// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_ram_rd_data_128B_iface.h

#if !defined(_nvdla_ram_rd_data_128B_iface_H_)
#define _nvdla_ram_rd_data_128B_iface_H_

#include <stdint.h>

typedef struct nvdla_ram_rd_data_128B_s {
    uint64_t data [16] ; 
} nvdla_ram_rd_data_128B_t;

#endif // !defined(_nvdla_ram_rd_data_128B_iface_H_)
