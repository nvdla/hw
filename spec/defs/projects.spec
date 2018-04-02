#if defined(FEATURE_DATA_TYPE_INT8)
    %define NVDLA_FEATURE_DATA_TYPE_INT8
    %define NVDLA_BPE 8
#elif defined(FEATURE_DATA_TYPE_INT16_FP16)
    %define NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    %define NVDLA_BPE 16
#else
    #error " NVDLA_FEATURE_DATA_TYPE_INT8 must be set"
#endif

#if defined(WEIGHT_DATA_TYPE_INT8)
    %define NVDLA_WEIGHT_DATA_TYPE_INT8
#elif defined(WEIGHT_DATA_TYPE_INT16_FP16)
    %define NVDLA_WEIGHT_DATA_TYPE_INT16_FP16
#else
    #error " NVDLA_WEIGHT_DATA_TYPE_INT8 must be set"
#endif


#if defined(WEIGHT_COMPRESSION_ENABLE)
    %define NVDLA_WEIGHT_COMPRESSION_ENABLE
#elif defined(WEIGHT_COMPRESSION_DISABLE)
#else
    #error "one of NVDLA_WEIGHT_COMPRESSION_{EN,DIS}ABLE must be set"
#endif

#if defined(WINOGRAD_ENABLE)
    %define NVDLA_WINOGRAD_ENABLE
#elif defined(WINOGRAD_DISABLE)
#else
    #error "one of NVDLA_WINOGRAD_{EN,DIS}ABLE must be set"
#endif

#if defined(BATCH_ENABLE)
    %define NVDLA_BATCH_ENABLE 
#elif defined(BATCH_DISABLE)
#else
    #error "one of NVDLA_BATCH_{EN,DIS}ABLE must be set"
#endif

#if defined(SECONDARY_MEMIF_ENABLE)
    %define NVDLA_SECONDARY_MEMIF_ENABLE
#elif defined(SECONDARY_MEMIF_DISABLE)
#else
    #error "one of NVDLA_SECONDARY_MEMIF_{EN,DIS}ABLE must be set"
#endif

#if defined(SDP_LUT_ENABLE)
    %define NVDLA_SDP_LUT_ENABLE 
#elif defined(SDP_LUT_DISABLE)
#else
    #error "one of NVDLA_SDP_LUT_{EN,DIS}ABLE must be set"
#endif

#if defined(SDP_BS_ENABLE)
    %define NVDLA_SDP_BS_ENABLE
#elif defined(SDP_BS_DISABLE)
#else
    #error "one of NVDLA_SDP_BS_{EN,DIS}ABLE must be set"
#endif

#if defined(SDP_BN_ENABLE)
    %define NVDLA_SDP_BN_ENABLE
#elif defined(SDP_BN_DISABLE)
#else
    #error "one of NVDLA_SDP_BN_{EN,DIS}ABLE must be set"
#endif

#if defined(SDP_EW_ENABLE)
    %define NVDLA_SDP_EW_ENABLE
#elif defined(SDP_EW_DISABLE)
#else
    #error "one of NVDLA_SDP_EW_{EN,DIS}ABLE must be set"
#endif

#if defined(BDMA_ENABLE)
    %define NVDLA_BDMA_ENABLE
#elif defined(BDMA_DISABLE)
#else
    #error "one of NVDLA_BDMA_{EN,DIS}ABLE must be set"
#endif

#if defined(RUBIK_ENABLE)
    %define NVDLA_RUBIK_ENABLE 
#elif defined(RUBIK_DISABLE)
#else
    #error "one of NVDLA_RUBIK_{EN,DIS}ABLE must be set"
#endif

#if defined(RUBIK_CONTRACT_ENABLE)
    %define NVDLA_RUBIK_CONTRACT_ENABLE
#elif defined(RUBIK_CONTRACT_DISABLE)
#else
    #error "one of NVDLA_RUBIK_CONTRACT_{EN,DIS}ABLE must be set"
#endif

#if defined(RUBIK_RESHAPE_ENABLE)
    %define NVDLA_RUBIK_RESHAPE_ENABLE
#elif defined(RUBIK_RESHAPE_DISABLE)
#else
    #error "one of NVDLA_RUBIK_RESHAPE_{EN,DIS}ABLE must be set"
#endif

#if defined(PDP_ENABLE)
    %define NVDLA_PDP_ENABLE
#elif defined(PDP_DISABLE)
#else
    #error "one of NVDLA_PDP_{EN,DIS}ABLE must be set"
#endif

#if defined(CDP_ENABLE)
    %define NVDLA_CDP_ENABLE
#elif defined(CDP_DISABLE)
#else
    #error "one of NVDLA_CDP_{EN,DIS}ABLE must be set"
#endif

#if defined(RETIMING_ENABLE)
    %define NVDLA_RETIMING_ENABLE
#elif defined(RETIMING_DISABLE)
#else
    #error "one of NVDLA_RETIMING_{EN,DIS}ABLE must be set"
#endif

#if defined(MAC_ATOMIC_C_SIZE_64)
    %define NVDLA_MAC_ATOMIC_C_SIZE 64 
#elif defined(MAC_ATOMIC_C_SIZE_32)
    %define NVDLA_MAC_ATOMIC_C_SIZE 32 
#elif defined(MAC_ATOMIC_C_SIZE_8)
    %define NVDLA_MAC_ATOMIC_C_SIZE 8 
#else
    #error "one of NVDLA_MAC_ATOMIC_C_SIZE_{64,32,8} must be set"
#endif

#if defined(MAC_ATOMIC_K_SIZE_32)
    %define NVDLA_MAC_ATOMIC_K_SIZE 32
#elif defined(MAC_ATOMIC_K_SIZE_8)
    %define NVDLA_MAC_ATOMIC_K_SIZE 8
#else
    #error "one of NVDLA_MAC_ATOMIC_K_SIZE_{32,8} must be set"
#endif

#if defined(MEMORY_ATOMIC_SIZE_32)
    %define NVDLA_MEMORY_ATOMIC_SIZE 32
#elif defined(MEMORY_ATOMIC_SIZE_8)
    %define NVDLA_MEMORY_ATOMIC_SIZE 8
#else
    #error "one of NVDLA_MEMORY_ATOMIC_SIZE_{32,8} must be set"
#endif

#if defined(MAX_BATCH_SIZE_32)
    %define NVDLA_MAX_BATCH_SIZE 32
#elif defined(MAX_BATCH_SIZE_x) 
#else
    #error "one of NVDLA_MAX_BATCH_SIZE_{32,x} must be set"
#endif

#if defined(CBUF_BANK_NUMBER_16)
    %define NVDLA_CBUF_BANK_NUMBER 16
#elif defined(CBUF_BANK_NUMBER_32)
    %define NVDLA_CBUF_BANK_NUMBER 32
#else
    #error "one of NVDLA_CBUF_BANK_NUMBER_{16,32} must be set"
#endif

#if defined(CBUF_BANK_WIDTH_64)
    %define NVDLA_CBUF_BANK_WIDTH 64
#elif defined(CBUF_BANK_WIDTH_32)
    %define NVDLA_CBUF_BANK_WIDTH 32
#elif defined(CBUF_BANK_WIDTH_8)
    %define NVDLA_CBUF_BANK_WIDTH 8
#else
    #error "one of NVDLA_CBUF_BANK_WIDTH_{64,32,8} must be set"
#endif

#if defined(CBUF_BANK_DEPTH_512)
    %define NVDLA_CBUF_BANK_DEPTH 512
#elif defined(CBUF_BANK_DEPTH_128)
    %define NVDLA_CBUF_BANK_DEPTH 128
#else
    #error "only NVDLA_CBUF_BANK_DEPTH_{512,128} can be set"
#endif

#if defined(SDP_BS_ENABLE)
 #if defined(SDP_BS_THROUGHPUT_16)
     %define NVDLA_SDP_BS_THROUGHPUT 16
 #elif defined(SDP_BS_THROUGHPUT_1)
     %define NVDLA_SDP_BS_THROUGHPUT 1
 #else
     #error "one of NVDLA_SDP_BS_THROUGHPUT_{16,1} must be set"
 #endif
#else
     %define NVDLA_SDP_BS_THROUGHPUT 0 
#endif 

#if defined(SDP_BN_ENABLE)
 #if defined(SDP_BN_THROUGHPUT_16)
     %define NVDLA_SDP_BN_THROUGHPUT 16 
 #elif defined(SDP_BN_THROUGHPUT_1)
     %define NVDLA_SDP_BN_THROUGHPUT 1 
 #else
     #error "one of NVDLA_SDP_BN_THROUGHPUT_{16,1} must be set"
 #endif
#else
     %define NVDLA_SDP_BN_THROUGHPUT 0 
#endif

#if defined(SDP_EW_ENABLE)
 #if defined(SDP_EW_THROUGHPUT_4)
     %define NVDLA_SDP_EW_THROUGHPUT 4
 #elif defined(SDP_EW_THROUGHPUT_x)
     %define NVDLA_SDP_EW_THROUGHPUT 1
 #else
     #error "one of NVDLA_SDP_EW_THROUGHPUT_{4,x} must be set"
 #endif
#else
     %define NVDLA_SDP_EW_THROUGHPUT 0
#endif

%define NVDLA_SDP_MAX_THROUGHPUT max(NVDLA_SDP_EW_THROUGHPUT, NVDLA_SDP_BN_THROUGHPUT,NVDLA_SDP_BS_THROUGHPUT)
%define NVDLA_SDP2PDP_WIDTH  (NVDLA_SDP_MAX_THROUGHPUT * NVDLA_BPE)

#if defined(PDP_THROUGHPUT_8)
    %define NVDLA_PDP_THROUGHPUT 8
#elif defined(PDP_THROUGHPUT_1)
    %define NVDLA_PDP_THROUGHPUT 1
#else
    #error "one of NVDLA_PDP_THROUGHPUT_{8,1} must be set"
#endif

#if defined(CDP_THROUGHPUT_8)
    %define NVDLA_CDP_THROUGHPUT 8
#elif defined(CDP_THROUGHPUT_1)
    %define NVDLA_CDP_THROUGHPUT 1
#else
    #error "one of NVDLA_CDP_THROUGHPUT_{8,1} must be set"
#endif

#if defined(PRIMARY_MEMIF_LATENCY_1200)
    %define NVDLA_PRIMARY_MEMIF_LATENCY 1200
#elif defined(PRIMARY_MEMIF_LATENCY_50)
    %define NVDLA_PRIMARY_MEMIF_LATENCY 50
#else
    #error "one of NVDLA_PRIMARY_MEMIF_LATENCY_{1200,50} must be set"
#endif

#if defined(SECONDARY_MEMIF_LATENCY_128)
    %define NVDLA_SECONDARY_MEMIF_LATENCY 128
#elif defined(SECONDARY_MEMIF_LATENCY_x)
#else
    #error "one of NVDLA_SECONDARY_MEMIF_LATENCY_{128,x} must be set"
#endif

#if defined(PRIMARY_MEMIF_MAX_BURST_LENGTH_1)
    %define NVDLA_PRIMARY_MEMIF_MAX_BURST_LENGTH 1
#elif defined(PRIMARY_MEMIF_MAX_BURST_LENGTH_4)
    %define NVDLA_PRIMARY_MEMIF_MAX_BURST_LENGTH 4
#else
    #error "one of NVDLA_PRIMARY_MEMIF_MAX_BURST_LENGTH_{1,4} must be set"
#endif

#if defined(PRIMARY_MEMIF_WIDTH_512)
    %define NVDLA_PRIMARY_MEMIF_WIDTH 512
#elif defined(PRIMARY_MEMIF_WIDTH_64)
    %define NVDLA_PRIMARY_MEMIF_WIDTH 64
#else
    #error "one of NVDLA_PRIMARY_MEMIF_WIDTH_{512,64} must be set"
#endif

#if defined(SECONDARY_MEMIF_MAX_BURST_LENGTH_4)
    %define NVDLA_SECONDARY_MEMIF_MAX_BURST_LENGTH 4
#elif defined(SECONDARY_MEMIF_MAX_BURST_LENGTH_x)
#else
    #error "one of NVDLA_SECONDARY_MEMIF_MAX_BURST_LENGTH_{4,x} must be set"
#endif

#if defined(SECONDARY_MEMIF_WIDTH_512)
    %define NVDLA_SECONDARY_MEMIF_WIDTH 512
#elif defined(SECONDARY_MEMIF_WIDTH_x)
#else
    #error "one of NVDLA_SECONDARY_MEMIF_WIDTH_{512,x} must be set"
#endif

#if defined(MEM_ADDRESS_WIDTH_64)
    %define NVDLA_MEM_ADDRESS_WIDTH 64
#elif defined(MEM_ADDRESS_WIDTH_32)
    %define NVDLA_MEM_ADDRESS_WIDTH 32
#else
    #error "one of NVDLA_PRIMARY_MEMIF_WIDTH_{512,64} must be set"
#endif

#if defined(SECONDARY_MEMIF_ENABLE)
    %define NVDLA_MEMIF_WIDTH max(NVDLA_PRIMARY_MEMIF_WIDTH, NVDLA_SECONDARY_MEMIF_WIDTH, NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE)
#elif defined(SECONDARY_MEMIF_DISABLE)
    %define NVDLA_MEMIF_WIDTH max(NVDLA_PRIMARY_MEMIF_WIDTH, NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE)
#else
    #error "one of NVDLA_SECONDARY_MEMIF_{EN,DIS}ABLE must be set"
#endif

%define NVDLA_DMA_RD_SIZE   15
%define NVDLA_DMA_WR_SIZE   13
%define NVDLA_DMA_MASK_BIT int( NVDLA_MEMIF_WIDTH / NVDLA_BPE / NVDLA_MEMORY_ATOMIC_SIZE )
%define NVDLA_DMA_RD_RSP   int( NVDLA_MEMIF_WIDTH + NVDLA_DMA_MASK_BIT )
%define NVDLA_DMA_WR_REQ   int( NVDLA_MEMIF_WIDTH + NVDLA_DMA_MASK_BIT + 1 )
%define NVDLA_DMA_WR_CMD   int( NVDLA_MEM_ADDRESS_WIDTH + NVDLA_DMA_WR_SIZE +1)
%define NVDLA_DMA_RD_REQ   int( NVDLA_MEM_ADDRESS_WIDTH + NVDLA_DMA_RD_SIZE )

%define NVDLA_MEMORY_ATOMIC_LOG2  log2(NVDLA_MEMORY_ATOMIC_SIZE)
%define NVDLA_PRIMARY_MEMIF_WIDTH_LOG2 log2(NVDLA_PRIMARY_MEMIF_WIDTH/8)
%define NVDLA_SECONDARY_MEMIF_WIDTH_LOG2 log2(NVDLA_SECONDARY_MEMIF_WIDTH/8)

#if defined(NUM_DMA_READ_CLIENTS_10)
    %define NVDLA_NUM_DMA_READ_CLIENTS 10
#endif

#if defined(NUM_DMA_WRITE_CLIENTS_5)
    %define NVDLA_NUM_DMA_WRITE_CLIENTS 5
#endif

#if defined(NUM_DMA_READ_CLIENTS_7)
    %define NVDLA_NUM_DMA_READ_CLIENTS 7
#endif

#if defined(NUM_DMA_WRITE_CLIENTS_3)
    %define NVDLA_NUM_DMA_WRITE_CLIENTS 3
#endif

#if defined(DESIGNWARE_NOEXIST)
    %define DESIGNWARE_NOEXIST
#endif

%define NVDLA_MAC_ATOMIC_C_SIZE_LOG2    log2(NVDLA_MAC_ATOMIC_C_SIZE)
%define NVDLA_MAC_ATOMIC_K_SIZE_LOG2    log2(NVDLA_MAC_ATOMIC_K_SIZE)
%define NVDLA_CBUF_BANK_NUMBER_LOG2     log2(NVDLA_CBUF_BANK_NUMBER)
%define NVDLA_CBUF_BANK_WIDTH_LOG2      log2(NVDLA_CBUF_BANK_WIDTH)
%define NVDLA_CBUF_BANK_DEPTH_LOG2      log2(NVDLA_CBUF_BANK_DEPTH)
%define NVDLA_CBUF_DEPTH_LOG2           log2(NVDLA_CBUF_BANK_NUMBER)+log2(NVDLA_CBUF_BANK_DEPTH)
%define NVDLA_CBUF_ENTRY_WIDTH          NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_BPE
%define NVDLA_CBUF_WIDTH_LOG2           log2(NVDLA_CBUF_ENTRY_WIDTH)
%define NVDLA_CBUF_WIDTH_MUL2_LOG2      log2(NVDLA_CBUF_ENTRY_WIDTH)+1
%define NVDLA_BPE_LOG2                  log2(NVDLA_BPE)
%define NVDLA_MAC_RESULT_WIDTH          NVDLA_BPE*2+NVDLA_MAC_ATOMIC_C_SIZE_LOG2
%define NVDLA_CC_ATOMC_DIV_ATOMK        int(NVDLA_MAC_ATOMIC_C_SIZE/NVDLA_MAC_ATOMIC_K_SIZE)
