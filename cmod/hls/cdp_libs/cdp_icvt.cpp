// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_icvt.cpp

#include "cdp_icvt.h"
#ifdef SYNTHESIS
#pragma hls_design top
#endif
void HLS_cdp_icvt (
     ac_channel<vDataInType>  & chn_data_in
    ,vAluInType               cfg_alu_in
    ,vMulInType               cfg_mul_in
    ,vTruncateType            cfg_truncate
    ,ACINTF(2)                cfg_precision
    ,ac_channel<vOutType> & chn_data_out
    )
{
    vDataInType  i_data = chn_data_in.read();
    vOutType o_data;

    if (cfg_precision==ENUM_FP16) {
        vFp16Type i_dat        = (vFp16Type)i_data;
        vFp17Type i_dat_fp17   = Fp16ToFp17(i_dat);
        o_data = (vOutType)i_dat_fp17;
        //vFp17Type cfg_alu_fp17 = Fp16ToFp17(cfg_alu_in);
        //vFp17Type cfg_mul_fp17 = Fp16ToFp17(cfg_mul_in);
        //vFp17Type o_alu = FpSub<vFp17ExpoSize,vFp17MantSize>(i_dat_fp17,cfg_alu_fp17);
        //vFp17Type o_mul = FpMul<vFp17ExpoSize,vFp17MantSize>(o_alu,cfg_mul_fp17);
        //o_data = (vOutType)o_mul;
    } else if (cfg_precision==ENUM_INT8) {
        vDataInTypeF ui_data = (vDataInTypeF)i_data;
        vDataInHType i_data_lsb = (vDataInHType)(ui_data.slc<vDataInHSize>(0));
        vDataInHType i_data_msb = (vDataInHType)(ui_data.slc<vDataInHSize>(vDataInHSize));

        // lsb
        vAluOutHType   o_alu_lsb = IntSubExt<vDataInHSize,vAluInHSize,vAluOutHSize>(i_data_lsb,cfg_alu_in);
        vMulOutHType   o_mul_lsb = IntMulExt<vAluOutHSize,vMulInHSize,vMulOutHSize>(o_alu_lsb,cfg_mul_in);
        vDataOutHType  o_trt_lsb = IntShiftRight<vMulOutHSize,vTruncateHSize,vDataOutHSize>(o_mul_lsb,cfg_truncate);

        // msb
        vAluOutHType   o_alu_msb = IntSubExt<vDataInHSize,vAluInHSize,vAluOutHSize>(i_data_msb,cfg_alu_in);
        vMulOutHType   o_mul_msb = IntMulExt<vAluOutHSize,vMulInHSize,vMulOutHSize>(o_alu_msb,cfg_mul_in);
        vDataOutHType  o_trt_msb = IntShiftRight<vMulOutHSize,vTruncateHSize,vDataOutHSize>(o_mul_msb,cfg_truncate);

        //vDataOutType o_trt_msb_shift = ((vDataOutType)(o_trt_msb)) << vDataOutHSize;
        //vDataOutType o_trt_lsb_shift =  (vDataOutType)(o_trt_lsb);
        //vDataOutType o_trt = (o_trt_msb_shift & 0xff00 ) | (o_trt_lsb_shift & 0x00ff);

        vOutTypeF o_trt_msb_f = (vOutTypeF)(o_trt_msb);
        vOutTypeF o_trt_msb_shift = o_trt_msb_f << vDataOutHSize;
        //vOutTypeF o_trt_msb_shift = ((vOutTypeF)(o_trt_msb)) << vDataOutHSize;
        vOutTypeF o_trt_lsb_shift = ((vOutTypeF)(o_trt_lsb)) & ((1ull<<vDataOutHSize)-1);
        vOutTypeF o_trt = o_trt_msb_shift | o_trt_lsb_shift;

        o_data = (vOutType)o_trt;
    } else {
        vAluOutType   o_alu = IntSubExt<vDataInSize,vAluInSize,vAluOutSize>(i_data,cfg_alu_in);
        vMulOutType   o_mul = IntMulExt<vAluOutSize,vMulInSize,vMulOutSize>(o_alu,cfg_mul_in);
        vDataOutType  o_trt= IntShiftRight<vMulOutSize,vTruncateSize,vDataOutSize>(o_mul,cfg_truncate);
        o_data = (vOutType)o_trt;
    }
   
    chn_data_out.write(o_data);
}
