// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: csc_cvt.cpp

#include "csc_cvt.h"

//        _            _
// C^T = |  1  0 -1  0  |
//       |  0  1  1  0  |
//       |  0 -1  1  0  |
//       |_ 0  1  0 -1 _|
//        _            _
// C   = |  1  0  0  0  |
//       |  0  1 -1  1  |
//       | -1  1  1  0  |
//       |_ 0  0  0 -1 _|

// Output = C^T * Input * C
// among which:
// M      = C^T * Input
// Output = M * C
//

#ifdef HLS_TRACE
static int hls_call_iter = 1;
#endif

#ifdef SYNTHESIS
#pragma hls_design top
#endif
void NV_NVDLA_CSC_pra_cell (
     ac_channel<vDataStruct> & chn_data_in
    ,ACINTF(2)               cfg_precision
    ,vTruncateType           cfg_truncate
    ,ac_channel<vDataStruct> & chn_data_out
    )
{
    vDataStruct i_data = chn_data_in.read();
    vInt17Struct  m_data; 
    vInt17Struct  f_data; 
    vInt18Struct  t_data; 
    vDataStruct   o_data;
    
    #ifdef HLS_TRACE
        cslDebug((30, "%s call NV_NVDLA_CSC_pra_cell on %d iter\n", "HLS_CALL", hls_call_iter++));
    #endif
    //=====================================================
    // C^T * Input
    //=====================================================
    // (1,0,-1,0) * i_data
    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    m_row0: 
    #endif
    for (int i=0; i<4; i++) {
        if (cfg_precision==ENUM_FP16) {
            vFp16Type d1 = (vFp16Type)i_data.data[i];
            vFp16Type d2 = (vFp16Type)i_data.data[i+8];
            
            vFloatType data1 = Fp16ToFp17(d1);
            vFloatType data2 = Fp16ToFp17(d2);

            m_data.data[i] = FpSub<vFloatExpoSize,vFloatMantSize>(data1,data2);
        } else {
            vInt16Type data1 = (vInt16Type)i_data.data[i];
            vInt16Type data2 = (vInt16Type)i_data.data[8+i];
            m_data.data[i] = IntSubExt<vInt16Size,vInt16Size,vInt17Size>(data1,data2);
        }
    }

    // (0,1,1,0) * i_data
    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    m_row1: 
    #endif
    for (int i=4; i<8; i++) {
        if (cfg_precision==ENUM_FP16) {
            vFp16Type d1 = (vFp16Type)i_data.data[i];
            vFp16Type d2 = (vFp16Type)i_data.data[i+4];

            vFloatType data1 = Fp16ToFp17(d1);
            vFloatType data2 = Fp16ToFp17(d2);

            m_data.data[i] = FpAdd<vFloatExpoSize,vFloatMantSize>(data1,data2);
        } else {
            vInt16Type data1 = (vInt16Type)i_data.data[i];
            vInt16Type data2 = (vInt16Type)i_data.data[i+4];
            m_data.data[i] = IntAddExt<vInt16Size,vInt16Size,vInt17Size>(data1,data2);
        }
    }
    
    // (0,-1,1,0) * i_data
    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    m_row2: 
    #endif
    for (int i=8; i<12; i++) {
        if (cfg_precision==ENUM_FP16) {
            vFp16Type d1 = (vFp16Type)i_data.data[i];
            vFp16Type d2 = (vFp16Type)i_data.data[i-4];

            vFloatType data1 = Fp16ToFp17(d1);
            vFloatType data2 = Fp16ToFp17(d2);

            m_data.data[i] = FpSub<vFloatExpoSize,vFloatMantSize>(data1,data2);
        } else {
            vInt16Type data1 = (vInt16Type)i_data.data[i];
            vInt16Type data2 = (vInt16Type)i_data.data[i-4];
            m_data.data[i] = IntSubExt<vInt16Size,vInt16Size,vInt17Size>(data1,data2);
        }
    }
    
    // (0,1,0,-1) * i_data
    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    m_row3: 
    #endif
    for (int i=12; i<16; i++) {
        if (cfg_precision==ENUM_FP16) {
            vFp16Type d1 = (vFp16Type)i_data.data[i-8];
            vFp16Type d2 = (vFp16Type)i_data.data[i];
            vFloatType data1 = Fp16ToFp17(d1);
            vFloatType data2 = Fp16ToFp17(d2);

            m_data.data[i] = FpSub<vFloatExpoSize,vFloatMantSize>(data1,data2);
        } else {
            vInt16Type data1 = (vInt16Type)i_data.data[i-8];
            vInt16Type data2 = (vInt16Type)i_data.data[i];
            m_data.data[i] = IntSubExt<vInt16Size,vInt16Size,vInt17Size>(data1,data2);
        }
    }
    
    #ifdef HLS_TRACE
        cslDebug((30, "Matrix: after C^T "));
        for (int i=0; i<16; i++) {
            cslDebug((30, "0x%08x ", m_data.data[i].to_int()));
        }
        cslDebug((30, "\n"));
    #endif
    
    //=====================================================
    // M * C
    //=====================================================
    // 
    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    o_col0: 
    #endif
    for (int i=0; i<4; i++) {
        if (cfg_precision==ENUM_FP16) {
            vFloatType data1 = m_data.data[4*i];
            vFloatType data2 = m_data.data[4*i+2];

            f_data.data[4*i] = FpSub<vFloatExpoSize,vFloatMantSize>(data1,data2);
        } else {
            vInt17Type data1 = (vInt17Type)m_data.data[4*i];
            vInt17Type data2 = (vInt17Type)m_data.data[4*i+2];
            t_data.data[4*i] = IntSubExt<vInt17Size,vInt17Size,vInt18Size>(data1,data2);
        }
    }
    
    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    o_col1: 
    #endif
    for (int i=0; i<4; i++) {
        if (cfg_precision==ENUM_FP16) {
            vFloatType data1 = m_data.data[4*i+1];
            vFloatType data2 = m_data.data[4*i+2];

            f_data.data[4*i+1] = FpAdd<vFloatExpoSize,vFloatMantSize>(data1,data2);
        } else {
            vInt17Type data1 = (vInt17Type)m_data.data[4*i+1];
            vInt17Type data2 = (vInt17Type)m_data.data[4*i+2];
            t_data.data[4*i+1] = IntAddExt<vInt17Size,vInt17Size,vInt18Size>(data1,data2);
        }
    }
    
    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    o_col2: 
    #endif
    for (int i=0; i<4; i++) {
        if (cfg_precision==ENUM_FP16) {
            vFloatType data1 = m_data.data[4*i+2];
            vFloatType data2 = m_data.data[4*i+1];

            f_data.data[4*i+2] = FpSub<vFloatExpoSize,vFloatMantSize>(data1,data2);
        } else {
            vInt17Type data1 = (vInt17Type)m_data.data[4*i+2];
            vInt17Type data2 = (vInt17Type)m_data.data[4*i+1];
            t_data.data[4*i+2] = IntSubExt<vInt17Size,vInt17Size,vInt18Size>(data1,data2);
        }
    }
    
    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    o_col3:
    #endif
    for (int i=0; i<4; i++) {
        if (cfg_precision==ENUM_FP16) {
            vFloatType data1 = m_data.data[4*i+1];
            vFloatType data2 = m_data.data[4*i+3];

            f_data.data[4*i+3] = FpSub<vFloatExpoSize,vFloatMantSize>(data1,data2);
        } else {
            vInt17Type data1 = (vInt17Type)m_data.data[4*i+1];
            vInt17Type data2 = (vInt17Type)m_data.data[4*i+3];
            t_data.data[4*i+3] = IntSubExt<vInt17Size,vInt17Size,vInt18Size>(data1,data2);
        }
    }
    
    #ifdef HLS_TRACE
        if (cfg_precision==ENUM_FP16) {
            cslDebug((30, "Matrix: after C "));
            for (int i=0; i<16; i++) {
                cslDebug((30, "0x%08x ", f_data.data[i].to_int()));
            }
            cslDebug((30, "\n"));
        } else {
            cslDebug((30, "Matrix: after C "));
            for (int i=0; i<16; i++) {
                cslDebug((30, "0x%08x ", t_data.data[i].to_int()));
            }
            cslDebug((30, "\n"));
        }
    #endif
    
    //=====================================================
    // TRUNCATE
    //=====================================================
    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    data_truncate: 
    #endif
    for (int i=0; i<16; i++) {
        if (cfg_precision==ENUM_INT16) {
            //o_data.data[i]= IntTruncate<vInt18Size,vInt16Size,vTruncateSize>(t_data.data[i],cfg_truncate);
            o_data.data[i]= IntShiftRight<vInt18Size,vTruncateSize,vInt16Size>(t_data.data[i],cfg_truncate);
        } else if (cfg_precision==ENUM_INT8) {
            //o_data.data[i]= IntTruncate<vInt18Size,vInt8Size,vTruncateSize>(t_data.data[i],cfg_truncate);
            o_data.data[i]= IntShiftRight<vInt18Size,vTruncateSize,vInt8Size>(t_data.data[i],cfg_truncate);
        } else {
            o_data.data[i]= Fp17ToFp16(f_data.data[i]);
        }
    }
    
    chn_data_out.write(o_data);
}
