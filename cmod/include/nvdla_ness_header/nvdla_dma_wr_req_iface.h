// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_dma_wr_req_iface.h

#if !defined(_nvdla_dma_wr_req_iface_H_)
#define _nvdla_dma_wr_req_iface_H_

#include <stdint.h>
#ifndef _dma_write_cmd_struct_H_
#define _dma_write_cmd_struct_H_

#define DMA_WRITE_CMD_REQUIRE_ACK_NO    0
#define DMA_WRITE_CMD_REQUIRE_ACK_YES   1
typedef struct dma_write_cmd_s {
    uint64_t addr ; 
    uint16_t size ; 
    // uint8_t stream_id_ptr ; 
    uint8_t require_ack ; 
} dma_write_cmd_t;

#endif
#ifndef _dma_write_data_struct_H_
#define _dma_write_data_struct_H_

typedef struct dma_write_data_s {
    uint64_t data [8] ; //used in byte unit 
} dma_write_data_t;

#endif

#define TAG_CMD     0
#define TAG_DATA    1
union nvdla_dma_wr_req_u {
    dma_write_cmd_t dma_write_cmd;
    dma_write_data_t dma_write_data;
};
typedef struct nvdla_dma_wr_req_s {
    union   nvdla_dma_wr_req_u pd ; 
    uint8_t tag;
} nvdla_dma_wr_req_t;

#endif // !defined(_nvdla_dma_wr_req_iface_H_)
