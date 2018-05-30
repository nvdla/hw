// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_mrdma.v

#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_mrdma (
   nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,pwrbus_ram_pd                 //|< i
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,mrdma_slcg_op_en              //|< i
  ,mrdma_disable                 //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE 
  ,sdp2cvif_rd_cdt_lat_fifo_pop  //|> o
  ,sdp2cvif_rd_req_pd            //|> o
  ,sdp2cvif_rd_req_valid         //|> o
  ,sdp2cvif_rd_req_ready         //|< i
  ,cvif2sdp_rd_rsp_pd            //|< i
  ,cvif2sdp_rd_rsp_valid         //|< i
  ,cvif2sdp_rd_rsp_ready         //|> o
#endif
  ,sdp2mcif_rd_cdt_lat_fifo_pop  //|> o
  ,sdp2mcif_rd_req_pd            //|> o
  ,sdp2mcif_rd_req_valid         //|> o
  ,sdp2mcif_rd_req_ready         //|< i
  ,mcif2sdp_rd_rsp_pd            //|< i
  ,mcif2sdp_rd_rsp_valid         //|< i
  ,mcif2sdp_rd_rsp_ready         //|> o
  ,sdp_mrdma2cmux_pd             //|> o
  ,sdp_mrdma2cmux_valid          //|> o
  ,sdp_mrdma2cmux_ready          //|< i
  ,reg2dp_op_en                  //|< i
  ,reg2dp_batch_number           //|< i
  ,reg2dp_channel                //|< i
  ,reg2dp_height                 //|< i
  ,reg2dp_width                  //|< i
  ,reg2dp_in_precision           //|< i
  ,reg2dp_proc_precision         //|< i
  ,reg2dp_src_ram_type           //|< i
  ,reg2dp_src_base_addr_high     //|< i
  ,reg2dp_src_base_addr_low      //|< i
  ,reg2dp_src_line_stride        //|< i
  ,reg2dp_src_surface_stride     //|< i
  ,reg2dp_perf_dma_en            //|< i
  ,reg2dp_perf_nan_inf_count_en  //|< i
  ,dp2reg_done                   //|> o
  ,dp2reg_mrdma_stall            //|> o
  ,dp2reg_status_inf_input_num   //|> o
  ,dp2reg_status_nan_input_num   //|> o
  );
 //
 // NV_NVDLA_SDP_mrdma_ports.v
 //
 input  nvdla_core_clk;   
 input  nvdla_core_rstn;  
 input [31:0] pwrbus_ram_pd;
 input          dla_clk_ovr_on_sync;
 input          global_clk_ovr_on_sync;
 input          tmc2slcg_disable_clock_gating;
 input          mrdma_disable;
 input          mrdma_slcg_op_en;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE 
 output         sdp2cvif_rd_req_valid;  
 input          sdp2cvif_rd_req_ready;  
 output [NVDLA_DMA_RD_REQ-1:0]  sdp2cvif_rd_req_pd;
 input          cvif2sdp_rd_rsp_valid;  
 output         cvif2sdp_rd_rsp_ready;  
 input  [NVDLA_DMA_RD_RSP-1:0] cvif2sdp_rd_rsp_pd;
 output  sdp2cvif_rd_cdt_lat_fifo_pop;
#endif

 output         sdp2mcif_rd_req_valid;  
 input          sdp2mcif_rd_req_ready;  
 output [NVDLA_DMA_RD_REQ-1:0]  sdp2mcif_rd_req_pd;
 input          mcif2sdp_rd_rsp_valid;  
 output         mcif2sdp_rd_rsp_ready;  
 input  [NVDLA_DMA_RD_RSP-1:0] mcif2sdp_rd_rsp_pd;
 output  sdp2mcif_rd_cdt_lat_fifo_pop;

 output         sdp_mrdma2cmux_valid;  
 input          sdp_mrdma2cmux_ready;  
 output [DP_DIN_DW+1:0] sdp_mrdma2cmux_pd;

 input          reg2dp_op_en;
 input    [4:0] reg2dp_batch_number;
 input   [12:0] reg2dp_channel;
 input   [12:0] reg2dp_height;
 input   [12:0] reg2dp_width;
 input    [1:0] reg2dp_in_precision;
 input    [1:0] reg2dp_proc_precision;
 input          reg2dp_src_ram_type;
 input   [31:0] reg2dp_src_base_addr_high;
 input   [31-AM_AW:0] reg2dp_src_base_addr_low;
 input   [31-AM_AW:0] reg2dp_src_line_stride;
 input   [31-AM_AW:0] reg2dp_src_surface_stride;
 input          reg2dp_perf_dma_en;
 input          reg2dp_perf_nan_inf_count_en;
 output         dp2reg_done;
 output  [31:0] dp2reg_mrdma_stall;
 output  [31:0] dp2reg_status_inf_input_num;
 output  [31:0] dp2reg_status_nan_input_num;

 reg            layer_process;
 wire           nvdla_gated_clk;
 wire           op_load;
 wire           eg_done;
 wire    [13:0] cq2eg_pd;
 wire           cq2eg_prdy;
 wire           cq2eg_pvld;
 wire    [13:0] ig2cq_pd;
 wire           ig2cq_prdy;
 wire           ig2cq_pvld;
 wire           dma_rd_cdt_lat_fifo_pop;
 wire    [NVDLA_DMA_RD_REQ-1:0] dma_rd_req_pd;
 wire           dma_rd_req_ram_type;
 wire           dma_rd_req_rdy;
 wire           dma_rd_req_vld;
 wire           dma_rd_rsp_ram_type;
 wire   [NVDLA_DMA_RD_RSP-1:0] dma_rd_rsp_pd;
 wire           dma_rd_rsp_rdy;
 wire           dma_rd_rsp_vld;

//==============
// Work Processing
//==============
assign op_load = reg2dp_op_en & ~layer_process;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    layer_process <= 1'b0;
  end else begin
    if (op_load) begin
        layer_process <= 1'b1;
    end else if (eg_done) begin
        layer_process <= 1'b0;
    end
  end
end
assign dp2reg_done = eg_done;


 //=======================================
 NV_NVDLA_SDP_MRDMA_gate u_gate (
    .nvdla_core_clk                (nvdla_core_clk)                    //|< i
   ,.nvdla_core_rstn               (nvdla_core_rstn)                   //|< i
   ,.dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)               //|< i
   ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)            //|< i
   ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)     //|< i
   ,.mrdma_slcg_op_en              (mrdma_slcg_op_en)                  //|< i
   ,.mrdma_disable                 (mrdma_disable)                     //|< i
   ,.nvdla_gated_clk               (nvdla_gated_clk)                   //|> w
   );

 //=======================================
 // Ingress: send read request to external mem
 //---------------------------------------
 NV_NVDLA_SDP_MRDMA_ig u_ig (
    .nvdla_core_clk                (nvdla_gated_clk)                   //|< w
   ,.nvdla_core_rstn               (nvdla_core_rstn)                   //|< i
   ,.op_load                       (op_load)                           //|< w
   ,.ig2cq_prdy                    (ig2cq_prdy)                        //|< w
   ,.ig2cq_pd                      (ig2cq_pd[13:0])                    //|> w
   ,.ig2cq_pvld                    (ig2cq_pvld)                        //|> w
   ,.dma_rd_req_rdy                (dma_rd_req_rdy)                    //|< w
   ,.dma_rd_req_pd                 (dma_rd_req_pd[NVDLA_DMA_RD_REQ-1:0])               //|> w
   ,.dma_rd_req_ram_type           (dma_rd_req_ram_type)               //|> w
   ,.dma_rd_req_vld                (dma_rd_req_vld)                    //|> w
   ,.reg2dp_batch_number           (reg2dp_batch_number[4:0])          //|< i
   ,.reg2dp_channel                (reg2dp_channel[12:0])              //|< i
   ,.reg2dp_height                 (reg2dp_height[12:0])               //|< i
   ,.reg2dp_width                  (reg2dp_width[12:0])                //|< i
   ,.reg2dp_in_precision           (reg2dp_in_precision[1:0])          //|< i
   ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])        //|< i
   ,.reg2dp_src_ram_type           (reg2dp_src_ram_type)               //|< i
   ,.reg2dp_src_base_addr_high     (reg2dp_src_base_addr_high[31:0])   //|< i
   ,.reg2dp_src_base_addr_low      (reg2dp_src_base_addr_low[31-AM_AW:0])    //|< i
   ,.reg2dp_src_line_stride        (reg2dp_src_line_stride[31-AM_AW:0])      //|< i
   ,.reg2dp_src_surface_stride     (reg2dp_src_surface_stride[31-AM_AW:0])   //|< i
   ,.reg2dp_perf_dma_en            (reg2dp_perf_dma_en)                //|< i
   ,.dp2reg_mrdma_stall            (dp2reg_mrdma_stall[31:0])          //|> o
   );


 //=======================================
 // Context Queue: trace outstanding req, and pass info from Ig to Eg
 //---------------------------------------
//: my $depth = (NVDLA_VMOD_SDP_MRDMA_LATENCY_FIFO_DEPTH < 16) ? 16 : NVDLA_VMOD_SDP_MRDMA_LATENCY_FIFO_DEPTH;
//: my $width = 14;
//: print "NV_NVDLA_SDP_MRDMA_cq_${depth}x${width}  u_cq ( \n";
    .nvdla_core_clk                (nvdla_gated_clk)                   //|< w
   ,.nvdla_core_rstn               (nvdla_core_rstn)                   //|< i
   ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])               //|< i
   ,.ig2cq_prdy                    (ig2cq_prdy)                        //|> w
   ,.ig2cq_pvld                    (ig2cq_pvld)                        //|< w
   ,.ig2cq_pd                      (ig2cq_pd[13:0])                    //|< w
   ,.cq2eg_prdy                    (cq2eg_prdy)                        //|< w
   ,.cq2eg_pvld                    (cq2eg_pvld)                        //|> w
   ,.cq2eg_pd                      (cq2eg_pd[13:0])                    //|> w
   );


 //=======================================
 // Egress: get return data from external mem
 //---------------------------------------
 NV_NVDLA_SDP_MRDMA_eg u_eg (
    .nvdla_core_clk                (nvdla_gated_clk)                   //|< w
   ,.nvdla_core_rstn               (nvdla_core_rstn)                   //|< i
   ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])               //|< i
   ,.op_load                       (op_load)                           //|< w
   ,.eg_done                       (eg_done)                           //|> w
   ,.cq2eg_pd                      (cq2eg_pd[13:0])                    //|< w
   ,.cq2eg_pvld                    (cq2eg_pvld)                        //|< w
   ,.cq2eg_prdy                    (cq2eg_prdy)                        //|> w
   ,.dma_rd_rsp_ram_type           (dma_rd_rsp_ram_type)               //|> w
   ,.dma_rd_rsp_pd                 (dma_rd_rsp_pd[NVDLA_DMA_RD_RSP-1:0])         //|< w
   ,.dma_rd_rsp_rdy                (dma_rd_rsp_rdy)               //|> w
   ,.dma_rd_rsp_vld                (dma_rd_rsp_vld)               //|< w
   ,.dma_rd_cdt_lat_fifo_pop       (dma_rd_cdt_lat_fifo_pop)           //|> w
   ,.sdp_mrdma2cmux_ready          (sdp_mrdma2cmux_ready)              //|< i
   ,.sdp_mrdma2cmux_pd             (sdp_mrdma2cmux_pd[DP_DIN_DW+1:0])          //|> o
   ,.sdp_mrdma2cmux_valid          (sdp_mrdma2cmux_valid)              //|> o
   ,.reg2dp_height                 (reg2dp_height[12:0])               //|< i
   ,.reg2dp_width                  (reg2dp_width[12:0])                //|< i
   ,.reg2dp_in_precision           (reg2dp_in_precision[1:0])          //|< i
   ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])        //|< i
   ,.reg2dp_src_ram_type           (reg2dp_src_ram_type)               //|< i
   ,.reg2dp_perf_nan_inf_count_en  (reg2dp_perf_nan_inf_count_en)      //|< i
   ,.dp2reg_status_inf_input_num   (dp2reg_status_inf_input_num[31:0]) //|> o
   ,.dp2reg_status_nan_input_num   (dp2reg_status_nan_input_num[31:0]) //|> o
   );
 

 NV_NVDLA_SDP_RDMA_dmaif u_NV_NVDLA_SDP_RDMA_dmaif (
    .nvdla_core_clk                (nvdla_gated_clk)                   //|< i
   ,.nvdla_core_rstn               (nvdla_core_rstn)                   //|< i         fixme
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE 
   ,.sdp2cvif_rd_cdt_lat_fifo_pop  (sdp2cvif_rd_cdt_lat_fifo_pop)      //|> o
   ,.sdp2cvif_rd_req_pd            (sdp2cvif_rd_req_pd[NVDLA_DMA_RD_REQ-1:0])          //|> o
   ,.sdp2cvif_rd_req_valid         (sdp2cvif_rd_req_valid)             //|> o
   ,.sdp2cvif_rd_req_ready         (sdp2cvif_rd_req_ready)             //|< i
   ,.cvif2sdp_rd_rsp_pd            (cvif2sdp_rd_rsp_pd[NVDLA_DMA_RD_RSP-1:0])         //|< i
   ,.cvif2sdp_rd_rsp_valid         (cvif2sdp_rd_rsp_valid)             //|< i
   ,.cvif2sdp_rd_rsp_ready         (cvif2sdp_rd_rsp_ready)             //|> o
#endif
   ,.sdp2mcif_rd_cdt_lat_fifo_pop  (sdp2mcif_rd_cdt_lat_fifo_pop)      //|> o
   ,.sdp2mcif_rd_req_pd            (sdp2mcif_rd_req_pd[NVDLA_DMA_RD_REQ-1:0])          //|> o
   ,.sdp2mcif_rd_req_valid         (sdp2mcif_rd_req_valid)             //|> o
   ,.sdp2mcif_rd_req_ready         (sdp2mcif_rd_req_ready)             //|< i
   ,.mcif2sdp_rd_rsp_pd            (mcif2sdp_rd_rsp_pd[NVDLA_DMA_RD_RSP-1:0])         //|< i
   ,.mcif2sdp_rd_rsp_valid         (mcif2sdp_rd_rsp_valid)             //|< i
   ,.mcif2sdp_rd_rsp_ready         (mcif2sdp_rd_rsp_ready)             //|> o
   ,.dma_rd_cdt_lat_fifo_pop       (dma_rd_cdt_lat_fifo_pop)           //|< w
   ,.dma_rd_req_pd                 (dma_rd_req_pd[NVDLA_DMA_RD_REQ-1:0])               //|< w
   ,.dma_rd_req_ram_type           (dma_rd_req_ram_type)               //|< w
   ,.dma_rd_req_vld                (dma_rd_req_vld)                    //|< w
   ,.dma_rd_rsp_ram_type           (dma_rd_rsp_ram_type)               //|< w
   ,.dma_rd_rsp_rdy                (dma_rd_rsp_rdy)                    //|< w
   ,.dma_rd_req_rdy                (dma_rd_req_rdy)                    //|> w
   ,.dma_rd_rsp_pd                 (dma_rd_rsp_pd[NVDLA_DMA_RD_RSP-1:0])              //|> w
   ,.dma_rd_rsp_vld                (dma_rd_rsp_vld)                    //|> w
   );
 

endmodule // NV_NVDLA_SDP_mrdma

