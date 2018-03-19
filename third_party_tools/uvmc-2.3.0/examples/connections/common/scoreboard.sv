//
//------------------------------------------------------------//
//   Copyright 2009-2012 Mentor Graphics Corporation          //
//   Copyright 2012 Synopsys, Inc                             //
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
// CLASS: UVMC Connection Common Code - SV Scoreboard
//
// Topic: Description
//
// A simple SV scoreboard TLM model that collects expected transactions from
// its ~expect_in~ analysis imp and compares them with actual transactions
// received from its ~actual_in~ analysis imp.
//
// The model makes use of the ~uvm_analysis_imp_decl~ macros to allow the
// scoreboard to directly implement more than one analysis interface (the
// expected and the actual).
//
// The ~write_expect~ implementation clones the incoming expect
// transaction because the producer may reuse the transaction object in
// subsequent iterations. It then prints the transaction before storing
// it in the internal queue. 
//
// The ~write_actual~ implementation also makes a clone of the incoming
// actual transaction. We do not do on-the-fly comparison because the
// corresponding expect transaction may not have arrived yet, and we
// can't hold onto the handle because the underlying object may be
// changed or reused before we've had a chance to compare it.
//
// This approach to scoreboard design affords several benefits over
// use of ~tlm_fifo #(T)~ on the expect side:
//
// - consumes less memory. The queue is a primitive data type, whereas the
//   tlm_fifo is composed of several class objects including the storage
//   (mailbox) and the TLM exports, which are themselves composed of
//   other objects.
//
// - the queue can be searched in cases where out-of-order arrival of
//   actuals is permitted. The tlm_fifo can not.
//
// - the ~write_expect~ and ~write_actual~ methods provide a means of
//   pre-qualifying the incoming transactions before putting them into
//   their respective queues for later comparison.
//
// Although not done here, the scoreboard model might employ a timeout
// mechanism so it does not prevent the run phase from ending indefinitely.
//
// While trivial in functionality, the model demonstrates use of TLM ports
// to facilitate external communication. 
//
// - Users of the model are not coupled to its internal implementation, using
//   only the provided TLM analysis imps to communicate.
//
// - The model itself does not refer to anything outside its encapsulated
//   implementation. It does not know nor care about what might
//   analysis port.
//-----------------------------------------------------------------------------

// (inline source)
import uvm_pkg::*; 
`include "uvm_macros.svh"

`uvm_analysis_imp_decl(_expect)
`uvm_analysis_imp_decl(_actual)

class scoreboard extends uvm_component;

   uvm_tlm_gp qe[$];
   uvm_tlm_gp qa[$];

   uvm_analysis_imp_expect #(uvm_tlm_gp,scoreboard) expect_in;
   uvm_analysis_imp_actual #(uvm_tlm_gp,scoreboard) actual_in; 

   `uvm_component_utils(scoreboard)

   uvm_comparer comparer;
   bit raised_bit; 
   uvm_phase run_ph;

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
      expect_in = new("expect_in", this);
      actual_in = new("actual_in", this);
      run_ph = uvm_run_phase::get();
   endfunction : new

   function void build_phase(uvm_phase phase);
      if (comparer == null)
        comparer = new;
      comparer.show_max = 100;
   endfunction

   virtual function void write_expect(uvm_tlm_gp t);
     uvm_tlm_gp t_copy;
     $cast(t_copy,t.clone());
     `uvm_info("SB/EXPECT/RECV",{"\n",t.sprint()},UVM_MEDIUM)
     qe.push_back(t_copy);
     if (!raised_bit) begin
       run_ph.raise_objection(this,"expect received, waiting for actual");
       raised_bit = 1;
     end
   endfunction

   virtual function void write_actual(uvm_tlm_gp t);
     uvm_tlm_gp t_copy;
     $cast(t_copy,t.clone());
     `uvm_info("SB/ACTUAL/RECV",{"\n",t.sprint()},UVM_MEDIUM)
     qa.push_back(t_copy);
     if (!raised_bit) begin
       run_ph.raise_objection(this,"actual received, waiting for expect");
       raised_bit = 1;
     end
   endfunction

   virtual task run_phase(uvm_phase phase);
     uvm_tlm_gp e,a;

     // wait for both sides to deliver
     forever begin
       @(qa.size() && qe.size());

       e = qe.pop_front();
       a = qa.pop_front();

       if (!a.compare(e))
         `uvm_error("SB/MISCOMPARE",
           $sformatf("%m: There were %0d miscompares:\nexpect=%s\nactual=%s",
             comparer.result,e.sprint(),a.sprint()))
     
       if (raised_bit && !qa.size() && !qe.size()) begin
         phase.drop_objection(this,"all packets matched; queues are empty");
         raised_bit = 0;
       end
     
     end

   endtask

endclass
