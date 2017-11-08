// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_fc_sc_credit_iface.h

#if !defined(_nvdla_fc_sc_credit_iface_H_)
#define _nvdla_fc_sc_credit_iface_H_

#include <stdint.h>

typedef struct nvdla_fc_sc_credit_s {
    uint16_t updated_entry_number ; 
    uint16_t updated_slice_number ; 
} nvdla_fc_sc_credit_t;

#endif // !defined(_nvdla_fc_sc_credit_iface_H_)
