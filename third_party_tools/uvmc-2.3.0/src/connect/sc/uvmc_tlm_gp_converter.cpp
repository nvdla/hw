//============================================================================
// @(#) $Id: uvmc_tlm_gp_converter.cpp 1259 2014-11-29 21:16:42Z jstickle $
//============================================================================

   //_______________________
  // Mentor Graphics, Corp. \_________________________________________________
 //                                                                         //
//   (C) Copyright, Mentor Graphics, Corp. 2003-2014                        //
//   All Rights Reserved                                                    //
//                                                                          //
//    Licensed under the Apache License, Version 2.0 (the                   //
//    "License"); you may not use this file except in                       //
//    compliance with the License.  You may obtain a copy of                //
//    the License at                                                        //
//                                                                          //
//        http://www.apache.org/licenses/LICENSE-2.0                        //
//                                                                          //
//    Unless required by applicable law or agreed to in                     //
//    writing, software distributed under the License is                    //
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR                //
//    CONDITIONS OF ANY KIND, either express or implied.  See               //
//    the License for the specific language governing                      //
//    permissions and limitations under the License.                      //
//-----------------------------------------------------------------------//

#include <stdio.h>
#include <string.h>

// Define compound macro for VCS || NCSC
#ifdef VCS
#define VCS_OR_NCSC
#endif

#ifdef NCSC
#define VCS_OR_NCSC
#endif

#ifdef VCS_OR_NCSC
#include <map>
using std::map;
#endif

#include "svdpi.h"

#include "uvmc_tlm_gp_converter.h"

#ifdef VCS_OR_NCSC
// Search for VCS, NCSC comments in similar code in uvmc_xl_converter.cpp
// for why this is needed for VCS,IUS modes only.
static map<unsigned char *, bool> duplicated_storage_map;
#endif

//----------------------------------------------------------------------------
// DPI-C import "C-assist" helper functions
//
// The following UVMC_CONV_SV2C functions assist in providing
// "pass-by-reference" handling and "turbo boost" for performing certain copy
// operations between C and SV arrays.
//----------------------------------------------------------------------------

extern "C" {

void  UVMC_CONV_SV2C_copy_c2sv_array(
    unsigned num_bytes,
    unsigned long long src_c_array_chandle,
    const svOpenArrayHandle dst_sv_array_handle )
{
#ifdef VCS // {
    // For VCS we cannot memcpy() directly to the raw simulator SV data open
    // array storage area from the C source byte array as its representation
    // appears different than just a straight byte-to-byte mapping. In fact
    // each byte of the TLM GP is actually expanded out to a full 32 bit word.
    //
    // We could use the "foolproof" portable svPutBitArrElem1VecVal() utility
    // function for VCS.
    //
    // But let's give it the benefit of the doubt and still go for some
    // decent performance. To do so we merely do a copy of the C byte array
    // source storage expanded out to the target SV 32 bit int array.

    svBitVecVal *targetStorage
        = reinterpret_cast<svBitVecVal *>(svGetArrayPtr(dst_sv_array_handle));
    for( unsigned i=0; i<num_bytes; i++ )
        targetStorage[i] = ((unsigned char *)src_c_array_chandle)[i];
#else
    memcpy( svGetArrayPtr(dst_sv_array_handle), (void *)src_c_array_chandle,
        num_bytes );
#endif // }
}

void  UVMC_CONV_SV2C_convert_array_ref_to_chandle(
    const svOpenArrayHandle src_sv_array_handle,
    svBitVecVal *dst_sv_array_chandle )
{
    union {
        svBitVecVal bitVecRep[2];
        void *chandle;
    } chandle_caster;

    chandle_caster.chandle = svGetArrayPtr(src_sv_array_handle);

    dst_sv_array_chandle[0] = chandle_caster.bitVecRep[0];
    dst_sv_array_chandle[1] = chandle_caster.bitVecRep[1];
}

#ifdef VCS_OR_NCSC // {
// For VCS, IUS specifically, the special functions below are needed. Search
// for NCSC comments in similar code in uvmc_xl_converter.cpp for more details.

void UVMC_CONV_SV2C_duplicate_array_ref_to_chandle(
    const svOpenArrayHandle src_sv_array_handle,
    svBitVecVal *dst_sv_array_chandle )
{
    union {
        svBitVecVal bitVecRep[2];
        void *chandle;
    } chandle_caster;

    chandle_caster.chandle = svGetArrayPtr(src_sv_array_handle);

    int num_bytes = svSize( src_sv_array_handle, 1 );
    unsigned char *duplicated_storage = new unsigned char[num_bytes];

#ifdef VCS // {
    // For VCS specifically we need to do an
    // "in place compression" of the internal storage format for a
    // TLM GP byte array representation of an array of 32 bit words
    // per byte to the required C "1 byte per byte" rep.
    unsigned i;
    for( i=0; i<num_bytes; i++ )
        ((unsigned char *)duplicated_storage)[i]
            = ((svBitVecVal *)chandle_caster.chandle)[i];
#else
    memcpy( duplicated_storage, chandle_caster.chandle, num_bytes );
#endif // } VCS

    chandle_caster.chandle = duplicated_storage;
    duplicated_storage_map[duplicated_storage] = true;

    dst_sv_array_chandle[0] = chandle_caster.bitVecRep[0];
    dst_sv_array_chandle[1] = chandle_caster.bitVecRep[1];
}

void UVMC_CONV_SV2C_free_duplicated_storage(
    unsigned long long c_array_chandle )
{
    // See VCS, NCSC comments in
    // UVMC_CONV_SV2C_convert_array_ref_to_chandle() below
    // for why this is needed. Here we free the temporarily duplicated data
    // pointer storage if applicable, now that we're done with it.
    if( c_array_chandle != 0 ){
        unsigned char *duplicated_storage = (unsigned char *)c_array_chandle;
        map<unsigned char *, bool>::iterator it =
            duplicated_storage_map.find( duplicated_storage );
//      assert( it != duplicated_storage_map.end() );

        if( it != duplicated_storage_map.end() && it->second == true ){
            it->second = false;
            delete [] duplicated_storage;
        }
    }
}
#endif // } VCS_OR_NCSC

};

//_____________________________                                _______________
// class uvmc_tlm_gp_converter \______________________________/ johnS 5-7-2012
//----------------------------------------------------------------------------

//---------------------------------------------------------
// ::do_pack()                               johnS 5-7-2012
//---------------------------------------------------------

void uvmc_tlm_gp_converter::do_pack(
        const tlm_generic_payload &t, uvmc_packer &packer )
{
    unsigned char *data_ptr    = t.get_data_ptr();
    unsigned int data_len      = t.get_data_length();
    unsigned char *byte_en_ptr = t.get_byte_enable_ptr();
    unsigned int byte_en_len   = t.get_byte_enable_length();
    sc_dt::uint64 addr         = t.get_address();

    packer << addr;                            // {bits[1],bits[0]}
    packer << (int)(t.get_command());          // bits[2]

    if( data_len == 0 || data_ptr == NULL ) {
        data_len = 0;
        data_ptr = NULL;
    }

    packer << data_len;                        // bits[3]

    // Here we just pass the payload "by reference" using its "chandle".
    packer << (unsigned long long)(void *)data_ptr; // {bits[5],bits[4]}

    packer << (int)(t.get_response_status());  // bits[6]

    if( byte_en_len == 0 || byte_en_ptr == NULL ) {
        byte_en_len = 0;
        byte_en_ptr = NULL;
    }

    packer << byte_en_len;                     // bits[7]

    // Here we just pass the byte_enable_ptr "by reference" using its "chandle".
    packer << (unsigned long long)(void *)byte_en_ptr; // {bits[9],bits[8]}

    packer << t.get_streaming_width();         // bits[10]
}

//---------------------------------------------------------
// ::do_unpack()                             johnS 5-7-2012
//---------------------------------------------------------

void uvmc_tlm_gp_converter::do_unpack(
        tlm_generic_payload &t, uvmc_packer &unpacker )
{
    sc_dt::uint64  new_addr;
    unsigned int   new_cmd;
    unsigned int   new_data_len;
    unsigned int   new_byte_en_len;
    unsigned int   new_resp_stat;
    unsigned int   new_streaming_width;
    unsigned long long new_data_ptr_chandle;
    unsigned long long new_byte_en_ptr_chandle;

    unpacker >> new_addr;                   // { bits[1], bits[0] }
    unpacker >> new_cmd;                    // bits[2]
    unpacker >> new_data_len;               // bits[3]
    unpacker >> new_data_ptr_chandle;       // { bits[5], bits[4] }
    unpacker >> new_resp_stat;              // bits[6]
    unpacker >> new_byte_en_len;            // bits[7]
    unpacker >> new_byte_en_ptr_chandle;    // { bits[9], bits[8] }
    unpacker >> new_streaming_width;        // bits[10]

    t.set_address(new_addr);
    t.set_command((tlm::tlm_command)(new_cmd));
    t.set_data_length(new_data_len);
    t.set_byte_enable_length(new_byte_en_len);
    t.set_streaming_width(new_streaming_width);

    // if( scenario (2) uvmc_DOES_OWN_trans in diagram in uvmc_xl_converter.h )
    //     It's an inbound transaction which UVMC layer has freshly allocated
    //     (and owns) and therefore all TLM GP fields must be updated.
    if( unpacker.does_uvmc_own_trans() ) {

        // NOTE: We've played a trick here where SV data pointers
        // are literally passed by reference (for speed and efficiency).
        // See how this is done in uvmc_tlm_gp_converter_pkg.sv
        // which implements the SV-side converters which call
        // the UVMC_CONV_SV2C*() helper functions above.
        t.set_data_ptr((unsigned char *)new_data_ptr_chandle);
        t.set_byte_enable_ptr((unsigned char *)new_byte_en_ptr_chandle);
    }

    // else scenario (4) in diagram in uvmc_xl_converter.h
    //     Copy data payload only if read op.
    else { // Scenario (4) uvmc_DOES_NOT_own_trans

        // In this version we bypass this optimization - use uvmc_xl_converter
        // if you want it. This one transfers all fields unconditionally
        // (and usually unecessarily as per TLM-2.0 2009 base protocol
        // "modifiabily of attributes" semantics !). See comments in
        // uvmc_tlm_gp_converter.h for more details.
        // if( read op ) Copy data back directly from SV array ref ...
        //if( t.is_read() )

            // Copy data back to target ...
            memcpy( t.get_data_ptr(),
                (void *)new_data_ptr_chandle, new_data_len );

#ifdef VCS_OR_NCSC
        UVMC_CONV_SV2C_free_duplicated_storage( (unsigned long long)
            new_data_ptr_chandle );
        UVMC_CONV_SV2C_free_duplicated_storage( (unsigned long long)
            new_byte_en_ptr_chandle );
#endif
    }

    // Update response status no matter what.
    t.set_response_status((tlm::tlm_response_status)(new_resp_stat));
}
