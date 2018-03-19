// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_define.h

#define MEMREQ_PD_BW   47       //79bits in Xavier with 64bits addr,in nvsmall change addr to 32bits
#define MEM_BW         64       //512bits in Xavier
#define MEMRSP_PD_BW   MEM_BW+1   //514bits in Xavier, 512bits data + 2bits mask
#define MEM_WR_PD_BW   (MEMRSP_PD_BW+1) //515bits in Xavier
#define MEM_WR_CMD_BW   NVDLA_MEM_ADDRESS_WIDTH+14

#define NVDLA_MEM_RD_IG_CMD  NVDLA_MEM_ADDRESS_WIDTH+11
#define NVDLA_MEM_WR_IG_CMD  NVDLA_MEM_ADDRESS_WIDTH+13
