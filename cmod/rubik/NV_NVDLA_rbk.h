// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_rbk.h

#ifndef _NV_NVDLA_RBK_H_
#define _NV_NVDLA_RBK_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 

#include "scsim_common.h"
#include "systemc.h"
#include "NV_NVDLA_rbk_base.h"
#include "rbk_reg_model.h"
// #include "rbkoreconfigclass.h"


#define RUBIK_FEATURE_CUBE_IN_FIFO_DEPTH    1024
#define RUBIK_FEATURE_CUBE_OUT_FIFO_DEPTH   64
#define RUBIK_PLANAR_FIFO_DEPTH             128
#define RUBIK_PLANAR_FIFO_NUM                 32
#define RUBIK_ELEMENT_PER_ATOM_INT8         32
#define RUBIK_ELEMENT_PER_ATOM_INT16        16
#define RUBIK_ELEMENT_PER_ATOM_FP16         16
#define RUBIK_ELEMENT_BYTE_SIZE_INT8        1
#define RUBIK_ELEMENT_BYTE_SIZE_INT16       2
#define RUBIK_ELEMENT_BYTE_SIZE_FP16        2
#define RUBIK_ATOM_CUBE_SIZE                32
#define RUBIK_MEM_TRANSACTION_SIZE          256
#define RUBIK_MEM_PLANAR_TRANSACTION_SIZE   64
#define RUBIK_INTERNAL_BUF_SIZE             2048

SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

class RubikConfig {
    public:
        uint8_t   rbk_rubik_mode_;
        uint8_t   rbk_in_precision_;
        uint8_t   rbk_datain_ram_type_;
        uint16_t  rbk_datain_width_;
        uint16_t  rbk_datain_height_;
        uint16_t  rbk_datain_channel_;
        uint32_t  rbk_dain_addr_high_;
        uint32_t  rbk_dain_addr_low_;
        uint32_t  rbk_dain_line_stride_;
        uint32_t  rbk_dain_surf_stride_;
        uint32_t  rbk_dain_planar_stride_;
        uint8_t   rbk_dataout_ram_type_;
        uint16_t  rbk_dataout_channel_;
        uint32_t  rbk_daout_addr_high_;
        uint32_t  rbk_daout_addr_low_;
        uint32_t  rbk_daout_line_stride_;
        uint32_t  rbk_contract_stride_0_;
        uint32_t  rbk_contract_stride_1_;
        uint32_t  rbk_daout_surf_stride_;
        uint32_t  rbk_daout_planar_stride_;
        uint8_t   rbk_deconv_x_stride_;
        uint8_t   rbk_deconv_y_stride_;
};

class rbk_ack_info {
    public:
        bool    is_mc;
        uint8_t group_id;
};

// Operator for being a SC_FIFO payload
inline std::ostream& operator<<(std::ostream& out, const RubikConfig & obj) {
    return out << "Just to fool compiler" << endl;
}

class NV_NVDLA_rbk:
    public NV_NVDLA_rbk_base,      // ports
    private rbk_reg_model          // register accessing
{
    public:
        SC_HAS_PROCESS(NV_NVDLA_rbk);
        NV_NVDLA_rbk( sc_module_name module_name );
        ~NV_NVDLA_rbk();
        // Target sockets
        // CSB request transport implementation shall in generated code
        void csb2rbk_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        void mcif2rbk_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);
        void cvif2rbk_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);

    private:
        // Variables
        // Payloads
        nvdla_dma_wr_req_t *dma_wr_req_cmd_payload_;
        nvdla_dma_wr_req_t *dma_wr_req_data_payload_;
        nvdla_dma_rd_req_t *dma_rd_req_payload_;

        bool is_there_ongoing_csb2rbk_response_;

        // # Delay
        sc_core::sc_time dma_delay_;
        sc_core::sc_time csb_delay_;
        sc_core::sc_time b_transport_delay_;

        // Events
        sc_event            rbk_kickoff_;
        sc_event            rbk_done_;
        sc_event rbk_mc_ack_;
        sc_event rbk_cv_ack_;
        bool     is_mc_ack_done_;
        bool     is_cv_ack_done_;
        uint8_t             *reorder_array_;
        sc_core::sc_fifo          <uint8_t *>     *rdma_buffer_;
        sc_core::sc_fifo          <uint8_t *>     *wdma_buffer_;
        sc_core::sc_fifo <rbk_ack_info *>     *rbk_ack_fifo_;
        // sc_core::sc_fifo          <RubikConfig *> *rubik_config_fifo_;
        sc_core::sc_fifo          <RubikConfig *> *rubik_config_fifo_r2d_, *rubik_config_fifo_d2w_;

        RubikConfig         *rubik_config_dp_;
        RubikConfig         *rubik_config_wdma_;

        sc_core::sc_fifo          <uint8_t *>     *feature_cube_in_fifo_;
        sc_core::sc_fifo          <uint8_t *>     *feature_cube_out_fifo_;
        sc_core::sc_vector<sc_core::sc_fifo <uint8_t *> >   planar_fifo_;

        // Layer switch related functions
        void RubikConfigEvaluation(CNVDLA_RBK_REGSET *register_group_ptr);
        void RubikHardwareLayerExecutionTrigger();

        // Threads major
        void RubikConsumerThread();
        void RubikRdmaSequenceThread();
        void RubikDataPathThread();
        void RubikWdmaSequenceThread();
        void WriteResponseThreadMc();
        void WriteResponseThreadCv();

        // Threads minor
        void RubikRdmaSequenceContract();
        void RubikRdmaSequenceSplit();
        void RubikRdmaSequenceMerge();
        void RubikDataPathSequenceContract();
        void RubikDataPathSequenceSplit();
        void RubikDataPathSequenceMerge();
        void RubikWdmaSequenceContract();
        void RubikWdmaSequenceSplit();
        void RubikWdmaSequenceMerge();
        void RbkIntrThread();

        void WaitUntilRdmaBufferFreeSizeGreaterThan(uint32_t num);
        void WaitUntilFifoFreeSizeGreaterThan(sc_core::sc_fifo <uint8_t *> *data_fifo, uint32_t num);
        void WaitUntilFifoAvailableSizeGreaterThan(sc_core::sc_fifo <uint8_t *> *data_fifo, uint32_t num);

        // #  Functional functions
        //  Send DMA read request
        void SendDmaReadRequest(nvdla_dma_rd_req_t* payload, sc_time& delay);
        // Send DMA write request
        void SendDmaWriteRequest(sc_core::sc_fifo <uint8_t *> *wdma_fifo, uint64_t payload_addr, uint32_t payload_size, uint32_t payload_atom_num, bool ack_required = false);
        void SendDmaWriteRequest(nvdla_dma_wr_req_t* payload, sc_time& delay, bool ack_required = false);

        //  Extract DMA read response payload
        void ExtractDmaPayload(sc_core::sc_fifo <uint8_t *> *dma_fifo, nvdla_dma_rd_rsp_t* payload);
        void ConfigViolationCheck();

        // ## Reset
        void Reset();
        void RbkSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);
};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NV_NVDLA_rbk * NV_NVDLA_rbkCon(sc_module_name module_name);

#endif

