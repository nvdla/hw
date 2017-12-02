// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_y_core.cpp

#include "sdp.h"
#include "nvdla_float.h"

//   in (i32)-> MUL (i64)-> ALU(i65) -> TCT(i32) -> RELU(i32) -> out(i32)
//               ^           ^
//               | i32       | i32
//               C           C
//               ^           ^
//               | i16       | i16
                
#ifdef HLS_TRACE
static int hls_call_iter = 1;
#endif

#ifdef SYNTHESIS
#pragma hls_design block
#endif
void Y_alu (
          ac_channel<yDataOutStruct> & chn_alu_in
         ,ac_channel<eDataOutStruct> & chn_alu_op
         ,ACINTF(1)         cfg_alu_bypass
         ,ACINTF(1)         cfg_alu_src
         ,eDataOutType      cfg_alu_op
         ,ACINTF(2)         cfg_alu_algo
         ,ACINTF(2)         cfg_precision
         ,ac_channel<yDataOutStruct> & chn_alu_out
         )
{
    yDataOutStruct AluIn = chn_alu_in.read();
    yDataOutStruct AluOut;
        
    #ifdef HLS_TRACE
        cslDebug((30, "ALU-IN:  "));
        for (int i=0; i<SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", AluIn.data[i].to_int()));
        }
        cslDebug((30, "\n"));
    #endif
        
    if (cfg_alu_bypass) {
        #ifdef SYNTHESIS
        #pragma hls_unroll yes
        alu_loop_bypass: 
        #endif
        for (int i=0; i<SPEED_Y; i++) {
            if (cfg_precision==ENUM_FP16) {
                AluOut.data[i] = AluIn.data[i];
            } else {
                AluOut.data[i] = AluIn.data[i];
            }
        }
    } else {
        eDataOutStruct AluOp;
        if (cfg_alu_src==SDP_ALU_SRC_REG) {
            #ifdef SYNTHESIS
            #pragma hls_unroll yes
            alu_loop_src_reg: 
            #endif
            for (int i=0; i<SPEED_Y; i++) {
                AluOp.data[i] = cfg_alu_op;
            }
        } else {
            AluOp = chn_alu_op.read();
        }
    
        #ifdef HLS_TRACE
            cslDebug((30, "ALU-OP:  "));
            for (int i=0; i<SPEED_Y; i++) {
                cslDebug((30, "0x%08x ", AluOp.data[i].to_int()));
            }
            cslDebug((30, "\n"));
        #endif
    
        #ifdef SYNTHESIS
        #pragma hls_unroll yes
        alu_loop_op: 
        #endif
        for (int i=0; i<SPEED_Y; i++) {
            if (cfg_precision==ENUM_FP16) {
                // Op * Data
                yFloatType a = AluIn.data[i].slc<Fp32Size>(0);
                yFloatType b = AluOp.data[i].slc<Fp32Size>(0);
                yFloatType o = FpAlu<yDataExpoSize,yDataMantSize>(cfg_alu_algo,a,b);
                AluOut.data[i] = o;
            } else {
                yAluMidType a = AluIn.data[i];
                yAluMidType b = AluOp.data[i];
                yAluMidType o;

                if (cfg_alu_algo==SDP_ALU_MODE_MAX) {
                    o = (a > b) ? a : b;
                } else if (cfg_alu_algo==SDP_ALU_MODE_MIN) {
                    o = (a < b) ? a : b;
                } else if (cfg_alu_algo==SDP_ALU_MODE_EQL) {
                    o = (a == b) ? 0 : 1;
                } else {
                    o =  a + b;
                }

                // Saturation
                AluOut.data[i] = IntSaturation<yAluMidSize,yDataOutSize>(o);
            }
        }
    
    }
    #ifdef HLS_TRACE
        cslDebug((30, "ALU-OUT: "));
        for (int i=0; i<SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", AluOut.data[i].to_int()));
        }
        cslDebug((30, "\n"));
    #endif
        
    chn_alu_out.write(AluOut);
}

#ifdef SYNTHESIS
#pragma hls_design block
#endif
void Y_mul (
          ac_channel<yDataInStruct> & chn_mul_in
         ,ac_channel<eDataOutStruct> & chn_mul_op
         ,ACINTF(1)         cfg_mul_bypass
         ,ACINTF(1)         cfg_mul_prelu
         ,ACINTF(1)         cfg_mul_src
         ,eDataOutType      cfg_mul_op
         ,yTruncateType     cfg_truncate
         ,ACINTF(2)         cfg_precision
         ,ac_channel<yDataOutStruct> & chn_mul_out
         )
{

    //chn_mul_out.write(MulOut);

    yDataInStruct MulIn = chn_mul_in.read();
    yDataOutStruct MulOut;
    if (cfg_mul_bypass) {
        #ifdef SYNTHESIS
        #pragma hls_unroll yes
        mul_loop_bypass: 
        #endif
        for (int i=0; i<SPEED_Y; i++) {
            if (cfg_precision==ENUM_FP16) {
                MulOut.data[i].set_slc(0,MulIn.data[i]);
            } else {
                MulOut.data[i] = MulIn.data[i];
            }
        }
    } else {
        // op mux: from mem or reg
        eDataOutStruct MulOp;
        if (cfg_mul_src==SDP_MUL_SRC_REG) {
            #ifdef SYNTHESIS
            #pragma hls_unroll yes
            mul_loop_src_reg: 
            #endif
            for (int i=0; i<SPEED_Y; i++) {
                MulOp.data[i] = cfg_mul_op;
            }
        } else {
            MulOp = chn_mul_op.read();
        }
        
        #ifdef HLS_TRACE
            cslDebug((30, "MUL-IN: "));
            for (int i=0; i<SPEED_Y; i++) {
                cslDebug((30, "0x%08x ", MulIn.data[i].to_int()));
            }
            cslDebug((30, "\n"));
            cslDebug((30, "MUL-OP: "));
            for (int i=0; i<SPEED_Y; i++) {
                cslDebug((30, "0x%08x ", MulOp.data[i].to_int()));
            }
            cslDebug((30, "\n"));
        #endif
    

        //Convert from fp16->(-,*,t)->fp32
        // multiple
        yMulMidStruct MulMid;
        #ifdef SYNTHESIS
        #pragma hls_unroll yes
        mul_mul:
        #endif
        for (int i=0; i<SPEED_Y; i++) {
            ACINTF(1) sign = MulIn.data[i].slc<1>(yDataInSize-1);
            if (cfg_mul_prelu && sign==0) {
                MulMid.data[i] = MulIn.data[i];
                MulOut.data[i] = MulMid.data[i];
            } else {
                if (cfg_precision==ENUM_FP16) {
                    // fp32*fp32
                    MulMid.data[i] = FpMul<yDataExpoSize,yDataMantSize>(MulIn.data[i],MulOp.data[i]);
                    MulOut.data[i] = MulMid.data[i];
                } else {
                    MulMid.data[i] = IntMulExt<yDataInSize,yMulOpSize,yMulMidSize>(MulIn.data[i],MulOp.data[i]);
                    MulOut.data[i] = IntShiftRight<yMulMidSize,yTruncateSize,yDataOutSize>(MulMid.data[i],cfg_truncate);
                }
            }
        }
    
        #ifdef HLS_TRACE
            cslDebug((30, "MUL-OUT: "));
            for (int i=0; i<SPEED_Y; i++) {
                cslDebug((30, "0x%08x ", MulOut.data[i].to_int()));
            }
            cslDebug((30, "\n"));
        #endif
    }

    chn_mul_out.write(MulOut);
}

// define the top level of sdp for hls
#ifdef SYNTHESIS
#pragma hls_design top
#endif
void NV_NVDLA_SDP_CORE_Y_core (
          ac_channel<yDataInStruct>  & chn_data_in
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
         )
{
        
        #ifdef HLS_TRACE
            cslDebug((30, "%s call NV_NVDLA_SDP_CORE_Y_core on %d iter\n", "HLS_CALL", hls_call_iter++));
            cslDebug((30, "CONFIG: "));
            cslDebug((30, "\n"));
            cslDebug((30, "cfg_alu_bypass:0x%08x ", cfg_alu_bypass.to_int()));
            cslDebug((30, "\n"));
            cslDebug((30, "cfg_alu_src:0x%08x ", cfg_alu_src.to_int()));
            cslDebug((30, "\n"));
            cslDebug((30, "cfg_alu_op:0x%08x ", cfg_alu_op.to_int()));
            cslDebug((30, "\n"));
            cslDebug((30, "cfg_alu_algo:0x%08x ", cfg_alu_algo.to_int()));
            cslDebug((30, "\n"));
            cslDebug((30, "cfg_mul_bypass:0x%08x ", cfg_mul_bypass.to_int()));
            cslDebug((30, "\n"));
            cslDebug((30, "cfg_mul_src:0x%08x ", cfg_mul_src.to_int()));
            cslDebug((30, "\n"));
            cslDebug((30, "cfg_mul_op:0x%08x ", cfg_mul_op.to_int()));
            cslDebug((30, "\n"));
            cslDebug((30, "cfg_truncate:0x%08x ", cfg_truncate.to_int()));
            cslDebug((30, "\n"));
            cslDebug((30, "cfg_mul_prelu:0x%08x ", cfg_mul_prelu.to_int()));
            cslDebug((30, "\n"));
            cslDebug((30, "cfg_precision:0x%08x ", cfg_precision.to_int()));
            cslDebug((30, "\n"));
        #endif

        static ac_channel<yDataOutStruct>  chn_mul_out;

        Y_mul ( chn_data_in, chn_mul_op,  cfg_mul_bypass, cfg_mul_prelu, cfg_mul_src, cfg_mul_op, cfg_truncate, cfg_precision, chn_mul_out);

        Y_alu ( chn_mul_out, chn_alu_op,   cfg_alu_bypass, cfg_alu_src, cfg_alu_op, cfg_alu_algo, cfg_precision, chn_data_out );
}
