// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

#ifdef  NVDLA_SDP_BS_ENABLE
  #define RDMA_USR1  "sdp_b"
#else 
  #define RDMA_USR1 
#endif

#ifdef NVDLA_SDP_BN_ENABLE
  #define RDMA_USR2  RDMA_USR1,"sdp_n"
#else
  #define RDMA_USR2  RDMA_USR1
#endif

#ifdef NVDLA_SDP_EW_ENABLE
  #define RDMA_USR3  RDMA_USR2,"sdp_e"
#else
  #define RDMA_USR3  RDMA_USR2
#endif

#ifdef NVDLA_PDP_ENABLE
  #define RDMA_USR4  RDMA_USR3,"pdp"
  #define WDMA_USR4  "pdp"
#else
  #define RDMA_USR4  RDMA_USR3
  #define WDMA_USR4 
#endif

#ifdef NVDLA_CDP_ENABLE
  #define RDMA_USR5  RDMA_USR4,"cdp"
  #define WDMA_USR5  WDMA_USR4,"cdp"
#else
  #define RDMA_USR5  RDMA_USR4
  #define WDMA_USR5  WDMA_USR4 
#endif

#ifdef NVDLA_RUBIK_ENABLE
  #define RDMA_USR6  RDMA_USR5,"rbk"
  #define WDMA_USR6  WDMA_USR5,"rbk"
#else
  #define RDMA_USR6  RDMA_USR5
  #define WDMA_USR6  WDMA_USR5
#endif

#ifdef NVDLA_BDMA_ENABLE
  #define RDMA_USR7  RDMA_USR6,"bdma"
  #define WDMA_USR7  WDMA_USR6,"bdma"
#else
  #define RDMA_USR7  RDMA_USR6
  #define WDMA_USR7  WDMA_USR6 
#endif

#define   RDMA_NAME  ("cdma_dat","cdma_wt","sdp", RDMA_USR7)
#define   WDMA_NAME  ("sdp", WDMA_USR7)

#define   RDMA_MAX_NUM   10 
#define   WDMA_MAX_NUM   5
#define   RDMA_NUM   NVDLA_NUM_DMA_READ_CLIENTS 
#define   WDMA_NUM   NVDLA_NUM_DMA_WRITE_CLIENTS


#define   NVDLA_DMA_RD_IG_PW  NVDLA_MEM_ADDRESS_WIDTH+11
#define   NVDLA_DMA_WR_IG_PW  NVDLA_MEM_ADDRESS_WIDTH+13

#define   NVDLA_PRIMARY_MEMIF_STRB   NVDLA_MEMORY_ATOMIC_SIZE //NVDLA_PRIMARY_MEMIF_WIDTH/8


