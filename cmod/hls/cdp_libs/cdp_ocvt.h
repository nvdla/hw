// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_ocvt.h

#ifndef _NVDLA_CDP_OCVT_H_
#define _NVDLA_CDP_OCVT_H_

#include "ac_channel.h"
#include "nvdla_float.h"

#define ENUM_INT8  0x0
#define ENUM_INT16 0x1
#define ENUM_FP16  0x2

#define vFp16ExpoSize  5
#define vFp16MantSize  10
#define vFp16Size      16
typedef ACINTT(vFp16Size)      vFp16Type;

#define vFp17ExpoSize  6
#define vFp17MantSize  10
#define vFp17Size      17
typedef ACINTT(vFp17Size)      vFp17Type;


#define vInSize 50
typedef ACINTT(vInSize)     vInType;
typedef ACINTF(vInSize)     vInTypeF;
#define vInHSize 25
typedef ACINTT(vInHSize)     vInHType;
typedef ACINTF(vInHSize)     vInHTypeF;

#define vDataInSize 33 
typedef ACINTT(vDataInSize)     vDataInType;
typedef ACINTF(vDataInSize)     vDataInTypeF;
#define vDataInHSize  25
typedef ACINTT(vDataInHSize)    vDataInHType;
typedef ACINTF(vDataInHSize)    vDataInHTypeF;

#define vAluInSize  32
typedef ACINTT(vAluInSize)      vAluInType;
#define vAluInHSize  25
typedef ACINTT(vAluInHSize)     vAluInHType;

#define vAluOutSize  34
typedef ACINTT(vAluOutSize)     vAluOutType;
#define vAluOutHSize  26
typedef ACINTT(vAluOutHSize)    vAluOutHType;

#define vMulInSize  16
typedef ACINTT(vMulInSize)      vMulInType;
#define vMulInHSize  16 // same as full size as int8 is same with int16
typedef ACINTT(vMulInHSize)     vMulInHType;

#define vMulOutSize  vAluOutSize + vMulInSize
typedef ACINTT(vMulOutSize)     vMulOutType;
#define vMulOutHSize  vAluOutHSize + vMulInHSize
typedef ACINTT(vMulOutHSize)     vMulOutHType;

#define vTruncateSize  6
typedef ACINTF(vTruncateSize)     vTruncateType;
#define vTruncateHSize  6
typedef ACINTF(vTruncateHSize)     vTruncateHType;

#define vDataOutSize 16
typedef ACINTT(vDataOutSize)    vDataOutType;
typedef ACINTF(vDataOutSize)    vDataOutTypeF;
#define vDataOutHSize 8
typedef ACINTT(vDataOutHSize)   vDataOutHType;
typedef ACINTF(vDataOutHSize)   vDataOutHTypeF;

#define vOutSize 16
typedef ACINTT(vOutSize)    vOutType;
typedef ACINTF(vOutSize)    vOutTypeF;

#define vSatSize 2
typedef ACINTF(vSatSize)    vSatType;

typedef struct { 
    vOutType data;
    vSatType sat;
} vOutStruct;


void HLS_cdp_ocvt (
     ac_channel<vInType>  & chn_a
    ,vAluInType           cfg_alu_in
    ,vMulInType           cfg_mul_in
    ,vTruncateType        cfg_truncate
    ,ACINTF(2)            cfg_precision
    ,ac_channel<vOutStruct> & chn_o
    );

#endif
