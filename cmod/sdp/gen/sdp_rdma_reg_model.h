// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_rdma_reg_model.h

#ifndef _SDP_RDMA_REG_MODEL_H_
#define _SDP_RDMA_REG_MODEL_H_

#include <systemc.h>
#include <tlm.h>

#include "scsim_common.h"

//LUT_COMMENT #include "NvdlaLut.h"
// //LUT_COMMENT class NvdlaLut;
SCSIM_NAMESPACE_START(clib)
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// Forward declarating cmacro parsed register model class
class CNVDLA_SDP_RDMA_REGSET;
// 
class sdp_rdma_reg_model {
    public:
        sdp_rdma_reg_model();
        ~sdp_rdma_reg_model();
    protected:
        //bool is_there_ongoing_sdp_rdma_csb_response_;
        CNVDLA_SDP_RDMA_REGSET *sdp_rdma_register_group_0;
        CNVDLA_SDP_RDMA_REGSET *sdp_rdma_register_group_1;

        sc_event event_sdp_rdma_reg_group_0_operation_enable;
        sc_event event_sdp_rdma_reg_group_1_operation_enable;

        //LUT_COMMENT NvdlaLut *sdp_rdma_lut;
        uint32_t sdp_rdma_lut_table_idx;  // 0: RAW, 1: DENSITY
        uint32_t sdp_rdma_lut_entry_idx;
        uint32_t sdp_rdma_lut_data;
        uint32_t sdp_rdma_lut_access;

        // Register field variables
        uint8_t   sdp_rdma_status_0_;
        uint8_t   sdp_rdma_status_1_;
        uint8_t   sdp_rdma_producer_;
        uint8_t   sdp_rdma_consumer_;
        uint8_t   sdp_rdma_op_en_;
        uint16_t  sdp_rdma_width_;
        uint16_t  sdp_rdma_height_;
        uint16_t  sdp_rdma_channel_;
        uint32_t  sdp_rdma_src_base_addr_low_;
        uint32_t  sdp_rdma_src_base_addr_high_;
        uint32_t  sdp_rdma_src_line_stride_;
        uint32_t  sdp_rdma_src_surface_stride_;
        uint8_t   sdp_rdma_brdma_disable_;
        uint8_t   sdp_rdma_brdma_data_use_;
        uint8_t   sdp_rdma_brdma_data_size_;
        uint8_t   sdp_rdma_brdma_data_mode_;
        uint8_t   sdp_rdma_brdma_ram_type_;
        uint32_t  sdp_rdma_bs_base_addr_low_;
        uint32_t  sdp_rdma_bs_base_addr_high_;
        uint32_t  sdp_rdma_bs_line_stride_;
        uint32_t  sdp_rdma_bs_surface_stride_;
        uint32_t  sdp_rdma_bs_batch_stride_;
        uint8_t   sdp_rdma_nrdma_disable_;
        uint8_t   sdp_rdma_nrdma_data_use_;
        uint8_t   sdp_rdma_nrdma_data_size_;
        uint8_t   sdp_rdma_nrdma_data_mode_;
        uint8_t   sdp_rdma_nrdma_ram_type_;
        uint32_t  sdp_rdma_bn_base_addr_low_;
        uint32_t  sdp_rdma_bn_base_addr_high_;
        uint32_t  sdp_rdma_bn_line_stride_;
        uint32_t  sdp_rdma_bn_surface_stride_;
        uint32_t  sdp_rdma_bn_batch_stride_;
        uint8_t   sdp_rdma_erdma_disable_;
        uint8_t   sdp_rdma_erdma_data_use_;
        uint8_t   sdp_rdma_erdma_data_size_;
        uint8_t   sdp_rdma_erdma_data_mode_;
        uint8_t   sdp_rdma_erdma_ram_type_;
        uint32_t  sdp_rdma_ew_base_addr_low_;
        uint32_t  sdp_rdma_ew_base_addr_high_;
        uint32_t  sdp_rdma_ew_line_stride_;
        uint32_t  sdp_rdma_ew_surface_stride_;
        uint32_t  sdp_rdma_ew_batch_stride_;
        uint8_t   sdp_rdma_flying_mode_;
        uint8_t   sdp_rdma_winograd_;
        uint8_t   sdp_rdma_in_precision_;
        uint8_t   sdp_rdma_proc_precision_;
        uint8_t   sdp_rdma_out_precision_;
        uint8_t   sdp_rdma_batch_number_;
        uint8_t   sdp_rdma_src_ram_type_;
        uint32_t  sdp_rdma_status_nan_input_num_;
        uint32_t  sdp_rdma_status_inf_input_num_;
        uint8_t   sdp_rdma_perf_dma_en_;
        uint8_t   sdp_rdma_perf_nan_inf_count_en_;
        uint32_t  sdp_rdma_mrdma_stall_;
        uint32_t  sdp_rdma_brdma_stall_;
        uint32_t  sdp_rdma_nrdma_stall_;
        uint32_t  sdp_rdma_erdma_stall_;

        // CSB request target socket
        // void csb2sdp_rdma_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // CSB response send function
        // void SdpRdmaSendCsbResponse(uint32_t date, uint8_t error_id);
        // Register accessing
        bool SdpRdmaAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write);
        // Reset
        void SdpRdmaRegReset();
        // Update configuration from register to variable
        void SdpRdmaUpdateVariables(CNVDLA_SDP_RDMA_REGSET *reg_group_ptr);
        bool SdpRdmaUpdateStatusRegister(uint32_t addr, uint8_t group, uint32_t reg);
        void SdpRdmaClearOpeartionEnable(CNVDLA_SDP_RDMA_REGSET *reg_group_ptr);
        uint32_t SdpRdmaGetOpeartionEnable(CNVDLA_SDP_RDMA_REGSET *reg_group_ptr);
        void SdpRdmaIncreaseConsumerPointer();
        void SdpRdmaUpdateWorkingStatus(uint32_t group_id, uint32_t status);
        void SdpRdmaUpdateStatRegisters(uint32_t group_id);
        void SdpRdmaUpdateStatRegisters(uint32_t group_id, uint32_t data_nan_num, uint32_t weight_nan_num, uint32_t data_inf_num, uint32_t weight_inf_num);
        void SdpRdmaUpdateStatRegisters(uint32_t group_id, uint32_t saturation_num);

        //LUT read/write functions
        //LUT_COMMENT virtual uint16_t read_lut() = 0;
        //LUT_COMMENT virtual void write_lut() = 0;
};
SCSIM_NAMESPACE_END()

#endif
