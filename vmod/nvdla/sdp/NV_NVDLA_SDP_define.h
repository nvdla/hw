// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_define.h

#define  AM_AW   NVDLA_MEMORY_ATOMIC_LOG2       //atomic m address width
#define  AM_AW2  NVDLA_MEMORY_ATOMIC_LOG2-1
#define  AM_DW   NVDLA_MEMORY_ATOMIC_SIZE*8     //atomic m bus width: atomic_m * 1byte
#define  AM_DW2  NVDLA_MEMORY_ATOMIC_SIZE*16    //atomic m bus width: atomic_m * 2byte

#define  TW      NVDLA_SDP_EW_THROUGHPUT_LOG2

#define  SDP_WR_CMD_DW   NVDLA_MEM_ADDRESS_WIDTH-AM_AW+13 

#define  BS_OP_DW     16*NVDLA_SDP_BS_THROUGHPUT
#define  BN_OP_DW     16*NVDLA_SDP_BN_THROUGHPUT
#define  EW_OP_DW     16*NVDLA_SDP_EW_THROUGHPUT  
#define  EW_OC_DW     32*NVDLA_SDP_EW_THROUGHPUT

#define  BS_IN_DW     32*NVDLA_SDP_BS_THROUGHPUT
#define  BS_OUT_DW    32*NVDLA_SDP_BS_THROUGHPUT
#define  BN_IN_DW     32*NVDLA_SDP_BN_THROUGHPUT
#define  BN_OUT_DW    32*NVDLA_SDP_BN_THROUGHPUT
#define  EW_IN_DW     32*NVDLA_SDP_EW_THROUGHPUT
#define  EW_OUT_DW    32*NVDLA_SDP_EW_THROUGHPUT

#define  EW_CORE_OUT_DW    32*NVDLA_SDP_EW_THROUGHPUT
#define  EW_IDX_OUT_DW     81*NVDLA_SDP_EW_THROUGHPUT
#define  EW_LUT_OUT_DW     185*NVDLA_SDP_EW_THROUGHPUT
#define  EW_INP_OUT_DW     32*NVDLA_SDP_EW_THROUGHPUT

#define  DP_DIN_DW    32*NVDLA_MEMORY_ATOMIC_SIZE 
#define  DP_IN_DW     32*NVDLA_SDP_MAX_THROUGHPUT
#define  BS_DOUT_DW   32*NVDLA_SDP_MAX_THROUGHPUT
#define  BN_DIN_DW    32*NVDLA_SDP_MAX_THROUGHPUT
#define  BN_DOUT_DW   32*NVDLA_SDP_MAX_THROUGHPUT
#define  EW_DIN_DW    32*NVDLA_SDP_MAX_THROUGHPUT
#define  EW_DOUT_DW   32*NVDLA_SDP_MAX_THROUGHPUT
#define  CV_IN_DW     32*NVDLA_SDP_MAX_THROUGHPUT
#define  CV_OUT_DW    16*NVDLA_SDP_MAX_THROUGHPUT
#define  DP_OUT_DW    NVDLA_BPE*NVDLA_SDP_MAX_THROUGHPUT 
#define  DP_DOUT_DW   AM_DW                         //int8: 32 * 1B ; int16: 16 * 2B


#define LUT_TABLE_LE_DEPTH   65
#define LUT_TABLE_LO_DEPTH   257
#define LUT_TABLE_MAX_DEPTH  LUT_TABLE_LO_DEPTH

