//
//------------------------------------------------------------//
//   Copyright 2009-2012 Mentor Graphics Corporation          //
//   All Rights Reserved Worldwid                             //
//                                                            //
//   Licensed under the Apache License, Version 2.0 (the      //
//   "License"); you may not use this file except in          //
//   compliance with the License.  You may obtain a copy of   //
//   the License at                                           //
//                                                            //
//       http://www.apache.org/licenses/LICENSE-2.0           //
//                                                            //
//   Unless required by applicable law or agreed to in        //
//   writing, software distributed under the License is       //
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR   //
//   CONDITIONS OF ANY KIND, either express or implied.  See  //
//   the License for the specific language governing          //
//   permissions and limitations under the License.           //
//------------------------------------------------------------//

//-----------------------------------------------------------------------------
// Title: UVMC Connection Common Code - SV Consumer
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


class consumer extends uvm_component;

   uvm_tlm_b_target_socket #(consumer) in;
   uvm_analysis_port #(uvm_tlm_generic_payload) ap; 

   `uvm_component_utils(consumer)
   
   function new(string name, uvm_component parent=null);
      super.new(name,parent);
      in = new("in",  this);
      ap = new("ap", this);
   endfunction

   // task called via 'in' socket
   virtual task b_transport (uvm_tlm_gp t, uvm_tlm_time delay);
     `uvm_info("CONSUMER/PKT/RECV",{"\n",t.sprint()},UVM_MEDIUM)
     #(delay.get_realtime(1ns,1e-9));
     delay.reset();
     ap.write(t);
   endtask

endclass
