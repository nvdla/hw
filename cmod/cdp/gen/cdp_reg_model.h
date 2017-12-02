// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_reg_model.h

#ifndef _CDP_REG_MODEL_H_
#define _CDP_REG_MODEL_H_

#include <systemc.h>
#include <tlm.h>

#include "scsim_common.h"

#include "NvdlaLut.h"
// class NvdlaLut;
SCSIM_NAMESPACE_START(clib)
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// Forward declarating cmacro parsed register model class
class CNVDLA_CDP_REGSET;
// 
class cdp_reg_model {
    public:
        cdp_reg_model();
        ~cdp_reg_model();
    protected:
        //bool is_there_ongoing_cdp_csb_response_;
        CNVDLA_CDP_REGSET *cdp_register_group_0;
        CNVDLA_CDP_REGSET *cdp_register_group_1;

        sc_event event_cdp_reg_group_0_operation_enable;
        sc_event event_cdp_reg_group_1_operation_enable;

        NvdlaLut *cdp_lut;
        uint32_t cdp_lut_table_idx;  // 0: RAW, 1: DENSITY
        uint32_t cdp_lut_entry_idx;
        uint32_t cdp_lut_data;
        uint32_t cdp_lut_access;

        // Register field variables
        uint8_t   cdp_status_0_;
        uint8_t   cdp_status_1_;
        uint8_t   cdp_producer_;
        uint8_t   cdp_consumer_;
        uint16_t  cdp_lut_addr_;
        uint8_t   cdp_lut_table_id_;
        uint8_t   cdp_lut_access_type_;
        uint16_t  cdp_lut_data_;
        uint8_t   cdp_lut_le_function_;
        uint8_t   cdp_lut_uflow_priority_;
        uint8_t   cdp_lut_oflow_priority_;
        uint8_t   cdp_lut_hybrid_priority_;
        uint8_t   cdp_lut_le_index_offset_;
        uint8_t   cdp_lut_le_index_select_;
        uint8_t   cdp_lut_lo_index_select_;
        uint32_t  cdp_lut_le_start_low_;
        uint8_t   cdp_lut_le_start_high_;
        uint32_t  cdp_lut_le_end_low_;
        uint8_t   cdp_lut_le_end_high_;
        uint32_t  cdp_lut_lo_start_low_;
        uint8_t   cdp_lut_lo_start_high_;
        uint32_t  cdp_lut_lo_end_low_;
        uint8_t   cdp_lut_lo_end_high_;
        uint16_t  cdp_lut_le_slope_uflow_scale_;
        uint16_t  cdp_lut_le_slope_oflow_scale_;
        uint8_t   cdp_lut_le_slope_uflow_shift_;
        uint8_t   cdp_lut_le_slope_oflow_shift_;
        uint16_t  cdp_lut_lo_slope_uflow_scale_;
        uint16_t  cdp_lut_lo_slope_oflow_scale_;
        uint8_t   cdp_lut_lo_slope_uflow_shift_;
        uint8_t   cdp_lut_lo_slope_oflow_shift_;
        uint8_t   cdp_op_en_;
        uint8_t   cdp_sqsum_bypass_;
        uint8_t   cdp_mul_bypass_;
        uint32_t  cdp_dst_base_addr_low_;
        uint32_t  cdp_dst_base_addr_high_;
        uint32_t  cdp_dst_line_stride_;
        uint32_t  cdp_dst_surface_stride_;
        uint8_t   cdp_dst_ram_type_;
        uint8_t   cdp_dst_compression_en_;
        uint8_t   cdp_input_data_type_;
        uint8_t   cdp_nan_to_zero_;
        uint8_t   cdp_normalz_len_;
        uint16_t  cdp_datin_offset_;
        uint16_t  cdp_datin_scale_;
        uint8_t   cdp_datin_shifter_;
        uint32_t  cdp_datout_offset_;
        uint16_t  cdp_datout_scale_;
        uint8_t   cdp_datout_shifter_;
        uint32_t  cdp_nan_input_num_;
        uint32_t  cdp_inf_input_num_;
        uint32_t  cdp_nan_output_num_;
        uint32_t  cdp_out_saturation_;
        uint8_t   cdp_dma_en_;
        uint8_t   cdp_lut_en_;
        uint32_t  cdp_perf_write_stall_;
        uint32_t  cdp_perf_lut_uflow_;
        uint32_t  cdp_perf_lut_oflow_;
        uint32_t  cdp_perf_lut_hybrid_;
        uint32_t  cdp_perf_lut_le_hit_;
        uint32_t  cdp_perf_lut_lo_hit_;
        uint32_t  cdp_cya_;

        // CSB request target socket
        // void csb2cdp_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // CSB response send function
        // void CdpSendCsbResponse(uint32_t date, uint8_t error_id);
        // Register accessing
        bool CdpAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write);
        // Reset
        void CdpRegReset();
        // Update configuration from register to variable
        void CdpUpdateVariables(CNVDLA_CDP_REGSET *reg_group_ptr);
        bool CdpUpdateStatusRegister(uint32_t addr, uint8_t group, uint32_t reg);
        void CdpClearOpeartionEnable(CNVDLA_CDP_REGSET *reg_group_ptr);
        uint32_t CdpGetOpeartionEnable(CNVDLA_CDP_REGSET *reg_group_ptr);
        void CdpIncreaseConsumerPointer();
        void CdpUpdateWorkingStatus(uint32_t group_id, uint32_t status);
        void CdpUpdateStatRegisters(uint32_t group_id);
        void CdpUpdateStatRegisters(uint32_t group_id, uint32_t data_nan_num, uint32_t weight_nan_num, uint32_t data_inf_num, uint32_t weight_inf_num);
        void CdpUpdateStatRegisters(uint32_t group_id, uint32_t saturation_num);

        //LUT read/write functions
        virtual uint16_t read_lut() = 0;
        virtual void write_lut() = 0;
};
SCSIM_NAMESPACE_END()

#endif
