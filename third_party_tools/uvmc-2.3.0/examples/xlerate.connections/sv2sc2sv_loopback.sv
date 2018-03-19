//============================================================================
// @(#) $Id: sv2sc2sv_loopback.sv 1254 2014-11-21 20:12:17Z jstickle $
//============================================================================

   //_______________________
  // Mentor Graphics, Corp. \_________________________________________________
 //                                                                         //
//   (C) Copyright, Mentor Graphics, Corp. 2003-2014                        //
//   All Rights Reserved                                                    //
//                                                                          //
//    Licensed under the Apache License, Version 2.0 (the                   //
//    "License"); you may not use this file except in                       //
//    compliance with the License.  You may obtain a copy of                //
//    the License at                                                        //
//                                                                          //
//        http://www.apache.org/licenses/LICENSE-2.0                        //
//                                                                          //
//    Unless required by applicable law or agreed to in                     //
//    writing, software distributed under the License is                    //
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR                //
//    CONDITIONS OF ANY KIND, either express or implied.  See               //
//    the License for the specific language governing                      //
//    permissions and limitations under the License.                      //
//-----------------------------------------------------------------------//

//-----------------------------------------------------------------------------
// Title: UVMC Connection Example - UVMC-based SV to SC to SV
//-----------------------------------------------------------------------------

// (inline source)
import uvm_pkg::*; 
import uvmc_pkg::*;

`include "producer_loopback.svh"

module sv_main;

  producer prod = new("prod");

  initial begin

    uvmc_tlm #() ::connect(prod.out, "42");
    uvmc_tlm #() ::connect(prod.in,  "43");

    run_test();
  end

endmodule
