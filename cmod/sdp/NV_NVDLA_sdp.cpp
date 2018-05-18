// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_sdp.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_sdp.h"
#include "NV_NVDLA_sdp_sdp_gen.h"
#include "NV_NVDLA_sdp_sdp_rdma_gen.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "math.h"
#include "NvdlaDataFormatConvertor.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

#define INTERNAL_BUF_SIZE (256)

// WG/Batch should alwasy play with CC, this makes WG/Batch debugging difficult,
// we added this workaround to allow SDP recieve input data from MC even for
// those mode so that SDP can be debugged standalone
#define CMOD_WAR_WG_BATCH   1

// In unit of 64bytes (16 elements)
#define NVDLA_VMOD_SDP_BRDMA_LATENCY_FIFO_DEPTH         128
#define NVDLA_VMOD_SDP_ERDMA_LATENCY_FIFO_DEPTH         64
#define NVDLA_VMOD_SDP_MRDMA_LATENCY_FIFO_DEPTH         64
#define NVDLA_VMOD_SDP_NRDMA_LATENCY_FIFO_DEPTH         128
#define NVDLA_VMOD_SDP_WDMA_LATENCY_FIFO_DEPTH          64


NV_NVDLA_sdp::NV_NVDLA_sdp( sc_module_name module_name ):
    NV_NVDLA_sdp_base(module_name),
    sdp2glb_done_intr("sdp2glb_done_intr", 2),
    // Delay setup
    dma_delay_(SC_ZERO_TIME),
    csb_delay_(SC_ZERO_TIME),
    b_transport_delay_(SC_ZERO_TIME)
{
    // Memory allocation
#if 0
    rdma_fifo_        = new sc_fifo <int16_t *> (NVDLA_VMOD_SDP_MRDMA_LATENCY_FIFO_DEPTH*2);
    rdma_b_alu_fifo_  = new sc_fifo <int16_t *> (NVDLA_VMOD_SDP_BRDMA_LATENCY_FIFO_DEPTH*2);
    rdma_b_mul_fifo_  = new sc_fifo <int16_t *> (NVDLA_VMOD_SDP_BRDMA_LATENCY_FIFO_DEPTH*2);
    rdma_n_alu_fifo_  = new sc_fifo <int16_t *> (NVDLA_VMOD_SDP_NRDMA_LATENCY_FIFO_DEPTH*2);
    rdma_n_mul_fifo_  = new sc_fifo <int16_t *> (NVDLA_VMOD_SDP_NRDMA_LATENCY_FIFO_DEPTH*2);
    rdma_e_alu_fifo_  = new sc_fifo <int16_t *> (NVDLA_VMOD_SDP_ERDMA_LATENCY_FIFO_DEPTH*2);
    rdma_e_mul_fifo_  = new sc_fifo <int16_t *> (NVDLA_VMOD_SDP_ERDMA_LATENCY_FIFO_DEPTH*2);
    wdma_fifo_        = new sc_fifo <int16_t *> (1);
    cc2pp_fifo_       = new sc_fifo <int32_t *> (1);
#else
    rdma_fifo_        = new sc_fifo <int16_t *> (128*SDP_RDMA_BUFFER_SIZE/ATOM_CUBE_SIZE);
    rdma_b_alu_fifo_  = new sc_fifo <int16_t *> (128*SDP_RDMA_BUFFER_SIZE/ATOM_CUBE_SIZE);
    rdma_b_mul_fifo_  = new sc_fifo <int16_t *> (128*SDP_RDMA_BUFFER_SIZE/ATOM_CUBE_SIZE);
    rdma_n_alu_fifo_  = new sc_fifo <int16_t *> (128*SDP_RDMA_BUFFER_SIZE/ATOM_CUBE_SIZE);
    rdma_n_mul_fifo_  = new sc_fifo <int16_t *> (128*SDP_RDMA_BUFFER_SIZE/ATOM_CUBE_SIZE);
    rdma_e_alu_fifo_  = new sc_fifo <int16_t *> (128*SDP_RDMA_BUFFER_SIZE/ATOM_CUBE_SIZE);
    rdma_e_mul_fifo_  = new sc_fifo <int16_t *> (128*SDP_RDMA_BUFFER_SIZE/ATOM_CUBE_SIZE);
    wdma_fifo_        = new sc_fifo <int16_t *> (128*SDP_RDMA_BUFFER_SIZE/ATOM_CUBE_SIZE);
    cc2pp_fifo_       = new sc_fifo <int32_t *> (128*SDP_RDMA_BUFFER_SIZE/ATOM_CUBE_SIZE);
#endif
    sdp_ack_fifo_     = new sc_fifo <ack_info*> (2);
    sdp_config_fifo_  = new sc_fifo <SdpConfig *> (1);
    for(int i = SDP_RDMA_INPUT; i < SDP_DMA_NUM; i++) {
        sdp_internal_buf_[i]    = new uint8_t[INTERNAL_BUF_SIZE];
        sdp_buf_wr_ptr_[i]      = 0;
        sdp_buf_rd_ptr_[i]      = 0;
        sdp_buf_width_iter_[i]  = 0;
    }

    dma_rd_req_payload_             = new nvdla_dma_rd_req_t;
    dma_b_rd_req_payload_           = new nvdla_dma_rd_req_t;
    dma_n_rd_req_payload_           = new nvdla_dma_rd_req_t;
    dma_e_rd_req_payload_           = new nvdla_dma_rd_req_t;
    dma_wr_req_cmd_payload_         = new nvdla_dma_wr_req_t;
    dma_wr_req_data_payload_        = new nvdla_dma_wr_req_t;
    dma_wr_req_cmd_payload_->tag    = TAG_CMD;
    dma_wr_req_data_payload_->tag   = TAG_DATA;

    payload_alu_                    = NULL;
    payload_mul_                    = NULL;
    payload_index_                  = 0;
    is_mc_ack_done_                 = false;
    is_cv_ack_done_                 = false;

    // Reset
    Reset();

    // SC_THREAD
    SC_THREAD(SdpRdmaConsumerThread);
    SC_THREAD(SdpConsumerThread);
    SC_THREAD(SdpRdmaThread);
    SC_THREAD(SdpBRdmaThread);
    SC_THREAD(SdpNRdmaThread);
    SC_THREAD(SdpERdmaThread);
    SC_THREAD(SdpDataOperationThread);
    SC_THREAD(SdpWdmaThread);
    SC_THREAD(SdpIntrThread);
    SC_METHOD(WriteResponseThreadMc);
    sensitive << mcif2sdp_wr_rsp;
    SC_METHOD(WriteResponseThreadCv);
    sensitive << cvif2sdp_wr_rsp;
}
#pragma CTC SKIP
NV_NVDLA_sdp::~NV_NVDLA_sdp() {
    if( rdma_fifo_ )          delete rdma_fifo_;
    if( sdp_config_fifo_ )    delete sdp_config_fifo_;
    if( rdma_b_alu_fifo_ )    delete rdma_b_alu_fifo_;
    if( rdma_b_mul_fifo_ )    delete rdma_b_mul_fifo_;
    if( rdma_n_alu_fifo_ )    delete rdma_n_alu_fifo_;
    if( rdma_n_mul_fifo_ )    delete rdma_n_mul_fifo_;
    if( rdma_e_alu_fifo_ )    delete rdma_e_alu_fifo_;
    if( rdma_e_mul_fifo_ )    delete rdma_e_mul_fifo_;
    if( wdma_fifo_ )          delete wdma_fifo_;
    if( cc2pp_fifo_ )         delete cc2pp_fifo_;
    if( dma_rd_req_payload_) delete dma_rd_req_payload_;
    if( dma_b_rd_req_payload_) delete dma_b_rd_req_payload_;
    if( dma_n_rd_req_payload_) delete dma_n_rd_req_payload_;
    if( dma_e_rd_req_payload_) delete dma_e_rd_req_payload_;
    if( dma_wr_req_cmd_payload_) delete dma_wr_req_cmd_payload_;
    if( dma_wr_req_data_payload_) delete dma_wr_req_data_payload_;
    if( sdp_ack_fifo_)         delete sdp_ack_fifo_;
    for(int i = SDP_RDMA_INPUT; i < SDP_DMA_NUM; i++) {
        if( sdp_internal_buf_[i] ) delete [] sdp_internal_buf_[i];
    }
}
#pragma CTC ENDSKIP

void NV_NVDLA_sdp::Reset()
{
    // Clear register and internal states
    SdpRegReset();
    SdpRdmaRegReset();
    is_there_ongoing_csb2sdp_response_      = false;
    is_there_ongoing_csb2sdp_rdma_response_ = false;

    sdp2glb_done_intr[0].initialize(false);
    sdp2glb_done_intr[1].initialize(false);
}

void NV_NVDLA_sdp::SdpRdmaConsumerThread() {
    while (true) {
        // Wait some events
        while(SdpRdmaGetOpeartionEnable(sdp_rdma_register_group_0) != NVDLA_SDP_RDMA_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_sdp_rdma_reg_group_0_operation_enable);
        }
        cslInfo(( "NV_NVDLA_sdp::SdpRdmaConsumerThread, group 0 opeartion start\n"));
        sdp_rdma_reg_model::SdpRdmaUpdateWorkingStatus(0,1);
        sdp_rdma_reg_model::SdpRdmaUpdateVariables(sdp_rdma_register_group_0);
#pragma CTC SKIP
        cslInfo(( "group0: %s: WxHxC=%dx%dx%d, M:%d, B:%d, N:%d, E:%d\n",
                    __FUNCTION__, sdp_rdma_width_+1, sdp_rdma_height_+1, sdp_rdma_channel_+1,
                    !sdp_rdma_flying_mode_, !sdp_rdma_brdma_disable_, !sdp_rdma_nrdma_disable_, !sdp_rdma_erdma_disable_));
#pragma CTC ENDSKIP
        SdpRdmaHardwareLayerExecutionTrigger();
        sdp_rdma_reg_model::SdpRdmaUpdateWorkingStatus(0,0);
        sdp_rdma_reg_model::SdpRdmaClearOpeartionEnable(sdp_rdma_register_group_0);
        cslInfo(("NV_NVDLA_sdp::SdpRdmaConsumerThread, group 0 opeartion done\n"));

        while(SdpRdmaGetOpeartionEnable(sdp_rdma_register_group_1) != NVDLA_SDP_RDMA_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_sdp_rdma_reg_group_1_operation_enable);
        }
        cslInfo(( "NV_NVDLA_sdp::SdpRdmaConsumerThread, group 1 opeartion start\n"));
        sdp_rdma_reg_model::SdpRdmaUpdateWorkingStatus(1,1);
        sdp_rdma_reg_model::SdpRdmaUpdateVariables(sdp_rdma_register_group_1);
#pragma CTC SKIP
        cslInfo(( "group1: %s: WxHxC=%dx%dx%d, M:%d, B:%d, N:%d, E:%d\n",
                    __FUNCTION__, sdp_rdma_width_+1, sdp_rdma_height_+1, sdp_rdma_channel_+1,
                    !sdp_rdma_flying_mode_, !sdp_rdma_brdma_disable_, !sdp_rdma_nrdma_disable_, !sdp_rdma_erdma_disable_));
#pragma CTC ENDSKIP
        SdpRdmaHardwareLayerExecutionTrigger();
        sdp_rdma_reg_model::SdpRdmaUpdateWorkingStatus(1,0);
        sdp_rdma_reg_model::SdpRdmaClearOpeartionEnable(sdp_rdma_register_group_1);
        cslInfo(( "NV_NVDLA_sdp::SdpRdmaConsumerThread, group 1 opeartion done\n"));
    }
#pragma CTC SKIP
}
#pragma CTC ENDSKIP

void NV_NVDLA_sdp::SdpConsumerThread() {
    while (true) {
        while(SdpGetOpeartionEnable(sdp_register_group_0) != NVDLA_SDP_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_sdp_reg_group_0_operation_enable);
        }
        cslInfo(( "NV_NVDLA_sdp::SdpConsumerThread, group 0 opeartion start\n"));
        sdp_reg_model::SdpUpdateWorkingStatus(0,1);
        sdp_reg_model::SdpUpdateVariables(sdp_register_group_0);
        SdpHardwareLayerExecutionTrigger();
        sdp_reg_model::SdpUpdateWorkingStatus(0,0);
        sdp_reg_model::SdpClearOpeartionEnable(sdp_register_group_0);
        cslInfo(( "NV_NVDLA_sdp::SdpConsumerThread, group 0 opeartion done\n"));

        while(SdpGetOpeartionEnable(sdp_register_group_1) != NVDLA_SDP_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_sdp_reg_group_1_operation_enable);
        }
        cslInfo(( "NV_NVDLA_sdp::SdpConsumerThread, group 1 opeartion start\n"));
        sdp_reg_model::SdpUpdateWorkingStatus(1,1);
        sdp_reg_model::SdpUpdateVariables(sdp_register_group_1);
        SdpHardwareLayerExecutionTrigger();
        sdp_reg_model::SdpUpdateWorkingStatus(1,0);
        sdp_reg_model::SdpClearOpeartionEnable(sdp_register_group_1);
        cslInfo(( "NV_NVDLA_sdp::SdpConsumerThread, group 1 opeartion done\n"));
    }
#pragma CTC SKIP
}
#pragma CTC ENDSKIP

void NV_NVDLA_sdp::SdpIntrThread() {
    while (true) {
        ack_info *ack = sdp_ack_fifo_->read();

        if (ack->is_mc == 1) {
#pragma CTC SKIP
            if (!is_mc_ack_done_)
                wait(sdp_mc_ack_);
#pragma CTC ENDSKIP

            is_mc_ack_done_ = false;
        } else if (ack->is_mc == 0){
#pragma CTC SKIP
            if (!is_cv_ack_done_)
                wait(sdp_cv_ack_);
#pragma CTC ENDSKIP

            is_cv_ack_done_ = false;
        }

        wait(1, SC_NS);
        cslInfo(( "%s: trigger interrupt on %d group\n", __FUNCTION__, (uint32_t)ack->group_id));
        sdp2glb_done_intr[ack->group_id].write(true);

        delete ack;
    }
#pragma CTC SKIP
}
#pragma CTC ENDSKIP


void NV_NVDLA_sdp::SdpRdmaHardwareLayerExecutionTrigger () {
    SdpConfig *cfg;

    cslInfo(( "%s invoked\n", __FUNCTION__));
    cfg = new SdpConfig;
    cfg->sdp_rdma_brdma_data_mode_ = sdp_rdma_brdma_data_mode_;
    cfg->sdp_rdma_nrdma_data_mode_ = sdp_rdma_nrdma_data_mode_;
    cfg->sdp_rdma_erdma_data_mode_ = sdp_rdma_erdma_data_mode_;
    sdp_config_fifo_->write(cfg);

    cslInfo(( "before sdp rdma HWL done\n"));
    sdp_rdma_kickoff_.notify(SC_ZERO_TIME);
    wait(sdp_rdma_done_ & sdp_b_rdma_done_ & sdp_n_rdma_done_ & sdp_e_rdma_done_);
    cslInfo(( "sdp rdma HWL done\n"));
}

void NV_NVDLA_sdp::SdpHardwareLayerExecutionTrigger () {
    sdp_kickoff_.notify(SC_ZERO_TIME);
    cslInfo(( "sdp before wait sdp_done_\n"));
    wait(sdp_done_);
    cslInfo(( "sdp after wait sdp_done_\n"));
}

void NV_NVDLA_sdp::SdpRdmaCore( te_rdma_type eRdDma ) {
    // Config variables, they have corresponding value in registers
    uint32_t    cube_width, cube_height, cube_channel;
    uint32_t    line_stride;
    uint32_t    surf_stride;
    // Control variables
    // # Iterators
    uint32_t    surf_iter;
    uint32_t    surf_num;
    uint32_t    line_iter, col_iter, trans_iter;
    // # Evaluated variable
    uint64_t    src_base_addr;
    uint64_t    payload_addr;
    uint32_t    payload_size;
    uint32_t    payload_atom_num;
    uint8_t     element_per_group_src;
    bool        enabled;
    uint32_t    component_per_element, bytes_per_component, data_mode;
    uint32_t    batch_num;
    uint32_t    bytes_per_element;
    nvdla_dma_rd_req_t *payload = NULL;
    bool        is_int16_to_int8 = false;
    bool        is_1x1 = false;
    uint32_t    precision = (eRdDma == SDP_RDMA_INPUT) ? sdp_rdma_in_precision_ : sdp_rdma_proc_precision_;

    // Common for all DMAs
    // Copy from register value to local config variables, similar with RTL connection, begin
    // # Cube setting
    cube_width      = sdp_rdma_width_+1;
    cube_height     = sdp_rdma_height_+1;
    cube_channel    = sdp_rdma_channel_+1;
    is_1x1 = cube_width == 1 && cube_height == 1;
    // # Precision setting
    switch (precision) {
        case NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_IN_PRECISION_INT8:
            element_per_group_src   = ELEMENT_PER_GROUP_INT8;
            break;
        case NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_IN_PRECISION_INT16:
            element_per_group_src   = ELEMENT_PER_GROUP_INT16;
            break;
        case NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_IN_PRECISION_FP16:
            element_per_group_src   = ELEMENT_PER_GROUP_FP16;
            break;
#pragma CTC SKIP
        default: break;
#pragma CTC ENDSKIP
    }
    // Copy from register value to local config variables, similar with RTL connection, end
    surf_num = (cube_channel + element_per_group_src - 1) / element_per_group_src;
    batch_num = sdp_rdma_batch_number_+1;

    switch(eRdDma) {
        case SDP_RDMA_INPUT:
            src_base_addr   = (uint64_t(sdp_rdma_src_base_addr_high_) << 32) | uint64_t(sdp_rdma_src_base_addr_low_);
            line_stride         = sdp_rdma_src_line_stride_;
            surf_stride         = sdp_rdma_src_surface_stride_;
            enabled             = NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_FLYING_MODE_OFF == sdp_rdma_flying_mode_;
            component_per_element = 1;
            bytes_per_component   = sdp_rdma_in_precision_ == NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_IN_PRECISION_INT8 ? 1:2;
            data_mode= is_1x1 ? NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DATA_MODE_PER_KERNEL:NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DATA_MODE_PER_ELEMENT;
            payload             = dma_rd_req_payload_;
#ifndef CMOD_WAR_WG_BATCH
            cslAssert((batch_num == 1));
            cslAssert((sdp_rdma_winograd_ == NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_WINOGRAD_OFF));
#endif
            break;
        case SDP_RDMA_X1_INPUT:
            src_base_addr   = (uint64_t(sdp_rdma_bs_base_addr_high_) << 32) | uint64_t(sdp_rdma_bs_base_addr_low_);
            line_stride         = sdp_rdma_bs_line_stride_;
            surf_stride         = sdp_rdma_bs_surface_stride_;
            enabled             = !sdp_rdma_brdma_disable_;
            component_per_element = sdp_rdma_brdma_data_use_ == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_USE_BOTH?2:1;
            bytes_per_component   = sdp_rdma_brdma_data_size_ == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_SIZE_TWO_BYTE ? 2:1;
            data_mode           = sdp_rdma_brdma_data_mode_;
            payload             = dma_b_rd_req_payload_;
            break;
        case SDP_RDMA_X2_INPUT:
            src_base_addr   = (uint64_t(sdp_rdma_bn_base_addr_high_) << 32) | uint64_t(sdp_rdma_bn_base_addr_low_);
            line_stride         = sdp_rdma_bn_line_stride_;
            surf_stride         = sdp_rdma_bn_surface_stride_;
            enabled             = !sdp_rdma_nrdma_disable_;
            component_per_element = sdp_rdma_nrdma_data_use_ == NVDLA_SDP_RDMA_D_NRDMA_CFG_0_NRDMA_DATA_USE_BOTH?2:1;
            bytes_per_component   = sdp_rdma_nrdma_data_size_ == NVDLA_SDP_RDMA_D_NRDMA_CFG_0_NRDMA_DATA_SIZE_TWO_BYTE ? 2:1;
            data_mode           = sdp_rdma_nrdma_data_mode_;
            payload             = dma_n_rd_req_payload_;
            break;
        case SDP_RDMA_Y_INPUT:
            src_base_addr   = (uint64_t(sdp_rdma_ew_base_addr_high_) << 32) | uint64_t(sdp_rdma_ew_base_addr_low_);
            line_stride         = sdp_rdma_ew_line_stride_;
            surf_stride         = sdp_rdma_ew_surface_stride_;
            enabled             = !sdp_rdma_erdma_disable_;
            component_per_element = sdp_rdma_erdma_data_use_ == NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DATA_USE_BOTH?2:1;
            bytes_per_component   = sdp_rdma_erdma_data_size_ == NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DATA_SIZE_TWO_BYTE ? 2:1;
            data_mode           = sdp_rdma_erdma_data_mode_;
            payload             = dma_e_rd_req_payload_;
            break;
#pragma CTC SKIP
        default:
            cslAssert((false));
#pragma CTC ENDSKIP
    }
    bytes_per_element = component_per_element * bytes_per_component;
#pragma CTC SKIP
    cslDebug((30, "rdma:%d, enabled:%d, addr:%lx, line_stride:%d, surf_stride:%d, data_mode:%d\n",
                eRdDma, enabled, src_base_addr, line_stride, surf_stride, data_mode));
#pragma CTC ENDSKIP

    if (enabled) {
        if (is_1x1) {
            cslAssert(surf_stride == element_per_group_src * bytes_per_element);
        }

        // argument check
#pragma CTC SKIP
        if (sdp_rdma_flying_mode_ == NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_FLYING_MODE_OFF) {
#pragma CTC ENDSKIP
            if (sdp_rdma_in_precision_ != sdp_rdma_proc_precision_ ) {
                cslAssert(sdp_rdma_winograd_ == NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_WINOGRAD_OFF);
                cslAssert(batch_num == 1);
#pragma CTC SKIP
                if (sdp_rdma_proc_precision_ == NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_IN_PRECISION_INT8 &&
                        eRdDma == SDP_RDMA_INPUT) {
#pragma CTC ENDSKIP
                    is_int16_to_int8    = true;
                }
            }
            if (sdp_rdma_in_precision_ != NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_IN_PRECISION_INT8 &&
                    sdp_rdma_proc_precision_ != NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_PROC_PRECISION_INT8 ) {
                if (sdp_rdma_brdma_disable_ == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DISABLE_NO) {
                    // cslAssert(sdp_rdma_brdma_data_size_ == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_SIZE_TWO_BYTE);
                }
                if (sdp_rdma_nrdma_disable_ == NVDLA_SDP_RDMA_D_NRDMA_CFG_0_NRDMA_DISABLE_NO) {
                    cslAssert(sdp_rdma_nrdma_data_size_ == NVDLA_SDP_RDMA_D_NRDMA_CFG_0_NRDMA_DATA_SIZE_TWO_BYTE);
                }
                if (sdp_rdma_erdma_disable_ == NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DISABLE_NO) {
                    cslAssert(sdp_rdma_erdma_data_size_ == NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DATA_SIZE_TWO_BYTE);
                }
            }
        }
        // argument check end;
        if (is_int16_to_int8 == true) {
            surf_num = ((surf_num+1)/2) * 2;
            cslDebug((30, "int16->int8, adjust surf_num as:%d\n", surf_num));
            // precision conversion is not supported
            assert(0);
        }
        rdma_atom_recieved_[eRdDma] = 0;
        if (data_mode == NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DATA_MODE_PER_KERNEL) {
            payload_size     = surf_num * element_per_group_src * bytes_per_element;
            if (eRdDma == SDP_RDMA_INPUT) {
                payload_size *= batch_num;
            }
        } else {
            payload_size      = surf_num * element_per_group_src * cube_width * cube_height * bytes_per_element;
            if (eRdDma == SDP_RDMA_INPUT) {
                payload_size *= batch_num;
            }
        }
        cslAssert(payload_size%DLA_ATOM_SIZE == 0);
        rdma_atom_total_[eRdDma] = payload_size/DLA_ATOM_SIZE;
        cslDebug((30, "rdma:%d, total payload:%d\n", eRdDma, rdma_atom_total_[eRdDma]));

        dma_packers_[eRdDma].set_parameters(DLA_ATOM_SIZE, SDP_PARALLEL_PROC_NUM*bytes_per_component,
                component_per_element, bytes_per_component == 1? DATA_TYPE_ONE_BYTE : DATA_TYPE_TWO_BYTE);


        cslDebug((30, "%s: DMA:%d port enabled, WxHxC=%dx%dx%d\n", __FUNCTION__, eRdDma, cube_width, cube_height, cube_channel));
        cslDebug((30, "\t: line_stride=%d, surfac_stride:%d\n", line_stride, surf_stride));
        cslDebug((30, "\t: surf_num         =%d\n", surf_num));
        cslDebug((30, "\t: batch_num        =%d\n", batch_num));
        cslDebug((30, "\t: bytes_per_element=%d\n", bytes_per_element));

        if (data_mode == NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DATA_MODE_PER_KERNEL) {
            int batch_count;
#ifndef CMOD_WAR_WG_BATCH
            batch_count = 1;
#else
            if (eRdDma == SDP_RDMA_INPUT) {
                // For multi-batch mode, input should comes from CC, in order to validate SDP
                // standalone, we updated SDP RDMA to allow fetch input from it;
                batch_count = batch_num;
            } else {
                // For BS/BN/EW DMA, the parameter blob should be shared by all batches
                batch_count = 1;
            }
#endif

            for(int batch_iter = 0; batch_iter < batch_count; batch_iter++) {
                payload_size     = surf_num * element_per_group_src * bytes_per_element;
                payload_atom_num = payload_size / ATOM_CUBE_SIZE;

                // Send DMA Read request for entire channel wise cube
                payload_addr     = src_base_addr;
                cslDebug((50, "SdpRdmaSequence_%d SendDmaReadRequest for per channel payload_addr=0x%lx payload_atom_num=0x%x\n", eRdDma, payload_addr, payload_atom_num));
                payload->pd.dma_read_cmd.addr = payload_addr;
                payload->pd.dma_read_cmd.size = payload_atom_num - 1;
                // WaitUntilRdmaFifoFreeSizeGreaterThan(payload_atom_num);
                // cout << "WaitUntilRdmaFifoFreeSizeGreaterThan done" << endl;
                SendDmaReadRequest(eRdDma, payload, dma_delay_);
            }
        } else {
            if ( eRdDma != SDP_RDMA_INPUT && sdp_rdma_winograd_ == NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_WINOGRAD_ON ) {
                // Winograd
                cslAssert((cube_width%(WINOGRAD_HORI_ATOM_NUM*2) == 0));
                cslAssert((cube_height%WINOGRAD_VERT_ATOM_NUM == 0));
                for (surf_iter=0; surf_iter < surf_num; surf_iter++) {
                    for (line_iter=0; line_iter < cube_height; line_iter+=WINOGRAD_VERT_ATOM_NUM) {
                        for( col_iter = 0; col_iter < cube_width; col_iter +=WINOGRAD_HORI_ATOM_NUM ) {
                            for( trans_iter = 0; trans_iter < WINOGRAD_VERT_ATOM_NUM; trans_iter++ ) {
                                payload_size     = WINOGRAD_HORI_ATOM_NUM * element_per_group_src * bytes_per_element;
                                payload_atom_num = payload_size / ATOM_CUBE_SIZE;

                                // Send DMA Read request for each line
                                payload_addr     = src_base_addr + surf_iter * surf_stride +
                                    (line_iter + trans_iter) * line_stride +
                                    col_iter * bytes_per_element * element_per_group_src;
                                cslDebug((50, "SdpRdmaSequence_%d SendDmaReadRequest payload_addr=0x%lx payload_atom_num=0x%x\n", eRdDma, payload_addr, payload_atom_num));
                                payload->pd.dma_read_cmd.addr = payload_addr;
                                payload->pd.dma_read_cmd.size = payload_atom_num - 1;
                                // WaitUntilRdmaFifoFreeSizeGreaterThan(payload_atom_num);
                                // cout << "WaitUntilRdmaFifoFreeSizeGreaterThan done" << endl;
                                SendDmaReadRequest(eRdDma, payload, dma_delay_);
                            }
                        }
                    }
                }
            } else if (batch_num > 1) {
                // Batch mode
                int batch_count;
#ifndef CMOD_WAR_WG_BATCH
                batch_count = 1;
#else
                if (eRdDma == SDP_RDMA_INPUT) {
                    // For multi-batch mode, input should comes from CC, in order to validate SDP
                    // standalone, we updated SDP RDMA to allow fetch input from it;
                    batch_count = batch_num;
                } else {
                    // For BS/BN/EW DMA, the parameter blob should be shared by all batches
                    batch_count = 1;
                }
#endif
                for (surf_iter=0; surf_iter < surf_num; surf_iter++) {
                    for (line_iter=0; line_iter < cube_height; line_iter++) {
                        for(int iter = 0; iter < batch_count; iter++) {
                            payload_size     = cube_width * element_per_group_src * bytes_per_element;
                            payload_atom_num = payload_size / ATOM_CUBE_SIZE;

                            // Send DMA Read request for each line
                            payload_addr     = src_base_addr + surf_iter * surf_stride + line_iter * line_stride;
                            cslDebug((50, "SdpRdmaSequence_%d SendDmaReadRequest payload_addr=0x%lx payload_atom_num=0x%x\n", eRdDma, payload_addr, payload_atom_num));
                            payload->pd.dma_read_cmd.addr = payload_addr;
                            payload->pd.dma_read_cmd.size = payload_atom_num - 1;
                            // WaitUntilRdmaFifoFreeSizeGreaterThan(payload_atom_num);
                            // cout << "WaitUntilRdmaFifoFreeSizeGreaterThan done" << endl;
                            SendDmaReadRequest(eRdDma, payload, dma_delay_);
                        }
                    }
                }
            } else if (is_int16_to_int8 == true) {
                // Precision conversion
                FAIL(("Precision conversion is not supported in openDLA\n"));
                int max_width_step = (INTERNAL_BUF_SIZE)/(element_per_group_src*bytes_per_element);
                for (surf_iter=0; surf_iter < surf_num; surf_iter+=2) {
                    for (line_iter=0; line_iter < cube_height; line_iter++) {
                        int width_iter = 0, width_step;
                        while(width_iter < cube_width) {
                            width_step = min(cube_width-width_iter, (uint32_t)max_width_step);

                            for(int surf_internal_iter = 0; surf_internal_iter < 2; surf_internal_iter++) {
                                payload_size     = width_step * element_per_group_src * bytes_per_element;
                                payload_atom_num = payload_size / ATOM_CUBE_SIZE;

                                // Send DMA Read request for each line
                                payload_addr     = src_base_addr +
                                    (surf_iter + surf_internal_iter) * surf_stride +
                                    line_iter * line_stride +
                                    width_iter * element_per_group_src * bytes_per_element;
                                cslDebug((50, "SdpRdmaSequence_%d SendDmaReadRequest payload_addr=0x%lx payload_atom_num=0x%x\n", eRdDma, payload_addr, payload_atom_num));
                                payload->pd.dma_read_cmd.addr = payload_addr;
                                payload->pd.dma_read_cmd.size = payload_atom_num - 1;
                                // WaitUntilRdmaFifoFreeSizeGreaterThan(payload_atom_num);
                                // cout << "WaitUntilRdmaFifoFreeSizeGreaterThan done" << endl;
                                SendDmaReadRequest(eRdDma, payload, dma_delay_);
                            }
                            width_iter += width_step;
                        }
                    }
                }
            } else {
                for (surf_iter=0; surf_iter < surf_num; surf_iter++) {
                    for (line_iter=0; line_iter < cube_height; line_iter++) {
                        payload_size     = cube_width * element_per_group_src * bytes_per_element;
                        payload_atom_num = payload_size / ATOM_CUBE_SIZE;

                        // Send DMA Read request for each line
                        payload_addr     = src_base_addr + surf_iter * surf_stride + line_iter * line_stride;
                        cslDebug((50, "SdpRdmaSequence_%d SendDmaReadRequest payload_addr=0x%lx payload_atom_num=0x%x\n", eRdDma, payload_addr, payload_atom_num));
                        payload->pd.dma_read_cmd.addr = payload_addr;
                        payload->pd.dma_read_cmd.size = payload_atom_num - 1;
                        // WaitUntilRdmaFifoFreeSizeGreaterThan(payload_atom_num);
                        // cout << "WaitUntilRdmaFifoFreeSizeGreaterThan done" << endl;
                        SendDmaReadRequest(eRdDma, payload, dma_delay_);
                    }
                }
            }
        }
    } else {
        rdma_atom_total_[eRdDma] = 0;
        rdma_atom_recieved_[eRdDma] = 0;
        if (eRdDma == SDP_RDMA_INPUT) {
            sdp_rdma_done_.notify(SC_ZERO_TIME);
            cslDebug((30, "sdp_rdma_done_.notify\n"));
        } else if (eRdDma == SDP_RDMA_X1_INPUT) {
            sdp_b_rdma_done_.notify(SC_ZERO_TIME);
            cslDebug((30, "sdp_b_rdma_done.notify\n"));
        } else if (eRdDma == SDP_RDMA_X2_INPUT) {
            sdp_n_rdma_done_.notify(SC_ZERO_TIME);
            cslDebug((30, "sdp_n_rdma_done.notify\n"));
#pragma CTC SKIP
        } else if (eRdDma == SDP_RDMA_Y_INPUT) {
#pragma CTC ENDSKIP
            sdp_e_rdma_done_.notify(SC_ZERO_TIME);
            cslDebug((30, "sdp_e_rdma_done.notify\n"));
#pragma CTC SKIP
        } else {
            cslAssert(false);
        }
#pragma CTC ENDSKIP
    }
}

void NV_NVDLA_sdp::SdpBRdmaThread () {
    
    // Wait kick off event
    while (true) {
        wait(sdp_rdma_kickoff_);
        SdpRdmaCore(SDP_RDMA_X1_INPUT);
        cslDebug((30, "BRDMA done\n"));
    }
#pragma CTC SKIP
}
#pragma CTC ENDSKIP

void NV_NVDLA_sdp::SdpNRdmaThread () {
    
    // Wait kick off event
    while (true) {
        wait(sdp_rdma_kickoff_);
        SdpRdmaCore(SDP_RDMA_X2_INPUT);
        cslDebug((30, "NRDMA done\n"));
    }
#pragma CTC SKIP
}
#pragma CTC ENDSKIP

void NV_NVDLA_sdp::SdpERdmaThread () {
    
    // Wait kick off event
    while (true) {
        wait(sdp_rdma_kickoff_);
        SdpRdmaCore(SDP_RDMA_Y_INPUT);
        cslDebug((30, "ERDMA done\n"));
    }
#pragma CTC SKIP
}
#pragma CTC ENDSKIP
void NV_NVDLA_sdp::SdpRdmaThread () {
    // Wait kick off event
    while (true) {
        wait(sdp_rdma_kickoff_);
        // Send out done
        SdpRdmaCore(SDP_RDMA_INPUT);
        cslDebug((30, "MRDMA done\n"));
    }
#pragma CTC SKIP
}
#pragma CTC ENDSKIP
void NV_NVDLA_sdp::SdpConfigHls() {
    sdp_hls_wrapper_.sdp_cfg_x1_bypass          = sdp_bs_bypass_;
    sdp_hls_wrapper_.sdp_cfg_x1_mul_op          = sdp_bs_mul_operand_;
    sdp_hls_wrapper_.sdp_cfg_x1_alu_op          = sdp_bs_alu_operand_;
    sdp_hls_wrapper_.sdp_cfg_x1_alu_bypass      = sdp_bs_alu_bypass_;
    sdp_hls_wrapper_.sdp_cfg_x1_alu_algo        = sdp_bs_alu_algo_;
    sdp_hls_wrapper_.sdp_cfg_x1_alu_src         = sdp_bs_alu_src_;
    sdp_hls_wrapper_.sdp_cfg_x1_alu_shift_value = sdp_bs_alu_shift_value_;
    sdp_hls_wrapper_.sdp_cfg_x1_mul_bypass      = sdp_bs_mul_bypass_;
    sdp_hls_wrapper_.sdp_cfg_x1_mul_src         = sdp_bs_mul_src_;
    sdp_hls_wrapper_.sdp_cfg_x1_mul_prelu       = sdp_bs_mul_prelu_;
    sdp_hls_wrapper_.sdp_cfg_x1_mul_shift_value = sdp_bs_mul_shift_value_;
    sdp_hls_wrapper_.sdp_cfg_x1_relu_bypass     = sdp_bs_relu_bypass_;

    sdp_hls_wrapper_.sdp_cfg_x2_bypass          = sdp_bn_bypass_;
    sdp_hls_wrapper_.sdp_cfg_x2_mul_op          = sdp_bn_mul_operand_;
    sdp_hls_wrapper_.sdp_cfg_x2_alu_op          = sdp_bn_alu_operand_;
    sdp_hls_wrapper_.sdp_cfg_x2_alu_bypass      = sdp_bn_alu_bypass_;
    sdp_hls_wrapper_.sdp_cfg_x2_alu_algo        = sdp_bn_alu_algo_;
    sdp_hls_wrapper_.sdp_cfg_x2_alu_src         = sdp_bn_alu_src_;
    sdp_hls_wrapper_.sdp_cfg_x2_alu_shift_value = sdp_bn_alu_shift_value_;
    sdp_hls_wrapper_.sdp_cfg_x2_mul_bypass      = sdp_bn_mul_bypass_;
    sdp_hls_wrapper_.sdp_cfg_x2_mul_src         = sdp_bn_mul_src_;
    sdp_hls_wrapper_.sdp_cfg_x2_mul_prelu       = sdp_bn_mul_prelu_;
    sdp_hls_wrapper_.sdp_cfg_x2_mul_shift_value = sdp_bn_mul_shift_value_;
    sdp_hls_wrapper_.sdp_cfg_x2_relu_bypass     = sdp_bn_relu_bypass_;

    sdp_hls_wrapper_.sdp_cfg_y_bypass             = sdp_ew_bypass_;
    sdp_hls_wrapper_.sdp_cfg_y_alu_op             = sdp_ew_alu_operand_;
    sdp_hls_wrapper_.sdp_cfg_y_alu_bypass         = sdp_ew_alu_bypass_;
    sdp_hls_wrapper_.sdp_cfg_y_alu_algo           = sdp_ew_alu_algo_;
    sdp_hls_wrapper_.sdp_cfg_y_alu_src            = sdp_ew_alu_src_;
    sdp_hls_wrapper_.sdp_cfg_y_alu_cvt_bypass     = sdp_ew_alu_cvt_bypass_;
    sdp_hls_wrapper_.sdp_cfg_y_alu_cvt_offset     = sdp_ew_alu_cvt_offset_;
    sdp_hls_wrapper_.sdp_cfg_y_alu_cvt_scale      = sdp_ew_alu_cvt_scale_;
    sdp_hls_wrapper_.sdp_cfg_y_alu_cvt_truncate   = sdp_ew_alu_cvt_truncate_;
    sdp_hls_wrapper_.sdp_cfg_y_mul_op             = sdp_ew_mul_operand_;
    sdp_hls_wrapper_.sdp_cfg_y_mul_bypass         = sdp_ew_mul_bypass_;
    sdp_hls_wrapper_.sdp_cfg_y_mul_src            = sdp_ew_mul_src_;
    sdp_hls_wrapper_.sdp_cfg_y_mul_prelu          = sdp_ew_mul_prelu_;
    sdp_hls_wrapper_.sdp_cfg_y_mul_cvt_bypass     = sdp_ew_mul_cvt_bypass_;
    sdp_hls_wrapper_.sdp_cfg_y_mul_cvt_offset     = sdp_ew_mul_cvt_offset_;
    sdp_hls_wrapper_.sdp_cfg_y_mul_cvt_scale      = sdp_ew_mul_cvt_scale_;
    sdp_hls_wrapper_.sdp_cfg_y_mul_cvt_truncate   = sdp_ew_mul_cvt_truncate_;
    sdp_hls_wrapper_.sdp_cfg_y_truncate           = sdp_ew_truncate_;
    sdp_hls_wrapper_.sdp_cfg_y_lut_le_function    = sdp_lut_le_function_;
    sdp_hls_wrapper_.sdp_cfg_y_lut_le_start       = sdp_lut_le_start_;
    sdp_hls_wrapper_.sdp_cfg_y_lut_le_end         = sdp_lut_le_end_;
    sdp_hls_wrapper_.sdp_cfg_y_lut_le_index_offset= sdp_lut_le_index_offset_;
    sdp_hls_wrapper_.sdp_cfg_y_lut_le_index_select= sdp_lut_le_index_select_;
    sdp_hls_wrapper_.sdp_cfg_y_lut_lo_start       = sdp_lut_lo_start_;
    sdp_hls_wrapper_.sdp_cfg_y_lut_lo_end         = sdp_lut_lo_end_;
    sdp_hls_wrapper_.sdp_cfg_y_lut_lo_index_select= sdp_lut_lo_index_select_;
    sdp_hls_wrapper_.sdp_cfg_y_lut_bypass         = sdp_ew_lut_bypass_;
    sdp_hls_wrapper_.sdp_cfg_y_lut_out_sel_hybrid = sdp_lut_hybrid_priority_;
    sdp_hls_wrapper_.sdp_cfg_y_lut_out_sel_u_miss = sdp_lut_uflow_priority_;
    sdp_hls_wrapper_.sdp_cfg_y_lut_out_sel_o_miss = sdp_lut_oflow_priority_;
    sdp_hls_wrapper_.sdp_cfg_y_le_uflow_scale     = sdp_lut_le_slope_uflow_scale_;
    sdp_hls_wrapper_.sdp_cfg_y_le_uflow_shift     = sdp_lut_le_slope_uflow_shift_;
    sdp_hls_wrapper_.sdp_cfg_y_le_oflow_scale     = sdp_lut_le_slope_oflow_scale_;
    sdp_hls_wrapper_.sdp_cfg_y_le_oflow_shift     = sdp_lut_le_slope_oflow_shift_;
    sdp_hls_wrapper_.sdp_cfg_y_lo_uflow_scale     = sdp_lut_lo_slope_uflow_scale_;
    sdp_hls_wrapper_.sdp_cfg_y_lo_uflow_shift     = sdp_lut_lo_slope_uflow_shift_;
    sdp_hls_wrapper_.sdp_cfg_y_lo_oflow_scale     = sdp_lut_lo_slope_oflow_scale_;
    sdp_hls_wrapper_.sdp_cfg_y_lo_oflow_shift     = sdp_lut_lo_slope_oflow_shift_;
    sdp_hls_wrapper_.sdp_cfg_nan_flush            = sdp_nan_to_zero_;

    sdp_hls_wrapper_.sdp_cfg_out_precision   = sdp_out_precision_;
    sdp_hls_wrapper_.sdp_cfg_nan_to_zero     = sdp_nan_to_zero_ && sdp_proc_precision_ == NVDLA_SDP_D_DATA_FORMAT_PROC_PRECISION_FP16;
    sdp_hls_wrapper_.sdp_cfg_perf_out_nan_cnt_en = sdp_perf_nan_inf_count_en_ && sdp_out_precision_ == NVDLA_SDP_D_DATA_FORMAT_OUT_PRECISION_FP16;
    sdp_hls_wrapper_.sdp_cfg_perf_nan_inf_cnt_en = sdp_rdma_perf_nan_inf_count_en_ && sdp_rdma_in_precision_ == NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_IN_PRECISION_FP16;
    sdp_hls_wrapper_.sdp_cfg_proc_precision  = sdp_proc_precision_;
    sdp_hls_wrapper_.sdp_cfg_cvt_offset      = sdp_cvt_offset_;
    sdp_hls_wrapper_.sdp_cfg_cvt_scale       = sdp_cvt_scale_;
    sdp_hls_wrapper_.sdp_cfg_cvt_shift       = sdp_cvt_shift_;
    sdp_hls_wrapper_.sdp_cfg_mode_eql        = sdp_ew_alu_algo_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_ALGO_EQL && sdp_ew_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_NO && sdp_ew_alu_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_BYPASS_NO;
}

void NV_NVDLA_sdp::SdpLoadPerChannelData(uint32_t proc_num) {
    uint32_t i;
    if (sdp_bs_bypass_ != NVDLA_SDP_D_DP_BS_CFG_0_BS_BYPASS_YES &&
            sdp_bs_alu_bypass_ != NVDLA_SDP_D_DP_BS_CFG_0_BS_ALU_BYPASS_YES &&
            sdp_bs_alu_src_ == NVDLA_SDP_D_DP_BS_ALU_CFG_BS_ALU_SRC_MEM &&
            sdp_cfg_.sdp_rdma_brdma_data_mode_ == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_MODE_PER_KERNEL ) {
        for( i = 0; i < proc_num; i++) {
            cslDebug((50, "Wait for rdma_b_alu_fifo for per-channel data\n"));
            int16_t *src_ptr = reinterpret_cast<int16_t*>(rdma_b_alu_fifo_->read());
            cslDebug((50, "After Wait for rdma_b_alu_fifo for per-channel data\n"));
            memcpy(hls_x1_alu_op_[0][i], src_ptr, SDP_PARALLEL_PROC_NUM*sizeof(int16_t));

            delete [] src_ptr;
        }
    }
    if (sdp_bs_bypass_ != NVDLA_SDP_D_DP_BS_CFG_0_BS_BYPASS_YES &&
            sdp_bs_mul_bypass_ != NVDLA_SDP_D_DP_BS_CFG_0_BS_MUL_BYPASS_YES &&
            sdp_bs_mul_src_ == NVDLA_SDP_D_DP_BS_MUL_CFG_BS_MUL_SRC_MEM &&
            sdp_cfg_.sdp_rdma_brdma_data_mode_ == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_MODE_PER_KERNEL ) {
        for( i = 0; i < proc_num; i ++) {
            cslDebug((50, "Wait for rdma_b_mul_fifo for per-channel data\n"));
            int16_t *src_ptr = reinterpret_cast<int16_t*>(rdma_b_mul_fifo_->read());
            cslDebug((50, "After Wait for rdma_b_mul_fifo for per-channel data\n"));
            memcpy(hls_x1_mul_op_[0][i], src_ptr, SDP_PARALLEL_PROC_NUM*sizeof(int16_t));

            delete [] src_ptr;
        }
    }
    if (sdp_bn_bypass_ != NVDLA_SDP_D_DP_BN_CFG_0_BN_BYPASS_YES &&
            sdp_bn_alu_bypass_ != NVDLA_SDP_D_DP_BN_CFG_0_BN_ALU_BYPASS_YES &&
            sdp_bn_alu_src_ == NVDLA_SDP_D_DP_BN_ALU_CFG_BN_ALU_SRC_MEM &&
            sdp_cfg_.sdp_rdma_nrdma_data_mode_ == NVDLA_SDP_RDMA_D_NRDMA_CFG_0_NRDMA_DATA_MODE_PER_KERNEL ) {
        for( i = 0; i < proc_num; i++) {
            cslDebug((50, "Wait for rdma_n_alu_fifo for per-channel data\n"));
            int16_t *src_ptr = reinterpret_cast<int16_t*>(rdma_n_alu_fifo_->read());
            cslDebug((50, "after Wait for rdma_n_alu_fifo for per-channel data\n"));
            memcpy(hls_x2_alu_op_[0][i], src_ptr, SDP_PARALLEL_PROC_NUM*sizeof(int16_t));

            delete [] src_ptr;
        }
    }
    if (sdp_bn_bypass_ != NVDLA_SDP_D_DP_BN_CFG_0_BN_BYPASS_YES &&
            sdp_bn_mul_bypass_ != NVDLA_SDP_D_DP_BN_CFG_0_BN_MUL_BYPASS_YES &&
            sdp_bn_mul_src_ == NVDLA_SDP_D_DP_BN_MUL_CFG_BN_MUL_SRC_MEM &&
            sdp_cfg_.sdp_rdma_nrdma_data_mode_ == NVDLA_SDP_RDMA_D_NRDMA_CFG_0_NRDMA_DATA_MODE_PER_KERNEL ) {
        for( i = 0; i < proc_num; i++) {
            cslDebug((50, "Wait for rdma_n_mul_fifo for per-channel data\n"));
            int16_t *src_ptr = reinterpret_cast<int16_t*>(rdma_n_mul_fifo_->read());
            cslDebug((50, "After Wait for rdma_n_mul_fifo for per-channel data\n"));
            memcpy(hls_x2_mul_op_[0][i], src_ptr, SDP_PARALLEL_PROC_NUM*sizeof(int16_t));

            delete [] src_ptr;
        }
    }
    if (sdp_ew_bypass_ != NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_YES &&
            sdp_ew_alu_bypass_ != NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_BYPASS_YES &&
            sdp_ew_alu_src_ == NVDLA_SDP_D_DP_EW_ALU_CFG_EW_ALU_SRC_MEM &&
            sdp_cfg_.sdp_rdma_erdma_data_mode_ == NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DATA_MODE_PER_KERNEL ) {
        for( i = 0; i < proc_num; i++) {
            cslDebug((50, "Wait for rdma_e_alu_fifo for per-channel data\n"));
            int16_t *src_ptr = reinterpret_cast<int16_t*>(rdma_e_alu_fifo_->read());
            cslDebug((50, "After Wait for rdma_e_alu_fifo for per-channel data\n"));
            memcpy(hls_y_alu_op_[0][i], src_ptr, SDP_PARALLEL_PROC_NUM*sizeof(int16_t));

            delete [] src_ptr;
        }
    }
    if (sdp_ew_bypass_ != NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_YES &&
            sdp_ew_mul_bypass_ != NVDLA_SDP_D_DP_EW_CFG_0_EW_MUL_BYPASS_YES &&
            sdp_ew_mul_src_ == NVDLA_SDP_D_DP_EW_MUL_CFG_EW_MUL_SRC_MEM &&
            sdp_cfg_.sdp_rdma_erdma_data_mode_ == NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DATA_MODE_PER_KERNEL ) {
        for( i = 0; i < proc_num; i++) {
            cslDebug((50, "Wait for rdma_e_mul_fifo for per-channel data\n"));
            int16_t *src_ptr = reinterpret_cast<int16_t*>(rdma_e_mul_fifo_->read());
            cslDebug((50, "Aftger Wait for rdma_e_mul_fifo for per-channel data\n"));
            memcpy(hls_y_mul_op_[0][i], src_ptr, SDP_PARALLEL_PROC_NUM*sizeof(int16_t));

            delete [] src_ptr;
        }
    }

}

void NV_NVDLA_sdp::SdpLoadPerElementData(uint32_t round, uint32_t proc) {
    // BS
    if (sdp_bs_bypass_ != NVDLA_SDP_D_DP_BS_CFG_0_BS_BYPASS_YES) {
        // alu_op data
        if (sdp_bs_alu_bypass_ != NVDLA_SDP_D_DP_BS_CFG_0_BS_ALU_BYPASS_YES) {
            if (sdp_bs_alu_src_ == NVDLA_SDP_D_DP_BS_ALU_CFG_0_BS_ALU_SRC_MEM &&
                sdp_cfg_.sdp_rdma_brdma_data_mode_ != NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_MODE_PER_KERNEL) {
                cslDebug((50, "Wait for rdma_b_alu_fifo for per-element data\n"));
                int16_t *ptr = rdma_b_alu_fifo_->read();
                cslDebug((50, "After Wait for rdma_b_alu_fifo for per-element data\n"));
                memcpy(hls_x1_alu_op_[round][proc], ptr, sizeof(hls_x1_alu_op_[0][0]));

                delete [] ptr;
            }
        }
    }
    if (sdp_bs_bypass_ != NVDLA_SDP_D_DP_BS_CFG_0_BS_BYPASS_YES) {
        // mul_op data
        if (sdp_bs_mul_bypass_ != NVDLA_SDP_D_DP_BS_CFG_0_BS_MUL_BYPASS_YES) {
            if (sdp_bs_mul_src_ == NVDLA_SDP_D_DP_BS_MUL_CFG_0_BS_MUL_SRC_MEM &&
                sdp_cfg_.sdp_rdma_brdma_data_mode_ != NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_MODE_PER_KERNEL) {
                cslDebug((50, "Wait for rdma_b_mul_fifo for per-element data\n"));
                int16_t *ptr = rdma_b_mul_fifo_->read();
                cslDebug((50, "After Wait for rdma_b_mul_fifo for per-element data\n"));
                memcpy(hls_x1_mul_op_[round][proc], ptr, sizeof(hls_x1_mul_op_[0][0]));

                delete [] ptr;
            }
        }
    }
    // BN
    if (sdp_bn_bypass_ != NVDLA_SDP_D_DP_BN_CFG_0_BN_BYPASS_YES) {
        // alu_op data
        if (sdp_bn_alu_bypass_ != NVDLA_SDP_D_DP_BN_CFG_0_BN_ALU_BYPASS_YES) {
            if (sdp_bn_alu_src_ == NVDLA_SDP_D_DP_BN_ALU_CFG_0_BN_ALU_SRC_MEM &&
                sdp_cfg_.sdp_rdma_nrdma_data_mode_ != NVDLA_SDP_RDMA_D_NRDMA_CFG_0_NRDMA_DATA_MODE_PER_KERNEL) {
                cslDebug((50, "Wait for rdma_n_alu_fifo for per-element data\n"));
                int16_t *ptr = rdma_n_alu_fifo_->read();
                cslDebug((50, "After Wait for rdma_n_alu_fifo for per-element data\n"));
                memcpy(hls_x2_alu_op_[round][proc], ptr, sizeof(hls_x2_alu_op_[0][0]));

                delete [] ptr;
            }
        }
    }
    if (sdp_bn_bypass_ != NVDLA_SDP_D_DP_BN_CFG_0_BN_BYPASS_YES) {
        // mul_op data
        if (sdp_bn_mul_bypass_ != NVDLA_SDP_D_DP_BN_CFG_0_BN_MUL_BYPASS_YES) {
            if (sdp_bn_mul_src_ == NVDLA_SDP_D_DP_BN_MUL_CFG_0_BN_MUL_SRC_MEM &&
                sdp_cfg_.sdp_rdma_nrdma_data_mode_ != NVDLA_SDP_RDMA_D_NRDMA_CFG_0_NRDMA_DATA_MODE_PER_KERNEL) {
                cslDebug((50, "Wait for rdma_n_mul_fifo for per-element data\n"));
                int16_t *ptr = rdma_n_mul_fifo_->read();
                cslDebug((50, "After Wait for rdma_n_mul_fifo for per-element data\n"));
                memcpy(hls_x2_mul_op_[round][proc], ptr, sizeof(hls_x2_mul_op_[0][0]));
                delete [] ptr;
            }
        }
    }
    // EW
    if (sdp_ew_bypass_ != NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_YES) {
        // alu_op data
        if (sdp_ew_alu_bypass_ != NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_BYPASS_YES) {
            if (sdp_ew_alu_src_ == NVDLA_SDP_D_DP_EW_ALU_CFG_0_EW_ALU_SRC_MEM &&
                sdp_cfg_.sdp_rdma_erdma_data_mode_ != NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DATA_MODE_PER_KERNEL) {
                cslDebug((50, "Wait for rdma_e_alu_fifo for per-element data\n"));
                int16_t *ptr = reinterpret_cast<int16_t*>(rdma_e_alu_fifo_->read());
                cslDebug((50, "After Wait for rdma_e_alu_fifo for per-element data\n"));
                memcpy(hls_y_alu_op_[round][proc], ptr, sizeof(hls_y_alu_op_[0][0]));
                delete [] ptr;
            }
        }
    }
    if (sdp_ew_bypass_ != NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_YES) {
        // mul_op data
        if (sdp_ew_mul_bypass_ != NVDLA_SDP_D_DP_EW_CFG_0_EW_MUL_BYPASS_YES) {
            if (sdp_ew_mul_src_ == NVDLA_SDP_D_DP_EW_MUL_CFG_0_EW_MUL_SRC_MEM &&
                sdp_cfg_.sdp_rdma_erdma_data_mode_ != NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DATA_MODE_PER_KERNEL) {
                cslDebug((50, "Wait for rdma_e_mul_fifo for per-element data\n"));
                int16_t *ptr = rdma_e_mul_fifo_->read();
                cslDebug((50, "After Wait for rdma_e_mul_fifo for per-element data\n"));
                memcpy(hls_y_mul_op_[round][proc], ptr, sizeof(hls_y_mul_op_[0][0]));
                delete [] ptr;
            }
        }
    }

}
void NV_NVDLA_sdp::SdpDataOperationDC() {
    // Config variables, they have corresponding value in registers
    uint32_t    width, height, channel, surf_num, proc_num_per_atom;
    uint32_t    surf_iter, height_iter, width_iter, proc_iter;
    uint32_t    element_per_atom;
    uint32_t    *cacc2sdp_data_ptr;
    // # Evaluated variable

    int16_t     *rdma_data_ptr;
 
    switch (sdp_proc_precision_) {
        case NVDLA_SDP_D_DATA_FORMAT_0_PROC_PRECISION_INT8:
            element_per_atom = ELEMENT_PER_GROUP_INT8;
            break;
         default:
            element_per_atom = ELEMENT_PER_GROUP_INT16;
            break;
    }
    proc_num_per_atom = element_per_atom/SDP_PARALLEL_PROC_NUM;


    width      = sdp_width_+1;
    height     = sdp_height_+1;
    channel    = sdp_channel_+1;

    surf_num        = (channel + element_per_atom - 1)/element_per_atom;
    cslDebug((30, "NV_NVDLA_sdp::SdpDataOperationDC started\n"));
    cslDebug((30, "WxHxC=%dx%dx%d, surf_num=%d\n", width, height, channel, surf_num));

    for( surf_iter = 0; surf_iter < surf_num; surf_iter++ ) {
        // load the alu/mul data for per channel mode
        SdpLoadPerChannelData(proc_num_per_atom);
        for( height_iter = 0; height_iter < height; height_iter++  ) {
            for( width_iter = 0; width_iter < width; width_iter++ ) {
                for( proc_iter = 0; proc_iter < proc_num_per_atom; proc_iter++ ) {
                    if (NVDLA_SDP_D_FEATURE_MODE_CFG_0_FLYING_MODE_OFF == sdp_flying_mode_) {
                        // input data
                        cslDebug((30, "%s: before wait rdma_fifo_, valid:%d\n", __FUNCTION__, rdma_fifo_->num_available()));
                        rdma_data_ptr = reinterpret_cast<int16_t*>(rdma_fifo_->read());
                        cslDebug((30, "%s: after wait rdma_fifo_, valid:%d\n", __FUNCTION__, rdma_fifo_->num_available()));
                        if (sdp_proc_precision_ == NVDLA_SDP_D_DATA_FORMAT_0_PROC_PRECISION_FP16 ) {
                            cslDebug((30, "%s: SDP_DP, input data before FP16->32\n", __FUNCTION__));
                            for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                cslDebug((30, "%08x, ", rdma_data_ptr[i]));
                            }
                            cslDebug((30, "\n" ));
                            if (sdp_hls_wrapper_.sdp_cfg_perf_nan_inf_cnt_en) {
                                for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                    if (((rdma_data_ptr[i]&0x3FF) == 0) && (((rdma_data_ptr[i]>>10)&0x1F) == 0x1F)) {
                                        sdp_hls_wrapper_.i_inf_cnt++;
                                    }
                                }
                                for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                    if (((rdma_data_ptr[i]&0x3FF) != 0) && (((rdma_data_ptr[i]>>10)&0x1F) == 0x1F)) {
                                        sdp_hls_wrapper_.i_nan_cnt++;
                                    }
                                }
                            }
                            
                            for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                hls_data_in_[i] = Fp16ToFp32((ACINTT(16))rdma_data_ptr[i]);
                            }
                            
                            cslDebug((30, "%s: SDP_DP, input data after FP16->32\n", __FUNCTION__));
                            for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                cslDebug((30, "%08x, ", hls_data_in_[i]));
                            }
                            cslDebug((30, "\n" ));

                        } else {
                            for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                hls_data_in_[i] = static_cast<int32_t>(rdma_data_ptr[i]);
                            }
                        }
                        delete [] rdma_data_ptr;
                    } else {
                        // On-flyingg model, receive data from CACC
                        cslDebug((50, "NV_NVDLA_sdp::SdpDataOperationThread, before read cc2pp_fifo_\n"));
                        cacc2sdp_data_ptr = (uint32_t*)(cc2pp_fifo_->read()); // Read an atom (32B)
                        cslDebug((50, "NV_NVDLA_sdp::SdpDataOperationThread, after read cc2pp_fifo_\n"));
                        memcpy(hls_data_in_, cacc2sdp_data_ptr, sizeof(uint32_t)*CC2PP_PAYLOAD_SIZE);
                        cslDebug((30, "%s: SDP_DP, input data from cacc\n", __FUNCTION__));
                        for(int i = 0; i < CC2PP_PAYLOAD_SIZE; i++) {
                            cslDebug((30, "%08x, ", hls_data_in_[i]));
                        }
                        cslDebug((30, "\n" ));

                        delete [] cacc2sdp_data_ptr;
                    }

                    cslDebug((30, "%s: before load per-element BS/BN/EW data\n", __FUNCTION__));
                    SdpLoadPerElementData(0, proc_iter);

                    cslDebug((70, "NV_NVDLA_sdp::%s, RDMA->DP\n", __FUNCTION__));
                    for(int i=0;i<SDP_PARALLEL_PROC_NUM;i++) {
                        cslDebug((70, "0x%x ", (unsigned int)hls_data_in_[i]));
                    }
                    cslDebug((70, "\n" ));
                    cslDebug((70, "NV_NVDLA_sdp::%s, RDMA->DP, X1_ALU\n", __FUNCTION__));
                    for(int i=0;i<SDP_PARALLEL_PROC_NUM;i++) {
                        cslDebug((70, "0x%x ", (unsigned int)hls_x1_alu_op_[0][proc_iter][i]));
                    }
                    cslDebug((70, "\n" ));
                    cslDebug((70, "NV_NVDLA_sdp::%s, RDMA->DP, X1_MUL\n", __FUNCTION__));
                    for(int i=0;i<SDP_PARALLEL_PROC_NUM;i++) {
                        cslDebug((70, "0x%x ", (unsigned int)hls_x1_mul_op_[0][proc_iter][i]));
                    }
                    cslDebug((70, "\n" ));

                    // Call HLS code
                    sdp_hls_wrapper_.sdp(hls_data_in_,
                            hls_x1_alu_op_[0][proc_iter], hls_x1_mul_op_[0][proc_iter],
                            hls_x2_alu_op_[0][proc_iter], hls_x2_mul_op_[0][proc_iter],
                            hls_y_alu_op_ [0][proc_iter], hls_y_mul_op_ [0][proc_iter]);
                    if (sdp_ew_alu_algo_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_ALGO_EQL &&
                            sdp_ew_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_NO &&
                            sdp_ew_alu_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_BYPASS_NO) {
                        for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                            if (sdp_hls_wrapper_.sdp_data_out[i] != 0) {
                                sdp_reg_model::SdpUpdateStatusRegister((uint32_t)NVDLA_SDP_D_STATUS_0,
                                        sdp_consumer_,
                                        (uint32_t)1);
                            }
                        }
                    } else {
                        if (NVDLA_SDP_D_FEATURE_MODE_CFG_0_OUTPUT_DST_MEM == sdp_output_dst_) {
                            int16_t *temp_ptr = new int16_t[SDP_PARALLEL_PROC_NUM];
                            cslAssert((temp_ptr != NULL));
                            memcpy(temp_ptr, sdp_hls_wrapper_.sdp_data_out, SDP_PARALLEL_PROC_NUM*sizeof(int16_t));
                            // Output destination is memory
                            cslDebug((70, "NV_NVDLA_sdp::%s, DP->WDMA\n", __FUNCTION__));
                            for(int i=0;i<SDP_PARALLEL_PROC_NUM;i++) {
                                cslDebug((70, "0x%x ", (unsigned int)sdp_hls_wrapper_.sdp_data_out[i]));
                            }
                            cslDebug((70, "\n" ));
                            wdma_fifo_->write(temp_ptr);

#pragma CTC SKIP
                            cslDebug((50, " write wdma_fifo_, height[%d], width[%d], proc[%d], total_num:%d\n",
                                        height_iter, width_iter, proc_iter,
                                        height_iter*width + width_iter*proc_num_per_atom + proc_iter+1));
#pragma CTC ENDSKIP
                        } else {
                            // Output destination is PDP
                            nvdla_sdp2pdp_t* payload = new nvdla_sdp2pdp_t;
                            cslDebug((70, "%s, DP->PDP\n", __FUNCTION__));
                            for(int i=0;i<SDP_PARALLEL_PROC_NUM;i++) {
                                cslDebug((70, "0x%x ", (unsigned int)sdp_hls_wrapper_.sdp_data_out[i]));
                            }
                            cslDebug((70, "\n" ));
                            if (sdp_out_precision_ != NVDLA_SDP_D_DATA_FORMAT_0_OUT_PRECISION_INT8) {
                                memcpy((void *)payload->pd.sdp2pdp.data,
                                        sdp_hls_wrapper_.sdp_data_out, SDP_PARALLEL_PROC_NUM*sizeof(int16_t));
                            } else {
                                memset((void *)payload->pd.sdp2pdp.data, 0, 
                                        SDP_PARALLEL_PROC_NUM*sizeof(int16_t));
                                int8_t *tmp_ptr = (int8_t *)payload->pd.sdp2pdp.data;
                                for(int element_iter = 0; element_iter < SDP_PARALLEL_PROC_NUM; element_iter++) {
                                    tmp_ptr[element_iter] = (int8_t)sdp_hls_wrapper_.sdp_data_out[element_iter];
                                }
                            }
                            sdp2pdp_b_transport(payload, b_transport_delay_);
                            delete payload;
                            cslDebug((70, "%s: send payload to PDP done\n", __FUNCTION__));
                        }
                    }
                }
            }
        }
    }
}

void NV_NVDLA_sdp::SdpDataOperationBatch() {
    // Config variables, they have corresponding value in registers
    uint32_t    width, height, channel, surf_num, proc_num_per_atom, round_num;
    uint32_t    surf_iter, height_iter, width_iter, proc_iter, batch_iter, round_iter;
    uint32_t    element_per_atom;
    uint32_t    batch_num = sdp_batch_number_ + 1;
    uint32_t    *cacc2sdp_data_ptr;
    int16_t     *rdma_data_ptr;
    int         bs_idx, bn_idx, y_idx;

    switch (sdp_proc_precision_) {
        case NVDLA_SDP_D_DATA_FORMAT_0_PROC_PRECISION_INT8:
            element_per_atom = ELEMENT_PER_GROUP_INT8;
            break;
         default:
            element_per_atom = ELEMENT_PER_GROUP_INT16;
            break;
    }
    proc_num_per_atom = element_per_atom/SDP_PARALLEL_PROC_NUM;


    cslDebug((30, "NV_NVDLA_sdp::SdpDataOperationBatch started\n"));
    width      = sdp_width_+1;
    height     = sdp_height_+1;
    channel    = sdp_channel_+1;

    surf_num        = (channel + element_per_atom - 1)/element_per_atom;

    for( surf_iter = 0; surf_iter < surf_num; surf_iter++ ) {
        // load the alu/mul data for per channel mode
        SdpLoadPerChannelData(proc_num_per_atom);
        for( height_iter = 0; height_iter < height; height_iter++  ) {
            round_num = 1;
            for( width_iter = 0; width_iter < width; width_iter+= round_num) {
                for( batch_iter = 0; batch_iter < batch_num; batch_iter++ ) {
                    for( round_iter = 0; round_iter < round_num; round_iter++ ) {
                        for( proc_iter = 0; proc_iter < proc_num_per_atom; proc_iter++ ) {
#ifndef CMOD_WAR_WG_BATCH
                            cslAssert(NVDLA_SDP_D_FEATURE_MODE_CFG_0_FLYING_MODE_ON == sdp_flying_mode_);
#endif
                            // On-flyingg model, receive data from CACC
                            if (NVDLA_SDP_D_FEATURE_MODE_CFG_0_FLYING_MODE_OFF == sdp_flying_mode_) {
                                // input data
                                cslDebug((50, "%s, before read data from rdma\n", __FUNCTION__));
                                rdma_data_ptr = reinterpret_cast<int16_t*>(rdma_fifo_->read());
                                cslDebug((30, "%s: SDP_DP, input data before FP16->32\n", __FUNCTION__));
                                for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                    cslDebug((30, "%08x, ", rdma_data_ptr[i]));
                                }
                                cslDebug((30, "\n" ));

                                if (sdp_proc_precision_ == NVDLA_SDP_D_DATA_FORMAT_0_PROC_PRECISION_FP16 ) {
#pragma CTC SKIP
                                    if (sdp_hls_wrapper_.sdp_cfg_perf_nan_inf_cnt_en) {
                                        for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                            if (((rdma_data_ptr[i]&0x3FF) == 0) && (((rdma_data_ptr[i]>>10)&0x1F) == 0x1F)) {
                                                sdp_hls_wrapper_.i_inf_cnt++;
                                            }
                                        }
                                        for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                            if (((rdma_data_ptr[i]&0x3FF) != 0) && (((rdma_data_ptr[i]>>10)&0x1F) == 0x1F)) {
                                                sdp_hls_wrapper_.i_nan_cnt++;
                                            }
                                        }
                                    }
#pragma CTC ENDSKIP
                                    for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                        hls_data_in_[i] = Fp16ToFp32((ACINTT(16))rdma_data_ptr[i]);
                                    }

                                    cslDebug((30, "%s: SDP_DP, input data after FP16->32\n", __FUNCTION__));
                                    for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                        cslDebug((30, "%08x, ", hls_data_in_[i]));
                                    }
                                    cslDebug((30, "\n" ));

                                } else {
                                    for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                        hls_data_in_[i] = static_cast<int32_t>(rdma_data_ptr[i]);
                                    }
                                }
                                delete [] rdma_data_ptr;
                            } else {
                                // On-flyingg model, receive data from CACC
                                cslDebug((50, "%s, before read data from cacc\n", __FUNCTION__));
                                cacc2sdp_data_ptr = (uint32_t*)(cc2pp_fifo_->read()); // Read an atom (32B)
                                memcpy(hls_data_in_, cacc2sdp_data_ptr, sizeof(uint32_t)*CC2PP_PAYLOAD_SIZE);
                                delete [] cacc2sdp_data_ptr;
                            }
                            cslDebug((50, "%s, after read data\n", __FUNCTION__));

                            if (batch_iter == 0) {
                                SdpLoadPerElementData(round_iter, proc_iter);
                            }
                            bs_idx = bn_idx = y_idx = round_iter;
                            if (sdp_cfg_.sdp_rdma_brdma_data_mode_ == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_MODE_PER_KERNEL) {
                                bs_idx = 0;
                            }
                            if (sdp_cfg_.sdp_rdma_nrdma_data_mode_ == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_MODE_PER_KERNEL) {
                                bn_idx = 0;
                            }
                            if (sdp_cfg_.sdp_rdma_erdma_data_mode_ == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_MODE_PER_KERNEL) {
                                y_idx = 0;
                            }


                            // Call HLS code
                            sdp_hls_wrapper_.sdp(hls_data_in_,
                                    hls_x1_alu_op_[bs_idx][proc_iter], hls_x1_mul_op_[bs_idx][proc_iter],
                                    hls_x2_alu_op_[bn_idx][proc_iter], hls_x2_mul_op_[bn_idx][proc_iter],
                                    hls_y_alu_op_[y_idx][proc_iter], hls_y_mul_op_[y_idx][proc_iter]);
                            int16_t *temp_ptr = new int16_t[SDP_PARALLEL_PROC_NUM];
                            cslAssert((temp_ptr != NULL));
                            memcpy(temp_ptr, sdp_hls_wrapper_.sdp_data_out, SDP_PARALLEL_PROC_NUM*sizeof(int16_t));
                            cslDebug((50, "before write wdma_fifo_\n"));
                            wdma_fifo_->write(temp_ptr);    //8B
                            cslDebug((50, "after write wdma_fifo_\n"));
                        }
                    }
                }
            }
        }
    }
}


void NV_NVDLA_sdp::SdpDataOperationWG() {
    // Config variables, they have corresponding value in registers
    uint32_t    width, height, channel, surf_num, proc_num_per_atom;
    uint32_t    surf_iter, height_iter, width_iter, proc_iter;
    uint32_t    wg_width_iter, wg_height_iter;
    uint32_t    element_per_atom;
    uint32_t    *cacc2sdp_data_ptr;
    int16_t     *rdma_data_ptr;
    // # Evaluated variable

    switch (sdp_proc_precision_) {
        case NVDLA_SDP_D_DATA_FORMAT_0_PROC_PRECISION_INT8:
            element_per_atom = ELEMENT_PER_ATOM_INT8;
            break;
         default:
            element_per_atom = ELEMENT_PER_ATOM_INT16;
            break;
    }
    proc_num_per_atom = element_per_atom/SDP_PARALLEL_PROC_NUM;


    cslDebug((30, "NV_NVDLA_sdp::SdpDataOperationWG started\n"));
    width      = sdp_width_+1;
    height     = sdp_height_+1;
    channel    = sdp_channel_+1;

    surf_num        = (channel + element_per_atom - 1)/element_per_atom;

    for( surf_iter = 0; surf_iter < surf_num; surf_iter++ ) {
        // load the alu/mul data for per channel mode
        SdpLoadPerChannelData(proc_num_per_atom);
        for( height_iter = 0; height_iter < height; height_iter+=WINOGRAD_VERT_ATOM_NUM  ) {
            for( width_iter = 0; width_iter < width; width_iter+=WINOGRAD_HORI_ATOM_NUM ) {
                for(wg_height_iter = 0; wg_height_iter < WINOGRAD_VERT_ATOM_NUM; wg_height_iter++ ) {
                    for(wg_width_iter = 0; wg_width_iter < WINOGRAD_HORI_ATOM_NUM; wg_width_iter++)  {
                        for( proc_iter = 0; proc_iter < proc_num_per_atom; proc_iter++ ) {
#ifndef CMOD_WAR_WG_BATCH
                            cslAssert(NVDLA_SDP_D_FEATURE_MODE_CFG_0_FLYING_MODE_ON == sdp_flying_mode_);
#endif
                            // On-flyingg model, receive data from CACC
                            cslDebug((50, "%s, before read data\n", __FUNCTION__));
                            if (NVDLA_SDP_D_FEATURE_MODE_CFG_0_FLYING_MODE_OFF == sdp_flying_mode_) {
                                // input data
                                rdma_data_ptr = reinterpret_cast<int16_t*>(rdma_fifo_->read());
                                cslDebug((30, "%s: after wait rdma_fifo_, valid:%d\n", __FUNCTION__, rdma_fifo_->num_available()));
                                if (sdp_proc_precision_ == NVDLA_SDP_D_DATA_FORMAT_0_PROC_PRECISION_FP16 ) {
                                    cslDebug((30, "%s: SDP_DP, input data before FP16->32\n", __FUNCTION__));
                                    for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                        cslDebug((30, "%08x, ", rdma_data_ptr[i]));
                                    }
                                    cslDebug((30, "\n" ));
#pragma CTC SKIP
                                    if (sdp_hls_wrapper_.sdp_cfg_perf_nan_inf_cnt_en) {
                                        for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                            if (((rdma_data_ptr[i]&0x3FF) == 0) && (((rdma_data_ptr[i]>>10)&0x1F) == 0x1F)) {
                                                sdp_hls_wrapper_.i_inf_cnt++;
                                            }
                                        }
                                        for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                            if (((rdma_data_ptr[i]&0x3FF) != 0) && (((rdma_data_ptr[i]>>10)&0x1F) == 0x1F)) {
                                                sdp_hls_wrapper_.i_nan_cnt++;
                                            }
                                        }
                                    }
#pragma CTC ENDSKIP

                                    for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                        hls_data_in_[i] = Fp16ToFp32((ACINTT(16))rdma_data_ptr[i]);
                                    }

                                    cslDebug((30, "%s: SDP_DP, input data after FP16->32\n", __FUNCTION__));
                                    for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                        cslDebug((30, "%08x, ", hls_data_in_[i]));
                                    }
                                    cslDebug((30, "\n" ));

                                } else {
                                    for(int i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
                                        hls_data_in_[i] = static_cast<int32_t>(rdma_data_ptr[i]);
                                    }
                                }
                                delete [] rdma_data_ptr;
                            } else {
                                // On-flyingg model, receive data from CACC
                                cacc2sdp_data_ptr = (uint32_t*)(cc2pp_fifo_->read()); // Read an atom (32B)
                                memcpy(hls_data_in_, cacc2sdp_data_ptr, sizeof(uint32_t)*CC2PP_PAYLOAD_SIZE);
                                delete [] cacc2sdp_data_ptr;
                            }
                            cslDebug((50, "%s, after read data\n", __FUNCTION__));

                            SdpLoadPerElementData(0, proc_iter);

                            // Call HLS code
                            sdp_hls_wrapper_.sdp(hls_data_in_,
                                    hls_x1_alu_op_[0][proc_iter], hls_x1_mul_op_[0][proc_iter],
                                    hls_x2_alu_op_[0][proc_iter], hls_x2_mul_op_[0][proc_iter],
                                    hls_y_alu_op_ [0][proc_iter], hls_y_mul_op_ [0][proc_iter]);
#pragma CTC SKIP
                            if (sdp_ew_alu_algo_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_ALGO_EQL &&
                                    sdp_ew_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_NO &&
                                    sdp_ew_alu_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_BYPASS_NO) {
                                cslInfo(("EQL mode is not supported in winograd\n"));
                                cslAssert(false);
#pragma CTC ENDSKIP
                            } else {
                                int16_t *temp_ptr = new int16_t[SDP_PARALLEL_PROC_NUM];
                                cslAssert((temp_ptr != NULL));
                                memcpy(temp_ptr, sdp_hls_wrapper_.sdp_data_out, SDP_PARALLEL_PROC_NUM*sizeof(int16_t));
                                wdma_fifo_->write(temp_ptr);    //8B
                                cslDebug((50, " write wdma_fifo_\n"));
                            }
                        }
                    }
                }
            }
        }
    }

}


void NV_NVDLA_sdp::SdpDataOperationThread () {
    uint32_t batch_num;
    SdpConfig *cfg;
    bool is_rdma_enabled;
    bool is_bn_has_rdma, is_bs_has_rdma, is_ew_has_rdma;
    bool is_int8_to_int16;

    // Wait kick off event
    while (true) {
        wait(sdp_kickoff_);

        is_rdma_enabled = (sdp_flying_mode_ == NVDLA_SDP_D_FEATURE_MODE_CFG_0_FLYING_MODE_OFF);
#pragma CTC SKIP
        is_bs_has_rdma = (sdp_bs_bypass_ == NVDLA_SDP_D_DP_BS_CFG_0_BS_BYPASS_NO) &&
            (((sdp_bs_alu_bypass_ == NVDLA_SDP_D_DP_BS_CFG_0_BS_ALU_BYPASS_NO) && (sdp_bs_alu_src_ == NVDLA_SDP_D_DP_BS_ALU_CFG_BS_ALU_SRC_MEM)) ||
            ((sdp_bs_mul_bypass_ == NVDLA_SDP_D_DP_BS_CFG_0_BS_MUL_BYPASS_NO) && (sdp_bs_mul_src_ == NVDLA_SDP_D_DP_BS_MUL_CFG_BS_MUL_SRC_MEM)));
        is_bn_has_rdma = (sdp_bn_bypass_ == NVDLA_SDP_D_DP_BN_CFG_0_BN_BYPASS_NO) &&
            (((sdp_bn_alu_bypass_ == NVDLA_SDP_D_DP_BN_CFG_0_BN_ALU_BYPASS_NO) && (sdp_bn_alu_src_ == NVDLA_SDP_D_DP_BN_ALU_CFG_BN_ALU_SRC_MEM)) ||
            ((sdp_bn_mul_bypass_ == NVDLA_SDP_D_DP_BN_CFG_0_BN_MUL_BYPASS_NO) && (sdp_bn_mul_src_ == NVDLA_SDP_D_DP_BN_MUL_CFG_BN_MUL_SRC_MEM)));
        is_ew_has_rdma = (sdp_ew_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_NO) &&
            (((sdp_ew_alu_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_BYPASS_NO) && (sdp_ew_alu_src_ == NVDLA_SDP_D_DP_EW_ALU_CFG_EW_ALU_SRC_MEM)) ||
            ((sdp_ew_mul_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_MUL_BYPASS_NO) && (sdp_ew_mul_src_ == NVDLA_SDP_D_DP_EW_MUL_CFG_EW_MUL_SRC_MEM)));
#pragma CTC ENDSKIP

        if (is_rdma_enabled || is_bs_has_rdma || is_bn_has_rdma || is_ew_has_rdma) {
            cfg = sdp_config_fifo_->read();
            sdp_cfg_ = *cfg;
            delete cfg;
        }

        if (sdp_ew_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_NO &&
                sdp_ew_alu_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_BYPASS_NO &&
                sdp_ew_alu_algo_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_ALGO_EQL) {
            cslAssert(sdp_cvt_offset_ == 0 && sdp_cvt_scale_ == 1 && sdp_cvt_shift_ == 0);
            sdp_reg_model::SdpUpdateStatusRegister((uint32_t)NVDLA_SDP_D_STATUS_0,
                sdp_consumer_,
                (uint32_t)0);
        }

        cslDebug((30, "NV_NVDLA_sdp::SdpDataOperationThread, layer operation begin\n"));
        // Copy from register value to local config variables, similar with RTL connection, begin
        // # Cube setting
        batch_num       = sdp_batch_number_+1;
        SdpConfigHls();
        sdp_hls_wrapper_.reset_stats_regs();

        is_int8_to_int16 = sdp_proc_precision_ == NVDLA_SDP_D_DATA_FORMAT_0_PROC_PRECISION_INT8 &&
            sdp_out_precision_ != NVDLA_SDP_D_DATA_FORMAT_0_OUT_PRECISION_INT8;
        if (is_int8_to_int16) {
            cslAssert(batch_num == 1);
            cslAssert(sdp_winograd_ == NVDLA_SDP_D_FEATURE_MODE_CFG_0_WINOGRAD_OFF);
        }

        if (sdp_winograd_ == NVDLA_SDP_D_FEATURE_MODE_CFG_0_WINOGRAD_ON) {
            SdpDataOperationWG();
        } else if (batch_num > 1) {
            SdpDataOperationBatch();
        } else {
            SdpDataOperationDC();
        }
        
        if (sdp_perf_lut_en_ == NVDLA_SDP_D_PERF_ENABLE_PERF_LUT_EN_YES &&
                sdp_ew_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_NO &&
                sdp_ew_lut_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_LUT_BYPASS_NO) {
#if 0
            sdp_hls_wrapper_.lut_hybrid_hit = sdp_hls_wrapper_.total_num - 
                sdp_hls_wrapper_.lut_u_flow - sdp_hls_wrapper_.lut_o_flow -
                sdp_hls_wrapper_.lut_le_hit - sdp_hls_wrapper_.lut_lo_hit;
#endif
            sdp_reg_model::SdpUpdateStatusRegister((uint32_t)NVDLA_SDP_D_PERF_LUT_UFLOW_0,
                    sdp_consumer_,
                    (uint32_t)sdp_hls_wrapper_.lut_u_flow);
            sdp_reg_model::SdpUpdateStatusRegister((uint32_t)NVDLA_SDP_D_PERF_LUT_OFLOW_0,
                    sdp_consumer_,
                    (uint32_t)sdp_hls_wrapper_.lut_o_flow);
            sdp_reg_model::SdpUpdateStatusRegister((uint32_t)NVDLA_SDP_D_PERF_LUT_HYBRID_0,
                    sdp_consumer_,
                    (uint32_t)sdp_hls_wrapper_.lut_hybrid_hit);
            sdp_reg_model::SdpUpdateStatusRegister((uint32_t)NVDLA_SDP_D_PERF_LUT_LE_HIT_0,
                    sdp_consumer_,
                    (uint32_t)sdp_hls_wrapper_.lut_le_hit );
            sdp_reg_model::SdpUpdateStatusRegister((uint32_t)NVDLA_SDP_D_PERF_LUT_LO_HIT_0,
                    sdp_consumer_,
                    (uint32_t)sdp_hls_wrapper_.lut_lo_hit );
        }
        if (sdp_perf_sat_en_) {
            sdp_reg_model::SdpUpdateStatusRegister((uint32_t)NVDLA_SDP_D_PERF_OUT_SATURATION_0,
                    sdp_consumer_,
                    (uint32_t)sdp_hls_wrapper_.o_cvt_o_flow);
        }
        if (sdp_hls_wrapper_.sdp_cfg_perf_nan_inf_cnt_en) {
            sdp_rdma_reg_model::SdpRdmaUpdateStatusRegister((uint32_t)NVDLA_SDP_RDMA_D_STATUS_NAN_INPUT_NUM_0,
                    sdp_consumer_,
                    (uint32_t)sdp_hls_wrapper_.i_nan_cnt);
            sdp_rdma_reg_model::SdpRdmaUpdateStatusRegister((uint32_t)NVDLA_SDP_RDMA_D_STATUS_INF_INPUT_NUM_0,
                    sdp_consumer_,
                    (uint32_t)sdp_hls_wrapper_.i_inf_cnt);
        }
        if (sdp_hls_wrapper_.sdp_cfg_perf_out_nan_cnt_en) {
            sdp_reg_model::SdpUpdateStatusRegister((uint32_t)NVDLA_SDP_D_STATUS_NAN_OUTPUT_NUM_0,
                    sdp_consumer_,
                    (uint32_t)sdp_hls_wrapper_.o_nan_cnt);
        }
        cslDebug((30, "NV_NVDLA_sdp::SdpDataOperationThread, layer operation end\n"));

#pragma CTC SKIP
        if ((sdp_ew_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_NO &&
                sdp_ew_alu_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_BYPASS_NO &&
                sdp_ew_alu_algo_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_ALGO_EQL) ||
                NVDLA_SDP_D_FEATURE_MODE_CFG_0_OUTPUT_DST_MEM != sdp_output_dst_) {
#pragma CTC ENDSKIP
            cslInfo(("trigger sdp_done as there's no wdma operation\n"));
            ack_info *ack = new ack_info;
            ack->is_mc = -1;
            ack->group_id = sdp_consumer_;
            sdp_done_.notify(SC_ZERO_TIME);
            sdp_ack_fifo_->write(ack);
        }
    }
#pragma CTC SKIP
}
#pragma CTC ENDSKIP

void NV_NVDLA_sdp::WdmaSequenceDC() {
    // Config variables, they have corresponding value in registers
    uint64_t dst_base_addr;
    uint32_t cube_width, cube_height, cube_channel;
    uint32_t dst_line_stride, dst_surface_stride;
    uint32_t element_per_atom;
    // Control variables
    // # Iterators
    uint32_t surface_iter, line_iter;
    uint32_t surface_num;
    // #
    bool     is_dst_data_line_packed;
    uint32_t atom_num;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint32_t payload_atom_num;
    bool     is_required_ack;
    bool    is_int8_to_int16;

    // Temp variables

    // Copy from register value to local config variables, similar with RTL connection
    //
    dst_base_addr       = (((uint64_t)(sdp_dst_base_addr_high_))<< 32) + (uint64_t)(sdp_dst_base_addr_low_);
    cube_width          = sdp_width_  +1;
    cube_height         = sdp_height_ +1;
    cube_channel        = sdp_channel_+1;
    dst_line_stride     = sdp_dst_line_stride_;
    dst_surface_stride  = sdp_dst_surface_stride_;
    is_required_ack     = false;
    is_int8_to_int16 = sdp_proc_precision_ == NVDLA_SDP_D_DATA_FORMAT_0_PROC_PRECISION_INT8 &&
        sdp_out_precision_ != NVDLA_SDP_D_DATA_FORMAT_0_OUT_PRECISION_INT8;

    switch (sdp_out_precision_) {
        case DATA_FORMAT_IS_INT8: {
                element_per_atom    = ELEMENT_PER_ATOM_INT8;
                break;
            }
        case DATA_FORMAT_IS_INT16: {
                element_per_atom    = ELEMENT_PER_ATOM_INT16;
                break;
            }
        case DATA_FORMAT_IS_FP16: {
                element_per_atom    = ELEMENT_PER_ATOM_FP16;
                break;
            }
#pragma CTC SKIP
        default: break;
#pragma CTC ENDSKIP
    }

    // write data across lines only when cube size is 1x1 and surf packed
    if ( (1==cube_width) && (1==cube_height) ) {
#pragma CTC SKIP
        cslAssert(dst_surface_stride == ATOM_CUBE_SIZE);
#pragma CTC ENDSKIP
        is_dst_data_line_packed = true;
    } else {
        is_dst_data_line_packed = false;
    }

    // For block sequence looping
    if (is_int8_to_int16) {
        // openDLA doesn't support precision conversion
        assert(0);
        surface_num     = ((cube_channel + ELEMENT_PER_ATOM_INT8 - 1)/ELEMENT_PER_ATOM_INT8)*2;
    } else {
        surface_num     = (cube_channel + element_per_atom - 1)/element_per_atom;
    }
    if (true == is_dst_data_line_packed) {
        // Line packed, sent request across lines
        atom_num        = surface_num;
        payload_addr    = dst_base_addr;
        payload_size    = atom_num*ATOM_CUBE_SIZE;
        SendDmaWriteRequest(payload_addr, payload_size, atom_num, true);
    } else {
        // Line unpacked, sent request per line
        if (is_int8_to_int16 == false) {
            for (surface_iter = 0; surface_iter<surface_num; surface_iter ++) {
                for (line_iter = 0; line_iter < cube_height; line_iter++) {
                    payload_addr    = dst_base_addr + line_iter * dst_line_stride + surface_iter * dst_surface_stride;
                    payload_atom_num    = cube_width;
                    payload_size        = payload_atom_num*ATOM_CUBE_SIZE;
                    if ( (surface_iter+1 == surface_num)
                            && (line_iter+1==cube_height)) {
                        is_required_ack = true;
                        cslDebug((30, "SDP dst line_unpacked %s send the last transaction, ack_required=%d\n", __FUNCTION__, is_required_ack));
                    }
                    SendDmaWriteRequest(payload_addr, payload_size, payload_atom_num, is_required_ack);
                }
            }
        } else {
            for (surface_iter = 0; surface_iter<surface_num; surface_iter+=2) {
                for (line_iter = 0; line_iter < cube_height; line_iter++) {
                    uint32_t width_iter = 0, width_step;
                    while(width_iter < cube_width) {
                        payload_addr    = dst_base_addr + line_iter * dst_line_stride + surface_iter * dst_surface_stride + width_iter*ATOM_CUBE_SIZE;
                        payload_size = DMA_TRANSACTION_SIZE - payload_addr%DMA_TRANSACTION_SIZE;
                        width_step = min(cube_width-width_iter, payload_size/ATOM_CUBE_SIZE);
                        payload_size = width_step*ATOM_CUBE_SIZE;
                        if ( (surface_iter+2 >= surface_num)
                                && (line_iter+1==cube_height)
                                && (width_iter + width_step == cube_width) ) {
                            is_required_ack = true;
                            cslDebug((30, "SDP dst line_unpacked %s send the last transaction, width_iter=%d ack_required=%d\n", __FUNCTION__, width_iter, is_required_ack));
                        }
                        SendDmaWriteRequest(payload_addr, payload_size, width_step, is_required_ack);

                        width_iter += width_step;
                    }
                }
            }
        }
    }
}

void NV_NVDLA_sdp::WdmaSequenceWG() {
    // Config variables, they have corresponding value in registers
    uint64_t dst_base_addr;
    int32_t cube_width, cube_height, cube_channel;
    uint32_t dst_line_stride, dst_surface_stride;
    uint32_t element_per_atom;
    // Control variables
    // # Iterators
    int32_t surface_iter, line_iter, col_iter, wg_line_iter;
    int32_t surface_num;
    // #
    uint64_t payload_addr;
    uint32_t payload_size;
    uint32_t payload_atom_num;
    bool     is_required_ack=false;
    // Temp variables

    // Copy from register value to local config variables, similar with RTL connection
    //
    dst_base_addr       = (uint64_t(sdp_dst_base_addr_high_) << 32) + uint64_t(sdp_dst_base_addr_low_);
    cube_width          = sdp_width_  +1;
    cube_height         = sdp_height_ +1;
    cube_channel        = sdp_channel_+1;
    dst_line_stride     = sdp_dst_line_stride_;
    dst_surface_stride  = sdp_dst_surface_stride_;

    switch (sdp_out_precision_) {
        case DATA_FORMAT_IS_INT8: {
                element_per_atom    = ELEMENT_PER_ATOM_INT8;
                break;
                                  }
        case DATA_FORMAT_IS_INT16: {
                element_per_atom    = ELEMENT_PER_ATOM_INT16;
                break;
                                  }
        case DATA_FORMAT_IS_FP16: {
                element_per_atom    = ELEMENT_PER_ATOM_FP16;
                break;
                                  }
#pragma CTC SKIP
        default: break;
#pragma CTC ENDSKIP
    }

    if (dst_base_addr%64 != 0) {
        cslDebug((30, "dst_base_addr:0x%lx is not 64bytes aligned\n", dst_base_addr));
    }

    // For block sequence looping
    surface_num     = (cube_channel + element_per_atom - 1)/element_per_atom;
    for (surface_iter = 0; surface_iter<surface_num; surface_iter ++) {
        for(line_iter = 0; line_iter < cube_height; line_iter += WINOGRAD_VERT_ATOM_NUM ) {
            for(col_iter = 0; col_iter < cube_width; col_iter += WINOGRAD_HORI_ATOM_NUM ) {
                for(wg_line_iter = 0; wg_line_iter < WINOGRAD_VERT_ATOM_NUM; wg_line_iter++) {
                    payload_atom_num        = min(cube_width-col_iter, WINOGRAD_HORI_ATOM_NUM);
                    payload_addr = dst_base_addr + surface_iter*dst_surface_stride +
                        (line_iter + wg_line_iter)*dst_line_stride + (col_iter)*ATOM_CUBE_SIZE;
                    payload_size    = DMA_TRANSACTION_SIZE - payload_addr%DMA_TRANSACTION_SIZE;
                    if ((line_iter+wg_line_iter+1 == cube_height) && (surface_iter+1 == surface_num) &&
                      (col_iter+payload_atom_num == cube_width) ) {
                        is_required_ack = true;
                    }
#pragma CTC SKIP
                    cslDebug((30, "%s: surf_iter:%d, line_iter:%d, col_iter:%d, wg_line_iter:%d, payload_size:%d, req_ack:%d\n",
                                __FUNCTION__, surface_iter, line_iter, col_iter, wg_line_iter, payload_size, is_required_ack));
#pragma CTC ENDSKIP
                    SendDmaWriteRequest(payload_addr, payload_size, payload_atom_num, is_required_ack);       
                }
            }
        }
    }
}
void NV_NVDLA_sdp::WdmaSequenceBatch() {
    // Config variables, they have corresponding value in registers
    uint64_t dst_base_addr;
    uint32_t cube_width, cube_height, cube_channel;
    uint32_t dst_line_stride, dst_surface_stride;
    uint32_t element_per_atom;
    // Control variables
    // # Iterators
    uint32_t surface_iter, line_iter, batch_iter;
    uint32_t surface_num;
    // #
    uint32_t atom_num, atom_sent_num;
    uint64_t payload_addr;
    uint32_t payload_size;
    bool     is_required_ack=false;
    uint32_t batch_num = sdp_batch_number_ + 1;
    uint32_t dst_batch_stride;
    uint32_t round_num;
    // Temp variables

    // Copy from register value to local config variables, similar with RTL connection
    //
    dst_base_addr       = (((uint64_t)sdp_dst_base_addr_high_) << 32) + (uint64_t)sdp_dst_base_addr_low_;
    cube_width          = sdp_width_  +1;
    cube_height         = sdp_height_ +1;
    cube_channel        = sdp_channel_+1;
    dst_line_stride     = sdp_dst_line_stride_;
    dst_surface_stride  = sdp_dst_surface_stride_;
    dst_batch_stride    = sdp_dst_batch_stride_ * DLA_ATOM_SIZE;

    if (sdp_ew_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_NO &&
            sdp_ew_alu_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_BYPASS_NO ) {
        cslAssert(sdp_ew_alu_algo_ != NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_ALGO_EQL);
    }

    switch (sdp_out_precision_) {
        case DATA_FORMAT_IS_INT8: {
                element_per_atom    = ELEMENT_PER_ATOM_INT8;
                break;
                                  }
        case DATA_FORMAT_IS_INT16: {
                element_per_atom    = ELEMENT_PER_ATOM_INT16;
                break;
                                  }
        case DATA_FORMAT_IS_FP16: {
                element_per_atom    = ELEMENT_PER_ATOM_FP16;
                break;
                                  }
#pragma CTC SKIP
        default: break;
#pragma CTC ENDSKIP
    }

    // Evaluated

    // For block sequence looping
    surface_num     = (cube_channel + element_per_atom - 1)/element_per_atom;
    for (surface_iter = 0; surface_iter<surface_num; surface_iter ++) {
        for(line_iter = 0; line_iter < cube_height; line_iter ++ ) {
            atom_sent_num = 0;
            atom_num = cube_width;
            while(atom_sent_num < atom_num)  {
#if 0
#pragma CTC SKIP
                // dst_base_addr should be always 64B aligend for multi-batch tests
                round_num = (dst_base_addr + surface_iter*dst_surface_stride +
                        line_iter*dst_line_stride + atom_sent_num*ATOM_CUBE_SIZE)%DMA_TRANSACTION_SIZE == 0 ? 2:1;
#pragma CTC ENDSKIP
                round_num = min(round_num, atom_num-atom_sent_num);
#else
                // CACC doesn't support packing for batch mode in openDLA
                round_num = 1;
#endif
                for(batch_iter = 0; batch_iter < batch_num; batch_iter++) {
                    payload_addr = dst_base_addr + surface_iter*dst_surface_stride +
                        line_iter*dst_line_stride + batch_iter*dst_batch_stride + atom_sent_num*ATOM_CUBE_SIZE;
                    payload_size = round_num*ATOM_CUBE_SIZE;
                    if (surface_iter == (surface_num-1) && batch_iter == (batch_num-1) &&
                            line_iter == (cube_height-1) && (atom_sent_num + round_num) == (atom_num)) {
                        is_required_ack = true;
                    }
#pragma CTC SKIP
                    cslDebug((30, "%s: send %d atoms on surf_iter:%d, line_iter:%d, atom_iter:%d, batch_iter:%d. AckReqired:%d\n", __FUNCTION__,
                                round_num, surface_iter, line_iter, atom_sent_num, batch_iter, is_required_ack));
#pragma CTC ENDSKIP
                    SendDmaWriteRequest(payload_addr, payload_size, round_num, is_required_ack);       
                }

                atom_sent_num += round_num;
            }
        }
    }
}

void NV_NVDLA_sdp::SdpWdmaThread () {
    // Varialbes
    while (true) {
        wait(sdp_kickoff_);
        dma_packers_[SDP_WDMA].set_parameters(SDP_PARALLEL_PROC_NUM*sizeof(int16_t),
                NVDLA_MEMORY_ATOMIC_SIZE*sizeof(int16_t), 1,
                // set data type as INT16 becuase we always pass down int16_t to wdma
                DATA_TYPE_TWO_BYTE);
        if (sdp_winograd_ == NVDLA_SDP_D_FEATURE_MODE_CFG_0_WINOGRAD_ON) {
#pragma CTC SKIP
            cslAssert(!(sdp_ew_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_NO &&
                    sdp_ew_alu_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_BYPASS_NO &&
                    sdp_ew_alu_algo_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_ALGO_EQL) &&
                    sdp_output_dst_ == NVDLA_SDP_D_FEATURE_MODE_CFG_0_OUTPUT_DST_MEM );
#pragma CTC ENDSKIP

            WdmaSequenceWG();
        } else if (sdp_batch_number_ > 0) {
            cslAssert(sdp_output_dst_ == NVDLA_SDP_D_FEATURE_MODE_CFG_0_OUTPUT_DST_MEM);
            WdmaSequenceBatch();
        } else {
#pragma CTC SKIP
            if (!(sdp_ew_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_BYPASS_NO &&
                    sdp_ew_alu_bypass_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_BYPASS_NO &&
                    sdp_ew_alu_algo_ == NVDLA_SDP_D_DP_EW_CFG_0_EW_ALU_ALGO_EQL) &&
                   sdp_output_dst_ == NVDLA_SDP_D_FEATURE_MODE_CFG_0_OUTPUT_DST_MEM ) {
#pragma CTC ENDSKIP
                WdmaSequenceDC();
            }
        }
    }
#pragma CTC SKIP
}
#pragma CTC ENDSKIP

void NV_NVDLA_sdp::cacc2sdp_b_transport(int ID, nvdla_accu2pp_if_t* payload, sc_time& delay){
    int i;
    int32_t  *fifo_data_ptr;
    while (true) {
        if (NVDLA_SDP_D_FEATURE_MODE_CFG_0_FLYING_MODE_OFF == sdp_flying_mode_) {
            // sdp can receive data from cacc when sdp is in off-flying mode. In this case, cacc will be back-pressed.
            // It's also possible that cacc starts earlier than sdp and sdp's sdp_flying_mode_ is not set when cacc sends data to sdp.
            // wait next sdp kick off and check sdp_flying_mode_ again.
#pragma CTC SKIP
            cslDebug((30, "calling NV_NVDLA_sdp::cacc2sdp_b_transport. sdp_flying_mode_ is OFF\n"));
            wait(sdp_kickoff_);
#pragma CTC ENDSKIP
        } else {
            break;
        }
    }
    fifo_data_ptr = new int32_t[CC2PP_PAYLOAD_SIZE];    //CC2PP_PAYLOAD_SIZE=16
    cslDebug((70, "NV_NVDLA_sdp::cacc2sdp_b_transport:\n"));
    for(i=0;i<CC2PP_PAYLOAD_SIZE;i++) {
        fifo_data_ptr[i] = payload->pd.nvdla_cc2pp_pkg.data[i];
        cslDebug((70, "0x%08x ", (int32_t)fifo_data_ptr[i]));
    }
    cslDebug((70, "\n"));
    cc2pp_fifo_->write((int32_t*)fifo_data_ptr);
}

void NV_NVDLA_sdp::ExtractRdmaResponsePayloadCore(te_rdma_type eRdDma, nvdla_dma_rd_rsp_t* payload){
    // Extract data from payload
    // Each payload is 64 byte, two mask bit tells which 32 byte groups are effective
    int8_t *payload_data_ptr_i8;
    int16_t *payload_data_ptr_i16;
    uint8_t mask;
    char    *str = NULL;
    uint8_t data_use, is_int8;
    bool    is_both;
    int     cube_width;
    uint32_t buf_limit;
    int     bytes_per_element, component_per_element, bytes_per_component, element_per_atom;
    sc_fifo <int16_t *> *fifo_alu = NULL, *fifo_mul = NULL, *fifo, *fifos[2];
    mask = payload->pd.dma_read_data.mask;
    payload_data_ptr_i8    = reinterpret_cast <int8_t *> (payload->pd.dma_read_data.data);
    payload_data_ptr_i16   = reinterpret_cast <int16_t *> (payload->pd.dma_read_data.data);
    cslDebug((50, "NV_NVDLA_sdp::ExtractRdmaResponsePayload_%d, get a dma read response payload. mask=0x%x\n", eRdDma, (int)mask));
    bool    is_int16_to_int8 = false;

    cube_width      = sdp_rdma_width_+1;
    is_int16_to_int8 = sdp_rdma_in_precision_ != NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_IN_PRECISION_INT8 &&
            sdp_rdma_proc_precision_ == NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_PROC_PRECISION_INT8;


#pragma CTC SKIP
    if (mask==0x2) {    // First 32B is not effective, second 32B is effective
        FAIL(("NV_NVDLA_sdp::ExtractRdmaResponsePayload, mask==2 is unexcepted"));
    }
#pragma CTC ENDSKIP

    switch (eRdDma) {
    case SDP_RDMA_INPUT:
        fifo_alu = rdma_fifo_;
        data_use = NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_USE_ALU;
        is_int8  = sdp_rdma_in_precision_ == NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_IN_PRECISION_INT8;
        str = (char*)"SDP RDMA";
        break;
    case SDP_RDMA_X1_INPUT:
        fifo_alu = rdma_b_alu_fifo_;
        fifo_mul = rdma_b_mul_fifo_;
        data_use = sdp_rdma_brdma_data_use_;
        is_int8  = sdp_rdma_brdma_data_size_ == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_SIZE_ONE_BYTE;
        str = (char*)"SDP X1 RDMA";
        break;
    case SDP_RDMA_X2_INPUT:
        fifo_alu = rdma_n_alu_fifo_;
        fifo_mul = rdma_n_mul_fifo_;
        data_use = sdp_rdma_nrdma_data_use_;
        is_int8  = sdp_rdma_nrdma_data_size_ == NVDLA_SDP_RDMA_D_NRDMA_CFG_0_NRDMA_DATA_SIZE_ONE_BYTE;
        str = (char*)"SDP X2 RDMA";
        break;
    case SDP_RDMA_Y_INPUT:
        fifo_alu = rdma_e_alu_fifo_;
        fifo_mul = rdma_e_mul_fifo_;
        data_use = sdp_rdma_erdma_data_use_;
        is_int8  = sdp_rdma_erdma_data_size_ == NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DATA_SIZE_ONE_BYTE;
        str = (char*)"SDP Y RDMA";
        break;
#pragma CTC SKIP
    default:
        cslAssert((false));
#pragma CTC ENDSKIP
    }

    component_per_element = data_use == NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_DATA_USE_BOTH ? 2:1;
    bytes_per_component = is_int8 ? 1:2;
    bytes_per_element   = bytes_per_component * component_per_element;
    element_per_atom    = sdp_rdma_in_precision_ == NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0_IN_PRECISION_INT8 ? ELEMENT_PER_ATOM_INT8:ELEMENT_PER_ATOM_INT16;
    buf_limit = cube_width;
   
    for(int payload_iter = 0; payload_iter < DMAIF_WIDTH/DLA_ATOM_SIZE; payload_iter++ ) {
        payload_data_ptr_i8 += payload_iter*ATOM_CUBE_SIZE;
        payload_data_ptr_i16 += payload_iter*ATOM_CUBE_SIZE/2;

        is_both = data_use == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_USE_BOTH;
        if (data_use == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_USE_ALU) {
            fifo = fifo_alu;
            fifos[0] = fifo;
            cslDebug((50, "fifo_alu\n"));
        } else if (data_use == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_USE_MUL) {
            fifo = fifo_mul;
            fifos[0] = fifo;
            cslDebug((50, "fifo_mul\n"));
        } else {
            fifos[0] = fifo_alu;
            fifos[1] = fifo_mul;
        }
        if (0 != (mask & (0x1 << payload_iter))) {
            for(int i = 0; i < DLA_ATOM_SIZE/2; i++) {
                cslDebug((30, "payload data:0x%x\n", payload_data_ptr_i16[i]));
            }
            if (is_int16_to_int8 && eRdDma == SDP_RDMA_INPUT) {
                int max_width_step = (INTERNAL_BUF_SIZE)/(element_per_atom*bytes_per_element);
                int width_step = min(buf_limit - sdp_buf_width_iter_[eRdDma], (uint32_t)max_width_step);
                uint32_t buf_surf_stride = width_step*bytes_per_element*element_per_atom;

                if (sdp_buf_wr_ptr_[eRdDma] < buf_surf_stride) {
                    // save to internal buffer as data is not enough to deliver to DP;
                    memcpy(sdp_internal_buf_[eRdDma] + sdp_buf_wr_ptr_[eRdDma],
                            payload_data_ptr_i16, ATOM_CUBE_SIZE);
                    sdp_buf_wr_ptr_[eRdDma] += ATOM_CUBE_SIZE;
                } else {
#pragma CTC SKIP
                    assert(sdp_buf_wr_ptr_[eRdDma] == buf_surf_stride);
#pragma CTC ENDSKIP

                    // send the buffered data
                    int16_t *ptr1 = new int16_t[SDP_PARALLEL_PROC_NUM];
                    cslAssert((ptr1 != NULL));
                    memcpy(ptr1, sdp_internal_buf_[eRdDma] + sdp_buf_rd_ptr_[eRdDma],
                            SDP_PARALLEL_PROC_NUM*bytes_per_element);
                    fifo->write(ptr1);
                    cslDebug((30, "%s send a payload to alu or mul fifo\n", str));
                    sdp_buf_rd_ptr_[eRdDma] += ATOM_CUBE_SIZE;

                    // send the current received data
                    ptr1 = new int16_t[SDP_PARALLEL_PROC_NUM];
                    cslAssert((ptr1 != NULL));
                    memcpy(ptr1, payload_data_ptr_i16,
                            SDP_PARALLEL_PROC_NUM*bytes_per_element);
                    fifo->write(ptr1);
                    cslDebug((30, "%s send a payload to alu or mul fifo\n", str));

                    if (sdp_buf_rd_ptr_[eRdDma] == buf_surf_stride) {
                        // all the buffered data are read out;
                        sdp_buf_wr_ptr_[eRdDma] = 0;
                        sdp_buf_rd_ptr_[eRdDma] = 0;

                        sdp_buf_width_iter_[eRdDma] += width_step;

                        if (sdp_buf_width_iter_[eRdDma] == buf_limit) {
                            sdp_buf_width_iter_[eRdDma]  = 0;
                        }
                    }
                }
#pragma CTC SKIP
                cslDebug((50, "fifo_available:%d, sdp_buf_wr_ptr_[%d]=%d, sdp_buf_rd_ptr_[%d]=%d, expect:%d\n",
                            fifo->num_available(), eRdDma, sdp_buf_wr_ptr_[eRdDma], 
                            eRdDma, sdp_buf_rd_ptr_[eRdDma], buf_surf_stride));
#pragma CTC ENDSKIP
            } else {
                uint8_t *output_payloads[MAX_OUTPUT_PAYLOAD_NUM][MAX_OUTPUT_WAY_NUM];
                uint8_t num_payloads;
                dma_packers_[eRdDma].set_payload((uint8_t*)payload_data_ptr_i8,
                                                 output_payloads,
                                                 &num_payloads);
                uint8_t ways = is_both ? 2:1;
                for(int payload_iter = 0; payload_iter < num_payloads; payload_iter++) {
                    if (is_int8) {
                        // For int8, we have to cast the data type to int16_t
                        for(int way_iter = 0; way_iter < ways; way_iter++) {
                            int16_t *ptr = new int16_t [SDP_PARALLEL_PROC_NUM];
                            for(int element_iter = 0; element_iter < SDP_PARALLEL_PROC_NUM; element_iter++) {
                                ptr[element_iter] = static_cast<int16_t>((reinterpret_cast<int8_t*>(output_payloads[payload_iter][way_iter])[element_iter]));
                            }
                            delete [] output_payloads[payload_iter][way_iter];
                            cslDebug((50, "write SDP_PARALLEL_PROC_NUM(%d) elements to DP:0x%x, payload_iter:%d, way_iter:%d\n", SDP_PARALLEL_PROC_NUM, ptr[0], payload_iter, way_iter));
                            fifos[way_iter]->write(ptr);
                        }
                    } else {
                        for(int way_iter = 0; way_iter < ways; way_iter++) {
                            cslDebug((50, "write SDP_PARALLEL_PROC_NUM(%d) elements to DP:0x%x, payload_iter:%d, way_iter:%d\n", SDP_PARALLEL_PROC_NUM, *((int16_t*)output_payloads[payload_iter][way_iter]), payload_iter, way_iter));
                            fifos[way_iter]->write((int16_t*)output_payloads[payload_iter][way_iter]);
                        }
                    }
                }
            }
        }
    }

    cslAssert(mask != 0);
    rdma_atom_recieved_[eRdDma] += ((mask&0x3) == 0x3)? 2:1;
    if (rdma_atom_recieved_[eRdDma] == rdma_atom_total_[eRdDma]) {
#pragma CTC SKIP
        cslDebug((30, "dma:%d, atom_recieved:%d, total:%d\n",
                    eRdDma, rdma_atom_recieved_[eRdDma], rdma_atom_total_[eRdDma]));
#pragma CTC ENDSKIP
        rdma_atom_recieved_[eRdDma] = 0;
        if (eRdDma == SDP_RDMA_INPUT) {
            sdp_rdma_done_.notify(SC_ZERO_TIME);
            cslDebug((30, "sdp_rdma_done_.notify\n"));
        } else if (eRdDma == SDP_RDMA_X1_INPUT) {
            sdp_b_rdma_done_.notify(SC_ZERO_TIME);
            cslDebug((30, "sdp_b_rdma_done.notify\n"));
        } else if (eRdDma == SDP_RDMA_X2_INPUT) {
            sdp_n_rdma_done_.notify(SC_ZERO_TIME);
            cslDebug((30, "sdp_n_rdma_done.notify\n"));
#pragma CTC SKIP
        } else if (eRdDma == SDP_RDMA_Y_INPUT) {
#pragma CTC ENDSKIP
            sdp_e_rdma_done_.notify(SC_ZERO_TIME);
            cslDebug((30, "sdp_e_rdma_done.notify\n"));
#pragma CTC SKIP
        } else {
            cslAssert(false);
        }
#pragma CTC ENDSKIP
    } else {
        cslDebug((30, "dma:%d recieved:%d atoms\n", eRdDma, rdma_atom_recieved_[eRdDma]));
    }
}

void NV_NVDLA_sdp::mcif2sdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay){
    ExtractRdmaResponsePayloadCore(SDP_RDMA_INPUT, payload);
}

void NV_NVDLA_sdp::mcif2sdp_b_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay){
    ExtractRdmaResponsePayloadCore(SDP_RDMA_X1_INPUT, payload);
}

void NV_NVDLA_sdp::mcif2sdp_n_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay){
    ExtractRdmaResponsePayloadCore(SDP_RDMA_X2_INPUT, payload);
}

void NV_NVDLA_sdp::mcif2sdp_e_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay){
    ExtractRdmaResponsePayloadCore(SDP_RDMA_Y_INPUT, payload);
}

void NV_NVDLA_sdp::cvif2sdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay){
    ExtractRdmaResponsePayloadCore(SDP_RDMA_INPUT, payload);
}

void NV_NVDLA_sdp::cvif2sdp_b_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay){
    ExtractRdmaResponsePayloadCore(SDP_RDMA_X1_INPUT, payload);
}

void NV_NVDLA_sdp::cvif2sdp_n_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay){
    ExtractRdmaResponsePayloadCore(SDP_RDMA_X2_INPUT, payload);
}

void NV_NVDLA_sdp::cvif2sdp_e_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay){
    ExtractRdmaResponsePayloadCore(SDP_RDMA_Y_INPUT, payload);
}

/*
void NV_NVDLA_sdp::WaitUntilRdmaFifoFreeSizeGreaterThan(uint32_t num) {
    while (uint32_t(rdma_fifo_->num_free()) < num) {
        wait( rdma_fifo_->data_read_event() );
    }
}
*/

// Send DMA read request
void NV_NVDLA_sdp::SendDmaReadRequest(te_rdma_type eRdDma, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    if (eRdDma == SDP_RDMA_INPUT) {
        if ( (NVDLA_SDP_RDMA_D_SRC_DMA_CFG_0_SRC_RAM_TYPE_MC) == sdp_rdma_src_ram_type_) {
            cslDebug((50, "NV_NVDLA_sdp::%s on SDP_RDMA MC port start.\n", __FUNCTION__));
            NV_NVDLA_sdp_base::sdp2mcif_rd_req_b_transport(payload, dma_delay_);
        } else {
            cslDebug((50, "NV_NVDLA_sdp::%s on SDP_RDMA CV port start.\n", __FUNCTION__));
            NV_NVDLA_sdp_base::sdp2cvif_rd_req_b_transport(payload, dma_delay_);
        }
    } else if (eRdDma == SDP_RDMA_X1_INPUT) {
         if ( (NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_RAM_TYPE_MC) == sdp_rdma_brdma_ram_type_) {
            cslDebug((50, "NV_NVDLA_sdp::%s on SDP_BRDMA MC port start.\n", __FUNCTION__));
            NV_NVDLA_sdp_base::sdp_b2mcif_rd_req_b_transport(payload, dma_delay_);
        } else {
            cslDebug((50, "NV_NVDLA_sdp::%s on SDP_BRDMA CV port start.\n", __FUNCTION__));
            NV_NVDLA_sdp_base::sdp_b2cvif_rd_req_b_transport(payload, dma_delay_);
        }
    } else if (eRdDma == SDP_RDMA_X2_INPUT) {
         if ( (NVDLA_SDP_RDMA_D_NRDMA_CFG_0_NRDMA_RAM_TYPE_MC) == sdp_rdma_nrdma_ram_type_) {
            cslDebug((50, "NV_NVDLA_sdp::%s on SDP_NRDMA MC port start.\n", __FUNCTION__));
            NV_NVDLA_sdp_base::sdp_n2mcif_rd_req_b_transport(payload, dma_delay_);
        } else {
            cslDebug((50, "NV_NVDLA_sdp::%s on SDP_NRDMA CV port start.\n", __FUNCTION__));
            NV_NVDLA_sdp_base::sdp_n2cvif_rd_req_b_transport(payload, dma_delay_);
        }
    } else {
         if ( (NVDLA_SDP_RDMA_D_ERDMA_CFG_0_ERDMA_RAM_TYPE_MC) == sdp_rdma_erdma_ram_type_) {
            cslDebug((50, "NV_NVDLA_sdp::%s on SDP_ERDMA MC port start.\n", __FUNCTION__));
            NV_NVDLA_sdp_base::sdp_e2mcif_rd_req_b_transport(payload, dma_delay_);
        } else {
            cslDebug((50, "NV_NVDLA_sdp::%s on SDP_ERDMA CV port start.\n", __FUNCTION__));
            NV_NVDLA_sdp_base::sdp_e2cvif_rd_req_b_transport(payload, dma_delay_);
        }
    }
}

// Send DMA write request
void NV_NVDLA_sdp::SendDmaWriteRequest(uint64_t payload_addr, uint32_t payload_size, uint32_t payload_atom_num, bool ack_required){
    uint32_t atom_iter = 0;
    int16_t *dma_write_data_ptr;
    int i;
    uint8_t *ptr;
    bool is_int8_to_int16 = sdp_proc_precision_ == NVDLA_SDP_D_DATA_FORMAT_0_PROC_PRECISION_INT8 &&
        sdp_out_precision_ != NVDLA_SDP_D_DATA_FORMAT_0_OUT_PRECISION_INT8;
    bool is_1x1 = sdp_width_ == 0 && sdp_height_==0;
    if (!is_int8_to_int16 || is_1x1 ) {
        // Prepare payload
        dma_wr_req_cmd_payload_->pd.dma_write_cmd.addr = payload_addr;
        dma_wr_req_cmd_payload_->pd.dma_write_cmd.size = payload_atom_num-1;
        // WaitUntilWdmaBufferAvailableSizeGreaterThan(payload_atom_num);
        // Send write command
        cslDebug((50, "NV_NVDLA_sdp::SendDmaWriteRequest before CMD addr=0x%lx payload_atom_num=%d\n", payload_addr, payload_atom_num));
        SendDmaWriteRequest(dma_wr_req_cmd_payload_, dma_delay_, ack_required);
        cslDebug((50, "NV_NVDLA_sdp::SendDmaWriteRequest after CMD addr=0x%lx payload_atom_num=%d\n", payload_addr, payload_atom_num));
    }
    if (sdp_out_precision_ == DATA_FORMAT_IS_INT8) {
        int8_t *payload_data_ptr;
        payload_data_ptr = reinterpret_cast <int8_t *>  (dma_wr_req_data_payload_->pd.dma_write_data.data);
        atom_iter = 0;
        while( atom_iter < payload_atom_num) {
            // each transaction from DP is SDP_PARALLEL_PROC_NUM elements, we have
            // to pack/unpack to ATOMs
            uint8_t *output_payloads[MAX_OUTPUT_PAYLOAD_NUM][MAX_OUTPUT_WAY_NUM];
            uint8_t num_payloads = 0;
            do {
                dma_write_data_ptr = reinterpret_cast <int16_t *>(wdma_fifo_->read());
                dma_packers_[SDP_WDMA].set_payload((uint8_t*)dma_write_data_ptr,
                       output_payloads, &num_payloads );
                delete [] dma_write_data_ptr;
            } while(num_payloads == 0);

            for(int payload_iter = 0; payload_iter < num_payloads; payload_iter++) {
                int16_t *tmp_ptr = reinterpret_cast<int16_t*>(output_payloads[payload_iter][0]);
                for(int element_iter = 0; element_iter < NVDLA_MEMORY_ATOMIC_SIZE; element_iter++) {
                    payload_data_ptr[element_iter + (atom_iter%DMA_MAX_ATOM_NUM)*NVDLA_MEMORY_ATOMIC_SIZE] = (int8_t)tmp_ptr[element_iter];
                }
            }
            if (atom_iter%DMA_MAX_ATOM_NUM == DMA_MAX_ATOM_NUM-1) {
                SendDmaWriteRequest (dma_wr_req_data_payload_, dma_delay_);
                cslDebug((70, "NV_NVDLA_sdp::SendDmaWriteRequest, dma_wr_req_data_payload_, atoms_sent=%d\n", atom_iter+1));
                for(i=0;i<DMAIF_WIDTH;i++) {
                    cslDebug((70, "0x%x ", (unsigned int)payload_data_ptr[i]));
                }
                cslDebug((70, "\n"));
            }
            atom_iter += num_payloads;
        }
        ptr = reinterpret_cast<uint8_t *>(payload_data_ptr);
    } else {
        if (is_int8_to_int16 == false || is_1x1) {
            int16_t *payload_data_ptr;
            payload_data_ptr = reinterpret_cast <int16_t *>  (dma_wr_req_data_payload_->pd.dma_write_data.data);
            for (atom_iter = 0; atom_iter < payload_atom_num; atom_iter++) {
                // each transaction from DP is SDP_PARALLEL_PROC_NUM elements, we have
                // to pack/unpack to ATOMs
                uint8_t *output_payloads[MAX_OUTPUT_PAYLOAD_NUM][MAX_OUTPUT_WAY_NUM];
                uint8_t num_payloads = 0;
                do {
                    dma_write_data_ptr = reinterpret_cast <int16_t *>(wdma_fifo_->read());
                    dma_packers_[SDP_WDMA].set_payload((uint8_t*)dma_write_data_ptr,
                            output_payloads, &num_payloads );
                    delete [] dma_write_data_ptr;
                } while(num_payloads == 0);

                for(int payload_iter = 0; payload_iter < num_payloads; payload_iter++) {
                    int16_t *tmp_ptr = reinterpret_cast<int16_t*>(output_payloads[payload_iter][0]);
                    for(int element_iter = 0; element_iter < NVDLA_MEMORY_ATOMIC_SIZE; element_iter++) {
                        payload_data_ptr[element_iter + (atom_iter%DMA_MAX_ATOM_NUM)*NVDLA_MEMORY_ATOMIC_SIZE] = (int16_t)tmp_ptr[element_iter];
                    }
                }
                if (atom_iter%DMA_MAX_ATOM_NUM == DMA_MAX_ATOM_NUM-1) {
                    SendDmaWriteRequest (dma_wr_req_data_payload_, dma_delay_);
                    cslDebug((70, "NV_NVDLA_sdp::SendDmaWriteRequest, dma_wr_req_data_payload_, atoms_sent=%d\n", atom_iter+1));
                    for(i=0;i<DMAIF_WIDTH/2;i++) {
                        cslDebug((70, "0x%x ", (unsigned int)payload_data_ptr[i]));
                    }
                    cslDebug((70, "\n"));
                }
            }
            ptr = reinterpret_cast<uint8_t *>(payload_data_ptr);
        } else {
            // INT8 --> INT16
            cslAssert(payload_atom_num <= 2);
            for (atom_iter = 0; atom_iter < payload_atom_num; atom_iter++) {
                for(int surf_internal_iter = 0; surf_internal_iter < 2; surf_internal_iter++) {
                    cslDebug((70, "%s: before read wdma_fifo\n", __FUNCTION__));
                    dma_write_data_ptr = wdma_fifo_->read();  
                    cslDebug((70, "%s: after read wdma_fifo\n", __FUNCTION__));
                    memcpy (sdp_internal_buf_[0] + surf_internal_iter*DMA_TRANSACTION_SIZE + atom_iter*ATOM_CUBE_SIZE,
                            dma_write_data_ptr, ATOM_CUBE_SIZE);

                }
            }
            int16_t *payload_data_ptr;
            uint32_t dst_surf_stride = sdp_dst_surface_stride_ * DLA_ATOM_SIZE;
            payload_data_ptr = reinterpret_cast <int16_t *>  (dma_wr_req_data_payload_->pd.dma_write_data.data);
            for(int surf_internal_iter = 0; surf_internal_iter < 2; surf_internal_iter++) {
                memcpy (payload_data_ptr, sdp_internal_buf_[0] + surf_internal_iter*DMA_TRANSACTION_SIZE, payload_atom_num*ATOM_CUBE_SIZE);
                // Prepare payload
                dma_wr_req_cmd_payload_->pd.dma_write_cmd.addr = payload_addr + surf_internal_iter*dst_surf_stride;
                dma_wr_req_cmd_payload_->pd.dma_write_cmd.size = payload_atom_num-1;
                // WaitUntilWdmaBufferAvailableSizeGreaterThan(payload_atom_num);
                // Send write command
#pragma CTC SKIP
                cslDebug((50, "NV_NVDLA_sdp::SendDmaWriteRequest addr=0x%lx payload_atom_num=%d\n",
                            dma_wr_req_cmd_payload_->pd.dma_write_cmd.addr, payload_atom_num));
#pragma CTC ENDSKIP
                SendDmaWriteRequest(dma_wr_req_cmd_payload_, dma_delay_, ack_required && (surf_internal_iter == 1));
                SendDmaWriteRequest (dma_wr_req_data_payload_, dma_delay_);
                cslDebug((50, "%s send payload success\n", __FUNCTION__));
            }
        }
    }
    // payload_atom_num is a odd number
    int remaining_atom_num = payload_atom_num%DMA_MAX_ATOM_NUM;
    if ( remaining_atom_num != 0 && (!is_int8_to_int16)) {
        // Fill the last bytes with 0
        cslDebug((30, "%s filling 0s to last invalid atom\n", __FUNCTION__));
        memset (&ptr[remaining_atom_num*DLA_ATOM_SIZE], 0, (DMA_MAX_ATOM_NUM-remaining_atom_num)*DLA_ATOM_SIZE);
        SendDmaWriteRequest (dma_wr_req_data_payload_, dma_delay_);
    }
    assert(0 == dma_packers_[SDP_WDMA].get_data_size());

    if (ack_required) {
        ack_info *ack = new ack_info;
        ack->is_mc = sdp_dst_ram_type_ == NVDLA_SDP_D_DST_DMA_CFG_0_DST_RAM_TYPE_MC;
        ack->group_id = sdp_consumer_;
        cslDebug((30, "%s: notify write complete on group:%d, is_mc:%d\n",
                    __FUNCTION__, sdp_consumer_, ack->is_mc));
        sdp_ack_fifo_->write(ack);
        sdp_done_.notify(SC_ZERO_TIME);
    }
    cslDebug((70, "exit:%s\n", __FUNCTION__));
}

void NV_NVDLA_sdp::SendDmaWriteRequest(nvdla_dma_wr_req_t* payload, sc_time& delay, bool ack_required) {
    if (NVDLA_SDP_D_DST_DMA_CFG_0_DST_RAM_TYPE_MC == sdp_dst_ram_type_) {
        if (TAG_CMD == payload->tag) {
            if (ack_required) {
                payload->pd.dma_write_cmd.require_ack = 1;
            } else {
                payload->pd.dma_write_cmd.require_ack = 0;
            }
        }
        cslDebug((70, "before: sdp2mcif_wr_req_b_transport, is_cmd:%d\n", payload->tag == TAG_CMD));
        sdp2mcif_wr_req_b_transport(payload, dma_delay_);
        cslDebug((70, "after: sdp2mcif_wr_req_b_transport\n"));
    } else {
        if (TAG_CMD == payload->tag) {
            if (ack_required) {
                payload->pd.dma_write_cmd.require_ack = 1;
            } else {
                payload->pd.dma_write_cmd.require_ack = 0;
            }
        }
        cslDebug((70, "before: sdp2cvif_wr_req_b_transport\n"));
        sdp2cvif_wr_req_b_transport(payload, dma_delay_);
        cslDebug((70, "after: sdp2cvif_wr_req_b_transport\n"));
    }
}

uint16_t NV_NVDLA_sdp::read_lut() {
    return sdp_hls_wrapper_.read_lut(sdp_lut_table_idx, sdp_lut_entry_idx);
    
}

void NV_NVDLA_sdp::write_lut() {
    return sdp_hls_wrapper_.write_lut(sdp_lut_table_idx, sdp_lut_entry_idx, sdp_lut_data);
}

void NV_NVDLA_sdp::WriteResponseThreadMc() {
    cslDebug((50, "NV_NVDLA_sdp::WriteResponseThreadMc is called\n"));
    if ( true == mcif2sdp_wr_rsp.read() ) {
        is_mc_ack_done_ = true;
        sdp_mc_ack_.notify(SC_ZERO_TIME);
        cslDebug((50, "NV_NVDLA_sdp::WriteResponseThreadMc, sent sdp_done notification\n"));
    }
}

void NV_NVDLA_sdp::WriteResponseThreadCv() {
    if ( true == cvif2sdp_wr_rsp.read() ) {
        is_cv_ack_done_ = true;
        sdp_cv_ack_.notify(SC_ZERO_TIME);
        cslDebug((50, "NV_NVDLA_sdp::WriteResponseThreadCv, sent sdp_done notification\n"));
    }
}

#pragma CTC SKIP
NV_NVDLA_sdp * NV_NVDLA_sdpCon(sc_module_name name) {
    return new NV_NVDLA_sdp(name);
}
#pragma CTC ENDSKIP

