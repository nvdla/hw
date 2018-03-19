// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: bdma_reg_model.cpp

#include "bdma_reg_model.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "bdmacoreconfigclass.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>


//HACK
//In opendla.h, there are no DEFAULT_MASK definitions
#define NVDLA_BDMA_STATUS_0_FREE_SLOT_DEFAULT_MASK 0xff
#define NVDLA_BDMA_STATUS_0_IDLE_DEFAULT_MASK      0x1

#pragma CTC SKIP
SCSIM_NAMESPACE_START(cmod)
    MK_UREGSET_CLASS(NVDLA_BDMA)
SCSIM_NAMESPACE_END()
#pragma CTC ENDSKIP

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace tlm;
using namespace sc_core;
using namespace std;
// std::ostream& operator<<(std::ostream& out, const BdmaCoreConfig & obj) {
//     return out << "Just to fool compiler" << endl;
// }


bdma_reg_model::bdma_reg_model() {
    bdma_register_group = new CNVDLA_BDMA_REGSET;
    bdma_config_class = new BdmaCoreConfig;
    BdmaRegReset();
}

#pragma CTC SKIP
bdma_reg_model::~bdma_reg_model() {
    delete bdma_register_group;
    delete bdma_config_class;
}
#pragma CTC ENDSKIP

bool bdma_reg_model::BdmaAccessRegister(uint32_t reg_addr, uint32_t & data, bool is_write) {
    uint32_t offset, operation_enable_offset, launch0_offset, launch1_offset, status_offset;
    uint32_t rdata = 0;

    offset                  = (reg_addr & 0xFFF);  // each sub-unit has only 4KBytes
    operation_enable_offset = REG_off(NVDLA_BDMA_CFG_OP);
    launch0_offset          = REG_off(NVDLA_BDMA_CFG_LAUNCH0);
    launch1_offset          = REG_off(NVDLA_BDMA_CFG_LAUNCH1);
    status_offset           = REG_off(NVDLA_BDMA_STATUS);

    if (is_write) { // Write Request
        cslDebug((50, "bdma is_write=%d reg_addr=0x%x offset=0x%x value=0x%x\x0A", is_write, reg_addr, offset, data));
        if (offset == operation_enable_offset) {
            op_count++;
            BdmaUpdateVariables(bdma_register_group);
            operation_enable_event_.notify();
        }
        else if (offset == launch0_offset) {
            bdma_register_group->rSTATUS.uGRP0_BUSY(1);
            launch_grp0_event_.notify();
        }
        else if (offset == launch1_offset) {
            bdma_register_group->rSTATUS.uGRP1_BUSY(1);
            launch_grp1_event_.notify();
        }
        else if (offset == status_offset) { //status register is read-only
        }
        else {
            bdma_register_group->SetWritable(offset, data);
        }
    } else { // Read Request
        bdma_register_group->GetReadable(offset, &rdata);
        cslDebug((50, "bdma is_write=%d reg_addr=0x%x offset=0x%x value=0x%x\x0A", is_write, reg_addr, offset, rdata));
        data = rdata;
    }
    return true;
}

void bdma_reg_model::BdmaRegReset() {
        bdma_register_group->ResetAll();

}

void bdma_reg_model::BdmaClearOperationEnable() {
    uint32_t operation_enable_offset, data;
    operation_enable_offset = REG_off(NVDLA_BDMA_CFG_OP);
    data = NVDLA_BDMA_CFG_OP_0_EN_DISABLE<<NVDLA_BDMA_CFG_OP_0_EN_SHIFT;
    bdma_register_group->SetWritable(operation_enable_offset, data);
}

void bdma_reg_model::BdmaUpdateFreeConfigSlotNum(uint8_t num) {
    uint32_t data;
    data = num & NVDLA_BDMA_STATUS_0_FREE_SLOT_DEFAULT_MASK;
    bdma_register_group->rSTATUS.uFREE_SLOT(data);
}

void bdma_reg_model::BdmaUpdateIdleStatus(bool status) {
    // uint32_t reg_offset, data;
    // reg_offset = REG_off(NVDLA_BDMA_STATUS);
    // bdma_register_group->Get(reg_offset, &data);
    // data = ( status | 
    //         (data & ~(NVDLA_BDMA_STATUS_0_IDLE_DEFAULT_MASK  << NVDLA_BDMA_STATUS_0_IDLE_SHIFT)) );
    // bdma_register_group->SetWritable(reg_offset, data);
    uint32_t data;
    data = status & NVDLA_BDMA_STATUS_0_IDLE_DEFAULT_MASK;
    bdma_register_group->rSTATUS.uIDLE(data);
}

void bdma_reg_model::BdmaUpdateVariables(CNVDLA_BDMA_REGSET *reg_group_ptr) {
        bdma_config_class->cfg_src_addr_low_v32_ = reg_group_ptr->rCFG_SRC_ADDR_LOW.uV32();
        bdma_config_class->cfg_src_addr_high_v8_ = reg_group_ptr->rCFG_SRC_ADDR_HIGH.uV8();
        bdma_config_class->cfg_dst_addr_low_v32_ = reg_group_ptr->rCFG_DST_ADDR_LOW.uV32();
        bdma_config_class->cfg_dst_addr_high_v8_ = reg_group_ptr->rCFG_DST_ADDR_HIGH.uV8();
        bdma_config_class->cfg_line_size_ = reg_group_ptr->rCFG_LINE.uSIZE();
        bdma_config_class->cfg_cmd_src_ram_type_ = reg_group_ptr->rCFG_CMD.uSRC_RAM_TYPE();
        bdma_config_class->cfg_cmd_dst_ram_type_ = reg_group_ptr->rCFG_CMD.uDST_RAM_TYPE();
        bdma_config_class->cfg_line_repeat_number_ = reg_group_ptr->rCFG_LINE_REPEAT.uNUMBER();
        bdma_config_class->cfg_src_line_stride_ = reg_group_ptr->rCFG_SRC_LINE.uSTRIDE();
        bdma_config_class->cfg_dst_line_stride_ = reg_group_ptr->rCFG_DST_LINE.uSTRIDE();
        bdma_config_class->cfg_surf_repeat_number_ = reg_group_ptr->rCFG_SURF_REPEAT.uNUMBER();
        bdma_config_class->cfg_src_surf_stride_ = reg_group_ptr->rCFG_SRC_SURF.uSTRIDE();
        bdma_config_class->cfg_dst_surf_stride_ = reg_group_ptr->rCFG_DST_SURF.uSTRIDE();
        bdma_config_class->cfg_op_en_ = reg_group_ptr->rCFG_OP.uEN();
        bdma_config_class->cfg_launch0_grp0_launch_ = reg_group_ptr->rCFG_LAUNCH0.uGRP0_LAUNCH();
        bdma_config_class->cfg_launch1_grp1_launch_ = reg_group_ptr->rCFG_LAUNCH1.uGRP1_LAUNCH();
        bdma_config_class->cfg_status_stall_count_en_ = reg_group_ptr->rCFG_STATUS.uSTALL_COUNT_EN();
        bdma_config_class->status_free_slot_ = reg_group_ptr->rSTATUS.uFREE_SLOT();
        bdma_config_class->status_idle_ = reg_group_ptr->rSTATUS.uIDLE();
        bdma_config_class->status_grp0_busy_ = reg_group_ptr->rSTATUS.uGRP0_BUSY();
        bdma_config_class->status_grp1_busy_ = reg_group_ptr->rSTATUS.uGRP1_BUSY();
        bdma_config_class->status_grp0_read_stall_count_ = reg_group_ptr->rSTATUS_GRP0_READ_STALL.uCOUNT();
        bdma_config_class->status_grp0_write_stall_count_ = reg_group_ptr->rSTATUS_GRP0_WRITE_STALL.uCOUNT();
        bdma_config_class->status_grp1_read_stall_count_ = reg_group_ptr->rSTATUS_GRP1_READ_STALL.uCOUNT();
        bdma_config_class->status_grp1_write_stall_count_ = reg_group_ptr->rSTATUS_GRP1_WRITE_STALL.uCOUNT();

}

void bdma_reg_model::BdmaClearGrp0Int() {
    bdma_register_group->rSTATUS.uGRP0_BUSY(0);
    bdma_register_group->rCFG_LAUNCH0.uGRP0_LAUNCH(0);
}

void bdma_reg_model::BdmaClearGrp1Int() {
    bdma_register_group->rSTATUS.uGRP1_BUSY(0);
    bdma_register_group->rCFG_LAUNCH1.uGRP1_LAUNCH(0);
}
