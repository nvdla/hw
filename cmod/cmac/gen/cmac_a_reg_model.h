// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cmac_a_reg_model.h

#ifndef _CMAC_A_REG_MODEL_H_
#define _CMAC_A_REG_MODEL_H_

#include <systemc.h>
#include <tlm.h>

#include "scsim_common.h"

//LUT_COMMENT #include "NvdlaLut.h"
// //LUT_COMMENT class NvdlaLut;
SCSIM_NAMESPACE_START(clib)
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// Forward declarating cmacro parsed register model class
class CNVDLA_CMAC_A_REGSET;
// 
class cmac_a_reg_model {
    public:
        cmac_a_reg_model();
        ~cmac_a_reg_model();
    protected:
        //bool is_there_ongoing_cmac_a_csb_response_;
        CNVDLA_CMAC_A_REGSET *cmac_a_register_group_0;
        CNVDLA_CMAC_A_REGSET *cmac_a_register_group_1;

        sc_event event_cmac_a_reg_group_0_operation_enable;
        sc_event event_cmac_a_reg_group_1_operation_enable;

        //LUT_COMMENT NvdlaLut *cmac_a_lut;
        uint32_t cmac_a_lut_table_idx;  // 0: RAW, 1: DENSITY
        uint32_t cmac_a_lut_entry_idx;
        uint32_t cmac_a_lut_data;
        uint32_t cmac_a_lut_access;

        // Register field variables
        uint8_t   cmac_a_status_0_;
        uint8_t   cmac_a_status_1_;
        uint8_t   cmac_a_producer_;
        uint8_t   cmac_a_consumer_;
        uint8_t   cmac_a_op_en_;
        uint8_t   cmac_a_conv_mode_;
        uint8_t   cmac_a_proc_precision_;

        // CSB request target socket
        // void csb2cmac_a_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // CSB response send function
        // void CmacASendCsbResponse(uint32_t date, uint8_t error_id);
        // Register accessing
        bool CmacAAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write);
        // Reset
        void CmacARegReset();
        // Update configuration from register to variable
        void CmacAUpdateVariables(CNVDLA_CMAC_A_REGSET *reg_group_ptr);
        bool CmacAUpdateStatusRegister(uint32_t addr, uint8_t group, uint32_t reg);
        void CmacAClearOpeartionEnable(CNVDLA_CMAC_A_REGSET *reg_group_ptr);
        uint32_t CmacAGetOpeartionEnable(CNVDLA_CMAC_A_REGSET *reg_group_ptr);
        void CmacAIncreaseConsumerPointer();
        void CmacAUpdateWorkingStatus(uint32_t group_id, uint32_t status);
        void CmacAUpdateStatRegisters(uint32_t group_id);
        void CmacAUpdateStatRegisters(uint32_t group_id, uint32_t data_nan_num, uint32_t weight_nan_num, uint32_t data_inf_num, uint32_t weight_inf_num);
        void CmacAUpdateStatRegisters(uint32_t group_id, uint32_t saturation_num);

        //LUT read/write functions
        //LUT_COMMENT virtual uint16_t read_lut() = 0;
        //LUT_COMMENT virtual void write_lut() = 0;
};
SCSIM_NAMESPACE_END()

#endif
