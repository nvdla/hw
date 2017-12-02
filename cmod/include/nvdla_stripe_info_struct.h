// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_stripe_info_struct.h

#include <stdint.h>
#ifndef _nvdla_stripe_struct_H_
#define _nvdla_stripe_struct_H_
typedef struct nvdla_stripe_info_s {
  uint8_t redundant;
  uint8_t layer_end;
  uint8_t channel_end;
  uint8_t stripe_end;
  uint8_t stripe_st;
  uint8_t batch_index;
} nvdla_stripe_info_t;
#endif
