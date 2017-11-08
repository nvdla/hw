// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cdp_base.h

#ifndef _NV_NVDLA_CDP_BASE_H_
#define _NV_NVDLA_CDP_BASE_H_

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

// Base SystemC class for module NV_NVDLA_cdp
class NV_NVDLA_cdp_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_cdp_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cdp_rdma_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cdp_base, 32, tlm::tlm_base_protocol_types> csb2cdp_rdma_req;
    virtual void csb2cdp_rdma_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb2cdp_rdma_req_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cdp_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cdp_base, 32, tlm::tlm_base_protocol_types> csb2cdp_req;
    virtual void csb2cdp_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb2cdp_req_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2cdp_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cdp_base, 32, tlm::tlm_base_protocol_types> cvif2cdp_rd_rsp;
    virtual void cvif2cdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cvif2cdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2cdp_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cdp_base, 32, tlm::tlm_base_protocol_types> mcif2cdp_rd_rsp;
    virtual void mcif2cdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mcif2cdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Port has no flow: cvif2cdp_wr_rsp
    sc_in<bool> cvif2cdp_wr_rsp;

    // Port has no flow: mcif2cdp_wr_rsp
    sc_in<bool> mcif2cdp_wr_rsp;

    // Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cdp2csb_resp
    tlm::tlm_generic_payload cdp2csb_resp_bp;
    nvdla_xx2csb_resp_t cdp2csb_resp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdp_base, 32, tlm::tlm_base_protocol_types> cdp2csb_resp;
    virtual void cdp2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cdp_rdma2csb_resp
    tlm::tlm_generic_payload cdp_rdma2csb_resp_bp;
    nvdla_xx2csb_resp_t cdp_rdma2csb_resp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdp_base, 32, tlm::tlm_base_protocol_types> cdp_rdma2csb_resp;
    virtual void cdp_rdma2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdp2cvif_rd_req
    tlm::tlm_generic_payload cdp2cvif_rd_req_bp;
    nvdla_dma_rd_req_t cdp2cvif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdp_base, 32, tlm::tlm_base_protocol_types> cdp2cvif_rd_req;
    virtual void cdp2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdp2mcif_rd_req
    tlm::tlm_generic_payload cdp2mcif_rd_req_bp;
    nvdla_dma_rd_req_t cdp2mcif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdp_base, 32, tlm::tlm_base_protocol_types> cdp2mcif_rd_req;
    virtual void cdp2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_wr_req_t): cdp2cvif_wr_req
    tlm::tlm_generic_payload cdp2cvif_wr_req_bp;
    nvdla_dma_wr_req_t cdp2cvif_wr_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdp_base, 32, tlm::tlm_base_protocol_types> cdp2cvif_wr_req;
    virtual void cdp2cvif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_wr_req_t): cdp2mcif_wr_req
    tlm::tlm_generic_payload cdp2mcif_wr_req_bp;
    nvdla_dma_wr_req_t cdp2mcif_wr_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdp_base, 32, tlm::tlm_base_protocol_types> cdp2mcif_wr_req;
    virtual void cdp2mcif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay);

    // Destructor
    virtual ~NV_NVDLA_cdp_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_cdp
inline NV_NVDLA_cdp_base::NV_NVDLA_cdp_base(const sc_module_name name)
    : sc_module(name),
    csb2cdp_rdma_req("csb2cdp_rdma_req"),
    csb2cdp_req("csb2cdp_req"),
    cvif2cdp_rd_rsp("cvif2cdp_rd_rsp"),
    mcif2cdp_rd_rsp("mcif2cdp_rd_rsp"),
    cdp2csb_resp_bp(),
    cdp2csb_resp("cdp2csb_resp"),
    cdp_rdma2csb_resp_bp(),
    cdp_rdma2csb_resp("cdp_rdma2csb_resp"),
    cdp2cvif_rd_req_bp(),
    cdp2cvif_rd_req("cdp2cvif_rd_req"),
    cdp2mcif_rd_req_bp(),
    cdp2mcif_rd_req("cdp2mcif_rd_req"),
    cdp2cvif_wr_req_bp(),
    cdp2cvif_wr_req("cdp2cvif_wr_req"),
    cdp2mcif_wr_req_bp(),
    cdp2mcif_wr_req("cdp2mcif_wr_req")
{
    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cdp_rdma_req
    this->csb2cdp_rdma_req.register_b_transport(this, &NV_NVDLA_cdp_base::csb2cdp_rdma_req_b_transport);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cdp_req
    this->csb2cdp_req.register_b_transport(this, &NV_NVDLA_cdp_base::csb2cdp_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2cdp_rd_rsp
    this->cvif2cdp_rd_rsp.register_b_transport(this, &NV_NVDLA_cdp_base::cvif2cdp_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2cdp_rd_rsp
    this->mcif2cdp_rd_rsp.register_b_transport(this, &NV_NVDLA_cdp_base::mcif2cdp_rd_rsp_b_transport);

}

inline void
NV_NVDLA_cdp_base::csb2cdp_rdma_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    csb2cdp_rdma_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cdp_base::csb2cdp_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    csb2cdp_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cdp_base::cvif2cdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    cvif2cdp_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cdp_base::mcif2cdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    mcif2cdp_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cdp_base::cdp2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    cdp2csb_resp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cdp2csb_resp.size(); socket_id++) {
        cdp2csb_resp[socket_id]->b_transport(cdp2csb_resp_bp, delay);
    }
}

inline void
NV_NVDLA_cdp_base::cdp_rdma2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    cdp_rdma2csb_resp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cdp_rdma2csb_resp.size(); socket_id++) {
        cdp_rdma2csb_resp[socket_id]->b_transport(cdp_rdma2csb_resp_bp, delay);
    }
}

inline void
NV_NVDLA_cdp_base::cdp2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    cdp2cvif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cdp2cvif_rd_req.size(); socket_id++) {
        cdp2cvif_rd_req[socket_id]->b_transport(cdp2cvif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_cdp_base::cdp2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    cdp2mcif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cdp2mcif_rd_req.size(); socket_id++) {
        cdp2mcif_rd_req[socket_id]->b_transport(cdp2mcif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_cdp_base::cdp2cvif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay)
{
    cdp2cvif_wr_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cdp2cvif_wr_req.size(); socket_id++) {
        cdp2cvif_wr_req[socket_id]->b_transport(cdp2cvif_wr_req_bp, delay);
    }
}

inline void
NV_NVDLA_cdp_base::cdp2mcif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay)
{
    cdp2mcif_wr_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cdp2mcif_wr_req.size(); socket_id++) {
        cdp2mcif_wr_req[socket_id]->b_transport(cdp2mcif_wr_req_bp, delay);
    }
}

SCSIM_NAMESPACE_END()

#endif
