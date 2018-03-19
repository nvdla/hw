//============================================================================
// @(#) $Id: uvmc_xl_converter.h 1272 2014-12-03 21:16:40Z jstickle $
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

#ifndef _uvmc_xl_converter_h
#define _uvmc_xl_converter_h

#include <iostream>
#include <ostream>
#include <iomanip>
#include <tlm.h>

using std::ostream;
using std::cout;
using std::setw;

#include "uvmc_packer.h"

using namespace uvmc;
using namespace tlm;

namespace uvmc {

//_________________________                                    _______________
// class uvmc_xl_converter \__________________________________/ johnS 5-7-2012
//
// Converter template specialization for tlm_generic_payload
//
// First, see important differences between class uvmc_tlm_gp_converter
// and class uvmc_xl_converter in the comments in uvmc_tlm_gp_converter.h.
// This can be used as a guideline to decide which of the two to use.
//
// Because this converter operates specifically on transactions of
// class tlm_generic_payload, dedicated packer/unpacker operations can
// be optimized for efficient transfers of generic payloads across
// the language or emulator boundary.
//
// Specifically, all the integer and enum fields of the generic payloads
// are deserialized (unpacked) and serialized (packed) in a way similar
// to the original plain class uvmc::uvmc_converter() versions.
//
// However for data payloads and byte enables, copy operations are made quite
// a bit more efficient by passing the data and byte enable payloads directly
// by reference rather than copying into the packer's 'canonical bitstream'
// vector. As such, only the pointer to these payload arrays are passed into
// the packer.
//
// That is, the payload itself *is not* seralized into the canonical bitstream.
// Rather, only 'chandles' or references to the payload are carried in the
// bitstream.
//
// This avoids the entire limitation of having limited size bitstream that
// requires a statically specified global maximum that must be able to
// accommodate both fix sized members of generic payloads and the variable data
// payload itself. Furthermore, it takes better advantage of
// 'pass by reference' semantics which is one of the strengths of the
// TLM-2.0 standard in the first place and the primary reason it is so high
// performing.
//
// This converter also makes certain assumptions in the do_unpack() operation
// which is a bit tricky because do_unpack() is called on the return
// path (see (4) in diagram below) of an outbound transaction going "into" the
// language boundary, but also in the inbound path (forward or backward) of an
// inbound transaction "coming from" the language boundary (see (2) in diagram
// below).
//
// For return paths of outbound transactions (4) you want to only do the
// following as per "modifiability of attributes" semantics of the TLM-2.0
// standard generic payload:
//   a. Update the response status
//   b. Update the return data payload *only if it is a read* otherwise do
//      nothing w/ data payload.
//   c. For all other fields, it is good to sanity check that they match
//      with the original outbound transaction.
//   d. Update the phase and timing annotation if applicable (which is
//      separate from the TLM GP anyway so the packer does not handle this)
//   e. Update the static config extension if applicable (only if it is
//      a read/query* operation)
//   f. Update the sideband config extension if applicable
//
// But for inbound paths of inbound transactions (2) you want copy all the
// fields because it is a locally allocated "empty proxy" TLM GP transaction
// created by, and ~owned by~ UVMC instrstructure, into which the contents of
// the bitstream will be deserialized.
//
// Now here's the tricky part: how do you know if it is the return path
// of an outbound transaction (4) or the forward or backward path of an inbound
// transaction (2) ? There's really no way to know this from within the
// converter itself the way it is currently defined. So for this reason,
// these special accessors had to be added to class uvmc_packer:
//
//    // Accessors added:
//    void uvmc_owns_trans( int enable );
//      UVMC calls this to indicate if it owns (i.e. was original allocator
//      of) the transaction (scenario (2), (3) below) or the application
//      does (scenario (1), (4) below.
//
//   int does_uvmc_own_trans();
//      Packer "application" calls this to query if it owns the transaction
//      (as opposed to UVM owning) and if so, deserialize all fields on
//      inbound transaction unpack operations.
//
//   Required packer logic:
//
//    if( does_uvmc_own_trans() )
//      Assume it was a freshly allocated empty TLM GP transaction
//      in which to deseralize all the fields coming out of the bitstream
//      representation of the inbound transaction coming from the boundary (2).
//    else
//      Assume it is the caller's original TLM GP passed to the outbound
//      fw or bw path operation (1). In this case we only want to update
//      the response status (always) and data payload (if read op only).
//
//                           language
//                           boundary
//                  outbound    |  inbound
//          (1)     (fw or bw)  |  (fw or bw)      (2)
//         pack(t) -----------> | ------------> unpack(t)  - - - - - +
//                              |                                    |
//          (4)       return    |   return         (3)
//       unpack(t) <----------- | <------------ pack(t)    < - - - - +
//
//----------------------------------------------------------------------------
// Platform specific implementations ...
//
// The diagrams below add a bit more detail to the one above showing what
// specific operations are done on each segement of TLM GPs travel through
// the language boundary interconnect, for the various platforms supported,
// namely, Questa, VCS, IUS.
//
// The legend below shows short-hand notations for the operations involved
// which are are implemented as UVMC_XL_CONV_SV2C_*() DPI-C helper functions
// on the SC side.
//
// The operations involve, depending on platform, the following primitve
// operations,
//
// - pass-by-reference, which requires ...
// - ... conversions of SV array refs to C++ ~chandles~
// - data copies of C arrays to SV arrays
// - duplication of SV arrays to C arrays (VCS,IUS only)
// - freeing of duplicated C arrays (VCS,IUS only)
//
// These primitive operations are applied to the relevant data payloads of any
// given TLM GP transaction, depending on whether or not used, namely,
//
// - data payload array
// - byte enable payload array
// - static config payload array (uvmc_xl_converter only)
// - sideband config payload array (uvmc_xl_converter only)
//
// Legend for DPI import "helper functions":
//   CONV_arr_ref_to_chandle -> UVMC_XL_CONV_SV2C_convert_array_ref_to_chandle()
//   COPY_c_to_sv_arr        -> UVMC_XL_CONV_SV2C_copy_c2sv_array()
//
//   DUPL_arr_ref_to_chandle -> UVMC_XL_CONV_SV2C_duplicate_array_ref_to_chandle
//   FREE_duped_storage      -> UVMC_XL_CONV_SV2C_free_duplicated_storage()
//----------------------------------------------------------------------------
//  QUESTA                                         
//  ------
//            SV-side        language        SC-side
//                           boundary
//                  outbound    |  inbound
//          (1)     (fw or bw)  |  (fw or bw)      (2)
//  m_post_pack(t) -----------> | ----------> do_unpack(t) - - - - - +
//  - CONV_arr_ref_to_chandle   |             - direct pass-by-ref   |
//                              |                                    |
//             "App owns trans" | "UVMC owns trans"                  |
//                              |                                    |
//          (4)       return    |   return         (3)               |
//  m_pre_unpack(t) <---------- | <---------  do_pack(t)   < - - - - +
//  - COPY_c_to_sv_arr                        - direct pass-by-ref
//
//
//            SC-side        language        SV-side
//                           boundary
//                  outbound    |  inbound
//          (1)     (fw or bw)  |  (fw or bw)      (2)
//  do_pack(t) ---------------> | ----------> m_pre_unpack(t)  - - - +
//  - direct pass-by-ref        |             - COPY_c_to_sv_arr     |
//                              |                                    |
//             "App owns trans" | "UVMC owns trans"                  |
//                              |                                    |
//          (4)       return    |   return         (3)               |
//  do_unpack(t)  <------------ | <---------  m_post_pack(t) < - - - +
//  - memcpy to target data                   - CONV_arr_ref_to_chandle
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
//  VCS,IUS
//  -------
//            SV-side        language        SC-side
//                           boundary
//                  outbound    |  inbound
//          (1)     (fw or bw)  |  (fw or bw)      (2)
//  m_post_pack(t) -----------> | ----------> do_unpack(t) - - - - - +
//  - DUPL_arr_ref_to_chandle   |             - direct pass-by-ref   |
//                              |             - VCS in place compress|
//             "App owns trans" | "UVMC owns trans"                  |
//                              |                                    |
//          (4)       return    |   return         (3)               |
//  m_pre_unpack(t) <---------- | <---------  do_pack(t)   < - - - - +
//  - COPY_c_to_sv_arr                        - direct pass-by-ref
//  - FREE_duped_storage
//
//
//            SC-side        language        SV-side
//                           boundary
//                  outbound    |  inbound
//          (1)     (fw or bw)  |  (fw or bw)      (2)
//  do_pack(t) ---------------> | ----------> m_pre_unpack(t)  - - - +
//  - direct pass-by-ref        |             - COPY_c_to_sv_arr     |
//                              |                                    |
//             "App owns trans" | "UVMC owns trans"                  |
//                              |                                    |
//          (4)       return    |   return         (3)               |
//  do_unpack(t)  <------------ | <---------  m_post_pack(t) < - - - +
//  - memcpy to target data                   - DUPL_arr_ref_to_chandle
//  - FREE_duped_storage
//----------------------------------------------------------------------------

template <typename T>
class uvmc_xl_converter {

  public:
    static void do_pack(const T &t, uvmc_packer &packer) { t.do_pack(packer); }
    static void do_unpack(T &t, uvmc_packer &unpacker) { t.do_unpack(unpacker); }
};

template <>
class uvmc_xl_converter<tlm_generic_payload> {

  public:
    //---------------------------------------------------------
    // ::do_pack()                               johnS 5-7-2012
    // ::do_unpack()
    //
    // ::do_pack() converts an object of type tlm_generic_payload to the
    // canonical bitstream representation that gets passed across the
    // language boundary to the SV side.
    //
    // ::do_unpack() unpacks the canonical bitstream representation passed
    // from the other size of the language boundary into a local
    // class tlm_generic_payload object.
    //---------------------------------------------------------

    static void do_pack( const tlm_generic_payload &t, uvmc_packer &packer );
    static void do_unpack( tlm_generic_payload &t, uvmc_packer &unpacker );

  private:

    //---------------------------------------------------------
    // Error/warning handlers                   johnS 3-12-2013
    //---------------------------------------------------------
    static void warning_inconsistent_tlm_gp(
        const char *functionName, int line, const char *file )
    {   char messageBuffer[1024];
        sprintf( messageBuffer,
            "Inconsistent TLM-GP fields on return path of outbound transaction "
            "across UVM-Connect boundary in '%s' [line #%d of '%s'].\n",
            functionName, line, file );
        SC_REPORT_WARNING( "WARNING", messageBuffer ); }
};

}; // namespace uvmc

#endif // _uvmc_xl_converter_h
