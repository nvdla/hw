// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_reg.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CDP_reg (
   nvdla_core_clk                  //|< i
  ,nvdla_core_rstn                 //|< i
  ,csb2cdp_req_pd                  //|< i
  ,csb2cdp_req_pvld                //|< i
  ,dp2reg_d0_out_saturation        //|< i
  ,dp2reg_d0_perf_lut_hybrid       //|< i
  ,dp2reg_d0_perf_lut_le_hit       //|< i
  ,dp2reg_d0_perf_lut_lo_hit       //|< i
  ,dp2reg_d0_perf_lut_oflow        //|< i
  ,dp2reg_d0_perf_lut_uflow        //|< i
  ,dp2reg_d0_perf_write_stall      //|< i
  ,dp2reg_d1_out_saturation        //|< i
  ,dp2reg_d1_perf_lut_hybrid       //|< i
  ,dp2reg_d1_perf_lut_le_hit       //|< i
  ,dp2reg_d1_perf_lut_lo_hit       //|< i
  ,dp2reg_d1_perf_lut_oflow        //|< i
  ,dp2reg_d1_perf_lut_uflow        //|< i
  ,dp2reg_d1_perf_write_stall      //|< i
  ,dp2reg_done                     //|< i
  ,dp2reg_inf_input_num            //|< i
  ,dp2reg_lut_data                 //|< i
  ,dp2reg_nan_input_num            //|< i
  ,dp2reg_nan_output_num           //|< i
  ,cdp2csb_resp_pd                 //|> o
  ,cdp2csb_resp_valid              //|> o
  ,csb2cdp_req_prdy                //|> o
  ,reg2dp_cya                      //|> o
  ,reg2dp_datin_offset             //|> o
  ,reg2dp_datin_scale              //|> o
  ,reg2dp_datin_shifter            //|> o
  ,reg2dp_datout_offset            //|> o
  ,reg2dp_datout_scale             //|> o
  ,reg2dp_datout_shifter           //|> o
  ,reg2dp_dma_en                   //|> o
  ,reg2dp_dst_base_addr_high       //|> o
  ,reg2dp_dst_base_addr_low        //|> o
  ,reg2dp_dst_line_stride          //|> o
  ,reg2dp_dst_ram_type             //|> o
  ,reg2dp_dst_surface_stride       //|> o
  ,reg2dp_input_data_type          //|> o
  ,reg2dp_interrupt_ptr            //|> o
  ,reg2dp_lut_access_type          //|> o
  ,reg2dp_lut_addr                 //|> o
  ,reg2dp_lut_data                 //|> o
  ,reg2dp_lut_data_trigger         //|> o
  ,reg2dp_lut_en                   //|> o
  ,reg2dp_lut_hybrid_priority      //|> o
  ,reg2dp_lut_le_end_high          //|> o
  ,reg2dp_lut_le_end_low           //|> o
  ,reg2dp_lut_le_function          //|> o
  ,reg2dp_lut_le_index_offset      //|> o
  ,reg2dp_lut_le_index_select      //|> o
  ,reg2dp_lut_le_slope_oflow_scale //|> o
  ,reg2dp_lut_le_slope_oflow_shift //|> o
  ,reg2dp_lut_le_slope_uflow_scale //|> o
  ,reg2dp_lut_le_slope_uflow_shift //|> o
  ,reg2dp_lut_le_start_high        //|> o
  ,reg2dp_lut_le_start_low         //|> o
  ,reg2dp_lut_lo_end_high          //|> o
  ,reg2dp_lut_lo_end_low           //|> o
  ,reg2dp_lut_lo_index_select      //|> o
  ,reg2dp_lut_lo_slope_oflow_scale //|> o
  ,reg2dp_lut_lo_slope_oflow_shift //|> o
  ,reg2dp_lut_lo_slope_uflow_scale //|> o
  ,reg2dp_lut_lo_slope_uflow_shift //|> o
  ,reg2dp_lut_lo_start_high        //|> o
  ,reg2dp_lut_lo_start_low         //|> o
  ,reg2dp_lut_oflow_priority       //|> o
  ,reg2dp_lut_table_id             //|> o
  ,reg2dp_lut_uflow_priority       //|> o
  ,reg2dp_mul_bypass               //|> o
  ,reg2dp_nan_to_zero              //|> o
  ,reg2dp_normalz_len              //|> o
  ,reg2dp_op_en                    //|> o
  ,reg2dp_sqsum_bypass             //|> o
  ,slcg_op_en                      //|> o
  );


input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [62:0] csb2cdp_req_pd;
input         csb2cdp_req_pvld;
input  [31:0] dp2reg_d0_out_saturation;
input  [31:0] dp2reg_d0_perf_lut_hybrid;
input  [31:0] dp2reg_d0_perf_lut_le_hit;
input  [31:0] dp2reg_d0_perf_lut_lo_hit;
input  [31:0] dp2reg_d0_perf_lut_oflow;
input  [31:0] dp2reg_d0_perf_lut_uflow;
input  [31:0] dp2reg_d0_perf_write_stall;
input  [31:0] dp2reg_d1_out_saturation;
input  [31:0] dp2reg_d1_perf_lut_hybrid;
input  [31:0] dp2reg_d1_perf_lut_le_hit;
input  [31:0] dp2reg_d1_perf_lut_lo_hit;
input  [31:0] dp2reg_d1_perf_lut_oflow;
input  [31:0] dp2reg_d1_perf_lut_uflow;
input  [31:0] dp2reg_d1_perf_write_stall;
input         dp2reg_done;
input  [31:0] dp2reg_inf_input_num;
input  [15:0] dp2reg_lut_data;
input  [31:0] dp2reg_nan_input_num;
input  [31:0] dp2reg_nan_output_num;
output [33:0] cdp2csb_resp_pd;
output        cdp2csb_resp_valid;
output        csb2cdp_req_prdy;
output [31:0] reg2dp_cya;
output [15:0] reg2dp_datin_offset;
output [15:0] reg2dp_datin_scale;
output  [4:0] reg2dp_datin_shifter;
output [31:0] reg2dp_datout_offset;
output [15:0] reg2dp_datout_scale;
output  [5:0] reg2dp_datout_shifter;
output        reg2dp_dma_en;
output [31:0] reg2dp_dst_base_addr_high;
output [26:0] reg2dp_dst_base_addr_low;
output [26:0] reg2dp_dst_line_stride;
output        reg2dp_dst_ram_type;
output [26:0] reg2dp_dst_surface_stride;
output  [1:0] reg2dp_input_data_type;
output        reg2dp_interrupt_ptr;
output        reg2dp_lut_access_type;
output  [9:0] reg2dp_lut_addr;
output [15:0] reg2dp_lut_data;
output        reg2dp_lut_data_trigger;
output        reg2dp_lut_en;
output        reg2dp_lut_hybrid_priority;
output  [5:0] reg2dp_lut_le_end_high;
output [31:0] reg2dp_lut_le_end_low;
output        reg2dp_lut_le_function;
output  [7:0] reg2dp_lut_le_index_offset;
output  [7:0] reg2dp_lut_le_index_select;
output [15:0] reg2dp_lut_le_slope_oflow_scale;
output  [4:0] reg2dp_lut_le_slope_oflow_shift;
output [15:0] reg2dp_lut_le_slope_uflow_scale;
output  [4:0] reg2dp_lut_le_slope_uflow_shift;
output  [5:0] reg2dp_lut_le_start_high;
output [31:0] reg2dp_lut_le_start_low;
output  [5:0] reg2dp_lut_lo_end_high;
output [31:0] reg2dp_lut_lo_end_low;
output  [7:0] reg2dp_lut_lo_index_select;
output [15:0] reg2dp_lut_lo_slope_oflow_scale;
output  [4:0] reg2dp_lut_lo_slope_oflow_shift;
output [15:0] reg2dp_lut_lo_slope_uflow_scale;
output  [4:0] reg2dp_lut_lo_slope_uflow_shift;
output  [5:0] reg2dp_lut_lo_start_high;
output [31:0] reg2dp_lut_lo_start_low;
output        reg2dp_lut_oflow_priority;
output        reg2dp_lut_table_id;
output        reg2dp_lut_uflow_priority;
output        reg2dp_mul_bypass;
output        reg2dp_nan_to_zero;
output  [1:0] reg2dp_normalz_len;
output        reg2dp_op_en;
output        reg2dp_sqsum_bypass;
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
wire          lut_end;
wire   [31:0] reg2dp_d0_cya;
wire   [15:0] reg2dp_d0_datin_offset;
wire   [15:0] reg2dp_d0_datin_scale;
wire    [4:0] reg2dp_d0_datin_shifter;
wire   [31:0] reg2dp_d0_datout_offset;
wire   [15:0] reg2dp_d0_datout_scale;
wire    [5:0] reg2dp_d0_datout_shifter;
wire          reg2dp_d0_dma_en;
wire   [31:0] reg2dp_d0_dst_base_addr_high;
wire   [26:0] reg2dp_d0_dst_base_addr_low;
wire   [26:0] reg2dp_d0_dst_line_stride;
wire          reg2dp_d0_dst_ram_type;
wire   [26:0] reg2dp_d0_dst_surface_stride;
wire    [1:0] reg2dp_d0_input_data_type;
wire          reg2dp_d0_lut_en;
wire          reg2dp_d0_mul_bypass;
wire          reg2dp_d0_nan_to_zero;
wire    [1:0] reg2dp_d0_normalz_len;
wire          reg2dp_d0_op_en_trigger;
wire          reg2dp_d0_sqsum_bypass;
wire   [31:0] reg2dp_d1_cya;
wire   [15:0] reg2dp_d1_datin_offset;
wire   [15:0] reg2dp_d1_datin_scale;
wire    [4:0] reg2dp_d1_datin_shifter;
wire   [31:0] reg2dp_d1_datout_offset;
wire   [15:0] reg2dp_d1_datout_scale;
wire    [5:0] reg2dp_d1_datout_shifter;
wire          reg2dp_d1_dma_en;
wire   [31:0] reg2dp_d1_dst_base_addr_high;
wire   [26:0] reg2dp_d1_dst_base_addr_low;
wire   [26:0] reg2dp_d1_dst_line_stride;
wire          reg2dp_d1_dst_ram_type;
wire   [26:0] reg2dp_d1_dst_surface_stride;
wire    [1:0] reg2dp_d1_input_data_type;
wire          reg2dp_d1_lut_en;
wire          reg2dp_d1_mul_bypass;
wire          reg2dp_d1_nan_to_zero;
wire    [1:0] reg2dp_d1_normalz_len;
wire          reg2dp_d1_op_en_trigger;
wire          reg2dp_d1_sqsum_bypass;
wire          reg2dp_lut_addr_trigger;
wire          reg2dp_lut_data_rd_trigger;
wire          reg2dp_lut_data_wr_trigger;
wire    [2:0] reg2dp_op_en_reg_w;
wire          reg2dp_producer;
wire   [23:0] reg_offset;
wire   [31:0] reg_offset_wr;
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
reg    [33:0] cdp2csb_resp_pd;
reg           cdp2csb_resp_valid;
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
reg     [9:0] dp2reg_lut_addr;
reg     [1:0] dp2reg_status_0;
reg     [1:0] dp2reg_status_1;
reg    [31:0] reg2dp_cya;
reg           reg2dp_d0_op_en;
reg           reg2dp_d0_op_en_w;
reg           reg2dp_d1_op_en;
reg           reg2dp_d1_op_en_w;
reg    [15:0] reg2dp_datin_offset;
reg    [15:0] reg2dp_datin_scale;
reg     [4:0] reg2dp_datin_shifter;
reg    [31:0] reg2dp_datout_offset;
reg    [15:0] reg2dp_datout_scale;
reg     [5:0] reg2dp_datout_shifter;
reg           reg2dp_dma_en;
reg    [31:0] reg2dp_dst_base_addr_high;
reg    [26:0] reg2dp_dst_base_addr_low;
reg    [26:0] reg2dp_dst_line_stride;
reg           reg2dp_dst_ram_type;
reg    [26:0] reg2dp_dst_surface_stride;
reg     [1:0] reg2dp_input_data_type;
reg           reg2dp_lut_en;
reg           reg2dp_mul_bypass;
reg           reg2dp_nan_to_zero;
reg     [1:0] reg2dp_normalz_len;
reg           reg2dp_op_en_ori;
reg     [2:0] reg2dp_op_en_reg;
reg           reg2dp_sqsum_bypass;
reg    [62:0] req_pd;
reg           req_pvld;
reg     [3:0] slcg_op_en_d1;
reg     [3:0] slcg_op_en_d2;
reg     [3:0] slcg_op_en_d3;


//Instance single register group
NV_NVDLA_CDP_REG_single u_single_reg (
   .reg_rd_data              (s_reg_rd_data[31:0])                   //|> w
  ,.reg_offset               (s_reg_offset[11:0])                    //|< w
  ,.reg_wr_data              (s_reg_wr_data[31:0])                   //|< w
  ,.reg_wr_en                (s_reg_wr_en)                           //|< w
  ,.nvdla_core_clk           (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)                       //|< i
  ,.lut_access_type          (reg2dp_lut_access_type)                //|> o
  ,.lut_addr_trigger         (reg2dp_lut_addr_trigger)               //|> w
  ,.lut_table_id             (reg2dp_lut_table_id)                   //|> o
  ,.lut_data_trigger         (reg2dp_lut_data_trigger)               //|> o
  ,.lut_hybrid_priority      (reg2dp_lut_hybrid_priority)            //|> o
  ,.lut_le_function          (reg2dp_lut_le_function)                //|> o
  ,.lut_oflow_priority       (reg2dp_lut_oflow_priority)             //|> o
  ,.lut_uflow_priority       (reg2dp_lut_uflow_priority)             //|> o
  ,.lut_le_index_offset      (reg2dp_lut_le_index_offset[7:0])       //|> o
  ,.lut_le_index_select      (reg2dp_lut_le_index_select[7:0])       //|> o
  ,.lut_lo_index_select      (reg2dp_lut_lo_index_select[7:0])       //|> o
  ,.lut_le_end_high          (reg2dp_lut_le_end_high[5:0])           //|> o
  ,.lut_le_end_low           (reg2dp_lut_le_end_low[31:0])           //|> o
  ,.lut_le_slope_oflow_scale (reg2dp_lut_le_slope_oflow_scale[15:0]) //|> o
  ,.lut_le_slope_uflow_scale (reg2dp_lut_le_slope_uflow_scale[15:0]) //|> o
  ,.lut_le_slope_oflow_shift (reg2dp_lut_le_slope_oflow_shift[4:0])  //|> o
  ,.lut_le_slope_uflow_shift (reg2dp_lut_le_slope_uflow_shift[4:0])  //|> o
  ,.lut_le_start_high        (reg2dp_lut_le_start_high[5:0])         //|> o
  ,.lut_le_start_low         (reg2dp_lut_le_start_low[31:0])         //|> o
  ,.lut_lo_end_high          (reg2dp_lut_lo_end_high[5:0])           //|> o
  ,.lut_lo_end_low           (reg2dp_lut_lo_end_low[31:0])           //|> o
  ,.lut_lo_slope_oflow_scale (reg2dp_lut_lo_slope_oflow_scale[15:0]) //|> o
  ,.lut_lo_slope_uflow_scale (reg2dp_lut_lo_slope_uflow_scale[15:0]) //|> o
  ,.lut_lo_slope_oflow_shift (reg2dp_lut_lo_slope_oflow_shift[4:0])  //|> o
  ,.lut_lo_slope_uflow_shift (reg2dp_lut_lo_slope_uflow_shift[4:0])  //|> o
  ,.lut_lo_start_high        (reg2dp_lut_lo_start_high[5:0])         //|> o
  ,.lut_lo_start_low         (reg2dp_lut_lo_start_low[31:0])         //|> o
  ,.producer                 (reg2dp_producer)                       //|> w
  ,.lut_addr                 (dp2reg_lut_addr[9:0])                  //|< r
  ,.lut_data                 (dp2reg_lut_data[15:0])                 //|< i
  ,.consumer                 (dp2reg_consumer)                       //|< r
  ,.status_0                 (dp2reg_status_0[1:0])                  //|< r
  ,.status_1                 (dp2reg_status_1[1:0])                  //|< r
  );

//Instance two duplicated register groups

NV_NVDLA_CDP_REG_dual u_dual_reg_d0 (
   .reg_rd_data              (d0_reg_rd_data[31:0])                  //|> w
  ,.reg_offset               (d0_reg_offset[11:0])                   //|< w
  ,.reg_wr_data              (d0_reg_wr_data[31:0])                  //|< w
  ,.reg_wr_en                (d0_reg_wr_en)                          //|< w
  ,.nvdla_core_clk           (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)                       //|< i
  ,.cya                      (reg2dp_d0_cya[31:0])                   //|> w
  ,.input_data_type          (reg2dp_d0_input_data_type[1:0])        //|> w
  ,.datin_offset             (reg2dp_d0_datin_offset[15:0])          //|> w
  ,.datin_scale              (reg2dp_d0_datin_scale[15:0])           //|> w
  ,.datin_shifter            (reg2dp_d0_datin_shifter[4:0])          //|> w
  ,.datout_offset            (reg2dp_d0_datout_offset[31:0])         //|> w
  ,.datout_scale             (reg2dp_d0_datout_scale[15:0])          //|> w
  ,.datout_shifter           (reg2dp_d0_datout_shifter[5:0])         //|> w
  ,.dst_base_addr_high       (reg2dp_d0_dst_base_addr_high[31:0])    //|> w
  ,.dst_base_addr_low        (reg2dp_d0_dst_base_addr_low[26:0])     //|> w
  ,.dst_ram_type             (reg2dp_d0_dst_ram_type)                //|> w
  ,.dst_line_stride          (reg2dp_d0_dst_line_stride[26:0])       //|> w
  ,.dst_surface_stride       (reg2dp_d0_dst_surface_stride[26:0])    //|> w
  ,.mul_bypass               (reg2dp_d0_mul_bypass)                  //|> w
  ,.sqsum_bypass             (reg2dp_d0_sqsum_bypass)                //|> w
  ,.normalz_len              (reg2dp_d0_normalz_len[1:0])            //|> w
  ,.nan_to_zero              (reg2dp_d0_nan_to_zero)                 //|> w
  ,.op_en_trigger            (reg2dp_d0_op_en_trigger)               //|> w
  ,.dma_en                   (reg2dp_d0_dma_en)                      //|> w
  ,.lut_en                   (reg2dp_d0_lut_en)                      //|> w
  ,.inf_input_num            (dp2reg_d0_inf_input_num[31:0])         //|< r
  ,.nan_input_num            (dp2reg_d0_nan_input_num[31:0])         //|< r
  ,.nan_output_num           (dp2reg_d0_nan_output_num[31:0])        //|< r
  ,.op_en                    (reg2dp_d0_op_en)                       //|< r
  ,.out_saturation           (dp2reg_d0_out_saturation[31:0])        //|< i
  ,.perf_lut_hybrid          (dp2reg_d0_perf_lut_hybrid[31:0])       //|< i
  ,.perf_lut_le_hit          (dp2reg_d0_perf_lut_le_hit[31:0])       //|< i
  ,.perf_lut_lo_hit          (dp2reg_d0_perf_lut_lo_hit[31:0])       //|< i
  ,.perf_lut_oflow           (dp2reg_d0_perf_lut_oflow[31:0])        //|< i
  ,.perf_lut_uflow           (dp2reg_d0_perf_lut_uflow[31:0])        //|< i
  ,.perf_write_stall         (dp2reg_d0_perf_write_stall[31:0])      //|< i
  );
        
NV_NVDLA_CDP_REG_dual u_dual_reg_d1 (
   .reg_rd_data              (d1_reg_rd_data[31:0])                  //|> w
  ,.reg_offset               (d1_reg_offset[11:0])                   //|< w
  ,.reg_wr_data              (d1_reg_wr_data[31:0])                  //|< w
  ,.reg_wr_en                (d1_reg_wr_en)                          //|< w
  ,.nvdla_core_clk           (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)                       //|< i
  ,.cya                      (reg2dp_d1_cya[31:0])                   //|> w
  ,.input_data_type          (reg2dp_d1_input_data_type[1:0])        //|> w
  ,.datin_offset             (reg2dp_d1_datin_offset[15:0])          //|> w
  ,.datin_scale              (reg2dp_d1_datin_scale[15:0])           //|> w
  ,.datin_shifter            (reg2dp_d1_datin_shifter[4:0])          //|> w
  ,.datout_offset            (reg2dp_d1_datout_offset[31:0])         //|> w
  ,.datout_scale             (reg2dp_d1_datout_scale[15:0])          //|> w
  ,.datout_shifter           (reg2dp_d1_datout_shifter[5:0])         //|> w
  ,.dst_base_addr_high       (reg2dp_d1_dst_base_addr_high[31:0])    //|> w
  ,.dst_base_addr_low        (reg2dp_d1_dst_base_addr_low[26:0])     //|> w
  ,.dst_ram_type             (reg2dp_d1_dst_ram_type)                //|> w
  ,.dst_line_stride          (reg2dp_d1_dst_line_stride[26:0])       //|> w
  ,.dst_surface_stride       (reg2dp_d1_dst_surface_stride[26:0])    //|> w
  ,.mul_bypass               (reg2dp_d1_mul_bypass)                  //|> w
  ,.sqsum_bypass             (reg2dp_d1_sqsum_bypass)                //|> w
  ,.normalz_len              (reg2dp_d1_normalz_len[1:0])            //|> w
  ,.nan_to_zero              (reg2dp_d1_nan_to_zero)                 //|> w
  ,.op_en_trigger            (reg2dp_d1_op_en_trigger)               //|> w
  ,.dma_en                   (reg2dp_d1_dma_en)                      //|> w
  ,.lut_en                   (reg2dp_d1_lut_en)                      //|> w
  ,.inf_input_num            (dp2reg_d1_inf_input_num[31:0])         //|< r
  ,.nan_input_num            (dp2reg_d1_nan_input_num[31:0])         //|< r
  ,.nan_output_num           (dp2reg_d1_nan_output_num[31:0])        //|< r
  ,.op_en                    (reg2dp_d1_op_en)                       //|< r
  ,.out_saturation           (dp2reg_d1_out_saturation[31:0])        //|< i
  ,.perf_lut_hybrid          (dp2reg_d1_perf_lut_hybrid[31:0])       //|< i
  ,.perf_lut_le_hit          (dp2reg_d1_perf_lut_le_hit[31:0])       //|< i
  ,.perf_lut_lo_hit          (dp2reg_d1_perf_lut_lo_hit[31:0])       //|< i
  ,.perf_lut_oflow           (dp2reg_d1_perf_lut_oflow[31:0])        //|< i
  ,.perf_lut_uflow           (dp2reg_d1_perf_lut_uflow[31:0])        //|< i
  ,.perf_write_stall         (dp2reg_d1_perf_write_stall[31:0])      //|< i
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
assign select_s  = (reg_offset[11:0] < (32'hf048  & 32'hfff)) ? 1'b1: 1'b0;
assign select_d0 = (reg_offset[11:0] >= (32'hf048  & 32'hfff)) & (reg2dp_producer == 1'h0 );
assign select_d1 = (reg_offset[11:0] >= (32'hf048  & 32'hfff)) & (reg2dp_producer == 1'h1 );

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
  req_pvld <= csb2cdp_req_pvld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_pd <= {63{1'b0}};
  end else begin
  if ((csb2cdp_req_pvld) == 1'b1) begin
    req_pd <= csb2cdp_req_pd;
  // VCS coverage off
  end else if ((csb2cdp_req_pvld) == 1'b0) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(csb2cdp_req_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign csb2cdp_req_prdy = 1'b1;


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
    cdp2csb_resp_pd <= {34{1'b0}};
  end else begin
    if(reg_rd_en)
    begin
        cdp2csb_resp_pd <= csb_rresp_pd_w;
    end
    else if(reg_wr_en & req_nposted)
    begin
        cdp2csb_resp_pd <= csb_wresp_pd_w;
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdp2csb_resp_valid <= 1'b0;
  end else begin
    cdp2csb_resp_valid <= (reg_wr_en & req_nposted) | reg_rd_en;
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
  or reg2dp_d1_input_data_type
  or reg2dp_d0_input_data_type
  ) begin
    reg2dp_input_data_type = dp2reg_consumer ? reg2dp_d1_input_data_type : reg2dp_d0_input_data_type;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datin_offset
  or reg2dp_d0_datin_offset
  ) begin
    reg2dp_datin_offset = dp2reg_consumer ? reg2dp_d1_datin_offset : reg2dp_d0_datin_offset;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datin_scale
  or reg2dp_d0_datin_scale
  ) begin
    reg2dp_datin_scale = dp2reg_consumer ? reg2dp_d1_datin_scale : reg2dp_d0_datin_scale;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datin_shifter
  or reg2dp_d0_datin_shifter
  ) begin
    reg2dp_datin_shifter = dp2reg_consumer ? reg2dp_d1_datin_shifter : reg2dp_d0_datin_shifter;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datout_offset
  or reg2dp_d0_datout_offset
  ) begin
    reg2dp_datout_offset = dp2reg_consumer ? reg2dp_d1_datout_offset : reg2dp_d0_datout_offset;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datout_scale
  or reg2dp_d0_datout_scale
  ) begin
    reg2dp_datout_scale = dp2reg_consumer ? reg2dp_d1_datout_scale : reg2dp_d0_datout_scale;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datout_shifter
  or reg2dp_d0_datout_shifter
  ) begin
    reg2dp_datout_shifter = dp2reg_consumer ? reg2dp_d1_datout_shifter : reg2dp_d0_datout_shifter;
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
  or reg2dp_d1_mul_bypass
  or reg2dp_d0_mul_bypass
  ) begin
    reg2dp_mul_bypass = dp2reg_consumer ? reg2dp_d1_mul_bypass : reg2dp_d0_mul_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_sqsum_bypass
  or reg2dp_d0_sqsum_bypass
  ) begin
    reg2dp_sqsum_bypass = dp2reg_consumer ? reg2dp_d1_sqsum_bypass : reg2dp_d0_sqsum_bypass;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_normalz_len
  or reg2dp_d0_normalz_len
  ) begin
    reg2dp_normalz_len = dp2reg_consumer ? reg2dp_d1_normalz_len : reg2dp_d0_normalz_len;
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
  or reg2dp_d1_lut_en
  or reg2dp_d0_lut_en
  ) begin
    reg2dp_lut_en = dp2reg_consumer ? reg2dp_d1_lut_en : reg2dp_d0_lut_en;
end

////////////////////////////////////////////////////////////////////////
//                                                                    //
// PASTE ADDIFITON LOGIC HERE FROM EXTRA FILE                         //
//                                                                    //
////////////////////////////////////////////////////////////////////////
assign reg2dp_lut_data = reg_wr_data[15:0];
assign reg2dp_interrupt_ptr = dp2reg_consumer;
//lut_addr generate logic
//   .reg_rd_data             (s_reg_rd_data[31:0])                    //|> w
//  ,.reg_offset              (s_reg_offset[11:0])                     //|< w
//  ,.reg_wr_data             (s_reg_wr_data[31:0])                    //|< w
//  ,.reg_wr_en               (s_reg_wr_en)                            //|< w
//&Always posedge;
//    if(reg2dp_lut_addr_trigger)
//        reg2dp_lut_addr[9:0] <0= s_reg_wr_data[31:0];
//    else if(reg2dp_lut_data_trigger | reg2dp_lut_data_rd_trigger)
//        reg2dp_lut_addr[9:0] <0= reg2dp_lut_addr[9:0] + 1'b1;
//&End;
assign reg_offset_wr = {20'b0 , s_reg_offset[11:0]};
//assign reg2dp_lut_data_wr_trigger = (reg_offset_wr == (32'h1000c  & 32'h00000fff)) & s_reg_wr_en & reg2dp_lut_access_type;  //spyglass disable UnloadedNet-ML //(W528)
assign reg2dp_lut_data_wr_trigger = (reg_offset_wr == (32'h1000c  & 32'h00000fff)) & s_reg_wr_en & (reg2dp_lut_access_type == 1'h1 );  //spyglass disable UnloadedNet-ML //(W528)
//assign reg2dp_lut_data_rd_trigger = (reg_offset_wr == (NVDLA_CDP_S_LUT_ACCESS_DATA_0 & 32'h00000fff)) & (!s_reg_wr_en) & (reg2dp_lut_access_type == NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_TYPE_READ); //spyglass disable UnloadedNet-ML //(W528)
assign reg2dp_lut_data_rd_trigger = (reg_offset_wr == (32'hf00c  & 32'h00000fff)) & (reg_rd_en & select_s) & (reg2dp_lut_access_type == 1'h0 ); //spyglass disable UnloadedNet-ML //(W528)

assign lut_end = (dp2reg_lut_addr == ((reg2dp_lut_table_id)? 10'd256 : 10'd64));
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_lut_addr[9:0] <= {10{1'b0}};
  end else begin
    if(reg2dp_lut_addr_trigger)
        dp2reg_lut_addr[9:0] <= s_reg_wr_data[9:0];
    else if(reg2dp_lut_data_wr_trigger | reg2dp_lut_data_rd_trigger) begin
        if(lut_end)
            dp2reg_lut_addr[9:0] <= dp2reg_lut_addr[9:0];
        else
            dp2reg_lut_addr[9:0] <= dp2reg_lut_addr[9:0] + 1'b1;
    end
  end
end
assign reg2dp_lut_addr[9:0] = dp2reg_lut_addr[9:0];


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

endmodule // NV_NVDLA_CDP_reg

