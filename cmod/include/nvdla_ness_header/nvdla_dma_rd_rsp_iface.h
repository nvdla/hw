// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_dma_rd_rsp_iface.h

#if !defined(_nvdla_dma_rd_rsp_iface_H_)
#define _nvdla_dma_rd_rsp_iface_H_

#include <stdint.h>
#ifndef _dma_read_data_struct_H_
#define _dma_read_data_struct_H_

typedef struct dma_read_data_s {
    uint64_t data [8] ; //used int byte unit
    uint8_t mask ; 
} dma_read_data_t;

#endif

union nvdla_dma_rd_rsp_u {
    dma_read_data_t dma_read_data;
};
typedef struct nvdla_dma_rd_rsp_s {
    union nvdla_dma_rd_rsp_u pd ; 
} nvdla_dma_rd_rsp_t;

#endif // !defined(_nvdla_dma_rd_rsp_iface_H_)
