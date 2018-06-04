// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_csc.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_csc.h"
#include "NV_NVDLA_csc_csc_gen.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "math.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define DATA_FORMAT_INT8        NVDLA_CSC_D_MISC_CFG_0_IN_PRECISION_INT8
#define DATA_FORMAT_INT16       NVDLA_CSC_D_MISC_CFG_0_IN_PRECISION_INT16
#define DATA_FORMAT_FP16        NVDLA_CSC_D_MISC_CFG_0_IN_PRECISION_FP16

#define LOG_DETAIL 0
#define ENABLE_WEIGHT_REUSE 1

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

const static bool USE_LUT = true;
const static bool NOT_USE_LUT = false;
#define ENABLE_PRA_LOG 1

enum CSC_OPERATION_MODE_ALIAS {
    CSC_MODE_FULL_DATA,
    CSC_MODE_DATA_REUSED,
    CSC_MODE_FULL_WEIGHT,
    CSC_MODE_WEIGHT_REUSED
};

enum CSC_DATA_LOAD_MODE_ALIAS {
    DATA_LOAD_MODE_DIRECT_CONV_NONE_BATCH,
    DATA_LOAD_MODE_DIRECT_CONV_BATCH,
    DATA_LOAD_MODE_IMAGE_CONV_NONE_BATCH,
    DATA_LOAD_MODE_IMAGE_CONV_BATCH,
    DATA_LOAD_MODE_WINOGRAD_CONV
};

enum CSC_WEIGHT_LOAD_MODE_ALIAS {
    WEIGHT_LOAD_MODE_DIRECT_CONV_NONE_BATCH,
    WEIGHT_LOAD_MODE_DIRECT_CONV,
    WEIGHT_LOAD_MODE_IMAGE_CONV_NONE_BATCH,
    WEIGHT_LOAD_MODE_IMAGE_CONV,
    WEIGHT_LOAD_MODE_WINOGRAD_CONV
};

NV_NVDLA_csc::NV_NVDLA_csc( sc_module_name module_name ):
    NV_NVDLA_csc_base(module_name),
    // Delay setup
    dma_delay_(SC_ZERO_TIME),
    csb_delay_(SC_ZERO_TIME),
    b_transport_delay_(SC_ZERO_TIME)
{
    // Memory allocation
    // csc2cbuf_data_payload_ = new nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t;
    // csc2cbuf_weight_payload_ = new nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t;
    data2sc_data_update_payload_ = new nvdla_dat_info_update_t;
    data2sc_weight_update_payload_ = new nvdla_wt_info_update_t;
    csc_act_share_buffer_  = new sc_core::sc_fifo <uint8_t> (CSC_LOCAL_BUFFER_SIZE);

    // For converting active operation to a passive operation
    cbuf_data_read_ = new sc_core::sc_fifo <sc_uint<64>*> (1);
    cbuf_weight_read_ = new sc_core::sc_fifo <sc_uint<64>*> (1);
    cbuf_wmb_read_ = new sc_core::sc_fifo <sc_uint<64>*> (1);
    cdma_updated_cbuf_data_fifo_ = new sc_core::sc_fifo <uint32_t> (16384);

    // Reset
    Reset();

    // SC_THREAD
    SC_THREAD(CscConsumerThread)
    SC_THREAD(DataLoadSequenceThread)
    // SC_THREAD(MeanDataReadSequenceThread)
    SC_THREAD(WeightLoadSequenceThread)
    // SC_THREAD()
}

#pragma CTC SKIP
NV_NVDLA_csc::~NV_NVDLA_csc() {
    // if( csc2cbuf_data_payload_ )   delete csc2cbuf_data_payload_;
    // if( csc2cbuf_weight_payload_ ) delete csc2cbuf_weight_payload_;
    if( data2sc_data_update_payload_ )  delete data2sc_data_update_payload_;
    if( data2sc_weight_update_payload_ )  delete data2sc_weight_update_payload_;
    if( csc_act_share_buffer_ )    delete csc_act_share_buffer_;
    if( cbuf_data_read_ )  delete cbuf_data_read_;
    if( cbuf_weight_read_ )  delete cbuf_weight_read_;
    if( cbuf_wmb_read_ )  delete cbuf_wmb_read_;
    // if(  )  delete ;
}
#pragma CTC ENDSKIP

void NV_NVDLA_csc::Reset()
{
    // Clear register and internal states
    CscRegReset();
    is_there_ongoing_csb2csc_response_      = false;
    cacc_free_entry_num_            = CACC_ENTRY_NUM;
    slice_idx_available_         = 0;
    slice_idx_available_         = 0;
    slice_idx_free_              = 0;
    slice_idx_free_              = 0;
    cacc_avaliable_entry_num_       = 0;
    data_entry_idx_available_       = 0;
    data_entry_idx_free_            = 0;
    weight_kernel_num_available_    = 0;
    weight_kernel_num_used_         = 0;
    weight_entry_idx_available_     = 0;
    weight_entry_idx_start_         = 0;
    weight_layer_start_byte_idx_    = 0;
    wmb_entry_idx_available_        = 0;
    wmb_entry_idx_start_            = 0;

    csc_dat_prev_skip_data_rls_ = false;
    csc_dat_prev_conv_mode_     = -1;
    csc_dat_prev_data_bank_     = -1;
    csc_dat_prev_weight_bank_   = -1;
    csc_dat_prev_input_data_format_ = -1;

    csc_wt_prev_skip_weight_rls_ = false;
    csc_wt_prev_conv_mode_     = -1;
    csc_wt_prev_data_bank_     = -1;
    csc_wt_prev_weight_bank_   = -1;
    csc_wt_prev_input_data_format_ = -1;

    // Used for recording kernel pointer in cbuf if weight reuse
#if ENABLE_WEIGHT_REUSE
    weight_kernel_num_used_prev_     = 0;
    weight_entry_idx_start_prev_     = 0;
#endif
}

void NV_NVDLA_csc::CscConsumerThread () {
    while (true) {
        while(CscGetOpeartionEnable(csc_register_group_0) != NVDLA_CSC_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_csc_reg_group_0_operation_enable);
        }
        csc_reg_model::CscUpdateWorkingStatus(0,1);
        csc_reg_model::CscUpdateVariables(csc_register_group_0);
        cslDebug((50, "CSC group 0 trigger\n"));
        CscHardwareLayerExecutionTrigger();
        csc_reg_model::CscUpdateWorkingStatus(0,0);
        csc_reg_model::CscClearOpeartionEnable(csc_register_group_0);

        while(CscGetOpeartionEnable(csc_register_group_1) != NVDLA_CSC_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_csc_reg_group_1_operation_enable);
        }
        csc_reg_model::CscUpdateWorkingStatus(1,1);
        csc_reg_model::CscUpdateVariables(csc_register_group_1);
        cslDebug((50, "CSC group 1 trigger\n"));
        CscHardwareLayerExecutionTrigger();
        csc_reg_model::CscUpdateWorkingStatus(1,0);
        csc_reg_model::CscClearOpeartionEnable(csc_register_group_1);
    }
}

void NV_NVDLA_csc::CscHardwareLayerExecutionTrigger () {
    kernel_switch_round_data_   = 0;
    kernel_switch_round_weight_ = 0;
    cslDebug((50, "calling csc_kickoff_.notify\n"));
    csc_kickoff_.notify();
    //wait(csc_data_fetch_done_);
    wait(csc_weight_fetch_done_);
    cslDebug((50, "CscHardwareLayerExecutionTrigger Done\n"));
}

void NV_NVDLA_csc::DataLoadSequenceThread () {
    uint32_t data_load_operation_mode;
    uint8_t  csc_dat_input_data_format_;
    while (true) {
        wait(csc_kickoff_);

        if (csc_conv_mode_ == NVDLA_CSC_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (csc_datain_format_ == NVDLA_CSC_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                csc_dat_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                csc_dat_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            csc_dat_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        if ((csc_dat_prev_conv_mode_ != csc_conv_mode_) || (csc_dat_prev_data_bank_ != csc_data_bank_) ||
            (csc_dat_prev_weight_bank_ != csc_weight_bank_) || (csc_dat_prev_input_data_format_ != csc_dat_input_data_format_)) {
            if ((csc_dat_prev_data_bank_ != csc_data_bank_)) {
                data_entry_idx_free_      = 0;
                data_entry_idx_available_ = 0;
                if (csc_prev_left_dat_entries_ > 0) {
                    dat_up_sc2cdma_payload.dat_slices  = csc_prev_left_dat_slices_;   // Release left data of previous layer in cbuf
                    dat_up_sc2cdma_payload.dat_entries = csc_prev_left_dat_entries_;
                    dat_up_sc2cdma_b_transport(&dat_up_sc2cdma_payload, b_transport_delay_);
                }
                cslInfo(("NV_NVDLA_csc::DataLoadSequenceThread. DATA_BANK changed.\n"));
            } else {
                if (csc_prev_left_dat_entries_ > 0) {   // Release left data of previous layer in cbuf
                    dat_up_sc2cdma_payload.dat_slices = csc_prev_left_dat_slices_;
                    dat_up_sc2cdma_payload.dat_entries = csc_prev_left_dat_entries_;
                    dat_up_sc2cdma_b_transport(&dat_up_sc2cdma_payload, b_transport_delay_);
                    data_entry_idx_free_ += csc_prev_left_dat_entries_;
                    cslInfo(("NV_NVDLA_csc::DataLoadSequenceThread. Not reuse previous layer's data. Partial data of previous layer was released. data_entry_idx_free_=0x%lx\n", data_entry_idx_free_));
                } else {
                    cslInfo(("NV_NVDLA_csc::DataLoadSequenceThread. Not reuse previous layer's data. All data of previous layer was released.  data_entry_idx_free_=0x%lx\n", data_entry_idx_free_));
                }
            }
            cslInfo(("NV_NVDLA_csc::DataLoadSequenceThread. Mode or BANK changed. Restart from 0 of cbuf\n"));
        }
        else if (csc_dat_prev_skip_data_rls_ && csc_data_reuse_ && (csc_dat_prev_conv_mode_ == csc_conv_mode_) &&
                (csc_dat_prev_data_bank_ == csc_data_bank_) && (csc_dat_prev_weight_bank_ == csc_weight_bank_) && (csc_dat_prev_input_data_format_ == csc_dat_input_data_format_)) {
            // reuse previous layer's entire data
            cslInfo(("NV_NVDLA_csc::DataLoadSequenceThread. reuse previous layer's entire data. data_entry_idx_free_=0x%lx data_entry_idx_available_=0x%lx\n", data_entry_idx_free_, data_entry_idx_available_));
        }
        else if (!csc_dat_prev_skip_data_rls_ && csc_data_reuse_ && (csc_dat_prev_conv_mode_ == csc_conv_mode_) &&
                (csc_dat_prev_data_bank_ == csc_data_bank_) && (csc_dat_prev_weight_bank_ == csc_weight_bank_) && (csc_dat_prev_input_data_format_ == csc_dat_input_data_format_)) {
            // reuse partial data of previous layer
            // Continue to use cbuf following the end of previous layer
            cslInfo(("NV_NVDLA_csc::DataLoadSequenceThread. reuse previous layer's partial data. data_entry_idx_free_=0x%lx data_entry_idx_available_=0x%lx\n", data_entry_idx_free_, data_entry_idx_available_));
        }
        else {
            // Not reuse data of previous layer
            if (csc_prev_left_dat_entries_ > 0) {   // Release left data of previous layer in cbuf
                dat_up_sc2cdma_payload.dat_slices = csc_prev_left_dat_slices_;
                dat_up_sc2cdma_payload.dat_entries = csc_prev_left_dat_entries_;
                dat_up_sc2cdma_b_transport(&dat_up_sc2cdma_payload, b_transport_delay_);
                data_entry_idx_free_ += csc_prev_left_dat_entries_;
                cslInfo(("NV_NVDLA_csc::DataLoadSequenceThread. Not reuse previous layer's data. Partial data of previous layer was released. data_entry_idx_free_=0x%lx\n", data_entry_idx_free_));
            } else {
                cslInfo(("NV_NVDLA_csc::DataLoadSequenceThread. Not reuse previous layer's data. All data of previous layer was released.  data_entry_idx_free_=0x%lx\n", data_entry_idx_free_));
            }
        }

        //notify cdma for kick off
        dat_up_sc2cdma_payload.dat_entries = 0;
        dat_up_sc2cdma_b_transport(&dat_up_sc2cdma_payload, b_transport_delay_);

        // Evaluation operation mode
        if (NVDLA_CSC_D_MISC_CFG_0_CONV_MODE_DIRECT == csc_conv_mode_) {
            // Direct convolution
            if ( NVDLA_CSC_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE == csc_datain_format_) {
                if (0 == csc_batches_) {
                    data_load_operation_mode = DATA_LOAD_MODE_DIRECT_CONV_NONE_BATCH;
                } else {
                    data_load_operation_mode = DATA_LOAD_MODE_DIRECT_CONV_BATCH;
                }
            }
            else if ( NVDLA_CSC_D_DATAIN_FORMAT_0_DATAIN_FORMAT_PIXEL == csc_datain_format_) {
                data_load_operation_mode = DATA_LOAD_MODE_IMAGE_CONV_NONE_BATCH;
            }
#pragma CTC SKIP
            else {  //HOG
                FAIL(("NV_NVDLA_csc::DataLoadSequenceThread, unsupport datain_format, csc_datain_format_ is 0x%X", csc_datain_format_));
            }
#pragma CTC ENDSKIP
        } else if (NVDLA_CSC_D_MISC_CFG_0_CONV_MODE_WINOGRAD == csc_conv_mode_) {
            // Winograd convolution
            data_load_operation_mode = DATA_LOAD_MODE_WINOGRAD_CONV;
#pragma CTC SKIP
        } else {
            FAIL(("NV_NVDLA_csc::DataLoadSequenceThread, unsupport mode, csc_conv_mode_ is 0x%X", csc_conv_mode_));
        }
#pragma CTC ENDSKIP

        // Call corresponding sequencer based on operation mode
        switch(data_load_operation_mode) {
            case DATA_LOAD_MODE_DIRECT_CONV_NONE_BATCH:
            case DATA_LOAD_MODE_DIRECT_CONV_BATCH:
                SendDataToMacSequencerDirectConvCommon();
                break;
            case DATA_LOAD_MODE_IMAGE_CONV_NONE_BATCH:
                SendImageDataToMacSequencerConvCommon();
                break;
#pragma CTC SKIP
            case DATA_LOAD_MODE_IMAGE_CONV_BATCH:
                FAIL(("NV_NVDLA_csc::DataLoadSequenceThread, image direct convolution sequences has not been implemented."));
                break;
#pragma CTC ENDSKIP
            case DATA_LOAD_MODE_WINOGRAD_CONV:
                cslInfo(("NV_NVDLA_csc::DataLoadSequenceThread calling SendDataToMacSequencerWinoConvCommon\n")); 
                SendDataToMacSequencerWinoConvCommon();
                break;
#pragma CTC SKIP
            default:
                FAIL(("invalid data_load_operation_mode\n"));
#pragma CTC ENDSKIP
        }

        int32_t  released_slice_num;
        if (NVDLA_CSC_D_MISC_CFG_0_SKIP_DATA_RLS_ENABLE == csc_skip_data_rls_) {
            // Not release slices in CBUF
            released_slice_num          = 0;
            csc_prev_left_dat_slices_   = (csc_batches_ + 1) * (csc_datain_height_ext_ + 1);
            csc_prev_left_dat_entries_  = csc_prev_left_dat_slices_ * (csc_entries_ + 1);
            cslInfo(("NV_NVDLA_csc::DataLoadSequenceThread, end of current layer. not release slices\n"));
        } else {
            // Release slices, the number is rls_slices_
            released_slice_num          = csc_rls_slices_ + 1;
            csc_prev_left_dat_slices_   = (csc_batches_ + 1) * (csc_datain_height_ext_ + 1) - released_slice_num;
            csc_prev_left_dat_entries_  = csc_prev_left_dat_slices_ * (csc_entries_ + 1);
            cslInfo(("NV_NVDLA_csc::DataLoadSequenceThread, end of current layer. released_slice_num=0x%x\n", released_slice_num));
        }

        // Advance data_entry_idx_free_
        data_entry_idx_free_ += released_slice_num * (csc_entries_ + 1);
        cslInfo(("NV_NVDLA_csc::DataLoadSequenceThread, end of current layer. data_entry_idx_free_=0x%lx\n", data_entry_idx_free_));
        // Release slices at the end of layer
        if (released_slice_num > 0) {
            dat_up_sc2cdma_payload.dat_slices   = released_slice_num;
            dat_up_sc2cdma_payload.dat_entries  = dat_up_sc2cdma_payload.dat_slices * (csc_entries_ + 1);
            dat_up_sc2cdma_b_transport(&dat_up_sc2cdma_payload, b_transport_delay_);
        }

        // Save info of previous layer
        csc_dat_prev_skip_data_rls_ = csc_skip_data_rls_;
        csc_dat_prev_conv_mode_ = csc_conv_mode_;
        csc_dat_prev_data_bank_ = csc_data_bank_;
        csc_dat_prev_weight_bank_ = csc_weight_bank_;

        if (csc_conv_mode_ == NVDLA_CSC_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (csc_datain_format_ == NVDLA_CSC_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                csc_dat_prev_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                csc_dat_prev_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            csc_dat_prev_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        // Send out done
        csc_data_fetch_done_.notify();
    }
}

void NV_NVDLA_csc::WeightLoadSequenceThread () {
    uint32_t weight_load_operation_mode;
    uint8_t  csc_wt_input_data_format_;
    while (true) {
        // Wait kick off event
        wait(csc_kickoff_);

        if (csc_conv_mode_ == NVDLA_CSC_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (csc_datain_format_ == NVDLA_CSC_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                csc_wt_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                csc_wt_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            csc_wt_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        if ((csc_wt_prev_conv_mode_ != csc_conv_mode_) || (csc_wt_prev_data_bank_ != csc_data_bank_) || (csc_wt_prev_weight_bank_ != csc_weight_bank_) || (csc_wt_prev_input_data_format_ != csc_wt_input_data_format_)) {
            if ((csc_dat_prev_data_bank_ != csc_data_bank_) || (csc_wt_prev_weight_bank_ != csc_weight_bank_)) { // reset cbuf pointers
                weight_kernel_num_available_= 0;
                weight_kernel_num_used_     = 0;
                weight_entry_idx_available_ = 0;

                weight_entry_idx_start_     = 0;
                // For weight uncompression only
                weight_layer_start_byte_idx_= 0;

#if ENABLE_WEIGHT_REUSE
                weight_kernel_num_used_prev_     = 0;
                weight_entry_idx_start_prev_     = 0;
                wmb_entry_idx_start_prev_        = 0;
#endif

                wmb_entry_idx_start_        = 0;
                wmb_entry_idx_available_    = 0;
                if (csc_wt_prev_skip_weight_rls_ && csc_prev_left_wt_entries_>0) {
                    wt_up_sc2cdma_payload.wt_kernels = csc_prev_left_wt_kernels_;   // Release the entire weight of previous layer in cbuf
                    wt_up_sc2cdma_payload.wt_entries = csc_prev_left_wt_entries_;
                    wt_up_sc2cdma_payload.wmb_entries = csc_prev_left_wmb_entries_;
                    wt_up_sc2cdma_b_transport(&wt_up_sc2cdma_payload, b_transport_delay_);
                }
                cslInfo(("NV_NVDLA_csc::WeightLoadSequenceThread. BANK changed. reset cbuf pointers\n"));
            } else {
#if ENABLE_WEIGHT_REUSE
                weight_kernel_num_used_prev_ = weight_kernel_num_used_; // weight_kernel_num_used_ may be increased in layer exeuction. save to weight_kernel_num_used_prev_
                weight_entry_idx_start_prev_ = weight_entry_idx_start_;
                wmb_entry_idx_start_prev_    = wmb_entry_idx_start_;
#endif
                // Update variable for weight uncompression mode
                weight_layer_start_byte_idx_   = weight_entry_idx_start_ * NVDLA_CBUF_BANK_WIDTH;
                if (csc_prev_left_wt_entries_>0) {   // Release left weight of previous layer in cbuf
                    wt_up_sc2cdma_payload.wt_kernels = csc_prev_left_wt_kernels_;
                    wt_up_sc2cdma_payload.wt_entries = csc_prev_left_wt_entries_;
                    wt_up_sc2cdma_payload.wmb_entries = csc_prev_left_wmb_entries_;
                    wt_up_sc2cdma_b_transport(&wt_up_sc2cdma_payload, b_transport_delay_);
                }
                cslInfo(("NV_NVDLA_csc::WeightLoadSequenceThread. BANK not change. not reset cbuf pointers\n"));
            }
            cslInfo(("NV_NVDLA_csc::WeightLoadSequenceThread. MODE or BANK changed.\n"));
        }
        else if (csc_wt_prev_skip_weight_rls_ && csc_weight_reuse_ && (csc_wt_prev_conv_mode_ == csc_conv_mode_) &&    // reuse previous layer's weight
                (csc_wt_prev_data_bank_ == csc_data_bank_) && (csc_wt_prev_weight_bank_ == csc_weight_bank_) && (csc_wt_prev_input_data_format_ == csc_wt_input_data_format_)) {
            cslInfo(("NV_NVDLA_csc::WeightLoadSequenceThread. reuse previous layer's weight. weight_entry_idx_start_=0x%lx weight_entry_idx_available_=0x%lx weight_layer_start_byte_idx_=0x%lx\n", weight_entry_idx_start_, weight_entry_idx_available_, weight_layer_start_byte_idx_));
#if ENABLE_WEIGHT_REUSE
            weight_kernel_num_used_ = weight_kernel_num_used_prev_;
            weight_entry_idx_start_ = weight_entry_idx_start_prev_;
            weight_layer_start_byte_idx_   = weight_entry_idx_start_ * NVDLA_CBUF_BANK_WIDTH;
            wmb_entry_idx_start_    = wmb_entry_idx_start_prev_;
#else
            FAIL(("Weight reuse configuration is not supported yet\n"));
#endif
        }
        else {    // not reuse previous layer's weight
#if ENABLE_WEIGHT_REUSE
            weight_kernel_num_used_prev_ = weight_kernel_num_used_; // weight_kernel_num_used_ may be increased in layer exeuction. save to weight_kernel_num_used_prev_
            weight_entry_idx_start_prev_ = weight_entry_idx_start_;
            wmb_entry_idx_start_prev_    = wmb_entry_idx_start_;
#endif
            // Update variable for weight uncompression mode
            weight_layer_start_byte_idx_   = weight_entry_idx_start_ * NVDLA_CBUF_BANK_WIDTH;
            if (csc_prev_left_wt_entries_>0) {   // Release left weight of previous layer in cbuf
                wt_up_sc2cdma_payload.wt_kernels = csc_prev_left_wt_kernels_;
                wt_up_sc2cdma_payload.wt_entries = csc_prev_left_wt_entries_;
                wt_up_sc2cdma_payload.wmb_entries = csc_prev_left_wmb_entries_;
                wt_up_sc2cdma_b_transport(&wt_up_sc2cdma_payload, b_transport_delay_);
            }
            cslInfo(("NV_NVDLA_csc::WeightLoadSequenceThread. Not reuse previous layer's weight. weight_entry_idx_start_=0x%lx weight_entry_idx_available_=0x%lx\n", weight_entry_idx_start_, weight_entry_idx_available_));
        }

        //notify cdma for kick off
        wt_up_sc2cdma_payload.wt_entries = 0;
        wt_up_sc2cdma_b_transport(&wt_up_sc2cdma_payload, b_transport_delay_);

        // Evaluation operation mode
        if (NVDLA_CSC_D_MISC_CFG_0_CONV_MODE_DIRECT == csc_conv_mode_) {
            // Direct convolution
            if ( NVDLA_CSC_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE == csc_datain_format_) {
                if (0 == csc_batches_) {
                    weight_load_operation_mode = WEIGHT_LOAD_MODE_DIRECT_CONV_NONE_BATCH;
                } else {
                    weight_load_operation_mode = WEIGHT_LOAD_MODE_DIRECT_CONV;
                }
            }
            else if ( NVDLA_CSC_D_DATAIN_FORMAT_0_DATAIN_FORMAT_PIXEL == csc_datain_format_) {
                weight_load_operation_mode = WEIGHT_LOAD_MODE_IMAGE_CONV_NONE_BATCH;
            }
            else {  //HOG
                FAIL(("NV_NVDLA_csc::DataLoadSequenceThread, unsupport datain_format, csc_datain_format_ is 0x%X", csc_datain_format_));
            }
        } else if (NVDLA_CSC_D_MISC_CFG_0_CONV_MODE_WINOGRAD == csc_conv_mode_) {
            // Winograd convolution
            weight_load_operation_mode = WEIGHT_LOAD_MODE_WINOGRAD_CONV;
        } else {
            FAIL(("NV_NVDLA_csc::WeightLoadSequenceThread, unsupport mode, csc_conv_mode_ is 0x%X", csc_conv_mode_));
        }

        // Call corresponding sequencer based on operation mode
        switch(weight_load_operation_mode) {
            case WEIGHT_LOAD_MODE_DIRECT_CONV_NONE_BATCH:
            case WEIGHT_LOAD_MODE_DIRECT_CONV:
                cslInfo(("NV_NVDLA_csc::WeightLoadSequenceThread calling SendWeightToMacSequencerDirectConvCommon\n")); 
                SendWeightToMacSequencerDirectConvCommon();
                break;
            case WEIGHT_LOAD_MODE_IMAGE_CONV_NONE_BATCH:
                cslInfo(("NV_NVDLA_csc::WeightLoadSequenceThread calling SendImageWeightToMacSequencerConvCommon\n")); 
                SendWeightToMacSequencerDirectConvCommon();
                //SendImageWeightToMacSequencerConvCommon();
                break;
            case WEIGHT_LOAD_MODE_IMAGE_CONV:
                FAIL(("NV_NVDLA_csc::WeightLoadSequenceThread, batch direct convolution sequences has not been implemented."));
                break;
            case WEIGHT_LOAD_MODE_WINOGRAD_CONV:
                cslInfo(("NV_NVDLA_csc::WeightLoadSequenceThread calling SendWeightToMacSequencerWinoConvCommon\n")); 
                SendWeightToMacSequencerWinoConvCommon();
                //FAIL(("NV_NVDLA_csc::WeightLoadSequenceThread, Winograd convolution sequences has not been implemented."));
                break;
#pragma CTC SKIP
            default:
                FAIL(("invalid weight_load_operation_mode\n"));
#pragma CTC ENDSKIP
        }

        if (NVDLA_CSC_D_MISC_CFG_0_SKIP_WEIGHT_RLS_ENABLE == csc_skip_weight_rls_) {
            // Not release weight in CBUF
            csc_prev_left_wt_kernels_ = csc_weight_kernel_ + 1;
            csc_prev_left_wt_entries_ = (csc_weight_bytes_ << NVDLA_CSC_D_WEIGHT_BYTES_0_WEIGHT_BYTES_SHIFT) / NVDLA_CBUF_BANK_WIDTH;  // The actual bytes of weight is csc_weight_bytes_*(1<<7)
            csc_prev_left_wmb_entries_ = (csc_wmb_bytes_ << NVDLA_CSC_D_WMB_BYTES_0_WMB_BYTES_SHIFT) / NVDLA_CBUF_BANK_WIDTH;  // The actual bytes of weight is csc_weight_bytes_*(2<<7)
            // If the weight is not used actually, the wt_up_sc2cdma_b_transport transaction is performed in the beginning of next layer
            // Update weight_kernel_num_used_ when layer ends if skip_weight_rls is true
            weight_kernel_num_used_ += (csc_weight_kernel_ + 1);
        } else {
            // release all kernels in CBUF
            csc_prev_left_wt_kernels_ = 0;
            csc_prev_left_wt_entries_ = 0;
            csc_prev_left_wmb_entries_ = 0;
        }

        csc_wt_prev_skip_weight_rls_ = csc_skip_weight_rls_;
        csc_wt_prev_conv_mode_ = csc_conv_mode_;
        csc_wt_prev_data_bank_ = csc_data_bank_;
        csc_wt_prev_weight_bank_ = csc_weight_bank_;

        if (csc_conv_mode_ == NVDLA_CSC_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (csc_datain_format_ == NVDLA_CSC_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                csc_wt_prev_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                csc_wt_prev_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            csc_wt_prev_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        // Send out done
        csc_data_fetch_done_.notify();
        wait(csc_data_fetch_done_);
        // Send out done
        csc_weight_fetch_done_.notify();
    }
}

// To step
// 1) Wait CDMA-CSC communication, get data from CBUF
// 2) Two conditions:
//      1) Wait weight_load -> data_load communication
//      2) ACCU has enough free entries
//     send data to mac
void NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon() {
    // Config variables, they have corresponding value in registers
    uint32_t cube_in_width;
    uint32_t cube_in_height;
    uint32_t cube_in_channel;
    uint32_t cube_out_width;
    uint32_t cube_out_height;
    uint32_t cube_out_channel;
    uint32_t precision;
    uint32_t pad_left;
    uint32_t pad_top;
    uint16_t batch_num;
    sc_uint<16> pad_value;
    uint32_t kernel_width;
    uint32_t kernel_height;
    uint32_t kernel_stride_w;
    uint32_t kernel_stride_h;
    uint32_t x_dilation_ext;
    uint32_t y_dilation_ext;
    uint32_t cbuf_entry_for_data;
    // uint32_t cbuf_entry_for_weight;
    // Control variables
    uint32_t atom_per_cbuf_entry;
    uint32_t out_surface_num;
    uint32_t stripe_num;
    uint32_t super_surface_num;
    uint32_t kernel_atom_num;
    uint32_t ideal_stripe_length_per_batch;
    uint32_t current_stripe_length_per_batch; //, last_stripe_length_per_batch;
    // uint32_t output_height_last;
    uint32_t output_atom_num, output_atom_sent_num;
    uint32_t cbuf_entry_addr, cbuf_entry_per_slice;
    uint32_t cbuf_entry_per_width;
    uint32_t element_size;
    uint32_t super_atom_size;
    uint32_t super_atom_per_cbuf_entry;
    uint32_t atom_per_channel;
    uint32_t cripple_atom_num;
    int32_t  input_atom_coor_height,  input_atom_coor_width;
    uint32_t output_atom_coor_height, output_atom_coor_width;
    uint32_t kernel_atom_coor_height, kernel_atom_coor_width;
    uint32_t last_super_surface_element_num;
    uint32_t required_slice_num;

    // # Iterators
    uint32_t out_surface_iter;
    uint32_t stripe_iter;
    uint32_t super_surface_iter;
    uint32_t kernel_atom_iter;
    uint32_t output_atom_iter;
    uint32_t channel_iter;
    uint32_t read_payload_gran_iter;
    uint16_t batch_iter;
    // Temp variables
    int32_t  idx;
    uint64_t *read_payload_data_ptr;
    sc_uint<64> *read_data_ptr;
    bool     last_super_surface;
    uint32_t packed_channel_iter;   // For packed store in cbuf, it points to the needed data in a cbuf entry

    uint8_t  stripe_length_per_batch[] = { 0, 32, 16, 16, 8, 8, 8, 8, 4, 4, 4, 4, 4, 4, 4, 4,
                                                                   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 };


    cslInfo(("NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, start\n"));
    read_data_ptr = new sc_uint<64>[NVDLA_CBUF_BANK_WIDTH / sizeof(uint64_t)];

    // Copy from register value to local config variables, similar with RTL connection
    cube_in_width           = csc_datain_width_ext_ + 1;
    cube_in_height          = csc_datain_height_ext_ + 1;
    cube_in_channel         = csc_datain_channel_ext_ + 1;
    cube_out_width          = csc_dataout_width_ + 1;
    cube_out_height         = csc_dataout_height_ + 1;
    cube_out_channel        = csc_dataout_channel_ + 1;
    precision               = csc_proc_precision_;
    pad_left                = csc_pad_left_;
    pad_top                 = csc_pad_top_;
    kernel_width            = csc_weight_width_ext_ + 1;
    kernel_height           = csc_weight_height_ext_ + 1;
    kernel_stride_w         = csc_conv_x_stride_ext_ + 1;
    kernel_stride_h         = csc_conv_y_stride_ext_ + 1;
    x_dilation_ext          = csc_x_dilation_ext_ + 1;
    y_dilation_ext          = csc_y_dilation_ext_ + 1;
    pad_value               = sc_uint<16>(csc_pad_value_);
    cbuf_entry_for_data     = (csc_data_bank_+1) * NVDLA_CBUF_BANK_DEPTH;
    batch_num               = csc_batches_ + 1;

    cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, cube_out_width is:0x%x\n", cube_out_width));
    cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, cube_out_height is:0x%x\n", cube_out_height));
    cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, cube_out_channel is:0x%x\n", cube_out_channel));
    // Evaluated
    switch (precision) {
        case DATA_FORMAT_INT8:
            element_size            = ELEMENT_SIZE_INT8;
            atom_per_cbuf_entry     = ATOM_PER_CBUF_ENTRY_INT8;
            break;
        case DATA_FORMAT_INT16:
            element_size            = ELEMENT_SIZE_INT16;
            atom_per_cbuf_entry     = ATOM_PER_CBUF_ENTRY_INT16;
            break;
        case DATA_FORMAT_FP16:
            element_size            = ELEMENT_SIZE_FP16;
            atom_per_cbuf_entry     = ATOM_PER_CBUF_ENTRY_FP16;
            break;
#pragma CTC SKIP
        default:
            FAIL(("invalid precision\n"));
#pragma CTC ENDSKIP
    }

    ideal_stripe_length_per_batch = stripe_length_per_batch[batch_num];

    super_atom_size = NVDLA_MAC_ATOMIC_C_SIZE * element_size;
    super_atom_per_cbuf_entry = NVDLA_CBUF_BANK_WIDTH / super_atom_size;
    kernel_atom_num = kernel_height * kernel_width;
    out_surface_num = (cube_out_channel + NVDLA_MEMORY_ATOMIC_SIZE - 1) / NVDLA_MEMORY_ATOMIC_SIZE;
    super_surface_num = (cube_in_channel + NVDLA_MAC_ATOMIC_C_SIZE - 1) / NVDLA_MAC_ATOMIC_C_SIZE;  // In element of channel direction, not Byte
    last_super_surface_element_num = (0==(cube_in_channel % NVDLA_MAC_ATOMIC_C_SIZE))? NVDLA_MAC_ATOMIC_C_SIZE: (cube_in_channel % NVDLA_MAC_ATOMIC_C_SIZE);
    atom_per_channel = (cube_in_channel + NVDLA_MEMORY_ATOMIC_SIZE - 1) / NVDLA_MEMORY_ATOMIC_SIZE;
    cbuf_entry_per_width = atom_per_channel / atom_per_cbuf_entry;
    cripple_atom_num     = atom_per_channel % atom_per_cbuf_entry;
    cbuf_entry_per_slice = cbuf_entry_per_width * cube_in_width;

    if(cripple_atom_num) {
        if (cripple_atom_num > atom_per_cbuf_entry / 2)
            cbuf_entry_per_slice += cube_in_width;
        else if (cripple_atom_num == atom_per_cbuf_entry / 2)
            cbuf_entry_per_slice += (cube_in_width + 1) / 2;
        else if (cripple_atom_num == atom_per_cbuf_entry / 4)
            cbuf_entry_per_slice += (cube_in_width + 3) / 4;
    }
    // Same check as in IP_TOT/tools/cc_sanity_checker.pl (line350~357)
#pragma CTC SKIP
    if (uint32_t(csc_entries_ + 1) != cbuf_entry_per_slice) {
        FAIL(("NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, invalid configuration csc_entries_, actual value is 0x%X, it shall be 0x%X.", csc_entries_, cbuf_entry_per_slice-1));
    }
#pragma CTC ENDSKIP
    
    slice_idx_free_ = 0;

    output_atom_num     = cube_out_height * cube_out_width;
    required_slice_num  = cube_in_height * batch_num;

    cslInfo(("NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, WaitUntilCBufferHasEnoughtAvailiableDataEntriesFullInput, wait cbuffer.\n"));
    WaitUntilCBufferHasEnoughtAvailiableDataEntriesFullInput(required_slice_num * cbuf_entry_per_slice);
    cslInfo(("NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, WaitUntilCBufferHasEnoughtAvailiableDataEntriesFullInput, wait cbuffer Done.\n"));
/*
    if (batch_num < NVDLA_MAC_ATOMIC_K_SIZE) {
        if (output_atom_num >= 2 * ideal_stripe_length_per_batch)
            last_stripe_length_per_batch = (((output_atom_num % ideal_stripe_length_per_batch) == 0) ? ideal_stripe_length_per_batch : (output_atom_num % ideal_stripe_length_per_batch)) + ideal_stripe_length_per_batch;
        else
            last_stripe_length_per_batch = output_atom_num;
    }
    else
        last_stripe_length_per_batch = 1;
*/
//  stripe_num = (output_atom_num - last_stripe_length_per_batch) / ideal_stripe_length_per_batch + 1;
    stripe_num = evaluate_channel_operation_num(output_atom_num, ideal_stripe_length_per_batch);
    // each out_surface (a channel of output cube) corresponds to a group(number of 16) of kernels
    cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, out_surface_num is: 0x%x\n", out_surface_num));
    cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, stripe_num is: 0x%x\n", stripe_num));
    cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, last_super_surface_element_num is: 0x%x\n", last_super_surface_element_num));


    for (out_surface_iter = 0; out_surface_iter < out_surface_num; out_surface_iter++) {
        output_atom_sent_num = 0;
        current_stripe_length_per_batch = 0;
        for (stripe_iter=0; stripe_iter < stripe_num; stripe_iter++){ // Loop on all stripes in output cube's W'xH' plane
//          output_atom_sent_num = stripe_iter * ideal_stripe_length_per_batch; // Count per input cube
            output_atom_sent_num += current_stripe_length_per_batch; 
            // Determine current stripe length
//          current_stripe_length_per_batch = (stripe_iter < (stripe_num - 1)) ? ideal_stripe_length_per_batch : last_stripe_length_per_batch;
            if(output_atom_num - output_atom_sent_num >= 4 * NVDLA_MAC_ATOMIC_K_SIZE) {
                current_stripe_length_per_batch = 2 * NVDLA_MAC_ATOMIC_K_SIZE; 
            } else if(output_atom_num - output_atom_sent_num > 2 * NVDLA_MAC_ATOMIC_K_SIZE) {
                current_stripe_length_per_batch = 1 * NVDLA_MAC_ATOMIC_K_SIZE;
            } else {
                current_stripe_length_per_batch = output_atom_num - output_atom_sent_num;
            }
            WaitUntilThereIsEnoughSpaceInCaccu(current_stripe_length_per_batch * batch_num);
            for (super_surface_iter = 0; super_surface_iter < super_surface_num; super_surface_iter++) { // Channel (Input Cube) operation loop
                last_super_surface = super_surface_iter == super_surface_num - 1;
                uint32_t last_cbuf_entry = (super_surface_iter / super_atom_per_cbuf_entry) == cbuf_entry_per_width;
                for (kernel_atom_iter=0; kernel_atom_iter < kernel_atom_num; kernel_atom_iter++) { // Block operation loop
                    // kernel_atom_num = kernel_width*kernel_height
                    kernel_atom_coor_height = kernel_atom_iter / kernel_width;
                    kernel_atom_coor_width = kernel_atom_iter % kernel_width;
                    for (output_atom_iter = output_atom_sent_num; output_atom_iter < output_atom_sent_num + current_stripe_length_per_batch; output_atom_iter++) { // Stripe operation loop
                        for (batch_iter = 0; batch_iter < batch_num; batch_iter++) {
                            sc2mac_a_dat_payload.pd.nvdla_stripe_info.batch_index = batch_iter;
                            // Perform atomic operations on all atoms IN CURRENT STRIPE
                            // Fetch data from CBUF
                            // Prepare CSC-to-CMAC data payload
                            // # copy data
                            // # set mask
                            // # set stripe_info
                            // group nvdla_stripe_info
                            //     down U batch_index 5
                            //     down U stripe_st 1
                            //     down U stripe_end 1
                            //     down U channel_end 1
                            //     down U layer_end 1
                            //     down U redundant 1
                            // Notify CMAC needs to reload weight
                            if ((batch_iter == 0) && (output_atom_iter == output_atom_sent_num)) { //The 1st atom of the stripe
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_st = 1;
                                cslDebug((30, "NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, before WaitUntilKernelsAreReady.\n"));
                                WaitUntilKernelsAreReady(); //Kernels should be loaded into shadow before featue data
                                cslDebug((30, "NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, a group of weight for a stripe operation was ready.\n"));
                            } else {
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_st = 0;
                            }

                            // Notify CACC one partial round is done
                            if ((batch_iter == (batch_num - 1)) && (output_atom_iter == (output_atom_sent_num + current_stripe_length_per_batch - 1))) { //The last atom of the stripe
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end = 1;
                            } else {
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end = 0;
                            }

                            // All channels done, notify CACC current data is the last partial sum, CACCU could send out data. The condition (Sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end == 1) is not required.
                            if ((kernel_atom_iter == kernel_atom_num - 1) && last_super_surface) { //&&        // Last stripe operation and the last block operation of current channel operation
                                // (output_atom_iter == output_atom_sent_num + current_stripe_length - 1))   // All atom operations of current stripe operation should have channel_end=1. Same as layer_end.
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.channel_end = 1;
                                cslDebug((30, "NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, got a channel_end, out_surface_iter is 0x%x, out_surface_num is 0x%x, stripe_iter is 0x%x, stripe_num is 0x%x\n", out_surface_iter, out_surface_num, stripe_iter, stripe_num));
                                if ( (out_surface_iter == out_surface_num - 1) && (stripe_iter == stripe_num - 1) ) {    //The last atom of the input cube (last stripe and last output surface)
                                    // Layer done, notify CACC set the hardware layer done bit
                                    sc2mac_a_dat_payload.pd.nvdla_stripe_info.layer_end = 1;
                                } else {
                                    sc2mac_a_dat_payload.pd.nvdla_stripe_info.layer_end = 0;
                                }
                            } else {
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.channel_end = 0;
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.layer_end = 0;
                            }

                            // Get data from CBUF
                            output_atom_coor_width  = output_atom_iter % cube_out_width;
                            output_atom_coor_height = output_atom_iter / cube_out_width;
                            input_atom_coor_width  = output_atom_coor_width * kernel_stride_w + kernel_atom_coor_width * x_dilation_ext - pad_left;
                            input_atom_coor_height = output_atom_coor_height * kernel_stride_h + kernel_atom_coor_height * y_dilation_ext - pad_top;
                            if ( (input_atom_coor_width < 0) || (input_atom_coor_height < 0) || (input_atom_coor_width >= int32_t(cube_in_width)) || (input_atom_coor_height >= int32_t(cube_in_height)) ) {
                                // Padding coordinate, no data in CBUF, filled with pad value
                                switch (precision) {
                                    case DATA_FORMAT_INT8:
                                        for (channel_iter = 0; channel_iter < NVDLA_MAC_ATOMIC_C_SIZE; channel_iter++) {
                                            if(last_super_surface && (channel_iter >= last_super_surface_element_num))
                                                sc2mac_a_dat_payload.data[channel_iter] = 0;   //type of sc2mac_a_dat_payload.data[0]: sc_int<10>
                                            else
                                                sc2mac_a_dat_payload.data[channel_iter] = pad_value.range(7,0);   //type of sc2mac_a_dat_payload.data[0]: sc_int<10>
                                            // Duplicate 64B for int8
                                            // sc2mac_a_dat_payload.data[channel_iter + NVDLA_MAC_ATOMIC_C_SIZE] = sc2mac_a_dat_payload.data[channel_iter];
                                        }
                                        break;
                                    case DATA_FORMAT_INT16:
                                    case DATA_FORMAT_FP16:
                                        for (channel_iter = 0; channel_iter < NVDLA_MAC_ATOMIC_C_SIZE; channel_iter++) {
                                            if(last_super_surface && (channel_iter >= last_super_surface_element_num))
                                                (sc2mac_a_dat_payload.data[channel_iter * 2 + 1].range(7, 0), sc2mac_a_dat_payload.data[channel_iter * 2].range(7, 0)) = 0;
                                            else
                                                (sc2mac_a_dat_payload.data[channel_iter * 2 + 1].range(7, 0), sc2mac_a_dat_payload.data[channel_iter * 2].range(7, 0)) = pad_value;
                                        }
                                        break;
                                }
                                cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, Padding coordinate:\n"));
                                cslDebug((50, "    out_surface_iter           is %d\n", out_surface_iter));
                                cslDebug((50, "    stripe_iter                is %d\n", stripe_iter));
                                cslDebug((50, "    batch_iter                 is %d\n", batch_iter));
                                cslDebug((50, "    super_surface_iter         is %d\n", super_surface_iter));
                                cslDebug((50, "    kernel_atom_iter           is %d\n", kernel_atom_iter));
                                cslDebug((50, "    output_atom_iter           is %d\n", output_atom_iter));
                                cslDebug((50, "    output_atom_coor_width     is %d\n", output_atom_coor_width));
                                cslDebug((50, "    output_atom_coor_height    is %d\n", output_atom_coor_height));
                                cslDebug((50, "    input_atom_coor_width      is %d\n", input_atom_coor_width));
                                cslDebug((50, "    input_atom_coor_height     is %d\n", input_atom_coor_height));
                            } else {
                                // None padding coordinate, read data from CBUF
                                if (last_cbuf_entry && cripple_atom_num && cripple_atom_num <= atom_per_cbuf_entry / 2) {
                                    if (cripple_atom_num == atom_per_cbuf_entry / 4) {  // pack cripple atoms with 4 different width coordinates into one cbuf entry
                                        cbuf_entry_addr = (data_entry_idx_free_ + (input_atom_coor_height * batch_num + batch_iter) * cbuf_entry_per_slice + cube_in_width * (super_surface_iter / super_atom_per_cbuf_entry) + input_atom_coor_width / 4) % cbuf_entry_for_data;
                                    } else {  // pack cripple atoms with 2 different width coordinates into one cbuf entry
                                        cbuf_entry_addr = (data_entry_idx_free_ + (input_atom_coor_height * batch_num + batch_iter) * cbuf_entry_per_slice + cube_in_width * (super_surface_iter / super_atom_per_cbuf_entry) + input_atom_coor_width / 2) % cbuf_entry_for_data;
                                    }
                                } else {
                                    cbuf_entry_addr = (data_entry_idx_free_ + (input_atom_coor_height * batch_num + batch_iter) * cbuf_entry_per_slice + cube_in_width * (super_surface_iter / super_atom_per_cbuf_entry) + input_atom_coor_width) % cbuf_entry_for_data;
                                }

                                sc2buf_dat_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr = cbuf_entry_addr;
                                // Send CBUF read request (block read)
                                cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, sc2buf_dat_rd_b_transport\n"));
                                cslDebug((50, "    out_surface_iter           is %d\n", out_surface_iter));
                                cslDebug((50, "    stripe_iter                is %d\n", stripe_iter));
                                cslDebug((50, "    batch_iter                 is %d\n", batch_iter));
                                cslDebug((50, "    super_surface_iter         is %d\n", super_surface_iter));
                                cslDebug((50, "    kernel_atom_iter           is %d\n", kernel_atom_iter));
                                cslDebug((50, "    output_atom_iter           is %d\n", output_atom_iter));
                                cslDebug((50, "    output_atom_coor_width     is %d\n", output_atom_coor_width));
                                cslDebug((50, "    output_atom_coor_height    is %d\n", output_atom_coor_height));
                                cslDebug((50, "    input_atom_coor_width      is %d\n", input_atom_coor_width));
                                cslDebug((50, "    input_atom_coor_height     is %d\n", input_atom_coor_height));
                                cslDebug((50, "    cbuf_entry_addr            is 0x%x\n", cbuf_entry_addr));
                                // NOTE: For packed data storage and int8, we may read same entry more than once. There is optimazation in RTL not to read cbuf if unnecessary.
                                //       So there is mismatch on cbuf2csc interface between RTL and cmodel.
                                sc2buf_dat_rd_b_transport(&sc2buf_dat_rd_payload, b_transport_delay_);
                                read_payload_data_ptr = reinterpret_cast <uint64_t*> (sc2buf_dat_rd_payload.nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1.data);
                                for (read_payload_gran_iter = 0; read_payload_gran_iter < NVDLA_CBUF_BANK_WIDTH / sizeof(uint64_t); read_payload_gran_iter++) {
                                    read_data_ptr[read_payload_gran_iter] = read_payload_data_ptr[read_payload_gran_iter];  //read_data_ptr[0] is 8Bytes
                                }
                                switch (precision) {
                                    case DATA_FORMAT_INT8:
                                        for (channel_iter=0; channel_iter < NVDLA_MAC_ATOMIC_C_SIZE; channel_iter++) {
                                            if (last_cbuf_entry && cripple_atom_num && cripple_atom_num <= atom_per_cbuf_entry / 2) {
                                                if (cripple_atom_num == atom_per_cbuf_entry / 4) {
                                                    packed_channel_iter = (input_atom_coor_width % 4) * (NVDLA_CBUF_BANK_WIDTH / 4) / element_size + channel_iter;
                                                } else {
                                                    packed_channel_iter = (input_atom_coor_width % 2) * (NVDLA_CBUF_BANK_WIDTH / 2) / element_size + channel_iter;
                                                }
                                            } else {
                                                packed_channel_iter = channel_iter;
                                            }

                                            if (last_super_surface && (channel_iter >= last_super_surface_element_num)) {
                                                sc2mac_a_dat_payload.data[channel_iter] = 0;
                                            } else {
                                                uint32_t elm_num = sizeof(uint64_t) / ELEMENT_SIZE_INT8;
                                                sc2mac_a_dat_payload.data[channel_iter] = read_data_ptr[packed_channel_iter / elm_num].range((packed_channel_iter % elm_num) * 8 + 7, (packed_channel_iter % elm_num) * 8);
                                            }
                                        }
                                        break;
                                    case DATA_FORMAT_INT16:
                                    case DATA_FORMAT_FP16:
                                        for (channel_iter=0; channel_iter < NVDLA_MAC_ATOMIC_C_SIZE; channel_iter++) {
                                            if (last_cbuf_entry && cripple_atom_num && cripple_atom_num <= atom_per_cbuf_entry / 2) {
                                                if (cripple_atom_num == atom_per_cbuf_entry / 4) {
                                                    packed_channel_iter = (input_atom_coor_width % 4) * (NVDLA_CBUF_BANK_WIDTH / 4) / element_size + channel_iter;
                                                }
                                                else {
                                                    packed_channel_iter = (input_atom_coor_width % 2) * (NVDLA_CBUF_BANK_WIDTH / 2) / element_size + channel_iter;
                                                }
                                            }
                                            else {
                                                packed_channel_iter = channel_iter;
                                            }
                                            
                                            if (last_super_surface && (channel_iter >= last_super_surface_element_num)) {
                                                (sc2mac_a_dat_payload.data[channel_iter * 2 + 1].range(7, 0), sc2mac_a_dat_payload.data[channel_iter * 2].range(7, 0)) = 0;
                                            } else {
                                                uint32_t elm_num = sizeof(uint64_t) / ELEMENT_SIZE_INT16;
                                                (sc2mac_a_dat_payload.data[channel_iter * 2 + 1].range(7, 0), sc2mac_a_dat_payload.data[channel_iter * 2].range(7, 0)) = read_data_ptr[packed_channel_iter / elm_num].range((packed_channel_iter % elm_num + 1) * 16 - 1, (packed_channel_iter % elm_num) * 16);
                                                /* cslDebug((70, "channel_iter=%d\n", channel_iter));
                                                   cslDebug((70, "sc2mac_a_dat_payload.data[%d]=0x%02x", channel_iter*2, (uint32_t)sc2mac_a_dat_payload.data[channel_iter*2].to_int()));
                                                   cslDebug((70, "\n"));
                                                   cslDebug((70, "sc2mac_a_dat_payload.data[%d]=0x%02x", channel_iter*2+1, (uint32_t)sc2mac_a_dat_payload.data[channel_iter*2+1].to_int()));
                                                   cslDebug((70, "\n")); */
                                            }
                                        }
                                        break;
                                }
                            }

                            // Send CSC-to-CMAC data payload
                            sc2mac_a_dat_payload.mask[0] = 0x0ULL;
                            sc2mac_a_dat_payload.mask[1] = 0x0ULL;
                            switch (precision) {
                                case DATA_FORMAT_INT8:
                                    for (idx = NVDLA_MAC_ATOMIC_C_SIZE - 1; idx >= 0; idx--) {
                                        // sc2mac_a_dat_payload.mask is per element
                                        // type of sc2mac_a_dat_payload.data[i] is sc_int<10>
                                        // If the data[i] is 0, then RTL code will not assign value to the registers to reduce toggle and save power
                                        uint8_t element_mask_bit = (sc2mac_a_dat_payload.data[idx] != 0)? 1: 0;
                                        if (idx < NVDLA_MAC_ATOMIC_C_SIZE / 2)
                                            sc2mac_a_dat_payload.mask[1] = (sc2mac_a_dat_payload.mask[1] << 1) | element_mask_bit;
                                        else
                                            sc2mac_a_dat_payload.mask[0] = (sc2mac_a_dat_payload.mask[0] << 1) | element_mask_bit;
                                    }
                                    break;
                                case DATA_FORMAT_INT16:
                                    for (idx = NVDLA_MAC_ATOMIC_C_SIZE - 1; idx >= 0; idx--) {
                                        sc_uint<16> tmp_v = (sc2mac_a_dat_payload.data[idx * 2 + 1].range(7, 0), sc2mac_a_dat_payload.data[idx * 2].range(7, 0));
                                        uint8_t element_mask_bit = (tmp_v != 0) ? 3 : 0;
                                        if (idx < NVDLA_MAC_ATOMIC_C_SIZE / 2)
                                            sc2mac_a_dat_payload.mask[1] = (sc2mac_a_dat_payload.mask[1] << 2) | element_mask_bit;
                                        else
                                            sc2mac_a_dat_payload.mask[0] = (sc2mac_a_dat_payload.mask[0] << 2) | element_mask_bit;
                                    }
                                    break;
                                case DATA_FORMAT_FP16:
                                    for (idx = NVDLA_MAC_ATOMIC_C_SIZE - 1; idx >= 0; idx--) {
                                        sc_uint<16> tmp_v = (sc2mac_a_dat_payload.data[idx * 2 + 1].range(7, 0), sc2mac_a_dat_payload.data[idx * 2].range(7, 0));
                                        uint8_t element_mask_bit = ((tmp_v != 0) && (tmp_v != 0x8000UL)) ? 3 : 0;   // Both +0 and -0 have to be involved for FP16
                                        if (idx < NVDLA_MAC_ATOMIC_C_SIZE / 2)
                                            sc2mac_a_dat_payload.mask[1] = (sc2mac_a_dat_payload.mask[1] << 2) | element_mask_bit;
                                        else
                                            sc2mac_a_dat_payload.mask[0] = (sc2mac_a_dat_payload.mask[0] << 2) | element_mask_bit;
                                    }
                                    break;
                            }
                            cslDebug((50, "sc2mac_a_dat_payload: stripe_st=%d\n", (uint32_t)sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_st));
                            cslDebug((50, " stripe_end=%d\n", (uint32_t)sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end));
                            cslDebug((50, " channel_end=%d\n", (uint32_t)sc2mac_a_dat_payload.pd.nvdla_stripe_info.channel_end));
                            cslDebug((50, " layer_end=%d\n", (uint32_t)sc2mac_a_dat_payload.pd.nvdla_stripe_info.layer_end));
                            cslDebug((50, " mask[0]=0x%016lx\n", (uint64_t)sc2mac_a_dat_payload.mask[0]));
                            cslDebug((50, " mask[1]=0x%016lx\n", (uint64_t)sc2mac_a_dat_payload.mask[1]));
#if LOG_DETAIL
                            for (uint32_t idx_db = 0; idx_db < NVDLA_CBUF_BANK_WIDTH; idx_db++) {
                                cslDebug((90, "    Data[%d]: 0x%02x\n", idx_db, sc2mac_a_dat_payload.data[idx_db].to_int()));
                            }
                            cslDebug((90, "\n"));
#endif
                            sc2mac_a_dat_b_transport (&sc2mac_a_dat_payload, b_transport_delay_);
                            sc2mac_b_dat_b_transport (&sc2mac_a_dat_payload, b_transport_delay_);
                            if (sc2mac_a_dat_payload.pd.nvdla_stripe_info.channel_end && sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end) {
                                cacc_free_entry_num_ -= current_stripe_length_per_batch * batch_num;
                                cslDebug((50, "Updated credit: cacc_free_entry_num_=%lx\n", cacc_free_entry_num_));
                            }

                            if ( 1 == sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_st ) {
                                // after data stripe_start has been sent, notify weight thread previous shadow (in CMAC) has been loaded into active
                                // weight load could send to next kernel to CMAC
                                kernel_switch_round_data_ ++;
                                stripe_begin_updated_.notify();
                            }
                        }
                    }
                }
            }
        }
    }

    delete [] read_data_ptr;
}

void NV_NVDLA_csc::SendWeightToMacSequencerDirectConvCommon() {
    // Config variables, they have corresponding value in registers
    //uint32_t cube_in_channel;
    uint32_t cube_out_width;
    uint32_t cube_out_height;
    uint32_t batch_num;
    uint32_t byte_per_kernel;
    uint32_t precision;
    uint32_t kernel_width;
    uint32_t kernel_height;
    uint32_t kernel_channel;
    uint32_t kernel_num;
    uint32_t weight_format;
    uint32_t skip_weight_rls_mode;
    uint32_t cbuf_entry_for_data, cbuf_entry_for_weight;
    uint8_t  post_y_extension;

    // # Iterators
    uint32_t kernel_group_iter;
    uint32_t kernel_iter;
    uint32_t channel_operation_iter;
    uint32_t block_operation_iter;
    uint32_t stripe_operation_iter;
    uint32_t read_payload_gran_iter;
    uint32_t sc2mac_element_iter;
    uint32_t byte_iter;
    uint32_t out_line_iter;
    int32_t idx;

    // Control variables
    uint32_t element_size;
    uint32_t kernel_per_group;
    uint32_t kernel_per_group_last;
    uint32_t kernel_group_num;
    uint32_t channel_operation_num;
    uint32_t kernel_group_stride;
    uint32_t block_per_channel_num;
    uint32_t cripple_channel_num;
    uint32_t stripe_operation_stride;
    uint32_t block_operation_stride;
    uint32_t ideal_super_atom_size;
    uint32_t last_super_atom_size;
    uint32_t current_super_atom_size;
    bool     is_last_channel_operation_cripple;
    bool     is_skip_weight_rls_mode;
    uint32_t ideal_stripe_length;
    uint32_t begin_byte_within_one_entry;
    uint32_t cbuf_entry_addr;
    uint32_t stripe_operation_per_block_operation;
    uint64_t kernel_atom_size_index;
    uint32_t input_atom_channel_num;
    uint32_t prev_read_size, curr_byte_size;
    uint32_t updated_entry_num;
    bool     image_in_mode;
    uint32_t out_line_num;
    bool     last_stripe_operation;
    int32_t  comp_released_wt_entries;
    int32_t  comp_released_wmb_entries;

    // Temperal variables
    uint8_t *read_data_curr_ptr;
    uint8_t *read_data_prev_ptr;
    uint8_t *read_data_reorder;
    uint8_t *read_payload_data_ptr;

    uint8_t  stripe_length[] = { 0, 32, 16, 16, 8, 8, 8, 8, 4, 4, 4, 4, 4, 4, 4, 4,
                                                         2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 };

    // Copy from register value to local config variables, similar with RTL connection
    //cube_in_channel         = csc_datain_channel_ext_ + 1;
    cube_out_width          = csc_dataout_width_ + 1;
    cube_out_height         = csc_dataout_height_ + 1;
    precision               = csc_proc_precision_;
    kernel_width            = csc_weight_width_ext_ + 1;
    kernel_height           = csc_weight_height_ext_ + 1;
    kernel_channel          = csc_weight_channel_ext_ + 1;
    kernel_num              = csc_weight_kernel_ + 1;
    skip_weight_rls_mode    = csc_skip_weight_rls_;
    cbuf_entry_for_data     = (csc_data_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH;
    cbuf_entry_for_weight   = (csc_weight_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH;
    weight_format           = csc_weight_format_;
    batch_num               = csc_batches_ + 1;
    image_in_mode           = (NVDLA_CSC_D_MISC_CFG_0_CONV_MODE_DIRECT == csc_conv_mode_) && (NVDLA_CSC_D_DATAIN_FORMAT_0_DATAIN_FORMAT_PIXEL == csc_datain_format_);
    post_y_extension        = 1 << csc_y_extension_ ;   // Valid values: 1, 2, 4

    // Evaluated
    switch (precision) {
        case DATA_FORMAT_INT8:
            element_size        = ELEMENT_SIZE_INT8;
            break;
        case DATA_FORMAT_INT16:
            element_size        = ELEMENT_SIZE_INT16;
            break;
        case DATA_FORMAT_FP16:
            element_size        = ELEMENT_SIZE_FP16;
            break;
        default:
            break;
    }

    // There is no byte_per_kernel register in manual. And we can't use weight_bytes/kernel_num to calculate byte_per_kernel because weight_bytes is ((byte_per_kernel*kernel_num + 127)/128)*128
    byte_per_kernel       = kernel_width * kernel_height * kernel_channel * element_size;
    kernel_per_group_last = kernel_num % NVDLA_MAC_ATOMIC_K_SIZE;
    is_skip_weight_rls_mode   = (NVDLA_CSC_D_MISC_CFG_0_SKIP_WEIGHT_RLS_ENABLE == skip_weight_rls_mode);
    block_per_channel_num = (kernel_channel + NVDLA_MAC_ATOMIC_C_SIZE - 1) / NVDLA_MAC_ATOMIC_C_SIZE;
    cripple_channel_num = kernel_channel % NVDLA_MAC_ATOMIC_C_SIZE;
    is_last_channel_operation_cripple = (0 == cripple_channel_num) ? false : true;
    kernel_group_stride = byte_per_kernel * NVDLA_MAC_ATOMIC_K_SIZE;
    kernel_group_num = (kernel_num + NVDLA_MAC_ATOMIC_K_SIZE - 1) / NVDLA_MAC_ATOMIC_K_SIZE;
    stripe_operation_per_block_operation = (kernel_width * kernel_height + post_y_extension - 1) / post_y_extension;

    read_data_curr_ptr = new uint8_t [NVDLA_CBUF_BANK_WIDTH];
    read_data_prev_ptr = new uint8_t [NVDLA_CBUF_BANK_WIDTH];
    read_data_reorder  = new uint8_t [NVDLA_CBUF_BANK_WIDTH];
    read_payload_data_ptr = reinterpret_cast <uint8_t*> (sc2buf_wt_rd_payload.nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1.data);

    if (image_in_mode) {
//        ideal_stripe_length   = NVDLA_MAC_ATOMIC_K_SIZE * 2;
      ideal_stripe_length   = (NVDLA_MAC_ATOMIC_C_SIZE / NVDLA_MAC_ATOMIC_K_SIZE == 4)? (NVDLA_MAC_ATOMIC_K_SIZE * 4) : (NVDLA_MAC_ATOMIC_K_SIZE * 2);
        channel_operation_num = (cube_out_width + ideal_stripe_length - 1) / ideal_stripe_length;
        out_line_num          = cube_out_height;
    }
    else {
        ideal_stripe_length   = stripe_length[batch_num];
        channel_operation_num = evaluate_channel_operation_num(cube_out_width * cube_out_height, ideal_stripe_length);
        out_line_num          = 1;
    }
    cslDebug((30, "cripple_channel_num=%d\n", cripple_channel_num));
    comp_released_wt_entries = 0;
    comp_released_wmb_entries = 0;
    for (kernel_group_iter=0; kernel_group_iter < kernel_group_num; kernel_group_iter++) { // (K / ATOM-K) loop
        // Loop on output channels
        if (kernel_group_iter == (kernel_group_num - 1)) {
            kernel_per_group = (kernel_per_group_last == 0) ? NVDLA_MAC_ATOMIC_K_SIZE : kernel_per_group_last;
        } else {
            kernel_per_group = NVDLA_MAC_ATOMIC_K_SIZE;
        }
        cslDebug((30, "kernel_group_iter=%d current kernel_per_group=%d\n", kernel_group_iter, kernel_per_group));
        cslDebug((50, "WaitUntilThereAreEnoughKernel start\n"));
        // Wait the next Kernel Group is fetched into cbuf
        if (is_skip_weight_rls_mode) {  // Not release weight
            // Count from the beginning of the entire weight
            WaitUntilThereAreEnoughKernel(kernel_group_iter * NVDLA_MAC_ATOMIC_K_SIZE + kernel_per_group);
        } else {
            // Count from the beginning of the current Kernel Group
            WaitUntilThereAreEnoughKernel(kernel_per_group);
        }
        cslDebug((50, "WaitUntilThereAreEnoughKernel end\n"));

        for (out_line_iter=0; out_line_iter < out_line_num; out_line_iter++) { // Loop on lines of output cube
            for (channel_operation_iter=0; channel_operation_iter < channel_operation_num; channel_operation_iter++) { // (W' * H' / ATOM-K) = stripe_num in one kernel group
                cslDebug((30, "channel_operation_iter=%d\n", channel_operation_iter));
                if (NVDLA_CSC_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED==weight_format) {
                    comp_updated_wt_entry_num = 0;
                    comp_updated_wmb_entry_num = 0;
                    cbuf_wmb_entry_addr = CBUF_WMB_BANK_IDX * NVDLA_CBUF_BANK_DEPTH + wmb_entry_idx_start_ % NVDLA_CBUF_BANK_DEPTH;
                    if (0 == kernel_group_iter) { // First kernel group
                        wt_payload_available = 0;
                        next_wt_idx     = 0;
                        next_wmb_idx    = 0;
                    } else {
                        wt_payload_available = wt_payload_available_bak;
                        next_wt_idx     = next_wt_idx_bak;
                        next_wmb_idx    = next_wmb_idx_bak;
                        memcpy(comp_entry_wt, comp_entry_wt_bak, NVDLA_CBUF_BANK_WIDTH);
                        memcpy(comp_entry_wmb, comp_entry_wmb_bak, NVDLA_CBUF_BANK_WIDTH);

                        if (NVDLA_CBUF_BANK_WIDTH == wt_payload_available)
                            FAIL(("The weight data in comp_entry_wt should be used by prev kernel group\n"));
                        
                        cslDebug((70, "After restore: wt_payload_available=%d next_wt_idx=%d next_wmb_idx=%d\n", wt_payload_available, next_wt_idx, next_wmb_idx));
                        cslDebug((70, "comp_entry_wt:\n"));

                        for (uint32_t i = 0; i < NVDLA_CBUF_BANK_WIDTH / sizeof(uint64_t); i++)
                            cslDebug((70, "0x%016lx ", comp_entry_wt[i]));
                        cslDebug((70, "\n"));

                        cslDebug((70, "comp_entry_wmb:\n"));
                        for (uint32_t i = 0; i < NVDLA_CBUF_BANK_WIDTH; i++)
                            cslDebug((70, "0x%02x ", comp_entry_wmb[i]));
                        cslDebug((70, "\n"));
                    }
                    // For each channel op in one kernel group, restart from the start of the kernel group
                    // cbuf_wt_entry_addr is used only for weight compression mode
                    cbuf_wt_entry_addr = cbuf_entry_for_data + weight_entry_idx_start_ % cbuf_entry_for_weight;
                } else {
                    updated_entry_num = 0;
                    // Copy the left weight of current kernel group which was released in the end of previous kernel_group
                    memcpy(read_data_curr_ptr, kg_wt_first_entry_buffer, NVDLA_CBUF_BANK_WIDTH);
                }
                for (block_operation_iter=0; block_operation_iter < block_per_channel_num; block_operation_iter ++) { // C / ATOM-C loop
                    cslDebug((30, "block_operation_iter=%d\n", block_operation_iter));
                    for (stripe_operation_iter = 0; stripe_operation_iter < stripe_operation_per_block_operation; stripe_operation_iter++) { // R * S loop
                        cslDebug((30, "stripe_operation_iter=%d\n", stripe_operation_iter));
                        last_stripe_operation = stripe_operation_iter == (stripe_operation_per_block_operation - 1);
                        if (post_y_extension > 1) {
                            if(block_operation_iter > 0)
                                FAIL(("There should be only one block operation in one channel operation when post_y_extension>1\n"));
                            ideal_super_atom_size = cripple_channel_num * element_size * post_y_extension;
                            last_super_atom_size = cripple_channel_num * element_size * (((kernel_height % post_y_extension)==0)? post_y_extension: (kernel_height % post_y_extension));
                            current_super_atom_size = last_stripe_operation ? last_super_atom_size : ideal_super_atom_size;
                            if (last_stripe_operation && ((kernel_height % post_y_extension) != 0))
                                input_atom_channel_num = cripple_channel_num * (kernel_height % post_y_extension);
                            else
                                input_atom_channel_num = cripple_channel_num * post_y_extension;
                            stripe_operation_stride  = ideal_super_atom_size * kernel_per_group;
                            // block_operation_stride is actually not used because block_operation_iter is always 0 for post-extension
                            block_operation_stride   = (ideal_super_atom_size * (stripe_operation_per_block_operation - 1) + last_super_atom_size) * kernel_per_group;
                        }
                        else if ( (true == is_last_channel_operation_cripple) && (block_operation_iter == block_per_channel_num - 1) ) {
                            current_super_atom_size = cripple_channel_num * element_size;
                            input_atom_channel_num = cripple_channel_num;
                            stripe_operation_stride  = current_super_atom_size * kernel_per_group;
                            block_operation_stride   = NVDLA_MAC_ATOMIC_C_SIZE * element_size * stripe_operation_per_block_operation * kernel_per_group;
                        } else {
                            current_super_atom_size = NVDLA_MAC_ATOMIC_C_SIZE * element_size;
                            input_atom_channel_num = NVDLA_MAC_ATOMIC_C_SIZE;
                            stripe_operation_stride  = current_super_atom_size * kernel_per_group;
                            block_operation_stride   = NVDLA_MAC_ATOMIC_C_SIZE * element_size * stripe_operation_per_block_operation * kernel_per_group;
                        }
                        WaitStripeBeginHasSent();   //Wait until the previous stripe has been sent to mac. Then load the next batch of kernels into shadow.
                        for (kernel_iter = 0; kernel_iter < kernel_per_group; kernel_iter++) { // ATOM-K loop
                            cslDebug((30, "kernel_iter=%d\n", kernel_iter));
                            kernel_atom_size_index = (weight_layer_start_byte_idx_
                                + kernel_iter * current_super_atom_size
                                + stripe_operation_iter * stripe_operation_stride
                                + block_operation_iter  * block_operation_stride
                                + kernel_group_iter     * kernel_group_stride) % (cbuf_entry_for_weight * NVDLA_CBUF_BANK_WIDTH);
                            cbuf_entry_addr = cbuf_entry_for_data + kernel_atom_size_index / NVDLA_CBUF_BANK_WIDTH;
                            begin_byte_within_one_entry = kernel_atom_size_index % NVDLA_CBUF_BANK_WIDTH;
                            cslDebug((50, "NV_NVDLA_csc::SendWeightToMacSequencerDirectConvCommon, iterator values:\n"));
                            cslDebug((50, "    kernel_group_iter          is %d\n", kernel_group_iter));
                            cslDebug((50, "    out_line_iter              is %d\n", out_line_iter));
                            cslDebug((50, "    channel_operation_iter     is %d\n", channel_operation_iter));
                            cslDebug((50, "    block_operation_iter       is %d\n", block_operation_iter));
                            cslDebug((50, "    stripe_operation_iter      is %d\n", stripe_operation_iter));
                            cslDebug((50, "    kernel_iter                is %d\n", kernel_iter));
                            cslDebug((50, "    kernel_atom_size_index     is 0x%lx\n", kernel_atom_size_index));
                            cslDebug((50, "    begin_byte_within_one_entry is 0x%x\n", begin_byte_within_one_entry));
                            cslDebug((50, "    cbuf_entry_addr            is 0x%x\n", cbuf_entry_addr));
                            if (NVDLA_CSC_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED == weight_format) {
                                get_decompressed_weight(read_data_curr_ptr, input_atom_channel_num);    // For INT8, read_data_curr_ptr is different in compress and non-compress modes
                                // Prepare CSC2MAC weight payload, from C0 to C64, C0 is aligned with 0
                                if (DATA_FORMAT_INT8 == precision) {    // sc2mac_a_wt_payload.data[0] is sc_int<8>
                                    for (sc2mac_element_iter = 0; sc2mac_element_iter < input_atom_channel_num * element_size; sc2mac_element_iter++) {
                                        sc2mac_a_wt_payload.data[sc2mac_element_iter] = read_data_curr_ptr[sc2mac_element_iter];
//                                        cslDebug((70, "kernel_iter=%d sc2mac_element_iter=%d read_data_curr_ptr[]=0x%x sc2mac_a_wt_payload.data[]=0x%x\n", kernel_iter, sc2mac_element_iter, read_data_curr_ptr[sc2mac_element_iter], sc2mac_a_wt_payload.data[sc2mac_element_iter].to_int()));
                                    }
                                } else {
                                    // Int16 or FP16, each element size is 2 byte
                                    for (sc2mac_element_iter = 0; sc2mac_element_iter < input_atom_channel_num * element_size; sc2mac_element_iter++) {
                                        sc2mac_a_wt_payload.data[sc2mac_element_iter] = read_data_curr_ptr[sc2mac_element_iter];
                                    }
                                }
                            }
                            // Determine to read one new entry or not
                            else if (0 == begin_byte_within_one_entry) {
                                // Begin byte address is aligned with NVDLA_CBUF_BANK_WIDTH, in current setting, NVDLA_CBUF_BANK_WIDTH is 128 byte
                                // There is no usable data in read_data_curr_ptr
                                // Read new line in cbuf
                                sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr = cbuf_entry_addr;
                                cslDebug((50, "NV_NVDLA_csc::SendWeightToMacSequencerDirectConvCommon, begin byte address is aligned with entry size.  sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr is 0x%x\n", sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr));
                                // Send CBUF read request. Read one cbuf entry(128B)
                                sc2buf_wt_rd_b_transport(&sc2buf_wt_rd_payload, b_transport_delay_);
                                updated_entry_num ++;
                                // Copy CBUF read data from payload to local variable
                                for (read_payload_gran_iter = 0; read_payload_gran_iter < NVDLA_CBUF_BANK_WIDTH; read_payload_gran_iter++) {
                                    read_data_curr_ptr[read_payload_gran_iter] = read_payload_data_ptr[read_payload_gran_iter];
                                }
                                // Prepare CSC2MAC weight payload, from C0 to C64, C0 is aligned with 0
                                if (DATA_FORMAT_INT8 == precision) {
                                    // Only copy 64Bytes from the buffer
                                    for (sc2mac_element_iter = 0; sc2mac_element_iter < input_atom_channel_num * element_size; sc2mac_element_iter++) {
                                        sc2mac_a_wt_payload.data[sc2mac_element_iter] = read_data_curr_ptr[sc2mac_element_iter];
                                    }
                                } else {
                                    // Int16 or FP16, each element size is 2 byte
                                    for (sc2mac_element_iter = 0; sc2mac_element_iter < input_atom_channel_num * element_size; sc2mac_element_iter++) {
                                        sc2mac_a_wt_payload.data[sc2mac_element_iter] = read_data_curr_ptr[sc2mac_element_iter];
                                    }
                                }
                            } else if( begin_byte_within_one_entry+current_super_atom_size > NVDLA_CBUF_BANK_WIDTH ) {
                                // Begin byte address is not aligned with NVDLA_CBUF_BANK_WIDTH, in current setting, NVDLA_CBUF_BANK_WIDTH is 128 byte
                                // There is some usable data in read_data_curr_ptr
                                // And there is some data need to be read from CBUF
                                // Read next line in cbuf, and use last read info to compose a payload to mac
                                if (cbuf_entry_addr == (cbuf_entry_for_data + cbuf_entry_for_weight - 1))
                                    cbuf_entry_addr = cbuf_entry_for_data;
                                else
                                    cbuf_entry_addr ++;
                                sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr = cbuf_entry_addr;
                                cslDebug((50, "NV_NVDLA_csc::SendWeightToMacSequencerDirectConvCommon, begin byte address is not aligned with entry size.  sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr is 0x%x\n", sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr));
                                // Send CBUF read request
                                sc2buf_wt_rd_b_transport(&sc2buf_wt_rd_payload, b_transport_delay_);
                                updated_entry_num ++;
                                // Copy CBUF read data from payload to local variable
                                for (read_payload_gran_iter = 0; read_payload_gran_iter < NVDLA_CBUF_BANK_WIDTH; read_payload_gran_iter++) {
                                    read_data_prev_ptr[read_payload_gran_iter] = read_data_curr_ptr[read_payload_gran_iter];
                                    read_data_curr_ptr[read_payload_gran_iter] = read_payload_data_ptr[read_payload_gran_iter];
                                }
                                // Reorder payload, may have performance issue
                                prev_read_size = NVDLA_CBUF_BANK_WIDTH - begin_byte_within_one_entry;
                                curr_byte_size = current_super_atom_size - prev_read_size;
                                // Get data from prev
                                for (byte_iter = 0; byte_iter < prev_read_size; byte_iter++) {
                                    read_data_reorder[byte_iter] = read_data_prev_ptr[byte_iter + begin_byte_within_one_entry];
                                    //cslDebug((70, "AAA read_data_reorder[%d]=0x%x\n", byte_iter, (uint32_t)read_data_reorder[byte_iter]));
                                }
                                // Get data from curr
                                for (byte_iter = 0; byte_iter < curr_byte_size; byte_iter++) {
                                    read_data_reorder[byte_iter + prev_read_size] = read_data_curr_ptr[byte_iter];
                                    //cslDebug((70, "BBB read_data_reorder[%d]=0x%x\n", byte_iter+prev_read_size, (uint32_t)read_data_reorder[byte_iter+prev_read_size]));
                                }
                                // Prepare CSC2MAC weight payload, from C0 to C64, C0 is aligned with 0
                                if (DATA_FORMAT_INT8 == precision) {
                                    // Int8, get 64B from read_data_reorder
                                    for (sc2mac_element_iter = 0; sc2mac_element_iter < input_atom_channel_num * element_size; sc2mac_element_iter++) {
                                        sc2mac_a_wt_payload.data[sc2mac_element_iter] = read_data_reorder[sc2mac_element_iter];
                                        //cslDebug((70, "CCC sc2mac_a_wt_payload.data[%d]=0x%02x\n", sc2mac_element_iter, sc2mac_a_wt_payload.data[sc2mac_element_iter].to_int()));
                                    }
                                } else {
                                    for (sc2mac_element_iter = 0; sc2mac_element_iter < input_atom_channel_num * element_size; sc2mac_element_iter++) {
                                        sc2mac_a_wt_payload.data[sc2mac_element_iter] = read_data_reorder[sc2mac_element_iter];
                                    }
                                }
                            } else {
                                // All required Data for current kernel are already in read_data_curr_ptr   (e.g. int8 or the current_super_atom_size is less than 128)
                                // Get data from curr
                                cslDebug((50, "(begin_byte_within_one_entry != 0) && (begin_byte_within_one_entry+current_super_atom_size <= NVDLA_CBUF_BANK_WIDTH)\n"));
                                prev_read_size = NVDLA_CBUF_BANK_WIDTH - begin_byte_within_one_entry;
                                curr_byte_size = current_super_atom_size - prev_read_size;
                                for (byte_iter = 0; byte_iter < current_super_atom_size; byte_iter++) {
                                    read_data_reorder[byte_iter] = read_data_curr_ptr[byte_iter + begin_byte_within_one_entry];
                                }
                                // Prepare CSC2MAC weight payload, from C0 to C64, C0 is aligned with 0
                                if (DATA_FORMAT_INT8 == precision) {
                                    for (sc2mac_element_iter = 0; sc2mac_element_iter < input_atom_channel_num * element_size; sc2mac_element_iter++) {
                                        sc2mac_a_wt_payload.data[sc2mac_element_iter] = read_data_reorder[sc2mac_element_iter];
                                        //cslDebug((70, "CCC sc2mac_a_wt_payload.data[%d]=0x%02x\n", sc2mac_element_iter, sc2mac_a_wt_payload.data[sc2mac_element_iter].to_int()));
                                    }
                                } else {
                                    for (sc2mac_element_iter = 0; sc2mac_element_iter < input_atom_channel_num * element_size; sc2mac_element_iter++) {
                                        sc2mac_a_wt_payload.data[sc2mac_element_iter] = read_data_reorder[sc2mac_element_iter];
                                    }
                                }
                            }

                            // Post extension
                            uint32_t ii;
                            uint8_t payload_data_tmp[128];
                            for (ii = 0; ii < 128; ii++) {
                                payload_data_tmp[ii] = sc2mac_a_wt_payload.data[ii].to_int();
                            }
#if 0
                            for (uint32_t idx_db=0; idx_db<128; idx_db ++) {
                                cslDebug((70, "    payload_data_tmp[%d]: 0x%02x\n", idx_db, (uint8_t)payload_data_tmp[idx_db]));
                            }
#endif
                            if (post_y_extension==1) {
                                // Fill 0 to cripple channels
                                if (DATA_FORMAT_INT8 == precision) {
                                    for (sc2mac_element_iter = input_atom_channel_num * element_size; sc2mac_element_iter < NVDLA_MAC_ATOMIC_C_SIZE * element_size; sc2mac_element_iter++)
                                        sc2mac_a_wt_payload.data[sc2mac_element_iter] = 0;
                                } else {
                                    for (sc2mac_element_iter = input_atom_channel_num * element_size; sc2mac_element_iter < NVDLA_MAC_ATOMIC_C_SIZE * element_size; sc2mac_element_iter++)
                                        sc2mac_a_wt_payload.data[sc2mac_element_iter] = 0;
                                }
                            }
                            else if (post_y_extension == 2) {
                                if (DATA_FORMAT_INT8 == precision) {
                                    for (ii = 0; ii < 2; ii++) {
                                        uint16_t element_start_idx = ii * NVDLA_MAC_ATOMIC_C_SIZE / 2;
                                        uint16_t element_end_idx = (ii + 1) * NVDLA_MAC_ATOMIC_C_SIZE / 2;
                                        for (sc2mac_element_iter = element_start_idx; sc2mac_element_iter < element_end_idx; sc2mac_element_iter++) {
                                            if (last_stripe_operation && (kernel_height % 2 == 1) && (ii > 0))
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter] = 0;
                                            else if( sc2mac_element_iter < element_start_idx + kernel_channel ) // Not change
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter] = payload_data_tmp[ii * cripple_channel_num + sc2mac_element_iter - element_start_idx];
                                            else
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter] = 0;
                                        }
                                    }
                                } else {
                                    for (ii = 0; ii < 2; ii++) {
                                        uint16_t element_start_idx = ii * NVDLA_MAC_ATOMIC_C_SIZE / 2;
                                        uint16_t element_end_idx = (ii + 1) * NVDLA_MAC_ATOMIC_C_SIZE / 2;
                                        for (sc2mac_element_iter = element_start_idx; sc2mac_element_iter < element_end_idx; sc2mac_element_iter++) {
                                            if (last_stripe_operation && (kernel_height % 2 ==1) && (ii > 0)) {
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2] = 0;
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2 + 1] = 0;
                                            }
                                            else if( sc2mac_element_iter < element_start_idx + kernel_channel ) { // Not change
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2] = payload_data_tmp[2 * (ii * cripple_channel_num + sc2mac_element_iter - element_start_idx)];
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2 + 1] = payload_data_tmp[2 * (ii * cripple_channel_num + sc2mac_element_iter - element_start_idx) + 1];
                                            }
                                            else {
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2] = 0;
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2 + 1] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                            else { //if (post_y_extension==4)
                                if (DATA_FORMAT_INT8 == precision) {
                                    for (ii = 0; ii < 4; ii++) {
                                        uint16_t element_start_idx = ii * NVDLA_MAC_ATOMIC_C_SIZE / 4;
                                        uint16_t element_end_idx = (ii + 1) * NVDLA_MAC_ATOMIC_C_SIZE / 4;
                                        for (sc2mac_element_iter = element_start_idx; sc2mac_element_iter < element_end_idx; sc2mac_element_iter++) {
                                            if (last_stripe_operation && (kernel_height % 4 ==1) && (ii > 0))
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter] = 0;
                                            else if (last_stripe_operation && (kernel_height % 4 ==2) && (ii > 1))
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter] = 0;
                                            else if (last_stripe_operation && (kernel_height % 4 ==3) && (ii > 2))
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter] = 0;
                                            else if( sc2mac_element_iter < element_start_idx + kernel_channel ) // Not change
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter] = payload_data_tmp[ii * cripple_channel_num + sc2mac_element_iter - element_start_idx];
                                            else
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter] = 0;
                                        }
                                    }
                                } else {
                                    for (ii = 0; ii < 4; ii++) {
                                        uint16_t element_start_idx = ii * NVDLA_MAC_ATOMIC_C_SIZE / 4;
                                        uint16_t element_end_idx = (ii + 1) * NVDLA_MAC_ATOMIC_C_SIZE / 4;
                                        for (sc2mac_element_iter = element_start_idx; sc2mac_element_iter < element_end_idx; sc2mac_element_iter++) {
                                            if (last_stripe_operation && (kernel_height % 4 == 1) && (ii > 0)) {
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2] = 0;
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2 + 1] = 0;
                                            }
                                            else if (last_stripe_operation && (kernel_height % 4 == 2) && (ii > 1)) {
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2] = 0;
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2 + 1] = 0;
                                            }
                                            else if (last_stripe_operation && (kernel_height % 4 == 3) && (ii > 2)) {
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2] = 0;
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2 + 1] = 0;
                                            }
                                            else if( sc2mac_element_iter < element_start_idx + kernel_channel ) { // Not change
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2] = payload_data_tmp[2 * (ii * cripple_channel_num + sc2mac_element_iter - element_start_idx)];
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2 + 1] = payload_data_tmp[2 * (ii * cripple_channel_num + sc2mac_element_iter - element_start_idx) + 1];
                                            }
                                            else {
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2] = 0;
                                                sc2mac_a_wt_payload.data[sc2mac_element_iter * 2 + 1] = 0;
                                            }
                                        }
                                    }
                                }
                            }
#if 0
                            for (uint32_t idx_db=0; idx_db<128; idx_db ++) {
                                cslDebug((70, "    XXXXXXX Weight[%d]: 0x%02x\n", idx_db, (uint8_t)sc2mac_a_wt_payload.data[idx_db].to_int()));
                            }
#endif
                            // Send weight to CMAC
                            sc2mac_a_wt_payload.mask[0] = 0x0ULL;
                            sc2mac_a_wt_payload.mask[1] = 0x0ULL;

                            if (DATA_FORMAT_INT8 == precision) {
                                for (idx = NVDLA_MAC_ATOMIC_C_SIZE - 1; idx >= 0; idx--) {
                                    uint8_t element_mask_bit = (sc2mac_a_wt_payload.data[idx] != 0)? 1 : 0;
                                    if (idx < NVDLA_MAC_ATOMIC_C_SIZE / 2)
                                        sc2mac_a_wt_payload.mask[1] = (sc2mac_a_wt_payload.mask[1] << 1) | element_mask_bit;
                                    else
                                        sc2mac_a_wt_payload.mask[0] = (sc2mac_a_wt_payload.mask[0] << 1) | element_mask_bit;
                                }
                                sc2mac_a_wt_payload.sel = ((uint64_t)0x1) << kernel_iter;
                                if ((sc2mac_a_wt_payload.sel & CSC2CMAC_WEIGHT_MASK)) {
                                    cslDebug((70, "sc2mac_a_wt_payload (part a) is\n"));
                                } else { //if ((sc2mac_a_wt_payload.sel>>8) & 0xFF)  {
                                    cslDebug((70, "sc2mac_a_wt_payload (part b) is\n"));
                                }
                                cslDebug((50, "    mask[0]=0x%016lx\n", (uint64_t)sc2mac_a_wt_payload.mask[0]));
                                cslDebug((50, "    mask[1]=0x%016lx\n", (uint64_t)sc2mac_a_wt_payload.mask[1]));
                                cslDebug((70, "    sel is 0x%lx\n", sc2mac_a_wt_payload.sel));
#if LOG_DETAIL
                                for (uint32_t idx_db = 0; idx_db < NVDLA_CBUF_BANK_WIDTH; idx_db++) {
                                    cslDebug((90, "    Weight[%d]: 0x%02x\n", idx_db, (uint8_t)sc2mac_a_wt_payload.data[idx_db].to_int()));
                                }
#endif
                                if ((sc2mac_a_wt_payload.sel & CSC2CMAC_WEIGHT_MASK)) {
                                    sc2mac_a_wt_b_transport(&sc2mac_a_wt_payload, b_transport_delay_);
                                } else { //if ((sc2mac_a_wt_payload.sel>>8) & 0xFF)  {
                                    sc2mac_a_wt_payload.sel = sc2mac_a_wt_payload.sel >> (NVDLA_MAC_ATOMIC_K_SIZE / 2);
                                    sc2mac_b_wt_b_transport(&sc2mac_a_wt_payload, b_transport_delay_);
                                }
                            } else {
                                for (idx = NVDLA_MAC_ATOMIC_C_SIZE - 1; idx >= 0; idx--) {
                                    sc_uint<16> tmp_v = (sc2mac_a_wt_payload.data[idx * 2 + 1].range(7, 0), sc2mac_a_wt_payload.data[idx * 2].range(7, 0));
                                    uint8_t element_mask_bit;
                                    if (DATA_FORMAT_FP16 == precision)
                                        element_mask_bit = ((tmp_v != 0) && (tmp_v != 0x8000UL)) ? 3 : 0;   // Both +0 and -0 have to be involved for FP16
                                    else
                                        element_mask_bit = (tmp_v != 0)? 3 : 0;
                                    if (idx < NVDLA_MAC_ATOMIC_C_SIZE / 2)
                                        sc2mac_a_wt_payload.mask[1] = (sc2mac_a_wt_payload.mask[1] << 2) | element_mask_bit;
                                    else
                                        sc2mac_a_wt_payload.mask[0] = (sc2mac_a_wt_payload.mask[0] << 2) | element_mask_bit;
                                }
                                sc2mac_a_wt_payload.sel = ((uint64_t)0x1) << kernel_iter;
                                if ((sc2mac_a_wt_payload.sel & CSC2CMAC_WEIGHT_MASK)) {
                                    cslDebug((70, "sc2mac_a_wt_payload (part a) is\n"));
                                } else { //if ((sc2mac_a_wt_payload.sel >> 8) & 0xFF)  {
                                    cslDebug((70, "sc2mac_a_wt_payload (part b) is\n"));
                                }
                                cslDebug((50, "    mask[0]=0x%016lx\n", (uint64_t)sc2mac_a_wt_payload.mask[0]));
                                cslDebug((50, "    mask[1]=0x%016lx\n", (uint64_t)sc2mac_a_wt_payload.mask[1]));
                                cslDebug((70, "    sel is 0x%lx\n", sc2mac_a_wt_payload.sel));
#if LOG_DETAIL
                                for (uint32_t idx_db = 0; idx_db < NVDLA_CBUF_BANK_WIDTH; idx_db++) {
                                    cslDebug((90, "    Weight[%d]: 0x%02x\n", idx_db, (uint8_t)(sc2mac_a_wt_payload.data[idx_db].to_int())));
                                }
#endif
                                if ((sc2mac_a_wt_payload.sel & CSC2CMAC_WEIGHT_MASK)) {
                                    sc2mac_a_wt_b_transport(&sc2mac_a_wt_payload, b_transport_delay_);
                                } else { // if ((sc2mac_a_wt_payload.sel >> 8) & 0xFF)  {
                                    sc2mac_a_wt_payload.sel = sc2mac_a_wt_payload.sel >> (NVDLA_MAC_ATOMIC_K_SIZE / 2);
                                    sc2mac_b_wt_b_transport(&sc2mac_a_wt_payload, b_transport_delay_);
                                }
                            }
                        }
                        // Notify data thread that a kernel group is ready
                        kernel_switch_round_weight_ ++;
                        kernel_switch_updated_.notify();
                        cslDebug((30, "end of stripe_operation_iter=%d\n", stripe_operation_iter));
                    }
                    cslDebug((30, "end of block_operation_iter=%d\n", block_operation_iter));
                }
                cslDebug((30, "end of channel_operation_iter=%d\n", channel_operation_iter));
            }
            cslDebug((30, "end of out_line_iter=%d\n", out_line_iter));
        }
        // End of a kernel group

        if (NVDLA_CSC_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED==weight_format) {
            if (kernel_group_iter == kernel_group_num - 1) {
                uint32_t total_wt_entries = (csc_weight_bytes_ << NVDLA_CSC_D_WEIGHT_BYTES_0_WEIGHT_BYTES_SHIFT) / NVDLA_CBUF_BANK_WIDTH;  // The actual bytes of weight is csc_weight_bytes_*(1<<7)
                wt_up_sc2cdma_payload.wt_entries = total_wt_entries - comp_released_wt_entries;
                weight_entry_idx_start_ += total_wt_entries - comp_released_wt_entries;
                if (total_wt_entries - comp_released_wt_entries != comp_updated_wt_entry_num) {
                    cslInfo(("total_wt_entries=0x%x comp_released_wt_entries=0x%x comp_updated_wt_entry_num=0x%x\n", total_wt_entries, comp_released_wt_entries, comp_updated_wt_entry_num));
                    //FAIL(("In the end of last kernel group in weight compression mode, the wt entry num used should be same as available wt entries\n"));
                }

                uint32_t total_wmb_entries = (csc_wmb_bytes_ << NVDLA_CSC_D_WMB_BYTES_0_WMB_BYTES_SHIFT) / NVDLA_CBUF_BANK_WIDTH;  // The actual bytes of wmb is csc_wmb_bytes_*(1<<7)
                wt_up_sc2cdma_payload.wmb_entries = total_wmb_entries - comp_released_wmb_entries;
                wmb_entry_idx_start_ += total_wmb_entries - comp_released_wmb_entries;
                if (total_wmb_entries - comp_released_wmb_entries != comp_updated_wmb_entry_num) {
                    cslInfo(("total_wmb_entries=0x%x comp_released_wmb_entries=0x%x comp_updated_wmb_entry_num=0x%x\n", total_wmb_entries, comp_released_wmb_entries, comp_updated_wmb_entry_num));
                    //FAIL(("In the end of last kernel group in weight compression mode, the wmb entry num used should be same as available wmb entries\n"));
                }
            } else {
                wt_up_sc2cdma_payload.wt_entries = comp_updated_wt_entry_num;
                weight_entry_idx_start_ += comp_updated_wt_entry_num;
                wt_up_sc2cdma_payload.wmb_entries = comp_updated_wmb_entry_num;
                wmb_entry_idx_start_ += comp_updated_wmb_entry_num;
            }
            comp_released_wt_entries += wt_up_sc2cdma_payload.wt_entries;
            comp_released_wmb_entries += wt_up_sc2cdma_payload.wmb_entries;
        } else {
            wt_up_sc2cdma_payload.wt_entries = updated_entry_num;
            wt_up_sc2cdma_payload.wmb_entries = 0;
            weight_entry_idx_start_ += updated_entry_num;
        }
        if ( false == is_skip_weight_rls_mode ) { // Release KPG once a kernel group is done
            weight_kernel_num_used_ += kernel_per_group;
            wt_up_sc2cdma_payload.wt_kernels = kernel_per_group;
            wt_up_sc2cdma_b_transport(&wt_up_sc2cdma_payload, b_transport_delay_);
            cslInfo(("after wt_up_sc2cdma_b_transport. wt_kernels = 0x%x wt_entries=0x%x wmb_entries=0x%xn", wt_up_sc2cdma_payload.wt_kernels, wt_up_sc2cdma_payload.wt_entries, wt_up_sc2cdma_payload.wmb_entries));
        }
        if (NVDLA_CSC_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED==weight_format) {
            save_info_kernel_group();
        } else {
            // Copy left valid data in read_data_curr_ptr to a backup buffer
            memcpy(kg_wt_first_entry_buffer, read_data_curr_ptr, NVDLA_CBUF_BANK_WIDTH);
        }
        cslDebug((30, "end of kernel_group_iter=%d\n", kernel_group_iter));
    }
    // End of layer
    // TODO: assert on weight_entry_idx_start_ to be the end of current layer

    delete [] read_data_curr_ptr;
    delete [] read_data_prev_ptr;
    delete [] read_data_reorder;
}

void NV_NVDLA_csc::SendImageDataToMacSequencerConvCommon() {
    // Config variables, they have corresponding value in registers
    uint32_t cube_in_height;
    uint32_t cube_in_channel;
    uint32_t cube_out_width;
    uint32_t cube_out_height;
    uint32_t cube_out_channel;
    uint32_t precision;
    uint32_t pad_top;
    uint8_t  post_y_extension;
    uint32_t kernel_width;
    uint32_t kernel_height;
    uint32_t kernel_channel;
    uint32_t kernel_stride_w;
    uint32_t kernel_stride_h;
    //uint32_t cbuf_entry_for_data;
    // Control variables
    uint32_t element_size;
    uint32_t out_surface_num;
    uint32_t stripe_num;
    uint32_t super_channel_num;
    uint32_t kernel_atom_num;
    uint32_t ideal_stripe_length;
    uint32_t current_stripe_length, last_stripe_length;
    //uint32_t output_atom_num, output_atom_sent_num;
    uint32_t output_atom_sent_num;
    uint32_t input_atom_coor_height,  input_atom_coor_width;
    uint32_t output_atom_coor_height, output_atom_coor_width;
    uint32_t kernel_atom_coor_height;//, kernel_atom_coor_width;
    uint32_t last_super_channel_element_num;
    uint32_t required_slice_num;
    uint32_t cbuf_entry_per_line;
    // # Iterators
    uint32_t out_surface_iter;
    uint32_t stripe_iter;
    uint32_t super_channel_iter;
    uint32_t kernel_atom_iter;
    uint32_t output_atom_iter;
    uint32_t channel_iter;
    uint32_t out_line_iter;
    uint32_t read_payload_gran_iter;
    //bool     last_stripe_in_block;
    // Temp variables
    int      idx;
    bool     last_super_channel;
    sc_uint<64> *read_data_ptr;
    uint8_t  read_data_ptr_tmp[NVDLA_CBUF_BANK_WIDTH];
    uint8_t  read_data_ptr_tmp0[NVDLA_CBUF_BANK_WIDTH], read_data_ptr_tmp1[NVDLA_CBUF_BANK_WIDTH], read_data_ptr_tmp2[NVDLA_CBUF_BANK_WIDTH], read_data_ptr_tmp3[NVDLA_CBUF_BANK_WIDTH];
    uint64_t *read_data_ptr_tmp_64;
    cslInfo(("NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, start\n"));
    read_data_ptr = new sc_uint<64> [NVDLA_CBUF_BANK_WIDTH / sizeof(uint64_t)];

    // Copy from register value to local config variables, similar with RTL connection
    cube_in_height          = csc_datain_height_ext_ + 1;
    cube_in_channel         = csc_datain_channel_ext_ + 1;
    cube_out_width          = csc_dataout_width_ + 1;
    cube_out_height         = csc_dataout_height_ + 1;
    cube_out_channel        = csc_dataout_channel_ + 1;
    precision               = csc_proc_precision_;
    pad_top                 = csc_pad_top_;
    kernel_width            = csc_weight_width_ext_ + 1;
    kernel_height           = csc_weight_height_ext_ + 1;
    kernel_channel          = csc_weight_channel_ext_ + 1;
    kernel_stride_w         = csc_conv_x_stride_ext_ + 1;
    kernel_stride_h         = csc_conv_y_stride_ext_ + 1;
    cbuf_entry_per_line     = csc_entries_ + 1;    // entries per line
    //cbuf_entry_for_data     = (csc_data_bank_+1) * NVDLA_CBUF_BANK_DEPTH;
    post_y_extension        = 1 << csc_y_extension_ ;   // Valid values: 1, 2, 4
//    ideal_stripe_length     = NVDLA_MAC_ATOMIC_K_SIZE * 2;
  ideal_stripe_length     = (NVDLA_MAC_ATOMIC_C_SIZE / NVDLA_MAC_ATOMIC_K_SIZE == 4)? (NVDLA_MAC_ATOMIC_K_SIZE * 4) : (NVDLA_MAC_ATOMIC_K_SIZE * 2);

    // Evaluated
    switch (precision) {
        case DATA_FORMAT_INT8:
            element_size = ELEMENT_SIZE_INT8;
            break;
        case DATA_FORMAT_INT16:
            element_size = ELEMENT_SIZE_INT16;
            break;
        case DATA_FORMAT_FP16:
            element_size = ELEMENT_SIZE_FP16;
            break;
        default:
            break;
    }

    // kernel_width and kernel_height are the values after pre-extension
    kernel_atom_num   = (kernel_height * kernel_width + post_y_extension - 1) / post_y_extension;
    out_surface_num = (cube_out_channel + NVDLA_MEMORY_ATOMIC_SIZE - 1) / NVDLA_MEMORY_ATOMIC_SIZE;
    super_channel_num = (kernel_channel + NVDLA_MAC_ATOMIC_C_SIZE - 1) / NVDLA_MAC_ATOMIC_C_SIZE; // kernel_channel is the value after pre-extension
    last_super_channel_element_num = (0==(kernel_channel % NVDLA_MAC_ATOMIC_C_SIZE))? NVDLA_MAC_ATOMIC_C_SIZE: (kernel_channel % NVDLA_MAC_ATOMIC_C_SIZE);

    if (kernel_width != 1) {
        FAIL(("NV_NVDLA_csc::SendImageDataToMacSequencerConvCommon, invalid configuration kernel_width, actual value is 0x%X, it shall be 1.", kernel_width));
    }

    slice_idx_free_ = 0;

    // For Image-in, batch mode is not supported
    sc2mac_a_dat_payload.pd.nvdla_stripe_info.batch_index = 0;
    required_slice_num = cube_in_height;
    cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerDirectConvCommon, WaitUntilCBufferHasEnoughtAvailiableDataEntriesFullInput, wait cbuffer.\n"));
    WaitUntilCBufferHasEnoughtAvailiableDataEntriesFullInput(required_slice_num*cbuf_entry_per_line);

    // Compute last stripe length of each line
    last_stripe_length = ((cube_out_width % ideal_stripe_length)==0)? ideal_stripe_length: (cube_out_width % ideal_stripe_length);
    // Compute stripe number of each line
    stripe_num = (cube_out_width - last_stripe_length) / ideal_stripe_length + 1;

    cslDebug((50, "NV_NVDLA_csc::SendImageDataToMacSequencerConvCommon, out_surface_num is: 0x%x\n", out_surface_num));
    cslDebug((50, "NV_NVDLA_csc::SendImageDataToMacSequencerConvCommon, stripe_num in one line is: 0x%x\n", stripe_num));
    cslDebug((50, "NV_NVDLA_csc::SendImageDataToMacSequencerConvCommon, last_super_channel_element_num is: 0x%x\n", last_super_channel_element_num));

    // each out_surface (a channel of output cube) corresponds to a group(number of 16) of kernels
    for (out_surface_iter = 0; out_surface_iter < out_surface_num; out_surface_iter++) {
        for (out_line_iter=0; out_line_iter < cube_out_height; out_line_iter++) { // Loop on lines of output cube (stripe operation shall never across output lines.)
            for (stripe_iter=0; stripe_iter < stripe_num; stripe_iter++){ // Each loop is a channel operation
                output_atom_sent_num = stripe_iter * ideal_stripe_length; // atom_sent_num in each line (not entire output cube)
                // Determine current stripe length
                current_stripe_length = (stripe_iter < (stripe_num - 1)) ? ideal_stripe_length : last_stripe_length;
                WaitUntilThereIsEnoughSpaceInCaccu(current_stripe_length);
                // In each stripe, the number of channel is kernel's channel size after pre-extension
                for (super_channel_iter = 0; super_channel_iter < super_channel_num; super_channel_iter++) { // Each loop is a block operation
                    last_super_channel = super_channel_iter == super_channel_num-1;
                    for (kernel_atom_iter=0; kernel_atom_iter < kernel_atom_num; kernel_atom_iter++) { // Each loop is a stripe operation
                        // last_stripe_in_block = kernel_atom_iter == (kernel_atom_num-1);
                        kernel_atom_coor_height = kernel_atom_iter / kernel_width;    // kernel_width is 1
                        for (output_atom_iter = output_atom_sent_num; output_atom_iter < output_atom_sent_num + current_stripe_length; output_atom_iter++) { // Each loop is an atom operation
                            // Perform atomic operations on all atoms IN CURRENT STRIPE
                            // Fetch data from CBUF
                            // Prepare CSC-to-CMAC data payload
                            // Notify CMAC needs to reload weight
                            if (output_atom_iter == output_atom_sent_num) { //The 1st atom of the stripe
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_st = 1;
                                cslDebug((50, "NV_NVDLA_csc::SendImageDataToMacSequencerDirectConvCommon, before WaitUntilKernelsAreReady.\n"));
                                WaitUntilKernelsAreReady(); //Kernels should be loaded into shadow before featue data
                                cslDebug((50, "NV_NVDLA_csc::SendImageDataToMacSequencerDirectConvCommon, a group of weight for a stripe operation was ready.\n"));
                            } else {
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_st = 0;
                            }

                            // Notify CACC once partial round is done
                            if (output_atom_iter == (output_atom_sent_num + current_stripe_length - 1)) { //The last atom of the stripe
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end = 1;
                            } else {
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end = 0;
                            }

                            // All channels done, notify CACC current data is the last partial sum, CACCU could send out data. The condition (sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end == 1) is not required.
                            if ((kernel_atom_iter == kernel_atom_num - 1) && last_super_channel) { //The last stripe of the last block operation
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.channel_end = 1;
                                cslDebug((30, "NV_NVDLA_csc::SendImageDataToMacSequencerConvCommon, got a channel_end, out_surface_iter is 0x%x, out_surface_num is 0x%x, stripe_iter is 0x%x, stripe_num is 0x%x\n", out_surface_iter, out_surface_num, stripe_iter, stripe_num));
                                if ( (out_surface_iter == out_surface_num - 1) && (out_line_iter == cube_out_height - 1) && (stripe_iter == stripe_num - 1) ) {    //The last atom of the input cube
                                    // Layer done, notify CACC set the hardware layer done bit
                                    sc2mac_a_dat_payload.pd.nvdla_stripe_info.layer_end = 1;
                                } else {
                                    sc2mac_a_dat_payload.pd.nvdla_stripe_info.layer_end = 0;
                                }
                            } else {
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.channel_end = 0;
                                sc2mac_a_dat_payload.pd.nvdla_stripe_info.layer_end = 0;
                            }

                            // Calculate coordinates(in pixel and after pre-extension) of input atom 
                            output_atom_coor_width = output_atom_iter%cube_out_width;  // output_atom_iter should be less than cube_out_width
                            output_atom_coor_height = out_line_iter;
                            // The position in the current input line(after pre-extension) (in element, not in byte or in pixel. include padding)
                            // Here input_atom_coor_width is actually the coordicate in channel direction. The real input_atom_coor_width is always 0 since the width of input cube is 1(after pre-extension).
                            input_atom_coor_width  = output_atom_coor_width * (kernel_stride_w * cube_in_channel) + super_channel_iter * NVDLA_MAC_ATOMIC_C_SIZE;
                            input_atom_coor_height = output_atom_coor_height * kernel_stride_h + kernel_atom_coor_height * post_y_extension - pad_top;
                            cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerImageConvCommon, sc2buf_dat_rd_b_transport\n"));
                            cslDebug((50, "    out_surface_iter           is %d\n", out_surface_iter));
                            cslDebug((50, "    out_line_iter              is %d\n", out_line_iter));
                            cslDebug((50, "    stripe_iter                is %d\n", stripe_iter));
                            cslDebug((50, "    super_channel_iter         is %d\n", super_channel_iter));
                            cslDebug((50, "    kernel_atom_iter           is %d\n", kernel_atom_iter));
                            cslDebug((50, "    output_atom_iter           is %d\n", output_atom_iter));
                            cslDebug((50, "    current_stripe_length      is %d\n", current_stripe_length));
                            cslDebug((50, "    output_atom_coor_width     is %d\n", output_atom_coor_width));
                            cslDebug((50, "    output_atom_coor_height    is %d\n", output_atom_coor_height));
                            cslDebug((50, "    input_atom_coor_width      is %d\n", input_atom_coor_width));
                            cslDebug((50, "    input_atom_coor_height     is %d\n", input_atom_coor_height));

                            if (post_y_extension == 1)
                                csc_read_one_image_entry(post_y_extension, 0, input_atom_coor_width, input_atom_coor_height, cbuf_entry_per_line, element_size, last_super_channel, last_super_channel_element_num, cube_in_height, cube_in_channel, &read_data_ptr_tmp[0]);
                            else if (post_y_extension == 2) {   // post-extension parameter is 2
                                if (!last_super_channel || (last_super_channel_element_num > (NVDLA_MAC_ATOMIC_C_SIZE / 2)))    // The bytes in channel direction should be not larger than 64
                                    FAIL(("There should be only one super channel when post-extension is enabled. last_super_channel=%d last_super_channel_element_num=%d\n", last_super_channel, last_super_channel_element_num));
                                csc_read_one_image_entry(post_y_extension, 0, input_atom_coor_width, input_atom_coor_height, cbuf_entry_per_line, element_size, last_super_channel, last_super_channel_element_num, cube_in_height, cube_in_channel, &read_data_ptr_tmp0[0]);
                                // Even if the line is out of the range of (0, pad_top+cube_height+pad_bottom), still use pad_value ( the corresponding weight is 0)
                                if ((kernel_atom_iter == kernel_atom_num - 1) && ((kernel_height % post_y_extension) == 1))
                                    memset(&read_data_ptr_tmp1, 0, NVDLA_CBUF_BANK_WIDTH);
                                else
                                    csc_read_one_image_entry(post_y_extension, 1, input_atom_coor_width, input_atom_coor_height, cbuf_entry_per_line, element_size, last_super_channel, last_super_channel_element_num, cube_in_height, cube_in_channel, &read_data_ptr_tmp1[0]);
                                if (DATA_FORMAT_INT8 == precision) {
                                    memcpy(&read_data_ptr_tmp,                              read_data_ptr_tmp0, NVDLA_MAC_ATOMIC_C_SIZE / 2);
                                    memcpy(&read_data_ptr_tmp[NVDLA_MAC_ATOMIC_C_SIZE / 2], read_data_ptr_tmp1, NVDLA_MAC_ATOMIC_C_SIZE / 2);
                                } else {
                                    // Assemble two lines (each is 64Bytes) into one 128B. The second 64B should be aligned to 64B. 0 is already filled in the gap by csc_read_one_image_entry().
                                    memcpy(&read_data_ptr_tmp,                          read_data_ptr_tmp0, NVDLA_MAC_ATOMIC_C_SIZE);
                                    memcpy(&read_data_ptr_tmp[NVDLA_MAC_ATOMIC_C_SIZE], read_data_ptr_tmp1, NVDLA_MAC_ATOMIC_C_SIZE);
                                }
                            }
                            else { //if (post_y_extension == 4) {
                                if (!last_super_channel || (last_super_channel_element_num > (NVDLA_MAC_ATOMIC_C_SIZE / 4)))    // The bytes in channel direction should be not larger than 32
                                    FAIL(("There should be only one super channel when post-extension is enabled. last_super_channel=%d last_super_channel_element_num=%d\n", last_super_channel, last_super_channel_element_num));
                                csc_read_one_image_entry(post_y_extension, 0, input_atom_coor_width, input_atom_coor_height, cbuf_entry_per_line, element_size, last_super_channel, last_super_channel_element_num, cube_in_height, cube_in_channel, &read_data_ptr_tmp0[0]);
                                if ((kernel_atom_iter == kernel_atom_num-1) && ((kernel_height % post_y_extension) == 1))
                                    memset(&read_data_ptr_tmp1, 0, NVDLA_CBUF_BANK_WIDTH);
                                else
                                    csc_read_one_image_entry(post_y_extension, 1, input_atom_coor_width, input_atom_coor_height, cbuf_entry_per_line, element_size, last_super_channel, last_super_channel_element_num, cube_in_height, cube_in_channel, &read_data_ptr_tmp1[0]);
                                if ((kernel_atom_iter == kernel_atom_num-1) && (((kernel_height % post_y_extension) == 1) || ((kernel_height % post_y_extension) == 2)))
                                    memset(&read_data_ptr_tmp2, 0, NVDLA_CBUF_BANK_WIDTH);
                                else
                                    csc_read_one_image_entry(post_y_extension, 2, input_atom_coor_width, input_atom_coor_height, cbuf_entry_per_line, element_size, last_super_channel, last_super_channel_element_num, cube_in_height, cube_in_channel, &read_data_ptr_tmp2[0]);
                                if ((kernel_atom_iter == kernel_atom_num-1) && (((kernel_height % post_y_extension) == 1) || ((kernel_height % post_y_extension) == 2) || ((kernel_height % post_y_extension) == 3)))
                                    memset(&read_data_ptr_tmp3, 0, NVDLA_CBUF_BANK_WIDTH);
                                else
                                    csc_read_one_image_entry(post_y_extension, 3, input_atom_coor_width, input_atom_coor_height, cbuf_entry_per_line, element_size, last_super_channel, last_super_channel_element_num, cube_in_height, cube_in_channel, &read_data_ptr_tmp3[0]);
                                if (DATA_FORMAT_INT8 == precision) {
                                    memcpy(&read_data_ptr_tmp,                                    read_data_ptr_tmp0, NVDLA_MAC_ATOMIC_C_SIZE / 4);
                                    memcpy(&read_data_ptr_tmp[(NVDLA_MAC_ATOMIC_C_SIZE / 4) * 1], read_data_ptr_tmp1, NVDLA_MAC_ATOMIC_C_SIZE / 4);
                                    memcpy(&read_data_ptr_tmp[(NVDLA_MAC_ATOMIC_C_SIZE / 4) * 2], read_data_ptr_tmp2, NVDLA_MAC_ATOMIC_C_SIZE / 4);
                                    memcpy(&read_data_ptr_tmp[(NVDLA_MAC_ATOMIC_C_SIZE / 4) * 3], read_data_ptr_tmp3, NVDLA_MAC_ATOMIC_C_SIZE / 4);
                                } else {
                                    // Assemble four lines (each is 32Bytes) into one 128B. Each 32B should be aligned to 32B. 0 is already filled in the gap by csc_read_one_image_entry().
                                    memcpy(&read_data_ptr_tmp,     read_data_ptr_tmp0, NVDLA_MAC_ATOMIC_C_SIZE / 2);
                                    memcpy(&read_data_ptr_tmp[(NVDLA_MAC_ATOMIC_C_SIZE / 2) * 1], read_data_ptr_tmp1, NVDLA_MAC_ATOMIC_C_SIZE / 2);
                                    memcpy(&read_data_ptr_tmp[(NVDLA_MAC_ATOMIC_C_SIZE / 2) * 2], read_data_ptr_tmp2, NVDLA_MAC_ATOMIC_C_SIZE / 2);
                                    memcpy(&read_data_ptr_tmp[(NVDLA_MAC_ATOMIC_C_SIZE / 2) * 3], read_data_ptr_tmp3, NVDLA_MAC_ATOMIC_C_SIZE / 2);
                                }
                            }

                            // Convert to sc_uint<64>
                            read_data_ptr_tmp_64 = reinterpret_cast <uint64_t*> (read_data_ptr_tmp);
                            for (read_payload_gran_iter = 0; read_payload_gran_iter < NVDLA_CBUF_BANK_WIDTH / sizeof(uint64_t); read_payload_gran_iter++) {
                                read_data_ptr[read_payload_gran_iter] = read_data_ptr_tmp_64[read_payload_gran_iter];
                            }
                            // 0 is already filled in cripple channel by csc_read_one_image_entry()
                            switch (precision) {
                                case DATA_FORMAT_INT8:
                                    for (channel_iter=0; channel_iter < NVDLA_MAC_ATOMIC_C_SIZE; channel_iter++) {
//                                        cslDebug((70, "channel_iter=%d data=0x%x\n", channel_iter, (uint64_t)read_data_ptr[channel_iter/4]));
                                        uint32_t elm_num = sizeof(uint64_t) / ELEMENT_SIZE_INT8;
                                        sc2mac_a_dat_payload.data[channel_iter] = read_data_ptr[channel_iter / elm_num].range((channel_iter % elm_num) * 8 + 7, (channel_iter % elm_num) * 8);
                                        // sc2mac_a_dat_payload.data[channel_iter + NVDLA_MAC_ATOMIC_C_SIZE] = sc2mac_a_dat_payload.data[channel_iter];
                                    }
                                    break;
                                case DATA_FORMAT_INT16:
                                case DATA_FORMAT_FP16:
                                    for (channel_iter=0; channel_iter < NVDLA_MAC_ATOMIC_C_SIZE; channel_iter++) { //NVDLA_MAC_ATOMIC_C_SIZE=64
                                        // cslDebug((70, "channel_iter=%d data=0x%x\n", channel_iter, (uint64_t)read_data_ptr[channel_iter/4]));
                                        uint32_t elm_num = sizeof(uint64_t) / ELEMENT_SIZE_INT16;
                                        (sc2mac_a_dat_payload.data[channel_iter * 2 + 1].range(7, 0), sc2mac_a_dat_payload.data[channel_iter * 2].range(7, 0)) = read_data_ptr[channel_iter / elm_num].range((channel_iter % elm_num + 1) * 16 - 1, channel_iter % elm_num * 16);
                                    }
                                    break;
                                default:
                                    break;
                            }

                            // Send CSC-to-CMAC data payload
                            sc2mac_a_dat_payload.mask[0] = 0x0ULL;
                            sc2mac_a_dat_payload.mask[1] = 0x0ULL;
                            switch (precision) {
                                case DATA_FORMAT_INT8:
                                    for (idx = NVDLA_MAC_ATOMIC_C_SIZE - 1; idx >= 0; idx--) {
                                        // sc2mac_a_dat_payload.mask is per element
                                        // type of sc2mac_a_dat_payload.data[i] is sc_int<10>
                                        // If the data[i] is 0, then RTL code will not assign value to the registers to reduce toggle and save power
                                        uint8_t element_mask_bit = (sc2mac_a_dat_payload.data[idx] != 0)? 1 : 0;
                                        if (idx < NVDLA_MAC_ATOMIC_C_SIZE / 2)
                                            sc2mac_a_dat_payload.mask[1] = (sc2mac_a_dat_payload.mask[1] << 1) | element_mask_bit;
                                        else
                                            sc2mac_a_dat_payload.mask[0] = (sc2mac_a_dat_payload.mask[0] << 1) | element_mask_bit;
                                    }
                                    break;
                                case DATA_FORMAT_INT16:
                                    for (idx = NVDLA_MAC_ATOMIC_C_SIZE - 1; idx >= 0; idx--) {
                                        sc_uint<16> tmp_v = (sc2mac_a_dat_payload.data[idx * 2 + 1].range(7, 0), sc2mac_a_dat_payload.data[idx * 2].range(7, 0));
                                        uint8_t element_mask_bit = (tmp_v != 0)? 3 : 0;
                                        if (idx < NVDLA_MAC_ATOMIC_C_SIZE / 2)
                                            sc2mac_a_dat_payload.mask[1] = (sc2mac_a_dat_payload.mask[1] << 2) | element_mask_bit;
                                        else
                                            sc2mac_a_dat_payload.mask[0] = (sc2mac_a_dat_payload.mask[0] << 2) | element_mask_bit;
                                    }
                                    break;
                                case DATA_FORMAT_FP16:
                                    for (idx = NVDLA_MAC_ATOMIC_C_SIZE - 1; idx >= 0; idx--) {
                                        sc_uint<16> tmp_v = (sc2mac_a_dat_payload.data[idx * 2 + 1].range(7, 0), sc2mac_a_dat_payload.data[idx * 2].range(7, 0));
                                        uint8_t element_mask_bit = ((tmp_v != 0) && (tmp_v!=0x8000UL))? 3 : 0;   // Both +0 and -0 have to be involved for FP16
                                        if (idx < NVDLA_MAC_ATOMIC_C_SIZE / 2)
                                            sc2mac_a_dat_payload.mask[1] = (sc2mac_a_dat_payload.mask[1] << 2) | element_mask_bit;
                                        else
                                            sc2mac_a_dat_payload.mask[0] = (sc2mac_a_dat_payload.mask[0] << 2) | element_mask_bit;
                                    }
                                    break;
                                default:
                                    break;
                            }
                            cslDebug((50, "sc2mac_a_dat_payload: stripe_st=%d\n", (uint32_t)sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_st));
                            cslDebug((50, " stripe_end=%d\n", (uint32_t)sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end));
                            cslDebug((50, " channel_end=%d\n", (uint32_t)sc2mac_a_dat_payload.pd.nvdla_stripe_info.channel_end));
                            cslDebug((50, " layer_end=%d\n", (uint32_t)sc2mac_a_dat_payload.pd.nvdla_stripe_info.layer_end));
                            cslDebug((50, " mask[0]=0x%016lx\n", (uint64_t)sc2mac_a_dat_payload.mask[0]));
                            cslDebug((50, " mask[1]=0x%016lx\n", (uint64_t)sc2mac_a_dat_payload.mask[1]));
#if LOG_DETAIL
                            for (uint32_t idx_db = 0; idx_db < NVDLA_CBUF_BANK_WIDTH; idx_db++) {
                                cslDebug((90, "    Data[%d]: 0x%x\n", idx_db, sc2mac_a_dat_payload.data[idx_db].to_int()));
                            }
                            cslDebug((90, "\n"));
#endif
                            sc2mac_a_dat_b_transport (&sc2mac_a_dat_payload, b_transport_delay_);
                            sc2mac_b_dat_b_transport (&sc2mac_a_dat_payload, b_transport_delay_);
                            if (sc2mac_a_dat_payload.pd.nvdla_stripe_info.channel_end && sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end) {
                                cacc_free_entry_num_ -= current_stripe_length;
                                cslDebug((50, "Updated credit: cacc_free_entry_num_=%lx\n", cacc_free_entry_num_));
                            }

                            if ( 1 == sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_st ) {
                                // after data stripe_start has been sent, notify weight thread previous shadow (in CMAC) has been loaded into active
                                // weight load could send to next kernel to CMAC
                                kernel_switch_round_data_ ++;
                                stripe_begin_updated_.notify();
                            }
                        }
                    }
                }
            }
        }
    }

    delete [] read_data_ptr;
}

// To step
// 1) Wait CDMA-CSC communication, get data from CBUF
// 2) Two conditions:
//      1) Wait weight_load -> data_load communication
//      2) ACCU has enough free entries
//     send data to mac
void NV_NVDLA_csc::SendDataToMacSequencerWinoConvCommon() {
    // Config variables, they have corresponding value in registers
    uint32_t cube_in_width;
    uint32_t cube_in_height;
    uint32_t cube_in_channel;
    uint32_t cube_out_width;
    uint32_t cube_out_height;
    uint32_t cube_out_channel;
    uint32_t precision;
    uint32_t cbuf_entry_for_data;
    uint32_t pra_truncate;
    // uint32_t cbuf_entry_for_weight;
    // Control variables
    uint32_t element_size;
    uint32_t out_surface_num;
    uint32_t stripe_num;
    uint32_t super_channel_num;
    uint32_t current_stripe_length, last_stripe_length;
    uint32_t output_2x2_num, output_2x2_sent_num;
    uint32_t cbuf_entry_per_slice;
    uint32_t cbuf_entry_addr_0, cbuf_entry_addr_1, cbuf_entry_addr_2, cbuf_entry_addr_3;
    int32_t  input_4x4_coor_height,  input_4x4_coor_width;
    uint32_t output_2x2_coor_height, output_2x2_coor_width;
    uint32_t required_slice_num;
    uint32_t atom_ratio_cacc_to_csc;
    uint32_t cube_in_4x4_width;
    uint32_t cube_in_4x4_height;
    uint32_t cube_out_2x2_width;
    uint32_t cube_out_2x2_height;
    // # Iterators
    uint32_t out_surface_iter;
    uint32_t stripe_iter;
    uint32_t super_channel_iter;
    uint32_t output_2x2_iter;
    uint32_t idx_c;
    // Temp variables
    uint8_t  read_data_ptr[NVDLA_CBUF_BANK_WIDTH];
    uint8_t  read_data_ptr_0[NVDLA_CBUF_BANK_WIDTH], read_data_ptr_1[NVDLA_CBUF_BANK_WIDTH], read_data_ptr_2[NVDLA_CBUF_BANK_WIDTH], read_data_ptr_3[NVDLA_CBUF_BANK_WIDTH];
    uint8_t map_out_seq_x[4] = {0, 0, 1, 1};
    uint8_t map_out_seq_y[4] = {0, 1, 0, 1};
    uint32_t trans_id = 0;
    cslInfo(("NV_NVDLA_csc::SendDataToMacSequencerWinoConvCommon, start\n"));
    // CBUF read request payload sc2buf_dat_rd_nvdla_ram_addr_ADDR_WIDTH_12_BE_1_payload

    // Copy from register value to local config variables, similar with RTL connection
    cube_in_width           = csc_datain_width_ext_ + 1;
    cube_in_height          = csc_datain_height_ext_ + 1;
    cube_in_channel         = csc_datain_channel_ext_ + 1;
    cube_out_width          = csc_dataout_width_ + 1;
    cube_out_height         = csc_dataout_height_ + 1;
    cube_out_channel        = csc_dataout_channel_ + 1;
    precision               = csc_proc_precision_;
    pra_truncate            = csc_pra_truncate_;
    cbuf_entry_for_data     = (csc_data_bank_+1) * NVDLA_CBUF_BANK_DEPTH;

    // Evaluated
    switch (precision) {
        case DATA_FORMAT_INT8:
            element_size        = ELEMENT_SIZE_INT8;
            break;
        case DATA_FORMAT_INT16:
            element_size        = ELEMENT_SIZE_INT16;
            break;
        case DATA_FORMAT_FP16:
            element_size        = ELEMENT_SIZE_FP16;
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    }
    atom_ratio_cacc_to_csc = 4;

    cube_in_4x4_width  = cube_in_width / 4;
    cube_in_4x4_height = cube_in_height / 4;
    uint32_t channel_size_per_cbuf_entry = NVDLA_CBUF_BANK_WIDTH / (4 * 4);
    super_channel_num  = cube_in_channel / channel_size_per_cbuf_entry;
#pragma CTC SKIP
    if (cube_in_channel%4 != 0)
        FAIL(("Incorrect Winograd configuration. cube_in_channel=0x%x\n", cube_in_channel));
#pragma CTC ENDSKIP
    cube_out_2x2_width  = cube_out_width / 2;
    cube_out_2x2_height = cube_out_height / 2;
    output_2x2_num      = cube_out_2x2_width * cube_out_2x2_height;
#pragma CTC SKIP
    if (output_2x2_num % 4 != 0)
        FAIL(("Incorrect Winograd configuration. output_2x2_num=0x%x\n", output_2x2_num));
#pragma CTC ENDSKIP
    out_surface_num = (cube_out_channel + NVDLA_MEMORY_ATOMIC_SIZE - 1) / NVDLA_MEMORY_ATOMIC_SIZE;
    if (output_2x2_num <= 32) {
        last_stripe_length = output_2x2_num;
    } else {
        last_stripe_length = output_2x2_num - (((output_2x2_num + NVDLA_MAC_ATOMIC_K_SIZE - 1) / NVDLA_MAC_ATOMIC_K_SIZE) - 2) * NVDLA_MAC_ATOMIC_K_SIZE;
    }
    stripe_num = (output_2x2_num - last_stripe_length) / NVDLA_MAC_ATOMIC_K_SIZE + 1;   // In unit of 2x2

    cbuf_entry_per_slice = 4 * cube_in_width * element_size * cube_in_channel / NVDLA_CBUF_BANK_WIDTH;
#pragma CTC SKIP
    if (uint32_t(csc_entries_+1) != cbuf_entry_per_slice / 4) {
        FAIL(("%s, invalid configuration csc_entries_, register value is 0x%X, it should be 0x%X.", __FUNCTION__, csc_entries_, cbuf_entry_per_slice / 4 - 1));
    }
#pragma CTC ENDSKIP

    slice_idx_free_ = 0;

    // For looping
    sc2mac_a_dat_payload.pd.nvdla_stripe_info.batch_index = 0;
    required_slice_num = cube_in_4x4_height;
    cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerWinoConvCommon, WaitUntilCBufferHasEnoughtAvailiableDataEntriesFullInput, wait cbuffer.\n"));
    WaitUntilCBufferHasEnoughtAvailiableDataEntriesFullInput(required_slice_num * cbuf_entry_per_slice);

    // each out_surface (a channel of output cube) corresponds to a group(number of 16) of kernels
    for (out_surface_iter = 0; out_surface_iter < out_surface_num; out_surface_iter++) {
        for (stripe_iter = 0; stripe_iter < stripe_num; stripe_iter++){ // Each loop is a channel operation which contains a stripe of ouput atoms
            output_2x2_sent_num = stripe_iter * NVDLA_MAC_ATOMIC_K_SIZE;
            current_stripe_length = (stripe_iter < (stripe_num - 1)) ? NVDLA_MAC_ATOMIC_K_SIZE : last_stripe_length;
            cslDebug((50, "%s: stripe_iter:%d, current_stripe_length:%d\n", __FUNCTION__, stripe_iter, current_stripe_length));
            WaitUntilThereIsEnoughSpaceInCaccu(current_stripe_length * atom_ratio_cacc_to_csc);
            for (super_channel_iter=0; super_channel_iter < super_channel_num; super_channel_iter++) { // Loop in Channel direction of Input Cube
                // Each block operation contains only one strip operation
                for (output_2x2_iter = output_2x2_sent_num; output_2x2_iter < output_2x2_sent_num + current_stripe_length; output_2x2_iter++) { // Stripe operation loop
                    // Notify CMAC needs to reload weight
                    if (output_2x2_iter == output_2x2_sent_num) { //The 1st atom of the stripe
                        sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_st = 1;
                        cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerWinoConvCommon, before WaitUntilKernelsAreReady.\n"));
                        WaitUntilKernelsAreReady(); //Kernels should be loaded into shadow before featue data
                        cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerWinoConvCommon, a group of weight for a stripe operation was ready.\n"));
                    } else {
                        sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_st = 0;
                    }
                    // Notify CACC one partial round is done
                    if (output_2x2_iter == (output_2x2_sent_num + current_stripe_length - 1)) {
                        sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end = 1;
                    } else {
                        sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end = 0;
                    }
                    if (super_channel_iter == super_channel_num - 1) {
                        sc2mac_a_dat_payload.pd.nvdla_stripe_info.channel_end = 1;
                        if ((out_surface_iter == out_surface_num - 1) && (stripe_iter == stripe_num - 1)) {
                            // Layer done, notify CACC set the hardware layer done bit
                            sc2mac_a_dat_payload.pd.nvdla_stripe_info.layer_end = 1;
                        } else {
                            sc2mac_a_dat_payload.pd.nvdla_stripe_info.layer_end = 0;
                        }
                    } else {
                        sc2mac_a_dat_payload.pd.nvdla_stripe_info.channel_end = 0;
                        sc2mac_a_dat_payload.pd.nvdla_stripe_info.layer_end = 0;
                    }

                    // Read data from CBUF
                    int output_4x4_int = output_2x2_iter / 4;
                    int output_4x4_frac = output_2x2_iter % 4;

                    output_2x2_coor_width = (output_4x4_int % (cube_out_2x2_width / 2)) * 2 + (map_out_seq_x[output_4x4_frac]);
                    output_2x2_coor_height = (output_4x4_int / (cube_out_2x2_width / 2)) * 2 + (map_out_seq_y[output_4x4_frac]);
                    input_4x4_coor_width  = output_2x2_coor_width * 2;  // conv_stride must be 0 here as the stride already channel extended
                    input_4x4_coor_height = output_2x2_coor_height * 2;
                    cslDebug((50, "NV_NVDLA_csc::SendDataToMacSequencerWinoConvCommon, sc2buf_dat_rd_b_transport\n"));
                    cslDebug((50, "    out_surface_iter           is %d\n", out_surface_iter));
                    cslDebug((50, "    stripe_iter                is %d\n", stripe_iter));
                    cslDebug((50, "    super_channel_iter         is %d\n", super_channel_iter));
                    cslDebug((50, "    output_2x2_coor_width      is %d\n", output_2x2_coor_width));
                    cslDebug((50, "    output_2x2_coor_height     is %d\n", output_2x2_coor_height));
                    cslDebug((50, "    input_4x4_coor_width       is %d\n", input_4x4_coor_width));
                    cslDebug((50, "    input_4x4_coor_height      is %d\n", input_4x4_coor_height));
                    if (((input_4x4_coor_width % 4) == 0) && ((input_4x4_coor_height % 4) == 0)) {
                        cbuf_entry_addr_0 = (data_entry_idx_free_ + input_4x4_coor_height / 4 * cbuf_entry_per_slice + super_channel_iter * cube_in_4x4_width + input_4x4_coor_width / 4) % cbuf_entry_for_data;
                        cslDebug((50, "    cbuf_entry_addr_0          is %d\n", cbuf_entry_addr_0));
                        read_cbuf_entry(cbuf_entry_addr_0, read_data_ptr);
                    }
#pragma CTC SKIP
                    else if (((input_4x4_coor_width % 4) == 0) && ((input_4x4_coor_height % 4) != 0)) {
#pragma CTC ENDSKIP
                        cbuf_entry_addr_0 = (data_entry_idx_free_ + input_4x4_coor_height / 4 * cbuf_entry_per_slice + super_channel_iter * cube_in_4x4_width + input_4x4_coor_width / 4) % cbuf_entry_for_data;
                        cslDebug((50, "    cbuf_entry_addr_0          is %d\n", cbuf_entry_addr_0));
                        read_cbuf_entry(cbuf_entry_addr_0, read_data_ptr_0);
                        cbuf_entry_addr_1 = (data_entry_idx_free_ + (input_4x4_coor_height / 4 + 1) * cbuf_entry_per_slice + super_channel_iter * cube_in_4x4_width + input_4x4_coor_width / 4) % cbuf_entry_for_data;
                        cslDebug((50, "    cbuf_entry_addr_1          is %d\n", cbuf_entry_addr_1));
                        read_cbuf_entry(cbuf_entry_addr_1, read_data_ptr_1);
                        memcpy(read_data_ptr, &read_data_ptr_0[channel_size_per_cbuf_entry * 8], channel_size_per_cbuf_entry * 8);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry * 8], read_data_ptr_1, channel_size_per_cbuf_entry * 8);
                    }
#pragma CTC SKIP
                    else if (((input_4x4_coor_width % 4) != 0) && ((input_4x4_coor_height % 4) == 0)) {
#pragma CTC ENDSKIP
                        cbuf_entry_addr_0 = (data_entry_idx_free_ + input_4x4_coor_height / 4 * cbuf_entry_per_slice + super_channel_iter * cube_in_4x4_width + input_4x4_coor_width / 4) % cbuf_entry_for_data;
                        cslDebug((50, "    cbuf_entry_addr_0          is %d\n", cbuf_entry_addr_0));
                        read_cbuf_entry(cbuf_entry_addr_0, read_data_ptr_0);
                        cbuf_entry_addr_1 = (data_entry_idx_free_ + input_4x4_coor_height / 4 * cbuf_entry_per_slice + super_channel_iter * cube_in_4x4_width + input_4x4_coor_width / 4 + 1) % cbuf_entry_for_data;
                        cslDebug((50, "    cbuf_entry_addr_1          is %d\n", cbuf_entry_addr_1));
                        read_cbuf_entry(cbuf_entry_addr_1, read_data_ptr_1);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry *  0],   &read_data_ptr_0[channel_size_per_cbuf_entry *  2], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry *  4],  &read_data_ptr_0[channel_size_per_cbuf_entry *  6], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry *  8],  &read_data_ptr_0[channel_size_per_cbuf_entry * 10], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry * 12],  &read_data_ptr_0[channel_size_per_cbuf_entry * 14], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry *  2],  &read_data_ptr_1[channel_size_per_cbuf_entry *  0], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry *  6],  &read_data_ptr_1[channel_size_per_cbuf_entry *  4], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry * 10],  &read_data_ptr_1[channel_size_per_cbuf_entry *  8], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry * 14], &read_data_ptr_1[channel_size_per_cbuf_entry * 12], channel_size_per_cbuf_entry * 2);
                    }
                    else { // ((input_4x4_coor_width%4)!=0) && ((input_4x4_coor_height%4)!=0)
                        // top-left -> left-bottom -> top_right -> bottom_right
                        cbuf_entry_addr_0 = (data_entry_idx_free_ + input_4x4_coor_height / 4 * cbuf_entry_per_slice + super_channel_iter * cube_in_4x4_width + input_4x4_coor_width / 4) % cbuf_entry_for_data;
                        cslDebug((50, "    cbuf_entry_addr_0          is %d\n", cbuf_entry_addr_0));
                        read_cbuf_entry(cbuf_entry_addr_0, read_data_ptr_0);
                        cbuf_entry_addr_1 = (data_entry_idx_free_ + (input_4x4_coor_height / 4 + 1) * cbuf_entry_per_slice + super_channel_iter * cube_in_4x4_width + input_4x4_coor_width / 4) % cbuf_entry_for_data;
                        cslDebug((50, "    cbuf_entry_addr_1          is %d\n", cbuf_entry_addr_1));
                        read_cbuf_entry(cbuf_entry_addr_1, read_data_ptr_1);
                        cbuf_entry_addr_2 = (data_entry_idx_free_ + input_4x4_coor_height / 4 * cbuf_entry_per_slice + super_channel_iter * cube_in_4x4_width + input_4x4_coor_width / 4 + 1) % cbuf_entry_for_data;
                        cslDebug((50, "    cbuf_entry_addr_2          is %d\n", cbuf_entry_addr_2));
                        read_cbuf_entry(cbuf_entry_addr_2, read_data_ptr_2);
                        cbuf_entry_addr_3 = (data_entry_idx_free_ + (input_4x4_coor_height / 4 + 1) * cbuf_entry_per_slice + super_channel_iter * cube_in_4x4_width + input_4x4_coor_width / 4 + 1) % cbuf_entry_for_data;
                        cslDebug((50, "    cbuf_entry_addr_3          is %d\n", cbuf_entry_addr_3));
                        read_cbuf_entry(cbuf_entry_addr_3, read_data_ptr_3);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry *  0],   &read_data_ptr_0[channel_size_per_cbuf_entry * 10], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry *  4],  &read_data_ptr_0[channel_size_per_cbuf_entry * 14], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry *  8],  &read_data_ptr_1[channel_size_per_cbuf_entry *  2], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry * 12],  &read_data_ptr_1[channel_size_per_cbuf_entry *  6], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry *  2],  &read_data_ptr_2[channel_size_per_cbuf_entry *  8], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry *  6],  &read_data_ptr_2[channel_size_per_cbuf_entry * 12], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry * 10],  &read_data_ptr_3[channel_size_per_cbuf_entry *  0], channel_size_per_cbuf_entry * 2);
                        memcpy(&read_data_ptr[channel_size_per_cbuf_entry * 14], &read_data_ptr_3[channel_size_per_cbuf_entry *  4], channel_size_per_cbuf_entry * 2);
                    }
#if ENABLE_PRA_LOG
                    cslDebug((70, "%s: data before pra remapping:\n", __FUNCTION__));
                    for(int32_t idx = NVDLA_CBUF_BANK_WIDTH - 1; idx >= 0; idx--) {
                        cslDebug((70, "%02x", read_data_ptr[idx]));
                    }
                    cslDebug((70, "\n"));
#endif
                    // Perform PRA
                    int16_t pra_hls_out[16];
                    uint16_t pra_hls_in[16 * 4];

                    // Remapping
                    for(idx_c = 0; idx_c < channel_size_per_cbuf_entry; idx_c++) {
                        for(int y = 0; y < 4; y++) {
                            for(int x = 0; x < 4; x++) {
                                if (precision == DATA_FORMAT_INT8) {
                                    pra_hls_in[idx_c * 16 + y * 4 + x] = sign_extend_8to16(read_data_ptr[idx_c + 4 * x + 4 * 4 * y]);
                                } else {
                                    pra_hls_in[idx_c * 16 + y * 4 + x] = ( ( (uint16_t *) read_data_ptr)[idx_c + 4 * x + 4 * 4 * y]);
                                }
                            }
                        }
                    }
#if ENABLE_PRA_LOG
                    cslDebug((70, "%s: data after pra remapping:\n", __FUNCTION__));
                    for (int32_t idx = NVDLA_CBUF_BANK_WIDTH - 1; idx >= 0; idx--) {
                        cslDebug((70, "%02x", ((uint8_t*)pra_hls_in)[idx]));
                    }
                    cslDebug((70, "\n"));
#endif
                    switch (precision) {
                        case DATA_FORMAT_INT8:
                            for (idx_c = 0; idx_c < channel_size_per_cbuf_entry; idx_c++) {     // In channel direction
                                csc_pra_hls(&pra_hls_in[idx_c * 16], precision, pra_truncate, pra_hls_out);   // pra_hls_out is 16x16bits
#if ENABLE_PRA_LOG
                                cslDebug((70, "%s: data after pra calculate@%d round:\n", __FUNCTION__, idx_c));
                                for(int32_t idx = 15; idx >= 0; idx--) {
                                    cslDebug((70, "%02x", ((uint8_t*)pra_hls_out)[idx]));
                                }
                                cslDebug((70, "\n"));
#endif
                                for (int32_t idx = 0; idx < 16; idx++) {
                                    sc2mac_a_dat_payload.data[idx_c + idx * 4] = pra_hls_out[idx] & 0xff;    // Only retrieve the low 8bits
                                }
                            }
                            break;
                        case DATA_FORMAT_INT16:
                        case DATA_FORMAT_FP16:
                            for (idx_c = 0; idx_c < channel_size_per_cbuf_entry; idx_c++) {     // In channel direction
                                csc_pra_hls(&pra_hls_in[16 * idx_c], precision, pra_truncate, pra_hls_out);
#if ENABLE_PRA_LOG
                                cslDebug((70, "%s: data after pra calculate@%d round:\n", __FUNCTION__, idx_c));
                                for(int32_t idx = 15; idx >= 0; idx--) {
                                    cslDebug((70, "%02x", ((uint8_t*)pra_hls_out)[idx]));
                                }
                                cslDebug((70, "\n"));
#endif

//#define WG_CMOD_DEBUG
// Debug CMOD/AMOD mismatch for winograd mode. If this MACRO is defined, user has to:
// 1. set correct condition for log dumping
// 2. grep wg_cmod_debug_post_pra, this is the feature data after PRA (4x4xC) w/ 3D layout. It should be bit-by-bit
//      indentical with cc_debug_feature_pra_out.dat dumped from AMOD
// 3. grep wt_post_pra, this is the wt dataafter PRA (same 4x4xC) w/ 3D layout, it should be bit-by-bit indentical
//      with cc_debug_wt_pra_out.dat dumped from AMOD
#ifdef WG_CMOD_DEBUG
                                if (out_surface_iter == 0 && stripe_iter == 0 && output_2x2_iter == 0) {
                                    cslDebug((30, "WG_CMOD_DEBUG: super_channel_iter:%d\n", super_channel_iter)) ;
                                    cslDebug((70, "WG_CMOD_DEBUG: %s: data before pra calculate@%d round:\n", __FUNCTION__, idx_c));
                                    cslDebug((70, "wg_cmod_debug_pre_pra: "));
                                    for(int32_t idx = 0; idx < 16; idx++) {
                                        cslDebug((70, "0x%02x 0x%02x ", ((uint8_t*)pra_hls_in)[idx*2 + idx_c*32], ((uint8_t*)pra_hls_in)[idx*2 + 1 + idx_c*32]));
                                    }
                                    cslDebug((70, "WG_CMOD_DEBUG:\n"));
                                    cslDebug((70, "WG_CMOD_DEBUG: %s: data after pra calculate@%d round:\n", __FUNCTION__, idx_c));
                                    cslDebug((70, "wg_cmod_debug_post_pra: "));
                                    for(int32_t idx = 0; idx < 16; idx++) {
                                        cslDebug((70, "0x%02x 0x%02x ", ((uint8_t*)pra_hls_out)[idx*2], ((uint8_t*)pra_hls_out)[idx*2+1]));
                                    }
                                    cslDebug((70, "WG_CMOD_DEBUG:\n"));
                                }
#endif
                                for (int32_t idx = 0; idx < 16; idx++) {
                                    (sc2mac_a_dat_payload.data[idx * 8 + 1 + idx_c * 2], sc2mac_a_dat_payload.data[idx * 8 + idx_c * 2]) = pra_hls_out[idx];
                                }
                            }
                            break;
#pragma CTC SKIP
                        default:
                            break;
#pragma CTC ENDSKIP
                    }
                    // Send CSC-to-CMAC data payload
                    sc2mac_a_dat_payload.mask[0] = 0x0ULL;
                    sc2mac_a_dat_payload.mask[1] = 0x0ULL;
                    switch (precision) {
                        case DATA_FORMAT_INT8:
                            for (int32_t idx = NVDLA_MAC_ATOMIC_C_SIZE - 1; idx >= 0; idx--) {
                                // sc2mac_a_dat_payload.mask is per element
                                // type of sc2mac_a_dat_payload.data[i] is sc_int<10>
                                // If the data[i] is 0, then RTL code will not assign value to the registers to reduce toggle and save power
                                // mask[0]: Byte64~Byte127, [31]-B127, ... [0]-B64
                                // mask[1]: Byte0~Byte63, [31]-B63, ... [0]-B0
                                uint8_t element_mask_bit = (sc2mac_a_dat_payload.data[idx] != 0)? 1 : 0;
                                if (idx < NVDLA_MAC_ATOMIC_C_SIZE / 2)
                                    sc2mac_a_dat_payload.mask[1] = (sc2mac_a_dat_payload.mask[1] << 1) | element_mask_bit;
                                else
                                    sc2mac_a_dat_payload.mask[0] = (sc2mac_a_dat_payload.mask[0] << 1) | element_mask_bit;
                            }
                            break;
                        case DATA_FORMAT_INT16:
                            for (int32_t idx = NVDLA_MAC_ATOMIC_C_SIZE - 1; idx >= 0; idx--) {
                                sc_uint<16> tmp_v = (sc2mac_a_dat_payload.data[idx * 2 + 1].range(7, 0), sc2mac_a_dat_payload.data[idx * 2].range(7, 0));
                                uint8_t element_mask_bit = (tmp_v != 0)? 3 : 0;
                                if (idx < NVDLA_MAC_ATOMIC_C_SIZE / 2)
                                    sc2mac_a_dat_payload.mask[1] = (sc2mac_a_dat_payload.mask[1] << 2) | element_mask_bit;
                                else
                                    sc2mac_a_dat_payload.mask[0] = (sc2mac_a_dat_payload.mask[0] << 2) | element_mask_bit;
                            }
                            break;
                        case DATA_FORMAT_FP16:
                            for (int32_t idx = NVDLA_MAC_ATOMIC_C_SIZE - 1; idx >= 0; idx--) {
                                sc_uint<16> tmp_v = (sc2mac_a_dat_payload.data[idx * 2 + 1].range(7, 0), sc2mac_a_dat_payload.data[idx * 2].range(7, 0));
                                uint8_t element_mask_bit = ((tmp_v != 0) && (tmp_v!=0x8000UL))? 3 : 0;   // Both +0 and -0 have to be involved for FP16
                                if (idx < NVDLA_MAC_ATOMIC_C_SIZE / 2)
                                    sc2mac_a_dat_payload.mask[1] = (sc2mac_a_dat_payload.mask[1] << 2) | element_mask_bit;
                                else
                                    sc2mac_a_dat_payload.mask[0] = (sc2mac_a_dat_payload.mask[0] << 2) | element_mask_bit;
                            }
                            break;
#pragma CTC SKIP
                        default:
                            break;
#pragma CTC ENDSKIP
                    }
                    cslDebug((50, "sc2mac_a_dat_payload(%d): stripe_st=%d\n", trans_id++, (uint32_t)sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_st));
                    cslDebug((50, " stripe_end=%d\n", (uint32_t)sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end));
                    cslDebug((50, " channel_end=%d\n", (uint32_t)sc2mac_a_dat_payload.pd.nvdla_stripe_info.channel_end));
                    cslDebug((50, " layer_end=%d\n", (uint32_t)sc2mac_a_dat_payload.pd.nvdla_stripe_info.layer_end));
                    for (uint32_t idx_db = 0; idx_db < NVDLA_CBUF_BANK_WIDTH; idx_db++) {
                        cslDebug((70, "    Data[%d]: 0x%x\n", idx_db, sc2mac_a_dat_payload.data[idx_db].to_int()));
                    }
                    sc2mac_a_dat_b_transport (&sc2mac_a_dat_payload, b_transport_delay_);
                    sc2mac_b_dat_b_transport (&sc2mac_a_dat_payload, b_transport_delay_);
                    if (sc2mac_a_dat_payload.pd.nvdla_stripe_info.channel_end && sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_end) {
                        cacc_free_entry_num_ -= current_stripe_length * atom_ratio_cacc_to_csc;
                        cslDebug((50, "Updated credit: cacc_free_entry_num_=%lx\n", cacc_free_entry_num_));
                    }

                    if ( 1 == sc2mac_a_dat_payload.pd.nvdla_stripe_info.stripe_st ) {
                        // after data stripe_start has been sent, notify weight thread previous shadow (in CMAC) has been loaded into active
                        // weight load could send to next kernel to CMAC
                        kernel_switch_round_data_ ++;
                        stripe_begin_updated_.notify();
                    }
                }
            }
        }
    }
}

void NV_NVDLA_csc::SendWeightToMacSequencerWinoConvCommon() {
    // Config variables, they have corresponding value in registers
    // uint32_t cube_in_width;
    // uint32_t cube_in_height;
    uint32_t cube_in_channel;
    uint32_t cube_out_width;
    uint32_t cube_out_height;
    // uint32_t cube_out_channel;
    uint32_t byte_per_kernel;
    uint32_t precision;
    uint32_t kernel_width;
    uint32_t kernel_height;
    uint32_t weight_format;
    // uint32_t kernel_stride_w;
    // uint32_t kernel_stride_h;
    uint32_t kernel_num;
    uint32_t skip_weight_rls_mode;
    // uint32_t weight_reuse_mode;
    uint32_t cbuf_entry_for_data, cbuf_entry_for_weight;

    // # Iterators
    uint32_t kernel_group_iter;
    uint32_t kernel_iter;
    uint32_t channel_operation_iter;
    uint32_t block_operation_iter;
    uint32_t stripe_operation_iter;
    uint32_t read_payload_gran_iter;
    uint32_t sc2mac_element_iter;
    uint32_t byte_iter;

    // Control variables
    uint32_t element_size;
    //RMPH##uint32_t part_num;
    uint32_t kernel_per_group;
    uint32_t kernel_per_group_last;
    uint32_t kernel_group_num;
    // uint32_t channel_operation_per_part;
    uint32_t channel_operation_num;
    uint32_t kernel_group_stride;
    uint32_t block_per_channel_num;
    uint32_t cripple_channel_num;
    uint32_t stripe_operation_stride;
    uint32_t block_operation_stride;
    // uint32_t atom_num;
    uint32_t super_atom_size;
    bool     is_skip_weight_rls_mode;
    uint32_t begin_byte_within_one_entry;
    uint32_t cbuf_entry_addr;
    uint32_t stripe_operation_per_block_operation;
    uint64_t kernel_atom_size_index;
    uint32_t input_atom_channel_num;
    uint32_t updated_entry_num;
    int32_t  comp_released_wt_entries;
    int32_t  comp_released_wmb_entries;

    // Temperal variables
    sc_uint<64> *read_data_curr_ptr;
    sc_uint<64> *read_data_reorder;
    uint64_t    *read_payload_data_ptr;

    // Copy from register value to local config variables, similar with RTL connection
    cube_in_channel         = csc_datain_channel_ext_ + 1;
    cube_out_width          = csc_dataout_width_ + 1;
    cube_out_height         = csc_dataout_height_ + 1;
    precision               = csc_proc_precision_;
    kernel_width            = csc_weight_width_ext_ + 1;
    kernel_height           = csc_weight_height_ext_ + 1;
    weight_format           = csc_weight_format_;
    kernel_num              = csc_weight_kernel_ + 1;
    skip_weight_rls_mode    = csc_skip_weight_rls_;
    cbuf_entry_for_data     = (csc_data_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH;
    cbuf_entry_for_weight   = (csc_weight_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH;
    // weight_reuse_mode       = csc_weight_reuse_;
    // This assertion is not correct becuase weight_bytes is up rounded to be multiple of 128
//    if(weight_bytes%kernel_num!=0)
//        FAIL(("weight_bytes%%kernel_num!=0. weight_bytes=0x%X, kernel_num=0x%X\n", weight_bytes, kernel_num));

#pragma CTC SKIP
    cslDebug((70, "DAIN: WxHxC=%dx%dx%d, DAOUT:WxHxC=%dx%dx%d, SxRxK=%dx%dx%d, weight format:%d, precision:%d, entry4data:%d, entry4wt:%d\n",
                csc_datain_width_ext_+1, csc_datain_height_ext_+1, csc_datain_channel_ext_+1, 
                cube_out_width, cube_out_height, csc_dataout_channel_,
                kernel_width, kernel_height, kernel_num,
                weight_format, precision,
                cbuf_entry_for_data, cbuf_entry_for_weight));
    assert(kernel_width == 4 && kernel_height == 4);
#pragma CTC ENDSKIP
    // Evaluated
    switch (precision) {
        case DATA_FORMAT_INT8:
            element_size        = ELEMENT_SIZE_INT8;
            break;
        case DATA_FORMAT_INT16:
            element_size        = ELEMENT_SIZE_INT16;
            break;
        case DATA_FORMAT_FP16:
            element_size        = ELEMENT_SIZE_FP16;
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    }

    // There is no byte_per_kernel register in manual. And we can't use weight_bytes/kernel_num to calculate byte_per_kernel because weight_bytes is ((byte_per_kernel*kernel_num + 127)/128)*128
    byte_per_kernel       = kernel_width * kernel_height * cube_in_channel * element_size;
    kernel_per_group_last = kernel_num % NVDLA_MAC_ATOMIC_K_SIZE;
    is_skip_weight_rls_mode   = (NVDLA_CSC_D_MISC_CFG_0_SKIP_WEIGHT_RLS_ENABLE == skip_weight_rls_mode);
    //RMPH##part_num = (partial_height==0)? 1: (cube_out_height + partial_height - 1)/partial_height;
    // # of block operations per channel operation
    block_per_channel_num = (cube_in_channel + NVDLA_MAC_ATOMIC_C_SIZE_WG - 1) / NVDLA_MAC_ATOMIC_C_SIZE_WG;
    cripple_channel_num = cube_in_channel % NVDLA_MAC_ATOMIC_C_SIZE_WG;
    cslAssert(0 == cripple_channel_num);
    kernel_group_stride = byte_per_kernel * NVDLA_MAC_ATOMIC_K_SIZE;
    kernel_group_num = (kernel_num + NVDLA_MAC_ATOMIC_K_SIZE - 1) / NVDLA_MAC_ATOMIC_K_SIZE;
    stripe_operation_per_block_operation = 1;

    read_data_curr_ptr = new sc_uint<64> [CBUF_ENTRY_CMOD_GRANULARITY_NUM];
    read_data_reorder  = new sc_uint<64> [CBUF_ENTRY_CMOD_GRANULARITY_NUM];
    read_payload_data_ptr = reinterpret_cast <uint64_t*> (sc2buf_wt_rd_payload.nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1.data);
    
    if (is_skip_weight_rls_mode) {
        weight_entry_idx_free_skip_weight_rls_ = weight_entry_idx_start_;
    }
    // # of channel oeprations to generate one output surface
    channel_operation_num = evaluate_channel_operation_num(cube_out_width * cube_out_height / 4, NVDLA_MAC_ATOMIC_K_SIZE);
    comp_released_wt_entries = 0;
    comp_released_wmb_entries = 0;
    for (kernel_group_iter = 0; kernel_group_iter < kernel_group_num; kernel_group_iter++) {
        // Loop on output channels
        if (kernel_group_iter == (kernel_group_num - 1)) {
            kernel_per_group = (kernel_per_group_last == 0) ? NVDLA_MAC_ATOMIC_K_SIZE : kernel_per_group_last;
        } else {
            kernel_per_group = NVDLA_MAC_ATOMIC_K_SIZE;
        }
        cslDebug((30, "kernel_group_iter=%d current kernel_per_group=%d\n", kernel_group_iter, kernel_per_group));
        // WaitUntilThereAreEnoughKernelGroup(kernel_per_group);
        int kernel_data_available;
        if (is_skip_weight_rls_mode) {
            // Count from the beginning of the entire weight
            WaitUntilThereAreEnoughKernel(kernel_group_iter * NVDLA_MAC_ATOMIC_K_SIZE + kernel_per_group);
            kernel_data_available = kernel_group_iter * NVDLA_MAC_ATOMIC_K_SIZE + kernel_per_group;
        } else {
            // Count from the beginning of the current Kernel Group
            WaitUntilThereAreEnoughKernel(kernel_per_group);
            kernel_data_available = kernel_per_group;
        }
        cslDebug((70, "enough(%d) kernel are received\n", kernel_data_available));
        for (channel_operation_iter = 0; channel_operation_iter < channel_operation_num; channel_operation_iter++) {
            cslDebug((30, "channel_operation_iter=%d\n", channel_operation_iter));
            if (NVDLA_CSC_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED == weight_format) {
                comp_updated_wt_entry_num = 0;
                comp_updated_wmb_entry_num = 0;
                cbuf_wmb_entry_addr = CBUF_WMB_BANK_IDX * NVDLA_CBUF_BANK_DEPTH + wmb_entry_idx_start_ % NVDLA_CBUF_BANK_DEPTH;
                if (0 == kernel_group_iter) { // First kernel group
                    wt_payload_available = 0;
                    next_wt_idx     = 0;
                    next_wmb_idx    = 0;
                }
                else {
                    wt_payload_available = wt_payload_available_bak;
                    next_wt_idx     = next_wt_idx_bak;
                    next_wmb_idx    = next_wmb_idx_bak;
                    memcpy(comp_entry_wt, comp_entry_wt_bak, NVDLA_CBUF_BANK_WIDTH);
                    memcpy(comp_entry_wmb, comp_entry_wmb_bak, NVDLA_CBUF_BANK_WIDTH);
#pragma CTC SKIP
                    if (NVDLA_CBUF_BANK_WIDTH == wt_payload_available)
                        FAIL(("The weight data in comp_entry_wt should be used by prev kernel group\n"));
#pragma CTC ENDSKIP
                    cslDebug((70, "After restore: wt_payload_available=%d next_wt_idx=%d next_wmb_idx=%d\n", wt_payload_available, next_wt_idx, next_wmb_idx));
                    cslDebug((70, "comp_entry_wt:\n"));
                    for (uint32_t i = 0; i < NVDLA_CBUF_BANK_WIDTH / sizeof(uint64_t); i++)
                        cslDebug((70, "0x%016lx ", comp_entry_wt[i]));
                    cslDebug((70, "\n"));

                    cslDebug((70, "comp_entry_wmb:\n"));
                    for (uint32_t i = 0; i < NVDLA_CBUF_BANK_WIDTH; i++)
                        cslDebug((70, "0x%02x ", comp_entry_wmb[i]));
                    cslDebug((70, "\n"));
                }
                // For each channel op in one kernel group, restart from the start of the kernel group
                cbuf_wt_entry_addr = cbuf_entry_for_data + weight_entry_idx_start_ % cbuf_entry_for_weight;
            } else {
                updated_entry_num = 0;
                // NOTE: for winograd, each kernel group is aligned to 128B? So there should be no left weight when releasing kernel group? If so, no need to do memcpy
            }
            for (block_operation_iter = 0; block_operation_iter < block_per_channel_num; block_operation_iter++) {
                cslDebug((30, "block_operation_iter=%d\n", block_operation_iter));
                // block_per_channel_num is number of input channels
                super_atom_size = NVDLA_MAC_ATOMIC_C_SIZE_WG * element_size * 4 * 4;
                input_atom_channel_num = NVDLA_MAC_ATOMIC_C_SIZE_WG;
                stripe_operation_stride  = super_atom_size * kernel_per_group;
                block_operation_stride   = stripe_operation_stride * stripe_operation_per_block_operation;  // stripe_operatrion_stride*1
                for (stripe_operation_iter = 0; stripe_operation_iter < stripe_operation_per_block_operation; stripe_operation_iter++) {
                    cslDebug((30, "stripe_operation_iter=%d\n", stripe_operation_iter));
                    WaitStripeBeginHasSent();   //Wait until the previous stipe has been sent to mac. Then load the next batch of kernels into shadow.
                    for (kernel_iter = 0; kernel_iter < kernel_per_group; kernel_iter++) {
                        cslDebug((30, "kernel_iter=%d\n", kernel_iter));
                        kernel_atom_size_index = (weight_layer_start_byte_idx_
                                + kernel_iter * super_atom_size
                                + stripe_operation_iter * stripe_operation_stride
                                + block_operation_iter  * block_operation_stride
                                + kernel_group_iter     * kernel_group_stride) % (cbuf_entry_for_weight * NVDLA_CBUF_BANK_WIDTH);
                        cbuf_entry_addr = cbuf_entry_for_data + kernel_atom_size_index / NVDLA_CBUF_BANK_WIDTH;
                        begin_byte_within_one_entry = kernel_atom_size_index % NVDLA_CBUF_BANK_WIDTH;
                        cslDebug((50, "NV_NVDLA_csc::SendWeightToMacSequencerWinoConvCommon, iterator values:\n"));
                        cslDebug((50, "    kernel_iter                is %d\n", kernel_iter));
                        cslDebug((50, "    stripe_operation_iter      is %d\n", stripe_operation_iter));
                        cslDebug((50, "    block_operation_iter       is %d\n", block_operation_iter));
                        cslDebug((50, "    channel_operation_iter     is %d\n", channel_operation_iter));
                        cslDebug((50, "    kernel_group_iter          is %d\n", kernel_group_iter));
                        if (NVDLA_CSC_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED == weight_format) {
                            uint8_t *read_data_curr_ptr_int8;
                            read_data_curr_ptr_int8 = new uint8_t [NVDLA_CBUF_BANK_WIDTH];
                            get_decompressed_weight(read_data_curr_ptr_int8, 4 * 4 * input_atom_channel_num);
                            // Prepare CSC2MAC weight payload, from C0 to C64, C0 is aligned with 0
                            if (DATA_FORMAT_INT8 == precision) {    // sc2mac_a_wt_payload.data[0] is sc_int<8>
                                for (sc2mac_element_iter = 0; sc2mac_element_iter < 4 * 4 * input_atom_channel_num * element_size; sc2mac_element_iter++) {
                                    sc2mac_a_wt_payload.data[sc2mac_element_iter] = read_data_curr_ptr_int8[sc2mac_element_iter];
                                    cslDebug((70, "kernel_iter=%d sc2mac_element_iter=%d read_data_curr_ptr_int8[]=0x%x sc2mac_a_wt_payload.data[]=0x%x\n", kernel_iter, sc2mac_element_iter, read_data_curr_ptr_int8[sc2mac_element_iter], sc2mac_a_wt_payload.data[sc2mac_element_iter].to_int()));
                                }
                            } else {
                                for (sc2mac_element_iter = 0; sc2mac_element_iter < 4 * 4 * input_atom_channel_num * element_size; sc2mac_element_iter++) {
                                    sc2mac_a_wt_payload.data[sc2mac_element_iter] = read_data_curr_ptr_int8[sc2mac_element_iter];
                                }
                            }
                            delete [] read_data_curr_ptr_int8;
                        }
                        // Determine to read one new entry or not
                        else if (0 == begin_byte_within_one_entry) {
                            // Begin byte address is aligned with NVDLA_CBUF_BANK_WIDTH, in current setting, NVDLA_CBUF_BANK_WIDTH is 128 byte
                            // There is no usable data in read_data_curr_ptr
                            // Read new line in cbuf
                            sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr = cbuf_entry_addr;
                            cslDebug((50, "NV_NVDLA_csc::SendWeightToMacSequencerWinoConvCommon, begin byte address is aligned with entry size.  sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr is 0x%x\n", sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr));
                            if (cbuf_entry_addr == (cbuf_entry_for_data + cbuf_entry_for_weight - 1))
                                cbuf_entry_addr = cbuf_entry_for_data;
                            else
                                cbuf_entry_addr++;
                            // Send CBUF read request. Read one cbuf entry(128B)
                            sc2buf_wt_rd_b_transport(&sc2buf_wt_rd_payload, b_transport_delay_);
                            read_payload_data_ptr = reinterpret_cast <uint64_t*> (sc2buf_wt_rd_payload.nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1.data);
                            updated_entry_num ++;
                            // Copy CBUF read data from payload to local variable
                            for (read_payload_gran_iter = 0; read_payload_gran_iter < CBUF_ENTRY_CMOD_GRANULARITY_NUM; read_payload_gran_iter++) {
                                read_data_curr_ptr[read_payload_gran_iter] = read_payload_data_ptr[read_payload_gran_iter];
                                // if (sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr == 0x400) {
                                //     cout << "    read_data_curr_ptr[" << dec << read_payload_gran_iter << "] is 0x" << hex << read_data_curr_ptr[read_payload_gran_iter] << endl;
                                // }
                            }
                            // Prepare CSC2MAC weight payload, from C0 to C64, C0 is aligned with 0
                            if (DATA_FORMAT_INT8 == precision) {
                                // Int8, each element size is 1 byte
                                for (sc2mac_element_iter = 0; sc2mac_element_iter < 4 * 4 * input_atom_channel_num * element_size; sc2mac_element_iter++) {
                                    sc2mac_a_wt_payload.data[sc2mac_element_iter] = read_data_curr_ptr[sc2mac_element_iter / CBUF_ENTRY_CMOD_GRANULARITY_SIZE].range( \
                                        (sc2mac_element_iter % CBUF_ENTRY_CMOD_GRANULARITY_SIZE + 1) * CSC2CMAC_CONTAINER_BITWIDTH - 1, (sc2mac_element_iter % CBUF_ENTRY_CMOD_GRANULARITY_SIZE) * CSC2CMAC_CONTAINER_BITWIDTH);
                                    if (sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr == 0x400) {
                                        cout << "     sc2mac_a_wt_payload.data[" << dec << sc2mac_element_iter << "] is 0x" << hex << sc2mac_a_wt_payload.data[sc2mac_element_iter] << endl;
                                    }
                                }
#pragma CTC SKIP
                                if (input_atom_channel_num != NVDLA_MAC_ATOMIC_C_SIZE_WG) {
                                    FAIL(("cripple channel is not allowed for winograd\n"));
                                }
#pragma CTC ENDSKIP
                            } else {
                                // Int16 or FP16, each element size is 2 byte
                                for (sc2mac_element_iter = 0; sc2mac_element_iter < 4 * 4 * input_atom_channel_num * element_size; sc2mac_element_iter++) {
                                    sc2mac_a_wt_payload.data[sc2mac_element_iter] = read_data_curr_ptr[sc2mac_element_iter / CBUF_ENTRY_CMOD_GRANULARITY_SIZE].range( \
                                        (sc2mac_element_iter % CBUF_ENTRY_CMOD_GRANULARITY_SIZE + 1) * CSC2CMAC_CONTAINER_BITWIDTH - 1, (sc2mac_element_iter % CBUF_ENTRY_CMOD_GRANULARITY_SIZE) * CSC2CMAC_CONTAINER_BITWIDTH);
                                    // if (sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr == 0x420) {
                                    //     cout << "     sc2mac_a_wt_payload.data[" << dec << sc2mac_element_iter << "] is 0x" << hex << sc2mac_a_wt_payload.data[sc2mac_element_iter] << endl;
                                    // }
                                }
#pragma CTC SKIP
                                if (input_atom_channel_num != NVDLA_MAC_ATOMIC_C_SIZE_WG) {
                                    FAIL(("cripple channel is not allowed for winograd\n"));
                                }
#pragma CTC ENDSKIP
                            }
                        } else {
                            cslAssert(DATA_FORMAT_INT8 == precision);
                            for (byte_iter = 0; byte_iter < super_atom_size; byte_iter++) {
                                read_data_reorder[byte_iter / CBUF_ENTRY_CMOD_GRANULARITY_SIZE].range((byte_iter % CBUF_ENTRY_CMOD_GRANULARITY_SIZE + 1) * CSC2CMAC_CONTAINER_BITWIDTH - 1, (byte_iter % CBUF_ENTRY_CMOD_GRANULARITY_SIZE) * CSC2CMAC_CONTAINER_BITWIDTH) = \
                                    read_data_curr_ptr[(byte_iter + begin_byte_within_one_entry) / CBUF_ENTRY_CMOD_GRANULARITY_SIZE].range(((byte_iter + begin_byte_within_one_entry) % CBUF_ENTRY_CMOD_GRANULARITY_SIZE + 1) * CSC2CMAC_CONTAINER_BITWIDTH - 1, ((byte_iter + begin_byte_within_one_entry) % CBUF_ENTRY_CMOD_GRANULARITY_SIZE) * CSC2CMAC_CONTAINER_BITWIDTH);
                            }
                            // Prepare CSC2MAC weight payload, from C0 to C64, C0 is aligned with 0
                            // Int8, each element size is 1 byte
                            for (sc2mac_element_iter = 0; sc2mac_element_iter < 4 * 4 * input_atom_channel_num * element_size; sc2mac_element_iter++) {
                                sc2mac_a_wt_payload.data[sc2mac_element_iter] = read_data_reorder[sc2mac_element_iter / CBUF_ENTRY_CMOD_GRANULARITY_SIZE].range(\
                                    (sc2mac_element_iter % CBUF_ENTRY_CMOD_GRANULARITY_SIZE + 1) * CSC2CMAC_CONTAINER_BITWIDTH - 1, (sc2mac_element_iter % CBUF_ENTRY_CMOD_GRANULARITY_SIZE) * CSC2CMAC_CONTAINER_BITWIDTH);
                            }
#pragma CTC SKIP
                            // Fill 0 to cripple channels
                            if (input_atom_channel_num != NVDLA_MAC_ATOMIC_C_SIZE_WG) {
                                FAIL(("cripple channel is not allowed for winograd\n"));
                            }
#pragma CTC ENDSKIP
                        }

                        // Send weight to CMAC
                        sc2mac_a_wt_payload.mask[0] = 0x0ULL;
                        sc2mac_a_wt_payload.mask[1] = 0x0ULL;
                        if (DATA_FORMAT_INT8 == precision) {
                            for (int idx = NVDLA_MAC_ATOMIC_C_SIZE - 1; idx >= 0; idx--) {
                                uint8_t element_mask_bit = (sc2mac_a_wt_payload.data[idx] != 0)? 1 : 0;
                                if (idx < NVDLA_MAC_ATOMIC_C_SIZE / 2)
                                    sc2mac_a_wt_payload.mask[1] = (sc2mac_a_wt_payload.mask[1] << 1) | element_mask_bit;
                                else
                                    sc2mac_a_wt_payload.mask[0] = (sc2mac_a_wt_payload.mask[0] << 1) | element_mask_bit;
                            }

                            sc2mac_a_wt_payload.sel = ((uint64_t)0x1) << kernel_iter;
                            cslDebug((70, "sc2mac_a_wt_payload is\n"));
                            cslDebug((50, "    mask[0]=0x%016lx\n", (uint64_t)sc2mac_a_wt_payload.mask[0]));
                            cslDebug((50, "    mask[1]=0x%016lx\n", (uint64_t)sc2mac_a_wt_payload.mask[1]));
                            cslDebug((70, "    sel is 0x%lx\n", sc2mac_a_wt_payload.sel));
                            for (uint32_t idx_db = 0; idx_db < NVDLA_CBUF_BANK_WIDTH; idx_db++) {
                                cslDebug((70, "    Weight[%d]: 0x%02x\n", idx_db, (uint8_t)sc2mac_a_wt_payload.data[idx_db].to_int()));
                            }
                            if ((sc2mac_a_wt_payload.sel & CSC2CMAC_WEIGHT_MASK)) {
                                sc2mac_a_wt_b_transport(&sc2mac_a_wt_payload, b_transport_delay_);
                            } else { //if ((sc2mac_a_wt_payload.sel>>8) & 0xFF)  {
                                cslDebug((70, "sending sc2mac_a_wt_payload to MAC_B\n"));
                                sc2mac_a_wt_payload.sel = sc2mac_a_wt_payload.sel >> (NVDLA_MAC_ATOMIC_K_SIZE / 2);
                                sc2mac_b_wt_b_transport(&sc2mac_a_wt_payload, b_transport_delay_);
                            }
                        } else {
                            for (int idx = NVDLA_MAC_ATOMIC_C_SIZE - 1; idx >= 0; idx--) {
                                sc_uint<16> tmp_v = (sc2mac_a_wt_payload.data[idx * 2 + 1].range(7, 0), sc2mac_a_wt_payload.data[idx * 2].range(7, 0));
                                uint8_t element_mask_bit;
                                if (DATA_FORMAT_FP16 == precision)
                                    element_mask_bit = ((tmp_v != 0) && (tmp_v!=0x8000UL))? 3 : 0;   // Both +0 and -0 have to be involved for FP16
                                else
                                    element_mask_bit = (tmp_v != 0)? 3 : 0;
                                if (idx < NVDLA_MAC_ATOMIC_C_SIZE / 2)
                                    sc2mac_a_wt_payload.mask[1] = (sc2mac_a_wt_payload.mask[1] << 2) | element_mask_bit;
                                else
                                    sc2mac_a_wt_payload.mask[0] = (sc2mac_a_wt_payload.mask[0] << 2) | element_mask_bit;
                            }
                            sc2mac_a_wt_payload.sel = ((uint64_t)0x1) << kernel_iter;
                            cslDebug((70, "sc2mac_a_wt_payload is\n"));
                            cslDebug((50, "    mask[0]=0x%016lx\n", (uint64_t)sc2mac_a_wt_payload.mask[0]));
                            cslDebug((50, "    mask[1]=0x%016lx\n", (uint64_t)sc2mac_a_wt_payload.mask[1]));
                            cslDebug((70, "    sel is 0x%lx\n", sc2mac_a_wt_payload.sel));
                            for (uint32_t idx_db = 0; idx_db < NVDLA_CBUF_BANK_WIDTH; idx_db++) {
                                cslDebug((70, "    Weight[%d]: 0x%02x\n", idx_db, (uint8_t)(sc2mac_a_wt_payload.data[idx_db].to_int())));
                            }

#ifdef WG_CMOD_DEBUG
                            if (kernel_group_iter == 0 && channel_operation_iter == 0 && kernel_iter == 1) {
                                cslDebug((30, "WG_CMOD_DEBUG:block_operation_iter:%d\n", block_operation_iter));
                                cslDebug((30, "\nWG_CMOD_DEBUG:wt_post_pra:"));
                                for(uint32_t channel_iter = 0; channel_iter < 4; channel_iter++) {
                                    for (uint32_t idx_db=0; idx_db<16; idx_db ++) {
                                        cslDebug((70, "0x%02x ", (uint8_t)(sc2mac_a_wt_payload.data[idx_db*8+channel_iter*2].to_int())));
                                        cslDebug((70, "0x%02x ", (uint8_t)(sc2mac_a_wt_payload.data[idx_db*8+channel_iter*2+1].to_int())));
                                    }
                                    cslDebug((30, "\nWG_CMOD_DEBUG:wt_post_pra:"));
                                }
                            }
#endif
                            if ((sc2mac_a_wt_payload.sel & CSC2CMAC_WEIGHT_MASK)) {
                                sc2mac_a_wt_b_transport(&sc2mac_a_wt_payload, b_transport_delay_);
#pragma CTC SKIP
                            } else { // if ((sc2mac_a_wt_payload.sel >> 8) & 0xFF;)  {
#pragma CTC ENDSKIP
                                sc2mac_a_wt_payload.sel = sc2mac_a_wt_payload.sel >> (NVDLA_MAC_ATOMIC_K_SIZE / 2);
                                sc2mac_b_wt_b_transport(&sc2mac_a_wt_payload, b_transport_delay_);
                            }
                        }

                    }
                    // Notify data thread that a kernel group is ready
                    kernel_switch_round_weight_ ++;
                    kernel_switch_updated_.notify();
                    cslDebug((30, "end of stripe_operation_iter=%d\n", stripe_operation_iter));
                }
                cslDebug((30, "end of block_operation_iter=%d\n", block_operation_iter));
            }
            cslDebug((30, "end of channel_operation_iter=%d\n", channel_operation_iter));
        }

        if (NVDLA_CSC_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED == weight_format) {
            if (kernel_group_iter == kernel_group_num - 1) {
                uint32_t total_wt_entries = (csc_weight_bytes_ << NVDLA_CSC_D_WEIGHT_BYTES_0_WEIGHT_BYTES_SHIFT) / NVDLA_CBUF_BANK_WIDTH;  // The actual bytes of weight is csc_weight_bytes_*(1<<7)
                wt_up_sc2cdma_payload.wt_entries = total_wt_entries - comp_released_wt_entries;
                weight_entry_idx_start_ += total_wt_entries - comp_released_wt_entries;
#pragma CTC SKIP
                if (total_wt_entries - comp_released_wt_entries != comp_updated_wt_entry_num) {
                    cslInfo(("total_wt_entries=0x%x comp_released_wt_entries=0x%x comp_updated_wt_entry_num=0x%x\n", total_wt_entries, comp_released_wt_entries, comp_updated_wt_entry_num));
                    //FAIL(("In the end of last kernel group in weight compression mode, the wt entry num used should be same as available wt entries\n"));
                }
#pragma CTC ENDSKIP

                uint32_t total_wmb_entries = (csc_wmb_bytes_ << NVDLA_CSC_D_WMB_BYTES_0_WMB_BYTES_SHIFT) / NVDLA_CBUF_BANK_WIDTH;  // The actual bytes of wmb is csc_wmb_bytes_*(1<<7)
                wt_up_sc2cdma_payload.wmb_entries = total_wmb_entries - comp_released_wmb_entries;
                wmb_entry_idx_start_ += total_wmb_entries - comp_released_wmb_entries;
#pragma CTC SKIP
                if (total_wmb_entries - comp_released_wmb_entries != comp_updated_wmb_entry_num) {
                    cslInfo(("total_wmb_entries=0x%x comp_released_wmb_entries=0x%x comp_updated_wmb_entry_num=0x%x\n", total_wmb_entries, comp_released_wmb_entries, comp_updated_wmb_entry_num));
                    //FAIL(("In the end of last kernel group in weight compression mode, the wmb entry num used should be same as available wmb entries\n"));
                }
#pragma CTC ENDSKIP
            } else {
                wt_up_sc2cdma_payload.wt_entries = comp_updated_wt_entry_num;
                weight_entry_idx_start_ += comp_updated_wt_entry_num;
                wt_up_sc2cdma_payload.wmb_entries = comp_updated_wmb_entry_num;
                wmb_entry_idx_start_ += comp_updated_wmb_entry_num;
            }
            comp_released_wt_entries += wt_up_sc2cdma_payload.wt_entries;
            comp_released_wmb_entries += wt_up_sc2cdma_payload.wmb_entries;
        } else {
            wt_up_sc2cdma_payload.wt_entries = updated_entry_num;
            wt_up_sc2cdma_payload.wmb_entries = 0;
            weight_entry_idx_start_ += updated_entry_num;
        }
        if ( false == is_skip_weight_rls_mode ) { // Release KPG once a kernel group is done
            weight_kernel_num_used_ += kernel_per_group;
            wt_up_sc2cdma_payload.wt_kernels = kernel_per_group;
            wt_up_sc2cdma_b_transport(&wt_up_sc2cdma_payload, b_transport_delay_);
            cslInfo(("after wt_up_sc2cdma_b_transport. wt_kernels=0x%x wt_entries=0x%x wmb_entries=0x%xn", wt_up_sc2cdma_payload.wt_kernels, wt_up_sc2cdma_payload.wt_entries, wt_up_sc2cdma_payload.wmb_entries));
        }
        if (NVDLA_CSC_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED==weight_format) {
            save_info_kernel_group();
        }
        cslDebug((30, "end of kernel_group_iter=%d\n", kernel_group_iter));
    }

    delete [] read_data_curr_ptr;
    delete [] read_data_reorder;
}

void NV_NVDLA_csc::WaitUntilCBufferHasEnoughtAvailiableDataEntriesFullInput(uint32_t required_entry_num) {
    uint32_t dat_entries;
    while (true) {
        cslDebug((50, "NV_NVDLA_csc::WaitUntilCBufferHasEnoughtAvailiableDataEntriesFullInput\n"));
        cslDebug((50, "    data_entry_idx_available_ is 0x%lx\n", data_entry_idx_available_));
        cslDebug((50, "    data_entry_idx_free_ is 0x%lx\n", data_entry_idx_free_));
        cslDebug((50, "    required_entry_num is 0x%x\n", required_entry_num));

        if ((data_entry_idx_available_ - data_entry_idx_free_) >= required_entry_num) {
            break;
        } else {
            //wait(cdma_updated_cbuf_data_usage_);
            // Block read
            dat_entries = cdma_updated_cbuf_data_fifo_->read();
            data_entry_idx_available_ += dat_entries;
        }
    }
}

void NV_NVDLA_csc::WaitUntilThereAreEnoughKernel(uint32_t kernel_num) {
    while ( (weight_kernel_num_available_ - weight_kernel_num_used_) < kernel_num) {
        cslDebug((50, "NV_NVDLA_csc::WaitUntilThereAreEnoughKernel: wait cdma_updated_cbuf_weight_usage_. weight_kernel_num_available_=0x%lx weight_kernel_num_used_=0x%lx kernel_num=0x%u\n", weight_kernel_num_available_, weight_kernel_num_used_, kernel_num));
        wait(cdma_updated_cbuf_weight_usage_);
    }
}

void NV_NVDLA_csc::WaitUntilThereIsEnoughSpaceInCaccu (uint32_t num) {
    while (true) {
        cslDebug((50, "NV_NVDLA_csc::WaitUntilThereIsEnoughSpaceInCaccu. cacc_free_entry_num_=%lu, num=%u\n", cacc_free_entry_num_, num));
        if (cacc_free_entry_num_ < num) {
            wait(accu_free_entry_num_update_);
        } else {
            break;
        }
    }
}

void NV_NVDLA_csc::WaitUntilKernelsAreReady() {
    while (kernel_switch_round_data_ >= kernel_switch_round_weight_) {
        cslDebug((50, "NV_NVDLA_csc::WaitUntilKernelsAreReady, kernel_switch_round_data_ = %lx kernel_switch_round_weight_ = %lx\n", kernel_switch_round_data_, kernel_switch_round_weight_));
        wait(kernel_switch_updated_);
    }
}

void NV_NVDLA_csc::WaitStripeBeginHasSent() {
    while (kernel_switch_round_data_ < kernel_switch_round_weight_) {
        cslDebug((50, "NV_NVDLA_csc::WaitStripeBeginHasSent, kernel_switch_round_data_ = %lu kernel_switch_round_weight_ = %lu\n", kernel_switch_round_data_, kernel_switch_round_weight_));
        wait(stripe_begin_updated_);
    }
}

// Target sockets
// # CDMA->CSC status update
void NV_NVDLA_csc::dat_up_cdma2sc_b_transport(int ID, nvdla_dat_info_update_t* payload, sc_time& delay){
    slice_idx_dma_fetched_mutex_.lock();
    slice_idx_available_+= payload->dat_slices;
    slice_idx_dma_fetched_mutex_.unlock();
    // data_entry_idx_available_ += payload->dat_entries;
    cslDebug((50, "NV_NVDLA_csc::dat_up_cdma2sc_b_transport, data_entry_idx_available_ is 0x%lx\n", data_entry_idx_available_));
    cslDebug((50, "NV_NVDLA_csc::dat_up_cdma2sc_b_transport, slice_idx_available_[%d] is 0x%x\n", csc_consumer_, slice_idx_available_));
    // cdma_updated_cbuf_data_usage_.notify();
    cdma_updated_cbuf_data_fifo_->write(payload->dat_entries);
}

void NV_NVDLA_csc::wt_up_cdma2sc_b_transport(int ID, nvdla_wt_info_update_t* payload, sc_time& delay){
    weight_kernel_num_available_ +=  payload->wt_kernels;
    weight_entry_idx_available_  +=  payload->wt_entries;
    wmb_entry_idx_available_     +=  payload->wmb_entries;
    cslDebug((50, "NV_NVDLA_csc::wt_up_cdma2sc_b_transport, weight_entry_idx_available_ is 0x%lx\n", weight_entry_idx_available_));
    cslDebug((50, "NV_NVDLA_csc::wt_up_cdma2sc_b_transport, wmb_entry_idx_available_ is 0x%lx\n", wmb_entry_idx_available_));
    cdma_updated_cbuf_weight_usage_.notify();
}

uint32_t NV_NVDLA_csc::evaluate_channel_operation_num(uint32_t total_atom_num, uint32_t ideal_stripe_length){
    uint32_t stripe_num = 0;
    if (ideal_stripe_length!=1) {
//      stripe_num = (total_atom_num - 1 < ideal_stripe_length) ? 1 : ((total_atom_num - 1) / ideal_stripe_length);
        uint32_t atom_left = total_atom_num;
        while(atom_left) {
            if(atom_left >= 4 * NVDLA_MAC_ATOMIC_K_SIZE) {
                atom_left -= 2 * NVDLA_MAC_ATOMIC_K_SIZE;
            } else if(atom_left > 2 * NVDLA_MAC_ATOMIC_K_SIZE) {
                atom_left -= 1 * NVDLA_MAC_ATOMIC_K_SIZE;
            } else {
                atom_left = 0;
            }
            stripe_num++;
        }
    }
    else
        stripe_num = total_atom_num;
    return stripe_num;
}

#pragma CTC SKIP
// CBUF->CSC read data return
void NV_NVDLA_csc::sc2buf_dat_rd_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_b_transport(int ID, nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_t* payload, sc_time& delay){
    sc_uint<64> *data;
    uint32_t    gran_iter;
    data = new sc_uint<64> [CBUF_ENTRY_CMOD_GRANULARITY_NUM];
    for (gran_iter=0; gran_iter < CBUF_ENTRY_CMOD_GRANULARITY_NUM; gran_iter++) {
        data[gran_iter] = payload->data[gran_iter];
    }
    cbuf_data_read_->write(data);
}

void NV_NVDLA_csc::sc2buf_wt_rd_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_b_transport(int ID, nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_t* payload, sc_time& delay){
    sc_uint<64> *data;
    uint32_t    gran_iter;
    data = new sc_uint<64> [CBUF_ENTRY_CMOD_GRANULARITY_NUM];
    for (gran_iter=0; gran_iter < CBUF_ENTRY_CMOD_GRANULARITY_NUM; gran_iter++) {
        data[gran_iter] = payload->data[gran_iter];
    }
    cbuf_weight_read_->write(data);
}

void NV_NVDLA_csc::sc2buf_wmb_rd_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_b_transport(int ID, nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_t* payload, sc_time& delay){
    sc_uint<64> *data;
    uint32_t    gran_iter;
    data = new sc_uint<64> [CBUF_ENTRY_CMOD_GRANULARITY_NUM];
    for (gran_iter=0; gran_iter < CBUF_ENTRY_CMOD_GRANULARITY_NUM; gran_iter++) {
        data[gran_iter] = payload->data[gran_iter];
    }
    cbuf_wmb_read_->write(data);
}
#pragma CTC ENDSKIP

// CACC->CSC entry info credit target socket
void NV_NVDLA_csc::accu2sc_credit_b_transport (int ID, nvdla_cc_credit_t* payload, sc_time& delay){
    cacc_free_entry_num_ += payload->size;
    cslDebug((50, "NV_NVDLA_csc::accu2sc_credit_b_transport size=0x%x cacc_free_entry_num_=%lu\n", (uint32_t)(payload->size), cacc_free_entry_num_));
    accu_free_entry_num_update_.notify();
}

// input_atom_coor_width is in element, not in byte, not in pixel
// Read 64(NVDLA_MAC_ATOMIC_C_SIZE) elements from cbuf (For INT8, the lower 64B are 0)
// Return: 64 (or less than 64 if cripple channel) elements, the remaining bytes are filled with 0
void NV_NVDLA_csc::csc_read_one_image_entry(uint8_t post_y_extension, uint32_t post_y_extension_idx, uint32_t input_atom_coor_width, uint32_t input_atom_coor_height, uint32_t cbuf_entry_per_line, uint32_t element_size, bool last_super_channel, uint32_t last_super_channel_element_num, uint32_t cube_in_height, uint32_t cube_in_channel, uint8_t* read_data_ptr) {
    uint32_t i;
    uint32_t precision;
    uint16_t pad_value;
    uint8_t read_data_ptr0[NVDLA_CBUF_BANK_WIDTH], read_data_ptr1[NVDLA_CBUF_BANK_WIDTH];
    uint32_t cbuf_entry_for_data;
    precision = csc_proc_precision_;
    pad_value = csc_pad_value_;
    cbuf_entry_for_data     = (csc_data_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH;

    if ( ((input_atom_coor_height + post_y_extension_idx) < 0) || ((input_atom_coor_height + post_y_extension_idx) >= cube_in_height) ) {
        cslDebug((50, "Top or bottom padding , no data in CBUF, fill with pad value\n"));
        switch (precision) {
            case DATA_FORMAT_INT8:
                for (i=0; i < NVDLA_MAC_ATOMIC_C_SIZE; i++) {
                    if(last_super_channel && (i >= last_super_channel_element_num))
                        read_data_ptr[i] = 0;   //type of sc2mac_a_dat_payload.data[0]: sc_int<10>
                    else
                        read_data_ptr[i] = pad_value & 0xff;   // Only use 8bits for INT8
                    // Duplicate 64B for int8
                    // read_data_ptr[i + NVDLA_MAC_ATOMIC_C_SIZE] = read_data_ptr[i];
                }
                break;
            case DATA_FORMAT_INT16:
            case DATA_FORMAT_FP16:
                for (i=0; i < NVDLA_MAC_ATOMIC_C_SIZE; i++) {
                    if(last_super_channel && (i >= last_super_channel_element_num))
                        read_data_ptr[i * 2 + 1] = read_data_ptr[i * 2] = 0;
                    else {
                        read_data_ptr[i * 2] = pad_value & 0xff;
                        read_data_ptr[i * 2 + 1] = (pad_value >> 8) & 0xff;
                    }
                }
                break;
            default:
                break;
        }
        return;
    }

    bool across_cbuf_entry = ((input_atom_coor_width * element_size) % NVDLA_CBUF_BANK_WIDTH) != 0;
    uint32_t cbuf_entry_addr = (data_entry_idx_free_ + ((input_atom_coor_height + post_y_extension_idx) * cbuf_entry_per_line) + (input_atom_coor_width * element_size) / NVDLA_CBUF_BANK_WIDTH) % cbuf_entry_for_data;
    cslDebug((50, "NV_NVDLA_csc::csc_read_one_image_entry. cbuf_entry_addr=0x%x\n", cbuf_entry_addr));
    read_cbuf_entry(cbuf_entry_addr, read_data_ptr0);

    if (across_cbuf_entry) {
        if (cbuf_entry_addr == (cbuf_entry_for_data - 1))
            cbuf_entry_addr = 0;
        else
            cbuf_entry_addr ++;
        cslDebug((50, "NV_NVDLA_csc::csc_read_one_image_entry. 2nd reading of cbuf when across_cbuf_entry. cbuf_entry_addr=0x%x\n", cbuf_entry_addr));
        read_cbuf_entry(cbuf_entry_addr, read_data_ptr1);
    }

    if(!across_cbuf_entry) {
        for (i = 0; i < NVDLA_CBUF_BANK_WIDTH; i++) {
            read_data_ptr[i] = read_data_ptr0[i];
        }
    }
    else {
        uint32_t start_addr_in_entry = (input_atom_coor_width * element_size) % NVDLA_CBUF_BANK_WIDTH;
        for (i = 0; i < (NVDLA_CBUF_BANK_WIDTH - start_addr_in_entry); i++) {
            read_data_ptr[i] = read_data_ptr0[i + start_addr_in_entry];
        }
        for (i = NVDLA_CBUF_BANK_WIDTH - start_addr_in_entry; i<NVDLA_CBUF_BANK_WIDTH; i++) {
            read_data_ptr[i] = read_data_ptr1[i - (NVDLA_CBUF_BANK_WIDTH - start_addr_in_entry)];
        }
    }

    // Fill 0 to cripple channel
    if (last_super_channel) {
        for (i=0; i < NVDLA_MAC_ATOMIC_C_SIZE; i++) {
            if(i >= last_super_channel_element_num) {
                if (DATA_FORMAT_INT8 == precision) {
                    read_data_ptr[i] = 0;
                }
                else {
                    read_data_ptr[2 * i] = read_data_ptr[2 * i + 1] = 0;
                }
            }
        }
    }

    // INT8: set the lower half of entry (64B) to 0
    if (1 == element_size) {
        for (i = NVDLA_MAC_ATOMIC_C_SIZE; i < 2 * NVDLA_MAC_ATOMIC_C_SIZE; i++) {
            read_data_ptr[i] = 0;
        }
    }
}

void NV_NVDLA_csc::read_cbuf_entry(uint32_t cbuf_entry_addr, uint8_t *read_data_ptr) {
    uint8_t *read_payload_data_ptr;
    uint32_t read_payload_gran_iter;
    sc2buf_dat_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr = cbuf_entry_addr;

    // Send CBUF read request (block read)
    sc2buf_dat_rd_b_transport(&sc2buf_dat_rd_payload, b_transport_delay_);
    read_payload_data_ptr = reinterpret_cast <uint8_t*> (sc2buf_dat_rd_payload.nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1.data);
    for (read_payload_gran_iter = 0; read_payload_gran_iter < NVDLA_CBUF_BANK_WIDTH; read_payload_gran_iter++) {
        read_data_ptr[read_payload_gran_iter] = read_payload_data_ptr[read_payload_gran_iter];  //read_data_ptr[0] is 8Bytes
    }
}

void NV_NVDLA_csc::get_decompressed_weight(uint8_t *read_data_curr_ptr, uint32_t current_kernel_channel) {
    uint32_t    i,j;
    uint8_t     current_bit;
    uint32_t    precision;
    uint32_t    cbuf_entry_for_data;
    uint32_t    cbuf_entry_for_weight;
    // For Compressed weight
    uint64_t   *read_payload_wt_ptr;
    uint8_t    *weight_ori_int8; 
    uint16_t   *weight_ori_int16; 
    uint16_t   *weight_ori_fp16; 
    // For WMB
    uint8_t    *read_payload_wmb_ptr;

    // Outputs
    uint8_t      weight_int8[NVDLA_CBUF_BANK_WIDTH/ELEMENT_SIZE_INT8];
    uint16_t     weight_int16[NVDLA_CBUF_BANK_WIDTH/ELEMENT_SIZE_INT16];
    uint16_t     weight_fp16[NVDLA_CBUF_BANK_WIDTH/ELEMENT_SIZE_FP16];

    precision               = csc_proc_precision_;
    cbuf_entry_for_data     = (csc_data_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH;
    cbuf_entry_for_weight   = (csc_weight_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH;

    read_payload_wt_ptr  = reinterpret_cast <uint64_t*> (sc2buf_wt_rd_payload.nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1.data);
    read_payload_wmb_ptr = reinterpret_cast <uint8_t*> (sc2buf_wt_rd_payload.nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1.data);
    weight_ori_int8  = reinterpret_cast <uint8_t*> (comp_entry_wt);
    weight_ori_int16 = reinterpret_cast <uint16_t*> (comp_entry_wt);
    weight_ori_fp16  = reinterpret_cast <uint16_t*> (comp_entry_wt);

    // next_wt_idx's range: INT8: [0 ~ 127], INT16/FP16: [0 ~ 63]
    // next_wmb_idx's range: [0 ~ 128*8-1]
    for (i = 0; i < current_kernel_channel; i++) {
#if LOG_DETAIL
        cslDebug((90, "NV_NVDLA_csc::get_decompressed_weight. i=%d wt_payload_available=%d next_wt_idx=%d next_wmb_idx=%d\n", i, wt_payload_available, next_wt_idx, next_wmb_idx));
#endif
        if (next_wmb_idx == 0) {
            // Read next entry of WMB
            sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr = cbuf_wmb_entry_addr;
            cslDebug((50, "NV_NVDLA_csc::get_decompressed_weight. read wmb from cbuf. sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr is 0x%x\n", sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr));
            if (cbuf_wmb_entry_addr == (CBUF_WMB_BANK_IDX * NVDLA_CBUF_BANK_DEPTH + NVDLA_CBUF_BANK_DEPTH - 1))
                cbuf_wmb_entry_addr = CBUF_WMB_BANK_IDX * NVDLA_CBUF_BANK_DEPTH;
            else
                cbuf_wmb_entry_addr++;
            // Send CBUF read request. Read one cbuf entry(128B)
            sc2buf_wt_rd_b_transport(&sc2buf_wt_rd_payload, b_transport_delay_);
            for (j = 0; j < NVDLA_CBUF_BANK_WIDTH; j++) {
                comp_entry_wmb[j] = read_payload_wmb_ptr[j];
            }
            comp_updated_wmb_entry_num++;
        }

        current_bit = (comp_entry_wmb[next_wmb_idx / 8] >> (next_wmb_idx % 8)) & 0x1;
#if LOG_DETAIL
        cslDebug((90, "current_bit=%d weight_ori_int8[next_wt_idx]=0x%02x weight_ori_int16[next_wt_idx]=0x%04x\n", current_bit, weight_ori_int8[next_wt_idx], weight_ori_int16[next_wt_idx]));
#endif
        if ((current_bit != 0) && (wt_payload_available == 0)) {
            // Read next entry of compressed weight only when necessary
            sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr = cbuf_wt_entry_addr;
            cslDebug((50, "NV_NVDLA_csc::get_decompressed_weight. read wt from cbuf. sc2buf_wt_rd_payload.nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr is 0x%x\n", cbuf_wt_entry_addr));
            if (cbuf_wt_entry_addr == (cbuf_entry_for_data + cbuf_entry_for_weight - 1))
                cbuf_wt_entry_addr = cbuf_entry_for_data;
            else
                cbuf_wt_entry_addr++;
            // Send CBUF read request. Read one cbuf entry(128B)
            sc2buf_wt_rd_b_transport(&sc2buf_wt_rd_payload, b_transport_delay_);
            for (j = 0; j < CBUF_ENTRY_CMOD_GRANULARITY_NUM; j++) {   // CBUF_ENTRY_CMOD_GRANULARITY_NUM is 16
                comp_entry_wt[j] = read_payload_wt_ptr[j];
            }
            wt_payload_available = NVDLA_CBUF_BANK_WIDTH;
            comp_updated_wt_entry_num++;
        }
        switch(precision) {
            case DATA_FORMAT_INT8:
                weight_int8[i] = (current_bit == 0) ? 0 : weight_ori_int8[next_wt_idx];
                next_wmb_idx = (next_wmb_idx + 1) % (NVDLA_CBUF_BANK_WIDTH * 8);  // One entry contains 128*8 bits
                if (current_bit!=0) {
                    next_wt_idx = (next_wt_idx + 1) % NVDLA_CBUF_BANK_WIDTH;
                    wt_payload_available--;
                }
                break;
            case DATA_FORMAT_INT16:
                weight_int16[i] = (current_bit==0)? 0: weight_ori_int16[next_wt_idx];
                next_wmb_idx = (next_wmb_idx + 1) % (NVDLA_CBUF_BANK_WIDTH * 8);  // One entry contains 128*8 bits
                if (current_bit!=0) {
                    next_wt_idx = (next_wt_idx + 1) % (NVDLA_CBUF_BANK_WIDTH / 2);
                    wt_payload_available -= 2;
                }
                break;
            case DATA_FORMAT_FP16:
                weight_fp16[i] = (current_bit==0)? 0: weight_ori_fp16[next_wt_idx];
                next_wmb_idx = (next_wmb_idx + 1) % (NVDLA_CBUF_BANK_WIDTH * 8);  // One entry contains 128*8 bits
                if (current_bit!=0) {
                    next_wt_idx = (next_wt_idx + 1) % (NVDLA_CBUF_BANK_WIDTH / 2);
                    wt_payload_available -= 2;
                }
                break;
            default:
                break;
        }
    }

    for (i = current_kernel_channel; i < NVDLA_MAC_ATOMIC_C_SIZE; i++) {
        switch(precision) {
            case DATA_FORMAT_INT8:
                weight_int8[i] = 0;
                break;
            case DATA_FORMAT_INT16:
                weight_int16[i] = 0;
                break;
            case DATA_FORMAT_FP16:
                weight_fp16[i] = 0;
                break;
            default:
                break;
        }
    }

    cslDebug((70, "NV_NVDLA_csc::get_decompressed_weight result:\n"));

    // Got 64 elements of decompressed weight
    switch(precision) {
        case DATA_FORMAT_INT8:
            for (i = 0; i < NVDLA_MAC_ATOMIC_C_SIZE; i++) {
                read_data_curr_ptr[i] = weight_int8[i];
#if LOG_DETAIL
                cslDebug((90, "    read_data_curr_ptr[%d]: 0x%02x\n", i, read_data_curr_ptr[i]));
#endif
            }
            break; 
        case DATA_FORMAT_INT16:
            for (i = 0; i < NVDLA_MAC_ATOMIC_C_SIZE; i++) {
                read_data_curr_ptr[2 * i] = weight_int16[i] & 0xff;
                read_data_curr_ptr[2 * i + 1] = (weight_int16[i] >> 8) & 0xff;
#if LOG_DETAIL
                cslDebug((90, "    read_data_curr_ptr[%d]: 0x%02x\n", 2 * i, read_data_curr_ptr[2 * i]));
                cslDebug((90, "    read_data_curr_ptr[%d]: 0x%02x\n", 2 * i + 1, read_data_curr_ptr[2 * i + 1]));
#endif
            }
            break; 
        case DATA_FORMAT_FP16:
            for (i = 0; i < NVDLA_MAC_ATOMIC_C_SIZE; i++) {
                read_data_curr_ptr[2 * i] = weight_fp16[i] & 0xff;
                read_data_curr_ptr[2 * i + 1] = (weight_fp16[i] >> 8) & 0xff;
#if LOG_DETAIL
                cslDebug((90, "    read_data_curr_ptr[%d]: 0x%02x\n", 2 * i, read_data_curr_ptr[2 * i]));
                cslDebug((90, "    read_data_curr_ptr[%d]: 0x%02x\n", 2 * i + 1, read_data_curr_ptr[2 * i + 1]));
#endif
            }
            break; 
        default:
            break;
    }
}

#pragma CTC SKIP
void pra_int8(uint16_t* read_data_ptr_int8, uint8_t pra_truncate, uint16_t* pra_out_int16) {
    // Perform PRA in unit of INT8
    sc_int<18> pra_tmp_4x4[4][4];
    sc_int<18> pra_tmp_d;
    int32_t  idx_i, idx_j, idx_k, idx_c;

    int16_t pra_c_t[4][4] = {{1,0,0,0}, {0,1,-1,1},{-1,1,1,0},{0,0,0,-1}};
    int16_t pra_c[4][4]   = {{1,0,-1,0}, {0,1,1,0},{0,-1,1,0},{0,1,0,-1}};
    for (idx_c=0;idx_c<8;idx_c++) {     // In channel direction
        // M = C^T * Input
        for (idx_i=0;idx_i<4;idx_i++) {
            for (idx_j=0;idx_j<4;idx_j++) {
                pra_tmp_4x4[idx_i][idx_j] = 0;
                for (idx_k=0;idx_k<4;idx_k++) {
                    pra_tmp_4x4[idx_i][idx_j] += pra_c_t[idx_i][idx_k] * read_data_ptr_int8[idx_k*4*4+idx_j*4+idx_c];
                }
            }
        }
        // M * C
        for (idx_i=0;idx_i<4;idx_i++) {
            for (idx_j=0;idx_j<4;idx_j++) {
                pra_tmp_d = 0;
                for (idx_k=0;idx_k<4;idx_k++) {
                    pra_tmp_d += pra_tmp_4x4[idx_i][idx_k]*pra_c[idx_k][idx_j];
                }
                // truncate
                sc_int<18> pra_d_high = pra_tmp_d.range(17, pra_truncate);
                if(pra_d_high > 32767 /*INT16_MAX*/)
                    pra_out_int16[idx_i*4*4+idx_j*4+idx_c] = 32767 /*INT16_MAX*/;
                else if(pra_d_high < (-32767-1) /*INT16_MIN*/)
                    pra_out_int16[idx_i*4*4+idx_j*4+idx_c] = (-32767-1) /*INT16_MIN*/;
                else
                    pra_out_int16[idx_i*4*4+idx_j*4+idx_c] = pra_d_high;
            }
        }
    }
}

void pra_int16(uint16_t* read_data_ptr_int16, uint8_t pra_truncate, uint16_t* pra_out_int16) {
    // Perform PRA in unit of INT16
    sc_int<32> pra_tmp_4x4[4][4];
    sc_int<32> pra_tmp_d;
    int32_t  idx_i, idx_j, idx_k, idx_c;

    int16_t pra_c_t[4][4] = {{1,0,0,0}, {0,1,-1,1},{-1,1,1,0},{0,0,0,-1}};
    int16_t pra_c[4][4]   = {{1,0,-1,0}, {0,1,1,0},{0,-1,1,0},{0,1,0,-1}};
    for (idx_c=0;idx_c<4;idx_c++) {
        for (idx_i=0;idx_i<4;idx_i++) {
            for (idx_j=0;idx_j<4;idx_j++) {
                pra_tmp_4x4[idx_i][idx_j] = 0;
                for (idx_k=0;idx_k<4;idx_k++) {
                    pra_tmp_4x4[idx_i][idx_j] += pra_c_t[idx_i][idx_k] * read_data_ptr_int16[idx_k*4*4+idx_j*4+idx_c];
                }
            }
        }
        for (idx_i=0;idx_i<4;idx_i++) {
            for (idx_j=0;idx_j<4;idx_j++) {
                pra_tmp_d = 0;
                for (idx_k=0;idx_k<4;idx_k++) {
                    pra_tmp_d += pra_tmp_4x4[idx_i][idx_k]*pra_c[idx_k][idx_j];
                }
                // truncate
                sc_int<18> pra_d_high = pra_tmp_d.range(17, pra_truncate);
                if(pra_d_high > 32767 /*INT16_MAX*/)
                    pra_out_int16[idx_i*4*4+idx_j*4+idx_c] = 32767 /*INT16_MAX*/;
                else if(pra_d_high < (-32767-1) /*INT16_MIN*/)
                    pra_out_int16[idx_i*4*4+idx_j*4+idx_c] = (-32767-1) /*INT16_MIN*/;
                else
                    pra_out_int16[idx_i*4*4+idx_j*4+idx_c] = pra_d_high;
            }
        }
    }
}
#pragma CTC ENDSKIP

uint16_t NV_NVDLA_csc::sign_extend_8to16(uint8_t int8_in) {
    uint16_t int16_out;
    if (int8_in & 0x80) {   // negative
        int16_out = 0xff << 8;
        int16_out |= int8_in;
    } else {
        int16_out = int8_in;
    }
    return int16_out;
}

void NV_NVDLA_csc::save_info_kernel_group() {
    uint32_t i;
    // For weight compression:
    memcpy(comp_entry_wt_bak, comp_entry_wt, NVDLA_CBUF_BANK_WIDTH);
    memcpy(comp_entry_wmb_bak, comp_entry_wmb, NVDLA_CBUF_BANK_WIDTH);
    wt_payload_available_bak = wt_payload_available;
    next_wt_idx_bak = next_wt_idx;
    next_wmb_idx_bak = next_wmb_idx;
    cslDebug((70, "NV_NVDLA_csc::save_info_kernel_group wt_payload_available=%d next_wt_idx=%d next_wmb_idx=%d\n", wt_payload_available, next_wt_idx, next_wmb_idx));
    cslDebug((70, "comp_entry_wt:\n"));
    for (i = 0; i < NVDLA_CBUF_BANK_WIDTH / sizeof(uint64_t); i++)
        cslDebug((70, "0x%016lx ", comp_entry_wt[i]));
    cslDebug((70, "\n"));

    cslDebug((70, "comp_entry_wmb:\n"));
    for (i = 0; i < NVDLA_CBUF_BANK_WIDTH; i++)
        cslDebug((70, "0x%02x ", comp_entry_wmb[i]));
    cslDebug((70, "\n"));
}

// void NV_NVDLA_csc::recover_info_kernel_group() {
// }

#pragma CTC SKIP
NV_NVDLA_csc * NV_NVDLA_cscCon(sc_module_name name)
{
    return new NV_NVDLA_csc(name);
}
#pragma CTC ENDSKIP
