// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_hls_wrapper.cpp

#include "log.h"
#include "ac_int.h"
#include "ac_channel.h"
#include "log.h"
#include <systemc.h>
#include "opendla.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#include "vlibs.h"

#include "cdp_hls_wrapper.h"

#pragma CTC SKIP
int half2single(void *target, void *source, int numel)
{
    unsigned short *hp = (unsigned short *) source; // Type pun input as an unsigned 16-bit int
    unsigned int *xp = (unsigned int *) target; // Type pun output as an unsigned 32-bit int
    unsigned short h, hs, he, hm;
    unsigned int xs, xe, xm;
    int xes;
    int e;
    static int checkieee = 1;  // Flag to check for IEEE754, Endian, and word size
    double one = 1.0; // Used for checking IEEE754 floating point format
    unsigned int *ip; // Used for checking IEEE754 floating point format

    if( checkieee ) { // 1st call, so check for IEEE754, Endian, and word size
        ip = (unsigned int *) &one;
        if( *ip ) { // If Big Endian, then no adjustment
        } else { // If Little Endian, then adjustment will be necessary
            ip++;
        }
        if( *ip != 0x3FF00000u ) { // Check for exact IEEE 754 bit pattern of 1.0
            return 1;  // Floating point bit pattern is not IEEE 754
        }
        if( sizeof(short) != 2 || sizeof(int) != 4 ) {
            return 1;  // short is not 16-bits, or long is not 32-bits.
        }
        checkieee = 0; // Everything checks out OK
    }

    if( source == NULL || target == NULL ) // Nothing to convert (e.g., imag part of pure real)
        return 0;

    while( numel-- ) {
        h = *hp++;
        if( (h & 0x7FFFu) == 0 ) {  // Signed zero
            *xp++ = ((unsigned int) h) << 16;  // Return the signed zero
        } else { // Not zero
            hs = h & 0x8000u;  // Pick off sign bit
            he = h & 0x7C00u;  // Pick off exponent bits
            hm = h & 0x03FFu;  // Pick off mantissa bits
            if( he == 0 ) {  // Denormal will convert to normalized
                e = -1; // The following loop figures out how much extra to adjust the exponent
                do {
                    e++;
                    hm <<= 1;
                } while( (hm & 0x0400u) == 0 ); // Shift until leading bit overflows into exponent bit
                xs = ((unsigned int) hs) << 16; // Sign bit
                xes = ((int) (he >> 10)) - 15 + 127 - e; // Exponent unbias the halfp, then bias the single
                xe = (unsigned int) (xes << 23); // Exponent
                xm = ((unsigned int) (hm & 0x03FFu)) << 13; // Mantissa
                *xp++ = (xs | xe | xm); // Combine sign bit, exponent bits, and mantissa bits
            } else if( he == 0x7C00u ) {  // Inf or NaN (all the exponent bits are set)
                if( hm == 0 ) { // If mantissa is zero ...
                    *xp++ = (((unsigned int) hs) << 16) | ((unsigned int) 0x7F800000u); // Signed Inf
                } else {
                    *xp++ = (unsigned int) 0xFFC00000u; // NaN, only 1st mantissa bit set
                }
            } else { // Normalized number
                xs = ((unsigned int) hs) << 16; // Sign bit
                xes = ((int) (he >> 10)) - 15 + 127; // Exponent unbias the halfp, then bias the single
                xe = (unsigned int) (xes << 23); // Exponent
                xm = ((unsigned int) hm) << 13; // Mantissa
                *xp++ = (xs | xe | xm); // Combine sign bit, exponent bits, and mantissa bits
            }
        }
    }
    return 0;
}

int single2half(void *target, void *source, int numel)
{
    unsigned short *hp = (unsigned short *) target; // Type pun output as an unsigned 16-bit int
    unsigned int *xp = (unsigned int *) source; // Type pun input as an unsigned 32-bit int
    unsigned short    hs, he, hm;
    unsigned int x, xs, xe, xm;
    int hes;
    static int checkieee = 1;  // Flag to check for IEEE754, Endian, and word size
    double one = 1.0; // Used for checking IEEE754 floating point format
    unsigned int *ip; // Used for checking IEEE754 floating point format

    if( checkieee ) { // 1st call, so check for IEEE754, Endian, and word size
        ip = (unsigned int *) &one;
        if( *ip ) { // If Big Endian, then no adjustment
        } else { // If Little Endian, then adjustment will be necessary
            ip++;
        }
        if( *ip != 0x3FF00000u ) { // Check for exact IEEE 754 bit pattern of 1.0
            return 1;  // Floating point bit pattern is not IEEE 754
        }
        if( sizeof(short) != 2 || sizeof(int) != 4 ) {
            return 1;  // short is not 16-bits, or long is not 32-bits.
        }
        checkieee = 0; // Everything checks out OK
    }

    if( source == NULL || target == NULL ) { // Nothing to convert (e.g., imag part of pure real)
        return 0;
    }

    while( numel-- ) {
        x = *xp++;
        if( (x & 0x7FFFFFFFu) == 0 ) {  // Signed zero
            *hp++ = (unsigned short) (x >> 16);  // Return the signed zero
        } else { // Not zero
            xs = x & 0x80000000u;  // Pick off sign bit
            xe = x & 0x7F800000u;  // Pick off exponent bits
            xm = x & 0x007FFFFFu;  // Pick off mantissa bits
            if( xe == 0 ) {  // Denormal will underflow, return a signed zero
                *hp++ = (unsigned short) (xs >> 16);
            } else if( xe == 0x7F800000u ) {  // Inf or NaN (all the exponent bits are set)
                if( xm == 0 ) { // If mantissa is zero ...
                    *hp++ = (unsigned short) ((xs >> 16) | 0x7C00u); // Signed Inf
                } else {
                    *hp++ = (unsigned short) 0xFE00u; // NaN, only 1st mantissa bit set
                }
            } else { // Normalized number
                hs = (unsigned short) (xs >> 16); // Sign bit
                hes = ((int)(xe >> 23)) - 127 + 15; // Exponent unbias the single, then bias the halfp
                if( hes >= 0x1F ) {  // Overflow
                    *hp++ = (unsigned short) ((xs >> 16) | 0x7C00u); // Signed Inf
                } else if( hes <= 0 ) {  // Underflow
                    if( (14 - hes) > 24 ) {  // Mantissa shifted all the way off & no rounding possibility
                        hm = (unsigned short) 0u;  // Set mantissa to zero
                    } else {
                        xm |= 0x00800000u;  // Add the hidden leading bit
                        hm = (unsigned short) (xm >> (14 - hes)); // Mantissa
                        if( (xm >> (13 - hes)) & 0x00000001u ) // Check for rounding
                            hm += (unsigned short) 1u; // Round, might overflow into exp bit, but this is OK
                    }
                    *hp++ = (hs | hm); // Combine sign bit and mantissa bits, biased exponent is zero
                } else {
                    he = (unsigned short) (hes << 10); // Exponent
                    hm = (unsigned short) (xm >> 13); // Mantissa
                    if( xm & 0x00001000u ) // Check for rounding
                        *hp++ = (hs | he | hm) + (unsigned short) 1u; // Round, might overflow to inf, this is OK
                    else
                        *hp++ = (hs | he | hm);  // No rounding
                }
            }
        }
    }
    return 0;
}
#pragma CTC ENDSKIP

// Inputs: 12 HLS_FP17 after icvt
// Outputs: 1 HLS_FP17 after Interplolation
void HLS_CDP_lookup_lut (
    vFp32Type   square_sum,
    uint16_t    lut_upper_index,
    bool        le,                 // True: linear_exp table
    bool        exp_mode,           // Only for linear_exp table
    int16_t*    lut,                // LUT table
    uint64_t    lut_start,
    uint64_t    lut_end,
    int16_t     slope_uflow_scale,  // It's accutally signed value
    int16_t     slope_oflow_scale,
    int16_t     index_offset,
    int8_t      index_select,

    // Outputs
    bool      & underflow,
    bool      & overflow,
    bool      & lut_hit,
    ac_channel<vFp17Type> & chn_result_fp17)
{
#if !ASSERT_WAR_CONSTRAIN
    // assert(density_end - pow(2, cdp_lut_lo_index_select_ + 8) == density_start);
#endif

    // Variables for sub input_offset
    vFp32Type lut_start_fp32, lut_end_fp32;
    vFp32Type lut_sub_result_fp32;
    ac_channel<vFp32Type> chn_square_sum_fp32;
    ac_channel<vFp32Type> chn_lut_start_fp32, chn_lut_end_fp32;
    ac_channel<vFp32Type> chn_lut_sub_result_fp32;
    ac_channel<vFp17Type> chn_lut_sub_result_fp17;
    float    lut_sub_result_float;
    float    lut_shifted;
    uint16_t lut_offset;
    int32_t  lut_index;

    ac_channel<vFp17Type> chn_lut_offset_fp17;

    // Varibales for underflow/overflow
    vFp16Type slope_fp16;
    ac_channel<vFp16Type> chn_slope_fp16;
    ac_channel<vFp17Type> chn_slope_fp17;
    ac_channel<vFp17Type> chn_lo_sub_result_fp17;
    ac_channel<vFp17Type> chn_mul_result_fp17;
    ac_channel<vFp17Type> chn_result_lut_underflow;
    ac_channel<vFp17Type> chn_result_lut_overflow;

    // Variables for Interpolation
    uint16_t result_0, result_1;
    vFp16Type result_0_fp16, result_1_fp16;
    ac_channel<vFp16Type> chn_result_0_fp16, chn_result_1_fp16;

    vFp32Type result_0_fp32, result_1_fp32;
    ac_channel<vFp32Type> chn_result_0_fp32, chn_result_1_fp32;
    ac_channel<vFp17Type> chn_result_0_fp17;
    ac_channel<vFp17Type> chn_result_1_fp17;

//    ac_channel<vFp17Type> chn_result_underflow_fp17;
//    ac_channel<vFp17Type> chn_result_overflow_fp17;

    ac_channel<vFp32Type> chn_L1_minus_L0_fp32;
    ac_channel<vFp17Type> chn_L1_minus_L0_fp17;
    ac_channel<vFp17Type> chn_result_lut_tmp;

//--------------------------------------------
    underflow = false;
    overflow = false;
    //exp_underflow = false;
    //exp_overflow = false;
    lut_hit = false;

//--------------------------------------------
    // 1. sub offset
    lut_start_fp32 = lut_start;
    chn_lut_start_fp32.write(lut_start_fp32);
    chn_square_sum_fp32.write(square_sum);
    HLS_fp32_sub(chn_square_sum_fp32, chn_lut_start_fp32, chn_lut_sub_result_fp32);
    lut_sub_result_fp32 = chn_lut_sub_result_fp32.read();
    lut_sub_result_float = *(float *)(&lut_sub_result_fp32); // vFp32Type is actually integer type

    cslDebug((70, "lut_start=0x%x, lut_sub_result=0x%x\n", (uint32_t)lut_start_fp32, (uint32_t)lut_sub_result_fp32));

    if(lut_sub_result_float <= 0 || std::isnan(lut_sub_result_float))
    {
        underflow = true;
    }

    if (!underflow) {
        if (le && exp_mode) {
            // Log2. If lo_sub_result_float is 0, exp will be 0
            uint32_t tmp_uint32 = *(uint32_t*)(&lut_sub_result_float);
            int32_t exp_raw = (tmp_uint32 >> 23) & 0xff;    // 8bits
            //int32_t exp = (exp_raw == 0)? 0 : exp_raw - 127;
            int32_t exp = exp_raw - 127;

            lut_index = exp - index_offset;
            lut_offset = (tmp_uint32 >> 7) & 0xffff;
            if(lut_index < 0)
            {
                lut_offset >>= -lut_index;
                lut_index = 0;
                underflow = true;
            }
            else if (lut_index  >= lut_upper_index) 
            {
                overflow = true;
            }

            cslDebug((70, "exp=%d, index_offset=%d, lut_index=%d, lut_offset=%d\n", exp, index_offset, lut_index, lut_offset));
        }
        else {
            // lo or (le && linear_mode)
            // To int and Shift using float of C++
            // In RTL, HLS is not used in below code
            if(index_select >= 0)
                lut_shifted = lut_sub_result_float / pow(2,  index_select);
            else
                lut_shifted = lut_sub_result_float * pow(2, -index_select);

            overflow = lut_shifted >= lut_upper_index;

            lut_index  = lut_shifted;
            lut_offset = (lut_shifted - int32_t(lut_shifted)) * 0x10000; // 16 MSB bits of fraction

            cslDebug((70, "index_select=%d, lut_shifted=%f, lut_index=%d, lut_offset=%d\n", index_select, lut_shifted, lut_index, lut_offset));
        }
    }
    
    // Convert Fraction from special INT16 to HLS_FP17
    vU16Type lut_offset_u16 = lut_offset;
    ac_channel<vU16Type> chn_lut_offset_u16;
    chn_lut_offset_u16.write(lut_offset_u16);
    
    HLS_uint16_to_fp17(chn_lut_offset_u16, chn_lut_offset_fp17);

    //if ((underflow || (le&&exp_underflow))) {
    if (underflow) {
        result_0 = lut[0];
        result_0_fp16 = result_0;
        chn_result_0_fp16.write(result_0_fp16);
        cslDebug((70, "L0=0x%x\n", result_0));
        // Convert result_lo_0 of HLS FP16 to HLS_FP17
        HLS_fp16_to_fp17(chn_result_0_fp16, chn_result_0_fp17);
        
        slope_fp16 = (int16_t)slope_uflow_scale;
        chn_slope_fp16.write(slope_fp16);
        // Convert FP16 to HLS_FP17
        HLS_fp16_to_fp17(chn_slope_fp16, chn_slope_fp17);

        // Convert FP32 to HLS_FP17
        if(le && exp_mode) 
        {
            float offset;
#pragma CTC SKIP
            if(index_offset <= -127)
            {
                offset = 0;
            }
#pragma CTC ENDSKIP
            else
            {
                offset = pow(2, index_offset);
            }
            ac_channel<vFp32Type> chn_offset, chn_offset_adj;
            chn_offset.write(*(vFp32Type *)(&offset));
            chn_lut_start_fp32.write(lut_start_fp32);
            HLS_fp32_add(chn_lut_start_fp32, chn_offset, chn_offset_adj); 
            chn_square_sum_fp32.write(square_sum);
            HLS_fp32_sub(chn_square_sum_fp32, chn_offset_adj, chn_lut_sub_result_fp32);
        }
        else
        {
            chn_lut_sub_result_fp32.write(lut_sub_result_fp32);
        }
        HLS_fp32_to_fp17(chn_lut_sub_result_fp32, chn_lut_sub_result_fp17);
        // chn_gap * slope
        HLS_fp17_mul(chn_lut_sub_result_fp17, chn_slope_fp17, chn_mul_result_fp17);
        HLS_fp17_add(chn_mul_result_fp17, chn_result_0_fp17, chn_result_fp17);
    }
    //else if ((overflow || (le&&exp_overflow))) {
    else if (overflow) {
        result_1 = lut[lut_upper_index];
        result_1_fp16 = result_1;
        chn_result_1_fp16.write(result_1_fp16);
        cslDebug((70, "L1=0x%x\n", result_1));
        // Convert result_lo_0 of HLS FP16 to HLS_FP17
        HLS_fp16_to_fp17(chn_result_1_fp16, chn_result_1_fp17);

        slope_fp16 = (int16_t)slope_oflow_scale;
        chn_slope_fp16.write(slope_fp16);
        // Convert FP16 to HLS_FP17
        HLS_fp16_to_fp17(chn_slope_fp16, chn_slope_fp17);
        // Convert FP32 to HLS_FP17
        lut_end_fp32 = lut_end;
        chn_lut_end_fp32.write(lut_end_fp32);
        chn_square_sum_fp32.write(square_sum);
        HLS_fp32_sub(chn_square_sum_fp32, chn_lut_end_fp32, chn_lut_sub_result_fp32);
        HLS_fp32_to_fp17(chn_lut_sub_result_fp32, chn_lut_sub_result_fp17);
        
        // chn_gap * slope
        HLS_fp17_mul(chn_lut_sub_result_fp17, chn_slope_fp17, chn_mul_result_fp17);
        HLS_fp17_add(chn_mul_result_fp17, chn_result_1_fp17, chn_result_fp17);
    }
    else {
        result_0 = lut[lut_index];
        result_1 = lut[lut_index+1];
        result_0_fp16 = result_0;
        result_1_fp16 = result_1;
        chn_result_0_fp16.write(result_0_fp16);
        chn_result_1_fp16.write(result_1_fp16);
        
        cslDebug((70, "L0=0x%x, L1=0x%x\n", result_0, result_1));

        // Convert HLS_FP16 to HLS_FP32
        HLS_fp16_to_fp32(chn_result_0_fp16, chn_result_0_fp32);
        HLS_fp16_to_fp32(chn_result_1_fp16, chn_result_1_fp32);
        // Convert result_lo_0 of HLS FP16 to HLS_FP17
        chn_result_0_fp16.write(result_0_fp16);
        HLS_fp16_to_fp17(chn_result_0_fp16, chn_result_0_fp17);

        // Interpolation
        HLS_fp32_sub(chn_result_1_fp32, chn_result_0_fp32, chn_L1_minus_L0_fp32);
        //vFp32Type L1_minus_L0_fp32 = chn_L1_minus_L0_fp32.read();
        //cslDebug((70,"L1_minus_L0_fp32=0x%x\n", L1_minus_L0_fp32));
        //chn_L1_minus_L0_fp32.write(L1_minus_L0_fp32);
        HLS_fp32_to_fp17(chn_L1_minus_L0_fp32, chn_L1_minus_L0_fp17);
        HLS_fp17_mul(chn_L1_minus_L0_fp17, chn_lut_offset_fp17, chn_result_lut_tmp);
        HLS_fp17_add(chn_result_lut_tmp, chn_result_0_fp17, chn_result_fp17);
        lut_hit = true;
        /*
        float L0_float, L1_float, L1_minus_L0_float, result_float;
        half2single(&L0_float,&result_0_fp16, 1);
        cslDebug((70,"L0: %f(0x%x)\n", L0_float, *(int *)(&L0_float) ));
        half2single(&L1_float,&result_1_fp16, 1);
        cslDebug((70,"L1: %f(0x%x)\n", L1_float, *(int *)(&L1_float) ));
        L1_minus_L0_float = L1_float - L0_float;
        cslDebug((70,"L1-L1: %f(0x%x)\n", L1_minus_L0_float, *(int *)(&L1_minus_L0_float) ));
        result_float = L0_float + L1_minus_L0_float * lut_offset;
        cslDebug((70,"result: %f(0x%x)\n", result_float, *(int *)(&result_float) ));*/
    }
}

void HLS_CDP_lookup_fp16 (
    int16_t  *data_in,      // 12 * fp17
    int16_t  *le_lut,
    int16_t  *lo_lut,

    // Configurations
    uint16_t normalz_len,
    uint16_t raw_method,
    bool     lut_uflow_priority,
    bool     lut_oflow_priority,
    bool     lut_hybrid_priority,
    uint64_t le_start,
    int16_t  le_index_offset,
    int8_t   le_index_select,
    uint64_t le_end,
    uint64_t lo_start,
    int8_t   lo_index_select,
    uint64_t lo_end,
    uint16_t datin_offset,
    uint16_t datin_scale,
    uint8_t  datin_shifter,
    uint32_t datout_offset,
    uint16_t datout_scale,
    uint8_t  datout_shifter,
    int16_t  le_slope_uflow_scale,
    int16_t  le_slope_oflow_scale,
    int16_t  lo_slope_uflow_scale,
    int16_t  lo_slope_oflow_scale,
    bool     sqsum_bypass,
    bool     mul_bypass,
    int16_t *normalz_out,
    uint32_t *lut_u_flow,
    uint32_t *lut_o_flow,
    uint32_t *lut_le_hit,
    uint32_t *lut_lo_hit,
    uint32_t *lut_hybrid_hit)      // 16bits
{
    int i;

    // Outputs
    bool le_underflow;
    bool le_overflow;
    //bool exp_underflow;
    //bool exp_overflow;
    bool lo_underflow;
    bool lo_overflow;
    bool le_hit;
    bool lo_hit;

    // Variables
    int32_t                 icvt_data_out[12];
    ac_channel<vFp32Type>   fp17tofp32_out[12];
    ac_channel<vFp32Type>   square_array[12];
    //ac_channel<vFp32Type>   square_sum;
    vFp32Type               square_result[12];

    // Outputs of lut tables
    ac_channel<vFp17Type>   chn_result_le_fp17;
    ac_channel<vFp17Type>   chn_result_lo_fp17;
//    ac_channel<vFp17Type>   chn_result_fp17;
    ac_channel<vFp17Type>   chn_result_to_ocvt_fp17;
    ac_channel<vFp17Type>   chn_ocvt_out_fp17;
#if 0
    // Initialization
    le_underflow    = false;
    le_overflow     = false;
    exp_underflow   = false;
    exp_overflow    = false;
    lo_underflow    = false;
    lo_overflow     = false;
    le_hit          = false;
    lo_hit          = false;
#endif
    vFp32Type icvt_data_out_fp32[12];

    float tmp[12], din_offset, din_scale;

    half2single(&din_offset, &datin_offset, 1);
    half2single(&din_scale,  &datin_scale,  1);

    cslDebug((70, "Data before input converter(float)\n"));
    for(i=0; i<12; i++)
    {
        half2single(&tmp[i], &data_in[i], 1);
        cslDebug((70, "%f(0x%x) ", tmp[i], *(int *)(&tmp[i]) ));
    }
    cslDebug((70, "\n"));

    cslDebug((70, "Data after square(float)\n"));
    for(i=0; i<12; i++)
    {
        tmp[i] = tmp[i] * tmp[i];
        cslDebug((70, "%f(0x%x) ", tmp[i], *(int *)(&tmp[i]) ));
    }
    cslDebug((70, "\n"));

    for(i=0; i<12; i++) {
        //***** Input Convertor (FP16->FP17) ******
        cdp_icvt_hls(&data_in[i], datin_offset, datin_scale, datin_shifter, NVDLA_CDP_RDMA_D_DATA_FORMAT_0_INPUT_DATA_FP16, &icvt_data_out[i]);

        //***** Convert FP17 to FP32 ******
        ac_channel<vFp17Type>   chn_a;
        chn_a.write(icvt_data_out[i]);
        HLS_fp17_to_fp32(chn_a, fp17tofp32_out[i]);
        icvt_data_out_fp32[i] = fp17tofp32_out[i].read();
        ac_channel<vFp32Type>   chn_b, chn_c;
        chn_b.write(icvt_data_out_fp32[i]);
        chn_c.write(icvt_data_out_fp32[i]);
        if(sqsum_bypass)
        {
            square_result[i] = icvt_data_out_fp32[i];
        }
        else
        {
            HLS_fp32_mul(chn_b, chn_c, square_array[i]);  // HLS_FP32 mul
            square_result[i] = square_array[i].read(); //keep data to re-write the square_array later
        }
    }
    
//    cslDebug((70, "Data after input convertor(FP17):\n"));
//    for(int i=0;i<12;i++) cslDebug((70,"%x ", *(int*)(&icvt_data_out[i]) ));
//    cslDebug((70, "\n"));

    cslDebug((70, "Data after input convertor(FP32):\n"));
    for(int i=0;i<12;i++) cslDebug((70,"%x ", *(int*)(&icvt_data_out_fp32[i]) ));
    cslDebug((70, "\n"));

    cslDebug((70, "Data after square:\n"));
    for(int i=0;i<12;i++) cslDebug((70,"%x ", *(int*)(&square_result[i]) ));
    cslDebug((70, "\n"));

    //***** Per Element ******
    for (i=0; i<4; i++) {
        le_underflow    = false;
        le_overflow     = false;
        //exp_underflow   = false;
        //exp_overflow    = false;
        lo_underflow    = false;
        lo_overflow     = false;
        le_hit          = false;
        lo_hit          = false;
        
        //re-write square_array in each iteration since it is empty after read
        for(int j=0; j<12; j++) square_array[j].write(square_result[j]);

        //***** Sum ******
        vFp32Type square_sum_result;

        if(sqsum_bypass)
        {
            square_sum_result = square_array[i+4].read();
        }
        else
        {
            ac_channel<vFp32Type>  square_sum_1, square_sum_2;

            HLS_fp32_add(square_array[i+3], square_array[i+5], square_sum_1); //3 + 5
            HLS_fp32_add(square_sum_1, square_array[i+4], square_sum_2); //sum3 = (3 + 5) + 4

            ac_channel<vFp32Type>  square_sum_3, square_sum_4;

            if(normalz_len > 0) //5+ elements
            {
                HLS_fp32_add(square_array[i+2], square_array[i+6], square_sum_3); //2 + 6
                HLS_fp32_add(square_sum_2, square_sum_3, square_sum_4); //sum5 = sum3 + (2 + 6)
            }

            ac_channel<vFp32Type>  square_sum_5, square_sum_6;
            
            if(normalz_len > 1) //7+ elements
            {
                HLS_fp32_add(square_array[i+1], square_array[i+7], square_sum_5); //1 + 7
                HLS_fp32_add(square_sum_4, square_sum_5, square_sum_6); //sum7 = sum5 + (1 + 7)
            }

            ac_channel<vFp32Type>  square_sum_7, square_sum_8;
            
            if(normalz_len > 2) //9 elements
            {
                HLS_fp32_add(square_array[i+0], square_array[i+8], square_sum_7); //1 + 7
                HLS_fp32_add(square_sum_6, square_sum_7, square_sum_8); //sum9 = sum7 + (0 + 8)
            }

            switch(normalz_len)
            {
                case 0: square_sum_result = square_sum_2.read(); break;
                case 1: square_sum_result = square_sum_4.read(); break;
                case 2: square_sum_result = square_sum_6.read(); break;
                case 3: square_sum_result = square_sum_8.read(); break;
#pragma CTC SKIP
                default: break;
#pragma CTC ENDSKIP
            }
        }
        cslDebug((70, "Square sum: %x\n", *(int *)(&square_sum_result) ));

        // Look up Raw table
        if(NVDLA_CDP_S_LUT_CFG_0_LUT_LE_FUNCTION_EXPONENT == raw_method) {    //raw lut is exponential
            cslDebug((70, "Lookup exp table\n"));
            HLS_CDP_lookup_lut(square_sum_result, 64, true, true, le_lut, le_start, le_end, le_slope_uflow_scale, le_slope_oflow_scale, le_index_offset, le_index_select, le_underflow, le_overflow, le_hit, chn_result_le_fp17);
        }
        else { // raw lut is linear
            cslDebug((70, "Lookup lin table\n"));
            HLS_CDP_lookup_lut(square_sum_result, 64, true, false, le_lut, le_start, le_end, le_slope_uflow_scale, le_slope_oflow_scale, le_index_offset, le_index_select, le_underflow, le_overflow, le_hit, chn_result_le_fp17);
        }

        cslDebug((70, "Lookup lo table\n"));
        // Look up LO(Linear Only) table
        HLS_CDP_lookup_lut(square_sum_result, 256, false, false, lo_lut, lo_start, lo_end, lo_slope_uflow_scale, lo_slope_oflow_scale, 0, lo_index_select, lo_underflow, lo_overflow, lo_hit, chn_result_lo_fp17);

        vFp17Type result_le = chn_result_le_fp17.read();
        vFp17Type result_lo = chn_result_lo_fp17.read();
        vFp17Type result_out;

        // Select result between RAW table and Density Table
        if(le_underflow && lo_underflow) {
            result_out = lut_uflow_priority? result_lo : result_le;
            (*lut_u_flow)++;
        }
        else if(le_overflow && lo_overflow) {
            result_out = lut_oflow_priority? result_lo : result_le;
            (*lut_o_flow)++;
        }
        else {
            if(le_hit ^ lo_hit) {
                result_out = le_hit? result_le : result_lo;
                if(le_hit)
                {
                    (*lut_le_hit)++;
		}
		else
		{
                    (*lut_lo_hit)++;
		}
            }
            else {
                if(lut_hybrid_priority)
                    result_out = result_lo;
                else
                    result_out = result_le;
                (*lut_hybrid_hit)++;
            }
        }

        cslDebug((70, "le:%x, lo:%x, out:%x\n" , *(int *)(&result_le), *(int *)(&result_lo), *(int *)(&result_out) ));

        if(mul_bypass)
        {
            float icvt_data_out_float = *(float *)&icvt_data_out_fp32[i+4];
            if(std::isnan(icvt_data_out_float))
            {
                chn_result_to_ocvt_fp17.write(icvt_data_out[i+4]);
            }
            else
            {
                chn_result_to_ocvt_fp17.write(result_out);
            }
        }
        else
        {
            ac_channel<vFp17Type> chn_result_fp17, chn_icvt_data_out_fp17;
            chn_result_fp17.write(result_out);
            vFp17Type icvt_data_out_fp17 = icvt_data_out[i+4];
            chn_icvt_data_out_fp17.write(icvt_data_out_fp17);
            HLS_fp17_mul(chn_icvt_data_out_fp17, chn_result_fp17, chn_result_to_ocvt_fp17);
        }

        // Output Converter
        int64_t ocvt_data_in = chn_result_to_ocvt_fp17.read();
        cslDebug((70, "ocvt_data_in:%x\n", (int)ocvt_data_in));
        uint8_t flag;
        cdp_ocvt_hls(&ocvt_data_in, datout_offset, datout_scale, datout_shifter, NVDLA_CDP_RDMA_D_DATA_FORMAT_0_INPUT_DATA_FP16, &normalz_out[i], &flag);
    }
}

