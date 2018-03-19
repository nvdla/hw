// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: BdmaCore.h

#ifndef _BDMACORE_H_
#define _BDMACORE_H_

#define SC_INCLUDE_DYNAMIC_PROCESSES
// #include "bytestream_payload.h"
#include "nvdla_dma_rd_req_iface.h"
#include "nvdla_dma_rd_rsp_iface.h"
#include "nvdla_dma_wr_req_iface.h"
#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_initiator_socket.h>
#include <tlm_utils/multi_passthrough_target_socket.h>
// #include "bdmacoreconfigclass.h"

#define BDMA_CONFIG_FIFO_DEPTH 40
#define DMA_ATOM_SIZE 32
#define DMA_ATOM_CMOD_ENTRY_GRANULARITY 8
#define BDMA_CORE_DMA_ATOM_FIFO_SIZE 2048
#define BDMA_CORE_ONGOING_WRITE_COMPLETE_REQUEST 2
#define MEM_TRANSACTION_MAX_SIZE    256
#define MEM_TRANSACTION_ATOM_SIZE   32
#define BDMA_MAX_ONGOING_READ_REQUEST   8192

SCSIM_NAMESPACE_START(cmod)
class BdmaCoreConfig;
class BdmaCoreInt;

class DmaAtom {
public:
    uint64_t data [4] ;
};
// Operator for being a SC_FIFO payload
inline std::ostream& operator<<(std::ostream& out, const DmaAtom & obj) {
    return out << "Just to fool compiler" << endl;
}

class bdma_ack_info {
public:
    bool    is_mc;
    uint8_t group_id;
};

// Base SystemC class for module NV_NVDLA_bdma
class BdmaCore : public sc_module
{
    public:

    SC_HAS_PROCESS(BdmaCore);
    // Constructor
    BdmaCore(sc_module_name name);

    sc_in<bool> reset_n_;

    // Interrupt
    sc_vector< sc_out<bool> > interrupt;
    sc_out<bool> is_idle;
    sc_out<bool> notify_get_config;

    // Reset done
    // sc_out<bool> reset_done;
    
    // fifo used to track the expected wr ack in bdma. When it's empty, all write req are acked.
    // It's size is 2. The data type in the fifo doesn't matter.
#if 0
    sc_fifo<uint8_t>          *expected_wr_ack;
    sc_fifo<uint8_t>          *expected_wr_ack_mc;
    sc_fifo<uint8_t>          *expected_wr_ack_cv;
    // fifo used to count the current outstanding cmd which needs wr_complete. The max number is 2.
    sc_fifo<uint8_t>          *cmd_req_ack;
#endif

    sc_core::sc_fifo <bdma_ack_info *> *bdma_ack_fifo_;
    
    // Configuration ports
    sc_port<sc_fifo_in_if<BdmaCoreConfig> > core_config_in;
    sc_port<sc_fifo_in_if<BdmaCoreInt> > bdma_core_int_fifo;

    // MCIF
    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2bdma_rd_rsp
    tlm_utils::multi_passthrough_target_socket<BdmaCore, 32, tlm::tlm_base_protocol_types, 0, sc_core::SC_ONE_OR_MORE_BOUND> mcif2bdma_rd_rsp;
    virtual void mcif2bdma_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void mcif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Port has no flow: mcif2bdma_wr_rsp
    sc_in<bool> mcif2bdma_wr_rsp;

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): bdma2mcif_rd_req
    tlm::tlm_generic_payload bdma2mcif_rd_req_bp;
    nvdla_dma_rd_req_t bdma2mcif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<BdmaCore, 32, tlm::tlm_base_protocol_types, 0, sc_core::SC_ONE_OR_MORE_BOUND> bdma2mcif_rd_req;
    virtual void bdma2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_wr_req_t): bdma2mcif_wr_req
    tlm::tlm_generic_payload bdma2mcif_wr_req_bp;
    nvdla_dma_wr_req_t bdma2mcif_wr_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<BdmaCore, 32, tlm::tlm_base_protocol_types, 0, sc_core::SC_ONE_OR_MORE_BOUND> bdma2mcif_wr_req;
    virtual void bdma2mcif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay);

    // CVIF
    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): cvif2bdma_rd_rsp
    tlm_utils::multi_passthrough_target_socket<BdmaCore, 32, tlm::tlm_base_protocol_types, 0, sc_core::SC_ONE_OR_MORE_BOUND> cvif2bdma_rd_rsp;
    virtual void cvif2bdma_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void cvif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

    // Port has no flow: cvif2bdma_wr_rsp
    sc_in<bool> cvif2bdma_wr_rsp;

    // Initiator Socket (unrecognized protocol: nvdla_dma_rd_req_t): bdma2cvif_rd_req
    tlm::tlm_generic_payload bdma2cvif_rd_req_bp;
    nvdla_dma_rd_req_t bdma2cvif_rd_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<BdmaCore, 32, tlm::tlm_base_protocol_types, 0, sc_core::SC_ONE_OR_MORE_BOUND> bdma2cvif_rd_req;
    virtual void bdma2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_dma_wr_req_t): bdma2cvif_wr_req
    tlm::tlm_generic_payload bdma2cvif_wr_req_bp;
    nvdla_dma_wr_req_t bdma2cvif_wr_req_payload;
    tlm_utils::multi_passthrough_initiator_socket<BdmaCore, 32, tlm::tlm_base_protocol_types, 0, sc_core::SC_ONE_OR_MORE_BOUND> bdma2cvif_wr_req;
    virtual void bdma2cvif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay);

    // Destructor
    ~BdmaCore();

    // Payloads
    nvdla_dma_rd_req_t *rd_req_cmd_payload;
    nvdla_dma_wr_req_t *wr_req_cmd_payload;
    nvdla_dma_wr_req_t *wr_req_data_payload;

    private:
    // Variables
    // Payloads
    
    sc_core::sc_time dma_delay_;

    // FIFO between read response and write request
    sc_core::sc_fifo <DmaAtom>              *dma_atom_fifo_;
    sc_core::sc_fifo <BdmaCoreConfig>   *write_config_fifo_;
#if 0
    sc_core::sc_fifo <uint8_t>          *write_complete_interrupt_ptr_fifo_;
#endif
    sc_event    reset_event_;

    uint32_t src_ram_type_next_;
    uint32_t src_ram_type_curr_;
    uint32_t dst_ram_type_;
    uint64_t read_credit_sent_;
    uint64_t read_credit_recv_;
    sc_event read_credit_granted_;
    //sc_mutex read_credit_mutex_;

    sc_event bdma_mc_ack_;
    sc_event bdma_cv_ack_;
    bool     is_mc_ack_done_;
    bool     is_cv_ack_done_;

    // Functions
    void Reset();
    void ResetThread();
    void WaitUntilAtomFifoFreeEntryGreaterThan(uint8_t num);
    void WaitUntilAtomFifoAvailableEntryGreaterThan(uint8_t num);
    void PrepareWriteDataPayload(nvdla_dma_wr_req_t * payload, uint8_t num);
    void SendDmaReadRequest(nvdla_dma_rd_req_t* payload, sc_time& delay, uint8_t src_ram_type);
    void SendDmaWriteRequest(nvdla_dma_wr_req_t* payload, sc_time& delay, uint8_t src_ram_type);
    void ReadRequestSequenceGeneratorThread();
    void WriteRequestSequenceGeneratorThread();
    void WriteResponseMethodMc();
    void WriteResponseMethodCv();
    void BdmaIntrThread();
};

// mcif
inline void
BdmaCore::mcif2bdma_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    mcif2bdma_rd_rsp_b_transport(ID, payload, delay);
}

inline void
BdmaCore::bdma2mcif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    uint32_t socket_id;
    bdma2mcif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (socket_id=0; socket_id < bdma2mcif_rd_req.size(); socket_id++) {
        bdma2mcif_rd_req[socket_id]->b_transport(bdma2mcif_rd_req_bp, delay);
    }
    // bdma2mcif_rd_req->b_transport(bdma2mcif_rd_req_bp, delay);
}

inline void
BdmaCore::bdma2mcif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay)
{
    uint32_t socket_id;
    bdma2mcif_wr_req_bp.set_data_ptr((unsigned char*) payload);
    for (socket_id=0; socket_id < bdma2mcif_wr_req.size(); socket_id++) {
        bdma2mcif_wr_req[socket_id]->b_transport(bdma2mcif_wr_req_bp, delay);
    }
}

// cvif
inline void
BdmaCore::cvif2bdma_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    cvif2bdma_rd_rsp_b_transport(ID, payload, delay);
}

inline void
BdmaCore::bdma2cvif_rd_req_b_transport(nvdla_dma_rd_req_t* payload, sc_time& delay)
{
    uint32_t socket_id;
    bdma2cvif_rd_req_bp.set_data_ptr((unsigned char*) payload);
    for (socket_id=0; socket_id < bdma2cvif_rd_req.size(); socket_id++) {
        bdma2cvif_rd_req[socket_id]->b_transport(bdma2cvif_rd_req_bp, delay);
    }
}

inline void
BdmaCore::bdma2cvif_wr_req_b_transport(nvdla_dma_wr_req_t* payload, sc_time& delay)
{
    uint32_t socket_id;
    bdma2cvif_wr_req_bp.set_data_ptr((unsigned char*) payload);
    for (socket_id=0; socket_id < bdma2cvif_wr_req.size(); socket_id++) {
        bdma2cvif_wr_req[socket_id]->b_transport(bdma2cvif_wr_req_bp, delay);
    }
}

SCSIM_NAMESPACE_END()

#endif
