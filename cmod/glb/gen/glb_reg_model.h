// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: glb_reg_model.h

#ifndef _GLB_REG_MODEL_H_
#define _GLB_REG_MODEL_H_

#include <systemc.h>
#include <tlm.h>

#include "scsim_common.h"

SCSIM_NAMESPACE_START(clib)
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// Forward declarating cmacro parsed register model class
class CNVDLA_GLB_REGSET;

class glb_reg_model {
    public:
        glb_reg_model();
        ~glb_reg_model();
        sc_event operation_enable_event_;
        sc_event intr_status_w;
    protected:
//        bool is_there_ongoing_glb_csb_response_;
        CNVDLA_GLB_REGSET *glb_register_group;

        // Register field variables
        uint8_t   s_nvdla_hw_version_major_;
        uint16_t  s_nvdla_hw_version_minor_;
        uint8_t   s_intr_mask_sdp_done_mask0_;
        uint8_t   s_intr_mask_sdp_done_mask1_;
        uint8_t   s_intr_mask_cdp_done_mask0_;
        uint8_t   s_intr_mask_cdp_done_mask1_;
        uint8_t   s_intr_mask_pdp_done_mask0_;
        uint8_t   s_intr_mask_pdp_done_mask1_;
        uint8_t   s_intr_mask_bdma_done_mask0_;
        uint8_t   s_intr_mask_bdma_done_mask1_;
        uint8_t   s_intr_mask_rubik_done_mask0_;
        uint8_t   s_intr_mask_rubik_done_mask1_;
        uint8_t   s_intr_mask_cdma_dat_done_mask0_;
        uint8_t   s_intr_mask_cdma_dat_done_mask1_;
        uint8_t   s_intr_mask_cdma_wt_done_mask0_;
        uint8_t   s_intr_mask_cdma_wt_done_mask1_;
        uint8_t   s_intr_mask_cacc_done_mask0_;
        uint8_t   s_intr_mask_cacc_done_mask1_;
        uint8_t   s_intr_set_sdp_done_set0_;
        uint8_t   s_intr_set_sdp_done_set1_;
        uint8_t   s_intr_set_cdp_done_set0_;
        uint8_t   s_intr_set_cdp_done_set1_;
        uint8_t   s_intr_set_pdp_done_set0_;
        uint8_t   s_intr_set_pdp_done_set1_;
        uint8_t   s_intr_set_bdma_done_set0_;
        uint8_t   s_intr_set_bdma_done_set1_;
        uint8_t   s_intr_set_rubik_done_set0_;
        uint8_t   s_intr_set_rubik_done_set1_;
        uint8_t   s_intr_set_cdma_dat_done_set0_;
        uint8_t   s_intr_set_cdma_dat_done_set1_;
        uint8_t   s_intr_set_cdma_wt_done_set0_;
        uint8_t   s_intr_set_cdma_wt_done_set1_;
        uint8_t   s_intr_set_cacc_done_set0_;
        uint8_t   s_intr_set_cacc_done_set1_;
        uint8_t   s_intr_status_sdp_done_status0_;
        uint8_t   s_intr_status_sdp_done_status1_;
        uint8_t   s_intr_status_cdp_done_status0_;
        uint8_t   s_intr_status_cdp_done_status1_;
        uint8_t   s_intr_status_pdp_done_status0_;
        uint8_t   s_intr_status_pdp_done_status1_;
        uint8_t   s_intr_status_bdma_done_status0_;
        uint8_t   s_intr_status_bdma_done_status1_;
        uint8_t   s_intr_status_rubik_done_status0_;
        uint8_t   s_intr_status_rubik_done_status1_;
        uint8_t   s_intr_status_cdma_dat_done_status0_;
        uint8_t   s_intr_status_cdma_dat_done_status1_;
        uint8_t   s_intr_status_cdma_wt_done_status0_;
        uint8_t   s_intr_status_cdma_wt_done_status1_;
        uint8_t   s_intr_status_cacc_done_status0_;
        uint8_t   s_intr_status_cacc_done_status1_;

        // CSB request target socket
        // void csb2glb_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // CSB response send function
        // void GlbSendCsbResponse(uint32_t date, uint8_t error_id);
        // Register accessing
        bool GlbAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write);
        // Reset
        void GlbRegReset();
        // Update configuration from register to variable
        void GlbUpdateVariables(CNVDLA_GLB_REGSET *reg_group_ptr);
        //void GlbUpdateIdleStatus(bool status);
        void GlbUpdateBdmaIntrStatus_0(bool status);
        void GlbUpdateBdmaIntrStatus_1(bool status);
        void GlbUpdateCdmaDatIntrStatus_0(bool status);
        void GlbUpdateCdmaDatIntrStatus_1(bool status);
        void GlbUpdateCdmaWtIntrStatus_0(bool status);
        void GlbUpdateCdmaWtIntrStatus_1(bool status);
        void GlbUpdatePdpIntrStatus_0(bool status);
        void GlbUpdatePdpIntrStatus_1(bool status);
        void GlbUpdateSdpIntrStatus_0(bool status);
        void GlbUpdateSdpIntrStatus_1(bool status);
        void GlbUpdateCdpIntrStatus_0(bool status);
        void GlbUpdateCdpIntrStatus_1(bool status);
        void GlbUpdateRbkIntrStatus_0(bool status);
        void GlbUpdateRbkIntrStatus_1(bool status);
        void GlbUpdateCaccIntrStatus_0(bool status);
        void GlbUpdateCaccIntrStatus_1(bool status);
};
SCSIM_NAMESPACE_END()

#endif
