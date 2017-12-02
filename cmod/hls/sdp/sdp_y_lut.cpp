// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_y_lut.cpp

#include "sdp.h"
#include "nvdla_float.h"
#include <mc_scverify.h>

//   in (i32)-> MUL (i64)-> ALU(i65) -> TCT(i32) -> RELU(i32) -> out(i32)
//               ^           ^
//               | i32       | i32
//               C           C
//               ^           ^
//               | i16       | i16
#ifdef SYNTHESIS
#pragma hls_design top
#endif
void NV_NVDLA_SDP_CORE_Y_idx (
          ac_channel<yDataOutStruct> & chn_lut_in
         ,yLutRegType     cfg_lut_le_start
         ,yLutRegType     cfg_lut_le_end
         ,yLutRegType     cfg_lut_lo_start
         ,yLutRegType     cfg_lut_lo_end
         ,yLutRegIdxType  cfg_lut_le_index_offset
         ,yLutRegIdxType  cfg_lut_le_index_select
         ,yLutRegIdxType  cfg_lut_lo_index_select
         ,ACINTF(1)       cfg_lut_le_function
         ,ACINTF(1)       cfg_lut_uflow_priority
         ,ACINTF(1)       cfg_lut_oflow_priority
         ,ACINTF(1)       cfg_lut_hybrid_priority
         ,ac_channel<yLutOutStruct> & chn_lut_out
         )
{
    yLutOutStruct lut_out;
    yDataOutStruct lut_in = chn_lut_in.read();
    #ifdef SYNTHESIS
    #pragma hls_unroll yes
    lut_lookup:
    #endif
    for (int i=0; i<16; i++) {
        // output input data
        lut_out.x[i]     = lut_in.data[i];

        // LE table
        bool le_uflow = 0;
        bool le_oflow = 0;
        yLutLoIndexType le_index_0 = 0;
        yLutLoIndexType le_index_1 = 0;
        yLutFracType le_fraction;
        if (lut_in.data[i] < cfg_lut_le_start) {
            le_uflow = 1;
            le_index_0 = 0;
            le_index_1 = 0;
            le_fraction = (cfg_lut_le_start - lut_in.data[i]);
        } else if (lut_in.data[i] > cfg_lut_le_end) {
            le_oflow = 1;
            le_index_0 = yLutTableLoDepth;
            le_index_1 = yLutTableLoDepth;
            le_fraction = (lut_in.data[i] - cfg_lut_le_end);
        } else {
                yLutInType le_index_m = lut_in.data[i] - cfg_lut_le_start;

            if ( cfg_lut_le_function == LUT_LE_FUNCTION_EXPONENT ) {
                //TODO: log2 to get int and fraction separately
                yLutInType le_data_f = le_index_m - cfg_lut_le_index_offset; 
                
                le_fraction = le_data_f >> (cfg_lut_le_index_select - 16);
        
                le_index_0 = le_data_f;
                le_index_1 = le_index_0 + 1;
            } else {
                yLutInType le_data_f = le_index_m & ((1ull << cfg_lut_le_index_select) - 1);

                le_fraction = le_data_f >> (cfg_lut_le_index_select - 16);
        
                le_index_0 = le_index_m >> cfg_lut_le_index_select;
                le_index_1 = le_index_0 + 1;
            }
        }
        
        // LO table
        bool lo_uflow = 0;
        bool lo_oflow = 0;
        yLutLoIndexType lo_index_0 = 0;
        yLutLoIndexType lo_index_1 = 0;
        yLutFracType lo_fraction;
        if (lut_in.data[i] < cfg_lut_lo_start) {
            lo_uflow = 1;
            lo_index_0 = 0;
            lo_index_1 = 0;
            lo_fraction = (cfg_lut_lo_start - lut_in.data[i]);
        } else if (lut_in.data[i] > cfg_lut_lo_end) {
            lo_oflow = 1;
            lo_index_0 = yLutTableLoDepth;
            lo_index_1 = yLutTableLoDepth;
            lo_fraction = (lut_in.data[i] - cfg_lut_lo_end);
        } else {
            yLutInType lo_index_m = lut_in.data[i] - cfg_lut_lo_start;
            yLutInType lo_data_f = lo_index_m & ((1ull << cfg_lut_lo_index_select) - 1);

            lo_fraction = lo_data_f >> (cfg_lut_lo_index_select - 16);
        
            lo_index_0 = lo_index_m >> cfg_lut_lo_index_select;
            lo_index_1 = lo_index_0 + 1;
        }


        // TODO: How to know hit or not?


        if (le_uflow & lo_uflow) {
            lut_out.ram_addr0[i] = cfg_lut_uflow_priority ? lo_index_0 : le_index_0;
            lut_out.ram_addr1[i] = cfg_lut_uflow_priority ? lo_index_0 : le_index_0;
            lut_out.ram_sel[i]   = cfg_lut_uflow_priority ? yLutTableLoID : yLutTableLeID;;
            lut_out.fraction[i]  = cfg_lut_uflow_priority ? lo_fraction : le_fraction;
            lut_out.uflow[i]     = cfg_lut_uflow_priority ? lo_uflow : le_uflow;
            lut_out.oflow[i]     = 0;
        } else if (le_oflow & le_oflow) {
            lut_out.ram_addr0[i] = cfg_lut_oflow_priority ? lo_index_0 : le_index_0;
            lut_out.ram_addr1[i] = cfg_lut_oflow_priority ? lo_index_0 : le_index_0;
            lut_out.ram_sel[i]   = cfg_lut_oflow_priority ? yLutTableLoID : yLutTableLeID;;
            lut_out.fraction[i]  = cfg_lut_oflow_priority ? lo_fraction : le_fraction;
            lut_out.uflow[i]     = 0;
            lut_out.oflow[i]     = cfg_lut_oflow_priority ? lo_oflow : le_oflow;
        } else {
            lut_out.ram_addr0[i] = cfg_lut_hybrid_priority ? lo_index_0 : le_index_0;
            lut_out.ram_addr1[i] = cfg_lut_hybrid_priority ? lo_index_1 : le_index_1;
            lut_out.ram_sel[i]   = cfg_lut_hybrid_priority ? yLutTableLoID : yLutTableLeID;;
            lut_out.fraction[i]  = cfg_lut_hybrid_priority ? lo_fraction : le_fraction;
            lut_out.uflow[i]     = 0;
            lut_out.oflow[i]     = 0;
        }
    }
    chn_lut_out.write(lut_out);
}
