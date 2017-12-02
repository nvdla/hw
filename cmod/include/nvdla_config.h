// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_config.h

#define NVDLA_CONFIG_SMALL

#define NVDLA_FEATURE_DATA_TYPE_BINARY  (1<<0)
#define NVDLA_FEATURE_DATA_TYPE_UINT4   (1<<1)
#define NVDLA_FEATURE_DATA_TYPE_INT4    (1<<2)
#define NVDLA_FEATURE_DATA_TYPE_UINT8   (1<<3)
#define NVDLA_FEATURE_DATA_TYPE_INT8    (1<<4)
#define NVDLA_FEATURE_DATA_TYPE_UINT16  (1<<5)
#define NVDLA_FEATURE_DATA_TYPE_INT16   (1<<6)
#define NVDLA_FEATURE_DATA_TYPE_UINT32  (1<<7)
#define NVDLA_FEATURE_DATA_TYPE_INT32   (1<<8)
#define NVDLA_FEATURE_DATA_TYPE_FP16    (1<<9)
#define NVDLA_FEATURE_DATA_TYPE_FP32    (1<<10)
#define NVDLA_FEATURE_DATA_TYPE_FP64    (1<<11)

#define NVDLA_WEIGHT_DATA_TYPE_BINARY   (1<<0)
#define NVDLA_WEIGHT_DATA_TYPE_UINT4    (1<<1)
#define NVDLA_WEIGHT_DATA_TYPE_INT4     (1<<2)
#define NVDLA_WEIGHT_DATA_TYPE_UINT8    (1<<3)
#define NVDLA_WEIGHT_DATA_TYPE_INT8     (1<<4)
#define NVDLA_WEIGHT_DATA_TYPE_UINT16   (1<<5)
#define NVDLA_WEIGHT_DATA_TYPE_INT16    (1<<6)
#define NVDLA_WEIGHT_DATA_TYPE_UINT32   (1<<7)
#define NVDLA_WEIGHT_DATA_TYPE_INT32    (1<<8)
#define NVDLA_WEIGHT_DATA_TYPE_FP16     (1<<9)
#define NVDLA_WEIGHT_DATA_TYPE_FP32     (1<<10)
#define NVDLA_WEIGHT_DATA_TYPE_FP64     (1<<11)

#ifdef NVDLA_CONFIG_LARGE
#include "nvdla_config_large.h"
#elif NVDLA_CONFIG_SMALL
#include "nvdla_config_small.h"
#endif
