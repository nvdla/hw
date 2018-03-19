//============================================================================
// @(#) $Id: uvmc_tlm_gp_converter.h 1234 2014-07-15 04:56:14Z jstickle $
//============================================================================

   //_______________________
  // Mentor Graphics, Corp. \_________________________________________________
 //                                                                         //
//   (C) Copyright, Mentor Graphics, Corp. 2003-2013                        //
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

#ifndef _uvmc_tlm_gp_converter_h
#define _uvmc_tlm_gp_converter_h

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

//_____________________________                                _______________
// class uvmc_tlm_gp_converter \______________________________/ johnS 5-7-2012
//
// See important comments in uvmc_xl_converter.h that also apply to this
// variation of uvmc_converter.
//
// The difference between class uvmc_tlm_gp_converter and class
// uvmc_xl_converter is described as follows:
//
//  1. class uvmc_xl_converter (see uvmc_xl_converter.h)
//
//    This version conforms in the strictest sense to the TLM-2.0
//    base protocol and does not indiscriminately transfer all
//    fields of the generic payload in both directions across
//    the language boundary. Rather it decides, depending on the
//    mode of the transaction (READ or WRITE), and whether it is
//    being transferred along the forward, backward, or return
//    paths, which fields to transfer and which to leave alone.
//
//    These semantics adhere strictly to the "Default values
//    and modifiability of attributes" rules depicted in
//    the table in section 7.7 of the TLM-2009-07-15 LRM.
//
//    For example WRITE transactions do not need to have the
//    address, data, length, enables and control fields transferred
//    long the return path - only the status.
//
//    READ transactions also do not need address, length, enables,
//    transferred along the return path, only data and status.
//    And furthermore for READs data does *not* need to be transferred
//    along the forward/backward path (only return path).
//
//    These fine-tuned optimizations collectively have maximized our
//    performance purely at the communication layers of the
//    TLM fabric.
//
//  2. class uvmc_tlm_gp_converter
//
//    This version has the same features of "unlimited payload size"
//    and efficient data payload passing techniques that use "C assist"
//    and "pass by reference" that version #1 above does, but it is
//    unconditionally transferring all fields of the generic payload along
//    all paths without regard to "modifiability of attributes".
//
// Both versions have been shown to be useful and considered essential
// in different usage contexts.
//----------------------------------------------------------------------------

class uvmc_tlm_gp_converter {

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
};

}; // namespace uvmc

#endif // _uvmc_tlm_gp_converter_h
