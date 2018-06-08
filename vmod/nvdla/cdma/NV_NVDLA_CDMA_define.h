// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_define.h

#ifndef _NV_NVDLA_CDMA_DEFINE_H_
#define _NV_NVDLA_CDMA_DEFINE_H_

#define CDMA_CBUF_WR_LATENCY            3
#define NVDLA_HLS_CDMA_CVT_LATENCY 3

//#define CDMA_SBUF_SDATA_BITS            256
#define CDMA_SBUF_SDATA_BITS            NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE
#define CDMA_SBUF_DEPTH                 256
#define CDMA_SBUF_NUMBER                16
#define CDMA_SBUF_RD_LATENCY            2
#define CDMA_SBUF_WR_LATENCY            3

#define CDMA_CVT_CELL_LATENCY           NVDLA_HLS_CDMA_CVT_LATENCY
#define CDMA_CVT_LATENCY                CDMA_CVT_CELL_LATENCY + 3
#define CDMA_STATUS_LATENCY             (CDMA_CBUF_WR_LATENCY + CDMA_CVT_LATENCY)

#ifdef NVDLA_WINOGRAD_ENABLE
    #define SBUF_WINOGRAD 1
#else
    #define SBUF_WINOGRAD 0
#endif

//DorisL-S----------------
#define NVDLA_CDMA_BPE NVDLA_BPE
#define NVDLA_CDMA_DMAIF_BW NVDLA_MEMIF_WIDTH
#define NVDLA_CDMA_MEM_MASK_BIT  (NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE/NVDLA_MEMORY_ATOMIC_SIZE)

#define NVDLA_CDMA_MEM_RD_RSP  ( NVDLA_CDMA_DMAIF_BW + NVDLA_CDMA_MEM_MASK_BIT )
#define NVDLA_CDMA_MEM_WR_REQ  ( NVDLA_CDMA_DMAIF_BW + NVDLA_CDMA_MEM_MASK_BIT + 1 )
#define NVDLA_CDMA_MEM_RD_REQ  ( NVDLA_MEM_ADDRESS_WIDTH + 15 )

#define CBUF_WR_BANK_ADDR_BITS  9 
#define CDMA_GRAIN_MAX_BIT      NVDLA_CDMA_GRAIN_MAX_BIT

//
// #if ( NVDLA_MEMORY_ATOMIC_SIZE  ==  32 )
//     #define IMG_LARGE
// #endif
// #if ( NVDLA_MEMORY_ATOMIC_SIZE == 8 )
//     #define IMG_SMALL
// #endif
//DorisL-E----------------
//--------------------------------------------------
#endif

