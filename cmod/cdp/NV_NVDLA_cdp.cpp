// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cdp.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_cdp.h"
#include "NV_NVDLA_cdp_cdp_gen.h"
#include "NV_NVDLA_cdp_cdp_rdma_gen.h"
#include "arnvdla.uh"
#include "arnvdla.h"
#include "cmacros.uh"
#include "math.h"
#include "NvdlaDataFormatConvertor.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#include "cdp_hls_wrapper.h"

// We have some constrain when program LUT, however, this is not awared by TB
// which leads to assertion fail, temporary workaround it by remove those
// assertion, BUG: 
#define ASSERT_WAR_CONSTRAIN 1

#define DATA_FORMAT_INT8        NVDLA_CDP_RDMA_D_DATA_FORMAT_0_INPUT_DATA_INT8
#define DATA_FORMAT_INT16       NVDLA_CDP_RDMA_D_DATA_FORMAT_0_INPUT_DATA_INT16
#define DATA_FORMAT_FP16        NVDLA_CDP_RDMA_D_DATA_FORMAT_0_INPUT_DATA_FP16

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

const static bool USE_LUT = true;
const static bool NOT_USE_LUT = false;

NV_NVDLA_cdp::NV_NVDLA_cdp( sc_module_name module_name ):
    NV_NVDLA_cdp_base(module_name),
    cdp2glb_done_intr("cdp2glb_done_intr", 2),
    // Delay setup
    dma_delay_(SC_ZERO_TIME),
    csb_delay_(SC_ZERO_TIME),
    b_transport_delay_(SC_ZERO_TIME)
{
    // Memory allocation
    dp_calc_buffer      = new int8_t [8*ATOM_CUBE_SIZE*2];    // 256B*2
    post_calc_buffer    = new int8_t [CDP_PRE_CALC_BUFFER_ATOM_NUM*32];
    rdma_fifo_          = new sc_fifo <int8_t *> (CDP_RDMA_SIZE);
    hls_out_fifo_       = new sc_fifo <int16_t *> (1024);
    rdma_atom_num_fifo_ = new sc_fifo <uint32_t> (1024);
    hls_atom_num_fifo_  = new sc_fifo <uint32_t> (1024);
    cdp_ack_fifo_     = new sc_fifo <cdp_ack_info*> (2);
    dma_wr_req_cmd_payload_ = new nvdla_dma_wr_req_t;
    dma_wr_req_cmd_payload_->tag = TAG_CMD;
    dma_wr_req_data_payload_= new nvdla_dma_wr_req_t;
    dma_wr_req_data_payload_->tag = TAG_DATA;
    dma_rd_req_payload_     = new nvdla_dma_rd_req_t;
    cdp_fifo_cfg_dp_        = new sc_fifo <CdpConfig *>  (1);
    cdp_fifo_cfg_wdma_      = new sc_fifo <CdpConfig *>  (1);
    is_mc_ack_done_ = false;
    is_cv_ack_done_ = false;
    txn_r = 0;
    txn_w = 0;

    // Reset
    Reset();

    // SC_THREAD
    SC_THREAD(CdpRdmaConsumerThread);
    SC_THREAD(CdpConsumerThread);
    SC_THREAD(CdpRdmaReadSequenceThread);
    SC_THREAD(CdpDataPathOperationSequenceThread);
    SC_THREAD(CdpWdmaWriteSequenceThread);
    SC_THREAD(CdpIntrThread);
    // SC_METHOD()
    SC_METHOD(WriteResponseThreadMc);
    sensitive << mcif2cdp_wr_rsp;
    SC_METHOD(WriteResponseThreadCv);
    sensitive << cvif2cdp_wr_rsp;
}

#pragma CTC SKIP
NV_NVDLA_cdp::~NV_NVDLA_cdp() {
    if( dp_calc_buffer )        delete [] dp_calc_buffer;
    if( post_calc_buffer )      delete [] post_calc_buffer;
    if( rdma_fifo_ )            delete rdma_fifo_;
    if( cdp_ack_fifo_)         delete cdp_ack_fifo_;
    if( rdma_atom_num_fifo_)    delete rdma_atom_num_fifo_;
    if( hls_atom_num_fifo_)     delete hls_atom_num_fifo_;
    if( dma_wr_req_cmd_payload_ )   delete dma_wr_req_cmd_payload_;
    if( dma_wr_req_data_payload_ )  delete dma_wr_req_data_payload_;
    if( dma_rd_req_payload_ )       delete dma_rd_req_payload_;
    if( cdp_fifo_cfg_dp_ )       delete cdp_fifo_cfg_dp_;
    if( cdp_fifo_cfg_wdma_ )       delete cdp_fifo_cfg_wdma_;
}
#pragma CTC ENDSKIP

void NV_NVDLA_cdp::Reset()
{
    // Clear register and internal states
    CdpRegReset();
    CdpRdmaRegReset();
    is_there_ongoing_csb2cdp_response_      = false;
    is_there_ongoing_csb2cdp_rdma_response_ = false;

    cdp2glb_done_intr[0].initialize(false);
    cdp2glb_done_intr[1].initialize(false);
}

void NV_NVDLA_cdp::CdpRdmaConsumerThread () {
    while (true) {
        while(CdpRdmaGetOpeartionEnable(cdp_rdma_register_group_0) != NVDLA_CDP_RDMA_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_cdp_rdma_reg_group_0_operation_enable);
        }
        cdp_rdma_reg_model::CdpRdmaUpdateWorkingStatus(0,1);
        cdp_rdma_reg_model::CdpRdmaUpdateVariables(cdp_rdma_register_group_0);
        CdpRdmaHardwareLayerExecutionTrigger();
        cdp_rdma_reg_model::CdpRdmaUpdateWorkingStatus(0,0);
        cdp_rdma_reg_model::CdpRdmaClearOpeartionEnable(cdp_rdma_register_group_0);

        while(CdpRdmaGetOpeartionEnable(cdp_rdma_register_group_1) != NVDLA_CDP_RDMA_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_cdp_rdma_reg_group_1_operation_enable);
        }
        cdp_rdma_reg_model::CdpRdmaUpdateWorkingStatus(1,1);
        cdp_rdma_reg_model::CdpRdmaUpdateVariables(cdp_rdma_register_group_1);
        CdpRdmaHardwareLayerExecutionTrigger();
        cdp_rdma_reg_model::CdpRdmaUpdateWorkingStatus(1,0);
        cdp_rdma_reg_model::CdpRdmaClearOpeartionEnable(cdp_rdma_register_group_1);
    }
}

void NV_NVDLA_cdp::CdpConsumerThread () {
    while (true) {
        while(CdpGetOpeartionEnable(cdp_register_group_0) != NVDLA_CDP_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_cdp_reg_group_0_operation_enable);
        }
        cdp_reg_model::CdpUpdateWorkingStatus(0,1);
        cdp_reg_model::CdpUpdateVariables(cdp_register_group_0);
        CdpHardwareLayerExecutionTrigger();
        cdp_reg_model::CdpUpdateWorkingStatus(0,0);
        cdp_reg_model::CdpClearOpeartionEnable(cdp_register_group_0);

        while(CdpGetOpeartionEnable(cdp_register_group_1) != NVDLA_CDP_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_cdp_reg_group_1_operation_enable);
        }
        cdp_reg_model::CdpUpdateWorkingStatus(1,1);
        cdp_reg_model::CdpUpdateVariables(cdp_register_group_1);
        CdpHardwareLayerExecutionTrigger();
        cdp_reg_model::CdpUpdateWorkingStatus(1,0);
        cdp_reg_model::CdpClearOpeartionEnable(cdp_register_group_1);
    }
}

void NV_NVDLA_cdp::CdpIntrThread() {
    while (true) {
        while (uint32_t(cdp_ack_fifo_->num_available()) < 1) {
            wait( cdp_ack_fifo_->data_written_event() );
        }
        cdp_ack_info *ack = cdp_ack_fifo_->read();

        if (ack->is_mc) {
            if (!is_mc_ack_done_)
                wait(cdp_mc_ack_);

            is_mc_ack_done_ = false;
        } else {
            if (!is_cv_ack_done_)
                wait(cdp_cv_ack_);

            is_cv_ack_done_ = false;
        }

        wait(1, SC_NS);
        cdp2glb_done_intr[ack->group_id].write(true);

        delete ack;
    }
}

void NV_NVDLA_cdp::CdpRdmaHardwareLayerExecutionTrigger () {
    cdp_rdma_kickoff_.notify();
    wait(cdp_rdma_done_);
}

void NV_NVDLA_cdp::CdpHardwareLayerExecutionTrigger () {
    cdp_kickoff_.notify();
    cslInfo(("NV_NVDLA_cdp::CdpHardwareLayerExecutionTrigger, cdp has just been kicked off.\n"));
    wait(cdp_done_);
}

void NV_NVDLA_cdp::CdpRdmaReadSequenceThread () {
    // Wait kick off event
    CdpConfig *cdp_config, *cdp_config_wdma;
    while (true) {
        wait(cdp_rdma_kickoff_);
        cslInfo(("NV_NVDLA_cdp::CdpRdmaReadSequenceThread, get CDP RDMA hardware layer kickoff event.\n"));
        cdp_config = new CdpConfig;
        cdp_config_wdma = new CdpConfig;
        cdp_config->cdp_rdma_width_ = cdp_rdma_width_;
        cdp_config->cdp_rdma_height_ = cdp_rdma_height_;
        cdp_config->cdp_rdma_channel_ = cdp_rdma_channel_;
        *cdp_config_wdma = *cdp_config;

        cdp_fifo_cfg_dp_->write(cdp_config);
        cdp_fifo_cfg_wdma_->write(cdp_config_wdma);

        CdpRdmaOrdinarySequence();

        // Send out done
        cdp_rdma_done_.notify();
    }
}

#pragma CTC SKIP
// This function is not used at all
void NV_NVDLA_cdp::CdpRdmaReadphileSequence() {
    CdpRdmaSequence_0();
}

void NV_NVDLA_cdp::CdpRdmaWritephileSequence() {
}

void NV_NVDLA_cdp::CdpRdmaOrdinarySequence() {
    CdpRdmaSequence_0();
}
#pragma CTC ENDSKIP

// base_addr_sequencer: determines the dma sequencer and how to split the read/write data requests
// base_addr_dma: the start address of RDMA
void NV_NVDLA_cdp::CdpRdmaSequence_0() {
    // Config variables, they have corresponding value in registers
    uint32_t    cube_width, cube_height, cube_channel;
    uint64_t    line_stride;
    uint64_t    surf_stride;
    uint8_t     element_per_group_src;
    // Control variables
    // # Iterators
    uint32_t    surf_iter;
    uint32_t    surf_num;
    uint32_t    line_iter;
    uint32_t    atom_num, atom_sent;
    // # Evaluated variable
    uint64_t    src_base_addr;
    uint64_t    surf0_payload_addr;
    uint64_t    payload_addr;
    uint32_t    payload_size;
    uint32_t    payload_atom_num;

    cslInfo(("NV_NVDLA_cdp::CdpRdmaSequence0, start.\n"));
    // Copy from register value to local config variables, similar with RTL connection, begin
    // # Cube setting
    cube_width      = cdp_rdma_width_+1;
    cube_height     = cdp_rdma_height_+1;
    cube_channel    = cdp_rdma_channel_+1;
    line_stride     = cdp_rdma_src_line_stride_ * 32;
    surf_stride     = cdp_rdma_src_surface_stride_ * 32;
    src_base_addr   = ((uint64_t)cdp_rdma_src_base_addr_high_ << 32)  | ((uint64_t)cdp_rdma_src_base_addr_low_ << 5);

    // # Precision setting
    switch (cdp_rdma_input_data_) {
        case DATA_FORMAT_IS_INT8:
            element_per_group_src   = ELEMENT_PER_GROUP_INT8;
            break;
        case DATA_FORMAT_IS_INT16:
            element_per_group_src   = ELEMENT_PER_GROUP_INT16;
            break;
        case DATA_FORMAT_IS_FP16:
            element_per_group_src   = ELEMENT_PER_GROUP_FP16;
            break;
#pragma CTC SKIP
        default: break;
#pragma CTC ENDSKIP
    }
    // Copy from register value to local config variables, similar with RTL connection, end
    cslInfo(("%s WxHxC=%dx%dx%d, format:%d\n", __FUNCTION__,
                cube_width, cube_height, cube_channel,cdp_rdma_input_data_));
    cslInfo(("\t addr:0x%lx, line_stride:%lx, surf_stride:%lx\n", src_base_addr, line_stride, surf_stride));

    surf_num = (cube_channel + element_per_group_src - 1) / element_per_group_src;

    for (line_iter=0; line_iter < cube_height; line_iter++) {
        // surf0_* variables are for each line of surface0
        atom_sent = 0;
        atom_num = cube_width;
        surf0_payload_addr = src_base_addr + line_iter * line_stride;   // The start address of the current line of the first surface
        payload_size     = MAX_MEM_TRANSACTION_SIZE;
        payload_atom_num = payload_size / ATOM_CUBE_SIZE;

        while (atom_sent < atom_num) {
            // For READPHILE
            /*if(atom_sent == 0) {    // First request
                payload_size     = min((uint64_t)cube_width*ATOM_CUBE_SIZE, MAX_MEM_TRANSACTION_SIZE - surf0_payload_addr%MAX_MEM_TRANSACTION_SIZE);
            }
            else if ((atom_num - atom_sent) <= MAX_MEM_TRANSACTION_SIZE/ATOM_CUBE_SIZE) {     // Last request
                payload_size     = (atom_num - atom_sent)*ATOM_CUBE_SIZE;
            }
            else {
                payload_size     = MAX_MEM_TRANSACTION_SIZE;
            }
            */
            if ((atom_num - atom_sent) <= MAX_MEM_TRANSACTION_SIZE/ATOM_CUBE_SIZE) {     // Last request
                payload_size     = (atom_num - atom_sent)*ATOM_CUBE_SIZE;
            }
            else {
                payload_size     = MAX_MEM_TRANSACTION_SIZE;
            }
            payload_atom_num     = payload_size / ATOM_CUBE_SIZE;

            // Send DMA request for all surfaces
            for (surf_iter = 0; surf_iter < surf_num; surf_iter++) {
                cslDebug((50, "CdpRdmaSequence_0 line_iter=%d, surf_iter=%d, atom_sent=%d\n", line_iter, surf_iter, atom_sent));
                rdma_atom_num_fifo_->write(payload_atom_num);
                payload_addr     = surf0_payload_addr + surf_iter * surf_stride + atom_sent * ATOM_CUBE_SIZE; // surface_stride is multiple of 256
                cslDebug((50, "CdpRdmaSequence_0 SendDmaReadRequest payload_addr=0x%lx payload_atom_num=%d\n", payload_addr, payload_atom_num));
                dma_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr;
                dma_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num - 1;
                //WaitUntilRdmaFifoFreeSizeGreaterThan(payload_atom_num);
                cslDebug((50, "WaitUntilRdmaFifoFreeSizeGreaterThan done\n"));
                SendDmaReadRequest(dma_rd_req_payload_, dma_delay_, cdp_rdma_src_ram_type_);
            }

            atom_sent               += payload_atom_num;
        }
    }
    cslInfo(("%s: finished fetch input cube, totally: %d atoms are fetched\n", __FUNCTION__, atom_sent*cube_height));
}

void NV_NVDLA_cdp::CdpDataPathOperationSequenceThread () {
    while (true) {
        wait(cdp_kickoff_);
        cslInfo(("NV_NVDLA_cdp::CdpDataPathOperationSequenceThread, catch cdp_kickoff_ event.\n"));

        CdpDataPathReadphileSequence();
    }
}

void NV_NVDLA_cdp::reset_stats_regs() {
    lut_o_flow = 0;
    lut_u_flow = 0;
    lut_le_hit = 0;
    lut_lo_hit = 0;
    lut_hybrid_hit = 0;
    o_cvt_o_flow = 0;
    nan_input_num = 0;
    inf_input_num = 0;
    nan_output_num = 0;
}
void NV_NVDLA_cdp::update_stats_regs() {
    cslInfo(("NV_NVDLA_cdp, nan_input_num:%d\n", nan_input_num));
    cslInfo(("NV_NVDLA_cdp, inf_input_num:%d\n", inf_input_num));
    cslInfo(("NV_NVDLA_cdp, nan_output_num:%d\n", nan_output_num));

    cslInfo(("NV_NVDLA_cdp, lut_u_flow:%d\n", lut_u_flow));
    cslInfo(("NV_NVDLA_cdp, lut_o_flow:%d\n", lut_o_flow));
    cslInfo(("NV_NVDLA_cdp, lut_le_hit:%d\n", lut_le_hit));
    cslInfo(("NV_NVDLA_cdp, lut_lo_hit:%d\n", lut_lo_hit));
    cslInfo(("NV_NVDLA_cdp, lut_hybrid_hit:%d\n", lut_hybrid_hit));

    cdp_reg_model::CdpUpdateStatusRegister((uint32_t)NVDLA_CDP_D_NAN_INPUT_NUM_0,  cdp_consumer_, (uint32_t)nan_input_num);
    cdp_reg_model::CdpUpdateStatusRegister((uint32_t)NVDLA_CDP_D_INF_INPUT_NUM_0,  cdp_consumer_, (uint32_t)inf_input_num);
    cdp_reg_model::CdpUpdateStatusRegister((uint32_t)NVDLA_CDP_D_NAN_OUTPUT_NUM_0, cdp_consumer_, (uint32_t)nan_output_num);
    cdp_reg_model::CdpUpdateStatusRegister((uint32_t)NVDLA_CDP_D_OUT_SATURATION_0, cdp_consumer_, (uint32_t)o_cvt_o_flow);

//    if (cdp_lut_en_ == NVDLA_CDP_D_PERF_ENABLE_LUT_EN_ENABLE) {
        cdp_reg_model::CdpUpdateStatusRegister((uint32_t)NVDLA_CDP_D_PERF_LUT_UFLOW_0,
                cdp_consumer_,
                (uint32_t)lut_u_flow);
        cdp_reg_model::CdpUpdateStatusRegister((uint32_t)NVDLA_CDP_D_PERF_LUT_OFLOW_0,
                cdp_consumer_,
                (uint32_t)lut_o_flow);
        cdp_reg_model::CdpUpdateStatusRegister((uint32_t)NVDLA_CDP_D_PERF_LUT_HYBRID_0,
                cdp_consumer_,
                (uint32_t)lut_hybrid_hit);
        cdp_reg_model::CdpUpdateStatusRegister((uint32_t)NVDLA_CDP_D_PERF_LUT_LE_HIT_0,
                cdp_consumer_,
                (uint32_t)lut_le_hit );
        cdp_reg_model::CdpUpdateStatusRegister((uint32_t)NVDLA_CDP_D_PERF_LUT_LO_HIT_0,
                cdp_consumer_,
                (uint32_t)lut_lo_hit );
//    }
}
void NV_NVDLA_cdp::CdpDataPathReadphileSequence() {
    reset_stats_regs();
    CdpDataPathSequence();
    update_stats_regs();
}

#pragma CTC SKIP
void NV_NVDLA_cdp::CdpDataPathWritephileSequence() {
}

void NV_NVDLA_cdp::CdpDataPathOrdinarySequence() {
}
#pragma CTC ENDSKIP

void NV_NVDLA_cdp::CdpDataPathSequence() {
    // Config variables, they have corresponding value in registers
    uint32_t    cube_width, cube_height, cube_channel;
    uint8_t     element_per_group_src;
    // Control variables
    // # Iterators
    uint32_t    width_iter;
    uint32_t    surf_iter;
    uint32_t    surf_num;
    uint32_t    line_iter;
    uint32_t    round_iter;
    uint32_t    atom_num;
    uint32_t    nxt_atom_num;
    uint32_t    atom_iter;
    uint32_t    nxt_atom_iter;
    uint32_t    processed_atom_num;
    uint32_t    atom_num_per_line;
    uint32_t    hls_out_num_;
    uint32_t    hls_lookup_num_;
    // # Evaluated variable
    //uint64_t    payload_addr;
    //uint32_t    payload_size;
    //uint32_t    payload_atom_num;
    //uint8_t     element_size_src;

    int8_t     *first_half_calc_buffer;
    int8_t     *second_half_calc_buffer;
    int8_t     *cur_calc_buffer;
    int8_t     *pre_calc_buffer;
    int8_t     *nxt_calc_buffer;

    // Varibles for HLS
    // Input
    //    uint16_t    data0, data1, data2, data3;
    int16_t     data_to_hls[12];
    int8_t      *data_to_hls_i8 = (int8_t*)(&data_to_hls[0]);
    bool        is_int8;
    int8_t     *byte;
    uint32_t    cdp_width_cnt, cdp_channel_cnt;
    bool        cdp_channel_last;
    uint32_t    round_num;
    // Input
    //uint32_t    cdp_width_out, cdp_channel_cnt_out;
    //bool        cdp_channel_last_out;
    int8_t     *rdma_data_ptr;
    CdpConfig   *cfg;
    uint32_t    parallel_num;

    // Copy from register value to local config variables, similar with RTL connection, begin
    // # Cube setting
    cfg = cdp_fifo_cfg_dp_->read();

    cube_width      = cfg->cdp_rdma_width_+1;
    cube_height     = cfg->cdp_rdma_height_+1;
    cube_channel    = cfg->cdp_rdma_channel_+1;
    delete cfg;
    // # Precision setting
    is_int8         = false;
    switch (cdp_input_data_type_) {
        case DATA_FORMAT_IS_INT8: {
            element_per_group_src   = ELEMENT_PER_GROUP_INT8;
            is_int8 = true;
            parallel_num = 8;
            break;
        }
        case DATA_FORMAT_IS_INT16: {
            element_per_group_src   = ELEMENT_PER_GROUP_INT16;
            parallel_num = 4;
            break;
        }
        case DATA_FORMAT_IS_FP16: {
            element_per_group_src   = ELEMENT_PER_GROUP_FP16;
            cdp_datin_offset_ = 0;
            parallel_num = 4;
            break;
        }
#pragma CTC SKIP
        default: break;
#pragma CTC ENDSKIP
    }

    first_half_calc_buffer = dp_calc_buffer;
    second_half_calc_buffer = dp_calc_buffer + 8*ATOM_CUBE_SIZE;
    surf_num = (cube_channel+element_per_group_src-1) / element_per_group_src;

    surf_iter = 0;
    width_iter = 0;    // width of current stripe
    processed_atom_num = 0;
    hls_out_num_ = 0;
    hls_lookup_num_ = 0;
    round_num = surf_num*ATOM_CUBE_SIZE/8;

    cslInfo(("%s WxHxC=%dx%dx%d, format:%d\n", __FUNCTION__,
                cube_width, cube_height, cube_channel,cdp_input_data_type_));
    cslInfo(("\t surf_num:%d, round_num:%d\n", surf_num, round_num));
    for (line_iter=0; line_iter < cube_height; line_iter++) {
        processed_atom_num = 0;
        atom_num_per_line = cube_width * surf_num;
        while(processed_atom_num < atom_num_per_line) {   // While loop to process the stripes in each line
            // Process a stripe
            cur_calc_buffer = first_half_calc_buffer;   // size of dp_calc_buffer is 8*ATOM_CUBE_SIZE*2
            nxt_calc_buffer = pre_calc_buffer  = second_half_calc_buffer;
            // Copy the first 256B data (may be less than 256B) to cur_calc_buffer
            atom_num = rdma_atom_num_fifo_->read();
            processed_atom_num  += atom_num;
            cslDebug((50, "CDP line_iter=%d processed_atom_num=%d\n", line_iter, processed_atom_num));

            hls_atom_num_fifo_->write(atom_num);
            for (atom_iter = 0; atom_iter < atom_num; atom_iter++) {
                rdma_data_ptr = rdma_fifo_->read();
                memcpy (&cur_calc_buffer[atom_iter*ATOM_CUBE_SIZE], rdma_data_ptr, ATOM_CUBE_SIZE);    // pre_calc_buffer is 8*32*2B
                delete [] rdma_data_ptr;
            }
            for (round_iter=0; round_iter<round_num; round_iter++) {     // Each round produces 8B result from HLS module (in Channel direction)
                for (atom_iter=0; atom_iter<atom_num; atom_iter++) {
                    byte = &cur_calc_buffer[atom_iter*ATOM_CUBE_SIZE];
                    if(round_iter==0) { // First surf, padding the first 8B
                        if (is_int8) {
                            // Each data is 1Byte
                            data_to_hls_i8[0] = data_to_hls_i8[1] =
                                data_to_hls_i8[2] = data_to_hls_i8[3] = (int8_t)cdp_datin_offset_;
                            memcpy(&data_to_hls_i8[4], byte, 12);
                        } else {
                            // Each data is 2Bytes
                            data_to_hls[0] = data_to_hls[1] =
                                data_to_hls[2] = data_to_hls[3] = cdp_datin_offset_;
                            memcpy(&data_to_hls[4], byte, 16);
                        }
                    }
                    else if(round_iter==(round_num-1)) { // Last round of last surf. Padding the last 8B
                        if (is_int8) {
                            memcpy(data_to_hls_i8, &byte[16+4], 12);
                            data_to_hls_i8[12] = data_to_hls_i8[13] =
                                data_to_hls_i8[14] = data_to_hls_i8[15] = (int8_t)cdp_datin_offset_;
                        } else {
                            // Each data is 2Bytes
                            memcpy(data_to_hls, &byte[16], 16);
                            data_to_hls[8] = data_to_hls[9] =
                                data_to_hls[10] = data_to_hls[11] = cdp_datin_offset_;
                        }
                    }
                    else if((round_iter%4)==1 || (round_iter%4)==2) {
                        if (is_int8) {
                            memcpy(data_to_hls_i8, &byte[((round_iter%4)-1)*8 + 4], 16);
                        } else {
                            memcpy(data_to_hls, &byte[((round_iter%4)-1)*8], 24);
                        }
                    }
                    else if(round_iter%4==0) {
                        if(cdp_sqsum_bypass_ && atom_iter==0) {
                            // Copy from rdma_fifo_ to nxt buffer
                            nxt_atom_num = rdma_atom_num_fifo_->read();
                            processed_atom_num  += nxt_atom_num;
                            cslDebug((50, "CDP line_iter=%d processed_atom_num=%d\n", line_iter, processed_atom_num));
#pragma CTC SKIP
                            if(nxt_atom_num!=atom_num) {
                                FAIL((("atom_num should be same in same stripe. atom_num=%d, nxt_atom_num=%d"), atom_num, nxt_atom_num));
                            }
#pragma CTC ENDSKIP
                            hls_atom_num_fifo_->write(nxt_atom_num);
                            for (nxt_atom_iter = 0; nxt_atom_iter < nxt_atom_num; nxt_atom_iter++) {
                                rdma_data_ptr = rdma_fifo_->read();
                                memcpy (&cur_calc_buffer[nxt_atom_iter*ATOM_CUBE_SIZE], rdma_data_ptr, ATOM_CUBE_SIZE);    // pre_calc_buffer is 8*32*2B
                                delete [] rdma_data_ptr;
                            }
                        }
                        if (is_int8) {
                            memcpy(data_to_hls_i8, &pre_calc_buffer[atom_iter*ATOM_CUBE_SIZE + 24 + 4], 4);
                            memcpy(&data_to_hls_i8[4], byte, 12);
                        } else {
                            memcpy(data_to_hls, &pre_calc_buffer[atom_iter*ATOM_CUBE_SIZE + 24], 8);
                            memcpy(&data_to_hls[4], byte, 16);
                        }
                        
                    }
                    else if((round_iter%4)==3) {
                        // Last round, but not the last round of the last surf
                        if(!cdp_sqsum_bypass_ && atom_iter==0) {
                            // Copy from rdma_fifo_ to nxt buffer
                            nxt_atom_num = rdma_atom_num_fifo_->read();
                            processed_atom_num  += nxt_atom_num;
                            cslDebug((50, "CDP line_iter=%d processed_atom_num=%d\n", line_iter, processed_atom_num));
#pragma CTC SKIP
                            if(nxt_atom_num!=atom_num) {
                                FAIL((("atom_num should be same in same stripe. atom_num=%d, nxt_atom_num=%d"), atom_num, nxt_atom_num));
                            }
#pragma CTC ENDSKIP
                            hls_atom_num_fifo_->write(nxt_atom_num);
                            for (nxt_atom_iter = 0; nxt_atom_iter < nxt_atom_num; nxt_atom_iter++) {
                                rdma_data_ptr = rdma_fifo_->read();
                                memcpy (&nxt_calc_buffer[nxt_atom_iter*ATOM_CUBE_SIZE], rdma_data_ptr, ATOM_CUBE_SIZE);    // pre_calc_buffer is 8*32*2B
                                delete [] rdma_data_ptr;
                            }
                        }
                        if (is_int8) {
                            memcpy(data_to_hls_i8, &byte[16+4], 12);
                            memcpy(&data_to_hls_i8[12], &nxt_calc_buffer[atom_iter*ATOM_CUBE_SIZE], 4);
                        } else {
                            memcpy(data_to_hls, &byte[16], 16);
                            memcpy(&data_to_hls[8], &nxt_calc_buffer[atom_iter*ATOM_CUBE_SIZE], 8);
                        }
                        if(atom_iter==(atom_num-1)) {   // The last atom of current round in current stripe
                            // Shift pointers cur_calc_buffer, pre_calc_buffer, nxt_calc_buffer
                            cur_calc_buffer = (cur_calc_buffer==first_half_calc_buffer)? second_half_calc_buffer: first_half_calc_buffer;
                            pre_calc_buffer = (pre_calc_buffer==first_half_calc_buffer)? second_half_calc_buffer: first_half_calc_buffer;
                            nxt_calc_buffer = pre_calc_buffer;
                        }
                    }
                    //garbage in left padding
                    if ((round_iter+0)*parallel_num > cube_channel) {
                        int garbage_element_num = std::min((round_iter+0)*parallel_num - cube_channel, (uint32_t)4);
                        int valid_element_num = 4 - garbage_element_num;
                        if (is_int8) {
                            for(int i = 0; i < garbage_element_num; i++) {
                                data_to_hls_i8[0 + valid_element_num + i] = (int8_t)cdp_datin_offset_;
                            }
                        } else {
                            for(int i = 0; i < garbage_element_num; i++) {
                                data_to_hls[0 + valid_element_num + i] = cdp_datin_offset_;
                            }
                        }
                    }
                    //garbage in current data
                    if ((round_iter+1)*parallel_num > cube_channel) {
                        int garbage_element_num = std::min((round_iter+1)*parallel_num - cube_channel, parallel_num);
                        int valid_element_num = parallel_num - garbage_element_num;
                        if (is_int8) {
                            for(int i = 0; i < garbage_element_num; i++) {
                                data_to_hls_i8[4 + valid_element_num + i] = (int8_t)cdp_datin_offset_;
                            }
                        } else {
                            for(int i = 0; i < garbage_element_num; i++) {
                                data_to_hls[4 + valid_element_num + i] = cdp_datin_offset_;
                            }
                        }
                    }
                    //garbage in right padding
                    if ((round_iter+2)*parallel_num > cube_channel) {
                        int garbage_element_num = std::min((round_iter+2)*parallel_num - cube_channel, parallel_num);
                        int valid_element_num = parallel_num - garbage_element_num;
                        if (is_int8) {
                            for(int i = 0; i < 4 - valid_element_num; i++) {
                                data_to_hls_i8[4 + parallel_num + valid_element_num + i] = (int8_t)cdp_datin_offset_;
                            }
                        } else {
                            for(int i = 0; i < 4 - valid_element_num; i++) {
                                data_to_hls[4 + parallel_num + valid_element_num + i] = cdp_datin_offset_;
                            }
                        }
                    }

                    cdp_width_cnt   = width_iter + atom_iter;
                    cdp_channel_cnt = surf_iter*ATOM_CUBE_SIZE/8;  // Each channel is 8B. Each surf is 32B.

                    if(cdp_channel_cnt==(surf_num-1)*ATOM_CUBE_SIZE/8)
                        cdp_channel_last = true;
                    else
                        cdp_channel_last = false;

                    hls_lookup_num_++;
                    cslDebug((70, "cdp_width_cnt=%d cdp_channel_cnt=%d cdp_channel_last=%d round_iter=%d data_to_hls:\n",
                                cdp_width_cnt, cdp_channel_cnt, cdp_channel_last, round_iter));
                    if(is_int8)
                    {
                        for(int i=0;i<16;i++) {
                            cslDebug((70, " %02x", data_to_hls_i8[i] & 0xff));
                        }
                    }
                    else
                    {
                        for(int i=0;i<12;i++) {
                            cslDebug((70, " %04x", data_to_hls[i] & 0xffff));

                            if(cdp_input_data_type_ == DATA_FORMAT_FP16)
                            {
                                uint32_t exp = (data_to_hls[i] >> 10) & 0x1f;
                                uint32_t frac = data_to_hls[i] & 0x3ff;
                                if(cdp_nan_to_zero_ && exp == 0x1f && frac != 0) data_to_hls[i] = 0; //nan flush to zero
                            }
                        }
                    }
                    cslDebug((70, "\n"));

                    if (is_int8) {
                        normalz_out_int8 = new int8_t[8];
                        lookup_lut_int8(data_to_hls_i8, 8);
                        hls_out_fifo_->write((int16_t*)normalz_out_int8);    //8B
                        cslDebug((50, "normalz_out:"));
                        for(int i=0;i<8;i++) {
                            cslDebug((50, " %04x", normalz_out_int8[i]));
                        }
                        cslDebug((50, "\n"));
                    } else {
                        normalz_out = new int16_t[4];
                        lookup_lut(data_to_hls, 4);
                        hls_out_fifo_->write(normalz_out);    //8B
                        cslDebug((50, "normalz_out:"));
                        for(int i=0;i<4;i++) {
                            if(cdp_input_data_type_ == DATA_FORMAT_IS_FP16)
                            {
                                uint32_t exp = (normalz_out[i] >> 10) & 0x1f;
                                uint32_t frac = normalz_out[i] & 0x3ff;
                                if(exp == 0x1f && frac != 0)
                                {
                                    nan_output_num++;
                                }
                            }
                            cslDebug((50, " %04x", normalz_out[i]));
                        }
                        cslDebug((50, "\n"));
                    }
                    hls_out_num_++;

                    cslDebug((50, "hls_lookup_num_=%d\n", hls_lookup_num_));
                    cslDebug((50, "hls_out_num_=%d\n", hls_out_num_));
                    
                    cslDebug((50, "\n"));
                } // atom_iter
            } // round_iter

            // Finished processing one stripe (last surf in stripe)
            if (surf_iter == (surf_num-1)) {
                surf_iter = 0;
                if ((width_iter + atom_num) == cube_width) {
                    width_iter = 0;
                }
                else
                    width_iter += atom_num;
            }
            else
                surf_iter++;
        } // stripe iter
    } // line_iter

    cslInfo(("%s finished process of current layer\n", __FUNCTION__));
}

void NV_NVDLA_cdp::CdpWdmaWriteSequenceThread () {
    // Varialbes
    // Wait kick off event
    while (true) {
        wait(cdp_kickoff_);

        CdpWdmaOrdinarySequence();
    }
}

#pragma CTC SKIP
void NV_NVDLA_cdp::CdpWdmaReadphileSequence() {
    CdpWdmaSequence();
}

void NV_NVDLA_cdp::CdpWdmaWritephileSequence() {
}
#pragma CTC ENDSKIP

void NV_NVDLA_cdp::CdpWdmaOrdinarySequence() {
    CdpWdmaSequence();
}

void NV_NVDLA_cdp::CdpWdmaSequence() {
    // Config variables, they have corresponding value in registers
    uint32_t    cube_width, cube_height, cube_channel;
    uint64_t    dst_base_addr;
    uint64_t    line_stride;
    uint64_t    surface_stride;
    uint8_t     element_per_group_dst;
    // Control variables
    // # Iterators
    uint32_t    width_iter;
    uint32_t    surf_iter;
    uint32_t    surf_num;
    uint32_t    line_iter;
    uint32_t    atom_iter;
    uint32_t    atom_num;
    uint32_t    total_atom_num;
    uint32_t    sent_atom_num;
    uint32_t    round_iter;
    uint32_t    round_num;
    // # Evaluated variable
    uint64_t    payload_addr;
    bool        is_required_ack=false;

    uint32_t    element_data_index;
    int16_t    *hls_element;
    uint8_t     *payload_data_ptr;
    CdpConfig   *cfg;

    cslInfo(("NV_NVDLA_cdp::CdpWdmaSequence, start.\n"));
    // Copy from register value to local config variables, similar with RTL connection, begin
    // # Cube setting
    cfg = cdp_fifo_cfg_wdma_->read();

    cube_width      = cfg->cdp_rdma_width_+1;
    cube_height     = cfg->cdp_rdma_height_+1;
    cube_channel    = cfg->cdp_rdma_channel_+1;
    line_stride     = cdp_dst_line_stride_ << 5;
    surface_stride  = cdp_dst_surface_stride_ << 5;
    dst_base_addr   = ((uint64_t)cdp_dst_base_addr_high_ << 32) | ((uint64_t)cdp_dst_base_addr_low_ << 5);

    delete cfg;
    // # Precision setting
    switch (cdp_input_data_type_) {
        case DATA_FORMAT_IS_INT8: {
                element_per_group_dst   = ELEMENT_PER_GROUP_INT8;
                break;
        }
        case DATA_FORMAT_IS_INT16: {
                element_per_group_dst   = ELEMENT_PER_GROUP_INT16;
                break;
        }
        case DATA_FORMAT_IS_FP16: {
                element_per_group_dst   = ELEMENT_PER_GROUP_FP16;
                break;
        }
#pragma CTC SKIP
        default: break;
#pragma CTC ENDSKIP
    }

    surf_num         = (cube_channel+element_per_group_dst-1)/element_per_group_dst;
    total_atom_num = cube_width * cube_height * surf_num;
    cslDebug((30, "%s: WxHxC=%dx%dx%d, total_atoms=%d\n", __FUNCTION__, cube_width, cube_height, cube_channel, total_atom_num));

    surf_iter = 0;
    line_iter = 0;
    width_iter = 0;    // width of current stripe
    sent_atom_num = 0;
    while(sent_atom_num < total_atom_num) {
        atom_num = hls_atom_num_fifo_->read();
        round_num = atom_num * 4;           // each atom has 4 rounds

        payload_addr = dst_base_addr + surf_iter * surface_stride + line_iter * line_stride + width_iter*ATOM_CUBE_SIZE;

        // Prepare payload
        cslDebug((30, "NV_NVDLA_cdp::SendDmaWriteRequest, begin. total_atom_num=%d sent_atom_num=%d atom_num=%d payload_addr=0x%lx\n", total_atom_num, sent_atom_num, atom_num, payload_addr));
        dma_wr_req_cmd_payload_->pd.dma_write_cmd.addr = payload_addr;
        dma_wr_req_cmd_payload_->pd.dma_write_cmd.size = atom_num-1;
        payload_data_ptr = reinterpret_cast <uint8_t  *>  (dma_wr_req_data_payload_->pd.dma_write_data.data);

        if ((sent_atom_num + atom_num) == total_atom_num)  // The last write request of the Cube
        {
            is_required_ack = true;
            cslDebug((30, "CDP is_required_ack=true\n"));
        }

        // Send write command
        txn_w++;
        cslDebug((50, "CdpWdmaSequence SendDmaWriteRquest cmd payload_addr=0x%lx payload_atom_num=%d txn=%d required_ack=%d\n", payload_addr, atom_num, txn_w, is_required_ack));
        SendDmaWriteRequest(dma_wr_req_cmd_payload_, dma_delay_, cdp_dst_ram_type_, is_required_ack);
        cslDebug((50, "CdpWdmaSequence SendDmaWriteRquest cmd done\n"));
        
        for (round_iter = 0; round_iter < round_num; round_iter++) {
            hls_element = hls_out_fifo_->read();    //8B
            int round_x = round_iter%atom_num;
            int round_y = round_iter/atom_num;

            element_data_index = round_x*ATOM_CUBE_SIZE + round_y*8;

            memcpy(&post_calc_buffer[element_data_index], hls_element, 8);     // Max size of payload_data_ptr is 256B
            delete [] hls_element;
        }

        // Send write data
        for (atom_iter=0; atom_iter<atom_num; atom_iter++) {
            memcpy(&payload_data_ptr[(atom_iter%2)*ATOM_CUBE_SIZE], &post_calc_buffer[atom_iter*ATOM_CUBE_SIZE], ATOM_CUBE_SIZE);
            if (((atom_iter%2)==1) || atom_iter==(atom_num-1)) {
                // Send write data
                cslDebug((50, "CdpWdmaSequence SendDmaWriteRquest data txn=%d atom_iter=%d\n", txn_w, atom_iter));
                SendDmaWriteRequest(dma_wr_req_data_payload_, dma_delay_, cdp_dst_ram_type_);
                cslDebug((50, "CdpWdmaSequence SendDmaWriteRquest data done\n"));
            }
        }

        if(is_required_ack) cdp_done_.notify();

        if (surf_iter == (surf_num-1)) {
            surf_iter = 0;
            if ((width_iter + atom_num) == cube_width) {
                width_iter = 0;
                line_iter++;
            }
            else
                width_iter += atom_num;
        }
        else
            surf_iter++;

        sent_atom_num += atom_num;
    }
    cslInfo(("%s finished current layer\n", __FUNCTION__));
}

#pragma CTC SKIP
void NV_NVDLA_cdp::WaitUntilRdmaFifoFreeSizeGreaterThan(uint32_t num) {
    while (uint32_t(rdma_fifo_->num_free()) < num) {
        wait( rdma_fifo_->data_read_event() );
    }
}

void NV_NVDLA_cdp::WaitUntilRdmaFifoAvailableSizeGreaterThan(uint32_t num) {
    while (uint32_t(rdma_fifo_->num_available()) < num) {
        wait( rdma_fifo_->data_written_event() );
    }
}

void NV_NVDLA_cdp::WaitUntilWdmaBufferFreeSizeGreaterThan(uint32_t num) {
//    while (uint32_t(wdma_buffer_->num_free()) < num) {
//        wait( wdma_buffer_->data_read_event() );
//    }
}

void NV_NVDLA_cdp::WaitUntilWdmaBufferAvailableSizeGreaterThan(uint32_t num) {
//    while (uint32_t(wdma_buffer_->num_available()) < num) {
//        wait( wdma_buffer_->data_written_event() );
//    }
}
#pragma CTC ENDSKIP

// Send DMA read request
void NV_NVDLA_cdp::SendDmaReadRequest(nvdla_dma_rd_req_t* payload, sc_time& delay, uint8_t src_ram_type) {
    cslDebug((50, "NV_NVDLA_cdp::SendDmaReadRequest, start.\n"));
    if ( (NVDLA_CDP_RDMA_D_SRC_DMA_CFG_0_SRC_RAM_TYPE_MC) == src_ram_type ) {
        NV_NVDLA_cdp_base::cdp2mcif_rd_req_b_transport(payload, dma_delay_);
    } else {
        NV_NVDLA_cdp_base::cdp2cvif_rd_req_b_transport(payload, dma_delay_);
    }
    cslDebug((50, "NV_NVDLA_cdp::SendDmaReadRequest, end.\n"));
}

void NV_NVDLA_cdp::ExtractRdmaResponsePayload(nvdla_dma_rd_rsp_t* payload){
    // Extract data from payload
    // Each payload is 64 byte, two mask bit tells which 32 byte groups are effective
    uint8_t *payload_data_ptr;
    int8_t *rdma_atom_cube_ptr;
    uint8_t mask;
    cslDebug((50, "NV_NVDLA_cdp::ExtractRdmaResponsePayload, get a dma read response payload\n"));
    mask = payload->pd.dma_read_data.mask;
    payload_data_ptr    = reinterpret_cast <uint8_t *> (payload->pd.dma_read_data.data);

#pragma CTC SKIP
    if (mask==0x2) {    // First 32B is not effective, second 32B is effective
        FAIL(("NV_NVDLA_cdp::ExtractRdmaResponsePayload, mask==2 is unexcepted"));
    }
#pragma CTC ENDSKIP

    // Handling lower 32 bytes
    if (0 != (mask & 0x1)) {
        rdma_atom_cube_ptr = new int8_t[ATOM_CUBE_SIZE]; 
        memcpy(rdma_atom_cube_ptr, payload_data_ptr, ATOM_CUBE_SIZE);
        rdma_fifo_->write(rdma_atom_cube_ptr);
        txn_r++;
        
        if(cdp_input_data_type_ == DATA_FORMAT_IS_FP16)
        {
            uint16_t *ptr = reinterpret_cast <uint16_t *> (rdma_atom_cube_ptr);

            for(int i=0;i<16;i++)
            {
                uint32_t exp = (ptr[i] >> 10) & 0x1f;
                uint32_t frac = ptr[i] & 0x3ff;

                if(exp == 0x1f)
                {
                    if(frac == 0)
                        inf_input_num++;
                    else
                        nan_input_num++;
                }
            }
        }

        cslDebug((70, "write to rdma_buffer. mask A\n"));
        for(int i=0;i<32;i++)
        {
            cslDebug((70, "%02x ", rdma_atom_cube_ptr[i]));
        }
        cslDebug((70, "\n"));
    }

    // Handling upper 32 bytes
    if (0 != (mask & 0x2)) {
        rdma_atom_cube_ptr = new int8_t[ATOM_CUBE_SIZE]; 
        memcpy(rdma_atom_cube_ptr, &payload_data_ptr[ATOM_CUBE_SIZE], ATOM_CUBE_SIZE);
        rdma_fifo_->write(rdma_atom_cube_ptr);
        txn_r++;

        if(cdp_input_data_type_ == DATA_FORMAT_IS_FP16)
        {
            uint16_t *ptr = reinterpret_cast <uint16_t *> (rdma_atom_cube_ptr);

            for(int i=0;i<16;i++)
            {
                uint32_t exp = (ptr[i] >> 10) & 0x1f;
                uint32_t frac = ptr[i] & 0x3ff;

                if(exp == 0x1f)
                {
                    if(frac == 0)
                        inf_input_num++;
                    else
                        nan_input_num++;
                }
            }
        }

        cslDebug((70, "write to rdma_buffer. mask B\n"));
        for(int i=0;i<32;i++)
        {
            cslDebug((70, "%02x ", rdma_atom_cube_ptr[i]));
        }
        cslDebug((70, "\n"));
    }

    cslDebug((50, "NV_NVDLA_cdp::ExtractRdmaResponsePayload, txn=%d, atom_iter=%d\n", txn_r / 8, txn_r % 8));
}

void NV_NVDLA_cdp::mcif2cdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    ExtractRdmaResponsePayload(payload);
}

void NV_NVDLA_cdp::cvif2cdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time&){
    ExtractRdmaResponsePayload(payload);
}

void NV_NVDLA_cdp::SendDmaWriteRequest(nvdla_dma_wr_req_t* payload, sc_time& delay, uint8_t dst_ram_type,bool ack_required) {
    if ( (NVDLA_CDP_D_DST_DMA_CFG_0_DST_RAM_TYPE_MC) == dst_ram_type) {
        if (TAG_CMD == payload->tag) {
            if (ack_required) {
                payload->pd.dma_write_cmd.require_ack = 1;
            } else {
                payload->pd.dma_write_cmd.require_ack = 0;
            }
        }
        NV_NVDLA_cdp_base::cdp2mcif_wr_req_b_transport(payload, dma_delay_);
    } else {
        if (TAG_CMD == payload->tag) {
            if (ack_required) {
                payload->pd.dma_write_cmd.require_ack = 1;
            } else {
                payload->pd.dma_write_cmd.require_ack = 0;
            }
        }
        NV_NVDLA_cdp_base::cdp2cvif_wr_req_b_transport(payload, dma_delay_);
    }

    if (ack_required) {
        cdp_ack_info *ack = new cdp_ack_info;
        ack->is_mc = cdp_dst_ram_type_ == NVDLA_CDP_D_DST_DMA_CFG_0_DST_RAM_TYPE_MC;
        ack->group_id = cdp_consumer_;
        cdp_ack_fifo_->write(ack);
        //cdp_done_.notify();
    }
}

void NV_NVDLA_cdp::WriteResponseThreadMc() {
    cslInfo(("NV_NVDLA_cdp::WriteResponseThreadMc is called\n"));
    if ( true == mcif2cdp_wr_rsp.read() ) {
#if 0
        if (NVDLA_CDP_D_DST_DMA_CFG_0_DST_RAM_TYPE_MC != cdp_dst_ram_type_) {
            FAIL(("NV_NVDLA_cdp::WriteResponseThreadMc, dst config is not MC"));
        }
#endif
        is_mc_ack_done_ = true;
        cdp_mc_ack_.notify();
    }
}

void NV_NVDLA_cdp::WriteResponseThreadCv() {
    cslInfo(("NV_NVDLA_cdp::WriteResponseThreadCv is called\n"));
    if ( true == cvif2cdp_wr_rsp.read() ) {
#if 0
        if (NVDLA_CDP_D_DST_DMA_CFG_0_DST_RAM_TYPE_MC == cdp_dst_ram_type_) {
            FAIL(("NV_NVDLA_cdp::WriteResponseThreadCv, dst config is not CV_SRAM"));
        }
#endif
        is_cv_ack_done_ = true;
        cdp_cv_ack_.notify();
    }
}

#pragma CTC SKIP
uint16_t NV_NVDLA_cdp::read_lut() {
    int16_t tmp;
    tmp = read_lut(cdp_lut_table_idx, cdp_lut_entry_idx);  //cdp_lut_table_idx=0: read raw; cdp_lut_table_idx=1: read density
    cslDebug((30, "CDP read_lut: cdp_lut_table_idx=%d cdp_lut_entry_idx=%d cdp_lut_data=%d\n", cdp_lut_table_idx, cdp_lut_entry_idx, tmp));
    return tmp;
}
#pragma CTC ENDSKIP

void NV_NVDLA_cdp::write_lut() {
    cslDebug((30, "CDP write_lut: cdp_lut_table_idx=%d cdp_lut_entry_idx=%d cdp_lut_data=%d\n", cdp_lut_table_idx, cdp_lut_entry_idx, cdp_lut_data));
    write_lut(cdp_lut_table_idx, cdp_lut_entry_idx, cdp_lut_data);  //cdp_lut_table_idx=0: write raw; cdp_lut_table_idx=1: write density
}

#pragma CTC SKIP
uint16_t NV_NVDLA_cdp::read_lut(uint32_t lut_table_idx, uint32_t addr)
{
    uint16_t lut_rd;
    if(lut_table_idx) {  // 1: density, 0: raw
        lut_rd = density_lut[addr];
    } else {
        lut_rd = raw_lut[addr];
    }

    return lut_rd;
}
#pragma CTC ENDSKIP

void NV_NVDLA_cdp::write_lut(uint32_t lut_table_idx, uint32_t addr, uint32_t value)
{
    if(lut_table_idx) {  // 1: density, 0: raw
        density_lut[addr] = (uint16_t)value;
    } else {
        raw_lut[addr]     = (uint16_t)value;
    }
}

int64_t NV_NVDLA_cdp::convert(int64_t value, int shift, int bits, bool is_sign)
{
    int64_t max, min;
    uint8_t is_positive;
    int64_t out;
    int64_t one = 1;
    double value_f = value;
    uint64_t value_f_tmp;
    int32_t exp;
/*
    max = is_sign ? (one<<(bits-1))-1 : (one<<bits)-1;
    min = is_sign ? -(one<<(bits-1)):0;
    is_positive = is_sign ? (value_f>0) : true;
    value_f = value_f/pow(2, shift);
    out = is_positive ? (value_f + 0.5) : (value_f - 0.5);

    uint64_t value_f_tmp = *(uint64_t *)&value_f;
    int32_t exp = ((value_f_tmp >> 52) & 0x7ff) - 1023;
*/
    if(is_sign)
    {
        max = (one << (bits - 1)) - 1;
        min =-(one << (bits - 1));
        is_positive = (value_f > 0);
        value_f = value_f / pow(2, shift);
        out = is_positive ? (value_f + 0.5) : (value_f - 0.5);

        value_f_tmp = *(uint64_t *)&value_f;
        exp = ((value_f_tmp >> 52) & 0x7ff) - 1023;

        if(exp > 62)
        {
            out = is_positive ? ((one << 63) - 1) : (one << 63);
        }
    }
#pragma CTC SKIP
    else
    {
        max = (one << bits) - 1;
        min = 0;
        is_positive = true;
        value_f = value_f / pow(2, shift);
        out = is_positive ? (value_f + 0.5) : (value_f - 0.5);

        value_f_tmp = *(uint64_t *)&value_f;
        exp = ((value_f_tmp >> 52) & 0x7ff) - 1023;

        if(exp > 63)
        {
            out = 0xffffffffffffffff;
        }
    }
#pragma CTC ENDSKIP

    //printf("exp=%d, out_tmp=0x%lx\n", exp, (uint64_t)out);

    if (out > max) {
        out = max;
    } else if (out < min) {
        out = min;
    }

    //printf("value=0x%lx, bits=%d, max=0x%lx, min=0x%lx, value_f=%lf, out=0x%lx\n", (uint64_t)value, bits, (uint64_t)max, (uint64_t)min, value_f, (uint64_t)out);

    return out;
}

#define INTERP_INTERMIDIATE_BITS 56
#define INTERP_INTERMIDIATE_BITS_INT8 56
void NV_NVDLA_cdp::lookup_lut_int8(int8_t *data_in, int parallel_num)
{
    int i, j;
    bool le_hit = false;
    bool lo_hit = false;

    // Configurations
    uint16_t normalz_len;
    uint16_t raw_method;
    bool     lut_uflow_priority;
    bool     lut_oflow_priority;
    bool     lut_hybrid_priority;
    int64_t raw_start;
    int32_t raw_frac_bits;
    int64_t density_start;
    int32_t density_frac_bits;
    int8_t   le_index_offset;
    int64_t raw_end;
    int64_t density_end;
    int16_t  le_slope_uflow_scale;
    int16_t  le_slope_oflow_scale;
    int16_t  lo_slope_uflow_scale;
    int16_t  lo_slope_oflow_scale;
    sc_int<8> cvt_in_offset;
    sc_int<5> shift;
    sc_int<16> cvt_in_scale;
    sc_uint<5> cvt_in_shifter;
    sc_int<32> cvt_out_offset;
    sc_int<16> cvt_out_scale;
    sc_uint<6> cvt_out_shifter;

    sc_int<9> data_cvt_in_2[16];
    sc_int<26> data_cvt_in_3[16];
    sc_int<22> square_sum;
    int16_t    log_sum;
    int16_t    index;

    int16_t    result_raw_0, result_raw_1;
    int64_t    offset_raw_1;
    int64_t    raw_index_tmp, raw_index;
    int64_t    result_raw;
    int16_t    result_density_0, result_density_1;
    int64_t    offset_density_1;
    int64_t    density_index_tmp, density_index;
    int64_t    result_density;

    sc_int<16> lut_result;

    sc_int<25> data_cvt_out_0[8];

    bool       le_underflow;
    bool       le_overflow;
    bool       lo_underflow;
    bool       lo_overflow;
    uint32_t    high;

    // Configure registers
    normalz_len     = cdp_normalz_len_;
    raw_method      = cdp_lut_le_function_;
    lut_uflow_priority = cdp_lut_uflow_priority_;   //0: select LE; 1: select LO
    lut_oflow_priority = cdp_lut_oflow_priority_;
    lut_hybrid_priority = cdp_lut_hybrid_priority_;
    high            = cdp_lut_le_start_high_ & (0x1 << 5) ? (cdp_lut_le_start_high_ | 0xFFFFFFC0):cdp_lut_le_start_high_;
    raw_start       = ((int64_t)high << 32) | cdp_lut_le_start_low_;
    high            = cdp_lut_le_end_high_ & (0x1 << 5) ? (cdp_lut_le_end_high_ | 0xFFFFFFC0):cdp_lut_le_end_high_;
    raw_end         = ((int64_t)high << 32) | cdp_lut_le_end_low_;
    raw_frac_bits   = cdp_lut_le_index_select_ & (0x1 << 5) ? (cdp_lut_le_index_select_ | 0xFFFFFFC0):cdp_lut_le_index_select_;
    high            = cdp_lut_lo_start_high_ & (0x1 << 5) ? (cdp_lut_lo_start_high_ | 0xFFFFFFC0):cdp_lut_lo_start_high_;
    density_start   = ((int64_t)high << 32) | cdp_lut_lo_start_low_;
    high            = cdp_lut_lo_end_high_ & (0x1 << 5) ? (cdp_lut_lo_end_high_ | 0xFFFFFFC0):cdp_lut_lo_end_high_;
    density_end     = ((int64_t)high << 32) | cdp_lut_lo_end_low_;
    density_frac_bits  = cdp_lut_lo_index_select_ & (0x1 << 5) ? (cdp_lut_lo_index_select_ | 0xFFFFFFC0):cdp_lut_lo_index_select_;
    le_index_offset = (int8_t)(cdp_lut_le_index_offset_);
    le_slope_uflow_scale = (int16_t)cdp_lut_le_slope_uflow_scale_;
    le_slope_oflow_scale = (int16_t)cdp_lut_le_slope_oflow_scale_;
    lo_slope_uflow_scale = (int16_t)cdp_lut_lo_slope_uflow_scale_;
    lo_slope_oflow_scale = (int16_t)cdp_lut_lo_slope_oflow_scale_;
    cvt_in_offset   = sc_int<8>(cdp_datin_offset_);
    cvt_in_scale    = sc_int<16>(cdp_datin_scale_);
    cvt_in_shifter  = sc_uint<5>(cdp_datin_shifter_);
    cvt_out_offset  = sc_int<25>(cdp_datout_offset_&0x1ffffff);
    cvt_out_scale   = sc_int<16>(cdp_datout_scale_);
    cvt_out_shifter = sc_uint<5>(cdp_datout_shifter_);

#pragma CTC SKIP
    assert(cdp_input_data_type_ == NVDLA_CDP_D_DATA_FORMAT_0_INPUT_DATA_TYPE_INT8);
    assert(parallel_num == 8);
#pragma CTC ENDSKIP

    // Input Converter
    for(i=0; i<(parallel_num+8)/2; i++) {
        //***** HLS Input Convertor (INT16->INT17) ******
        int32_t data_cvt_in_2_tmp;
        int16_t in = ((int16_t)data_in[i*2+1] << 8) | (data_in[i*2] & 0xff);
        cdp_icvt_hls(&in, cdp_datin_offset_, cdp_datin_scale_,
               cdp_datin_shifter_, cdp_input_data_type_, &data_cvt_in_2_tmp);
        data_cvt_in_2[i*2+0] = (data_cvt_in_2_tmp & 0x1ff);
        data_cvt_in_2[i*2+1] = ((data_cvt_in_2_tmp>>9) & 0x1ff);
        data_cvt_in_3[i*2+0] = data_cvt_in_2[i*2+0] * data_cvt_in_2[i*2+0];
        data_cvt_in_3[i*2+1] = data_cvt_in_2[i*2+1] * data_cvt_in_2[i*2+1];
    }

    cslDebug((70, "Data after input convertor:\n"));
    for(int i=0;i<parallel_num+8;i++) {
        cslDebug((70," %x",  data_cvt_in_2[i].to_int()));
    }
    cslDebug((70, "\n"));
    cslDebug((70, "Data after square:\n"));
    for(int i=0;i<parallel_num+8;i++) {
        cslDebug((70," %x",  data_cvt_in_3[i].to_int()));
    }
    cslDebug((70, "\n"));


    for(i=0; i<parallel_num; i++) {
        le_underflow     = false;
        le_overflow      = false;
        lo_underflow     = false;
        lo_overflow      = false;
        le_hit           = false;
        lo_hit           = false;
        square_sum = 0;

        // Calculate sum
        if (cdp_sqsum_bypass_) {
            square_sum = data_cvt_in_2[i+4];
        } else {
            for(j=-1*(normalz_len+1);j<=normalz_len+1;j++) {     // normalz_len_cfg (0x0: 3 elements; 0x1: 5 elements; 0x2: 7 elements; 0x3: 9 elements)
                square_sum = square_sum + data_cvt_in_3[i+4+j];
            }
        }
        cslDebug((70, "Square sum: %lx\n",  (uint64_t)square_sum.to_int64() ));

        // Look up Raw table
        if(raw_method==NVDLA_CDP_S_LUT_CFG_0_LUT_LE_FUNCTION_EXPONENT) {    //raw lut is exponential
            int64_t raw_input_temp = square_sum - raw_start;

            if(raw_input_temp <= 0)
                log_sum = 0;
            else
                log_sum = (int16_t)log2(raw_input_temp);       //range: 0~36 for INT16

            index = log_sum - le_index_offset;
            
            cslDebug((70, "LE start=%lx index_offset=%d index=%d sub_result=0x%lx\n", (uint64_t)raw_start, le_index_offset, index, (uint64_t)raw_input_temp));

            if(index < 0 || raw_input_temp <= 0)  {
                int16_t slope = cdp_lut_le_slope_uflow_scale_;
                int64_t le_index_offset_uflow = (le_index_offset < 0)? 0 : ((int64_t)1 << le_index_offset);
                shift = cdp_lut_le_slope_uflow_shift_;
                result_raw = raw_lut[0] + convert((square_sum - raw_start - le_index_offset_uflow)*slope,
                        shift.to_int(),
                        INTERP_INTERMIDIATE_BITS_INT8, true);
                result_raw = convert(result_raw, 0, 16, true);
                le_underflow = true;
            }
            else if(index >= 64) {
                int16_t slope = cdp_lut_le_slope_oflow_scale_;
                le_overflow = true;

                shift = cdp_lut_le_slope_oflow_shift_;
                result_raw = raw_lut[64] + convert((square_sum - raw_end)*slope,
                        shift.to_int(),
                        INTERP_INTERMIDIATE_BITS_INT8, true);
                result_raw = convert(result_raw, 0, 16, true);
            }
            else {
                result_raw_0 = raw_lut[index];
                result_raw_1 = raw_lut[index+1];
                offset_raw_1 = raw_input_temp - ((int64_t)1 << (index+le_index_offset));
#if !ASSERT_WAR_CONSTRAIN
                assert(((int64_t)1 << (index+le_index_offset+1)) >= raw_input_temp);
#endif
                // The precision of offset_raw in RTL is 16bits although higher precision can be kept in CMOD
                if(index+le_index_offset > 16)
                    offset_raw_1 = offset_raw_1 >> (index+le_index_offset - 16);
                else
                    offset_raw_1 = offset_raw_1 << (16 - index - le_index_offset);
                //offset_raw_0 = (1 << 16) - offset_raw_1;
                //result_raw = (result_raw_0*offset_raw_0 + result_raw_1*offset_raw_1);
                result_raw = result_raw_0 + convert((result_raw_1 - result_raw_0) * offset_raw_1, 16, INTERP_INTERMIDIATE_BITS_INT8, true);
                cslDebug((70, "L0=%x L1=%x offset=%lx result=%lx\n", result_raw_0, result_raw_1, (uint64_t)offset_raw_1, (uint64_t)result_raw));
                result_raw = convert(result_raw, 0, 16, true);
                le_hit = true;
            }
        }
        else { // raw lut is linear
#if !ASSERT_WAR_CONSTRAIN
            assert(raw_end - pow(2, cdp_lut_le_index_select_ + 6) == raw_start);
#endif
            raw_index_tmp = square_sum - raw_start;
            if(raw_frac_bits < 0)
            {
                raw_index = raw_index_tmp << -raw_frac_bits;
            }
            else
            {
                raw_index = raw_index_tmp >> raw_frac_bits;
            }

            cslDebug((70, "LE start=%lx index_select=%d index=%ld sub_result=0x%lx\n", (uint64_t)raw_start, raw_frac_bits, raw_index, (uint64_t)raw_index_tmp));

            if (raw_index < 0 || raw_index_tmp <= 0) {
                int16_t slope = le_slope_uflow_scale;
                le_underflow = true;
                shift = cdp_lut_le_slope_uflow_shift_;
                result_raw = raw_lut[0] + convert((square_sum - raw_start)*slope,
                        shift.to_int(), INTERP_INTERMIDIATE_BITS_INT8, true);
                cslDebug((70, "L0=%x start=%lx slope=%x shift=%x result=%lx\n", raw_lut[0], raw_start, slope, shift.to_int(), (uint64_t)result_raw));
                result_raw = convert(result_raw, 0, 16, true);
            }
            else if (raw_index >= 64){
                int16_t slope = le_slope_oflow_scale;
                //le_underflow = true;
                shift = cdp_lut_le_slope_oflow_shift_;
                result_raw = raw_lut[64] + convert((square_sum - raw_end)*slope,
                        shift.to_int(), INTERP_INTERMIDIATE_BITS_INT8, true);
                cslDebug((70, "L64=%x end=%lx slope=%x shift=%x result=%lx\n", raw_lut[64], raw_end, slope, shift.to_int(), (uint64_t)result_raw));
                result_raw = convert(result_raw, 0, 16, true);

                le_overflow = true;
            }
            else {
                result_raw_0 = raw_lut[raw_index];
                result_raw_1 = raw_lut[raw_index+1];
                if(raw_frac_bits < 0)
                {
                    offset_raw_1 = 0;
                }
                else
                {
                    offset_raw_1 = raw_index_tmp % (1 << raw_frac_bits);
                    // The precision of offset is 16bits
                    if(raw_frac_bits > 16)
                        offset_raw_1 = offset_raw_1 >> (raw_frac_bits - 16);
                    else
                        offset_raw_1 = offset_raw_1 << (16 - raw_frac_bits);
                }
                //offset_raw_0 = (1 << 16) - offset_raw_1;
                //result_raw = (result_raw_0*offset_raw_0 + result_raw_1*offset_raw_1);
                result_raw = result_raw_0 + convert((result_raw_1 - result_raw_0) * offset_raw_1, 16, INTERP_INTERMIDIATE_BITS_INT8, true);
                cslDebug((70, "L0=%x L1=%x offset=%lx result=%lx\n", result_raw_0, result_raw_1, (uint64_t)offset_raw_1, (uint64_t)result_raw));
                result_raw = convert(result_raw, 0, 16, true);
                le_hit = true;
            }
        }

        // Look up Density table
#if !ASSERT_WAR_CONSTRAIN
        assert(density_end - pow(2, cdp_lut_lo_index_select_ + 8) == density_start);
#endif
        density_index_tmp = square_sum - density_start;
        if(density_frac_bits < 0)
        {
            density_index = density_index_tmp << -density_frac_bits;
        }
        else
        {
            density_index = density_index_tmp >> density_frac_bits;
        }
            
        cslDebug((70, "LO start=%lx index_select=%d index=%ld sub_result=0x%lx\n", (uint64_t)density_start, density_frac_bits, density_index, (uint64_t)density_index_tmp));

        if (density_index < 0 || density_index_tmp <= 0) {
            int16_t slope = lo_slope_uflow_scale;
            shift = cdp_lut_lo_slope_uflow_shift_;
            result_density = density_lut[0] + convert((square_sum - density_start)*slope,
                    shift.to_int(), INTERP_INTERMIDIATE_BITS_INT8, true);
            result_density = convert(result_density, 0, 16, true);
            lo_underflow = true;
        }
        else if (density_index>=256){
            int16_t slope = lo_slope_oflow_scale;
            shift = cdp_lut_lo_slope_oflow_shift_;
            result_density = density_lut[256] + convert((square_sum - density_end)*slope,
                    shift.to_int(), INTERP_INTERMIDIATE_BITS_INT8, true);
            result_density = convert(result_density, 0, 16, true);
            lo_overflow = true;
        }
        else {
            result_density_0 = density_lut[density_index];
            result_density_1 = density_lut[density_index+1];

            if(density_frac_bits < 0)
            {
                offset_density_1 = 0;
            }
            else
            {
                offset_density_1 = density_index_tmp % (1 << density_frac_bits);
                // The precision of offset is 16bits
                if(density_frac_bits > 16)
                    offset_density_1 = offset_density_1 >> (density_frac_bits - 16);
                else
                    offset_density_1 = offset_density_1 << (16 - density_frac_bits);
            }
            //offset_density_0 = (1 << 16) - offset_density_1;
            //result_density = (result_density_0*offset_density_0 + result_density_1*offset_density_1);
            result_density = result_density_0 + convert((result_density_1 - result_density_0) * offset_density_1, 16, INTERP_INTERMIDIATE_BITS_INT8, true);
            cslDebug((70, "L0=%x L1=%x offset=%lx result=%lx\n", result_density_0, result_density_1, (uint64_t)offset_density_1, (uint64_t)result_density));
            result_density = convert(result_density, 0, 16, true);
            lo_hit = true;
        }

        // Select result between RAW table and Density Table
        if(le_underflow && lo_underflow) {
            lut_result = lut_uflow_priority? result_density: result_raw;
            lut_u_flow++;
        }
        else if(le_overflow && lo_overflow) {
            lut_result = lut_oflow_priority? result_density: result_raw;
            lut_o_flow++;
        }
        else {
            if(le_hit ^ lo_hit) {
                lut_result = le_hit? result_raw: result_density;
                if (le_hit) {
                    lut_le_hit++;
                } else {
                    lut_lo_hit++;
                }
            }
            else {
                if(lut_hybrid_priority)
                    lut_result = result_density;
                else
                    lut_result = result_raw;
                lut_hybrid_hit++;
            }
        }
        
        if (cdp_mul_bypass_) {
            data_cvt_out_0[i] = lut_result;
        } else {
            data_cvt_out_0[i] = lut_result * data_cvt_in_2[i+4];
        }

        cslDebug((70, "le: %lx, lo:%lx, out:%x mul:%x\n" , result_raw, result_density, lut_result.to_int(), data_cvt_out_0[i].to_int() ));
    }

    for(i = 0; i < parallel_num/2; i++) {
        int64_t in = (int64_t)(((int64_t)data_cvt_out_0[i*2+1].to_int()&0x1ffffff) << 25) | ((int64_t)data_cvt_out_0[i*2].to_int()&0x1ffffff);
        int16_t out;
        uint8_t flag;
        cdp_ocvt_hls(&in, cdp_datout_offset_, cdp_datout_scale_,
                cdp_datout_shifter_, cdp_input_data_type_, &out, &flag);
        normalz_out_int8[i*2+0] = (int8_t)((out>>0) & 0xff);
        normalz_out_int8[i*2+1] = (int8_t)((out>>8) & 0xff);

        o_cvt_o_flow += flag&0x1;
        o_cvt_o_flow += (flag>>1)&0x1;
    }
}

#define USE_HLS

// INT16
void NV_NVDLA_cdp::lookup_lut(int16_t *data_in, int parallel_num)
{
    int i, j;
    bool le_hit = false;
    bool lo_hit = false;

    // Configurations
    uint16_t normalz_len;
    uint16_t raw_method;
    bool     lut_uflow_priority;
    bool     lut_oflow_priority;
    bool     lut_hybrid_priority;
    sc_int<38> raw_start;
    int32_t raw_frac_bits;
    sc_int<38> density_start;
    int32_t density_frac_bits;
    int8_t   le_index_offset;
    sc_int<38> raw_end;
    sc_int<38> density_end;
    int16_t  le_slope_uflow_scale;
    int16_t  le_slope_oflow_scale;
    int16_t  lo_slope_uflow_scale;
    int16_t  lo_slope_oflow_scale;
    sc_int<16> cvt_in_offset;
    sc_int<16> cvt_in_scale;
    sc_uint<5> cvt_in_shifter;
    sc_int<32> cvt_out_offset;
    sc_int<16> cvt_out_scale;
    sc_uint<6> cvt_out_shifter;
    sc_int<5> shift;
    // Input data
#ifndef USE_HLS
    sc_int<16> data[12];

    // Variables
    sc_int<17> data_cvt_in_0[12];
    sc_int<33> data_cvt_in_1[12];
    sc_int<33> data_cvt_in_2_tmp[12];
#endif
    sc_int<17> data_cvt_in_2[12];
    sc_uint<33> data_cvt_in_3[12];
    sc_int<38> square_sum;
    int16_t    log_sum;
    int16_t    index;

    int16_t    result_raw_0, result_raw_1;
    int64_t    offset_raw_1;
    int64_t    raw_index_tmp, raw_index;
    int64_t    result_raw;
    int16_t    result_density_0, result_density_1;
    int64_t    offset_density_1;
    int64_t    density_index_tmp, density_index;
    int64_t    result_density;

    sc_int<16> lut_result;

    sc_int<33> data_cvt_out_0[4];
#ifndef USE_HLS
    sc_int<34> data_cvt_out_1[4];
    sc_int<50> data_cvt_out_2[4];
    sc_int<50> data_cvt_out_3_tmp[4];
    sc_int<16> data_cvt_out_3[4];
#endif

    bool       le_underflow;
    bool       le_overflow;
    bool       lo_underflow;
    bool       lo_overflow;
    uint32_t    high;

    // Configure registers
    normalz_len     = cdp_normalz_len_;
    raw_method      = cdp_lut_le_function_;
    lut_uflow_priority = cdp_lut_uflow_priority_;   //0: select LE; 1: select LO
    lut_oflow_priority = cdp_lut_oflow_priority_;
    lut_hybrid_priority = cdp_lut_hybrid_priority_;
    high            = cdp_lut_le_start_high_ & (0x1 << 5) ? (cdp_lut_le_start_high_ | 0xFFFFFFC0):cdp_lut_le_start_high_;
    raw_start       = ((int64_t)high << 32) | cdp_lut_le_start_low_;
    high            = cdp_lut_le_end_high_ & (0x1 << 5) ? (cdp_lut_le_end_high_ | 0xFFFFFFC0):cdp_lut_le_end_high_;
    raw_end         = ((int64_t)high << 32) | cdp_lut_le_end_low_;
    raw_frac_bits   = cdp_lut_le_index_select_ & (0x1 << 6) ? (cdp_lut_le_index_select_ | 0xFFFFFF80):cdp_lut_le_index_select_;
    high            = cdp_lut_lo_start_high_ & (0x1 << 5) ? (cdp_lut_lo_start_high_ | 0xFFFFFFC0):cdp_lut_lo_start_high_;
    density_start   = ((int64_t)high << 32) | cdp_lut_lo_start_low_;
    high            = cdp_lut_lo_end_high_ & (0x1 << 5) ? (cdp_lut_lo_end_high_ | 0xFFFFFFC0):cdp_lut_lo_end_high_;
    density_end     = ((int64_t)high << 32) | cdp_lut_lo_end_low_;
    density_frac_bits  = cdp_lut_lo_index_select_ & (0x1 << 6) ? (cdp_lut_lo_index_select_ | 0xFFFFFF80):cdp_lut_lo_index_select_;
    le_index_offset = (int8_t)(cdp_lut_le_index_offset_);
    le_slope_uflow_scale = (int16_t)cdp_lut_le_slope_uflow_scale_;
    le_slope_oflow_scale = (int16_t)cdp_lut_le_slope_oflow_scale_;
    lo_slope_uflow_scale = (int16_t)cdp_lut_lo_slope_uflow_scale_;
    lo_slope_oflow_scale = (int16_t)cdp_lut_lo_slope_oflow_scale_;
    cvt_in_offset   = sc_int<16>(cdp_datin_offset_);
    cvt_in_scale    = sc_int<16>(cdp_datin_scale_);
    cvt_in_shifter  = sc_uint<5>(cdp_datin_shifter_);
    cvt_out_offset  = sc_int<32>(cdp_datout_offset_);
    cvt_out_scale   = sc_int<16>(cdp_datout_scale_);
    cvt_out_shifter = sc_uint<5>(cdp_datout_shifter_);

    if (DATA_FORMAT_IS_FP16==cdp_input_data_type_) {
        HLS_CDP_lookup_fp16(data_in, raw_lut, density_lut, normalz_len, raw_method, lut_uflow_priority, lut_oflow_priority, lut_hybrid_priority,
                            raw_start.to_int64(), le_index_offset, cdp_lut_le_index_select_, raw_end.to_int64(), density_start.to_int64(), cdp_lut_lo_index_select_, density_end.to_int64(),
                            cdp_datin_offset_, cdp_datin_scale_, cdp_datin_shifter_, cdp_datout_offset_, cdp_datout_scale_, cdp_datout_shifter_,
                            le_slope_uflow_scale, le_slope_oflow_scale, lo_slope_uflow_scale, lo_slope_oflow_scale, cdp_sqsum_bypass_, cdp_mul_bypass_, normalz_out,
			    &lut_u_flow, &lut_o_flow, &lut_le_hit, &lut_lo_hit, &lut_hybrid_hit);
        return;
    }

    // Input Converter
    for(i=0; i<parallel_num+8; i++) {
#ifndef USE_HLS
        data[i] = sc_int<16>(data_in[i]);
        data_cvt_in_0[i] = data[i] - cvt_in_offset;
        data_cvt_in_1[i] = data_cvt_in_0[i] * cvt_in_scale;
        data_cvt_in_2_tmp[i] = data_cvt_in_1[i] >> cvt_in_shifter;

        data_cvt_in_2[i] = convert(data_cvt_in_1[i].to_int64(), cvt_in_shifter.to_int(),
                17, true);
#else
        //***** HLS Input Convertor (INT16->INT17) ******
        int32_t data_cvt_in_2_tmp;
        cdp_icvt_hls(&data_in[i], cdp_datin_offset_, cdp_datin_scale_,
               cdp_datin_shifter_, cdp_input_data_type_, &data_cvt_in_2_tmp);
        data_cvt_in_2[i] = data_cvt_in_2_tmp;
#endif
        data_cvt_in_3[i] = data_cvt_in_2[i] * data_cvt_in_2[i];
    }

    cslDebug((70, "Data after input convertor:\n"));
    for(int i=0;i<12;i++) {
        cslDebug((70," %x",  data_cvt_in_2[i].to_int()));
    }
    cslDebug((70, "\n"));
    cslDebug((70, "Data after square:\n"));
    for(int i=0;i<12;i++) {
        cslDebug((70," %llx",  data_cvt_in_3[i].to_int64()));
    }
    cslDebug((70, "\n"));


    for(i=0; i<4; i++) {
        le_underflow     = false;
        le_overflow      = false;
        lo_underflow     = false;
        lo_overflow      = false;
        le_hit           = false;
        lo_hit           = false;
        square_sum = 0;

        // Calculate sum
        if (cdp_sqsum_bypass_) {
            square_sum = data_cvt_in_2[i+4];
        } else {
            for(j=-1*(normalz_len+1);j<=normalz_len+1;j++) {     // normalz_len_cfg (0x0: 3 elements; 0x1: 5 elements; 0x2: 7 elements; 0x3: 9 elements)
                square_sum = square_sum + data_cvt_in_3[i+4+j];
            }
        }
        cslDebug((70, "Square sum: %lx\n",  (uint64_t)square_sum.to_int64() ));

        // Look up Raw table
        if(raw_method==NVDLA_CDP_S_LUT_CFG_0_LUT_LE_FUNCTION_EXPONENT) {    //raw lut is exponential
            int64_t raw_input_temp = square_sum - raw_start;

            if(raw_input_temp <= 0)
                log_sum = 0;
            else
                log_sum = (int16_t)log2(raw_input_temp);       //range: 0~36 for INT16

            index = log_sum - le_index_offset;

            cslDebug((70, "x=0x%lx, index=%d, log_sum=%d\n", (uint64_t)raw_input_temp, index, log_sum));
        
            if(index < 0 || raw_input_temp <= 0)  {
                int16_t slope = cdp_lut_le_slope_uflow_scale_;
                int64_t le_index_offset_uflow = (le_index_offset < 0)? 0 : ((int64_t)1 << le_index_offset);
                shift = cdp_lut_le_slope_uflow_shift_;
                result_raw = raw_lut[0] + convert((square_sum - raw_start - le_index_offset_uflow)*slope,
                        shift.to_int(),
                        INTERP_INTERMIDIATE_BITS, true);
                result_raw = convert(result_raw, 0, 16, true);
                le_underflow = true;
            }
            else if(index >= 64) {
                int16_t slope = cdp_lut_le_slope_oflow_scale_;
                shift = cdp_lut_le_slope_oflow_shift_;
                le_overflow = true;

                result_raw = raw_lut[64] + convert((square_sum - raw_end)*slope,
                        shift.to_int(),
                        INTERP_INTERMIDIATE_BITS, true);
                result_raw = convert(result_raw, 0, 16, true);
            }
            else {
                result_raw_0 = raw_lut[index];
                result_raw_1 = raw_lut[index+1];
                offset_raw_1 = raw_input_temp - ((int64_t)1 << (index+le_index_offset));
#if !ASSERT_WAR_CONSTRAIN
                assert(((int64_t)1 << (index+le_index_offset+1)) >= raw_input_temp);
#endif
                // The precision of offset_raw in RTL is 16bits although higher precision can be kept in CMOD
                if(index+le_index_offset > 16)
                    offset_raw_1 = offset_raw_1 >> (index + le_index_offset - 16);
                else
                    offset_raw_1 = offset_raw_1 << (16 - index - le_index_offset);
                //offset_raw_0 = (1 << 16) - offset_raw_1;
                //result_raw = (result_raw_0*offset_raw_0 + result_raw_1*offset_raw_1);
                result_raw = result_raw_0 + convert((result_raw_1 - result_raw_0) * offset_raw_1, 16, INTERP_INTERMIDIATE_BITS, true);
                cslDebug((70, "L0=%x L1=%x offset=%lx result=%lx\n", result_raw_0, result_raw_1, (uint64_t)offset_raw_1, (uint64_t)result_raw));
                result_raw = convert(result_raw, 0, 16, true);

                le_hit = true;
            }
        }
        else { // raw lut is linear
#if !ASSERT_WAR_CONSTRAIN
            assert(raw_end - pow(2, cdp_lut_le_index_select_ + 6) == raw_start);
#endif
            raw_index_tmp = square_sum - raw_start;

            if(raw_frac_bits < 0)
            {
                raw_index = raw_index_tmp << -raw_frac_bits;
            }
            else
            {
                raw_index = raw_index_tmp >> raw_frac_bits;
            }
            
            cslDebug((70, "x=0x%lx, index=%ld\n", (uint64_t)raw_index_tmp, raw_index));
        
            if (raw_index < 0 || raw_index_tmp <= 0) {
                int16_t slope = le_slope_uflow_scale;
                shift = cdp_lut_le_slope_uflow_shift_;
                le_underflow = true;
                result_raw = raw_lut[0] + convert((square_sum - raw_start)*slope,
                        shift.to_int(), INTERP_INTERMIDIATE_BITS, true);
                result_raw = convert(result_raw, 0, 16, true);
            }
            else if (raw_index >= 64){
                int16_t slope = le_slope_oflow_scale;
                shift = cdp_lut_le_slope_oflow_shift_;
                //le_underflow = true;
                result_raw = raw_lut[64] + convert((square_sum - raw_end)*slope,
                        shift.to_int(), INTERP_INTERMIDIATE_BITS, true);
                result_raw = convert(result_raw, 0, 16, true);

                le_overflow = true;
            }
            else {
                result_raw_0 = raw_lut[raw_index];
                result_raw_1 = raw_lut[raw_index+1];
                if(raw_frac_bits < 0)
                {
                    offset_raw_1 = 0;
                }
                else
                {
                    offset_raw_1 = raw_index_tmp % (1 << raw_frac_bits);
                    // The precision of offset is 16bits
                    if(raw_frac_bits > 16)
                        offset_raw_1 = offset_raw_1 >> (raw_frac_bits - 16);
                    else
                        offset_raw_1 = offset_raw_1 << (16 - raw_frac_bits);
                }
                //offset_raw_0 = (1 << 16) - offset_raw_1;
                //result_raw = (result_raw_0*offset_raw_0 + result_raw_1*offset_raw_1);
                result_raw = result_raw_0 + convert((result_raw_1 - result_raw_0) * offset_raw_1, 16, INTERP_INTERMIDIATE_BITS, true);
                cslDebug((70, "L0=%x L1=%x offset=%lx result=%lx\n", result_raw_0, result_raw_1, (uint64_t)offset_raw_1, (uint64_t)result_raw));
                result_raw = convert(result_raw, 0, 16, true);

                le_hit = true;
            }
        }

        // Look up Density table
#if !ASSERT_WAR_CONSTRAIN
        assert(density_end - pow(2, cdp_lut_lo_index_select_ + 8) == density_start);
#endif
        density_index_tmp = square_sum - density_start;
        if(density_frac_bits < 0)
        {
            density_index = density_index_tmp << -density_frac_bits;
        }
        else
        {
            density_index = density_index_tmp >> density_frac_bits;
        }
            
        cslDebug((70, "x=0x%lx, index=%ld\n", (uint64_t)density_index_tmp, density_index));
        
        if (density_index < 0 || density_index_tmp <= 0) {
            int16_t slope = lo_slope_uflow_scale;
            shift = cdp_lut_lo_slope_uflow_shift_;
        
            result_density = density_lut[0] + convert((square_sum - density_start)*slope,
                    shift.to_int(), INTERP_INTERMIDIATE_BITS, true);
            
            cslDebug((70, "result_density=0x%lx, L0=0x%x, slope=0x%x, shift=%d\n", (uint64_t)result_density, density_lut[0], slope, shift.to_int() ));

            result_density = convert(result_density, 0, 16, true);
            lo_underflow = true;
        }
        else if (density_index >= 256){
            int16_t slope = lo_slope_oflow_scale;
            shift = cdp_lut_lo_slope_oflow_shift_;
            result_density = density_lut[256] + convert((square_sum - density_end)*slope,
                    shift.to_int(), INTERP_INTERMIDIATE_BITS, true);
            result_density = convert(result_density, 0, 16, true);
            lo_overflow = true;
        }
        else {
            result_density_0 = density_lut[density_index];
            result_density_1 = density_lut[density_index+1];
            if(density_frac_bits < 0)
            {
                offset_density_1 = 0;
            }
            else
            {
                offset_density_1 = density_index_tmp % (1 << density_frac_bits);
                // The precision of offset is 16bits
                if(density_frac_bits > 16)
                    offset_density_1 = offset_density_1 >> (density_frac_bits - 16);
                else
                    offset_density_1 = offset_density_1 << (16 - density_frac_bits);
            }
            //offset_density_0 = (1 << 16) - offset_density_1;
            //result_density = (result_density_0*offset_density_0 + result_density_1*offset_density_1);
            result_density = result_density_0 + convert((result_density_1 - result_density_0) * offset_density_1, 16, INTERP_INTERMIDIATE_BITS, true);
            cslDebug((70, "L0=%x L1=%x offset=%lx result=%lx\n", result_density_0, result_density_1, (uint64_t)offset_density_1, (uint64_t)result_density));
            result_density = convert(result_density, 0, 16, true);
            lo_hit = true;
        }

        // Select result between RAW table and Density Table
        if(le_underflow && lo_underflow) {
            lut_result = lut_uflow_priority? result_density: result_raw;
            lut_u_flow++;
        }
        else if(le_overflow && lo_overflow) {
            lut_result = lut_oflow_priority? result_density: result_raw;
            lut_o_flow++;
        }
        else {
            if(le_hit ^ lo_hit) {
                lut_result = le_hit? result_raw: result_density;
                if (le_hit) {
                    lut_le_hit++;
                } else {
                    lut_lo_hit++;
                }
            }
            else {
                if(lut_hybrid_priority)
                    lut_result = result_density;
                else
                    lut_result = result_raw;
                lut_hybrid_hit++;
            }
        }

        if (cdp_mul_bypass_) {
            data_cvt_out_0[i] = lut_result;
        } else {
            data_cvt_out_0[i] = lut_result * data_cvt_in_2[i+4];
        }

        cslDebug((70, "le: %lx, lo:%lx, out:%x mul:%lx\n" , result_raw, result_density, lut_result.to_int(), (uint64_t)data_cvt_out_0[i].to_int64() ));

#ifdef USE_HLS
        //***** HLS Output Convertor (For INT16: i33->i16) ******
        int64_t data_cvt_out_0_tmp;
        uint8_t flag;
        data_cvt_out_0_tmp = data_cvt_out_0[i];

        cdp_ocvt_hls(&data_cvt_out_0_tmp, cdp_datout_offset_, cdp_datout_scale_, cdp_datout_shifter_, DATA_FORMAT_INT16, &normalz_out[i], &flag);
        o_cvt_o_flow += !!flag;
#else
        data_cvt_out_1[i] = data_cvt_out_0[i] - cvt_out_offset;
        data_cvt_out_2[i] = data_cvt_out_1[i] * cvt_out_scale;
        data_cvt_out_3_tmp[i] = data_cvt_out_2[i] >> cvt_out_shifter;
        data_cvt_out_3[i] = convert(data_cvt_out_2[i].to_int64(), cvt_out_shifter.to_int(), 16, true);

        normalz_out[i]    = data_cvt_out_3[i].to_int();
#endif
    }
}

#pragma CTC SKIP
NV_NVDLA_cdp * NV_NVDLA_cdpCon(sc_module_name name)
{
    return new NV_NVDLA_cdp(name);
}
#pragma CTC ENDSKIP
