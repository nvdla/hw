// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_sdp2pdp_iface.h

#if !defined(_nvdla_sdp2pdp_iface_H_)
#define _nvdla_sdp2pdp_iface_H_

#include <stdint.h>
#include "nvdla_config.h"

#ifndef _sdp2pdp_struct_H_
#define _sdp2pdp_struct_H_

typedef struct sdp2pdp_s {
    uint16_t data [SDP_MAX_THROUGHPUT]; //used in byte unit 
} sdp2pdp_t;

#endif

union nvdla_sdp2pdp_u {
    sdp2pdp_t sdp2pdp;
};
typedef struct nvdla_sdp2pdp_s {
    union nvdla_sdp2pdp_u pd ; 
} nvdla_sdp2pdp_t;

#endif // !defined(_nvdla_sdp2pdp_iface_H_)
