// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: csc_reg_model.h

#ifndef _CSC_REG_MODEL_H_
#define _CSC_REG_MODEL_H_

#include <systemc.h>
#include <tlm.h>

#include "scsim_common.h"

//LUT_COMMENT #include "NvdlaLut.h"
// //LUT_COMMENT class NvdlaLut;
SCSIM_NAMESPACE_START(clib)
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// Forward declarating cmacro parsed register model class
class CNVDLA_CSC_REGSET;
// 
class csc_reg_model {
    public:
        csc_reg_model();
        ~csc_reg_model();
    protected:
        //bool is_there_ongoing_csc_csb_response_;
        CNVDLA_CSC_REGSET *csc_register_group_0;
        CNVDLA_CSC_REGSET *csc_register_group_1;

        sc_event event_csc_reg_group_0_operation_enable;
        sc_event event_csc_reg_group_1_operation_enable;

        //LUT_COMMENT NvdlaLut *csc_lut;
        uint32_t csc_lut_table_idx;  // 0: RAW, 1: DENSITY
        uint32_t csc_lut_entry_idx;
        uint32_t csc_lut_data;
        uint32_t csc_lut_access;

        // Register field variables
        uint8_t   csc_status_0_;
        uint8_t   csc_status_1_;
        uint8_t   csc_producer_;
        uint8_t   csc_consumer_;
        uint8_t   csc_op_en_;
        uint8_t   csc_conv_mode_;
        uint8_t   csc_in_precision_;
        uint8_t   csc_proc_precision_;
        uint8_t   csc_data_reuse_;
        uint8_t   csc_weight_reuse_;
        uint8_t   csc_skip_data_rls_;
        uint8_t   csc_skip_weight_rls_;
        uint8_t   csc_datain_format_;
        uint16_t  csc_datain_width_ext_;
        uint16_t  csc_datain_height_ext_;
        uint16_t  csc_datain_channel_ext_;
        uint8_t   csc_batches_;
        uint8_t   csc_y_extension_;
        uint16_t  csc_entries_;
        uint8_t   csc_weight_format_;
        uint8_t   csc_weight_width_ext_;
        uint8_t   csc_weight_height_ext_;
        uint16_t  csc_weight_channel_ext_;
        uint16_t  csc_weight_kernel_;
        uint32_t  csc_weight_bytes_;
        uint32_t  csc_wmb_bytes_;
        uint16_t  csc_dataout_width_;
        uint16_t  csc_dataout_height_;
        uint16_t  csc_dataout_channel_;
        uint32_t  csc_atomics_;
        uint16_t  csc_rls_slices_;
        uint8_t   csc_conv_x_stride_ext_;
        uint8_t   csc_conv_y_stride_ext_;
        uint8_t   csc_x_dilation_ext_;
        uint8_t   csc_y_dilation_ext_;
        uint8_t   csc_pad_left_;
        uint8_t   csc_pad_top_;
        uint16_t  csc_pad_value_;
        uint8_t   csc_data_bank_;
        uint8_t   csc_weight_bank_;
        uint8_t   csc_pra_truncate_;
        uint32_t  csc_cya_;

        // CSB request target socket
        // void csb2csc_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // CSB response send function
        // void CscSendCsbResponse(uint32_t date, uint8_t error_id);
        // Register accessing
        bool CscAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write);
        // Reset
        void CscRegReset();
        // Update configuration from register to variable
        void CscUpdateVariables(CNVDLA_CSC_REGSET *reg_group_ptr);
        bool CscUpdateStatusRegister(uint32_t addr, uint8_t group, uint32_t reg);
        void CscClearOpeartionEnable(CNVDLA_CSC_REGSET *reg_group_ptr);
        uint32_t CscGetOpeartionEnable(CNVDLA_CSC_REGSET *reg_group_ptr);
        void CscIncreaseConsumerPointer();
        void CscUpdateWorkingStatus(uint32_t group_id, uint32_t status);
        void CscUpdateStatRegisters(uint32_t group_id);
        void CscUpdateStatRegisters(uint32_t group_id, uint32_t data_nan_num, uint32_t weight_nan_num, uint32_t data_inf_num, uint32_t weight_inf_num);
        void CscUpdateStatRegisters(uint32_t group_id, uint32_t saturation_num);

        //LUT read/write functions
        //LUT_COMMENT virtual uint16_t read_lut() = 0;
        //LUT_COMMENT virtual void write_lut() = 0;
};
SCSIM_NAMESPACE_END()

#endif
