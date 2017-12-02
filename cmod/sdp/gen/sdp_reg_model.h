// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_reg_model.h

#ifndef _SDP_REG_MODEL_H_
#define _SDP_REG_MODEL_H_

#include <systemc.h>
#include <tlm.h>

#include "scsim_common.h"

#include "NvdlaLut.h"
// class NvdlaLut;
SCSIM_NAMESPACE_START(clib)
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// Forward declarating cmacro parsed register model class
class CNVDLA_SDP_REGSET;
// 
class sdp_reg_model {
    public:
        sdp_reg_model();
        ~sdp_reg_model();
    protected:
        //bool is_there_ongoing_sdp_csb_response_;
        CNVDLA_SDP_REGSET *sdp_register_group_0;
        CNVDLA_SDP_REGSET *sdp_register_group_1;

        sc_event event_sdp_reg_group_0_operation_enable;
        sc_event event_sdp_reg_group_1_operation_enable;

        NvdlaLut *sdp_lut;
        uint32_t sdp_lut_table_idx;  // 0: RAW, 1: DENSITY
        uint32_t sdp_lut_entry_idx;
        uint32_t sdp_lut_data;
        uint32_t sdp_lut_access;

        // Register field variables
        uint8_t   sdp_status_0_;
        uint8_t   sdp_status_1_;
        uint8_t   sdp_producer_;
        uint8_t   sdp_consumer_;
        uint16_t  sdp_lut_addr_;
        uint8_t   sdp_lut_table_id_;
        uint8_t   sdp_lut_access_type_;
        uint16_t  sdp_lut_data_;
        uint8_t   sdp_lut_le_function_;
        uint8_t   sdp_lut_uflow_priority_;
        uint8_t   sdp_lut_oflow_priority_;
        uint8_t   sdp_lut_hybrid_priority_;
        uint8_t   sdp_lut_le_index_offset_;
        uint8_t   sdp_lut_le_index_select_;
        uint8_t   sdp_lut_lo_index_select_;
        uint32_t  sdp_lut_le_start_;
        uint32_t  sdp_lut_le_end_;
        uint32_t  sdp_lut_lo_start_;
        uint32_t  sdp_lut_lo_end_;
        uint16_t  sdp_lut_le_slope_uflow_scale_;
        uint16_t  sdp_lut_le_slope_oflow_scale_;
        uint8_t   sdp_lut_le_slope_uflow_shift_;
        uint8_t   sdp_lut_le_slope_oflow_shift_;
        uint16_t  sdp_lut_lo_slope_uflow_scale_;
        uint16_t  sdp_lut_lo_slope_oflow_scale_;
        uint8_t   sdp_lut_lo_slope_uflow_shift_;
        uint8_t   sdp_lut_lo_slope_oflow_shift_;
        uint8_t   sdp_op_en_;
        uint16_t  sdp_width_;
        uint16_t  sdp_height_;
        uint16_t  sdp_channel_;
        uint32_t  sdp_dst_base_addr_low_;
        uint32_t  sdp_dst_base_addr_high_;
        uint32_t  sdp_dst_line_stride_;
        uint32_t  sdp_dst_surface_stride_;
        uint8_t   sdp_bs_bypass_;
        uint8_t   sdp_bs_alu_bypass_;
        uint8_t   sdp_bs_alu_algo_;
        uint8_t   sdp_bs_mul_bypass_;
        uint8_t   sdp_bs_mul_prelu_;
        uint8_t   sdp_bs_relu_bypass_;
        uint8_t   sdp_bs_alu_src_;
        uint8_t   sdp_bs_alu_shift_value_;
        uint16_t  sdp_bs_alu_operand_;
        uint8_t   sdp_bs_mul_src_;
        uint8_t   sdp_bs_mul_shift_value_;
        uint16_t  sdp_bs_mul_operand_;
        uint8_t   sdp_bn_bypass_;
        uint8_t   sdp_bn_alu_bypass_;
        uint8_t   sdp_bn_alu_algo_;
        uint8_t   sdp_bn_mul_bypass_;
        uint8_t   sdp_bn_mul_prelu_;
        uint8_t   sdp_bn_relu_bypass_;
        uint8_t   sdp_bn_alu_src_;
        uint8_t   sdp_bn_alu_shift_value_;
        uint16_t  sdp_bn_alu_operand_;
        uint8_t   sdp_bn_mul_src_;
        uint8_t   sdp_bn_mul_shift_value_;
        uint16_t  sdp_bn_mul_operand_;
        uint8_t   sdp_ew_bypass_;
        uint8_t   sdp_ew_alu_bypass_;
        uint8_t   sdp_ew_alu_algo_;
        uint8_t   sdp_ew_mul_bypass_;
        uint8_t   sdp_ew_mul_prelu_;
        uint8_t   sdp_ew_lut_bypass_;
        uint8_t   sdp_ew_alu_src_;
        uint8_t   sdp_ew_alu_cvt_bypass_;
        uint32_t  sdp_ew_alu_operand_;
        uint32_t  sdp_ew_alu_cvt_offset_;
        uint16_t  sdp_ew_alu_cvt_scale_;
        uint8_t   sdp_ew_alu_cvt_truncate_;
        uint8_t   sdp_ew_mul_src_;
        uint8_t   sdp_ew_mul_cvt_bypass_;
        uint32_t  sdp_ew_mul_operand_;
        uint32_t  sdp_ew_mul_cvt_offset_;
        uint16_t  sdp_ew_mul_cvt_scale_;
        uint8_t   sdp_ew_mul_cvt_truncate_;
        uint16_t  sdp_ew_truncate_;
        uint8_t   sdp_flying_mode_;
        uint8_t   sdp_output_dst_;
        uint8_t   sdp_winograd_;
        uint8_t   sdp_nan_to_zero_;
        uint8_t   sdp_batch_number_;
        uint8_t   sdp_dst_ram_type_;
        uint32_t  sdp_dst_batch_stride_;
        uint8_t   sdp_proc_precision_;
        uint8_t   sdp_out_precision_;
        uint32_t  sdp_cvt_offset_;
        uint16_t  sdp_cvt_scale_;
        uint8_t   sdp_cvt_shift_;
        uint8_t   sdp_status_unequal_;
        uint32_t  sdp_status_nan_input_num_;
        uint32_t  sdp_status_inf_input_num_;
        uint32_t  sdp_status_nan_output_num_;
        uint8_t   sdp_perf_dma_en_;
        uint8_t   sdp_perf_lut_en_;
        uint8_t   sdp_perf_sat_en_;
        uint8_t   sdp_perf_nan_inf_count_en_;
        uint32_t  sdp_wdma_stall_;
        uint32_t  sdp_lut_uflow_;
        uint32_t  sdp_lut_oflow_;
        uint32_t  sdp_out_saturation_;
        uint32_t  sdp_lut_hybrid_;
        uint32_t  sdp_lut_le_hit_;
        uint32_t  sdp_lut_lo_hit_;

        // CSB request target socket
        // void csb2sdp_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // CSB response send function
        // void SdpSendCsbResponse(uint32_t date, uint8_t error_id);
        // Register accessing
        bool SdpAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write);
        // Reset
        void SdpRegReset();
        // Update configuration from register to variable
        void SdpUpdateVariables(CNVDLA_SDP_REGSET *reg_group_ptr);
        bool SdpUpdateStatusRegister(uint32_t addr, uint8_t group, uint32_t reg);
        void SdpClearOpeartionEnable(CNVDLA_SDP_REGSET *reg_group_ptr);
        uint32_t SdpGetOpeartionEnable(CNVDLA_SDP_REGSET *reg_group_ptr);
        void SdpIncreaseConsumerPointer();
        void SdpUpdateWorkingStatus(uint32_t group_id, uint32_t status);
        void SdpUpdateStatRegisters(uint32_t group_id);
        void SdpUpdateStatRegisters(uint32_t group_id, uint32_t data_nan_num, uint32_t weight_nan_num, uint32_t data_inf_num, uint32_t weight_inf_num);
        void SdpUpdateStatRegisters(uint32_t group_id, uint32_t saturation_num);

        //LUT read/write functions
        virtual uint16_t read_lut() = 0;
        virtual void write_lut() = 0;
};
SCSIM_NAMESPACE_END()

#endif
