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
// Title: UVMC Command API Example - Factory
//
// This example demonstrates making UVM factory queries and setting
// type and instance overrides. The UVMC factory API mirrors the
// methods provided in UVM:
//
// uvmc_print_factory - print the contents of the UVM factory
//
// uvmc_find_factory_override - get the name of the type the factory
//      would create given a requested type and context.
//
// uvmc_debug_factory_create - print detailed information on how the
//      factory arrives the type it returns given a requested type
//      and a context.
//
// uvmc_set_factory_type_override - set a type-wide override whereby
//      all requests for a type will instead produce the override type
//      for all instances of the requested type.
//    
// uvmc_set_factory_inst_override - set a instance override whereby
//      a request for a type will instead produce the override type
//      for all instances matching the given path. Glob and regular
//      expressions are allowed.
//    
// See the <Factory> command descriptions for more details.
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
// - Spawn a thread function, ~show_uvm_factory~
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
    SC_THREAD(show_uvm_factory);
    uvmc_connect(cons.in,"foo");
    uvmc_connect(cons.ap,"bar");
  }

  void show_uvm_factory();

};
//(end inline source)


//---------------------------------------------------------------------
// Function: show_uvm_factory
//
// The ~show_uvm_factory~ thread will show
// usage of the UVMC factory commands. In this example, we configure
// type and instance overrides to make the UVM factory create
// extensions to the default producer and scoreboard components.
// We call on <uvmc_print_factory> and <uvmc_debug_factory_create>
// to confirm our settings, and we call ~uvmc_find_factory_override>
// to confirm that our override has taken effect.
//
// Note the use of the UVM_INFO and UVM_ERROR macros, which issue
// reports to UVM for filtering, formatting, and display.
//---------------------------------------------------------------------

//(begin inline source)
void top::show_uvm_factory()
{
  string override;

  // print the factory before we do anything
  uvmc_print_factory();

  // what type would the factory give if we asked for a producer?
  override = uvmc_find_factory_override("producer","e.prod");

  UVMC_INFO("SHOW_FACTORY",
    (string("Factory override for type 'producer' ") +
     + "in context 'e.prod' is " + override).c_str(),
     UVM_NONE,"");

  // show how factory chooses what type it creates
  uvmc_debug_factory_create("producer","e.prod");

  // set a type and instance override
  uvmc_set_factory_type_override("producer","producer_ext","e.*");
  uvmc_set_factory_inst_override("scoreboard","scoreboard_ext","e.*");

  // print the factory after setting overrides
  uvmc_print_factory();

  uvmc_debug_factory_create("producer","e.prod");
  uvmc_debug_factory_create("scoreboard","e.sb");

  // NOW what type would the factory give if we asked for a producer?
  override = uvmc_find_factory_override("producer","e.prod");

  UVMC_INFO("SHOW_FACTORY",
    (string("Factory override for type 'producer' ") +
     + "with context 'e.prod' is " + override).c_str(),
     UVM_NONE,"");

  // What type would the factory give if we asked for a scoreboard?
  override = uvmc_find_factory_override("scoreboard","e.*");

  UVMC_INFO("SHOW_FACTORY",
    (string("Factory override for type 'scoreboard' ") +
     + "given a context 'e.*' is " + override).c_str(),
     UVM_NONE,"");
}
// (end inline source)


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
