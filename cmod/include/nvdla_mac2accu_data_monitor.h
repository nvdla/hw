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

// union nvdla_mac2accu_data_if_u {
//     nvdla_stripe_info_t nvdla_stripe_info;
// };
typedef struct nvdla_mac2accu_data_monitor_s {
    uint8_t mask ; 
    uint8_t mode;
    int32_t  data [8*8]; 
    // union nvdla_mac2accu_data_if_u pd ; 
    nvdla_stripe_info_t nvdla_stripe_info;
} nvdla_mac2accu_data_monitor_t;

#endif // !defined(_nvdla_mac2accu_data_monitor_H_)

