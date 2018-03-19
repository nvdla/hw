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
// Title: UVMC Converter Example - SC Converter Class, Macro-Generated
//
// This example demonstrates how to define an external converter for a
// transaction class using a <UVMC_UTILS> macro. The macro expands into a
// template specialization of ~uvmc_converter<T>~ for your type ~T~, overriding
// the default converter's implementation. An example showing how to write such
// a template specialization without the convenience macros can be found in
// <UVMC Converter Example - SC Converter Class>.
//
// (see UVMC_Converters_SC_UserDefined.png)
//
// In SC, a separate converter class definition is usually required because most
// SC transactions do not implement the pack and unpack member functions
// required by the default converter. To <UVMC_UTILS> macros can be used to
// quickly define a converter for your transaction type. The macro would expand
// into the same code you would write directly, so these macros do not suffer
// from the performance and debug costs associated with other macros such as the
// ~`uvm_field~ macros.
//
// The UTILS macros also defined ~operator<<~ for the output stream (e.g. cout).
// With this, we can print the transaction contents to any output stream.
// For example:
//
//| packet p;
//| // initialize p...
//| cout << p;
//
// This produces output similar to
//
//| '{cmd:2 addr:1fa34f22 data:'{4a, 27, de, a2, 6b, 62, 8d, 1d, 6} }
//
// Template specializations are chosen automatically by the C+ compiler, so
// you will not need to explicitly specify your converter type when connecting
// via ~uvmc_connect~.
//
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Group: User Library
//
// This section defines a user transaction class and generic consumer model. 
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

}
// (end inline source)



//------------------------------------------------------------------------------
// Group: Conversion code
//
// This section defines a converter for our ~packet~ transaction type using a
// <UVMC_UTILS> macro for each class in the ~packet~ inheritance hierarchy..
//
// The definition of the SC-side template specialization is so regular that a
// set of convenient macros have been developed to produce a converter class
// definition for you. You need to invoke one of these macros, depending on
// the number of fields in your transaction class and whether it inherits from
// a base class.
//------------------------------------------------------------------------------

// (begin inline source)
#include "uvmc.h"
using namespace uvmc;
using namespace user_lib;

UVMC_UTILS_3(packet_base,cmd,addr,data)
UVMC_UTILS_EXT_1(packet,packet_base,extra_int)
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

#include "consumer.cpp"

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

