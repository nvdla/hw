// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_icvt_wrapper.cpp

#include "ac_int.h"
#include "ac_channel.h"
#include "log.h"
#include "cdp_icvt.h"
#include "vlibs.h"
#include <systemc.h>
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

void cdp_icvt_hls (
    int16_t  *cdp_icvt_data_in,      // 16bits
    int32_t  cdp_icvt_alu_op,       // 32bits
    int16_t  cdp_icvt_mul_op,       // 16bits
    uint8_t   cdp_icvt_truncate,     // 5bits
    uint8_t   cdp_icvt_precision,
    int32_t  *cdp_icvt_data_out)     // 17bits
{
    // Inputs
    ac_channel<vDataInType> chn_data_in;
    vAluInType      cfg_alu_in;
    vMulInType      cfg_mul_in;
    vTruncateType   cfg_truncate;
    ACINTF(2)       cfg_precision;

    // Outputs
    ac_channel<vOutType> chn_data_out;

    // Prepare Inputs
    vDataInType data_in = *cdp_icvt_data_in;
    chn_data_in.write(data_in);
    cfg_alu_in      = cdp_icvt_alu_op;
    cfg_mul_in      = cdp_icvt_mul_op;
    cfg_truncate    = cdp_icvt_truncate;
    cfg_precision   = cdp_icvt_precision;

    cslDebug((70, "cdp_icvt input: 0x%08x\n", cdp_icvt_data_in[0]));

    HLS_cdp_icvt(chn_data_in, cfg_alu_in, cfg_mul_in, cfg_truncate, cfg_precision, chn_data_out);

    // Get output
    cdp_icvt_data_out[0] = chn_data_out.read().to_int();
    cslDebug((70, "cdp_icvt output: 0x%08x\n", cdp_icvt_data_out[0]));
}
