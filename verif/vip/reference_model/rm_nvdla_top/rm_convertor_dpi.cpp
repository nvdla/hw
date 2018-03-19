
#include <iostream>
#include <string.h>
#include <svdpi.h>
#include "scsim_common.h"
#include "xx2csb_struct.h"
#include "NV_MSDEC_csb2xx_16m_secure_be_lvl_iface.h"
#include "NV_MSDEC_xx2csb_erpt_iface.h"

#include "nvdla_dma_rd_req_iface.h"
#include "nvdla_dma_rd_rsp_iface.h"
#include "nvdla_dma_wr_req_iface.h"
#include "nvdla_sc2mac_data_monitor.h"
#include "nvdla_sc2mac_weight_monitor.h"
#include "nvdla_mac2accu_data_monitor.h"
#include "nvdla_accu2pp_if_iface.h"
#include "nvdla_sdp2pdp_iface.h"
#include "nvdla_monitor_dma_transaction.h"

#ifndef CSC2MAC_DATA_CONTAINER_NUM
#define CSC2MAC_DATA_CONTAINER_NUM NVDLA_MAC_ATOMIC_C_SIZE
#endif

#ifndef MAC2ACCU_DATA_CONTAINER_NUM
#define MAC2ACCU_DATA_CONTAINER_NUM (NVDLA_MAC_ATOMIC_K_SIZE/2)
#endif

#ifndef ACCU2SDP_DATA_CONTAINER_NUM
#define ACCU2SDP_DATA_CONTAINER_NUM NVDLA_SDP_BS_THROUGHPUT
#endif

#ifndef SDP2PDP_DATA_CONTAINER_NUM
#define SDP2PDP_DATA_CONTAINER_NUM 1   // Large: 8, Small: 1
#endif

#ifndef TAG_CMD
#define TAG_CMD     0
#endif

#ifndef TAG_DATA
#define TAG_DATA    1
#endif

#ifndef DMA_WRITE_CMD_PAD_BYTES
#define DMA_WRITE_CMD_PAD_BYTES 53
#endif

#define get_array_len(array) (sizeof(array) / sizeof(array[0]))

using namespace std;

extern "C" void rm_dpi_test( svLogic a ) {
    int a_int = a;
    cout << "C++ DPI test, a is " << a_int << endl;
    cout << "C++ DPI test, scope is " << svGetNameFromScope(svGetScope()) << endl;
    // return ((unsigned char*) csb_req);
    // return;
}

// typedef struct csb2xx_16m_secure_be_lvl_s {
//     uint32_t addr ;
//     uint32_t wdat ;
//     uint8_t write ;
//     uint8_t nposted ;
//     uint8_t srcpriv ;
//     uint8_t wrbe ;
//     uint8_t secure ;
//     uint8_t level ;
// } csb2xx_16m_secure_be_lvl_t;

extern "C" void parse_read_dma_transaction(
    const       svOpenArrayHandle tlm_gp_data_ptr,
    const       svOpenArrayHandle parsed_data_ptr
) {
    nvdla_monitor_dma_rd_transaction_t *dma_read_sc;
    uint8_t *dma_read_sv;
    uint8_t *src_uint8_ptr;
    uint32_t copy_idx;
    uint32_t copy_size;
    uint32_t dma_read_sv_byte_idx = 0;
    dma_read_sc = reinterpret_cast <nvdla_monitor_dma_rd_transaction_t *> (svGetArrayPtr(tlm_gp_data_ptr));
    dma_read_sv = reinterpret_cast <uint8_t *> (svGetArrayPtr(parsed_data_ptr));
    //cout << svGetNameFromScope(svGetScope()) << ": RM_CSB_CONVERTOR_DPI::parse_read_dma_transaction, enter function ." << endl;
    // README, we have to do reverse byte copy for values which have multiple bytes due to SystemVerilog stream operation behavior.

    src_uint8_ptr = reinterpret_cast <uint8_t *> (&dma_read_sc->dma_id);
    copy_size     = sizeof(dma_read_sc->dma_id);
    for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
        memcpy(&dma_read_sv[dma_read_sv_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
    }
    dma_read_sv_byte_idx += copy_size;
    //cout << svGetNameFromScope(svGetScope()) << ": RM_CSB_CONVERTOR_DPI::parse_read_dma_transaction, copy 0x" << hex << dma_read_sv_byte_idx << " bytes." << endl;
    // memcpy(&dma_read_sv[dma_read_sv_byte_idx], &dma_read_sc->dma_id, sizeof(dma_read_sc->dma_id));
    // dma_read_sv_byte_idx += sizeof(dma_read_sc->dma_id);
    // cout << svGetNameFromScope(svGetScope()) << ": RM_CSB_CONVERTOR_DPI::parse_read_dma_transaction, copy 0x" << hex << dma_read_sv_byte_idx << " bytes." << endl;

    src_uint8_ptr = reinterpret_cast <uint8_t *> (&dma_read_sc->status);
    copy_size     = sizeof(dma_read_sc->status);
    for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
        memcpy(&dma_read_sv[dma_read_sv_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
    }
    dma_read_sv_byte_idx += copy_size;
    // memcpy(&dma_read_sv[dma_read_sv_byte_idx], &dma_read_sc->status, sizeof(dma_read_sc->status));
    // dma_read_sv_byte_idx += sizeof(dma_read_sc->status);
    // cout << svGetNameFromScope(svGetScope()) << ": RM_CSB_CONVERTOR_DPI::parse_read_dma_transaction, copy 0x" << hex << dma_read_sv_byte_idx << " bytes." << endl;
// typedef struct dma_read_cmd_s {
//     uint64_t addr ; 
//     uint16_t size ; 
//     uint8_t stream_id_ptr ; 
// } dma_read_cmd_t;
// 
// #endif
// 
// union nvdla_dma_rd_req_u {
//     dma_read_cmd_t dma_read_cmd;
// };
// typedef struct nvdla_dma_rd_req_s {
//     union nvdla_dma_rd_req_u pd ; 
// } nvdla_dma_rd_req_t;
    src_uint8_ptr = reinterpret_cast <uint8_t *> (&dma_read_sc->req.pd.dma_read_cmd.addr);
    copy_size     = sizeof(dma_read_sc->req.pd.dma_read_cmd.addr);
    // cout << svGetNameFromScope(svGetScope()) << ": RM_CSB_CONVERTOR_DPI::parse_read_dma_transaction, copy_size is 0x" << hex << copy_size << endl;
    for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
        memcpy(&dma_read_sv[dma_read_sv_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
    }
    dma_read_sv_byte_idx += copy_size;
    // cout << svGetNameFromScope(svGetScope()) << ": RM_CSB_CONVERTOR_DPI::parse_read_dma_transaction, copy 0x" << hex << dma_read_sv_byte_idx << " bytes." << endl;
    // memcpy(&dma_read_sv[dma_read_sv_byte_idx], &dma_read_sc->req.pd.dma_read_cmd.size, sizeof(dma_read_sc->req.pd.dma_read_cmd.size));
    // dma_read_sv_byte_idx += sizeof(dma_read_sc->req.pd.dma_read_cmd.size);

    src_uint8_ptr = reinterpret_cast <uint8_t *> (&dma_read_sc->req.pd.dma_read_cmd.size);
    copy_size     = sizeof(dma_read_sc->req.pd.dma_read_cmd.size);
    for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
        memcpy(&dma_read_sv[dma_read_sv_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
    }
    dma_read_sv_byte_idx += copy_size;
    //cout << svGetNameFromScope(svGetScope()) << ": RM_CSB_CONVERTOR_DPI::parse_read_dma_transaction, copy 0x" << hex << dma_read_sv_byte_idx << " bytes." << endl;
    // memcpy(&dma_read_sv[dma_read_sv_byte_idx], &dma_read_sc->req.pd.dma_read_cmd.stream_id_ptr, sizeof(dma_read_sc->req.pd.dma_read_cmd.stream_id_ptr));
    // dma_read_sv_byte_idx += sizeof(dma_read_sc->req.pd.dma_read_cmd.stream_id_ptr);
    // src_uint8_ptr = reinterpret_cast <uint8_t *> (&dma_read_sc->req.pd.dma_read_cmd.stream_id_ptr);
    // copy_size     = sizeof(dma_read_sc->req.pd.dma_read_cmd.stream_id_ptr);
    // for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
    //     memcpy(&dma_read_sv[dma_read_sv_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
    // }
    // dma_read_sv_byte_idx += copy_size;
    // cout << svGetNameFromScope(svGetScope()) << ": RM_CSB_CONVERTOR_DPI::parse_read_dma_transaction, copy 0x" << hex << dma_read_sv_byte_idx << " bytes." << endl;
// typedef struct dma_read_data_s {
//     uint64_t data [8] ; 
//     uint8_t mask ; 
// } dma_read_data_t;
// union nvdla_dma_rd_rsp_u {
//     dma_read_data_t dma_read_data;
// };
// typedef struct nvdla_dma_rd_rsp_s {
//     union nvdla_dma_rd_rsp_u pd ; 
// } nvdla_dma_rd_rsp_t;
    // memcpy(&dma_read_sv[dma_read_sv_byte_idx], dma_read_sc->rsp.pd.dma_read_data.data, sizeof(dma_read_sc->rsp.pd.dma_read_data.data));
    // dma_read_sv_byte_idx += sizeof(dma_read_sc->rsp.pd.dma_read_data.data);
    src_uint8_ptr = reinterpret_cast <uint8_t *> (dma_read_sc->rsp.pd.dma_read_data.data);
    copy_size     = sizeof(dma_read_sc->rsp.pd.dma_read_data.data);
    for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
        memcpy(&dma_read_sv[dma_read_sv_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
    }
    dma_read_sv_byte_idx += copy_size;
    //cout << svGetNameFromScope(svGetScope()) << ": RM_CSB_CONVERTOR_DPI::parse_read_dma_transaction, copy 0x" << hex << dma_read_sv_byte_idx << " bytes." << endl;
    // memcpy(&dma_read_sv[dma_read_sv_byte_idx], &dma_read_sc->rsp.pd.dma_read_data.mask, sizeof(dma_read_sc->rsp.pd.dma_read_data.mask));
    // dma_read_sv_byte_idx += sizeof(dma_read_sc->rsp.pd.dma_read_data.mask);
    src_uint8_ptr = reinterpret_cast <uint8_t *> (&dma_read_sc->rsp.pd.dma_read_data.mask);
    copy_size     = sizeof(dma_read_sc->rsp.pd.dma_read_data.mask);
    for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
        memcpy(&dma_read_sv[dma_read_sv_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
    }
    dma_read_sv_byte_idx += copy_size;
    //cout << svGetNameFromScope(svGetScope()) << ": RM_CSB_CONVERTOR_DPI::parse_read_dma_transaction, copy 0x" << hex << dma_read_sv_byte_idx << " bytes." << endl;
}


extern "C" void parse_write_dma_transaction(
    const       svOpenArrayHandle tlm_gp_data_ptr,
    const       svOpenArrayHandle parsed_data_ptr
) {
    nvdla_monitor_dma_wr_transaction_t *dma_write_sc;
    uint8_t *dma_write_sv;
    uint32_t dma_write_sv_byte_idx = 0;
    uint8_t  tag;
    uint8_t *src_uint8_ptr;
    uint32_t copy_idx;
    uint32_t copy_size;
    dma_write_sc = reinterpret_cast <nvdla_monitor_dma_wr_transaction_t *> (svGetArrayPtr(tlm_gp_data_ptr));
    dma_write_sv = reinterpret_cast <uint8_t *> (svGetArrayPtr(parsed_data_ptr));
    tag = dma_write_sc->req.tag;

    memcpy(&dma_write_sv[dma_write_sv_byte_idx], &dma_write_sc->dma_id, sizeof(dma_write_sc->dma_id));
    dma_write_sv_byte_idx += sizeof(dma_write_sc->dma_id);
    //cout << svGetNameFromScope(svGetScope()) << ": RM_CSB_CONVERTOR_DPI::parse_write_dma_transaction, copy 0x" << hex << dma_write_sv_byte_idx << " bytes." << endl;
    memcpy(&dma_write_sv[dma_write_sv_byte_idx], &dma_write_sc->status, sizeof(dma_write_sc->status));
    dma_write_sv_byte_idx += sizeof(dma_write_sc->status);
    //cout << svGetNameFromScope(svGetScope()) << ": RM_CSB_CONVERTOR_DPI::parse_write_dma_transaction, copy 0x" << hex << dma_write_sv_byte_idx << " bytes." << endl;

    memcpy(&dma_write_sv[dma_write_sv_byte_idx], &dma_write_sc->req.tag, sizeof(dma_write_sc->req.tag));
    dma_write_sv_byte_idx += sizeof(dma_write_sc->req.tag);

    // memcpy(&dma_write_sv[dma_write_sv_byte_idx], &dma_write_sc->req.pd.dma_write_data.data, sizeof(dma_write_sc->req.pd.dma_write_data.data));
    // dma_write_sv_byte_idx += sizeof(dma_write_sc->req.pd.dma_write_data.data);

    if (TAG_DATA == tag) {
        copy_size     = sizeof(dma_write_sc->req.pd.dma_write_data.data);
        src_uint8_ptr = reinterpret_cast <uint8_t *> (dma_write_sc->req.pd.dma_write_data.data);
        for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
            memcpy(&dma_write_sv[dma_write_sv_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
        }
        dma_write_sv_byte_idx += copy_size;
    } else {
        // Transfer pad
        memset(&dma_write_sv[dma_write_sv_byte_idx], 0, DMA_WRITE_CMD_PAD_BYTES);
        dma_write_sv_byte_idx += DMA_WRITE_CMD_PAD_BYTES;

        // Transfer addr
        copy_size     = sizeof(dma_write_sc->req.pd.dma_write_cmd.addr);
        src_uint8_ptr = reinterpret_cast <uint8_t *> (&dma_write_sc->req.pd.dma_write_cmd.addr);
        for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
            memcpy(&dma_write_sv[dma_write_sv_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
        }
        dma_write_sv_byte_idx += copy_size;

        // Transfer size
        copy_size     = sizeof(dma_write_sc->req.pd.dma_write_cmd.size);
        src_uint8_ptr = reinterpret_cast <uint8_t *> (&dma_write_sc->req.pd.dma_write_cmd.size);
        for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
            memcpy(&dma_write_sv[dma_write_sv_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
        }
        dma_write_sv_byte_idx += copy_size;

        // // Transfer stream_id_ptr
        // memcpy(&dma_write_sv[dma_write_sv_byte_idx], &dma_write_sc->req.pd.dma_write_cmd.stream_id_ptr, sizeof(dma_write_sc->req.pd.dma_write_cmd.stream_id_ptr));
        // dma_write_sv_byte_idx += sizeof(dma_write_sc->req.pd.dma_write_cmd.stream_id_ptr);

        // Transfer require_ack
        memcpy(&dma_write_sv[dma_write_sv_byte_idx], &dma_write_sc->req.pd.dma_write_cmd.require_ack, sizeof(dma_write_sc->req.pd.dma_write_cmd.require_ack));
        dma_write_sv_byte_idx += sizeof(dma_write_sc->req.pd.dma_write_cmd.require_ack);
    }

}

// union nvdla_sc2mac_data_if_u {
//     nvdla_stripe_info_t nvdla_stripe_info;
// };
// typedef struct nvdla_sc2mac_data_if_s {
//     uint64_t mask [2] ; 
//     sc_int<10> data[128];
//     union nvdla_sc2mac_data_if_u pd ; 
// } nvdla_sc2mac_data_if_t;
//
// typedef struct nvdla_stripe_info_s {
//     uint8_t redundant;
//     uint8_t layer_end;
//     uint8_t channel_end;
//     uint8_t stripe_end;
//     uint8_t stripe_st;
//     uint8_t batch_index;
// } nvdla_stripe_info_t;

extern "C" void parse_sc2mac_data_transaction(
    const       svOpenArrayHandle tlm_gp_data_ptr,
    const       svOpenArrayHandle parsed_data_ptr
) {
    uint8_t                 *byte_ptr;
    nvdla_sc2mac_data_monitor_t  *sc_ptr;
    uint8_t                 *sv_ptr;
    uint32_t                sv_ptr_byte_idx = 0;
    uint32_t                idx;
    uint8_t                 data_value;
    uint8_t                 *src_uint8_ptr;
    uint32_t                copy_idx;
    uint32_t                copy_size;
    uint32_t                mask;
    byte_ptr = reinterpret_cast <uint8_t *> (svGetArrayPtr(tlm_gp_data_ptr));
    sc_ptr = reinterpret_cast <nvdla_sc2mac_data_monitor_t *> (&byte_ptr[1]);
    sv_ptr = reinterpret_cast <uint8_t *> (svGetArrayPtr(parsed_data_ptr));

    // Transfer mask
    mask = (sc_ptr->mask[0] << CSC2MAC_DATA_CONTAINER_NUM/2) | sc_ptr->mask[1];
//  printf("[DEBUG] parse_sc2mac_data_transaction: mask = %#x, mask[0] = %#x: mask[1]=%#x\n", mask, sc_ptr->mask[0], sc_ptr->mask[1]);
    src_uint8_ptr = reinterpret_cast <uint8_t *> (&mask);
    copy_size = CSC2MAC_DATA_CONTAINER_NUM/8;
    for (copy_idx=0; copy_idx<copy_size; copy_idx++) {
        memcpy(&sv_ptr[sv_ptr_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
    }
    sv_ptr_byte_idx += copy_size;

    // Data payload
    for (idx = 0; idx < CSC2MAC_DATA_CONTAINER_NUM; idx ++) {
        data_value = sc_ptr->data[idx];
        copy_size     = sizeof(data_value);
        src_uint8_ptr = reinterpret_cast <uint8_t *> (&data_value);
        for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
            memcpy(&sv_ptr[sv_ptr_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
        }
        sv_ptr_byte_idx += copy_size;
    }

    // Transfer layer_end
//  printf("[DEBUG] parse_sc2mac_data_transaction: stripe_info.layer_end: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
    memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->nvdla_stripe_info.layer_end, sizeof(sc_ptr->nvdla_stripe_info.layer_end));
    sv_ptr_byte_idx += sizeof(sc_ptr->nvdla_stripe_info.layer_end);
    // Transfer channel_end
//  printf("[DEBUG] parse_sc2mac_data_transaction: stripe_info.channel_end: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
    memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->nvdla_stripe_info.channel_end, sizeof(sc_ptr->nvdla_stripe_info.channel_end));
    sv_ptr_byte_idx += sizeof(sc_ptr->nvdla_stripe_info.channel_end);
    // Transfer stripe_end
//  printf("[DEBUG] parse_sc2mac_data_transaction: stripe_info.stripe_end: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
    memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->nvdla_stripe_info.stripe_end, sizeof(sc_ptr->nvdla_stripe_info.stripe_end));
    sv_ptr_byte_idx += sizeof(sc_ptr->nvdla_stripe_info.stripe_end);
    // Transfer stripe_st
//  printf("[DEBUG] parse_sc2mac_data_transaction: stripe_info.stripe_st: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
    memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->nvdla_stripe_info.stripe_st, sizeof(sc_ptr->nvdla_stripe_info.stripe_st));
    sv_ptr_byte_idx += sizeof(sc_ptr->nvdla_stripe_info.stripe_st);
    // Transfer batch_index
//  printf("[DEBUG] parse_sc2mac_data_transaction: stripe_info.batch_index: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
    memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->nvdla_stripe_info.batch_index, sizeof(sc_ptr->nvdla_stripe_info.batch_index));
    sv_ptr_byte_idx += sizeof(sc_ptr->nvdla_stripe_info.batch_index);
//  printf("[DEBUG] parse_sc2mac_data_transaction: end: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
}

extern "C" void parse_sc2mac_weight_transaction(
    const       svOpenArrayHandle tlm_gp_data_ptr,
    const       svOpenArrayHandle parsed_data_ptr
) {
    uint8_t                     *byte_ptr;
    nvdla_sc2mac_weight_monitor_t    *sc_ptr;
    uint8_t                     *sv_ptr;
    uint32_t                    sv_ptr_byte_idx = 0;
    uint32_t                    idx;
    uint8_t                     data_value;
    uint8_t                     *src_uint8_ptr;
    uint32_t                    copy_idx;
    uint32_t                    copy_size;
    uint32_t                    mask;

    byte_ptr = reinterpret_cast <uint8_t *> (svGetArrayPtr(tlm_gp_data_ptr));
    sc_ptr = reinterpret_cast <nvdla_sc2mac_weight_monitor_t *> (&byte_ptr[1]);
    sv_ptr = reinterpret_cast <uint8_t *> (svGetArrayPtr(parsed_data_ptr));

    // Transfer mask
    mask = (sc_ptr->mask[0] << CSC2MAC_DATA_CONTAINER_NUM/2) | sc_ptr->mask[1];
//  printf("[DEBUG] parse_sc2mac_weight_transaction: mask = %#x, mask[0] = %#x: mask[1]=%#x\n", mask, sc_ptr->mask[0], sc_ptr->mask[1]);
    src_uint8_ptr = reinterpret_cast <uint8_t *> (&mask);
    copy_size = CSC2MAC_DATA_CONTAINER_NUM/8;
    for (copy_idx=0; copy_idx<copy_size; copy_idx++) {
        memcpy(&sv_ptr[sv_ptr_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
    }
    sv_ptr_byte_idx += copy_size;

    // Weight payload
    for (idx = 0; idx < CSC2MAC_DATA_CONTAINER_NUM; idx ++) {
        data_value = int8_t (sc_ptr->data[idx]);
//      printf("[DEBUG] parse_sc2mac_weight_transaction: data[%0d] = 0x%x: CSC2MAC_DATA_CONTAINER_NUM=%0d, sc_ptr->data.len=%0d, sv_ptr_byte_idx=%0d\n",
//          idx, data_value, CSC2MAC_DATA_CONTAINER_NUM, get_array_len(sc_ptr->data), sv_ptr_byte_idx);
        memcpy(&sv_ptr[sv_ptr_byte_idx], &data_value, sizeof(data_value));
        sv_ptr_byte_idx += sizeof(data_value);
    }

    // Transfer wt_sel
//  copy_size     = sizeof(sc_ptr->sel);
    copy_size     = 1;
    src_uint8_ptr = reinterpret_cast <uint8_t *> (&sc_ptr->sel);
    for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
//      printf("[DEBUG] parse_sc2mac_weight_transaction: wsel[%0d] = %#x: sv_ptr_byte_idx=%0d\n", copy_idx, src_uint8_ptr[copy_size-1-copy_idx], sv_ptr_byte_idx);
        memcpy(&sv_ptr[sv_ptr_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
    }
    sv_ptr_byte_idx += copy_size;
}

// union nvdla_mac2accu_data_if_u {
//     nvdla_stripe_info_t nvdla_stripe_info;
// };
// typedef struct nvdla_mac2accu_data_if_s {
//     uint16_t mask ; 
//     sc_int<22> data [8*8]; 
//     union nvdla_mac2accu_data_if_u pd ; 
// } nvdla_mac2accu_data_monitor_t;
//
// typedef struct nvdla_stripe_info_s {
//     uint8_t redundant;
//     uint8_t layer_end;
//     uint8_t channel_end;
//     uint8_t stripe_end;
//     uint8_t stripe_st;
//     uint8_t batch_index;
// } nvdla_stripe_info_t;

extern "C" void parse_mac2accu_transaction(
    const       svOpenArrayHandle tlm_gp_data_ptr,
    const       svOpenArrayHandle parsed_data_ptr
) {
    uint8_t                     *byte_ptr;
    nvdla_mac2accu_data_monitor_t    *sc_ptr;
    uint8_t                     *sv_ptr;
    uint32_t                    sv_ptr_byte_idx = 0;
    uint32_t                    idx;
    int32_t                     data_value;
    uint8_t                     *src_uint8_ptr;
    uint32_t                    copy_idx;
    uint32_t                    copy_size;
    byte_ptr = reinterpret_cast <uint8_t *> (svGetArrayPtr(tlm_gp_data_ptr));
    sc_ptr = reinterpret_cast <nvdla_mac2accu_data_monitor_t *> (&byte_ptr[1]);
    sv_ptr = reinterpret_cast <uint8_t *> (svGetArrayPtr(parsed_data_ptr));
/*
    printf("[DEBUG] parse_mac2accu_transaction: mask=%#x, mode=%#x", sc_ptr->mask, sc_ptr->mode);
    for (idx = 0; idx < MAC2ACCU_DATA_CONTAINER_NUM; idx++) {
        printf(", data[%0d] = %#8x", idx, sc_ptr->data[idx*4]);
    }
    printf(", layer_end=%#x", sc_ptr->nvdla_stripe_info.layer_end);
    printf(", channel_end=%#x", sc_ptr->nvdla_stripe_info.channel_end);
    printf(", stripe_end=%#x", sc_ptr->nvdla_stripe_info.stripe_end);
    printf(", stripe_st=%#x", sc_ptr->nvdla_stripe_info.stripe_st);
    printf(", batch_index=%#x", sc_ptr->nvdla_stripe_info.batch_index);
    printf("\n"); 
*/
    // Transfer mask
    src_uint8_ptr = reinterpret_cast <uint8_t *> (&sc_ptr->mask);
    copy_size     = sizeof(sc_ptr->mask);
    for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
//      printf("[DEBUG] parse_mac2accu_transaction: mask: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
        memcpy(&sv_ptr[sv_ptr_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
    }
    // cout << "parse_mac2accu_transaction, sc mask is 0x" << hex << sc_ptr->mask << endl;
    // cout << "parse_mac2accu_transaction, sv mask is 0x" << hex << sv_ptr->mask << endl;
    sv_ptr_byte_idx += copy_size;
    // Transfer mode
    src_uint8_ptr = reinterpret_cast <uint8_t *> (&sc_ptr->mode);
    copy_size     = sizeof(sc_ptr->mode);
    for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
//      printf("[DEBUG] parse_mac2accu_transaction: mode: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
        memcpy(&sv_ptr[sv_ptr_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
    }
    // cout << "parse_mac2accu_transaction, sc mask is 0x" << hex << sc_ptr->mask << endl;
    // cout << "parse_mac2accu_transaction, sv mask is 0x" << hex << sv_ptr->mask << endl;
    sv_ptr_byte_idx += copy_size;
    // memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->mask, sizeof(sc_ptr->mask));
    // sv_ptr_byte_idx += sizeof(sc_ptr->mask);
    // Transfer data

//  printf("[DEBUG]: MAC2ACCU_DATA_CONTAINER_NUM=%0d, sc_ptr->data.len=%0d, sv_ptr_byte_idx=%0d\n",
//      MAC2ACCU_DATA_CONTAINER_NUM, get_array_len(sc_ptr->data), sv_ptr_byte_idx);
//  for (idx = 0; idx < get_array_len(sc_ptr->data); idx ++) {
    for (idx = 0; idx < MAC2ACCU_DATA_CONTAINER_NUM; idx ++) {
        data_value = sc_ptr->data[idx*4]; // FIXME: CMOD use 32*4=128 bits to store mac result for both nv_large and nv_small
        // memcpy(&sv_ptr[sv_ptr_byte_idx], &data_value, sizeof(data_value));
        copy_size     = sizeof(data_value);
        src_uint8_ptr = reinterpret_cast <uint8_t *> (&data_value);
        for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
//          printf("[DEBUG] parse_mac2accu_transaction: data: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
            memcpy(&sv_ptr[sv_ptr_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
        }
        sv_ptr_byte_idx += copy_size;
    }
    // Transfer layer_end
//  printf("[DEBUG] parse_mac2accu_transaction: layer_end: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
    memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->nvdla_stripe_info.layer_end, sizeof(sc_ptr->nvdla_stripe_info.layer_end));
    // cout << "parse_mac2accu_transaction, layer_end is 0x" << hex << sc_ptr->nvdla_stripe_info.layer_end << endl;
    sv_ptr_byte_idx += sizeof(sc_ptr->nvdla_stripe_info.layer_end);
    // Transfer channel_end
//  printf("[DEBUG] parse_mac2accu_transaction: channel_end: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
    memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->nvdla_stripe_info.channel_end, sizeof(sc_ptr->nvdla_stripe_info.channel_end));
    sv_ptr_byte_idx += sizeof(sc_ptr->nvdla_stripe_info.channel_end);
    // Transfer stripe_end
//  printf("[DEBUG] parse_mac2accu_transaction: stripe_end: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
    memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->nvdla_stripe_info.stripe_end, sizeof(sc_ptr->nvdla_stripe_info.stripe_end));
    // cout << "parse_mac2accu_transaction, stripe_end is 0x" << hex << sc_ptr->nvdla_stripe_info.stripe_end << endl;
    sv_ptr_byte_idx += sizeof(sc_ptr->nvdla_stripe_info.stripe_end);
    // Transfer stripe_st
//  printf("[DEBUG] parse_mac2accu_transaction: stripe_st: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
    memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->nvdla_stripe_info.stripe_st, sizeof(sc_ptr->nvdla_stripe_info.stripe_st));
    // cout << "parse_mac2accu_transaction, stripe_st is 0x" << hex << sc_ptr->nvdla_stripe_info.stripe_st << endl;
    sv_ptr_byte_idx += sizeof(sc_ptr->nvdla_stripe_info.stripe_st);
    // Transfer batch_index
//  printf("[DEBUG] parse_mac2accu_transaction: batch_index: sv_ptr_byte_idx=%0d\n", sv_ptr_byte_idx);
    memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->nvdla_stripe_info.batch_index, sizeof(sc_ptr->nvdla_stripe_info.batch_index));
    sv_ptr_byte_idx += sizeof(sc_ptr->nvdla_stripe_info.batch_index);
}

// typedef struct nvdla_cc2pp_pkg_s {
//     sc_int<32>  data [16]; 
//     uint8_t     batch_end ; 
//     uint8_t     layer_end ; 
// } nvdla_cc2pp_pkg_t;
// 
// // union nvdla_accu2pp_if_u {
// struct nvdla_accu2pp_if_u {
//     nvdla_cc2pp_pkg_t nvdla_cc2pp_pkg;
// };
// typedef struct nvdla_accu2pp_if_s {
//     // union nvdla_accu2pp_if_u pd ; 
//     nvdla_accu2pp_if_u pd ; 
// } nvdla_accu2pp_if_t;

extern "C" void parse_cacc2sdp_transaction(
    const       svOpenArrayHandle tlm_gp_data_ptr,
    const       svOpenArrayHandle parsed_data_ptr
) {
    uint8_t             *byte_ptr;
    nvdla_accu2pp_if_t  *sc_ptr;
    uint8_t             *sv_ptr;
    uint32_t            sv_ptr_byte_idx = 0;
    uint32_t            idx;
    int32_t             data_value;
    uint8_t             *src_uint8_ptr;
    uint32_t            copy_idx;
    uint32_t            copy_size;
    byte_ptr = reinterpret_cast <uint8_t *> (svGetArrayPtr(tlm_gp_data_ptr));
    sc_ptr = reinterpret_cast <nvdla_accu2pp_if_t *> (&byte_ptr[1]);
    sv_ptr = reinterpret_cast <uint8_t *> (svGetArrayPtr(parsed_data_ptr));
    // Transfer data
//  for (idx = 0; idx < get_array_len(sc_ptr->pd.nvdla_cc2pp_pkg.data); idx ++) {
    for (idx = 0; idx < ACCU2SDP_DATA_CONTAINER_NUM; idx ++) {
        data_value = sc_ptr->pd.nvdla_cc2pp_pkg.data[idx].to_int();
//      printf("[DEBUG]: ACCU2SDP_DATA_CONTAINER_NUM=%0d, sc_ptr->pd.nvdla_cc2pp_pkg.data.len=%0d, sv_ptr_byte_idx=%0d\n",
//          ACCU2SDP_DATA_CONTAINER_NUM, get_array_len(sc_ptr->pd.nvdla_cc2pp_pkg.data), sv_ptr_byte_idx);
        // cout << "parse_cacc2sdp_transaction, data_value is 0x" << hex << data_value << endl;
        // memcpy(&sv_ptr[sv_ptr_byte_idx], &data_value, sizeof(data_value));
        // sv_ptr_byte_idx += sizeof(data_value);
        copy_size     = sizeof(data_value);
        src_uint8_ptr = reinterpret_cast <uint8_t *> (&data_value);
        for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
            memcpy(&sv_ptr[sv_ptr_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
        }
        sv_ptr_byte_idx += copy_size;
    }
    // Transfer batch_end
    memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->pd.nvdla_cc2pp_pkg.batch_end, sizeof(sc_ptr->pd.nvdla_cc2pp_pkg.batch_end));
    sv_ptr_byte_idx += sizeof(sc_ptr->pd.nvdla_cc2pp_pkg.batch_end);
    // Transfer layer_end
    memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->pd.nvdla_cc2pp_pkg.layer_end, sizeof(sc_ptr->pd.nvdla_cc2pp_pkg.layer_end));
    sv_ptr_byte_idx += sizeof(sc_ptr->pd.nvdla_cc2pp_pkg.layer_end);
}

// typedef struct sdp2pdp_s {
//     uint16_t data [4]; 
//     uint8_t wpos ; 
//     uint8_t cpos ; 
//     uint8_t lc ; 
//     uint8_t surf_end ; 
//     uint8_t cube_end ; 
// } sdp2pdp_t;
// 
// #endif
// 
// union nvdla_sdp2pdp_u {
//     sdp2pdp_t sdp2pdp;
// };
// typedef struct nvdla_sdp2pdp_s {
//     union nvdla_sdp2pdp_u pd ; 
// } nvdla_sdp2pdp_t;

extern "C" void parse_sdp2pdp_transaction(
    const       svOpenArrayHandle tlm_gp_data_ptr,
    const       svOpenArrayHandle parsed_data_ptr
) {
    uint8_t             *byte_ptr;
    nvdla_sdp2pdp_t     *sc_ptr;
    uint8_t             *sv_ptr;
    uint32_t            sv_ptr_byte_idx = 0;
    uint32_t            idx;
    uint16_t            data_value;
    uint8_t             *src_uint8_ptr;
    uint32_t            copy_idx;
    uint32_t            copy_size;
    byte_ptr = reinterpret_cast <uint8_t *> (svGetArrayPtr(tlm_gp_data_ptr));
    sc_ptr = reinterpret_cast <nvdla_sdp2pdp_t *> (&byte_ptr[1]);
    sv_ptr = reinterpret_cast <uint8_t *> (svGetArrayPtr(parsed_data_ptr));
    // Transfer data
//  printf("[DEBUG]: SDP2PDP_DATA_CONTAINER_NUM=%0d, sc_ptr->pd.sdp2pdp.data.len=%0d\n", SDP2PDP_DATA_CONTAINER_NUM, get_array_len(sc_ptr->pd.sdp2pdp.data));
//  for (idx = 0; idx < get_array_len(sc_ptr->pd.sdp2pdp.data); idx ++) {
//  printf("[DEBUG] parse_sdp2pdp_transaction: data_value = %#x\n", sc_ptr->pd.sdp2pdp.data[0]);
    for (idx = 0; idx < SDP2PDP_DATA_CONTAINER_NUM; idx ++) {
        data_value = sc_ptr->pd.sdp2pdp.data[idx];
        copy_size     = sizeof(data_value);
        src_uint8_ptr = reinterpret_cast <uint8_t *> (&data_value);
        for (copy_idx = 0; copy_idx < copy_size; copy_idx++) {
            memcpy(&sv_ptr[sv_ptr_byte_idx+copy_idx], &src_uint8_ptr[copy_size-1-copy_idx], 1);
        }
        sv_ptr_byte_idx += copy_size;
    }
    // Transfer wpos
    // memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->pd.sdp2pdp.wpos, sizeof(sc_ptr->pd.sdp2pdp.wpos));
    // sv_ptr_byte_idx += sizeof(sc_ptr->pd.sdp2pdp.wpos);
    // // Transfer cpos
    // memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->pd.sdp2pdp.cpos, sizeof(sc_ptr->pd.sdp2pdp.cpos));
    // sv_ptr_byte_idx += sizeof(sc_ptr->pd.sdp2pdp.cpos);
    // // Transfer lc
    // memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->pd.sdp2pdp.lc, sizeof(sc_ptr->pd.sdp2pdp.lc));
    // sv_ptr_byte_idx += sizeof(sc_ptr->pd.sdp2pdp.lc);
    // // Transfer surf_end
    // memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->pd.sdp2pdp.surf_end, sizeof(sc_ptr->pd.sdp2pdp.surf_end));
    // sv_ptr_byte_idx += sizeof(sc_ptr->pd.sdp2pdp.surf_end);
    // // Transfer cube_end
    // memcpy(&sv_ptr[sv_ptr_byte_idx], &sc_ptr->pd.sdp2pdp.cube_end, sizeof(sc_ptr->pd.sdp2pdp.cube_end));
    // sv_ptr_byte_idx += sizeof(sc_ptr->pd.sdp2pdp.cube_end);
}








