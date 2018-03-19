// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_reg_model.cpp

#include "cdp_reg_model.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD (1<<17)
#define NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT 17

#pragma CTC SKIP
SCSIM_NAMESPACE_START(cmod)
    MK_UREGSET_CLASS(NVDLA_CDP)
SCSIM_NAMESPACE_END()
#pragma CTC ENDSKIP

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
    using namespace tlm;
    using namespace sc_core;

cdp_reg_model::cdp_reg_model() {
    cdp_register_group_0 = new CNVDLA_CDP_REGSET;
    cdp_register_group_1 = new CNVDLA_CDP_REGSET;
    //cdp_lut = new NvdlaLut;
    CdpRegReset();
}

#pragma CTC SKIP
cdp_reg_model::~cdp_reg_model() {
    delete cdp_register_group_0;
    delete cdp_register_group_1;
    //delete cdp_lut;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
bool cdp_reg_model::CdpUpdateStatusRegister(uint32_t reg_addr, uint8_t group, uint32_t data) {
    uint32_t offset;

    offset = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    // Get producer point value
    if ( 0 == group ) {
        // The invertion of valid bit served as write enable
        cdp_register_group_0->Set(offset, data);
    } else {
        // The invertion of valid bit served as write enable
        cdp_register_group_1->Set(offset, data);
    }

    return true;
}
#pragma CTC ENDSKIP

bool cdp_reg_model::CdpAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write) {
    uint32_t offset, operation_enable_offset;
    uint32_t rdata = 0;
    uint32_t producer_pointer;

    uint32_t lut_access_cfg_offset   = REG_off(NVDLA_CDP_S_LUT_ACCESS_CFG);
    uint32_t lut_access_data_offset  = REG_off(NVDLA_CDP_S_LUT_ACCESS_DATA);

    offset                  = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    operation_enable_offset = REG_off(NVDLA_CDP_D_OP_ENABLE);
    producer_pointer = cdp_register_group_0->rS_POINTER.uPRODUCER();

    if (is_write) { // Write Request
        if (offset >= operation_enable_offset) { // Registers with dual entities
            // Get producer point value
            if ( 0 == producer_pointer ) {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (cdp_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("cdp_reg_model::CdpAccessRegister, attent to write working group 0"));
                }
#pragma CTC ENDSKIP
                cdp_register_group_0->SetWritable(offset, data);
                if (cdp_register_group_0->rD_OP_ENABLE.uOP_EN()) {
                    event_cdp_reg_group_0_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "cdp_reg_model::CdpAccessRegister, notified op_en for group 0.\x0A"));
                }
            } else {
                // The invertion of valid bit served as write enable
#pragma CTC SKIP
                if (cdp_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    FAIL(("cdp_reg_model::CdpAccessRegister, attent to write working group 1"));
                }
#pragma CTC ENDSKIP
                cdp_register_group_1->SetWritable(offset, data);
                if (cdp_register_group_1->rD_OP_ENABLE.uOP_EN()) {
                    event_cdp_reg_group_1_operation_enable.notify(SC_ZERO_TIME);
                    cslDebug((30, "cdp_reg_model::CdpAccessRegister, notified op_en for group 1.\x0A"));
                }
            }
        } else { // Registers which have only one entity

            if (offset == lut_access_data_offset) {
                if(cdp_lut_access)
                {
                    cdp_lut_data = data;
                    write_lut();
                    if((cdp_lut_table_idx && cdp_lut_entry_idx < 256) || (!cdp_lut_table_idx && cdp_lut_entry_idx < 64))
                    {
                        cdp_lut_entry_idx++;
                    }
                }
            } else if (offset == lut_access_cfg_offset) {
                cdp_lut_table_idx = (data & NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_TABLE_ID_FIELD) >> NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_TABLE_ID_SHIFT;
                cdp_lut_entry_idx = (data & NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_ADDR_FIELD)     >> NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_ADDR_SHIFT;
                cdp_lut_access    = (data & NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD)   >> NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT;
            } else {
                cdp_register_group_0->SetWritable(offset, data);
                cdp_register_group_1->SetWritable(offset, data);
            }

        }
        // Write done
    } else { // Read Request
        if (offset >= operation_enable_offset) { // Register with shadow
            if ( 0 == producer_pointer ) {
                cdp_register_group_0->GetReadable(offset, &rdata);
            } else {
                cdp_register_group_1->GetReadable(offset, &rdata);
            }
        } else { // Register which have only one entity

            if (offset == lut_access_data_offset) {
                if(!cdp_lut_access)
                {
                    rdata = (uint32_t)read_lut();   // The type of the return value of read_lut() is uint16_t
                    if((cdp_lut_table_idx && cdp_lut_entry_idx < 256) || (!cdp_lut_table_idx && cdp_lut_entry_idx < 64))
                    {
                        cdp_lut_entry_idx++;
                    }
                }
            } else if (offset == lut_access_cfg_offset) {
                rdata = ( (cdp_lut_table_idx & NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_TABLE_ID_FIELD) << NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_TABLE_ID_SHIFT ) 
                      | ( (cdp_lut_entry_idx & NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_ADDR_FIELD)     << NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_ADDR_SHIFT) 
                      | ( (cdp_lut_table_idx & NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_FIELD)   << NVDLA_CDP_S_LUT_ACCESS_CFG_0_LUT_ACCESS_SHIFT );
            } else {
                cdp_register_group_0->GetReadable(offset, &rdata);
            }

        }
        data = rdata;
    }
    return true;
}

void cdp_reg_model::CdpRegReset() {
        cdp_register_group_0->ResetAll();
        cdp_register_group_1->ResetAll();

}

void cdp_reg_model::CdpUpdateVariables(CNVDLA_CDP_REGSET *reg_group_ptr) {
        cdp_status_0_ = reg_group_ptr->rS_STATUS.uSTATUS_0();
        cdp_status_1_ = reg_group_ptr->rS_STATUS.uSTATUS_1();
        cdp_producer_ = reg_group_ptr->rS_POINTER.uPRODUCER();
        cdp_consumer_ = reg_group_ptr->rS_POINTER.uCONSUMER();
        cdp_lut_addr_ = reg_group_ptr->rS_LUT_ACCESS_CFG.uLUT_ADDR();
        cdp_lut_table_id_ = reg_group_ptr->rS_LUT_ACCESS_CFG.uLUT_TABLE_ID();
        cdp_lut_access_type_ = reg_group_ptr->rS_LUT_ACCESS_CFG.uLUT_ACCESS_TYPE();
        cdp_lut_data_ = reg_group_ptr->rS_LUT_ACCESS_DATA.uLUT_DATA();
        cdp_lut_le_function_ = reg_group_ptr->rS_LUT_CFG.uLUT_LE_FUNCTION();
        cdp_lut_uflow_priority_ = reg_group_ptr->rS_LUT_CFG.uLUT_UFLOW_PRIORITY();
        cdp_lut_oflow_priority_ = reg_group_ptr->rS_LUT_CFG.uLUT_OFLOW_PRIORITY();
        cdp_lut_hybrid_priority_ = reg_group_ptr->rS_LUT_CFG.uLUT_HYBRID_PRIORITY();
        cdp_lut_le_index_offset_ = reg_group_ptr->rS_LUT_INFO.uLUT_LE_INDEX_OFFSET();
        cdp_lut_le_index_select_ = reg_group_ptr->rS_LUT_INFO.uLUT_LE_INDEX_SELECT();
        cdp_lut_lo_index_select_ = reg_group_ptr->rS_LUT_INFO.uLUT_LO_INDEX_SELECT();
        cdp_lut_le_start_low_ = reg_group_ptr->rS_LUT_LE_START_LOW.uLUT_LE_START_LOW();
        cdp_lut_le_start_high_ = reg_group_ptr->rS_LUT_LE_START_HIGH.uLUT_LE_START_HIGH();
        cdp_lut_le_end_low_ = reg_group_ptr->rS_LUT_LE_END_LOW.uLUT_LE_END_LOW();
        cdp_lut_le_end_high_ = reg_group_ptr->rS_LUT_LE_END_HIGH.uLUT_LE_END_HIGH();
        cdp_lut_lo_start_low_ = reg_group_ptr->rS_LUT_LO_START_LOW.uLUT_LO_START_LOW();
        cdp_lut_lo_start_high_ = reg_group_ptr->rS_LUT_LO_START_HIGH.uLUT_LO_START_HIGH();
        cdp_lut_lo_end_low_ = reg_group_ptr->rS_LUT_LO_END_LOW.uLUT_LO_END_LOW();
        cdp_lut_lo_end_high_ = reg_group_ptr->rS_LUT_LO_END_HIGH.uLUT_LO_END_HIGH();
        cdp_lut_le_slope_uflow_scale_ = reg_group_ptr->rS_LUT_LE_SLOPE_SCALE.uLUT_LE_SLOPE_UFLOW_SCALE();
        cdp_lut_le_slope_oflow_scale_ = reg_group_ptr->rS_LUT_LE_SLOPE_SCALE.uLUT_LE_SLOPE_OFLOW_SCALE();
        cdp_lut_le_slope_uflow_shift_ = reg_group_ptr->rS_LUT_LE_SLOPE_SHIFT.uLUT_LE_SLOPE_UFLOW_SHIFT();
        cdp_lut_le_slope_oflow_shift_ = reg_group_ptr->rS_LUT_LE_SLOPE_SHIFT.uLUT_LE_SLOPE_OFLOW_SHIFT();
        cdp_lut_lo_slope_uflow_scale_ = reg_group_ptr->rS_LUT_LO_SLOPE_SCALE.uLUT_LO_SLOPE_UFLOW_SCALE();
        cdp_lut_lo_slope_oflow_scale_ = reg_group_ptr->rS_LUT_LO_SLOPE_SCALE.uLUT_LO_SLOPE_OFLOW_SCALE();
        cdp_lut_lo_slope_uflow_shift_ = reg_group_ptr->rS_LUT_LO_SLOPE_SHIFT.uLUT_LO_SLOPE_UFLOW_SHIFT();
        cdp_lut_lo_slope_oflow_shift_ = reg_group_ptr->rS_LUT_LO_SLOPE_SHIFT.uLUT_LO_SLOPE_OFLOW_SHIFT();
        cdp_op_en_ = reg_group_ptr->rD_OP_ENABLE.uOP_EN();
        cdp_sqsum_bypass_ = reg_group_ptr->rD_FUNC_BYPASS.uSQSUM_BYPASS();
        cdp_mul_bypass_ = reg_group_ptr->rD_FUNC_BYPASS.uMUL_BYPASS();
        cdp_dst_base_addr_low_ = reg_group_ptr->rD_DST_BASE_ADDR_LOW.uDST_BASE_ADDR_LOW();
        cdp_dst_base_addr_high_ = reg_group_ptr->rD_DST_BASE_ADDR_HIGH.uDST_BASE_ADDR_HIGH();
        cdp_dst_line_stride_ = reg_group_ptr->rD_DST_LINE_STRIDE.uDST_LINE_STRIDE();
        cdp_dst_surface_stride_ = reg_group_ptr->rD_DST_SURFACE_STRIDE.uDST_SURFACE_STRIDE();
        cdp_dst_ram_type_ = reg_group_ptr->rD_DST_DMA_CFG.uDST_RAM_TYPE();
        cdp_dst_compression_en_ = reg_group_ptr->rD_DST_COMPRESSION_EN.uDST_COMPRESSION_EN();
        cdp_input_data_type_ = reg_group_ptr->rD_DATA_FORMAT.uINPUT_DATA_TYPE();
        cdp_nan_to_zero_ = reg_group_ptr->rD_NAN_FLUSH_TO_ZERO.uNAN_TO_ZERO();
        cdp_normalz_len_ = reg_group_ptr->rD_LRN_CFG.uNORMALZ_LEN();
        cdp_datin_offset_ = reg_group_ptr->rD_DATIN_OFFSET.uDATIN_OFFSET();
        cdp_datin_scale_ = reg_group_ptr->rD_DATIN_SCALE.uDATIN_SCALE();
        cdp_datin_shifter_ = reg_group_ptr->rD_DATIN_SHIFTER.uDATIN_SHIFTER();
        cdp_datout_offset_ = reg_group_ptr->rD_DATOUT_OFFSET.uDATOUT_OFFSET();
        cdp_datout_scale_ = reg_group_ptr->rD_DATOUT_SCALE.uDATOUT_SCALE();
        cdp_datout_shifter_ = reg_group_ptr->rD_DATOUT_SHIFTER.uDATOUT_SHIFTER();
        cdp_nan_input_num_ = reg_group_ptr->rD_NAN_INPUT_NUM.uNAN_INPUT_NUM();
        cdp_inf_input_num_ = reg_group_ptr->rD_INF_INPUT_NUM.uINF_INPUT_NUM();
        cdp_nan_output_num_ = reg_group_ptr->rD_NAN_OUTPUT_NUM.uNAN_OUTPUT_NUM();
        cdp_out_saturation_ = reg_group_ptr->rD_OUT_SATURATION.uOUT_SATURATION();
        cdp_dma_en_ = reg_group_ptr->rD_PERF_ENABLE.uDMA_EN();
        cdp_lut_en_ = reg_group_ptr->rD_PERF_ENABLE.uLUT_EN();
        cdp_perf_write_stall_ = reg_group_ptr->rD_PERF_WRITE_STALL.uPERF_WRITE_STALL();
        cdp_perf_lut_uflow_ = reg_group_ptr->rD_PERF_LUT_UFLOW.uPERF_LUT_UFLOW();
        cdp_perf_lut_oflow_ = reg_group_ptr->rD_PERF_LUT_OFLOW.uPERF_LUT_OFLOW();
        cdp_perf_lut_hybrid_ = reg_group_ptr->rD_PERF_LUT_HYBRID.uPERF_LUT_HYBRID();
        cdp_perf_lut_le_hit_ = reg_group_ptr->rD_PERF_LUT_LE_HIT.uPERF_LUT_LE_HIT();
        cdp_perf_lut_lo_hit_ = reg_group_ptr->rD_PERF_LUT_LO_HIT.uPERF_LUT_LO_HIT();
        cdp_cya_ = reg_group_ptr->rD_CYA.uCYA();

}

void cdp_reg_model::CdpClearOpeartionEnable(CNVDLA_CDP_REGSET *reg_group_ptr){
    reg_group_ptr->rD_OP_ENABLE.uOP_EN(NVDLA_CDP_D_OP_ENABLE_0_OP_EN_DISABLE);
    CdpIncreaseConsumerPointer();
}

uint32_t cdp_reg_model::CdpGetOpeartionEnable(CNVDLA_CDP_REGSET *reg_group_ptr){
    return reg_group_ptr->rD_OP_ENABLE.uOP_EN();
}

void cdp_reg_model::CdpIncreaseConsumerPointer(){
    uint32_t consumer_pointer;
    consumer_pointer = (cdp_register_group_0->rS_POINTER.uCONSUMER() == 0) ? 1 : 0;
    cdp_register_group_0->rS_POINTER.uCONSUMER( consumer_pointer );
    cdp_register_group_1->rS_POINTER.uCONSUMER( consumer_pointer );
}

void cdp_reg_model::CdpUpdateWorkingStatus(uint32_t group_id, uint32_t status){
    switch (group_id) {
        case 0:
            cdp_register_group_0->rS_STATUS.uSTATUS_0(status);
            break;
        case 1:
            cdp_register_group_0->rS_STATUS.uSTATUS_1(status);
            break;
#pragma CTC SKIP
        default:
            break;
#pragma CTC ENDSKIP
    } 
}
