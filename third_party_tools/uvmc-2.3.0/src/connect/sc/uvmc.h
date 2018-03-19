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

//-----------------------------------------------------------------------------
// Title- uvmc.h
//
// The main include file. All users of UVMC need to #include this
// file.
//-----------------------------------------------------------------------------

#ifndef UVMC_H
#define UVMC_H

#ifndef SC_INCLUDE_DYNAMIC_PROCESSES
#define SC_INCLUDE_DYNAMIC_PROCESSES
#endif

#include "systemc.h"
#include "svdpi.h"
#include "uvmc_common.h"
#include "uvmc_packer.h"
#include "uvmc_convert.h"
#include "uvmc_commands.h"
#include "uvmc_channels.h"
#include "uvmc_ports.h"
#include "uvmc_connect.h"
#include "uvmc_macros.h"
#include "uvmc_xl_config.h"
#include "uvmc_xl_converter.h"
#include "uvmc_tlm_gp_converter.h"

#endif // UVMC_H
