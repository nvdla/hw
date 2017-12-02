// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaDataFormatConvertor.cpp

#include <inttypes.h>
#include <typeinfo>
#include "NvdlaDataFormatConvertor.h"
#include "log.h"
#define DATA_TYPE_IS_INT    0
#define DATA_TYPE_IS_FP     1

using namespace std;

NvdlaDataFormatConvertor::NvdlaDataFormatConvertor(uint8_t    data_type, uint32_t   offset, uint32_t   scaling_factor, uint8_t    truncation_lsb, uint8_t    truncation_bit_width) {
    cslDebug((70, "NvdlaDataFormatConvertor::NvdlaDataFormatConvertor: Enter constructor.\n"));
    set_data_type(data_type);
    set_offset(offset);
    set_scaling_factor(scaling_factor);
    set_truncation_lsb(truncation_lsb);
    set_truncation_bit_width(truncation_bit_width);
}

void NvdlaDataFormatConvertor::set_data_type        (uint8_t    data_type){
    data_type_ = data_type;
    cslDebug((70, "NvdlaDataFormatConvertor::set_data_type: data type is %d\n", uint16_t(data_type_)));
}

void NvdlaDataFormatConvertor::set_offset           (uint32_t   &offset){
    offset_float_ = *reinterpret_cast <float*>    (&offset);
    offset_int_   = int64_t(*reinterpret_cast <int32_t*>  (&offset));
    cslDebug((70, "NvdlaDataFormatConvertor::set_offset: offset float is %f\n", offset_float_));
    cslDebug((70, "NvdlaDataFormatConvertor::set_offset: offset integer is %ld\n", offset_int_));
}

void NvdlaDataFormatConvertor::set_scaling_factor   (uint32_t   &scaling_factor){
    scaling_factor_float_ = *reinterpret_cast <float*>            (&scaling_factor);
    scaling_factor_int_   = int64_t(*reinterpret_cast <int32_t*>  (&scaling_factor));
    cslDebug((70, "NvdlaDataFormatConvertor::set_scaling_factor: scalling float is %f\n", scaling_factor_float_));
    cslDebug((70, "NvdlaDataFormatConvertor::set_scaling_factor: scalling integer is %ld\n", scaling_factor_int_));
}

void NvdlaDataFormatConvertor::set_truncation_lsb  (uint8_t    truncation_lsb){
    truncation_lsb_ = truncation_lsb;
    cslDebug((70, "NvdlaDataFormatConvertor::set_truncation_lsb: truncation lsb is %d\n", uint16_t(truncation_lsb_)));
}

void NvdlaDataFormatConvertor::set_truncation_bit_width (uint8_t    truncation_bit_width){
    truncation_bit_width_ = truncation_bit_width;
    cslDebug((70, "NvdlaDataFormatConvertor::set_truncation_bit_width: truncation bit width is %d\n", uint16_t(truncation_bit_width_)));
}

