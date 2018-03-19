// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_rbk.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_rbk.h"
#include "NV_NVDLA_rbk_base.h"
#include "NV_NVDLA_rbk_rbk_gen.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "math.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define RUBIK_DATA_FORMAT_INT8        NVDLA_RBK_D_MISC_CFG_0_IN_PRECISION_INT8
#define RUBIK_DATA_FORMAT_INT16       NVDLA_RBK_D_MISC_CFG_0_IN_PRECISION_INT16
#define RUBIK_DATA_FORMAT_FP16        NVDLA_RBK_D_MISC_CFG_0_IN_PRECISION_FP16

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

NV_NVDLA_rbk::NV_NVDLA_rbk( sc_module_name module_name ):
    NV_NVDLA_rbk_base(module_name),
    planar_fifo_("planar_fifo", RUBIK_PLANAR_FIFO_NUM)
    // Delay setup
{
    sc_core::sc_vector<sc_fifo <uint8_t *>>::iterator iter;
    // uint32_t iter;
    reorder_array_                  = new uint8_t[RUBIK_INTERNAL_BUF_SIZE];
    feature_cube_in_fifo_           = new sc_fifo <uint8_t *> (RUBIK_FEATURE_CUBE_IN_FIFO_DEPTH);
    feature_cube_out_fifo_          = new sc_fifo <uint8_t *> (RUBIK_FEATURE_CUBE_OUT_FIFO_DEPTH);
    rbk_ack_fifo_     = new sc_fifo <rbk_ack_info*> (2);
    rubik_config_fifo_r2d_          = new sc_fifo <RubikConfig *>  (1);
    rubik_config_fifo_d2w_          = new sc_fifo <RubikConfig *>  (1);
    dma_rd_req_payload_             = new nvdla_dma_rd_req_t;
    dma_wr_req_cmd_payload_         = new nvdla_dma_wr_req_t;
    dma_wr_req_data_payload_        = new nvdla_dma_wr_req_t;
    dma_wr_req_cmd_payload_->tag    = TAG_CMD;
    dma_wr_req_data_payload_->tag   = TAG_DATA;
    is_mc_ack_done_                 = false;
    is_cv_ack_done_                 = false;
    Reset();
    // SC_THREAD
    SC_THREAD(RubikConsumerThread)
    SC_THREAD(RubikRdmaSequenceThread)
    SC_THREAD(RubikDataPathThread)
    SC_THREAD(RubikWdmaSequenceThread)
    SC_THREAD(RbkIntrThread)
    // SC_METHOD
    SC_METHOD(WriteResponseThreadMc);
    sensitive << mcif2rbk_wr_rsp;
    SC_METHOD(WriteResponseThreadCv);
    sensitive << cvif2rbk_wr_rsp;
}

#pragma CTC SKIP
NV_NVDLA_rbk::~NV_NVDLA_rbk () {
    sc_core::sc_vector<sc_fifo <uint8_t *>>::iterator iter;
    // uint32_t iter;
    if (reorder_array_)                 delete [] reorder_array_;
    if (feature_cube_in_fifo_)          delete feature_cube_in_fifo_;
    if( rbk_ack_fifo_)         delete rbk_ack_fifo_;
    if (rubik_config_fifo_r2d_)         delete rubik_config_fifo_r2d_;
    if (rubik_config_fifo_d2w_)         delete rubik_config_fifo_d2w_;
    if (dma_rd_req_payload_)            delete dma_rd_req_payload_;
    if (dma_wr_req_cmd_payload_)        delete dma_wr_req_cmd_payload_;
    if (dma_wr_req_data_payload_)       delete dma_wr_req_data_payload_;

}
#pragma CTC ENDSKIP

void NV_NVDLA_rbk::ExtractDmaPayload(sc_fifo <uint8_t *> *dma_fifo, nvdla_dma_rd_rsp_t* payload){
    // Extract data from payload
    //  Each payload is 64 byte, two mask bit tells which 32 byte groups are effective
    uint8_t *payload_data_ptr;
    uint8_t *rdma_atom_cube_ptr;
    uint8_t mask;
    mask = payload->pd.dma_read_data.mask;
    payload_data_ptr    = reinterpret_cast <uint8_t *> (payload->pd.dma_read_data.data);

    // Handling lower 32 bytes
    if (0 != (mask & 0x1)) {
        rdma_atom_cube_ptr = new uint8_t[RUBIK_ATOM_CUBE_SIZE]; 
        memcpy(rdma_atom_cube_ptr, payload_data_ptr, RUBIK_ATOM_CUBE_SIZE);
        dma_fifo->write(rdma_atom_cube_ptr);
        cslDebug((70, "NV_NVDLA_rbk::ExtractDmaPayload, write to dma_fifo. mask A, num_free:%d, num_avail:%d\n",
                    dma_fifo->num_free(), dma_fifo->num_available()));
        for(int i=0;i<32;i++)
            cslDebug((70, "0x%02x \n", rdma_atom_cube_ptr[i]));
        cslDebug((70, "\n"));
    }

    // Handling upper 32 bytes
    if (0 != (mask & 0x2)) {
        rdma_atom_cube_ptr = new uint8_t[RUBIK_ATOM_CUBE_SIZE]; 
        memcpy(rdma_atom_cube_ptr, payload_data_ptr + RUBIK_ATOM_CUBE_SIZE, RUBIK_ATOM_CUBE_SIZE);
        dma_fifo->write(rdma_atom_cube_ptr);
        cslDebug((70, "NV_NVDLA_rbk::ExtractDmaPayload, write to dma_fifo. mask B, num_free:%d, num_avail:%d\n",
                    dma_fifo->num_free(), dma_fifo->num_available()));
        for(int i=0;i<32;i++)
            cslDebug((70, "0x%02x \n", rdma_atom_cube_ptr[i]));
        cslDebug((70, "\n"));
    }
}

void NV_NVDLA_rbk::mcif2rbk_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    cslDebug((70, "NV_NVDLA_rbk::mcif2rbk_rd_rsp_b_transport, begin\n"));
    uint32_t rubik_mode;
#pragma CTC SKIP
    if(rubik_config_wdma_ == NULL)  // In case of rd_rsp_b_transport is called before RubikWdmaSequenceThread is scheduled 
    {
        rubik_mode = rbk_rubik_mode_;
    }
#pragma CTC ENDSKIP
    else
    {
        rubik_mode = rubik_config_wdma_->rbk_rubik_mode_;
    }
    switch (rubik_mode) {
        case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_CONTRACT:
            ExtractDmaPayload(feature_cube_in_fifo_, payload);
            break;
        case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_SPLIT: 
            ExtractDmaPayload(feature_cube_in_fifo_, payload);
            break;
        case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_MERGE:
            ExtractDmaPayload(feature_cube_in_fifo_, payload);
            break;
#pragma CTC SKIP
        default: 
            FAIL(("NV_NVDLA_rbk::mcif2rbk_rd_rsp_b_transport, unexpected RUBIK_MODE setting"));
            break;
#pragma CTC ENDSKIP
    }
    cslDebug((70, "NV_NVDLA_rbk::mcif2rbk_rd_rsp_b_transport, end\n"));
}

void NV_NVDLA_rbk::cvif2rbk_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    cslDebug((70, "NV_NVDLA_rbk::cvif2rbk_rd_rsp_b_transport, begin\n"));
    uint32_t rubik_mode;
#pragma CTC SKIP
    if(rubik_config_wdma_ == NULL)  // In case of rd_rsp_b_transport is called before RubikWdmaSequenceThread is scheduled 
    {
        rubik_mode = rbk_rubik_mode_;
    }
#pragma CTC ENDSKIP
    else
    {
        rubik_mode = rubik_config_wdma_->rbk_rubik_mode_;
    }
    switch (rubik_mode) {
        case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_CONTRACT:
            ExtractDmaPayload(feature_cube_in_fifo_, payload);
            break;
        case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_SPLIT: 
            ExtractDmaPayload(feature_cube_in_fifo_, payload);
            break;
        case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_MERGE:
            ExtractDmaPayload(feature_cube_in_fifo_, payload);
            break;
#pragma CTC SKIP
        default: 
            FAIL(("NV_NVDLA_rbk::cvif2rbk_rd_rsp_b_transport, unexpected RUBIK_MODE setting"));
            break;
#pragma CTC ENDSKIP
    }
    cslDebug((70, "NV_NVDLA_rbk::cvif2rbk_rd_rsp_b_transport, end\n"));
}

void NV_NVDLA_rbk::RbkIntrThread() {
    while (true) {
        while (uint32_t(rbk_ack_fifo_->num_available()) < 1) {
            wait( rbk_ack_fifo_->data_written_event() );
        }
        rbk_ack_info *ack = rbk_ack_fifo_->read();

        if (ack->is_mc) {
            if (!is_mc_ack_done_) {
                cslDebug((30, "%s: wait for mc_ack on group:%d\n", __FUNCTION__, ack->group_id));
                wait(rbk_mc_ack_);
            }

            is_mc_ack_done_ = false;
        } else {
            if (!is_cv_ack_done_) {
                cslDebug((30, "%s: wait for cv_ack on group:%d\n", __FUNCTION__, ack->group_id));
                wait(rbk_cv_ack_);
            }

            is_cv_ack_done_ = false;
        }

        wait(1, SC_NS);
        rbk2glb_done_intr[ack->group_id].write(true);

        delete ack;
    }
}

void NV_NVDLA_rbk::Reset() {
    rubik_config_wdma_ = NULL;
    rbk2glb_done_intr[0].initialize(false);
    rbk2glb_done_intr[1].initialize(false);
}

void NV_NVDLA_rbk::RubikHardwareLayerExecutionTrigger() {
    rbk_kickoff_.notify();
    wait(rbk_done_);
}

void NV_NVDLA_rbk::RubikConfigEvaluation(CNVDLA_RBK_REGSET *register_group_ptr) {
    rbk_reg_model::RbkUpdateVariables(register_group_ptr);
}

void NV_NVDLA_rbk::RubikConsumerThread() {
    while (true) {
        while(RbkGetOpeartionEnable(rbk_register_group_0) != NVDLA_RBK_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_rbk_reg_group_0_operation_enable);
        }
        cslDebug((50, "NV_NVDLA_rbk::RubikConsumerThread, group 0 opeartion start\n"));
        rbk_reg_model::RbkUpdateWorkingStatus(0,1);
        RubikConfigEvaluation(rbk_register_group_0);
        RubikHardwareLayerExecutionTrigger();
        rbk_reg_model::RbkUpdateWorkingStatus(0,0);
        cslDebug((50, "NV_NVDLA_rbk::RubikConsumerThread, group 0 opeartion done\n"));
        rbk_reg_model::RbkClearOpeartionEnable(rbk_register_group_0);

        while(RbkGetOpeartionEnable(rbk_register_group_1) != NVDLA_RBK_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_rbk_reg_group_1_operation_enable);
        }
        cslDebug((50, "NV_NVDLA_rbk::RubikConsumerThread, group 1 opeartion start\n"));
        rbk_reg_model::RbkUpdateWorkingStatus(1,1);
        RubikConfigEvaluation(rbk_register_group_1);
        RubikHardwareLayerExecutionTrigger();
        rbk_reg_model::RbkUpdateWorkingStatus(1,0);
        cslDebug((50, "NV_NVDLA_rbk::RubikConsumerThread, group 1 opeartion done\n"));
        rbk_reg_model::RbkClearOpeartionEnable(rbk_register_group_1);
    }
}

void NV_NVDLA_rbk::RubikRdmaSequenceThread() {
    RubikConfig *rubik_config;
    while (true) {
        wait (rbk_kickoff_);
        rubik_config = new RubikConfig;
        rubik_config->rbk_rubik_mode_ = rbk_rubik_mode_;
        rubik_config->rbk_in_precision_ = rbk_in_precision_;
        rubik_config->rbk_datain_ram_type_ = rbk_datain_ram_type_;
        rubik_config->rbk_datain_width_ = rbk_datain_width_;
        rubik_config->rbk_datain_height_ = rbk_datain_height_;
        rubik_config->rbk_datain_channel_ = rbk_datain_channel_;
        rubik_config->rbk_dain_addr_high_ = rbk_dain_addr_high_;
        rubik_config->rbk_dain_addr_low_ = rbk_dain_addr_low_;
        rubik_config->rbk_dain_line_stride_ = rbk_dain_line_stride_;
        rubik_config->rbk_dain_surf_stride_ = rbk_dain_surf_stride_;
        rubik_config->rbk_dain_planar_stride_ = rbk_dain_planar_stride_;
        rubik_config->rbk_dataout_ram_type_ = rbk_dataout_ram_type_;
        rubik_config->rbk_dataout_channel_ = rbk_dataout_channel_;
        rubik_config->rbk_daout_addr_high_ = rbk_daout_addr_high_;
        rubik_config->rbk_daout_addr_low_ = rbk_daout_addr_low_;
        rubik_config->rbk_daout_line_stride_ = rbk_daout_line_stride_;
        rubik_config->rbk_contract_stride_0_ = rbk_contract_stride_0_;
        rubik_config->rbk_contract_stride_1_ = rbk_contract_stride_1_;
        rubik_config->rbk_daout_surf_stride_ = rbk_daout_surf_stride_;
        rubik_config->rbk_daout_planar_stride_ = rbk_daout_planar_stride_;
        rubik_config->rbk_deconv_x_stride_ = rbk_deconv_x_stride_;
        rubik_config->rbk_deconv_y_stride_ = rbk_deconv_y_stride_;
        rubik_config_fifo_r2d_->write(rubik_config);
        cslDebug((30, "WxHxC=%dx%dx%d, precision:%d\n",
                    rbk_datain_width_+1, rbk_datain_height_+1, rbk_datain_channel_+1, rbk_in_precision_));
        switch (rbk_rubik_mode_) {
            case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_CONTRACT:
                RubikRdmaSequenceContract();
                break;
            case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_SPLIT: 
                RubikRdmaSequenceSplit();
                break;
            case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_MERGE:
                RubikRdmaSequenceMerge();
                break;
#pragma CTC SKIP
            default: 
                FAIL(("NV_NVDLA_rbk::RubikRdmaSequenceThread, unexpected RUBIK_MODE setting"));
                break;
#pragma CTC ENDSKIP
        }
    }
}

void NV_NVDLA_rbk::RubikRdmaSequenceContract() {
    // Config variables, they have corresponding value in registers
    uint32_t cube_in_width, cube_in_height;// , cube_in_channel;
    // uint32_t cube_out_width, cube_out_height, cube_out_channel;
    uint32_t cube_out_channel;
    uint64_t src_base_addr;
    uint32_t src_line_stride, src_surface_stride;
    uint32_t precision;
    uint32_t stride_x, stride_y;
    // Control variables
    uint32_t width_in_iter, height_in_iter, surface_in_iter, surface_out_iter;
    // uint32_t width_out_iter, height_out_iter, surface_out_iter;
    uint32_t stride_x_iter, stride_y_iter;
    uint32_t surface_out_num;
    uint32_t element_per_atom;
    uint64_t payload_addr;
    uint32_t payload_atom_num;
    uint32_t stride_x_step;
    // Copy from register value to local config variables, similar with RTL connection
    precision           = rbk_in_precision_;
    cube_in_width       = rbk_datain_width_   + 1;
    cube_in_height      = rbk_datain_height_  + 1;
    // cube_in_channel     = rbk_datain_channel_ + 1;
    // cube_out_width      = rbk_daout_width_   + 1;
    // cube_out_height     = rbk_daout_height_  + 1;
    stride_x            = rbk_deconv_x_stride_ + 1;
    stride_y            = rbk_deconv_y_stride_ + 1;
    // cube_out_channel    = rbk_daout_channel_ + 1;
    cube_out_channel    = rbk_dataout_channel_+1;
    src_base_addr       = uint64_t (rbk_dain_addr_high_) << 32 | uint64_t (rbk_dain_addr_low_) << 5;
    src_line_stride     = rbk_dain_line_stride_ << 5;
    src_surface_stride  = rbk_dain_surf_stride_ << 5;
    switch (precision) {
        case RUBIK_DATA_FORMAT_INT8:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT8;
            break;
        case RUBIK_DATA_FORMAT_INT16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT16;
            break;
        case RUBIK_DATA_FORMAT_FP16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_FP16;
            break;
#pragma CTC SKIP
        default:
            FAIL(("NV_NVDLA_rbk::RubikRdmaSequenceContract, invalid precision setting."));
            break;
#pragma CTC ENDSKIP
    }
    surface_out_num = (cube_out_channel + element_per_atom - 1)/element_per_atom;
    // Output surface iteration
    for (surface_out_iter = 0; surface_out_iter < surface_out_num; surface_out_iter ++) {
        cslDebug((70, "NV_NVDLA_rbk::RubikRdmaSequenceContract, surface_out_iter:0x%x, surface_out_num:0x%x\n", surface_out_iter, surface_out_num));
        // Input height iteration
        for (height_in_iter = 0; height_in_iter < cube_in_height; height_in_iter ++) {
            cslDebug((70, "NV_NVDLA_rbk::RubikRdmaSequenceContract, height_in_iter:0x%x, cube_in_height:0x%x\n", height_in_iter, cube_in_height));
            // Stride Y iteration
            for (stride_y_iter = 0; stride_y_iter < stride_y; stride_y_iter ++) {
                cslDebug((70, "NV_NVDLA_rbk::RubikRdmaSequenceContract, stride_y_iter:0x%x, stride_y:0x%x\n", stride_y_iter, stride_y));
                // Input width iteration
                width_in_iter = 0;
                while (width_in_iter < cube_in_width) {
                    payload_atom_num= min ((cube_in_width - width_in_iter), uint32_t(8));
                    cslDebug((70, "NV_NVDLA_rbk::RubikRdmaSequenceContract, width_in_iter:0x%x, cube_in_width:0x%x, width_in_step:0x%x\n", width_in_iter, cube_in_width, payload_atom_num));
                    // Stride X iteration
                    stride_x_iter = 0;
                    while (stride_x_iter < stride_x) {
                        stride_x_step = min ((stride_x - stride_x_iter), uint32_t(8));
                        cslDebug((70, "NV_NVDLA_rbk::RubikRdmaSequenceContract, stride_x_iter:0x%x, stride_x:0x%x, stride_x_step:0x%x\n", stride_x_iter, stride_x, stride_x_step));
                        for (surface_in_iter = 0; surface_in_iter < stride_x_step; surface_in_iter++) {
                            payload_addr    = src_base_addr + ( (stride_y_iter * stride_x + stride_x_iter + surface_in_iter) * surface_out_num + surface_out_iter) * src_surface_stride + height_in_iter * src_line_stride + width_in_iter*RUBIK_ATOM_CUBE_SIZE;
                            // Prepare payload
                            dma_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr;
                            dma_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num-1;
                            cslDebug((50, "%s wait for feature_cube_in_fifo_ > %d\n", __FUNCTION__, payload_atom_num));
                            //WaitUntilFifoFreeSizeGreaterThan(feature_cube_in_fifo_, payload_atom_num);
                            // Send read request to RDMA
                            SendDmaReadRequest(dma_rd_req_payload_, dma_delay_);
                        }
                        stride_x_iter += stride_x_step;
                    }
                    width_in_iter += payload_atom_num;
                }
            }
        }
    }
}

void NV_NVDLA_rbk::RubikRdmaSequenceSplit(){
    // Config variables, they have corresponding value in registers
    uint32_t cube_width, cube_height, cube_channel;
    uint64_t src_base_addr;
    uint32_t src_line_stride, src_surface_stride;
    uint32_t precision;
    // Control variables
    uint32_t width_iter, height_iter, surface_iter;
    uint32_t surface_num;
    uint32_t element_per_atom;
    uint64_t payload_addr;
    uint32_t payload_atom_num;
    uint32_t trans_size;
    // Copy from register value to local config variables, similar with RTL connection
    precision           = rbk_in_precision_;
    cube_width          = rbk_datain_width_   + 1;
    cube_height         = rbk_datain_height_  + 1;
    cube_channel        = rbk_datain_channel_ + 1;
    src_base_addr       = uint64_t (rbk_dain_addr_high_) << 32 | uint64_t (rbk_dain_addr_low_) << 5;
    src_line_stride     = rbk_dain_line_stride_ << 5;
    src_surface_stride  = rbk_dain_surf_stride_ << 5;
    cslDebug((80, "NV_NVDLA_rbk::RubikRdmaSequenceSplit: cube_width=0x%x cube_height=0x%x cube_channel=0x%x\n", cube_width, cube_height, cube_channel));
    cslDebug((80, "NV_NVDLA_rbk::RubikRdmaSequenceSplit: src_line_stride=0x%x src_surface_stride=0x%x\n", src_line_stride, src_surface_stride));
    switch (precision) {
        case RUBIK_DATA_FORMAT_INT8:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT8;
            //element_byte_size = RUBIK_ELEMENT_BYTE_SIZE_INT8;
            break;
        case RUBIK_DATA_FORMAT_INT16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT16;
            //element_byte_size = RUBIK_ELEMENT_BYTE_SIZE_INT16;
            break;
        case RUBIK_DATA_FORMAT_FP16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_FP16;
            //element_byte_size = RUBIK_ELEMENT_BYTE_SIZE_FP16;
            break;
#pragma CTC SKIP
        default:
            FAIL(("NV_NVDLA_rbk::RubikRdmaSequenceSplit, invalid precision setting."));
            break;
#pragma CTC ENDSKIP
    }
    trans_size = (RUBIK_INTERNAL_BUF_SIZE)/(32);
    cslDebug((50, "NV_NVDLA_rbk::RubikRdmaSequenceSplit, start\n"));
    surface_num = (cube_channel + element_per_atom - 1)/element_per_atom;
    for (surface_iter = 0; surface_iter < surface_num; surface_iter ++) {
        for (height_iter = 0; height_iter < cube_height; height_iter ++) {
            width_iter = 0;
            while (width_iter < cube_width) {
                cslDebug((80, "NV_NVDLA_rbk::RubikRdmaSequenceSplit: width_iter=0x%x height_iter=0x%x surface_iter=0x%x\n", width_iter, height_iter, surface_iter));
                payload_addr = src_base_addr + surface_iter * src_surface_stride + height_iter * src_line_stride + width_iter * RUBIK_ATOM_CUBE_SIZE;
                payload_atom_num    = min (cube_width - width_iter, uint32_t(trans_size));
                // payload_atom_num    = cube_width - width_iter;
                // Prepare payload
                dma_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr;
                dma_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num-1;
                cslDebug((80, "NV_NVDLA_rbk::RubikRdmaSequenceSplit: payload_addr=0x%lx payload_atom_num=0x%x\n", payload_addr, payload_atom_num));
                // Check are there sufficient entries in feature_cube_in_fifo_ 
                cslDebug((50, "%s wait for feature_cube_in_fifo_ > %d\n", __FUNCTION__, payload_atom_num));
                //WaitUntilFifoFreeSizeGreaterThan(feature_cube_in_fifo_, payload_atom_num);
                // Send read request to RDMA
                SendDmaReadRequest(dma_rd_req_payload_, dma_delay_);
                width_iter += payload_atom_num;
            }
        }
    }
    cslDebug((50, "NV_NVDLA_rbk::RubikRdmaSequenceSplit, end\n"));
}

void NV_NVDLA_rbk::RubikRdmaSequenceMerge() {
    // Config variables, they have corresponding value in registers
    uint32_t cube_width, cube_height, cube_channel;
    uint64_t src_base_addr;
    uint32_t src_line_stride, src_planar_stride;
    uint32_t precision;
    // Control variables
    uint32_t width_iter, height_iter, channel_iter, surface_iter;
    uint32_t surface_num;
    uint32_t planar_num;
    uint32_t element_byte_size;
    uint32_t element_per_atom;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint32_t payload_atom_num;
    uint32_t width_step;
    uint32_t trans_size;
    // Copy from register value to local config variables, similar with RTL connection
    precision           = rbk_in_precision_;
    cube_width          = rbk_datain_width_   + 1;
    cube_height         = rbk_datain_height_  + 1;
    cube_channel        = rbk_datain_channel_ + 1;
    src_base_addr       = ((uint64_t )rbk_dain_addr_high_) << 32 | uint64_t (rbk_dain_addr_low_) << 5;
    src_line_stride     = rbk_dain_line_stride_ << 5;
    src_planar_stride   = rbk_dain_planar_stride_ << 5;
    switch (precision) {
        case RUBIK_DATA_FORMAT_INT8:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT8;
            element_byte_size = RUBIK_ELEMENT_BYTE_SIZE_INT8;
            break;
        case RUBIK_DATA_FORMAT_INT16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT16;
            element_byte_size = RUBIK_ELEMENT_BYTE_SIZE_INT16;
            break;
        case RUBIK_DATA_FORMAT_FP16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_FP16;
            element_byte_size = RUBIK_ELEMENT_BYTE_SIZE_FP16;
            break;
#pragma CTC SKIP
        default:
            FAIL(("NV_NVDLA_rbk::RubikRdmaSequenceMerge, invalid precision setting."));
            break;
#pragma CTC ENDSKIP
    }
    surface_num = (cube_channel + element_per_atom - 1)/element_per_atom;
    trans_size = RUBIK_INTERNAL_BUF_SIZE/(element_per_atom*element_byte_size);
    for (surface_iter = 0; surface_iter < surface_num; surface_iter ++) {
        planar_num = cube_channel - surface_iter*element_per_atom;
        planar_num = planar_num < element_per_atom ? planar_num : element_per_atom;
        for (height_iter = 0; height_iter < cube_height; height_iter ++) {
            width_iter = 0;
            while (width_iter < cube_width) {
                width_step      = min ((cube_width - width_iter), trans_size);
                payload_size    = max (uint32_t(RUBIK_ATOM_CUBE_SIZE), width_step * element_byte_size);
                cslDebug((80, "NV_NVDLA_rbk::RubikRdmaSequenceMerge: width_iter=0x%x height_iter=0x%x surface_iter=0x%x, width_step=0x%x\n",
                            width_iter, height_iter, surface_iter, width_step));
                payload_atom_num= (payload_size + RUBIK_ATOM_CUBE_SIZE-1)/RUBIK_ATOM_CUBE_SIZE;
                for (channel_iter = 0; channel_iter < planar_num; channel_iter ++) {
                    payload_addr = src_base_addr + height_iter * src_line_stride +
                        (surface_iter*element_per_atom+channel_iter) * src_planar_stride + width_iter*element_byte_size;
                    // Prepare payload
                    dma_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr;
                    dma_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num-1;
                    // Check are there sufficient entries in feature_cube_in_fifo_ 
                    cslDebug((50, "%s wait for feature_cube_in_fifo_ free slots > %d E\n", __FUNCTION__, payload_atom_num));
                    //WaitUntilFifoFreeSizeGreaterThan(feature_cube_in_fifo_, payload_atom_num);
                    cslDebug((50, "%s wait for feature_cube_in_fifo_ free slots > %d X\n", __FUNCTION__, payload_atom_num));
                    // Send read request to RDMA
                    SendDmaReadRequest(dma_rd_req_payload_, dma_delay_);
                }
                width_iter += width_step;
            }
        }
    }
}

void NV_NVDLA_rbk::RubikDataPathThread() {
    while (true) {
        rubik_config_dp_ = rubik_config_fifo_r2d_->read();
        rubik_config_fifo_d2w_->write(rubik_config_dp_);
        switch (rubik_config_dp_->rbk_rubik_mode_) {
            case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_CONTRACT:
                RubikDataPathSequenceContract();
                break;
            case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_SPLIT: 
                RubikDataPathSequenceSplit();
                break;
            case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_MERGE:
                RubikDataPathSequenceMerge();
                break;
#pragma CTC SKIP
            default: 
                FAIL(("NV_NVDLA_rbk::RubikDataPathSequenceThread, unexpected RUBIK_MODE setting"));
                break;
#pragma CTC ENDSKIP
        }
    }
}

void NV_NVDLA_rbk::RubikDataPathSequenceContract(){
    // Config variables, they have corresponding value in registers
    uint32_t cube_in_width, cube_in_height;// , cube_in_channel;
    // uint32_t cube_out_width, cube_out_height, cube_out_channel;
    uint32_t cube_out_channel;
    uint32_t precision;
    uint32_t stride_x, stride_y;
    // Control variables
    uint32_t width_in_iter, height_in_iter, surface_in_iter, surface_out_iter;
    // uint32_t width_out_iter, height_out_iter, surface_out_iter;
    uint32_t stride_x_iter, stride_y_iter, atom_iter;
    uint32_t surface_out_num;
    uint32_t element_per_atom;
    uint32_t width_in_step, stride_x_step;
    uint8_t  *atom_ptr;
    // Copy from register value to local config variables, similar with RTL connection
    precision           = rubik_config_dp_->rbk_in_precision_;
    cube_in_width       = rubik_config_dp_->rbk_datain_width_   + 1;
    cube_in_height      = rubik_config_dp_->rbk_datain_height_  + 1;
    // cube_in_channel     = rubik_config_dp_->rbk_datain_channel_ + 1;
    // cube_out_width      = rubik_config_dp_->rbk_daout_width_   + 1;
    // cube_out_height     = rubik_config_dp_->rbk_daout_height_  + 1;
    stride_x            = rubik_config_dp_->rbk_deconv_x_stride_ + 1;
    stride_y            = rubik_config_dp_->rbk_deconv_y_stride_ + 1;
    // cube_out_channel    = rbk_daout_channel_ + 1;
    cube_out_channel    = rubik_config_dp_->rbk_dataout_channel_+1;
    // src_base_addr       = uint64_t (rbk_dain_addr_high_) << 32 | uint64_t (rbk_dain_addr_low_) << 5;
    // src_line_stride     = rbk_dain_line_stride_ << 5;
    // src_surface_stride  = rbk_dain_surf_stride_ << 5;
    switch (precision) {
        case RUBIK_DATA_FORMAT_INT8:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT8;
            break;
        case RUBIK_DATA_FORMAT_INT16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT16;
            break;
        case RUBIK_DATA_FORMAT_FP16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_FP16;
            break;
#pragma CTC SKIP
        default:
            FAIL(("NV_NVDLA_rbk::RubikDataPathSequenceContract, invalid precision setting."));
            break;
#pragma CTC ENDSKIP
    }
    surface_out_num = (cube_out_channel + element_per_atom - 1)/element_per_atom;
    // Output surface iteration
    for (surface_out_iter = 0; surface_out_iter < surface_out_num; surface_out_iter ++) {
        cslDebug((70, "NV_NVDLA_rbk::RubikDataPathSequenceContract, surface_out_iter:0x%x, surface_out_num:0x%x\n", surface_out_iter, surface_out_num));
        // Input height iteration
        for (height_in_iter = 0; height_in_iter < cube_in_height; height_in_iter ++) {
            cslDebug((70, "NV_NVDLA_rbk::RubikDataPathSequenceContract, height_in_iter:0x%x, cube_in_height:0x%x\n", height_in_iter, cube_in_height));
            // Stride Y iteration
            for (stride_y_iter = 0; stride_y_iter < stride_y; stride_y_iter ++) {
                cslDebug((70, "NV_NVDLA_rbk::RubikDataPathSequenceContract, stride_y_iter:0x%x, stride_y:0x%x\n", stride_y_iter, stride_y));
                // Input lines from different cube shall be in the same line of output cube
                // Input width iteration
                width_in_iter = 0;
                while (width_in_iter < cube_in_width) {
                    width_in_step   = min ((cube_in_width - width_in_iter), uint32_t(8));
                    cslDebug((70, "NV_NVDLA_rbk::RubikDataPathSequenceContract, width_in_iter:0x%x, cube_in_width:0x%x, width_in_step:0x%x\n", width_in_iter, cube_in_width, width_in_step));
                    // Stride X iteration
                    stride_x_iter = 0;
                    while (stride_x_iter < stride_x) {
                        stride_x_step = min ((stride_x - stride_x_iter), uint32_t(8));
                        cslDebug((70, "NV_NVDLA_rbk::RubikDataPathSequenceContract, stride_x_iter:0x%x, stride_x:0x%x, stride_x_step:0x%x\n", stride_x_iter, stride_x, stride_x_step));
                        for (surface_in_iter = 0; surface_in_iter < stride_x_step; surface_in_iter++) {
                            for (atom_iter=0; atom_iter<width_in_step; atom_iter++) {
                                atom_ptr = feature_cube_in_fifo_->read();
                                cslDebug((70, "NV_NVDLA_rbk::RubikDataPathSequenceContract, data from feature_cube_in_fifo_ "));
                                for(int i=0;i<RUBIK_ATOM_CUBE_SIZE;i++)
                                    cslDebug((70, "0x%02x ", atom_ptr[i]));
                                cslDebug((70, "\n"));
                                planar_fifo_[surface_in_iter].write(atom_ptr);
                            }
                        }
                        for (atom_iter=0; atom_iter<width_in_step; atom_iter++) {
                            for (surface_in_iter = 0; surface_in_iter < stride_x_step; surface_in_iter++) {
                                atom_ptr = planar_fifo_[surface_in_iter].read();
                                cslDebug((70, "NV_NVDLA_rbk::RubikDataPathSequenceContract, data from planar_fifo_[0x%x] ", surface_in_iter));
                                for(int i=0;i<RUBIK_ATOM_CUBE_SIZE;i++)
                                    cslDebug((70, "0x%02x ", atom_ptr[i]));
                                cslDebug((70, "\n"));
                                feature_cube_out_fifo_->write(atom_ptr);
                            }
                        }
                        stride_x_iter += stride_x_step;
                    }
                    width_in_iter += width_in_step;
                }
            }
        }
    }
}

void NV_NVDLA_rbk::RubikDataPathSequenceSplit(){
}

void NV_NVDLA_rbk::RubikDataPathSequenceMerge(){
}

void NV_NVDLA_rbk::RubikWdmaSequenceThread() {
    while (true) {
        rubik_config_wdma_ = rubik_config_fifo_d2w_->read();
        switch (rubik_config_wdma_->rbk_rubik_mode_) {
            case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_CONTRACT:
                RubikWdmaSequenceContract();
                break;
            case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_SPLIT: 
                RubikWdmaSequenceSplit();
                break;
            case NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_MERGE:
                RubikWdmaSequenceMerge();
                break;
#pragma CTC SKIP
            default: 
                FAIL(("NV_NVDLA_rbk::RubikWdmaSequenceThread, unexpected RUBIK_MODE setting"));
                break;
#pragma CTC ENDSKIP
        }
        cslDebug((30, "Delete rubik_config_wdma\n"));
        delete rubik_config_wdma_;
        rubik_config_wdma_ = NULL;
    }
}

void NV_NVDLA_rbk::RubikWdmaSequenceContract(){
    // Config variables, they have corresponding value in registers
    uint32_t cube_in_width, cube_in_height;// , cube_in_channel;
    // uint32_t cube_out_width, cube_out_height, cube_out_channel;
    uint32_t cube_out_width, cube_out_channel;
    uint64_t dst_base_addr;
    uint32_t dst_super_line_stride;
    uint32_t dst_line_stride;
    uint32_t dst_surface_stride;
    uint32_t precision;
    uint32_t stride_x, stride_y;
    // Control variables
    uint32_t width_in_iter, height_in_iter, surface_out_iter;
    // uint32_t width_out_iter, height_out_iter, surface_out_iter;
    uint32_t stride_x_iter, stride_y_iter;
    uint32_t surface_out_num;
    uint32_t element_per_atom;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint32_t payload_atom_num;
    uint32_t width_in_step, stride_x_step;
    uint32_t width_in_step_iter;
    bool     is_required_ack=false;
    // Copy from register value to local config variables, similar with RTL connection
    precision           = rubik_config_wdma_->rbk_in_precision_;
    cube_in_width       = rubik_config_wdma_->rbk_datain_width_   + 1;
    cube_in_height      = rubik_config_wdma_->rbk_datain_height_  + 1;
    // cube_in_channel     = rubik_config_wdma_->rbk_datain_channel_ + 1;
    stride_x            = rubik_config_wdma_->rbk_deconv_x_stride_ + 1;
    stride_y            = rubik_config_wdma_->rbk_deconv_y_stride_ + 1;
    cube_out_width      = cube_in_width*stride_x;
    dst_base_addr       = uint64_t (rubik_config_wdma_->rbk_daout_addr_high_) << 32 | uint64_t (rubik_config_wdma_->rbk_daout_addr_low_) << 5;
    dst_super_line_stride     = rubik_config_wdma_->rbk_contract_stride_1_ << 5;
    dst_line_stride     = rubik_config_wdma_->rbk_daout_line_stride_ << 5;
    dst_surface_stride  = rubik_config_wdma_->rbk_daout_surf_stride_ << 5;
    // cube_out_channel    = rbk_daout_channel_ + 1;
    // cube_out_channel    = cube_in_channel/stride_x/stride_y;
    cube_out_channel    = rubik_config_wdma_->rbk_dataout_channel_+1;
    switch (precision) {
        case RUBIK_DATA_FORMAT_INT8:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT8;
            break;
        case RUBIK_DATA_FORMAT_INT16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT16;
            break;
        case RUBIK_DATA_FORMAT_FP16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_FP16;
            break;
#pragma CTC SKIP
        default:
            FAIL(("NV_NVDLA_rbk::RubikWdmaSequenceContract, invalid precision setting."));
            break;
#pragma CTC ENDSKIP
    }
    surface_out_num = (cube_out_channel + element_per_atom - 1)/element_per_atom;
    // Output surface iteration
    for (surface_out_iter = 0; surface_out_iter < surface_out_num; surface_out_iter ++) {
        cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceContract, surface_out_iter:0x%x, surface_out_num:0x%x\n", surface_out_iter, surface_out_num));
        // Input height iteration
        for (height_in_iter = 0; height_in_iter < cube_in_height; height_in_iter ++) {
            cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceContract, height_in_iter:0x%x, cube_in_height:0x%x\n", height_in_iter, cube_in_height));
            // Stride Y iteration
            for (stride_y_iter = 0; stride_y_iter < stride_y; stride_y_iter ++) {
                cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceContract, stride_y_iter:0x%x, stride_y:0x%x\n", stride_y_iter, stride_y));
                if (stride_x > 8) {
                    // Stride_x is greater than 8, payload_atom_num shall be stride_x_partial * width_partial
                    // Input width iteration
                    width_in_iter = 0;
                    while (width_in_iter < cube_in_width) {
                        width_in_step   =   min ((cube_in_width - width_in_iter), uint32_t(8));
                        cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceContract, width_in_iter:0x%x, cube_in_width:0x%x, width_in_step:0x%x\n", width_in_iter, cube_in_width, width_in_step));
                        // Stride X iteration
                        stride_x_iter = 0;
                        while (stride_x_iter < stride_x) {
                            stride_x_step = min ((stride_x - stride_x_iter), uint32_t(8));
                            cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceContract, stride_x_iter:0x%x, stride_x:0x%x, stride_x_step:0x%x\n", stride_x_iter, stride_x, stride_x_step));
                            for (width_in_step_iter=0;width_in_step_iter<width_in_step;width_in_step_iter++) {
                                payload_atom_num=   stride_x_step;
                                payload_size    =   payload_atom_num*RUBIK_ATOM_CUBE_SIZE;
                                payload_addr    =   dst_base_addr + stride_y_iter * dst_line_stride + height_in_iter * dst_super_line_stride + surface_out_iter * dst_surface_stride + (width_in_iter*stride_x + width_in_step_iter * stride_x + stride_x_iter)*RUBIK_ATOM_CUBE_SIZE;
                                cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceContract, payload_addr:0x%lx, payload_atom_num:0x%x\n", payload_addr, payload_atom_num));
                                if ( (surface_out_iter+1 == surface_out_num) && (height_in_iter+1 == cube_in_height) && (stride_y_iter + 1 == stride_y) && (stride_x_iter + stride_x_step == stride_x) && (width_in_iter + width_in_step  == cube_in_width && width_in_step_iter + 1 == width_in_step) ) {
                                    is_required_ack = true;
                                }
                                SendDmaWriteRequest(feature_cube_out_fifo_, payload_addr, payload_size, payload_atom_num, is_required_ack);
                            }
                            stride_x_iter += stride_x_step;
                        }
                        width_in_iter   +=  width_in_step;
                    }
                } else {
                    // Stride_x is less or equal than 8, send line by line 
                    payload_atom_num= cube_out_width;
                    payload_size    = payload_atom_num*RUBIK_ATOM_CUBE_SIZE;
                    payload_addr    = dst_base_addr + height_in_iter * dst_super_line_stride + stride_y_iter * dst_line_stride + surface_out_iter * dst_surface_stride;
                    // Prepare Payload
                    cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceContract, payload_addr:0x%lx, payload_atom_num:0x%x\n", payload_addr, payload_atom_num));
                    if ( (surface_out_iter+1 == surface_out_num) && (height_in_iter+1 == cube_in_height) && (stride_y_iter + 1 == stride_y) ) {
                        is_required_ack = true;
                    }
                    SendDmaWriteRequest(feature_cube_out_fifo_, payload_addr, payload_size, payload_atom_num, is_required_ack);
                }
            }
        }
    }
}
//
//
//
//
//
//
//
//
//
//
//
//
//
void NV_NVDLA_rbk::RubikWdmaSequenceSplit(){
    // Config variables, they have corresponding value in registers
    uint32_t cube_width, cube_height, cube_channel;
    uint64_t dst_base_addr;
    uint32_t dst_line_stride, dst_planar_stride;
    uint32_t precision;
    // Control variables
    uint32_t width_iter, height_iter, channel_iter, surface_iter;
    uint32_t surface_num;
    uint32_t element_byte_size;
    uint32_t element_per_atom;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint32_t payload_atom_iter, payload_atom_num;
    uint8_t  *feature_cube_atom_ptr;
    uint8_t  *planar_atom_ptr;
    uint32_t planar_num;
    uint32_t reorder_iter;
    uint32_t width_step;
    uint32_t channel_stride_in_reorder_array;
    bool     is_required_ack=false;
    uint32_t trans_size;

    // Copy from register value to local config variables, similar with RTL connection
    precision           = rubik_config_wdma_->rbk_in_precision_;
    cube_width          = rubik_config_wdma_->rbk_datain_width_   + 1;
    cube_height         = rubik_config_wdma_->rbk_datain_height_  + 1;
    cube_channel        = rubik_config_wdma_->rbk_dataout_channel_ + 1;
    dst_base_addr       = uint64_t (rubik_config_wdma_->rbk_daout_addr_high_) << 32 | uint64_t (rubik_config_wdma_->rbk_daout_addr_low_) << 5;
    dst_line_stride     = rubik_config_wdma_->rbk_daout_line_stride_ << 5;
    dst_planar_stride   = rubik_config_wdma_->rbk_daout_planar_stride_ << 5;
    switch (precision) {
        case RUBIK_DATA_FORMAT_INT8:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT8;
            element_byte_size = RUBIK_ELEMENT_BYTE_SIZE_INT8;
            break;
        case RUBIK_DATA_FORMAT_INT16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT16;
            element_byte_size = RUBIK_ELEMENT_BYTE_SIZE_INT16;
            break;
        case RUBIK_DATA_FORMAT_FP16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_FP16;
            element_byte_size = RUBIK_ELEMENT_BYTE_SIZE_FP16;
            break;
#pragma CTC SKIP
        default:
            FAIL(("NV_NVDLA_rbk::RubikWdmaSequenceSplit, invalid precision setting."));
            break;
#pragma CTC ENDSKIP
    }
    cslDebug((50, "NV_NVDLA_rbk::RubikWdmaSequenceSplit, start\n"));
    surface_num = (cube_channel + element_per_atom - 1)/element_per_atom;
    trans_size = (RUBIK_INTERNAL_BUF_SIZE)/(32);
    channel_stride_in_reorder_array = element_byte_size * trans_size;
    for (surface_iter = 0; surface_iter < surface_num; surface_iter ++) {
        planar_num = cube_channel - surface_iter*element_per_atom;
        planar_num = min(planar_num, element_per_atom);
        cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceSplit, surface_iter:0x%x, surface_num:0x%x, planar_num:0x%x\n", surface_iter, surface_num, planar_num));
        for (height_iter = 0; height_iter < cube_height; height_iter ++) {
            cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceSplit, height_iter:0x%x, cube_height:0x%x\n", height_iter, cube_height));
            width_iter = 0;
            while (width_iter < cube_width) {
                width_step      = min ((cube_width - width_iter), trans_size);
                cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceSplit, width_iter:0x%x, cube_width:0x%x, width_step:0x%x\n", width_iter, cube_width, width_step));
                payload_size    = max (uint32_t(RUBIK_ATOM_CUBE_SIZE), width_step * element_byte_size);
                payload_atom_num= (payload_size + RUBIK_ATOM_CUBE_SIZE-1)/RUBIK_ATOM_CUBE_SIZE;
                memset(reorder_array_, 0, RUBIK_INTERNAL_BUF_SIZE);
                for (reorder_iter=0; reorder_iter < width_step; reorder_iter++) {
                    feature_cube_atom_ptr = feature_cube_in_fifo_->read();
                    cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceSplit, data from feature_cube_in_fifo_:"));
                    for(int i=0;i<32;i++)
                        cslDebug((70, "0x%02x ", feature_cube_atom_ptr[i]));
                    cslDebug((70, "\n"));
                    for (channel_iter = 0; channel_iter < planar_num; channel_iter ++) {
                        // int index = channel_iter * payload_size + reorder_iter*element_byte_size;
                        int index = channel_iter * channel_stride_in_reorder_array + reorder_iter*element_byte_size;
#pragma CTC SKIP
                        assert(index < RUBIK_INTERNAL_BUF_SIZE);
#pragma CTC ENDSKIP
                        memcpy(&reorder_array_[index], &feature_cube_atom_ptr[channel_iter*element_byte_size], element_byte_size);
                    }
                    delete [] feature_cube_atom_ptr;
                }
                cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceSplit, data in reorder_array_:"));
                for(int i=0;i<RUBIK_ATOM_CUBE_SIZE*RUBIK_ELEMENT_PER_ATOM_INT8;i++)
                    cslDebug((70, "0x%02x ", reorder_array_[i]));
                cslDebug((70, "\n"));
                // Send out write transactions plane by plane
                for (channel_iter = 0; channel_iter < planar_num; channel_iter ++) {
                    cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceSplit, channel_iter:0x%x, planar_num:0x%x\n", channel_iter, planar_num));
                    // Copy data from reorder_array to planar fifos
                    for (payload_atom_iter=0; payload_atom_iter<payload_atom_num;payload_atom_iter++) {
                        // int index = channel_iter*payload_size + payload_atom_iter*RUBIK_ATOM_CUBE_SIZE;
                        int index = channel_iter * channel_stride_in_reorder_array + payload_atom_iter*RUBIK_ATOM_CUBE_SIZE;
#pragma CTC SKIP
                        assert(index < RUBIK_INTERNAL_BUF_SIZE);
#pragma CTC ENDSKIP
                        planar_atom_ptr = new uint8_t[RUBIK_ATOM_CUBE_SIZE];
                        memcpy(planar_atom_ptr, &reorder_array_[index], RUBIK_ATOM_CUBE_SIZE);
                        planar_fifo_[channel_iter].write(planar_atom_ptr);
                    }
                    payload_addr     = dst_base_addr + height_iter * dst_line_stride + (surface_iter * element_per_atom + channel_iter) * dst_planar_stride + width_iter*element_byte_size;
                    // Prepare Payload
                    if ( ((surface_iter+1) == surface_num) && ((height_iter+1) == cube_height) && ((channel_iter + 1) == planar_num) && ((width_iter+width_step) >= cube_width) ) {
                        is_required_ack = true;
                    }
                    // Send data to planar_fifo_
                    cslDebug((80, "NV_NVDLA_rbk::RubikWdmaSequenceSplit: payload_addr=0x%lx payload_atom_num=0x%x is_required_ack=0x%x\n", payload_addr, payload_atom_num, is_required_ack));
                    SendDmaWriteRequest(&planar_fifo_[channel_iter], payload_addr, payload_size, payload_atom_num, is_required_ack);
                }
                width_iter += width_step;
            }
        }
    }
    cslDebug((50, "NV_NVDLA_rbk::RubikWdmaSequenceSplit, end\n"));
}

void NV_NVDLA_rbk::RubikWdmaSequenceMerge(){
    // Config variables, they have corresponding value in registers
    uint32_t cube_width, cube_height, cube_channel;
    uint64_t dst_base_addr;
    uint32_t dst_line_stride, dst_surf_stride;
    uint32_t precision;
    // Control variables
    uint32_t width_iter, height_iter, channel_iter, surface_iter;
    uint32_t surface_num;
    uint32_t planar_num;
    uint32_t element_byte_size;
    uint32_t element_per_atom;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint32_t payload_atom_num;
    uint8_t  *planar_atom_ptr;
    uint8_t  *feature_cube_atom_ptr;
    uint32_t atom_iter, atom_num_iter;
    uint32_t width_step;
    bool     is_required_ack=false;
    uint32_t trans_size;

    // Copy from register value to local config variables, similar with RTL connection
    precision           = rubik_config_wdma_->rbk_in_precision_;
    cube_width          = rubik_config_wdma_->rbk_datain_width_   + 1;
    cube_height         = rubik_config_wdma_->rbk_datain_height_  + 1;
    cube_channel        = rubik_config_wdma_->rbk_datain_channel_ + 1;
    dst_base_addr       = ((uint64_t)rubik_config_wdma_->rbk_daout_addr_high_) << 32 | uint64_t (rubik_config_wdma_->rbk_daout_addr_low_) << 5;
    dst_line_stride     = rubik_config_wdma_->rbk_daout_line_stride_ << 5;
    dst_surf_stride     = rubik_config_wdma_->rbk_daout_surf_stride_ << 5;
    cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceMerge, dst_line_stride:0x%x, dst_surf_stride:0x%x\n", dst_line_stride, dst_surf_stride));
    switch (precision) {
        case RUBIK_DATA_FORMAT_INT8:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT8;
            element_byte_size = RUBIK_ELEMENT_BYTE_SIZE_INT8;
            break;
        case RUBIK_DATA_FORMAT_INT16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_INT16;
            element_byte_size = RUBIK_ELEMENT_BYTE_SIZE_INT16;
            break;
        case RUBIK_DATA_FORMAT_FP16:
            element_per_atom = RUBIK_ELEMENT_PER_ATOM_FP16;
            element_byte_size = RUBIK_ELEMENT_BYTE_SIZE_FP16;
            break;
#pragma CTC SKIP
        default:
            FAIL(("NV_NVDLA_rbk::RubikWdmaSequenceMerge, invalid precision setting."));
            break;
#pragma CTC ENDSKIP
    }
    surface_num = (cube_channel + element_per_atom - 1)/element_per_atom;
    trans_size = (RUBIK_INTERNAL_BUF_SIZE)/(element_per_atom*element_byte_size);
    for (surface_iter = 0; surface_iter < surface_num; surface_iter ++) {
        planar_num = cube_channel - surface_iter*element_per_atom;
        planar_num = planar_num > element_per_atom ? element_per_atom : planar_num;
        cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceMerge, surface_iter:0x%x, surface_num:0x%x\n", surface_iter, surface_num));
        for (height_iter = 0; height_iter < cube_height; height_iter ++) {
            cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceMerge, height_iter:0x%x, cube_height:0x%x\n", height_iter, cube_height));
            width_iter = 0;
            while (width_iter < cube_width) {
                width_step      = min ((cube_width - width_iter), trans_size);
                memset(reorder_array_, 0, RUBIK_INTERNAL_BUF_SIZE);
                cslDebug((70, "NV_NVDLA_rbk::RubikWdmaSequenceMerge, width_iter:0x%x, cube_width:0x%x, width_step:0x%x\n", width_iter, cube_width, width_step));
                for (channel_iter = 0; channel_iter < planar_num; channel_iter ++) {
                    // Read a planar atom from rdma buffer
                    for(atom_num_iter = 0; atom_num_iter < (width_step*element_byte_size + RUBIK_ATOM_CUBE_SIZE -1 )/RUBIK_ATOM_CUBE_SIZE; atom_num_iter++) {
                        cslDebug((50, "%s read from feature_cube_in_fifo_ E\n", __FUNCTION__));
                        planar_atom_ptr = feature_cube_in_fifo_->read();
                        cslDebug((50, "%s read from feature_cube_in_fifo_ X\n", __FUNCTION__));
                        for (atom_iter=0; atom_iter < RUBIK_ATOM_CUBE_SIZE/element_byte_size; atom_iter++) {
                            int index = (atom_iter + atom_num_iter*element_per_atom) * RUBIK_ATOM_CUBE_SIZE + channel_iter * element_byte_size;
#pragma CTC SKIP
                            assert(index < RUBIK_INTERNAL_BUF_SIZE);
#pragma CTC ENDSKIP
                            memcpy(&reorder_array_[index], &planar_atom_ptr[atom_iter*element_byte_size], element_byte_size);
                        }
                        delete [] planar_atom_ptr;
                    }
                }
                cslDebug((50, "%s reorder done\n", __FUNCTION__));
                // Send out write transactions atom by atom
                // payload_atom_num= min ((cube_width - width_iter), uint32_t(RUBIK_ATOM_CUBE_SIZE/element_byte_size));
                payload_atom_num= width_step;
                payload_size    = payload_atom_num*RUBIK_ATOM_CUBE_SIZE;
                // Copy data from reorder_array to feature_cube_out_fifo_ fifos
                for (atom_iter=0; atom_iter < width_step; atom_iter++) {
                    feature_cube_atom_ptr = new uint8_t[RUBIK_ATOM_CUBE_SIZE];
                    memcpy(feature_cube_atom_ptr, &reorder_array_[atom_iter * RUBIK_ATOM_CUBE_SIZE], RUBIK_ATOM_CUBE_SIZE);
                    cslDebug((50, "%s write to feature_cube_out_fifo_ E\n", __FUNCTION__));
                    // Send out write transactions atom by atom
                    feature_cube_out_fifo_->write(feature_cube_atom_ptr);
                    cslDebug((50, "%s write to feature_cube_out_fifo_ X\n", __FUNCTION__));
                }
                payload_addr     = dst_base_addr + height_iter * dst_line_stride + surface_iter * dst_surf_stride + width_iter * RUBIK_ATOM_CUBE_SIZE;
                // Prepare Payload
                if ( ((surface_iter+1) == surface_num) && ((height_iter+1) == cube_height) && ((width_iter+payload_atom_num) == cube_width) ) {
                    is_required_ack = true;
                }
                cslDebug((80, "NV_NVDLA_rbk::RubikWdmaSequenceMerge: payload_addr=0x%lx payload_atom_num=0x%x is_required_ack=0x%x\n", payload_addr, payload_atom_num, is_required_ack));
                SendDmaWriteRequest(feature_cube_out_fifo_, payload_addr, payload_size, payload_atom_num, is_required_ack);
                width_iter += width_step;
            }
        }
    }
}

#pragma CTC SKIP
void NV_NVDLA_rbk::WaitUntilFifoFreeSizeGreaterThan(sc_fifo <uint8_t *> *data_fifo, uint32_t num) {
    while (uint32_t(data_fifo->num_free()) < num) {
        wait( data_fifo->data_read_event() );
    }
}

void NV_NVDLA_rbk::WaitUntilFifoAvailableSizeGreaterThan(sc_fifo <uint8_t *> *data_fifo, uint32_t num) {
    while (uint32_t(data_fifo->num_available()) < num) {
        wait( data_fifo->data_written_event() );
    }
}
#pragma CTC ENDSKIP

// Send DMA read request
void NV_NVDLA_rbk::SendDmaReadRequest(nvdla_dma_rd_req_t* payload, sc_time& delay) {
    cslDebug((50, "NV_NVDLA_rbk::SendDmaReadRequest: payload_addr=0x%lx payload_atom_num=0x%x\n", payload->pd.dma_read_cmd.addr, payload->pd.dma_read_cmd.size+1));
    if (NVDLA_RBK_D_DAIN_RAM_TYPE_0_DATAIN_RAM_TYPE_MCIF == rbk_datain_ram_type_) {
        rbk2mcif_rd_req_b_transport(payload, dma_delay_);
    } else {
        rbk2cvif_rd_req_b_transport(payload, dma_delay_);
    }
}

// Send DMA write request
void NV_NVDLA_rbk::SendDmaWriteRequest(sc_fifo <uint8_t *> *wdma_fifo, uint64_t payload_addr, uint32_t payload_size, uint32_t payload_atom_num, bool ack_required){
    uint32_t atom_iter = 0;
    uint8_t *dma_write_data_ptr;
    uint8_t *payload_data_ptr;
    // Prepare payload
    dma_wr_req_cmd_payload_->pd.dma_write_cmd.addr = payload_addr;
    dma_wr_req_cmd_payload_->pd.dma_write_cmd.size = payload_atom_num-1;
    payload_data_ptr = reinterpret_cast <uint8_t  *>  (dma_wr_req_data_payload_->pd.dma_write_data.data);
    // cslDebug((50, "%s wait for fifo > %d E\n", __FUNCTION__, payload_atom_num));
    // WaitUntilFifoAvailableSizeGreaterThan(wdma_fifo, payload_atom_num);
    // cslDebug((50, "%s wait for fifo > %d X\n", __FUNCTION__, payload_atom_num));
    // Send write command
    SendDmaWriteRequest(dma_wr_req_cmd_payload_, dma_delay_, ack_required);
    cslDebug((50, "NV_NVDLA_rbk::SendDmaWriteRequest: payload_addr=0x%lx payload_atom_num=0x%x, begin\n", payload_addr, payload_atom_num));
    for (atom_iter = 0; atom_iter < payload_atom_num; atom_iter++) {
        dma_write_data_ptr = wdma_fifo->read();
        cslDebug((70, "NV_NVDLA_rbk::SendDmaWriteRequest, read from wdma_fifo\n"));
        for(int i=0;i<32;i++)
            cslDebug((70, "0x%02x ", dma_write_data_ptr[i]));
        cslDebug((70, "\n"));
        memcpy (&payload_data_ptr[RUBIK_ATOM_CUBE_SIZE*(atom_iter%2)], dma_write_data_ptr, RUBIK_ATOM_CUBE_SIZE);
        delete[] dma_write_data_ptr;
        // Send write data
        if ( (atom_iter%2) == 1 ) {
            SendDmaWriteRequest (dma_wr_req_data_payload_, dma_delay_);
        }
    }
    // payload_atom_num is a odd number
    if ( (payload_atom_num%2) == 1 ) {
        // Fill the last 32 byte with 0
        memset (&payload_data_ptr[RUBIK_ATOM_CUBE_SIZE], 0, RUBIK_ATOM_CUBE_SIZE);
        SendDmaWriteRequest (dma_wr_req_data_payload_, dma_delay_);
    }
    
    if (ack_required) rbk_done_.notify();

    cslDebug((50, "NV_NVDLA_rbk::SendDmaWriteRequest: payload_addr=0x%lx payload_atom_num=0x%x, end\n", payload_addr, payload_atom_num));
}

void NV_NVDLA_rbk::SendDmaWriteRequest(nvdla_dma_wr_req_t* payload, sc_time& delay, bool ack_required) {
    if (NVDLA_RBK_D_DAOUT_RAM_TYPE_0_DATAOUT_RAM_TYPE_MCIF == rubik_config_wdma_->rbk_dataout_ram_type_) {
        if (TAG_CMD == payload->tag) {
            if (ack_required) {
                payload->pd.dma_write_cmd.require_ack = 1;
            } else {
                payload->pd.dma_write_cmd.require_ack = 0;
            }
        }
        NV_NVDLA_rbk_base::rbk2mcif_wr_req_b_transport(payload, dma_delay_);
    } else {
        if (TAG_CMD == payload->tag) {
            if (ack_required) {
                payload->pd.dma_write_cmd.require_ack = 1;
            } else {
                payload->pd.dma_write_cmd.require_ack = 0;
            }
        }
        NV_NVDLA_rbk_base::rbk2cvif_wr_req_b_transport(payload, dma_delay_);
    }

    if (ack_required) {
        rbk_ack_info *ack = new rbk_ack_info;
        ack->is_mc = rubik_config_wdma_->rbk_dataout_ram_type_ == NVDLA_RBK_D_DAOUT_RAM_TYPE_0_DATAOUT_RAM_TYPE_MCIF;
        ack->group_id = rbk_consumer_;
        cslDebug((30, "%s: DMA transaction with ack is fired, is_mc:%d, group_id:%d\n", __FUNCTION__, ack->is_mc, ack->group_id));
        rbk_ack_fifo_->write(ack);
        //rbk_done_.notify();
    }
}

void NV_NVDLA_rbk::WriteResponseThreadMc() {
    cslDebug((50, "NV_NVDLA_rbk::WriteResponseThreadMc is called\n"));
    if ( true == mcif2rbk_wr_rsp.read() ) {
#if 0
        if (NVDLA_RBK_D_DAOUT_RAM_TYPE_0_DATAOUT_RAM_TYPE_MCIF != rbk_dataout_ram_type_) {
            FAIL(("NV_NVDLA_rbk::WriteResponseThreadMc, dst config is not MC"));
        }
#endif
        cslDebug((50, "mcif2rbk_wr_rsp.read returns true\n"));
        is_mc_ack_done_ = true;
        rbk_mc_ack_.notify();
    }
}

void NV_NVDLA_rbk::WriteResponseThreadCv() {
    cslDebug((50, "NV_NVDLA_rbk::WriteResponseThreadCv is called\n"));
    if ( true == cvif2rbk_wr_rsp.read() ) {
#if 0
        if (NVDLA_RBK_D_DAOUT_RAM_TYPE_0_DATAOUT_RAM_TYPE_CVIF != rbk_dataout_ram_type_) {
            FAIL(("NV_NVDLA_rbk::WriteResponseThreadCv, dst config is not CV"));
        }
#endif
        cslDebug((50, "cvif2rbk_wr_rsp.read returns true\n"));
        is_cv_ack_done_ = true;
        rbk_cv_ack_.notify();
    }
}

#pragma CTC SKIP
NV_NVDLA_rbk * NV_NVDLA_rbkCon(sc_module_name name) {
    return new NV_NVDLA_rbk(name);
}
#pragma CTC ENDSKIP
