//============================================================================
// @(#) $Id: sc2sv2sc_xl_gp_converter_loopback.cpp 1254 2014-11-21 20:12:17Z jstickle $
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

#include <systemc.h>
using namespace sc_core;

//-----------------------------------------------------------------------------
// Title: UVMC Connection Example - SC to SV, SC side
//
// This example shows a SC producer driving a SV consumer via a TLM connection
// made with UVMC, including how to derive a SC producer subtype that can
// control UVM phasing using the UVMC Command API.
// See <UVMC Connection Example - SC to SV, SV side> to see the SV portion
// of the example.
//
// (see UVMC_Connections_SC2SV.png)
//
// In a pure SC simulation, synchronization between a producer and consumer
// occurs exclusively through the protocol prescribed by the TLM standard.
// In mixed SC-SV simulation, SC usually elaborates and starts its threads
// before SV has finished elaborating. To prevent run-time errors, UVMC will
// block any cross-language access until SV is ready. This means calls to
// interface methods via SC ports or sockets connected to SV must be made
// from within SC threads (via the SC_THREAD macro or sc_spawn).
// 
// Blocking until SV is ready technically violates TLM non-blocking semantics.
// It was deemed more useful to hold back activity from all cross-language
// calls rather than reject all non-blocking calls until SV was ready. Future
// releases may provide an option to return immediately with 0 status from
// non-blocking calls.
//
// When a UVM testbench is sitting on the SV side, you must also consider UVM's
// phasing semantics, which says that a phase will end if there are no objections
// raised to its ending. When, as in this example, there is a SC-side participant
// to UVM phase control, an objection will need to be raised from the SC side
// for the phase(s) in which the SC side actively participates. The producer,
// in other words, must use the UVMC Command API to raise and drop the objection
// that corresponds to the phase in which it is generating stimulus. If it does
// not, then UVM (SV) will end that phase and likely end simulation before the
// SC producer has had a chance to emit the first transaction.
// 
// To preserve reuse, it is recommended that the UVM Command API usage be
// relegated to a subtype of the native SC producer. This way, you do not couple
// the producer's primary functionality (producing transactions) with
// cross-language synchronization issues and UVMC.
//
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Group: UVM-aware SC producer
//
// This example defines the ~producer_uvm~ class, which derives from
// our generic SC ~producer~. In it, we spawn a dynamic ~objector~ thread
// that calls ~uvmc_raise_objection~ to UVM's run phase. This keeps simulation
// alive on the SV side while the base ~producer~ in SC generates stimulus.
//
// When the base ~producer~ is finished generating stimulus, it will notify a
// ~done~ sc_event. The ~objector~ thread in this ~producer_uvm~ wakes up on
// that event notification and drops its objection using ~uvmc_drop_objection~.
// This allows UVM simulation to proceed to the next phase and eventually
// complete simulation.
//-----------------------------------------------------------------------------

// (begin inline source)
#include "uvmc.h"
using namespace uvmc;

#include "producer_loopback.h"

class producer_uvm : public producer {

  public:

  producer_uvm(sc_module_name nm) : producer(nm) {
    SC_THREAD(objector);
  }

  SC_HAS_PROCESS(producer_uvm);

  void objector() {
    uvmc_raise_objection("run");
    wait(done);
    uvmc_drop_objection("run");
  }

};
// (end inline source)


//-----------------------------------------------------------------------------
// Group: sc_main
//
// The ~sc_main~ function below creates and starts the SC portion of this example.
// It does the following:
//
// - Instantiates a basic ~producer~
//
// - Registers the producer's ~in~ port with UVMC using the lookup
//   string "42". During elaboration, UVMC will connect this port with
//   a port registered with the same lookup string. In this example, the
//   match will occur with a consumer's ~in~ port on the SV side.
//
// - Calls ~sc_start~ to start SystemC
//
//-----------------------------------------------------------------------------

// (begin inline source)
int sc_main(int argc, char* argv[]) 
{  
  producer_uvm prod("producer");
  uvmc_connect<uvmc_xl_converter<tlm_generic_payload> >(prod.out,"42");
  uvmc_connect<uvmc_xl_converter<tlm_generic_payload> >(prod.in,"43");
  sc_start(-1);
  return 0;
}
// (end inline source)

