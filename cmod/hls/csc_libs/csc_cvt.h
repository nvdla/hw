// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: csc_cvt.h

#ifndef _NVDLA_CVT_H_
#define _NVDLA_CVT_H_

#include "ac_int.h"
#include "ac_fixed.h"
#include "ac_channel.h"
#include "nvdla_int.h"
#include "nvdla_float.h"

#ifdef HLS_TRACE
#include "log.h"
#endif

#define ENUM_INT8  0x0
#define ENUM_INT16 0x1
#define ENUM_FP16  0x2

#define vFloatExpoSize  6
#define vFloatMantSize  10
#define vFloatSize      17

#define vFp17Size      17
#define vFp16Size      16

#define vInt8Size       8
#define vInt16Size      16
#define vInt17Size      17
#define vInt18Size      18

#define vDataSize  vInt16Size

#define vTruncateSize 2
typedef ACINTF(vTruncateSize)  vTruncateType;

enum {  kInt16Max = (1ull << vInt16Size) - 1 
       ,kInt8Max  = (1ull << vInt8Size) - 1 };

typedef ACINTT(vInt16Size) vInt16Type;
typedef ACINTT(vInt17Size) vInt17Type;
typedef ACINTT(vInt18Size) vInt18Type;
typedef ACINTT(vInt8Size)  vInt8Type;

typedef ACINTT(vFp17Size) vFp17Type;
typedef ACINTT(vFp16Size) vFp16Type;
typedef ACINTT(vFloatSize) vFloatType;

typedef ACINTT(vDataSize)  vDataType;

typedef struct { vDataType  data[16]; }  vDataStruct;
typedef struct { vInt16Type data[16]; }  vInt16Struct;
typedef struct { vInt17Type data[16]; }  vInt17Struct;
typedef struct { vInt18Type data[16]; }  vInt18Struct;

void NV_NVDLA_CSC_pra_cell (
     ac_channel<vDataStruct> & chn_data_in
    ,ACINTF(2)               cfg_precision
    ,vTruncateType           cfg_truncate
    ,ac_channel<vDataStruct> & chn_data_out
    );
#endif
