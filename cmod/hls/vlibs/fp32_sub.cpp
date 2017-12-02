// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: fp32_sub.cpp

#include "vlibs.h"
#ifdef SYNTHESIS
#pragma hls_design top
#endif
void HLS_fp32_sub (
     ac_channel<vFp32Type>  & chn_a
    ,ac_channel<vFp32Type>  & chn_b
    ,ac_channel<vFp32Type>  & chn_o
    )
{
    vFp32Type  a = chn_a.read();
    vFp32Type  b = chn_b.read();
   
    vFp32Type o = FpSub<vFp32ExpoSize,vFp32MantSize>(a,b);
    chn_o.write(o);
}
