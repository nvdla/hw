// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_csc.h

#ifndef _NV_NVDLA_CSC_H_
#define _NV_NVDLA_CSC_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 
#include "scsim_common.h"
#include "nvdla_sc2mac_data_if_iface.h"
// #include "nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_iface.h"
#include "NV_NVDLA_csc_base.h"
#include "csc_reg_model.h"
#include "csc_hls_wrapper.h"
#include "nvdla_config.h"

#define MEM_BUS_WIDTH               (max(max(NVDLA_PRIMARY_MEMIF_WIDTH/8, NVDLA_SECONDARY_MEMIF_WIDTH/8), NVDLA_MEMORY_ATOMIC_SIZE*ELEMENT_SIZE_INT8))

#define ELEMENT_SIZE_INT8                   1
#define ELEMENT_SIZE_INT16                  2
#define ELEMENT_SIZE_FP16                   2

#define ATOM_SIZE_INT8                      (NVDLA_MEMORY_ATOMIC_SIZE*ELEMENT_SIZE_INT8)
#define ATOM_SIZE_INT16                     (NVDLA_MEMORY_ATOMIC_SIZE*ELEMENT_SIZE_INT16)
#define ATOM_SIZE_FP16                      (NVDLA_MEMORY_ATOMIC_SIZE*ELEMENT_SIZE_FP16)

#define NVDLA_MAC_ATOMIC_C_SIZE_WG          (NVDLA_MAC_ATOMIC_C_SIZE/(4*4))

#define CBUF_ENTRY_NUM                      (NVDLA_CBUF_BANK_NUMBER*NVDLA_CBUF_BANK_DEPTH)
#define CBUF_WMB_BANK_IDX                   15

#define ATOM_PER_CBUF_ENTRY_INT8            (NVDLA_CBUF_BANK_WIDTH/ATOM_SIZE_INT8)
#define ATOM_PER_CBUF_ENTRY_INT16           (NVDLA_CBUF_BANK_WIDTH/ATOM_SIZE_INT16)
#define ATOM_PER_CBUF_ENTRY_FP16            (NVDLA_CBUF_BANK_WIDTH/ATOM_SIZE_FP16)

#define CSC2CMAC_CONTAINER_BITWIDTH         8
#define CBUF_ENTRY_CMOD_GRANULARITY_SIZE    8
#define CBUF_ENTRY_CMOD_GRANULARITY_NUM     (NVDLA_CBUF_BANK_WIDTH/CBUF_ENTRY_CMOD_GRANULARITY_SIZE)

#define CSC2CMAC_WEIGHT_MASK                ((1<<(NVDLA_MAC_ATOMIC_K_SIZE/2))-1)

#define MAX_MEM_TRANSACTION_SIZE            256

#define CACC_ENTRY_NUM                      (256*2)

#define INPUT_DATA_FORMAT_DC                0
#define INPUT_DATA_FORMAT_IMAGE             1
#define INPUT_DATA_FORMAT_WINO              2

#define CSC_LOCAL_BUFFER_SIZE              256

/***************************************
 * Clarify on channel mask and kernel mask,
 *  when in int8 mode, channel mask shall be the same, so channel mask
 *  suggest add kernel mask in nvdla_stripe_info
 * Int8 data element layout in a csc2mac
 * Suggest split CSC to MAC interface as int8 container based
 * Confirm on nvdla_stripe_info
***************************************/

SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)
class NV_NVDLA_csc:
    public  NV_NVDLA_csc_base, // ports
    private csc_reg_model      // csc data path and write dma register accessing
{
    public:
        SC_HAS_PROCESS(NV_NVDLA_csc);
        NV_NVDLA_csc( sc_module_name module_name );
        ~NV_NVDLA_csc();
        // Overload for pure virtual TLM target functions
        // # CSB request transport implementation shall in generated code
        void csb2csc_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // # CSC-CDMA status update
        void dat_up_cdma2sc_b_transport(int ID, nvdla_dat_info_update_t* payload, sc_time& delay);
        void wt_up_cdma2sc_b_transport(int ID, nvdla_wt_info_update_t* payload, sc_time& delay);
        // # CBUF->CSC read data return
        void sc2buf_dat_rd_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_b_transport(int ID, nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_t* payload, sc_time& delay);
        void sc2buf_wt_rd_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_b_transport(int ID, nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_t* payload, sc_time& delay);
        void sc2buf_wmb_rd_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_b_transport(int ID, nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_t* payload, sc_time& delay);
        // # CACC-CSC
        void accu2sc_credit_b_transport(int ID, nvdla_cc_credit_t* payload, sc_time& delay);

    private:
        // Variables
        bool is_there_ongoing_csb2csc_response_;
        uint32_t cbuf_wt_entry_addr;
        uint32_t cbuf_wmb_entry_addr;
        uint32_t comp_updated_wt_entry_num;
        uint32_t comp_updated_wmb_entry_num;
        uint8_t  kg_wt_first_entry_buffer[NVDLA_CBUF_BANK_WIDTH];
        // For weight compression
        uint32_t next_wt_idx;
        uint32_t next_wmb_idx;
        uint8_t  wt_payload_available;
        uint32_t next_wt_idx_bak;
        uint32_t next_wmb_idx_bak;
        uint8_t  wt_payload_available_bak;
        uint64_t comp_entry_wt[CBUF_ENTRY_CMOD_GRANULARITY_NUM], comp_entry_wt_bak[CBUF_ENTRY_CMOD_GRANULARITY_NUM];
        uint8_t  comp_entry_wmb[NVDLA_CBUF_BANK_WIDTH], comp_entry_wmb_bak[NVDLA_CBUF_BANK_WIDTH];
        // Payloads

        nvdla_dat_info_update_t *data2sc_data_update_payload_;
        nvdla_wt_info_update_t  *data2sc_weight_update_payload_;

        // Delay
        sc_core::sc_time dma_delay_;
        sc_core::sc_time csb_delay_;
        sc_core::sc_time b_transport_delay_;

        // Events
        sc_event csc_kickoff_;
        // Done signals are not DMA mapped
        sc_event csc_data_fetch_done_;
        sc_event csc_weight_fetch_done_;

        // Sequence controller and DMA fetcher communication on CBuffer usage
        sc_event cdma_updated_cbuf_data_usage_;
        sc_event cdma_updated_cbuf_weight_usage_;
        // ACCU update its free entry number
        sc_event accu_free_entry_num_update_;
        // kernel load and data load communication
        sc_event kernel_switch_updated_;
        sc_event stripe_begin_updated_;


        // Communication between CDMA and CSC
        uint32_t    slice_idx_available_;
        uint32_t    slice_idx_free_;
        sc_core::sc_mutex slice_idx_dma_fetched_mutex_;
        uint64_t    data_entry_idx_available_;
        uint64_t    data_entry_idx_free_;

        uint64_t    cacc_free_entry_num_;           // update by CACC
        uint64_t    cacc_avaliable_entry_num_;      // update by CSC

        // Communication between Data sequence and Weight Sequence
        uint64_t    kernel_switch_round_data_;
        uint64_t    kernel_switch_round_weight_;

        uint64_t    weight_kernel_num_used_;       // update by CSC
        uint64_t    weight_kernel_num_available_;  // update by CSC
        uint64_t    weight_entry_idx_available_;   // update by CDMA
        uint64_t    weight_entry_idx_start_;       // update by CSC. Can be removed actually.
        uint64_t    weight_layer_start_byte_idx_;  // The byte index of the first byte of current layer. It should be multiple of NVDLA_CBUF_BANK_WIDTH
        uint64_t    weight_entry_idx_free_skip_weight_rls_; // update by CSC

        uint64_t    wmb_entry_idx_available_;      // update by CDMA
        uint64_t    wmb_entry_idx_start_;          // update by CSC

        uint64_t    weight_kernel_num_used_prev_;
        uint64_t    weight_entry_idx_start_prev_;
        uint64_t    wmb_entry_idx_start_prev_;

        bool       csc_dat_prev_skip_data_rls_;
        int32_t    csc_dat_prev_conv_mode_;
        int32_t    csc_dat_prev_data_bank_;
        int32_t    csc_dat_prev_weight_bank_;
        int32_t    csc_dat_prev_input_data_format_;
        int32_t    csc_prev_left_dat_slices_;
        int32_t    csc_prev_left_dat_entries_;

        bool       csc_wt_prev_skip_weight_rls_;
        int32_t    csc_wt_prev_conv_mode_;
        int32_t    csc_wt_prev_data_bank_;
        int32_t    csc_wt_prev_weight_bank_;
        int32_t    csc_wt_prev_input_data_format_;
        int32_t    csc_prev_left_wt_kernels_;
        int32_t    csc_prev_left_wt_entries_;
        int32_t    csc_prev_left_wmb_entries_;

        // FIFOs
        // # DMA buffers
        sc_core::sc_fifo <uint8_t>  *csc_act_share_buffer_;
        sc_core::sc_fifo <sc_uint<64>*> *cbuf_data_read_;
        sc_core::sc_fifo <sc_uint<64>*> *cbuf_weight_read_;
        sc_core::sc_fifo <sc_uint<64>*> *cbuf_wmb_read_;
        sc_core::sc_fifo <uint32_t> *cdma_updated_cbuf_data_fifo_;

        // Operation mode
        uint32_t    csc_operation_mode_;

        // Function declaration 
        // # Threads
        void CscConsumerThread();
        // # Hardware layer trigger function
        void CscHardwareLayerExecutionTrigger();
        // Send data to CMAC
        void DataLoadSequenceThread();
        // Weight load sequence
        void WeightLoadSequenceThread();
        // #  Functional functions
        void Reset();
        void CscSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);
        uint32_t evaluate_channel_operation_num(uint32_t total_atom_num, uint32_t ideal_stripe_length);

        void WaitUntilCBufferHasEnoughtAvailiableDataEntriesFullInput(uint32_t required_entry_num);
        void WaitUntilThereIsEnoughSpaceInCaccu(uint32_t num);
        void WaitUntilThereAreEnoughKernel(uint32_t kernel_num);
        void WaitUntilKernelsAreReady();
        void WaitStripeBeginHasSent();

        // Sequencers
        // Direct convolution sequencer
        void SendDataToMacSequencerDirectConvCommon();
        void SendDataToMacSequencerWinoConvCommon();
        void SendWeightToMacSequencerDirectConvCommon();
        void SendWeightToMacSequencerWinoConvCommon();
        void SendImageDataToMacSequencerConvCommon();

        uint32_t csc_bytes_per_pixel(uint32_t pixel_format);
        void get_decompressed_weight(uint8_t *read_data_curr_ptr, uint32_t current_kernel_channel);
        void read_cbuf_entry(uint32_t cbuf_entry_addr, uint8_t *read_data_ptr);
        uint16_t sign_extend_8to16(uint8_t int8_in);
        void csc_read_one_image_entry(uint8_t post_y_extension, uint32_t post_y_extension_idx, uint32_t input_atom_coor_width, uint32_t input_atom_coor_height, uint32_t cbuf_entry_per_line, uint32_t element_size, bool last_super_channel, uint32_t last_super_channel_element_num, uint32_t cube_in_height, uint32_t cube_in_channel, uint8_t* read_data_ptr);
        void save_info_kernel_group();
};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NV_NVDLA_csc * NV_NVDLA_cscCon(sc_module_name module_name);

#endif

