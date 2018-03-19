// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: rbk_reg_model.cpp

#include "rbk_reg_model.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define NVDLA_RBK_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD (1<<17)
#define NVDLA_RBK_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT 17

#pragma CTC SKIP
SCSIM_NAMESPACE_START(cmod)
    MK_UREGSET_CLASS(NVDLA_RBK)
SCSIM_NAMESPACE_END()
#pragma CTC ENDSKIP

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
    using namespace tlm;
    using namespace sc_core;

rbk_reg_model::rbk_reg_model() {
    rbk_register_group_0 = new CNVDLA_RBK_REGSET;
    rbk_register_group_1 = new CNVDLA_RBK_REGSET;
    ////LUT_COMMENT rbk_lut = new NvdlaLut;
    RbkRegReset();
}

#pragma CTC SKIP
rbk_reg_model::~rbk_reg_model() {
    delete rbk_register_group_0;
    delete rbk_register_group_1;
    ////LUT_COMMENT delete rbk_lut;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
bool rbk_reg_model::RbkUpdateStatusRegister(uint32_t reg_addr, uint8_t group, uint32_t data) {
    uint32_t offset;

    offset = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    // Get producer point value
    if ( 0 == group ) {
        // The invertion of valid bit served as write enable
        rbk_register_group_0->Set(offset, data);
    } else {
        // The invertion of valid bit served as write enable
        rbk_register_group_1->Set(offset, data);
    }

    return true;
}
#pragma CTC ENDSKIP

bool rbk_reg_model::RbkAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write) {
    uint32_t offset, operation_enable_offset;
    uint32_t rdata = 0;
    uint32_t producer_pointer;

    offset                  = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    operation_enable_offset = REG_off(NVDLA_RBK_D_OP_ENABLE);
    producer_pointer = rbk_register_group_0->rS_POINTER.uPRODUCER();

    if (is_write) { // Write Request
        if (offset >= operation_enable_offset) { // Registers with dual entities
            // Get producer point value
            if ( 0 == producer_pointer ) {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (rbk_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("rbk_reg_model::RbkAccessRegister, attent to write working group 0"));
                }
#pragma CTC ENDSKIP
                rbk_register_group_0->SetWritable(offset, data);
                if (rbk_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    event_rbk_reg_group_0_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "rbk_reg_model::RbkAccessRegister, notified op_en for group 0.\x0A"));
                }
            } else {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (rbk_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("rbk_reg_model::RbkAccessRegister, attent to write working group 1"));
                }
#pragma CTC ENDSKIP
                rbk_register_group_1->SetWritable(offset, data);
                if (rbk_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    event_rbk_reg_group_1_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "rbk_reg_model::RbkAccessRegister, notified op_en for group 1.\x0A"));
                }
            }
        } else { // Registers which have only one entity

            rbk_register_group_0->SetWritable(offset, data);
            rbk_register_group_1->SetWritable(offset, data);

        }
        // Write done
    } else { // Read Request
        if (offset >= operation_enable_offset) { // Register with shadow
            if ( 0 == producer_pointer ) {
                rbk_register_group_0->GetReadable(offset, &rdata);
            } else {
                rbk_register_group_1->GetReadable(offset, &rdata);
            }
        } else { // Register which have only one entity

            rbk_register_group_0->GetReadable(offset, &rdata);

        }
        data = rdata;
    }
    return true;
}

void rbk_reg_model::RbkRegReset() {
        rbk_register_group_0->ResetAll();
        rbk_register_group_1->ResetAll();

}

void rbk_reg_model::RbkUpdateVariables(CNVDLA_RBK_REGSET *reg_group_ptr) {
        rbk_status_0_ = reg_group_ptr->rS_STATUS.uSTATUS_0();
        rbk_status_1_ = reg_group_ptr->rS_STATUS.uSTATUS_1();
        rbk_producer_ = reg_group_ptr->rS_POINTER.uPRODUCER();
        rbk_consumer_ = reg_group_ptr->rS_POINTER.uCONSUMER();
        rbk_op_en_ = reg_group_ptr->rD_OP_ENABLE.uOP_EN();
        rbk_rubik_mode_ = reg_group_ptr->rD_MISC_CFG.uRUBIK_MODE();
        rbk_in_precision_ = reg_group_ptr->rD_MISC_CFG.uIN_PRECISION();
        rbk_datain_ram_type_ = reg_group_ptr->rD_DAIN_RAM_TYPE.uDATAIN_RAM_TYPE();
        rbk_datain_width_ = reg_group_ptr->rD_DATAIN_SIZE_0.uDATAIN_WIDTH();
        rbk_datain_height_ = reg_group_ptr->rD_DATAIN_SIZE_0.uDATAIN_HEIGHT();
        rbk_datain_channel_ = reg_group_ptr->rD_DATAIN_SIZE_1.uDATAIN_CHANNEL();
        rbk_dain_addr_high_ = reg_group_ptr->rD_DAIN_ADDR_HIGH.uDAIN_ADDR_HIGH();
        rbk_dain_addr_low_ = reg_group_ptr->rD_DAIN_ADDR_LOW.uDAIN_ADDR_LOW();
        rbk_dain_line_stride_ = reg_group_ptr->rD_DAIN_LINE_STRIDE.uDAIN_LINE_STRIDE();
        rbk_dain_surf_stride_ = reg_group_ptr->rD_DAIN_SURF_STRIDE.uDAIN_SURF_STRIDE();
        rbk_dain_planar_stride_ = reg_group_ptr->rD_DAIN_PLANAR_STRIDE.uDAIN_PLANAR_STRIDE();
        rbk_dataout_ram_type_ = reg_group_ptr->rD_DAOUT_RAM_TYPE.uDATAOUT_RAM_TYPE();
        rbk_dataout_channel_ = reg_group_ptr->rD_DATAOUT_SIZE_1.uDATAOUT_CHANNEL();
        rbk_daout_addr_high_ = reg_group_ptr->rD_DAOUT_ADDR_HIGH.uDAOUT_ADDR_HIGH();
        rbk_daout_addr_low_ = reg_group_ptr->rD_DAOUT_ADDR_LOW.uDAOUT_ADDR_LOW();
        rbk_daout_line_stride_ = reg_group_ptr->rD_DAOUT_LINE_STRIDE.uDAOUT_LINE_STRIDE();
        rbk_contract_stride_0_ = reg_group_ptr->rD_CONTRACT_STRIDE_0.uCONTRACT_STRIDE_0();
        rbk_contract_stride_1_ = reg_group_ptr->rD_CONTRACT_STRIDE_1.uCONTRACT_STRIDE_1();
        rbk_daout_surf_stride_ = reg_group_ptr->rD_DAOUT_SURF_STRIDE.uDAOUT_SURF_STRIDE();
        rbk_daout_planar_stride_ = reg_group_ptr->rD_DAOUT_PLANAR_STRIDE.uDAOUT_PLANAR_STRIDE();
        rbk_deconv_x_stride_ = reg_group_ptr->rD_DECONV_STRIDE.uDECONV_X_STRIDE();
        rbk_deconv_y_stride_ = reg_group_ptr->rD_DECONV_STRIDE.uDECONV_Y_STRIDE();
        rbk_perf_en_ = reg_group_ptr->rD_PERF_ENABLE.uPERF_EN();
        rbk_rd_stall_cnt_ = reg_group_ptr->rD_PERF_READ_STALL.uRD_STALL_CNT();
        rbk_wr_stall_cnt_ = reg_group_ptr->rD_PERF_WRITE_STALL.uWR_STALL_CNT();

}

void rbk_reg_model::RbkClearOpeartionEnable(CNVDLA_RBK_REGSET *reg_group_ptr){
    reg_group_ptr->rD_OP_ENABLE.uOP_EN(NVDLA_RBK_D_OP_ENABLE_0_OP_EN_DISABLE);
    RbkIncreaseConsumerPointer();
}

uint32_t rbk_reg_model::RbkGetOpeartionEnable(CNVDLA_RBK_REGSET *reg_group_ptr){
    return reg_group_ptr->rD_OP_ENABLE.uOP_EN();
}

void rbk_reg_model::RbkIncreaseConsumerPointer(){
    uint32_t consumer_pointer;
    consumer_pointer = (rbk_register_group_0->rS_POINTER.uCONSUMER() == 0) ? 1 : 0;
    rbk_register_group_0->rS_POINTER.uCONSUMER( consumer_pointer );
    rbk_register_group_1->rS_POINTER.uCONSUMER( consumer_pointer );
}

void rbk_reg_model::RbkUpdateWorkingStatus(uint32_t group_id, uint32_t status){
    switch (group_id) {
        case 0:
            rbk_register_group_0->rS_STATUS.uSTATUS_0(status);
            break;
        case 1:
            rbk_register_group_0->rS_STATUS.uSTATUS_1(status);
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    } 
}
