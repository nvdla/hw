// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_sc2mac_weight_if_iface.h

#if !defined(_nvdla_sc2mac_weight_if_iface_H_)
#define _nvdla_sc2mac_weight_if_iface_H_

#include <stdint.h>

typedef struct nvdla_sc2mac_weight_if_s {
    uint64_t mask [2];
    sc_int<8> data[128];
    uint16_t sel ; 
} nvdla_sc2mac_weight_if_t;

#endif // !defined(_nvdla_sc2mac_weight_if_iface_H_)
