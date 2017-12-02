// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_MRDMA_EG_din.v

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_MRDMA_EG_din (
   nvdla_core_clk               //|< i
  ,nvdla_core_rstn              //|< i
  ,cmd2dat_spt_pd               //|< i
  ,cmd2dat_spt_pvld             //|< i
  ,cvif2sdp_rd_rsp_pd           //|< i
  ,cvif2sdp_rd_rsp_valid        //|< i
  ,mcif2sdp_rd_rsp_pd           //|< i
  ,mcif2sdp_rd_rsp_valid        //|< i
  ,pfifo0_rd_prdy               //|< i
  ,pfifo1_rd_prdy               //|< i
  ,pfifo2_rd_prdy               //|< i
  ,pfifo3_rd_prdy               //|< i
  ,pwrbus_ram_pd                //|< i
  ,reg2dp_src_ram_type          //|< i
  ,sfifo0_rd_prdy               //|< i
  ,sfifo1_rd_prdy               //|< i
  ,cmd2dat_spt_prdy             //|> o
  ,cvif2sdp_rd_rsp_ready        //|> o
  ,mcif2sdp_rd_rsp_ready        //|> o
  ,pfifo0_rd_pd                 //|> o
  ,pfifo0_rd_pvld               //|> o
  ,pfifo1_rd_pd                 //|> o
  ,pfifo1_rd_pvld               //|> o
  ,pfifo2_rd_pd                 //|> o
  ,pfifo2_rd_pvld               //|> o
  ,pfifo3_rd_pd                 //|> o
  ,pfifo3_rd_pvld               //|> o
  ,sdp2cvif_rd_cdt_lat_fifo_pop //|> o
  ,sdp2mcif_rd_cdt_lat_fifo_pop //|> o
  ,sfifo0_rd_pd                 //|> o
  ,sfifo0_rd_pvld               //|> o
  ,sfifo1_rd_pd                 //|> o
  ,sfifo1_rd_pvld               //|> o
  );
//
// NV_NVDLA_SDP_MRDMA_EG_din_ports.v
//
input  nvdla_core_clk;   /* cmd2dat_spt, pfifo0_rd, pfifo1_rd, pfifo2_rd, pfifo3_rd, sfifo0_rd, sfifo1_rd, mcif2sdp_rd_rsp, cvif2sdp_rd_rsp, sdp2mcif_rd_cdt, sdp2cvif_rd_cdt */
input  nvdla_core_rstn;  /* cmd2dat_spt, pfifo0_rd, pfifo1_rd, pfifo2_rd, pfifo3_rd, sfifo0_rd, sfifo1_rd, mcif2sdp_rd_rsp, cvif2sdp_rd_rsp, sdp2mcif_rd_cdt, sdp2cvif_rd_cdt */

input         cmd2dat_spt_pvld;  /* data valid */
output        cmd2dat_spt_prdy;  /* data return handshake */
input  [12:0] cmd2dat_spt_pd;

output         pfifo0_rd_pvld;  /* data valid */
input          pfifo0_rd_prdy;  /* data return handshake */
output [127:0] pfifo0_rd_pd;

output         pfifo1_rd_pvld;  /* data valid */
input          pfifo1_rd_prdy;  /* data return handshake */
output [127:0] pfifo1_rd_pd;

output         pfifo2_rd_pvld;  /* data valid */
input          pfifo2_rd_prdy;  /* data return handshake */
output [127:0] pfifo2_rd_pd;

output         pfifo3_rd_pvld;  /* data valid */
input          pfifo3_rd_prdy;  /* data return handshake */
output [127:0] pfifo3_rd_pd;

output         sfifo0_rd_pvld;  /* data valid */
input          sfifo0_rd_prdy;  /* data return handshake */
output [255:0] sfifo0_rd_pd;

output         sfifo1_rd_pvld;  /* data valid */
input          sfifo1_rd_prdy;  /* data return handshake */
output [255:0] sfifo1_rd_pd;

input          mcif2sdp_rd_rsp_valid;  /* data valid */
output         mcif2sdp_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2sdp_rd_rsp_pd;

input          cvif2sdp_rd_rsp_valid;  /* data valid */
output         cvif2sdp_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2sdp_rd_rsp_pd;

output  sdp2mcif_rd_cdt_lat_fifo_pop;

output  sdp2cvif_rd_cdt_lat_fifo_pop;

input [31:0] pwrbus_ram_pd;

input          reg2dp_src_ram_type;
reg     [11:0] beat_cnt;
reg            lat_ecc_rd_prdy;
reg            sdp2cvif_rd_cdt_lat_fifo_pop;
reg            sdp2mcif_rd_cdt_lat_fifo_pop;
wire           cmd2dat_spt_primary;
wire    [11:0] cmd2dat_spt_size;
wire    [11:0] cmd_size;
wire   [513:0] cv_dma_rd_rsp_pd;
wire           cv_dma_rd_rsp_vld;
wire   [513:0] cv_int_rd_rsp_pd;
wire           cv_int_rd_rsp_ready;
wire           cv_int_rd_rsp_valid;
wire   [513:0] cvif2sdp_rd_rsp_pd_d0;
wire   [513:0] cvif2sdp_rd_rsp_pd_d1;
wire           cvif2sdp_rd_rsp_ready_d0;
wire           cvif2sdp_rd_rsp_ready_d1;
wire           cvif2sdp_rd_rsp_valid_d0;
wire           cvif2sdp_rd_rsp_valid_d1;
wire           dma_rd_cdt_lat_fifo_pop;
wire   [513:0] dma_rd_rsp_pd;
wire           dma_rd_rsp_ram_type;
wire           dma_rd_rsp_rdy;
wire           dma_rd_rsp_vld;
wire           is_last_beat;
wire           lat_ecc_rd_accept;
wire   [511:0] lat_ecc_rd_data;
wire     [1:0] lat_ecc_rd_mask;
wire   [513:0] lat_ecc_rd_pd;
wire           lat_ecc_rd_pvld;
wire           lat_rd_mask0_vld;
wire           lat_rd_mask1_vld;
wire   [513:0] mc_dma_rd_rsp_pd;
wire           mc_dma_rd_rsp_vld;
wire   [513:0] mc_int_rd_rsp_pd;
wire           mc_int_rd_rsp_ready;
wire           mc_int_rd_rsp_valid;
wire   [513:0] mcif2sdp_rd_rsp_pd_d0;
wire   [513:0] mcif2sdp_rd_rsp_pd_d1;
wire           mcif2sdp_rd_rsp_ready_d0;
wire           mcif2sdp_rd_rsp_ready_d1;
wire           mcif2sdp_rd_rsp_valid_d0;
wire           mcif2sdp_rd_rsp_valid_d1;
wire   [127:0] pfifo0_wr_pd;
wire           pfifo0_wr_prdy;
wire           pfifo0_wr_pvld;
wire   [127:0] pfifo1_wr_pd;
wire           pfifo1_wr_prdy;
wire           pfifo1_wr_pvld;
wire   [127:0] pfifo2_wr_pd;
wire           pfifo2_wr_prdy;
wire           pfifo2_wr_pvld;
wire   [127:0] pfifo3_wr_pd;
wire           pfifo3_wr_prdy;
wire           pfifo3_wr_pvld;
wire   [255:0] sfifo0_wr_pd;
wire           sfifo0_wr_prdy;
wire           sfifo0_wr_pvld;
wire   [255:0] sfifo1_wr_pd;
wire           sfifo1_wr_prdy;
wire           sfifo1_wr_pvld;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//==============
// Status Generation: idle/busy/process/done/etc
//==============
// CFG
//assign cfg_di_int8  = reg2dp_in_precision == NVDLA_GENERIC_PRECISION_ENUM_INT8;
//assign cfg_di_int16 = reg2dp_in_precision == NVDLA_GENERIC_PRECISION_ENUM_INT16;
//assign cfg_do_int8  = reg2dp_proc_precision == NVDLA_GENERIC_PRECISION_ENUM_INT8;
//assign cfg_do_int16 = reg2dp_proc_precision == NVDLA_GENERIC_PRECISION_ENUM_INT16;
//
//assign cfg_mode_16to8 = cfg_di_int16 & cfg_do_int8;

//==============
// DMA Interface
//==============
assign dma_rd_rsp_ram_type     = reg2dp_src_ram_type;
assign dma_rd_cdt_lat_fifo_pop = lat_ecc_rd_pvld & lat_ecc_rd_prdy;
// rd Channel: Response

assign mcif2sdp_rd_rsp_valid_d0 = mcif2sdp_rd_rsp_valid;
assign mcif2sdp_rd_rsp_ready = mcif2sdp_rd_rsp_ready_d0;
assign mcif2sdp_rd_rsp_pd_d0[513:0] = mcif2sdp_rd_rsp_pd[513:0];
NV_NVDLA_SDP_MRDMA_EG_DIN_pipe_p1 pipe_p1 (
   .nvdla_core_clk           (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)              //|< i
  ,.mcif2sdp_rd_rsp_pd_d0    (mcif2sdp_rd_rsp_pd_d0[513:0]) //|< w
  ,.mcif2sdp_rd_rsp_ready_d1 (mcif2sdp_rd_rsp_ready_d1)     //|< w
  ,.mcif2sdp_rd_rsp_valid_d0 (mcif2sdp_rd_rsp_valid_d0)     //|< w
  ,.mcif2sdp_rd_rsp_pd_d1    (mcif2sdp_rd_rsp_pd_d1[513:0]) //|> w
  ,.mcif2sdp_rd_rsp_ready_d0 (mcif2sdp_rd_rsp_ready_d0)     //|> w
  ,.mcif2sdp_rd_rsp_valid_d1 (mcif2sdp_rd_rsp_valid_d1)     //|> w
  );
assign mc_int_rd_rsp_valid = mcif2sdp_rd_rsp_valid_d1;
assign mcif2sdp_rd_rsp_ready_d1 = mc_int_rd_rsp_ready;
assign mc_int_rd_rsp_pd[513:0] = mcif2sdp_rd_rsp_pd_d1[513:0];


assign cvif2sdp_rd_rsp_valid_d0 = cvif2sdp_rd_rsp_valid;
assign cvif2sdp_rd_rsp_ready = cvif2sdp_rd_rsp_ready_d0;
assign cvif2sdp_rd_rsp_pd_d0[513:0] = cvif2sdp_rd_rsp_pd[513:0];
NV_NVDLA_SDP_MRDMA_EG_DIN_pipe_p2 pipe_p2 (
   .nvdla_core_clk           (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)              //|< i
  ,.cvif2sdp_rd_rsp_pd_d0    (cvif2sdp_rd_rsp_pd_d0[513:0]) //|< w
  ,.cvif2sdp_rd_rsp_ready_d1 (cvif2sdp_rd_rsp_ready_d1)     //|< w
  ,.cvif2sdp_rd_rsp_valid_d0 (cvif2sdp_rd_rsp_valid_d0)     //|< w
  ,.cvif2sdp_rd_rsp_pd_d1    (cvif2sdp_rd_rsp_pd_d1[513:0]) //|> w
  ,.cvif2sdp_rd_rsp_ready_d0 (cvif2sdp_rd_rsp_ready_d0)     //|> w
  ,.cvif2sdp_rd_rsp_valid_d1 (cvif2sdp_rd_rsp_valid_d1)     //|> w
  );
assign cv_int_rd_rsp_valid = cvif2sdp_rd_rsp_valid_d1;
assign cvif2sdp_rd_rsp_ready_d1 = cv_int_rd_rsp_ready;
assign cv_int_rd_rsp_pd[513:0] = cvif2sdp_rd_rsp_pd_d1[513:0];

NV_NVDLA_SDP_MRDMA_EG_DIN_pipe_p3 pipe_p3 (
   .nvdla_core_clk           (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)              //|< i
  ,.dma_rd_rsp_rdy           (dma_rd_rsp_rdy)               //|< w
  ,.mc_int_rd_rsp_pd         (mc_int_rd_rsp_pd[513:0])      //|< w
  ,.mc_int_rd_rsp_valid      (mc_int_rd_rsp_valid)          //|< w
  ,.mc_dma_rd_rsp_pd         (mc_dma_rd_rsp_pd[513:0])      //|> w
  ,.mc_dma_rd_rsp_vld        (mc_dma_rd_rsp_vld)            //|> w
  ,.mc_int_rd_rsp_ready      (mc_int_rd_rsp_ready)          //|> w
  );
NV_NVDLA_SDP_MRDMA_EG_DIN_pipe_p4 pipe_p4 (
   .nvdla_core_clk           (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)              //|< i
  ,.cv_int_rd_rsp_pd         (cv_int_rd_rsp_pd[513:0])      //|< w
  ,.cv_int_rd_rsp_valid      (cv_int_rd_rsp_valid)          //|< w
  ,.dma_rd_rsp_rdy           (dma_rd_rsp_rdy)               //|< w
  ,.cv_dma_rd_rsp_pd         (cv_dma_rd_rsp_pd[513:0])      //|> w
  ,.cv_dma_rd_rsp_vld        (cv_dma_rd_rsp_vld)            //|> w
  ,.cv_int_rd_rsp_ready      (cv_int_rd_rsp_ready)          //|> w
  );
assign dma_rd_rsp_vld = mc_dma_rd_rsp_vld | cv_dma_rd_rsp_vld;
assign dma_rd_rsp_pd = ({514{mc_dma_rd_rsp_vld}} & mc_dma_rd_rsp_pd) 
                        | ({514{cv_dma_rd_rsp_vld}} & cv_dma_rd_rsp_pd);

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
  // VCS coverage off 
  nv_assert_never #(0,0,"DMAIF: mcif and cvif should never return data both")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, mc_dma_rd_rsp_vld & cv_dma_rd_rsp_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
    sdp2mcif_rd_cdt_lat_fifo_pop <= 1'b0;
  end else begin
  sdp2mcif_rd_cdt_lat_fifo_pop <= dma_rd_cdt_lat_fifo_pop & (dma_rd_rsp_ram_type == 1'b1);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp2cvif_rd_cdt_lat_fifo_pop <= 1'b0;
  end else begin
  sdp2cvif_rd_cdt_lat_fifo_pop <= dma_rd_cdt_lat_fifo_pop & (dma_rd_rsp_ram_type == 1'b0);
  end
end

//==============
// Latency FIFO to buffer return DATA
//==============
    NV_NVDLA_SDP_MRDMA_EG_lat_fifo u_lat_fifo (
       .nvdla_core_clk           (nvdla_core_clk)               //|< i
      ,.nvdla_core_rstn          (nvdla_core_rstn)              //|< i
      ,.lat_wr_prdy              (dma_rd_rsp_rdy)               //|> w
      ,.lat_wr_pvld              (dma_rd_rsp_vld)               //|< w
      ,.lat_wr_pd                (dma_rd_rsp_pd[513:0])         //|< w
      ,.lat_rd_prdy              (lat_ecc_rd_prdy)              //|< r
      ,.lat_rd_pvld              (lat_ecc_rd_pvld)              //|> w
      ,.lat_rd_pd                (lat_ecc_rd_pd[513:0])         //|> w
      ,.pwrbus_ram_pd            (pwrbus_ram_pd[31:0])          //|< i
      );

assign lat_ecc_rd_accept = lat_ecc_rd_pvld & lat_ecc_rd_prdy;
//==================================

// PKT_UNPACK_WIRE( dma_read_data , lat_ecc_rd_ , lat_ecc_rd_pd )
assign       lat_ecc_rd_data[511:0] =    lat_ecc_rd_pd[511:0];
assign       lat_ecc_rd_mask[1:0] =    lat_ecc_rd_pd[513:512];
// lat_ecc_rd_mask | lat_ecc_rd_data

assign lat_rd_mask0_vld = lat_ecc_rd_pvld & lat_ecc_rd_mask[0];
assign lat_rd_mask1_vld = lat_ecc_rd_pvld & lat_ecc_rd_mask[1];

//==================================
// CMD2DAT UNPACK
//assign cmd_accept = cmd2dat_spt_pvld & cmd2dat_spt_prdy;
assign cmd2dat_spt_prdy = lat_ecc_rd_accept & is_last_beat;

// PKT_UNPACK_WIRE( sdp_mrdma_eg_spt , cmd2dat_spt_ , cmd2dat_spt_pd )
assign       cmd2dat_spt_size[11:0] =    cmd2dat_spt_pd[11:0];
assign        cmd2dat_spt_primary  =    cmd2dat_spt_pd[12];
// cmd_size | cmd_primary
assign cmd_size = {12 {cmd2dat_spt_pvld}} & cmd2dat_spt_size;

//==================================
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
            lat_ecc_rd_prdy = (!lat_rd_mask0_vld || (pfifo0_wr_prdy & pfifo1_wr_prdy)) 
                            & (!lat_rd_mask1_vld || (pfifo2_wr_prdy & pfifo3_wr_prdy));
        end else begin
            lat_ecc_rd_prdy = (!lat_rd_mask0_vld || (sfifo0_wr_prdy)) 
                            & (!lat_rd_mask1_vld || (sfifo1_wr_prdy));
        end
    end else begin
        lat_ecc_rd_prdy = 1'b0;
    end
end

//==================================
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    beat_cnt <= {12{1'b0}};
  end else begin
    if (lat_ecc_rd_accept) begin
        if (is_last_beat) begin
            beat_cnt <= 0;
        end else begin
            beat_cnt <= beat_cnt + 1;
        end
    end
  end
end
assign is_last_beat = (beat_cnt==cmd_size);

//==================================
// FIFO WRITE
assign pfifo0_wr_pvld = cmd2dat_spt_pvld & cmd2dat_spt_primary & lat_rd_mask0_vld & pfifo1_wr_prdy & (!lat_ecc_rd_mask[1] || (pfifo2_wr_prdy & pfifo3_wr_prdy));
assign pfifo1_wr_pvld = cmd2dat_spt_pvld & cmd2dat_spt_primary & lat_rd_mask0_vld & pfifo0_wr_prdy & (!lat_ecc_rd_mask[1] || (pfifo2_wr_prdy & pfifo3_wr_prdy));
assign pfifo2_wr_pvld = cmd2dat_spt_pvld & cmd2dat_spt_primary & lat_rd_mask1_vld & pfifo3_wr_prdy & (!lat_ecc_rd_mask[0] || (pfifo0_wr_prdy & pfifo1_wr_prdy));
assign pfifo3_wr_pvld = cmd2dat_spt_pvld & cmd2dat_spt_primary & lat_rd_mask1_vld & pfifo2_wr_prdy & (!lat_ecc_rd_mask[0] || (pfifo0_wr_prdy & pfifo1_wr_prdy));

assign sfifo0_wr_pvld = cmd2dat_spt_pvld & (!cmd2dat_spt_primary) & lat_rd_mask0_vld & (!lat_ecc_rd_mask[1] || (sfifo1_wr_prdy ));
assign sfifo1_wr_pvld = cmd2dat_spt_pvld & (!cmd2dat_spt_primary) & lat_rd_mask1_vld & (!lat_ecc_rd_mask[1] || (sfifo0_wr_prdy ));

assign pfifo0_wr_pd = lat_ecc_rd_data[127:0];
assign pfifo1_wr_pd = lat_ecc_rd_data[255:128];
assign pfifo2_wr_pd = lat_ecc_rd_data[383:256];
assign pfifo3_wr_pd = lat_ecc_rd_data[511:384];
assign sfifo0_wr_pd = lat_ecc_rd_data[255:0];
assign sfifo1_wr_pd = lat_ecc_rd_data[511:256];

//==================================
// FIFO INSTANCE
NV_NVDLA_SDP_MRDMA_EG_pfifo u_pfifo0 (
   .nvdla_core_clk           (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)              //|< i
  ,.pfifo_wr_prdy            (pfifo0_wr_prdy)               //|> w
  ,.pfifo_wr_pvld            (pfifo0_wr_pvld)               //|< w
  ,.pfifo_wr_pd              (pfifo0_wr_pd[127:0])          //|< w
  ,.pfifo_rd_prdy            (pfifo0_rd_prdy)               //|< i
  ,.pfifo_rd_pvld            (pfifo0_rd_pvld)               //|> o
  ,.pfifo_rd_pd              (pfifo0_rd_pd[127:0])          //|> o
  ,.pwrbus_ram_pd            (pwrbus_ram_pd[31:0])          //|< i
  );
NV_NVDLA_SDP_MRDMA_EG_pfifo u_pfifo1 (
   .nvdla_core_clk           (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)              //|< i
  ,.pfifo_wr_prdy            (pfifo1_wr_prdy)               //|> w
  ,.pfifo_wr_pvld            (pfifo1_wr_pvld)               //|< w
  ,.pfifo_wr_pd              (pfifo1_wr_pd[127:0])          //|< w
  ,.pfifo_rd_prdy            (pfifo1_rd_prdy)               //|< i
  ,.pfifo_rd_pvld            (pfifo1_rd_pvld)               //|> o
  ,.pfifo_rd_pd              (pfifo1_rd_pd[127:0])          //|> o
  ,.pwrbus_ram_pd            (pwrbus_ram_pd[31:0])          //|< i
  );
NV_NVDLA_SDP_MRDMA_EG_pfifo u_pfifo2 (
   .nvdla_core_clk           (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)              //|< i
  ,.pfifo_wr_prdy            (pfifo2_wr_prdy)               //|> w
  ,.pfifo_wr_pvld            (pfifo2_wr_pvld)               //|< w
  ,.pfifo_wr_pd              (pfifo2_wr_pd[127:0])          //|< w
  ,.pfifo_rd_prdy            (pfifo2_rd_prdy)               //|< i
  ,.pfifo_rd_pvld            (pfifo2_rd_pvld)               //|> o
  ,.pfifo_rd_pd              (pfifo2_rd_pd[127:0])          //|> o
  ,.pwrbus_ram_pd            (pwrbus_ram_pd[31:0])          //|< i
  );
NV_NVDLA_SDP_MRDMA_EG_pfifo u_pfifo3 (
   .nvdla_core_clk           (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)              //|< i
  ,.pfifo_wr_prdy            (pfifo3_wr_prdy)               //|> w
  ,.pfifo_wr_pvld            (pfifo3_wr_pvld)               //|< w
  ,.pfifo_wr_pd              (pfifo3_wr_pd[127:0])          //|< w
  ,.pfifo_rd_prdy            (pfifo3_rd_prdy)               //|< i
  ,.pfifo_rd_pvld            (pfifo3_rd_pvld)               //|> o
  ,.pfifo_rd_pd              (pfifo3_rd_pd[127:0])          //|> o
  ,.pwrbus_ram_pd            (pwrbus_ram_pd[31:0])          //|< i
  );

NV_NVDLA_SDP_MRDMA_EG_sfifo u_sfifo0 (
   .nvdla_core_clk           (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)              //|< i
  ,.sfifo_wr_prdy            (sfifo0_wr_prdy)               //|> w
  ,.sfifo_wr_pvld            (sfifo0_wr_pvld)               //|< w
  ,.sfifo_wr_pd              (sfifo0_wr_pd[255:0])          //|< w
  ,.sfifo_rd_prdy            (sfifo0_rd_prdy)               //|< i
  ,.sfifo_rd_pvld            (sfifo0_rd_pvld)               //|> o
  ,.sfifo_rd_pd              (sfifo0_rd_pd[255:0])          //|> o
  ,.pwrbus_ram_pd            (pwrbus_ram_pd[31:0])          //|< i
  );
NV_NVDLA_SDP_MRDMA_EG_sfifo u_sfifo1 (
   .nvdla_core_clk           (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)              //|< i
  ,.sfifo_wr_prdy            (sfifo1_wr_prdy)               //|> w
  ,.sfifo_wr_pvld            (sfifo1_wr_pvld)               //|< w
  ,.sfifo_wr_pd              (sfifo1_wr_pd[255:0])          //|< w
  ,.sfifo_rd_prdy            (sfifo1_rd_prdy)               //|< i
  ,.sfifo_rd_pvld            (sfifo1_rd_pvld)               //|> o
  ,.sfifo_rd_pd              (sfifo1_rd_pd[255:0])          //|> o
  ,.pwrbus_ram_pd            (pwrbus_ram_pd[31:0])          //|< i
  );

//==================================
// OBS
//assign obs_bus_sdp_mrdma_eg_dat_lat_fifo_rd_pvld = lat_rd_pvld;  
//assign obs_bus_sdp_mrdma_eg_dat_lat_fifo_rd_prdy = lat_rd_prdy;
//assign obs_bus_sdp_mrdma_eg_dat_lat_fifo_wr_pvld = lat_wr_pvld; 
//assign obs_bus_sdp_mrdma_eg_dat_lat_fifo_wr_prdy = lat_wr_prdy; 
//assign obs_bus_sdp_mrdma_eg_mcif_rd_rsp_ready    = mcif2sdp_rd_rsp_ready;
//assign obs_bus_sdp_mrdma_eg_mcif_rd_rsp_valid    = mcif2sdp_rd_rsp_valid;  
//assign obs_bus_sdp_mrdma_eg_cvif_rd_rsp_ready    = cvif2sdp_rd_rsp_ready;  
//assign obs_bus_sdp_mrdma_eg_cvif_rd_rsp_valid    = cvif2sdp_rd_rsp_valid; 

endmodule // NV_NVDLA_SDP_MRDMA_EG_din



// **************************************************************************************************************
// Generated by ::pipe -m -bc -os -rand none mcif2sdp_rd_rsp_pd_d1[513:0] (mcif2sdp_rd_rsp_valid_d1,mcif2sdp_rd_rsp_ready_d1) <= mcif2sdp_rd_rsp_pd_d0[513:0] (mcif2sdp_rd_rsp_valid_d0,mcif2sdp_rd_rsp_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_SDP_MRDMA_EG_DIN_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,mcif2sdp_rd_rsp_pd_d0
  ,mcif2sdp_rd_rsp_ready_d1
  ,mcif2sdp_rd_rsp_valid_d0
  ,mcif2sdp_rd_rsp_pd_d1
  ,mcif2sdp_rd_rsp_ready_d0
  ,mcif2sdp_rd_rsp_valid_d1
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] mcif2sdp_rd_rsp_pd_d0;
input          mcif2sdp_rd_rsp_ready_d1;
input          mcif2sdp_rd_rsp_valid_d0;
output [513:0] mcif2sdp_rd_rsp_pd_d1;
output         mcif2sdp_rd_rsp_ready_d0;
output         mcif2sdp_rd_rsp_valid_d1;
reg    [513:0] mcif2sdp_rd_rsp_pd_d1;
reg            mcif2sdp_rd_rsp_ready_d0;
reg            mcif2sdp_rd_rsp_valid_d1;
reg    [513:0] p1_pipe_data;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg    [513:0] p1_pipe_skid_data;
reg            p1_pipe_skid_ready;
reg            p1_pipe_skid_valid;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg    [513:0] p1_skid_data;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
//## pipe (1) valid-ready-bubble-collapse
always @(
  p1_pipe_ready
  or p1_pipe_valid
  ) begin
  p1_pipe_ready_bc = p1_pipe_ready || !p1_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_valid <= 1'b0;
  end else begin
  p1_pipe_valid <= (p1_pipe_ready_bc)? mcif2sdp_rd_rsp_valid_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && mcif2sdp_rd_rsp_valid_d0)? mcif2sdp_rd_rsp_pd_d0[513:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  mcif2sdp_rd_rsp_ready_d0 = p1_pipe_ready_bc;
end
//## pipe (1) skid buffer
always @(
  p1_pipe_valid
  or p1_skid_ready_flop
  or p1_pipe_skid_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_valid && p1_skid_ready_flop && !p1_pipe_skid_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_pipe_skid_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_pipe_skid_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_valid
  or p1_skid_valid
  or p1_pipe_data
  or p1_skid_data
  ) begin
  p1_pipe_skid_valid = (p1_skid_ready_flop)? p1_pipe_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_pipe_skid_data = (p1_skid_ready_flop)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (1) output
always @(
  p1_pipe_skid_valid
  or mcif2sdp_rd_rsp_ready_d1
  or p1_pipe_skid_data
  ) begin
  mcif2sdp_rd_rsp_valid_d1 = p1_pipe_skid_valid;
  p1_pipe_skid_ready = mcif2sdp_rd_rsp_ready_d1;
  mcif2sdp_rd_rsp_pd_d1[513:0] = p1_pipe_skid_data;
end
//## pipe (1) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p1_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2sdp_rd_rsp_valid_d1^mcif2sdp_rd_rsp_ready_d1^mcif2sdp_rd_rsp_valid_d0^mcif2sdp_rd_rsp_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_3x (nvdla_core_clk, `ASSERT_RESET, (mcif2sdp_rd_rsp_valid_d0 && !mcif2sdp_rd_rsp_ready_d0), (mcif2sdp_rd_rsp_valid_d0), (mcif2sdp_rd_rsp_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`endif
endmodule // NV_NVDLA_SDP_MRDMA_EG_DIN_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os -rand none cvif2sdp_rd_rsp_pd_d1[513:0] (cvif2sdp_rd_rsp_valid_d1,cvif2sdp_rd_rsp_ready_d1) <= cvif2sdp_rd_rsp_pd_d0[513:0] (cvif2sdp_rd_rsp_valid_d0,cvif2sdp_rd_rsp_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_SDP_MRDMA_EG_DIN_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cvif2sdp_rd_rsp_pd_d0
  ,cvif2sdp_rd_rsp_ready_d1
  ,cvif2sdp_rd_rsp_valid_d0
  ,cvif2sdp_rd_rsp_pd_d1
  ,cvif2sdp_rd_rsp_ready_d0
  ,cvif2sdp_rd_rsp_valid_d1
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] cvif2sdp_rd_rsp_pd_d0;
input          cvif2sdp_rd_rsp_ready_d1;
input          cvif2sdp_rd_rsp_valid_d0;
output [513:0] cvif2sdp_rd_rsp_pd_d1;
output         cvif2sdp_rd_rsp_ready_d0;
output         cvif2sdp_rd_rsp_valid_d1;
reg    [513:0] cvif2sdp_rd_rsp_pd_d1;
reg            cvif2sdp_rd_rsp_ready_d0;
reg            cvif2sdp_rd_rsp_valid_d1;
reg    [513:0] p2_pipe_data;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg    [513:0] p2_pipe_skid_data;
reg            p2_pipe_skid_ready;
reg            p2_pipe_skid_valid;
reg            p2_pipe_valid;
reg            p2_skid_catch;
reg    [513:0] p2_skid_data;
reg            p2_skid_ready;
reg            p2_skid_ready_flop;
reg            p2_skid_valid;
//## pipe (2) valid-ready-bubble-collapse
always @(
  p2_pipe_ready
  or p2_pipe_valid
  ) begin
  p2_pipe_ready_bc = p2_pipe_ready || !p2_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? cvif2sdp_rd_rsp_valid_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && cvif2sdp_rd_rsp_valid_d0)? cvif2sdp_rd_rsp_pd_d0[513:0] : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  cvif2sdp_rd_rsp_ready_d0 = p2_pipe_ready_bc;
end
//## pipe (2) skid buffer
always @(
  p2_pipe_valid
  or p2_skid_ready_flop
  or p2_pipe_skid_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = p2_pipe_valid && p2_skid_ready_flop && !p2_pipe_skid_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_pipe_skid_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    p2_pipe_ready <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_pipe_skid_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  p2_pipe_ready <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? p2_pipe_data : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or p2_pipe_valid
  or p2_skid_valid
  or p2_pipe_data
  or p2_skid_data
  ) begin
  p2_pipe_skid_valid = (p2_skid_ready_flop)? p2_pipe_valid : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_pipe_skid_data = (p2_skid_ready_flop)? p2_pipe_data : p2_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (2) output
always @(
  p2_pipe_skid_valid
  or cvif2sdp_rd_rsp_ready_d1
  or p2_pipe_skid_data
  ) begin
  cvif2sdp_rd_rsp_valid_d1 = p2_pipe_skid_valid;
  p2_pipe_skid_ready = cvif2sdp_rd_rsp_ready_d1;
  cvif2sdp_rd_rsp_pd_d1[513:0] = p2_pipe_skid_data;
end
//## pipe (2) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p2_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cvif2sdp_rd_rsp_valid_d1^cvif2sdp_rd_rsp_ready_d1^cvif2sdp_rd_rsp_valid_d0^cvif2sdp_rd_rsp_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_5x (nvdla_core_clk, `ASSERT_RESET, (cvif2sdp_rd_rsp_valid_d0 && !cvif2sdp_rd_rsp_ready_d0), (cvif2sdp_rd_rsp_valid_d0), (cvif2sdp_rd_rsp_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`endif
endmodule // NV_NVDLA_SDP_MRDMA_EG_DIN_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os mc_dma_rd_rsp_pd (mc_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= mc_int_rd_rsp_pd[513:0] (mc_int_rd_rsp_valid,mc_int_rd_rsp_ready)
// **************************************************************************************************************
module NV_NVDLA_SDP_MRDMA_EG_DIN_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma_rd_rsp_rdy
  ,mc_int_rd_rsp_pd
  ,mc_int_rd_rsp_valid
  ,mc_dma_rd_rsp_pd
  ,mc_dma_rd_rsp_vld
  ,mc_int_rd_rsp_ready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          dma_rd_rsp_rdy;
input  [513:0] mc_int_rd_rsp_pd;
input          mc_int_rd_rsp_valid;
output [513:0] mc_dma_rd_rsp_pd;
output         mc_dma_rd_rsp_vld;
output         mc_int_rd_rsp_ready;
reg    [513:0] mc_dma_rd_rsp_pd;
reg            mc_dma_rd_rsp_vld;
reg            mc_int_rd_rsp_ready;
reg    [513:0] p3_pipe_data;
reg    [513:0] p3_pipe_rand_data;
reg            p3_pipe_rand_ready;
reg            p3_pipe_rand_valid;
reg            p3_pipe_ready;
reg            p3_pipe_ready_bc;
reg    [513:0] p3_pipe_skid_data;
reg            p3_pipe_skid_ready;
reg            p3_pipe_skid_valid;
reg            p3_pipe_valid;
reg            p3_skid_catch;
reg    [513:0] p3_skid_data;
reg            p3_skid_ready;
reg            p3_skid_ready_flop;
reg            p3_skid_valid;
//## pipe (3) randomizer
`ifndef SYNTHESIS
reg p3_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p3_pipe_rand_active
  or 
     `endif
     mc_int_rd_rsp_valid
  or p3_pipe_rand_ready
  or mc_int_rd_rsp_pd
  ) begin
  `ifdef SYNTHESIS
  p3_pipe_rand_valid = mc_int_rd_rsp_valid;
  mc_int_rd_rsp_ready = p3_pipe_rand_ready;
  p3_pipe_rand_data = mc_int_rd_rsp_pd[513:0];
  `else
  // VCS coverage off
  p3_pipe_rand_valid = (p3_pipe_rand_active)? 1'b0 : mc_int_rd_rsp_valid;
  mc_int_rd_rsp_ready = (p3_pipe_rand_active)? 1'b0 : p3_pipe_rand_ready;
  p3_pipe_rand_data = (p3_pipe_rand_active)?  'bx : mc_int_rd_rsp_pd[513:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p3_pipe_stall_cycles;
integer p3_pipe_stall_probability;
integer p3_pipe_stall_cycles_min;
integer p3_pipe_stall_cycles_max;
initial begin
  p3_pipe_stall_cycles = 0;
  p3_pipe_stall_probability = 0;
  p3_pipe_stall_cycles_min = 1;
  p3_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_stall_probability" ) ) p3_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_stall_cycles_min"  ) ) p3_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_stall_cycles_max"  ) ) p3_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p3_pipe_rand_enable;
reg p3_pipe_rand_poised;
always @(
  p3_pipe_stall_cycles
  or p3_pipe_stall_probability
  or mc_int_rd_rsp_valid
  ) begin
  p3_pipe_rand_active = p3_pipe_stall_cycles != 0;
  p3_pipe_rand_enable = p3_pipe_stall_probability != 0;
  p3_pipe_rand_poised = p3_pipe_rand_enable && !p3_pipe_rand_active && mc_int_rd_rsp_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p3_pipe_rand_poised) begin
    if (p3_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p3_pipe_stall_cycles <= prand_inst1(p3_pipe_stall_cycles_min, p3_pipe_stall_cycles_max);
    end
  end else if (p3_pipe_rand_active) begin
    p3_pipe_stall_cycles <= p3_pipe_stall_cycles - 1;
  end else begin
    p3_pipe_stall_cycles <= 0;
  end
  end
end

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

`endif
// VCS coverage on
//## pipe (3) valid-ready-bubble-collapse
always @(
  p3_pipe_ready
  or p3_pipe_valid
  ) begin
  p3_pipe_ready_bc = p3_pipe_ready || !p3_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_valid <= 1'b0;
  end else begin
  p3_pipe_valid <= (p3_pipe_ready_bc)? p3_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && p3_pipe_rand_valid)? p3_pipe_rand_data : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  p3_pipe_rand_ready = p3_pipe_ready_bc;
end
//## pipe (3) skid buffer
always @(
  p3_pipe_valid
  or p3_skid_ready_flop
  or p3_pipe_skid_ready
  or p3_skid_valid
  ) begin
  p3_skid_catch = p3_pipe_valid && p3_skid_ready_flop && !p3_pipe_skid_ready;  
  p3_skid_ready = (p3_skid_valid)? p3_pipe_skid_ready : !p3_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_skid_valid <= 1'b0;
    p3_skid_ready_flop <= 1'b1;
    p3_pipe_ready <= 1'b1;
  end else begin
  p3_skid_valid <= (p3_skid_valid)? !p3_pipe_skid_ready : p3_skid_catch;
  p3_skid_ready_flop <= p3_skid_ready;
  p3_pipe_ready <= p3_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_skid_data <= (p3_skid_catch)? p3_pipe_data : p3_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p3_skid_ready_flop
  or p3_pipe_valid
  or p3_skid_valid
  or p3_pipe_data
  or p3_skid_data
  ) begin
  p3_pipe_skid_valid = (p3_skid_ready_flop)? p3_pipe_valid : p3_skid_valid; 
  // VCS sop_coverage_off start
  p3_pipe_skid_data = (p3_skid_ready_flop)? p3_pipe_data : p3_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (3) output
always @(
  p3_pipe_skid_valid
  or dma_rd_rsp_rdy
  or p3_pipe_skid_data
  ) begin
  mc_dma_rd_rsp_vld = p3_pipe_skid_valid;
  p3_pipe_skid_ready = dma_rd_rsp_rdy;
  mc_dma_rd_rsp_pd = p3_pipe_skid_data;
end
//## pipe (3) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p3_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_dma_rd_rsp_vld^dma_rd_rsp_rdy^mc_int_rd_rsp_valid^mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_7x (nvdla_core_clk, `ASSERT_RESET, (mc_int_rd_rsp_valid && !mc_int_rd_rsp_ready), (mc_int_rd_rsp_valid), (mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`endif
endmodule // NV_NVDLA_SDP_MRDMA_EG_DIN_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os cv_dma_rd_rsp_pd (cv_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= cv_int_rd_rsp_pd[513:0] (cv_int_rd_rsp_valid,cv_int_rd_rsp_ready)
// **************************************************************************************************************
module NV_NVDLA_SDP_MRDMA_EG_DIN_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cv_int_rd_rsp_pd
  ,cv_int_rd_rsp_valid
  ,dma_rd_rsp_rdy
  ,cv_dma_rd_rsp_pd
  ,cv_dma_rd_rsp_vld
  ,cv_int_rd_rsp_ready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] cv_int_rd_rsp_pd;
input          cv_int_rd_rsp_valid;
input          dma_rd_rsp_rdy;
output [513:0] cv_dma_rd_rsp_pd;
output         cv_dma_rd_rsp_vld;
output         cv_int_rd_rsp_ready;
reg    [513:0] cv_dma_rd_rsp_pd;
reg            cv_dma_rd_rsp_vld;
reg            cv_int_rd_rsp_ready;
reg    [513:0] p4_pipe_data;
reg    [513:0] p4_pipe_rand_data;
reg            p4_pipe_rand_ready;
reg            p4_pipe_rand_valid;
reg            p4_pipe_ready;
reg            p4_pipe_ready_bc;
reg    [513:0] p4_pipe_skid_data;
reg            p4_pipe_skid_ready;
reg            p4_pipe_skid_valid;
reg            p4_pipe_valid;
reg            p4_skid_catch;
reg    [513:0] p4_skid_data;
reg            p4_skid_ready;
reg            p4_skid_ready_flop;
reg            p4_skid_valid;
//## pipe (4) randomizer
`ifndef SYNTHESIS
reg p4_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p4_pipe_rand_active
  or 
     `endif
     cv_int_rd_rsp_valid
  or p4_pipe_rand_ready
  or cv_int_rd_rsp_pd
  ) begin
  `ifdef SYNTHESIS
  p4_pipe_rand_valid = cv_int_rd_rsp_valid;
  cv_int_rd_rsp_ready = p4_pipe_rand_ready;
  p4_pipe_rand_data = cv_int_rd_rsp_pd[513:0];
  `else
  // VCS coverage off
  p4_pipe_rand_valid = (p4_pipe_rand_active)? 1'b0 : cv_int_rd_rsp_valid;
  cv_int_rd_rsp_ready = (p4_pipe_rand_active)? 1'b0 : p4_pipe_rand_ready;
  p4_pipe_rand_data = (p4_pipe_rand_active)?  'bx : cv_int_rd_rsp_pd[513:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p4_pipe_stall_cycles;
integer p4_pipe_stall_probability;
integer p4_pipe_stall_cycles_min;
integer p4_pipe_stall_cycles_max;
initial begin
  p4_pipe_stall_cycles = 0;
  p4_pipe_stall_probability = 0;
  p4_pipe_stall_cycles_min = 1;
  p4_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_stall_probability" ) ) p4_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_stall_cycles_min"  ) ) p4_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_din_pipe_stall_cycles_max"  ) ) p4_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p4_pipe_rand_enable;
reg p4_pipe_rand_poised;
always @(
  p4_pipe_stall_cycles
  or p4_pipe_stall_probability
  or cv_int_rd_rsp_valid
  ) begin
  p4_pipe_rand_active = p4_pipe_stall_cycles != 0;
  p4_pipe_rand_enable = p4_pipe_stall_probability != 0;
  p4_pipe_rand_poised = p4_pipe_rand_enable && !p4_pipe_rand_active && cv_int_rd_rsp_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p4_pipe_rand_poised) begin
    if (p4_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p4_pipe_stall_cycles <= prand_inst1(p4_pipe_stall_cycles_min, p4_pipe_stall_cycles_max);
    end
  end else if (p4_pipe_rand_active) begin
    p4_pipe_stall_cycles <= p4_pipe_stall_cycles - 1;
  end else begin
    p4_pipe_stall_cycles <= 0;
  end
  end
end

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

`endif
// VCS coverage on
//## pipe (4) valid-ready-bubble-collapse
always @(
  p4_pipe_ready
  or p4_pipe_valid
  ) begin
  p4_pipe_ready_bc = p4_pipe_ready || !p4_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_valid <= 1'b0;
  end else begin
  p4_pipe_valid <= (p4_pipe_ready_bc)? p4_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && p4_pipe_rand_valid)? p4_pipe_rand_data : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  p4_pipe_rand_ready = p4_pipe_ready_bc;
end
//## pipe (4) skid buffer
always @(
  p4_pipe_valid
  or p4_skid_ready_flop
  or p4_pipe_skid_ready
  or p4_skid_valid
  ) begin
  p4_skid_catch = p4_pipe_valid && p4_skid_ready_flop && !p4_pipe_skid_ready;  
  p4_skid_ready = (p4_skid_valid)? p4_pipe_skid_ready : !p4_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_skid_valid <= 1'b0;
    p4_skid_ready_flop <= 1'b1;
    p4_pipe_ready <= 1'b1;
  end else begin
  p4_skid_valid <= (p4_skid_valid)? !p4_pipe_skid_ready : p4_skid_catch;
  p4_skid_ready_flop <= p4_skid_ready;
  p4_pipe_ready <= p4_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_skid_data <= (p4_skid_catch)? p4_pipe_data : p4_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p4_skid_ready_flop
  or p4_pipe_valid
  or p4_skid_valid
  or p4_pipe_data
  or p4_skid_data
  ) begin
  p4_pipe_skid_valid = (p4_skid_ready_flop)? p4_pipe_valid : p4_skid_valid; 
  // VCS sop_coverage_off start
  p4_pipe_skid_data = (p4_skid_ready_flop)? p4_pipe_data : p4_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (4) output
always @(
  p4_pipe_skid_valid
  or dma_rd_rsp_rdy
  or p4_pipe_skid_data
  ) begin
  cv_dma_rd_rsp_vld = p4_pipe_skid_valid;
  p4_pipe_skid_ready = dma_rd_rsp_rdy;
  cv_dma_rd_rsp_pd = p4_pipe_skid_data;
end
//## pipe (4) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p4_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_dma_rd_rsp_vld^dma_rd_rsp_rdy^cv_int_rd_rsp_valid^cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_9x (nvdla_core_clk, `ASSERT_RESET, (cv_int_rd_rsp_valid && !cv_int_rd_rsp_ready), (cv_int_rd_rsp_valid), (cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`endif
endmodule // NV_NVDLA_SDP_MRDMA_EG_DIN_pipe_p4


//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_SDP_MRDMA_EG_lat_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus lat_wr -rd_pipebus lat_rd -rd_reg -d 80 -w 514 -ram ra2 [Chosen ram type: ra2 - ramgen_generic (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


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
                if ( prand_inst2(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst3(stall_cycles_min, stall_cycles_max);
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
reg [47:0] prand_local_seed2;
reg prand_initialized2;
reg prand_no_rollpli2;
`endif
`endif
`endif

function [31:0] prand_inst2;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst2 = min;
`else
`ifdef SYNTHESIS
        prand_inst2 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized2 !== 1'b1) begin
            prand_no_rollpli2 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli2)
                prand_local_seed2 = {$prand_get_seed(2), 16'b0};
            prand_initialized2 = 1'b1;
        end
        if (prand_no_rollpli2) begin
            prand_inst2 = min;
        end else begin
            diff = max - min + 1;
            prand_inst2 = min + prand_local_seed2[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed2 = prand_local_seed2 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst2 = min;
`else
        prand_inst2 = $RollPLI(min, max, "auto");
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
reg [47:0] prand_local_seed3;
reg prand_initialized3;
reg prand_no_rollpli3;
`endif
`endif
`endif

function [31:0] prand_inst3;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst3 = min;
`else
`ifdef SYNTHESIS
        prand_inst3 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized3 !== 1'b1) begin
            prand_no_rollpli3 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli3)
                prand_local_seed3 = {$prand_get_seed(3), 16'b0};
            prand_initialized3 = 1'b1;
        end
        if (prand_no_rollpli3) begin
            prand_inst3 = min;
        end else begin
            diff = max - min + 1;
            prand_inst3 = min + prand_local_seed3[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed3 = prand_local_seed3 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst3 = min;
`else
        prand_inst3 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


endmodule // NV_NVDLA_SDP_MRDMA_EG_lat_fifo



// Re-Order Primary FIFo
// if we have rd_reg, then depth = required - 1 ,so depth=4-1=3
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_SDP_MRDMA_EG_pfifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus pfifo_wr -rd_pipebus pfifo_rd -rd_reg -rand_none -ram_bypass -d 3 -w 128 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_MRDMA_EG_pfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , pfifo_wr_prdy
    , pfifo_wr_pvld
    , pfifo_wr_pd
    , pfifo_rd_prdy
    , pfifo_rd_pvld
    , pfifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        pfifo_wr_prdy;
input         pfifo_wr_pvld;
input  [127:0] pfifo_wr_pd;
input         pfifo_rd_prdy;
output        pfifo_rd_pvld;
output [127:0] pfifo_rd_pd;
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
reg        pfifo_wr_busy_int;		        	// copy for internal use
assign     pfifo_wr_prdy = !pfifo_wr_busy_int;
assign       wr_reserving = pfifo_wr_pvld && !pfifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [1:0] pfifo_wr_count;			// write-side count

wire [1:0] wr_count_next_wr_popping = wr_reserving ? pfifo_wr_count : (pfifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [1:0] wr_count_next_no_wr_popping = wr_reserving ? (pfifo_wr_count + 1'd1) : pfifo_wr_count; // spyglass disable W164a W484
wire [1:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_3 = ( wr_count_next_no_wr_popping == 2'd3 );
wire wr_count_next_is_3 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_3;
wire [1:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [1:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       pfifo_wr_busy_next = wr_count_next_is_3 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check pfifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        pfifo_wr_busy_int <=  1'b0;
        pfifo_wr_count <=  2'd0;
    end else begin
	pfifo_wr_busy_int <=  pfifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    pfifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            pfifo_wr_count <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as pfifo_wr_pvld

//
// RAM
//

reg  [1:0] pfifo_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        pfifo_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    pfifo_wr_adr <=  (pfifo_wr_adr == 2'd2) ? 2'd0 : (pfifo_wr_adr + 1'd1);
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] pfifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (pfifo_wr_count > 2'd0 || !rd_popping);   // note: write occurs next cycle
wire [127:0] pfifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_MRDMA_EG_pfifo_flopram_rwsa_3x128 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( pfifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( pfifo_wr_adr )
    , .ra        ( (pfifo_wr_count == 0) ? 2'd3 : pfifo_rd_adr )
    , .dout        ( pfifo_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = (pfifo_rd_adr == 2'd2) ? 2'd0 : (pfifo_rd_adr + 1'd1); // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        pfifo_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    pfifo_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            pfifo_rd_adr <=  {2{`x_or_0}};
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

wire       pfifo_rd_pvld_p; 		// data out of fifo is valid

reg        pfifo_rd_pvld_int;	// internal copy of pfifo_rd_pvld
assign     pfifo_rd_pvld = pfifo_rd_pvld_int;
assign     rd_popping = pfifo_rd_pvld_p && !(pfifo_rd_pvld_int && !pfifo_rd_prdy);

reg  [1:0] pfifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [1:0] rd_count_p_next_rd_popping = rd_pushing ? pfifo_rd_count_p : 
                                                                (pfifo_rd_count_p - 1'd1);
wire [1:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (pfifo_rd_count_p + 1'd1) : 
                                                                    pfifo_rd_count_p;
// spyglass enable_block W164a W484
wire [1:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     pfifo_rd_pvld_p = pfifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        pfifo_rd_count_p <=  2'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    pfifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            pfifo_rd_count_p <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [127:0]  pfifo_rd_pd;         // output data register
wire        rd_req_next = (pfifo_rd_pvld_p || (pfifo_rd_pvld_int && !pfifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        pfifo_rd_pvld_int <=  1'b0;
    end else begin
        pfifo_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        pfifo_rd_pd <=  pfifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        pfifo_rd_pd <=  {128{`x_or_0}};
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (pfifo_wr_pvld && !pfifo_wr_busy_int) || (pfifo_wr_busy_int != pfifo_wr_busy_next)) || (rd_pushing || rd_popping || (pfifo_rd_pvld_int && pfifo_rd_prdy)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_MRDMA_EG_pfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_MRDMA_EG_pfifo_wr_limit : 2'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 2'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 2'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 2'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [1:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 2'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_pfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_pfifo_wr_limit=%d", wr_limit_override_value);
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
    , .max      ( {30'd0, (wr_limit_reg == 2'd0) ? 2'd3 : wr_limit_reg} )
    , .curr	( {30'd0, pfifo_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_MRDMA_EG_pfifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_MRDMA_EG_pfifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_MRDMA_EG_pfifo_flopram_rwsa_3x128 (
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
input  [127:0] di;
input  we;
input  [1:0] wa;
input  [1:0] ra;
output [127:0] dout;

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


`ifdef EMU


wire [127:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [127:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_SDP_MRDMA_EG_pfifo_flopram_rwsa_3x128 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 3) ? di : dout_p;

`else

reg [127:0] ram_ff0;
reg [127:0] ram_ff1;
reg [127:0] ram_ff2;

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
end

reg [127:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = ram_ff2;
    2'd3:       dout = di;
    //VCS coverage off
    default:    dout = {128{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_SDP_MRDMA_EG_pfifo_flopram_rwsa_3x128

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_SDP_MRDMA_EG_pfifo_flopram_rwsa_3x128 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [127:0] Di0;
input  [1:0] Ra0;
output [127:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 128'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [127:0] mem[2:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [127:0] Q0 = mem[0];
wire [127:0] Q1 = mem[1];
wire [127:0] Q2 = mem[2];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_SDP_MRDMA_EG_pfifo_flopram_rwsa_3x128] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_SDP_MRDMA_EG_pfifo_flopram_rwsa_3x128] }
endmodule // vmw_NV_NVDLA_SDP_MRDMA_EG_pfifo_flopram_rwsa_3x128

//vmw: Memory vmw_NV_NVDLA_SDP_MRDMA_EG_pfifo_flopram_rwsa_3x128
//vmw: Address-size 2
//vmw: Data-size 128
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[127:0] data0[127:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[127:0] data1[127:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_SDP_MRDMA_EG_pfifo_flopram_rwsa_3x128
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

// Re-Order Secondary FIFo, for 16-to-8 only
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_SDP_MRDMA_EG_sfifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus sfifo_wr -rd_pipebus sfifo_rd -rd_reg -rand_none -ram_bypass -d 1 -w 256 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


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

