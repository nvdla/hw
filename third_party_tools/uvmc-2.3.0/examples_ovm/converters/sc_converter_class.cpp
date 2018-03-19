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

#include "systemc.h"
#include "tlm.h"
#include <vector>
#include <iomanip>

using namespace sc_core;
using namespace tlm;
using std::vector;

//------------------------------------------------------------------------------
// Title: UVMC Converter Example - SC Converter Class
//
// This example demonstrates how to define an external converter class for a
// given transaction type. The user-defined converter class is a template
// specialization of the default converter, ~uvmc_converter<T>~.
//
// (see UVMC_Converters_SC_UserDefined.png)
//
// Because most SC transactions do not implement the pack and unpack member
// functions required by the default converter, a template specialization of
// ~uvmc_converter<T>~ is usually required.
//
// You can define a template specialization for your transaction as in this
// example, or you could use one of the <UVMC_UTILS> macros to generate a
// definition for you. See <UVMC Converter Example - SC Converter Class,
// Macro-Generated> for details.
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Group: User Library
//
// This section defines a "user library" consisting of a ~packet~ transaction
// class and a generic consumer model. This example will define a converter for
// this packet, then connect an instance of the consumer with an SV-side
// producer using a blocking put interface  conveying that transaction.
//------------------------------------------------------------------------------

// (begin inline source)
namespace user_lib {

  class packet_base
  {
    public:
    enum cmd_t { WRITE=0, READ, NOOP };

    cmd_t cmd;
    unsigned int addr;
    vector<unsigned char> data;
  };

  class packet : public packet_base
  {
    public:
    int extra_int;
  };

  // a generic target with a TLM1 put export
  #include "consumer.cpp"

}
// (end inline source)



//------------------------------------------------------------------------------
// Group: Conversion code
//
// This section defines a converter specialization for our 'packet' transaction
// type.
//
// We can not use the default converter because it delegates to ~pack~ and
// ~unpack~ methods of the transaction, which our packet class doesn't have.
// So, we define a converter template specialization for our packet type. You
// would implement a transaction converter for your specific transaction type
// in much the same manner.
//
// The definition of a SC-side converter specialization is so regular that a
// set of convenient macros have been developed to produce a converter class
// definition for you.
// See <UVMC Converter Example - SC Converter Class, Macro-Generated> for
// for an example of using the <UVMC_UTILS> macros. See <UVMC_PRINT> for
// how to define ~operator<<(ostream&)~ so you can print your transaction
// contents to ~cout~ or any other output stream.
//------------------------------------------------------------------------------

// (begin inline source)
#include "uvmc.h"
using namespace uvmc;
using namespace user_lib;

template <>
struct uvmc_converter<packet_base> {
  static void do_pack(const packet_base &t, uvmc_packer &packer) {
    packer << t.cmd << t.addr << t.data;
  }
  static void do_unpack(packet_base &t, uvmc_packer &packer) {
    packer >> t.cmd >> t.addr >> t.data;
  }
};

template <>
struct uvmc_converter<packet> {
  static void do_pack(const packet &t, uvmc_packer &packer) {
    uvmc_converter<packet_base>::do_pack(t,packer);
    packer << t.extra_int;
  }
  static void do_unpack(packet &t, uvmc_packer &packer) {
    uvmc_converter<packet_base>::do_unpack(t,packer);
    packer >> t.extra_int;
  }
};

UVMC_PRINT_3(packet_base,cmd,addr,data)
UVMC_PRINT_EXT_1(packet,packet_base,extra_int)
// (end inline source)


//------------------------------------------------------------------------------
// Group: Testbench code
//
// This section defines our testbench environment. In the top-level  module, we
// instantiate the generic consumer model. We also register  the consumer's 'in'
// export to have a UVMC connection with a lookup  string 'stimulus'. The
// SV-side will register its producer's 'out'  port with the same 'stimulus'
// lookup string. UVMC will match these two strings to complete the cross-
// language connection, i.e. the SV producer's ~out~ port will be bound to the
// SC consumer's ~in~ export.
//------------------------------------------------------------------------------

// (begin inline source)

class sc_env : public sc_module
{
  public:
  consumer<packet> cons;

  sc_env(sc_module_name nm) : cons("cons") {
    uvmc_connect(cons.in,"stimulus");
    uvmc_connect(cons.ap,"checker");
  }
};

// Define sc_main, the vendor-independent means of starting a
// SystemC simulation.

int sc_main(int argc, char* argv[]) 
{  
  sc_env env("env");
  sc_start();
  return 0;
}
// (end inline source)

