// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_accu2pp_if_iface.h

#if !defined(_nvdla_accu2pp_if_iface_H_)
#define _nvdla_accu2pp_if_iface_H_

#include <systemc.h>
#include <stdint.h>
#include "nvdla_config.h"

#ifndef _nvdla_cc2pp_pkg_struct_H_
#define _nvdla_cc2pp_pkg_struct_H_

typedef struct nvdla_cc2pp_pkg_s {
    sc_int<32>  data [SDP_MAX_THROUGHPUT]; //used in sc_int<32> element unit for all precisions
    uint8_t     batch_end ; 
    uint8_t     layer_end ; 
} nvdla_cc2pp_pkg_t;

#endif

// union nvdla_accu2pp_if_u {
struct nvdla_accu2pp_if_u {
    nvdla_cc2pp_pkg_t nvdla_cc2pp_pkg;
};
typedef struct nvdla_accu2pp_if_s {
    // union nvdla_accu2pp_if_u pd ; 
    nvdla_accu2pp_if_u pd ; 
} nvdla_accu2pp_if_t;

#endif // !defined(_nvdla_accu2pp_if_iface_H_)
