
--------------------------------------------------------------------------------
Title: Converters
--------------------------------------------------------------------------------

This chapter shows how to write converters for your transactions.
Converters facilitate data exchange between components residing in different
languages.

If components were written in a common language, you could guarantee they
exchanged compatible data simply by requiring they use the same transaction
type. Such components are ~strongly typed~. Any mismatch in type would be
caught by the compiler.

Now let's say two components were developed such that each agreed more or less
on the content of the transaction, but this time their transaction definitions
were of different types. This condition always the case between components
written in two different languages--they cannot possibly share a common
transaction definition. To get such components talking to each other requires
an adapter, or converter, that translates between the transaction types
defined in each language.


Topic: Got Transactions?
------------------------

UVM Connect imposes very few requirements on the transaction types being
conveyed between TLM models in SV and SC, a critical requirement for enabling
reuse of existing IP. The more restrictions imposed on the transaction type,
the more difficult it will be to reuse the models that use them. 

- No base classes required.
It is not required that a transaction inherit from any base class to
facilitate its conversion--in either SV or SC. The converter is ultimately
responsible for all aspects of packing and unpacking the transaction object,
and it can be implemented separately from the transaction proper.

- No factory registration required.
It is not required that the transaction register with a factory--via a
~`ovm_object_utils~ macro inside the transaction definition or by any other
means. 

- It is not required that the transaction provide conversion methods.
The default converter used in SV will expect the transaction type to implement
the OVM pack/unpack API, but you can specify a different converter for each or
every UVMC connection you make. Your converter class may opt to do the conversion
directly, or it can delegate to any other entity capable of performing the
operation.

- It is not required that the members (properties) of the transaction classes
in both languages be of equal number, equivalent type, and declaration order.
The converter can adapt disparate transaction definitions at the same time
it serializes the data. The following are valid and compatible UVM Connect
transaction definitions, assuming a properly coded converter:

|SV	                           SC
|class C;                          struct C {
|  cmd_t cmd;                        long addr;
|  shortint unsigned address;        vector<char> data;
|  int payload[MAX_LEN];             bool write;
|endclass                          };

- In OVM SV, it is required that the transaction class constructor not
define any required arguments. It may have arguments, but they all must
have default values. The first constructor argument must be ~string name=""~.


Topic: Do You Need a Converter?
-------------------------------

UVM Connect supports only TLM1 communication with OVM, so you will always
need to define a converter for your transaction types.

To enable transaction object transfer across the SV-SC boundary, you must define
converters in both SC and SV. UVM Connect makes this an easy process.

Defining a converter involves implementing two functions--~do_pack~ and
~do_unpack~--either inside your transaction definition or in a separate
converter class.  Although the means of conversion are similar between SV
and SC, differences in these languages capabilities translate to differences
in conversion. 

The following sections describe several options available to you for writing
converters in SV and SC.



--------------------------------------------------------------------------------

Group: SV Conversion options

--------------------------------------------------------------------------------

Here, we enumerate three different ways to define conversion functionality for
your transaction type in SV.

We illustrate each of these options using the following packet definition.

SV Transaction:

| class packet extends ovm_sequence_item;
| 
|   typedef enum { WRITE, READ, NOOP } cmd_t;
|
|   `ovm_object_utils(packet)
| 
|   rand cmd_t cmd;
|   rand int   addr;
|   rand byte  data[$];
|   ...
|
| endclass


Topic: In-Transaction
---------------------

This approach defines the conversion algorithm in transaction class itself.

(see UVMC_Converters_SV_InTrans.png)

A transaction in OVM is derives from ~ovm_sequence_item~, which defines the
~do_pack~ and ~do_unpack~ virtual methods for users to implement the conversion
functionality.  This option is the recommended option for SV-based transactions.

To use this approach, you declare and define overrides for the virtual ~do_pack~
and ~do_unpack~ methods in your transaction class.

  | virtual function void do_pack   (uvmc_packer packer);
  | virtual function void do_unpack (uvmc_packer packer);

Most transactions in SV should be defined this way, as it is prescribed by OVM
and it works with UVM Connect's SV default converter. See <Default Converters>
for details.

When implementing the ~do_pack~ and ~do_unpack~ methods, you call various
methods of the provided ~packer~ object. See OVM documentation for details.

The following packs an ~addr~ field using each approach. Our example above uses
the small-macro approach.

| virtual function void do_pack(ovm_packer packer);
|
|     packer.pack_field_int(addr,$bits(addr));
|
| endfunction



Topic: Converter Class
----------------------

For transactions not extending ~ovm_sequence_item~, you can define a separate
converter class extending ~uvmc_converter #(T)~. You then specify this converter
type when calling <The Connect Function>.

(see UVMC_Converters_SV_UserDefined.png)

The following SV packet definition implements the ~do_pack~ and ~do_pack~
methods required of any custom converter. OVM does not provide the convenience
macros you get in UVM (although you are free to #include them if you wish).
Here, we use ~packer~ functions like ~pack_field_int~ to pack/unpack 
individual transaction members.
See <UVMC Converter Example - SV Converter Class> for a complete example.

| class convert_packet extends uvmc_converter #(packet);
| 
|    static function void do_pack(packet t, ovm_packer packer);
|      packer.pack_field_int(t.cmd,32);
|      packer.pack_field_int(t.addr,32);
|      packer.pack_field_int(t.data.size(),32);
|      foreach (t.data[i])
|        packer.pack_field_int(t.data[i],8);
|    endfunction
| 
|    static function void do_unpack(packet t, ovm_packer packer);
|       int sz;
|       t.cmd = packet_base::cmd_t'(packer.unpack_field_int(32));
|       t.addr = packer.unpack_field_int(32);
|       sz = packer.unpack_field_int(32);
|       t.data.delete();
|       for (int i=0; i < sz; i++)
|         t.data.push_back( packer.unpack_field_int(8) );
|    endfunction
| 
|  endclass


To use the above converter for a specific TLM connection, specify its type
when making connection using <The Connect Function>.

| uvmc_tlm1 #(.T1(packet), .T1_CVRT(convert_packet))::connect( ... );



Topic: Field Macros
-------------------

This approach defines in-transaction conversion via ~`ovm_field~ macro
invocations.

(see UVMC_Converters_SV_InTrans.png)

While this approach also works with UVMC's default converter, it is far
less desirable than the first <In-Transaction> option. The ~`ovm_field~
macros provide a convenient means of implementing the ~do~ methods of
~ovm_object~ for most data types, but they have recurring run-time costs
and should be avoided, especially if your transaction is slated for widespread
reuse, as with VIP-related transactions.

As with the <In-Transaction> approach, this method is compatible with the
default converter UVMC uses, so you will not need to specify the converter
type when making connections with <The Connect Function>.
See <UVMC Converter Example - SV In-Transaction via Field Macros> for a
complete example of using this approach.

| class packet extends ovm_sequence_item;
| 
|   rand cmd_t cmd;
|   rand int unsigned addr;
|   rand byte data[$];
| 
|   constraint C_data_size { data.size inside {[1:16]}; }
| 
|   `ovm_object_utils_begin(packet)
|     `ovm_field_int(cmd,OVM_ALL_ON)
|     `ovm_field_int(addr,OVM_ALL_ON)
|     `ovm_field_queue_int(data,OVM_ALL_ON)
|   `ovm_object_utils_end
| 
|   function new(string name="");
|     super.new(name);
|   endfunction
| 
| endclass

While more succinct than our <In-Transaction> recommendation, we prefer
optimizing for recurring run-time performance over one-time coding convenience.
The macros' run-time performance is inferior, which affects every
user of your transaction class in every simulation. Even small performance
differences can be magnified and significantly affect the upper bound on
performance speed-up with accelleration or emulation hardware. And, as stated
before, post-macro-expansion yields hundreds more lines of code compared to
implementations that do not employ the ~`ovm_field~ macros. You may eventually
have to wade through this code during your debug sessions.
See http://verificationacademy.com/uvm-ovm/MacroCostBenefit for more detail
on the topic of macro usage in OVM and UVM.



--------------------------------------------------------------------------------

Group: SC Conversion Options

--------------------------------------------------------------------------------

Conversion of the transaction type in SC can be defined in at least four ways.

We illustrate each of these options using the following packet definition.

SC Transaction:

| class packet {
|   public:
|   enum cmd_t { WRITE=0, READ, NOOP };
|   cmd_t cmd;
|   int addr;
|   vector<char> data;
| };  

This transaction has no base class, no methods for packing or unpacking,
no macros, etc. It is a simple container of data representing a bus transaction.


With SystemC, you are more easily able to decouple the transaction data from the
algorithms that operate on the data. The SC transaction and converter
definitions are typically in separate classes. Existing transaction definitions
in SC can be used in a UVM Connect context by defining converters for them.

An external converter class requires that all transaction fields be public or
have public accessor member functions. The ~friend~ construct in C++ lets you
circumvent this protection, but it is not recommended. 


Topic: Converter Specialization
-------------------------------

Define a separate class for converting your transaction type.

In SC, conversion for a transaction is typically defined in a separate class
called a ~template specialization~. C++ allows you to specialize the
default converter implementation for a specific transaction type, ~T~.

(see UVMC_Converters_SC_UserDefined.png)

The converter specialization for our ~packet~ type can be defined as follows

| #include "uvmc.h"
| using namespace uvmc;
| 
| template <>
| class uvmc_converter<packet> {
|   public:
|   virtual void do_pack(const packet &t,
|                        uvmc_packer &packer) {
|     packer << t.cmd << t.addr << t.data;
|   }
|   virtual void do_unpack(packet &t,
|                          uvmc_packer &packer) {
|     packer >> t.cmd >> t.addr >> t.data;
|   }
| };
  

When implementing the converter's ~do_pack~ and ~do_unpack~ functions, you
stream your transaction members to and from the ~packer~ variable, an
instance of ~uvmc_packer~ that is inherited from an internal base class.

To pack, you stream the fields into the ~packer~

| packer << t.cmd << t.addr << t.data;

To unpack, you stream the fields from the ~packer~

| packer >> t.cmd >> t.addr >> t.data;

You can stream all the fields with one statement as shown above, or stream
in separate statements, perhaps with some conditional and other code
in between.

| packer << t.cmd;
| ...
| packer << t.addr;
| ...
| packer << t.data;

With this approach, you will not need to specify the ~CVRT~ type parameter
when calling <The Connect Function>. Your converter is automatically chosen
by the compiler as an override (specialization) of the default converter.
See <UVMC Converter Example - SC Converter Class> for a complete example of
using this approach.

See <Converter Specialization, Macro-Generated>, next, for an approach that
auto-generates the above converter specialization.



Topic: Converter Specialization, Macro-Generated
------------------------------------------------

Invoke a convenience macro that defines the converter specialization for you.

(see UVMC_Converters_SC_UserDefined.png)

The easist way to define a converter in SC is to invoke one of the <UVMC_UTILS>
macros. Using this option, our conversion class definition reduces to:

| #include "uvmc.h"
| using namespace uvmc;
| 
| UVMC_UTILS_3 (packet,cmd,addr,data)

That's it. The ~UVMC_UTILS_3~ macro expands into the converter specialization
defined in <Converter Specialization>, exactly. These macros are the "good"
macros; they expand into efficient, readable code exactly as you would write it.
See <UVMC Converter Example - SC Converter Class, Macro-Generated> for a complete
example of using this approach.

Keep the following in mind when using the UTILS macros

-  The number suffix in the macro name indicates the number of members of
   the class being converted. UVMC supports up to 20 field members, i.e. up
   to UVMC_UTILS_20.

- The macros only support types for which the ~uvmc_packer~ defines the
  << and >> operators. These include all C++ built-in types, strings,
  vectors, maps, and the SC types ~sc_bit~, ~sc_logic~, ~sc_bv<N>~,
  ~sc_lv<N>~, ~sc_int<N>~, ~sc_uint<N>~, ~sc_unsigned<N>~, and ~sc_time~. 
  See <UVMC Type Support> for details.

- The UTILS macros also define the ~operator<<~ to the output stream for
  your transaction. This allows you to stream your transaction contents to
  ~cout~ and other output streams.

  | packet p;
  | ...
  | cout << "Packet p contents are: " << p << endl;

- The UTILS definition of ~operator<<~ to the output stream may interfere
  with other functions that define ~operator<<(&ostream)~. In this case, use
  a <UVMC_CONVERT> macro instead of the <UVMC_UTILS> macro. The convert
  macros only define the converter specialization. They also support up
  to 20 field members.

- All fields named in the UTILS macro invocation must be public members of
  the transaction. If they are not, and these members have accessor functions,
  you can still define an external converter via <Converter Specialization>
  without the macros.




Topic: In-Transaction - SC
--------------------------

Define ~do_pack~ and ~do_unpack~ methods in the SC transaction itself.

Although this option works with SC's default converter, it is not recommended
because it hard-codes the transaction to a particular packing and unpacking
algorithm. Keeping the conversion functionality separate allows you to apply
different conversion algorithms without having to modify or derive new transaction
subtypes.

(see UVMC_Converters_SC_InTrans.png)

The following ~packet~ transaction definition provides both the content and
conversion routines for the transaction. Because it is compatible with the
default SC-side converter, you will not be required to specify converter class
when connection with <The Connect Function>.
See <UVMC Converter Example - SC In-Transaction> for a complete
example of using this approach.

| class packet;
|
|   public:
|   enum cmd_t { WRITE=0, READ, NOOP };
|
|   cmd_t cmd;
|   int addr;
|   vector<char> data;
| 
|   virtual void do_pack(uvmc_packer &packer) const {
|     packer << t.cmd << t.addr << t.data;
|   }
|   virtual void do_unpack(uvmc_packer &packer) {
|     packer >> t.cmd >> t.addr >> t.data;
|   }
| };
  


Topic: Custom Adaptor
---------------------

Define a custom converter for a transaction whose members differ in number,
type, size, and declaration order from the corresponding transaction
definition in the other language.

(see UVMC_Converters_SC_UserDefinedAdapter.png)

With UVMC support for a separate converter class, you are not limited to
member-by-member, bit-compatible packing and unpacking.
The only requirement is that the two sides' conversion routines agree on
what and how data are represented in the bits being sent across
the language boundary.

Thus, an array of four ~bytes~ in SV can be converted to a single ~unsigned int~ 
in SC.  A single ~longint~ in SV can be mapped to many possible combinations of
the SC integrals: ~int[2]~, ~char[8]~, ~vector<char>~, ~sc_bit<64>~,
~sc_int<64>~, etc. See <UVMC Converter Example - SC Adapter Class> for a complete
example of using a "full-custom" approach to transaction conversion.



--------------------------------------------------------------------------------

Group: Notes

--------------------------------------------------------------------------------


Topic: Type Support
-------------------

UVM Connect supports most of the built in types, arrays, and even sub-objects
as properties of your transaction class.

The ~uvmc_packer~ supports packing and unpacking the following types

- bool
- char, unsigned char
- short, unsigned short
- int, unsigned int
- long, unsigned long
- long long, unsigned long long
- float
- double
- sc_bit
- sc_logic
- sc_bv<N>
- sc_int<N>
- sc_uint<N>
- sc_bigint<N>
- sc_biguint<N>
- enums
- T[N], where T is one of the above types
- vector<T>, where T is one of the above types
- list<T>, where T is one of the above types
- map<KEY,T>, where KEY and T are among the above types


See <UVMC Type Support> for more detail and examples.


Topic: On (not) using `ovm_field macros
---------------------------------------

The ~`ovm_field~ macros hurt run-time performance, can make debug more difficult,
and can not accomodate custom behaviors, for example, conditional packing based on
the value of another field.

In UVM 1.1a and prior, ~uvm_tlm_generic_payload~ uses the ~`uvm_field~ macros,
whose implementation comes from the ~`ovm_field~ macros.
Its definition expands into almost ~600~ lines of code, and it's wrong. The
data and data_enable arrays should be packed according to the length and
~byte_enable_length~ fields, but the field macros do not accommodate this.
They pack the entire data and byte_enable buffers, even if one one byte is
valid. To speed up performance and fix data and byte array handling, the
`ovm_field macros were replaced with direct implementations of the ~do_~
methods (pack, unpack, copy, compare, etc.) in UVM 1.1b.
See http://verificationacademy.com/uvm-ovm/MacroCostBenefit
for more on macro costs in OVM and UVM.



Topic: Packing Algorithm
------------------------

To pass an object across the language boundary, UVM Connect first calls
~converter.do_pack~, which serializes the transaction contents to a simple
bit-vector-like form. Upon return, your transaction's canonical representation
will be stored inside the converter. UVM Connect retrieves and passes this
canonical data across the language boundary using standard DPI-C.

On the target side, UVM Connect will unpack the canonical data into a new
transaction object in the other language. To do this, UVM Connect first loads
the data into the target-side converter. It then creates a new corresponding
transaction object and passes it to converter.do_unpack, which does the reverse
operation as pack. The converter unpacks the canonical data into the new
transaction object, effectively reconstituting the original transaction object
in the other language. This resulting transaction is then sent to the connected
TLM target. 

On the SV side, the default converter's implementations of ~do_pack~ and
~do_unpack~ delegate the work to the pack and unpack methods of your
~ovm_object~-based transaction. If your transaction is not based on
~ovm_object~ (or ~ovm_sequence_item~), or if your transaction object does
not implement ~do_pack~ and ~do_unpack~, you must define a converter
for that transaction. 

Like the SV side, the default converter on the SC side delegates to ~do_pack~
and ~do_unpack~ methods of the transaction object, ~T~. However, SC-side transactions
typically do not implement an OVM or UVM-compatible pack/unpack interface. In most
cases, you will need to define a converter for each transaction type in SC.
Fortunately, the UVM Connect library makes this very easy.



Topic: Conversion on the return path
------------------------------------

TLM1 communication is a pass-by-value message passing mechanism, so no
conversion back to the original request object is done on the return path.



Topic: Deletion on the return path
----------------------------------

TLM1 communication is a pass-by-value message passing mechanism, so the proxy
transaction object on the target side is deleted (SC) or left for garbage
collection (SC) upon return from the target.



--------------------------------------------------------------------------------

Group: Default Converters

--------------------------------------------------------------------------------

UVM Connect defines default converters in both SV and SC

All converters define ~do_pack~ and ~do_unpack~ static methods. UVMC calls
upon these methods to convert an object into a form that can be transferred
across the language boundary. UVMC defines default implementations of the
converter, one each for SV and SC. 


Topic: Default SV Converter
---------------------------

The default converter on the SV side is designed to work with ~ovm_object~-based
OVM transactions. It delegates the actual work to the ~pack~ and ~unpack~ methods in
the transaction, which in turn call the virtual user-defined methods, ~do_pack~ and
~do_unpack~.

| class uvmc_default_converter #(type T=int)
|                       extends uvmc_converter #(T);
| 
|  static function void do_pack(T t, ovm_packer packer);
|     t.pack(packer); // calls t.do_pack
|  endfunction
| 
|  static function void do_unpack(T t, ovm_packer packer);
|     t.unpack(packer); // calls t.do_unpack
|   endfunction
| 
| endclass

Our ~packet~ definition for the <In-Transaction> approach is compatible with
the default SV converter. This converter, as well as any custom converters
you may define, are required to extend from ~uvmc_converter #(your_trans_type)~.


Topic: Default SC Converter
---------------------------

The default converter on the SC side is meant to mirror the default in SV--it
delegates to ~do_pack~ and ~do_unpack~ methods of your transaction type. 

| template <typename T>
| class uvmc_converter {
|   public:
| 
|   static void do_pack(const T &t, uvmc_packer &packer) {
|     t.do_pack(packer);
|   }
| 
|   static void do_unpack(T &t, uvmc_packer &packer) {
|     t.do_unpack(packer);
|   }
| };


Most SC transaction definitions won't use this default converter. Instead,
a <Converter Specialization> is defined to handle your specific transaction
type. The C++ compiler will then automatically
choose your specialized definition over the default converter.


Topic: Converter Parameters and Methods
---------------------------------------

The following describes the type parameters and methods of the converter class.

Parameters:

T     - The transaction type to be converted. The default converters
        requires T to provide the packing and unpacking functionality in
        ~do_pack~ and ~do_unpack~ methods.


Methods:

do_pack   - Packs the given object of type T. The default implementation
            in SV requires T be derived from ovm_object, whose ~do_pack~
            implementation or ~`ovm_field~ macros provide the packing
            functionality. The default implementation in SC requires T
            implement a ~do_pack~ method with the following prototype:

            | void pack void do_pack (uvmc_packer &packer) const;

do_unpack - Unpacks into given object of type T. The default implementation
            in SV requires T be derived from ovm_object, whose do_unpack
            implementation or `ovm_field macros provide the unpacking
            functionality. The default implementation in SC requires T
            implement an ~do_unpack~ method with the following prototype:

            | void do_unpack (uvmc_packer &packer);


--------------------------------------------------------------------------------

Group: Converter Examples

--------------------------------------------------------------------------------

The directory ~UVMC_HOME/examples/converters~  contains several examples of
transaction conversion in both SystemC (SC) and SystemVerilog (SV) 

How a transaction is converted on one side does not effect your options
on the other side. With four ways to convert a transaction in SC and three
ways to do this in SV, there are a total of 12 combinations.  We provide
an example for each of these 12 combinations.

See <Getting Started> for setup requirements for running the examples.
Specifically, you will need to have precompiled the OVM and UVMC
libraries and set environment variables pointing to them.

Use ~make help~ to view the menu of available examples

|> make help

You'll get a menu similar to the following

|  -----------------------------------------------------------------
| |                  UVMC EXAMPLES - CONVERTERS                     |
|  -----------------------------------------------------------------
| |                                                                 |
| | Usage:                                                          |
| |                                                                 |
| |   make [OVM_HOME=path] [UVMC_HOME=path] <example>               |
| |                                                                 |
| | where <example> is one or more of:                              |
| |                                                                 |
| |   ex01 : SV conversion done in OVM transaction                  |
| |          SC conversion done in macro-generated converter class  |
| |                                                                 |
| |   ex02 : SV conversion done in OVM transaction                  |
| |          SC conversion done in separate converter class         |
| |                                                                 |
| |   ex03 : SV conversion done in OVM transaction                  |
| |          SC conversion done in transaction                      |
| |                                                                 |
| |   ex04 : SV conversion done in OVM transaction via field macros |
| |          SC conversion done in macro-generated converter class  |
| |                                                                 |
| |   ex05 : SV conversion done in OVM transaction via field macros |
| |          SC conversion done in separate converter class         |
| |                                                                 |
| |   ex06 : SV conversion done in OVM transaction via field macros |
| |          SC conversion done in transaction                      |
| |                                                                 |
| |   ex07 : SV conversion done in separate converter class;        |
| |                  transaction is not based on ovm_object         |
| |          SC conversion done in macro-generated converter class  |
| |                                                                 |
| |   ex08 : SV conversion done in separate converter class;        |
| |                  transaction is not based on ovm_object         |
| |          SC conversion done in separate converter class         |
| |                                                                 |
| |   ex09 : SV conversion done in separate converter class;        |
| |                  transaction is not based on ovm_object         |
| |          SC conversion done in transaction                      |
| |                                                                 |
| |   ex10 : SV conversion done in OVM transaction                  |
| |          SC-side implements converter that converts and adapts  |
| |                  to an otherwise incompatible transaction type  |
| |                                                                 |
| |   ex11 : SV conversion done in OVM transaction via field macros |
| |          SC-side implements converter that converts and adapts  |
| |                  to an otherwise incompatible transaction type  |
| |                                                                 |
| |   ex12 : SV-side implements converter in separate class;        |
| |                  transaction is not based on ovm_object         |
| |          SC-side implements converter that converts and adapts  |
| |                  to an otherwise incompatible transaction type  |
| |                                                                 |
| | OVM_HOME and UVMC_HOME specify the location of the source       |
| | headers and macro definitions needed by the examples. You must  |
| | specify their locations via OVM_HOME and UVMC_HOME environment  |
| | variables or make command line options. Command line options    |
| | override any envrionment variable settings.                     |
| |                                                                 |
| | The OVM and UVMC libraries must be compiled prior to running    |
| | any example. If the libraries are not at their default location |
| | (UVMC_HOME/lib) then you must specify their location via the    |
| | OVM_LIB and/or UVMC_LIB environment variables or make command   |
| | line options. Make command line options take precedence.        |
| |                                                                 |
| | Other options:                                                  |
| |                                                                 |
| |   all   : Run all examples                                      |
| |   clean : Remove simulation files and directories               |
| |   help  : Print this help information                           |
| |                                                                 |
| |                                                                 |
|  -----------------------------------------------------------------

To run just one example

|> make ex01

This compiles and runs Example 1, which demonstrates the recommended  
converter implementation option in both SC and SV. The OVM source
location is defined by the ~OVM_HOME~ environment variable, and the
OVM and UVMC compiled libraries are searched at their default
location, ~../../lib/uvmc_lib~.

To run all examples

  |> make all

The ~clean~ target deletes all the simulation files produced from
previous runs.

  |> make clean

You can combine targets in one command line

  |> make clean ex03

The following runs the 'ex10' example, providing the path to the
OVM source and compiled library on the ~make~ command line.

  |> make OVM_HOME=<path> OVM_LIB=<path> ex10


| //------------------------------------------------------------//
| //   Copyright 2009-2012 Mentor Graphics Corporation          //
| //   All Rights Reserved Worldwid                             //
| //                                                            //
| //   Licensed under the Apache License, Version 2.0 (the      //
| //   "License"); you may not use this file except in          //
| //   compliance with the License.  You may obtain a copy of   //
| //   the License at                                           //
| //                                                            //
| //       http://www.apache.org/licenses/LICENSE-2.0           //
| //                                                            //
| //   Unless required by applicable law or agreed to in        //
| //   writing, software distributed under the License is       //
| //   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR   //
| //   CONDITIONS OF ANY KIND, either express or implied.  See  //
| //   the License for the specific language governing          //
| //   permissions and limitations under the License.           //
| //------------------------------------------------------------//
