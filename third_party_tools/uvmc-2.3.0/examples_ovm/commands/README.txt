
Title: UVMC Command Examples

The ~examples_ovm/commands~ directory contains several examples of using the
UVMC Command API from SystemC to query, configure, and control OVM simulation
in SystemVerilog.

See <Getting Started> for setup requirements before running the examples.
Specifically, you will need to have precompiled the OVM and UVMC
libraries and set environment variables pointing to them.

Use ~make help~ to view the menu of available examples:

|> make help

You'll get a menu similar to the following

|  -----------------------------------------------------------------
| |                   UVMC EXAMPLES - OVM COMMANDS                  |
|  -----------------------------------------------------------------
| |                                                                 |
| | Usage:                                                          |
| |                                                                 |
| |   make [OVM_HOME=path] [UVMC_HOME=path] [TRACE=1] <example>     |
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
| | OVM_HOME and UVMC_HOME specify the location of the source       |
| | headers and macro definitions needed by the examples. You must  |
| | specify their locations via OVM_HOME and UVMC_HOME environment  |
| | variables or make command line options. Command line options    |
| | override any environment variable settings.                     |
| |                                                                 |
| | The OVM and UVMC libraries must be compiled prior to running    |
| | any example. If the libraries are not at their default location |
| | (UVMC_HOME/lib) then you must specify their location via the    |
| | OVM_LIB and/or UVMC_LIB environment variables (or make command  |
| | line options). Make command line options take precedence.       |
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

  | > make -f Makefile.<tool> phasing

Where <tool> is either questa, vcs, or ius.

This runs the 'phasing' example with the OVM source location defined by
the ~OVM_HOME~ environment variable and the OVM and UVMC compiled
libraries at their default location, ~../../lib/ovmc_lib~.

To run all command examples

  | > make -f Makefile.<tool> all

The ~clean~ target deletes all the simulation files produced from previous
runs.

  | > make -f Makefile.<tool> clean

You can combine targets in one command line

  | > make -f Makefile.<tool> clean all

The following runs the 'phasing' example using the OVM library at the given
path, which overrides the OVM_HOME environment variable.

  | > make -f Makefile.<tool> OVM_HOME=<path> phasing


Assuming your environment is properly set up, choose an example to
run from the menu, say

|> make -f Makefile.<tool> phasing

This compiles and runs the example that demonstrates SC waiting for
and controlling phase progression in SV OVM. 



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
