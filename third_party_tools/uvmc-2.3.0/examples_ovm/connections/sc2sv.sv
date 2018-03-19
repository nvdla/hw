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
// Title: UVMC Connection Example - SC to SV, SV side
//
// Topic: Description
// This example shows an SC producer driving an SV consumer via a TLM connection
// made with UVMC.
// See <UVMC Connection Example - SC to SV, SC side> to see the SC portion of
// the example.
//
// (see UVMC_Connections_SC2SV.png)
//
// Note: This example is derived from the UVM Connect examples, so the diagram 
// depicts components with TLM2 sockets. TLM2 is not available in OVM, so this OVM
// components use TLM1 blocking put ports. Whether sockets or ports/exports, the
// connection syntax is the same.
//
// The ~sv_main~ top-level module below creates and starts the SV portion of this
// example. It does the following:
//
// - Creates an instance of a ~consumer~ component
//
// - Registers the consumer's ~in~ target socket with UVMC using the arbitrary
//   string, "42". During elaboration, UVMC will connect this port with a port
//   registered with the same lookup string. In this example, the match will
//   occur with a producer's ~in~ port on the SC side.
//
// - Calls ~run_test~ to start UVM simulation
//
// TLM connections would normally be made in the ~connect~ callback of
// a UVM component. This example does not show that for sake of highlighting
// the UVMC connect functionality.
//
//-----------------------------------------------------------------------------

// (inline source)
import ovm_pkg::*; 
import ovmc_pkg::*;

`include "consumer.sv"

module sv_main;

  consumer cons = new("cons");

  initial begin
    uvmc_tlm1 #(packet)::connect(cons.in, "42");
    uvmc_init();
    run_test();
  end

endmodule
