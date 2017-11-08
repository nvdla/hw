// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: csc_hls_wrapper.cpp

#include "ac_int.h"
#include "ac_channel.h"
#include "log.h"
#include "csc_cvt.h"
#include "vlibs.h"
#include <systemc.h>
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#include "csc_hls_wrapper.h"

void csc_pra_hls (
    uint16_t  *csc_pra_data_in,         // 16bits (For INT8, it's signed from int8)
    uint8_t    csc_pra_precision,
    uint8_t    csc_pra_pra_truncate,
    int16_t  *csc_pra_data_out)
{
    int     i;
    // Inputs
    vDataStruct             data_in;
    ac_channel<vDataStruct> chn_data_in;
    ACINTF(2)               cfg_precision;
    ACINTF(2)               cfg_truncate;

    // Outputs
    vDataStruct             data_out;
    ac_channel<vDataStruct> chn_data_out;

    cslDebug((70, "%s enter\n", __FUNCTION__));

    // Prepare Inputs
    for (i=0; i<16; i++) {
        data_in.data[i]         = csc_pra_data_in[i];
    }
    chn_data_in.write(data_in);
    cfg_precision   = csc_pra_precision;
    cfg_truncate    = csc_pra_pra_truncate;

    //cslDebug((70, "csc_pra input: 0x%08x\n", *csc_data_in));

    NV_NVDLA_CSC_pra_cell(chn_data_in, cfg_precision, cfg_truncate, chn_data_out);

    // Get output
    data_out = chn_data_out.read();
    for (i=0; i<16; i++) {
        csc_pra_data_out[i] = data_out.data[i];
    }
    cslDebug((70, "%s end\n", __FUNCTION__));
    //cslDebug((70, "cdp_ipra output: 0x%08x\n", cdp_ipra_data_out[0]));
}
