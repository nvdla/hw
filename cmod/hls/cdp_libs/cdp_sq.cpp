// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_sq.cpp

#include "cdp_sq.h"
#ifdef SYNTHESIS
#pragma hls_design top
#endif
void HLS_cdp_sq (
     ac_channel<vDataInType>  & chn_data_in
    ,ACINTF(2)                cfg_precision
    ,ac_channel<vDataOutType> & chn_data_out
    )
{
    vDataInType  i_data = chn_data_in.read();
    vDataOutType o_data;



    if (cfg_precision==ENUM_FP16) {
        vFloatType i_fp = vFloatType(i_data);
        vFloatType o_fp16= FpMul<vFloatExpoSize,vFloatMantSize>(i_fp,i_fp);
        o_data = (vDataOutType)o_fp16;
    } else {
        o_data = IntSq<vDataInSize>(i_data);
    }
   
    chn_data_out.write(o_data);
}
