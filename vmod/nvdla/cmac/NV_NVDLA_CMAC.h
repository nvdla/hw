// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CMAC.h

#define CMAC_BPE                                NVDLA_BPE //bits per element
#define CMAC_ATOMC                              NVDLA_MAC_ATOMIC_C_SIZE 
#define CMAC_ATOMK                              NVDLA_MAC_ATOMIC_K_SIZE
#define CMAC_ATOMK_HALF                         CMAC_ATOMK/2
#define CMAC_INPUT_NUM                          CMAC_ATOMC  //for one MAC_CELL
#define CMAC_SLCG_NUM                           3+CMAC_ATOMK_HALF
#define CMAC_RESULT_WIDTH                       NVDLA_MAC_RESULT_WIDTH    //16b+log2(atomC)
#define CMAC_IN_RT_LATENCY                      2   //both for data&pd
#define CMAC_OUT_RT_LATENCY                     2   //both for data&pd
#define CMAC_OUT_RETIMING                       3   //only data
#define CMAC_ACTV_LATENCY                       2   //only data
#define CMAC_DATA_LATENCY                       (CMAC_IN_RT_LATENCY+CMAC_OUT_RT_LATENCY+CMAC_OUT_RETIMING+CMAC_ACTV_LATENCY)
#define MAC_PD_LATENCY                          (CMAC_OUT_RETIMING+CMAC_ACTV_LATENCY-3)     //pd must be 3T earlier than data
#define RT_CMAC_A2CACC_LATENCY                  2
#define RT_CMAC_B2CACC_LATENCY                  3
#define PKT_nvdla_stripe_info_stripe_st_FIELD   5
#define PKT_nvdla_stripe_info_stripe_end_FIELD  6
#define PKT_nvdla_stripe_info_layer_end_FIELD   8
#if (USE_DESIGNWARE==0)
`define DESIGNWARE_NOEXIST 1
#endif
