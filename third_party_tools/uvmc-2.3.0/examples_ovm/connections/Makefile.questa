#
# //------------------------------------------------------------//
# //   Copyright 2009-2012 Mentor Graphics Corporation          //
# //   All Rights Reserved Worldwid                             //
# //                                                            //
# //   Licensed under the Apache License, Version 2.0 (the      //
# //   "License"); you may not use this file except in          //
# //   compliance with the License.  You may obtain a copy of   //
# //   the License at                                           //
# //                                                            //
# //       http://www.apache.org/licenses/LICENSE-2.0           //
# //                                                            //
# //   Unless required by applicable law or agreed to in        //
# //   writing, software distributed under the License is       //
# //   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR   //
# //   CONDITIONS OF ANY KIND, either express or implied.  See  //
# //   the License for the specific language governing          //
# //   permissions and limitations under the License.           //
# //------------------------------------------------------------//

UVMC_HOME ?= ../..
VSIM_EXTRA ?=
MAKE_CMD = $(MAKE) -f Makefile.questa

help:
	@echo " -----------------------------------------------------------------";
	@echo "|                  UVMC EXAMPLES - CONNECTIONS                    |";
	@echo " -----------------------------------------------------------------";
	@echo "|                                                                 |";
	@echo "| Usage:                                                          |";
	@echo "|                                                                 |";
	@echo "|   make [UVM_HOME=path] [UVMC_HOME=path] <example>               |";
	@echo "|                                                                 |";
	@echo "| where <example> is one or more of:                              |";
	@echo "|                                                                 |";
	@echo "|   sv2sc        : SV producer --> SC consumer                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                                                                 |";
	@echo "|   sc2sv        : SC producer --> SV consumer                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                                                                 |";
	@echo "|   sv2sc2sv     : SV producer --> SC consumer                    |";
	@echo "|                  Producer and consumer send transactions to     |";
	@echo "|                  scoreboard for comparison                      |";
	@echo "|                  Connections are made via UVMC                  |";
	@echo "|                                                                 |";
	@echo "|   sc_wraps_sv  : SC producer --> SC consumer                    |";
	@echo "|                  Defines SC wrapper around SV model, uses       |";
	@echo "|                  UVMC connections inside the the wrapper to     |";
	@echo "|                  integrate the SV component. The wrapper        |";
	@echo "|                  appears as a native SC component.              |";
	@echo "|                  Consider integration of RTL models in SC.      |";
	@echo "|                                                                 |";
	@echo "|   sv2sv_native : SV producer --> SV consumer                    |";
	@echo "|                  Connection is made via standard UVM in SV      |";
	@echo "|                                                                 |";
	@echo "|   sc2sc_native : SC producer --> SC consumer                    |";
	@echo "|                  Connection is made via standard IEEE TLM in SC |";
	@echo "|                                                                 |";
	@echo "|   sv2sv_uvmc   : SV producer --> SV consumer                    |";
	@echo "|                  Connection is made via UVMC. Semantically      |";
	@echo "|                  equivalent to sv2sv_native                     |";
	@echo "|                                                                 |";
	@echo "|   sc2sc_uvmc   : SC producer --> SC consumer                    |";
	@echo "|                  Connection is made via UVMC. Semantically      |";
	@echo "|                  equivalent to sc2sc_native (disabled)          |";
	@echo "|                                                                 |";
	@echo "| UVM_HOME and UVMC_HOME specify the location of the source       |";
	@echo "| headers and macro definitions needed by the examples. You must  |";
	@echo "| specify their locations via UVM_HOME and UVMC_HOME environment  |";
	@echo "| variables or make command line options. Command line options    |";
	@echo "| override any envrionment variable settings.                     |";
	@echo "|                                                                 |";
	@echo "| The UVM and UVMC libraries must be compiled prior to running    |";
	@echo "| any example. If the libraries are not at their default location |";
	@echo "| (UVMC_HOME/lib) then you must specify their location via the    |";
	@echo "| UVM_LIB and/or UVMC_LIB environment variables or make command   |";
	@echo "| line options. Make command line options take precedence.        |";
	@echo "|                                                                 |";
	@echo "| Other options:                                                  |";
	@echo "|                                                                 |";
	@echo "|   all   : Run all examples                                      |";
	@echo "|   clean : Remove simulation files and directories               |";
	@echo "|   help  : Print this help information                           |";
	@echo "|                                                                 |";
	@echo "|                                                                 |";
	@echo " -----------------------------------------------------------------";

include $(UVMC_HOME)/examples_ovm/Makefile.questa

all: sv2sc sc2sv sv2sc2sv sc_wraps_sv sv2sv_native sc2sc_native sv2sv_uvmc

sv2sc:
	$(MAKE_CMD) EXAMPLE=sv2sc run

sc2sv:
	$(MAKE_CMD) EXAMPLE=sc2sv VSIM_EXTRA=+UVMC_COMMAND_TRACE run

sc_wraps_sv:
	$(MAKE_CMD) EXAMPLE=sc_wraps_sv run

sv2sc2sv:
	$(MAKE_CMD) EXAMPLE=sv2sc2sv run

sv2sv_uvmc:
	$(MAKE_CMD) EXAMPLE=sv2sv_uvmc run

run:
	-rm -rf work
	vlib work
	$(VLOG) +incdir+common $(EXAMPLE).sv
	$(SCCOM) -Icommon $(EXAMPLE).cpp
	$(LINK)
	$(VSIM) sc_main sv_main
	$(CHECK)

sc2sc_native:
	-rm -rf work
	vlib work
	$(SCCOM) -Icommon sc2sc_native.cpp
	$(LINK)
	$(VSIM) sc_main
	$(CHECK_SC)

sv2sv_native:
	-rm -rf work
	vlib work
	$(VLOG) +incdir+common sv2sv_native.sv
	$(VSIM) sv_main
	$(CHECK)

sc2sc_uvmc:
	@echo "** SC-to-SC via UVMC not yet supported **"


clean:
	rm -rf work *.log vsim* transcript *.vstf

