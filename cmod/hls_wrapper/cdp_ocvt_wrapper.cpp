// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_ocvt_wrapper.cpp

#include "ac_int.h"
#include "ac_channel.h"
#include "log.h"
#include "cdp_ocvt.h"
#include "vlibs.h"
#include <systemc.h>
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

void cdp_ocvt_hls(
    int64_t *cdp_ocvt_data_in,      // 17bits
    int32_t  cdp_ocvt_alu_op,       // 32bits
    int16_t  cdp_ocvt_mul_op,       // 16bits
    uint8_t   cdp_ocvt_truncate,     // 5bits
    uint8_t   cdp_ocvt_precision,
    int16_t  *cdp_ocvt_data_out,
    uint8_t  *o_flow)     // 2bits
{
    // Inputs
    ac_channel<vInType> chn_data_in;
    vAluInType      cfg_alu_in;
    vMulInType      cfg_mul_in;
    vTruncateType   cfg_truncate;
    ACINTF(2)       cfg_precision;
    ACINTF(2)       status_saturation;

    // Outputs
    ac_channel<vOutStruct> chn_data_out;

    // Prepare Inputs
    vInType data_in = *cdp_ocvt_data_in;
    chn_data_in.write(data_in);
    cfg_alu_in      = cdp_ocvt_alu_op;
    cfg_mul_in      = cdp_ocvt_mul_op;
    cfg_truncate    = cdp_ocvt_truncate;
    cfg_precision   = cdp_ocvt_precision;

    cslDebug((70, "cdp_ocvt input: 0x%08x\n", (uint32_t)cdp_ocvt_data_in[0]));

    HLS_cdp_ocvt(chn_data_in, cfg_alu_in, cfg_mul_in, cfg_truncate, cfg_precision, chn_data_out);

    // Get output
    vOutStruct cdp_ocvt_out = chn_data_out.read();
    cdp_ocvt_data_out[0] = cdp_ocvt_out.data.to_int();
    *o_flow              = cdp_ocvt_out.sat.to_int();
    cslDebug((70, "cdp_ocvt output data: 0x%08x\n", (uint32_t)cdp_ocvt_data_out[0]));
}
