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
// Title: UVMC Converter Example - SC Adapter Class
//
// This example demonstrates how to define a custom converter for a transaction
// class whose members differ in number, type, and size from the corresponding
// transaction definition in SV. This situation can arise in cases where the
// transaction types are pre-existing in both SC and SV yet have compatible
// content.
//
// (see UVMC_Converters_SC_UserDefinedAdapter.png)
//
// Because most SC transactions do not implement the pack and unpack member
// functions required by the default converter, a template specialization
// definition is required. A template specialization can be defined by hand or
// via a <UVMC_UTILS> macro, which defines the same converter specialization
// plus the operator<< for the default output stream (cout).  This allows you
// to print your packet contents using cout << my_packet;
//
// Template specializations are chosen automatically by the C+ compiler, so
// you will not need to specify the converter type explicitly when connecting
// via <The Connect Function>.
//
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Group: User Library
//
// This section defines a transaction class and generic consumer model. We will
// define a converter for this packet, then connect an instance of the consumer
// with an SV-side producer using a blocking put interface  conveying that
// transaction.
//------------------------------------------------------------------------------

// (begin inline source)
namespace user_lib {

  class packet
  {
    public:
    short addr_hi;
    short addr_lo;
    unsigned int payload[4];
    char  len;
    bool  write; // 1=write, 0=read
  };
}
// (end inline source)



//------------------------------------------------------------------------------
// Group: Conversion code
//
// This section defines a converter specialization for our 'packet' transaction
// type. We can not use the default converter because it delegates to ~pack~ and
// ~unpack~ methods of the transaction, which our packet class doesn't have.
//
// So, we define a converter template specialization for our packet type. Your
// transaction converters would implement the same template.
//
// The definition of a SC-side converter specialization is so regular that a
// set of convenient macros have been developed to produce a converter class
// definition for you. You would invoke one of the macros from the set,
// depending on the number of fields in your transaction class and whether it
// inherits from a base class.
// See <UVMC Converter Example - SC Converter Class, Macro-Generated> for
// for an example of using the <UVMC_UTILS> macros.
//
//
// The corresponding transaction in SV declares the following fields, split
// across two classes (one inheriting from the other), in the given order. 
//
//| class packet_base extends uvm_sequence_item:
//|   typedef enum {WRITE, READ, NOOP} cmd_t;
//|   cmd_t cmd;
//|   int   addr;
//|   byte  data[$];
//| endclass
//|
//| class packet:
//|   int extra_int;
//| endclass
//
// If we could define our SC-side transaction to suit this definition, we'd
// mirror the types, declaration order, and even the inheritance hierarchy.
// In this example, however, we are faced with having to adapt to a
// pre-existing transaction type. 
//
// When writing the converters on the SV and SC side, we can choose three
// different ways:
//
// 1: Let the SC converter pack/unpack normally; implement a custom SV
//    converter to convert according to how the SC side expects to receive
//    the bits.
// 
// 2: Let the SV converter pack/unpack normally; implement a SC converter
//    specialization of the default SC converter to convert according to
//    how the SV side expects to receive the bits.
//
// 3: Let the SV converter pack/unpack normally; implement a subtype to
//    the SC converter specialization to convert according to how the SV
//    side expects to receive the bits. Specify the custom converter type
//    when calling uvmc_connect.
//
// A converter specialization, e.g.  ~template <> class uvmc_converter<packet>~,
// should be reserved for converting the SC transaction as it is defined,
// streaming each field in order and without adaptation.  It should not
// be used to adapt to a custom mapping on the SV side, as in this example.
// For this reason, option 3 is the best.
// 
// The ~packet~ transaction in SV will be packed normally: ~cmd~, ~addr~,
// ~data~, and ~extra_int~. The SV packetized bits, assuming 3 bytes in
// the data array, looks like this:
//
//|  ____________________________________
//| | cmd    |  addr  |d0|d1|d2|extra_int|      
//| |________|________|__|__|__|_________|
//|  0        32       64 72 80 88
//
// In SC, we shall adapt as follows
//
// - map the 32-bit ~cmd~ from SV to a single ~bool~ in SV
//
// - map the 32-bit ~addr~ from SV to two ~addr_lo~ and ~addr_hi~ 16-bit
//   values in SC
//
// - map the ~data~ byte array data from SV to an integer array in SV
//
// When dealing with built-in types, you should account for the endianess
// of your machine's architecture. This example assumes a little-endian
// architecture.
//
//------------------------------------------------------------------------------

// (begin inline source)
#include <vector>
#include <iomanip>
using std::vector;

#include "uvmc.h"
using namespace uvmc;
using namespace user_lib;

struct packet_converter : public uvmc_converter<packet>
{
  static void do_pack(const packet &t, uvmc_packer &packer) {
    int cmd_tmp;
    if (t.write)
      cmd_tmp = 0;
    else
      cmd_tmp = 1;
    packer << cmd_tmp
           << t.addr_lo << t.addr_hi
           << (int)(t.len) << t.payload;
  }

  static void do_unpack(packet &t, uvmc_packer &packer) {
    int cmd_tmp;
    vector<unsigned char> data_tmp;
    packer >> cmd_tmp >> t.addr_lo >> t.addr_hi >> data_tmp;
    t.len = data_tmp.size();
    if (cmd_tmp == 0)
      t.write = 1;
    else if (cmd_tmp == 1)
      t.write = 0;
    else
      cout << "packet cmd from SV side has unsupported value "
           << cmd_tmp << endl;
    for (int i=0;i<4;i++)
      t.payload[i]=0;
    for (int i=0;i<4;i++) {
      for (int j=0;j<4;j++) {
        if ((i*4+j)<t.len) {
          int b;
          b = data_tmp[i*4+j] << (8*j);
          t.payload[i] = t.payload[i] | b;
        }
        else {
          break;
        }
      }
    }
  }

};

UVMC_PRINT_4(packet,addr_hi,addr_lo,len,write)
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
#include "systemc.h"
#include "tlm.h"
using namespace sc_core;
using namespace tlm;

// a generic target with a TLM1 put export
#include "consumer.cpp"

class sc_env : public sc_module
{
  public:
  consumer<packet> cons;

  sc_env(sc_module_name nm) : cons("cons") {
    uvmc_connect<packet_converter>(cons.in,"stimulus");
    uvmc_connect<packet_converter>(cons.ap,"checker");
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
