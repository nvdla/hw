// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_iface.h

#if !defined(_nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_iface_H_)
#define _nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_iface_H_

#include "nvdla_ram_addr_ADDR_WIDTH_12_BE_1_iface.h"
#include "nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_iface.h"

typedef struct nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_s {
    nvdla_ram_addr_ADDR_WIDTH_12_BE_1_t nvdla_ram_addr_ADDR_WIDTH_12_BE_1;
    nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_t nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1;
} nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t;
#endif // !defined(_nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_iface_H_)
