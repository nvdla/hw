// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaDataFormatConvertor.h

#ifndef _NVDLADATAFORMATCONVERTOR_H_
#define _NVDLADATAFORMATCONVERTOR_H_

// #include <stdint.h>
#include <inttypes.h>
#include <typeinfo>
#include "log.h"

#define DATA_TYPE_IS_INT    0
#define DATA_TYPE_IS_FP     1

using namespace std;

class NvdlaDataFormatConvertor {
    public:
        // Constructors and deconstructors
        NvdlaDataFormatConvertor () {
            data_type_ = 0xFF;
        };
        NvdlaDataFormatConvertor (uint8_t    data_type, uint32_t   offset, uint32_t   scaling_factor, uint8_t    truncation_lsb, uint8_t    truncation_bit_width);
        ~NvdlaDataFormatConvertor (){};
        void    set_data_type               (uint8_t    data_type);
        void    set_offset                  (uint32_t   &offset);
        void    set_scaling_factor          (uint32_t   &scaling_factor);
        void    set_truncation_lsb         (uint8_t    truncation_lsb);
        void    set_truncation_bit_width   (uint8_t    truncation_bit_width);
        template <typename T_IN, typename T_OUT>
        void    do_conversion (T_IN * const data_in, T_OUT * const data_out, uint32_t data_num);
    private:
        uint8_t data_type_;
        // Factors
        //  1) float
        float   offset_float_;
        float   scaling_factor_float_;
        //  2) integer
        int64_t offset_int_;
        int64_t scaling_factor_int_;
        uint8_t truncation_lsb_;
        uint8_t truncation_bit_width_;
        // Intermediate result
        //  1) float
        double  result_float_;
        //  2) integer
        int64_t result_int_;
};

template <typename T_IN, typename T_OUT>
void NvdlaDataFormatConvertor::do_conversion (T_IN * const data_in, T_OUT * const data_out, uint32_t data_num) {
    uint8_t     idx;
    int64_t     data_template;
    uint64_t    mask;
    // Check
    if (0xFF == data_type_) {
        FAIL (("NvdlaDataFormatConvertor::do_conversion : Don't know which data type shall be processed, please set data_type_ at first"));
        // exit (EXIT_FAILURE);
    }
    // Check data type match
    if ((DATA_TYPE_IS_FP == data_type_) && (typeid(*data_in)!= typeid(float)) ) {
        FAIL (("NvdlaDataFormatConvertor::do_conversion : data_in type is not float"));
        // exit (EXIT_FAILURE);
    }
    if ((DATA_TYPE_IS_INT == data_type_) && (typeid(*data_in)!= typeid(int16_t)) && (typeid(*data_in)!= typeid(int32_t)) && (typeid(*data_in)!= typeid(int64_t))) {
        FAIL (("NvdlaDataFormatConvertor::do_conversion : data_in type is not signed integer"));
        // exit (EXIT_FAILURE);
    }
    if (DATA_TYPE_IS_FP == data_type_) {
        // Float point data conversion
        for (idx=0; idx<data_num; idx ++) {
            data_out[idx] = T_OUT((float(data_in[idx]) - offset_float_) * scaling_factor_float_);
        }
    }
    if (DATA_TYPE_IS_INT == data_type_) {
        // Check truncation_bit_width_ is legal or not
        if ( (truncation_bit_width_ <= 8) ) {
            // do nothing
        } else if ( (truncation_bit_width_ <= 16) && (typeid(*data_out)== typeid(int8_t)) ) {
            // Truncation bit width is (8,16]
            FAIL (("NvdlaDataFormatConvertor::do_conversion : truncation_bit_width_ is larger than output data type"));
            // exit (EXIT_FAILURE);
        } else if ( (truncation_bit_width_ <= 32) && ( (typeid(*data_out)== typeid(int8_t)) || (typeid(*data_out)== typeid(int16_t)) ) ) {
            // Truncation bit width is (16,32]
            FAIL (("NvdlaDataFormatConvertor::do_conversion : truncation_bit_width_ is larger than output data type"));
            // exit (EXIT_FAILURE);
        } else if ( (truncation_bit_width_ <= 64) && ( (typeid(*data_out)== typeid(int8_t)) || (typeid(*data_out)== typeid(int16_t)) || (typeid(*data_out)== typeid(int32_t)) ) ) {
            // Truncation bit width is (32,64]
            FAIL (("NvdlaDataFormatConvertor::do_conversion : truncation_bit_width_ is larger than output data type"));
            // exit (EXIT_FAILURE);
        }
        // Integer data conversion
        mask = 0;
        for (idx=0; idx < truncation_bit_width_; idx ++) {
            mask |= 1 << idx;
        }
        mask = mask << truncation_lsb_;
        for (idx=0; idx < data_num; idx ++) {
            cslInfo(("Input data is 0x%x\n", *data_in));
            data_template = (int64_t(data_in[idx]) - offset_int_) * scaling_factor_int_;
            cslInfo(("Data template is 0x%x\n", data_template));
            // data_template = int64_t (mask & (*reinterpret_cast <uint64_t*> (&data_template)));
            // *data_out = T_OUT( (*reinterpret_cast <int64_t*> (mask & (*reinterpret_cast <uint64_t*> (&data_template))) >> truncation_lsb_) );
            data_out[idx] = T_OUT( (int64_t (mask & (*reinterpret_cast <uint64_t*> (&data_template))) >> truncation_lsb_) );
            cslInfo(("Output data is 0x%x\n", *data_out));
        }
    }
}

#endif

