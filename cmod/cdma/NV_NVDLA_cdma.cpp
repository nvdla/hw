// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cdma.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_cdma.h"
#include "NV_NVDLA_cdma_cdma_gen.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "math.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define DATA_FORMAT_INT8        NVDLA_CDMA_D_MISC_CFG_0_IN_PRECISION_INT8
#define DATA_FORMAT_INT16       NVDLA_CDMA_D_MISC_CFG_0_IN_PRECISION_INT16
#define DATA_FORMAT_FP16        NVDLA_CDMA_D_MISC_CFG_0_IN_PRECISION_FP16

#define WGS_FIFO_DEPTH          32 // The depth of WGS FIFO in RTL is 32*4Bytes

#define LOG_DETAIL              0

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

enum CDMA_ACT_DATA_MODE_ALIAS {
    ACT_MODE_DIRECT_CONV_NONE_BATCH,
    ACT_MODE_DIRECT_CONV_BATCH,
    ACT_MODE_WINOGRAD_CONV,
    ACT_MODE_DIRECT_PIXEL
};

enum CDMA_WT_DATA_MODE_ALIAS {
    WT_MODE_DIRECT_CONV,
    WT_MODE_WINOGRAD_CONV,
    WT_MODE_IMAGE_LOAD
};

NV_NVDLA_cdma::NV_NVDLA_cdma( sc_module_name module_name ):
    NV_NVDLA_cdma_base(module_name),
    // Delay setup
    dma_delay_(SC_ZERO_TIME),
    csb_delay_(SC_ZERO_TIME),
    b_transport_delay_(SC_ZERO_TIME)
{
    // Memory allocation
    dma_act_rd_req_payload_ = new nvdla_dma_rd_req_t;
    dma_wt_rd_req_payload_  = new nvdla_dma_rd_req_t;
    dma_wgs_rd_req_payload_ = new nvdla_dma_rd_req_t;
    dma_wmb_rd_req_payload_ = new nvdla_dma_rd_req_t;
    cdma2cbuf_data_payload_ = new nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t;
    data2sc_data_update_payload_ = new nvdla_dat_info_update_t;
    data2sc_weight_update_payload_ = new nvdla_wt_info_update_t;
    cdma_act_share_buffer_  = new sc_core::sc_fifo <uint8_t> (CDMA_LOCAL_BUFFER_SIZE);
    // For converting active operation to a passive operation
    act_data_read_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (MAX_MEM_TRANSACTION_NUM *10);
    mean_data_read_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*>(MAX_MEM_TRANSACTION_NUM);
    weight_read_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*>(MAX_MEM_TRANSACTION_NUM);
    wmb_read_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*>(MAX_MEM_TRANSACTION_NUM);
    wgs_read_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*>(MAX_MEM_TRANSACTION_NUM);

    cdma_data_fetch_done_fifo_  = new sc_core::sc_fifo <bool> (1);
    cdma_mean_fetch_done_fifo_  = new sc_core::sc_fifo <bool> (1);
    cdma_weight_fetch_done_fifo_= new sc_core::sc_fifo <bool> (1);
    cdma_wgs_fetch_done_fifo_   = new sc_core::sc_fifo <bool> (1);
    cdma_wmb_fetch_done_fifo_   = new sc_core::sc_fifo <bool> (1);

    // The max height in winograd mode is 1920. the smallest size of each super_heigh_iter(4 rows) is 4*8atoms(8 entries). In this case, the size of input cube is 8*1920*16
    // 480 = 1920/4 = 15*256/8
    wino_req2resp_sync_fifo_    = new sc_core::sc_fifo <bool> (480);

    // For SCVE:
    cdma_wgs2wt_sync_fifo_  = new sc_core::sc_fifo <bool> (1);
    // For HEADLESS_NTB:
    wgs2wt_sync_fifo_             = new sc_core::sc_fifo <bool> (WGS_FIFO_DEPTH*2);
    // cdma_wmb_fetch_done2wt_fifo_ is used for wt_done interrupt
    cdma_wmb_fetch_done2wt_fifo_  = new sc_core::sc_fifo <bool> (1);

    wmb2sc_up_fifo_               = new sc_core::sc_fifo <int32_t> (1024);
    wt2sc_up_kernel_fifo_         = new sc_core::sc_fifo <int32_t> (1024);
    wt2sc_up_entry_fifo_          = new sc_core::sc_fifo <int32_t> (1024);

    for(int i = 0; i < 4; i++) {
        wino_fetch_data_fifo_[i]   = new sc_core::sc_fifo <uint8_t*> (2*READ_WINO_BUF_WIDTH);    // The max value of conv_x_stride is 8, *2 because there might be padding data
    }

    wt_dma_rtl_source_id_fifo_ = new sc_core::sc_fifo<int> (256);
    cdma_wt_req_fifo_      = new sc_core::sc_fifo<cdma_wt_req_t*> (1024);
    cdma_wmb_req_fifo_     = new sc_core::sc_fifo<cdma_wt_req_t*> (1024);
    cdma_wgs_req_fifo_     = new sc_core::sc_fifo<cdma_wt_req_t*> (1024);
    cdma_wt_info_fifo_     = new sc_core::sc_fifo<cdma_wt_info_t*> (1024);
    wgs_buffer_            = NULL;
    dat_first_layer        = true;
    wgs_first_layer        = true;
    wmb_first_layer        = true;
    wt_first_layer         = true;

    sc_dt_kick_off         = false;
    sc_wt_kick_off         = false;

    // Reset
    Reset();

    // SC_THREAD
    SC_THREAD(CdmaConsumerThread)
    SC_THREAD(ActDataReadRequestSequenceThread)
    SC_THREAD(ActDataReadResponseSequenceThread)
    SC_THREAD(WeightReadRequestSequenceThread)
    SC_THREAD(WeightReadResponseSequenceThread)
    SC_THREAD(WGSReadRequestSequenceThread)
    SC_THREAD(WGSReadResponseSequenceThread)
    SC_THREAD(WMBReadRequestSequenceThread)
    SC_THREAD(WMBReadResponseSequenceThread)
    SC_THREAD(WtReadRequestThread)
    SC_THREAD(Cdma2ScUpdateThread)
}

#pragma CTC SKIP
NV_NVDLA_cdma::~NV_NVDLA_cdma() {
    for(int i = 0; i < 4; i++) {
        if (wino_fetch_data_fifo_[i]) {
            delete wino_fetch_data_fifo_[i];
        }
    }
    if( dma_act_rd_req_payload_ )   delete dma_act_rd_req_payload_;
    if( dma_wt_rd_req_payload_ )    delete dma_wt_rd_req_payload_;
    if( cdma_act_share_buffer_ )    delete cdma_act_share_buffer_;
    if( act_data_read_rsp_fifo_ )   delete act_data_read_rsp_fifo_;
    if( weight_read_rsp_fifo_ )     delete weight_read_rsp_fifo_;
    if( mean_data_read_rsp_fifo_)   delete mean_data_read_rsp_fifo_;
    if( wgs_read_rsp_fifo_)         delete wgs_read_rsp_fifo_;
    if( wmb_read_rsp_fifo_)         delete wmb_read_rsp_fifo_;
    if( wt_dma_rtl_source_id_fifo_) delete wt_dma_rtl_source_id_fifo_;
    if( cdma_wt_req_fifo_)          delete cdma_wt_req_fifo_;
    if( cdma_wmb_req_fifo_)         delete cdma_wmb_req_fifo_;
    if( cdma_wgs_req_fifo_)         delete cdma_wgs_req_fifo_;
    if( cdma_wt_info_fifo_)         delete cdma_wt_info_fifo_;
    if( cdma2cbuf_data_payload_ )   delete cdma2cbuf_data_payload_;
    if( data2sc_data_update_payload_ )  delete data2sc_data_update_payload_;
    if( data2sc_weight_update_payload_ )  delete data2sc_weight_update_payload_;
    if( wgs_buffer_ )               delete[] wgs_buffer_;
}
#pragma CTC ENDSKIP

void NV_NVDLA_cdma::Reset()
{
    uint32_t flush_status = 0x1;
    // Clear register and internal states
    CdmaRegReset();
    CdmaUpdateStatusRegister((uint32_t)NVDLA_CDMA_S_CBUF_FLUSH_STATUS_0, 0, flush_status);
    is_there_ongoing_csb2cdma_response_      = false;
    slice_idx_available_            = 0;
    data_entry_idx_working_         = 0;
    data_entry_idx_planed_          = -1;
    data_entry_idx_free_            = 0;

    weight_entry_idx_planed_        = -1;
    weight_entry_idx_working_       = 0;
    weight_entry_idx_free_          = 0;
    weight_byte_idx_planed_         = 0;

    wmb_entry_idx_planed_           = -1;
    wmb_entry_idx_working_          = 0;
    wmb_entry_idx_free_             = 0;
    wmb_byte_idx_planed_            = 0;

    cdma_req_prev_data_bank_        = NVDLA_CBUF_BANK_NUMBER + 1;
    cdma_req_prev_skip_data_rls_    = false;
    cdma_resp_prev_data_bank_       = NVDLA_CBUF_BANK_NUMBER + 1;
    cdma_resp_prev_skip_data_rls_   = false;
    wt_req_cdma_prev_weight_bank_   = NVDLA_CBUF_BANK_NUMBER + 1;
    wt_req_cdma_prev_skip_weight_rls_      = false;

    wt_response_payload_size        = 0;
    wt_response_cdma_source         = 0;
}

void NV_NVDLA_cdma::CdmaConsumerThread () {
    while (true) {
        while(CdmaGetOpeartionEnable(cdma_register_group_0) != NVDLA_CDMA_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_cdma_reg_group_0_operation_enable);
        }
        cdma_reg_model::CdmaUpdateWorkingStatus(0,1);
        cdma_reg_model::CdmaUpdateVariables(cdma_register_group_0);
        CdmaHardwareLayerExecutionTrigger();
        cdma_reg_model::CdmaUpdateStatRegisters(0, data_nan_num_perlayer_, weight_nan_num_perlayer_, data_inf_num_perlayer_, weight_inf_num_perlayer_);
        cdma_reg_model::CdmaUpdateWorkingStatus(0,0);
        cdma_reg_model::CdmaClearOpeartionEnable(cdma_register_group_0);    // Update COMSUMER Pointer too

        while(CdmaGetOpeartionEnable(cdma_register_group_1) != NVDLA_CDMA_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_cdma_reg_group_1_operation_enable);
        }
        cdma_reg_model::CdmaUpdateWorkingStatus(1,1);
        cdma_reg_model::CdmaUpdateVariables(cdma_register_group_1);
        CdmaHardwareLayerExecutionTrigger();
        cdma_reg_model::CdmaUpdateStatRegisters(1, data_nan_num_perlayer_, weight_nan_num_perlayer_, data_inf_num_perlayer_, weight_inf_num_perlayer_);
        cdma_reg_model::CdmaUpdateWorkingStatus(1,0);
        cdma_reg_model::CdmaClearOpeartionEnable(cdma_register_group_1);    // Update COMSUMER Pointer too
    }
}

void NV_NVDLA_cdma::CdmaHardwareLayerExecutionTrigger () {
    cdma_kickoff_.notify();
    cdma_data_fetch_done_fifo_->read();
    cdma_wgs_fetch_done_fifo_->read();
    cdma_wmb_fetch_done_fifo_->read();
    cdma_weight_fetch_done_fifo_->read();
    cslInfo(("NV_NVDLA_cdma::CdmaHardwareLayerExecutionTrigger. HW Layer done\n"));
}

void NV_NVDLA_cdma::ActDataReadRequestSequenceThread () {
    uint32_t cdma_act_data_operation_mode;
    uint8_t  cdma_input_data_format_;
    while (true) {
        cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, before cdma_kickoff_\n"));
        wait(cdma_kickoff_);
        cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, after cdma_kickoff_\n"));

        WaitUntilSCDataKickOff();
        cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, after csc_kickoff_\n"));

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                cdma_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                cdma_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            cdma_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        if (dat_first_layer) {  // The first layer
            dat_first_layer         = false;
            data_entry_idx_free_    = (cdma_data_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH - 1;
            data_entry_idx_working_ = 0;
            data_entry_idx_planed_  = -1;
            // if (cdma_data_reuse_)
            //    FAIL(("Can't reuse data when first layer\n"));

            cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread dat_first_layer. data_entry_idx_free_=0x%x data_entry_idx_working_=0x%x data_entry_idx_planed_=0x%x\n", data_entry_idx_free_, data_entry_idx_working_, data_entry_idx_planed_));
        }
        else if ((cdma_req_prev_conv_mode_ != cdma_conv_mode_) || (cdma_req_prev_data_bank_ != cdma_data_bank_) || (cdma_req_prev_weight_bank_ != cdma_weight_bank_) || (cdma_req_prev_input_data_format_ != cdma_input_data_format_)) {
            // Not reuse data of previous layer. wait until cbuf is empty
            if (cdma_req_prev_data_bank_ != cdma_data_bank_) {
                cslInfo(("Before WaitUntilDataEntryPlanedIndexEqualEntryFreeIndex\n"));
                WaitUntilDataEntryPlanedIndexEqualEntryFreeIndex();
                cslInfo(("After WaitUntilDataEntryPlanedIndexEqualEntryFreeIndex\n"));
                data_entry_idx_free_    = (cdma_data_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH - 1;
                data_entry_idx_working_ = 0;
                data_entry_idx_planed_  = -1;
                cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread not dat_first_layer. Bank changed, not reuse data. data_entry_idx_free_=0x%x data_entry_idx_working_=0x%x data_entry_idx_planed_=0x%x\n", data_entry_idx_free_, data_entry_idx_working_, data_entry_idx_planed_));
            } else {
                // Continue to use cbuf following the end of previous layer
                // data_entry_idx_free_ will be updated by sc2cdma
                data_entry_idx_working_ = data_entry_idx_planed_ + 1;
                cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread not dat_first_layer. Not reuse data. data_entry_idx_free_=0x%x data_entry_idx_working_=0x%x data_entry_idx_planed_=0x%x\n", data_entry_idx_free_, data_entry_idx_working_, data_entry_idx_planed_));
            }
        }
        else if (cdma_req_prev_skip_data_rls_ && cdma_data_reuse_ && (cdma_req_prev_conv_mode_ == cdma_conv_mode_) && (cdma_req_prev_data_bank_ == cdma_data_bank_) && 
            (cdma_req_prev_weight_bank_ == cdma_weight_bank_) && (cdma_req_prev_input_data_format_ == cdma_input_data_format_)) {
            // Reuse all data of previous layer. Skip fetching new data.
            cdma_req_prev_skip_data_rls_= cdma_skip_data_rls_;
            cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread not dat_first_layer. Reuse all data of previous layer. data_entry_idx_free_=0x%x data_entry_idx_working_=0x%x data_entry_idx_planed_=0x%x\n", data_entry_idx_free_, data_entry_idx_working_, data_entry_idx_planed_));
            continue;
        }
        else {
            // reuse partial data of previous layer OR not reuse data of previous layer
            // Continue to use cbuf following the end of previous layer
            // data_entry_idx_free_ will be updated by sc2cdma
            data_entry_idx_working_ = data_entry_idx_planed_ + 1;
            cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread not dat_first_layer. Partial resue or not reuse data. data_entry_idx_free_=0x%x data_entry_idx_working_=0x%x data_entry_idx_planed_=0x%x\n", data_entry_idx_free_, data_entry_idx_working_, data_entry_idx_planed_));
        }

        if ( NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE == cdma_datain_format_) {
            // Direct convolution or Winograd convolution
            if (NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT == cdma_conv_mode_) {
                // Direct convolution
                if (0 == cdma_batches_) {
                    cdma_act_data_operation_mode = ACT_MODE_DIRECT_CONV_NONE_BATCH;
                } else {
                    cdma_act_data_operation_mode = ACT_MODE_DIRECT_CONV_BATCH;
                }
            } else if (NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_WINOGRAD == cdma_conv_mode_) {
                cdma_act_data_operation_mode = ACT_MODE_WINOGRAD_CONV;
#pragma CTC SKIP
            } else {
                FAIL(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, unsupport mode, cdma_conv_mode_ is 0x%X", cdma_conv_mode_));
            }
#pragma CTC ENDSKIP
        }
        else if (NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_PIXEL == cdma_datain_format_) {
            // Image load, only Direct convolution is supported
            if (NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT == cdma_conv_mode_) {
                if (0 == cdma_batches_) {
                    cdma_act_data_operation_mode = ACT_MODE_DIRECT_PIXEL;
#pragma CTC SKIP
                } else {
                    FAIL(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, unsupport mode, cdma_conv_mode_ is 0x%X", cdma_conv_mode_));
                }
            } else {
                FAIL(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, unsupport mode, cdma_conv_mode_ is 0x%X", cdma_conv_mode_));
            }
        }
        else {
            // HOG
            FAIL(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, image load sequences has not been implemented."));
        }
#pragma CTC ENDSKIP

        // Call corresponding sequencer based on operation mode
        switch(cdma_act_data_operation_mode) {
            case ACT_MODE_DIRECT_CONV_NONE_BATCH:
            case ACT_MODE_DIRECT_CONV_BATCH:
                cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, before DirectConvDataRequestSequencerCommon\n"));
                DirectConvDataRequestSequencerCommon();
                cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, after DirectConvDataRequestSequencerCommon\n"));
                break;
            case ACT_MODE_WINOGRAD_CONV:
                cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, before WinotConvDataRequestSequencerCommon\n"));
                WinoConvDataRequestSequencerCommon();
                cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, after WinoConvDataRequestSequencerCommon\n"));
                break;
            case ACT_MODE_DIRECT_PIXEL:
                cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, before ImageConvDataRequestSequencerCommon\n"));
                ImageConvDataRequestSequencerCommon();
                cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, after ImageConvDataRequestSequencerCommon\n"));
                break;
#pragma CTC SKIP
            default:
                FAIL(("Invalid cdma_act_data_operation_mode\n"));
#pragma CTC ENDSKIP
        }
        cdma_req_prev_conv_mode_    = cdma_conv_mode_;
        cdma_req_prev_skip_data_rls_= cdma_skip_data_rls_;
        cdma_req_prev_data_bank_    = cdma_data_bank_;
        cdma_req_prev_weight_bank_  = cdma_weight_bank_;

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                cdma_req_prev_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                cdma_req_prev_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            cdma_req_prev_input_data_format_ = INPUT_DATA_FORMAT_WINO;
        cslInfo(("NV_NVDLA_cdma::ActDataReadRequestSequenceThread, end of current layer\n"));
    }
}

void NV_NVDLA_cdma::ActDataReadResponseSequenceThread () {
    uint32_t cdma_act_data_operation_mode;
    uint8_t  cdma_resp_input_data_format_;
    while (true) {
        wait(cdma_kickoff_);

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                cdma_resp_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                cdma_resp_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            cdma_resp_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        if (cdma_resp_prev_skip_data_rls_ && cdma_data_reuse_ && (cdma_resp_prev_conv_mode_ == cdma_conv_mode_) && (cdma_resp_prev_data_bank_ == cdma_data_bank_) && 
            (cdma_resp_prev_weight_bank_ == cdma_weight_bank_) && (cdma_resp_prev_input_data_format_ == cdma_resp_input_data_format_)) {
            // Reuse all data of previous layer's data. Skip fetching new data.
            cdma_resp_prev_skip_data_rls_= cdma_skip_data_rls_;
            cdma_dat2glb_done_intr[cdma_consumer_].write(true);
            cdma_data_fetch_done_fifo_->write(true);
            cslInfo(("NV_NVDLA_cdma::ActDataReadResponseSequenceThread Begin. Reuse all data. CDMA Data Fetch Done. consumer pointer is %d\n", cdma_consumer_));
            continue;
        } else {
            cslInfo(("NV_NVDLA_cdma::ActDataReadResponseSequenceThread Begin. Not reuse all data.\n"));
        }

        if ( NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE == cdma_datain_format_) {
            // Direct convolution or Winograd convolution
            if (NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT == cdma_conv_mode_) {
                // Direct convolution
                if (0 == cdma_batches_) {
                    cdma_act_data_operation_mode = ACT_MODE_DIRECT_CONV_NONE_BATCH;
                } else {
                    cdma_act_data_operation_mode = ACT_MODE_DIRECT_CONV_BATCH;
                }
            } else if (NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_WINOGRAD == cdma_conv_mode_) {
                cdma_act_data_operation_mode = ACT_MODE_WINOGRAD_CONV;
#pragma CTC SKIP
            } else {
                FAIL(("NV_NVDLA_cdma::ActDataReadResponseSequenceThread, unsupport mode, cdma_conv_mode_ is 0x%X", cdma_conv_mode_));
            }
#pragma CTC ENDSKIP
        } else {
            // Image load
            cdma_act_data_operation_mode = ACT_MODE_DIRECT_PIXEL;
        }

        data_nan_num_perlayer_ =0;
        data_inf_num_perlayer_ =0;

        // Call corresponding sequencer based on operation mode
        switch(cdma_act_data_operation_mode) {
            case ACT_MODE_DIRECT_CONV_NONE_BATCH:
            case ACT_MODE_DIRECT_CONV_BATCH:
                DirectConvDataResponseSequencerCommon();
                break;
            case ACT_MODE_WINOGRAD_CONV:
                WinoConvDataResponseSequencerCommon();
                break;
            case ACT_MODE_DIRECT_PIXEL:
                ImageConvDataResponseSequencerCommon();
                break;
#pragma CTC SKIP
            default:
                FAIL(("Invalid cdma_act_data_operation_mode\n"));
#pragma CTC ENDSKIP
        }

        cdma_resp_prev_conv_mode_    = cdma_conv_mode_;
        cdma_resp_prev_skip_data_rls_= cdma_skip_data_rls_;
        cdma_resp_prev_data_bank_    = cdma_data_bank_;
        cdma_resp_prev_weight_bank_  = cdma_weight_bank_;

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                cdma_resp_prev_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                cdma_resp_prev_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            cdma_resp_prev_input_data_format_ = INPUT_DATA_FORMAT_WINO;

#pragma CTC SKIP
        if (act_data_read_rsp_fifo_->num_available() != 0)
            FAIL(("act_data_read_rsp_fifo_ should be empty in the end of NV_NVDLA_cdma::ActDataReadResponseSequenceThread. act_data_read_rsp_fifo_->num_available()=0x%x\n", act_data_read_rsp_fifo_->num_available()));
#pragma CTC ENDSKIP
        cslInfo(("NV_NVDLA_cdma::ActDataReadResponseSequenceThread end of layer\n"));

        cdma_dat2glb_done_intr[cdma_consumer_].write(true);
        cdma_data_fetch_done_fifo_->write(true);
        cslInfo(("CDMA Data Fetch Done. consumer pointer is %d\n", cdma_consumer_));
    }
}

void NV_NVDLA_cdma::WeightReadRequestSequenceThread () {
    uint8_t wt_req_input_data_format_;
    while (true) {
        cslInfo(("before wait cdma_kickoff_\n"));
        wait(cdma_kickoff_);
        cslInfo(("wait cdma_kickoff_ done\n"));

        WaitUntilSCWeightKickOff();
        cslInfo(("wait csc_kickoff_ done\n"));

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                wt_req_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                wt_req_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            wt_req_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        if (wt_first_layer) {  // The first layer
            wt_first_layer = false;
            weight_entry_idx_free_   = (cdma_weight_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH - 1;
            weight_entry_idx_working_ = 0;
            weight_entry_idx_planed_ = -1;
            weight_byte_idx_planed_  = 0;
            //if (cdma_weight_reuse_)
            //    FAIL(("Can't reuse weight when first layer\n"));

            cslInfo(("NV_NVDLA_cdma::WeightReadRequestSequenceThread wt_first_layer. weight_entry_idx_free_=0x%x weight_entry_idx_working_=0x%x weight_entry_idx_planed_=0x%x weight_byte_idx_planed_=0x%x\n", weight_entry_idx_free_, weight_entry_idx_working_, weight_entry_idx_planed_, weight_byte_idx_planed_));
        }
        else if ((wt_req_cdma_prev_conv_mode_ != cdma_conv_mode_) || (wt_req_cdma_prev_weight_bank_ != cdma_weight_bank_) || (wt_req_cdma_prev_data_bank_ != cdma_data_bank_) || (wt_req_prev_input_data_format_ != wt_req_input_data_format_)) {
            if ((wt_req_cdma_prev_weight_bank_ != cdma_weight_bank_) || (wt_req_cdma_prev_data_bank_ != cdma_data_bank_)) {
                // Not reuse weight. wait until cbuf is empty and then restart from the beginning of cbuf weight banks
                WaitUntilWeightEntryPlanedIndexEqualEntryFreeIndex();
                weight_entry_idx_free_      = (cdma_weight_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH - 1;
                weight_entry_idx_working_   = 0;
                weight_entry_idx_planed_    = -1;
                weight_byte_idx_planed_     = 0;

                cslInfo(("NV_NVDLA_cdma::WeightReadRequestSequenceThread not first_layer. BANK Changed. Not reuse weight. weight_entry_idx_free_=0x%x weight_entry_idx_working_=0x%x weight_entry_idx_planed_=0x%x weight_byte_idx_planed_=0x%x\n", weight_entry_idx_free_, weight_entry_idx_working_, weight_entry_idx_planed_, weight_byte_idx_planed_));
            }
            else {
                weight_entry_idx_working_ = weight_entry_idx_planed_ + 1;
                cslInfo(("NV_NVDLA_cdma::WeightReadRequestSequenceThread not first_layer. Not reuse weight. weight_entry_idx_free_=0x%x weight_entry_idx_working_=0x%x weight_entry_idx_planed_=0x%x weight_byte_idx_planed_=0x%x\n", weight_entry_idx_free_, weight_entry_idx_working_, weight_entry_idx_planed_, weight_byte_idx_planed_));
            }
        }
        else if (wt_req_cdma_prev_skip_weight_rls_ && cdma_weight_reuse_ && (wt_req_cdma_prev_conv_mode_ == cdma_conv_mode_)
                && (wt_req_cdma_prev_data_bank_ == cdma_data_bank_) && (wt_req_cdma_prev_weight_bank_ == cdma_weight_bank_) && (wt_req_prev_input_data_format_ == wt_req_input_data_format_)) {
            // reuse entire weight of previous layer. Skip fetching new weight
            wt_req_cdma_prev_skip_weight_rls_ = cdma_skip_weight_rls_;
            cslInfo(("NV_NVDLA_cdma::WeightReadRequestSequenceThread not first_layer. Reuse entire weight. weight_entry_idx_free_=0x%x weight_entry_idx_working_=0x%x weight_entry_idx_planed_=0x%x weight_byte_idx_planed_=0x%x\n", weight_entry_idx_free_, weight_entry_idx_working_, weight_entry_idx_planed_, weight_byte_idx_planed_));
            continue;
        }
        else { // not reuse weight of previous layer, Continue to use cbuf following the end of previous layer
            weight_entry_idx_working_ = weight_entry_idx_planed_ + 1;
            cslInfo(("NV_NVDLA_cdma::WeightReadRequestSequenceThread not first_layer. Not reuse weight. weight_entry_idx_free_=0x%x weight_entry_idx_working_=0x%x weight_entry_idx_planed_=0x%x weight_byte_idx_planed_=0x%x\n", weight_entry_idx_free_, weight_entry_idx_working_, weight_entry_idx_planed_, weight_byte_idx_planed_));

#pragma CTC SKIP
            // Check reuse
            if ( (NVDLA_CDMA_D_MISC_CFG_0_WEIGHT_REUSE_ENABLE == cdma_weight_reuse_) && (NVDLA_CDMA_D_MISC_CFG_0_SKIP_WEIGHT_RLS_DISABLE == wt_req_cdma_prev_skip_weight_rls_) ) {
                FAIL (("NV_NVDLA_cdma::WeightReadRequestSequenceThread, invalid config, current layer is weight_reuse, previous layer shall be full input."));
            }
            // Check weight bank
            if ( (NVDLA_CDMA_D_MISC_CFG_0_WEIGHT_REUSE_ENABLE == cdma_weight_reuse_) && (wt_req_cdma_prev_weight_bank_ != cdma_weight_bank_) ) {
                FAIL (("NV_NVDLA_cdma::WeightReadRequestSequenceThread, invalid config, current layer is weight_reuse, weight bank settings shall be the same as previous layer."));
            }
        }
#pragma CTC ENDSKIP

        // For SCVE: the entire WGS read should be done before weight request is sent
        // For UVM:  the WGS read request should begin before weight read request to make sure that wgs_buffer_ is initialzed
        cdma_wgs2wt_sync_fifo_->read();

        cslInfo(("NV_NVDLA_cdma::WeightReadRequestSequenceThread, before DirectConvWeightRequestSequencerCommon\n"));
        DirectConvWeightRequestSequencerCommon();
        cslInfo(("NV_NVDLA_cdma::WeightReadRequestSequenceThread, after DirectConvWeightRequestSequencerCommon\n"));

        wt_req_cdma_prev_skip_weight_rls_ = cdma_skip_weight_rls_;
        wt_req_cdma_prev_weight_bank_     = cdma_weight_bank_;
        wt_req_cdma_prev_data_bank_       = cdma_data_bank_;
        wt_req_cdma_prev_conv_mode_       = cdma_conv_mode_;

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                wt_req_prev_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                wt_req_prev_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            wt_req_prev_input_data_format_ = INPUT_DATA_FORMAT_WINO;
        cslInfo(("NV_NVDLA_cdma::WeightReadRequestSequenceThread HW layer done\n"));
    }
}

void NV_NVDLA_cdma::WeightReadResponseSequenceThread () {
    uint32_t cdma_wt_data_operation_mode;
    uint8_t  wt_resp_input_data_format_;
    while (true) {
        wait(cdma_kickoff_);

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                wt_resp_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                wt_resp_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            wt_resp_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        if (wt_resp_cdma_prev_skip_weight_rls_ && cdma_weight_reuse_ && (wt_resp_cdma_prev_conv_mode_ == cdma_conv_mode_)
            && (wt_resp_cdma_prev_data_bank_ == cdma_data_bank_) && (wt_resp_cdma_prev_weight_bank_ == cdma_weight_bank_) && (wt_resp_prev_input_data_format_ == wt_resp_input_data_format_)) {
            // Reuse all data of previous layer's data. Skip fetching new data.
            wt_resp_cdma_prev_skip_weight_rls_ = cdma_skip_weight_rls_;

            // wt2glb_done_intr includes the fetch done of wgs and wmb
            cdma_wmb_fetch_done2wt_fifo_->read();
            cdma_wt2glb_done_intr[cdma_consumer_].write(true);
            cdma_weight_fetch_done_fifo_->write(true);
            cslInfo(("Reuse weight. CDMA Weight Fetch Done. consumer pointer is %d\n", cdma_consumer_));
            continue;
        }
        else {
            cslInfo(("NV_NVDLA_cdma::WeightReadResponseSequenceThread. Not reuse weight. \n"));
        }

        if ( NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE == cdma_datain_format_) {
            // Direct convolution or Winograd convolution
            if (NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT == cdma_conv_mode_) {
                // Direct convolution
                cdma_wt_data_operation_mode = WT_MODE_DIRECT_CONV;
            } else if (NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_WINOGRAD == cdma_conv_mode_) {
                cdma_wt_data_operation_mode = WT_MODE_WINOGRAD_CONV;
            } else {
                FAIL(("NV_NVDLA_cdma::WeightReadResponseSequenceThread, unsupport mode, cdma_conv_mode_ is 0x%X", cdma_conv_mode_));
            }
        } else {
            // Image load
            cdma_wt_data_operation_mode = WT_MODE_IMAGE_LOAD;
        }

        weight_nan_num_perlayer_ =0;
        weight_inf_num_perlayer_ =0;
        // Call corresponding sequencer based on operation mode
        switch(cdma_wt_data_operation_mode) {
            case WT_MODE_DIRECT_CONV:
            case WT_MODE_IMAGE_LOAD:
                DirectConvWeightResponseSequencerCommon();
                break;
            case WT_MODE_WINOGRAD_CONV:
                DirectConvWeightResponseSequencerCommon();
                break;
#pragma CTC SKIP
            default:
                FAIL(("Invalid cdma_wt_data_operation_mode\n"));
#pragma CTC ENDSKIP
        }

        wt_resp_cdma_prev_skip_weight_rls_ = cdma_skip_weight_rls_;
        wt_resp_cdma_prev_weight_bank_     = cdma_weight_bank_;
        wt_resp_cdma_prev_data_bank_       = cdma_data_bank_;
        wt_resp_cdma_prev_conv_mode_       = cdma_conv_mode_;

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                wt_resp_prev_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                wt_resp_prev_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            wt_resp_prev_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        // wt2glb_done_intr includes the fetch done of wgs and wmb
        cdma_wmb_fetch_done2wt_fifo_->read();
        cdma_wt2glb_done_intr[cdma_consumer_].write(true);
        cdma_weight_fetch_done_fifo_->write(true);
        cslInfo(("CDMA Weight Fetch Done. consumer pointer is %d\n", cdma_consumer_));
    }
}

void NV_NVDLA_cdma::WGSReadRequestSequenceThread () {
    uint32_t weight_kernel;
    uint32_t wgs_total_bytes;
    uint8_t  wgs_req_input_data_format_;
    while (true) {
        wait(cdma_kickoff_);

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                wgs_req_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                wgs_req_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            wgs_req_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        if (wgs_first_layer) {
            wgs_first_layer = false;
        }
        else if (wgs_req_cdma_prev_skip_weight_rls_ && cdma_weight_reuse_ && (wgs_req_cdma_prev_conv_mode_ == cdma_conv_mode_)
                && (wgs_req_cdma_prev_data_bank_ == cdma_data_bank_) && (wgs_req_cdma_prev_weight_bank_ == cdma_weight_bank_) && (wgs_req_prev_input_data_format_ == wgs_req_input_data_format_)) {
            // reuse entire weight of previous layer. Skip fetching wgs
            wgs_req_cdma_prev_skip_weight_rls_ = cdma_skip_weight_rls_;
            continue;
        }

        // Not reuse previous layer's wgs

        if(cdma_weight_format_ == NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED) {
            cslInfo(("NV_NVDLA_cdma::WGSReadRequestSequenceThread, weight is compressed\n"));
            weight_kernel = cdma_weight_kernel_ + 1;
            wgs_total_bytes = weight_kernel * sizeof(uint32_t);
            if(wgs_buffer_) delete[] wgs_buffer_;
            uint32_t atom_num = (wgs_total_bytes + ATOM_SIZE_INT8 - 1) / ATOM_SIZE_INT8;
            uint32_t buffer_size = (atom_num * ATOM_SIZE_INT8) / sizeof(uint32_t);
            wgs_buffer_ = new uint32_t [buffer_size]; // Align to ATOM_SIZE
            if (cdma_wt_dma_arbiter_override_enable) {
                for (uint32_t i = 0; i < buffer_size; i++)
                    wgs_buffer_[i] = 0xffffffff;    // Max uint32_t
                cdma_wgs2wt_sync_fifo_->write(true);
            }
            ConvWGSRequestSequencerCommon();
        }
        else {
            cslInfo(("NV_NVDLA_cdma::WGSReadRequestSequenceThread, weight is not compressed\n"));
            if (cdma_wt_dma_arbiter_override_enable)
                cdma_wgs2wt_sync_fifo_->write(true);
        }

        wgs_req_cdma_prev_skip_weight_rls_ = cdma_skip_weight_rls_;
        wgs_req_cdma_prev_weight_bank_     = cdma_weight_bank_;
        wgs_req_cdma_prev_data_bank_       = cdma_data_bank_;
        wgs_req_cdma_prev_conv_mode_       = cdma_conv_mode_;

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                wgs_req_prev_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                wgs_req_prev_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            wgs_req_prev_input_data_format_ = INPUT_DATA_FORMAT_WINO;
    }
}

void NV_NVDLA_cdma::WGSReadResponseSequenceThread () {
    uint8_t  wgs_resp_input_data_format_;
    while (true) {
        wait(cdma_kickoff_);

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                wgs_resp_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                wgs_resp_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            wgs_resp_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        // cdma_weight_reuse_ should be false for the 1st layer
        if (wgs_resp_cdma_prev_skip_weight_rls_ && cdma_weight_reuse_ && (wgs_resp_cdma_prev_conv_mode_ == cdma_conv_mode_)
                && (wgs_resp_cdma_prev_data_bank_ == cdma_data_bank_) && (wgs_resp_cdma_prev_weight_bank_ == cdma_weight_bank_) && (wgs_resp_prev_input_data_format_ == wgs_resp_input_data_format_)) {
            // reuse entire weight of previous layer. Skip fetching wgs
            wgs_resp_cdma_prev_skip_weight_rls_ = cdma_skip_weight_rls_;
            cdma_wgs_fetch_done_fifo_->write(true);
            cslInfo(("CDMA WGS Fetch Done\n"));
            continue;
        }

        // Not reuse previous layer's wgs

        if(cdma_weight_format_ == NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED) {
            cslInfo(("NV_NVDLA_cdma::WGSReadResponseSequenceThread, weight is compressed\n"));
            ConvWGSResponseSequencerCommon();
        }
        else {
            cslInfo(("NV_NVDLA_cdma::WGSReadResponseSequenceThread, weight is not compressed\n"));
        }

        wgs_resp_cdma_prev_skip_weight_rls_ = cdma_skip_weight_rls_;
        wgs_resp_cdma_prev_weight_bank_     = cdma_weight_bank_;
        wgs_resp_cdma_prev_data_bank_       = cdma_data_bank_;
        wgs_resp_cdma_prev_conv_mode_       = cdma_conv_mode_;

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                wgs_resp_prev_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                wgs_resp_prev_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            wgs_resp_prev_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        cdma_wgs_fetch_done_fifo_->write(true);
        if (!cdma_wt_dma_arbiter_override_enable)   // In SCVE
            cdma_wgs2wt_sync_fifo_->write(true);
        cslInfo(("CDMA WGS Fetch Done\n"));
    }
}

void NV_NVDLA_cdma::WMBReadRequestSequenceThread () {
    uint8_t  wmb_req_input_data_format_;
    while (true) {
        wait(cdma_kickoff_);

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                wmb_req_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                wmb_req_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            wmb_req_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        if (wmb_first_layer) {  // The first layer
            wmb_first_layer = false;
            wmb_entry_idx_free_   = NVDLA_CBUF_BANK_DEPTH - 1;
            wmb_entry_idx_working_ = 0;
            wmb_entry_idx_planed_ = -1;
            wmb_byte_idx_planed_  = 0;
            cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, wmb_first_layer\n"));
            if(cdma_weight_format_ == NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED) {
                cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, weight is compressed\n"));
                ConvWMBRequestSequencerCommon();
            }
            else {
                cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, weight is not compressed\n"));
            }
        }
        else if (cdma_weight_format_ == NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED) {    //current layer is weight compression
            cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, not first layer. weight is compressed\n"));
            if (wmb_req_cdma_prev_weight_format_ == NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED) { //prev layer is weight compression
                if (wmb_req_cdma_prev_skip_weight_rls_ && cdma_weight_reuse_ && (wmb_req_cdma_prev_conv_mode_ == cdma_conv_mode_)
                        && (wmb_req_cdma_prev_data_bank_ == cdma_data_bank_) && (wmb_req_cdma_prev_weight_bank_ == cdma_weight_bank_) && (wmb_req_prev_input_data_format_ == wmb_req_input_data_format_)) {
                    // reuse entire weight of previous layer. Skip fetching new weight
                    wmb_req_cdma_prev_skip_weight_rls_ = cdma_skip_weight_rls_;
                    cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, reuse entire weight\n"));
                    continue;
                } else if ((wmb_req_cdma_prev_weight_bank_ != cdma_weight_bank_) || (wmb_req_cdma_prev_data_bank_ != cdma_data_bank_)) {
                    // Not reuse weight and wait until cbuf is empty and restart from the beginning of wmb banks
                    cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, not reuse wmb due to config change. BANK changed, rewind cbuf\n"));
                    WaitUntilWmbEntryPlanedIndexEqualEntryFreeIndex();
                    wmb_entry_idx_free_   = NVDLA_CBUF_BANK_DEPTH - 1;
                    wmb_entry_idx_working_ = 0;
                    wmb_entry_idx_planed_ = -1;
                    wmb_byte_idx_planed_  = 0;
                } else {    // not reuse weight
                    wmb_entry_idx_working_ = wmb_entry_idx_planed_ + 1;
                    cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, not reuse wmb due to config change.\n"));
                }
            } else { //prev layer is not weight compression
                if (cdma_weight_reuse_)
                    FAIL(("Can't reuse weight when previous layer is not weight compression and current is weight compression\n"));
                else if ((wmb_req_cdma_prev_weight_bank_ != cdma_weight_bank_) || (wmb_req_cdma_prev_data_bank_ != cdma_data_bank_)) {
                    // Not reuse weight. wait until cbuf is empty and restart from the beginning of wmb banks
                    cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, not reuse wmb due to config change. BANK changed, rewind cbuf\n"));
                    WaitUntilWmbEntryPlanedIndexEqualEntryFreeIndex();
                    wmb_entry_idx_free_   = NVDLA_CBUF_BANK_DEPTH - 1;
                    wmb_entry_idx_working_ = 0;
                    wmb_entry_idx_planed_ = -1;
                    wmb_byte_idx_planed_  = 0;
                } else {
                    wmb_entry_idx_working_ = wmb_entry_idx_planed_ + 1;
                    cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, not reuse wmb due to config change.\n"));
                }
            }
            cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, weight is compressed. before ConvWMBRequestSequencerCommon\n"));
            ConvWMBRequestSequencerCommon();
            cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, weight is compressed. after ConvWMBRequestSequencerCommon\n"));
        } else {    // //current layer is not weight compression
            if (wmb_req_cdma_prev_weight_format_ == NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED) { //prev layer is weight compression
                if (cdma_weight_reuse_)
                    FAIL(("Can't reuse weight when previous layer is weight compression and current is not weight compression\n"));
                else if ((wmb_req_cdma_prev_weight_bank_ != cdma_weight_bank_) || (wmb_req_cdma_prev_data_bank_ != cdma_data_bank_)) {
                    // Not reuse weight and wait until cbuf is empty and restart from the beginning of wmb banks
                    cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, not reuse wmb due to config change. BANK changed, rewind cbuf\n"));
                    WaitUntilWmbEntryPlanedIndexEqualEntryFreeIndex();
                    wmb_entry_idx_free_   = NVDLA_CBUF_BANK_DEPTH - 1;
                    wmb_entry_idx_working_ = 0;
                    wmb_entry_idx_planed_ = -1;
                    wmb_byte_idx_planed_  = 0;
                } else {
                    wmb_entry_idx_working_ = wmb_entry_idx_planed_ + 1;
                    cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, not reuse wmb due to config change.\n"));
                }
            } else {    //prev layer is not weight compression
                if ((wmb_req_cdma_prev_weight_bank_ != cdma_weight_bank_) || (wmb_req_cdma_prev_data_bank_ != cdma_data_bank_)) {
                    // Not reuse weight and wait until cbuf is empty and restart from the beginning of wmb banks
                    cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, not reuse wmb due to config change. BANK changed, rewind cbuf\n"));
                    WaitUntilWmbEntryPlanedIndexEqualEntryFreeIndex();
                    wmb_entry_idx_free_   = NVDLA_CBUF_BANK_DEPTH - 1;
                    wmb_entry_idx_working_ = 0;
                    wmb_entry_idx_planed_ = -1;
                    wmb_byte_idx_planed_  = 0;
                } else {
                    wmb_entry_idx_working_ = wmb_entry_idx_planed_ + 1;
                    cslInfo(("NV_NVDLA_cdma::WMBReadRequestSequenceThread, not reuse wmb due to config change.\n"));
                }
            }
        }

        wmb_req_cdma_prev_skip_weight_rls_ = cdma_skip_weight_rls_;
        wmb_req_cdma_prev_weight_bank_     = cdma_weight_bank_;
        wmb_req_cdma_prev_data_bank_       = cdma_data_bank_;
        wmb_req_cdma_prev_conv_mode_       = cdma_conv_mode_;
        wmb_req_cdma_prev_weight_format_   = cdma_weight_format_;

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                wmb_req_prev_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                wmb_req_prev_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            wmb_req_prev_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        cslInfo(("NV_NVDLA_cdma::WmbReadRequestSequenceThread HW layer done\n"));
    }
}

void NV_NVDLA_cdma::WMBReadResponseSequenceThread () {
    uint8_t  wmb_resp_input_data_format_;
    while (true) {
        // Wait kick off event
        wait(cdma_kickoff_);

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                wmb_resp_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                wmb_resp_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            wmb_resp_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        if (wmb_resp_cdma_prev_skip_weight_rls_ && cdma_weight_reuse_ && (wmb_resp_cdma_prev_conv_mode_ == cdma_conv_mode_)
            && (wmb_resp_cdma_prev_data_bank_ == cdma_data_bank_) && (wmb_resp_cdma_prev_weight_bank_ == cdma_weight_bank_) && (wmb_resp_prev_input_data_format_ == wmb_resp_input_data_format_)) {
            // Reuse all data of previous layer's data. Skip fetching new data.
            wmb_resp_cdma_prev_skip_weight_rls_ = cdma_skip_weight_rls_;
            cdma_wmb_fetch_done_fifo_->write(true);
            cdma_wmb_fetch_done2wt_fifo_->write(true);
            cslInfo(("Reuse weight. CDMA Weight Fetch Done. consumer pointer is %d\n", cdma_consumer_));
            continue;
        }
        else {
            cslInfo(("NV_NVDLA_cdma::WMBReadResponseSequenceThread. Not reuse weight. \n"));
        }

        // Not reuse previous layer's wmb

        if(cdma_weight_format_ == NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED) {
            cslInfo(("NV_NVDLA_cdma::WMBReadResponseSequenceThread, weight is compressed\n"));
            ConvWMBResponseSequencerCommon();
        }
        else {
            cslInfo(("NV_NVDLA_cdma::WMBReadResponseSequenceThread, weight is not compressed\n"));
        }

        wmb_resp_cdma_prev_skip_weight_rls_ = cdma_skip_weight_rls_;
        wmb_resp_cdma_prev_weight_bank_     = cdma_weight_bank_;
        wmb_resp_cdma_prev_data_bank_       = cdma_data_bank_;
        wmb_resp_cdma_prev_conv_mode_       = cdma_conv_mode_;

        if (cdma_conv_mode_ == NVDLA_CDMA_D_MISC_CFG_0_CONV_MODE_DIRECT) {
            if (cdma_datain_format_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_FEATURE)
                wmb_resp_prev_input_data_format_ = INPUT_DATA_FORMAT_DC;
            else
                wmb_resp_prev_input_data_format_ = INPUT_DATA_FORMAT_IMAGE;
        } else
            wmb_resp_prev_input_data_format_ = INPUT_DATA_FORMAT_WINO;

        cdma_wmb_fetch_done_fifo_->write(true);
        cdma_wmb_fetch_done2wt_fifo_->write(true);
        cslInfo(("CDMA WMB Fetch Done\n"));
    }
}

void NV_NVDLA_cdma::WtReadRequestThread () {
    int                  source_id;
    cdma_wt_req_t       *cdma_wt_req;
    nvdla_dma_rd_req_t   payload;
    cdma_wt_info_t      *cdma_wt_info;

    while (true) {
        //wait(cdma_kickoff_);
        source_id = wt_dma_rtl_source_id_fifo_->read();
        cslDebug((50, "NV_NVDLA_cdma::WtReadRequestThread, get one req from RTL. source_id=%d\n", source_id));

        if (source_id==CDMA_WEIGHT_DATA) {
            cdma_wt_req = cdma_wt_req_fifo_->read();
        }
        else if (source_id==CDMA_WMB_DATA) {
            cdma_wt_req = cdma_wmb_req_fifo_->read();
        }
        else {
            cdma_wt_req = cdma_wgs_req_fifo_->read();
        }
        memcpy(&payload, &(cdma_wt_req->pd), sizeof(nvdla_dma_rd_req_t));
        delete cdma_wt_req;

        cslDebug((50, "NV_NVDLA_cdma::WtReadRequestThread, get one request. source_id=%d payload_addr=0x%16lx, size=0x%x\n", source_id, payload.pd.dma_read_cmd.addr, payload.pd.dma_read_cmd.size + 1));

        cdma_wt_info = new cdma_wt_info_t();
        cdma_wt_info->cdma_source = source_id;
        cdma_wt_info->payload_size = payload.pd.dma_read_cmd.size + 1;
        cdma_wt_info_fifo_->write(cdma_wt_info);

        if (RAM_ID_MC == cdma_weight_ram_type_) {
            NV_NVDLA_cdma_base::cdma_wt2mcif_rd_req_b_transport(&payload, dma_delay_);
        } else {
            NV_NVDLA_cdma_base::cdma_wt2cvif_rd_req_b_transport(&payload, dma_delay_);
        }

        cslDebug((50, "NV_NVDLA_cdma::WtReadRequestThread, request is sent.\n"));
    }
}

void NV_NVDLA_cdma::Cdma2ScUpdateThread() {
    int32_t wt_kernels, wt_entries, wmb_entries;
    while (true) {
        cslInfo(("wt_up_cdma2sc_b_transport start\n"));
        cslInfo(("reading wt2sc_up_kernel_fifo_\n"));
        wt_kernels  = wt2sc_up_kernel_fifo_->read();
        cslInfo(("reading wt2sc_up_entry_fifo_\n"));
        wt_entries  = wt2sc_up_entry_fifo_->read();

        wt_up_cdma2sc_payload.wt_kernels    =  wt_kernels;
        wt_up_cdma2sc_payload.wt_entries    =  wt_entries;
        if (NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED == cdma_weight_format_) {
            cslInfo(("reading wmb2sc_up_entry_fifo_\n"));
            wmb_entries = wmb2sc_up_fifo_->read();
            wt_up_cdma2sc_payload.wmb_entries   =  wmb_entries;
        }
        else
            wt_up_cdma2sc_payload.wmb_entries   =  0;

        cslInfo(("cdma: wt_kernels=0x%x wt_entries=0x%x wmb_entries=0x%x\n", wt_kernels, wt_entries, wmb_entries));;
        wt_up_cdma2sc_b_transport(&wt_up_cdma2sc_payload, b_transport_delay_);
        cslInfo(("wt_up_cdma2sc_b_transport done\n"));
    }
}

void NV_NVDLA_cdma::DirectConvDataRequestSequencerCommon() {
    // Config variables, they have corresponding value in registers
    uint32_t cube_width, cube_height, cube_channel;
    uint32_t line_stride, surface_stride;
    uint32_t fetch_slice_grain, fetch_slice_grain_last, current_slice_grain;
    uint32_t entry_per_slice;
    uint32_t precision;
    uint64_t base_addr;
    uint16_t batch_num;
    uint64_t batch_stride;
    // # Iterators
    uint32_t surface_iter;
    uint32_t super_slice_iter, super_surface_iter;
    uint16_t batch_iter;
    // Evaluated variablas
    uint32_t element_per_super_atom;
    uint32_t element_size;
    uint32_t atom_per_cbuf_entry;
    uint32_t super_slice_num, super_surface_num;
    uint32_t super_normal_ratio;
    bool     is_line_packed;
    bool     is_surf_packed;
    // Temp variables
    uint32_t atom_num[4], atom_sent_num[4];
    uint64_t payload_addr[4];
    uint64_t payload_addr_1x1;
    uint32_t payload_size;
    uint32_t payload_atom_num;
    bool     last_super_surface;
    uint32_t last_super_surface_size;
    uint32_t atom_sent_num_1x1;
    uint32_t atom_num_1x1;

    // Copy from register value to local config variables, similar with RTL connection
    cube_width      = cdma_datain_width_ + 1;
    cube_height     = cdma_datain_height_ + 1;
    cube_channel    = cdma_datain_channel_ + 1;
    entry_per_slice = cdma_entries_ + 1;
    base_addr       = (uint64_t(cdma_datain_addr_high_0_) << 32) + uint64_t(cdma_datain_addr_low_0_);
    line_stride     = cdma_line_stride_;
    surface_stride  = cdma_surf_stride_;
    batch_num       = cdma_batches_ + 1;
    batch_stride    = cdma_batch_stride_;
    precision       = cdma_in_precision_;
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

    int atom_size = NVDLA_MEMORY_ATOMIC_SIZE * element_size;
    atom_per_cbuf_entry = NVDLA_CBUF_BANK_WIDTH / atom_size;
    super_normal_ratio      = min(MEM_BUS_WIDTH / atom_size, NVDLA_MAC_ATOMIC_C_SIZE / NVDLA_MEMORY_ATOMIC_SIZE);
    element_per_super_atom  = NVDLA_MEMORY_ATOMIC_SIZE * super_normal_ratio;
    fetch_slice_grain       = cdma_grains_ + 1; // For DC, it's the number of lines because one slice contains one line in DC mode.
    super_slice_num         = (cube_height + fetch_slice_grain - 1) / fetch_slice_grain;
    super_surface_num       = (cube_channel + element_per_super_atom - 1) / element_per_super_atom;
    fetch_slice_grain_last  = cube_height - fetch_slice_grain * (super_slice_num - 1);
    is_line_packed          = cdma_line_packed_;
    is_surf_packed          = cdma_surf_packed_;

#pragma CTC SKIP
    if ((batch_num > 1) && (batch_stride < (surface_stride * ((cube_channel + NVDLA_MEMORY_ATOMIC_SIZE - 1) / NVDLA_MEMORY_ATOMIC_SIZE))))
        FAIL(("NV_NVDLA_cdma::DirectConvDataRequestSequencerCommon, invalid configuration batch_stride is 0x%lx, surface_stride is 0x%x.", batch_stride, surface_stride));

    if ((0 == is_line_packed) && (fetch_slice_grain != 1))
        FAIL(("NV_NVDLA_cdma::DirectConvDataRequestSequencerCommon, invalid configuration cdma_line_packed_ and cdma_grains_, cdma_line_packed_ is %d,  cdma_grains_ is %d.", cdma_line_packed_, cdma_grains_));
#pragma CTC ENDSKIP

    cslInfo(("    super_normal_ratio is 0x%x fetch_slice_grain=0x%x\n", super_normal_ratio, fetch_slice_grain));

    slice_idx_available_ = 0;

    uint32_t max_mem_transaction_size = MAX_MEM_TRANSACTION_NUM * DLA_ATOM_SIZE;

    if ((true == is_line_packed) && (true == is_surf_packed) && (1 == cube_width) && (1 == cube_height)) {
        for (batch_iter = 0; batch_iter < batch_num; batch_iter++) {
            atom_num_1x1 = (cube_channel + NVDLA_MEMORY_ATOMIC_SIZE - 1) / NVDLA_MEMORY_ATOMIC_SIZE;
            atom_sent_num_1x1   = 0;
            payload_addr_1x1    = base_addr + batch_iter * batch_stride;
            data_entry_idx_planed_ += (atom_num_1x1 + atom_per_cbuf_entry - 1) / atom_per_cbuf_entry;
            WaitUntilCBufferHasEnoughFreeDataEntry();
            cslDebug((50, "NV_NVDLA_cdma::DirectConvDataRequestSequencerCommon(1x1), atom num calculation. atom_num_1x1 is 0x%x\n", atom_num_1x1));
            while (atom_sent_num_1x1 < atom_num_1x1) {
                // Calculate payload size, payload transaction must be within a 256 byte
                payload_size = max_mem_transaction_size - payload_addr_1x1 % max_mem_transaction_size;
                // Payload transaction shall not larger than rest of atom cube number
                payload_atom_num = min(atom_num_1x1 - atom_sent_num_1x1, payload_size / atom_size);
                payload_size = payload_atom_num * atom_size;
                // Prepare payload
                dma_act_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr_1x1;
                dma_act_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num - 1;
                // Send read request to RDMA
                SendActDmaReadRequest(dma_act_rd_req_payload_, CDMA_FEATURE_DATA, dma_delay_);
                // Increase
                payload_addr_1x1  += payload_size;
                atom_sent_num_1x1 += payload_atom_num;
            }
            // slice_idx_fetched_[cdma_consumer_] += current_slice_grain;
        }
    }
    else { // if line unpacked, fetch_slice_grain should be 1.
        if (fetch_slice_grain > cube_height)
            FAIL(("NV_NVDLA_cdma::DirectConvDataRequestSequencerCommon, invalid configuration fetch_slice_grain=0x%x cube_height=0x%x", fetch_slice_grain, cube_height));
        for (super_slice_iter = 0; super_slice_iter < super_slice_num; super_slice_iter++) {
            current_slice_grain = ((super_slice_iter == (super_slice_num - 1)) ? fetch_slice_grain_last : fetch_slice_grain);
            cslDebug((50, "NV_NVDLA_cdma::DirectConvDataRequestSequencerCommon: super_slice_iter is 0x%x current_slice_grain=0x%x\n", super_slice_iter, current_slice_grain));

            for (batch_iter = 0; batch_iter < batch_num; batch_iter++) {
                cslDebug((50, "NV_NVDLA_cdma::DirectConvDataRequestSequencerCommon: batch_iter is 0x%x\n", batch_iter));
                // Check free entry num is greater or equal to current slice_grain
                data_entry_idx_planed_ += current_slice_grain * entry_per_slice;
                WaitUntilCBufferHasEnoughFreeDataEntry();
                for (super_surface_iter = 0; super_surface_iter < super_surface_num; super_surface_iter++) {     // A super_surface is 64B width
                    last_super_surface = super_surface_iter == (super_surface_num - 1);
                    last_super_surface_size = (cube_channel * element_size) % (element_per_super_atom * element_size);
                    last_super_surface_size = (0 == last_super_surface_size) ? (element_per_super_atom * element_size) : last_super_surface_size;
                    cslDebug((50, "NV_NVDLA_cdma::DirectConvDataRequestSequencerCommon: super_surface_iter is 0x%x\n", super_surface_iter));
                    for (surface_iter = 0; surface_iter < super_normal_ratio; surface_iter++) {
                        atom_num[surface_iter] = cube_width * current_slice_grain;
                        if (last_super_surface && (last_super_surface_size <= surface_iter * atom_size))
                            atom_num[surface_iter] = 0;
                        atom_sent_num[surface_iter] = 0;
                        payload_addr[surface_iter] = base_addr + batch_iter * batch_stride + super_slice_iter * fetch_slice_grain * line_stride + (super_surface_iter * super_normal_ratio + surface_iter) * surface_stride;
                        cslDebug((50, "NV_NVDLA_cdma::DirectConvDataRequestSequencerCommon, atom num calculation\n"));
                        cslDebug((50, "    surface_iter is 0x%x\n", surface_iter));
                        cslDebug((50, "    atom_num[surface_iter] is 0x%x\n", atom_num[surface_iter]));
                        cslDebug((50, "    atom_sent_num[surface_iter] is 0x%x\n", atom_sent_num[surface_iter]));
                        cslDebug((50, "    payload_addr[surface_iter] is 0x%lx\n", payload_addr[surface_iter]));
                    }
                    while (true) {
                        bool all_sent = true;
                        for (surface_iter = 0; surface_iter < super_normal_ratio; surface_iter++) {
                            if (atom_sent_num[surface_iter] < atom_num[surface_iter]) {
                                all_sent = false;
                                break;
                            }
                        }
                        if (all_sent) break;
                        // Traverse each surface within current super
                        for (surface_iter = 0; surface_iter < super_normal_ratio; surface_iter++) {
                            cslDebug((50, "NV_NVDLA_cdma::DirectConvDataRequestSequencerCommon, transaction sending\n"));
                            cslDebug((50, "    surface_iter is 0x%x\n", surface_iter));
                            cslDebug((50, "    atom_num[surface_iter] is 0x%x\n", atom_num[surface_iter]));
                            cslDebug((50, "    atom_sent_num[surface_iter] is 0x%x\n", atom_sent_num[surface_iter]));
                            cslDebug((50, "    payload_addr[surface_iter] is 0x%lx\n", payload_addr[surface_iter]));
                            if (atom_sent_num[surface_iter] < atom_num[surface_iter]) {
                                // Calculate payload size, payload transaction must be within a 256 byte
                                payload_size = max_mem_transaction_size - payload_addr[surface_iter] % max_mem_transaction_size;
                                // Payload transaction shall not larger than rest of atom cube number
                                payload_atom_num = min(atom_num[surface_iter] - atom_sent_num[surface_iter], payload_size / atom_size);
                                payload_size = payload_atom_num * atom_size;
                                // Prepare payload
                                dma_act_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr[surface_iter];
                                dma_act_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num - 1;
                                // Send read request to RDMA
                                SendActDmaReadRequest(dma_act_rd_req_payload_, CDMA_FEATURE_DATA, dma_delay_);
                                // Increase
                                payload_addr[surface_iter]  += payload_size;
                                atom_sent_num[surface_iter] += payload_atom_num;
                            }
                        }
                    }
                }
            }
        }
    }
}

void NV_NVDLA_cdma::DirectConvDataResponseSequencerCommon() {
    // Config variables, they have corresponding value in registers
    uint32_t cube_width, cube_height, cube_channel;
    uint32_t line_stride, surface_stride;
    uint32_t fetch_slice_grain, fetch_slice_grain_last, current_slice_grain;
    uint32_t precision;
    uint32_t proc_precision;
    uint64_t base_addr;
    uint16_t batch_num;
    uint64_t batch_stride;
    int16_t  cvt_offset;
    int16_t  cvt_scale;
    uint8_t  cvt_truncate;
    bool     cvt_en;
    bool     flush_nan2zero;
    // # Iterators
    uint32_t surface_iter;
    uint32_t super_slice_iter, super_surface_iter;
    uint32_t height_iter;
    uint32_t payload_atom_iter;
    uint16_t batch_iter;
    uint32_t i, j;
    // # Evaluated variables
    uint32_t super_atom_size;
    uint32_t element_size;
    uint32_t element_per_super_atom;
    uint32_t atom_per_cbuf_entry;
    uint32_t super_atom_per_cbuf_entry;
    uint32_t atom_per_channel;
    uint32_t super_slice_num, super_surface_num;
    uint32_t data_entry_num;
    uint8_t  super_normal_ratio;
    bool     is_line_packed;
    bool     is_surf_packed;
    uint32_t atom_num[4], atom_sent_num[4];
    uint64_t payload_addr[4];
    uint32_t payload_size;
    uint32_t payload_atom_num;
    uint32_t cbuf_entry_addr;
    uint32_t cbuf_entry_per_slice;
    uint32_t cbuf_entry_per_width;
    uint32_t cripple_atom_num;
    uint32_t atom_stored;
    // Temp variables
    uint8_t  *read_data_ptr;
    uint8_t  **super_surf_fetched_data_ptr, **converted_super_surf_fetched_data_ptr, **fetched_data_ptr;
    uint8_t  *cbuf_payload_data_ptr;
    bool     last_super_surface;
    uint32_t last_super_surface_size;
    uint8_t  fetched_data_1x1[NVDLA_CBUF_BANK_WIDTH], converted_fetched_data_1x1[NVDLA_CBUF_BANK_WIDTH];
    uint8_t  *fetched_data_1x1_ptr;
    uint32_t atom_num_1x1;
    uint32_t read_atom_iter_1x1;
    uint32_t read_atom_num_1x1;

    cube_width          = cdma_datain_width_ + 1;
    cube_height         = cdma_datain_height_ + 1;
    cube_channel        = cdma_datain_channel_ + 1;
    precision           = cdma_in_precision_;
    base_addr           = (uint64_t(cdma_datain_addr_high_0_) << 32) + uint64_t(cdma_datain_addr_low_0_);
    line_stride         = cdma_line_stride_;
    surface_stride      = cdma_surf_stride_;
    batch_num           = cdma_batches_ + 1;
    batch_stride        = cdma_batch_stride_ * DLA_ATOM_SIZE;
    cvt_offset          = cdma_cvt_offset_;
    cvt_scale           = cdma_cvt_scale_;
    cvt_truncate        = cdma_cvt_truncate_;
    cvt_en              = cdma_cvt_en_;
    flush_nan2zero      = cdma_nan_to_zero_;
    proc_precision      = cdma_proc_precision_;

#pragma CTC SKIP
    if (cvt_en) {
        if (precision==NVDLA_CDMA_D_MISC_CFG_0_PROC_PRECISION_FP16)
            FAIL(("Incorrect configuration on conversion on precision in CDMA\n"));
    }
    else {
        if (precision!=proc_precision)
            FAIL(("Incorrect configuration on conversion on precision in CDMA\n"));
    }
#pragma CTC ENDSKIP

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

    int atom_size = NVDLA_MEMORY_ATOMIC_SIZE * element_size;
    atom_per_cbuf_entry = NVDLA_CBUF_BANK_WIDTH / atom_size;
    super_normal_ratio      = min(MEM_BUS_WIDTH / atom_size, NVDLA_MAC_ATOMIC_C_SIZE / NVDLA_MEMORY_ATOMIC_SIZE);
    element_per_super_atom  = NVDLA_MEMORY_ATOMIC_SIZE * super_normal_ratio;
    fetch_slice_grain       = cdma_grains_ + 1;
    super_slice_num         = (cube_height + fetch_slice_grain - 1) / fetch_slice_grain;
    super_surface_num       = (cube_channel + element_per_super_atom - 1) / element_per_super_atom;
    fetch_slice_grain_last  = cube_height - fetch_slice_grain * (super_slice_num - 1);
    data_entry_num          = (cdma_data_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH;
    atom_per_channel        = (cube_channel + NVDLA_MEMORY_ATOMIC_SIZE - 1) / NVDLA_MEMORY_ATOMIC_SIZE;
    cbuf_entry_per_width    = atom_per_channel / atom_per_cbuf_entry;
    cripple_atom_num        = atom_per_channel % atom_per_cbuf_entry;
    cbuf_entry_per_slice    = cbuf_entry_per_width * cube_width;

    if(cripple_atom_num) {
        if (cripple_atom_num > atom_per_cbuf_entry / 2)
            cbuf_entry_per_slice += cube_width;
        else if (cripple_atom_num == atom_per_cbuf_entry / 2)
            cbuf_entry_per_slice += (cube_width + 1) / 2;
        else if (cripple_atom_num == atom_per_cbuf_entry / 4)
            cbuf_entry_per_slice += (cube_width + 3) / 4;
    }

    super_atom_size = atom_size * super_normal_ratio;
    super_atom_per_cbuf_entry = NVDLA_CBUF_BANK_WIDTH / super_atom_size;

    if (uint32_t(cdma_entries_ + 1) != cbuf_entry_per_slice) {
        FAIL(("NV_NVDLA_cdma::DirectConvDataResponseSequencerCommon, invalid configuration cdma_entries_, set value is 0x%X, it shall be 0x%X.", cdma_entries_, cbuf_entry_per_slice - 1));
    }

    if(cube_height * cbuf_entry_per_slice > data_entry_num) {
        FAIL(("NV_NVDLA_cdma::DirectConvDataResponseSequencerCommon, insufficient cbuf space, total entry num is 0x%X, need 0x%X.", data_entry_num, cube_height * cbuf_entry_per_slice));
    }

    is_line_packed  = cdma_line_packed_;
    is_surf_packed  = cdma_surf_packed_;
#pragma CTC SKIP
    if (is_line_packed != (line_stride == atom_size * cube_width)) {
        FAIL(("NV_NVDLA_cdma::DirectConvDataResponseSequencerCommon, invalid configuration of cdma_line_packed_, cdma_line_packed_ is %d, line_stride == atom_size * cube_width is %d.", cdma_line_packed_, (line_stride == atom_size * cube_width)));
    }
    if ( (!is_line_packed) && (fetch_slice_grain!=1) ) {
        FAIL(("NV_NVDLA_cdma::DirectConvDataResponseSequencerCommon, invalid configuration of cdma_line_packed_ and cdma_grains_, cdma_line_packed_ is %d, fetch_slice_grain is %d.", cdma_line_packed_, fetch_slice_grain));
    }
#pragma CTC ENDSKIP

    // slice_idx_sequence_control_mutex_[cdma_consumer_].lock();
    slice_idx_available_ = 0;

    uint32_t max_mem_transaction_size = MAX_MEM_TRANSACTION_NUM * DLA_ATOM_SIZE;

    if ((true == is_line_packed) && (true == is_surf_packed) && (1 == cube_width) && (1 == cube_height)) {
        for (batch_iter = 0; batch_iter < batch_num; batch_iter++) {
            atom_num_1x1 = (cube_channel + NVDLA_MEMORY_ATOMIC_SIZE - 1) / NVDLA_MEMORY_ATOMIC_SIZE;
            read_atom_num_1x1 = 0;
            cdma2cbuf_data_payload_->hsel = super_atom_per_cbuf_entry - 1;
            cslDebug((50, "NV_NVDLA_cdma::DirectConvDataResponseSequencerCommon(1x1), atom num calculation. atom_num_1x1 is 0x%x\n", atom_num_1x1));
            while (read_atom_num_1x1 < atom_num_1x1) {
                read_atom_iter_1x1 = 0;
                while ( read_atom_iter_1x1 < super_normal_ratio ) {
                    read_data_ptr = act_data_read_rsp_fifo_->read();
                    if (DATA_FORMAT_FP16 == precision) {
                        countNaNinData(read_data_ptr, &data_nan_num_perlayer_);
                        countInfinData(read_data_ptr, &data_inf_num_perlayer_);
                    }
                    memcpy(&fetched_data_1x1[read_atom_iter_1x1 * atom_size], read_data_ptr, atom_size);
                    delete [] read_data_ptr;
                    read_atom_iter_1x1++;
                    read_atom_num_1x1++;
                    if(read_atom_num_1x1 == atom_num_1x1)
                        break;
                }

                // Flush NaN to zero
                if (DATA_FORMAT_FP16 == precision) {
                    for (i = 0; i < element_per_super_atom; i++) {
                        uint16_t tmp_fp16 = ((uint16_t)fetched_data_1x1[2 * i + 1]) << 8 | fetched_data_1x1[2 * i];
                        if(isNaN(tmp_fp16)){
                            if (flush_nan2zero)
                                fetched_data_1x1[2 * i] = fetched_data_1x1[2 * i + 1] = 0;
                        }
                    }
                }

                // Converter
                if (cvt_en) {
                    switch (precision) {
                        case DATA_FORMAT_INT8:
                            for (i = 0; i < element_per_super_atom; i++) {
                                int16_t convert_input;
                                int32_t convert_result;
                                convert_input = fetched_data_1x1[i] & 0xff;
                                hls_convertor(&convert_input, PIXEL_SIGNED_INT8, cvt_offset, cvt_scale, cvt_truncate, precision, proc_precision, &convert_result);
                                converted_fetched_data_1x1[i] = *(uint8_t*)&convert_result;
                            }
                            break;
                        case DATA_FORMAT_INT16:
                            for (i = 0; i < element_per_super_atom; i++) {
                                int16_t convert_input;
                                int32_t convert_result;
                                convert_input = (uint16_t(fetched_data_1x1[2 * i + 1]) << 8) | fetched_data_1x1[2 * i];
                                hls_convertor(&convert_input, PIXEL_SIGNED_INT16, cvt_offset, cvt_scale, cvt_truncate, precision, proc_precision, &convert_result);
                                converted_fetched_data_1x1[2 * i] = convert_result & 0xff;
                                converted_fetched_data_1x1[2 * i + 1] = (convert_result >> 8) & 0xff;
                            }
                            break;
                        case DATA_FORMAT_FP16:
                            for (i = 0; i < element_per_super_atom; i++) {
                                int16_t convert_input;
                                int32_t convert_result;
                                convert_input = (uint16_t(fetched_data_1x1[2 * i + 1]) << 8) | fetched_data_1x1[2 * i];
                                hls_convertor(&convert_input, PIXEL_FP16, cvt_offset, cvt_scale, cvt_truncate, precision, proc_precision, &convert_result);
                                converted_fetched_data_1x1[2 * i] = convert_result & 0xff;
                                converted_fetched_data_1x1[2 * i + 1] = (convert_result >> 8) & 0xff;
                            }
                            break;
                    }
                }
                fetched_data_1x1_ptr = cvt_en ? converted_fetched_data_1x1 : fetched_data_1x1;
                cbuf_entry_addr = (data_entry_idx_working_ + batch_iter * cbuf_entry_per_slice + (read_atom_num_1x1 - 1) / atom_per_cbuf_entry) % data_entry_num;
                cdma2cbuf_data_payload_->hsel = (cdma2cbuf_data_payload_->hsel + 1) % super_atom_per_cbuf_entry;
                cbuf_payload_data_ptr = reinterpret_cast <uint8_t *> (cdma2cbuf_data_payload_->data);
                cdma2cbuf_data_payload_->addr = cbuf_entry_addr;
                cdma2cbuf_data_payload_->size = super_atom_size;
                memcpy(cbuf_payload_data_ptr, fetched_data_1x1_ptr, super_atom_size);
                cslDebug((70, "cdma2buf_dat_wr_b_transport(1x1) addr=0x%x hsel=%d read_atom_num_1x1=%d\n", cbuf_entry_addr, (uint32_t)cdma2cbuf_data_payload_->hsel, read_atom_num_1x1));
#if LOG_DETAIL
                cslDebug((90, "data: "));
                for (uint32_t i = 0; i < super_atom_size; i++)
                    cslDebug((90, "0x%x ", cbuf_payload_data_ptr[i]));
                cslDebug((90, "\n"));
#endif
                cdma2buf_dat_wr_b_transport(cdma2cbuf_data_payload_, b_transport_delay_);
            }
            // Update CBUF availiable data status to sequence controller
            slice_idx_available_ += 1;
            data2sc_data_update_payload_->dat_entries = (atom_num_1x1 + atom_per_cbuf_entry - 1) / atom_per_cbuf_entry;
            data2sc_data_update_payload_->dat_slices  = 1;
            dat_up_cdma2sc_b_transport(data2sc_data_update_payload_, b_transport_delay_);
        }
    }
    else { // Not 1x1. Please note that if line unpacked, fetch_slice_grain should be 1.
           // If line packed, fetch_slice_grain can be larger than 1.
        for (super_slice_iter = 0; super_slice_iter < super_slice_num; super_slice_iter++) {
            current_slice_grain = ((super_slice_iter == (super_slice_num - 1)) ? fetch_slice_grain_last : fetch_slice_grain);
            cslDebug((50, "NV_NVDLA_cdma::DirectConvDataResponseSequencerCommon, super_slice_iter=0x%x current_slice_grain=0x%x\n", super_slice_iter, current_slice_grain));
            for (batch_iter = 0; batch_iter < batch_num; batch_iter++) {
                for (super_surface_iter = 0; super_surface_iter < super_surface_num; super_surface_iter++) {
                    last_super_surface = super_surface_iter == (super_surface_num - 1);
                    last_super_surface_size = (cube_channel * element_size) % super_atom_size;
                    last_super_surface_size = (0 == last_super_surface_size) ? super_atom_size : last_super_surface_size;

                     uint32_t last_cbuf_entry = (super_surface_iter / super_atom_per_cbuf_entry) == cbuf_entry_per_width;

                    // ====== Save all data of current super surface to inter buffer =====
                    // Save data to cbuf line by line since a cbuf entry can't across height direction
                    for (surface_iter = 0; surface_iter < super_normal_ratio; surface_iter++) {
                        atom_num[surface_iter] = cube_width * current_slice_grain;
                        if (last_super_surface && (last_super_surface_size <= surface_iter * atom_size))
                            atom_num[surface_iter]    = 0;
                        atom_sent_num[surface_iter]   = 0;
                        // Start address of the surface in current super slice
                        payload_addr[surface_iter] = base_addr + batch_iter * batch_stride + super_slice_iter * fetch_slice_grain * line_stride + (super_surface_iter * super_normal_ratio + surface_iter) * surface_stride;
                    }

                    // array size: array[cube_width * current_slice_grain][64]
                    super_surf_fetched_data_ptr = new uint8_t *[cube_width * current_slice_grain];    // 16 (>8) is required because the two surfaces may not advance in same pace
                    converted_super_surf_fetched_data_ptr = new uint8_t *[cube_width * current_slice_grain];    // 16 (>8) is required because the two surfaces may not advance in same pace
                    for (payload_atom_iter = 0; payload_atom_iter < cube_width * current_slice_grain; payload_atom_iter++) {
                        super_surf_fetched_data_ptr[payload_atom_iter] = new uint8_t[NVDLA_CBUF_BANK_WIDTH];
                        converted_super_surf_fetched_data_ptr[payload_atom_iter] = new uint8_t[NVDLA_CBUF_BANK_WIDTH];
                    }
                    while (true) {
                        bool all_sent = true;
                        for (surface_iter = 0; surface_iter < super_normal_ratio; surface_iter++) {
                            if (atom_sent_num[surface_iter] < atom_num[surface_iter])
                            {
                                all_sent = false;
                                break;
                            }
                        }
                        if (all_sent) break;
                        // Traverse each surface within current super_surface
                        // read all the data of the super surf into super_surf_fetched_data_ptr
                        for (surface_iter = 0; surface_iter < super_normal_ratio; surface_iter++) {
                            cslDebug((50, "NV_NVDLA_cdma::DirectConvDataResponseSequencerCommon, transaction receiving\n"));
                            cslDebug((50, "    surface_iter is 0x%x\n", surface_iter));
                            cslDebug((50, "    atom_num[surface_iter] is 0x%x\n", atom_num[surface_iter]));
                            cslDebug((50, "    atom_sent_num[surface_iter] is 0x%x\n", atom_sent_num[surface_iter]));
                            cslDebug((50, "    payload_addr[surface_iter] is 0x%lx\n", payload_addr[surface_iter]));
                            cslDebug((50,"NV_NVDLA_cdma::DirectConvDataResponseSequencerCommon Receiving data. super_slice_iter=%d batch_iter=%d super_surface_iter=%d surface_iter=%d\n", super_slice_iter, batch_iter, super_surface_iter, surface_iter));
                            if (atom_sent_num[surface_iter] < atom_num[surface_iter]) {
                                // Calculate payload size, payload transaction must be within a 256 byte
                                payload_size = max_mem_transaction_size - payload_addr[surface_iter] % max_mem_transaction_size;
                                // Payload transaction shall not larger than rest of atom cube number
                                payload_atom_num = min(atom_num[surface_iter] - atom_sent_num[surface_iter], payload_size / atom_size);
                                payload_size = payload_atom_num * atom_size;
                                // Get data from act_data_read_rsp_fifo_
                                for (payload_atom_iter = 0; payload_atom_iter < payload_atom_num; payload_atom_iter++) {
                                    read_data_ptr = act_data_read_rsp_fifo_->read();
                                    if (DATA_FORMAT_FP16 == precision) {
                                        countNaNinData(read_data_ptr, &data_nan_num_perlayer_);
                                        countInfinData(read_data_ptr, &data_inf_num_perlayer_);
                                    }
                                    uint32_t curr_payload_idx = atom_sent_num[surface_iter] + payload_atom_iter;
                                    memcpy(&super_surf_fetched_data_ptr[curr_payload_idx][surface_iter * atom_size], read_data_ptr, atom_size);
                                    delete [] read_data_ptr;
                                }
                                payload_addr[surface_iter]  += payload_size;
                                atom_sent_num[surface_iter] += payload_atom_num;
                            }
                        }
                    }

                    // Flush NaN to zero
                    if (DATA_FORMAT_FP16 == precision) {
                        for (i = 0; i < cube_width * current_slice_grain; i++) {
                            for (j = 0; j < element_per_super_atom; j++) {
                                uint16_t tmp_fp16 = ((uint16_t)super_surf_fetched_data_ptr[i][2 * j + 1]) << 8 | super_surf_fetched_data_ptr[i][2 * j];
                                if(isNaN(tmp_fp16)){
                                    if (flush_nan2zero)
                                        super_surf_fetched_data_ptr[i][2 * j] = super_surf_fetched_data_ptr[i][2 * j + 1] = 0;
                                }
                            }
                        }
                    }

                    // Converter
                    if (cvt_en) {
                        switch (precision) {
                            case DATA_FORMAT_INT8:
                                for (i = 0; i < cube_width * current_slice_grain; i++) {
                                    for (j = 0; j < element_per_super_atom; j++) {
                                        int16_t convert_input;
                                        int32_t convert_result;
                                        convert_input = super_surf_fetched_data_ptr[i][j] & 0xff;
                                        hls_convertor(&convert_input, PIXEL_SIGNED_INT8, cvt_offset, cvt_scale, cvt_truncate, precision, proc_precision, &convert_result);
                                        converted_super_surf_fetched_data_ptr[i][j] = *(uint8_t*)&convert_result;
                                    }
                                }
                                break;
                            case DATA_FORMAT_INT16:
                                for (i=0;i<cube_width * current_slice_grain;i++) {
                                    for (j = 0; j < element_per_super_atom; j++) {
                                        int16_t convert_input;
                                        int32_t convert_result;
                                        convert_input = (super_surf_fetched_data_ptr[i][2 * j] & 0xff) | ((super_surf_fetched_data_ptr[i][2 * j + 1] & 0xff) << 8);
                                        hls_convertor(&convert_input, PIXEL_SIGNED_INT16, cvt_offset, cvt_scale, cvt_truncate, precision, proc_precision, &convert_result);
                                        converted_super_surf_fetched_data_ptr[i][2 * j] = convert_result & 0xff;
                                        converted_super_surf_fetched_data_ptr[i][2 * j + 1] = (convert_result >> 8) & 0xff;
                                    }
                                }
                                break;
                            /*  If FP16, cvt_en should be false
                            case DATA_FORMAT_FP16:
                                for (i=0;i<cube_width * current_slice_grain;i++) {
                                    for (j=0;j<CBUF_HALF_ENTRY_SIZE/2;j++) {
                                        int16_t convert_input;
                                        int32_t convert_result;
                                        convert_input = (super_surf_fetched_data_ptr[i][2*j] & 0xff) | ((super_surf_fetched_data_ptr[i][2*j+1] & 0xff) << 8);
                                        hls_convertor(&convert_input, PIXEL_FP16, cvt_offset, cvt_scale, cvt_truncate, precision, proc_precision, &convert_result);
                                        converted_super_surf_fetched_data_ptr[i][2*j] = convert_result & 0xff;
                                        converted_super_surf_fetched_data_ptr[i][2*j+1] = (convert_result >> 8) & 0xff;
                                    }
                                }
                                break;
                            */
                        }
                    }

                    fetched_data_ptr = cvt_en ? converted_super_surf_fetched_data_ptr : super_surf_fetched_data_ptr;

                    // ===== All data of current super slice is received. Now store to CBUF =====
                    // The width of fetched_data_ptr is fixed to 64B
                    // Compute the address to access CBUF
                    for (height_iter = 0; height_iter < current_slice_grain; height_iter++) {   // height iterator in current super slice
                        atom_stored = 0;
                        cbuf_payload_data_ptr = reinterpret_cast <uint8_t *> (cdma2cbuf_data_payload_->data);
                        while(atom_stored < cube_width) {
                            if (last_cbuf_entry && cripple_atom_num && cripple_atom_num <= atom_per_cbuf_entry / 2) {
                                uint32_t cripple_atom_size = cripple_atom_num * atom_size;
                                if (cripple_atom_num == atom_per_cbuf_entry / 4) {  // pack cripple atoms with 4 different width coordinates into one cbuf entry
                                    cbuf_entry_addr = (data_entry_idx_working_ + ((super_slice_iter * fetch_slice_grain + height_iter) * batch_num + batch_iter) * cbuf_entry_per_slice + (super_surface_iter / super_atom_per_cbuf_entry) * cube_width + (atom_stored / 4)) % data_entry_num;
                                    for (surface_iter = 0; surface_iter < super_normal_ratio; surface_iter++) {
                                        if (atom_stored < cube_width)
                                            memcpy(&cbuf_payload_data_ptr[surface_iter * atom_size], fetched_data_ptr[height_iter * cube_width + atom_stored + surface_iter], atom_size);
                                        else
                                            memset(&cbuf_payload_data_ptr[surface_iter * atom_size], 0, atom_size);
                                    }
                                    cdma2cbuf_data_payload_->hsel = super_surface_iter % super_atom_per_cbuf_entry + (atom_stored * cripple_atom_num / super_normal_ratio) % super_atom_per_cbuf_entry;
                                    if(super_atom_size > cripple_atom_size) {
                                        atom_stored += super_atom_size / cripple_atom_size;
                                    } else {
                                        atom_stored += 1;
                                    }
                                } else {  // pack cripple atoms with 2 different width coordinates into one cbuf entry
                                    cbuf_entry_addr = (data_entry_idx_working_ + ((super_slice_iter * fetch_slice_grain + height_iter) * batch_num + batch_iter) * cbuf_entry_per_slice + (super_surface_iter / super_atom_per_cbuf_entry) * cube_width + (atom_stored / 2)) % data_entry_num;
                                    for (surface_iter = 0; surface_iter < super_normal_ratio; surface_iter++) {
                                        if (atom_stored < cube_width)
                                            memcpy(&cbuf_payload_data_ptr[surface_iter * atom_size], fetched_data_ptr[height_iter * cube_width + atom_stored + surface_iter], atom_size);
                                        else
                                            memset(&cbuf_payload_data_ptr[surface_iter * atom_size], 0, atom_size);
                                    }
                                    cdma2cbuf_data_payload_->hsel = super_surface_iter % super_atom_per_cbuf_entry + (atom_stored * cripple_atom_num / super_normal_ratio) % super_atom_per_cbuf_entry;
                                    if(super_atom_size > cripple_atom_size) {
                                        atom_stored += super_atom_size / cripple_atom_size;
                                    } else {
                                        atom_stored += 1;
                                    }
                                }
                            } else {
                                memcpy(cbuf_payload_data_ptr, fetched_data_ptr[height_iter * cube_width + atom_stored], super_atom_size);
                                cbuf_entry_addr = (data_entry_idx_working_ + ((super_slice_iter * fetch_slice_grain + height_iter) * batch_num + batch_iter) * cbuf_entry_per_slice + (super_surface_iter / super_atom_per_cbuf_entry) * cube_width + atom_stored % cube_width) % data_entry_num;
                                cdma2cbuf_data_payload_->hsel = super_surface_iter % super_atom_per_cbuf_entry;
                                atom_stored++;
                            }
                            cdma2cbuf_data_payload_->addr = cbuf_entry_addr;
                            cdma2cbuf_data_payload_->size = super_atom_size;
                            cslDebug((70, "cdma2buf_dat_wr_b_transport addr=0x%x hsel=%d atom_stored=%d\n", cbuf_entry_addr, (unsigned int)(cdma2cbuf_data_payload_->hsel), atom_stored));
#if LOG_DETAIL
                            cslDebug((90, "data: "));
                            for (uint32_t i = 0; i < super_atom_size; i++)
                                cslDebug((90, "0x%x ", cbuf_payload_data_ptr[i]));
                            cslDebug((90, "\n"));
#endif
                            cdma2buf_dat_wr_b_transport(cdma2cbuf_data_payload_, b_transport_delay_);
                        }
                    }

                    for (payload_atom_iter = 0; payload_atom_iter < cube_width * current_slice_grain; payload_atom_iter++) {
                        delete[] super_surf_fetched_data_ptr[payload_atom_iter];
                        delete[] converted_super_surf_fetched_data_ptr[payload_atom_iter];
                    }
                    delete[] super_surf_fetched_data_ptr;
                    delete[] converted_super_surf_fetched_data_ptr;
                }
                slice_idx_available_ += current_slice_grain;
                data2sc_data_update_payload_->dat_entries = current_slice_grain * cbuf_entry_per_slice;
                data2sc_data_update_payload_->dat_slices  = current_slice_grain;
                dat_up_cdma2sc_b_transport(data2sc_data_update_payload_, b_transport_delay_);
                cslDebug((50, "DirectConvDataResponseSequencerCommon. after dat_up_cdma2sc_b_transport. payload->dat_entries=0x%x, payload->dat_slices=0x%x\n", data2sc_data_update_payload_->dat_entries, data2sc_data_update_payload_->dat_slices));
            }
        }
    }
}

void NV_NVDLA_cdma::ConvWGSRequestSequencerCommon() {
    // Temp variables
    uint64_t base_addr;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint32_t payload_atom_num;
    uint32_t weight_kernel;
    uint32_t wgs_total_bytes_fetched;
    uint32_t wgs_total_bytes;

    // Copy from register value to local config variables, similar with RTL connection
    base_addr = (uint64_t(cdma_wgs_addr_high_) << 32) + uint64_t(cdma_wgs_addr_low_);
    weight_kernel = cdma_weight_kernel_ + 1;
    wgs_total_bytes = (weight_kernel + NVDLA_MAC_ATOMIC_K_SIZE - 1) / NVDLA_MAC_ATOMIC_K_SIZE * sizeof(uint32_t);
    cslInfo(("NV_NVDLA_cdma::ConvWGSRequestSequencerCommon, WGS total size is 0x%x\n", wgs_total_bytes));

    wgs_total_bytes_fetched = 0;
    payload_addr = base_addr;

    while (wgs_total_bytes_fetched < wgs_total_bytes) {
        // Fetch WGS and each request is 32B
        payload_size = DLA_ATOM_SIZE;
        payload_atom_num = 1;
        dma_wgs_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr;
        dma_wgs_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num - 1;
        // Send read request to RDMA
        cslDebug((50, "SendWGSDmaReadRequest payload_addr=0x%lx\n", payload_addr));
        if (cdma_wt_dma_arbiter_override_enable)
            SendWeightDmaReadRequestRTL(dma_wgs_rd_req_payload_, CDMA_WGS_DATA, dma_delay_);
        else
            SendWeightDmaReadRequest(dma_wgs_rd_req_payload_, CDMA_WGS_DATA, dma_delay_);
        payload_addr += payload_size;
        wgs_total_bytes_fetched += DLA_ATOM_SIZE;
    }
    // Total weight byte index is 128 aligned
    cslInfo(("NV_NVDLA_cdma::ConvWGSRequestSequencerCommon, end\n"));
}

void NV_NVDLA_cdma::ConvWGSResponseSequencerCommon() {
    // Temp variables
    uint32_t weight_kernel;
    uint32_t wgs_total_bytes_fetched;
    uint32_t wgs_total_bytes;
    uint8_t* read_data_ptr;

    // Copy from register value to local config variables, similar with RTL connection
    weight_kernel = cdma_weight_kernel_ + 1;
    wgs_total_bytes = (weight_kernel + NVDLA_MAC_ATOMIC_K_SIZE - 1) / NVDLA_MAC_ATOMIC_K_SIZE * sizeof(uint32_t);
    cslInfo(("NV_NVDLA_cdma::ConvWGSResponseSequencerCommon, WGS total size is 0x%x\n", wgs_total_bytes));

    wgs_total_bytes_fetched = 0;
    while (wgs_total_bytes_fetched < wgs_total_bytes) {
        read_data_ptr = wgs_read_rsp_fifo_->read();
        memcpy(&wgs_buffer_[wgs_total_bytes_fetched / sizeof(uint32_t)], read_data_ptr, DLA_ATOM_SIZE);
        cslDebug((50, "Read 32B WGS data from wgs_read_rsp_fifo_\n"));
        wgs_total_bytes_fetched += DLA_ATOM_SIZE;
        delete [] read_data_ptr;
        wgs2wt_update_.notify();
    }
    cslInfo(("NV_NVDLA_cdma::ConvWGSResponseSequencerCommon, end\n"));
}

void NV_NVDLA_cdma::ConvWMBRequestSequencerCommon() {
    uint64_t base_addr;
    uint32_t wmb_total_bytes;
    // Temp variables
    uint64_t payload_addr;
    uint32_t payload_size;
    uint32_t payload_atom_num;
    uint32_t wmb_bytes_fetched;

    // Copy from register value to local config variables, similar with RTL connection
    base_addr           = (uint64_t(cdma_wmb_addr_high_) << 32) + uint64_t(cdma_wmb_addr_low_);
    wmb_total_bytes     = cdma_wmb_bytes_ << NVDLA_CDMA_D_WMB_BYTES_0_WMB_BYTES_SHIFT;

    cslInfo(("NV_NVDLA_cdma::ConvWMBRequestSequencerCommon, WMB total size is 0x%x\n", wmb_total_bytes));

    wmb_bytes_fetched = 0;
    payload_addr = base_addr;
    
    uint32_t max_mem_transaction_size = MAX_MEM_TRANSACTION_NUM * DLA_ATOM_SIZE;

    while (wmb_bytes_fetched < wmb_total_bytes) {
        // Calculate payload size, payload transaction must be within a 256 byte
        payload_size = max_mem_transaction_size - payload_addr % max_mem_transaction_size;
        // Payload transaction shall not larger than rest of atom cube number
        payload_atom_num = min((wmb_total_bytes - wmb_bytes_fetched + DLA_ATOM_SIZE - 1) / DLA_ATOM_SIZE, payload_size / DLA_ATOM_SIZE);
        payload_size = payload_atom_num * DLA_ATOM_SIZE;
        // Prepare payload
        dma_wmb_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr;
        dma_wmb_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num - 1;
        // Check free entry num is greater or equal to current slice_grain
        wmb_bytes_fetched  += payload_size;
        wmb_byte_idx_planed_ += payload_size;
        wmb_entry_idx_planed_ = (wmb_byte_idx_planed_ - 1) / NVDLA_CBUF_BANK_WIDTH;
        cslDebug((50, "WaitUntilCBufferHasEnoughFreeWmbEntry start. wmb_bytes_fetched=0x%x wmb_byte_idx_planed_=0x%x\n", wmb_bytes_fetched, wmb_byte_idx_planed_));
        WaitUntilCBufferHasEnoughFreeWmbEntry();
        cslDebug((50, "WaitUntilCBufferHasEnoughFreeWmbEntry end\n"));

        // Send read request to RDMA
        cslDebug((50, "SendWMBDmaReadRequest payload_addr=0x%16lx, payload_atom_num=0x%x\n", payload_addr, payload_atom_num));;
        if (cdma_wt_dma_arbiter_override_enable)
            SendWeightDmaReadRequestRTL(dma_wmb_rd_req_payload_, CDMA_WMB_DATA, dma_delay_);
        else
            SendWeightDmaReadRequest(dma_wmb_rd_req_payload_, CDMA_WMB_DATA, dma_delay_);
        // Increase
        payload_addr += payload_size;
    }

    // Layer end. Align wmb_byte_idx_planed_ to 128Bytes.
    wmb_byte_idx_planed_ += ((wmb_byte_idx_planed_ % NVDLA_CBUF_BANK_WIDTH) == 0) ? 0 : (NVDLA_CBUF_BANK_WIDTH - wmb_byte_idx_planed_ % NVDLA_CBUF_BANK_WIDTH);
    cslInfo(("NV_NVDLA_cdma::ConvWMBRequestSequencerCommon, end\n"));
}

void NV_NVDLA_cdma::ConvWMBResponseSequencerCommon() {
    uint8_t  proc_precision;

    // Temp variables
    uint8_t  element_size;
    uint32_t super_normal_ratio;
    uint32_t super_atom_size;
    uint32_t super_atom_per_cbuf_entry;
    uint32_t weight_kernel, weight_kernel_left;
    uint32_t current_kernel_per_group;
    double   kernel_group_wmb_size;
    uint8_t  *read_data_ptr;
    uint8_t  *cdma2cbuf_payload_data_ptr;
    uint64_t wmb_bytes_fetched;
    double   prev_wmb_bytes_fetched;
    uint64_t wmb_total_bytes;
    int32_t  kg_fetched_wmb_entries;

    proc_precision      = cdma_proc_precision_;
    wmb_total_bytes     = cdma_wmb_bytes_ << NVDLA_CDMA_D_WMB_BYTES_0_WMB_BYTES_SHIFT;
    weight_kernel       = cdma_weight_kernel_ + 1;
    weight_kernel_left  = weight_kernel;
    switch (proc_precision) {
        case DATA_FORMAT_INT8:
            element_size = ELEMENT_SIZE_INT8;
            break;
        case DATA_FORMAT_INT16:
            element_size = ELEMENT_SIZE_INT16;
            break;
        case DATA_FORMAT_FP16:
            element_size = ELEMENT_SIZE_FP16;
            break;
    }

    int atom_size = NVDLA_MEMORY_ATOMIC_SIZE * element_size;
    super_normal_ratio = min(MEM_BUS_WIDTH / atom_size, NVDLA_MAC_ATOMIC_C_SIZE / NVDLA_MEMORY_ATOMIC_SIZE);
    super_atom_size = atom_size * super_normal_ratio;
    super_atom_per_cbuf_entry = NVDLA_CBUF_BANK_WIDTH / super_atom_size;

    cslInfo(("NV_NVDLA_cdma::ConvWMBResponseSequencerCommon, WMB total size is 0x%lx\n", wmb_total_bytes));
    // Evaluated
    cdma2cbuf_payload_data_ptr = reinterpret_cast <uint8_t *> (cdma2buf_wmb_wr_payload.data);

    wmb_bytes_fetched = 0;
    prev_wmb_bytes_fetched = 0;
    wmb_entries_fetched_ = 0;
    prev_wmb_entries_fetched_ = 0;
    cdma2buf_wmb_wr_payload.hsel = super_atom_per_cbuf_entry - 1;
    while (wmb_bytes_fetched < wmb_total_bytes) {
        current_kernel_per_group = (weight_kernel_left < NVDLA_MAC_ATOMIC_K_SIZE) ? weight_kernel_left : NVDLA_MAC_ATOMIC_K_SIZE;
		// In unit of byte. The result is double type because we need to use accuracy of bit
        kernel_group_wmb_size = current_kernel_per_group * (cdma_byte_per_kernel_ + 1) * 1.0 / element_size / 8.0;

        read_data_ptr = wmb_read_rsp_fifo_->read();
        cslDebug((50, "read from wmb_read_rsp_fifo_\n"));
        memcpy(&cdma2cbuf_payload_data_ptr[wmb_bytes_fetched % super_atom_size], read_data_ptr, atom_size);
        delete [] read_data_ptr;
        // Store to Convolution Buffer (CBUF), Half entry(64Bytes) in each transaction
        wmb_bytes_fetched += atom_size;
        cslDebug((50, "NV_NVDLA_cdma::ConvWMBResponseSequencerCommon, wmb_bytes_fetched=0x%lx\n", wmb_bytes_fetched));
        if (0 == (wmb_bytes_fetched % super_atom_size)) {
            // Data is NVDLA_CBUF_BANK_WIDTH/2 (64 byte) aligned, send half of entry data to CBUF
            cdma2buf_wmb_wr_payload.addr = ((wmb_bytes_fetched - 1) / NVDLA_CBUF_BANK_WIDTH + wmb_entry_idx_working_) % NVDLA_CBUF_BANK_DEPTH + CBUF_WMB_BANK_IDX * NVDLA_CBUF_BANK_DEPTH;
            cdma2buf_wmb_wr_payload.hsel = (cdma2buf_wmb_wr_payload.hsel + 1) % super_atom_per_cbuf_entry;
            cdma2buf_wmb_wr_payload.size = super_atom_size;
            if ((wmb_bytes_fetched % NVDLA_CBUF_BANK_WIDTH) == 0) {
                wmb_entries_fetched_++;
            }

            cslDebug((50, "NV_NVDLA_cdma::ConvWMBResponseSequencerCommon, cdma2buf_wmb_wr_payload.addr is 0x%x\n", cdma2buf_wmb_wr_payload.addr));
            cslDebug((50, "NV_NVDLA_cdma::ConvWMBResponseSequencerCommon, cdma2buf_wmb_wr_payload.hsel is 0x%x\n", uint32_t(cdma2buf_wmb_wr_payload.hsel)));
            cslDebug((70, "NV_NVDLA_cdma::ConvWMBResponseSequencerCommon, cdma2buf_wmb_wr_payload.data are :\n"));
#if LOG_DETAIL
            for (uint32_t idx = 0; idx < sizeof(cdma2buf_wmb_wr_payload.data) / sizeof(cdma2buf_wmb_wr_payload.data[0]); idx++) {
                cslDebug((90, " 0x%016lx\n", cdma2buf_wmb_wr_payload.data[idx]));
            }
#endif
            cdma2buf_wt_wr_b_transport (&cdma2buf_wmb_wr_payload, b_transport_delay_);

            if (0 == (wmb_bytes_fetched % NVDLA_CBUF_BANK_WIDTH)) {
                while ((weight_kernel_left > 0) && (wmb_bytes_fetched - prev_wmb_bytes_fetched) >= kernel_group_wmb_size) { // WMB size of a kernel group may be less than 128B.
                    kg_fetched_wmb_entries = wmb_entries_fetched_ - prev_wmb_entries_fetched_;
                    cslDebug((50, "Write to wmb2sc_up_fifo_. wmb_entries_fetched_=0x%x prev_wmb_bytes_fetched=%f kg_fetched_wmb_entries=0x%x\n", wmb_entries_fetched_, prev_wmb_bytes_fetched, kg_fetched_wmb_entries));
                    wmb2sc_up_fifo_->write(kg_fetched_wmb_entries);
                    cslDebug((50, "Write to wmb2sc_up_fifo done\n"));
                    prev_wmb_bytes_fetched += kernel_group_wmb_size;
                    prev_wmb_entries_fetched_ = wmb_entries_fetched_;
                    weight_kernel_left -= current_kernel_per_group;

                    current_kernel_per_group = (weight_kernel_left < NVDLA_MAC_ATOMIC_K_SIZE) ? weight_kernel_left : NVDLA_MAC_ATOMIC_K_SIZE;
                    // In unit of byte. The result is double type because we need to use accuracy of bit
                    kernel_group_wmb_size = current_kernel_per_group * (cdma_byte_per_kernel_ + 1) * 1.0 / element_size / 8.0;
                }
            }
        }
    }
    if ((uint32_t)wmb_entries_fetched_ != (wmb_total_bytes / NVDLA_CBUF_BANK_WIDTH))
        FAIL(("The total size of weight should be multiple of NVDLA_CBUF_BANK_WIDTH\n"));
}

void NV_NVDLA_cdma::DirectConvWeightRequestSequencerCommon(){
    // Config variables, they have corresponding value in registers
    uint32_t weight_total_bytes;
    uint32_t byte_per_kernel;
    uint64_t base_addr;
    uint32_t proc_precision;
    uint32_t weight_kernel;

    // Temp variables
    uint64_t payload_addr;
    uint32_t payload_size;
    uint32_t payload_atom_num;
    uint32_t weight_bytes_fetched;
    uint32_t prev_weight_bytes_fetched;
    uint32_t current_kernel_per_group;
    uint32_t weight_kernel_left;
    uint32_t kernel_group_idx;
    bool     end_of_current_kernel_group;
    int32_t  wt_required_entries_num;
    uint32_t atom_size;

    // Copy from register value to local config variables, similar with RTL connection
    base_addr           = (uint64_t(cdma_weight_addr_high_) << 32) + uint64_t(cdma_weight_addr_low_);
    weight_total_bytes  = cdma_weight_bytes_ << NVDLA_CDMA_D_WEIGHT_BYTES_0_WEIGHT_BYTES_SHIFT;
    byte_per_kernel     = cdma_byte_per_kernel_ + 1;
    weight_kernel       = cdma_weight_kernel_ + 1;
    proc_precision      = cdma_proc_precision_;
    cslInfo(("NV_NVDLA_cdma::DirectConvWeightRequestSequencerCommon, weight_total_bytes is 0x%x\n", weight_total_bytes));

    switch (proc_precision) {
        case DATA_FORMAT_INT8:
            atom_size = ATOM_SIZE_INT8;
            break;
        case DATA_FORMAT_INT16:
            atom_size = ATOM_SIZE_INT16;
            break;
        case DATA_FORMAT_FP16:
            atom_size = ATOM_SIZE_FP16;
            break;
        default:
            FAIL(("NV_NVDLA_cdma::DirectConvWeightRequestSequencerCommon, invalid precision setting."));
    }

    wt_required_entries_num = (weight_total_bytes + NVDLA_CBUF_BANK_WIDTH - 1) / NVDLA_CBUF_BANK_WIDTH;
    if ((wt_required_entries_num > (cdma_weight_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH) && cdma_skip_weight_rls_) {
        FAIL (("NV_NVDLA_cdma::DirectConvWeightRequestSequencerCommon, invalid config, The total weight size is larger than cdma_weight_bank_*NVDLA_CBUF_BANK_WIDTH, but cdma_skip_weight_rls_ is true."));
    }
    if (0==weight_total_bytes)
        FAIL(("weight_total_bytes should be larger than 0\n"));

    weight_kernel_left      = weight_kernel;
    weight_bytes_fetched    = 0;
    prev_weight_bytes_fetched = 0;
    kernel_group_idx        = 0;
    payload_addr            = base_addr;
//    if ((NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED == cdma_weight_format_) && !cdma_wt_dma_arbiter_override_enable) {   // SCVE environment
//        // wait until wmb finish reading a kernel group and writing to cbuf
//        cslDebug((70, "before read wmb2wt_kg_sync_fifo_\n"));
//        wmb2wt_kg_sync_fifo_->read();
//        cslDebug((70, "after read wmb2wt_kg_sync_fifo_\n"));
//    }

    uint32_t max_mem_transaction_size = MAX_MEM_TRANSACTION_NUM * DLA_ATOM_SIZE;

    while (weight_bytes_fetched < weight_total_bytes) {
        current_kernel_per_group = (weight_kernel_left < NVDLA_MAC_ATOMIC_K_SIZE) ? weight_kernel_left : NVDLA_MAC_ATOMIC_K_SIZE;
        // Calculate payload size, payload transaction must be within a 256 byte
        payload_size        = max_mem_transaction_size - payload_addr % max_mem_transaction_size;
        // Payload transaction shall not larger than rest of atom cube number
        payload_atom_num    = min((weight_total_bytes - weight_bytes_fetched + atom_size - 1) / atom_size, payload_size / atom_size);
        payload_size        = payload_atom_num * atom_size;
        // Prepare payload
        dma_wt_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr;
        dma_wt_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num-1;
        weight_bytes_fetched  += payload_size;
#if 0
        weight_byte_idx_planed_ += payload_size;
        weight_entry_idx_planed_ = (weight_byte_idx_planed_ - 1) / NVDLA_CBUF_BANK_WIDTH;
        cslDebug((50, "WaitUntilCBufferHasEnoughFreeWeightEntry start. weight_bytes_fetched=0x%x weight_byte_idx_planed_=0x%x\n", weight_bytes_fetched, weight_byte_idx_planed_));
        WaitUntilCBufferHasEnoughFreeWeightEntry();
        cslDebug((50, "WaitUntilCBufferHasEnoughFreeWeightEntry end\n"));
#endif
        // Send read request to RDMA
        cslDebug((50, "SendWeightDmaReadRequest payload_addr=0x%16lx payload_size=0x%x\n", payload_addr, payload_size));;
        if (cdma_wt_dma_arbiter_override_enable)
            SendWeightDmaReadRequestRTL(dma_wt_rd_req_payload_, CDMA_WEIGHT_DATA, dma_delay_);
        else
            SendWeightDmaReadRequest(dma_wt_rd_req_payload_, CDMA_WEIGHT_DATA, dma_delay_);
        payload_addr += payload_size;

        end_of_current_kernel_group = (NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED == cdma_weight_format_)? ((weight_bytes_fetched - prev_weight_bytes_fetched) >= wgs_buffer_[kernel_group_idx]):
                                       ((weight_bytes_fetched - prev_weight_bytes_fetched) >= current_kernel_per_group * byte_per_kernel);

        // Finished reading weight of one kernel group
        if ((weight_bytes_fetched >= weight_total_bytes) || end_of_current_kernel_group) {
//            if ( (weight_bytes_fetched < weight_total_bytes) && // There are still weight to read
//                (NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED == cdma_weight_format_) && !cdma_wt_dma_arbiter_override_enable) {
//                // In SCVE environment: wait until wmb finish reading a kernel group and writing to cbuf
//                cslDebug((70, "before read wmb2wt_kg_sync_fifo_\n"));
//                wmb2wt_kg_sync_fifo_->read();
//                cslDebug((70, "after read wmb2wt_kg_sync_fifo_\n"));
//            }
            weight_kernel_left -= current_kernel_per_group;
            prev_weight_bytes_fetched = weight_bytes_fetched;
            kernel_group_idx++;
        }
    }

    cslInfo(("NV_NVDLA_cdma::DirectConvWeightRequestSequencerCommon, end\n"));
}

void NV_NVDLA_cdma::DirectConvWeightResponseSequencerCommon() {
    // Config variables, they have corresponding value in registers
    uint32_t weight_total_bytes;
    uint32_t weight_entry_addr_start, weight_entry_addr_aperture;
    uint32_t byte_per_kernel;
    uint32_t proc_precision;
    uint32_t weight_kernel;
    //bool     flush_nan2zero;

    // # Iterators
    uint32_t idx;

    // # Evaluated variables
     int32_t atom_size;
    uint32_t super_atom_size;
    uint32_t super_normal_ratio;
    uint32_t super_atom_per_cbuf_entry;
    uint32_t current_kernel_per_group;
    uint32_t weight_kernel_left;

    // Temp variables
    uint8_t *read_data_ptr;
    uint8_t *cdma2cbuf_payload_data_ptr;
    uint64_t weight_bytes_fetched;
    uint64_t weight_bytes_fetched_prev;
    uint32_t kernel_group_idx;
    uint32_t wt_entries_fetched, prev_wt_entries_fetched;
    bool    wt_up_cdma2sc_en;

    // Copy from register value to local config variables, similar with RTL connection
    weight_entry_addr_start     = (cdma_data_bank_+1) * NVDLA_CBUF_BANK_DEPTH;
    weight_entry_addr_aperture  = (cdma_weight_bank_+1) * NVDLA_CBUF_BANK_DEPTH;
    byte_per_kernel             = cdma_byte_per_kernel_ + 1;
    weight_total_bytes          = cdma_weight_bytes_ << NVDLA_CDMA_D_WEIGHT_BYTES_0_WEIGHT_BYTES_SHIFT;
    proc_precision              = cdma_proc_precision_;
    weight_kernel               = cdma_weight_kernel_ + 1;
    //flush_nan2zero              = cdma_nan_to_zero_;

    // Evaluated
    cdma2cbuf_payload_data_ptr      = reinterpret_cast <uint8_t *> (cdma2buf_wt_wr_payload.data);   //the data size in payload is 128Bytes
    switch (proc_precision) {
        case DATA_FORMAT_INT8:
            atom_size = ATOM_SIZE_INT8;
            break;
        case DATA_FORMAT_INT16:
            atom_size = ATOM_SIZE_INT16;
            break;
        case DATA_FORMAT_FP16:
            atom_size = ATOM_SIZE_FP16;
            break;
        default:
            FAIL(("NV_NVDLA_cdma::DirectConvWeightResponseSequencerCommon, invalid precision setting."));
    }

    super_normal_ratio = min(MEM_BUS_WIDTH / atom_size, NVDLA_MAC_ATOMIC_C_SIZE / NVDLA_MEMORY_ATOMIC_SIZE);
    super_atom_size = atom_size * super_normal_ratio;
    super_atom_per_cbuf_entry = NVDLA_CBUF_BANK_WIDTH / super_atom_size;

    weight_kernel_left = weight_kernel;
    kernel_group_idx   = 0;

    weight_bytes_fetched = 0;
    weight_bytes_fetched_prev = 0;
    wt_entries_fetched = 0;
    prev_wt_entries_fetched = 0;

    cdma2buf_wt_wr_payload.hsel = super_atom_per_cbuf_entry - 1;

    while (weight_bytes_fetched < weight_total_bytes) {
        read_data_ptr = weight_read_rsp_fifo_->read();
        cslDebug((50, "read from weight_read_rsp_fifo_\n"));
        memcpy(&cdma2cbuf_payload_data_ptr[weight_bytes_fetched % super_atom_size], read_data_ptr, atom_size);
        delete [] read_data_ptr;

        // Store a half entry(64B) to Convolution Buffer (CBUF)
        weight_bytes_fetched += atom_size;
        //cslDebug((50, "NV_NVDLA_cdma::DirectConvWeightResponseSequencerCommon. weight_bytes_fetched=0x%lx\n", weight_bytes_fetched));
        weight_byte_idx_planed_ += atom_size;
        weight_entry_idx_planed_ = (weight_byte_idx_planed_ - 1) / NVDLA_CBUF_BANK_WIDTH;
        cslDebug((50, "WaitUntilCBufferHasEnoughFreeWeightEntry start. weight_bytes_fetched=0x%x weight_byte_idx_planed_=0x%x\n", weight_bytes_fetched, weight_byte_idx_planed_));
        WaitUntilCBufferHasEnoughFreeWeightEntry();
        cslDebug((50, "WaitUntilCBufferHasEnoughFreeWeightEntry end\n"));

        if (0 == (weight_bytes_fetched % super_atom_size)) {
            cdma2buf_wt_wr_payload.addr = ((weight_bytes_fetched - 1) / NVDLA_CBUF_BANK_WIDTH + weight_entry_idx_working_) % weight_entry_addr_aperture + weight_entry_addr_start;
            cdma2buf_wt_wr_payload.hsel = (cdma2buf_wt_wr_payload.hsel + 1) % super_atom_per_cbuf_entry;
            cdma2buf_wt_wr_payload.size = super_atom_size;
            if ((weight_bytes_fetched % NVDLA_CBUF_BANK_WIDTH) == 0) {
                wt_entries_fetched++;
            }
            // No NaN and Inf in Weight. But still count them to match RTL.
            if (DATA_FORMAT_FP16 == proc_precision) {
                for (idx = 0; idx < super_atom_size / 2; idx++) {
                    uint16_t tmp_fp16 = ((uint16_t)cdma2cbuf_payload_data_ptr[2 * idx + 1]) << 8 | cdma2cbuf_payload_data_ptr[2 * idx];
                    if(isNaN(tmp_fp16)){
                        weight_nan_num_perlayer_++;
                    }
                    if(isInf(tmp_fp16)) {
                        weight_inf_num_perlayer_++;
                    }
                }
            }

            cslDebug((50, "NV_NVDLA_cdma::DirectConvWeightResponseSequencerCommon, cdma2buf_wt_wr_payload.addr is 0x%x\n", cdma2buf_wt_wr_payload.addr));
            cslDebug((50, "NV_NVDLA_cdma::DirectConvWeightResponseSequencerCommon, cdma2buf_wt_wr_payload.hsel is 0x%x\n", uint32_t(cdma2buf_wt_wr_payload.hsel)));
            cslDebug((70, "NV_NVDLA_cdma::DirectConvWeightResponseSequencerCommon, cdma2buf_wt_wr_payload.data are :\n"));
#if LOG_DETAIL
            for (idx = 0; idx < sizeof(cdma2buf_wt_wr_payload.data)/sizeof(uint8_t); idx++) { // Should loop 128 times. Type of cdma2buf_wt_wr_payload.data is uint64_t.
                cslDebug((90, "0x%02x ", cdma2cbuf_payload_data_ptr[idx]));
            }
            cslDebug((90, "\n"));
#endif
            cdma2buf_wt_wr_b_transport (&cdma2buf_wt_wr_payload, b_transport_delay_);

            // It's possible that weight_bytes_fetched < weight_total_bytes, but all kernels are fetched already.
            // In such case, weight_total_bytes is rounded to 12B. And we need to read over-fetched atoms from weight_read_rsp_fifo_, But no need to read wgs_buffer_
            if (0==weight_kernel_left)
                continue;

            if (0 == (weight_bytes_fetched % NVDLA_CBUF_BANK_WIDTH)) {
                while ((weight_kernel_left > 0) && (weight_bytes_fetched > weight_bytes_fetched_prev)) { // Update entry usage info for each kernel group
                    current_kernel_per_group = (weight_kernel_left < NVDLA_MAC_ATOMIC_K_SIZE) ? weight_kernel_left : NVDLA_MAC_ATOMIC_K_SIZE;
                    cslDebug((70, "NV_NVDLA_cdma::DirectConvWeightResponseSequencerCommon current_kernel_per_group =%d\n", current_kernel_per_group));
                    if (cdma_weight_format_ == NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_UNCOMPRESSED)
                        wt_up_cdma2sc_en = ((weight_bytes_fetched - weight_bytes_fetched_prev) >= current_kernel_per_group * byte_per_kernel);
                    else
                        wt_up_cdma2sc_en = ((weight_bytes_fetched - weight_bytes_fetched_prev) >= wgs_buffer_[kernel_group_idx]);

                    if (wt_up_cdma2sc_en) {
                        cslInfo(("NV_NVDLA_cdma::DirectConvWeightResponseSequencerCommon, wt_up_cdma2sc_en is true\n"));
                        int32_t kg_wt_kernels    =  current_kernel_per_group;
                        int32_t kg_wt_entries    =  wt_entries_fetched - prev_wt_entries_fetched;
                        wt2sc_up_kernel_fifo_->write(kg_wt_kernels);
                        wt2sc_up_entry_fifo_->write(kg_wt_entries);

                        if (cdma_weight_format_ == NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_COMPRESSED)
                            cslDebug((70, "cdma: weight_bytes_fetched=0x%lx weight_bytes_fetched_prev=0x%lx wgs_buffer_[%d]=0x%x\n", weight_bytes_fetched, weight_bytes_fetched_prev, kernel_group_idx, wgs_buffer_[kernel_group_idx]));
                        else
                            cslDebug((70, "cdma: weight_bytes_fetched=0x%lx weight_bytes_fetched_prev=0x%lx\n", weight_bytes_fetched, weight_bytes_fetched_prev ));
                        cslDebug((70, "cdma: kg_wt_kernels=0x%x kg_wt_entries=0x%x wt_entries_fetched=0x%x prev_wt_entries_fetched=0x%x\n", kg_wt_kernels, kg_wt_entries, wt_entries_fetched, prev_wt_entries_fetched));

                        weight_bytes_fetched_prev += (cdma_weight_format_ == NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_UNCOMPRESSED)?
                                                     (current_kernel_per_group * byte_per_kernel): wgs_buffer_[kernel_group_idx];  // Align to the size of one kernel group
                        prev_wt_entries_fetched    = wt_entries_fetched;

                        weight_kernel_left -= current_kernel_per_group;
                        kernel_group_idx++;
                    }
                    else
                        break;
                }
            }
        }
    }
    cslInfo(("End of DirectConvWeightResponseSequencerCommon: weight_bytes_fetched=0x%lx wt_entries_fetched=0x%x\n", weight_bytes_fetched, wt_entries_fetched));;

    // All weight fetch is done, but some wgs may be not fetched yet
    while ( true ) {
        if (0 == weight_kernel_left)
            break;
        if (!cdma_wt_dma_arbiter_override_enable || (cdma_weight_format_ == NVDLA_CDMA_D_WEIGHT_FORMAT_0_WEIGHT_FORMAT_UNCOMPRESSED))
            FAIL(("If weight uncompressed, all cdma2sc_wt should have been sent\n"));

        cslDebug((70, "before wait wgs2wt_update_\n"));
        wait(wgs2wt_update_);
        cslDebug((70, "after wait wgs2wt_update_\n"));
        while ((weight_kernel_left > 0) && (weight_bytes_fetched > weight_bytes_fetched_prev)) { // Update entry usage info for each kernel group
            current_kernel_per_group = (weight_kernel_left < NVDLA_MAC_ATOMIC_K_SIZE) ? weight_kernel_left : NVDLA_MAC_ATOMIC_K_SIZE;
            cslDebug((70, "NV_NVDLA_cdma::DirectConvWeightResponseSequencerCommon current_kernel_per_group =%d\n", current_kernel_per_group));
            wt_up_cdma2sc_en = ((weight_bytes_fetched - weight_bytes_fetched_prev) >= wgs_buffer_[kernel_group_idx]);

            if (wt_up_cdma2sc_en) {
                cslInfo(("NV_NVDLA_cdma::DirectConvWeightResponseSequencerCommon, wt_up_cdma2sc_en is true\n"));
                int32_t kg_wt_kernels    =  current_kernel_per_group;
                int32_t kg_wt_entries    =  wt_entries_fetched - prev_wt_entries_fetched;
                wt2sc_up_kernel_fifo_->write(kg_wt_kernels);
                wt2sc_up_entry_fifo_->write(kg_wt_entries);

                cslDebug((70, "cdma: weight_bytes_fetched=0x%lx weight_bytes_fetched_prev=0x%lx wgs_buffer_[%d]=0x%x\n", weight_bytes_fetched, weight_bytes_fetched_prev, kernel_group_idx, wgs_buffer_[kernel_group_idx]));
                cslDebug((70, "cdma: kg_wt_kernels=0x%x kg_wt_entries=0x%x wt_entries_fetched=0x%x prev_wt_entries_fetched=0x%x\n", kg_wt_kernels, kg_wt_entries, wt_entries_fetched, prev_wt_entries_fetched));

                weight_bytes_fetched_prev += wgs_buffer_[kernel_group_idx];  // Align to the size of one kernel group
                prev_wt_entries_fetched    = wt_entries_fetched;

                weight_kernel_left -= current_kernel_per_group;
                kernel_group_idx++;
            }
            else
                break;
        }
    }

    if (wt_entries_fetched != (weight_total_bytes / NVDLA_CBUF_BANK_WIDTH))
        FAIL(("The total size of weight should be multiple of NVDLA_CBUF_BANK_WIDTH\n"));
}

void NV_NVDLA_cdma::ImageConvDataRequestSequencerCommon() {
    // Config variables, they have corresponding value in registers
    uint32_t cube_width, cube_height;
    uint32_t pixel_x_offset;
    uint32_t pad_left;
    uint32_t pixel_format;
    bool     pitch_linear;
    uint8_t  precision;
    uint32_t line_stride;
    uint32_t uv_line_stride;
    uint32_t cube_in_channel;
    uint32_t cbuf_entry_per_line;
    // # Iterators
    uint32_t height_iter;
    // Temp variables
    uint64_t payload_addr;
    uint32_t payload_size;
    uint32_t payload_atom_num;
    uint32_t planar_num;
    uint32_t bytes_per_pixel_p0, bytes_per_pixel_p1;
    uint32_t element_size;
    uint32_t atom_size;
    uint32_t bytes_per_pixel;
    uint32_t p0_pad_left_main, p0_pad_left_tail, p0_x_offset_byte, p0_line_st_minus;
    uint32_t planar0_to_fetch_bytes, p0_line_st, planar0_bytes_fetched;
    uint32_t p1_pad_left_main, p1_pad_left_tail, p1_x_offset_byte, p1_line_st_minus;
    uint32_t planar1_to_fetch_bytes, p1_line_st, planar1_bytes_fetched;

    uint64_t planar0_base_addr;
    uint64_t planar1_base_addr;

    // Copy from register value to local config variables, similar with RTL connection
    cube_width          = cdma_datain_width_ + 1;
    cube_height         = cdma_datain_height_ + 1;
    line_stride         = cdma_line_stride_;
    uv_line_stride      = cdma_uv_line_stride_;
    cube_in_channel     = cdma_datain_channel_ + 1;
    cbuf_entry_per_line = cdma_entries_ + 1;

    planar0_base_addr   = (uint64_t(cdma_datain_addr_high_0_) << 32) + uint64_t(cdma_datain_addr_low_0_);
    planar1_base_addr   = (uint64_t(cdma_datain_addr_high_1_) << 32) + uint64_t(cdma_datain_addr_low_1_);
    precision           = cdma_in_precision_;
    pixel_x_offset      = cdma_pixel_x_offset_;
    pad_left            = cdma_pad_left_;
    pixel_format        = cdma_pixel_format_;
    pitch_linear        = cdma_pixel_mapping_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_MAPPING_PITCH_LINEAR;

    planar_num          = cdma_planar_num(pixel_format);
    bytes_per_pixel     = cdma_bytes_per_pixel(pixel_format);
    bytes_per_pixel_p0 = (planar_num == 1) ? bytes_per_pixel : cdma_bytes_per_pixel_planar0(pixel_format);
    bytes_per_pixel_p1  = cdma_bytes_per_pixel_planar1(pixel_format);

    // packed_format is a special case and element_size is used for calculating p0_line_st_minus. For semi-planar cases, there is no packed format available.
    element_size        = packed_format(pixel_format) ? 1 : (DATA_FORMAT_INT8 == precision) ? ELEMENT_SIZE_INT8 : ELEMENT_SIZE_INT16;
    atom_size           = NVDLA_MEMORY_ATOMIC_SIZE * element_size;

if (1 == planar_num) {
        p0_pad_left_main = int(pad_left * cube_in_channel * element_size / atom_size);
        p0_pad_left_tail = (pad_left * cube_in_channel * element_size) % atom_size;
        p0_x_offset_byte = pixel_x_offset * cube_in_channel * element_size;
        p0_line_st_minus = (p0_pad_left_tail > p0_x_offset_byte) ? p0_pad_left_main + 1 : p0_pad_left_main;
    } else {
        p0_pad_left_main = int(pad_left * element_size / atom_size);
        p0_pad_left_tail = (pad_left * element_size) % atom_size;
        p0_x_offset_byte = pixel_x_offset * element_size;
        p0_line_st_minus = (p0_pad_left_tail > p0_x_offset_byte) ? p0_pad_left_main + 1 : p0_pad_left_main;

        p1_pad_left_main = int(pad_left * 2 * element_size / atom_size);
        p1_pad_left_tail = (pad_left * 2 * element_size) % atom_size;
        p1_x_offset_byte = (pixel_x_offset * 2 * element_size) % atom_size;
        p1_line_st_minus = (p1_pad_left_tail > p1_x_offset_byte) ? p1_pad_left_main + 1 : p1_pad_left_main;
    }

    if (pitch_linear) {
        planar0_to_fetch_bytes = (pixel_x_offset + cube_width) * bytes_per_pixel_p0;
        planar1_to_fetch_bytes = ((pixel_x_offset * bytes_per_pixel_p1) % atom_size) + cube_width * bytes_per_pixel_p1;
        if (planar0_to_fetch_bytes > line_stride)
            FAIL(("Incorrect configuration on line_stride in pitch_linear. line_stride=0x%x planar0_to_fetch_bytes=0x%x\n", line_stride, planar0_to_fetch_bytes));
        if ((2 == planar_num) && (planar1_to_fetch_bytes > uv_line_stride))
            FAIL(("Incorrect configuration on uv_line_stride in pitch_linear. uv_line_stride=0x%x planar1_to_fetch_bytes=0x%x\n", uv_line_stride, planar1_to_fetch_bytes));

        p0_line_st = 9 - p0_line_st_minus;          //For pitch linear, unit is burst
        p1_line_st = 17 - p1_line_st_minus;         //for pitch linear, unit is burst 
        for (height_iter=0; height_iter<cube_height; height_iter++) {       // read data line by line
            planar0_bytes_fetched = planar1_bytes_fetched = 0;
            data_entry_idx_planed_ += cbuf_entry_per_line;
            WaitUntilCBufferHasEnoughFreeDataEntry();
            cslDebug((50, "pitch linear, planar0_to_fetch_bytes=0x%x planar1_to_fetch_bytes=0x%x height_iter=0x%x\n", planar0_to_fetch_bytes, planar1_to_fetch_bytes, height_iter));
            while ((planar0_bytes_fetched < planar0_to_fetch_bytes) || ((2 == planar_num) && (planar1_bytes_fetched < planar1_to_fetch_bytes))) {
                // Send one read transaction for planar0
                if (planar0_bytes_fetched < planar0_to_fetch_bytes) {
                    if (planar0_bytes_fetched == 0)
                        payload_size = min((p0_line_st * atom_size), planar0_to_fetch_bytes);
                    else
                        payload_size = min(int(planar0_to_fetch_bytes - planar0_bytes_fetched), MAX_MEM_TRANSACTION_NUM * DLA_ATOM_SIZE);
                    payload_atom_num = (payload_size + atom_size - 1) / atom_size;
                    cslDebug((50, "Pitch Linear Request: planar0_bytes_fetched=0x%x payload_size=0x%x payload_atom_num=0x%x\n", planar0_bytes_fetched, payload_size, payload_atom_num));
                    payload_size = payload_atom_num * atom_size;
                    payload_addr = planar0_base_addr + height_iter * line_stride + planar0_bytes_fetched;
                    dma_act_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr;
                    dma_act_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num - 1;
                    SendActDmaReadRequest(dma_act_rd_req_payload_, CDMA_FEATURE_DATA, dma_delay_);
                    planar0_bytes_fetched += payload_size;
                }

                // Send one read transaction for planar1
                if ((2 == planar_num) && planar1_bytes_fetched < planar1_to_fetch_bytes) {
                    if(planar1_bytes_fetched==0)
                        payload_size = min((p1_line_st * atom_size), planar1_to_fetch_bytes);
                    else
                        payload_size = min(int(planar1_to_fetch_bytes - planar1_bytes_fetched), MAX_MEM_TRANSACTION_NUM * DLA_ATOM_SIZE * 2);
                    payload_atom_num = (payload_size + atom_size - 1) / atom_size;
                    payload_size = payload_atom_num * atom_size;
                    cslDebug((50, "Pitch Linear Request: planar1_bytes_fetched=0x%x payload_size=0x%x payload_atom_num=0x%x\n", planar1_bytes_fetched, payload_size, payload_atom_num));
                    payload_addr = planar1_base_addr + height_iter * uv_line_stride + planar1_bytes_fetched;
                    dma_act_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr;
                    dma_act_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num - 1;
                    SendActDmaReadRequest(dma_act_rd_req_payload_, CDMA_FEATURE_DATA, dma_delay_);
                    planar1_bytes_fetched += payload_size;
                }
            }
        }
    }
    //data_entry_idx_planed_ += cbuf_entry_per_line * cube_height;
}

void NV_NVDLA_cdma::ImageConvDataResponseSequencerCommon() {
    // Config variables, they have corresponding value in registers
    uint32_t cube_width, cube_height;
    uint32_t cbuf_entry_per_line;
    uint32_t pixel_x_offset;
    uint32_t pad_left;
    uint32_t pad_right;
    uint32_t precision;
    uint32_t proc_precision;
    uint16_t pad_value;
    int16_t  cvt_offset;
    int16_t  cvt_scale;
    uint8_t  cvt_truncate;
    bool     cvt_en;
    uint32_t cube_in_channel;
    uint8_t  mean_format;
    bool     flush_nan2zero;
    // # Iterators
    uint32_t height_iter;
    // Temp variables
    bool     convert_8to16;
    bool     convert_16to8;
    uint32_t pixel_format;
    bool     pitch_linear;
    uint8_t  element_num;
    uint32_t cbuf_entry_addr;
    uint32_t received_atoms;
    uint32_t planar_num;
    uint32_t payload_size;
    uint32_t payload_atom_num;
    uint32_t left_line_bytes;
    uint32_t curr_cbuf_entry_size;
    uint8_t  pad_value_8;
    uint16_t pad_value_16;
    uint8_t* read_data_ptr;
    uint32_t i;
    uint32_t bytes_per_pixel, bytes_per_pixel_p0, bytes_per_pixel_p1, converted_bytes_per_pixel;
    uint32_t element_size;
    uint32_t atom_size;
    uint32_t super_atom_size;
    uint32_t super_normal_ratio;
    uint32_t p0_pad_left_main, p0_pad_left_tail, p0_x_offset_byte, p0_line_st_minus;
    uint32_t p0_line_st;
    uint32_t p1_pad_left_main, p1_pad_left_tail, p1_x_offset_byte, p1_line_st_minus;
    uint32_t p1_line_st;

    uint8_t** pitch_buffer;
    uint8_t** pad_buffer;
    uint8_t to_cbuf[NVDLA_CBUF_BANK_WIDTH];
    uint8_t zero_array[NVDLA_CBUF_BANK_WIDTH] = { 0 };

    precision           = cdma_in_precision_;
    proc_precision      = cdma_proc_precision_;
    mean_format         = cdma_mean_format_;
    cvt_en              = cdma_cvt_en_;

    convert_8to16       = cvt_en &&
                          (cdma_in_precision_ == NVDLA_CDMA_D_MISC_CFG_0_IN_PRECISION_INT8) &&
                          ((cdma_proc_precision_ == NVDLA_CDMA_D_MISC_CFG_0_PROC_PRECISION_INT16) || (cdma_proc_precision_ == NVDLA_CDMA_D_MISC_CFG_0_PROC_PRECISION_FP16));
    convert_16to8       = cvt_en &&
                          (cdma_in_precision_ == NVDLA_CDMA_D_MISC_CFG_0_IN_PRECISION_INT16) &&
                          (cdma_proc_precision_ == NVDLA_CDMA_D_MISC_CFG_0_PROC_PRECISION_INT8);

    flush_nan2zero      = cdma_nan_to_zero_;

    // Copy from register value to local config variables, similar with RTL connection
    cube_width          = cdma_datain_width_ + 1;
    cube_height         = cdma_datain_height_ + 1;
    cube_in_channel     = cdma_datain_channel_ + 1;
    pitch_linear        = cdma_pixel_mapping_ == NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_MAPPING_PITCH_LINEAR;

    cbuf_entry_per_line = cdma_entries_ + 1;
    pixel_x_offset      = cdma_pixel_x_offset_;
    pad_left            = cdma_pad_left_;
    pad_right           = cdma_pad_right_;
    pixel_format        = cdma_pixel_format_;
    cvt_offset          = cdma_cvt_offset_;
    cvt_scale           = cdma_cvt_scale_;
    cvt_truncate        = cdma_cvt_truncate_;
    planar_num          = cdma_planar_num(pixel_format);
    bytes_per_pixel     = cdma_bytes_per_pixel(pixel_format);
    bytes_per_pixel_p0  = (planar_num == 1) ? bytes_per_pixel : cdma_bytes_per_pixel_planar0(pixel_format);
    bytes_per_pixel_p1  = cdma_bytes_per_pixel_planar1(pixel_format);
    element_num         = cdma_element_num(pixel_format);
    if (cvt_en && (precision!=proc_precision))
        converted_bytes_per_pixel = cdma_converted_bytes_per_pixel(pixel_format, proc_precision);
    else
        converted_bytes_per_pixel = packed_format(pixel_format) ? 8 : bytes_per_pixel;
    // packed_format is a special case and element_size is used for calculating p0_line_st_minus. For semi-planar cases, there is no packed format available.
    element_size = packed_format(pixel_format) ? 1 : (DATA_FORMAT_INT8 == precision) ? ELEMENT_SIZE_INT8 : ELEMENT_SIZE_INT16;
    atom_size = NVDLA_MEMORY_ATOMIC_SIZE * element_size;
    super_normal_ratio = min(MEM_BUS_WIDTH / (int)atom_size, NVDLA_MAC_ATOMIC_C_SIZE / NVDLA_MEMORY_ATOMIC_SIZE);
    super_atom_size = atom_size * super_normal_ratio;

    pad_value           = cdma_pad_value_;
    pad_value_8         = cdma_pad_value_ & 0xff;  // Low 8bits
    pad_value_16        = pad_value;

    if (1 == planar_num) {
        p0_pad_left_main = int(pad_left * cube_in_channel * element_size / atom_size);
        p0_pad_left_tail = (pad_left * cube_in_channel * element_size) % atom_size;
        p0_x_offset_byte = pixel_x_offset * cube_in_channel * element_size;
        p0_line_st_minus = (p0_pad_left_tail > p0_x_offset_byte) ? p0_pad_left_main + 1 : p0_pad_left_main;
    } else {
        p0_pad_left_main = int(pad_left * element_size / atom_size);
        p0_pad_left_tail = (pad_left * element_size) % atom_size;
        p0_x_offset_byte = pixel_x_offset * element_size;
        p0_line_st_minus = (p0_pad_left_tail > p0_x_offset_byte) ? p0_pad_left_main + 1 : p0_pad_left_main;

        p1_pad_left_main = int(pad_left * 2 * element_size / atom_size);
        p1_pad_left_tail = (pad_left * 2 * element_size) % atom_size;
        p1_x_offset_byte = (pixel_x_offset * 2 * element_size) % atom_size;
        p1_line_st_minus = (p1_pad_left_tail > p1_x_offset_byte) ? p1_pad_left_main + 1 : p1_pad_left_main;
    }

    cslInfo(("p0_pad_left_main=%d p0_pad_left_tail=%d p0_x_offset_byte=%d p0_line_st_minus=%d\n", p0_pad_left_main, p0_pad_left_tail, p0_x_offset_byte, p0_line_st_minus));

    // The cube after conversion and with left and right padding
    uint32_t pad_line_bytes = (pad_left + cube_width + pad_right) * converted_bytes_per_pixel;
    pad_buffer   = new uint8_t *[cube_height];
    for (i=0; i < cube_height; i++) {
        pad_buffer[i] = new uint8_t[pad_line_bytes + atom_size];
    }

    if (pitch_linear) {
        // The pixel_x_offset of planar0 and planar1 may be different. p1_pixel_x_offset is for planar1
        //p1_pixel_x_offset = p1_x_offset_byte / (2*element_size);

        uint32_t planar0_to_fetch_bytes = (pixel_x_offset + cube_width) * bytes_per_pixel_p0;
        uint32_t planar1_to_fetch_bytes = ((pixel_x_offset * bytes_per_pixel_p1) % atom_size) + cube_width * bytes_per_pixel_p1;
        uint32_t pitch_line_bytes_rounded = ((pixel_x_offset + cube_width) * bytes_per_pixel + atom_size - 1) / atom_size * atom_size;
        p0_line_st = 9 - p0_line_st_minus;          //For pitch linear, unit is burst
        p1_line_st = 17 - p1_line_st_minus;         //for pitch linear, unit is burst 
        pitch_buffer = new uint8_t *[cube_height];  //pitch_buffer contains all pixels in x_offset range
        for (height_iter=0; height_iter < cube_height; height_iter++) {
            pitch_buffer[height_iter] = new uint8_t[pitch_line_bytes_rounded + 32 * bytes_per_pixel * 2];
            memset(pitch_buffer[height_iter], 0, pitch_line_bytes_rounded + 32 * bytes_per_pixel * 2);
        }

        for (height_iter = 0; height_iter < cube_height; height_iter++) {     // read data line by line and assemble into pitch_buffer
            uint32_t planar0_bytes_fetched = 0;
            uint32_t planar1_bytes_fetched = 0;
            uint32_t planar0_pixel_idx = 0;
            uint32_t planar1_pixel_idx;
            if ((pixel_x_offset * 2 * element_size) >= atom_size)
                planar1_pixel_idx = atom_size / (2 * element_size);
            else
                planar1_pixel_idx = 0;
            cslDebug((50, "pitch linear, planar0_to_fetch_bytes=0x%x planar1_to_fetch_bytes=0x%x height_iter=0x%x planar1_pixel_idx=%d\n", planar0_to_fetch_bytes, planar1_to_fetch_bytes, height_iter, planar1_pixel_idx));

            // One read transaction for planar0
            while ((planar0_bytes_fetched < planar0_to_fetch_bytes) || ((2==planar_num) && (planar1_bytes_fetched < planar1_to_fetch_bytes))) {
                // One read transaction for planar0
                if (planar0_bytes_fetched < planar0_to_fetch_bytes) {
                    if(planar0_bytes_fetched==0)
                        payload_size = min((p0_line_st * atom_size), planar0_to_fetch_bytes);
                    else
                        payload_size = min(int(planar0_to_fetch_bytes - planar0_bytes_fetched), MAX_MEM_TRANSACTION_NUM * DLA_ATOM_SIZE);
                    payload_atom_num = (payload_size + atom_size - 1) / atom_size;
                    cslDebug((50, "Pitch Linear Request: planar0_bytes_fetched=0x%x payload_size=0x%x payload_atom_num=0x%x\n", planar0_bytes_fetched, payload_size, payload_atom_num));
                    // Get atoms from read port
                    received_atoms = 0;
                    while (received_atoms < payload_atom_num) {
                        read_data_ptr = act_data_read_rsp_fifo_->read();
                        for (i = 0; i < atom_size;) {
                            if (planar0_pixel_idx >= (pixel_x_offset + cube_width))  // If not break, memcpy may access beyond the size of pitch_buffer[i], because the number of fetched pixel may be larger than the expected.
                                break;                                              // The minimal size of a fetch is a 32B atom which may contains redundant data.
                            memcpy(&pitch_buffer[height_iter][planar0_pixel_idx * bytes_per_pixel] , &read_data_ptr[i], bytes_per_pixel_p0);
                            i += bytes_per_pixel_p0;
                            planar0_pixel_idx++;
                        }
                        delete [] read_data_ptr;
                        received_atoms++;
                    }
                    planar0_bytes_fetched += payload_atom_num * atom_size;
                }

                // One read transaction for planar1
                if ((2 == planar_num) && (planar1_bytes_fetched < planar1_to_fetch_bytes)) {
                    // One read transaction for planar0
                    if(planar1_bytes_fetched==0)
                        payload_size = min((p1_line_st * atom_size), planar1_to_fetch_bytes);
                    else
                        payload_size = min(int(planar1_to_fetch_bytes - planar1_bytes_fetched), MAX_MEM_TRANSACTION_NUM * DLA_ATOM_SIZE * 2);
                    payload_atom_num = (payload_size + atom_size - 1) / atom_size;
                    // Get atoms from read port
                    received_atoms = 0;
                    cslDebug((50, "Pitch Linear Request: planar1_bytes_fetched=0x%x payload_size=0x%x payload_atom_num=0x%x\n", planar1_bytes_fetched, payload_size, payload_atom_num));
                    while (received_atoms < payload_atom_num) {
                        read_data_ptr = act_data_read_rsp_fifo_->read();
                        for (i = 0; i < atom_size;) {
                            if (planar1_pixel_idx >= (pixel_x_offset + cube_width))  // If not break, memcpy may access beyond the size of pitch_buffer[i], because the number of fetched pixel may be larger than the expected.
                                break;                                              // The minimal size of a fetch is a 32B atom which may contains redundant data.
                            memcpy(&pitch_buffer[height_iter][planar1_pixel_idx * bytes_per_pixel+bytes_per_pixel_p0], &read_data_ptr[i], bytes_per_pixel_p1);
                            i += bytes_per_pixel_p1;
                            planar1_pixel_idx++;
                        }
                        delete [] read_data_ptr;
                        received_atoms++;
                    }
                    planar1_bytes_fetched += payload_atom_num * atom_size;
                }
            }
        }
        cslInfo(("ImageConvDataResponseSequencerCommon pitch_linear fetched to pitch_buffer\n"));

        // Flush NaN to zero
        //if (flush_nan2zero&&(DATA_FORMAT_FP16 == precision)) {
        if (DATA_FORMAT_FP16 == precision) {
            for (height_iter=0; height_iter<cube_height; height_iter++) {     // read data line by line and assemble into pad_buffer
                uint32_t element_iter = pixel_x_offset * bytes_per_pixel / element_size; // The NaN and Inf in pixel_x_offset range are not counted.
                while (element_iter < pitch_line_bytes_rounded / element_size) {
                    uint16_t tmp_fp16 = ((uint16_t)pitch_buffer[height_iter][2 * element_iter + 1]) << 8 | pitch_buffer[height_iter][2 * element_iter];
                    if(isNaN(tmp_fp16)){
                        data_nan_num_perlayer_++;
                        if (flush_nan2zero)
                            pitch_buffer[height_iter][2 * element_iter] = pitch_buffer[height_iter][2 * element_iter + 1] = 0; //stepheng,20170329
                    }
                    if(isInf(tmp_fp16)) {
                        data_inf_num_perlayer_++;
                    }
                    element_iter++;
                }
            }
        }
    }   // end of pitch_linear

    cslInfo(("pad_value_8=0x%x pad_value_16=0x%x\n", pad_value_8, pad_value_16));
    cslInfo(("pad_left=0x%x pad_right=0x%x pixel_format=0x%x element_num=%d\n", pad_left, pad_right, pixel_format, element_num));
    
    // Perform conversion and append padding values
    for (height_iter = 0; height_iter < cube_height; height_iter++) {     // read data line by line and assemble into pad_buffer
        uint32_t  i, element_idx;
        uint32_t  ori_pixel_idx = 0;
        uint32_t  pixel_idx = 0;
        uint8_t   input_data_type;
        uint8_t  *fetch_buffer_8;
        uint16_t *fetch_buffer_16;
        uint32_t *fetch_buffer_32;
        if (pitch_linear) {
            fetch_buffer_8  = (uint8_t*)pitch_buffer[height_iter];
            fetch_buffer_16 = (uint16_t*)pitch_buffer[height_iter];
            fetch_buffer_32 = (uint32_t*)pitch_buffer[height_iter];
        }
        uint8_t  *pad_buffer_8  = (uint8_t*)pad_buffer[height_iter];
        uint16_t *pad_buffer_16 = (uint16_t*)pad_buffer[height_iter];
        cslDebug((70, "height_iter=0x%x of fetch_buffer:\n", height_iter));
#if 0
        for(i=0;i<512;i++)
            cslDebug((70, " 0x%02x ", fetch_buffer_8[i]));
        cslDebug((70, "\n"));
#endif
        // Fill left padding values
        for (pixel_idx = 0; pixel_idx < pad_left; pixel_idx++) {    // pad_left is in pixel, not byte
            for (element_idx = 0; element_idx < element_num; element_idx++) {
                if (DATA_FORMAT_INT8 == proc_precision)
                    memcpy(&pad_buffer_8[pixel_idx * element_num + element_idx], &pad_value_8, sizeof(uint8_t));
                else
                    memcpy(&pad_buffer_16[pixel_idx * element_num + element_idx], &pad_value_16, sizeof(uint16_t));
            }
        }

        uint32_t max_garbage_pixel = (atom_size / element_size) / element_num;

        while (pixel_idx < pad_left + cube_width + pad_right + max_garbage_pixel) {
            int8_t  pixel_8, rgba_idx;
            int16_t pixel_16;
            int32_t pixel_32;
            int16_t cvt_mean;
            ori_pixel_idx = pixel_idx - pad_left + pixel_x_offset;
            switch (pixel_format) {
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8:
                    pixel_8 = fetch_buffer_8[ori_pixel_idx];
                    cslDebug((70, "bytes_per_pixel=0x%x ori_pixel_idx=0x%x i=%d pixel_8=0x%x\n", bytes_per_pixel, ori_pixel_idx, i, pixel_8));
                    if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                        cvt_mean = cdma_mean_ry_;    // For INT8, still use 16bits mean (signed)
                    else
                        cvt_mean = cvt_offset;
                    if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                    process_one_element_8(pixel_8, pixel_idx, element_num, 0, cvt_en, convert_8to16, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R10:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R12:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16:
                    pixel_16  = fetch_buffer_16[ori_pixel_idx];
                    // cslDebug((70, "bytes_per_pixel=0x%x ori_pixel_idx=0x%x i=%d pixel_8=0x%x\n", bytes_per_pixel, ori_pixel_idx, i, pixel_8));
                    if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                        cvt_mean = cdma_mean_ry_;
                    else
                        cvt_mean = cvt_offset;
                    if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                    process_one_element_16(pixel_16, pixel_idx, element_num, 0, PIXEL_UNSIGNED_INT16, cvt_en, convert_16to8, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16_I:
                    pixel_16  = fetch_buffer_16[ori_pixel_idx];
                    if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                        cvt_mean = cdma_mean_ry_;
                    else
                        cvt_mean = cvt_offset;
                    if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                    process_one_element_16(pixel_16, pixel_idx, element_num, 0, PIXEL_SIGNED_INT16, cvt_en, convert_16to8, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16_F:
                    pixel_16  = fetch_buffer_16[ori_pixel_idx];
                    if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                        cvt_mean = cdma_mean_ry_;
                    else
                        cvt_mean = cvt_offset;
                    if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                    process_one_element_16(pixel_16, pixel_idx, element_num, 0, PIXEL_FP16, cvt_en, convert_16to8, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16B16G16R16:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X16B16G16R16:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16B16G16R16_F:
                    for (i = 0; i < 4; i++) {
                        rgba_idx = i;
                        pixel_16 = fetch_buffer_16[ori_pixel_idx * element_num + rgba_idx]; // Perfrom reorder. Store to CBUF in the order of RGBA
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ : 
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_; 
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        input_data_type = (pixel_format==NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16B16G16R16_F)? PIXEL_FP16: PIXEL_UNSIGNED_INT16;
                        process_one_element_16(pixel_16, pixel_idx, element_num, i, input_data_type, cvt_en, convert_16to8, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16Y16U16V16:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16Y16U16V16_F:
                    for (i = 0; i < 4; i++) {
                        rgba_idx = (i == 0) ? 2 : (i == 1) ? 1 : (i == 2) ? 0 : 3;
                        pixel_16 = fetch_buffer_16[ori_pixel_idx * element_num + rgba_idx]; // Perfrom reorder. Store to CBUF in the order of RGBA
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        input_data_type = (pixel_format==NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16Y16U16V16_F)? PIXEL_FP16: PIXEL_SIGNED_INT16;
                        process_one_element_16(pixel_16, pixel_idx, element_num, i, input_data_type, cvt_en, convert_16to8, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V16U16Y16A16:
                    for (i = 0; i < 4; i++) {
                        rgba_idx = (i + 1) % 4;
                        pixel_16 = fetch_buffer_16[ori_pixel_idx * element_num + rgba_idx]; // Perfrom reorder. Store to CBUF in the order of RGBA
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        process_one_element_16(pixel_16, pixel_idx, element_num, i, PIXEL_UNSIGNED_INT16, cvt_en, convert_16to8, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8B8G8R8:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X8B8G8R8:
                    for (i = 0; i < 4; i++) {
                        rgba_idx = i;
                        pixel_8 = fetch_buffer_8[ori_pixel_idx * element_num + rgba_idx]; // Perfrom reorder. Store to CBUF in the order of RGBA
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        process_one_element_8(pixel_8, pixel_idx, element_num, i, cvt_en, convert_8to16, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8R8G8B8:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X8R8G8B8:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8Y8U8V8:
                    for (i = 0; i < 4; i++) {
                        rgba_idx = (i==0)? 2: (i==1)? 1: (i==2)? 0: 3;
                        pixel_8 = fetch_buffer_8[ori_pixel_idx * element_num + rgba_idx]; // Perfrom reorder. Store to CBUF in the order of RGBA
                        //cslDebug((70, "bytes_per_pixel=0x%x ori_pixel_idx=0x%x i=%d pixel_8=0x%x\n", bytes_per_pixel, ori_pixel_idx, i, pixel_8));
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        process_one_element_8(pixel_8, pixel_idx, element_num, i, cvt_en, convert_8to16, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B8G8R8A8:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B8G8R8X8:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V8U8Y8A8:
                    for (i = 0; i < 4; i++) {
                        rgba_idx = (i + 1) % 4;
                        pixel_8 = fetch_buffer_8[ori_pixel_idx * element_num + rgba_idx]; // Perfrom reorder. Store to CBUF in the order of RGBA
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        process_one_element_8(pixel_8, pixel_idx, element_num, i, cvt_en, convert_8to16, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8G8B8A8:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8G8B8X8:
                    for (i = 0; i < 4; i++) {
                        rgba_idx = 3 - i;
                        pixel_8 = fetch_buffer_8[ori_pixel_idx * element_num + rgba_idx]; // Perfrom reorder. Store to CBUF in the order of RGBA
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        process_one_element_8(pixel_8, pixel_idx, element_num, i, cvt_en, convert_8to16, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2B10G10R10:
                    for (i = 0; i < 4; i++) {
                        pixel_32 = fetch_buffer_32[ori_pixel_idx];
                        switch(i) {
                            case 0: //R
                                pixel_16  = (pixel_32 & 0x3ff) << 6;
                                break;
                            case 1: //G
                                pixel_16  = ((pixel_32>>10) & 0x3ff) << 6;
                                break;
                            case 2: //B
                                pixel_16  = ((pixel_32>>20) & 0x3ff) << 6;
                                break;
                            case 3: //A
                                pixel_16  = (pixel_32>>30) << 14;
                                break;
                        }
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        process_one_element_16(pixel_16, pixel_idx, element_num, i, PIXEL_UNSIGNED_INT16, cvt_en, convert_16to8, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2R10G10B10:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2Y10U10V10:
                    for (i = 0; i < 4; i++) {
                        pixel_32 = fetch_buffer_32[ori_pixel_idx];
                        switch(i) {
                            case 0: //R
                                pixel_16  = ((pixel_32>>20) & 0x3ff) << 6;
                                break;
                            case 1: //G
                                pixel_16  = ((pixel_32>>10) & 0x3ff) << 6;
                                break;
                            case 2: //B
                                pixel_16  = (pixel_32 & 0x3ff) << 6;
                                break;
                            case 3: //A
                                pixel_16  = (pixel_32>>30) << 14;
                                break;
                        }
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        process_one_element_16(pixel_16, pixel_idx, element_num, i, PIXEL_UNSIGNED_INT16, cvt_en, convert_16to8, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B10G10R10A2:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V10U10Y10A2:
                    for (i = 0; i < 4; i++) {
                        pixel_32 = fetch_buffer_32[ori_pixel_idx];
                        switch(i) {
                            case 0: //R
                                pixel_16  = ((pixel_32>>2) & 0x3ff) << 6;
                                break;
                            case 1: //G
                                pixel_16  = ((pixel_32>>12) & 0x3ff) << 6;
                                break;
                            case 2: //B
                                pixel_16  = ((pixel_32>>22) & 0x3ff) << 6;
                                break;
                            case 3: //A
                                pixel_16  = (pixel_32&0x3) << 14;
                                break;
                        }
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        process_one_element_16(pixel_16, pixel_idx, element_num, i, PIXEL_UNSIGNED_INT16, cvt_en, convert_16to8, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R10G10B10A2:
                    for (i = 0; i < 4; i++) {
                        pixel_32 = fetch_buffer_32[ori_pixel_idx];
                        switch(i) {
                            case 0: //R
                                pixel_16  = ((pixel_32>>22) & 0x3ff) << 6;
                                break;
                            case 1: //G
                                pixel_16  = ((pixel_32>>12) & 0x3ff) << 6;
                                break;
                            case 2: //B
                                pixel_16  = ((pixel_32>>2) & 0x3ff) << 6;
                                break;
                            case 3: //A
                                pixel_16 = (pixel_32 & 0x3) << 14;
                                break;
                        }
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        process_one_element_16(pixel_16, pixel_idx, element_num, i, PIXEL_UNSIGNED_INT16, cvt_en, convert_16to8, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___U8V8_N444:
                    for (i = 0; i < 3; i++) {
                        rgba_idx = (i == 0) ? 0 : (i == 1) ? 2 : 1;
                        pixel_8 = fetch_buffer_8[ori_pixel_idx * element_num + rgba_idx]; // Perfrom reorder. Store to CBUF in the order of RGBA
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        process_one_element_8(pixel_8, pixel_idx, element_num, i, cvt_en, convert_8to16, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___V8U8_N444:
                    for (i = 0; i < 3; i++) {
                        rgba_idx = i;
                        pixel_8  = fetch_buffer_8[ori_pixel_idx * element_num+rgba_idx]; // Perfrom reorder. Store to CBUF in the order of RGBA
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        process_one_element_8(pixel_8, pixel_idx, element_num, i, cvt_en, convert_8to16, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___U10V10_N444:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___U12V12_N444:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___U16V16_N444:
                    for (i = 0; i < 3; i++) {
                        rgba_idx = (i == 0) ? 0 : (i == 1) ? 2 : 1;
                        pixel_16 = fetch_buffer_16[ori_pixel_idx * element_num + rgba_idx]; // Perfrom reorder. Store to CBUF in the order of RGBA
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        process_one_element_16(pixel_16, pixel_idx, element_num, i, PIXEL_UNSIGNED_INT16, cvt_en, convert_16to8, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___V10U10_N444:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___V12U12_N444:
                case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___V16U16_N444:
                    for (i = 0; i < 3; i++) {
                        rgba_idx = i;
                        pixel_16 = fetch_buffer_16[ori_pixel_idx * element_num + rgba_idx]; // Perfrom reorder. Store to CBUF in the order of RGBA
                        if (NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format)
                            cvt_mean = (i == 0) ? cdma_mean_ry_ :
                            (i == 1) ? cdma_mean_gu_ : 
                            (i == 2) ? cdma_mean_bv_ : cdma_mean_ax_;
                        else
                            cvt_mean = cvt_offset;
                        if(pixel_idx >= pad_left + cube_width + pad_right && NVDLA_CDMA_D_MEAN_FORMAT_0_MEAN_FORMAT_ENABLE == mean_format) cvt_mean = 0;
                        process_one_element_16(pixel_16, pixel_idx, element_num, i, PIXEL_UNSIGNED_INT16, cvt_en, convert_16to8, pad_buffer_8, pad_buffer_16, cvt_mean, cvt_scale, cvt_truncate, precision, proc_precision);
                    }
                    break;
                default:
                    FAIL(("Unexpected pixel format %d", pixel_format));
            }
            pixel_idx++;
        }
        // Fill right padding values
        for (pixel_idx -= pad_right + max_garbage_pixel; pixel_idx < pad_left + cube_width + pad_right; pixel_idx++) {    // pad_left is in pixel, not byte
            for (element_idx = 0; element_idx < element_num; element_idx++) {
                if (DATA_FORMAT_INT8 == proc_precision)
                    memcpy(&pad_buffer_8[pixel_idx * element_num + element_idx], &pad_value_8, sizeof(uint8_t));
                else
                    memcpy(&pad_buffer_16[pixel_idx * element_num + element_idx], &pad_value_16, sizeof(uint16_t));
            }
        }
    }
    cslInfo(("ImageConvDataResponseSequencerCommon converted and saved to pad_buffer\n"));

    // Write all image data to cbuf (not include pad_top and pad_bottom)
    cbuf_entry_addr = data_entry_idx_working_ % ((cdma_data_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH);
    for (height_iter = 0; height_iter < cube_height; height_iter++) {
        cslDebug((70, "Writing image data to cbuf height_iter=%d\n", height_iter));
#if 0
        cslDebug((70, " pad_buffer[%d]:\n", height_iter));
        for(i=0;i<512;i++)
            cslDebug((70, " 0x%02x ", pad_buffer[height_iter][i]));
        cslDebug((70, "\n"));
#endif

        uint32_t write_line_bytes = 0;
        uint32_t total_line_bytes = ((pad_line_bytes + atom_size - 1) / atom_size) * atom_size;
        while (write_line_bytes < total_line_bytes) {
            left_line_bytes = total_line_bytes - write_line_bytes;
            curr_cbuf_entry_size = min((uint32_t)NVDLA_CBUF_BANK_WIDTH, left_line_bytes);
            cslDebug((70, "total_line_bytes=%d, left_line_bytes=%d\n", total_line_bytes, left_line_bytes));
            if (curr_cbuf_entry_size == NVDLA_CBUF_BANK_WIDTH)
                memcpy(to_cbuf, &pad_buffer[height_iter][write_line_bytes], NVDLA_CBUF_BANK_WIDTH);
            else {
                memcpy(to_cbuf, &pad_buffer[height_iter][write_line_bytes], curr_cbuf_entry_size);
                memcpy(&to_cbuf[curr_cbuf_entry_size], zero_array, NVDLA_CBUF_BANK_WIDTH - curr_cbuf_entry_size);
            }
            // Write one entry to CBUF
            uint32_t curr_super_atom_num = (curr_cbuf_entry_size + super_atom_size - 1) / super_atom_size;
            WriteOneEntryToCbuf(to_cbuf, cbuf_entry_addr, super_atom_size, curr_super_atom_num);
            cbuf_entry_addr = (cbuf_entry_addr + 1) % ((cdma_data_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH);
            write_line_bytes += curr_cbuf_entry_size;
        }
    }
    cslInfo(("ImageConvDataResponseSequencerCommon All image data are written into CBUF\n"));

    for (i=0; i < cube_height; i++) {
        delete [] pad_buffer[i];
    }
    delete [] pad_buffer;
    if (pitch_linear) {
        for (i=0; i < cube_height; i++) {
            delete [] pitch_buffer[i];
        }
        delete [] pitch_buffer;
    } 
    // Update CBUF availiable data status to csc
    // We update the info only once for the entire data cube
    slice_idx_available_ += 1;
    data2sc_data_update_payload_->dat_entries = cbuf_entry_per_line * cube_height;
    data2sc_data_update_payload_->dat_slices  = cube_height;
    dat_up_cdma2sc_b_transport(data2sc_data_update_payload_, b_transport_delay_);
    cslInfo(("ImageConvDataRequestSequencerCommon. dat_up_cdma2sc: dat_entries=0x%x dat_slices=0x%x\n", data2sc_data_update_payload_->dat_entries, data2sc_data_update_payload_->dat_slices));
}

void NV_NVDLA_cdma::WinoConvDataRequestSequencerCommon() {
    // Config variables, they have corresponding value in registers
    uint32_t cube_width, cube_height, cube_channel;
    uint32_t line_stride, surface_stride;
    uint32_t precision;
    uint64_t base_addr;
    uint32_t pad_top, pad_bottom;
    uint32_t conv_y_stride;
    uint32_t element_size;
    uint32_t atom_size;
    // # Iterators
    uint32_t width_iter;
    uint32_t height_iter;
    uint32_t super_height_iter;
    uint32_t surface_iter;
    uint32_t stride_y_iter;
    // Evaluated variablas
    uint32_t surface_num;
    int      i;
    // Temp variables
    uint64_t payload_addr;
    uint32_t payload_atom_num;
    uint32_t total_height;
    uint32_t part_4_sy_height;
    uint32_t super_height_num;


    // Copy from register value to local config variables, similar with RTL connection
    cube_width          = cdma_datain_width_ + 1;
    cube_height         = cdma_datain_height_ + 1;
    cube_channel        = cdma_datain_channel_ + 1;
    line_stride         = cdma_line_stride_;
    surface_stride      = cdma_surf_stride_;
    precision           = cdma_in_precision_;
    pad_top             = cdma_pad_top_;
    pad_bottom          = cdma_pad_bottom_;
    conv_y_stride       = cdma_conv_y_stride_ + 1;
    base_addr           = (uint64_t(cdma_datain_addr_high_0_) << 32) + uint64_t(cdma_datain_addr_low_0_);
    element_size        = (DATA_FORMAT_INT8 == precision) ? ELEMENT_SIZE_INT8 : ELEMENT_SIZE_INT16;
    atom_size           = NVDLA_MEMORY_ATOMIC_SIZE * element_size;

    //super_slice_num         = (cube_height+fetch_slice_grain-1)/fetch_slice_grain;
    surface_num = (cube_channel + NVDLA_MEMORY_ATOMIC_SIZE - 1) / NVDLA_MEMORY_ATOMIC_SIZE;
    // data_entry_num          = (cdma_data_bank_+1) * NVDLA_CBUF_BANK_DEPTH;
    //fetch_slice_grain_last  = cube_height - fetch_slice_grain*(super_slice_num-1);

    // slice_idx_sequence_control_mutex_[cdma_consumer_].lock();
    slice_idx_available_ = 0;

    total_height = pad_top + cube_height + pad_bottom;
    part_4_sy_height = 4 * conv_y_stride;
    super_height_num = total_height / part_4_sy_height;
#pragma CTC SKIP
    if (total_height % part_4_sy_height != 0) {
        FAIL(("NV_NVDLA_cdma::WinoConvDataRequestSequencerCommon, invalid config on padding and conv_y_stride."));
    }
    cslDebug((70, "WxHxC=%dx%dx%d, SX*SY=%dx%d, pad: topxbottomxleftxright=%dx%dx%dx%d, precision:%d\n", cube_width, cube_height, cube_channel,
                cdma_conv_x_stride_+1, conv_y_stride, pad_top, pad_bottom,
                cdma_pad_left_, cdma_pad_right_, precision));
#pragma CTC ENDSKIP

    // In H direction, loop stride is 4*conv_y_stride.
    for (super_height_iter = 0; super_height_iter < super_height_num; super_height_iter++) {
        // In C direction, loop stride is 32Bytes (an atom)
        data_entry_idx_planed_ += ((cdma_entries_ + 1)) * 4;
        WaitUntilCBufferHasEnoughFreeDataEntry();
        // We need to sync between wino req and resp threads to make sure resp thread not overide valid data of previous layer in cbuf
        // The resp thread may write to cbuf with only pad value and not read act_data_read_rsp_fifo_
        wino_req2resp_sync_fifo_->write(1);
        for (surface_iter = 0; surface_iter < surface_num; surface_iter++) {
            // In H direction, loop stride is 4 lines
            for (stride_y_iter = 0; stride_y_iter < conv_y_stride; stride_y_iter++) {
                // In W direction, loop stride is 8 atoms
                for (width_iter = 0; width_iter < cube_width; width_iter += MAX_MEM_TRANSACTION_NUM) { // The left pad and right pad are not fetched. The last transaction may be less than 8 atoms.
                    // Fetch 4 8*32B sub cubes
                    for (i = 0; i < 4; i++) {  // 4 rows
                        height_iter = super_height_iter * part_4_sy_height + i * conv_y_stride + stride_y_iter - pad_top;
                        if ((height_iter < 0) || (height_iter >= cube_height)) {
                            // do nothing, not fetch data for padding
                        }
                        else {
                            // payload_addr doesn't have to be aligned to 256Bytes
                            payload_addr = base_addr + surface_iter * surface_stride + height_iter * line_stride + width_iter * atom_size;
#pragma CTC SKIP
                            cslDebug((30, "base_addr:0x%lx, super_height_iter:%d, surface_iter:%d, stride_y_iter:%d, width_iter:%d, i:%d, height_iter:%d\n",
                                        base_addr, super_height_iter, surface_iter, stride_y_iter, width_iter, i, height_iter));
#pragma CTC ENDSKIP
                            payload_atom_num = min((uint32_t)MAX_MEM_TRANSACTION_NUM, cube_width - width_iter);
                            // Prepare payload
                            dma_act_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr;
                            dma_act_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num - 1;
                            // Send read request to RDMA
                            SendActDmaReadRequest(dma_act_rd_req_payload_, CDMA_FEATURE_DATA, dma_delay_);
                        }
                        //cslDebug((50, "NV_NVDLA_cdma::WinoConvDataRequestSequencerCommon, super slice iteration\n"));
                        //cslDebug((50, "    data_entry_idx_planed_ is 0x%x\n", data_entry_idx_planed_));
                    }
                }
            }
        }
    }
}

void NV_NVDLA_cdma::WinoConvDataResponseSequencerCommon() {
    // Config variables, they have corresponding value in registers
    uint32_t cube_width, cube_height, cube_channel;
    uint32_t line_stride;//, surface_stride;
    uint32_t precision;
    uint32_t pad_left, pad_right, pad_top, pad_bottom;
    uint32_t conv_x_stride, conv_y_stride;
    uint32_t cube_width_ext;
    bool     flush_nan2zero;
    // # Iterators
    uint32_t width_iter;
    uint32_t surface_iter;
    uint32_t height_iter;
    uint32_t super_height_iter;
    uint32_t stride_y_iter;
    uint32_t cube444_height_iter, cube444_width_iter;
    // # Evaluated variables
    uint32_t surface_num;
    bool     is_line_packed;
    uint32_t cbuf_entry_per_slice;
    uint32_t total_width;
    uint32_t total_height;
    uint32_t coor_width_4x4x4, coor_height_4x4x4, coor_channel_4x4x4;
    uint32_t super_height_num;
    uint32_t part_4_sx_width;
    uint32_t part_4_sy_height;
    uint32_t num_4x4x4_channel;
    uint32_t  i, j, k;
    int32_t  payload_atom_num;
    int32_t  payload_atom_iter;
    uint32_t fetched_width;
    //uint32_t to_fetch_width;
    uint8_t* read_atom_ptr;
    uint16_t pad_value;
    uint8_t* cbuf_payload_data_ptr;
    uint32_t cbuf_entry_addr;
    uint32_t data_entry_num;

    uint16_t atom_pad_value_int16[NVDLA_MEMORY_ATOMIC_SIZE];
     int32_t atom_size;
    uint32_t super_atom_size;
    uint32_t super_normal_ratio;
    uint32_t super_atom_per_cbuf_entry;

    // Temp variables
    uint8_t  read_data_ptr[4][READ_WINO_BUF_WIDTH][NVDLA_MEMORY_ATOMIC_SIZE * ELEMENT_SIZE_INT16];
    uint8_t  cbuf_entry_buffer[NVDLA_CBUF_BANK_WIDTH];

    cube_width          = cdma_datain_width_ + 1;
    cube_height         = cdma_datain_height_ + 1;
    cube_channel        = cdma_datain_channel_ + 1;
    precision           = cdma_in_precision_;
    line_stride         = cdma_line_stride_;
    pad_left            = cdma_pad_left_;
    pad_right           = cdma_pad_right_;
    pad_top             = cdma_pad_top_;
    pad_bottom          = cdma_pad_bottom_;
    pad_value           = cdma_pad_value_;
    conv_y_stride       = cdma_conv_y_stride_ + 1;
    conv_x_stride       = cdma_conv_x_stride_ + 1;
    flush_nan2zero      = cdma_nan_to_zero_;
    data_entry_num      = (cdma_data_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH;
    // Evaluated
    switch (precision) {
        case DATA_FORMAT_INT8:
            for (i = 0; i < 16; i++) {
                atom_pad_value_int16[i] = (pad_value << 8) | (pad_value & 0xFF);
                atom_size = ATOM_SIZE_INT8;
            }
            break;
        case DATA_FORMAT_INT16:
            for (i = 0; i < 16; i++) {
                atom_pad_value_int16[i] = pad_value;
                atom_size = ATOM_SIZE_INT16;
            }
            break;
        case DATA_FORMAT_FP16:
            for (i = 0; i < 16; i++) {
                atom_pad_value_int16[i] = pad_value;
                atom_size = ATOM_SIZE_FP16;
            }
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    }

    surface_num = (cube_channel + NVDLA_MEMORY_ATOMIC_SIZE - 1) / NVDLA_MEMORY_ATOMIC_SIZE;
    uint32_t width_ext = cube_width + pad_left + pad_right;
    uint32_t c_atomics_ext = surface_num * conv_x_stride * conv_y_stride;
    uint32_t atom_per_cbuf_entry = NVDLA_CBUF_BANK_WIDTH / atom_size;
    cbuf_entry_per_slice = ((width_ext / conv_x_stride) * c_atomics_ext) / atom_per_cbuf_entry * 4;

    super_normal_ratio = min(MEM_BUS_WIDTH / atom_size, NVDLA_MAC_ATOMIC_C_SIZE / NVDLA_MEMORY_ATOMIC_SIZE);
    super_atom_size = atom_size * super_normal_ratio;
    super_atom_per_cbuf_entry = NVDLA_CBUF_BANK_WIDTH / super_atom_size;

    cslInfo(("width_ext:%d, c_atoms_ext:%d, surf_num:%d, stride:%dx%d, eps:%d\n", width_ext, c_atomics_ext, surface_num, conv_x_stride, conv_y_stride, cbuf_entry_per_slice));

#pragma CTC SKIP
    if (width_ext % (4 * conv_x_stride) != 0) {
        FAIL(("%s: failed due to width_ext[%d] is not multiple of 4*conv_x_stride[%d]\n",
                    __FUNCTION__,
                    width_ext,
                    conv_x_stride));
    }
    if (uint32_t(cdma_entries_ + 1) != cbuf_entry_per_slice / 4) {
        FAIL(("NV_NVDLA_cdma::DirectConvDataResponseSequencerCommon, invalid configuration cdma_entries_, actual value is 0x%X, it shall be 0x%X.", cdma_entries_, cbuf_entry_per_slice / 4 - 1));
    }
    is_line_packed = cdma_line_packed_;
    if (is_line_packed != (line_stride == atom_size * cube_width)) {
        FAIL(("NV_NVDLA_cdma::DirectConvDataResponseSequencerCommon, invalid configuration cdma_line_packed_, cdma_line_packed_ is %d, line_stride == atom_size * cube_width is %d.", cdma_line_packed_, (line_stride == atom_size * cube_width)));
    }
#pragma CTC ENDSKIP

    // slice_idx_sequence_control_mutex_[cdma_consumer_].lock();
    slice_idx_available_ = 0;

    total_width      = pad_left + cube_width + pad_right;
    total_height     = pad_top + cube_height + pad_bottom;
    part_4_sx_width  = 4 * conv_x_stride;
    part_4_sy_height = 4 * conv_y_stride;
    super_height_num = total_height / part_4_sy_height;
    cube_width_ext   = total_width / conv_x_stride;
#pragma CTC SKIP
    if (total_height % part_4_sy_height != 0) {
        FAIL(("NV_NVDLA_cdma::WinoConvDataResponseSequencerCommon, invalid config on padding and conv_y_stride."));
    }
    if (total_width % part_4_sx_width != 0) {
        FAIL(("NV_NVDLA_cdma::WinoConvDataResponseSequencerCommon, invalid config on padding and conv_x_stride."));
    }
#pragma CTC ENDSKIP
    // Fetch 8*32B sub cubes
    // In H direction, loop stride is 4*conv_y_stride.
    for (super_height_iter = 0; super_height_iter < super_height_num; super_height_iter++) {
        wino_req2resp_sync_fifo_->read();
        // In C direction, loop stride is 32Bytes (an atom)
        for (surface_iter = 0; surface_iter < surface_num; surface_iter++) {
            // In H direction, loop stride is 4 lines
            for (stride_y_iter = 0; stride_y_iter < conv_y_stride; stride_y_iter++) {
                width_iter = 0;
                fetched_width = pad_left;
                cslAssert(wino_fetch_data_fifo_[0]->num_available() == 0);
                while (width_iter < total_width) {
                    // Read data from act_data_read_rsp_fifo_
                    // Make sure that at lease 4*conv_x_stride atoms for each line are fetched.
                    //to_fetch_width = min(conv_x_stride * 4, total_width - fetched_width);
                    while (fetched_width - width_iter < conv_x_stride * 4) {
                        payload_atom_num = min(MAX_MEM_TRANSACTION_NUM, (int)(cube_width - (fetched_width - pad_left)));
                        for (i = 0; i < 4; i++) {  // 4 rows
                            height_iter = super_height_iter * part_4_sy_height + i * conv_y_stride + stride_y_iter;
                            if (!((height_iter < pad_top) || (height_iter >= (pad_top + cube_height)))) {
                                for (payload_atom_iter = 0; payload_atom_iter < payload_atom_num; payload_atom_iter++) {
#pragma CTC SKIP
                                    cslDebug((50, "super_height_iter=0x%x surface_iter=0x%x stride_y_iter=0x%x width_iter=0x%x fetched_width=0x%x\n", 
                                                super_height_iter, surface_iter, stride_y_iter, width_iter, fetched_width));
#pragma CTC ENDSKIP
                                    read_atom_ptr = act_data_read_rsp_fifo_->read();
                                    cslDebug((50, "after read act_data_read_rsp_fifo_\n"));
                                    wino_fetch_data_fifo_[i]->write(read_atom_ptr);
                                }
                            }
                        }
                        fetched_width += payload_atom_num;
                        // no need to fetch padding data
                        if (fetched_width >= cube_width + pad_left) {
#pragma CTC SKIP
                            cslDebug((70, "fetched_width:%d exceed valid data area, set to total_width:%d\n",
                                        fetched_width, total_width));
#pragma CTC ENDSKIP
                            fetched_width = total_width;
                        }
                    }
#pragma CTC SKIP
                    cslDebug((70, "%s prepared width_iter*ATOM*4=%dx32x4 act data, wino_fetch_data_fifo->num_available()=%d, fetched_width:%d, act_data_read_rsp_fifo->free():%d\n",
                                __FUNCTION__,
                                width_iter,
                                wino_fetch_data_fifo_[0]->num_available(),
                                fetched_width,
                                act_data_read_rsp_fifo_->num_free()));
#pragma CTC ENDSKIP

                    // Compose a cube of W=Stride_x*4, H=4, C=32B
                    uint32_t x;
                    for (x = 0; x < 4 * conv_x_stride; x++) {
                        for (i = 0; i < 4; i++) {  // 4 rows
                            height_iter = super_height_iter * part_4_sy_height + i * conv_y_stride + stride_y_iter;
                            if ((height_iter < pad_top) || (height_iter >= (pad_top + cube_height)) ||
                                (width_iter + x < pad_left) || (width_iter + x >= (pad_left + cube_width))) {
                                // Padding value
                                memcpy(read_data_ptr[i][x], atom_pad_value_int16, atom_size);
                            }
                            else {
                                read_atom_ptr = wino_fetch_data_fifo_[i]->read();
                                memcpy(read_data_ptr[i][x], read_atom_ptr, atom_size);
                                delete [] read_atom_ptr;
                            }
                        }
                    }
                    cslDebug((70, "%s: add padding done for width_iter:%d\n", __FUNCTION__, width_iter));
                    // There are (Stride_x*4)*4 atoms in read_data_ptr now
                    // The 4*256B (W=8, H=4, C=32B) will be divided into 8*128B. Each 128B is a cbuf entry.
                    for (i = 0; i < conv_x_stride; i++) {       // Number of stride_x 4x4x4 sub-cubes in width direction
                        uint32_t channel_size_per_cbuf_entry = NVDLA_CBUF_BANK_WIDTH / (4 * 4);
                        uint32_t sub_cube_num_per_atom = atom_size / channel_size_per_cbuf_entry;
                        for (j = 0; j < sub_cube_num_per_atom; j++) {   // Number of 4x4x4 sub-cubes in channel diretion in one atom
                            // Compose a 4x4x4 sub-cube
                            for (cube444_height_iter = 0; cube444_height_iter < 4; cube444_height_iter++) {        // loop on height of 4x4x4 sub-cube
                                for (cube444_width_iter = 0; cube444_width_iter < 4; cube444_width_iter++) {       // loop on width of 4x4x4 sub-cube
                                    uint32_t line_size_per_cbuf_entry = 4 * channel_size_per_cbuf_entry;
                                    memcpy(&cbuf_entry_buffer[cube444_height_iter * line_size_per_cbuf_entry + cube444_width_iter * channel_size_per_cbuf_entry], 
                                           &read_data_ptr[cube444_height_iter][cube444_width_iter * conv_x_stride + i][j * channel_size_per_cbuf_entry], 
                                           channel_size_per_cbuf_entry);
                                }
                            }
                            cslDebug((70, "compose 4x4x4 small cube done for i:%d, j:%d\n", i, j));

                            // Now we have an entire line(128B) in cbuf_entry_buffer to write to cbuf entry
                            // Flush NaN to zero
                            //if (flush_nan2zero&&(DATA_FORMAT_FP16 == precision)) {
                            if (DATA_FORMAT_FP16 == precision) {
                                for (k = 0; k < NVDLA_CBUF_BANK_WIDTH / ELEMENT_SIZE_FP16; k++) {
                                    uint16_t tmp_fp16 = ((uint16_t)cbuf_entry_buffer[2 * k + 1]) << 8 | cbuf_entry_buffer[2 * k];
                                    if(isNaN(tmp_fp16)){
                                        data_nan_num_perlayer_++;
                                        if(flush_nan2zero)
                                            cbuf_entry_buffer[2 * k] = cbuf_entry_buffer[2 * k + 1] = 0;
                                    }
                                    if(isInf(tmp_fp16)) {
                                        data_inf_num_perlayer_++;
                                    }
                                }
                            }
                            // height_4x4x4, width_4x4x4, channel_4x4x4 are the coordinates of the 4x4x4 small cube in the extended input cube
                            coor_height_4x4x4  = super_height_iter;
                            coor_width_4x4x4   = width_iter / part_4_sx_width;
                            coor_channel_4x4x4 = ((stride_y_iter * conv_x_stride + i) * surface_num + surface_iter) * sub_cube_num_per_atom + j;
                            cbuf_entry_addr    = (data_entry_idx_working_ + coor_height_4x4x4 * cbuf_entry_per_slice + coor_channel_4x4x4 * (cube_width_ext / 4) + coor_width_4x4x4) % data_entry_num;
                            num_4x4x4_channel  = surface_num * conv_x_stride * conv_y_stride * 4; // Number of 4x4x4 sub-cubes in channel direction after channel extension
                            cslAssert(cube_width_ext * num_4x4x4_channel == cbuf_entry_per_slice * atom_per_cbuf_entry);

                            cslDebug((50, "NV_NVDLA_cdma::WinoConvDataResponseSequencerCommon\n"));
                            cslDebug((50, "    coor_height_4x4x4          is 0x%x\n", coor_height_4x4x4));
                            cslDebug((50, "    coor_width_4x4x4           is 0x%x\n", coor_width_4x4x4));
                            cslDebug((50, "    coor_channel_4x4x4         is 0x%x\n", coor_channel_4x4x4));
                            cslDebug((50, "    num_4x4x4_channel          is 0x%x\n", num_4x4x4_channel));
                            cslDebug((50, "    cbuf_entry_addr            is 0x%x\n", cbuf_entry_addr));

                            cbuf_payload_data_ptr = reinterpret_cast <uint8_t *> (cdma2cbuf_data_payload_->data);
                            cdma2cbuf_data_payload_->addr = cbuf_entry_addr;
                            cdma2cbuf_data_payload_->size = super_atom_size;
                            
                            for (uint32_t super_atom_iter = 0; super_atom_iter < super_atom_per_cbuf_entry; super_atom_iter++)
                            {
                                cdma2cbuf_data_payload_->hsel = super_atom_iter;
                                memcpy(cbuf_payload_data_ptr, &cbuf_entry_buffer[super_atom_iter * super_atom_size], super_atom_size);
                                cslDebug((70, "cdma2buf_dat_wr_b_transport addr=0x%x hsel=%d\n", cbuf_entry_addr, (unsigned int)(cdma2cbuf_data_payload_->hsel)));
                                cslDebug((70, "data: "));
                                for (uint32_t i = 0; i < super_atom_size; i++)
                                    cslDebug((70, "0x%x ", cbuf_payload_data_ptr[i]));
                                cslDebug((70, "\n"));
                                cdma2buf_dat_wr_b_transport(cdma2cbuf_data_payload_, b_transport_delay_);
                                cslDebug((70, "cdma2buf_dat_wr_b_transport hsel=%d done\n", (unsigned int)(cdma2cbuf_data_payload_->hsel)));
                            }
                        }
                    }
                    width_iter += 4 * conv_x_stride;
#pragma CTC SKIP
                    cslDebug((50, "width_iter:%d, payload_atom_num:%d, num_available:%d\n",
                                width_iter, payload_atom_num, wino_fetch_data_fifo_[0]->num_available()));
#pragma CTC ENDSKIP
                }
            }
        }
        data2sc_data_update_payload_->dat_entries = cbuf_entry_per_slice;
        data2sc_data_update_payload_->dat_slices = 1;
        dat_up_cdma2sc_b_transport(data2sc_data_update_payload_, b_transport_delay_);
        cslDebug((50, "%s. after dat_up_cdma2sc_b_transport. payload->dat_entries=0x%x, payload->dat_slices=0x%x\n", __FUNCTION__, data2sc_data_update_payload_->dat_entries, data2sc_data_update_payload_->dat_slices));
    }
}

// Send Activation data DMA read request
void NV_NVDLA_cdma::SendActDmaReadRequest(nvdla_dma_rd_req_t* payload, uint8_t cdma_source, sc_time& delay) {
    // TODO: push payload_addr for debug purpose. it can be poped when receiving data from mcif/cvif
    cslDebug((50, "NV_NVDLA_cdma::SendActDmaReadRequest, begin. payload_addr=0x%0lx atom_num=0x%x\n", payload->pd.dma_read_cmd.addr, payload->pd.dma_read_cmd.size + 1));
    //cslDebug((50, "Writing cdma_req_source_fifo_ in unit of a dma request (may be not 64bytes)\n"));
    // EFAN: we can't use cdma_req_source_fifo_ here because 
    if (RAM_ID_MC == cdma_datain_ram_type_) {
        NV_NVDLA_cdma_base::cdma_dat2mcif_rd_req_b_transport(payload, dma_delay_);
    } else {
        NV_NVDLA_cdma_base::cdma_dat2cvif_rd_req_b_transport(payload, dma_delay_);
    }
    cslDebug((50, "NV_NVDLA_cdma::SendActDmaReadRequest, end.\n"));
}

// Send weight DMA read request
void NV_NVDLA_cdma::SendWeightDmaReadRequestRTL(nvdla_dma_rd_req_t* payload, uint8_t cdma_source, sc_time& delay) {
    cdma_wt_req_t *cdma_wt_req;
    cslDebug((50, "NV_NVDLA_cdma::SendWeightDmaReadRequestRTL, begin. payload_addr=0x%016lx, cdma_source=%d\n", payload->pd.dma_read_cmd.addr, cdma_source));

    cdma_wt_req = new cdma_wt_req_t();
    memcpy(&(cdma_wt_req->pd), payload, sizeof(nvdla_dma_rd_req_t));
    if (cdma_source == CDMA_WEIGHT_DATA) {
        cdma_wt_req_fifo_->write(cdma_wt_req);
    }
    else if (cdma_source == CDMA_WMB_DATA) {
        cdma_wmb_req_fifo_->write(cdma_wt_req);
    }
    else {
        cdma_wgs_req_fifo_->write(cdma_wt_req);
    }
    cslDebug((50, "NV_NVDLA_cdma::SendWeightDmaReadRequestRTL, end.\n"));
}

// Send weight DMA read request
void NV_NVDLA_cdma::SendWeightDmaReadRequest(nvdla_dma_rd_req_t* payload, uint8_t cdma_source, sc_time& delay) {
    cdma_wt_info_t*     cdma_wt_info;
    cslDebug((50, "NV_NVDLA_cdma::SendWeightDmaReadRequest, begin. cdma_source=%d payload_addr=0x%016lx\n", cdma_source, payload->pd.dma_read_cmd.addr));

    cdma_wt_info = new cdma_wt_info_t();
    cdma_wt_info->cdma_source = cdma_source;
    cdma_wt_info->payload_size = payload->pd.dma_read_cmd.size + 1;
    cdma_wt_info_fifo_->write(cdma_wt_info);

    if (RAM_ID_MC == cdma_weight_ram_type_) {
        NV_NVDLA_cdma_base::cdma_wt2mcif_rd_req_b_transport(payload, dma_delay_);
    } else {
        NV_NVDLA_cdma_base::cdma_wt2cvif_rd_req_b_transport(payload, dma_delay_);
    }
    cslDebug((50, "NV_NVDLA_cdma::SendWeightDmaReadRequest, end.\n"));
}

void NV_NVDLA_cdma::WaitUntilSCDataKickOff() {
    while(true) {
        if(sc_dt_kick_off) {
            cslDebug((50, "NV_NVDLA_cdma::WaitUntilCSCDataKickOff, break\n"));
            sc_dt_kick_off = false;
            break;
        } else {
            cslDebug((50, "NV_NVDLA_cdma::WaitUntilCSCDataKickOff, go to sleep\n"));
            wait(sc_updated_cbuf_usage_data_);
        }
    }
}

void NV_NVDLA_cdma::WaitUntilSCWeightKickOff() {
    while(true) {
        if(sc_wt_kick_off) {
            cslDebug((50, "NV_NVDLA_cdma::WaitUntilCSCWeightKickOff, break\n"));
            sc_wt_kick_off = false;
            break;
        } else {
            cslDebug((50, "NV_NVDLA_cdma::WaitUntilCSCWeightKickOff, go to sleep\n"));
            wait(sc_updated_cbuf_usage_weight_);
        }
    }
}

void NV_NVDLA_cdma::WaitUntilCBufferHasEnoughFreeDataEntry() {
    while (true) {
        if(data_entry_idx_planed_ <= data_entry_idx_free_) {
            break;
        } else {
            cslDebug((50, "NV_NVDLA_cdma::WaitUntilCBufferHasEnoughFreeDataEntry, go to sleep\n"));
            cslDebug((50, "    data_entry_idx_planed_ is 0x%x", data_entry_idx_planed_));
            cslDebug((50, "    data_entry_idx_free_ is 0x%x\n", data_entry_idx_free_));
            wait(sc_updated_cbuf_usage_data_);
        }
    }
}

void NV_NVDLA_cdma::WaitUntilCBufferHasEnoughFreeWmbEntry() {
    while (true) {
        if ( wmb_entry_idx_planed_ <= wmb_entry_idx_free_) {
            cslDebug((50, "NV_NVDLA_cdma::WaitUntilCBufferHasEnoughFreeWmbEntry, break\n"));
            cslDebug((50, "    wmb_entry_idx_planed_ is 0x%x\n", wmb_entry_idx_planed_));
            cslDebug((50, "    wmb_entry_idx_free_ is 0x%x\n", wmb_entry_idx_free_));
            break;
        } else {
            cslDebug((50, "NV_NVDLA_cdma::WaitUntilCBufferHasEnoughFreeWmbEntry, go to sleep\n"));
            cslDebug((50, "    wmb_entry_idx_planed_ is 0x%x\n", wmb_entry_idx_planed_));
            cslDebug((50, "    wmb_entry_idx_free_ is 0x%x\n", wmb_entry_idx_free_));
            wait(sc_updated_cbuf_usage_wmb_);
        }
    }
}

void NV_NVDLA_cdma::WaitUntilCBufferHasEnoughFreeWeightEntry() {
    while (true) {
        if ( weight_entry_idx_planed_ <= weight_entry_idx_free_) {
            cslDebug((50, "NV_NVDLA_cdma::WaitUntilCBufferHasEnoughFreeWeightEntry, break\n"));
            cslDebug((50, "    weight_entry_idx_planed_ is 0x%x\n", weight_entry_idx_planed_));
            cslDebug((50, "    weight_entry_idx_free_ is 0x%x\n", weight_entry_idx_free_));
            break;
        } else {
            cslDebug((50, "NV_NVDLA_cdma::WaitUntilCBufferHasEnoughFreeWeightEntry, go to sleep\n"));
            cslDebug((50, "    weight_entry_idx_planed_ is 0x%x\n", weight_entry_idx_planed_));
            cslDebug((50, "    weight_entry_idx_free_ is 0x%x\n", weight_entry_idx_free_));
            wait(sc_updated_cbuf_usage_weight_);
        }
    }
}

void NV_NVDLA_cdma::WaitUntilDataEntryPlanedIndexEqualEntryFreeIndex() {
    while (true) {
        if ((data_entry_idx_free_ - data_entry_idx_planed_) < ((cdma_req_prev_data_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH)) {
            cslInfo(("NV_NVDLA_cdma::WaitUntilDataEntryPlanedIndexEqualEntryFreeIndex, wait until cbuf data is empty.\n"));
            cslInfo(("data_entry_idx_free_=0x%x data_entry_idx_planed_=0x%x cdma_prev_data_bank_=%d\n", data_entry_idx_free_, data_entry_idx_planed_, cdma_req_prev_data_bank_));
            wait (sc_updated_cbuf_usage_data_);
        } else {
            break;
        }
    }
}

void NV_NVDLA_cdma::WaitUntilWmbEntryPlanedIndexEqualEntryFreeIndex() {
    while (true) {
        if ((wmb_entry_idx_free_ - wmb_entry_idx_planed_) < NVDLA_CBUF_BANK_DEPTH) {
            cslDebug((50, "NV_NVDLA_cdma::WaitUntilWmbEntryPlanedIndexEqualEntryFreeIndex wait until cbuf wmb is empty. wmb_entry_idx_free_=0x%x wmb_entry_idx_planed_=0x%x\n", wmb_entry_idx_free_, wmb_entry_idx_planed_));
            wait (sc_updated_cbuf_usage_wmb_);
        } else {
            cslDebug((50, "NV_NVDLA_cdma::WaitUntilWmbEntryPlanedIndexEqualEntryFreeIndex break. wmb_entry_idx_free_=0x%x wmb_entry_idx_planed_=0x%x\n", wmb_entry_idx_free_, wmb_entry_idx_planed_));
            break;
        }
    }
}

void NV_NVDLA_cdma::WaitUntilWeightEntryPlanedIndexEqualEntryFreeIndex() {
    while (true) {
        if ((weight_entry_idx_free_ - weight_entry_idx_planed_) < ((wt_req_cdma_prev_weight_bank_ + 1) * NVDLA_CBUF_BANK_DEPTH)) {
            cslDebug((50, "NV_NVDLA_cdma::WaitUntilWeightEntryPlanedIndexEqualEntryFreeIndex wait until cbuf weight is empty. weight_entry_idx_free_=0x%x weight_entry_idx_planed_=0x%x wt_req_cdma_prev_weight_bank_=%d\n", weight_entry_idx_free_, weight_entry_idx_planed_, wt_req_cdma_prev_weight_bank_));
            wait (sc_updated_cbuf_usage_weight_);
        } else {
            cslDebug((50, "NV_NVDLA_cdma::WaitUntilWeightEntryPlanedIndexEqualEntryFreeIndex break. weight_entry_idx_free_=0x%x weight_entry_idx_planed_=0x%x wt_req_cdma_prev_weight_bank_=%d\n", weight_entry_idx_free_, weight_entry_idx_planed_, wt_req_cdma_prev_weight_bank_));
            break;
        }
    }
}

void NV_NVDLA_cdma::ActDmaResponseHandler(nvdla_dma_rd_rsp_t* payload){
    // Extract data from payload
    // Each payload is 64 byte, two mask bit tells which 32 byte groups are effective
    uint8_t *payload_data_ptr;
    uint8_t *atom_cube_ptr;
    uint8_t mask;
    mask = payload->pd.dma_read_data.mask;
    payload_data_ptr    = reinterpret_cast <uint8_t *> (payload->pd.dma_read_data.data);
    //cout << "Reading cdma_req_source_fifo_ (64bytes)" << endl;
    //cdma_data_source    = cdma_req_source_fifo_->read();
    cslDebug((50, "NV_NVDLA_cdma::ActDmaResponseHandler is called. mask=%d valid atom number=0x%x, fifo->free():%d\n", (uint32_t)mask, (mask&0x1) + ((mask&0x2)>>1), act_data_read_rsp_fifo_->num_free()));

    for(uint32_t payload_iter = 0; payload_iter < DMAIF_WIDTH / DLA_ATOM_SIZE; payload_iter++ ) {
        if (0 != (mask & (0x1 << payload_iter))) {
            atom_cube_ptr = new uint8_t[DLA_ATOM_SIZE]; 
            memcpy(atom_cube_ptr, payload_data_ptr + payload_iter * DLA_ATOM_SIZE, DLA_ATOM_SIZE);
            cslDebug((50, "NV_NVDLA_cdma::ActDmaResponseHandler, payload_iter=%d. CDMA_FEATURE_DATA\n", payload_iter));
            act_data_read_rsp_fifo_->write(atom_cube_ptr);
#if LOG_DETAIL
            for(uint32_t i = 0; i < DLA_ATOM_SIZE; i++)
                cslDebug((90, "0x%02x ", atom_cube_ptr[i]));
            cslDebug((90, "\n"));
#endif
        }
    }
}

void NV_NVDLA_cdma::WeightDmaResponseHandler(nvdla_dma_rd_rsp_t* payload){
    // Extract data from payload
    // Each payload is 64 byte, two mask bit tells which 32 byte groups are effective
    uint8_t *payload_data_ptr;
    uint8_t *atom_cube_ptr;
    uint8_t  mask;
    //uint32_t idx;
    cdma_wt_info_t *cdma_wt_info;

    mask = payload->pd.dma_read_data.mask;
    payload_data_ptr    = reinterpret_cast <uint8_t *> (payload->pd.dma_read_data.data);
    if (0==wt_response_payload_size) {
        cslDebug((50, "before reading cdma_wt_info_fifo_\n"));
        cdma_wt_info             = cdma_wt_info_fifo_->read();
        cslDebug((50, "after reading cdma_wt_info_fifo_\n"));
        wt_response_cdma_source  = cdma_wt_info->cdma_source;
        wt_response_payload_size = cdma_wt_info->payload_size;
        delete cdma_wt_info;
    }

    for(uint32_t payload_iter = 0; payload_iter < DMAIF_WIDTH / DLA_ATOM_SIZE; payload_iter++ ) {
        if (0 != (mask & (0x1 << payload_iter))) {
            atom_cube_ptr = new uint8_t[DLA_ATOM_SIZE]; 
            memcpy(atom_cube_ptr, payload_data_ptr + payload_iter * DLA_ATOM_SIZE, DLA_ATOM_SIZE);
            cslDebug((50, "NV_NVDLA_cdma::WeightDmaResponseHandler, payload_iter=%d\n", payload_iter));
#if LOG_DETAIL
            for(uint32_t i = 0; i < DLA_ATOM_SIZE; i++)
                cslDebug((90, "0x%02x ", atom_cube_ptr[i]));
            cslDebug((90, "\n"));
#endif
            if (wt_response_cdma_source==CDMA_WEIGHT_DATA) {
                cslDebug((50, "NV_NVDLA_cdma::WeightDmaResponseHandler. CDMA_WEIGHT_DATA\n"));
                weight_read_rsp_fifo_->write(atom_cube_ptr);
            } else if (wt_response_cdma_source==CDMA_WMB_DATA) {
                cslDebug((50, "NV_NVDLA_cdma::WeightDmaResponseHandler. CDMA_WMB_DATA\n"));
                wmb_read_rsp_fifo_->write(atom_cube_ptr);
            } else {
                cslDebug((50, "NV_NVDLA_cdma::WeightDmaResponseHandler. CDMA_WGS_DATA\n"));
                wgs_read_rsp_fifo_->write(atom_cube_ptr);
            }
            wt_response_payload_size--;
        }
    }
}

// Target sockets
// # MC/CV_SRAM read response
void NV_NVDLA_cdma::mcif2cdma_dat_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay){
    //cslDebug((50, "NV_NVDLA_cdma::mcif2cdma_dat_rd_rsp_b_transport, begin\n"));
    ActDmaResponseHandler(payload);
    //cslDebug((50, "NV_NVDLA_cdma::mcif2cdma_dat_rd_rsp_b_transport, end\n"));
}

void NV_NVDLA_cdma::mcif2cdma_wt_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay){
    //cslDebug((50, "NV_NVDLA_cdma::mcif2cdma_wt_rd_rsp_b_transport, begin\n"));
    WeightDmaResponseHandler(payload);
    //cslDebug((50, "NV_NVDLA_cdma::mcif2cdma_wt_rd_rsp_b_transport, end\n"));
}

void NV_NVDLA_cdma::cvif2cdma_dat_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay){
    //cslDebug((50, "NV_NVDLA_cdma::cvif2cdma_dat_rd_rsp_b_transport, begin\n"));
    ActDmaResponseHandler(payload);
    //cslDebug((50, "NV_NVDLA_cdma::cvif2cdma_dat_rd_rsp_b_transport, end\n"));
}

void NV_NVDLA_cdma::cvif2cdma_wt_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay){
    //cslDebug((50, "NV_NVDLA_cdma::cvif2cdma_wt_rd_rsp_b_transport, begin\n"));
    WeightDmaResponseHandler(payload);
    //cslDebug((50, "NV_NVDLA_cdma::cvif2cdma_wt_rd_rsp_b_transport, end\n"));
}

void NV_NVDLA_cdma::dat_up_sc2cdma_b_transport(int ID, nvdla_dat_info_update_t* payload, sc_time& delay){
    if(payload->dat_entries == 0)
    {
        sc_dt_kick_off = true;
        sc_updated_cbuf_usage_data_.notify();
        cslDebug((50, "NV_NVDLA_cdma::dat_up_sc2cdma_b_transport sc_dt_kick_off\n"));
        return;
    }

    data_entry_idx_free_ += payload->dat_entries;
    cslDebug((50, "NV_NVDLA_cdma::dat_up_sc2cdma_b_transport\n"));
    cslDebug((50, "    payload->dat_entries is 0x%x\n", uint32_t (payload->dat_entries)));
    cslDebug((50, "    data_entry_idx_free_ is 0x%x\n", data_entry_idx_free_));

    sc_updated_cbuf_usage_data_.notify();
}

void NV_NVDLA_cdma::wt_up_sc2cdma_b_transport(int ID, nvdla_wt_info_update_t* payload, sc_time& delay){
    if(payload->wt_entries == 0)
    {
        sc_wt_kick_off = true;
        sc_updated_cbuf_usage_weight_.notify();
        cslDebug((50, "NV_NVDLA_cdma::wt_up_sc2cdma_b_transport, sc_wt_kick_off\n"));
        return;
    }

    weight_entry_idx_free_ +=  payload->wt_entries;
    wmb_entry_idx_free_    +=  payload->wmb_entries;
    cslDebug((50, "NV_NVDLA_cdma::wt_up_sc2cdma_b_transport\n"));
    cslDebug((50, "    payload->wt_kernels is 0x%x\n", uint32_t (payload->wt_kernels)));
    cslDebug((50, "    payload->wt_entries is 0x%x\n", uint32_t (payload->wt_entries)));
    cslDebug((50, "    payload->wmb_entries is 0x%x\n", uint32_t (payload->wmb_entries)));
    cslDebug((50, "    weight_entry_idx_free_ is 0x%x\n", weight_entry_idx_free_));
    cslDebug((50, "    wmb_entry_idx_free_ is 0x%x\n", wmb_entry_idx_free_));

    sc_updated_cbuf_usage_wmb_.notify();
    sc_updated_cbuf_usage_weight_.notify();
}

void NV_NVDLA_cdma::cdma_wt_dma_arbiter_source_id_b_transport(int ID, int source_id, sc_time& delay){
    cslDebug((50, "NV_NVDLA_cdma::cdma_wt_dma_arbiter_source_id_b_transport. source_id=%d\n", source_id));
    wt_dma_rtl_source_id_fifo_->write(source_id);
}

uint8_t NV_NVDLA_cdma::cdma_bytes_per_pixel(uint16_t pixel_format) {
    uint8_t bytes_per_pixel;
    switch (pixel_format) {
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8:
            bytes_per_pixel = 1;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R12:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16_I:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16_F:
            bytes_per_pixel = 2;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16B16G16R16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X16B16G16R16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16B16G16R16_F:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16Y16U16V16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V16U16Y16A16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16Y16U16V16_F:
            bytes_per_pixel = 8;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8B8G8R8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8R8G8B8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B8G8R8A8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8G8B8A8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X8B8G8R8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X8R8G8B8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B8G8R8X8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8G8B8X8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2B10G10R10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2R10G10B10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B10G10R10A2:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R10G10B10A2:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2Y10U10V10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V10U10Y10A2:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8Y8U8V8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V8U8Y8A8:
            bytes_per_pixel = 4;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___U8V8_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___V8U8_N444:
            bytes_per_pixel = 3;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___U10V10_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___V10U10_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___U12V12_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___V12U12_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___U16V16_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___V16U16_N444:
            bytes_per_pixel = 6;
            break;
#pragma CTC SKIP
        default:
            FAIL(("Unexpected pixel format %d", pixel_format));
#pragma CTC ENDSKIP
    }
    return bytes_per_pixel;
}

// NV_NVDLA_cdma::cdma_converted_bytes_per_pixel() is only for conversion when in_precision!=out_precision
// The pixel_format can't be FP16 formats
uint8_t NV_NVDLA_cdma::cdma_converted_bytes_per_pixel(uint16_t pixel_format, uint32_t proc_precision) {
    uint8_t bytes_per_pixel;
    switch (pixel_format) {
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8:
            bytes_per_pixel = 2;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R12:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16_I:
//        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16_F:
            bytes_per_pixel = (proc_precision==DATA_FORMAT_FP16)? 2: 1;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16B16G16R16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X16B16G16R16:
//        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16B16G16R16_F:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16Y16U16V16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V16U16Y16A16:
//        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16Y16U16V16_F:
            bytes_per_pixel = (proc_precision==DATA_FORMAT_FP16)? 8: 4;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8B8G8R8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8R8G8B8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B8G8R8A8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8G8B8A8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X8B8G8R8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X8R8G8B8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B8G8R8X8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8G8B8X8:
            bytes_per_pixel = 8;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2B10G10R10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2R10G10B10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B10G10R10A2:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R10G10B10A2:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2Y10U10V10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V10U10Y10A2:
            bytes_per_pixel = (proc_precision==DATA_FORMAT_FP16)? 8: 4;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8Y8U8V8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V8U8Y8A8:
            bytes_per_pixel = 8;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___U8V8_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___V8U8_N444:
            bytes_per_pixel = 6;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___U10V10_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___V10U10_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___U12V12_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___V12U12_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___U16V16_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___V16U16_N444:
            bytes_per_pixel = (proc_precision==DATA_FORMAT_FP16)? 6: 3;
            break;
#pragma CTC SKIP
        default:
            FAIL(("Unexpected pixel format %d", pixel_format));
#pragma CTC ENDSKIP
    }
    return bytes_per_pixel;
}

uint8_t NV_NVDLA_cdma::packed_format(uint16_t pixel_format) {
    switch (pixel_format) {
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2B10G10R10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2R10G10B10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B10G10R10A2:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R10G10B10A2:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2Y10U10V10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V10U10Y10A2:
            return true;
        default:
            return false;
    }
}

uint8_t NV_NVDLA_cdma::cdma_bytes_per_pixel_planar0(uint16_t pixel_format) {
    uint8_t bytes_per_pixel_planar0;
    switch (pixel_format) {
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___U8V8_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___V8U8_N444:
            bytes_per_pixel_planar0 = 1;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___U10V10_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___V10U10_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___U12V12_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___V12U12_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___U16V16_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___V16U16_N444:
            bytes_per_pixel_planar0 = 2;
            break;
#pragma CTC SKIP
        default:
            bytes_per_pixel_planar0 = 0;
            break;
#pragma CTC ENDSKIP
    }
    return bytes_per_pixel_planar0;
}

uint8_t NV_NVDLA_cdma::cdma_bytes_per_pixel_planar1(uint16_t pixel_format) {
    uint8_t bytes_per_pixel_planar1;
    switch (pixel_format) {
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___U8V8_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___V8U8_N444:
            bytes_per_pixel_planar1 = 2;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___U10V10_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___V10U10_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___U12V12_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___V12U12_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___U16V16_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___V16U16_N444:
            bytes_per_pixel_planar1 = 4;
            break;
#pragma CTC SKIP
        default:
            bytes_per_pixel_planar1 = 0;
            break;
#pragma CTC ENDSKIP
    }
    return bytes_per_pixel_planar1;
}

uint8_t NV_NVDLA_cdma::cdma_element_num(uint16_t pixel_format) {
    uint8_t element_num = 0;
    cslDebug((50, "NV_NVDLA_cdma::cdma_element_num pixel_format=0x%x\n", pixel_format));
    switch (pixel_format) {
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R12:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16_I:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16_F:
            element_num = 1;
            cslDebug((50, "NV_NVDLA_cdma::cdma_element_num element_num=0x%x\n", element_num));
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16B16G16R16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X16B16G16R16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16B16G16R16_F:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16Y16U16V16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V16U16Y16A16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V8U8Y8A8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8Y8U8V8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16Y16U16V16_F:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8B8G8R8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8R8G8B8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B8G8R8A8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8G8B8A8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X8B8G8R8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X8R8G8B8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B8G8R8X8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2B10G10R10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2R10G10B10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B10G10R10A2:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R10G10B10A2:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2Y10U10V10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V10U10Y10A2:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8G8B8X8:
            element_num = 4;
            cslDebug((50, "NV_NVDLA_cdma::cdma_element_num: element_num=0x%x\n", element_num));
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___U8V8_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___V8U8_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___U10V10_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___V10U10_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___U12V12_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___V12U12_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___U16V16_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___V16U16_N444:
            element_num = 3;
            cslDebug((50, "NV_NVDLA_cdma::cdma_element_num: element_num=0x%x\n", element_num));
            break;
        default:
            FAIL(("Unexpected pixel format %d", pixel_format));
    }
    cslDebug((50, "NV_NVDLA_cdma::cdma_element_num: element_num=0x%x\n", element_num));
    return element_num;
}

uint8_t NV_NVDLA_cdma::cdma_planar_num(uint16_t pixel_format) {
    uint8_t planar_num;
    switch (pixel_format) {
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R12:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16_I:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R16_F:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16B16G16R16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X16B16G16R16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16B16G16R16_F:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16Y16U16V16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V16U16Y16A16:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A16Y16U16V16_F:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8B8G8R8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8R8G8B8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B8G8R8A8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8G8B8A8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X8B8G8R8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_X8R8G8B8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B8G8R8X8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R8G8B8X8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A8Y8U8V8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V8U8Y8A8:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2B10G10R10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2R10G10B10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_B10G10R10A2:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_R10G10B10A2:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_A2Y10U10V10:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_V10U10Y10A2:
            planar_num = 1;
            break;
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___U8V8_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y8___V8U8_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___U10V10_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y10___V10U10_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___U12V12_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y12___V12U12_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___U16V16_N444:
        case NVDLA_CDMA_D_DATAIN_FORMAT_0_PIXEL_FORMAT_T_Y16___V16U16_N444:
            planar_num = 2;
            break;
#pragma CTC SKIP
        default:
            FAIL(("Unexpected pixel format %d", pixel_format));
    }
    return planar_num;
#pragma CTC ENDSKIP
}

// read_data_ptr is 128Bytes
void NV_NVDLA_cdma::WriteOneEntryToCbuf(uint8_t* read_data_ptr, uint32_t cbuf_entry_addr, uint32_t super_atom_size, uint32_t super_atom_num)
{
    uint8_t *cbuf_payload_data_ptr = reinterpret_cast <uint8_t *> (cdma2cbuf_data_payload_->data);
//  for (uint32_t super_atom_iter = 0; super_atom_iter < NVDLA_CBUF_BANK_WIDTH / super_atom_size; super_atom_iter++)
    for (uint32_t super_atom_iter = 0; super_atom_iter < super_atom_num; super_atom_iter++)
    {
        cdma2cbuf_data_payload_->hsel = super_atom_iter;
        cdma2cbuf_data_payload_->addr = cbuf_entry_addr;
        cdma2cbuf_data_payload_->size = super_atom_size;
        memcpy(cbuf_payload_data_ptr, &read_data_ptr[super_atom_iter * super_atom_size], super_atom_size);
        cslDebug((50, "WriteToCbuf addr=0x%x hsel=%d\n", cdma2cbuf_data_payload_->addr, (unsigned int)(cdma2cbuf_data_payload_->hsel)));
#if LOG_DETAIL
        cslDebug((90, " data:\n"));
        for (uint32_t i = 0; i < super_atom_size; i++)
            cslDebug((90, " 0x%x ", cbuf_payload_data_ptr[i]));
        cslDebug((90, "\n"));
#endif
        cdma2buf_dat_wr_b_transport(cdma2cbuf_data_payload_, b_transport_delay_);
    }
}

// input_ptr is int16_t*, output ptr is int32_t*
void NV_NVDLA_cdma::hls_convertor(int16_t* in_ptr, uint8_t input_data_type, int16_t offset, int16_t scale, uint8_t truncate, uint32_t in_precision, uint32_t out_precision, int32_t* out_ptr)
{
    int64_t tmp0;
    int64_t tmp1;
    int64_t tmp2;
    double  tmp3;
    int64_t tmp4;

    bool unsigned_int8   = input_data_type == PIXEL_UNSIGNED_INT8;
    bool signed_int8     = input_data_type == PIXEL_SIGNED_INT8;
    bool unsigned_int16  = input_data_type == PIXEL_UNSIGNED_INT16;
    bool signed_int16    = input_data_type == PIXEL_SIGNED_INT16;
    bool fp16            = input_data_type == PIXEL_FP16;

    cdma_cvt_hls(in_ptr, input_data_type, offset, scale, in_precision, out_precision, truncate, out_ptr);

    // Check for INT8 and INT16
    if ((!fp16) && (DATA_FORMAT_FP16 != out_precision))
    {
        // Prepare 17bits Input
        if(unsigned_int8) {
            tmp0 = (*in_ptr) & 0xff; // Set MSB to 0
        }
        else if(signed_int8) {
            if (((*in_ptr) & 0x80) !=0) {  // negative
                uint64_t tmp = (*in_ptr) | 0xffffffffffffff00ULL;
                tmp0 = static_cast<int64_t>(tmp);
            }
            else
                tmp0 = (*in_ptr) & 0xff;   // Set MSB to 0
        }
        else if(unsigned_int16) {
            tmp0 = (*in_ptr) & 0xffff; // Set MSB to 0
        }
        else if(signed_int16) {
            if (((*in_ptr) & 0x8000) !=0) { // negative
                uint64_t tmp = (*in_ptr) | 0xffffffffffff0000ULL;
                tmp0 = static_cast<int64_t>(tmp);
            }
            else
                tmp0 = (*in_ptr) & 0xffff;   // Set MSB to 0
        }
#pragma CTC SKIP
        else if(fp16) {  // FP16
            tmp0 = *in_ptr;
        }
        else {
            cslInfo(("Invalid data type\n"));
        }
#pragma CTC ENDSKIP

        // minus offset
        tmp1 = tmp0 - offset;
        // scale
        tmp2 = tmp1 * scale;
        // truncate and saturate
        tmp3 = double(tmp2) / (1ULL<<truncate);
        tmp4 = static_cast<int64_t>( tmp3 + ((tmp3>0)?0.5:(-0.5)));
        if (DATA_FORMAT_INT8 == out_precision)
            tmp4 = (tmp4 > 0x7f)? 0x7f: (tmp4 < -0x80)? -0x80: tmp4;
        else
            tmp4 = (tmp4 > 0x7fff)? 0x7fff: (tmp4 < -0x8000)? -0x8000: tmp4;
    }

    cslDebug((70, "NV_NVDLA_cdma::hls_convertor input data=0x%x offset=0x%x scale=0x%x truncate=0x%x in_precision=%d out_precision=%d output_data=0x%x\n", *in_ptr, offset, scale, truncate, in_precision, out_precision, *out_ptr));
    if ((!fp16) && (DATA_FORMAT_FP16 != out_precision) && ((*out_ptr) != int32_t(tmp4)))
        FAIL(("Checker faild: hls ouput = 0x%x checker outout = 0x%lx\n", *out_ptr, (uint64_t)tmp4));
}

void NV_NVDLA_cdma::process_one_element_8(int8_t pixel_8, uint32_t pixel_idx, uint8_t element_num, uint8_t i, bool cvt_en, bool convert_8to16, uint8_t* pad_buffer_8, uint16_t* pad_buffer_16, int16_t cvt_mean, int16_t cvt_scale, uint8_t cvt_truncate, uint32_t in_precision, uint32_t proc_precision)
{
    int16_t convert_input;
    int32_t convert_result;
    int8_t  input_data_type;

    input_data_type = cdma_pixel_sign_override_? PIXEL_SIGNED_INT8: PIXEL_UNSIGNED_INT8;
    convert_input = pixel_8 & 0xff;
#if LOG_DETAIL
    cslDebug((90, "convert_8to16=%d cvt_en=%d cvt_mean=0x%x cvt_scale=0x%x cvt_truncate=0x%x pixel_idx=0x%x pixel_8=0x%x convert_input=0x%x\n", convert_8to16, cvt_en, cvt_mean, cvt_scale, cvt_truncate, pixel_idx, pixel_8, convert_input));
#endif

    if(cvt_en)
        hls_convertor(&convert_input, input_data_type, cvt_mean, cvt_scale, cvt_truncate, in_precision, proc_precision, &convert_result);
    else
        convert_result = pixel_8;   // if cvt_en==false, no need to minus mean
    if(convert_8to16) {
        pad_buffer_16[pixel_idx*element_num+i] = *(uint16_t*)&convert_result;   // get the lower two bytes
    }
    else {
        pad_buffer_8[pixel_idx*element_num+i] = *(uint8_t*)&convert_result;     // get the lower one byte
        //cslDebug((70, "pad_buffer_8[pixel_idx*element_num+i]=0x%x\n", pad_buffer_8[pixel_idx*element_num+i]));
    }
#if LOG_DETAIL
    cslDebug((90, "convert_result=0x%x\n", convert_result));
#endif
}

void NV_NVDLA_cdma::process_one_element_16(int16_t pixel_16, uint32_t pixel_idx, uint8_t element_num, uint8_t i, int8_t input_data_type, bool cvt_en, bool convert_16to8, uint8_t* pad_buffer_8, uint16_t* pad_buffer_16, int16_t cvt_mean, int16_t cvt_scale, uint8_t cvt_truncate, uint32_t in_precision, uint32_t proc_precision)
{
    int16_t convert_input;
    int32_t convert_result;
    int8_t  input_data_type_tmp;

    input_data_type_tmp = (input_data_type==PIXEL_FP16)? PIXEL_FP16: cdma_pixel_sign_override_? PIXEL_SIGNED_INT16: PIXEL_UNSIGNED_INT16;
    convert_input = pixel_16;
#if LOG_DETAIL
    cslDebug((90, "cvt_en=%d cvt_mean=0x%x pixel_idx=0x%x pixel_16=0x%x\n", cvt_en, cvt_mean, pixel_idx, pixel_16));
#endif

    if(cvt_en)
        hls_convertor(&convert_input, input_data_type_tmp, cvt_mean, cvt_scale, cvt_truncate, in_precision, proc_precision, &convert_result);
    else
        convert_result = pixel_16;
    if(convert_16to8) {
        pad_buffer_8[pixel_idx*element_num+i] = *(uint8_t*)&convert_result;   // get the lower one byte
    }
    else {
        pad_buffer_16[pixel_idx*element_num+i] = *(uint16_t*)&convert_result; // get the lower two bytes
    }
#if LOG_DETAIL
    cslDebug((90, "convert_result=0x%x\n", convert_result));
#endif
}

bool NV_NVDLA_cdma::isNaN(uint16_t in_fp16)
{
    //cout <<"stepheng, the input fp16 is 0x"<<hex<<in_fp16<<endl;
    if (((in_fp16 & 0x3ff) != 0) && (((in_fp16 >> 10) & 0x1f) == 31)){
        return true;
    }
    else {
        return false;
    }
}

bool NV_NVDLA_cdma::isInf(uint16_t in_fp16)
{
    if (((in_fp16 & 0x3ff) == 0) && (((in_fp16 >> 10) & 0x1f) == 31)){
        return true;
    }
    else {
        return false;
    }
}

void NV_NVDLA_cdma::countNaNinData(uint8_t *read_data_ptr, uint32_t *data_nan_num_perlayer_)
{
    int32_t i;
    for (i = 0; i<NVDLA_MEMORY_ATOMIC_SIZE; i++) {
        uint16_t tmp_fp16 = ((uint16_t)read_data_ptr[2 * i + 1]) << 8 | read_data_ptr[2 * i];
        if(isNaN(tmp_fp16)){
            (*data_nan_num_perlayer_)++;
        }
    }
}

void NV_NVDLA_cdma::countInfinData(uint8_t *read_data_ptr, uint32_t *data_inf_num_perlayer_)
{
    int32_t i;
    for (i = 0; i<NVDLA_MEMORY_ATOMIC_SIZE; i++) {
        uint16_t tmp_fp16 = ((uint16_t)read_data_ptr[2 * i + 1]) << 8 | read_data_ptr[2 * i];
        if(isInf(tmp_fp16)){
            (*data_inf_num_perlayer_)++;
        }
    }
}

#pragma CTC SKIP
NV_NVDLA_cdma * NV_NVDLA_cdmaCon(sc_module_name name)
{
    return new NV_NVDLA_cdma(name);
}
#pragma CTC ENDSKIP
