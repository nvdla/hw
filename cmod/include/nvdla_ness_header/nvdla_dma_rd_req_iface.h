// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_dma_rd_req_iface.h

#if !defined(_nvdla_dma_rd_req_iface_H_)
#define _nvdla_dma_rd_req_iface_H_

#include <stdint.h>
#ifndef _dma_read_cmd_struct_H_
#define _dma_read_cmd_struct_H_

typedef struct dma_read_cmd_s {
    uint64_t addr ; 
    uint16_t size ; 
} dma_read_cmd_t;

#endif

union nvdla_dma_rd_req_u {
    dma_read_cmd_t dma_read_cmd;
};
typedef struct nvdla_dma_rd_req_s {
    union nvdla_dma_rd_req_u pd ; 
} nvdla_dma_rd_req_t;

#endif // !defined(_nvdla_dma_rd_req_iface_H_)
