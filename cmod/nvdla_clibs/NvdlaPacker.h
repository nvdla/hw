// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaPacker.h

#ifndef __NVDLAPACKER_H__
#define __NVDLAPACKER_H__

#include <inttypes.h>
#include <typeinfo>
#include "nvdla_config.h"
#include <cstddef>
#include <assert.h>

using namespace std;

typedef enum {
    DATA_TYPE_ONE_BYTE  = 0,
    DATA_TYPE_TWO_BYTE = 1,
} te_data_type;


#define MAX_ATOM_NUM            (DMAIF_WIDTH/DLA_ATOM_SIZE)
#define MAX_SDP_PROCESS_NUM     (DMAIF_WIDTH/SDP_MAX_THROUGHPUT)
#define MAX_OUTPUT_PAYLOAD_NUM  MAX(MAX_ATOM_NUM, MAX_SDP_PROCESS_NUM)
#define MAX_OUTPUT_WAY_NUM      2

class NvdlaPacker {
    public:
        // Constructors and deconstructors
        NvdlaPacker () {
            working_buffer_         = NULL;
            total_buffer_size_      = 0;
            valid_data_size_        = 0;

            input_payload_size_     = 0;
            output_way_size_        = 0;
            output_way_num_         = 0;
        };
        ~NvdlaPacker (){
            assert(valid_data_size_ == 0);
            if (working_buffer_) delete [] working_buffer_;
        };

        /*
         * Description:
         *  set the parameter of packer:
         *
         * Parameters:
         *  @input_payload_size  : The input payload size in bytes when set_payload is called
         *  @output_way_size     : The bytes per way in a output payload
         *  @output_way_num      : Number of ways in a output payload
         *  @type                : The data type in the output payload
         *
         * NOTE:
         *  We need to exaplain the term of "way" to faciliate user understand how to use this
         *  interface:
         *  In NVDLA SDP RDMA, we support up to 2 channels per data element, we call "channel"
         *  as "way" in packer.
         *  Take SDP BRDMA for example, if the  data_size=TWO_BYTE, DATA_USE=BOTH and one atom
         *  contains 32 elements, then, user has to set:
         *  output_way_size = 32*2(data_size=TWO_BYTES) = 64;
         *  output_way_num  = 2 (DATA_USE=BOTH)
         *  type            = INT16 (data_size=TWO_BYTES)
         * 
         * */
        void set_parameters(uint32_t input_payload_size, uint32_t output_way_size, uint32_t output_way_num, te_data_type type);
        /*
         * Description:
         *  Take the payload data as input then buffer those data to internal working buffer,
         *  if the buffer is full, convert the data to specified output format.
         *
         * Parameters:
         *  @payload        : The input payload data, pointer to input_payload_size bytes
         *  @output_payloads: The array of output payloads (if possible)
         *  @num_payloads   : Number of payloads output by this invoke
         *
         * */
        void set_payload(uint8_t *payload, uint8_t *output_payloads[MAX_OUTPUT_PAYLOAD_NUM][MAX_OUTPUT_WAY_NUM], uint8_t *num_payloads);

        /*
         * Description:
         *  Return the valid data size recieved by packer;
         *
         * Parameters:
         *  N/A
         *
         * */
        uint32_t get_data_size();
        
    private:
        // input
        uint32_t        input_payload_size_;

        // output
        uint32_t        output_way_size_;
        uint32_t        output_way_num_;
        te_data_type    output_type_;

        // internal buffer
        uint8_t         *working_buffer_;
        uint32_t        total_buffer_size_;
        uint32_t        valid_data_size_;
};

#endif

