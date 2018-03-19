// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_reg_model.cpp

#include "sdp_reg_model.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD (1<<17)
#define NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT 17

#pragma CTC SKIP
SCSIM_NAMESPACE_START(cmod)
    MK_UREGSET_CLASS(NVDLA_SDP)
SCSIM_NAMESPACE_END()
#pragma CTC ENDSKIP

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
    using namespace tlm;
    using namespace sc_core;

sdp_reg_model::sdp_reg_model() {
    sdp_register_group_0 = new CNVDLA_SDP_REGSET;
    sdp_register_group_1 = new CNVDLA_SDP_REGSET;
    //sdp_lut = new NvdlaLut;
    SdpRegReset();
}

#pragma CTC SKIP
sdp_reg_model::~sdp_reg_model() {
    delete sdp_register_group_0;
    delete sdp_register_group_1;
    //delete sdp_lut;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
bool sdp_reg_model::SdpUpdateStatusRegister(uint32_t reg_addr, uint8_t group, uint32_t data) {
    uint32_t offset;

    offset = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    // Get producer point value
    if ( 0 == group ) {
        // The invertion of valid bit served as write enable
        sdp_register_group_0->Set(offset, data);
    } else {
        // The invertion of valid bit served as write enable
        sdp_register_group_1->Set(offset, data);
    }

    return true;
}
#pragma CTC ENDSKIP

bool sdp_reg_model::SdpAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write) {
    uint32_t offset, operation_enable_offset;
    uint32_t rdata = 0;
    uint32_t producer_pointer;

    uint32_t lut_access_cfg_offset   = REG_off(NVDLA_SDP_S_LUT_ACCESS_CFG);
    uint32_t lut_access_data_offset  = REG_off(NVDLA_SDP_S_LUT_ACCESS_DATA);

    offset                  = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    operation_enable_offset = REG_off(NVDLA_SDP_D_OP_ENABLE);
    producer_pointer = sdp_register_group_0->rS_POINTER.uPRODUCER();

    if (is_write) { // Write Request
        if (offset >= operation_enable_offset) { // Registers with dual entities
            // Get producer point value
            if ( 0 == producer_pointer ) {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (sdp_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("sdp_reg_model::SdpAccessRegister, attent to write working group 0"));
                }
#pragma CTC ENDSKIP
                sdp_register_group_0->SetWritable(offset, data);
                if (sdp_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    event_sdp_reg_group_0_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "sdp_reg_model::SdpAccessRegister, notified op_en for group 0.\x0A"));
                }
            } else {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (sdp_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("sdp_reg_model::SdpAccessRegister, attent to write working group 1"));
                }
#pragma CTC ENDSKIP
                sdp_register_group_1->SetWritable(offset, data);
                if (sdp_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    event_sdp_reg_group_1_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "sdp_reg_model::SdpAccessRegister, notified op_en for group 1.\x0A"));
                }
            }
        } else { // Registers which have only one entity

            if (offset == lut_access_data_offset) {
                if(sdp_lut_access)
                {
                    sdp_lut_data = data;
                    write_lut();
                    if((sdp_lut_table_idx && sdp_lut_entry_idx < 256) || (!sdp_lut_table_idx && sdp_lut_entry_idx < 64))
                    {
                        sdp_lut_entry_idx++;
                    }
                }
            } else if (offset == lut_access_cfg_offset) {
                sdp_lut_table_idx = (data & NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_TABLE_ID_FIELD) >> NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_TABLE_ID_SHIFT;
                sdp_lut_entry_idx = (data & NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_ADDR_FIELD)     >> NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_ADDR_SHIFT;
                sdp_lut_access    = (data & NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD)   >> NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT;
            } else {
                sdp_register_group_0->SetWritable(offset, data);
                sdp_register_group_1->SetWritable(offset, data);
            }

        }
        // Write done
    } else { // Read Request
        if (offset >= operation_enable_offset) { // Register with shadow
            if ( 0 == producer_pointer ) {
                sdp_register_group_0->GetReadable(offset, &rdata);
            } else {
                sdp_register_group_1->GetReadable(offset, &rdata);
            }
        } else { // Register which have only one entity

            if (offset == lut_access_data_offset) {
                if(!sdp_lut_access)
                {
                    rdata = (uint32_t)read_lut();   // The type of the return value of read_lut() is uint16_t
                    if((sdp_lut_table_idx && sdp_lut_entry_idx < 256) || (!sdp_lut_table_idx && sdp_lut_entry_idx < 64))
                    {
                        sdp_lut_entry_idx++;
                    }
                }
            } else if (offset == lut_access_cfg_offset) {
                rdata = ( (sdp_lut_table_idx & NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_TABLE_ID_FIELD) << NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_TABLE_ID_SHIFT ) 
                      | ( (sdp_lut_entry_idx & NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_ADDR_FIELD)     << NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_ADDR_SHIFT) 
                      | ( (sdp_lut_table_idx & NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD)   << NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT );
            } else {
                sdp_register_group_0->GetReadable(offset, &rdata);
            }

        }
        data = rdata;
    }
    return true;
}

void sdp_reg_model::SdpRegReset() {
        sdp_register_group_0->ResetAll();
        sdp_register_group_1->ResetAll();

}

void sdp_reg_model::SdpUpdateVariables(CNVDLA_SDP_REGSET *reg_group_ptr) {
        sdp_status_0_ = reg_group_ptr->rS_STATUS.uSTATUS_0();
        sdp_status_1_ = reg_group_ptr->rS_STATUS.uSTATUS_1();
        sdp_producer_ = reg_group_ptr->rS_POINTER.uPRODUCER();
        sdp_consumer_ = reg_group_ptr->rS_POINTER.uCONSUMER();
        sdp_lut_addr_ = reg_group_ptr->rS_LUT_ACCESS_CFG.uLUT_ADDR();
        sdp_lut_table_id_ = reg_group_ptr->rS_LUT_ACCESS_CFG.uLUT_TABLE_ID();
        sdp_lut_access_type_ = reg_group_ptr->rS_LUT_ACCESS_CFG.uLUT_ACCESS_TYPE();
        sdp_lut_data_ = reg_group_ptr->rS_LUT_ACCESS_DATA.uLUT_DATA();
        sdp_lut_le_function_ = reg_group_ptr->rS_LUT_CFG.uLUT_LE_FUNCTION();
        sdp_lut_uflow_priority_ = reg_group_ptr->rS_LUT_CFG.uLUT_UFLOW_PRIORITY();
        sdp_lut_oflow_priority_ = reg_group_ptr->rS_LUT_CFG.uLUT_OFLOW_PRIORITY();
        sdp_lut_hybrid_priority_ = reg_group_ptr->rS_LUT_CFG.uLUT_HYBRID_PRIORITY();
        sdp_lut_le_index_offset_ = reg_group_ptr->rS_LUT_INFO.uLUT_LE_INDEX_OFFSET();
        sdp_lut_le_index_select_ = reg_group_ptr->rS_LUT_INFO.uLUT_LE_INDEX_SELECT();
        sdp_lut_lo_index_select_ = reg_group_ptr->rS_LUT_INFO.uLUT_LO_INDEX_SELECT();
        sdp_lut_le_start_ = reg_group_ptr->rS_LUT_LE_START.uLUT_LE_START();
        sdp_lut_le_end_ = reg_group_ptr->rS_LUT_LE_END.uLUT_LE_END();
        sdp_lut_lo_start_ = reg_group_ptr->rS_LUT_LO_START.uLUT_LO_START();
        sdp_lut_lo_end_ = reg_group_ptr->rS_LUT_LO_END.uLUT_LO_END();
        sdp_lut_le_slope_uflow_scale_ = reg_group_ptr->rS_LUT_LE_SLOPE_SCALE.uLUT_LE_SLOPE_UFLOW_SCALE();
        sdp_lut_le_slope_oflow_scale_ = reg_group_ptr->rS_LUT_LE_SLOPE_SCALE.uLUT_LE_SLOPE_OFLOW_SCALE();
        sdp_lut_le_slope_uflow_shift_ = reg_group_ptr->rS_LUT_LE_SLOPE_SHIFT.uLUT_LE_SLOPE_UFLOW_SHIFT();
        sdp_lut_le_slope_oflow_shift_ = reg_group_ptr->rS_LUT_LE_SLOPE_SHIFT.uLUT_LE_SLOPE_OFLOW_SHIFT();
        sdp_lut_lo_slope_uflow_scale_ = reg_group_ptr->rS_LUT_LO_SLOPE_SCALE.uLUT_LO_SLOPE_UFLOW_SCALE();
        sdp_lut_lo_slope_oflow_scale_ = reg_group_ptr->rS_LUT_LO_SLOPE_SCALE.uLUT_LO_SLOPE_OFLOW_SCALE();
        sdp_lut_lo_slope_uflow_shift_ = reg_group_ptr->rS_LUT_LO_SLOPE_SHIFT.uLUT_LO_SLOPE_UFLOW_SHIFT();
        sdp_lut_lo_slope_oflow_shift_ = reg_group_ptr->rS_LUT_LO_SLOPE_SHIFT.uLUT_LO_SLOPE_OFLOW_SHIFT();
        sdp_op_en_ = reg_group_ptr->rD_OP_ENABLE.uOP_EN();
        sdp_width_ = reg_group_ptr->rD_DATA_CUBE_WIDTH.uWIDTH();
        sdp_height_ = reg_group_ptr->rD_DATA_CUBE_HEIGHT.uHEIGHT();
        sdp_channel_ = reg_group_ptr->rD_DATA_CUBE_CHANNEL.uCHANNEL();
        sdp_dst_base_addr_low_ = reg_group_ptr->rD_DST_BASE_ADDR_LOW.uDST_BASE_ADDR_LOW();
        sdp_dst_base_addr_high_ = reg_group_ptr->rD_DST_BASE_ADDR_HIGH.uDST_BASE_ADDR_HIGH();
        sdp_dst_line_stride_ = reg_group_ptr->rD_DST_LINE_STRIDE.uDST_LINE_STRIDE();
        sdp_dst_surface_stride_ = reg_group_ptr->rD_DST_SURFACE_STRIDE.uDST_SURFACE_STRIDE();
        sdp_bs_bypass_ = reg_group_ptr->rD_DP_BS_CFG.uBS_BYPASS();
        sdp_bs_alu_bypass_ = reg_group_ptr->rD_DP_BS_CFG.uBS_ALU_BYPASS();
        sdp_bs_alu_algo_ = reg_group_ptr->rD_DP_BS_CFG.uBS_ALU_ALGO();
        sdp_bs_mul_bypass_ = reg_group_ptr->rD_DP_BS_CFG.uBS_MUL_BYPASS();
        sdp_bs_mul_prelu_ = reg_group_ptr->rD_DP_BS_CFG.uBS_MUL_PRELU();
        sdp_bs_relu_bypass_ = reg_group_ptr->rD_DP_BS_CFG.uBS_RELU_BYPASS();
        sdp_bs_alu_src_ = reg_group_ptr->rD_DP_BS_ALU_CFG.uBS_ALU_SRC();
        sdp_bs_alu_shift_value_ = reg_group_ptr->rD_DP_BS_ALU_CFG.uBS_ALU_SHIFT_VALUE();
        sdp_bs_alu_operand_ = reg_group_ptr->rD_DP_BS_ALU_SRC_VALUE.uBS_ALU_OPERAND();
        sdp_bs_mul_src_ = reg_group_ptr->rD_DP_BS_MUL_CFG.uBS_MUL_SRC();
        sdp_bs_mul_shift_value_ = reg_group_ptr->rD_DP_BS_MUL_CFG.uBS_MUL_SHIFT_VALUE();
        sdp_bs_mul_operand_ = reg_group_ptr->rD_DP_BS_MUL_SRC_VALUE.uBS_MUL_OPERAND();
        sdp_bn_bypass_ = reg_group_ptr->rD_DP_BN_CFG.uBN_BYPASS();
        sdp_bn_alu_bypass_ = reg_group_ptr->rD_DP_BN_CFG.uBN_ALU_BYPASS();
        sdp_bn_alu_algo_ = reg_group_ptr->rD_DP_BN_CFG.uBN_ALU_ALGO();
        sdp_bn_mul_bypass_ = reg_group_ptr->rD_DP_BN_CFG.uBN_MUL_BYPASS();
        sdp_bn_mul_prelu_ = reg_group_ptr->rD_DP_BN_CFG.uBN_MUL_PRELU();
        sdp_bn_relu_bypass_ = reg_group_ptr->rD_DP_BN_CFG.uBN_RELU_BYPASS();
        sdp_bn_alu_src_ = reg_group_ptr->rD_DP_BN_ALU_CFG.uBN_ALU_SRC();
        sdp_bn_alu_shift_value_ = reg_group_ptr->rD_DP_BN_ALU_CFG.uBN_ALU_SHIFT_VALUE();
        sdp_bn_alu_operand_ = reg_group_ptr->rD_DP_BN_ALU_SRC_VALUE.uBN_ALU_OPERAND();
        sdp_bn_mul_src_ = reg_group_ptr->rD_DP_BN_MUL_CFG.uBN_MUL_SRC();
        sdp_bn_mul_shift_value_ = reg_group_ptr->rD_DP_BN_MUL_CFG.uBN_MUL_SHIFT_VALUE();
        sdp_bn_mul_operand_ = reg_group_ptr->rD_DP_BN_MUL_SRC_VALUE.uBN_MUL_OPERAND();
        sdp_ew_bypass_ = reg_group_ptr->rD_DP_EW_CFG.uEW_BYPASS();
        sdp_ew_alu_bypass_ = reg_group_ptr->rD_DP_EW_CFG.uEW_ALU_BYPASS();
        sdp_ew_alu_algo_ = reg_group_ptr->rD_DP_EW_CFG.uEW_ALU_ALGO();
        sdp_ew_mul_bypass_ = reg_group_ptr->rD_DP_EW_CFG.uEW_MUL_BYPASS();
        sdp_ew_mul_prelu_ = reg_group_ptr->rD_DP_EW_CFG.uEW_MUL_PRELU();
        sdp_ew_lut_bypass_ = reg_group_ptr->rD_DP_EW_CFG.uEW_LUT_BYPASS();
        sdp_ew_alu_src_ = reg_group_ptr->rD_DP_EW_ALU_CFG.uEW_ALU_SRC();
        sdp_ew_alu_cvt_bypass_ = reg_group_ptr->rD_DP_EW_ALU_CFG.uEW_ALU_CVT_BYPASS();
        sdp_ew_alu_operand_ = reg_group_ptr->rD_DP_EW_ALU_SRC_VALUE.uEW_ALU_OPERAND();
        sdp_ew_alu_cvt_offset_ = reg_group_ptr->rD_DP_EW_ALU_CVT_OFFSET_VALUE.uEW_ALU_CVT_OFFSET();
        sdp_ew_alu_cvt_scale_ = reg_group_ptr->rD_DP_EW_ALU_CVT_SCALE_VALUE.uEW_ALU_CVT_SCALE();
        sdp_ew_alu_cvt_truncate_ = reg_group_ptr->rD_DP_EW_ALU_CVT_TRUNCATE_VALUE.uEW_ALU_CVT_TRUNCATE();
        sdp_ew_mul_src_ = reg_group_ptr->rD_DP_EW_MUL_CFG.uEW_MUL_SRC();
        sdp_ew_mul_cvt_bypass_ = reg_group_ptr->rD_DP_EW_MUL_CFG.uEW_MUL_CVT_BYPASS();
        sdp_ew_mul_operand_ = reg_group_ptr->rD_DP_EW_MUL_SRC_VALUE.uEW_MUL_OPERAND();
        sdp_ew_mul_cvt_offset_ = reg_group_ptr->rD_DP_EW_MUL_CVT_OFFSET_VALUE.uEW_MUL_CVT_OFFSET();
        sdp_ew_mul_cvt_scale_ = reg_group_ptr->rD_DP_EW_MUL_CVT_SCALE_VALUE.uEW_MUL_CVT_SCALE();
        sdp_ew_mul_cvt_truncate_ = reg_group_ptr->rD_DP_EW_MUL_CVT_TRUNCATE_VALUE.uEW_MUL_CVT_TRUNCATE();
        sdp_ew_truncate_ = reg_group_ptr->rD_DP_EW_TRUNCATE_VALUE.uEW_TRUNCATE();
        sdp_flying_mode_ = reg_group_ptr->rD_FEATURE_MODE_CFG.uFLYING_MODE();
        sdp_output_dst_ = reg_group_ptr->rD_FEATURE_MODE_CFG.uOUTPUT_DST();
        sdp_winograd_ = reg_group_ptr->rD_FEATURE_MODE_CFG.uWINOGRAD();
        sdp_nan_to_zero_ = reg_group_ptr->rD_FEATURE_MODE_CFG.uNAN_TO_ZERO();
        sdp_batch_number_ = reg_group_ptr->rD_FEATURE_MODE_CFG.uBATCH_NUMBER();
        sdp_dst_ram_type_ = reg_group_ptr->rD_DST_DMA_CFG.uDST_RAM_TYPE();
        sdp_dst_batch_stride_ = reg_group_ptr->rD_DST_BATCH_STRIDE.uDST_BATCH_STRIDE();
        sdp_proc_precision_ = reg_group_ptr->rD_DATA_FORMAT.uPROC_PRECISION();
        sdp_out_precision_ = reg_group_ptr->rD_DATA_FORMAT.uOUT_PRECISION();
        sdp_cvt_offset_ = reg_group_ptr->rD_CVT_OFFSET.uCVT_OFFSET();
        sdp_cvt_scale_ = reg_group_ptr->rD_CVT_SCALE.uCVT_SCALE();
        sdp_cvt_shift_ = reg_group_ptr->rD_CVT_SHIFT.uCVT_SHIFT();
        sdp_status_unequal_ = reg_group_ptr->rD_STATUS.uSTATUS_UNEQUAL();
        sdp_status_nan_input_num_ = reg_group_ptr->rD_STATUS_NAN_INPUT_NUM.uSTATUS_NAN_INPUT_NUM();
        sdp_status_inf_input_num_ = reg_group_ptr->rD_STATUS_INF_INPUT_NUM.uSTATUS_INF_INPUT_NUM();
        sdp_status_nan_output_num_ = reg_group_ptr->rD_STATUS_NAN_OUTPUT_NUM.uSTATUS_NAN_OUTPUT_NUM();
        sdp_perf_dma_en_ = reg_group_ptr->rD_PERF_ENABLE.uPERF_DMA_EN();
        sdp_perf_lut_en_ = reg_group_ptr->rD_PERF_ENABLE.uPERF_LUT_EN();
        sdp_perf_sat_en_ = reg_group_ptr->rD_PERF_ENABLE.uPERF_SAT_EN();
        sdp_perf_nan_inf_count_en_ = reg_group_ptr->rD_PERF_ENABLE.uPERF_NAN_INF_COUNT_EN();
        sdp_wdma_stall_ = reg_group_ptr->rD_PERF_WDMA_WRITE_STALL.uWDMA_STALL();
        sdp_lut_uflow_ = reg_group_ptr->rD_PERF_LUT_UFLOW.uLUT_UFLOW();
        sdp_lut_oflow_ = reg_group_ptr->rD_PERF_LUT_OFLOW.uLUT_OFLOW();
        sdp_out_saturation_ = reg_group_ptr->rD_PERF_OUT_SATURATION.uOUT_SATURATION();
        sdp_lut_hybrid_ = reg_group_ptr->rD_PERF_LUT_HYBRID.uLUT_HYBRID();
        sdp_lut_le_hit_ = reg_group_ptr->rD_PERF_LUT_LE_HIT.uLUT_LE_HIT();
        sdp_lut_lo_hit_ = reg_group_ptr->rD_PERF_LUT_LO_HIT.uLUT_LO_HIT();

}

void sdp_reg_model::SdpClearOpeartionEnable(CNVDLA_SDP_REGSET *reg_group_ptr){
    reg_group_ptr->rD_OP_ENABLE.uOP_EN(NVDLA_SDP_D_OP_ENABLE_0_OP_EN_DISABLE);
    SdpIncreaseConsumerPointer();
}

uint32_t sdp_reg_model::SdpGetOpeartionEnable(CNVDLA_SDP_REGSET *reg_group_ptr){
    return reg_group_ptr->rD_OP_ENABLE.uOP_EN();
}

void sdp_reg_model::SdpIncreaseConsumerPointer(){
    uint32_t consumer_pointer;
    consumer_pointer = (sdp_register_group_0->rS_POINTER.uCONSUMER() == 0) ? 1 : 0;
    sdp_register_group_0->rS_POINTER.uCONSUMER( consumer_pointer );
    sdp_register_group_1->rS_POINTER.uCONSUMER( consumer_pointer );
}

void sdp_reg_model::SdpUpdateWorkingStatus(uint32_t group_id, uint32_t status){
    switch (group_id) {
        case 0:
            sdp_register_group_0->rS_STATUS.uSTATUS_0(status);
            break;
        case 1:
            sdp_register_group_0->rS_STATUS.uSTATUS_1(status);
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    } 
}
