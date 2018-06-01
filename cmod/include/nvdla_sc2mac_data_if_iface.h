// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_sc2mac_data_if_iface.h

#if !defined(_nvdla_sc2mac_data_if_iface_H_)
#define _nvdla_sc2mac_data_if_iface_H_

#include <systemc.h>
#include <stdint.h>
#ifndef _nvdla_stripe_info_struct_H_
#include "nvdla_stripe_info_struct.h"
#endif
#include "nvdla_config.h"

union nvdla_sc2mac_data_if_u {
    nvdla_stripe_info_t nvdla_stripe_info;
};
typedef struct nvdla_sc2mac_data_if_s {
    uint64_t mask [2] ; //used in uint64_t element unit 
    sc_int<8> data[NVDLA_CBUF_BANK_WIDTH]; //used in byte unit
    union nvdla_sc2mac_data_if_u pd ; 
} nvdla_sc2mac_data_if_t;

#endif // !defined(_nvdla_sc2mac_data_if_iface_H_)
