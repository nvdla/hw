//============================================================================
// @(#) $Id: loopback2.svh 1254 2014-11-21 20:12:17Z jstickle $
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
// Title: SV Consumer
//
// Topic: Description
//
// A simple SV consumer TLM model that prints received transactions (of type
// ~uvm_tlm_generic_payload~ and sends them out its ~ap~ analysis port.
//
// The ~in~ socket exports the ~tlm_blocking_transport_if~ interface
// implemented by this consumer.
//
// While trivial in functionality, the model demonstrates use of TLM ports
// to facilitate external communication. 
//
// - Users of the model are not coupled to its internal implementation, using
//   only the provided TLM port and imp to communicate.
//
// - The model itself does not refer to anything outside its encapsulated
//   implementation. It does not know nor care about what might
//   be driving its ~in~ socket or who might be listening on its ~ap~
//   analysis port.
//-----------------------------------------------------------------------------

// (inline source)
import uvm_pkg::*; 
`include "uvm_macros.svh"

class loopback extends uvm_component;

// uvm_tlm_b_target_socket #(loopback) in;
   uvm_tlm_b_transport_imp #(uvm_tlm_generic_payload, loopback) in;
// uvm_tlm_b_initiator_socket #() out;
   uvm_tlm_b_transport_port #(uvm_tlm_generic_payload) out;


   `uvm_component_utils(loopback)
   
   function new(string name, uvm_component parent=null);
      super.new(name,parent);
      in = new("in",  this);
      out = new("out",  this);
   endfunction

   // task called via 'in' socket, loops back via 'out' socket
   virtual task b_transport (uvm_tlm_gp t, uvm_tlm_time delay);
     out.b_transport( t, delay );
   endtask

endclass
