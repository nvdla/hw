
--------------------------------------------------------------------------------

Title: UVMC Type Support

--------------------------------------------------------------------------------

The members of your transaction definitions may be any collection of the
following types, which have direct support in UVMC. For any type not listed,
there is likely a supported type to which your converter can adapt.


Group: Supported Data Types	

The following types are supported by UVMC for packing and unpacking via
the streaming operators.

| SV	             |   SC
|
| longint            |   long long
| int                |   int
| shortint           |   short
| byte               |   char
| bit                |   bool
|                    |
| longint unsigned   |   unsigned long long
| int unsigned       |   unsigned int
| shortint unsigned  |   unsigned short
| byte unsigned      |   unsigned char
| bit unsigned       |   bool
|                    |
| shortreal          |   float
| real               |   double
| string             |   string
| time               |   sc_time
|                    |
| T                  |   T
| T arr[N]           |   T arr[N];
| T q[$]             |   vector<T>
| T da[]             |   list<T>
| T aa[KEY]          |   map<KEY,T>
|                    |
| sc_bit             |   sc_bit
| sc_logic           |   sc_logic
| sc_lv [L:R]        |   sc_lv<N>
| sc_bv [L:R]        |   sc_bv<N>
|                    |
| bit [N-1:0]        |   sc_int<N>
| bit [N-1:0]        |   sc_uint<N>
| bit [N-1:0]        |   sc_bigint<N>
| bit [N-1:0]        |   sc_biguint<N>


Choosing the type mappings:

- Each row in the table shows a ~suggested~ mapping between SV and SC types.
Many other mappings are possible. For example, you can unpack an ~int~
from the source language into many types other than ~int~ in the target
language, ~char[4]~, ~sc_lv<32>~, and ~bit [31:0]~ to name a few.

- Be sure to consider platform dependencies such as 32-bit versus 64-bit,
and big versus little endian.

- When you have the freedom to define an equivalent transaction type from
scratch, you would typically define the transaction to have the same number
of fields with equivalent bit sizes.

- When both of the transaction objects in SV and SC are pre-existing, they
may not have the exact same number of members of equivalent types declared
in the exact same order. With UVM Connect, your ability to define custom
converters allows you to get your models communicating despite the
disparate transaction types.

- Conversion can even span multiple members of the target transaction type.
That int might represent a 32-bit address on the source side, and two
16-bit high/low addresses on the target side.

- Conversion can map between fields of different bit widths. For example,
a 32-bit address can be mapped to a 16-bit address, as long as steps
are taken to avoid truncation of the larger field. 


Usage Limitations: 

Integral size - Each integral field is limited to 4K bits

Total size - Each packed transaction is limited to 4K bytes

Arrays - Supports one dimension only

`ovm_field macros - Instead of implementing the ~do_*~ methods directly,
you may opt to employ the `ovm_field macros, which expand into code that
implements these operations for most types. This is not recommended.
The field macros expand into large amounts of code that affect run-time
performance in every simulation in which they are used.  They limit the
upper-bound on accelleration performance. The code they expand into is
unreadable and may hinder debug should you ever have to step through it.
For details on these and other costs associated with `ovm_field and all
other OVM macros, see the white paper, ~OVM/UVM Macros: A Cost-Benefit Analysis~,
at http://www.verificationacademy.com  


--------------------------------------------------------------------------------
Group: Type-Support Examples

How to run the example demonstrating type support

See <Getting Started> for setup requirements for running the examples.

Use ~make help~ to view the menu of available examples:

|> make help

Choose an example to run from the menu, say

|> make all

This compiles and runs an example demonstrating packing and unpacking of
all directly supported data types allowed as members of your transaction
classes. Other types require conversion to the supported types.


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

