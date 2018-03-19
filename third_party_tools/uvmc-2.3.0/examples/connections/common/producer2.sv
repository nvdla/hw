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
// Title: Another SV producer
//
// Topic: Description
//
// A simple SV producer TLM model that generates a configurable number of
// ~uvm_tlm_generic_payload~ transactions. The model uses the TLM2
// blocking interface, whose semantic guarantees the transaction is fully
// completed upon return from the ~b_transport~ call. Thus, we can reuse the
// transaction each iterationi and need only allocate the transaction once.
//
// Instead of a port, an initiator socket could have been used. To do this,
// comment-out the current declaration for ~out~ and uncomment the socket
// declaration. Of course, any connected to the new ~out~ port must now be
// compatible with the ~b_inititator_socket~.
//
// Normally, a monitor, not the producer, emits observed transactions 
// through an analysis port.
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

   //uvm_tlm_b_initiator_socket #() out;
   uvm_tlm_b_transport_port #(uvm_tlm_gp) out;
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
      uvm_config_db #(uvm_bitstream_t)::get(this,"","num_trans",num_trans);

      // Iterate N times, randomizing transaction, setting delay
      for (int i = 0; i < num_trans; i++) begin

        delay.set_abstime(10,1e-9);
        assert(gp.randomize() with { gp.m_byte_enable_length == 0;
                                     gp.m_length inside {[1:8]};
                                     gp.m_data.size() == m_length; } );
        `uvm_info("PRODUCER/PKT/SEND",{"\n",gp.sprint()},UVM_MEDIUM)

        // Send to analysis
	out.b_transport(gp,delay);
        if (gp.get_response_status() == UVM_TLM_COMPLETED)
          ap.write(gp);
      end
      #100;
      `uvm_info("PRODUCER/END_TEST",
                "Dropping objection to ending the test",UVM_LOW)
      phase.drop_objection(this);
   endtask

endclass
