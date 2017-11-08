// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_rbk_base.h

#ifndef _NV_NVDLA_RBK_BASE_H_
#define _NV_NVDLA_RBK_BASE_H_

#define SC_INCLUDE_DYNAMIC_PROCESSES
#include "NV_MSDEC_csb2xx_16m_secure_be_lvl_iface.h"
#include "nvdla_xx2csb_resp_iface.h"

#include "nvdla_dma_rd_req_iface.h"
#include "nvdla_dma_rd_rsp_iface.h"
#include "nvdla_dma_wr_req_iface.h"
#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_initiator_socket.h>
#include <tlm_utils/multi_passthrough_target_socket.h>

SCSIM_NAMESPACE_START(cmod)

// Base SystemC class for module NV_NVDLA_rbk
class NV_NVDLA_rbk_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_rbk_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2rbk_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_rbk_base, 32, tlm::tlm_base_protocol_types> csb2rbk_req;
    virtual void csb2rbk_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb2rbk_req_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2rbk_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_rbk_base, 32, tlm::tlm_base_protocol_types> cvif2rbk_rd_rsp;
    virtual void cvif2rbk_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cvif2rbk_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2rbk_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_rbk_base, 32, tlm::tlm_base_protocol_types> mcif2rbk_rd_rsp;
    virtual void mcif2rbk_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mcif2rbk_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Port has no flow: cvif2rbk_wr_rsp
    sc_in<bool> cvif2rbk_wr_rsp;

    // Port has no flow: mcif2rbk_wr_rsp
    sc_in<bool> mcif2rbk_wr_rsp;

    // Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): rbk2csb_resp
    tlm::tlm_generic_payload rbk2csb_resp_bp;
    nvdla_xx2csb_resp_t rbk2csb_resp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_rbk_base, 32, tlm::tlm_base_protocol_types> rbk2csb_resp;
    virtual void rbk2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): rbk2cvif_rd_req
    tlm::tlm_generic_payload rbk2cvif_rd_req_bp;
    nvdla_dma_rd_req_t rbk2cvif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_rbk_base, 32, tlm::tlm_base_protocol_types> rbk2cvif_rd_req;
    virtual void rbk2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): rbk2mcif_rd_req
    tlm::tlm_generic_payload rbk2mcif_rd_req_bp;
    nvdla_dma_rd_req_t rbk2mcif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_rbk_base, 32, tlm::tlm_base_protocol_types> rbk2mcif_rd_req;
    virtual void rbk2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_wr_req_t): rbk2cvif_wr_req
    tlm::tlm_generic_payload rbk2cvif_wr_req_bp;
    nvdla_dma_wr_req_t rbk2cvif_wr_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_rbk_base, 32, tlm::tlm_base_protocol_types> rbk2cvif_wr_req;
    virtual void rbk2cvif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_wr_req_t): rbk2mcif_wr_req
    tlm::tlm_generic_payload rbk2mcif_wr_req_bp;
    nvdla_dma_wr_req_t rbk2mcif_wr_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_rbk_base, 32, tlm::tlm_base_protocol_types> rbk2mcif_wr_req;
    virtual void rbk2mcif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay);

    // Port has no flow: rbk2glb_done_intr
    sc_vector< sc_out<bool> > rbk2glb_done_intr;

    // Destructor
    virtual ~NV_NVDLA_rbk_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_rbk
inline NV_NVDLA_rbk_base::NV_NVDLA_rbk_base(const sc_module_name name)
    : sc_module(name),
    csb2rbk_req("csb2rbk_req"),
    cvif2rbk_rd_rsp("cvif2rbk_rd_rsp"),
    mcif2rbk_rd_rsp("mcif2rbk_rd_rsp"),
    rbk2csb_resp_bp(),
    rbk2csb_resp("rbk2csb_resp"),
    rbk2cvif_rd_req_bp(),
    rbk2cvif_rd_req("rbk2cvif_rd_req"),
    rbk2mcif_rd_req_bp(),
    rbk2mcif_rd_req("rbk2mcif_rd_req"),
    rbk2cvif_wr_req_bp(),
    rbk2cvif_wr_req("rbk2cvif_wr_req"),
    rbk2mcif_wr_req_bp(),
    rbk2mcif_wr_req("rbk2mcif_wr_req"),
    rbk2glb_done_intr("rbk2glb_done_intr", 2)
{
    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2rbk_req
    this->csb2rbk_req.register_b_transport(this, &NV_NVDLA_rbk_base::csb2rbk_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2rbk_rd_rsp
    this->cvif2rbk_rd_rsp.register_b_transport(this, &NV_NVDLA_rbk_base::cvif2rbk_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2rbk_rd_rsp
    this->mcif2rbk_rd_rsp.register_b_transport(this, &NV_NVDLA_rbk_base::mcif2rbk_rd_rsp_b_transport);

}

inline void
NV_NVDLA_rbk_base::csb2rbk_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    csb2rbk_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_rbk_base::cvif2rbk_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    cvif2rbk_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_rbk_base::mcif2rbk_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    mcif2rbk_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_rbk_base::rbk2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    rbk2csb_resp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < rbk2csb_resp.size(); socket_id++) {
        rbk2csb_resp[socket_id]->b_transport(rbk2csb_resp_bp, delay);
    }
}

inline void
NV_NVDLA_rbk_base::rbk2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    rbk2cvif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < rbk2cvif_rd_req.size(); socket_id++) {
        rbk2cvif_rd_req[socket_id]->b_transport(rbk2cvif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_rbk_base::rbk2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    rbk2mcif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < rbk2mcif_rd_req.size(); socket_id++) {
        rbk2mcif_rd_req[socket_id]->b_transport(rbk2mcif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_rbk_base::rbk2cvif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay)
{
    rbk2cvif_wr_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < rbk2cvif_wr_req.size(); socket_id++) {
        rbk2cvif_wr_req[socket_id]->b_transport(rbk2cvif_wr_req_bp, delay);
    }
}

inline void
NV_NVDLA_rbk_base::rbk2mcif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay)
{
    rbk2mcif_wr_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < rbk2mcif_wr_req.size(); socket_id++) {
        rbk2mcif_wr_req[socket_id]->b_transport(rbk2mcif_wr_req_bp, delay);
    }
}

SCSIM_NAMESPACE_END()

#endif
