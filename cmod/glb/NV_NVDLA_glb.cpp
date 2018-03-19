// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_glb.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_glb.h"
#include "NV_NVDLA_glb_glb_gen.h"
#include "NV_NVDLA_glb_gec_gen.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "math.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

//#include <stdio.h>

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

NV_NVDLA_glb::NV_NVDLA_glb( sc_module_name module_name ):
    NV_NVDLA_glb_base(module_name),
    // Delay setup
    csb_delay_(SC_ZERO_TIME),
    b_transport_delay_(SC_ZERO_TIME)
{
    Reset();
    is_there_ongoing_csb2glb_response_ = false;
    is_there_ongoing_csb2gec_response_ = false;
    // SC_THREAD
    // SC_METHOD
    SC_METHOD(UpdateBdmaIntrStatus_0)
    sensitive << bdma2glb_done_intr[0];
    SC_METHOD(UpdateBdmaIntrStatus_1)
    sensitive << bdma2glb_done_intr[1];

    SC_METHOD(UpdatePdpIntrStatus_0)
    sensitive << pdp2glb_done_intr[0];
    SC_METHOD(UpdatePdpIntrStatus_1)
    sensitive << pdp2glb_done_intr[1];

    SC_METHOD(UpdateSdpIntrStatus_0)
    sensitive << sdp2glb_done_intr[0];
    SC_METHOD(UpdateSdpIntrStatus_1)
    sensitive << sdp2glb_done_intr[1];

    SC_METHOD(UpdateCdpIntrStatus_0)
    sensitive << cdp2glb_done_intr[0];
    SC_METHOD(UpdateCdpIntrStatus_1)
    sensitive << cdp2glb_done_intr[1];

    SC_METHOD(UpdateRbkIntrStatus_0)
    sensitive << rbk2glb_done_intr[0];

    SC_METHOD(UpdateRbkIntrStatus_1)
    sensitive << rbk2glb_done_intr[1];

    SC_METHOD(UpdateCdmaDatIntrStatus_0)
    sensitive << cdma_dat2glb_done_intr[0];

    SC_METHOD(UpdateCdmaDatIntrStatus_1)
    sensitive << cdma_dat2glb_done_intr[1];

    SC_METHOD(UpdateCdmaWtIntrStatus_0)
    sensitive << cdma_wt2glb_done_intr[0];

    SC_METHOD(UpdateCdmaWtIntrStatus_1)
    sensitive << cdma_wt2glb_done_intr[1];

    SC_METHOD(UpdateCaccIntrStatus_0)
    sensitive << cacc2glb_done_intr[0];

    SC_METHOD(UpdateCaccIntrStatus_1)
    sensitive << cacc2glb_done_intr[1];

    SC_METHOD(Update_nvdla_intr_bdma_0)
    sensitive << bdma2glb_done_intr[0];

    SC_METHOD(Update_nvdla_intr_bdma_1)
    sensitive << bdma2glb_done_intr[1];

    SC_METHOD(Update_nvdla_intr_pdp_0)
    sensitive << pdp2glb_done_intr[0];

    SC_METHOD(Update_nvdla_intr_pdp_1)
    sensitive << pdp2glb_done_intr[1];

    SC_METHOD(Update_nvdla_intr_sdp_0)
    sensitive << sdp2glb_done_intr[0];

    SC_METHOD(Update_nvdla_intr_sdp_1)
    sensitive << sdp2glb_done_intr[1];

    SC_METHOD(Update_nvdla_intr_cdp_0)
    sensitive << cdp2glb_done_intr[0];

    SC_METHOD(Update_nvdla_intr_cdp_1)
    sensitive << cdp2glb_done_intr[1];

    SC_METHOD(Update_nvdla_intr_rbk_0)
    sensitive << rbk2glb_done_intr[0];

    SC_METHOD(Update_nvdla_intr_rbk_1)
    sensitive << rbk2glb_done_intr[1];

    SC_METHOD(Update_nvdla_intr_cdma_dat_0)
    sensitive << cdma_dat2glb_done_intr[0];

    SC_METHOD(Update_nvdla_intr_cdma_dat_1)
    sensitive << cdma_dat2glb_done_intr[1];

    SC_METHOD(Update_nvdla_intr_cdma_wt_0)
    sensitive << cdma_wt2glb_done_intr[0];

    SC_METHOD(Update_nvdla_intr_cdma_wt_1)
    sensitive << cdma_wt2glb_done_intr[1];

    SC_METHOD(Update_nvdla_intr_cacc_0)
    sensitive << cacc2glb_done_intr[0];

    SC_METHOD(Update_nvdla_intr_cacc_1)
    sensitive << cacc2glb_done_intr[1];

    // Response to reg write to glb_status
    SC_METHOD(Update_nvdla_intr_w)
    sensitive << glb_reg_model::intr_status_w;
    dont_initialize();
}

void NV_NVDLA_glb::UpdateBdmaIntrStatus_0() {
    if(bdma2glb_done_intr[0]==true)
        glb_reg_model::GlbUpdateBdmaIntrStatus_0(true);
}

void NV_NVDLA_glb::UpdateBdmaIntrStatus_1() {
    if(bdma2glb_done_intr[1]==true)
        glb_reg_model::GlbUpdateBdmaIntrStatus_1(true);
}

void NV_NVDLA_glb::UpdatePdpIntrStatus_0() {
    if(pdp2glb_done_intr[0]==true)
        glb_reg_model::GlbUpdatePdpIntrStatus_0(true);
}

void NV_NVDLA_glb::UpdatePdpIntrStatus_1() {
    if(pdp2glb_done_intr[1]==true)
        glb_reg_model::GlbUpdatePdpIntrStatus_1(true);
}

void NV_NVDLA_glb::UpdateSdpIntrStatus_0() {
    if(sdp2glb_done_intr[0]==true) {
        glb_reg_model::GlbUpdateSdpIntrStatus_0(true);
        cslDebug((50, "glb_reg_model::GlbUpdateSdpIntrStatus_0 is called\n"));
    }
}

void NV_NVDLA_glb::UpdateSdpIntrStatus_1() {
    if(sdp2glb_done_intr[1]==true)
        glb_reg_model::GlbUpdateSdpIntrStatus_1(true);
}

void NV_NVDLA_glb::UpdateCdpIntrStatus_0() {
    if(cdp2glb_done_intr[0]==true)
        glb_reg_model::GlbUpdateCdpIntrStatus_0(true);
}

void NV_NVDLA_glb::UpdateCdpIntrStatus_1() {
    if(cdp2glb_done_intr[1]==true)
        glb_reg_model::GlbUpdateCdpIntrStatus_1(true);
}

void NV_NVDLA_glb::UpdateRbkIntrStatus_0() {
    if(rbk2glb_done_intr[0]==true)
        glb_reg_model::GlbUpdateRbkIntrStatus_0(true);
}

void NV_NVDLA_glb::UpdateRbkIntrStatus_1() {
    if(rbk2glb_done_intr[1]==true)
        glb_reg_model::GlbUpdateRbkIntrStatus_1(true);
}

void NV_NVDLA_glb::UpdateCdmaDatIntrStatus_0() {
    if(cdma_dat2glb_done_intr[0]==true)
        glb_reg_model::GlbUpdateCdmaDatIntrStatus_0(true);
}

void NV_NVDLA_glb::UpdateCdmaDatIntrStatus_1() {
    if(cdma_dat2glb_done_intr[1]==true)
        glb_reg_model::GlbUpdateCdmaDatIntrStatus_1(true);
}

void NV_NVDLA_glb::UpdateCdmaWtIntrStatus_0() {
    if(cdma_wt2glb_done_intr[0]==true)
        glb_reg_model::GlbUpdateCdmaWtIntrStatus_0(true);
}

void NV_NVDLA_glb::UpdateCdmaWtIntrStatus_1() {
    if(cdma_wt2glb_done_intr[1]==true)
        glb_reg_model::GlbUpdateCdmaWtIntrStatus_1(true);
}

void NV_NVDLA_glb::UpdateCaccIntrStatus_0() {
    if(cacc2glb_done_intr[0]==true) {
        glb_reg_model::GlbUpdateCaccIntrStatus_0(true);
        cslInfo(("Generating Cacc interrupt0\n"));
    }
}

void NV_NVDLA_glb::UpdateCaccIntrStatus_1() {
    if(cacc2glb_done_intr[1]==true) {
        glb_reg_model::GlbUpdateCaccIntrStatus_1(true);
        cslInfo(("Generating Cacc interrupt1\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_bdma_0() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_bdma_0\n"));
    if(bdma2glb_done_intr[0] && !s_intr_mask_bdma_done_mask0_) {
       nvdla_intr.write(true);
       cslInfo(("Generating BDMA interrupt0\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_bdma_1() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_bdma_1\n"));
    if(bdma2glb_done_intr[1] && !s_intr_mask_bdma_done_mask1_) {
       nvdla_intr.write(true);
       cslInfo(("Generating BDMA interrupt1\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_pdp_0() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_pdp_0\n"));
    if(pdp2glb_done_intr[0] && !s_intr_mask_pdp_done_mask0_) {
       nvdla_intr.write(true);
       cslInfo(("Generating PDP interrupt0\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_pdp_1() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_pdp_1\n"));
    if(pdp2glb_done_intr[1] && !s_intr_mask_pdp_done_mask1_) {
       nvdla_intr.write(true);
       cslInfo(("Generating PDP interrupt1\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_sdp_0() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_sdp_0\n"));
    if(sdp2glb_done_intr[0] && !s_intr_mask_sdp_done_mask0_) {
       nvdla_intr.write(true);
       cslInfo(("Generating SDP interrupt0\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_sdp_1() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_sdp_1\n"));
    if(sdp2glb_done_intr[1] && !s_intr_mask_sdp_done_mask1_) {
       nvdla_intr.write(true);
       cslInfo(("Generating SDP interrupt1\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_cdp_0() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_cdp_0\n"));
    if(cdp2glb_done_intr[0] && !s_intr_mask_cdp_done_mask0_) {
       nvdla_intr.write(true);
       cslInfo(("Generating CDP interrupt0\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_cdp_1() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_cdp_1\n"));
    if(cdp2glb_done_intr[1] && !s_intr_mask_cdp_done_mask1_) {
       nvdla_intr.write(true);
       cslInfo(("Generating CDP interrupt1\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_rbk_0() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_rbk_0\n"));
    if(rbk2glb_done_intr[0] && !s_intr_mask_rubik_done_mask0_) {
       nvdla_intr.write(true);
       cslInfo(("Generating RBK interrupt0\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_rbk_1() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_rbk_1\n"));
    if(rbk2glb_done_intr[1] && !s_intr_mask_rubik_done_mask1_) {
       nvdla_intr.write(true);
       cslInfo(("Generating RBK interrupt1\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_cdma_dat_0() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_cdma_dat_0\n"));
    if(cdma_dat2glb_done_intr[0] && !s_intr_mask_cdma_dat_done_mask0_) {
       nvdla_intr.write(true);
       cslInfo(("Generating CDMA_DAT interrupt0\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_cdma_dat_1() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_cdma_dat_1\n"));
    if(cdma_dat2glb_done_intr[1] && !s_intr_mask_cdma_dat_done_mask1_) {
       nvdla_intr.write(true);
       cslInfo(("Generating CDMA_DAT interrupt1\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_cdma_wt_0() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_cdma_wt_0\n"));
    if(cdma_wt2glb_done_intr[0] && !s_intr_mask_cdma_wt_done_mask0_) {
       nvdla_intr.write(true);
       cslInfo(("Generating CDMA_WT interrupt0\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_cdma_wt_1() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_cdma_wt_1\n"));
    if(cdma_wt2glb_done_intr[1] && !s_intr_mask_cdma_wt_done_mask1_) {
       nvdla_intr.write(true);
       cslInfo(("Generating CDMA_WT interrupt1\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_cacc_0() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_cacc_0\n"));
    if(cacc2glb_done_intr[0] && !s_intr_mask_cacc_done_mask0_) {
       nvdla_intr.write(true);
       cslInfo(("Generating CACC interrupt0\n"));
    }
}

void NV_NVDLA_glb::Update_nvdla_intr_cacc_1() {
    cslInfo(("calling NV_NVDLA_glb::Update_nvdla_intr_cacc_1\n"));
    if(cacc2glb_done_intr[1] && !s_intr_mask_cacc_done_mask1_) {
       nvdla_intr.write(true);
       cslInfo(("Generating CACC interrupt1\n"));
    }
}

// Clear interrupt to nvdla_core when glb_intr_status is writen from csb
void NV_NVDLA_glb::Update_nvdla_intr_w(){
    if(!(s_intr_status_sdp_done_status0_ || s_intr_status_sdp_done_status1_ ||
        s_intr_status_cdp_done_status0_ || s_intr_status_cdp_done_status1_ ||
        s_intr_status_pdp_done_status0_ || s_intr_status_pdp_done_status1_ ||
        s_intr_status_bdma_done_status0_ || s_intr_status_bdma_done_status1_ ||
        s_intr_status_rubik_done_status0_ || s_intr_status_rubik_done_status1_ ||
        s_intr_status_cacc_done_status0_ || s_intr_status_cacc_done_status1_ ||
        s_intr_status_cdma_dat_done_status0_ || s_intr_status_cdma_dat_done_status1_ ||
        s_intr_status_cdma_wt_done_status0_ || s_intr_status_cdma_wt_done_status1_)) {
        nvdla_intr.write(false);
    }
}

NV_NVDLA_glb::~NV_NVDLA_glb () {
}

void NV_NVDLA_glb::Reset()
{
    // Clear register and internal states
    GlbRegReset();

    // interrupt fired
    nvdla_intr.initialize(false);
}

NV_NVDLA_glb * NV_NVDLA_glbCon(sc_module_name name) {
    return new NV_NVDLA_glb(name);
}

