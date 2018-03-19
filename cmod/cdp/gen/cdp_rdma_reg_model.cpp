// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_rdma_reg_model.cpp

#include "cdp_rdma_reg_model.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define NVDLA_CDP_RDMA_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD (1<<17)
#define NVDLA_CDP_RDMA_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT 17

#pragma CTC SKIP
SCSIM_NAMESPACE_START(cmod)
    MK_UREGSET_CLASS(NVDLA_CDP_RDMA)
SCSIM_NAMESPACE_END()
#pragma CTC ENDSKIP

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
    using namespace tlm;
    using namespace sc_core;

cdp_rdma_reg_model::cdp_rdma_reg_model() {
    cdp_rdma_register_group_0 = new CNVDLA_CDP_RDMA_REGSET;
    cdp_rdma_register_group_1 = new CNVDLA_CDP_RDMA_REGSET;
    ////LUT_COMMENT cdp_rdma_lut = new NvdlaLut;
    CdpRdmaRegReset();
}

#pragma CTC SKIP
cdp_rdma_reg_model::~cdp_rdma_reg_model() {
    delete cdp_rdma_register_group_0;
    delete cdp_rdma_register_group_1;
    ////LUT_COMMENT delete cdp_rdma_lut;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
bool cdp_rdma_reg_model::CdpRdmaUpdateStatusRegister(uint32_t reg_addr, uint8_t group, uint32_t data) {
    uint32_t offset;

    offset = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    // Get producer point value
    if ( 0 == group ) {
        // The invertion of valid bit served as write enable
        cdp_rdma_register_group_0->Set(offset, data);
    } else {
        // The invertion of valid bit served as write enable
        cdp_rdma_register_group_1->Set(offset, data);
    }

    return true;
}
#pragma CTC ENDSKIP

bool cdp_rdma_reg_model::CdpRdmaAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write) {
    uint32_t offset, operation_enable_offset;
    uint32_t rdata = 0;
    uint32_t producer_pointer;

    offset                  = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    operation_enable_offset = REG_off(NVDLA_CDP_RDMA_D_OP_ENABLE);
    producer_pointer = cdp_rdma_register_group_0->rS_POINTER.uPRODUCER();

    if (is_write) { // Write Request
        if (offset >= operation_enable_offset) { // Registers with dual entities
            // Get producer point value
            if ( 0 == producer_pointer ) {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (cdp_rdma_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("cdp_rdma_reg_model::CdpRdmaAccessRegister, attent to write working group 0"));
                }
#pragma CTC ENDSKIP
                cdp_rdma_register_group_0->SetWritable(offset, data);
                if (cdp_rdma_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    event_cdp_rdma_reg_group_0_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "cdp_rdma_reg_model::CdpRdmaAccessRegister, notified op_en for group 0.\x0A"));
                }
            } else {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (cdp_rdma_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("cdp_rdma_reg_model::CdpRdmaAccessRegister, attent to write working group 1"));
                }
#pragma CTC ENDSKIP
                cdp_rdma_register_group_1->SetWritable(offset, data);
                if (cdp_rdma_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    event_cdp_rdma_reg_group_1_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "cdp_rdma_reg_model::CdpRdmaAccessRegister, notified op_en for group 1.\x0A"));
                }
            }
        } else { // Registers which have only one entity

            cdp_rdma_register_group_0->SetWritable(offset, data);
            cdp_rdma_register_group_1->SetWritable(offset, data);

        }
        // Write done
    } else { // Read Request
        if (offset >= operation_enable_offset) { // Register with shadow
            if ( 0 == producer_pointer ) {
                cdp_rdma_register_group_0->GetReadable(offset, &rdata);
            } else {
                cdp_rdma_register_group_1->GetReadable(offset, &rdata);
            }
        } else { // Register which have only one entity

            cdp_rdma_register_group_0->GetReadable(offset, &rdata);

        }
        data = rdata;
    }
    return true;
}

void cdp_rdma_reg_model::CdpRdmaRegReset() {
        cdp_rdma_register_group_0->ResetAll();
        cdp_rdma_register_group_1->ResetAll();

}

void cdp_rdma_reg_model::CdpRdmaUpdateVariables(CNVDLA_CDP_RDMA_REGSET *reg_group_ptr) {
        cdp_rdma_status_0_ = reg_group_ptr->rS_STATUS.uSTATUS_0();
        cdp_rdma_status_1_ = reg_group_ptr->rS_STATUS.uSTATUS_1();
        cdp_rdma_producer_ = reg_group_ptr->rS_POINTER.uPRODUCER();
        cdp_rdma_consumer_ = reg_group_ptr->rS_POINTER.uCONSUMER();
        cdp_rdma_op_en_ = reg_group_ptr->rD_OP_ENABLE.uOP_EN();
        cdp_rdma_width_ = reg_group_ptr->rD_DATA_CUBE_WIDTH.uWIDTH();
        cdp_rdma_height_ = reg_group_ptr->rD_DATA_CUBE_HEIGHT.uHEIGHT();
        cdp_rdma_channel_ = reg_group_ptr->rD_DATA_CUBE_CHANNEL.uCHANNEL();
        cdp_rdma_src_base_addr_low_ = reg_group_ptr->rD_SRC_BASE_ADDR_LOW.uSRC_BASE_ADDR_LOW();
        cdp_rdma_src_base_addr_high_ = reg_group_ptr->rD_SRC_BASE_ADDR_HIGH.uSRC_BASE_ADDR_HIGH();
        cdp_rdma_src_line_stride_ = reg_group_ptr->rD_SRC_LINE_STRIDE.uSRC_LINE_STRIDE();
        cdp_rdma_src_surface_stride_ = reg_group_ptr->rD_SRC_SURFACE_STRIDE.uSRC_SURFACE_STRIDE();
        cdp_rdma_src_ram_type_ = reg_group_ptr->rD_SRC_DMA_CFG.uSRC_RAM_TYPE();
        cdp_rdma_src_compression_en_ = reg_group_ptr->rD_SRC_COMPRESSION_EN.uSRC_COMPRESSION_EN();
        cdp_rdma_operation_mode_ = reg_group_ptr->rD_OPERATION_MODE.uOPERATION_MODE();
        cdp_rdma_input_data_ = reg_group_ptr->rD_DATA_FORMAT.uINPUT_DATA();
        cdp_rdma_dma_en_ = reg_group_ptr->rD_PERF_ENABLE.uDMA_EN();
        cdp_rdma_perf_read_stall_ = reg_group_ptr->rD_PERF_READ_STALL.uPERF_READ_STALL();
        cdp_rdma_cya_ = reg_group_ptr->rD_CYA.uCYA();

}

void cdp_rdma_reg_model::CdpRdmaClearOpeartionEnable(CNVDLA_CDP_RDMA_REGSET *reg_group_ptr){
    reg_group_ptr->rD_OP_ENABLE.uOP_EN(NVDLA_CDP_RDMA_D_OP_ENABLE_0_OP_EN_DISABLE);
    CdpRdmaIncreaseConsumerPointer();
}

uint32_t cdp_rdma_reg_model::CdpRdmaGetOpeartionEnable(CNVDLA_CDP_RDMA_REGSET *reg_group_ptr){
    return reg_group_ptr->rD_OP_ENABLE.uOP_EN();
}

void cdp_rdma_reg_model::CdpRdmaIncreaseConsumerPointer(){
    uint32_t consumer_pointer;
    consumer_pointer = (cdp_rdma_register_group_0->rS_POINTER.uCONSUMER() == 0) ? 1 : 0;
    cdp_rdma_register_group_0->rS_POINTER.uCONSUMER( consumer_pointer );
    cdp_rdma_register_group_1->rS_POINTER.uCONSUMER( consumer_pointer );
}

void cdp_rdma_reg_model::CdpRdmaUpdateWorkingStatus(uint32_t group_id, uint32_t status){
    switch (group_id) {
        case 0:
            cdp_rdma_register_group_0->rS_STATUS.uSTATUS_0(status);
            break;
        case 1:
            cdp_rdma_register_group_0->rS_STATUS.uSTATUS_1(status);
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    } 
}
