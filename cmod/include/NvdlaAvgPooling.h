// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaAvgPooling.h

#ifndef _NVDLAAVGPOOLING_H_
#define _NVDLAAVGPOOLING_H_

// #include <stdint.h>
#include <inttypes.h>
#include <typeinfo>

#define DATA_TYPE_IS_INT    0
#define DATA_TYPE_IS_FP     1

using namespace std;

class NvdlaAvgPooling {
    public:
        // Constructors and deconstructors
        NvdlaAvgPooling () {
            data_type_ = 0xFF;
        };
        NvdlaAvgPooling (uint8_t    data_type, uint32_t * scaling_factor, uint8_t    truncation_lsb, uint8_t    truncation_bit_width);
        ~NvdlaAvgPooling (){};
        void    set_data_type               (uint8_t    data_type);
        void    set_scaling_factor          (uint32_t   * scaling_factor);
        void    set_truncation_lsb          (uint8_t    truncation_lsb);
        void    set_truncation_bit_width    (uint8_t    truncation_bit_width);
        template <typename T_IN, typename T_OUT>
        void    do_conversion (T_IN * const data_in, T_OUT * const data_out, uint8_t kernel_width, uint8_t kernel_height, uint8_t data_num);
    private:
        uint8_t data_type_;
        // Factors
        //  1) float
        float   scaling_factor_float_[8];
        //  2) integer
        int64_t scaling_factor_int_[8];
        uint8_t truncation_lsb_;
        uint8_t truncation_bit_width_;
        // Intermediate result
        //  1) float
        double  result_float_;
        //  2) integer
        int64_t result_int_;
};

NvdlaAvgPooling::NvdlaAvgPooling(uint8_t    data_type, uint32_t * scaling_factor, uint8_t    truncation_lsb, uint8_t    truncation_bit_width) {
    cslInfo(("NvdlaAvgPooling::NvdlaAvgPooling: Enter constructor.\n"));
    set_data_type(data_type);
    set_scaling_factor(scaling_factor);
    set_truncation_lsb(truncation_lsb);
    set_truncation_bit_width(truncation_bit_width);
}

void NvdlaAvgPooling::set_data_type        (uint8_t    data_type){
    data_type_ = data_type;
    cslInfo(("NvdlaAvgPooling::set_data_type: data type is %d\n", uint16_t(data_type_)));
}

void NvdlaAvgPooling::set_scaling_factor   (uint32_t   * scaling_factor){
    uint8_t iter;
    float   * scaling_factor_float_ptr;
    int32_t * scaling_factor_int_ptr;
    scaling_factor_float_ptr = reinterpret_cast <float*>   (scaling_factor);
    scaling_factor_int_ptr   = reinterpret_cast <int32_t*> (scaling_factor);
    for (iter = 0; iter<8; iter ++) {
        scaling_factor_float_[iter] = scaling_factor_float_ptr[iter];
        scaling_factor_int_[iter] = int64_t(scaling_factor_int_ptr[iter]);
    }
}

void NvdlaAvgPooling::set_truncation_lsb  (uint8_t    truncation_lsb){
    truncation_lsb_ = truncation_lsb;
    cslInfo(("NvdlaAvgPooling::set_truncation_lsb: truncation lsb is %d\n", uint16_t(truncation_lsb_)));
}

void NvdlaAvgPooling::set_truncation_bit_width (uint8_t    truncation_bit_width){
    truncation_bit_width_ = truncation_bit_width;
    cslInfo(("NvdlaAvgPooling::set_truncation_bit_width: truncation bit width is %d\n", uint16_t(truncation_bit_width_)));
}

template <typename T_IN, typename T_OUT>
void NvdlaAvgPooling::do_conversion (T_IN * const data_in, T_OUT * const data_out, uint8_t kernel_width, uint8_t kernel_height, uint8_t data_num) {
    uint8_t     idx;
    int64_t     data_template;
    uint64_t    mask;
    // Check
    if (0xFF == data_type_) {
        FAIL (("NvdlaAvgPooling::do_conversion : Don't know which data type shall be processed, please set data_type_ at first"));
        // exit (EXIT_FAILURE);
    }
    // Check data type match
    if ((DATA_TYPE_IS_FP == data_type_) && (typeid(*data_in)!= typeid(float)) ) {
        FAIL (("NvdlaAvgPooling::do_conversion : data_in type is not float"));
        // exit (EXIT_FAILURE);
    }
    if ((DATA_TYPE_IS_INT == data_type_) && (typeid(*data_in)!= typeid(int16_t)) && (typeid(*data_in)!= typeid(int32_t)) && (typeid(*data_in)!= typeid(int64_t))) {
        FAIL (("NvdlaAvgPooling::do_conversion : data_in type is not signed integer"));
        // exit (EXIT_FAILURE);
    }
    if (DATA_TYPE_IS_FP == data_type_) {
        // Float point data conversion
        for (idx=0; idx<data_num; idx ++) {
            *data_out = T_OUT((float(*data_in)) * scaling_factor_float_[kernel_width-1] * scaling_factor_float_[kernel_height-1]);
        }
    }
    if (DATA_TYPE_IS_INT == data_type_) {
        // Check truncation_bit_width_ is legal or not
        if ( (truncation_bit_width_ <= 8) ) {
            // do nothing
        } else if ( (truncation_bit_width_ <= 16) && (typeid(*data_out)== typeid(int8_t)) ) {
            // Truncation bit width is (8,16]
            FAIL (("NvdlaAvgPooling::do_conversion : truncation_bit_width_ is larger than output data type"));
            // exit (EXIT_FAILURE);
        } else if ( (truncation_bit_width_ <= 32) && ( (typeid(*data_out)== typeid(int8_t)) || (typeid(*data_out)== typeid(int16_t)) ) ) {
            // Truncation bit width is (16,32]
            FAIL (("NvdlaAvgPooling::do_conversion : truncation_bit_width_ is larger than output data type"));
            // exit (EXIT_FAILURE);
        } else if ( (truncation_bit_width_ <= 64) && ( (typeid(*data_out)== typeid(int8_t)) || (typeid(*data_out)== typeid(int16_t)) || (typeid(*data_out)== typeid(int32_t)) ) ) {
            // Truncation bit width is (32,64]
            FAIL (("NvdlaAvgPooling::do_conversion : truncation_bit_width_ is larger than output data type"));
            // exit (EXIT_FAILURE);
        }
        // Integer data conversion
        mask = 0;
        for (idx=0; idx < truncation_bit_width_; idx ++) {
            mask |= 1 << idx;
        }
        //cout << "Mask is: " << hex << mask << dec << endl;
        mask = mask << truncation_lsb_;
        for (idx=0; idx < data_num; idx ++) {
            //cout << "Input data is " << hex << *data_in << dec << endl;
            data_template = (int64_t(*data_in)) * scaling_factor_int_[kernel_width-1] * scaling_factor_int_[kernel_height-1];
            //cout << "Data template is " << hex << data_template << dec << endl;
            // data_template = int64_t (mask & (*reinterpret_cast <uint64_t*> (&data_template)));
            // *data_out = T_OUT( (*reinterpret_cast <int64_t*> (mask & (*reinterpret_cast <uint64_t*> (&data_template))) >> truncation_lsb_) );
            *data_out = T_OUT( (int64_t (mask & (*reinterpret_cast <uint64_t*> (&data_template))) >> truncation_lsb_) );
            //cout << "Output data is " << hex << *data_out << dec << endl;
        }
    }
}

#endif

