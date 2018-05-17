// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_MRDMA_EG_dout.v

`include "simulate_x_tick.vh"
#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_MRDMA_EG_dout (
   nvdla_core_clk               //|< i
  ,nvdla_core_rstn              //|< i
  ,op_load                      //|< i
  ,eg_done                      //|> o
  ,cmd2dat_dma_pd               //|< i
  ,cmd2dat_dma_pvld             //|< i
  ,cmd2dat_dma_prdy             //|> o
  ,pfifo0_rd_pd                 //|< i
  ,pfifo0_rd_pvld               //|< i
  ,pfifo1_rd_pd                 //|< i
  ,pfifo1_rd_pvld               //|< i
  ,pfifo2_rd_pd                 //|< i
  ,pfifo2_rd_pvld               //|< i
  ,pfifo3_rd_pd                 //|< i
  ,pfifo3_rd_pvld               //|< i
  ,pfifo0_rd_prdy               //|> o
  ,pfifo1_rd_prdy               //|> o
  ,pfifo2_rd_prdy               //|> o
  ,pfifo3_rd_prdy               //|> o
  ,sdp_mrdma2cmux_pd            //|> o
  ,sdp_mrdma2cmux_valid         //|> o
  ,sdp_mrdma2cmux_ready         //|< i
#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
  ,sfifo0_rd_prdy               //|> o
  ,sfifo1_rd_prdy               //|> o
  ,sfifo0_rd_pd                 //|< i
  ,sfifo0_rd_pvld               //|< i
  ,sfifo1_rd_pd                 //|< i
  ,sfifo1_rd_pvld               //|< i
#endif
  ,reg2dp_height                //|< i
  ,reg2dp_width                 //|< i
  ,reg2dp_in_precision          //|< i
  ,reg2dp_proc_precision        //|< i
  ,reg2dp_perf_nan_inf_count_en //|< i
  ,dp2reg_status_inf_input_num  //|> o
  ,dp2reg_status_nan_input_num  //|> o
  );
//
// NV_NVDLA_SDP_MRDMA_EG_dout_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input  op_load;
output eg_done;
input   [12:0] reg2dp_height;
input   [12:0] reg2dp_width;
input    [1:0] reg2dp_in_precision;
input    [1:0] reg2dp_proc_precision;
input          reg2dp_perf_nan_inf_count_en;
output  [31:0] dp2reg_status_inf_input_num;
output  [31:0] dp2reg_status_nan_input_num;

output         sdp_mrdma2cmux_valid;  
input          sdp_mrdma2cmux_ready;  
output [DP_DIN_DW+1:0] sdp_mrdma2cmux_pd;

input         cmd2dat_dma_pvld;  
output        cmd2dat_dma_prdy;  
input  [14:0] cmd2dat_dma_pd;

input          pfifo0_rd_pvld;  
output         pfifo0_rd_prdy;  
input  [AM_DW-1:0] pfifo0_rd_pd;

input          pfifo1_rd_pvld;  
output         pfifo1_rd_prdy;  
input  [AM_DW-1:0] pfifo1_rd_pd;

input          pfifo2_rd_pvld;  
output         pfifo2_rd_prdy;  
input  [AM_DW-1:0] pfifo2_rd_pd;

input          pfifo3_rd_pvld;  
output         pfifo3_rd_prdy;  
input  [AM_DW-1:0] pfifo3_rd_pd;

#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
input          sfifo0_rd_pvld;  
output         sfifo0_rd_prdy;  
input  [255:0] sfifo0_rd_pd;
input          sfifo1_rd_pvld;  
output         sfifo1_rd_prdy;  
input  [255:0] sfifo1_rd_pd;

reg    [511:0] sfifo_data;
wire           cfg_mode_16to8;
wire           mode_16to8_sfifo0_sel;
wire           mode_16to8_sfifo1_sel;
#endif

reg            eg_done;
wire           cfg_di_16;
wire           cfg_di_fp16;
wire           cfg_di_int16;
wire           cfg_di_int8;
wire           cfg_do_int8;
wire           cfg_mode_1x1_pack;
wire           cfg_perf_nan_inf_count_en;
wire    [13:0] size_of_beat;
reg     [13:0] beat_cnt;
wire           is_last_beat;
wire           cmd2dat_dma_cube_end;
wire    [13:0] cmd2dat_dma_size;
wire           cmd_cube_end;
wire           dat_accept;
wire           dat_batch_end;
wire   [DP_DIN_DW-1:0] dat_data;
wire           dat_layer_end;
wire   [DP_DIN_DW+1:0] dat_pd;
wire           dat_rdy;
wire           dat_vld;
wire           fifo_vld;

wire           pfifo0_sel;
wire           pfifo1_sel;
wire           pfifo2_sel;
wire           pfifo3_sel;
wire   [AM_DW-1:0] pfifo0_rd_data;
wire   [AM_DW-1:0] pfifo1_rd_data;
wire   [AM_DW-1:0] pfifo2_rd_data;
wire   [AM_DW-1:0] pfifo3_rd_data;

//: my $k  = NVDLA_MEMORY_ATOMIC_SIZE/2;
//: foreach my $j  (0..3) {
//: foreach my $i  (0..${k}-1) {
//: print "wire    [15:0] pfifo${j}_data_byte${i}_16; \n";
//: }
//: }
//: foreach my $j  (0..3) {
//: foreach my $i  (0..${k}-1) {
//: print "wire    [31:0] pfifo${j}_data_ext_byte${i}_int16; \n";
//: print "wire    [31:0] pfifo${j}_data_ext_byte${i}_16; \n";
//: }
//: }
//: my $k  = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $dw = $k * 8 -1;
//: foreach my $j  (0..3) {
//: foreach my $i  (0..${k}-1) {
//: print "wire     [7:0] pfifo${j}_data_byte${i}_8; \n";
//: }
//: }
//: foreach my $j  (0..3) {
//: foreach my $i  (0..${k}-1) {
//: print "wire    [31:0] pfifo${j}_data_ext_byte${i}_8; \n";
//: }
//: }

wire   [DP_DIN_DW-1:0] pfifo_data0_16;
wire   [DP_DIN_DW-1:0] pfifo_data1_16;
wire   [DP_DIN_DW-1:0] pfifo_data2_16;
wire   [DP_DIN_DW-1:0] pfifo_data3_16;
wire   [DP_DIN_DW-1:0] pfifo_data0_8;
wire   [DP_DIN_DW-1:0] pfifo_data1_8;
wire   [DP_DIN_DW-1:0] pfifo_data2_8;
wire   [DP_DIN_DW-1:0] pfifo_data3_8;
reg    [DP_DIN_DW-1:0] pfifo_data_r;
wire   [DP_DIN_DW-1:0] pfifo_data;

wire           pfifo_sel;
wire           pfifo_vld;
wire           sdp_mrdma2cmux_layer_end;

#ifdef NVDLA_FEATURE_DATA_TYPE_FP16
reg     [31:0] inf_input_cnt;
reg     [31:0] nan_input_cnt;
wire    [31:0] nan_input_cnt_nxt;
wire           nan_input_cnt_nxt_c;
wire    [31:0] inf_input_cnt_nxt;
wire           inf_input_cnt_nxt_c;
wire           pfifo0_data_byte0_is_inf;
wire           pfifo0_data_byte0_is_nan;
wire    [31:0] pfifo0_data_ext_byte0_fp16;
wire    [31:0] pfifo0_data_ext_byte0_int16;
wire     [4:0] sum0_of_inf;
wire     [4:0] sum0_of_nan;
wire     [4:0] sum1_of_inf;
wire     [4:0] sum1_of_nan;
wire     [4:0] sum_of_inf;
wire     [4:0] sum_of_nan;
wire           sum_of_sel;
#endif
#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
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
#endif
   
 
//==============
// CFG
//==============
assign  cfg_di_int8  = reg2dp_in_precision == 0 ;
assign  cfg_di_int16 = reg2dp_in_precision == 1 ;
assign  cfg_di_fp16 = reg2dp_in_precision == 2 ;
assign  cfg_di_16 = cfg_di_int16 | cfg_di_fp16;
assign  cfg_do_int8  = reg2dp_proc_precision == 0 ;
#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
assign  cfg_mode_16to8 = cfg_di_int16 & cfg_do_int8;
#endif
assign  cfg_mode_1x1_pack = (reg2dp_width==0) & (reg2dp_height==0);
assign  cfg_perf_nan_inf_count_en = reg2dp_perf_nan_inf_count_en;


//pop command dat fifo //
assign  cmd2dat_dma_prdy = dat_accept & is_last_beat & fifo_vld & dat_rdy;

assign  cmd2dat_dma_size[13:0] = cmd2dat_dma_pd[13:0];
assign  cmd2dat_dma_cube_end   = cmd2dat_dma_pd[14];

assign  size_of_beat = {14 {cmd2dat_dma_pvld}} & cmd2dat_dma_size;
assign  cmd_cube_end = {1 {cmd2dat_dma_pvld}} & cmd2dat_dma_cube_end;

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


#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
wire   mode_norm_pfifo0_sel_16 = beat_cnt[0:0]==0;
wire   mode_norm_pfifo1_sel_16 = beat_cnt[0:0]==0;
wire   mode_norm_pfifo2_sel_16 = beat_cnt[0:0]==1;
wire   mode_norm_pfifo3_sel_16 = beat_cnt[0:0]==1;
wire   mode_norm_pfifo0_sel_8  = beat_cnt[1:0]==0;
wire   mode_norm_pfifo1_sel_8  = beat_cnt[1:0]==1;
wire   mode_norm_pfifo2_sel_8  = beat_cnt[1:0]==2;
wire   mode_norm_pfifo3_sel_8  = beat_cnt[1:0]==3;
wire   mode_norm_pfifo0_sel = cfg_di_int8 ? mode_norm_pfifo0_sel_8 : mode_norm_pfifo0_sel_16;
wire   mode_norm_pfifo1_sel = cfg_di_int8 ? mode_norm_pfifo1_sel_8 : mode_norm_pfifo1_sel_16;
wire   mode_norm_pfifo2_sel = cfg_di_int8 ? mode_norm_pfifo2_sel_8 : mode_norm_pfifo2_sel_16;
wire   mode_norm_pfifo3_sel = cfg_di_int8 ? mode_norm_pfifo3_sel_8 : mode_norm_pfifo3_sel_16;
     
wire   mode_16to8_pfifo0_sel = beat_cnt[1:0]==0;
wire   mode_16to8_pfifo1_sel = beat_cnt[1:0]==0;
wire   mode_16to8_pfifo2_sel = beat_cnt[1:0]==2;
wire   mode_16to8_pfifo3_sel = beat_cnt[1:0]==2;

assign pfifo0_sel = (cfg_mode_16to8 && !cfg_mode_1x1_pack) ? mode_16to8_pfifo0_sel : mode_norm_pfifo0_sel;
assign pfifo1_sel = (cfg_mode_16to8 && !cfg_mode_1x1_pack) ? mode_16to8_pfifo1_sel : mode_norm_pfifo1_sel;
assign pfifo2_sel = (cfg_mode_16to8 && !cfg_mode_1x1_pack) ? mode_16to8_pfifo2_sel : mode_norm_pfifo2_sel;
assign pfifo3_sel = (cfg_mode_16to8 && !cfg_mode_1x1_pack) ? mode_16to8_pfifo3_sel : mode_norm_pfifo3_sel;
#else 
assign pfifo0_sel = beat_cnt[1:0]==0;
assign pfifo1_sel = beat_cnt[1:0]==1;
assign pfifo2_sel = beat_cnt[1:0]==2;
assign pfifo3_sel = beat_cnt[1:0]==3;
#endif 


assign pfifo_vld = (pfifo3_rd_pvld & pfifo3_sel) | (pfifo2_rd_pvld & pfifo2_sel) | (pfifo1_rd_pvld & pfifo1_sel) | (pfifo0_rd_pvld & pfifo0_sel);
#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
assign fifo_vld = pfifo_vld | sfifo_vld;
#else
assign fifo_vld = pfifo_vld;
#endif
assign dat_vld  = fifo_vld; //& cmd2dat_dma_pvld;

assign pfifo0_rd_prdy = dat_rdy & pfifo0_sel; //& cmd2dat_dma_pvld;
assign pfifo1_rd_prdy = dat_rdy & pfifo1_sel; //& cmd2dat_dma_pvld;
assign pfifo2_rd_prdy = dat_rdy & pfifo2_sel; //& cmd2dat_dma_pvld;
assign pfifo3_rd_prdy = dat_rdy & pfifo3_sel; //& cmd2dat_dma_pvld;

assign pfifo0_rd_data = {AM_DW{pfifo0_sel}} & pfifo0_rd_pd;
assign pfifo1_rd_data = {AM_DW{pfifo1_sel}} & pfifo1_rd_pd;
assign pfifo2_rd_data = {AM_DW{pfifo2_sel}} & pfifo2_rd_pd;
assign pfifo3_rd_data = {AM_DW{pfifo3_sel}} & pfifo3_rd_pd;


//: my $k = NVDLA_MEMORY_ATOMIC_SIZE/2;
//: foreach my $j  (0..3) {
//: foreach my $i  (0..${k}-1) {
//: print "assign pfifo${j}_data_byte${i}_16 = pfifo${j}_rd_data[${i}*16+15:${i}*16]; \n";
//: }
//: print "\n";
//: }
//: print "\n";
//: my $k = NVDLA_MEMORY_ATOMIC_SIZE/2;
//: foreach my $j  (0..3) {
//: foreach my $i  (0..${k}-1) {
//: print "assign pfifo${j}_data_ext_byte${i}_int16 = {{16{pfifo${j}_data_byte${i}_16[15]}}, pfifo${j}_data_byte${i}_16[15:0]}; \n";
//: }
//: print "\n";
//: }
//: print "\n";


#ifdef NVDLA_FEATURE_DATA_TYPE_FP16
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
#else
//: my $k = NVDLA_MEMORY_ATOMIC_SIZE/2;
//: foreach my $j  (0..3) {
//: foreach my $i  (0..${k}-1) {
//: print "assign pfifo${j}_data_ext_byte${i}_16 = pfifo${j}_data_ext_byte${i}_int16; \n";
//: }
//: }
//: print "\n";
#endif

//: my $k = NVDLA_MEMORY_ATOMIC_SIZE/2;
//: my $remain = $k*32;
//: foreach my $j  (0..3) {
//: print "assign pfifo_data${j}_16 = {${remain}\'h0,";
//: foreach my $i  (0..${k}-2) {
//: my $ii = $k - $i -1;
//: print "pfifo${j}_data_ext_byte${ii}_16,"; 
//: }
//: print "pfifo${j}_data_ext_byte0_16}; \n";
//: }


//// int8 ///////////
//: my $k = NVDLA_MEMORY_ATOMIC_SIZE;
//: foreach my $j  (0..3) {
//: foreach my $i  (0..${k}-1) {
//: print "assign pfifo${j}_data_byte${i}_8 = pfifo${j}_rd_data[${i}*8+7:${i}*8]; \n";
//: }
//: print "\n";
//: }
//: print "\n";
//: my $k = NVDLA_MEMORY_ATOMIC_SIZE;
//: foreach my $j  (0..3) {
//: foreach my $i  (0..${k}-1) {
//: print "assign pfifo${j}_data_ext_byte${i}_8 = {{24{pfifo${j}_data_byte${i}_8[7]}}, pfifo${j}_data_byte${i}_8[7:0]}; \n";
//: }
//: print "\n";
//: }
//: print "\n";

// INT8, concate
//: my $k = NVDLA_MEMORY_ATOMIC_SIZE;
//: foreach my $j  (0..3) {
//: print "assign pfifo_data${j}_8 = {";
//: foreach my $i  (0..${k}-2) {
//: my $ii = $k - $i -1;
//: print "pfifo${j}_data_ext_byte${ii}_8,"; 
//: }
//: print "pfifo${j}_data_ext_byte0_8}; \n";
//: }



//=====PERF COUNT BEG=============
#ifdef NVDLA_FEATURE_DATA_TYPE_FP16
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

#else 
assign dp2reg_status_inf_input_num = 32'h0; 
assign dp2reg_status_nan_input_num = 32'h0; 
#endif
//=====PERF COUNT END=============


#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
 assign mode_16to8_sfifo0_sel = beat_cnt[1:0]==1;
 assign mode_16to8_sfifo1_sel = beat_cnt[1:0]==3;
 assign sfifo0_sel = (cfg_mode_16to8 && !cfg_mode_1x1_pack) ? mode_16to8_sfifo0_sel : 1'b0;
 assign sfifo1_sel = (cfg_mode_16to8 && !cfg_mode_1x1_pack) ? mode_16to8_sfifo1_sel : 1'b0;
 assign sfifo_vld = (sfifo1_rd_pvld & sfifo1_sel) | (sfifo0_rd_pvld & sfifo0_sel);
 assign sfifo0_rd_prdy = dat_rdy & sfifo0_sel & cmd2dat_dma_pvld;
 assign sfifo1_rd_prdy = dat_rdy & sfifo1_sel & cmd2dat_dma_pvld;

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

assign sfifo_sel = {sfifo1_sel | sfifo0_sel};

always @(
  sfifo0_sel
  or sfifo_data0_16
  or sfifo1_sel
  or sfifo_data1_16
  ) begin
    case (1'b1)
     sfifo0_sel: sfifo_data = sfifo_data0_16;
     sfifo1_sel: sfifo_data = sfifo_data1_16;
    default : begin 
                sfifo_data[511:0] = {512{`x_or_0}};
              end  
    endcase
end
#endif   //NVDLA_SDP_DATA_TYPE_INT16TO8




#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
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

assign pfifo_sel = {pfifo3_sel | pfifo2_sel | pfifo1_sel | pfifo0_sel};
assign dat_data = pfifo_sel ? pfifo_data : sfifo_sel ? sfifo_data : 512'h0;
#else
always @(
  pfifo0_sel
  or pfifo1_sel
  or pfifo2_sel
  or pfifo3_sel
  or cfg_di_16 
  or pfifo_data0_8
  or pfifo_data1_8
  or pfifo_data2_8
  or pfifo_data3_8
  or pfifo_data0_16
  or pfifo_data1_16
  or pfifo_data2_16
  or pfifo_data3_16
  ) begin
  //spyglass disable_block W171 W226
    case (1'b1)
     pfifo0_sel: pfifo_data_r = cfg_di_16 ? pfifo_data0_16 : pfifo_data0_8;
     pfifo1_sel: pfifo_data_r = cfg_di_16 ? pfifo_data1_16 : pfifo_data1_8;
     pfifo2_sel: pfifo_data_r = cfg_di_16 ? pfifo_data2_16 : pfifo_data2_8;
     pfifo3_sel: pfifo_data_r = cfg_di_16 ? pfifo_data3_16 : pfifo_data3_8;
    default : begin 
                pfifo_data_r[DP_DIN_DW-1:0] = {(DP_DIN_DW){`x_or_0}};
              end  
    endcase
  //spyglass enable_block W171 W226
end

assign dat_data = pfifo_data_r;
#endif

assign dat_accept    = dat_vld & dat_rdy;
assign dat_layer_end = cmd_cube_end & is_last_beat;
assign dat_batch_end = cmd_cube_end & is_last_beat;

assign dat_pd[DP_DIN_DW-1:0] =  dat_data[DP_DIN_DW-1:0];
assign dat_pd[DP_DIN_DW]     =  dat_batch_end ;
assign dat_pd[DP_DIN_DW+1]   =  dat_layer_end ;

NV_NVDLA_SDP_MRDMA_EG_DOUT_pipe_p1 pipe_p1 (
   .nvdla_core_clk       (nvdla_core_clk)           
  ,.nvdla_core_rstn      (nvdla_core_rstn)          
  ,.dat_pd               (dat_pd[DP_DIN_DW+1:0])            
  ,.dat_vld              (dat_vld)                  
  ,.sdp_mrdma2cmux_ready (sdp_mrdma2cmux_ready)     
  ,.dat_rdy              (dat_rdy)                  
  ,.sdp_mrdma2cmux_pd    (sdp_mrdma2cmux_pd[DP_DIN_DW+1:0]) 
  ,.sdp_mrdma2cmux_valid (sdp_mrdma2cmux_valid)     
  );


assign sdp_mrdma2cmux_layer_end = sdp_mrdma2cmux_pd[DP_DIN_DW+1];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    eg_done <= 1'b0;
  end else begin
  eg_done <= sdp_mrdma2cmux_layer_end & sdp_mrdma2cmux_valid & sdp_mrdma2cmux_ready;
  end
end



#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
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
#endif //NVDLA_SDP_DATA_TYPE_INT16TO8 


#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
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
#endif


//Shift-left - unsigned shift argument one bit more
#ifdef NVDLA_FEATURE_DATA_TYPE_FP16
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
#endif

endmodule // NV_NVDLA_SDP_MRDMA_EG_dout



// **************************************************************************************************************
// Generated by ::pipe -m -bc -is sdp_mrdma2cmux_pd (sdp_mrdma2cmux_valid, sdp_mrdma2cmux_ready) <= dat_pd[DP_DIN_DW+1:0] (dat_vld,dat_rdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_MRDMA_EG_DOUT_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dat_pd
  ,dat_vld
  ,dat_rdy
  ,sdp_mrdma2cmux_pd
  ,sdp_mrdma2cmux_valid
  ,sdp_mrdma2cmux_ready
  );

input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [DP_DIN_DW+1:0] dat_pd;
input          dat_vld;
output         dat_rdy;
output [DP_DIN_DW+1:0] sdp_mrdma2cmux_pd;
output         sdp_mrdma2cmux_valid;
input          sdp_mrdma2cmux_ready;


//: my $dw = DP_DIN_DW+2;
//: &eperl::pipe("-is -wid $dw -do sdp_mrdma2cmux_pd -vo sdp_mrdma2cmux_valid -ri sdp_mrdma2cmux_ready -di dat_pd -vi dat_vld -ro dat_rdy");



endmodule // NV_NVDLA_SDP_MRDMA_EG_DOUT_pipe_p1


