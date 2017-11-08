// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_glb_base.h

#ifndef _NV_NVDLA_GLB_BASE_H_
#define _NV_NVDLA_GLB_BASE_H_

#ifndef SC_INCLUDE_DYNAMIC_PROCESSES
#define SC_INCLUDE_DYNAMIC_PROCESSES
#endif
#include "NV_MSDEC_csb2xx_16m_secure_be_lvl_iface.h"
#include "nvdla_xx2csb_resp_iface.h"
#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_initiator_socket.h>
#include <tlm_utils/multi_passthrough_target_socket.h>

SCSIM_NAMESPACE_START(cmod)

// Base SystemC class for module NV_NVDLA_glb
class NV_NVDLA_glb_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_glb_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2glb_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_glb_base, 32, tlm::tlm_base_protocol_types> csb2glb_req;
    virtual void csb2glb_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb2glb_req_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2gec_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_glb_base, 32, tlm::tlm_base_protocol_types> csb2gec_req;
    virtual void csb2gec_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb2gec_req_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Port has no flow: sdp2glb_done_intr
    sc_vector< sc_in<bool> > sdp2glb_done_intr;

    // Port has no flow: cdp2glb_done_intr
    sc_vector< sc_in<bool> > cdp2glb_done_intr;

    // Port has no flow: pdp2glb_done_intr
    sc_vector< sc_in<bool> > pdp2glb_done_intr;

    // Port has no flow: bdma2glb_done_intr
    sc_vector< sc_in<bool> > bdma2glb_done_intr;

    // Port has no flow: bdma2glb_done_intr
    sc_vector< sc_in<bool> > rbk2glb_done_intr;

    // Port has no flow: cdma_dat2glb_done_intr
    sc_vector< sc_in<bool> > cdma_dat2glb_done_intr;

    // Port has no flow: cdma_wt2glb_done_intr
    sc_vector< sc_in<bool> > cdma_wt2glb_done_intr;

    // Port has no flow: cacc2glb_done_intr
    sc_vector< sc_in<bool> > cacc2glb_done_intr;

    // Port has no flow: nvdla_fault_report_uncorrected
    // sc_out<bool> nvdla_fault_report_uncorrected;

    // Port has no flow: nvdla_fault_report_corrected
    // sc_out<bool> nvdla_fault_report_corrected;

    // Port has no flow: nvdla_intr
    sc_out<bool> nvdla_intr;

    // Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): glb2csb_resp
    tlm::tlm_generic_payload glb2csb_resp_bp;
    nvdla_xx2csb_resp_t glb2csb_resp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_glb_base, 32, tlm::tlm_base_protocol_types> glb2csb_resp;
    virtual void glb2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): gec2csb_resp
    tlm::tlm_generic_payload gec2csb_resp_bp;
    nvdla_xx2csb_resp_t gec2csb_resp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_glb_base, 32, tlm::tlm_base_protocol_types> gec2csb_resp;
    virtual void gec2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay);

    // Destructor
    virtual ~NV_NVDLA_glb_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_GLB
inline NV_NVDLA_glb_base::NV_NVDLA_glb_base(const sc_module_name name)
    : sc_module(name),
    csb2glb_req("csb2glb_req"),
    csb2gec_req("csb2gec_req"),
    sdp2glb_done_intr("sdp2glb_done_intr", 2),
    cdp2glb_done_intr("cdp2glb_done_intr", 2),
    pdp2glb_done_intr("pdp2glb_done_intr", 2),
    bdma2glb_done_intr("bdma2glb_done_intr", 2),
    rbk2glb_done_intr("rbk2glb_done_intr", 2),
    cdma_dat2glb_done_intr("cdma_dat2glb_done_intr", 2),
    cdma_wt2glb_done_intr("cdma_wt2glb_done_intr", 2),
    cacc2glb_done_intr("cacc2glb_done_intr", 2),
//    nvdla_fault_report_uncorrected("nvdla_fault_report_uncorrected"),
//    nvdla_fault_report_corrected("nvdla_fault_report_corrected"),
    nvdla_intr("nvdla_intr"),
    glb2csb_resp_bp(),
    glb2csb_resp("glb2csb_resp"),
    gec2csb_resp_bp(),
    gec2csb_resp("gec2csb_resp")
{
    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2glb_req
    this->csb2glb_req.register_b_transport(this, &NV_NVDLA_glb_base::csb2glb_req_b_transport);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2gec_req
    this->csb2gec_req.register_b_transport(this, &NV_NVDLA_glb_base::csb2gec_req_b_transport);
}

inline void
NV_NVDLA_glb_base::csb2glb_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    csb2glb_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_glb_base::csb2gec_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    csb2gec_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_glb_base::glb2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    glb2csb_resp_bp.set_data_ptr((unsigned char*) payload);
    glb2csb_resp->b_transport(glb2csb_resp_bp, delay);
}

inline void
NV_NVDLA_glb_base::gec2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    gec2csb_resp_bp.set_data_ptr((unsigned char*) payload);
    gec2csb_resp->b_transport(gec2csb_resp_bp, delay);
}

SCSIM_NAMESPACE_END()

#endif
