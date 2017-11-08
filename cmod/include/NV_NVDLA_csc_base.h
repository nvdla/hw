// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_csc_base.h

#ifndef _NV_NVDLA_CSC_BASE_H_
#define _NV_NVDLA_CSC_BASE_H_

#define SC_INCLUDE_DYNAMIC_PROCESSES
#include "NV_MSDEC_csb2xx_16m_secure_be_lvl_iface.h"
#include "nvdla_xx2csb_resp_iface.h"

#include "nvdla_cc_credit_iface.h"
#include "nvdla_dat_info_update_iface.h"
#include "nvdla_ram_rd_valid_port_RADDR_8_RDATA_1024_iface.h"
#include "nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_iface.h"
#include "nvdla_sc2mac_data_if_iface.h"
#include "nvdla_sc2mac_weight_if_iface.h"
#include "nvdla_wt_info_update_iface.h"
#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_initiator_socket.h>
#include <tlm_utils/multi_passthrough_target_socket.h>

SCSIM_NAMESPACE_START(cmod)

// Base SystemC class for module NV_NVDLA_csc
class NV_NVDLA_csc_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_csc_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2csc_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> csb2csc_req;
    virtual void csb2csc_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb2csc_req_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_cc_credit_t): accu2sc_credit
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> accu2sc_credit;
    virtual void accu2sc_credit_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void accu2sc_credit_b_transport(int ID, nvdla_cc_credit_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_dat_info_update_t): dat_up_cdma2sc
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> dat_up_cdma2sc;
    virtual void dat_up_cdma2sc_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void dat_up_cdma2sc_b_transport(int ID, nvdla_dat_info_update_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_wt_info_update_t): wt_up_cdma2sc
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> wt_up_cdma2sc;
    virtual void wt_up_cdma2sc_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void wt_up_cdma2sc_b_transport(int ID, nvdla_wt_info_update_t* payload, sc_time& delay) = 0;

    // Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): csc2csb_resp
    tlm::tlm_generic_payload csc2csb_resp_bp;
    nvdla_xx2csb_resp_t csc2csb_resp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> csc2csb_resp;
    virtual void csc2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dat_info_update_t): dat_up_sc2cdma
    tlm::tlm_generic_payload dat_up_sc2cdma_bp;
    nvdla_dat_info_update_t dat_up_sc2cdma_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> dat_up_sc2cdma;
    virtual void dat_up_sc2cdma_b_transport(nvdla_dat_info_update_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t): sc2buf_dat_rd
    tlm::tlm_generic_payload sc2buf_dat_rd_bp;
    nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t sc2buf_dat_rd_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> sc2buf_dat_rd;
    virtual void sc2buf_dat_rd_b_transport(nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t): sc2buf_wt_rd
    tlm::tlm_generic_payload sc2buf_wt_rd_bp;
    nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t sc2buf_wt_rd_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> sc2buf_wt_rd;
    virtual void sc2buf_wt_rd_b_transport(nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_ram_rd_valid_port_RADDR_8_RDATA_1024_t): sc2buf_wmb_rd
    tlm::tlm_generic_payload sc2buf_wmb_rd_bp;
    nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t sc2buf_wmb_rd_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> sc2buf_wmb_rd;
    virtual void sc2buf_wmb_rd_b_transport(nvdla_ram_rd_valid_port_RADDR_8_RDATA_1024_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_sc2mac_data_if_t): sc2mac_dat
    tlm::tlm_generic_payload sc2mac_a_dat_bp;
    nvdla_sc2mac_data_if_t sc2mac_a_dat_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> sc2mac_dat_a;
    virtual void sc2mac_a_dat_b_transport(nvdla_sc2mac_data_if_t* payload, sc_time& delay);

    tlm::tlm_generic_payload sc2mac_b_dat_bp;
    nvdla_sc2mac_data_if_t sc2mac_b_dat_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> sc2mac_dat_b;
    virtual void sc2mac_b_dat_b_transport(nvdla_sc2mac_data_if_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_sc2mac_weight_if_t): sc2mac_wt
    tlm::tlm_generic_payload sc2mac_a_wt_bp;
    nvdla_sc2mac_weight_if_t sc2mac_a_wt_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> sc2mac_wt_a;
    virtual void sc2mac_a_wt_b_transport(nvdla_sc2mac_weight_if_t* payload, sc_time& delay);

    tlm::tlm_generic_payload sc2mac_b_wt_bp;
    nvdla_sc2mac_weight_if_t sc2mac_b_wt_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> sc2mac_wt_b;
    virtual void sc2mac_b_wt_b_transport(nvdla_sc2mac_weight_if_t* payload, sc_time& delay);


    // Initiator Socket (unrecognized protocol: nvdla_wt_info_update_t): wt_up_sc2cdma
    tlm::tlm_generic_payload wt_up_sc2cdma_bp;
    nvdla_wt_info_update_t wt_up_sc2cdma_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csc_base, 32, tlm::tlm_base_protocol_types> wt_up_sc2cdma;
    virtual void wt_up_sc2cdma_b_transport(nvdla_wt_info_update_t* payload, sc_time& delay);

    // Destructor
    virtual ~NV_NVDLA_csc_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_csc
inline NV_NVDLA_csc_base::NV_NVDLA_csc_base(const sc_module_name name)
    : sc_module(name),
    csb2csc_req("csb2csc_req"),
    accu2sc_credit("accu2sc_credit"),
    dat_up_cdma2sc("dat_up_cdma2sc"),
    wt_up_cdma2sc("wt_up_cdma2sc"),
    csc2csb_resp_bp(),
    csc2csb_resp("csc2csb_resp"),
    dat_up_sc2cdma_bp(),
    dat_up_sc2cdma("dat_up_sc2cdma"),
    sc2buf_dat_rd_bp(),
    sc2buf_dat_rd("sc2buf_dat_rd"),
    sc2buf_wt_rd_bp(),
    sc2buf_wt_rd("sc2buf_wt_rd"),
    sc2buf_wmb_rd_bp(),
    sc2buf_wmb_rd("sc2buf_wmb_rd"),
    sc2mac_a_dat_bp(),
    sc2mac_dat_a("sc2mac_dat_a"),
    sc2mac_b_dat_bp(),
    sc2mac_dat_b("sc2mac_dat_b"),
    sc2mac_a_wt_bp(),
    sc2mac_wt_a("sc2mac_wt_a"),
    sc2mac_b_wt_bp(),
    sc2mac_wt_b("sc2mac_wt_b"),
    wt_up_sc2cdma_bp(),
    wt_up_sc2cdma("wt_up_sc2cdma")
{
    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2csc_req
    this->csb2csc_req.register_b_transport(this, &NV_NVDLA_csc_base::csb2csc_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_cc_credit_t): accu2sc_credit
    this->accu2sc_credit.register_b_transport(this, &NV_NVDLA_csc_base::accu2sc_credit_b_transport);

    // Target Socket (unrecognized protocol: nvdla_dat_info_update_t): dat_up_cdma2sc
    this->dat_up_cdma2sc.register_b_transport(this, &NV_NVDLA_csc_base::dat_up_cdma2sc_b_transport);

    // Target Socket (unrecognized protocol: nvdla_wt_info_update_t): wt_up_cdma2sc
    this->wt_up_cdma2sc.register_b_transport(this, &NV_NVDLA_csc_base::wt_up_cdma2sc_b_transport);

}

inline void
NV_NVDLA_csc_base::csb2csc_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
    csb2csc_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csc_base::accu2sc_credit_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_cc_credit_t* payload = (nvdla_cc_credit_t*) bp.get_data_ptr();
    accu2sc_credit_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csc_base::dat_up_cdma2sc_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dat_info_update_t* payload = (nvdla_dat_info_update_t*) bp.get_data_ptr();
    dat_up_cdma2sc_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csc_base::wt_up_cdma2sc_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_wt_info_update_t* payload = (nvdla_wt_info_update_t*) bp.get_data_ptr();
    wt_up_cdma2sc_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_csc_base::csc2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay)
{
    csc2csb_resp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < csc2csb_resp.size(); socket_id++) {
        csc2csb_resp[socket_id]->b_transport(csc2csb_resp_bp, delay);
    }
}

inline void
NV_NVDLA_csc_base::dat_up_sc2cdma_b_transport(nvdla_dat_info_update_t* payload, sc_time& delay)
{
    dat_up_sc2cdma_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < dat_up_sc2cdma.size(); socket_id++) {
        dat_up_sc2cdma[socket_id]->b_transport(dat_up_sc2cdma_bp, delay);
    }
}

inline void
NV_NVDLA_csc_base::sc2buf_dat_rd_b_transport(nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t* payload, sc_time& delay)
{
    sc2buf_dat_rd_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sc2buf_dat_rd.size(); socket_id++) {
        sc2buf_dat_rd[socket_id]->b_transport(sc2buf_dat_rd_bp, delay);
    }
}

inline void
NV_NVDLA_csc_base::sc2buf_wt_rd_b_transport(nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t* payload, sc_time& delay)
{
    sc2buf_wt_rd_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sc2buf_wt_rd.size(); socket_id++) {
        sc2buf_wt_rd[socket_id]->b_transport(sc2buf_wt_rd_bp, delay);
    }
}

inline void
NV_NVDLA_csc_base::sc2buf_wmb_rd_b_transport(nvdla_ram_rd_valid_port_RADDR_8_RDATA_1024_t* payload, sc_time& delay)
{
    sc2buf_wmb_rd_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sc2buf_wmb_rd.size(); socket_id++) {
        sc2buf_wmb_rd[socket_id]->b_transport(sc2buf_wmb_rd_bp, delay);
    }
}

inline void
NV_NVDLA_csc_base::sc2mac_a_dat_b_transport(nvdla_sc2mac_data_if_t* payload, sc_time& delay)
{
    sc2mac_a_dat_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sc2mac_dat_a.size(); socket_id++) {
        sc2mac_dat_a[socket_id]->b_transport(sc2mac_a_dat_bp, delay);
    }
}

inline void
NV_NVDLA_csc_base::sc2mac_b_dat_b_transport(nvdla_sc2mac_data_if_t* payload, sc_time& delay)
{
    sc2mac_b_dat_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sc2mac_dat_b.size(); socket_id++) {
        sc2mac_dat_b[socket_id]->b_transport(sc2mac_b_dat_bp, delay);
    }
}


inline void
NV_NVDLA_csc_base::sc2mac_a_wt_b_transport(nvdla_sc2mac_weight_if_t* payload, sc_time& delay)
{
    sc2mac_a_wt_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sc2mac_dat_a.size(); socket_id++) {
        sc2mac_wt_a[socket_id]->b_transport(sc2mac_a_wt_bp, delay);
    }
}

inline void
NV_NVDLA_csc_base::sc2mac_b_wt_b_transport(nvdla_sc2mac_weight_if_t* payload, sc_time& delay)
{
    sc2mac_b_wt_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < sc2mac_dat_b.size(); socket_id++) {
        sc2mac_wt_b[socket_id]->b_transport(sc2mac_b_wt_bp, delay);
    }
}

inline void
NV_NVDLA_csc_base::wt_up_sc2cdma_b_transport(nvdla_wt_info_update_t* payload, sc_time& delay)
{
    wt_up_sc2cdma_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < wt_up_sc2cdma.size(); socket_id++) {
        wt_up_sc2cdma[socket_id]->b_transport(wt_up_sc2cdma_bp, delay);
    }
}

SCSIM_NAMESPACE_END()

#endif
