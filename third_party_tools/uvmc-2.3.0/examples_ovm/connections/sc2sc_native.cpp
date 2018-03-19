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
// Title:  UVMC Connection Example - Native SC to SC
//
// This example serves as a review for how to make 'native' TLM connections
// between two SystemC components (does not use UVMC).
//
// (see UVMC_Connections_SC2SC-native.png)
//
// In SystemC, a ~port~ is connected to an ~export~ or an ~interface~ using
// the port's ~bind~ function. An sc_module's port can also be connected to
// a port in a parent module, which effectively promotes the port up one
// level of hierarchy.
//
// In this particular example, ~sc_main~ does the following
//
// - Instantiates ~producer~ and ~consumer~ sc_modules
//
// - Binds the producer's ~out~ port to the consumer's ~in~ export
//
// - Calls ~sc_start~ to start the SystemC portion of our testbench.
//
// The ~bind~ call looks the same for all port-to-export/interface connections,
// regardless of the port types and transaction types. The C++ compiler
// will let you know if you've attempted an incompatible connection.
//-----------------------------------------------------------------------------

// (inline source)
#include <systemc.h>
using namespace sc_core;

#include "consumer.h"
#include "producer.h"

int sc_main(int argc, char* argv[]) 
{  
  producer prod("prod");
  consumer cons("cons");

  prod.out.bind(cons.in);

  sc_start(-1);
  return 0;
}
