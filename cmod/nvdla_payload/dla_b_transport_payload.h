// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: dla_b_transport_payload.h

#ifndef _DLA_B_TRANSPORT_PAYLOAD_H_
#define _DLA_B_TRANSPORT_PAYLOAD_H_

#include <systemc>
#include <tlm.h>
#include "scsim_common.h"
#include "nvdla_dbb_extension.h"

SCSIM_NAMESPACE_START(clib)
using namespace tlm;

class dla_b_transport_payload {
public:
    enum dla_b_transport_payload_type {
        DLA_B_TRANSPORT_PAYLOAD_TYPE_EMPTY = 0,
        DLA_B_TRANSPORT_PAYLOAD_TYPE_MC = 2
    };

    tlm::tlm_generic_payload gp;

    uint8_t  *data;
    uint8_t  *be;
    uint32_t len;

    nvdla_dbb_extension *nv_dbb_ext;

    dla_b_transport_payload_type type;
    dla_b_transport_payload( uint32_t _len, dla_b_transport_payload_type _type );
    ~dla_b_transport_payload();

    void set_tlm_extension_by_type(tlm_generic_payload &gp, dla_b_transport_payload_type _type);

    static void user_configure_gp( tlm::tlm_generic_payload& user_gp, uint64_t addr, uint32_t len, bool is_read );
    void configure_gp( uint64_t addr, uint32_t len, bool is_read );
};

SCSIM_NAMESPACE_END()

#endif



