// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: vlibs.h

#ifndef _NVDLA_VLIBS_H_
#define _NVDLA_VLIBS_H_

#include "ac_channel.h"
#include "nvdla_float.h"

#define vU16Size    16
#define vInt16Size  16
#define vInt17Size  17
typedef ACINTF(vU16Size)      vU16Type;
typedef ACINTT(vInt16Size)    vInt16Type;
typedef ACINTT(vInt17Size)    vInt17Type;

#define vFp16ExpoSize  5
#define vFp16MantSize  10
#define vFp16Size      16

#define vFp17ExpoSize  6
#define vFp17MantSize  10
#define vFp17Size      17

#define vFp32ExpoSize  8
#define vFp32MantSize  23
#define vFp32Size      32

typedef ACINTT(vFp16Size)      vFp16Type;
typedef ACINTT(vFp17Size)      vFp17Type;
typedef ACINTT(vFp32Size)      vFp32Type;

void HLS_fp16_add (
     ac_channel<vFp16Type>  & chn_a
    ,ac_channel<vFp16Type>  & chn_b
    ,ac_channel<vFp16Type>  & chn_o
    );
void HLS_fp16_sub (
     ac_channel<vFp16Type>  & chn_a
    ,ac_channel<vFp16Type>  & chn_b
    ,ac_channel<vFp16Type>  & chn_o
    );
void HLS_fp16_mul (
     ac_channel<vFp16Type>  & chn_a
    ,ac_channel<vFp16Type>  & chn_b
    ,ac_channel<vFp16Type>  & chn_o
    );
void HLS_fp16_max (
     ac_channel<vFp16Type>  & chn_a
    ,ac_channel<vFp16Type>  & chn_b
    ,ac_channel<vFp16Type>  & chn_o
    );
void HLS_fp16_min (
     ac_channel<vFp16Type>  & chn_a
    ,ac_channel<vFp16Type>  & chn_b
    ,ac_channel<vFp16Type>  & chn_o
    );
void HLS_fp17_add (
     ac_channel<vFp17Type>  & chn_a
    ,ac_channel<vFp17Type>  & chn_b
    ,ac_channel<vFp17Type>  & chn_o
    );
void HLS_fp17_sub (
     ac_channel<vFp17Type>  & chn_a
    ,ac_channel<vFp17Type>  & chn_b
    ,ac_channel<vFp17Type>  & chn_o
    );
void HLS_fp17_mul (
     ac_channel<vFp17Type>  & chn_a
    ,ac_channel<vFp17Type>  & chn_b
    ,ac_channel<vFp17Type>  & chn_o
    );
void HLS_fp17_max (
     ac_channel<vFp17Type>  & chn_a
    ,ac_channel<vFp17Type>  & chn_b
    ,ac_channel<vFp17Type>  & chn_o
    );
void HLS_fp17_min (
     ac_channel<vFp17Type>  & chn_a
    ,ac_channel<vFp17Type>  & chn_b
    ,ac_channel<vFp17Type>  & chn_o
    );
void HLS_fp32_add (
     ac_channel<vFp32Type>  & chn_a
    ,ac_channel<vFp32Type>  & chn_b
    ,ac_channel<vFp32Type>  & chn_o
    );
void HLS_fp32_sub (
     ac_channel<vFp32Type>  & chn_a
    ,ac_channel<vFp32Type>  & chn_b
    ,ac_channel<vFp32Type>  & chn_o
    );
void HLS_fp32_mul (
     ac_channel<vFp32Type>  & chn_a
    ,ac_channel<vFp32Type>  & chn_b
    ,ac_channel<vFp32Type>  & chn_o
    );
void HLS_fp16_to_fp32 (
     ac_channel<vFp16Type>  & chn_a
    ,ac_channel<vFp32Type>  & chn_o
    );
void HLS_fp32_to_fp16 (
     ac_channel<vFp32Type>  & chn_a
    ,ac_channel<vFp16Type>  & chn_o
    );
void HLS_fp16_to_fp17 (
     ac_channel<vFp16Type>  & chn_a
    ,ac_channel<vFp17Type>  & chn_o
    );
void HLS_fp17_to_fp16 (
     ac_channel<vFp17Type>  & chn_a
    ,ac_channel<vFp16Type>  & chn_o
    );
void HLS_fp17_to_fp32 (
     ac_channel<vFp17Type>  & chn_a
    ,ac_channel<vFp32Type>  & chn_o
    );
void HLS_fp32_to_fp17 (
     ac_channel<vFp32Type>  & chn_a
    ,ac_channel<vFp17Type>  & chn_o
    );

void HLS_uint16_to_fp17 (
     ac_channel<vU16Type>   & chn_a
    ,ac_channel<vFp17Type>  & chn_o
    );
void HLS_int17_to_fp16 (
     ac_channel<vInt17Type> & chn_a
    ,ac_channel<vFp16Type>  & chn_o
    );
#endif
