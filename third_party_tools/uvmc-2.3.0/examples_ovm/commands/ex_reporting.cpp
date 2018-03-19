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
// Title: UVMC Command API Example - Reporting
//
// This code provides an example of issuing UVM reports and setting
// report verbosity from SC.
//
// uvmc_report - Send a report to UVM for processing
//
// uvmc_set_report_verbosity - Set the verbosity level of messages
//      coming from the given context(s).
//
// uvmc_report_enabled - Return true if a report of the given severity,
//      verbosity, and ID would be issued. Return 0 if it would be
//      filtered.
//
// UVMC_INFO - Send an info report to UVM for processing if
//             ~uvmc_report_enabled~ returns true. File and
//             line number are provided in the call to ~uvmc_report~.
//
// UVMC_WARNING - Send a warning report to UVM for processing if
//             ~uvmc_report_enabled~ returns true. File and
//             line number are provided in the call to ~uvmc_report~.
//
// UVMC_ERROR - Send an error report to UVM for processing if
//             ~uvmc_report_enabled~ returns true. File and
//             line number are provided in the call to ~uvmc_report~.
//
// UVMC_FATAL - Send a fatal report to UVM for processing if
//             ~uvmc_report_enabled~ returns true. File and
//             line number are provided in the call to ~uvmc_report~.
//
// The UVM reporting API provides a means of issuing reports from SC
// that are filtered and formatted by the standard UVM reporting
// mechanism in SV. Reports from SC are subject to the same filtering
// and report catching semantics as native UVM reports.
//
// Reports issued from SC via <uvmc_report> use the global ~uvm_top~
// as context, but the provided ~context~ is displayed to screen.
// To have the actual SC ~context~ participate in finer-grained
// report filtering, use the report catching mechanism.
//
// When setting report verbosity from SC, the ~context~ argument refers
// to SV context. Use a context of "" when setting verbosity level
// for reports issued from SC via <uvmc_report>.
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
// - Spawn a thread function, ~show_uvm_reporting~
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
    SC_THREAD(show_uvm_reporting);
    uvmc_connect(cons.in,"foo");
    uvmc_connect(cons.ap,"bar");
  }

  void show_uvm_reporting();

  private:
  void issue_reports();
};
//(end inline source)


//---------------------------------------------------------------------
// Function: show_uvm_factory
//
// This function sets UVM's report verbosity to various levels and
// issues several reports to demonstrate the effect.
//---------------------------------------------------------------------

// (inline source)
void top::show_uvm_reporting()
{
  // wait for UVM to start run phase
  uvmc_wait_for_phase("run", UVM_PHASE_STARTED);

  cout << endl << "Verbosity = FULL" << endl;
  uvmc_set_report_verbosity(UVM_FULL, "", 1);
  issue_reports();

  cout << endl << "Verbosity = HIGH" << endl;
  uvmc_set_report_verbosity(UVM_HIGH, "", 1);
  issue_reports();

  cout << endl << "Verbosity = MEDIUM" << endl;
  uvmc_set_report_verbosity(UVM_MEDIUM, "", 1);
  issue_reports();

  cout << endl << "Verbosity = LOW" << endl;
  uvmc_set_report_verbosity(UVM_LOW, "", 1);
  issue_reports();

  cout << endl << "Verbosity = NONE" << endl;
  uvmc_set_report_verbosity(UVM_NONE, "", 1);
  issue_reports();

  // back to the default
  uvmc_set_report_verbosity(UVM_MEDIUM, "", 1);
}

void top::issue_reports()
{
  UVMC_INFO("MY_INFO-NONE","Some none message", UVM_NONE,   name());
  UVMC_INFO("MY_INFO-LOW ","Some low  message", UVM_LOW,    name());
  UVMC_INFO("MY_INFO-MED ","Some med  message", UVM_MEDIUM, name());
  UVMC_INFO("MY_INFO-HIGH","Some high message", UVM_HIGH,   name());
  UVMC_INFO("MY_INFO-FULL","Some full message", UVM_FULL,   name());
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
