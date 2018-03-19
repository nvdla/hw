// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_bdma.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_bdma_base.h"
#include "NV_NVDLA_bdma_bdma_gen.h"
#include "BdmaCore.h"
#include "bdmacoreconfigclass.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "math.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

NV_NVDLA_bdma::NV_NVDLA_bdma( sc_module_name module_name ):
    NV_NVDLA_bdma_base(module_name)
{
    bdma_core_config_fifo_          = new sc_core::sc_fifo <BdmaCoreConfig> (BDMA_CONFIG_FIFO_DEPTH);
    bdma_core_int_fifo_             = new sc_core::sc_fifo <BdmaCoreInt> (2); // Only two outstanding int are allowed.
    // # Sub modules
    bdma_core = new BdmaCore("bdma_core");
    op_count  = 0;

    // Sub module connection
    // # BDMA core bdma_core
    bdma_core->core_config_in(*bdma_core_config_fifo_);
    bdma_core->bdma_core_int_fifo(*bdma_core_int_fifo_);
    bdma_core->reset_n_(reset);
    bdma_core->is_idle(core_is_idle);
    bdma_core->notify_get_config(core_notify_get_config);
    bdma_core->bdma2mcif_rd_req(bdma2mcif_rd_req);
    bdma_core->bdma2mcif_wr_req(bdma2mcif_wr_req);
    bdma_core->bdma2cvif_rd_req(bdma2cvif_rd_req);
    bdma_core->bdma2cvif_wr_req(bdma2cvif_wr_req);
    mcif2bdma_rd_rsp(bdma_core->mcif2bdma_rd_rsp);
    bdma_core->mcif2bdma_wr_rsp(mcif2bdma_wr_rsp);
    cvif2bdma_rd_rsp(bdma_core->cvif2bdma_rd_rsp);
    bdma_core->cvif2bdma_wr_rsp(cvif2bdma_wr_rsp);
    bdma_core->interrupt.bind(bdma2glb_done_intr);

    Reset();

    // SC_THREAD
    SC_THREAD(OperationEnableTriggerThread)
    SC_THREAD(LaunchGroup0TriggerThread)
    SC_THREAD(LaunchGroup1TriggerThread)
    SC_METHOD(UpdateIdleStatus)
    sensitive << core_is_idle;
    SC_METHOD(UpdateFreeSlotNum)
    sensitive << bdma_core_config_fifo_->data_written_event() << bdma_core_config_fifo_->data_read_event();
    SC_METHOD(ClearInt0Flag)
    sensitive << bdma2glb_done_intr[0];
    SC_METHOD(ClearInt1Flag)
    sensitive << bdma2glb_done_intr[1];
}

void NV_NVDLA_bdma::UpdateIdleStatus() {
    bool is_idle_bdmacore;
    bool is_idle;
    uint8_t free_slot_num;
    free_slot_num   = bdma_core_config_fifo_->num_free();
    is_idle_bdmacore= core_is_idle.read();
    is_idle         = is_idle_bdmacore && (BDMA_CONFIG_FIFO_DEPTH == free_slot_num);
    bdma_reg_model::BdmaUpdateIdleStatus(is_idle);
}

void NV_NVDLA_bdma::UpdateFreeSlotNum() {
    uint8_t free_slot_num;
    free_slot_num   = bdma_core_config_fifo_->num_free();
    cslDebug((50,"Call bdma_reg_model::BdmaUpdateFreeConfigSlotNum free_slot_num=%d\n", free_slot_num));
    bdma_reg_model::BdmaUpdateFreeConfigSlotNum(free_slot_num);
}

#pragma CTC SKIP
NV_NVDLA_bdma::~NV_NVDLA_bdma () {
    delete bdma_core_config_fifo_;
    delete bdma_core;
}
#pragma CTC ENDSKIP

void NV_NVDLA_bdma::Reset() {
    // BDMA interrupt wires to GLB
    uint32_t port_idx;
    for (port_idx = 0; port_idx < bdma2glb_done_intr.size(); port_idx++) {
        bdma2glb_done_intr[port_idx].initialize(false);
    }
    int0_op_running = false;
    int1_op_running = false;
}

void NV_NVDLA_bdma::ClearInt0Flag() {
    int0_op_running = false;
    bdma_reg_model::BdmaClearGrp0Int();
}

void NV_NVDLA_bdma::ClearInt1Flag() {
    int1_op_running = false;
    bdma_reg_model::BdmaClearGrp1Int();
}

void NV_NVDLA_bdma::LaunchGroup0TriggerThread() {
    BdmaCoreInt     bdma_int;
    while (true) {
        wait(launch_grp0_event_);

        bdma_int.int_enable = true;
        bdma_int.int_ptr    = 0;
        bdma_int.op_count   = op_count;
        bdma_core_int_fifo_->write(bdma_int);
        op_count            = 0;
#pragma CTC SKIP
        if(int0_op_running)
            FAIL(("BDMA: interrupt0 can't be used when the interrupt0 is not returned"));
#pragma CTC ENDSKIP
        else
            int0_op_running = true;
    }
}

void NV_NVDLA_bdma::LaunchGroup1TriggerThread() {
    BdmaCoreInt     bdma_int;
    while (true) {
        wait(launch_grp1_event_);

        bdma_int.int_enable = true;
        bdma_int.int_ptr    = 1;
        bdma_int.op_count   = op_count;
        bdma_core_int_fifo_->write(bdma_int);
        op_count            = 0;
#pragma CTC SKIP
        if(int1_op_running)
            FAIL(("BDMA: interrupt1 can't be used when the interrupt1 is not returned"));
#pragma CTC ENDSKIP
        else
            int1_op_running = true;
    }
}

void NV_NVDLA_bdma::OperationEnableTriggerThread() {
    BdmaCoreConfig bdma_config;
    while (true) {
        wait(operation_enable_event_);
        cout << "after wait operation_enable_event_" << endl;
        // Copy data from bdma_config_class to bdma_config
        bdma_config.cfg_src_addr_low_v32_ = bdma_config_class->cfg_src_addr_low_v32_;
        bdma_config.cfg_src_addr_high_v8_ = bdma_config_class->cfg_src_addr_high_v8_;
        bdma_config.cfg_dst_addr_low_v32_ = bdma_config_class->cfg_dst_addr_low_v32_;
        bdma_config.cfg_dst_addr_high_v8_ = bdma_config_class->cfg_dst_addr_high_v8_;
        bdma_config.cfg_line_size_ = bdma_config_class->cfg_line_size_+1;
        bdma_config.cfg_cmd_src_ram_type_ = bdma_config_class->cfg_cmd_src_ram_type_;
        bdma_config.cfg_cmd_dst_ram_type_ = bdma_config_class->cfg_cmd_dst_ram_type_;
        bdma_config.cfg_line_repeat_number_ = bdma_config_class->cfg_line_repeat_number_+1;
        bdma_config.cfg_src_line_stride_ = bdma_config_class->cfg_src_line_stride_;
        bdma_config.cfg_dst_line_stride_ = bdma_config_class->cfg_dst_line_stride_;
        bdma_config.cfg_surf_repeat_number_ = bdma_config_class->cfg_surf_repeat_number_+1;
        bdma_config.cfg_src_surf_stride_ = bdma_config_class->cfg_src_surf_stride_;
        bdma_config.cfg_dst_surf_stride_ = bdma_config_class->cfg_dst_surf_stride_;
        bdma_config.cfg_launch0_grp0_launch_ = 0;
        bdma_config.cfg_launch1_grp1_launch_ = 0;
        bdma_core_config_fifo_->write(bdma_config);
        cout << "after write to bdma_core_config_fifo_" << endl;
        //bdma_reg_model::BdmaClearOperationEnable();
    }
}

#pragma CTC SKIP
void NV_NVDLA_bdma::mcif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
}

void NV_NVDLA_bdma::cvif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
}

NV_NVDLA_bdma * NV_NVDLA_bdmaCon(sc_module_name name) {
    return new NV_NVDLA_bdma(name);
}
#pragma CTC ENDSKIP

