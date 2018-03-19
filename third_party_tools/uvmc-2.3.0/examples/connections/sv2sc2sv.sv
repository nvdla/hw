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
// Title: UVMC Connection Example - Basic Testbench, SV side
//
// This example shows a SV producer driving an SC consumer via a TLM2 UVMC
// connection, and an SC consumer sending transactions to a SV scoreboard
// via a TLM1 analysis connection. It also makes a local UVM analysis
// connection between the producer and scoreboard.
// See <UVMC Connection Example - Basic Testbench, SC side> for the SC
// portion of this example.
//
// (see UVMC_Connections_SV2SC2SV.png)
//
// The ~sv_main~ top-level module below creates and starts the SV portion of this
// example. It does the following:
//
// - Creates an instance of ~producer~ and ~scoreboard~ components
//
// - Registers the producer's ~out~ socket with UVMC using the string "stimulus".
//   During elaboration, UVMC will connect this port with a port registered with
//   the same lookup string. In this example, the match will occur with the
//   consumer's ~in~ port on the SC side.
//
// - Registers the scoredboard's ~actual_in~ analysis export with UVMC using
//   the string "analysis". During elaboration, UVMC will connect this port with
//   a port registered with the same lookup string. In this example, the
//   match will occur with the consumers's ~ap~ analysis port on the SC side.
//
// - Connects the producer's analysis port, ~ap~, to the scoreboard's
//   ~expect_in~ analysis export.
//
// - Calls ~run_test~ to start UVM simulation
//
// These connections would normally be made in the ~connect~ method of a UVM
// component. This example does not show that for sake of brevity and
// highlighting the UVMC connect calls.
//
//
//-----------------------------------------------------------------------------

// (inline source)
import uvm_pkg::*; 
import uvmc_pkg::*;

`include "producer.sv"
`include "scoreboard.sv"

module sv_main;

  producer prod = new("prod");
  scoreboard sb = new("sb");

  initial begin

    // normal SV-only connection
    prod.ap.connect(sb.expect_in);

    // TLM2 connection
    uvmc_tlm #()::connect(prod.out, "stimulus");

    // TLM1 connection
    uvmc_tlm1 #(uvm_tlm_generic_payload)::connect(sb.actual_in, "analysis");

    run_test();
  end

endmodule

