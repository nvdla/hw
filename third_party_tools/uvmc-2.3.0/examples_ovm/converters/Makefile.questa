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

UVMC_HOME = ../..

MAKE_CMD = $(MAKE) -f Makefile.questa

help:
	@echo " -----------------------------------------------------------------";
	@echo "|                  UVMC EXAMPLES - CONVERTERS                     |";
	@echo " -----------------------------------------------------------------";
	@echo "|                                                                 |";
	@echo "| Usage:                                                          |";
	@echo "|                                                                 |";
	@echo "|   make [UVM_HOME=path] [UVMC_HOME=path] <example>               |";
	@echo "|                                                                 |";
	@echo "| where <example> is one or more of:                              |";
	@echo "|                                                                 |";
	@echo "|   ex01 : SV conversion done in UVM transaction                  |";
	@echo "|          SC conversion done in macro-generated converter class  |";
	@echo "|                                                                 |";
	@echo "|   ex02 : SV conversion done in UVM transaction                  |";
	@echo "|          SC conversion done in separate converter class         |";
	@echo "|                                                                 |";
	@echo "|   ex03 : SV conversion done in UVM transaction                  |";
	@echo "|          SC conversion done in transaction                      |";
	@echo "|                                                                 |";
	@echo "|   ex04 : SV conversion done in UVM transaction via field macros |";
	@echo "|          SC conversion done in macro-generated converter class  |";
	@echo "|                                                                 |";
	@echo "|   ex05 : SV conversion done in UVM transaction via field macros |";
	@echo "|          SC conversion done in separate converter class         |";
	@echo "|                                                                 |";
	@echo "|   ex06 : SV conversion done in UVM transaction via field macros |";
	@echo "|          SC conversion done in transaction                      |";
	@echo "|                                                                 |";
	@echo "|   ex07 : SV conversion done in separate converter class;        |";
	@echo "|                  transaction is not based on uvm_object         |";
	@echo "|          SC conversion done in macro-generated converter class  |";
	@echo "|                                                                 |";
	@echo "|   ex08 : SV conversion done in separate converter class;        |";
	@echo "|                  transaction is not based on uvm_object         |";
	@echo "|          SC conversion done in separate converter class         |";
	@echo "|                                                                 |";
	@echo "|   ex09 : SV conversion done in separate converter class;        |";
	@echo "|                  transaction is not based on uvm_object         |";
	@echo "|          SC conversion done in transaction                      |";
	@echo "|                                                                 |";
	@echo "|   ex10 : SV conversion done in UVM transaction                  |";
	@echo "|          SC-side implements converter that converts and adapts  |";
	@echo "|                  to an otherwise incompatible transaction type  |";
	@echo "|                                                                 |";
	@echo "|   ex11 : SV conversion done in UVM transaction via field macros |";
	@echo "|          SC-side implements converter that converts and adapts  |";
	@echo "|                  to an otherwise incompatible transaction type  |"; 
	@echo "|                                                                 |";
	@echo "|   ex12 : SV-side implements converter in separate class;        |";
	@echo "|                  transaction is not based on uvm_object         |";
	@echo "|          SC-side implements converter that converts and adapts  |";
	@echo "|                  to an otherwise incompatible transaction type  |";
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


ex01:
	$(MAKE_CMD) \
        SV_FILE=sv_converter_trans.sv \
	SC_FILE=sc_converter_macros.cpp \
	run

ex02:
	$(MAKE_CMD) \
	SV_FILE=sv_converter_trans.sv \
	SC_FILE=sc_converter_class.cpp \
	run

ex03:
	$(MAKE_CMD) \
	SV_FILE=sv_converter_trans.sv \
	SC_FILE=sc_converter_trans.cpp \
	run

ex04:
	$(MAKE_CMD) \
	SV_FILE=sv_converter_trans_field_macros.sv \
	SC_FILE=sc_converter_macros.cpp \
	run

ex05:
	$(MAKE_CMD) \
	SV_FILE=sv_converter_trans_field_macros.sv \
	SC_FILE=sc_converter_class.cpp \
	run

ex06:
	$(MAKE_CMD) \
	SV_FILE=sv_converter_trans_field_macros.sv \
	SC_FILE=sc_converter_trans.cpp \
	run

ex07:
	$(MAKE_CMD) \
	SV_FILE=sv_converter_class.sv \
	SC_FILE=sc_converter_macros.cpp \
	run

ex08:
	$(MAKE_CMD) \
	SV_FILE=sv_converter_class.sv \
	SC_FILE=sc_converter_class.cpp \
	run

ex09:
	$(MAKE_CMD) \
	SV_FILE=sv_converter_class.sv \
	SC_FILE=sc_converter_trans.cpp \
	run

ex10:
	$(MAKE_CMD) \
	SV_FILE=sv_converter_trans.sv \
	SC_FILE=sc_converter_adapter.cpp \
	run

ex11:
	$(MAKE_CMD) \
	SV_FILE=sv_converter_trans_field_macros.sv \
	SC_FILE=sc_converter_adapter.cpp \
	run

ex12:
	$(MAKE_CMD) \
	SV_FILE=sv_converter_class.sv \
	SC_FILE=sc_converter_adapter.cpp \
	run


all: ex01 ex02 ex03 ex04 ex05 ex06 ex07 ex08 ex09 ex10 ex11 ex12

run:
	-rm -rf work
	vlib work
	$(VLOG) $(SV_FILE)
	$(SCCOM) $(SC_FILE)
	$(LINK)
	$(VSIM) sc_main sv_main
	$(CHECK)

clean:
	rm -rf work *.log vsim* transcript *.out vish*

