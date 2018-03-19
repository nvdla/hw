//============================================================================
// @(#) $Id: uvmc_xl_converter.svh 1259 2014-11-29 21:16:42Z jstickle $
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

`ifndef _uvmc_xl_converter_svh_
`define _uvmc_xl_converter_svh_

`define IS_CONFIG_EXTENSIONS_ENABLED

// Define compound macro for VCS || INCA
`ifdef VCS
`define VCS_OR_INCA
`endif

`ifdef INCA
`define VCS_OR_INCA
`endif

//----------------------------------------------------------------------------
// DPI-C import "C-assist" helper functions
//
// The following UVMC_XL_CONV_SV2C functions provide "turbo boost" for performing
// certain copy operations between C and SV arrays.
//----------------------------------------------------------------------------

import "DPI-C" function void UVMC_XL_CONV_SV2C_copy_c2sv_array(
    int unsigned num_bytes,
    longint unsigned src_c_array_chandle,
    inout byte unsigned dst_sv_array[] );

import "DPI-C" function void UVMC_XL_CONV_SV2C_copy_c2sv_int_array(
    int unsigned num_bytes,
    longint unsigned src_c_array_chandle,
    inout int unsigned dst_sv_array[] );

import "DPI-C" function void UVMC_XL_CONV_SV2C_convert_array_ref_to_chandle(
    input byte unsigned src_sv_array[],
    inout bit [63:0] dst_c_array_chandle );

import "DPI-C" function void UVMC_XL_CONV_SV2C_convert_int_array_ref_to_chandle(
    input int unsigned src_sv_array[],
    inout bit [63:0] dst_c_array_chandle );

`ifdef VCS_OR_INCA
import "DPI-C" function void UVMC_XL_CONV_SV2C_duplicate_array_ref_to_chandle(
    input byte unsigned src_sv_array[],
    inout bit [63:0] dst_c_array_chandle );

import "DPI-C" function void UVMC_XL_CONV_SV2C_duplicate_int_array_ref_to_chandle(
    input int unsigned src_sv_array[],
    inout bit [63:0] dst_c_array_chandle );

import "DPI-C" function void UVMC_XL_CONV_SV2C_free_duplicated_storage(
    longint unsigned c_array_chandle );
`endif // VCS_OR_INCA

//________________________________                             _______________
// class uvmc_xl_tlm_gp_converter \___________________________/ johnS 5-7-2012
//
// Converts an object of type uvm_tlm_generic_payload to/from the canonical
// type using the uvm_packer. 
//
// Because this converter operates specifically on transactions of
// class uvm_tlm_generic_payload, dedicated packer/unpacker operations can
// be done that bypass some of the overhead of using a more general
// approach for all uvm_objects that make use of the field automation
// macros.
//
// Consider this the 'XLerated' version of a uvmc_converter specifically
// tuned for TLM2 generic payloads. While this converter was originally
// designed to target acceleration and emulation applications, it also has
// the side benefit of signficantly improving pure simulation performance
// by as much as 10X in pure transaction communication performance as well
// and should be considered for that reason as a higher performing alternative
// to the default UVMC converters that come with the UVMC release and make
// use of the field automation macros.
//
// Specifically, all the integer and enum fields of the generic payloads
// are deserialized (unpacked) and serialized (packed) in a way similar
// to the original versions - although more directly and without use
// of the field automation macros.
//
// However for data payloads and byte enables, copy operations are made quite
// a bit more efficient by using "C assist". More importantly, the payload
// itself *is not* contained in the canonical bitstream. Rather, only 'chandles'
// or references to the payload are carried in the bitstream. In addition
// to a significant performance improvement, this has the added benefit
// that it avoids having a limited statically sized bitstream that requires
// a globally specified maximum size that must be able to accommodate
// both fix sized members of generic payloads and any possible variable data
// payload itself that must be carried over the link.
//
// Furthermore, it takes better advantage of 'pass by reference' semantics
// which is one of the strengths of the TLM-2.0 standard in the first place
// and one of the primary reasons the SystemC version is so high performing.
//
// Also, see important information in the SystemC-side counterpart to this
// class, in uvmc_xl_converter.h regarding special assumptions being
// made in the implementation of the ::do_unpack() call.
//------------------------------------------------------------------------

class uvmc_xl_tlm_gp_converter; // {

    //---------------------------------------------------------
    // ::do_pack()                               johnS 5-7-2012
    //
    // Convert an object of type uvm_tlm_generic_payload to the canonical
    // bitstream representation type bits_t.
    //
    // Well, actually for the XLerated TLM-GP converter this function does
    // nothing. It's all done in the m_post_pack(). See comments below for
    // why this is.
    //---------------------------------------------------------

    static function void do_pack(uvm_tlm_generic_payload t, uvm_packer packer);
//      if (t == null)
//          `uvm_fatal("UVMC",
//               "Null transaction handle passed to uvmc_xl_tlm_gp_converter::do_pack")
// The original way of doing it (please don't do this) ...
//      t.__m_uvm_field_automation(null, UVM_PACK, "");
//      t.do_pack(packer);

        // ... now,
        // Do nothing !
    endfunction

    //---------------------------------------------------------
    // ::do_unpack()                             johnS 5-7-2012
    //
    // Unpacks the canonical bitstream representation type bits_t into an
    // object of type uvm_tlm_generic_payload.
    //
    // Well, actually for the XLerated TLM-GP converter this function does
    // nothing. It's all done in the m_pre_unpack(). See comments below for
    // why this is.
    //---------------------------------------------------------

    static function void do_unpack(
            uvm_tlm_generic_payload t, uvm_packer unpacker);

//      if (t == null)
//          `uvm_fatal("UVMC",
//              "Null transaction handle passed to uvmc_xl_tlm_gp_converter::do_unpack")
// The original way of doing it (please don't do this) ...
//      t.__m_uvm_field_automation(null, UVM_UNPACK, "");
//      t.do_unpack(unpacker);

        // ... now,
        // Do nothing !
    endfunction

    //---------------------------------------------------------
    // ::m_pre_pack()                            johnS 5-7-2012
    // ::m_post_pack()
    //
    // In the original class uvmc_default_converter these were methods for
    // retreiving the canonical bitstream from the packer after packing.
    // However, in this high performance version these methods, which
    // are required by higher layers of UVM-connect, are used in a slightly
    // different, more direct way, than using the field automation macros.
    //
    // This totally avoids the expensive data copy operations that had
    // existed in the class uvmc_default_converter() versions.
    //
    // For packing, the entire operation of transferring data in the
    // source transaction to the target canonical bitstream is done
    // in the m_post_pack() method only. This is be because it is only
    // here that you have access to both the bitstream and the
    // source transaction themselves.
    //
    // The do_pack() and m_pre_pack() methods do nothing.
    //---------------------------------------------------------

    static function void m_pre_pack (
            uvm_tlm_generic_payload t, uvm_packer packer);
        // Do nothing !
    endfunction

    //---------------------------------------------------------

    static function void m_post_pack (
        ref bits_t bits, input uvm_tlm_generic_payload t, uvm_packer packer);

        bit [63:0] chandle_vector;

`ifdef IS_CONFIG_EXTENSIONS_ENABLED // {
        uvmc_xl_config_base config_extension;
        int unsigned config_num_bytes = 0;

        // This is not used but apparently needed to trigger the first
        // creation of the instance specific ::ID() of
        // uvmc_xl_config_base extension type so that subsequent $cast()
        // ops used with the ::ID() accessor below do not cause crashes.
        // Something fishy may be going on in the UVM 1.1b library with 
        // 'local static' variables (which::ID() depends on) when used 
        // with Questa. TODO: Get to the bottom of this !
        uvm_tlm_extension_base baseExt
            = t.get_extension(uvmc_xl_config_base::ID());
`endif // } IS_CONFIG_EXTENSIONS_ENABLED

        if (t == null)
            `uvm_fatal("UVMC",
                "Null transaction handle passed to uvmc_xl_tlm_gp_converter::m_post_pack")
        { bits[1], bits[0] } = t.m_address;

        bits[2] = t.m_command;

        bits[3] = t.m_length;
        if( t.m_length > 0 ) begin
`ifdef VCS_OR_INCA // {
            UVMC_XL_CONV_SV2C_duplicate_array_ref_to_chandle(
                t.m_data, chandle_vector );
`else
            // Questa can use direct ref-to-chandle conversions with no
            // duplication required.
            UVMC_XL_CONV_SV2C_convert_array_ref_to_chandle(
                t.m_data, chandle_vector );
`endif // } VCS_OR_INCA
        end
        else chandle_vector = 0;
        { bits[5], bits[4] } = chandle_vector;

        bits[6] = t.m_response_status;

        bits[7] = t.m_byte_enable_length;
        if( t.m_byte_enable_length > 0 ) begin
`ifdef VCS_OR_INCA // {
            UVMC_XL_CONV_SV2C_duplicate_array_ref_to_chandle(
                t.m_byte_enable, chandle_vector );
`else
            UVMC_XL_CONV_SV2C_convert_array_ref_to_chandle(
                t.m_byte_enable, chandle_vector );
`endif // } VCS_OR_INCA
        end
        else chandle_vector = 0;
        { bits[9], bits[8] } = chandle_vector;

        bits[10] = t.m_streaming_width;

`ifdef IS_CONFIG_EXTENSIONS_ENABLED // {
        // Here we check for config extensions ...
        config_num_bytes = 0;
        $cast( config_extension, t.get_extension(uvmc_xl_config_base::ID()) );
        if( config_extension != null ) begin // {
            bit [63:0] configDataPtr;

            // We got one ! Determine if static or sideband ...
            if( t.m_length == 0 ) begin // { Static config if data_len == 0
                // Static configs if data_len == 0 ...
                config_num_bytes =
                    config_extension.get_static_config_num_bytes();
`ifdef VCS_OR_INCA // {
                UVMC_XL_CONV_SV2C_duplicate_int_array_ref_to_chandle(
                    config_extension.m_static_config.m_data_array,
                    configDataPtr );
`else
                UVMC_XL_CONV_SV2C_convert_int_array_ref_to_chandle(
                    config_extension.m_static_config.m_data_array,
                    configDataPtr );
`endif // } VCS_OR_INCA
            end // }
            else begin // {
                // Sideband configs if data_len > 0 ...
                config_num_bytes =
                    config_extension.get_sideband_config_num_bytes();
`ifdef VCS_OR_INCA // {
                UVMC_XL_CONV_SV2C_duplicate_int_array_ref_to_chandle(
                    config_extension.m_sideband_config.m_data_array,
                    configDataPtr );
`else
                UVMC_XL_CONV_SV2C_convert_int_array_ref_to_chandle(
                    config_extension.m_sideband_config.m_data_array,
                    configDataPtr );
`endif // } VCS_OR_INCA
            end // }

            // Here we just pass the config data "by reference"
            // using its "chandle".
            bits[11] = config_num_bytes;
            { bits[13], bits[12] } = configDataPtr;

            // if( "uvmc_owns_trans == 1" )
            if( packer.physical == 0 ) t.clear_extensions();
        end // }
        else bits[11] = config_num_bytes;
`endif // } IS_CONFIG_EXTENSIONS_ENABLED

    if( packer.physical == 0 )
        // Restore to default "uvmc_owns_trans = 0"
        // (see comments about "uvmc_owns_trans" below) ...
        packer.physical = 1;

    endfunction

    //---------------------------------------------------------
    // ::m_pre_unpack()                          johnS 5-7-2012
    // ::m_post_unpack()
    //
    // In the original class uvmc_default_converter these were methods for
    // preloading the canonical bitstream ref into packer before unpacking.
    // However, in this high performance version these methods, which
    // are required by higher layers of UVM-connect, are used in a slightly
    // different, more direct way, than using the field automation macros.
    //
    // This totally avoids the expensive data copy operations that had
    // existed in the class uvmc_default_converter() versions.
    //
    // For unpacking, the entire operation of transferring data in the
    // canonical bitstream to the target transaction itself is done
    // in the m_pre_unpack() method. This is be because it is only
    // here that you have access to both the bitstream and the
    // target transaction themselves.
    //
    // The do_unpack() and m_post_unpack() methods do nothing.
    //---------------------------------------------------------

    static function void m_pre_unpack (
        ref bits_t bits, input uvm_tlm_generic_payload t, uvm_packer unpacker);
    // {
        byte unsigned new_data[];
        byte unsigned new_byte_enable[];

        bit [63:0] new_address = { bits[1], bits[0] };
        uvm_tlm_command_e new_command = uvm_tlm_command_e'(bits[2]);
        int unsigned new_data_len = bits[3];
        longint unsigned new_data_ptr_chandle = {bits[5],bits[4]};
        int unsigned new_byte_enable_len = bits[7];
        longint unsigned new_byte_enable_ptr_chandle = {bits[9],bits[8]};
        int unsigned new_streaming_width = bits[10];

        // This bit is used to indicate if we're in scenario (2) in diagram
        // shown in comments for SystemC-side uvmc_xl_converter.h.
        // 
        // Generally if we see the payload coming from the other side has 
        // non-zero length but that storage has not yet been allocated to
        // contain it, then UVMC infrastructure (a.k.a. interconnect) owns
        // the newly allocated TLM GP trans to be propagated to the
        // downstream target, and and payload storage must be allocated
        // below.
        //
        // On the SystemC side we added a special bit in uvmc_packer to
        // handle this but on the SV side we would have had to change the
        // UVM package since uvm_packer is part of that package. So, rather
        // we infer it wholly within this converter itself.

        bit does_uvmc_own_trans;

`ifdef IS_CONFIG_EXTENSIONS_ENABLED // {
        int unsigned new_config_num_bytes = bits[11];
        longint unsigned new_config_data_ptr;
        uvmc_xl_config_base config_extension;

        $cast( config_extension, t.get_extension(uvmc_xl_config_base::ID()) );

        does_uvmc_own_trans =
            (new_data_len != 0 && t.m_data.size() == 0) ||
            (new_config_num_bytes != 0 && config_extension == null);
`else
        does_uvmc_own_trans = (new_data_len != 0 && t.m_data.size() == 0);
`endif // } IS_CONFIG_EXTENSIONS_ENABLED

        if (t == null)
            `uvm_fatal( "UVMC",
                "Null transaction handle passed to uvmc_xl_tlm_gp_converter::m_pre_unpack()")

        // if( scenario (2) in diagram in SystemC-side uvmc_xl_converter.h )
        //     Assume inbound transaction and update all fields in t.
        if( does_uvmc_own_trans ) begin // {

            // Here we determine if we're in scenario (2) in that diagram.
            // Generally if we see the payload coming from the other side has
            // non-zero length but that storage has not yet been allocated to
            // contain it, then UVMC infrastructure (a.k.a. interconnect) owns
            // the newly allocated TLM GP trans to be propagated to the
            // downstream target, and and payload storage must be allocated
            // below.
            //
            // On the SystemC side we added a special bit in uvmc_packer to
            // handle this but on the SV side we would have had to change the
            // UVM package since uvm_packer is part of that package. So, rather
            // we infer it wholly within this converter itself. We also set
            // the 'physical' bit in the packer to indicate this mode for
            // query during the return path of this transaction.
            //
            // This complexity can potentially be removed in future versions
            // if a better way around this is found.
            //
            // The packer.physical data member is overloaded for filtering to
            // allow converters to query if transaction being unpacked/packed
            // is owned by application or the UVMC infrastructure (for knowing
            // when to allocate/release duplicated storage). The meaning of
            // this overloaded flag can be reinterpreted as,
            //
            //   physical=0 indicates "uvmc_owns_trans=1"
            //   physical=1 indicates "uvmc_owns_trans=0"
            //     (Default init-time setting is physical=1 as per initial value
            //      in standard UVM library, i.e. "does not own trans").
            //
            // Using this flag, as indicated in the comments in uvm_packer.h,
            // allows special filtering. In this particular context of UVMC XL
            // packers, uvmc_xl_tlm_gp_converter itself can query whether the
            // UVMC infrastructure owns the transaction or the application code
            // does and take appropriate action accordingly. Refering to
            // the diagram in ../sc/uvmc_xl_converter.h, in scenarios (2)
            // and (3) UVMC instrastructure owns the transaction. In scenarios
            // (1) and (4), application owns it.
            //
            // Doing it this way restricts this special flag handling to be
            // non-intrustively localized just to class
            // uvmc_xl_tlm_gp_converter without having to get UVMC
            // infrastructure involved, or, worse yet, require mods to the
            // main UVM package.

            unpacker.physical = 0;

            t.m_address = new_address;
            t.m_command = new_command;
            t.m_length = new_data_len;
            t.m_byte_enable_length = new_byte_enable_len;

            if( new_data_len > 0 ) begin
                // Preserve the old data array before updating
                // with the new just in case they're the same !
                new_data = new[new_data_len]; 

                // For read ops this data copy is not necessary ...
                if( t.is_write() )
                    UVMC_XL_CONV_SV2C_copy_c2sv_array(
                        new_data_len, new_data_ptr_chandle, new_data );
                t.m_data = new_data;
            end

            // For read ops byte enable copies are not necessary ...
            if( t.is_write() )
                if( new_byte_enable_len > 0 ) begin
                    new_byte_enable = new[new_byte_enable_len];
                    UVMC_XL_CONV_SV2C_copy_c2sv_array( new_byte_enable_len,
                        new_byte_enable_ptr_chandle, new_byte_enable );
                    t.m_byte_enable = new_byte_enable;
                end

            t.m_streaming_width = new_streaming_width;
        end // }

        // else scenario (4) in diagram in uvmc_xl_converter.h
        //     In this case (except for VCS,IUS mode below) we don't need to do
        //     anything other than possibly the "sanity check" below.
        //     For that we just sanity check values against fields in t.

        else begin // { // else // Scenario (4) uvmc_DOES_NOT_own_trans ...
// Comment `define for speed, uncomment for safety.
//`define UVMC_XL_CONV_CHECK_SANITY
`ifdef UVMC_XL_CONV_CHECK_SANITY
            // Sanity check values against fields in t.
            if(        t.m_address            != new_address         ||
                       t.m_command            != new_command         ||
                       t.m_length             != new_data_len        ||
                       t.m_byte_enable_length != new_byte_enable_len ||
                       t.m_streaming_width    != new_streaming_width )
        
                `uvm_warning( "UVMC",
                    "Inconsistent TLM-GP fields on return path of outbound transaction across UVM-Connect boundary in uvmc_xl_tlm_gp_converter::m_pre_unpack()" );
`endif // UVMC_XL_CONV_CHECK_SANITY

`ifdef VCS_OR_INCA // {
            // For VCS,IUS only, free duplicated C storage here. Search for
            // VCS_OR_INCA comments above and 'VCS,NCSC' comments in
            // uvmc_tlm_gp_converter.cpp for reasons why.
            if( new_data_len != 0 && t.is_read() )
                UVMC_XL_CONV_SV2C_copy_c2sv_array(
                    t.m_length, new_data_ptr_chandle, t.m_data );
            UVMC_XL_CONV_SV2C_free_duplicated_storage( new_data_ptr_chandle );
            UVMC_XL_CONV_SV2C_free_duplicated_storage(
                new_byte_enable_ptr_chandle );
`endif // } VCS_OR_INCA
        end // } // does_uvmc_own_trans

`ifdef IS_CONFIG_EXTENSIONS_ENABLED // {

        if( new_config_num_bytes ) begin // {

            t.m_command = new_command;

            new_config_data_ptr = { bits[13], bits[12] };

            // if( scenario (2) in diagram in SystemC-side uvmc_xl_converter.h,
            //       i.e. this transaction and extension are owned by UVMC
            //       infrastructure )
            //     Create a config extension and attach it ...
            if( does_uvmc_own_trans ) begin // {
                uvmc_xl_config_base new_config_extension = new();

                // We got one ! Determine if static or sideband ...
                if( new_data_len == 0 ) begin
                    // Static configs if data_len == 0 ...
                    new_config_extension.setup( new_config_num_bytes, 0 );

                    UVMC_XL_CONV_SV2C_copy_c2sv_int_array( new_config_num_bytes,
                        new_config_data_ptr,
                        new_config_extension.m_static_config.m_data_array );
                end
                else begin
                    // Sideband configs if data_len > 0 ...
                    new_config_extension.setup( 0, new_config_num_bytes );
                    UVMC_XL_CONV_SV2C_copy_c2sv_int_array( new_config_num_bytes,
                        new_config_data_ptr,
                        new_config_extension.m_sideband_config.m_data_array );
                end
                void'(t.set_extension( new_config_extension ));
            end // }

            // else scenario (4) in diagram in uvmc_xl_converter.h
            //     In this case (except for VCS,IUS mode below) we don't need
            //     to do anything because the data copy was already efficiently
            //     done by reference to target storage by the SC-side packer.

            else begin // { // else !does_uvmc_own_trans ...
`ifdef VCS_OR_INCA // {
                if( new_data_len == 0 && t.is_read )
                    UVMC_XL_CONV_SV2C_copy_c2sv_int_array( new_config_num_bytes,
                        new_config_data_ptr,
                        config_extension.m_static_config.m_data_array );
                UVMC_XL_CONV_SV2C_free_duplicated_storage(
                    new_config_data_ptr );
`endif // } VCS_OR_INCA
            end // }
        end // }
`endif // } IS_CONFIG_EXTENSIONS_ENABLED

        // Update response status no matter what.
        t.m_response_status = uvm_tlm_response_status_e'(bits[6]);

    endfunction // }

    //---------------------------------------------------------

    static function void m_post_unpack (
            uvm_tlm_generic_payload t, uvm_packer unpacker);
        // Do nothing !
    endfunction
endclass // } uvmc_xl_tlm_gp_converter

`endif // _uvmc_xl_converter_svh_
