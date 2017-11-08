// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cbuf_base.h

#ifndef _NV_NVDLA_CBUF_BASE_H_
#define _NV_NVDLA_CBUF_BASE_H_

#define SC_INCLUDE_DYNAMIC_PROCESSES

#include "nvdla_ram_rd_valid_port_RADDR_8_RDATA_1024_iface.h"
#include "nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_iface.h"
#include "nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_iface.h"
#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_target_socket.h>

SCSIM_NAMESPACE_START(cmod)

// Base SystemC class for module NV_NVDLA_cbuf
class NV_NVDLA_cbuf_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_cbuf_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: nvdla_ram_rd_valid_port_RADDR_8_RDATA_1024_t): sc2buf_wmb_rd
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cbuf_base, 32, tlm::tlm_base_protocol_types> sc2buf_wmb_rd;
    virtual void sc2buf_wmb_rd_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sc2buf_wmb_rd_b_transport(int ID, nvdla_ram_rd_valid_port_RADDR_8_RDATA_1024_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t): sc2buf_dat_rd
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cbuf_base, 32, tlm::tlm_base_protocol_types> sc2buf_dat_rd;
    virtual void sc2buf_dat_rd_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sc2buf_dat_rd_b_transport(int ID, nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t): sc2buf_wt_rd
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cbuf_base, 32, tlm::tlm_base_protocol_types> sc2buf_wt_rd;
    virtual void sc2buf_wt_rd_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void sc2buf_wt_rd_b_transport(int ID, nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t): cdma2buf_dat_wr
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cbuf_base, 32, tlm::tlm_base_protocol_types> cdma2buf_dat_wr;
    virtual void cdma2buf_dat_wr_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdma2buf_dat_wr_b_transport(int ID, nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t): cdma2buf_wt_wr
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cbuf_base, 32, tlm::tlm_base_protocol_types> cdma2buf_wt_wr;
    virtual void cdma2buf_wt_wr_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cdma2buf_wt_wr_b_transport(int ID, nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t* payload, sc_time& delay) = 0;

    // Destructor
    virtual ~NV_NVDLA_cbuf_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_cbuf
inline NV_NVDLA_cbuf_base::NV_NVDLA_cbuf_base(const sc_module_name name)
    : sc_module(name),
    sc2buf_wmb_rd("sc2buf_wmb_rd"),
    sc2buf_dat_rd("sc2buf_dat_rd"),
    sc2buf_wt_rd("sc2buf_wt_rd"),
    cdma2buf_dat_wr("cdma2buf_dat_wr"),
    cdma2buf_wt_wr("cdma2buf_wt_wr")
{
    // Target Socket (unrecognized protocol: nvdla_ram_rd_valid_port_RADDR_8_RDATA_1024_t): sc2buf_wmb_rd
    this->sc2buf_wmb_rd.register_b_transport(this, &NV_NVDLA_cbuf_base::sc2buf_wmb_rd_b_transport);

    // Target Socket (unrecognized protocol: nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t): sc2buf_dat_rd
    this->sc2buf_dat_rd.register_b_transport(this, &NV_NVDLA_cbuf_base::sc2buf_dat_rd_b_transport);

    // Target Socket (unrecognized protocol: nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t): sc2buf_wt_rd
    this->sc2buf_wt_rd.register_b_transport(this, &NV_NVDLA_cbuf_base::sc2buf_wt_rd_b_transport);

    // Target Socket (unrecognized protocol: nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t): cdma2buf_dat_wr
    this->cdma2buf_dat_wr.register_b_transport(this, &NV_NVDLA_cbuf_base::cdma2buf_dat_wr_b_transport);

    // Target Socket (unrecognized protocol: nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t): cdma2buf_wt_wr
    this->cdma2buf_wt_wr.register_b_transport(this, &NV_NVDLA_cbuf_base::cdma2buf_wt_wr_b_transport);

}

inline void
NV_NVDLA_cbuf_base::sc2buf_wmb_rd_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_ram_rd_valid_port_RADDR_8_RDATA_1024_t* payload = (nvdla_ram_rd_valid_port_RADDR_8_RDATA_1024_t*) bp.get_data_ptr();
    sc2buf_wmb_rd_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cbuf_base::sc2buf_dat_rd_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t* payload = (nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t*) bp.get_data_ptr();
    sc2buf_dat_rd_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cbuf_base::sc2buf_wt_rd_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t* payload = (nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t*) bp.get_data_ptr();
    sc2buf_wt_rd_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cbuf_base::cdma2buf_dat_wr_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t* payload = (nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t*) bp.get_data_ptr();
    cdma2buf_dat_wr_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_cbuf_base::cdma2buf_wt_wr_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t* payload = (nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t*) bp.get_data_ptr();
    cdma2buf_wt_wr_b_transport(ID, payload, delay);
}

SCSIM_NAMESPACE_END()

#endif
