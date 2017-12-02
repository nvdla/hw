// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_y_cvt.cpp

#include"sdp.h"

//  Convert:+   -> *   -> rs          -> t
//          add -> mul -> right-shift -> truncate

#ifdef HLS_TRACE
static int hls_call_iter = 1;
#endif

eDataOutType cvt (
          eDataInType i_data
         ,eAluOpType  cfg_offset
         ,eMulOpType  cfg_scale
         ,eTruncateType cfg_truncate
         ,ACINTF(1)   cfg_nan_to_zero
         ,ACINTF(1)   cfg_bypass
         ,ACINTF(2)   cfg_precision
)
{
    // get op from reg | dma

    eDataOutType o_data;
    if (cfg_precision==ENUM_FP16) {
        // INF to MAX
        //eDataInType i_dat = FpFloatToFloat<5,10>(i_data);
        eDataInType i_dat = i_data;

        // NAN Flush to Zero
        ACINTF(yOpSignSize) op_sign;
        ACINTF(yOpExpoSize) op_expo;
        ACINTF(yOpMantSize) op_mant;
        FpSignedBitsToFloat<yOpExpoSize,yOpMantSize>(i_dat,op_sign,op_expo,op_mant);
                
        bool is_nan = IsNaN<yOpExpoSize,yOpMantSize>(op_expo,op_mant);
        if (cfg_nan_to_zero && is_nan) {
            op_sign = 0;
            op_expo = 0;
            op_mant = 0;
        }

        i_dat = FpFloatToSignedBits<yOpExpoSize,yOpMantSize>(op_sign,op_expo,op_mant);

        // fp16 to fp32
        Fp32Type i_dat_32 = Fp16ToFp32(i_dat);
        o_data = i_dat_32;

        //Fp32Type cfg_offset_32 = Fp16ToFp32(cfg_offset);
        //Fp32Type o_alu = FpSub<Fp32ExpoSize,Fp32MantSize>(i_dat_32,cfg_offset_32);

        //Fp32Type cfg_scale_32 = Fp16ToFp32(cfg_scale);
        //Fp32Type o_mul = FpMul<Fp32ExpoSize,Fp32MantSize>(o_alu,cfg_scale_32);
        //o_data = (eDataOutType)o_mul;
    } else {
        if (cfg_bypass) {
            o_data = i_data;
        } else {
            eDataInType   i_dat = i_data;
            eAluOutType   o_alu = IntSubExt<eDataInSize,eAluOpSize,eAluOutSize>(i_dat,cfg_offset);
            eMulOutType   o_mul = IntMulExt<eAluOutSize,eMulOpSize,eMulOutSize>(o_alu,cfg_scale);
            eDataOutType  o_tct = IntShiftRight<eMulOutSize,eTruncateSize,eDataOutSize>(o_mul,cfg_truncate);
            o_data = (eDataOutType)o_tct;
        }
    }

    return o_data;
}

#ifdef SYNTHESIS
#pragma hls_design top
#endif
void NV_NVDLA_SDP_CORE_Y_cvt (
          ac_channel<eDataInStruct> & chn_in
         ,ACINTF(1)     cfg_bypass
         ,eAluOpType    cfg_offset
         ,eMulOpType    cfg_scale
         ,eTruncateType cfg_truncate
         ,ACINTF(1)     cfg_nan_to_zero
         ,ACINTF(2)     cfg_precision
         ,ac_channel<eDataOutStruct> & chn_out
         )
{
    eDataInStruct data_in;
    eDataOutStruct data_out;

    data_in = chn_in.read();
        
    #ifdef HLS_TRACE
        cslDebug((30, "%s call NV_NVDLA_SDP_CORE_Y_cvt on %d iter\n", "HLS_CALL", hls_call_iter++));
    #endif

    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    cvt: 
    #endif
    for (int i=0; i<SPEED_Y; i++) {
            eDataOutType cvt_out;
            cvt_out = cvt (
                         data_in.data[i]
                        ,cfg_offset
                        ,cfg_scale
                        ,cfg_truncate
                        ,cfg_nan_to_zero
                        ,cfg_bypass
                        ,cfg_precision
                        );
            data_out.data[i] = cvt_out;
    }
    
    #ifdef HLS_TRACE
        #pragma CTC SKIP
        if (hls_call_iter % 2) {
            cslDebug((30, "ALU:  "));
        } else {
            cslDebug((30, "MUL:  "));
        }
        #pragma CTC ENDSKIP

        cslDebug((30, "\n"));
        cslDebug((30, "Y-CVT-IN:  "));
        cslDebug((30, "\n"));
        for (int i=0; i<SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", data_in.data[i].to_int()));
        }
        cslDebug((30, "\n"));
        cslDebug((30, "Y-CVT-OUT: "));
        cslDebug((30, "\n"));
        for (int i=0; i<SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", data_out.data[i].to_int()));
        }
        cslDebug((30, "\n"));
    #endif
    chn_out.write(data_out);
}
