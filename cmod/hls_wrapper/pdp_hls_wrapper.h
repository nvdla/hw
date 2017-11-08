// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: pdp_hls_wrapper.h

#ifndef _PDP_HLS_WRAPPER_
#define _PDP_HLS_WRAPPER_

void HLS_PDP_PoolingStage0Calc_FP16_W(
    bool        is_first_element,
    uint32_t    padding_value_left,
    uint32_t    padding_value_right,
    uint8_t     pdp_pooling_method_,
    uint32_t    des_element_idx,
    uint32_t*   line_buffer_ptr,
    uint32_t    src_element_idx,
    uint16_t*   atomic_data_in
    );

void HLS_PDP_PoolingStage0Calc_FP16_H(
    bool        is_first_element,
    uint32_t    padding_value_top,
    uint32_t    padding_value_bottom,
    uint32_t    kernel_width,
    uint8_t     pdp_pooling_method_,
    uint32_t    des_element_idx,
    uint32_t*   line_buffer_ptr,
    uint32_t    src_element_idx,
    uint32_t*   atomic_data_in
    );


void HLS_PDP_PoolingStage1Calc_FP16(
    uint8_t     pdp_pooling_method_,
    uint32_t    recip_kernel_width,
    uint32_t    recip_kernel_height,
    uint32_t    des_element_idx,
    uint16_t*   atomic_data_out,
    uint32_t    src_element_idx,
    uint32_t*   line_buffer_ptr
    );

#endif
