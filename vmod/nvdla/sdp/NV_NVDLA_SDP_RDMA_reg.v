// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_RDMA_reg.v

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_RDMA_reg (
   nvdla_core_clk               //|< i
  ,nvdla_core_rstn              //|< i
  ,csb2sdp_rdma_req_pd          //|< i
  ,csb2sdp_rdma_req_pvld        //|< i
  ,dp2reg_brdma_stall           //|< i
  ,dp2reg_done                  //|< i
  ,dp2reg_erdma_stall           //|< i
  ,dp2reg_mrdma_stall           //|< i
  ,dp2reg_nrdma_stall           //|< i
  ,dp2reg_status_inf_input_num  //|< i
  ,dp2reg_status_nan_input_num  //|< i
  ,csb2sdp_rdma_req_prdy        //|> o
  ,reg2dp_batch_number          //|> o
  ,reg2dp_bn_base_addr_high     //|> o
  ,reg2dp_bn_base_addr_low      //|> o
  ,reg2dp_bn_batch_stride       //|> o
  ,reg2dp_bn_line_stride        //|> o
  ,reg2dp_bn_surface_stride     //|> o
  ,reg2dp_brdma_data_mode       //|> o
  ,reg2dp_brdma_data_size       //|> o
  ,reg2dp_brdma_data_use        //|> o
  ,reg2dp_brdma_disable         //|> o
  ,reg2dp_brdma_ram_type        //|> o
  ,reg2dp_bs_base_addr_high     //|> o
  ,reg2dp_bs_base_addr_low      //|> o
  ,reg2dp_bs_batch_stride       //|> o
  ,reg2dp_bs_line_stride        //|> o
  ,reg2dp_bs_surface_stride     //|> o
  ,reg2dp_channel               //|> o
  ,reg2dp_erdma_data_mode       //|> o
  ,reg2dp_erdma_data_size       //|> o
  ,reg2dp_erdma_data_use        //|> o
  ,reg2dp_erdma_disable         //|> o
  ,reg2dp_erdma_ram_type        //|> o
  ,reg2dp_ew_base_addr_high     //|> o
  ,reg2dp_ew_base_addr_low      //|> o
  ,reg2dp_ew_batch_stride       //|> o
  ,reg2dp_ew_line_stride        //|> o
  ,reg2dp_ew_surface_stride     //|> o
  ,reg2dp_flying_mode           //|> o
  ,reg2dp_height                //|> o
  ,reg2dp_in_precision          //|> o
  ,reg2dp_nrdma_data_mode       //|> o
  ,reg2dp_nrdma_data_size       //|> o
  ,reg2dp_nrdma_data_use        //|> o
  ,reg2dp_nrdma_disable         //|> o
  ,reg2dp_nrdma_ram_type        //|> o
  ,reg2dp_op_en                 //|> o
  ,reg2dp_out_precision         //|> o
  ,reg2dp_perf_dma_en           //|> o
  ,reg2dp_perf_nan_inf_count_en //|> o
  ,reg2dp_proc_precision        //|> o
  ,reg2dp_src_base_addr_high    //|> o
  ,reg2dp_src_base_addr_low     //|> o
  ,reg2dp_src_line_stride       //|> o
  ,reg2dp_src_ram_type          //|> o
  ,reg2dp_src_surface_stride    //|> o
  ,reg2dp_width                 //|> o
  ,reg2dp_winograd              //|> o
  ,sdp_rdma2csb_resp_pd         //|> o
  ,sdp_rdma2csb_resp_valid      //|> o
  ,slcg_op_en                   //|> o
  );


input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [62:0] csb2sdp_rdma_req_pd;
input         csb2sdp_rdma_req_pvld;
input  [31:0] dp2reg_brdma_stall;
input         dp2reg_done;
input  [31:0] dp2reg_erdma_stall;
input  [31:0] dp2reg_mrdma_stall;
input  [31:0] dp2reg_nrdma_stall;
input  [31:0] dp2reg_status_inf_input_num;
input  [31:0] dp2reg_status_nan_input_num;
output        csb2sdp_rdma_req_prdy;
output  [4:0] reg2dp_batch_number;
output [31:0] reg2dp_bn_base_addr_high;
output [26:0] reg2dp_bn_base_addr_low;
output [26:0] reg2dp_bn_batch_stride;
output [26:0] reg2dp_bn_line_stride;
output [26:0] reg2dp_bn_surface_stride;
output        reg2dp_brdma_data_mode;
output        reg2dp_brdma_data_size;
output  [1:0] reg2dp_brdma_data_use;
output        reg2dp_brdma_disable;
output        reg2dp_brdma_ram_type;
output [31:0] reg2dp_bs_base_addr_high;
output [26:0] reg2dp_bs_base_addr_low;
output [26:0] reg2dp_bs_batch_stride;
output [26:0] reg2dp_bs_line_stride;
output [26:0] reg2dp_bs_surface_stride;
output [12:0] reg2dp_channel;
output        reg2dp_erdma_data_mode;
output        reg2dp_erdma_data_size;
output  [1:0] reg2dp_erdma_data_use;
output        reg2dp_erdma_disable;
output        reg2dp_erdma_ram_type;
output [31:0] reg2dp_ew_base_addr_high;
output [26:0] reg2dp_ew_base_addr_low;
output [26:0] reg2dp_ew_batch_stride;
output [26:0] reg2dp_ew_line_stride;
output [26:0] reg2dp_ew_surface_stride;
output        reg2dp_flying_mode;
output [12:0] reg2dp_height;
output  [1:0] reg2dp_in_precision;
output        reg2dp_nrdma_data_mode;
output        reg2dp_nrdma_data_size;
output  [1:0] reg2dp_nrdma_data_use;
output        reg2dp_nrdma_disable;
output        reg2dp_nrdma_ram_type;
output        reg2dp_op_en;
output  [1:0] reg2dp_out_precision;
output        reg2dp_perf_dma_en;
output        reg2dp_perf_nan_inf_count_en;
output  [1:0] reg2dp_proc_precision;
output [31:0] reg2dp_src_base_addr_high;
output [26:0] reg2dp_src_base_addr_low;
output [26:0] reg2dp_src_line_stride;
output        reg2dp_src_ram_type;
output [26:0] reg2dp_src_surface_stride;
output [12:0] reg2dp_width;
output        reg2dp_winograd;
output [33:0] sdp_rdma2csb_resp_pd;
output        sdp_rdma2csb_resp_valid;
output  [3:0] slcg_op_en;
wire          csb_rresp_error;
wire   [33:0] csb_rresp_pd_w;
wire   [31:0] csb_rresp_rdat;
wire          csb_wresp_error;
wire   [33:0] csb_wresp_pd_w;
wire   [31:0] csb_wresp_rdat;
wire   [23:0] d0_reg_offset;
wire   [31:0] d0_reg_rd_data;
wire   [31:0] d0_reg_wr_data;
wire          d0_reg_wr_en;
wire   [23:0] d1_reg_offset;
wire   [31:0] d1_reg_rd_data;
wire   [31:0] d1_reg_wr_data;
wire          d1_reg_wr_en;
wire          dp2reg_consumer_w;
wire   [31:0] dp2reg_d0_brdma_stall_w;
wire   [31:0] dp2reg_d0_erdma_stall_w;
wire   [31:0] dp2reg_d0_mrdma_stall_w;
wire   [31:0] dp2reg_d0_nrdma_stall_w;
wire   [31:0] dp2reg_d0_status_inf_input_num_w;
wire   [31:0] dp2reg_d0_status_nan_input_num_w;
wire   [31:0] dp2reg_d1_brdma_stall_w;
wire   [31:0] dp2reg_d1_erdma_stall_w;
wire   [31:0] dp2reg_d1_mrdma_stall_w;
wire   [31:0] dp2reg_d1_nrdma_stall_w;
wire   [31:0] dp2reg_d1_status_inf_input_num_w;
wire   [31:0] dp2reg_d1_status_nan_input_num_w;
wire    [4:0] reg2dp_d0_batch_number;
wire   [31:0] reg2dp_d0_bn_base_addr_high;
wire   [26:0] reg2dp_d0_bn_base_addr_low;
wire   [26:0] reg2dp_d0_bn_batch_stride;
wire   [26:0] reg2dp_d0_bn_line_stride;
wire   [26:0] reg2dp_d0_bn_surface_stride;
wire          reg2dp_d0_brdma_data_mode;
wire          reg2dp_d0_brdma_data_size;
wire    [1:0] reg2dp_d0_brdma_data_use;
wire          reg2dp_d0_brdma_disable;
wire          reg2dp_d0_brdma_ram_type;
wire   [31:0] reg2dp_d0_bs_base_addr_high;
wire   [26:0] reg2dp_d0_bs_base_addr_low;
wire   [26:0] reg2dp_d0_bs_batch_stride;
wire   [26:0] reg2dp_d0_bs_line_stride;
wire   [26:0] reg2dp_d0_bs_surface_stride;
wire   [12:0] reg2dp_d0_channel;
wire          reg2dp_d0_erdma_data_mode;
wire          reg2dp_d0_erdma_data_size;
wire    [1:0] reg2dp_d0_erdma_data_use;
wire          reg2dp_d0_erdma_disable;
wire          reg2dp_d0_erdma_ram_type;
wire   [31:0] reg2dp_d0_ew_base_addr_high;
wire   [26:0] reg2dp_d0_ew_base_addr_low;
wire   [26:0] reg2dp_d0_ew_batch_stride;
wire   [26:0] reg2dp_d0_ew_line_stride;
wire   [26:0] reg2dp_d0_ew_surface_stride;
wire          reg2dp_d0_flying_mode;
wire   [12:0] reg2dp_d0_height;
wire    [1:0] reg2dp_d0_in_precision;
wire          reg2dp_d0_nrdma_data_mode;
wire          reg2dp_d0_nrdma_data_size;
wire    [1:0] reg2dp_d0_nrdma_data_use;
wire          reg2dp_d0_nrdma_disable;
wire          reg2dp_d0_nrdma_ram_type;
wire          reg2dp_d0_op_en_trigger;
wire    [1:0] reg2dp_d0_out_precision;
wire          reg2dp_d0_perf_dma_en;
wire          reg2dp_d0_perf_nan_inf_count_en;
wire    [1:0] reg2dp_d0_proc_precision;
wire   [31:0] reg2dp_d0_src_base_addr_high;
wire   [26:0] reg2dp_d0_src_base_addr_low;
wire   [26:0] reg2dp_d0_src_line_stride;
wire          reg2dp_d0_src_ram_type;
wire   [26:0] reg2dp_d0_src_surface_stride;
wire   [12:0] reg2dp_d0_width;
wire          reg2dp_d0_winograd;
wire    [4:0] reg2dp_d1_batch_number;
wire   [31:0] reg2dp_d1_bn_base_addr_high;
wire   [26:0] reg2dp_d1_bn_base_addr_low;
wire   [26:0] reg2dp_d1_bn_batch_stride;
wire   [26:0] reg2dp_d1_bn_line_stride;
wire   [26:0] reg2dp_d1_bn_surface_stride;
wire          reg2dp_d1_brdma_data_mode;
wire          reg2dp_d1_brdma_data_size;
wire    [1:0] reg2dp_d1_brdma_data_use;
wire          reg2dp_d1_brdma_disable;
wire          reg2dp_d1_brdma_ram_type;
wire   [31:0] reg2dp_d1_bs_base_addr_high;
wire   [26:0] reg2dp_d1_bs_base_addr_low;
wire   [26:0] reg2dp_d1_bs_batch_stride;
wire   [26:0] reg2dp_d1_bs_line_stride;
wire   [26:0] reg2dp_d1_bs_surface_stride;
wire   [12:0] reg2dp_d1_channel;
wire          reg2dp_d1_erdma_data_mode;
wire          reg2dp_d1_erdma_data_size;
wire    [1:0] reg2dp_d1_erdma_data_use;
wire          reg2dp_d1_erdma_disable;
wire          reg2dp_d1_erdma_ram_type;
wire   [31:0] reg2dp_d1_ew_base_addr_high;
wire   [26:0] reg2dp_d1_ew_base_addr_low;
wire   [26:0] reg2dp_d1_ew_batch_stride;
wire   [26:0] reg2dp_d1_ew_line_stride;
wire   [26:0] reg2dp_d1_ew_surface_stride;
wire          reg2dp_d1_flying_mode;
wire   [12:0] reg2dp_d1_height;
wire    [1:0] reg2dp_d1_in_precision;
wire          reg2dp_d1_nrdma_data_mode;
wire          reg2dp_d1_nrdma_data_size;
wire    [1:0] reg2dp_d1_nrdma_data_use;
wire          reg2dp_d1_nrdma_disable;
wire          reg2dp_d1_nrdma_ram_type;
wire          reg2dp_d1_op_en_trigger;
wire    [1:0] reg2dp_d1_out_precision;
wire          reg2dp_d1_perf_dma_en;
wire          reg2dp_d1_perf_nan_inf_count_en;
wire    [1:0] reg2dp_d1_proc_precision;
wire   [31:0] reg2dp_d1_src_base_addr_high;
wire   [26:0] reg2dp_d1_src_base_addr_low;
wire   [26:0] reg2dp_d1_src_line_stride;
wire          reg2dp_d1_src_ram_type;
wire   [26:0] reg2dp_d1_src_surface_stride;
wire   [12:0] reg2dp_d1_width;
wire          reg2dp_d1_winograd;
wire    [2:0] reg2dp_op_en_reg_w;
wire          reg2dp_producer;
wire   [23:0] reg_offset;
wire   [31:0] reg_rd_data;
wire          reg_rd_en;
wire   [31:0] reg_wr_data;
wire          reg_wr_en;
wire   [21:0] req_addr;
wire    [1:0] req_level;
wire          req_nposted;
wire          req_srcpriv;
wire   [31:0] req_wdat;
wire    [3:0] req_wrbe;
wire          req_write;
wire   [23:0] s_reg_offset;
wire   [31:0] s_reg_rd_data;
wire   [31:0] s_reg_wr_data;
wire          s_reg_wr_en;
wire          select_d0;
wire          select_d1;
wire          select_s;
wire    [3:0] slcg_op_en_d0;
reg           dp2reg_consumer;
reg    [31:0] dp2reg_d0_brdma_stall;
reg           dp2reg_d0_clr;
reg    [31:0] dp2reg_d0_erdma_stall;
reg    [31:0] dp2reg_d0_mrdma_stall;
reg    [31:0] dp2reg_d0_nrdma_stall;
reg           dp2reg_d0_reg;
reg           dp2reg_d0_set;
reg    [31:0] dp2reg_d0_status_inf_input_num;
reg    [31:0] dp2reg_d0_status_nan_input_num;
reg    [31:0] dp2reg_d1_brdma_stall;
reg           dp2reg_d1_clr;
reg    [31:0] dp2reg_d1_erdma_stall;
reg    [31:0] dp2reg_d1_mrdma_stall;
reg    [31:0] dp2reg_d1_nrdma_stall;
reg           dp2reg_d1_reg;
reg           dp2reg_d1_set;
reg    [31:0] dp2reg_d1_status_inf_input_num;
reg    [31:0] dp2reg_d1_status_nan_input_num;
reg     [1:0] dp2reg_status_0;
reg     [1:0] dp2reg_status_1;
reg     [4:0] reg2dp_batch_number;
reg    [31:0] reg2dp_bn_base_addr_high;
reg    [26:0] reg2dp_bn_base_addr_low;
reg    [26:0] reg2dp_bn_batch_stride;
reg    [26:0] reg2dp_bn_line_stride;
reg    [26:0] reg2dp_bn_surface_stride;
reg           reg2dp_brdma_data_mode;
reg           reg2dp_brdma_data_size;
reg     [1:0] reg2dp_brdma_data_use;
reg           reg2dp_brdma_disable;
reg           reg2dp_brdma_ram_type;
reg    [31:0] reg2dp_bs_base_addr_high;
reg    [26:0] reg2dp_bs_base_addr_low;
reg    [26:0] reg2dp_bs_batch_stride;
reg    [26:0] reg2dp_bs_line_stride;
reg    [26:0] reg2dp_bs_surface_stride;
reg    [12:0] reg2dp_channel;
reg           reg2dp_d0_op_en;
reg           reg2dp_d0_op_en_w;
reg           reg2dp_d1_op_en;
reg           reg2dp_d1_op_en_w;
reg           reg2dp_erdma_data_mode;
reg           reg2dp_erdma_data_size;
reg     [1:0] reg2dp_erdma_data_use;
reg           reg2dp_erdma_disable;
reg           reg2dp_erdma_ram_type;
reg    [31:0] reg2dp_ew_base_addr_high;
reg    [26:0] reg2dp_ew_base_addr_low;
reg    [26:0] reg2dp_ew_batch_stride;
reg    [26:0] reg2dp_ew_line_stride;
reg    [26:0] reg2dp_ew_surface_stride;
reg           reg2dp_flying_mode;
reg    [12:0] reg2dp_height;
reg     [1:0] reg2dp_in_precision;
reg           reg2dp_nrdma_data_mode;
reg           reg2dp_nrdma_data_size;
reg     [1:0] reg2dp_nrdma_data_use;
reg           reg2dp_nrdma_disable;
reg           reg2dp_nrdma_ram_type;
reg           reg2dp_op_en_ori;
reg     [2:0] reg2dp_op_en_reg;
reg     [1:0] reg2dp_out_precision;
reg           reg2dp_perf_dma_en;
reg           reg2dp_perf_nan_inf_count_en;
reg     [1:0] reg2dp_proc_precision;
reg    [31:0] reg2dp_src_base_addr_high;
reg    [26:0] reg2dp_src_base_addr_low;
reg    [26:0] reg2dp_src_line_stride;
reg           reg2dp_src_ram_type;
reg    [26:0] reg2dp_src_surface_stride;
reg    [12:0] reg2dp_width;
reg           reg2dp_winograd;
reg    [62:0] req_pd;
reg           req_pvld;
reg    [33:0] sdp_rdma2csb_resp_pd;
reg           sdp_rdma2csb_resp_valid;
reg     [3:0] slcg_op_en_d1;
reg     [3:0] slcg_op_en_d2;
reg     [3:0] slcg_op_en_d3;


//Instance single register group
NV_NVDLA_SDP_RDMA_REG_single u_single_reg (
   .reg_rd_data           (s_reg_rd_data[31:0])                  //|> w
  ,.reg_offset            (s_reg_offset[11:0])                   //|< w
  ,.reg_wr_data           (s_reg_wr_data[31:0])                  //|< w
  ,.reg_wr_en             (s_reg_wr_en)                          //|< w
  ,.nvdla_core_clk        (nvdla_core_clk)                       //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)                      //|< i
  ,.producer              (reg2dp_producer)                      //|> w
  ,.consumer              (dp2reg_consumer)                      //|< r
  ,.status_0              (dp2reg_status_0[1:0])                 //|< r
  ,.status_1              (dp2reg_status_1[1:0])                 //|< r
  );

//Instance two duplicated register groups

NV_NVDLA_SDP_RDMA_REG_dual u_dual_reg_d0 (
   .reg_rd_data           (d0_reg_rd_data[31:0])                 //|> w
  ,.reg_offset            (d0_reg_offset[11:0])                  //|< w
  ,.reg_wr_data           (d0_reg_wr_data[31:0])                 //|< w
  ,.reg_wr_en             (d0_reg_wr_en)                         //|< w
  ,.nvdla_core_clk        (nvdla_core_clk)                       //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)                      //|< i
  ,.bn_base_addr_high     (reg2dp_d0_bn_base_addr_high[31:0])    //|> w
  ,.bn_base_addr_low      (reg2dp_d0_bn_base_addr_low[26:0])     //|> w
  ,.bn_batch_stride       (reg2dp_d0_bn_batch_stride[26:0])      //|> w
  ,.bn_line_stride        (reg2dp_d0_bn_line_stride[26:0])       //|> w
  ,.bn_surface_stride     (reg2dp_d0_bn_surface_stride[26:0])    //|> w
  ,.brdma_data_mode       (reg2dp_d0_brdma_data_mode)            //|> w
  ,.brdma_data_size       (reg2dp_d0_brdma_data_size)            //|> w
  ,.brdma_data_use        (reg2dp_d0_brdma_data_use[1:0])        //|> w
  ,.brdma_disable         (reg2dp_d0_brdma_disable)              //|> w
  ,.brdma_ram_type        (reg2dp_d0_brdma_ram_type)             //|> w
  ,.bs_base_addr_high     (reg2dp_d0_bs_base_addr_high[31:0])    //|> w
  ,.bs_base_addr_low      (reg2dp_d0_bs_base_addr_low[26:0])     //|> w
  ,.bs_batch_stride       (reg2dp_d0_bs_batch_stride[26:0])      //|> w
  ,.bs_line_stride        (reg2dp_d0_bs_line_stride[26:0])       //|> w
  ,.bs_surface_stride     (reg2dp_d0_bs_surface_stride[26:0])    //|> w
  ,.channel               (reg2dp_d0_channel[12:0])              //|> w
  ,.height                (reg2dp_d0_height[12:0])               //|> w
  ,.width                 (reg2dp_d0_width[12:0])                //|> w
  ,.erdma_data_mode       (reg2dp_d0_erdma_data_mode)            //|> w
  ,.erdma_data_size       (reg2dp_d0_erdma_data_size)            //|> w
  ,.erdma_data_use        (reg2dp_d0_erdma_data_use[1:0])        //|> w
  ,.erdma_disable         (reg2dp_d0_erdma_disable)              //|> w
  ,.erdma_ram_type        (reg2dp_d0_erdma_ram_type)             //|> w
  ,.ew_base_addr_high     (reg2dp_d0_ew_base_addr_high[31:0])    //|> w
  ,.ew_base_addr_low      (reg2dp_d0_ew_base_addr_low[26:0])     //|> w
  ,.ew_batch_stride       (reg2dp_d0_ew_batch_stride[26:0])      //|> w
  ,.ew_line_stride        (reg2dp_d0_ew_line_stride[26:0])       //|> w
  ,.ew_surface_stride     (reg2dp_d0_ew_surface_stride[26:0])    //|> w
  ,.batch_number          (reg2dp_d0_batch_number[4:0])          //|> w
  ,.flying_mode           (reg2dp_d0_flying_mode)                //|> w
  ,.in_precision          (reg2dp_d0_in_precision[1:0])          //|> w
  ,.out_precision         (reg2dp_d0_out_precision[1:0])         //|> w
  ,.proc_precision        (reg2dp_d0_proc_precision[1:0])        //|> w
  ,.winograd              (reg2dp_d0_winograd)                   //|> w
  ,.nrdma_data_mode       (reg2dp_d0_nrdma_data_mode)            //|> w
  ,.nrdma_data_size       (reg2dp_d0_nrdma_data_size)            //|> w
  ,.nrdma_data_use        (reg2dp_d0_nrdma_data_use[1:0])        //|> w
  ,.nrdma_disable         (reg2dp_d0_nrdma_disable)              //|> w
  ,.nrdma_ram_type        (reg2dp_d0_nrdma_ram_type)             //|> w
  ,.op_en_trigger         (reg2dp_d0_op_en_trigger)              //|> w
  ,.perf_dma_en           (reg2dp_d0_perf_dma_en)                //|> w
  ,.perf_nan_inf_count_en (reg2dp_d0_perf_nan_inf_count_en)      //|> w
  ,.src_base_addr_high    (reg2dp_d0_src_base_addr_high[31:0])   //|> w
  ,.src_base_addr_low     (reg2dp_d0_src_base_addr_low[26:0])    //|> w
  ,.src_ram_type          (reg2dp_d0_src_ram_type)               //|> w
  ,.src_line_stride       (reg2dp_d0_src_line_stride[26:0])      //|> w
  ,.src_surface_stride    (reg2dp_d0_src_surface_stride[26:0])   //|> w
  ,.op_en                 (reg2dp_d0_op_en)                      //|< r
  ,.brdma_stall           (dp2reg_d0_brdma_stall[31:0])          //|< r
  ,.erdma_stall           (dp2reg_d0_erdma_stall[31:0])          //|< r
  ,.mrdma_stall           (dp2reg_d0_mrdma_stall[31:0])          //|< r
  ,.nrdma_stall           (dp2reg_d0_nrdma_stall[31:0])          //|< r
  ,.status_inf_input_num  (dp2reg_d0_status_inf_input_num[31:0]) //|< r
  ,.status_nan_input_num  (dp2reg_d0_status_nan_input_num[31:0]) //|< r
  );
        
NV_NVDLA_SDP_RDMA_REG_dual u_dual_reg_d1 (
   .reg_rd_data           (d1_reg_rd_data[31:0])                 //|> w
  ,.reg_offset            (d1_reg_offset[11:0])                  //|< w
  ,.reg_wr_data           (d1_reg_wr_data[31:0])                 //|< w
  ,.reg_wr_en             (d1_reg_wr_en)                         //|< w
  ,.nvdla_core_clk        (nvdla_core_clk)                       //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)                      //|< i
  ,.bn_base_addr_high     (reg2dp_d1_bn_base_addr_high[31:0])    //|> w
  ,.bn_base_addr_low      (reg2dp_d1_bn_base_addr_low[26:0])     //|> w
  ,.bn_batch_stride       (reg2dp_d1_bn_batch_stride[26:0])      //|> w
  ,.bn_line_stride        (reg2dp_d1_bn_line_stride[26:0])       //|> w
  ,.bn_surface_stride     (reg2dp_d1_bn_surface_stride[26:0])    //|> w
  ,.brdma_data_mode       (reg2dp_d1_brdma_data_mode)            //|> w
  ,.brdma_data_size       (reg2dp_d1_brdma_data_size)            //|> w
  ,.brdma_data_use        (reg2dp_d1_brdma_data_use[1:0])        //|> w
  ,.brdma_disable         (reg2dp_d1_brdma_disable)              //|> w
  ,.brdma_ram_type        (reg2dp_d1_brdma_ram_type)             //|> w
  ,.bs_base_addr_high     (reg2dp_d1_bs_base_addr_high[31:0])    //|> w
  ,.bs_base_addr_low      (reg2dp_d1_bs_base_addr_low[26:0])     //|> w
  ,.bs_batch_stride       (reg2dp_d1_bs_batch_stride[26:0])      //|> w
  ,.bs_line_stride        (reg2dp_d1_bs_line_stride[26:0])       //|> w
  ,.bs_surface_stride     (reg2dp_d1_bs_surface_stride[26:0])    //|> w
  ,.channel               (reg2dp_d1_channel[12:0])              //|> w
  ,.height                (reg2dp_d1_height[12:0])               //|> w
  ,.width                 (reg2dp_d1_width[12:0])                //|> w
  ,.erdma_data_mode       (reg2dp_d1_erdma_data_mode)            //|> w
  ,.erdma_data_size       (reg2dp_d1_erdma_data_size)            //|> w
  ,.erdma_data_use        (reg2dp_d1_erdma_data_use[1:0])        //|> w
  ,.erdma_disable         (reg2dp_d1_erdma_disable)              //|> w
  ,.erdma_ram_type        (reg2dp_d1_erdma_ram_type)             //|> w
  ,.ew_base_addr_high     (reg2dp_d1_ew_base_addr_high[31:0])    //|> w
  ,.ew_base_addr_low      (reg2dp_d1_ew_base_addr_low[26:0])     //|> w
  ,.ew_batch_stride       (reg2dp_d1_ew_batch_stride[26:0])      //|> w
  ,.ew_line_stride        (reg2dp_d1_ew_line_stride[26:0])       //|> w
  ,.ew_surface_stride     (reg2dp_d1_ew_surface_stride[26:0])    //|> w
  ,.batch_number          (reg2dp_d1_batch_number[4:0])          //|> w
  ,.flying_mode           (reg2dp_d1_flying_mode)                //|> w
  ,.in_precision          (reg2dp_d1_in_precision[1:0])          //|> w
  ,.out_precision         (reg2dp_d1_out_precision[1:0])         //|> w
  ,.proc_precision        (reg2dp_d1_proc_precision[1:0])        //|> w
  ,.winograd              (reg2dp_d1_winograd)                   //|> w
  ,.nrdma_data_mode       (reg2dp_d1_nrdma_data_mode)            //|> w
  ,.nrdma_data_size       (reg2dp_d1_nrdma_data_size)            //|> w
  ,.nrdma_data_use        (reg2dp_d1_nrdma_data_use[1:0])        //|> w
  ,.nrdma_disable         (reg2dp_d1_nrdma_disable)              //|> w
  ,.nrdma_ram_type        (reg2dp_d1_nrdma_ram_type)             //|> w
  ,.op_en_trigger         (reg2dp_d1_op_en_trigger)              //|> w
  ,.perf_dma_en           (reg2dp_d1_perf_dma_en)                //|> w
  ,.perf_nan_inf_count_en (reg2dp_d1_perf_nan_inf_count_en)      //|> w
  ,.src_base_addr_high    (reg2dp_d1_src_base_addr_high[31:0])   //|> w
  ,.src_base_addr_low     (reg2dp_d1_src_base_addr_low[26:0])    //|> w
  ,.src_ram_type          (reg2dp_d1_src_ram_type)               //|> w
  ,.src_line_stride       (reg2dp_d1_src_line_stride[26:0])      //|> w
  ,.src_surface_stride    (reg2dp_d1_src_surface_stride[26:0])   //|> w
  ,.op_en                 (reg2dp_d1_op_en)                      //|< r
  ,.brdma_stall           (dp2reg_d1_brdma_stall[31:0])          //|< r
  ,.erdma_stall           (dp2reg_d1_erdma_stall[31:0])          //|< r
  ,.mrdma_stall           (dp2reg_d1_mrdma_stall[31:0])          //|< r
  ,.nrdma_stall           (dp2reg_d1_nrdma_stall[31:0])          //|< r
  ,.status_inf_input_num  (dp2reg_d1_status_inf_input_num[31:0]) //|< r
  ,.status_nan_input_num  (dp2reg_d1_status_nan_input_num[31:0]) //|< r
  );
        
////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE CONSUMER PIONTER IN GENERAL SINGLE REGISTER GROUP         //
//                                                                    //
////////////////////////////////////////////////////////////////////////
assign dp2reg_consumer_w = ~dp2reg_consumer;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_consumer <= 1'b0;
  end else begin
  if ((dp2reg_done) == 1'b1) begin
    dp2reg_consumer <= dp2reg_consumer_w;
  // VCS coverage off
  end else if ((dp2reg_done) == 1'b0) begin
  end else begin
    dp2reg_consumer <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE TWO STATUS FIELDS IN GENERAL SINGLE REGISTER GROUP        //
//                                                                    //
////////////////////////////////////////////////////////////////////////
always @(
  reg2dp_d0_op_en
  or dp2reg_consumer
  ) begin
    dp2reg_status_0 = (reg2dp_d0_op_en == 1'h0 ) ? 2'h0  :
                      (dp2reg_consumer == 1'h1 ) ? 2'h2  :
                      2'h1 ;
end

always @(
  reg2dp_d1_op_en
  or dp2reg_consumer
  ) begin
    dp2reg_status_1 = (reg2dp_d1_op_en == 1'h0 ) ? 2'h0  :
                      (dp2reg_consumer == 1'h0 ) ? 2'h2  :
                      2'h1 ;
end

////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE OP_EN LOGIC                                               //
//                                                                    //
////////////////////////////////////////////////////////////////////////
always @(
  reg2dp_d0_op_en
  or reg2dp_d0_op_en_trigger
  or reg_wr_data
  or dp2reg_done
  or dp2reg_consumer
  ) begin
    reg2dp_d0_op_en_w = (~reg2dp_d0_op_en & reg2dp_d0_op_en_trigger) ? reg_wr_data[0 ] :
                        (dp2reg_done && dp2reg_consumer == 1'h0 ) ? 1'b0 :
                        reg2dp_d0_op_en;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_d0_op_en <= 1'b0;
  end else begin
  reg2dp_d0_op_en <= reg2dp_d0_op_en_w;
  end
end

always @(
  reg2dp_d1_op_en
  or reg2dp_d1_op_en_trigger
  or reg_wr_data
  or dp2reg_done
  or dp2reg_consumer
  ) begin
    reg2dp_d1_op_en_w = (~reg2dp_d1_op_en & reg2dp_d1_op_en_trigger) ? reg_wr_data[0 ] :
                        (dp2reg_done && dp2reg_consumer == 1'h1 ) ? 1'b0 :
                        reg2dp_d1_op_en;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_d1_op_en <= 1'b0;
  end else begin
  reg2dp_d1_op_en <= reg2dp_d1_op_en_w;
  end
end

always @(
  dp2reg_consumer
  or reg2dp_d1_op_en
  or reg2dp_d0_op_en
  ) begin
    reg2dp_op_en_ori = dp2reg_consumer ? reg2dp_d1_op_en : reg2dp_d0_op_en;
end

assign reg2dp_op_en_reg_w = dp2reg_done ? 3'b0 :
                            {reg2dp_op_en_reg[1:0], reg2dp_op_en_ori};

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_op_en_reg <= {3{1'b0}};
  end else begin
  reg2dp_op_en_reg <= reg2dp_op_en_reg_w;
  end
end

assign reg2dp_op_en = reg2dp_op_en_reg[3-1];

assign slcg_op_en_d0 = {4{reg2dp_op_en_ori}};

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_op_en_d1 <= {4{1'b0}};
  end else begin
  slcg_op_en_d1 <= slcg_op_en_d0;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_op_en_d2 <= {4{1'b0}};
  end else begin
  slcg_op_en_d2 <= slcg_op_en_d1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_op_en_d3 <= {4{1'b0}};
  end else begin
  slcg_op_en_d3 <= slcg_op_en_d2;
  end
end



assign slcg_op_en = slcg_op_en_d3;

////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE ACCESS LOGIC TO EACH REGISTER GROUP                       //
//                                                                    //
////////////////////////////////////////////////////////////////////////
//EACH subunit has 4KB address space
assign select_s  = (reg_offset[11:0] < (32'ha008  & 32'hfff)) ? 1'b1: 1'b0;
assign select_d0 = (reg_offset[11:0] >= (32'ha008  & 32'hfff)) & (reg2dp_producer == 1'h0 );
assign select_d1 = (reg_offset[11:0] >= (32'ha008  & 32'hfff)) & (reg2dp_producer == 1'h1 );

assign s_reg_wr_en  = reg_wr_en & select_s;
assign d0_reg_wr_en = reg_wr_en & select_d0 & ~reg2dp_d0_op_en;
assign d1_reg_wr_en = reg_wr_en & select_d1 & ~reg2dp_d1_op_en;

assign s_reg_offset  = reg_offset;
assign d0_reg_offset = reg_offset;
assign d1_reg_offset = reg_offset;

assign s_reg_wr_data  = reg_wr_data;
assign d0_reg_wr_data = reg_wr_data;
assign d1_reg_wr_data = reg_wr_data;

assign reg_rd_data = ({32{select_s}}  & s_reg_rd_data)  |
                     ({32{select_d0}} & d0_reg_rd_data) |
                     ({32{select_d1}} & d1_reg_rd_data);

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
  nv_assert_never #(0,0,"Error! Write group 0 registers when OP_EN is set!")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, (reg_wr_en & select_d0 & reg2dp_d0_op_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Write group 1 registers when OP_EN is set!")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (reg_wr_en & select_d1 & reg2dp_d1_op_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE CSB TO REGISTER CONNECTION LOGIC                          //
//                                                                    //
////////////////////////////////////////////////////////////////////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_pvld <= 1'b0;
  end else begin
  req_pvld <= csb2sdp_rdma_req_pvld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_pd <= {63{1'b0}};
  end else begin
  if ((csb2sdp_rdma_req_pvld) == 1'b1) begin
    req_pd <= csb2sdp_rdma_req_pd;
  // VCS coverage off
  end else if ((csb2sdp_rdma_req_pvld) == 1'b0) begin
  end else begin
    req_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(csb2sdp_rdma_req_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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


// PKT_UNPACK_WIRE( csb2xx_16m_be_lvl ,  req_ ,  req_pd )
assign        req_addr[21:0] =     req_pd[21:0];
assign        req_wdat[31:0] =     req_pd[53:22];
assign         req_write  =     req_pd[54];
assign         req_nposted  =     req_pd[55];
assign         req_srcpriv  =     req_pd[56];
assign        req_wrbe[3:0] =     req_pd[60:57];
assign        req_level[1:0] =     req_pd[62:61];

assign csb2sdp_rdma_req_prdy = 1'b1;


//Address in CSB master is word aligned while address in regfile is byte aligned.
assign reg_offset = {req_addr, 2'b0};
assign reg_wr_data = req_wdat;
assign reg_wr_en = req_pvld & req_write;
assign reg_rd_en = req_pvld & ~req_write;


// PKT_PACK_WIRE_ID( nvdla_xx2csb_resp ,  dla_xx2csb_rd_erpt ,  csb_rresp_ ,  csb_rresp_pd_w )
assign       csb_rresp_pd_w[31:0] =     csb_rresp_rdat[31:0];
assign       csb_rresp_pd_w[32] =     csb_rresp_error ;

assign   csb_rresp_pd_w[33:33] = 1'd0  /* PKT_nvdla_xx2csb_resp_dla_xx2csb_rd_erpt_ID  */ ;

// PKT_PACK_WIRE_ID( nvdla_xx2csb_resp ,  dla_xx2csb_wr_erpt ,  csb_wresp_ ,  csb_wresp_pd_w )
assign       csb_wresp_pd_w[31:0] =     csb_wresp_rdat[31:0];
assign       csb_wresp_pd_w[32] =     csb_wresp_error ;

assign   csb_wresp_pd_w[33:33] = 1'd1  /* PKT_nvdla_xx2csb_resp_dla_xx2csb_wr_erpt_ID  */ ;

assign csb_rresp_rdat = reg_rd_data;
assign csb_rresp_error = 1'b0;
assign csb_wresp_rdat = {32{1'b0}};
assign csb_wresp_error = 1'b0;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp_rdma2csb_resp_pd <= {34{1'b0}};
  end else begin
    if(reg_rd_en)
    begin
        sdp_rdma2csb_resp_pd <= csb_rresp_pd_w;
    end
    else if(reg_wr_en & req_nposted)
    begin
        sdp_rdma2csb_resp_pd <= csb_wresp_pd_w;
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp_rdma2csb_resp_valid <= 1'b0;
  end else begin
    sdp_rdma2csb_resp_valid <= (reg_wr_en & req_nposted) | reg_rd_en;
  end
end

////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE OUTPUT REGISTER FILED FROM DUPLICATED REGISTER GROUPS     //
//                                                                    //
////////////////////////////////////////////////////////////////////////
always @(
  dp2reg_consumer
  or reg2dp_d1_bn_base_addr_high
  or reg2dp_d0_bn_base_addr_high
  ) begin
    reg2dp_bn_base_addr_high = dp2reg_consumer ? reg2dp_d1_bn_base_addr_high : reg2dp_d0_bn_base_addr_high;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_base_addr_low
  or reg2dp_d0_bn_base_addr_low
  ) begin
    reg2dp_bn_base_addr_low = dp2reg_consumer ? reg2dp_d1_bn_base_addr_low : reg2dp_d0_bn_base_addr_low;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_batch_stride
  or reg2dp_d0_bn_batch_stride
  ) begin
    reg2dp_bn_batch_stride = dp2reg_consumer ? reg2dp_d1_bn_batch_stride : reg2dp_d0_bn_batch_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_line_stride
  or reg2dp_d0_bn_line_stride
  ) begin
    reg2dp_bn_line_stride = dp2reg_consumer ? reg2dp_d1_bn_line_stride : reg2dp_d0_bn_line_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_surface_stride
  or reg2dp_d0_bn_surface_stride
  ) begin
    reg2dp_bn_surface_stride = dp2reg_consumer ? reg2dp_d1_bn_surface_stride : reg2dp_d0_bn_surface_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_brdma_data_mode
  or reg2dp_d0_brdma_data_mode
  ) begin
    reg2dp_brdma_data_mode = dp2reg_consumer ? reg2dp_d1_brdma_data_mode : reg2dp_d0_brdma_data_mode;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_brdma_data_size
  or reg2dp_d0_brdma_data_size
  ) begin
    reg2dp_brdma_data_size = dp2reg_consumer ? reg2dp_d1_brdma_data_size : reg2dp_d0_brdma_data_size;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_brdma_data_use
  or reg2dp_d0_brdma_data_use
  ) begin
    reg2dp_brdma_data_use = dp2reg_consumer ? reg2dp_d1_brdma_data_use : reg2dp_d0_brdma_data_use;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_brdma_disable
  or reg2dp_d0_brdma_disable
  ) begin
    reg2dp_brdma_disable = dp2reg_consumer ? reg2dp_d1_brdma_disable : reg2dp_d0_brdma_disable;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_brdma_ram_type
  or reg2dp_d0_brdma_ram_type
  ) begin
    reg2dp_brdma_ram_type = dp2reg_consumer ? reg2dp_d1_brdma_ram_type : reg2dp_d0_brdma_ram_type;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_base_addr_high
  or reg2dp_d0_bs_base_addr_high
  ) begin
    reg2dp_bs_base_addr_high = dp2reg_consumer ? reg2dp_d1_bs_base_addr_high : reg2dp_d0_bs_base_addr_high;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_base_addr_low
  or reg2dp_d0_bs_base_addr_low
  ) begin
    reg2dp_bs_base_addr_low = dp2reg_consumer ? reg2dp_d1_bs_base_addr_low : reg2dp_d0_bs_base_addr_low;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_batch_stride
  or reg2dp_d0_bs_batch_stride
  ) begin
    reg2dp_bs_batch_stride = dp2reg_consumer ? reg2dp_d1_bs_batch_stride : reg2dp_d0_bs_batch_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_line_stride
  or reg2dp_d0_bs_line_stride
  ) begin
    reg2dp_bs_line_stride = dp2reg_consumer ? reg2dp_d1_bs_line_stride : reg2dp_d0_bs_line_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_surface_stride
  or reg2dp_d0_bs_surface_stride
  ) begin
    reg2dp_bs_surface_stride = dp2reg_consumer ? reg2dp_d1_bs_surface_stride : reg2dp_d0_bs_surface_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_channel
  or reg2dp_d0_channel
  ) begin
    reg2dp_channel = dp2reg_consumer ? reg2dp_d1_channel : reg2dp_d0_channel;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_height
  or reg2dp_d0_height
  ) begin
    reg2dp_height = dp2reg_consumer ? reg2dp_d1_height : reg2dp_d0_height;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_width
  or reg2dp_d0_width
  ) begin
    reg2dp_width = dp2reg_consumer ? reg2dp_d1_width : reg2dp_d0_width;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_erdma_data_mode
  or reg2dp_d0_erdma_data_mode
  ) begin
    reg2dp_erdma_data_mode = dp2reg_consumer ? reg2dp_d1_erdma_data_mode : reg2dp_d0_erdma_data_mode;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_erdma_data_size
  or reg2dp_d0_erdma_data_size
  ) begin
    reg2dp_erdma_data_size = dp2reg_consumer ? reg2dp_d1_erdma_data_size : reg2dp_d0_erdma_data_size;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_erdma_data_use
  or reg2dp_d0_erdma_data_use
  ) begin
    reg2dp_erdma_data_use = dp2reg_consumer ? reg2dp_d1_erdma_data_use : reg2dp_d0_erdma_data_use;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_erdma_disable
  or reg2dp_d0_erdma_disable
  ) begin
    reg2dp_erdma_disable = dp2reg_consumer ? reg2dp_d1_erdma_disable : reg2dp_d0_erdma_disable;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_erdma_ram_type
  or reg2dp_d0_erdma_ram_type
  ) begin
    reg2dp_erdma_ram_type = dp2reg_consumer ? reg2dp_d1_erdma_ram_type : reg2dp_d0_erdma_ram_type;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_base_addr_high
  or reg2dp_d0_ew_base_addr_high
  ) begin
    reg2dp_ew_base_addr_high = dp2reg_consumer ? reg2dp_d1_ew_base_addr_high : reg2dp_d0_ew_base_addr_high;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_base_addr_low
  or reg2dp_d0_ew_base_addr_low
  ) begin
    reg2dp_ew_base_addr_low = dp2reg_consumer ? reg2dp_d1_ew_base_addr_low : reg2dp_d0_ew_base_addr_low;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_batch_stride
  or reg2dp_d0_ew_batch_stride
  ) begin
    reg2dp_ew_batch_stride = dp2reg_consumer ? reg2dp_d1_ew_batch_stride : reg2dp_d0_ew_batch_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_line_stride
  or reg2dp_d0_ew_line_stride
  ) begin
    reg2dp_ew_line_stride = dp2reg_consumer ? reg2dp_d1_ew_line_stride : reg2dp_d0_ew_line_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_surface_stride
  or reg2dp_d0_ew_surface_stride
  ) begin
    reg2dp_ew_surface_stride = dp2reg_consumer ? reg2dp_d1_ew_surface_stride : reg2dp_d0_ew_surface_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_batch_number
  or reg2dp_d0_batch_number
  ) begin
    reg2dp_batch_number = dp2reg_consumer ? reg2dp_d1_batch_number : reg2dp_d0_batch_number;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_flying_mode
  or reg2dp_d0_flying_mode
  ) begin
    reg2dp_flying_mode = dp2reg_consumer ? reg2dp_d1_flying_mode : reg2dp_d0_flying_mode;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_in_precision
  or reg2dp_d0_in_precision
  ) begin
    reg2dp_in_precision = dp2reg_consumer ? reg2dp_d1_in_precision : reg2dp_d0_in_precision;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_out_precision
  or reg2dp_d0_out_precision
  ) begin
    reg2dp_out_precision = dp2reg_consumer ? reg2dp_d1_out_precision : reg2dp_d0_out_precision;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_proc_precision
  or reg2dp_d0_proc_precision
  ) begin
    reg2dp_proc_precision = dp2reg_consumer ? reg2dp_d1_proc_precision : reg2dp_d0_proc_precision;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_winograd
  or reg2dp_d0_winograd
  ) begin
    reg2dp_winograd = dp2reg_consumer ? reg2dp_d1_winograd : reg2dp_d0_winograd;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_nrdma_data_mode
  or reg2dp_d0_nrdma_data_mode
  ) begin
    reg2dp_nrdma_data_mode = dp2reg_consumer ? reg2dp_d1_nrdma_data_mode : reg2dp_d0_nrdma_data_mode;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_nrdma_data_size
  or reg2dp_d0_nrdma_data_size
  ) begin
    reg2dp_nrdma_data_size = dp2reg_consumer ? reg2dp_d1_nrdma_data_size : reg2dp_d0_nrdma_data_size;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_nrdma_data_use
  or reg2dp_d0_nrdma_data_use
  ) begin
    reg2dp_nrdma_data_use = dp2reg_consumer ? reg2dp_d1_nrdma_data_use : reg2dp_d0_nrdma_data_use;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_nrdma_disable
  or reg2dp_d0_nrdma_disable
  ) begin
    reg2dp_nrdma_disable = dp2reg_consumer ? reg2dp_d1_nrdma_disable : reg2dp_d0_nrdma_disable;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_nrdma_ram_type
  or reg2dp_d0_nrdma_ram_type
  ) begin
    reg2dp_nrdma_ram_type = dp2reg_consumer ? reg2dp_d1_nrdma_ram_type : reg2dp_d0_nrdma_ram_type;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_perf_dma_en
  or reg2dp_d0_perf_dma_en
  ) begin
    reg2dp_perf_dma_en = dp2reg_consumer ? reg2dp_d1_perf_dma_en : reg2dp_d0_perf_dma_en;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_perf_nan_inf_count_en
  or reg2dp_d0_perf_nan_inf_count_en
  ) begin
    reg2dp_perf_nan_inf_count_en = dp2reg_consumer ? reg2dp_d1_perf_nan_inf_count_en : reg2dp_d0_perf_nan_inf_count_en;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_src_base_addr_high
  or reg2dp_d0_src_base_addr_high
  ) begin
    reg2dp_src_base_addr_high = dp2reg_consumer ? reg2dp_d1_src_base_addr_high : reg2dp_d0_src_base_addr_high;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_src_base_addr_low
  or reg2dp_d0_src_base_addr_low
  ) begin
    reg2dp_src_base_addr_low = dp2reg_consumer ? reg2dp_d1_src_base_addr_low : reg2dp_d0_src_base_addr_low;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_src_ram_type
  or reg2dp_d0_src_ram_type
  ) begin
    reg2dp_src_ram_type = dp2reg_consumer ? reg2dp_d1_src_ram_type : reg2dp_d0_src_ram_type;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_src_line_stride
  or reg2dp_d0_src_line_stride
  ) begin
    reg2dp_src_line_stride = dp2reg_consumer ? reg2dp_d1_src_line_stride : reg2dp_d0_src_line_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_src_surface_stride
  or reg2dp_d0_src_surface_stride
  ) begin
    reg2dp_src_surface_stride = dp2reg_consumer ? reg2dp_d1_src_surface_stride : reg2dp_d0_src_surface_stride;
end

////////////////////////////////////////////////////////////////////////
//                                                                    //
// PASTE ADDIFITON LOGIC HERE FROM EXTRA FILE                         //
//                                                                    //
////////////////////////////////////////////////////////////////////////
// USER logic can be put here:
//////// Dual Flop Write Control////////
always @(
  reg2dp_d0_op_en
  or reg2dp_d0_op_en_w
  ) begin
    dp2reg_d0_set = reg2dp_d0_op_en & ~reg2dp_d0_op_en_w;
    dp2reg_d0_clr = ~reg2dp_d0_op_en & reg2dp_d0_op_en_w;
    dp2reg_d0_reg = reg2dp_d0_op_en ^ reg2dp_d0_op_en_w;
end

always @(
  reg2dp_d1_op_en
  or reg2dp_d1_op_en_w
  ) begin
    dp2reg_d1_set = reg2dp_d1_op_en & ~reg2dp_d1_op_en_w;
    dp2reg_d1_clr = ~reg2dp_d1_op_en & reg2dp_d1_op_en_w;
    dp2reg_d1_reg = reg2dp_d1_op_en ^ reg2dp_d1_op_en_w;
end

//////// for overflow counting register ////////
assign dp2reg_d0_status_nan_input_num_w = (dp2reg_d0_set) ? dp2reg_status_nan_input_num[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_status_nan_input_num;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_status_nan_input_num <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_status_nan_input_num <= dp2reg_d0_status_nan_input_num_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_status_nan_input_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d0_brdma_stall_w = (dp2reg_d0_set) ? dp2reg_brdma_stall[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_brdma_stall;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_brdma_stall <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_brdma_stall <= dp2reg_d0_brdma_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_brdma_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d0_status_inf_input_num_w = (dp2reg_d0_set) ? dp2reg_status_inf_input_num[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_status_inf_input_num;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_status_inf_input_num <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_status_inf_input_num <= dp2reg_d0_status_inf_input_num_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_status_inf_input_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d0_erdma_stall_w = (dp2reg_d0_set) ? dp2reg_erdma_stall[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_erdma_stall;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_erdma_stall <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_erdma_stall <= dp2reg_d0_erdma_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_erdma_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d0_nrdma_stall_w = (dp2reg_d0_set) ? dp2reg_nrdma_stall[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_nrdma_stall;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_nrdma_stall <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_nrdma_stall <= dp2reg_d0_nrdma_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_nrdma_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d0_mrdma_stall_w = (dp2reg_d0_set) ? dp2reg_mrdma_stall[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_mrdma_stall;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_mrdma_stall <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_mrdma_stall <= dp2reg_d0_mrdma_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_mrdma_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d1_status_nan_input_num_w = (dp2reg_d1_set) ? dp2reg_status_nan_input_num[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_status_nan_input_num;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_status_nan_input_num <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_status_nan_input_num <= dp2reg_d1_status_nan_input_num_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_status_nan_input_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d1_brdma_stall_w = (dp2reg_d1_set) ? dp2reg_brdma_stall[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_brdma_stall;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_brdma_stall <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_brdma_stall <= dp2reg_d1_brdma_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_brdma_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d1_status_inf_input_num_w = (dp2reg_d1_set) ? dp2reg_status_inf_input_num[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_status_inf_input_num;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_status_inf_input_num <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_status_inf_input_num <= dp2reg_d1_status_inf_input_num_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_status_inf_input_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d1_erdma_stall_w = (dp2reg_d1_set) ? dp2reg_erdma_stall[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_erdma_stall;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_erdma_stall <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_erdma_stall <= dp2reg_d1_erdma_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_erdma_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d1_nrdma_stall_w = (dp2reg_d1_set) ? dp2reg_nrdma_stall[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_nrdma_stall;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_nrdma_stall <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_nrdma_stall <= dp2reg_d1_nrdma_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_nrdma_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d1_mrdma_stall_w = (dp2reg_d1_set) ? dp2reg_mrdma_stall[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_mrdma_stall;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_mrdma_stall <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_mrdma_stall <= dp2reg_d1_mrdma_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_mrdma_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_RDMA_reg

