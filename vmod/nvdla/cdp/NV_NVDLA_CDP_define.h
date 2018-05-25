// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_define.h

#define NVDLA_CDP_BWPE NVDLA_BPE
#define NVDLA_CDP_ICVTO_BWPE (NVDLA_CDP_BWPE+1)

#define NVDLA_CDP_DMAIF_BW NVDLA_MEMIF_WIDTH
#define NVDLA_CDP_MEM_ADDR_BW NVDLA_MEM_ADDRESS_WIDTH

///////////////////////////////////////////////////

//#ifdef NVDLA_FEATURE_DATA_TYPE_INT8
//#if ( NVDLA_CDP_THROUGHPUT  ==  8 )
//    #define LARGE_FIFO_RAM
//#endif
//#if ( NVDLA_CDP_THROUGHPUT == 1 )
//    #define SMALL_FIFO_RAM
//#endif
//#endif
