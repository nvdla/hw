// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_mcif_base.h

#ifndef _NV_NVDLA_MCIF_BASE_H_
#define _NV_NVDLA_MCIF_BASE_H_

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

// Base SystemC class for module NV_NVDLA_mcif
class NV_NVDLA_mcif_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_mcif_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): bdma2mcif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> bdma2mcif_rd_req;
    virtual void bdma2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void bdma2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdma_dat2mcif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> cdma_dat2mcif_rd_req;
    virtual void cdma_dat2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdma_dat2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdma_wt2mcif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> cdma_wt2mcif_rd_req;
    virtual void cdma_wt2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdma_wt2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdp2mcif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> cdp2mcif_rd_req;
    virtual void cdp2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdp2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): pdp2mcif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> pdp2mcif_rd_req;
    virtual void pdp2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void pdp2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): rbk2mcif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> rbk2mcif_rd_req;
    virtual void rbk2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void rbk2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp2mcif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> sdp2mcif_rd_req;
    virtual void sdp2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sdp2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_b2mcif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> sdp_b2mcif_rd_req;
    virtual void sdp_b2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sdp_b2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_e2mcif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> sdp_e2mcif_rd_req;
    virtual void sdp_e2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sdp_e2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_n2mcif_rd_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> sdp_n2mcif_rd_req;
    virtual void sdp_n2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sdp_n2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): bdma2mcif_wr_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> bdma2mcif_wr_req;
    virtual void bdma2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void bdma2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): cdp2mcif_wr_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> cdp2mcif_wr_req;
    virtual void cdp2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdp2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): pdp2mcif_wr_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> pdp2mcif_wr_req;
    virtual void pdp2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void pdp2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): rbk2mcif_wr_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> rbk2mcif_wr_req;
    virtual void rbk2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void rbk2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): sdp2mcif_wr_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> sdp2mcif_wr_req;
    virtual void sdp2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sdp2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) = 0;

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2bdma_rd_rsp
    tlm::tlm_generic_payload mcif2bdma_rd_rsp_bp;
    nvdla_dma_rd_rsp_t mcif2bdma_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> mcif2bdma_rd_rsp;
    virtual void mcif2bdma_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2cdma_dat_rd_rsp
    tlm::tlm_generic_payload mcif2cdma_dat_rd_rsp_bp;
    nvdla_dma_rd_rsp_t mcif2cdma_dat_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> mcif2cdma_dat_rd_rsp;
    virtual void mcif2cdma_dat_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2cdma_wt_rd_rsp
    tlm::tlm_generic_payload mcif2cdma_wt_rd_rsp_bp;
    nvdla_dma_rd_rsp_t mcif2cdma_wt_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> mcif2cdma_wt_rd_rsp;
    virtual void mcif2cdma_wt_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2cdp_rd_rsp
    tlm::tlm_generic_payload mcif2cdp_rd_rsp_bp;
    nvdla_dma_rd_rsp_t mcif2cdp_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> mcif2cdp_rd_rsp;
    virtual void mcif2cdp_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2pdp_rd_rsp
    tlm::tlm_generic_payload mcif2pdp_rd_rsp_bp;
    nvdla_dma_rd_rsp_t mcif2pdp_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> mcif2pdp_rd_rsp;
    virtual void mcif2pdp_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2rbk_rd_rsp
    tlm::tlm_generic_payload mcif2rbk_rd_rsp_bp;
    nvdla_dma_rd_rsp_t mcif2rbk_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> mcif2rbk_rd_rsp;
    virtual void mcif2rbk_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2sdp_b_rd_rsp
    tlm::tlm_generic_payload mcif2sdp_b_rd_rsp_bp;
    nvdla_dma_rd_rsp_t mcif2sdp_b_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> mcif2sdp_b_rd_rsp;
    virtual void mcif2sdp_b_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2sdp_e_rd_rsp
    tlm::tlm_generic_payload mcif2sdp_e_rd_rsp_bp;
    nvdla_dma_rd_rsp_t mcif2sdp_e_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> mcif2sdp_e_rd_rsp;
    virtual void mcif2sdp_e_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2sdp_n_rd_rsp
    tlm::tlm_generic_payload mcif2sdp_n_rd_rsp_bp;
    nvdla_dma_rd_rsp_t mcif2sdp_n_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> mcif2sdp_n_rd_rsp;
    virtual void mcif2sdp_n_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2sdp_rd_rsp
    tlm::tlm_generic_payload mcif2sdp_rd_rsp_bp;
    nvdla_dma_rd_rsp_t mcif2sdp_rd_rsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_mcif_base, 32, tlm::tlm_base_protocol_types> mcif2sdp_rd_rsp;
    virtual void mcif2sdp_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Port has no flow: mcif2bdma_wr_rsp
    sc_out<bool> mcif2bdma_wr_rsp;

    // Port has no flow: mcif2cdp_wr_rsp
    sc_out<bool> mcif2cdp_wr_rsp;

    // Port has no flow: mcif2pdp_wr_rsp
    sc_out<bool> mcif2pdp_wr_rsp;

    // Port has no flow: mcif2rbk_wr_rsp
    sc_out<bool> mcif2rbk_wr_rsp;

    // Port has no flow: mcif2sdp_wr_rsp
    sc_out<bool> mcif2sdp_wr_rsp;

    /*
    // Initiator Socket (axi4): noc2mcif_axi4
    tlm::tlm_generic_payload noc2mcif_axi4_gp;
    amba_pv::amba_pv_extension noc2mcif_axi4_amba_pv_ext;
    scsim::clib::nv_axi4_bus_extension noc2mcif_axi4_nv_axi4_bus_ext;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_mcif_base> noc2mcif_axi4;

    // Initiator Socket (axi4): mcif2noc_axi4
    tlm::tlm_generic_payload mcif2noc_axi4_gp;
    amba_pv::amba_pv_extension mcif2noc_axi4_amba_pv_ext;
    scsim::clib::nv_axi4_bus_extension mcif2noc_axi4_nv_axi4_bus_ext;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_mcif_base> mcif2noc_axi4;
    */

    // Destructor
    virtual ~NV_NVDLA_mcif_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_mcif
inline NV_NVDLA_mcif_base::NV_NVDLA_mcif_base(const sc_module_name name)
    : sc_module(name),
    bdma2mcif_rd_req("bdma2mcif_rd_req"),
    cdma_dat2mcif_rd_req("cdma_dat2mcif_rd_req"),
    cdma_wt2mcif_rd_req("cdma_wt2mcif_rd_req"),
    cdp2mcif_rd_req("cdp2mcif_rd_req"),
    pdp2mcif_rd_req("pdp2mcif_rd_req"),
    rbk2mcif_rd_req("rbk2mcif_rd_req"),
    sdp2mcif_rd_req("sdp2mcif_rd_req"),
    sdp_b2mcif_rd_req("sdp_b2mcif_rd_req"),
    sdp_e2mcif_rd_req("sdp_e2mcif_rd_req"),
    sdp_n2mcif_rd_req("sdp_n2mcif_rd_req"),
    bdma2mcif_wr_req("bdma2mcif_wr_req"),
    cdp2mcif_wr_req("cdp2mcif_wr_req"),
    pdp2mcif_wr_req("pdp2mcif_wr_req"),
    rbk2mcif_wr_req("rbk2mcif_wr_req"),
    sdp2mcif_wr_req("sdp2mcif_wr_req"),
    mcif2bdma_rd_rsp_bp(),
    mcif2bdma_rd_rsp("mcif2bdma_rd_rsp"),
    mcif2cdma_dat_rd_rsp_bp(),
    mcif2cdma_dat_rd_rsp("mcif2cdma_dat_rd_rsp"),
    mcif2cdma_wt_rd_rsp_bp(),
    mcif2cdma_wt_rd_rsp("mcif2cdma_wt_rd_rsp"),
    mcif2cdp_rd_rsp_bp(),
    mcif2cdp_rd_rsp("mcif2cdp_rd_rsp"),
    mcif2pdp_rd_rsp_bp(),
    mcif2pdp_rd_rsp("mcif2pdp_rd_rsp"),
    mcif2rbk_rd_rsp_bp(),
    mcif2rbk_rd_rsp("mcif2rbk_rd_rsp"),
    mcif2sdp_b_rd_rsp_bp(),
    mcif2sdp_b_rd_rsp("mcif2sdp_b_rd_rsp"),
    mcif2sdp_e_rd_rsp_bp(),
    mcif2sdp_e_rd_rsp("mcif2sdp_e_rd_rsp"),
    mcif2sdp_n_rd_rsp_bp(),
    mcif2sdp_n_rd_rsp("mcif2sdp_n_rd_rsp"),
    mcif2sdp_rd_rsp_bp(),
    mcif2sdp_rd_rsp("mcif2sdp_rd_rsp"),
    mcif2bdma_wr_rsp("mcif2bdma_wr_rsp"),
    mcif2cdp_wr_rsp("mcif2cdp_wr_rsp"),
    mcif2pdp_wr_rsp("mcif2pdp_wr_rsp"),
    mcif2rbk_wr_rsp("mcif2rbk_wr_rsp"),
    mcif2sdp_wr_rsp("mcif2sdp_wr_rsp")
    //noc2mcif_axi4_gp(),
    //noc2mcif_axi4_amba_pv_ext(),
    //noc2mcif_axi4_nv_axi4_bus_ext(),
    //noc2mcif_axi4("noc2mcif_axi4"),
    //mcif2noc_axi4_gp(),
    //mcif2noc_axi4_amba_pv_ext(),
    //mcif2noc_axi4_nv_axi4_bus_ext(),
    //mcif2noc_axi4("mcif2noc_axi4")
{
    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): bdma2mcif_rd_req
    this->bdma2mcif_rd_req.register_b_transport(this, &NV_NVDLA_mcif_base::bdma2mcif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdma_dat2mcif_rd_req
    this->cdma_dat2mcif_rd_req.register_b_transport(this, &NV_NVDLA_mcif_base::cdma_dat2mcif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdma_wt2mcif_rd_req
    this->cdma_wt2mcif_rd_req.register_b_transport(this, &NV_NVDLA_mcif_base::cdma_wt2mcif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdp2mcif_rd_req
    this->cdp2mcif_rd_req.register_b_transport(this, &NV_NVDLA_mcif_base::cdp2mcif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): pdp2mcif_rd_req
    this->pdp2mcif_rd_req.register_b_transport(this, &NV_NVDLA_mcif_base::pdp2mcif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): rbk2mcif_rd_req
    this->rbk2mcif_rd_req.register_b_transport(this, &NV_NVDLA_mcif_base::rbk2mcif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp2mcif_rd_req
    this->sdp2mcif_rd_req.register_b_transport(this, &NV_NVDLA_mcif_base::sdp2mcif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_b2mcif_rd_req
    this->sdp_b2mcif_rd_req.register_b_transport(this, &NV_NVDLA_mcif_base::sdp_b2mcif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_e2mcif_rd_req
    this->sdp_e2mcif_rd_req.register_b_transport(this, &NV_NVDLA_mcif_base::sdp_e2mcif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_req_t): sdp_n2mcif_rd_req
    this->sdp_n2mcif_rd_req.register_b_transport(this, &NV_NVDLA_mcif_base::sdp_n2mcif_rd_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): bdma2mcif_wr_req
    this->bdma2mcif_wr_req.register_b_transport(this, &NV_NVDLA_mcif_base::bdma2mcif_wr_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): cdp2mcif_wr_req
    this->cdp2mcif_wr_req.register_b_transport(this, &NV_NVDLA_mcif_base::cdp2mcif_wr_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): pdp2mcif_wr_req
    this->pdp2mcif_wr_req.register_b_transport(this, &NV_NVDLA_mcif_base::pdp2mcif_wr_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): rbk2mcif_wr_req
    this->rbk2mcif_wr_req.register_b_transport(this, &NV_NVDLA_mcif_base::rbk2mcif_wr_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_wr_req_t): sdp2mcif_wr_req
    this->sdp2mcif_wr_req.register_b_transport(this, &NV_NVDLA_mcif_base::sdp2mcif_wr_req_b_transport);

}

inline void
NV_NVDLA_mcif_base::bdma2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    bdma2mcif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::cdma_dat2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    cdma_dat2mcif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::cdma_wt2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    cdma_wt2mcif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::cdp2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    cdp2mcif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::pdp2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    pdp2mcif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::rbk2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    rbk2mcif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::sdp2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    sdp2mcif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::sdp_b2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    sdp_b2mcif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::sdp_e2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    sdp_e2mcif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::sdp_n2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    sdp_n2mcif_rd_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::bdma2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    bdma2mcif_wr_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::cdp2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    cdp2mcif_wr_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::pdp2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    pdp2mcif_wr_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::rbk2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    rbk2mcif_wr_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::sdp2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    sdp2mcif_wr_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_mcif_base::mcif2bdma_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    mcif2bdma_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < mcif2bdma_rd_rsp.size(); socket_id++) {
        mcif2bdma_rd_rsp[socket_id]->b_transport(mcif2bdma_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_mcif_base::mcif2cdma_dat_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    mcif2cdma_dat_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < mcif2cdma_dat_rd_rsp.size(); socket_id++) {
        mcif2cdma_dat_rd_rsp[socket_id]->b_transport(mcif2cdma_dat_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_mcif_base::mcif2cdma_wt_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    mcif2cdma_wt_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < mcif2cdma_wt_rd_rsp.size(); socket_id++) {
        mcif2cdma_wt_rd_rsp[socket_id]->b_transport(mcif2cdma_wt_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_mcif_base::mcif2cdp_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    mcif2cdp_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < mcif2cdp_rd_rsp.size(); socket_id++) {
        mcif2cdp_rd_rsp[socket_id]->b_transport(mcif2cdp_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_mcif_base::mcif2pdp_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    mcif2pdp_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < mcif2pdp_rd_rsp.size(); socket_id++) {
        mcif2pdp_rd_rsp[socket_id]->b_transport(mcif2pdp_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_mcif_base::mcif2rbk_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    mcif2rbk_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < mcif2rbk_rd_rsp.size(); socket_id++) {
        mcif2rbk_rd_rsp[socket_id]->b_transport(mcif2rbk_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_mcif_base::mcif2sdp_b_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    mcif2sdp_b_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < mcif2sdp_b_rd_rsp.size(); socket_id++) {
        mcif2sdp_b_rd_rsp[socket_id]->b_transport(mcif2sdp_b_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_mcif_base::mcif2sdp_e_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    mcif2sdp_e_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < mcif2sdp_e_rd_rsp.size(); socket_id++) {
        mcif2sdp_e_rd_rsp[socket_id]->b_transport(mcif2sdp_e_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_mcif_base::mcif2sdp_n_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    mcif2sdp_n_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < mcif2sdp_n_rd_rsp.size(); socket_id++) {
        mcif2sdp_n_rd_rsp[socket_id]->b_transport(mcif2sdp_n_rd_rsp_bp, delay);
    }
}

inline void
NV_NVDLA_mcif_base::mcif2sdp_rd_rsp_b_transport(nvdla_dma_rd_rsp_t* payload, sc_time& delay)
{
    mcif2sdp_rd_rsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < mcif2sdp_rd_rsp.size(); socket_id++) {
        mcif2sdp_rd_rsp[socket_id]->b_transport(mcif2sdp_rd_rsp_bp, delay);
    }
}

SCSIM_NAMESPACE_END()

#endif
