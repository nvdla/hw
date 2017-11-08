// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_container_number_8_bit_width_32_iface.h

#if !defined(_nvdla_container_number_8_bit_width_32_iface_H_)
#define _nvdla_container_number_8_bit_width_32_iface_H_

#include <systemc.h>
#include <stdint.h>

typedef struct nvdla_container_number_8_bit_width_32_s {
    uint8_t mask ; 
    sc_uint<32> data [8];
    uint8_t last ; 
} nvdla_container_number_8_bit_width_32_t;

#endif // !defined(_nvdla_container_number_8_bit_width_32_iface_H_)
