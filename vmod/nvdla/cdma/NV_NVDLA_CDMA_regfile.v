// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_regfile.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CDMA_regfile (
   nvdla_core_clk             //|< i
  ,nvdla_core_rstn            //|< i
  ,csb2cdma_req_pd            //|< i
  ,csb2cdma_req_pvld          //|< i
  ,dp2reg_dat_flush_done      //|< i
  ,dp2reg_dc_rd_latency       //|< i
  ,dp2reg_dc_rd_stall         //|< i
  ,dp2reg_done                //|< i
  ,dp2reg_img_rd_latency      //|< i
  ,dp2reg_img_rd_stall        //|< i
  ,dp2reg_inf_data_num        //|< i
  ,dp2reg_inf_weight_num      //|< i
  ,dp2reg_nan_data_num        //|< i
  ,dp2reg_nan_weight_num      //|< i
  ,dp2reg_wg_rd_latency       //|< i
  ,dp2reg_wg_rd_stall         //|< i
  ,dp2reg_wt_flush_done       //|< i
  ,dp2reg_wt_rd_latency       //|< i
  ,dp2reg_wt_rd_stall         //|< i
  ,cdma2csb_resp_pd           //|> o
  ,cdma2csb_resp_valid        //|> o
  ,csb2cdma_req_prdy          //|> o
  ,dp2reg_consumer            //|> o
  ,reg2dp_arb_weight          //|> o
  ,reg2dp_arb_wmb             //|> o
  ,reg2dp_batch_stride        //|> o
  ,reg2dp_batches             //|> o
  ,reg2dp_byte_per_kernel     //|> o
  ,reg2dp_conv_mode           //|> o
  ,reg2dp_conv_x_stride       //|> o
  ,reg2dp_conv_y_stride       //|> o
  ,reg2dp_cvt_en              //|> o
  ,reg2dp_cvt_offset          //|> o
  ,reg2dp_cvt_scale           //|> o
  ,reg2dp_cvt_truncate        //|> o
  ,reg2dp_cya                 //|> o
  ,reg2dp_data_bank           //|> o
  ,reg2dp_data_reuse          //|> o
  ,reg2dp_datain_addr_high_0  //|> o
  ,reg2dp_datain_addr_high_1  //|> o
  ,reg2dp_datain_addr_low_0   //|> o
  ,reg2dp_datain_addr_low_1   //|> o
  ,reg2dp_datain_channel      //|> o
  ,reg2dp_datain_format       //|> o
  ,reg2dp_datain_height       //|> o
  ,reg2dp_datain_height_ext   //|> o
  ,reg2dp_datain_ram_type     //|> o
  ,reg2dp_datain_width        //|> o
  ,reg2dp_datain_width_ext    //|> o
  ,reg2dp_dma_en              //|> o
  ,reg2dp_entries             //|> o
  ,reg2dp_grains              //|> o
  ,reg2dp_in_precision        //|> o
  ,reg2dp_line_packed         //|> o
  ,reg2dp_line_stride         //|> o
  ,reg2dp_mean_ax             //|> o
  ,reg2dp_mean_bv             //|> o
  ,reg2dp_mean_format         //|> o
  ,reg2dp_mean_gu             //|> o
  ,reg2dp_mean_ry             //|> o
  ,reg2dp_nan_to_zero         //|> o
  ,reg2dp_op_en               //|> o
  ,reg2dp_pad_bottom          //|> o
  ,reg2dp_pad_left            //|> o
  ,reg2dp_pad_right           //|> o
  ,reg2dp_pad_top             //|> o
  ,reg2dp_pad_value           //|> o
  ,reg2dp_pixel_format        //|> o
  ,reg2dp_pixel_mapping       //|> o
  ,reg2dp_pixel_sign_override //|> o
  ,reg2dp_pixel_x_offset      //|> o
  ,reg2dp_pixel_y_offset      //|> o
  ,reg2dp_proc_precision      //|> o
  ,reg2dp_rsv_height          //|> o
  ,reg2dp_rsv_per_line        //|> o
  ,reg2dp_rsv_per_uv_line     //|> o
  ,reg2dp_rsv_y_index         //|> o
  ,reg2dp_skip_data_rls       //|> o
  ,reg2dp_skip_weight_rls     //|> o
  ,reg2dp_surf_packed         //|> o
  ,reg2dp_surf_stride         //|> o
  ,reg2dp_uv_line_stride      //|> o
  ,reg2dp_weight_addr_high    //|> o
  ,reg2dp_weight_addr_low     //|> o
  ,reg2dp_weight_bank         //|> o
  ,reg2dp_weight_bytes        //|> o
  ,reg2dp_weight_format       //|> o
  ,reg2dp_weight_kernel       //|> o
  ,reg2dp_weight_ram_type     //|> o
  ,reg2dp_weight_reuse        //|> o
  ,reg2dp_wgs_addr_high       //|> o
  ,reg2dp_wgs_addr_low        //|> o
  ,reg2dp_wmb_addr_high       //|> o
  ,reg2dp_wmb_addr_low        //|> o
  ,reg2dp_wmb_bytes           //|> o
  ,slcg_op_en                 //|> o
  );


input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [62:0] csb2cdma_req_pd;
input         csb2cdma_req_pvld;
input         dp2reg_dat_flush_done;
input  [31:0] dp2reg_dc_rd_latency;
input  [31:0] dp2reg_dc_rd_stall;
input         dp2reg_done;
input  [31:0] dp2reg_img_rd_latency;
input  [31:0] dp2reg_img_rd_stall;
input  [31:0] dp2reg_inf_data_num;
input  [31:0] dp2reg_inf_weight_num;
input  [31:0] dp2reg_nan_data_num;
input  [31:0] dp2reg_nan_weight_num;
input  [31:0] dp2reg_wg_rd_latency;
input  [31:0] dp2reg_wg_rd_stall;
input         dp2reg_wt_flush_done;
input  [31:0] dp2reg_wt_rd_latency;
input  [31:0] dp2reg_wt_rd_stall;
output [33:0] cdma2csb_resp_pd;
output        cdma2csb_resp_valid;
output        csb2cdma_req_prdy;
output        dp2reg_consumer;
output  [3:0] reg2dp_arb_weight;
output  [3:0] reg2dp_arb_wmb;
output [31:0] reg2dp_batch_stride;
output  [4:0] reg2dp_batches;
output [17:0] reg2dp_byte_per_kernel;
output        reg2dp_conv_mode;
output  [2:0] reg2dp_conv_x_stride;
output  [2:0] reg2dp_conv_y_stride;
output        reg2dp_cvt_en;
output [15:0] reg2dp_cvt_offset;
output [15:0] reg2dp_cvt_scale;
output  [5:0] reg2dp_cvt_truncate;
output [31:0] reg2dp_cya;
output  [4:0] reg2dp_data_bank;
output        reg2dp_data_reuse;
output [31:0] reg2dp_datain_addr_high_0;
output [31:0] reg2dp_datain_addr_high_1;
output [31:0] reg2dp_datain_addr_low_0;
output [31:0] reg2dp_datain_addr_low_1;
output [12:0] reg2dp_datain_channel;
output        reg2dp_datain_format;
output [12:0] reg2dp_datain_height;
output [12:0] reg2dp_datain_height_ext;
output        reg2dp_datain_ram_type;
output [12:0] reg2dp_datain_width;
output [12:0] reg2dp_datain_width_ext;
output        reg2dp_dma_en;
output [13:0] reg2dp_entries;
output [11:0] reg2dp_grains;
output  [1:0] reg2dp_in_precision;
output        reg2dp_line_packed;
output [31:0] reg2dp_line_stride;
output [15:0] reg2dp_mean_ax;
output [15:0] reg2dp_mean_bv;
output        reg2dp_mean_format;
output [15:0] reg2dp_mean_gu;
output [15:0] reg2dp_mean_ry;
output        reg2dp_nan_to_zero;
output        reg2dp_op_en;
output  [5:0] reg2dp_pad_bottom;
output  [4:0] reg2dp_pad_left;
output  [5:0] reg2dp_pad_right;
output  [4:0] reg2dp_pad_top;
output [15:0] reg2dp_pad_value;
output  [5:0] reg2dp_pixel_format;
output        reg2dp_pixel_mapping;
output        reg2dp_pixel_sign_override;
output  [4:0] reg2dp_pixel_x_offset;
output  [2:0] reg2dp_pixel_y_offset;
output  [1:0] reg2dp_proc_precision;
output  [2:0] reg2dp_rsv_height;
output  [9:0] reg2dp_rsv_per_line;
output  [9:0] reg2dp_rsv_per_uv_line;
output  [4:0] reg2dp_rsv_y_index;
output        reg2dp_skip_data_rls;
output        reg2dp_skip_weight_rls;
output        reg2dp_surf_packed;
output [31:0] reg2dp_surf_stride;
output [31:0] reg2dp_uv_line_stride;
output [31:0] reg2dp_weight_addr_high;
output [31:0] reg2dp_weight_addr_low;
output  [4:0] reg2dp_weight_bank;
output [31:0] reg2dp_weight_bytes;
output        reg2dp_weight_format;
output [12:0] reg2dp_weight_kernel;
output        reg2dp_weight_ram_type;
output        reg2dp_weight_reuse;
output [31:0] reg2dp_wgs_addr_high;
output [31:0] reg2dp_wgs_addr_low;
output [31:0] reg2dp_wmb_addr_high;
output [31:0] reg2dp_wmb_addr_low;
output [27:0] reg2dp_wmb_bytes;
output  [7:0] slcg_op_en;
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
wire   [31:0] reg2dp_d0_batch_stride;
wire    [4:0] reg2dp_d0_batches;
wire   [17:0] reg2dp_d0_byte_per_kernel;
wire          reg2dp_d0_conv_mode;
wire    [2:0] reg2dp_d0_conv_x_stride;
wire    [2:0] reg2dp_d0_conv_y_stride;
wire          reg2dp_d0_cvt_en;
wire   [15:0] reg2dp_d0_cvt_offset;
wire   [15:0] reg2dp_d0_cvt_scale;
wire    [5:0] reg2dp_d0_cvt_truncate;
wire   [31:0] reg2dp_d0_cya;
wire    [4:0] reg2dp_d0_data_bank;
wire          reg2dp_d0_data_reuse;
wire   [31:0] reg2dp_d0_datain_addr_high_0;
wire   [31:0] reg2dp_d0_datain_addr_high_1;
wire   [31:0] reg2dp_d0_datain_addr_low_0;
wire   [31:0] reg2dp_d0_datain_addr_low_1;
wire   [12:0] reg2dp_d0_datain_channel;
wire          reg2dp_d0_datain_format;
wire   [12:0] reg2dp_d0_datain_height;
wire   [12:0] reg2dp_d0_datain_height_ext;
wire          reg2dp_d0_datain_ram_type;
wire   [12:0] reg2dp_d0_datain_width;
wire   [12:0] reg2dp_d0_datain_width_ext;
wire          reg2dp_d0_dma_en;
wire   [13:0] reg2dp_d0_entries;
wire   [11:0] reg2dp_d0_grains;
wire    [1:0] reg2dp_d0_in_precision;
wire          reg2dp_d0_line_packed;
wire   [31:0] reg2dp_d0_line_stride;
wire   [15:0] reg2dp_d0_mean_ax;
wire   [15:0] reg2dp_d0_mean_bv;
wire          reg2dp_d0_mean_format;
wire   [15:0] reg2dp_d0_mean_gu;
wire   [15:0] reg2dp_d0_mean_ry;
wire          reg2dp_d0_nan_to_zero;
wire          reg2dp_d0_op_en_trigger;
wire    [5:0] reg2dp_d0_pad_bottom;
wire    [4:0] reg2dp_d0_pad_left;
wire    [5:0] reg2dp_d0_pad_right;
wire    [4:0] reg2dp_d0_pad_top;
wire   [15:0] reg2dp_d0_pad_value;
wire    [5:0] reg2dp_d0_pixel_format;
wire          reg2dp_d0_pixel_mapping;
wire          reg2dp_d0_pixel_sign_override;
wire    [4:0] reg2dp_d0_pixel_x_offset;
wire    [2:0] reg2dp_d0_pixel_y_offset;
wire    [1:0] reg2dp_d0_proc_precision;
wire    [2:0] reg2dp_d0_rsv_height;
wire    [9:0] reg2dp_d0_rsv_per_line;
wire    [9:0] reg2dp_d0_rsv_per_uv_line;
wire    [4:0] reg2dp_d0_rsv_y_index;
wire          reg2dp_d0_skip_data_rls;
wire          reg2dp_d0_skip_weight_rls;
wire          reg2dp_d0_surf_packed;
wire   [31:0] reg2dp_d0_surf_stride;
wire   [31:0] reg2dp_d0_uv_line_stride;
wire   [31:0] reg2dp_d0_weight_addr_high;
wire   [31:0] reg2dp_d0_weight_addr_low;
wire    [4:0] reg2dp_d0_weight_bank;
wire   [31:0] reg2dp_d0_weight_bytes;
wire          reg2dp_d0_weight_format;
wire   [12:0] reg2dp_d0_weight_kernel;
wire          reg2dp_d0_weight_ram_type;
wire          reg2dp_d0_weight_reuse;
wire   [31:0] reg2dp_d0_wgs_addr_high;
wire   [31:0] reg2dp_d0_wgs_addr_low;
wire   [31:0] reg2dp_d0_wmb_addr_high;
wire   [31:0] reg2dp_d0_wmb_addr_low;
wire   [27:0] reg2dp_d0_wmb_bytes;
wire   [31:0] reg2dp_d1_batch_stride;
wire    [4:0] reg2dp_d1_batches;
wire   [17:0] reg2dp_d1_byte_per_kernel;
wire          reg2dp_d1_conv_mode;
wire    [2:0] reg2dp_d1_conv_x_stride;
wire    [2:0] reg2dp_d1_conv_y_stride;
wire          reg2dp_d1_cvt_en;
wire   [15:0] reg2dp_d1_cvt_offset;
wire   [15:0] reg2dp_d1_cvt_scale;
wire    [5:0] reg2dp_d1_cvt_truncate;
wire   [31:0] reg2dp_d1_cya;
wire    [4:0] reg2dp_d1_data_bank;
wire          reg2dp_d1_data_reuse;
wire   [31:0] reg2dp_d1_datain_addr_high_0;
wire   [31:0] reg2dp_d1_datain_addr_high_1;
wire   [31:0] reg2dp_d1_datain_addr_low_0;
wire   [31:0] reg2dp_d1_datain_addr_low_1;
wire   [12:0] reg2dp_d1_datain_channel;
wire          reg2dp_d1_datain_format;
wire   [12:0] reg2dp_d1_datain_height;
wire   [12:0] reg2dp_d1_datain_height_ext;
wire          reg2dp_d1_datain_ram_type;
wire   [12:0] reg2dp_d1_datain_width;
wire   [12:0] reg2dp_d1_datain_width_ext;
wire          reg2dp_d1_dma_en;
wire   [13:0] reg2dp_d1_entries;
wire   [11:0] reg2dp_d1_grains;
wire    [1:0] reg2dp_d1_in_precision;
wire          reg2dp_d1_line_packed;
wire   [31:0] reg2dp_d1_line_stride;
wire   [15:0] reg2dp_d1_mean_ax;
wire   [15:0] reg2dp_d1_mean_bv;
wire          reg2dp_d1_mean_format;
wire   [15:0] reg2dp_d1_mean_gu;
wire   [15:0] reg2dp_d1_mean_ry;
wire          reg2dp_d1_nan_to_zero;
wire          reg2dp_d1_op_en_trigger;
wire    [5:0] reg2dp_d1_pad_bottom;
wire    [4:0] reg2dp_d1_pad_left;
wire    [5:0] reg2dp_d1_pad_right;
wire    [4:0] reg2dp_d1_pad_top;
wire   [15:0] reg2dp_d1_pad_value;
wire    [5:0] reg2dp_d1_pixel_format;
wire          reg2dp_d1_pixel_mapping;
wire          reg2dp_d1_pixel_sign_override;
wire    [4:0] reg2dp_d1_pixel_x_offset;
wire    [2:0] reg2dp_d1_pixel_y_offset;
wire    [1:0] reg2dp_d1_proc_precision;
wire    [2:0] reg2dp_d1_rsv_height;
wire    [9:0] reg2dp_d1_rsv_per_line;
wire    [9:0] reg2dp_d1_rsv_per_uv_line;
wire    [4:0] reg2dp_d1_rsv_y_index;
wire          reg2dp_d1_skip_data_rls;
wire          reg2dp_d1_skip_weight_rls;
wire          reg2dp_d1_surf_packed;
wire   [31:0] reg2dp_d1_surf_stride;
wire   [31:0] reg2dp_d1_uv_line_stride;
wire   [31:0] reg2dp_d1_weight_addr_high;
wire   [31:0] reg2dp_d1_weight_addr_low;
wire    [4:0] reg2dp_d1_weight_bank;
wire   [31:0] reg2dp_d1_weight_bytes;
wire          reg2dp_d1_weight_format;
wire   [12:0] reg2dp_d1_weight_kernel;
wire          reg2dp_d1_weight_ram_type;
wire          reg2dp_d1_weight_reuse;
wire   [31:0] reg2dp_d1_wgs_addr_high;
wire   [31:0] reg2dp_d1_wgs_addr_low;
wire   [31:0] reg2dp_d1_wmb_addr_high;
wire   [31:0] reg2dp_d1_wmb_addr_low;
wire   [27:0] reg2dp_d1_wmb_bytes;
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
wire    [7:0] slcg_op_en_d0;
reg    [33:0] cdma2csb_resp_pd;
reg           cdma2csb_resp_valid;
reg           dp2reg_consumer;
reg           dp2reg_d0_clr;
reg    [31:0] dp2reg_d0_dat_rd_latency;
reg    [31:0] dp2reg_d0_dat_rd_latency_w;
reg    [31:0] dp2reg_d0_dat_rd_stall;
reg    [31:0] dp2reg_d0_dat_rd_stall_w;
reg    [31:0] dp2reg_d0_inf_data_num;
reg    [31:0] dp2reg_d0_inf_data_num_w;
reg    [31:0] dp2reg_d0_inf_weight_num;
reg    [31:0] dp2reg_d0_inf_weight_num_w;
reg    [31:0] dp2reg_d0_nan_data_num;
reg    [31:0] dp2reg_d0_nan_data_num_w;
reg    [31:0] dp2reg_d0_nan_weight_num;
reg    [31:0] dp2reg_d0_nan_weight_num_w;
reg           dp2reg_d0_reg;
reg           dp2reg_d0_set;
reg    [31:0] dp2reg_d0_wt_rd_latency;
reg    [31:0] dp2reg_d0_wt_rd_latency_w;
reg    [31:0] dp2reg_d0_wt_rd_stall;
reg    [31:0] dp2reg_d0_wt_rd_stall_w;
reg           dp2reg_d1_clr;
reg    [31:0] dp2reg_d1_dat_rd_latency;
reg    [31:0] dp2reg_d1_dat_rd_latency_w;
reg    [31:0] dp2reg_d1_dat_rd_stall;
reg    [31:0] dp2reg_d1_dat_rd_stall_w;
reg    [31:0] dp2reg_d1_inf_data_num;
reg    [31:0] dp2reg_d1_inf_data_num_w;
reg    [31:0] dp2reg_d1_inf_weight_num;
reg    [31:0] dp2reg_d1_inf_weight_num_w;
reg    [31:0] dp2reg_d1_nan_data_num;
reg    [31:0] dp2reg_d1_nan_data_num_w;
reg    [31:0] dp2reg_d1_nan_weight_num;
reg    [31:0] dp2reg_d1_nan_weight_num_w;
reg           dp2reg_d1_reg;
reg           dp2reg_d1_set;
reg    [31:0] dp2reg_d1_wt_rd_latency;
reg    [31:0] dp2reg_d1_wt_rd_latency_w;
reg    [31:0] dp2reg_d1_wt_rd_stall;
reg    [31:0] dp2reg_d1_wt_rd_stall_w;
reg           dp2reg_flush_done;
reg     [1:0] dp2reg_status_0;
reg     [1:0] dp2reg_status_1;
reg    [31:0] reg2dp_batch_stride;
reg     [4:0] reg2dp_batches;
reg    [17:0] reg2dp_byte_per_kernel;
reg           reg2dp_conv_mode;
reg     [2:0] reg2dp_conv_x_stride;
reg     [2:0] reg2dp_conv_y_stride;
reg           reg2dp_cvt_en;
reg    [15:0] reg2dp_cvt_offset;
reg    [15:0] reg2dp_cvt_scale;
reg     [5:0] reg2dp_cvt_truncate;
reg    [31:0] reg2dp_cya;
reg           reg2dp_d0_op_en;
reg           reg2dp_d0_op_en_w;
reg           reg2dp_d1_op_en;
reg           reg2dp_d1_op_en_w;
reg     [4:0] reg2dp_data_bank;
reg           reg2dp_data_reuse;
reg    [31:0] reg2dp_datain_addr_high_0;
reg    [31:0] reg2dp_datain_addr_high_1;
reg    [31:0] reg2dp_datain_addr_low_0;
reg    [31:0] reg2dp_datain_addr_low_1;
reg    [12:0] reg2dp_datain_channel;
reg           reg2dp_datain_format;
reg    [12:0] reg2dp_datain_height;
reg    [12:0] reg2dp_datain_height_ext;
reg           reg2dp_datain_ram_type;
reg    [12:0] reg2dp_datain_width;
reg    [12:0] reg2dp_datain_width_ext;
reg           reg2dp_dma_en;
reg    [13:0] reg2dp_entries;
reg    [11:0] reg2dp_grains;
reg     [1:0] reg2dp_in_precision;
reg           reg2dp_line_packed;
reg    [31:0] reg2dp_line_stride;
reg    [15:0] reg2dp_mean_ax;
reg    [15:0] reg2dp_mean_bv;
reg           reg2dp_mean_format;
reg    [15:0] reg2dp_mean_gu;
reg    [15:0] reg2dp_mean_ry;
reg           reg2dp_nan_to_zero;
reg           reg2dp_op_en_ori;
reg     [2:0] reg2dp_op_en_reg;
reg     [5:0] reg2dp_pad_bottom;
reg     [4:0] reg2dp_pad_left;
reg     [5:0] reg2dp_pad_right;
reg     [4:0] reg2dp_pad_top;
reg    [15:0] reg2dp_pad_value;
reg     [5:0] reg2dp_pixel_format;
reg           reg2dp_pixel_mapping;
reg           reg2dp_pixel_sign_override;
reg     [4:0] reg2dp_pixel_x_offset;
reg     [2:0] reg2dp_pixel_y_offset;
reg     [1:0] reg2dp_proc_precision;
reg     [2:0] reg2dp_rsv_height;
reg     [9:0] reg2dp_rsv_per_line;
reg     [9:0] reg2dp_rsv_per_uv_line;
reg     [4:0] reg2dp_rsv_y_index;
reg           reg2dp_skip_data_rls;
reg           reg2dp_skip_weight_rls;
reg           reg2dp_surf_packed;
reg    [31:0] reg2dp_surf_stride;
reg    [31:0] reg2dp_uv_line_stride;
reg    [31:0] reg2dp_weight_addr_high;
reg    [31:0] reg2dp_weight_addr_low;
reg     [4:0] reg2dp_weight_bank;
reg    [31:0] reg2dp_weight_bytes;
reg           reg2dp_weight_format;
reg    [12:0] reg2dp_weight_kernel;
reg           reg2dp_weight_ram_type;
reg           reg2dp_weight_reuse;
reg    [31:0] reg2dp_wgs_addr_high;
reg    [31:0] reg2dp_wgs_addr_low;
reg    [31:0] reg2dp_wmb_addr_high;
reg    [31:0] reg2dp_wmb_addr_low;
reg    [27:0] reg2dp_wmb_bytes;
reg    [62:0] req_pd;
reg           req_pvld;
reg     [7:0] slcg_op_en_d1;
reg     [7:0] slcg_op_en_d2;
reg     [7:0] slcg_op_en_d3;


//Instance single register group
NV_NVDLA_CDMA_single_reg u_single_reg (
   .reg_rd_data         (s_reg_rd_data[31:0])                //|> w
  ,.reg_offset          (s_reg_offset[11:0])                 //|< w
  ,.reg_wr_data         (s_reg_wr_data[31:0])                //|< w
  ,.reg_wr_en           (s_reg_wr_en)                        //|< w
  ,.nvdla_core_clk      (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                    //|< i
  ,.arb_weight          (reg2dp_arb_weight[3:0])             //|> o
  ,.arb_wmb             (reg2dp_arb_wmb[3:0])                //|> o
  ,.producer            (reg2dp_producer)                    //|> w
  ,.flush_done          (dp2reg_flush_done)                  //|< r
  ,.consumer            (dp2reg_consumer)                    //|< o
  ,.status_0            (dp2reg_status_0[1:0])               //|< r
  ,.status_1            (dp2reg_status_1[1:0])               //|< r
  );

//Instance two duplicated register groups

NV_NVDLA_CDMA_dual_reg u_dual_reg_d0 (
   .reg_rd_data         (d0_reg_rd_data[31:0])               //|> w
  ,.reg_offset          (d0_reg_offset[11:0])                //|< w
  ,.reg_wr_data         (d0_reg_wr_data[31:0])               //|< w
  ,.reg_wr_en           (d0_reg_wr_en)                       //|< w
  ,.nvdla_core_clk      (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                    //|< i
  ,.data_bank           (reg2dp_d0_data_bank[4:0])           //|> w
  ,.weight_bank         (reg2dp_d0_weight_bank[4:0])         //|> w
  ,.batches             (reg2dp_d0_batches[4:0])             //|> w
  ,.batch_stride        (reg2dp_d0_batch_stride[31:0])       //|> w
  ,.conv_x_stride       (reg2dp_d0_conv_x_stride[2:0])       //|> w
  ,.conv_y_stride       (reg2dp_d0_conv_y_stride[2:0])       //|> w
  ,.cvt_en              (reg2dp_d0_cvt_en)                   //|> w
  ,.cvt_truncate        (reg2dp_d0_cvt_truncate[5:0])        //|> w
  ,.cvt_offset          (reg2dp_d0_cvt_offset[15:0])         //|> w
  ,.cvt_scale           (reg2dp_d0_cvt_scale[15:0])          //|> w
  ,.cya                 (reg2dp_d0_cya[31:0])                //|> w
  ,.datain_addr_high_0  (reg2dp_d0_datain_addr_high_0[31:0]) //|> w
  ,.datain_addr_high_1  (reg2dp_d0_datain_addr_high_1[31:0]) //|> w
  ,.datain_addr_low_0   (reg2dp_d0_datain_addr_low_0[31:0])  //|> w
  ,.datain_addr_low_1   (reg2dp_d0_datain_addr_low_1[31:0])  //|> w
  ,.line_packed         (reg2dp_d0_line_packed)              //|> w
  ,.surf_packed         (reg2dp_d0_surf_packed)              //|> w
  ,.datain_ram_type     (reg2dp_d0_datain_ram_type)          //|> w
  ,.datain_format       (reg2dp_d0_datain_format)            //|> w
  ,.pixel_format        (reg2dp_d0_pixel_format[5:0])        //|> w
  ,.pixel_mapping       (reg2dp_d0_pixel_mapping)            //|> w
  ,.pixel_sign_override (reg2dp_d0_pixel_sign_override)      //|> w
  ,.datain_height       (reg2dp_d0_datain_height[12:0])      //|> w
  ,.datain_width        (reg2dp_d0_datain_width[12:0])       //|> w
  ,.datain_channel      (reg2dp_d0_datain_channel[12:0])     //|> w
  ,.datain_height_ext   (reg2dp_d0_datain_height_ext[12:0])  //|> w
  ,.datain_width_ext    (reg2dp_d0_datain_width_ext[12:0])   //|> w
  ,.entries             (reg2dp_d0_entries[13:0])            //|> w
  ,.grains              (reg2dp_d0_grains[11:0])             //|> w
  ,.line_stride         (reg2dp_d0_line_stride[31:0])        //|> w
  ,.uv_line_stride      (reg2dp_d0_uv_line_stride[31:0])     //|> w
  ,.mean_format         (reg2dp_d0_mean_format)              //|> w
  ,.mean_gu             (reg2dp_d0_mean_gu[15:0])            //|> w
  ,.mean_ry             (reg2dp_d0_mean_ry[15:0])            //|> w
  ,.mean_ax             (reg2dp_d0_mean_ax[15:0])            //|> w
  ,.mean_bv             (reg2dp_d0_mean_bv[15:0])            //|> w
  ,.conv_mode           (reg2dp_d0_conv_mode)                //|> w
  ,.data_reuse          (reg2dp_d0_data_reuse)               //|> w
  ,.in_precision        (reg2dp_d0_in_precision[1:0])        //|> w
  ,.proc_precision      (reg2dp_d0_proc_precision[1:0])      //|> w
  ,.skip_data_rls       (reg2dp_d0_skip_data_rls)            //|> w
  ,.skip_weight_rls     (reg2dp_d0_skip_weight_rls)          //|> w
  ,.weight_reuse        (reg2dp_d0_weight_reuse)             //|> w
  ,.nan_to_zero         (reg2dp_d0_nan_to_zero)              //|> w
  ,.op_en_trigger       (reg2dp_d0_op_en_trigger)            //|> w
  ,.dma_en              (reg2dp_d0_dma_en)                   //|> w
  ,.pixel_x_offset      (reg2dp_d0_pixel_x_offset[4:0])      //|> w
  ,.pixel_y_offset      (reg2dp_d0_pixel_y_offset[2:0])      //|> w
  ,.rsv_per_line        (reg2dp_d0_rsv_per_line[9:0])        //|> w
  ,.rsv_per_uv_line     (reg2dp_d0_rsv_per_uv_line[9:0])     //|> w
  ,.rsv_height          (reg2dp_d0_rsv_height[2:0])          //|> w
  ,.rsv_y_index         (reg2dp_d0_rsv_y_index[4:0])         //|> w
  ,.surf_stride         (reg2dp_d0_surf_stride[31:0])        //|> w
  ,.weight_addr_high    (reg2dp_d0_weight_addr_high[31:0])   //|> w
  ,.weight_addr_low     (reg2dp_d0_weight_addr_low[31:0])    //|> w
  ,.weight_bytes        (reg2dp_d0_weight_bytes[31:0])       //|> w
  ,.weight_format       (reg2dp_d0_weight_format)            //|> w
  ,.weight_ram_type     (reg2dp_d0_weight_ram_type)          //|> w
  ,.byte_per_kernel     (reg2dp_d0_byte_per_kernel[17:0])    //|> w
  ,.weight_kernel       (reg2dp_d0_weight_kernel[12:0])      //|> w
  ,.wgs_addr_high       (reg2dp_d0_wgs_addr_high[31:0])      //|> w
  ,.wgs_addr_low        (reg2dp_d0_wgs_addr_low[31:0])       //|> w
  ,.wmb_addr_high       (reg2dp_d0_wmb_addr_high[31:0])      //|> w
  ,.wmb_addr_low        (reg2dp_d0_wmb_addr_low[31:0])       //|> w
  ,.wmb_bytes           (reg2dp_d0_wmb_bytes[27:0])          //|> w
  ,.pad_bottom          (reg2dp_d0_pad_bottom[5:0])          //|> w
  ,.pad_left            (reg2dp_d0_pad_left[4:0])            //|> w
  ,.pad_right           (reg2dp_d0_pad_right[5:0])           //|> w
  ,.pad_top             (reg2dp_d0_pad_top[4:0])             //|> w
  ,.pad_value           (reg2dp_d0_pad_value[15:0])          //|> w
  ,.inf_data_num        (dp2reg_d0_inf_data_num[31:0])       //|< r
  ,.inf_weight_num      (dp2reg_d0_inf_weight_num[31:0])     //|< r
  ,.nan_data_num        (dp2reg_d0_nan_data_num[31:0])       //|< r
  ,.nan_weight_num      (dp2reg_d0_nan_weight_num[31:0])     //|< r
  ,.op_en               (reg2dp_d0_op_en)                    //|< r
  ,.dat_rd_latency      (dp2reg_d0_dat_rd_latency[31:0])     //|< r
  ,.dat_rd_stall        (dp2reg_d0_dat_rd_stall[31:0])       //|< r
  ,.wt_rd_latency       (dp2reg_d0_wt_rd_latency[31:0])      //|< r
  ,.wt_rd_stall         (dp2reg_d0_wt_rd_stall[31:0])        //|< r
  );
        
NV_NVDLA_CDMA_dual_reg u_dual_reg_d1 (
   .reg_rd_data         (d1_reg_rd_data[31:0])               //|> w
  ,.reg_offset          (d1_reg_offset[11:0])                //|< w
  ,.reg_wr_data         (d1_reg_wr_data[31:0])               //|< w
  ,.reg_wr_en           (d1_reg_wr_en)                       //|< w
  ,.nvdla_core_clk      (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                    //|< i
  ,.data_bank           (reg2dp_d1_data_bank[4:0])           //|> w
  ,.weight_bank         (reg2dp_d1_weight_bank[4:0])         //|> w
  ,.batches             (reg2dp_d1_batches[4:0])             //|> w
  ,.batch_stride        (reg2dp_d1_batch_stride[31:0])       //|> w
  ,.conv_x_stride       (reg2dp_d1_conv_x_stride[2:0])       //|> w
  ,.conv_y_stride       (reg2dp_d1_conv_y_stride[2:0])       //|> w
  ,.cvt_en              (reg2dp_d1_cvt_en)                   //|> w
  ,.cvt_truncate        (reg2dp_d1_cvt_truncate[5:0])        //|> w
  ,.cvt_offset          (reg2dp_d1_cvt_offset[15:0])         //|> w
  ,.cvt_scale           (reg2dp_d1_cvt_scale[15:0])          //|> w
  ,.cya                 (reg2dp_d1_cya[31:0])                //|> w
  ,.datain_addr_high_0  (reg2dp_d1_datain_addr_high_0[31:0]) //|> w
  ,.datain_addr_high_1  (reg2dp_d1_datain_addr_high_1[31:0]) //|> w
  ,.datain_addr_low_0   (reg2dp_d1_datain_addr_low_0[31:0])  //|> w
  ,.datain_addr_low_1   (reg2dp_d1_datain_addr_low_1[31:0])  //|> w
  ,.line_packed         (reg2dp_d1_line_packed)              //|> w
  ,.surf_packed         (reg2dp_d1_surf_packed)              //|> w
  ,.datain_ram_type     (reg2dp_d1_datain_ram_type)          //|> w
  ,.datain_format       (reg2dp_d1_datain_format)            //|> w
  ,.pixel_format        (reg2dp_d1_pixel_format[5:0])        //|> w
  ,.pixel_mapping       (reg2dp_d1_pixel_mapping)            //|> w
  ,.pixel_sign_override (reg2dp_d1_pixel_sign_override)      //|> w
  ,.datain_height       (reg2dp_d1_datain_height[12:0])      //|> w
  ,.datain_width        (reg2dp_d1_datain_width[12:0])       //|> w
  ,.datain_channel      (reg2dp_d1_datain_channel[12:0])     //|> w
  ,.datain_height_ext   (reg2dp_d1_datain_height_ext[12:0])  //|> w
  ,.datain_width_ext    (reg2dp_d1_datain_width_ext[12:0])   //|> w
  ,.entries             (reg2dp_d1_entries[13:0])            //|> w
  ,.grains              (reg2dp_d1_grains[11:0])             //|> w
  ,.line_stride         (reg2dp_d1_line_stride[31:0])        //|> w
  ,.uv_line_stride      (reg2dp_d1_uv_line_stride[31:0])     //|> w
  ,.mean_format         (reg2dp_d1_mean_format)              //|> w
  ,.mean_gu             (reg2dp_d1_mean_gu[15:0])            //|> w
  ,.mean_ry             (reg2dp_d1_mean_ry[15:0])            //|> w
  ,.mean_ax             (reg2dp_d1_mean_ax[15:0])            //|> w
  ,.mean_bv             (reg2dp_d1_mean_bv[15:0])            //|> w
  ,.conv_mode           (reg2dp_d1_conv_mode)                //|> w
  ,.data_reuse          (reg2dp_d1_data_reuse)               //|> w
  ,.in_precision        (reg2dp_d1_in_precision[1:0])        //|> w
  ,.proc_precision      (reg2dp_d1_proc_precision[1:0])      //|> w
  ,.skip_data_rls       (reg2dp_d1_skip_data_rls)            //|> w
  ,.skip_weight_rls     (reg2dp_d1_skip_weight_rls)          //|> w
  ,.weight_reuse        (reg2dp_d1_weight_reuse)             //|> w
  ,.nan_to_zero         (reg2dp_d1_nan_to_zero)              //|> w
  ,.op_en_trigger       (reg2dp_d1_op_en_trigger)            //|> w
  ,.dma_en              (reg2dp_d1_dma_en)                   //|> w
  ,.pixel_x_offset      (reg2dp_d1_pixel_x_offset[4:0])      //|> w
  ,.pixel_y_offset      (reg2dp_d1_pixel_y_offset[2:0])      //|> w
  ,.rsv_per_line        (reg2dp_d1_rsv_per_line[9:0])        //|> w
  ,.rsv_per_uv_line     (reg2dp_d1_rsv_per_uv_line[9:0])     //|> w
  ,.rsv_height          (reg2dp_d1_rsv_height[2:0])          //|> w
  ,.rsv_y_index         (reg2dp_d1_rsv_y_index[4:0])         //|> w
  ,.surf_stride         (reg2dp_d1_surf_stride[31:0])        //|> w
  ,.weight_addr_high    (reg2dp_d1_weight_addr_high[31:0])   //|> w
  ,.weight_addr_low     (reg2dp_d1_weight_addr_low[31:0])    //|> w
  ,.weight_bytes        (reg2dp_d1_weight_bytes[31:0])       //|> w
  ,.weight_format       (reg2dp_d1_weight_format)            //|> w
  ,.weight_ram_type     (reg2dp_d1_weight_ram_type)          //|> w
  ,.byte_per_kernel     (reg2dp_d1_byte_per_kernel[17:0])    //|> w
  ,.weight_kernel       (reg2dp_d1_weight_kernel[12:0])      //|> w
  ,.wgs_addr_high       (reg2dp_d1_wgs_addr_high[31:0])      //|> w
  ,.wgs_addr_low        (reg2dp_d1_wgs_addr_low[31:0])       //|> w
  ,.wmb_addr_high       (reg2dp_d1_wmb_addr_high[31:0])      //|> w
  ,.wmb_addr_low        (reg2dp_d1_wmb_addr_low[31:0])       //|> w
  ,.wmb_bytes           (reg2dp_d1_wmb_bytes[27:0])          //|> w
  ,.pad_bottom          (reg2dp_d1_pad_bottom[5:0])          //|> w
  ,.pad_left            (reg2dp_d1_pad_left[4:0])            //|> w
  ,.pad_right           (reg2dp_d1_pad_right[5:0])           //|> w
  ,.pad_top             (reg2dp_d1_pad_top[4:0])             //|> w
  ,.pad_value           (reg2dp_d1_pad_value[15:0])          //|> w
  ,.inf_data_num        (dp2reg_d1_inf_data_num[31:0])       //|< r
  ,.inf_weight_num      (dp2reg_d1_inf_weight_num[31:0])     //|< r
  ,.nan_data_num        (dp2reg_d1_nan_data_num[31:0])       //|< r
  ,.nan_weight_num      (dp2reg_d1_nan_weight_num[31:0])     //|< r
  ,.op_en               (reg2dp_d1_op_en)                    //|< r
  ,.dat_rd_latency      (dp2reg_d1_dat_rd_latency[31:0])     //|< r
  ,.dat_rd_stall        (dp2reg_d1_dat_rd_stall[31:0])       //|< r
  ,.wt_rd_latency       (dp2reg_d1_wt_rd_latency[31:0])      //|< r
  ,.wt_rd_stall         (dp2reg_d1_wt_rd_stall[31:0])        //|< r
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

assign slcg_op_en_d0 = {8{reg2dp_op_en_ori}};

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_op_en_d1 <= {8{1'b0}};
  end else begin
  slcg_op_en_d1 <= slcg_op_en_d0;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_op_en_d2 <= {8{1'b0}};
  end else begin
  slcg_op_en_d2 <= slcg_op_en_d1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_op_en_d3 <= {8{1'b0}};
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
assign select_s  = (reg_offset[11:0] < (32'h5010  & 32'hfff)) ? 1'b1: 1'b0;
assign select_d0 = (reg_offset[11:0] >= (32'h5010  & 32'hfff)) & (reg2dp_producer == 1'h0 );
assign select_d1 = (reg_offset[11:0] >= (32'h5010  & 32'hfff)) & (reg2dp_producer == 1'h1 );

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
  req_pvld <= csb2cdma_req_pvld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_pd <= {63{1'b0}};
  end else begin
  if ((csb2cdma_req_pvld) == 1'b1) begin
    req_pd <= csb2cdma_req_pd;
  // VCS coverage off
  end else if ((csb2cdma_req_pvld) == 1'b0) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(csb2cdma_req_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign csb2cdma_req_prdy = 1'b1;


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
    cdma2csb_resp_pd <= {34{1'b0}};
  end else begin
    if(reg_rd_en)
    begin
        cdma2csb_resp_pd <= csb_rresp_pd_w;
    end
    else if(reg_wr_en & req_nposted)
    begin
        cdma2csb_resp_pd <= csb_wresp_pd_w;
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdma2csb_resp_valid <= 1'b0;
  end else begin
    cdma2csb_resp_valid <= (reg_wr_en & req_nposted) | reg_rd_en;
  end
end

////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE OUTPUT REGISTER FILED FROM DUPLICATED REGISTER GROUPS     //
//                                                                    //
////////////////////////////////////////////////////////////////////////
always @(
  dp2reg_consumer
  or reg2dp_d1_data_bank
  or reg2dp_d0_data_bank
  ) begin
    reg2dp_data_bank = dp2reg_consumer ? reg2dp_d1_data_bank : reg2dp_d0_data_bank;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_bank
  or reg2dp_d0_weight_bank
  ) begin
    reg2dp_weight_bank = dp2reg_consumer ? reg2dp_d1_weight_bank : reg2dp_d0_weight_bank;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_batches
  or reg2dp_d0_batches
  ) begin
    reg2dp_batches = dp2reg_consumer ? reg2dp_d1_batches : reg2dp_d0_batches;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_batch_stride
  or reg2dp_d0_batch_stride
  ) begin
    reg2dp_batch_stride = dp2reg_consumer ? reg2dp_d1_batch_stride : reg2dp_d0_batch_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_conv_x_stride
  or reg2dp_d0_conv_x_stride
  ) begin
    reg2dp_conv_x_stride = dp2reg_consumer ? reg2dp_d1_conv_x_stride : reg2dp_d0_conv_x_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_conv_y_stride
  or reg2dp_d0_conv_y_stride
  ) begin
    reg2dp_conv_y_stride = dp2reg_consumer ? reg2dp_d1_conv_y_stride : reg2dp_d0_conv_y_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_cvt_en
  or reg2dp_d0_cvt_en
  ) begin
    reg2dp_cvt_en = dp2reg_consumer ? reg2dp_d1_cvt_en : reg2dp_d0_cvt_en;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_cvt_truncate
  or reg2dp_d0_cvt_truncate
  ) begin
    reg2dp_cvt_truncate = dp2reg_consumer ? reg2dp_d1_cvt_truncate : reg2dp_d0_cvt_truncate;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_cvt_offset
  or reg2dp_d0_cvt_offset
  ) begin
    reg2dp_cvt_offset = dp2reg_consumer ? reg2dp_d1_cvt_offset : reg2dp_d0_cvt_offset;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_cvt_scale
  or reg2dp_d0_cvt_scale
  ) begin
    reg2dp_cvt_scale = dp2reg_consumer ? reg2dp_d1_cvt_scale : reg2dp_d0_cvt_scale;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_cya
  or reg2dp_d0_cya
  ) begin
    reg2dp_cya = dp2reg_consumer ? reg2dp_d1_cya : reg2dp_d0_cya;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_addr_high_0
  or reg2dp_d0_datain_addr_high_0
  ) begin
    reg2dp_datain_addr_high_0 = dp2reg_consumer ? reg2dp_d1_datain_addr_high_0 : reg2dp_d0_datain_addr_high_0;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_addr_high_1
  or reg2dp_d0_datain_addr_high_1
  ) begin
    reg2dp_datain_addr_high_1 = dp2reg_consumer ? reg2dp_d1_datain_addr_high_1 : reg2dp_d0_datain_addr_high_1;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_addr_low_0
  or reg2dp_d0_datain_addr_low_0
  ) begin
    reg2dp_datain_addr_low_0 = dp2reg_consumer ? reg2dp_d1_datain_addr_low_0 : reg2dp_d0_datain_addr_low_0;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_addr_low_1
  or reg2dp_d0_datain_addr_low_1
  ) begin
    reg2dp_datain_addr_low_1 = dp2reg_consumer ? reg2dp_d1_datain_addr_low_1 : reg2dp_d0_datain_addr_low_1;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_line_packed
  or reg2dp_d0_line_packed
  ) begin
    reg2dp_line_packed = dp2reg_consumer ? reg2dp_d1_line_packed : reg2dp_d0_line_packed;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_surf_packed
  or reg2dp_d0_surf_packed
  ) begin
    reg2dp_surf_packed = dp2reg_consumer ? reg2dp_d1_surf_packed : reg2dp_d0_surf_packed;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_ram_type
  or reg2dp_d0_datain_ram_type
  ) begin
    reg2dp_datain_ram_type = dp2reg_consumer ? reg2dp_d1_datain_ram_type : reg2dp_d0_datain_ram_type;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_format
  or reg2dp_d0_datain_format
  ) begin
    reg2dp_datain_format = dp2reg_consumer ? reg2dp_d1_datain_format : reg2dp_d0_datain_format;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pixel_format
  or reg2dp_d0_pixel_format
  ) begin
    reg2dp_pixel_format = dp2reg_consumer ? reg2dp_d1_pixel_format : reg2dp_d0_pixel_format;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pixel_mapping
  or reg2dp_d0_pixel_mapping
  ) begin
    reg2dp_pixel_mapping = dp2reg_consumer ? reg2dp_d1_pixel_mapping : reg2dp_d0_pixel_mapping;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pixel_sign_override
  or reg2dp_d0_pixel_sign_override
  ) begin
    reg2dp_pixel_sign_override = dp2reg_consumer ? reg2dp_d1_pixel_sign_override : reg2dp_d0_pixel_sign_override;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_height
  or reg2dp_d0_datain_height
  ) begin
    reg2dp_datain_height = dp2reg_consumer ? reg2dp_d1_datain_height : reg2dp_d0_datain_height;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_width
  or reg2dp_d0_datain_width
  ) begin
    reg2dp_datain_width = dp2reg_consumer ? reg2dp_d1_datain_width : reg2dp_d0_datain_width;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_channel
  or reg2dp_d0_datain_channel
  ) begin
    reg2dp_datain_channel = dp2reg_consumer ? reg2dp_d1_datain_channel : reg2dp_d0_datain_channel;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_height_ext
  or reg2dp_d0_datain_height_ext
  ) begin
    reg2dp_datain_height_ext = dp2reg_consumer ? reg2dp_d1_datain_height_ext : reg2dp_d0_datain_height_ext;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_width_ext
  or reg2dp_d0_datain_width_ext
  ) begin
    reg2dp_datain_width_ext = dp2reg_consumer ? reg2dp_d1_datain_width_ext : reg2dp_d0_datain_width_ext;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_entries
  or reg2dp_d0_entries
  ) begin
    reg2dp_entries = dp2reg_consumer ? reg2dp_d1_entries : reg2dp_d0_entries;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_grains
  or reg2dp_d0_grains
  ) begin
    reg2dp_grains = dp2reg_consumer ? reg2dp_d1_grains : reg2dp_d0_grains;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_line_stride
  or reg2dp_d0_line_stride
  ) begin
    reg2dp_line_stride = dp2reg_consumer ? reg2dp_d1_line_stride : reg2dp_d0_line_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_uv_line_stride
  or reg2dp_d0_uv_line_stride
  ) begin
    reg2dp_uv_line_stride = dp2reg_consumer ? reg2dp_d1_uv_line_stride : reg2dp_d0_uv_line_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_mean_format
  or reg2dp_d0_mean_format
  ) begin
    reg2dp_mean_format = dp2reg_consumer ? reg2dp_d1_mean_format : reg2dp_d0_mean_format;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_mean_gu
  or reg2dp_d0_mean_gu
  ) begin
    reg2dp_mean_gu = dp2reg_consumer ? reg2dp_d1_mean_gu : reg2dp_d0_mean_gu;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_mean_ry
  or reg2dp_d0_mean_ry
  ) begin
    reg2dp_mean_ry = dp2reg_consumer ? reg2dp_d1_mean_ry : reg2dp_d0_mean_ry;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_mean_ax
  or reg2dp_d0_mean_ax
  ) begin
    reg2dp_mean_ax = dp2reg_consumer ? reg2dp_d1_mean_ax : reg2dp_d0_mean_ax;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_mean_bv
  or reg2dp_d0_mean_bv
  ) begin
    reg2dp_mean_bv = dp2reg_consumer ? reg2dp_d1_mean_bv : reg2dp_d0_mean_bv;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_conv_mode
  or reg2dp_d0_conv_mode
  ) begin
    reg2dp_conv_mode = dp2reg_consumer ? reg2dp_d1_conv_mode : reg2dp_d0_conv_mode;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_data_reuse
  or reg2dp_d0_data_reuse
  ) begin
    reg2dp_data_reuse = dp2reg_consumer ? reg2dp_d1_data_reuse : reg2dp_d0_data_reuse;
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
  or reg2dp_d1_proc_precision
  or reg2dp_d0_proc_precision
  ) begin
    reg2dp_proc_precision = dp2reg_consumer ? reg2dp_d1_proc_precision : reg2dp_d0_proc_precision;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_skip_data_rls
  or reg2dp_d0_skip_data_rls
  ) begin
    reg2dp_skip_data_rls = dp2reg_consumer ? reg2dp_d1_skip_data_rls : reg2dp_d0_skip_data_rls;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_skip_weight_rls
  or reg2dp_d0_skip_weight_rls
  ) begin
    reg2dp_skip_weight_rls = dp2reg_consumer ? reg2dp_d1_skip_weight_rls : reg2dp_d0_skip_weight_rls;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_reuse
  or reg2dp_d0_weight_reuse
  ) begin
    reg2dp_weight_reuse = dp2reg_consumer ? reg2dp_d1_weight_reuse : reg2dp_d0_weight_reuse;
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
  or reg2dp_d1_dma_en
  or reg2dp_d0_dma_en
  ) begin
    reg2dp_dma_en = dp2reg_consumer ? reg2dp_d1_dma_en : reg2dp_d0_dma_en;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pixel_x_offset
  or reg2dp_d0_pixel_x_offset
  ) begin
    reg2dp_pixel_x_offset = dp2reg_consumer ? reg2dp_d1_pixel_x_offset : reg2dp_d0_pixel_x_offset;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pixel_y_offset
  or reg2dp_d0_pixel_y_offset
  ) begin
    reg2dp_pixel_y_offset = dp2reg_consumer ? reg2dp_d1_pixel_y_offset : reg2dp_d0_pixel_y_offset;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_rsv_per_line
  or reg2dp_d0_rsv_per_line
  ) begin
    reg2dp_rsv_per_line = dp2reg_consumer ? reg2dp_d1_rsv_per_line : reg2dp_d0_rsv_per_line;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_rsv_per_uv_line
  or reg2dp_d0_rsv_per_uv_line
  ) begin
    reg2dp_rsv_per_uv_line = dp2reg_consumer ? reg2dp_d1_rsv_per_uv_line : reg2dp_d0_rsv_per_uv_line;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_rsv_height
  or reg2dp_d0_rsv_height
  ) begin
    reg2dp_rsv_height = dp2reg_consumer ? reg2dp_d1_rsv_height : reg2dp_d0_rsv_height;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_rsv_y_index
  or reg2dp_d0_rsv_y_index
  ) begin
    reg2dp_rsv_y_index = dp2reg_consumer ? reg2dp_d1_rsv_y_index : reg2dp_d0_rsv_y_index;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_surf_stride
  or reg2dp_d0_surf_stride
  ) begin
    reg2dp_surf_stride = dp2reg_consumer ? reg2dp_d1_surf_stride : reg2dp_d0_surf_stride;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_addr_high
  or reg2dp_d0_weight_addr_high
  ) begin
    reg2dp_weight_addr_high = dp2reg_consumer ? reg2dp_d1_weight_addr_high : reg2dp_d0_weight_addr_high;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_addr_low
  or reg2dp_d0_weight_addr_low
  ) begin
    reg2dp_weight_addr_low = dp2reg_consumer ? reg2dp_d1_weight_addr_low : reg2dp_d0_weight_addr_low;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_bytes
  or reg2dp_d0_weight_bytes
  ) begin
    reg2dp_weight_bytes = dp2reg_consumer ? reg2dp_d1_weight_bytes : reg2dp_d0_weight_bytes;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_format
  or reg2dp_d0_weight_format
  ) begin
    reg2dp_weight_format = dp2reg_consumer ? reg2dp_d1_weight_format : reg2dp_d0_weight_format;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_ram_type
  or reg2dp_d0_weight_ram_type
  ) begin
    reg2dp_weight_ram_type = dp2reg_consumer ? reg2dp_d1_weight_ram_type : reg2dp_d0_weight_ram_type;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_byte_per_kernel
  or reg2dp_d0_byte_per_kernel
  ) begin
    reg2dp_byte_per_kernel = dp2reg_consumer ? reg2dp_d1_byte_per_kernel : reg2dp_d0_byte_per_kernel;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_kernel
  or reg2dp_d0_weight_kernel
  ) begin
    reg2dp_weight_kernel = dp2reg_consumer ? reg2dp_d1_weight_kernel : reg2dp_d0_weight_kernel;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_wgs_addr_high
  or reg2dp_d0_wgs_addr_high
  ) begin
    reg2dp_wgs_addr_high = dp2reg_consumer ? reg2dp_d1_wgs_addr_high : reg2dp_d0_wgs_addr_high;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_wgs_addr_low
  or reg2dp_d0_wgs_addr_low
  ) begin
    reg2dp_wgs_addr_low = dp2reg_consumer ? reg2dp_d1_wgs_addr_low : reg2dp_d0_wgs_addr_low;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_wmb_addr_high
  or reg2dp_d0_wmb_addr_high
  ) begin
    reg2dp_wmb_addr_high = dp2reg_consumer ? reg2dp_d1_wmb_addr_high : reg2dp_d0_wmb_addr_high;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_wmb_addr_low
  or reg2dp_d0_wmb_addr_low
  ) begin
    reg2dp_wmb_addr_low = dp2reg_consumer ? reg2dp_d1_wmb_addr_low : reg2dp_d0_wmb_addr_low;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_wmb_bytes
  or reg2dp_d0_wmb_bytes
  ) begin
    reg2dp_wmb_bytes = dp2reg_consumer ? reg2dp_d1_wmb_bytes : reg2dp_d0_wmb_bytes;
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
  or reg2dp_d1_pad_value
  or reg2dp_d0_pad_value
  ) begin
    reg2dp_pad_value = dp2reg_consumer ? reg2dp_d1_pad_value : reg2dp_d0_pad_value;
end

////////////////////////////////////////////////////////////////////////
//                                                                    //
// PASTE ADDIFITON LOGIC HERE FROM EXTRA FILE                         //
//                                                                    //
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//  for interrupt                                                     //
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//  for cbuf flushing logic                                           //
////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_flush_done <= 1'b0;
  end else begin
  dp2reg_flush_done <= dp2reg_wt_flush_done & dp2reg_dat_flush_done;
  end
end

////////////////////////////////////////////////////////////////////////
//  for general counting register                                     //
////////////////////////////////////////////////////////////////////////
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

////////////////////////////////////////////////////////////////////////
//  for NaN and infinity counting registers                           //
////////////////////////////////////////////////////////////////////////
//////// group 0 ////////
always @(
  dp2reg_d0_set
  or dp2reg_nan_weight_num
  or dp2reg_d0_clr
  or dp2reg_d0_nan_weight_num
  ) begin
    dp2reg_d0_nan_weight_num_w = (dp2reg_d0_set) ? dp2reg_nan_weight_num :
                                 (dp2reg_d0_clr) ? 32'b0 :
                                 dp2reg_d0_nan_weight_num;
end

always @(
  dp2reg_d0_set
  or dp2reg_inf_weight_num
  or dp2reg_d0_clr
  or dp2reg_d0_inf_weight_num
  ) begin
    dp2reg_d0_inf_weight_num_w = (dp2reg_d0_set) ? dp2reg_inf_weight_num :
                                 (dp2reg_d0_clr) ? 32'b0 :
                                 dp2reg_d0_inf_weight_num;
end

always @(
  dp2reg_d0_set
  or dp2reg_nan_data_num
  or dp2reg_d0_clr
  or dp2reg_d0_nan_data_num
  ) begin
    dp2reg_d0_nan_data_num_w = (dp2reg_d0_set) ? dp2reg_nan_data_num :
                               (dp2reg_d0_clr) ? 32'b0 :
                               dp2reg_d0_nan_data_num;
end

always @(
  dp2reg_d0_set
  or dp2reg_inf_data_num
  or dp2reg_d0_clr
  or dp2reg_d0_inf_data_num
  ) begin
    dp2reg_d0_inf_data_num_w = (dp2reg_d0_set) ? dp2reg_inf_data_num :
                               (dp2reg_d0_clr) ? 32'b0 :
                               dp2reg_d0_inf_data_num;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_nan_weight_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_nan_weight_num <= dp2reg_d0_nan_weight_num_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_nan_weight_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    dp2reg_d0_inf_weight_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_inf_weight_num <= dp2reg_d0_inf_weight_num_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_inf_weight_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    dp2reg_d0_nan_data_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_nan_data_num <= dp2reg_d0_nan_data_num_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_nan_data_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_inf_data_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_inf_data_num <= dp2reg_d0_inf_data_num_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_inf_data_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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

//////// group 1 ////////
always @(
  dp2reg_d1_set
  or dp2reg_nan_weight_num
  or dp2reg_d1_clr
  or dp2reg_d1_nan_weight_num
  ) begin
    dp2reg_d1_nan_weight_num_w = (dp2reg_d1_set) ? dp2reg_nan_weight_num :
                                 (dp2reg_d1_clr) ? 32'b0 :
                                 dp2reg_d1_nan_weight_num;
end

always @(
  dp2reg_d1_set
  or dp2reg_inf_weight_num
  or dp2reg_d1_clr
  or dp2reg_d1_inf_weight_num
  ) begin
    dp2reg_d1_inf_weight_num_w = (dp2reg_d1_set) ? dp2reg_inf_weight_num :
                                 (dp2reg_d1_clr) ? 32'b0 :
                                 dp2reg_d1_inf_weight_num;
end

always @(
  dp2reg_d1_set
  or dp2reg_nan_data_num
  or dp2reg_d1_clr
  or dp2reg_d1_nan_data_num
  ) begin
    dp2reg_d1_nan_data_num_w = (dp2reg_d1_set) ? dp2reg_nan_data_num :
                               (dp2reg_d1_clr) ? 32'b0 :
                               dp2reg_d1_nan_data_num;
end

always @(
  dp2reg_d1_set
  or dp2reg_inf_data_num
  or dp2reg_d1_clr
  or dp2reg_d1_inf_data_num
  ) begin
    dp2reg_d1_inf_data_num_w = (dp2reg_d1_set) ? dp2reg_inf_data_num :
                               (dp2reg_d1_clr) ? 32'b0 :
                               dp2reg_d1_inf_data_num;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_nan_weight_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_nan_weight_num <= dp2reg_d1_nan_weight_num_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_nan_weight_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    dp2reg_d1_inf_weight_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_inf_weight_num <= dp2reg_d1_inf_weight_num_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_inf_weight_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_nan_data_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_nan_data_num <= dp2reg_d1_nan_data_num_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_nan_data_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_inf_data_num <= {32{1'b0}};
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_inf_data_num <= dp2reg_d1_inf_data_num_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_inf_data_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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

////////////////////////////////////////////////////////////////////////
//  for perf conting registers                                        //
////////////////////////////////////////////////////////////////////////
//////// group 0 ////////
always @(
  dp2reg_d0_set
  or dp2reg_wt_rd_stall
  or dp2reg_d0_clr
  or dp2reg_d0_wt_rd_stall
  ) begin
    dp2reg_d0_wt_rd_stall_w = (dp2reg_d0_set) ? dp2reg_wt_rd_stall :
                              (dp2reg_d0_clr) ? 32'b0 :
                              dp2reg_d0_wt_rd_stall;
end

always @(
  dp2reg_d0_set
  or dp2reg_wt_rd_latency
  or dp2reg_d0_clr
  or dp2reg_d0_wt_rd_latency
  ) begin
    dp2reg_d0_wt_rd_latency_w = (dp2reg_d0_set) ? dp2reg_wt_rd_latency :
                                (dp2reg_d0_clr) ? 32'b0 :
                                dp2reg_d0_wt_rd_latency;
end

always @(
  dp2reg_d0_set
  or dp2reg_dc_rd_stall
  or dp2reg_wg_rd_stall
  or dp2reg_img_rd_stall
  or dp2reg_d0_clr
  or dp2reg_d0_dat_rd_stall
  ) begin
    dp2reg_d0_dat_rd_stall_w = (dp2reg_d0_set) ? (dp2reg_dc_rd_stall | dp2reg_wg_rd_stall | dp2reg_img_rd_stall) :
                               (dp2reg_d0_clr) ? 32'b0 :
                               dp2reg_d0_dat_rd_stall;
end

always @(
  dp2reg_d0_set
  or dp2reg_dc_rd_latency
  or dp2reg_wg_rd_latency
  or dp2reg_img_rd_latency
  or dp2reg_d0_clr
  or dp2reg_d0_dat_rd_latency
  ) begin
    dp2reg_d0_dat_rd_latency_w = (dp2reg_d0_set) ? (dp2reg_dc_rd_latency | dp2reg_wg_rd_latency | dp2reg_img_rd_latency) :
                                 (dp2reg_d0_clr) ? 32'b0 :
                                 dp2reg_d0_dat_rd_latency;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_wt_rd_stall <= {32{1'b0}};
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_wt_rd_stall <= dp2reg_d0_wt_rd_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_wt_rd_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dp2reg_d0_wt_rd_latency <= {32{1'b0}};
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_wt_rd_latency <= dp2reg_d0_wt_rd_latency_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_wt_rd_latency <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dp2reg_d0_dat_rd_stall <= {32{1'b0}};
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_dat_rd_stall <= dp2reg_d0_dat_rd_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_dat_rd_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dp2reg_d0_dat_rd_latency <= {32{1'b0}};
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_dat_rd_latency <= dp2reg_d0_dat_rd_latency_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_dat_rd_latency <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  or dp2reg_wt_rd_stall
  or dp2reg_d1_clr
  or dp2reg_d1_wt_rd_stall
  ) begin
    dp2reg_d1_wt_rd_stall_w = (dp2reg_d1_set) ? dp2reg_wt_rd_stall :
                              (dp2reg_d1_clr) ? 32'b0 :
                              dp2reg_d1_wt_rd_stall;
end

always @(
  dp2reg_d1_set
  or dp2reg_wt_rd_latency
  or dp2reg_d1_clr
  or dp2reg_d1_wt_rd_latency
  ) begin
    dp2reg_d1_wt_rd_latency_w = (dp2reg_d1_set) ? dp2reg_wt_rd_latency :
                                (dp2reg_d1_clr) ? 32'b0 :
                                dp2reg_d1_wt_rd_latency;
end

always @(
  dp2reg_d1_set
  or dp2reg_dc_rd_stall
  or dp2reg_wg_rd_stall
  or dp2reg_img_rd_stall
  or dp2reg_d1_clr
  or dp2reg_d1_dat_rd_stall
  ) begin
    dp2reg_d1_dat_rd_stall_w = (dp2reg_d1_set) ? (dp2reg_dc_rd_stall | dp2reg_wg_rd_stall | dp2reg_img_rd_stall) :
                               (dp2reg_d1_clr) ? 32'b0 :
                               dp2reg_d1_dat_rd_stall;
end

always @(
  dp2reg_d1_set
  or dp2reg_dc_rd_latency
  or dp2reg_wg_rd_latency
  or dp2reg_img_rd_latency
  or dp2reg_d1_clr
  or dp2reg_d1_dat_rd_latency
  ) begin
    dp2reg_d1_dat_rd_latency_w = (dp2reg_d1_set) ? (dp2reg_dc_rd_latency | dp2reg_wg_rd_latency | dp2reg_img_rd_latency) :
                                 (dp2reg_d1_clr) ? 32'b0 :
                                 dp2reg_d1_dat_rd_latency;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_wt_rd_stall <= {32{1'b0}};
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_wt_rd_stall <= dp2reg_d1_wt_rd_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_wt_rd_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dp2reg_d1_wt_rd_latency <= {32{1'b0}};
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_wt_rd_latency <= dp2reg_d1_wt_rd_latency_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_wt_rd_latency <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dp2reg_d1_dat_rd_stall <= {32{1'b0}};
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_dat_rd_stall <= dp2reg_d1_dat_rd_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_dat_rd_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dp2reg_d1_dat_rd_latency <= {32{1'b0}};
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_dat_rd_latency <= dp2reg_d1_dat_rd_latency_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_dat_rd_latency <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

endmodule // NV_NVDLA_CDMA_regfile

