// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdma_reg_model.cpp

#include "cdma_reg_model.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define NVDLA_CDMA_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD (1<<17)
#define NVDLA_CDMA_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT 17

#pragma CTC SKIP
SCSIM_NAMESPACE_START(cmod)
    MK_UREGSET_CLASS(NVDLA_CDMA)
SCSIM_NAMESPACE_END()
#pragma CTC ENDSKIP

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
    using namespace tlm;
    using namespace sc_core;

cdma_reg_model::cdma_reg_model() {
    cdma_register_group_0 = new CNVDLA_CDMA_REGSET;
    cdma_register_group_1 = new CNVDLA_CDMA_REGSET;
    ////LUT_COMMENT cdma_lut = new NvdlaLut;
    CdmaRegReset();
}

#pragma CTC SKIP
cdma_reg_model::~cdma_reg_model() {
    delete cdma_register_group_0;
    delete cdma_register_group_1;
    ////LUT_COMMENT delete cdma_lut;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
bool cdma_reg_model::CdmaUpdateStatusRegister(uint32_t reg_addr, uint8_t group, uint32_t data) {
    uint32_t offset;

    offset = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    // Get producer point value
    if ( 0 == group ) {
        // The invertion of valid bit served as write enable
        cdma_register_group_0->Set(offset, data);
    } else {
        // The invertion of valid bit served as write enable
        cdma_register_group_1->Set(offset, data);
    }

    return true;
}
#pragma CTC ENDSKIP

bool cdma_reg_model::CdmaAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write) {
    uint32_t offset, operation_enable_offset;
    uint32_t rdata = 0;
    uint32_t producer_pointer;

    offset                  = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    operation_enable_offset = REG_off(NVDLA_CDMA_D_OP_ENABLE);
    producer_pointer = cdma_register_group_0->rS_POINTER.uPRODUCER();

    if (is_write) { // Write Request
        if (offset >= operation_enable_offset) { // Registers with dual entities
            // Get producer point value
            if ( 0 == producer_pointer ) {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (cdma_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("cdma_reg_model::CdmaAccessRegister, attent to write working group 0"));
                }
#pragma CTC ENDSKIP
                cdma_register_group_0->SetWritable(offset, data);
                if (cdma_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    event_cdma_reg_group_0_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "cdma_reg_model::CdmaAccessRegister, notified op_en for group 0.\x0A"));
                }
            } else {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (cdma_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("cdma_reg_model::CdmaAccessRegister, attent to write working group 1"));
                }
#pragma CTC ENDSKIP
                cdma_register_group_1->SetWritable(offset, data);
                if (cdma_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    event_cdma_reg_group_1_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "cdma_reg_model::CdmaAccessRegister, notified op_en for group 1.\x0A"));
                }
            }
        } else { // Registers which have only one entity

            cdma_register_group_0->SetWritable(offset, data);
            cdma_register_group_1->SetWritable(offset, data);

        }
        // Write done
    } else { // Read Request
        if (offset >= operation_enable_offset) { // Register with shadow
            if ( 0 == producer_pointer ) {
                cdma_register_group_0->GetReadable(offset, &rdata);
            } else {
                cdma_register_group_1->GetReadable(offset, &rdata);
            }
        } else { // Register which have only one entity

            cdma_register_group_0->GetReadable(offset, &rdata);

        }
        data = rdata;
    }
    return true;
}

void cdma_reg_model::CdmaRegReset() {
        cdma_register_group_0->ResetAll();
        cdma_register_group_1->ResetAll();

}

void cdma_reg_model::CdmaUpdateVariables(CNVDLA_CDMA_REGSET *reg_group_ptr) {
        cdma_status_0_ = reg_group_ptr->rS_STATUS.uSTATUS_0();
        cdma_status_1_ = reg_group_ptr->rS_STATUS.uSTATUS_1();
        cdma_producer_ = reg_group_ptr->rS_POINTER.uPRODUCER();
        cdma_consumer_ = reg_group_ptr->rS_POINTER.uCONSUMER();
        cdma_arb_weight_ = reg_group_ptr->rS_ARBITER.uARB_WEIGHT();
        cdma_arb_wmb_ = reg_group_ptr->rS_ARBITER.uARB_WMB();
        cdma_flush_done_ = reg_group_ptr->rS_CBUF_FLUSH_STATUS.uFLUSH_DONE();
        cdma_op_en_ = reg_group_ptr->rD_OP_ENABLE.uOP_EN();
        cdma_conv_mode_ = reg_group_ptr->rD_MISC_CFG.uCONV_MODE();
        cdma_in_precision_ = reg_group_ptr->rD_MISC_CFG.uIN_PRECISION();
        cdma_proc_precision_ = reg_group_ptr->rD_MISC_CFG.uPROC_PRECISION();
        cdma_data_reuse_ = reg_group_ptr->rD_MISC_CFG.uDATA_REUSE();
        cdma_weight_reuse_ = reg_group_ptr->rD_MISC_CFG.uWEIGHT_REUSE();
        cdma_skip_data_rls_ = reg_group_ptr->rD_MISC_CFG.uSKIP_DATA_RLS();
        cdma_skip_weight_rls_ = reg_group_ptr->rD_MISC_CFG.uSKIP_WEIGHT_RLS();
        cdma_datain_format_ = reg_group_ptr->rD_DATAIN_FORMAT.uDATAIN_FORMAT();
        cdma_pixel_format_ = reg_group_ptr->rD_DATAIN_FORMAT.uPIXEL_FORMAT();
        cdma_pixel_mapping_ = reg_group_ptr->rD_DATAIN_FORMAT.uPIXEL_MAPPING();
        cdma_pixel_sign_override_ = reg_group_ptr->rD_DATAIN_FORMAT.uPIXEL_SIGN_OVERRIDE();
        cdma_datain_width_ = reg_group_ptr->rD_DATAIN_SIZE_0.uDATAIN_WIDTH();
        cdma_datain_height_ = reg_group_ptr->rD_DATAIN_SIZE_0.uDATAIN_HEIGHT();
        cdma_datain_channel_ = reg_group_ptr->rD_DATAIN_SIZE_1.uDATAIN_CHANNEL();
        cdma_datain_width_ext_ = reg_group_ptr->rD_DATAIN_SIZE_EXT_0.uDATAIN_WIDTH_EXT();
        cdma_datain_height_ext_ = reg_group_ptr->rD_DATAIN_SIZE_EXT_0.uDATAIN_HEIGHT_EXT();
        cdma_pixel_x_offset_ = reg_group_ptr->rD_PIXEL_OFFSET.uPIXEL_X_OFFSET();
        cdma_pixel_y_offset_ = reg_group_ptr->rD_PIXEL_OFFSET.uPIXEL_Y_OFFSET();
        cdma_datain_ram_type_ = reg_group_ptr->rD_DAIN_RAM_TYPE.uDATAIN_RAM_TYPE();
        cdma_datain_addr_high_0_ = reg_group_ptr->rD_DAIN_ADDR_HIGH_0.uDATAIN_ADDR_HIGH_0();
        cdma_datain_addr_low_0_ = reg_group_ptr->rD_DAIN_ADDR_LOW_0.uDATAIN_ADDR_LOW_0();
        cdma_datain_addr_high_1_ = reg_group_ptr->rD_DAIN_ADDR_HIGH_1.uDATAIN_ADDR_HIGH_1();
        cdma_datain_addr_low_1_ = reg_group_ptr->rD_DAIN_ADDR_LOW_1.uDATAIN_ADDR_LOW_1();
        cdma_line_stride_ = reg_group_ptr->rD_LINE_STRIDE.uLINE_STRIDE();
        cdma_uv_line_stride_ = reg_group_ptr->rD_LINE_UV_STRIDE.uUV_LINE_STRIDE();
        cdma_surf_stride_ = reg_group_ptr->rD_SURF_STRIDE.uSURF_STRIDE();
        cdma_line_packed_ = reg_group_ptr->rD_DAIN_MAP.uLINE_PACKED();
        cdma_surf_packed_ = reg_group_ptr->rD_DAIN_MAP.uSURF_PACKED();
        cdma_rsv_per_line_ = reg_group_ptr->rD_RESERVED_X_CFG.uRSV_PER_LINE();
        cdma_rsv_per_uv_line_ = reg_group_ptr->rD_RESERVED_X_CFG.uRSV_PER_UV_LINE();
        cdma_rsv_height_ = reg_group_ptr->rD_RESERVED_Y_CFG.uRSV_HEIGHT();
        cdma_rsv_y_index_ = reg_group_ptr->rD_RESERVED_Y_CFG.uRSV_Y_INDEX();
        cdma_batches_ = reg_group_ptr->rD_BATCH_NUMBER.uBATCHES();
        cdma_batch_stride_ = reg_group_ptr->rD_BATCH_STRIDE.uBATCH_STRIDE();
        cdma_entries_ = reg_group_ptr->rD_ENTRY_PER_SLICE.uENTRIES();
        cdma_grains_ = reg_group_ptr->rD_FETCH_GRAIN.uGRAINS();
        cdma_weight_format_ = reg_group_ptr->rD_WEIGHT_FORMAT.uWEIGHT_FORMAT();
        cdma_byte_per_kernel_ = reg_group_ptr->rD_WEIGHT_SIZE_0.uBYTE_PER_KERNEL();
        cdma_weight_kernel_ = reg_group_ptr->rD_WEIGHT_SIZE_1.uWEIGHT_KERNEL();
        cdma_weight_ram_type_ = reg_group_ptr->rD_WEIGHT_RAM_TYPE.uWEIGHT_RAM_TYPE();
        cdma_weight_addr_high_ = reg_group_ptr->rD_WEIGHT_ADDR_HIGH.uWEIGHT_ADDR_HIGH();
        cdma_weight_addr_low_ = reg_group_ptr->rD_WEIGHT_ADDR_LOW.uWEIGHT_ADDR_LOW();
        cdma_weight_bytes_ = reg_group_ptr->rD_WEIGHT_BYTES.uWEIGHT_BYTES();
        cdma_wgs_addr_high_ = reg_group_ptr->rD_WGS_ADDR_HIGH.uWGS_ADDR_HIGH();
        cdma_wgs_addr_low_ = reg_group_ptr->rD_WGS_ADDR_LOW.uWGS_ADDR_LOW();
        cdma_wmb_addr_high_ = reg_group_ptr->rD_WMB_ADDR_HIGH.uWMB_ADDR_HIGH();
        cdma_wmb_addr_low_ = reg_group_ptr->rD_WMB_ADDR_LOW.uWMB_ADDR_LOW();
        cdma_wmb_bytes_ = reg_group_ptr->rD_WMB_BYTES.uWMB_BYTES();
        cdma_mean_format_ = reg_group_ptr->rD_MEAN_FORMAT.uMEAN_FORMAT();
        cdma_mean_ry_ = reg_group_ptr->rD_MEAN_GLOBAL_0.uMEAN_RY();
        cdma_mean_gu_ = reg_group_ptr->rD_MEAN_GLOBAL_0.uMEAN_GU();
        cdma_mean_bv_ = reg_group_ptr->rD_MEAN_GLOBAL_1.uMEAN_BV();
        cdma_mean_ax_ = reg_group_ptr->rD_MEAN_GLOBAL_1.uMEAN_AX();
        cdma_cvt_en_ = reg_group_ptr->rD_CVT_CFG.uCVT_EN();
        cdma_cvt_truncate_ = reg_group_ptr->rD_CVT_CFG.uCVT_TRUNCATE();
        cdma_cvt_offset_ = reg_group_ptr->rD_CVT_OFFSET.uCVT_OFFSET();
        cdma_cvt_scale_ = reg_group_ptr->rD_CVT_SCALE.uCVT_SCALE();
        cdma_conv_x_stride_ = reg_group_ptr->rD_CONV_STRIDE.uCONV_X_STRIDE();
        cdma_conv_y_stride_ = reg_group_ptr->rD_CONV_STRIDE.uCONV_Y_STRIDE();
        cdma_pad_left_ = reg_group_ptr->rD_ZERO_PADDING.uPAD_LEFT();
        cdma_pad_right_ = reg_group_ptr->rD_ZERO_PADDING.uPAD_RIGHT();
        cdma_pad_top_ = reg_group_ptr->rD_ZERO_PADDING.uPAD_TOP();
        cdma_pad_bottom_ = reg_group_ptr->rD_ZERO_PADDING.uPAD_BOTTOM();
        cdma_pad_value_ = reg_group_ptr->rD_ZERO_PADDING_VALUE.uPAD_VALUE();
        cdma_data_bank_ = reg_group_ptr->rD_BANK.uDATA_BANK();
        cdma_weight_bank_ = reg_group_ptr->rD_BANK.uWEIGHT_BANK();
        cdma_nan_to_zero_ = reg_group_ptr->rD_NAN_FLUSH_TO_ZERO.uNAN_TO_ZERO();
        cdma_nan_data_num_ = reg_group_ptr->rD_NAN_INPUT_DATA_NUM.uNAN_DATA_NUM();
        cdma_nan_weight_num_ = reg_group_ptr->rD_NAN_INPUT_WEIGHT_NUM.uNAN_WEIGHT_NUM();
        cdma_inf_data_num_ = reg_group_ptr->rD_INF_INPUT_DATA_NUM.uINF_DATA_NUM();
        cdma_inf_weight_num_ = reg_group_ptr->rD_INF_INPUT_WEIGHT_NUM.uINF_WEIGHT_NUM();
        cdma_dma_en_ = reg_group_ptr->rD_PERF_ENABLE.uDMA_EN();
        cdma_dat_rd_stall_ = reg_group_ptr->rD_PERF_DAT_READ_STALL.uDAT_RD_STALL();
        cdma_wt_rd_stall_ = reg_group_ptr->rD_PERF_WT_READ_STALL.uWT_RD_STALL();
        cdma_dat_rd_latency_ = reg_group_ptr->rD_PERF_DAT_READ_LATENCY.uDAT_RD_LATENCY();
        cdma_wt_rd_latency_ = reg_group_ptr->rD_PERF_WT_READ_LATENCY.uWT_RD_LATENCY();
        cdma_cya_ = reg_group_ptr->rD_CYA.uCYA();

}

void cdma_reg_model::CdmaClearOpeartionEnable(CNVDLA_CDMA_REGSET *reg_group_ptr){
    reg_group_ptr->rD_OP_ENABLE.uOP_EN(NVDLA_CDMA_D_OP_ENABLE_0_OP_EN_DISABLE);
    CdmaIncreaseConsumerPointer();
}

uint32_t cdma_reg_model::CdmaGetOpeartionEnable(CNVDLA_CDMA_REGSET *reg_group_ptr){
    return reg_group_ptr->rD_OP_ENABLE.uOP_EN();
}

void cdma_reg_model::CdmaIncreaseConsumerPointer(){
    uint32_t consumer_pointer;
    consumer_pointer = (cdma_register_group_0->rS_POINTER.uCONSUMER() == 0) ? 1 : 0;
    cdma_register_group_0->rS_POINTER.uCONSUMER( consumer_pointer );
    cdma_register_group_1->rS_POINTER.uCONSUMER( consumer_pointer );
}

void cdma_reg_model::CdmaUpdateWorkingStatus(uint32_t group_id, uint32_t status){
    switch (group_id) {
        case 0:
            cdma_register_group_0->rS_STATUS.uSTATUS_0(status);
            break;
        case 1:
            cdma_register_group_0->rS_STATUS.uSTATUS_1(status);
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    } 
}

void cdma_reg_model::CdmaUpdateStatRegisters(uint32_t group_id, uint32_t data_nan_num, uint32_t weight_nan_num, uint32_t data_inf_num, uint32_t weight_inf_num) {
    if ( 0 == group_id ) {
        cdma_register_group_0->rD_NAN_INPUT_DATA_NUM.uNAN_DATA_NUM(data_nan_num);
        cdma_register_group_0->rD_NAN_INPUT_WEIGHT_NUM.uNAN_WEIGHT_NUM(weight_nan_num);
        cdma_register_group_0->rD_INF_INPUT_DATA_NUM.uINF_DATA_NUM(data_inf_num);
        cdma_register_group_0->rD_INF_INPUT_WEIGHT_NUM.uINF_WEIGHT_NUM(weight_inf_num);
    } else {
        cdma_register_group_1->rD_NAN_INPUT_DATA_NUM.uNAN_DATA_NUM(data_nan_num);
        cdma_register_group_1->rD_NAN_INPUT_WEIGHT_NUM.uNAN_WEIGHT_NUM(weight_nan_num);
        cdma_register_group_1->rD_INF_INPUT_DATA_NUM.uINF_DATA_NUM(data_inf_num);
        cdma_register_group_1->rD_INF_INPUT_WEIGHT_NUM.uINF_WEIGHT_NUM(weight_inf_num);
    }
}
