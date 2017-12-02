// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cdma_base.h

#ifndef _NV_NVDLA_CDMA_BASE_H_
#define _NV_NVDLA_CDMA_BASE_H_

#define SC_INCLUDE_DYNAMIC_PROCESSES
#include "NV_MSDEC_csb2xx_16m_secure_be_lvl_iface.h"
#include "nvdla_xx2csb_resp_iface.h"

#include "nvdla_dat_info_update_iface.h"
#include "nvdla_dma_rd_req_iface.h"
#include "nvdla_dma_rd_rsp_iface.h"
#include "nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_iface.h"
#include "nvdla_wt_info_update_iface.h"
#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_initiator_socket.h>
#include <tlm_utils/multi_passthrough_target_socket.h>

SCSIM_NAMESPACE_START(cmod)

// Base SystemC class for module NV_NVDLA_cdma
class NV_NVDLA_cdma_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_cdma_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cdma_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> csb2cdma_req;
    virtual void csb2cdma_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb2cdma_req_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dat_info_update_t): dat_up_sc2cdma
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> dat_up_sc2cdma;
    virtual void dat_up_sc2cdma_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void dat_up_sc2cdma_b_transport(int ID, nvdla_dat_info_update_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2cdma_dat_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> mcif2cdma_dat_rd_rsp;
    virtual void mcif2cdma_dat_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mcif2cdma_dat_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2cdma_dat_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> cvif2cdma_dat_rd_rsp;
    virtual void cvif2cdma_dat_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cvif2cdma_dat_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2cdma_wt_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> cvif2cdma_wt_rd_rsp;
    virtual void cvif2cdma_wt_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cvif2cdma_wt_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2cdma_wt_rd_rsp
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> mcif2cdma_wt_rd_rsp;
    virtual void mcif2cdma_wt_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mcif2cdma_wt_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_wt_info_update_t): wt_up_sc2cdma
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> wt_up_sc2cdma;
    virtual void wt_up_sc2cdma_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void wt_up_sc2cdma_b_transport(int ID, nvdla_wt_info_update_t* payload, sc_time& delay) = 0;

    // Special socket for CDMA_WT internal arbiter
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types, 1, sc_core::SC_ZERO_OR_MORE_BOUND> cdma_wt_dma_arbiter_source_id;
    virtual void cdma_wt_dma_arbiter_source_id_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdma_wt_dma_arbiter_source_id_b_transport(int ID, int source_id, sc_time& delay) = 0;

    // Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cdma2csb_resp
    tlm::tlm_generic_payload cdma2csb_resp_bp;
    nvdla_xx2csb_resp_t cdma2csb_resp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> cdma2csb_resp;
    virtual void cdma2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dat_info_update_t): dat_up_cdma2sc
    tlm::tlm_generic_payload dat_up_cdma2sc_bp;
    nvdla_dat_info_update_t dat_up_cdma2sc_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> dat_up_cdma2sc;
    virtual void dat_up_cdma2sc_b_transport(nvdla_dat_info_update_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdma_dat2mcif_rd_req
    tlm::tlm_generic_payload cdma_dat2mcif_rd_req_bp;
    nvdla_dma_rd_req_t cdma_dat2mcif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> cdma_dat2mcif_rd_req;
    virtual void cdma_dat2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdma_dat2cvif_rd_req
    tlm::tlm_generic_payload cdma_dat2cvif_rd_req_bp;
    nvdla_dma_rd_req_t cdma_dat2cvif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> cdma_dat2cvif_rd_req;
    virtual void cdma_dat2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdma_wt2cvif_rd_req
    tlm::tlm_generic_payload cdma_wt2cvif_rd_req_bp;
    nvdla_dma_rd_req_t cdma_wt2cvif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> cdma_wt2cvif_rd_req;
    virtual void cdma_wt2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): cdma_wt2mcif_rd_req
    tlm::tlm_generic_payload cdma_wt2mcif_rd_req_bp;
    nvdla_dma_rd_req_t cdma_wt2mcif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> cdma_wt2mcif_rd_req;
    virtual void cdma_wt2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t): cdma2buf_dat_wr
    tlm::tlm_generic_payload cdma2buf_dat_wr_bp;
    nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t cdma2buf_dat_wr_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> cdma2buf_dat_wr;
    virtual void cdma2buf_dat_wr_b_transport(nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t): cdma2buf_wt_wr
    tlm::tlm_generic_payload cdma2buf_wt_wr_bp;
    nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t cdma2buf_wt_wr_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> cdma2buf_wt_wr;
    virtual void cdma2buf_wt_wr_b_transport(nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_wt_info_update_t): wt_up_cdma2sc
    tlm::tlm_generic_payload wt_up_cdma2sc_bp;
    nvdla_wt_info_update_t wt_up_cdma2sc_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cdma_base, 32, tlm::tlm_base_protocol_types> wt_up_cdma2sc;
    virtual void wt_up_cdma2sc_b_transport(nvdla_wt_info_update_t* payload, sc_time& delay);

    // Port has no flow: cdma_dat2glb_done_intr
    sc_vector< sc_out<bool> > cdma_dat2glb_done_intr;

    // Port has no flow: cdma_wt2glb_done_intr
    sc_vector< sc_out<bool> > cdma_wt2glb_done_intr;

    sc_in <bool> cdma_wt_dma_arbiter_override_enable;
    // Destructor
    virtual ~NV_NVDLA_cdma_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_cdma
inline NV_NVDLA_cdma_base::NV_NVDLA_cdma_base(const sc_module_name name)
    : sc_module(name),
    csb2cdma_req("csb2cdma_req"),
    dat_up_sc2cdma("dat_up_sc2cdma"),
    mcif2cdma_dat_rd_rsp("mcif2cdma_dat_rd_rsp"),
    cvif2cdma_dat_rd_rsp("cvif2cdma_dat_rd_rsp"),
    cvif2cdma_wt_rd_rsp("cvif2cdma_wt_rd_rsp"),
    mcif2cdma_wt_rd_rsp("mcif2cdma_wt_rd_rsp"),
    wt_up_sc2cdma("wt_up_sc2cdma"),
    cdma2csb_resp_bp(),
    cdma2csb_resp("cdma2csb_resp"),
    dat_up_cdma2sc_bp(),
    dat_up_cdma2sc("dat_up_cdma2sc"),
    cdma_dat2mcif_rd_req_bp(),
    cdma_dat2mcif_rd_req("cdma_dat2mcif_rd_req"),
    cdma_dat2cvif_rd_req_bp(),
    cdma_dat2cvif_rd_req("cdma_dat2cvif_rd_req"),
    cdma_wt2cvif_rd_req_bp(),
    cdma_wt2cvif_rd_req("cdma_wt2cvif_rd_req"),
    cdma_wt2mcif_rd_req_bp(),
    cdma_wt2mcif_rd_req("cdma_wt2mcif_rd_req"),
    cdma2buf_dat_wr_bp(),
    cdma2buf_dat_wr("cdma2buf_dat_wr"),
    cdma2buf_wt_wr_bp(),
    cdma2buf_wt_wr("cdma2buf_wt_wr"),
    wt_up_cdma2sc_bp(),
    wt_up_cdma2sc("wt_up_cdma2sc"),
    cdma_dat2glb_done_intr("cdma_dat2glb_done_intr", 2),
    cdma_wt2glb_done_intr("cdma_wt2glb_done_intr", 2),
    cdma_wt_dma_arbiter_override_enable("cdma_wt_dma_arbiter_override_enable")
{
    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cdma_req
    this->csb2cdma_req.register_b_transport(this, &NV_NVDLA_cdma_base::csb2cdma_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dat_info_update_t): dat_up_sc2cdma
    this->dat_up_sc2cdma.register_b_transport(this, &NV_NVDLA_cdma_base::dat_up_sc2cdma_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2cdma_dat_rd_rsp
    this->mcif2cdma_dat_rd_rsp.register_b_transport(this, &NV_NVDLA_cdma_base::mcif2cdma_dat_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2cdma_dat_rd_rsp
    this->cvif2cdma_dat_rd_rsp.register_b_transport(this, &NV_NVDLA_cdma_base::cvif2cdma_dat_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2cdma_wt_rd_rsp
    this->cvif2cdma_wt_rd_rsp.register_b_transport(this, &NV_NVDLA_cdma_base::cvif2cdma_wt_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2cdma_wt_rd_rsp
    this->mcif2cdma_wt_rd_rsp.register_b_transport(this, &NV_NVDLA_cdma_base::mcif2cdma_wt_rd_rsp_b_transport);

    // Target Socket (unrecognized protocol: nvdla_wt_info_update_t): wt_up_sc2cdma
    this->wt_up_sc2cdma.register_b_transport(this, &NV_NVDLA_cdma_base::wt_up_sc2cdma_b_transport);

    this->cdma_wt_dma_arbiter_source_id.register_b_transport(this, &NV_NVDLA_cdma_base::cdma_wt_dma_arbiter_source_id_b_transport);
}

inline void
NV_NVDLA_cdma_base::csb2cdma_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    csb2cdma_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cdma_base::dat_up_sc2cdma_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dat_info_update_t* payload = (nvdla_dat_info_update_t*) bp.get_data_ptr();
    dat_up_sc2cdma_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cdma_base::mcif2cdma_dat_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    mcif2cdma_dat_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cdma_base::cvif2cdma_dat_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    cvif2cdma_dat_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cdma_base::cvif2cdma_wt_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    cvif2cdma_wt_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cdma_base::mcif2cdma_wt_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    mcif2cdma_wt_rd_rsp_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cdma_base::wt_up_sc2cdma_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_wt_info_update_t* payload = (nvdla_wt_info_update_t*) bp.get_data_ptr();
    wt_up_sc2cdma_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cdma_base::cdma_wt_dma_arbiter_source_id_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    int source_id;
    uint8_t* data_ptr = bp.get_data_ptr();
    memcpy((void *) & source_id, (void *) data_ptr, sizeof(int));
    // 0:weight data; 1:wmb data; 2:wgs_data
    cdma_wt_dma_arbiter_source_id_b_transport(ID, source_id, delay);
}

inline void
NV_NVDLA_cdma_base::cdma2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    cdma2csb_resp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cdma2csb_resp.size(); socket_id++) {
        cdma2csb_resp[socket_id]->b_transport(cdma2csb_resp_bp, delay);
    }
}

inline void
NV_NVDLA_cdma_base::dat_up_cdma2sc_b_transport(nvdla_dat_info_update_t* payload, sc_time& delay)
{
    dat_up_cdma2sc_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < dat_up_cdma2sc.size(); socket_id++) {
        dat_up_cdma2sc[socket_id]->b_transport(dat_up_cdma2sc_bp, delay);
    }
}

inline void
NV_NVDLA_cdma_base::cdma_dat2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    cdma_dat2mcif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cdma_dat2mcif_rd_req.size(); socket_id++) {
        cdma_dat2mcif_rd_req[socket_id]->b_transport(cdma_dat2mcif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_cdma_base::cdma_dat2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    cdma_dat2cvif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cdma_dat2cvif_rd_req.size(); socket_id++) {
        cdma_dat2cvif_rd_req[socket_id]->b_transport(cdma_dat2cvif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_cdma_base::cdma_wt2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    cdma_wt2cvif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cdma_wt2cvif_rd_req.size(); socket_id++) {
        cdma_wt2cvif_rd_req[socket_id]->b_transport(cdma_wt2cvif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_cdma_base::cdma_wt2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    cdma_wt2mcif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cdma_wt2mcif_rd_req.size(); socket_id++) {
        cdma_wt2mcif_rd_req[socket_id]->b_transport(cdma_wt2mcif_rd_req_bp, delay);
    }
}

inline void
NV_NVDLA_cdma_base::cdma2buf_dat_wr_b_transport(nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t* payload, sc_time& delay)
{
    cdma2buf_dat_wr_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < cdma2buf_dat_wr.size(); socket_id++) {
        cdma2buf_dat_wr[socket_id]->b_transport(cdma2buf_dat_wr_bp, delay);
    }
}

inline void
NV_NVDLA_cdma_base::cdma2buf_wt_wr_b_transport(nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t* payload, sc_time& delay)
{
    cdma2buf_wt_wr_bp.set_data_ptr((unsigned char*) payload);
    // for (uint8_t socket_id=0; socket_id < cdma2buf_wt_wr.size(); socket_id++) {
    //     cdma2buf_wt_wr[socket_id]->b_transport(cdma2buf_wt_wr_bp, delay);
    // }
    cdma2buf_wt_wr->b_transport(cdma2buf_wt_wr_bp, delay);
}

inline void
NV_NVDLA_cdma_base::wt_up_cdma2sc_b_transport(nvdla_wt_info_update_t* payload, sc_time& delay)
{
    wt_up_cdma2sc_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < wt_up_cdma2sc.size(); socket_id++) {
        wt_up_cdma2sc[socket_id]->b_transport(wt_up_cdma2sc_bp, delay);
    }
}

SCSIM_NAMESPACE_END()

#endif
