// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_pdp.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_pdp.h"
#include "NV_NVDLA_pdp_pdp_gen.h"
#include "NV_NVDLA_pdp_pdp_rdma_gen.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "math.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#include "pdp_hls_wrapper.h"

#define DATA_FORMAT_INT8        NVDLA_PDP_D_DATA_FORMAT_0_INPUT_DATA_INT8
#define DATA_FORMAT_INT16       NVDLA_PDP_D_DATA_FORMAT_0_INPUT_DATA_INT16
#define DATA_FORMAT_FP16        NVDLA_PDP_D_DATA_FORMAT_0_INPUT_DATA_FP16
#define KERNEL_WIDTH_MAX        8
#define PDP_ATOM_PER_TRANSFER   (DMAIF_WIDTH / DLA_ATOM_SIZE)

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

enum PDP_OPERATION_MODE_ALIAS {
    SPLIT_WIDTH_DIS_16B_TO_8B,
    SPLIT_WIDTH_DIS_COMMON,
    SPLIT_WIDTH_EN_16B_TO_8B,
    SPLIT_WIDTH_EN_COMMON
};

// -----------------------------------------------------------------------------
// Functional logic parts and configuration
//              partial_height  input_data_src  split_width data_format
//  RDMA        *               +               *           IN
//  Pipeline    *               *               *           PIPE
//  WDMA        *               -               *           OUT
// -----------------------------------------------------------------------------
// foot notes:
//  - : not awared
//  + : affected by one config space
//  * : affected by more than one config space

NV_NVDLA_pdp::NV_NVDLA_pdp( sc_module_name module_name ):
    NV_NVDLA_pdp_base(module_name),
    // Delay setup
    dma_delay_(SC_ZERO_TIME),
    csb_delay_(SC_ZERO_TIME),
    b_transport_delay_(SC_ZERO_TIME)
{
    sdp2pdp_fifo_ = new sc_core::sc_fifo <uint8_t *> (SDP2PDP_FIFO_ENTRY_NUM);
    rdma_buffer_  = new sc_fifo <uint8_t *> (PDP_RDMA_BUFFER_ENTRY_NUM);
    wdma_buffer_  = new sc_fifo <uint8_t *> (PDP_RDMA_BUFFER_ENTRY_NUM);
    pdp_ack_fifo_     = new sc_fifo <pdp_ack_info*> (2);
    for(int i=0; i < PDP_LINE_BUFFER_ENTRY_NUM; i++)
    {
        line_buffer_usage_free_[i]  = new sc_core::sc_fifo<uint8_t> (1);
        line_buffer_ready_[i]       = new sc_core::sc_fifo<uint8_t> (1);
    }
    dma_rd_req_payload_             = new nvdla_dma_rd_req_t;
    dma_wr_req_cmd_payload_         = new nvdla_dma_wr_req_t;
    dma_wr_req_data_payload_        = new nvdla_dma_wr_req_t;
    dma_wr_req_cmd_payload_->tag    = TAG_CMD;
    dma_wr_req_data_payload_->tag   = TAG_DATA;
    is_mc_ack_done_                 = false;
    is_cv_ack_done_                 = false;
    //sdp2pdp_trans_cnt               = 0;
    Reset();
    // SC_THREAD
    SC_THREAD(PdpRdmaConsumerThread)
    SC_THREAD(PdpConsumerThread)
    SC_THREAD(PoolingStage0SequenceThread)
    SC_THREAD(PoolingStage1SequenceThread)
    SC_THREAD(PdpRdmaSequenceThread)
    SC_THREAD(PdpWdmaSequenceThread)
    SC_THREAD(PdpIntrThread)
    // SC_THREAD()
    SC_METHOD(WriteResponseThreadMc);
    sensitive << mcif2pdp_wr_rsp;
    SC_METHOD(WriteResponseThreadCv);
    sensitive << cvif2pdp_wr_rsp;
}

#pragma CTC SKIP
NV_NVDLA_pdp::~NV_NVDLA_pdp () {
    if (sdp2pdp_fifo_)                  delete sdp2pdp_fifo_;
    if (rdma_buffer_)                   delete rdma_buffer_;
    if( wdma_buffer_ )                  delete wdma_buffer_;
    if (dma_rd_req_payload_)            delete dma_rd_req_payload_;
    if (dma_wr_req_cmd_payload_)        delete dma_wr_req_cmd_payload_;
    if (dma_wr_req_data_payload_)       delete dma_wr_req_data_payload_;
    if( pdp_ack_fifo_)         delete pdp_ack_fifo_;
}
#pragma CTC ENDSKIP

void NV_NVDLA_pdp::PdpIntrThread() {
    while (true) {
        while (uint32_t(pdp_ack_fifo_->num_available()) < 1) {
            wait( pdp_ack_fifo_->data_written_event() );
        }
        pdp_ack_info *ack = pdp_ack_fifo_->read();

        if (ack->is_mc) {
            if (!is_mc_ack_done_)
                wait(pdp_mc_ack_);

            is_mc_ack_done_ = false;
        } else {
            if (!is_cv_ack_done_)
                wait(pdp_cv_ack_);

            is_cv_ack_done_ = false;
        }

        wait(1, SC_NS);
        pdp2glb_done_intr[ack->group_id].write(true);

        delete ack;
    }
}

void NV_NVDLA_pdp::PdpRdmaConsumerThread() {
    while (true) {
        while(PdpRdmaGetOpeartionEnable(pdp_rdma_register_group_0) != NVDLA_PDP_RDMA_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_pdp_rdma_reg_group_0_operation_enable);
        }
        pdp_rdma_reg_model::PdpRdmaUpdateWorkingStatus(0,1);
        PdpRdmaConfigEvaluation(pdp_rdma_register_group_0);
        PdpRdmaHardwareLayerExecutionTrigger();
        pdp_rdma_reg_model::PdpRdmaUpdateWorkingStatus(0,0);
        pdp_rdma_reg_model::PdpRdmaClearOpeartionEnable(pdp_rdma_register_group_0);

        while(PdpRdmaGetOpeartionEnable(pdp_rdma_register_group_1) != NVDLA_PDP_RDMA_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_pdp_rdma_reg_group_1_operation_enable);
        }
        pdp_rdma_reg_model::PdpRdmaUpdateWorkingStatus(1,1);
        PdpRdmaConfigEvaluation(pdp_rdma_register_group_1);
        PdpRdmaHardwareLayerExecutionTrigger();
        pdp_rdma_reg_model::PdpRdmaUpdateWorkingStatus(1,0);
        pdp_rdma_reg_model::PdpRdmaClearOpeartionEnable(pdp_rdma_register_group_1);
    }
}

void NV_NVDLA_pdp::PdpConsumerThread() {
    while (true) {
        while(PdpGetOpeartionEnable(pdp_register_group_0) != NVDLA_PDP_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_pdp_reg_group_0_operation_enable);
        }
        pdp_reg_model::PdpUpdateWorkingStatus(0,1);
        PdpConfigEvaluation(pdp_register_group_0);
        PdpHardwareLayerExecutionTrigger();
        pdp_reg_model::PdpUpdateWorkingStatus(0,0);
        pdp_reg_model::PdpClearOpeartionEnable(pdp_register_group_0);

        while(PdpGetOpeartionEnable(pdp_register_group_1) != NVDLA_PDP_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_pdp_reg_group_1_operation_enable);
        }
        pdp_reg_model::PdpUpdateWorkingStatus(1,1);
        PdpConfigEvaluation(pdp_register_group_1);
        PdpHardwareLayerExecutionTrigger();
        pdp_reg_model::PdpUpdateWorkingStatus(1,0);
        pdp_reg_model::PdpClearOpeartionEnable(pdp_register_group_1);
    }
}

void NV_NVDLA_pdp::PdpRdmaConfigEvaluation(CNVDLA_PDP_RDMA_REGSET *register_group_ptr) {
    pdp_rdma_reg_model::PdpRdmaUpdateVariables(register_group_ptr);
    if (pdp_rdma_split_num_ == 0 ) {
        pdp_rdma_operation_mode_         = SPLIT_WIDTH_DIS_COMMON;
    } else {
        pdp_rdma_operation_mode_         = SPLIT_WIDTH_EN_COMMON;
    }
}

void NV_NVDLA_pdp::PdpRdmaHardwareLayerExecutionTrigger(){
    pdp_rdma_kickoff_.notify();
    wait(pdp_rdma_done_);
}

void NV_NVDLA_pdp::PdpRdmaSequenceThread(){
    uint32_t partial_width_in_first;
    uint32_t partial_width_in_mid;
    uint32_t partial_width_in_last;
    uint32_t kernel_width;
    uint32_t kernel_stride_width;
    uint32_t cube_in_width;
    uint64_t src_base_addr;
     int32_t split_offset;
    uint32_t split_iter;
    uint32_t split_num;

    while (true) {
        wait(pdp_rdma_kickoff_);

        partial_width_in_first  = pdp_rdma_partial_width_in_first_ + 1;
        partial_width_in_mid    = pdp_rdma_partial_width_in_mid_   + 1;
        partial_width_in_last   = pdp_rdma_partial_width_in_last_  + 1;
        kernel_width            = pdp_rdma_kernel_width_ + 1;
        kernel_stride_width     = pdp_rdma_kernel_stride_width_ + 1;

        split_num = pdp_rdma_split_num_ + 1;
        switch (pdp_rdma_operation_mode_) {
#pragma CTC SKIP
            case SPLIT_WIDTH_DIS_16B_TO_8B:
                FAIL(("NV_NVDLA_pdp::PdpRdmaSequenceThread, SPLIT_WIDTH_DIS_16B_TO_8B has not been implemented\n"));
                // RdmaSequence16Bto8B();
                break;
#pragma CTC ENDSKIP
            case SPLIT_WIDTH_DIS_COMMON:
                src_base_addr = uint64_t(pdp_rdma_src_base_addr_high_) << 32 | uint64_t(pdp_rdma_src_base_addr_low_);
                cube_in_width = pdp_rdma_cube_in_width_ + 1;
                cslDebug((30, "PdpRdmaSequenceThread, split disabled. before RdmaSequenceCommon. src_base_addr=0x%lx cube_in_width=0x%x\n", src_base_addr, cube_in_width));
                RdmaSequenceCommon(src_base_addr, cube_in_width);
                cslDebug((30, "PdpRdmaSequenceThread, split disabled. after RdmaSequenceCommon\n"));
                break;
#pragma CTC SKIP
            case SPLIT_WIDTH_EN_16B_TO_8B:
                FAIL(("NV_NVDLA_pdp::PdpRdmaSequenceThread, SPLIT_WIDTH_EN_16B_TO_8B has not been implemented\n"));
                // RdmaSequence16Bto8B();
                break;
#pragma CTC ENDSKIP
            case SPLIT_WIDTH_EN_COMMON:
                for (split_iter = 0; split_iter < split_num; split_iter ++) {
                    if (0 == split_iter) {
                        // The first split width
                        src_base_addr = uint64_t(pdp_rdma_src_base_addr_high_) << 32 | uint64_t(pdp_rdma_src_base_addr_low_);
                        cube_in_width = partial_width_in_first;
                    } else if ( split_num - uint32_t(1) == split_iter ) {
                        // The last split width
                        //Note: kernel_stride_width may be larger than kernel_width
                        src_base_addr = uint64_t(pdp_rdma_src_base_addr_high_) << 32 | uint64_t(pdp_rdma_src_base_addr_low_);
                        split_offset = (partial_width_in_first + (split_iter-1)*partial_width_in_mid - (kernel_width - kernel_stride_width)) * DLA_ATOM_SIZE;
                        src_base_addr += (int64_t)split_offset;
                        cube_in_width = partial_width_in_last + (kernel_width - kernel_stride_width);
                    } else {
                        //Note: kernel_stride_width may be larger than kernel_width
                        src_base_addr = uint64_t(pdp_rdma_src_base_addr_high_) << 32 | uint64_t(pdp_rdma_src_base_addr_low_);
                        split_offset = (partial_width_in_first + (split_iter-1)*partial_width_in_mid - (kernel_width - kernel_stride_width)) * DLA_ATOM_SIZE;
                        src_base_addr += (int64_t)split_offset;
                        cube_in_width = partial_width_in_mid + (kernel_width - kernel_stride_width);
                    }
                    cslDebug((30, "PdpRdmaSequenceThread, split iter %d. before RdmaSequenceCommon. src_base_addr=0x%lx cube_in_width=0x%x\n", split_iter, src_base_addr, cube_in_width));
                    RdmaSequenceCommon(src_base_addr, cube_in_width);
                    cslDebug((30, "PdpRdmaSequenceThread, split enabled. after RdmaSequenceCommon\n"));
                }
                break;
#pragma CTC SKIP
            default: 
                break;
#pragma CTC ENDSKIP
        }
        pdp_rdma_done_.notify();
    }
}

void NV_NVDLA_pdp::PdpConfigEvaluation(CNVDLA_PDP_REGSET *register_group_ptr) {
    pdp_reg_model::PdpUpdateVariables(register_group_ptr);
    // overlapped_line_num_        = max(pdp_kernel_height_/pdp_kernel_stride_height_,1);
    pdp_ready_to_receive_data_  = true;
    if (pdp_split_num_ == 0) {
        pdp_operation_mode_         = SPLIT_WIDTH_DIS_COMMON;
    } else {
        pdp_operation_mode_         = SPLIT_WIDTH_EN_COMMON;
    }
}

void NV_NVDLA_pdp::PdpHardwareLayerExecutionTrigger() {
    reset_stats_regs();
    pdp_kickoff_.notify();
    wait(pdp_done_);
    pdp_ready_to_receive_data_  = false;
    update_stats_regs();
}

void NV_NVDLA_pdp::RdmaSequenceCommon(uint64_t src_base_addr, uint32_t cube_in_width) {
    // Config variables, they have corresponding value in registers
    uint32_t cube_in_height, cube_in_channel;
    uint64_t src_line_stride, src_surface_stride;
    uint32_t element_per_atom;
    // Control variables
    // # Iterators
    uint32_t surface_iter;
    uint32_t surface_num;
    uint32_t height_iter;
    // # 
    bool     is_src_line_packed;
    uint64_t payload_addr;
    uint32_t payload_atom_num;
    // Temp variables

    // Copy from register value to local config variables, similar with RTL connection
    // overlapped_line_num = pdp_overlapped_line_num_;
    cube_in_height      = pdp_rdma_cube_in_height_+1;
    cube_in_channel     = pdp_rdma_cube_in_channel_+1;
    // RDMA read sequence does not support partial height
    src_line_stride     = pdp_rdma_src_line_stride_;
    src_surface_stride  = pdp_rdma_src_surface_stride_;

    // Modified. If mode_split is true, is_src_line_packed should always be false.
    if ( src_line_stride == DLA_ATOM_SIZE * cube_in_width ) {
        is_src_line_packed = true;
    } else {
        is_src_line_packed = false;
    }
/*
    if(pdp_rdma_split_num_ > 0)
    {
        assert(is_src_line_packed == false);
    }
*/
    // In current RTL design (2016/08/01), the dma request doesn't cross lines. So set is_src_line_packed to false.
    is_src_line_packed = false;

    switch (pdp_rdma_input_data_) {
        case DATA_FORMAT_IS_INT8: {
                element_per_atom = ELEMENT_PER_ATOM_INT8;
                break;
            }
        case DATA_FORMAT_IS_INT16: {
                element_per_atom = ELEMENT_PER_ATOM_INT16;
                break;
            }
        case DATA_FORMAT_IS_FP16: {
                element_per_atom = ELEMENT_PER_ATOM_FP16;
                break;
            }
#pragma CTC SKIP
        default: break;
#pragma CTC ENDSKIP
    }

    // For block sequence looping
    surface_num = (cube_in_channel + element_per_atom - 1)/element_per_atom;
    for (surface_iter = 0; surface_iter<surface_num; surface_iter ++) {
#pragma CTC SKIP
        if (true == is_src_line_packed) {
            // Line packed, sent request across lines
            /*                atom_num        = cube_in_width * ((block_iter_height==block_num_height-1)?partial_height:(partial_height_last));
                              atom_sent_num   = 0;
                              payload_addr    = src_base_addr + block_iter_height * partial_height * src_line_stride + surface_iter * src_surface_stride;
                              while (atom_sent_num < atom_num) {
            // Calculate payload size, payload transaction must be within a 256 byte
            payload_size        = MAX_MEM_TRANSACTION_SIZE - payload_addr%MAX_MEM_TRANSACTION_SIZE;
            // Payload transaction shall not larger than rest of atom cube number
            payload_atom_num    = min(atom_num-atom_sent_num, payload_size/DLA_ATOM_SIZE);
            payload_size        = payload_atom_num*DLA_ATOM_SIZE;
          // Prepare payload
            dma_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr;
            dma_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num-1;
            // Check are there sufficient entries in RDMA buffer 
            WaitUntilRdmaBufferFreeSizeGreaterThan(payload_atom_num);
            // Send read request to RDMA
            SendDmaReadRequest(dma_rd_req_payload_, dma_delay_);
            // Increase
            payload_addr    += payload_size;
            atom_sent_num   += payload_atom_num;
            }
            */            
        } 
#pragma CTC ENDSKIP
        else {
            // Line unpacked, sent one request for each line
            for (height_iter=0; height_iter<cube_in_height; height_iter++) {
                payload_addr        = src_base_addr + height_iter * src_line_stride + surface_iter * src_surface_stride;
                payload_atom_num    = cube_in_width;
                // Prepare payload
                dma_rd_req_payload_->pd.dma_read_cmd.addr = payload_addr;
                dma_rd_req_payload_->pd.dma_read_cmd.size = payload_atom_num-1;
                // Check are there sufficient entries in RDMA buffer 
                //WaitUntilRdmaBufferFreeSizeGreaterThan(payload_atom_num);

                // Send read request to RDMA
                SendDmaReadRequest(dma_rd_req_payload_, dma_delay_);
            }
        }
    }
}

// Line buffer allocation
//                                           +=================+
//            /                 /            +<<<<<<<<<<<<<<<<<+
//            |   cross section |            +<<<<<<<<<<<<<<<<<+
//            |     max is 8    |            +<<<<<<<<<<<<<<<<<+
//            |                 |            +<<<<<<<<<<<<<<<<<+
//            |                 \            +<<<<<<<<<<<<<<<<<+
//            |                              +-----------------+
//            |                 /            +<<<<<<<<<<<<<<<<<+
// Surface 0  |   cross section |            +<<<<<<<<<<<<<<<<<+
//            |     max is 8    |            +<<<<<<<<<<<<<<<<<+
//            |                 |            +<<<<<<<<<<<<<<<<<+
//            |                 \            +<<<<<<<<<<<<<<<<<+
//            |                              +-----------------+
//            |                 /            +<<<<<<<<<<<<<<<<<+
//            |   cross section |            +<<<<<<<<<<<<<<<<<+
//            |     max is 8    |            +<<<<<<<<<<<<<<<<<+
//            |                 |            +<<<<<<<<<<<<<<<<<+
//            \                 \            +<<<<<<<<<<<<<<<<<+
//                                           +=================+
void NV_NVDLA_pdp::PoolingStage0SequenceCommon(uint32_t cube_in_width, uint32_t pad_left, uint32_t pad_right, uint32_t acc_subcube_out_width, uint32_t cube_out_width) {
    // Config variables, they have corresponding value in registers
    // uint32_t overlapped_line_num;
    // bool     pdp_is_src_line_packed;
    uint32_t cube_in_height, cube_in_channel;
    uint32_t kernel_width, kernel_height;
    uint32_t kernel_stride_width, kernel_stride_height;
    uint32_t pad_top, pad_bottom;
    uint32_t precision;
    // Control variables
    uint32_t surface_iter;
    uint32_t surface_num;
    uint32_t width_iter, height_iter;
    uint32_t kernel_width_iter, kernel_height_iter;
    uint32_t idx_atom_width_out, idx_atom_height_out;
    uint32_t kernel_per_group;
    uint32_t overlapped_kernel_max_num_width;
    // Temp variables
    uint8_t  * atomic_cube;
    int8_t   * atomic_cube_ptr_int8;
    int16_t  * atomic_cube_ptr_int16;
    uint16_t * atomic_cube_ptr_fp16;
    int16_t  * line_buffer_ptr_int8;    //Use 16bits for INT8 to keep precision
    int32_t  * line_buffer_ptr_int16;   //Use 32bits for INT16 to keep precision
    uint32_t * line_buffer_ptr_fp16;    //Use 32bits for FP16 to keep precision
    int16_t  * line_operation_buffer_ptr_int8;    //Use 16bits for INT8 to keep precision
    int32_t  * line_operation_buffer_ptr_int16;   //Use 32bits for INT16 to keep precision
    uint32_t * line_operation_buffer_ptr_fp16;    //Use 32bits for FP16 to keep precision
    int16_t  * padding_value_array_ptr_int8;    //Use 16bits for INT8 to keep precision
    int32_t  * padding_value_array_ptr_int16;   //Use 32bits for INT16 to keep precision
    uint32_t * padding_value_array_ptr_fp16;    //Use 32bits for FP16 to keep precision
    bool    is_first_element;
    bool    is_last_element;

    bool    valid_width_iter;
    bool    valid_height_iter;
    uint32_t padding_value_array[PDP_MAX_PADDING_SIZE];

    line_buffer_ptr_int8  = reinterpret_cast <int16_t *> (line_buffer_);
    line_buffer_ptr_int16 = reinterpret_cast <int32_t *> (line_buffer_);
    line_buffer_ptr_fp16  = reinterpret_cast <uint32_t *> (line_buffer_);

    line_operation_buffer_ptr_int8  = reinterpret_cast <int16_t *>  (line_operation_buffer_);
    line_operation_buffer_ptr_int16 = reinterpret_cast <int32_t *>  (line_operation_buffer_);
    line_operation_buffer_ptr_fp16  = reinterpret_cast <uint32_t *> (line_operation_buffer_);

    padding_value_array_ptr_int8  = reinterpret_cast <int16_t *>    (padding_value_array);
    padding_value_array_ptr_int16 = reinterpret_cast <int32_t *>    (padding_value_array);
    padding_value_array_ptr_fp16  = reinterpret_cast <uint32_t *>   (padding_value_array);

    // Copy from register value to local config variables, similar with RTL connection
    // overlapped_line_num = pdp_overlapped_line_num_;
    cube_in_height      = pdp_cube_in_height_+1;
    cube_in_channel     = pdp_cube_in_channel_+1;
    kernel_width        = pdp_kernel_width_+1;
    kernel_height       = pdp_kernel_height_+1;
    kernel_stride_width = pdp_kernel_stride_width_+1;
    kernel_stride_height= pdp_kernel_stride_height_+1;
    pad_top             = pdp_pad_top_;
    pad_bottom          = pdp_pad_bottom_;
    precision           = pdp_input_data_;
    //if ((kernel_width < kernel_stride_width) || (kernel_height < kernel_stride_height))
    //    FAIL(("NV_NVDLA_pdp::PoolingStage0SequenceCommon, invalid pooling configuration."));

    overlapped_kernel_max_num_width = (kernel_width+kernel_stride_width-1)/kernel_stride_width;

    switch (precision) {
        case DATA_FORMAT_INT8:
            kernel_per_group = KERNEL_PER_GROUP_INT8;
            int_sign_extend(pdp_pad_value_1x_,7,32 , &padding_value_array_ptr_int8[0]);
            int_sign_extend(pdp_pad_value_2x_,8,32 , &padding_value_array_ptr_int8[1]);
            int_sign_extend(pdp_pad_value_3x_,9,32 , &padding_value_array_ptr_int8[2]);
            int_sign_extend(pdp_pad_value_4x_,9,32 , &padding_value_array_ptr_int8[3]);
            int_sign_extend(pdp_pad_value_5x_,10,32, &padding_value_array_ptr_int8[4]);
            int_sign_extend(pdp_pad_value_6x_,10,32, &padding_value_array_ptr_int8[5]);
            int_sign_extend(pdp_pad_value_7x_,10,32, &padding_value_array_ptr_int8[6]);
            break;
        case DATA_FORMAT_INT16:
            kernel_per_group = KERNEL_PER_GROUP_INT16;
            int_sign_extend(pdp_pad_value_1x_,15, 32, &padding_value_array_ptr_int16[0]);
            int_sign_extend(pdp_pad_value_2x_,16, 32, &padding_value_array_ptr_int16[1]);
            int_sign_extend(pdp_pad_value_3x_,17, 32, &padding_value_array_ptr_int16[2]);
            int_sign_extend(pdp_pad_value_4x_,17, 32, &padding_value_array_ptr_int16[3]);
            int_sign_extend(pdp_pad_value_5x_,18, 32, &padding_value_array_ptr_int16[4]);
            int_sign_extend(pdp_pad_value_6x_,18, 32, &padding_value_array_ptr_int16[5]);
            int_sign_extend(pdp_pad_value_7x_,18, 32, &padding_value_array_ptr_int16[6]);
            break;
        case DATA_FORMAT_FP16:
            kernel_per_group = KERNEL_PER_GROUP_FP16;
            padding_value_array_ptr_fp16[0] = pdp_pad_value_1x_;
            padding_value_array_ptr_fp16[1] = pdp_pad_value_2x_;
            padding_value_array_ptr_fp16[2] = pdp_pad_value_3x_;
            padding_value_array_ptr_fp16[3] = pdp_pad_value_4x_;
            padding_value_array_ptr_fp16[4] = pdp_pad_value_5x_;
            padding_value_array_ptr_fp16[5] = pdp_pad_value_6x_;
            padding_value_array_ptr_fp16[6] = pdp_pad_value_7x_;
            break;
#pragma CTC SKIP
        default:
            FAIL(("NV_NVDLA_pdp::PoolingStage0SequenceCommon, invalid precision setting."));
#pragma CTC ENDSKIP
    }

    // For block sequence looping
    surface_num = (cube_in_channel + kernel_per_group - 1)/kernel_per_group;
    for (surface_iter = 0; surface_iter<surface_num; surface_iter ++) {
        for (height_iter=0; height_iter<cube_in_height; height_iter++) {
            for (width_iter=0; width_iter<cube_in_width; width_iter++) {    // Loop on each element in current line
                // Fetch data (32B) from upstream
                // FetchInputData ( reinterpret_cast <uint8_t *> (atomic_cube) );
                cslDebug((50, "NV_NVDLA_pdp::PoolingStage0SequenceCommon, fetch input data s=%d of %d, h=%d of %d, w=%d of %d\n", surface_iter, surface_num, height_iter, cube_in_height, width_iter, cube_in_width));
                atomic_cube = FetchInputData ();
                atomic_cube_ptr_int8  = reinterpret_cast <int8_t *> (atomic_cube);
                atomic_cube_ptr_int16 = reinterpret_cast <int16_t *> (atomic_cube);
                atomic_cube_ptr_fp16  = reinterpret_cast <uint16_t *> (atomic_cube);

                if(precision == DATA_FORMAT_FP16)
                {
                    for(int element_iter = 0; element_iter < ELEMENT_PER_ATOM_FP16; element_iter++)
                    {
                        uint32_t exp = (atomic_cube_ptr_fp16[element_iter] >> 10) & 0x1f;
                        uint32_t frac = atomic_cube_ptr_fp16[element_iter] & 0x3ff;
                        if(POOLING_FLYING_MODE_OFF_FLYING == pdp_flying_mode_ && pdp_nan_to_zero_ && exp == 0x1f && frac != 0) atomic_cube_ptr_fp16[element_iter] = 0; //nan flush to zero
                    }
                }

                // For input element at (width_iter, height_iter), count it into all the output element which depends on it
                for (kernel_width_iter = 0; kernel_width_iter < kernel_width; kernel_width_iter++) {
                    valid_width_iter = (pad_left + width_iter >= kernel_width_iter) &&                                                     //Left boundary
                                       ((pad_left + width_iter + (kernel_width - kernel_width_iter) <= pad_left + pad_right + cube_in_width)) &&  //Right boundary
                                       ((pad_left + width_iter - kernel_width_iter)%kernel_stride_width == 0);
                    idx_atom_width_out = (pad_left + width_iter - kernel_width_iter)/kernel_stride_width;
                    if (valid_width_iter) {
#if 1   //just for debug
                        for (kernel_height_iter = 0; kernel_height_iter < kernel_height; kernel_height_iter++) {
                            valid_height_iter = (pad_top + height_iter >= kernel_height_iter) &&                                        //Top boundary
                                                ((pad_top + height_iter + (kernel_height - kernel_height_iter) <= pad_top + pad_bottom + cube_in_height)) &&  //Bottom boundary
                                                ((pad_top + height_iter - kernel_height_iter)%kernel_stride_height == 0);
                            idx_atom_height_out = (pad_top + height_iter - kernel_height_iter)/kernel_stride_height;
                            if(valid_height_iter)
                            {
                                cslDebug((50, "Input s=%d w=%d h=%d maps to output w=%d h=%d, data: ", surface_iter, width_iter, height_iter, idx_atom_width_out, idx_atom_height_out));
                                for(int i=0; i<DLA_ATOM_SIZE; i++) cslDebug((50, "%02x ", atomic_cube[i]));
                                cslDebug((50, "\n"));
                            }
                        }
#endif
						uint32_t lob_idx = idx_atom_width_out%overlapped_kernel_max_num_width;
                        // Do line opertion
                        cslDebug((50, "kernel_width_iter:0x%02x, idx_atom_width_out:0x%02x lob_idx:%d\n", kernel_width_iter, idx_atom_width_out, lob_idx));
                        switch (precision) {
                            case DATA_FORMAT_INT8:
                                cslDebug((50, "Line_operation_buffer_atom_address:0x%04x, Line_operation_buffer_address:0x%08x\n", lob_idx, lob_idx*ELEMENT_PER_ATOM_INT8));
                                LineOperation (atomic_cube_ptr_int8, &line_operation_buffer_ptr_int8[lob_idx*ELEMENT_PER_ATOM_INT8], kernel_width_iter, kernel_width, width_iter, cube_in_width, padding_value_array_ptr_int8, ELEMENT_PER_ATOM_INT8, pad_left);
                                break;
                            case DATA_FORMAT_INT16:
                                cslDebug((50, "Line_operation_buffer_atom_address:0x%04x, Line_operation_buffer_address:0x%08x\n", lob_idx, lob_idx*ELEMENT_PER_ATOM_INT16));
                                LineOperation (atomic_cube_ptr_int16, &line_operation_buffer_ptr_int16[lob_idx*ELEMENT_PER_ATOM_INT16], kernel_width_iter, kernel_width, width_iter, cube_in_width, padding_value_array_ptr_int16, ELEMENT_PER_ATOM_INT16, pad_left);
                                break;
                            case DATA_FORMAT_FP16:
								cslDebug((50, "Line_operation_buffer_atom_address:0x%04x, Line_operation_buffer_address:0x%08x\n", lob_idx, lob_idx*ELEMENT_PER_ATOM_FP16));
								LineOperation (atomic_cube_ptr_fp16, &line_operation_buffer_ptr_fp16[lob_idx*ELEMENT_PER_ATOM_FP16], kernel_width_iter, kernel_width, width_iter, cube_in_width, padding_value_array_ptr_fp16, ELEMENT_PER_ATOM_FP16, pad_left);
								break;
#pragma CTC SKIP
                            default:
                                break;
#pragma CTC ENDSKIP
                        }
                        // if it's the right most kernel element, or it's the right most width element, do operation with line buffer
                        if ( (kernel_width_iter + 1 == kernel_width) || ( (width_iter + kernel_width - kernel_width_iter > cube_in_width) && (width_iter + 1 == cube_in_width) ) ) {
                            for (kernel_height_iter = 0; kernel_height_iter < kernel_height; kernel_height_iter++) {
                                valid_height_iter = (pad_top + height_iter >= kernel_height_iter) &&                                        //Top boundary
                                                    ((pad_top + height_iter + (kernel_height - kernel_height_iter) <= pad_top + pad_bottom + cube_in_height)) &&  //Bottom boundary
                                                    ((pad_top + height_iter - kernel_height_iter)%kernel_stride_height == 0);
                                idx_atom_height_out = (pad_top + height_iter - kernel_height_iter)/kernel_stride_height;
                                cslDebug((50, "kernel_height_iter:0x%02x, idx_atom_height_out:0x%02x\n", kernel_height_iter, idx_atom_height_out));
                                if (valid_height_iter) {
                                    uint32_t atomic_stride   = uint32_t(DLA_ATOM_SIZE) * 2;     //In size of Byte. INT8 uses 2bytes, INT16 and FP16 uses 4bytes
                                    uint32_t line_stride     = cube_out_width * atomic_stride;
                                    uint32_t surf_stride     = (pdp_cube_out_height_+1) * line_stride;
                                    uint32_t acc_subcube_start = (pdp_cube_out_height_+1) * acc_subcube_out_width * surface_num * atomic_stride;
                                    uint32_t output_size = (precision == DATA_FORMAT_INT8)? 2 : 4;
                                    uint32_t linebuf_start_idx = ((acc_subcube_start + surface_iter * surf_stride + idx_atom_height_out * line_stride + idx_atom_width_out * atomic_stride)%sizeof(line_buffer_))/output_size;
                                    uint32_t linebuf_entry_idx = linebuf_start_idx * output_size / atomic_stride;
                                    // The first input (left most and up most) element which contributes to the same output element
                                    is_first_element = IsContributeToANewLine(height_iter, kernel_height_iter);
                                    cslDebug((50, "is_first_element=%d surface_iter=0x%x height_iter=0x%x width_iter=0x%x kernel_width_iter=0x%x kernel_height_iter=0x%x\n", is_first_element, surface_iter, height_iter, width_iter, kernel_width_iter, kernel_height_iter));

                                    if (is_first_element) 
                                    {
                                        cslDebug((50, "attempt writing to line_buffer_usage_free_[%d]\n", linebuf_entry_idx));
                                        line_buffer_usage_free_[linebuf_entry_idx]->write(1);  //hold space of one atom in line buffer. the space will be released in stage1
                                        cslDebug((50, "wrote to line_buffer_usage_free_[%d]\n", linebuf_entry_idx));
                                    }

                                    switch (precision) {
                                        case DATA_FORMAT_INT8:
                                            PoolingStage0Calc (&line_operation_buffer_ptr_int8[lob_idx*ELEMENT_PER_ATOM_INT8], line_buffer_ptr_int8, idx_atom_width_out, idx_atom_height_out, surface_iter, cube_in_height, kernel_height_iter, kernel_height, height_iter, padding_value_array_ptr_int8, ELEMENT_PER_ATOM_INT8, surface_num, acc_subcube_out_width, cube_out_width);
                                            break;
                                        case DATA_FORMAT_INT16:
                                            PoolingStage0Calc (&line_operation_buffer_ptr_int16[lob_idx*ELEMENT_PER_ATOM_INT16], line_buffer_ptr_int16, idx_atom_width_out, idx_atom_height_out, surface_iter, cube_in_height, kernel_height_iter, kernel_height, height_iter, padding_value_array_ptr_int16, ELEMENT_PER_ATOM_INT16, surface_num, acc_subcube_out_width, cube_out_width);
                                            break;
                                        case DATA_FORMAT_FP16:
											PoolingStage0Calc (&line_operation_buffer_ptr_fp16[lob_idx*ELEMENT_PER_ATOM_FP16], line_buffer_ptr_fp16, idx_atom_width_out, idx_atom_height_out, surface_iter, cube_in_height, kernel_height_iter, kernel_height, height_iter, padding_value_array_ptr_fp16, ELEMENT_PER_ATOM_FP16, surface_num, acc_subcube_out_width, cube_out_width);
                                            break;
#pragma CTC SKIP
                                        default:
                                            break;
#pragma CTC ENDSKIP
                                    }
                                    // If it is the last (right most and down most) element, incr incr_line_buffer_available_atom_
                                    is_last_element = IsLastElement(cube_in_width, pad_left, width_iter, height_iter, kernel_width_iter, kernel_height_iter);
                                    cslDebug((50, "is_last_element=%d surface_iter=0x%x height_iter=0x%x width_iter=0x%x kernel_width_iter=0x%x kernel_height_iter=0x%x\n", is_last_element, surface_iter, height_iter, width_iter, kernel_width_iter, kernel_height_iter));
                                    if (is_last_element)
                                    {
                                        cslDebug((50, "write to line_buffer_ready_[%d], out h=%d, out w=%d\n", linebuf_entry_idx, idx_atom_height_out, idx_atom_width_out));
                                        line_buffer_ready_[linebuf_entry_idx]->write(1);
                                    }
                                }
                            }
                        }
                    }
                }
#pragma CTC SKIP
                if(atomic_cube) delete [] atomic_cube;
#pragma CTC ENDSKIP
            }
        }
    }
}

#pragma CTC SKIP
// Input precision is int8, processing precision is int8
void NV_NVDLA_pdp::PoolingStage0Sequence8Bto8B() {
}
#pragma CTC ENDSKIP

void NV_NVDLA_pdp::PoolingStage1SequenceCommon(uint32_t cube_out_width, uint32_t acc_subcube_out_width, uint32_t pad_left, uint32_t pad_right, uint32_t cube_in_width) {
    // Config variables, they have corresponding value in registers
    // uint32_t overlapped_line_num;
    // bool     pdp_is_src_line_packed;
    uint32_t cube_in_channel;
    uint32_t cube_out_height;
    uint32_t precision;
    // Control variables
    // # Iterators
    uint32_t surface_iter;
    uint32_t surface_num;
    // uint32_t input_width_iter, input_height_iter;
    uint32_t output_width_iter;
    uint32_t output_height_iter;
    // uint32_t atom_iter;
    // uint32_t kernel_width_iter, kernel_height_iter;
    // uint32_t idx_atom_width_out, idx_atom_height_out;
    // uint32_t idx_atom_width_out_prev, idx_atom_height_out_prev;
    uint32_t kernel_per_group;
    // # Temp variables
    uint8_t  * atomic_cube;
    int8_t   * atomic_cube_ptr_int8;
    int16_t  * atomic_cube_ptr_int16;
    uint16_t * atomic_cube_ptr_fp16;
    int16_t  * line_buffer_ptr_int8;
    int32_t  * line_buffer_ptr_int16;
    uint32_t * line_buffer_ptr_fp16;
    // int16_t  * padding_value_array_ptr_int8;    //Use 16bits for INT8 to keep precision
    // int32_t  * padding_value_array_ptr_int16;   //Use 32bits for INT16 to keep precision
    // uint32_t * padding_value_array_ptr_fp16;    //Use 32bits for FP16 to keep precision
    // uint32_t padding_value_array[PDP_MAX_PADDING_SIZE];
    // padding_value_array_ptr_int8  = reinterpret_cast <int16_t *>    (padding_value_array);
    // padding_value_array_ptr_int16 = reinterpret_cast <int32_t *>    (padding_value_array);
    // padding_value_array_ptr_fp16  = reinterpret_cast <uint32_t *>   (padding_value_array);

    // Copy from register value to local config variables, similar with RTL connection
    // overlapped_line_num = pdp_overlapped_line_num_;
    cube_in_channel     = pdp_cube_in_channel_+1;
    cube_out_height     = pdp_cube_out_height_+1;
    //kernel_width        = pdp_kernel_width_+1;
    precision           = pdp_input_data_;

    switch (precision) {
        case DATA_FORMAT_INT8:
            kernel_per_group = KERNEL_PER_GROUP_INT8;
            // int_sign_extend(pdp_pad_value_1x_,7,32 , &padding_value_array_ptr_int16[0]);
            // int_sign_extend(pdp_pad_value_2x_,8,32 , &padding_value_array_ptr_int16[1]);
            // int_sign_extend(pdp_pad_value_3x_,9,32 , &padding_value_array_ptr_int16[2]);
            // int_sign_extend(pdp_pad_value_4x_,9,32 , &padding_value_array_ptr_int16[3]);
            // int_sign_extend(pdp_pad_value_5x_,10,32, &padding_value_array_ptr_int16[4]);
            // int_sign_extend(pdp_pad_value_6x_,10,32, &padding_value_array_ptr_int16[5]);
            // int_sign_extend(pdp_pad_value_7x_,10,32, &padding_value_array_ptr_int16[6]);
            break;
        case DATA_FORMAT_INT16:
            kernel_per_group = KERNEL_PER_GROUP_INT16;
            // int_sign_extend(pdp_pad_value_1x_,15, 32, &padding_value_array_ptr_int16[0]);
            // int_sign_extend(pdp_pad_value_2x_,16, 32, &padding_value_array_ptr_int16[1]);
            // int_sign_extend(pdp_pad_value_3x_,17, 32, &padding_value_array_ptr_int16[2]);
            // int_sign_extend(pdp_pad_value_4x_,17, 32, &padding_value_array_ptr_int16[3]);
            // int_sign_extend(pdp_pad_value_5x_,18, 32, &padding_value_array_ptr_int16[4]);
            // int_sign_extend(pdp_pad_value_6x_,18, 32, &padding_value_array_ptr_int16[5]);
            // int_sign_extend(pdp_pad_value_7x_,18, 32, &padding_value_array_ptr_int16[6]);
            break;
        case DATA_FORMAT_FP16:
            kernel_per_group = KERNEL_PER_GROUP_FP16;
            break;
#pragma CTC SKIP
        default:
            FAIL(("NV_NVDLA_pdp::PoolingStage1SequenceCommon, invalid precision setting."));
#pragma CTC ENDSKIP
    }
    // For block sequence looping
    surface_num = (cube_in_channel + kernel_per_group - 1)/kernel_per_group;
    // Iterate output line which is contributed by current input block
    for (surface_iter = 0; surface_iter<surface_num; surface_iter ++) {
        for (output_height_iter = 0; output_height_iter < cube_out_height; output_height_iter++) {
            // Get data
            for (output_width_iter = 0; output_width_iter < cube_out_width; output_width_iter++) {
                //cslDebug((50, "attempt reading from line_buffer_usage_available_\n"));
                //line_buffer_usage_available_->read();
                //cslDebug((50, "read from line_buffer_usage_available_ done\n"));

                atomic_cube = new uint8_t[KERNEL_PER_GROUP_INT8];
                atomic_cube_ptr_int8  = reinterpret_cast <int8_t *> (atomic_cube);
                atomic_cube_ptr_int16 = reinterpret_cast <int16_t *> (atomic_cube);
                atomic_cube_ptr_fp16  = reinterpret_cast <uint16_t *> (atomic_cube);
                line_buffer_ptr_int8  = reinterpret_cast <int16_t *> (line_buffer_);
                line_buffer_ptr_int16 = reinterpret_cast <int32_t *> (line_buffer_);
                line_buffer_ptr_fp16  = reinterpret_cast <uint32_t *> (line_buffer_);

                switch (precision) {
                    case DATA_FORMAT_INT8:
                        PoolingStage1Calc (atomic_cube_ptr_int8, line_buffer_ptr_int8, output_width_iter, output_height_iter, surface_iter, ELEMENT_PER_ATOM_INT8, surface_num, acc_subcube_out_width, cube_out_width, pad_left, pad_right, cube_in_width);
                        break;
                    case DATA_FORMAT_INT16:
                        PoolingStage1Calc (atomic_cube_ptr_int16, line_buffer_ptr_int16, output_width_iter, output_height_iter, surface_iter, ELEMENT_PER_ATOM_INT16, surface_num, acc_subcube_out_width, cube_out_width, pad_left, pad_right, cube_in_width);
                        break;
                    case DATA_FORMAT_FP16:
                        PoolingStage1Calc (atomic_cube_ptr_fp16, line_buffer_ptr_fp16, output_width_iter, output_height_iter, surface_iter, ELEMENT_PER_ATOM_FP16, surface_num, acc_subcube_out_width, cube_out_width, pad_left, pad_right, cube_in_width);
                        break;
#pragma CTC SKIP
                    default:
                        break;
#pragma CTC ENDSKIP
                }

                wdma_buffer_->write(atomic_cube);
                
                if(precision == DATA_FORMAT_FP16)
                {
                    uint16_t *ptr = reinterpret_cast <uint16_t *> (atomic_cube);

                    for(int i=0;i<16;i++)
                    {
                        uint32_t exp = (ptr[i] >> 10) & 0x1f;
                        uint32_t frac = ptr[i] & 0x3ff;

                        if(exp == 0x1f && frac != 0)
                        {
                            nan_output_num++;
                        }
                    }
                }

                cslDebug((70, "NV_NVDLA_pdp::PoolingStage1SequenceCommon, write to wdma_buffer: "));
                for(int i=0;i<KERNEL_PER_GROUP_INT8;i++)
                    cslDebug((70, "0x%02x ", atomic_cube[i]));
                cslDebug((70, "\n"));
            }
        }
    }
}

void NV_NVDLA_pdp::PdpWdmaSequenceThread () {
    uint32_t partial_width_out_first;
    uint32_t partial_width_out_mid;
    uint32_t partial_width_out_last;
    uint32_t cube_out_width;
    uint64_t dst_base_addr;
    uint32_t split_iter;
    uint32_t split_num;
    bool     split_last;

    while(true) {
        // Wait kick off event
        wait(pdp_kickoff_);

        partial_width_out_first = pdp_partial_width_out_first_ + 1;
        partial_width_out_mid   = pdp_partial_width_out_mid_   + 1;
        partial_width_out_last  = pdp_partial_width_out_last_  + 1;

        split_num = pdp_split_num_ + 1;
        switch(pdp_operation_mode_) {
#pragma CTC SKIP
            case SPLIT_WIDTH_DIS_16B_TO_8B:
                // WdmaSequence16Bto8B();
                FAIL(("NV_NVDLA_pdp::PdpWdmaSequenceThread: SPLIT_WIDTH_DIS_16B_TO_8B has not been implemented"));
                break;
#pragma CTC ENDSKIP
            case SPLIT_WIDTH_DIS_COMMON:
                dst_base_addr = uint64_t(pdp_dst_base_addr_high_) << 32 | uint64_t(pdp_dst_base_addr_low_);
                cube_out_width = pdp_cube_out_width_+1;
                split_last     = true;
                WdmaSequenceCommon(dst_base_addr, cube_out_width, split_last);
                break;
#pragma CTC SKIP
            case SPLIT_WIDTH_EN_16B_TO_8B:
                // WdmaSequence16Bto8B();
                FAIL(("NV_NVDLA_pdp::PdpWdmaSequenceThread: SPLIT_WIDTH_EN_ has not been implemented"));
                break;
#pragma CTC ENDSKIP
            case SPLIT_WIDTH_EN_COMMON:
                for (split_iter = 0; split_iter < split_num; split_iter ++) {
                    if (0 == split_iter) {
                        // The first split width
                        dst_base_addr  = uint64_t(pdp_dst_base_addr_high_) << 32 | uint64_t(pdp_dst_base_addr_low_);
                        cube_out_width = partial_width_out_first;
                        split_last     = false;
                    } else if ((split_num - 1) == split_iter) { // The last split width
                        dst_base_addr  = uint64_t(pdp_dst_base_addr_high_) << 32 | uint64_t(pdp_dst_base_addr_low_);
                        dst_base_addr += (partial_width_out_first + (split_iter-1)*partial_width_out_mid) * DLA_ATOM_SIZE;
                        cube_out_width = partial_width_out_last;
                        split_last     = true;
                    } else {
                        dst_base_addr  = uint64_t(pdp_dst_base_addr_high_) << 32 | uint64_t(pdp_dst_base_addr_low_);
                        dst_base_addr += (partial_width_out_first + (split_iter-1)*partial_width_out_mid) * DLA_ATOM_SIZE;
                        cube_out_width = partial_width_out_mid;
                        split_last     = false;
                    }
                    WdmaSequenceCommon(dst_base_addr, cube_out_width, split_last);
                }
                break;
#pragma CTC SKIP
            default: 
                break;
#pragma CTC ENDSKIP
        }
    }
}

void NV_NVDLA_pdp::WdmaSequenceCommon(uint64_t dst_base_addr, uint32_t cube_out_width, bool split_last) {
    // Config variables, they have corresponding value in registers
    uint32_t cube_in_channel, cube_out_height;
    uint64_t dst_line_stride, dst_surface_stride;
    uint32_t element_per_atom;
    // Control variables
    // # Iterators
    uint32_t surface_iter;
    uint32_t surface_num;
    uint32_t output_height_iter;
    // #
    bool     is_dst_line_packed;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint32_t payload_atom_num;
    bool     is_required_ack=false;

    // Copy from register value to local config variables, similar with RTL connection
    // overlapped_line_num = pdp_overlapped_line_num_;
    cube_in_channel     = pdp_cube_in_channel_+1;
    cube_out_height     = pdp_cube_out_height_+1;
    dst_line_stride     = pdp_dst_line_stride_;
    dst_surface_stride  = pdp_dst_surface_stride_;

    // Evaluated
    if ( dst_line_stride == DLA_ATOM_SIZE * cube_out_width ) {
        is_dst_line_packed = true;
    } else {
        is_dst_line_packed = false;
    }

    // In current RTL design (2016/08/01), the dma request doesn't cross lines. So set is_dst_line_packed to false.
    is_dst_line_packed = false;

    switch (pdp_input_data_) {
        case DATA_FORMAT_IS_INT8: {
                element_per_atom = ELEMENT_PER_ATOM_INT8;
                break;
            }
        case DATA_FORMAT_IS_INT16: {
                element_per_atom = ELEMENT_PER_ATOM_INT16;
                break;
            }
        case DATA_FORMAT_IS_FP16: {
                element_per_atom = ELEMENT_PER_ATOM_FP16;
                break;
            }
#pragma CTC SKIP
        default: break;
#pragma CTC ENDSKIP
    }

    // For block sequence looping
    surface_num = (cube_in_channel + element_per_atom - 1)/element_per_atom;
    for (surface_iter = 0; surface_iter<surface_num; surface_iter ++) {
#pragma CTC SKIP
        if (true == is_dst_line_packed) {
/*          // Line packed, sent request across lines
            atom_num        = cube_out_width * (output_line_current_idx - output_line_last_idx);
            atom_sent_num   = 0;
            payload_addr    = dst_base_addr + output_line_last_idx * dst_line_stride + surface_iter * dst_surface_stride;
            while (atom_sent_num < atom_num) {
                // Calculate payload size, payload transaction must be within a 256 byte
                payload_size        = MAX_MEM_TRANSACTION_SIZE - payload_addr%MAX_MEM_TRANSACTION_SIZE;
                // Payload transaction shall not be larger than rest of atom cube number
                payload_atom_num    = min(atom_num-atom_sent_num, payload_size/DLA_ATOM_SIZE);
                payload_size        = payload_atom_num*DLA_ATOM_SIZE;
                if ((block_iter_height+1 == block_num_height) && (surface_iter+1 == surface_num) && (atom_sent_num+payload_atom_num == atom_num) ) {
                    is_required_ack = true;
                }
                SendDmaWriteRequest(payload_addr, payload_size, payload_atom_num, is_required_ack);
                // Increase loop controls
                payload_addr        += payload_size;
                atom_sent_num       += payload_atom_num;
            } */
        }
#pragma CTC ENDSKIP
        else {
            // Line unpacked, sent request per line
            for (output_height_iter = 0; output_height_iter < cube_out_height; output_height_iter++) {
                payload_addr     = dst_base_addr + output_height_iter * dst_line_stride + surface_iter * dst_surface_stride;
                payload_atom_num = cube_out_width;
                payload_size     = payload_atom_num*DLA_ATOM_SIZE;
                // Prepare Payload
                if ( split_last && (surface_iter+1 == surface_num) && (output_height_iter+1 == cube_out_height) ) {
                    is_required_ack = true;
                }
                cslDebug((50, "NV_NVDLA_pdp::WdmaSequenceCommon, SendDmaWriteRequest h=%d of %d\n", output_height_iter, cube_out_height));
                SendDmaWriteRequest(payload_addr, payload_size, payload_atom_num, is_required_ack);
                cslDebug((50, "NV_NVDLA_pdp::WdmaSequenceCommon, SendDmaWriteRequest done\n"));
            }
        }
    }
}

#pragma CTC SKIP
void NV_NVDLA_pdp::PoolingStage1Sequence8Bto8B() {
}
#pragma CTC ENDSKIP

void NV_NVDLA_pdp::PoolingStage0SequenceThread() {
    uint32_t partial_width_in_first;
    uint32_t partial_width_in_mid;
    uint32_t partial_width_in_last;
    uint32_t partial_width_out_first;
    uint32_t partial_width_out_mid;
    uint32_t partial_width_out_last;
    uint32_t kernel_width;
    uint32_t kernel_stride_width;
    uint32_t cube_in_width;
    uint32_t cube_out_width;
    uint32_t pad_left;
    uint32_t pad_right;
    uint32_t split_iter;
    uint32_t split_num;
    uint32_t acc_subcube_out_width;

    // Wait kick off event
    while (true) {
        wait(pdp_kickoff_);

        partial_width_in_first  = pdp_partial_width_in_first_ + 1;
        partial_width_in_mid    = pdp_partial_width_in_mid_   + 1;
        partial_width_in_last   = pdp_partial_width_in_last_  + 1;
        partial_width_out_first = pdp_partial_width_out_first_ + 1;
        partial_width_out_mid   = pdp_partial_width_out_mid_   + 1;
        partial_width_out_last  = pdp_partial_width_out_last_  + 1;
        kernel_width            = pdp_kernel_width_ + 1;
        kernel_stride_width     = pdp_kernel_stride_width_ + 1;

        //registers D_POOLING_PADDING_VALUE_2_CFG, ... D_PARTIAL_WIDTH_OVERLAP are not used
        //we can calculate them in cmod and compare them with csb registers

        split_num = pdp_split_num_ + 1;
        switch(pdp_operation_mode_) {
            case SPLIT_WIDTH_DIS_COMMON:
                cube_in_width   = pdp_cube_in_width_ + 1;
                cube_out_width  = pdp_cube_out_width_ + 1;
                pad_left        = pdp_pad_left_;
                pad_right       = pdp_pad_right_;
                acc_subcube_out_width = 0;
                PoolingStage0SequenceCommon(cube_in_width, pad_left, pad_right, acc_subcube_out_width, cube_out_width);
                break;
#pragma CTC SKIP
            case SPLIT_WIDTH_EN_16B_TO_8B:
            case SPLIT_WIDTH_DIS_16B_TO_8B:
                FAIL(("NV_NVDLA_pdp::PoolingStage0SequenceThread, SPLIT_WIDTH_EN_16B_TO_8B and SPLIT_WIDTH_DIS_16B_TO_8B have not been implemented"));
                // PoolingStage0Sequence16Bto8B();
                break;
#pragma CTC ENDSKIP
            case SPLIT_WIDTH_EN_COMMON:
                for (split_iter = 0; split_iter < split_num; split_iter ++) {
                    if (0 == split_iter) {
                        cube_in_width   = partial_width_in_first;
                        cube_out_width  = partial_width_out_first;
                        pad_left        = pdp_pad_left_;
                        pad_right       = 0;
                        acc_subcube_out_width = 0;
                    } else if ( split_num - uint32_t(1) == split_iter ) {
                        cube_in_width   = partial_width_in_last + (kernel_width - kernel_stride_width);
                        cube_out_width  = partial_width_out_last;
                        pad_left        = 0;
                        pad_right       = pdp_pad_right_;
                        acc_subcube_out_width = partial_width_out_first + (split_iter-1) * partial_width_out_mid;
                    } else {
                        cube_in_width   = partial_width_in_mid + (kernel_width - kernel_stride_width);
                        cube_out_width  = partial_width_out_mid;
                        pad_left        = 0;
                        pad_right       = 0;
                        acc_subcube_out_width = partial_width_out_first + (split_iter-1) * partial_width_out_mid;
                    }
                    PoolingStage0SequenceCommon(cube_in_width, pad_left, pad_right, acc_subcube_out_width, cube_out_width);
                }
                break;
#pragma CTC SKIP
            default:
                break;
#pragma CTC ENDSKIP
        }
    }
}

void NV_NVDLA_pdp::PoolingStage1SequenceThread () {
    uint32_t partial_width_in_first;
    uint32_t partial_width_in_mid;
    uint32_t partial_width_in_last;
    uint32_t partial_width_out_first;
    uint32_t partial_width_out_mid;
    uint32_t partial_width_out_last;
    uint32_t cube_in_width;
    uint32_t cube_out_width;
    uint32_t split_iter;
    uint32_t split_num;
    uint32_t acc_subcube_out_width;
    uint32_t pad_left;
    uint32_t pad_right;

    // Wait kick off event
    while (true) {
        wait(pdp_kickoff_);

        partial_width_in_first  = pdp_partial_width_in_first_ + 1;
        partial_width_in_mid    = pdp_partial_width_in_mid_   + 1;
        partial_width_in_last   = pdp_partial_width_in_last_  + 1;
        partial_width_out_first  = pdp_partial_width_out_first_ + 1;
        partial_width_out_mid    = pdp_partial_width_out_mid_   + 1;
        partial_width_out_last   = pdp_partial_width_out_last_  + 1;

        split_num = pdp_split_num_ + 1;
        switch(pdp_operation_mode_) {
            case SPLIT_WIDTH_DIS_COMMON:
                cube_in_width = pdp_cube_in_width_ + 1;
                cube_out_width = pdp_cube_out_width_ + 1;
                acc_subcube_out_width = 0;
                pad_left = pdp_pad_left_;
                pad_right = pdp_pad_right_;
                PoolingStage1SequenceCommon(cube_out_width, acc_subcube_out_width, pad_left, pad_right, cube_in_width);
                break;
#pragma CTC SKIP
            case SPLIT_WIDTH_EN_16B_TO_8B:
            case SPLIT_WIDTH_DIS_16B_TO_8B:
                FAIL(("NV_NVDLA_pdp::PoolingStage1SequenceThread, SPLIT_WIDTH_EN_16B_TO_8B and SPLIT_WIDTH_DIS_16B_TO_8B have not been implemented"));
                // PoolingStage1Sequence16Bto8B();
                break;
#pragma CTC ENDSKIP
            case SPLIT_WIDTH_EN_COMMON:
                for (split_iter = 0; split_iter < split_num; split_iter ++) {
                    if (0 == split_iter) {
                        cube_in_width   = partial_width_in_first;
                        cube_out_width = partial_width_out_first;
                        acc_subcube_out_width = 0;
                        pad_left = pdp_pad_left_;
                        pad_right = 0;
                    } else if ( split_num - uint32_t(1) == split_iter ) {
                        cube_in_width = partial_width_in_last;
                        cube_out_width = partial_width_out_last;
                        acc_subcube_out_width = partial_width_out_first + (split_iter-1) * partial_width_out_mid;
                        pad_left = 0;
                        pad_right = pdp_pad_right_;
                    } else {
                        cube_in_width = partial_width_in_mid;
                        cube_out_width = partial_width_out_mid;
                        acc_subcube_out_width = partial_width_out_first + (split_iter-1) * partial_width_out_mid;
                        pad_left = 0;
                        pad_right = 0;
                    }
                    PoolingStage1SequenceCommon(cube_out_width, acc_subcube_out_width, pad_left, pad_right, cube_in_width);
                }
                break;
#pragma CTC SKIP
            default:
                break;
#pragma CTC ENDSKIP
        }
    }
}

#pragma CTC SKIP
void NV_NVDLA_pdp::OperationModePdpRdmaCommon() {
}
#pragma CTC ENDSKIP

void NV_NVDLA_pdp::Reset()
{
    // Clear register and internal states
    PdpRegReset();
    PdpRdmaRegReset();
    is_there_ongoing_csb2pdp_response_      = false;
    is_there_ongoing_csb2pdp_rdma_response_ = false;
    dma_delay_ = SC_ZERO_TIME;
    csb_delay_ = SC_ZERO_TIME;
    pdp_rdma_operation_mode_                = SPLIT_WIDTH_DIS_COMMON;
    pdp_operation_mode_                     = SPLIT_WIDTH_DIS_COMMON;
    pdp_ready_to_receive_data_              = false;
    b_transport_delay_ = SC_ZERO_TIME;
    //PDP interrupt wires to GLB
    pdp2glb_done_intr[0].initialize(false);
    pdp2glb_done_intr[1].initialize(false);
}

// Target sockets
void NV_NVDLA_pdp::sdp2pdp_b_transport(int ID, nvdla_sdp2pdp_t* payload, sc_core::sc_time& delay) {
    uint8_t *payload_data_ptr;
    uint8_t  *fifo_data_ptr;
    payload_data_ptr    = reinterpret_cast <uint8_t *> (payload->pd.sdp2pdp.data);
    fifo_data_ptr = new uint8_t[SDP2PDP_PAYLOAD_SIZE];
    memcpy (fifo_data_ptr, payload_data_ptr, SDP2PDP_PAYLOAD_SIZE);
    sdp2pdp_fifo_->write(fifo_data_ptr);
    //sdp2pdp_trans_cnt++;
    //printf("sdp2pdp_trans_cnt=%d\n", sdp2pdp_trans_cnt);
}

#pragma CTC SKIP
void NV_NVDLA_pdp::WaitUntilRdmaBufferFreeSizeGreaterThan(uint32_t num) {
    while (uint32_t(rdma_buffer_->num_free()) < num) {
        wait( rdma_buffer_->data_read_event() );
    }
}

void NV_NVDLA_pdp::WaitUntilRdmaBufferAvailableSizeGreaterThan(uint32_t num) {
    while (uint32_t(rdma_buffer_->num_available()) < num) {
        wait( rdma_buffer_->data_written_event() );
    }
}

void NV_NVDLA_pdp::WaitUntilWdmaBufferFreeSizeGreaterThan(uint32_t num) {
    while (uint32_t(wdma_buffer_->num_free()) < num) {
        wait( wdma_buffer_->data_read_event() );
    }
}

void NV_NVDLA_pdp::WaitUntilWdmaBufferAvailableSizeGreaterThan(uint32_t num) {
    while (uint32_t(wdma_buffer_->num_available()) < num) {
        wait( wdma_buffer_->data_written_event() );
    }
}
#pragma CTC ENDSKIP

// Send DMA read request
void NV_NVDLA_pdp::SendDmaReadRequest(nvdla_dma_rd_req_t* payload, sc_time& delay) {
    if (NVDLA_PDP_RDMA_D_SRC_RAM_CFG_0_SRC_RAM_TYPE_MC== pdp_rdma_src_ram_type_) {
        cslDebug((50, "NV_NVDLA_pdp::SendDmaReadRequest to MC, payload_addr=0x%lx payload_atom_num=0x%x\n", payload->pd.dma_read_cmd.addr, payload->pd.dma_read_cmd.size+1));
        NV_NVDLA_pdp_base::pdp2mcif_rd_req_b_transport(payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_pdp::SendDmaReadRequest to MC, done\n"));
    } else {
        cslDebug((50, "NV_NVDLA_pdp::SendDmaReadRequest to CV  payload_addr=0x%lx payload_atom_num=0x%x\n", payload->pd.dma_read_cmd.addr, payload->pd.dma_read_cmd.size+1));
        NV_NVDLA_pdp_base::pdp2cvif_rd_req_b_transport(payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_pdp::SendDmaReadRequest to CV, done\n"));
    }
}

void NV_NVDLA_pdp::ExtractDmaPayload(nvdla_dma_rd_rsp_t* payload){
    // Extract data from payload
    //  Each payload is 64 byte, two mask bit tells which 32 byte groups are effective
    uint8_t *payload_data_ptr;
    uint8_t *rdma_atom_cube_ptr;
    uint8_t mask;
    mask = payload->pd.dma_read_data.mask;
    payload_data_ptr    = reinterpret_cast <uint8_t *> (payload->pd.dma_read_data.data);

    cslDebug((50, "NV_NVDLA_pdp::ExtractDmaPayload\n"));

    for(int atom_iter = 0; atom_iter < PDP_ATOM_PER_TRANSFER; atom_iter++) {
        if (0 != (mask & (0x1 << atom_iter))) {
            rdma_atom_cube_ptr = new uint8_t[DLA_ATOM_SIZE]; 
            memcpy(rdma_atom_cube_ptr, &payload_data_ptr[DLA_ATOM_SIZE*atom_iter], DLA_ATOM_SIZE);
            rdma_buffer_->write(rdma_atom_cube_ptr);

            if(pdp_input_data_ == DATA_FORMAT_FP16)
            {
                uint16_t *ptr = reinterpret_cast <uint16_t *> (rdma_atom_cube_ptr);

                for(int i=0;i<16;i++)
                {
                    uint32_t exp = (ptr[i] >> 10) & 0x1f;
                    uint32_t frac = ptr[i] & 0x3ff;

                    if(exp == 0x1f)
                    {
                        if(frac == 0)
                        {
                            inf_input_num++;
                        }
                        else
                        {
                            nan_input_num++;
                            cslDebug((70, "got NaN:%x i=%d\n", ptr[i], i));
                        }
                    }
                }
            }

#ifdef NVDLA_CMOD_DEBUG
            cslDebug((70, "write to rdma_buffer. mask A\n"));
            for(int i=0;i<DLA_ATOM_SIZE;i++)
                cslDebug((70, "0x%02x \n", rdma_atom_cube_ptr[i]));
            cslDebug((70, "\n"));
#endif
        }
    }

    cslDebug((50, "NV_NVDLA_pdp::ExtractDmaPayload done\n"));
}

void NV_NVDLA_pdp::mcif2pdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    ExtractDmaPayload(payload);
}

void NV_NVDLA_pdp::cvif2pdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time&){
    ExtractDmaPayload(payload);
}

// Send DMA write request
void NV_NVDLA_pdp::SendDmaWriteRequest(uint64_t payload_addr, uint32_t payload_size, uint32_t payload_atom_num, bool ack_required){
    uint32_t atom_iter;
    uint32_t transfer_iter;
    uint32_t transfer_num;
    uint8_t *dma_write_data_ptr;
    uint8_t *payload_data_ptr;
    // Prepare payload
    dma_wr_req_cmd_payload_->pd.dma_write_cmd.addr = payload_addr;
    dma_wr_req_cmd_payload_->pd.dma_write_cmd.size = payload_atom_num-1;
    payload_data_ptr = reinterpret_cast <uint8_t  *>  (dma_wr_req_data_payload_->pd.dma_write_data.data);
    //WaitUntilWdmaBufferAvailableSizeGreaterThan(payload_atom_num);
    // Send write command
    cslDebug((50, "NV_NVDLA_pdp::SendDmaWriteRequest cmd, payload_addr=0x%lx payload_atom_num=0x%x\n", payload_addr, payload_atom_num));
    SendDmaWriteRequest(dma_wr_req_cmd_payload_, dma_delay_, ack_required);
    cslDebug((50, "NV_NVDLA_pdp::SendDmaWriteRequest cmd done\n"));
    transfer_num = (payload_atom_num + PDP_ATOM_PER_TRANSFER - 1)/PDP_ATOM_PER_TRANSFER;
    for (transfer_iter = 0; transfer_iter < transfer_num; transfer_iter++) {
        for (atom_iter=0; atom_iter<PDP_ATOM_PER_TRANSFER; atom_iter++) {
            if((transfer_iter*PDP_ATOM_PER_TRANSFER + atom_iter) == payload_atom_num) {
                // Fill 0
                memset(&payload_data_ptr[atom_iter*DLA_ATOM_SIZE], 0, (PDP_ATOM_PER_TRANSFER-atom_iter)*DLA_ATOM_SIZE);
                SendDmaWriteRequest (dma_wr_req_data_payload_, dma_delay_);
                break;
            }
            dma_write_data_ptr = wdma_buffer_->read();
            cslDebug((50, "NV_NVDLA_pdp::SendDmaWriteRequest data transfer_iter=%d w=%d of %d, read from wdma_buffer_: ", transfer_iter, atom_iter, payload_atom_num));
            for(int i=0;i<DLA_ATOM_SIZE;i++)
                cslDebug((70, "0x%02x ", dma_write_data_ptr[i]));
            cslDebug((70, "\n"));
            memcpy(&payload_data_ptr[DLA_ATOM_SIZE*(atom_iter%PDP_ATOM_PER_TRANSFER)], dma_write_data_ptr, DLA_ATOM_SIZE);
            delete[] dma_write_data_ptr;
            // Send write data
            if (atom_iter == (PDP_ATOM_PER_TRANSFER - 1)) {
                SendDmaWriteRequest (dma_wr_req_data_payload_, dma_delay_);
            }
        }
    }

    if (ack_required) pdp_done_.notify();
}

void NV_NVDLA_pdp::SendDmaWriteRequest(nvdla_dma_wr_req_t* payload, sc_time& delay, bool ack_required) {
    if (NVDLA_PDP_D_DST_RAM_CFG_0_DST_RAM_TYPE_MC == pdp_dst_ram_type_) {
        if (TAG_CMD == payload->tag) {
            if (ack_required) {
                payload->pd.dma_write_cmd.require_ack = 1;
            } else {
                payload->pd.dma_write_cmd.require_ack = 0;
            }
        }
        NV_NVDLA_pdp_base::pdp2mcif_wr_req_b_transport(payload, dma_delay_);
    } else {
        if (TAG_CMD == payload->tag) {
            if (ack_required) {
                payload->pd.dma_write_cmd.require_ack = 1;
            } else {
                payload->pd.dma_write_cmd.require_ack = 0;
            }
        }
        NV_NVDLA_pdp_base::pdp2cvif_wr_req_b_transport(payload, dma_delay_);
    }

    if (ack_required) {
        pdp_ack_info *ack = new pdp_ack_info;
        ack->is_mc = NVDLA_PDP_D_DST_RAM_CFG_0_DST_RAM_TYPE_MC == pdp_dst_ram_type_;
        ack->group_id = pdp_consumer_;
        pdp_ack_fifo_->write(ack);
        //pdp_done_.notify();
    }

}


// template <typename T>
// void NV_NVDLA_pdp::FetchInputData (T * atomic_cube) {
// void NV_NVDLA_pdp::FetchInputData (uint8_t * atomic_cube) {
// Input data could from:
// 1. pdp, data formation:
//      1. Parallel element number: 16 elements for both Int8 and Int16/FP16
//      2. Bit-depth:
//          1. Int8: one element per one container, only use lower 8 bits of each container
//          2. Int16/FP16: one element per one container, use full 16 bits of each container     
// 2. PDP RDMA, data formation:
//      1. Parallel element number:
//          1. Int8: 32 elements
//          2. Int16/FP16: 16 elements
//      2. Bit-depth:
//          1. Int8: 8 bits
//          2. Int16/FP16: 16 bits
uint8_t * NV_NVDLA_pdp::FetchInputData () {
    uint8_t *data;
    uint8_t sdp2pdp_element_iter;
    data = NULL;
    if (POOLING_FLYING_MODE_ON_FLYING == pdp_flying_mode_) {
        data = new uint8_t[DLA_ATOM_SIZE];
        for(int iter = 0; iter < NVDLA_MEMORY_ATOMIC_SIZE/SDP_MAX_THROUGHPUT; iter++) {
            if (NVDLA_PDP_D_DATA_FORMAT_0_INPUT_DATA_INT8 == pdp_input_data_) {
                // Int8, 8 bits per container, only use 8*SDP_THROUGHPUT bits
                uint8_t *sdp2pdp_payload_data;
                sdp2pdp_payload_data = sdp2pdp_fifo_->read();
                cslDebug((50, "Before copy data from sdp2pdp_payload_data to data\n"));
                for (sdp2pdp_element_iter = 0; sdp2pdp_element_iter < SDP_MAX_THROUGHPUT; sdp2pdp_element_iter ++) {
                    data[iter*SDP_MAX_THROUGHPUT+sdp2pdp_element_iter] =  sdp2pdp_payload_data[sdp2pdp_element_iter];
                }
                cslDebug((50, "After copy data from sdp2pdp_payload_data to data\n"));
#pragma CTC SKIP
                if (sdp2pdp_payload_data) delete [] sdp2pdp_payload_data;
#pragma CTC ENDSKIP
            } else {
                // Int16/FP16, 16 bits per container, user full 16 bits
                uint16_t *sdp2pdp_payload_data;
                sdp2pdp_payload_data = (uint16_t*)sdp2pdp_fifo_->read();
                memcpy (data + iter*SDP_MAX_THROUGHPUT*sizeof(int16_t), sdp2pdp_payload_data, SDP_MAX_THROUGHPUT*sizeof(int16_t));
#pragma CTC SKIP
                if (sdp2pdp_payload_data) delete [] sdp2pdp_payload_data;
#pragma CTC ENDSKIP
            }
        }
    } else if (POOLING_FLYING_MODE_OFF_FLYING == pdp_flying_mode_) {
        // atomic_cube = rdma_buffer_->read();
        data = rdma_buffer_->read();
        cslDebug((50, "FetchInputData: read rdma_buffer, data is.\n"));
        for(int i=0;i<DLA_ATOM_SIZE;i++) {
            cslDebug((50, "0x%02x ", data[i]));
        }
        cslDebug((50, "\n"));
    } else {
#pragma CTC SKIP
        FAIL(("NV_NVDLA_pdp::FetchInputData, invalid flying mode."));
#pragma CTC ENDSKIP
    }
    return data;
}

template <typename T_IN, typename T_OUT, typename T_PAD>
void NV_NVDLA_pdp::LineOperation (T_IN * atomic_data_in, T_OUT * line_buffer_ptr, uint32_t kernel_width_iter, uint32_t kernel_width, uint32_t cube_in_width_iter, uint32_t cube_in_width, T_PAD * padding_value_ptr, uint8_t element_num, uint32_t pad_left) {
    uint32_t element_idx;
    cslDebug((50, "NV_NVDLA_pdp::LineOperation: kernel_width_iter:0x%04x, kernel_width:0x%04x, cube_in_width_iter:0x%04x, cube_in_width:0x%04x\n", kernel_width_iter, kernel_width, cube_in_width_iter, cube_in_width));
    cslDebug((50, "NV_NVDLA_pdp::LineOperation, padding_value_ptr:\n"));
    for (element_idx=0; element_idx<PDP_MAX_PADDING_SIZE; element_idx++) {
        cslDebug((50, "0x%08x ", (uint32_t)padding_value_ptr[element_idx] & 0xffffffff));
    }
    cslDebug((50, "\n"));
    cslDebug((50, "LineOperation, operand: atom data:\n"));
    for (element_idx=0; element_idx<element_num; element_idx++) {
        cslDebug((50, "0x%04x ", (uint16_t)atomic_data_in[element_idx] & 0xffff));
    }
    cslDebug((50, "\n"));
    cslDebug((50, "LineOperation, operand: line buffer data:\n"));
    for (element_idx=0; element_idx<element_num; element_idx++) {
        cslDebug((50, "0x%08x ", (uint32_t)line_buffer_ptr[element_idx] & 0xffffffff));
    }
    cslDebug((50, "\n"));

    bool is_first_element = (0 == cube_in_width_iter) || (0 == kernel_width_iter);
    bool add_left_padding = (cube_in_width_iter + 1 < kernel_width) && ((kernel_width_iter+1 == kernel_width) || ((cube_in_width_iter + 1 == cube_in_width) && (cube_in_width_iter < kernel_width_iter) && pad_left));
    bool add_right_padding = (cube_in_width_iter + kernel_width - kernel_width_iter > cube_in_width) && (cube_in_width_iter + 1 == cube_in_width);

    T_PAD padding_value_left = 0;
    T_PAD padding_value_right = 0;

    if(add_left_padding)
    {
        uint32_t num = kernel_width - (cube_in_width_iter + 1);
        padding_value_left = padding_value_ptr[num-1];
        cslDebug((50, "pad left %d\n", num));
    }
    else if(add_right_padding)
    {
        uint32_t num = kernel_width - (kernel_width_iter + 1);
        padding_value_right = padding_value_ptr[num-1];
        cslDebug((50, "pad right %d\n", num));
    }

    for (element_idx=0; element_idx<element_num; element_idx++) {
        if(pdp_input_data_ == DATA_FORMAT_FP16)
        {
            HLS_PDP_PoolingStage0Calc_FP16_W(is_first_element, (uint32_t)padding_value_left, (uint32_t)padding_value_right, pdp_pooling_method_, element_idx, (uint32_t *)line_buffer_ptr, element_idx, (uint16_t *)atomic_data_in);
            continue;
        }
        switch (pdp_pooling_method_) {
            case POOLING_METHOD_MIN:
                {
                    if (is_first_element) {
                        line_buffer_ptr[element_idx] = atomic_data_in[element_idx];
                    } else {
                        line_buffer_ptr[element_idx] = min ( line_buffer_ptr[element_idx], T_OUT(atomic_data_in[element_idx]) );
                    }
                    break;
                }
            case POOLING_METHOD_MAX:
                {
                    if (is_first_element) {
                        line_buffer_ptr[element_idx] = atomic_data_in[element_idx];
                    } else {
                        line_buffer_ptr[element_idx] = max ( line_buffer_ptr[element_idx], T_OUT(atomic_data_in[element_idx]) );
                    }
                    break;
                }
            case POOLING_METHOD_AVE:
                {
                    if (is_first_element) {
                        // The first valid element, store data to line_operation buffer
                        line_buffer_ptr[element_idx] =  atomic_data_in[element_idx];
                    } else {
                        // Not the first valid element, adds data to line_operation buffer
                        line_buffer_ptr[element_idx] += atomic_data_in[element_idx];
                    }
                    // Add padding value, there may a case that one kernel requires both left padding and right padding
                    line_buffer_ptr[element_idx] += padding_value_left;
                    line_buffer_ptr[element_idx] += padding_value_right;
                    break;
                }
#pragma CTC SKIP
            default: 
                {
                    FAIL(("NV_NVDLA_pdp::LineOperation: Invalid pooling method."));
                }
#pragma CTC ENDSKIP
        }
    }
    cslDebug((50, "LineOperation, result: line buffer data\n"));
    for (element_idx=0; element_idx<element_num; element_idx++) {
        cslDebug((50, "0x%08x ", (uint32_t)line_buffer_ptr[element_idx] & 0xffffffff));
    }
    cslDebug((50, "\n"));
}

// User shall make sure T_IN and T_OUT type is match
// width, height: coordinates of the output element
// element_num: the number of elements in 32Bytes
// is_first_element: the first element which contributes to the output element
template <typename T_IN, typename T_OUT, typename T_PAD>
void NV_NVDLA_pdp::PoolingStage0Calc (T_IN * atomic_data_in, T_OUT * line_buffer_ptr, uint32_t cube_out_width_idx, uint32_t cube_out_height_idx, uint32_t surface, uint32_t cube_in_height, uint32_t kernel_height_iter,  uint32_t kernel_height, uint32_t cube_in_height_iter, T_PAD * padding_value_ptr, uint8_t element_num, uint32_t surface_num, uint32_t acc_subcube_out_width, uint32_t cube_out_width) {
    uint32_t element_idx;
    uint32_t atomic_stride;
    uint32_t line_stride;
    uint32_t surf_stride;
    uint32_t linebuf_start_idx;
    //uint32_t linebuf_entry_idx;
    uint32_t acc_subcube_start;
    uint32_t kernel_width;

    atomic_stride   = uint32_t(DLA_ATOM_SIZE) * 2;     //In size of Byte. INT8 uses 2bytes, INT16 and FP16 uses 4bytes
    line_stride     = cube_out_width * atomic_stride;
    surf_stride     = (pdp_cube_out_height_+1) * line_stride;
    acc_subcube_start = (pdp_cube_out_height_+1) * acc_subcube_out_width * surface_num * atomic_stride;
    linebuf_start_idx = ((acc_subcube_start + surface*surf_stride + cube_out_height_idx*line_stride + cube_out_width_idx * atomic_stride)%sizeof(line_buffer_))/sizeof(T_OUT);
    kernel_width    = pdp_kernel_width_+1;

    cslDebug((50, "PoolingStage0Calc::padding_value_ptr:\n"));
    for (element_idx=0; element_idx<PDP_MAX_PADDING_SIZE; element_idx++) {
        cslDebug((50, "0x%08x ", (uint32_t)padding_value_ptr[element_idx] & 0xffffffff));
    }
    cslDebug((50, "\n"));
    cslDebug((50, "PoolingStage0Calc::operand: atom data:\n"));
    for (element_idx=0; element_idx<element_num; element_idx++) {
        cslDebug((50, "0x%08x ", (uint32_t)atomic_data_in[element_idx] & 0xffffffff));
    }
    cslDebug((50, "\n"));
    cslDebug((50, "PoolingStage0Calc::operand: linebuf_start_idx=0x%x data:\n", linebuf_start_idx));
    for (element_idx=0; element_idx<element_num; element_idx++) {
        cslDebug((50, "0x%08x ", (uint32_t)line_buffer_ptr[linebuf_start_idx  + element_idx] & 0xffffffff));
    }
    cslDebug((50, "\n"));

    bool is_first_element = (0 == cube_in_height_iter) || (0 == kernel_height_iter);
    bool add_top_padding = (cube_in_height_iter + 1 < kernel_height) && ((kernel_height_iter+1 == kernel_height) || ((cube_in_height_iter + 1 == cube_in_height) && (cube_in_height_iter < kernel_height_iter)));
    bool add_bottom_padding = (cube_in_height_iter + kernel_height - kernel_height_iter > cube_in_height) && (cube_in_height_iter + 1 == cube_in_height);
    
    T_PAD padding_value_top = 0;
    T_PAD padding_value_bottom = 0;

    if(add_top_padding)
    {
        uint32_t num = kernel_height - (cube_in_height_iter + 1);
        padding_value_top = padding_value_ptr[num-1];
        cslDebug((50, "pad top %d\n", num));
    }
    else if(add_bottom_padding)
    {
        uint32_t num = kernel_height - (kernel_height_iter + 1);
        padding_value_bottom = padding_value_ptr[num-1];
        cslDebug((50, "pad bottom %d\n", num));
    }
  
    if(pdp_input_data_ != DATA_FORMAT_FP16)
    {
        padding_value_top *= kernel_width;
        padding_value_bottom *= kernel_width;
    }

    for (element_idx=0; element_idx<element_num; element_idx++) {
        if(pdp_input_data_ == DATA_FORMAT_FP16)
        {
            HLS_PDP_PoolingStage0Calc_FP16_H(is_first_element, (uint32_t)padding_value_top, (uint32_t)padding_value_bottom, kernel_width, pdp_pooling_method_, linebuf_start_idx + element_idx, (uint32_t *)line_buffer_ptr, element_idx, (uint32_t *)atomic_data_in);
            continue;
        }
        // if (true == is_first_element) {
        //     line_buffer_ptr[linebuf_start_idx  + element_idx] = atomic_data_in[element_idx];
        // } else {
        switch (pdp_pooling_method_) {
            case POOLING_METHOD_MIN:
                {
                    if (is_first_element) {
                        line_buffer_ptr[linebuf_start_idx + element_idx] = atomic_data_in[element_idx];
                    } else {
                        line_buffer_ptr[linebuf_start_idx + element_idx] = min ( line_buffer_ptr[linebuf_start_idx + element_idx], T_OUT(atomic_data_in[element_idx]) );
                    }
                    break;
                }
            case POOLING_METHOD_MAX:
                {
                    if (is_first_element) {
                        line_buffer_ptr[linebuf_start_idx + element_idx] = atomic_data_in[element_idx];
                    } else {
                        line_buffer_ptr[linebuf_start_idx + element_idx] = max ( line_buffer_ptr[linebuf_start_idx + element_idx], T_OUT(atomic_data_in[element_idx]) );
                    }
                    break;
                }
            case POOLING_METHOD_AVE:
                {
                    if (is_first_element) {
                        line_buffer_ptr[linebuf_start_idx + element_idx] = atomic_data_in[element_idx];
                    } else {
                        line_buffer_ptr[linebuf_start_idx + element_idx] += atomic_data_in[element_idx];
                    }
                    line_buffer_ptr[linebuf_start_idx + element_idx] += padding_value_top;
                    line_buffer_ptr[linebuf_start_idx + element_idx] += padding_value_bottom;
                    break;
                }
#pragma CTC SKIP
            default: 
                {
                    FAIL(("NV_NVDLA_pdp::PoolingStage0Calc: Invalid pooling method."));
                }
#pragma CTC ENDSKIP
        }
        //}
    }
    cslDebug((50, "PoolingStage0Calc::result w=%d h=%d, line buffer data\n", cube_out_width_idx, cube_out_height_idx));
    for (element_idx=0; element_idx<element_num; element_idx++) {
        cslDebug((50, "0x%08x ", (uint32_t)line_buffer_ptr[linebuf_start_idx  + element_idx] & 0xffffffff));
    }
    cslDebug((50, "\n"));
}

// This function is useful only for AVERAGE pooling method
// User shall make sure T_IN and T_OUT type is match
template <typename T_OUT, typename T_IN>
void NV_NVDLA_pdp::PoolingStage1Calc (T_OUT * atomic_data_out, T_IN * line_buffer_ptr, uint32_t width, uint32_t height, uint32_t surface, uint8_t element_num, uint32_t surface_num, uint32_t acc_subcube_out_width, uint32_t cube_out_width, uint32_t pad_left, uint32_t pad_right, uint32_t cube_in_width) {
    uint8_t  element_idx;
    uint32_t atomic_stride;
    uint32_t line_stride;
    uint32_t surf_stride;
    // uint32_t cube_in_height;
    // uint32_t kernel_width, kernel_height;
    // uint32_t kernel_height;
    // uint32_t kernel_stride_width, kernel_stride_height;
    // uint32_t kernel_stride_height;
    //uint32_t pad_left;
    // uint32_t pad_top;
    //  int32_t pad_value_1x;
    uint32_t linebuf_start_idx;
    uint32_t linebuf_entry_idx;
    // uint32_t in_w_start, in_w_end, in_w_len;
    // uint32_t in_h_start, in_h_end, in_h_len;
    uint32_t acc_subcube_start;
    // uint32_t pooling_size;
    // uint32_t padding_num;
    uint32_t recip_kernel_width;
    uint32_t recip_kernel_height;

    //cube_in_width       = pdp_cube_in_width_+1;
    // cube_in_height      = pdp_cube_in_height_+1;
    // kernel_width        = pdp_kernel_width_+1;
    // kernel_height       = pdp_kernel_height_+1;
    // kernel_stride_width = pdp_kernel_stride_width_+1;
    // kernel_stride_height= pdp_kernel_stride_height_+1;
    //pad_left            = pdp_pad_left_;
    // pad_top             = pdp_pad_top_;
    // pad_value_1x        = pdp_pad_value_1x_;
    recip_kernel_width  = pdp_recip_kernel_width_;
    recip_kernel_height = pdp_recip_kernel_height_;

    // pooling_size        = kernel_width*kernel_height;

    atomic_stride   = uint32_t(DLA_ATOM_SIZE) * 2;     //In size of Byte. INT8 uses 2bytes, INT16 and FP16 uses 4bytes
    line_stride     = cube_out_width * atomic_stride;
    surf_stride     = (pdp_cube_out_height_+1)*line_stride;
    acc_subcube_start = (pdp_cube_out_height_+1) * acc_subcube_out_width * surface_num * atomic_stride;
    linebuf_start_idx = ((acc_subcube_start + surface*surf_stride + height*line_stride + width * atomic_stride)%sizeof(line_buffer_))/sizeof(T_IN);

    // Count the number of padding values
    // in_w_start = max(int32_t(width*kernel_stride_width - pad_left), 0);
    // in_w_end   = min((width*kernel_stride_width + kernel_width - 1 - pad_left), cube_in_width-1);
    // in_w_len   = in_w_end - in_w_start + 1;

    // in_h_start = max(int32_t(height*kernel_stride_height - pad_top), 0);
    // in_h_end   = min((height*kernel_stride_height + kernel_height - 1 - pad_top), cube_in_height-1);
    // in_h_len   = in_h_end - in_h_start + 1;

    // padding_num = pooling_size - in_w_len * in_h_len;

    // uint32_t output_bits = sizeof(T_OUT) * 8;
    // if((pdp_pad_value_1x_ >> (output_bits - 1)) & 0x1) //check MSB, the sign bit
    // {
    //     uint32_t upper_bits = sizeof(pad_value_1x) * 8 - output_bits;
    //     uint32_t upper_mask = (1 << upper_bits) - 1;
    //     pad_value_1x |= upper_mask << output_bits;
    // }
    cslDebug((50, "NV_NVDLA_pdp::PoolingStage1Calc\n"));

    linebuf_entry_idx = linebuf_start_idx*sizeof(T_IN)/atomic_stride;

    cslDebug((50, "attempt read line_buffer_ready_[%d], h=%d, w=%d\n", linebuf_entry_idx, height, width));
    line_buffer_ready_[linebuf_entry_idx]->read();
    cslDebug((50, "read line_buffer_ready_[%d]\n", linebuf_entry_idx));

    cslDebug((50, "attempt read line_buffer_usage_free_[%d], h=%d, w=%d\n", linebuf_entry_idx, height, width));
    line_buffer_usage_free_[linebuf_entry_idx]->read();
    cslDebug((50, "read line_buffer_usage_free_[%d]\n", linebuf_entry_idx));

    for (element_idx=0; element_idx<element_num; element_idx++) {
        if(pdp_input_data_ == DATA_FORMAT_FP16)
        {
            HLS_PDP_PoolingStage1Calc_FP16(pdp_pooling_method_, pdp_recip_kernel_width_, pdp_recip_kernel_height_, element_idx, (uint16_t *)atomic_data_out, linebuf_start_idx + element_idx, (uint32_t *)line_buffer_ptr); 
            continue;
        }
        switch (pdp_pooling_method_) {
            case POOLING_METHOD_MIN:
            case POOLING_METHOD_MAX:
                atomic_data_out[element_idx] = line_buffer_ptr[linebuf_start_idx + element_idx];
                break;
                // Only POOLING_METHOD_AVE needs stage 1 calculation
            case POOLING_METHOD_AVE:
                {
                    int32_t  tmp_sum = line_buffer_ptr[linebuf_start_idx + element_idx];

                    double  tmp_out = (double)tmp_sum * recip_kernel_width / 65536;
                    int32_t tmp_int = (tmp_out > 0)? (tmp_out + 0.5) : (tmp_out - 0.5);

                    tmp_out = (double)tmp_int * recip_kernel_height / 65536;
                    tmp_int = (tmp_out > 0)? (tmp_out + 0.5) : (tmp_out - 0.5);

                    atomic_data_out[element_idx] = static_cast<T_OUT>(tmp_int);
                    cslDebug((50, "PoolingStage1Calc linebuf_start_idx=0x%x element_idx=0x%x sum=0x%x tmp_sum=0x%x atomic_data_out=0x%x\n", linebuf_start_idx, (uint32_t)element_idx, line_buffer_ptr[linebuf_start_idx + element_idx], tmp_sum, atomic_data_out[element_idx]));
                    break;
                }
#pragma CTC SKIP
            default: 
                {
                    FAIL(("NV_NVDLA_pdp::PoolingStage1Calc: Invalid pooling method."));
                }
#pragma CTC ENDSKIP
        }
    }
}

void NV_NVDLA_pdp::WriteResponseThreadMc() {
    cslDebug((50, "NV_NVDLA_pdp::WriteResponseThreadMc is called\n"));
    if ( true == mcif2pdp_wr_rsp.read() ) {
#if 0
        if (NVDLA_PDP_D_DST_RAM_CFG_0_DST_RAM_TYPE_MC != pdp_dst_ram_type_) {
            FAIL(("NV_NVDLA_pdp::WriteResponseThreadMc, dst config is not MC"));
        }
#endif
        is_mc_ack_done_ = true;
        pdp_mc_ack_.notify();
    }
}

void NV_NVDLA_pdp::WriteResponseThreadCv() {
    if ( true == cvif2pdp_wr_rsp.read() ) {
#if 0
        if (NVDLA_PDP_D_DST_RAM_CFG_0_DST_RAM_TYPE_MC == pdp_dst_ram_type_) {
            FAIL(("NV_NVDLA_pdp::WriteResponseThreadCv, dst config is not CV_SRAM"));
        }
#endif
        is_cv_ack_done_ = true;
        pdp_cv_ack_.notify();
    }
}

#pragma CTC SKIP
// The first input (left most and up most of the kernel, not counting padded elements) element which contributes to the same output element
bool NV_NVDLA_pdp::IsFirstElement(uint32_t pad_left, uint32_t cube_in_width_iter, uint32_t cube_in_height_iter, uint32_t kernel_width_iter, uint32_t kernel_height_iter) {
    uint32_t kernel_stride_width, kernel_stride_height;
    uint32_t pad_top;
    bool is_first_element = false;

    kernel_stride_width     = pdp_kernel_stride_width_+1;
    kernel_stride_height    = pdp_kernel_stride_height_+1;
    pad_top                 = pdp_pad_top_;

    if (cube_in_height_iter == 0) { // Corner case 0: first row of input cube
        if (cube_in_width_iter == 0) // first column and first row (upper left corner of input cube)
            is_first_element = true;
        else if (((pad_left + cube_in_width_iter)%kernel_stride_width == 0) && (kernel_width_iter==0)) // left most kernel element, for data elements inside cube_in
            is_first_element = true;
    }
    else if (cube_in_width_iter == 0) { // Corner case 1: first columnnot the first row of input cube 
        if (((pad_top + cube_in_height_iter)%kernel_stride_height == 0) && (kernel_height_iter==0)) // top most kernel element, for data elements inside cube_in 
            is_first_element = true;
    }
    else    // Other cases
        is_first_element = (kernel_width_iter == 0) && (kernel_height_iter == 0) && ((pad_left + cube_in_width_iter)%kernel_stride_width==0) && ((pad_top + cube_in_height_iter)%kernel_stride_height==0);
    return is_first_element;
}
#pragma CTC ENDSKIP

// The last input (right most and bottom most of the kernel) element which contributes to the same output element
bool NV_NVDLA_pdp::IsLastElement(uint32_t cube_in_width, uint32_t pad_left, uint32_t width_iter, uint32_t height_iter, uint32_t kernel_width_iter, uint32_t kernel_height_iter) {
    uint32_t cube_in_height;
    uint32_t kernel_width, kernel_height;
    uint32_t kernel_stride_width, kernel_stride_height;
    uint32_t pad_top;
    bool     is_last_element = false;

    cube_in_height      = pdp_cube_in_height_+1;
    kernel_width        = pdp_kernel_width_+1;
    kernel_height       = pdp_kernel_height_+1;
    kernel_stride_width = pdp_kernel_stride_width_+1;
    kernel_stride_height= pdp_kernel_stride_height_+1;
    pad_top             = pdp_pad_top_;
#pragma CTC SKIP
    if (height_iter == (cube_in_height-1)) { // last row of input cube
        if (width_iter == (cube_in_width-1)) // last column and last row (lower right corner of input cube)
            is_last_element = true;
        else if (((pad_left + width_iter) >= (kernel_width - 1)) && ((pad_left + width_iter - (kernel_width - 1))%kernel_stride_width == 0) && (kernel_width_iter==(kernel_width-1))) // last row
            is_last_element = true;
    }
    else if (width_iter == (cube_in_width-1)) { // last column, and not last row
        if (((pad_top + height_iter) >= (kernel_height - 1)) && ((pad_top + height_iter - (kernel_height - 1))%kernel_stride_height == 0) && (kernel_height_iter==(kernel_height-1)))
            is_last_element = true;
    }
    else    // Other cases
        is_last_element = (kernel_width_iter == (kernel_width-1)) && (kernel_height_iter == (kernel_height-1)) &&
            ((pad_left + width_iter) >= (kernel_width - 1)) && ((pad_left + width_iter - (kernel_width - 1))%kernel_stride_width==0) &&
            ((pad_top + height_iter) >= (kernel_height - 1)) && ((pad_top + height_iter - (kernel_height - 1))%kernel_stride_height==0);
#pragma CTC ENDSKIP
    return is_last_element;
}

// The first input (left most and up most of the kernel, not counting padded elements) element which contributes to the same output element
bool NV_NVDLA_pdp::IsContributeToANewLine(uint32_t cube_in_height_iter, uint32_t kernel_height_iter) {
    uint32_t kernel_stride_height;
    uint32_t pad_top;
    bool is_contribute_to_a_new_line = false;

    kernel_stride_height    = pdp_kernel_stride_height_+1;
    pad_top                 = pdp_pad_top_;

    if (cube_in_height_iter == 0) { // Corner case 0: first row of input cube
        is_contribute_to_a_new_line = true;
    }
    else if (((pad_top + cube_in_height_iter)%kernel_stride_height == 0) && (kernel_height_iter==0)) { // top most kernel element, for data elements inside cube_in 
        is_contribute_to_a_new_line = true;
    }
    return is_contribute_to_a_new_line;
}

template <typename T_IN, typename T_OUT>
void NV_NVDLA_pdp::int_sign_extend(T_IN original_value, uint8_t sign_bit_idx, uint8_t extended_bit_num, T_OUT *return_value) {
    uint32_t bit_iter;
    int8_t  sign_bit_value;
    *return_value = 0;
    sign_bit_value = (original_value >> sign_bit_idx) & 0x1;
    *return_value = 0;
    for (bit_iter=0; bit_iter < uint32_t(extended_bit_num-sign_bit_idx-1); bit_iter ++) {
        *return_value = (*return_value << 1) | sign_bit_value;
    }
    *return_value = (*return_value << (sign_bit_idx+1)) | original_value;
    //  return *return_value;
}

#pragma CTC SKIP
NV_NVDLA_pdp * NV_NVDLA_pdpCon(sc_module_name name) {
    return new NV_NVDLA_pdp(name);
}
#pragma CTC ENDSKIP

void NV_NVDLA_pdp::reset_stats_regs() {
    nan_input_num = 0;
    inf_input_num = 0;
    nan_output_num = 0;
}

void NV_NVDLA_pdp::update_stats_regs() {
    cslInfo(("NV_NVDLA_pdp, nan_input_num:%d\n", nan_input_num));
    cslInfo(("NV_NVDLA_pdp, inf_input_num:%d\n", inf_input_num));
    cslInfo(("NV_NVDLA_pdp, nan_output_num:%d\n", nan_output_num));
    pdp_reg_model::PdpUpdateStatusRegister((uint32_t)NVDLA_PDP_D_NAN_INPUT_NUM_0,  pdp_consumer_, (uint32_t)nan_input_num);
    pdp_reg_model::PdpUpdateStatusRegister((uint32_t)NVDLA_PDP_D_INF_INPUT_NUM_0,  pdp_consumer_, (uint32_t)inf_input_num);
    pdp_reg_model::PdpUpdateStatusRegister((uint32_t)NVDLA_PDP_D_NAN_OUTPUT_NUM_0, pdp_consumer_, (uint32_t)nan_output_num);
}

