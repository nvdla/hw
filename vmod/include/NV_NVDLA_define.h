// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_define.h

#define NVDLA_DMAIF_BW ( NVDLA_MEMIF_WIDTH )

#define MULTI_MASK (NVDLA_DMAIF_BW/NVDLA_BPE/NVDLA_MEMORY_ATOMIC_SIZE)

#define NVDLA_MEM_MASK_BIT NVDLA_DMA_MASK_BIT

#define NVDLA_MEMORY_ATOMIC_WIDTH NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE

///////////////////////////////////////////////////
//
#if ( NVDLA_PRIMARY_MEMIF_WIDTH  ==  512 )
    #define LARGE_MEMBUS
#endif
#if ( NVDLA_PRIMARY_MEMIF_WIDTH  ==  64 )
    #define SMALL_MEMBUS
#endif
