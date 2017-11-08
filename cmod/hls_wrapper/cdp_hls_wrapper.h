// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_hls_wrapper.h

#ifndef _CDP_HLS_WRAPPER_H_
#define _CDP_HLS_WRAPPER_H_

void cdp_icvt_hls(
    int16_t  *cdp_icvt_data_in,      // 16bits
    int32_t  cdp_icvt_alu_op,       // 32bits
    int16_t  cdp_icvt_mul_op,       // 16bits
    uint8_t   cdp_icvt_truncate,     // 5bits
    uint8_t   cdp_icvt_precision,
    int32_t  *cdp_icvt_data_out);    // 17bits

void cdp_ocvt_hls(
    int64_t *cdp_ocvt_data_in,      // 17bits
    int32_t  cdp_ocvt_alu_op,       // 32bits
    int16_t  cdp_ocvt_mul_op,       // 16bits
    uint8_t   cdp_ocvt_truncate,     // 5bits
    uint8_t   cdp_ocvt_precision,
    int16_t  *cdp_ocvt_data_out,    // 16bits
    uint8_t *o_flow);

void HLS_CDP_lookup_fp16 (
    int16_t  *data_in,      // 12 * fp17
    int16_t  *le_lut,
    int16_t  *lo_lut,

    // Configurations
    uint16_t normalz_len,
    uint16_t raw_method,
    bool     lut_uflow_priority,
    bool     lut_oflow_priority,
    bool     lut_hybrid_priority,
    uint64_t le_start,
    int16_t  le_index_offset,
    int8_t   le_index_select,
    uint64_t le_end,
    uint64_t lo_start,
    int8_t   lo_index_select,
    uint64_t lo_end,
    uint16_t datin_offset,
    uint16_t datin_scale,
    uint8_t  datin_shifter,
    uint32_t datout_offset,
    uint16_t datout_scale,
    uint8_t  datout_shifter,
    int16_t  le_slope_uflow_scale,
    int16_t  le_slope_oflow_scale,
    int16_t  lo_slope_uflow_scale,
    int16_t  lo_slope_oflow_scale,
    bool     sqsum_bypass,
    bool     mul_bypass,
    int16_t *normalz_out,
    uint32_t *lut_u_flow,
    uint32_t *lut_o_flow,
    uint32_t *lut_le_hit,
    uint32_t *lut_lo_hit,
    uint32_t *lut_hybrid_hit);

#endif
