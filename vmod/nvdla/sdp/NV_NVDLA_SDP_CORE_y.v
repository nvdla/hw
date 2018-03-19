// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_CORE_y.v

#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_CORE_y (
   nvdla_core_clk                  //|< i
  ,nvdla_core_rstn                 //|< i
  ,op_en_load                      //|< i
  ,pwrbus_ram_pd                   //|< i
  ,ew_alu_in_rdy                   //|> o
  ,ew_alu_in_data                  //|< i
  ,ew_alu_in_vld                   //|< i
  ,ew_mul_in_data                  //|< i
  ,ew_mul_in_vld                   //|< i
  ,ew_mul_in_rdy                   //|> o
  ,ew_data_in_pd                   //|< i
  ,ew_data_in_pvld                 //|< i
  ,ew_data_in_prdy                 //|> o
  ,reg2dp_nan_to_zero              //|< i
  ,reg2dp_perf_lut_en              //|< i
  ,reg2dp_proc_precision           //|< i
  ,reg2dp_ew_alu_algo              //|< i
  ,reg2dp_ew_alu_bypass            //|< i
  ,reg2dp_ew_alu_cvt_bypass        //|< i
  ,reg2dp_ew_alu_cvt_offset        //|< i
  ,reg2dp_ew_alu_cvt_scale         //|< i
  ,reg2dp_ew_alu_cvt_truncate      //|< i
  ,reg2dp_ew_alu_operand           //|< i
  ,reg2dp_ew_alu_src               //|< i
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
  ,ew_data_out_pd                  //|> o
  ,ew_data_out_pvld                //|> o
  ,ew_data_out_prdy                //|< i
  );

input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [EW_OP_DW-1:0] ew_alu_in_data;
input          ew_alu_in_vld;
output         ew_alu_in_rdy;
input  [EW_IN_DW-1:0] ew_data_in_pd;
input          ew_data_in_pvld;
output         ew_data_in_prdy;
input  [EW_OP_DW-1:0] ew_mul_in_data;
input          ew_mul_in_vld;
output         ew_mul_in_rdy;
output [EW_OUT_DW-1:0] ew_data_out_pd;
output         ew_data_out_pvld;
input          ew_data_out_prdy;
input    [1:0] reg2dp_ew_alu_algo;
input          reg2dp_ew_alu_bypass;
input          reg2dp_ew_alu_cvt_bypass;
input   [31:0] reg2dp_ew_alu_cvt_offset;
input   [15:0] reg2dp_ew_alu_cvt_scale;
input    [5:0] reg2dp_ew_alu_cvt_truncate;
input   [31:0] reg2dp_ew_alu_operand;
input          reg2dp_ew_alu_src;
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
input          reg2dp_nan_to_zero;
input          reg2dp_perf_lut_en;
input    [1:0] reg2dp_proc_precision;
//&Ports /^cfg/;
input   [31:0] pwrbus_ram_pd;
input          op_en_load;
reg      [1:0] cfg_ew_alu_algo;
reg            cfg_ew_alu_bypass;
reg            cfg_ew_alu_cvt_bypass;
reg     [31:0] cfg_ew_alu_cvt_offset;
reg     [15:0] cfg_ew_alu_cvt_scale;
reg      [5:0] cfg_ew_alu_cvt_truncate;
reg     [31:0] cfg_ew_alu_operand;
reg            cfg_ew_alu_src;
reg            cfg_ew_lut_bypass;
reg            cfg_ew_mul_bypass;
reg            cfg_ew_mul_cvt_bypass;
reg     [31:0] cfg_ew_mul_cvt_offset;
reg     [15:0] cfg_ew_mul_cvt_scale;
reg      [5:0] cfg_ew_mul_cvt_truncate;
reg     [31:0] cfg_ew_mul_operand;
reg            cfg_ew_mul_prelu;
reg            cfg_ew_mul_src;
reg      [9:0] cfg_ew_truncate;
#ifdef NVDLA_SDP_LUT_ENABLE
reg            cfg_lut_hybrid_priority;
reg     [31:0] cfg_lut_le_end;
reg            cfg_lut_le_function;
reg      [7:0] cfg_lut_le_index_offset;
reg      [7:0] cfg_lut_le_index_select;
reg     [15:0] cfg_lut_le_slope_oflow_scale;
reg      [4:0] cfg_lut_le_slope_oflow_shift;
reg     [15:0] cfg_lut_le_slope_uflow_scale;
reg      [4:0] cfg_lut_le_slope_uflow_shift;
reg     [31:0] cfg_lut_le_start;
reg     [31:0] cfg_lut_lo_end;
reg      [7:0] cfg_lut_lo_index_select;
reg     [15:0] cfg_lut_lo_slope_oflow_scale;
reg      [4:0] cfg_lut_lo_slope_oflow_shift;
reg     [15:0] cfg_lut_lo_slope_uflow_scale;
reg      [4:0] cfg_lut_lo_slope_uflow_shift;
reg     [31:0] cfg_lut_lo_start;
reg            cfg_lut_oflow_priority;
reg            cfg_lut_uflow_priority;
#endif
reg            cfg_nan_to_zero;
reg      [1:0] cfg_proc_precision;
wire   [EW_OC_DW-1:0] alu_cvt_out_pd;
wire           alu_cvt_out_prdy;
wire           alu_cvt_out_pvld;
wire   [EW_OC_DW-1:0] mul_cvt_out_pd;
wire           mul_cvt_out_prdy;
wire           mul_cvt_out_pvld;
wire   [EW_CORE_OUT_DW-1:0] core_out_pd;
wire           core_out_prdy;
wire           core_out_pvld;

#ifdef NVDLA_SDP_LUT_ENABLE
wire   [EW_IDX_OUT_DW-1:0] idx2lut_pd;
wire           idx2lut_prdy;
wire           idx2lut_pvld;
wire   [EW_CORE_OUT_DW-1:0] idx_in_pd;
wire           idx_in_prdy;
wire           idx_in_pvld;
wire   [EW_INP_OUT_DW-1:0] inp_out_pd;
wire           inp_out_prdy;
wire           inp_out_pvld;
wire   [EW_LUT_OUT_DW-1:0] lut2inp_pd;
wire           lut2inp_prdy;
wire           lut2inp_pvld;
#endif
    

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_proc_precision <= {2{1'b0}};
    cfg_nan_to_zero <= 1'b0;
    cfg_ew_alu_operand <= {32{1'b0}};
    cfg_ew_alu_bypass <= 1'b0;
    cfg_ew_alu_algo <= {2{1'b0}};
    cfg_ew_alu_src <= 1'b0;
    cfg_ew_alu_cvt_bypass <= 1'b0;
    cfg_ew_alu_cvt_offset <= {32{1'b0}};
    cfg_ew_alu_cvt_scale <= {16{1'b0}};
    cfg_ew_alu_cvt_truncate <= {6{1'b0}};
    cfg_ew_mul_operand <= {32{1'b0}};
    cfg_ew_mul_bypass <= 1'b0;
    cfg_ew_mul_src <= 1'b0;
    cfg_ew_mul_cvt_bypass <= 1'b0;
    cfg_ew_mul_cvt_offset <= {32{1'b0}};
    cfg_ew_mul_cvt_scale <= {16{1'b0}};
    cfg_ew_mul_cvt_truncate <= {6{1'b0}};
    cfg_ew_truncate <= {10{1'b0}};
    cfg_ew_mul_prelu <= 1'b0;
#ifdef NVDLA_SDP_LUT_ENABLE
    cfg_ew_lut_bypass <= 1'b0;
    cfg_lut_le_start <= {32{1'b0}};
    cfg_lut_le_end <= {32{1'b0}};
    cfg_lut_lo_start <= {32{1'b0}};
    cfg_lut_lo_end <= {32{1'b0}};
    cfg_lut_le_index_offset <= {8{1'b0}};
    cfg_lut_le_index_select <= {8{1'b0}};
    cfg_lut_lo_index_select <= {8{1'b0}};
    cfg_lut_le_function <= 1'b0;
    cfg_lut_uflow_priority <= 1'b0;
    cfg_lut_oflow_priority <= 1'b0;
    cfg_lut_hybrid_priority <= 1'b0;
    cfg_lut_le_slope_oflow_scale <= {16{1'b0}};
    cfg_lut_le_slope_oflow_shift <= {5{1'b0}};
    cfg_lut_le_slope_uflow_scale <= {16{1'b0}};
    cfg_lut_le_slope_uflow_shift <= {5{1'b0}};
    cfg_lut_lo_slope_oflow_scale <= {16{1'b0}};
    cfg_lut_lo_slope_oflow_shift <= {5{1'b0}};
    cfg_lut_lo_slope_uflow_scale <= {16{1'b0}};
    cfg_lut_lo_slope_uflow_shift <= {5{1'b0}};
#else
    cfg_ew_lut_bypass <= 1'b1;
#endif                  
  end else begin
    if (op_en_load) begin
        cfg_proc_precision      <= reg2dp_proc_precision     ;
        cfg_nan_to_zero         <= reg2dp_nan_to_zero        ;
        cfg_ew_alu_operand      <= reg2dp_ew_alu_operand     ;
        cfg_ew_alu_bypass       <= reg2dp_ew_alu_bypass      ;
        cfg_ew_alu_algo         <= reg2dp_ew_alu_algo        ;
        cfg_ew_alu_src          <= reg2dp_ew_alu_src         ;
        cfg_ew_alu_cvt_bypass   <= reg2dp_ew_alu_cvt_bypass  ;
        cfg_ew_alu_cvt_offset   <= reg2dp_ew_alu_cvt_offset  ;
        cfg_ew_alu_cvt_scale    <= reg2dp_ew_alu_cvt_scale   ;
        cfg_ew_alu_cvt_truncate <= reg2dp_ew_alu_cvt_truncate;
        cfg_ew_mul_operand      <= reg2dp_ew_mul_operand     ;
        cfg_ew_mul_bypass       <= reg2dp_ew_mul_bypass      ;
        cfg_ew_mul_src          <= reg2dp_ew_mul_src         ;
        cfg_ew_mul_cvt_bypass   <= reg2dp_ew_mul_cvt_bypass  ;
        cfg_ew_mul_cvt_offset   <= reg2dp_ew_mul_cvt_offset  ;
        cfg_ew_mul_cvt_scale    <= reg2dp_ew_mul_cvt_scale   ;
        cfg_ew_mul_cvt_truncate <= reg2dp_ew_mul_cvt_truncate;
        cfg_ew_truncate         <= reg2dp_ew_truncate        ;
        cfg_ew_mul_prelu        <= reg2dp_ew_mul_prelu       ;
#ifdef NVDLA_SDP_LUT_ENABLE
        cfg_ew_lut_bypass       <= reg2dp_ew_lut_bypass      ;
        cfg_lut_le_start        <= reg2dp_lut_le_start       ;      
        cfg_lut_le_end          <= reg2dp_lut_le_end         ;
        cfg_lut_lo_start        <= reg2dp_lut_lo_start       ;
        cfg_lut_lo_end          <= reg2dp_lut_lo_end         ;
        cfg_lut_le_index_offset <= reg2dp_lut_le_index_offset;
        cfg_lut_le_index_select <= reg2dp_lut_le_index_select;
        cfg_lut_lo_index_select <= reg2dp_lut_lo_index_select;
        cfg_lut_le_function     <= reg2dp_lut_le_function    ;
        cfg_lut_uflow_priority  <= reg2dp_lut_uflow_priority ;
        cfg_lut_oflow_priority  <= reg2dp_lut_oflow_priority ;
        cfg_lut_hybrid_priority <= reg2dp_lut_hybrid_priority;

        cfg_lut_le_slope_oflow_scale <= reg2dp_lut_le_slope_oflow_scale;
        cfg_lut_le_slope_oflow_shift <= reg2dp_lut_le_slope_oflow_shift;
        cfg_lut_le_slope_uflow_scale <= reg2dp_lut_le_slope_uflow_scale;
        cfg_lut_le_slope_uflow_shift <= reg2dp_lut_le_slope_uflow_shift;

        cfg_lut_lo_slope_oflow_scale <= reg2dp_lut_lo_slope_oflow_scale;
        cfg_lut_lo_slope_oflow_shift <= reg2dp_lut_lo_slope_oflow_shift;
        cfg_lut_lo_slope_uflow_scale <= reg2dp_lut_lo_slope_uflow_scale;
        cfg_lut_lo_slope_uflow_shift <= reg2dp_lut_lo_slope_uflow_shift;
#else
        cfg_ew_lut_bypass <= 1'b1;
#endif                  
    end
  end
end
 
//===========================================
// y input pipe
//===========================================

//=================================================
NV_NVDLA_SDP_HLS_Y_cvt_top u_alu_cvt (
   .cfg_cvt_bypass                  (cfg_ew_alu_cvt_bypass)              //|< r
  ,.cfg_cvt_offset                  (cfg_ew_alu_cvt_offset[31:0])        //|< r
  ,.cfg_cvt_scale                   (cfg_ew_alu_cvt_scale[15:0])         //|< r
  ,.cfg_cvt_truncate                (cfg_ew_alu_cvt_truncate[5:0])       //|< r
  ,.cvt_data_in                     (ew_alu_in_data[EW_OP_DW-1:0])       //|< w
  ,.cvt_in_pvld                     (ew_alu_in_vld)                      //|< w
  ,.cvt_in_prdy                     (ew_alu_in_rdy)                      //|> w
  ,.cvt_out_prdy                    (alu_cvt_out_prdy)                   //|< w
  ,.cvt_data_out                    (alu_cvt_out_pd[EW_OC_DW-1:0])       //|> w
  ,.cvt_out_pvld                    (alu_cvt_out_pvld)                   //|> w
  ,.nvdla_core_clk                  (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                    //|< i
  );


NV_NVDLA_SDP_HLS_Y_cvt_top u_mul_cvt (
   .cfg_cvt_bypass                  (cfg_ew_mul_cvt_bypass)              //|< r
  ,.cfg_cvt_offset                  (cfg_ew_mul_cvt_offset[31:0])        //|< r
  ,.cfg_cvt_scale                   (cfg_ew_mul_cvt_scale[15:0])         //|< r
  ,.cfg_cvt_truncate                (cfg_ew_mul_cvt_truncate[5:0])       //|< r
  ,.cvt_data_in                     (ew_mul_in_data[EW_OP_DW-1:0])       //|< w
  ,.cvt_in_pvld                     (ew_mul_in_vld)                      //|< w
  ,.cvt_in_prdy                     (ew_mul_in_rdy)                      //|> w
  ,.cvt_out_prdy                    (mul_cvt_out_prdy)                   //|< w
  ,.cvt_data_out                    (mul_cvt_out_pd[EW_OC_DW-1:0])       //|> w
  ,.cvt_out_pvld                    (mul_cvt_out_pvld)                   //|> w
  ,.nvdla_core_clk                  (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                    //|< i
  );


NV_NVDLA_SDP_HLS_Y_int_core u_core (
   .cfg_alu_algo                    (cfg_ew_alu_algo[1:0])               //|< r
  ,.cfg_alu_bypass                  (cfg_ew_alu_bypass)                  //|< r
  ,.cfg_alu_op                      (cfg_ew_alu_operand[31:0])           //|< r
  ,.cfg_alu_src                     (cfg_ew_alu_src)                     //|< r
  ,.cfg_mul_bypass                  (cfg_ew_mul_bypass)                  //|< r
  ,.cfg_mul_op                      (cfg_ew_mul_operand[31:0])           //|< r
  ,.cfg_mul_prelu                   (cfg_ew_mul_prelu)                   //|< r
  ,.cfg_mul_src                     (cfg_ew_mul_src)                     //|< r
  ,.cfg_mul_truncate                (cfg_ew_truncate[9:0])               //|< r
  ,.chn_alu_op                      (alu_cvt_out_pd[EW_OC_DW-1:0])       //|< w
  ,.chn_alu_op_pvld                 (alu_cvt_out_pvld)                   //|< w
  ,.chn_data_in                     (ew_data_in_pd[EW_IN_DW-1:0])   //|< w
  ,.chn_in_pvld                     (ew_data_in_pvld)               //|< w
  ,.chn_in_prdy                     (ew_data_in_prdy)               //|> w
  ,.chn_mul_op                      (mul_cvt_out_pd[EW_OC_DW-1:0])       //|< w
  ,.chn_mul_op_pvld                 (mul_cvt_out_pvld)                   //|< w
  ,.chn_alu_op_prdy                 (alu_cvt_out_prdy)                   //|> w
  ,.chn_mul_op_prdy                 (mul_cvt_out_prdy)                   //|> w
  ,.chn_data_out                    (core_out_pd[EW_CORE_OUT_DW-1:0])    //|> w
  ,.chn_out_pvld                    (core_out_pvld)                      //|> w
  ,.chn_out_prdy                    (core_out_prdy)                      //|< w
  ,.nvdla_core_clk                  (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                    //|< i
  );


#ifdef NVDLA_SDP_LUT_ENABLE
assign core_out_prdy = cfg_ew_lut_bypass ? ew_data_out_prdy : idx_in_prdy;
#else 
assign core_out_prdy = ew_data_out_prdy;
#endif

#ifdef NVDLA_SDP_LUT_ENABLE
assign idx_in_pvld = cfg_ew_lut_bypass ? 1'b0 : core_out_pvld;
assign idx_in_pd   =  {EW_CORE_OUT_DW{idx_in_pvld}} & core_out_pd;

NV_NVDLA_SDP_HLS_Y_idx_top u_idx (
   .cfg_lut_hybrid_priority         (cfg_lut_hybrid_priority)            //|< r
  ,.cfg_lut_le_function             (cfg_lut_le_function)                //|< r
  ,.cfg_lut_le_index_offset         (cfg_lut_le_index_offset[7:0])       //|< r
  ,.cfg_lut_le_index_select         (cfg_lut_le_index_select[7:0])       //|< r
  ,.cfg_lut_le_start                (cfg_lut_le_start[31:0])             //|< r
  ,.cfg_lut_lo_index_select         (cfg_lut_lo_index_select[7:0])       //|< r
  ,.cfg_lut_lo_start                (cfg_lut_lo_start[31:0])             //|< r
  ,.cfg_lut_oflow_priority          (cfg_lut_oflow_priority)             //|< r
  ,.cfg_lut_uflow_priority          (cfg_lut_uflow_priority)             //|< r
  ,.chn_lut_in_pd                   (idx_in_pd[EW_CORE_OUT_DW-1:0])      //|< w
  ,.chn_lut_in_pvld                 (idx_in_pvld)                        //|< w
  ,.chn_lut_out_prdy                (idx2lut_prdy)                       //|< w
  ,.chn_lut_in_prdy                 (idx_in_prdy)                        //|> w
  ,.chn_lut_out_pd                  (idx2lut_pd[EW_IDX_OUT_DW-1:0])      //|> w
  ,.chn_lut_out_pvld                (idx2lut_pvld)                       //|> w
  ,.nvdla_core_clk                  (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                    //|< i
  );


NV_NVDLA_SDP_CORE_Y_lut u_lut (
   .nvdla_core_clk                  (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                    //|< i
  ,.lut2inp_pvld                    (lut2inp_pvld)                       //|> w
  ,.lut2inp_prdy                    (lut2inp_prdy)                       //|< w
  ,.lut2inp_pd                      (lut2inp_pd[EW_LUT_OUT_DW-1:0])      //|> w
  ,.idx2lut_pvld                    (idx2lut_pvld)                       //|< w
  ,.idx2lut_prdy                    (idx2lut_prdy)                       //|> w
  ,.idx2lut_pd                      (idx2lut_pd[EW_IDX_OUT_DW-1:0])      //|< w
  ,.reg2dp_lut_int_access_type      (reg2dp_lut_int_access_type)         //|< i
  ,.reg2dp_lut_int_addr             (reg2dp_lut_int_addr[9:0])           //|< i
  ,.reg2dp_lut_int_data             (reg2dp_lut_int_data[15:0])          //|< i
  ,.reg2dp_lut_int_data_wr          (reg2dp_lut_int_data_wr)             //|< i
  ,.reg2dp_lut_int_table_id         (reg2dp_lut_int_table_id)            //|< i
  ,.reg2dp_lut_le_end               (cfg_lut_le_end[31:0])               //|< r
  ,.reg2dp_lut_le_function          (reg2dp_lut_le_function)             //|< i
  ,.reg2dp_lut_le_index_offset      (reg2dp_lut_le_index_offset[7:0])    //|< i
  ,.reg2dp_lut_le_slope_oflow_scale (cfg_lut_le_slope_oflow_scale[15:0]) //|< r
  ,.reg2dp_lut_le_slope_oflow_shift (cfg_lut_le_slope_oflow_shift[4:0])  //|< r
  ,.reg2dp_lut_le_slope_uflow_scale (cfg_lut_le_slope_uflow_scale[15:0]) //|< r
  ,.reg2dp_lut_le_slope_uflow_shift (cfg_lut_le_slope_uflow_shift[4:0])  //|< r
  ,.reg2dp_lut_le_start             (cfg_lut_le_start[31:0])             //|< r
  ,.reg2dp_lut_lo_end               (cfg_lut_lo_end[31:0])               //|< r
  ,.reg2dp_lut_lo_slope_oflow_scale (cfg_lut_lo_slope_oflow_scale[15:0]) //|< r
  ,.reg2dp_lut_lo_slope_oflow_shift (cfg_lut_lo_slope_oflow_shift[4:0])  //|< r
  ,.reg2dp_lut_lo_slope_uflow_scale (cfg_lut_lo_slope_uflow_scale[15:0]) //|< r
  ,.reg2dp_lut_lo_slope_uflow_shift (cfg_lut_lo_slope_uflow_shift[4:0])  //|< r
  ,.reg2dp_lut_lo_start             (cfg_lut_lo_start[31:0])             //|< r
  ,.reg2dp_perf_lut_en              (reg2dp_perf_lut_en)                 //|< i
  ,.reg2dp_proc_precision           (reg2dp_proc_precision[1:0])         //|< i
  ,.dp2reg_lut_hybrid               (dp2reg_lut_hybrid[31:0])            //|> o
  ,.dp2reg_lut_int_data             (dp2reg_lut_int_data[15:0])          //|> o
  ,.dp2reg_lut_le_hit               (dp2reg_lut_le_hit[31:0])            //|> o
  ,.dp2reg_lut_lo_hit               (dp2reg_lut_lo_hit[31:0])            //|> o
  ,.dp2reg_lut_oflow                (dp2reg_lut_oflow[31:0])             //|> o
  ,.dp2reg_lut_uflow                (dp2reg_lut_uflow[31:0])             //|> o
  ,.pwrbus_ram_pd                   (pwrbus_ram_pd[31:0])                //|< i
  ,.op_en_load                      (op_en_load)                         //|< i
  );

NV_NVDLA_SDP_HLS_Y_inp_top u_inp (
   .chn_inp_in_pd                   (lut2inp_pd[EW_LUT_OUT_DW-1:0])      //|< w
  ,.chn_inp_in_pvld                 (lut2inp_pvld)                       //|< w
  ,.chn_inp_out_prdy                (inp_out_prdy)                       //|< w
  ,.chn_inp_in_prdy                 (lut2inp_prdy)                       //|> w
  ,.chn_inp_out_pd                  (inp_out_pd[EW_INP_OUT_DW-1:0])      //|> w
  ,.chn_inp_out_pvld                (inp_out_pvld)                       //|> w
  ,.nvdla_core_clk                  (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                    //|< i
  );


assign ew_data_out_pvld = cfg_ew_lut_bypass ? core_out_pvld : inp_out_pvld;
assign ew_data_out_pd   = cfg_ew_lut_bypass ? core_out_pd   : inp_out_pd;
assign inp_out_prdy     = cfg_ew_lut_bypass ? 1'b0 : ew_data_out_prdy;

#else
assign ew_data_out_pvld = core_out_pvld; 
assign ew_data_out_pd   = core_out_pd;   
#endif


endmodule // NV_NVDLA_SDP_CORE_y

