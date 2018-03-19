
--------------------------------------------------------------------------------
Title: Configuration extensions
--------------------------------------------------------------------------------

Topic: Introduction
-------------------

Configuration extensions are _ignorable extensions_ (in the sense of TLM-2.0
generic payloads) that can be used to pass configurations which accompany
generic payloads that travel from TLM-2.0 initiators to targets.

The UVMC config extension base class *uvmc_xl_config* contains a simple
abstraction of a set _configuration registers_ that can act as shadows
of the associated configuration register set one might find in the target
model.

There are two types of configuration extensions that are handled by
*class uvmc_xl_config*,

- Static configurations
- Sideband configurations

Topic: Static configurations
----------------------------

- Static configurations are sent as separate dedicated transactions
  to update configuration register sets on the target side of the connection.

- Static configs can be used for configuring things that don't change often
  such as UART baud rate, AXI randomized wait state bounds and cross
  channel latencies.

Topic: Sideband configurations
----------------------------

- Sideband confgurations are unconditionally sent with each and
  every generic payload transaction along the forward path to the target.

- These should be used for things that typically change as frequently
  as every transaction such as tid's for AXI transactions, tags for
  Wishbone transactions, etc.

Group: How to use configuration extensions
------------------------------------------

Topic: Defining your config extension classes
---------------------------------------------

NOTE: The *class uvmc_xl_config* TLM GP extension is designed to be used *only*
with TLM GPs passed to the *class uvmc_xl_converter* fast packer described
above. You can attach them to TLM GPs that use other packers but the
extension itself may not accompany the TLM GP across the TLM channel in
that case (certainly not for UVMC ~default converters~ or *class
uvmc_tlm_gp_converter* fast packers).

For the config extensions themselves see the *class uvmc_xl_config* definitions
in these files,

|       src/connect/
|         sc/uvmc_xl_config.*
|         sv/uvmc_xl_config.svh

To create a custom configuration extension suitable for passing
static or sideband configurations attached to TLM GPs across UVM-Connect'ions,
simply define a class that derives from *class uvmc_xl_config* for each
language (SC, SV).

For use by the examples to follow, we'll first define a custom configuration
extension for TLM GP's that one might see being used with the AXI protocol.

Please see the section <Customizing class uvmc_xl_config for AXI configuration>
below for more details but here we simply show how the class is defined
and how the constructor is done for each language. In both cases a
custom configuration extension is created for the AXI master TLM connections
in the examples by deriving the custom config from *class uvmc_xl_config* as
follows,

- For SC-side,

| class AxiConfig : public uvmc::uvmc_xl_config {
| 
|   public:
|     AxiConfig()
|       : uvmc::uvmc_xl_config(
|           ( 16*2 + 8*3 ) / 8,      // staticConfigNumBytes
|           ( 32*1 + 8*1 ) / 8 ) { } // sidebandConfigNumBytes
| ...

- for SV-side,

| class AxiConfig extends uvmc_xl_config #(
|     ( 16*2 + 8*3 ) / 8,      // staticConfigNumBytes
|     ( 32*1 + 8*1 ) / 8 );    // sidebandConfigNumBytes
| 
|     `uvm_object_utils( AxiConfig )

Note that in both cases the *class uvmc_xl_config* is dimensioned to the number
of bytes in the static configuration and the number of bytes in the sideband
configuration. In the case of SC the dimensions are given in the constructor
whereas in the case of SV they are given with class parametrizations.

The single configuration extension class definition will handle both types of
configurations in all TLM GP transaction communications.

So those are the basics of how to create a custom configuration.
Again see the section <Customizing class uvmc_xl_config for AXI configuration>
for more details about the example AXI configuration that is used in
the examples and how to perform ~config query~ and ~config update~ operations
on the various config register fields that are managed by the *class AxiConfig*
config extension itself.

--------------------------------------------------------------------------------
Topic: Running the examples

For examples that use the configuration extensions see,

|   examples/config_exts/Makefile

This directory contains several examples of TLM-2 UVM-Connect'ions that pass
TLM-2 generic payloads (TLM GPs) between SystemC (SC) and SystemVerilog (SV).

They modified variants of tests lifted from ~examples/xlerate.connections~,
namely the following two,

| TESTS = \
|   sc2sv2sc_xl_gp_converter_loopback_whole_image_payloads \
|   sv2sc2sv_xl_gp_converter_loopback_whole_image_payloads

This allows illustrations for config extension ~update~ or ~query~ operations
traveling from SC -> SV -> SC or from SV -> SC -> SV respectively.

Use ~make help~ to view the menu of available tests,

| make help

To run just one test such
as ~sc2sv2sc_xl_gp_converter_loopback_whole_image_payloads~,

| make sc2sv2sc_xl_gp_converter_loopback_whole_image_payloads

This compiles then runs
the ~sc2sv2sc_xl_gp_converter_loopback_whole_image_payloads~ test.

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
