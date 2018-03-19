//
//------------------------------------------------------------//
//   Copyright 2012 Mentor Graphics Corporation               //
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
// ~packet~ transactions. The model uses the TLM1 blocking put interface,
// whose semantic does not guarantee the transaction is fully completed upon
// return from the ~put~ call. Thus, we must allocate a new transaction
// each iteration.
//
// While trivial in functionality, the model demonstrates use of TLM ports
// to facilitate external communication. 
//
// - All external components receive transactions via a connection via their
//   export or imp port. They do not know or care about what component is
//   producing and sending them the transactions.
//
// - The model itself does not refer to anything outside its encapsulated
//   implementation. It does not know nor care about what might be receiving
//   the transactions in the ~out~ and ~ap~ ports.
//-----------------------------------------------------------------------------

// (inline source)
import ovm_pkg::*; 
`include "ovm_macros.svh"

`include "packet.sv"

class producer extends ovm_component;

   ovm_blocking_put_port #(packet) out;
   ovm_analysis_port #(packet) ap; 

   `ovm_component_utils(producer)
   
   function new(string name, ovm_component parent=null);
      super.new(name,parent);
      out = new("out", this);
      ap = new("ap", this);
   endfunction

   virtual task run();

      // Allocate GP once
      packet pkt = new();
      int num_trans = 2;
      int max_len   = 10;


      // Keep the "run" phase from ending
      ovm_test_done.raise_objection(this);

      // Get number of transactions desired (default=2)
      void'(get_config_int("num_trans",num_trans));

      // Get max length of data array; absolute max is 16
      void'(get_config_int("max_len",max_len));

      `ovm_info("PRODUCER/START",
         $sformatf("Producing %0d packets with max data size of %0d bytes...",
         num_trans,max_len),OVM_LOW)

      // Iterate N times, randomizing transaction
      for (int i = 0; i < num_trans; i++) begin


        assert(pkt.randomize() with { data.size() <= max_len; } );
        `ovm_info("PRODUCER/PKT/SEND",{"\n",pkt.sprint()},OVM_MEDIUM)

        // Send to port for execution (although that is not guaranteed)
	out.put(pkt);

        // Send to analysis
        ap.write(pkt);
      end
      #100;
      `ovm_info("PRODUCER/END_TEST",
                "Dropping objection to ending the test",OVM_LOW)
      ovm_test_done.drop_objection(this);

   endtask

endclass

