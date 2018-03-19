# ============================================================================
#  @(#) $Id: common.mk 1379 2015-02-17 00:13:20Z jstickle $
# ============================================================================

#    //_______________________
#   // Mentor Graphics, Corp. \_______________________________________
#  //                                                               //
# //   (C) Copyright, Mentor Graphics, Corp. 2003-2014              //
# //   All Rights Reserved                                          //
# //                                                                //
# //    Licensed under the Apache License, Version 2.0 (the         //
# //    "License"); you may not use this file except in             //
# //    compliance with the License.  You may obtain a copy of      //
# //    the License at                                              //
# //                                                                //
# //        http://www.apache.org/licenses/LICENSE-2.0              //
# //                                                                //
# //    Unless required by applicable law or agreed to in           //
# //    writing, software distributed under the License is          //
# //    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR      //
# //    CONDITIONS OF ANY KIND, either express or implied.  See     //
# //    the License for the specific language governing            //
# //    permissions and limitations under the License.            //
# //-------------------------------------------------------------//

UVMC_HOME ?= ../..

TESTS = \
    sc2sv2sc_loopback \
    sv2sc2sv_loopback \
	\
    sc2sv2sc_gp_converter_loopback \
    sv2sc2sv_gp_converter_loopback \
    sc2sv2sc_gp_converter_loopback_whole_image_payloads \
    sv2sc2sv_gp_converter_loopback_whole_image_payloads \
	\
    sc2sv2sc_xl_gp_converter_loopback \
    sv2sc2sv_xl_gp_converter_loopback \
    sc2sv2sc_xl_gp_converter_loopback_whole_image_payloads \
    sv2sc2sv_xl_gp_converter_loopback_whole_image_payloads \
	\
    sc2sc2sc_uvmc_loopback \
	\
    sv2sv2sv_uvmc_loopback \
    sv2sv2sv_xl_gp_converter_uvmc_loopback \
    sv2sv2sv_xl_gp_converter_uvmc_loopback_whole_image_payloads

# Use these settings for the main benchmark ...
NUM_LIMITED_TRANSACTIONS=81920
LIMITED_PAYLOAD_NUM_BYTES=2048

NUM_UNLIMITED_TRANSACTIONS=80
UNLIMITED_PAYLOAD_NUM_BYTES=2097152

# Use these settings for shorter runs for debugging ...
#NUM_LIMITED_TRANSACTIONS=16
#LIMITED_PAYLOAD_NUM_BYTES=2048

#NUM_UNLIMITED_TRANSACTIONS=16
#UNLIMITED_PAYLOAD_NUM_BYTES=2048

help:
	@echo " -----------------------------------------------------------------";
	@echo "|                  UVMC EXAMPLES - FAST PACKERS                   |";
	@echo " -----------------------------------------------------------------";
	@echo "|                                                                 |";
	@echo "| Usage:                                                          |";
	@echo "|                                                                 |";
	@echo "|   make [UVM_HOME=path] [UVMC_HOME=path] <example>               |";
	@echo "|                                                                 |";
	@echo "| where <example> is one or more of:                              |";
	@echo "|                                                                 |";
	@echo "|   sc2sv2sc_loopback:                                            |";
	@echo "|                  SC producer <-> SV loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with native default uvmc_converter's           |";
	@echo "|                                                                 |";
	@echo "|   sv2sc2sv_loopback:                                            |";
	@echo "|                  SV producer <-> SC loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with native default uvmc_converter's           |";
	@echo "|   -----------------------------------------------------------   |";
	@echo "|   sc2sv2sc_gp_converter_loopback:                               |";
	@echo "|                  SC producer <-> SV loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with uvmc_tlm_gp_converter's                   |";
	@echo "|                                                                 |";
	@echo "|   sv2sc2sv_gp_converter_loopback:                               |";
	@echo "|                  SV producer <-> SC loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with uvmc_tlm_gp_converter's                   |";
	@echo "|                                                                 |";
	@echo "|   sc2sv2sc_gp_converter_loopback_whole_image_payloads:          |";
	@echo "|                  SC producer <-> SV loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with uvmc_tlm_gp_converter's                   |";
	@echo "|                  and big, nasty packets                         |";
	@echo "|                                                                 |";
	@echo "|   sv2sc2sv_gp_converter_loopback_whole_image_payloads:          |";
	@echo "|                  SV producer <-> SC loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with uvmc_tlm_gp_converter's                   |";
	@echo "|                  and big, nasty packets                         |";
	@echo "|   -----------------------------------------------------------   |";
	@echo "|   sc2sv2sc_xl_gp_converter_loopback:                            |";
	@echo "|                  SC producer <-> SV loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with XLerated converters                       |";
	@echo "|                                                                 |";
	@echo "|   sv2sc2sv_xl_gp_converter_loopback:                            |";
	@echo "|                  SV producer <-> SC loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with XLerated converters                       |";
	@echo "|                                                                 |";
	@echo "|   sc2sv2sc_xl_gp_converter_loopback_whole_image_payloads:       |";
	@echo "|                  SC producer <-> SV loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with XLerated converters                       |";
	@echo "|                  and big, nasty packets                         |";
	@echo "|                                                                 |";
	@echo "|   sv2sc2sv_xl_gp_converter_loopback_whole_image_payloads:       |";
	@echo "|                  SV producer <-> SC loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with XLerated converters                       |";
	@echo "|                  and big, nasty packets                         |";
	@echo "|   -----------------------------------------------------------   |";
	@echo "|   sc2sc2sc_uvmc_loopback:                                       |";
	@echo "|                  SC producer <-> SC loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with native default uvmc_converter's           |";
	@echo "|                                                                 |";
	@echo "|   sc2sc2sc_xl_gp_converter_uvmc_loopback:                       |";
	@echo "|                  SC producer --> SC loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with XLerated converters                       |";
	@echo "|                                                                 |";
	@echo "|   sc2sc2sc_xl_gp_converter_uvmc_loopback_whole_image_payloads   |";
	@echo "|                  SC producer <-> SC loopback                    |";
	@echo "|                  Connection is made via UVMC.                   |";
	@echo "|                  with XLerated converters                       |";
	@echo "|                  and big, nasty packets                         |";
	@echo "|   -----------------------------------------------------------   |";
	@echo "|   sc2sc2sc_uvmc_loopback:                                       |";
	@echo "|                  SC producer <-> SC loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with native default uvmc_converter's           |";
	@echo "|   -----------------------------------------------------------   |";
	@echo "|   sv2sv2sv_uvmc_loopback:                                       |";
	@echo "|                  SV producer <-> SV loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with native default uvmc_converter's           |";
	@echo "|                                                                 |";
	@echo "|   sv2sv2sv_xl_gp_converter_uvmc_loopback:                       |";
	@echo "|                  SV producer --> SV loopback                    |";
	@echo "|                  Connection is made via UVMC                    |";
	@echo "|                  with XLerated converters                       |";
	@echo "|                                                                 |";
	@echo "|   sv2sv2sv_xl_gp_converter_uvmc_loopback_whole_image_payloads   |";
	@echo "|                  SV producer <-> SV loopback                    |";
	@echo "|                  Connection is made via UVMC.                   |";
	@echo "|                  with XLerated converters                       |";
	@echo "|                  and big, nasty packets                         |";
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
	@echo " -----------------------------------------------------------------";
