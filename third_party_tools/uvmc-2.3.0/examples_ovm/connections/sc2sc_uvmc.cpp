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
// Title-  UVMC-based SC to SC Connections (not implemented yet) 
//
// This example demonstrates connecting two SC components using UVMC. 
//
// (see UVMC_Connections_SC2SC.png)
//
// In this example, we instantiate a <producer> and <consumer>
// sc_module.  Then two ~uvmc_connect~ calls are made, one for each side of
// the connection. Because we use the same lookup string, "sc2sc", in each
// of these calls, UVMC will establish the connection during binding resolution
// at elaboration time. 
//
// The connection must be valid, i.e. the port/export/interface types and
// transaction type must be compatible, else an elaboration-time error will
// result.
// 
//-----------------------------------------------------------------------------

// (- inline source)
#include <systemc.h>
using namespace sc_core;

#include "consumer.h"
#include "producer.h"
#include "packet.h"

int sc_main(int argc, char* argv[]) 
{  
  producer prod("prod");
  consumer cons("cons");
  uvmc_connect(prod.out, "sc2sc");
  uvmc_connect(cons.in, "sc2sc");
  sc_start(-1);
  return 0;
}
