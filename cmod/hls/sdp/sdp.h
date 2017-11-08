// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp.h

#ifndef _NVDLA_SDP_H_
#define _NVDLA_SDP_H_


#include "ac_int.h"
#include "ac_fixed.h"
#include "ac_channel.h"
#include "nvdla_float.h"

#ifdef HLS_TRACE
#include "log.h"
#endif

#define ENUM_INT8  0x0
#define ENUM_INT16 0x1
#define ENUM_FP16  0x2

//==========================================================
// B = 2^E/2-1
// D = 2^E/2-2
//NAN:      e=2^E-1 & f!=0.
//INF:      e=2^E-1 & f==0. 
//Denorm:   e==0 & f!=0. X=(-1)^s * 2^(0-D) * (0.f)
//0:        e==0 & f==0. X=(-1)^s0
//Norm:     e=(0,2^E-1). X=(-1)^s * 2^(e-B) * (1.f)
//==========================================================
//
// define the bus width between X->X->Y->C
#define SDP_DATAPATH_BUS_WIDTH      32


#define SDP_BS_MODE_ON     0
#define SDP_BS_MODE_BYPASS 1

#define SDP_ALU_SRC_REG      0x0
#define SDP_ALU_SRC_DMA      0x1

#define SDP_ALU_SHIFT_LEFT      0x0
#define SDP_ALU_SHIFT_RIGHT     0x1

#define SDP_ALU_MODE_MAX     0x0
#define SDP_ALU_MODE_MIN     0x1
#define SDP_ALU_MODE_SUM     0x2
#define SDP_ALU_MODE_EQL     0x3

#define SDP_MUL_SRC_REG      0x0
#define SDP_MUL_SRC_DMA      0x1

#define SDP_BS_MUL_BYPASS_NO  0x0
#define SDP_BS_MUL_BYPASS_YES 0x1

#define SDP_BS_RELU_BYPASS_NO   0x0
#define SDP_BS_RELU_BYPASS_YES  0x1

//#define ACINTT(x) ac_int<x,true>
//#define ACINTF(x) ac_int<x,false>

#define SignSize 1

//=============================================
// X part
//=============================================
#define xDataSize 32
#define xDataSignSize 1
#define xDataExpoSize 8
#define xDataMantSize 23

#define xOpSize 16
#define xOpSignSize 1
#define xOpExpoSize 5
#define xOpMantSize 10


// ALU
//#define xDataInExpoSize 8
//#define xDataInMantSize 23
#define xDataInSize 32
typedef ACINTT(xDataInSize) xDataType;

typedef ACINTT(xOpSize) xOpType;
typedef ACINTF(xOpSize) xOpTypeF;

typedef ACINTT(xDataInSize) xDataInType;
typedef ACINTF(xDataInSize) xDataInTypeF;
typedef struct { xDataInType data[16]; } xDataInStruct;

//#define xAluOpExpoSize 5
//#define xAluOpMantSize 10
#define xAluOpSize 16
typedef ACINTT(xAluOpSize) xAluOpType;
typedef ACINTF(xAluOpSize) xAluOpTypeF;
typedef struct { xAluOpType data[16]; } xAluOpStruct;

//#define AluOutExpoSize 9
//#define AluOutMantSize 23
#define xAluOutSize 33
typedef ACINTT(xAluOutSize) xAluOutType;
typedef ACINTF(xAluOutSize) xAluOutTypeF;
typedef struct { xAluOutType data[16]; } xAluOutStruct;

//#define xMulOpExpoSize 5
//#define xMulOpMantSize 10
#define xMulOpSize 16
typedef ACINTT(xMulOpSize) xMulOpType;
typedef ACINTF(xMulOpSize) xMulOpTypeF;
typedef struct { xMulOpType data[16]; } xMulOpStruct;

#define xMulOutSize 49
typedef ACINTT(xMulOutSize) xMulOutType;
typedef ACINTF(xMulOutSize) xMulOutTypeF;
typedef struct {
    xMulOutType data[16]; 
    ACINTF(1)   bypass_trt[16];
} xMulOutStruct;

// OUT (also used in RELU as RELU will NOT change type)
//#define xDataOutExpoSize 8
//#define xDataOutMantSize 23
#define xDataOutSize 32
typedef ACINTT(xDataOutSize) xDataOutType;
typedef ACINTF(xDataOutSize) xDataOutTypeF;
typedef struct { xDataOutType data[16]; } xDataOutStruct;

void NV_NVDLA_SDP_CORE_x (
          ac_channel<xDataInStruct> & chn_data_in
         ,ac_channel<xAluOpStruct> & chn_alu_op
         ,ac_channel<xMulOpStruct> & chn_mul_op
         ,xMulOpType cfg_mul_op
         ,xAluOpType cfg_alu_op
         ,ACINTF(1)  cfg_alu_bypass
         ,ACINTF(2)  cfg_alu_algo
         ,ACINTF(1)  cfg_alu_src
         ,ACINTF(6)  cfg_alu_shift_value
         ,ACINTF(1)  cfg_mul_bypass
         ,ACINTF(1)  cfg_mul_prelu
         ,ACINTF(1)  cfg_mul_src
         ,ACINTF(6)  cfg_mul_shift_value
         ,ACINTF(1)  cfg_relu_bypass
         ,ACINTF(1)  cfg_nan_to_zero
         ,ACINTF(2)  cfg_precision
         ,ac_channel<xDataOutStruct> & chn_data_out
         );

//=============================================
// Y part
//=============================================

#define SPEED_Y 4
#define yFloatSize 32
#define yFloatExpoSize 8
#define yFloatMantSize 23
typedef ACINTT(yFloatSize) yFloatType;
#define cFloatSize 32
#define cFloatExpoSize 8
#define cFloatMantSize 23
typedef ACINTT(cFloatSize) cFloatType;

#define Fp17Size 17
#define Fp17SignSize 1
#define Fp17ExpoSize 6
#define Fp17MantSize 10
typedef ACINTT(Fp17Size) Fp17Type;

#define Fp32Size 32
#define Fp32SignSize 1
#define Fp32ExpoSize 8
#define Fp32ExpoSizeT 9
#define Fp32MantSize 23
typedef ACINTT(Fp32Size) Fp32Type;

#define Fp16Size 16
#define Fp16ExpoSize 5
#define Fp16MantSize 10
typedef ACINTT(Fp16Size) Fp16Type;

#define yDataSize 32
#define yDataSignSize 1
#define yDataExpoSize 8
#define yDataMantSize 23
typedef ACINTT(yDataSize) yDataType;

#define yOpSize 16
#define yOpSignSize 1
#define yOpExpoSize 5
#define yOpMantSize 10

#define yDataInSize 32
typedef ACINTT(yOpSize)     yOpType;
typedef ACINTF(yOpSize)     yOpTypeF;

typedef ACINTT(yDataInSize) yDataInType;
typedef ACINTF(yDataInSize) yDataInTypeF;
typedef struct { yDataInType data[SPEED_Y]; } yDataInStruct;

#define yMulOpSize 32
typedef ACINTT(yMulOpSize) yMulOpType;
typedef ACINTF(yMulOpSize) yMulOpTypeF;
typedef struct { yMulOpType data[SPEED_Y]; } yMulOpStruct;
#define yMulOpDSize 32
typedef ACINTT(yMulOpDSize) yMulOpDType;
typedef ACINTF(yMulOpDSize) yMulOpDTypeF;
typedef struct { yMulOpDType data[SPEED_Y]; } yMulOpDStruct;

#define yMulMidSize yMulOpSize + yMulOpDSize // 32+32=64
typedef ACINTT(yMulMidSize) yMulMidType;
typedef ACINTF(yMulMidSize) yMulMidTypeF;
typedef struct { yMulMidType data[SPEED_Y]; } yMulMidStruct;

#define yAluOpSize 32
typedef ACINTT(yAluOpSize) yAluOpType;
typedef ACINTF(yAluOpSize) yAluOpTypeF;
typedef struct { yAluOpType data[SPEED_Y]; } yAluOpStruct;

#define yAluMidSize 33
typedef ACINTT(yAluMidSize) yAluMidType;
typedef ACINTF(yAluMidSize) yAluMidTypeF;
typedef struct { yAluMidType data[SPEED_Y]; } yAluMidStruct;

#define yTruncateSize 10
typedef ACINTT(yTruncateSize) yTruncateType;
typedef ACINTF(yTruncateSize) yTruncateTypeF;

// DataOut (also used in RELU as RELU will NOT change type)
#define yDataOutSize 32
typedef ACINTT(yDataOutSize) yDataOutType;
typedef ACINTF(yDataOutSize) yDataOutTypeF;
typedef struct { yDataOutType data[SPEED_Y]; } yDataOutStruct;

typedef struct { ACINTF(1) data[1]; } yBitStruct;

//=============================================
// LUT
//=============================================
#define LUT_LE_FUNCTION_EXPONENT 0x0
#define LUT_LE_FUNCTION_LINEAR   0x1

#define yLutTableLeDepth 65
#define yLutTableLoDepth 257

#define yLutTableLeID 0x0
#define yLutTableLoID 0x1

#define yLutRegSize 32
typedef ACINTT(yLutRegSize)  yLutRegType;
#define yLutSlopeScaleSize 16
typedef ACINTT(yLutSlopeScaleSize)  yLutSlopeScaleType;
#define yLutSlopeShiftSize 5
typedef ACINTT(yLutSlopeShiftSize)  yLutSlopeShiftType;
#define yLutRegIdxSize 8
typedef ACINTT(yLutRegIdxSize)  yLutRegIdxType;
typedef ACINTF(yLutRegIdxSize)  yLutRegIdxTypeF;
#define yLutInMaxSize 32 + 64
typedef ACINTT(yLutInMaxSize)  yLutInMaxType;
typedef ACINTF(yLutInMaxSize)  yLutInMaxTypeF;

#define yLutInSize 32
typedef ACINTT(yLutInSize)  yLutInType;
typedef ACINTF(yLutInSize)  yLutInTypeF;
#define yLutInPlusOneSize yLutInSize + 1
typedef ACINTT(yLutInPlusOneSize)  yLutInPlusOneType;

#define yLutMantSize 24
typedef ACINTF(yLutMantSize)  yLutMantType;

#define yLutFracSize 35 
typedef ACINTF(yLutFracSize)  yLutFracType;
#define yLutAddrSize 9
typedef ACINTF(yLutAddrSize)  yLutAddrType;

//typedef struct { 
//    yLutInType data[16];
//} yLutInStruct;

typedef struct {
    yLutFracType fraction[SPEED_Y];
    yLutInType   x[SPEED_Y];
    ACINTF(1)    oflow[SPEED_Y];
    ACINTF(1)    uflow[SPEED_Y];
    ACINTF(1)    ram_sel[SPEED_Y];
    yLutAddrType ram_addr[SPEED_Y];
    ACINTF(1)    le_hit[SPEED_Y];
    ACINTF(1)    lo_hit[SPEED_Y];
} yLutOutStruct;

#define yLutIndexSize 9
typedef ACINTT(yLutIndexSize)  yLutIndexType;
typedef ACINTF(yLutIndexSize)  yLutIndexTypeF;

#define yLutCoeffiSize 16
typedef ACINTF(yLutCoeffiSize)  yLutCoeffiType;

// Y_INP
#define yInpLutInSize 16
typedef ACINTT(yInpLutInSize)  yInpLutInType;
typedef ACINTF(yInpLutInSize)  yInpLutInTypeF;

#define yInpDataInSize 32
typedef ACINTT(yInpDataInSize)  yInpDataInType;
typedef ACINTF(yInpDataInSize)  yInpDataInTypeF;

#define yInpDataInP1Size yInpDataInSize + 2
typedef ACINTT(yInpDataInP1Size)  yInpDataInP1Type;

#define yInpDataMidSize yInpLutInSize + yInpDataInP1Size
typedef ACINTT(yInpDataMidSize)  yInpDataMidType;

#define yInpDataMidP1Size yInpDataMidSize + 1
typedef ACINTT(yInpDataMidP1Size)  yInpDataMidP1Type;

#define yInpDataFMidSize yLutFracSize + yInpDataInP1Size
typedef ACINTT(yInpDataFMidSize)  yInpDataFMidType;

#define yInpOutSize 32
typedef ACINTT(yInpOutSize)  yInpOutType;

typedef struct { 
    yInpDataInType      x[SPEED_Y];
    yLutFracType        fraction[SPEED_Y];
    yInpLutInType       y0[SPEED_Y];
    yInpLutInType       y1[SPEED_Y];
    yLutSlopeScaleType  scale[SPEED_Y];
    yLutSlopeShiftType  shift[SPEED_Y];
    yInpDataInType      offset[SPEED_Y];
    yInpDataInTypeF     bias[SPEED_Y];
    ACINTF(1)           flow[SPEED_Y];
} yInpInStruct;

typedef struct { 
    yInpOutType data[SPEED_Y];
} yInpOutStruct;


//=============================================
// CVT
//=============================================
#define yCvtInSize 32
typedef ACINTT(yCvtInSize)  yCvtInType;

#define yCvtAluOpSize 32
typedef ACINTT(yCvtAluOpSize) yCvtAluOpType;
#define yCvtAluOutSize 33
typedef ACINTT(yCvtAluOutSize) yCvtAluOutType;

#define yCvtMulOpSize 16
typedef ACINTT(yCvtMulOpSize) yCvtMulOpType;
#define yCvtMulOpDSize 32
typedef ACINTT(yCvtMulOpDSize) yCvtMulOpDType;
#define yCvtMulOutSize 49
typedef ACINTT(yCvtMulOutSize) yCvtMulOutType;

#define yCvtTruncateSize 10
typedef ACINTT(yCvtTruncateSize) yCvtTruncateType;
#define yCvtOutSize 32
typedef ACINTT(yCvtOutSize) yCvtOutType;

//=============================================
// C part
//=============================================
// SDP_C
#define cDataInSize 32
typedef ACINTT(cDataInSize) cDataInType;
typedef ACINTF(cDataInSize) cDataInTypeF;
typedef struct { cDataInType data[16]; } cDataInStruct;


#define cAluOpSize 32
typedef ACINTT(cAluOpSize) cAluOpType;
typedef ACINTF(cAluOpSize) cAluOpTypeF;
typedef struct { cAluOpType data[16]; } cAluOpStruct;

#define cAluOutSize 33
typedef ACINTT(cAluOutSize) cAluOutType;
typedef ACINTF(cAluOutSize) cAluOutTypeF;
typedef struct { cAluOutType data[16]; } cAluOutStruct;

#define cMulOpSize 16
typedef ACINTT(cMulOpSize) cMulOpType;
typedef ACINTF(cMulOpSize) cMulOpTypeF;
typedef struct { cMulOpType data[16]; } cMulOpStruct;

#define cMulOutSize 49
typedef ACINTT(cMulOutSize) cMulOutType;
typedef ACINTF(cMulOutSize) cMulOutTypeF;
typedef struct { cMulOutType data[16]; } cMulOutStruct;

#define cTruncateSize 6
typedef ACINTF(cTruncateSize) cTruncateType;

#define cTrunOutSize 17
typedef ACINTT(cTrunOutSize) cTrunOutType;
typedef ACINTF(cTrunOutSize) cTrunOutTypeF;
typedef struct { cTrunOutType data[16]; } cTrunOutStruct;

#define cDataOutSize 16
typedef ACINTT(cDataOutSize) cDataOutType;
typedef ACINTF(cDataOutSize) cDataOutTypeF;

#define cDataOutHSize 8
typedef ACINTT(cDataOutHSize) cDataOutHType;

#define cSatSize 1
typedef ACINTF(cSatSize) cSatType;
typedef struct { 
    cDataOutType data[16]; 
    cSatType sat[16]; 
} cDataOutStruct;

void NV_NVDLA_SDP_CORE_c (
                 ac_channel<cDataInStruct> & chn_in
                ,cAluOpType cfg_offset
                ,cMulOpType cfg_scale
                ,cTruncateType  cfg_shift
                ,ACINTF(2)  cfg_proc_precision
                ,ACINTF(2)  cfg_out_precision
                ,ACINTF(1)  cfg_mode_eql
                ,ac_channel<cDataOutStruct> & chn_out
                );
//=============================================
// Y_cvt part
//=============================================
// SDP_Y_CVT
#define eDataInSize 16
typedef ACINTT(eDataInSize) eDataInType;
typedef ACINTF(eDataInSize) eDataInTypeF;
typedef struct { eDataInType data[SPEED_Y]; } eDataInStruct;

#define eAluOpSize 32
typedef ACINTT(eAluOpSize) eAluOpType;
typedef ACINTF(eAluOpSize) eAluOpTypeF;
typedef struct { eAluOpType data[SPEED_Y]; } eAluOpStruct;

#define eAluOutSize 33
typedef ACINTT(eAluOutSize) eAluOutType;
typedef ACINTF(eAluOutSize) eAluOutTypeF;
typedef struct { eAluOutType data[SPEED_Y]; } eAluOutStruct;

#define eMulOpSize 16
typedef ACINTT(eMulOpSize) eMulOpType;
typedef ACINTF(eMulOpSize) eMulOpTypeF;
typedef struct { eMulOpType data[SPEED_Y]; } eMulOpStruct;

#define eMulOutSize eAluOutSize + eMulOpSize // 49
typedef ACINTT(eMulOutSize) eMulOutType;
typedef ACINTF(eMulOutSize) eMulOutTypeF;
typedef struct { eMulOutType data[SPEED_Y]; } eMulOutStruct;

#define eTruncateSize 6
typedef ACINTT(eTruncateSize) eTruncateType;
typedef ACINTF(eTruncateSize) eTruncateTypeF;

#define eDataOutSize 32
typedef ACINTT(eDataOutSize) eDataOutType;
typedef ACINTF(eDataOutSize) eDataOutTypeF;
typedef struct { eDataOutType data[SPEED_Y]; } eDataOutStruct;

void NV_NVDLA_SDP_CORE_Y_cvt (
          ac_channel<eDataInStruct> & chn_in
         ,ACINTF(1)     cfg_bypass
         ,eAluOpType    cfg_offset
         ,eMulOpType    cfg_scale
         ,eTruncateType cfg_truncate
         ,ACINTF(1)     cfg_nan_to_zero
         ,ACINTF(2)     cfg_precision
         ,ac_channel<eDataOutStruct> & chn_out
         );

void NV_NVDLA_SDP_CORE_Y_core (
          ac_channel<yDataInStruct> & chn_data_in
         ,ac_channel<eDataOutStruct> & chn_alu_op
         ,ac_channel<eDataOutStruct> & chn_mul_op
         ,ACINTF(1)         cfg_alu_bypass
         ,ACINTF(1)         cfg_alu_src
         ,eDataOutType      cfg_alu_op
         ,ACINTF(2)         cfg_alu_algo
         ,ACINTF(1)         cfg_mul_bypass
         ,ACINTF(1)         cfg_mul_src
         ,eDataOutType      cfg_mul_op
         ,yTruncateType     cfg_truncate
         ,ACINTF(1)         cfg_mul_prelu
         ,ACINTF(2)         cfg_precision
         ,ac_channel<yDataOutStruct> & chn_data_out
         );

void NV_NVDLA_SDP_CORE_Y_idx (
          ac_channel<yDataOutStruct> & chn_lut_in
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
         ,ACINTF(2)       cfg_precision
         ,ac_channel<yLutOutStruct> & chn_lut_out
         );

void NV_NVDLA_SDP_CORE_Y_inp (
          ac_channel<yInpInStruct>  & chn_inp_in
         ,ACINTF(2)  cfg_precision
         ,ac_channel<yInpOutStruct> & chn_inp_out
         );

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
         ,eDataOutType  cfg_alu_in
         ,ACINTF(1)     cfg_alu_src
         ,ACINTF(1)     cfg_alu_cvt_bypass
         ,eAluOpType    cfg_alu_cvt_offset
         ,eMulOpType    cfg_alu_cvt_scale
         ,eTruncateType cfg_alu_cvt_truncate
         ,ac_channel<eDataInStruct> & chn_mul_in
         ,eDataOutType  cfg_mul_in
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
         );

template <unsigned int ExpoWidth, unsigned int MantWidth >
ACINTT(1+ExpoWidth+MantWidth) FpAlu (
      ACINTF(2) mode
     ,ACINTT(1+ExpoWidth+MantWidth) a
     ,ACINTT(1+ExpoWidth+MantWidth) b
    ) {

    typedef ACINTT(1+ExpoWidth+MantWidth) sT;
    sT o;

    if (mode==SDP_ALU_MODE_SUM) {
        o = FpAdd<ExpoWidth,MantWidth>(a,b);
    } else if (mode==SDP_ALU_MODE_MAX) {
        o = FpMax<ExpoWidth,MantWidth>(a,b);
    } else if (mode==SDP_ALU_MODE_EQL) {
        o = !FpEql<ExpoWidth,MantWidth>(a,b);
    } else {
        o = FpMin<ExpoWidth,MantWidth>(a,b);
    }

    return o;
}

void NV_shift (
          ac_channel<ACINTT(8)> & chn_inp_in
         ,ACINTF(3)   shift
         ,ac_channel<ACINTT(4)> & chn_inp_out
         );
#endif
