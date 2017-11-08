// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_MSDEC_xx2csb_resp_iface.h

#if !defined(_NV_MSDEC_xx2csb_resp_iface_H_)
#define _NV_MSDEC_xx2csb_resp_iface_H_

#include <stdint.h>
#ifndef _xx2csb_rd_erpt_struct_H_
#define _xx2csb_rd_erpt_struct_H_

typedef struct xx2csb_rd_erpt_s {
    uint32_t rdat ; 
    uint8_t error ; 
} xx2csb_rd_erpt_t;

#endif
#ifndef _xx2csb_wr_erpt_struct_H_
#define _xx2csb_wr_erpt_struct_H_

typedef struct xx2csb_wr_erpt_s {
    uint32_t rdat ; 
    uint8_t error ; 
} xx2csb_wr_erpt_t;

#endif

#define XX2CSB_RESP_TAG_READ    0
#define XX2CSB_RESP_TAG_WRITE   1

union NV_MSDEC_xx2csb_resp_u {
    xx2csb_rd_erpt_t xx2csb_rd_erpt;
    xx2csb_wr_erpt_t xx2csb_wr_erpt;
};
typedef struct NV_MSDEC_xx2csb_resp_s {
    union NV_MSDEC_xx2csb_resp_u pd ; 
    uint8_t tag;
} NV_MSDEC_xx2csb_resp_t;

#endif // !defined(_NV_MSDEC_xx2csb_resp_iface_H_)
