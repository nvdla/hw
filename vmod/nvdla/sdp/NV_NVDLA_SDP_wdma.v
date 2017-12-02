// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_wdma.v

module NV_NVDLA_SDP_wdma (
   nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,cvif2sdp_wr_rsp_complete      //|< i
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,mcif2sdp_wr_rsp_complete      //|< i
  ,pwrbus_ram_pd                 //|< i
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
  ,sdp2cvif_wr_req_ready         //|< i
  ,sdp2mcif_wr_req_ready         //|< i
  ,sdp_dp2wdma_pd                //|< i
  ,sdp_dp2wdma_valid             //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,dp2reg_done                   //|> o
  ,dp2reg_status_nan_output_num  //|> o
  ,dp2reg_status_unequal         //|> o
  ,dp2reg_wdma_stall             //|> o
  ,sdp2cvif_wr_req_pd            //|> o
  ,sdp2cvif_wr_req_valid         //|> o
  ,sdp2glb_done_intr_pd          //|> o
  ,sdp2mcif_wr_req_pd            //|> o
  ,sdp2mcif_wr_req_valid         //|> o
  ,sdp_dp2wdma_ready             //|> o
  );
//
// NV_NVDLA_SDP_wdma_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input  cvif2sdp_wr_rsp_complete;

input  mcif2sdp_wr_rsp_complete;

output         sdp2cvif_wr_req_valid;  /* data valid */
input          sdp2cvif_wr_req_ready;  /* data return handshake */
output [514:0] sdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

output [1:0] sdp2glb_done_intr_pd;

output         sdp2mcif_wr_req_valid;  /* data valid */
input          sdp2mcif_wr_req_ready;  /* data return handshake */
output [514:0] sdp2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input          sdp_dp2wdma_valid;  /* data valid */
output         sdp_dp2wdma_ready;  /* data return handshake */
input  [255:0] sdp_dp2wdma_pd;

input          dla_clk_ovr_on_sync;
input          global_clk_ovr_on_sync;
input   [31:0] pwrbus_ram_pd;
input    [4:0] reg2dp_batch_number;
input   [12:0] reg2dp_channel;
input   [31:0] reg2dp_dst_base_addr_high;
input   [26:0] reg2dp_dst_base_addr_low;
input   [26:0] reg2dp_dst_batch_stride;
input   [26:0] reg2dp_dst_line_stride;
input          reg2dp_dst_ram_type;
input   [26:0] reg2dp_dst_surface_stride;
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
wire    [73:0] cmd2dat_dma_pd;
wire           cmd2dat_dma_prdy;
wire           cmd2dat_dma_pvld;
wire    [14:0] cmd2dat_spt_pd;
wire           cmd2dat_spt_prdy;
wire           cmd2dat_spt_pvld;
wire   [514:0] dma_wr_req_pd;
wire           dma_wr_req_rdy;
wire           dma_wr_req_type;
wire           dma_wr_req_vld;
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
  ,.nvdla_core_clk                (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                    //|< i
  ,.reg2dp_wdma_slcg_op_en        (reg2dp_wdma_slcg_op_en)             //|< i
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)      //|< i
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
  ,.cmd2dat_dma_pd                (cmd2dat_dma_pd[73:0])               //|> w
  ,.reg2dp_batch_number           (reg2dp_batch_number[4:0])           //|< i
  ,.reg2dp_channel                (reg2dp_channel[12:0])               //|< i
  ,.reg2dp_dst_base_addr_high     (reg2dp_dst_base_addr_high[31:0])    //|< i
  ,.reg2dp_dst_base_addr_low      (reg2dp_dst_base_addr_low[26:0])     //|< i
  ,.reg2dp_dst_batch_stride       (reg2dp_dst_batch_stride[26:0])      //|< i
  ,.reg2dp_dst_line_stride        (reg2dp_dst_line_stride[26:0])       //|< i
  ,.reg2dp_dst_surface_stride     (reg2dp_dst_surface_stride[26:0])    //|< i
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
  ,.cmd2dat_dma_pvld              (cmd2dat_dma_pvld)                   //|< w
  ,.cmd2dat_dma_prdy              (cmd2dat_dma_prdy)                   //|> w
  ,.cmd2dat_dma_pd                (cmd2dat_dma_pd[73:0])               //|< w
  ,.cmd2dat_spt_pvld              (cmd2dat_spt_pvld)                   //|< w
  ,.cmd2dat_spt_prdy              (cmd2dat_spt_prdy)                   //|> w
  ,.cmd2dat_spt_pd                (cmd2dat_spt_pd[14:0])               //|< w
  ,.sdp_dp2wdma_valid             (sdp_dp2wdma_valid)                  //|< i
  ,.sdp_dp2wdma_ready             (sdp_dp2wdma_ready)                  //|> o
  ,.sdp_dp2wdma_pd                (sdp_dp2wdma_pd[255:0])              //|< i
  ,.dma_wr_req_rdy                (dma_wr_req_rdy)                     //|< w
  ,.op_load                       (op_load)                            //|< w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])                //|< i
  ,.reg2dp_batch_number           (reg2dp_batch_number[4:0])           //|< i
  ,.reg2dp_dst_ram_type           (reg2dp_dst_ram_type)                //|< i
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
  ,.dma_wr_req_pd                 (dma_wr_req_pd[514:0])               //|> w
  ,.dma_wr_req_type               (dma_wr_req_type)                    //|> w
  ,.dma_wr_req_vld                (dma_wr_req_vld)                     //|> w
  ,.dp2reg_done                   (dp2reg_done)                        //|> o
  ,.dp2reg_status_nan_output_num  (dp2reg_status_nan_output_num[31:0]) //|> o
  ,.dp2reg_status_unequal         (dp2reg_status_unequal)              //|> o
  ,.intr_req_ptr                  (intr_req_ptr)                       //|> w
  ,.intr_req_pvld                 (intr_req_pvld)                      //|> w
  );

NV_NVDLA_SDP_WDMA_dmaif u_dmaif (
   .nvdla_core_clk                (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                    //|< i
  ,.sdp2mcif_wr_req_valid         (sdp2mcif_wr_req_valid)              //|> o
  ,.sdp2mcif_wr_req_ready         (sdp2mcif_wr_req_ready)              //|< i
  ,.sdp2mcif_wr_req_pd            (sdp2mcif_wr_req_pd[514:0])          //|> o
  ,.mcif2sdp_wr_rsp_complete      (mcif2sdp_wr_rsp_complete)           //|< i
  ,.sdp2cvif_wr_req_valid         (sdp2cvif_wr_req_valid)              //|> o
  ,.sdp2cvif_wr_req_ready         (sdp2cvif_wr_req_ready)              //|< i
  ,.sdp2cvif_wr_req_pd            (sdp2cvif_wr_req_pd[514:0])          //|> o
  ,.cvif2sdp_wr_rsp_complete      (cvif2sdp_wr_rsp_complete)           //|< i
  ,.sdp2glb_done_intr_pd          (sdp2glb_done_intr_pd[1:0])          //|> o
  ,.reg2dp_ew_alu_algo            (reg2dp_ew_alu_algo[1:0])            //|< i
  ,.reg2dp_ew_alu_bypass          (reg2dp_ew_alu_bypass)               //|< i
  ,.reg2dp_ew_bypass              (reg2dp_ew_bypass)                   //|< i
  ,.reg2dp_op_en                  (reg2dp_op_en)                       //|< i
  ,.reg2dp_output_dst             (reg2dp_output_dst)                  //|< i
  ,.reg2dp_perf_dma_en            (reg2dp_perf_dma_en)                 //|< i
  ,.dp2reg_wdma_stall             (dp2reg_wdma_stall[31:0])            //|> o
  ,.dma_wr_req_vld                (dma_wr_req_vld)                     //|< w
  ,.dma_wr_req_rdy                (dma_wr_req_rdy)                     //|> w
  ,.dma_wr_req_pd                 (dma_wr_req_pd[514:0])               //|< w
  ,.dma_wr_req_type               (dma_wr_req_type)                    //|< w
  ,.intr_req_ptr                  (intr_req_ptr)                       //|< w
  ,.intr_req_pvld                 (intr_req_pvld)                      //|< w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])                //|< i
  ,.op_load                       (op_load)                            //|< w
  );

endmodule // NV_NVDLA_SDP_wdma

