// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: pdp_rdma_reg_model.h

#ifndef _PDP_RDMA_REG_MODEL_H_
#define _PDP_RDMA_REG_MODEL_H_

#include <systemc.h>
#include <tlm.h>

#include "scsim_common.h"

//LUT_COMMENT #include "NvdlaLut.h"
// //LUT_COMMENT class NvdlaLut;
SCSIM_NAMESPACE_START(clib)
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// Forward declarating cmacro parsed register model class
class CNVDLA_PDP_RDMA_REGSET;
// 
class pdp_rdma_reg_model {
    public:
        pdp_rdma_reg_model();
        ~pdp_rdma_reg_model();
    protected:
        //bool is_there_ongoing_pdp_rdma_csb_response_;
        CNVDLA_PDP_RDMA_REGSET *pdp_rdma_register_group_0;
        CNVDLA_PDP_RDMA_REGSET *pdp_rdma_register_group_1;

        sc_event event_pdp_rdma_reg_group_0_operation_enable;
        sc_event event_pdp_rdma_reg_group_1_operation_enable;

        //LUT_COMMENT NvdlaLut *pdp_rdma_lut;
        uint32_t pdp_rdma_lut_table_idx;  // 0: RAW, 1: DENSITY
        uint32_t pdp_rdma_lut_entry_idx;
        uint32_t pdp_rdma_lut_data;
        uint32_t pdp_rdma_lut_access;

        // Register field variables
        uint8_t   pdp_rdma_status_0_;
        uint8_t   pdp_rdma_status_1_;
        uint8_t   pdp_rdma_producer_;
        uint8_t   pdp_rdma_consumer_;
        uint8_t   pdp_rdma_op_en_;
        uint16_t  pdp_rdma_cube_in_width_;
        uint16_t  pdp_rdma_cube_in_height_;
        uint16_t  pdp_rdma_cube_in_channel_;
        uint8_t   pdp_rdma_flying_mode_;
        uint32_t  pdp_rdma_src_base_addr_low_;
        uint32_t  pdp_rdma_src_base_addr_high_;
        uint32_t  pdp_rdma_src_line_stride_;
        uint32_t  pdp_rdma_src_surface_stride_;
        uint8_t   pdp_rdma_src_ram_type_;
        uint8_t   pdp_rdma_input_data_;
        uint8_t   pdp_rdma_split_num_;
        uint8_t   pdp_rdma_kernel_width_;
        uint8_t   pdp_rdma_kernel_stride_width_;
        uint8_t   pdp_rdma_pad_width_;
        uint16_t  pdp_rdma_partial_width_in_first_;
        uint16_t  pdp_rdma_partial_width_in_last_;
        uint16_t  pdp_rdma_partial_width_in_mid_;
        uint8_t   pdp_rdma_dma_en_;
        uint32_t  pdp_rdma_perf_read_stall_;
        uint32_t  pdp_rdma_cya_;

        // CSB request target socket
        // void csb2pdp_rdma_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // CSB response send function
        // void PdpRdmaSendCsbResponse(uint32_t date, uint8_t error_id);
        // Register accessing
        bool PdpRdmaAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write);
        // Reset
        void PdpRdmaRegReset();
        // Update configuration from register to variable
        void PdpRdmaUpdateVariables(CNVDLA_PDP_RDMA_REGSET *reg_group_ptr);
        bool PdpRdmaUpdateStatusRegister(uint32_t addr, uint8_t group, uint32_t reg);
        void PdpRdmaClearOpeartionEnable(CNVDLA_PDP_RDMA_REGSET *reg_group_ptr);
        uint32_t PdpRdmaGetOpeartionEnable(CNVDLA_PDP_RDMA_REGSET *reg_group_ptr);
        void PdpRdmaIncreaseConsumerPointer();
        void PdpRdmaUpdateWorkingStatus(uint32_t group_id, uint32_t status);
        void PdpRdmaUpdateStatRegisters(uint32_t group_id);
        void PdpRdmaUpdateStatRegisters(uint32_t group_id, uint32_t data_nan_num, uint32_t weight_nan_num, uint32_t data_inf_num, uint32_t weight_inf_num);
        void PdpRdmaUpdateStatRegisters(uint32_t group_id, uint32_t saturation_num);

        //LUT read/write functions
        //LUT_COMMENT virtual uint16_t read_lut() = 0;
        //LUT_COMMENT virtual void write_lut() = 0;
};
SCSIM_NAMESPACE_END()

#endif
