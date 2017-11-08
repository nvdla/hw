// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdma_reg_model.h

#ifndef _CDMA_REG_MODEL_H_
#define _CDMA_REG_MODEL_H_

#include <systemc.h>
#include <tlm.h>

#include "scsim_common.h"

//LUT_COMMENT #include "NvdlaLut.h"
// //LUT_COMMENT class NvdlaLut;
SCSIM_NAMESPACE_START(clib)
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// Forward declarating cmacro parsed register model class
class CNVDLA_CDMA_REGSET;
// 
class cdma_reg_model {
    public:
        cdma_reg_model();
        ~cdma_reg_model();
    protected:
        //bool is_there_ongoing_cdma_csb_response_;
        CNVDLA_CDMA_REGSET *cdma_register_group_0;
        CNVDLA_CDMA_REGSET *cdma_register_group_1;

        sc_event event_cdma_reg_group_0_operation_enable;
        sc_event event_cdma_reg_group_1_operation_enable;

        //LUT_COMMENT NvdlaLut *cdma_lut;
        uint32_t cdma_lut_table_idx;  // 0: RAW, 1: DENSITY
        uint32_t cdma_lut_entry_idx;
        uint32_t cdma_lut_data;
        uint32_t cdma_lut_access;

        // Register field variables
        uint8_t   cdma_status_0_;
        uint8_t   cdma_status_1_;
        uint8_t   cdma_producer_;
        uint8_t   cdma_consumer_;
        uint8_t   cdma_arb_weight_;
        uint8_t   cdma_arb_wmb_;
        uint8_t   cdma_flush_done_;
        uint8_t   cdma_op_en_;
        uint8_t   cdma_conv_mode_;
        uint8_t   cdma_in_precision_;
        uint8_t   cdma_proc_precision_;
        uint8_t   cdma_data_reuse_;
        uint8_t   cdma_weight_reuse_;
        uint8_t   cdma_skip_data_rls_;
        uint8_t   cdma_skip_weight_rls_;
        uint8_t   cdma_datain_format_;
        uint8_t   cdma_pixel_format_;
        uint8_t   cdma_pixel_mapping_;
        uint8_t   cdma_pixel_sign_override_;
        uint16_t  cdma_datain_width_;
        uint16_t  cdma_datain_height_;
        uint16_t  cdma_datain_channel_;
        uint16_t  cdma_datain_width_ext_;
        uint16_t  cdma_datain_height_ext_;
        uint8_t   cdma_pixel_x_offset_;
        uint8_t   cdma_pixel_y_offset_;
        uint8_t   cdma_datain_ram_type_;
        uint32_t  cdma_datain_addr_high_0_;
        uint32_t  cdma_datain_addr_low_0_;
        uint32_t  cdma_datain_addr_high_1_;
        uint32_t  cdma_datain_addr_low_1_;
        uint32_t  cdma_line_stride_;
        uint32_t  cdma_uv_line_stride_;
        uint32_t  cdma_surf_stride_;
        uint8_t   cdma_line_packed_;
        uint8_t   cdma_surf_packed_;
        uint16_t  cdma_rsv_per_line_;
        uint16_t  cdma_rsv_per_uv_line_;
        uint8_t   cdma_rsv_height_;
        uint8_t   cdma_rsv_y_index_;
        uint8_t   cdma_batches_;
        uint32_t  cdma_batch_stride_;
        uint16_t  cdma_entries_;
        uint16_t  cdma_grains_;
        uint8_t   cdma_weight_format_;
        uint32_t  cdma_byte_per_kernel_;
        uint16_t  cdma_weight_kernel_;
        uint8_t   cdma_weight_ram_type_;
        uint32_t  cdma_weight_addr_high_;
        uint32_t  cdma_weight_addr_low_;
        uint32_t  cdma_weight_bytes_;
        uint32_t  cdma_wgs_addr_high_;
        uint32_t  cdma_wgs_addr_low_;
        uint32_t  cdma_wmb_addr_high_;
        uint32_t  cdma_wmb_addr_low_;
        uint32_t  cdma_wmb_bytes_;
        uint8_t   cdma_mean_format_;
        uint16_t  cdma_mean_ry_;
        uint16_t  cdma_mean_gu_;
        uint16_t  cdma_mean_bv_;
        uint16_t  cdma_mean_ax_;
        uint8_t   cdma_cvt_en_;
        uint8_t   cdma_cvt_truncate_;
        uint16_t  cdma_cvt_offset_;
        uint16_t  cdma_cvt_scale_;
        uint8_t   cdma_conv_x_stride_;
        uint8_t   cdma_conv_y_stride_;
        uint8_t   cdma_pad_left_;
        uint8_t   cdma_pad_right_;
        uint8_t   cdma_pad_top_;
        uint8_t   cdma_pad_bottom_;
        uint16_t  cdma_pad_value_;
        uint8_t   cdma_data_bank_;
        uint8_t   cdma_weight_bank_;
        uint8_t   cdma_nan_to_zero_;
        uint32_t  cdma_nan_data_num_;
        uint32_t  cdma_nan_weight_num_;
        uint32_t  cdma_inf_data_num_;
        uint32_t  cdma_inf_weight_num_;
        uint8_t   cdma_dma_en_;
        uint32_t  cdma_dat_rd_stall_;
        uint32_t  cdma_wt_rd_stall_;
        uint32_t  cdma_dat_rd_latency_;
        uint32_t  cdma_wt_rd_latency_;
        uint32_t  cdma_cya_;

        // CSB request target socket
        // void csb2cdma_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // CSB response send function
        // void CdmaSendCsbResponse(uint32_t date, uint8_t error_id);
        // Register accessing
        bool CdmaAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write);
        // Reset
        void CdmaRegReset();
        // Update configuration from register to variable
        void CdmaUpdateVariables(CNVDLA_CDMA_REGSET *reg_group_ptr);
        bool CdmaUpdateStatusRegister(uint32_t addr, uint8_t group, uint32_t reg);
        void CdmaClearOpeartionEnable(CNVDLA_CDMA_REGSET *reg_group_ptr);
        uint32_t CdmaGetOpeartionEnable(CNVDLA_CDMA_REGSET *reg_group_ptr);
        void CdmaIncreaseConsumerPointer();
        void CdmaUpdateWorkingStatus(uint32_t group_id, uint32_t status);
        void CdmaUpdateStatRegisters(uint32_t group_id);
        void CdmaUpdateStatRegisters(uint32_t group_id, uint32_t data_nan_num, uint32_t weight_nan_num, uint32_t data_inf_num, uint32_t weight_inf_num);
        void CdmaUpdateStatRegisters(uint32_t group_id, uint32_t saturation_num);

        //LUT read/write functions
        //LUT_COMMENT virtual uint16_t read_lut() = 0;
        //LUT_COMMENT virtual void write_lut() = 0;
};
SCSIM_NAMESPACE_END()

#endif
