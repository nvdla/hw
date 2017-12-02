// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_dat_info_update_iface.h

#if !defined(_nvdla_dat_info_update_iface_H_)
#define _nvdla_dat_info_update_iface_H_

#include <stdint.h>

typedef struct nvdla_dat_info_update_s {
    uint16_t dat_entries ; 
    uint16_t dat_slices ; 
} nvdla_dat_info_update_t;

#endif // !defined(_nvdla_dat_info_update_iface_H_)
