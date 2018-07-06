// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_core.v

#include "NV_NVDLA_SDP_define.h"

module NV_NVDLA_SDP_core (
   nvdla_core_clk                  //|< i
  ,nvdla_core_rstn                 //|< i
  ,cacc2sdp_pd                     //|< i
  ,cacc2sdp_valid                  //|< i
  ,cacc2sdp_ready                  //|> o
  ,dla_clk_ovr_on_sync             //|< i
  ,dp2reg_done                     //|< i
  ,global_clk_ovr_on_sync          //|< i
  ,pwrbus_ram_pd                   //|< i
  ,tmc2slcg_disable_clock_gating   //|< i
  ,reg2dp_bcore_slcg_op_en         //|< i
  ,reg2dp_flying_mode              //|< i
#ifdef NVDLA_SDP_BN_ENABLE
  ,reg2dp_bn_alu_algo              //|< i
  ,reg2dp_bn_alu_bypass            //|< i
  ,reg2dp_bn_alu_operand           //|< i
  ,reg2dp_bn_alu_shift_value       //|< i
  ,reg2dp_bn_alu_src               //|< i
  ,reg2dp_bn_bypass                //|< i
  ,reg2dp_bn_mul_bypass            //|< i
  ,reg2dp_bn_mul_operand           //|< i
  ,reg2dp_bn_mul_prelu             //|< i
  ,reg2dp_bn_mul_shift_value       //|< i
  ,reg2dp_bn_mul_src               //|< i
  ,reg2dp_bn_relu_bypass           //|< i
#endif
#ifdef NVDLA_SDP_BS_ENABLE
  ,reg2dp_bs_alu_algo              //|< i
  ,reg2dp_bs_alu_bypass            //|< i
  ,reg2dp_bs_alu_operand           //|< i
  ,reg2dp_bs_alu_shift_value       //|< i
  ,reg2dp_bs_alu_src               //|< i
  ,reg2dp_bs_bypass                //|< i
  ,reg2dp_bs_mul_bypass            //|< i
  ,reg2dp_bs_mul_operand           //|< i
  ,reg2dp_bs_mul_prelu             //|< i
  ,reg2dp_bs_mul_shift_value       //|< i
  ,reg2dp_bs_mul_src               //|< i
  ,reg2dp_bs_relu_bypass           //|< i
#endif
  ,reg2dp_cvt_offset               //|< i
  ,reg2dp_cvt_scale                //|< i
  ,reg2dp_cvt_shift                //|< i
  ,reg2dp_ecore_slcg_op_en         //|< i
#ifdef NVDLA_SDP_EW_ENABLE
  ,reg2dp_ew_alu_algo              //|< i
  ,reg2dp_ew_alu_bypass            //|< i
  ,reg2dp_ew_alu_cvt_bypass        //|< i
  ,reg2dp_ew_alu_cvt_offset        //|< i
  ,reg2dp_ew_alu_cvt_scale         //|< i
  ,reg2dp_ew_alu_cvt_truncate      //|< i
  ,reg2dp_ew_alu_operand           //|< i
  ,reg2dp_ew_alu_src               //|< i
  ,reg2dp_ew_bypass                //|< i
  ,reg2dp_ew_lut_bypass            //|< i
  ,reg2dp_ew_mul_bypass            //|< i
  ,reg2dp_ew_mul_cvt_bypass        //|< i
  ,reg2dp_ew_mul_cvt_offset        //|< i
  ,reg2dp_ew_mul_cvt_scale         //|< i
  ,reg2dp_ew_mul_cvt_truncate      //|< i
  ,reg2dp_ew_mul_operand           //|< i
  ,reg2dp_ew_mul_prelu             //|< i
  ,reg2dp_ew_mul_src               //|< i
  ,reg2dp_ew_truncate              //|< i
#ifdef NVDLA_SDP_LUT_ENABLE
  ,reg2dp_lut_slcg_en              //|< i
  ,reg2dp_lut_hybrid_priority      //|< i
  ,reg2dp_lut_int_access_type      //|< i
  ,reg2dp_lut_int_addr             //|< i
  ,reg2dp_lut_int_data             //|< i
  ,reg2dp_lut_int_data_wr          //|< i
  ,reg2dp_lut_int_table_id         //|< i
  ,reg2dp_lut_le_end               //|< i
  ,reg2dp_lut_le_function          //|< i
  ,reg2dp_lut_le_index_offset      //|< i
  ,reg2dp_lut_le_index_select      //|< i
  ,reg2dp_lut_le_slope_oflow_scale //|< i
  ,reg2dp_lut_le_slope_oflow_shift //|< i
  ,reg2dp_lut_le_slope_uflow_scale //|< i
  ,reg2dp_lut_le_slope_uflow_shift //|< i
  ,reg2dp_lut_le_start             //|< i
  ,reg2dp_lut_lo_end               //|< i
  ,reg2dp_lut_lo_index_select      //|< i
  ,reg2dp_lut_lo_slope_oflow_scale //|< i
  ,reg2dp_lut_lo_slope_oflow_shift //|< i
  ,reg2dp_lut_lo_slope_uflow_scale //|< i
  ,reg2dp_lut_lo_slope_uflow_shift //|< i
  ,reg2dp_lut_lo_start             //|< i
  ,reg2dp_lut_oflow_priority       //|< i
  ,reg2dp_lut_uflow_priority       //|< i
  ,dp2reg_lut_hybrid               //|> o
  ,dp2reg_lut_int_data             //|> o
  ,dp2reg_lut_le_hit               //|> o
  ,dp2reg_lut_lo_hit               //|> o
  ,dp2reg_lut_oflow                //|> o
  ,dp2reg_lut_uflow                //|> o
#endif
#endif
  ,reg2dp_nan_to_zero              //|< i
  ,reg2dp_ncore_slcg_op_en         //|< i
  ,reg2dp_op_en                    //|< i
  ,reg2dp_out_precision            //|< i
  ,reg2dp_output_dst               //|< i
  ,reg2dp_perf_lut_en              //|< i
  ,reg2dp_perf_sat_en              //|< i
  ,reg2dp_proc_precision           //|< i
  ,dp2reg_out_saturation           //|> o
#ifdef NVDLA_SDP_BS_ENABLE
  ,sdp_brdma2dp_alu_pd             //|< i
  ,sdp_brdma2dp_alu_valid          //|< i
  ,sdp_brdma2dp_alu_ready          //|> o
  ,sdp_brdma2dp_mul_pd             //|< i
  ,sdp_brdma2dp_mul_valid          //|< i
  ,sdp_brdma2dp_mul_ready          //|> o
#endif
#ifdef NVDLA_SDP_EW_ENABLE
  ,sdp_erdma2dp_alu_pd             //|< i
  ,sdp_erdma2dp_alu_valid          //|< i
  ,sdp_erdma2dp_alu_ready          //|> o
  ,sdp_erdma2dp_mul_pd             //|< i
  ,sdp_erdma2dp_mul_valid          //|< i
  ,sdp_erdma2dp_mul_ready          //|> o
#endif
#ifdef NVDLA_SDP_BN_ENABLE
  ,sdp_nrdma2dp_alu_pd             //|< i
  ,sdp_nrdma2dp_alu_valid          //|< i
  ,sdp_nrdma2dp_alu_ready          //|> o
  ,sdp_nrdma2dp_mul_pd             //|< i
  ,sdp_nrdma2dp_mul_valid          //|< i
  ,sdp_nrdma2dp_mul_ready          //|> o
#endif
  ,sdp_mrdma2cmux_pd               //|< i
  ,sdp_mrdma2cmux_valid            //|< i
  ,sdp_mrdma2cmux_ready            //|> o
  ,sdp2pdp_pd                      //|> o
  ,sdp2pdp_valid                   //|> o
  ,sdp2pdp_ready                   //|< i
  ,sdp_dp2wdma_pd                  //|> o
  ,sdp_dp2wdma_valid               //|> o
  ,sdp_dp2wdma_ready               //|< i
  );

//
// NV_NVDLA_SDP_core_ports.v
//
input  nvdla_core_clk;   
input  nvdla_core_rstn; 

#ifdef NVDLA_SDP_BS_ENABLE
input          sdp_brdma2dp_mul_valid;  
output         sdp_brdma2dp_mul_ready;  
input  [AM_DW2:0] sdp_brdma2dp_mul_pd;

input          sdp_brdma2dp_alu_valid;  
output         sdp_brdma2dp_alu_ready;  
input  [AM_DW2:0] sdp_brdma2dp_alu_pd;
#endif

#ifdef NVDLA_SDP_BN_ENABLE
input          sdp_nrdma2dp_mul_valid;  
output         sdp_nrdma2dp_mul_ready;  
input  [AM_DW2:0] sdp_nrdma2dp_mul_pd;

input          sdp_nrdma2dp_alu_valid;  
output         sdp_nrdma2dp_alu_ready;  
input  [AM_DW2:0] sdp_nrdma2dp_alu_pd;
#endif

#ifdef NVDLA_SDP_EW_ENABLE
input          sdp_erdma2dp_mul_valid;  
output         sdp_erdma2dp_mul_ready;  
input  [AM_DW2:0] sdp_erdma2dp_mul_pd;

input          sdp_erdma2dp_alu_valid;  
output         sdp_erdma2dp_alu_ready;  
input  [AM_DW2:0] sdp_erdma2dp_alu_pd;
#endif

output         sdp_dp2wdma_valid;  
input          sdp_dp2wdma_ready;  
output [DP_DOUT_DW-1:0] sdp_dp2wdma_pd;

output         sdp2pdp_valid;  
input          sdp2pdp_ready;  
output [DP_OUT_DW-1:0] sdp2pdp_pd;

input [31:0] pwrbus_ram_pd;

input          cacc2sdp_valid;  
output         cacc2sdp_ready;  
input  [DP_IN_DW+1:0] cacc2sdp_pd;

input          sdp_mrdma2cmux_valid;  
output         sdp_mrdma2cmux_ready;  
input  [DP_DIN_DW+1:0] sdp_mrdma2cmux_pd;

input          reg2dp_bcore_slcg_op_en;
input          reg2dp_flying_mode;
#ifdef NVDLA_SDP_BN_ENABLE
input    [1:0] reg2dp_bn_alu_algo;
input          reg2dp_bn_alu_bypass;
input   [15:0] reg2dp_bn_alu_operand;
input    [5:0] reg2dp_bn_alu_shift_value;
input          reg2dp_bn_alu_src;
input          reg2dp_bn_bypass;
input          reg2dp_bn_mul_bypass;
input   [15:0] reg2dp_bn_mul_operand;
input          reg2dp_bn_mul_prelu;
input    [7:0] reg2dp_bn_mul_shift_value;
input          reg2dp_bn_mul_src;
input          reg2dp_bn_relu_bypass;
#endif
#ifdef NVDLA_SDP_BS_ENABLE
input    [1:0] reg2dp_bs_alu_algo;
input          reg2dp_bs_alu_bypass;
input   [15:0] reg2dp_bs_alu_operand;
input    [5:0] reg2dp_bs_alu_shift_value;
input          reg2dp_bs_alu_src;
input          reg2dp_bs_bypass;
input          reg2dp_bs_mul_bypass;
input   [15:0] reg2dp_bs_mul_operand;
input          reg2dp_bs_mul_prelu;
input    [7:0] reg2dp_bs_mul_shift_value;
input          reg2dp_bs_mul_src;
input          reg2dp_bs_relu_bypass;
#endif
input   [31:0] reg2dp_cvt_offset;
input   [15:0] reg2dp_cvt_scale;
input    [5:0] reg2dp_cvt_shift;
input          reg2dp_ecore_slcg_op_en;
#ifdef NVDLA_SDP_EW_ENABLE
input    [1:0] reg2dp_ew_alu_algo;
input          reg2dp_ew_alu_bypass;
input          reg2dp_ew_alu_cvt_bypass;
input   [31:0] reg2dp_ew_alu_cvt_offset;
input   [15:0] reg2dp_ew_alu_cvt_scale;
input    [5:0] reg2dp_ew_alu_cvt_truncate;
input   [31:0] reg2dp_ew_alu_operand;
input          reg2dp_ew_alu_src;
input          reg2dp_ew_bypass;
input          reg2dp_ew_lut_bypass;
input          reg2dp_ew_mul_bypass;
input          reg2dp_ew_mul_cvt_bypass;
input   [31:0] reg2dp_ew_mul_cvt_offset;
input   [15:0] reg2dp_ew_mul_cvt_scale;
input    [5:0] reg2dp_ew_mul_cvt_truncate;
input   [31:0] reg2dp_ew_mul_operand;
input          reg2dp_ew_mul_prelu;
input          reg2dp_ew_mul_src;
input    [9:0] reg2dp_ew_truncate;
#ifdef NVDLA_SDP_LUT_ENABLE
input          reg2dp_lut_slcg_en;
input          reg2dp_lut_hybrid_priority;
input          reg2dp_lut_int_access_type;
input    [9:0] reg2dp_lut_int_addr;
input   [15:0] reg2dp_lut_int_data;
input          reg2dp_lut_int_data_wr;
input          reg2dp_lut_int_table_id;
input   [31:0] reg2dp_lut_le_end;
input          reg2dp_lut_le_function;
input    [7:0] reg2dp_lut_le_index_offset;
input    [7:0] reg2dp_lut_le_index_select;
input   [15:0] reg2dp_lut_le_slope_oflow_scale;
input    [4:0] reg2dp_lut_le_slope_oflow_shift;
input   [15:0] reg2dp_lut_le_slope_uflow_scale;
input    [4:0] reg2dp_lut_le_slope_uflow_shift;
input   [31:0] reg2dp_lut_le_start;
input   [31:0] reg2dp_lut_lo_end;
input    [7:0] reg2dp_lut_lo_index_select;
input   [15:0] reg2dp_lut_lo_slope_oflow_scale;
input    [4:0] reg2dp_lut_lo_slope_oflow_shift;
input   [15:0] reg2dp_lut_lo_slope_uflow_scale;
input    [4:0] reg2dp_lut_lo_slope_uflow_shift;
input   [31:0] reg2dp_lut_lo_start;
input          reg2dp_lut_oflow_priority;
input          reg2dp_lut_uflow_priority;
output  [31:0] dp2reg_lut_hybrid;
output  [15:0] dp2reg_lut_int_data;
output  [31:0] dp2reg_lut_le_hit;
output  [31:0] dp2reg_lut_lo_hit;
output  [31:0] dp2reg_lut_oflow;
output  [31:0] dp2reg_lut_uflow;
#endif
#endif

input          reg2dp_nan_to_zero;
input          reg2dp_ncore_slcg_op_en;
input          reg2dp_op_en;
input    [1:0] reg2dp_out_precision;
input          reg2dp_output_dst;
input          reg2dp_perf_lut_en;
input          reg2dp_perf_sat_en;
input    [1:0] reg2dp_proc_precision;
input          dp2reg_done;
output  [31:0] dp2reg_out_saturation;
input          dla_clk_ovr_on_sync;
input          global_clk_ovr_on_sync;
input          tmc2slcg_disable_clock_gating;

wire           bcore_slcg_en;
wire           ncore_slcg_en;
wire           ecore_slcg_en;
wire           nvdla_gated_bcore_clk;
wire           nvdla_gated_ecore_clk;
wire           nvdla_gated_ncore_clk;
wire           op_en_load;
reg            wait_for_op_en;
reg            cfg_bs_en;
reg            cfg_bn_en;
reg            cfg_ew_en;
reg            cfg_mode_eql;
reg            cfg_nan_to_zero;
reg      [1:0] cfg_out_precision;
reg      [1:0] cfg_proc_precision;
wire           cfg_mode_pdp;
reg     [31:0] cfg_cvt_offset;
reg     [15:0] cfg_cvt_scale;
reg      [5:0] cfg_cvt_shift;
#ifdef NVDLA_SDP_BN_ENABLE
reg      [1:0] cfg_bn_alu_algo;
reg            cfg_bn_alu_bypass;
reg     [15:0] cfg_bn_alu_operand;
reg      [5:0] cfg_bn_alu_shift_value;
reg            cfg_bn_alu_src;
reg            cfg_bn_mul_bypass;
reg     [15:0] cfg_bn_mul_operand;
reg            cfg_bn_mul_prelu;
reg      [7:0] cfg_bn_mul_shift_value;
reg            cfg_bn_mul_src;
reg            cfg_bn_relu_bypass;
#endif
#ifdef NVDLA_SDP_BS_ENABLE
reg      [1:0] cfg_bs_alu_algo;
reg            cfg_bs_alu_bypass;
reg     [15:0] cfg_bs_alu_operand;
reg      [5:0] cfg_bs_alu_shift_value;
reg            cfg_bs_alu_src;
reg            cfg_bs_mul_bypass;
reg     [15:0] cfg_bs_mul_operand;
reg            cfg_bs_mul_prelu;
reg      [7:0] cfg_bs_mul_shift_value;
reg            cfg_bs_mul_src;
reg            cfg_bs_relu_bypass;
#endif
#ifdef NVDLA_SDP_BN_ENABLE
reg            bn_alu_in_en;
reg            bn_mul_in_en;
wire   [BN_OP_DW-1:0] bn_alu_in_data;
wire           bn_alu_in_layer_end;
wire   [BN_OP_DW:0] bn_alu_in_pd;
wire           bn_alu_in_prdy;
wire           bn_alu_in_pvld;
wire           bn_alu_in_rdy;
wire           bn_alu_in_vld;
wire   [BN_OP_DW-1:0] bn_mul_in_data;
wire           bn_mul_in_layer_end;
wire   [BN_OP_DW:0] bn_mul_in_pd;
wire           bn_mul_in_prdy;
wire           bn_mul_in_pvld;
wire           bn_mul_in_rdy;
wire           bn_mul_in_vld;
#endif
#ifdef NVDLA_SDP_BS_ENABLE
reg            bs_alu_in_en;
reg            bs_mul_in_en;
wire   [BS_OP_DW-1:0] bs_alu_in_data;
wire           bs_alu_in_layer_end;
wire   [BS_OP_DW:0] bs_alu_in_pd;
wire           bs_alu_in_prdy;
wire           bs_alu_in_pvld;
wire           bs_alu_in_rdy;
wire           bs_alu_in_vld;
wire   [BS_OP_DW-1:0] bs_mul_in_data;
wire           bs_mul_in_layer_end;
wire   [BS_OP_DW:0] bs_mul_in_pd;
wire           bs_mul_in_prdy;
wire           bs_mul_in_pvld;
wire           bs_mul_in_rdy;
wire           bs_mul_in_vld;
#endif
#ifdef NVDLA_SDP_EW_ENABLE
reg            ew_alu_in_en;
reg            ew_mul_in_en;
wire   [EW_OP_DW-1:0] ew_alu_in_data;
wire           ew_alu_in_layer_end;
wire   [EW_OP_DW:0] ew_alu_in_pd;
wire           ew_alu_in_prdy;
wire           ew_alu_in_pvld;
wire           ew_alu_in_rdy;
wire           ew_alu_in_vld;
wire   [EW_OP_DW-1:0] ew_mul_in_data;
wire           ew_mul_in_layer_end;
wire   [EW_OP_DW:0] ew_mul_in_pd;
wire           ew_mul_in_prdy;
wire           ew_mul_in_pvld;
wire           ew_mul_in_rdy;
wire           ew_mul_in_vld;
#endif

wire           sdp_mrdma_data_in_valid;            
wire           sdp_mrdma_data_in_ready;            
wire   [DP_IN_DW+1:0] sdp_mrdma_data_in_pd; 
wire   [DP_IN_DW-1:0] sdp_cmux2dp_data;
wire   [DP_IN_DW-1:0] sdp_cmux2dp_pd;
wire           sdp_cmux2dp_ready;
wire           sdp_cmux2dp_valid;

wire           bn2ew_data_pvld;
wire           bs_data_in_pvld;
wire   [DP_IN_DW-1:0] bs_data_in_pd;
wire           bs_data_in_prdy;
wire   [BS_IN_DW-1:0] flop_bs_data_in_pd;
wire           flop_bs_data_in_prdy;
wire           flop_bs_data_in_pvld;
wire   [BS_OUT_DW:0] bs_data_out_pd;
wire           bs_data_out_prdy;
wire           bs_data_out_pvld;
wire   [BS_DOUT_DW-1:0] flop_bs_data_out_pd;
wire           flop_bs_data_out_pvld;
wire           flop_bs_data_out_prdy;

wire           bs2bn_data_pvld;
wire           bn_data_in_pvld;
wire           bn_data_in_prdy;
wire   [BN_DIN_DW-1:0] bn_data_in_pd;
wire           flop_bn_data_in_prdy;
wire           flop_bn_data_in_pvld;
wire   [BN_IN_DW-1:0] flop_bn_data_in_pd;
wire           bn_data_out_prdy;
wire           bn_data_out_pvld;
wire   [BN_OUT_DW-1:0] bn_data_out_pd;
wire           flop_bn_data_out_pvld;
wire           flop_bn_data_out_prdy;
wire   [BN_DOUT_DW-1:0] flop_bn_data_out_pd;

wire           ew_data_in_prdy;
wire           ew_data_in_pvld;
wire   [EW_DIN_DW-1:0] ew_data_in_pd;
wire           flop_ew_data_in_prdy;
wire           flop_ew_data_in_pvld;
wire   [EW_IN_DW-1:0] flop_ew_data_in_pd;
wire           ew_data_out_prdy;
wire           ew_data_out_pvld;
wire   [EW_OUT_DW-1:0] ew_data_out_pd;
wire           flop_ew_data_out_prdy;
wire           flop_ew_data_out_pvld;
wire   [EW_DOUT_DW-1:0] flop_ew_data_out_pd;

wire           ew2cvt_data_pvld;
wire           cvt_data_in_pvld;
wire           cvt_data_in_prdy;
wire   [CV_IN_DW-1:0] cvt_data_in_pd;
wire   [CV_OUT_DW+NVDLA_SDP_MAX_THROUGHPUT-1:0] cvt_data_out_pd;
wire   [CV_OUT_DW-1:0] cvt_data_out_data;
wire           cvt_data_out_prdy;
wire           cvt_data_out_pvld;
wire   [CV_OUT_DW-1:0] core2wdma_pd;
wire           core2wdma_rdy;
wire           core2wdma_vld;
wire   [DP_OUT_DW-1:0] core2pdp_pd;
wire           core2pdp_rdy;
wire           core2pdp_vld;

wire    [NVDLA_SDP_MAX_THROUGHPUT-1:0] cvt_data_out_sat;
reg     [NVDLA_SDP_MAX_THROUGHPUT-1:0] saturation_bits;
reg            cvt_sat_cvt_sat_adv;
reg     [31:0] cvt_sat_cvt_sat_cnt_cur;
reg     [33:0] cvt_sat_cvt_sat_cnt_ext;
reg     [33:0] cvt_sat_cvt_sat_cnt_mod;
reg     [33:0] cvt_sat_cvt_sat_cnt_new;
reg     [33:0] cvt_sat_cvt_sat_cnt_nxt;
reg     [31:0] cvt_saturation_cnt;
wire     [4:0] i_add;
wire     [0:0] i_sub;
wire     [4:0] cvt_sat_add_act;
wire     [4:0] cvt_sat_add_act_ext;
wire     [4:0] cvt_sat_add_ext;
wire           cvt_sat_add_flow;
wire           cvt_sat_add_guard;
wire           cvt_sat_dec;
wire           cvt_sat_inc;
wire     [4:0] cvt_sat_mod_ext;
wire           cvt_sat_sub_act;
wire     [4:0] cvt_sat_sub_act_ext;
wire     [4:0] cvt_sat_sub_ext;
wire           cvt_sat_sub_flow;
wire           cvt_sat_sub_guard;
wire     [4:0] cvt_saturation_add;
wire           cvt_saturation_cen;
wire           cvt_saturation_clr;
wire           cvt_saturation_sub;



//===========================================
// CFG
//===========================================
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_bs_en <= 1'b0;
    cfg_bn_en <= 1'b0;
    cfg_ew_en <= 1'b0;
    cfg_mode_eql <= 1'b0;
  end else begin
#ifdef NVDLA_SDP_BS_ENABLE
        cfg_bs_en <= reg2dp_bs_bypass== 1'h0 ;
#else 
        cfg_bs_en <= 1'b0;
#endif
#ifdef NVDLA_SDP_BN_ENABLE
        cfg_bn_en <= reg2dp_bn_bypass== 1'h0 ;
#else 
        cfg_bn_en <= 1'b0;
#endif
#ifdef NVDLA_SDP_EW_ENABLE
        cfg_ew_en     <= reg2dp_ew_bypass== 1'h0 ;
        cfg_mode_eql  <= reg2dp_ew_alu_algo== 2'h3  && reg2dp_ew_alu_bypass== 1'h0  && reg2dp_ew_bypass== 1'h0 ;
#else 
        cfg_ew_en    <= 1'b0;
        cfg_mode_eql <= 1'b0;
#endif
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
#ifdef NVDLA_SDP_BS_ENABLE
    cfg_bs_alu_operand <= {16{1'b0}};
    cfg_bs_mul_operand <= {16{1'b0}};
    cfg_bs_alu_bypass <= 1'b0;
    cfg_bs_alu_algo <= {2{1'b0}};
    cfg_bs_alu_src <= 1'b0;
    cfg_bs_alu_shift_value <= {6{1'b0}};
    cfg_bs_mul_bypass <= 1'b0;
    cfg_bs_mul_prelu <= 1'b0;
    cfg_bs_mul_src <= 1'b0;
    cfg_bs_mul_shift_value <= {8{1'b0}};
    cfg_bs_relu_bypass <= 1'b0;
#endif
#ifdef NVDLA_SDP_BN_ENABLE
    cfg_bn_alu_operand <= {16{1'b0}};
    cfg_bn_mul_operand <= {16{1'b0}};
    cfg_bn_alu_bypass <= 1'b0;
    cfg_bn_alu_algo <= {2{1'b0}};
    cfg_bn_alu_src <= 1'b0;
    cfg_bn_alu_shift_value <= {6{1'b0}};
    cfg_bn_mul_bypass <= 1'b0;
    cfg_bn_mul_prelu <= 1'b0;
    cfg_bn_mul_src <= 1'b0;
    cfg_bn_mul_shift_value <= {8{1'b0}};
    cfg_bn_relu_bypass <= 1'b0;
#endif
    cfg_cvt_offset <= {32{1'b0}};
    cfg_cvt_scale <= {16{1'b0}};
    cfg_cvt_shift <= {6{1'b0}};
    cfg_proc_precision <= {2{1'b0}};
    cfg_out_precision <= {2{1'b0}};
    cfg_nan_to_zero <= 1'b0;
  end else begin
    if (op_en_load) begin
#ifdef NVDLA_SDP_BS_ENABLE
        cfg_bs_alu_operand      <= reg2dp_bs_alu_operand      ;
        cfg_bs_mul_operand      <= reg2dp_bs_mul_operand      ;
        cfg_bs_alu_bypass       <= reg2dp_bs_alu_bypass       ;
        cfg_bs_alu_algo         <= reg2dp_bs_alu_algo         ;
        cfg_bs_alu_src          <= reg2dp_bs_alu_src          ;
        cfg_bs_alu_shift_value  <= reg2dp_bs_alu_shift_value  ;
        cfg_bs_mul_bypass       <= reg2dp_bs_mul_bypass       ;
        cfg_bs_mul_prelu        <= reg2dp_bs_mul_prelu        ;
        cfg_bs_mul_src          <= reg2dp_bs_mul_src          ;
        cfg_bs_mul_shift_value  <= reg2dp_bs_mul_shift_value  ;
        cfg_bs_relu_bypass      <= reg2dp_bs_relu_bypass      ;
#endif
#ifdef NVDLA_SDP_BN_ENABLE
        cfg_bn_alu_operand      <= reg2dp_bn_alu_operand      ;
        cfg_bn_mul_operand      <= reg2dp_bn_mul_operand      ;
        cfg_bn_alu_bypass       <= reg2dp_bn_alu_bypass       ;
        cfg_bn_alu_algo         <= reg2dp_bn_alu_algo         ;
        cfg_bn_alu_src          <= reg2dp_bn_alu_src          ;
        cfg_bn_alu_shift_value  <= reg2dp_bn_alu_shift_value  ;
        cfg_bn_mul_bypass       <= reg2dp_bn_mul_bypass       ;
        cfg_bn_mul_prelu        <= reg2dp_bn_mul_prelu        ;
        cfg_bn_mul_src          <= reg2dp_bn_mul_src          ;
        cfg_bn_mul_shift_value  <= reg2dp_bn_mul_shift_value  ;
        cfg_bn_relu_bypass      <= reg2dp_bn_relu_bypass      ;
#endif
        cfg_cvt_offset          <= reg2dp_cvt_offset          ;
        cfg_cvt_scale           <= reg2dp_cvt_scale           ;
        cfg_cvt_shift           <= reg2dp_cvt_shift           ;
        cfg_proc_precision      <= reg2dp_proc_precision      ;
        cfg_out_precision       <= reg2dp_out_precision       ;
        cfg_nan_to_zero         <= reg2dp_nan_to_zero         ;
    end
  end
end



//===========================================
// SLCG Gate
//===========================================
assign bcore_slcg_en = cfg_bs_en & reg2dp_bcore_slcg_op_en;

assign ncore_slcg_en = cfg_bn_en & reg2dp_ncore_slcg_op_en;
#ifdef NVDLA_SDP_EW_ENABLE
#ifdef NVDLA_SDP_LUT_ENABLE
assign ecore_slcg_en = (cfg_ew_en & reg2dp_ecore_slcg_op_en) | reg2dp_lut_slcg_en;
#else
assign ecore_slcg_en = (cfg_ew_en & reg2dp_ecore_slcg_op_en);
#endif
#else
assign ecore_slcg_en = (cfg_ew_en & reg2dp_ecore_slcg_op_en);
#endif
NV_NVDLA_SDP_CORE_gate u_gate (
   .bcore_slcg_en                   (bcore_slcg_en)                         //|< w
  ,.dla_clk_ovr_on_sync             (dla_clk_ovr_on_sync)                   //|< i
  ,.ecore_slcg_en                   (ecore_slcg_en)                         //|< w
  ,.global_clk_ovr_on_sync          (global_clk_ovr_on_sync)                //|< i
  ,.ncore_slcg_en                   (ncore_slcg_en)                         //|< w
  ,.nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.tmc2slcg_disable_clock_gating   (tmc2slcg_disable_clock_gating)         //|< i
  ,.nvdla_gated_bcore_clk           (nvdla_gated_bcore_clk)                 //|> w
  ,.nvdla_gated_ecore_clk           (nvdla_gated_ecore_clk)                 //|> w
  ,.nvdla_gated_ncore_clk           (nvdla_gated_ncore_clk)                 //|> w
  );




//===========================================================================
//  DATA PATH LOGIC 
//  RDMA data 
//===========================================================================
//covert mrdma data from atomic_m to NVDLA_SDP_MAX_THROUGHPUT
NV_NVDLA_SDP_RDMA_pack #(.IW(DP_DIN_DW),.OW(DP_IN_DW),.CW(2))  u_dpin_pack (
   .nvdla_core_clk                  (nvdla_core_clk)                
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                      
  ,.cfg_dp_8                        (~(|reg2dp_proc_precision))            
  ,.inp_pvld                        (sdp_mrdma2cmux_valid)               
  ,.inp_prdy                        (sdp_mrdma2cmux_ready)               
  ,.inp_data                        (sdp_mrdma2cmux_pd[DP_DIN_DW+1:0])   
  ,.out_pvld                        (sdp_mrdma_data_in_valid)                       
  ,.out_prdy                        (sdp_mrdma_data_in_ready)                       
  ,.out_data                        (sdp_mrdma_data_in_pd[DP_IN_DW+1:0])          
  );


#ifdef NVDLA_SDP_BS_ENABLE
//covert atomic_m to NVDLA_SDP_BS_THROUGHPUT
NV_NVDLA_SDP_RDMA_pack #(.IW(AM_DW2),.OW(BS_OP_DW),.CW(1))  u_bs_mul_pack (
   .nvdla_core_clk                  (nvdla_core_clk)                
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                      
  ,.cfg_dp_8                        (~(|reg2dp_proc_precision))            
  ,.inp_pvld                        (sdp_brdma2dp_mul_valid)               
  ,.inp_prdy                        (sdp_brdma2dp_mul_ready)               
  ,.inp_data                        (sdp_brdma2dp_mul_pd[AM_DW2:0])        
  ,.out_pvld                        (bs_mul_in_pvld)                       
  ,.out_prdy                        (bs_mul_in_prdy)                       
  ,.out_data                        (bs_mul_in_pd[BS_OP_DW:0])             
  );

assign   bs_mul_in_data[BS_OP_DW-1:0] = bs_mul_in_pd[BS_OP_DW-1:0];
assign   bs_mul_in_layer_end = bs_mul_in_pd[BS_OP_DW];

//covert atomic_m to NVDLA_SDP_BS_THROUGHPUT
NV_NVDLA_SDP_RDMA_pack #(.IW(AM_DW2),.OW(BS_OP_DW),.CW(1))  u_bs_alu_pack (
   .nvdla_core_clk                  (nvdla_core_clk)               
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                     
  ,.cfg_dp_8                        (~(|reg2dp_proc_precision))           
  ,.inp_pvld                        (sdp_brdma2dp_alu_valid)              
  ,.inp_prdy                        (sdp_brdma2dp_alu_ready)              
  ,.inp_data                        (sdp_brdma2dp_alu_pd[AM_DW2:0])       
  ,.out_pvld                        (bs_alu_in_pvld)                      
  ,.out_prdy                        (bs_alu_in_prdy)                      
  ,.out_data                        (bs_alu_in_pd[BS_OP_DW:0])            
  );


assign   bs_alu_in_data[BS_OP_DW-1:0] = bs_alu_in_pd[BS_OP_DW-1:0];
assign   bs_alu_in_layer_end = bs_alu_in_pd[BS_OP_DW];

#endif


#ifdef NVDLA_SDP_BN_ENABLE
//covert atomic_m to NVDLA_SDP_BN_THROUGHPUT
NV_NVDLA_SDP_RDMA_pack #(.IW(AM_DW2),.OW(BN_OP_DW),.CW(1))  u_bn_mul_pack (
   .nvdla_core_clk                  (nvdla_core_clk)                      
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                     
  ,.cfg_dp_8                        (~(|reg2dp_proc_precision))           
  ,.inp_pvld                        (sdp_nrdma2dp_mul_valid)              
  ,.inp_prdy                        (sdp_nrdma2dp_mul_ready)              
  ,.inp_data                        (sdp_nrdma2dp_mul_pd[AM_DW2:0])     
  ,.out_pvld                        (bn_mul_in_pvld)                      
  ,.out_prdy                        (bn_mul_in_prdy)                      
  ,.out_data                        (bn_mul_in_pd[BN_OP_DW:0])            
  );

assign       bn_mul_in_data[BN_OP_DW-1:0] = bn_mul_in_pd[BN_OP_DW-1:0];
assign       bn_mul_in_layer_end = bn_mul_in_pd[BN_OP_DW];

NV_NVDLA_SDP_RDMA_pack #(.IW(AM_DW2),.OW(BN_OP_DW),.CW(1))  u_bn_alu_pack (
   .nvdla_core_clk                  (nvdla_core_clk)                      
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                     
  ,.cfg_dp_8                        (~(|reg2dp_proc_precision))           
  ,.inp_pvld                        (sdp_nrdma2dp_alu_valid)              
  ,.inp_prdy                        (sdp_nrdma2dp_alu_ready)              
  ,.inp_data                        (sdp_nrdma2dp_alu_pd[AM_DW2:0])     
  ,.out_pvld                        (bn_alu_in_pvld)                      
  ,.out_prdy                        (bn_alu_in_prdy)                      
  ,.out_data                        (bn_alu_in_pd[BN_OP_DW:0])            
  );

assign       bn_alu_in_data[BN_OP_DW-1:0] = bn_alu_in_pd[BN_OP_DW-1:0];
assign       bn_alu_in_layer_end = bn_alu_in_pd[BN_OP_DW];
#endif


#ifdef NVDLA_SDP_EW_ENABLE
//=====EW=======
//covert atomic_m to NVDLA_SDP_EW_THROUGHPUT
NV_NVDLA_SDP_RDMA_pack #(.IW(AM_DW2),.OW(EW_OP_DW),.CW(1))  u_ew_mul_pack (
   .nvdla_core_clk                  (nvdla_core_clk)                      
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                     
  ,.cfg_dp_8                        (~(|reg2dp_proc_precision))           
  ,.inp_pvld                        (sdp_erdma2dp_mul_valid)              
  ,.inp_prdy                        (sdp_erdma2dp_mul_ready)              
  ,.inp_data                        (sdp_erdma2dp_mul_pd[AM_DW2:0])     
  ,.out_pvld                        (ew_mul_in_pvld)                      
  ,.out_prdy                        (ew_mul_in_prdy)                      
  ,.out_data                        (ew_mul_in_pd[EW_OP_DW:0])            
  );

assign       ew_mul_in_data[EW_OP_DW-1:0] = ew_mul_in_pd[EW_OP_DW-1:0];
assign       ew_mul_in_layer_end = ew_mul_in_pd[EW_OP_DW];

NV_NVDLA_SDP_RDMA_pack #(.IW(AM_DW2),.OW(EW_OP_DW),.CW(1))  u_ew_alu_pack (
   .nvdla_core_clk                  (nvdla_core_clk)                      
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                     
  ,.cfg_dp_8                        (~(|reg2dp_proc_precision))           
  ,.inp_pvld                        (sdp_erdma2dp_alu_valid)              
  ,.inp_prdy                        (sdp_erdma2dp_alu_ready)              
  ,.inp_data                        (sdp_erdma2dp_alu_pd[AM_DW2:0])     
  ,.out_pvld                        (ew_alu_in_pvld)                      
  ,.out_prdy                        (ew_alu_in_prdy)                      
  ,.out_data                        (ew_alu_in_pd[EW_OP_DW:0])            
  );

assign       ew_alu_in_data[EW_OP_DW-1:0] = ew_alu_in_pd[EW_OP_DW-1:0];
assign       ew_alu_in_layer_end  = ew_alu_in_pd[EW_OP_DW];
#endif

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wait_for_op_en <= 1'b1;
  end else begin
    if (dp2reg_done) begin
        wait_for_op_en <= 1'b1;
    end else if (reg2dp_op_en) begin
        wait_for_op_en <= 1'b0;
    end
  end
end
assign op_en_load = wait_for_op_en & reg2dp_op_en;

#ifdef NVDLA_SDP_BS_ENABLE
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bs_alu_in_en <= 1'b0;
  end else begin
   if (dp2reg_done) begin
      bs_alu_in_en  <= 1'b0;
   end else if (op_en_load) begin
      bs_alu_in_en  <= cfg_bs_en && (!reg2dp_bs_alu_bypass) && (reg2dp_bs_alu_src==1);
   end else if (bs_alu_in_layer_end && bs_alu_in_pvld && bs_alu_in_prdy) begin
      bs_alu_in_en  <= 1'b0;
   end
  end
end
assign bs_alu_in_vld = bs_alu_in_en & bs_alu_in_pvld;
assign bs_alu_in_prdy = bs_alu_in_en & bs_alu_in_rdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bs_mul_in_en <= 1'b0;
  end else begin
   if (dp2reg_done) begin
      bs_mul_in_en  <= 1'b0;
   end else if (op_en_load) begin
      bs_mul_in_en  <= cfg_bs_en && (!reg2dp_bs_mul_bypass) &(reg2dp_bs_mul_src==1);
   end else if (bs_mul_in_layer_end && bs_mul_in_pvld && bs_mul_in_prdy) begin
      bs_mul_in_en  <= 1'b0;
   end
  end
end

assign bs_mul_in_vld = bs_mul_in_en & bs_mul_in_pvld;
assign bs_mul_in_prdy = bs_mul_in_en & bs_mul_in_rdy;
#endif

#ifdef NVDLA_SDP_BN_ENABLE
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bn_alu_in_en <= 1'b0;
  end else begin
   if (dp2reg_done) begin
      bn_alu_in_en  <= 1'b0;
   end else if (op_en_load) begin
      bn_alu_in_en  <= cfg_bn_en && (!reg2dp_bn_alu_bypass) && (reg2dp_bn_alu_src==1);
   end else if (bn_alu_in_layer_end && bn_alu_in_pvld && bn_alu_in_prdy) begin
      bn_alu_in_en  <= 1'b0;
   end
  end
end
assign bn_alu_in_vld = bn_alu_in_en & bn_alu_in_pvld;
assign bn_alu_in_prdy = bn_alu_in_en & bn_alu_in_rdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bn_mul_in_en <= 1'b0;
  end else begin
   if (dp2reg_done) begin
      bn_mul_in_en  <= 1'b0;
   end else if (op_en_load) begin
      bn_mul_in_en  <= cfg_bn_en && (!reg2dp_bn_mul_bypass) &(reg2dp_bn_mul_src==1);
   end else if (bn_mul_in_layer_end && bn_mul_in_pvld && bn_mul_in_prdy) begin
      bn_mul_in_en  <= 1'b0;
   end
  end
end
assign bn_mul_in_vld = bn_mul_in_en & bn_mul_in_pvld;
assign bn_mul_in_prdy = bn_mul_in_en & bn_mul_in_rdy;
#endif

#ifdef NVDLA_SDP_EW_ENABLE
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ew_alu_in_en <= 1'b0;
  end else begin
   if (dp2reg_done) begin
      ew_alu_in_en  <= 1'b0;
   end else if (op_en_load) begin
      ew_alu_in_en  <= cfg_ew_en && (!reg2dp_ew_alu_bypass) && (reg2dp_ew_alu_src==1);
   end else if (ew_alu_in_layer_end && ew_alu_in_pvld && ew_alu_in_prdy) begin
      ew_alu_in_en  <= 1'b0;
   end
  end
end
assign ew_alu_in_vld = ew_alu_in_en & ew_alu_in_pvld;
assign ew_alu_in_prdy = ew_alu_in_en & ew_alu_in_rdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ew_mul_in_en <= 1'b0;
  end else begin
   if (dp2reg_done) begin
      ew_mul_in_en  <= 1'b0;
   end else if (op_en_load) begin
      ew_mul_in_en  <= cfg_ew_en && (!reg2dp_ew_mul_bypass) &(reg2dp_ew_mul_src==1);
   end else if (ew_mul_in_layer_end && ew_mul_in_pvld && ew_mul_in_prdy) begin
      ew_mul_in_en  <= 1'b0;
   end
  end
end
assign ew_mul_in_vld = ew_mul_in_en & ew_mul_in_pvld;
assign ew_mul_in_prdy = ew_mul_in_en & ew_mul_in_rdy;
#endif



//===========================================
// CORE
//===========================================
// data from MUX ? CC : MEM
NV_NVDLA_SDP_cmux u_NV_NVDLA_SDP_cmux (
   .nvdla_core_clk                  (nvdla_core_clk)                        
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       
  ,.cacc2sdp_valid                  (cacc2sdp_valid)                        
  ,.cacc2sdp_ready                  (cacc2sdp_ready)                        
  ,.cacc2sdp_pd                     (cacc2sdp_pd[DP_IN_DW+1:0])             
  ,.sdp_mrdma2cmux_valid            (sdp_mrdma_data_in_valid)                  
  ,.sdp_mrdma2cmux_ready            (sdp_mrdma_data_in_ready)                  
  ,.sdp_mrdma2cmux_pd               (sdp_mrdma_data_in_pd[DP_IN_DW+1:0])       
  ,.sdp_cmux2dp_ready               (sdp_cmux2dp_ready)                     
  ,.sdp_cmux2dp_pd                  (sdp_cmux2dp_pd[DP_IN_DW-1:0])          
  ,.sdp_cmux2dp_valid               (sdp_cmux2dp_valid)                     
  ,.reg2dp_flying_mode              (reg2dp_flying_mode)                    
  ,.reg2dp_nan_to_zero              (reg2dp_nan_to_zero)                    
  ,.reg2dp_proc_precision           (reg2dp_proc_precision[1:0])            
  ,.op_en_load                      (op_en_load)                            
  );

assign  sdp_cmux2dp_data[DP_IN_DW-1:0] = sdp_cmux2dp_pd[DP_IN_DW-1:0];

// MUX to bypass CORE_x0
#ifdef NVDLA_SDP_BS_ENABLE
assign sdp_cmux2dp_ready = cfg_bs_en ? bs_data_in_prdy : flop_bs_data_out_prdy;
#else
assign sdp_cmux2dp_ready = flop_bs_data_out_prdy;
#endif
assign bs_data_in_pd   = sdp_cmux2dp_data;
#ifdef NVDLA_SDP_BS_ENABLE
assign bs_data_in_pvld = cfg_bs_en & sdp_cmux2dp_valid;

//covert NVDLA_SDP_MAX_THROUGHPUT to NVDLA_SDP_BS_THROUGHPUT
NV_NVDLA_SDP_CORE_pack #(.IW(DP_IN_DW),.OW(BS_IN_DW))  u_bs_dppack (
   .nvdla_core_clk                  (nvdla_gated_bcore_clk)                //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                      //|< i
  ,.inp_pvld                        (bs_data_in_pvld)                      //|< i
  ,.inp_data                        (bs_data_in_pd[DP_IN_DW-1:0])          //|< i
  ,.inp_prdy                        (bs_data_in_prdy)                      //|> o
  ,.out_pvld                        (flop_bs_data_in_pvld)                 //|> w
  ,.out_data                        (flop_bs_data_in_pd[BS_IN_DW-1:0])     //|> w
  ,.out_prdy                        (flop_bs_data_in_prdy)                 //|< w
  );


NV_NVDLA_SDP_HLS_x1_int   u_bs (
   .cfg_alu_algo                    (cfg_bs_alu_algo[1:0])                  //|< r
  ,.cfg_alu_bypass                  (cfg_bs_alu_bypass)                     //|< r
  ,.cfg_alu_op                      (cfg_bs_alu_operand[15:0])              //|< r
  ,.cfg_alu_shift_value             (cfg_bs_alu_shift_value[5:0])           //|< r
  ,.cfg_alu_src                     (cfg_bs_alu_src)                        //|< r
  ,.cfg_mul_bypass                  (cfg_bs_mul_bypass)                     //|< r
  ,.cfg_mul_op                      (cfg_bs_mul_operand[15:0])              //|< r
  ,.cfg_mul_prelu                   (cfg_bs_mul_prelu)                      //|< r
  ,.cfg_mul_shift_value             (cfg_bs_mul_shift_value[5:0])           //|< r
  ,.cfg_mul_src                     (cfg_bs_mul_src)                        //|< r
  ,.cfg_relu_bypass                 (cfg_bs_relu_bypass)                    //|< r
  ,.chn_alu_op                      (bs_alu_in_data[BS_OP_DW-1:0])          //|< w
  ,.chn_alu_op_pvld                 (bs_alu_in_vld)                         //|< w
  ,.chn_data_in                     (flop_bs_data_in_pd[BS_IN_DW-1:0])      //|< w
  ,.chn_in_pvld                     (flop_bs_data_in_pvld)                  //|< w
  ,.chn_mul_op                      (bs_mul_in_data[BS_OP_DW-1:0])          //|< w
  ,.chn_mul_op_pvld                 (bs_mul_in_vld)                         //|< w
  ,.chn_out_prdy                    (bs_data_out_prdy)                      //|< w
  ,.chn_alu_op_prdy                 (bs_alu_in_rdy)                         //|> w
  ,.chn_data_out                    (bs_data_out_pd[BS_OUT_DW-1:0])         //|> w
  ,.chn_in_prdy                     (flop_bs_data_in_prdy)                  //|> w
  ,.chn_mul_op_prdy                 (bs_mul_in_rdy)                         //|> w
  ,.chn_out_pvld                    (bs_data_out_pvld)                      //|> w
  ,.nvdla_core_clk                  (nvdla_gated_bcore_clk)                 //|< w
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  );


//covert NVDLA_SDP_BS_THROUGHPUT to NVDLA_SDP_MAX_THROUGHPUT
NV_NVDLA_SDP_CORE_unpack #(.IW(BS_OUT_DW),.OW(BS_DOUT_DW))  u_bs_dpunpack (
   .nvdla_core_clk                  (nvdla_gated_bcore_clk)                 //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.inp_pvld                        (bs_data_out_pvld)                      //|< i
  ,.inp_data                        (bs_data_out_pd[BS_OUT_DW-1:0])         //|< i
  ,.inp_prdy                        (bs_data_out_prdy)                      //|> o
  ,.out_pvld                        (flop_bs_data_out_pvld)                 //|> w
  ,.out_data                        (flop_bs_data_out_pd[BS_DOUT_DW-1:0])   //|> w
  ,.out_prdy                        (flop_bs_data_out_prdy)                 //|< w
  );

#endif


//===========================================
// MUX between BS and BN
//===========================================
#ifdef NVDLA_SDP_BN_ENABLE
assign flop_bs_data_out_prdy = cfg_bn_en ? bn_data_in_prdy : flop_bn_data_out_prdy;
#else
assign flop_bs_data_out_prdy = flop_bn_data_out_prdy;
#endif
assign bs2bn_data_pvld  = cfg_bs_en ? flop_bs_data_out_pvld : sdp_cmux2dp_valid;
assign bn_data_in_pd    = cfg_bs_en ? flop_bs_data_out_pd   : bs_data_in_pd;
#ifdef NVDLA_SDP_BN_ENABLE
assign bn_data_in_pvld  = cfg_bn_en & bs2bn_data_pvld;

//covert NVDLA_SDP_MAX_THROUGHPUT to NVDLA_SDP_BN_THROUGHPUT
NV_NVDLA_SDP_CORE_pack #(.IW(BN_DIN_DW),.OW(BN_IN_DW)) u_bn_dppack (
   .nvdla_core_clk                  (nvdla_gated_ncore_clk)                
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                      //|< i
  ,.inp_pvld                        (bn_data_in_pvld)                      //|< i
  ,.inp_data                        (bn_data_in_pd[BN_DIN_DW-1:0])         //|< i
  ,.inp_prdy                        (bn_data_in_prdy)                      //|> o
  ,.out_pvld                        (flop_bn_data_in_pvld)                 //|> w
  ,.out_data                        (flop_bn_data_in_pd[BN_IN_DW-1:0])     //|> w
  ,.out_prdy                        (flop_bn_data_in_prdy)                 //|< w
  );


NV_NVDLA_SDP_HLS_x2_int  u_bn (
   .nvdla_core_clk                  (nvdla_gated_ncore_clk)                 //|< w
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.cfg_alu_algo                    (cfg_bn_alu_algo[1:0])                  //|< r
  ,.cfg_alu_bypass                  (cfg_bn_alu_bypass)                     //|< r
  ,.cfg_alu_op                      (cfg_bn_alu_operand[15:0])              //|< r
  ,.cfg_alu_shift_value             (cfg_bn_alu_shift_value[5:0])           //|< r
  ,.cfg_alu_src                     (cfg_bn_alu_src)                        //|< r
  ,.cfg_mul_bypass                  (cfg_bn_mul_bypass)                     //|< r
  ,.cfg_mul_op                      (cfg_bn_mul_operand[15:0])              //|< r
  ,.cfg_mul_prelu                   (cfg_bn_mul_prelu)                      //|< r
  ,.cfg_mul_shift_value             (cfg_bn_mul_shift_value[5:0])           //|< r
  ,.cfg_mul_src                     (cfg_bn_mul_src)                        //|< r
  ,.cfg_relu_bypass                 (cfg_bn_relu_bypass)                    //|< r
  ,.chn_data_in                     (flop_bn_data_in_pd[BN_IN_DW-1:0])      //|< w
  ,.chn_in_pvld                     (flop_bn_data_in_pvld)                  //|< w
  ,.chn_in_prdy                     (flop_bn_data_in_prdy)                  //|> w
  ,.chn_alu_op                      (bn_alu_in_data[BN_OP_DW-1:0])          //|< w
  ,.chn_alu_op_pvld                 (bn_alu_in_vld)                         //|< w
  ,.chn_alu_op_prdy                 (bn_alu_in_rdy)                         //|> w
  ,.chn_mul_op                      (bn_mul_in_data[BN_OP_DW-1:0])          //|< w
  ,.chn_mul_op_pvld                 (bn_mul_in_vld)                         //|< w
  ,.chn_mul_op_prdy                 (bn_mul_in_rdy)                         //|> w
  ,.chn_out_prdy                    (bn_data_out_prdy)                      //|< w
  ,.chn_data_out                    (bn_data_out_pd[BN_OUT_DW-1:0])         //|> w
  ,.chn_out_pvld                    (bn_data_out_pvld)                      //|> w
  );


//covert NVDLA_SDP_BN_THROUGHPUT to NVDLA_SDP_MAX_THROUGHPUT
NV_NVDLA_SDP_CORE_unpack #(.IW(BN_OUT_DW),.OW(BN_DOUT_DW)) u_bn_dpunpack (
   .nvdla_core_clk                  (nvdla_gated_ncore_clk)                
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.inp_pvld                        (bn_data_out_pvld)                      //|< i
  ,.inp_data                        (bn_data_out_pd[BN_OUT_DW-1:0])         //|< i
  ,.inp_prdy                        (bn_data_out_prdy)                      //|> o
  ,.out_pvld                        (flop_bn_data_out_pvld)                 //|> w
  ,.out_data                        (flop_bn_data_out_pd[BN_DOUT_DW-1:0])   //|> w
  ,.out_prdy                        (flop_bn_data_out_prdy)                 //|< w
  );

#endif


//===========================================
// MUX between BN and EW
//===========================================
#ifdef NVDLA_SDP_EW_ENABLE
assign flop_bn_data_out_prdy = cfg_ew_en ? ew_data_in_prdy : flop_ew_data_out_prdy;
#else
assign flop_bn_data_out_prdy = flop_ew_data_out_prdy;
#endif
assign bn2ew_data_pvld  = cfg_bn_en ? flop_bn_data_out_pvld : bs2bn_data_pvld;
assign ew_data_in_pd    = cfg_bn_en ? flop_bn_data_out_pd   : bn_data_in_pd;
#ifdef NVDLA_SDP_EW_ENABLE
assign ew_data_in_pvld  = cfg_ew_en & bn2ew_data_pvld;

//===========================================
// CORE: y
//===========================================
//covert NVDLA_SDP_MAX_THROUGHPUT to NVDLA_SDP_EW_THROUGHPUT
NV_NVDLA_SDP_CORE_pack #(.IW(EW_DIN_DW),.OW(EW_IN_DW)) u_ew_dppack (
   .nvdla_core_clk                  (nvdla_gated_ecore_clk)                //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                      //|< i
  ,.inp_pvld                        (ew_data_in_pvld)                      //|< i
  ,.inp_data                        (ew_data_in_pd[EW_DIN_DW-1:0])         //|< i
  ,.inp_prdy                        (ew_data_in_prdy)                      //|> o
  ,.out_pvld                        (flop_ew_data_in_pvld)                 //|> w
  ,.out_data                        (flop_ew_data_in_pd[EW_IN_DW-1:0])     //|> w
  ,.out_prdy                        (flop_ew_data_in_prdy)                 //|< w
  );

NV_NVDLA_SDP_CORE_y u_ew (
   .nvdla_core_clk                  (nvdla_gated_ecore_clk)                 //|< w
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.ew_data_in_pd                   (flop_ew_data_in_pd[EW_IN_DW-1:0])      //|< w
  ,.ew_data_in_pvld                 (flop_ew_data_in_pvld)                  //|< w
  ,.ew_data_in_prdy                 (flop_ew_data_in_prdy)                  //|> w
  ,.ew_alu_in_data                  (ew_alu_in_data[EW_OP_DW-1:0])          //|< w
  ,.ew_alu_in_vld                   (ew_alu_in_vld)                         //|< w
  ,.ew_alu_in_rdy                   (ew_alu_in_rdy)                         //|> w
  ,.ew_mul_in_data                  (ew_mul_in_data[EW_OP_DW-1:0])          //|< w
  ,.ew_mul_in_vld                   (ew_mul_in_vld)                         //|< w
  ,.ew_mul_in_rdy                   (ew_mul_in_rdy)                         //|> w
  ,.ew_data_out_pd                  (ew_data_out_pd[EW_OUT_DW-1:0])         //|> w
  ,.ew_data_out_pvld                (ew_data_out_pvld)                      //|> w
  ,.ew_data_out_prdy                (ew_data_out_prdy)                      //|< w
  ,.reg2dp_ew_alu_algo              (reg2dp_ew_alu_algo[1:0])               //|< i
  ,.reg2dp_ew_alu_bypass            (reg2dp_ew_alu_bypass)                  //|< i
  ,.reg2dp_ew_alu_cvt_bypass        (reg2dp_ew_alu_cvt_bypass)              //|< i
  ,.reg2dp_ew_alu_cvt_offset        (reg2dp_ew_alu_cvt_offset[31:0])        //|< i
  ,.reg2dp_ew_alu_cvt_scale         (reg2dp_ew_alu_cvt_scale[15:0])         //|< i
  ,.reg2dp_ew_alu_cvt_truncate      (reg2dp_ew_alu_cvt_truncate[5:0])       //|< i
  ,.reg2dp_ew_alu_operand           (reg2dp_ew_alu_operand[31:0])           //|< i
  ,.reg2dp_ew_alu_src               (reg2dp_ew_alu_src)                     //|< i
  ,.reg2dp_ew_lut_bypass            (reg2dp_ew_lut_bypass)                  //|< i
  ,.reg2dp_ew_mul_bypass            (reg2dp_ew_mul_bypass)                  //|< i
  ,.reg2dp_ew_mul_cvt_bypass        (reg2dp_ew_mul_cvt_bypass)              //|< i
  ,.reg2dp_ew_mul_cvt_offset        (reg2dp_ew_mul_cvt_offset[31:0])        //|< i
  ,.reg2dp_ew_mul_cvt_scale         (reg2dp_ew_mul_cvt_scale[15:0])         //|< i
  ,.reg2dp_ew_mul_cvt_truncate      (reg2dp_ew_mul_cvt_truncate[5:0])       //|< i
  ,.reg2dp_ew_mul_operand           (reg2dp_ew_mul_operand[31:0])           //|< i
  ,.reg2dp_ew_mul_prelu             (reg2dp_ew_mul_prelu)                   //|< i
  ,.reg2dp_ew_mul_src               (reg2dp_ew_mul_src)                     //|< i
  ,.reg2dp_ew_truncate              (reg2dp_ew_truncate[9:0])               //|< i
#ifdef NVDLA_SDP_LUT_ENABLE
  ,.reg2dp_lut_hybrid_priority      (reg2dp_lut_hybrid_priority)            //|< i
  ,.reg2dp_lut_int_access_type      (reg2dp_lut_int_access_type)            //|< i
  ,.reg2dp_lut_int_addr             (reg2dp_lut_int_addr[9:0])              //|< i
  ,.reg2dp_lut_int_data             (reg2dp_lut_int_data[15:0])             //|< i
  ,.reg2dp_lut_int_data_wr          (reg2dp_lut_int_data_wr)                //|< i
  ,.reg2dp_lut_int_table_id         (reg2dp_lut_int_table_id)               //|< i
  ,.reg2dp_lut_le_end               (reg2dp_lut_le_end[31:0])               //|< i
  ,.reg2dp_lut_le_function          (reg2dp_lut_le_function)                //|< i
  ,.reg2dp_lut_le_index_offset      (reg2dp_lut_le_index_offset[7:0])       //|< i
  ,.reg2dp_lut_le_index_select      (reg2dp_lut_le_index_select[7:0])       //|< i
  ,.reg2dp_lut_le_slope_oflow_scale (reg2dp_lut_le_slope_oflow_scale[15:0]) //|< i
  ,.reg2dp_lut_le_slope_oflow_shift (reg2dp_lut_le_slope_oflow_shift[4:0])  //|< i
  ,.reg2dp_lut_le_slope_uflow_scale (reg2dp_lut_le_slope_uflow_scale[15:0]) //|< i
  ,.reg2dp_lut_le_slope_uflow_shift (reg2dp_lut_le_slope_uflow_shift[4:0])  //|< i
  ,.reg2dp_lut_le_start             (reg2dp_lut_le_start[31:0])             //|< i
  ,.reg2dp_lut_lo_end               (reg2dp_lut_lo_end[31:0])               //|< i
  ,.reg2dp_lut_lo_index_select      (reg2dp_lut_lo_index_select[7:0])       //|< i
  ,.reg2dp_lut_lo_slope_oflow_scale (reg2dp_lut_lo_slope_oflow_scale[15:0]) //|< i
  ,.reg2dp_lut_lo_slope_oflow_shift (reg2dp_lut_lo_slope_oflow_shift[4:0])  //|< i
  ,.reg2dp_lut_lo_slope_uflow_scale (reg2dp_lut_lo_slope_uflow_scale[15:0]) //|< i
  ,.reg2dp_lut_lo_slope_uflow_shift (reg2dp_lut_lo_slope_uflow_shift[4:0])  //|< i
  ,.reg2dp_lut_lo_start             (reg2dp_lut_lo_start[31:0])             //|< i
  ,.reg2dp_lut_oflow_priority       (reg2dp_lut_oflow_priority)             //|< i
  ,.reg2dp_lut_uflow_priority       (reg2dp_lut_uflow_priority)             //|< i
  ,.dp2reg_lut_hybrid               (dp2reg_lut_hybrid[31:0])               //|> o
  ,.dp2reg_lut_int_data             (dp2reg_lut_int_data[15:0])             //|> o
  ,.dp2reg_lut_le_hit               (dp2reg_lut_le_hit[31:0])               //|> o
  ,.dp2reg_lut_lo_hit               (dp2reg_lut_lo_hit[31:0])               //|> o
  ,.dp2reg_lut_oflow                (dp2reg_lut_oflow[31:0])                //|> o
  ,.dp2reg_lut_uflow                (dp2reg_lut_uflow[31:0])                //|> o
#endif
  ,.reg2dp_nan_to_zero              (reg2dp_nan_to_zero)                    //|< i
  ,.reg2dp_perf_lut_en              (reg2dp_perf_lut_en)                    //|< i
  ,.reg2dp_proc_precision           (reg2dp_proc_precision[1:0])            //|< i
  ,.pwrbus_ram_pd                   (pwrbus_ram_pd[31:0])                   //|< i
  ,.op_en_load                      (op_en_load)                            //|< w
  );


//covert NVDLA_SDP_EW_THROUGHPUT to NVDLA_SDP_MAX_THROUGHPUT
NV_NVDLA_SDP_CORE_unpack #(.IW(EW_OUT_DW),.OW(EW_DOUT_DW)) u_ew_dpunpack (
   .nvdla_core_clk                  (nvdla_gated_ecore_clk)                 //|< w
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.inp_pvld                        (ew_data_out_pvld)                      //|< w
  ,.inp_data                        (ew_data_out_pd[EW_OUT_DW-1:0])         //|< w
  ,.inp_prdy                        (ew_data_out_prdy)                      //|> w
  ,.out_pvld                        (flop_ew_data_out_pvld)                 //|> o
  ,.out_data                        (flop_ew_data_out_pd[EW_DOUT_DW-1:0])   //|> o
  ,.out_prdy                        (flop_ew_data_out_prdy)                 //|< i
  );



//===========================================
// MUX between EW and CVT
//===========================================
assign flop_ew_data_out_prdy = cvt_data_in_prdy;
assign ew2cvt_data_pvld  = cfg_ew_en ? flop_ew_data_out_pvld : bn2ew_data_pvld;
assign cvt_data_in_pvld  = ew2cvt_data_pvld;
assign cvt_data_in_pd    = cfg_ew_en ? flop_ew_data_out_pd   : ew_data_in_pd;
#else 
assign flop_ew_data_out_prdy = cvt_data_in_prdy;
assign cvt_data_in_pvld  = bn2ew_data_pvld; 
assign cvt_data_in_pd    = ew_data_in_pd;
#endif


NV_NVDLA_SDP_HLS_c u_c (
   .cfg_mode_eql                    (cfg_mode_eql)                          //|< r
  ,.cfg_out_precision               (cfg_out_precision[1:0])                //|< r
  ,.cfg_offset                      (cfg_cvt_offset[31:0])                  //|< r
  ,.cfg_scale                       (cfg_cvt_scale[15:0])                   //|< r
  ,.cfg_truncate                    (cfg_cvt_shift[5:0])                    //|< r
  ,.cvt_in_pvld                     (cvt_data_in_pvld)                      //|< w
  ,.cvt_in_prdy                     (cvt_data_in_prdy)                      //|> w
  ,.cvt_pd_in                       (cvt_data_in_pd[CV_IN_DW-1:0])          //|< w
  ,.cvt_out_pvld                    (cvt_data_out_pvld)                     //|> w
  ,.cvt_out_prdy                    (cvt_data_out_prdy)                     //|< w
  ,.cvt_pd_out                      (cvt_data_out_pd[CV_OUT_DW+NVDLA_SDP_MAX_THROUGHPUT-1:0])                //|> w
  ,.nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  );

assign cvt_data_out_data = cvt_data_out_pd[CV_OUT_DW-1:0];
assign cvt_data_out_sat  = cvt_data_out_pd[CV_OUT_DW+NVDLA_SDP_MAX_THROUGHPUT-1:CV_OUT_DW];

// to (PDP | WDMA)
assign cfg_mode_pdp    = reg2dp_output_dst== 1'h1 ;
assign cvt_data_out_prdy = core2wdma_rdy & ((!cfg_mode_pdp) || core2pdp_rdy);

assign core2wdma_vld  = cvt_data_out_pvld & ( (!cfg_mode_pdp) || core2pdp_rdy);
assign core2pdp_vld   = cfg_mode_pdp & cvt_data_out_pvld & core2wdma_rdy;

assign core2wdma_pd = cfg_mode_pdp ? {DP_OUT_DW{1'b0}} : cvt_data_out_data;
assign core2pdp_pd  = cfg_mode_pdp ? cvt_data_out_data[DP_OUT_DW-1:0] : {DP_OUT_DW{1'b0}};

//covert NVDLA_SDP_MAX_THROUGHPUT to atomic_m
//only int8 or int16. If support both, use NV_NVDLA_SDP_WDMA_unpack
NV_NVDLA_SDP_CORE_unpack  #(.IW(DP_OUT_DW),.OW(DP_DOUT_DW)) u_dpout_unpack (
   .nvdla_core_clk                  (nvdla_core_clk)                
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                      
  ,.inp_pvld                        (core2wdma_vld)                 
  ,.inp_prdy                        (core2wdma_rdy)                 
  ,.inp_data                        (core2wdma_pd[DP_OUT_DW-1:0])   
  ,.out_pvld                        (sdp_dp2wdma_valid)                   
  ,.out_prdy                        (sdp_dp2wdma_ready)                   
  ,.out_data                        (sdp_dp2wdma_pd[DP_DOUT_DW-1:0])     
  );


//pdp THROUGHPUT is NVDLA_SDP_MAX_THROUGHPUT
NV_NVDLA_SDP_CORE_pipe_p11 pipe_p11 (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.core2pdp_pd                     (core2pdp_pd[DP_OUT_DW-1:0])            //|< w
  ,.core2pdp_vld                    (core2pdp_vld)                          //|< w
  ,.core2pdp_rdy                    (core2pdp_rdy)                          //|> w
  ,.sdp2pdp_pd                      (sdp2pdp_pd[DP_OUT_DW-1:0])             //|> o
  ,.sdp2pdp_valid                   (sdp2pdp_valid)                         //|> o
  ,.sdp2pdp_ready                   (sdp2pdp_ready)                         //|< i
  );


//===========================================
// PERF STATISTIC: SATURATION 
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    saturation_bits <= {NVDLA_SDP_MAX_THROUGHPUT{1'b0}};
  end else begin
    if (cvt_data_out_pvld & cvt_data_out_prdy) begin
    #ifdef NVDLA_FEATURE_DATA_TYPE_FP16
        if (cfg_out_precision== 2'h2 ) begin
            saturation_bits[0] <= (cvt_data_out_data[15:0]== 16'h7bff ) | (cvt_data_out_data[15:0]== 16'hfbff );
            saturation_bits[1] <= (cvt_data_out_data[31:16]== 16'h7bff ) | (cvt_data_out_data[31:16]== 16'hfbff );
            saturation_bits[2] <= (cvt_data_out_data[47:32]== 16'h7bff ) | (cvt_data_out_data[47:32]== 16'hfbff );
            saturation_bits[3] <= (cvt_data_out_data[63:48]== 16'h7bff ) | (cvt_data_out_data[63:48]== 16'hfbff );
            saturation_bits[4] <= (cvt_data_out_data[79:64]== 16'h7bff ) | (cvt_data_out_data[79:64]== 16'hfbff );
            saturation_bits[5] <= (cvt_data_out_data[95:80]== 16'h7bff ) | (cvt_data_out_data[95:80]== 16'hfbff );
            saturation_bits[6] <= (cvt_data_out_data[111:96]== 16'h7bff ) | (cvt_data_out_data[111:96]== 16'hfbff );
            saturation_bits[7] <= (cvt_data_out_data[127:112]== 16'h7bff ) | (cvt_data_out_data[127:112]== 16'hfbff );
            saturation_bits[8] <= (cvt_data_out_data[143:128]== 16'h7bff ) | (cvt_data_out_data[143:128]== 16'hfbff );
            saturation_bits[9] <= (cvt_data_out_data[159:144]== 16'h7bff ) | (cvt_data_out_data[159:144]== 16'hfbff );
            saturation_bits[10] <= (cvt_data_out_data[175:160]== 16'h7bff ) | (cvt_data_out_data[175:160]== 16'hfbff );
            saturation_bits[11] <= (cvt_data_out_data[191:176]== 16'h7bff ) | (cvt_data_out_data[191:176]== 16'hfbff );
            saturation_bits[12] <= (cvt_data_out_data[207:192]== 16'h7bff ) | (cvt_data_out_data[207:192]== 16'hfbff );
            saturation_bits[13] <= (cvt_data_out_data[223:208]== 16'h7bff ) | (cvt_data_out_data[223:208]== 16'hfbff );
            saturation_bits[14] <= (cvt_data_out_data[239:224]== 16'h7bff ) | (cvt_data_out_data[239:224]== 16'hfbff );
            saturation_bits[15] <= (cvt_data_out_data[255:240]== 16'h7bff ) | (cvt_data_out_data[255:240]== 16'hfbff );
        end else
     #endif 
          saturation_bits <= cvt_data_out_sat;
    end else begin
        saturation_bits <= 0;
    end
  end
end

assign cvt_saturation_add = fun_my_bit_sum({{(16-NVDLA_SDP_MAX_THROUGHPUT){1'b0}},saturation_bits});
assign cvt_saturation_sub = 1'b0;
assign cvt_saturation_clr = op_en_load;
assign cvt_saturation_cen = reg2dp_perf_sat_en;

assign cvt_sat_add_ext = cvt_saturation_add;
assign cvt_sat_sub_ext = {{4{1'b0}}, cvt_saturation_sub};
assign cvt_sat_inc = cvt_sat_add_ext > cvt_sat_sub_ext; 
assign cvt_sat_dec = cvt_sat_add_ext < cvt_sat_sub_ext; 
assign cvt_sat_mod_ext[4:0] = cvt_sat_inc ? (cvt_sat_add_ext - cvt_sat_sub_ext) : (cvt_sat_sub_ext - cvt_sat_add_ext); // spyglass disable W484 

assign cvt_sat_sub_guard = (|cvt_saturation_cnt[31:1])==1'b0;
assign cvt_sat_sub_act = cvt_saturation_cnt[0:0];
assign cvt_sat_sub_act_ext = {{4{1'b0}}, cvt_sat_sub_act};
assign cvt_sat_sub_flow = cvt_sat_dec & cvt_sat_sub_guard & (cvt_sat_sub_act_ext < cvt_sat_mod_ext);

assign cvt_sat_add_guard = (&cvt_saturation_cnt[31:5])==1'b1;
assign cvt_sat_add_act = cvt_saturation_cnt[4:0];
assign cvt_sat_add_act_ext = cvt_sat_add_act;
assign cvt_sat_add_flow = cvt_sat_inc & cvt_sat_add_guard & (cvt_sat_add_act_ext + cvt_sat_mod_ext > 31 );

assign i_add = cvt_sat_add_flow ? (31 - cvt_sat_add_act) : cvt_sat_sub_flow ? 0 : cvt_saturation_add;
assign i_sub = cvt_sat_sub_flow ? (cvt_sat_sub_act) : cvt_sat_add_flow ? 0 : cvt_saturation_sub ;


always @(
  i_add
  or i_sub
  ) begin
  cvt_sat_cvt_sat_adv = i_add[4:0] != {{4{1'b0}}, i_sub[0:0]};
end
    
always @(
  cvt_sat_cvt_sat_cnt_cur
  or i_add
  or i_sub
  or cvt_sat_cvt_sat_adv
  or cvt_saturation_clr
  ) begin
  cvt_sat_cvt_sat_cnt_ext[33:0] = {1'b0, 1'b0, cvt_sat_cvt_sat_cnt_cur};
  cvt_sat_cvt_sat_cnt_mod[33:0] = cvt_sat_cvt_sat_cnt_cur + i_add[4:0] - i_sub[0:0]; // spyglass disable W164b
  cvt_sat_cvt_sat_cnt_new[33:0] = (cvt_sat_cvt_sat_adv)? cvt_sat_cvt_sat_cnt_mod[33:0] : cvt_sat_cvt_sat_cnt_ext[33:0];
  cvt_sat_cvt_sat_cnt_nxt[33:0] = (cvt_saturation_clr)? 34'd0 : cvt_sat_cvt_sat_cnt_new[33:0];
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_sat_cvt_sat_cnt_cur[31:0] <= 0;
  end else begin
  if (cvt_saturation_cen) begin
  cvt_sat_cvt_sat_cnt_cur[31:0] <= cvt_sat_cvt_sat_cnt_nxt[31:0];
  end
  end
end

always @(
  cvt_sat_cvt_sat_cnt_cur
  ) begin
  cvt_saturation_cnt[31:0] = cvt_sat_cvt_sat_cnt_cur[31:0];
end


assign dp2reg_out_saturation = cvt_saturation_cnt;

function [4:0] fun_my_bit_sum;
  input [15:0] idata;
  reg [4:0] ocnt;
  begin
    ocnt =
        ((( idata[0]  
      +  idata[1]  
      +  idata[2] ) 
      + ( idata[3]  
      +  idata[4]  
      +  idata[5] )) 
      + (( idata[6]  
      +  idata[7]  
      +  idata[8] ) 
      + ( idata[9]  
      +  idata[10]  
      +  idata[11] ))) 
      + ( idata[12]  
      +  idata[13]  
      +  idata[14] ) 
      +  idata[15]  ;
    fun_my_bit_sum = ocnt;
  end
endfunction


endmodule // NV_NVDLA_SDP_core



// **************************************************************************************************************
// Generated by ::pipe -m -bc sdp2pdp_pd (sdp2pdp_valid,sdp2pdp_ready) <= core2pdp_pd[255:0] (core2pdp_vld,core2pdp_rdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_CORE_pipe_p11 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,core2pdp_pd
  ,core2pdp_vld
  ,sdp2pdp_ready
  ,core2pdp_rdy
  ,sdp2pdp_pd
  ,sdp2pdp_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [DP_OUT_DW-1:0] core2pdp_pd;
input          core2pdp_vld;
input          sdp2pdp_ready;
output         core2pdp_rdy;
output [DP_OUT_DW-1:0] sdp2pdp_pd;
output         sdp2pdp_valid;


//: my $dw = DP_OUT_DW;
//: &eperl::pipe("-is -wid $dw -do sdp2pdp_pd -vo sdp2pdp_valid -ri sdp2pdp_ready -di core2pdp_pd -vi core2pdp_vld -ro core2pdp_rdy");



endmodule // NV_NVDLA_SDP_CORE_pipe_p11


