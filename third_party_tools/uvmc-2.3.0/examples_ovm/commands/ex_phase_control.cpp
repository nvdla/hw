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
// Title: UVMC Command API Example - Phase Control
//
// This code provides an example of waiting for each UVM phase to reach
// a specified state and then, if the phase is a task phase, controlling
// its progression by raising and dropping the objection that governs it.
//
// uvmc_wait_for_phase - block until UVM has reached a certain phase.
//      You may also wait for certain phase state (e.g. started, ended,
//      etc.)
//
// uvmc_raise_objection - prevent a UVM phase from ending
//
// uvmc_drop_objection - remove your objection to ending a UVM phase
//
// See the <Phasing> command descriptions for more details.
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// CLASS: top
//
// Our top-level SC module does the following
//
// - Creates an instance of a generic <consumer>. The consumer merely
//   prints the transactions it receives side and sends them out its
//   analysis port.
//
// - Spawn a thread function, ~show_uvm_phasing~
//
// - Register the consumer's ports for UVMC connection.
//
//----------------------------------------------------------------------

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
    SC_THREAD(show_uvm_phasing);
    uvmc_connect(cons.in,"foo");
    uvmc_connect(cons.ap,"bar");
  }

  void show_uvm_phasing();

  private:
  void spawn_phase_control_proc(const char* phase, bool is_task_phase);
  void wait_phase_started(const char* ph_name, bool is_task_phase);
};
// (end inline source)


//----------------------------------------------------------------------
// Function: show_uvm_phasing
//
// The ~show_uvm_phasing~ thread spawns as many sub-processes as there
// are predefined phases in UVM, where each thread will wait for its
// associated phase. If the phase is a task-based phase, each thread
// will raise an objection, delay, then drop the objection. This shows
// how SC can prevent a UVM phase from ending. The
// <UVMC Connection Example - SC to SV, SC side> shows one practical
// use for phase control.
//----------------------------------------------------------------------

// (begin inline source)
void top::show_uvm_phasing()
{
  wait(SC_ZERO_TIME);

  // common phases
  spawn_phase_control_proc("build",0);
  spawn_phase_control_proc("connect",0);
  spawn_phase_control_proc("end_of_elaboration",0);
  spawn_phase_control_proc("start_of_simulation",0);
  spawn_phase_control_proc("run",1);
  spawn_phase_control_proc("extract",0);
  spawn_phase_control_proc("check",0);
  spawn_phase_control_proc("report",0);
}
// (end inline source)


//----------------------------------------------------------------------
// Function: spawn_phase_control_proc
//
// A convenience function for spawning a dynamic SC thread.
//----------------------------------------------------------------------

// (begin inline source)
void top::spawn_phase_control_proc(const char* phase, bool is_task_phase)
{
  sc_spawn(sc_bind(&top::wait_phase_started,this,phase,
         is_task_phase), (string("wait_for_") + phase).c_str());
}
// (end inline source)


//----------------------------------------------------------------------
// Function: wait_phase_started
//
// This function is spawned as a dynamic SC thread for each predefined
// phase in UVM. Each thread waits for the UVM phase given by ~ph_name~
// to reach the started state. If the phase is a task phase, it will
// raise an objection, wait 10ns, then drop the objection. The reports
// that get emitted will show that UVM phases are being controlled by
// these threads.
//----------------------------------------------------------------------

// (begin inline source)
void top::wait_phase_started(const char* ph_name, bool is_task_phase)
{

  UVMC_INFO("SC_TOP/WAITING",(string("Waiting for phase ") +
            ph_name + " to start...").c_str(),UVM_LOW,"");

  uvmc_wait_for_phase(ph_name, UVM_PHASE_STARTED);

  UVMC_INFO("SC_TOP/PH_STARTED", (string(name()) + ": Phase " +
            ph_name + " has started").c_str(), UVM_MEDIUM,"");

  // if a task, raise and drop objection

  if (is_task_phase)
  {
    UVMC_INFO("SC_TOP/RAISE_OBJ",
              (string(name()) + " raising objection in phase "
              + ph_name).c_str(), UVM_MEDIUM,"");

    uvmc_raise_objection(ph_name, name(), "SC waiting 10ns");

    // wait some delay to prove we are in control...
    wait(sc_time(10,SC_NS));

    UVMC_INFO("SC_TOP/DROP_OBJ",
              (string(name()) + " dropping objection in phase "
              + ph_name).c_str(), UVM_MEDIUM,"");

    uvmc_drop_objection(ph_name, name(), "10ns has passed");
  }
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
