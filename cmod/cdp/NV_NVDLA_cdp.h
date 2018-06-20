// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cdp.h

#ifndef _NV_NVDLA_CDP_H_
#define _NV_NVDLA_CDP_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 

#include "scsim_common.h"

#include "nvdla_dma_wr_req_iface.h"
#include "nvdla_xx2csb_resp_iface.h"
#include "NV_NVDLA_cdp_base.h"
#include "cdp_reg_model.h"
#include "cdp_rdma_reg_model.h"
// #include "NvdlaLut.h"
#include "systemc.h"
#include "nvdla_config.h"

#define CDP_RDMA_SIZE                       2048
#define CDP_PRE_CALC_BUFFER_ATOM_NUM        8
#define DATA_FORMAT_IS_INT8                 0
#define DATA_FORMAT_IS_INT16                1
#define DATA_FORMAT_IS_FP16                 2
#define ELEMENT_PER_GROUP_INT8              (DLA_ATOM_SIZE)
#define ELEMENT_PER_GROUP_INT16             (DLA_ATOM_SIZE/2)
#define ELEMENT_PER_GROUP_FP16              (DLA_ATOM_SIZE/2)

#define TAG_CMD 0
#define TAG_DATA 1

#define ATOM_CUBE_SIZE                      DLA_ATOM_SIZE

#define LOW_ADDRESS_SHIFT               (NVDLA_CDP_RDMA_D_SRC_BASE_ADDR_LOW_0_SRC_BASE_ADDR_LOW_SHIFT)

// using half_float::half;
class NvdlaDataFormatConvertor;

SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

class CdpConfig {
    public:
        uint16_t  cdp_rdma_width_;
        uint16_t  cdp_rdma_height_;
        uint16_t  cdp_rdma_channel_;

};

class cdp_ack_info {
    public:
        bool    is_mc;
        uint8_t group_id;
};

class NV_NVDLA_cdp:
    public  NV_NVDLA_cdp_base,  // ports
    private cdp_reg_model,      // cdp data path and write dma register accessing
    private cdp_rdma_reg_model  // cdp rdma register accessing
{
    public:
        SC_HAS_PROCESS(NV_NVDLA_cdp);
        NV_NVDLA_cdp( sc_module_name module_name );
        ~NV_NVDLA_cdp();
        // Overload for pure virtual TLM target functions
        // # CSB request transport implementation shall in generated code
        void csb2cdp_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        void csb2cdp_rdma_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // # MC/CV_SRAM read response
        void mcif2cdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);
        void cvif2cdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t*, sc_core::sc_time&);

        // Port has no flow: bdma2glb_done_intr
        sc_vector< sc_out<bool> > cdp2glb_done_intr;

    private:
        sc_core::sc_fifo          <CdpConfig *> *cdp_fifo_cfg_dp_, *cdp_fifo_cfg_wdma_;
        // Variables
        bool is_there_ongoing_csb2cdp_response_;
        bool is_there_ongoing_csb2cdp_rdma_response_;

        // Payloads
        // # DMA read request
        // # DMA write request
        nvdla_dma_wr_req_t *dma_wr_req_cmd_payload_;
        nvdla_dma_wr_req_t *dma_wr_req_data_payload_;
        nvdla_dma_rd_req_t *dma_rd_req_payload_;

        // Delay
        sc_core::sc_time dma_delay_;
        sc_core::sc_time csb_delay_;
        sc_core::sc_time b_transport_delay_;

        // Events
        sc_event cdp_rdma_kickoff_;
        sc_event cdp_kickoff_;
        sc_event cdp_rdma_done_;
        sc_event cdp_done_;
        sc_event cdp_mc_ack_;
        sc_event cdp_cv_ack_;
        bool     is_mc_ack_done_;
        bool     is_cv_ack_done_;

        // FIFOs
        // # Data path local buffer
        int8_t                     ***dp_calc_buffer;    // Datapath calc buffer
        int8_t                     *post_calc_buffer;
        sc_core::sc_fifo <int8_t *>      *rdma_fifo_;
        sc_core::sc_fifo <int16_t *>     *hls_out_fifo_;
        sc_core::sc_fifo <cdp_ack_info *>     *cdp_ack_fifo_;

        sc_core::sc_fifo <uint32_t>       *rdma_atom_num_fifo_;   // Used by DataProcessor
        sc_core::sc_fifo <uint32_t>       *hls_atom_num_fifo_;    // Used by WDMA

        // LUT table
        int16_t density_lut[257];
        int16_t raw_lut[65];

        // Operation mode
        uint32_t    cdp_rdma_operation_mode_;
        uint32_t    cdp_operation_mode_;

        // Normalization output (4 elements)
        int16_t    *normalz_out;
        int8_t      *normalz_out_int8;

        // Function declaration 
        // # Threads
        void CdpRdmaConsumerThread();
        void CdpConsumerThread();
        void WriteResponseThreadMc();
        void WriteResponseThreadCv();
        // ## RDMA thread
        void CdpRdmaReadSequenceThread();
        // ## Data path operation thread
        void CdpDataPathOperationSequenceThread();
        // ## WDMA thread
        void CdpWdmaWriteSequenceThread();
        // # Hardware layer trigger function
        void CdpRdmaHardwareLayerExecutionTrigger();
        void CdpHardwareLayerExecutionTrigger();
        void CdpIntrThread();
        void reset_stats_regs();
        void update_stats_regs();

        // RDMA sequence
        //void CdpRdmaSequence(uint64_t base_addr_sequencer, uint64_t base_addr_dma, uint32_t line_stride, bool is_sequencer_line_packed, bool is_dst_line_packed);
        void CdpRdmaSequence_0();
        void CdpRdmaReadphileSequence();
        void CdpRdmaWritephileSequence();
        void CdpRdmaOrdinarySequence();
        // Data path sequence
        void CdpDataPathSequence();
        void CdpDataPathReadphileSequence();
        void CdpDataPathWritephileSequence();
        void CdpDataPathOrdinarySequence();
        // WDMA sequence
        void CdpWdmaSequence();
        void CdpWdmaReadphileSequence();
        void CdpWdmaWritephileSequence();
        void CdpWdmaOrdinarySequence();
        // #  Functional functions
        void Reset();

        void WaitUntilRdmaFifoFreeSizeGreaterThan(uint32_t num);
        void WaitUntilRdmaFifoAvailableSizeGreaterThan(uint32_t num);
        void WaitUntilWdmaBufferFreeSizeGreaterThan(uint32_t num);
        void WaitUntilWdmaBufferAvailableSizeGreaterThan(uint32_t num);

        void SendDmaReadRequest(nvdla_dma_rd_req_t* payload, sc_time& delay, uint8_t src_ram_type);
        void ExtractRdmaResponsePayload(nvdla_dma_rd_rsp_t* payload);
        void SendDmaWriteRequest(nvdla_dma_wr_req_t* payload, sc_time& delay, uint8_t dst_ram_type, bool ack_required = false);
        void CdpSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);
        void CdpRdmaSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);

        // LUT functions
        uint16_t read_lut();
        void     write_lut();
        uint16_t read_lut(uint32_t lut_table_idx, uint32_t addr);
        void     write_lut(uint32_t lut_table_idx, uint32_t addr, uint32_t value);
        void     lookup_lut(int16_t *data_in, int paralllel_num);
        void     lookup_lut_int8(int8_t *data_in, int paralllel_num);
        int64_t  convert(int64_t value, int shift, int bits, bool is_signed);

        uint32_t    lut_o_flow;
        uint32_t    lut_u_flow;
        uint32_t    lut_le_hit;
        uint32_t    lut_lo_hit;
        uint32_t    lut_hybrid_hit;
        uint32_t    o_cvt_o_flow;
        uint32_t    nan_input_num;
        uint32_t    inf_input_num;
        uint32_t    nan_output_num;

        //txn counter
        uint32_t    txn_r;
        uint32_t    txn_w; 

	uint32_t dbg_atom_idx = 0;


};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NV_NVDLA_cdp * NV_NVDLA_cdpCon(sc_module_name module_name);

#endif

