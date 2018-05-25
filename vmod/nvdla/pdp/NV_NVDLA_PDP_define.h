// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_define.h

#define NVDLA_PDP_BWPE NVDLA_BPE
#define NVDLA_PDP_DMAIF_BW NVDLA_MEMIF_WIDTH

#define SDP_THROUGHPUT NVDLA_SDP_MAX_THROUGHPUT

#define NVDLA_PDP_ONFLY_INPUT_BW    NVDLA_PDP_BWPE*SDP_THROUGHPUT
/////////////////////////////////////////////////////////////
#define NVDLA_PDP_MEM_MASK_NUM  (NVDLA_PDP_DMAIF_BW/NVDLA_PDP_BWPE/NVDLA_MEMORY_ATOMIC_SIZE)
#define NVDLA_PDP_MEM_MASK_BIT NVDLA_PDP_MEM_MASK_NUM

#define NVDLA_PDP_MEM_RD_RSP  ( NVDLA_PDP_DMAIF_BW + NVDLA_PDP_MEM_MASK_BIT )
#define NVDLA_PDP_MEM_WR_REQ  ( NVDLA_PDP_DMAIF_BW + NVDLA_PDP_MEM_MASK_BIT + 1 )
#define NVDLA_PDP_MEM_RD_REQ  ( NVDLA_MEM_ADDRESS_WIDTH + 15 )
/////////////////////////////////////////////////////////////

//#ifdef NVDLA_FEATURE_DATA_TYPE_INT8
//#if ( NVDLA_PDP_THROUGHPUT  ==  8 )
//    #define LARGE_FIFO_RAM
//#endif
//#if ( NVDLA_PDP_THROUGHPUT == 1 )
//    #define SMALL_FIFO_RAM
//#endif
//#endif
