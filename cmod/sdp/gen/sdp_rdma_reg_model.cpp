// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_rdma_reg_model.cpp

#include "sdp_rdma_reg_model.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define NVDLA_SDP_RDMA_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD (1<<17)
#define NVDLA_SDP_RDMA_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT 17

#pragma CTC SKIP
SCSIM_NAMESPACE_START(cmod)
    MK_UREGSET_CLASS(NVDLA_SDP_RDMA)
SCSIM_NAMESPACE_END()
#pragma CTC ENDSKIP

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
    using namespace tlm;
    using namespace sc_core;

sdp_rdma_reg_model::sdp_rdma_reg_model() {
    sdp_rdma_register_group_0 = new CNVDLA_SDP_RDMA_REGSET;
    sdp_rdma_register_group_1 = new CNVDLA_SDP_RDMA_REGSET;
    ////LUT_COMMENT sdp_rdma_lut = new NvdlaLut;
    SdpRdmaRegReset();
}

#pragma CTC SKIP
sdp_rdma_reg_model::~sdp_rdma_reg_model() {
    delete sdp_rdma_register_group_0;
    delete sdp_rdma_register_group_1;
    ////LUT_COMMENT delete sdp_rdma_lut;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
bool sdp_rdma_reg_model::SdpRdmaUpdateStatusRegister(uint32_t reg_addr, uint8_t group, uint32_t data) {
    uint32_t offset;

    offset = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    // Get producer point value
    if ( 0 == group ) {
        // The invertion of valid bit served as write enable
        sdp_rdma_register_group_0->Set(offset, data);
    } else {
        // The invertion of valid bit served as write enable
        sdp_rdma_register_group_1->Set(offset, data);
    }

    return true;
}
#pragma CTC ENDSKIP

bool sdp_rdma_reg_model::SdpRdmaAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write) {
    uint32_t offset, operation_enable_offset;
    uint32_t rdata = 0;
    uint32_t producer_pointer;

    offset                  = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    operation_enable_offset = REG_off(NVDLA_SDP_RDMA_D_OP_ENABLE);
    producer_pointer = sdp_rdma_register_group_0->rS_POINTER.uPRODUCER();

    if (is_write) { // Write Request
        if (offset >= operation_enable_offset) { // Registers with dual entities
            // Get producer point value
            if ( 0 == producer_pointer ) {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (sdp_rdma_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("sdp_rdma_reg_model::SdpRdmaAccessRegister, attent to write working group 0"));
                }
#pragma CTC ENDSKIP
                sdp_rdma_register_group_0->SetWritable(offset, data);
                if (sdp_rdma_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    event_sdp_rdma_reg_group_0_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "sdp_rdma_reg_model::SdpRdmaAccessRegister, notified op_en for group 0.\x0A"));
                }
            } else {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (sdp_rdma_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("sdp_rdma_reg_model::SdpRdmaAccessRegister, attent to write working group 1"));
                }
#pragma CTC ENDSKIP
                sdp_rdma_register_group_1->SetWritable(offset, data);
                if (sdp_rdma_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    event_sdp_rdma_reg_group_1_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "sdp_rdma_reg_model::SdpRdmaAccessRegister, notified op_en for group 1.\x0A"));
                }
            }
        } else { // Registers which have only one entity

            sdp_rdma_register_group_0->SetWritable(offset, data);
            sdp_rdma_register_group_1->SetWritable(offset, data);

        }
        // Write done
    } else { // Read Request
        if (offset >= operation_enable_offset) { // Register with shadow
            if ( 0 == producer_pointer ) {
                sdp_rdma_register_group_0->GetReadable(offset, &rdata);
            } else {
                sdp_rdma_register_group_1->GetReadable(offset, &rdata);
            }
        } else { // Register which have only one entity

            sdp_rdma_register_group_0->GetReadable(offset, &rdata);

        }
        data = rdata;
    }
    return true;
}

void sdp_rdma_reg_model::SdpRdmaRegReset() {
        sdp_rdma_register_group_0->ResetAll();
        sdp_rdma_register_group_1->ResetAll();

}

void sdp_rdma_reg_model::SdpRdmaUpdateVariables(CNVDLA_SDP_RDMA_REGSET *reg_group_ptr) {
        sdp_rdma_status_0_ = reg_group_ptr->rS_STATUS.uSTATUS_0();
        sdp_rdma_status_1_ = reg_group_ptr->rS_STATUS.uSTATUS_1();
        sdp_rdma_producer_ = reg_group_ptr->rS_POINTER.uPRODUCER();
        sdp_rdma_consumer_ = reg_group_ptr->rS_POINTER.uCONSUMER();
        sdp_rdma_op_en_ = reg_group_ptr->rD_OP_ENABLE.uOP_EN();
        sdp_rdma_width_ = reg_group_ptr->rD_DATA_CUBE_WIDTH.uWIDTH();
        sdp_rdma_height_ = reg_group_ptr->rD_DATA_CUBE_HEIGHT.uHEIGHT();
        sdp_rdma_channel_ = reg_group_ptr->rD_DATA_CUBE_CHANNEL.uCHANNEL();
        sdp_rdma_src_base_addr_low_ = reg_group_ptr->rD_SRC_BASE_ADDR_LOW.uSRC_BASE_ADDR_LOW();
        sdp_rdma_src_base_addr_high_ = reg_group_ptr->rD_SRC_BASE_ADDR_HIGH.uSRC_BASE_ADDR_HIGH();
        sdp_rdma_src_line_stride_ = reg_group_ptr->rD_SRC_LINE_STRIDE.uSRC_LINE_STRIDE();
        sdp_rdma_src_surface_stride_ = reg_group_ptr->rD_SRC_SURFACE_STRIDE.uSRC_SURFACE_STRIDE();
        sdp_rdma_brdma_disable_ = reg_group_ptr->rD_BRDMA_CFG.uBRDMA_DISABLE();
        sdp_rdma_brdma_data_use_ = reg_group_ptr->rD_BRDMA_CFG.uBRDMA_DATA_USE();
        sdp_rdma_brdma_data_size_ = reg_group_ptr->rD_BRDMA_CFG.uBRDMA_DATA_SIZE();
        sdp_rdma_brdma_data_mode_ = reg_group_ptr->rD_BRDMA_CFG.uBRDMA_DATA_MODE();
        sdp_rdma_brdma_ram_type_ = reg_group_ptr->rD_BRDMA_CFG.uBRDMA_RAM_TYPE();
        sdp_rdma_bs_base_addr_low_ = reg_group_ptr->rD_BS_BASE_ADDR_LOW.uBS_BASE_ADDR_LOW();
        sdp_rdma_bs_base_addr_high_ = reg_group_ptr->rD_BS_BASE_ADDR_HIGH.uBS_BASE_ADDR_HIGH();
        sdp_rdma_bs_line_stride_ = reg_group_ptr->rD_BS_LINE_STRIDE.uBS_LINE_STRIDE();
        sdp_rdma_bs_surface_stride_ = reg_group_ptr->rD_BS_SURFACE_STRIDE.uBS_SURFACE_STRIDE();
        sdp_rdma_bs_batch_stride_ = reg_group_ptr->rD_BS_BATCH_STRIDE.uBS_BATCH_STRIDE();
        sdp_rdma_nrdma_disable_ = reg_group_ptr->rD_NRDMA_CFG.uNRDMA_DISABLE();
        sdp_rdma_nrdma_data_use_ = reg_group_ptr->rD_NRDMA_CFG.uNRDMA_DATA_USE();
        sdp_rdma_nrdma_data_size_ = reg_group_ptr->rD_NRDMA_CFG.uNRDMA_DATA_SIZE();
        sdp_rdma_nrdma_data_mode_ = reg_group_ptr->rD_NRDMA_CFG.uNRDMA_DATA_MODE();
        sdp_rdma_nrdma_ram_type_ = reg_group_ptr->rD_NRDMA_CFG.uNRDMA_RAM_TYPE();
        sdp_rdma_bn_base_addr_low_ = reg_group_ptr->rD_BN_BASE_ADDR_LOW.uBN_BASE_ADDR_LOW();
        sdp_rdma_bn_base_addr_high_ = reg_group_ptr->rD_BN_BASE_ADDR_HIGH.uBN_BASE_ADDR_HIGH();
        sdp_rdma_bn_line_stride_ = reg_group_ptr->rD_BN_LINE_STRIDE.uBN_LINE_STRIDE();
        sdp_rdma_bn_surface_stride_ = reg_group_ptr->rD_BN_SURFACE_STRIDE.uBN_SURFACE_STRIDE();
        sdp_rdma_bn_batch_stride_ = reg_group_ptr->rD_BN_BATCH_STRIDE.uBN_BATCH_STRIDE();
        sdp_rdma_erdma_disable_ = reg_group_ptr->rD_ERDMA_CFG.uERDMA_DISABLE();
        sdp_rdma_erdma_data_use_ = reg_group_ptr->rD_ERDMA_CFG.uERDMA_DATA_USE();
        sdp_rdma_erdma_data_size_ = reg_group_ptr->rD_ERDMA_CFG.uERDMA_DATA_SIZE();
        sdp_rdma_erdma_data_mode_ = reg_group_ptr->rD_ERDMA_CFG.uERDMA_DATA_MODE();
        sdp_rdma_erdma_ram_type_ = reg_group_ptr->rD_ERDMA_CFG.uERDMA_RAM_TYPE();
        sdp_rdma_ew_base_addr_low_ = reg_group_ptr->rD_EW_BASE_ADDR_LOW.uEW_BASE_ADDR_LOW();
        sdp_rdma_ew_base_addr_high_ = reg_group_ptr->rD_EW_BASE_ADDR_HIGH.uEW_BASE_ADDR_HIGH();
        sdp_rdma_ew_line_stride_ = reg_group_ptr->rD_EW_LINE_STRIDE.uEW_LINE_STRIDE();
        sdp_rdma_ew_surface_stride_ = reg_group_ptr->rD_EW_SURFACE_STRIDE.uEW_SURFACE_STRIDE();
        sdp_rdma_ew_batch_stride_ = reg_group_ptr->rD_EW_BATCH_STRIDE.uEW_BATCH_STRIDE();
        sdp_rdma_flying_mode_ = reg_group_ptr->rD_FEATURE_MODE_CFG.uFLYING_MODE();
        sdp_rdma_winograd_ = reg_group_ptr->rD_FEATURE_MODE_CFG.uWINOGRAD();
        sdp_rdma_in_precision_ = reg_group_ptr->rD_FEATURE_MODE_CFG.uIN_PRECISION();
        sdp_rdma_proc_precision_ = reg_group_ptr->rD_FEATURE_MODE_CFG.uPROC_PRECISION();
        sdp_rdma_out_precision_ = reg_group_ptr->rD_FEATURE_MODE_CFG.uOUT_PRECISION();
        sdp_rdma_batch_number_ = reg_group_ptr->rD_FEATURE_MODE_CFG.uBATCH_NUMBER();
        sdp_rdma_src_ram_type_ = reg_group_ptr->rD_SRC_DMA_CFG.uSRC_RAM_TYPE();
        sdp_rdma_status_nan_input_num_ = reg_group_ptr->rD_STATUS_NAN_INPUT_NUM.uSTATUS_NAN_INPUT_NUM();
        sdp_rdma_status_inf_input_num_ = reg_group_ptr->rD_STATUS_INF_INPUT_NUM.uSTATUS_INF_INPUT_NUM();
        sdp_rdma_perf_dma_en_ = reg_group_ptr->rD_PERF_ENABLE.uPERF_DMA_EN();
        sdp_rdma_perf_nan_inf_count_en_ = reg_group_ptr->rD_PERF_ENABLE.uPERF_NAN_INF_COUNT_EN();
        sdp_rdma_mrdma_stall_ = reg_group_ptr->rD_PERF_MRDMA_READ_STALL.uMRDMA_STALL();
        sdp_rdma_brdma_stall_ = reg_group_ptr->rD_PERF_BRDMA_READ_STALL.uBRDMA_STALL();
        sdp_rdma_nrdma_stall_ = reg_group_ptr->rD_PERF_NRDMA_READ_STALL.uNRDMA_STALL();
        sdp_rdma_erdma_stall_ = reg_group_ptr->rD_PERF_ERDMA_READ_STALL.uERDMA_STALL();

}

void sdp_rdma_reg_model::SdpRdmaClearOpeartionEnable(CNVDLA_SDP_RDMA_REGSET *reg_group_ptr){
    reg_group_ptr->rD_OP_ENABLE.uOP_EN(NVDLA_SDP_RDMA_D_OP_ENABLE_0_OP_EN_DISABLE);
    SdpRdmaIncreaseConsumerPointer();
}

uint32_t sdp_rdma_reg_model::SdpRdmaGetOpeartionEnable(CNVDLA_SDP_RDMA_REGSET *reg_group_ptr){
    return reg_group_ptr->rD_OP_ENABLE.uOP_EN();
}

void sdp_rdma_reg_model::SdpRdmaIncreaseConsumerPointer(){
    uint32_t consumer_pointer;
    consumer_pointer = (sdp_rdma_register_group_0->rS_POINTER.uCONSUMER() == 0) ? 1 : 0;
    sdp_rdma_register_group_0->rS_POINTER.uCONSUMER( consumer_pointer );
    sdp_rdma_register_group_1->rS_POINTER.uCONSUMER( consumer_pointer );
}

void sdp_rdma_reg_model::SdpRdmaUpdateWorkingStatus(uint32_t group_id, uint32_t status){
    switch (group_id) {
        case 0:
            sdp_rdma_register_group_0->rS_STATUS.uSTATUS_0(status);
            break;
        case 1:
            sdp_rdma_register_group_0->rS_STATUS.uSTATUS_1(status);
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    } 
}
