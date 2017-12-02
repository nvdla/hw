// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_glb_glb_gen.h

#include "NV_NVDLA_glb.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)

inline void
NV_NVDLA_glb::csb2glb_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) {
    uint32_t addr;
    uint32_t data;
    uint8_t write;
    uint8_t nposted;
    uint8_t error_id=0;
    bool    register_access_result;
    if (true == is_there_ongoing_csb2glb_response_) {
        FAIL(("NVDLA NV_NVDLA_glb::csb2glb_b_transport: there is onging CSB response."));
    } else {
        is_there_ongoing_csb2glb_response_ = true;
    }
    // Extract CSB request information from payload
    if (NULL != payload) {
        addr = payload->pd.csb2xx_16m_secure_be_lvl.addr;
        data = payload->pd.csb2xx_16m_secure_be_lvl.wdat;
        write = payload->pd.csb2xx_16m_secure_be_lvl.write;
        nposted = payload->pd.csb2xx_16m_secure_be_lvl.nposted;
    } else {
        FAIL(("NVDLA NV_NVDLA_glb::csb2glb_b_transport: payload pointer shall not be NULL"));
    }
    // Accessing registers
    register_access_result = GlbAccessRegister (addr, data, 0!=write);
    if (false == register_access_result) {
        error_id = 1;
    }
    // Read and nposted write need to send response data
    if ( (0==write) || (0!=nposted) ) {
        // Read     or  is non-posted
        GlbSendCsbResponse(write, data, error_id);
    }
    is_there_ongoing_csb2glb_response_ = false;
}

inline void
NV_NVDLA_glb::GlbSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id) {
    nvdla_xx2csb_resp_t payload;
    if (0==type) {
        // Read return data
        payload.pd.xx2csb_rd_erpt.error   = error_id;
        payload.pd.xx2csb_rd_erpt.rdat    = data;
		payload.tag =  XX2CSB_RESP_TAG_READ;
    } else {
        // Write return data
        payload.pd.xx2csb_wr_erpt.error   = error_id;
        payload.pd.xx2csb_wr_erpt.rdat    = 0;
		payload.tag =  XX2CSB_RESP_TAG_WRITE;
    }
    NV_NVDLA_glb_base::glb2csb_resp_b_transport(&payload, b_transport_delay_);
}
