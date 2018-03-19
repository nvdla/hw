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

#include "uvmc_commands.h"

//------------------------------------------------------------------------------
// UVM COMMAND LAYER
//
// TODO- this should all be part of a separate package
//       without dependency on SC, i.e. uvmc_cmd_pkg.
//------------------------------------------------------------------------------

// TODO- add find and find_all, returning full name, queue of full names (for
// use in context args in subsequenct UVM UVMC commands
extern "C" {

sc_event sv_ready_e;
bool sv_is_ready =0;

void wait_sv_ready() {
  sc_process_handle proc_h = sc_get_current_process_handle();
  if (proc_h.proc_kind() == SC_METHOD_PROC_) {
    cout << "UVMC Error: Cannot call to an UVM-SV export or imp "
         << "before UVM has started the RUN phase" << endl;
    return;
  }
  if (!sv_is_ready) {
    wait(sv_ready_e); 
  }
}


bool SV2C_sv_ready () {
  if (sv_is_ready == 0) {
    sv_is_ready = 1;
    sv_ready_e.notify();
  }
  if (uvmc_pkg_scope == NULL) {
    uvmc_set_scope();
  }
  return 1;
}

void uvmc_set_scope() {
    uvmc_pkg_scope = svGetScope();

   char *fix_str;
    UVMC_get_uvm_version(&uvm_major, &uvm_minor, &fix_str);
    uvm_fix = fix_str;
    // if uvm version is 1.0x or 1.1 or 1.1a...
    if ((uvm_major == 1 && uvm_minor == 0) ||
        (uvm_major == 1 && uvm_minor == 1 && ((uvm_fix == "") || uvm_fix == "a"))) {
      uvmc_uvm_version_is_pre11b = 1;  
    }
    else {
      uvmc_uvm_version_is_pre11b = 0;  
    }
    //cout << "UVM VERSION: " << uvm_major << "." << uvm_minor << fix_str << " is_uvm_pre11b=" << uvmc_uvm_version_is_pre11b << endl;

}


// TOPOLOGY

void uvmc_print_topology (const char *context, int depth) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_print_topology(context,depth);
}

// PHASING

map<int,sc_event*> uvmc_phase_events;

bool SV2C_phase_notification (int id) {
  map<int,sc_event*>::const_iterator it = uvmc_phase_events.find(id);
  if (it == uvmc_phase_events.end()) {
    cout << "UVMC Internal Error: Phase notification with id "
         << id << " not expected." << endl;
    sc_stop();
    return 0;
  }
  uvmc_phase_events[id]->notify();
  return 1;
}

void uvmc_wait_for_phase (const char *phase,
                          uvmc_phase_state state,
                          uvmc_wait_op op) {
  sc_event e;
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  int id = UVMC_wait_for_phase_request(phase, state, op);
  uvmc_phase_events[id] = &e;
  wait(e);
  uvmc_phase_events.erase(id);
}


// OBJECTIONS

void uvmc_raise_objection (const char* name,
                           const char* context,
                           const char* description,
                           unsigned int count) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_raise_objection(name,context,description,count);
}

void uvmc_drop_objection (const char* name,
                          const char* context,
                          const char* description,
                          unsigned int count) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_drop_objection(name,context,description,count);
}

// REPORTING

bool uvmc_report_enabled (int verbosity,
                          int severity,
                          const char* id,
                          const char* context) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  return UVMC_report_enabled(context, verbosity, severity, id);
}


void uvmc_set_report_verbosity (int level,
                                const char* context,
                                bool recurse) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_set_report_verbosity(level, context, recurse);
}

void uvmc_report (int severity,
                  const char* id,
                  const char* message,
                  int verbosity,
                  const char* context,
                  const char* filename,
                  int line) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_report(severity, id, message, verbosity, context, filename, line);
}


void uvmc_report_info (const char* id,
                       const char* message,
                       int verbosity,
                       const char* context,
                       const char* filename,
                       int line) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_report(UVM_INFO, id, message, verbosity, context, filename, line);
}


void uvmc_report_warning (const char* id,
                          const char* message,
                          const char* context,
                          const char* filename,
                          int line) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_report(UVM_WARNING, id, message, 0, context, filename, line);
}


void uvmc_report_error (const char* id,
                        const char* message,
                        const char* context,
                        const char* filename,
                        int line) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_report(UVM_ERROR, id, message, 0, context, filename, line);
}


void uvmc_report_fatal (const char* id,
                        const char* message,
                        const char* context,
                        const char* filename,
                        int line) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_report(UVM_FATAL, id, message, 0, context, filename, line);
}


/*
typedef int catch_fptr(int *severity, 
                       const char* name, 
                       const char** id,
                       const char** message,
                       int *verbosity_level,
                       int *action,
                       const char* filename,
                       int line);


vector<catch_fptr*> uvmc_catcher_cbs;

void uvmc_register_report_catcher(catch_fptr*) {
  // check for duplicate...
  uvmc_catcher_cbs.push_back(catch_fptr);
}

// action
int uvmc_report_catch(int *severity, 
                                   const char* name, 
                                   const char** id,
                                   const char** message,
                                   int *verbosity_level,
                                   int *action,
                                   const char* filename,
                                   int line) {
  // to be called by UVM if report catching is enabled (via uvmc_enable_report_catching 
  //
  vector<catch_fptr*>::iterator iter= vector<catch_fptr*>::begin();
  //while (iter != vector<catch_fptr*>::end()) {
  //  call cb with above arguments
  // }
}
*/


// FACTORY

void uvmc_print_factory (int all_types) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_print_factory(all_types);
}

void uvmc_set_factory_inst_override (const char* requested_type,
                                     const char* override_type,
                                     const char* full_inst_path) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_set_factory_inst_override(requested_type,override_type,full_inst_path);
}

void uvmc_set_factory_type_override (const char* requested_type,
                                     const char* override_type,
                                     bool replace) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_set_factory_type_override(requested_type,override_type,replace);
}

void uvmc_debug_factory_create (const char* requested_type,
                                const char* context) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_debug_factory_create(requested_type,context);
}

string uvmc_find_factory_override (const char* requested_type,
                                   const char* full_inst_path) {
  const char *override_name;
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_find_factory_override(requested_type,full_inst_path,&override_name);
  string s = override_name; 
  return s;
}



// CONFIG

// set/get_config_object are template functions in the .h file

// up to 64 bits
void uvmc_set_config_int (const char* context,
                          const char* inst_name,
                          const char* field_name,
                          uint64 value) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_set_config_int(context,inst_name,field_name,value);
}


void uvmc_set_config_string (const char* context,
                             const char* inst_name,  
                             const char* field_name,
                             const string &value) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  UVMC_set_config_string(context,inst_name,field_name,value.c_str());
}


bool uvmc_get_config_int (const char* context,
                          const char* inst_name,
                          const char* field_name,
                          uint64 &value) {
  wait_sv_ready();
  svSetScope(uvmc_pkg_scope);
  return UVMC_get_config_int(context,inst_name,field_name,&value);
}


bool uvmc_get_config_string (const char* context,
                             const char* inst_name,  
                             const char* field_name,
                             string &value) {
  wait_sv_ready();
  bool result;
  const char* str_val;
  svSetScope(uvmc_pkg_scope);
  result = UVMC_get_config_string(context,inst_name,field_name,&str_val);
  if (result) {
    value = str_val;
    return 1;
  }
  return 0;

}

} // extern "C"
