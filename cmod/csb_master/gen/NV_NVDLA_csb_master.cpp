// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_csb_master.cpp

#include "NV_NVDLA_csb_master.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>
#include "log.h"

#define NVDLA_AMAP_BASE_MASK 0xFFFFF000
#define NVDLA_CSB_ADDR_COMPENSATION 0x00001000

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)


// Constructor
NV_NVDLA_csb_master::NV_NVDLA_csb_master( sc_module_name module_name )
    :NV_NVDLA_csb_master_base(module_name),
    csb2nvdla_wr_hack_bp(),
    csb2nvdla_wr_hack("csb2nvdla_wr"),
    serving_client_id(0xFFFFFFFF)
{

}

// Deconstructor
NV_NVDLA_csb_master::~NV_NVDLA_csb_master() {
}

inline void
NV_NVDLA_csb_master::nvdla2csb_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) {
    payload->pd.csb2xx_16m_secure_be_lvl.addr = payload->pd.csb2xx_16m_secure_be_lvl.addr << 2;

    if (0xFFFFFFFF!=serving_client_id) {
        // There is ongoing resquest, wait
    }
    // Both read request and none-posted write shall wait for response
    if ( (0==payload->pd.csb2xx_16m_secure_be_lvl.write) || (0!=payload->pd.csb2xx_16m_secure_be_lvl.write && 0!=payload->pd.csb2xx_16m_secure_be_lvl.nposted) ) {
        serving_client_id = payload->pd.csb2xx_16m_secure_be_lvl.addr & NVDLA_AMAP_BASE_MASK;
    }
    if (0!=payload->pd.csb2xx_16m_secure_be_lvl.write) {
        // Write request
        serving_client_id |= 0x1;
    }
    // Invoke client initiator
    uint32_t base_addr = payload->pd.csb2xx_16m_secure_be_lvl.addr & NVDLA_AMAP_BASE_MASK;
    cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, base_addr: 0x%x\x0A", base_addr));
    switch (base_addr) {
        case GLB_BASE:
            csb2glb_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to GLB_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2glb_req_b_transport(&csb2glb_req_payload, delay);
            break;
        case GEC_BASE:
            csb2gec_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to GEC_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2gec_req_b_transport(&csb2gec_req_payload, delay);
            break;
        case MCIF_BASE:
            csb2mcif_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to MCIF_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2mcif_req_b_transport(&csb2mcif_req_payload, delay);
            break;
        case CVIF_BASE:
            csb2cvif_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to CVIF_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2cvif_req_b_transport(&csb2cvif_req_payload, delay);
            break;
        case BDMA_BASE:
            csb2bdma_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to BDMA_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2bdma_req_b_transport(&csb2bdma_req_payload, delay);
            break;
        case CDMA_BASE:
            csb2cdma_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to CDMA_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2cdma_req_b_transport(&csb2cdma_req_payload, delay);
            break;
        case CSC_BASE:
            csb2csc_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to CSC_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2csc_req_b_transport(&csb2csc_req_payload, delay);
            break;
        case CMAC_A_BASE:
            csb2cmac_a_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to CMAC_A_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2cmac_a_req_b_transport(&csb2cmac_a_req_payload, delay);
            break;
        case CMAC_B_BASE:
            csb2cmac_b_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to CMAC_B_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2cmac_b_req_b_transport(&csb2cmac_b_req_payload, delay);
            break;
        case CACC_BASE:
            csb2cacc_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to CACC_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2cacc_req_b_transport(&csb2cacc_req_payload, delay);
            break;
        case SDP_RDMA_BASE:
            csb2sdp_rdma_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to SDP_RDMA_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2sdp_rdma_req_b_transport(&csb2sdp_rdma_req_payload, delay);
            break;
        case SDP_BASE:
            csb2sdp_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to SDP_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2sdp_req_b_transport(&csb2sdp_req_payload, delay);
            break;
        case PDP_RDMA_BASE:
            csb2pdp_rdma_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to PDP_RDMA_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2pdp_rdma_req_b_transport(&csb2pdp_rdma_req_payload, delay);
            break;
        case PDP_BASE:
            csb2pdp_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to PDP_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2pdp_req_b_transport(&csb2pdp_req_payload, delay);
            break;
        case CDP_RDMA_BASE:
            csb2cdp_rdma_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to CDP_RDMA_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2cdp_rdma_req_b_transport(&csb2cdp_rdma_req_payload, delay);
            break;
        case CDP_BASE:
            csb2cdp_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to CDP_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2cdp_req_b_transport(&csb2cdp_req_payload, delay);
            break;
        case RBK_BASE:
            csb2rbk_req_payload = *payload;
            cslDebug((30, "NV_NVDLA_csb_master::nvdla2csb_b_transport, csb req to RBK_BASE, \x0A"));
            cslDebug((30, "Addr: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.addr));
            cslDebug((30, "Data: 0x%x\x0A", payload->pd.csb2xx_16m_secure_be_lvl.wdat));
            cslDebug((30, "Is write: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.write)));
            cslDebug((30, "nposted: 0x%x\x0A", uint32_t(payload->pd.csb2xx_16m_secure_be_lvl.nposted)));
            csb2rbk_req_b_transport(&csb2rbk_req_payload, delay);
            break;

        default:
            FAIL(("NV_NVDLA_csb_master::nvdla2csb_b_transport: Receiving an invalid csb address to nvdla sub-units. payload->pd.csb2xx_16m_secure_be_lvl.addr = 0x%x, base_addr=0x%x", payload->pd.csb2xx_16m_secure_be_lvl.addr, base_addr));

    }
}

inline void
NV_NVDLA_csb_master::csb2nvdla_wr_hack_b_transport(NV_MSDEC_xx2csb_wr_erpt_t* payload, sc_time& delay) {
    uint8_t *csb2nvdla_wr_hack_bp_byte_enable_ptr;
    uint32_t payload_byte_size;
    payload_byte_size = sizeof(NV_MSDEC_xx2csb_wr_erpt_t);
    csb2nvdla_wr_hack_bp_byte_enable_ptr   = new uint8_t[payload_byte_size];
    memset(csb2nvdla_wr_hack_bp_byte_enable_ptr, 0xFF, payload_byte_size);
    csb2nvdla_wr_hack_bp.set_data_ptr((unsigned char*) payload);
    csb2nvdla_wr_hack_bp.set_data_length(payload_byte_size);
    csb2nvdla_wr_hack_bp.set_byte_enable_ptr((unsigned char*)csb2nvdla_wr_hack_bp_byte_enable_ptr);
    csb2nvdla_wr_hack_bp.set_byte_enable_length(payload_byte_size);
    csb2nvdla_wr_hack_bp.set_command(tlm::TLM_WRITE_COMMAND);
    csb2nvdla_wr_hack->b_transport(csb2nvdla_wr_hack_bp, delay);
    delete[] csb2nvdla_wr_hack_bp_byte_enable_ptr;

    // csb2nvdla_wr_hack_bp.set_data_ptr((unsigned char*) payload);
    // csb2nvdla_wr_hack->b_transport(csb2nvdla_wr_hack_bp, delay);
}

inline void
NV_NVDLA_csb_master::glb2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::glb: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (GLB_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::glb: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::glb2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::glb2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::gec2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::gec: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (GEC_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::gec: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::gec2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::gec2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::mcif2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::mcif: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (MCIF_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::mcif: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::mcif2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::mcif2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::cvif2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::cvif: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (CVIF_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::cvif: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cvif2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cvif2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::bdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::bdma: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (BDMA_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::bdma: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::bdma2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::bdma2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::cdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::cdma: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (CDMA_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::cdma: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cdma2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cdma2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::csc2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::csc: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (CSC_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::csc: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::csc2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::csc2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::cmac_a2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::cmac_a: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (CMAC_A_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::cmac_a: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cmac_a2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cmac_a2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::cmac_b2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::cmac_b: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (CMAC_B_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::cmac_b: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cmac_b2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cmac_b2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::cacc2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::cacc: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (CACC_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::cacc: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cacc2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cacc2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::sdp_rdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::sdp_rdma: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (SDP_RDMA_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::sdp_rdma: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::sdp_rdma2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::sdp_rdma2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::sdp2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::sdp: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (SDP_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::sdp: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::sdp2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::sdp2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::pdp_rdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::pdp_rdma: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (PDP_RDMA_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::pdp_rdma: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::pdp_rdma2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::pdp_rdma2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::pdp2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::pdp: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (PDP_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::pdp: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::pdp2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::pdp2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::cdp_rdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::cdp_rdma: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (CDP_RDMA_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::cdp_rdma: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cdp_rdma2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cdp_rdma2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::cdp2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::cdp: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (CDP_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::cdp: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cdp2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::cdp2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}

inline void
NV_NVDLA_csb_master::rbk2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    // uint8_t bit_iter;
    // Check is nvdla waiting for a request
    if (0xFFFFFFFF == serving_client_id) {
        FAIL(("NV_NVDLA_csb_master::rbk: Client sends out a CSB response without receiving a CSB request."));
    }
    // Check base matches with serving_client_id
    if (RBK_BASE != (serving_client_id & NVDLA_AMAP_BASE_MASK)) {
        FAIL(("NV_NVDLA_csb_master::rbk: Client sends out a CSB response without receiving a CSB request."));
    }
    // if ((serving_client_id & 0x1)!=0) {}
    if (XX2CSB_RESP_TAG_WRITE==payload->tag) {
        // Write response, invoke csb2nvdla read response initiator socket
        // Not use csb2nvdla_wr_hack_payload which is connected to dummy
        // In TB, only csb2nvdla_payload is checked.
        csb2nvdla_payload.error                    = payload->pd.xx2csb_wr_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_wr_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::rbk2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
        // for (bit_iter = 0; bit_iter < 32; bit_iter++) {
        //     if ( (payload->pd.xx2csb_wr_erpt.error & (0x1<<bit_iter)) != 0x0 ) {
        //         csb2nvdla_wr[bit_iter] = true;
        //     } else {
        //         csb2nvdla_wr[bit_iter] = false;
        //     }
        // }
        // if (payload->pd.xx2csb_wr_erpt.error != 0x0) {
        //     csb2nvdla_wr[32] = true;
        // } else {
        //     csb2nvdla_wr[32] = false;
        // }
        // csb2nvdla_wr[33] = true;
    } else {
        // Read response, invoke csb2nvdla read response initiator socket
        csb2nvdla_payload.error                    = payload->pd.xx2csb_rd_erpt.error;
        csb2nvdla_payload.pd.xx2csb.rdat           = payload->pd.xx2csb_rd_erpt.rdat;
        cslDebug((30, "NV_NVDLA_csb_master::rbk2csb_resp_b_transport. Err bit: 0x\x25x Data: 0x\x25x\x0A", uint32_t(csb2nvdla_payload.error), csb2nvdla_payload.pd.xx2csb.rdat));
        csb2nvdla_b_transport(&csb2nvdla_payload, delay);
    }
    serving_client_id = 0xFFFFFFFF;
}



