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
// Title: SV Producer
//
// Topic: Description
// A generic producer parameterized on transaction type. Used to illustrate
// different converter options using the same producer class. Doesn't do
// anything functionally useful. Sends a transaction out a ~out~ put port
// and receives the same packet via its ~in_ap~ analysis imp. The write
// function compares to make sure the conversion happened properly in
// both directions.
//-----------------------------------------------------------------------------

// (inline source)
class producer #(type T=int) extends ovm_component;

   ovm_blocking_put_port #(T) out; 
   ovm_analysis_imp #(T,producer#(T)) ap_in; 

   int num_pkts;
   packet expected_pkt;

   `ovm_component_param_utils(producer #(T))
   
   function new(string name, ovm_component parent=null);
      super.new(name,parent);
      out = new("out", this);
      ap_in = new("ap_in", this);
      num_pkts = 10;
   endfunction : new

   virtual task run();

     ovm_test_done.raise_objection(this);

     for (int i = 1; i <= num_pkts; i++) begin

       int unsigned exp_addr;
       byte exp_data[$];

       T pkt = new();
       assert(pkt.randomize());

       exp_addr = ~pkt.addr;
       foreach (pkt.data[i])
         exp_data[i] = ~pkt.data[i];

       `ovm_info("PRODUCER/PKT/SEND_REQ",
          $sformatf("SV producer request:\n   %s", pkt.convert2string()), OVM_MEDIUM)

       expected_pkt = pkt;

       out.put(pkt);

     end

     `ovm_info("PRODUCER/END_TEST","Dropping objection to ending the test",OVM_LOW)
     ovm_test_done.drop_objection(this);

   endtask


   virtual function void write(packet t);

       `ovm_info("PRODUCER/PKT/RECV_RSP",
          $sformatf("SV producer response:\n   %s\n", t.convert2string()), OVM_MEDIUM)

       if (t.addr != expected_pkt.addr)
         `ovm_error("PRODUCER/PKT/ADDR_MISCOMPARE",
            $sformatf("Expected address to be %h, got back %h",
                    expected_pkt.addr,t.addr))

       if (t.data != expected_pkt.data)
         `ovm_error("PRODUCER/PKT/DATA_MISCOMPARE",
            $sformatf("Expected data to be %p, got back %p",
                    expected_pkt.data,t.data))

       expected_pkt = null; 

   endfunction

endclass

