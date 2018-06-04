// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CACC.h

#define CACC_IN_WIDTH                                   NVDLA_MAC_RESULT_WIDTH  //16+log2(atomC),sum result width for one atomic operation.
#define SDP_MAX_THROUGHPUT                              NVDLA_SDP_MAX_THROUGHPUT  //2^n, no bigger than atomM
#define CACC_ATOMK                                      NVDLA_MAC_ATOMIC_K_SIZE
#define CACC_ATOMK_LOG2                                 NVDLA_MAC_ATOMIC_K_SIZE_LOG2
#define CACC_ABUF_WIDTH                                 CACC_PARSUM_WIDTH*CACC_ATOMK
#define CACC_DBUF_WIDTH                                 CACC_FINAL_WIDTH*CACC_ATOMK
#define CACC_PARSUM_WIDTH                               34  //sum result width for one layer operation.
#define CACC_FINAL_WIDTH                                32  //sum result width for one layer operation with saturaton.
#define CACC_SDP_DATA_WIDTH                             CACC_FINAL_WIDTH*SDP_MAX_THROUGHPUT
#define CACC_SDP_WIDTH                                  CACC_SDP_DATA_WIDTH+2    //cacc to sdp pd width
#define CACC_DWIDTH_DIV_SWIDTH                          (CACC_DBUF_WIDTH)/(CACC_SDP_DATA_WIDTH)  //1,2,4...
#define CACC_CELL_PARTIAL_LATENCY                       2 
#define CACC_CELL_FINAL_LATENCY                         2
#define CACC_D_RAM_WRITE_LATENCY                        1
#define NVDLA_CACC_D_MISC_CFG_0_PROC_PRECISION_INT8     2'h0
#define CACC_CHANNEL_BITS                               12

#if(NVDLA_CC_ATOMC_DIV_ATOMK==1)
    #define CACC_ABUF_DEPTH                                 NVDLA_MAC_ATOMIC_K_SIZE*2  //2*atomK
    #define CACC_ABUF_AWIDTH                                NVDLA_MAC_ATOMIC_K_SIZE_LOG2+1   //log2(abuf_depth)
#elif(NVDLA_CC_ATOMC_DIV_ATOMK==2)
    #define CACC_ABUF_DEPTH                                 NVDLA_MAC_ATOMIC_K_SIZE*2  //2*atomK
    #define CACC_ABUF_AWIDTH                                NVDLA_MAC_ATOMIC_K_SIZE_LOG2+1   //log2(abuf_depth)
#elif(NVDLA_CC_ATOMC_DIV_ATOMK==4)
    #define CACC_ABUF_DEPTH                                 NVDLA_MAC_ATOMIC_K_SIZE*4  //4*atomK,under image, stripe OP must begin from entry align place
    #define CACC_ABUF_AWIDTH                                NVDLA_MAC_ATOMIC_K_SIZE_LOG2+2   //log2(abuf_depth)
#endif
    
#define CACC_DBUF_DEPTH                                 CACC_ABUF_DEPTH
#define CACC_DBUF_AWIDTH                                CACC_ABUF_AWIDTH    //address width
