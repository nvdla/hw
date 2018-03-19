// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: pdp_rdma_reg_model.cpp

#include "pdp_rdma_reg_model.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define NVDLA_PDP_RDMA_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD (1<<17)
#define NVDLA_PDP_RDMA_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT 17

#pragma CTC SKIP
SCSIM_NAMESPACE_START(cmod)
    MK_UREGSET_CLASS(NVDLA_PDP_RDMA)
SCSIM_NAMESPACE_END()
#pragma CTC ENDSKIP

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
    using namespace tlm;
    using namespace sc_core;

pdp_rdma_reg_model::pdp_rdma_reg_model() {
    pdp_rdma_register_group_0 = new CNVDLA_PDP_RDMA_REGSET;
    pdp_rdma_register_group_1 = new CNVDLA_PDP_RDMA_REGSET;
    ////LUT_COMMENT pdp_rdma_lut = new NvdlaLut;
    PdpRdmaRegReset();
}

#pragma CTC SKIP
pdp_rdma_reg_model::~pdp_rdma_reg_model() {
    delete pdp_rdma_register_group_0;
    delete pdp_rdma_register_group_1;
    ////LUT_COMMENT delete pdp_rdma_lut;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
bool pdp_rdma_reg_model::PdpRdmaUpdateStatusRegister(uint32_t reg_addr, uint8_t group, uint32_t data) {
    uint32_t offset;

    offset = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    // Get producer point value
    if ( 0 == group ) {
        // The invertion of valid bit served as write enable
        pdp_rdma_register_group_0->Set(offset, data);
    } else {
        // The invertion of valid bit served as write enable
        pdp_rdma_register_group_1->Set(offset, data);
    }

    return true;
}
#pragma CTC ENDSKIP

bool pdp_rdma_reg_model::PdpRdmaAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write) {
    uint32_t offset, operation_enable_offset;
    uint32_t rdata = 0;
    uint32_t producer_pointer;

    offset                  = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    operation_enable_offset = REG_off(NVDLA_PDP_RDMA_D_OP_ENABLE);
    producer_pointer = pdp_rdma_register_group_0->rS_POINTER.uPRODUCER();

    if (is_write) { // Write Request
        if (offset >= operation_enable_offset) { // Registers with dual entities
            // Get producer point value
            if ( 0 == producer_pointer ) {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (pdp_rdma_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("pdp_rdma_reg_model::PdpRdmaAccessRegister, attent to write working group 0"));
                }
#pragma CTC ENDSKIP
                pdp_rdma_register_group_0->SetWritable(offset, data);
                if (pdp_rdma_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    event_pdp_rdma_reg_group_0_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "pdp_rdma_reg_model::PdpRdmaAccessRegister, notified op_en for group 0.\x0A"));
                }
            } else {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (pdp_rdma_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("pdp_rdma_reg_model::PdpRdmaAccessRegister, attent to write working group 1"));
                }
#pragma CTC ENDSKIP
                pdp_rdma_register_group_1->SetWritable(offset, data);
                if (pdp_rdma_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    event_pdp_rdma_reg_group_1_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "pdp_rdma_reg_model::PdpRdmaAccessRegister, notified op_en for group 1.\x0A"));
                }
            }
        } else { // Registers which have only one entity

            pdp_rdma_register_group_0->SetWritable(offset, data);
            pdp_rdma_register_group_1->SetWritable(offset, data);

        }
        // Write done
    } else { // Read Request
        if (offset >= operation_enable_offset) { // Register with shadow
            if ( 0 == producer_pointer ) {
                pdp_rdma_register_group_0->GetReadable(offset, &rdata);
            } else {
                pdp_rdma_register_group_1->GetReadable(offset, &rdata);
            }
        } else { // Register which have only one entity

            pdp_rdma_register_group_0->GetReadable(offset, &rdata);

        }
        data = rdata;
    }
    return true;
}

void pdp_rdma_reg_model::PdpRdmaRegReset() {
        pdp_rdma_register_group_0->ResetAll();
        pdp_rdma_register_group_1->ResetAll();

}

void pdp_rdma_reg_model::PdpRdmaUpdateVariables(CNVDLA_PDP_RDMA_REGSET *reg_group_ptr) {
        pdp_rdma_status_0_ = reg_group_ptr->rS_STATUS.uSTATUS_0();
        pdp_rdma_status_1_ = reg_group_ptr->rS_STATUS.uSTATUS_1();
        pdp_rdma_producer_ = reg_group_ptr->rS_POINTER.uPRODUCER();
        pdp_rdma_consumer_ = reg_group_ptr->rS_POINTER.uCONSUMER();
        pdp_rdma_op_en_ = reg_group_ptr->rD_OP_ENABLE.uOP_EN();
        pdp_rdma_cube_in_width_ = reg_group_ptr->rD_DATA_CUBE_IN_WIDTH.uCUBE_IN_WIDTH();
        pdp_rdma_cube_in_height_ = reg_group_ptr->rD_DATA_CUBE_IN_HEIGHT.uCUBE_IN_HEIGHT();
        pdp_rdma_cube_in_channel_ = reg_group_ptr->rD_DATA_CUBE_IN_CHANNEL.uCUBE_IN_CHANNEL();
        pdp_rdma_flying_mode_ = reg_group_ptr->rD_FLYING_MODE.uFLYING_MODE();
        pdp_rdma_src_base_addr_low_ = reg_group_ptr->rD_SRC_BASE_ADDR_LOW.uSRC_BASE_ADDR_LOW();
        pdp_rdma_src_base_addr_high_ = reg_group_ptr->rD_SRC_BASE_ADDR_HIGH.uSRC_BASE_ADDR_HIGH();
        pdp_rdma_src_line_stride_ = reg_group_ptr->rD_SRC_LINE_STRIDE.uSRC_LINE_STRIDE();
        pdp_rdma_src_surface_stride_ = reg_group_ptr->rD_SRC_SURFACE_STRIDE.uSRC_SURFACE_STRIDE();
        pdp_rdma_src_ram_type_ = reg_group_ptr->rD_SRC_RAM_CFG.uSRC_RAM_TYPE();
        pdp_rdma_input_data_ = reg_group_ptr->rD_DATA_FORMAT.uINPUT_DATA();
        pdp_rdma_split_num_ = reg_group_ptr->rD_OPERATION_MODE_CFG.uSPLIT_NUM();
        pdp_rdma_kernel_width_ = reg_group_ptr->rD_POOLING_KERNEL_CFG.uKERNEL_WIDTH();
        pdp_rdma_kernel_stride_width_ = reg_group_ptr->rD_POOLING_KERNEL_CFG.uKERNEL_STRIDE_WIDTH();
        pdp_rdma_pad_width_ = reg_group_ptr->rD_POOLING_PADDING_CFG.uPAD_WIDTH();
        pdp_rdma_partial_width_in_first_ = reg_group_ptr->rD_PARTIAL_WIDTH_IN.uPARTIAL_WIDTH_IN_FIRST();
        pdp_rdma_partial_width_in_last_ = reg_group_ptr->rD_PARTIAL_WIDTH_IN.uPARTIAL_WIDTH_IN_LAST();
        pdp_rdma_partial_width_in_mid_ = reg_group_ptr->rD_PARTIAL_WIDTH_IN.uPARTIAL_WIDTH_IN_MID();
        pdp_rdma_dma_en_ = reg_group_ptr->rD_PERF_ENABLE.uDMA_EN();
        pdp_rdma_perf_read_stall_ = reg_group_ptr->rD_PERF_READ_STALL.uPERF_READ_STALL();
        pdp_rdma_cya_ = reg_group_ptr->rD_CYA.uCYA();

}

void pdp_rdma_reg_model::PdpRdmaClearOpeartionEnable(CNVDLA_PDP_RDMA_REGSET *reg_group_ptr){
    reg_group_ptr->rD_OP_ENABLE.uOP_EN(NVDLA_PDP_RDMA_D_OP_ENABLE_0_OP_EN_DISABLE);
    PdpRdmaIncreaseConsumerPointer();
}

uint32_t pdp_rdma_reg_model::PdpRdmaGetOpeartionEnable(CNVDLA_PDP_RDMA_REGSET *reg_group_ptr){
    return reg_group_ptr->rD_OP_ENABLE.uOP_EN();
}

void pdp_rdma_reg_model::PdpRdmaIncreaseConsumerPointer(){
    uint32_t consumer_pointer;
    consumer_pointer = (pdp_rdma_register_group_0->rS_POINTER.uCONSUMER() == 0) ? 1 : 0;
    pdp_rdma_register_group_0->rS_POINTER.uCONSUMER( consumer_pointer );
    pdp_rdma_register_group_1->rS_POINTER.uCONSUMER( consumer_pointer );
}

void pdp_rdma_reg_model::PdpRdmaUpdateWorkingStatus(uint32_t group_id, uint32_t status){
    switch (group_id) {
        case 0:
            pdp_rdma_register_group_0->rS_STATUS.uSTATUS_0(status);
            break;
        case 1:
            pdp_rdma_register_group_0->rS_STATUS.uSTATUS_1(status);
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    } 
}
