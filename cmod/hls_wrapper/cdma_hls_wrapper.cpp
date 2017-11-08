// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdma_hls_wrapper.cpp

#include "ac_int.h"
#include "ac_channel.h"
#include "log.h"
#include "cdma_cvt.h"
#include "vlibs.h"
#include <systemc.h>
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#include "cdma_hls_wrapper.h"

void cdma_cvt_hls (
    int16_t  *cdma_cvt_data_in,     // 16bits
    uint8_t   input_data_type,
    uint16_t  cdma_cvt_alu_in,      // 16bits
    uint16_t  cdma_cvt_mul_in,      // 16bits
    uint8_t   cdma_cvt_in_precission,
    uint8_t   cdma_cvt_out_precission,
    uint8_t   cdma_cvt_truncate,
    int32_t  *cdma_cvt_data_out)
{
    bool      unsigned_int8;
    bool      signed_int8;
    bool      unsigned_int16;
    bool      signed_int16;
    bool      fp16;
    // Inputs
    vDataInType     data_in;        // 17bits
    vAluInType      cfg_alu_in;
    vMulInType      cfg_mul_in;
    ACINTF(2)       cfg_in_precision;
    ACINTF(2)       cfg_out_precision;
    vTruncateType   cfg_truncate;
    ac_channel<vDataInType> chn_data_in;
    ac_channel<vAluInType> chn_alu_in;

    // Output
    ac_channel<vDataOutType> chn_data_out;

    unsigned_int8   = input_data_type == PIXEL_UNSIGNED_INT8;
    signed_int8     = input_data_type == PIXEL_SIGNED_INT8;
    unsigned_int16  = input_data_type == PIXEL_UNSIGNED_INT16;
    signed_int16    = input_data_type == PIXEL_SIGNED_INT16;
    fp16            = input_data_type == PIXEL_FP16;

    // Prepare 17bits Input
    if(unsigned_int8) {
        data_in = (*cdma_cvt_data_in) & 0xff; // Set MSB to 0
        cslDebug((70, "cdma_hls_wrapper unsigned_int8: *cdma_cvt_data_in=0x%x data_in=0x%x\n", *cdma_cvt_data_in, data_in.to_int()));
    }
    else if(signed_int8) {
        if (((*cdma_cvt_data_in) & 0x80) !=0)  // negative
            data_in = (*cdma_cvt_data_in) | 0x1ff00;
        else
            data_in = (*cdma_cvt_data_in) & 0xff;   // Set MSB to 0
    }
    else if(unsigned_int16) {
        data_in = (*cdma_cvt_data_in) & 0xffff; // Set MSB to 0
        cslDebug((70, "cdma_hls_wrapper unsigned_int16: *cdma_cvt_data_in=0x%x data_in=0x%x\n", *cdma_cvt_data_in, data_in.to_int()));
    }
    else if(signed_int16) {
        if (((*cdma_cvt_data_in) & 0x8000) !=0)  // negative
            data_in = (*cdma_cvt_data_in) | 0x10000;
        else
            data_in = (*cdma_cvt_data_in) & 0xffff; // Set MSB to 0
        cslDebug((70, "cdma_hls_wrapper signed_int16: *cdma_cvt_data_in=0x%x data_in=0x%x\n", *cdma_cvt_data_in, data_in.to_int()));
    }
#pragma CTC SKIP
    else if(fp16) {  // FP16
        data_in = *cdma_cvt_data_in;
    }
    else {
        cslInfo(("Invalid data type\n"));
    }
#pragma CTC ENDSKIP

    chn_data_in.write(data_in);
    cfg_alu_in      = cdma_cvt_alu_in;
    chn_alu_in.write(cfg_alu_in);
    cfg_mul_in          = cdma_cvt_mul_in;
    cfg_in_precision    = cdma_cvt_in_precission;
    cfg_out_precision   = cdma_cvt_out_precission;
    cfg_truncate        = cdma_cvt_truncate;

    cslDebug((70, "cdma_cvt_hls data_in=0x%x alu_in=0x%x mul_in=0x%x in_precision=%d out_precision=%d truncate=0x%x\n", data_in.to_int(), cfg_alu_in.to_int(), cfg_mul_in.to_int(), cfg_in_precision.to_int(), cfg_out_precision.to_int(), cfg_truncate.to_int()));

    NV_NVDLA_CDMA_CVT_cell(chn_data_in, chn_alu_in, cfg_mul_in, cfg_in_precision, cfg_out_precision, cfg_truncate, chn_data_out);

    // Get output
    *cdma_cvt_data_out = chn_data_out.read().to_uint();
    cslDebug((70, "cdma_cvt_hls data_out=0x%x\n", *cdma_cvt_data_out));
}
