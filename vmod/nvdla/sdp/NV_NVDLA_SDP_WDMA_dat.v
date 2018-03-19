// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_WDMA_dat.v

#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_WDMA_dat (
   cmd2dat_dma_pd               //|< i
  ,cmd2dat_dma_pvld             //|< i
  ,cmd2dat_spt_pd               //|< i
  ,cmd2dat_spt_pvld             //|< i
  ,dma_wr_req_rdy               //|< i
  ,nvdla_core_clk               //|< i
  ,nvdla_core_rstn              //|< i
  ,op_load                      //|< i
  ,pwrbus_ram_pd                //|< i
  ,reg2dp_batch_number          //|< i
  ,reg2dp_ew_alu_algo           //|< i
  ,reg2dp_ew_alu_bypass         //|< i
  ,reg2dp_ew_bypass             //|< i
  ,reg2dp_height                //|< i
  ,reg2dp_interrupt_ptr         //|< i
  ,reg2dp_out_precision         //|< i
  ,reg2dp_output_dst            //|< i
  ,reg2dp_proc_precision        //|< i
  ,reg2dp_width                 //|< i
  ,reg2dp_winograd              //|< i
  ,sdp_dp2wdma_pd               //|< i
  ,sdp_dp2wdma_valid            //|< i
  ,cmd2dat_dma_prdy             //|> o
  ,cmd2dat_spt_prdy             //|> o
  ,dma_wr_req_pd                //|> o
  ,dma_wr_req_vld               //|> o
  ,dp2reg_done                  //|> o
  ,dp2reg_status_nan_output_num //|> o
  ,dp2reg_status_unequal        //|> o
  ,intr_req_ptr                 //|> o
  ,intr_req_pvld                //|> o
  ,sdp_dp2wdma_ready            //|> o
  );
//
// NV_NVDLA_SDP_WDMA_dat_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         cmd2dat_dma_pvld;  
output        cmd2dat_dma_prdy;  
input  [SDP_WR_CMD_DW+1:0] cmd2dat_dma_pd;

input         cmd2dat_spt_pvld;  
output        cmd2dat_spt_prdy;  
input  [14:0] cmd2dat_spt_pd;

input          sdp_dp2wdma_valid;  
output         sdp_dp2wdma_ready;  
input  [AM_DW-1:0] sdp_dp2wdma_pd;

input          dma_wr_req_rdy;
input          op_load;
input   [31:0] pwrbus_ram_pd;
input    [4:0] reg2dp_batch_number;
input    [1:0] reg2dp_ew_alu_algo;
input          reg2dp_ew_alu_bypass;
input          reg2dp_ew_bypass;
input   [12:0] reg2dp_height;
input          reg2dp_interrupt_ptr;
input    [1:0] reg2dp_out_precision;
input          reg2dp_output_dst;
input    [1:0] reg2dp_proc_precision;
input   [12:0] reg2dp_width;
input          reg2dp_winograd;
output [NVDLA_DMA_WR_REQ-1:0] dma_wr_req_pd;
output         dma_wr_req_vld;
output         dp2reg_done;
output  [31:0] dp2reg_status_nan_output_num;
output         dp2reg_status_unequal;
output         intr_req_ptr;
output         intr_req_pvld;
wire   [AM_DW-1:0] dfifo0_rd_pd;
wire           dfifo0_rd_prdy;
wire           dfifo0_rd_pvld;
wire   [AM_DW-1:0] dfifo1_rd_pd;
wire           dfifo1_rd_prdy;
wire           dfifo1_rd_pvld;
wire   [AM_DW-1:0] dfifo2_rd_pd;
wire           dfifo2_rd_prdy;
wire           dfifo2_rd_pvld;
wire   [AM_DW-1:0] dfifo3_rd_pd;
wire           dfifo3_rd_prdy;
wire           dfifo3_rd_pvld;

NV_NVDLA_SDP_WDMA_DAT_in u_in (
   .nvdla_core_clk               (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn              (nvdla_core_rstn)                    //|< i
  ,.cmd2dat_spt_pvld             (cmd2dat_spt_pvld)                   //|< i
  ,.cmd2dat_spt_prdy             (cmd2dat_spt_prdy)                   //|> o
  ,.cmd2dat_spt_pd               (cmd2dat_spt_pd[14:0])               //|< i
  ,.sdp_dp2wdma_valid            (sdp_dp2wdma_valid)                  //|< i
  ,.sdp_dp2wdma_ready            (sdp_dp2wdma_ready)                  //|> o
  ,.sdp_dp2wdma_pd               (sdp_dp2wdma_pd[AM_DW-1:0])              //|< i
  ,.dfifo0_rd_pvld               (dfifo0_rd_pvld)                     //|> w
  ,.dfifo0_rd_prdy               (dfifo0_rd_prdy)                     //|< w
  ,.dfifo0_rd_pd                 (dfifo0_rd_pd[AM_DW-1:0])                //|> w
  ,.dfifo1_rd_pvld               (dfifo1_rd_pvld)                     //|> w
  ,.dfifo1_rd_prdy               (dfifo1_rd_prdy)                     //|< w
  ,.dfifo1_rd_pd                 (dfifo1_rd_pd[AM_DW-1:0])                //|> w
  ,.dfifo2_rd_pvld               (dfifo2_rd_pvld)                     //|> w
  ,.dfifo2_rd_prdy               (dfifo2_rd_prdy)                     //|< w
  ,.dfifo2_rd_pd                 (dfifo2_rd_pd[AM_DW-1:0])                //|> w
  ,.dfifo3_rd_pvld               (dfifo3_rd_pvld)                     //|> w
  ,.dfifo3_rd_prdy               (dfifo3_rd_prdy)                     //|< w
  ,.dfifo3_rd_pd                 (dfifo3_rd_pd[AM_DW-1:0])                //|> w
  ,.reg2dp_batch_number          (reg2dp_batch_number[4:0])           //|< i
  ,.reg2dp_height                (reg2dp_height[12:0])                //|< i
  ,.reg2dp_out_precision         (reg2dp_out_precision[1:0])          //|< i
  ,.reg2dp_proc_precision        (reg2dp_proc_precision[1:0])         //|< i
  ,.reg2dp_width                 (reg2dp_width[12:0])                 //|< i
  ,.reg2dp_winograd              (reg2dp_winograd)                    //|< i
  ,.dp2reg_status_nan_output_num (dp2reg_status_nan_output_num[31:0]) //|> o
  ,.pwrbus_ram_pd                (pwrbus_ram_pd[31:0])                //|< i
  ,.op_load                      (op_load)                            //|< i
  );
NV_NVDLA_SDP_WDMA_DAT_out u_out (
   .nvdla_core_clk               (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn              (nvdla_core_rstn)                    //|< i
  ,.cmd2dat_dma_pvld             (cmd2dat_dma_pvld)                   //|< i
  ,.cmd2dat_dma_prdy             (cmd2dat_dma_prdy)                   //|> o
  ,.cmd2dat_dma_pd               (cmd2dat_dma_pd[SDP_WR_CMD_DW+1:0])               //|< i
  ,.dfifo0_rd_pvld               (dfifo0_rd_pvld)                     //|< w
  ,.dfifo0_rd_prdy               (dfifo0_rd_prdy)                     //|> w
  ,.dfifo0_rd_pd                 (dfifo0_rd_pd[AM_DW-1:0])                //|< w
  ,.dfifo1_rd_pvld               (dfifo1_rd_pvld)                     //|< w
  ,.dfifo1_rd_prdy               (dfifo1_rd_prdy)                     //|> w
  ,.dfifo1_rd_pd                 (dfifo1_rd_pd[AM_DW-1:0])                //|< w
  ,.dfifo2_rd_pvld               (dfifo2_rd_pvld)                     //|< w
  ,.dfifo2_rd_prdy               (dfifo2_rd_prdy)                     //|> w
  ,.dfifo2_rd_pd                 (dfifo2_rd_pd[AM_DW-1:0])                //|< w
  ,.dfifo3_rd_pvld               (dfifo3_rd_pvld)                     //|< w
  ,.dfifo3_rd_prdy               (dfifo3_rd_prdy)                     //|> w
  ,.dfifo3_rd_pd                 (dfifo3_rd_pd[AM_DW-1:0])                //|< w
  ,.op_load                      (op_load)                            //|< i
  ,.reg2dp_batch_number          (reg2dp_batch_number[4:0])           //|< i
  ,.reg2dp_ew_alu_algo           (reg2dp_ew_alu_algo[1:0])            //|< i
  ,.reg2dp_ew_alu_bypass         (reg2dp_ew_alu_bypass)               //|< i
  ,.reg2dp_ew_bypass             (reg2dp_ew_bypass)                   //|< i
  ,.reg2dp_height                (reg2dp_height[12:0])                //|< i
  ,.reg2dp_interrupt_ptr         (reg2dp_interrupt_ptr)               //|< i
  ,.reg2dp_out_precision         (reg2dp_out_precision[1:0])          //|< i
  ,.reg2dp_output_dst            (reg2dp_output_dst)                  //|< i
  ,.reg2dp_proc_precision        (reg2dp_proc_precision[1:0])         //|< i
  ,.reg2dp_width                 (reg2dp_width[12:0])                 //|< i
  ,.reg2dp_winograd              (reg2dp_winograd)                    //|< i
  ,.dp2reg_done                  (dp2reg_done)                        //|> o
  ,.dp2reg_status_unequal        (dp2reg_status_unequal)              //|> o
  ,.dma_wr_req_rdy               (dma_wr_req_rdy)                     //|< i
  ,.dma_wr_req_pd                (dma_wr_req_pd[NVDLA_DMA_WR_REQ-1:0])               //|> o
  ,.dma_wr_req_vld               (dma_wr_req_vld)                     //|> o
  ,.intr_req_ptr                 (intr_req_ptr)                       //|> o
  ,.intr_req_pvld                (intr_req_pvld)                      //|> o
  );

endmodule // NV_NVDLA_SDP_WDMA_dat

