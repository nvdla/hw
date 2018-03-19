// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: BdmaCore.cpp

#include <algorithm>
#include <iomanip>
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "BdmaCore.h"
#include "bdmacoreconfigclass.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

enum BDMA_OPERATION_MODE_ALIAS {
    LINE_PACKED,
    LINE_UNPACKED
};

// Constructor for base SystemC class for module BdmaCore
BdmaCore::BdmaCore(sc_module_name name)
    : sc_module(name),
    interrupt("interrupt", 2),
    mcif2bdma_rd_rsp("mcif2bdma_rd_rsp"),
    bdma2mcif_rd_req_bp(),
    bdma2mcif_rd_req("bdma2mcif_rd_req"),
    bdma2mcif_wr_req_bp(),
    bdma2mcif_wr_req("bdma2mcif_wr_req"),
    cvif2bdma_rd_rsp("cvif2bdma_rd_rsp"),
    bdma2cvif_rd_req_bp(),
    bdma2cvif_rd_req("bdma2cvif_rd_req"),
    bdma2cvif_wr_req_bp(),
    bdma2cvif_wr_req("bdma2cvif_wr_req")
{
    write_config_fifo_          = new sc_core::sc_fifo <BdmaCoreConfig> (BDMA_CONFIG_FIFO_DEPTH);
#if 0
    expected_wr_ack             = new sc_fifo <uint8_t> (2);
    expected_wr_ack_mc          = new sc_fifo <uint8_t> (2);
    expected_wr_ack_cv          = new sc_fifo <uint8_t> (2);
#endif
    bdma_ack_fifo_              = new sc_fifo <bdma_ack_info*> (2);

    // DMA atom FIFO memory allocation
//    dma_atom_fifo_              = new sc_fifo <DmaAtom> (BDMA_CORE_DMA_ATOM_FIFO_SIZE/DMA_ATOM_SIZE);
    dma_atom_fifo_              = new sc_fifo <DmaAtom> (1024);
#if 0
    write_complete_interrupt_ptr_fifo_  = new sc_fifo <uint8_t> (BDMA_CORE_ONGOING_WRITE_COMPLETE_REQUEST);
#endif
    rd_req_cmd_payload          = new nvdla_dma_rd_req_t;
    wr_req_cmd_payload          = new nvdla_dma_wr_req_t;
    wr_req_data_payload         = new nvdla_dma_wr_req_t;
    wr_req_cmd_payload->tag     = TAG_CMD;
    wr_req_data_payload->tag    = TAG_DATA;
    dma_delay_                  = SC_ZERO_TIME;
    src_ram_type_next_          = NVDLA_BDMA_CFG_CMD_0_SRC_RAM_TYPE_MC;
    src_ram_type_curr_          = NVDLA_BDMA_CFG_CMD_0_SRC_RAM_TYPE_MC;
    //read_credit_                = BDMA_MAX_ONGOING_READ_REQUEST;
    read_credit_sent_           = 0;
    read_credit_recv_           = 0;

    is_mc_ack_done_             = false;
    is_cv_ack_done_             = false;

    // Target Socket (unrecognized protocol: nvdla_dma_rd_rsp_t): mcif2bdma_rd_rsp
    this->mcif2bdma_rd_rsp.register_b_transport(this, &BdmaCore::mcif2bdma_rd_rsp_b_transport);
    this->cvif2bdma_rd_rsp.register_b_transport(this, &BdmaCore::cvif2bdma_rd_rsp_b_transport);
   
    // SC_THREAD
    SC_METHOD(ResetThread)
    sensitive << reset_n_;
    SC_THREAD(ReadRequestSequenceGeneratorThread);
    SC_THREAD(WriteRequestSequenceGeneratorThread);
    SC_METHOD(WriteResponseMethodMc);
    sensitive << mcif2bdma_wr_rsp;
    SC_METHOD(WriteResponseMethodCv);
    sensitive << cvif2bdma_wr_rsp;
    SC_THREAD(BdmaIntrThread);
}

#pragma CTC SKIP
BdmaCore::~BdmaCore () {
    if (write_config_fifo_)                 delete write_config_fifo_;
#if 0
    if (expected_wr_ack)                    delete expected_wr_ack;
    if (expected_wr_ack_mc)                 delete expected_wr_ack_mc;
    if (expected_wr_ack_cv)                 delete expected_wr_ack_cv;
#endif
    if (bdma_ack_fifo_)                     delete bdma_ack_fifo_;
    if (dma_atom_fifo_)                     delete dma_atom_fifo_;
#if 0
    if (write_complete_interrupt_ptr_fifo_) delete write_complete_interrupt_ptr_fifo_;
#endif
    if (rd_req_cmd_payload)                 delete rd_req_cmd_payload;
    if (wr_req_cmd_payload)                 delete wr_req_cmd_payload;
    if (wr_req_data_payload)                delete wr_req_data_payload;
}
#pragma CTC ENDSKIP

void BdmaCore::ResetThread() {
    is_idle.write(true);
    cslInfo(("BdmaCore::ResetThread\n"));
}

void BdmaCore::ReadRequestSequenceGeneratorThread() {
    BdmaCoreConfig core_config;
    BdmaCoreInt    bdma_int;
    //bool        is_line_packed;
    uint64_t    cube_base_addr;
    uint32_t    surface_iter;
    uint64_t    surface_base_addr;
//    uint32_t    surface_size;
    uint32_t    line_iter;
    uint32_t    line_size;
    uint64_t    payload_addr;
    uint32_t    payload_size;
    uint32_t    payload_atom_num;
    uint32_t    i;
    while (true) {
        // Blocking FIFO read
        bdma_core_int_fifo->read(bdma_int);
        cslInfo(("BdmaCore::ReadRequestSequenceGeneratorThread, one bdma operation group starts. int_ptr=%d op_count=%d\n", bdma_int.int_ptr, bdma_int.op_count));
        is_idle.write(false);

        for (i=0;i<bdma_int.op_count;i++) {
            core_config_in->read(core_config);

            cslInfo(("BdmaCore::ReadRequestSequenceGeneratorThread, before notify_get_config.\n"));
            notify_get_config.write(true);
            cslInfo(("BdmaCore::ReadRequestSequenceGeneratorThread, before write_config_fifo_.\n"));
            if (i==(uint32_t)(bdma_int.op_count-1)) {
                if (bdma_int.int_ptr == 0) {
                    core_config.cfg_launch0_grp0_launch_ = 1;
                    core_config.cfg_launch1_grp1_launch_ = 0;
                }
                else {
                    core_config.cfg_launch0_grp0_launch_ = 0;
                    core_config.cfg_launch1_grp1_launch_ = 1;
                }
            } else {
                core_config.cfg_launch0_grp0_launch_ = 0;
                core_config.cfg_launch1_grp1_launch_ = 0;
            }
            write_config_fifo_->write(core_config);
            // Evaluating line packed or not
            //if ( core_config.cfg_line_size_ == core_config.cfg_src_line_stride_ ) {
            //    is_line_packed = true;
            //} else {
            //    is_line_packed = false;
            //}

            src_ram_type_next_ = core_config.cfg_cmd_src_ram_type_;
            if (src_ram_type_curr_ != src_ram_type_next_) {
                // Source switch, wait until credit back to initial value
                while (read_credit_sent_ != read_credit_recv_) {
                    cslDebug((50, "BdmaCore::ReadRequestSequenceGeneratorThread, switch source, wait until all read response back.\n"));
                    wait(read_credit_granted_);
                    cslDebug((50, "BdmaCore::ReadRequestSequenceGeneratorThread, sent_credit=%ld, recv_credit=%ld\n", read_credit_sent_, read_credit_recv_));
                }
                read_credit_sent_ = 0;
                read_credit_recv_ = 0;
                src_ram_type_curr_ = src_ram_type_next_;
            }
            // Evaluate base address
            cube_base_addr = uint64_t(core_config.cfg_src_addr_high_v8_) << 32 | uint64_t(core_config.cfg_src_addr_low_v32_) << 5;
            // Surface Loop
            for (surface_iter = 0; surface_iter < core_config.cfg_surf_repeat_number_; surface_iter ++) {
                cslDebug((50, "BdmaCore::ReadRequestSequenceGeneratorThread, surface_iter=%d start\n", surface_iter));
                surface_base_addr = cube_base_addr + uint64_t(surface_iter * (core_config.cfg_src_surf_stride_ << 5));
                cslDebug((50, "BdmaCore::ReadRequestSequenceGeneratorThread, surf_stride=%x\n", core_config.cfg_src_surf_stride_));
                //if (true == is_line_packed) {    //deprecated routine
                if (0) { /*
                    surface_size = core_config.cfg_line_repeat_number_ * core_config.cfg_line_size_ * 32;
                    payload_addr = surface_base_addr;
                    payload_size = surface_size;
                    payload_atom_num = (payload_size+DMA_ATOM_SIZE-1)/DMA_ATOM_SIZE;
                    rd_req_cmd_payload->pd.dma_read_cmd.addr = payload_addr;
                    rd_req_cmd_payload->pd.dma_read_cmd.size = payload_atom_num-1;
                    //WaitUntilAtomFifoFreeEntryGreaterThan(payload_atom_num);
                    //read_credit_mutex_.lock();
                    //read_credit_ = read_credit_ - payload_atom_num;
                    read_credit_sent_ += payload_atom_num;
                    cslDebug((50, "BdmaCore::sent_credit=%d.\n", read_credit_sent_));
                    SendDmaReadRequest(rd_req_cmd_payload, dma_delay_, core_config.cfg_cmd_src_ram_type_);
                    //read_credit_mutex_.unlock(); */
                } else {
                    // Line loop
                    for (line_iter = 0; line_iter < core_config.cfg_line_repeat_number_; line_iter ++) {
                        cslDebug((50, "BdmaCore::ReadRequestSequenceGeneratorThread, line_iter=%d start\n", line_iter));
                        line_size = core_config.cfg_line_size_ * 32;
                        payload_addr = surface_base_addr + line_iter * (core_config.cfg_src_line_stride_ << 5);
                        cslDebug((50, "BdmaCore::ReadRequestSequenceGeneratorThread, line_size=%d, addr=%lx\n", line_size, payload_addr));
                        payload_size = line_size;
                        payload_atom_num = (payload_size+DMA_ATOM_SIZE-1)/DMA_ATOM_SIZE;
                        rd_req_cmd_payload->pd.dma_read_cmd.addr = payload_addr;
                        rd_req_cmd_payload->pd.dma_read_cmd.size = payload_atom_num-1;
                        //WaitUntilAtomFifoFreeEntryGreaterThan(payload_atom_num);
                        //read_credit_mutex_.lock();
                        //read_credit_ = read_credit_ - payload_atom_num;
                        read_credit_sent_ += payload_atom_num;
                        cslDebug((50, "BdmaCore::sent_credit=%ld.\n", read_credit_sent_));
                        SendDmaReadRequest(rd_req_cmd_payload, dma_delay_, core_config.cfg_cmd_src_ram_type_);
                        //read_credit_mutex_.unlock();
                        cslDebug((50, "BdmaCore::ReadRequestSequenceGeneratorThread, line_iter=%d end\n", line_iter));
                    }
                }
                cslDebug((50, "BdmaCore::ReadRequestSequenceGeneratorThread, surface_iter=%d end\n", surface_iter));
            }
            cslInfo(("BdmaCore::ReadRequestSequenceGeneratorThread, read sequence end.\n"));
        }
    }
}

void BdmaCore::mcif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) {
    cslDebug((50, "BdmaCore::mcif2bdma_rd_rsp_b_transport, begin.\n"));
#pragma CTC SKIP
    if ( NVDLA_BDMA_CFG_CMD_0_SRC_RAM_TYPE_MC != src_ram_type_curr_ ) {
        FAIL(("BdmaCore::mcif2bdma_rd_rsp_b_transport, src config is not mc"));
    }
#pragma CTC ENDSKIP
    //read_credit_mutex_.lock();
    //  Each payload is 64 byte, two mask bit tells which 32 byte groups are effective
    DmaAtom dma_atom;
    uint64_t * payload_data_ptr, * dma_atom_ptr;
    uint8_t mask;
    mask = payload->pd.dma_read_data.mask;
    payload_data_ptr    = reinterpret_cast <uint64_t *> (payload->pd.dma_read_data.data);
    dma_atom_ptr        = reinterpret_cast <uint64_t *> (dma_atom.data);

    // Handling lower 32 bytes
    if (0 != (mask & 0x1)) {
        memcpy(dma_atom_ptr,payload_data_ptr,DMA_ATOM_SIZE);
        dma_atom_fifo_->write(dma_atom);
        //read_credit_ ++;
        read_credit_recv_++;
    }

    // Handling upper 32 bytes
    if (0 != (mask & 0x2)) {
        memcpy(dma_atom_ptr,&payload_data_ptr[4],DMA_ATOM_SIZE);
        dma_atom_fifo_->write(dma_atom);
        //read_credit_ ++;
        read_credit_recv_++;
    }
    cslDebug((50, "BdmaCore::mcif2bdma_rd_rsp_b_transport, recv_credit=%ld\n", read_credit_recv_));
    read_credit_granted_.notify();
    //read_credit_mutex_.unlock();    
    cslDebug((50, "BdmaCore::mcif2bdma_rd_rsp_b_transport, end.\n"));
}

void BdmaCore::cvif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay) {
#pragma CTC SKIP
    if ( NVDLA_BDMA_CFG_CMD_0_SRC_RAM_TYPE_MC == src_ram_type_curr_ ) {
        FAIL(("BdmaCore::cvif2bdma_rd_rsp_b_transport, src config is not CV_SRAM"));
    }
#pragma CTC ENDSKIP
    //read_credit_mutex_.lock();
    //  Each payload is 64 byte, two mask bit tells which 32 byte groups are effective
    DmaAtom dma_atom;
    uint64_t * payload_data_ptr, * dma_atom_ptr;
    uint8_t mask;
    mask = payload->pd.dma_read_data.mask;
    payload_data_ptr    = reinterpret_cast <uint64_t *> (payload->pd.dma_read_data.data);
    dma_atom_ptr        = reinterpret_cast <uint64_t *> (dma_atom.data);

    // Handling lower 32 bytes
    if (0 != (mask & 0x1)) {
        memcpy(dma_atom_ptr,payload_data_ptr,DMA_ATOM_SIZE);
        dma_atom_fifo_->write(dma_atom);
        //read_credit_ ++;
        read_credit_recv_++;
    }

    // Handling upper 32 bytes
    if (0 != (mask & 0x2)) {
        memcpy(dma_atom_ptr,&payload_data_ptr[4],DMA_ATOM_SIZE);
        dma_atom_fifo_->write(dma_atom);
        //read_credit_ ++;
        read_credit_recv_++;
    }
    cslDebug((50, "BdmaCore::cvif2bdma_rd_rsp_b_transport, recv_credit=%ld\n", read_credit_recv_));
    read_credit_granted_.notify();
    //read_credit_mutex_.unlock();
}

void BdmaCore::WriteRequestSequenceGeneratorThread() {
    BdmaCoreConfig core_config;
    //bool        is_line_packed;
    uint64_t    cube_base_addr;
    uint32_t    surface_iter;
    uint64_t    surface_base_addr;
//    uint32_t    surface_size;
    uint32_t    line_iter;
    uint32_t    line_size;
    uint32_t    line_size_sent;
    uint64_t    payload_addr;
    uint32_t    payload_size;
    bool        is_write_complete_required;
    uint32_t    payload_atom_num, payload_atom_num_sent; //, payload_atom_num_req;
    while (true) {
        write_config_fifo_->read(core_config);
        cslInfo(("BdmaCore::WriteRequestSequenceGeneratorThread, write sequence start.\n"));
        dst_ram_type_ = core_config.cfg_cmd_dst_ram_type_;
        wr_req_cmd_payload->pd.dma_write_cmd.require_ack = 0;
        //bdma_core_int = new BdmaCoreInt();
        is_write_complete_required = (core_config.cfg_launch0_grp0_launch_ || core_config.cfg_launch1_grp1_launch_);
        //bdma_core_int->int_enable = is_write_complete_required;
        //bdma_core_int->int_ptr = core_config.cfg_launch0_grp0_launch_? 0: 1;
#if 0
        if ( is_write_complete_required ) {
            write_complete_interrupt_ptr_fifo_->write(core_config.cfg_launch0_grp0_launch_? 0: 1);
        }
#endif
        // Evaluating line packed or not
        //if ( core_config.cfg_line_size_ == core_config.cfg_dst_line_stride_ ) {
        //    is_line_packed = true;
        //} else {
        //    is_line_packed = false;
        //}
        cube_base_addr = uint64_t(core_config.cfg_dst_addr_high_v8_) << 32 | uint64_t(core_config.cfg_dst_addr_low_v32_) << 5;
        // Surface Loop
        for (surface_iter = 0; surface_iter < core_config.cfg_surf_repeat_number_; surface_iter ++) {
            cslDebug((50, "BdmaCore::WriteRequestSequenceGeneratorThread, surface_iter=%d start\n", surface_iter));
            surface_base_addr = cube_base_addr + uint64_t(surface_iter * (core_config.cfg_dst_surf_stride_ << 5));
            //if (true == is_line_packed) {    //deprecated routine
            if (0) { /*
                // Write surface in one write request
                surface_size = core_config.cfg_line_repeat_number_ * core_config.cfg_line_size_ * 32;
                payload_addr = surface_base_addr;
                payload_size = surface_size;
                payload_atom_num = (payload_size+DMA_ATOM_SIZE-1)/DMA_ATOM_SIZE;
                wr_req_cmd_payload->pd.dma_write_cmd.addr = payload_addr;
                wr_req_cmd_payload->pd.dma_write_cmd.size = payload_atom_num - 1;
                if ( (true == is_write_complete_required) && (surface_iter == core_config.cfg_surf_repeat_number_-1) ) {
                    //The last request in the cube needs write ack
                    wr_req_cmd_payload->pd.dma_write_cmd.require_ack = 1;
#if 0
                    if (NVDLA_BDMA_CFG_CMD_0_DST_RAM_TYPE_MC == core_config.cfg_cmd_dst_ram_type_) {
                        expected_wr_ack_mc->write(1);
                    } else {
                        expected_wr_ack_cv->write(1);
                    }
                    expected_wr_ack->write(1);
#endif
        		    bdma_ack_info *ack = new bdma_ack_info;
		            ack->is_mc = NVDLA_CDP_D_DST_DMA_CFG_0_DST_RAM_TYPE_MC == core_config.cfg_cmd_dst_ram_type_;
        		    ack->group_id = core_config.cfg_launch0_grp0_launch_? 0 : 1;
		            bdma_ack_fifo_->write(ack);
                }
                // Send cmd
                SendDmaWriteRequest(wr_req_cmd_payload, dma_delay_, core_config.cfg_cmd_dst_ram_type_);

                payload_atom_num_sent = 0;
                while (payload_atom_num_sent < payload_atom_num) {
                    payload_atom_num_req = min(2, int32_t (payload_atom_num - payload_atom_num_sent));
                    //WaitUntilAtomFifoAvailableEntryGreaterThan(payload_atom_num_req);
                    PrepareWriteDataPayload(wr_req_data_payload, payload_atom_num_req);
                    // Send 64B data
                    SendDmaWriteRequest(wr_req_data_payload, dma_delay_, core_config.cfg_cmd_dst_ram_type_);
                    payload_atom_num_sent += payload_atom_num_req;
                } */
            } else {
                // Line loop
                for (line_iter = 0; line_iter < core_config.cfg_line_repeat_number_; line_iter ++) {
                    cslDebug((50, "BdmaCore::WriteRequestSequenceGeneratorThread, line_iter=%d start\n", line_iter));
                    line_size = core_config.cfg_line_size_ * 32;
                    cslDebug((50, "BdmaCore::WriteRequestSequenceGeneratorThread, line_size=%d\n", line_size));
                    payload_addr = surface_base_addr + line_iter * (core_config.cfg_dst_line_stride_ << 5 );
                    line_size_sent = 0;
                    while (line_size_sent < line_size) {
                        // payload_size = min( uint32_t(line_size - line_size_sent), uint32_t(MEM_TRANSACTION_MAX_SIZE - payload_addr%MEM_TRANSACTION_MAX_SIZE) );
                        payload_size = line_size;
                        payload_atom_num = (payload_size+DMA_ATOM_SIZE-1)/DMA_ATOM_SIZE;
                        cslDebug((50, "BdmaCore::WriteRequestSequenceGeneratorThread, DMA_ATOM_SIZE-1=%d, payload_atom_num=%d\n", DMA_ATOM_SIZE-1, payload_atom_num));
                        wr_req_cmd_payload->pd.dma_write_cmd.addr = payload_addr;
                        wr_req_cmd_payload->pd.dma_write_cmd.size = payload_atom_num - 1;
                        //WaitUntilAtomFifoAvailableEntryGreaterThan(payload_atom_num);
                        if ( (true == is_write_complete_required) && (surface_iter == (core_config.cfg_surf_repeat_number_-1)) && (line_iter == (core_config.cfg_line_repeat_number_-1)) /* && ((line_size_sent+payload_size) == line_size)*/ ) 
                        {
                            //The last request in the cube needs write ack
                            wr_req_cmd_payload->pd.dma_write_cmd.require_ack = 1;
#if 0
                            if (NVDLA_BDMA_CFG_CMD_0_DST_RAM_TYPE_MC == core_config.cfg_cmd_dst_ram_type_) {
                                expected_wr_ack_mc->write(1);
                            } else {
                                expected_wr_ack_cv->write(1);
                            }
                            expected_wr_ack->write(1);
#endif

		                    bdma_ack_info *ack = new bdma_ack_info;
		                    ack->is_mc = NVDLA_CDP_D_DST_DMA_CFG_0_DST_RAM_TYPE_MC == core_config.cfg_cmd_dst_ram_type_;
		                    ack->group_id = core_config.cfg_launch0_grp0_launch_? 0 : 1;
		                    bdma_ack_fifo_->write(ack);
                        }
                        SendDmaWriteRequest(wr_req_cmd_payload, dma_delay_, core_config.cfg_cmd_dst_ram_type_);
                        cslDebug((50, "BdmaCore::WriteRequestSequenceGeneratorThread, sent dma write request, command.\n"));
                        payload_atom_num_sent = 0;
                        while (payload_atom_num_sent < payload_atom_num) {
                            cslDebug((50, "BdmaCore::WriteRequestSequenceGeneratorThread, payload_atom_num_sent=0x%x payload_atom_num=0x%x\n", payload_atom_num_sent, payload_atom_num));
                            PrepareWriteDataPayload(wr_req_data_payload,min(2,int32_t(payload_atom_num-payload_atom_num_sent)));
                            cslDebug((50, "BdmaCore::WriteRequestSequenceGeneratorThread, PrepareWriteDataPayload done\n"));
                            SendDmaWriteRequest(wr_req_data_payload, dma_delay_, core_config.cfg_cmd_dst_ram_type_);
                            cslDebug((50, "BdmaCore::WriteRequestSequenceGeneratorThread, sent dma write request, data\n"));
                            payload_atom_num_sent += min(2,int32_t(payload_atom_num-payload_atom_num_sent));
                        }
                        payload_addr += payload_size;
                        line_size_sent += payload_size;
                    }
                    cslDebug((50, "BdmaCore::WriteRequestSequenceGeneratorThread, line_iter=%d end\n", line_iter));
                }
            }
            cslDebug((50, "BdmaCore::WriteRequestSequenceGeneratorThread, surface_iter=%d end\n", surface_iter));
        }
        cslInfo(("BdmaCore::WriteRequestSequenceGeneratorThread, write sequence end.\n"));
    }
}

void BdmaCore::WriteResponseMethodMc() {
    cslInfo(("BdmaCore::WriteResponseThreadMc is called\n"));
    if ( true == mcif2bdma_wr_rsp.read() ) {
        is_mc_ack_done_ = true;
        bdma_mc_ack_.notify();
    }
}

void BdmaCore::WriteResponseMethodCv() {
    cslInfo(("BdmaCore::WriteResponseThreadCv is called\n"));
    if ( true == cvif2bdma_wr_rsp.read() ) {
        is_cv_ack_done_ = true;
        bdma_cv_ack_.notify();
    }
}

void BdmaCore::BdmaIntrThread() {
    while (true) {
        while (uint32_t(bdma_ack_fifo_->num_available()) < 1) {
            wait( bdma_ack_fifo_->data_written_event() );
        }
        bdma_ack_info *ack = bdma_ack_fifo_->read();

        if (ack->is_mc) {
            if (!is_mc_ack_done_)
                wait(bdma_mc_ack_);

            is_mc_ack_done_ = false;
        } else {
            if (!is_cv_ack_done_)
                wait(bdma_cv_ack_);

            is_cv_ack_done_ = false;
        }

        wait(1, SC_NS);
        interrupt[ack->group_id].write(true);
    
        cslInfo(("BdmaCore::group %d interrupt %s\n", ack->group_id, ack->is_mc? "MC":"CV"));

        if(bdma_ack_fifo_->num_available()==0 && write_config_fifo_->num_available()==0) is_idle.write(true);

        delete ack;
    }
}

#pragma CTC SKIP
void BdmaCore::Reset()
{
    // Clear register and internal states
    // BdmaCore interrupt wires to GLB
    uint32_t port_idx;
    for (port_idx = 0; port_idx < interrupt.size(); port_idx++) {
        interrupt[port_idx].initialize(false);
    }
}

// Check free entry numbers in atom fifo
void BdmaCore::WaitUntilAtomFifoFreeEntryGreaterThan(uint8_t num) {
    while (dma_atom_fifo_->num_free() < num) {
        wait( dma_atom_fifo_->data_read_event() );
    }
}

// Check available entry numbers in atom fifo
void BdmaCore::WaitUntilAtomFifoAvailableEntryGreaterThan(uint8_t num) {
    while (dma_atom_fifo_->num_available() < num) {
        cslInfo(("BdmaCore::WaitUntilAtomFifoAvailableEntryGreaterThan, num=%d\n", num ));
        wait( dma_atom_fifo_->data_written_event() );
        cslInfo(("BdmaCore::WaitUntilAtomFifoAvailableEntryGreaterThan, avail=%d\n", dma_atom_fifo_->num_available() ));
    }
}
#pragma CTC ENDSKIP

void BdmaCore::PrepareWriteDataPayload(nvdla_dma_wr_req_t * payload, uint8_t num) {
    DmaAtom dma_atom;
    uint64_t * payload_data_ptr, * dma_atom_ptr;
    dma_atom_fifo_->read(dma_atom);
    payload_data_ptr    = reinterpret_cast <uint64_t *> (payload->pd.dma_write_data.data);
    dma_atom_ptr        = reinterpret_cast <uint64_t *> (dma_atom.data);
    memcpy(payload_data_ptr,dma_atom_ptr,DMA_ATOM_SIZE);
    if (num == 2) {
        dma_atom_fifo_->read(dma_atom);
        dma_atom_ptr        = reinterpret_cast <uint64_t *> (dma_atom.data);
        memcpy(payload_data_ptr+4, dma_atom_ptr, DMA_ATOM_SIZE);
    }
}

// Send DMA read request
void BdmaCore::SendDmaReadRequest(nvdla_dma_rd_req_t* payload, sc_time& delay, uint8_t src_ram_type) {
    if ( NVDLA_BDMA_CFG_CMD_0_SRC_RAM_TYPE_MC == src_ram_type ) {
        cslDebug((50, "BdmaCore::SendDmaReadRequest, send read request to MC Address=0x%lx Size=0x%x\n", payload->pd.dma_read_cmd.addr, payload->pd.dma_read_cmd.size));
        bdma2mcif_rd_req_b_transport(payload, dma_delay_);
    } else {
        cslDebug((50, "BdmaCore::SendDmaReadRequest, send read request to CV Address=0x%lx Size=0x%x\n", payload->pd.dma_read_cmd.addr, payload->pd.dma_read_cmd.size));
        bdma2cvif_rd_req_b_transport(payload, dma_delay_);
    }
}

// Send DMA write request
void BdmaCore::SendDmaWriteRequest(nvdla_dma_wr_req_t* payload, sc_time& delay, uint8_t dst_ram_type) {
    if (NVDLA_BDMA_CFG_CMD_0_DST_RAM_TYPE_MC == dst_ram_type) {
        if(TAG_CMD == payload->tag) {
            cslDebug((50, "BdmaCore::SendDmaWriteRequest, send write request to MC command. Address=0x%lx Size=0x%x\n", payload->pd.dma_write_cmd.addr, payload->pd.dma_write_cmd.size));
        } else {
            cslDebug((50, "BdmaCore::SendDmaWriteRequest, send write request to MC, data.\n"));
        }
        bdma2mcif_wr_req_b_transport(payload, dma_delay_);
    } else {
        if(TAG_CMD == payload->tag) {
            cslDebug((50, "BdmaCore::SendDmaWriteRequest, send write request to CV command. Address=0x%lx Size=0x%x\n", payload->pd.dma_write_cmd.addr, payload->pd.dma_write_cmd.size));
        } else {
            cslDebug((50, "BdmaCore::SendDmaWriteRequest, send write request to CV, data.\n"));
        }
        bdma2cvif_wr_req_b_transport(payload, dma_delay_);
    }
}

#pragma CTC SKIP
BdmaCore * BdmaCoreCon(sc_module_name name) {
    return new BdmaCore(name);
}
#pragma CTC ENDSKIP

