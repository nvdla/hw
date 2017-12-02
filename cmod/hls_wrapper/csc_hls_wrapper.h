// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: csc_hls_wrapper.h

#ifndef _PDP_HLS_WRAPPER_
#define _PDP_HLS_WRAPPER_

void csc_pra_hls (
    uint16_t  *csc_pra_data_in,         // 16bits
    uint8_t    csc_pra_precision,
    uint8_t    csc_pra_pra_truncate,
    int16_t  *csc_pra_data_out);

#endif
