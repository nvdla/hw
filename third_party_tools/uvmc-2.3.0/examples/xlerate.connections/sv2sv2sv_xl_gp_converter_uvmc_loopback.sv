//============================================================================
// @(#) $Id: sv2sv2sv_xl_gp_converter_uvmc_loopback.sv 1254 2014-11-21 20:12:17Z jstickle $
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

//-----------------------------------------------------------------------------
// Title: UVMC Connection Example - UVMC-based SV to SV
//
// This example shows that you can use UVMC to establish TLM connections between
// any two compatible components, even if they both reside in SV. This further
// demonstrates the principle of designing components independent of their
// context, i.e. how they are connected.
//
// (see UVMC_Connections_SV2SV-native.png)
//
// Connecting SV components via UVM Connect has the same overall effect as
// making a direct, native connection. UVM Connect recognizes that the two
// components both reside in SV and forwards the transaction to the
// connected SV consumer, avoiding the unnecessary overhead of converting to
// bits and back. 
//
// This code in this example is very similar to native connections.
// Compare this example with the <UVMC Connection Example - Native SV to SV>,
// which makes the same connection without UVMC. You might also compare this
// example with the <UVMC Connection Example - SV to SC, SV side> and
// <UVMC Connection Example - SV to SC, SC side> to see how to construct
// a similar testbench where the consumer is implemented in SystemC.
//
// The ~sv_main~ top-level module below creates and starts the SV portion of this
// example. It does the following:
//
// - Creates an instance of a ~producer~ component
//
// - Registers the producer's ~out~ port with UVMC using the string "sv2sv".
//   We don't specify the transaction type as a parameter to ~uvmc_tlm~, so
//   the default ~uvm_tlm_generic_payload~ is chosen.
//
// - Registers the consumer's ~in~ export with UVMC using the same string,
//   "sv2sv". During elaboration, UVMC will connect these ports because their
//   lookup strings match. 
//
// - Calls ~run_test~ to start UVM simulation
//
// TLM connections are normally made in the ~connect_phase~ callback of
// a UVM component. This example does not show that for sake of highlighting
// the UVMC connect functionality.
//
//-----------------------------------------------------------------------------

// (inline source)
import uvm_pkg::*; 
import uvmc_pkg::*;

`include "producer_loopback.svh"
`include "loopback2.svh"

module sv_main;

  producer prod = new("prod");
  loopback loop = new("loop");

  initial begin
    uvmc_tlm #( uvm_tlm_generic_payload,
        uvm_tlm_phase_e, uvmc_xl_tlm_gp_converter ) ::connect(prod.out, "42");
    uvmc_tlm #( uvm_tlm_generic_payload,
        uvm_tlm_phase_e, uvmc_xl_tlm_gp_converter ) ::connect(loop.in,  "42");
    uvmc_tlm #( uvm_tlm_generic_payload,
        uvm_tlm_phase_e, uvmc_xl_tlm_gp_converter ) ::connect(loop.out, "43");
    uvmc_tlm #( uvm_tlm_generic_payload,
        uvm_tlm_phase_e, uvmc_xl_tlm_gp_converter )	::connect(prod.in,  "43");

    run_test();
  end

endmodule
