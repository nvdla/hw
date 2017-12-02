// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_y_idx.cpp

#include "sdp.h"
#include "nvdla_float.h"
//#include <mc_scverify.h>

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
         )
{

    #ifdef HLS_TRACE
        cslDebug((30, "%s call NV_NVDLA_SDP_CORE_Y_idx on %d iter\n", "HLS_CALL", hls_call_iter++));
    #endif

    yLutOutStruct lut_out;
    yDataOutStruct lut_in = chn_lut_in.read();
    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    lut_lookup:
    #endif
    for (int i=0; i<SPEED_Y; i++) {
        // output input data
        lut_out.x[i]     = lut_in.data[i];

        // LE table
        bool le_uflow = 0;
        bool le_oflow = 0;
        yLutIndexTypeF le_index_0 = 0;
        yLutFracType le_fraction = 0;
        
        yLutInType le_index_f;

        if ( cfg_lut_le_function == LUT_LE_FUNCTION_EXPONENT ) {
            // LE: EXPONENT TABLE
            yLutInType le_index_f;
            if (cfg_precision==ENUM_FP16) {
                le_index_f = FpSub<Fp32ExpoSize,Fp32MantSize>(lut_in.data[i],cfg_lut_le_start);
                
                ACINTF(Fp32SignSize) le_sign;
                ACINTF(Fp32ExpoSize) le_expo;
                ACINTF(Fp32MantSize) le_mant;
                ACINTT(Fp32ExpoSizeT) le_signed_expo;
                FpSignedBitsToFloat<Fp32ExpoSize,Fp32MantSize>(le_index_f,le_sign,le_expo,le_mant);
                le_signed_expo = le_expo - 127; //get the real exp. stepheng.20170525

                bool is_zero = IsZero<Fp32ExpoSize,Fp32MantSize>(le_expo,le_mant);
                bool is_nan  = IsNaN<Fp32ExpoSize,Fp32MantSize>(le_expo,le_mant);

                if (le_sign==1 || is_zero || is_nan) {
                    le_uflow = 1;
                    le_index_0 = 0;
                } else {
                    if (le_signed_expo < cfg_lut_le_index_offset) {
                        le_uflow = 1;
                        le_index_0 = 0;
                    } else {
                        yLutIndexTypeF le_index_s = (yLutIndexType)(le_signed_expo) - (yLutIndexType)(cfg_lut_le_index_offset); //stepheng.20170525
                        if (le_index_s >= yLutTableLeDepth - 1) {
                            le_oflow = 1;
                            le_index_0 = yLutTableLeDepth - 1;
                        } else {
                            le_index_0 = le_index_s;
                            le_fraction = ((yLutFracType)(le_mant)) << (yLutFracSize - yDataMantSize );
                        }
                    }
                }
            } else {
                if ( lut_in.data[i] <= cfg_lut_le_start) {
                    le_uflow = 1;
                    le_index_0 = 0;
                } else {
                    yLutInTypeF le_data_sub = (yLutInPlusOneType)(lut_in.data[i]) - (yLutInPlusOneType)(cfg_lut_le_start);
                    yLutInTypeF le_data_idx;
                    yLutInTypeF le_data_fra;

                    IntLog2<yLutInSize>(le_data_sub,le_data_idx,le_data_fra);

                    yLutIndexTypeF le_index_idx = le_data_idx ;
        
                    if (le_index_idx < cfg_lut_le_index_offset) {
                        le_uflow = 1;
                        le_index_0 = 0;
                    } else {
                        yLutIndexTypeF le_index_s = (yLutIndexType)le_index_idx - (yLutIndexType)cfg_lut_le_index_offset;
                        if (le_index_s >= yLutTableLeDepth - 1) {
                            le_oflow = 1;
                            le_index_0 = yLutTableLeDepth - 1;
                        } else {
                            le_index_0 = le_index_s;
                            //if (le_data_idx < yLutFracSize) {
                                le_fraction = ((yLutFracType)(le_data_fra)) << (yLutFracSize - le_data_idx);
                            //#pragma CTC SKIP
                            //} else {
                            //    le_fraction = ((yLutFracType)(le_data_fra)) >> (le_data_idx - yLutFracSize);
                            //#pragma CTC ENDSKIP
                            //}
                        }
                    }
                }
            }
        } else {
            // LE: LINEAR TABLE
            if (cfg_precision==ENUM_FP16) {
                le_index_f = FpSub<Fp32ExpoSize,Fp32MantSize>(lut_in.data[i],cfg_lut_le_start);

                ACINTF(Fp32SignSize) le_sign;
                ACINTF(Fp32ExpoSize) le_expo;
                ACINTF(Fp32MantSize) le_mant;
                FpSignedBitsToFloat<Fp32ExpoSize,Fp32MantSize>(le_index_f,le_sign,le_expo,le_mant);
                
                bool is_zero = IsZero<Fp32ExpoSize,Fp32MantSize>(le_expo,le_mant);
                bool is_nan  = IsNaN<Fp32ExpoSize,Fp32MantSize>(le_expo,le_mant);

                if (le_sign==1 || is_zero || is_nan) {
                    le_uflow = 1;
                    le_index_0 = 0;
                } else {
                    yLutIndexTypeF  le_int;
                    yLutFracType   le_fra;
                    FpFloatToIntFrac<Fp32ExpoSize,Fp32MantSize,yLutRegIdxSize,yLutAddrSize,yLutFracSize>(le_index_f,cfg_lut_le_index_select,le_int,le_fra);

                    // TODO, need PLUSONE
                    //yLutMantType le_data;
                    //yLutRegIdxType le_int_shift = (yLutIndexTypeF)le_ptr + cfg_lut_le_index_select;
                    //yLutMantType le_int = IntSignedShiftRightTZ<yLutMantSize,yLutRegIdxSize,yLutMantSize>(le_data,le_int_shift);

                    if (le_int >= yLutTableLeDepth - 1) {
                        le_oflow   = 1;
                        le_index_0 = yLutTableLeDepth - 1;
                    } else {
                        le_index_0  = le_int;
                        le_fraction = le_fra;
                    }
                }
            } else {
                if (lut_in.data[i] <= cfg_lut_le_start) {
                    le_uflow = 1;
                    le_index_0 = 0;
                } else {
                    yLutInTypeF le_index_u;
                    le_index_u = lut_in.data[i] - cfg_lut_le_start;
                    yLutIndexTypeF le_index_s = IntSignedShiftRightTZ<yLutInSize,yLutRegIdxSize,yLutIndexSize>(le_index_u,cfg_lut_le_index_select);

                    if (le_index_s >= yLutTableLeDepth - 1 ) {
                        le_oflow = 1;
                        le_index_0 = yLutTableLeDepth - 1;
                    } else {
                        le_index_0 = le_index_s;
                        yLutInType le_data_f = le_index_u & ((1ull << cfg_lut_le_index_select) - 1);
                        le_fraction = ((yLutFracType)(le_data_f)) >> (cfg_lut_le_index_select - yLutFracSize);
                    }
                }
            }
        } // end of LE table
        
        
        // LO table
        bool lo_uflow = 0;
        bool lo_oflow = 0;
        yLutIndexTypeF lo_index_0 = 0;
        yLutFracType lo_fraction = 0;
        
        {
            // LE: LINEAR TABLE
            yLutInType lo_index_f;
            if (cfg_precision==ENUM_FP16) {
                lo_index_f = FpSub<Fp32ExpoSize,Fp32MantSize>(lut_in.data[i],cfg_lut_lo_start);

                ACINTF(Fp32SignSize) lo_sign;
                ACINTF(Fp32ExpoSize) lo_expo;
                ACINTF(Fp32MantSize) lo_mant;
                FpSignedBitsToFloat<Fp32ExpoSize,Fp32MantSize>(lo_index_f,lo_sign,lo_expo,lo_mant);
                
                bool is_zero = IsZero<Fp32ExpoSize,Fp32MantSize>(lo_expo,lo_mant);
                bool is_nan  = IsNaN<Fp32ExpoSize,Fp32MantSize>(lo_expo,lo_mant);

                if (lo_sign==1 || is_zero || is_nan) {
                    lo_uflow = 1;
                    lo_index_0 = 0;
                } else {
                    yLutIndexTypeF  lo_int;
                    yLutFracType   lo_fra;
                    FpFloatToIntFrac<Fp32ExpoSize,Fp32MantSize,yLutRegIdxSize,yLutAddrSize,yLutFracSize>(lo_index_f,cfg_lut_lo_index_select,lo_int,lo_fra);

                    // TODO, need PLUSONE
                    //yLutMantType lo_data;
                    //yLutRegIdxType lo_int_shift = (yLutIndexTypeF)lo_ptr + cfg_lut_lo_index_select;
                    //yLutMantType lo_int = IntSignedShiftRightTZ<yLutMantSize,yLutRegIdxSize,yLutMantSize>(lo_data,lo_int_shift);

                    if (lo_int >= yLutTableLoDepth - 1) {
                        lo_oflow   = 1;
                        lo_index_0 = yLutTableLoDepth - 1;
                    } else {
                        lo_index_0  = lo_int;
                        lo_fraction = lo_fra;
                    }

                    //yLutMantType lo_data;
                    //yLutAddrType lo_ptr;
                    //FpFloatToIntFrac<Fp32ExpoSize,Fp32MantSize,yLutMantSize,yLutAddrSize>(lo_index_m,lo_data,lo_ptr);

                    //// TODO, need PLUSONE
                    //yLutRegIdxType lo_int_shift = ((yLutIndexTypeF)(lo_ptr)) + cfg_lut_lo_index_select;

                    ////stepheng. 20170519
                    ////yLutInTypeF lo_int = IntSignedShiftRightTZ<yLutMantSize,yLutRegIdxSize,yLutMantSize>(lo_data,lo_int_shift);
                    //yLutInTypeAdd1T  lo_data_signed = lo_data;
                    //yLutMantType lo_int = IntSignedShiftRightTZ<yLutMantSize+1,yLutRegIdxSize,yLutMantSize>(lo_data_signed,lo_int_shift);

                    //if (lo_int >= yLutTableLoDepth - 1) {
                    //    lo_oflow   = 1;
                    //    lo_index_0 = yLutTableLoDepth - 1;
                    //} else {
                    //    yLutFracType lo_fra=0;
                    //    if (lo_int_shift<=0) {
                    //        lo_fra = 0;
                    //    } else if (lo_int_shift > yLutFracSize) {
                    //        lo_fra = ((yLutFracType)(lo_data)) >> (lo_int_shift - yLutFracSize);
                    //    } else {
                    //        lo_fra = ((yLutFracType)(lo_data)) << (yLutFracSize - lo_int_shift);
                    //    }

                    //    lo_index_0  = lo_int;
                    //    lo_fraction = lo_fra;
                    //}
                }
            } else {
                yLutInTypeF lo_index_u;
                if ( lut_in.data[i] <= cfg_lut_lo_start) {
                    lo_uflow = 1;
                    lo_index_0 = 0;
                } else {
                    lo_index_u = (yLutInTypeF)(lut_in.data[i] - cfg_lut_lo_start);
                    yLutIndexTypeF lo_index_s = IntSignedShiftRightTZ<yLutInSize,yLutRegIdxSize,yLutIndexSize>(lo_index_u,cfg_lut_lo_index_select);

                    if (lo_index_s >= yLutTableLoDepth - 1 ) {
                        lo_oflow = 1;
                        lo_index_0 = yLutTableLoDepth - 1;
                    } else {
                        lo_index_0 = lo_index_s;
                        yLutInTypeF lo_data_f = lo_index_u & ((1ull << cfg_lut_lo_index_select) - 1);
                        lo_fraction = ((yLutFracType)(lo_data_f)) >> (cfg_lut_lo_index_select - yLutFracSize);
                    }
                }
            }
        }

        bool le_miss = (le_uflow | le_oflow);
        bool le_hit = !le_miss;
        bool lo_miss = (lo_uflow | lo_oflow);
        bool lo_hit = !lo_miss;
        // INDEX MUXING
        if (le_uflow & lo_uflow) {
            lut_out.ram_addr[i]  = cfg_lut_uflow_priority ? lo_index_0 : le_index_0;
            lut_out.ram_sel[i]   = cfg_lut_uflow_priority ? yLutTableLoID : yLutTableLeID;;
            lut_out.fraction[i]  = cfg_lut_uflow_priority ? lo_fraction : le_fraction;
            lut_out.uflow[i]     = cfg_lut_uflow_priority ? lo_uflow : le_uflow;
            lut_out.oflow[i]     = 0;
        } else if (le_oflow & lo_oflow) {
            lut_out.ram_addr[i]  = cfg_lut_oflow_priority ? lo_index_0 : le_index_0;
            lut_out.ram_sel[i]   = cfg_lut_oflow_priority ? yLutTableLoID : yLutTableLeID;;
            lut_out.fraction[i]  = cfg_lut_oflow_priority ? lo_fraction : le_fraction;
            lut_out.uflow[i]     = 0;
            lut_out.oflow[i]     = cfg_lut_oflow_priority ? lo_oflow : le_oflow;
        } else if (le_hit & lo_hit) {
            lut_out.ram_addr[i]  = cfg_lut_hybrid_priority ? lo_index_0 : le_index_0;
            lut_out.ram_sel[i]   = cfg_lut_hybrid_priority ? yLutTableLoID : yLutTableLeID;;
            lut_out.fraction[i]  = cfg_lut_hybrid_priority ? lo_fraction : le_fraction;
            lut_out.uflow[i]     = 0;
            lut_out.oflow[i]     = 0;
        } else if (le_miss & lo_miss) {
            lut_out.ram_addr[i]  = cfg_lut_hybrid_priority ? lo_index_0 : le_index_0;
            lut_out.ram_sel[i]   = cfg_lut_hybrid_priority ? yLutTableLoID : yLutTableLeID;;
            lut_out.fraction[i]  = cfg_lut_hybrid_priority ? lo_fraction : le_fraction;
            lut_out.uflow[i]     = cfg_lut_hybrid_priority ? lo_uflow : le_uflow;
            lut_out.oflow[i]     = cfg_lut_hybrid_priority ? lo_oflow : le_oflow;
        } else if (le_hit) {
            lut_out.ram_addr[i]  = le_index_0;
            lut_out.ram_sel[i]   = yLutTableLeID;
            lut_out.fraction[i]  = le_fraction;
            lut_out.uflow[i]     = 0;
            lut_out.oflow[i]     = 0;
        #pragma CTC SKIP
        } else if (lo_hit) {
        #pragma CTC ENDSKIP
            lut_out.ram_addr[i]  = lo_index_0;
            lut_out.ram_sel[i]   = yLutTableLoID;
            lut_out.fraction[i]  = lo_fraction;
            lut_out.uflow[i]     = 0;
            lut_out.oflow[i]     = 0;
        }
            
            lut_out.le_hit[i]     = le_hit;
            lut_out.lo_hit[i]     = lo_hit;
    }
    
    #ifdef HLS_TRACE
        cslDebug((30, "LutIn\n "));
        for (int i=0; i<SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", lut_in.data[i].to_int()));
        }
        cslDebug((30, "\n"));
        
        cslDebug((30, "LutOut.ram_addr\n "));
        for (int i=0; i<SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", lut_out.ram_addr[i].to_int()));
        }
        cslDebug((30, "\n"));
        cslDebug((30, "LutOut.ram_sel\n "));
        for (int i=0; i<SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", lut_out.ram_sel[i].to_int()));
        }
        cslDebug((30, "\n"));
        cslDebug((30, "LutOut.fraction\n "));
        for (int i=0; i<SPEED_Y; i++) {
            cslDebug((30, "0x%08llx ", lut_out.fraction[i].to_int64()));
        }
        cslDebug((30, "\n"));
        cslDebug((30, "LutOut.uflow\n "));
        for (int i=0; i<SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", lut_out.uflow[i].to_int()));
        }
        cslDebug((30, "\n"));
        cslDebug((30, "LutOut.oflow\n "));
        for (int i=0; i<SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", lut_out.oflow[i].to_int()));
        }
        cslDebug((30, "\n"));
        cslDebug((30, "LutOut.le_hit\n "));
        for (int i=0; i<SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", lut_out.le_hit[i].to_int()));
        }
        cslDebug((30, "\n"));
        cslDebug((30, "LutOut.lo_hit\n "));
        for (int i=0; i<SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", lut_out.lo_hit[i].to_int()));
        }
        cslDebug((30, "\n"));
    #endif

    chn_lut_out.write(lut_out);
}
