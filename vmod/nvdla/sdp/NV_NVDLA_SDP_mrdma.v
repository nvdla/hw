// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_mrdma.v

module NV_NVDLA_SDP_mrdma (
   nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,cvif2sdp_rd_rsp_pd            //|< i
  ,cvif2sdp_rd_rsp_valid         //|< i
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,mcif2sdp_rd_rsp_pd            //|< i
  ,mcif2sdp_rd_rsp_valid         //|< i
  ,mrdma_disable                 //|< i
  ,mrdma_slcg_op_en              //|< i
  ,pwrbus_ram_pd                 //|< i
  ,reg2dp_batch_number           //|< i
  ,reg2dp_channel                //|< i
  ,reg2dp_height                 //|< i
  ,reg2dp_in_precision           //|< i
  ,reg2dp_op_en                  //|< i
  ,reg2dp_perf_dma_en            //|< i
  ,reg2dp_perf_nan_inf_count_en  //|< i
  ,reg2dp_proc_precision         //|< i
  ,reg2dp_src_base_addr_high     //|< i
  ,reg2dp_src_base_addr_low      //|< i
  ,reg2dp_src_line_stride        //|< i
  ,reg2dp_src_ram_type           //|< i
  ,reg2dp_src_surface_stride     //|< i
  ,reg2dp_width                  //|< i
  ,sdp2cvif_rd_req_ready         //|< i
  ,sdp2mcif_rd_req_ready         //|< i
  ,sdp_mrdma2cmux_ready          //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,cvif2sdp_rd_rsp_ready         //|> o
  ,dp2reg_done                   //|> o
  ,dp2reg_mrdma_stall            //|> o
  ,dp2reg_status_inf_input_num   //|> o
  ,dp2reg_status_nan_input_num   //|> o
  ,mcif2sdp_rd_rsp_ready         //|> o
  ,sdp2cvif_rd_cdt_lat_fifo_pop  //|> o
  ,sdp2cvif_rd_req_pd            //|> o
  ,sdp2cvif_rd_req_valid         //|> o
  ,sdp2mcif_rd_cdt_lat_fifo_pop  //|> o
  ,sdp2mcif_rd_req_pd            //|> o
  ,sdp2mcif_rd_req_valid         //|> o
  ,sdp_mrdma2cmux_pd             //|> o
  ,sdp_mrdma2cmux_valid          //|> o
  );
 //
 // NV_NVDLA_SDP_mrdma_ports.v
 //
 input  nvdla_core_clk;   /* cvif2sdp_rd_rsp, mcif2sdp_rd_rsp, sdp2cvif_rd_cdt, sdp2cvif_rd_req, sdp2mcif_rd_cdt, sdp2mcif_rd_req, sdp_mrdma2cmux */
 input  nvdla_core_rstn;  /* cvif2sdp_rd_rsp, mcif2sdp_rd_rsp, sdp2cvif_rd_cdt, sdp2cvif_rd_req, sdp2mcif_rd_cdt, sdp2mcif_rd_req, sdp_mrdma2cmux */

 input          cvif2sdp_rd_rsp_valid;  /* data valid */
 output         cvif2sdp_rd_rsp_ready;  /* data return handshake */
 input  [513:0] cvif2sdp_rd_rsp_pd;

 input          mcif2sdp_rd_rsp_valid;  /* data valid */
 output         mcif2sdp_rd_rsp_ready;  /* data return handshake */
 input  [513:0] mcif2sdp_rd_rsp_pd;

 input [31:0] pwrbus_ram_pd;

 output  sdp2cvif_rd_cdt_lat_fifo_pop;

 output        sdp2cvif_rd_req_valid;  /* data valid */
 input         sdp2cvif_rd_req_ready;  /* data return handshake */
 output [78:0] sdp2cvif_rd_req_pd;

 output  sdp2mcif_rd_cdt_lat_fifo_pop;

 output        sdp2mcif_rd_req_valid;  /* data valid */
 input         sdp2mcif_rd_req_ready;  /* data return handshake */
 output [78:0] sdp2mcif_rd_req_pd;

 output         sdp_mrdma2cmux_valid;  /* data valid */
 input          sdp_mrdma2cmux_ready;  /* data return handshake */
 output [513:0] sdp_mrdma2cmux_pd;

 input   [4:0] reg2dp_batch_number;
 input  [12:0] reg2dp_channel;
 input  [12:0] reg2dp_height;
 input   [1:0] reg2dp_in_precision;
 input         reg2dp_op_en;
 input         reg2dp_perf_dma_en;
 input         reg2dp_perf_nan_inf_count_en;
 input   [1:0] reg2dp_proc_precision;
 input  [31:0] reg2dp_src_base_addr_high;
 input  [26:0] reg2dp_src_base_addr_low;
 input  [26:0] reg2dp_src_line_stride;
 input         reg2dp_src_ram_type;
 input  [26:0] reg2dp_src_surface_stride;
 input  [12:0] reg2dp_width;
 output        dp2reg_done;
 output [31:0] dp2reg_mrdma_stall;
 output [31:0] dp2reg_status_inf_input_num;
 output [31:0] dp2reg_status_nan_input_num;
 input         dla_clk_ovr_on_sync;
 input         global_clk_ovr_on_sync;
 input         tmc2slcg_disable_clock_gating;
 input         mrdma_disable;
 input         mrdma_slcg_op_en;
 reg           layer_process;
 wire   [13:0] cq2eg_pd;
 wire          cq2eg_prdy;
 wire          cq2eg_pvld;
 wire          eg_done;
 wire   [13:0] ig2cq_pd;
 wire          ig2cq_prdy;
 wire          ig2cq_pvld;
 wire          nvdla_gated_clk;
 wire          op_load;

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

 NV_NVDLA_SDP_MRDMA_gate u_gate (
    .nvdla_core_clk                (nvdla_core_clk)                    //|< i
   ,.nvdla_core_rstn               (nvdla_core_rstn)                   //|< i
   ,.dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)               //|< i
   ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)            //|< i
   ,.mrdma_disable                 (mrdma_disable)                     //|< i
   ,.mrdma_slcg_op_en              (mrdma_slcg_op_en)                  //|< i
   ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)     //|< i
   ,.nvdla_gated_clk               (nvdla_gated_clk)                   //|> w
   );
 //=======================================
 // Ingress: send read request to external mem
 //---------------------------------------
 NV_NVDLA_SDP_MRDMA_ig u_ig (
    .nvdla_core_clk                (nvdla_gated_clk)                   //|< w
   ,.nvdla_core_rstn               (nvdla_core_rstn)                   //|< i
   ,.sdp2mcif_rd_req_valid         (sdp2mcif_rd_req_valid)             //|> o
   ,.sdp2mcif_rd_req_ready         (sdp2mcif_rd_req_ready)             //|< i
   ,.sdp2mcif_rd_req_pd            (sdp2mcif_rd_req_pd[78:0])          //|> o
   ,.sdp2cvif_rd_req_valid         (sdp2cvif_rd_req_valid)             //|> o
   ,.sdp2cvif_rd_req_ready         (sdp2cvif_rd_req_ready)             //|< i
   ,.sdp2cvif_rd_req_pd            (sdp2cvif_rd_req_pd[78:0])          //|> o
   ,.ig2cq_pvld                    (ig2cq_pvld)                        //|> w
   ,.ig2cq_prdy                    (ig2cq_prdy)                        //|< w
   ,.ig2cq_pd                      (ig2cq_pd[13:0])                    //|> w
   ,.op_load                       (op_load)                           //|< w
   ,.reg2dp_batch_number           (reg2dp_batch_number[4:0])          //|< i
   ,.reg2dp_channel                (reg2dp_channel[12:0])              //|< i
   ,.reg2dp_height                 (reg2dp_height[12:0])               //|< i
   ,.reg2dp_in_precision           (reg2dp_in_precision[1:0])          //|< i
   ,.reg2dp_perf_dma_en            (reg2dp_perf_dma_en)                //|< i
   ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])        //|< i
   ,.reg2dp_src_base_addr_high     (reg2dp_src_base_addr_high[31:0])   //|< i
   ,.reg2dp_src_base_addr_low      (reg2dp_src_base_addr_low[26:0])    //|< i
   ,.reg2dp_src_line_stride        (reg2dp_src_line_stride[26:0])      //|< i
   ,.reg2dp_src_ram_type           (reg2dp_src_ram_type)               //|< i
   ,.reg2dp_src_surface_stride     (reg2dp_src_surface_stride[26:0])   //|< i
   ,.reg2dp_width                  (reg2dp_width[12:0])                //|< i
   ,.dp2reg_mrdma_stall            (dp2reg_mrdma_stall[31:0])          //|> o
   );
 //=======================================
 // Context Queue: trace outstanding req, and pass info from Ig to Eg
 //---------------------------------------
 NV_NVDLA_SDP_MRDMA_cq u_cq (
    .nvdla_core_clk                (nvdla_gated_clk)                   //|< w
   ,.nvdla_core_rstn               (nvdla_core_rstn)                   //|< i
   ,.ig2cq_prdy                    (ig2cq_prdy)                        //|> w
   ,.ig2cq_pvld                    (ig2cq_pvld)                        //|< w
   ,.ig2cq_pd                      (ig2cq_pd[13:0])                    //|< w
   ,.cq2eg_prdy                    (cq2eg_prdy)                        //|< w
   ,.cq2eg_pvld                    (cq2eg_pvld)                        //|> w
   ,.cq2eg_pd                      (cq2eg_pd[13:0])                    //|> w
   ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])               //|< i
   );
 //=======================================
 // Egress: get return data from external mem
 //---------------------------------------
 NV_NVDLA_SDP_MRDMA_eg u_eg (
    .nvdla_core_clk                (nvdla_gated_clk)                   //|< w
   ,.nvdla_core_rstn               (nvdla_core_rstn)                   //|< i
   ,.cq2eg_pvld                    (cq2eg_pvld)                        //|< w
   ,.cq2eg_prdy                    (cq2eg_prdy)                        //|> w
   ,.cq2eg_pd                      (cq2eg_pd[13:0])                    //|< w
   ,.cvif2sdp_rd_rsp_valid         (cvif2sdp_rd_rsp_valid)             //|< i
   ,.cvif2sdp_rd_rsp_ready         (cvif2sdp_rd_rsp_ready)             //|> o
   ,.cvif2sdp_rd_rsp_pd            (cvif2sdp_rd_rsp_pd[513:0])         //|< i
   ,.mcif2sdp_rd_rsp_valid         (mcif2sdp_rd_rsp_valid)             //|< i
   ,.mcif2sdp_rd_rsp_ready         (mcif2sdp_rd_rsp_ready)             //|> o
   ,.mcif2sdp_rd_rsp_pd            (mcif2sdp_rd_rsp_pd[513:0])         //|< i
   ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])               //|< i
   ,.sdp2cvif_rd_cdt_lat_fifo_pop  (sdp2cvif_rd_cdt_lat_fifo_pop)      //|> o
   ,.sdp2mcif_rd_cdt_lat_fifo_pop  (sdp2mcif_rd_cdt_lat_fifo_pop)      //|> o
   ,.sdp_mrdma2cmux_valid          (sdp_mrdma2cmux_valid)              //|> o
   ,.sdp_mrdma2cmux_ready          (sdp_mrdma2cmux_ready)              //|< i
   ,.sdp_mrdma2cmux_pd             (sdp_mrdma2cmux_pd[513:0])          //|> o
   ,.op_load                       (op_load)                           //|< w
   ,.eg_done                       (eg_done)                           //|> w
   ,.reg2dp_height                 (reg2dp_height[12:0])               //|< i
   ,.reg2dp_in_precision           (reg2dp_in_precision[1:0])          //|< i
   ,.reg2dp_perf_nan_inf_count_en  (reg2dp_perf_nan_inf_count_en)      //|< i
   ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])        //|< i
   ,.reg2dp_src_ram_type           (reg2dp_src_ram_type)               //|< i
   ,.reg2dp_width                  (reg2dp_width[12:0])                //|< i
   ,.dp2reg_status_inf_input_num   (dp2reg_status_inf_input_num[31:0]) //|> o
   ,.dp2reg_status_nan_input_num   (dp2reg_status_nan_input_num[31:0]) //|> o
   );
 
endmodule // NV_NVDLA_SDP_mrdma

