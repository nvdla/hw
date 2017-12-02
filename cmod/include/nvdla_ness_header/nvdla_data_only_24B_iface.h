// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_data_only_24B_iface.h

#if !defined(_nvdla_data_only_24B_iface_H_)
#define _nvdla_data_only_24B_iface_H_

#include <stdint.h>

typedef struct nvdla_data_only_24B_s {
    uint64_t data [3] ; 
    uint8_t sync ; 
} nvdla_data_only_24B_t;

#endif // !defined(_nvdla_data_only_24B_iface_H_)
