// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_ocvt.cpp

#include "cdp_ocvt.h"
#ifdef SYNTHESIS
#pragma hls_design top
#endif
void HLS_cdp_ocvt (
     ac_channel<vInType>  & chn_data_in
    ,vAluInType               cfg_alu_in
    ,vMulInType               cfg_mul_in
    ,vTruncateType            cfg_truncate
    ,ACINTF(2)                cfg_precision
    ,ac_channel<vOutStruct> & chn_data_out
    )
{
    vInType  i_data = chn_data_in.read();
    vOutStruct o_data;

    if (cfg_precision==ENUM_FP16) {
        
        vFp17Type i_dat        = (vFp17Type)i_data;
        vFp16Type i_dat_fp16   = Fp17ToFp16(i_dat);
        o_data.sat = 0;
        o_data.data = (vOutType)i_dat_fp16;
    } else if (cfg_precision==ENUM_INT8) {
        vDataInHType i_data_lsb = (vDataInHType)(i_data.slc<vInHSize>(0));
        vDataInHType i_data_msb = (vDataInHType)(i_data.slc<vInHSize>(vInHSize));

        ACINTF(1) sat_lsb = 0;
        ACINTF(1) sat_msb = 0;
        // lsb
        vAluOutHType   o_alu_lsb = IntSubExt<vDataInHSize,vAluInHSize,vAluOutHSize>(i_data_lsb,cfg_alu_in);
        vMulOutHType   o_mul_lsb = IntMulExt<vAluOutHSize,vMulInHSize,vMulOutHSize>(o_alu_lsb,cfg_mul_in);
        vDataOutHType  o_trt_lsb = IntShiftRightSat<vMulOutHSize,vTruncateHSize,vDataOutHSize>(o_mul_lsb,cfg_truncate,sat_lsb);

        // msb
        vAluOutHType   o_alu_msb = IntSubExt<vDataInHSize,vAluInHSize,vAluOutHSize>(i_data_msb,cfg_alu_in);
        vMulOutHType   o_mul_msb = IntMulExt<vAluOutHSize,vMulInHSize,vMulOutHSize>(o_alu_msb,cfg_mul_in);
        vDataOutHType  o_trt_msb = IntShiftRightSat<vMulOutHSize,vTruncateHSize,vDataOutHSize>(o_mul_msb,cfg_truncate,sat_msb);

        vDataOutTypeF o_trt_msb_shift = ((vDataOutTypeF)(o_trt_msb)) << vDataOutHSize;
        vDataOutTypeF o_trt_lsb_shift = ((vDataOutTypeF)(o_trt_lsb)) & ((1ull<<vDataOutHSize)-1);
        vDataOutTypeF o_trt = o_trt_msb_shift | o_trt_lsb_shift;

        ACINTF(2) saturation_lsb = sat_lsb;
        ACINTF(2) saturation_msb = (ACINTF(2))(sat_msb) << 1;
        
        o_data.sat = saturation_msb | saturation_lsb;
        o_data.data = (vOutType)o_trt;
    } else {
        ACINTF(1) sat_lsb = 0;
        ACINTF(1) sat_msb = 0;

        vDataInType   i_dat = i_data.slc<vDataInSize>(0);
        vAluOutType   o_alu = IntSubExt<vDataInSize,vAluInSize,vAluOutSize>(i_dat,cfg_alu_in);
        vMulOutType   o_mul = IntMulExt<vAluOutSize,vMulInSize,vMulOutSize>(o_alu,cfg_mul_in);
        vDataOutType  o_trt= IntShiftRightSat<vMulOutSize,vTruncateSize,vDataOutSize>(o_mul,cfg_truncate,sat_lsb);
        
        ACINTF(2) saturation_lsb = sat_lsb;
        ACINTF(2) saturation_msb = (ACINTF(2))(sat_msb) << 1;
        o_data.sat = saturation_msb | saturation_lsb;
        o_data.data = (vOutType)o_trt;
    }
   
    chn_data_out.write(o_data);
}
