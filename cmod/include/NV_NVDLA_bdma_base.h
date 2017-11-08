// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_bdma_base.h

#ifndef _NV_NVDLA_BDMA_BASE_H_
#define _NV_NVDLA_BDMA_BASE_H_

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

// Base SystemC class for module NV_NVDLA_bdma
class NV_NVDLA_bdma_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_bdma_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2bdma_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_bdma_base, 32, tlm::tlm_base_protocol_types> csb2bdma_req;
    virtual void csb2bdma_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb2bdma_req_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2bdma_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_bdma_base, 32, tlm::tlm_base_protocol_types> cvif2bdma_rd_rsp;
    virtual void cvif2bdma_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cvif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2bdma_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_bdma_base, 32, tlm::tlm_base_protocol_types> mcif2bdma_rd_rsp;
    virtual void mcif2bdma_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mcif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Port has no flow: cvif2bdma_wr_rsp
    sc_in<bool> cvif2bdma_wr_rsp;

    // Port has no flow: mcif2bdma_wr_rsp
    sc_in<bool> mcif2bdma_wr_rsp;

    // Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): bdma2csb_resp
    tlm::tlm_generic_payload bdma2csb_resp_bp;
    nvdla_xx2csb_resp_t bdma2csb_resp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_bdma_base, 32, tlm::tlm_base_protocol_types> bdma2csb_resp;
    virtual void bdma2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): bdma2cvif_rd_req
    tlm::tlm_generic_payload bdma2cvif_rd_req_bp;
    nvdla_dma_rd_req_t bdma2cvif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_bdma_base, 32, tlm::tlm_base_protocol_types> bdma2cvif_rd_req;
    virtual void bdma2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): bdma2mcif_rd_req
    tlm::tlm_generic_payload bdma2mcif_rd_req_bp;
    nvdla_dma_rd_req_t bdma2mcif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_bdma_base, 32, tlm::tlm_base_protocol_types> bdma2mcif_rd_req;
    virtual void bdma2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_wr_req_t): bdma2cvif_wr_req
    tlm::tlm_generic_payload bdma2cvif_wr_req_bp;
    nvdla_dma_wr_req_t bdma2cvif_wr_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_bdma_base, 32, tlm::tlm_base_protocol_types> bdma2cvif_wr_req;
    virtual void bdma2cvif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_wr_req_t): bdma2mcif_wr_req
    tlm::tlm_generic_payload bdma2mcif_wr_req_bp;
    nvdla_dma_wr_req_t bdma2mcif_wr_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_bdma_base, 32, tlm::tlm_base_protocol_types> bdma2mcif_wr_req;
    virtual void bdma2mcif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay);

    // Port has no flow: bdma2glb_done_intr
    sc_vector< sc_out<bool> > bdma2glb_done_intr;

    // Destructor
    virtual ~NV_NVDLA_bdma_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_bdma
inline NV_NVDLA_bdma_base::NV_NVDLA_bdma_base(const sc_module_name name)
    : sc_module(name),
    csb2bdma_req("csb2bdma_req"),
    cvif2bdma_rd_rsp("cvif2bdma_rd_rsp"),
    mcif2bdma_rd_rsp("mcif2bdma_rd_rsp"),
    bdma2csb_resp_bp(),
    bdma2csb_resp("bdma2csb_resp"),
    bdma2cvif_rd_req_bp(),
    bdma2cvif_rd_req("bdma2cvif_rd_req"),
    bdma2mcif_rd_req_bp(),
    bdma2mcif_rd_req("bdma2mcif_rd_req"),
    bdma2cvif_wr_req_bp(),
    bdma2cvif_wr_req("bdma2cvif_wr_req"),
    bdma2mcif_wr_req_bp(),
    bdma2mcif_wr_req("bdma2mcif_wr_req"),
    bdma2glb_done_intr("bdma2glb_done_intr", 2)
{
    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2bdma_req
    this->csb2bdma_req.register_b_transport(this, &NV_NVDLA_bdma_base::csb2bdma_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2bdma_rd_rsp
    // this->cvif2bdma_rd_rsp.register_b_transport(this, &NV_NVDLA_bdma_base::cvif2bdma_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2bdma_rd_rsp
    // this->mcif2bdma_rd_rsp.register_b_transport(this, &NV_NVDLA_bdma_base::mcif2bdma_rd_rsp_b_transport);

}

inline void
NV_NVDLA_bdma_base::csb2bdma_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    csb2bdma_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_bdma_base::cvif2bdma_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    cvif2bdma_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_bdma_base::mcif2bdma_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    mcif2bdma_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_bdma_base::bdma2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    bdma2csb_resp_bp.set_data_ptr((unsigned char*) payload);
    bdma2csb_resp->b_transport(bdma2csb_resp_bp, delay);
}

inline void
NV_NVDLA_bdma_base::bdma2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    bdma2cvif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    bdma2cvif_rd_req->b_transport(bdma2cvif_rd_req_bp, delay);
}

inline void
NV_NVDLA_bdma_base::bdma2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    bdma2mcif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    bdma2mcif_rd_req->b_transport(bdma2mcif_rd_req_bp, delay);
}

inline void
NV_NVDLA_bdma_base::bdma2cvif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay)
{
    bdma2cvif_wr_req_bp.set_data_ptr((unsigned char*) payload);
    bdma2cvif_wr_req->b_transport(bdma2cvif_wr_req_bp, delay);
}

inline void
NV_NVDLA_bdma_base::bdma2mcif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay)
{
    bdma2mcif_wr_req_bp.set_data_ptr((unsigned char*) payload);
    bdma2mcif_wr_req->b_transport(bdma2mcif_wr_req_bp, delay);
}

SCSIM_NAMESPACE_END()

#endif
