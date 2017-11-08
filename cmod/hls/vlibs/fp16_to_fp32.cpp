// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: fp16_to_fp32.cpp

#include "vlibs.h"
#ifdef SYNTHESIS
#pragma hls_design top
#endif
void HLS_fp16_to_fp32 (
     ac_channel<vFp16Type>  & chn_a
    ,ac_channel<vFp32Type>  & chn_o
    )
{
    vFp16Type  a = chn_a.read();
   
    vFp32Type o = Fp16ToFp32(a);
    chn_o.write(o);
}
