// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_MRDMA_EG_dout.v

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_MRDMA_EG_dout (
   nvdla_core_clk               //|< i
  ,nvdla_core_rstn              //|< i
  ,cmd2dat_dma_pd               //|< i
  ,cmd2dat_dma_pvld             //|< i
  ,op_load                      //|< i
  ,pfifo0_rd_pd                 //|< i
  ,pfifo0_rd_pvld               //|< i
  ,pfifo1_rd_pd                 //|< i
  ,pfifo1_rd_pvld               //|< i
  ,pfifo2_rd_pd                 //|< i
  ,pfifo2_rd_pvld               //|< i
  ,pfifo3_rd_pd                 //|< i
  ,pfifo3_rd_pvld               //|< i
  ,reg2dp_height                //|< i
  ,reg2dp_in_precision          //|< i
  ,reg2dp_perf_nan_inf_count_en //|< i
  ,reg2dp_proc_precision        //|< i
  ,reg2dp_width                 //|< i
  ,sdp_mrdma2cmux_ready         //|< i
  ,sfifo0_rd_pd                 //|< i
  ,sfifo0_rd_pvld               //|< i
  ,sfifo1_rd_pd                 //|< i
  ,sfifo1_rd_pvld               //|< i
  ,cmd2dat_dma_prdy             //|> o
  ,dp2reg_status_inf_input_num  //|> o
  ,dp2reg_status_nan_input_num  //|> o
  ,eg_done                      //|> o
  ,pfifo0_rd_prdy               //|> o
  ,pfifo1_rd_prdy               //|> o
  ,pfifo2_rd_prdy               //|> o
  ,pfifo3_rd_prdy               //|> o
  ,sdp_mrdma2cmux_pd            //|> o
  ,sdp_mrdma2cmux_valid         //|> o
  ,sfifo0_rd_prdy               //|> o
  ,sfifo1_rd_prdy               //|> o
  );
//
// NV_NVDLA_SDP_MRDMA_EG_dout_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         cmd2dat_dma_pvld;  /* data valid */
output        cmd2dat_dma_prdy;  /* data return handshake */
input  [14:0] cmd2dat_dma_pd;

input          pfifo0_rd_pvld;  /* data valid */
output         pfifo0_rd_prdy;  /* data return handshake */
input  [127:0] pfifo0_rd_pd;

input          pfifo1_rd_pvld;  /* data valid */
output         pfifo1_rd_prdy;  /* data return handshake */
input  [127:0] pfifo1_rd_pd;

input          pfifo2_rd_pvld;  /* data valid */
output         pfifo2_rd_prdy;  /* data return handshake */
input  [127:0] pfifo2_rd_pd;

input          pfifo3_rd_pvld;  /* data valid */
output         pfifo3_rd_prdy;  /* data return handshake */
input  [127:0] pfifo3_rd_pd;

input          sfifo0_rd_pvld;  /* data valid */
output         sfifo0_rd_prdy;  /* data return handshake */
input  [255:0] sfifo0_rd_pd;

input          sfifo1_rd_pvld;  /* data valid */
output         sfifo1_rd_prdy;  /* data return handshake */
input  [255:0] sfifo1_rd_pd;

output         sdp_mrdma2cmux_valid;  /* data valid */
input          sdp_mrdma2cmux_ready;  /* data return handshake */
output [513:0] sdp_mrdma2cmux_pd;

input op_load;
output eg_done;
input   [12:0] reg2dp_height;
input    [1:0] reg2dp_in_precision;
input          reg2dp_perf_nan_inf_count_en;
input    [1:0] reg2dp_proc_precision;
input   [12:0] reg2dp_width;
output  [31:0] dp2reg_status_inf_input_num;
output  [31:0] dp2reg_status_nan_input_num;
//&Ports /^eg2ig/;
reg     [13:0] beat_cnt;
reg            eg_done;
reg     [31:0] inf_input_cnt;
reg     [31:0] nan_input_cnt;
reg    [511:0] pfifo_data_16;
reg    [511:0] pfifo_data_8;
reg    [511:0] sfifo_data;
wire           cfg_di_16;
wire           cfg_di_fp16;
wire           cfg_di_int16;
wire           cfg_di_int8;
wire           cfg_do_int8;
wire           cfg_mode_16to8;
wire           cfg_mode_1x1_pack;
wire           cfg_perf_nan_inf_count_en;
wire           cmd2dat_dma_cube_end;
wire    [13:0] cmd2dat_dma_size;
wire           cmd_cube_end;
wire           dat_accept;
wire           dat_batch_end;
wire   [511:0] dat_data;
wire           dat_layer_end;
wire   [513:0] dat_pd;
wire           dat_rdy;
wire           dat_vld;
wire           fifo_vld;
wire    [31:0] inf_input_cnt_nxt;
wire           inf_input_cnt_nxt_c;
wire           is_last_beat;
wire           mode_16to8_pfifo0_sel;
wire           mode_16to8_pfifo1_sel;
wire           mode_16to8_pfifo2_sel;
wire           mode_16to8_pfifo3_sel;
wire           mode_16to8_sfifo0_sel;
wire           mode_16to8_sfifo1_sel;
wire           mode_norm_pfifo0_sel;
wire           mode_norm_pfifo0_sel_16;
wire           mode_norm_pfifo0_sel_8;
wire           mode_norm_pfifo1_sel;
wire           mode_norm_pfifo1_sel_16;
wire           mode_norm_pfifo1_sel_8;
wire           mode_norm_pfifo2_sel;
wire           mode_norm_pfifo2_sel_16;
wire           mode_norm_pfifo2_sel_8;
wire           mode_norm_pfifo3_sel;
wire           mode_norm_pfifo3_sel_16;
wire           mode_norm_pfifo3_sel_8;
wire    [31:0] nan_input_cnt_nxt;
wire           nan_input_cnt_nxt_c;
wire   [255:0] pfifo0_data_16;
wire    [15:0] pfifo0_data_byte0_16;
wire     [7:0] pfifo0_data_byte0_8;
wire           pfifo0_data_byte0_is_inf;
wire           pfifo0_data_byte0_is_nan;
wire     [7:0] pfifo0_data_byte10_8;
wire     [7:0] pfifo0_data_byte11_8;
wire     [7:0] pfifo0_data_byte12_8;
wire     [7:0] pfifo0_data_byte13_8;
wire     [7:0] pfifo0_data_byte14_8;
wire     [7:0] pfifo0_data_byte15_8;
wire    [15:0] pfifo0_data_byte1_16;
wire     [7:0] pfifo0_data_byte1_8;
wire           pfifo0_data_byte1_is_inf;
wire           pfifo0_data_byte1_is_nan;
wire    [15:0] pfifo0_data_byte2_16;
wire     [7:0] pfifo0_data_byte2_8;
wire           pfifo0_data_byte2_is_inf;
wire           pfifo0_data_byte2_is_nan;
wire    [15:0] pfifo0_data_byte3_16;
wire     [7:0] pfifo0_data_byte3_8;
wire           pfifo0_data_byte3_is_inf;
wire           pfifo0_data_byte3_is_nan;
wire    [15:0] pfifo0_data_byte4_16;
wire     [7:0] pfifo0_data_byte4_8;
wire           pfifo0_data_byte4_is_inf;
wire           pfifo0_data_byte4_is_nan;
wire    [15:0] pfifo0_data_byte5_16;
wire     [7:0] pfifo0_data_byte5_8;
wire           pfifo0_data_byte5_is_inf;
wire           pfifo0_data_byte5_is_nan;
wire    [15:0] pfifo0_data_byte6_16;
wire     [7:0] pfifo0_data_byte6_8;
wire           pfifo0_data_byte6_is_inf;
wire           pfifo0_data_byte6_is_nan;
wire    [15:0] pfifo0_data_byte7_16;
wire     [7:0] pfifo0_data_byte7_8;
wire           pfifo0_data_byte7_is_inf;
wire           pfifo0_data_byte7_is_nan;
wire     [7:0] pfifo0_data_byte8_8;
wire     [7:0] pfifo0_data_byte9_8;
wire    [31:0] pfifo0_data_ext_byte0_16;
wire    [31:0] pfifo0_data_ext_byte0_8;
wire    [31:0] pfifo0_data_ext_byte0_fp16;
wire    [31:0] pfifo0_data_ext_byte0_int16;
wire    [31:0] pfifo0_data_ext_byte10_8;
wire    [31:0] pfifo0_data_ext_byte11_8;
wire    [31:0] pfifo0_data_ext_byte12_8;
wire    [31:0] pfifo0_data_ext_byte13_8;
wire    [31:0] pfifo0_data_ext_byte14_8;
wire    [31:0] pfifo0_data_ext_byte15_8;
wire    [31:0] pfifo0_data_ext_byte1_16;
wire    [31:0] pfifo0_data_ext_byte1_8;
wire    [31:0] pfifo0_data_ext_byte1_fp16;
wire    [31:0] pfifo0_data_ext_byte1_int16;
wire    [31:0] pfifo0_data_ext_byte2_16;
wire    [31:0] pfifo0_data_ext_byte2_8;
wire    [31:0] pfifo0_data_ext_byte2_fp16;
wire    [31:0] pfifo0_data_ext_byte2_int16;
wire    [31:0] pfifo0_data_ext_byte3_16;
wire    [31:0] pfifo0_data_ext_byte3_8;
wire    [31:0] pfifo0_data_ext_byte3_fp16;
wire    [31:0] pfifo0_data_ext_byte3_int16;
wire    [31:0] pfifo0_data_ext_byte4_16;
wire    [31:0] pfifo0_data_ext_byte4_8;
wire    [31:0] pfifo0_data_ext_byte4_fp16;
wire    [31:0] pfifo0_data_ext_byte4_int16;
wire    [31:0] pfifo0_data_ext_byte5_16;
wire    [31:0] pfifo0_data_ext_byte5_8;
wire    [31:0] pfifo0_data_ext_byte5_fp16;
wire    [31:0] pfifo0_data_ext_byte5_int16;
wire    [31:0] pfifo0_data_ext_byte6_16;
wire    [31:0] pfifo0_data_ext_byte6_8;
wire    [31:0] pfifo0_data_ext_byte6_fp16;
wire    [31:0] pfifo0_data_ext_byte6_int16;
wire    [31:0] pfifo0_data_ext_byte7_16;
wire    [31:0] pfifo0_data_ext_byte7_8;
wire    [31:0] pfifo0_data_ext_byte7_fp16;
wire    [31:0] pfifo0_data_ext_byte7_int16;
wire    [31:0] pfifo0_data_ext_byte8_8;
wire    [31:0] pfifo0_data_ext_byte9_8;
wire   [127:0] pfifo0_rd_data;
wire           pfifo0_sel;
wire   [255:0] pfifo1_data_16;
wire    [15:0] pfifo1_data_byte0_16;
wire     [7:0] pfifo1_data_byte0_8;
wire           pfifo1_data_byte0_is_inf;
wire           pfifo1_data_byte0_is_nan;
wire     [7:0] pfifo1_data_byte10_8;
wire     [7:0] pfifo1_data_byte11_8;
wire     [7:0] pfifo1_data_byte12_8;
wire     [7:0] pfifo1_data_byte13_8;
wire     [7:0] pfifo1_data_byte14_8;
wire     [7:0] pfifo1_data_byte15_8;
wire    [15:0] pfifo1_data_byte1_16;
wire     [7:0] pfifo1_data_byte1_8;
wire           pfifo1_data_byte1_is_inf;
wire           pfifo1_data_byte1_is_nan;
wire    [15:0] pfifo1_data_byte2_16;
wire     [7:0] pfifo1_data_byte2_8;
wire           pfifo1_data_byte2_is_inf;
wire           pfifo1_data_byte2_is_nan;
wire    [15:0] pfifo1_data_byte3_16;
wire     [7:0] pfifo1_data_byte3_8;
wire           pfifo1_data_byte3_is_inf;
wire           pfifo1_data_byte3_is_nan;
wire    [15:0] pfifo1_data_byte4_16;
wire     [7:0] pfifo1_data_byte4_8;
wire           pfifo1_data_byte4_is_inf;
wire           pfifo1_data_byte4_is_nan;
wire    [15:0] pfifo1_data_byte5_16;
wire     [7:0] pfifo1_data_byte5_8;
wire           pfifo1_data_byte5_is_inf;
wire           pfifo1_data_byte5_is_nan;
wire    [15:0] pfifo1_data_byte6_16;
wire     [7:0] pfifo1_data_byte6_8;
wire           pfifo1_data_byte6_is_inf;
wire           pfifo1_data_byte6_is_nan;
wire    [15:0] pfifo1_data_byte7_16;
wire     [7:0] pfifo1_data_byte7_8;
wire           pfifo1_data_byte7_is_inf;
wire           pfifo1_data_byte7_is_nan;
wire     [7:0] pfifo1_data_byte8_8;
wire     [7:0] pfifo1_data_byte9_8;
wire    [31:0] pfifo1_data_ext_byte0_16;
wire    [31:0] pfifo1_data_ext_byte0_8;
wire    [31:0] pfifo1_data_ext_byte0_fp16;
wire    [31:0] pfifo1_data_ext_byte0_int16;
wire    [31:0] pfifo1_data_ext_byte10_8;
wire    [31:0] pfifo1_data_ext_byte11_8;
wire    [31:0] pfifo1_data_ext_byte12_8;
wire    [31:0] pfifo1_data_ext_byte13_8;
wire    [31:0] pfifo1_data_ext_byte14_8;
wire    [31:0] pfifo1_data_ext_byte15_8;
wire    [31:0] pfifo1_data_ext_byte1_16;
wire    [31:0] pfifo1_data_ext_byte1_8;
wire    [31:0] pfifo1_data_ext_byte1_fp16;
wire    [31:0] pfifo1_data_ext_byte1_int16;
wire    [31:0] pfifo1_data_ext_byte2_16;
wire    [31:0] pfifo1_data_ext_byte2_8;
wire    [31:0] pfifo1_data_ext_byte2_fp16;
wire    [31:0] pfifo1_data_ext_byte2_int16;
wire    [31:0] pfifo1_data_ext_byte3_16;
wire    [31:0] pfifo1_data_ext_byte3_8;
wire    [31:0] pfifo1_data_ext_byte3_fp16;
wire    [31:0] pfifo1_data_ext_byte3_int16;
wire    [31:0] pfifo1_data_ext_byte4_16;
wire    [31:0] pfifo1_data_ext_byte4_8;
wire    [31:0] pfifo1_data_ext_byte4_fp16;
wire    [31:0] pfifo1_data_ext_byte4_int16;
wire    [31:0] pfifo1_data_ext_byte5_16;
wire    [31:0] pfifo1_data_ext_byte5_8;
wire    [31:0] pfifo1_data_ext_byte5_fp16;
wire    [31:0] pfifo1_data_ext_byte5_int16;
wire    [31:0] pfifo1_data_ext_byte6_16;
wire    [31:0] pfifo1_data_ext_byte6_8;
wire    [31:0] pfifo1_data_ext_byte6_fp16;
wire    [31:0] pfifo1_data_ext_byte6_int16;
wire    [31:0] pfifo1_data_ext_byte7_16;
wire    [31:0] pfifo1_data_ext_byte7_8;
wire    [31:0] pfifo1_data_ext_byte7_fp16;
wire    [31:0] pfifo1_data_ext_byte7_int16;
wire    [31:0] pfifo1_data_ext_byte8_8;
wire    [31:0] pfifo1_data_ext_byte9_8;
wire   [127:0] pfifo1_rd_data;
wire           pfifo1_sel;
wire   [255:0] pfifo2_data_16;
wire    [15:0] pfifo2_data_byte0_16;
wire     [7:0] pfifo2_data_byte0_8;
wire           pfifo2_data_byte0_is_inf;
wire           pfifo2_data_byte0_is_nan;
wire     [7:0] pfifo2_data_byte10_8;
wire     [7:0] pfifo2_data_byte11_8;
wire     [7:0] pfifo2_data_byte12_8;
wire     [7:0] pfifo2_data_byte13_8;
wire     [7:0] pfifo2_data_byte14_8;
wire     [7:0] pfifo2_data_byte15_8;
wire    [15:0] pfifo2_data_byte1_16;
wire     [7:0] pfifo2_data_byte1_8;
wire           pfifo2_data_byte1_is_inf;
wire           pfifo2_data_byte1_is_nan;
wire    [15:0] pfifo2_data_byte2_16;
wire     [7:0] pfifo2_data_byte2_8;
wire           pfifo2_data_byte2_is_inf;
wire           pfifo2_data_byte2_is_nan;
wire    [15:0] pfifo2_data_byte3_16;
wire     [7:0] pfifo2_data_byte3_8;
wire           pfifo2_data_byte3_is_inf;
wire           pfifo2_data_byte3_is_nan;
wire    [15:0] pfifo2_data_byte4_16;
wire     [7:0] pfifo2_data_byte4_8;
wire           pfifo2_data_byte4_is_inf;
wire           pfifo2_data_byte4_is_nan;
wire    [15:0] pfifo2_data_byte5_16;
wire     [7:0] pfifo2_data_byte5_8;
wire           pfifo2_data_byte5_is_inf;
wire           pfifo2_data_byte5_is_nan;
wire    [15:0] pfifo2_data_byte6_16;
wire     [7:0] pfifo2_data_byte6_8;
wire           pfifo2_data_byte6_is_inf;
wire           pfifo2_data_byte6_is_nan;
wire    [15:0] pfifo2_data_byte7_16;
wire     [7:0] pfifo2_data_byte7_8;
wire           pfifo2_data_byte7_is_inf;
wire           pfifo2_data_byte7_is_nan;
wire     [7:0] pfifo2_data_byte8_8;
wire     [7:0] pfifo2_data_byte9_8;
wire    [31:0] pfifo2_data_ext_byte0_16;
wire    [31:0] pfifo2_data_ext_byte0_8;
wire    [31:0] pfifo2_data_ext_byte0_fp16;
wire    [31:0] pfifo2_data_ext_byte0_int16;
wire    [31:0] pfifo2_data_ext_byte10_8;
wire    [31:0] pfifo2_data_ext_byte11_8;
wire    [31:0] pfifo2_data_ext_byte12_8;
wire    [31:0] pfifo2_data_ext_byte13_8;
wire    [31:0] pfifo2_data_ext_byte14_8;
wire    [31:0] pfifo2_data_ext_byte15_8;
wire    [31:0] pfifo2_data_ext_byte1_16;
wire    [31:0] pfifo2_data_ext_byte1_8;
wire    [31:0] pfifo2_data_ext_byte1_fp16;
wire    [31:0] pfifo2_data_ext_byte1_int16;
wire    [31:0] pfifo2_data_ext_byte2_16;
wire    [31:0] pfifo2_data_ext_byte2_8;
wire    [31:0] pfifo2_data_ext_byte2_fp16;
wire    [31:0] pfifo2_data_ext_byte2_int16;
wire    [31:0] pfifo2_data_ext_byte3_16;
wire    [31:0] pfifo2_data_ext_byte3_8;
wire    [31:0] pfifo2_data_ext_byte3_fp16;
wire    [31:0] pfifo2_data_ext_byte3_int16;
wire    [31:0] pfifo2_data_ext_byte4_16;
wire    [31:0] pfifo2_data_ext_byte4_8;
wire    [31:0] pfifo2_data_ext_byte4_fp16;
wire    [31:0] pfifo2_data_ext_byte4_int16;
wire    [31:0] pfifo2_data_ext_byte5_16;
wire    [31:0] pfifo2_data_ext_byte5_8;
wire    [31:0] pfifo2_data_ext_byte5_fp16;
wire    [31:0] pfifo2_data_ext_byte5_int16;
wire    [31:0] pfifo2_data_ext_byte6_16;
wire    [31:0] pfifo2_data_ext_byte6_8;
wire    [31:0] pfifo2_data_ext_byte6_fp16;
wire    [31:0] pfifo2_data_ext_byte6_int16;
wire    [31:0] pfifo2_data_ext_byte7_16;
wire    [31:0] pfifo2_data_ext_byte7_8;
wire    [31:0] pfifo2_data_ext_byte7_fp16;
wire    [31:0] pfifo2_data_ext_byte7_int16;
wire    [31:0] pfifo2_data_ext_byte8_8;
wire    [31:0] pfifo2_data_ext_byte9_8;
wire   [127:0] pfifo2_rd_data;
wire           pfifo2_sel;
wire   [255:0] pfifo3_data_16;
wire    [15:0] pfifo3_data_byte0_16;
wire     [7:0] pfifo3_data_byte0_8;
wire           pfifo3_data_byte0_is_inf;
wire           pfifo3_data_byte0_is_nan;
wire     [7:0] pfifo3_data_byte10_8;
wire     [7:0] pfifo3_data_byte11_8;
wire     [7:0] pfifo3_data_byte12_8;
wire     [7:0] pfifo3_data_byte13_8;
wire     [7:0] pfifo3_data_byte14_8;
wire     [7:0] pfifo3_data_byte15_8;
wire    [15:0] pfifo3_data_byte1_16;
wire     [7:0] pfifo3_data_byte1_8;
wire           pfifo3_data_byte1_is_inf;
wire           pfifo3_data_byte1_is_nan;
wire    [15:0] pfifo3_data_byte2_16;
wire     [7:0] pfifo3_data_byte2_8;
wire           pfifo3_data_byte2_is_inf;
wire           pfifo3_data_byte2_is_nan;
wire    [15:0] pfifo3_data_byte3_16;
wire     [7:0] pfifo3_data_byte3_8;
wire           pfifo3_data_byte3_is_inf;
wire           pfifo3_data_byte3_is_nan;
wire    [15:0] pfifo3_data_byte4_16;
wire     [7:0] pfifo3_data_byte4_8;
wire           pfifo3_data_byte4_is_inf;
wire           pfifo3_data_byte4_is_nan;
wire    [15:0] pfifo3_data_byte5_16;
wire     [7:0] pfifo3_data_byte5_8;
wire           pfifo3_data_byte5_is_inf;
wire           pfifo3_data_byte5_is_nan;
wire    [15:0] pfifo3_data_byte6_16;
wire     [7:0] pfifo3_data_byte6_8;
wire           pfifo3_data_byte6_is_inf;
wire           pfifo3_data_byte6_is_nan;
wire    [15:0] pfifo3_data_byte7_16;
wire     [7:0] pfifo3_data_byte7_8;
wire           pfifo3_data_byte7_is_inf;
wire           pfifo3_data_byte7_is_nan;
wire     [7:0] pfifo3_data_byte8_8;
wire     [7:0] pfifo3_data_byte9_8;
wire    [31:0] pfifo3_data_ext_byte0_16;
wire    [31:0] pfifo3_data_ext_byte0_8;
wire    [31:0] pfifo3_data_ext_byte0_fp16;
wire    [31:0] pfifo3_data_ext_byte0_int16;
wire    [31:0] pfifo3_data_ext_byte10_8;
wire    [31:0] pfifo3_data_ext_byte11_8;
wire    [31:0] pfifo3_data_ext_byte12_8;
wire    [31:0] pfifo3_data_ext_byte13_8;
wire    [31:0] pfifo3_data_ext_byte14_8;
wire    [31:0] pfifo3_data_ext_byte15_8;
wire    [31:0] pfifo3_data_ext_byte1_16;
wire    [31:0] pfifo3_data_ext_byte1_8;
wire    [31:0] pfifo3_data_ext_byte1_fp16;
wire    [31:0] pfifo3_data_ext_byte1_int16;
wire    [31:0] pfifo3_data_ext_byte2_16;
wire    [31:0] pfifo3_data_ext_byte2_8;
wire    [31:0] pfifo3_data_ext_byte2_fp16;
wire    [31:0] pfifo3_data_ext_byte2_int16;
wire    [31:0] pfifo3_data_ext_byte3_16;
wire    [31:0] pfifo3_data_ext_byte3_8;
wire    [31:0] pfifo3_data_ext_byte3_fp16;
wire    [31:0] pfifo3_data_ext_byte3_int16;
wire    [31:0] pfifo3_data_ext_byte4_16;
wire    [31:0] pfifo3_data_ext_byte4_8;
wire    [31:0] pfifo3_data_ext_byte4_fp16;
wire    [31:0] pfifo3_data_ext_byte4_int16;
wire    [31:0] pfifo3_data_ext_byte5_16;
wire    [31:0] pfifo3_data_ext_byte5_8;
wire    [31:0] pfifo3_data_ext_byte5_fp16;
wire    [31:0] pfifo3_data_ext_byte5_int16;
wire    [31:0] pfifo3_data_ext_byte6_16;
wire    [31:0] pfifo3_data_ext_byte6_8;
wire    [31:0] pfifo3_data_ext_byte6_fp16;
wire    [31:0] pfifo3_data_ext_byte6_int16;
wire    [31:0] pfifo3_data_ext_byte7_16;
wire    [31:0] pfifo3_data_ext_byte7_8;
wire    [31:0] pfifo3_data_ext_byte7_fp16;
wire    [31:0] pfifo3_data_ext_byte7_int16;
wire    [31:0] pfifo3_data_ext_byte8_8;
wire    [31:0] pfifo3_data_ext_byte9_8;
wire   [127:0] pfifo3_rd_data;
wire           pfifo3_sel;
wire   [511:0] pfifo_data;
wire   [511:0] pfifo_data0_16;
wire   [511:0] pfifo_data0_8;
wire   [511:0] pfifo_data1_16;
wire   [511:0] pfifo_data1_8;
wire   [511:0] pfifo_data2_8;
wire   [511:0] pfifo_data3_8;
wire           pfifo_sel;
wire           pfifo_vld;
wire           sdp_mrdma2cmux_layer_end;
wire   [511:0] sfifo0_data_16;
wire    [15:0] sfifo0_data_byte0_16;
wire    [15:0] sfifo0_data_byte10_16;
wire    [15:0] sfifo0_data_byte11_16;
wire    [15:0] sfifo0_data_byte12_16;
wire    [15:0] sfifo0_data_byte13_16;
wire    [15:0] sfifo0_data_byte14_16;
wire    [15:0] sfifo0_data_byte15_16;
wire    [15:0] sfifo0_data_byte1_16;
wire    [15:0] sfifo0_data_byte2_16;
wire    [15:0] sfifo0_data_byte3_16;
wire    [15:0] sfifo0_data_byte4_16;
wire    [15:0] sfifo0_data_byte5_16;
wire    [15:0] sfifo0_data_byte6_16;
wire    [15:0] sfifo0_data_byte7_16;
wire    [15:0] sfifo0_data_byte8_16;
wire    [15:0] sfifo0_data_byte9_16;
wire    [31:0] sfifo0_data_ext_byte0_16;
wire    [31:0] sfifo0_data_ext_byte10_16;
wire    [31:0] sfifo0_data_ext_byte11_16;
wire    [31:0] sfifo0_data_ext_byte12_16;
wire    [31:0] sfifo0_data_ext_byte13_16;
wire    [31:0] sfifo0_data_ext_byte14_16;
wire    [31:0] sfifo0_data_ext_byte15_16;
wire    [31:0] sfifo0_data_ext_byte1_16;
wire    [31:0] sfifo0_data_ext_byte2_16;
wire    [31:0] sfifo0_data_ext_byte3_16;
wire    [31:0] sfifo0_data_ext_byte4_16;
wire    [31:0] sfifo0_data_ext_byte5_16;
wire    [31:0] sfifo0_data_ext_byte6_16;
wire    [31:0] sfifo0_data_ext_byte7_16;
wire    [31:0] sfifo0_data_ext_byte8_16;
wire    [31:0] sfifo0_data_ext_byte9_16;
wire   [255:0] sfifo0_rd_data;
wire           sfifo0_sel;
wire   [511:0] sfifo1_data_16;
wire    [15:0] sfifo1_data_byte0_16;
wire    [15:0] sfifo1_data_byte10_16;
wire    [15:0] sfifo1_data_byte11_16;
wire    [15:0] sfifo1_data_byte12_16;
wire    [15:0] sfifo1_data_byte13_16;
wire    [15:0] sfifo1_data_byte14_16;
wire    [15:0] sfifo1_data_byte15_16;
wire    [15:0] sfifo1_data_byte1_16;
wire    [15:0] sfifo1_data_byte2_16;
wire    [15:0] sfifo1_data_byte3_16;
wire    [15:0] sfifo1_data_byte4_16;
wire    [15:0] sfifo1_data_byte5_16;
wire    [15:0] sfifo1_data_byte6_16;
wire    [15:0] sfifo1_data_byte7_16;
wire    [15:0] sfifo1_data_byte8_16;
wire    [15:0] sfifo1_data_byte9_16;
wire    [31:0] sfifo1_data_ext_byte0_16;
wire    [31:0] sfifo1_data_ext_byte10_16;
wire    [31:0] sfifo1_data_ext_byte11_16;
wire    [31:0] sfifo1_data_ext_byte12_16;
wire    [31:0] sfifo1_data_ext_byte13_16;
wire    [31:0] sfifo1_data_ext_byte14_16;
wire    [31:0] sfifo1_data_ext_byte15_16;
wire    [31:0] sfifo1_data_ext_byte1_16;
wire    [31:0] sfifo1_data_ext_byte2_16;
wire    [31:0] sfifo1_data_ext_byte3_16;
wire    [31:0] sfifo1_data_ext_byte4_16;
wire    [31:0] sfifo1_data_ext_byte5_16;
wire    [31:0] sfifo1_data_ext_byte6_16;
wire    [31:0] sfifo1_data_ext_byte7_16;
wire    [31:0] sfifo1_data_ext_byte8_16;
wire    [31:0] sfifo1_data_ext_byte9_16;
wire   [255:0] sfifo1_rd_data;
wire           sfifo1_sel;
wire   [511:0] sfifo_data0_16;
wire   [511:0] sfifo_data1_16;
wire           sfifo_sel;
wire           sfifo_vld;
wire    [13:0] size_of_beat;
wire     [4:0] sum0_of_inf;
wire     [4:0] sum0_of_nan;
wire     [4:0] sum1_of_inf;
wire     [4:0] sum1_of_nan;
wire     [4:0] sum_of_inf;
wire     [4:0] sum_of_nan;
wire           sum_of_sel;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//==============
// Status Generation: idle/busy/process/done/etc
//==============
// CFG
assign cfg_di_int8  = reg2dp_in_precision == 0 ;
assign cfg_di_int16 = reg2dp_in_precision == 1 ;
assign cfg_di_fp16 = reg2dp_in_precision == 2 ;
assign cfg_di_16 = cfg_di_int16 | cfg_di_fp16;
assign cfg_do_int8  = reg2dp_proc_precision == 0 ;
//assign cfg_do_int16 = reg2dp_proc_precision == NVDLA_GENERIC_PRECISION_ENUM_INT16;
assign cfg_mode_16to8 = cfg_di_int16 & cfg_do_int8;
assign cfg_mode_1x1_pack = (reg2dp_width==0) & (reg2dp_height==0);

assign cfg_perf_nan_inf_count_en = reg2dp_perf_nan_inf_count_en;

assign cmd2dat_dma_prdy = dat_accept & is_last_beat & fifo_vld & dat_rdy;

// PKT_UNPACK_WIRE( sdp_mrdma_eg_dma , cmd2dat_dma_ , cmd2dat_dma_pd )
assign       cmd2dat_dma_size[13:0] =    cmd2dat_dma_pd[13:0];
assign        cmd2dat_dma_cube_end  =    cmd2dat_dma_pd[14];
// cmd_size | cmd_freeze
assign size_of_beat = {14 {cmd2dat_dma_pvld}} & cmd2dat_dma_size;
assign cmd_cube_end = {1 {cmd2dat_dma_pvld}} & cmd2dat_dma_cube_end;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    beat_cnt <= {14{1'b0}};
  end else begin
    if (dat_accept) begin
        if (is_last_beat) begin
            beat_cnt <= 0;
        end else begin
            beat_cnt <= beat_cnt + 1;
        end
    end
  end
end
assign is_last_beat = (beat_cnt==size_of_beat);

//=====PERF COUNT BEG=============
assign sum_of_sel = beat_cnt[0]==1;

 assign pfifo0_data_byte0_is_inf = pfifo0_data_byte0_16[14:10]==5'h1f && pfifo0_data_byte0_16[9:0]==10'h0;
 assign pfifo0_data_byte1_is_inf = pfifo0_data_byte1_16[14:10]==5'h1f && pfifo0_data_byte1_16[9:0]==10'h0;
 assign pfifo0_data_byte2_is_inf = pfifo0_data_byte2_16[14:10]==5'h1f && pfifo0_data_byte2_16[9:0]==10'h0;
 assign pfifo0_data_byte3_is_inf = pfifo0_data_byte3_16[14:10]==5'h1f && pfifo0_data_byte3_16[9:0]==10'h0;
 assign pfifo0_data_byte4_is_inf = pfifo0_data_byte4_16[14:10]==5'h1f && pfifo0_data_byte4_16[9:0]==10'h0;
 assign pfifo0_data_byte5_is_inf = pfifo0_data_byte5_16[14:10]==5'h1f && pfifo0_data_byte5_16[9:0]==10'h0;
 assign pfifo0_data_byte6_is_inf = pfifo0_data_byte6_16[14:10]==5'h1f && pfifo0_data_byte6_16[9:0]==10'h0;
 assign pfifo0_data_byte7_is_inf = pfifo0_data_byte7_16[14:10]==5'h1f && pfifo0_data_byte7_16[9:0]==10'h0;
 assign pfifo1_data_byte0_is_inf = pfifo1_data_byte0_16[14:10]==5'h1f && pfifo1_data_byte0_16[9:0]==10'h0;
 assign pfifo1_data_byte1_is_inf = pfifo1_data_byte1_16[14:10]==5'h1f && pfifo1_data_byte1_16[9:0]==10'h0;
 assign pfifo1_data_byte2_is_inf = pfifo1_data_byte2_16[14:10]==5'h1f && pfifo1_data_byte2_16[9:0]==10'h0;
 assign pfifo1_data_byte3_is_inf = pfifo1_data_byte3_16[14:10]==5'h1f && pfifo1_data_byte3_16[9:0]==10'h0;
 assign pfifo1_data_byte4_is_inf = pfifo1_data_byte4_16[14:10]==5'h1f && pfifo1_data_byte4_16[9:0]==10'h0;
 assign pfifo1_data_byte5_is_inf = pfifo1_data_byte5_16[14:10]==5'h1f && pfifo1_data_byte5_16[9:0]==10'h0;
 assign pfifo1_data_byte6_is_inf = pfifo1_data_byte6_16[14:10]==5'h1f && pfifo1_data_byte6_16[9:0]==10'h0;
 assign pfifo1_data_byte7_is_inf = pfifo1_data_byte7_16[14:10]==5'h1f && pfifo1_data_byte7_16[9:0]==10'h0;
 assign pfifo2_data_byte0_is_inf = pfifo2_data_byte0_16[14:10]==5'h1f && pfifo2_data_byte0_16[9:0]==10'h0;
 assign pfifo2_data_byte1_is_inf = pfifo2_data_byte1_16[14:10]==5'h1f && pfifo2_data_byte1_16[9:0]==10'h0;
 assign pfifo2_data_byte2_is_inf = pfifo2_data_byte2_16[14:10]==5'h1f && pfifo2_data_byte2_16[9:0]==10'h0;
 assign pfifo2_data_byte3_is_inf = pfifo2_data_byte3_16[14:10]==5'h1f && pfifo2_data_byte3_16[9:0]==10'h0;
 assign pfifo2_data_byte4_is_inf = pfifo2_data_byte4_16[14:10]==5'h1f && pfifo2_data_byte4_16[9:0]==10'h0;
 assign pfifo2_data_byte5_is_inf = pfifo2_data_byte5_16[14:10]==5'h1f && pfifo2_data_byte5_16[9:0]==10'h0;
 assign pfifo2_data_byte6_is_inf = pfifo2_data_byte6_16[14:10]==5'h1f && pfifo2_data_byte6_16[9:0]==10'h0;
 assign pfifo2_data_byte7_is_inf = pfifo2_data_byte7_16[14:10]==5'h1f && pfifo2_data_byte7_16[9:0]==10'h0;
 assign pfifo3_data_byte0_is_inf = pfifo3_data_byte0_16[14:10]==5'h1f && pfifo3_data_byte0_16[9:0]==10'h0;
 assign pfifo3_data_byte1_is_inf = pfifo3_data_byte1_16[14:10]==5'h1f && pfifo3_data_byte1_16[9:0]==10'h0;
 assign pfifo3_data_byte2_is_inf = pfifo3_data_byte2_16[14:10]==5'h1f && pfifo3_data_byte2_16[9:0]==10'h0;
 assign pfifo3_data_byte3_is_inf = pfifo3_data_byte3_16[14:10]==5'h1f && pfifo3_data_byte3_16[9:0]==10'h0;
 assign pfifo3_data_byte4_is_inf = pfifo3_data_byte4_16[14:10]==5'h1f && pfifo3_data_byte4_16[9:0]==10'h0;
 assign pfifo3_data_byte5_is_inf = pfifo3_data_byte5_16[14:10]==5'h1f && pfifo3_data_byte5_16[9:0]==10'h0;
 assign pfifo3_data_byte6_is_inf = pfifo3_data_byte6_16[14:10]==5'h1f && pfifo3_data_byte6_16[9:0]==10'h0;
 assign pfifo3_data_byte7_is_inf = pfifo3_data_byte7_16[14:10]==5'h1f && pfifo3_data_byte7_16[9:0]==10'h0;

assign sum0_of_inf = pfifo1_data_byte7_is_inf + pfifo1_data_byte6_is_inf + pfifo1_data_byte5_is_inf + pfifo1_data_byte4_is_inf + pfifo1_data_byte3_is_inf + pfifo1_data_byte2_is_inf + pfifo1_data_byte1_is_inf + pfifo1_data_byte0_is_inf + pfifo0_data_byte7_is_inf + pfifo0_data_byte6_is_inf + pfifo0_data_byte5_is_inf + pfifo0_data_byte4_is_inf + pfifo0_data_byte3_is_inf + pfifo0_data_byte2_is_inf + pfifo0_data_byte1_is_inf + pfifo0_data_byte0_is_inf;
assign sum1_of_inf = pfifo3_data_byte7_is_inf + pfifo3_data_byte6_is_inf + pfifo3_data_byte5_is_inf + pfifo3_data_byte4_is_inf + pfifo3_data_byte3_is_inf + pfifo3_data_byte2_is_inf + pfifo3_data_byte1_is_inf + pfifo3_data_byte0_is_inf + pfifo2_data_byte7_is_inf + pfifo2_data_byte6_is_inf + pfifo2_data_byte5_is_inf + pfifo2_data_byte4_is_inf + pfifo2_data_byte3_is_inf + pfifo2_data_byte2_is_inf + pfifo2_data_byte1_is_inf + pfifo2_data_byte0_is_inf;

assign sum_of_inf = sum_of_sel ? sum1_of_inf : sum0_of_inf;
assign {inf_input_cnt_nxt_c,inf_input_cnt_nxt[31:0]} = inf_input_cnt[31:0] + sum_of_inf;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    inf_input_cnt <= {32{1'b0}};
  end else begin
    if (cfg_di_fp16 && cfg_perf_nan_inf_count_en) begin
        if (op_load) begin
            inf_input_cnt <= 0;
        end else if (dat_accept) begin
            if (inf_input_cnt_nxt_c || (&inf_input_cnt)) begin
                inf_input_cnt <= 32'hffffffff;
            end else begin
                inf_input_cnt <= inf_input_cnt_nxt;
            end
        end
    end
  end
end
assign dp2reg_status_inf_input_num = inf_input_cnt;

 assign pfifo0_data_byte0_is_nan = pfifo0_data_byte0_16[14:10]==5'h1f && pfifo0_data_byte0_16[9:0]!=10'h0;
 assign pfifo0_data_byte1_is_nan = pfifo0_data_byte1_16[14:10]==5'h1f && pfifo0_data_byte1_16[9:0]!=10'h0;
 assign pfifo0_data_byte2_is_nan = pfifo0_data_byte2_16[14:10]==5'h1f && pfifo0_data_byte2_16[9:0]!=10'h0;
 assign pfifo0_data_byte3_is_nan = pfifo0_data_byte3_16[14:10]==5'h1f && pfifo0_data_byte3_16[9:0]!=10'h0;
 assign pfifo0_data_byte4_is_nan = pfifo0_data_byte4_16[14:10]==5'h1f && pfifo0_data_byte4_16[9:0]!=10'h0;
 assign pfifo0_data_byte5_is_nan = pfifo0_data_byte5_16[14:10]==5'h1f && pfifo0_data_byte5_16[9:0]!=10'h0;
 assign pfifo0_data_byte6_is_nan = pfifo0_data_byte6_16[14:10]==5'h1f && pfifo0_data_byte6_16[9:0]!=10'h0;
 assign pfifo0_data_byte7_is_nan = pfifo0_data_byte7_16[14:10]==5'h1f && pfifo0_data_byte7_16[9:0]!=10'h0;
 assign pfifo1_data_byte0_is_nan = pfifo1_data_byte0_16[14:10]==5'h1f && pfifo1_data_byte0_16[9:0]!=10'h0;
 assign pfifo1_data_byte1_is_nan = pfifo1_data_byte1_16[14:10]==5'h1f && pfifo1_data_byte1_16[9:0]!=10'h0;
 assign pfifo1_data_byte2_is_nan = pfifo1_data_byte2_16[14:10]==5'h1f && pfifo1_data_byte2_16[9:0]!=10'h0;
 assign pfifo1_data_byte3_is_nan = pfifo1_data_byte3_16[14:10]==5'h1f && pfifo1_data_byte3_16[9:0]!=10'h0;
 assign pfifo1_data_byte4_is_nan = pfifo1_data_byte4_16[14:10]==5'h1f && pfifo1_data_byte4_16[9:0]!=10'h0;
 assign pfifo1_data_byte5_is_nan = pfifo1_data_byte5_16[14:10]==5'h1f && pfifo1_data_byte5_16[9:0]!=10'h0;
 assign pfifo1_data_byte6_is_nan = pfifo1_data_byte6_16[14:10]==5'h1f && pfifo1_data_byte6_16[9:0]!=10'h0;
 assign pfifo1_data_byte7_is_nan = pfifo1_data_byte7_16[14:10]==5'h1f && pfifo1_data_byte7_16[9:0]!=10'h0;
 assign pfifo2_data_byte0_is_nan = pfifo2_data_byte0_16[14:10]==5'h1f && pfifo2_data_byte0_16[9:0]!=10'h0;
 assign pfifo2_data_byte1_is_nan = pfifo2_data_byte1_16[14:10]==5'h1f && pfifo2_data_byte1_16[9:0]!=10'h0;
 assign pfifo2_data_byte2_is_nan = pfifo2_data_byte2_16[14:10]==5'h1f && pfifo2_data_byte2_16[9:0]!=10'h0;
 assign pfifo2_data_byte3_is_nan = pfifo2_data_byte3_16[14:10]==5'h1f && pfifo2_data_byte3_16[9:0]!=10'h0;
 assign pfifo2_data_byte4_is_nan = pfifo2_data_byte4_16[14:10]==5'h1f && pfifo2_data_byte4_16[9:0]!=10'h0;
 assign pfifo2_data_byte5_is_nan = pfifo2_data_byte5_16[14:10]==5'h1f && pfifo2_data_byte5_16[9:0]!=10'h0;
 assign pfifo2_data_byte6_is_nan = pfifo2_data_byte6_16[14:10]==5'h1f && pfifo2_data_byte6_16[9:0]!=10'h0;
 assign pfifo2_data_byte7_is_nan = pfifo2_data_byte7_16[14:10]==5'h1f && pfifo2_data_byte7_16[9:0]!=10'h0;
 assign pfifo3_data_byte0_is_nan = pfifo3_data_byte0_16[14:10]==5'h1f && pfifo3_data_byte0_16[9:0]!=10'h0;
 assign pfifo3_data_byte1_is_nan = pfifo3_data_byte1_16[14:10]==5'h1f && pfifo3_data_byte1_16[9:0]!=10'h0;
 assign pfifo3_data_byte2_is_nan = pfifo3_data_byte2_16[14:10]==5'h1f && pfifo3_data_byte2_16[9:0]!=10'h0;
 assign pfifo3_data_byte3_is_nan = pfifo3_data_byte3_16[14:10]==5'h1f && pfifo3_data_byte3_16[9:0]!=10'h0;
 assign pfifo3_data_byte4_is_nan = pfifo3_data_byte4_16[14:10]==5'h1f && pfifo3_data_byte4_16[9:0]!=10'h0;
 assign pfifo3_data_byte5_is_nan = pfifo3_data_byte5_16[14:10]==5'h1f && pfifo3_data_byte5_16[9:0]!=10'h0;
 assign pfifo3_data_byte6_is_nan = pfifo3_data_byte6_16[14:10]==5'h1f && pfifo3_data_byte6_16[9:0]!=10'h0;
 assign pfifo3_data_byte7_is_nan = pfifo3_data_byte7_16[14:10]==5'h1f && pfifo3_data_byte7_16[9:0]!=10'h0;
assign sum0_of_nan = pfifo1_data_byte7_is_nan + pfifo1_data_byte6_is_nan + pfifo1_data_byte5_is_nan + pfifo1_data_byte4_is_nan + pfifo1_data_byte3_is_nan + pfifo1_data_byte2_is_nan + pfifo1_data_byte1_is_nan + pfifo1_data_byte0_is_nan + pfifo0_data_byte7_is_nan + pfifo0_data_byte6_is_nan + pfifo0_data_byte5_is_nan + pfifo0_data_byte4_is_nan + pfifo0_data_byte3_is_nan + pfifo0_data_byte2_is_nan + pfifo0_data_byte1_is_nan + pfifo0_data_byte0_is_nan;
assign sum1_of_nan = pfifo3_data_byte7_is_nan + pfifo3_data_byte6_is_nan + pfifo3_data_byte5_is_nan + pfifo3_data_byte4_is_nan + pfifo3_data_byte3_is_nan + pfifo3_data_byte2_is_nan + pfifo3_data_byte1_is_nan + pfifo3_data_byte0_is_nan + pfifo2_data_byte7_is_nan + pfifo2_data_byte6_is_nan + pfifo2_data_byte5_is_nan + pfifo2_data_byte4_is_nan + pfifo2_data_byte3_is_nan + pfifo2_data_byte2_is_nan + pfifo2_data_byte1_is_nan + pfifo2_data_byte0_is_nan;
assign sum_of_nan = sum_of_sel ? sum1_of_nan : sum0_of_nan;
assign {nan_input_cnt_nxt_c,nan_input_cnt_nxt[31:0]} = nan_input_cnt[31:0] + sum_of_nan;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    nan_input_cnt <= {32{1'b0}};
  end else begin
    if (cfg_di_fp16 && cfg_perf_nan_inf_count_en) begin
        if (op_load) begin
            nan_input_cnt <= 0;
        end else if (dat_accept) begin
            if (nan_input_cnt_nxt_c || (&nan_input_cnt)) begin
                nan_input_cnt <= 32'hffffffff;
            end else begin
                nan_input_cnt <= nan_input_cnt_nxt;
            end
        end
    end
  end
end
assign dp2reg_status_nan_input_num = nan_input_cnt;

//=====PERF COUNT END=============

 assign mode_norm_pfifo0_sel_16 = beat_cnt[0:0]==0;
 assign mode_norm_pfifo1_sel_16 = beat_cnt[0:0]==0;
 assign mode_norm_pfifo2_sel_16 = beat_cnt[0:0]==1;
 assign mode_norm_pfifo3_sel_16 = beat_cnt[0:0]==1;
 assign mode_norm_pfifo0_sel_8  = beat_cnt[1:0]==0;
 assign mode_norm_pfifo1_sel_8  = beat_cnt[1:0]==1;
 assign mode_norm_pfifo2_sel_8  = beat_cnt[1:0]==2;
 assign mode_norm_pfifo3_sel_8  = beat_cnt[1:0]==3;
 assign mode_norm_pfifo0_sel = cfg_di_int8 ? mode_norm_pfifo0_sel_8 : mode_norm_pfifo0_sel_16;
 assign mode_norm_pfifo1_sel = cfg_di_int8 ? mode_norm_pfifo1_sel_8 : mode_norm_pfifo1_sel_16;
 assign mode_norm_pfifo2_sel = cfg_di_int8 ? mode_norm_pfifo2_sel_8 : mode_norm_pfifo2_sel_16;
 assign mode_norm_pfifo3_sel = cfg_di_int8 ? mode_norm_pfifo3_sel_8 : mode_norm_pfifo3_sel_16;

 assign mode_16to8_pfifo0_sel = beat_cnt[1:0]==0;
 assign mode_16to8_pfifo1_sel = beat_cnt[1:0]==0;
 assign mode_16to8_pfifo2_sel = beat_cnt[1:0]==2;
 assign mode_16to8_pfifo3_sel = beat_cnt[1:0]==2;
 assign mode_16to8_sfifo0_sel = beat_cnt[1:0]==1;
 assign mode_16to8_sfifo1_sel = beat_cnt[1:0]==3;

 assign pfifo0_sel = (cfg_mode_16to8 && !cfg_mode_1x1_pack) ? mode_16to8_pfifo0_sel : mode_norm_pfifo0_sel;
 assign pfifo1_sel = (cfg_mode_16to8 && !cfg_mode_1x1_pack) ? mode_16to8_pfifo1_sel : mode_norm_pfifo1_sel;
 assign pfifo2_sel = (cfg_mode_16to8 && !cfg_mode_1x1_pack) ? mode_16to8_pfifo2_sel : mode_norm_pfifo2_sel;
 assign pfifo3_sel = (cfg_mode_16to8 && !cfg_mode_1x1_pack) ? mode_16to8_pfifo3_sel : mode_norm_pfifo3_sel;
 assign sfifo0_sel = (cfg_mode_16to8 && !cfg_mode_1x1_pack) ? mode_16to8_sfifo0_sel : 1'b0;
 assign sfifo1_sel = (cfg_mode_16to8 && !cfg_mode_1x1_pack) ? mode_16to8_sfifo1_sel : 1'b0;

// VALID
assign pfifo_vld = (pfifo3_rd_pvld & pfifo3_sel) | (pfifo2_rd_pvld & pfifo2_sel) | (pfifo1_rd_pvld & pfifo1_sel) | (pfifo0_rd_pvld & pfifo0_sel);
assign sfifo_vld = (sfifo1_rd_pvld & sfifo1_sel) | (sfifo0_rd_pvld & sfifo0_sel);
assign fifo_vld = pfifo_vld | sfifo_vld;
assign dat_vld  = fifo_vld & cmd2dat_dma_pvld;

// READY
 assign pfifo0_rd_prdy = dat_rdy & pfifo0_sel & cmd2dat_dma_pvld;
 assign pfifo1_rd_prdy = dat_rdy & pfifo1_sel & cmd2dat_dma_pvld;
 assign pfifo2_rd_prdy = dat_rdy & pfifo2_sel & cmd2dat_dma_pvld;
 assign pfifo3_rd_prdy = dat_rdy & pfifo3_sel & cmd2dat_dma_pvld;
 assign sfifo0_rd_prdy = dat_rdy & sfifo0_sel & cmd2dat_dma_pvld;
 assign sfifo1_rd_prdy = dat_rdy & sfifo1_sel & cmd2dat_dma_pvld;

// PFIFO PD
 assign pfifo0_rd_data = {128{pfifo0_sel}} & pfifo0_rd_pd;
 assign pfifo1_rd_data = {128{pfifo1_sel}} & pfifo1_rd_pd;
 assign pfifo2_rd_data = {128{pfifo2_sel}} & pfifo2_rd_pd;
 assign pfifo3_rd_data = {128{pfifo3_sel}} & pfifo3_rd_pd;

// INT/FP 16, split into 2byte
 assign pfifo0_data_byte0_16 = pfifo0_rd_data[((0*16) + 16 - 1):0*16];
 assign pfifo0_data_byte1_16 = pfifo0_rd_data[((1*16) + 16 - 1):1*16];
 assign pfifo0_data_byte2_16 = pfifo0_rd_data[((2*16) + 16 - 1):2*16];
 assign pfifo0_data_byte3_16 = pfifo0_rd_data[((3*16) + 16 - 1):3*16];
 assign pfifo0_data_byte4_16 = pfifo0_rd_data[((4*16) + 16 - 1):4*16];
 assign pfifo0_data_byte5_16 = pfifo0_rd_data[((5*16) + 16 - 1):5*16];
 assign pfifo0_data_byte6_16 = pfifo0_rd_data[((6*16) + 16 - 1):6*16];
 assign pfifo0_data_byte7_16 = pfifo0_rd_data[((7*16) + 16 - 1):7*16];
 assign pfifo1_data_byte0_16 = pfifo1_rd_data[((0*16) + 16 - 1):0*16];
 assign pfifo1_data_byte1_16 = pfifo1_rd_data[((1*16) + 16 - 1):1*16];
 assign pfifo1_data_byte2_16 = pfifo1_rd_data[((2*16) + 16 - 1):2*16];
 assign pfifo1_data_byte3_16 = pfifo1_rd_data[((3*16) + 16 - 1):3*16];
 assign pfifo1_data_byte4_16 = pfifo1_rd_data[((4*16) + 16 - 1):4*16];
 assign pfifo1_data_byte5_16 = pfifo1_rd_data[((5*16) + 16 - 1):5*16];
 assign pfifo1_data_byte6_16 = pfifo1_rd_data[((6*16) + 16 - 1):6*16];
 assign pfifo1_data_byte7_16 = pfifo1_rd_data[((7*16) + 16 - 1):7*16];
 assign pfifo2_data_byte0_16 = pfifo2_rd_data[((0*16) + 16 - 1):0*16];
 assign pfifo2_data_byte1_16 = pfifo2_rd_data[((1*16) + 16 - 1):1*16];
 assign pfifo2_data_byte2_16 = pfifo2_rd_data[((2*16) + 16 - 1):2*16];
 assign pfifo2_data_byte3_16 = pfifo2_rd_data[((3*16) + 16 - 1):3*16];
 assign pfifo2_data_byte4_16 = pfifo2_rd_data[((4*16) + 16 - 1):4*16];
 assign pfifo2_data_byte5_16 = pfifo2_rd_data[((5*16) + 16 - 1):5*16];
 assign pfifo2_data_byte6_16 = pfifo2_rd_data[((6*16) + 16 - 1):6*16];
 assign pfifo2_data_byte7_16 = pfifo2_rd_data[((7*16) + 16 - 1):7*16];
 assign pfifo3_data_byte0_16 = pfifo3_rd_data[((0*16) + 16 - 1):0*16];
 assign pfifo3_data_byte1_16 = pfifo3_rd_data[((1*16) + 16 - 1):1*16];
 assign pfifo3_data_byte2_16 = pfifo3_rd_data[((2*16) + 16 - 1):2*16];
 assign pfifo3_data_byte3_16 = pfifo3_rd_data[((3*16) + 16 - 1):3*16];
 assign pfifo3_data_byte4_16 = pfifo3_rd_data[((4*16) + 16 - 1):4*16];
 assign pfifo3_data_byte5_16 = pfifo3_rd_data[((5*16) + 16 - 1):5*16];
 assign pfifo3_data_byte6_16 = pfifo3_rd_data[((6*16) + 16 - 1):6*16];
 assign pfifo3_data_byte7_16 = pfifo3_rd_data[((7*16) + 16 - 1):7*16];

// INT16, sign extend to 4byte
 assign pfifo0_data_ext_byte0_int16 = {{16{pfifo0_data_byte0_16[15]}}, pfifo0_data_byte0_16[15:0]};
 assign pfifo0_data_ext_byte1_int16 = {{16{pfifo0_data_byte1_16[15]}}, pfifo0_data_byte1_16[15:0]};
 assign pfifo0_data_ext_byte2_int16 = {{16{pfifo0_data_byte2_16[15]}}, pfifo0_data_byte2_16[15:0]};
 assign pfifo0_data_ext_byte3_int16 = {{16{pfifo0_data_byte3_16[15]}}, pfifo0_data_byte3_16[15:0]};
 assign pfifo0_data_ext_byte4_int16 = {{16{pfifo0_data_byte4_16[15]}}, pfifo0_data_byte4_16[15:0]};
 assign pfifo0_data_ext_byte5_int16 = {{16{pfifo0_data_byte5_16[15]}}, pfifo0_data_byte5_16[15:0]};
 assign pfifo0_data_ext_byte6_int16 = {{16{pfifo0_data_byte6_16[15]}}, pfifo0_data_byte6_16[15:0]};
 assign pfifo0_data_ext_byte7_int16 = {{16{pfifo0_data_byte7_16[15]}}, pfifo0_data_byte7_16[15:0]};
 assign pfifo1_data_ext_byte0_int16 = {{16{pfifo1_data_byte0_16[15]}}, pfifo1_data_byte0_16[15:0]};
 assign pfifo1_data_ext_byte1_int16 = {{16{pfifo1_data_byte1_16[15]}}, pfifo1_data_byte1_16[15:0]};
 assign pfifo1_data_ext_byte2_int16 = {{16{pfifo1_data_byte2_16[15]}}, pfifo1_data_byte2_16[15:0]};
 assign pfifo1_data_ext_byte3_int16 = {{16{pfifo1_data_byte3_16[15]}}, pfifo1_data_byte3_16[15:0]};
 assign pfifo1_data_ext_byte4_int16 = {{16{pfifo1_data_byte4_16[15]}}, pfifo1_data_byte4_16[15:0]};
 assign pfifo1_data_ext_byte5_int16 = {{16{pfifo1_data_byte5_16[15]}}, pfifo1_data_byte5_16[15:0]};
 assign pfifo1_data_ext_byte6_int16 = {{16{pfifo1_data_byte6_16[15]}}, pfifo1_data_byte6_16[15:0]};
 assign pfifo1_data_ext_byte7_int16 = {{16{pfifo1_data_byte7_16[15]}}, pfifo1_data_byte7_16[15:0]};
 assign pfifo2_data_ext_byte0_int16 = {{16{pfifo2_data_byte0_16[15]}}, pfifo2_data_byte0_16[15:0]};
 assign pfifo2_data_ext_byte1_int16 = {{16{pfifo2_data_byte1_16[15]}}, pfifo2_data_byte1_16[15:0]};
 assign pfifo2_data_ext_byte2_int16 = {{16{pfifo2_data_byte2_16[15]}}, pfifo2_data_byte2_16[15:0]};
 assign pfifo2_data_ext_byte3_int16 = {{16{pfifo2_data_byte3_16[15]}}, pfifo2_data_byte3_16[15:0]};
 assign pfifo2_data_ext_byte4_int16 = {{16{pfifo2_data_byte4_16[15]}}, pfifo2_data_byte4_16[15:0]};
 assign pfifo2_data_ext_byte5_int16 = {{16{pfifo2_data_byte5_16[15]}}, pfifo2_data_byte5_16[15:0]};
 assign pfifo2_data_ext_byte6_int16 = {{16{pfifo2_data_byte6_16[15]}}, pfifo2_data_byte6_16[15:0]};
 assign pfifo2_data_ext_byte7_int16 = {{16{pfifo2_data_byte7_16[15]}}, pfifo2_data_byte7_16[15:0]};
 assign pfifo3_data_ext_byte0_int16 = {{16{pfifo3_data_byte0_16[15]}}, pfifo3_data_byte0_16[15:0]};
 assign pfifo3_data_ext_byte1_int16 = {{16{pfifo3_data_byte1_16[15]}}, pfifo3_data_byte1_16[15:0]};
 assign pfifo3_data_ext_byte2_int16 = {{16{pfifo3_data_byte2_16[15]}}, pfifo3_data_byte2_16[15:0]};
 assign pfifo3_data_ext_byte3_int16 = {{16{pfifo3_data_byte3_16[15]}}, pfifo3_data_byte3_16[15:0]};
 assign pfifo3_data_ext_byte4_int16 = {{16{pfifo3_data_byte4_16[15]}}, pfifo3_data_byte4_16[15:0]};
 assign pfifo3_data_ext_byte5_int16 = {{16{pfifo3_data_byte5_16[15]}}, pfifo3_data_byte5_16[15:0]};
 assign pfifo3_data_ext_byte6_int16 = {{16{pfifo3_data_byte6_16[15]}}, pfifo3_data_byte6_16[15:0]};
 assign pfifo3_data_ext_byte7_int16 = {{16{pfifo3_data_byte7_16[15]}}, pfifo3_data_byte7_16[15:0]};

// FP16, FP16 -> FP32
 assign pfifo0_data_ext_byte0_fp16 = func_fp16_to_fp32(pfifo0_data_byte0_16);
 assign pfifo0_data_ext_byte1_fp16 = func_fp16_to_fp32(pfifo0_data_byte1_16);
 assign pfifo0_data_ext_byte2_fp16 = func_fp16_to_fp32(pfifo0_data_byte2_16);
 assign pfifo0_data_ext_byte3_fp16 = func_fp16_to_fp32(pfifo0_data_byte3_16);
 assign pfifo0_data_ext_byte4_fp16 = func_fp16_to_fp32(pfifo0_data_byte4_16);
 assign pfifo0_data_ext_byte5_fp16 = func_fp16_to_fp32(pfifo0_data_byte5_16);
 assign pfifo0_data_ext_byte6_fp16 = func_fp16_to_fp32(pfifo0_data_byte6_16);
 assign pfifo0_data_ext_byte7_fp16 = func_fp16_to_fp32(pfifo0_data_byte7_16);
 assign pfifo1_data_ext_byte0_fp16 = func_fp16_to_fp32(pfifo1_data_byte0_16);
 assign pfifo1_data_ext_byte1_fp16 = func_fp16_to_fp32(pfifo1_data_byte1_16);
 assign pfifo1_data_ext_byte2_fp16 = func_fp16_to_fp32(pfifo1_data_byte2_16);
 assign pfifo1_data_ext_byte3_fp16 = func_fp16_to_fp32(pfifo1_data_byte3_16);
 assign pfifo1_data_ext_byte4_fp16 = func_fp16_to_fp32(pfifo1_data_byte4_16);
 assign pfifo1_data_ext_byte5_fp16 = func_fp16_to_fp32(pfifo1_data_byte5_16);
 assign pfifo1_data_ext_byte6_fp16 = func_fp16_to_fp32(pfifo1_data_byte6_16);
 assign pfifo1_data_ext_byte7_fp16 = func_fp16_to_fp32(pfifo1_data_byte7_16);
 assign pfifo2_data_ext_byte0_fp16 = func_fp16_to_fp32(pfifo2_data_byte0_16);
 assign pfifo2_data_ext_byte1_fp16 = func_fp16_to_fp32(pfifo2_data_byte1_16);
 assign pfifo2_data_ext_byte2_fp16 = func_fp16_to_fp32(pfifo2_data_byte2_16);
 assign pfifo2_data_ext_byte3_fp16 = func_fp16_to_fp32(pfifo2_data_byte3_16);
 assign pfifo2_data_ext_byte4_fp16 = func_fp16_to_fp32(pfifo2_data_byte4_16);
 assign pfifo2_data_ext_byte5_fp16 = func_fp16_to_fp32(pfifo2_data_byte5_16);
 assign pfifo2_data_ext_byte6_fp16 = func_fp16_to_fp32(pfifo2_data_byte6_16);
 assign pfifo2_data_ext_byte7_fp16 = func_fp16_to_fp32(pfifo2_data_byte7_16);
 assign pfifo3_data_ext_byte0_fp16 = func_fp16_to_fp32(pfifo3_data_byte0_16);
 assign pfifo3_data_ext_byte1_fp16 = func_fp16_to_fp32(pfifo3_data_byte1_16);
 assign pfifo3_data_ext_byte2_fp16 = func_fp16_to_fp32(pfifo3_data_byte2_16);
 assign pfifo3_data_ext_byte3_fp16 = func_fp16_to_fp32(pfifo3_data_byte3_16);
 assign pfifo3_data_ext_byte4_fp16 = func_fp16_to_fp32(pfifo3_data_byte4_16);
 assign pfifo3_data_ext_byte5_fp16 = func_fp16_to_fp32(pfifo3_data_byte5_16);
 assign pfifo3_data_ext_byte6_fp16 = func_fp16_to_fp32(pfifo3_data_byte6_16);
 assign pfifo3_data_ext_byte7_fp16 = func_fp16_to_fp32(pfifo3_data_byte7_16);

 assign pfifo0_data_ext_byte0_16 = cfg_di_fp16  ? pfifo0_data_ext_byte0_fp16 : pfifo0_data_ext_byte0_int16;
 assign pfifo0_data_ext_byte1_16 = cfg_di_fp16  ? pfifo0_data_ext_byte1_fp16 : pfifo0_data_ext_byte1_int16;
 assign pfifo0_data_ext_byte2_16 = cfg_di_fp16  ? pfifo0_data_ext_byte2_fp16 : pfifo0_data_ext_byte2_int16;
 assign pfifo0_data_ext_byte3_16 = cfg_di_fp16  ? pfifo0_data_ext_byte3_fp16 : pfifo0_data_ext_byte3_int16;
 assign pfifo0_data_ext_byte4_16 = cfg_di_fp16  ? pfifo0_data_ext_byte4_fp16 : pfifo0_data_ext_byte4_int16;
 assign pfifo0_data_ext_byte5_16 = cfg_di_fp16  ? pfifo0_data_ext_byte5_fp16 : pfifo0_data_ext_byte5_int16;
 assign pfifo0_data_ext_byte6_16 = cfg_di_fp16  ? pfifo0_data_ext_byte6_fp16 : pfifo0_data_ext_byte6_int16;
 assign pfifo0_data_ext_byte7_16 = cfg_di_fp16  ? pfifo0_data_ext_byte7_fp16 : pfifo0_data_ext_byte7_int16;
 assign pfifo1_data_ext_byte0_16 = cfg_di_fp16  ? pfifo1_data_ext_byte0_fp16 : pfifo1_data_ext_byte0_int16;
 assign pfifo1_data_ext_byte1_16 = cfg_di_fp16  ? pfifo1_data_ext_byte1_fp16 : pfifo1_data_ext_byte1_int16;
 assign pfifo1_data_ext_byte2_16 = cfg_di_fp16  ? pfifo1_data_ext_byte2_fp16 : pfifo1_data_ext_byte2_int16;
 assign pfifo1_data_ext_byte3_16 = cfg_di_fp16  ? pfifo1_data_ext_byte3_fp16 : pfifo1_data_ext_byte3_int16;
 assign pfifo1_data_ext_byte4_16 = cfg_di_fp16  ? pfifo1_data_ext_byte4_fp16 : pfifo1_data_ext_byte4_int16;
 assign pfifo1_data_ext_byte5_16 = cfg_di_fp16  ? pfifo1_data_ext_byte5_fp16 : pfifo1_data_ext_byte5_int16;
 assign pfifo1_data_ext_byte6_16 = cfg_di_fp16  ? pfifo1_data_ext_byte6_fp16 : pfifo1_data_ext_byte6_int16;
 assign pfifo1_data_ext_byte7_16 = cfg_di_fp16  ? pfifo1_data_ext_byte7_fp16 : pfifo1_data_ext_byte7_int16;
 assign pfifo2_data_ext_byte0_16 = cfg_di_fp16  ? pfifo2_data_ext_byte0_fp16 : pfifo2_data_ext_byte0_int16;
 assign pfifo2_data_ext_byte1_16 = cfg_di_fp16  ? pfifo2_data_ext_byte1_fp16 : pfifo2_data_ext_byte1_int16;
 assign pfifo2_data_ext_byte2_16 = cfg_di_fp16  ? pfifo2_data_ext_byte2_fp16 : pfifo2_data_ext_byte2_int16;
 assign pfifo2_data_ext_byte3_16 = cfg_di_fp16  ? pfifo2_data_ext_byte3_fp16 : pfifo2_data_ext_byte3_int16;
 assign pfifo2_data_ext_byte4_16 = cfg_di_fp16  ? pfifo2_data_ext_byte4_fp16 : pfifo2_data_ext_byte4_int16;
 assign pfifo2_data_ext_byte5_16 = cfg_di_fp16  ? pfifo2_data_ext_byte5_fp16 : pfifo2_data_ext_byte5_int16;
 assign pfifo2_data_ext_byte6_16 = cfg_di_fp16  ? pfifo2_data_ext_byte6_fp16 : pfifo2_data_ext_byte6_int16;
 assign pfifo2_data_ext_byte7_16 = cfg_di_fp16  ? pfifo2_data_ext_byte7_fp16 : pfifo2_data_ext_byte7_int16;
 assign pfifo3_data_ext_byte0_16 = cfg_di_fp16  ? pfifo3_data_ext_byte0_fp16 : pfifo3_data_ext_byte0_int16;
 assign pfifo3_data_ext_byte1_16 = cfg_di_fp16  ? pfifo3_data_ext_byte1_fp16 : pfifo3_data_ext_byte1_int16;
 assign pfifo3_data_ext_byte2_16 = cfg_di_fp16  ? pfifo3_data_ext_byte2_fp16 : pfifo3_data_ext_byte2_int16;
 assign pfifo3_data_ext_byte3_16 = cfg_di_fp16  ? pfifo3_data_ext_byte3_fp16 : pfifo3_data_ext_byte3_int16;
 assign pfifo3_data_ext_byte4_16 = cfg_di_fp16  ? pfifo3_data_ext_byte4_fp16 : pfifo3_data_ext_byte4_int16;
 assign pfifo3_data_ext_byte5_16 = cfg_di_fp16  ? pfifo3_data_ext_byte5_fp16 : pfifo3_data_ext_byte5_int16;
 assign pfifo3_data_ext_byte6_16 = cfg_di_fp16  ? pfifo3_data_ext_byte6_fp16 : pfifo3_data_ext_byte6_int16;
 assign pfifo3_data_ext_byte7_16 = cfg_di_fp16  ? pfifo3_data_ext_byte7_fp16 : pfifo3_data_ext_byte7_int16;

// INT/FP 16, concate
assign pfifo0_data_16 = {pfifo0_data_ext_byte7_16 , pfifo0_data_ext_byte6_16 , pfifo0_data_ext_byte5_16 , pfifo0_data_ext_byte4_16 , pfifo0_data_ext_byte3_16 , pfifo0_data_ext_byte2_16 , pfifo0_data_ext_byte1_16 , pfifo0_data_ext_byte0_16};
assign pfifo1_data_16 = {pfifo1_data_ext_byte7_16 , pfifo1_data_ext_byte6_16 , pfifo1_data_ext_byte5_16 , pfifo1_data_ext_byte4_16 , pfifo1_data_ext_byte3_16 , pfifo1_data_ext_byte2_16 , pfifo1_data_ext_byte1_16 , pfifo1_data_ext_byte0_16};
assign pfifo2_data_16 = {pfifo2_data_ext_byte7_16 , pfifo2_data_ext_byte6_16 , pfifo2_data_ext_byte5_16 , pfifo2_data_ext_byte4_16 , pfifo2_data_ext_byte3_16 , pfifo2_data_ext_byte2_16 , pfifo2_data_ext_byte1_16 , pfifo2_data_ext_byte0_16};
assign pfifo3_data_16 = {pfifo3_data_ext_byte7_16 , pfifo3_data_ext_byte6_16 , pfifo3_data_ext_byte5_16 , pfifo3_data_ext_byte4_16 , pfifo3_data_ext_byte3_16 , pfifo3_data_ext_byte2_16 , pfifo3_data_ext_byte1_16 , pfifo3_data_ext_byte0_16};

assign pfifo_data0_16 = {pfifo1_data_16,pfifo0_data_16};
assign pfifo_data1_16 = {pfifo3_data_16,pfifo2_data_16};

// INT8, split into 1byte
 assign pfifo0_data_byte0_8 = pfifo0_rd_data[((0*8) + 8 - 1):0*8];
 assign pfifo0_data_byte1_8 = pfifo0_rd_data[((1*8) + 8 - 1):1*8];
 assign pfifo0_data_byte2_8 = pfifo0_rd_data[((2*8) + 8 - 1):2*8];
 assign pfifo0_data_byte3_8 = pfifo0_rd_data[((3*8) + 8 - 1):3*8];
 assign pfifo0_data_byte4_8 = pfifo0_rd_data[((4*8) + 8 - 1):4*8];
 assign pfifo0_data_byte5_8 = pfifo0_rd_data[((5*8) + 8 - 1):5*8];
 assign pfifo0_data_byte6_8 = pfifo0_rd_data[((6*8) + 8 - 1):6*8];
 assign pfifo0_data_byte7_8 = pfifo0_rd_data[((7*8) + 8 - 1):7*8];
 assign pfifo0_data_byte8_8 = pfifo0_rd_data[((8*8) + 8 - 1):8*8];
 assign pfifo0_data_byte9_8 = pfifo0_rd_data[((9*8) + 8 - 1):9*8];
 assign pfifo0_data_byte10_8 = pfifo0_rd_data[((10*8) + 8 - 1):10*8];
 assign pfifo0_data_byte11_8 = pfifo0_rd_data[((11*8) + 8 - 1):11*8];
 assign pfifo0_data_byte12_8 = pfifo0_rd_data[((12*8) + 8 - 1):12*8];
 assign pfifo0_data_byte13_8 = pfifo0_rd_data[((13*8) + 8 - 1):13*8];
 assign pfifo0_data_byte14_8 = pfifo0_rd_data[((14*8) + 8 - 1):14*8];
 assign pfifo0_data_byte15_8 = pfifo0_rd_data[((15*8) + 8 - 1):15*8];
 assign pfifo1_data_byte0_8 = pfifo1_rd_data[((0*8) + 8 - 1):0*8];
 assign pfifo1_data_byte1_8 = pfifo1_rd_data[((1*8) + 8 - 1):1*8];
 assign pfifo1_data_byte2_8 = pfifo1_rd_data[((2*8) + 8 - 1):2*8];
 assign pfifo1_data_byte3_8 = pfifo1_rd_data[((3*8) + 8 - 1):3*8];
 assign pfifo1_data_byte4_8 = pfifo1_rd_data[((4*8) + 8 - 1):4*8];
 assign pfifo1_data_byte5_8 = pfifo1_rd_data[((5*8) + 8 - 1):5*8];
 assign pfifo1_data_byte6_8 = pfifo1_rd_data[((6*8) + 8 - 1):6*8];
 assign pfifo1_data_byte7_8 = pfifo1_rd_data[((7*8) + 8 - 1):7*8];
 assign pfifo1_data_byte8_8 = pfifo1_rd_data[((8*8) + 8 - 1):8*8];
 assign pfifo1_data_byte9_8 = pfifo1_rd_data[((9*8) + 8 - 1):9*8];
 assign pfifo1_data_byte10_8 = pfifo1_rd_data[((10*8) + 8 - 1):10*8];
 assign pfifo1_data_byte11_8 = pfifo1_rd_data[((11*8) + 8 - 1):11*8];
 assign pfifo1_data_byte12_8 = pfifo1_rd_data[((12*8) + 8 - 1):12*8];
 assign pfifo1_data_byte13_8 = pfifo1_rd_data[((13*8) + 8 - 1):13*8];
 assign pfifo1_data_byte14_8 = pfifo1_rd_data[((14*8) + 8 - 1):14*8];
 assign pfifo1_data_byte15_8 = pfifo1_rd_data[((15*8) + 8 - 1):15*8];
 assign pfifo2_data_byte0_8 = pfifo2_rd_data[((0*8) + 8 - 1):0*8];
 assign pfifo2_data_byte1_8 = pfifo2_rd_data[((1*8) + 8 - 1):1*8];
 assign pfifo2_data_byte2_8 = pfifo2_rd_data[((2*8) + 8 - 1):2*8];
 assign pfifo2_data_byte3_8 = pfifo2_rd_data[((3*8) + 8 - 1):3*8];
 assign pfifo2_data_byte4_8 = pfifo2_rd_data[((4*8) + 8 - 1):4*8];
 assign pfifo2_data_byte5_8 = pfifo2_rd_data[((5*8) + 8 - 1):5*8];
 assign pfifo2_data_byte6_8 = pfifo2_rd_data[((6*8) + 8 - 1):6*8];
 assign pfifo2_data_byte7_8 = pfifo2_rd_data[((7*8) + 8 - 1):7*8];
 assign pfifo2_data_byte8_8 = pfifo2_rd_data[((8*8) + 8 - 1):8*8];
 assign pfifo2_data_byte9_8 = pfifo2_rd_data[((9*8) + 8 - 1):9*8];
 assign pfifo2_data_byte10_8 = pfifo2_rd_data[((10*8) + 8 - 1):10*8];
 assign pfifo2_data_byte11_8 = pfifo2_rd_data[((11*8) + 8 - 1):11*8];
 assign pfifo2_data_byte12_8 = pfifo2_rd_data[((12*8) + 8 - 1):12*8];
 assign pfifo2_data_byte13_8 = pfifo2_rd_data[((13*8) + 8 - 1):13*8];
 assign pfifo2_data_byte14_8 = pfifo2_rd_data[((14*8) + 8 - 1):14*8];
 assign pfifo2_data_byte15_8 = pfifo2_rd_data[((15*8) + 8 - 1):15*8];
 assign pfifo3_data_byte0_8 = pfifo3_rd_data[((0*8) + 8 - 1):0*8];
 assign pfifo3_data_byte1_8 = pfifo3_rd_data[((1*8) + 8 - 1):1*8];
 assign pfifo3_data_byte2_8 = pfifo3_rd_data[((2*8) + 8 - 1):2*8];
 assign pfifo3_data_byte3_8 = pfifo3_rd_data[((3*8) + 8 - 1):3*8];
 assign pfifo3_data_byte4_8 = pfifo3_rd_data[((4*8) + 8 - 1):4*8];
 assign pfifo3_data_byte5_8 = pfifo3_rd_data[((5*8) + 8 - 1):5*8];
 assign pfifo3_data_byte6_8 = pfifo3_rd_data[((6*8) + 8 - 1):6*8];
 assign pfifo3_data_byte7_8 = pfifo3_rd_data[((7*8) + 8 - 1):7*8];
 assign pfifo3_data_byte8_8 = pfifo3_rd_data[((8*8) + 8 - 1):8*8];
 assign pfifo3_data_byte9_8 = pfifo3_rd_data[((9*8) + 8 - 1):9*8];
 assign pfifo3_data_byte10_8 = pfifo3_rd_data[((10*8) + 8 - 1):10*8];
 assign pfifo3_data_byte11_8 = pfifo3_rd_data[((11*8) + 8 - 1):11*8];
 assign pfifo3_data_byte12_8 = pfifo3_rd_data[((12*8) + 8 - 1):12*8];
 assign pfifo3_data_byte13_8 = pfifo3_rd_data[((13*8) + 8 - 1):13*8];
 assign pfifo3_data_byte14_8 = pfifo3_rd_data[((14*8) + 8 - 1):14*8];
 assign pfifo3_data_byte15_8 = pfifo3_rd_data[((15*8) + 8 - 1):15*8];

// INT8, sign extend to 4byte
 assign pfifo0_data_ext_byte0_8 = {{24{pfifo0_data_byte0_8[7]}}, pfifo0_data_byte0_8[7:0]};
 assign pfifo0_data_ext_byte1_8 = {{24{pfifo0_data_byte1_8[7]}}, pfifo0_data_byte1_8[7:0]};
 assign pfifo0_data_ext_byte2_8 = {{24{pfifo0_data_byte2_8[7]}}, pfifo0_data_byte2_8[7:0]};
 assign pfifo0_data_ext_byte3_8 = {{24{pfifo0_data_byte3_8[7]}}, pfifo0_data_byte3_8[7:0]};
 assign pfifo0_data_ext_byte4_8 = {{24{pfifo0_data_byte4_8[7]}}, pfifo0_data_byte4_8[7:0]};
 assign pfifo0_data_ext_byte5_8 = {{24{pfifo0_data_byte5_8[7]}}, pfifo0_data_byte5_8[7:0]};
 assign pfifo0_data_ext_byte6_8 = {{24{pfifo0_data_byte6_8[7]}}, pfifo0_data_byte6_8[7:0]};
 assign pfifo0_data_ext_byte7_8 = {{24{pfifo0_data_byte7_8[7]}}, pfifo0_data_byte7_8[7:0]};
 assign pfifo0_data_ext_byte8_8 = {{24{pfifo0_data_byte8_8[7]}}, pfifo0_data_byte8_8[7:0]};
 assign pfifo0_data_ext_byte9_8 = {{24{pfifo0_data_byte9_8[7]}}, pfifo0_data_byte9_8[7:0]};
 assign pfifo0_data_ext_byte10_8 = {{24{pfifo0_data_byte10_8[7]}}, pfifo0_data_byte10_8[7:0]};
 assign pfifo0_data_ext_byte11_8 = {{24{pfifo0_data_byte11_8[7]}}, pfifo0_data_byte11_8[7:0]};
 assign pfifo0_data_ext_byte12_8 = {{24{pfifo0_data_byte12_8[7]}}, pfifo0_data_byte12_8[7:0]};
 assign pfifo0_data_ext_byte13_8 = {{24{pfifo0_data_byte13_8[7]}}, pfifo0_data_byte13_8[7:0]};
 assign pfifo0_data_ext_byte14_8 = {{24{pfifo0_data_byte14_8[7]}}, pfifo0_data_byte14_8[7:0]};
 assign pfifo0_data_ext_byte15_8 = {{24{pfifo0_data_byte15_8[7]}}, pfifo0_data_byte15_8[7:0]};
 assign pfifo1_data_ext_byte0_8 = {{24{pfifo1_data_byte0_8[7]}}, pfifo1_data_byte0_8[7:0]};
 assign pfifo1_data_ext_byte1_8 = {{24{pfifo1_data_byte1_8[7]}}, pfifo1_data_byte1_8[7:0]};
 assign pfifo1_data_ext_byte2_8 = {{24{pfifo1_data_byte2_8[7]}}, pfifo1_data_byte2_8[7:0]};
 assign pfifo1_data_ext_byte3_8 = {{24{pfifo1_data_byte3_8[7]}}, pfifo1_data_byte3_8[7:0]};
 assign pfifo1_data_ext_byte4_8 = {{24{pfifo1_data_byte4_8[7]}}, pfifo1_data_byte4_8[7:0]};
 assign pfifo1_data_ext_byte5_8 = {{24{pfifo1_data_byte5_8[7]}}, pfifo1_data_byte5_8[7:0]};
 assign pfifo1_data_ext_byte6_8 = {{24{pfifo1_data_byte6_8[7]}}, pfifo1_data_byte6_8[7:0]};
 assign pfifo1_data_ext_byte7_8 = {{24{pfifo1_data_byte7_8[7]}}, pfifo1_data_byte7_8[7:0]};
 assign pfifo1_data_ext_byte8_8 = {{24{pfifo1_data_byte8_8[7]}}, pfifo1_data_byte8_8[7:0]};
 assign pfifo1_data_ext_byte9_8 = {{24{pfifo1_data_byte9_8[7]}}, pfifo1_data_byte9_8[7:0]};
 assign pfifo1_data_ext_byte10_8 = {{24{pfifo1_data_byte10_8[7]}}, pfifo1_data_byte10_8[7:0]};
 assign pfifo1_data_ext_byte11_8 = {{24{pfifo1_data_byte11_8[7]}}, pfifo1_data_byte11_8[7:0]};
 assign pfifo1_data_ext_byte12_8 = {{24{pfifo1_data_byte12_8[7]}}, pfifo1_data_byte12_8[7:0]};
 assign pfifo1_data_ext_byte13_8 = {{24{pfifo1_data_byte13_8[7]}}, pfifo1_data_byte13_8[7:0]};
 assign pfifo1_data_ext_byte14_8 = {{24{pfifo1_data_byte14_8[7]}}, pfifo1_data_byte14_8[7:0]};
 assign pfifo1_data_ext_byte15_8 = {{24{pfifo1_data_byte15_8[7]}}, pfifo1_data_byte15_8[7:0]};
 assign pfifo2_data_ext_byte0_8 = {{24{pfifo2_data_byte0_8[7]}}, pfifo2_data_byte0_8[7:0]};
 assign pfifo2_data_ext_byte1_8 = {{24{pfifo2_data_byte1_8[7]}}, pfifo2_data_byte1_8[7:0]};
 assign pfifo2_data_ext_byte2_8 = {{24{pfifo2_data_byte2_8[7]}}, pfifo2_data_byte2_8[7:0]};
 assign pfifo2_data_ext_byte3_8 = {{24{pfifo2_data_byte3_8[7]}}, pfifo2_data_byte3_8[7:0]};
 assign pfifo2_data_ext_byte4_8 = {{24{pfifo2_data_byte4_8[7]}}, pfifo2_data_byte4_8[7:0]};
 assign pfifo2_data_ext_byte5_8 = {{24{pfifo2_data_byte5_8[7]}}, pfifo2_data_byte5_8[7:0]};
 assign pfifo2_data_ext_byte6_8 = {{24{pfifo2_data_byte6_8[7]}}, pfifo2_data_byte6_8[7:0]};
 assign pfifo2_data_ext_byte7_8 = {{24{pfifo2_data_byte7_8[7]}}, pfifo2_data_byte7_8[7:0]};
 assign pfifo2_data_ext_byte8_8 = {{24{pfifo2_data_byte8_8[7]}}, pfifo2_data_byte8_8[7:0]};
 assign pfifo2_data_ext_byte9_8 = {{24{pfifo2_data_byte9_8[7]}}, pfifo2_data_byte9_8[7:0]};
 assign pfifo2_data_ext_byte10_8 = {{24{pfifo2_data_byte10_8[7]}}, pfifo2_data_byte10_8[7:0]};
 assign pfifo2_data_ext_byte11_8 = {{24{pfifo2_data_byte11_8[7]}}, pfifo2_data_byte11_8[7:0]};
 assign pfifo2_data_ext_byte12_8 = {{24{pfifo2_data_byte12_8[7]}}, pfifo2_data_byte12_8[7:0]};
 assign pfifo2_data_ext_byte13_8 = {{24{pfifo2_data_byte13_8[7]}}, pfifo2_data_byte13_8[7:0]};
 assign pfifo2_data_ext_byte14_8 = {{24{pfifo2_data_byte14_8[7]}}, pfifo2_data_byte14_8[7:0]};
 assign pfifo2_data_ext_byte15_8 = {{24{pfifo2_data_byte15_8[7]}}, pfifo2_data_byte15_8[7:0]};
 assign pfifo3_data_ext_byte0_8 = {{24{pfifo3_data_byte0_8[7]}}, pfifo3_data_byte0_8[7:0]};
 assign pfifo3_data_ext_byte1_8 = {{24{pfifo3_data_byte1_8[7]}}, pfifo3_data_byte1_8[7:0]};
 assign pfifo3_data_ext_byte2_8 = {{24{pfifo3_data_byte2_8[7]}}, pfifo3_data_byte2_8[7:0]};
 assign pfifo3_data_ext_byte3_8 = {{24{pfifo3_data_byte3_8[7]}}, pfifo3_data_byte3_8[7:0]};
 assign pfifo3_data_ext_byte4_8 = {{24{pfifo3_data_byte4_8[7]}}, pfifo3_data_byte4_8[7:0]};
 assign pfifo3_data_ext_byte5_8 = {{24{pfifo3_data_byte5_8[7]}}, pfifo3_data_byte5_8[7:0]};
 assign pfifo3_data_ext_byte6_8 = {{24{pfifo3_data_byte6_8[7]}}, pfifo3_data_byte6_8[7:0]};
 assign pfifo3_data_ext_byte7_8 = {{24{pfifo3_data_byte7_8[7]}}, pfifo3_data_byte7_8[7:0]};
 assign pfifo3_data_ext_byte8_8 = {{24{pfifo3_data_byte8_8[7]}}, pfifo3_data_byte8_8[7:0]};
 assign pfifo3_data_ext_byte9_8 = {{24{pfifo3_data_byte9_8[7]}}, pfifo3_data_byte9_8[7:0]};
 assign pfifo3_data_ext_byte10_8 = {{24{pfifo3_data_byte10_8[7]}}, pfifo3_data_byte10_8[7:0]};
 assign pfifo3_data_ext_byte11_8 = {{24{pfifo3_data_byte11_8[7]}}, pfifo3_data_byte11_8[7:0]};
 assign pfifo3_data_ext_byte12_8 = {{24{pfifo3_data_byte12_8[7]}}, pfifo3_data_byte12_8[7:0]};
 assign pfifo3_data_ext_byte13_8 = {{24{pfifo3_data_byte13_8[7]}}, pfifo3_data_byte13_8[7:0]};
 assign pfifo3_data_ext_byte14_8 = {{24{pfifo3_data_byte14_8[7]}}, pfifo3_data_byte14_8[7:0]};
 assign pfifo3_data_ext_byte15_8 = {{24{pfifo3_data_byte15_8[7]}}, pfifo3_data_byte15_8[7:0]};

// INT8, concate
assign pfifo_data0_8 = {pfifo0_data_ext_byte15_8 , pfifo0_data_ext_byte14_8 , pfifo0_data_ext_byte13_8 , pfifo0_data_ext_byte12_8 , pfifo0_data_ext_byte11_8 , pfifo0_data_ext_byte10_8 , pfifo0_data_ext_byte9_8 , pfifo0_data_ext_byte8_8 , pfifo0_data_ext_byte7_8 , pfifo0_data_ext_byte6_8 , pfifo0_data_ext_byte5_8 , pfifo0_data_ext_byte4_8 , pfifo0_data_ext_byte3_8 , pfifo0_data_ext_byte2_8 , pfifo0_data_ext_byte1_8 , pfifo0_data_ext_byte0_8};
assign pfifo_data1_8 = {pfifo1_data_ext_byte15_8 , pfifo1_data_ext_byte14_8 , pfifo1_data_ext_byte13_8 , pfifo1_data_ext_byte12_8 , pfifo1_data_ext_byte11_8 , pfifo1_data_ext_byte10_8 , pfifo1_data_ext_byte9_8 , pfifo1_data_ext_byte8_8 , pfifo1_data_ext_byte7_8 , pfifo1_data_ext_byte6_8 , pfifo1_data_ext_byte5_8 , pfifo1_data_ext_byte4_8 , pfifo1_data_ext_byte3_8 , pfifo1_data_ext_byte2_8 , pfifo1_data_ext_byte1_8 , pfifo1_data_ext_byte0_8};
assign pfifo_data2_8 = {pfifo2_data_ext_byte15_8 , pfifo2_data_ext_byte14_8 , pfifo2_data_ext_byte13_8 , pfifo2_data_ext_byte12_8 , pfifo2_data_ext_byte11_8 , pfifo2_data_ext_byte10_8 , pfifo2_data_ext_byte9_8 , pfifo2_data_ext_byte8_8 , pfifo2_data_ext_byte7_8 , pfifo2_data_ext_byte6_8 , pfifo2_data_ext_byte5_8 , pfifo2_data_ext_byte4_8 , pfifo2_data_ext_byte3_8 , pfifo2_data_ext_byte2_8 , pfifo2_data_ext_byte1_8 , pfifo2_data_ext_byte0_8};
assign pfifo_data3_8 = {pfifo3_data_ext_byte15_8 , pfifo3_data_ext_byte14_8 , pfifo3_data_ext_byte13_8 , pfifo3_data_ext_byte12_8 , pfifo3_data_ext_byte11_8 , pfifo3_data_ext_byte10_8 , pfifo3_data_ext_byte9_8 , pfifo3_data_ext_byte8_8 , pfifo3_data_ext_byte7_8 , pfifo3_data_ext_byte6_8 , pfifo3_data_ext_byte5_8 , pfifo3_data_ext_byte4_8 , pfifo3_data_ext_byte3_8 , pfifo3_data_ext_byte2_8 , pfifo3_data_ext_byte1_8 , pfifo3_data_ext_byte0_8};

// SFIFO PD
 assign sfifo0_rd_data = {256{sfifo0_sel}} & sfifo0_rd_pd;
 assign sfifo1_rd_data = {256{sfifo1_sel}} & sfifo1_rd_pd;
// INT16, split into 2byte
 assign sfifo0_data_byte0_16 = sfifo0_rd_data[((0*16) + 16 - 1):0*16];
 assign sfifo0_data_byte1_16 = sfifo0_rd_data[((1*16) + 16 - 1):1*16];
 assign sfifo0_data_byte2_16 = sfifo0_rd_data[((2*16) + 16 - 1):2*16];
 assign sfifo0_data_byte3_16 = sfifo0_rd_data[((3*16) + 16 - 1):3*16];
 assign sfifo0_data_byte4_16 = sfifo0_rd_data[((4*16) + 16 - 1):4*16];
 assign sfifo0_data_byte5_16 = sfifo0_rd_data[((5*16) + 16 - 1):5*16];
 assign sfifo0_data_byte6_16 = sfifo0_rd_data[((6*16) + 16 - 1):6*16];
 assign sfifo0_data_byte7_16 = sfifo0_rd_data[((7*16) + 16 - 1):7*16];
 assign sfifo0_data_byte8_16 = sfifo0_rd_data[((8*16) + 16 - 1):8*16];
 assign sfifo0_data_byte9_16 = sfifo0_rd_data[((9*16) + 16 - 1):9*16];
 assign sfifo0_data_byte10_16 = sfifo0_rd_data[((10*16) + 16 - 1):10*16];
 assign sfifo0_data_byte11_16 = sfifo0_rd_data[((11*16) + 16 - 1):11*16];
 assign sfifo0_data_byte12_16 = sfifo0_rd_data[((12*16) + 16 - 1):12*16];
 assign sfifo0_data_byte13_16 = sfifo0_rd_data[((13*16) + 16 - 1):13*16];
 assign sfifo0_data_byte14_16 = sfifo0_rd_data[((14*16) + 16 - 1):14*16];
 assign sfifo0_data_byte15_16 = sfifo0_rd_data[((15*16) + 16 - 1):15*16];
 assign sfifo1_data_byte0_16 = sfifo1_rd_data[((0*16) + 16 - 1):0*16];
 assign sfifo1_data_byte1_16 = sfifo1_rd_data[((1*16) + 16 - 1):1*16];
 assign sfifo1_data_byte2_16 = sfifo1_rd_data[((2*16) + 16 - 1):2*16];
 assign sfifo1_data_byte3_16 = sfifo1_rd_data[((3*16) + 16 - 1):3*16];
 assign sfifo1_data_byte4_16 = sfifo1_rd_data[((4*16) + 16 - 1):4*16];
 assign sfifo1_data_byte5_16 = sfifo1_rd_data[((5*16) + 16 - 1):5*16];
 assign sfifo1_data_byte6_16 = sfifo1_rd_data[((6*16) + 16 - 1):6*16];
 assign sfifo1_data_byte7_16 = sfifo1_rd_data[((7*16) + 16 - 1):7*16];
 assign sfifo1_data_byte8_16 = sfifo1_rd_data[((8*16) + 16 - 1):8*16];
 assign sfifo1_data_byte9_16 = sfifo1_rd_data[((9*16) + 16 - 1):9*16];
 assign sfifo1_data_byte10_16 = sfifo1_rd_data[((10*16) + 16 - 1):10*16];
 assign sfifo1_data_byte11_16 = sfifo1_rd_data[((11*16) + 16 - 1):11*16];
 assign sfifo1_data_byte12_16 = sfifo1_rd_data[((12*16) + 16 - 1):12*16];
 assign sfifo1_data_byte13_16 = sfifo1_rd_data[((13*16) + 16 - 1):13*16];
 assign sfifo1_data_byte14_16 = sfifo1_rd_data[((14*16) + 16 - 1):14*16];
 assign sfifo1_data_byte15_16 = sfifo1_rd_data[((15*16) + 16 - 1):15*16];

// INT16, sign extend to 4byte
 assign sfifo0_data_ext_byte0_16 = {{16{sfifo0_data_byte0_16[15]}}, sfifo0_data_byte0_16[15:0]};
 assign sfifo0_data_ext_byte1_16 = {{16{sfifo0_data_byte1_16[15]}}, sfifo0_data_byte1_16[15:0]};
 assign sfifo0_data_ext_byte2_16 = {{16{sfifo0_data_byte2_16[15]}}, sfifo0_data_byte2_16[15:0]};
 assign sfifo0_data_ext_byte3_16 = {{16{sfifo0_data_byte3_16[15]}}, sfifo0_data_byte3_16[15:0]};
 assign sfifo0_data_ext_byte4_16 = {{16{sfifo0_data_byte4_16[15]}}, sfifo0_data_byte4_16[15:0]};
 assign sfifo0_data_ext_byte5_16 = {{16{sfifo0_data_byte5_16[15]}}, sfifo0_data_byte5_16[15:0]};
 assign sfifo0_data_ext_byte6_16 = {{16{sfifo0_data_byte6_16[15]}}, sfifo0_data_byte6_16[15:0]};
 assign sfifo0_data_ext_byte7_16 = {{16{sfifo0_data_byte7_16[15]}}, sfifo0_data_byte7_16[15:0]};
 assign sfifo0_data_ext_byte8_16 = {{16{sfifo0_data_byte8_16[15]}}, sfifo0_data_byte8_16[15:0]};
 assign sfifo0_data_ext_byte9_16 = {{16{sfifo0_data_byte9_16[15]}}, sfifo0_data_byte9_16[15:0]};
 assign sfifo0_data_ext_byte10_16 = {{16{sfifo0_data_byte10_16[15]}}, sfifo0_data_byte10_16[15:0]};
 assign sfifo0_data_ext_byte11_16 = {{16{sfifo0_data_byte11_16[15]}}, sfifo0_data_byte11_16[15:0]};
 assign sfifo0_data_ext_byte12_16 = {{16{sfifo0_data_byte12_16[15]}}, sfifo0_data_byte12_16[15:0]};
 assign sfifo0_data_ext_byte13_16 = {{16{sfifo0_data_byte13_16[15]}}, sfifo0_data_byte13_16[15:0]};
 assign sfifo0_data_ext_byte14_16 = {{16{sfifo0_data_byte14_16[15]}}, sfifo0_data_byte14_16[15:0]};
 assign sfifo0_data_ext_byte15_16 = {{16{sfifo0_data_byte15_16[15]}}, sfifo0_data_byte15_16[15:0]};
 assign sfifo1_data_ext_byte0_16 = {{16{sfifo1_data_byte0_16[15]}}, sfifo1_data_byte0_16[15:0]};
 assign sfifo1_data_ext_byte1_16 = {{16{sfifo1_data_byte1_16[15]}}, sfifo1_data_byte1_16[15:0]};
 assign sfifo1_data_ext_byte2_16 = {{16{sfifo1_data_byte2_16[15]}}, sfifo1_data_byte2_16[15:0]};
 assign sfifo1_data_ext_byte3_16 = {{16{sfifo1_data_byte3_16[15]}}, sfifo1_data_byte3_16[15:0]};
 assign sfifo1_data_ext_byte4_16 = {{16{sfifo1_data_byte4_16[15]}}, sfifo1_data_byte4_16[15:0]};
 assign sfifo1_data_ext_byte5_16 = {{16{sfifo1_data_byte5_16[15]}}, sfifo1_data_byte5_16[15:0]};
 assign sfifo1_data_ext_byte6_16 = {{16{sfifo1_data_byte6_16[15]}}, sfifo1_data_byte6_16[15:0]};
 assign sfifo1_data_ext_byte7_16 = {{16{sfifo1_data_byte7_16[15]}}, sfifo1_data_byte7_16[15:0]};
 assign sfifo1_data_ext_byte8_16 = {{16{sfifo1_data_byte8_16[15]}}, sfifo1_data_byte8_16[15:0]};
 assign sfifo1_data_ext_byte9_16 = {{16{sfifo1_data_byte9_16[15]}}, sfifo1_data_byte9_16[15:0]};
 assign sfifo1_data_ext_byte10_16 = {{16{sfifo1_data_byte10_16[15]}}, sfifo1_data_byte10_16[15:0]};
 assign sfifo1_data_ext_byte11_16 = {{16{sfifo1_data_byte11_16[15]}}, sfifo1_data_byte11_16[15:0]};
 assign sfifo1_data_ext_byte12_16 = {{16{sfifo1_data_byte12_16[15]}}, sfifo1_data_byte12_16[15:0]};
 assign sfifo1_data_ext_byte13_16 = {{16{sfifo1_data_byte13_16[15]}}, sfifo1_data_byte13_16[15:0]};
 assign sfifo1_data_ext_byte14_16 = {{16{sfifo1_data_byte14_16[15]}}, sfifo1_data_byte14_16[15:0]};
 assign sfifo1_data_ext_byte15_16 = {{16{sfifo1_data_byte15_16[15]}}, sfifo1_data_byte15_16[15:0]};

// INT16, concate
assign sfifo0_data_16 = {sfifo0_data_ext_byte15_16 , sfifo0_data_ext_byte14_16 , sfifo0_data_ext_byte13_16 , sfifo0_data_ext_byte12_16 , sfifo0_data_ext_byte11_16 , sfifo0_data_ext_byte10_16 , sfifo0_data_ext_byte9_16 , sfifo0_data_ext_byte8_16 , sfifo0_data_ext_byte7_16 , sfifo0_data_ext_byte6_16 , sfifo0_data_ext_byte5_16 , sfifo0_data_ext_byte4_16 , sfifo0_data_ext_byte3_16 , sfifo0_data_ext_byte2_16 , sfifo0_data_ext_byte1_16 , sfifo0_data_ext_byte0_16};
assign sfifo1_data_16 = {sfifo1_data_ext_byte15_16 , sfifo1_data_ext_byte14_16 , sfifo1_data_ext_byte13_16 , sfifo1_data_ext_byte12_16 , sfifo1_data_ext_byte11_16 , sfifo1_data_ext_byte10_16 , sfifo1_data_ext_byte9_16 , sfifo1_data_ext_byte8_16 , sfifo1_data_ext_byte7_16 , sfifo1_data_ext_byte6_16 , sfifo1_data_ext_byte5_16 , sfifo1_data_ext_byte4_16 , sfifo1_data_ext_byte3_16 , sfifo1_data_ext_byte2_16 , sfifo1_data_ext_byte1_16 , sfifo1_data_ext_byte0_16};

assign sfifo_data0_16 = sfifo0_data_16;
assign sfifo_data1_16 = sfifo1_data_16;

//spyglass disable_block W171 W226
always @(
  pfifo0_sel
  or pfifo_data0_8
  or pfifo1_sel
  or pfifo_data1_8
  or pfifo2_sel
  or pfifo_data2_8
  or pfifo3_sel
  or pfifo_data3_8
  ) begin
    case (1'b1)
     pfifo0_sel: pfifo_data_8 = pfifo_data0_8;
     pfifo1_sel: pfifo_data_8 = pfifo_data1_8;
     pfifo2_sel: pfifo_data_8 = pfifo_data2_8;
     pfifo3_sel: pfifo_data_8 = pfifo_data3_8;
    //VCS coverage off
    default : begin 
                pfifo_data_8[511:0] = {512{`x_or_0}};
              end  
    //VCS coverage on
    endcase
end
always @(
  pfifo0_sel
  or pfifo_data0_16
  or pfifo2_sel
  or pfifo_data1_16
  ) begin
    case (1'b1)
     pfifo0_sel: pfifo_data_16 = pfifo_data0_16;
     pfifo2_sel: pfifo_data_16 = pfifo_data1_16;
    //VCS coverage off
    default : begin 
                pfifo_data_16[511:0] = {512{`x_or_0}};
              end  
    //VCS coverage on
    endcase
end
assign pfifo_data = cfg_di_16 ? pfifo_data_16 : pfifo_data_8;

always @(
  sfifo0_sel
  or sfifo_data0_16
  or sfifo1_sel
  or sfifo_data1_16
  ) begin
    case (1'b1)
     sfifo0_sel: sfifo_data = sfifo_data0_16;
     sfifo1_sel: sfifo_data = sfifo_data1_16;
    //VCS coverage off
    default : begin 
                sfifo_data[511:0] = {512{`x_or_0}};
              end  
    //VCS coverage on
    endcase
end

assign pfifo_sel = {pfifo3_sel | pfifo2_sel | pfifo1_sel | pfifo0_sel};
assign sfifo_sel = {sfifo1_sel | sfifo0_sel};
assign dat_data = pfifo_sel ? pfifo_data : sfifo_sel ? sfifo_data : 512'h0;
assign dat_accept  = dat_vld & dat_rdy;

assign dat_layer_end = cmd_cube_end & is_last_beat;
assign dat_batch_end = cmd_cube_end & is_last_beat;

// PKT_PACK_WIRE( sdp_mrdma2cmux , dat_ , dat_pd )
assign      dat_pd[511:0] =    dat_data[511:0];
assign      dat_pd[512] =    dat_batch_end ;
assign      dat_pd[513] =    dat_layer_end ;
//assign sdp_mrdma2cmux_pd = dat_pd;
//assign sdp_mrdma2cmux_valid = dat_vld;
//assign dat_rdy = sdp_mrdma2cmux_ready;;
NV_NVDLA_SDP_MRDMA_EG_DOUT_pipe_p1 pipe_p1 (
   .nvdla_core_clk       (nvdla_core_clk)           //|< i
  ,.nvdla_core_rstn      (nvdla_core_rstn)          //|< i
  ,.dat_pd               (dat_pd[513:0])            //|< w
  ,.dat_vld              (dat_vld)                  //|< w
  ,.sdp_mrdma2cmux_ready (sdp_mrdma2cmux_ready)     //|< i
  ,.dat_rdy              (dat_rdy)                  //|> w
  ,.sdp_mrdma2cmux_pd    (sdp_mrdma2cmux_pd[513:0]) //|> o
  ,.sdp_mrdma2cmux_valid (sdp_mrdma2cmux_valid)     //|> o
  );

//spyglass enable_block W171 W226
assign sdp_mrdma2cmux_layer_end = sdp_mrdma2cmux_pd[513:513];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    eg_done <= 1'b0;
  end else begin
  eg_done <= sdp_mrdma2cmux_layer_end & sdp_mrdma2cmux_valid & sdp_mrdma2cmux_ready;
  end
end
//==========================================
// ASSERTIONS
//==========================================
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
  nv_assert_never #(0,0,"either pfifo or sfifo will be selected")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, pfifo_sel & sfifo_sel); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"int16 mode, 0/1 pfifo need be paired")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, cfg_di_16 & pfifo0_rd_pvld & !pfifo1_rd_pvld); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"int16 mode, 0/1 pfifo need be paired")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, cfg_di_16 & !pfifo0_rd_pvld & pfifo1_rd_pvld); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"int16 mode, 2/3 pfifo need be paired")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, cfg_di_16 & pfifo2_rd_pvld & !pfifo3_rd_pvld); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"int16 mode, 2/3 pfifo need be paired")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, cfg_di_16 & !pfifo2_rd_pvld & pfifo3_rd_pvld); // spyglass disable W504 SelfDeterminedExpr-ML 
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

   //Shift-left - unsigned shift argument one bit more
function [31:0] func_fp16_to_fp32;
    input [15:0] fp16;

    reg is_zero;
    reg is_nan;
    reg is_inf;
    reg is_denm;

    reg [0:0] i_sign;
    reg [4:0] i_expo;
    reg [9:0] i_mant;
    reg [10:0] i_mant_p1;
    reg [23:0] i_mant_p1_ext;
    reg [3:0] zero_cnt;

    reg [0:0] o_sign;
    reg [7:0] o_expo;
    reg [22:0] o_mant;
    reg [23:0] o_mant_p1;

    begin
        i_sign = fp16[15:15];
        i_expo = fp16[14:10];
        i_mant = fp16[9:0];

        is_zero = ((|i_expo)==1'b0) & ((|i_mant)==1'b0);
        is_denm = ((|i_expo)==1'b0) & ((|i_mant)==1'b1);
        is_nan  = ((&i_expo)==1'b1) & ((|i_mant)==1'b1);
        is_inf  = ((&i_expo)==1'b1) & ((|i_mant)==1'b0);

        o_sign = i_sign;
        if (is_zero) begin
            o_expo = 8'h0;
            o_mant = 23'h0;
        end else if (is_denm) begin
            i_mant_p1 = {{1{1'b0}}, i_mant};
            zero_cnt = fun_cnt_lead_zero(i_mant_p1);
            
            o_expo = 127 - 15 + 1 - zero_cnt;

            i_mant_p1_ext = {{14{1'b0}}, i_mant};
            o_mant_p1 = i_mant_p1_ext<<(23-10 + zero_cnt);
            o_mant = o_mant_p1[22:0];

        end else if (is_nan) begin
            o_expo = 8'hff;
            o_mant = {{13{1'b0}}, i_mant};
        end else if (is_inf) begin
            o_expo = 8'hfe;
            o_mant = 23'h7fffff;
        end else begin
            o_expo = i_expo + (127 - 15);
            o_mant = i_mant<<(23-10);
        end

        func_fp16_to_fp32 = {o_sign,o_expo,o_mant};
    end
endfunction // fshl_u

function [3:0] fun_cnt_lead_zero;
  input [10:0] ibits;
  reg [10:0] xbits;
  reg [10:0] ybits;
  reg [10:0] zbits;
  reg [3:0] ocnt;
  begin
    xbits = ibits;
    ybits[10] = xbits[10];
    ybits[9] = |xbits[10:9];
    ybits[8] = |xbits[10:8];
    ybits[7] = |xbits[10:7];
    ybits[6] = |xbits[10:6];
    ybits[5] = |xbits[10:5];
    ybits[4] = |xbits[10:4];
    ybits[3] = |xbits[10:3];
    ybits[2] = |xbits[10:2];
    ybits[1] = |xbits[10:1];
    ybits[0] = |xbits[10:0];
    zbits = ~ybits;
    ocnt =
      zbits[10] +
      zbits[9] +
      zbits[8] +
      zbits[7] +
      zbits[6] +
      zbits[5] +
      zbits[4] +
      zbits[3] +
      zbits[2] +
      zbits[1] +
      zbits[0] ;
    fun_cnt_lead_zero = ocnt;
  end
endfunction


endmodule // NV_NVDLA_SDP_MRDMA_EG_dout



// **************************************************************************************************************
// Generated by ::pipe -m -bc -is sdp_mrdma2cmux_pd (sdp_mrdma2cmux_valid, sdp_mrdma2cmux_ready) <= dat_pd[513:0] (dat_vld,dat_rdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_MRDMA_EG_DOUT_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dat_pd
  ,dat_vld
  ,sdp_mrdma2cmux_ready
  ,dat_rdy
  ,sdp_mrdma2cmux_pd
  ,sdp_mrdma2cmux_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] dat_pd;
input          dat_vld;
input          sdp_mrdma2cmux_ready;
output         dat_rdy;
output [513:0] sdp_mrdma2cmux_pd;
output         sdp_mrdma2cmux_valid;
reg            dat_rdy;
reg    [513:0] p1_pipe_data;
reg    [513:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg    [513:0] p1_skid_data;
reg    [513:0] p1_skid_pipe_data;
reg            p1_skid_pipe_ready;
reg            p1_skid_pipe_valid;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
reg    [513:0] sdp_mrdma2cmux_pd;
reg            sdp_mrdma2cmux_valid;
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     dat_vld
  or p1_pipe_rand_ready
  or dat_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = dat_vld;
  dat_rdy = p1_pipe_rand_ready;
  p1_pipe_rand_data = dat_pd[513:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : dat_vld;
  dat_rdy = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : dat_pd[513:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p1_pipe_stall_cycles;
integer p1_pipe_stall_probability;
integer p1_pipe_stall_cycles_min;
integer p1_pipe_stall_cycles_max;
initial begin
  p1_pipe_stall_cycles = 0;
  p1_pipe_stall_probability = 0;
  p1_pipe_stall_cycles_min = 1;
  p1_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_dout_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_dout_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_dout_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_dout_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_dout_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_dout_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_dout_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or dat_vld
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && dat_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p1_pipe_rand_poised) begin
    if (p1_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p1_pipe_stall_cycles <= prand_inst1(p1_pipe_stall_cycles_min, p1_pipe_stall_cycles_max);
    end
  end else if (p1_pipe_rand_active) begin
    p1_pipe_stall_cycles <= p1_pipe_stall_cycles - 1;
  end else begin
    p1_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (1) skid buffer
always @(
  p1_pipe_rand_valid
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_rand_valid && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_rand_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_rand_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_rand_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_rand_valid
  or p1_skid_valid
  or p1_pipe_rand_data
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? p1_pipe_rand_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? p1_pipe_rand_data : p1_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (1) valid-ready-bubble-collapse
always @(
  p1_pipe_ready
  or p1_pipe_valid
  ) begin
  p1_pipe_ready_bc = p1_pipe_ready || !p1_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_valid <= 1'b0;
  end else begin
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_skid_pipe_valid)? p1_skid_pipe_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_skid_pipe_ready = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or sdp_mrdma2cmux_ready
  or p1_pipe_data
  ) begin
  sdp_mrdma2cmux_valid = p1_pipe_valid;
  p1_pipe_ready = sdp_mrdma2cmux_ready;
  sdp_mrdma2cmux_pd = p1_pipe_data;
end
//## pipe (1) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p1_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sdp_mrdma2cmux_valid^sdp_mrdma2cmux_ready^dat_vld^dat_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_7x (nvdla_core_clk, `ASSERT_RESET, (dat_vld && !dat_rdy), (dat_vld), (dat_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_SDP_MRDMA_EG_DOUT_pipe_p1


