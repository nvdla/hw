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
`include "uvm_macros.svh"
import uvm_pkg::*; 


//----------------------------------------------------------------------
// Title: UVMC Command API Examples - Common SV Code
//
// This code provides an example of waiting for each UVM phase to reach
// a specified state and then, if the phase is a task phase, controlling
// its progression by raising and dropping the objection that governs it.
//
// uvmc_wait_for_phase - block until UVM has reached a certain phase.
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
class prod_cfg extends uvm_object;

  `uvm_object_utils(prod_cfg);

  function new(string name="producer_config_inst");
    super.new(name);
  endfunction

  int min_addr = 'h00;
  int max_addr = 'hff;
  int min_data_len = 10;
  int max_data_len = 80;
  int max_trans = 5;

  virtual function void do_pack(uvm_packer packer);
    `uvm_pack_int(min_addr)
    `uvm_pack_int(max_addr)
    `uvm_pack_int(min_data_len)
    `uvm_pack_int(max_data_len)
    `uvm_pack_int(max_trans)
  endfunction

  virtual function void do_unpack(uvm_packer packer);
    `uvm_unpack_int(min_addr)
    `uvm_unpack_int(max_addr)
    `uvm_unpack_int(min_data_len)
    `uvm_unpack_int(max_data_len)
    `uvm_unpack_int(max_trans)
  endfunction

  function string convert2string();
    return $sformatf("min_addr:%h max_addr:%h min_data_len:%0d max_data_len:%0d max_trans:%0d",
    min_addr, max_addr, min_data_len, max_data_len,max_trans);
  endfunction

endclass
// (end inline source)


//-----------------------------------------------------------------------------
// CLASS: producer
//
// A simple SV producer TLM model that generates a configurable number of
// ~uvm_tlm_generic_payload~ transactions and sends them to its ~out~ port
// for execution. The transaction is also broadcast to its ~ap~ analysis port.
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

class producer extends uvm_component;

   uvm_tlm_b_transport_port #(uvm_tlm_generic_payload) out; 

   uvm_analysis_port #(uvm_tlm_generic_payload) analysis_out; 

   `uvm_component_utils(producer)
   
   // Functions: Phases
   //
   // We implement each phase to simply print a message that the
   // phase has started. The <UVMC Command API Example - Phase Control>
   // will show that SC can be synchronized to UVM phases and even
   // prevent the task phases from ending.

   // (begin inline source)
   function void build_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","BUILD Started",UVM_NONE);
   endfunction

   function void connect_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","CONNECT Started",UVM_NONE);
   endfunction

   function void end_of_elaboration_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","END_OF_ELABORATION Started",UVM_NONE);
   endfunction

   function void start_of_simulation_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","START_OF_SIMULATION Started",UVM_NONE);
   endfunction

   task pre_reset_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","PRE_RESET Started",UVM_LOW);
   endtask

   task reset_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","RESET Started",UVM_LOW);
   endtask

   task post_reset_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","POST_RESET Started",UVM_LOW);
   endtask

   task pre_configure_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","PRE_CONFIGURE Started",UVM_LOW);
   endtask

   task configure_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","CONFIGURE Started",UVM_LOW);
   endtask

   task post_configure_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","POST_CONFIGURE Started",UVM_LOW);
   endtask

   task pre_main_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","PRE_MAIN Started",UVM_LOW);
   endtask

   task main_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","MAIN Started",UVM_LOW);
   endtask

   task post_main_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","POST_MAIN Started",UVM_LOW);
   endtask

   task pre_shutdown_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","PRE_SHUTDOWN Started",UVM_LOW);
   endtask

   task shutdown_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","SHUTDOWN Started",UVM_LOW);
   endtask

   task post_shutdown_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","POST_SHUTDOWN Started",UVM_LOW);
   endtask

   function void extract_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","EXTRACT Started",UVM_LOW);
   endfunction

   function void check_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","CHECK Started",UVM_LOW);
   endfunction

   function void report_phase(uvm_phase phase);
     `uvm_info("UVMC_PHASING","REPORT Started",UVM_LOW);
   endfunction
   // (end inline source)


   // Function: new
   //
   // Creates a new producer object. Here, we allocate the
   // ~out~ port and ~ap~ analysis port. If +PHASING_ON is
   // not on the command line, we disable the UVMC_PHASING
   // messages that are emitted by each phase callback
   // (see above).

   // (begin inline source)
   function new(string name, uvm_component parent=null);
      super.new(name,parent);
      out = new("out", this);
      analysis_out = new("analysis_out", this);
      if (!$test$plusargs("PHASING_ON"))
        set_report_id_action("UVMC_PHASING",UVM_NO_ACTION);
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
     uvm_object obj;

       if (!uvm_config_db #(uvm_bitstream_t)::get(this,"","some_int",i))
         `uvm_error("NO_INT_CONFIG",{"No configuration for field 'some_int'",
            " found at context '",get_full_name(),"'"})
       else
         `uvm_info("INT_CONFIG",
            $sformatf("Config for field 'some_int' at context '%s' has value %0h",
            get_full_name(),i),UVM_NONE)


       if (!uvm_config_db #(string)::get(this,"","some_string",str))
         `uvm_error("NO_STRING_CONFIG",{"No configuration for field 'some_string'",
            " found at context '",get_full_name(),"'"})
       else
         `uvm_info("STRING_CONFIG",
            {"Config for field 'message' at context '", get_full_name(),
            "' has value '", str,"'"},UVM_NONE)

       if (!uvm_config_db #(uvm_object)::get(this,"","config",obj))
         `uvm_error("NO_OBJECT_CONFIG",{"No configuration for field 'config'",
            " found at context '",get_full_name(),"'"})
       else begin
          prod_cfg c;
          if (!$cast(c,obj))
            `uvm_error("BAD_CONFIG_TYPE", 
               {"Object set for configuration field 'config' at context '",
               get_full_name(),"' is not a prod_cfg type"})
          else begin
            cfg = c;
            `uvm_info("OBJECT_CONFIG",
               {"Config for field 'config' at context '",get_full_name(),
               "' has value '", cfg.convert2string(),"'"},UVM_NONE)
          end
       end

   endfunction
   // (end inline source)


   // Function: run_phase
   //
   // Produces the configured number of transactions, sending each
   // to its ~out~ and ~ap~ analysis ports. A <prod_cfg> configuration
   // object governs how many transactions are produced and constrains
   // the address range and data array length during randomization.
   // Upon return from sending the last transaction, the producer drops
   // its objection to ending the run_phase, thus allowing simulation
   // to proceed to the next phase.

   // (begin inline source)
   task run_phase (uvm_phase phase);

     uvm_tlm_generic_payload pkt = new;
     uvm_tlm_time delay = new;

     bit enable_config_check = $test$plusargs("CONFIG_ON");
     bit enable_stimulus = $test$plusargs("TRANS_ON");
     pkt.m_streaming_width.rand_mode(0);
     pkt.m_byte_enable_length.rand_mode(0);
     pkt.m_byte_enable.rand_mode(0);
     pkt.m_data = new[1];

     `uvm_info("UVMC_PHASING","RUN Started",UVM_LOW);

     phase.raise_objection(this);

     if (enable_config_check)
       check_config();

     if (enable_stimulus && cfg != null) begin

       for (int i = 1; i <= cfg.max_trans; i++) begin

         if (!pkt.randomize() with {
            m_address inside { [cfg.min_addr:cfg.max_addr] };
            m_data.size() inside { [cfg.min_data_len:cfg.max_data_len] }; })
           `uvm_error("RAND_FAILED",  "Randomization of tlm_gp failed")

         pkt.set_data_length(pkt.m_data.size());

         delay.set_abstime(11,1e-9);

         $display();
         `uvm_info("PRODUCER/SEND_PKT",
            $sformatf("SV producer sending packet #%0d\n  %s",i,
                      pkt.sprint(uvm_default_line_printer)),UVM_MEDIUM)

         analysis_out.write(pkt);
         out.b_transport(pkt,delay);
       end

     end

     #1000;

     `uvm_info("PRODUCER/STOP_TEST","Stopping the test",UVM_LOW)
     phase.drop_objection(this);

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

   `uvm_component_utils(producer_ext)

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
      `uvm_info("PRODUCER_EXTENSION","Derived producer created!",UVM_NONE);
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

class scoreboard extends uvm_component;

   uvm_tlm_analysis_fifo   #(uvm_tlm_generic_payload) expect_fifo;
   uvm_analysis_export #(uvm_tlm_generic_payload) expect_in;
   uvm_analysis_imp    #(uvm_tlm_generic_payload,scoreboard) actual_in; 

   `uvm_component_utils(scoreboard)
   
   function new(string name, uvm_component parent=null);
      super.new(name,parent);
      actual_in   = new("actual_in", this);
      expect_in   = new("expect_in", this);
      expect_fifo = new("exp_fifo",  this);
      expect_in.connect(expect_fifo.analysis_export);
   endfunction : new

   virtual function void write(uvm_tlm_generic_payload t);
     uvm_tlm_generic_payload exp;
     int success;
     uvm_default_comparer.show_max = 1000;

     uvm_report_info("SCOREBD/RECV",{"Scoreboard received actual packet:\n",
                     t.sprint(uvm_default_line_printer),"\n"});

     if (!expect_fifo.try_get(exp))
       uvm_report_fatal("SCOREBD/NO_EXP",
                 "No expect packet for incoming actual.");

     success = exp.compare(t);

     if (!success)
       uvm_report_error("SCOREBD/MISCOMPARE",
         $sformatf("There were %0d miscompares:\nexpect=%p\nactual=%p",
           uvm_default_comparer.result,exp,t));

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

   `uvm_component_utils(scoreboard_ext)

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
      `uvm_info("SCOREBOARD_EXTENSION","Derived scoreboard created!",UVM_NONE);
   endfunction

endclass
// (end inline source)


//------------------------------------------------------------------------------
// CLASS: env
//
// Our SV ~env~ contains an instance of our <producer> and <scoreboard>, above.
//------------------------------------------------------------------------------

// (begin inline source)
class env extends uvm_env;

   `uvm_component_utils(env)
   
   uvm_tlm_b_transport_port #(uvm_tlm_generic_payload) prod_out; 
   uvm_analysis_export #(uvm_tlm_generic_payload) sb_actual_in;

   producer prod;
   scoreboard sb;

   function new(string name, uvm_component parent=null);
     super.new(name,parent);
     prod_out = new("prod_out",this);
     sb_actual_in = new("sb_actual_in",this);
   endfunction

   function void build();
     prod = producer::type_id::create("prod",this);
     sb = scoreboard::type_id::create("sb",this);
   endfunction

   function void connect();
     prod.analysis_out.connect(sb.expect_in);
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

  import uvmc_pkg::*;

  env e;

  // Must initialize 
  initial 
    uvmc_init();

  initial begin
    e = new("e");

    $timeformat(-9,0," ns");

    // actual path - SC-side consumer to SV-side scoreboard
    uvmc_tlm #(uvm_tlm_generic_payload)::connect(e.prod_out,"foo");
    uvmc_tlm1 #(uvm_tlm_generic_payload)::connect(e.sb_actual_in,"bar");

    run_test();

  end

endmodule
// (end inline source)
