// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaAxiAdaptor.h

#ifndef _NVDLAAXIADAPTOR_H_
#define _NVDLAAXIADAPTOR_H_

#ifndef SC_INCLUDE_DYNAMIC_PROCESSES
#define SC_INCLUDE_DYNAMIC_PROCESSES
#endif

#include "scsim_common.h"
#include "gp_mm.h"
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/simple_initiator_socket.h" 
#include "tlm_utils/simple_target_socket.h" 
#include "tlm_utils/peq_with_get.h"
#include "systemc.h"

#define NVDLA_AXI_ADAPTOR_OUT_STANDING_REQUEST_NUM 1024

SCSIM_NAMESPACE_START(cmod)

using namespace sc_core;
using namespace tlm;
using scsim::clib::gp_mm;

class NvdlaAxiAdaptor : public sc_module {
public:
    NvdlaAxiAdaptor( sc_module_name module_name );
    SC_HAS_PROCESS(NvdlaAxiAdaptor);

    // Sockets for channel independent side, socket direction shall be reversed as MCIF
    // MC write request (target)
    tlm_utils::simple_target_socket<NvdlaAxiAdaptor, 512>    customized_wr_req;
    void customized_wr_req_b_transport(tlm::tlm_generic_payload& tlm_gp, sc_time& delay);
    // MC write response (initiator)
    tlm_utils::simple_initiator_socket<NvdlaAxiAdaptor, 512> customized_wr_rsp;
    // MC read request (target)
    tlm_utils::simple_target_socket<NvdlaAxiAdaptor, 512>    customized_rd_req;
    void customized_rd_req_b_transport(tlm::tlm_generic_payload& tlm_gp, sc_time& delay);
    // MC read response (initiator)
    tlm_utils::simple_initiator_socket<NvdlaAxiAdaptor, 512> customized_rd_rsp;

	// Socket for standard side
    tlm_utils::multi_passthrough_initiator_socket<NvdlaAxiAdaptor> standard_axi;

private:
    void axi_nb_transport_fw(tlm_generic_payload& tlm_gp, sc_time& delay);
    void done_request(tlm_generic_payload& tlm_gp, sc_time& delay);
    void nb_resp_thread();
    void axi_rd_wr_thread();

    tlm_sync_enum axi_nb_transport_bw_cb(int ID, tlm_generic_payload& tlm_gp, 
            tlm_phase& phase, sc_time& delay);

    sc_mutex standard_axi_mutex;

    bool   m_perf;
    gp_mm* m_mm;

    tlm_utils::peq_with_get<tlm_generic_payload> m_peq;
    sc_event m_end_req;
    sc_core::sc_fifo <tlm_generic_payload*> *axi_wr_req_fifo_;
    sc_core::sc_fifo <tlm_generic_payload*> *axi_rd_req_fifo_;
};

SCSIM_NAMESPACE_END()

#endif

