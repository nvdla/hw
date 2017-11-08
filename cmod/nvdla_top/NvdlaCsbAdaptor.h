// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaCsbAdaptor.h

#ifndef _NVDLACSBADAPTOR_H_
#define _NVDLACSBADAPTOR_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 


#include "scsim_common.h"

#include "NV_MSDEC_xx2csb_erpt_iface.h"
#include "NV_MSDEC_csb2xx_16m_secure_be_lvl_iface.h"

SCSIM_NAMESPACE_START(cmod)

class NvdlaCsbAdaptor : public sc_module {
    public:
        SC_HAS_PROCESS(NvdlaCsbAdaptor);
        NvdlaCsbAdaptor( sc_module_name module_name );
        ~NvdlaCsbAdaptor();

        tlm_utils::multi_passthrough_target_socket<NvdlaCsbAdaptor> csb_nvdla_bus;
        void csb_nvdla_bus_cb(int ID, tlm::tlm_generic_payload& gp, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCsbAdaptor> csb2adaptor;
        void csb2adaptor_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        void csb2adaptor_b_transport(int ID, NV_MSDEC_xx2csb_erpt_t* payload, sc_time& delay);

		// Socket for csb_master side
        tlm_utils::multi_passthrough_initiator_socket<NvdlaCsbAdaptor> adaptor2csb;
    private:
        // Variables
        tlm::tlm_generic_payload adaptor2csb_bp;
        // Payloads
        // Delay
        // Events
        // FIFOs
		sc_core::sc_fifo <NV_MSDEC_xx2csb_erpt_t *> *csb_read_fifo;
		// sc_core::sc_fifo <int> wr_req_fifo_id_;
		// sc_core::sc_fifo <tlm::tlm_generic_payload *> rd_req_fifo_payload_;
		// sc_core::sc_fifo <int> rd_req_fifo_id_;

		// sc_core::sc_mutex standard_axi_mutex;

        // Function declaration 
        // # Threads
        // # Functional functions
};

SCSIM_NAMESPACE_END()

#endif

