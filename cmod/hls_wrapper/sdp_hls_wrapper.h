// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_hls_wrapper.h

#ifndef _SDP_HLS_WRAPPER_H_
#define _SDP_HLS_WRAPPER_H_
//#include <mc_scverify.h>
#include "ac_int.h"
#include "ac_channel.h"

#include "sdp.h"
#include "nvdla_config.h"

#define HLS_TRACE        "HLS_API"

#define LE_TBL_ENTRY 65
#define LO_TBL_ENTRY 257
#define SDP_PARALLEL_PROC_NUM               (SDP_MAX_THROUGHPUT)

#define HLS_MAX_THROUGHPUT  16

#if SDP_PARALLEL_PROC_NUM > HLS_MAX_THROUGHPUT
#error "SDP throughput shoudldn't be larger than 16"
#endif

class sdp_hls_wrapper{
public:
    sdp_hls_wrapper();
    ~sdp_hls_wrapper();

public:
//    uint32_t read_lut(bool is_access_raw, uint32_t addr);
//    void write_lut(bool is_access_raw, uint32_t addr, uint32_t value);

//    void lookup_lut(bool cdp_data_in_valid, uint16_t data0, uint16_t data1, uint16_t data2, uint16_t data3, 
//            uint32_t cdp_width_cnt, uint32_t cdp_channel_cnt, bool cdp_channel_last);
    void sdp(int32_t *data_in,
            int16_t *x1_alu_op, int16_t *x1_mul_op,
            int16_t *x2_alu_op, int16_t *x2_mul_op,
            int16_t *y_alu_op,  int16_t *y_mul_op);
    void sdp_x(bool is_x1, int32_t *data_in, int16_t *alu_op, int16_t *mul_op, int32_t *sdp_data);
    void sdp_y(int32_t *sdp_data_in, int16_t *sdp_alu_op, int16_t *sdp_mul_op, int32_t *sdp_data_out);
    void sdp_c(ac_channel<cDataInStruct> & chn_in);
    uint16_t read_lut(uint32_t tbl_id, uint32_t addr);
    void write_lut(uint32_t tbl_id, uint32_t addr, uint16_t val);
    void reset_stats_regs();

public:
    // For ALL
    uint8_t   sdp_cfg_proc_precision;
    uint8_t   sdp_cfg_out_precision;
    bool      sdp_cfg_nan_to_zero;
    
    // For SDP_X
    bool      sdp_cfg_x1_bypass;
    int16_t   sdp_cfg_x1_mul_op;
    int16_t   sdp_cfg_x1_alu_op;
    bool      sdp_cfg_x1_alu_bypass;   // 0:no ; 1:yes
    uint8_t   sdp_cfg_x1_alu_algo;     // 0:max; 1:min; 2:sum
    bool      sdp_cfg_x1_alu_src;      // 0:reg; 1:dma
    uint8_t   sdp_cfg_x1_alu_shift_value;
    bool      sdp_cfg_x1_mul_bypass;   //0:no ; 1:yes
    bool      sdp_cfg_x1_mul_src;      //0:reg; 1:dma
    bool      sdp_cfg_x1_mul_prelu;
    uint8_t   sdp_cfg_x1_mul_shift_value;
    bool      sdp_cfg_x1_relu_bypass;  // 0:no; 1:yes

    // For SDP_X
    bool      sdp_cfg_x2_bypass;
    int16_t  sdp_cfg_x2_mul_op;
    int16_t  sdp_cfg_x2_alu_op;
    bool      sdp_cfg_x2_alu_bypass;   // 0:no ; 1:yes
    uint8_t   sdp_cfg_x2_alu_algo;     // 0:max; 1:min; 2:sum
    bool      sdp_cfg_x2_alu_src;      // 0:reg; 1:dma
    uint8_t   sdp_cfg_x2_alu_shift_value;
    bool      sdp_cfg_x2_mul_bypass;   //0:no ; 1:yes
    bool      sdp_cfg_x2_mul_src;      //0:reg; 1:dma
    bool      sdp_cfg_x2_mul_prelu;
    uint8_t   sdp_cfg_x2_mul_shift_value;
    bool      sdp_cfg_x2_relu_bypass;  // 0:no; 1:yes

    // For SDP_Y
    bool      sdp_cfg_y_bypass;
    int32_t   sdp_cfg_y_alu_op;
    bool      sdp_cfg_y_alu_bypass;   // 0:no ; 1:yes
    uint8_t   sdp_cfg_y_alu_algo;     // 0:max; 1:min; 2:sum
    bool      sdp_cfg_y_alu_src;      // 0:reg; 1:dma
    bool      sdp_cfg_y_alu_cvt_bypass; 
    int32_t   sdp_cfg_y_alu_cvt_offset;
    int16_t   sdp_cfg_y_alu_cvt_scale;
    int16_t   sdp_cfg_y_alu_cvt_truncate;
    int32_t   sdp_cfg_y_mul_op;
    bool      sdp_cfg_y_mul_bypass;   // 0:no ; 1:yes
    bool      sdp_cfg_y_mul_src;      // 0:reg; 1:dma
    bool      sdp_cfg_y_mul_prelu;
    bool      sdp_cfg_y_mul_cvt_bypass;
    int32_t   sdp_cfg_y_mul_cvt_offset;
    int16_t   sdp_cfg_y_mul_cvt_scale;
    int16_t   sdp_cfg_y_mul_cvt_truncate;
    int16_t   sdp_cfg_y_truncate;
    int32_t   sdp_cfg_y_lut_le_function;
    int32_t   sdp_cfg_y_lut_le_start;
    int32_t   sdp_cfg_y_lut_le_end;
    int8_t    sdp_cfg_y_lut_le_index_offset;
    int8_t    sdp_cfg_y_lut_le_index_select;
    int32_t   sdp_cfg_y_lut_lo_start;
    int32_t   sdp_cfg_y_lut_lo_end;
    int8_t    sdp_cfg_y_lut_lo_index_select;
    bool      sdp_cfg_y_lut_bypass;
    bool      sdp_cfg_y_lut_out_sel_hybrid;
    bool      sdp_cfg_y_lut_out_sel_u_miss;
    bool      sdp_cfg_y_lut_out_sel_o_miss;
    ac_channel<xDataOutStruct>  sdp_x_data_out;
    int16_t     sdp_cfg_y_le_uflow_scale;
    int8_t      sdp_cfg_y_le_uflow_shift;
    int16_t     sdp_cfg_y_le_oflow_scale;
    int8_t      sdp_cfg_y_le_oflow_shift;
    int16_t     sdp_cfg_y_lo_uflow_scale;
    int8_t      sdp_cfg_y_lo_uflow_shift;
    int16_t     sdp_cfg_y_lo_oflow_scale;
    int8_t      sdp_cfg_y_lo_oflow_shift;

    bool        sdp_cfg_nan_flush;
    bool        sdp_cfg_perf_nan_inf_cnt_en;
    bool        sdp_cfg_perf_out_nan_cnt_en;

    uint32_t    total_num;
    uint32_t    lut_o_flow;
    uint32_t    lut_u_flow;
    uint32_t    lut_le_hit;
    uint32_t    lut_lo_hit;
    uint32_t    lut_hybrid_hit;
    uint32_t    o_cvt_o_flow;
    uint32_t    o_cvt_u_flow;
    uint32_t    i_nan_cnt;
    uint32_t    i_inf_cnt;
    uint32_t    o_nan_cnt;

    // LUT
    int16_t     le_tbl[LE_TBL_ENTRY];
    int16_t     lo_tbl[LO_TBL_ENTRY];


    // For SDP_C
    int32_t   sdp_cfg_cvt_offset;
    int16_t   sdp_cfg_cvt_scale;
    uint8_t   sdp_cfg_cvt_shift;
    bool      sdp_cfg_mode_eql;

    // Output of SDP HLS
    int16_t  sdp_data_out[SDP_PARALLEL_PROC_NUM];

};

#endif
