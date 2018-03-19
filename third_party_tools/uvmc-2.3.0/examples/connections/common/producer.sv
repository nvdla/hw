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
// Title: UVMC Connection Common Code - SV Producer
//
// Topic: Description
//
// A simple SV producer TLM model that generates a configurable number of
// ~uvm_tlm_generic_payload~ transactions. The model uses the TLM2
// blocking interface, whose semantic guarantees the transaction is fully
// completed upon return from the b_transport call. Thus, we can reuse the
// transaction each iterationi and need only allocate the transaction once.
//
// This example uses the ~uvm_tlm_b_initiator_socket~, which only uses the
// ~b_transport~ TLM interface. It's default transaction type is the
// ~uvm_tlm_generic_payload~, which is what this example uses. 
//
// Normally, a monitor, not the producer, emits observed transactions 
// through an analysis port. We use the analysis port here only to illustrate
// external connectivity.
//
// While trivial in functionality, the model demonstrates use of TLM ports
// to facilitate external communication. 
//
// - Users of the model are not coupled to its internal implementation, using
//   only the provided TLM port and socket to communicate.
//
// - The model itself does not refer to anything outside its encapsulated
//   implementation. It does not know nor care about what might
//   be driving its ~in~ socket or who might be listening on its ~ap~
//   analysis port.
//-----------------------------------------------------------------------------

// (inline source)
import uvm_pkg::*; 
`include "uvm_macros.svh"

class producer extends uvm_component;

   uvm_tlm_b_initiator_socket #() out;
   uvm_analysis_port #(uvm_tlm_gp) ap; 

   `uvm_component_utils(producer)
   
   function new(string name, uvm_component parent=null);
      super.new(name,parent);
      out = new("out", this);
      ap = new("ap", this);
   endfunction

   task run_phase (uvm_phase phase);

      // Allocate GP once
      uvm_tlm_gp gp = new;
      uvm_tlm_time delay = new("del",1e-12);
      int num_trans = 2;

      // Keep the "run" phase from ending
      phase.raise_objection(this);

      // Get number of transactions desired (default=2)
      void'(uvm_config_db #(uvm_bitstream_t)::get(this,"","num_trans",num_trans));

      // Iterate N times, randomizing transaction, setting delay
      for (int i = 0; i < num_trans; i++) begin

        delay.set_abstime(10,1e-9);
        assert(gp.randomize() with { gp.m_byte_enable_length == 0;
                                     gp.m_length inside {[1:8]};
                                     gp.m_data.size() == m_length; } );
        `uvm_info("PRODUCER/PKT/SEND",{"\n",gp.sprint()},UVM_MEDIUM)

	out.b_transport(gp,delay);
        ap.write(gp);
      end
      #100;
      `uvm_info("PRODUCER/END_TEST",
                "Dropping objection to ending the test",UVM_LOW)
      phase.drop_objection(this);
   endtask

endclass
