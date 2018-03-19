// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_iface.h

#if !defined(_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_iface_H_)
#define _nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_iface_H_

#include <stdint.h>
#include "nvdla_config.h"

typedef struct nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_s {
    uint64_t data [NVDLA_CBUF_BANK_WIDTH / sizeof(uint64_t)] ;
} nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_t;

#endif // !defined(_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_iface_H_)
