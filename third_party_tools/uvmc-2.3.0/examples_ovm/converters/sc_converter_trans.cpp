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
#include <uvmc.h>

using std::vector;
using namespace sc_core;
using namespace tlm;

//------------------------------------------------------------------------------
// Title: UVMC Converter Example - SC In-Transaction
//
// This example's packet class defines ~do_pack~ and ~do_unpack~ methods that
// are compatible with the default converter in SC. The default converter merely
// delegates conversion to these two methods in the transaction class.
//
// (see UVMC_Converters_SC_InTrans.png)
//
// This approach is not very common in practice, as it couples your transaction
// types to the UVMC library.
//
// Instead of defining member functions of the transaction type to do conversion,
// you should instead implement a template specialization of uvmc_convert<T>.
// This leaves conversion knowledge outside your transaction proper, and allows
// you to define different conversion algorithms without requiring inheritance.

// This example demonstrates use of a transaction class that defines the
// conversion functionality in compliant ~do_pack~ and ~do_unpack~ methods.
// Thus, an custom converter specialization will not be needed--the default
// converter, which delegates to ~do_pack~ and ~do_unpack~ methods in the
// transaction, is sufficient.
//
// Because most SC transactions do not implement the pack and unpack member
// functions required by the default converter, a template specialization
// definition is normally required. 
//
// The default converter, uvmc_converter<T>, or any template specialization
// of that converter for a given packet type, e.g. uvmc_converter<packet>,
// is implicitly chosen by the C+ compiler. This means you will seldom need to
// explicitly specify the converter type when connecting via <uvmc_connect>.
//
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Group: User Library
//
// This section defines a transaction class and generic consumer model. The
// transaction implements the ~do_pack~ and ~do_unpack~ methods required by the
// default converter.
//
// Packing and unpacking involves streaming the contents of your transaction
// fields into and out of the ~packer~ object provided as an argument to ~do_pack~
// and ~do_unpack~. The packer needs to have defined ~operator<<~ for each type
// of field you stream. See <UVMC Type Support> for a list of supported
// transaction field types.
//------------------------------------------------------------------------------

// (begin inline source)
namespace user_lib {

  using namespace uvmc;

  class packet_base
  {
    public:
    enum cmd_t { WRITE=0, READ, NOOP };

    cmd_t cmd;
    unsigned int addr;
    vector<unsigned char> data;

    virtual void do_pack(uvmc_packer &packer) const {
      packer << cmd << addr << data;
    }

    virtual void do_unpack(uvmc_packer &packer) {
      packer >> cmd >> addr >> data;
    }
  };


  class packet : public packet_base
  {
    public:
    unsigned int extra_int;
  
    virtual void do_pack(uvmc_packer &packer) const {
      packet_base::do_pack(packer);
      packer << extra_int;
    }

    virtual void do_unpack(uvmc_packer &packer) {
      packet_base::do_unpack(packer);
      packer >> extra_int;
    }
  };

  // a generic target with a TLM1 put export
  #include "consumer.cpp"

}
// (end inline source)




//------------------------------------------------------------------------------
// Group: Conversion code
//
// We do not need to define an external conversion class because it conversion
// is built into the transaction proper. The default converter will delegate to
// our transaction's ~do_pack~ and ~do_unpack~ methods. 
//
// We do, however, define ~operator<< (ostream&)~ for our transaction type using
// <UVMC_PRINT> macros. With this, we can print the transaction contents to any
// output stream.
//
// For example
//
//| packet p;
//| ...initialize p...
//| cout << p;
//
// This produces output similar to
//
//| '{cmd:2 addr:1fa34f22 data:'{4a, 27, de, a2, 6b, 62, 8d, 1d, 6} }
//
// You can invoke the macros in any namepace in which the uvmc namespace
// was imported and the macros #included.
//
//------------------------------------------------------------------------------

// (begin inline source)
using namespace user_lib;

UVMC_PRINT_3(packet_base,cmd,addr,data)
UVMC_PRINT_EXT_1(packet,packet_base,extra_int)

// (end inline source)


//------------------------------------------------------------------------------
// Group: Testbench code
//
// This section defines our testbench environment. In the top-level  module, we
// instantiate the generic consumer model. We also register  the consumer's ~in~
// export to have a UVMC connection with a lookup string, ~stimulus~. The
// SV-side will register its producer's ~out~  port with the same lookup string.
// UVMC will match these two strings to complete the cross-language connection,
// i.e. the SV producer's ~out~ port will be bound to the SC consumer's
// ~in~ export.
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


