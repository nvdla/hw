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
// Title: UVMC Converter Common Code - SV Producer
//
// Topic: Description
// A generic producer parameterized on transaction type. Used to illustrate
// different converter options using the same producer class.
//-----------------------------------------------------------------------------

// (inline source)
class producer #(type T=int) extends uvm_component;

   uvm_tlm_b_transport_port #(T) out; 

   int num_pkts;

   `uvm_component_param_utils(producer #(T))
   
   function new(string name, uvm_component parent=null);
      super.new(name,parent);
      out = new("out", this);
      num_pkts = 10;
   endfunction : new

   task run_phase (uvm_phase phase);
     uvm_tlm_time delay = new("delay",1.0e-12);

     phase.raise_objection(this);

     for (int i = 1; i <= num_pkts; i++) begin

       int unsigned exp_addr;
       byte exp_data[$];

       T pkt = new(); //$sformatf("packet%0d",i));
       assert(pkt.randomize());
       delay.set_abstime(1,1e-9);

       exp_addr = ~pkt.addr;
       foreach (pkt.data[i])
         exp_data[i] = ~pkt.data[i];

       `uvm_info("PRODUCER/PKT/SEND_REQ",
          $sformatf("SV producer request:\n   %s", pkt.convert2string()), UVM_MEDIUM)

       out.b_transport(pkt,delay);

       `uvm_info("PRODUCER/PKT/RECV_RSP",
          $sformatf("SV producer response:\n   %s\n", pkt.convert2string()), UVM_MEDIUM)

       if (exp_addr != pkt.addr)
         `uvm_error("PRODUCER/PKT/RSP_MISCOMPARE",
            $sformatf("SV producer expected returned address to be %h, got back %h",
                    exp_addr,pkt.addr))

       if (exp_data != pkt.data)
         `uvm_error("PRODUCER/PKT/RSP_MISCOMPARE",
            $sformatf("SV producer expected returned data to be %p, got back %p",
                      exp_data,pkt.data))
     end

     `uvm_info("PRODUCER/END_TEST","Dropping objection to ending the test",UVM_LOW)
     phase.drop_objection(this);

   endtask

endclass

