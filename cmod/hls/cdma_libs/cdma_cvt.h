// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdma_cvt.h

#ifndef _NVDLA_CDMA_CVT_H_
#define _NVDLA_CDMA_CVT_H_

#include "ac_int.h"
#include "ac_fixed.h"
#include "ac_channel.h"
#include "nvdla_int.h"
#include "nvdla_float.h"

#define ENUM_INT8  0x0
#define ENUM_INT16 0x1
#define ENUM_FP16  0x2

#define vFloatExpoSize  5
#define vFloatMantSize  10
#define vFloatSize      16

#define vInt8Size  8
#define vInt16Size 16
#define vInt17Size 17
#define vInt18Size 18

#define vDataInSize  17
#define vAluInSize   16
#define vMulInSize   16
#define vAluOutSize  18
#define vMulOutSize  34
#define vDataOutSize 16
#define vTruncateBits 6

typedef ACINTT(vFloatSize)      vFloatType;
typedef ACINTT(vInt16Size)      vInt16Type;
typedef ACINTT(vInt17Size)      vInt17Type;
typedef ACINTT(vInt8Size)       vInt8Type;

typedef ACINTT(vDataInSize)     vDataInType;
typedef ACINTT(vAluInSize)      vAluInType;
typedef ACINTT(vMulInSize)      vMulInType;
typedef ACINTT(vAluOutSize)     vAluOutType;
typedef ACINTT(vMulOutSize)     vMulOutType;
typedef ACINTF(vTruncateBits)   vTruncateType;
typedef ACINTT(vDataOutSize)    vDataOutType;

void NV_NVDLA_CDMA_CVT_cell (
     ac_channel<vDataInType>  & chn_data_in
    ,ac_channel<vAluInType>   & chn_alu_in
    ,vMulInType               cfg_mul_in
    ,ACINTF(2)                cfg_in_precision
    ,ACINTF(2)                cfg_out_precision
    ,vTruncateType            cfg_truncate
    ,ac_channel<vDataOutType> & chn_data_out
    );
#endif
