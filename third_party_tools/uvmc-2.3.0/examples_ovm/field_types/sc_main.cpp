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

//---------------------------------------------------------------------
// Title: SC Type Support
//
// This example defines and uses a transaction that declares as members
// each of the data types supported for cross-language transfer by UVMC.
// The example consists of the following classes and functions:
//---------------------------------------------------------------------

#include "systemc.h"
#include "tlm.h"
#include <vector>
#include <list>
#include <map>
#include <string>

using std::vector;
using std::list;
using std::map;
using std::string;

#include "sub_object.cpp"

//---------------------------------------------------------------------
// Class: Packet
//
// First, we define a transaction class, ~Packet~, declaring an
// instance of each supported data type for UVMC transfer. It contains
// the following fields:
// 
// integrals - bool, char, short, int, long long, and their unsigned
//           counterparts.
//
// enum    - user-defined enumeration types packed by their numeric
//           value. A compatible enumeration type must be defined on
//           the SV side.
//
// reals   - float and double translate to shortreal and real,
//           respectively.
//
// strings - terminated with the NULL character. Use vector<char> for
//           an array of bytes whose elements can include the '0' value
//
// arrays  - fixed arrays, and STL vector<T>, list<T>, and map<KEY,T>
//           are supported as long as T and KEY are also supported.
//           These types are similar to the SV queue, dynamic array,
//           and associate array types, respectively. Be sure to
//           #include the definitions and declare you're 'using' any
//           STL types in your transaction.
//
// time    - packed as 64-bit values. Equates to the SV 'time' type.
//
// sc data types - sc_bit, sc_logic, sc_bv<N>, sc_lv<N>, sc_int<N>,
//           sc_uint<N>, sc_bigint<N>, and sc_biguint<N>, for any valid
//           width, N. These translate to bit and logic vectors on the
//           SV side.
//
// Here is the complete definition of our SC-side Packet class. Note
// that it does not inherit from any base class. 
//---------------------------------------------------------------------

//(begin inline source)
class Packet {

  public:
    enum cmds_t { ADD, SUBTRACT, MULTIPLY, DIVIDE };

    cmds_t             enum32;  // Enumerations

    long long          int64;   // Signed integrals
    int                int32;
    short              int16;
    char               int8;
    bool               int1;

    unsigned long long uint64;  // Unsigned integrals
    unsigned int       uint32;
    unsigned short     uint16;
    unsigned char      uint8;
    bool               uint1;

    double             real64;

    sc_time            time64;  // Time

    string             str;     // Strings

    int                arr[3];  // Arrays
    vector<char>       q;
    list<short>        da;
    map<short,short>   aa;

    sub_object         obj;     // Sub-objects

    sc_bit             scbit;   // SystemC data types
    sc_logic           sclogic;
    sc_bv<17>          scbv;
    sc_lv<35>          sclv;
    sc_int<6>          scint;
    sc_uint<25>        scuint;
    sc_bigint<37>      scbigint;
    sc_biguint<62>     scbiguint;
};
//(end inline source)



#include "uvmc.h"
using namespace uvmc;

//---------------------------------------------------------------------
// Class: uvmc_converter<Packet>
//
// Next, we defined a template specialization of uvmc_converter<T> for
// our <Packet> type. This class defines <do_pack> and <do_unpack>
// methods that convert our <Packet> using the ~uvmc_packer~ object
// passed as an argument. Unlike in SV, we are defining packing and
// unpacking functionality in a separate class and not as methods
// of the <Packet> itself. This allows us to define custom packing
// algorithms, or "policies", without having to subtype the Packet
// class.
//---------------------------------------------------------------------

template <>
class uvmc_converter<Packet> {

  public:

    // Function: do_pack
    //
    // Serializes the packet ~t~ using the provided ~uvmc_packer~
    // argument, ~packer~.
    //
    // ~All fields are "streamed" into the packer object using
    // operator<<, which the packer defines for each of of the
    // supported data types.~
    //
    // In effect, we are packing our object just as you might
    // print your object contents to ~cout~. Instead of streaming
    // to ~cout~, you are streaming to the ~packer~. Thus the process
    // of packing an object is easy. You need only ensure that
    // the field order of packing and unpacking are the same for the
    // converters on both sides of the language boundary.
    //
    // The resulting bits are retained by the
    // ~packer~ for subsequent extraction and transfer to SV.
    //
    // The bits representing the serialized transaction will be
    // transferred to SV, preloaded into a SV packer object, then
    // unpacked via a compatible ~unpack~ operation in SV.
    //
    // This example packs all members with one statement. You may
    // need to split into several statements, e.g.  when conditionally
    // packing sub-objects.
    //
    // When packing sub-objects, you must first pack a 4-bit value as
    // follows
    //
    //   0 - if the sub-object is NULL or is not to be packed
    //   1 - if the sub-object is non-NULL and packed.
    //
    // If you pack a '1' as above, then pack the sub-object by calling
    //
    //| uvmc_conveter<obj type>::do_pack(packer);

    //(begin inline source)
    static void do_pack(const Packet &t, uvmc_packer &packer)
    {
      packer
        << t.enum32
        << t.int64  << t.int32   << t.int16  << t.int8  << t.int1
        << t.uint64 << t.uint32  << t.uint16 << t.uint8 << t.uint1
        << t.scbit  << t.sclogic << t.scbv   << t.sclv
        << t.scint  << t.scuint  << t.scbigint << t.scbiguint
        << t.time64 << t.real64
        << t.str << t.arr << t.q << t.da << t.aa;

      // pack object:
      packer << (sc_bv<4>(1));
      uvmc_converter<sub_object>::do_pack(t.obj, packer);

    }
    //(end inline source)


    // Function: do_unpack
    //
    // Extracts a serialized version of a packet into the given <Packet>
    // object. The bits representing the serialized transaction have
    // been packed via a compatible ~do_pack~ operation, transferred
    // across the language boundary if necessary, then preloaded into
    // the ~packer~ object before this function is called.
    //
    // ~All fields are "streamed" out of the packer object using
    // operator>>, which the packer defines for each of of the
    // supported data types.~
    //
    // In effect, we are unpacking into a Packet object just as you might
    // stream Packet contents from ~cin~. Instead of streaming from
    // ~cin~, you are streaming from the ~packer~. Thus, the process
    // of unpacking into an object is easy. You need only ensure that
    // the field order of packing and unpacking are the same for the
    // converters on both sides of the language boundary.
    //
    // When unpacking sub-objects, you first unpack a 4-bit value and
    // interpret as follows
    //
    //   0 - set the sub-object to NULL
    //   1 - unpack the sub-object by calling
    //       ~uvmc_conveter<type>::do_unpack~
    //
    // This example unpacks all members with one statement. You may
    // need to split into several statements, e.g.  when conditionally
    // unpacking sub-objects.

    //(begin inline source)
    static void do_unpack(Packet &t, uvmc_packer &packer)
    {
      packer
        >> t.enum32
        >> t.int64  >> t.int32   >> t.int16  >> t.int8  >> t.int1
        >> t.uint64 >> t.uint32  >> t.uint16 >> t.uint8 >> t.uint1
        >> t.scbit  >> t.sclogic >> t.scbv   >> t.sclv
        >> t.scint  >> t.scuint  >> t.scbigint >> t.scbiguint
        >> t.time64 >> t.real64
        >> t.str >> t.arr >> t.q >> t.da >> t.aa;

      sc_bv<4> is_null;
      packer >> is_null;
      if (is_null != 0)
        uvmc_converter<sub_object>::do_unpack(t.obj, packer);

    }

}; // uvmc_conveter<Packet>

//(end inline source)



//---------------------------------------------------------------------
// Class: uvmc_print<Packet>
//
// A template specialization of uvmc_print<T>, this class is used by
// <operator<<(ostream,Packet)> to print the contents of a <Packet>.
//
// The <print> method is the entry point; it calls <do_print>, which
// performs the actual streaming.
//
// An overload of non-member function, ~operator<<~, for the ~ostream~
// is defined for <Packet> types. Its implementation calls this class'
// <print> method.
//
// With these defined, any <Packet> object can be output as follows
//
//| #include <iostream>
//| using std::ostream;
//| using std::cout;
//| 
//| Packet t;
//| ...
//| cout << t << endl;
//
//---------------------------------------------------------------------

  // Function: do_print
  //
  // Streams the data members of the <Packet> object ~t~ to the
  // provided output stream ~os~, which defaults to the standard output
  // stream, ~cout~.
  //
  // All data members, including sub-objects, must have
  // ~operator<<(ostream&)~ defined. This is true for all C++ and SC
  // built-in types. The UVMC library provides ~operator<<(ostream&)~
  // for the STL ~vector<T>~, ~list<T>~, and ~map<KEY,T>~ types. 
  //
  // Infinite recursion through self-reference is not caught. You are
  // responsible for making sure sub-objects, if streamed, do not
  // refer to an object already streamed.
  //
  // Although example streams all members with one statement, you may
  // split the task into as many statements as you like.

  //(begin inline source)
template <>
class uvmc_print<Packet> {
  public:

  static void do_print(const Packet& t, ostream& os=cout) {
        os << " enum32:" << t.enum32
           << " int64:"  << t.int64
           << " int32:"  << t.int32
           << " int16:"  << t.int16
           << " int8:"   << t.int8
           << " int1:"   << t.int1
           << " int64:"  << t.uint64
           << " int32:"  << t.uint32
           << " int16:"  << t.uint16
           << " int8:"   << t.uint8
           << " int1:"   << t.uint1
           << " scbit:"  << t.scbit
           << " sclogic:"<< t.sclogic
           << " scbv:"   << t.scbv
           << " sclv:"   << t.sclv
           << " scint:"  << t.scint
           << " scuint:"    << t.scuint
           << " scbigint:"  << t.scbigint
           << " scbiguint:" << t.scbiguint
           << " time64:" << t.time64
           << " real64:" << t.real64
           << " str:"    << t.str
           << " arr:"    << t.arr
           << " q:"      << t.q
           << " da:"     << t.da
           << " aa:"     << t.aa
           << " obj:"    << t.obj;
  }
  //(end inline source)

  // Function: print
  //
  // The entry point for printing our Packet. We output a brace, {,
  // then call <do_print>, then output a closing brace, }. This
  // structure prevents superfluous braces for transactions inheriting
  // from base classes with fields. See the Converters examples set
  // to see examples of converters and printers for transactions with
  // base classes.

  //(begin inline source)
  static void print(const Packet& t, ostream& os=cout) {
    os << "'{";
    do_print(t,os);
    os << " }";
  }

};
//(end inline source)


//---------------------------------------------------------------------
//
// Class: operator<<(ostream,Packet)
//
//---------------------------------------------------------------------
//
// We next defines ~operator<< (ostream&)~ for <Packet> types, enabling
// us to output Packet objects to cout and other output streams. Our
// <Consumer> uses ~operator<<~ to output Packets it receives.
// 
// Example usage
//
//| #include <iostream>
//| using std::ostream;
//| using std::cout;
//| 
//| Packet t;
//| ...
//| cout << t << endl;

//(begin inline source)
ostream& operator << (ostream& os, const Packet& v) {
  uvmc_print<Packet>::print(v,os);
}
//(end inline source)


//---------------------------------------------------------------------
// Class: Consumer
//
// Defines a simple consumer of <Packets>. Each packet it gets is printed
// and sent out its ~analysis_out~ port.
//---------------------------------------------------------------------

//(begin inline source)
using namespace sc_core;
using namespace tlm;

class Consumer : public sc_module,
                 public tlm_blocking_put_if<Packet> {

  public:
  sc_export<tlm_blocking_put_if<Packet> > in;

  tlm_analysis_port<Packet> analysis_out;

  Consumer(sc_module_name nm) : in("in"),
                                analysis_out("analysis_out")
  {
    in(*this);
  }

  virtual void put(const Packet &t) {

    cout << sc_time_stamp()
         << " SC consumer executing packet:" << endl
         << "  " << t << endl;

    wait(123,SC_NS);

    analysis_out.write(t);
  }
};
//(end inline source)


//---------------------------------------------------------------------
// Class: sc_main
//
// Finally, in ~sc_main~, we simply instantiate a <Consumer> of
// <Packets>, register tUVMC connections to its ~in~ export and
// ~analysis_out~ port, then start SC simulation. A SV-side producer
// will drive this consumer with transactions once SV's reaches its
// ~run_phase~.
//
//---------------------------------------------------------------------


//(begin inline source)
int sc_main(int argc, char* argv[]) 
{  
  Consumer cons("consumer");

  uvmc_connect(cons.in,"foo");
  uvmc_connect(cons.analysis_out,"bar");

  sc_start();
  return 0;
}
//(end inline source)



