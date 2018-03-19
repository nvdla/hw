// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_csb_master.h

#ifndef _NV_NVDLA_CSB_MASTER_H_
#define _NV_NVDLA_CSB_MASTER_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 
#include "scsim_common.h"
#include "NV_MSDEC_xx2csb_wr_erpt_iface.h"
#include "nvdla_xx2csb_resp_iface.h"
#include "NV_NVDLA_csb_master_base.h"

#define CFGROM_BASE 0x0
#define GLB_BASE 0x1000
#define MCIF_BASE 0x2000
#define CDMA_BASE 0x3000
#define CSC_BASE 0x4000
#define CMAC_A_BASE 0x5000
#define CMAC_B_BASE 0x6000
#define CACC_BASE 0x7000
#define SDP_RDMA_BASE 0x8000
#define SDP_BASE 0x9000
#define PDP_RDMA_BASE 0xa000
#define PDP_BASE 0xb000
#define CDP_RDMA_BASE 0xc000
#define CDP_BASE 0xd000

// Unused sub-units in nv_small
#define GEC_BASE  0xe000
#define CVIF_BASE 0xf000
#define BDMA_BASE 0x10000
#define RBK_BASE  0x11000

SCSIM_NAMESPACE_START(cmod)
// Forward declaration on NESS generated wrapper
// class NV_NVDLA_csb_master_base;
class NV_NVDLA_csb_master:public NV_NVDLA_csb_master_base {
    public:
    NV_NVDLA_csb_master( sc_module_name module_name );
    ~NV_NVDLA_csb_master();
    // Socket function declaration
    tlm::tlm_generic_payload csb2nvdla_wr_hack_bp;
    NV_MSDEC_xx2csb_wr_erpt_t csb2nvdla_wr_hack_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_csb_master, 32, tlm::tlm_base_protocol_types, 0, sc_core::SC_ONE_OR_MORE_BOUND> csb2nvdla_wr_hack;
    virtual void csb2nvdla_wr_hack_b_transport(NV_MSDEC_xx2csb_wr_erpt_t* payload, sc_time& delay);
    // nvdla2csb request target socket
    virtual void nvdla2csb_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
    // CSB2NVDLA_CORE_Clients sockets
    void glb2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void gec2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void mcif2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void cvif2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void bdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void cdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void csc2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void cmac_a2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void cmac_b2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void cacc2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void sdp_rdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void sdp2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void pdp_rdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void pdp2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void cdp_rdma2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void cdp2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);
    void rbk2csb_resp_b_transport(int ID, nvdla_xx2csb_resp_t* payload, sc_time& delay);

    private:
    uint32_t serving_client_id; 
};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NV_NVDLA_csb_master * NV_NVDLA_csb_masterCon(sc_module_name module_name);

#endif

