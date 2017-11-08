// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_y_inp.cpp

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
#pragma hls_design top
#endif
void NV_NVDLA_SDP_CORE_Y_inp (
          ac_channel<yInpInStruct>  & chn_inp_in
         ,ACINTF(2)  cfg_precision
         ,ac_channel<yInpOutStruct> & chn_inp_out
         )
{
    #ifdef HLS_TRACE
        cslDebug((30, "%s call NV_NVDLA_SDP_CORE_Y_inp on %d iter\n", "HLS_CALL", hls_call_iter++));
    #endif

    yInpInStruct inp_in = chn_inp_in.read();
    yInpOutStruct inp_out;
    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    inp_lookup:
    #endif
    for (int i=0; i<SPEED_Y; i++) {
        
        if (inp_in.flow[i]) {
            if (cfg_precision==ENUM_FP16) {
                //Fp17Type x = Fp32ToFp17(inp_in.x[i]);
                //Fp32Type a = FpSub<Fp17ExpoSize,Fp32MantSize>(inp_in.x[i],inp_in.offset[i]);
                //
                //Fp17Type bias   = Fp32ToFp17(inp_in.bias[i]);
                //Fp17Type offset = Fp32ToFp17(inp_in.offset[i]);
                
                //Fp17Type ob = Fp17Add(offset,bias);

                //Fp17Type a = Fp17Sub(x,ob);
                
                Fp32Type bias   = (inp_in.bias[i]);
                Fp32Type offset = (inp_in.offset[i]);
                Fp32Type ob = Fp32Add(offset,bias);
                
                Fp32Type x = (inp_in.x[i]);
                Fp32Type xob = Fp32Sub(x,ob);
                Fp17Type a = Fp32ToFp17(xob);

                Fp17Type scale = Fp16ToFp17(inp_in.scale[i]);
                Fp17Type b = Fp17Mul(a,scale);

                Fp17Type y = Fp16ToFp17(inp_in.y0[i]);
                Fp17Type o = Fp17Add(y,b); //stepheng. 20170515
                
                #ifdef HLS_TRACE
                    cslDebug((30, "Inp.x.fp32 %d:", i));
                    cslDebug((30, "0x%08x ", x.to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "Inp.bias.fp32 %d:", i));
                    cslDebug((30, "0x%08x ", bias.to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "Inp.offset.fp32 %d:", i));
                    cslDebug((30, "0x%08x ", offset.to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "Inp.offset+bias.fp32 %d:", i));
                    cslDebug((30, "0x%08x ", ob.to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "Inp.x-(offset+bias).fp32 %d:", i));
                    cslDebug((30, "0x%08x ", xob.to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "Inp.scale.fp17 %d:", i));
                    cslDebug((30, "0x%08x ", scale.to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "Inp.(x-(offset+bias)) x scale.fp17 %d:", i));
                    cslDebug((30, "0x%08x ", b.to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "Inp.y.fp17 %d:", i));
                    cslDebug((30, "0x%08x ", y.to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "Inp.out.fp17 %d:", i));
                    cslDebug((30, "0x%08x ", o.to_int()));
                    cslDebug((30, "\n"));
                #endif
                inp_out.data[i] = Fp17ToFp32(o);
            } else {
                yInpDataInP1Type ob = (yInpDataInP1Type)(inp_in.bias[i]) + (yInpDataInP1Type)(inp_in.offset[i]);
                yInpDataInP1Type a = (yInpDataInP1Type)(inp_in.x[i]) - ob;

                yInpDataMidType b = a * (yInpDataMidType)(inp_in.scale[i]);
                yInpDataMidType c = IntSignedShiftRight<yInpDataMidSize,yLutSlopeShiftSize,yInpOutSize>(b,inp_in.shift[i]);
                yInpDataMidP1Type o = (yInpDataMidP1Type)(inp_in.y0[i]) + c;
                inp_out.data[i] = IntSaturation<yInpDataMidP1Size,yInpOutSize>(o);
                
                //#ifdef HLS_TRACE
                //    cslDebug((30, "ob.i34 %d:", i));
                //    cslDebug((30, "0x%08x ", ob.to_int64()));
                //    cslDebug((30, "\n"));
                //    cslDebug((30, "a=(x-ob.i34) %d:", i));
                //    cslDebug((30, "0x%08x ", a.to_int64()));
                //    cslDebug((30, "\n"));
                //    cslDebug((30, "b=(x-ob)*scale %d:", i));
                //    cslDebug((30, "0x%08x ", b.to_int64()));
                //    cslDebug((30, "\n"));
                //    cslDebug((30, "c=b>>shifter %d:", i));
                //    cslDebug((30, "0x%08x ", c.to_int64()));
                //    cslDebug((30, "\n"));
                //    cslDebug((30, "o=c+y0 %d:", i));
                //    cslDebug((30, "0x%08x ", o.to_int64()));
                //    cslDebug((30, "\n"));
                //#endif
            }
        } else {
            if (cfg_precision==ENUM_FP16) {
                yLutFracType a0_frac;
                Fp17Type a0;
                if (inp_in.fraction[i]==0) {
                    a0 = 0x7c00; // 1 in FP17 format
                } else {
                    a0_frac = (1ull<<yLutFracSize) - inp_in.fraction[i];
                    a0 = FpFractionToFloat<yLutFracSize,Fp17ExpoSize,Fp17MantSize>(a0_frac);
                }

                yLutFracType a1_frac = inp_in.fraction[i];
                Fp17Type a1 = FpFractionToFloat<yLutFracSize,Fp17ExpoSize,Fp17MantSize>(a1_frac);

                
                Fp17Type y0 = Fp16ToFp17(inp_in.y0[i]);
                Fp17Type y1 = Fp16ToFp17(inp_in.y1[i]);

                Fp17Type b0 = Fp17Mul(a0,y0);
                Fp17Type b1 = Fp17Mul(a1,y1);
                

                Fp17Type o = Fp17Add(b0,b1);
                inp_out.data[i] = Fp17ToFp32(o);
                
                #ifdef HLS_TRACE
                    cslDebug((30, "a0.fraction %d:", i));
                    cslDebug((30, "0x%08llx ", a0_frac.to_int64()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "a0 fp17 %d:", i));
                    cslDebug((30, "0x%08x ", a0.to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "a1.fraction %d:", i));
                    cslDebug((30, "0x%08llx ", a1_frac.to_int64()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "a1 fp17 %d:", i));
                    cslDebug((30, "0x%08x ", a1.to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "y0 fp16 %d:", i));
                    cslDebug((30, "0x%08x ", inp_in.y0[i].to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "y0 fp17 %d:", i));
                    cslDebug((30, "0x%08x ", y0.to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "y1 fp16 %d:", i));
                    cslDebug((30, "0x%08x ", inp_in.y1[i].to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "y1 fp17 %d:", i));
                    cslDebug((30, "0x%08x ", y1.to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "o fp17 %d:", i));
                    cslDebug((30, "0x%08x ", o.to_int()));
                    cslDebug((30, "\n"));
                    cslDebug((30, "OUT fp32 %d:", i));
                    cslDebug((30, "0x%08x ", inp_out.data[i].to_int()));
                    cslDebug((30, "\n"));
                #endif
            } else {
                yInpDataFMidType a0 = (yInpDataFMidType)((1ull<<yLutFracSize) - inp_in.fraction[i]);
                yInpDataFMidType b0 = (yInpDataFMidType)(inp_in.y0[i]) * a0;

                yInpDataFMidType a1 = (yInpDataFMidType)(inp_in.fraction[i]);
                yInpDataFMidType b1 = (yInpDataFMidType)(inp_in.y1[i]) * a1;
                yInpDataFMidType o = b0 + b1;
                //inp_out.data[i] = (o >> 16);
                inp_out.data[i] = IntShiftRight<yInpDataFMidSize,6,yInpOutSize>(o,yLutFracSize);
            }
        }
    }
    chn_inp_out.write(inp_out);
}
