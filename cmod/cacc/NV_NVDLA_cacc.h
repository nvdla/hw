// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cacc.h

#ifndef _NV_NVDLA_CACC_H_
#define _NV_NVDLA_CACC_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 
#include "scsim_common.h"
#include "systemc.h"
// #include "nvdla_mac_dat_if_DATA_2944_MASK_16_iface.h"
#include "nvdla_mac2accu_data_if_iface.h"
// #include "nvdla_container_number_32_bit_width_32_iface.h"
#include "nvdla_accu2pp_if_iface.h"
#include "nvdla_xx2csb_resp_iface.h"
#include "NV_NVDLA_cacc_base.h"
#include "cacc_reg_model.h"
#include "nvdla_config.h"

//stepheng add cacc FP39 define.20170329
//#define CACC_FP39
//#define NVDLA_GENERIC_CACC_USE_39_BIT_FP_ADDER

#ifdef NVDLA_GENERIC_CACC_USE_39_BIT_FP_ADDER
     #define FP16_ALEN 39
     #define FP16_ELEN 7
     #define FP16_MLEN 32
     #define CACC_FP39
#else
     #define FP16_ALEN 48
     #define FP16_ELEN 8
     #define FP16_MLEN 40
#endif

#define MAC_OUTPUT_BIT_WIDTH_INT8               22
#define MAC_OUTPUT_BIT_WIDTH_INT16              46
#define MAC_OUTPUT_BIT_WIDTH_FP16               32

#define ACCU_ASSEMBLY_BIT_WIDTH_INT8            32
#define ACCU_ASSEMBLY_BIT_WIDTH_INT16           FP16_ALEN   //stepheng.20170329
#define ACCU_ASSEMBLY_BIT_WIDTH_FP16            32

#define ACCU_DELIVERY_BIT_WIDTH_INT8            32
#define ACCU_DELIVERY_BIT_WIDTH_INT16           32
#define ACCU_DELIVERY_BIT_WIDTH_FP16            32

#define ACCU_DELIVERY_BIT_WIDTH_COMMON_INT8     8
#define ACCU_DELIVERY_BIT_WIDTH_COMMON_INT16    16
#define ACCU_DELIVERY_BIT_WIDTH_COMMON_FP16     16

#define MAC_CELL_NUM							NVDLA_MAC_ATOMIC_K_SIZE
#define HALF_MAC_CELL_NUM						(MAC_CELL_NUM/2)
#define RESULT_NUM_PER_MACCELL					4

#define DIRECT_CONV_ASSEMBLY_ENTRY_NUM          256
#define DIRECT_CONV_DELIVERY_ENTRY_NUM          256
//In RTL, the assembly SRAM group and delivery SRAM group can contain 256*16elements separately.
//For simplicity, multiply 2 here for INT8 case.
#define SRAM_GROUP_SIZE             (MAC_CELL_NUM*2*DIRECT_CONV_DELIVERY_ENTRY_NUM)

#define CONV_MODE_DIRECT_CONVOLUTION    0
#define CONV_MODE_WINOGRAD              1

#define MAX_BATCH_SIZE                  32


SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)
class CaccConfig {
    public:
        uint32_t cacc_proc_precision_;
        uint32_t cacc_dataout_width_;
        uint32_t cacc_dataout_height_;
        uint32_t cacc_dataout_channel_;
        uint32_t cacc_conv_mode_;
        uint32_t cacc_clip_truncate_;
        uint32_t cacc_batches_;
        bool     cacc_line_packed_;
        bool     cacc_surf_packed_;
        uint64_t cacc_dataout_addr_;
        uint64_t cacc_line_stride_;
        uint32_t cacc_consumer_;
};

// Operator for being a SC_FIFO payload
inline std::ostream& operator<<(std::ostream& out, const CaccConfig & obj) {
    return out << "Just to fool compiler" << endl;
}

class NV_NVDLA_cacc:
    public  NV_NVDLA_cacc_base, // ports
    private cacc_reg_model      // cacc data path and write dma register accessing
{
    public:
        SC_HAS_PROCESS(NV_NVDLA_cacc);
        NV_NVDLA_cacc( sc_module_name module_name );
        ~NV_NVDLA_cacc();
        // Overload for pure virtual TLM target functions
        // # CSB request transport implementation shall in generated code
        void csb2cacc_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // # CMAC to CACCU
        void mac_a2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay);
        void mac_b2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay);

        // Port has no flow: cacc2glb_done_intr
        sc_vector< sc_out<bool> > cacc2glb_done_intr;

    private:
        // Variable shall be in register config
        uint32_t accu_batch_num_;
        uint32_t accu_split_c_en_;
        uint32_t accu_ass2del_msb_;
        uint32_t accu_ass2del_lsb_;

        // Variables
        bool    first_layer;
        bool    delivery_first_layer;
        bool    reshape_first_layer;
        bool    input_first_layer;
        bool    input_first_channel;
        int     deliver_prev_conv_mode_;
        int     reshape_prev_conv_mode_;
        int     deliver_prev_precision_;
        int     reshape_prev_precision_;
        bool    is_there_ongoing_csb2cacc_response_;
        bool    is_assembly_working_;
        int32_t assembly_sram_group_idx_working_;
        int32_t saved_assembly_sram_group_idx_working_;
        int32_t assembly_sram_group_idx_available_;
        int32_t prev_layer_assembly_sram_group_idx_available_;
        int32_t assembly_sram_group_idx_fetched_;
        // int32_t delivery_sram_group_idx_working_;
        int32_t delivery_sram_group_idx_available_;
        int32_t prev_layer_delivery_sram_group_idx_available_;
        int32_t delivery_sram_group_idx_fetched_;
        // uint8_t *assembly_sram_group_;
        // uint8_t *delivery_sram_group_;
        sc_int<ACCU_ASSEMBLY_BIT_WIDTH_INT16> *assembly_sram_group_;
        sc_int<ACCU_DELIVERY_BIT_WIDTH_INT16> *delivery_sram_group_;
        uint32_t *assembly_sram_group_mask_bits_;
        uint8_t *assembly_sram_group_layer_end_bit_;
        uint32_t *delivery_sram_group_mask_bits_;
        uint8_t  *delivery_sram_group_layer_end_bit_;
        // int32_t *assembly_group_ptr_int8_;
        // int64_t *assembly_group_ptr_int16_;
        // float   *assembly_group_ptr_fp16_;
        // Payloads
        bool has_ongoing_channel_operation_;
        uint32_t cacc2sdp_count;
        uint32_t mac2cacc_count;

        uint32_t    saturation_num_perlayer_; //stepheng.20170724 

        sc_fifo <nvdla_mac2accu_data_if_t*> *mac_a2acc_fifo_;
        sc_fifo <nvdla_mac2accu_data_if_t*> *mac_b2acc_fifo_;
        nvdla_mac2accu_data_concat_if_t mac2accu_payload;

        // Delay
        sc_core::sc_time dma_delay_;
        sc_core::sc_time csb_delay_;
        sc_core::sc_time b_transport_delay_;

        // Events
        sc_event cacc_kickoff_;
        sc_event cacc_done_;
        sc_event assembly_sram_group_idx_available_incr_;
        sc_event delivery_sram_group_idx_available_incr_;

        // FIFOs
        // # ACCU buffers
        // sc_core::sc_fifo <uint8_t *>  *assembly_sram_group_;
        // sc_core::sc_fifo <uint8_t *>  *delivery_sram_group_;
        sc_core::sc_fifo <sc_int<32> *>  *to_sdp_fifo_;
        sc_fifo <CaccConfig *>        *assembly2reshape_config_fifo_;
        sc_fifo <CaccConfig *>        *assembly2delivery_config_fifo_;
        sc_fifo <CaccConfig *>        *assembly2send_config_fifo_;

        // Operation mode
        uint32_t    cacc_operation_mode_;

        // Function declaration 
        // # Threads
        void CaccConsumerThread();
        // # Hardware layer trigger function
        void CaccHardwareLayerExecutionTrigger();
        void ReshapeSequenceThread();
        void DeliverSequenceThread();
        void SendToSDPThread();
        void mac2accu_b_transport(nvdla_mac2accu_data_concat_if_t* payload, sc_time& delay);


        // Sequencers
        // Reshape sequence
        void ReshapeSequencerDirectConvCommon();
        // Deliver sequencer
        void DeliverSequencerDirectConvCommon();
        void SendToSDPCommon();
        // void DirectConvDeliverSequencerInt8();
        // #  Functional functions
        void CmacDataConcatThread();
        void Reset();
        void CaccSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);
        void WaitUntilThereIsAvaliableDataInAssemblyGroup();
        void WaitUntilThereIsAvaliableDataInDeliveryGroup();
        void cacc_fp16_add(sc_uint<FP16_ALEN> *fp16_accu_data, sc_uint<44> fp16_mac_data);
        void cacc_fp48_to_fp32(sc_int<32> *fp32_to_sdp, sc_uint<FP16_ALEN> fp16_accu_data);

};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NV_NVDLA_cacc * NV_NVDLA_caccCon(sc_module_name module_name);

#endif

