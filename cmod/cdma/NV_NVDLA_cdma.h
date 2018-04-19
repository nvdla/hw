// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cdma.h

#ifndef _NV_NVDLA_CDMA_H_
#define _NV_NVDLA_CDMA_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 
#include "scsim_common.h"
#include "nvdla_xx2csb_resp_iface.h"
#include "NV_NVDLA_cdma_base.h"
#include "cdma_reg_model.h"
#include "systemc.h"
#include "nvdla_config.h"
#include "cdma_hls_wrapper.h"

#define MEM_BUS_WIDTH               (max(max(NVDLA_PRIMARY_MEMIF_WIDTH/8, NVDLA_SECONDARY_MEMIF_WIDTH/8), NVDLA_MEMORY_ATOMIC_SIZE*ELEMENT_SIZE_INT8))
#define MAX_MEM_TRANSACTION_NUM     8

#define ELEMENT_SIZE_INT8           1
#define ELEMENT_SIZE_INT16          2
#define ELEMENT_SIZE_FP16           2

#define ATOM_SIZE_INT8              (NVDLA_MEMORY_ATOMIC_SIZE*ELEMENT_SIZE_INT8)
#define ATOM_SIZE_INT16             (NVDLA_MEMORY_ATOMIC_SIZE*ELEMENT_SIZE_INT16)
#define ATOM_SIZE_FP16              (NVDLA_MEMORY_ATOMIC_SIZE*ELEMENT_SIZE_FP16)

#define CBUF_ENTRY_NUM              (NVDLA_CBUF_BANK_NUMBER*NVDLA_CBUF_BANK_DEPTH)
#define CBUF_WMB_BANK_IDX           15

#define RAM_ID_MC                   1
#define RAM_ID_CV                   0

#define CDMA_WEIGHT_DATA            0
#define CDMA_WMB_DATA               1
#define CDMA_WGS_DATA               2
#define CDMA_FEATURE_DATA           3
#define CDMA_MEAN_DATA              4

#define READ_WINO_BUF_WIDTH         (4*8)    //8 is max of stride_x

#define INPUT_DATA_FORMAT_DC        0
#define INPUT_DATA_FORMAT_IMAGE     1
#define INPUT_DATA_FORMAT_WINO      2

#define CDMA_LOCAL_BUFFER_SIZE      256

SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

struct cdma_wt_req_t {
    nvdla_dma_rd_req_t pd;
};

struct cdma_wt_info_t {
    int cdma_source;
    uint32_t payload_size;  // In unit of 32B
};

class NV_NVDLA_cdma:
    public  NV_NVDLA_cdma_base, // ports
    private cdma_reg_model      // cdma data path and write dma register accessing
{
    public:
        SC_HAS_PROCESS(NV_NVDLA_cdma);
        NV_NVDLA_cdma( sc_module_name module_name );
        ~NV_NVDLA_cdma();
        // Overload for pure virtual TLM target functions
        // # CSB request transport implementation shall in generated code
        void csb2cdma_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // # MC/CV_SRAM read response
        void mcif2cdma_dat_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);
        void mcif2cdma_wt_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);
        void cvif2cdma_dat_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);
        void cvif2cdma_wt_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);
        // # CSC-CDMA status update
        void dat_up_sc2cdma_b_transport(int ID, nvdla_dat_info_update_t* payload, sc_time& delay);
        void wt_up_sc2cdma_b_transport(int ID, nvdla_wt_info_update_t* payload, sc_time& delay);
        void cdma_wt_dma_arbiter_source_id_b_transport(int ID, int source_id, sc_time& delay);

    private:
        // Variables
        bool sc_dt_kick_off;
        bool sc_wt_kick_off;
        bool dat_first_layer;
        bool wt_first_layer;
        bool wmb_first_layer;
        bool wgs_first_layer;
        bool is_there_ongoing_csb2cdma_response_;
        uint32_t *wgs_buffer_;
        // Payloads
        nvdla_dma_rd_req_t *dma_act_rd_req_payload_;
        nvdla_dma_rd_req_t *dma_wt_rd_req_payload_;
        nvdla_dma_rd_req_t *dma_wgs_rd_req_payload_;
        nvdla_dma_rd_req_t *dma_wmb_rd_req_payload_;

        nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t *cdma2cbuf_data_payload_;
        nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t cdma2buf_wmb_wr_payload;    // cdma2buf_wt_wr_payload is defined in cdma_base class

        nvdla_dat_info_update_t *data2sc_data_update_payload_;
        nvdla_wt_info_update_t *data2sc_weight_update_payload_;

        // Delay
        sc_core::sc_time dma_delay_;
        sc_core::sc_time csb_delay_;
        sc_core::sc_time b_transport_delay_;

        // Events
        sc_event cdma_kickoff_;
        sc_event wgs2wt_update_;
        // Sequence controller and DMA fetcher communication on CBuffer usage
        sc_event sc_updated_cbuf_usage_data_;
        sc_event sc_updated_cbuf_usage_weight_;
        sc_event sc_updated_cbuf_usage_wmb_;
        // Done signals are not DMA mapped
        sc_event cdma_data_fetch_done_;
        sc_event cdma_mean_fetch_done_;
        sc_event cdma_weight_fetch_done_;
        sc_event cdma_wgs_fetch_done_;
        sc_event cdma_wmb_fetch_done_;

        sc_core::sc_fifo <bool>      *cdma_data_fetch_done_fifo_;
        sc_core::sc_fifo <bool>      *cdma_mean_fetch_done_fifo_;
        sc_core::sc_fifo <bool>      *cdma_weight_fetch_done_fifo_;
        sc_core::sc_fifo <bool>      *cdma_wgs_fetch_done_fifo_;
        sc_core::sc_fifo <bool>      *cdma_wmb_fetch_done_fifo_;
        sc_core::sc_fifo <bool>      *cdma_wgs2wt_sync_fifo_;
        sc_core::sc_fifo <bool>      *wgs2wt_sync_fifo_;
        sc_core::sc_fifo <bool>      *cdma_wgs_fetch_done2wmb_fifo_;
        sc_core::sc_fifo <bool>      *cdma_wmb_fetch_done2wt_fifo_;
        sc_core::sc_fifo <bool>      *wino_req2resp_sync_fifo_;

        // arbiter info between wmb/wgs/wt from RTL.
        sc_core::sc_fifo <int>       *wt_dma_rtl_source_id_fifo_;
        // CDMA requests from weight/wgs/wmb
        sc_core::sc_fifo <cdma_wt_req_t*>    *cdma_wt_req_fifo_;
        sc_core::sc_fifo <cdma_wt_req_t*>    *cdma_wmb_req_fifo_;
        sc_core::sc_fifo <cdma_wt_req_t*>    *cdma_wgs_req_fifo_;
        sc_core::sc_fifo <cdma_wt_info_t*>   *cdma_wt_info_fifo_;
        uint32_t                     wt_response_cdma_source;
        uint32_t                     wt_response_payload_size;
        //sc_core::sc_fifo <bool>              *wt2wmb_kg_sync_fifo_;
        //sc_core::sc_fifo <bool>              *wmb2wt_kg_sync_fifo_;
        sc_core::sc_fifo <int32_t>              *wmb2sc_up_fifo_;
        sc_core::sc_fifo <int32_t>              *wt2sc_up_kernel_fifo_;
        sc_core::sc_fifo <int32_t>              *wt2sc_up_entry_fifo_;

        // uint32_t    slice_idx_fetched_[2];
        uint32_t    slice_idx_sequence_control_;
        sc_core::sc_mutex slice_idx_sequence_control_mutex_;
        uint32_t    entry_idx_cdma_;
        uint32_t    entry_idx_csc_;

        int32_t     slice_idx_available_;        // update by CDMA
        int32_t     slice_idx_free_;             // update by CSC
        // sc_core::sc_mutex slice_idx_sequence_control_mutex_[2];
        // Auto wrap around is needed, those variables must be unsigned int
        int32_t     data_entry_idx_working_;        // update by CDMA
        int32_t     data_entry_idx_planed_;         // update by CDMA
        int32_t     data_entry_idx_free_;           // update by CSC

        int32_t     weight_entry_idx_planed_;       // update by CDMA
        int32_t     weight_entry_idx_working_;      // update by CDMA
        int32_t     weight_entry_idx_free_;         // update by CSC
        // Byte idx is actually 32 byte aligned
        int32_t     weight_byte_idx_planed_;        // update by CDMA
        int32_t     wmb_entry_idx_planed_;          // update by CDMA
        int32_t     wmb_entry_idx_working_;         // update by CDMA
        int32_t     wmb_entry_idx_free_;            // update by CSC
        int32_t     wmb_byte_idx_planed_;           // update by CDMA
        int32_t     wmb_entries_fetched_, prev_wmb_entries_fetched_;

        uint32_t    data_nan_num_perlayer_;
        uint32_t    weight_nan_num_perlayer_; 
        uint32_t    data_inf_num_perlayer_;
        uint32_t    weight_inf_num_perlayer_; 

        // FIFOs
        // # DMA buffers
        sc_core::sc_fifo <uint8_t>      *cdma_act_share_buffer_;
        sc_core::sc_fifo <uint8_t*>     *act_data_read_rsp_fifo_;
        sc_core::sc_fifo <uint8_t*>     *mean_data_read_rsp_fifo_;
        sc_core::sc_fifo <uint8_t*>     *weight_read_rsp_fifo_;
        sc_core::sc_fifo <uint8_t*>     *wgs_read_rsp_fifo_;
        sc_core::sc_fifo <uint8_t*>     *wmb_read_rsp_fifo_;

        sc_core::sc_fifo <uint8_t*>     *wino_fetch_data_fifo_[4];

        // Variables to record info of previous layer
        uint32_t    cdma_req_prev_conv_mode_;
        uint8_t     cdma_req_prev_skip_data_rls_;
        uint8_t     cdma_req_prev_data_bank_;
        uint8_t     cdma_req_prev_weight_bank_;
        uint8_t     cdma_req_prev_input_data_format_;

        uint32_t    cdma_resp_prev_conv_mode_;
        uint8_t     cdma_resp_prev_skip_data_rls_;
        uint8_t     cdma_resp_prev_data_bank_;
        uint8_t     cdma_resp_prev_weight_bank_;
        uint8_t     cdma_resp_prev_input_data_format_;

        uint32_t    wt_req_cdma_prev_conv_mode_;
        uint8_t     wt_req_cdma_prev_skip_weight_rls_;
        uint8_t     wt_req_cdma_prev_data_bank_;
        uint8_t     wt_req_cdma_prev_weight_bank_;
        uint8_t     wt_req_prev_input_data_format_;
        uint32_t    wt_resp_cdma_prev_conv_mode_;
        uint8_t     wt_resp_cdma_prev_skip_weight_rls_;
        uint8_t     wt_resp_cdma_prev_data_bank_;
        uint8_t     wt_resp_cdma_prev_weight_bank_;
        uint8_t     wt_resp_prev_input_data_format_;

        uint32_t    wgs_req_cdma_prev_conv_mode_;
        uint8_t     wgs_req_cdma_prev_skip_weight_rls_;
        uint8_t     wgs_req_cdma_prev_data_bank_;
        uint8_t     wgs_req_cdma_prev_weight_bank_;
        uint8_t     wgs_req_prev_input_data_format_;
        uint32_t    wgs_resp_cdma_prev_conv_mode_;
        uint8_t     wgs_resp_cdma_prev_skip_weight_rls_;
        uint8_t     wgs_resp_cdma_prev_data_bank_;
        uint8_t     wgs_resp_cdma_prev_weight_bank_;
        uint8_t     wgs_resp_prev_input_data_format_;

        uint32_t    wmb_req_cdma_prev_conv_mode_;
        uint8_t     wmb_req_cdma_prev_skip_weight_rls_;
        uint8_t     wmb_req_cdma_prev_data_bank_;
        uint8_t     wmb_req_cdma_prev_weight_bank_;
        uint8_t     wmb_req_prev_input_data_format_;
        uint8_t     wmb_req_cdma_prev_weight_format_;
        uint32_t    wmb_resp_cdma_prev_conv_mode_;
        uint8_t     wmb_resp_cdma_prev_skip_weight_rls_;
        uint8_t     wmb_resp_cdma_prev_data_bank_;
        uint8_t     wmb_resp_cdma_prev_weight_bank_;
        uint8_t     wmb_resp_prev_input_data_format_;

        // Function declaration 
        // # Threads
        void CdmaConsumerThread();
        // # Hardware layer trigger function
        void CdmaHardwareLayerExecutionTrigger();
        // ## DMA sequences
        void ActDataReadRequestSequenceThread();
        void ActDataReadResponseSequenceThread();
        void WeightReadRequestSequenceThread();
        void WeightReadResponseSequenceThread();
        void WGSReadRequestSequenceThread();
        void WGSReadResponseSequenceThread();
        void WMBReadRequestSequenceThread();
        void WMBReadResponseSequenceThread();
        void WtReadRequestThread();
        void Cdma2ScUpdateThread();
        // #  Functional functions
        void Reset();
        void CdmaSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);

        void SendActDmaReadRequest(nvdla_dma_rd_req_t* payload, uint8_t cmda_source, sc_time& delay);
        void SendWeightDmaReadRequestRTL(nvdla_dma_rd_req_t* payload, uint8_t cdma_source, sc_time& delay);
        void SendWeightDmaReadRequest(nvdla_dma_rd_req_t* payload, uint8_t cdma_source, sc_time& delay);

        void ActDmaResponseHandler(nvdla_dma_rd_rsp_t* payload);
        void WeightDmaResponseHandler(nvdla_dma_rd_rsp_t* payload);
        void WaitUntilCBufferHasEnoughFreeDataEntry();
        void WaitUntilCBufferHasEnoughFreeWeightEntry();
        void WaitUntilCBufferHasEnoughFreeWmbEntry();
        void WaitUntilDataEntryPlanedIndexEqualEntryFreeIndex();
        void WaitUntilWeightEntryPlanedIndexEqualEntryFreeIndex();
        void WaitUntilWmbEntryPlanedIndexEqualEntryFreeIndex();

        void WaitUntilSCDataKickOff();
        void WaitUntilSCWeightKickOff();

        // Sequencers
        // Direct convolution sequencer
        void DirectConvDataRequestSequencerCommon();
        void DirectConvDataResponseSequencerCommon();
        void DirectConvWeightRequestSequencerCommon();
        void DirectConvWeightResponseSequencerCommon();
        void ConvWGSRequestSequencerCommon();
        void ConvWGSResponseSequencerCommon();
        void ConvWMBRequestSequencerCommon();
        void ConvWMBResponseSequencerCommon();
        void WinoConvDataRequestSequencerCommon();
        void WinoConvDataResponseSequencerCommon();
        void ImageConvDataRequestSequencerCommon();
        void ImageConvDataResponseSequencerCommon();
        uint8_t cdma_planar_num(uint16_t pixel_format);
        uint8_t cdma_bytes_per_pixel(uint16_t pixel_format);
        uint8_t cdma_bytes_per_pixel_planar0(uint16_t pixel_format);
        uint8_t cdma_bytes_per_pixel_planar1(uint16_t pixel_format);
        uint8_t cdma_converted_bytes_per_pixel(uint16_t pixel_format, uint32_t proc_precision);
        uint8_t packed_format(uint16_t pixel_format);
        uint8_t cdma_element_num(uint16_t pixel_format);
        bool isNaN(uint16_t in_fp16);
        bool isInf(uint16_t in_fp16);
        void WriteOneEntryToCbuf(uint8_t* ptr, uint32_t cbuf_entry_addr, uint32_t super_atom_size, uint32_t super_atom_num);
        void hls_convertor(int16_t* in_ptr, uint8_t input_data_type, int16_t offset, int16_t scale, uint8_t truncate, uint32_t in_precision, uint32_t out_precision, int32_t* out_ptr);
        void process_one_element_8(int8_t pixel_8, uint32_t pixel_idx, uint8_t element_num, uint8_t i, bool cvt_en, bool convert_8to16, uint8_t* pad_buffer_8, uint16_t* pad_buffer_16, int16_t cvt_mean, int16_t cvt_scale, uint8_t cvt_truncate, uint32_t in_precision, uint32_t proc_precision);
        void process_one_element_16(int16_t pixel_16, uint32_t pixel_idx, uint8_t element_num, uint8_t i, int8_t input_data_type, bool cvt_en, bool convert_16to8, uint8_t* pad_buffer_8, uint16_t* pad_buffer_16, int16_t cvt_mean, int16_t cvt_scale, uint8_t cvt_truncate, uint32_t in_precision, uint32_t proc_precision);
        void countNaNinData(uint8_t *read_data_ptr, uint32_t *data_nan_num_perlayer_);
        void countInfinData(uint8_t *read_data_ptr, uint32_t *data_inf_num_perlayer_);
};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NV_NVDLA_cdma * NV_NVDLA_cdmaCon(sc_module_name module_name);

#endif

