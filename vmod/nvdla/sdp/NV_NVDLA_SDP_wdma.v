// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_wdma.v

#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_wdma (
   nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,pwrbus_ram_pd                 //|< i
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,reg2dp_batch_number           //|< i
  ,reg2dp_channel                //|< i
  ,reg2dp_dst_base_addr_high     //|< i
  ,reg2dp_dst_base_addr_low      //|< i
  ,reg2dp_dst_batch_stride       //|< i
  ,reg2dp_dst_line_stride        //|< i
  ,reg2dp_dst_ram_type           //|< i
  ,reg2dp_dst_surface_stride     //|< i
  ,reg2dp_ew_alu_algo            //|< i
  ,reg2dp_ew_alu_bypass          //|< i
  ,reg2dp_ew_bypass              //|< i
  ,reg2dp_height                 //|< i
  ,reg2dp_interrupt_ptr          //|< i
  ,reg2dp_op_en                  //|< i
  ,reg2dp_out_precision          //|< i
  ,reg2dp_output_dst             //|< i
  ,reg2dp_perf_dma_en            //|< i
  ,reg2dp_proc_precision         //|< i
  ,reg2dp_wdma_slcg_op_en        //|< i
  ,reg2dp_width                  //|< i
  ,reg2dp_winograd               //|< i
  ,dp2reg_done                   //|> o
  ,dp2reg_status_nan_output_num  //|> o
  ,dp2reg_status_unequal         //|> o
  ,dp2reg_wdma_stall             //|> o
  ,sdp_dp2wdma_pd                //|< i
  ,sdp_dp2wdma_valid             //|< i
  ,sdp_dp2wdma_ready             //|> o
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,sdp2cvif_wr_req_pd            //|> o
  ,sdp2cvif_wr_req_valid         //|> o
  ,sdp2cvif_wr_req_ready         //|< i
  ,cvif2sdp_wr_rsp_complete      //|< i
  #endif
  ,sdp2mcif_wr_req_pd            //|> o
  ,sdp2mcif_wr_req_valid         //|> o
  ,sdp2mcif_wr_req_ready         //|< i
  ,mcif2sdp_wr_rsp_complete      //|< i
  ,sdp2glb_done_intr_pd          //|> o
  );
//
// NV_NVDLA_SDP_wdma_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output         sdp2cvif_wr_req_valid;  
input          sdp2cvif_wr_req_ready;  
output [NVDLA_DMA_WR_REQ-1:0] sdp2cvif_wr_req_pd;     
input          cvif2sdp_wr_rsp_complete;
#endif

output [1:0]   sdp2glb_done_intr_pd;

output         sdp2mcif_wr_req_valid;  
input          sdp2mcif_wr_req_ready;  
output [NVDLA_DMA_WR_REQ-1:0] sdp2mcif_wr_req_pd;     
input          mcif2sdp_wr_rsp_complete;

input          sdp_dp2wdma_valid;  
output         sdp_dp2wdma_ready;  
input  [DP_DOUT_DW-1:0] sdp_dp2wdma_pd;

input          dla_clk_ovr_on_sync;
input          global_clk_ovr_on_sync;
input   [31:0] pwrbus_ram_pd;
input    [4:0] reg2dp_batch_number;
input   [12:0] reg2dp_channel;
input   [31:0] reg2dp_dst_base_addr_high;
input   [31-AM_AW:0] reg2dp_dst_base_addr_low;
input   [31-AM_AW:0] reg2dp_dst_batch_stride;
input   [31-AM_AW:0] reg2dp_dst_line_stride;
input          reg2dp_dst_ram_type;
input   [31-AM_AW:0] reg2dp_dst_surface_stride;
input    [1:0] reg2dp_ew_alu_algo;
input          reg2dp_ew_alu_bypass;
input          reg2dp_ew_bypass;
input   [12:0] reg2dp_height;
input          reg2dp_interrupt_ptr;
input          reg2dp_op_en;
input    [1:0] reg2dp_out_precision;
input          reg2dp_output_dst;
input          reg2dp_perf_dma_en;
input    [1:0] reg2dp_proc_precision;
input          reg2dp_wdma_slcg_op_en;
input   [12:0] reg2dp_width;
input          reg2dp_winograd;
input          tmc2slcg_disable_clock_gating;
output         dp2reg_done;
output  [31:0] dp2reg_status_nan_output_num;
output         dp2reg_status_unequal;
output  [31:0] dp2reg_wdma_stall;
reg            processing;
wire    [SDP_WR_CMD_DW+1:0] cmd2dat_dma_pd;
wire           cmd2dat_dma_prdy;
wire           cmd2dat_dma_pvld;
wire    [14:0] cmd2dat_spt_pd;
wire           cmd2dat_spt_prdy;
wire           cmd2dat_spt_pvld;
wire   [NVDLA_DMA_WR_REQ-1:0] dma_wr_req_pd;
wire           dma_wr_req_rdy;
wire           dma_wr_req_type;
wire           dma_wr_req_vld;
wire           dma_wr_rsp_complete;
wire           intr_req_ptr;
wire           intr_req_pvld;
wire           nvdla_gated_clk;
wire           op_load;


//==============
// Start Processing
//==============
assign op_load = reg2dp_op_en & !processing;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    processing <= 1'b0;
  end else begin
    if (op_load) begin
        processing <= 1'b1;
    end else if (dp2reg_done) begin
        processing <= 1'b0;
    end
  end
end

NV_NVDLA_SDP_WDMA_gate u_gate (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)                //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)             //|< i
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)      //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                    //|< i
  ,.reg2dp_wdma_slcg_op_en        (reg2dp_wdma_slcg_op_en)             //|< i
  ,.nvdla_gated_clk               (nvdla_gated_clk)                    //|> w
  );

NV_NVDLA_SDP_WDMA_cmd u_cmd (
   .nvdla_core_clk                (nvdla_gated_clk)                    //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                    //|< i
  ,.cmd2dat_spt_pvld              (cmd2dat_spt_pvld)                   //|> w
  ,.cmd2dat_spt_prdy              (cmd2dat_spt_prdy)                   //|< w
  ,.cmd2dat_spt_pd                (cmd2dat_spt_pd[14:0])               //|> w
  ,.cmd2dat_dma_pvld              (cmd2dat_dma_pvld)                   //|> w
  ,.cmd2dat_dma_prdy              (cmd2dat_dma_prdy)                   //|< w
  ,.cmd2dat_dma_pd                (cmd2dat_dma_pd[SDP_WR_CMD_DW+1:0])               //|> w
  ,.reg2dp_batch_number           (reg2dp_batch_number[4:0])           //|< i
  ,.reg2dp_channel                (reg2dp_channel[12:0])               //|< i
  ,.reg2dp_dst_base_addr_high     (reg2dp_dst_base_addr_high[31:0])    //|< i
  ,.reg2dp_dst_base_addr_low      (reg2dp_dst_base_addr_low[31-AM_AW:0])     //|< i
  ,.reg2dp_dst_batch_stride       (reg2dp_dst_batch_stride[31-AM_AW:0])      //|< i
  ,.reg2dp_dst_line_stride        (reg2dp_dst_line_stride[31-AM_AW:0])       //|< i
  ,.reg2dp_dst_surface_stride     (reg2dp_dst_surface_stride[31-AM_AW:0])    //|< i
  ,.reg2dp_ew_alu_algo            (reg2dp_ew_alu_algo[1:0])            //|< i
  ,.reg2dp_ew_alu_bypass          (reg2dp_ew_alu_bypass)               //|< i
  ,.reg2dp_ew_bypass              (reg2dp_ew_bypass)                   //|< i
  ,.reg2dp_height                 (reg2dp_height[12:0])                //|< i
  ,.reg2dp_out_precision          (reg2dp_out_precision[1:0])          //|< i
  ,.reg2dp_output_dst             (reg2dp_output_dst)                  //|< i
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])         //|< i
  ,.reg2dp_width                  (reg2dp_width[12:0])                 //|< i
  ,.reg2dp_winograd               (reg2dp_winograd)                    //|< i
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])                //|< i
  ,.op_load                       (op_load)                            //|< w
  );

NV_NVDLA_SDP_WDMA_dat u_dat (
   .nvdla_core_clk                (nvdla_gated_clk)                    //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                    //|< i
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])                //|< i
  ,.op_load                       (op_load)                            //|< w
  ,.cmd2dat_dma_pvld              (cmd2dat_dma_pvld)                   //|< w
  ,.cmd2dat_dma_prdy              (cmd2dat_dma_prdy)                   //|> w
  ,.cmd2dat_dma_pd                (cmd2dat_dma_pd[SDP_WR_CMD_DW+1:0])               //|< w
  ,.cmd2dat_spt_pvld              (cmd2dat_spt_pvld)                   //|< w
  ,.cmd2dat_spt_prdy              (cmd2dat_spt_prdy)                   //|> w
  ,.cmd2dat_spt_pd                (cmd2dat_spt_pd[14:0])               //|< w
  ,.sdp_dp2wdma_valid             (sdp_dp2wdma_valid)                  //|< i
  ,.sdp_dp2wdma_ready             (sdp_dp2wdma_ready)                  //|> o
  ,.sdp_dp2wdma_pd                (sdp_dp2wdma_pd[DP_DOUT_DW-1:0])     //|< i
  ,.dma_wr_req_rdy                (dma_wr_req_rdy)                     //|< w
  ,.dma_wr_req_pd                 (dma_wr_req_pd[NVDLA_DMA_WR_REQ-1:0])               //|> w
  ,.dma_wr_req_vld                (dma_wr_req_vld)                     //|> w
  ,.reg2dp_batch_number           (reg2dp_batch_number[4:0])           //|< i
  ,.reg2dp_ew_alu_algo            (reg2dp_ew_alu_algo[1:0])            //|< i
  ,.reg2dp_ew_alu_bypass          (reg2dp_ew_alu_bypass)               //|< i
  ,.reg2dp_ew_bypass              (reg2dp_ew_bypass)                   //|< i
  ,.reg2dp_height                 (reg2dp_height[12:0])                //|< i
  ,.reg2dp_interrupt_ptr          (reg2dp_interrupt_ptr)               //|< i
  ,.reg2dp_out_precision          (reg2dp_out_precision[1:0])          //|< i
  ,.reg2dp_output_dst             (reg2dp_output_dst)                  //|< i
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])         //|< i
  ,.reg2dp_width                  (reg2dp_width[12:0])                 //|< i
  ,.reg2dp_winograd               (reg2dp_winograd)                    //|< i
  ,.dp2reg_done                   (dp2reg_done)                        //|> o
  ,.dp2reg_status_nan_output_num  (dp2reg_status_nan_output_num[31:0]) //|> o
  ,.dp2reg_status_unequal         (dp2reg_status_unequal)              //|> o
  ,.intr_req_ptr                  (intr_req_ptr)                       //|> w
  ,.intr_req_pvld                 (intr_req_pvld)                      //|> w
  );

NV_NVDLA_DMAIF_wr    u_dmaif_wr(
   .nvdla_core_clk                (nvdla_core_clk)            //fixme         
  ,.nvdla_core_rstn               (nvdla_core_rstn)                    
  ,.reg2dp_dst_ram_type           (reg2dp_dst_ram_type)
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cvif_wr_req_pd                (sdp2cvif_wr_req_pd)
  ,.cvif_wr_req_valid             (sdp2cvif_wr_req_valid)
  ,.cvif_wr_req_ready             (sdp2cvif_wr_req_ready)
  ,.cvif_wr_rsp_complete          (cvif2sdp_wr_rsp_complete)
  #endif
  ,.mcif_wr_req_pd                (sdp2mcif_wr_req_pd)
  ,.mcif_wr_req_valid             (sdp2mcif_wr_req_valid)
  ,.mcif_wr_req_ready             (sdp2mcif_wr_req_ready)
  ,.mcif_wr_rsp_complete          (mcif2sdp_wr_rsp_complete)
  ,.dmaif_wr_req_pd               (dma_wr_req_pd)
  ,.dmaif_wr_req_pvld             (dma_wr_req_vld)
  ,.dmaif_wr_req_prdy             (dma_wr_req_rdy)
  ,.dmaif_wr_rsp_complete         (dma_wr_rsp_complete )
);

NV_NVDLA_SDP_WDMA_intr  u_intr (
   .nvdla_core_clk                (nvdla_core_clk)                     
  ,.nvdla_core_rstn               (nvdla_core_rstn)                    
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])                
  ,.op_load                       (op_load)                            
  ,.reg2dp_ew_alu_algo            (reg2dp_ew_alu_algo[1:0])            
  ,.reg2dp_ew_alu_bypass          (reg2dp_ew_alu_bypass)               
  ,.reg2dp_ew_bypass              (reg2dp_ew_bypass)                   
  ,.reg2dp_op_en                  (reg2dp_op_en)                       
  ,.reg2dp_output_dst             (reg2dp_output_dst)                  
  ,.reg2dp_perf_dma_en            (reg2dp_perf_dma_en)                 
  ,.dp2reg_wdma_stall             (dp2reg_wdma_stall[31:0])            
  ,.dma_wr_req_vld                (dma_wr_req_vld)                     
  ,.dma_wr_req_rdy                (dma_wr_req_rdy)                     
  ,.dma_wr_rsp_complete           (dma_wr_rsp_complete )
  ,.intr_req_ptr                  (intr_req_ptr)                       
  ,.intr_req_pvld                 (intr_req_pvld)                      
  ,.sdp2glb_done_intr_pd          (sdp2glb_done_intr_pd[1:0])          
  );



endmodule // NV_NVDLA_SDP_wdma

