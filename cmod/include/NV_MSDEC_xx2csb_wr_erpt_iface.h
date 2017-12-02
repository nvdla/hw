// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_MSDEC_xx2csb_wr_erpt_iface.h

#ifndef _NV_MSDEC_XX2CSB_WR_ERPT_T_IFACE_H_
#define _NV_MSDEC_XX2CSB_WR_ERPT_T_IFACE_H_

#include <stdint.h>
#ifndef _xx2csb_struct_H_
#include "xx2csb_struct.h"
#endif

union NV_MSDEC_xx2csb_wr_erpt_u {
    xx2csb_t xx2csb;
};

typedef struct NV_MSDEC_xx2csb_wr_erpt_s {
    union NV_MSDEC_xx2csb_wr_erpt_u pd ; 
    uint8_t complete ; 
    uint8_t error ; 
} NV_MSDEC_xx2csb_wr_erpt_t;

#endif
