// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cdp_rdma_reg_model.h

#ifndef _CDP_RDMA_REG_MODEL_H_
#define _CDP_RDMA_REG_MODEL_H_

#include <systemc.h>
#include <tlm.h>

#include "scsim_common.h"

//LUT_COMMENT #include "NvdlaLut.h"
// //LUT_COMMENT class NvdlaLut;
SCSIM_NAMESPACE_START(clib)
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// Forward declarating cmacro parsed register model class
class CNVDLA_CDP_RDMA_REGSET;
// 
class cdp_rdma_reg_model {
    public:
        cdp_rdma_reg_model();
        ~cdp_rdma_reg_model();
    protected:
        //bool is_there_ongoing_cdp_rdma_csb_response_;
        CNVDLA_CDP_RDMA_REGSET *cdp_rdma_register_group_0;
        CNVDLA_CDP_RDMA_REGSET *cdp_rdma_register_group_1;

        sc_event event_cdp_rdma_reg_group_0_operation_enable;
        sc_event event_cdp_rdma_reg_group_1_operation_enable;

        //LUT_COMMENT NvdlaLut *cdp_rdma_lut;
        uint32_t cdp_rdma_lut_table_idx;  // 0: RAW, 1: DENSITY
        uint32_t cdp_rdma_lut_entry_idx;
        uint32_t cdp_rdma_lut_data;
        uint32_t cdp_rdma_lut_access;

        // Register field variables
        uint8_t   cdp_rdma_status_0_;
        uint8_t   cdp_rdma_status_1_;
        uint8_t   cdp_rdma_producer_;
        uint8_t   cdp_rdma_consumer_;
        uint8_t   cdp_rdma_op_en_;
        uint16_t  cdp_rdma_width_;
        uint16_t  cdp_rdma_height_;
        uint16_t  cdp_rdma_channel_;
        uint32_t  cdp_rdma_src_base_addr_low_;
        uint32_t  cdp_rdma_src_base_addr_high_;
        uint32_t  cdp_rdma_src_line_stride_;
        uint32_t  cdp_rdma_src_surface_stride_;
        uint8_t   cdp_rdma_src_ram_type_;
        uint8_t   cdp_rdma_src_compression_en_;
        uint8_t   cdp_rdma_operation_mode_;
        uint8_t   cdp_rdma_input_data_;
        uint8_t   cdp_rdma_dma_en_;
        uint32_t  cdp_rdma_perf_read_stall_;
        uint32_t  cdp_rdma_cya_;

        // CSB request target socket
        // void csb2cdp_rdma_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // CSB response send function
        // void CdpRdmaSendCsbResponse(uint32_t date, uint8_t error_id);
        // Register accessing
        bool CdpRdmaAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write);
        // Reset
        void CdpRdmaRegReset();
        // Update configuration from register to variable
        void CdpRdmaUpdateVariables(CNVDLA_CDP_RDMA_REGSET *reg_group_ptr);
        bool CdpRdmaUpdateStatusRegister(uint32_t addr, uint8_t group, uint32_t reg);
        void CdpRdmaClearOpeartionEnable(CNVDLA_CDP_RDMA_REGSET *reg_group_ptr);
        uint32_t CdpRdmaGetOpeartionEnable(CNVDLA_CDP_RDMA_REGSET *reg_group_ptr);
        void CdpRdmaIncreaseConsumerPointer();
        void CdpRdmaUpdateWorkingStatus(uint32_t group_id, uint32_t status);
        void CdpRdmaUpdateStatRegisters(uint32_t group_id);
        void CdpRdmaUpdateStatRegisters(uint32_t group_id, uint32_t data_nan_num, uint32_t weight_nan_num, uint32_t data_inf_num, uint32_t weight_inf_num);
        void CdpRdmaUpdateStatRegisters(uint32_t group_id, uint32_t saturation_num);

        //LUT read/write functions
        //LUT_COMMENT virtual uint16_t read_lut() = 0;
        //LUT_COMMENT virtual void write_lut() = 0;
};
SCSIM_NAMESPACE_END()

#endif
