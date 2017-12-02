// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_sdp_base.h

#ifndef _NV_NVDLA_SDP_BASE_H_
#define _NV_NVDLA_SDP_BASE_H_

#ifndef SC_INCLUDE_DYNAMIC_PROCESSES
#define SC_INCLUDE_DYNAMIC_PROCESSES
#endif
#include "NV_MSDEC_csb2xx_16m_secure_be_lvl_iface.h"

#include "nvdla_accu2pp_if_iface.h"
#include "nvdla_dma_rd_req_iface.h"
#include "nvdla_dma_rd_rsp_iface.h"
#include "nvdla_dma_wr_req_iface.h"
#include "nvdla_sdp2pdp_iface.h"
#include "nvdla_xx2csb_resp_iface.h"
#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_initiator_socket.h>
#include <tlm_utils/multi_passthrough_target_socket.h>

SCSIM_NAMESPACE_START(cmod)

// Base SystemC class for module NV_NVDLA_sdp
class NV_NVDLA_sdp_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_sdp_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2sdp_rdma_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> csb2sdp_rdma_req;
    virtual void csb2sdp_rdma_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb2sdp_rdma_req_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2sdp_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> csb2sdp_req;
    virtual void csb2sdp_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb2sdp_req_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Port has no flow: nvdla_global_clk
    // sc_vector< sc_in<bool> > nvdla_global_clk;

    // Target Socket (unrecognized protocol: nvdla_accu2pp_if_t): cacc2sdp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> cacc2sdp;
    virtual void cacc2sdp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cacc2sdp_b_transport(int ID, nvdla_accu2pp_if_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2sdp_b_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> cvif2sdp_b_rd_rsp;
    virtual void cvif2sdp_b_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cvif2sdp_b_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2sdp_e_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> cvif2sdp_e_rd_rsp;
    virtual void cvif2sdp_e_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cvif2sdp_e_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2sdp_n_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> cvif2sdp_n_rd_rsp;
    virtual void cvif2sdp_n_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cvif2sdp_n_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2sdp_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> cvif2sdp_rd_rsp;
    virtual void cvif2sdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cvif2sdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2sdp_b_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> mcif2sdp_b_rd_rsp;
    virtual void mcif2sdp_b_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mcif2sdp_b_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2sdp_e_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> mcif2sdp_e_rd_rsp;
    virtual void mcif2sdp_e_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mcif2sdp_e_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2sdp_n_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> mcif2sdp_n_rd_rsp;
    virtual void mcif2sdp_n_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mcif2sdp_n_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2sdp_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> mcif2sdp_rd_rsp;
    virtual void mcif2sdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mcif2sdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Port has no flow: cvif2sdp_wr_rsp
    sc_in<bool> cvif2sdp_wr_rsp;

    // Port has no flow: mcif2sdp_wr_rsp
    sc_in<bool> mcif2sdp_wr_rsp;
/*
    // Port has no flow: sdp2glb_fault_inject
    sc_vector< sc_in<bool> > sdp2glb_fault_inject;

    // Port has no flow: sdp_b2glb_fault_inject
    sc_vector< sc_in<bool> > sdp_b2glb_fault_inject;

    // Port has no flow: sdp_e2glb_fault_inject
    sc_vector< sc_in<bool> > sdp_e2glb_fault_inject;

    // Port has no flow: sdp_n2glb_fault_inject
    sc_vector< sc_in<bool> > sdp_n2glb_fault_inject;

    // Port has no flow: reset_in
    sc_vector< sc_in<bool> > reset_in;
    // Port has no flow: sdp2cvif_rd_cdt
    sc_out<bool> sdp2cvif_rd_cdt;

    // Port has no flow: sdp2mcif_rd_cdt
    sc_out<bool> sdp2mcif_rd_cdt;

    // Port has no flow: sdp_b2cvif_rd_cdt
    sc_out<bool> sdp_b2cvif_rd_cdt;

    // Port has no flow: sdp_b2mcif_rd_cdt
    sc_out<bool> sdp_b2mcif_rd_cdt;

    // Port has no flow: sdp_e2cvif_rd_cdt
    sc_out<bool> sdp_e2cvif_rd_cdt;

    // Port has no flow: sdp_e2mcif_rd_cdt
    sc_out<bool> sdp_e2mcif_rd_cdt;

    // Port has no flow: sdp_n2cvif_rd_cdt
    sc_out<bool> sdp_n2cvif_rd_cdt;

    // Port has no flow: sdp_n2mcif_rd_cdt
    sc_out<bool> sdp_n2mcif_rd_cdt;
*/
    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp2cvif_rd_req
    tlm::tlm_generic_payload sdp2cvif_rd_req_bp;
    nvdla_dma_rd_req_t sdp2cvif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> sdp2cvif_rd_req;
    virtual void sdp2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp2mcif_rd_req
    tlm::tlm_generic_payload sdp2mcif_rd_req_bp;
    nvdla_dma_rd_req_t sdp2mcif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> sdp2mcif_rd_req;
    virtual void sdp2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_b2cvif_rd_req
    tlm::tlm_generic_payload sdp_b2cvif_rd_req_bp;
    nvdla_dma_rd_req_t sdp_b2cvif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> sdp_b2cvif_rd_req;
    virtual void sdp_b2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_b2mcif_rd_req
    tlm::tlm_generic_payload sdp_b2mcif_rd_req_bp;
    nvdla_dma_rd_req_t sdp_b2mcif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> sdp_b2mcif_rd_req;
    virtual void sdp_b2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_e2cvif_rd_req
    tlm::tlm_generic_payload sdp_e2cvif_rd_req_bp;
    nvdla_dma_rd_req_t sdp_e2cvif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> sdp_e2cvif_rd_req;
    virtual void sdp_e2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_e2mcif_rd_req
    tlm::tlm_generic_payload sdp_e2mcif_rd_req_bp;
    nvdla_dma_rd_req_t sdp_e2mcif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> sdp_e2mcif_rd_req;
    virtual void sdp_e2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_n2cvif_rd_req
    tlm::tlm_generic_payload sdp_n2cvif_rd_req_bp;
    nvdla_dma_rd_req_t sdp_n2cvif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> sdp_n2cvif_rd_req;
    virtual void sdp_n2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_n2mcif_rd_req
    tlm::tlm_generic_payload sdp_n2mcif_rd_req_bp;
    nvdla_dma_rd_req_t sdp_n2mcif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> sdp_n2mcif_rd_req;
    virtual void sdp_n2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_wr_req_t): sdp2cvif_wr_req
    tlm::tlm_generic_payload sdp2cvif_wr_req_bp;
    nvdla_dma_wr_req_t sdp2cvif_wr_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> sdp2cvif_wr_req;
    virtual void sdp2cvif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_wr_req_t): sdp2mcif_wr_req
    tlm::tlm_generic_payload sdp2mcif_wr_req_bp;
    nvdla_dma_wr_req_t sdp2mcif_wr_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> sdp2mcif_wr_req;
    virtual void sdp2mcif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay);
/*
    // Port has no flow: sdp2glb_fault_report
    sc_vector< sc_out<bool> > sdp2glb_fault_report;

    // Port has no flow: sdp_b2glb_fault_report
    sc_vector< sc_out<bool> > sdp_b2glb_fault_report;

    // Port has no flow: sdp_e2glb_fault_report
    sc_vector< sc_out<bool> > sdp_e2glb_fault_report;

    // Port has no flow: sdp_n2glb_fault_report
    sc_vector< sc_out<bool> > sdp_n2glb_fault_report;

    // Port has no flow: sdp2glb_done_intr
    // sc_vector< sc_out<bool> > sdp2glb_done_intr;
*/
    // Initiator Socket (unrecognized protocol: nvdla_sdp2pdp_t): sdp2pdp
    tlm::tlm_generic_payload sdp2pdp_bp;
    nvdla_sdp2pdp_t sdp2pdp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> sdp2pdp;
    virtual void sdp2pdp_b_transport(nvdla_sdp2pdp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): sdp2csb_resp
    tlm::tlm_generic_payload sdp2csb_resp_bp;
    nvdla_xx2csb_resp_t sdp2csb_resp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> sdp2csb_resp;
    virtual void sdp2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): sdp_rdma2csb_resp
    tlm::tlm_generic_payload sdp_rdma2csb_resp_bp;
    nvdla_xx2csb_resp_t sdp_rdma2csb_resp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_sdp_base, 32, tlm::tlm_base_protocol_types> sdp_rdma2csb_resp;
    virtual void sdp_rdma2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay);

    // Destructor
    virtual ~NV_NVDLA_sdp_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_sdp
inline NV_NVDLA_sdp_base::NV_NVDLA_sdp_base(const sc_module_name name)
    : sc_module(name),
    csb2sdp_rdma_req("csb2sdp_rdma_req"),
    csb2sdp_req("csb2sdp_req"),
    // nvdla_global_clk("nvdla_global_clk", 8),
    cacc2sdp("cacc2sdp"),
    cvif2sdp_b_rd_rsp("cvif2sdp_b_rd_rsp"),
    cvif2sdp_e_rd_rsp("cvif2sdp_e_rd_rsp"),
    cvif2sdp_n_rd_rsp("cvif2sdp_n_rd_rsp"),
    cvif2sdp_rd_rsp("cvif2sdp_rd_rsp"),
    mcif2sdp_b_rd_rsp("mcif2sdp_b_rd_rsp"),
    mcif2sdp_e_rd_rsp("mcif2sdp_e_rd_rsp"),
    mcif2sdp_n_rd_rsp("mcif2sdp_n_rd_rsp"),
    mcif2sdp_rd_rsp("mcif2sdp_rd_rsp"),
    cvif2sdp_wr_rsp("cvif2sdp_wr_rsp"),
    mcif2sdp_wr_rsp("mcif2sdp_wr_rsp"),
    //sdp2glb_fault_inject("sdp2glb_fault_inject", 2),
    //sdp_b2glb_fault_inject("sdp_b2glb_fault_inject", 2),
    //sdp_e2glb_fault_inject("sdp_e2glb_fault_inject", 2),
    //sdp_n2glb_fault_inject("sdp_n2glb_fault_inject", 2),
    //reset_in("reset_in", 2),
    //sdp2cvif_rd_cdt("sdp2cvif_rd_cdt"),
    //sdp2mcif_rd_cdt("sdp2mcif_rd_cdt"),
    //sdp_b2cvif_rd_cdt("sdp_b2cvif_rd_cdt"),
    //sdp_b2mcif_rd_cdt("sdp_b2mcif_rd_cdt"),
    //sdp_e2cvif_rd_cdt("sdp_e2cvif_rd_cdt"),
    //sdp_e2mcif_rd_cdt("sdp_e2mcif_rd_cdt"),
    //sdp_n2cvif_rd_cdt("sdp_n2cvif_rd_cdt"),
    //sdp_n2mcif_rd_cdt("sdp_n2mcif_rd_cdt"),
    sdp2cvif_rd_req_bp(),
    sdp2cvif_rd_req("sdp2cvif_rd_req"),
    sdp2mcif_rd_req_bp(),
    sdp2mcif_rd_req("sdp2mcif_rd_req"),
    sdp_b2cvif_rd_req_bp(),
    sdp_b2cvif_rd_req("sdp_b2cvif_rd_req"),
    sdp_b2mcif_rd_req_bp(),
    sdp_b2mcif_rd_req("sdp_b2mcif_rd_req"),
    sdp_e2cvif_rd_req_bp(),
    sdp_e2cvif_rd_req("sdp_e2cvif_rd_req"),
    sdp_e2mcif_rd_req_bp(),
    sdp_e2mcif_rd_req("sdp_e2mcif_rd_req"),
    sdp_n2cvif_rd_req_bp(),
    sdp_n2cvif_rd_req("sdp_n2cvif_rd_req"),
    sdp_n2mcif_rd_req_bp(),
    sdp_n2mcif_rd_req("sdp_n2mcif_rd_req"),
    sdp2cvif_wr_req_bp(),
    sdp2cvif_wr_req("sdp2cvif_wr_req"),
    sdp2mcif_wr_req_bp(),
    sdp2mcif_wr_req("sdp2mcif_wr_req"),
//    sdp2glb_fault_report("sdp2glb_fault_report", 4),
//    sdp_b2glb_fault_report("sdp_b2glb_fault_report", 4),
//    sdp_e2glb_fault_report("sdp_e2glb_fault_report", 4),
//    sdp_n2glb_fault_report("sdp_n2glb_fault_report", 4),
//    sdp2glb_done_intr("sdp2glb_done_intr", 2),
    sdp2pdp_bp(),
    sdp2pdp("sdp2pdp"),
    sdp2csb_resp_bp(),
    sdp2csb_resp("sdp2csb_resp"),
    sdp_rdma2csb_resp_bp(),
    sdp_rdma2csb_resp("sdp_rdma2csb_resp")
{
    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2sdp_rdma_req
    this->csb2sdp_rdma_req.register_b_transport(this, &NV_NVDLA_sdp_base::csb2sdp_rdma_req_b_transport);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2sdp_req
    this->csb2sdp_req.register_b_transport(this, &NV_NVDLA_sdp_base::csb2sdp_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_accu2pp_if_t): cacc2sdp
    this->cacc2sdp.register_b_transport(this, &NV_NVDLA_sdp_base::cacc2sdp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2sdp_b_rd_rsp
    this->cvif2sdp_b_rd_rsp.register_b_transport(this, &NV_NVDLA_sdp_base::cvif2sdp_b_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2sdp_e_rd_rsp
    this->cvif2sdp_e_rd_rsp.register_b_transport(this, &NV_NVDLA_sdp_base::cvif2sdp_e_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2sdp_n_rd_rsp
    this->cvif2sdp_n_rd_rsp.register_b_transport(this, &NV_NVDLA_sdp_base::cvif2sdp_n_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2sdp_rd_rsp
    this->cvif2sdp_rd_rsp.register_b_transport(this, &NV_NVDLA_sdp_base::cvif2sdp_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2sdp_b_rd_rsp
    this->mcif2sdp_b_rd_rsp.register_b_transport(this, &NV_NVDLA_sdp_base::mcif2sdp_b_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2sdp_e_rd_rsp
    this->mcif2sdp_e_rd_rsp.register_b_transport(this, &NV_NVDLA_sdp_base::mcif2sdp_e_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2sdp_n_rd_rsp
    this->mcif2sdp_n_rd_rsp.register_b_transport(this, &NV_NVDLA_sdp_base::mcif2sdp_n_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2sdp_rd_rsp
    this->mcif2sdp_rd_rsp.register_b_transport(this, &NV_NVDLA_sdp_base::mcif2sdp_rd_rsp_b_transport);

}

inline void
NV_NVDLA_sdp_base::csb2sdp_rdma_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    csb2sdp_rdma_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_sdp_base::csb2sdp_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    csb2sdp_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_sdp_base::cacc2sdp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_accu2pp_if_t* payload = (nvdla_accu2pp_if_t*) bp.get_data_ptr();
    cacc2sdp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_sdp_base::cvif2sdp_b_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    cvif2sdp_b_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_sdp_base::cvif2sdp_e_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    cvif2sdp_e_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_sdp_base::cvif2sdp_n_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    cvif2sdp_n_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_sdp_base::cvif2sdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    cvif2sdp_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_sdp_base::mcif2sdp_b_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    mcif2sdp_b_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_sdp_base::mcif2sdp_e_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    mcif2sdp_e_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_sdp_base::mcif2sdp_n_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    mcif2sdp_n_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_sdp_base::mcif2sdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    mcif2sdp_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_sdp_base::sdp2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    sdp2cvif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sdp2cvif_rd_req.size(); socket_id++) {
        sdp2cvif_rd_req[socket_id]->b_transport(sdp2cvif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_sdp_base::sdp2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    sdp2mcif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sdp2mcif_rd_req.size(); socket_id++) {
        sdp2mcif_rd_req[socket_id]->b_transport(sdp2mcif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_sdp_base::sdp_b2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    sdp_b2cvif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sdp_b2cvif_rd_req.size(); socket_id++) {
        sdp_b2cvif_rd_req[socket_id]->b_transport(sdp_b2cvif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_sdp_base::sdp_b2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    sdp_b2mcif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sdp_b2mcif_rd_req.size(); socket_id++) {
        sdp_b2mcif_rd_req[socket_id]->b_transport(sdp_b2mcif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_sdp_base::sdp_e2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    sdp_e2cvif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sdp_e2cvif_rd_req.size(); socket_id++) {
        sdp_e2cvif_rd_req[socket_id]->b_transport(sdp_e2cvif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_sdp_base::sdp_e2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    sdp_e2mcif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sdp_e2mcif_rd_req.size(); socket_id++) {
        sdp_e2mcif_rd_req[socket_id]->b_transport(sdp_e2mcif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_sdp_base::sdp_n2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    sdp_n2cvif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sdp_n2cvif_rd_req.size(); socket_id++) {
        sdp_n2cvif_rd_req[socket_id]->b_transport(sdp_n2cvif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_sdp_base::sdp_n2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    sdp_n2mcif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sdp_n2mcif_rd_req.size(); socket_id++) {
        sdp_n2mcif_rd_req[socket_id]->b_transport(sdp_n2mcif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_sdp_base::sdp2cvif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay)
{
    sdp2cvif_wr_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sdp2cvif_wr_req.size(); socket_id++) {
        sdp2cvif_wr_req[socket_id]->b_transport(sdp2cvif_wr_req_bp, delay);
    }
}

inline void
NV_NVDLA_sdp_base::sdp2mcif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay)
{
    sdp2mcif_wr_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sdp2mcif_wr_req.size(); socket_id++) {
        sdp2mcif_wr_req[socket_id]->b_transport(sdp2mcif_wr_req_bp, delay);
    }
}

inline void
NV_NVDLA_sdp_base::sdp2pdp_b_transport(nvdla_sdp2pdp_t* payload, sc_time& delay)
{
    sdp2pdp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sdp2pdp.size(); socket_id++) {
        sdp2pdp[socket_id]->b_transport(sdp2pdp_bp, delay);
    }
}

inline void
NV_NVDLA_sdp_base::sdp2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    sdp2csb_resp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sdp2csb_resp.size(); socket_id++) {
        sdp2csb_resp[socket_id]->b_transport(sdp2csb_resp_bp, delay);
    }
}

inline void
NV_NVDLA_sdp_base::sdp_rdma2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    sdp_rdma2csb_resp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sdp_rdma2csb_resp.size(); socket_id++) {
        sdp_rdma2csb_resp[socket_id]->b_transport(sdp_rdma2csb_resp_bp, delay);
    }
}

SCSIM_NAMESPACE_END()

#endif
