// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cmac.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_cmac.h"
#include "NV_NVDLA_cmac_cmac_a_gen.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "math.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define DATA_FORMAT_INT8        NVDLA_CMAC_A_D_MISC_CFG_0_IN_PRECISION_INT8
#define DATA_FORMAT_INT16       NVDLA_CMAC_A_D_MISC_CFG_0_IN_PRECISION_INT16
#define DATA_FORMAT_FP16        NVDLA_CMAC_A_D_MISC_CFG_0_IN_PRECISION_FP16

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

NV_NVDLA_cmac::NV_NVDLA_cmac( sc_module_name module_name ):
    NV_NVDLA_cmac_base(module_name),
    // Delay setup
    dma_delay_(SC_ZERO_TIME),
    csb_delay_(SC_ZERO_TIME),
    b_transport_delay_(SC_ZERO_TIME)
{
    // Memory allocation
    // weight_operand_shadow_  = new uint8_t [max( (WEIGHT_OPERAND_BIT_WIDTH_INT8+8-1)/8*2,(WEIGHT_OPERAND_BIT_WIDTH_INT16+8-1)/8 )*PARALLEL_CHANNEL_NUM*MAC_CELL_NUM];
    // weight_operand_         = new uint8_t [max( (WEIGHT_OPERAND_BIT_WIDTH_INT8+8-1)/8*2,(WEIGHT_OPERAND_BIT_WIDTH_INT16+8-1)/8 )*PARALLEL_CHANNEL_NUM*MAC_CELL_NUM];
    // data_operand_           = new uint8_t [max( (DATA_OPERAND_BIT_WIDTH_INT8+8-1)/8*2,(DATA_OPERAND_BIT_WIDTH_INT16+8-1)/8 )*ARALLEL_CHANNEL_NUM];
    // mac_result_             = new uint8_t [max( (OUTPUT_BIT_WIDTH_INT8+8-1)/8*2, (OUTPUT_BIT_WIDTH_INT16+8-1)/8)*MAC_CELL_NUM];
    data_operand_           = new sc_int<DATA_OPERAND_BIT_WIDTH_INT8>   [DATA_ELEMENT_NUM];     // 128*8bit
    weight_operand_shadow_  = new sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT8> [WEIGHT_ELEMENT_NUM];   // 8*128*8bit   - We have 8 MAC cells, 128B per MAC
    weight_operand_         = new sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT8> [WEIGHT_ELEMENT_NUM];
    mac_result_             = new sc_int<OUTPUT_BIT_WIDTH_INT8>         [MAC_CELL_NUM * RESULT_NUM_PER_MACELL]; // 8*8*22bit - 8 MAC cells, 8 output per MAC for INT8+WG mode(worst case)
    mac_cell_array          = new NvdlaMacCell[MAC_CELL_NUM];

    // Reset
    Reset();

    // SC_THREAD
    SC_THREAD(CmacConsumerThread)
}

NV_NVDLA_cmac::~NV_NVDLA_cmac() {
    if( weight_operand_shadow_ )  delete [] weight_operand_shadow_;
    if( weight_operand_ )  delete [] weight_operand_;
    if( data_operand_ )  delete [] data_operand_;
    if( mac_result_ )  delete [] mac_result_;
    if( mac_cell_array )  delete [] mac_cell_array;
}

void NV_NVDLA_cmac::Reset() {
    uint8_t mac_cell_iter;
    for (mac_cell_iter=0; mac_cell_iter < MAC_CELL_NUM; mac_cell_iter++) {
        mac_cell_array[mac_cell_iter].wt_mask_ptr_          = wt_mask[mac_cell_iter];    // two uint64_t
        mac_cell_array[mac_cell_iter].dat_mask_ptr_         = dat_mask;   // two uint64_t
        mac_cell_array[mac_cell_iter].data_operand_ptr_     = data_operand_; //Each MAC CELL uses same data(128Bytes)
        mac_cell_array[mac_cell_iter].weight_operand_ptr_   = &weight_operand_[mac_cell_iter * DATA_ELEMENT_NUM];
        mac_cell_array[mac_cell_iter].result_ptr_           = &mac_result_[mac_cell_iter * RESULT_NUM_PER_MACELL];
    }
    // Clear register and internal states
    CmacARegReset();
    is_there_ongoing_csb2cmac_a_response_ = false;
    enabled_mac_cell_shadow_ = 0;
}

void NV_NVDLA_cmac::CmacConsumerThread () {
    while (true) {
        while(CmacAGetOpeartionEnable(cmac_a_register_group_0) != NVDLA_CMAC_A_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_cmac_a_reg_group_0_operation_enable);
        }
        cslDebug((50, "%s NV_NVDLA_cmac::CmacConsumerThread, group 0 opeartion start\n", basename()));
        cmac_a_reg_model::CmacAUpdateWorkingStatus(0,1);
        cmac_a_reg_model::CmacAUpdateVariables(cmac_a_register_group_0);
        CmacHardwareLayerExecutionTrigger();
        cmac_a_reg_model::CmacAUpdateWorkingStatus(0,0);
        cmac_a_reg_model::CmacAClearOpeartionEnable(cmac_a_register_group_0);
        cslDebug((50, "%s NV_NVDLA_cmac::CmacConsumerThread, group 0 opeartion done\n", basename()));

        while(CmacAGetOpeartionEnable(cmac_a_register_group_1) != NVDLA_CMAC_A_D_OP_ENABLE_0_OP_EN_ENABLE) {
            wait(event_cmac_a_reg_group_1_operation_enable);
        }
        cslDebug((50, "%s NV_NVDLA_cmac::CmacConsumerThread, group 1 opeartion start\n", basename()));
        cmac_a_reg_model::CmacAUpdateWorkingStatus(1,1);
        cmac_a_reg_model::CmacAUpdateVariables(cmac_a_register_group_1);
        CmacHardwareLayerExecutionTrigger();
        cmac_a_reg_model::CmacAUpdateWorkingStatus(1,0);
        cmac_a_reg_model::CmacAClearOpeartionEnable(cmac_a_register_group_1);
        cslDebug((50, "%s NV_NVDLA_cmac::CmacConsumerThread, group 1 opeartion done\n", basename()));
    }
}

void NV_NVDLA_cmac::CmacHardwareLayerExecutionTrigger () {
    uint32_t    mac_cell_iter;
    for (mac_cell_iter=0; mac_cell_iter < MAC_CELL_NUM; mac_cell_iter++) {
        mac_cell_array[mac_cell_iter].precision_ = cmac_a_proc_precision_;
    }
    cmac_kickoff_.notify();
    is_working_ = true;
    wait(cmac_done_);
    is_working_ = false;
}

void NV_NVDLA_cmac::sc2mac_wt_b_transport(int ID, nvdla_sc2mac_weight_if_t* payload, sc_time& delay) {
    uint64_t    payload_sel;
    uint8_t     mac_cell_id;
    sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT8>   *payload_data_ptr;
    uint32_t    iter;
    while (is_working_ == false) {
        // wait(cmac_kickoff_);
        // CSC to CMAC is valid only protocol, before receiving data, CMAC shall be in working status
        FAIL(("%s NV_NVDLA_cmac::sc2mac_wt_b_transport, CMAC is not working yet.", basename()));
    }
    payload_data_ptr = (payload->data);
    payload_sel = payload->sel;
    mac_cell_id = 0;
    enabled_mac_cell_shadow_ |= payload_sel;
    assert(enabled_mac_cell_shadow_ < (1 << (MAC_CELL_NUM + 1)));
    while ( payload_sel != 0x1 ) {
        mac_cell_id++;
        payload_sel = payload_sel >> 1;
    }
    wt_mask_shadow[mac_cell_id][0] = payload->mask[0];
    wt_mask_shadow[mac_cell_id][1] = payload->mask[1];
    for (iter = 0; iter < DATA_ELEMENT_NUM; iter ++) {
        weight_operand_shadow_[mac_cell_id * DATA_ELEMENT_NUM + iter] = payload_data_ptr[iter];
    }

    cslDebug((70, "%s: weight before MAC on %d MAC cell:\n", __FUNCTION__, mac_cell_id));
    for (iter = 0; iter < DATA_ELEMENT_NUM; iter ++) {
        uint8_t val = weight_operand_shadow_[mac_cell_id * DATA_ELEMENT_NUM + iter].to_int();
        cslDebug((70, "%02x", val));
    }
    cslDebug((70, "\n"));

}

void NV_NVDLA_cmac::sc2mac_dat_b_transport(int ID, nvdla_sc2mac_data_if_t* payload, sc_time& delay) {
    sc_int<8> *csc2cmac_payload_data_ptr;
    sc_int<OUTPUT_BIT_WIDTH_INT8>       *cmac2cacc_payload_data_ptr;
    bool        mac_enable;
    bool        wino_op;
    uint16_t    mac_cell_iter;
    uint16_t    element_iter;
    wino_op     = cmac_a_conv_mode_ == NVDLA_CMAC_A_D_MISC_CFG_0_CONV_MODE_WINOGRAD;
    while (is_working_ == false) {
        // wait(cmac_kickoff_);
        // CSC to CMAC is valid only protocol, before receiving data, CMAC shall be in working status
        FAIL(("%s NV_NVDLA_cmac::sc2mac_dat_b_transport, CMAC is not working yet.", basename()));
    }
    if ( 1 == payload->pd.nvdla_stripe_info.stripe_st ) {
        // A new stripe operation, promote shadow weights into active
        UpdateWeightFromShadowToActive();
        enabled_mac_cell_active_ = enabled_mac_cell_shadow_;
        enabled_mac_cell_shadow_ = 0;
    }
    // Copy data from payload to operand ptr
    csc2cmac_payload_data_ptr = payload->data;
    for (element_iter = 0; element_iter < DATA_ELEMENT_NUM; element_iter ++ ) {
        data_operand_[element_iter] = csc2cmac_payload_data_ptr[element_iter].range(7,0);
    }
    dat_mask[0] = payload->mask[0];
    dat_mask[1] = payload->mask[1];

    cslDebug((70, "%s: data before MAC:\n", __FUNCTION__));
    for (int idx = DATA_ELEMENT_NUM - 1; idx >= 0; idx--) {
        uint8_t val = data_operand_[idx].to_int();
        cslDebug((70, "%02x", val));
    }
    cslDebug((70, "\n"));

    // Calculation
	for (mac_cell_iter = 0; mac_cell_iter < MAC_CELL_NUM; mac_cell_iter++) {
        cslDebug((70, "%s Calling mac do_calc. mac_cell_iter=%d\n", basename(), mac_cell_iter));
        mac_enable = ((enabled_mac_cell_active_ & (0x1 << mac_cell_iter)) != 0);
        mac_cell_array[mac_cell_iter].do_calc(mac_enable, wino_op);
    }
    // Send data to accu
    mac2accu_payload.mask       = enabled_mac_cell_active_;
	mac2accu_payload.mode		= wino_op ? 0xff : 0x00;
    cmac2cacc_payload_data_ptr  = mac2accu_payload.data;
    for (element_iter = 0; element_iter < MAC_CELL_NUM * RESULT_NUM_PER_MACELL; element_iter ++ ) {
        cmac2cacc_payload_data_ptr[element_iter] = mac_result_[element_iter];
    }
    mac2accu_payload.pd.nvdla_stripe_info = payload->pd.nvdla_stripe_info;

    cslDebug((50, "%s NV_NVDLA_cmac::mac2accu_dat_b_transport, mac2accu_payload is below\n", basename()));
    cslDebug((50, "    layer_end is 0x%x\n" ,   (uint32_t)mac2accu_payload.pd.nvdla_stripe_info.layer_end));
    cslDebug((50, "    channel_end is 0x%x\n",  (uint32_t)mac2accu_payload.pd.nvdla_stripe_info.channel_end));
    cslDebug((50, "    stripe_st is 0x%x\n",    (uint32_t)mac2accu_payload.pd.nvdla_stripe_info.stripe_st));
    cslDebug((50, "    stripe_end is 0x%x\n",   (uint32_t)mac2accu_payload.pd.nvdla_stripe_info.stripe_end));
    cslDebug((50, "    Mask is 0x%x\n",         mac2accu_payload.mask));
    cslDebug((50, "    Mode is 0x%x\n",         mac2accu_payload.mode));
	for (uint32_t mac_cell_idx_db = 0; mac_cell_idx_db < MAC_CELL_NUM; mac_cell_idx_db++) {
		for (uint32_t element_idx_db = 0; element_idx_db < RESULT_NUM_PER_MACELL; element_idx_db++) {
            cslDebug((70, "Data[0x%x,0x%x]: 0x%08lx\n", mac_cell_idx_db, element_idx_db, (uint64_t)mac2accu_payload.data[mac_cell_idx_db * RESULT_NUM_PER_MACELL + element_idx_db].to_int64()));
        }
    }
    mac2accu_b_transport(&mac2accu_payload, b_transport_delay_);

    // Hardware layer done 
    if ( (1 == payload->pd.nvdla_stripe_info.layer_end) && (1 == payload->pd.nvdla_stripe_info.stripe_end) ) {
        cmac_done_.notify();
        cslDebug((50, "%s NV_NVDLA_cmac::sc2mac_dat_b_transport, sent cmac_done notification\n", basename()));
    }
}

void NV_NVDLA_cmac::UpdateWeightFromShadowToActive () {
    uint32_t iter;
    uint32_t mac_cell_iter;
    for (iter = 0; iter < WEIGHT_ELEMENT_NUM; iter ++) {
        weight_operand_[iter] = weight_operand_shadow_[iter];
    }
    for (mac_cell_iter=0; mac_cell_iter < MAC_CELL_NUM; mac_cell_iter++) {
        wt_mask[mac_cell_iter][0] = wt_mask_shadow[mac_cell_iter][0];
        wt_mask[mac_cell_iter][1] = wt_mask_shadow[mac_cell_iter][1];
    }
}

NV_NVDLA_cmac * NV_NVDLA_cmacCon(sc_module_name name)
{
    return new NV_NVDLA_cmac(name);
}
