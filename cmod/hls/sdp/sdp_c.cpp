// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_c.cpp

#include"sdp.h"

//  Convert:+   -> *   -> rs          -> t
//          add -> mul -> right-shift -> truncate

#ifdef SYNTHESIS
#pragma hls_design top
#endif
void NV_NVDLA_SDP_CORE_c (
                 ac_channel<cDataInStruct> & chn_in
                ,cAluOpType cfg_offset
                ,cMulOpType cfg_scale
                ,cTruncateType  cfg_truncate
                ,ACINTF(2)  cfg_proc_precision
                ,ACINTF(2)  cfg_out_precision
                ,ACINTF(1)  cfg_mode_eql
                ,ac_channel<cDataOutStruct> & chn_out
                )
{
    cDataInStruct chn_idata;
    cDataOutStruct chn_odata;

    chn_idata = chn_in.read();

    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    cvt: 
    #endif
    for (int i=0; i<16; i++) {
        cDataInType data_in = chn_idata.data[i];
        cSatType status_saturation = 0;

        if (cfg_proc_precision == ENUM_FP16) {
            cFloatType i_dat = (cFloatType)(data_in.slc<cFloatSize>(0));
            Fp16Type o = Fp32ToFp16(i_dat);

            if (cfg_out_precision==ENUM_INT16) {
                o = Fp16ToInt16(o);
            }
            chn_odata.data[i]= (cDataOutType)o;
            chn_odata.sat[i]= status_saturation;
            
        } else {
            cDataInType   i_dat = data_in.slc<cDataInSize>(0);
            cAluOutType   o_alu = IntSubExt<cDataInSize,cAluOpSize,cAluOutSize>(i_dat,cfg_offset);
            cMulOutType   o_mul = IntMulExt<cAluOutSize,cMulOpSize,cMulOutSize>(o_alu,cfg_scale);

            //// Truncate to 17
            cTrunOutType t = IntShiftRightSat<cMulOutSize,cTruncateSize,cTrunOutSize>(o_mul,cfg_truncate,status_saturation);

            // to FP16
            cDataOutType o;
            if (cfg_out_precision==ENUM_FP16) {
                o = Int17ToFp16(t);
            }
            
            // to INT16
            if (cfg_out_precision==ENUM_INT16) {
                o = IntSaturation<cTrunOutSize,cDataOutSize>(t);
            }
            
            // to INT8
            if (cfg_out_precision==ENUM_INT8) {
                o = IntSaturation<cTrunOutSize,cDataOutHSize>(t);
            }
            chn_odata.data[i]= o;
            chn_odata.sat[i]= status_saturation;
        }
            
        if (cfg_mode_eql) {
            chn_odata.data[i] = data_in;
        }

    }
    chn_out.write(chn_odata);
}
