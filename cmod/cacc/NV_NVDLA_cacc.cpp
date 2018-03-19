// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cacc.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_cacc.h"
#include "NV_NVDLA_cacc_cacc_gen.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "math.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define LOG_DETAIL 0

#define DATA_FORMAT_INT8        NVDLA_CACC_D_MISC_CFG_0_PROC_PRECISION_INT8
#define DATA_FORMAT_INT16       NVDLA_CACC_D_MISC_CFG_0_PROC_PRECISION_INT16
#define DATA_FORMAT_FP16        NVDLA_CACC_D_MISC_CFG_0_PROC_PRECISION_FP16

#define MAX_INT_48BITS    0x7fffffffffffLL    // 47 bits of 1'b1. The max positive value in INT48
#define MIN_INT_48BITS   (-140737488355328LL) // (0-0x800000000000LL)

#define FP16DEBUG_DETAIL  0   //stepheng.20170330 
//#define FP16DEBUG_DETAIL  1

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

NV_NVDLA_cacc::NV_NVDLA_cacc( sc_module_name module_name ):
    NV_NVDLA_cacc_base(module_name),
    cacc2glb_done_intr("cacc2glb_done_intr", 2),
    // Delay setup
    dma_delay_(SC_ZERO_TIME),
    csb_delay_(SC_ZERO_TIME),
    b_transport_delay_(SC_ZERO_TIME)
{
    // Memory allocation
    // No matter which precision (int8, Int16 and FP16) is used, both assembly and delivery ram use the highest bit consumption precision which is Int16
    assembly_sram_group_    = new sc_int<ACCU_ASSEMBLY_BIT_WIDTH_INT16> [SRAM_GROUP_SIZE];
    delivery_sram_group_    = new sc_int<ACCU_DELIVERY_BIT_WIDTH_INT16> [SRAM_GROUP_SIZE];
    mac_a2acc_fifo_ = new sc_fifo <nvdla_mac2accu_data_if_t *> (1);
    mac_b2acc_fifo_ = new sc_fifo <nvdla_mac2accu_data_if_t *> (1);
    to_sdp_fifo_    = new sc_core::sc_fifo <sc_int<32> *> (SRAM_GROUP_SIZE*4);
    assembly2reshape_config_fifo_   = new sc_fifo <CaccConfig *> (1);
    assembly2delivery_config_fifo_  = new sc_fifo <CaccConfig *> (1);
    assembly2send_config_fifo_      = new sc_fifo <CaccConfig *> (1);
    cacc2sdp_count = 0;
    mac2cacc_count = 0;
    first_layer = true;
    delivery_first_layer = true;
    reshape_first_layer  = true;
    input_first_layer    = true;
    input_first_channel  = true;
    deliver_prev_conv_mode_      = -1;
    reshape_prev_conv_mode_      = -1;
    deliver_prev_precision_      = -1;
    reshape_prev_precision_      = -1;

    // Reset
    Reset();

    SC_THREAD(CaccConsumerThread)
    SC_THREAD(ReshapeSequenceThread)
    SC_THREAD(DeliverSequenceThread)
    SC_THREAD(CmacDataConcatThread)
    SC_THREAD(SendToSDPThread)
}

#pragma CTC SKIP
NV_NVDLA_cacc::~NV_NVDLA_cacc() {
    if( assembly_sram_group_ )                  delete [] assembly_sram_group_;
    if( delivery_sram_group_ )                  delete [] delivery_sram_group_;
    if( mac_a2acc_fifo_ )                       delete mac_a2acc_fifo_;
    if( mac_b2acc_fifo_ )                       delete mac_b2acc_fifo_;
}
#pragma CTC ENDSKIP

void NV_NVDLA_cacc::Reset()
{
    // Clear register and internal states
    CaccRegReset();
    is_there_ongoing_csb2cacc_response_     = false;
    has_ongoing_channel_operation_          = false;

    cacc2glb_done_intr[0].initialize(false);
    cacc2glb_done_intr[1].initialize(false);
}

void NV_NVDLA_cacc::CaccConsumerThread () {
    while (true) {
        while(CaccGetOpeartionEnable(cacc_register_group_0) != NVDLA_CACC_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_cacc_reg_group_0_operation_enable);
        }
        cslInfo(("NV_NVDLA_cacc::CaccConsumerThread, group 0 opeartion start\n"));
        saturation_num_perlayer_ =0;
        cacc_reg_model::CaccUpdateWorkingStatus(0,1);
        cacc_reg_model::CaccUpdateVariables(cacc_register_group_0);
        CaccHardwareLayerExecutionTrigger();
        cacc_reg_model::CaccUpdateStatRegisters(0, saturation_num_perlayer_);  //stepheng.20170724
        cacc_reg_model::CaccUpdateWorkingStatus(0,0);
        cacc_reg_model::CaccClearOpeartionEnable(cacc_register_group_0);
        cslInfo(("NV_NVDLA_cacc::CaccConsumerThread, group 0 opeartion done\n"));

        while(CaccGetOpeartionEnable(cacc_register_group_1) != NVDLA_CACC_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_cacc_reg_group_1_operation_enable);
        }
        cslInfo(("NV_NVDLA_cacc::CaccConsumerThread, group 1 opeartion start\n"));
        saturation_num_perlayer_ =0;
        cacc_reg_model::CaccUpdateWorkingStatus(1,1);
        cacc_reg_model::CaccUpdateVariables(cacc_register_group_1);
        CaccHardwareLayerExecutionTrigger();
        cacc_reg_model::CaccUpdateStatRegisters(1, saturation_num_perlayer_);  //stepheng,20170724      
        cacc_reg_model::CaccUpdateWorkingStatus(1,0);
        cacc_reg_model::CaccClearOpeartionEnable(cacc_register_group_1);
        cslInfo(("NV_NVDLA_cacc::CaccConsumerThread, group 1 opeartion done\n"));
    }
}

void NV_NVDLA_cacc::CaccHardwareLayerExecutionTrigger () {
    uint32_t    atom_per_mac_cell;
    uint32_t    conv_mode;
    CaccConfig  *cacc_config_reshape;
    CaccConfig  *cacc_config_delivery;
    CaccConfig  *cacc_config_send;

    conv_mode = cacc_conv_mode_;
    // Evaluated
    if (CONV_MODE_WINOGRAD == conv_mode) {
        atom_per_mac_cell = 4;
    } else {
        atom_per_mac_cell = 1;
    }

    if(first_layer) {
        first_layer = false;
        // Initialize the idx variables when starting the 1st layer. They will not be reset when layer switches.
        assembly_sram_group_idx_working_    = 0;  //assembly_sram_group_idx_working_ points to the next entry for process and it starts from 0
        prev_layer_assembly_sram_group_idx_available_ = -100;
        prev_layer_delivery_sram_group_idx_available_ = -100;

        assembly_sram_group_idx_available_  = -1 * atom_per_mac_cell;  //assembly_sram_group_idx_available_ points to the entry which has valid data to process
        assembly_sram_group_idx_fetched_    = -1 * atom_per_mac_cell; //assembly_sram_group_idx_fetched_ points to the last entry which has been processed
        delivery_sram_group_idx_available_  = -1 * atom_per_mac_cell;
        delivery_sram_group_idx_fetched_    = -1 * atom_per_mac_cell;
    }

    if (!is_assembly_working_) {
        is_assembly_working_ = true;

#pragma CTC SKIP
        if (cacc_clip_truncate_+ACCU_DELIVERY_BIT_WIDTH_INT16 > ACCU_ASSEMBLY_BIT_WIDTH_INT16) {
            FAIL(("NV_NVDLA_cacc::CaccHardwareLayerExecutionTrigger, cacc_clip_truncate_ shall not be greater than %d, it's value is %d\n", ACCU_ASSEMBLY_BIT_WIDTH_INT16 - ACCU_DELIVERY_BIT_WIDTH_INT16, cacc_clip_truncate_));
        }
#pragma CTC ENDSKIP

        cacc_config_reshape = new CaccConfig;
        cacc_config_reshape->cacc_proc_precision_  = cacc_proc_precision_;
        cacc_config_reshape->cacc_dataout_width_   = cacc_dataout_width_;
        cacc_config_reshape->cacc_dataout_height_  = cacc_dataout_height_;
        cacc_config_reshape->cacc_dataout_channel_ = cacc_dataout_channel_;
        cacc_config_reshape->cacc_conv_mode_       = cacc_conv_mode_;
        cacc_config_reshape->cacc_clip_truncate_   = cacc_clip_truncate_;
        cacc_config_reshape->cacc_batches_         = cacc_batches_;
        cacc_config_reshape->cacc_line_packed_     = cacc_line_packed_;
        cacc_config_reshape->cacc_surf_packed_     = cacc_surf_packed_;
        cacc_config_reshape->cacc_dataout_addr_    = cacc_dataout_addr_;
        cacc_config_reshape->cacc_line_stride_     = cacc_line_stride_;
        cacc_config_reshape->cacc_consumer_        = cacc_consumer_;
        assembly2reshape_config_fifo_->write(cacc_config_reshape);

        cacc_config_delivery = new CaccConfig;
        cacc_config_send     = new CaccConfig;
        cacc_config_send->cacc_proc_precision_  = cacc_config_delivery->cacc_proc_precision_  = cacc_proc_precision_;
        cacc_config_send->cacc_dataout_width_   = cacc_config_delivery->cacc_dataout_width_   = cacc_dataout_width_;
        cacc_config_send->cacc_dataout_height_  = cacc_config_delivery->cacc_dataout_height_  = cacc_dataout_height_;
        cacc_config_send->cacc_dataout_channel_ = cacc_config_delivery->cacc_dataout_channel_ = cacc_dataout_channel_;
        cacc_config_send->cacc_conv_mode_       = cacc_config_delivery->cacc_conv_mode_       = cacc_conv_mode_;
        cacc_config_send->cacc_clip_truncate_   = cacc_config_delivery->cacc_clip_truncate_   = cacc_clip_truncate_;
        cacc_config_send->cacc_batches_         = cacc_config_delivery->cacc_batches_         = cacc_batches_;
        cacc_config_send->cacc_line_packed_     = cacc_config_delivery->cacc_line_packed_     = cacc_line_packed_;
        cacc_config_send->cacc_surf_packed_     = cacc_config_delivery->cacc_surf_packed_     = cacc_surf_packed_;
        cacc_config_send->cacc_dataout_addr_    = cacc_config_delivery->cacc_dataout_addr_    = cacc_dataout_addr_;
        cacc_config_send->cacc_line_stride_     = cacc_config_delivery->cacc_line_stride_     = cacc_line_stride_;
        cacc_config_send->cacc_consumer_        = cacc_config_delivery->cacc_consumer_        = cacc_consumer_;
        assembly2delivery_config_fifo_->write(cacc_config_delivery);
        assembly2send_config_fifo_->write(cacc_config_send);
    }
    cacc_kickoff_.notify();
    cslInfo(("cacc before wait cacc_done_\n"));
    wait(cacc_done_);
    cslInfo(("cacc after wait cacc_done_\n"));
}

void NV_NVDLA_cacc::mac_a2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay) {
    uint8_t *src_ptr, *dst_ptr;
    nvdla_mac2accu_data_if_t * payload_copy = new nvdla_mac2accu_data_if_t;
    src_ptr = (uint8_t*) payload;
    dst_ptr = (uint8_t*) payload_copy;
    memcpy(dst_ptr, src_ptr, sizeof(nvdla_mac2accu_data_if_t));
    // mac_a2acc_fifo_->write(payload);
    cslDebug((50, "MARKFIFO: before write to mac_a2acc_fifo_\n"));
    mac_a2acc_fifo_->write(payload_copy);
    cslDebug((50, "MARKFIFO: after write to mac_a2acc_fifo_\n"));
}

void NV_NVDLA_cacc::mac_b2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay) {
    uint8_t *src_ptr, *dst_ptr;
    nvdla_mac2accu_data_if_t * payload_copy = new nvdla_mac2accu_data_if_t;
    src_ptr = (uint8_t*) payload;
    dst_ptr = (uint8_t*) payload_copy;
    memcpy(dst_ptr, src_ptr, sizeof(nvdla_mac2accu_data_if_t));
    // mac_b2acc_fifo_->write(payload);
    //cslDebug((50, "MARKFIFO: before write to mac_b2acc_fifo_\n"));
    mac_b2acc_fifo_->write(payload_copy);
    //cslDebug((50, "MARKFIFO: after write to mac_b2acc_fifo_\n"));
}

void NV_NVDLA_cacc::CmacDataConcatThread() {
    nvdla_mac2accu_data_if_t *half_payload;
    int offset = HALF_MAC_CELL_NUM*RESULT_NUM_PER_MACCELL;

    while(1) {
        //cslDebug((50,"MARKWAIT: before mac_a2acc_fifo_ and mac_b2acc_fifo_\n"));
        wait(mac_a2acc_fifo_->data_written_event() & mac_b2acc_fifo_->data_written_event());
        //cslDebug((50,"MARKWAIT: after mac_a2acc_fifo_ and mac_b2acc_fifo_\n"));
        mac2accu_payload.mask = 0;

        // MAC_A
#pragma CTC SKIP
        assert(mac_a2acc_fifo_->num_available() > 0);
#pragma CTC ENDSKIP
        half_payload = mac_a2acc_fifo_->read();

        mac2accu_payload.mask |= half_payload->mask;
        cslDebug((50, "NV_NVDLA_cacc::CmacDataConcatThread, from A part\n"));
        for(int element_iter = 0; element_iter < HALF_MAC_CELL_NUM*RESULT_NUM_PER_MACCELL; element_iter++) {
            mac2accu_payload.data[element_iter] = half_payload->data[element_iter];
            cslDebug((70, "half_payload.data[0x%x]:0x%08x\n", element_iter, (uint32_t)(half_payload->data[element_iter])));
        }
        mac2accu_payload.pd.nvdla_stripe_info = half_payload->pd.nvdla_stripe_info;
        delete half_payload;

        // MAC_B
#pragma CTC SKIP
        assert(mac_b2acc_fifo_->num_available() > 0);
#pragma CTC ENDSKIP
        half_payload = mac_b2acc_fifo_->read();

        mac2accu_payload.mask |= half_payload->mask << HALF_MAC_CELL_NUM;
        cslDebug((50, "NV_NVDLA_cacc::CmacDataConcatThread, from B part\n"));
        for(int element_iter = 0; element_iter < HALF_MAC_CELL_NUM*RESULT_NUM_PER_MACCELL; element_iter++) {
            mac2accu_payload.data[element_iter+offset] = half_payload->data[element_iter];
            cslDebug((70, "half_payload.data[0x%x]:0x%08x\n", element_iter, (uint32_t)(half_payload->data[element_iter])));
        }
        // check strip info is the same or not
        // if (!memcmp(&mac2accu_payload.pd.nvdla_stripe_info, &half_payload->pd.nvdla_stripe_info, sizeof(mac2accu_payload.pd.nvdla_stripe_info))) {
        //     FAIL(("NV_NVDLA_cacc::CmacDataConcatThread, stripe info is different between CMAC_A and CMAC_B"));
        // }
        mac2accu_payload.pd.nvdla_stripe_info = half_payload->pd.nvdla_stripe_info;
        delete half_payload;

        mac2accu_b_transport(&mac2accu_payload, b_transport_delay_);
    }
}


void NV_NVDLA_cacc::ReshapeSequenceThread () {
    while (true) {
        cslDebug((30, "NV_NVDLA_cacc::ReshapeSequenceThread before ReshapeSequencerDirectConvCommon\n"));
        ReshapeSequencerDirectConvCommon();
        cslDebug((30, "NV_NVDLA_cacc::ReshapeSequenceThread after ReshapeSequencerDirectConvCommon\n"));
    }
}

void NV_NVDLA_cacc::DeliverSequenceThread () {
    while (true) {
        cslDebug((30, "NV_NVDLA_cacc::DeliverSequenceThread before DeliverSequencerDirectConvCommon\n"));
        DeliverSequencerDirectConvCommon();
        cslDebug((30, "NV_NVDLA_cacc::DeliverSequenceThread after DeliverSequencerDirectConvCommon\n"));
    }
}

void NV_NVDLA_cacc::SendToSDPThread () {
    while (true) {
        cslDebug((30, "NV_NVDLA_cacc::SendToSDPThread Layer begin\n"));
        SendToSDPCommon();
        cslDebug((30, "NV_NVDLA_cacc::SendToThread Layer end\n"));
    }
}

void NV_NVDLA_cacc::SendToSDPCommon () {
    // Config variables, they have corresponding value in registers
    uint32_t    precision;
    uint32_t    cube_width;
    uint32_t    cube_height;
    uint32_t    cube_channel;
    uint32_t    conv_mode;
    uint32_t    batch_num;
    bool        line_packed;
    bool        surf_packed;
    uint64_t    base_addr;
    uint64_t    line_stride;
    uint32_t    cacc_consumer;
    // Control variables
    uint64_t    atom_num_sent, atom_num, batch_atom_num;
    uint32_t    atom_per_mac_cell;
    uint16_t    atom_num_batch_2sdp;
    bool        line_start_addr_aligned_to_64B;
    bool        cube_size_1x1;
    sc_int<32>* to_sdp_atom[2*2*MAX_BATCH_SIZE];    // 1st 2: for int8; 2nd 2: for line_start_addr_aligned_to_64B cases
    uint32_t    cube_out_width_coor;
    uint32_t    cube_out_height_coor;
    bool        cube_out_width_first;
    bool        cube_out_width_last;
    bool        cube_out_height_last;
    uint32_t    i, j;
    uint16_t    trans_num;
    uint16_t    trans_iter;
    CaccConfig* cacc_config;

    cacc2sdp_count  = 0;

    sc_int<32>  *payload_data_ptr = cacc2sdp_payload.pd.nvdla_cc2pp_pkg.data;   // cacc2sdp_payload.pd.nvdla_cc2pp_pkg.data is an array of 16 sc_int<32> elements
    cacc2sdp_payload.pd.nvdla_cc2pp_pkg.batch_end = 0;
    cacc2sdp_payload.pd.nvdla_cc2pp_pkg.layer_end = 0;

    assembly2send_config_fifo_->read(cacc_config);
    cslDebug((70, "after read assembly2send_config_fifo_\n"));

    precision    = cacc_config->cacc_proc_precision_;
    cube_width   = cacc_config->cacc_dataout_width_ + 1;
    cube_height  = cacc_config->cacc_dataout_height_ + 1;
    cube_channel = cacc_config->cacc_dataout_channel_ + 1;
    conv_mode    = cacc_config->cacc_conv_mode_;
    batch_num    = cacc_config->cacc_batches_ + 1;
    line_packed  = cacc_config->cacc_line_packed_;
    surf_packed  = cacc_config->cacc_surf_packed_;
    base_addr    = cacc_config->cacc_dataout_addr_;
    line_stride  = cacc_config->cacc_line_stride_;
    cacc_consumer = cacc_config->cacc_consumer_;
    delete cacc_config;

    cslDebug((70, "WxHxC=%dx%dx%d, precision:%d, batch_num:%d, line_packed:%d, surf_packed:%d, conv_mode:%d\n",
                cube_width, cube_height, cube_channel, precision, batch_num, line_packed, surf_packed, conv_mode));

    if (CONV_MODE_WINOGRAD == conv_mode) {
        atom_per_mac_cell = 4;
    } else {
        atom_per_mac_cell = 1;
    }

    // atom_num is the atom number to be written by sdp to memory
	atom_num = uint64_t(cube_width) * cube_height * ((cube_channel + NVDLA_MEMORY_ATOMIC_SIZE - 1) / NVDLA_MEMORY_ATOMIC_SIZE);
    batch_atom_num = batch_num * atom_num;
	trans_num = NVDLA_MAC_ATOMIC_K_SIZE / SDP_MAX_THROUGHPUT;
    atom_num_sent = 0;

	line_start_addr_aligned_to_64B = (base_addr % 64) == 0;
	cube_size_1x1 = (cube_width == 1) && (cube_height == 1);
	if (1 == batch_num)
        atom_num_batch_2sdp = 1;
    else {  // For 1x1, the address is aligned to 32B or 64B; otherwise, it should be aligned to 64B
            // In all cases, line_packed and surf_packed should be treated as false
        if (line_start_addr_aligned_to_64B && (cube_width > 1))
			atom_num_batch_2sdp = 2 * batch_num;
        else
            atom_num_batch_2sdp = batch_num;
    }
    cslDebug((50, "batch_num=%d atom_num=0x%lx atom_num_batch_2sdp=0x%x trans_num=%d\n", batch_num, atom_num, atom_num_batch_2sdp, trans_num));

    while (atom_num_sent < batch_atom_num) {
        // Read atoms from to_sdp_fifo_. The number of atom is atom_num_batch_2sdp
		for (i = 0; i < atom_num_batch_2sdp * atom_per_mac_cell; i++) {
            to_sdp_atom[i] = to_sdp_fifo_->read();  // Each entry of to_sdp_fifo_ contains data for an output atom of sdp
#if LOG_DETAIL
            cslDebug((50, "%s: [HYZ] to_sdp_atom init = %d\n", __FUNCTION__, i));
            cslDebug((50, "%s: deliver buffer for atom:%d\n", __FUNCTION__, i));
            for(int m = 0; m < NVDLA_MAC_ATOMIC_K_SIZE; m++) {
                cslDebug((50, "%04x \n", to_sdp_atom[i][m].to_int()));
            }
            cslDebug((50, "\n" ));
#endif
        }

        // Reorder and Send atoms to SDP
		for (i = 0; i < batch_num; i++) {
			if (atom_num_batch_2sdp == batch_num) {
                for(uint32_t atom_iter = 0; atom_iter < atom_per_mac_cell; atom_iter++) {
					for (trans_iter = 0; trans_iter < trans_num; trans_iter++) {
						for (j = 0; j < SDP_MAX_THROUGHPUT; j++) {
							payload_data_ptr[j] = to_sdp_atom[i + atom_iter][j + trans_iter * SDP_MAX_THROUGHPUT];
                        }
                        if ( trans_iter == trans_num - 1) {
						    delete[] to_sdp_atom[i + atom_iter];
                        }
						if ((trans_iter == trans_num - 1) && (atom_num_sent + 1 == batch_atom_num)) {    // Send layer_end to SDP only for the last cube in the batch
                            cacc2sdp_payload.pd.nvdla_cc2pp_pkg.batch_end = 0;  // Note: batch_end is not used by SDP cmodel??
                            cacc2sdp_payload.pd.nvdla_cc2pp_pkg.layer_end = 1;
                        }
                        cslDebug((50, "before cacc2sdp_payload\n"));
                        cacc2sdp_b_transport(&cacc2sdp_payload, b_transport_delay_);
                        cslDebug((50, "cacc2sdp_count=%d\n", cacc2sdp_count));
                        cacc2sdp_count++;
                    }
                    atom_num_sent++;
                }
            } else {
                // 1st atom
				for (trans_iter = 0; trans_iter < trans_num; trans_iter++) {
					for (j = 0; j < SDP_MAX_THROUGHPUT; j++) {
						payload_data_ptr[j] = to_sdp_atom[i][j + trans_iter * SDP_MAX_THROUGHPUT];
                    }
                    if ( trans_iter == trans_num - 1) {
    					delete[] to_sdp_atom[i];
                    }
                    cacc2sdp_b_transport(&cacc2sdp_payload, b_transport_delay_);
                    cslDebug((50, "cacc2sdp_count=%d\n", cacc2sdp_count));
                    cacc2sdp_count++;
                }
                atom_num_sent++;

                // 2nd atom
				for (trans_iter = 0; trans_iter < trans_num; trans_iter++) {
					for (j = 0; j < SDP_MAX_THROUGHPUT; j++) {
						payload_data_ptr[j] = to_sdp_atom[i + batch_num][j + trans_iter * SDP_MAX_THROUGHPUT];
                    }
                    if ( trans_iter == trans_num - 1) {
    					delete[] to_sdp_atom[i + batch_num];
                    }
					if ((trans_iter == trans_num - 1) && (atom_num_sent + 1 == batch_atom_num)) {    // Send layer_end to SDP only for the last cube in the batch
                        cacc2sdp_payload.pd.nvdla_cc2pp_pkg.batch_end = 0;
                        cacc2sdp_payload.pd.nvdla_cc2pp_pkg.layer_end = 1;
                    }
                    cacc2sdp_b_transport(&cacc2sdp_payload, b_transport_delay_);
                    cslDebug((50, "cacc2sdp_count=%d\n", cacc2sdp_count));
                    cacc2sdp_count++;
                }
                atom_num_sent++;
            }
        }

        // compute the atom_num_batch_2sdp of next batch
		cube_out_width_coor = (atom_num_sent / batch_num) % cube_width;
		cube_out_height_coor = (atom_num_sent / batch_num) / cube_width;
        cube_out_width_first = cube_out_width_coor == 0;
        cube_out_width_last = cube_out_width_coor == cube_width - 1;
        cube_out_height_last = cube_out_height_coor == cube_height - 1;

		if (1 == batch_num) {
            atom_num_batch_2sdp = 1;
        }
        else if (cube_size_1x1) {
                atom_num_batch_2sdp = batch_num;
        } else {
#pragma CTC SKIP
            if(line_packed) {   // line_packed is always false in NVDLA 1.0 due to SDP constraint
                if(cube_out_width_last && cube_out_height_last) // Last atom of current surface
                    atom_num_batch_2sdp = batch_num;
                else
                    atom_num_batch_2sdp = 2 * batch_num;
            }
#pragma CTC ENDSKIP
            else {
                if(cube_out_width_last) // Last atom of current line
                    atom_num_batch_2sdp = batch_num;
                else if(cube_out_width_first) {
                    line_start_addr_aligned_to_64B = ((base_addr + line_stride * cube_out_height_coor) % 64) == 0;
                    // line_start_addr_aligned_to_64B should be true in NVDLA1.0 because base_addr and line_stride are 64B aligned in multi-batch mode
					if (line_start_addr_aligned_to_64B && (cube_width > 1))
                        atom_num_batch_2sdp = 2 * batch_num;
                    else
                        atom_num_batch_2sdp = batch_num;
                }
                else
                    atom_num_batch_2sdp = 2 * batch_num;
            }
        }
    }
    cacc2glb_done_intr[cacc_consumer].write(true);
}

void NV_NVDLA_cacc::DeliverSequencerDirectConvCommon() {
    // Config variables, they have corresponding value in registers
    uint32_t    precision;
    uint32_t    cube_width;
    uint32_t    cube_height;
    uint32_t    cube_channel;
    uint32_t    conv_mode;
    uint32_t    batch_num;
    bool        line_packed;
    bool        surf_packed;
    // Control variables
    uint8_t     mac_cell_iter;
    uint8_t     element_per_payload;
    uint8_t     element_per_payload_prepared;
    uint64_t    atom_num_sent, atom_num, batch_atom_num;
    uint32_t    round_stride_accu;
    uint32_t    atom_per_mac_cell;
    uint8_t     atom_per_mac_cell_iter;
    sc_int<32>* prepared_sdp_atom;
    CaccConfig* cacc_config;

    cacc2sdp_count  = 0;

    cacc2sdp_payload.pd.nvdla_cc2pp_pkg.batch_end = 0;
    cacc2sdp_payload.pd.nvdla_cc2pp_pkg.layer_end = 0;

    assembly2delivery_config_fifo_->read(cacc_config);
    cslDebug((70, "after read assembly2delivery_config_fifo_\n"));

    precision    = cacc_config->cacc_proc_precision_;
    cube_width   = cacc_config->cacc_dataout_width_ + 1;
    cube_height  = cacc_config->cacc_dataout_height_ + 1;
    cube_channel = cacc_config->cacc_dataout_channel_ + 1;
    conv_mode    = cacc_config->cacc_conv_mode_;
    batch_num    = cacc_config->cacc_batches_ + 1;
    line_packed  = cacc_config->cacc_line_packed_;
    surf_packed  = cacc_config->cacc_surf_packed_;
    delete cacc_config;

    cslDebug((70, "WxHxC=%dx%dx%d, precision:%d, batch_num:%d, line_packed:%d, surf_packed:%d, conv_mode:%d\n",
                cube_width, cube_height, cube_channel, precision, batch_num, line_packed, surf_packed, conv_mode));

	round_stride_accu = MAC_CELL_NUM;

    // Evaluated
    if (CONV_MODE_WINOGRAD == conv_mode) {
        atom_per_mac_cell = 4;
    } else {
        atom_per_mac_cell = 1;
    }

    // atom_num is the atom number to be written by sdp to memory
	atom_num = uint64_t(cube_width) * cube_height * ((cube_channel + NVDLA_MEMORY_ATOMIC_SIZE - 1) / NVDLA_MEMORY_ATOMIC_SIZE);
    batch_atom_num = batch_num * atom_num;
	element_per_payload = NVDLA_MAC_ATOMIC_K_SIZE;

    atom_num_sent = 0;

    cslDebug((50, "batch_num=%d atom_num=%ld\n", batch_num, atom_num));
    while (atom_num_sent < batch_atom_num) {
        WaitUntilThereIsAvaliableDataInDeliveryGroup();
        if (delivery_first_layer) {     // first layer and first atom
            delivery_sram_group_idx_fetched_ = 0;
            delivery_first_layer = false;
		} else if (0 != atom_num_sent) {
            delivery_sram_group_idx_fetched_ += atom_per_mac_cell;
        } else {    // Not first layer and atom_num_sent==0: start of a new layer
            if (deliver_prev_conv_mode_ == CONV_MODE_WINOGRAD) {
                delivery_sram_group_idx_fetched_ += 4;
            } else {
                delivery_sram_group_idx_fetched_ += 1;
            }
        }
        cslDebug((50, "atom_num_sent=%ld batch_atom_num=%ld\n", atom_num_sent, batch_atom_num));
        cslDebug((50, "delivery_sram_group_idx_available_=0x%x\n", delivery_sram_group_idx_available_));
        cslDebug((50, "delivery_sram_group_idx_fetched_=0x%x\n", delivery_sram_group_idx_fetched_));

        for(atom_per_mac_cell_iter=0;atom_per_mac_cell_iter<atom_per_mac_cell;atom_per_mac_cell_iter++) {
			prepared_sdp_atom = new sc_int<32>[NVDLA_MAC_ATOMIC_K_SIZE];
            element_per_payload_prepared = 0;
			cslAssert(MAC_CELL_NUM == NVDLA_MAC_ATOMIC_K_SIZE);
            for (mac_cell_iter = 0; mac_cell_iter < MAC_CELL_NUM; mac_cell_iter ++) {
				prepared_sdp_atom[element_per_payload_prepared] = delivery_sram_group_[((delivery_sram_group_idx_fetched_ + atom_per_mac_cell_iter) * round_stride_accu + mac_cell_iter) % SRAM_GROUP_SIZE];
                element_per_payload_prepared += 1;
                if (element_per_payload_prepared % element_per_payload == 0) {
#if LOG_DETAIL
                    cslDebug((70, "prepared_sdp_atom for atom:%d:\n", atom_per_mac_cell_iter));
					for (int i = 0;i < element_per_payload; i++) {
                        cslDebug((70, "0x%04x, ", prepared_sdp_atom[i].to_int()));
                    }
                    cslDebug((70, "\n"));
#endif
                    to_sdp_fifo_->write(prepared_sdp_atom);
                }
            }
            atom_num_sent++;
        }

        accu2sc_credit_payload.size = atom_per_mac_cell;
        accu2sc_credit_b_transport(&accu2sc_credit_payload, b_transport_delay_);
    }

    deliver_prev_conv_mode_ = conv_mode;
    deliver_prev_precision_ = precision;
    cslDebug((50, "NV_NVDLA_cacc::DeliverSequencerDirectConvCommon delivery_sram_group_idx_available_=0x%x\n", delivery_sram_group_idx_available_));
    cslDebug((50, "NV_NVDLA_cacc::DeliverSequencerDirectConvCommon delivery_sram_group_idx_fetched_=0x%x\n", delivery_sram_group_idx_fetched_));

    cslDebug((50, "CACC delivery Done. consumer pointer is %d\n", cacc_consumer_));
}

void NV_NVDLA_cacc::ReshapeSequencerDirectConvCommon() {
    // Config variables, they have corresponding value in registers
    uint32_t    precision;
    uint32_t    cube_width;
    uint32_t    cube_height;
    uint32_t    cube_channel;
    uint32_t    conv_mode;
    uint32_t    clip_truncate;
    uint32_t    batch_num;
    // Control variables
    uint8_t     mac_cell_iter;
    uint64_t    atom_num_sent, atom_num, batch_atom_num;
    uint32_t    round_stride_accu;
    uint32_t    channel_num;
    uint32_t    atom_per_mac_cell;
    uint8_t     atom_per_mac_cell_iter;

    sc_int<ACCU_ASSEMBLY_BIT_WIDTH_INT16> assembly_int16;
    sc_uint<48> fp16_assembly_data;
    sc_int<32>  fp16_delivery_data;
    sc_uint<FP16_ALEN> fp16_assembly_value;
    sc_int<32>  truncator_signed_part;
    sc_int<32>  truncator_remained_part;

    uint32_t assembly_idx;
    uint32_t delivery_idx;
    sc_int<48> assembly_value;
    sc_int<48> rouding_addend;
    sc_int<48> truncated_result_tmp;
    sc_int<48> truncated_result;

    uint32_t nan_num=0;
    uint32_t total_case=0;
    CaccConfig* cacc_config;

    assembly2reshape_config_fifo_->read(cacc_config);

    precision       = cacc_config->cacc_proc_precision_;
    cube_width      = cacc_config->cacc_dataout_width_ + 1;
    cube_height     = cacc_config->cacc_dataout_height_ + 1;
    cube_channel    = cacc_config->cacc_dataout_channel_ + 1;
    conv_mode       = cacc_config->cacc_conv_mode_;
    batch_num       = cacc_config->cacc_batches_ + 1;
    clip_truncate   = cacc_config->cacc_clip_truncate_;
    delete cacc_config;

	round_stride_accu = MAC_CELL_NUM;

    // Evaluated
    if (CONV_MODE_WINOGRAD == conv_mode) {
        atom_per_mac_cell = 4;
    } else {
        atom_per_mac_cell = 1;
    }

	channel_num = ((cube_channel + NVDLA_MEMORY_ATOMIC_SIZE - 1) / NVDLA_MEMORY_ATOMIC_SIZE) * NVDLA_MEMORY_ATOMIC_SIZE;
	atom_num = uint64_t(cube_width) * cube_height * channel_num / NVDLA_MEMORY_ATOMIC_SIZE;
    batch_atom_num = batch_num * atom_num;

    atom_num_sent = 0;
    while (atom_num_sent < batch_atom_num) {
        WaitUntilThereIsAvaliableDataInAssemblyGroup();
        if (reshape_first_layer) {  // first layer and first atom
            assembly_sram_group_idx_fetched_    = 0;
            delivery_sram_group_idx_available_  = 0;
            reshape_first_layer = false;
        } else if (0!=atom_num_sent) {
            assembly_sram_group_idx_fetched_    += atom_per_mac_cell;
            delivery_sram_group_idx_available_  += atom_per_mac_cell;
        } else {
            if (reshape_prev_conv_mode_ == CONV_MODE_WINOGRAD) {
                assembly_sram_group_idx_fetched_    += 4;
                delivery_sram_group_idx_available_  += 4;
            } else {
                assembly_sram_group_idx_fetched_    += 1;
                delivery_sram_group_idx_available_  += 1;
            }
        }
        cslDebug((50, "NV_NVDLA_cacc::ReshapeSequencerDirectConvCommon, assembly_sram_group_idx_fetched_=0x%x\n", assembly_sram_group_idx_fetched_));
        cslDebug((50, "NV_NVDLA_cacc::ReshapeSequencerDirectConvCommon, delivery_sram_group_idx_available_=0x%x\n", delivery_sram_group_idx_available_));
        cslDebug((50, "NV_NVDLA_cacc::ReshapeSequencerDirectConvCommon, before truncation\n"));
        for (mac_cell_iter = 0; mac_cell_iter < MAC_CELL_NUM; mac_cell_iter ++) {
            switch (precision) {
                case DATA_FORMAT_INT8:
                case DATA_FORMAT_INT16:
                    // ACCU_ASSEMBLY_BIT_WIDTH_INT16 = 48
                    // ACCU_DELIVERY_BIT_WIDTH_INT16 = 32
					for (atom_per_mac_cell_iter = 0; atom_per_mac_cell_iter < atom_per_mac_cell; atom_per_mac_cell_iter++) {
						assembly_idx = ((assembly_sram_group_idx_fetched_ + atom_per_mac_cell_iter) * round_stride_accu + mac_cell_iter) % SRAM_GROUP_SIZE;
						delivery_idx = ((delivery_sram_group_idx_available_ + atom_per_mac_cell_iter) * round_stride_accu + mac_cell_iter) % SRAM_GROUP_SIZE;
                        assembly_value = assembly_sram_group_[assembly_idx];
#if 0
                        if (0 == clip_truncate) {
                            rouding_addend = 0;
                        } else {
                            rouding_addend = 1 << (clip_truncate - 1);
                        }
                        if(assembly_value > 0)
                            truncated_result_tmp = assembly_value + rouding_addend;
                        else
                            truncated_result_tmp = assembly_value;
                        truncated_result = truncated_result_tmp >> clip_truncate;
#else
                        int64_t in = assembly_value.to_int64();
                        double   fp_in = in;
                        double   scale = pow(2, clip_truncate);
                        double   out = fp_in /scale;

                        truncated_result = (int64_t)(out > 0 ? out+0.5 : out-0.5);
#endif
                        cslDebug((50, "NV_NVDLA_cacc::ReshapeSequencerDirectConvCommon, assembly_sram_group_[0x%x] is 0x%016lx\n", assembly_idx, (int64_t)(assembly_value.to_int64())));
                        cslDebug((50, "NV_NVDLA_cacc::ReshapeSequencerDirectConvCommon, assembly_sram_group_[0x%x][ACCU_ASSEMBLY_BIT_WIDTH_INT16-1] is 0x%x\n", assembly_idx, (uint32_t)(assembly_value[ACCU_ASSEMBLY_BIT_WIDTH_INT16-1])));
                        cslDebug((50, "NV_NVDLA_cacc::ReshapeSequencerDirectConvCommon, truncated_result is 0x%16lx\n", (uint64_t)(truncated_result.to_uint64())));
                        if ( truncated_result.to_int64() > (int64_t)INT32_MAX ) {
                            // Overflow
                            delivery_sram_group_[delivery_idx] = INT32_MAX;
                            saturation_num_perlayer_++;
                        } else if (truncated_result.to_int64() < (int64_t)INT32_MIN ) {
                            // Underflow
                            delivery_sram_group_[delivery_idx] = INT32_MIN;
                            saturation_num_perlayer_++;
                        } else {
                            delivery_sram_group_[delivery_idx] = truncated_result.range(ACCU_DELIVERY_BIT_WIDTH_INT16 - 1, 0);
                        }
                        cslDebug((50, "    delivery_sram_group_[0x%x]: 0x%08x, saturation_num_perlayer_:%d\n", delivery_idx, (uint32_t)delivery_sram_group_[delivery_idx].to_int(), saturation_num_perlayer_));
                    }
                    break;
                case DATA_FORMAT_FP16:
					for (atom_per_mac_cell_iter = 0; atom_per_mac_cell_iter < atom_per_mac_cell; atom_per_mac_cell_iter++) {
						assembly_idx = ((assembly_sram_group_idx_fetched_ + atom_per_mac_cell_iter) * round_stride_accu + mac_cell_iter) % SRAM_GROUP_SIZE;
						delivery_idx = ((delivery_sram_group_idx_available_ + atom_per_mac_cell_iter) * round_stride_accu + mac_cell_iter) % SRAM_GROUP_SIZE;
                        fp16_assembly_value = assembly_sram_group_[assembly_idx];

						cacc_fp48_to_fp32(&fp16_delivery_data, fp16_assembly_value);  // from FP48 to FP32
						total_case++;
						if((fp16_delivery_data.range(30,23)==255) && (fp16_delivery_data.range(22,0)!=0))
							nan_num++;
						delivery_sram_group_[delivery_idx] = fp16_delivery_data;
                    }
                    break;
            }
        }
        atom_num_sent += atom_per_mac_cell;
        delivery_sram_group_idx_available_incr_.notify();
    }
    // prev_layer_delivery_sram_group_idx_available_ = delivery_sram_group_idx_available_;
    //cout<<"stepheng: FP32 output nan statictic percent is "<<nan_num/total_case<<endl;
    reshape_prev_conv_mode_ = conv_mode;
    reshape_prev_precision_ = precision;
    cslDebug((50, "NV_NVDLA_cacc::ReshapeSequencerDirectConvCommon, end of layer, assembly_sram_group_idx_fetched_=0x%x\n", assembly_sram_group_idx_fetched_));
    cslDebug((50, "NV_NVDLA_cacc::ReshapeSequencerDirectConvCommon, end of layer, delivery_sram_group_idx_available_=0x%x\n", delivery_sram_group_idx_available_));
}

// Data from MAC, target socket
// Be awared, this interface follows valid-only protocol, there should not be any back pressure one this target socket
// Data layout inside payload/assembly_sram_entry/delivery_sram_entry
/*
// |<---------------------------------------  16 MAC_CELL   -------------------------------------->|
// |----MAC_CELL_STRIDE----|----MAC_CELL_STRIDE----|----MAC_CELL_STRIDE----|----MAC_CELL_STRIDE----|
// |                       \_______________________________________________________________________
// | Inside each MAC_CELL_STRIDE                                                                   \
// |        | Element numbers |                            Element bit width                       |
// |--------------------------| MAC2ACCU Payload ==== assembly_sram_entry ==== delivery_sram_entry |
// | INT8:  |   8 elements    |     23                         32                      16  
// | INT16: |   4 elements    |     46                         48                      32
// | FP16:  |   4 elements    |     32                         32                      16
*/
void NV_NVDLA_cacc::mac2accu_b_transport(nvdla_mac2accu_data_concat_if_t* payload, sc_time& delay) {
    // Config variables, they have corresponding value in registers
    uint32_t    precision;
    uint32_t    conv_mode;
    // Control variables
    uint16_t    mac_cell_iter;
    uint16_t    atom_iter;
    uint32_t    round_stride_accu;
    uint32_t    atom_per_mac_cell;
    uint32_t    payload_idx;
    uint32_t    assembly_idx;
    sc_int<MAC_OUTPUT_BIT_WIDTH_INT8>     *payload_data_ptr;    //sc_int<22>
    sc_int<38>  int16_mac_data;
    sc_int<22>  int8_mac_data;
    sc_int<49>  sum_tmp;
    // For float point calculation
    sc_uint<44> fp16_mac_data;
    sc_uint<FP16_ALEN> fp16_accu_data;
    //float       *fp16_mac_data_ptr;
    //float       *fp16_accu_data_ptr;
    //fp16_mac_data_ptr  = reinterpret_cast <float *> (&fp16_mac_data);
    //fp16_accu_data_ptr = reinterpret_cast <float *> (&fp16_accu_data);

    payload_data_ptr = payload->data;
    mac2cacc_count++;
    cslDebug((50, "mac2cacc_count = %d\n", mac2cacc_count));
    cslDebug((50, "payload->pd.nvdla_stripe_info.stripe_end = %d\n", (unsigned int)payload->pd.nvdla_stripe_info.stripe_end));
    cslDebug((50, "payload->pd.nvdla_stripe_info.channel_end = %d\n", (unsigned int)payload->pd.nvdla_stripe_info.channel_end));
#if LOG_DETAIL
    for (int i=0;i<MAC_CELL_NUM*8;i++)    // each element is sc_int<22>
        cslDebug((70, "    mac2cacc payload[%d]: 0x%08x\n", i, (uint32_t)payload_data_ptr[i].to_int()));
#endif

    if (is_assembly_working_ == false) {
        wait(cacc_kickoff_);
        // cacc should be kicked off before other cc sub-units
        // FAIL(("NV_NVDLA_cacc::mac2accu_b_transport, CACCU is not in working status."));
    }
    
    // Copy from register value to local config variables, similar with RTL connection
    precision = cacc_proc_precision_;
    conv_mode = cacc_conv_mode_;

	round_stride_accu = MAC_CELL_NUM;

    // Evaluated
    // atom_per_mac_cell is the number of atoms per mac cell to output to SDP
    if (CONV_MODE_WINOGRAD == conv_mode) {
        atom_per_mac_cell = 4;
    } else {
        atom_per_mac_cell = 1;
    }

    //typedef struct nvdla_stripe_info_s {
    //  uint8_t redundant;
    //  uint8_t layer_end;
    //  uint8_t channel_end;
    //  uint8_t stripe_end;
    //  uint8_t stripe_st;
    //  uint8_t batch_index;
    //} nvdla_stripe_info_t;
    //
    // union nvdla_mac2accu_data_if_u {
    //     nvdla_stripe_info_t nvdla_stripe_info;
    // };
    // typedef struct nvdla_mac2accu_data_if_s {
    //     uint16_t mask ; 
    //     sc_int<22> data [16*8];
    //     union nvdla_mac2accu_data_if_u pd ;
    // } nvdla_mac2accu_data_if_t;
    cslDebug((50, "NV_NVDLA_cacc::mac2accu_b_transport, assembly_sram_group_idx_working_ is 0x%x\n", assembly_sram_group_idx_working_));
    if (assembly_sram_group_idx_working_ <= prev_layer_assembly_sram_group_idx_available_)
        FAIL(("The value of assembly_sram_group_idx_working_ is wrong. assembly_sram_group_idx_working_=0x%x prev_layer_assembly_sram_group_idx_available_=0x%x\n", assembly_sram_group_idx_working_, prev_layer_assembly_sram_group_idx_available_));
    if (false == has_ongoing_channel_operation_) {
        // has_ongoing_channel_operation_ = true;
        // Start of a new output stripe, directly write mac data to ACCU
        cslDebug((50, "NV_NVDLA_cacc::mac2accu_b_transport, assembly, the first stripe of a channel operation\n"));
        for (mac_cell_iter = 0; mac_cell_iter < MAC_CELL_NUM; mac_cell_iter ++) {
			for (atom_iter = 0; atom_iter < atom_per_mac_cell; atom_iter++) {
                switch (precision) {
                    case DATA_FORMAT_INT8:
						payload_idx = mac_cell_iter * RESULT_NUM_PER_MACCELL + atom_iter * 1;
						assembly_idx = ((assembly_sram_group_idx_working_ + atom_iter) * round_stride_accu + mac_cell_iter) % SRAM_GROUP_SIZE;
						int8_mac_data = payload_data_ptr[payload_idx];
                        assembly_sram_group_[assembly_idx] = int8_mac_data;
#if LOG_DETAIL
                        cslDebug((50, "    mac_cell_iter is 0x%x\n", mac_cell_iter));
                        cslDebug((50, "    atom_iter is 0x%x\n", atom_iter));
                        cslDebug((50, "    int8_mac_data: 0x%016x\n", (uint32_t)int8_mac_data.to_int()));
                        cslDebug((50, "    int8 assembly_sram_group_[%d]: 0x%016x\n", assembly_idx, (uint32_t)assembly_sram_group_[assembly_idx].to_int()));
#endif
                        break;
                    case DATA_FORMAT_INT16:
						payload_idx = mac_cell_iter * RESULT_NUM_PER_MACCELL + atom_iter * 2;
						assembly_idx = ((assembly_sram_group_idx_working_ + atom_iter) * round_stride_accu + mac_cell_iter) % SRAM_GROUP_SIZE;
						int16_mac_data = (payload_data_ptr[payload_idx + 1], payload_data_ptr[payload_idx]);
                        assembly_sram_group_[assembly_idx] = int16_mac_data;
#if LOG_DETAIL
                        cslDebug((50, "    mac_cell_iter is 0x%x\n", mac_cell_iter));
                        cslDebug((50, "    atom_iter is 0x%x\n", atom_iter));
                        cslDebug((50, "    int16_cmac_data is 0x%016lx\n", (int64_t)int16_mac_data.to_int64()));
                        cslDebug((50, "    int16 assembly_sram_group_[%d]: 0x%016lx\n", assembly_idx, (int64_t)assembly_sram_group_[assembly_idx].to_int64()));
#endif
                        break;
                    case DATA_FORMAT_FP16:
						payload_idx = mac_cell_iter * RESULT_NUM_PER_MACCELL + atom_iter * 2;
						assembly_idx = ((assembly_sram_group_idx_working_ + atom_iter) * round_stride_accu + mac_cell_iter) % SRAM_GROUP_SIZE;
						fp16_mac_data = (payload_data_ptr[payload_idx + 1], payload_data_ptr[payload_idx]);
                        fp16_accu_data = 0;
                        cacc_fp16_add(&fp16_accu_data, fp16_mac_data);
                        assembly_sram_group_[assembly_idx] = fp16_accu_data;
                        //cout <<"stepheng0, fp16_accu_data cacc result is "<< fp16_accu_data <<",assembly_idx is "<< assembly_idx<< endl;
#if LOG_DETAIL
                        cslDebug((50, "    mac_cell_iter is 0x%x\n", mac_cell_iter));
                        cslDebug((50, "    atom_iter is 0x%x\n", atom_iter));
                        cslDebug((50, "    int16_cmac_data is 0x%016lx\n", (int64_t)fp16_mac_data.to_int64()));
                        cslDebug((50, "    int16 assembly_sram_group_[%d]: 0x%016lx\n", assembly_idx, (int64_t)assembly_sram_group_[assembly_idx].to_int64()));
#endif
                        break;
                }
            }
        }
    } else {
        // Not the start of a new output stripe, accumulate mac data to ACCU
        cslDebug((50, "NV_NVDLA_cacc::mac2accu_b_transport, assembly, not the first stripe of a channel operation\n"));
        for (mac_cell_iter = 0; mac_cell_iter < MAC_CELL_NUM; mac_cell_iter ++) {
			for (atom_iter = 0; atom_iter < atom_per_mac_cell; atom_iter++) {
                switch (precision) {
                    case DATA_FORMAT_INT8:
						payload_idx = mac_cell_iter * RESULT_NUM_PER_MACCELL + atom_iter * 1;
						assembly_idx = ((assembly_sram_group_idx_working_ + atom_iter) * round_stride_accu + mac_cell_iter) % SRAM_GROUP_SIZE;
                        int8_mac_data  = payload_data_ptr[payload_idx];
                        sum_tmp = assembly_sram_group_[assembly_idx];
                        sum_tmp += int8_mac_data;
                        if (sum_tmp > MAX_INT_48BITS)
                            sum_tmp = MAX_INT_48BITS;
                        else if (sum_tmp < MIN_INT_48BITS)
                            sum_tmp = MIN_INT_48BITS;
                        assembly_sram_group_[assembly_idx] = sum_tmp;
#if LOG_DETAIL
                        cslDebug((50, "    mac_cell_iter is 0x%x\n", mac_cell_iter));
                        cslDebug((50, "    atom_iter is 0x%x\n", atom_iter));
                        cslDebug((50, "    int8_mac_data: 0x%016x\n", (uint32_t)int8_mac_data.to_int()));
                        cslDebug((50, "    int8 assembly_sram_group_[%d]: 0x%016x\n", assembly_idx, (uint32_t)assembly_sram_group_[assembly_idx].to_int()));
#endif
                        break;
                    case DATA_FORMAT_INT16:
						payload_idx = mac_cell_iter * RESULT_NUM_PER_MACCELL + atom_iter * 2;
						assembly_idx = ((assembly_sram_group_idx_working_ + atom_iter) * round_stride_accu + mac_cell_iter) % SRAM_GROUP_SIZE;
                        int16_mac_data  = (payload_data_ptr[payload_idx+1], payload_data_ptr[payload_idx]); //36bits
                        sum_tmp = assembly_sram_group_[assembly_idx];
                        sum_tmp += int16_mac_data;
                        if (sum_tmp > MAX_INT_48BITS)
                            sum_tmp = MAX_INT_48BITS;
                        else if (sum_tmp < MIN_INT_48BITS)
                            sum_tmp = MIN_INT_48BITS;
                        assembly_sram_group_[assembly_idx] = sum_tmp;
#if LOG_DETAIL
                        cslDebug((50, "    mac_cell_iter is 0x%x\n", mac_cell_iter));
                        cslDebug((50, "    atom_iter is 0x%x\n", atom_iter));
                        cslDebug((50, "    int16_mac_data is 0x%016lx\n", (int64_t)int16_mac_data.to_int64()));
                        cslDebug((50, "    int16 assembly_sram_group_[%d]: 0x%016lx\n", assembly_idx, (int64_t)assembly_sram_group_[assembly_idx].to_int64()));
#endif
                        break;
                    case DATA_FORMAT_FP16:
						payload_idx = mac_cell_iter * RESULT_NUM_PER_MACCELL + atom_iter * 2;
                        assembly_idx = ((assembly_sram_group_idx_working_+atom_iter)*round_stride_accu+mac_cell_iter)%SRAM_GROUP_SIZE;
                        fp16_mac_data  = (payload_data_ptr[payload_idx+1], payload_data_ptr[payload_idx]);
                        fp16_accu_data = assembly_sram_group_[assembly_idx]; // assembly_sram_group_[0] is 48bits
                        //stepheng, add debug
                        //cout <<"stepheng1, fp16_accu_data before cacc value is "<< fp16_accu_data <<",assembly_idx is "<< assembly_idx<< endl;
                        cacc_fp16_add(&fp16_accu_data, fp16_mac_data);
                        assembly_sram_group_[assembly_idx] = fp16_accu_data;
#if LOG_DETAIL
                        cslDebug((50, "    mac_cell_iter is 0x%x\n", mac_cell_iter));
                        cslDebug((50, "    atom_iter is 0x%x\n", atom_iter));
                        cslDebug((50, "    fp16_mac_data is 0x%016lx\n", (int64_t)fp16_mac_data.to_int64()));
                        cslDebug((50, "    fp16 assembly_sram_group_[%d]: 0x%016lx\n", assembly_idx, (int64_t)assembly_sram_group_[assembly_idx].to_int64()));
#endif
                        break;
                    default:
                        break;
                }
            }
        }
    }

    if (1 == payload->pd.nvdla_stripe_info.channel_end) {   // The last stripe of current channel
        // Come to a channel end. Finish current stripe. We got the sums of current stripe.
        assembly_sram_group_idx_available_ = assembly_sram_group_idx_working_;
        cslDebug((50, "NV_NVDLA_cacc::mac2accu_b_transport, end of channel operation, assembly_sram_group_idx_available_=0x%x\n", assembly_sram_group_idx_available_));
        assembly_sram_group_idx_available_incr_.notify();
        if ((assembly_sram_group_idx_available_ - assembly_sram_group_idx_fetched_) > SRAM_GROUP_SIZE)   // In unit of 16 entries in buffer
            FAIL(("cacc assembly group will overflow. assembly_sram_group_idx_available_=%d assembly_sram_group_idx_fetched_=%d\n", assembly_sram_group_idx_available_, assembly_sram_group_idx_fetched_));
        // If layer_end, assembly_sram_group_idx_working_ points to the start entry of next layer
        assembly_sram_group_idx_working_ += atom_per_mac_cell;
        cslDebug((50, "NV_NVDLA_cacc::mac2accu_b_transport, end of channel operation, assembly_sram_group_idx_working_=0x%x\n", assembly_sram_group_idx_working_));
        if (1 == payload->pd.nvdla_stripe_info.stripe_end) {
            has_ongoing_channel_operation_ = false;
            cslDebug((50, "NV_NVDLA_cacc::mac2accu_b_transport, end of channel operation and end of stripe operation\n"));
        }
        input_first_channel = false;
    } else {
        if (1 == payload->pd.nvdla_stripe_info.stripe_end) {
            // Restart from the beginning of the stripe
            if (input_first_layer && input_first_channel) {
                assembly_sram_group_idx_working_ = 0;
            }
            else if (!input_first_layer && input_first_channel) {
                // update assembly_sram_group_idx_working_ to the beginning of current layer
                assembly_sram_group_idx_working_ = saved_assembly_sram_group_idx_working_;
            }
            else {
                assembly_sram_group_idx_working_ = assembly_sram_group_idx_available_ + atom_per_mac_cell;
            }
            has_ongoing_channel_operation_ = true;
            cslDebug((50, "NV_NVDLA_cacc::mac2accu_b_transport, end of stripe operation, assembly_sram_group_idx_available_=0x%x\n", assembly_sram_group_idx_available_));
            cslDebug((50, "NV_NVDLA_cacc::mac2accu_b_transport, end of stripe operation, assembly_sram_group_idx_working_=0x%x\n", assembly_sram_group_idx_working_));
        }
        else {  // Not stripe end and not channel end
            //assembly_sram_group_idx_working_ points to the next entry for process
            assembly_sram_group_idx_working_ += atom_per_mac_cell;
            cslDebug((50, "yilinz: atom_per_mac_cell=%d, working:%d\n", atom_per_mac_cell, assembly_sram_group_idx_working_));
            cslDebug((50, "NV_NVDLA_cacc::mac2accu_b_transport, not end of stripe operation, assembly_sram_group_idx_available_=0x%x\n", assembly_sram_group_idx_available_));
            cslDebug((50, "NV_NVDLA_cacc::mac2accu_b_transport, not end of stripe operation, assembly_sram_group_idx_working_=0x%x\n", assembly_sram_group_idx_working_));
        }
    }

    if ((1 == payload->pd.nvdla_stripe_info.stripe_end) && (1 == payload->pd.nvdla_stripe_info.layer_end)) {
        mac2cacc_count=0;
        cslDebug((50, "NV_NVDLA_cacc::mac2accu_b_transport, end of layer.\n"));
        cslDebug((50, "NV_NVDLA_cacc::mac2accu_b_transport, end of layer, assembly_sram_group_idx_available_=0x%x\n", assembly_sram_group_idx_available_));
        cslDebug((50, "NV_NVDLA_cacc::mac2accu_b_transport, end of layer, assembly_sram_group_idx_working_=0x%x\n", assembly_sram_group_idx_working_));

        is_assembly_working_ = false;
        input_first_channel  = true;    // For next layer
        input_first_layer    = false;
        // save assembly_sram_group_idx_working_ for next layer. it's assigned when channel_end
        saved_assembly_sram_group_idx_working_ = assembly_sram_group_idx_working_;
        // notify event cacc_done_, cacc can switch to next layer
        cacc_done_.notify();
        cslInfo(("cacc after cacc_done_.notify\n"));
        prev_layer_assembly_sram_group_idx_available_ = assembly_sram_group_idx_available_;
    }
}

void NV_NVDLA_cacc::WaitUntilThereIsAvaliableDataInAssemblyGroup () {
    while (true) {
        cslDebug((50, "assembly_sram_group_idx_available_=0x%x\n", assembly_sram_group_idx_available_));
        cslDebug((50, "assembly_sram_group_idx_fetched_=0x%x\n", assembly_sram_group_idx_fetched_));
        if (assembly_sram_group_idx_available_ <= assembly_sram_group_idx_fetched_) {
            wait (assembly_sram_group_idx_available_incr_);
        }
        else {
            break;
        }
    }
}

void NV_NVDLA_cacc::WaitUntilThereIsAvaliableDataInDeliveryGroup () {
    while (true) {
        cslDebug((50, "delivery_sram_group_idx_available_=0x%x\n", delivery_sram_group_idx_available_));
        cslDebug((50, "delivery_sram_group_idx_fetched_=0x%x\n", delivery_sram_group_idx_fetched_));
        if (delivery_sram_group_idx_available_ <= delivery_sram_group_idx_fetched_) {
            wait (delivery_sram_group_idx_available_incr_);
        }
        else {
            break;
        }
    }
}

// Input from cmac is FP44, the intermediate data is FP48
void NV_NVDLA_cacc::cacc_fp16_add(sc_uint<FP16_ALEN> *fp16_accu_data, sc_uint<44> fp16_mac_data) {
    sc_uint<6>  mac_in_exp          = fp16_mac_data.range(43, 38);
    sc_uint<38>  mac_in_mantisa_u      = fp16_mac_data.range(37,  0);
    sc_uint<FP16_ELEN>  accu_in_exp         = fp16_accu_data->range(FP16_ALEN-1, FP16_ALEN-FP16_ELEN);
    sc_uint<FP16_MLEN>  accu_in_mantisa_u     = fp16_accu_data->range(FP16_MLEN-1,  0);

    sc_int<40> sum_mantisa_tmp;
    sc_int<40> sum_mantisa;
    sc_int<FP16_MLEN> sum_mantisa_round;
    sc_int<FP16_MLEN> sum_mantisa_final;
	sc_uint<FP16_ELEN>  sum_exp;

    sc_int<38>  mac_in_mantisa;
    sc_int<FP16_MLEN>  accu_in_mantisa;
    int         exp_diff=0;
	int			num_need_left_shift0=0;
	int     	num_need_left_shift1=0;
	int 		real_exp_mac=0;
	int 		real_exp_accu=0;
	int			bigger_exp=0;
	int  		real_sum_exp=0;
	int			i=36;
    int         j=38;
	sc_int<38>  mac_in_mantisa_regulized=0;
	sc_uint<8>  mac_in_exp_regulized=0;
	
	sc_int<40> mac_in_mantisa_extended=0;
    sc_int<40> accu_in_mantisa_extended=0;
	sc_uint<40> shift_out_bits0=0;	
	sc_uint<1> shift_out_high_bit1=0;
	
	
	double in44=0;
	double in48=0;
	double out48_golden=0;
	double out48=0;
    double delta=0;
	int temp0=0; 
	int temp1=0; 
	int temp2=0;
    sc_uint<48> sticky0bits=0;
    sc_uint<48> sticky1bits=0;
    int overflow=0;
    int sticky0=0;
    int sticky1=0;
    int guard0=0;
    int guard1=0;
    int need_round=0;


 //transfer from sc_uint to sc_int
    mac_in_mantisa = mac_in_mantisa_u; 
    accu_in_mantisa = accu_in_mantisa_u;

    cslDebug((50, "  input FP44 is  : 0x%016lx\n",(int64_t)fp16_mac_data ));
    cslDebug((50, "  input FP48/FP39 is  : 0x%016lx\n",(int64_t)(fp16_accu_data->range(FP16_ALEN-1,0)) ));

if(FP16DEBUG_DETAIL){
    cout <<"step0:input original FP44 is "<<hex<< fp16_mac_data <<endl;
    cout <<"step0:input original FP48/FP39 is "<<hex<< (fp16_accu_data->range(FP16_ALEN-1,0))<<endl;
}

// Pure C hign level checker.
	//for debug,transfer FP44 input to float
	//temp0= mac_in_exp-60; //30+30
    temp0= mac_in_exp-50; //20+30. stepheng,20170405
    in44 = mac_in_mantisa * pow(2, temp0);
	
	//for debug,transfer FP48/FP39 input to float
    #ifdef CACC_FP39
	temp1= accu_in_exp-93; //63+30    
    #else
	temp1= accu_in_exp-101; //63+38	
    #endif
    in48 = accu_in_mantisa * pow(2, temp1);
	out48_golden=in44+in48;
	
	
//step1: handle input 0/NaN, regulize mac 44bit input.
	if(mac_in_mantisa==0)	{  //input mac is 0
        if(FP16DEBUG_DETAIL){cout<< "step5:the output FP48/FP39 is "<<hex<<fp16_accu_data->range(FP16_ALEN-1,0)<<endl;}
		return;
	}

	if(accu_in_exp.and_reduce())  {  //input accu is NaN
		fp16_accu_data->range(FP16_MLEN-12,0)=0;
        fp16_accu_data->range(FP16_MLEN-1,FP16_MLEN-11)=accu_in_mantisa.range(FP16_MLEN-1,FP16_MLEN-11);
        fp16_accu_data->range(FP16_ALEN-1,FP16_ALEN-FP16_ELEN)=255;
        if(FP16DEBUG_DETAIL){cout<< "step5:the output FP48/FP39 is "<<hex<<fp16_accu_data->range(FP16_ALEN-1,0)<<endl;}
		return;
	}	

    if(mac_in_exp.and_reduce())  {  //input mac is NaN 
		fp16_accu_data->range(FP16_MLEN-12,0)=0;
        fp16_accu_data->range(FP16_MLEN-1,FP16_MLEN-11)=mac_in_mantisa.range(37,27);
        fp16_accu_data->range(FP16_ALEN-1,FP16_ALEN-FP16_ELEN)=255;
        if(FP16DEBUG_DETAIL){cout<< "step5:the output FP48/FP39 is "<<hex<<fp16_accu_data->range(FP16_ALEN-1,0)<<endl;}
		return;
	}

	//left regulize mac input data
	if(mac_in_mantisa[37]==mac_in_mantisa[36]){
		for (i=36; i>=0;i--) {
			if(mac_in_mantisa[i]==mac_in_mantisa[37])
				continue;
			else
				break;
		}
	}

    num_need_left_shift0 =36-i;
	mac_in_mantisa_regulized= mac_in_mantisa<<num_need_left_shift0;
    mac_in_mantisa_extended.range(1,0)=0;
    mac_in_mantisa_extended.range(39,2)=mac_in_mantisa_regulized;

	//mac_in_exp_regulized= mac_in_exp-num_need_left_shift0+39; //(+6-30+63, bias 63)
    mac_in_exp_regulized= mac_in_exp-num_need_left_shift0+49; //(+16-30+63, bias 63), stepheng.20170405

//stepheng, 20170328, if FP39, need round,so can't use this any more.
/*	if(accu_in_mantisa==0)	{  //input accu is 0.
		cslDebug((50, "NV_NVDLA_cacc::cacc_fp16_add, input accu data is all 0! \n"));
		accu_in_exp = mac_in_exp_regulized;//63 bias
		accu_in_mantisa= mac_in_mantisa_extended;
         *fp16_accu_data =(accu_in_exp,accu_in_mantisa);
         return;
	}	
*/
  //stepheng. 20170510,if mantisa is 0, then exp need forced to 0.
    if(accu_in_mantisa==0)	{  //input accu is 0.
    accu_in_exp = 0;
    }

//stepheng, 20170328, extend FP48/FP39 mantisa to 40bit anyway, to make sure full precision.
    if (FP16_MLEN==40)  accu_in_mantisa_extended = accu_in_mantisa;
    else {
    accu_in_mantisa_extended.range(7,0)=0;
    accu_in_mantisa_extended.range(39,8)= accu_in_mantisa;
    }


//step2: right shift and get the same order/exp.
	real_exp_mac= mac_in_exp_regulized;//63 bias
	real_exp_accu= accu_in_exp; //63 bias
    bigger_exp = real_exp_mac;
    if ( real_exp_mac> real_exp_accu) {
        exp_diff =  real_exp_mac- real_exp_accu;
        if(exp_diff<=40){
		shift_out_bits0.range(39,40-exp_diff)= accu_in_mantisa_extended.range(exp_diff-1,0);
        accu_in_mantisa_extended = accu_in_mantisa_extended >> exp_diff; 	
        }
        else{
        accu_in_mantisa_extended=0;
        }
	}
	else if(real_exp_mac < real_exp_accu) {
		bigger_exp = real_exp_accu;
		exp_diff = real_exp_accu-real_exp_mac; 
        if(exp_diff<=40){
		shift_out_bits0.range(39,40-exp_diff)= mac_in_mantisa_extended.range(exp_diff-1,0);
        mac_in_mantisa_extended = mac_in_mantisa_extended >> exp_diff; 	
        }
        else{
        mac_in_mantisa_extended = 0;
        }
	}
    else    ; 
	
	
//step3: add mantisa, and regulize the result.	
    sum_mantisa_tmp = accu_in_mantisa_extended + mac_in_mantisa_extended;

// overflow or underflow,right regulize 1bit
    if ((mac_in_mantisa_extended[39]==accu_in_mantisa_extended[39]) && (mac_in_mantisa_extended[39]!=sum_mantisa_tmp[39])) {
		shift_out_high_bit1 = sum_mantisa_tmp[0];
        overflow=1;
		sum_mantisa = (mac_in_mantisa_extended[39],sum_mantisa_tmp.range(39,1));  
        real_sum_exp = bigger_exp + 1;
    }   
    else if (sum_mantisa_tmp[38]==sum_mantisa_tmp[39]){  //left regulize
			for (j=38; j>=0;j--) {
				if(sum_mantisa_tmp[j]==sum_mantisa_tmp[39])
					continue;
				else
					break;
			}
			num_need_left_shift1=38-j;
			//sum_mantisa = sum_mantisa_tmp << num_need_left_shift1;
            sum_mantisa = (sum_mantisa_tmp.range(39-num_need_left_shift1,0),shift_out_bits0(39,40-num_need_left_shift1));
            shift_out_bits0 = shift_out_bits0 << num_need_left_shift1; //stepheng.20170420
			real_sum_exp = bigger_exp - num_need_left_shift1;
        }
		else if (sum_mantisa_tmp[38]!=sum_mantisa_tmp[39]){
			 sum_mantisa = sum_mantisa_tmp;
			 real_sum_exp = bigger_exp;
		}
		else {
		cslDebug((50, "NV_NVDLA_cacc::cacc_fp16_add, error path!! need debug.\n"));	
	}


//step4: round back the shift bits. 
    if (FP16_MLEN==40) {
    guard0= shift_out_bits0[39];
    sticky0bits.range(47,9)= shift_out_bits0.range(38,0);
    sticky0 = sticky0bits.or_reduce();
    guard1= shift_out_high_bit1;
    sticky1bits.range(47,8)=shift_out_bits0;
    sticky1 = sticky1bits.or_reduce();
    }
    else {  //FP39
    guard0= sum_mantisa[7];
    sticky0bits.range(47,1)= (sum_mantisa.range(6,0),shift_out_bits0.range(39,0));
    sticky0 = sticky0bits.or_reduce();
    guard1= sum_mantisa[7];
    sticky1bits=(sum_mantisa.range(6,0),shift_out_high_bit1,shift_out_bits0.range(39,0));
    sticky1 = sticky1bits.or_reduce();  
    }

    need_round = overflow ? (sum_mantisa[39] ? guard1&&sticky1 : guard1) :  (sum_mantisa[39] ? guard0&&sticky0 : guard0);
	if(need_round){
	sum_mantisa_round = sum_mantisa.range(39,40-FP16_MLEN)+1;
	}
    else
    sum_mantisa_round = sum_mantisa.range(39,40-FP16_MLEN);

    if(FP16DEBUG_DETAIL){
    cout<<"step4:overflow: "<<overflow<<",result sign: "<<sum_mantisa[39]<<",guard0: "<<guard0<<",sticky0: "<<sticky0<<",guard1: "<<guard1<<",sticky1: "<<sticky1<<endl;
    }

	
//step5: check overflow and regulize.	
	if(sum_mantisa_round[FP16_MLEN-1] != sum_mantisa[39]){  //overflow, right regulize 1bit.
	sum_mantisa_final = (sum_mantisa[39],sum_mantisa_round(FP16_MLEN-1,1));	
	real_sum_exp++;
	}
	else {
	sum_mantisa_final = sum_mantisa_round;
	}

	sum_exp = real_sum_exp; //bias 63

    if (sum_mantisa_final==0) {
    sum_exp =0; //stepheng. 20170515.
    }

	*fp16_accu_data =(sum_exp,sum_mantisa_final);
    if(FP16DEBUG_DETAIL){cout<< "step5:the output FP48/FP39 is "<<hex<<fp16_accu_data->range(FP16_ALEN-1,0)<<endl;}
    cslDebug((50, " ***output FP48/FP39 is  : 0x%016lx\n",(int64_t)(fp16_accu_data->range(FP16_ALEN-1,0)) ));


//high level checker, for debug,transfer FP48/FP39 output to float
    #ifdef CACC_FP39
	temp2= sum_exp-93;	//63+30
    #else
	temp2= sum_exp-101;	//63+38
    #endif
    out48= sum_mantisa_final * pow(2, temp2);

    delta = 1*pow(2,temp2);
    
    if (fabs(out48-out48_golden)> delta){
        cerr <<"Error: CACC FP16 ADD output is not sync with high level checker!!"<<endl;
        cout<< "step5:output to float is "<<setiosflags(ios::scientific)<<setiosflags(ios::showpos)<< out48 << ",the golden float value is "<<setiosflags(ios::scientific)<<setiosflags(ios::showpos)<<out48_golden<<endl;
        cout <<"step5:|output minus golden| is "<< fabs(out48-out48_golden)<<endl;
        cout<< "step5:delta is "<<delta<<endl;
        exit(-1);
    }   
    else
     ;//cout<<"step5:CACC FP16 ADD output is sync with high level checker"<<endl;
}
	
		
	
//the input FP48 should be regulized data.
void NV_NVDLA_cacc::cacc_fp48_to_fp32(sc_int<32> *fp32_to_sdp, sc_uint<FP16_ALEN> fp16_accu_data) {
    sc_int<32>  to_sdp_tmp;
    sc_uint<FP16_ELEN>  accu_in_exp           = fp16_accu_data.range(FP16_ALEN-1, FP16_ALEN-FP16_ELEN);
    sc_uint<FP16_MLEN> accu_in_mantisa_u     = fp16_accu_data.range(FP16_MLEN-1,  0);
    sc_int<FP16_MLEN>  accu_in_mantisa;
    sc_int<25>  mantisa_temp=0;
    sc_uint<8>  exp_temp=0;
    sc_int<FP16_MLEN>  accu_in_mantisa_o=0; //yuanma
    sc_uint<FP16_MLEN-1> temp=0;
    int guard=0;
    //sc_uint<FP16_MLEN-26> sticky_bits=0;
    //int sticky=0;
    int need_round=0;
    int temp1=0;
    int temp2=0;
    double in48;
    double out32;
    double delta;
    sc_uint<8> out_exp;
    sc_uint<24> out_mantisa_u;

    cslDebug((50, " FP48-2-32, input FP48/FP39 is  : 0x%016lx\n", (int64_t)fp16_accu_data ));
    accu_in_mantisa = accu_in_mantisa_u;
	//is NaN
	if(accu_in_exp.and_reduce()){
	to_sdp_tmp[31] = accu_in_mantisa[FP16_MLEN-1];
	to_sdp_tmp.range(30,23) = 255;
	to_sdp_tmp.range(9,0) = accu_in_mantisa.range(FP16_MLEN-2, FP16_MLEN-11);
    to_sdp_tmp.range(22,10) = 0;
    *fp32_to_sdp = to_sdp_tmp;

    if(FP16DEBUG_DETAIL){
    cout <<"step6:the FP48/FP39 input is "<<hex<< fp16_accu_data.range(FP16_ALEN-1,0)<<endl;
    cout <<"* the FP32 output is * 0x"<<hex<< fp32_to_sdp->range(31,0) <<endl;
    }

    return;
	}
	else if(accu_in_mantisa[FP16_MLEN-1] && (accu_in_mantisa.range(FP16_MLEN-2,0).or_reduce()==0)){   //handle mantisa buma is -2.
    to_sdp_tmp[31] = accu_in_mantisa[FP16_MLEN-1];
    to_sdp_tmp.range(30,23) =  accu_in_exp+65; //+64+1
    to_sdp_tmp.range(22,0) = 0; 
    }
     else {
        //transfer from buma to yuanma
        temp =  ~accu_in_mantisa_u.range(FP16_MLEN-2,0)+1;
        if(accu_in_mantisa_u[FP16_MLEN-1]){
        accu_in_mantisa_o =  (accu_in_mantisa[FP16_MLEN-1],temp );
        }
        else
        accu_in_mantisa_o = accu_in_mantisa;


        exp_temp = (accu_in_mantisa_u.or_reduce()==0) ? 0: accu_in_exp+64; //-63+127
        guard=accu_in_mantisa_o[FP16_MLEN-26];
        need_round= guard;
        if(need_round){   //need round
        mantisa_temp  = 1 + accu_in_mantisa_o.range(FP16_MLEN-1, FP16_MLEN-25);  //round back 1.
            if(mantisa_temp[24]!=accu_in_mantisa_o[FP16_MLEN-1]) { // round back overflow, need right shift.
                mantisa_temp=(accu_in_mantisa[FP16_MLEN-1],mantisa_temp.range(24,1) );
                exp_temp++;
                to_sdp_tmp.range(22,0) = mantisa_temp.range(22,0);
            }
            else{  //no overflow
                to_sdp_tmp.range(22,0) = mantisa_temp.range(22,0);            
            }
        }
        else { //no need round
        to_sdp_tmp.range(22,0)  = accu_in_mantisa_o.range(FP16_MLEN-3, FP16_MLEN-25);  //remove the bias 1.      
        }
    to_sdp_tmp[31] = accu_in_mantisa_u[FP16_MLEN-1];
    to_sdp_tmp.range(30,23) = exp_temp;
	}
    *fp32_to_sdp = to_sdp_tmp;


    if(FP16DEBUG_DETAIL){
    cout <<"step6:the FP48/FP39 input is "<<hex<< fp16_accu_data.range(FP16_ALEN-1,0)<<endl;
    cout <<"* the FP32 output is * 0x"<<hex<< fp32_to_sdp->range(31,0) <<endl;
    }
    cslDebug((50, "FP48-2-32, output FP32 is  : 0x%016lx\n", (int64_t)(fp32_to_sdp->range(31,0)) ));


// pure C high level checker.
    #ifdef CACC_FP39
	temp1= accu_in_exp-93;	//63+30
    #else
	temp1= accu_in_exp-101;	//63+38
    #endif
    in48= accu_in_mantisa * pow(2, temp1);
    
    out_exp =  to_sdp_tmp.range(30,23);
    out_mantisa_u[23]= (to_sdp_tmp == 0) ? 0 : 1;
    out_mantisa_u.range(22,0) = to_sdp_tmp.range(22,0);
    temp2 = out_exp - 150; //127+23
    out32 = to_sdp_tmp[31] ? (0-out_mantisa_u * pow(2, temp2)) : out_mantisa_u * pow(2, temp2);
    delta = 1*pow(2,temp2);

    if (fabs(in48-out32)> delta){
        cerr <<"Error: CACC FP48-2-32 is not sync with high level checker!!"<<endl;
        cout<< "step6:input FP48 to float is "<<setiosflags(ios::scientific)<<setiosflags(ios::showpos)<< in48 << ",output FP32 to float is "<<setiosflags(ios::scientific)<<setiosflags(ios::showpos)<<out32<<endl;
        cout<< "step6:|FP48 minus FP32| is "<< fabs(in48-out32)<<endl;
        cout<< "step6:delta is "<<delta<<endl;
        exit(-1);
    }
    else
    ;//cout<< "step6:CACC FP48-2-32 is sync with high level checker!!"<<endl;

}



#pragma CTC SKIP
NV_NVDLA_cacc * NV_NVDLA_caccCon(sc_module_name name)
{
    return new NV_NVDLA_cacc(name);
}
#pragma CTC ENDSKIP
