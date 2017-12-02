// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: dla_b_transport_payload.cpp

#include "dla_b_transport_payload.h"
#include "nvdla_dbb_extension.h"
#include "log.h"
USING_SCSIM_NAMESPACE(cmod);
USING_SCSIM_NAMESPACE(clib);

using namespace::tlm;

dla_b_transport_payload::dla_b_transport_payload( uint32_t _len, dla_b_transport_payload_type _type ):
        data(NULL), 
        be(NULL), 
        len(_len), 
        type(_type)
{
    data = new uint8_t[len];
    be   = new uint8_t[len];

    dla_b_transport_payload::set_tlm_extension_by_type(gp, _type);

    gp.set_data_ptr(data);
    gp.set_data_length(len);
    gp.set_byte_enable_ptr(be);
    gp.set_byte_enable_length(len);

}

dla_b_transport_payload::~dla_b_transport_payload()
{
    
    // Don't need to delete extension, gp will help delete them
    // if ( host1x_ext ) delete host1x_ext;
    // if ( mc_ext ) delete mc_ext;
    if ( data ) delete [] data; 
    if ( be ) delete [] be;
}

void dla_b_transport_payload::set_tlm_extension_by_type(tlm_generic_payload &gp, dla_b_transport_payload_type _type){
    switch ( _type ) {
        case DLA_B_TRANSPORT_PAYLOAD_TYPE_EMPTY:
            cslDebug((30, "DLA_B_TRANSPORT_PAYLOAD_TYPE_EMPTY"));
            // No extension
            break;
        case DLA_B_TRANSPORT_PAYLOAD_TYPE_MC:
            cslDebug((30, "DLA_B_TRANSPORT_PAYLOAD_TYPE_MC"));
            nv_dbb_ext = new nvdla_dbb_extension();
            gp.set_extension(nv_dbb_ext);
            break;
        default:
            cslDebug((30,  "set_tlm_extension_by_type: dla_b_transport_payload_type(%u), is not supported.", _type ));
            assert(0);
    }
}

void dla_b_transport_payload::user_configure_gp(
        tlm::tlm_generic_payload& user_gp,
        uint64_t addr,
        uint32_t set_len,
        bool is_read )
{
    if( is_read ) {
        user_gp.set_command(tlm::TLM_READ_COMMAND); 
    } else {
        user_gp.set_command(tlm::TLM_WRITE_COMMAND); 
    }
    user_gp.set_address(addr); 
    user_gp.set_data_length(set_len);
    user_gp.set_byte_enable_length(set_len);
    user_gp.set_streaming_width(set_len);
}

void dla_b_transport_payload::configure_gp(
        uint64_t addr,
        uint32_t set_len,
        bool is_read )
{
    if( set_len > len ) {
        cslDebug((30, "Setting a set_len(%u), which is larger than max len(%u)", set_len, len ));
        assert(0);
    }

    user_configure_gp( this->gp, addr, set_len, is_read);
    if( is_read ) {
        gp.set_command(tlm::TLM_READ_COMMAND); 
    } else {
        gp.set_command(tlm::TLM_WRITE_COMMAND); 
    }
    gp.set_dmi_allowed(false);
    gp.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);
}
