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
//
// Title: SV Consumer
//
// Topic: Description
//
// A simple SV consumer TLM model that prints received transactions (of type
// ~packet~) and sends them out its ~ap~ analysis port.
//
// Incoming transactions are received via the ~in~ member, a TLM imp port.
// Imps export the consumer's implementation of the ~tlm_blocking_put_if~ 
// interface. Imps are ultimately driven via a port of some external component.
// The port would have the same interface type, i.e. tlm_blocking_put_if~. 
//
// While trivial in functionality, the model demonstrates use of TLM ports
// to facilitate external communication. 
//
// - Users of the model are not coupled to its internal implementation, using
//   only the provided TLM port and imp to communicate.
//
// - The model itself does not refer to anything outside its encapsulated
//   implementation. It does not know nor care about what might
//   be driving its ~in~ member or who might be listening on its ~ap~
//   analysis port.
//-----------------------------------------------------------------------------

// (inline source)
import ovm_pkg::*; 
`include "ovm_macros.svh"
`include "packet.sv"

class consumer extends ovm_component;

   ovm_blocking_put_imp #(packet, consumer) in;
   ovm_analysis_port #(packet) ap; 

   `ovm_component_utils(consumer)
   
   function new(string name, ovm_component parent=null);
      super.new(name,parent);
      in = new("in",  this);
      ap = new("ap", this);
   endfunction

   // task called via 'in' imp
   virtual task put (packet t);
     `ovm_info("CONSUMER/PKT/RECV",{"\n",t.sprint()},OVM_MEDIUM)
     #10ns;
     ap.write(t);
   endtask

endclass

