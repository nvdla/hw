// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_rdma.v

module NV_NVDLA_SDP_rdma (
   nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,csb2sdp_rdma_req_pd            //|< i
  ,csb2sdp_rdma_req_pvld          //|< i
  ,cvif2sdp_b_rd_rsp_pd           //|< i
  ,cvif2sdp_b_rd_rsp_valid        //|< i
  ,cvif2sdp_e_rd_rsp_pd           //|< i
  ,cvif2sdp_e_rd_rsp_valid        //|< i
  ,cvif2sdp_n_rd_rsp_pd           //|< i
  ,cvif2sdp_n_rd_rsp_valid        //|< i
  ,cvif2sdp_rd_rsp_pd             //|< i
  ,cvif2sdp_rd_rsp_valid          //|< i
  ,dla_clk_ovr_on_sync            //|< i
  ,global_clk_ovr_on_sync         //|< i
  ,mcif2sdp_b_rd_rsp_pd           //|< i
  ,mcif2sdp_b_rd_rsp_valid        //|< i
  ,mcif2sdp_e_rd_rsp_pd           //|< i
  ,mcif2sdp_e_rd_rsp_valid        //|< i
  ,mcif2sdp_n_rd_rsp_pd           //|< i
  ,mcif2sdp_n_rd_rsp_valid        //|< i
  ,mcif2sdp_rd_rsp_pd             //|< i
  ,mcif2sdp_rd_rsp_valid          //|< i
  ,pwrbus_ram_pd                  //|< i
  ,sdp2cvif_rd_req_ready          //|< i
  ,sdp2mcif_rd_req_ready          //|< i
  ,sdp_b2cvif_rd_req_ready        //|< i
  ,sdp_b2mcif_rd_req_ready        //|< i
  ,sdp_brdma2dp_alu_ready         //|< i
  ,sdp_brdma2dp_mul_ready         //|< i
  ,sdp_e2cvif_rd_req_ready        //|< i
  ,sdp_e2mcif_rd_req_ready        //|< i
  ,sdp_erdma2dp_alu_ready         //|< i
  ,sdp_erdma2dp_mul_ready         //|< i
  ,sdp_mrdma2cmux_ready           //|< i
  ,sdp_n2cvif_rd_req_ready        //|< i
  ,sdp_n2mcif_rd_req_ready        //|< i
  ,sdp_nrdma2dp_alu_ready         //|< i
  ,sdp_nrdma2dp_mul_ready         //|< i
  ,tmc2slcg_disable_clock_gating  //|< i
  ,csb2sdp_rdma_req_prdy          //|> o
  ,cvif2sdp_b_rd_rsp_ready        //|> o
  ,cvif2sdp_e_rd_rsp_ready        //|> o
  ,cvif2sdp_n_rd_rsp_ready        //|> o
  ,cvif2sdp_rd_rsp_ready          //|> o
  ,mcif2sdp_b_rd_rsp_ready        //|> o
  ,mcif2sdp_e_rd_rsp_ready        //|> o
  ,mcif2sdp_n_rd_rsp_ready        //|> o
  ,mcif2sdp_rd_rsp_ready          //|> o
  ,sdp2cvif_rd_cdt_lat_fifo_pop   //|> o
  ,sdp2cvif_rd_req_pd             //|> o
  ,sdp2cvif_rd_req_valid          //|> o
  ,sdp2mcif_rd_cdt_lat_fifo_pop   //|> o
  ,sdp2mcif_rd_req_pd             //|> o
  ,sdp2mcif_rd_req_valid          //|> o
  ,sdp_b2cvif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_b2cvif_rd_req_pd           //|> o
  ,sdp_b2cvif_rd_req_valid        //|> o
  ,sdp_b2mcif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_b2mcif_rd_req_pd           //|> o
  ,sdp_b2mcif_rd_req_valid        //|> o
  ,sdp_brdma2dp_alu_pd            //|> o
  ,sdp_brdma2dp_alu_valid         //|> o
  ,sdp_brdma2dp_mul_pd            //|> o
  ,sdp_brdma2dp_mul_valid         //|> o
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
  ,sdp_mrdma2cmux_pd              //|> o
  ,sdp_mrdma2cmux_valid           //|> o
  ,sdp_n2cvif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_n2cvif_rd_req_pd           //|> o
  ,sdp_n2cvif_rd_req_valid        //|> o
  ,sdp_n2mcif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_n2mcif_rd_req_pd           //|> o
  ,sdp_n2mcif_rd_req_valid        //|> o
  ,sdp_nrdma2dp_alu_pd            //|> o
  ,sdp_nrdma2dp_alu_valid         //|> o
  ,sdp_nrdma2dp_mul_pd            //|> o
  ,sdp_nrdma2dp_mul_valid         //|> o
  ,sdp_rdma2csb_resp_pd           //|> o
  ,sdp_rdma2csb_resp_valid        //|> o
  );
//
// NV_NVDLA_SDP_rdma_ports.v
//
input  nvdla_core_clk;   /* csb2sdp_rdma_req, cvif2sdp_b_rd_rsp, cvif2sdp_e_rd_rsp, cvif2sdp_n_rd_rsp, cvif2sdp_rd_rsp, mcif2sdp_b_rd_rsp, mcif2sdp_e_rd_rsp, mcif2sdp_n_rd_rsp, mcif2sdp_rd_rsp, sdp2cvif_rd_cdt, sdp2cvif_rd_req, sdp2mcif_rd_cdt, sdp2mcif_rd_req, sdp_b2cvif_rd_cdt, sdp_b2cvif_rd_req, sdp_b2mcif_rd_cdt, sdp_b2mcif_rd_req, sdp_brdma2dp_alu, sdp_brdma2dp_mul, sdp_e2cvif_rd_cdt, sdp_e2cvif_rd_req, sdp_e2mcif_rd_cdt, sdp_e2mcif_rd_req, sdp_erdma2dp_alu, sdp_erdma2dp_mul, sdp_mrdma2cmux, sdp_n2cvif_rd_cdt, sdp_n2cvif_rd_req, sdp_n2mcif_rd_cdt, sdp_n2mcif_rd_req, sdp_nrdma2dp_alu, sdp_nrdma2dp_mul, sdp_rdma2csb_resp */
input  nvdla_core_rstn;  /* csb2sdp_rdma_req, cvif2sdp_b_rd_rsp, cvif2sdp_e_rd_rsp, cvif2sdp_n_rd_rsp, cvif2sdp_rd_rsp, mcif2sdp_b_rd_rsp, mcif2sdp_e_rd_rsp, mcif2sdp_n_rd_rsp, mcif2sdp_rd_rsp, sdp2cvif_rd_cdt, sdp2cvif_rd_req, sdp2mcif_rd_cdt, sdp2mcif_rd_req, sdp_b2cvif_rd_cdt, sdp_b2cvif_rd_req, sdp_b2mcif_rd_cdt, sdp_b2mcif_rd_req, sdp_brdma2dp_alu, sdp_brdma2dp_mul, sdp_e2cvif_rd_cdt, sdp_e2cvif_rd_req, sdp_e2mcif_rd_cdt, sdp_e2mcif_rd_req, sdp_erdma2dp_alu, sdp_erdma2dp_mul, sdp_mrdma2cmux, sdp_n2cvif_rd_cdt, sdp_n2cvif_rd_req, sdp_n2mcif_rd_cdt, sdp_n2mcif_rd_req, sdp_nrdma2dp_alu, sdp_nrdma2dp_mul, sdp_rdma2csb_resp */

input         csb2sdp_rdma_req_pvld;  /* data valid */
output        csb2sdp_rdma_req_prdy;  /* data return handshake */
input  [62:0] csb2sdp_rdma_req_pd;

input          cvif2sdp_b_rd_rsp_valid;  /* data valid */
output         cvif2sdp_b_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2sdp_b_rd_rsp_pd;

input          cvif2sdp_e_rd_rsp_valid;  /* data valid */
output         cvif2sdp_e_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2sdp_e_rd_rsp_pd;

input          cvif2sdp_n_rd_rsp_valid;  /* data valid */
output         cvif2sdp_n_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2sdp_n_rd_rsp_pd;

input          cvif2sdp_rd_rsp_valid;  /* data valid */
output         cvif2sdp_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2sdp_rd_rsp_pd;

input          mcif2sdp_b_rd_rsp_valid;  /* data valid */
output         mcif2sdp_b_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2sdp_b_rd_rsp_pd;

input          mcif2sdp_e_rd_rsp_valid;  /* data valid */
output         mcif2sdp_e_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2sdp_e_rd_rsp_pd;

input          mcif2sdp_n_rd_rsp_valid;  /* data valid */
output         mcif2sdp_n_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2sdp_n_rd_rsp_pd;

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

output  sdp_b2cvif_rd_cdt_lat_fifo_pop;

output        sdp_b2cvif_rd_req_valid;  /* data valid */
input         sdp_b2cvif_rd_req_ready;  /* data return handshake */
output [78:0] sdp_b2cvif_rd_req_pd;

output  sdp_b2mcif_rd_cdt_lat_fifo_pop;

output        sdp_b2mcif_rd_req_valid;  /* data valid */
input         sdp_b2mcif_rd_req_ready;  /* data return handshake */
output [78:0] sdp_b2mcif_rd_req_pd;

output         sdp_brdma2dp_alu_valid;  /* data valid */
input          sdp_brdma2dp_alu_ready;  /* data return handshake */
output [256:0] sdp_brdma2dp_alu_pd;

output         sdp_brdma2dp_mul_valid;  /* data valid */
input          sdp_brdma2dp_mul_ready;  /* data return handshake */
output [256:0] sdp_brdma2dp_mul_pd;

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

output         sdp_mrdma2cmux_valid;  /* data valid */
input          sdp_mrdma2cmux_ready;  /* data return handshake */
output [513:0] sdp_mrdma2cmux_pd;

output  sdp_n2cvif_rd_cdt_lat_fifo_pop;

output        sdp_n2cvif_rd_req_valid;  /* data valid */
input         sdp_n2cvif_rd_req_ready;  /* data return handshake */
output [78:0] sdp_n2cvif_rd_req_pd;

output  sdp_n2mcif_rd_cdt_lat_fifo_pop;

output        sdp_n2mcif_rd_req_valid;  /* data valid */
input         sdp_n2mcif_rd_req_ready;  /* data return handshake */
output [78:0] sdp_n2mcif_rd_req_pd;

output         sdp_nrdma2dp_alu_valid;  /* data valid */
input          sdp_nrdma2dp_alu_ready;  /* data return handshake */
output [256:0] sdp_nrdma2dp_alu_pd;

output         sdp_nrdma2dp_mul_valid;  /* data valid */
input          sdp_nrdma2dp_mul_ready;  /* data return handshake */
output [256:0] sdp_nrdma2dp_mul_pd;

output        sdp_rdma2csb_resp_valid;  /* data valid */
output [33:0] sdp_rdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input        dla_clk_ovr_on_sync;
input        global_clk_ovr_on_sync;
input        tmc2slcg_disable_clock_gating;
reg          brdma_done_pending;
reg          erdma_done_pending;
reg          mrdma_done_pending;
reg          nrdma_done_pending;
wire         brdma_disable;
wire         brdma_done;
wire         brdma_op_en;
wire         brdma_slcg_op_en;
wire  [31:0] dp2reg_brdma_stall;
wire         dp2reg_done;
wire  [31:0] dp2reg_erdma_stall;
wire  [31:0] dp2reg_mrdma_stall;
wire  [31:0] dp2reg_nrdma_stall;
wire  [31:0] dp2reg_status_inf_input_num;
wire  [31:0] dp2reg_status_nan_input_num;
wire         erdma_disable;
wire         erdma_done;
wire         erdma_op_en;
wire         erdma_slcg_op_en;
wire         mrdma_disable;
wire         mrdma_done;
wire         mrdma_op_en;
wire         mrdma_slcg_op_en;
wire         nrdma_disable;
wire         nrdma_done;
wire         nrdma_op_en;
wire         nrdma_slcg_op_en;
wire   [4:0] reg2dp_batch_number;
wire  [31:0] reg2dp_bn_base_addr_high;
wire  [26:0] reg2dp_bn_base_addr_low;
wire  [26:0] reg2dp_bn_batch_stride;
wire  [26:0] reg2dp_bn_line_stride;
wire  [26:0] reg2dp_bn_surface_stride;
wire         reg2dp_brdma_data_mode;
wire         reg2dp_brdma_data_size;
wire   [1:0] reg2dp_brdma_data_use;
wire         reg2dp_brdma_disable;
wire         reg2dp_brdma_ram_type;
wire  [31:0] reg2dp_bs_base_addr_high;
wire  [26:0] reg2dp_bs_base_addr_low;
wire  [26:0] reg2dp_bs_batch_stride;
wire  [26:0] reg2dp_bs_line_stride;
wire  [26:0] reg2dp_bs_surface_stride;
wire  [12:0] reg2dp_channel;
wire         reg2dp_erdma_data_mode;
wire         reg2dp_erdma_data_size;
wire   [1:0] reg2dp_erdma_data_use;
wire         reg2dp_erdma_disable;
wire         reg2dp_erdma_ram_type;
wire  [31:0] reg2dp_ew_base_addr_high;
wire  [26:0] reg2dp_ew_base_addr_low;
wire  [26:0] reg2dp_ew_batch_stride;
wire  [26:0] reg2dp_ew_line_stride;
wire  [26:0] reg2dp_ew_surface_stride;
wire         reg2dp_flying_mode;
wire  [12:0] reg2dp_height;
wire   [1:0] reg2dp_in_precision;
wire         reg2dp_nrdma_data_mode;
wire         reg2dp_nrdma_data_size;
wire   [1:0] reg2dp_nrdma_data_use;
wire         reg2dp_nrdma_disable;
wire         reg2dp_nrdma_ram_type;
wire         reg2dp_op_en;
wire   [1:0] reg2dp_out_precision;
wire         reg2dp_perf_dma_en;
wire         reg2dp_perf_nan_inf_count_en;
wire   [1:0] reg2dp_proc_precision;
wire  [31:0] reg2dp_src_base_addr_high;
wire  [26:0] reg2dp_src_base_addr_low;
wire  [26:0] reg2dp_src_line_stride;
wire         reg2dp_src_ram_type;
wire  [26:0] reg2dp_src_surface_stride;
wire  [12:0] reg2dp_width;
wire         reg2dp_winograd;
wire   [3:0] slcg_op_en;

//=======================================
// M-RDMA
NV_NVDLA_SDP_mrdma u_mrdma (
   .nvdla_core_clk                 (nvdla_core_clk)                    //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                   //|< i
  ,.cvif2sdp_rd_rsp_valid          (cvif2sdp_rd_rsp_valid)             //|< i
  ,.cvif2sdp_rd_rsp_ready          (cvif2sdp_rd_rsp_ready)             //|> o
  ,.cvif2sdp_rd_rsp_pd             (cvif2sdp_rd_rsp_pd[513:0])         //|< i
  ,.mcif2sdp_rd_rsp_valid          (mcif2sdp_rd_rsp_valid)             //|< i
  ,.mcif2sdp_rd_rsp_ready          (mcif2sdp_rd_rsp_ready)             //|> o
  ,.mcif2sdp_rd_rsp_pd             (mcif2sdp_rd_rsp_pd[513:0])         //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])               //|< i
  ,.sdp2cvif_rd_cdt_lat_fifo_pop   (sdp2cvif_rd_cdt_lat_fifo_pop)      //|> o
  ,.sdp2cvif_rd_req_valid          (sdp2cvif_rd_req_valid)             //|> o
  ,.sdp2cvif_rd_req_ready          (sdp2cvif_rd_req_ready)             //|< i
  ,.sdp2cvif_rd_req_pd             (sdp2cvif_rd_req_pd[78:0])          //|> o
  ,.sdp2mcif_rd_cdt_lat_fifo_pop   (sdp2mcif_rd_cdt_lat_fifo_pop)      //|> o
  ,.sdp2mcif_rd_req_valid          (sdp2mcif_rd_req_valid)             //|> o
  ,.sdp2mcif_rd_req_ready          (sdp2mcif_rd_req_ready)             //|< i
  ,.sdp2mcif_rd_req_pd             (sdp2mcif_rd_req_pd[78:0])          //|> o
  ,.sdp_mrdma2cmux_valid           (sdp_mrdma2cmux_valid)              //|> o
  ,.sdp_mrdma2cmux_ready           (sdp_mrdma2cmux_ready)              //|< i
  ,.sdp_mrdma2cmux_pd              (sdp_mrdma2cmux_pd[513:0])          //|> o
  ,.reg2dp_batch_number            (reg2dp_batch_number[4:0])          //|< w
  ,.reg2dp_channel                 (reg2dp_channel[12:0])              //|< w
  ,.reg2dp_height                  (reg2dp_height[12:0])               //|< w
  ,.reg2dp_in_precision            (reg2dp_in_precision[1:0])          //|< w
  ,.reg2dp_op_en                   (mrdma_op_en)                       //|< w
  ,.reg2dp_perf_dma_en             (reg2dp_perf_dma_en)                //|< w
  ,.reg2dp_perf_nan_inf_count_en   (reg2dp_perf_nan_inf_count_en)      //|< w
  ,.reg2dp_proc_precision          (reg2dp_proc_precision[1:0])        //|< w
  ,.reg2dp_src_base_addr_high      (reg2dp_src_base_addr_high[31:0])   //|< w
  ,.reg2dp_src_base_addr_low       (reg2dp_src_base_addr_low[26:0])    //|< w
  ,.reg2dp_src_line_stride         (reg2dp_src_line_stride[26:0])      //|< w
  ,.reg2dp_src_ram_type            (reg2dp_src_ram_type)               //|< w
  ,.reg2dp_src_surface_stride      (reg2dp_src_surface_stride[26:0])   //|< w
  ,.reg2dp_width                   (reg2dp_width[12:0])                //|< w
  ,.dp2reg_done                    (mrdma_done)                        //|> w
  ,.dp2reg_mrdma_stall             (dp2reg_mrdma_stall[31:0])          //|> w
  ,.dp2reg_status_inf_input_num    (dp2reg_status_inf_input_num[31:0]) //|> w
  ,.dp2reg_status_nan_input_num    (dp2reg_status_nan_input_num[31:0]) //|> w
  ,.dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)               //|< i
  ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)            //|< i
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)     //|< i
  ,.mrdma_disable                  (mrdma_disable)                     //|< w
  ,.mrdma_slcg_op_en               (mrdma_slcg_op_en)                  //|< w
  );

NV_NVDLA_SDP_brdma u_brdma (
   .nvdla_core_clk                 (nvdla_core_clk)                    //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                   //|< i
  ,.cvif2sdp_b_rd_rsp_valid        (cvif2sdp_b_rd_rsp_valid)           //|< i
  ,.cvif2sdp_b_rd_rsp_ready        (cvif2sdp_b_rd_rsp_ready)           //|> o
  ,.cvif2sdp_b_rd_rsp_pd           (cvif2sdp_b_rd_rsp_pd[513:0])       //|< i
  ,.mcif2sdp_b_rd_rsp_valid        (mcif2sdp_b_rd_rsp_valid)           //|< i
  ,.mcif2sdp_b_rd_rsp_ready        (mcif2sdp_b_rd_rsp_ready)           //|> o
  ,.mcif2sdp_b_rd_rsp_pd           (mcif2sdp_b_rd_rsp_pd[513:0])       //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])               //|< i
  ,.sdp_b2cvif_rd_cdt_lat_fifo_pop (sdp_b2cvif_rd_cdt_lat_fifo_pop)    //|> o
  ,.sdp_b2cvif_rd_req_valid        (sdp_b2cvif_rd_req_valid)           //|> o
  ,.sdp_b2cvif_rd_req_ready        (sdp_b2cvif_rd_req_ready)           //|< i
  ,.sdp_b2cvif_rd_req_pd           (sdp_b2cvif_rd_req_pd[78:0])        //|> o
  ,.sdp_b2mcif_rd_cdt_lat_fifo_pop (sdp_b2mcif_rd_cdt_lat_fifo_pop)    //|> o
  ,.sdp_b2mcif_rd_req_valid        (sdp_b2mcif_rd_req_valid)           //|> o
  ,.sdp_b2mcif_rd_req_ready        (sdp_b2mcif_rd_req_ready)           //|< i
  ,.sdp_b2mcif_rd_req_pd           (sdp_b2mcif_rd_req_pd[78:0])        //|> o
  ,.sdp_brdma2dp_alu_valid         (sdp_brdma2dp_alu_valid)            //|> o
  ,.sdp_brdma2dp_alu_ready         (sdp_brdma2dp_alu_ready)            //|< i
  ,.sdp_brdma2dp_alu_pd            (sdp_brdma2dp_alu_pd[256:0])        //|> o
  ,.sdp_brdma2dp_mul_valid         (sdp_brdma2dp_mul_valid)            //|> o
  ,.sdp_brdma2dp_mul_ready         (sdp_brdma2dp_mul_ready)            //|< i
  ,.sdp_brdma2dp_mul_pd            (sdp_brdma2dp_mul_pd[256:0])        //|> o
  ,.reg2dp_batch_number            (reg2dp_batch_number[4:0])          //|< w
  ,.reg2dp_brdma_data_mode         (reg2dp_brdma_data_mode)            //|< w
  ,.reg2dp_brdma_data_size         (reg2dp_brdma_data_size)            //|< w
  ,.reg2dp_brdma_data_use          (reg2dp_brdma_data_use[1:0])        //|< w
  ,.reg2dp_brdma_ram_type          (reg2dp_brdma_ram_type)             //|< w
  ,.reg2dp_bs_base_addr_high       (reg2dp_bs_base_addr_high[31:0])    //|< w
  ,.reg2dp_bs_base_addr_low        (reg2dp_bs_base_addr_low[26:0])     //|< w
  ,.reg2dp_bs_line_stride          (reg2dp_bs_line_stride[26:0])       //|< w
  ,.reg2dp_bs_surface_stride       (reg2dp_bs_surface_stride[26:0])    //|< w
  ,.reg2dp_channel                 (reg2dp_channel[12:0])              //|< w
  ,.reg2dp_height                  (reg2dp_height[12:0])               //|< w
  ,.reg2dp_op_en                   (brdma_op_en)                       //|< w
  ,.reg2dp_out_precision           (reg2dp_out_precision[1:0])         //|< w
  ,.reg2dp_perf_dma_en             (reg2dp_perf_dma_en)                //|< w
  ,.reg2dp_proc_precision          (reg2dp_proc_precision[1:0])        //|< w
  ,.reg2dp_width                   (reg2dp_width[12:0])                //|< w
  ,.reg2dp_winograd                (reg2dp_winograd)                   //|< w
  ,.dp2reg_brdma_stall             (dp2reg_brdma_stall[31:0])          //|> w
  ,.dp2reg_done                    (brdma_done)                        //|> w
  ,.dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)               //|< i
  ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)            //|< i
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)     //|< i
  ,.brdma_slcg_op_en               (brdma_slcg_op_en)                  //|< w
  ,.brdma_disable                  (brdma_disable)                     //|< w
  );

NV_NVDLA_SDP_nrdma u_nrdma (
   .nvdla_core_clk                 (nvdla_core_clk)                    //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                   //|< i
  ,.cvif2sdp_n_rd_rsp_valid        (cvif2sdp_n_rd_rsp_valid)           //|< i
  ,.cvif2sdp_n_rd_rsp_ready        (cvif2sdp_n_rd_rsp_ready)           //|> o
  ,.cvif2sdp_n_rd_rsp_pd           (cvif2sdp_n_rd_rsp_pd[513:0])       //|< i
  ,.mcif2sdp_n_rd_rsp_valid        (mcif2sdp_n_rd_rsp_valid)           //|< i
  ,.mcif2sdp_n_rd_rsp_ready        (mcif2sdp_n_rd_rsp_ready)           //|> o
  ,.mcif2sdp_n_rd_rsp_pd           (mcif2sdp_n_rd_rsp_pd[513:0])       //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])               //|< i
  ,.sdp_n2cvif_rd_cdt_lat_fifo_pop (sdp_n2cvif_rd_cdt_lat_fifo_pop)    //|> o
  ,.sdp_n2cvif_rd_req_valid        (sdp_n2cvif_rd_req_valid)           //|> o
  ,.sdp_n2cvif_rd_req_ready        (sdp_n2cvif_rd_req_ready)           //|< i
  ,.sdp_n2cvif_rd_req_pd           (sdp_n2cvif_rd_req_pd[78:0])        //|> o
  ,.sdp_n2mcif_rd_cdt_lat_fifo_pop (sdp_n2mcif_rd_cdt_lat_fifo_pop)    //|> o
  ,.sdp_n2mcif_rd_req_valid        (sdp_n2mcif_rd_req_valid)           //|> o
  ,.sdp_n2mcif_rd_req_ready        (sdp_n2mcif_rd_req_ready)           //|< i
  ,.sdp_n2mcif_rd_req_pd           (sdp_n2mcif_rd_req_pd[78:0])        //|> o
  ,.sdp_nrdma2dp_alu_valid         (sdp_nrdma2dp_alu_valid)            //|> o
  ,.sdp_nrdma2dp_alu_ready         (sdp_nrdma2dp_alu_ready)            //|< i
  ,.sdp_nrdma2dp_alu_pd            (sdp_nrdma2dp_alu_pd[256:0])        //|> o
  ,.sdp_nrdma2dp_mul_valid         (sdp_nrdma2dp_mul_valid)            //|> o
  ,.sdp_nrdma2dp_mul_ready         (sdp_nrdma2dp_mul_ready)            //|< i
  ,.sdp_nrdma2dp_mul_pd            (sdp_nrdma2dp_mul_pd[256:0])        //|> o
  ,.reg2dp_batch_number            (reg2dp_batch_number[4:0])          //|< w
  ,.reg2dp_bn_base_addr_high       (reg2dp_bn_base_addr_high[31:0])    //|< w
  ,.reg2dp_bn_base_addr_low        (reg2dp_bn_base_addr_low[26:0])     //|< w
  ,.reg2dp_bn_line_stride          (reg2dp_bn_line_stride[26:0])       //|< w
  ,.reg2dp_bn_surface_stride       (reg2dp_bn_surface_stride[26:0])    //|< w
  ,.reg2dp_channel                 (reg2dp_channel[12:0])              //|< w
  ,.reg2dp_height                  (reg2dp_height[12:0])               //|< w
  ,.reg2dp_nrdma_data_mode         (reg2dp_nrdma_data_mode)            //|< w
  ,.reg2dp_nrdma_data_size         (reg2dp_nrdma_data_size)            //|< w
  ,.reg2dp_nrdma_data_use          (reg2dp_nrdma_data_use[1:0])        //|< w
  ,.reg2dp_nrdma_ram_type          (reg2dp_nrdma_ram_type)             //|< w
  ,.reg2dp_op_en                   (nrdma_op_en)                       //|< w
  ,.reg2dp_out_precision           (reg2dp_out_precision[1:0])         //|< w
  ,.reg2dp_perf_dma_en             (reg2dp_perf_dma_en)                //|< w
  ,.reg2dp_proc_precision          (reg2dp_proc_precision[1:0])        //|< w
  ,.reg2dp_width                   (reg2dp_width[12:0])                //|< w
  ,.reg2dp_winograd                (reg2dp_winograd)                   //|< w
  ,.dp2reg_done                    (nrdma_done)                        //|> w
  ,.dp2reg_nrdma_stall             (dp2reg_nrdma_stall[31:0])          //|> w
  ,.dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)               //|< i
  ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)            //|< i
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)     //|< i
  ,.nrdma_slcg_op_en               (nrdma_slcg_op_en)                  //|< w
  ,.nrdma_disable                  (nrdma_disable)                     //|< w
  );

NV_NVDLA_SDP_erdma u_erdma (
   .nvdla_core_clk                 (nvdla_core_clk)                    //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                   //|< i
  ,.cvif2sdp_e_rd_rsp_valid        (cvif2sdp_e_rd_rsp_valid)           //|< i
  ,.cvif2sdp_e_rd_rsp_ready        (cvif2sdp_e_rd_rsp_ready)           //|> o
  ,.cvif2sdp_e_rd_rsp_pd           (cvif2sdp_e_rd_rsp_pd[513:0])       //|< i
  ,.mcif2sdp_e_rd_rsp_valid        (mcif2sdp_e_rd_rsp_valid)           //|< i
  ,.mcif2sdp_e_rd_rsp_ready        (mcif2sdp_e_rd_rsp_ready)           //|> o
  ,.mcif2sdp_e_rd_rsp_pd           (mcif2sdp_e_rd_rsp_pd[513:0])       //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])               //|< i
  ,.sdp_e2cvif_rd_cdt_lat_fifo_pop (sdp_e2cvif_rd_cdt_lat_fifo_pop)    //|> o
  ,.sdp_e2cvif_rd_req_valid        (sdp_e2cvif_rd_req_valid)           //|> o
  ,.sdp_e2cvif_rd_req_ready        (sdp_e2cvif_rd_req_ready)           //|< i
  ,.sdp_e2cvif_rd_req_pd           (sdp_e2cvif_rd_req_pd[78:0])        //|> o
  ,.sdp_e2mcif_rd_cdt_lat_fifo_pop (sdp_e2mcif_rd_cdt_lat_fifo_pop)    //|> o
  ,.sdp_e2mcif_rd_req_valid        (sdp_e2mcif_rd_req_valid)           //|> o
  ,.sdp_e2mcif_rd_req_ready        (sdp_e2mcif_rd_req_ready)           //|< i
  ,.sdp_e2mcif_rd_req_pd           (sdp_e2mcif_rd_req_pd[78:0])        //|> o
  ,.sdp_erdma2dp_alu_valid         (sdp_erdma2dp_alu_valid)            //|> o
  ,.sdp_erdma2dp_alu_ready         (sdp_erdma2dp_alu_ready)            //|< i
  ,.sdp_erdma2dp_alu_pd            (sdp_erdma2dp_alu_pd[256:0])        //|> o
  ,.sdp_erdma2dp_mul_valid         (sdp_erdma2dp_mul_valid)            //|> o
  ,.sdp_erdma2dp_mul_ready         (sdp_erdma2dp_mul_ready)            //|< i
  ,.sdp_erdma2dp_mul_pd            (sdp_erdma2dp_mul_pd[256:0])        //|> o
  ,.reg2dp_batch_number            (reg2dp_batch_number[4:0])          //|< w
  ,.reg2dp_channel                 (reg2dp_channel[12:0])              //|< w
  ,.reg2dp_erdma_data_mode         (reg2dp_erdma_data_mode)            //|< w
  ,.reg2dp_erdma_data_size         (reg2dp_erdma_data_size)            //|< w
  ,.reg2dp_erdma_data_use          (reg2dp_erdma_data_use[1:0])        //|< w
  ,.reg2dp_erdma_ram_type          (reg2dp_erdma_ram_type)             //|< w
  ,.reg2dp_ew_base_addr_high       (reg2dp_ew_base_addr_high[31:0])    //|< w
  ,.reg2dp_ew_base_addr_low        (reg2dp_ew_base_addr_low[26:0])     //|< w
  ,.reg2dp_ew_line_stride          (reg2dp_ew_line_stride[26:0])       //|< w
  ,.reg2dp_ew_surface_stride       (reg2dp_ew_surface_stride[26:0])    //|< w
  ,.reg2dp_height                  (reg2dp_height[12:0])               //|< w
  ,.reg2dp_op_en                   (erdma_op_en)                       //|< w
  ,.reg2dp_out_precision           (reg2dp_out_precision[1:0])         //|< w
  ,.reg2dp_perf_dma_en             (reg2dp_perf_dma_en)                //|< w
  ,.reg2dp_proc_precision          (reg2dp_proc_precision[1:0])        //|< w
  ,.reg2dp_width                   (reg2dp_width[12:0])                //|< w
  ,.reg2dp_winograd                (reg2dp_winograd)                   //|< w
  ,.dp2reg_done                    (erdma_done)                        //|> w
  ,.dp2reg_erdma_stall             (dp2reg_erdma_stall[31:0])          //|> w
  ,.dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)               //|< i
  ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)            //|< i
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)     //|< i
  ,.erdma_slcg_op_en               (erdma_slcg_op_en)                  //|< w
  ,.erdma_disable                  (erdma_disable)                     //|< w
  );

//&Instance NV_NVDLA_SDP_erdma;

//=======================================
// Configuration Register File
assign mrdma_slcg_op_en = slcg_op_en[0];
assign brdma_slcg_op_en = slcg_op_en[1];
assign nrdma_slcg_op_en = slcg_op_en[2];
assign erdma_slcg_op_en = slcg_op_en[3];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mrdma_done_pending <= 1'b0;
  end else begin
   if (dp2reg_done) begin
      mrdma_done_pending <= 1'b0;
   end else if (mrdma_done) begin
      mrdma_done_pending <= 1'b1;
   end
  end
end
assign mrdma_op_en = reg2dp_op_en & ~mrdma_done_pending & ~mrdma_disable;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    brdma_done_pending <= 1'b0;
  end else begin
   if (dp2reg_done) begin
      brdma_done_pending <= 1'b0;
   end else if (brdma_done) begin
      brdma_done_pending <= 1'b1;
   end
  end
end
assign brdma_op_en = reg2dp_op_en & ~brdma_done_pending & ~brdma_disable;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    nrdma_done_pending <= 1'b0;
  end else begin
   if (dp2reg_done) begin
      nrdma_done_pending <= 1'b0;
   end else if (nrdma_done) begin
      nrdma_done_pending <= 1'b1;
   end
  end
end
assign nrdma_op_en = reg2dp_op_en & ~nrdma_done_pending & ~nrdma_disable;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    erdma_done_pending <= 1'b0;
  end else begin
   if (dp2reg_done) begin
      erdma_done_pending <= 1'b0;
   end else if (erdma_done) begin
      erdma_done_pending <= 1'b1;
   end
  end
end
assign erdma_op_en = reg2dp_op_en & ~erdma_done_pending & ~erdma_disable;
assign dp2reg_done = reg2dp_op_en & ((mrdma_done_pending || mrdma_done || mrdma_disable)&(brdma_done_pending || brdma_done || brdma_disable)&(nrdma_done_pending || nrdma_done || nrdma_disable)&(erdma_done_pending || erdma_done || erdma_disable));
assign mrdma_disable = reg2dp_flying_mode == 1'h1 ;
assign brdma_disable = reg2dp_brdma_disable == 1'h1 ;
assign nrdma_disable = reg2dp_nrdma_disable == 1'h1 ;
assign erdma_disable = reg2dp_erdma_disable == 1'h1 ;

NV_NVDLA_SDP_RDMA_reg u_reg (
   .nvdla_core_clk                 (nvdla_core_clk)                    //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                   //|< i
  ,.csb2sdp_rdma_req_pd            (csb2sdp_rdma_req_pd[62:0])         //|< i
  ,.csb2sdp_rdma_req_pvld          (csb2sdp_rdma_req_pvld)             //|< i
  ,.dp2reg_brdma_stall             (dp2reg_brdma_stall[31:0])          //|< w
  ,.dp2reg_done                    (dp2reg_done)                       //|< w
  ,.dp2reg_erdma_stall             (dp2reg_erdma_stall[31:0])          //|< w
  ,.dp2reg_mrdma_stall             (dp2reg_mrdma_stall[31:0])          //|< w
  ,.dp2reg_nrdma_stall             (dp2reg_nrdma_stall[31:0])          //|< w
  ,.dp2reg_status_inf_input_num    (dp2reg_status_inf_input_num[31:0]) //|< w
  ,.dp2reg_status_nan_input_num    (dp2reg_status_nan_input_num[31:0]) //|< w
  ,.csb2sdp_rdma_req_prdy          (csb2sdp_rdma_req_prdy)             //|> o
  ,.reg2dp_batch_number            (reg2dp_batch_number[4:0])          //|> w
  ,.reg2dp_bn_base_addr_high       (reg2dp_bn_base_addr_high[31:0])    //|> w
  ,.reg2dp_bn_base_addr_low        (reg2dp_bn_base_addr_low[26:0])     //|> w
  ,.reg2dp_bn_batch_stride         (reg2dp_bn_batch_stride[26:0])      //|> w *
  ,.reg2dp_bn_line_stride          (reg2dp_bn_line_stride[26:0])       //|> w
  ,.reg2dp_bn_surface_stride       (reg2dp_bn_surface_stride[26:0])    //|> w
  ,.reg2dp_brdma_data_mode         (reg2dp_brdma_data_mode)            //|> w
  ,.reg2dp_brdma_data_size         (reg2dp_brdma_data_size)            //|> w
  ,.reg2dp_brdma_data_use          (reg2dp_brdma_data_use[1:0])        //|> w
  ,.reg2dp_brdma_disable           (reg2dp_brdma_disable)              //|> w
  ,.reg2dp_brdma_ram_type          (reg2dp_brdma_ram_type)             //|> w
  ,.reg2dp_bs_base_addr_high       (reg2dp_bs_base_addr_high[31:0])    //|> w
  ,.reg2dp_bs_base_addr_low        (reg2dp_bs_base_addr_low[26:0])     //|> w
  ,.reg2dp_bs_batch_stride         (reg2dp_bs_batch_stride[26:0])      //|> w *
  ,.reg2dp_bs_line_stride          (reg2dp_bs_line_stride[26:0])       //|> w
  ,.reg2dp_bs_surface_stride       (reg2dp_bs_surface_stride[26:0])    //|> w
  ,.reg2dp_channel                 (reg2dp_channel[12:0])              //|> w
  ,.reg2dp_erdma_data_mode         (reg2dp_erdma_data_mode)            //|> w
  ,.reg2dp_erdma_data_size         (reg2dp_erdma_data_size)            //|> w
  ,.reg2dp_erdma_data_use          (reg2dp_erdma_data_use[1:0])        //|> w
  ,.reg2dp_erdma_disable           (reg2dp_erdma_disable)              //|> w
  ,.reg2dp_erdma_ram_type          (reg2dp_erdma_ram_type)             //|> w
  ,.reg2dp_ew_base_addr_high       (reg2dp_ew_base_addr_high[31:0])    //|> w
  ,.reg2dp_ew_base_addr_low        (reg2dp_ew_base_addr_low[26:0])     //|> w
  ,.reg2dp_ew_batch_stride         (reg2dp_ew_batch_stride[26:0])      //|> w *
  ,.reg2dp_ew_line_stride          (reg2dp_ew_line_stride[26:0])       //|> w
  ,.reg2dp_ew_surface_stride       (reg2dp_ew_surface_stride[26:0])    //|> w
  ,.reg2dp_flying_mode             (reg2dp_flying_mode)                //|> w
  ,.reg2dp_height                  (reg2dp_height[12:0])               //|> w
  ,.reg2dp_in_precision            (reg2dp_in_precision[1:0])          //|> w
  ,.reg2dp_nrdma_data_mode         (reg2dp_nrdma_data_mode)            //|> w
  ,.reg2dp_nrdma_data_size         (reg2dp_nrdma_data_size)            //|> w
  ,.reg2dp_nrdma_data_use          (reg2dp_nrdma_data_use[1:0])        //|> w
  ,.reg2dp_nrdma_disable           (reg2dp_nrdma_disable)              //|> w
  ,.reg2dp_nrdma_ram_type          (reg2dp_nrdma_ram_type)             //|> w
  ,.reg2dp_op_en                   (reg2dp_op_en)                      //|> w
  ,.reg2dp_out_precision           (reg2dp_out_precision[1:0])         //|> w
  ,.reg2dp_perf_dma_en             (reg2dp_perf_dma_en)                //|> w
  ,.reg2dp_perf_nan_inf_count_en   (reg2dp_perf_nan_inf_count_en)      //|> w
  ,.reg2dp_proc_precision          (reg2dp_proc_precision[1:0])        //|> w
  ,.reg2dp_src_base_addr_high      (reg2dp_src_base_addr_high[31:0])   //|> w
  ,.reg2dp_src_base_addr_low       (reg2dp_src_base_addr_low[26:0])    //|> w
  ,.reg2dp_src_line_stride         (reg2dp_src_line_stride[26:0])      //|> w
  ,.reg2dp_src_ram_type            (reg2dp_src_ram_type)               //|> w
  ,.reg2dp_src_surface_stride      (reg2dp_src_surface_stride[26:0])   //|> w
  ,.reg2dp_width                   (reg2dp_width[12:0])                //|> w
  ,.reg2dp_winograd                (reg2dp_winograd)                   //|> w
  ,.sdp_rdma2csb_resp_pd           (sdp_rdma2csb_resp_pd[33:0])        //|> o
  ,.sdp_rdma2csb_resp_valid        (sdp_rdma2csb_resp_valid)           //|> o
  ,.slcg_op_en                     (slcg_op_en[3:0])                   //|> w
  );


//===================================
// Function Coverage
 
endmodule // NV_NVDLA_SDP_rdma

