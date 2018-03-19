// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cmac_a_reg_model.cpp

#include "cmac_a_reg_model.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define NVDLA_CMAC_A_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD (1<<17)
#define NVDLA_CMAC_A_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT 17

#pragma CTC SKIP
SCSIM_NAMESPACE_START(cmod)
    MK_UREGSET_CLASS(NVDLA_CMAC_A)
SCSIM_NAMESPACE_END()
#pragma CTC ENDSKIP

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
    using namespace tlm;
    using namespace sc_core;

cmac_a_reg_model::cmac_a_reg_model() {
    cmac_a_register_group_0 = new CNVDLA_CMAC_A_REGSET;
    cmac_a_register_group_1 = new CNVDLA_CMAC_A_REGSET;
    ////LUT_COMMENT cmac_a_lut = new NvdlaLut;
    CmacARegReset();
}

#pragma CTC SKIP
cmac_a_reg_model::~cmac_a_reg_model() {
    delete cmac_a_register_group_0;
    delete cmac_a_register_group_1;
    ////LUT_COMMENT delete cmac_a_lut;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
bool cmac_a_reg_model::CmacAUpdateStatusRegister(uint32_t reg_addr, uint8_t group, uint32_t data) {
    uint32_t offset;

    offset = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    // Get producer point value
    if ( 0 == group ) {
        // The invertion of valid bit served as write enable
        cmac_a_register_group_0->Set(offset, data);
    } else {
        // The invertion of valid bit served as write enable
        cmac_a_register_group_1->Set(offset, data);
    }

    return true;
}
#pragma CTC ENDSKIP

bool cmac_a_reg_model::CmacAAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write) {
    uint32_t offset, operation_enable_offset;
    uint32_t rdata = 0;
    uint32_t producer_pointer;

    offset                  = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    operation_enable_offset = REG_off(NVDLA_CMAC_A_D_OP_ENABLE);
    producer_pointer = cmac_a_register_group_0->rS_POINTER.uPRODUCER();

    if (is_write) { // Write Request
        if (offset >= operation_enable_offset) { // Registers with dual entities
            // Get producer point value
            if ( 0 == producer_pointer ) {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (cmac_a_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("cmac_a_reg_model::CmacAAccessRegister, attent to write working group 0"));
                }
#pragma CTC ENDSKIP
                cmac_a_register_group_0->SetWritable(offset, data);
                if (cmac_a_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    event_cmac_a_reg_group_0_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "cmac_a_reg_model::CmacAAccessRegister, notified op_en for group 0.\x0A"));
                }
            } else {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (cmac_a_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("cmac_a_reg_model::CmacAAccessRegister, attent to write working group 1"));
                }
#pragma CTC ENDSKIP
                cmac_a_register_group_1->SetWritable(offset, data);
                if (cmac_a_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    event_cmac_a_reg_group_1_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "cmac_a_reg_model::CmacAAccessRegister, notified op_en for group 1.\x0A"));
                }
            }
        } else { // Registers which have only one entity

            cmac_a_register_group_0->SetWritable(offset, data);
            cmac_a_register_group_1->SetWritable(offset, data);

        }
        // Write done
    } else { // Read Request
        if (offset >= operation_enable_offset) { // Register with shadow
            if ( 0 == producer_pointer ) {
                cmac_a_register_group_0->GetReadable(offset, &rdata);
            } else {
                cmac_a_register_group_1->GetReadable(offset, &rdata);
            }
        } else { // Register which have only one entity

            cmac_a_register_group_0->GetReadable(offset, &rdata);

        }
        data = rdata;
    }
    return true;
}

void cmac_a_reg_model::CmacARegReset() {
        cmac_a_register_group_0->ResetAll();
        cmac_a_register_group_1->ResetAll();

}

void cmac_a_reg_model::CmacAUpdateVariables(CNVDLA_CMAC_A_REGSET *reg_group_ptr) {
        cmac_a_status_0_ = reg_group_ptr->rS_STATUS.uSTATUS_0();
        cmac_a_status_1_ = reg_group_ptr->rS_STATUS.uSTATUS_1();
        cmac_a_producer_ = reg_group_ptr->rS_POINTER.uPRODUCER();
        cmac_a_consumer_ = reg_group_ptr->rS_POINTER.uCONSUMER();
        cmac_a_op_en_ = reg_group_ptr->rD_OP_ENABLE.uOP_EN();
        cmac_a_conv_mode_ = reg_group_ptr->rD_MISC_CFG.uCONV_MODE();
        cmac_a_proc_precision_ = reg_group_ptr->rD_MISC_CFG.uPROC_PRECISION();

}

void cmac_a_reg_model::CmacAClearOpeartionEnable(CNVDLA_CMAC_A_REGSET *reg_group_ptr){
    reg_group_ptr->rD_OP_ENABLE.uOP_EN(NVDLA_CMAC_A_D_OP_ENABLE_0_OP_EN_DISABLE);
    CmacAIncreaseConsumerPointer();
}

uint32_t cmac_a_reg_model::CmacAGetOpeartionEnable(CNVDLA_CMAC_A_REGSET *reg_group_ptr){
    return reg_group_ptr->rD_OP_ENABLE.uOP_EN();
}

void cmac_a_reg_model::CmacAIncreaseConsumerPointer(){
    uint32_t consumer_pointer;
    consumer_pointer = (cmac_a_register_group_0->rS_POINTER.uCONSUMER() == 0) ? 1 : 0;
    cmac_a_register_group_0->rS_POINTER.uCONSUMER( consumer_pointer );
    cmac_a_register_group_1->rS_POINTER.uCONSUMER( consumer_pointer );
}

void cmac_a_reg_model::CmacAUpdateWorkingStatus(uint32_t group_id, uint32_t status){
    switch (group_id) {
        case 0:
            cmac_a_register_group_0->rS_STATUS.uSTATUS_0(status);
            break;
        case 1:
            cmac_a_register_group_0->rS_STATUS.uSTATUS_1(status);
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    } 
}
