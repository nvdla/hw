// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_config_small.h

#define NVDLA_FEATURE_DATA_TYPE_INT8 
#define NVDLA_WEIGHT_DATA_TYPE_INT8 
#define NVDLA_SDP_BS_ENABLE 
#define NVDLA_SDP_BN_ENABLE 
#define NVDLA_PDP_ENABLE 
#define NVDLA_CDP_ENABLE 
#define NVDLA_MAC_ATOMIC_C_SIZE 8
#define NVDLA_MAC_ATOMIC_K_SIZE 8
#define NVDLA_MEMORY_ATOMIC_SIZE 8
#define NVDLA_CBUF_BANK_NUMBER 32
#define NVDLA_CBUF_BANK_WIDTH 8
#define NVDLA_CBUF_BANK_DEPTH 512
#define NVDLA_SDP_BS_THROUGHPUT 1
#define NVDLA_SDP_BN_THROUGHPUT 1
#define NVDLA_PDP_THROUGHPUT 1
#define NVDLA_CDP_THROUGHPUT 1
#define NVDLA_PRIMARY_MEMIF_LATENCY 50
#define NVDLA_PRIMARY_MEMIF_MAX_BURST_LENGTH 4
#define NVDLA_PRIMARY_MEMIF_WIDTH 64
