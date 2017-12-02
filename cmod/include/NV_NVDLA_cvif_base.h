// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cvif_base.h

#ifndef _NV_NVDLA_CVIF_BASE_H_
#define _NV_NVDLA_CVIF_BASE_H_

#ifndef SC_INCLUDE_DYNAMIC_PROCESSES
#define SC_INCLUDE_DYNAMIC_PROCESSES
#endif

#include "nvdla_dma_rd_req_iface.h"
#include "nvdla_dma_rd_rsp_iface.h"
#include "nvdla_dma_wr_req_iface.h"
#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_initiator_socket.h>
#include <tlm_utils/multi_passthrough_target_socket.h>

SCSIM_NAMESPACE_START(cmod)

// Base SystemC class for module NV_NVDLA_cvif
class NV_NVDLA_cvif_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_cvif_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): bdma2cvif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> bdma2cvif_rd_req;
    virtual void bdma2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void bdma2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdma_dat2cvif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cdma_dat2cvif_rd_req;
    virtual void cdma_dat2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdma_dat2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdma_wt2cvif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cdma_wt2cvif_rd_req;
    virtual void cdma_wt2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdma_wt2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdp2cvif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cdp2cvif_rd_req;
    virtual void cdp2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdp2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): pdp2cvif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> pdp2cvif_rd_req;
    virtual void pdp2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void pdp2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): rbk2cvif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> rbk2cvif_rd_req;
    virtual void rbk2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void rbk2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp2cvif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> sdp2cvif_rd_req;
    virtual void sdp2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sdp2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_b2cvif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> sdp_b2cvif_rd_req;
    virtual void sdp_b2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sdp_b2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_e2cvif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> sdp_e2cvif_rd_req;
    virtual void sdp_e2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sdp_e2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_n2cvif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> sdp_n2cvif_rd_req;
    virtual void sdp_n2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sdp_n2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): bdma2cvif_wr_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> bdma2cvif_wr_req;
    virtual void bdma2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void bdma2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): cdp2cvif_wr_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cdp2cvif_wr_req;
    virtual void cdp2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdp2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): pdp2cvif_wr_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> pdp2cvif_wr_req;
    virtual void pdp2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void pdp2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): rbk2cvif_wr_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> rbk2cvif_wr_req;
    virtual void rbk2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void rbk2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): sdp2cvif_wr_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> sdp2cvif_wr_req;
    virtual void sdp2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sdp2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) = 0;

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2bdma_rd_rsp
    tlm::tlm_generic_payload cvif2bdma_rd_rsp_bp;
    nvdla_dma_rd_rsp_t cvif2bdma_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cvif2bdma_rd_rsp;
    virtual void cvif2bdma_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2cdma_dat_rd_rsp
    tlm::tlm_generic_payload cvif2cdma_dat_rd_rsp_bp;
    nvdla_dma_rd_rsp_t cvif2cdma_dat_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cvif2cdma_dat_rd_rsp;
    virtual void cvif2cdma_dat_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2cdma_wt_rd_rsp
    tlm::tlm_generic_payload cvif2cdma_wt_rd_rsp_bp;
    nvdla_dma_rd_rsp_t cvif2cdma_wt_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cvif2cdma_wt_rd_rsp;
    virtual void cvif2cdma_wt_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2cdp_rd_rsp
    tlm::tlm_generic_payload cvif2cdp_rd_rsp_bp;
    nvdla_dma_rd_rsp_t cvif2cdp_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cvif2cdp_rd_rsp;
    virtual void cvif2cdp_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2pdp_rd_rsp
    tlm::tlm_generic_payload cvif2pdp_rd_rsp_bp;
    nvdla_dma_rd_rsp_t cvif2pdp_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cvif2pdp_rd_rsp;
    virtual void cvif2pdp_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2rbk_rd_rsp
    tlm::tlm_generic_payload cvif2rbk_rd_rsp_bp;
    nvdla_dma_rd_rsp_t cvif2rbk_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cvif2rbk_rd_rsp;
    virtual void cvif2rbk_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2sdp_b_rd_rsp
    tlm::tlm_generic_payload cvif2sdp_b_rd_rsp_bp;
    nvdla_dma_rd_rsp_t cvif2sdp_b_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cvif2sdp_b_rd_rsp;
    virtual void cvif2sdp_b_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2sdp_e_rd_rsp
    tlm::tlm_generic_payload cvif2sdp_e_rd_rsp_bp;
    nvdla_dma_rd_rsp_t cvif2sdp_e_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cvif2sdp_e_rd_rsp;
    virtual void cvif2sdp_e_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2sdp_n_rd_rsp
    tlm::tlm_generic_payload cvif2sdp_n_rd_rsp_bp;
    nvdla_dma_rd_rsp_t cvif2sdp_n_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cvif2sdp_n_rd_rsp;
    virtual void cvif2sdp_n_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2sdp_rd_rsp
    tlm::tlm_generic_payload cvif2sdp_rd_rsp_bp;
    nvdla_dma_rd_rsp_t cvif2sdp_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif_base, 32, tlm::tlm_base_protocol_types> cvif2sdp_rd_rsp;
    virtual void cvif2sdp_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Port has no flow: cvif2bdma_wr_rsp
    sc_out<bool> cvif2bdma_wr_rsp;

    // Port has no flow: cvif2cdp_wr_rsp
    sc_out<bool> cvif2cdp_wr_rsp;

    // Port has no flow: cvif2pdp_wr_rsp
    sc_out<bool> cvif2pdp_wr_rsp;

    // Port has no flow: cvif2rbk_wr_rsp
    sc_out<bool> cvif2rbk_wr_rsp;

    // Port has no flow: cvif2sdp_wr_rsp
    sc_out<bool> cvif2sdp_wr_rsp;

/*
    // Initiator Socket (axi4): cvif2noc_axi4
    tlm::tlm_generic_payload cvif2noc_axi4_gp;
    amba_pv::amba_pv_extension cvif2noc_axi4_amba_pv_ext;
    scsim::clib::nv_axi4_bus_extension cvif2noc_axi4_nv_axi4_bus_ext;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif_base> cvif2noc_axi4;

    // Initiator Socket (axi4): noc2cvif_axi4
    tlm::tlm_generic_payload noc2cvif_axi4_gp;
    amba_pv::amba_pv_extension noc2cvif_axi4_amba_pv_ext;
    scsim::clib::nv_axi4_bus_extension noc2cvif_axi4_nv_axi4_bus_ext;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif_base> noc2cvif_axi4;
*/
    // Destructor
    virtual ~NV_NVDLA_cvif_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_cvif
inline NV_NVDLA_cvif_base::NV_NVDLA_cvif_base(const sc_module_name name)
    : sc_module(name),
    bdma2cvif_rd_req("bdma2cvif_rd_req"),
    cdma_dat2cvif_rd_req("cdma_dat2cvif_rd_req"),
    cdma_wt2cvif_rd_req("cdma_wt2cvif_rd_req"),
    cdp2cvif_rd_req("cdp2cvif_rd_req"),
    pdp2cvif_rd_req("pdp2cvif_rd_req"),
    rbk2cvif_rd_req("rbk2cvif_rd_req"),
    sdp2cvif_rd_req("sdp2cvif_rd_req"),
    sdp_b2cvif_rd_req("sdp_b2cvif_rd_req"),
    sdp_e2cvif_rd_req("sdp_e2cvif_rd_req"),
    sdp_n2cvif_rd_req("sdp_n2cvif_rd_req"),
    bdma2cvif_wr_req("bdma2cvif_wr_req"),
    cdp2cvif_wr_req("cdp2cvif_wr_req"),
    pdp2cvif_wr_req("pdp2cvif_wr_req"),
    rbk2cvif_wr_req("rbk2cvif_wr_req"),
    sdp2cvif_wr_req("sdp2cvif_wr_req"),
    cvif2bdma_rd_rsp_bp(),
    cvif2bdma_rd_rsp("cvif2bdma_rd_rsp"),
    cvif2cdma_dat_rd_rsp_bp(),
    cvif2cdma_dat_rd_rsp("cvif2cdma_dat_rd_rsp"),
    cvif2cdma_wt_rd_rsp_bp(),
    cvif2cdma_wt_rd_rsp("cvif2cdma_wt_rd_rsp"),
    cvif2cdp_rd_rsp_bp(),
    cvif2cdp_rd_rsp("cvif2cdp_rd_rsp"),
    cvif2pdp_rd_rsp_bp(),
    cvif2pdp_rd_rsp("cvif2pdp_rd_rsp"),
    cvif2rbk_rd_rsp_bp(),
    cvif2rbk_rd_rsp("cvif2rbk_rd_rsp"),
    cvif2sdp_b_rd_rsp_bp(),
    cvif2sdp_b_rd_rsp("cvif2sdp_b_rd_rsp"),
    cvif2sdp_e_rd_rsp_bp(),
    cvif2sdp_e_rd_rsp("cvif2sdp_e_rd_rsp"),
    cvif2sdp_n_rd_rsp_bp(),
    cvif2sdp_n_rd_rsp("cvif2sdp_n_rd_rsp"),
    cvif2sdp_rd_rsp_bp(),
    cvif2sdp_rd_rsp("cvif2sdp_rd_rsp"),
    cvif2bdma_wr_rsp("cvif2bdma_wr_rsp"),
    cvif2cdp_wr_rsp("cvif2cdp_wr_rsp"),
    cvif2pdp_wr_rsp("cvif2pdp_wr_rsp"),
    cvif2rbk_wr_rsp("cvif2rbk_wr_rsp"),
    cvif2sdp_wr_rsp("cvif2sdp_wr_rsp")
    //cvif2noc_axi4_gp(),
    //cvif2noc_axi4_amba_pv_ext(),
    //cvif2noc_axi4_nv_axi4_bus_ext(),
    //cvif2noc_axi4("cvif2noc_axi4"),
    //noc2cvif_axi4_gp(),
    //noc2cvif_axi4_amba_pv_ext(),
    //noc2cvif_axi4_nv_axi4_bus_ext(),
    //noc2cvif_axi4("noc2cvif_axi4")
{
    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): bdma2cvif_rd_req
    this->bdma2cvif_rd_req.register_b_transport(this, &NV_NVDLA_cvif_base::bdma2cvif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdma_dat2cvif_rd_req
    this->cdma_dat2cvif_rd_req.register_b_transport(this, &NV_NVDLA_cvif_base::cdma_dat2cvif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdma_wt2cvif_rd_req
    this->cdma_wt2cvif_rd_req.register_b_transport(this, &NV_NVDLA_cvif_base::cdma_wt2cvif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdp2cvif_rd_req
    this->cdp2cvif_rd_req.register_b_transport(this, &NV_NVDLA_cvif_base::cdp2cvif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): pdp2cvif_rd_req
    this->pdp2cvif_rd_req.register_b_transport(this, &NV_NVDLA_cvif_base::pdp2cvif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): rbk2cvif_rd_req
    this->rbk2cvif_rd_req.register_b_transport(this, &NV_NVDLA_cvif_base::rbk2cvif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp2cvif_rd_req
    this->sdp2cvif_rd_req.register_b_transport(this, &NV_NVDLA_cvif_base::sdp2cvif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_b2cvif_rd_req
    this->sdp_b2cvif_rd_req.register_b_transport(this, &NV_NVDLA_cvif_base::sdp_b2cvif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_e2cvif_rd_req
    this->sdp_e2cvif_rd_req.register_b_transport(this, &NV_NVDLA_cvif_base::sdp_e2cvif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_n2cvif_rd_req
    this->sdp_n2cvif_rd_req.register_b_transport(this, &NV_NVDLA_cvif_base::sdp_n2cvif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): bdma2cvif_wr_req
    this->bdma2cvif_wr_req.register_b_transport(this, &NV_NVDLA_cvif_base::bdma2cvif_wr_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): cdp2cvif_wr_req
    this->cdp2cvif_wr_req.register_b_transport(this, &NV_NVDLA_cvif_base::cdp2cvif_wr_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): pdp2cvif_wr_req
    this->pdp2cvif_wr_req.register_b_transport(this, &NV_NVDLA_cvif_base::pdp2cvif_wr_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): rbk2cvif_wr_req
    this->rbk2cvif_wr_req.register_b_transport(this, &NV_NVDLA_cvif_base::rbk2cvif_wr_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): sdp2cvif_wr_req
    this->sdp2cvif_wr_req.register_b_transport(this, &NV_NVDLA_cvif_base::sdp2cvif_wr_req_b_transport);

}

inline void
NV_NVDLA_cvif_base::bdma2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    bdma2cvif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::cdma_dat2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    cdma_dat2cvif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::cdma_wt2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    cdma_wt2cvif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::cdp2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    cdp2cvif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::pdp2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    pdp2cvif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::rbk2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    rbk2cvif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::sdp2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    sdp2cvif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::sdp_b2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    sdp_b2cvif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::sdp_e2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    sdp_e2cvif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::sdp_n2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    sdp_n2cvif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::bdma2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    bdma2cvif_wr_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::cdp2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    cdp2cvif_wr_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::pdp2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    pdp2cvif_wr_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::rbk2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    rbk2cvif_wr_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::sdp2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    sdp2cvif_wr_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cvif_base::cvif2bdma_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    cvif2bdma_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cvif2bdma_rd_rsp.size(); socket_id++) {
        cvif2bdma_rd_rsp[socket_id]->b_transport(cvif2bdma_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_cvif_base::cvif2cdma_dat_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    cvif2cdma_dat_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cvif2cdma_dat_rd_rsp.size(); socket_id++) {
        cvif2cdma_dat_rd_rsp[socket_id]->b_transport(cvif2cdma_dat_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_cvif_base::cvif2cdma_wt_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    cvif2cdma_wt_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cvif2cdma_wt_rd_rsp.size(); socket_id++) {
        cvif2cdma_wt_rd_rsp[socket_id]->b_transport(cvif2cdma_wt_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_cvif_base::cvif2cdp_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    cvif2cdp_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cvif2cdp_rd_rsp.size(); socket_id++) {
        cvif2cdp_rd_rsp[socket_id]->b_transport(cvif2cdp_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_cvif_base::cvif2pdp_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    cvif2pdp_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cvif2pdp_rd_rsp.size(); socket_id++) {
        cvif2pdp_rd_rsp[socket_id]->b_transport(cvif2pdp_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_cvif_base::cvif2rbk_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    cvif2rbk_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cvif2rbk_rd_rsp.size(); socket_id++) {
        cvif2rbk_rd_rsp[socket_id]->b_transport(cvif2rbk_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_cvif_base::cvif2sdp_b_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    cvif2sdp_b_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cvif2sdp_b_rd_rsp.size(); socket_id++) {
        cvif2sdp_b_rd_rsp[socket_id]->b_transport(cvif2sdp_b_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_cvif_base::cvif2sdp_e_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    cvif2sdp_e_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cvif2sdp_e_rd_rsp.size(); socket_id++) {
        cvif2sdp_e_rd_rsp[socket_id]->b_transport(cvif2sdp_e_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_cvif_base::cvif2sdp_n_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    cvif2sdp_n_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cvif2sdp_n_rd_rsp.size(); socket_id++) {
        cvif2sdp_n_rd_rsp[socket_id]->b_transport(cvif2sdp_n_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_cvif_base::cvif2sdp_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    cvif2sdp_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cvif2sdp_rd_rsp.size(); socket_id++) {
        cvif2sdp_rd_rsp[socket_id]->b_transport(cvif2sdp_rd_rsp_bp, delay);
    }
}

SCSIM_NAMESPACE_END()

#endif
