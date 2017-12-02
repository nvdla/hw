// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_core.v

module NV_NVDLA_SDP_core (
   nvdla_core_clk                  //|< i
  ,nvdla_core_rstn                 //|< i
  ,cacc2sdp_pd                     //|< i
  ,cacc2sdp_valid                  //|< i
  ,dla_clk_ovr_on_sync             //|< i
  ,dp2reg_done                     //|< i
  ,global_clk_ovr_on_sync          //|< i
  ,pwrbus_ram_pd                   //|< i
  ,reg2dp_bcore_slcg_op_en         //|< i
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
  ,reg2dp_cvt_offset               //|< i
  ,reg2dp_cvt_scale                //|< i
  ,reg2dp_cvt_shift                //|< i
  ,reg2dp_ecore_slcg_op_en         //|< i
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
  ,reg2dp_flying_mode              //|< i
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
  ,reg2dp_lut_slcg_en              //|< i
  ,reg2dp_lut_uflow_priority       //|< i
  ,reg2dp_nan_to_zero              //|< i
  ,reg2dp_ncore_slcg_op_en         //|< i
  ,reg2dp_op_en                    //|< i
  ,reg2dp_out_precision            //|< i
  ,reg2dp_output_dst               //|< i
  ,reg2dp_perf_lut_en              //|< i
  ,reg2dp_perf_sat_en              //|< i
  ,reg2dp_proc_precision           //|< i
  ,sdp2pdp_ready                   //|< i
  ,sdp_brdma2dp_alu_pd             //|< i
  ,sdp_brdma2dp_alu_valid          //|< i
  ,sdp_brdma2dp_mul_pd             //|< i
  ,sdp_brdma2dp_mul_valid          //|< i
  ,sdp_dp2wdma_ready               //|< i
  ,sdp_erdma2dp_alu_pd             //|< i
  ,sdp_erdma2dp_alu_valid          //|< i
  ,sdp_erdma2dp_mul_pd             //|< i
  ,sdp_erdma2dp_mul_valid          //|< i
  ,sdp_mrdma2cmux_pd               //|< i
  ,sdp_mrdma2cmux_valid            //|< i
  ,sdp_nrdma2dp_alu_pd             //|< i
  ,sdp_nrdma2dp_alu_valid          //|< i
  ,sdp_nrdma2dp_mul_pd             //|< i
  ,sdp_nrdma2dp_mul_valid          //|< i
  ,tmc2slcg_disable_clock_gating   //|< i
  ,cacc2sdp_ready                  //|> o
  ,dp2reg_lut_hybrid               //|> o
  ,dp2reg_lut_int_data             //|> o
  ,dp2reg_lut_le_hit               //|> o
  ,dp2reg_lut_lo_hit               //|> o
  ,dp2reg_lut_oflow                //|> o
  ,dp2reg_lut_uflow                //|> o
  ,dp2reg_out_saturation           //|> o
  ,sdp2pdp_pd                      //|> o
  ,sdp2pdp_valid                   //|> o
  ,sdp_brdma2dp_alu_ready          //|> o
  ,sdp_brdma2dp_mul_ready          //|> o
  ,sdp_dp2wdma_pd                  //|> o
  ,sdp_dp2wdma_valid               //|> o
  ,sdp_erdma2dp_alu_ready          //|> o
  ,sdp_erdma2dp_mul_ready          //|> o
  ,sdp_mrdma2cmux_ready            //|> o
  ,sdp_nrdma2dp_alu_ready          //|> o
  ,sdp_nrdma2dp_mul_ready          //|> o
  );

//
// NV_NVDLA_SDP_core_ports.v
//
input  nvdla_core_clk;   /* sdp_brdma2dp_mul, sdp_brdma2dp_alu, sdp_nrdma2dp_mul, sdp_nrdma2dp_alu, sdp_erdma2dp_mul, sdp_erdma2dp_alu, sdp_dp2wdma, sdp2pdp, cacc2sdp, sdp_mrdma2cmux */
input  nvdla_core_rstn;  /* sdp_brdma2dp_mul, sdp_brdma2dp_alu, sdp_nrdma2dp_mul, sdp_nrdma2dp_alu, sdp_erdma2dp_mul, sdp_erdma2dp_alu, sdp_dp2wdma, sdp2pdp, cacc2sdp, sdp_mrdma2cmux */

input          sdp_brdma2dp_mul_valid;  /* data valid */
output         sdp_brdma2dp_mul_ready;  /* data return handshake */
input  [256:0] sdp_brdma2dp_mul_pd;

input          sdp_brdma2dp_alu_valid;  /* data valid */
output         sdp_brdma2dp_alu_ready;  /* data return handshake */
input  [256:0] sdp_brdma2dp_alu_pd;

input          sdp_nrdma2dp_mul_valid;  /* data valid */
output         sdp_nrdma2dp_mul_ready;  /* data return handshake */
input  [256:0] sdp_nrdma2dp_mul_pd;

input          sdp_nrdma2dp_alu_valid;  /* data valid */
output         sdp_nrdma2dp_alu_ready;  /* data return handshake */
input  [256:0] sdp_nrdma2dp_alu_pd;

input          sdp_erdma2dp_mul_valid;  /* data valid */
output         sdp_erdma2dp_mul_ready;  /* data return handshake */
input  [256:0] sdp_erdma2dp_mul_pd;

input          sdp_erdma2dp_alu_valid;  /* data valid */
output         sdp_erdma2dp_alu_ready;  /* data return handshake */
input  [256:0] sdp_erdma2dp_alu_pd;

output         sdp_dp2wdma_valid;  /* data valid */
input          sdp_dp2wdma_ready;  /* data return handshake */
output [255:0] sdp_dp2wdma_pd;

output         sdp2pdp_valid;  /* data valid */
input          sdp2pdp_ready;  /* data return handshake */
output [255:0] sdp2pdp_pd;

input [31:0] pwrbus_ram_pd;

input          cacc2sdp_valid;  /* data valid */
output         cacc2sdp_ready;  /* data return handshake */
input  [513:0] cacc2sdp_pd;

input          sdp_mrdma2cmux_valid;  /* data valid */
output         sdp_mrdma2cmux_ready;  /* data return handshake */
input  [513:0] sdp_mrdma2cmux_pd;

input          reg2dp_bcore_slcg_op_en;
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
input   [31:0] reg2dp_cvt_offset;
input   [15:0] reg2dp_cvt_scale;
input    [5:0] reg2dp_cvt_shift;
input          reg2dp_ecore_slcg_op_en;
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
input          reg2dp_flying_mode;
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
input          reg2dp_lut_slcg_en;
input          reg2dp_lut_uflow_priority;
input          reg2dp_nan_to_zero;
input          reg2dp_ncore_slcg_op_en;
input          reg2dp_op_en;
input    [1:0] reg2dp_out_precision;
input          reg2dp_output_dst;
input          reg2dp_perf_lut_en;
input          reg2dp_perf_sat_en;
input    [1:0] reg2dp_proc_precision;
input          dp2reg_done;
output  [31:0] dp2reg_lut_hybrid;
output  [15:0] dp2reg_lut_int_data;
output  [31:0] dp2reg_lut_le_hit;
output  [31:0] dp2reg_lut_lo_hit;
output  [31:0] dp2reg_lut_oflow;
output  [31:0] dp2reg_lut_uflow;
output  [31:0] dp2reg_out_saturation;
input          dla_clk_ovr_on_sync;
input          global_clk_ovr_on_sync;
input          tmc2slcg_disable_clock_gating;

reg            bn_alu_in_en;
reg            bn_mul_in_en;
reg            bs_alu_in_en;
reg            bs_mul_in_en;
reg      [1:0] cfg_bn_alu_algo;
reg            cfg_bn_alu_bypass;
reg     [15:0] cfg_bn_alu_operand;
reg      [5:0] cfg_bn_alu_shift_value;
reg            cfg_bn_alu_src;
reg            cfg_bn_en;
reg            cfg_bn_mul_bypass;
reg     [15:0] cfg_bn_mul_operand;
reg            cfg_bn_mul_prelu;
reg      [7:0] cfg_bn_mul_shift_value;
reg            cfg_bn_mul_src;
reg            cfg_bn_relu_bypass;
reg      [1:0] cfg_bs_alu_algo;
reg            cfg_bs_alu_bypass;
reg     [15:0] cfg_bs_alu_operand;
reg      [5:0] cfg_bs_alu_shift_value;
reg            cfg_bs_alu_src;
reg            cfg_bs_en;
reg            cfg_bs_mul_bypass;
reg     [15:0] cfg_bs_mul_operand;
reg            cfg_bs_mul_prelu;
reg      [7:0] cfg_bs_mul_shift_value;
reg            cfg_bs_mul_src;
reg            cfg_bs_relu_bypass;
reg     [31:0] cfg_cvt_offset;
reg     [15:0] cfg_cvt_scale;
reg      [5:0] cfg_cvt_shift;
reg            cfg_ew_en;
reg            cfg_mode_eql;
reg            cfg_nan_to_zero;
reg      [1:0] cfg_out_precision;
reg      [1:0] cfg_proc_precision;
reg            cvt_sat_cvt_sat_adv;
reg     [31:0] cvt_sat_cvt_sat_cnt_cur;
reg     [33:0] cvt_sat_cvt_sat_cnt_ext;
reg     [33:0] cvt_sat_cvt_sat_cnt_mod;
reg     [33:0] cvt_sat_cvt_sat_cnt_new;
reg     [33:0] cvt_sat_cvt_sat_cnt_nxt;
reg     [31:0] cvt_saturation_cnt;
reg            ew_alu_in_en;
reg            ew_mul_in_en;
reg     [15:0] saturation_bits;
reg            wait_for_op_en;
wire           bcore_slcg_en;
wire           bn2ew_data_pvld;
wire   [255:0] bn_alu_in_data;
wire           bn_alu_in_layer_end;
wire   [256:0] bn_alu_in_pd;
wire           bn_alu_in_prdy;
wire           bn_alu_in_pvld;
wire           bn_alu_in_rdy;
wire           bn_alu_in_vld;
wire   [511:0] bn_data_in_pd;
wire           bn_data_in_prdy;
wire           bn_data_in_pvld;
wire   [511:0] bn_data_out_pd;
wire           bn_data_out_prdy;
wire           bn_data_out_pvld;
wire   [255:0] bn_mul_in_data;
wire           bn_mul_in_layer_end;
wire   [256:0] bn_mul_in_pd;
wire           bn_mul_in_prdy;
wire           bn_mul_in_pvld;
wire           bn_mul_in_rdy;
wire           bn_mul_in_vld;
wire           bs2bn_data_pvld;
wire   [255:0] bs_alu_in_data;
wire           bs_alu_in_layer_end;
wire   [256:0] bs_alu_in_pd;
wire           bs_alu_in_prdy;
wire           bs_alu_in_pvld;
wire           bs_alu_in_rdy;
wire           bs_alu_in_vld;
wire   [511:0] bs_data_in_pd;
wire           bs_data_in_prdy;
wire           bs_data_in_pvld;
wire   [511:0] bs_data_out_pd;
wire           bs_data_out_prdy;
wire           bs_data_out_pvld;
wire   [255:0] bs_mul_in_data;
wire           bs_mul_in_layer_end;
wire   [256:0] bs_mul_in_pd;
wire           bs_mul_in_prdy;
wire           bs_mul_in_pvld;
wire           bs_mul_in_rdy;
wire           bs_mul_in_vld;
wire           cfg_mode_pdp;
wire   [255:0] core2pdp_pd;
wire           core2pdp_rdy;
wire           core2pdp_vld;
wire   [255:0] core2wdma_pd;
wire           core2wdma_rdy;
wire           core2wdma_vld;
wire   [511:0] cvt_data_in_pd;
wire           cvt_data_in_prdy;
wire           cvt_data_in_pvld;
wire   [255:0] cvt_data_out_data;
wire   [271:0] cvt_data_out_pd;
wire           cvt_data_out_prdy;
wire           cvt_data_out_pvld;
wire    [15:0] cvt_data_out_sat;
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
wire           ecore_slcg_en;
wire           ew2cvt_data_pvld;
wire   [255:0] ew_alu_in_data;
wire           ew_alu_in_layer_end;
wire   [256:0] ew_alu_in_pd;
wire           ew_alu_in_prdy;
wire           ew_alu_in_pvld;
wire           ew_alu_in_rdy;
wire           ew_alu_in_vld;
wire   [511:0] ew_data_in_pd;
wire           ew_data_in_prdy;
wire           ew_data_in_pvld;
wire   [511:0] ew_data_out_pd;
wire           ew_data_out_prdy;
wire           ew_data_out_pvld;
wire   [255:0] ew_mul_in_data;
wire           ew_mul_in_layer_end;
wire   [256:0] ew_mul_in_pd;
wire           ew_mul_in_prdy;
wire           ew_mul_in_pvld;
wire           ew_mul_in_rdy;
wire           ew_mul_in_vld;
wire   [511:0] flop_bn_data_in_pd;
wire           flop_bn_data_in_prdy;
wire           flop_bn_data_in_pvld;
wire   [511:0] flop_bs_data_in_pd;
wire           flop_bs_data_in_prdy;
wire           flop_bs_data_in_pvld;
wire   [511:0] flop_cvt_data_in_pd;
wire           flop_cvt_data_in_prdy;
wire           flop_cvt_data_in_pvld;
wire     [4:0] i_add;
wire     [0:0] i_sub;
wire           ncore_slcg_en;
wire           nvdla_gated_bcore_clk;
wire           nvdla_gated_ecore_clk;
wire           nvdla_gated_ncore_clk;
wire           op_en_load;
wire   [511:0] sdp_cmux2dp_data;
wire   [511:0] sdp_cmux2dp_pd;
wire           sdp_cmux2dp_ready;
wire           sdp_cmux2dp_valid;

// data from MUX ? CC : MEM
NV_NVDLA_SDP_cmux u_NV_NVDLA_SDP_cmux (
   .nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.cacc2sdp_valid                    (cacc2sdp_valid)                        //|< i
  ,.cacc2sdp_ready                    (cacc2sdp_ready)                        //|> o
  ,.cacc2sdp_pd                       (cacc2sdp_pd[513:0])                    //|< i
  ,.sdp_mrdma2cmux_valid              (sdp_mrdma2cmux_valid)                  //|< i
  ,.sdp_mrdma2cmux_ready              (sdp_mrdma2cmux_ready)                  //|> o
  ,.sdp_mrdma2cmux_pd                 (sdp_mrdma2cmux_pd[513:0])              //|< i
  ,.sdp_cmux2dp_ready                 (sdp_cmux2dp_ready)                     //|< w
  ,.sdp_cmux2dp_pd                    (sdp_cmux2dp_pd[511:0])                 //|> w
  ,.sdp_cmux2dp_valid                 (sdp_cmux2dp_valid)                     //|> w
  ,.reg2dp_flying_mode                (reg2dp_flying_mode)                    //|< i
  ,.reg2dp_nan_to_zero                (reg2dp_nan_to_zero)                    //|< i
  ,.reg2dp_proc_precision             (reg2dp_proc_precision[1:0])            //|< i
  ,.op_en_load                        (op_en_load)                            //|< w
  );

// PKT_UNPACK_WIRE( sdp_cmux2dp , sdp_cmux2dp_ , sdp_cmux2dp_pd )
assign       sdp_cmux2dp_data[511:0] =    sdp_cmux2dp_pd[511:0];

//=====BS=======
// data for MULTIPLE
NV_NVDLA_SDP_CORE_pipe_p1 pipe_p1 (
   .nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.bs_mul_in_prdy                    (bs_mul_in_prdy)                        //|< w
  ,.sdp_brdma2dp_mul_pd               (sdp_brdma2dp_mul_pd[256:0])            //|< i
  ,.sdp_brdma2dp_mul_valid            (sdp_brdma2dp_mul_valid)                //|< i
  ,.bs_mul_in_pd                      (bs_mul_in_pd[256:0])                   //|> w
  ,.bs_mul_in_pvld                    (bs_mul_in_pvld)                        //|> w
  ,.sdp_brdma2dp_mul_ready            (sdp_brdma2dp_mul_ready)                //|> o
  );

// PKT_UNPACK_WIRE( sdp_brdma2dp_mul , bs_mul_in_ , bs_mul_in_pd )
assign       bs_mul_in_data[255:0] =    bs_mul_in_pd[255:0];
assign        bs_mul_in_layer_end  =    bs_mul_in_pd[256];
// out_data

// data for ALU (MAX,MIN,SUM)
NV_NVDLA_SDP_CORE_pipe_p2 pipe_p2 (
   .nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.bs_alu_in_prdy                    (bs_alu_in_prdy)                        //|< w
  ,.sdp_brdma2dp_alu_pd               (sdp_brdma2dp_alu_pd[256:0])            //|< i
  ,.sdp_brdma2dp_alu_valid            (sdp_brdma2dp_alu_valid)                //|< i
  ,.bs_alu_in_pd                      (bs_alu_in_pd[256:0])                   //|> w
  ,.bs_alu_in_pvld                    (bs_alu_in_pvld)                        //|> w
  ,.sdp_brdma2dp_alu_ready            (sdp_brdma2dp_alu_ready)                //|> o
  );

// PKT_UNPACK_WIRE( sdp_brdma2dp_alu , bs_alu_in_ , bs_alu_in_pd )
assign       bs_alu_in_data[255:0] =    bs_alu_in_pd[255:0];
assign        bs_alu_in_layer_end  =    bs_alu_in_pd[256];
// out_data

//=====BN=======
// data for MULTIPLE
NV_NVDLA_SDP_CORE_pipe_p3 pipe_p3 (
   .nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.bn_mul_in_prdy                    (bn_mul_in_prdy)                        //|< w
  ,.sdp_nrdma2dp_mul_pd               (sdp_nrdma2dp_mul_pd[256:0])            //|< i
  ,.sdp_nrdma2dp_mul_valid            (sdp_nrdma2dp_mul_valid)                //|< i
  ,.bn_mul_in_pd                      (bn_mul_in_pd[256:0])                   //|> w
  ,.bn_mul_in_pvld                    (bn_mul_in_pvld)                        //|> w
  ,.sdp_nrdma2dp_mul_ready            (sdp_nrdma2dp_mul_ready)                //|> o
  );

// PKT_UNPACK_WIRE( sdp_nrdma2dp_mul , bn_mul_in_ , bn_mul_in_pd )
assign       bn_mul_in_data[255:0] =    bn_mul_in_pd[255:0];
assign        bn_mul_in_layer_end  =    bn_mul_in_pd[256];
// out_data

// data for ALU (MAX,MIN,SUM)
NV_NVDLA_SDP_CORE_pipe_p4 pipe_p4 (
   .nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.bn_alu_in_prdy                    (bn_alu_in_prdy)                        //|< w
  ,.sdp_nrdma2dp_alu_pd               (sdp_nrdma2dp_alu_pd[256:0])            //|< i
  ,.sdp_nrdma2dp_alu_valid            (sdp_nrdma2dp_alu_valid)                //|< i
  ,.bn_alu_in_pd                      (bn_alu_in_pd[256:0])                   //|> w
  ,.bn_alu_in_pvld                    (bn_alu_in_pvld)                        //|> w
  ,.sdp_nrdma2dp_alu_ready            (sdp_nrdma2dp_alu_ready)                //|> o
  );

// PKT_UNPACK_WIRE( sdp_nrdma2dp_alu , bn_alu_in_ , bn_alu_in_pd )
assign       bn_alu_in_data[255:0] =    bn_alu_in_pd[255:0];
assign        bn_alu_in_layer_end  =    bn_alu_in_pd[256];
// out_data

//=====EW=======
// data for MULTIPLE
NV_NVDLA_SDP_CORE_pipe_p5 pipe_p5 (
   .nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.ew_mul_in_prdy                    (ew_mul_in_prdy)                        //|< w
  ,.sdp_erdma2dp_mul_pd               (sdp_erdma2dp_mul_pd[256:0])            //|< i
  ,.sdp_erdma2dp_mul_valid            (sdp_erdma2dp_mul_valid)                //|< i
  ,.ew_mul_in_pd                      (ew_mul_in_pd[256:0])                   //|> w
  ,.ew_mul_in_pvld                    (ew_mul_in_pvld)                        //|> w
  ,.sdp_erdma2dp_mul_ready            (sdp_erdma2dp_mul_ready)                //|> o
  );

// PKT_UNPACK_WIRE( sdp_erdma2dp_mul , ew_mul_in_ , ew_mul_in_pd )
assign       ew_mul_in_data[255:0] =    ew_mul_in_pd[255:0];
assign        ew_mul_in_layer_end  =    ew_mul_in_pd[256];
// out_data

// data for ALU (MAX,MIN,SUM)
NV_NVDLA_SDP_CORE_pipe_p6 pipe_p6 (
   .nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.ew_alu_in_prdy                    (ew_alu_in_prdy)                        //|< w
  ,.sdp_erdma2dp_alu_pd               (sdp_erdma2dp_alu_pd[256:0])            //|< i
  ,.sdp_erdma2dp_alu_valid            (sdp_erdma2dp_alu_valid)                //|< i
  ,.ew_alu_in_pd                      (ew_alu_in_pd[256:0])                   //|> w
  ,.ew_alu_in_pvld                    (ew_alu_in_pvld)                        //|> w
  ,.sdp_erdma2dp_alu_ready            (sdp_erdma2dp_alu_ready)                //|> o
  );

// PKT_UNPACK_WIRE( sdp_erdma2dp_alu , ew_alu_in_ , ew_alu_in_pd )
assign       ew_alu_in_data[255:0] =    ew_alu_in_pd[255:0];
assign        ew_alu_in_layer_end  =    ew_alu_in_pd[256];
// out_data

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
        cfg_bs_en     <= reg2dp_bs_bypass== 1'h0 ;
        cfg_bn_en     <= reg2dp_bn_bypass== 1'h0 ;
        cfg_ew_en     <= reg2dp_ew_bypass== 1'h0 ;
        cfg_mode_eql  <= reg2dp_ew_alu_algo== 2'h3  && reg2dp_ew_alu_bypass== 1'h0  && reg2dp_ew_bypass== 1'h0 ;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
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
    cfg_cvt_offset <= {32{1'b0}};
    cfg_cvt_scale <= {16{1'b0}};
    cfg_cvt_shift <= {6{1'b0}};
    cfg_proc_precision <= {2{1'b0}};
    cfg_out_precision <= {2{1'b0}};
    cfg_nan_to_zero <= 1'b0;
  end else begin
    if (op_en_load) begin
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
        cfg_cvt_offset          <= reg2dp_cvt_offset          ;
        cfg_cvt_scale           <= reg2dp_cvt_scale           ;
        cfg_cvt_shift           <= reg2dp_cvt_shift           ;
        cfg_proc_precision      <= reg2dp_proc_precision      ;
        cfg_out_precision       <= reg2dp_out_precision       ;
        cfg_nan_to_zero         <= reg2dp_nan_to_zero         ;
    end
  end
end


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

//===========================================
// CORE
//===========================================
// MUX to bypass CORE_x0
assign bs_data_in_pvld = cfg_bs_en & sdp_cmux2dp_valid;
assign bs_data_in_pd   = sdp_cmux2dp_data;
assign sdp_cmux2dp_ready     = cfg_bs_en ? bs_data_in_prdy : bs_data_out_prdy;

//===========================================
// x0 input pipe
//===========================================
NV_NVDLA_SDP_CORE_pipe_p7 pipe_p7 (
   .nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.bs_data_in_pd                     (bs_data_in_pd[511:0])                  //|< w
  ,.bs_data_in_pvld                   (bs_data_in_pvld)                       //|< w
  ,.flop_bs_data_in_prdy              (flop_bs_data_in_prdy)                  //|< w
  ,.bs_data_in_prdy                   (bs_data_in_prdy)                       //|> w
  ,.flop_bs_data_in_pd                (flop_bs_data_in_pd[511:0])             //|> w
  ,.flop_bs_data_in_pvld              (flop_bs_data_in_pvld)                  //|> w
  );

//===========================================
// SLCG Gate
//===========================================

assign bcore_slcg_en = cfg_bs_en & reg2dp_bcore_slcg_op_en;

assign ncore_slcg_en = cfg_bn_en & reg2dp_ncore_slcg_op_en;

assign ecore_slcg_en = (cfg_ew_en & reg2dp_ecore_slcg_op_en) | reg2dp_lut_slcg_en;
NV_NVDLA_SDP_CORE_gate u_gate (
   .bcore_slcg_en                     (bcore_slcg_en)                         //|< w
  ,.dla_clk_ovr_on_sync               (dla_clk_ovr_on_sync)                   //|< i
  ,.ecore_slcg_en                     (ecore_slcg_en)                         //|< w
  ,.global_clk_ovr_on_sync            (global_clk_ovr_on_sync)                //|< i
  ,.ncore_slcg_en                     (ncore_slcg_en)                         //|< w
  ,.nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.tmc2slcg_disable_clock_gating     (tmc2slcg_disable_clock_gating)         //|< i
  ,.nvdla_gated_bcore_clk             (nvdla_gated_bcore_clk)                 //|> w
  ,.nvdla_gated_ecore_clk             (nvdla_gated_ecore_clk)                 //|> w
  ,.nvdla_gated_ncore_clk             (nvdla_gated_ncore_clk)                 //|> w
  );

// CORE: x0
//===========================================
NV_NVDLA_SDP_CORE_x u_bs (
   .nvdla_core_clk                    (nvdla_gated_bcore_clk)                 //|< w
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.chn_data_in_rsc_z                 (flop_bs_data_in_pd[511:0])             //|< w
  ,.chn_data_in_rsc_vz                (flop_bs_data_in_pvld)                  //|< w
  ,.chn_data_in_rsc_lz                (flop_bs_data_in_prdy)                  //|> w
  ,.chn_alu_op_rsc_z                  (bs_alu_in_data[255:0])                 //|< w
  ,.chn_alu_op_rsc_vz                 (bs_alu_in_vld)                         //|< w
  ,.chn_alu_op_rsc_lz                 (bs_alu_in_rdy)                         //|> w
  ,.chn_mul_op_rsc_z                  (bs_mul_in_data[255:0])                 //|< w
  ,.chn_mul_op_rsc_vz                 (bs_mul_in_vld)                         //|< w
  ,.chn_mul_op_rsc_lz                 (bs_mul_in_rdy)                         //|> w
  ,.cfg_mul_op_rsc_z                  (cfg_bs_mul_operand[15:0])              //|< r
  ,.cfg_mul_op_rsc_triosy_lz          ()                                      //|> ?
  ,.cfg_alu_op_rsc_z                  (cfg_bs_alu_operand[15:0])              //|< r
  ,.cfg_alu_op_rsc_triosy_lz          ()                                      //|> ?
  ,.cfg_alu_bypass_rsc_z              (cfg_bs_alu_bypass)                     //|< r
  ,.cfg_alu_bypass_rsc_triosy_lz      ()                                      //|> ?
  ,.cfg_alu_algo_rsc_z                (cfg_bs_alu_algo[1:0])                  //|< r
  ,.cfg_alu_algo_rsc_triosy_lz        ()                                      //|> ?
  ,.cfg_alu_src_rsc_z                 (cfg_bs_alu_src)                        //|< r
  ,.cfg_alu_src_rsc_triosy_lz         ()                                      //|> ?
  ,.cfg_alu_shift_value_rsc_z         (cfg_bs_alu_shift_value[5:0])           //|< r
  ,.cfg_alu_shift_value_rsc_triosy_lz ()                                      //|> ?
  ,.cfg_mul_bypass_rsc_z              (cfg_bs_mul_bypass)                     //|< r
  ,.cfg_mul_bypass_rsc_triosy_lz      ()                                      //|> ?
  ,.cfg_mul_prelu_rsc_z               (cfg_bs_mul_prelu)                      //|< r
  ,.cfg_mul_prelu_rsc_triosy_lz       ()                                      //|> ?
  ,.cfg_mul_src_rsc_z                 (cfg_bs_mul_src)                        //|< r
  ,.cfg_mul_src_rsc_triosy_lz         ()                                      //|> ?
  ,.cfg_mul_shift_value_rsc_z         (cfg_bs_mul_shift_value[5:0])           //|< r
  ,.cfg_mul_shift_value_rsc_triosy_lz ()                                      //|> ?
  ,.cfg_relu_bypass_rsc_z             (cfg_bs_relu_bypass)                    //|< r
  ,.cfg_relu_bypass_rsc_triosy_lz     ()                                      //|> ?
  ,.cfg_nan_to_zero                   (cfg_nan_to_zero)                       //|< r
  ,.cfg_precision                     (cfg_proc_precision[1:0])               //|< r
  ,.chn_data_out_rsc_z                (bs_data_out_pd[511:0])                 //|> w
  ,.chn_data_out_rsc_vz               (bs_data_out_prdy)                      //|< w
  ,.chn_data_out_rsc_lz               (bs_data_out_pvld)                      //|> w
  );

 


//===========================================
// MUX between BS and BN
//===========================================
assign bs2bn_data_pvld  = cfg_bs_en ? bs_data_out_pvld : sdp_cmux2dp_valid;
assign bn_data_in_pvld  = cfg_bn_en & bs2bn_data_pvld;
assign bn_data_in_pd    = cfg_bs_en ? bs_data_out_pd   : bs_data_in_pd;

assign bs_data_out_prdy = cfg_bn_en ? bn_data_in_prdy : bn_data_out_prdy;

//===========================================
// x0 input pipe
//===========================================
NV_NVDLA_SDP_CORE_pipe_p8 pipe_p8 (
   .nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.bn_data_in_pd                     (bn_data_in_pd[511:0])                  //|< w
  ,.bn_data_in_pvld                   (bn_data_in_pvld)                       //|< w
  ,.flop_bn_data_in_prdy              (flop_bn_data_in_prdy)                  //|< w
  ,.bn_data_in_prdy                   (bn_data_in_prdy)                       //|> w
  ,.flop_bn_data_in_pd                (flop_bn_data_in_pd[511:0])             //|> w
  ,.flop_bn_data_in_pvld              (flop_bn_data_in_pvld)                  //|> w
  );

//===========================================
// CORE: x1
//===========================================
NV_NVDLA_SDP_CORE_x u_bn (
   .nvdla_core_clk                    (nvdla_gated_ncore_clk)                 //|< w
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.chn_data_in_rsc_z                 (flop_bn_data_in_pd[511:0])             //|< w
  ,.chn_data_in_rsc_vz                (flop_bn_data_in_pvld)                  //|< w
  ,.chn_data_in_rsc_lz                (flop_bn_data_in_prdy)                  //|> w
  ,.chn_alu_op_rsc_z                  (bn_alu_in_data[255:0])                 //|< w
  ,.chn_alu_op_rsc_vz                 (bn_alu_in_vld)                         //|< w
  ,.chn_alu_op_rsc_lz                 (bn_alu_in_rdy)                         //|> w
  ,.chn_mul_op_rsc_z                  (bn_mul_in_data[255:0])                 //|< w
  ,.chn_mul_op_rsc_vz                 (bn_mul_in_vld)                         //|< w
  ,.chn_mul_op_rsc_lz                 (bn_mul_in_rdy)                         //|> w
  ,.cfg_mul_op_rsc_z                  (cfg_bn_mul_operand[15:0])              //|< r
  ,.cfg_mul_op_rsc_triosy_lz          ()                                      //|> ?
  ,.cfg_alu_op_rsc_z                  (cfg_bn_alu_operand[15:0])              //|< r
  ,.cfg_alu_op_rsc_triosy_lz          ()                                      //|> ?
  ,.cfg_alu_bypass_rsc_z              (cfg_bn_alu_bypass)                     //|< r
  ,.cfg_alu_bypass_rsc_triosy_lz      ()                                      //|> ?
  ,.cfg_alu_algo_rsc_z                (cfg_bn_alu_algo[1:0])                  //|< r
  ,.cfg_alu_algo_rsc_triosy_lz        ()                                      //|> ?
  ,.cfg_alu_src_rsc_z                 (cfg_bn_alu_src)                        //|< r
  ,.cfg_alu_src_rsc_triosy_lz         ()                                      //|> ?
  ,.cfg_alu_shift_value_rsc_z         (cfg_bn_alu_shift_value[5:0])           //|< r
  ,.cfg_alu_shift_value_rsc_triosy_lz ()                                      //|> ?
  ,.cfg_mul_bypass_rsc_z              (cfg_bn_mul_bypass)                     //|< r
  ,.cfg_mul_bypass_rsc_triosy_lz      ()                                      //|> ?
  ,.cfg_mul_prelu_rsc_z               (cfg_bn_mul_prelu)                      //|< r
  ,.cfg_mul_prelu_rsc_triosy_lz       ()                                      //|> ?
  ,.cfg_mul_src_rsc_z                 (cfg_bn_mul_src)                        //|< r
  ,.cfg_mul_src_rsc_triosy_lz         ()                                      //|> ?
  ,.cfg_mul_shift_value_rsc_z         (cfg_bn_mul_shift_value[5:0])           //|< r
  ,.cfg_mul_shift_value_rsc_triosy_lz ()                                      //|> ?
  ,.cfg_relu_bypass_rsc_z             (cfg_bn_relu_bypass)                    //|< r
  ,.cfg_relu_bypass_rsc_triosy_lz     ()                                      //|> ?
  ,.cfg_nan_to_zero                   (cfg_nan_to_zero)                       //|< r
  ,.cfg_precision                     (cfg_proc_precision[1:0])               //|< r
  ,.chn_data_out_rsc_z                (bn_data_out_pd[511:0])                 //|> w
  ,.chn_data_out_rsc_vz               (bn_data_out_prdy)                      //|< w
  ,.chn_data_out_rsc_lz               (bn_data_out_pvld)                      //|> w
  );

 


//===========================================
// MUX between BN and EW
//===========================================
assign bn2ew_data_pvld  = cfg_bn_en ? bn_data_out_pvld : bs2bn_data_pvld;
assign ew_data_in_pvld  = cfg_ew_en & bn2ew_data_pvld;
assign ew_data_in_pd    = cfg_bn_en ? bn_data_out_pd   : bn_data_in_pd;

assign bn_data_out_prdy = cfg_ew_en ? ew_data_in_prdy : ew_data_out_prdy;
//===========================================
// CORE: y
//===========================================
NV_NVDLA_SDP_CORE_y u_ew (
   .nvdla_core_clk                    (nvdla_gated_ecore_clk)                 //|< w
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.ew_alu_in_data                    (ew_alu_in_data[255:0])                 //|< w
  ,.ew_alu_in_vld                     (ew_alu_in_vld)                         //|< w
  ,.ew_data_in_pd                     (ew_data_in_pd[511:0])                  //|< w
  ,.ew_data_in_pvld                   (ew_data_in_pvld)                       //|< w
  ,.ew_data_out_prdy                  (ew_data_out_prdy)                      //|< w
  ,.ew_mul_in_data                    (ew_mul_in_data[255:0])                 //|< w
  ,.ew_mul_in_vld                     (ew_mul_in_vld)                         //|< w
  ,.ew_alu_in_rdy                     (ew_alu_in_rdy)                         //|> w
  ,.ew_data_in_prdy                   (ew_data_in_prdy)                       //|> w
  ,.ew_data_out_pd                    (ew_data_out_pd[511:0])                 //|> w
  ,.ew_data_out_pvld                  (ew_data_out_pvld)                      //|> w
  ,.ew_mul_in_rdy                     (ew_mul_in_rdy)                         //|> w
  ,.reg2dp_ew_alu_algo                (reg2dp_ew_alu_algo[1:0])               //|< i
  ,.reg2dp_ew_alu_bypass              (reg2dp_ew_alu_bypass)                  //|< i
  ,.reg2dp_ew_alu_cvt_bypass          (reg2dp_ew_alu_cvt_bypass)              //|< i
  ,.reg2dp_ew_alu_cvt_offset          (reg2dp_ew_alu_cvt_offset[31:0])        //|< i
  ,.reg2dp_ew_alu_cvt_scale           (reg2dp_ew_alu_cvt_scale[15:0])         //|< i
  ,.reg2dp_ew_alu_cvt_truncate        (reg2dp_ew_alu_cvt_truncate[5:0])       //|< i
  ,.reg2dp_ew_alu_operand             (reg2dp_ew_alu_operand[31:0])           //|< i
  ,.reg2dp_ew_alu_src                 (reg2dp_ew_alu_src)                     //|< i
  ,.reg2dp_ew_lut_bypass              (reg2dp_ew_lut_bypass)                  //|< i
  ,.reg2dp_ew_mul_bypass              (reg2dp_ew_mul_bypass)                  //|< i
  ,.reg2dp_ew_mul_cvt_bypass          (reg2dp_ew_mul_cvt_bypass)              //|< i
  ,.reg2dp_ew_mul_cvt_offset          (reg2dp_ew_mul_cvt_offset[31:0])        //|< i
  ,.reg2dp_ew_mul_cvt_scale           (reg2dp_ew_mul_cvt_scale[15:0])         //|< i
  ,.reg2dp_ew_mul_cvt_truncate        (reg2dp_ew_mul_cvt_truncate[5:0])       //|< i
  ,.reg2dp_ew_mul_operand             (reg2dp_ew_mul_operand[31:0])           //|< i
  ,.reg2dp_ew_mul_prelu               (reg2dp_ew_mul_prelu)                   //|< i
  ,.reg2dp_ew_mul_src                 (reg2dp_ew_mul_src)                     //|< i
  ,.reg2dp_ew_truncate                (reg2dp_ew_truncate[9:0])               //|< i
  ,.reg2dp_lut_hybrid_priority        (reg2dp_lut_hybrid_priority)            //|< i
  ,.reg2dp_lut_int_access_type        (reg2dp_lut_int_access_type)            //|< i
  ,.reg2dp_lut_int_addr               (reg2dp_lut_int_addr[9:0])              //|< i
  ,.reg2dp_lut_int_data               (reg2dp_lut_int_data[15:0])             //|< i
  ,.reg2dp_lut_int_data_wr            (reg2dp_lut_int_data_wr)                //|< i
  ,.reg2dp_lut_int_table_id           (reg2dp_lut_int_table_id)               //|< i
  ,.reg2dp_lut_le_end                 (reg2dp_lut_le_end[31:0])               //|< i
  ,.reg2dp_lut_le_function            (reg2dp_lut_le_function)                //|< i
  ,.reg2dp_lut_le_index_offset        (reg2dp_lut_le_index_offset[7:0])       //|< i
  ,.reg2dp_lut_le_index_select        (reg2dp_lut_le_index_select[7:0])       //|< i
  ,.reg2dp_lut_le_slope_oflow_scale   (reg2dp_lut_le_slope_oflow_scale[15:0]) //|< i
  ,.reg2dp_lut_le_slope_oflow_shift   (reg2dp_lut_le_slope_oflow_shift[4:0])  //|< i
  ,.reg2dp_lut_le_slope_uflow_scale   (reg2dp_lut_le_slope_uflow_scale[15:0]) //|< i
  ,.reg2dp_lut_le_slope_uflow_shift   (reg2dp_lut_le_slope_uflow_shift[4:0])  //|< i
  ,.reg2dp_lut_le_start               (reg2dp_lut_le_start[31:0])             //|< i
  ,.reg2dp_lut_lo_end                 (reg2dp_lut_lo_end[31:0])               //|< i
  ,.reg2dp_lut_lo_index_select        (reg2dp_lut_lo_index_select[7:0])       //|< i
  ,.reg2dp_lut_lo_slope_oflow_scale   (reg2dp_lut_lo_slope_oflow_scale[15:0]) //|< i
  ,.reg2dp_lut_lo_slope_oflow_shift   (reg2dp_lut_lo_slope_oflow_shift[4:0])  //|< i
  ,.reg2dp_lut_lo_slope_uflow_scale   (reg2dp_lut_lo_slope_uflow_scale[15:0]) //|< i
  ,.reg2dp_lut_lo_slope_uflow_shift   (reg2dp_lut_lo_slope_uflow_shift[4:0])  //|< i
  ,.reg2dp_lut_lo_start               (reg2dp_lut_lo_start[31:0])             //|< i
  ,.reg2dp_lut_oflow_priority         (reg2dp_lut_oflow_priority)             //|< i
  ,.reg2dp_lut_uflow_priority         (reg2dp_lut_uflow_priority)             //|< i
  ,.reg2dp_nan_to_zero                (reg2dp_nan_to_zero)                    //|< i
  ,.reg2dp_perf_lut_en                (reg2dp_perf_lut_en)                    //|< i
  ,.reg2dp_proc_precision             (reg2dp_proc_precision[1:0])            //|< i
  ,.dp2reg_lut_hybrid                 (dp2reg_lut_hybrid[31:0])               //|> o
  ,.dp2reg_lut_int_data               (dp2reg_lut_int_data[15:0])             //|> o
  ,.dp2reg_lut_le_hit                 (dp2reg_lut_le_hit[31:0])               //|> o
  ,.dp2reg_lut_lo_hit                 (dp2reg_lut_lo_hit[31:0])               //|> o
  ,.dp2reg_lut_oflow                  (dp2reg_lut_oflow[31:0])                //|> o
  ,.dp2reg_lut_uflow                  (dp2reg_lut_uflow[31:0])                //|> o
  ,.pwrbus_ram_pd                     (pwrbus_ram_pd[31:0])                   //|< i
  ,.op_en_load                        (op_en_load)                            //|< w
  );

//===========================================
// MUX between EW and CVT
//===========================================
assign ew2cvt_data_pvld  = cfg_ew_en ? ew_data_out_pvld : bn2ew_data_pvld;
assign cvt_data_in_pvld  = ew2cvt_data_pvld;
assign cvt_data_in_pd    = cfg_ew_en ? ew_data_out_pd   : ew_data_in_pd;

assign ew_data_out_prdy = cvt_data_in_prdy;

//===========================================
// c input pipe
//===========================================
NV_NVDLA_SDP_CORE_pipe_p9 pipe_p9 (
   .nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.cvt_data_in_pd                    (cvt_data_in_pd[511:0])                 //|< w
  ,.cvt_data_in_pvld                  (cvt_data_in_pvld)                      //|< w
  ,.flop_cvt_data_in_prdy             (flop_cvt_data_in_prdy)                 //|< w
  ,.cvt_data_in_prdy                  (cvt_data_in_prdy)                      //|> w
  ,.flop_cvt_data_in_pd               (flop_cvt_data_in_pd[511:0])            //|> w
  ,.flop_cvt_data_in_pvld             (flop_cvt_data_in_pvld)                 //|> w
  );

//===========================================
// CORE: c
//===========================================
NV_NVDLA_SDP_CORE_c u_c (
   .nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.chn_in_rsc_z                      (flop_cvt_data_in_pd[511:0])            //|< w
  ,.chn_in_rsc_vz                     (flop_cvt_data_in_pvld)                 //|< w
  ,.chn_in_rsc_lz                     (flop_cvt_data_in_prdy)                 //|> w
  ,.cfg_offset_rsc_z                  (cfg_cvt_offset[31:0])                  //|< r
  ,.cfg_scale_rsc_z                   (cfg_cvt_scale[15:0])                   //|< r
  ,.cfg_truncate_rsc_z                (cfg_cvt_shift[5:0])                    //|< r
  ,.cfg_proc_precision_rsc_z          (cfg_proc_precision[1:0])               //|< r
  ,.cfg_out_precision_rsc_z           (cfg_out_precision[1:0])                //|< r
  ,.cfg_mode_eql_rsc_z                (cfg_mode_eql)                          //|< r
  ,.chn_out_rsc_z                     (cvt_data_out_pd[271:0])                //|> w
  ,.chn_out_rsc_vz                    (cvt_data_out_prdy)                     //|< w
  ,.chn_out_rsc_lz                    (cvt_data_out_pvld)                     //|> w
  );

assign cvt_data_out_data = cvt_data_out_pd[255:0];
assign cvt_data_out_sat  = cvt_data_out_pd[271:256];

// to (PDP | WDMA)
assign cfg_mode_pdp = reg2dp_output_dst== 1'h1 ;
assign cvt_data_out_prdy = core2wdma_rdy & ((!cfg_mode_pdp) || core2pdp_rdy);
//assign core2wdma_vld  = cfg_mode_pdp ? 1'b0 : cvt_data_out_pvld;
assign core2wdma_vld  = cvt_data_out_pvld & ( (!cfg_mode_pdp) || core2pdp_rdy);
assign core2pdp_vld   = cfg_mode_pdp & cvt_data_out_pvld & core2wdma_rdy;

assign core2wdma_pd = cfg_mode_pdp ? 256'h0 : cvt_data_out_data;
assign core2pdp_pd  = cfg_mode_pdp ? cvt_data_out_data : 256'h0;

NV_NVDLA_SDP_CORE_pipe_p10 pipe_p10 (
   .nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.core2wdma_pd                      (core2wdma_pd[255:0])                   //|< w
  ,.core2wdma_vld                     (core2wdma_vld)                         //|< w
  ,.sdp_dp2wdma_ready                 (sdp_dp2wdma_ready)                     //|< i
  ,.core2wdma_rdy                     (core2wdma_rdy)                         //|> w
  ,.sdp_dp2wdma_pd                    (sdp_dp2wdma_pd[255:0])                 //|> o
  ,.sdp_dp2wdma_valid                 (sdp_dp2wdma_valid)                     //|> o
  );

NV_NVDLA_SDP_CORE_pipe_p11 pipe_p11 (
   .nvdla_core_clk                    (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                   (nvdla_core_rstn)                       //|< i
  ,.core2pdp_pd                       (core2pdp_pd[255:0])                    //|< w
  ,.core2pdp_vld                      (core2pdp_vld)                          //|< w
  ,.sdp2pdp_ready                     (sdp2pdp_ready)                         //|< i
  ,.core2pdp_rdy                      (core2pdp_rdy)                          //|> w
  ,.sdp2pdp_pd                        (sdp2pdp_pd[255:0])                     //|> o
  ,.sdp2pdp_valid                     (sdp2pdp_valid)                         //|> o
  );

//===========================================
// OBS
//assign obs_bus_sdp_core_bs_in_rdy  = flop_bs_data_in_prdy;  
//assign obs_bus_sdp_core_bs_in_vld  = flop_bs_data_in_pvld; 
//assign obs_bus_sdp_core_bs_alu_rdy = bs_alu_in_rdy; 
//assign obs_bus_sdp_core_bs_alu_vld = bs_alu_in_vld; 
//assign obs_bus_sdp_core_bs_mul_rdy = bs_alu_in_rdy; 
//assign obs_bus_sdp_core_bs_mul_vld = bs_alu_in_vld; 
//assign obs_bus_sdp_core_bs_out_rdy = bs_data_out_prdy; 
//assign obs_bus_sdp_core_bs_out_vld = bs_data_out_pvld; 
//assign obs_bus_sdp_core_bn_in_rdy  = flop_bn_data_in_prdy;  
//assign obs_bus_sdp_core_bn_in_vld  = flop_bn_data_in_pvld; 
//assign obs_bus_sdp_core_bn_alu_rdy = bn_alu_in_rdy; 
//assign obs_bus_sdp_core_bn_alu_vld = bn_alu_in_vld; 
//assign obs_bus_sdp_core_bn_mul_rdy = bn_alu_in_rdy; 
//assign obs_bus_sdp_core_bn_mul_vld = bn_alu_in_vld; 
//assign obs_bus_sdp_core_bn_out_rdy = bn_data_out_prdy; 
//assign obs_bus_sdp_core_bn_out_vld = bn_data_out_pvld; 
//assign obs_bus_sdp_core_ew_in_rdy  = ew_data_in_prdy;  
//assign obs_bus_sdp_core_ew_in_vld  = ew_data_in_pvld; 
//assign obs_bus_sdp_core_ew_alu_rdy = ew_alu_in_rdy; 
//assign obs_bus_sdp_core_ew_alu_vld = ew_alu_in_vld; 
//assign obs_bus_sdp_core_ew_mul_rdy = ew_alu_in_rdy; 
//assign obs_bus_sdp_core_ew_mul_vld = ew_alu_in_vld; 
//assign obs_bus_sdp_core_ew_out_rdy = ew_data_out_prdy; 
//assign obs_bus_sdp_core_ew_out_vld = ew_data_out_pvld; 

//===========================================
// PERF STATISTIC: SATURATION 
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    saturation_bits <= {16{1'b0}};
  end else begin
    if (cvt_data_out_pvld & cvt_data_out_prdy) begin
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
        end else begin
            saturation_bits <= cvt_data_out_sat;
        end
    end else begin
        saturation_bits <= 0;
    end
  end
end

assign cvt_saturation_add = fun_my_bit_sum(saturation_bits);
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


        // cvt_sat_cvt_sat adv logic

        always @(
          i_add
          or i_sub
          ) begin
          cvt_sat_cvt_sat_adv = i_add[4:0] != {{4{1'b0}}, i_sub[0:0]};
        end
            
        // cvt_sat_cvt_sat cnt logic
        always @(
          cvt_sat_cvt_sat_cnt_cur
          or i_add
          or i_sub
          or cvt_sat_cvt_sat_adv
          or cvt_saturation_clr
          ) begin
          // VCS sop_coverage_off start
          cvt_sat_cvt_sat_cnt_ext[33:0] = {1'b0, 1'b0, cvt_sat_cvt_sat_cnt_cur};
          cvt_sat_cvt_sat_cnt_mod[33:0] = cvt_sat_cvt_sat_cnt_cur + i_add[4:0] - i_sub[0:0]; // spyglass disable W164b
          cvt_sat_cvt_sat_cnt_new[33:0] = (cvt_sat_cvt_sat_adv)? cvt_sat_cvt_sat_cnt_mod[33:0] : cvt_sat_cvt_sat_cnt_ext[33:0];
          cvt_sat_cvt_sat_cnt_nxt[33:0] = (cvt_saturation_clr)? 34'd0 : cvt_sat_cvt_sat_cnt_new[33:0];
          // VCS sop_coverage_off end
        end

        // cvt_sat_cvt_sat flops

        always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
          if (!nvdla_core_rstn) begin
            cvt_sat_cvt_sat_cnt_cur[31:0] <= 0;
          end else begin
          if (cvt_saturation_cen) begin
          cvt_sat_cvt_sat_cnt_cur[31:0] <= cvt_sat_cvt_sat_cnt_nxt[31:0];
          end
          end
        end

        // cvt_sat_cvt_sat output logic

        always @(
          cvt_sat_cvt_sat_cnt_cur
          ) begin
          cvt_saturation_cnt[31:0] = cvt_sat_cvt_sat_cnt_cur[31:0];
        end
            
          

assign dp2reg_out_saturation = cvt_saturation_cnt;
//===========================================
// FUNCTION 
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


//===========================================
// FUNCTION COVERAGE

//===========================================
// ASSERTION

endmodule // NV_NVDLA_SDP_core



// **************************************************************************************************************
// Generated by ::pipe -m -bc bs_mul_in_pd (bs_mul_in_pvld,bs_mul_in_prdy) <= sdp_brdma2dp_mul_pd[256:0] (sdp_brdma2dp_mul_valid,sdp_brdma2dp_mul_ready)
// **************************************************************************************************************
module NV_NVDLA_SDP_CORE_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,bs_mul_in_prdy
  ,sdp_brdma2dp_mul_pd
  ,sdp_brdma2dp_mul_valid
  ,bs_mul_in_pd
  ,bs_mul_in_pvld
  ,sdp_brdma2dp_mul_ready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          bs_mul_in_prdy;
input  [256:0] sdp_brdma2dp_mul_pd;
input          sdp_brdma2dp_mul_valid;
output [256:0] bs_mul_in_pd;
output         bs_mul_in_pvld;
output         sdp_brdma2dp_mul_ready;
reg    [256:0] bs_mul_in_pd;
reg            bs_mul_in_pvld;
reg    [256:0] p1_pipe_data;
reg    [256:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg            p1_pipe_valid;
reg            sdp_brdma2dp_mul_ready;
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     sdp_brdma2dp_mul_valid
  or p1_pipe_rand_ready
  or sdp_brdma2dp_mul_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = sdp_brdma2dp_mul_valid;
  sdp_brdma2dp_mul_ready = p1_pipe_rand_ready;
  p1_pipe_rand_data = sdp_brdma2dp_mul_pd[256:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : sdp_brdma2dp_mul_valid;
  sdp_brdma2dp_mul_ready = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : sdp_brdma2dp_mul_pd[256:0];
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
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or sdp_brdma2dp_mul_valid
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && sdp_brdma2dp_mul_valid === 1'b1;
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_pipe_rand_valid)? p1_pipe_rand_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_pipe_rand_ready = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or bs_mul_in_prdy
  or p1_pipe_data
  ) begin
  bs_mul_in_pvld = p1_pipe_valid;
  p1_pipe_ready = bs_mul_in_prdy;
  bs_mul_in_pd = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (bs_mul_in_pvld^bs_mul_in_prdy^sdp_brdma2dp_mul_valid^sdp_brdma2dp_mul_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (sdp_brdma2dp_mul_valid && !sdp_brdma2dp_mul_ready), (sdp_brdma2dp_mul_valid), (sdp_brdma2dp_mul_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_CORE_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc bs_alu_in_pd (bs_alu_in_pvld,bs_alu_in_prdy) <= sdp_brdma2dp_alu_pd[256:0] (sdp_brdma2dp_alu_valid,sdp_brdma2dp_alu_ready)
// **************************************************************************************************************
module NV_NVDLA_SDP_CORE_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,bs_alu_in_prdy
  ,sdp_brdma2dp_alu_pd
  ,sdp_brdma2dp_alu_valid
  ,bs_alu_in_pd
  ,bs_alu_in_pvld
  ,sdp_brdma2dp_alu_ready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          bs_alu_in_prdy;
input  [256:0] sdp_brdma2dp_alu_pd;
input          sdp_brdma2dp_alu_valid;
output [256:0] bs_alu_in_pd;
output         bs_alu_in_pvld;
output         sdp_brdma2dp_alu_ready;
reg    [256:0] bs_alu_in_pd;
reg            bs_alu_in_pvld;
reg    [256:0] p2_pipe_data;
reg    [256:0] p2_pipe_rand_data;
reg            p2_pipe_rand_ready;
reg            p2_pipe_rand_valid;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
reg            sdp_brdma2dp_alu_ready;
//## pipe (2) randomizer
`ifndef SYNTHESIS
reg p2_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p2_pipe_rand_active
  or 
     `endif
     sdp_brdma2dp_alu_valid
  or p2_pipe_rand_ready
  or sdp_brdma2dp_alu_pd
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = sdp_brdma2dp_alu_valid;
  sdp_brdma2dp_alu_ready = p2_pipe_rand_ready;
  p2_pipe_rand_data = sdp_brdma2dp_alu_pd[256:0];
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : sdp_brdma2dp_alu_valid;
  sdp_brdma2dp_alu_ready = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : sdp_brdma2dp_alu_pd[256:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p2_pipe_stall_cycles;
integer p2_pipe_stall_probability;
integer p2_pipe_stall_cycles_min;
integer p2_pipe_stall_cycles_max;
initial begin
  p2_pipe_stall_cycles = 0;
  p2_pipe_stall_probability = 0;
  p2_pipe_stall_cycles_min = 1;
  p2_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or sdp_brdma2dp_alu_valid
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && sdp_brdma2dp_alu_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p2_pipe_rand_poised) begin
    if (p2_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p2_pipe_stall_cycles <= prand_inst1(p2_pipe_stall_cycles_min, p2_pipe_stall_cycles_max);
    end
  end else if (p2_pipe_rand_active) begin
    p2_pipe_stall_cycles <= p2_pipe_stall_cycles - 1;
  end else begin
    p2_pipe_stall_cycles <= 0;
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
//## pipe (2) valid-ready-bubble-collapse
always @(
  p2_pipe_ready
  or p2_pipe_valid
  ) begin
  p2_pipe_ready_bc = p2_pipe_ready || !p2_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? p2_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && p2_pipe_rand_valid)? p2_pipe_rand_data : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  p2_pipe_rand_ready = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or bs_alu_in_prdy
  or p2_pipe_data
  ) begin
  bs_alu_in_pvld = p2_pipe_valid;
  p2_pipe_ready = bs_alu_in_prdy;
  bs_alu_in_pd = p2_pipe_data;
end
//## pipe (2) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p2_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (bs_alu_in_pvld^bs_alu_in_prdy^sdp_brdma2dp_alu_valid^sdp_brdma2dp_alu_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (sdp_brdma2dp_alu_valid && !sdp_brdma2dp_alu_ready), (sdp_brdma2dp_alu_valid), (sdp_brdma2dp_alu_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_CORE_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc bn_mul_in_pd (bn_mul_in_pvld,bn_mul_in_prdy) <= sdp_nrdma2dp_mul_pd[256:0] (sdp_nrdma2dp_mul_valid,sdp_nrdma2dp_mul_ready)
// **************************************************************************************************************
module NV_NVDLA_SDP_CORE_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,bn_mul_in_prdy
  ,sdp_nrdma2dp_mul_pd
  ,sdp_nrdma2dp_mul_valid
  ,bn_mul_in_pd
  ,bn_mul_in_pvld
  ,sdp_nrdma2dp_mul_ready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          bn_mul_in_prdy;
input  [256:0] sdp_nrdma2dp_mul_pd;
input          sdp_nrdma2dp_mul_valid;
output [256:0] bn_mul_in_pd;
output         bn_mul_in_pvld;
output         sdp_nrdma2dp_mul_ready;
reg    [256:0] bn_mul_in_pd;
reg            bn_mul_in_pvld;
reg    [256:0] p3_pipe_data;
reg    [256:0] p3_pipe_rand_data;
reg            p3_pipe_rand_ready;
reg            p3_pipe_rand_valid;
reg            p3_pipe_ready;
reg            p3_pipe_ready_bc;
reg            p3_pipe_valid;
reg            sdp_nrdma2dp_mul_ready;
//## pipe (3) randomizer
`ifndef SYNTHESIS
reg p3_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p3_pipe_rand_active
  or 
     `endif
     sdp_nrdma2dp_mul_valid
  or p3_pipe_rand_ready
  or sdp_nrdma2dp_mul_pd
  ) begin
  `ifdef SYNTHESIS
  p3_pipe_rand_valid = sdp_nrdma2dp_mul_valid;
  sdp_nrdma2dp_mul_ready = p3_pipe_rand_ready;
  p3_pipe_rand_data = sdp_nrdma2dp_mul_pd[256:0];
  `else
  // VCS coverage off
  p3_pipe_rand_valid = (p3_pipe_rand_active)? 1'b0 : sdp_nrdma2dp_mul_valid;
  sdp_nrdma2dp_mul_ready = (p3_pipe_rand_active)? 1'b0 : p3_pipe_rand_ready;
  p3_pipe_rand_data = (p3_pipe_rand_active)?  'bx : sdp_nrdma2dp_mul_pd[256:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p3_pipe_stall_cycles;
integer p3_pipe_stall_probability;
integer p3_pipe_stall_cycles_min;
integer p3_pipe_stall_cycles_max;
initial begin
  p3_pipe_stall_cycles = 0;
  p3_pipe_stall_probability = 0;
  p3_pipe_stall_cycles_min = 1;
  p3_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability" ) ) p3_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min"  ) ) p3_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max"  ) ) p3_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p3_pipe_rand_enable;
reg p3_pipe_rand_poised;
always @(
  p3_pipe_stall_cycles
  or p3_pipe_stall_probability
  or sdp_nrdma2dp_mul_valid
  ) begin
  p3_pipe_rand_active = p3_pipe_stall_cycles != 0;
  p3_pipe_rand_enable = p3_pipe_stall_probability != 0;
  p3_pipe_rand_poised = p3_pipe_rand_enable && !p3_pipe_rand_active && sdp_nrdma2dp_mul_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p3_pipe_rand_poised) begin
    if (p3_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p3_pipe_stall_cycles <= prand_inst1(p3_pipe_stall_cycles_min, p3_pipe_stall_cycles_max);
    end
  end else if (p3_pipe_rand_active) begin
    p3_pipe_stall_cycles <= p3_pipe_stall_cycles - 1;
  end else begin
    p3_pipe_stall_cycles <= 0;
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
//## pipe (3) valid-ready-bubble-collapse
always @(
  p3_pipe_ready
  or p3_pipe_valid
  ) begin
  p3_pipe_ready_bc = p3_pipe_ready || !p3_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_valid <= 1'b0;
  end else begin
  p3_pipe_valid <= (p3_pipe_ready_bc)? p3_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && p3_pipe_rand_valid)? p3_pipe_rand_data : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  p3_pipe_rand_ready = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or bn_mul_in_prdy
  or p3_pipe_data
  ) begin
  bn_mul_in_pvld = p3_pipe_valid;
  p3_pipe_ready = bn_mul_in_prdy;
  bn_mul_in_pd = p3_pipe_data;
end
//## pipe (3) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p3_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (bn_mul_in_pvld^bn_mul_in_prdy^sdp_nrdma2dp_mul_valid^sdp_nrdma2dp_mul_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (sdp_nrdma2dp_mul_valid && !sdp_nrdma2dp_mul_ready), (sdp_nrdma2dp_mul_valid), (sdp_nrdma2dp_mul_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_CORE_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc bn_alu_in_pd (bn_alu_in_pvld,bn_alu_in_prdy) <= sdp_nrdma2dp_alu_pd[256:0] (sdp_nrdma2dp_alu_valid,sdp_nrdma2dp_alu_ready)
// **************************************************************************************************************
module NV_NVDLA_SDP_CORE_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,bn_alu_in_prdy
  ,sdp_nrdma2dp_alu_pd
  ,sdp_nrdma2dp_alu_valid
  ,bn_alu_in_pd
  ,bn_alu_in_pvld
  ,sdp_nrdma2dp_alu_ready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          bn_alu_in_prdy;
input  [256:0] sdp_nrdma2dp_alu_pd;
input          sdp_nrdma2dp_alu_valid;
output [256:0] bn_alu_in_pd;
output         bn_alu_in_pvld;
output         sdp_nrdma2dp_alu_ready;
reg    [256:0] bn_alu_in_pd;
reg            bn_alu_in_pvld;
reg    [256:0] p4_pipe_data;
reg    [256:0] p4_pipe_rand_data;
reg            p4_pipe_rand_ready;
reg            p4_pipe_rand_valid;
reg            p4_pipe_ready;
reg            p4_pipe_ready_bc;
reg            p4_pipe_valid;
reg            sdp_nrdma2dp_alu_ready;
//## pipe (4) randomizer
`ifndef SYNTHESIS
reg p4_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p4_pipe_rand_active
  or 
     `endif
     sdp_nrdma2dp_alu_valid
  or p4_pipe_rand_ready
  or sdp_nrdma2dp_alu_pd
  ) begin
  `ifdef SYNTHESIS
  p4_pipe_rand_valid = sdp_nrdma2dp_alu_valid;
  sdp_nrdma2dp_alu_ready = p4_pipe_rand_ready;
  p4_pipe_rand_data = sdp_nrdma2dp_alu_pd[256:0];
  `else
  // VCS coverage off
  p4_pipe_rand_valid = (p4_pipe_rand_active)? 1'b0 : sdp_nrdma2dp_alu_valid;
  sdp_nrdma2dp_alu_ready = (p4_pipe_rand_active)? 1'b0 : p4_pipe_rand_ready;
  p4_pipe_rand_data = (p4_pipe_rand_active)?  'bx : sdp_nrdma2dp_alu_pd[256:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p4_pipe_stall_cycles;
integer p4_pipe_stall_probability;
integer p4_pipe_stall_cycles_min;
integer p4_pipe_stall_cycles_max;
initial begin
  p4_pipe_stall_cycles = 0;
  p4_pipe_stall_probability = 0;
  p4_pipe_stall_cycles_min = 1;
  p4_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability" ) ) p4_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min"  ) ) p4_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max"  ) ) p4_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p4_pipe_rand_enable;
reg p4_pipe_rand_poised;
always @(
  p4_pipe_stall_cycles
  or p4_pipe_stall_probability
  or sdp_nrdma2dp_alu_valid
  ) begin
  p4_pipe_rand_active = p4_pipe_stall_cycles != 0;
  p4_pipe_rand_enable = p4_pipe_stall_probability != 0;
  p4_pipe_rand_poised = p4_pipe_rand_enable && !p4_pipe_rand_active && sdp_nrdma2dp_alu_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p4_pipe_rand_poised) begin
    if (p4_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p4_pipe_stall_cycles <= prand_inst1(p4_pipe_stall_cycles_min, p4_pipe_stall_cycles_max);
    end
  end else if (p4_pipe_rand_active) begin
    p4_pipe_stall_cycles <= p4_pipe_stall_cycles - 1;
  end else begin
    p4_pipe_stall_cycles <= 0;
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
//## pipe (4) valid-ready-bubble-collapse
always @(
  p4_pipe_ready
  or p4_pipe_valid
  ) begin
  p4_pipe_ready_bc = p4_pipe_ready || !p4_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_valid <= 1'b0;
  end else begin
  p4_pipe_valid <= (p4_pipe_ready_bc)? p4_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && p4_pipe_rand_valid)? p4_pipe_rand_data : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  p4_pipe_rand_ready = p4_pipe_ready_bc;
end
//## pipe (4) output
always @(
  p4_pipe_valid
  or bn_alu_in_prdy
  or p4_pipe_data
  ) begin
  bn_alu_in_pvld = p4_pipe_valid;
  p4_pipe_ready = bn_alu_in_prdy;
  bn_alu_in_pd = p4_pipe_data;
end
//## pipe (4) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p4_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (bn_alu_in_pvld^bn_alu_in_prdy^sdp_nrdma2dp_alu_valid^sdp_nrdma2dp_alu_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_8x (nvdla_core_clk, `ASSERT_RESET, (sdp_nrdma2dp_alu_valid && !sdp_nrdma2dp_alu_ready), (sdp_nrdma2dp_alu_valid), (sdp_nrdma2dp_alu_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_CORE_pipe_p4




// **************************************************************************************************************
// Generated by ::pipe -m -bc ew_mul_in_pd (ew_mul_in_pvld,ew_mul_in_prdy) <= sdp_erdma2dp_mul_pd[256:0] (sdp_erdma2dp_mul_valid,sdp_erdma2dp_mul_ready)
// **************************************************************************************************************
module NV_NVDLA_SDP_CORE_pipe_p5 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,ew_mul_in_prdy
  ,sdp_erdma2dp_mul_pd
  ,sdp_erdma2dp_mul_valid
  ,ew_mul_in_pd
  ,ew_mul_in_pvld
  ,sdp_erdma2dp_mul_ready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          ew_mul_in_prdy;
input  [256:0] sdp_erdma2dp_mul_pd;
input          sdp_erdma2dp_mul_valid;
output [256:0] ew_mul_in_pd;
output         ew_mul_in_pvld;
output         sdp_erdma2dp_mul_ready;
reg    [256:0] ew_mul_in_pd;
reg            ew_mul_in_pvld;
reg    [256:0] p5_pipe_data;
reg    [256:0] p5_pipe_rand_data;
reg            p5_pipe_rand_ready;
reg            p5_pipe_rand_valid;
reg            p5_pipe_ready;
reg            p5_pipe_ready_bc;
reg            p5_pipe_valid;
reg            sdp_erdma2dp_mul_ready;
//## pipe (5) randomizer
`ifndef SYNTHESIS
reg p5_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p5_pipe_rand_active
  or 
     `endif
     sdp_erdma2dp_mul_valid
  or p5_pipe_rand_ready
  or sdp_erdma2dp_mul_pd
  ) begin
  `ifdef SYNTHESIS
  p5_pipe_rand_valid = sdp_erdma2dp_mul_valid;
  sdp_erdma2dp_mul_ready = p5_pipe_rand_ready;
  p5_pipe_rand_data = sdp_erdma2dp_mul_pd[256:0];
  `else
  // VCS coverage off
  p5_pipe_rand_valid = (p5_pipe_rand_active)? 1'b0 : sdp_erdma2dp_mul_valid;
  sdp_erdma2dp_mul_ready = (p5_pipe_rand_active)? 1'b0 : p5_pipe_rand_ready;
  p5_pipe_rand_data = (p5_pipe_rand_active)?  'bx : sdp_erdma2dp_mul_pd[256:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p5_pipe_stall_cycles;
integer p5_pipe_stall_probability;
integer p5_pipe_stall_cycles_min;
integer p5_pipe_stall_cycles_max;
initial begin
  p5_pipe_stall_cycles = 0;
  p5_pipe_stall_probability = 0;
  p5_pipe_stall_cycles_min = 1;
  p5_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_rand_probability=%d",  p5_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p5_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability=%d", p5_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p5_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min=%d",  p5_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p5_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max=%d",  p5_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p5_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability" ) ) p5_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min"  ) ) p5_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max"  ) ) p5_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p5_pipe_rand_enable;
reg p5_pipe_rand_poised;
always @(
  p5_pipe_stall_cycles
  or p5_pipe_stall_probability
  or sdp_erdma2dp_mul_valid
  ) begin
  p5_pipe_rand_active = p5_pipe_stall_cycles != 0;
  p5_pipe_rand_enable = p5_pipe_stall_probability != 0;
  p5_pipe_rand_poised = p5_pipe_rand_enable && !p5_pipe_rand_active && sdp_erdma2dp_mul_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p5_pipe_rand_poised) begin
    if (p5_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p5_pipe_stall_cycles <= prand_inst1(p5_pipe_stall_cycles_min, p5_pipe_stall_cycles_max);
    end
  end else if (p5_pipe_rand_active) begin
    p5_pipe_stall_cycles <= p5_pipe_stall_cycles - 1;
  end else begin
    p5_pipe_stall_cycles <= 0;
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
//## pipe (5) valid-ready-bubble-collapse
always @(
  p5_pipe_ready
  or p5_pipe_valid
  ) begin
  p5_pipe_ready_bc = p5_pipe_ready || !p5_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_pipe_valid <= 1'b0;
  end else begin
  p5_pipe_valid <= (p5_pipe_ready_bc)? p5_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p5_pipe_data <= (p5_pipe_ready_bc && p5_pipe_rand_valid)? p5_pipe_rand_data : p5_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p5_pipe_ready_bc
  ) begin
  p5_pipe_rand_ready = p5_pipe_ready_bc;
end
//## pipe (5) output
always @(
  p5_pipe_valid
  or ew_mul_in_prdy
  or p5_pipe_data
  ) begin
  ew_mul_in_pvld = p5_pipe_valid;
  p5_pipe_ready = ew_mul_in_prdy;
  ew_mul_in_pd = p5_pipe_data;
end
//## pipe (5) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p5_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (ew_mul_in_pvld^ew_mul_in_prdy^sdp_erdma2dp_mul_valid^sdp_erdma2dp_mul_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_10x (nvdla_core_clk, `ASSERT_RESET, (sdp_erdma2dp_mul_valid && !sdp_erdma2dp_mul_ready), (sdp_erdma2dp_mul_valid), (sdp_erdma2dp_mul_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_CORE_pipe_p5




// **************************************************************************************************************
// Generated by ::pipe -m -bc ew_alu_in_pd (ew_alu_in_pvld,ew_alu_in_prdy) <= sdp_erdma2dp_alu_pd[256:0] (sdp_erdma2dp_alu_valid,sdp_erdma2dp_alu_ready)
// **************************************************************************************************************
module NV_NVDLA_SDP_CORE_pipe_p6 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,ew_alu_in_prdy
  ,sdp_erdma2dp_alu_pd
  ,sdp_erdma2dp_alu_valid
  ,ew_alu_in_pd
  ,ew_alu_in_pvld
  ,sdp_erdma2dp_alu_ready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          ew_alu_in_prdy;
input  [256:0] sdp_erdma2dp_alu_pd;
input          sdp_erdma2dp_alu_valid;
output [256:0] ew_alu_in_pd;
output         ew_alu_in_pvld;
output         sdp_erdma2dp_alu_ready;
reg    [256:0] ew_alu_in_pd;
reg            ew_alu_in_pvld;
reg    [256:0] p6_pipe_data;
reg    [256:0] p6_pipe_rand_data;
reg            p6_pipe_rand_ready;
reg            p6_pipe_rand_valid;
reg            p6_pipe_ready;
reg            p6_pipe_ready_bc;
reg            p6_pipe_valid;
reg            sdp_erdma2dp_alu_ready;
//## pipe (6) randomizer
`ifndef SYNTHESIS
reg p6_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p6_pipe_rand_active
  or 
     `endif
     sdp_erdma2dp_alu_valid
  or p6_pipe_rand_ready
  or sdp_erdma2dp_alu_pd
  ) begin
  `ifdef SYNTHESIS
  p6_pipe_rand_valid = sdp_erdma2dp_alu_valid;
  sdp_erdma2dp_alu_ready = p6_pipe_rand_ready;
  p6_pipe_rand_data = sdp_erdma2dp_alu_pd[256:0];
  `else
  // VCS coverage off
  p6_pipe_rand_valid = (p6_pipe_rand_active)? 1'b0 : sdp_erdma2dp_alu_valid;
  sdp_erdma2dp_alu_ready = (p6_pipe_rand_active)? 1'b0 : p6_pipe_rand_ready;
  p6_pipe_rand_data = (p6_pipe_rand_active)?  'bx : sdp_erdma2dp_alu_pd[256:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p6_pipe_stall_cycles;
integer p6_pipe_stall_probability;
integer p6_pipe_stall_cycles_min;
integer p6_pipe_stall_cycles_max;
initial begin
  p6_pipe_stall_cycles = 0;
  p6_pipe_stall_probability = 0;
  p6_pipe_stall_cycles_min = 1;
  p6_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_rand_probability=%d",  p6_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p6_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability=%d", p6_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p6_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min=%d",  p6_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p6_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max=%d",  p6_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p6_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability" ) ) p6_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min"  ) ) p6_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max"  ) ) p6_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p6_pipe_rand_enable;
reg p6_pipe_rand_poised;
always @(
  p6_pipe_stall_cycles
  or p6_pipe_stall_probability
  or sdp_erdma2dp_alu_valid
  ) begin
  p6_pipe_rand_active = p6_pipe_stall_cycles != 0;
  p6_pipe_rand_enable = p6_pipe_stall_probability != 0;
  p6_pipe_rand_poised = p6_pipe_rand_enable && !p6_pipe_rand_active && sdp_erdma2dp_alu_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p6_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p6_pipe_rand_poised) begin
    if (p6_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p6_pipe_stall_cycles <= prand_inst1(p6_pipe_stall_cycles_min, p6_pipe_stall_cycles_max);
    end
  end else if (p6_pipe_rand_active) begin
    p6_pipe_stall_cycles <= p6_pipe_stall_cycles - 1;
  end else begin
    p6_pipe_stall_cycles <= 0;
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
//## pipe (6) valid-ready-bubble-collapse
always @(
  p6_pipe_ready
  or p6_pipe_valid
  ) begin
  p6_pipe_ready_bc = p6_pipe_ready || !p6_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p6_pipe_valid <= 1'b0;
  end else begin
  p6_pipe_valid <= (p6_pipe_ready_bc)? p6_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p6_pipe_data <= (p6_pipe_ready_bc && p6_pipe_rand_valid)? p6_pipe_rand_data : p6_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p6_pipe_ready_bc
  ) begin
  p6_pipe_rand_ready = p6_pipe_ready_bc;
end
//## pipe (6) output
always @(
  p6_pipe_valid
  or ew_alu_in_prdy
  or p6_pipe_data
  ) begin
  ew_alu_in_pvld = p6_pipe_valid;
  p6_pipe_ready = ew_alu_in_prdy;
  ew_alu_in_pd = p6_pipe_data;
end
//## pipe (6) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p6_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (ew_alu_in_pvld^ew_alu_in_prdy^sdp_erdma2dp_alu_valid^sdp_erdma2dp_alu_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_12x (nvdla_core_clk, `ASSERT_RESET, (sdp_erdma2dp_alu_valid && !sdp_erdma2dp_alu_ready), (sdp_erdma2dp_alu_valid), (sdp_erdma2dp_alu_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_CORE_pipe_p6




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is flop_bs_data_in_pd (flop_bs_data_in_pvld,flop_bs_data_in_prdy) <= bs_data_in_pd[511:0] (bs_data_in_pvld,bs_data_in_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_CORE_pipe_p7 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,bs_data_in_pd
  ,bs_data_in_pvld
  ,flop_bs_data_in_prdy
  ,bs_data_in_prdy
  ,flop_bs_data_in_pd
  ,flop_bs_data_in_pvld
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [511:0] bs_data_in_pd;
input          bs_data_in_pvld;
input          flop_bs_data_in_prdy;
output         bs_data_in_prdy;
output [511:0] flop_bs_data_in_pd;
output         flop_bs_data_in_pvld;
reg            bs_data_in_prdy;
reg    [511:0] flop_bs_data_in_pd;
reg            flop_bs_data_in_pvld;
reg    [511:0] p7_pipe_data;
reg    [511:0] p7_pipe_rand_data;
reg            p7_pipe_rand_ready;
reg            p7_pipe_rand_valid;
reg            p7_pipe_ready;
reg            p7_pipe_ready_bc;
reg            p7_pipe_valid;
reg            p7_skid_catch;
reg    [511:0] p7_skid_data;
reg    [511:0] p7_skid_pipe_data;
reg            p7_skid_pipe_ready;
reg            p7_skid_pipe_valid;
reg            p7_skid_ready;
reg            p7_skid_ready_flop;
reg            p7_skid_valid;
//## pipe (7) randomizer
`ifndef SYNTHESIS
reg p7_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p7_pipe_rand_active
  or 
     `endif
     bs_data_in_pvld
  or p7_pipe_rand_ready
  or bs_data_in_pd
  ) begin
  `ifdef SYNTHESIS
  p7_pipe_rand_valid = bs_data_in_pvld;
  bs_data_in_prdy = p7_pipe_rand_ready;
  p7_pipe_rand_data = bs_data_in_pd[511:0];
  `else
  // VCS coverage off
  p7_pipe_rand_valid = (p7_pipe_rand_active)? 1'b0 : bs_data_in_pvld;
  bs_data_in_prdy = (p7_pipe_rand_active)? 1'b0 : p7_pipe_rand_ready;
  p7_pipe_rand_data = (p7_pipe_rand_active)?  'bx : bs_data_in_pd[511:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p7_pipe_stall_cycles;
integer p7_pipe_stall_probability;
integer p7_pipe_stall_cycles_min;
integer p7_pipe_stall_cycles_max;
initial begin
  p7_pipe_stall_cycles = 0;
  p7_pipe_stall_probability = 0;
  p7_pipe_stall_cycles_min = 1;
  p7_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_rand_probability=%d",  p7_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p7_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability=%d", p7_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p7_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min=%d",  p7_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p7_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max=%d",  p7_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p7_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability" ) ) p7_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min"  ) ) p7_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max"  ) ) p7_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p7_pipe_rand_enable;
reg p7_pipe_rand_poised;
always @(
  p7_pipe_stall_cycles
  or p7_pipe_stall_probability
  or bs_data_in_pvld
  ) begin
  p7_pipe_rand_active = p7_pipe_stall_cycles != 0;
  p7_pipe_rand_enable = p7_pipe_stall_probability != 0;
  p7_pipe_rand_poised = p7_pipe_rand_enable && !p7_pipe_rand_active && bs_data_in_pvld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p7_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p7_pipe_rand_poised) begin
    if (p7_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p7_pipe_stall_cycles <= prand_inst1(p7_pipe_stall_cycles_min, p7_pipe_stall_cycles_max);
    end
  end else if (p7_pipe_rand_active) begin
    p7_pipe_stall_cycles <= p7_pipe_stall_cycles - 1;
  end else begin
    p7_pipe_stall_cycles <= 0;
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
//## pipe (7) skid buffer
always @(
  p7_pipe_rand_valid
  or p7_skid_ready_flop
  or p7_skid_pipe_ready
  or p7_skid_valid
  ) begin
  p7_skid_catch = p7_pipe_rand_valid && p7_skid_ready_flop && !p7_skid_pipe_ready;  
  p7_skid_ready = (p7_skid_valid)? p7_skid_pipe_ready : !p7_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p7_skid_valid <= 1'b0;
    p7_skid_ready_flop <= 1'b1;
    p7_pipe_rand_ready <= 1'b1;
  end else begin
  p7_skid_valid <= (p7_skid_valid)? !p7_skid_pipe_ready : p7_skid_catch;
  p7_skid_ready_flop <= p7_skid_ready;
  p7_pipe_rand_ready <= p7_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p7_skid_data <= (p7_skid_catch)? p7_pipe_rand_data : p7_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p7_skid_ready_flop
  or p7_pipe_rand_valid
  or p7_skid_valid
  or p7_pipe_rand_data
  or p7_skid_data
  ) begin
  p7_skid_pipe_valid = (p7_skid_ready_flop)? p7_pipe_rand_valid : p7_skid_valid; 
  // VCS sop_coverage_off start
  p7_skid_pipe_data = (p7_skid_ready_flop)? p7_pipe_rand_data : p7_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (7) valid-ready-bubble-collapse
always @(
  p7_pipe_ready
  or p7_pipe_valid
  ) begin
  p7_pipe_ready_bc = p7_pipe_ready || !p7_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p7_pipe_valid <= 1'b0;
  end else begin
  p7_pipe_valid <= (p7_pipe_ready_bc)? p7_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p7_pipe_data <= (p7_pipe_ready_bc && p7_skid_pipe_valid)? p7_skid_pipe_data : p7_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p7_pipe_ready_bc
  ) begin
  p7_skid_pipe_ready = p7_pipe_ready_bc;
end
//## pipe (7) output
always @(
  p7_pipe_valid
  or flop_bs_data_in_prdy
  or p7_pipe_data
  ) begin
  flop_bs_data_in_pvld = p7_pipe_valid;
  p7_pipe_ready = flop_bs_data_in_prdy;
  flop_bs_data_in_pd = p7_pipe_data;
end
//## pipe (7) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p7_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (flop_bs_data_in_pvld^flop_bs_data_in_prdy^bs_data_in_pvld^bs_data_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_14x (nvdla_core_clk, `ASSERT_RESET, (bs_data_in_pvld && !bs_data_in_prdy), (bs_data_in_pvld), (bs_data_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_CORE_pipe_p7




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is flop_bn_data_in_pd (flop_bn_data_in_pvld,flop_bn_data_in_prdy) <= bn_data_in_pd[511:0] (bn_data_in_pvld,bn_data_in_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_CORE_pipe_p8 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,bn_data_in_pd
  ,bn_data_in_pvld
  ,flop_bn_data_in_prdy
  ,bn_data_in_prdy
  ,flop_bn_data_in_pd
  ,flop_bn_data_in_pvld
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [511:0] bn_data_in_pd;
input          bn_data_in_pvld;
input          flop_bn_data_in_prdy;
output         bn_data_in_prdy;
output [511:0] flop_bn_data_in_pd;
output         flop_bn_data_in_pvld;
reg            bn_data_in_prdy;
reg    [511:0] flop_bn_data_in_pd;
reg            flop_bn_data_in_pvld;
reg    [511:0] p8_pipe_data;
reg    [511:0] p8_pipe_rand_data;
reg            p8_pipe_rand_ready;
reg            p8_pipe_rand_valid;
reg            p8_pipe_ready;
reg            p8_pipe_ready_bc;
reg            p8_pipe_valid;
reg            p8_skid_catch;
reg    [511:0] p8_skid_data;
reg    [511:0] p8_skid_pipe_data;
reg            p8_skid_pipe_ready;
reg            p8_skid_pipe_valid;
reg            p8_skid_ready;
reg            p8_skid_ready_flop;
reg            p8_skid_valid;
//## pipe (8) randomizer
`ifndef SYNTHESIS
reg p8_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p8_pipe_rand_active
  or 
     `endif
     bn_data_in_pvld
  or p8_pipe_rand_ready
  or bn_data_in_pd
  ) begin
  `ifdef SYNTHESIS
  p8_pipe_rand_valid = bn_data_in_pvld;
  bn_data_in_prdy = p8_pipe_rand_ready;
  p8_pipe_rand_data = bn_data_in_pd[511:0];
  `else
  // VCS coverage off
  p8_pipe_rand_valid = (p8_pipe_rand_active)? 1'b0 : bn_data_in_pvld;
  bn_data_in_prdy = (p8_pipe_rand_active)? 1'b0 : p8_pipe_rand_ready;
  p8_pipe_rand_data = (p8_pipe_rand_active)?  'bx : bn_data_in_pd[511:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p8_pipe_stall_cycles;
integer p8_pipe_stall_probability;
integer p8_pipe_stall_cycles_min;
integer p8_pipe_stall_cycles_max;
initial begin
  p8_pipe_stall_cycles = 0;
  p8_pipe_stall_probability = 0;
  p8_pipe_stall_cycles_min = 1;
  p8_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_rand_probability=%d",  p8_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p8_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability=%d", p8_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p8_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min=%d",  p8_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p8_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max=%d",  p8_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p8_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability" ) ) p8_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min"  ) ) p8_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max"  ) ) p8_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p8_pipe_rand_enable;
reg p8_pipe_rand_poised;
always @(
  p8_pipe_stall_cycles
  or p8_pipe_stall_probability
  or bn_data_in_pvld
  ) begin
  p8_pipe_rand_active = p8_pipe_stall_cycles != 0;
  p8_pipe_rand_enable = p8_pipe_stall_probability != 0;
  p8_pipe_rand_poised = p8_pipe_rand_enable && !p8_pipe_rand_active && bn_data_in_pvld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p8_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p8_pipe_rand_poised) begin
    if (p8_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p8_pipe_stall_cycles <= prand_inst1(p8_pipe_stall_cycles_min, p8_pipe_stall_cycles_max);
    end
  end else if (p8_pipe_rand_active) begin
    p8_pipe_stall_cycles <= p8_pipe_stall_cycles - 1;
  end else begin
    p8_pipe_stall_cycles <= 0;
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
//## pipe (8) skid buffer
always @(
  p8_pipe_rand_valid
  or p8_skid_ready_flop
  or p8_skid_pipe_ready
  or p8_skid_valid
  ) begin
  p8_skid_catch = p8_pipe_rand_valid && p8_skid_ready_flop && !p8_skid_pipe_ready;  
  p8_skid_ready = (p8_skid_valid)? p8_skid_pipe_ready : !p8_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p8_skid_valid <= 1'b0;
    p8_skid_ready_flop <= 1'b1;
    p8_pipe_rand_ready <= 1'b1;
  end else begin
  p8_skid_valid <= (p8_skid_valid)? !p8_skid_pipe_ready : p8_skid_catch;
  p8_skid_ready_flop <= p8_skid_ready;
  p8_pipe_rand_ready <= p8_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p8_skid_data <= (p8_skid_catch)? p8_pipe_rand_data : p8_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p8_skid_ready_flop
  or p8_pipe_rand_valid
  or p8_skid_valid
  or p8_pipe_rand_data
  or p8_skid_data
  ) begin
  p8_skid_pipe_valid = (p8_skid_ready_flop)? p8_pipe_rand_valid : p8_skid_valid; 
  // VCS sop_coverage_off start
  p8_skid_pipe_data = (p8_skid_ready_flop)? p8_pipe_rand_data : p8_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (8) valid-ready-bubble-collapse
always @(
  p8_pipe_ready
  or p8_pipe_valid
  ) begin
  p8_pipe_ready_bc = p8_pipe_ready || !p8_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p8_pipe_valid <= 1'b0;
  end else begin
  p8_pipe_valid <= (p8_pipe_ready_bc)? p8_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p8_pipe_data <= (p8_pipe_ready_bc && p8_skid_pipe_valid)? p8_skid_pipe_data : p8_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p8_pipe_ready_bc
  ) begin
  p8_skid_pipe_ready = p8_pipe_ready_bc;
end
//## pipe (8) output
always @(
  p8_pipe_valid
  or flop_bn_data_in_prdy
  or p8_pipe_data
  ) begin
  flop_bn_data_in_pvld = p8_pipe_valid;
  p8_pipe_ready = flop_bn_data_in_prdy;
  flop_bn_data_in_pd = p8_pipe_data;
end
//## pipe (8) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p8_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (flop_bn_data_in_pvld^flop_bn_data_in_prdy^bn_data_in_pvld^bn_data_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_16x (nvdla_core_clk, `ASSERT_RESET, (bn_data_in_pvld && !bn_data_in_prdy), (bn_data_in_pvld), (bn_data_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_CORE_pipe_p8




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is flop_cvt_data_in_pd (flop_cvt_data_in_pvld,flop_cvt_data_in_prdy) <= cvt_data_in_pd[511:0] (cvt_data_in_pvld,cvt_data_in_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_CORE_pipe_p9 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cvt_data_in_pd
  ,cvt_data_in_pvld
  ,flop_cvt_data_in_prdy
  ,cvt_data_in_prdy
  ,flop_cvt_data_in_pd
  ,flop_cvt_data_in_pvld
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [511:0] cvt_data_in_pd;
input          cvt_data_in_pvld;
input          flop_cvt_data_in_prdy;
output         cvt_data_in_prdy;
output [511:0] flop_cvt_data_in_pd;
output         flop_cvt_data_in_pvld;
reg            cvt_data_in_prdy;
reg    [511:0] flop_cvt_data_in_pd;
reg            flop_cvt_data_in_pvld;
reg    [511:0] p9_pipe_data;
reg    [511:0] p9_pipe_rand_data;
reg            p9_pipe_rand_ready;
reg            p9_pipe_rand_valid;
reg            p9_pipe_ready;
reg            p9_pipe_ready_bc;
reg            p9_pipe_valid;
reg            p9_skid_catch;
reg    [511:0] p9_skid_data;
reg    [511:0] p9_skid_pipe_data;
reg            p9_skid_pipe_ready;
reg            p9_skid_pipe_valid;
reg            p9_skid_ready;
reg            p9_skid_ready_flop;
reg            p9_skid_valid;
//## pipe (9) randomizer
`ifndef SYNTHESIS
reg p9_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p9_pipe_rand_active
  or 
     `endif
     cvt_data_in_pvld
  or p9_pipe_rand_ready
  or cvt_data_in_pd
  ) begin
  `ifdef SYNTHESIS
  p9_pipe_rand_valid = cvt_data_in_pvld;
  cvt_data_in_prdy = p9_pipe_rand_ready;
  p9_pipe_rand_data = cvt_data_in_pd[511:0];
  `else
  // VCS coverage off
  p9_pipe_rand_valid = (p9_pipe_rand_active)? 1'b0 : cvt_data_in_pvld;
  cvt_data_in_prdy = (p9_pipe_rand_active)? 1'b0 : p9_pipe_rand_ready;
  p9_pipe_rand_data = (p9_pipe_rand_active)?  'bx : cvt_data_in_pd[511:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p9_pipe_stall_cycles;
integer p9_pipe_stall_probability;
integer p9_pipe_stall_cycles_min;
integer p9_pipe_stall_cycles_max;
initial begin
  p9_pipe_stall_cycles = 0;
  p9_pipe_stall_probability = 0;
  p9_pipe_stall_cycles_min = 1;
  p9_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_rand_probability=%d",  p9_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p9_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability=%d", p9_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p9_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min=%d",  p9_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p9_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max=%d",  p9_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p9_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability" ) ) p9_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min"  ) ) p9_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max"  ) ) p9_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p9_pipe_rand_enable;
reg p9_pipe_rand_poised;
always @(
  p9_pipe_stall_cycles
  or p9_pipe_stall_probability
  or cvt_data_in_pvld
  ) begin
  p9_pipe_rand_active = p9_pipe_stall_cycles != 0;
  p9_pipe_rand_enable = p9_pipe_stall_probability != 0;
  p9_pipe_rand_poised = p9_pipe_rand_enable && !p9_pipe_rand_active && cvt_data_in_pvld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p9_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p9_pipe_rand_poised) begin
    if (p9_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p9_pipe_stall_cycles <= prand_inst1(p9_pipe_stall_cycles_min, p9_pipe_stall_cycles_max);
    end
  end else if (p9_pipe_rand_active) begin
    p9_pipe_stall_cycles <= p9_pipe_stall_cycles - 1;
  end else begin
    p9_pipe_stall_cycles <= 0;
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
//## pipe (9) skid buffer
always @(
  p9_pipe_rand_valid
  or p9_skid_ready_flop
  or p9_skid_pipe_ready
  or p9_skid_valid
  ) begin
  p9_skid_catch = p9_pipe_rand_valid && p9_skid_ready_flop && !p9_skid_pipe_ready;  
  p9_skid_ready = (p9_skid_valid)? p9_skid_pipe_ready : !p9_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p9_skid_valid <= 1'b0;
    p9_skid_ready_flop <= 1'b1;
    p9_pipe_rand_ready <= 1'b1;
  end else begin
  p9_skid_valid <= (p9_skid_valid)? !p9_skid_pipe_ready : p9_skid_catch;
  p9_skid_ready_flop <= p9_skid_ready;
  p9_pipe_rand_ready <= p9_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p9_skid_data <= (p9_skid_catch)? p9_pipe_rand_data : p9_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p9_skid_ready_flop
  or p9_pipe_rand_valid
  or p9_skid_valid
  or p9_pipe_rand_data
  or p9_skid_data
  ) begin
  p9_skid_pipe_valid = (p9_skid_ready_flop)? p9_pipe_rand_valid : p9_skid_valid; 
  // VCS sop_coverage_off start
  p9_skid_pipe_data = (p9_skid_ready_flop)? p9_pipe_rand_data : p9_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (9) valid-ready-bubble-collapse
always @(
  p9_pipe_ready
  or p9_pipe_valid
  ) begin
  p9_pipe_ready_bc = p9_pipe_ready || !p9_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p9_pipe_valid <= 1'b0;
  end else begin
  p9_pipe_valid <= (p9_pipe_ready_bc)? p9_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p9_pipe_data <= (p9_pipe_ready_bc && p9_skid_pipe_valid)? p9_skid_pipe_data : p9_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p9_pipe_ready_bc
  ) begin
  p9_skid_pipe_ready = p9_pipe_ready_bc;
end
//## pipe (9) output
always @(
  p9_pipe_valid
  or flop_cvt_data_in_prdy
  or p9_pipe_data
  ) begin
  flop_cvt_data_in_pvld = p9_pipe_valid;
  p9_pipe_ready = flop_cvt_data_in_prdy;
  flop_cvt_data_in_pd = p9_pipe_data;
end
//## pipe (9) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p9_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (flop_cvt_data_in_pvld^flop_cvt_data_in_prdy^cvt_data_in_pvld^cvt_data_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_18x (nvdla_core_clk, `ASSERT_RESET, (cvt_data_in_pvld && !cvt_data_in_prdy), (cvt_data_in_pvld), (cvt_data_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_CORE_pipe_p9




// **************************************************************************************************************
// Generated by ::pipe -m -bc sdp_dp2wdma_pd (sdp_dp2wdma_valid,sdp_dp2wdma_ready) <= core2wdma_pd[255:0] (core2wdma_vld,core2wdma_rdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_CORE_pipe_p10 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,core2wdma_pd
  ,core2wdma_vld
  ,sdp_dp2wdma_ready
  ,core2wdma_rdy
  ,sdp_dp2wdma_pd
  ,sdp_dp2wdma_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [255:0] core2wdma_pd;
input          core2wdma_vld;
input          sdp_dp2wdma_ready;
output         core2wdma_rdy;
output [255:0] sdp_dp2wdma_pd;
output         sdp_dp2wdma_valid;
reg            core2wdma_rdy;
reg    [255:0] p10_pipe_data;
reg    [255:0] p10_pipe_rand_data;
reg            p10_pipe_rand_ready;
reg            p10_pipe_rand_valid;
reg            p10_pipe_ready;
reg            p10_pipe_ready_bc;
reg            p10_pipe_valid;
reg    [255:0] sdp_dp2wdma_pd;
reg            sdp_dp2wdma_valid;
//## pipe (10) randomizer
`ifndef SYNTHESIS
reg p10_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p10_pipe_rand_active
  or 
     `endif
     core2wdma_vld
  or p10_pipe_rand_ready
  or core2wdma_pd
  ) begin
  `ifdef SYNTHESIS
  p10_pipe_rand_valid = core2wdma_vld;
  core2wdma_rdy = p10_pipe_rand_ready;
  p10_pipe_rand_data = core2wdma_pd[255:0];
  `else
  // VCS coverage off
  p10_pipe_rand_valid = (p10_pipe_rand_active)? 1'b0 : core2wdma_vld;
  core2wdma_rdy = (p10_pipe_rand_active)? 1'b0 : p10_pipe_rand_ready;
  p10_pipe_rand_data = (p10_pipe_rand_active)?  'bx : core2wdma_pd[255:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p10_pipe_stall_cycles;
integer p10_pipe_stall_probability;
integer p10_pipe_stall_cycles_min;
integer p10_pipe_stall_cycles_max;
initial begin
  p10_pipe_stall_cycles = 0;
  p10_pipe_stall_probability = 0;
  p10_pipe_stall_cycles_min = 1;
  p10_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_rand_probability=%d",  p10_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p10_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability=%d", p10_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p10_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min=%d",  p10_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p10_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max=%d",  p10_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p10_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability" ) ) p10_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min"  ) ) p10_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max"  ) ) p10_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p10_pipe_rand_enable;
reg p10_pipe_rand_poised;
always @(
  p10_pipe_stall_cycles
  or p10_pipe_stall_probability
  or core2wdma_vld
  ) begin
  p10_pipe_rand_active = p10_pipe_stall_cycles != 0;
  p10_pipe_rand_enable = p10_pipe_stall_probability != 0;
  p10_pipe_rand_poised = p10_pipe_rand_enable && !p10_pipe_rand_active && core2wdma_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p10_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p10_pipe_rand_poised) begin
    if (p10_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p10_pipe_stall_cycles <= prand_inst1(p10_pipe_stall_cycles_min, p10_pipe_stall_cycles_max);
    end
  end else if (p10_pipe_rand_active) begin
    p10_pipe_stall_cycles <= p10_pipe_stall_cycles - 1;
  end else begin
    p10_pipe_stall_cycles <= 0;
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
//## pipe (10) valid-ready-bubble-collapse
always @(
  p10_pipe_ready
  or p10_pipe_valid
  ) begin
  p10_pipe_ready_bc = p10_pipe_ready || !p10_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p10_pipe_valid <= 1'b0;
  end else begin
  p10_pipe_valid <= (p10_pipe_ready_bc)? p10_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p10_pipe_data <= (p10_pipe_ready_bc && p10_pipe_rand_valid)? p10_pipe_rand_data : p10_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p10_pipe_ready_bc
  ) begin
  p10_pipe_rand_ready = p10_pipe_ready_bc;
end
//## pipe (10) output
always @(
  p10_pipe_valid
  or sdp_dp2wdma_ready
  or p10_pipe_data
  ) begin
  sdp_dp2wdma_valid = p10_pipe_valid;
  p10_pipe_ready = sdp_dp2wdma_ready;
  sdp_dp2wdma_pd = p10_pipe_data;
end
//## pipe (10) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p10_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sdp_dp2wdma_valid^sdp_dp2wdma_ready^core2wdma_vld^core2wdma_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_20x (nvdla_core_clk, `ASSERT_RESET, (core2wdma_vld && !core2wdma_rdy), (core2wdma_vld), (core2wdma_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_CORE_pipe_p10




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
input  [255:0] core2pdp_pd;
input          core2pdp_vld;
input          sdp2pdp_ready;
output         core2pdp_rdy;
output [255:0] sdp2pdp_pd;
output         sdp2pdp_valid;
reg            core2pdp_rdy;
reg    [255:0] p11_pipe_data;
reg    [255:0] p11_pipe_rand_data;
reg            p11_pipe_rand_ready;
reg            p11_pipe_rand_valid;
reg            p11_pipe_ready;
reg            p11_pipe_ready_bc;
reg            p11_pipe_valid;
reg    [255:0] sdp2pdp_pd;
reg            sdp2pdp_valid;
//## pipe (11) randomizer
`ifndef SYNTHESIS
reg p11_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p11_pipe_rand_active
  or 
     `endif
     core2pdp_vld
  or p11_pipe_rand_ready
  or core2pdp_pd
  ) begin
  `ifdef SYNTHESIS
  p11_pipe_rand_valid = core2pdp_vld;
  core2pdp_rdy = p11_pipe_rand_ready;
  p11_pipe_rand_data = core2pdp_pd[255:0];
  `else
  // VCS coverage off
  p11_pipe_rand_valid = (p11_pipe_rand_active)? 1'b0 : core2pdp_vld;
  core2pdp_rdy = (p11_pipe_rand_active)? 1'b0 : p11_pipe_rand_ready;
  p11_pipe_rand_data = (p11_pipe_rand_active)?  'bx : core2pdp_pd[255:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p11_pipe_stall_cycles;
integer p11_pipe_stall_probability;
integer p11_pipe_stall_cycles_min;
integer p11_pipe_stall_cycles_max;
initial begin
  p11_pipe_stall_cycles = 0;
  p11_pipe_stall_probability = 0;
  p11_pipe_stall_cycles_min = 1;
  p11_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_rand_probability=%d",  p11_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p11_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability=%d", p11_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p11_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min=%d",  p11_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p11_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max=%d",  p11_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p11_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_probability" ) ) p11_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_min"  ) ) p11_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_core_pipe_stall_cycles_max"  ) ) p11_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p11_pipe_rand_enable;
reg p11_pipe_rand_poised;
always @(
  p11_pipe_stall_cycles
  or p11_pipe_stall_probability
  or core2pdp_vld
  ) begin
  p11_pipe_rand_active = p11_pipe_stall_cycles != 0;
  p11_pipe_rand_enable = p11_pipe_stall_probability != 0;
  p11_pipe_rand_poised = p11_pipe_rand_enable && !p11_pipe_rand_active && core2pdp_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p11_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p11_pipe_rand_poised) begin
    if (p11_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p11_pipe_stall_cycles <= prand_inst1(p11_pipe_stall_cycles_min, p11_pipe_stall_cycles_max);
    end
  end else if (p11_pipe_rand_active) begin
    p11_pipe_stall_cycles <= p11_pipe_stall_cycles - 1;
  end else begin
    p11_pipe_stall_cycles <= 0;
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
//## pipe (11) valid-ready-bubble-collapse
always @(
  p11_pipe_ready
  or p11_pipe_valid
  ) begin
  p11_pipe_ready_bc = p11_pipe_ready || !p11_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p11_pipe_valid <= 1'b0;
  end else begin
  p11_pipe_valid <= (p11_pipe_ready_bc)? p11_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p11_pipe_data <= (p11_pipe_ready_bc && p11_pipe_rand_valid)? p11_pipe_rand_data : p11_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p11_pipe_ready_bc
  ) begin
  p11_pipe_rand_ready = p11_pipe_ready_bc;
end
//## pipe (11) output
always @(
  p11_pipe_valid
  or sdp2pdp_ready
  or p11_pipe_data
  ) begin
  sdp2pdp_valid = p11_pipe_valid;
  p11_pipe_ready = sdp2pdp_ready;
  sdp2pdp_pd = p11_pipe_data;
end
//## pipe (11) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p11_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sdp2pdp_valid^sdp2pdp_ready^core2pdp_vld^core2pdp_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_22x (nvdla_core_clk, `ASSERT_RESET, (core2pdp_vld && !core2pdp_rdy), (core2pdp_vld), (core2pdp_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_CORE_pipe_p11


