// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_reg.v

`include "simulate_x_tick.vh"
#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_reg (
   nvdla_core_clk                  //|< i
  ,nvdla_core_rstn                 //|< i
  ,csb2sdp_req_pd                  //|< i
  ,csb2sdp_req_pvld                //|< i
  ,dp2reg_done                     //|< i
  ,dp2reg_lut_hybrid               //|< i
  ,dp2reg_lut_int_data             //|< i
  ,dp2reg_lut_le_hit               //|< i
  ,dp2reg_lut_lo_hit               //|< i
  ,dp2reg_lut_oflow                //|< i
  ,dp2reg_lut_uflow                //|< i
  ,dp2reg_out_saturation           //|< i
  ,dp2reg_status_inf_input_num     //|< i
  ,dp2reg_status_nan_input_num     //|< i
  ,dp2reg_status_nan_output_num    //|< i
  ,dp2reg_status_unequal           //|< i
  ,dp2reg_wdma_stall               //|< i
  ,csb2sdp_req_prdy                //|> o
  ,reg2dp_batch_number             //|> o
  ,reg2dp_bcore_slcg_op_en         //|> o
  ,reg2dp_bn_alu_algo              //|> o
  ,reg2dp_bn_alu_bypass            //|> o
  ,reg2dp_bn_alu_operand           //|> o
  ,reg2dp_bn_alu_shift_value       //|> o
  ,reg2dp_bn_alu_src               //|> o
  ,reg2dp_bn_bypass                //|> o
  ,reg2dp_bn_mul_bypass            //|> o
  ,reg2dp_bn_mul_operand           //|> o
  ,reg2dp_bn_mul_prelu             //|> o
  ,reg2dp_bn_mul_shift_value       //|> o
  ,reg2dp_bn_mul_src               //|> o
  ,reg2dp_bn_relu_bypass           //|> o
  ,reg2dp_bs_alu_algo              //|> o
  ,reg2dp_bs_alu_bypass            //|> o
  ,reg2dp_bs_alu_operand           //|> o
  ,reg2dp_bs_alu_shift_value       //|> o
  ,reg2dp_bs_alu_src               //|> o
  ,reg2dp_bs_bypass                //|> o
  ,reg2dp_bs_mul_bypass            //|> o
  ,reg2dp_bs_mul_operand           //|> o
  ,reg2dp_bs_mul_prelu             //|> o
  ,reg2dp_bs_mul_shift_value       //|> o
  ,reg2dp_bs_mul_src               //|> o
  ,reg2dp_bs_relu_bypass           //|> o
  ,reg2dp_channel                  //|> o
  ,reg2dp_cvt_offset               //|> o
  ,reg2dp_cvt_scale                //|> o
  ,reg2dp_cvt_shift                //|> o
  ,reg2dp_dst_base_addr_high       //|> o
  ,reg2dp_dst_base_addr_low        //|> o
  ,reg2dp_dst_batch_stride         //|> o
  ,reg2dp_dst_line_stride          //|> o
  ,reg2dp_dst_ram_type             //|> o
  ,reg2dp_dst_surface_stride       //|> o
  ,reg2dp_ecore_slcg_op_en         //|> o
  ,reg2dp_ew_alu_algo              //|> o
  ,reg2dp_ew_alu_bypass            //|> o
  ,reg2dp_ew_alu_cvt_bypass        //|> o
  ,reg2dp_ew_alu_cvt_offset        //|> o
  ,reg2dp_ew_alu_cvt_scale         //|> o
  ,reg2dp_ew_alu_cvt_truncate      //|> o
  ,reg2dp_ew_alu_operand           //|> o
  ,reg2dp_ew_alu_src               //|> o
  ,reg2dp_ew_bypass                //|> o
  ,reg2dp_ew_lut_bypass            //|> o
  ,reg2dp_ew_mul_bypass            //|> o
  ,reg2dp_ew_mul_cvt_bypass        //|> o
  ,reg2dp_ew_mul_cvt_offset        //|> o
  ,reg2dp_ew_mul_cvt_scale         //|> o
  ,reg2dp_ew_mul_cvt_truncate      //|> o
  ,reg2dp_ew_mul_operand           //|> o
  ,reg2dp_ew_mul_prelu             //|> o
  ,reg2dp_ew_mul_src               //|> o
  ,reg2dp_ew_truncate              //|> o
  ,reg2dp_flying_mode              //|> o
  ,reg2dp_height                   //|> o
  ,reg2dp_interrupt_ptr            //|> o
  ,reg2dp_lut_hybrid_priority      //|> o
  ,reg2dp_lut_int_access_type      //|> o
  ,reg2dp_lut_int_addr             //|> o
  ,reg2dp_lut_int_data             //|> o
  ,reg2dp_lut_int_data_wr          //|> o
  ,reg2dp_lut_int_table_id         //|> o
  ,reg2dp_lut_le_end               //|> o
  ,reg2dp_lut_le_function          //|> o
  ,reg2dp_lut_le_index_offset      //|> o
  ,reg2dp_lut_le_index_select      //|> o
  ,reg2dp_lut_le_slope_oflow_scale //|> o
  ,reg2dp_lut_le_slope_oflow_shift //|> o
  ,reg2dp_lut_le_slope_uflow_scale //|> o
  ,reg2dp_lut_le_slope_uflow_shift //|> o
  ,reg2dp_lut_le_start             //|> o
  ,reg2dp_lut_lo_end               //|> o
  ,reg2dp_lut_lo_index_select      //|> o
  ,reg2dp_lut_lo_slope_oflow_scale //|> o
  ,reg2dp_lut_lo_slope_oflow_shift //|> o
  ,reg2dp_lut_lo_slope_uflow_scale //|> o
  ,reg2dp_lut_lo_slope_uflow_shift //|> o
  ,reg2dp_lut_lo_start             //|> o
  ,reg2dp_lut_oflow_priority       //|> o
  ,reg2dp_lut_slcg_en              //|> o
  ,reg2dp_lut_uflow_priority       //|> o
  ,reg2dp_nan_to_zero              //|> o
  ,reg2dp_ncore_slcg_op_en         //|> o
  ,reg2dp_op_en                    //|> o
  ,reg2dp_out_precision            //|> o
  ,reg2dp_output_dst               //|> o
  ,reg2dp_perf_dma_en              //|> o
  ,reg2dp_perf_lut_en              //|> o
  ,reg2dp_perf_nan_inf_count_en    //|> o
  ,reg2dp_perf_sat_en              //|> o
  ,reg2dp_proc_precision           //|> o
  ,reg2dp_wdma_slcg_op_en          //|> o
  ,reg2dp_width                    //|> o
  ,reg2dp_winograd                 //|> o
  ,sdp2csb_resp_pd                 //|> o
  ,sdp2csb_resp_valid              //|> o
  );


input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [62:0] csb2sdp_req_pd;
input         csb2sdp_req_pvld;
input         dp2reg_done;
input  [31:0] dp2reg_lut_hybrid;
input  [15:0] dp2reg_lut_int_data;
input  [31:0] dp2reg_lut_le_hit;
input  [31:0] dp2reg_lut_lo_hit;
input  [31:0] dp2reg_lut_oflow;
input  [31:0] dp2reg_lut_uflow;
input  [31:0] dp2reg_out_saturation;
input  [31:0] dp2reg_status_inf_input_num;
input  [31:0] dp2reg_status_nan_input_num;
input  [31:0] dp2reg_status_nan_output_num;
input   [0:0] dp2reg_status_unequal;
input  [31:0] dp2reg_wdma_stall;
output        csb2sdp_req_prdy;
output  [4:0] reg2dp_batch_number;
output        reg2dp_bcore_slcg_op_en;
output  [1:0] reg2dp_bn_alu_algo;
output        reg2dp_bn_alu_bypass;
output [15:0] reg2dp_bn_alu_operand;
output  [5:0] reg2dp_bn_alu_shift_value;
output        reg2dp_bn_alu_src;
output        reg2dp_bn_bypass;
output        reg2dp_bn_mul_bypass;
output [15:0] reg2dp_bn_mul_operand;
output        reg2dp_bn_mul_prelu;
output  [7:0] reg2dp_bn_mul_shift_value;
output        reg2dp_bn_mul_src;
output        reg2dp_bn_relu_bypass;
output  [1:0] reg2dp_bs_alu_algo;
output        reg2dp_bs_alu_bypass;
output [15:0] reg2dp_bs_alu_operand;
output  [5:0] reg2dp_bs_alu_shift_value;
output        reg2dp_bs_alu_src;
output        reg2dp_bs_bypass;
output        reg2dp_bs_mul_bypass;
output [15:0] reg2dp_bs_mul_operand;
output        reg2dp_bs_mul_prelu;
output  [7:0] reg2dp_bs_mul_shift_value;
output        reg2dp_bs_mul_src;
output        reg2dp_bs_relu_bypass;
output [12:0] reg2dp_channel;
output [31:0] reg2dp_cvt_offset;
output [15:0] reg2dp_cvt_scale;
output  [5:0] reg2dp_cvt_shift;
output [31:0] reg2dp_dst_base_addr_high;
output [31:0] reg2dp_dst_base_addr_low;
output [31:0] reg2dp_dst_batch_stride;
output [31:0] reg2dp_dst_line_stride;
output        reg2dp_dst_ram_type;
output [31:0] reg2dp_dst_surface_stride;
output        reg2dp_ecore_slcg_op_en;
output  [1:0] reg2dp_ew_alu_algo;
output        reg2dp_ew_alu_bypass;
output        reg2dp_ew_alu_cvt_bypass;
output [31:0] reg2dp_ew_alu_cvt_offset;
output [15:0] reg2dp_ew_alu_cvt_scale;
output  [5:0] reg2dp_ew_alu_cvt_truncate;
output [31:0] reg2dp_ew_alu_operand;
output        reg2dp_ew_alu_src;
output        reg2dp_ew_bypass;
output        reg2dp_ew_lut_bypass;
output        reg2dp_ew_mul_bypass;
output        reg2dp_ew_mul_cvt_bypass;
output [31:0] reg2dp_ew_mul_cvt_offset;
output [15:0] reg2dp_ew_mul_cvt_scale;
output  [5:0] reg2dp_ew_mul_cvt_truncate;
output [31:0] reg2dp_ew_mul_operand;
output        reg2dp_ew_mul_prelu;
output        reg2dp_ew_mul_src;
output  [9:0] reg2dp_ew_truncate;
output        reg2dp_flying_mode;
output [12:0] reg2dp_height;
output        reg2dp_interrupt_ptr;
output        reg2dp_lut_hybrid_priority;
output        reg2dp_lut_int_access_type;
output  [9:0] reg2dp_lut_int_addr;
output [15:0] reg2dp_lut_int_data;
output        reg2dp_lut_int_data_wr;
output        reg2dp_lut_int_table_id;
output [31:0] reg2dp_lut_le_end;
output        reg2dp_lut_le_function;
output  [7:0] reg2dp_lut_le_index_offset;
output  [7:0] reg2dp_lut_le_index_select;
output [15:0] reg2dp_lut_le_slope_oflow_scale;
output  [4:0] reg2dp_lut_le_slope_oflow_shift;
output [15:0] reg2dp_lut_le_slope_uflow_scale;
output  [4:0] reg2dp_lut_le_slope_uflow_shift;
output [31:0] reg2dp_lut_le_start;
output [31:0] reg2dp_lut_lo_end;
output  [7:0] reg2dp_lut_lo_index_select;
output [15:0] reg2dp_lut_lo_slope_oflow_scale;
output  [4:0] reg2dp_lut_lo_slope_oflow_shift;
output [15:0] reg2dp_lut_lo_slope_uflow_scale;
output  [4:0] reg2dp_lut_lo_slope_uflow_shift;
output [31:0] reg2dp_lut_lo_start;
output        reg2dp_lut_oflow_priority;
output        reg2dp_lut_slcg_en;
output        reg2dp_lut_uflow_priority;
output        reg2dp_nan_to_zero;
output        reg2dp_ncore_slcg_op_en;
output        reg2dp_op_en;
output  [1:0] reg2dp_out_precision;
output        reg2dp_output_dst;
output        reg2dp_perf_dma_en;
output        reg2dp_perf_lut_en;
output        reg2dp_perf_nan_inf_count_en;
output        reg2dp_perf_sat_en;
output  [1:0] reg2dp_proc_precision;
output        reg2dp_wdma_slcg_op_en;
output [12:0] reg2dp_width;
output        reg2dp_winograd;
output [33:0] sdp2csb_resp_pd;
output        sdp2csb_resp_valid;
wire          bcore_slcg_op_en;
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
wire   [31:0] dp2reg_d0_lut_hybrid_w;
wire   [31:0] dp2reg_d0_lut_le_hit_w;
wire   [31:0] dp2reg_d0_lut_lo_hit_w;
wire   [31:0] dp2reg_d0_lut_oflow_w;
wire   [31:0] dp2reg_d0_lut_uflow_w;
wire   [31:0] dp2reg_d0_out_saturation_w;
wire   [31:0] dp2reg_d0_status_inf_input_num_w;
wire   [31:0] dp2reg_d0_status_nan_input_num_w;
wire   [31:0] dp2reg_d0_status_nan_output_num_w;
wire          dp2reg_d0_status_unequal_w;
wire   [31:0] dp2reg_d0_wdma_stall_w;
wire   [31:0] dp2reg_d1_lut_hybrid_w;
wire   [31:0] dp2reg_d1_lut_le_hit_w;
wire   [31:0] dp2reg_d1_lut_lo_hit_w;
wire   [31:0] dp2reg_d1_lut_oflow_w;
wire   [31:0] dp2reg_d1_lut_uflow_w;
wire   [31:0] dp2reg_d1_out_saturation_w;
wire   [31:0] dp2reg_d1_status_inf_input_num_w;
wire   [31:0] dp2reg_d1_status_nan_input_num_w;
wire   [31:0] dp2reg_d1_status_nan_output_num_w;
wire          dp2reg_d1_status_unequal_w;
wire   [31:0] dp2reg_d1_wdma_stall_w;
wire   [15:0] dp2reg_lut_data;
wire          ecore_slcg_op_en;
wire          lut_int_data_rd_trigger;
wire          ncore_slcg_op_en;
wire    [4:0] reg2dp_d0_batch_number;
wire    [1:0] reg2dp_d0_bn_alu_algo;
wire          reg2dp_d0_bn_alu_bypass;
wire   [15:0] reg2dp_d0_bn_alu_operand;
wire    [5:0] reg2dp_d0_bn_alu_shift_value;
wire          reg2dp_d0_bn_alu_src;
wire          reg2dp_d0_bn_bypass;
wire          reg2dp_d0_bn_mul_bypass;
wire   [15:0] reg2dp_d0_bn_mul_operand;
wire          reg2dp_d0_bn_mul_prelu;
wire    [7:0] reg2dp_d0_bn_mul_shift_value;
wire          reg2dp_d0_bn_mul_src;
wire          reg2dp_d0_bn_relu_bypass;
wire    [1:0] reg2dp_d0_bs_alu_algo;
wire          reg2dp_d0_bs_alu_bypass;
wire   [15:0] reg2dp_d0_bs_alu_operand;
wire    [5:0] reg2dp_d0_bs_alu_shift_value;
wire          reg2dp_d0_bs_alu_src;
wire          reg2dp_d0_bs_bypass;
wire          reg2dp_d0_bs_mul_bypass;
wire   [15:0] reg2dp_d0_bs_mul_operand;
wire          reg2dp_d0_bs_mul_prelu;
wire    [7:0] reg2dp_d0_bs_mul_shift_value;
wire          reg2dp_d0_bs_mul_src;
wire          reg2dp_d0_bs_relu_bypass;
wire   [12:0] reg2dp_d0_channel;
wire   [31:0] reg2dp_d0_cvt_offset;
wire   [15:0] reg2dp_d0_cvt_scale;
wire    [5:0] reg2dp_d0_cvt_shift;
wire   [31:0] reg2dp_d0_dst_base_addr_high;
wire   [31:0] reg2dp_d0_dst_base_addr_low;
wire   [31:0] reg2dp_d0_dst_batch_stride;
wire   [31:0] reg2dp_d0_dst_line_stride;
wire          reg2dp_d0_dst_ram_type;
wire   [31:0] reg2dp_d0_dst_surface_stride;
wire    [1:0] reg2dp_d0_ew_alu_algo;
wire          reg2dp_d0_ew_alu_bypass;
wire          reg2dp_d0_ew_alu_cvt_bypass;
wire   [31:0] reg2dp_d0_ew_alu_cvt_offset;
wire   [15:0] reg2dp_d0_ew_alu_cvt_scale;
wire    [5:0] reg2dp_d0_ew_alu_cvt_truncate;
wire   [31:0] reg2dp_d0_ew_alu_operand;
wire          reg2dp_d0_ew_alu_src;
wire          reg2dp_d0_ew_bypass;
wire          reg2dp_d0_ew_lut_bypass;
wire          reg2dp_d0_ew_mul_bypass;
wire          reg2dp_d0_ew_mul_cvt_bypass;
wire   [31:0] reg2dp_d0_ew_mul_cvt_offset;
wire   [15:0] reg2dp_d0_ew_mul_cvt_scale;
wire    [5:0] reg2dp_d0_ew_mul_cvt_truncate;
wire   [31:0] reg2dp_d0_ew_mul_operand;
wire          reg2dp_d0_ew_mul_prelu;
wire          reg2dp_d0_ew_mul_src;
wire    [9:0] reg2dp_d0_ew_truncate;
wire          reg2dp_d0_flying_mode;
wire   [12:0] reg2dp_d0_height;
wire          reg2dp_d0_nan_to_zero;
wire          reg2dp_d0_op_en_trigger;
wire    [1:0] reg2dp_d0_out_precision;
wire          reg2dp_d0_output_dst;
wire          reg2dp_d0_perf_dma_en;
wire          reg2dp_d0_perf_lut_en;
wire          reg2dp_d0_perf_nan_inf_count_en;
wire          reg2dp_d0_perf_sat_en;
wire    [1:0] reg2dp_d0_proc_precision;
wire   [12:0] reg2dp_d0_width;
wire          reg2dp_d0_winograd;
wire    [4:0] reg2dp_d1_batch_number;
wire    [1:0] reg2dp_d1_bn_alu_algo;
wire          reg2dp_d1_bn_alu_bypass;
wire   [15:0] reg2dp_d1_bn_alu_operand;
wire    [5:0] reg2dp_d1_bn_alu_shift_value;
wire          reg2dp_d1_bn_alu_src;
wire          reg2dp_d1_bn_bypass;
wire          reg2dp_d1_bn_mul_bypass;
wire   [15:0] reg2dp_d1_bn_mul_operand;
wire          reg2dp_d1_bn_mul_prelu;
wire    [7:0] reg2dp_d1_bn_mul_shift_value;
wire          reg2dp_d1_bn_mul_src;
wire          reg2dp_d1_bn_relu_bypass;
wire    [1:0] reg2dp_d1_bs_alu_algo;
wire          reg2dp_d1_bs_alu_bypass;
wire   [15:0] reg2dp_d1_bs_alu_operand;
wire    [5:0] reg2dp_d1_bs_alu_shift_value;
wire          reg2dp_d1_bs_alu_src;
wire          reg2dp_d1_bs_bypass;
wire          reg2dp_d1_bs_mul_bypass;
wire   [15:0] reg2dp_d1_bs_mul_operand;
wire          reg2dp_d1_bs_mul_prelu;
wire    [7:0] reg2dp_d1_bs_mul_shift_value;
wire          reg2dp_d1_bs_mul_src;
wire          reg2dp_d1_bs_relu_bypass;
wire   [12:0] reg2dp_d1_channel;
wire   [31:0] reg2dp_d1_cvt_offset;
wire   [15:0] reg2dp_d1_cvt_scale;
wire    [5:0] reg2dp_d1_cvt_shift;
wire   [31:0] reg2dp_d1_dst_base_addr_high;
wire   [31:0] reg2dp_d1_dst_base_addr_low;
wire   [31:0] reg2dp_d1_dst_batch_stride;
wire   [31:0] reg2dp_d1_dst_line_stride;
wire          reg2dp_d1_dst_ram_type;
wire   [31:0] reg2dp_d1_dst_surface_stride;
wire    [1:0] reg2dp_d1_ew_alu_algo;
wire          reg2dp_d1_ew_alu_bypass;
wire          reg2dp_d1_ew_alu_cvt_bypass;
wire   [31:0] reg2dp_d1_ew_alu_cvt_offset;
wire   [15:0] reg2dp_d1_ew_alu_cvt_scale;
wire    [5:0] reg2dp_d1_ew_alu_cvt_truncate;
wire   [31:0] reg2dp_d1_ew_alu_operand;
wire          reg2dp_d1_ew_alu_src;
wire          reg2dp_d1_ew_bypass;
wire          reg2dp_d1_ew_lut_bypass;
wire          reg2dp_d1_ew_mul_bypass;
wire          reg2dp_d1_ew_mul_cvt_bypass;
wire   [31:0] reg2dp_d1_ew_mul_cvt_offset;
wire   [15:0] reg2dp_d1_ew_mul_cvt_scale;
wire    [5:0] reg2dp_d1_ew_mul_cvt_truncate;
wire   [31:0] reg2dp_d1_ew_mul_operand;
wire          reg2dp_d1_ew_mul_prelu;
wire          reg2dp_d1_ew_mul_src;
wire    [9:0] reg2dp_d1_ew_truncate;
wire          reg2dp_d1_flying_mode;
wire   [12:0] reg2dp_d1_height;
wire          reg2dp_d1_nan_to_zero;
wire          reg2dp_d1_op_en_trigger;
wire    [1:0] reg2dp_d1_out_precision;
wire          reg2dp_d1_output_dst;
wire          reg2dp_d1_perf_dma_en;
wire          reg2dp_d1_perf_lut_en;
wire          reg2dp_d1_perf_nan_inf_count_en;
wire          reg2dp_d1_perf_sat_en;
wire    [1:0] reg2dp_d1_proc_precision;
wire   [12:0] reg2dp_d1_width;
wire          reg2dp_d1_winograd;
wire          reg2dp_lut_access_type;
wire    [9:0] reg2dp_lut_addr;
wire          reg2dp_lut_addr_trigger;
wire          reg2dp_lut_data_trigger;
wire          reg2dp_lut_table_id;
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
wire    [3:0] slcg_op_en;
wire    [3:0] slcg_op_en_d0;
wire          wdma_slcg_op_en;
reg           dp2reg_consumer;
reg           dp2reg_d0_clr;
reg    [31:0] dp2reg_d0_lut_hybrid;
reg    [31:0] dp2reg_d0_lut_le_hit;
reg    [31:0] dp2reg_d0_lut_lo_hit;
reg    [31:0] dp2reg_d0_lut_oflow;
reg    [31:0] dp2reg_d0_lut_uflow;
reg    [31:0] dp2reg_d0_out_saturation;
reg           dp2reg_d0_reg;
reg           dp2reg_d0_set;
reg    [31:0] dp2reg_d0_status_inf_input_num;
reg    [31:0] dp2reg_d0_status_nan_input_num;
reg    [31:0] dp2reg_d0_status_nan_output_num;
reg           dp2reg_d0_status_unequal;
reg    [31:0] dp2reg_d0_wdma_stall;
reg           dp2reg_d1_clr;
reg    [31:0] dp2reg_d1_lut_hybrid;
reg    [31:0] dp2reg_d1_lut_le_hit;
reg    [31:0] dp2reg_d1_lut_lo_hit;
reg    [31:0] dp2reg_d1_lut_oflow;
reg    [31:0] dp2reg_d1_lut_uflow;
reg    [31:0] dp2reg_d1_out_saturation;
reg           dp2reg_d1_reg;
reg           dp2reg_d1_set;
reg    [31:0] dp2reg_d1_status_inf_input_num;
reg    [31:0] dp2reg_d1_status_nan_input_num;
reg    [31:0] dp2reg_d1_status_nan_output_num;
reg           dp2reg_d1_status_unequal;
reg    [31:0] dp2reg_d1_wdma_stall;
reg     [1:0] dp2reg_status_0;
reg     [1:0] dp2reg_status_1;
reg           lut_int_access_type;
reg     [9:0] lut_int_addr;
reg           lut_int_addr_trigger;
reg           lut_int_data_wr_trigger;
reg           lut_int_table_id;
reg     [4:0] reg2dp_batch_number;
reg     [1:0] reg2dp_bn_alu_algo;
reg           reg2dp_bn_alu_bypass;
reg    [15:0] reg2dp_bn_alu_operand;
reg     [5:0] reg2dp_bn_alu_shift_value;
reg           reg2dp_bn_alu_src;
reg           reg2dp_bn_bypass;
reg           reg2dp_bn_mul_bypass;
reg    [15:0] reg2dp_bn_mul_operand;
reg           reg2dp_bn_mul_prelu;
reg     [7:0] reg2dp_bn_mul_shift_value;
reg           reg2dp_bn_mul_src;
reg           reg2dp_bn_relu_bypass;
reg     [1:0] reg2dp_bs_alu_algo;
reg           reg2dp_bs_alu_bypass;
reg    [15:0] reg2dp_bs_alu_operand;
reg     [5:0] reg2dp_bs_alu_shift_value;
reg           reg2dp_bs_alu_src;
reg           reg2dp_bs_bypass;
reg           reg2dp_bs_mul_bypass;
reg    [15:0] reg2dp_bs_mul_operand;
reg           reg2dp_bs_mul_prelu;
reg     [7:0] reg2dp_bs_mul_shift_value;
reg           reg2dp_bs_mul_src;
reg           reg2dp_bs_relu_bypass;
reg    [12:0] reg2dp_channel;
reg    [31:0] reg2dp_cvt_offset;
reg    [15:0] reg2dp_cvt_scale;
reg     [5:0] reg2dp_cvt_shift;
reg           reg2dp_d0_op_en;
reg           reg2dp_d0_op_en_w;
reg           reg2dp_d1_op_en;
reg           reg2dp_d1_op_en_w;
reg    [31:0] reg2dp_dst_base_addr_high;
reg    [31:0] reg2dp_dst_base_addr_low;
reg    [31:0] reg2dp_dst_batch_stride;
reg    [31:0] reg2dp_dst_line_stride;
reg           reg2dp_dst_ram_type;
reg    [31:0] reg2dp_dst_surface_stride;
reg     [1:0] reg2dp_ew_alu_algo;
reg           reg2dp_ew_alu_bypass;
reg           reg2dp_ew_alu_cvt_bypass;
reg    [31:0] reg2dp_ew_alu_cvt_offset;
reg    [15:0] reg2dp_ew_alu_cvt_scale;
reg     [5:0] reg2dp_ew_alu_cvt_truncate;
reg    [31:0] reg2dp_ew_alu_operand;
reg           reg2dp_ew_alu_src;
reg           reg2dp_ew_bypass;
reg           reg2dp_ew_lut_bypass;
reg           reg2dp_ew_mul_bypass;
reg           reg2dp_ew_mul_cvt_bypass;
reg    [31:0] reg2dp_ew_mul_cvt_offset;
reg    [15:0] reg2dp_ew_mul_cvt_scale;
reg     [5:0] reg2dp_ew_mul_cvt_truncate;
reg    [31:0] reg2dp_ew_mul_operand;
reg           reg2dp_ew_mul_prelu;
reg           reg2dp_ew_mul_src;
reg     [9:0] reg2dp_ew_truncate;
reg           reg2dp_flying_mode;
reg    [12:0] reg2dp_height;
reg    [15:0] reg2dp_lut_int_data;
reg           reg2dp_lut_slcg_en;
reg           reg2dp_nan_to_zero;
reg           reg2dp_op_en_ori;
reg     [2:0] reg2dp_op_en_reg;
reg     [1:0] reg2dp_out_precision;
reg           reg2dp_output_dst;
reg           reg2dp_perf_dma_en;
reg           reg2dp_perf_lut_en;
reg           reg2dp_perf_nan_inf_count_en;
reg           reg2dp_perf_sat_en;
reg     [1:0] reg2dp_proc_precision;
reg    [12:0] reg2dp_width;
reg           reg2dp_winograd;
reg    [62:0] req_pd;
reg           req_pvld;
reg    [33:0] sdp2csb_resp_pd;
reg           sdp2csb_resp_valid;
reg     [3:0] slcg_op_en_d1;
reg     [3:0] slcg_op_en_d2;
reg     [3:0] slcg_op_en_d3;


//Instance single register group
NV_NVDLA_SDP_REG_single u_single_reg (
   .reg_rd_data              (s_reg_rd_data[31:0])                   //|> w
  ,.reg_offset               (s_reg_offset[11:0])                    //|< w
  ,.reg_wr_data              (s_reg_wr_data[31:0])                   //|< w
  ,.reg_wr_en                (s_reg_wr_en)                           //|< w
  ,.nvdla_core_clk           (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)                       //|< i
  ,.lut_access_type          (reg2dp_lut_access_type)                //|> w
  ,.lut_addr                 (reg2dp_lut_addr[9:0])                  //|> w
  ,.lut_addr_trigger         (reg2dp_lut_addr_trigger)               //|> w
  ,.lut_table_id             (reg2dp_lut_table_id)                   //|> w
  ,.lut_data_trigger         (reg2dp_lut_data_trigger)               //|> w
  ,.lut_hybrid_priority      (reg2dp_lut_hybrid_priority)            //|> o
  ,.lut_le_function          (reg2dp_lut_le_function)                //|> o
  ,.lut_oflow_priority       (reg2dp_lut_oflow_priority)             //|> o
  ,.lut_uflow_priority       (reg2dp_lut_uflow_priority)             //|> o
  ,.lut_le_index_offset      (reg2dp_lut_le_index_offset[7:0])       //|> o
  ,.lut_le_index_select      (reg2dp_lut_le_index_select[7:0])       //|> o
  ,.lut_lo_index_select      (reg2dp_lut_lo_index_select[7:0])       //|> o
  ,.lut_le_end               (reg2dp_lut_le_end[31:0])               //|> o
  ,.lut_le_slope_oflow_scale (reg2dp_lut_le_slope_oflow_scale[15:0]) //|> o
  ,.lut_le_slope_uflow_scale (reg2dp_lut_le_slope_uflow_scale[15:0]) //|> o
  ,.lut_le_slope_oflow_shift (reg2dp_lut_le_slope_oflow_shift[4:0])  //|> o
  ,.lut_le_slope_uflow_shift (reg2dp_lut_le_slope_uflow_shift[4:0])  //|> o
  ,.lut_le_start             (reg2dp_lut_le_start[31:0])             //|> o
  ,.lut_lo_end               (reg2dp_lut_lo_end[31:0])               //|> o
  ,.lut_lo_slope_oflow_scale (reg2dp_lut_lo_slope_oflow_scale[15:0]) //|> o
  ,.lut_lo_slope_uflow_scale (reg2dp_lut_lo_slope_uflow_scale[15:0]) //|> o
  ,.lut_lo_slope_oflow_shift (reg2dp_lut_lo_slope_oflow_shift[4:0])  //|> o
  ,.lut_lo_slope_uflow_shift (reg2dp_lut_lo_slope_uflow_shift[4:0])  //|> o
  ,.lut_lo_start             (reg2dp_lut_lo_start[31:0])             //|> o
  ,.producer                 (reg2dp_producer)                       //|> w
  ,.lut_data                 (dp2reg_lut_data[15:0])                 //|< w
  ,.consumer                 (dp2reg_consumer)                       //|< r
  ,.status_0                 (dp2reg_status_0[1:0])                  //|< r
  ,.status_1                 (dp2reg_status_1[1:0])                  //|< r
  );

//Instance two duplicated register groups

NV_NVDLA_SDP_REG_dual u_dual_reg_d0 (
   .reg_rd_data              (d0_reg_rd_data[31:0])                  //|> w
  ,.reg_offset               (d0_reg_offset[11:0])                   //|< w
  ,.reg_wr_data              (d0_reg_wr_data[31:0])                  //|< w
  ,.reg_wr_en                (d0_reg_wr_en)                          //|< w
  ,.nvdla_core_clk           (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)                       //|< i
  ,.cvt_offset               (reg2dp_d0_cvt_offset[31:0])            //|> w
  ,.cvt_scale                (reg2dp_d0_cvt_scale[15:0])             //|> w
  ,.cvt_shift                (reg2dp_d0_cvt_shift[5:0])              //|> w
  ,.channel                  (reg2dp_d0_channel[12:0])               //|> w
  ,.height                   (reg2dp_d0_height[12:0])                //|> w
  ,.width                    (reg2dp_d0_width[12:0])                 //|> w
  ,.out_precision            (reg2dp_d0_out_precision[1:0])          //|> w
  ,.proc_precision           (reg2dp_d0_proc_precision[1:0])         //|> w
  ,.bn_alu_shift_value       (reg2dp_d0_bn_alu_shift_value[5:0])     //|> w
  ,.bn_alu_src               (reg2dp_d0_bn_alu_src)                  //|> w
  ,.bn_alu_operand           (reg2dp_d0_bn_alu_operand[15:0])        //|> w
  ,.bn_alu_algo              (reg2dp_d0_bn_alu_algo[1:0])            //|> w
  ,.bn_alu_bypass            (reg2dp_d0_bn_alu_bypass)               //|> w
  ,.bn_bypass                (reg2dp_d0_bn_bypass)                   //|> w
  ,.bn_mul_bypass            (reg2dp_d0_bn_mul_bypass)               //|> w
  ,.bn_mul_prelu             (reg2dp_d0_bn_mul_prelu)                //|> w
  ,.bn_relu_bypass           (reg2dp_d0_bn_relu_bypass)              //|> w
  ,.bn_mul_shift_value       (reg2dp_d0_bn_mul_shift_value[7:0])     //|> w
  ,.bn_mul_src               (reg2dp_d0_bn_mul_src)                  //|> w
  ,.bn_mul_operand           (reg2dp_d0_bn_mul_operand[15:0])        //|> w
  ,.bs_alu_shift_value       (reg2dp_d0_bs_alu_shift_value[5:0])     //|> w
  ,.bs_alu_src               (reg2dp_d0_bs_alu_src)                  //|> w
  ,.bs_alu_operand           (reg2dp_d0_bs_alu_operand[15:0])        //|> w
  ,.bs_alu_algo              (reg2dp_d0_bs_alu_algo[1:0])            //|> w
  ,.bs_alu_bypass            (reg2dp_d0_bs_alu_bypass)               //|> w
  ,.bs_bypass                (reg2dp_d0_bs_bypass)                   //|> w
  ,.bs_mul_bypass            (reg2dp_d0_bs_mul_bypass)               //|> w
  ,.bs_mul_prelu             (reg2dp_d0_bs_mul_prelu)                //|> w
  ,.bs_relu_bypass           (reg2dp_d0_bs_relu_bypass)              //|> w
  ,.bs_mul_shift_value       (reg2dp_d0_bs_mul_shift_value[7:0])     //|> w
  ,.bs_mul_src               (reg2dp_d0_bs_mul_src)                  //|> w
  ,.bs_mul_operand           (reg2dp_d0_bs_mul_operand[15:0])        //|> w
  ,.ew_alu_cvt_bypass        (reg2dp_d0_ew_alu_cvt_bypass)           //|> w
  ,.ew_alu_src               (reg2dp_d0_ew_alu_src)                  //|> w
  ,.ew_alu_cvt_offset        (reg2dp_d0_ew_alu_cvt_offset[31:0])     //|> w
  ,.ew_alu_cvt_scale         (reg2dp_d0_ew_alu_cvt_scale[15:0])      //|> w
  ,.ew_alu_cvt_truncate      (reg2dp_d0_ew_alu_cvt_truncate[5:0])    //|> w
  ,.ew_alu_operand           (reg2dp_d0_ew_alu_operand[31:0])        //|> w
  ,.ew_alu_algo              (reg2dp_d0_ew_alu_algo[1:0])            //|> w
  ,.ew_alu_bypass            (reg2dp_d0_ew_alu_bypass)               //|> w
  ,.ew_bypass                (reg2dp_d0_ew_bypass)                   //|> w
  ,.ew_lut_bypass            (reg2dp_d0_ew_lut_bypass)               //|> w
  ,.ew_mul_bypass            (reg2dp_d0_ew_mul_bypass)               //|> w
  ,.ew_mul_prelu             (reg2dp_d0_ew_mul_prelu)                //|> w
  ,.ew_mul_cvt_bypass        (reg2dp_d0_ew_mul_cvt_bypass)           //|> w
  ,.ew_mul_src               (reg2dp_d0_ew_mul_src)                  //|> w
  ,.ew_mul_cvt_offset        (reg2dp_d0_ew_mul_cvt_offset[31:0])     //|> w
  ,.ew_mul_cvt_scale         (reg2dp_d0_ew_mul_cvt_scale[15:0])      //|> w
  ,.ew_mul_cvt_truncate      (reg2dp_d0_ew_mul_cvt_truncate[5:0])    //|> w
  ,.ew_mul_operand           (reg2dp_d0_ew_mul_operand[31:0])        //|> w
  ,.ew_truncate              (reg2dp_d0_ew_truncate[9:0])            //|> w
  ,.dst_base_addr_high       (reg2dp_d0_dst_base_addr_high[31:0])    //|> w
  ,.dst_base_addr_low        (reg2dp_d0_dst_base_addr_low[31:0])     //|> w
  ,.dst_batch_stride         (reg2dp_d0_dst_batch_stride[31:0])      //|> w
  ,.dst_ram_type             (reg2dp_d0_dst_ram_type)                //|> w
  ,.dst_line_stride          (reg2dp_d0_dst_line_stride[31:0])       //|> w
  ,.dst_surface_stride       (reg2dp_d0_dst_surface_stride[31:0])    //|> w
  ,.batch_number             (reg2dp_d0_batch_number[4:0])           //|> w
  ,.flying_mode              (reg2dp_d0_flying_mode)                 //|> w
  ,.nan_to_zero              (reg2dp_d0_nan_to_zero)                 //|> w
  ,.output_dst               (reg2dp_d0_output_dst)                  //|> w
  ,.winograd                 (reg2dp_d0_winograd)                    //|> w
  ,.op_en_trigger            (reg2dp_d0_op_en_trigger)               //|> w
  ,.perf_dma_en              (reg2dp_d0_perf_dma_en)                 //|> w
  ,.perf_lut_en              (reg2dp_d0_perf_lut_en)                 //|> w
  ,.perf_nan_inf_count_en    (reg2dp_d0_perf_nan_inf_count_en)       //|> w
  ,.perf_sat_en              (reg2dp_d0_perf_sat_en)                 //|> w
  ,.op_en                    (reg2dp_d0_op_en)                       //|< r
  ,.lut_hybrid               (dp2reg_d0_lut_hybrid[31:0])            //|< r
  ,.lut_le_hit               (dp2reg_d0_lut_le_hit[31:0])            //|< r
  ,.lut_lo_hit               (dp2reg_d0_lut_lo_hit[31:0])            //|< r
  ,.lut_oflow                (dp2reg_d0_lut_oflow[31:0])             //|< r
  ,.lut_uflow                (dp2reg_d0_lut_uflow[31:0])             //|< r
  ,.out_saturation           (dp2reg_d0_out_saturation[31:0])        //|< r
  ,.wdma_stall               (dp2reg_d0_wdma_stall[31:0])            //|< r
  ,.status_unequal           (dp2reg_d0_status_unequal)              //|< r
  ,.status_inf_input_num     (dp2reg_d0_status_inf_input_num[31:0])  //|< r
  ,.status_nan_input_num     (dp2reg_d0_status_nan_input_num[31:0])  //|< r
  ,.status_nan_output_num    (dp2reg_d0_status_nan_output_num[31:0]) //|< r
  );
        
NV_NVDLA_SDP_REG_dual u_dual_reg_d1 (
   .reg_rd_data              (d1_reg_rd_data[31:0])                  //|> w
  ,.reg_offset               (d1_reg_offset[11:0])                   //|< w
  ,.reg_wr_data              (d1_reg_wr_data[31:0])                  //|< w
  ,.reg_wr_en                (d1_reg_wr_en)                          //|< w
  ,.nvdla_core_clk           (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)                       //|< i
  ,.cvt_offset               (reg2dp_d1_cvt_offset[31:0])            //|> w
  ,.cvt_scale                (reg2dp_d1_cvt_scale[15:0])             //|> w
  ,.cvt_shift                (reg2dp_d1_cvt_shift[5:0])              //|> w
  ,.channel                  (reg2dp_d1_channel[12:0])               //|> w
  ,.height                   (reg2dp_d1_height[12:0])                //|> w
  ,.width                    (reg2dp_d1_width[12:0])                 //|> w
  ,.out_precision            (reg2dp_d1_out_precision[1:0])          //|> w
  ,.proc_precision           (reg2dp_d1_proc_precision[1:0])         //|> w
  ,.bn_alu_shift_value       (reg2dp_d1_bn_alu_shift_value[5:0])     //|> w
  ,.bn_alu_src               (reg2dp_d1_bn_alu_src)                  //|> w
  ,.bn_alu_operand           (reg2dp_d1_bn_alu_operand[15:0])        //|> w
  ,.bn_alu_algo              (reg2dp_d1_bn_alu_algo[1:0])            //|> w
  ,.bn_alu_bypass            (reg2dp_d1_bn_alu_bypass)               //|> w
  ,.bn_bypass                (reg2dp_d1_bn_bypass)                   //|> w
  ,.bn_mul_bypass            (reg2dp_d1_bn_mul_bypass)               //|> w
  ,.bn_mul_prelu             (reg2dp_d1_bn_mul_prelu)                //|> w
  ,.bn_relu_bypass           (reg2dp_d1_bn_relu_bypass)              //|> w
  ,.bn_mul_shift_value       (reg2dp_d1_bn_mul_shift_value[7:0])     //|> w
  ,.bn_mul_src               (reg2dp_d1_bn_mul_src)                  //|> w
  ,.bn_mul_operand           (reg2dp_d1_bn_mul_operand[15:0])        //|> w
  ,.bs_alu_shift_value       (reg2dp_d1_bs_alu_shift_value[5:0])     //|> w
  ,.bs_alu_src               (reg2dp_d1_bs_alu_src)                  //|> w
  ,.bs_alu_operand           (reg2dp_d1_bs_alu_operand[15:0])        //|> w
  ,.bs_alu_algo              (reg2dp_d1_bs_alu_algo[1:0])            //|> w
  ,.bs_alu_bypass            (reg2dp_d1_bs_alu_bypass)               //|> w
  ,.bs_bypass                (reg2dp_d1_bs_bypass)                   //|> w
  ,.bs_mul_bypass            (reg2dp_d1_bs_mul_bypass)               //|> w
  ,.bs_mul_prelu             (reg2dp_d1_bs_mul_prelu)                //|> w
  ,.bs_relu_bypass           (reg2dp_d1_bs_relu_bypass)              //|> w
  ,.bs_mul_shift_value       (reg2dp_d1_bs_mul_shift_value[7:0])     //|> w
  ,.bs_mul_src               (reg2dp_d1_bs_mul_src)                  //|> w
  ,.bs_mul_operand           (reg2dp_d1_bs_mul_operand[15:0])        //|> w
  ,.ew_alu_cvt_bypass        (reg2dp_d1_ew_alu_cvt_bypass)           //|> w
  ,.ew_alu_src               (reg2dp_d1_ew_alu_src)                  //|> w
  ,.ew_alu_cvt_offset        (reg2dp_d1_ew_alu_cvt_offset[31:0])     //|> w
  ,.ew_alu_cvt_scale         (reg2dp_d1_ew_alu_cvt_scale[15:0])      //|> w
  ,.ew_alu_cvt_truncate      (reg2dp_d1_ew_alu_cvt_truncate[5:0])    //|> w
  ,.ew_alu_operand           (reg2dp_d1_ew_alu_operand[31:0])        //|> w
  ,.ew_alu_algo              (reg2dp_d1_ew_alu_algo[1:0])            //|> w
  ,.ew_alu_bypass            (reg2dp_d1_ew_alu_bypass)               //|> w
  ,.ew_bypass                (reg2dp_d1_ew_bypass)                   //|> w
  ,.ew_lut_bypass            (reg2dp_d1_ew_lut_bypass)               //|> w
  ,.ew_mul_bypass            (reg2dp_d1_ew_mul_bypass)               //|> w
  ,.ew_mul_prelu             (reg2dp_d1_ew_mul_prelu)                //|> w
  ,.ew_mul_cvt_bypass        (reg2dp_d1_ew_mul_cvt_bypass)           //|> w
  ,.ew_mul_src               (reg2dp_d1_ew_mul_src)                  //|> w
  ,.ew_mul_cvt_offset        (reg2dp_d1_ew_mul_cvt_offset[31:0])     //|> w
  ,.ew_mul_cvt_scale         (reg2dp_d1_ew_mul_cvt_scale[15:0])      //|> w
  ,.ew_mul_cvt_truncate      (reg2dp_d1_ew_mul_cvt_truncate[5:0])    //|> w
  ,.ew_mul_operand           (reg2dp_d1_ew_mul_operand[31:0])        //|> w
  ,.ew_truncate              (reg2dp_d1_ew_truncate[9:0])            //|> w
  ,.dst_base_addr_high       (reg2dp_d1_dst_base_addr_high[31:0])    //|> w
  ,.dst_base_addr_low        (reg2dp_d1_dst_base_addr_low[31:0])     //|> w
  ,.dst_batch_stride         (reg2dp_d1_dst_batch_stride[31:0])      //|> w
  ,.dst_ram_type             (reg2dp_d1_dst_ram_type)                //|> w
  ,.dst_line_stride          (reg2dp_d1_dst_line_stride[31:0])       //|> w
  ,.dst_surface_stride       (reg2dp_d1_dst_surface_stride[31:0])    //|> w
  ,.batch_number             (reg2dp_d1_batch_number[4:0])           //|> w
  ,.flying_mode              (reg2dp_d1_flying_mode)                 //|> w
  ,.nan_to_zero              (reg2dp_d1_nan_to_zero)                 //|> w
  ,.output_dst               (reg2dp_d1_output_dst)                  //|> w
  ,.winograd                 (reg2dp_d1_winograd)                    //|> w
  ,.op_en_trigger            (reg2dp_d1_op_en_trigger)               //|> w
  ,.perf_dma_en              (reg2dp_d1_perf_dma_en)                 //|> w
  ,.perf_lut_en              (reg2dp_d1_perf_lut_en)                 //|> w
  ,.perf_nan_inf_count_en    (reg2dp_d1_perf_nan_inf_count_en)       //|> w
  ,.perf_sat_en              (reg2dp_d1_perf_sat_en)                 //|> w
  ,.op_en                    (reg2dp_d1_op_en)                       //|< r
  ,.lut_hybrid               (dp2reg_d1_lut_hybrid[31:0])            //|< r
  ,.lut_le_hit               (dp2reg_d1_lut_le_hit[31:0])            //|< r
  ,.lut_lo_hit               (dp2reg_d1_lut_lo_hit[31:0])            //|< r
  ,.lut_oflow                (dp2reg_d1_lut_oflow[31:0])             //|< r
  ,.lut_uflow                (dp2reg_d1_lut_uflow[31:0])             //|< r
  ,.out_saturation           (dp2reg_d1_out_saturation[31:0])        //|< r
  ,.wdma_stall               (dp2reg_d1_wdma_stall[31:0])            //|< r
  ,.status_unequal           (dp2reg_d1_status_unequal)              //|< r
  ,.status_inf_input_num     (dp2reg_d1_status_inf_input_num[31:0])  //|< r
  ,.status_nan_input_num     (dp2reg_d1_status_nan_input_num[31:0])  //|< r
  ,.status_nan_output_num    (dp2reg_d1_status_nan_output_num[31:0]) //|< r
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
assign select_s  = (reg_offset[11:0] < (32'hb038  & 32'hfff)) ? 1'b1: 1'b0;
assign select_d0 = (reg_offset[11:0] >= (32'hb038  & 32'hfff)) & (reg2dp_producer == 1'h0 );
assign select_d1 = (reg_offset[11:0] >= (32'hb038  & 32'hfff)) & (reg2dp_producer == 1'h1 );

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
  req_pvld <= csb2sdp_req_pvld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_pd <= {63{1'b0}};
  end else begin
  if ((csb2sdp_req_pvld) == 1'b1) begin
    req_pd <= csb2sdp_req_pd;
  // VCS coverage off
  end else if ((csb2sdp_req_pvld) == 1'b0) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(csb2sdp_req_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign csb2sdp_req_prdy = 1'b1;


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
    sdp2csb_resp_pd <= {34{1'b0}};
  end else begin
    if(reg_rd_en)
    begin
        sdp2csb_resp_pd <= csb_rresp_pd_w;
    end
    else if(reg_wr_en & req_nposted)
    begin
        sdp2csb_resp_pd <= csb_wresp_pd_w;
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp2csb_resp_valid <= 1'b0;
  end else begin
    sdp2csb_resp_valid <= (reg_wr_en & req_nposted) | reg_rd_en;
  end
end

////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE OUTPUT REGISTER FILED FROM DUPLICATED REGISTER GROUPS     //
//                                                                    //
////////////////////////////////////////////////////////////////////////
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
  or reg2dp_d1_cvt_shift
  or reg2dp_d0_cvt_shift
  ) begin
    reg2dp_cvt_shift = dp2reg_consumer ? reg2dp_d1_cvt_shift : reg2dp_d0_cvt_shift;
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
  or reg2dp_d1_bn_alu_shift_value
  or reg2dp_d0_bn_alu_shift_value
  ) begin
    reg2dp_bn_alu_shift_value = dp2reg_consumer ? reg2dp_d1_bn_alu_shift_value : reg2dp_d0_bn_alu_shift_value;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_alu_src
  or reg2dp_d0_bn_alu_src
  ) begin
    reg2dp_bn_alu_src = dp2reg_consumer ? reg2dp_d1_bn_alu_src : reg2dp_d0_bn_alu_src;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_alu_operand
  or reg2dp_d0_bn_alu_operand
  ) begin
    reg2dp_bn_alu_operand = dp2reg_consumer ? reg2dp_d1_bn_alu_operand : reg2dp_d0_bn_alu_operand;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_alu_algo
  or reg2dp_d0_bn_alu_algo
  ) begin
    reg2dp_bn_alu_algo = dp2reg_consumer ? reg2dp_d1_bn_alu_algo : reg2dp_d0_bn_alu_algo;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_alu_bypass
  or reg2dp_d0_bn_alu_bypass
  ) begin
    reg2dp_bn_alu_bypass = dp2reg_consumer ? reg2dp_d1_bn_alu_bypass : reg2dp_d0_bn_alu_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_bypass
  or reg2dp_d0_bn_bypass
  ) begin
    reg2dp_bn_bypass = dp2reg_consumer ? reg2dp_d1_bn_bypass : reg2dp_d0_bn_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_mul_bypass
  or reg2dp_d0_bn_mul_bypass
  ) begin
    reg2dp_bn_mul_bypass = dp2reg_consumer ? reg2dp_d1_bn_mul_bypass : reg2dp_d0_bn_mul_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_mul_prelu
  or reg2dp_d0_bn_mul_prelu
  ) begin
    reg2dp_bn_mul_prelu = dp2reg_consumer ? reg2dp_d1_bn_mul_prelu : reg2dp_d0_bn_mul_prelu;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_relu_bypass
  or reg2dp_d0_bn_relu_bypass
  ) begin
    reg2dp_bn_relu_bypass = dp2reg_consumer ? reg2dp_d1_bn_relu_bypass : reg2dp_d0_bn_relu_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_mul_shift_value
  or reg2dp_d0_bn_mul_shift_value
  ) begin
    reg2dp_bn_mul_shift_value = dp2reg_consumer ? reg2dp_d1_bn_mul_shift_value : reg2dp_d0_bn_mul_shift_value;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_mul_src
  or reg2dp_d0_bn_mul_src
  ) begin
    reg2dp_bn_mul_src = dp2reg_consumer ? reg2dp_d1_bn_mul_src : reg2dp_d0_bn_mul_src;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bn_mul_operand
  or reg2dp_d0_bn_mul_operand
  ) begin
    reg2dp_bn_mul_operand = dp2reg_consumer ? reg2dp_d1_bn_mul_operand : reg2dp_d0_bn_mul_operand;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_alu_shift_value
  or reg2dp_d0_bs_alu_shift_value
  ) begin
    reg2dp_bs_alu_shift_value = dp2reg_consumer ? reg2dp_d1_bs_alu_shift_value : reg2dp_d0_bs_alu_shift_value;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_alu_src
  or reg2dp_d0_bs_alu_src
  ) begin
    reg2dp_bs_alu_src = dp2reg_consumer ? reg2dp_d1_bs_alu_src : reg2dp_d0_bs_alu_src;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_alu_operand
  or reg2dp_d0_bs_alu_operand
  ) begin
    reg2dp_bs_alu_operand = dp2reg_consumer ? reg2dp_d1_bs_alu_operand : reg2dp_d0_bs_alu_operand;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_alu_algo
  or reg2dp_d0_bs_alu_algo
  ) begin
    reg2dp_bs_alu_algo = dp2reg_consumer ? reg2dp_d1_bs_alu_algo : reg2dp_d0_bs_alu_algo;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_alu_bypass
  or reg2dp_d0_bs_alu_bypass
  ) begin
    reg2dp_bs_alu_bypass = dp2reg_consumer ? reg2dp_d1_bs_alu_bypass : reg2dp_d0_bs_alu_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_bypass
  or reg2dp_d0_bs_bypass
  ) begin
    reg2dp_bs_bypass = dp2reg_consumer ? reg2dp_d1_bs_bypass : reg2dp_d0_bs_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_mul_bypass
  or reg2dp_d0_bs_mul_bypass
  ) begin
    reg2dp_bs_mul_bypass = dp2reg_consumer ? reg2dp_d1_bs_mul_bypass : reg2dp_d0_bs_mul_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_mul_prelu
  or reg2dp_d0_bs_mul_prelu
  ) begin
    reg2dp_bs_mul_prelu = dp2reg_consumer ? reg2dp_d1_bs_mul_prelu : reg2dp_d0_bs_mul_prelu;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_relu_bypass
  or reg2dp_d0_bs_relu_bypass
  ) begin
    reg2dp_bs_relu_bypass = dp2reg_consumer ? reg2dp_d1_bs_relu_bypass : reg2dp_d0_bs_relu_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_mul_shift_value
  or reg2dp_d0_bs_mul_shift_value
  ) begin
    reg2dp_bs_mul_shift_value = dp2reg_consumer ? reg2dp_d1_bs_mul_shift_value : reg2dp_d0_bs_mul_shift_value;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_mul_src
  or reg2dp_d0_bs_mul_src
  ) begin
    reg2dp_bs_mul_src = dp2reg_consumer ? reg2dp_d1_bs_mul_src : reg2dp_d0_bs_mul_src;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_bs_mul_operand
  or reg2dp_d0_bs_mul_operand
  ) begin
    reg2dp_bs_mul_operand = dp2reg_consumer ? reg2dp_d1_bs_mul_operand : reg2dp_d0_bs_mul_operand;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_alu_cvt_bypass
  or reg2dp_d0_ew_alu_cvt_bypass
  ) begin
    reg2dp_ew_alu_cvt_bypass = dp2reg_consumer ? reg2dp_d1_ew_alu_cvt_bypass : reg2dp_d0_ew_alu_cvt_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_alu_src
  or reg2dp_d0_ew_alu_src
  ) begin
    reg2dp_ew_alu_src = dp2reg_consumer ? reg2dp_d1_ew_alu_src : reg2dp_d0_ew_alu_src;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_alu_cvt_offset
  or reg2dp_d0_ew_alu_cvt_offset
  ) begin
    reg2dp_ew_alu_cvt_offset = dp2reg_consumer ? reg2dp_d1_ew_alu_cvt_offset : reg2dp_d0_ew_alu_cvt_offset;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_alu_cvt_scale
  or reg2dp_d0_ew_alu_cvt_scale
  ) begin
    reg2dp_ew_alu_cvt_scale = dp2reg_consumer ? reg2dp_d1_ew_alu_cvt_scale : reg2dp_d0_ew_alu_cvt_scale;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_alu_cvt_truncate
  or reg2dp_d0_ew_alu_cvt_truncate
  ) begin
    reg2dp_ew_alu_cvt_truncate = dp2reg_consumer ? reg2dp_d1_ew_alu_cvt_truncate : reg2dp_d0_ew_alu_cvt_truncate;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_alu_operand
  or reg2dp_d0_ew_alu_operand
  ) begin
    reg2dp_ew_alu_operand = dp2reg_consumer ? reg2dp_d1_ew_alu_operand : reg2dp_d0_ew_alu_operand;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_alu_algo
  or reg2dp_d0_ew_alu_algo
  ) begin
    reg2dp_ew_alu_algo = dp2reg_consumer ? reg2dp_d1_ew_alu_algo : reg2dp_d0_ew_alu_algo;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_alu_bypass
  or reg2dp_d0_ew_alu_bypass
  ) begin
    reg2dp_ew_alu_bypass = dp2reg_consumer ? reg2dp_d1_ew_alu_bypass : reg2dp_d0_ew_alu_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_bypass
  or reg2dp_d0_ew_bypass
  ) begin
    reg2dp_ew_bypass = dp2reg_consumer ? reg2dp_d1_ew_bypass : reg2dp_d0_ew_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_lut_bypass
  or reg2dp_d0_ew_lut_bypass
  ) begin
    reg2dp_ew_lut_bypass = dp2reg_consumer ? reg2dp_d1_ew_lut_bypass : reg2dp_d0_ew_lut_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_mul_bypass
  or reg2dp_d0_ew_mul_bypass
  ) begin
    reg2dp_ew_mul_bypass = dp2reg_consumer ? reg2dp_d1_ew_mul_bypass : reg2dp_d0_ew_mul_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_mul_prelu
  or reg2dp_d0_ew_mul_prelu
  ) begin
    reg2dp_ew_mul_prelu = dp2reg_consumer ? reg2dp_d1_ew_mul_prelu : reg2dp_d0_ew_mul_prelu;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_mul_cvt_bypass
  or reg2dp_d0_ew_mul_cvt_bypass
  ) begin
    reg2dp_ew_mul_cvt_bypass = dp2reg_consumer ? reg2dp_d1_ew_mul_cvt_bypass : reg2dp_d0_ew_mul_cvt_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_mul_src
  or reg2dp_d0_ew_mul_src
  ) begin
    reg2dp_ew_mul_src = dp2reg_consumer ? reg2dp_d1_ew_mul_src : reg2dp_d0_ew_mul_src;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_mul_cvt_offset
  or reg2dp_d0_ew_mul_cvt_offset
  ) begin
    reg2dp_ew_mul_cvt_offset = dp2reg_consumer ? reg2dp_d1_ew_mul_cvt_offset : reg2dp_d0_ew_mul_cvt_offset;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_mul_cvt_scale
  or reg2dp_d0_ew_mul_cvt_scale
  ) begin
    reg2dp_ew_mul_cvt_scale = dp2reg_consumer ? reg2dp_d1_ew_mul_cvt_scale : reg2dp_d0_ew_mul_cvt_scale;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_mul_cvt_truncate
  or reg2dp_d0_ew_mul_cvt_truncate
  ) begin
    reg2dp_ew_mul_cvt_truncate = dp2reg_consumer ? reg2dp_d1_ew_mul_cvt_truncate : reg2dp_d0_ew_mul_cvt_truncate;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_mul_operand
  or reg2dp_d0_ew_mul_operand
  ) begin
    reg2dp_ew_mul_operand = dp2reg_consumer ? reg2dp_d1_ew_mul_operand : reg2dp_d0_ew_mul_operand;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_ew_truncate
  or reg2dp_d0_ew_truncate
  ) begin
    reg2dp_ew_truncate = dp2reg_consumer ? reg2dp_d1_ew_truncate : reg2dp_d0_ew_truncate;
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
  or reg2dp_d1_dst_batch_stride
  or reg2dp_d0_dst_batch_stride
  ) begin
    reg2dp_dst_batch_stride = dp2reg_consumer ? reg2dp_d1_dst_batch_stride : reg2dp_d0_dst_batch_stride;
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
  or reg2dp_d1_dst_line_stride
  or reg2dp_d0_dst_line_stride
  ) begin
    reg2dp_dst_line_stride = dp2reg_consumer ? reg2dp_d1_dst_line_stride : reg2dp_d0_dst_line_stride;
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
  or reg2dp_d1_nan_to_zero
  or reg2dp_d0_nan_to_zero
  ) begin
    reg2dp_nan_to_zero = dp2reg_consumer ? reg2dp_d1_nan_to_zero : reg2dp_d0_nan_to_zero;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_output_dst
  or reg2dp_d0_output_dst
  ) begin
    reg2dp_output_dst = dp2reg_consumer ? reg2dp_d1_output_dst : reg2dp_d0_output_dst;
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
  or reg2dp_d1_perf_dma_en
  or reg2dp_d0_perf_dma_en
  ) begin
    reg2dp_perf_dma_en = dp2reg_consumer ? reg2dp_d1_perf_dma_en : reg2dp_d0_perf_dma_en;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_perf_lut_en
  or reg2dp_d0_perf_lut_en
  ) begin
    reg2dp_perf_lut_en = dp2reg_consumer ? reg2dp_d1_perf_lut_en : reg2dp_d0_perf_lut_en;
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
  or reg2dp_d1_perf_sat_en
  or reg2dp_d0_perf_sat_en
  ) begin
    reg2dp_perf_sat_en = dp2reg_consumer ? reg2dp_d1_perf_sat_en : reg2dp_d0_perf_sat_en;
end

////////////////////////////////////////////////////////////////////////
//                                                                    //
// PASTE ADDIFITON LOGIC HERE FROM EXTRA FILE                         //
//                                                                    //
////////////////////////////////////////////////////////////////////////
//
// DO NOT EDIT - generated by simspec!
//

// ifndef ___ARNVDLA_VH_INC_
//assign reg2dp_lut_data = reg_wr_data[::range(15)];
assign reg2dp_interrupt_ptr = dp2reg_consumer;

//===================================================
//////// Single Flop Write Control////////
//===================================================

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lut_int_addr_trigger <= 1'b0;
  end else begin
  lut_int_addr_trigger <= reg2dp_lut_addr_trigger;
  end
end
//assign reg2dp_lut_int_addr_trigger = lut_int_addr_trigger;

assign lut_int_data_rd_trigger = reg_rd_en & ( {20'h0,reg_offset[11:0]}==(32'hb00c  & 32'h00000fff));
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lut_int_data_wr_trigger <= 1'b0;
  end else begin
  lut_int_data_wr_trigger <= reg2dp_lut_data_trigger;
  end
end
//assign reg2dp_lut_int_data_wr = lut_int_data_wr_trigger && (lut_int_access_type==NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_TYPE_WRITE);
assign reg2dp_lut_int_data_wr = lut_int_data_wr_trigger;

assign reg2dp_lut_int_addr = lut_int_addr;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lut_int_addr <= {10{1'b0}};
  end else begin
    if (lut_int_addr_trigger) begin
        lut_int_addr <= reg2dp_lut_addr;
    end else if (lut_int_data_wr_trigger || lut_int_data_rd_trigger) begin
        lut_int_addr <= lut_int_addr + 1'b1;
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
  // VCS coverage off 
  nv_assert_never #(0,0,"WRITE on LUT_ADDR need be NPOST before LUT_DATA READ")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, lut_int_data_rd_trigger & lut_int_addr_trigger); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
    lut_int_access_type <= 1'b0;
  end else begin
  if ((lut_int_addr_trigger) == 1'b1) begin
    lut_int_access_type <= reg2dp_lut_access_type;
  // VCS coverage off
  end else if ((lut_int_addr_trigger) == 1'b0) begin
  end else begin
    lut_int_access_type <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lut_int_addr_trigger))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign reg2dp_lut_int_access_type = lut_int_access_type;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lut_int_table_id <= 1'b0;
  end else begin
  if ((lut_int_addr_trigger) == 1'b1) begin
    lut_int_table_id <= reg2dp_lut_table_id;
  // VCS coverage off
  end else if ((lut_int_addr_trigger) == 1'b0) begin
  end else begin
    lut_int_table_id <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lut_int_addr_trigger))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign reg2dp_lut_int_table_id = lut_int_table_id;

always @(posedge nvdla_core_clk) begin
    if (reg2dp_lut_data_trigger) begin
        reg2dp_lut_int_data <= s_reg_wr_data[15:0];
    end
end
assign dp2reg_lut_data = dp2reg_lut_int_data[15:0];

assign wdma_slcg_op_en  = slcg_op_en[0];
assign bcore_slcg_op_en = slcg_op_en[1];
assign ncore_slcg_op_en = slcg_op_en[2];
assign ecore_slcg_op_en = slcg_op_en[3];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_lut_slcg_en <= 1'b0;
  end else begin
    if (reg2dp_lut_addr_trigger) begin
        reg2dp_lut_slcg_en <= 1'b1;
    end else if (ecore_slcg_op_en) begin
        reg2dp_lut_slcg_en <= 1'b0;
    end
  end
end
assign reg2dp_wdma_slcg_op_en  = wdma_slcg_op_en;
assign reg2dp_bcore_slcg_op_en = bcore_slcg_op_en;
assign reg2dp_ncore_slcg_op_en = ncore_slcg_op_en;
assign reg2dp_ecore_slcg_op_en = ecore_slcg_op_en;

//===================================================
//////// Dual Flop Write Control////////
//===================================================
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
assign dp2reg_d0_lut_oflow_w = (dp2reg_d0_set) ? dp2reg_lut_oflow[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_lut_oflow;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_lut_oflow <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_lut_oflow <= dp2reg_d0_lut_oflow_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_lut_oflow <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
assign dp2reg_d0_lut_uflow_w = (dp2reg_d0_set) ? dp2reg_lut_uflow[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_lut_uflow;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_lut_uflow <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_lut_uflow <= dp2reg_d0_lut_uflow_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_lut_uflow <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
assign dp2reg_d0_wdma_stall_w = (dp2reg_d0_set) ? dp2reg_wdma_stall[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_wdma_stall;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_wdma_stall <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_wdma_stall <= dp2reg_d0_wdma_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_wdma_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d0_out_saturation_w = (dp2reg_d0_set) ? dp2reg_out_saturation[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_out_saturation;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_out_saturation <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_out_saturation <= dp2reg_d0_out_saturation_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_out_saturation <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d0_status_nan_output_num_w = (dp2reg_d0_set) ? dp2reg_status_nan_output_num[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_status_nan_output_num;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_status_nan_output_num <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_status_nan_output_num <= dp2reg_d0_status_nan_output_num_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_status_nan_output_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
assign dp2reg_d0_lut_le_hit_w = (dp2reg_d0_set) ? dp2reg_lut_le_hit[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_lut_le_hit;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_lut_le_hit <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_lut_le_hit <= dp2reg_d0_lut_le_hit_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_lut_le_hit <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
assign dp2reg_d0_status_unequal_w = (dp2reg_d0_set) ? dp2reg_status_unequal[0:0] :
                                  (dp2reg_d0_clr) ? 1'd0 :
                                   dp2reg_d0_status_unequal;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_status_unequal <= 1'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_status_unequal <= dp2reg_d0_status_unequal_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_status_unequal <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
assign dp2reg_d0_lut_hybrid_w = (dp2reg_d0_set) ? dp2reg_lut_hybrid[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_lut_hybrid;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_lut_hybrid <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_lut_hybrid <= dp2reg_d0_lut_hybrid_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_lut_hybrid <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d0_lut_lo_hit_w = (dp2reg_d0_set) ? dp2reg_lut_lo_hit[31:0] :
                                  (dp2reg_d0_clr) ? 32'd0 :
                                   dp2reg_d0_lut_lo_hit;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_lut_lo_hit <= 32'd0;
  end else begin
  if ((dp2reg_d0_reg) == 1'b1) begin
    dp2reg_d0_lut_lo_hit <= dp2reg_d0_lut_lo_hit_w;
  // VCS coverage off
  end else if ((dp2reg_d0_reg) == 1'b0) begin
  end else begin
    dp2reg_d0_lut_lo_hit <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d0_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d1_lut_oflow_w = (dp2reg_d1_set) ? dp2reg_lut_oflow[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_lut_oflow;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_lut_oflow <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_lut_oflow <= dp2reg_d1_lut_oflow_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_lut_oflow <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
assign dp2reg_d1_lut_uflow_w = (dp2reg_d1_set) ? dp2reg_lut_uflow[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_lut_uflow;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_lut_uflow <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_lut_uflow <= dp2reg_d1_lut_uflow_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_lut_uflow <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
assign dp2reg_d1_wdma_stall_w = (dp2reg_d1_set) ? dp2reg_wdma_stall[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_wdma_stall;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_wdma_stall <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_wdma_stall <= dp2reg_d1_wdma_stall_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_wdma_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d1_out_saturation_w = (dp2reg_d1_set) ? dp2reg_out_saturation[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_out_saturation;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_out_saturation <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_out_saturation <= dp2reg_d1_out_saturation_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_out_saturation <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d1_status_nan_output_num_w = (dp2reg_d1_set) ? dp2reg_status_nan_output_num[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_status_nan_output_num;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_status_nan_output_num <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_status_nan_output_num <= dp2reg_d1_status_nan_output_num_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_status_nan_output_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d1_lut_le_hit_w = (dp2reg_d1_set) ? dp2reg_lut_le_hit[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_lut_le_hit;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_lut_le_hit <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_lut_le_hit <= dp2reg_d1_lut_le_hit_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_lut_le_hit <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d1_status_unequal_w = (dp2reg_d1_set) ? dp2reg_status_unequal[0:0] :
                                  (dp2reg_d1_clr) ? 1'd0 :
                                   dp2reg_d1_status_unequal;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_status_unequal <= 1'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_status_unequal <= dp2reg_d1_status_unequal_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_status_unequal <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d1_lut_hybrid_w = (dp2reg_d1_set) ? dp2reg_lut_hybrid[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_lut_hybrid;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_lut_hybrid <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_lut_hybrid <= dp2reg_d1_lut_hybrid_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_lut_hybrid <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dp2reg_d1_lut_lo_hit_w = (dp2reg_d1_set) ? dp2reg_lut_lo_hit[31:0] :
                                  (dp2reg_d1_clr) ? 32'd0 :
                                   dp2reg_d1_lut_lo_hit;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_lut_lo_hit <= 32'd0;
  end else begin
  if ((dp2reg_d1_reg) == 1'b1) begin
    dp2reg_d1_lut_lo_hit <= dp2reg_d1_lut_lo_hit_w;
  // VCS coverage off
  end else if ((dp2reg_d1_reg) == 1'b0) begin
  end else begin
    dp2reg_d1_lut_lo_hit <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_d1_reg))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_reg

