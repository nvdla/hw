// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_reg.v

`include "simulate_x_tick.vh"
module NV_NVDLA_PDP_reg (
   nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,csb2pdp_req_pd                 //|< i
  ,csb2pdp_req_pvld               //|< i
  ,dp2reg_d0_perf_write_stall     //|< i
  ,dp2reg_d1_perf_write_stall     //|< i
  ,dp2reg_done                    //|< i
  ,dp2reg_inf_input_num           //|< i
  ,dp2reg_nan_input_num           //|< i
  ,dp2reg_nan_output_num          //|< i
  ,csb2pdp_req_prdy               //|> o
  ,pdp2csb_resp_pd                //|> o
  ,pdp2csb_resp_valid             //|> o
  ,reg2dp_cube_in_channel         //|> o
  ,reg2dp_cube_in_height          //|> o
  ,reg2dp_cube_in_width           //|> o
  ,reg2dp_cube_out_channel        //|> o
  ,reg2dp_cube_out_height         //|> o
  ,reg2dp_cube_out_width          //|> o
  ,reg2dp_cya                     //|> o
  ,reg2dp_dma_en                  //|> o
  ,reg2dp_dst_base_addr_high      //|> o
  ,reg2dp_dst_base_addr_low       //|> o
  ,reg2dp_dst_line_stride         //|> o
  ,reg2dp_dst_ram_type            //|> o
  ,reg2dp_dst_surface_stride      //|> o
  ,reg2dp_flying_mode             //|> o
  ,reg2dp_input_data              //|> o
  ,reg2dp_interrupt_ptr           //|> o
  ,reg2dp_kernel_height           //|> o
  ,reg2dp_kernel_stride_height    //|> o
  ,reg2dp_kernel_stride_width     //|> o
  ,reg2dp_kernel_width            //|> o
  ,reg2dp_nan_to_zero             //|> o
  ,reg2dp_op_en                   //|> o
  ,reg2dp_pad_bottom              //|> o
  ,reg2dp_pad_left                //|> o
  ,reg2dp_pad_right               //|> o
  ,reg2dp_pad_top                 //|> o
  ,reg2dp_pad_value_1x            //|> o
  ,reg2dp_pad_value_2x            //|> o
  ,reg2dp_pad_value_3x            //|> o
  ,reg2dp_pad_value_4x            //|> o
  ,reg2dp_pad_value_5x            //|> o
  ,reg2dp_pad_value_6x            //|> o
  ,reg2dp_pad_value_7x            //|> o
  ,reg2dp_partial_width_in_first  //|> o
  ,reg2dp_partial_width_in_last   //|> o
  ,reg2dp_partial_width_in_mid    //|> o
  ,reg2dp_partial_width_out_first //|> o
  ,reg2dp_partial_width_out_last  //|> o
  ,reg2dp_partial_width_out_mid   //|> o
  ,reg2dp_pooling_method          //|> o
  ,reg2dp_recip_kernel_height     //|> o
  ,reg2dp_recip_kernel_width      //|> o
  ,reg2dp_split_num               //|> o
  ,reg2dp_src_base_addr_high      //|> o
  ,reg2dp_src_base_addr_low       //|> o
  ,reg2dp_src_line_stride         //|> o
  ,reg2dp_src_surface_stride      //|> o
  ,slcg_op_en                     //|> o
  );


input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [62:0] csb2pdp_req_pd;
input         csb2pdp_req_pvld;
input  [31:0] dp2reg_d0_perf_write_stall;
input  [31:0] dp2reg_d1_perf_write_stall;
input         dp2reg_done;
input  [31:0] dp2reg_inf_input_num;
input  [31:0] dp2reg_nan_input_num;
input  [31:0] dp2reg_nan_output_num;
output        csb2pdp_req_prdy;
output [33:0] pdp2csb_resp_pd;
output        pdp2csb_resp_valid;
output [12:0] reg2dp_cube_in_channel;
output [12:0] reg2dp_cube_in_height;
output [12:0] reg2dp_cube_in_width;
output [12:0] reg2dp_cube_out_channel;
output [12:0] reg2dp_cube_out_height;
output [12:0] reg2dp_cube_out_width;
output [31:0] reg2dp_cya;
output        reg2dp_dma_en;
output [31:0] reg2dp_dst_base_addr_high;
output [31:0] reg2dp_dst_base_addr_low;
output [31:0] reg2dp_dst_line_stride;
output        reg2dp_dst_ram_type;
output [31:0] reg2dp_dst_surface_stride;
output        reg2dp_flying_mode;
output  [1:0] reg2dp_input_data;
output        reg2dp_interrupt_ptr;
output  [3:0] reg2dp_kernel_height;
output  [3:0] reg2dp_kernel_stride_height;
output  [3:0] reg2dp_kernel_stride_width;
output  [3:0] reg2dp_kernel_width;
output        reg2dp_nan_to_zero;
output        reg2dp_op_en;
output  [2:0] reg2dp_pad_bottom;
output  [2:0] reg2dp_pad_left;
output  [2:0] reg2dp_pad_right;
output  [2:0] reg2dp_pad_top;
output [18:0] reg2dp_pad_value_1x;
output [18:0] reg2dp_pad_value_2x;
output [18:0] reg2dp_pad_value_3x;
output [18:0] reg2dp_pad_value_4x;
output [18:0] reg2dp_pad_value_5x;
output [18:0] reg2dp_pad_value_6x;
output [18:0] reg2dp_pad_value_7x;
output  [9:0] reg2dp_partial_width_in_first;
output  [9:0] reg2dp_partial_width_in_last;
output  [9:0] reg2dp_partial_width_in_mid;
output  [9:0] reg2dp_partial_width_out_first;
output  [9:0] reg2dp_partial_width_out_last;
output  [9:0] reg2dp_partial_width_out_mid;
output  [1:0] reg2dp_pooling_method;
output [16:0] reg2dp_recip_kernel_height;
output [16:0] reg2dp_recip_kernel_width;
output  [7:0] reg2dp_split_num;
output [31:0] reg2dp_src_base_addr_high;
output [31:0] reg2dp_src_base_addr_low;
output [31:0] reg2dp_src_line_stride;
output [31:0] reg2dp_src_surface_stride;
output  [2:0] slcg_op_en;
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
wire   [12:0] reg2dp_d0_cube_in_channel;
wire   [12:0] reg2dp_d0_cube_in_height;
wire   [12:0] reg2dp_d0_cube_in_width;
wire   [12:0] reg2dp_d0_cube_out_channel;
wire   [12:0] reg2dp_d0_cube_out_height;
wire   [12:0] reg2dp_d0_cube_out_width;
wire   [31:0] reg2dp_d0_cya;
wire          reg2dp_d0_dma_en;
wire   [31:0] reg2dp_d0_dst_base_addr_high;
wire   [31:0] reg2dp_d0_dst_base_addr_low;
wire   [31:0] reg2dp_d0_dst_line_stride;
wire          reg2dp_d0_dst_ram_type;
wire   [31:0] reg2dp_d0_dst_surface_stride;
wire          reg2dp_d0_flying_mode;
wire    [1:0] reg2dp_d0_input_data;
wire    [3:0] reg2dp_d0_kernel_height;
wire    [3:0] reg2dp_d0_kernel_stride_height;
wire    [3:0] reg2dp_d0_kernel_stride_width;
wire    [3:0] reg2dp_d0_kernel_width;
wire          reg2dp_d0_nan_to_zero;
wire          reg2dp_d0_op_en_trigger;
wire    [2:0] reg2dp_d0_pad_bottom;
wire    [2:0] reg2dp_d0_pad_left;
wire    [2:0] reg2dp_d0_pad_right;
wire    [2:0] reg2dp_d0_pad_top;
wire   [18:0] reg2dp_d0_pad_value_1x;
wire   [18:0] reg2dp_d0_pad_value_2x;
wire   [18:0] reg2dp_d0_pad_value_3x;
wire   [18:0] reg2dp_d0_pad_value_4x;
wire   [18:0] reg2dp_d0_pad_value_5x;
wire   [18:0] reg2dp_d0_pad_value_6x;
wire   [18:0] reg2dp_d0_pad_value_7x;
wire    [9:0] reg2dp_d0_partial_width_in_first;
wire    [9:0] reg2dp_d0_partial_width_in_last;
wire    [9:0] reg2dp_d0_partial_width_in_mid;
wire    [9:0] reg2dp_d0_partial_width_out_first;
wire    [9:0] reg2dp_d0_partial_width_out_last;
wire    [9:0] reg2dp_d0_partial_width_out_mid;
wire    [1:0] reg2dp_d0_pooling_method;
wire   [16:0] reg2dp_d0_recip_kernel_height;
wire   [16:0] reg2dp_d0_recip_kernel_width;
wire    [7:0] reg2dp_d0_split_num;
wire   [31:0] reg2dp_d0_src_base_addr_high;
wire   [31:0] reg2dp_d0_src_base_addr_low;
wire   [31:0] reg2dp_d0_src_line_stride;
wire   [31:0] reg2dp_d0_src_surface_stride;
wire   [12:0] reg2dp_d1_cube_in_channel;
wire   [12:0] reg2dp_d1_cube_in_height;
wire   [12:0] reg2dp_d1_cube_in_width;
wire   [12:0] reg2dp_d1_cube_out_channel;
wire   [12:0] reg2dp_d1_cube_out_height;
wire   [12:0] reg2dp_d1_cube_out_width;
wire   [31:0] reg2dp_d1_cya;
wire          reg2dp_d1_dma_en;
wire   [31:0] reg2dp_d1_dst_base_addr_high;
wire   [31:0] reg2dp_d1_dst_base_addr_low;
wire   [31:0] reg2dp_d1_dst_line_stride;
wire          reg2dp_d1_dst_ram_type;
wire   [31:0] reg2dp_d1_dst_surface_stride;
wire          reg2dp_d1_flying_mode;
wire    [1:0] reg2dp_d1_input_data;
wire    [3:0] reg2dp_d1_kernel_height;
wire    [3:0] reg2dp_d1_kernel_stride_height;
wire    [3:0] reg2dp_d1_kernel_stride_width;
wire    [3:0] reg2dp_d1_kernel_width;
wire          reg2dp_d1_nan_to_zero;
wire          reg2dp_d1_op_en_trigger;
wire    [2:0] reg2dp_d1_pad_bottom;
wire    [2:0] reg2dp_d1_pad_left;
wire    [2:0] reg2dp_d1_pad_right;
wire    [2:0] reg2dp_d1_pad_top;
wire   [18:0] reg2dp_d1_pad_value_1x;
wire   [18:0] reg2dp_d1_pad_value_2x;
wire   [18:0] reg2dp_d1_pad_value_3x;
wire   [18:0] reg2dp_d1_pad_value_4x;
wire   [18:0] reg2dp_d1_pad_value_5x;
wire   [18:0] reg2dp_d1_pad_value_6x;
wire   [18:0] reg2dp_d1_pad_value_7x;
wire    [9:0] reg2dp_d1_partial_width_in_first;
wire    [9:0] reg2dp_d1_partial_width_in_last;
wire    [9:0] reg2dp_d1_partial_width_in_mid;
wire    [9:0] reg2dp_d1_partial_width_out_first;
wire    [9:0] reg2dp_d1_partial_width_out_last;
wire    [9:0] reg2dp_d1_partial_width_out_mid;
wire    [1:0] reg2dp_d1_pooling_method;
wire   [16:0] reg2dp_d1_recip_kernel_height;
wire   [16:0] reg2dp_d1_recip_kernel_width;
wire    [7:0] reg2dp_d1_split_num;
wire   [31:0] reg2dp_d1_src_base_addr_high;
wire   [31:0] reg2dp_d1_src_base_addr_low;
wire   [31:0] reg2dp_d1_src_line_stride;
wire   [31:0] reg2dp_d1_src_surface_stride;
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
wire    [2:0] slcg_op_en_d0;
reg           dp2reg_consumer;
reg           dp2reg_d0_clr;
reg    [31:0] dp2reg_d0_inf_input_num;
reg    [31:0] dp2reg_d0_inf_input_num_w;
reg    [31:0] dp2reg_d0_nan_input_num;
reg    [31:0] dp2reg_d0_nan_input_num_w;
reg    [31:0] dp2reg_d0_nan_output_num;
reg    [31:0] dp2reg_d0_nan_output_num_w;
reg           dp2reg_d0_reg;
reg           dp2reg_d0_set;
reg           dp2reg_d1_clr;
reg    [31:0] dp2reg_d1_inf_input_num;
reg    [31:0] dp2reg_d1_inf_input_num_w;
reg    [31:0] dp2reg_d1_nan_input_num;
reg    [31:0] dp2reg_d1_nan_input_num_w;
reg    [31:0] dp2reg_d1_nan_output_num;
reg    [31:0] dp2reg_d1_nan_output_num_w;
reg           dp2reg_d1_reg;
reg           dp2reg_d1_set;
reg     [1:0] dp2reg_status_0;
reg     [1:0] dp2reg_status_1;
reg    [33:0] pdp2csb_resp_pd;
reg           pdp2csb_resp_valid;
reg    [12:0] reg2dp_cube_in_channel;
reg    [12:0] reg2dp_cube_in_height;
reg    [12:0] reg2dp_cube_in_width;
reg    [12:0] reg2dp_cube_out_channel;
reg    [12:0] reg2dp_cube_out_height;
reg    [12:0] reg2dp_cube_out_width;
reg    [31:0] reg2dp_cya;
reg           reg2dp_d0_op_en;
reg           reg2dp_d0_op_en_w;
reg           reg2dp_d1_op_en;
reg           reg2dp_d1_op_en_w;
reg           reg2dp_dma_en;
reg    [31:0] reg2dp_dst_base_addr_high;
reg    [31:0] reg2dp_dst_base_addr_low;
reg    [31:0] reg2dp_dst_line_stride;
reg           reg2dp_dst_ram_type;
reg    [31:0] reg2dp_dst_surface_stride;
reg           reg2dp_flying_mode;
reg     [1:0] reg2dp_input_data;
reg     [3:0] reg2dp_kernel_height;
reg     [3:0] reg2dp_kernel_stride_height;
reg     [3:0] reg2dp_kernel_stride_width;
reg     [3:0] reg2dp_kernel_width;
reg           reg2dp_nan_to_zero;
reg           reg2dp_op_en_ori;
reg     [2:0] reg2dp_op_en_reg;
reg     [2:0] reg2dp_pad_bottom;
reg     [2:0] reg2dp_pad_left;
reg     [2:0] reg2dp_pad_right;
reg     [2:0] reg2dp_pad_top;
reg    [18:0] reg2dp_pad_value_1x;
reg    [18:0] reg2dp_pad_value_2x;
reg    [18:0] reg2dp_pad_value_3x;
reg    [18:0] reg2dp_pad_value_4x;
reg    [18:0] reg2dp_pad_value_5x;
reg    [18:0] reg2dp_pad_value_6x;
reg    [18:0] reg2dp_pad_value_7x;
reg     [9:0] reg2dp_partial_width_in_first;
reg     [9:0] reg2dp_partial_width_in_last;
reg     [9:0] reg2dp_partial_width_in_mid;
reg     [9:0] reg2dp_partial_width_out_first;
reg     [9:0] reg2dp_partial_width_out_last;
reg     [9:0] reg2dp_partial_width_out_mid;
reg     [1:0] reg2dp_pooling_method;
reg    [16:0] reg2dp_recip_kernel_height;
reg    [16:0] reg2dp_recip_kernel_width;
reg     [7:0] reg2dp_split_num;
reg    [31:0] reg2dp_src_base_addr_high;
reg    [31:0] reg2dp_src_base_addr_low;
reg    [31:0] reg2dp_src_line_stride;
reg    [31:0] reg2dp_src_surface_stride;
reg    [62:0] req_pd;
reg           req_pvld;
reg     [2:0] slcg_op_en_d1;
reg     [2:0] slcg_op_en_d2;
reg     [2:0] slcg_op_en_d3;


//Instance single register group
NV_NVDLA_PDP_REG_single u_single_reg (
   .reg_rd_data             (s_reg_rd_data[31:0])                    //|> w
  ,.reg_offset              (s_reg_offset[11:0])                     //|< w
  ,.reg_wr_data             (s_reg_wr_data[31:0])                    //|< w
  ,.reg_wr_en               (s_reg_wr_en)                            //|< w
  ,.nvdla_core_clk          (nvdla_core_clk)                         //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)                        //|< i
  ,.producer                (reg2dp_producer)                        //|> w
  ,.consumer                (dp2reg_consumer)                        //|< r
  ,.status_0                (dp2reg_status_0[1:0])                   //|< r
  ,.status_1                (dp2reg_status_1[1:0])                   //|< r
  );

//Instance two duplicated register groups

NV_NVDLA_PDP_REG_dual u_dual_reg_d0 (
   .reg_rd_data             (d0_reg_rd_data[31:0])                   //|> w
  ,.reg_offset              (d0_reg_offset[11:0])                    //|< w
  ,.reg_wr_data             (d0_reg_wr_data[31:0])                   //|< w
  ,.reg_wr_en               (d0_reg_wr_en)                           //|< w
  ,.nvdla_core_clk          (nvdla_core_clk)                         //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)                        //|< i
  ,.cya                     (reg2dp_d0_cya[31:0])                    //|> w
  ,.cube_in_channel         (reg2dp_d0_cube_in_channel[12:0])        //|> w
  ,.cube_in_height          (reg2dp_d0_cube_in_height[12:0])         //|> w
  ,.cube_in_width           (reg2dp_d0_cube_in_width[12:0])          //|> w
  ,.cube_out_channel        (reg2dp_d0_cube_out_channel[12:0])       //|> w
  ,.cube_out_height         (reg2dp_d0_cube_out_height[12:0])        //|> w
  ,.cube_out_width          (reg2dp_d0_cube_out_width[12:0])         //|> w
  ,.input_data              (reg2dp_d0_input_data[1:0])              //|> w
  ,.dst_base_addr_high      (reg2dp_d0_dst_base_addr_high[31:0])     //|> w
  ,.dst_base_addr_low       (reg2dp_d0_dst_base_addr_low[31:0])      //|> w
  ,.dst_line_stride         (reg2dp_d0_dst_line_stride[31:0])        //|> w
  ,.dst_ram_type            (reg2dp_d0_dst_ram_type)                 //|> w
  ,.dst_surface_stride      (reg2dp_d0_dst_surface_stride[31:0])     //|> w
  ,.nan_to_zero             (reg2dp_d0_nan_to_zero)                  //|> w
  ,.flying_mode             (reg2dp_d0_flying_mode)                  //|> w
  ,.pooling_method          (reg2dp_d0_pooling_method[1:0])          //|> w
  ,.split_num               (reg2dp_d0_split_num[7:0])               //|> w
  ,.op_en_trigger           (reg2dp_d0_op_en_trigger)                //|> w
  ,.partial_width_in_first  (reg2dp_d0_partial_width_in_first[9:0])  //|> w
  ,.partial_width_in_last   (reg2dp_d0_partial_width_in_last[9:0])   //|> w
  ,.partial_width_in_mid    (reg2dp_d0_partial_width_in_mid[9:0])    //|> w
  ,.partial_width_out_first (reg2dp_d0_partial_width_out_first[9:0]) //|> w
  ,.partial_width_out_last  (reg2dp_d0_partial_width_out_last[9:0])  //|> w
  ,.partial_width_out_mid   (reg2dp_d0_partial_width_out_mid[9:0])   //|> w
  ,.dma_en                  (reg2dp_d0_dma_en)                       //|> w
  ,.kernel_height           (reg2dp_d0_kernel_height[3:0])           //|> w
  ,.kernel_stride_height    (reg2dp_d0_kernel_stride_height[3:0])    //|> w
  ,.kernel_stride_width     (reg2dp_d0_kernel_stride_width[3:0])     //|> w
  ,.kernel_width            (reg2dp_d0_kernel_width[3:0])            //|> w
  ,.pad_bottom              (reg2dp_d0_pad_bottom[2:0])              //|> w
  ,.pad_left                (reg2dp_d0_pad_left[2:0])                //|> w
  ,.pad_right               (reg2dp_d0_pad_right[2:0])               //|> w
  ,.pad_top                 (reg2dp_d0_pad_top[2:0])                 //|> w
  ,.pad_value_1x            (reg2dp_d0_pad_value_1x[18:0])           //|> w
  ,.pad_value_2x            (reg2dp_d0_pad_value_2x[18:0])           //|> w
  ,.pad_value_3x            (reg2dp_d0_pad_value_3x[18:0])           //|> w
  ,.pad_value_4x            (reg2dp_d0_pad_value_4x[18:0])           //|> w
  ,.pad_value_5x            (reg2dp_d0_pad_value_5x[18:0])           //|> w
  ,.pad_value_6x            (reg2dp_d0_pad_value_6x[18:0])           //|> w
  ,.pad_value_7x            (reg2dp_d0_pad_value_7x[18:0])           //|> w
  ,.recip_kernel_height     (reg2dp_d0_recip_kernel_height[16:0])    //|> w
  ,.recip_kernel_width      (reg2dp_d0_recip_kernel_width[16:0])     //|> w
  ,.src_base_addr_high      (reg2dp_d0_src_base_addr_high[31:0])     //|> w
  ,.src_base_addr_low       (reg2dp_d0_src_base_addr_low[31:0])      //|> w
  ,.src_line_stride         (reg2dp_d0_src_line_stride[31:0])        //|> w
  ,.src_surface_stride      (reg2dp_d0_src_surface_stride[31:0])     //|> w
  ,.inf_input_num           (dp2reg_d0_inf_input_num[31:0])          //|< r
  ,.nan_input_num           (dp2reg_d0_nan_input_num[31:0])          //|< r
  ,.nan_output_num          (dp2reg_d0_nan_output_num[31:0])         //|< r
  ,.op_en                   (reg2dp_d0_op_en)                        //|< r
  ,.perf_write_stall        (dp2reg_d0_perf_write_stall[31:0])       //|< i
  );
        
NV_NVDLA_PDP_REG_dual u_dual_reg_d1 (
   .reg_rd_data             (d1_reg_rd_data[31:0])                   //|> w
  ,.reg_offset              (d1_reg_offset[11:0])                    //|< w
  ,.reg_wr_data             (d1_reg_wr_data[31:0])                   //|< w
  ,.reg_wr_en               (d1_reg_wr_en)                           //|< w
  ,.nvdla_core_clk          (nvdla_core_clk)                         //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)                        //|< i
  ,.cya                     (reg2dp_d1_cya[31:0])                    //|> w
  ,.cube_in_channel         (reg2dp_d1_cube_in_channel[12:0])        //|> w
  ,.cube_in_height          (reg2dp_d1_cube_in_height[12:0])         //|> w
  ,.cube_in_width           (reg2dp_d1_cube_in_width[12:0])          //|> w
  ,.cube_out_channel        (reg2dp_d1_cube_out_channel[12:0])       //|> w
  ,.cube_out_height         (reg2dp_d1_cube_out_height[12:0])        //|> w
  ,.cube_out_width          (reg2dp_d1_cube_out_width[12:0])         //|> w
  ,.input_data              (reg2dp_d1_input_data[1:0])              //|> w
  ,.dst_base_addr_high      (reg2dp_d1_dst_base_addr_high[31:0])     //|> w
  ,.dst_base_addr_low       (reg2dp_d1_dst_base_addr_low[31:0])      //|> w
  ,.dst_line_stride         (reg2dp_d1_dst_line_stride[31:0])        //|> w
  ,.dst_ram_type            (reg2dp_d1_dst_ram_type)                 //|> w
  ,.dst_surface_stride      (reg2dp_d1_dst_surface_stride[31:0])     //|> w
  ,.nan_to_zero             (reg2dp_d1_nan_to_zero)                  //|> w
  ,.flying_mode             (reg2dp_d1_flying_mode)                  //|> w
  ,.pooling_method          (reg2dp_d1_pooling_method[1:0])          //|> w
  ,.split_num               (reg2dp_d1_split_num[7:0])               //|> w
  ,.op_en_trigger           (reg2dp_d1_op_en_trigger)                //|> w
  ,.partial_width_in_first  (reg2dp_d1_partial_width_in_first[9:0])  //|> w
  ,.partial_width_in_last   (reg2dp_d1_partial_width_in_last[9:0])   //|> w
  ,.partial_width_in_mid    (reg2dp_d1_partial_width_in_mid[9:0])    //|> w
  ,.partial_width_out_first (reg2dp_d1_partial_width_out_first[9:0]) //|> w
  ,.partial_width_out_last  (reg2dp_d1_partial_width_out_last[9:0])  //|> w
  ,.partial_width_out_mid   (reg2dp_d1_partial_width_out_mid[9:0])   //|> w
  ,.dma_en                  (reg2dp_d1_dma_en)                       //|> w
  ,.kernel_height           (reg2dp_d1_kernel_height[3:0])           //|> w
  ,.kernel_stride_height    (reg2dp_d1_kernel_stride_height[3:0])    //|> w
  ,.kernel_stride_width     (reg2dp_d1_kernel_stride_width[3:0])     //|> w
  ,.kernel_width            (reg2dp_d1_kernel_width[3:0])            //|> w
  ,.pad_bottom              (reg2dp_d1_pad_bottom[2:0])              //|> w
  ,.pad_left                (reg2dp_d1_pad_left[2:0])                //|> w
  ,.pad_right               (reg2dp_d1_pad_right[2:0])               //|> w
  ,.pad_top                 (reg2dp_d1_pad_top[2:0])                 //|> w
  ,.pad_value_1x            (reg2dp_d1_pad_value_1x[18:0])           //|> w
  ,.pad_value_2x            (reg2dp_d1_pad_value_2x[18:0])           //|> w
  ,.pad_value_3x            (reg2dp_d1_pad_value_3x[18:0])           //|> w
  ,.pad_value_4x            (reg2dp_d1_pad_value_4x[18:0])           //|> w
  ,.pad_value_5x            (reg2dp_d1_pad_value_5x[18:0])           //|> w
  ,.pad_value_6x            (reg2dp_d1_pad_value_6x[18:0])           //|> w
  ,.pad_value_7x            (reg2dp_d1_pad_value_7x[18:0])           //|> w
  ,.recip_kernel_height     (reg2dp_d1_recip_kernel_height[16:0])    //|> w
  ,.recip_kernel_width      (reg2dp_d1_recip_kernel_width[16:0])     //|> w
  ,.src_base_addr_high      (reg2dp_d1_src_base_addr_high[31:0])     //|> w
  ,.src_base_addr_low       (reg2dp_d1_src_base_addr_low[31:0])      //|> w
  ,.src_line_stride         (reg2dp_d1_src_line_stride[31:0])        //|> w
  ,.src_surface_stride      (reg2dp_d1_src_surface_stride[31:0])     //|> w
  ,.inf_input_num           (dp2reg_d1_inf_input_num[31:0])          //|< r
  ,.nan_input_num           (dp2reg_d1_nan_input_num[31:0])          //|< r
  ,.nan_output_num          (dp2reg_d1_nan_output_num[31:0])         //|< r
  ,.op_en                   (reg2dp_d1_op_en)                        //|< r
  ,.perf_write_stall        (dp2reg_d1_perf_write_stall[31:0])       //|< i
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

assign slcg_op_en_d0 = {3{reg2dp_op_en_ori}};

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_op_en_d1 <= {3{1'b0}};
  end else begin
  slcg_op_en_d1 <= slcg_op_en_d0;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_op_en_d2 <= {3{1'b0}};
  end else begin
  slcg_op_en_d2 <= slcg_op_en_d1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_op_en_d3 <= {3{1'b0}};
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
assign select_s  = (reg_offset[11:0] < (32'hd008  & 32'hfff)) ? 1'b1: 1'b0;
assign select_d0 = (reg_offset[11:0] >= (32'hd008  & 32'hfff)) & (reg2dp_producer == 1'h0 );
assign select_d1 = (reg_offset[11:0] >= (32'hd008  & 32'hfff)) & (reg2dp_producer == 1'h1 );

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
  req_pvld <= csb2pdp_req_pvld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_pd <= {63{1'b0}};
  end else begin
  if ((csb2pdp_req_pvld) == 1'b1) begin
    req_pd <= csb2pdp_req_pd;
  // VCS coverage off
  end else if ((csb2pdp_req_pvld) == 1'b0) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(csb2pdp_req_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign csb2pdp_req_prdy = 1'b1;


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
    pdp2csb_resp_pd <= {34{1'b0}};
  end else begin
    if(reg_rd_en)
    begin
        pdp2csb_resp_pd <= csb_rresp_pd_w;
    end
    else if(reg_wr_en & req_nposted)
    begin
        pdp2csb_resp_pd <= csb_wresp_pd_w;
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pdp2csb_resp_valid <= 1'b0;
  end else begin
    pdp2csb_resp_valid <= (reg_wr_en & req_nposted) | reg_rd_en;
  end
end

////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE OUTPUT REGISTER FILED FROM DUPLICATED REGISTER GROUPS     //
//                                                                    //
////////////////////////////////////////////////////////////////////////
always @(
  dp2reg_consumer
  or reg2dp_d1_cya
  or reg2dp_d0_cya
  ) begin
    reg2dp_cya = dp2reg_consumer ? reg2dp_d1_cya : reg2dp_d0_cya;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_cube_in_channel
  or reg2dp_d0_cube_in_channel
  ) begin
    reg2dp_cube_in_channel = dp2reg_consumer ? reg2dp_d1_cube_in_channel : reg2dp_d0_cube_in_channel;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_cube_in_height
  or reg2dp_d0_cube_in_height
  ) begin
    reg2dp_cube_in_height = dp2reg_consumer ? reg2dp_d1_cube_in_height : reg2dp_d0_cube_in_height;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_cube_in_width
  or reg2dp_d0_cube_in_width
  ) begin
    reg2dp_cube_in_width = dp2reg_consumer ? reg2dp_d1_cube_in_width : reg2dp_d0_cube_in_width;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_cube_out_channel
  or reg2dp_d0_cube_out_channel
  ) begin
    reg2dp_cube_out_channel = dp2reg_consumer ? reg2dp_d1_cube_out_channel : reg2dp_d0_cube_out_channel;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_cube_out_height
  or reg2dp_d0_cube_out_height
  ) begin
    reg2dp_cube_out_height = dp2reg_consumer ? reg2dp_d1_cube_out_height : reg2dp_d0_cube_out_height;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_cube_out_width
  or reg2dp_d0_cube_out_width
  ) begin
    reg2dp_cube_out_width = dp2reg_consumer ? reg2dp_d1_cube_out_width : reg2dp_d0_cube_out_width;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_input_data
  or reg2dp_d0_input_data
  ) begin
    reg2dp_input_data = dp2reg_consumer ? reg2dp_d1_input_data : reg2dp_d0_input_data;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_dst_base_addr_high
  or reg2dp_d0_dst_base_addr_high
  ) begin
    reg2dp_dst_base_addr_high = dp2reg_consumer ? reg2dp_d1_dst_base_addr_high : reg2dp_d0_dst_base_addr_high;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_dst_base_addr_low
  or reg2dp_d0_dst_base_addr_low
  ) begin
    reg2dp_dst_base_addr_low = dp2reg_consumer ? reg2dp_d1_dst_base_addr_low : reg2dp_d0_dst_base_addr_low;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_dst_line_stride
  or reg2dp_d0_dst_line_stride
  ) begin
    reg2dp_dst_line_stride = dp2reg_consumer ? reg2dp_d1_dst_line_stride : reg2dp_d0_dst_line_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_dst_ram_type
  or reg2dp_d0_dst_ram_type
  ) begin
    reg2dp_dst_ram_type = dp2reg_consumer ? reg2dp_d1_dst_ram_type : reg2dp_d0_dst_ram_type;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_dst_surface_stride
  or reg2dp_d0_dst_surface_stride
  ) begin
    reg2dp_dst_surface_stride = dp2reg_consumer ? reg2dp_d1_dst_surface_stride : reg2dp_d0_dst_surface_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_nan_to_zero
  or reg2dp_d0_nan_to_zero
  ) begin
    reg2dp_nan_to_zero = dp2reg_consumer ? reg2dp_d1_nan_to_zero : reg2dp_d0_nan_to_zero;
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
  or reg2dp_d1_pooling_method
  or reg2dp_d0_pooling_method
  ) begin
    reg2dp_pooling_method = dp2reg_consumer ? reg2dp_d1_pooling_method : reg2dp_d0_pooling_method;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_split_num
  or reg2dp_d0_split_num
  ) begin
    reg2dp_split_num = dp2reg_consumer ? reg2dp_d1_split_num : reg2dp_d0_split_num;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_partial_width_in_first
  or reg2dp_d0_partial_width_in_first
  ) begin
    reg2dp_partial_width_in_first = dp2reg_consumer ? reg2dp_d1_partial_width_in_first : reg2dp_d0_partial_width_in_first;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_partial_width_in_last
  or reg2dp_d0_partial_width_in_last
  ) begin
    reg2dp_partial_width_in_last = dp2reg_consumer ? reg2dp_d1_partial_width_in_last : reg2dp_d0_partial_width_in_last;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_partial_width_in_mid
  or reg2dp_d0_partial_width_in_mid
  ) begin
    reg2dp_partial_width_in_mid = dp2reg_consumer ? reg2dp_d1_partial_width_in_mid : reg2dp_d0_partial_width_in_mid;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_partial_width_out_first
  or reg2dp_d0_partial_width_out_first
  ) begin
    reg2dp_partial_width_out_first = dp2reg_consumer ? reg2dp_d1_partial_width_out_first : reg2dp_d0_partial_width_out_first;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_partial_width_out_last
  or reg2dp_d0_partial_width_out_last
  ) begin
    reg2dp_partial_width_out_last = dp2reg_consumer ? reg2dp_d1_partial_width_out_last : reg2dp_d0_partial_width_out_last;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_partial_width_out_mid
  or reg2dp_d0_partial_width_out_mid
  ) begin
    reg2dp_partial_width_out_mid = dp2reg_consumer ? reg2dp_d1_partial_width_out_mid : reg2dp_d0_partial_width_out_mid;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_dma_en
  or reg2dp_d0_dma_en
  ) begin
    reg2dp_dma_en = dp2reg_consumer ? reg2dp_d1_dma_en : reg2dp_d0_dma_en;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_kernel_height
  or reg2dp_d0_kernel_height
  ) begin
    reg2dp_kernel_height = dp2reg_consumer ? reg2dp_d1_kernel_height : reg2dp_d0_kernel_height;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_kernel_stride_height
  or reg2dp_d0_kernel_stride_height
  ) begin
    reg2dp_kernel_stride_height = dp2reg_consumer ? reg2dp_d1_kernel_stride_height : reg2dp_d0_kernel_stride_height;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_kernel_stride_width
  or reg2dp_d0_kernel_stride_width
  ) begin
    reg2dp_kernel_stride_width = dp2reg_consumer ? reg2dp_d1_kernel_stride_width : reg2dp_d0_kernel_stride_width;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_kernel_width
  or reg2dp_d0_kernel_width
  ) begin
    reg2dp_kernel_width = dp2reg_consumer ? reg2dp_d1_kernel_width : reg2dp_d0_kernel_width;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_bottom
  or reg2dp_d0_pad_bottom
  ) begin
    reg2dp_pad_bottom = dp2reg_consumer ? reg2dp_d1_pad_bottom : reg2dp_d0_pad_bottom;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_left
  or reg2dp_d0_pad_left
  ) begin
    reg2dp_pad_left = dp2reg_consumer ? reg2dp_d1_pad_left : reg2dp_d0_pad_left;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_right
  or reg2dp_d0_pad_right
  ) begin
    reg2dp_pad_right = dp2reg_consumer ? reg2dp_d1_pad_right : reg2dp_d0_pad_right;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_top
  or reg2dp_d0_pad_top
  ) begin
    reg2dp_pad_top = dp2reg_consumer ? reg2dp_d1_pad_top : reg2dp_d0_pad_top;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_value_1x
  or reg2dp_d0_pad_value_1x
  ) begin
    reg2dp_pad_value_1x = dp2reg_consumer ? reg2dp_d1_pad_value_1x : reg2dp_d0_pad_value_1x;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_value_2x
  or reg2dp_d0_pad_value_2x
  ) begin
    reg2dp_pad_value_2x = dp2reg_consumer ? reg2dp_d1_pad_value_2x : reg2dp_d0_pad_value_2x;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_value_3x
  or reg2dp_d0_pad_value_3x
  ) begin
    reg2dp_pad_value_3x = dp2reg_consumer ? reg2dp_d1_pad_value_3x : reg2dp_d0_pad_value_3x;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_value_4x
  or reg2dp_d0_pad_value_4x
  ) begin
    reg2dp_pad_value_4x = dp2reg_consumer ? reg2dp_d1_pad_value_4x : reg2dp_d0_pad_value_4x;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_value_5x
  or reg2dp_d0_pad_value_5x
  ) begin
    reg2dp_pad_value_5x = dp2reg_consumer ? reg2dp_d1_pad_value_5x : reg2dp_d0_pad_value_5x;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_value_6x
  or reg2dp_d0_pad_value_6x
  ) begin
    reg2dp_pad_value_6x = dp2reg_consumer ? reg2dp_d1_pad_value_6x : reg2dp_d0_pad_value_6x;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_value_7x
  or reg2dp_d0_pad_value_7x
  ) begin
    reg2dp_pad_value_7x = dp2reg_consumer ? reg2dp_d1_pad_value_7x : reg2dp_d0_pad_value_7x;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_recip_kernel_height
  or reg2dp_d0_recip_kernel_height
  ) begin
    reg2dp_recip_kernel_height = dp2reg_consumer ? reg2dp_d1_recip_kernel_height : reg2dp_d0_recip_kernel_height;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_recip_kernel_width
  or reg2dp_d0_recip_kernel_width
  ) begin
    reg2dp_recip_kernel_width = dp2reg_consumer ? reg2dp_d1_recip_kernel_width : reg2dp_d0_recip_kernel_width;
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
//assign reg2dp_lut_data = reg_wr_data[::range(15)];
assign reg2dp_interrupt_ptr = dp2reg_consumer;

//////// for general counting register ////////
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

//////// for NaN and infinity counting registers ////////
//////// group 0 ////////
always @(
  dp2reg_d0_set
  or dp2reg_nan_input_num
  or dp2reg_d0_clr
  or dp2reg_d0_nan_input_num
  ) begin
    dp2reg_d0_nan_input_num_w = (dp2reg_d0_set) ? dp2reg_nan_input_num :
                                 (dp2reg_d0_clr) ? 32'b0 :
                                 dp2reg_d0_nan_input_num;
end

always @(
  dp2reg_d0_set
  or dp2reg_inf_input_num
  or dp2reg_d0_clr
  or dp2reg_d0_inf_input_num
  ) begin
    dp2reg_d0_inf_input_num_w = (dp2reg_d0_set) ? dp2reg_inf_input_num :
                                 (dp2reg_d0_clr) ? 32'b0 :
                                 dp2reg_d0_inf_input_num;
end

always @(
  dp2reg_d0_set
  or dp2reg_nan_output_num
  or dp2reg_d0_clr
  or dp2reg_d0_nan_output_num
  ) begin
    dp2reg_d0_nan_output_num_w = (dp2reg_d0_set) ? dp2reg_nan_output_num :
                                 (dp2reg_d0_clr) ? 32'b0 :
                                 dp2reg_d0_nan_output_num;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_nan_input_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_nan_input_num <= dp2reg_d0_nan_input_num_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_nan_input_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_inf_input_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_inf_input_num <= dp2reg_d0_inf_input_num_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_inf_input_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_nan_output_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_nan_output_num <= dp2reg_d0_nan_output_num_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_nan_output_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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

//////// group 1 ////////
always @(
  dp2reg_d1_set
  or dp2reg_nan_input_num
  or dp2reg_d1_clr
  or dp2reg_d1_nan_input_num
  ) begin
    dp2reg_d1_nan_input_num_w = (dp2reg_d1_set) ? dp2reg_nan_input_num :
                                 (dp2reg_d1_clr) ? 32'b0 :
                                 dp2reg_d1_nan_input_num;
end

always @(
  dp2reg_d1_set
  or dp2reg_inf_input_num
  or dp2reg_d1_clr
  or dp2reg_d1_inf_input_num
  ) begin
    dp2reg_d1_inf_input_num_w = (dp2reg_d1_set) ? dp2reg_inf_input_num :
                                 (dp2reg_d1_clr) ? 32'b0 :
                                 dp2reg_d1_inf_input_num;
end

always @(
  dp2reg_d1_set
  or dp2reg_nan_output_num
  or dp2reg_d1_clr
  or dp2reg_d1_nan_output_num
  ) begin
    dp2reg_d1_nan_output_num_w = (dp2reg_d1_set) ? dp2reg_nan_output_num :
                                 (dp2reg_d1_clr) ? 32'b0 :
                                 dp2reg_d1_nan_output_num;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_nan_input_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_nan_input_num <= dp2reg_d1_nan_input_num_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_nan_input_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_inf_input_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_inf_input_num <= dp2reg_d1_inf_input_num_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_inf_input_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_nan_output_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_nan_output_num <= dp2reg_d1_nan_output_num_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_nan_output_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

endmodule // NV_NVDLA_PDP_reg

