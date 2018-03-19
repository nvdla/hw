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
// class that does not extend from ~ovm_object~. 
//
// (see UVMC_Converters_SV_UserDefined.png)
//
// Most SV transactions extend ~ovm_object~ and implement the ~do_pack~ and
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
  `include "ovm_macros.svh"
  import ovm_pkg::*;

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
//------------------------------------------------------------------------------

// (begin inline source)
package convert_pkg;

  `include "ovm_macros.svh"
  import ovm_pkg::*;
  import ovmc_pkg::*;
  import user_pkg::*;

  class convert_packet_base extends uvmc_converter #(packet_base);

    static function void do_pack(packet_base t, ovm_packer packer);
       packer.pack_field_int(t.cmd,32);
       packer.pack_field_int(t.addr,32);
       packer.pack_field_int(t.data.size(),32);
       foreach (t.data[i])
         packer.pack_field_int(t.data[i],8);
    endfunction

    static function void do_unpack(packet_base t, ovm_packer packer);
        int sz;
        t.cmd = packet_base::cmd_t'(packer.unpack_field_int(32));
        t.addr = packer.unpack_field_int(32);
        sz = packer.unpack_field_int(32);
        t.data.delete();
        for (int i=0; i < sz; i++)
          t.data.push_back( packer.unpack_field_int(8) );
    endfunction

  endclass


  class convert_packet extends uvmc_converter #(packet);

    static function void do_pack(packet t, ovm_packer packer);
      convert_packet_base::do_pack(t,packer);
      packer.pack_field_int(t.extra_int,32);
    endfunction

    static function void do_unpack(packet t, ovm_packer packer);
      convert_packet_base::do_unpack(t,packer);
      t.extra_int = packer.unpack_field_int(32);
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

  `include "ovm_macros.svh"
  import ovm_pkg::*;
  import ovmc_pkg::*;
  import user_pkg::*;
  import convert_pkg::*;

  // Define env with connection specifying custom converter 

  class sv_env extends ovm_env;

    producer #(packet) prod;

    `ovm_component_utils(sv_env)
   
    function new(string name, ovm_component parent=null);
       super.new(name,parent);
    endfunction

    virtual function void build();
       prod = new("prod", this);
    endfunction

    virtual function void connect();
      uvmc_tlm1 #(.T1(packet),.CVRT_T1(convert_packet))::
                              connect(prod.out, "stimulus");
      uvmc_tlm1 #(.T1(packet),.CVRT_T1(convert_packet))::
                              connect(prod.ap_in, "checker");
    endfunction

  endclass


  sv_env env;

  initial begin
    env = new("env");
    run_test();
  end

endmodule
// (end inline source)

