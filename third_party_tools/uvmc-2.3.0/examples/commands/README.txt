
Title: UVM Command Examples

The ~examples/commands~ directory contains several examples of using the
UVMC Command API from SystemC to query, configure, and control UVM simulation
in SystemVerilog.

See <Getting Started> for setup requirements before running the examples.
Specifically, you will need to have precompiled the UVM and UVMC
libraries and set environment variables pointing to them.

Use ~make help~ to view the menu of available examples:

|> make help

You'll get a menu similar to the following

|  -----------------------------------------------------------------
| |                   UVMC EXAMPLES - UVM COMMANDS                  |
|  -----------------------------------------------------------------
| |                                                                 |
| | Usage:                                                          |
| |                                                                 |
| |   make [UVM_HOME=path] [UVMC_HOME=path] [TRACE=1] <example>     |
| |                                                                 |
| | where <example> is one of                                       |
| |                                                                 |
| |   config    : shows usage of the UVMC set/get config API        |
| |                                                                 |
| |   reporting : shows how to issue and filter UVM standard        |
| |               reports                                           |
| |                                                                 |
| |   factory   : shows how to set type and instance overrides and  |
| |               dump factory state and perform factory debug      |
| |                                                                 |
| |   topology  : illusrates how (and when) to dump UVM topology    |
| |                                                                 |
| |   phasing   : show how SC can wait for any UVM phase state      |
| |               and raise/drop objections to control their        |
| |               progression                                       |
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
| | If TRACE=1 is used, UVM command tracing is enabled (try it!)    |
| |                                                                 |
| | Other options:                                                  |
| |                                                                 |
| |   all   : Run all examples                                      |
| |   clean : Remove simulation files and directories               |
| |   help  : Print this help information                           |
| |                                                                 |
|  -----------------------------------------------------------------

To run just the 'phasing' example

  | > make phasing

This runs the 'phasing' example with the UVM source location defined by
the ~UVM_HOME~ environment variable and the UVM and UVMC compiled
libraries at their default location, ~../../lib/uvmc_lib~.

To run all ~UVM Command~ examples

  | prompt> make all

The ~clean~ target deletes all the simulation files produced from previous
runs.

  | prompt> make clean

You can combine targets in one command line

  | prompt> make clean all

The following runs the 'phasing' example using the UVM library at the given
path, which overrides the UVM_HOME environment variable.

  | > make UVM_HOME=<path> phasing


Assuming your environment is properly set up, choose an example to
run from the menu, say

|> make phasing

This compiles and runs the example that demonstrates SC waiting for
and controlling phase progression in SV UVM. 



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
