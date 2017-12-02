// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_csb_master_base.h

#ifndef _NV_NVDLA_CSB_MASTER_BASE_H_
#define _NV_NVDLA_CSB_MASTER_BASE_H_

#define SC_INCLUDE_DYNAMIC_PROCESSES
#include "NV_MSDEC_csb2xx_16m_secure_be_lvl_iface.h"
#include "NV_MSDEC_xx2csb_erpt_iface.h"
#include "nvdla_xx2csb_resp_iface.h"

#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_initiator_socket.h>
#include <tlm_utils/multi_passthrough_target_socket.h>

SCSIM_NAMESPACE_START(cmod)

// Base SystemC class for module NV_NVDLA_csb_master
class NV_NVDLA_csb_master_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_csb_master_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): nvdla2csb
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> nvdla2csb;
    virtual void nvdla2csb_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void nvdla2csb_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): glb2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> glb2csb_resp;
    virtual void glb2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void glb2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (nvdla_xx2csb_resp): gec2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base> gec2csb_resp;
    virtual void gec2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& gp, sc_time& delay);
    virtual void gec2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): mcif2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> mcif2csb_resp;
    virtual void mcif2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mcif2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cvif2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> cvif2csb_resp;
    virtual void cvif2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cvif2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): bdma2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> bdma2csb_resp;
    virtual void bdma2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void bdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cdma2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> cdma2csb_resp;
    virtual void cdma2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): csc2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csc2csb_resp;
    virtual void csc2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csc2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cmac_a2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> cmac_a2csb_resp;
    virtual void cmac_a2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cmac_a2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cmac_b2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> cmac_b2csb_resp;
    virtual void cmac_b2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cmac_b2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cacc2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> cacc2csb_resp;
    virtual void cacc2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cacc2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): sdp_rdma2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> sdp_rdma2csb_resp;
    virtual void sdp_rdma2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sdp_rdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): sdp2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> sdp2csb_resp;
    virtual void sdp2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sdp2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): pdp_rdma2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> pdp_rdma2csb_resp;
    virtual void pdp_rdma2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void pdp_rdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): pdp2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> pdp2csb_resp;
    virtual void pdp2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void pdp2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cdp_rdma2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> cdp_rdma2csb_resp;
    virtual void cdp_rdma2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdp_rdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cdp2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> cdp2csb_resp;
    virtual void cdp2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdp2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): rbk2csb_resp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> rbk2csb_resp;
    virtual void rbk2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void rbk2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay) = 0;

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2glb_req
    tlm::tlm_generic_payload csb2glb_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2glb_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2glb_req;
    virtual void csb2glb_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (NV_MSDEC_csb2xx_16m_be_lvl): csb2gec_req
    tlm::tlm_generic_payload csb2gec_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2gec_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base> csb2gec_req;
    virtual void csb2gec_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2mcif_req
    tlm::tlm_generic_payload csb2mcif_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2mcif_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2mcif_req;
    virtual void csb2mcif_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cvif_req
    tlm::tlm_generic_payload csb2cvif_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2cvif_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2cvif_req;
    virtual void csb2cvif_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2bdma_req
    tlm::tlm_generic_payload csb2bdma_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2bdma_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2bdma_req;
    virtual void csb2bdma_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cdma_req
    tlm::tlm_generic_payload csb2cdma_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2cdma_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2cdma_req;
    virtual void csb2cdma_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2csc_req
    tlm::tlm_generic_payload csb2csc_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2csc_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2csc_req;
    virtual void csb2csc_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cmac_a_req
    tlm::tlm_generic_payload csb2cmac_a_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2cmac_a_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2cmac_a_req;
    virtual void csb2cmac_a_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cmac_b_req
    tlm::tlm_generic_payload csb2cmac_b_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2cmac_b_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2cmac_b_req;
    virtual void csb2cmac_b_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cacc_req
    tlm::tlm_generic_payload csb2cacc_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2cacc_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2cacc_req;
    virtual void csb2cacc_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2sdp_rdma_req
    tlm::tlm_generic_payload csb2sdp_rdma_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2sdp_rdma_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2sdp_rdma_req;
    virtual void csb2sdp_rdma_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2sdp_req
    tlm::tlm_generic_payload csb2sdp_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2sdp_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2sdp_req;
    virtual void csb2sdp_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2pdp_rdma_req
    tlm::tlm_generic_payload csb2pdp_rdma_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2pdp_rdma_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2pdp_rdma_req;
    virtual void csb2pdp_rdma_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2pdp_req
    tlm::tlm_generic_payload csb2pdp_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2pdp_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2pdp_req;
    virtual void csb2pdp_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cdp_rdma_req
    tlm::tlm_generic_payload csb2cdp_rdma_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2cdp_rdma_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2cdp_rdma_req;
    virtual void csb2cdp_rdma_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cdp_req
    tlm::tlm_generic_payload csb2cdp_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2cdp_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2cdp_req;
    virtual void csb2cdp_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2rbk_req
    tlm::tlm_generic_payload csb2rbk_req_bp;
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t csb2rbk_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2rbk_req;
    virtual void csb2rbk_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: NV_MSDEC_xx2csb_erpt_t): csb2nvdla
    tlm::tlm_generic_payload csb2nvdla_bp;
    NV_MSDEC_xx2csb_erpt_t csb2nvdla_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master_base, 32, tlm::tlm_base_protocol_types> csb2nvdla;
    virtual void csb2nvdla_b_transport(NV_MSDEC_xx2csb_erpt_t* payload, sc_time& delay);

    // Destructor
    virtual ~NV_NVDLA_csb_master_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_csb_master
inline NV_NVDLA_csb_master_base::NV_NVDLA_csb_master_base(const sc_module_name name)
    : sc_module(name),
    nvdla2csb("nvdla2csb"),
    glb2csb_resp("glb2csb_resp"),
    gec2csb_resp("gec2csb_resp"),
    mcif2csb_resp("mcif2csb_resp"),
    cvif2csb_resp("cvif2csb_resp"),
    bdma2csb_resp("bdma2csb_resp"),
    cdma2csb_resp("cdma2csb_resp"),
    csc2csb_resp("csc2csb_resp"),
    cmac_a2csb_resp("cmac_a2csb_resp"),
    cmac_b2csb_resp("cmac_b2csb_resp"),
    cacc2csb_resp("cacc2csb_resp"),
    sdp_rdma2csb_resp("sdp_rdma2csb_resp"),
    sdp2csb_resp("sdp2csb_resp"),
    pdp_rdma2csb_resp("pdp_rdma2csb_resp"),
    pdp2csb_resp("pdp2csb_resp"),
    cdp_rdma2csb_resp("cdp_rdma2csb_resp"),
    cdp2csb_resp("cdp2csb_resp"),
    rbk2csb_resp("rbk2csb_resp"),
    csb2glb_req_bp(),
    csb2glb_req("csb2glb_req"),
    csb2gec_req_bp(),
    csb2gec_req("csb2gec_req"),
    csb2mcif_req_bp(),
    csb2mcif_req("csb2mcif_req"),
    csb2cvif_req_bp(),
    csb2cvif_req("csb2cvif_req"),
    csb2bdma_req_bp(),
    csb2bdma_req("csb2bdma_req"),
    csb2cdma_req_bp(),
    csb2cdma_req("csb2cdma_req"),
    csb2csc_req_bp(),
    csb2csc_req("csb2csc_req"),
    csb2cmac_a_req_bp(),
    csb2cmac_a_req("csb2cmac_a_req"),
    csb2cmac_b_req_bp(),
    csb2cmac_b_req("csb2cmac_b_req"),
    csb2cacc_req_bp(),
    csb2cacc_req("csb2cacc_req"),
    csb2sdp_rdma_req_bp(),
    csb2sdp_rdma_req("csb2sdp_rdma_req"),
    csb2sdp_req_bp(),
    csb2sdp_req("csb2sdp_req"),
    csb2pdp_rdma_req_bp(),
    csb2pdp_rdma_req("csb2pdp_rdma_req"),
    csb2pdp_req_bp(),
    csb2pdp_req("csb2pdp_req"),
    csb2cdp_rdma_req_bp(),
    csb2cdp_rdma_req("csb2cdp_rdma_req"),
    csb2cdp_req_bp(),
    csb2cdp_req("csb2cdp_req"),
    csb2rbk_req_bp(),
    csb2rbk_req("csb2rbk_req"),
    csb2nvdla_bp(),
    csb2nvdla("csb2nvdla")
{
    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): nvdla2csb
    this->nvdla2csb.register_b_transport(this, &NV_NVDLA_csb_master_base::nvdla2csb_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): glb2csb_resp
    this->glb2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::glb2csb_resp_b_transport);

    // Target Socket (nvdla_xx2csb_resp): gec2csb_resp
    this->gec2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::gec2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): mcif2csb_resp
    this->mcif2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::mcif2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cvif2csb_resp
    this->cvif2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::cvif2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): bdma2csb_resp
    this->bdma2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::bdma2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cdma2csb_resp
    this->cdma2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::cdma2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): csc2csb_resp
    this->csc2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::csc2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cmac_a2csb_resp
    this->cmac_a2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::cmac_a2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cmac_b2csb_resp
    this->cmac_b2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::cmac_b2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cacc2csb_resp
    this->cacc2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::cacc2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): sdp_rdma2csb_resp
    this->sdp_rdma2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::sdp_rdma2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): sdp2csb_resp
    this->sdp2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::sdp2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): pdp_rdma2csb_resp
    this->pdp_rdma2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::pdp_rdma2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): pdp2csb_resp
    this->pdp2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::pdp2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cdp_rdma2csb_resp
    this->cdp_rdma2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::cdp_rdma2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cdp2csb_resp
    this->cdp2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::cdp2csb_resp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_xx2csb_resp_t): rbk2csb_resp
    this->rbk2csb_resp.register_b_transport(this, &NV_NVDLA_csb_master_base::rbk2csb_resp_b_transport);

}

inline void
NV_NVDLA_csb_master_base::nvdla2csb_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    nvdla2csb_b_transport(ID, payload, delay);
    bp.set_response_status(tlm::TLM_OK_RESPONSE);

}

inline void
NV_NVDLA_csb_master_base::glb2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    glb2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::gec2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    gec2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::mcif2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    mcif2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::cvif2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    cvif2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::bdma2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    bdma2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::rbk2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    rbk2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::cdma2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    cdma2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::csc2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    csc2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::cmac_a2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    cmac_a2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::cmac_b2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    cmac_b2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::cacc2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    cacc2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::sdp_rdma2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    sdp_rdma2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::sdp2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    sdp2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::pdp_rdma2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    pdp_rdma2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::pdp2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    pdp2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::cdp_rdma2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    cdp_rdma2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::cdp2csb_resp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_xx2csb_resp_t* payload = (nvdla_xx2csb_resp_t*) bp.get_data_ptr();
    cdp2csb_resp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2glb_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2glb_req_bp.set_data_ptr((unsigned char*) payload);
    csb2glb_req->b_transport(csb2glb_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2gec_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2gec_req_bp.set_data_ptr((unsigned char*) payload);
    csb2gec_req->b_transport(csb2gec_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2mcif_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2mcif_req_bp.set_data_ptr((unsigned char*) payload);
    csb2mcif_req->b_transport(csb2mcif_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2cvif_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2cvif_req_bp.set_data_ptr((unsigned char*) payload);
    csb2cvif_req->b_transport(csb2cvif_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2bdma_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2bdma_req_bp.set_data_ptr((unsigned char*) payload);
    csb2bdma_req->b_transport(csb2bdma_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2rbk_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2rbk_req_bp.set_data_ptr((unsigned char*) payload);
    csb2rbk_req->b_transport(csb2rbk_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2cdma_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2cdma_req_bp.set_data_ptr((unsigned char*) payload);
    csb2cdma_req->b_transport(csb2cdma_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2csc_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2csc_req_bp.set_data_ptr((unsigned char*) payload);
    csb2csc_req->b_transport(csb2csc_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2cmac_a_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2cmac_a_req_bp.set_data_ptr((unsigned char*) payload);
    csb2cmac_a_req->b_transport(csb2cmac_a_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2cmac_b_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2cmac_b_req_bp.set_data_ptr((unsigned char*) payload);
    csb2cmac_b_req->b_transport(csb2cmac_b_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2cacc_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2cacc_req_bp.set_data_ptr((unsigned char*) payload);
    csb2cacc_req->b_transport(csb2cacc_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2sdp_rdma_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2sdp_rdma_req_bp.set_data_ptr((unsigned char*) payload);
    csb2sdp_rdma_req->b_transport(csb2sdp_rdma_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2sdp_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2sdp_req_bp.set_data_ptr((unsigned char*) payload);
    csb2sdp_req->b_transport(csb2sdp_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2pdp_rdma_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2pdp_rdma_req_bp.set_data_ptr((unsigned char*) payload);
    csb2pdp_rdma_req->b_transport(csb2pdp_rdma_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2pdp_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2pdp_req_bp.set_data_ptr((unsigned char*) payload);
    csb2pdp_req->b_transport(csb2pdp_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2cdp_rdma_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2cdp_rdma_req_bp.set_data_ptr((unsigned char*) payload);
    csb2cdp_rdma_req->b_transport(csb2cdp_rdma_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2cdp_req_b_transport(NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay)
{
    csb2cdp_req_bp.set_data_ptr((unsigned char*) payload);
    csb2cdp_req->b_transport(csb2cdp_req_bp, delay);
}

inline void
NV_NVDLA_csb_master_base::csb2nvdla_b_transport(NV_MSDEC_xx2csb_erpt_t* payload, sc_time& delay)
{
    // csb2nvdla_bp.set_data_ptr((unsigned char*) payload);
    // csb2nvdla->b_transport(csb2nvdla_bp, delay);
    // uint8_t *csb2nvdla_bp_data_ptr;
    uint8_t *csb2nvdla_bp_byte_enable_ptr;
    uint32_t payload_byte_size;
    payload_byte_size = sizeof(NV_MSDEC_xx2csb_erpt_t);
    // csb2nvdla_bp_data_ptr          = new uint8_t[payload_byte_size];
    csb2nvdla_bp_byte_enable_ptr   = new uint8_t[payload_byte_size];
    // memcpy(csb2nvdla_bp_data_ptr, (void *)payload, payload_byte_size);
    memset(csb2nvdla_bp_byte_enable_ptr, 0xFF, payload_byte_size);
    // csb2nvdla_bp.set_data_ptr((unsigned char*) csb2nvdla_bp_data_ptr);
    csb2nvdla_bp.set_data_ptr((unsigned char*) payload);
    csb2nvdla_bp.set_data_length(payload_byte_size);
    csb2nvdla_bp.set_byte_enable_ptr((unsigned char*)csb2nvdla_bp_byte_enable_ptr);
    csb2nvdla_bp.set_byte_enable_length(payload_byte_size);
    csb2nvdla_bp.set_command(tlm::TLM_WRITE_COMMAND);
    csb2nvdla->b_transport(csb2nvdla_bp, delay);
    delete[] csb2nvdla_bp_byte_enable_ptr;
}

SCSIM_NAMESPACE_END()

#endif
