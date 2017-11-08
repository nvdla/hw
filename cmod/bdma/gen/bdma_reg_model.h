// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: bdma_reg_model.h

#ifndef _BDMA_REG_MODEL_H_
#define _BDMA_REG_MODEL_H_

#include <systemc.h>
#include <tlm.h>

#include "scsim_common.h"
// #include "bdmacoreconfigclass.h"

SCSIM_NAMESPACE_START(clib)
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// Forward declarating cmacro parsed register model class
class CNVDLA_BDMA_REGSET;
class BdmaCoreConfig;
// Operator for being a SC_FIFO payload
// std::ostream& operator<<(std::ostream& out, const  BdmaCoreConfig & obj) {
//     return out << "Just to fool compiler" << endl;
// }

class bdma_reg_model {
    public:
        bdma_reg_model();
        ~bdma_reg_model();
        sc_event operation_enable_event_;
        sc_event operation_enable_clr_event_;
        sc_event launch_grp0_event_;
        sc_event launch_grp1_event_;
        uint32_t op_count;
    protected:
        //bool is_there_ongoing_bdma_csb_response_;
        CNVDLA_BDMA_REGSET *bdma_register_group;
        BdmaCoreConfig *bdma_config_class;

        // Register field variables
        uint32_t  cfg_src_addr_low_v32_;
        uint32_t  cfg_src_addr_high_v8_;
        uint32_t  cfg_dst_addr_low_v32_;
        uint32_t  cfg_dst_addr_high_v8_;
        uint16_t  cfg_line_size_;
        uint8_t   cfg_cmd_src_ram_type_;
        uint8_t   cfg_cmd_dst_ram_type_;
        uint32_t  cfg_line_repeat_number_;
        uint32_t  cfg_src_line_stride_;
        uint32_t  cfg_dst_line_stride_;
        uint32_t  cfg_surf_repeat_number_;
        uint32_t  cfg_src_surf_stride_;
        uint32_t  cfg_dst_surf_stride_;
        uint8_t   cfg_op_en_;
        uint8_t   cfg_launch0_grp0_launch_;
        uint8_t   cfg_launch1_grp1_launch_;
        uint8_t   cfg_status_stall_count_en_;
        uint8_t   status_free_slot_;
        uint8_t   status_idle_;
        uint8_t   status_grp0_busy_;
        uint8_t   status_grp1_busy_;
        uint32_t  status_grp0_read_stall_count_;
        uint32_t  status_grp0_write_stall_count_;
        uint32_t  status_grp1_read_stall_count_;
        uint32_t  status_grp1_write_stall_count_;

        // CSB request target socket
        // void csb2bdma_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // CSB response send function
        // void BdmaSendCsbResponse(uint32_t date, uint8_t error_id);
        // Register accessing
        bool BdmaAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write);
        // Reset
        void BdmaRegReset();
        // Clear operation enable bit
        void BdmaClearOperationEnable();
        // Update configuration from register to variable
        void BdmaUpdateVariables(CNVDLA_BDMA_REGSET *reg_group_ptr);
        // Update free configuration slot number
        void BdmaUpdateFreeConfigSlotNum(uint8_t num);
        // Update free configuration slot number
        void BdmaUpdateIdleStatus(bool status);
        // Update free configuration slot number
        void BdmaClearGrp0Int();
        void BdmaClearGrp1Int();
};
SCSIM_NAMESPACE_END()

#endif
