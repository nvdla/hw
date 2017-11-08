// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cacc_base.h

#ifndef _NV_NVDLA_CACC_BASE_H_
#define _NV_NVDLA_CACC_BASE_H_

#define SC_INCLUDE_DYNAMIC_PROCESSES
#include "NV_MSDEC_csb2xx_16m_secure_be_lvl_iface.h"
#include "nvdla_xx2csb_resp_iface.h"

#include "nvdla_accu2pp_if_iface.h"
#include "nvdla_cc_credit_iface.h"
#include "nvdla_mac2accu_if_iface.h"
#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_initiator_socket.h>
#include <tlm_utils/multi_passthrough_target_socket.h>

SCSIM_NAMESPACE_START(cmod)

// Base SystemC class for module NV_NVDLA_cacc
class NV_NVDLA_cacc_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_cacc_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cacc_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cacc_base, 32, tlm::tlm_base_protocol_types> csb2cacc_req;
    virtual void csb2cacc_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb2cacc_req_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_mac2accu_data_if_t): mac_a2accu
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cacc_base, 32, tlm::tlm_base_protocol_types> mac_a2accu;
    virtual void mac_a2accu_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mac_a2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_mac2accu_data_if_t): mac_b2accu
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cacc_base, 32, tlm::tlm_base_protocol_types> mac_b2accu;
    virtual void mac_b2accu_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mac_b2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay) = 0;

    // Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cacc2csb_resp
    tlm::tlm_generic_payload cacc2csb_resp_bp;
    nvdla_xx2csb_resp_t cacc2csb_resp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cacc_base, 32, tlm::tlm_base_protocol_types> cacc2csb_resp;
    virtual void cacc2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_cc_credit_t): accu2sc_credit
    tlm::tlm_generic_payload accu2sc_credit_bp;
    nvdla_cc_credit_t accu2sc_credit_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cacc_base, 32, tlm::tlm_base_protocol_types> accu2sc_credit;
    virtual void accu2sc_credit_b_transport(nvdla_cc_credit_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_accu2pp_if_t): cacc2sdp
    tlm::tlm_generic_payload cacc2sdp_bp;
    nvdla_accu2pp_if_t cacc2sdp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cacc_base, 32, tlm::tlm_base_protocol_types> cacc2sdp;
    virtual void cacc2sdp_b_transport(nvdla_accu2pp_if_t* payload, sc_time& delay);

    // Port has no flow: cacc2glb_done_intr
    // sc_vector< sc_out<bool> > cacc2glb_done_intr;

    // Destructor
    virtual ~NV_NVDLA_cacc_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_cacc
inline NV_NVDLA_cacc_base::NV_NVDLA_cacc_base(const sc_module_name name)
    : sc_module(name),
    csb2cacc_req("csb2cacc_req"),
    mac_a2accu("mac_a2accu"),
    mac_b2accu("mac_b2accu"),
    cacc2csb_resp_bp(),
    cacc2csb_resp("cacc2csb_resp"),
    accu2sc_credit_bp(),
    accu2sc_credit("accu2sc_credit"),
    cacc2sdp_bp(),
    cacc2sdp("cacc2sdp")
    //cacc2glb_done_intr("cacc2glb_done_intr", 2)
{
    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cacc_req
    this->csb2cacc_req.register_b_transport(this, &NV_NVDLA_cacc_base::csb2cacc_req_b_transport);

    this->mac_a2accu.register_b_transport(this, &NV_NVDLA_cacc_base::mac_a2accu_b_transport);
    this->mac_b2accu.register_b_transport(this, &NV_NVDLA_cacc_base::mac_b2accu_b_transport);
    // Target Socket (unrecognized protocol: nvdla_mac2accu_data_if_t): mac2accu
    // this->mac2accu.register_b_transport(this, &NV_NVDLA_cacc_base::mac2accu_b_transport);

}

inline void
NV_NVDLA_cacc_base::csb2cacc_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    csb2cacc_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cacc_base::mac_a2accu_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_mac2accu_data_if_t* payload = (nvdla_mac2accu_data_if_t*) bp.get_data_ptr();
    mac_a2accu_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cacc_base::mac_b2accu_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_mac2accu_data_if_t* payload = (nvdla_mac2accu_data_if_t*) bp.get_data_ptr();
    mac_b2accu_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cacc_base::cacc2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    cacc2csb_resp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cacc2csb_resp.size(); socket_id++) {
        cacc2csb_resp[socket_id]->b_transport(cacc2csb_resp_bp, delay);
    }
}

inline void
NV_NVDLA_cacc_base::accu2sc_credit_b_transport(nvdla_cc_credit_t* payload, sc_time& delay)
{
    accu2sc_credit_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < accu2sc_credit.size(); socket_id++) {
        accu2sc_credit[socket_id]->b_transport(accu2sc_credit_bp, delay);
    }
}

inline void
NV_NVDLA_cacc_base::cacc2sdp_b_transport(nvdla_accu2pp_if_t* payload, sc_time& delay)
{
    cacc2sdp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cacc2sdp.size(); socket_id++) {
        cacc2sdp[socket_id]->b_transport(cacc2sdp_bp, delay);
    }
}

SCSIM_NAMESPACE_END()

#endif
