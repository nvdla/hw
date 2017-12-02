// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: rbk_reg_model.h

#ifndef _RBK_REG_MODEL_H_
#define _RBK_REG_MODEL_H_

#include <systemc.h>
#include <tlm.h>

#include "scsim_common.h"

//LUT_COMMENT #include "NvdlaLut.h"
// //LUT_COMMENT class NvdlaLut;
SCSIM_NAMESPACE_START(clib)
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// Forward declarating cmacro parsed register model class
class CNVDLA_RBK_REGSET;
// 
class rbk_reg_model {
    public:
        rbk_reg_model();
        ~rbk_reg_model();
    protected:
        //bool is_there_ongoing_rbk_csb_response_;
        CNVDLA_RBK_REGSET *rbk_register_group_0;
        CNVDLA_RBK_REGSET *rbk_register_group_1;

        sc_event event_rbk_reg_group_0_operation_enable;
        sc_event event_rbk_reg_group_1_operation_enable;

        //LUT_COMMENT NvdlaLut *rbk_lut;
        uint32_t rbk_lut_table_idx;  // 0: RAW, 1: DENSITY
        uint32_t rbk_lut_entry_idx;
        uint32_t rbk_lut_data;
        uint32_t rbk_lut_access;

        // Register field variables
        uint8_t   rbk_status_0_;
        uint8_t   rbk_status_1_;
        uint8_t   rbk_producer_;
        uint8_t   rbk_consumer_;
        uint8_t   rbk_op_en_;
        uint8_t   rbk_rubik_mode_;
        uint8_t   rbk_in_precision_;
        uint8_t   rbk_datain_ram_type_;
        uint16_t  rbk_datain_width_;
        uint16_t  rbk_datain_height_;
        uint16_t  rbk_datain_channel_;
        uint32_t  rbk_dain_addr_high_;
        uint32_t  rbk_dain_addr_low_;
        uint32_t  rbk_dain_line_stride_;
        uint32_t  rbk_dain_surf_stride_;
        uint32_t  rbk_dain_planar_stride_;
        uint8_t   rbk_dataout_ram_type_;
        uint16_t  rbk_dataout_channel_;
        uint32_t  rbk_daout_addr_high_;
        uint32_t  rbk_daout_addr_low_;
        uint32_t  rbk_daout_line_stride_;
        uint32_t  rbk_contract_stride_0_;
        uint32_t  rbk_contract_stride_1_;
        uint32_t  rbk_daout_surf_stride_;
        uint32_t  rbk_daout_planar_stride_;
        uint8_t   rbk_deconv_x_stride_;
        uint8_t   rbk_deconv_y_stride_;
        uint8_t   rbk_perf_en_;
        uint32_t  rbk_rd_stall_cnt_;
        uint32_t  rbk_wr_stall_cnt_;

        // CSB request target socket
        // void csb2rbk_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // CSB response send function
        // void RbkSendCsbResponse(uint32_t date, uint8_t error_id);
        // Register accessing
        bool RbkAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write);
        // Reset
        void RbkRegReset();
        // Update configuration from register to variable
        void RbkUpdateVariables(CNVDLA_RBK_REGSET *reg_group_ptr);
        bool RbkUpdateStatusRegister(uint32_t addr, uint8_t group, uint32_t reg);
        void RbkClearOpeartionEnable(CNVDLA_RBK_REGSET *reg_group_ptr);
        uint32_t RbkGetOpeartionEnable(CNVDLA_RBK_REGSET *reg_group_ptr);
        void RbkIncreaseConsumerPointer();
        void RbkUpdateWorkingStatus(uint32_t group_id, uint32_t status);
        void RbkUpdateStatRegisters(uint32_t group_id);
        void RbkUpdateStatRegisters(uint32_t group_id, uint32_t data_nan_num, uint32_t weight_nan_num, uint32_t data_inf_num, uint32_t weight_inf_num);
        void RbkUpdateStatRegisters(uint32_t group_id, uint32_t saturation_num);

        //LUT read/write functions
        //LUT_COMMENT virtual uint16_t read_lut() = 0;
        //LUT_COMMENT virtual void write_lut() = 0;
};
SCSIM_NAMESPACE_END()

#endif
