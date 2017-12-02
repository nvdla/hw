// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_config_large.h

#define NVDLA_FEATURE_DATA_TYPE_INT8 
#define NVDLA_WEIGHT_DATA_TYPE_INT8 
#define NVDLA_WEIGHT_COMPRESSION_ENABLE 
#define NVDLA_WINOGRAD_ENABLE 
#define NVDLA_BATCH_ENABLE 
#define NVDLA_SECONDARY_MEMIF_ENABLE 
#define NVDLA_SDP_LUT_ENABLE 
#define NVDLA_SDP_BS_ENABLE 
#define NVDLA_SDP_BN_ENABLE 
#define NVDLA_SDP_EW_ENABLE 
#define NVDLA_BDMA_ENABLE 
#define NVDLA_RUBIK_ENABLE 
#define NVDLA_RUBIK_CONTRACT_ENABLE 
#define NVDLA_RUBIK_RESHAPE_ENABLE 
#define NVDLA_PDP_ENABLE 
#define NVDLA_CDP_ENABLE 
#define NVDLA_RETIMING_ENABLE 
#define NVDLA_MAC_ATOMIC_C_SIZE 64
#define NVDLA_MAC_ATOMIC_K_SIZE 32
#define NVDLA_MEMORY_ATOMIC_SIZE 32
#define NVDLA_MAX_BATCH_SIZE 32
#define NVDLA_CBUF_BANK_NUMBER 16
#define NVDLA_CBUF_BANK_WIDTH 64
#define NVDLA_CBUF_BANK_DEPTH 512
#define NVDLA_SDP_BS_THROUGHPUT 16
#define NVDLA_SDP_BN_THROUGHPUT 16
#define NVDLA_SDP_EW_THROUGHPUT 4
#define NVDLA_PDP_THROUGHPUT 8
#define NVDLA_CDP_THROUGHPUT 8
#define NVDLA_PRIMARY_MEMIF_LATENCY 1200
#define NVDLA_SECONDARY_MEMIF_LATENCY 128
#define NVDLA_PRIMARY_MEMIF_MAX_BURST_LENGTH 1
#define NVDLA_PRIMARY_MEMIF_WIDTH 512
#define NVDLA_SECONDARY_MEMIF_MAX_BURST_LENGTH 4
#define NVDLA_SECONDARY_MEMIF_WIDTH 512
