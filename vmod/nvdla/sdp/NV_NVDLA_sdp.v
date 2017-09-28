// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_sdp.v

module NV_NVDLA_sdp (
   cacc2sdp_pd                    //|< i
  ,cacc2sdp_valid                 //|< i
  ,csb2sdp_rdma_req_pd            //|< i
  ,csb2sdp_rdma_req_pvld          //|< i
  ,csb2sdp_req_pd                 //|< i
  ,csb2sdp_req_pvld               //|< i
  ,cvif2sdp_b_rd_rsp_pd           //|< i
  ,cvif2sdp_b_rd_rsp_valid        //|< i
  ,cvif2sdp_e_rd_rsp_pd           //|< i
  ,cvif2sdp_e_rd_rsp_valid        //|< i
  ,cvif2sdp_n_rd_rsp_pd           //|< i
  ,cvif2sdp_n_rd_rsp_valid        //|< i
  ,cvif2sdp_rd_rsp_pd             //|< i
  ,cvif2sdp_rd_rsp_valid          //|< i
  ,cvif2sdp_wr_rsp_complete       //|< i
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
  ,mcif2sdp_wr_rsp_complete       //|< i
  ,nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,pwrbus_ram_pd                  //|< i
  ,sdp2cvif_rd_req_ready          //|< i
  ,sdp2cvif_wr_req_ready          //|< i
  ,sdp2mcif_rd_req_ready          //|< i
  ,sdp2mcif_wr_req_ready          //|< i
  ,sdp2pdp_ready                  //|< i
  ,sdp_b2cvif_rd_req_ready        //|< i
  ,sdp_b2mcif_rd_req_ready        //|< i
  ,sdp_e2cvif_rd_req_ready        //|< i
  ,sdp_e2mcif_rd_req_ready        //|< i
  ,sdp_n2cvif_rd_req_ready        //|< i
  ,sdp_n2mcif_rd_req_ready        //|< i
  ,tmc2slcg_disable_clock_gating  //|< i
  ,cacc2sdp_ready                 //|> o
  ,csb2sdp_rdma_req_prdy          //|> o
  ,csb2sdp_req_prdy               //|> o
  ,cvif2sdp_b_rd_rsp_ready        //|> o
  ,cvif2sdp_e_rd_rsp_ready        //|> o
  ,cvif2sdp_n_rd_rsp_ready        //|> o
  ,cvif2sdp_rd_rsp_ready          //|> o
  ,mcif2sdp_b_rd_rsp_ready        //|> o
  ,mcif2sdp_e_rd_rsp_ready        //|> o
  ,mcif2sdp_n_rd_rsp_ready        //|> o
  ,mcif2sdp_rd_rsp_ready          //|> o
  ,sdp2csb_resp_pd                //|> o
  ,sdp2csb_resp_valid             //|> o
  ,sdp2cvif_rd_cdt_lat_fifo_pop   //|> o
  ,sdp2cvif_rd_req_pd             //|> o
  ,sdp2cvif_rd_req_valid          //|> o
  ,sdp2cvif_wr_req_pd             //|> o
  ,sdp2cvif_wr_req_valid          //|> o
  ,sdp2glb_done_intr_pd           //|> o
  ,sdp2mcif_rd_cdt_lat_fifo_pop   //|> o
  ,sdp2mcif_rd_req_pd             //|> o
  ,sdp2mcif_rd_req_valid          //|> o
  ,sdp2mcif_wr_req_pd             //|> o
  ,sdp2mcif_wr_req_valid          //|> o
  ,sdp2pdp_pd                     //|> o
  ,sdp2pdp_valid                  //|> o
  ,sdp_b2cvif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_b2cvif_rd_req_pd           //|> o
  ,sdp_b2cvif_rd_req_valid        //|> o
  ,sdp_b2mcif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_b2mcif_rd_req_pd           //|> o
  ,sdp_b2mcif_rd_req_valid        //|> o
  ,sdp_e2cvif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_e2cvif_rd_req_pd           //|> o
  ,sdp_e2cvif_rd_req_valid        //|> o
  ,sdp_e2mcif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_e2mcif_rd_req_pd           //|> o
  ,sdp_e2mcif_rd_req_valid        //|> o
  ,sdp_n2cvif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_n2cvif_rd_req_pd           //|> o
  ,sdp_n2cvif_rd_req_valid        //|> o
  ,sdp_n2mcif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_n2mcif_rd_req_pd           //|> o
  ,sdp_n2mcif_rd_req_valid        //|> o
  ,sdp_rdma2csb_resp_pd           //|> o
  ,sdp_rdma2csb_resp_valid        //|> o
  );

//
// NV_NVDLA_sdp_ports.v
//
input  nvdla_core_clk;   /* cacc2sdp, csb2sdp_rdma_req, csb2sdp_req, cvif2sdp_b_rd_rsp, cvif2sdp_e_rd_rsp, cvif2sdp_n_rd_rsp, cvif2sdp_rd_rsp, cvif2sdp_wr_rsp, mcif2sdp_b_rd_rsp, mcif2sdp_e_rd_rsp, mcif2sdp_n_rd_rsp, mcif2sdp_rd_rsp, mcif2sdp_wr_rsp, sdp2csb_resp, sdp2cvif_rd_cdt, sdp2cvif_rd_req, sdp2cvif_wr_req, sdp2glb_done_intr, sdp2mcif_rd_cdt, sdp2mcif_rd_req, sdp2mcif_wr_req, sdp2pdp, sdp_b2cvif_rd_cdt, sdp_b2cvif_rd_req, sdp_b2mcif_rd_cdt, sdp_b2mcif_rd_req, sdp_e2cvif_rd_cdt, sdp_e2cvif_rd_req, sdp_e2mcif_rd_cdt, sdp_e2mcif_rd_req, sdp_n2cvif_rd_cdt, sdp_n2cvif_rd_req, sdp_n2mcif_rd_cdt, sdp_n2mcif_rd_req, sdp_rdma2csb_resp */
input  nvdla_core_rstn;  /* cacc2sdp, csb2sdp_rdma_req, csb2sdp_req, cvif2sdp_b_rd_rsp, cvif2sdp_e_rd_rsp, cvif2sdp_n_rd_rsp, cvif2sdp_rd_rsp, cvif2sdp_wr_rsp, mcif2sdp_b_rd_rsp, mcif2sdp_e_rd_rsp, mcif2sdp_n_rd_rsp, mcif2sdp_rd_rsp, mcif2sdp_wr_rsp, sdp2csb_resp, sdp2cvif_rd_cdt, sdp2cvif_rd_req, sdp2cvif_wr_req, sdp2glb_done_intr, sdp2mcif_rd_cdt, sdp2mcif_rd_req, sdp2mcif_wr_req, sdp2pdp, sdp_b2cvif_rd_cdt, sdp_b2cvif_rd_req, sdp_b2mcif_rd_cdt, sdp_b2mcif_rd_req, sdp_e2cvif_rd_cdt, sdp_e2cvif_rd_req, sdp_e2mcif_rd_cdt, sdp_e2mcif_rd_req, sdp_n2cvif_rd_cdt, sdp_n2cvif_rd_req, sdp_n2mcif_rd_cdt, sdp_n2mcif_rd_req, sdp_rdma2csb_resp */

input          cacc2sdp_valid;  /* data valid */
output         cacc2sdp_ready;  /* data return handshake */
input  [513:0] cacc2sdp_pd;

input         csb2sdp_rdma_req_pvld;  /* data valid */
output        csb2sdp_rdma_req_prdy;  /* data return handshake */
input  [62:0] csb2sdp_rdma_req_pd;

input         csb2sdp_req_pvld;  /* data valid */
output        csb2sdp_req_prdy;  /* data return handshake */
input  [62:0] csb2sdp_req_pd;

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

input  cvif2sdp_wr_rsp_complete;

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

input  mcif2sdp_wr_rsp_complete;

input [31:0] pwrbus_ram_pd;

output        sdp2csb_resp_valid;  /* data valid */
output [33:0] sdp2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output  sdp2cvif_rd_cdt_lat_fifo_pop;

output        sdp2cvif_rd_req_valid;  /* data valid */
input         sdp2cvif_rd_req_ready;  /* data return handshake */
output [78:0] sdp2cvif_rd_req_pd;

output         sdp2cvif_wr_req_valid;  /* data valid */
input          sdp2cvif_wr_req_ready;  /* data return handshake */
output [514:0] sdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

output [1:0] sdp2glb_done_intr_pd;

output  sdp2mcif_rd_cdt_lat_fifo_pop;

output        sdp2mcif_rd_req_valid;  /* data valid */
input         sdp2mcif_rd_req_ready;  /* data return handshake */
output [78:0] sdp2mcif_rd_req_pd;

output         sdp2mcif_wr_req_valid;  /* data valid */
input          sdp2mcif_wr_req_ready;  /* data return handshake */
output [514:0] sdp2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

output         sdp2pdp_valid;  /* data valid */
input          sdp2pdp_ready;  /* data return handshake */
output [255:0] sdp2pdp_pd;

output  sdp_b2cvif_rd_cdt_lat_fifo_pop;

output        sdp_b2cvif_rd_req_valid;  /* data valid */
input         sdp_b2cvif_rd_req_ready;  /* data return handshake */
output [78:0] sdp_b2cvif_rd_req_pd;

output  sdp_b2mcif_rd_cdt_lat_fifo_pop;

output        sdp_b2mcif_rd_req_valid;  /* data valid */
input         sdp_b2mcif_rd_req_ready;  /* data return handshake */
output [78:0] sdp_b2mcif_rd_req_pd;

output  sdp_e2cvif_rd_cdt_lat_fifo_pop;

output        sdp_e2cvif_rd_req_valid;  /* data valid */
input         sdp_e2cvif_rd_req_ready;  /* data return handshake */
output [78:0] sdp_e2cvif_rd_req_pd;

output  sdp_e2mcif_rd_cdt_lat_fifo_pop;

output        sdp_e2mcif_rd_req_valid;  /* data valid */
input         sdp_e2mcif_rd_req_ready;  /* data return handshake */
output [78:0] sdp_e2mcif_rd_req_pd;

output  sdp_n2cvif_rd_cdt_lat_fifo_pop;

output        sdp_n2cvif_rd_req_valid;  /* data valid */
input         sdp_n2cvif_rd_req_ready;  /* data return handshake */
output [78:0] sdp_n2cvif_rd_req_pd;

output  sdp_n2mcif_rd_cdt_lat_fifo_pop;

output        sdp_n2mcif_rd_req_valid;  /* data valid */
input         sdp_n2mcif_rd_req_ready;  /* data return handshake */
output [78:0] sdp_n2mcif_rd_req_pd;

output        sdp_rdma2csb_resp_valid;  /* data valid */
output [33:0] sdp_rdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input         dla_clk_ovr_on_sync;
input         global_clk_ovr_on_sync;
input         tmc2slcg_disable_clock_gating;
wire          dp2reg_done;
wire   [31:0] dp2reg_lut_hybrid;
wire   [15:0] dp2reg_lut_int_data;
wire   [31:0] dp2reg_lut_le_hit;
wire   [31:0] dp2reg_lut_lo_hit;
wire   [31:0] dp2reg_lut_oflow;
wire   [31:0] dp2reg_lut_uflow;
wire   [31:0] dp2reg_out_saturation;
wire   [31:0] dp2reg_status_nan_output_num;
wire    [0:0] dp2reg_status_unequal;
wire   [31:0] dp2reg_wdma_stall;
wire    [4:0] reg2dp_batch_number;
wire          reg2dp_bcore_slcg_op_en;
wire    [1:0] reg2dp_bn_alu_algo;
wire          reg2dp_bn_alu_bypass;
wire   [15:0] reg2dp_bn_alu_operand;
wire    [5:0] reg2dp_bn_alu_shift_value;
wire          reg2dp_bn_alu_src;
wire          reg2dp_bn_bypass;
wire          reg2dp_bn_mul_bypass;
wire   [15:0] reg2dp_bn_mul_operand;
wire          reg2dp_bn_mul_prelu;
wire    [7:0] reg2dp_bn_mul_shift_value;
wire          reg2dp_bn_mul_src;
wire          reg2dp_bn_relu_bypass;
wire    [1:0] reg2dp_bs_alu_algo;
wire          reg2dp_bs_alu_bypass;
wire   [15:0] reg2dp_bs_alu_operand;
wire    [5:0] reg2dp_bs_alu_shift_value;
wire          reg2dp_bs_alu_src;
wire          reg2dp_bs_bypass;
wire          reg2dp_bs_mul_bypass;
wire   [15:0] reg2dp_bs_mul_operand;
wire          reg2dp_bs_mul_prelu;
wire    [7:0] reg2dp_bs_mul_shift_value;
wire          reg2dp_bs_mul_src;
wire          reg2dp_bs_relu_bypass;
wire   [12:0] reg2dp_channel;
wire   [31:0] reg2dp_cvt_offset;
wire   [15:0] reg2dp_cvt_scale;
wire    [5:0] reg2dp_cvt_shift;
wire   [31:0] reg2dp_dst_base_addr_high;
wire   [26:0] reg2dp_dst_base_addr_low;
wire   [26:0] reg2dp_dst_batch_stride;
wire   [26:0] reg2dp_dst_line_stride;
wire          reg2dp_dst_ram_type;
wire   [26:0] reg2dp_dst_surface_stride;
wire          reg2dp_ecore_slcg_op_en;
wire    [1:0] reg2dp_ew_alu_algo;
wire          reg2dp_ew_alu_bypass;
wire          reg2dp_ew_alu_cvt_bypass;
wire   [31:0] reg2dp_ew_alu_cvt_offset;
wire   [15:0] reg2dp_ew_alu_cvt_scale;
wire    [5:0] reg2dp_ew_alu_cvt_truncate;
wire   [31:0] reg2dp_ew_alu_operand;
wire          reg2dp_ew_alu_src;
wire          reg2dp_ew_bypass;
wire          reg2dp_ew_lut_bypass;
wire          reg2dp_ew_mul_bypass;
wire          reg2dp_ew_mul_cvt_bypass;
wire   [31:0] reg2dp_ew_mul_cvt_offset;
wire   [15:0] reg2dp_ew_mul_cvt_scale;
wire    [5:0] reg2dp_ew_mul_cvt_truncate;
wire   [31:0] reg2dp_ew_mul_operand;
wire          reg2dp_ew_mul_prelu;
wire          reg2dp_ew_mul_src;
wire    [9:0] reg2dp_ew_truncate;
wire          reg2dp_flying_mode;
wire   [12:0] reg2dp_height;
wire          reg2dp_interrupt_ptr;
wire          reg2dp_lut_hybrid_priority;
wire          reg2dp_lut_int_access_type;
wire    [9:0] reg2dp_lut_int_addr;
wire   [15:0] reg2dp_lut_int_data;
wire          reg2dp_lut_int_data_wr;
wire          reg2dp_lut_int_table_id;
wire   [31:0] reg2dp_lut_le_end;
wire          reg2dp_lut_le_function;
wire    [7:0] reg2dp_lut_le_index_offset;
wire    [7:0] reg2dp_lut_le_index_select;
wire   [15:0] reg2dp_lut_le_slope_oflow_scale;
wire    [4:0] reg2dp_lut_le_slope_oflow_shift;
wire   [15:0] reg2dp_lut_le_slope_uflow_scale;
wire    [4:0] reg2dp_lut_le_slope_uflow_shift;
wire   [31:0] reg2dp_lut_le_start;
wire   [31:0] reg2dp_lut_lo_end;
wire    [7:0] reg2dp_lut_lo_index_select;
wire   [15:0] reg2dp_lut_lo_slope_oflow_scale;
wire    [4:0] reg2dp_lut_lo_slope_oflow_shift;
wire   [15:0] reg2dp_lut_lo_slope_uflow_scale;
wire    [4:0] reg2dp_lut_lo_slope_uflow_shift;
wire   [31:0] reg2dp_lut_lo_start;
wire          reg2dp_lut_oflow_priority;
wire          reg2dp_lut_slcg_en;
wire          reg2dp_lut_uflow_priority;
wire          reg2dp_nan_to_zero;
wire          reg2dp_ncore_slcg_op_en;
wire          reg2dp_op_en;
wire    [1:0] reg2dp_out_precision;
wire          reg2dp_output_dst;
wire          reg2dp_perf_dma_en;
wire          reg2dp_perf_lut_en;
wire          reg2dp_perf_sat_en;
wire    [1:0] reg2dp_proc_precision;
wire          reg2dp_wdma_slcg_op_en;
wire   [12:0] reg2dp_width;
wire          reg2dp_winograd;
wire  [256:0] sdp_brdma2dp_alu_pd;
wire          sdp_brdma2dp_alu_ready;
wire          sdp_brdma2dp_alu_valid;
wire  [256:0] sdp_brdma2dp_mul_pd;
wire          sdp_brdma2dp_mul_ready;
wire          sdp_brdma2dp_mul_valid;
wire  [255:0] sdp_dp2wdma_pd;
wire          sdp_dp2wdma_ready;
wire          sdp_dp2wdma_valid;
wire  [256:0] sdp_erdma2dp_alu_pd;
wire          sdp_erdma2dp_alu_ready;
wire          sdp_erdma2dp_alu_valid;
wire  [256:0] sdp_erdma2dp_mul_pd;
wire          sdp_erdma2dp_mul_ready;
wire          sdp_erdma2dp_mul_valid;
wire  [513:0] sdp_mrdma2cmux_pd;
wire          sdp_mrdma2cmux_ready;
wire          sdp_mrdma2cmux_valid;
wire  [256:0] sdp_nrdma2dp_alu_pd;
wire          sdp_nrdma2dp_alu_ready;
wire          sdp_nrdma2dp_alu_valid;
wire  [256:0] sdp_nrdma2dp_mul_pd;
wire          sdp_nrdma2dp_mul_ready;
wire          sdp_nrdma2dp_mul_valid;

//=======================================
//DMA
//---------------------------------------
NV_NVDLA_SDP_rdma u_rdma (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.csb2sdp_rdma_req_pvld           (csb2sdp_rdma_req_pvld)                 //|< i
  ,.csb2sdp_rdma_req_prdy           (csb2sdp_rdma_req_prdy)                 //|> o
  ,.csb2sdp_rdma_req_pd             (csb2sdp_rdma_req_pd[62:0])             //|< i
  ,.cvif2sdp_b_rd_rsp_valid         (cvif2sdp_b_rd_rsp_valid)               //|< i
  ,.cvif2sdp_b_rd_rsp_ready         (cvif2sdp_b_rd_rsp_ready)               //|> o
  ,.cvif2sdp_b_rd_rsp_pd            (cvif2sdp_b_rd_rsp_pd[513:0])           //|< i
  ,.cvif2sdp_e_rd_rsp_valid         (cvif2sdp_e_rd_rsp_valid)               //|< i
  ,.cvif2sdp_e_rd_rsp_ready         (cvif2sdp_e_rd_rsp_ready)               //|> o
  ,.cvif2sdp_e_rd_rsp_pd            (cvif2sdp_e_rd_rsp_pd[513:0])           //|< i
  ,.cvif2sdp_n_rd_rsp_valid         (cvif2sdp_n_rd_rsp_valid)               //|< i
  ,.cvif2sdp_n_rd_rsp_ready         (cvif2sdp_n_rd_rsp_ready)               //|> o
  ,.cvif2sdp_n_rd_rsp_pd            (cvif2sdp_n_rd_rsp_pd[513:0])           //|< i
  ,.cvif2sdp_rd_rsp_valid           (cvif2sdp_rd_rsp_valid)                 //|< i
  ,.cvif2sdp_rd_rsp_ready           (cvif2sdp_rd_rsp_ready)                 //|> o
  ,.cvif2sdp_rd_rsp_pd              (cvif2sdp_rd_rsp_pd[513:0])             //|< i
  ,.mcif2sdp_b_rd_rsp_valid         (mcif2sdp_b_rd_rsp_valid)               //|< i
  ,.mcif2sdp_b_rd_rsp_ready         (mcif2sdp_b_rd_rsp_ready)               //|> o
  ,.mcif2sdp_b_rd_rsp_pd            (mcif2sdp_b_rd_rsp_pd[513:0])           //|< i
  ,.mcif2sdp_e_rd_rsp_valid         (mcif2sdp_e_rd_rsp_valid)               //|< i
  ,.mcif2sdp_e_rd_rsp_ready         (mcif2sdp_e_rd_rsp_ready)               //|> o
  ,.mcif2sdp_e_rd_rsp_pd            (mcif2sdp_e_rd_rsp_pd[513:0])           //|< i
  ,.mcif2sdp_n_rd_rsp_valid         (mcif2sdp_n_rd_rsp_valid)               //|< i
  ,.mcif2sdp_n_rd_rsp_ready         (mcif2sdp_n_rd_rsp_ready)               //|> o
  ,.mcif2sdp_n_rd_rsp_pd            (mcif2sdp_n_rd_rsp_pd[513:0])           //|< i
  ,.mcif2sdp_rd_rsp_valid           (mcif2sdp_rd_rsp_valid)                 //|< i
  ,.mcif2sdp_rd_rsp_ready           (mcif2sdp_rd_rsp_ready)                 //|> o
  ,.mcif2sdp_rd_rsp_pd              (mcif2sdp_rd_rsp_pd[513:0])             //|< i
  ,.pwrbus_ram_pd                   (pwrbus_ram_pd[31:0])                   //|< i
  ,.sdp2cvif_rd_cdt_lat_fifo_pop    (sdp2cvif_rd_cdt_lat_fifo_pop)          //|> o
  ,.sdp2cvif_rd_req_valid           (sdp2cvif_rd_req_valid)                 //|> o
  ,.sdp2cvif_rd_req_ready           (sdp2cvif_rd_req_ready)                 //|< i
  ,.sdp2cvif_rd_req_pd              (sdp2cvif_rd_req_pd[78:0])              //|> o
  ,.sdp2mcif_rd_cdt_lat_fifo_pop    (sdp2mcif_rd_cdt_lat_fifo_pop)          //|> o
  ,.sdp2mcif_rd_req_valid           (sdp2mcif_rd_req_valid)                 //|> o
  ,.sdp2mcif_rd_req_ready           (sdp2mcif_rd_req_ready)                 //|< i
  ,.sdp2mcif_rd_req_pd              (sdp2mcif_rd_req_pd[78:0])              //|> o
  ,.sdp_b2cvif_rd_cdt_lat_fifo_pop  (sdp_b2cvif_rd_cdt_lat_fifo_pop)        //|> o
  ,.sdp_b2cvif_rd_req_valid         (sdp_b2cvif_rd_req_valid)               //|> o
  ,.sdp_b2cvif_rd_req_ready         (sdp_b2cvif_rd_req_ready)               //|< i
  ,.sdp_b2cvif_rd_req_pd            (sdp_b2cvif_rd_req_pd[78:0])            //|> o
  ,.sdp_b2mcif_rd_cdt_lat_fifo_pop  (sdp_b2mcif_rd_cdt_lat_fifo_pop)        //|> o
  ,.sdp_b2mcif_rd_req_valid         (sdp_b2mcif_rd_req_valid)               //|> o
  ,.sdp_b2mcif_rd_req_ready         (sdp_b2mcif_rd_req_ready)               //|< i
  ,.sdp_b2mcif_rd_req_pd            (sdp_b2mcif_rd_req_pd[78:0])            //|> o
  ,.sdp_brdma2dp_alu_valid          (sdp_brdma2dp_alu_valid)                //|> w
  ,.sdp_brdma2dp_alu_ready          (sdp_brdma2dp_alu_ready)                //|< w
  ,.sdp_brdma2dp_alu_pd             (sdp_brdma2dp_alu_pd[256:0])            //|> w
  ,.sdp_brdma2dp_mul_valid          (sdp_brdma2dp_mul_valid)                //|> w
  ,.sdp_brdma2dp_mul_ready          (sdp_brdma2dp_mul_ready)                //|< w
  ,.sdp_brdma2dp_mul_pd             (sdp_brdma2dp_mul_pd[256:0])            //|> w
  ,.sdp_e2cvif_rd_cdt_lat_fifo_pop  (sdp_e2cvif_rd_cdt_lat_fifo_pop)        //|> o
  ,.sdp_e2cvif_rd_req_valid         (sdp_e2cvif_rd_req_valid)               //|> o
  ,.sdp_e2cvif_rd_req_ready         (sdp_e2cvif_rd_req_ready)               //|< i
  ,.sdp_e2cvif_rd_req_pd            (sdp_e2cvif_rd_req_pd[78:0])            //|> o
  ,.sdp_e2mcif_rd_cdt_lat_fifo_pop  (sdp_e2mcif_rd_cdt_lat_fifo_pop)        //|> o
  ,.sdp_e2mcif_rd_req_valid         (sdp_e2mcif_rd_req_valid)               //|> o
  ,.sdp_e2mcif_rd_req_ready         (sdp_e2mcif_rd_req_ready)               //|< i
  ,.sdp_e2mcif_rd_req_pd            (sdp_e2mcif_rd_req_pd[78:0])            //|> o
  ,.sdp_erdma2dp_alu_valid          (sdp_erdma2dp_alu_valid)                //|> w
  ,.sdp_erdma2dp_alu_ready          (sdp_erdma2dp_alu_ready)                //|< w
  ,.sdp_erdma2dp_alu_pd             (sdp_erdma2dp_alu_pd[256:0])            //|> w
  ,.sdp_erdma2dp_mul_valid          (sdp_erdma2dp_mul_valid)                //|> w
  ,.sdp_erdma2dp_mul_ready          (sdp_erdma2dp_mul_ready)                //|< w
  ,.sdp_erdma2dp_mul_pd             (sdp_erdma2dp_mul_pd[256:0])            //|> w
  ,.sdp_mrdma2cmux_valid            (sdp_mrdma2cmux_valid)                  //|> w
  ,.sdp_mrdma2cmux_ready            (sdp_mrdma2cmux_ready)                  //|< w
  ,.sdp_mrdma2cmux_pd               (sdp_mrdma2cmux_pd[513:0])              //|> w
  ,.sdp_n2cvif_rd_cdt_lat_fifo_pop  (sdp_n2cvif_rd_cdt_lat_fifo_pop)        //|> o
  ,.sdp_n2cvif_rd_req_valid         (sdp_n2cvif_rd_req_valid)               //|> o
  ,.sdp_n2cvif_rd_req_ready         (sdp_n2cvif_rd_req_ready)               //|< i
  ,.sdp_n2cvif_rd_req_pd            (sdp_n2cvif_rd_req_pd[78:0])            //|> o
  ,.sdp_n2mcif_rd_cdt_lat_fifo_pop  (sdp_n2mcif_rd_cdt_lat_fifo_pop)        //|> o
  ,.sdp_n2mcif_rd_req_valid         (sdp_n2mcif_rd_req_valid)               //|> o
  ,.sdp_n2mcif_rd_req_ready         (sdp_n2mcif_rd_req_ready)               //|< i
  ,.sdp_n2mcif_rd_req_pd            (sdp_n2mcif_rd_req_pd[78:0])            //|> o
  ,.sdp_nrdma2dp_alu_valid          (sdp_nrdma2dp_alu_valid)                //|> w
  ,.sdp_nrdma2dp_alu_ready          (sdp_nrdma2dp_alu_ready)                //|< w
  ,.sdp_nrdma2dp_alu_pd             (sdp_nrdma2dp_alu_pd[256:0])            //|> w
  ,.sdp_nrdma2dp_mul_valid          (sdp_nrdma2dp_mul_valid)                //|> w
  ,.sdp_nrdma2dp_mul_ready          (sdp_nrdma2dp_mul_ready)                //|< w
  ,.sdp_nrdma2dp_mul_pd             (sdp_nrdma2dp_mul_pd[256:0])            //|> w
  ,.sdp_rdma2csb_resp_valid         (sdp_rdma2csb_resp_valid)               //|> o
  ,.sdp_rdma2csb_resp_pd            (sdp_rdma2csb_resp_pd[33:0])            //|> o
  ,.dla_clk_ovr_on_sync             (dla_clk_ovr_on_sync)                   //|< i
  ,.global_clk_ovr_on_sync          (global_clk_ovr_on_sync)                //|< i
  ,.tmc2slcg_disable_clock_gating   (tmc2slcg_disable_clock_gating)         //|< i
  );

NV_NVDLA_SDP_wdma u_wdma (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.cvif2sdp_wr_rsp_complete        (cvif2sdp_wr_rsp_complete)              //|< i
  ,.mcif2sdp_wr_rsp_complete        (mcif2sdp_wr_rsp_complete)              //|< i
  ,.sdp2cvif_wr_req_valid           (sdp2cvif_wr_req_valid)                 //|> o
  ,.sdp2cvif_wr_req_ready           (sdp2cvif_wr_req_ready)                 //|< i
  ,.sdp2cvif_wr_req_pd              (sdp2cvif_wr_req_pd[514:0])             //|> o
  ,.sdp2glb_done_intr_pd            (sdp2glb_done_intr_pd[1:0])             //|> o
  ,.sdp2mcif_wr_req_valid           (sdp2mcif_wr_req_valid)                 //|> o
  ,.sdp2mcif_wr_req_ready           (sdp2mcif_wr_req_ready)                 //|< i
  ,.sdp2mcif_wr_req_pd              (sdp2mcif_wr_req_pd[514:0])             //|> o
  ,.sdp_dp2wdma_valid               (sdp_dp2wdma_valid)                     //|< w
  ,.sdp_dp2wdma_ready               (sdp_dp2wdma_ready)                     //|> w
  ,.sdp_dp2wdma_pd                  (sdp_dp2wdma_pd[255:0])                 //|< w
  ,.dla_clk_ovr_on_sync             (dla_clk_ovr_on_sync)                   //|< i
  ,.global_clk_ovr_on_sync          (global_clk_ovr_on_sync)                //|< i
  ,.pwrbus_ram_pd                   (pwrbus_ram_pd[31:0])                   //|< i
  ,.reg2dp_batch_number             (reg2dp_batch_number[4:0])              //|< w
  ,.reg2dp_channel                  (reg2dp_channel[12:0])                  //|< w
  ,.reg2dp_dst_base_addr_high       (reg2dp_dst_base_addr_high[31:0])       //|< w
  ,.reg2dp_dst_base_addr_low        (reg2dp_dst_base_addr_low[26:0])        //|< w
  ,.reg2dp_dst_batch_stride         (reg2dp_dst_batch_stride[26:0])         //|< w
  ,.reg2dp_dst_line_stride          (reg2dp_dst_line_stride[26:0])          //|< w
  ,.reg2dp_dst_ram_type             (reg2dp_dst_ram_type)                   //|< w
  ,.reg2dp_dst_surface_stride       (reg2dp_dst_surface_stride[26:0])       //|< w
  ,.reg2dp_ew_alu_algo              (reg2dp_ew_alu_algo[1:0])               //|< w
  ,.reg2dp_ew_alu_bypass            (reg2dp_ew_alu_bypass)                  //|< w
  ,.reg2dp_ew_bypass                (reg2dp_ew_bypass)                      //|< w
  ,.reg2dp_height                   (reg2dp_height[12:0])                   //|< w
  ,.reg2dp_interrupt_ptr            (reg2dp_interrupt_ptr)                  //|< w
  ,.reg2dp_op_en                    (reg2dp_op_en)                          //|< w
  ,.reg2dp_out_precision            (reg2dp_out_precision[1:0])             //|< w
  ,.reg2dp_output_dst               (reg2dp_output_dst)                     //|< w
  ,.reg2dp_perf_dma_en              (reg2dp_perf_dma_en)                    //|< w
  ,.reg2dp_proc_precision           (reg2dp_proc_precision[1:0])            //|< w
  ,.reg2dp_wdma_slcg_op_en          (reg2dp_wdma_slcg_op_en)                //|< w
  ,.reg2dp_width                    (reg2dp_width[12:0])                    //|< w
  ,.reg2dp_winograd                 (reg2dp_winograd)                       //|< w
  ,.tmc2slcg_disable_clock_gating   (tmc2slcg_disable_clock_gating)         //|< i
  ,.dp2reg_done                     (dp2reg_done)                           //|> w
  ,.dp2reg_status_nan_output_num    (dp2reg_status_nan_output_num[31:0])    //|> w
  ,.dp2reg_status_unequal           (dp2reg_status_unequal)                 //|> w
  ,.dp2reg_wdma_stall               (dp2reg_wdma_stall[31:0])               //|> w
  );

//========================================
//SDP core instance
//----------------------------------------
NV_NVDLA_SDP_core u_core (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.sdp_brdma2dp_mul_valid          (sdp_brdma2dp_mul_valid)                //|< w
  ,.sdp_brdma2dp_mul_ready          (sdp_brdma2dp_mul_ready)                //|> w
  ,.sdp_brdma2dp_mul_pd             (sdp_brdma2dp_mul_pd[256:0])            //|< w
  ,.sdp_brdma2dp_alu_valid          (sdp_brdma2dp_alu_valid)                //|< w
  ,.sdp_brdma2dp_alu_ready          (sdp_brdma2dp_alu_ready)                //|> w
  ,.sdp_brdma2dp_alu_pd             (sdp_brdma2dp_alu_pd[256:0])            //|< w
  ,.sdp_nrdma2dp_mul_valid          (sdp_nrdma2dp_mul_valid)                //|< w
  ,.sdp_nrdma2dp_mul_ready          (sdp_nrdma2dp_mul_ready)                //|> w
  ,.sdp_nrdma2dp_mul_pd             (sdp_nrdma2dp_mul_pd[256:0])            //|< w
  ,.sdp_nrdma2dp_alu_valid          (sdp_nrdma2dp_alu_valid)                //|< w
  ,.sdp_nrdma2dp_alu_ready          (sdp_nrdma2dp_alu_ready)                //|> w
  ,.sdp_nrdma2dp_alu_pd             (sdp_nrdma2dp_alu_pd[256:0])            //|< w
  ,.sdp_erdma2dp_mul_valid          (sdp_erdma2dp_mul_valid)                //|< w
  ,.sdp_erdma2dp_mul_ready          (sdp_erdma2dp_mul_ready)                //|> w
  ,.sdp_erdma2dp_mul_pd             (sdp_erdma2dp_mul_pd[256:0])            //|< w
  ,.sdp_erdma2dp_alu_valid          (sdp_erdma2dp_alu_valid)                //|< w
  ,.sdp_erdma2dp_alu_ready          (sdp_erdma2dp_alu_ready)                //|> w
  ,.sdp_erdma2dp_alu_pd             (sdp_erdma2dp_alu_pd[256:0])            //|< w
  ,.sdp_dp2wdma_valid               (sdp_dp2wdma_valid)                     //|> w
  ,.sdp_dp2wdma_ready               (sdp_dp2wdma_ready)                     //|< w
  ,.sdp_dp2wdma_pd                  (sdp_dp2wdma_pd[255:0])                 //|> w
  ,.sdp2pdp_valid                   (sdp2pdp_valid)                         //|> o
  ,.sdp2pdp_ready                   (sdp2pdp_ready)                         //|< i
  ,.sdp2pdp_pd                      (sdp2pdp_pd[255:0])                     //|> o
  ,.pwrbus_ram_pd                   (pwrbus_ram_pd[31:0])                   //|< i
  ,.cacc2sdp_valid                  (cacc2sdp_valid)                        //|< i
  ,.cacc2sdp_ready                  (cacc2sdp_ready)                        //|> o
  ,.cacc2sdp_pd                     (cacc2sdp_pd[513:0])                    //|< i
  ,.sdp_mrdma2cmux_valid            (sdp_mrdma2cmux_valid)                  //|< w
  ,.sdp_mrdma2cmux_ready            (sdp_mrdma2cmux_ready)                  //|> w
  ,.sdp_mrdma2cmux_pd               (sdp_mrdma2cmux_pd[513:0])              //|< w
  ,.reg2dp_bcore_slcg_op_en         (reg2dp_bcore_slcg_op_en)               //|< w
  ,.reg2dp_bn_alu_algo              (reg2dp_bn_alu_algo[1:0])               //|< w
  ,.reg2dp_bn_alu_bypass            (reg2dp_bn_alu_bypass)                  //|< w
  ,.reg2dp_bn_alu_operand           (reg2dp_bn_alu_operand[15:0])           //|< w
  ,.reg2dp_bn_alu_shift_value       (reg2dp_bn_alu_shift_value[5:0])        //|< w
  ,.reg2dp_bn_alu_src               (reg2dp_bn_alu_src)                     //|< w
  ,.reg2dp_bn_bypass                (reg2dp_bn_bypass)                      //|< w
  ,.reg2dp_bn_mul_bypass            (reg2dp_bn_mul_bypass)                  //|< w
  ,.reg2dp_bn_mul_operand           (reg2dp_bn_mul_operand[15:0])           //|< w
  ,.reg2dp_bn_mul_prelu             (reg2dp_bn_mul_prelu)                   //|< w
  ,.reg2dp_bn_mul_shift_value       (reg2dp_bn_mul_shift_value[7:0])        //|< w
  ,.reg2dp_bn_mul_src               (reg2dp_bn_mul_src)                     //|< w
  ,.reg2dp_bn_relu_bypass           (reg2dp_bn_relu_bypass)                 //|< w
  ,.reg2dp_bs_alu_algo              (reg2dp_bs_alu_algo[1:0])               //|< w
  ,.reg2dp_bs_alu_bypass            (reg2dp_bs_alu_bypass)                  //|< w
  ,.reg2dp_bs_alu_operand           (reg2dp_bs_alu_operand[15:0])           //|< w
  ,.reg2dp_bs_alu_shift_value       (reg2dp_bs_alu_shift_value[5:0])        //|< w
  ,.reg2dp_bs_alu_src               (reg2dp_bs_alu_src)                     //|< w
  ,.reg2dp_bs_bypass                (reg2dp_bs_bypass)                      //|< w
  ,.reg2dp_bs_mul_bypass            (reg2dp_bs_mul_bypass)                  //|< w
  ,.reg2dp_bs_mul_operand           (reg2dp_bs_mul_operand[15:0])           //|< w
  ,.reg2dp_bs_mul_prelu             (reg2dp_bs_mul_prelu)                   //|< w
  ,.reg2dp_bs_mul_shift_value       (reg2dp_bs_mul_shift_value[7:0])        //|< w
  ,.reg2dp_bs_mul_src               (reg2dp_bs_mul_src)                     //|< w
  ,.reg2dp_bs_relu_bypass           (reg2dp_bs_relu_bypass)                 //|< w
  ,.reg2dp_cvt_offset               (reg2dp_cvt_offset[31:0])               //|< w
  ,.reg2dp_cvt_scale                (reg2dp_cvt_scale[15:0])                //|< w
  ,.reg2dp_cvt_shift                (reg2dp_cvt_shift[5:0])                 //|< w
  ,.reg2dp_ecore_slcg_op_en         (reg2dp_ecore_slcg_op_en)               //|< w
  ,.reg2dp_ew_alu_algo              (reg2dp_ew_alu_algo[1:0])               //|< w
  ,.reg2dp_ew_alu_bypass            (reg2dp_ew_alu_bypass)                  //|< w
  ,.reg2dp_ew_alu_cvt_bypass        (reg2dp_ew_alu_cvt_bypass)              //|< w
  ,.reg2dp_ew_alu_cvt_offset        (reg2dp_ew_alu_cvt_offset[31:0])        //|< w
  ,.reg2dp_ew_alu_cvt_scale         (reg2dp_ew_alu_cvt_scale[15:0])         //|< w
  ,.reg2dp_ew_alu_cvt_truncate      (reg2dp_ew_alu_cvt_truncate[5:0])       //|< w
  ,.reg2dp_ew_alu_operand           (reg2dp_ew_alu_operand[31:0])           //|< w
  ,.reg2dp_ew_alu_src               (reg2dp_ew_alu_src)                     //|< w
  ,.reg2dp_ew_bypass                (reg2dp_ew_bypass)                      //|< w
  ,.reg2dp_ew_lut_bypass            (reg2dp_ew_lut_bypass)                  //|< w
  ,.reg2dp_ew_mul_bypass            (reg2dp_ew_mul_bypass)                  //|< w
  ,.reg2dp_ew_mul_cvt_bypass        (reg2dp_ew_mul_cvt_bypass)              //|< w
  ,.reg2dp_ew_mul_cvt_offset        (reg2dp_ew_mul_cvt_offset[31:0])        //|< w
  ,.reg2dp_ew_mul_cvt_scale         (reg2dp_ew_mul_cvt_scale[15:0])         //|< w
  ,.reg2dp_ew_mul_cvt_truncate      (reg2dp_ew_mul_cvt_truncate[5:0])       //|< w
  ,.reg2dp_ew_mul_operand           (reg2dp_ew_mul_operand[31:0])           //|< w
  ,.reg2dp_ew_mul_prelu             (reg2dp_ew_mul_prelu)                   //|< w
  ,.reg2dp_ew_mul_src               (reg2dp_ew_mul_src)                     //|< w
  ,.reg2dp_ew_truncate              (reg2dp_ew_truncate[9:0])               //|< w
  ,.reg2dp_flying_mode              (reg2dp_flying_mode)                    //|< w
  ,.reg2dp_lut_hybrid_priority      (reg2dp_lut_hybrid_priority)            //|< w
  ,.reg2dp_lut_int_access_type      (reg2dp_lut_int_access_type)            //|< w
  ,.reg2dp_lut_int_addr             (reg2dp_lut_int_addr[9:0])              //|< w
  ,.reg2dp_lut_int_data             (reg2dp_lut_int_data[15:0])             //|< w
  ,.reg2dp_lut_int_data_wr          (reg2dp_lut_int_data_wr)                //|< w
  ,.reg2dp_lut_int_table_id         (reg2dp_lut_int_table_id)               //|< w
  ,.reg2dp_lut_le_end               (reg2dp_lut_le_end[31:0])               //|< w
  ,.reg2dp_lut_le_function          (reg2dp_lut_le_function)                //|< w
  ,.reg2dp_lut_le_index_offset      (reg2dp_lut_le_index_offset[7:0])       //|< w
  ,.reg2dp_lut_le_index_select      (reg2dp_lut_le_index_select[7:0])       //|< w
  ,.reg2dp_lut_le_slope_oflow_scale (reg2dp_lut_le_slope_oflow_scale[15:0]) //|< w
  ,.reg2dp_lut_le_slope_oflow_shift (reg2dp_lut_le_slope_oflow_shift[4:0])  //|< w
  ,.reg2dp_lut_le_slope_uflow_scale (reg2dp_lut_le_slope_uflow_scale[15:0]) //|< w
  ,.reg2dp_lut_le_slope_uflow_shift (reg2dp_lut_le_slope_uflow_shift[4:0])  //|< w
  ,.reg2dp_lut_le_start             (reg2dp_lut_le_start[31:0])             //|< w
  ,.reg2dp_lut_lo_end               (reg2dp_lut_lo_end[31:0])               //|< w
  ,.reg2dp_lut_lo_index_select      (reg2dp_lut_lo_index_select[7:0])       //|< w
  ,.reg2dp_lut_lo_slope_oflow_scale (reg2dp_lut_lo_slope_oflow_scale[15:0]) //|< w
  ,.reg2dp_lut_lo_slope_oflow_shift (reg2dp_lut_lo_slope_oflow_shift[4:0])  //|< w
  ,.reg2dp_lut_lo_slope_uflow_scale (reg2dp_lut_lo_slope_uflow_scale[15:0]) //|< w
  ,.reg2dp_lut_lo_slope_uflow_shift (reg2dp_lut_lo_slope_uflow_shift[4:0])  //|< w
  ,.reg2dp_lut_lo_start             (reg2dp_lut_lo_start[31:0])             //|< w
  ,.reg2dp_lut_oflow_priority       (reg2dp_lut_oflow_priority)             //|< w
  ,.reg2dp_lut_slcg_en              (reg2dp_lut_slcg_en)                    //|< w
  ,.reg2dp_lut_uflow_priority       (reg2dp_lut_uflow_priority)             //|< w
  ,.reg2dp_nan_to_zero              (reg2dp_nan_to_zero)                    //|< w
  ,.reg2dp_ncore_slcg_op_en         (reg2dp_ncore_slcg_op_en)               //|< w
  ,.reg2dp_op_en                    (reg2dp_op_en)                          //|< w
  ,.reg2dp_out_precision            (reg2dp_out_precision[1:0])             //|< w
  ,.reg2dp_output_dst               (reg2dp_output_dst)                     //|< w
  ,.reg2dp_perf_lut_en              (reg2dp_perf_lut_en)                    //|< w
  ,.reg2dp_perf_sat_en              (reg2dp_perf_sat_en)                    //|< w
  ,.reg2dp_proc_precision           (reg2dp_proc_precision[1:0])            //|< w
  ,.dp2reg_done                     (dp2reg_done)                           //|< w
  ,.dp2reg_lut_hybrid               (dp2reg_lut_hybrid[31:0])               //|> w
  ,.dp2reg_lut_int_data             (dp2reg_lut_int_data[15:0])             //|> w
  ,.dp2reg_lut_le_hit               (dp2reg_lut_le_hit[31:0])               //|> w
  ,.dp2reg_lut_lo_hit               (dp2reg_lut_lo_hit[31:0])               //|> w
  ,.dp2reg_lut_oflow                (dp2reg_lut_oflow[31:0])                //|> w
  ,.dp2reg_lut_uflow                (dp2reg_lut_uflow[31:0])                //|> w
  ,.dp2reg_out_saturation           (dp2reg_out_saturation[31:0])           //|> w
  ,.dla_clk_ovr_on_sync             (dla_clk_ovr_on_sync)                   //|< i
  ,.global_clk_ovr_on_sync          (global_clk_ovr_on_sync)                //|< i
  ,.tmc2slcg_disable_clock_gating   (tmc2slcg_disable_clock_gating)         //|< i
  );

//=======================================
//CONFIG instance
//rdma has seperate config register, while wdma share with core
//---------------------------------------
NV_NVDLA_SDP_reg u_reg (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.csb2sdp_req_pd                  (csb2sdp_req_pd[62:0])                  //|< i
  ,.csb2sdp_req_pvld                (csb2sdp_req_pvld)                      //|< i
  ,.dp2reg_done                     (dp2reg_done)                           //|< w
  ,.dp2reg_lut_hybrid               (dp2reg_lut_hybrid[31:0])               //|< w
  ,.dp2reg_lut_int_data             (dp2reg_lut_int_data[15:0])             //|< w
  ,.dp2reg_lut_le_hit               (dp2reg_lut_le_hit[31:0])               //|< w
  ,.dp2reg_lut_lo_hit               (dp2reg_lut_lo_hit[31:0])               //|< w
  ,.dp2reg_lut_oflow                (dp2reg_lut_oflow[31:0])                //|< w
  ,.dp2reg_lut_uflow                (dp2reg_lut_uflow[31:0])                //|< w
  ,.dp2reg_out_saturation           (dp2reg_out_saturation[31:0])           //|< w
  ,.dp2reg_status_inf_input_num     ({32{1'b0}})                            //|< ?
  ,.dp2reg_status_nan_input_num     ({32{1'b0}})                            //|< ?
  ,.dp2reg_status_nan_output_num    (dp2reg_status_nan_output_num[31:0])    //|< w
  ,.dp2reg_status_unequal           (dp2reg_status_unequal[0])              //|< w
  ,.dp2reg_wdma_stall               (dp2reg_wdma_stall[31:0])               //|< w
  ,.csb2sdp_req_prdy                (csb2sdp_req_prdy)                      //|> o
  ,.reg2dp_batch_number             (reg2dp_batch_number[4:0])              //|> w
  ,.reg2dp_bcore_slcg_op_en         (reg2dp_bcore_slcg_op_en)               //|> w
  ,.reg2dp_bn_alu_algo              (reg2dp_bn_alu_algo[1:0])               //|> w
  ,.reg2dp_bn_alu_bypass            (reg2dp_bn_alu_bypass)                  //|> w
  ,.reg2dp_bn_alu_operand           (reg2dp_bn_alu_operand[15:0])           //|> w
  ,.reg2dp_bn_alu_shift_value       (reg2dp_bn_alu_shift_value[5:0])        //|> w
  ,.reg2dp_bn_alu_src               (reg2dp_bn_alu_src)                     //|> w
  ,.reg2dp_bn_bypass                (reg2dp_bn_bypass)                      //|> w
  ,.reg2dp_bn_mul_bypass            (reg2dp_bn_mul_bypass)                  //|> w
  ,.reg2dp_bn_mul_operand           (reg2dp_bn_mul_operand[15:0])           //|> w
  ,.reg2dp_bn_mul_prelu             (reg2dp_bn_mul_prelu)                   //|> w
  ,.reg2dp_bn_mul_shift_value       (reg2dp_bn_mul_shift_value[7:0])        //|> w
  ,.reg2dp_bn_mul_src               (reg2dp_bn_mul_src)                     //|> w
  ,.reg2dp_bn_relu_bypass           (reg2dp_bn_relu_bypass)                 //|> w
  ,.reg2dp_bs_alu_algo              (reg2dp_bs_alu_algo[1:0])               //|> w
  ,.reg2dp_bs_alu_bypass            (reg2dp_bs_alu_bypass)                  //|> w
  ,.reg2dp_bs_alu_operand           (reg2dp_bs_alu_operand[15:0])           //|> w
  ,.reg2dp_bs_alu_shift_value       (reg2dp_bs_alu_shift_value[5:0])        //|> w
  ,.reg2dp_bs_alu_src               (reg2dp_bs_alu_src)                     //|> w
  ,.reg2dp_bs_bypass                (reg2dp_bs_bypass)                      //|> w
  ,.reg2dp_bs_mul_bypass            (reg2dp_bs_mul_bypass)                  //|> w
  ,.reg2dp_bs_mul_operand           (reg2dp_bs_mul_operand[15:0])           //|> w
  ,.reg2dp_bs_mul_prelu             (reg2dp_bs_mul_prelu)                   //|> w
  ,.reg2dp_bs_mul_shift_value       (reg2dp_bs_mul_shift_value[7:0])        //|> w
  ,.reg2dp_bs_mul_src               (reg2dp_bs_mul_src)                     //|> w
  ,.reg2dp_bs_relu_bypass           (reg2dp_bs_relu_bypass)                 //|> w
  ,.reg2dp_channel                  (reg2dp_channel[12:0])                  //|> w
  ,.reg2dp_cvt_offset               (reg2dp_cvt_offset[31:0])               //|> w
  ,.reg2dp_cvt_scale                (reg2dp_cvt_scale[15:0])                //|> w
  ,.reg2dp_cvt_shift                (reg2dp_cvt_shift[5:0])                 //|> w
  ,.reg2dp_dst_base_addr_high       (reg2dp_dst_base_addr_high[31:0])       //|> w
  ,.reg2dp_dst_base_addr_low        (reg2dp_dst_base_addr_low[26:0])        //|> w
  ,.reg2dp_dst_batch_stride         (reg2dp_dst_batch_stride[26:0])         //|> w
  ,.reg2dp_dst_line_stride          (reg2dp_dst_line_stride[26:0])          //|> w
  ,.reg2dp_dst_ram_type             (reg2dp_dst_ram_type)                   //|> w
  ,.reg2dp_dst_surface_stride       (reg2dp_dst_surface_stride[26:0])       //|> w
  ,.reg2dp_ecore_slcg_op_en         (reg2dp_ecore_slcg_op_en)               //|> w
  ,.reg2dp_ew_alu_algo              (reg2dp_ew_alu_algo[1:0])               //|> w
  ,.reg2dp_ew_alu_bypass            (reg2dp_ew_alu_bypass)                  //|> w
  ,.reg2dp_ew_alu_cvt_bypass        (reg2dp_ew_alu_cvt_bypass)              //|> w
  ,.reg2dp_ew_alu_cvt_offset        (reg2dp_ew_alu_cvt_offset[31:0])        //|> w
  ,.reg2dp_ew_alu_cvt_scale         (reg2dp_ew_alu_cvt_scale[15:0])         //|> w
  ,.reg2dp_ew_alu_cvt_truncate      (reg2dp_ew_alu_cvt_truncate[5:0])       //|> w
  ,.reg2dp_ew_alu_operand           (reg2dp_ew_alu_operand[31:0])           //|> w
  ,.reg2dp_ew_alu_src               (reg2dp_ew_alu_src)                     //|> w
  ,.reg2dp_ew_bypass                (reg2dp_ew_bypass)                      //|> w
  ,.reg2dp_ew_lut_bypass            (reg2dp_ew_lut_bypass)                  //|> w
  ,.reg2dp_ew_mul_bypass            (reg2dp_ew_mul_bypass)                  //|> w
  ,.reg2dp_ew_mul_cvt_bypass        (reg2dp_ew_mul_cvt_bypass)              //|> w
  ,.reg2dp_ew_mul_cvt_offset        (reg2dp_ew_mul_cvt_offset[31:0])        //|> w
  ,.reg2dp_ew_mul_cvt_scale         (reg2dp_ew_mul_cvt_scale[15:0])         //|> w
  ,.reg2dp_ew_mul_cvt_truncate      (reg2dp_ew_mul_cvt_truncate[5:0])       //|> w
  ,.reg2dp_ew_mul_operand           (reg2dp_ew_mul_operand[31:0])           //|> w
  ,.reg2dp_ew_mul_prelu             (reg2dp_ew_mul_prelu)                   //|> w
  ,.reg2dp_ew_mul_src               (reg2dp_ew_mul_src)                     //|> w
  ,.reg2dp_ew_truncate              (reg2dp_ew_truncate[9:0])               //|> w
  ,.reg2dp_flying_mode              (reg2dp_flying_mode)                    //|> w
  ,.reg2dp_height                   (reg2dp_height[12:0])                   //|> w
  ,.reg2dp_interrupt_ptr            (reg2dp_interrupt_ptr)                  //|> w
  ,.reg2dp_lut_hybrid_priority      (reg2dp_lut_hybrid_priority)            //|> w
  ,.reg2dp_lut_int_access_type      (reg2dp_lut_int_access_type)            //|> w
  ,.reg2dp_lut_int_addr             (reg2dp_lut_int_addr[9:0])              //|> w
  ,.reg2dp_lut_int_data             (reg2dp_lut_int_data[15:0])             //|> w
  ,.reg2dp_lut_int_data_wr          (reg2dp_lut_int_data_wr)                //|> w
  ,.reg2dp_lut_int_table_id         (reg2dp_lut_int_table_id)               //|> w
  ,.reg2dp_lut_le_end               (reg2dp_lut_le_end[31:0])               //|> w
  ,.reg2dp_lut_le_function          (reg2dp_lut_le_function)                //|> w
  ,.reg2dp_lut_le_index_offset      (reg2dp_lut_le_index_offset[7:0])       //|> w
  ,.reg2dp_lut_le_index_select      (reg2dp_lut_le_index_select[7:0])       //|> w
  ,.reg2dp_lut_le_slope_oflow_scale (reg2dp_lut_le_slope_oflow_scale[15:0]) //|> w
  ,.reg2dp_lut_le_slope_oflow_shift (reg2dp_lut_le_slope_oflow_shift[4:0])  //|> w
  ,.reg2dp_lut_le_slope_uflow_scale (reg2dp_lut_le_slope_uflow_scale[15:0]) //|> w
  ,.reg2dp_lut_le_slope_uflow_shift (reg2dp_lut_le_slope_uflow_shift[4:0])  //|> w
  ,.reg2dp_lut_le_start             (reg2dp_lut_le_start[31:0])             //|> w
  ,.reg2dp_lut_lo_end               (reg2dp_lut_lo_end[31:0])               //|> w
  ,.reg2dp_lut_lo_index_select      (reg2dp_lut_lo_index_select[7:0])       //|> w
  ,.reg2dp_lut_lo_slope_oflow_scale (reg2dp_lut_lo_slope_oflow_scale[15:0]) //|> w
  ,.reg2dp_lut_lo_slope_oflow_shift (reg2dp_lut_lo_slope_oflow_shift[4:0])  //|> w
  ,.reg2dp_lut_lo_slope_uflow_scale (reg2dp_lut_lo_slope_uflow_scale[15:0]) //|> w
  ,.reg2dp_lut_lo_slope_uflow_shift (reg2dp_lut_lo_slope_uflow_shift[4:0])  //|> w
  ,.reg2dp_lut_lo_start             (reg2dp_lut_lo_start[31:0])             //|> w
  ,.reg2dp_lut_oflow_priority       (reg2dp_lut_oflow_priority)             //|> w
  ,.reg2dp_lut_slcg_en              (reg2dp_lut_slcg_en)                    //|> w
  ,.reg2dp_lut_uflow_priority       (reg2dp_lut_uflow_priority)             //|> w
  ,.reg2dp_nan_to_zero              (reg2dp_nan_to_zero)                    //|> w
  ,.reg2dp_ncore_slcg_op_en         (reg2dp_ncore_slcg_op_en)               //|> w
  ,.reg2dp_op_en                    (reg2dp_op_en)                          //|> w
  ,.reg2dp_out_precision            (reg2dp_out_precision[1:0])             //|> w
  ,.reg2dp_output_dst               (reg2dp_output_dst)                     //|> w
  ,.reg2dp_perf_dma_en              (reg2dp_perf_dma_en)                    //|> w
  ,.reg2dp_perf_lut_en              (reg2dp_perf_lut_en)                    //|> w
  ,.reg2dp_perf_nan_inf_count_en    ()                                      //|> ?
  ,.reg2dp_perf_sat_en              (reg2dp_perf_sat_en)                    //|> w
  ,.reg2dp_proc_precision           (reg2dp_proc_precision[1:0])            //|> w
  ,.reg2dp_wdma_slcg_op_en          (reg2dp_wdma_slcg_op_en)                //|> w
  ,.reg2dp_width                    (reg2dp_width[12:0])                    //|> w
  ,.reg2dp_winograd                 (reg2dp_winograd)                       //|> w
  ,.sdp2csb_resp_pd                 (sdp2csb_resp_pd[33:0])                 //|> o
  ,.sdp2csb_resp_valid              (sdp2csb_resp_valid)                    //|> o
  );

//// SLCG enable
////    my @slcg_ends = qw( mrdma brdma nrdma erdma wdma bcore ncore ecore);
//&PerlBeg;
//    my @slcg_ends = qw( wdma bcore ncore ecore);
//    foreach my $i (0..$#slcg_ends) {
//        my $sig = $slcg_ends[$i]."_slcg_op_en";
//        vprintl "assign $sig = slcg_op_en[$i];";
//    }
//&PerlEnd;


//|
//|

endmodule // NV_NVDLA_sdp

