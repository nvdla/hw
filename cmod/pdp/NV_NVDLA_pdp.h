// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_pdp.h

#ifndef _NV_NVDLA_PDP_H_
#define _NV_NVDLA_PDP_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 

#include "scsim_common.h"
#include "nvdla_dma_wr_req_iface.h"
#include "systemc.h"
#include "nvdla_xx2csb_resp_iface.h"
#include "NV_NVDLA_pdp_base.h"
#include "pdp_reg_model.h"
#include "pdp_rdma_reg_model.h"
#include "NvdlaDataFormatConvertor.h"
#include "nvdla_config.h"

#define SDP2PDP_ELEMENT_NUM     8
#define SDP2PDP_ELEMENT_BIT_WIDTH   16

#define DATA_FORMAT_IS_INT8                 0
#define DATA_FORMAT_IS_INT16                1
#define DATA_FORMAT_IS_FP16                 2
#define ELEMENT_SIZE_INT8                   1
#define ELEMENT_SIZE_INT16                  2
#define ELEMENT_SIZE_FP16                   2
#define ELEMENT_PER_ATOM_INT8               DLA_ATOM_SIZE
#define ELEMENT_PER_ATOM_INT16              (DLA_ATOM_SIZE/2)
#define ELEMENT_PER_ATOM_FP16               (DLA_ATOM_SIZE/2)

#define KERNEL_PER_GROUP_INT8   ELEMENT_PER_ATOM_INT8
#define KERNEL_PER_GROUP_INT16  ELEMENT_PER_ATOM_INT16
#define KERNEL_PER_GROUP_FP16   ELEMENT_PER_ATOM_FP16

#define TAG_CMD 0
#define TAG_DATA 1

#define PDP_RDMA_BUFFER_TOTAL_SIZE    32*8192
#define PDP_RDMA_BUFFER_ENTRY_SIZE    DLA_ATOM_SIZE
#define PDP_RDMA_BUFFER_ENTRY_NUM     PDP_RDMA_BUFFER_TOTAL_SIZE/PDP_RDMA_BUFFER_ENTRY_SIZE

#define SDP2PDP_PAYLOAD_SIZE    32
#define SDP2PDP_PAYLOAD_ELEMENT_NUM   SDP_MAX_THROUGHPUT
#define SDP2PDP_FIFO_ENTRY_NUM  16 // DLA_ATOM_SIZE/SDP2PDP_PAYLOAD_SIZE

#define PDP_LINE_BUFFER_INT8_ELEMENT_NUM    8*1024
#define PDP_LINE_BUFFER_INT16_ELEMENT_NUM   4*1024
#define PDP_LINE_BUFFER_FP16_ELEMENT_NUM    4*1024
#define PDP_LINE_BUFFER_SIZE                (PDP_LINE_BUFFER_INT8_ELEMENT_NUM*2)     // Size in Byte
#define PDP_LINE_BUFFER_ENTRY_NUM           (PDP_LINE_BUFFER_SIZE/(DLA_ATOM_SIZE*2)) // The number of bytes consumed by one atom is DLA_ATOM_SIZE*2

#define POOLING_FLYING_MODE_ON_FLYING   NVDLA_PDP_D_OPERATION_MODE_CFG_0_FLYING_MODE_ON_FLYING
#define POOLING_FLYING_MODE_OFF_FLYING  NVDLA_PDP_D_OPERATION_MODE_CFG_0_FLYING_MODE_OFF_FLYING
#define POOLING_METHOD_AVE              NVDLA_PDP_D_OPERATION_MODE_CFG_0_POOLING_METHOD_POOLING_METHOD_AVERAGE
#define POOLING_METHOD_MAX              NVDLA_PDP_D_OPERATION_MODE_CFG_0_POOLING_METHOD_POOLING_METHOD_MAX
#define POOLING_METHOD_MIN              NVDLA_PDP_D_OPERATION_MODE_CFG_0_POOLING_METHOD_POOLING_METHOD_MIN

#define PDP_MAX_PADDING_SIZE    7
#define LOW_ADDRESS_SHIFT               (NVDLA_PDP_RDMA_D_SRC_BASE_ADDR_LOW_0_SRC_BASE_ADDR_LOW_SHIFT)

// class NvdlaDataFormatConvertor;
SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)
// class container_payload_wrapper {
// public:
//     uint8_t *data;
//     uint8_t data_num;
// };
// 
// std::ostream& operator<<(std::ostream& out, const container_payload_wrapper& obj) {
//         return out << "Just to fool compiler" << endl;
// }
// 
// std::ostream& operator<<(std::ostream& out, const nvdla_container_number_8_bit_width_16_t& obj) {
//         return out << "Just to fool compiler" << endl;
// }
class pdp_ack_info {
    public:
        bool    is_mc;
        uint8_t group_id;
};
class NV_NVDLA_pdp:
    public NV_NVDLA_pdp_base,   // ports
    private pdp_reg_model,      // pdp register accessing
    private pdp_rdma_reg_model  // pdp_rdma
{
    public:
        SC_HAS_PROCESS(NV_NVDLA_pdp);
        NV_NVDLA_pdp( sc_module_name module_name );
        ~NV_NVDLA_pdp();
        // CSB request transport implementation shall in generated code
        void csb2pdp_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        void csb2pdp_rdma_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        void sdp2pdp_b_transport(int ID, nvdla_sdp2pdp_t* payload, sc_core::sc_time& delay);
        void mcif2pdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);
        void cvif2pdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);
        // void pdp2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay) {NV_NVDLA_pdp_base::pdp2csb_resp_b_transport(payload, delay);}
        // void pdp_rdma2csb_resp_b_transport(nvdla_xx2csb_resp_t* payload, sc_time& delay) {NV_NVDLA_pdp_base::pdp2csb_resp_b_transport(payload, delay);}

    private:
        // Payloads
        nvdla_dma_wr_req_t *dma_wr_req_cmd_payload_;
        nvdla_dma_wr_req_t *dma_wr_req_data_payload_;
        nvdla_dma_rd_req_t *dma_rd_req_payload_;

        // Delay
        sc_core::sc_time dma_delay_;
        sc_core::sc_time csb_delay_;
        sc_core::sc_time b_transport_delay_;

        // Events
        // PDP config evaluation is done
        sc_event event_pdp_config_evaluation_done;
        // Receiving data from sdp
        sc_event event_got_conv_data;
        // Functional logic have fetched data from RDMA buffer
        sc_event event_functional_logic_got_data;
        sc_event rdma_read_event;
        sc_event rdma_write_event;
        // For PDP hardware layer kickoff and end
        sc_event pdp_rdma_kickoff_;
        sc_event pdp_rdma_done_;
        sc_event pdp_kickoff_;
        sc_event pdp_done_;
        sc_core::sc_fifo<uint8_t> *line_buffer_usage_free_[PDP_LINE_BUFFER_ENTRY_NUM];
        sc_core::sc_fifo<uint8_t> *line_buffer_ready_[PDP_LINE_BUFFER_ENTRY_NUM];

        // Evaluated configs based on register config 

        uint32_t    pdp_rdma_operation_mode_;
        uint32_t    pdp_operation_mode_;
        bool        pdp_ready_to_receive_data_;

        // Temperal and intermedia signals
        bool        is_there_ongoing_csb2pdp_response_;
        bool        is_there_ongoing_csb2pdp_rdma_response_;

        // Variables needs to be added to register
        // uint8_t   pdp_rdma_kernel_stride_width_;
        // uint8_t   pdp_rdma_kernel_width_;
        // uint8_t   pdp_rdma_pad_width_;
        uint32_t  pdp_cvt_offset_input_;
        uint16_t  pdp_cvt_scale_input_;
        uint8_t   pdp_cvt_truncate_lsb_input_;
        uint8_t   pdp_cvt_truncate_msb_input_;

        sc_core::sc_fifo    <uint8_t *> *sdp2pdp_fifo_;
        sc_core::sc_fifo          <uint8_t *> *rdma_buffer_;
        sc_core::sc_fifo          <uint8_t *> *wdma_buffer_;
        sc_core::sc_fifo <pdp_ack_info *>     *pdp_ack_fifo_;

        sc_event pdp_mc_ack_;
        sc_event pdp_cv_ack_;
        bool     is_mc_ack_done_;
        bool     is_cv_ack_done_;

        // RDMA buffer index
        uint32_t    rdma_buffer_write_idx_;
        uint32_t    rdma_buffer_read_idx_;
        
        // WDMA buffer index
        uint32_t    wdma_buffer_write_idx_;
        uint32_t    wdma_buffer_read_idx_;
        
        // Data buffers
        // # Shared line buffer, each entry stores one int8 element
        // In HW, its size is 8KB. In CMOD, it's 16KB. The num of entries are same as HW, however each entry size is 16B, not 8B for precision in arithmetic.
        uint16_t    line_buffer_[PDP_LINE_BUFFER_INT8_ELEMENT_NUM]; 
        uint16_t    line_operation_buffer_[8*ELEMENT_PER_ATOM_INT8]; 

        // Function declaration 
        // # Threads
        void PdpRdmaConsumerThread();
        void PdpConsumerThread();
        void PoolingStage0SequenceThread ();
        void PoolingStage1SequenceThread ();
        void PdpRdmaSequenceThread ();
        void PdpWdmaSequenceThread ();
        void PdpIntrThread();
        void WriteResponseThreadMc();
        void WriteResponseThreadCv();
        // # Config evaluation
        void PdpRdmaConfigEvaluation(CNVDLA_PDP_RDMA_REGSET *register_group_ptr);
        void PdpConfigEvaluation(CNVDLA_PDP_REGSET *register_group_ptr);
        // # Hardware layer execution trigger
        void PdpRdmaHardwareLayerExecutionTrigger();
        void PdpHardwareLayerExecutionTrigger();
        // # Operation
        void OperationModePdpRdmaCommon();
        void OperationModePdpCommon();
        void RdmaSequenceCommon(uint64_t src_base_addr, uint32_t cube_in_width);
        // void RdmaSequence8Bto8B();
        // void RdmaSequence16Bto16B();
        // void RdmaSequence8Bto16B();
        void RdmaSequence16Bto8B();
        // Pooling function
        void PoolingStage0SequenceCommon(uint32_t cube_in_width, uint32_t pad_left, uint32_t pad_right, uint32_t acc_subcube_out_width, uint32_t cube_out_width);
        void PoolingStage0Sequence8Bto8B();
        void PoolingStage0Sequence16Bto16B();

        void PoolingStage1SequenceCommon(uint32_t cube_out_width, uint32_t acc_subcube_out_width, uint32_t pad_left, uint32_t pad_right, uint32_t cube_in_width);
        void PoolingStage1Sequence8Bto8B();
        void PoolingStage1Sequence16Bto16B();

        // void WdmaSequenceCommon();
        void WdmaSequenceCommon(uint64_t dst_base_addr, uint32_t cube_out_width, bool split_last);
        // #  Functional functions
        //  Send DMA read request
        void SendDmaReadRequest(nvdla_dma_rd_req_t* payload, sc_time& delay);
        // void SendDmaReadRequest(nvdla_dma_rd_req_t* payload, sc_time& delay, uint8_t src_ram_type);
        //  Extract DMA read response payload
        void ExtractDmaPayload(nvdla_dma_rd_rsp_t* payload);
        // Send DMA write request
        void SendDmaWriteRequest(nvdla_dma_wr_req_t* payload, sc_time& delay, bool ack_required = false);
        void SendDmaWriteRequest(uint64_t payload_addr, uint32_t payload_size, uint32_t payload_atom_num, bool ack_required = false);
        // template <typename T>
        // void FetchInputData (uint8_t * atomic_cube);
        uint8_t * FetchInputData ();
        template <typename T_IN, typename T_OUT, typename T_PAD>
        void PoolingStage0Calc (T_IN * atomic_data_in, T_OUT * line_buffer_ptr, uint32_t cube_out_width_idx, uint32_t cube_out_height_idx, uint32_t surface, uint32_t cube_in_height, uint32_t kernel_height_iter,  uint32_t kernel_height, uint32_t cube_in_height_iter, T_PAD * padding_value_ptr, uint8_t element_num, uint32_t surface_num, uint32_t acc_subcube_out_width, uint32_t cube_out_width);
        template <typename T_OUT, typename T_IN>
        void PoolingStage1Calc (T_OUT * atomic_data_out, T_IN * line_buffer_ptr, uint32_t width, uint32_t height, uint32_t surface, uint8_t element_num, uint32_t surface_num, uint32_t acc_subcube_out_width, uint32_t cube_out_width, uint32_t pad_left, uint32_t pad_right, uint32_t cube_in_width);
        template <typename T_IN, typename T_OUT, typename T_PAD>
        void LineOperation (T_IN * atomic_data_in, T_OUT * line_buffer_ptr, uint32_t kernel_width_iter, uint32_t kernel_width, uint32_t cube_in_width_iter, uint32_t cube_in_width, T_PAD * padding_value_ptr, uint8_t element_num, uint32_t pad_left);
        // ## Reset 
        void Reset();
        void WaitUntilRdmaBufferFreeSizeGreaterThan(uint32_t num);
        void WaitUntilRdmaBufferAvailableSizeGreaterThan(uint32_t num);
        void WaitUntilWdmaBufferFreeSizeGreaterThan(uint32_t num);
        void WaitUntilWdmaBufferAvailableSizeGreaterThan(uint32_t num);
        void PdpSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);
        void PdpRdmaSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);
        bool IsFirstElement(uint32_t pad_left, uint32_t width_iter, uint32_t height_iter, uint32_t kernel_width_iter, uint32_t kernel_height_iter);
        bool IsLastElement(uint32_t cube_in_width, uint32_t pad_left, uint32_t width_iter, uint32_t height_iter, uint32_t kernel_width_iter, uint32_t kernel_height_iter);
        bool IsContributeToANewLine(uint32_t cube_in_height_iter, uint32_t kernel_height_iter);
        template <typename T_IN, typename T_OUT>
        void int_sign_extend(T_IN original_value, uint8_t sign_bit_idx, uint8_t extended_bit_num, T_OUT *return_value);
        void reset_stats_regs();
        void update_stats_regs();

        uint32_t    nan_input_num;
        uint32_t    inf_input_num;
        uint32_t    nan_output_num;
};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NV_NVDLA_pdp * NV_NVDLA_pdpCon(sc_module_name module_name);

#endif

