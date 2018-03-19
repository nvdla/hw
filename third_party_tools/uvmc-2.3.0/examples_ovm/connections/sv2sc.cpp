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
// Title: UVMC Connection Example - SV to SC, SC side
//
// This example shows an SV producer driving an SC consumer via a TLM connection
// made with UVMC.
// See <UVMC Connection Example - SV to SC, SV side> to see the SV portion
// of the example.
//
// (see UVMC_Connections_SV2SC.png)
//
// The ~sc_main~ function below creates and starts the SC portion of this example.
// It does the following:
//
// - Instantiates a basic ~consumer~
//
// - Registers the consumer's ~in~ port with UVMC using the lookup
//   string "foo". During elaboration, UVMC will connect this port with
//   a port registered with the same lookup string. In this example, the
//   match will occur with the producer's ~out~ port on the SV side.
//
// - Calls ~sc_start~ to start SystemC
//
//-----------------------------------------------------------------------------

// (inline source)
#include "uvmc.h"
using namespace uvmc;

#include "consumer.h"

int sc_main(int argc, char* argv[]) 
{  
  consumer cons("cons");
  uvmc_connect(cons.in,"foo");
  sc_start(-1);
  return 0;
}
