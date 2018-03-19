// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: csc_reg_model.cpp

#include "csc_reg_model.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define NVDLA_CSC_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD (1<<17)
#define NVDLA_CSC_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT 17

#pragma CTC SKIP
SCSIM_NAMESPACE_START(cmod)
    MK_UREGSET_CLASS(NVDLA_CSC)
SCSIM_NAMESPACE_END()
#pragma CTC ENDSKIP

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
    using namespace tlm;
    using namespace sc_core;

csc_reg_model::csc_reg_model() {
    csc_register_group_0 = new CNVDLA_CSC_REGSET;
    csc_register_group_1 = new CNVDLA_CSC_REGSET;
    ////LUT_COMMENT csc_lut = new NvdlaLut;
    CscRegReset();
}

#pragma CTC SKIP
csc_reg_model::~csc_reg_model() {
    delete csc_register_group_0;
    delete csc_register_group_1;
    ////LUT_COMMENT delete csc_lut;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
bool csc_reg_model::CscUpdateStatusRegister(uint32_t reg_addr, uint8_t group, uint32_t data) {
    uint32_t offset;

    offset = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    // Get producer point value
    if ( 0 == group ) {
        // The invertion of valid bit served as write enable
        csc_register_group_0->Set(offset, data);
    } else {
        // The invertion of valid bit served as write enable
        csc_register_group_1->Set(offset, data);
    }

    return true;
}
#pragma CTC ENDSKIP

bool csc_reg_model::CscAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write) {
    uint32_t offset, operation_enable_offset;
    uint32_t rdata = 0;
    uint32_t producer_pointer;

    offset                  = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    operation_enable_offset = REG_off(NVDLA_CSC_D_OP_ENABLE);
    producer_pointer = csc_register_group_0->rS_POINTER.uPRODUCER();

    if (is_write) { // Write Request
        if (offset >= operation_enable_offset) { // Registers with dual entities
            // Get producer point value
            if ( 0 == producer_pointer ) {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (csc_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("csc_reg_model::CscAccessRegister, attent to write working group 0"));
                }
#pragma CTC ENDSKIP
                csc_register_group_0->SetWritable(offset, data);
                if (csc_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    event_csc_reg_group_0_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "csc_reg_model::CscAccessRegister, notified op_en for group 0.\x0A"));
                }
            } else {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (csc_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("csc_reg_model::CscAccessRegister, attent to write working group 1"));
                }
#pragma CTC ENDSKIP
                csc_register_group_1->SetWritable(offset, data);
                if (csc_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    event_csc_reg_group_1_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "csc_reg_model::CscAccessRegister, notified op_en for group 1.\x0A"));
                }
            }
        } else { // Registers which have only one entity

            csc_register_group_0->SetWritable(offset, data);
            csc_register_group_1->SetWritable(offset, data);

        }
        // Write done
    } else { // Read Request
        if (offset >= operation_enable_offset) { // Register with shadow
            if ( 0 == producer_pointer ) {
                csc_register_group_0->GetReadable(offset, &rdata);
            } else {
                csc_register_group_1->GetReadable(offset, &rdata);
            }
        } else { // Register which have only one entity

            csc_register_group_0->GetReadable(offset, &rdata);

        }
        data = rdata;
    }
    return true;
}

void csc_reg_model::CscRegReset() {
        csc_register_group_0->ResetAll();
        csc_register_group_1->ResetAll();

}

void csc_reg_model::CscUpdateVariables(CNVDLA_CSC_REGSET *reg_group_ptr) {
        csc_status_0_ = reg_group_ptr->rS_STATUS.uSTATUS_0();
        csc_status_1_ = reg_group_ptr->rS_STATUS.uSTATUS_1();
        csc_producer_ = reg_group_ptr->rS_POINTER.uPRODUCER();
        csc_consumer_ = reg_group_ptr->rS_POINTER.uCONSUMER();
        csc_op_en_ = reg_group_ptr->rD_OP_ENABLE.uOP_EN();
        csc_conv_mode_ = reg_group_ptr->rD_MISC_CFG.uCONV_MODE();
        csc_in_precision_ = reg_group_ptr->rD_MISC_CFG.uIN_PRECISION();
        csc_proc_precision_ = reg_group_ptr->rD_MISC_CFG.uPROC_PRECISION();
        csc_data_reuse_ = reg_group_ptr->rD_MISC_CFG.uDATA_REUSE();
        csc_weight_reuse_ = reg_group_ptr->rD_MISC_CFG.uWEIGHT_REUSE();
        csc_skip_data_rls_ = reg_group_ptr->rD_MISC_CFG.uSKIP_DATA_RLS();
        csc_skip_weight_rls_ = reg_group_ptr->rD_MISC_CFG.uSKIP_WEIGHT_RLS();
        csc_datain_format_ = reg_group_ptr->rD_DATAIN_FORMAT.uDATAIN_FORMAT();
        csc_datain_width_ext_ = reg_group_ptr->rD_DATAIN_SIZE_EXT_0.uDATAIN_WIDTH_EXT();
        csc_datain_height_ext_ = reg_group_ptr->rD_DATAIN_SIZE_EXT_0.uDATAIN_HEIGHT_EXT();
        csc_datain_channel_ext_ = reg_group_ptr->rD_DATAIN_SIZE_EXT_1.uDATAIN_CHANNEL_EXT();
        csc_batches_ = reg_group_ptr->rD_BATCH_NUMBER.uBATCHES();
        csc_y_extension_ = reg_group_ptr->rD_POST_Y_EXTENSION.uY_EXTENSION();
        csc_entries_ = reg_group_ptr->rD_ENTRY_PER_SLICE.uENTRIES();
        csc_weight_format_ = reg_group_ptr->rD_WEIGHT_FORMAT.uWEIGHT_FORMAT();
        csc_weight_width_ext_ = reg_group_ptr->rD_WEIGHT_SIZE_EXT_0.uWEIGHT_WIDTH_EXT();
        csc_weight_height_ext_ = reg_group_ptr->rD_WEIGHT_SIZE_EXT_0.uWEIGHT_HEIGHT_EXT();
        csc_weight_channel_ext_ = reg_group_ptr->rD_WEIGHT_SIZE_EXT_1.uWEIGHT_CHANNEL_EXT();
        csc_weight_kernel_ = reg_group_ptr->rD_WEIGHT_SIZE_EXT_1.uWEIGHT_KERNEL();
        csc_weight_bytes_ = reg_group_ptr->rD_WEIGHT_BYTES.uWEIGHT_BYTES();
        csc_wmb_bytes_ = reg_group_ptr->rD_WMB_BYTES.uWMB_BYTES();
        csc_dataout_width_ = reg_group_ptr->rD_DATAOUT_SIZE_0.uDATAOUT_WIDTH();
        csc_dataout_height_ = reg_group_ptr->rD_DATAOUT_SIZE_0.uDATAOUT_HEIGHT();
        csc_dataout_channel_ = reg_group_ptr->rD_DATAOUT_SIZE_1.uDATAOUT_CHANNEL();
        csc_atomics_ = reg_group_ptr->rD_ATOMICS.uATOMICS();
        csc_rls_slices_ = reg_group_ptr->rD_RELEASE.uRLS_SLICES();
        csc_conv_x_stride_ext_ = reg_group_ptr->rD_CONV_STRIDE_EXT.uCONV_X_STRIDE_EXT();
        csc_conv_y_stride_ext_ = reg_group_ptr->rD_CONV_STRIDE_EXT.uCONV_Y_STRIDE_EXT();
        csc_x_dilation_ext_ = reg_group_ptr->rD_DILATION_EXT.uX_DILATION_EXT();
        csc_y_dilation_ext_ = reg_group_ptr->rD_DILATION_EXT.uY_DILATION_EXT();
        csc_pad_left_ = reg_group_ptr->rD_ZERO_PADDING.uPAD_LEFT();
        csc_pad_top_ = reg_group_ptr->rD_ZERO_PADDING.uPAD_TOP();
        csc_pad_value_ = reg_group_ptr->rD_ZERO_PADDING_VALUE.uPAD_VALUE();
        csc_data_bank_ = reg_group_ptr->rD_BANK.uDATA_BANK();
        csc_weight_bank_ = reg_group_ptr->rD_BANK.uWEIGHT_BANK();
        csc_pra_truncate_ = reg_group_ptr->rD_PRA_CFG.uPRA_TRUNCATE();
        csc_cya_ = reg_group_ptr->rD_CYA.uCYA();

}

void csc_reg_model::CscClearOpeartionEnable(CNVDLA_CSC_REGSET *reg_group_ptr){
    reg_group_ptr->rD_OP_ENABLE.uOP_EN(NVDLA_CSC_D_OP_ENABLE_0_OP_EN_DISABLE);
    CscIncreaseConsumerPointer();
}

uint32_t csc_reg_model::CscGetOpeartionEnable(CNVDLA_CSC_REGSET *reg_group_ptr){
    return reg_group_ptr->rD_OP_ENABLE.uOP_EN();
}

void csc_reg_model::CscIncreaseConsumerPointer(){
    uint32_t consumer_pointer;
    consumer_pointer = (csc_register_group_0->rS_POINTER.uCONSUMER() == 0) ? 1 : 0;
    csc_register_group_0->rS_POINTER.uCONSUMER( consumer_pointer );
    csc_register_group_1->rS_POINTER.uCONSUMER( consumer_pointer );
}

void csc_reg_model::CscUpdateWorkingStatus(uint32_t group_id, uint32_t status){
    switch (group_id) {
        case 0:
            csc_register_group_0->rS_STATUS.uSTATUS_0(status);
            break;
        case 1:
            csc_register_group_0->rS_STATUS.uSTATUS_1(status);
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    } 
}
