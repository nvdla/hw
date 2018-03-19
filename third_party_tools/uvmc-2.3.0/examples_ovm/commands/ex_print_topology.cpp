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

//----------------------------------------------------------------------
// Title: UVMC Command API Example - Print Topology
//
// This example shows how to print the UVM testbench topology from SC.
// 
// First, we wait for the UVM's build phase to start, then print the
// UVM topology. At this point only the top-level component exists.
//
// Then, we wait for the build phase to end, then print the topology
// once more. This time, all the UVM components exist and you see
//----------------------------------------------------------------------


//---------------------------------------------------------------------
// CLASS: top
//
// Our top-level SC module does the following
//
// - Creates an instance of a generic <consumer>. The consumer merely
//   prints the transactions it receives side and sends them out its
//   analysis port.
//
// - Spawn a thread function, ~show_uvm_print_topology~
//
// - Register the consumer's ports for UVMC connection.
//
//---------------------------------------------------------------------

// (begin inline source)
#include "systemc.h"
#include "tlm.h"
#include <string>
#include <iostream>

using namespace std;
using namespace sc_core;
using namespace tlm;

#include "uvmc.h"
#include "uvmc_macros.h"
using namespace uvmc;

#include "consumer.cpp"


SC_MODULE(top)
{
  consumer cons;

  SC_CTOR(top) : cons("consumer") {
    SC_THREAD(show_uvm_print_topology);
    uvmc_connect(cons.in,"foo");
    uvmc_connect(cons.ap,"bar");
  }

  void show_uvm_print_topology();

};
//(end inline source)


//----------------------------------------------------------------------
// Function: show_uvm_print_topology
//
// The ~show_uvm_print_topology~ waits for UVM to start its
// ~build_phase~, then prints UVM topology. At this point only the
// top-level component exists.
//
// It then waits for the ~build_phase~ to finish. This time, printing
// the UVM topology shows our expected testbench topology. 
//----------------------------------------------------------------------

// (inline source)
void top::show_uvm_print_topology()
{
  cout << endl << endl << "Waiting for UVM to reach build phase..." << endl;
  uvmc_wait_for_phase("build", UVM_PHASE_STARTED, UVM_GTE);

  cout << endl << endl << "Topology before build phase:" << endl;
  uvmc_print_topology();

  uvmc_wait_for_phase("build", UVM_PHASE_ENDED);

  cout << endl << endl << "Topology after build phase:" << endl;
  uvmc_print_topology();
}



//---------------------------------------------------------------------
// Group: sc_main
// 
// Creates an instance of our <top> module then calls ~sc_start~
// to start SC simulation.
//---------------------------------------------------------------------

// (begin inline source)
int sc_main(int argc, char* argv[]) 
{  
  top t("top");
  sc_start();
  return 0;
}
// (end inline source)
