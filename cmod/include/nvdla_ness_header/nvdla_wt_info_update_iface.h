// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_wt_info_update_iface.h

#if !defined(_nvdla_wt_info_update_iface_H_)
#define _nvdla_wt_info_update_iface_H_

#include <stdint.h>

typedef struct nvdla_wt_info_update_s {
    uint16_t wt_kernels ; 
    uint16_t wt_entries ; 
    uint16_t wmb_entries ; 
} nvdla_wt_info_update_t;

#endif // !defined(_nvdla_wt_info_update_iface_H_)
