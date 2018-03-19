// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: pdp_reg_model.cpp

#include "pdp_reg_model.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define NVDLA_PDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD (1<<17)
#define NVDLA_PDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT 17

#pragma CTC SKIP
SCSIM_NAMESPACE_START(cmod)
    MK_UREGSET_CLASS(NVDLA_PDP)
SCSIM_NAMESPACE_END()
#pragma CTC ENDSKIP

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
    using namespace tlm;
    using namespace sc_core;

pdp_reg_model::pdp_reg_model() {
    pdp_register_group_0 = new CNVDLA_PDP_REGSET;
    pdp_register_group_1 = new CNVDLA_PDP_REGSET;
    ////LUT_COMMENT pdp_lut = new NvdlaLut;
    PdpRegReset();
}

#pragma CTC SKIP
pdp_reg_model::~pdp_reg_model() {
    delete pdp_register_group_0;
    delete pdp_register_group_1;
    ////LUT_COMMENT delete pdp_lut;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
bool pdp_reg_model::PdpUpdateStatusRegister(uint32_t reg_addr, uint8_t group, uint32_t data) {
    uint32_t offset;

    offset = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    // Get producer point value
    if ( 0 == group ) {
        // The invertion of valid bit served as write enable
        pdp_register_group_0->Set(offset, data);
    } else {
        // The invertion of valid bit served as write enable
        pdp_register_group_1->Set(offset, data);
    }

    return true;
}
#pragma CTC ENDSKIP

bool pdp_reg_model::PdpAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write) {
    uint32_t offset, operation_enable_offset;
    uint32_t rdata = 0;
    uint32_t producer_pointer;

    offset                  = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    operation_enable_offset = REG_off(NVDLA_PDP_D_OP_ENABLE);
    producer_pointer = pdp_register_group_0->rS_POINTER.uPRODUCER();

    if (is_write) { // Write Request
        if (offset >= operation_enable_offset) { // Registers with dual entities
            // Get producer point value
            if ( 0 == producer_pointer ) {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (pdp_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("pdp_reg_model::PdpAccessRegister, attent to write working group 0"));
                }
#pragma CTC ENDSKIP
                pdp_register_group_0->SetWritable(offset, data);
                if (pdp_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    event_pdp_reg_group_0_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "pdp_reg_model::PdpAccessRegister, notified op_en for group 0.\x0A"));
                }
            } else {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (pdp_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("pdp_reg_model::PdpAccessRegister, attent to write working group 1"));
                }
#pragma CTC ENDSKIP
                pdp_register_group_1->SetWritable(offset, data);
                if (pdp_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    event_pdp_reg_group_1_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "pdp_reg_model::PdpAccessRegister, notified op_en for group 1.\x0A"));
                }
            }
        } else { // Registers which have only one entity

            pdp_register_group_0->SetWritable(offset, data);
            pdp_register_group_1->SetWritable(offset, data);

        }
        // Write done
    } else { // Read Request
        if (offset >= operation_enable_offset) { // Register with shadow
            if ( 0 == producer_pointer ) {
                pdp_register_group_0->GetReadable(offset, &rdata);
            } else {
                pdp_register_group_1->GetReadable(offset, &rdata);
            }
        } else { // Register which have only one entity

            pdp_register_group_0->GetReadable(offset, &rdata);

        }
        data = rdata;
    }
    return true;
}

void pdp_reg_model::PdpRegReset() {
        pdp_register_group_0->ResetAll();
        pdp_register_group_1->ResetAll();

}

void pdp_reg_model::PdpUpdateVariables(CNVDLA_PDP_REGSET *reg_group_ptr) {
        pdp_status_0_ = reg_group_ptr->rS_STATUS.uSTATUS_0();
        pdp_status_1_ = reg_group_ptr->rS_STATUS.uSTATUS_1();
        pdp_producer_ = reg_group_ptr->rS_POINTER.uPRODUCER();
        pdp_consumer_ = reg_group_ptr->rS_POINTER.uCONSUMER();
        pdp_op_en_ = reg_group_ptr->rD_OP_ENABLE.uOP_EN();
        pdp_cube_in_width_ = reg_group_ptr->rD_DATA_CUBE_IN_WIDTH.uCUBE_IN_WIDTH();
        pdp_cube_in_height_ = reg_group_ptr->rD_DATA_CUBE_IN_HEIGHT.uCUBE_IN_HEIGHT();
        pdp_cube_in_channel_ = reg_group_ptr->rD_DATA_CUBE_IN_CHANNEL.uCUBE_IN_CHANNEL();
        pdp_cube_out_width_ = reg_group_ptr->rD_DATA_CUBE_OUT_WIDTH.uCUBE_OUT_WIDTH();
        pdp_cube_out_height_ = reg_group_ptr->rD_DATA_CUBE_OUT_HEIGHT.uCUBE_OUT_HEIGHT();
        pdp_cube_out_channel_ = reg_group_ptr->rD_DATA_CUBE_OUT_CHANNEL.uCUBE_OUT_CHANNEL();
        pdp_pooling_method_ = reg_group_ptr->rD_OPERATION_MODE_CFG.uPOOLING_METHOD();
        pdp_flying_mode_ = reg_group_ptr->rD_OPERATION_MODE_CFG.uFLYING_MODE();
        pdp_split_num_ = reg_group_ptr->rD_OPERATION_MODE_CFG.uSPLIT_NUM();
        pdp_nan_to_zero_ = reg_group_ptr->rD_NAN_FLUSH_TO_ZERO.uNAN_TO_ZERO();
        pdp_partial_width_in_first_ = reg_group_ptr->rD_PARTIAL_WIDTH_IN.uPARTIAL_WIDTH_IN_FIRST();
        pdp_partial_width_in_last_ = reg_group_ptr->rD_PARTIAL_WIDTH_IN.uPARTIAL_WIDTH_IN_LAST();
        pdp_partial_width_in_mid_ = reg_group_ptr->rD_PARTIAL_WIDTH_IN.uPARTIAL_WIDTH_IN_MID();
        pdp_partial_width_out_first_ = reg_group_ptr->rD_PARTIAL_WIDTH_OUT.uPARTIAL_WIDTH_OUT_FIRST();
        pdp_partial_width_out_last_ = reg_group_ptr->rD_PARTIAL_WIDTH_OUT.uPARTIAL_WIDTH_OUT_LAST();
        pdp_partial_width_out_mid_ = reg_group_ptr->rD_PARTIAL_WIDTH_OUT.uPARTIAL_WIDTH_OUT_MID();
        pdp_kernel_width_ = reg_group_ptr->rD_POOLING_KERNEL_CFG.uKERNEL_WIDTH();
        pdp_kernel_height_ = reg_group_ptr->rD_POOLING_KERNEL_CFG.uKERNEL_HEIGHT();
        pdp_kernel_stride_width_ = reg_group_ptr->rD_POOLING_KERNEL_CFG.uKERNEL_STRIDE_WIDTH();
        pdp_kernel_stride_height_ = reg_group_ptr->rD_POOLING_KERNEL_CFG.uKERNEL_STRIDE_HEIGHT();
        pdp_recip_kernel_width_ = reg_group_ptr->rD_RECIP_KERNEL_WIDTH.uRECIP_KERNEL_WIDTH();
        pdp_recip_kernel_height_ = reg_group_ptr->rD_RECIP_KERNEL_HEIGHT.uRECIP_KERNEL_HEIGHT();
        pdp_pad_left_ = reg_group_ptr->rD_POOLING_PADDING_CFG.uPAD_LEFT();
        pdp_pad_top_ = reg_group_ptr->rD_POOLING_PADDING_CFG.uPAD_TOP();
        pdp_pad_right_ = reg_group_ptr->rD_POOLING_PADDING_CFG.uPAD_RIGHT();
        pdp_pad_bottom_ = reg_group_ptr->rD_POOLING_PADDING_CFG.uPAD_BOTTOM();
        pdp_pad_value_1x_ = reg_group_ptr->rD_POOLING_PADDING_VALUE_1_CFG.uPAD_VALUE_1X();
        pdp_pad_value_2x_ = reg_group_ptr->rD_POOLING_PADDING_VALUE_2_CFG.uPAD_VALUE_2X();
        pdp_pad_value_3x_ = reg_group_ptr->rD_POOLING_PADDING_VALUE_3_CFG.uPAD_VALUE_3X();
        pdp_pad_value_4x_ = reg_group_ptr->rD_POOLING_PADDING_VALUE_4_CFG.uPAD_VALUE_4X();
        pdp_pad_value_5x_ = reg_group_ptr->rD_POOLING_PADDING_VALUE_5_CFG.uPAD_VALUE_5X();
        pdp_pad_value_6x_ = reg_group_ptr->rD_POOLING_PADDING_VALUE_6_CFG.uPAD_VALUE_6X();
        pdp_pad_value_7x_ = reg_group_ptr->rD_POOLING_PADDING_VALUE_7_CFG.uPAD_VALUE_7X();
        pdp_src_base_addr_low_ = reg_group_ptr->rD_SRC_BASE_ADDR_LOW.uSRC_BASE_ADDR_LOW();
        pdp_src_base_addr_high_ = reg_group_ptr->rD_SRC_BASE_ADDR_HIGH.uSRC_BASE_ADDR_HIGH();
        pdp_src_line_stride_ = reg_group_ptr->rD_SRC_LINE_STRIDE.uSRC_LINE_STRIDE();
        pdp_src_surface_stride_ = reg_group_ptr->rD_SRC_SURFACE_STRIDE.uSRC_SURFACE_STRIDE();
        pdp_dst_base_addr_low_ = reg_group_ptr->rD_DST_BASE_ADDR_LOW.uDST_BASE_ADDR_LOW();
        pdp_dst_base_addr_high_ = reg_group_ptr->rD_DST_BASE_ADDR_HIGH.uDST_BASE_ADDR_HIGH();
        pdp_dst_line_stride_ = reg_group_ptr->rD_DST_LINE_STRIDE.uDST_LINE_STRIDE();
        pdp_dst_surface_stride_ = reg_group_ptr->rD_DST_SURFACE_STRIDE.uDST_SURFACE_STRIDE();
        pdp_dst_ram_type_ = reg_group_ptr->rD_DST_RAM_CFG.uDST_RAM_TYPE();
        pdp_input_data_ = reg_group_ptr->rD_DATA_FORMAT.uINPUT_DATA();
        pdp_inf_input_num_ = reg_group_ptr->rD_INF_INPUT_NUM.uINF_INPUT_NUM();
        pdp_nan_input_num_ = reg_group_ptr->rD_NAN_INPUT_NUM.uNAN_INPUT_NUM();
        pdp_nan_output_num_ = reg_group_ptr->rD_NAN_OUTPUT_NUM.uNAN_OUTPUT_NUM();
        pdp_dma_en_ = reg_group_ptr->rD_PERF_ENABLE.uDMA_EN();
        pdp_perf_write_stall_ = reg_group_ptr->rD_PERF_WRITE_STALL.uPERF_WRITE_STALL();
        pdp_cya_ = reg_group_ptr->rD_CYA.uCYA();

}

void pdp_reg_model::PdpClearOpeartionEnable(CNVDLA_PDP_REGSET *reg_group_ptr){
    reg_group_ptr->rD_OP_ENABLE.uOP_EN(NVDLA_PDP_D_OP_ENABLE_0_OP_EN_DISABLE);
    PdpIncreaseConsumerPointer();
}

uint32_t pdp_reg_model::PdpGetOpeartionEnable(CNVDLA_PDP_REGSET *reg_group_ptr){
    return reg_group_ptr->rD_OP_ENABLE.uOP_EN();
}

void pdp_reg_model::PdpIncreaseConsumerPointer(){
    uint32_t consumer_pointer;
    consumer_pointer = (pdp_register_group_0->rS_POINTER.uCONSUMER() == 0) ? 1 : 0;
    pdp_register_group_0->rS_POINTER.uCONSUMER( consumer_pointer );
    pdp_register_group_1->rS_POINTER.uCONSUMER( consumer_pointer );
}

void pdp_reg_model::PdpUpdateWorkingStatus(uint32_t group_id, uint32_t status){
    switch (group_id) {
        case 0:
            pdp_register_group_0->rS_STATUS.uSTATUS_0(status);
            break;
        case 1:
            pdp_register_group_0->rS_STATUS.uSTATUS_1(status);
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    } 
}
