// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_icvt.h

#ifndef _NVDLA_CDP_ICVT_H_
#define _NVDLA_CDP_ICVT_H_

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


#define vDataInSize  16
typedef ACINTT(vDataInSize)     vDataInType;
typedef ACINTF(vDataInSize)     vDataInTypeF;
#define vDataInHSize  8
typedef ACINTT(vDataInHSize)     vDataInHType;
typedef ACINTF(vDataInHSize)     vDataInHTypeF;

#define vAluInSize  16
typedef ACINTT(vAluInSize)      vAluInType;
#define vAluInHSize  8
typedef ACINTT(vAluInHSize)      vAluInHType;

#define vAluOutSize  17
typedef ACINTT(vAluOutSize)     vAluOutType;
#define vAluOutHSize  9
typedef ACINTT(vAluOutHSize)     vAluOutHType;

#define vMulInSize  16
typedef ACINTT(vMulInSize)     vMulInType;
#define vMulInHSize  16
typedef ACINTT(vMulInHSize)     vMulInHType;

#define vMulOutSize  vAluOutSize + vMulInSize
typedef ACINTT(vMulOutSize)     vMulOutType;
#define vMulOutHSize  vAluOutHSize + vMulInHSize
typedef ACINTT(vMulOutHSize)     vMulOutHType;

#define vTruncateSize  5
typedef ACINTF(vTruncateSize)     vTruncateType;
#define vTruncateHSize  5
typedef ACINTF(vTruncateHSize)     vTruncateHType;

#define vDataOutSize 17
typedef ACINTT(vDataOutSize)    vDataOutType;
typedef ACINTF(vDataOutSize)    vDataOutTypeF;
#define vDataOutHSize 9
typedef ACINTT(vDataOutHSize)   vDataOutHType;
typedef ACINTF(vDataOutHSize)   vDataOutHTypeF;

#define vOutSize 18
typedef ACINTT(vOutSize)    vOutType;
typedef ACINTF(vOutSize)    vOutTypeF;

void HLS_cdp_icvt (
     ac_channel<vDataInType>  & chn_a
    ,vAluInType               cfg_alu_in
    ,vMulInType               cfg_mul_in
    ,vTruncateType            cfg_truncate
    ,ACINTF(2)                cfg_precision
    ,ac_channel<vOutType> & chn_o
    );

#endif
