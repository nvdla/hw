// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_pdp_base.h

#ifndef _NV_NVDLA_PDP_BASE_H_
#define _NV_NVDLA_PDP_BASE_H_

#define SC_INCLUDE_DYNAMIC_PROCESSES
#include "NV_MSDEC_csb2xx_16m_secure_be_lvl_iface.h"
#include "nvdla_xx2csb_resp_iface.h"

#include "nvdla_dma_rd_req_iface.h"
#include "nvdla_dma_rd_rsp_iface.h"
#include "nvdla_dma_wr_req_iface.h"
#include "nvdla_sdp2pdp_iface.h"
#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_initiator_socket.h>
#include <tlm_utils/multi_passthrough_target_socket.h>

SCSIM_NAMESPACE_START(cmod)

// Base SystemC class for module NV_NVDLA_pdp
class NV_NVDLA_pdp_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_pdp_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2pdp_rdma_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_pdp_base, 32, tlm::tlm_base_protocol_types> csb2pdp_rdma_req;
    virtual void csb2pdp_rdma_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb2pdp_rdma_req_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2pdp_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_pdp_base, 32, tlm::tlm_base_protocol_types> csb2pdp_req;
    virtual void csb2pdp_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb2pdp_req_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2pdp_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_pdp_base, 32, tlm::tlm_base_protocol_types> cvif2pdp_rd_rsp;
    virtual void cvif2pdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cvif2pdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2pdp_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_pdp_base, 32, tlm::tlm_base_protocol_types> mcif2pdp_rd_rsp;
    virtual void mcif2pdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mcif2pdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Port has no flow: cvif2pdp_wr_rsp
    sc_in<bool> cvif2pdp_wr_rsp;

    // Port has no flow: mcif2pdp_wr_rsp
    sc_in<bool> mcif2pdp_wr_rsp;

    // Target Socket (unrecognized protocol: nvdla_sdp2pdp_t): sdp2pdp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_pdp_base, 32, tlm::tlm_base_protocol_types> sdp2pdp;
    virtual void sdp2pdp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sdp2pdp_b_transport(int ID, nvdla_sdp2pdp_t* payload, sc_time& delay) = 0;

    // Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): pdp2csb_resp
    tlm::tlm_generic_payload pdp2csb_resp_bp;
    nvdla_xx2csb_resp_t pdp2csb_resp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_pdp_base, 32, tlm::tlm_base_protocol_types> pdp2csb_resp;
    virtual void pdp2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): pdp_rdma2csb_resp
    tlm::tlm_generic_payload pdp_rdma2csb_resp_bp;
    nvdla_xx2csb_resp_t pdp_rdma2csb_resp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_pdp_base, 32, tlm::tlm_base_protocol_types> pdp_rdma2csb_resp;
    virtual void pdp_rdma2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): pdp2cvif_rd_req
    tlm::tlm_generic_payload pdp2cvif_rd_req_bp;
    nvdla_dma_rd_req_t pdp2cvif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_pdp_base, 32, tlm::tlm_base_protocol_types> pdp2cvif_rd_req;
    virtual void pdp2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): pdp2mcif_rd_req
    tlm::tlm_generic_payload pdp2mcif_rd_req_bp;
    nvdla_dma_rd_req_t pdp2mcif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_pdp_base, 32, tlm::tlm_base_protocol_types> pdp2mcif_rd_req;
    virtual void pdp2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_wr_req_t): pdp2cvif_wr_req
    tlm::tlm_generic_payload pdp2cvif_wr_req_bp;
    nvdla_dma_wr_req_t pdp2cvif_wr_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_pdp_base, 32, tlm::tlm_base_protocol_types> pdp2cvif_wr_req;
    virtual void pdp2cvif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_wr_req_t): pdp2mcif_wr_req
    tlm::tlm_generic_payload pdp2mcif_wr_req_bp;
    nvdla_dma_wr_req_t pdp2mcif_wr_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_pdp_base, 32, tlm::tlm_base_protocol_types> pdp2mcif_wr_req;
    virtual void pdp2mcif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay);

    // Port has no flow: pdp2glb_done_intr
    sc_vector< sc_out<bool> > pdp2glb_done_intr;

    // Destructor
    virtual ~NV_NVDLA_pdp_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_pdp
inline NV_NVDLA_pdp_base::NV_NVDLA_pdp_base(const sc_module_name name)
    : sc_module(name),
    csb2pdp_rdma_req("csb2pdp_rdma_req"),
    csb2pdp_req("csb2pdp_req"),
    cvif2pdp_rd_rsp("cvif2pdp_rd_rsp"),
    mcif2pdp_rd_rsp("mcif2pdp_rd_rsp"),
    sdp2pdp("sdp2pdp"),
    pdp2csb_resp_bp(),
    pdp2csb_resp("pdp2csb_resp"),
    pdp_rdma2csb_resp_bp(),
    pdp_rdma2csb_resp("pdp_rdma2csb_resp"),
    pdp2cvif_rd_req_bp(),
    pdp2cvif_rd_req("pdp2cvif_rd_req"),
    pdp2mcif_rd_req_bp(),
    pdp2mcif_rd_req("pdp2mcif_rd_req"),
    pdp2cvif_wr_req_bp(),
    pdp2cvif_wr_req("pdp2cvif_wr_req"),
    pdp2mcif_wr_req_bp(),
    pdp2mcif_wr_req("pdp2mcif_wr_req"),
    pdp2glb_done_intr("pdp2glb_done_intr", 2)
{
    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2pdp_rdma_req
    this->csb2pdp_rdma_req.register_b_transport(this, &NV_NVDLA_pdp_base::csb2pdp_rdma_req_b_transport);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2pdp_req
    this->csb2pdp_req.register_b_transport(this, &NV_NVDLA_pdp_base::csb2pdp_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2pdp_rd_rsp
    this->cvif2pdp_rd_rsp.register_b_transport(this, &NV_NVDLA_pdp_base::cvif2pdp_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2pdp_rd_rsp
    this->mcif2pdp_rd_rsp.register_b_transport(this, &NV_NVDLA_pdp_base::mcif2pdp_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_sdp2pdp_t): sdp2pdp
    this->sdp2pdp.register_b_transport(this, &NV_NVDLA_pdp_base::sdp2pdp_b_transport);

}

inline void
NV_NVDLA_pdp_base::csb2pdp_rdma_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    csb2pdp_rdma_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_pdp_base::csb2pdp_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    csb2pdp_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_pdp_base::cvif2pdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    cvif2pdp_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_pdp_base::mcif2pdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    mcif2pdp_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_pdp_base::sdp2pdp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_sdp2pdp_t* payload = (nvdla_sdp2pdp_t*) bp.get_data_ptr();
    sdp2pdp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_pdp_base::pdp2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    pdp2csb_resp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < pdp2csb_resp.size(); socket_id++) {
        pdp2csb_resp[socket_id]->b_transport(pdp2csb_resp_bp, delay);
    }
}

inline void
NV_NVDLA_pdp_base::pdp_rdma2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    pdp_rdma2csb_resp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < pdp_rdma2csb_resp.size(); socket_id++) {
        pdp_rdma2csb_resp[socket_id]->b_transport(pdp_rdma2csb_resp_bp, delay);
    }
}

inline void
NV_NVDLA_pdp_base::pdp2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    pdp2cvif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < pdp2cvif_rd_req.size(); socket_id++) {
        pdp2cvif_rd_req[socket_id]->b_transport(pdp2cvif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_pdp_base::pdp2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    pdp2mcif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < pdp2mcif_rd_req.size(); socket_id++) {
        pdp2mcif_rd_req[socket_id]->b_transport(pdp2mcif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_pdp_base::pdp2cvif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay)
{
    pdp2cvif_wr_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < pdp2cvif_wr_req.size(); socket_id++) {
        pdp2cvif_wr_req[socket_id]->b_transport(pdp2cvif_wr_req_bp, delay);
    }
}

inline void
NV_NVDLA_pdp_base::pdp2mcif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay)
{
    pdp2mcif_wr_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < pdp2mcif_wr_req.size(); socket_id++) {
        pdp2mcif_wr_req[socket_id]->b_transport(pdp2mcif_wr_req_bp, delay);
    }
}

SCSIM_NAMESPACE_END()

#endif
