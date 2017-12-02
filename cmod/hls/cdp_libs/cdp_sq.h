// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_sq.h

#ifndef _NVDLA_CDP_SQ_H_
#define _NVDLA_CDP_SQ_H_

#include "ac_channel.h"
#include "nvdla_float.h"

#define ENUM_INT8  0x0
#define ENUM_INT16 0x1
#define ENUM_FP16  0x2

#define vFloatExpoSize  5
#define vFloatMantSize  10
#define vFloatSize      16
typedef ACINTT(vFloatSize)      vFloatType;

#define vDataInSize  17
typedef ACINTT(vDataInSize)     vDataInType;

#define vDataOutSize 33
typedef ACINTF(vDataOutSize)   vDataOutType;

void HLS_cdp_sq (
     ac_channel<vDataInType>  & chn_a
    ,ACINTF(2)                cfg_precision
    ,ac_channel<vDataOutType> & chn_o
    );

#endif
