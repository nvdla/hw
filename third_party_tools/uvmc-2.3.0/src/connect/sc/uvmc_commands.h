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
// Title: UVMC Command API
//
// This section describes the API for accessing and controlling UVM simulation
// in SystemVerilog from SystemC (or C or C++). To use, the SV side must have
// called the ~uvmc_init~, which starts a background process that receives and
// processes incoming commands.
// 
// The UVM Connect library provides an SystemC API for accessing SystemVeilog
// UVM during simulation. With this API users can:
//
// - Wait for a UVM to reach a given simulation phase
// - Raise and drop objections
// - Set and get UVM configuration
// - Send UVM report messages
// - Set type and instance overrides in the UVM factory
// - Print UVM component topology
//
// While most commands are compatible with C, a few functions take object
// arguments or block on sc_events. Therefore, SystemC is currently the only
// practical source language for using the UVM Command API. Future releases may
// separate the subset of C-compatible functions into a separate shared library
// that would not require linking in SystemC.
//
// The following may appear in a future release, based on demand
//
// - Callbacks on phase and objection activity
// - Receive UVM report messages, i.e. SC-side acts as report catcher or server
// - Integration with SystemCs sc_report_handler facility
// - Print factory contents, config db contents, and other UVM information
// - Separate command layer into SC, C++, and C-accessible components; i.e.
//   not require SystemC for non-SystemC-dependent functions
//
// The following sections provide details and examples for each command in the
// UVM Command API. To enable access to the UVM command layer, you must call
// the uvmc_cmd_init function from an initial block in a top-level module as in
// the following example:
// 
// SystemVerilog:
//
//| module sv_main;
//| 
//|   import uvm_pkg::*;
//|   import uvmc_pkg::*;
//| 
//|   initial begin
//|     uvmc_cmd_init();
//|     run_test();
//|   end
//| 
//| endmodule
//
// SystemC-side calls to the UVM Command API will block until SystemVerilog has
// finished elaboration and the uvmc_cmd_init function has been called. Because
// any call to the UVM Command layer may block, calls must be made from within
// thread processes.
//
// All code provided in the UVM Command descriptions that follow are SystemC
// unless stated otherwise.


#ifndef UVMC_COMMANDS_H
#define UVMC_COMMANDS_H

#include "svdpi.h"

#include <string>
#include <map>
#include <vector>
#include <iomanip>
#include <systemc.h>
#include <tlm.h>


using namespace sc_core;
using namespace sc_dt;
using namespace tlm;
using std::string;
using std::map;
using std::vector;
using sc_core::sc_semaphore;

#include "uvmc_common.h"
#include "uvmc_convert.h"

extern "C" {


//------------------------------------------------------------------------------
// Group: Enumeration Constants
//
// The following enumeration constants are used in various UVM Commands:
//------------------------------------------------------------------------------

// Enum: uvmc_phase_state
//
// The state of a UVM phase
//
//    UVM_PHASE_DORMANT      - Phase has not started yet
//    UVM_PHASE_STARTED      - Phase has started
//    UVM_PHASE_EXECUTING    - Phase is executing
//    UVM_PHASE_READY_TO_END - Phase is ready to end
//    UVM_PHASE_ENDED        - Phase has ended
//    UVM_PHASE_DONE         - Phase has completed
//
enum uvmc_phase_state {
   UVM_PHASE_DORMANT      = 1,
   UVM_PHASE_SCHEDULED    = 2,
   UVM_PHASE_SYNCING      = 4,
   UVM_PHASE_STARTED      = 8,
   UVM_PHASE_EXECUTING    = 16,
   UVM_PHASE_READY_TO_END = 32,
   UVM_PHASE_ENDED        = 64,
   UVM_PHASE_CLEANUP      = 128,
   UVM_PHASE_DONE         = 256,
   UVM_PHASE_JUMPING      = 512
   };


// Enum: uvmc_report_severity
//
// The severity of a report
//
//   UVM_INFO    - Informative message. Verbosity settings affect whether
//                 they are printed.
//   UVM_WARNING - Warning. Not affected by verbosity settings.
//   UVM_ERROR   - Error. Error counter incremented by default.  Not affected
//                 by verbosity settings.
//   UVM_FATAL   - Unrecoverable error. SV simulation will end immediately.
// 
enum uvmc_report_severity {
   UVM_INFO,
   UVM_WARNING,
   UVM_ERROR,
   UVM_FATAL
   };


// Enum: uvmc_report_verbosity
//
// The verbosity level assigned to UVM_INFO reports
//
//   UVM_NONE   - report will always be issued (unaffected by
//                verbosity level)
//   UVM_LOW    - report is issued at low verbosity setting and higher
//   UVM_MEDIUM - report is issued at medium verbosity and higher
//   UVM_HIGH   - report is issued at high verbosity and higher
//   UVM_FULL   - report is issued only when verbosity is set to full
//
enum uvmc_report_verbosity {
   UVM_NONE   = 0,
   UVM_LOW    = 100,
   UVM_MEDIUM = 200,
   UVM_HIGH   = 300,
   UVM_FULL   = 400
   };


// Enum: uvmc_wait_op
//
// The relational operator to apply in <uvmc_wait_for_phase> calls
//
//   UVM_LT  - Wait until UVM is before the given phase
//   UVM_LTE - Wait until UVM is before or at the given phase
//   UVM_NE  - Wait until UVM is not at the given phase
//   UVM_EQ  - Wait until UVM is at the given phase
//   UVM_GT  - Wait until UVM is after the given phase
//   UVM_GTE - Wait until UVM is at or after the given phase
//
enum uvmc_wait_op {
   UVM_LT,
   UVM_LTE,
   UVM_NE,
   UVM_EQ,
   UVM_GT,
   UVM_GTE
   };


void wait_sv_ready();

} // extern "C"

//------------------------------------------------------------------------------
// UVM COMMANDS

extern "C" {

// Internal API (SV DPI Export Functions)

void UVMC_print_topology(const char* context="", int depth=-1);

bool UVMC_report_enabled    (const char* context,
                             int verbosity,
                             int severity,
                             const char* id);

void UVMC_set_report_verbosity(int level,
                             const char* context,
                             bool  recurse=0);

void UVMC_report            (int severity,
                             const char* id,
                             const char* message,
                             int verbosity,
                             const char* context,
                             const char* filename,
                             int line);
// up to 64 bits
void UVMC_set_config_int    (const char* context, const char* inst_name,
                             const char* field_name, uint64 value);
void UVMC_set_config_object (const char* type_name,
                             const char* context, const char* inst_name,
                             const char* field_name, const bits_t *value);
void UVMC_set_config_string (const char* context, const char* inst_name,  
                             const char* field_name, const char* value);
bool UVMC_get_config_int    (const char* context, const char* inst_name,
                             const char* field_name, uint64 *value);
bool UVMC_get_config_object (const char* type_name,
                             const char* context, const char* inst_name,
                             const char* field_name, bits_t* bits);
bool UVMC_get_config_string (const char* context, const char* inst_name,  
                             const char* field_name, const char** value);


void UVMC_raise_objection   (const char* name, const char* context="",
                             const char* description="", unsigned int count=1);

void UVMC_drop_objection    (const char* name, const char* context="",
                             const char* description="", unsigned int count=1);

void UVMC_print_factory (int all_types=1);

void UVMC_set_factory_inst_override
                            (const char* original_type_name,
                             const char* override_type_name,
                             const char* full_inst_path);

void UVMC_set_factory_type_override (const char* original_type_name,
                             const char* override_type_name,
                             bool replace=1);

void UVMC_debug_factory_create (const char* requested_type,
                             const char* context="");

void UVMC_find_factory_override (const char* requested_type,
                             const char* context,
                             const char** override_type_name);


int  UVMC_wait_for_phase_request(const char *phase, int state, int op);

void UVMC_get_uvm_version(unsigned int *major, unsigned int *minor, char **fix);

bool SV2C_phase_notification(int id);
bool SV2C_sv_ready();

void uvmc_set_scope(); // internal

} // extern "C"


extern "C" {

//------------------------------------------------------------------------------
// Group: Topology
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Function: uvmc_print_topology
//
// Prints the current UVM testbench topology.
//
// If called prior to UVM completing the build phase,
// the topology will be incomplete.
//
// Arguments:
//
// context - The hierarchical path of the component from which to start printing
//           topology. If unspecified, topology printing will begin at
//           uvm_top.  Multiple components can be specified by using glob
//           wildcards (* and ?), e.g. "top.env.*.driver". You can also specify
//           a POSIX extended regular expression by enclosing the contxt in
//           forward slashes, e.g. "/a[hp]b/".  Default: "" (uvm_top)
//
// depth   - The number of levels of hierarchy to print. If not specified,
//           all levels of hierarchy starting from the given context are printed.
//           Default: -1 (recurse all children)
//------------------------------------------------------------------------------
//
void uvmc_print_topology (const char *context="", int depth=-1);


//------------------------------------------------------------------------------
// Group: Reporting
//
// The reporting API provides the ability to issue UVM reports, set verbosity,
// and other reporting features.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Function: uvmc_report_enabled
//
// Returns true if a report at the specified verbosity, severity, and id would
// be emitted if made within the specified component contxt.
//
// The primary purpose of this command is to determine whether a report has a
// chance of being emitted before incurring the high run-time overhead of
// formatting the string message.
//
// A report at severity UVM_INFO is ignored if its verbosity is greater than
// the verbosity configured for the component in which it is issued. Reports at
// other severities are not affected by verbosity settings.
//
// If the action of a report with the specified severity and id is configured
// as UVM_NO_ACTION within the specified component contxt.
//
// Filtration by any registered report_catchers is not considered.
//
// Arguments:
//
// verbosity - The uvmc_report_verbosity of the hypothetical report.
//
// severity  - The <uvmc_report_severity> of the hypothetical report.
//             Default: UVM_INFO.
//
// id        - The identifier string of the hypothetical report. Must be an
//             exact match. If not specified, then uvmc_report_enabled checks
//             only if UVM_NO_ACTION is the configured action for the given
//             severity at the specified context. Default: "" (unspecified)
//
// context   - The hierarchical path of the component that would issue the
//             hypothetical report. If not specified, the context is global,
//             i.e. uvm_top. Reports not issued by components come from uvm_top.
//             Default: "" (unspecified)
// 
// Example:
//
//| if (uvmc_report_enabled(UVM_HIGH, UVM_INFO, "PRINT_TRANS") {
//|   string detailed_msg;
//|   ...prepare message string here...
//|   uvmc_report(UVM_INFO, "PRINT_TRANS", detailed_msg, UVM_HIGH);
//| }
//------------------------------------------------------------------------------
//
bool uvmc_report_enabled (int verbosity,
                          int severity=UVM_INFO,
                          const char* id="",
                          const char* context="");


//------------------------------------------------------------------------------
// Function: uvmc_set_report_verbosity
//
// Sets the run-time verbosity level for all UVM_INFO-severity reports issued
// by the component(s) at the specified context. Any report from the component
// context whose verbosity exceeds this maximum will be ignored.
//
// Reports issued by SC via uvmc_report are affected only by the verbosity level
// setting for the global context, i.e. context="". To have finer-grained
// control over SC-issued reports, register a uvm_report_catcher with uvm_top.
//
// Arguments:
//
// level   - The verbosity level. Specify UVM_NONE, UVM_LOW, UVM_MEDIUM,
//           UVM_HIGH, or UVM_FULL. Required.
//
// context - The hierarchical path of the component. Multiple components can be
//           specified by using glob wildcards * and ?, e.g. "top.env.*.driver".
//           You can also specify a POSIX extended regular expression by
//           enclosing the contxt in forward slashes, e.g. "/a[hp]b/".
//           Default: "" (uvm_top)
//
// recurse - If true, sets the verbosity of all descendents of the component(s)
//           matching context. Default:false
// 
// Examples:
//
// Set global UVM report verbosity to maximum (FULL) output:
//
//   | uvmc_set_report_verbosity(UVM_FULL);
// 
// Disable all filterable INFO reports for the top.env.agent1.driver,
// but none of its children:
//
//   | uvmc_set_report_verbosity(UVM_NONE, "top.env.agent1.driver");
// 
// Set report verbosity for all components to UVM_LOW, except for the
// troublemaker component, which gets UVM_HIGH verbosity:
//
//   | uvmc_set_report_verbosity(UVM_LOW, true);
//   | uvmc_set_report_verbosity(UVM_HIGH, "top.env.troublemaker");
// 
// In the last example, the recursion flag is set to false, so all of
// troublemaker's children, if any, will remain at UVM_LOW verbosity.
//------------------------------------------------------------------------------

void uvmc_set_report_verbosity (int level,
                                const char* context="",
                                bool recurse=0);


//------------------------------------------------------------------------------
// Function: uvmc_report
//
// Send a report to UVM for processing, subject to possible filtering by
// verbosity, action, and active report catchers.
//
// See uvmc_report_enabled to learn how a report may be filtered.
//
// The UVM report mechanism is used instead of $display and other ad hoc
// approaches to ensure consistent output and to control whether a report is
// issued and what if any actions are taken when it is issued. All reporting
// methods have the same arguments, except a verbosity level is applied to
// UVM_INFO-severity reports.
//
// Arguments:
//
// severity  - The report severity: specify either UVM_INFO, UVM_WARNING,
//             UVM_ERROR, or UVM_FATAL. Required argument.
//
// id        - The report id string, used for identification and targeted
//             filtering. See context description for details on how the
//             report's id affects filtering. Required argument.
//
// message   - The message body, pre-formatted if necessary to a single string.
//             Required.
//
// verbosity - The verbosity level indicating an INFO report's relative detail.
//             Ignored for warning, error, and fatal reports. Specify UVM_NONE,
//             UVM_LOW, UVM_MEDIUM, UVM_HIGH, or UVM_FULL. Default: UVM_MEDIUM. 
//
// context   - The hierarchical path of the SC-side component issuing the
//             report. The context string appears as the hierarchical name in
//             the report on the SV side, but it does not play a role in report
//             filtering in all cases. All SC-side reports are issued from the
//             global context in UVM, i.e. uvm_top. To apply filter settings,
//             make them from that context, e.g. uvm_top.set_report_id_action().
//             With the context fixed, only the report's id can be used to
//             uniquely identify the SC report to filter. Report catchers,
//             however, are passed the report's context and so can filter based
//             on both SC context and id. Default: "" (unspecified)
//
// filename  - The optional filename from which the report was issued. Use
//             __FILE__. If specified, the filename will be displayed as part
//             of the report. Default: "" (unspecified)
//
// line      - The optional line number within filename from which the report
//             was issued. Use __LINE__. If specified, the line number will be
//             displayed as part of the report. Default: 0 (unspecified)
// 
// Examples:
//
// Send a global (uvm_top-sourced) info report of medium verbosity to UVM:
//
// | uvmc_report(UVM_INFO, "SC_READY", "SystemC side is ready");
// 
// Issue the same report, this time with low verbosity a filename and line number.
//
// | uvmc_report(UVM_INFO, "SC_READY", "SystemC side is ready",
// |                      UVM_LOW, "", __FILE__, __LINE__);
// 
// UVM_LOW verbosity does not mean lower output. On the contrary, reports with
// UVM_LOW verbosity are printed if the run-time verbosity setting is anything
// but UVM_NONE. Reports issued with UVM_NONE verbosity cannot be filtered by
// the run-time verbosity setting.
//
// The next example sends a WARNING and INFO report from an SC-side producer
// component. In SV, we disable the warning by setting the action for its
// effective ID to UVM_NO_ACTION. We also set the verbosity threshold for INFO
// messages with the effective ID to UVM_NONE. This causes the INFO report to
// be filtered, as the run-time verbosity for reports of that particular ID are
// now much lower than the reports stated verbosity level (UVM_HIGH). 
//
//| class producer : public sc_module {
//|  ...
//|   void run_thread() {
//|     ...
//|     uvmc_report(UVM_WARNING, "TransEvent",
//|            "Generated error transaction.",, this.name());
//|     ...
//|     uvmc_report(UVM_INFO, "TransEvent",
//|            "Transaction complete.", UVM_HIGH, this.name());
//|     ...
//|   }
//| };
// 
// To filter SC-sourced reports on the SV side:
//
//| uvm_top.set_report_id_action("TransEvent@top/prod",UVM_NO_ACTION);
//| uvm_top.set_report_id_verbosity("TransEvent@top/prod",UVM_NONE);
//| uvm_top.set_report_id_verbosity("TransDump",UVM_NONE);
// 
// The last statement disables all reports to the global context (uvm_top)
// having the ID "TransDump". Note that it is currently not possible to
// set filters for reports for several contexts at once using wildcards. Also,
// the hierarchical separator for SC may be configurable in your simulator, and
// thus could affect the context provided to these commands.
//------------------------------------------------------------------------------

void uvmc_report (int severity, 
                  const char* id,
                  const char* message,
                  int verbosity=UVM_MEDIUM,
                  const char* context="",
                  const char* filename="",
                  int line=0);



// Function: uvmc_report_info
//
// Equivalent to <uvmc_report> (UVM_INFO, ...)

void uvmc_report_info (const char* id,
                       const char* message,
                       int verbosity=UVM_MEDIUM,
                       const char* context="",
                       const char* filename="",
                       int line=0);


// Function: uvmc_report_warning
//
// Equivalent to <uvmc_report> (UVM_WARNING, ...)

void uvmc_report_warning (const char* id,
                          const char* message,
                          const char* context="",
                          const char* filename="",
                          int line=0);

// Function: uvmc_report_error
//
// Equivalent to <uvmc_report> (UVM_ERROR, ...)

void uvmc_report_error (const char* id,
                        const char* message,
                        const char* context="",
                        const char* filename="",
                        int line=0);


// Function: uvmc_report_fatal
//
// Equivalent to <uvmc_report> (UVM_FATAL, ...)

void uvmc_report_fatal (const char* id,
                        const char* message,
                        const char* context="",
                        const char* filename="",
                        int line=0);


//------------------------------------------------------------------------------
// Topic: Report Macros
//
// Convenience macros to <uvmc_report>.
// See <uvmc_report> for details on macro arguments.
//
// | UVMC_INFO    (ID, message, verbosity, context)
// | UVMC_WARNING (ID, message, context)
// | UVMC_ERROR   (ID, message, context)
// | UVMC_FATAL   (ID, message, context)
//
//
// Before sending the report, the macros first call <uvmc_report_enabled> to
// avoid sending the report at all if its verbosity or action would prevent
// it from reaching the report server. If the report is enabled, then
// <uvmc_report> is called with the filename and line number arguments
// provided for you.
//
// Invocations of these macros must be terminated with semicolons, which is
// in keeping with the SystemC convention established for the ~SC_REPORT~
// macros. Future releases may provide a UVMC sc_report_handler that you
// can use to redirect all SC_REPORTs to UVM.
//
// Example:
//
//| UVMC_ERROR("SC_TOP/NO_CFG","Missing required config object", name());
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Group: Phasing
//
// An API that provides access UVM's phase state and the objection objects used
// to control phase progression.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Function: uvmc_wait_for_phase
//
// Wait for a UVM phase to reach a certain state.
//
// The call must be made from a SystemC process thread that is either statically
// declared via SC_THREAD or dynamically started via sc_spawn. If the latter,
// you must include the following define on the sccom command
// line: -DSC_INCLUDE_DYNAMIC_PROCESSES.
//
// Arguments:
//
// phase  - The name of the phase to wait on. The built-in phase names are, in
//          order of execution: build, connect, end_of_elaboration,
//          start_of_simulation, run, extract, check, report. The fine-grained
//          run-time phases, which run in parallel with the run phase, are, in
//          order: pre_reset, reset, post_reset, pre_configure, configure,
//          post_configure, pre_main, main, post_main, pre_shutdown, shutdown,
//          and post_shutdown.
//
// state  - The state to wait on.  A phase may transition through
//          ~UVM_PHASE_JUMPING~ instead of UVM_PHASE_READY_TO_END if its
//          execution had been preempted by a phase jump operation. Phases
//          execute in the following state order: 
//
//          | UVM_PHASE_STARTED
//          | UVM_PHASE_EXECUTING
//          | UVM_PHASE_READY_TO_END | UVM_PHASE_JUMPING
//          | UVM_PHASE_ENDED
//          | UVM_PHASE_DONE
// 
// condition - The state condition to wait for. When state is
//          ~UVM_PHASE_JUMPING~, ~condition~ must be UVM_EQ. Default is
//          ~UVM_EQ~. Valid values are:
//
//          | UVM_LT - Phase is before the given state.
//          | UVM_LTE - Phase is before or at the given state.
//          | UVM_EQ - Phase is at the given state.
//          | UVM_GTE - Phase is at or after the given state.
//          | UVM_GT - Phase is after the given state.
//          | UVM_NE - Phase is not at the given state.
//
// 
// Examples:
//
// The following example shows how to spawn threads that correspond to UVM's
// phases. Here, the ~run_phase~ method executes during the UVM's run phase.
// As any UVM component executing the run phase would do, the SC component's
// ~run_phase~ process prevents the UVM (SV-side) run phase from ending until
// it is finished by calling <uvmc_drop_objection>.
// 
//| SC_MODULE(top)
//| {
//|   sc_process_handle run_proc;
//| 
//|   SC_CTOR(top) {
//|     run_proc = sc_spawn(sc_bind(&run_phase,this),"run_phase");
//|   };
//|   
//|   void async_reset() {
//|     if (run_proc != null && run_proc.valid())
//|       run_proc.reset(SC_INCLUDE_DESCENDANTS);
//|   }
//| 
//|   void run_phase() {
//|    uvmc_wait_for_phase("run",UVM_PHASE_STARTED,UVM_EQ);
//|    uvmc_raise_objection("run","","SC run_phase executing");
//|      ...
//|    uvmc_drop_objection("run","","SC run_phase finished");
//|   }
//| };
// 
// If ~async_reset~ is called, the run_proc process and all descendants are
// killed, then run_proc is restarted. The run_proc calls run_phase again,
// which first waits for the UVM to reach the run_phase before resuming
// its work.
//------------------------------------------------------------------------------

void uvmc_wait_for_phase(const char *phase,
                         uvmc_phase_state state,
                         uvmc_wait_op op=UVM_EQ);



//------------------------------------------------------------------------------
// Function: uvmc_raise_objection

void uvmc_raise_objection (const char* name,
                           const char* context="",
                           const char* description="",
                           unsigned int count=1);

// Function: uvmc_drop_objection
//
// Raise or drop an objection to ending the specified phase on behalf of the
// component at a given context. Raises can be made before the actual phase is
// executing. However, drops that move the objection count to zero must be
// avoided until the phase is actually executing, else the all-dropped
// condition will occur prematurely. Typical usage includes calling
// <uvmc_wait_for_phase>.

// Arguments:
//
// name    - The verbosity level. Specify UVM_NONE, UVM_LOW, UVM_MEDIUM,
//           UVM_HIGH, or UVM_FULL. Required.
//
// context - The hierarchical path of the component on whose behalf the
//           specified objection is raised or dropped. Wildcards or regular
//           expressions are not allowed. The context must exactly match an
//           existing component's hierarchical name. Default: "" (uvm_top)
//
// description - The reason for raising or dropping the objection. This string
//           is passed in all callbacks and printed when objection tracing is
//           turned on. Default: ""
//
// count   - The number of objections to raise or drop. Default: 1
// 
// Examples:
//
// The following routine will force the specified UVM task phase to last at
// minimum number of nanoseconds, assuming SystemC and SystemVerilog are
// operating on the same timescale.
//
//| void set_min_phase_duration(const char* ph_name, sc_time min_time) {
//|   uvmc_wait_for_phase(ph_name, UVM_PHASE_STARTED);
//|   uvmc_raise_objection(ph_name,"","Forcing minimum run time");
//|   wait(min_time); 
//|   uvmc_drop_objection(ph_name,"","Phase met minimum run time");
//| }
//
// Use directly as a blocking call, or use in non-blocking fashion with
// sc_spawn/sc_bind:
//
//| sc_spawn(sc_bind(&top:set_min_phase_duration, // <--func pointer
//|          this,"run",sc_time(100,SC_NS)),"min_run_time");
//------------------------------------------------------------------------------

void uvmc_drop_objection (const char* name,
                          const char* context="",
                          const char* description="",
                          unsigned int count=1);



//------------------------------------------------------------------------------
// Group: Factory
//
// This API provides access to UVM's object and component factory.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Function: uvmc_print_factory
//
// Prints the state of the UVM factory, including registered types, instance
// overrides, and type overrides.
//
// Arguments:
//
// all_types - When all_types is 0, only type and instance overrides are
//             displayed. When all_types is 1 (default), all registered
//             user-defined types are printed as well, provided they have type
//             names associated with them. (Parameterized types usually do not.)
//             When all_types is 2, all UVM types (prefixed with uvm_) are
//             included in the list of registered types.
//
// Examples:
//
// Print all type and instance overrides in the factory.
//
//| uvmc_print_factory(0);
//
// Print all type and instance overrides, plus all registered user-defined
// types.
//
//| uvmc_print_factory(1);
// 
// Print all type and instance overrides, plus all registered types, including
// UVM types.
//
//| uvmc_print_factory(2);
//------------------------------------------------------------------------------

void uvmc_print_factory (int all_types=1);



//------------------------------------------------------------------------------
// Function: uvmc_set_factory_type_override

void uvmc_set_factory_type_override (const char* original_type,
                                     const char* override_type,
                                     bool replace=1);

// Function: uvmc_set_factory_inst_override
//
// Set a type or instance override. Instance overrides take precedence over
// type overrides. All specified types must have been registered with the
// factory.
//
// Arguments:
//
// requested_type - The name of the requested type.
//
// override_type  - The name of the override type. Must be an extension of the
//                  requested_type.
//
// context        - The hierarchical path of the component. Multiple components
//                  can be specified by using glob wildcards (* and ?), e.g.
//                  "top.env.*.driver". You can also specify a POSIX extended
//                  regular expression by enclosing the context string in
//                  forward slashes, e.g. "/a[hp]b/".
//
// replace        - If true, replace any existing type override. Default: true
// 
// Examples:
//
// The following sets an instance override in the UVM factory. Any component
// whose inst path matches the glob expression "e.*" that requests an object
// of type scoreboard_base (i.e. scoreboard_base:type_id::create) will instead
// get an object of type scoreboard.
//
//| uvmc_set_factory_inst_override("scoreboard_base","scoreboard","e.*");
// 
// The following sets a type override in the UVM factory. Any component whose
// hierarchical path matches the glob expression "e.*" that requests an
// object of type producer_base (i.e. producer_base:type_id::create) will
// instead get an object of type producer.
//
//| uvmc_set_factory_type_override("producer_base","producer");
// 
// The following sets an override chain. Given any request for an atype, a
// ctype object is returned, except for the component with hierarchical name
// "e.prod", which will get a dtype.
//
//| uvmc_set_factory_type_override("atype","btype");
//| uvmc_set_factory_type_override("btype","ctype");
//| uvmc_set_factory_inst_override("ctype","dtype","e.prod");
//------------------------------------------------------------------------------

void uvmc_set_factory_inst_override (const char* original_type,
                                     const char* override_type,
                                     const char* context);


//------------------------------------------------------------------------------
// Function: uvmc_debug_factory_create
//
// Display detailed information about the object type the UVM factory would
// create given a requested type and context, listing each override that was
// applied to arrive at the result.
//
// Arguments:
//
// requested - The requested type name for a hypothetical call to create.
//
// context   - The hierarchical path of the object to be created, which is a
//             concatenation of the parent's hierarchical name with the
//             name of the object being created. Wildcards or regular
//             expressions are not allowed. The context must exactly match
//             an existing component's hierarchical name, or can be the
//             empty string to specify global context.
// 
// Example:
//
// The following example answers the question: If the component at
// hierarchical path ~env.agent1.scoreboard~ requested an object of type
// scoreboard_base, what are all the applicable overrides, and which of
// those were applied to arrive at the result?
//
//| uvmc_debug_factory_create("scoreboard_base","env.agent1.scoreboard");
//------------------------------------------------------------------------------

void uvmc_debug_factory_create (const char* requested_type,
                                const char* context="");


//------------------------------------------------------------------------------
// Function: uvmc_find_factory_override
//
// Returns the type name of the type that would be created by the factory given
// the requested type and context.
//
// Arguments:
//
// requested - The requested type name for a hypothetical call to create.
//
// context   - The hierarchical path of the component that would make the
//             request. Wildcards or regular expressions are not allowed.
//             The context must exactly match an existing component's
//             hierarchical name, or can be the empty string to specify
//             global context.
// 
// Examples:
//
// The following examples assume all types, A through D, have been registered
// with the UVM factory. Given the following overrides:
//
//| uvmc_set_type_override("B","C");
//| uvmc_set_type_override("A","B");
//| uvmc_set_inst_override("D", "C", "top.env.agent1.*");
// 
// The following will display "C":
//
//| $display(uvmc_find_factory_override("A"));
// 
// The following will display "D":
//
//| $display(uvmc_find_factory_override("A", "top.env.agent1.driver"));
// 
// The returned string can be used in subsequent calls to
// <uvmc_set_factory_type_override> and <uvmc_set_factory_inst_override>.
//------------------------------------------------------------------------------

string uvmc_find_factory_override (const char* requested_type,
                                  const char* context="");




//------------------------------------------------------------------------------
// Group: set_config
//------------------------------------------------------------------------------
// 
// Creates or updates a configuration setting for a field at a specified
// hierarchical context.
//
// These functions establish configuration settings, storing them as resource
// entries in the resource database for later lookup by get_config calls. They
// do not directly affect the field values being targeted. As the component
// hierarchy is being constructed during UVM's build phase, components
// spring into existence and establish their context. Once its context is
// known, each component can call get_config to retrieve any configuration
// settings that apply to it.
//
// The context is specified as the concatenation of two arguments, context and
// inst_name, which are separated by a "." if both context and inst_name are
// not empty. Both context and inst_name may be glob style or regular
// expression style expressions.
//
// The name of the configuration parameter is specified by the ~field_name~
// argument. 
//
// The semantic of the set methods is different when UVM is in the build phase
// versus any other phase. If a set call is made during the build phase, the
// context determines precedence in the database. A set call from a higher
// level in the hierarchy (e.g. mytop.test1) has precedence over a set call to
// the same field from a lower level (e.g. mytop.test1.env.agent). Set calls
// made at the same level of hierarchy have equal precedence, so each set call
// overwrites the field value from a previous set call.
//
// After the build phase, all set calls have the same precedence regardless of
// their hierarchical context. Each set call overwrites the value of the
// previous call.
// 
// Arguments:
//
// type_name  - For uvmc_set_config_object only. Specifies the type name of the
//              equivalent object to set in SV. UVM Connect will utilize the
//              factory to allocate an object of this type and unpack the
//              serialized value into it. Parameterized classes are not
//              supported.
//
// context    - The hierarchical path of the component, or the empty string,
//              which specifies uvm_top. Multiple components can be specified
//              by using glob wildcards (* and ?), e.g. "top.env.*.driver".
//              You can also specify a POSIX extended regular expression by
//              enclosing the contxt in forward slashes, e.g. "/a[hp]b/".
//              Default: "" (uvm_top)
//
// inst_name  - The instance path of the object being configured, relative to
//              the specified context(s). Can contain wildcards or be a
//              regular expression.
//
// field_name - The name of the configuration parameter. Typically this name
//              is the same as or similar to the variable used to hold the
//              configured value in the target context(s).
//
// value      - The value of the configuration parameter. Integral values
//              currently cannot exceed 64 bits. Object values must have a
//              uvmc_convert<object_type> specialization defined for it.
//              Use of the converter convenience macros is acceptable for
//              meeting this requirement.
//
// Examples:
//
// The following example sets the configuration object field at path
// "e.prod.trans" to the tr instance, which is type uvm_tlm_generic_payload.
//
//| uvmc_set_config_object("uvm_tlm_generic_payload","e.prod","","trans", tr);
// 
// The next example sets the string property at hierarchical path
// "e.prod.message" to "Hello from SystemC!".
//
//| uvmc_set_config_string ("e.prod", "", "message", "Hello from SystemC!");
// 
// The next example sets the integral property at hierarchical path
// "e.prod.start_addr" to hex 0x1234.
//
//| uvmc_set_config_int ("e.prod", "", "start_addr", 0x1234);
//------------------------------------------------------------------------------


// Function: uvmc_set_config_int
//
// Set an integral configuration value
//
void uvmc_set_config_int    (const char* context, const char* inst_name,
                            const char* field_name, uint64 value);

// Function: uvmc_set_config_string
//
// Set a string configuration value
//
void uvmc_set_config_string (const char* context, const char* inst_name,  
                            const char* field_name, const string& value);

} // extern "C"

namespace uvmc {

// Function: uvmc_set_config_object
//
// Set an object configuration value using a custom converter
//
template <class T, class CVRT>
void uvmc_set_config_object (const char* type_name,
                            const char* context,
                            const char* inst_name,
                            const char* field_name,
                            T &value,
                            uvmc_packer *packer=NULL) {
  static bits_t bits[UVMC_MAX_WORDS];
  static uvmc_packer def_packer;
  if (packer == NULL) {
    packer = &def_packer;
    //packer->big_endian = 0;
  }
  wait_sv_ready();
  packer->init_pack(bits);
  CVRT::do_pack(value,packer);
  svSetScope(uvmc_pkg_scope);
  UVMC_set_config_object(type_name,context,inst_name,field_name,bits);
}


// Function: uvmc_set_config_object
//
// Set an object configuration value using the default converter
//
template <class T>
void uvmc_set_config_object (const char* type_name,
                            const char* context,
                            const char* inst_name,
                            const char* field_name,
                            T &value,
                            uvmc_packer *packer=NULL) {
  static bits_t bits[UVMC_MAX_WORDS];
  static uvmc_packer def_packer;
  if (packer == NULL) {
    packer = &def_packer;
    //packer->big_endian = 0;
  }
  wait_sv_ready();
  packer->init_pack(bits);
  uvmc_converter<T>::do_pack(value,*packer);
  svSetScope(uvmc_pkg_scope);
  UVMC_set_config_object(type_name,context,inst_name,field_name,bits);
}

} // namespace uvmc


extern "C" {

//------------------------------------------------------------------------------
// Group: get_config
//------------------------------------------------------------------------------
//
// Gets a configuration field ~value~ at a specified hierarchical ~context~.
// Returns true if successful, false if a configuration setting could not be
// found at the given ~context~. If false, the ~value~ reference is unmodified.
//
// The ~context~ specifies the starting point for a search for a configuration
// setting for the field made at that level of hierarchy or higher. The
// ~inst_name~ is an explicit instance name relative to context and may be an
// empty string if ~context~ is the full context that the configuration
// setting applies to.
//
// The ~context~ and ~inst_name~ strings must be simple strings--no wildcards
// or regular expressions. 
//
// See the section on <set_config> for the semantics
// that apply when setting configuration.
//
// Arguments:
//
// type_name    - For <uvmc_get_config_object> only. Specifies the type name
//                of the equivalent object to retrieve in SV. UVM Connect
//                will check that the object retrieved from the configuration
//                database matches this type name. If a match, the object is
//                serialized (packed) and returned across the language
//                boundary. Once on this side, the object data is unpacked
//                into the object passed by reference via the value argument.
//                Parameterized classes are not supported.
//
// context      - The hierarchical path of the component on whose behalf the
//                specified configuration is being retrieved. Wildcards or
//                regular expressions are not allowed. The context must
//                exactly match an existing component's hierarchical name,
//                or be the empty string, which specifies uvm_top.
//
// inst_name    - The instance path of the object being configured, relative
//                to the specified context(s).
//
// field_name   - The name of the configuration parameter. Typically this name
//                is the same as or similar to the variable used to hold the
//                configured value in the target context(s).
//
// value        - The value of the configuration parameter. Integral values
//                currently cannot exceed 64 bits. Object values must have a
//                uvmc_convert<object_type> specialization defined for it. Use
//                of the converter convenience macros is acceptable for meeting
//                this requirement. The equivalent class in SV must be based
//                on uvm_object and registered with the UVM factory, i.e.
//                contain a `uvm_object_utils macro invocation.
// 
// Examples:
//
// The following example retrieves the uvm_tlm_generic_payload configuration
// property at hierarchical path "e.prod.trans" into tr2. 
//
//| uvmc_get_config_object("uvm_tlm_generic_payload","e","prod","trans", tr2);
// 
// The context specification is split between the context and inst_name
// arguments. Unlike setting configuration, there is no semantic difference
// between the context and inst_name properties. When getting configuration,
// the full context is always the concatenation of the context, ".", and
// inst_name. The transaction tr2 will effectively become a copy of the
// object used to set the configuration property.
//
// The next example retrieves the string property at hierarchical path
// "e.prod.message" into local variable str.
//
//| uvmc_get_config_string ("e", "prod", "message", str);
// 
// The following example retrieves the integral property at hierarchical path
// "e.prod.start_addr" into the local variable, saddr.
//
//| uvmc_get_config_int ("e.prod", "", "start_addr", saddr);
//------------------------------------------------------------------------------


// Function: uvmc_get_config_int
//
// Set an integral configuration value.
//
bool uvmc_get_config_int    (const char* context, const char* inst_name,
                            const char* field_name, uint64 &value);

// Function: uvmc_get_config_string
//
// Set a string configuration value.
//
bool uvmc_get_config_string (const char* context, const char* inst_name,  
                            const char* field_name, string &value);

} // extern "C"

namespace uvmc {


// Function: uvmc_get_config_object
//
// Set an object configuration value using a custom converter
//
template <class T, class CVRT>
bool uvmc_get_config_object (const char* type_name,
                            const char* context,
                            const char* inst_name,
                            const char* field_name,
                            T &value,
                            uvmc_packer *packer=NULL) {
  static bits_t bits[UVMC_MAX_WORDS];
  static uvmc_packer def_packer;
  if (packer == NULL) {
    packer = &def_packer;
    //packer->big_endian = 0;
  }
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  if (UVMC_get_config_object(type_name,context,inst_name,field_name,bits)) {
    packer->init_unpack(bits);
    CVRT::do_unpack(value,packer);
    return 1;
  }
  return 0;
}



// Function: uvmc_get_config_object
//
// Set an object configuration value using the default converter
//
template <class T>
bool uvmc_get_config_object (const char* type_name,
                            const char* context,
                            const char* inst_name,
                            const char* field_name,
                            T &value,
                            uvmc_packer *packer=NULL) {
  static bits_t bits[UVMC_MAX_WORDS];
  static uvmc_packer def_packer;
  if (packer == NULL) {
    packer = &def_packer;
    //packer->big_endian = 0;
  }
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  if (UVMC_get_config_object(type_name,context,inst_name,field_name,bits)) {
    packer->init_unpack(bits);
    uvmc_converter<T>::do_unpack(value,*packer);
    return 1;
  }
  return 0;
}

} // namespace uvmc

#endif // UVMC_COMMANDS_H
