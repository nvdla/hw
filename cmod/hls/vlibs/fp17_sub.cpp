// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: fp17_sub.cpp

#include "vlibs.h"
#ifdef SYNTHESIS
#pragma hls_design top
#endif
void HLS_fp17_sub (
     ac_channel<vFp17Type>  & chn_a
    ,ac_channel<vFp17Type>  & chn_b
    ,ac_channel<vFp17Type>  & chn_o
    )
{
    vFp17Type  a = chn_a.read();
    vFp17Type  b = chn_b.read();
   
    vFp17Type o = FpSub<vFp17ExpoSize,vFp17MantSize>(a,b);
    chn_o.write(o);
}
