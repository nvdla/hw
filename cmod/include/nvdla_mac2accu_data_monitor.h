// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_mac2accu_data_monitor.h

#if !defined(_nvdla_mac2accu_data_monitor_H_)
#define _nvdla_mac2accu_data_monitor_H_

#include <systemc.h>
#include <stdint.h>
#ifndef _nvdla_stripe_info_struct_H_
#include "nvdla_stripe_info_struct.h"
#endif
#include "nvdla_config.h"

// union nvdla_mac2accu_data_if_u {
//     nvdla_stripe_info_t nvdla_stripe_info;
// };
typedef struct nvdla_mac2accu_data_monitor_s {
    uint32_t mask ; 
    uint8_t mode;
    int32_t  data [(NVDLA_MAC_ATOMIC_K_SIZE / 2) * 4];
    // union nvdla_mac2accu_data_if_u pd ; 
    nvdla_stripe_info_t nvdla_stripe_info;
} nvdla_mac2accu_data_monitor_t;

#endif // !defined(_nvdla_mac2accu_data_monitor_H_)

