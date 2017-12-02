// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_ram_addr_ADDR_WIDTH_12_BE_1_iface.h

#if !defined(_nvdla_ram_addr_ADDR_WIDTH_12_BE_1_iface_H_)
#define _nvdla_ram_addr_ADDR_WIDTH_12_BE_1_iface_H_

#include <stdint.h>

typedef struct nvdla_ram_addr_ADDR_WIDTH_12_BE_1_s {
    uint16_t addr ; 
    uint8_t hsel ; 
} nvdla_ram_addr_ADDR_WIDTH_12_BE_1_t;

#endif // !defined(_nvdla_ram_addr_ADDR_WIDTH_12_BE_1_iface_H_)
