//============================================================================
// @(#) $Id: uvmc_xl_converter.cpp 1272 2014-12-03 21:16:40Z jstickle $
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

#include "uvmc_xl_converter.h"

#ifdef VCS_OR_NCSC
// Search for VCS, NCSC comments below for why this map<> is needed for VCS,IUS
// modes only.
static map<unsigned char *, bool> xl_duplicated_storage_map;
#endif

#define IS_CONFIG_EXTENSIONS_ENABLED
#ifdef IS_CONFIG_EXTENSIONS_ENABLED
#include "uvmc_xl_config.h"
#endif // IS_CONFIG_EXTENSIONS_ENABLED

//----------------------------------------------------------------------------
// DPI-C import "C-assist" helper functions
//
// The following UVMC_XL_CONV_SV2C functions assist in providing
// "pass-by-reference" handling and "turbo boost" for performing certain copy
// operations between C and SV arrays.
//----------------------------------------------------------------------------

extern "C" {

void  UVMC_XL_CONV_SV2C_copy_c2sv_array(
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

void  UVMC_XL_CONV_SV2C_copy_c2sv_int_array(
    unsigned num_bytes,
    unsigned long long src_c_array_chandle,
    const svOpenArrayHandle dst_sv_array_handle )
{
    memcpy( svGetArrayPtr(dst_sv_array_handle), (void *)src_c_array_chandle,
        num_bytes );
}

void  UVMC_XL_CONV_SV2C_convert_array_ref_to_chandle(
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

void  UVMC_XL_CONV_SV2C_convert_int_array_ref_to_chandle(
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
// For VCS, IUS specifically, there seems to be circumstances in which the
// bitstream stored chandle derived from the SV-side svOpenArrayHandle using
// the DPI utlity function, svGetArrayPtr() above looses its validity from the
// point in execution when it was created in uvmc_tlm_gp_converter::m_pre_pack()
// on the SV-side to the point when we reach uvmc_tlm_gp_converter::do_unpack()
// below where we need the pointer. So for now we cannot take advantage of this
// optimization (Synopsys,Cadence folks can you help out here ? Would be nice
// to optimize this like the other platform). Most ideally, and efficiently we
// should be able to directly use the chandle above in downstream code).
//
// So what we do instead is duplicate the storage on the heap
// and free it downstream when we're done with it (groan !). See
// UVMC_XL_CONV_SV2C_copy_c2sv_array() above where we free it. Basically
// we know to free it is there's a match in an stl::map<>.

void UVMC_XL_CONV_SV2C_duplicate_array_ref_to_chandle(
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
    xl_duplicated_storage_map[duplicated_storage] = true;

    dst_sv_array_chandle[0] = chandle_caster.bitVecRep[0];
    dst_sv_array_chandle[1] = chandle_caster.bitVecRep[1];
}

void UVMC_XL_CONV_SV2C_duplicate_int_array_ref_to_chandle(
    const svOpenArrayHandle src_sv_array_handle,
    svBitVecVal *dst_sv_array_chandle )
{
    union {
        svBitVecVal bitVecRep[2];
        void *chandle;
    } chandle_caster;

    chandle_caster.chandle = svGetArrayPtr(src_sv_array_handle);

    int num_bytes = svSize( src_sv_array_handle, 1 ) * sizeof( unsigned );
    unsigned char *duplicated_storage = new unsigned char[num_bytes];
    memcpy( duplicated_storage, chandle_caster.chandle, num_bytes );

    chandle_caster.chandle = duplicated_storage;
    xl_duplicated_storage_map[duplicated_storage] = true;

    dst_sv_array_chandle[0] = chandle_caster.bitVecRep[0];
    dst_sv_array_chandle[1] = chandle_caster.bitVecRep[1];
}

void UVMC_XL_CONV_SV2C_free_duplicated_storage(
    unsigned long long c_array_chandle )
{
    // See VCS, NCSC comments in
    // UVMC_XL_CONV_SV2C_convert_array_ref_to_chandle() below
    // for why this is needed. Here we free the temporarily duplicated data
    // pointer storage if applicable, now that we're done with it.
    if( c_array_chandle != 0 ){
        unsigned char *duplicated_storage = (unsigned char *)c_array_chandle;
        map<unsigned char *, bool>::iterator it =
            xl_duplicated_storage_map.find( duplicated_storage );
//      assert( it != xl_duplicated_storage_map.end() );

        if( it != xl_duplicated_storage_map.end() && it->second == true ){
            it->second = false;
            delete [] duplicated_storage;
        }
    }
}
#endif // } VCS_OR_NCSC

};

//_________________________                                    _______________
// class uvmc_xl_converter \__________________________________/ johnS 5-7-2012
//----------------------------------------------------------------------------

//---------------------------------------------------------
// ::do_pack()                               johnS 5-7-2012
//---------------------------------------------------------

void uvmc_xl_converter<tlm_generic_payload>::do_pack(
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

#ifdef IS_CONFIG_EXTENSIONS_ENABLED
    {   uvmc_xl_config *config_extension;
        unsigned config_num_bytes = 0;

        // Here we check for config extensions ...
        t.get_extension( config_extension );
        if( config_extension ){
            unsigned char *config_data_ptr;

            // We got one ! Determine if static or sideband ...
            if( data_len == 0 ) {
                // Static configs if data_len == 0 ...
                config_num_bytes
                    = config_extension->get_static_config_num_bytes();
                config_data_ptr = config_extension->get_raw_static_config();
            }
            else {
                config_num_bytes
                    = config_extension->get_sideband_config_num_bytes();
                config_data_ptr
                    = config_extension->get_raw_sideband_config();
            }

            // if( this transaction and extension owned by UVMC infrastructure )
            //     if( query, a.k.a. is_read() ) Transfer data contents back
            //     Then clear the config extension it and delete it.
            if( packer.does_uvmc_own_trans() ) {

                (const_cast<tlm_generic_payload &>(t)).clear_extension(
                    config_extension );
                delete config_extension;
            }

            // Here we just pass the config data "by reference"
            // using its "chandle".
            packer << config_num_bytes; // bits[11]
            packer << (unsigned long long)(void *)config_data_ptr;
                // bits[13], bits[12]
        }
        else packer << config_num_bytes; // bits[11]
    }
#endif // IS_CONFIG_EXTENSIONS_ENABLED
}

//---------------------------------------------------------
// ::do_unpack()                             johnS 5-7-2012
//---------------------------------------------------------

void uvmc_xl_converter<tlm_generic_payload>::do_unpack(
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

    // if( scenario (2) uvmc_DOES_OWN_trans in diagram in uvmc_xl_converter.h )
    //     It's an inbound transaction which UVMC layer has freshly allocated
    //     (and owns) and therefore all TLM GP fields must be updated.
    if( unpacker.does_uvmc_own_trans() ) {

        t.set_address(new_addr);
        t.set_command((tlm::tlm_command)(new_cmd));
        t.set_data_length(new_data_len);
        t.set_byte_enable_length(new_byte_en_len);
        t.set_streaming_width(new_streaming_width);

        // NOTE: We've played a trick here where SV data pointers
        // are literally passed by reference (for speed and efficiency).
        // See how this is done in uvmc_xl_converter_pkg.sv
        // which implements the SV-side converters which call
        // the UVMC_XL_CONV_SV2C*() helper functions above.
        t.set_data_ptr((unsigned char *)new_data_ptr_chandle);
        t.set_byte_enable_ptr((unsigned char *)new_byte_en_ptr_chandle);
    }

    // else scenario (4) in diagram in uvmc_xl_converter.h
    //     Sanity check values against fields in t.
    //     Copy data payload only if read op.
    else { // Scenario (4) uvmc_DOES_NOT_own_trans
// Comment define for speed, uncomment for safety.
//#define UVMC_XL_CONV_CHECK_SANITY
#ifdef UVMC_XL_CONV_CHECK_SANITY
        if(     t.get_address()            != new_addr             ||
                t.get_command()            != tlm_command(new_cmd) ||
                t.get_data_length()        != new_data_len         ||
                t.get_byte_enable_length() != new_byte_en_len      ||
                t.get_streaming_width()    != new_streaming_width  )

            warning_inconsistent_tlm_gp(
                "uvmc_xl_converter<>::do_unpack()", __LINE__, __FILE__ );
#endif // UVMC_XL_CONV_CHECK_SANITY

        // if( read op ) Copy data back directly from SV array ref ...
        if( t.is_read() )
            // Copy data back to target ...
            memcpy( t.get_data_ptr(),
                (void *)new_data_ptr_chandle, new_data_len );

#ifdef VCS_OR_NCSC
        UVMC_XL_CONV_SV2C_free_duplicated_storage( (unsigned long long)
            new_data_ptr_chandle );
        UVMC_XL_CONV_SV2C_free_duplicated_storage( (unsigned long long)
            new_byte_en_ptr_chandle );
#endif
    }

#ifdef IS_CONFIG_EXTENSIONS_ENABLED
    {   unsigned int new_config_num_bytes;
        unsigned long long new_config_data_ptr_chandle;

        unpacker >> new_config_num_bytes; // bits[11]

        if( new_config_num_bytes ){
            uvmc_xl_config *config_extension;

            unpacker >> new_config_data_ptr_chandle; // { bits[13], bits[12] }

            // if( scenario (2) uvmc_DOES_OWN_trans )
            //     Create a config extension and attach it ...
            if( unpacker.does_uvmc_own_trans() ) {
 
                t.set_command((tlm::tlm_command)(new_cmd));

                // We got one ! Determine if static or sideband ...
                config_extension = new uvmc_xl_config(0,0);
                if( new_data_len == 0 ) {
                    // Static configs if data_len == 0 ...
                    config_extension->set_static_config_num_bytes(
                        new_config_num_bytes );
                    config_extension->set_raw_static_config(
                        (unsigned char *)new_config_data_ptr_chandle );
                }
                else {
                    // Sideband configs if data_len > 0 ...
                    config_extension->set_sideband_config_num_bytes(
                        new_config_num_bytes );
                    config_extension->set_raw_sideband_config(
                        (unsigned char *)new_config_data_ptr_chandle );
                }
                t.set_extension( config_extension );
            }
            else { // Scenario (4) uvmc_DOES_NOT_own_trans
                // Static configs beging queried if data_len == 0 ...
                t.get_extension( config_extension );
//              assert( config_extension ); // Internal error if NULL.

                if( new_data_len == 0 ) {
                    if( t.is_read() ) {
                        // if( static config query )
                        //     Copy sideband or static config data back into
                        //     original config extension.

//                      assert( new_config_num_bytes ==
//                          config_extension->get_static_config_num_bytes() );
//                              // Internal error if sizes don't match.
                        memcpy( config_extension->get_raw_static_config(),
                            (void *)new_config_data_ptr_chandle,
                            new_config_num_bytes );
                    }
                }
                // Sideband configs ...
                //   Copy sideband configs back unconditionally (as per
                //   TLM GP "modiability of attributes" rules in 1666 LRM)
                else
                    memcpy( config_extension->get_raw_sideband_config(),
                        (void *)new_config_data_ptr_chandle,
                        new_config_num_bytes );
#ifdef VCS_OR_NCSC
                UVMC_XL_CONV_SV2C_free_duplicated_storage( (unsigned long long)
                    new_config_data_ptr_chandle );
#endif
            }
        }
    }
#endif // IS_CONFIG_EXTENSIONS_ENABLED

    // Update response status no matter what.
    t.set_response_status((tlm::tlm_response_status)(new_resp_stat));
}
