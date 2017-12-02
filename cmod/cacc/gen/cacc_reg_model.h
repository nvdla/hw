// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cacc_reg_model.h

#ifndef _CACC_REG_MODEL_H_
#define _CACC_REG_MODEL_H_

#include <systemc.h>
#include <tlm.h>

#include "scsim_common.h"

//LUT_COMMENT #include "NvdlaLut.h"
// //LUT_COMMENT class NvdlaLut;
SCSIM_NAMESPACE_START(clib)
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// Forward declarating cmacro parsed register model class
class CNVDLA_CACC_REGSET;
// 
class cacc_reg_model {
    public:
        cacc_reg_model();
        ~cacc_reg_model();
    protected:
        //bool is_there_ongoing_cacc_csb_response_;
        CNVDLA_CACC_REGSET *cacc_register_group_0;
        CNVDLA_CACC_REGSET *cacc_register_group_1;

        sc_event event_cacc_reg_group_0_operation_enable;
        sc_event event_cacc_reg_group_1_operation_enable;

        //LUT_COMMENT NvdlaLut *cacc_lut;
        uint32_t cacc_lut_table_idx;  // 0: RAW, 1: DENSITY
        uint32_t cacc_lut_entry_idx;
        uint32_t cacc_lut_data;
        uint32_t cacc_lut_access;

        // Register field variables
        uint8_t   cacc_status_0_;
        uint8_t   cacc_status_1_;
        uint8_t   cacc_producer_;
        uint8_t   cacc_consumer_;
        uint8_t   cacc_op_en_;
        uint8_t   cacc_conv_mode_;
        uint8_t   cacc_proc_precision_;
        uint16_t  cacc_dataout_width_;
        uint16_t  cacc_dataout_height_;
        uint16_t  cacc_dataout_channel_;
        uint32_t  cacc_dataout_addr_;
        uint8_t   cacc_batches_;
        uint32_t  cacc_line_stride_;
        uint32_t  cacc_surf_stride_;
        uint8_t   cacc_line_packed_;
        uint8_t   cacc_surf_packed_;
        uint8_t   cacc_clip_truncate_;
        uint32_t  cacc_sat_count_;
        uint32_t  cacc_cya_;

        // CSB request target socket
        // void csb2cacc_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // CSB response send function
        // void CaccSendCsbResponse(uint32_t date, uint8_t error_id);
        // Register accessing
        bool CaccAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write);
        // Reset
        void CaccRegReset();
        // Update configuration from register to variable
        void CaccUpdateVariables(CNVDLA_CACC_REGSET *reg_group_ptr);
        bool CaccUpdateStatusRegister(uint32_t addr, uint8_t group, uint32_t reg);
        void CaccClearOpeartionEnable(CNVDLA_CACC_REGSET *reg_group_ptr);
        uint32_t CaccGetOpeartionEnable(CNVDLA_CACC_REGSET *reg_group_ptr);
        void CaccIncreaseConsumerPointer();
        void CaccUpdateWorkingStatus(uint32_t group_id, uint32_t status);
        void CaccUpdateStatRegisters(uint32_t group_id);
        void CaccUpdateStatRegisters(uint32_t group_id, uint32_t data_nan_num, uint32_t weight_nan_num, uint32_t data_inf_num, uint32_t weight_inf_num);
        void CaccUpdateStatRegisters(uint32_t group_id, uint32_t saturation_num);

        //LUT read/write functions
        //LUT_COMMENT virtual uint16_t read_lut() = 0;
        //LUT_COMMENT virtual void write_lut() = 0;
};
SCSIM_NAMESPACE_END()

#endif
