// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CSC.h

#define CSC_ATOMC                                           NVDLA_MAC_ATOMIC_C_SIZE
#define CSC_ATOMK                                           NVDLA_MAC_ATOMIC_K_SIZE
#define CBUF_BANK_NUM                                       NVDLA_CBUF_BANK_NUMBER
#define CBUF_BANK_DEPTH                                     NVDLA_CBUF_BANK_DEPTH
#define CSC_BPE                                             NVDLA_BPE
#define CBUF_ENTRY_BITS                                     NVDLA_CBUF_ENTRY_WIDTH
#define CSC_ATOMK_HF                                        CSC_ATOMK/2
#define CSC_TWICE_ENTRY_BITS                                CBUF_ENTRY_BITS*2         //entry*2
#define CSC_ENTRY_BITS                                      CBUF_ENTRY_BITS   //entry
#define CSC_HALF_ENTRY_BITS                                 CBUF_ENTRY_BITS/2          //entry/2
#define CSC_QUAT_ENTRY_BITS                                 CBUF_ENTRY_BITS/4          //entry/4
#define CSC_3QUAT_ENTRY_BITS                                CBUF_ENTRY_BITS*3/4        //entry*3/4
#define CSC_ATOMC_HALF                                      CSC_ATOMC/2           //atomC/2
#define CSC_ATOMC_QUAT                                      CSC_ATOMC/4           //atomC/4
#define LOG2_ATOMC                                          NVDLA_MAC_ATOMIC_C_SIZE_LOG2           //log2(atomC)
#define LOG2_ATOMK                                          NVDLA_MAC_ATOMIC_K_SIZE_LOG2           //log2(atomK)
#define LOG2_CBUF_BANK_DEPTH                                NVDLA_CBUF_BANK_DEPTH_LOG2              //log2(bank_depth)
#define CBUF_ADDR_WIDTH                                     NVDLA_CBUF_DEPTH_LOG2                   //log2(bank_num*bank_depth)
#define LOG2_BANK_NUM                                       NVDLA_CBUF_BANK_NUMBER_LOG2             //log2(bank_num)
#define NVDLA_VMOD_CBUF_WRITE_LATENCY                       3
#define NVDLA_VMOD_CBUF_READ_LATENCY                        6
#define NVDLA_HLS_CSC_PRA_LATENCY                           5
#define NVDLA_CBUF_READ_LATENCY                             NVDLA_VMOD_CBUF_READ_LATENCY
#define NVDLA_MACCELL_NUMBER                                CSC_ATOMK
#define CSC_DL_PRA_LATENCY                                  NVDLA_HLS_CSC_PRA_LATENCY
#define CSC_WL_LATENCY                                      4
#define RT_CSC2CMAC_A_LATENCY                               2
#define RT_CSC2CMAC_B_LATENCY                               1
#define CSC_ENTRIES_NUM_WIDTH                               15

#if (CSC_WL_LATENCY >= CSC_DL_PRA_LATENCY)
    #define CSC_DL_PIPELINE_ADDITION                        CSC_WL_LATENCY-CSC_DL_PRA_LATENCY
    #define CSC_WL_PIPELINE_ADDITION                        0
#else
    #define CSC_DL_PIPELINE_ADDITION                        0
    #define CSC_WL_PIPELINE_ADDITION                        CSC_DL_PRA_LATENCY-CSC_WL_LATENCY
#endif

#define CSC_SG_DONE_FLUSH                                   6'h30
#define CSC_SG_PEND_FLUSH                                   6'h20


#if (NVDLA_MAC_ATOMIC_C_SIZE==64)
    //entry bits
    #define CSC_WMB_ELEMENTS                                    11'h200
    //atomC
    #define CSC_WT_ELEMENTS                                     7'h40
    //in bytes, entry/8
    #define CSC_ENTRY_HEX                                       8'h40  
    //CSC_ENTRY_HEX/2
    #define CSC_HALF_ENTRY_HEX                                  8'h20
    //CSC_ENTRY_HEX/4
    #define CSC_QUAT_ENTRY_HEX                                  8'h10
    //CSC_ENTRY_HEX-1
    #define CSC_ENTRY_MINUS1_HEX                                8'h3f
    #define CSC_ENTRY_HEX_MUL2                                  8'h80
    
    #define CSC_ATOMC_HEX                                       7'h40
    #define CSC_ATOMC_HEX_STR                                   "\"7'h40\""
#elif (NVDLA_MAC_ATOMIC_C_SIZE==32)
    //entry bits
    #define CSC_WMB_ELEMENTS                                    11'h100
    //atomC
    #define CSC_WT_ELEMENTS                                     7'h20
    //in bytes, entry/8
    #define CSC_ENTRY_HEX                                       8'h20  
    //CSC_ENTRY_HEX/2
    #define CSC_HALF_ENTRY_HEX                                  8'h10
    //CSC_ENTRY_HEX/4
    #define CSC_QUAT_ENTRY_HEX                                  8'h8
    //CSC_ENTRY_HEX-1
    #define CSC_ENTRY_MINUS1_HEX                                8'h1f
    #define CSC_ENTRY_HEX_MUL2                                  8'h40

    #define CSC_ATOMC_HEX                                       7'h20
    #define CSC_ATOMC_HEX_STR                                   "\"7'h20\""
#elif (NVDLA_MAC_ATOMIC_C_SIZE==8) 
    //entry bits
    #define CSC_WMB_ELEMENTS                                    11'h40
    //atomC
    #define CSC_WT_ELEMENTS                                     7'h8
    //in bytes, entry/8
    #define CSC_ENTRY_HEX                                       8'h08  
    //CSC_ENTRY_HEX/2
    #define CSC_HALF_ENTRY_HEX                                  8'h04
    //CSC_ENTRY_HEX/4
    #define CSC_QUAT_ENTRY_HEX                                  8'h2
    //CSC_ENTRY_HEX-1
    #define CSC_ENTRY_MINUS1_HEX                                8'h07
    #define CSC_ENTRY_HEX_MUL2                                  8'h10

    #define CSC_ATOMC_HEX                                       7'h08
    #define CSC_ATOMC_HEX_STR                                   "\"7'h08\""
#endif


#if (NVDLA_MAC_ATOMIC_K_SIZE==32) 
    //atomK
    #define CSC_MIN_STRIPE                                      7'd32
    //atomK
    #define CSC_ATOMK_HEX                                       7'h20
    #define CSC_ATOMK_HEX_STR                                   "\"7'h20\""
    //atomK*2
    #define CSC_ATOMK_MUL2_HEX                                  7'h40
    #define CSC_ATOMK_MUL2_HEX_STR                              "\"7'h40\""
#elif (NVDLA_MAC_ATOMIC_K_SIZE==16) 
    //atomK
    #define CSC_MIN_STRIPE                                      7'd16
    //atomK
    #define CSC_ATOMK_HEX                                       7'h10
    #define CSC_ATOMK_HEX_STR                                   "\"7'h10\""
    //atomK*2
    #define CSC_ATOMK_MUL2_HEX                                  7'h20
    #define CSC_ATOMK_MUL2_HEX_STR                              "\"7'h20\""
    //atomK*4
    #define CSC_ATOMK_MUL4_HEX                                  7'h40
    #define CSC_ATOMK_MUL4_HEX_STR                              "\"7'h40\""
#elif (NVDLA_MAC_ATOMIC_K_SIZE==8) 
    //atomK
    #define CSC_MIN_STRIPE                                      7'd8
    //atomK
    #define CSC_ATOMK_HEX                                       7'h8
    #define CSC_ATOMK_HEX_STR                                   "\"7'h8\""
    //atomK*2
    #define CSC_ATOMK_MUL2_HEX                                  7'h10
    #define CSC_ATOMK_MUL2_HEX_STR                              "\"7'h10\""
    //atomK*4
    #define CSC_ATOMK_MUL4_HEX                                  7'h20
    #define CSC_ATOMK_MUL4_HEX_STR                              "\"7'h20\""
#endif

//notice, for image case, first atom OP within one strip OP must fetch from entry align place, in the middle of an entry is not supported.
//thus, when atomC/atomK=4, stripe=4*atomK, feature data still keeps atomK*2
#if (NVDLA_CC_ATOMC_DIV_ATOMK==1)
    `define CC_ATOMC_DIV_ATOMK_EQUAL_1
    #define CSC_IMG_STRIPE                                      CSC_ATOMK_MUL2_HEX
    #define NVDLA_CC_CREDIT_SIZE                                CSC_ATOMK*2
#elif (NVDLA_CC_ATOMC_DIV_ATOMK==2)
    `define CC_ATOMC_DIV_ATOMK_EQUAL_2
    #define CSC_IMG_STRIPE                                      CSC_ATOMK_MUL2_HEX
    #define NVDLA_CC_CREDIT_SIZE                                CSC_ATOMK*2
#elif (NVDLA_CC_ATOMC_DIV_ATOMK==4)
    `define CC_ATOMC_DIV_ATOMK_EQUAL_4
    #define CSC_IMG_STRIPE                                      CSC_ATOMK_MUL4_HEX
    #define NVDLA_CC_CREDIT_SIZE                                CSC_ATOMK*4
#endif


//batch keep 1
#define CSC_BATCH_STRIPE                                    7'h1


#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
`define CBUF_WEIGHT_COMPRESSED    //whether need read WMB
#endif
