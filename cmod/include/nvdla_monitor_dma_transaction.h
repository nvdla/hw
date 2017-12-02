// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_monitor_dma_transaction.h

#if !defined(nvdla_monitor_dma_transaction_H)
#define nvdla_monitor_dma_transaction_H

#define NVDLA_MONITOR_DMA_STATUS_REQUEST    0
#define NVDLA_MONITOR_DMA_STATUS_RESPONSE   1

#include <stdint.h>
#include "nvdla_dma_rd_req_iface.h"
#include "nvdla_dma_rd_rsp_iface.h"
#include "nvdla_dma_wr_req_iface.h"

typedef struct nvdla_monitor_dma_wr_transaction {
    uint8_t             dma_id;
    uint8_t             status; // Request, Response
    nvdla_dma_wr_req_t  req;
} nvdla_monitor_dma_wr_transaction_t;
// } __attribute__((packed)) nvdla_monitor_dma_wr_transaction_t;

// union nvdla_monitor_dma_rd_u {
//     nvdla_dma_rd_req_t  red_req;
//     nvdla_dma_rd_rsp_t  red_rsp;
// };

typedef struct nvdla_monitor_dma_rd_transaction {
    uint8_t             dma_id;
    uint8_t             status; // Request, Response
    // union   nvdla_monitor_dma_rd_u  payload;
    nvdla_dma_rd_req_t  req;
    nvdla_dma_rd_rsp_t  rsp;
} nvdla_monitor_dma_rd_transaction_t;
// } __attribute__((packed)) nvdla_monitor_dma_rd_transaction_t;

#endif // !defined(nvdla_monitor_dma_wr_payload_wrapper_H)
