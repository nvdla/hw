// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_erdma.v

module NV_NVDLA_SDP_erdma (
   nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,cvif2sdp_e_rd_rsp_pd           //|< i
  ,cvif2sdp_e_rd_rsp_valid        //|< i
  ,dla_clk_ovr_on_sync            //|< i
  ,erdma_disable                  //|< i
  ,erdma_slcg_op_en               //|< i
  ,global_clk_ovr_on_sync         //|< i
  ,mcif2sdp_e_rd_rsp_pd           //|< i
  ,mcif2sdp_e_rd_rsp_valid        //|< i
  ,pwrbus_ram_pd                  //|< i
  ,reg2dp_batch_number            //|< i
  ,reg2dp_channel                 //|< i
  ,reg2dp_erdma_data_mode         //|< i
  ,reg2dp_erdma_data_size         //|< i
  ,reg2dp_erdma_data_use          //|< i
  ,reg2dp_erdma_ram_type          //|< i
  ,reg2dp_ew_base_addr_high       //|< i
  ,reg2dp_ew_base_addr_low        //|< i
  ,reg2dp_ew_line_stride          //|< i
  ,reg2dp_ew_surface_stride       //|< i
  ,reg2dp_height                  //|< i
  ,reg2dp_op_en                   //|< i
  ,reg2dp_out_precision           //|< i
  ,reg2dp_perf_dma_en             //|< i
  ,reg2dp_proc_precision          //|< i
  ,reg2dp_width                   //|< i
  ,reg2dp_winograd                //|< i
  ,sdp_e2cvif_rd_req_ready        //|< i
  ,sdp_e2mcif_rd_req_ready        //|< i
  ,sdp_erdma2dp_alu_ready         //|< i
  ,sdp_erdma2dp_mul_ready         //|< i
  ,tmc2slcg_disable_clock_gating  //|< i
  ,cvif2sdp_e_rd_rsp_ready        //|> o
  ,dp2reg_done                    //|> o
  ,dp2reg_erdma_stall             //|> o
  ,mcif2sdp_e_rd_rsp_ready        //|> o
  ,sdp_e2cvif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_e2cvif_rd_req_pd           //|> o
  ,sdp_e2cvif_rd_req_valid        //|> o
  ,sdp_e2mcif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_e2mcif_rd_req_pd           //|> o
  ,sdp_e2mcif_rd_req_valid        //|> o
  ,sdp_erdma2dp_alu_pd            //|> o
  ,sdp_erdma2dp_alu_valid         //|> o
  ,sdp_erdma2dp_mul_pd            //|> o
  ,sdp_erdma2dp_mul_valid         //|> o
  );

 //
 // NV_NVDLA_SDP_erdma_ports.v
 //
 input  nvdla_core_clk;   /* cvif2sdp_e_rd_rsp, mcif2sdp_e_rd_rsp, sdp_e2cvif_rd_cdt, sdp_e2cvif_rd_req, sdp_e2mcif_rd_cdt, sdp_e2mcif_rd_req, sdp_erdma2dp_alu, sdp_erdma2dp_mul */
 input  nvdla_core_rstn;  /* cvif2sdp_e_rd_rsp, mcif2sdp_e_rd_rsp, sdp_e2cvif_rd_cdt, sdp_e2cvif_rd_req, sdp_e2mcif_rd_cdt, sdp_e2mcif_rd_req, sdp_erdma2dp_alu, sdp_erdma2dp_mul */

 input          cvif2sdp_e_rd_rsp_valid;  /* data valid */
 output         cvif2sdp_e_rd_rsp_ready;  /* data return handshake */
 input  [513:0] cvif2sdp_e_rd_rsp_pd;

 input          mcif2sdp_e_rd_rsp_valid;  /* data valid */
 output         mcif2sdp_e_rd_rsp_ready;  /* data return handshake */
 input  [513:0] mcif2sdp_e_rd_rsp_pd;

 input [31:0] pwrbus_ram_pd;

 output  sdp_e2cvif_rd_cdt_lat_fifo_pop;

 output        sdp_e2cvif_rd_req_valid;  /* data valid */
 input         sdp_e2cvif_rd_req_ready;  /* data return handshake */
 output [78:0] sdp_e2cvif_rd_req_pd;

 output  sdp_e2mcif_rd_cdt_lat_fifo_pop;

 output        sdp_e2mcif_rd_req_valid;  /* data valid */
 input         sdp_e2mcif_rd_req_ready;  /* data return handshake */
 output [78:0] sdp_e2mcif_rd_req_pd;

 output         sdp_erdma2dp_alu_valid;  /* data valid */
 input          sdp_erdma2dp_alu_ready;  /* data return handshake */
 output [256:0] sdp_erdma2dp_alu_pd;

 output         sdp_erdma2dp_mul_valid;  /* data valid */
 input          sdp_erdma2dp_mul_ready;  /* data return handshake */
 output [256:0] sdp_erdma2dp_mul_pd;

 input   [4:0] reg2dp_batch_number;
 input  [12:0] reg2dp_channel;
 input         reg2dp_erdma_data_mode;
 input         reg2dp_erdma_data_size;
 input   [1:0] reg2dp_erdma_data_use;
 input         reg2dp_erdma_ram_type;
 input  [31:0] reg2dp_ew_base_addr_high;
 input  [26:0] reg2dp_ew_base_addr_low;
 input  [26:0] reg2dp_ew_line_stride;
 input  [26:0] reg2dp_ew_surface_stride;
 input  [12:0] reg2dp_height;
 input         reg2dp_op_en;
 input   [1:0] reg2dp_out_precision;
 input         reg2dp_perf_dma_en;
 input   [1:0] reg2dp_proc_precision;
 input  [12:0] reg2dp_width;
 input         reg2dp_winograd;
 output        dp2reg_done;
 output [31:0] dp2reg_erdma_stall;
 input         dla_clk_ovr_on_sync;
 input         global_clk_ovr_on_sync;
 input         tmc2slcg_disable_clock_gating;
 input         erdma_slcg_op_en;
 input         erdma_disable;
 reg           layer_process;
 wire   [15:0] cq2eg_pd;
 wire          cq2eg_prdy;
 wire          cq2eg_pvld;
 wire          eg_done;
 wire   [15:0] ig2cq_pd;
 wire          ig2cq_prdy;
 wire          ig2cq_pvld;
 wire          nvdla_gated_clk;
 wire          op_load;

 // Layer Switch

assign op_load = reg2dp_op_en & !layer_process;
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
NV_NVDLA_SDP_ERDMA_gate u_gate (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)            //|< i
  ,.erdma_disable                  (erdma_disable)                  //|< i
  ,.erdma_slcg_op_en               (erdma_slcg_op_en)               //|< i
  ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)         //|< i
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)  //|< i
  ,.nvdla_gated_clk                (nvdla_gated_clk)                //|> w
  );

NV_NVDLA_SDP_ERDMA_ig u_ig (
   .reg2dp_channel                 (reg2dp_channel[12:0])           //|< i
  ,.reg2dp_erdma_data_mode         (reg2dp_erdma_data_mode)         //|< i
  ,.reg2dp_erdma_data_size         (reg2dp_erdma_data_size)         //|< i
  ,.reg2dp_erdma_data_use          (reg2dp_erdma_data_use[1:0])     //|< i
  ,.reg2dp_erdma_ram_type          (reg2dp_erdma_ram_type)          //|< i
  ,.reg2dp_ew_base_addr_high       (reg2dp_ew_base_addr_high[31:0]) //|< i
  ,.reg2dp_ew_base_addr_low        (reg2dp_ew_base_addr_low[26:0])  //|< i
  ,.reg2dp_ew_line_stride          (reg2dp_ew_line_stride[26:0])    //|< i
  ,.reg2dp_ew_surface_stride       (reg2dp_ew_surface_stride[26:0]) //|< i
  ,.reg2dp_height                  (reg2dp_height[12:0])            //|< i
  ,.reg2dp_op_en                   (reg2dp_op_en)                   //|< i
  ,.reg2dp_perf_dma_en             (reg2dp_perf_dma_en)             //|< i
  ,.reg2dp_proc_precision          (reg2dp_proc_precision[1:0])     //|< i
  ,.reg2dp_width                   (reg2dp_width[12:0])             //|< i
  ,.reg2dp_winograd                (reg2dp_winograd)                //|< i
  ,.dp2reg_erdma_stall             (dp2reg_erdma_stall[31:0])       //|> o
  ,.op_load                        (op_load)                        //|< w
  ,.nvdla_core_clk                 (nvdla_gated_clk)                //|< w
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.sdp_e2mcif_rd_req_valid        (sdp_e2mcif_rd_req_valid)        //|> o
  ,.sdp_e2mcif_rd_req_ready        (sdp_e2mcif_rd_req_ready)        //|< i
  ,.sdp_e2mcif_rd_req_pd           (sdp_e2mcif_rd_req_pd[78:0])     //|> o
  ,.sdp_e2cvif_rd_req_valid        (sdp_e2cvif_rd_req_valid)        //|> o
  ,.sdp_e2cvif_rd_req_ready        (sdp_e2cvif_rd_req_ready)        //|< i
  ,.sdp_e2cvif_rd_req_pd           (sdp_e2cvif_rd_req_pd[78:0])     //|> o
  ,.ig2cq_pvld                     (ig2cq_pvld)                     //|> w
  ,.ig2cq_prdy                     (ig2cq_prdy)                     //|< w
  ,.ig2cq_pd                       (ig2cq_pd[15:0])                 //|> w
  );

NV_NVDLA_SDP_ERDMA_cq u_cq (
   .nvdla_core_clk                 (nvdla_gated_clk)                //|< w
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.ig2cq_prdy                     (ig2cq_prdy)                     //|> w
  ,.ig2cq_pvld                     (ig2cq_pvld)                     //|< w
  ,.ig2cq_pd                       (ig2cq_pd[15:0])                 //|< w
  ,.cq2eg_prdy                     (cq2eg_prdy)                     //|< w
  ,.cq2eg_pvld                     (cq2eg_pvld)                     //|> w
  ,.cq2eg_pd                       (cq2eg_pd[15:0])                 //|> w
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  );

NV_NVDLA_SDP_ERDMA_eg u_eg (
   .nvdla_core_clk                 (nvdla_gated_clk)                //|< w
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.mcif2sdp_e_rd_rsp_valid        (mcif2sdp_e_rd_rsp_valid)        //|< i
  ,.mcif2sdp_e_rd_rsp_ready        (mcif2sdp_e_rd_rsp_ready)        //|> o
  ,.mcif2sdp_e_rd_rsp_pd           (mcif2sdp_e_rd_rsp_pd[513:0])    //|< i
  ,.cvif2sdp_e_rd_rsp_valid        (cvif2sdp_e_rd_rsp_valid)        //|< i
  ,.cvif2sdp_e_rd_rsp_ready        (cvif2sdp_e_rd_rsp_ready)        //|> o
  ,.cvif2sdp_e_rd_rsp_pd           (cvif2sdp_e_rd_rsp_pd[513:0])    //|< i
  ,.sdp_e2mcif_rd_cdt_lat_fifo_pop (sdp_e2mcif_rd_cdt_lat_fifo_pop) //|> o
  ,.sdp_e2cvif_rd_cdt_lat_fifo_pop (sdp_e2cvif_rd_cdt_lat_fifo_pop) //|> o
  ,.cq2eg_pvld                     (cq2eg_pvld)                     //|< w
  ,.cq2eg_prdy                     (cq2eg_prdy)                     //|> w
  ,.cq2eg_pd                       (cq2eg_pd[15:0])                 //|< w
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.sdp_erdma2dp_alu_valid         (sdp_erdma2dp_alu_valid)         //|> o
  ,.sdp_erdma2dp_alu_ready         (sdp_erdma2dp_alu_ready)         //|< i
  ,.sdp_erdma2dp_alu_pd            (sdp_erdma2dp_alu_pd[256:0])     //|> o
  ,.sdp_erdma2dp_mul_valid         (sdp_erdma2dp_mul_valid)         //|> o
  ,.sdp_erdma2dp_mul_ready         (sdp_erdma2dp_mul_ready)         //|< i
  ,.sdp_erdma2dp_mul_pd            (sdp_erdma2dp_mul_pd[256:0])     //|> o
  ,.reg2dp_batch_number            (reg2dp_batch_number[4:0])       //|< i
  ,.reg2dp_channel                 (reg2dp_channel[12:0])           //|< i
  ,.reg2dp_erdma_data_mode         (reg2dp_erdma_data_mode)         //|< i
  ,.reg2dp_erdma_data_size         (reg2dp_erdma_data_size)         //|< i
  ,.reg2dp_erdma_data_use          (reg2dp_erdma_data_use[1:0])     //|< i
  ,.reg2dp_erdma_ram_type          (reg2dp_erdma_ram_type)          //|< i
  ,.reg2dp_height                  (reg2dp_height[12:0])            //|< i
  ,.reg2dp_out_precision           (reg2dp_out_precision[1:0])      //|< i
  ,.reg2dp_proc_precision          (reg2dp_proc_precision[1:0])     //|< i
  ,.reg2dp_width                   (reg2dp_width[12:0])             //|< i
  ,.op_load                        (op_load)                        //|< w
  ,.eg_done                        (eg_done)                        //|> w
  );

//|
//|

endmodule // NV_NVDLA_SDP_erdma

