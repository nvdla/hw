// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cacc_reg_model.cpp

#include "cacc_reg_model.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define NVDLA_CACC_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD (1<<17)
#define NVDLA_CACC_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT 17

#pragma CTC SKIP
SCSIM_NAMESPACE_START(cmod)
    MK_UREGSET_CLASS(NVDLA_CACC)
SCSIM_NAMESPACE_END()
#pragma CTC ENDSKIP

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
    using namespace tlm;
    using namespace sc_core;

cacc_reg_model::cacc_reg_model() {
    cacc_register_group_0 = new CNVDLA_CACC_REGSET;
    cacc_register_group_1 = new CNVDLA_CACC_REGSET;
    ////LUT_COMMENT cacc_lut = new NvdlaLut;
    CaccRegReset();
}

#pragma CTC SKIP
cacc_reg_model::~cacc_reg_model() {
    delete cacc_register_group_0;
    delete cacc_register_group_1;
    ////LUT_COMMENT delete cacc_lut;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
bool cacc_reg_model::CaccUpdateStatusRegister(uint32_t reg_addr, uint8_t group, uint32_t data) {
    uint32_t offset;

    offset = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    // Get producer point value
    if ( 0 == group ) {
        // The invertion of valid bit served as write enable
        cacc_register_group_0->Set(offset, data);
    } else {
        // The invertion of valid bit served as write enable
        cacc_register_group_1->Set(offset, data);
    }

    return true;
}
#pragma CTC ENDSKIP

bool cacc_reg_model::CaccAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write) {
    uint32_t offset, operation_enable_offset;
    uint32_t rdata = 0;
    uint32_t producer_pointer;

    offset                  = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    operation_enable_offset = REG_off(NVDLA_CACC_D_OP_ENABLE);
    producer_pointer = cacc_register_group_0->rS_POINTER.uPRODUCER();

    if (is_write) { // Write Request
        if (offset >= operation_enable_offset) { // Registers with dual entities
            // Get producer point value
            if ( 0 == producer_pointer ) {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (cacc_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("cacc_reg_model::CaccAccessRegister, attent to write working group 0"));
                }
#pragma CTC ENDSKIP
                cacc_register_group_0->SetWritable(offset, data);
                if (cacc_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    event_cacc_reg_group_0_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "cacc_reg_model::CaccAccessRegister, notified op_en for group 0.\x0A"));
                }
            } else {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (cacc_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("cacc_reg_model::CaccAccessRegister, attent to write working group 1"));
                }
#pragma CTC ENDSKIP
                cacc_register_group_1->SetWritable(offset, data);
                if (cacc_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    event_cacc_reg_group_1_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "cacc_reg_model::CaccAccessRegister, notified op_en for group 1.\x0A"));
                }
            }
        } else { // Registers which have only one entity

            cacc_register_group_0->SetWritable(offset, data);
            cacc_register_group_1->SetWritable(offset, data);

        }
        // Write done
    } else { // Read Request
        if (offset >= operation_enable_offset) { // Register with shadow
            if ( 0 == producer_pointer ) {
                cacc_register_group_0->GetReadable(offset, &rdata);
            } else {
                cacc_register_group_1->GetReadable(offset, &rdata);
            }
        } else { // Register which have only one entity

            cacc_register_group_0->GetReadable(offset, &rdata);

        }
        data = rdata;
    }
    return true;
}

void cacc_reg_model::CaccRegReset() {
        cacc_register_group_0->ResetAll();
        cacc_register_group_1->ResetAll();

}

void cacc_reg_model::CaccUpdateVariables(CNVDLA_CACC_REGSET *reg_group_ptr) {
        cacc_status_0_ = reg_group_ptr->rS_STATUS.uSTATUS_0();
        cacc_status_1_ = reg_group_ptr->rS_STATUS.uSTATUS_1();
        cacc_producer_ = reg_group_ptr->rS_POINTER.uPRODUCER();
        cacc_consumer_ = reg_group_ptr->rS_POINTER.uCONSUMER();
        cacc_op_en_ = reg_group_ptr->rD_OP_ENABLE.uOP_EN();
        cacc_conv_mode_ = reg_group_ptr->rD_MISC_CFG.uCONV_MODE();
        cacc_proc_precision_ = reg_group_ptr->rD_MISC_CFG.uPROC_PRECISION();
        cacc_dataout_width_ = reg_group_ptr->rD_DATAOUT_SIZE_0.uDATAOUT_WIDTH();
        cacc_dataout_height_ = reg_group_ptr->rD_DATAOUT_SIZE_0.uDATAOUT_HEIGHT();
        cacc_dataout_channel_ = reg_group_ptr->rD_DATAOUT_SIZE_1.uDATAOUT_CHANNEL();
        cacc_dataout_addr_ = reg_group_ptr->rD_DATAOUT_ADDR.uDATAOUT_ADDR();
        cacc_batches_ = reg_group_ptr->rD_BATCH_NUMBER.uBATCHES();
        cacc_line_stride_ = reg_group_ptr->rD_LINE_STRIDE.uLINE_STRIDE();
        cacc_surf_stride_ = reg_group_ptr->rD_SURF_STRIDE.uSURF_STRIDE();
        cacc_line_packed_ = reg_group_ptr->rD_DATAOUT_MAP.uLINE_PACKED();
        cacc_surf_packed_ = reg_group_ptr->rD_DATAOUT_MAP.uSURF_PACKED();
        cacc_clip_truncate_ = reg_group_ptr->rD_CLIP_CFG.uCLIP_TRUNCATE();
        cacc_sat_count_ = reg_group_ptr->rD_OUT_SATURATION.uSAT_COUNT();
        cacc_cya_ = reg_group_ptr->rD_CYA.uCYA();

}

void cacc_reg_model::CaccClearOpeartionEnable(CNVDLA_CACC_REGSET *reg_group_ptr){
    reg_group_ptr->rD_OP_ENABLE.uOP_EN(NVDLA_CACC_D_OP_ENABLE_0_OP_EN_DISABLE);
    CaccIncreaseConsumerPointer();
}

uint32_t cacc_reg_model::CaccGetOpeartionEnable(CNVDLA_CACC_REGSET *reg_group_ptr){
    return reg_group_ptr->rD_OP_ENABLE.uOP_EN();
}

void cacc_reg_model::CaccIncreaseConsumerPointer(){
    uint32_t consumer_pointer;
    consumer_pointer = (cacc_register_group_0->rS_POINTER.uCONSUMER() == 0) ? 1 : 0;
    cacc_register_group_0->rS_POINTER.uCONSUMER( consumer_pointer );
    cacc_register_group_1->rS_POINTER.uCONSUMER( consumer_pointer );
}

void cacc_reg_model::CaccUpdateWorkingStatus(uint32_t group_id, uint32_t status){
    switch (group_id) {
        case 0:
            cacc_register_group_0->rS_STATUS.uSTATUS_0(status);
            break;
        case 1:
            cacc_register_group_0->rS_STATUS.uSTATUS_1(status);
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    } 
}

void cacc_reg_model::CaccUpdateStatRegisters(uint32_t group_id, uint32_t saturation_num) {
    if ( 0 == group_id ) {
        cacc_register_group_0->rD_OUT_SATURATION.uSAT_COUNT(saturation_num);;
    } else {
        cacc_register_group_1->rD_OUT_SATURATION.uSAT_COUNT(saturation_num);;
    }
}
