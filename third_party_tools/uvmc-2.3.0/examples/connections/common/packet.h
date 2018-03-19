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

#ifndef PACKET_H
#define PACKET_H

#include <vector>
using std::vector;

#include <systemc.h>
#include <tlm.h>
using namespace sc_core;

class packet {
  public:
  short cmd;
  int addr;
  vector<char> data;
};

//------------------------------------------------------------------------------
// Begin UVMC-specific code

#include "uvmc.h"
using namespace uvmc;

UVMC_UTILS_3 (packet,cmd,addr,data)

#endif // PACKET_H
