// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_sdp.h

#ifndef _NV_NVDLA_SDP_H_
#define _NV_NVDLA_SDP_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 

#include "scsim_common.h"

#include "nvdla_accu2pp_if_iface.h"
#include "nvdla_dma_wr_req_iface.h"
#include "nvdla_xx2csb_resp_iface.h"
#include "NV_NVDLA_sdp_base.h"
#include "sdp_reg_model.h"
#include "sdp_rdma_reg_model.h"

#include "sdp_hls_wrapper.h"
#include "NvdlaPacker.h"
#include "nvdla_config.h"

#define ATOM_CUBE_SIZE          (DLA_ATOM_SIZE)
#define SDP_RDMA_BUFFER_SIZE    9*256

#define DMA_TRANSACTION_SIZE    (DMAIF_WIDTH)

#define DATA_FORMAT_IS_INT8                 0
#define DATA_FORMAT_IS_INT16                1
#define DATA_FORMAT_IS_FP16                 2
#define ELEMENT_PER_GROUP_INT8              (NVDLA_MEMORY_ATOMIC_SIZE)
#define ELEMENT_PER_GROUP_INT16             (NVDLA_MEMORY_ATOMIC_SIZE)
#define ELEMENT_PER_GROUP_FP16              (NVDLA_MEMORY_ATOMIC_SIZE)
#define ELEMENT_PER_ATOM_INT8               (NVDLA_MEMORY_ATOMIC_SIZE)
#define ELEMENT_PER_ATOM_INT16              (NVDLA_MEMORY_ATOMIC_SIZE)
#define ELEMENT_PER_ATOM_FP16               (NVDLA_MEMORY_ATOMIC_SIZE)
#define WINOGRAD_HORI_ATOM_NUM              2
#define WINOGRAD_VERT_ATOM_NUM              4
#define SDP_PARALLEL_PROC_NUM               (SDP_MAX_THROUGHPUT)
#define DMA_MAX_ATOM_NUM                    (DMAIF_WIDTH/DLA_ATOM_SIZE)
#define ATOM_PROC_ITER_NUM                  (NVDLA_MEMORY_ATOMIC_SIZE/SDP_MAX_THROUGHPUT)
#if ATOM_PROC_ITER_NUM == 0
#undef ATOM_PROC_ITER_NUM
#define ATOM_PROC_ITER_NUM                  1
#endif

SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)
// Register class forward declaration

#define CC2PP_PAYLOAD_SIZE              (SDP_MAX_THROUGHPUT)
#define LOW_ADDRESS_SHIFT               (NVDLA_SDP_RDMA_D_SRC_BASE_ADDR_LOW_0_SRC_BASE_ADDR_LOW_SHIFT)

typedef enum {
    SDP_RDMA_INPUT,
    SDP_RDMA_X1_INPUT,
    SDP_RDMA_X2_INPUT,
    SDP_RDMA_Y_INPUT,
    SDP_WDMA,
    SDP_DMA_NUM,
} te_rdma_type;

class SdpConfig {
    public:
        uint8_t   sdp_rdma_brdma_data_mode_;
        uint8_t   sdp_rdma_nrdma_data_mode_;
        uint8_t   sdp_rdma_erdma_data_mode_;
};

class ack_info {
    public:
        int8_t  is_mc;
        uint8_t group_id;
};

class NV_NVDLA_sdp:
    public  NV_NVDLA_sdp_base,  // ports
    private sdp_reg_model,      // sdp data path and write dma register accessing
    private sdp_rdma_reg_model  // sdp rdma register accessing
{
    public:
        SC_HAS_PROCESS(NV_NVDLA_sdp);
        NV_NVDLA_sdp( sc_module_name module_name );
        ~NV_NVDLA_sdp();
        // Overload for pure virtual TLM target functions
        // # CSB request transport implementation shall in generated code
        void csb2sdp_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        void csb2sdp_rdma_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // # CACC -> SDP
        void cacc2sdp_b_transport(int ID, nvdla_accu2pp_if_t* payload, sc_time& delay);
        // # MC/CV_SRAM read response
        void mcif2sdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);
        void mcif2sdp_b_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);
        void mcif2sdp_n_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);
        void mcif2sdp_e_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);
        void cvif2sdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);
        void cvif2sdp_b_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);
        void cvif2sdp_n_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);
        void cvif2sdp_e_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);

        // Port has no flow: bdma2glb_done_intr
        sc_vector< sc_out<bool> > sdp2glb_done_intr;

    private:
        sc_core::sc_fifo          <SdpConfig *> *sdp_config_fifo_;
        SdpConfig                 sdp_cfg_;
        
        // HLS module
        sdp_hls_wrapper sdp_hls_wrapper_;

        // Payloads
        nvdla_dma_wr_req_t *dma_wr_req_cmd_payload_;
        nvdla_dma_wr_req_t *dma_wr_req_data_payload_;
        nvdla_dma_rd_req_t *dma_rd_req_payload_;
        nvdla_dma_rd_req_t *dma_b_rd_req_payload_;
        nvdla_dma_rd_req_t *dma_n_rd_req_payload_;
        nvdla_dma_rd_req_t *dma_e_rd_req_payload_;

        // Variables
        bool is_there_ongoing_csb2sdp_response_;
        bool is_there_ongoing_csb2sdp_rdma_response_;
        // Delay
        sc_core::sc_time dma_delay_;
        sc_core::sc_time csb_delay_;
        sc_core::sc_time b_transport_delay_;


        // buffers
        int32_t     hls_data_in_[SDP_MAX_THROUGHPUT];
        // round, proc, element
        int16_t     hls_x1_alu_op_[2][ATOM_PROC_ITER_NUM][SDP_MAX_THROUGHPUT];
        int16_t     hls_x1_mul_op_[2][ATOM_PROC_ITER_NUM][SDP_MAX_THROUGHPUT];
        int16_t     hls_x2_alu_op_[2][ATOM_PROC_ITER_NUM][SDP_MAX_THROUGHPUT];
        int16_t     hls_x2_mul_op_[2][ATOM_PROC_ITER_NUM][SDP_MAX_THROUGHPUT];
        int16_t     hls_y_alu_op_ [2][ATOM_PROC_ITER_NUM][SDP_MAX_THROUGHPUT];
        int16_t     hls_y_mul_op_ [2][ATOM_PROC_ITER_NUM][SDP_MAX_THROUGHPUT];

        // Events
        sc_event sdp_rdma_kickoff_;
        sc_event sdp_kickoff_;
        sc_event sdp_rdma_done_;
        sc_event sdp_b_rdma_done_;
        sc_event sdp_n_rdma_done_;
        sc_event sdp_e_rdma_done_;
        sc_event sdp_done_;
        sc_event sdp_mc_ack_;
        sc_event sdp_cv_ack_;
        bool     is_mc_ack_done_;
        bool     is_cv_ack_done_;

        int16_t                     *payload_alu_;
        int16_t                     *payload_mul_;
        int                         payload_index_;
        sc_core::sc_fifo <int16_t *>      *rdma_fifo_;

        sc_core::sc_fifo <int16_t *>     *rdma_b_alu_fifo_;
        sc_core::sc_fifo <int16_t *>     *rdma_b_mul_fifo_;

        sc_core::sc_fifo <int16_t *>     *rdma_n_alu_fifo_;
        sc_core::sc_fifo <int16_t *>     *rdma_n_mul_fifo_;

        sc_core::sc_fifo <int16_t *>     *rdma_e_alu_fifo_;
        sc_core::sc_fifo <int16_t *>     *rdma_e_mul_fifo_;

        sc_core::sc_fifo <int16_t *>     *wdma_fifo_;

        sc_core::sc_fifo <int32_t *>      *cc2pp_fifo_;
        sc_core::sc_fifo <ack_info *>     *sdp_ack_fifo_;
        uint8_t                     *sdp_internal_buf_[SDP_DMA_NUM];
        uint32_t                    sdp_buf_wr_ptr_[SDP_DMA_NUM];
        uint32_t                    sdp_buf_rd_ptr_[SDP_DMA_NUM];
        uint32_t                    sdp_buf_width_iter_[SDP_DMA_NUM];
        uint32_t                    rdma_atom_total_[SDP_DMA_NUM];
        uint32_t                    rdma_atom_recieved_[SDP_DMA_NUM];

        NvdlaPacker                 dma_packers_[SDP_DMA_NUM];

        // Function declaration 
        // # Threads
        void SdpRdmaConsumerThread();
        void SdpConsumerThread();
        // ## RDMA thread
        void SdpRdmaCore( te_rdma_type eRdma );
        void SdpRdmaThread();
        void SdpBRdmaThread();
        void SdpNRdmaThread();
        void SdpERdmaThread();
        void SdpIntrThread();
        // ## Data path operation thread
        void SdpDataOperationWG();
        void SdpDataOperationBatch();
        void SdpDataOperationDC();
        void SdpDataOperationThread();
        // ## WDMA thread
        void WdmaSequenceDC();
        void WdmaSequenceWG();
        void WdmaSequenceBatch();
        void SdpWdmaThread();
        void WriteResponseThreadMc();
        void WriteResponseThreadCv();
        // #  Functional functions
        void WdmaSequenceCommon();
        // ## Reset 
        void Reset();
        // ## Hardware layer trigger function
        void SdpRdmaHardwareLayerExecutionTrigger();
        void SdpHardwareLayerExecutionTrigger();
        // ## Operation
        void SdpLoadPerChannelData(uint32_t proc_num);
        void SdpLoadPerElementData(uint32_t round, uint32_t proc);
        void ExtractRdmaResponsePayloadCore(te_rdma_type eRdDma, nvdla_dma_rd_rsp_t* payload);
        void SdpConfigHls();

        // #  TLM sockets
        // ## CSB target socket
//        void WaitUntilRdmaFifoFreeSizeGreaterThan(uint32_t num);
        void SdpSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);
        void SdpRdmaSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);

        void SendDmaReadRequest(te_rdma_type eRdDma, nvdla_dma_rd_req_t* payload, sc_time& delay);
        void SendDmaWriteRequest(nvdla_dma_wr_req_t* payload, sc_time& delay, bool ack_required = false);
        void SendDmaWriteRequest(uint64_t payload_addr, uint32_t payload_size, uint32_t payload_atom_num, bool ack_required = false);

        // LUT functions
        uint16_t read_lut();
        void write_lut();
};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NV_NVDLA_sdp * NV_NVDLA_sdpCon(sc_module_name module_name);

#endif

