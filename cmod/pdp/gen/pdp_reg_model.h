// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: pdp_reg_model.h

#ifndef _PDP_REG_MODEL_H_
#define _PDP_REG_MODEL_H_

#include <systemc.h>
#include <tlm.h>

#include "scsim_common.h"

//LUT_COMMENT #include "NvdlaLut.h"
// //LUT_COMMENT class NvdlaLut;
SCSIM_NAMESPACE_START(clib)
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// Forward declarating cmacro parsed register model class
class CNVDLA_PDP_REGSET;
// 
class pdp_reg_model {
    public:
        pdp_reg_model();
        ~pdp_reg_model();
    protected:
        //bool is_there_ongoing_pdp_csb_response_;
        CNVDLA_PDP_REGSET *pdp_register_group_0;
        CNVDLA_PDP_REGSET *pdp_register_group_1;

        sc_event event_pdp_reg_group_0_operation_enable;
        sc_event event_pdp_reg_group_1_operation_enable;

        //LUT_COMMENT NvdlaLut *pdp_lut;
        uint32_t pdp_lut_table_idx;  // 0: RAW, 1: DENSITY
        uint32_t pdp_lut_entry_idx;
        uint32_t pdp_lut_data;
        uint32_t pdp_lut_access;

        // Register field variables
        uint8_t   pdp_status_0_;
        uint8_t   pdp_status_1_;
        uint8_t   pdp_producer_;
        uint8_t   pdp_consumer_;
        uint8_t   pdp_op_en_;
        uint16_t  pdp_cube_in_width_;
        uint16_t  pdp_cube_in_height_;
        uint16_t  pdp_cube_in_channel_;
        uint16_t  pdp_cube_out_width_;
        uint16_t  pdp_cube_out_height_;
        uint16_t  pdp_cube_out_channel_;
        uint8_t   pdp_pooling_method_;
        uint8_t   pdp_flying_mode_;
        uint8_t   pdp_split_num_;
        uint8_t   pdp_nan_to_zero_;
        uint16_t  pdp_partial_width_in_first_;
        uint16_t  pdp_partial_width_in_last_;
        uint16_t  pdp_partial_width_in_mid_;
        uint16_t  pdp_partial_width_out_first_;
        uint16_t  pdp_partial_width_out_last_;
        uint16_t  pdp_partial_width_out_mid_;
        uint8_t   pdp_kernel_width_;
        uint8_t   pdp_kernel_height_;
        uint8_t   pdp_kernel_stride_width_;
        uint8_t   pdp_kernel_stride_height_;
        uint32_t  pdp_recip_kernel_width_;
        uint32_t  pdp_recip_kernel_height_;
        uint8_t   pdp_pad_left_;
        uint8_t   pdp_pad_top_;
        uint8_t   pdp_pad_right_;
        uint8_t   pdp_pad_bottom_;
        uint32_t  pdp_pad_value_1x_;
        uint32_t  pdp_pad_value_2x_;
        uint32_t  pdp_pad_value_3x_;
        uint32_t  pdp_pad_value_4x_;
        uint32_t  pdp_pad_value_5x_;
        uint32_t  pdp_pad_value_6x_;
        uint32_t  pdp_pad_value_7x_;
        uint32_t  pdp_src_base_addr_low_;
        uint32_t  pdp_src_base_addr_high_;
        uint32_t  pdp_src_line_stride_;
        uint32_t  pdp_src_surface_stride_;
        uint32_t  pdp_dst_base_addr_low_;
        uint32_t  pdp_dst_base_addr_high_;
        uint32_t  pdp_dst_line_stride_;
        uint32_t  pdp_dst_surface_stride_;
        uint8_t   pdp_dst_ram_type_;
        uint8_t   pdp_input_data_;
        uint32_t  pdp_inf_input_num_;
        uint32_t  pdp_nan_input_num_;
        uint32_t  pdp_nan_output_num_;
        uint8_t   pdp_dma_en_;
        uint32_t  pdp_perf_write_stall_;
        uint32_t  pdp_cya_;

        // CSB request target socket
        // void csb2pdp_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // CSB response send function
        // void PdpSendCsbResponse(uint32_t date, uint8_t error_id);
        // Register accessing
        bool PdpAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write);
        // Reset
        void PdpRegReset();
        // Update configuration from register to variable
        void PdpUpdateVariables(CNVDLA_PDP_REGSET *reg_group_ptr);
        bool PdpUpdateStatusRegister(uint32_t addr, uint8_t group, uint32_t reg);
        void PdpClearOpeartionEnable(CNVDLA_PDP_REGSET *reg_group_ptr);
        uint32_t PdpGetOpeartionEnable(CNVDLA_PDP_REGSET *reg_group_ptr);
        void PdpIncreaseConsumerPointer();
        void PdpUpdateWorkingStatus(uint32_t group_id, uint32_t status);
        void PdpUpdateStatRegisters(uint32_t group_id);
        void PdpUpdateStatRegisters(uint32_t group_id, uint32_t data_nan_num, uint32_t weight_nan_num, uint32_t data_inf_num, uint32_t weight_inf_num);
        void PdpUpdateStatRegisters(uint32_t group_id, uint32_t saturation_num);

        //LUT read/write functions
        //LUT_COMMENT virtual uint16_t read_lut() = 0;
        //LUT_COMMENT virtual void write_lut() = 0;
};
SCSIM_NAMESPACE_END()

#endif
