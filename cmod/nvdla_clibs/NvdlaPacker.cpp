// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaPacker.cpp
#include "NvdlaPacker.h"
#include <algorithm>
#include <cstring>

void NvdlaPacker::set_parameters(uint32_t input_payload_size, uint32_t output_way_size, uint32_t output_way_num, te_data_type type)
{
    int updated_total_size = 0;
    input_payload_size_     = input_payload_size;
    output_way_size_        = output_way_size;
    output_way_num_         = output_way_num;
    output_type_            = type;

    updated_total_size      = max(output_way_size * output_way_num, input_payload_size);
    if (updated_total_size != total_buffer_size_) {
        assert(valid_data_size_ == 0);
        if (working_buffer_) delete [] working_buffer_;

        working_buffer_     = new uint8_t[updated_total_size];
        assert(working_buffer_ != NULL);

        total_buffer_size_  = updated_total_size;
    }
}

uint32_t NvdlaPacker::get_data_size()
{
    return valid_data_size_;
}

void NvdlaPacker::set_payload(uint8_t *payload, uint8_t *output_payloads[MAX_OUTPUT_PAYLOAD_NUM][MAX_OUTPUT_WAY_NUM], uint8_t *num_payloads)
{
    assert(working_buffer_ != NULL);
    assert(valid_data_size_ + input_payload_size_ <= total_buffer_size_);
    memcpy(working_buffer_ + valid_data_size_, payload, input_payload_size_);

    valid_data_size_ += input_payload_size_;
    if (valid_data_size_ == total_buffer_size_) {
        int BPE = output_type_ == DATA_TYPE_ONE_BYTE ? 1 : 2;
        if (output_type_ == DATA_TYPE_ONE_BYTE) {
            int element_per_output_payload = output_way_size_ / (BPE);
            *num_payloads = valid_data_size_/(output_way_size_*output_way_num_);

            for(int payload_iter = 0; payload_iter < *num_payloads; payload_iter++) {
                uint8_t *src_data = ((uint8_t*)working_buffer_) + payload_iter*element_per_output_payload*output_way_num_;

                // allocate output payload buffers
                for(int way_iter = 0; way_iter < output_way_num_; way_iter++) {
                    output_payloads[payload_iter][way_iter] = new uint8_t[element_per_output_payload];
                    assert(output_payloads[payload_iter][way_iter] != NULL);
                }

                // feeds the data, it's interleaving format. e.g.: For way_num=2,
                // the layout will be: A0B0A1B1...
                for(int element_iter = 0; element_iter < element_per_output_payload; element_iter++) {
                    for(int way_iter = 0; way_iter < output_way_num_; way_iter++) {
                        *((uint8_t*)&output_payloads[payload_iter][way_iter][element_iter]) = src_data[way_iter + element_iter*output_way_num_];
                    }
                }
            }
        } else {
            int element_per_output_payload = output_way_size_ / (BPE);
            *num_payloads = valid_data_size_/(output_way_size_*output_way_num_);

            for(int payload_iter = 0; payload_iter < *num_payloads; payload_iter++) {
                uint16_t *src_data = ((uint16_t*)working_buffer_) + payload_iter*element_per_output_payload*output_way_num_;
                uint16_t *dst_data[MAX_OUTPUT_WAY_NUM] = {NULL};

                // allocate output payload buffers
                for(int way_iter = 0; way_iter < output_way_num_; way_iter++) {
                    output_payloads[payload_iter][way_iter] = reinterpret_cast<uint8_t*>(new uint16_t[element_per_output_payload]);
                    assert(output_payloads[payload_iter][way_iter] != NULL);
                    dst_data[way_iter] = (uint16_t*)output_payloads[payload_iter][way_iter];
                }

                // feeds the data, it's interleaving format. e.g.: For way_num=2,
                // the layout will be: A0B0A1B1...
                for(int element_iter = 0; element_iter < element_per_output_payload; element_iter++) {
                    for(int way_iter = 0; way_iter < output_way_num_; way_iter++) {
                        dst_data[way_iter][element_iter] = src_data[way_iter + element_iter*output_way_num_];
                    }
                }
            }
        }

        valid_data_size_ = 0;
    } else {
        *num_payloads = 0;
    }

    assert(*num_payloads <= MAX_OUTPUT_PAYLOAD_NUM);
}

