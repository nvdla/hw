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

`timescale 1ns / 1ns
`include "ovm_macros.svh"
import ovm_pkg::*; 


//----------------------------------------------------------------------
// Title: UVMC Command API Examples - Common SV Code
//
// This code provides an example of waiting for each OVM phase to reach
// a specified state and then, if the phase is a task phase, controlling
// its progression by raising and dropping the objection that governs it.
//
// uvmc_wait_for_phase - block until OVM has reached a certain phase.
//      You may also wait for certain phase state (e.g. started, ended,
//      etc.)
//
// uvmc_raise_objection - prevent a UVM phase from ending
//
// uvmc_drop_objection - remove your objection to ending a UVM phase
//
// See the <Phasing> command descriptions for more details.
//----------------------------------------------------------------------


//-----------------------------------------------------------------------------
// CLASS: prod_cfg
//
// The ~prod_cfg~ class is the configuration object used by our <producer>
// below. The <UVMC Command API Example - Configuration>  demonstrates how to
// set this configuration from the SC side.
//
// The configuration object specifies various constraints on randomization of
// the generated transactions: the number of transactions, the address range,
// and limits on the size of the data array.
//
// SV-side conversion is implemented inside the ~do_pack~ and ~do_unpack~
// methods in the configuration object.
//-----------------------------------------------------------------------------

// (begin inline source)
class prod_cfg extends ovm_object;

  `ovm_object_utils(prod_cfg);

  function new(string name="producer_config_inst");
    super.new(name);
  endfunction

  int min_addr = 'h00;
  int max_addr = 'hff;
  int min_data_len = 10;
  int max_data_len = 80;
  int max_trans = 5;

  virtual function void do_pack(ovm_packer packer);
    packer.pack_field_int(min_addr,32);
    packer.pack_field_int(max_addr,32);
    packer.pack_field_int(min_data_len,32);
    packer.pack_field_int(max_data_len,32);
    packer.pack_field_int(max_trans,32);
  endfunction

  virtual function void do_unpack(ovm_packer packer);
    min_addr = packer.unpack_field_int(32);
    max_addr = packer.unpack_field_int(32);
    min_data_len = packer.unpack_field_int(32);
    max_data_len = packer.unpack_field_int(32);
    max_trans = packer.unpack_field_int(32);
  endfunction

  function string convert2string();
    return $sformatf("min_addr:%h max_addr:%h min_data_len:%0d max_data_len:%0d max_trans:%0d",
    min_addr, max_addr, min_data_len, max_data_len,max_trans);
  endfunction

endclass
// (end inline source)


`include "packet.sv"

//-----------------------------------------------------------------------------
// CLASS: producer
//
// A simple SV producer TLM model that generates a configurable number of
// ~packet~ transactions and sends them to its ~out~ port for execution.
// The transaction is also broadcast to its ~ap~ analysis port.
//
// While trivial in functionality, the model demonstrates use of TLM ports
// to facilitate external communication. 
//
// - Users of the model are not coupled to its internal implementation, using
//   only the provided TLM ports to communicate.
//
// - The model itself does not refer to anything outside its encapsulated
//   implementation. It does not know nor care about what might
//   be receiving the transactions sent via its ~out~ and ~ap~ ports.
//
// Because this producer is used for all the Command API examples,  for
//-----------------------------------------------------------------------------

class producer extends ovm_component;

   ovm_blocking_put_port #(packet) out; 

   ovm_analysis_port #(packet) ap; 

   `ovm_component_utils(producer)
   
   // Functions: Phases
   //
   // We implement each phase to simply print a message that the
   // phase has started. The <UVMC Command API Example - Phase Control>
   // will show that SC can be synchronized to OVM phases and even
   // prevent the task phases from ending.

   // (begin inline source)
   virtual function void build();
     `ovm_info("OVMC_PHASING","BUILD Started",OVM_NONE);
   endfunction

   virtual function void connect();
     `ovm_info("OVMC_PHASING","CONNECT Started",OVM_NONE);
   endfunction

   virtual function void end_of_elaboration();
     `ovm_info("OVMC_PHASING","END_OF_ELABORATION Started",OVM_NONE);
   endfunction

   virtual function void start_of_simulation();
     `ovm_info("OVMC_PHASING","START_OF_SIMULATION Started",OVM_NONE);
   endfunction

   virtual function void extract();
     `ovm_info("OVMC_PHASING","EXTRACT Started",OVM_LOW);
   endfunction

   virtual function void check();
     `ovm_info("OVMC_PHASING","CHECK Started",OVM_LOW);
   endfunction

   virtual function void report();
     `ovm_info("OVMC_PHASING","REPORT Started",OVM_LOW);
   endfunction
   // (end inline source)


   // Function: new
   //
   // Creates a new producer object. Here, we allocate the
   // ~out~ port and ~ap~ analysis port. If +PHASING_ON is
   // not on the command line, we disable the OVMC_PHASING
   // messages that are emitted by each phase callback
   // (see above).

   // (begin inline source)
   function new(string name, ovm_component parent=null);
      super.new(name,parent);
      out = new("out", this);
      ap = new("ap", this);
      //if (!$test$plusargs("PHASING_ON"))
       // set_report_id_action("OVMC_PHASING",OVM_NO_ACTION);
   endfunction : new


   // Function: check_config
   //
   // Enabled only during the <UVMC Command API Example - Configuration>,
   // the ~check_config~ function gets the configuration parameters
   // that the SC side should have set. It produces ERRORs in cases
   // where a get was not successful.

   // (begin inline source)
   prod_cfg cfg = new();

   function void check_config();

     int i;
     string str;
     ovm_object obj;

       if (!get_config_int("some_int",i))
         `ovm_error("NO_INT_CONFIG",{"No configuration for field 'some_int'",
            " found at context '",get_full_name(),"'"})
       else
         `ovm_info("INT_CONFIG",
            $sformatf("Config for field 'some_int' at context '%s' has value %0h",
            get_full_name(),i),OVM_NONE)


       if (!get_config_string("some_string",str))
         `ovm_error("NO_STRING_CONFIG",{"No configuration for field 'some_string'",
            " found at context '",get_full_name(),"'"})
       else
         `ovm_info("STRING_CONFIG",
            {"Config for field 'message' at context '", get_full_name(),
            "' has value '", str,"'"},OVM_NONE)

       if (!get_config_object("config",obj,0))
         `ovm_error("NO_OBJECT_CONFIG",{"No configuration for field 'config'",
            " found at context '",get_full_name(),"'"})
       else begin
          prod_cfg c;
          if (!$cast(c,obj))
            `ovm_error("BAD_CONFIG_TYPE", 
               {"Object set for configuration field 'config' at context '",
               get_full_name(),"' is not a prod_cfg type"})
          else begin
            cfg = c;
            `ovm_info("OBJECT_CONFIG",
               {"Config for field 'config' at context '",get_full_name(),
               "' has value '", cfg.convert2string(),"'"},OVM_NONE)
          end
       end

   endfunction
   // (end inline source)


   // Task: run
   //
   // Produces the configured number of transactions, sending each
   // to its ~out~ and ~ap~ analysis ports. A <prod_cfg> configuration
   // object governs how many transactions are produced and constrains
   // the address range and data array length during randomization.
   // Upon return from sending the last transaction, the producer drops
   // its objection to ending the run phase, thus allowing simulation
   // to proceed to the next phase.

   // (begin inline source)
   virtual task run();

     bit enable_config_check = $test$plusargs("CONFIG_ON");
     bit enable_stimulus = $test$plusargs("TRANS_ON");

     if (enable_config_check)
       check_config();

     if (enable_stimulus) begin

       `ovm_info("OVMC_PHASING","RUN Started",OVM_LOW);

       if (cfg != null) begin

         ovm_test_done.raise_objection(this);

         for (int i = 1; i <= cfg.max_trans; i++) begin

           packet pkt = packet::type_id::create("pkt",this);

           pkt.cmd = i;

           if (!pkt.randomize() with {
              addr inside { [cfg.min_addr:cfg.max_addr] };
              data.size() inside { [cfg.min_data_len:cfg.max_data_len] }; })
             `ovm_error("RAND_FAILED",  "Randomization of tlm_gp failed")

           $display();
           `ovm_info("PRODUCER/SEND_PKT",
              $sformatf("SV producer sending packet #%0d\n  %s",i,
                        pkt.sprint(ovm_default_line_printer)),OVM_MEDIUM)

           ap.write(pkt);
           out.put(pkt);
         end

         ovm_test_done.drop_objection(this);

         `ovm_info("PRODUCER/DONE","Finished with stimulus",OVM_LOW)

       end

     end // enable_stimulues
     
     else begin
       global_stop_request();
     end

   endtask

endclass
// (end inline source)


//-----------------------------------------------------------------------------
// CLASS: producer_ext
//
// This trivial extension of our <producer> class is used to demonstrate
// factory overrides from SC using the UVMC Command API.
//-----------------------------------------------------------------------------

// (begin inline source)
class producer_ext extends producer;

   `ovm_component_utils(producer_ext)

   function new(string name, ovm_component parent=null);
      super.new(name,parent);
      `ovm_info("PRODUCER_EXTENSION","Derived producer created!",OVM_NONE);
   endfunction

endclass
// (end inline source)


//-----------------------------------------------------------------------------
// CLASS: scoreboard
//
// A simple SV consumer TLM model that prints received transactions (of type
// ~tlm_generic_payload) and sends them out its ~ap~ analysis port.
//
// While trivial in functionality, the model demonstrates use of TLM ports
// to facilitate external communication. 
//
// - Users of the model are not coupled to its internal implementation, using
//   only the provided TLM exports to communicate.
//
// - The model itself does not refer to anything outside its encapsulated
//   implementation. It does not know nor care about what might
//   be driving its analysis exports.
//-----------------------------------------------------------------------------

class scoreboard extends ovm_component;

   tlm_analysis_fifo   #(packet) expect_fifo;
   ovm_analysis_export #(packet) expect_in;
   ovm_analysis_imp    #(packet,scoreboard) actual_in; 

   `ovm_component_utils(scoreboard)
   
   function new(string name, ovm_component parent=null);
      super.new(name,parent);
      actual_in   = new("actual_in", this);
      expect_in   = new("expect_in", this);
      expect_fifo = new("exp_fifo",  this);
      expect_in.connect(expect_fifo.analysis_export);
   endfunction : new

   virtual function void write(packet t);
     packet exp;
     int success;
     ovm_default_comparer.show_max = 1000;

     ovm_report_info("SCOREBD/RECV",{"Scoreboard received actual packet:\n",
                     t.sprint(ovm_default_line_printer),"\n"});

     if (!expect_fifo.try_get(exp))
       ovm_report_fatal("SCOREBD/NO_EXP",
                 "No expect packet for incoming actual.");

     success = exp.compare(t);

     if (!success)
       ovm_report_error("SCOREBD/MISCOMPARE",
         $sformatf("There were %0d miscompares:\nexpect=%p\nactual=%p",
           ovm_default_comparer.result,exp,t));

   endfunction

endclass


//-----------------------------------------------------------------------------
// CLASS: scoreboard_ext
//
// This trivial extension of our <scoreboard> class is used to demonstrate
// factory overrides from SC using the UVMC Command API.
//-----------------------------------------------------------------------------

// (begin inline source)
class scoreboard_ext extends scoreboard;

   `ovm_component_utils(scoreboard_ext)

   function new(string name, ovm_component parent=null);
      super.new(name,parent);
      `ovm_info("SCOREBOARD_EXTENSION","Derived scoreboard created!",OVM_NONE);
   endfunction

endclass
// (end inline source)


//------------------------------------------------------------------------------
// CLASS: env
//
// Our SV ~env~ contains an instance of our <producer> and <scoreboard>, above.
//------------------------------------------------------------------------------

// (begin inline source)
class env extends ovm_env;

   `ovm_component_utils(env)
   
   ovm_blocking_put_port #(packet) prod_out; 
   ovm_analysis_export #(packet) sb_actual_in;

   producer prod;
   scoreboard sb;

   function new(string name, ovm_component parent=null);
     super.new(name,parent);
     prod_out = new("prod_out",this);
     sb_actual_in = new("sb_actual_in",this);
   endfunction

   function void build();
     prod = producer::type_id::create("prod",this);
     sb = scoreboard::type_id::create("sb",this);
   endfunction

   function void connect();
     prod.ap.connect(sb.expect_in);
     prod.out.connect(prod_out);
     sb_actual_in.connect(sb.actual_in);
   endfunction

endclass
// (end inline source)


//-----------------------------------------------------------------------------
// MODULE: sv_main
//
// This is the top-level module for the SV side of each command API example.
//
// This top-level SV module does the following
//
// - Initializes the UVMC Command API layer by calling ~uvmc_init~. This is
//   required. You can also relegate the init call to a separate module that
//   is compiled separately or on the same command line as this file.
//
// - Registers the env's ~prod_out~ and ~sb_actual_in~ ports for UVMC
//   communication.
// 
// - Calls ~run_test~ to start the SV portion of the simulation.
// 
// We could have registered the UVMC connections in the <env's> ~connect~
// method, but that would have forced the ~env~ to only work with UVMC. If
// you prefer to relagate UVMC registration to the <env> or lower, you should
// not mix it in with the ~env's~ main purpose. Instead, try to add the
// UVMC connection code to a simple extension/wrapper around your original
// model. This technique is demonstrated in <SC to SV Connection-SC side).
//-----------------------------------------------------------------------------

// (begin inline source)
module sv_main;

  import ovmc_pkg::*;

  env e;

  initial begin
    e = new("e");

    uvmc_init();

    // In OVM, build-phase can be started before SC-side gets to wait
    // on UVM_PHASE_STARTED, causing an error. This #0 delays the
    // run_test() enough to allow SC-side to issue a wait for
    // the build phase to be started. UVM doesn't have this problem
    // because UVM inserts delta delays between each phase transition.
    #0;

    $timeformat(-9,0," ns");

    // actual path - SC-side consumer to SV-side scoreboard
    uvmc_tlm1 #(packet)::connect(e.prod_out,"foo");
    uvmc_tlm1 #(packet)::connect(e.sb_actual_in,"bar");

    run_test();

  end

endmodule
// (end inline source)
