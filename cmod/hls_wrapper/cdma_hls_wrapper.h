// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdma_hls_wrapper.h

#ifndef _CDP_HLS_WRAPPER_H_
#define _CDP_HLS_WRAPPER_H_

#define PIXEL_UNSIGNED_INT8     0
#define PIXEL_SIGNED_INT8       1
#define PIXEL_UNSIGNED_INT16    2
#define PIXEL_SIGNED_INT16      3
#define PIXEL_FP16              4

void cdma_cvt_hls (
    int16_t  *cdma_cvt_data_in,      // 16bits
    uint8_t   input_data_type,
    uint16_t  cdma_cvt_alu_in,       // 16bits
    uint16_t  cdma_cvt_mul_in,       // 16bits
    uint8_t   cdma_cvt_in_precission,
    uint8_t   cdma_cvt_out_precission,
    uint8_t   cdma_cvt_truncate,
    int32_t  *cdma_cvt_data_out);

#endif
