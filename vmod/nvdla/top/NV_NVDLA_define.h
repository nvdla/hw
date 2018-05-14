// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_define.h

#define NVDLA_DMAIF_BW   NVDLA_MEMIF_WIDTH  

#define MULTI_MASK (NVDLA_DMAIF_BW/NVDLA_BPE/NVDLA_MEMORY_ATOMIC_SIZE)

#define NVDLA_MEM_MASK_BIT MULTI_MASK

#define NVDLA_MEM_RD_RSP  ( NVDLA_DMAIF_BW + NVDLA_MEM_MASK_BIT )
#define NVDLA_MEM_WR_REQ  ( NVDLA_DMAIF_BW + NVDLA_MEM_MASK_BIT + 1 )
#define NVDLA_MEM_RD_REQ  ( NVDLA_MEM_ADDRESS_WIDTH + 15 )
///////////////////////////////////////////////////
//
//#if ( NVDLA_PRIMARY_MEMIF_WIDTH  ==  512 )
//    #define LARGE_MEMBUS
//#endif
//#if ( NVDLA_PRIMARY_MEMIF_WIDTH  ==  64 )
//    #define LARGE_MEMBUS
//#endif

#define SCALE_MCIF 
