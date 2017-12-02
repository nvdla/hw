// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_mac2accu_data_if_iface.h

#if !defined(_nvdla_mac2accu_data_if_iface_H_)
#define _nvdla_mac2accu_data_if_iface_H_

#include <systemc.h>
#include <stdint.h>
#ifndef _nvdla_stripe_info_struct_H_
#include "nvdla_stripe_info_struct.h"
#endif

union nvdla_mac2accu_data_if_u {
    nvdla_stripe_info_t nvdla_stripe_info;
};
typedef struct nvdla_mac2accu_data_if_s {
    uint8_t mask ; 
    uint8_t mode ;
    sc_int<22> data [8*8]; 
    union nvdla_mac2accu_data_if_u pd ; 
} nvdla_mac2accu_data_if_t;

typedef struct nvdla_mac2accu_data_concat_if_s {
    uint16_t mask ; 
    sc_int<22> data [16*8]; 
    union nvdla_mac2accu_data_if_u pd ; 
} nvdla_mac2accu_data_concat_if_t;

// typedef struct nvdla_mac_half2accu_data_if_s {
//     uint16_t mask ; 
//     sc_int<22> data [8*8]; 
//     union nvdla_mac2accu_data_if_u pd ; 
// } nvdla_mac_half2accu_data_if_t;


#endif // !defined(_nvdla_mac2accu_data_if_iface_H_)

