// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_x.cpp

#include "sdp.h"
#include "nvdla_float.h"

//  (in) -> ALU -> MUL -> RELU -> (out)
//           ^      ^
//           |      |
//          (in)   (in)

// FP
//  (in)fp32 -> ALU (fp33)-> MUL -> RELU -> (out)
//           ^                ^
//           | fp19           | fp16
//          LS                |
//           ^                |
//           | fp16           |


#ifdef SYNTHESIS
#pragma hls_design block
#endif
void X_alu (
          ac_channel<xDataInStruct> & chn_alu_in
         ,ac_channel<xAluOpStruct> & chn_alu_op
         ,xAluOpType cfg_alu_op
         ,ACINTF(1) cfg_alu_bypass
         ,ACINTF(2) cfg_alu_algo
         ,ACINTF(1) cfg_alu_src
         ,ACINTF(6) cfg_alu_shift_value
         ,ACINTF(1) cfg_nan_to_zero
         ,ACINTF(2) cfg_precision
         ,ac_channel<xAluOutStruct> & chn_alu_out
         )
{
    xDataInStruct AluIn = chn_alu_in.read();
    xAluOutStruct AluOut;

        
        if (cfg_alu_bypass) {
            #ifdef SYNTHESIS
            #pragma hls_unroll yes
            alu_loop_bypass: 
            #endif
            for (int i=0; i<16; i++) {
                if (cfg_precision==ENUM_FP16) {
                    AluOut.data[i] = AluIn.data[i];
                } else {
                    AluOut.data[i] = (xAluOutType) (AluIn.data[i]);
                }
            }
        } else {
            xAluOpStruct AluOp;
            if (cfg_alu_src) {
                AluOp = chn_alu_op.read();
            } else {
                #ifdef SYNTHESIS
                #pragma hls_unroll yes
                alu_loop_cfg: 
                #endif
                for (int i=0; i<16; i++) {
                    AluOp.data[i] = cfg_alu_op;
                }
            }

            // NAN FLush to Zero
            if (cfg_precision==ENUM_FP16) {
                #ifdef SYNTHESIS
                #pragma hls_unroll yes
                alu_nan_to_zero: 
                #endif
                for (int i=0; i<16; i++) {
                    // INF to MAX
                    //xOpType op_bits = Fp16ToFp16(AluOp.data[i]);
                    xOpType op_bits = AluOp.data[i];


                    // NAN flush
                    ACINTF(xOpMantSize) op_mant;
                    ACINTF(xOpExpoSize) op_expo;
                    ACINTF(xOpSignSize) op_sign;


                    FpSignedBitsToFloat<xOpExpoSize,xOpMantSize>(op_bits,op_sign,op_expo,op_mant);
                    
                    bool is_nan = IsNaN<xOpExpoSize,xOpMantSize>(op_expo,op_mant);
                    if (cfg_nan_to_zero && is_nan) {
                        op_sign = 0;
                        op_expo = 0;
                        op_mant = 0;
                    }
                    AluOp.data[i] = FpFloatToSignedBits<xOpExpoSize,xOpMantSize>(op_sign,op_expo,op_mant);
                }
            }

            #ifdef SYNTHESIS
            #pragma hls_unroll yes
            alu_loop_op: 
            #endif
            for (int i=0; i<16; i++) {
                if (cfg_precision==ENUM_FP16) {
                    // operand shift: fp16->fp19->fp32
                    // OP: fp16-fp32
                    xDataType alu_op = Fp16ToFp32(AluOp.data[i]);

                    // CFG: shift_value -> fp32
                    //ACINTF(1) cfg_alu_shift_sign = (ACINTF(1))0;
                    //ACINTF(xDataExpoSize) cfg_alu_shift_expo = cfg_alu_shift_value;
                    //ACINTF(xDataMantSize) cfg_alu_shift_mant = (xDataMantSize)0;
                    //xDataType cfg_alu_shift = FpFloatToSignedBits<xDataExpoSize,xDataMantSize>(cfg_alu_shift_sign,cfg_alu_shift_expo,cfg_alu_shift_mant);

                    // OP:Shift
                    //xDataType AluOp = FpMul<xDataExpoSize,xDataMantSize>(alu_op_ext,cfg_alu_shift_value);

                    // Op * Data
                    AluOut.data[i] = FpAlu<xDataExpoSize,xDataMantSize>(cfg_alu_algo,AluIn.data[i],alu_op);

                } else {
                    xDataInType operand = IntShiftLeft<xAluOpSize,6,xDataInSize>(AluOp.data[i],cfg_alu_shift_value);

                    if (cfg_alu_algo==SDP_ALU_MODE_MAX) {
                        AluOut.data[i] = (AluIn.data[i] > operand) ? AluIn.data[i] : operand;
                    } else if (cfg_alu_algo==SDP_ALU_MODE_MIN) {
                        AluOut.data[i] = (AluIn.data[i] < operand) ? AluIn.data[i] : operand;
                    } else {
                        AluOut.data[i] = AluIn.data[i] + operand;
                    }
                }
            }
        }
    chn_alu_out.write(AluOut);
}

// out = min (0,in)
// (multiple -> shift), with bypass
// multiple: 32b x 16b -> 48b
// shift 48b -> 48b, with quantization (trancate and rounding) and overflow (saturation) support
#ifdef SYNTHESIS
#pragma hls_design block
#endif
void X_mul (
          ac_channel<xAluOutStruct> & chn_mul_in
         ,ac_channel<xMulOpStruct> & chn_mul_op
         ,xMulOpType cfg_mul_op
         ,ACINTF(1) cfg_mul_bypass
         ,ACINTF(1) cfg_mul_prelu
         ,ACINTF(1) cfg_mul_src
         ,ACINTF(1) cfg_nan_to_zero
         ,ACINTF(2) cfg_precision
         ,ac_channel<xMulOutStruct> & chn_mul_out
         )
{
    xAluOutStruct MulIn = chn_mul_in.read();
    xMulOutStruct MulOut;

    if (cfg_mul_bypass) {
        #ifdef SYNTHESIS
        #pragma hls_unroll yes
        mul_loop_bypass: 
        #endif
        for (int i=0; i<16; i++) {
            MulOut.data[i] = MulIn.data[i];
            MulOut.bypass_trt[i] = 0;
        }

    } else {
        
        // op mux: from mem or reg
        xMulOpStruct MulOp;
        if (cfg_mul_src==SDP_MUL_SRC_REG) {
            #ifdef SYNTHESIS
            #pragma hls_unroll yes
            mul_loop_reg: 
            #endif
            for (int i=0; i<16; i++) {
                MulOp.data[i] = cfg_mul_op;
            }
        } else {
            MulOp = chn_mul_op.read();
        }
                
        if (cfg_precision==ENUM_FP16) {
            #ifdef SYNTHESIS
            #pragma hls_unroll yes
            mul_nan_to_zero: 
            #endif
            for (int i=0; i<16; i++) {
                // INF to MAX
                //xOpType op_bits = Fp16ToFp16(MulOp.data[i]);
                xOpType op_bits = MulOp.data[i];

                // NAN flush
                ACINTF(xOpMantSize) op_mant;
                ACINTF(xOpExpoSize) op_expo;
                ACINTF(xOpSignSize) op_sign;

                FpSignedBitsToFloat<xOpExpoSize,xOpMantSize>(op_bits,op_sign,op_expo,op_mant);

                bool is_nan = IsNaN<xOpExpoSize,xOpMantSize>(op_expo,op_mant);
                //bool is_nan = (op_expo.and_reduce()==1) && (op_mant.or_reduce()!=0);
                if (cfg_nan_to_zero && is_nan) {
                    op_sign = 0;
                    op_expo = 0;
                    op_mant = 0;
                }

                MulOp.data[i] = FpFloatToSignedBits<xOpExpoSize,xOpMantSize>(op_sign,op_expo,op_mant);
            }
        }
        
        // multiple
        // xMulShiftStruct MulShift;
        #ifdef SYNTHESIS
        #pragma hls_unroll yes
        mul_loop_mul: 
        #endif
        for (int i=0; i<16; i++) {
            if (cfg_precision==ENUM_FP16) {

                ACINTF(1) sign = MulIn.data[i].slc<1>(Fp32Size-1);
                // fp32*fp32
                if (cfg_mul_prelu && sign==0) {
                    MulOut.data[i] = MulIn.data[i];
                } else {
                    xDataType mul_op_ext = Fp16ToFp32(MulOp.data[i]);
                    MulOut.data[i] = FpMul<xDataExpoSize,xDataMantSize>(MulIn.data[i],mul_op_ext);
                }

            } else {
                ACINTF(1) sign = MulIn.data[i].slc<1>(xAluOutSize-1);
                if (cfg_mul_prelu && sign==0) {
                    MulOut.data[i] = MulIn.data[i];
                    MulOut.bypass_trt[i] = 1;
                } else {
                    MulOut.data[i] = MulIn.data[i] * MulOp.data[i];
                    MulOut.bypass_trt[i] = 0;
                    
                    //xMulShiftType MulShift;
                    //MulOut.data[i] = (xDataOutType) (MulShift>>cfg_mul_shift_value);
                    //MulOut.data[i] = IntSignedShiftRight<xMulShiftSize,6,xDataOutSize>(MulShift,cfg_mul_shift_value);
                }
            }
        }
    }
    
    chn_mul_out.write(MulOut);
}

#ifdef SYNTHESIS
#pragma hls_design block
#endif
void X_trt (
          ac_channel<xMulOutStruct> & chn_trt_in
         ,ACINTF(6) cfg_mul_shift_value
         ,ACINTF(1)  cfg_mul_prelu
         ,ACINTF(2) cfg_precision
         ,ac_channel<xDataOutStruct> & chn_trt_out
         )
{
    xMulOutStruct TrtIn = chn_trt_in.read();
    xDataOutStruct TrtOut;

    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    trt_loop: 
    #endif
    for (int i=0; i<16; i++) {
        if (cfg_precision==ENUM_FP16) {
            TrtOut.data[i] = TrtIn.data[i];
        } else {
            if (TrtIn.bypass_trt[i]) {
                TrtOut.data[i] = TrtIn.data[i];
            } else {
                TrtOut.data[i] = IntShiftRight<xMulOutSize,6,xDataOutSize>(TrtIn.data[i],cfg_mul_shift_value);
            }
        }
    }

    chn_trt_out.write(TrtOut);
}

#ifdef SYNTHESIS
#pragma hls_design block
#endif
void X_relu (
          ac_channel<xDataOutStruct> & chn_relu_in
         ,ACINTF(1) cfg_relu_bypass
         ,ACINTF(2) cfg_precision
         ,ac_channel<xDataOutStruct> & chn_relu_out
                )
{
    
    xDataOutStruct idata = chn_relu_in.read();
    xDataOutStruct odata;
        
    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    relu_loop: 
    #endif
    for (int i=0; i<16; i++) {
        if (cfg_relu_bypass) {
            odata.data[i] =  idata.data[i];
        } else {
            if (cfg_precision==ENUM_FP16) {
                odata.data[i] = FpRelu<xDataExpoSize,xDataMantSize>(idata.data[i]);
            } else {
                odata.data[i] = (idata.data[i] > 0) ? idata.data[i] : (xDataOutType) 0;
            }
        }
    }

    chn_relu_out.write(odata);
}

// define the top level of sdp for hls
#ifdef SYNTHESIS
#pragma hls_design top
#endif
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
         )
{
        
        static ac_channel<xAluOutStruct> chn_alu_out;
        static ac_channel<xMulOutStruct> chn_mul_out;
        static ac_channel<xDataOutStruct> chn_trt_out;
        X_alu (
                  chn_data_in
                 ,chn_alu_op
                 ,cfg_alu_op
                 ,cfg_alu_bypass
                 ,cfg_alu_algo
                 ,cfg_alu_src
                 ,cfg_alu_shift_value
                 ,cfg_nan_to_zero
                 ,cfg_precision
                 ,chn_alu_out
                 );

        X_mul (
                  chn_alu_out
                 ,chn_mul_op
                 ,cfg_mul_op
                 ,cfg_mul_bypass
                 ,cfg_mul_prelu
                 ,cfg_mul_src
                 ,cfg_nan_to_zero
                 ,cfg_precision
                 ,chn_mul_out
                 );
        
        X_trt (
                  chn_mul_out
                 ,cfg_mul_shift_value
                 ,cfg_mul_prelu
                 ,cfg_precision
                 ,chn_trt_out
                 );

        X_relu (
                  chn_trt_out
                 ,cfg_relu_bypass
                 ,cfg_precision
                 ,chn_data_out
                 );
}
