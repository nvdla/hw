// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_bdma.h

#ifndef _NV_NVDLA_BDMA_H_
#define _NV_NVDLA_BDMA_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 

#include "scsim_common.h"
#include "NV_NVDLA_bdma_base.h"
#include "bdma_reg_model.h"
// #include "bdmacoreconfigclass.h"
// #include "BdmaCore.h"


#define BDMA_CONFIG_FIFO_DEPTH      (2*NVDLA_BDMA_STATUS_0_FREE_SLOT_DEFAULT)   // Defined as 0x14 in spec
#define MAX_MEM_TRANSACTION_SIZE    256
#define MEM_TRANSACTION_ATOM_SIZE   32

SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

class BdmaCoreConfig;
class BdmaCoreInt;
// Operator for being a SC_FIFO payload
// std::ostream& operator<<(std::ostream& out, const BdmaCoreConfig & obj) {
//     return out << "Just to fool compiler" << endl;
// }
class BdmaCore;

class NV_NVDLA_bdma:
    public NV_NVDLA_bdma_base,      // ports
    private bdma_reg_model          // register accessing
{
    public:
        SC_HAS_PROCESS(NV_NVDLA_bdma);
        NV_NVDLA_bdma( sc_module_name module_name );
        ~NV_NVDLA_bdma();
        // Target sockets
        // CSB request transport implementation shall in generated code
        void csb2bdma_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        void mcif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);
        void cvif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);
        // void bdma2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay) {NV_NVDLA_bdma_base::bdma2csb_resp_b_transport(payload, delay);}
        // void bdma_rdma2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay) {NV_NVDLA_bdma_base::bdma2csb_resp_b_transport(payload, delay);}

    private:
        // Variables
        bool is_there_ongoing_csb2bdma_response_;
        // # Delay
        sc_core::sc_time csb_delay_;
        sc_core::sc_time b_transport_delay_;

        // # Events
        // sc_event    bdma_core_config_fifo_write_event;
        // sc_event    bdma_core_config_fifo_read_event;
        // # Signals
        sc_signal <bool> reset;
        sc_signal <bool> bdma_core_reset_done;
        sc_signal <bool> core_is_idle;
        sc_signal <bool> core_notify_get_config;
        // # FIFOs
        // ##   Configuration fifos
        sc_core::sc_fifo <BdmaCoreConfig>   *bdma_core_config_fifo_;
        sc_core::sc_fifo <BdmaCoreInt>      *bdma_core_int_fifo_;
        //uint32_t op_count;
        bool    int0_op_running;    // true: there is bdma ops running and int0 is supposed to be triggered when they are done.
        bool    int1_op_running;
 
        // # Sub modules
        BdmaCore *bdma_core;

        // Function declaration 
        // # Threads
        void OperationEnableTriggerThread();
        // void InterruptForwardingThread();
        void UpdateIdleStatus();
        void UpdateFreeSlotNum();
        void LaunchGroup0TriggerThread();
        void LaunchGroup1TriggerThread();
        void ClearInt0Flag();
        void ClearInt1Flag();

        // ## Reset
        void Reset();
        void BdmaSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);
};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NV_NVDLA_bdma * NV_NVDLA_bdmaCon(sc_module_name module_name);

#endif

