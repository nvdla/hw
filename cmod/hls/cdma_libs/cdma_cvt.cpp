// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdma_cvt.cpp

#include "cdma_cvt.h"
#ifdef SYNTHESIS
#pragma hls_design top
#endif
void NV_NVDLA_CDMA_CVT_cell (
     ac_channel<vDataInType>  & chn_data_in
    ,ac_channel<vAluInType>   & chn_alu_in
    ,vMulInType               cfg_mul_in
    ,ACINTF(2)                cfg_in_precision
    ,ACINTF(2)                cfg_out_precision
    ,vTruncateType            cfg_truncate
    ,ac_channel<vDataOutType> & chn_data_out
    )
{
    vDataInType i_data = chn_data_in.read();
    vAluInType  i_alu  = chn_alu_in.read();
    vMulInType  i_mul  = cfg_mul_in;
    vDataOutType  o_data;
   
    #pragma CTC SKIP
    if (cfg_in_precision==ENUM_FP16) {
        o_data = i_data;
    #pragma CTC ENDSKIP
    } else {
        vAluOutType o_alu = IntSubExt<vDataInSize,vAluInSize,vAluOutSize>(i_data,i_alu);
        vMulOutType o_mul = IntMulExt<vAluOutSize,vMulInSize,vMulOutSize>(o_alu,i_mul);
        //vInt17Type  o_i17 = IntTruncate<vMulOutSize,vInt17Size,vTruncateBits>(o_mul,cfg_truncate);
        vInt17Type  o_i17 = IntShiftRight<vMulOutSize,vTruncateBits,vInt17Size>(o_mul,cfg_truncate);

        if (cfg_out_precision==ENUM_FP16) {
            o_data = FpIntToFloat<vInt17Size,vFloatExpoSize,vFloatMantSize>(o_i17);
        } else if (cfg_out_precision==ENUM_INT16) {
            vInt16Type  o_i16 = IntSaturation<vInt17Size,vInt16Size>(o_i17);
            o_data = (vDataOutType)o_i16;
        } else {
            //vInt8Type   o_i8  = IntTruncate<vMulOutSize,vInt8Size,vTruncateBits>(o_mul,cfg_truncate);
            vInt8Type   o_i8  = IntSaturation<vInt17Size,vInt8Size>(o_i17);
            o_data = (vDataOutType)o_i8;
        }
    }
    chn_data_out.write(o_data);
}
