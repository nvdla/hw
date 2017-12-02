// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_MRDMA_eg.v

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_MRDMA_eg (
   cq2eg_pd                     //|< i
  ,cq2eg_pvld                   //|< i
  ,cvif2sdp_rd_rsp_pd           //|< i
  ,cvif2sdp_rd_rsp_valid        //|< i
  ,mcif2sdp_rd_rsp_pd           //|< i
  ,mcif2sdp_rd_rsp_valid        //|< i
  ,nvdla_core_clk               //|< i
  ,nvdla_core_rstn              //|< i
  ,op_load                      //|< i
  ,pwrbus_ram_pd                //|< i
  ,reg2dp_height                //|< i
  ,reg2dp_in_precision          //|< i
  ,reg2dp_perf_nan_inf_count_en //|< i
  ,reg2dp_proc_precision        //|< i
  ,reg2dp_src_ram_type          //|< i
  ,reg2dp_width                 //|< i
  ,sdp_mrdma2cmux_ready         //|< i
  ,cq2eg_prdy                   //|> o
  ,cvif2sdp_rd_rsp_ready        //|> o
  ,dp2reg_status_inf_input_num  //|> o
  ,dp2reg_status_nan_input_num  //|> o
  ,eg_done                      //|> o
  ,mcif2sdp_rd_rsp_ready        //|> o
  ,sdp2cvif_rd_cdt_lat_fifo_pop //|> o
  ,sdp2mcif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_mrdma2cmux_pd            //|> o
  ,sdp_mrdma2cmux_valid         //|> o
  );
//
// NV_NVDLA_SDP_MRDMA_eg_ports.v
//
input  nvdla_core_clk;   /* cq2eg, cvif2sdp_rd_rsp, mcif2sdp_rd_rsp, sdp2cvif_rd_cdt, sdp2mcif_rd_cdt, sdp_mrdma2cmux */
input  nvdla_core_rstn;  /* cq2eg, cvif2sdp_rd_rsp, mcif2sdp_rd_rsp, sdp2cvif_rd_cdt, sdp2mcif_rd_cdt, sdp_mrdma2cmux */

input         cq2eg_pvld;  /* data valid */
output        cq2eg_prdy;  /* data return handshake */
input  [13:0] cq2eg_pd;

input          cvif2sdp_rd_rsp_valid;  /* data valid */
output         cvif2sdp_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2sdp_rd_rsp_pd;

input          mcif2sdp_rd_rsp_valid;  /* data valid */
output         mcif2sdp_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2sdp_rd_rsp_pd;

input [31:0] pwrbus_ram_pd;

output  sdp2cvif_rd_cdt_lat_fifo_pop;

output  sdp2mcif_rd_cdt_lat_fifo_pop;

output         sdp_mrdma2cmux_valid;  /* data valid */
input          sdp_mrdma2cmux_ready;  /* data return handshake */
output [513:0] sdp_mrdma2cmux_pd;

input op_load;
output eg_done;
input   [12:0] reg2dp_height;
input    [1:0] reg2dp_in_precision;
input          reg2dp_perf_nan_inf_count_en;
input    [1:0] reg2dp_proc_precision;
input          reg2dp_src_ram_type;
input   [12:0] reg2dp_width;
output  [31:0] dp2reg_status_inf_input_num;
output  [31:0] dp2reg_status_nan_input_num;
wire    [14:0] cmd2dat_dma_pd;
wire           cmd2dat_dma_prdy;
wire           cmd2dat_dma_pvld;
wire    [12:0] cmd2dat_spt_pd;
wire           cmd2dat_spt_prdy;
wire           cmd2dat_spt_pvld;
wire   [127:0] pfifo0_rd_pd;
wire           pfifo0_rd_prdy;
wire           pfifo0_rd_pvld;
wire   [127:0] pfifo1_rd_pd;
wire           pfifo1_rd_prdy;
wire           pfifo1_rd_pvld;
wire   [127:0] pfifo2_rd_pd;
wire           pfifo2_rd_prdy;
wire           pfifo2_rd_pvld;
wire   [127:0] pfifo3_rd_pd;
wire           pfifo3_rd_prdy;
wire           pfifo3_rd_pvld;
wire   [255:0] sfifo0_rd_pd;
wire           sfifo0_rd_prdy;
wire           sfifo0_rd_pvld;
wire   [255:0] sfifo1_rd_pd;
wire           sfifo1_rd_prdy;
wire           sfifo1_rd_pvld;

NV_NVDLA_SDP_MRDMA_EG_cmd u_cmd (
   .nvdla_core_clk               (nvdla_core_clk)                    //|< i
  ,.nvdla_core_rstn              (nvdla_core_rstn)                   //|< i
  ,.cq2eg_pvld                   (cq2eg_pvld)                        //|< i
  ,.cq2eg_prdy                   (cq2eg_prdy)                        //|> o
  ,.cq2eg_pd                     (cq2eg_pd[13:0])                    //|< i
  ,.cmd2dat_spt_pvld             (cmd2dat_spt_pvld)                  //|> w
  ,.cmd2dat_spt_prdy             (cmd2dat_spt_prdy)                  //|< w
  ,.cmd2dat_spt_pd               (cmd2dat_spt_pd[12:0])              //|> w
  ,.cmd2dat_dma_pvld             (cmd2dat_dma_pvld)                  //|> w
  ,.cmd2dat_dma_prdy             (cmd2dat_dma_prdy)                  //|< w
  ,.cmd2dat_dma_pd               (cmd2dat_dma_pd[14:0])              //|> w
  ,.pwrbus_ram_pd                (pwrbus_ram_pd[31:0])               //|< i
  ,.eg_done                      (eg_done)                           //|< o
  ,.reg2dp_height                (reg2dp_height[12:0])               //|< i
  ,.reg2dp_in_precision          (reg2dp_in_precision[1:0])          //|< i
  ,.reg2dp_proc_precision        (reg2dp_proc_precision[1:0])        //|< i
  ,.reg2dp_width                 (reg2dp_width[12:0])                //|< i
  );
NV_NVDLA_SDP_MRDMA_EG_din u_din (
   .nvdla_core_clk               (nvdla_core_clk)                    //|< i
  ,.nvdla_core_rstn              (nvdla_core_rstn)                   //|< i
  ,.cmd2dat_spt_pvld             (cmd2dat_spt_pvld)                  //|< w
  ,.cmd2dat_spt_prdy             (cmd2dat_spt_prdy)                  //|> w
  ,.cmd2dat_spt_pd               (cmd2dat_spt_pd[12:0])              //|< w
  ,.pfifo0_rd_pvld               (pfifo0_rd_pvld)                    //|> w
  ,.pfifo0_rd_prdy               (pfifo0_rd_prdy)                    //|< w
  ,.pfifo0_rd_pd                 (pfifo0_rd_pd[127:0])               //|> w
  ,.pfifo1_rd_pvld               (pfifo1_rd_pvld)                    //|> w
  ,.pfifo1_rd_prdy               (pfifo1_rd_prdy)                    //|< w
  ,.pfifo1_rd_pd                 (pfifo1_rd_pd[127:0])               //|> w
  ,.pfifo2_rd_pvld               (pfifo2_rd_pvld)                    //|> w
  ,.pfifo2_rd_prdy               (pfifo2_rd_prdy)                    //|< w
  ,.pfifo2_rd_pd                 (pfifo2_rd_pd[127:0])               //|> w
  ,.pfifo3_rd_pvld               (pfifo3_rd_pvld)                    //|> w
  ,.pfifo3_rd_prdy               (pfifo3_rd_prdy)                    //|< w
  ,.pfifo3_rd_pd                 (pfifo3_rd_pd[127:0])               //|> w
  ,.sfifo0_rd_pvld               (sfifo0_rd_pvld)                    //|> w
  ,.sfifo0_rd_prdy               (sfifo0_rd_prdy)                    //|< w
  ,.sfifo0_rd_pd                 (sfifo0_rd_pd[255:0])               //|> w
  ,.sfifo1_rd_pvld               (sfifo1_rd_pvld)                    //|> w
  ,.sfifo1_rd_prdy               (sfifo1_rd_prdy)                    //|< w
  ,.sfifo1_rd_pd                 (sfifo1_rd_pd[255:0])               //|> w
  ,.mcif2sdp_rd_rsp_valid        (mcif2sdp_rd_rsp_valid)             //|< i
  ,.mcif2sdp_rd_rsp_ready        (mcif2sdp_rd_rsp_ready)             //|> o
  ,.mcif2sdp_rd_rsp_pd           (mcif2sdp_rd_rsp_pd[513:0])         //|< i
  ,.cvif2sdp_rd_rsp_valid        (cvif2sdp_rd_rsp_valid)             //|< i
  ,.cvif2sdp_rd_rsp_ready        (cvif2sdp_rd_rsp_ready)             //|> o
  ,.cvif2sdp_rd_rsp_pd           (cvif2sdp_rd_rsp_pd[513:0])         //|< i
  ,.sdp2mcif_rd_cdt_lat_fifo_pop (sdp2mcif_rd_cdt_lat_fifo_pop)      //|> o
  ,.sdp2cvif_rd_cdt_lat_fifo_pop (sdp2cvif_rd_cdt_lat_fifo_pop)      //|> o
  ,.pwrbus_ram_pd                (pwrbus_ram_pd[31:0])               //|< i
  ,.reg2dp_src_ram_type          (reg2dp_src_ram_type)               //|< i
  );
NV_NVDLA_SDP_MRDMA_EG_dout u_dout (
   .nvdla_core_clk               (nvdla_core_clk)                    //|< i
  ,.nvdla_core_rstn              (nvdla_core_rstn)                   //|< i
  ,.cmd2dat_dma_pvld             (cmd2dat_dma_pvld)                  //|< w
  ,.cmd2dat_dma_prdy             (cmd2dat_dma_prdy)                  //|> w
  ,.cmd2dat_dma_pd               (cmd2dat_dma_pd[14:0])              //|< w
  ,.pfifo0_rd_pvld               (pfifo0_rd_pvld)                    //|< w
  ,.pfifo0_rd_prdy               (pfifo0_rd_prdy)                    //|> w
  ,.pfifo0_rd_pd                 (pfifo0_rd_pd[127:0])               //|< w
  ,.pfifo1_rd_pvld               (pfifo1_rd_pvld)                    //|< w
  ,.pfifo1_rd_prdy               (pfifo1_rd_prdy)                    //|> w
  ,.pfifo1_rd_pd                 (pfifo1_rd_pd[127:0])               //|< w
  ,.pfifo2_rd_pvld               (pfifo2_rd_pvld)                    //|< w
  ,.pfifo2_rd_prdy               (pfifo2_rd_prdy)                    //|> w
  ,.pfifo2_rd_pd                 (pfifo2_rd_pd[127:0])               //|< w
  ,.pfifo3_rd_pvld               (pfifo3_rd_pvld)                    //|< w
  ,.pfifo3_rd_prdy               (pfifo3_rd_prdy)                    //|> w
  ,.pfifo3_rd_pd                 (pfifo3_rd_pd[127:0])               //|< w
  ,.sfifo0_rd_pvld               (sfifo0_rd_pvld)                    //|< w
  ,.sfifo0_rd_prdy               (sfifo0_rd_prdy)                    //|> w
  ,.sfifo0_rd_pd                 (sfifo0_rd_pd[255:0])               //|< w
  ,.sfifo1_rd_pvld               (sfifo1_rd_pvld)                    //|< w
  ,.sfifo1_rd_prdy               (sfifo1_rd_prdy)                    //|> w
  ,.sfifo1_rd_pd                 (sfifo1_rd_pd[255:0])               //|< w
  ,.sdp_mrdma2cmux_valid         (sdp_mrdma2cmux_valid)              //|> o
  ,.sdp_mrdma2cmux_ready         (sdp_mrdma2cmux_ready)              //|< i
  ,.sdp_mrdma2cmux_pd            (sdp_mrdma2cmux_pd[513:0])          //|> o
  ,.op_load                      (op_load)                           //|< i
  ,.eg_done                      (eg_done)                           //|> o
  ,.reg2dp_height                (reg2dp_height[12:0])               //|< i
  ,.reg2dp_in_precision          (reg2dp_in_precision[1:0])          //|< i
  ,.reg2dp_perf_nan_inf_count_en (reg2dp_perf_nan_inf_count_en)      //|< i
  ,.reg2dp_proc_precision        (reg2dp_proc_precision[1:0])        //|< i
  ,.reg2dp_width                 (reg2dp_width[12:0])                //|< i
  ,.dp2reg_status_inf_input_num  (dp2reg_status_inf_input_num[31:0]) //|> o
  ,.dp2reg_status_nan_input_num  (dp2reg_status_nan_input_num[31:0]) //|> o
  );

endmodule // NV_NVDLA_SDP_MRDMA_eg

