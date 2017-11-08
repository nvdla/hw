// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_y.cpp

#include "sdp.h"
#include "nvdla_float.h"

//   in (i32)-> MUL (i64)-> ALU(i65) -> TCT(i32) -> RELU(i32) -> out(i32)
//               ^           ^
//               | i32       | i32
//               C           C
//               ^           ^
//               | i16       | i16
#ifdef SYNTHESIS
#pragma hls_design block
#endif

void NV_NVDLA_SDP_CORE_Y_top (
          ac_channel<yDataInStruct> & chn_data_in
         ,ACINTF(1)         cfg_alu_bypass
         ,ACINTF(2)         cfg_alu_algo
         ,ACINTF(1)         cfg_mul_bypass
         ,yTruncateType     cfg_truncate
         ,ACINTF(1)         cfg_mul_prelu
         ,ACINTF(1)         cfg_nan_to_zero
         ,ACINTF(2)         cfg_precision
         
         ,ac_channel<eDataInStruct> & chn_alu_in
         ,eDataOutType  cfg_alu_op
         ,ACINTF(1)     cfg_alu_src
         ,ACINTF(1)     cfg_alu_cvt_bypass
         ,eAluOpType    cfg_alu_cvt_offset
         ,eMulOpType    cfg_alu_cvt_scale
         ,eTruncateType cfg_alu_cvt_truncate
         ,ac_channel<eDataInStruct> & chn_mul_in
         ,eDataOutType  cfg_mul_op
         ,ACINTF(1)     cfg_mul_src
         ,ACINTF(1)     cfg_mul_cvt_bypass
         ,eAluOpType    cfg_mul_cvt_offset
         ,eMulOpType    cfg_mul_cvt_scale
         ,eTruncateType cfg_mul_cvt_truncate
         
         ,yLutRegType     cfg_lut_le_start
         //,yLutRegType     cfg_lut_le_end
         ,yLutRegType     cfg_lut_lo_start
         //,yLutRegType     cfg_lut_lo_end
         ,yLutRegIdxType  cfg_lut_le_index_offset
         ,yLutRegIdxType  cfg_lut_le_index_select
         ,yLutRegIdxType  cfg_lut_lo_index_select
         ,ACINTF(1)       cfg_lut_le_function
         ,ACINTF(1)       cfg_lut_uflow_priority
         ,ACINTF(1)       cfg_lut_oflow_priority
         ,ACINTF(1)       cfg_lut_hybrid_priority
         ,ACINTF(1)       cfg_lut_bypass
         ,ac_channel<yLutOutStruct> & chn_lut_out
         ,ac_channel<yDataOutStruct> & chn_data_out
         )
{
        static ac_channel<eDataOutStruct> chn_alu_op;
        static ac_channel<eDataOutStruct> chn_mul_op;
        static ac_channel<yDataOutStruct> chn_lut_in;

        
        if (cfg_mul_src==SDP_MUL_SRC_DMA && (!cfg_mul_bypass) ) {
            NV_NVDLA_SDP_CORE_Y_cvt ( chn_mul_in ,cfg_mul_cvt_bypass, cfg_mul_cvt_offset ,cfg_mul_cvt_scale ,cfg_mul_cvt_truncate ,cfg_nan_to_zero, cfg_precision ,chn_mul_op);
        }
        
        if (cfg_alu_src==SDP_ALU_SRC_DMA && (!cfg_alu_bypass)) {
            NV_NVDLA_SDP_CORE_Y_cvt ( chn_alu_in ,cfg_alu_cvt_bypass, cfg_alu_cvt_offset ,cfg_alu_cvt_scale ,cfg_alu_cvt_truncate ,cfg_nan_to_zero, cfg_precision , chn_alu_op);
        }

        NV_NVDLA_SDP_CORE_Y_core ( chn_data_in ,chn_alu_op ,chn_mul_op ,cfg_alu_bypass ,cfg_alu_src, cfg_alu_op, cfg_alu_algo ,cfg_mul_bypass ,cfg_mul_src, cfg_mul_op,cfg_truncate ,cfg_mul_prelu, cfg_precision ,chn_lut_in);
        
        if (cfg_lut_bypass) {
            yDataOutStruct lut_in = chn_lut_in.read();
            yDataOutStruct data_out;
            for (int i=0; i<SPEED_Y; i++) {
                data_out.data[i] = lut_in.data[i];
            }
            chn_data_out.write(data_out);
        } else {
            NV_NVDLA_SDP_CORE_Y_idx ( chn_lut_in ,cfg_lut_le_start ,cfg_lut_lo_start ,cfg_lut_le_index_offset ,cfg_lut_le_index_select ,cfg_lut_lo_index_select ,cfg_lut_le_function ,cfg_lut_uflow_priority ,cfg_lut_oflow_priority ,cfg_lut_hybrid_priority ,cfg_precision, chn_lut_out);
        }
}
