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

//------------------------------------------------------------------------------
// Title: UVMC Converter Example - SV Converter Class
//
// This example demonstrates how to define a custom converter for a transaction
// class that does not extend from ~uvm_object~. 
//
// (see UVMC_Converters_SV_UserDefined.png)
//
// Most SV transactions extend ~uvm_object~ and implement the ~do_pack~ and
// ~do_unpack~ methods. The default converter for SV works for these types of
// transactions, so in most cases you will not need to define an external
// converter class.
//
// To apply the external converter to a particular cross-language connection,
// specify it as a type parameter when registering a UVMC connection
//
//| uvmc_tlm #(packet, my_converter)::connect( some_port, "some_lookup");
//
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Group: User Library
//
// This section defines a transaction class, ~packet~, that does not extend from
// any base class. It also defines a generic producer model via `include. All
// transactions and components in the  user library should be written to be
// independent of context, i.e. not assume a UVMC or any other outside connetion.
//------------------------------------------------------------------------------

package user_pkg;

  // (begin inline source)
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  class packet_base;

    typedef enum { WRITE, READ, NOOP } cmd_t;

    rand cmd_t cmd;
    rand int   addr;
    rand byte  data[$];

    constraint c_data_size { data.size() inside { [1:12] }; }

    extern virtual function string convert2string(); //for printing

  endclass


  class packet extends packet_base;

    rand int extra_int;

    extern virtual function string convert2string(); //for printing

  endclass

  // a generic producer with a b_transport port
  `include "producer.sv"

  // (end inline source)

  // for printing in short format
  function string packet_base::convert2string();
    return $sformatf("cmd:%s addr:%h data:%p",cmd,addr,data);
  endfunction

  function string packet::convert2string();
    return $sformatf("%s extra_int:%h",super.convert2string(),extra_int);
  endfunction

endpackage : user_pkg




//------------------------------------------------------------------------------
// Group: Conversion code
//
// This section defines a converter for our 'packet' transaction type. We will
// later use this converter when registering cross-language connections to SC.
//
// The ~`uvm_pack_*~ and ~`uvm_unpack_*~ macros expand into two or so lines of
// code that are more efficient than using the packer's API directly. These
// macros are part of the UVM standard and are documented under the ~Macros~
// heading in the UVM Reference Manual.
//
//------------------------------------------------------------------------------

// (begin inline source)
package convert_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import uvmc_pkg::*;
  import user_pkg::*;

  class convert_packet_base extends uvmc_converter #(packet_base);

    static function void do_pack(packet_base t, uvm_packer packer);
      `uvm_pack_enum(t.cmd)
      `uvm_pack_int(t.addr)
      `uvm_pack_queue(t.data)
    endfunction

    static function void do_unpack(packet_base t, uvm_packer packer);
      `uvm_unpack_enum(t.cmd,packet_base::cmd_t)
      `uvm_unpack_int(t.addr)
      `uvm_unpack_queue(t.data)
    endfunction

  endclass


  class convert_packet extends uvmc_converter #(packet);

    static function void do_pack(packet t, uvm_packer packer);
      convert_packet_base::do_pack(t,packer);
      `uvm_pack_int(t.extra_int)
    endfunction

    static function void do_unpack(packet t, uvm_packer packer);
      convert_packet_base::do_unpack(t,packer);
      `uvm_unpack_int(t.extra_int)
    endfunction

  endclass

endpackage
// (end inline source)


//------------------------------------------------------------------------------
// Group: Testbench code
//
// This section defines our testbench environment. In the top-level  module, we
// instantiate the generic producer model. We also register  the producer's
// 'out' port to have a UVMC connection with a lookup  string 'stimulus'. The
// SC-side will register its consumer's 'in'  port with the same 'stimulus'
// lookup string. UVMC will match these two strings and complete the cross-
// language connection, i.e. the SV producer's ~out~ port will be bound to the
// SC consumer's ~in~ export.
//------------------------------------------------------------------------------

// (begin inline source)
module sv_main;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import uvmc_pkg::*;
  import user_pkg::*;
  import convert_pkg::*;

  // Define env with connection specifying custom converter 

  class sv_env extends uvm_env;

    producer #(packet) prod;

    `uvm_component_utils(sv_env)
   
    function new(string name, uvm_component parent=null);
       super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
       prod = new("prod", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      uvmc_tlm #(packet,uvm_tlm_phase_e,convert_packet)::
                              connect(prod.out, "stimulus");
    endfunction

  endclass


  sv_env env;

  initial begin
    env = new("env");
    run_test();
  end

endmodule
// (end inline source)

