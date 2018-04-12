// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: glb_reg_model.cpp

#include "glb_reg_model.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

SCSIM_NAMESPACE_START(cmod)
    MK_UREGSET_CLASS(NVDLA_GLB)
SCSIM_NAMESPACE_END()

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace tlm;
using namespace sc_core;
using namespace std;


glb_reg_model::glb_reg_model() {
    glb_register_group = new CNVDLA_GLB_REGSET;
    GlbRegReset();
}

glb_reg_model::~glb_reg_model() {
    delete glb_register_group;
}

bool glb_reg_model::GlbAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write) {
    uint32_t offset;
    uint32_t rdata = 0;
    uint32_t new_value = 0;

    cslDebug((50, "glb_reg_model::GlbAccessRegister addr=0x%x data=0x%x is_write=%d\n", reg_addr, data, is_write));

    offset = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes

    if (is_write) { // Write Request
        if (offset == REG_off(NVDLA_GLB_S_INTR_STATUS)) {
            glb_register_group->Get(offset, &rdata);
            new_value = rdata & (~data);
            glb_register_group->SetWritable(offset, new_value);
            if((new_value&0xf03ff)==0)
                intr_status_w.notify();
        } else {
            glb_register_group->SetWritable(offset, data);
        }
        GlbUpdateVariables(glb_register_group);
        cslDebug((50, "glb_reg_model::GlbAccessRegister write to offset 0x%x with 0x%x\n", offset, data));
    } else { // Read Request
        glb_register_group->Get(offset, &rdata);
        data = rdata;
    }
    return true;
}

void glb_reg_model::GlbRegReset() {
        glb_register_group->ResetAll();

}

//void glb_reg_model::GlbUpdateIdleStatus(bool status) {
//}

void glb_reg_model::GlbUpdateBdmaIntrStatus_0(bool status) {
    glb_register_group->rS_INTR_STATUS.uBDMA_DONE_STATUS0(status);
}

void glb_reg_model::GlbUpdateBdmaIntrStatus_1(bool status) {
    glb_register_group->rS_INTR_STATUS.uBDMA_DONE_STATUS1(status);
}

void glb_reg_model::GlbUpdatePdpIntrStatus_0(bool status) {
    glb_register_group->rS_INTR_STATUS.uPDP_DONE_STATUS0(status);
}

void glb_reg_model::GlbUpdatePdpIntrStatus_1(bool status) {
    glb_register_group->rS_INTR_STATUS.uPDP_DONE_STATUS1(status);
}

void glb_reg_model::GlbUpdateSdpIntrStatus_0(bool status) {
    glb_register_group->rS_INTR_STATUS.uSDP_DONE_STATUS0(status);
}

void glb_reg_model::GlbUpdateSdpIntrStatus_1(bool status) {
    glb_register_group->rS_INTR_STATUS.uSDP_DONE_STATUS1(status);
}

void glb_reg_model::GlbUpdateCdpIntrStatus_0(bool status) {
    glb_register_group->rS_INTR_STATUS.uCDP_DONE_STATUS0(status);
}

void glb_reg_model::GlbUpdateCdpIntrStatus_1(bool status) {
    glb_register_group->rS_INTR_STATUS.uCDP_DONE_STATUS1(status);
}

void glb_reg_model::GlbUpdateRbkIntrStatus_0(bool status) {
    glb_register_group->rS_INTR_STATUS.uRUBIK_DONE_STATUS0(status);
}

void glb_reg_model::GlbUpdateRbkIntrStatus_1(bool status) {
    glb_register_group->rS_INTR_STATUS.uRUBIK_DONE_STATUS1(status);
}

void glb_reg_model::GlbUpdateCaccIntrStatus_0(bool status) {
    glb_register_group->rS_INTR_STATUS.uCACC_DONE_STATUS0(status);
}

void glb_reg_model::GlbUpdateCaccIntrStatus_1(bool status) {
    glb_register_group->rS_INTR_STATUS.uCACC_DONE_STATUS1(status);
}

void glb_reg_model::GlbUpdateCdmaDatIntrStatus_0(bool status) {
    glb_register_group->rS_INTR_STATUS.uCDMA_DAT_DONE_STATUS0(status);
}

void glb_reg_model::GlbUpdateCdmaDatIntrStatus_1(bool status) {
    glb_register_group->rS_INTR_STATUS.uCDMA_DAT_DONE_STATUS1(status);
}

void glb_reg_model::GlbUpdateCdmaWtIntrStatus_0(bool status) {
    glb_register_group->rS_INTR_STATUS.uCDMA_WT_DONE_STATUS0(status);
}

void glb_reg_model::GlbUpdateCdmaWtIntrStatus_1(bool status) {
    glb_register_group->rS_INTR_STATUS.uCDMA_WT_DONE_STATUS1(status);
}

void glb_reg_model::GlbUpdateVariables(CNVDLA_GLB_REGSET *reg_group_ptr) {
        s_nvdla_hw_version_major_ = reg_group_ptr->rS_NVDLA_HW_VERSION.uMAJOR();
        s_nvdla_hw_version_minor_ = reg_group_ptr->rS_NVDLA_HW_VERSION.uMINOR();
        s_intr_mask_sdp_done_mask0_ = reg_group_ptr->rS_INTR_MASK.uSDP_DONE_MASK0();
        s_intr_mask_sdp_done_mask1_ = reg_group_ptr->rS_INTR_MASK.uSDP_DONE_MASK1();
        s_intr_mask_cdp_done_mask0_ = reg_group_ptr->rS_INTR_MASK.uCDP_DONE_MASK0();
        s_intr_mask_cdp_done_mask1_ = reg_group_ptr->rS_INTR_MASK.uCDP_DONE_MASK1();
        s_intr_mask_pdp_done_mask0_ = reg_group_ptr->rS_INTR_MASK.uPDP_DONE_MASK0();
        s_intr_mask_pdp_done_mask1_ = reg_group_ptr->rS_INTR_MASK.uPDP_DONE_MASK1();
        s_intr_mask_bdma_done_mask0_ = reg_group_ptr->rS_INTR_MASK.uBDMA_DONE_MASK0();
        s_intr_mask_bdma_done_mask1_ = reg_group_ptr->rS_INTR_MASK.uBDMA_DONE_MASK1();
        s_intr_mask_rubik_done_mask0_ = reg_group_ptr->rS_INTR_MASK.uRUBIK_DONE_MASK0();
        s_intr_mask_rubik_done_mask1_ = reg_group_ptr->rS_INTR_MASK.uRUBIK_DONE_MASK1();
        s_intr_mask_cdma_dat_done_mask0_ = reg_group_ptr->rS_INTR_MASK.uCDMA_DAT_DONE_MASK0();
        s_intr_mask_cdma_dat_done_mask1_ = reg_group_ptr->rS_INTR_MASK.uCDMA_DAT_DONE_MASK1();
        s_intr_mask_cdma_wt_done_mask0_ = reg_group_ptr->rS_INTR_MASK.uCDMA_WT_DONE_MASK0();
        s_intr_mask_cdma_wt_done_mask1_ = reg_group_ptr->rS_INTR_MASK.uCDMA_WT_DONE_MASK1();
        s_intr_mask_cacc_done_mask0_ = reg_group_ptr->rS_INTR_MASK.uCACC_DONE_MASK0();
        s_intr_mask_cacc_done_mask1_ = reg_group_ptr->rS_INTR_MASK.uCACC_DONE_MASK1();
        s_intr_set_sdp_done_set0_ = reg_group_ptr->rS_INTR_SET.uSDP_DONE_SET0();
        s_intr_set_sdp_done_set1_ = reg_group_ptr->rS_INTR_SET.uSDP_DONE_SET1();
        s_intr_set_cdp_done_set0_ = reg_group_ptr->rS_INTR_SET.uCDP_DONE_SET0();
        s_intr_set_cdp_done_set1_ = reg_group_ptr->rS_INTR_SET.uCDP_DONE_SET1();
        s_intr_set_pdp_done_set0_ = reg_group_ptr->rS_INTR_SET.uPDP_DONE_SET0();
        s_intr_set_pdp_done_set1_ = reg_group_ptr->rS_INTR_SET.uPDP_DONE_SET1();
        s_intr_set_bdma_done_set0_ = reg_group_ptr->rS_INTR_SET.uBDMA_DONE_SET0();
        s_intr_set_bdma_done_set1_ = reg_group_ptr->rS_INTR_SET.uBDMA_DONE_SET1();
        s_intr_set_rubik_done_set0_ = reg_group_ptr->rS_INTR_SET.uRUBIK_DONE_SET0();
        s_intr_set_rubik_done_set1_ = reg_group_ptr->rS_INTR_SET.uRUBIK_DONE_SET1();
        s_intr_set_cdma_dat_done_set0_ = reg_group_ptr->rS_INTR_SET.uCDMA_DAT_DONE_SET0();
        s_intr_set_cdma_dat_done_set1_ = reg_group_ptr->rS_INTR_SET.uCDMA_DAT_DONE_SET1();
        s_intr_set_cdma_wt_done_set0_ = reg_group_ptr->rS_INTR_SET.uCDMA_WT_DONE_SET0();
        s_intr_set_cdma_wt_done_set1_ = reg_group_ptr->rS_INTR_SET.uCDMA_WT_DONE_SET1();
        s_intr_set_cacc_done_set0_ = reg_group_ptr->rS_INTR_SET.uCACC_DONE_SET0();
        s_intr_set_cacc_done_set1_ = reg_group_ptr->rS_INTR_SET.uCACC_DONE_SET1();
        s_intr_status_sdp_done_status0_ = reg_group_ptr->rS_INTR_STATUS.uSDP_DONE_STATUS0();
        s_intr_status_sdp_done_status1_ = reg_group_ptr->rS_INTR_STATUS.uSDP_DONE_STATUS1();
        s_intr_status_cdp_done_status0_ = reg_group_ptr->rS_INTR_STATUS.uCDP_DONE_STATUS0();
        s_intr_status_cdp_done_status1_ = reg_group_ptr->rS_INTR_STATUS.uCDP_DONE_STATUS1();
        s_intr_status_pdp_done_status0_ = reg_group_ptr->rS_INTR_STATUS.uPDP_DONE_STATUS0();
        s_intr_status_pdp_done_status1_ = reg_group_ptr->rS_INTR_STATUS.uPDP_DONE_STATUS1();
        s_intr_status_bdma_done_status0_ = reg_group_ptr->rS_INTR_STATUS.uBDMA_DONE_STATUS0();
        s_intr_status_bdma_done_status1_ = reg_group_ptr->rS_INTR_STATUS.uBDMA_DONE_STATUS1();
        s_intr_status_rubik_done_status0_ = reg_group_ptr->rS_INTR_STATUS.uRUBIK_DONE_STATUS0();
        s_intr_status_rubik_done_status1_ = reg_group_ptr->rS_INTR_STATUS.uRUBIK_DONE_STATUS1();
        s_intr_status_cdma_dat_done_status0_ = reg_group_ptr->rS_INTR_STATUS.uCDMA_DAT_DONE_STATUS0();
        s_intr_status_cdma_dat_done_status1_ = reg_group_ptr->rS_INTR_STATUS.uCDMA_DAT_DONE_STATUS1();
        s_intr_status_cdma_wt_done_status0_ = reg_group_ptr->rS_INTR_STATUS.uCDMA_WT_DONE_STATUS0();
        s_intr_status_cdma_wt_done_status1_ = reg_group_ptr->rS_INTR_STATUS.uCDMA_WT_DONE_STATUS1();
        s_intr_status_cacc_done_status0_ = reg_group_ptr->rS_INTR_STATUS.uCACC_DONE_STATUS0();
        s_intr_status_cacc_done_status1_ = reg_group_ptr->rS_INTR_STATUS.uCACC_DONE_STATUS1();

}
