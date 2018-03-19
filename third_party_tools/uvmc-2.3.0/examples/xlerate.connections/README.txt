
--------------------------------------------------------------------------------
Title: Fast packer converters
--------------------------------------------------------------------------------

Topic: Introduction
-------------------

Now that you've read the chapter on ~Converters~ and understand how to
create custom variations of converters and packers, this section shows
2 special types of custom converters called ~fast packers~.

Fast packers are designed to operate specifically on
TLM generic payload (TLM GP) transaction types (i.e.
SV *class uvm_tlm_generic_payload*, SC *class tlm_generic_payload*)
when the application passes them across UVM-Connect'ed sockets.

For the fast packer converter classes, the same technique described
in the previous section for creating custom converter classes was used
to create these particular converters for use on both sides of the
UVM-Connect'ion.

Group: Fast packer features
----------------------------

These "fast packers" add two features in contrast to their ~default converter~
counterparts,

- Improved performance
- Support for TLM generic payloads with no fixed limitations on data
  payload sizes (i.e. unlimited data payloads)

There are two flavors of fast packers,

|   1. class uvmc_xl_converter
|   2. class uvmc_tlm_gp_converter

The same class names were used for both the SV and SC versions of these
classes.

The fast packer converter classes have both been enhanced for better
performance than the default packers, and both support unlimited payloads.
But there are slightly differing semantics for each of the two.

Topic: The class uvmc_xl_converter packer class
-----------------------------------------------

The *class uvmc_xl_converter* conforms in the strictest sense to the required
semantics of the _TLM-2.0 base protocol_ specifically with respect to
_modifiability of attributes_ (see IEEE 1666-2011 section on TLM-2.0 base
protocol), and thus does not indiscriminately transfer all fields of the
generic payload in both directions across the language boundary.

Rather it decides, depending on the mode of the transaction (_READ_ or
_WRITE_), and whether it is being transferred along the _forward_,
_backward_, or _return_ paths, which fields to transfer and which to
leave alone.

For example WRITE transactions do not need to have the address, data, length,
enables and control fields transferred long the return path - only the status.

READ transactions also do not need address, length, enables, transferred along
the return path, only data and status. And furthermore for READs data
does *not* need to be transferred along the forward/backward path (only
return path).

These fine-tuned optimizations, along with some use of ~pass-by-reference~
semantics collectively have maximized the performance purely at the
communication layers of the UVM-Connect'ion.

Additionally the *class uvmc_xl_converter* supports the passing of
TLM GP ~configuration extensions~ that derive from *class uvmc_xl_config*.
See the section on <Configuration extensions> for more details about
how they can be used.

Topic: The class uvmc_tlm_gp_converter packer class
-----------------------------------------------

The *class uvmc_tlm_gp_converter* has the same features of unlimited
payload size and efficient data payload passing techniques that use
"C assist" and "pass by reference" that *class uvmc_xl_converter* above
does, but it unconditionally transfers all fields of the generic payload along
all paths without regard to _modifiability of attributes_ which is more
semantically compatible with the slower, size limited default packer,
but which is less efficient that the *class uvmc_xl_converter* described
above.

Both types of fast packers have been shown to be useful and are considered
essential for different usage contexts.

Group: How to use the fast packers
----------------------------------

Topic: Specifying fast packers when uvmc_connect() is called
------------------------------------------------------------

To use the fast packers for a specific TLM connection that uses TLM GPs
as the transaction type, specify the desired converter type when calling
the *uvmc_connect()* call.

Here is how it is done for the *class uvmc_xl_converter* variant,

- For SC side (see ~sc2sv2sc_xl_gp_converter_loopback.cpp~ for example):

| int sc_main( int argc, char* argv[] ) {
|   producer_uvm prod( "producer" );
|   uvmc_connect<uvmc_xl_converter<tlm_generic_payload> >( prod.out, "42" );
|   uvmc_connect<uvmc_xl_converter<tlm_generic_payload> >( prod.in, "43" );
|   sc_start(-1);
|   return 0;
| }

- For SV side (see ~sc2sv2sc_xl_gp_converter_loopback.sv~ for an example):

| module sv_main;
|   loopback loop = new( "loop" );
| 
|   initial begin
|     uvmc_tlm #( uvm_tlm_generic_payload,
|         uvm_tlm_phase_e, uvmc_xl_tlm_gp_converter)::connect( loop.in, "42" );
|     uvmc_tlm #( uvm_tlm_generic_payload,
|         uvm_tlm_phase_e, uvmc_xl_tlm_gp_converter)::connect( loop.out, "43");
|     run_test();
|   end
| endmodule

And here is how it is done for the *class uvmc_tlm_gp_converter* variant,

- For SC side (see ~sc2sv2sc_gp_converter_loopback.cpp~ for example):

| int sc_main( int argc, char* argv[] ) {
|   producer_uvm prod( "producer" );
|   uvmc_connect<uvmc_tlm_gp_converter>( prod.out,"42" );
|   uvmc_connect<uvmc_tlm_gp_converter>( prod.in,"43" );
|   sc_start(-1);
|   return 0;
| }

- For SV side (see ~sc2sv2sc_gp_converter_loopback.sv~ for an example):

| module sv_main;
|   loopback loop = new( "loop" );
|   initial begin
|     uvmc_tlm #( uvm_tlm_generic_payload,
|         uvm_tlm_phase_e, uvmc_tlm_gp_converter) ::connect( loop.in, "42" );
|     uvmc_tlm #( uvm_tlm_generic_payload,
|         uvm_tlm_phase_e, uvmc_tlm_gp_converter) ::connect( loop.out, "43");
|     run_test();
|   end
| endmodule

Topic: Fast packer source code
------------------------------

- For the fast packer source code files themselves see,

|   src/connect/
|     sc/uvmc_tlm_gp_converter.*
|     sc/uvmc_xl_converter.*
|     sv/uvmc_converter.svh
|     sv/uvmc_xl_converter.svh

--------------------------------------------------------------------------------
Group: Fast-packer converter examples

--------------------------------------------------------------------------------
Topic: Running the examples

For examples that use the fast packer converters see,

|   examples/xlerate.connections/Makefile

This directory contains several examples of TLM-2 UVM-Connect'ions that pass
TLM-2 generic payloads (TLM GPs) between SystemC (SC) and SystemVerilog (SV).

Use ~make help~ to view the menu of available tests,

| make help

To run just one test such as ~sc2sv2sc_loopback~,

| make sc2sv2sc_loopback

This compiles then runs the ~sc2sv2sc_loopback~ test. See listing below
for all possible tests in the ~xlerate.connections/~ suite.

To run all tests, check them, and clean up afterwards, i.e. ~sim:~,
~check:~, and ~clean:~ targets, use the ~all:~ target as follows,

| make all

Or you can run individual sub-targets.

The ~sim~ target compiles and runs all the tests.

| make sim

The ~check~ target checks results of all the tests.

| make check

The ~clean~ target deletes all the simulation files produced from
previous runs.

| make clean

You can combine targets in one command line

| make sim check

The following runs the 'sim' target, providing the path to the
UVM source and compiled library on the ~make~ command line.

| make UVM_HOME=<path> UVM_LIB=<path> sim

--------------------------------------------------------------------------------
Topic: List of tests and what they do.

In all the tests below we want to benchmark the transfer of 80 2MB "HD-image"
payloads across a UVM-Connect'ion.

With truly unlimited generic payloads (TLM GPs), we can represent each image
as a single GP transaction.

However, because the default UVM packer based implementation limits the entire
payload to 4KBytes (see default value of *`define UVM_PACKER_MAX_BYTES 4096*
for UVM packers) we must break the image down into a series of small payload
fragments. Each fragment must fit in a maximally sized generic payload as
supported by UVM-Connect. This means, address, command, status, byte enables,
lengths, and the payload data itself must all fit in the 4KB payload.

So, the tests below that use default UVM packers (see
tests ~sc2sv2sc_loopback~ and ~sv2sc2sv_loopback~) need the actual data
payloads themselves to fit in 2KByte fragments which would leave ample
room for the rest of the fixed sized data fields of the TLM GP (address,
command, byte enables, etc) to fit in the remaining 2KB of the payload.

So with this in mind we can fragment our 80 2MB HD-images into 2KB chunks as,

|   80 x 2 x 1024   x 1024 bytes
| = 80 x 2 x 1024/2 x 2048 bytes
| = 80 x 2 x 512            2048 byte payloads
| = 81920                   2048 byte payloads
|
|  i.e. NUM_TRANSACTIONS = 81920, PAYLOAD_NUM_BYTES = 2048

Now with the 2 flavors of improved packers, in addition to getting better
trans-language communication performance, there is no limit on payload size.
In fact, there is no need for a globally defined static maximum byte stream
size at all.

Having a statically specified global maximum of any kind always begs
the question, "how big is big enough ?". And so in many accelerated
applications we try to avoid statically specified maximum payload sizes
entirely on the HVL side of the link.

So without this limitation, we can restructure the test as,

|  80 x 2MB payloads
|
|  i.e. NUM_TRANSACTIONS = 80, PAYLOAD_NUM_BYTES = 2 * 1024 * 1024 = 2 MB

In the tests below this is referred to as a "whole image payload". So for
each of the tests listed in the Makefile's you'll see that each 
test specifies both of these parameters, *NUM_TRANSACTIONS*
and *PAYLOAD_NUM_BYTES*, depending on whether the test is dividing each
image into multiple 2KB chunks or sending the ~whole image payload~ 80 times.

Here is a listing of the tests in this example suite the indicates
what packers are used and what payload kinds are used for each test
(listing is generated with "make help" command).

|  -----------------------------------------------------------------
| |                  UVMC EXAMPLES - FAST PACKERS                   |
|  -----------------------------------------------------------------
| |                                                                 |
| | Usage:                                                          |
| |                                                                 |
| |   make [UVM_HOME=path] [UVMC_HOME=path] <example>               |
| |                                                                 |
| | where <example> is one or more of:                              |
| |                                                                 |
| |   sc2sv2sc_loopback:                                            |
| |                  SC producer <-> SV loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with native default uvmc_converter's           |
| |                                                                 |
| |   sv2sc2sv_loopback:                                            |
| |                  SV producer <-> SC loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with native default uvmc_converter's           |
| |   -----------------------------------------------------------   |
| |   sc2sv2sc_gp_converter_loopback:                               |
| |                  SC producer <-> SV loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with uvmc_tlm_gp_converter's                   |
| |                                                                 |
| |   sv2sc2sv_gp_converter_loopback:                               |
| |                  SV producer <-> SC loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with uvmc_tlm_gp_converter's                   |
| |                                                                 |
| |   sc2sv2sc_gp_converter_loopback_whole_image_payloads:          |
| |                  SC producer <-> SV loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with uvmc_tlm_gp_converter's                   |
| |                  and big, nasty packets                         |
| |                                                                 |
| |   sv2sc2sv_gp_converter_loopback_whole_image_payloads:          |
| |                  SV producer <-> SC loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with uvmc_tlm_gp_converter's                   |
| |                  and big, nasty packets                         |
| |   -----------------------------------------------------------   |
| |   sc2sv2sc_xl_gp_converter_loopback:                            |
| |                  SC producer <-> SV loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with XLerated converters                       |
| |                                                                 |
| |   sv2sc2sv_xl_gp_converter_loopback:                            |
| |                  SV producer <-> SC loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with XLerated converters                       |
| |                                                                 |
| |   sc2sv2sc_xl_gp_converter_loopback_whole_image_payloads:       |
| |                  SC producer <-> SV loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with XLerated converters                       |
| |                  and big, nasty packets                         |
| |                                                                 |
| |   sv2sc2sv_xl_gp_converter_loopback_whole_image_payloads:       |
| |                  SV producer <-> SC loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with XLerated converters                       |
| |                  and big, nasty packets                         |
| |   -----------------------------------------------------------   |
| |   sc2sc2sc_uvmc_loopback:                                       |
| |                  SC producer <-> SC loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with native default uvmc_converter's           |
| |                                                                 |
| |   sc2sc2sc_xl_gp_converter_uvmc_loopback:                       |
| |                  SC producer --> SC loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with XLerated converters                       |
| |                                                                 |
| |   sc2sc2sc_xl_gp_converter_uvmc_loopback_whole_image_payloads   |
| |                  SC producer <-> SC loopback                    |
| |                  Connection is made via UVMC.                   |
| |                  with XLerated converters                       |
| |                  and big, nasty packets                         |
| |   -----------------------------------------------------------   |
| |   sc2sc2sc_uvmc_loopback:                                       |
| |                  SC producer <-> SC loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with native default uvmc_converter's           |
| |   -----------------------------------------------------------   |
| |   sv2sv2sv_uvmc_loopback:                                       |
| |                  SV producer <-> SV loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with native default uvmc_converter's           |
| |                                                                 |
| |   sv2sv2sv_xl_gp_converter_uvmc_loopback:                       |
| |                  SV producer --> SV loopback                    |
| |                  Connection is made via UVMC                    |
| |                  with XLerated converters                       |
| |                                                                 |
| |   sv2sv2sv_xl_gp_converter_uvmc_loopback_whole_image_payloads   |
| |                  SV producer <-> SV loopback                    |
| |                  Connection is made via UVMC.                   |
| |                  with XLerated converters                       |
| |                  and big, nasty packets                         |
| |                                                                 |
| | UVM_HOME and UVMC_HOME specify the location of the source       |
| | headers and macro definitions needed by the examples. You must  |
| | specify their locations via UVM_HOME and UVMC_HOME environment  |
| | variables or make command line options. Command line options    |
| | override any envrionment variable settings.                     |
| |                                                                 |
| | The UVM and UVMC libraries must be compiled prior to running    |
| | any example. If the libraries are not at their default location |
| | (UVMC_HOME/lib) then you must specify their location via the    |
| | UVM_LIB and/or UVMC_LIB environment variables or make command   |
| | line options. Make command line options take precedence.        |
| |                                                                 |
| | Other options:                                                  |
| |                                                                 |
| |   all   : Run all examples                                      |
| |   clean : Remove simulation files and directories               |
| |   help  : Print this help information                           |
| |                                                                 |
|  -----------------------------------------------------------------


| //------------------------------------------------------------//
| //   Copyright 2009-2015 Mentor Graphics Corporation          //
| //   All Rights Reserved Worldwide                            //
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
