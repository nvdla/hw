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

// This file has been updated by NVIDIA in function UVMC_set_config_object

//-----------------------------------------------------------------------------
// File: uvmc_commands.sv
//
// Implements the UVM command interface.
//-----------------------------------------------------------------------------


export "DPI-C" function UVMC_wait_for_phase_request;
export "DPI-C" function UVMC_raise_objection;
export "DPI-C" function UVMC_drop_objection;

export "DPI-C" function UVMC_print_topology;

export "DPI-C" function UVMC_set_report_verbosity;
export "DPI-C" function UVMC_report_enabled;
export "DPI-C" function UVMC_report;

export "DPI-C" function UVMC_set_config_int;
export "DPI-C" function UVMC_set_config_object;
export "DPI-C" function UVMC_set_config_string;

export "DPI-C" function UVMC_get_config_int;
export "DPI-C" function UVMC_get_config_object;
export "DPI-C" function UVMC_get_config_string;

export "DPI-C" function UVMC_print_factory;
export "DPI-C" function UVMC_set_factory_inst_override;
export "DPI-C" function UVMC_set_factory_type_override;
export "DPI-C" function UVMC_debug_factory_create;
export "DPI-C" function UVMC_find_factory_override;

import "DPI-C" context function bit SV2C_phase_notification(int id);
import "DPI-C" context function bit SV2C_sv_ready();


export "DPI-C" function UVMC_get_uvm_version;

export "DPI-C" function UVMC_global_stop_request; // bkwd compat


bit sv_is_ready = SV2C_sv_ready();

typedef uvmc_default_converter #(uvm_object) converter;

// Function- get_context

function automatic uvm_component get_context (string contxt,
                                              string cmd,
                                              int err=0);
  uvm_root top = uvm_root::get();
  if (contxt == "")
    get_context = top;
  else begin
    uvm_component comps[$];
    int sz;
    top.find_all(contxt,comps);
    sz=comps.size();
    if (sz == 0) begin
      if (err == 2)
        `uvm_error(cmd,{"No component matching the name '",contxt,"'"})
      else if (err == 1)
        `uvm_warning(cmd,{"No component matching the name '",contxt,"'"})
      return null;
    end
    if (sz > 1) begin
      if (err == 2)
        `uvm_error(cmd,{"Multiple components match the name '",contxt,"'"})
      else if (err == 1)
        `uvm_warning(cmd,{"Multiple components match the name '",contxt,"'"})
    end
    get_context = comps[0];
  end
endfunction



`ifdef OVMC
class uvm_domain;
  function uvm_phase find_by_name(string ph_name, bit stay_in_domain);
    ovm_root top;
    top = ovm_root::get(); // makes sure global phases objects are created
    case (ph_name)
      "build"               : return build_ph;
      "connect"             : return connect_ph;
      "end_of_elaboration"  : return end_of_elaboration_ph;
      "start_of_simulation" : return start_of_simulation_ph;
      "run"                 : return run_ph;
      "extract"             : return extract_ph;
      "check"               : return check_ph;
      "report"              : return report_ph;
      default               : return null;
    endcase
  endfunction
endclass

`endif

//------------------------------------------------------------------------------
// Group: Phasing
//
// Provides ability to wait for UVM phase transitions.
//------------------------------------------------------------------------------

class uvmc_wait_for_phase_info;
  uvm_phase phase;
  uvm_phase_state state;
  uvm_wait_op op;
  int id;
endclass

uvmc_wait_for_phase_info uvmc_wait_for_phase_q[$];


class uvmc_drop_objection_info;
  uvm_objection objection;
  string description;
  int count;
  uvm_component comp;
endclass

uvmc_drop_objection_info uvmc_drop_objection_q[$];



// UVMC_wait_for_phase_request
// ---------------------------

function automatic int UVMC_wait_for_phase_request(string ph_name,
                                                   int state,
                                                   int op);
  // TODO: Issue Warning if already past given phase event
  uvm_phase_state state_e;
  uvm_phase_state curr_state_e;
  uvm_wait_op op_e;
  uvm_domain dom;
  uvm_phase ph;
  static int id;
  uvmc_wait_for_phase_info info;
  info = new();
  `ifdef OVMC
  dom = new;
  `else
  dom = uvm_domain::get_common_domain();
  `endif
  ph = dom.find_by_name(ph_name,0);
  state_e = uvm_phase_state'(state);
  op_e = uvm_wait_op'(op);
  if ($test$plusargs("UVMC_COMMAND_TRACE"))
    `uvm_info("TRACE/UVMC_CMD/WAIT_FOR_PHASE",
        $sformatf("ph_name=%s state=%s op=%s %s",
          ph_name,state_e.name(),
          op_e.name(),
          (ph==null?"(unknown phase)":"")),UVM_NONE)
  if (ph == null) begin
    `uvm_error("UVMC_WAIT_FOR_PHASE",
               {"Request to wait for unknown phase '",ph_name,"'"})
    return -1;
  end
  else begin
    `ifndef OVMC
    curr_state_e = ph.get_state();
    `else

    if (ph.is_done())
      curr_state_e = UVM_PHASE_DONE;
    else if (ph.is_in_progress())
      curr_state_e = UVM_PHASE_EXECUTING;
    else
      curr_state_e = UVM_PHASE_DORMANT;

    if ((curr_state_e > state_e) && (op <= UVM_EQ)) begin
      `uvm_error("UVMC_WAIT_FOR_PHASE",
               {"Request to wait for ", ph_name, " to be in state '", state_e.name(),",",
                " which is already in state '",curr_state_e.name(),"'. Will block forever."})
    end

    if (state_e != UVM_PHASE_DORMANT &&
        state_e != UVM_PHASE_STARTED &&
        state_e != UVM_PHASE_EXECUTING &&
        state_e != UVM_PHASE_ENDED &&
        state_e != UVM_PHASE_DONE) begin
      `uvm_error("UVMC_WAIT_FOR_PHASE",
               {"Request to wait for unsupported phase state in OVM mode, '",state_e.name(),"'.",
                " Must be one of UVM_PHASE_DORMANT, UVM_PHASE_STARTED,  UVM_PHASE_EXECUTING, or UVM_PHASE_DONE"})
      return -1;
    end
    `endif
    `uvm_info("UVMC_WAIT_FOR_PHASE",
        $sformatf("Waiting for phase '%s' to be '%s' to state '%s'. Currently its state is '%s'",
           ph_name,op_e.name(),state_e.name(),
           curr_state_e.name()),UVM_MEDIUM)
  end
  info.phase = ph;
  info.state = state_e;
  info.op = op_e;
  info.id = ++id;
  uvmc_wait_for_phase_q.push_back(info);
  return info.id;
endfunction



// Function- uvmc_init
//
// Future: automate execution of uvmc_init, which must fork this from
// initial block

`define UVM_FIX_REV_STR `"`UVM_FIX_REV`"

task uvmc_init();
  fork
    m_uvmc_wait_for_phase_proc();
    m_uvmc_drop_objection_proc();
  join_none
endtask


// Function- UVMC_get_uvm_version
//
//
function void UVMC_get_uvm_version (output int unsigned major,
                                    output int unsigned minor,
                                    output string fix);
  major = `UVM_MAJOR_REV;
  minor = `UVM_MINOR_REV;
  fix   = `UVM_FIX_REV_STR;
  //$display("major=%0d minor=%0d fix=%s",major,minor,fix);
endfunction

/*
BF - block forever
WT - wait
RE - return immediately

           | DORM | INPR | DONE |

LT -DORM      BF     BF     BF
LTE-DORM      RE     BF     BF
NE -DORM      WT     RE     RE
EQ -DORM      RE     BF     BF
GT -DORM      WT     RE     RE
GTE-DORM      RE     RE     RE

LT -INPR      RE     BF     BF
LTE-INPR      RE     RE     BF
NE -INPR      RE     WT     RE
EQ -INPR      WT     RE     BF
GT -INPR      WT     WT     RE
GTE-INPR      WT     RE     RE

LT -DONE      RE     RE     BF
LTE-DONE      RE     RE     RE
NE -DONE      RE     RE     BF
EQ -DONE      WT     WT     RE
GT -DONE      BF     BF     BF
GTE-DONE      WT     WT     RE
*/



// Task- m_uvmc_wait_for_phase_proc
//
// Background process for waiting for UVM phase
//
task automatic m_uvmc_wait_for_phase_proc();
  bit never_trig;
  forever begin
    uvmc_wait_for_phase_info info;
    if (uvmc_wait_for_phase_q.size()==0)
      @(uvmc_wait_for_phase_q.size()!=0);
    info = uvmc_wait_for_phase_q.pop_front();
    assert(info != null);
    fork begin
      `ifdef OVMC
        if ((info.state == UVM_PHASE_DONE && info.op == UVM_GT) ||
            (info.state == UVM_PHASE_DORMANT && info.op == UVM_LT) ||
            (
              info.phase.is_done() &&
                (
                 (info.state != UVM_PHASE_DONE && (info.op == UVM_LT || info.op == UVM_LTE || info.op == UVM_EQ)) ||
                 (info.state == UVM_PHASE_DONE && (info.op == UVM_LT || info.op == UVM_NE))
                )
            ) ||
            (
              info.phase.is_in_progress() &&
                (
                  (info.state == UVM_PHASE_DORMANT   && (info.op == UVM_LT || info.op == UVM_LTE || info.op == UVM_EQ)) ||
                  (info.state == UVM_PHASE_STARTED   && (info.op == UVM_LT || info.op == UVM_LTE || info.op == UVM_EQ)) ||
                  (info.state == UVM_PHASE_EXECUTING && (info.op == UVM_LT))
                )
            )
           )
           never_trig = 1;

        if (info.phase.is_in_progress()) begin
          if (
              (info.state == UVM_PHASE_EXECUTING && (info.op == UVM_NE || info.op == UVM_GT)) ||
              (info.state == UVM_PHASE_ENDED     && (info.op == UVM_EQ || info.op == UVM_GTE || info.op == UVM_GT)) ||
              (info.state == UVM_PHASE_DONE      && (info.op == UVM_EQ || info.op == UVM_GTE))
             )
            info.phase.wait_done();
        end
  
        if ((!info.phase.is_in_progress() && !info.phase.is_done())) begin
          if (
              (info.state == UVM_PHASE_DORMANT   && (info.op == UVM_NE || info.op == UVM_GT )) ||
              (info.state == UVM_PHASE_STARTED   && (info.op == UVM_EQ || info.op == UVM_GTE || info.op == UVM_GT)) ||
              (info.state == UVM_PHASE_EXECUTING && (info.op == UVM_EQ || info.op == UVM_GTE))
             )
            info.phase.wait_start();
          if (
              (info.state == UVM_PHASE_EXECUTING && info.op == UVM_GT) ||
              (info.state == UVM_PHASE_ENDED     && (info.op == UVM_EQ || info.op == UVM_GTE)) ||
              (info.state == UVM_PHASE_DONE      && (info.op == UVM_EQ || info.op == UVM_GTE))
             )
            info.phase.wait_done();
        end
      `else
        info.phase.wait_for_state(info.state, info.op);
      `endif
      if (!never_trig)
        void'(SV2C_phase_notification(info.id));
    end
    join_none
  end
endtask



// OBJECTIONS

// limited to phase objections 

function automatic void m_uvmc_objection_op (string op,
                                      string name,
                                      string contxt,
                                      string description,
                                      int unsigned count);
  uvm_component comp = get_context(contxt,{"UVMC_",op,"_OBJECTION"},0); 
  string nm;
  `ifdef OVMC
    ovm_objection ph;
  `else
    uvm_phase ph;
    uvm_domain dom;
  `endif
  if (comp == null)
    comp = uvm_root::get();
  nm = comp.get_full_name();
  if ($test$plusargs("UVMC_COMMAND_TRACE"))
    `uvm_info("TRACE/UVMC_CMD/OBJECTION",
      $sformatf("op=%s name=%s contxt=%s description=%s count=%0d sv_contxt=%s",
          op,name,contxt,description,count,(nm==""?"uvm_top":nm)),UVM_NONE)
  `ifdef OVMC
    if (name != "run") begin
      `uvm_error({"UVMC_",op,"_OBJECTION"},
                 "Can only raise/drop objection for the 'run' phase")
      return;
    end
    ph = ovm_test_done;

  `else
    dom = uvm_domain::get_common_domain();
    ph = dom.find_by_name(name,0);
    if (ph == null) begin
      `uvm_error({"UVMC_",op,"_OBJECTION"},
                 {"Request for objection in unknown phase '",name,"'"})
      return;
    end
  `endif
  description = {contxt,": ",description};
  // OVMC mode: must schedule the drop to occur via a process started via an initial block.
  // For some reason, this is not an issue in UVMC mode, 
  // i.e. calling drop_objection directly works in UVM
  `ifdef OVMC
  if (op == "DROP") begin
    uvmc_drop_objection_info info = new;
      info.objection = ph;
    //`else
    //  info.objection = ph.phase_done; // for UVM
    //`endif
    info.description = description;
    info.count = count;
    info.comp = comp;
    uvmc_drop_objection_q.push_back(info);
  end
  else begin // RAISE
    ph.raise_objection(comp,count);
  end
  `else
    if (op == "RAISE")
      ph.raise_objection(comp,description,count);
    else
      ph.drop_objection(comp,description,count);
  `endif
endfunction


function automatic void UVMC_raise_objection (string name,
                                      string contxt,
                                      string description,
                                      int unsigned count);
   m_uvmc_objection_op("RAISE",name,contxt,description,count); 
endfunction

function automatic void UVMC_drop_objection (string name,
                                     string contxt,
                                     string description,
                                     int unsigned count);
   m_uvmc_objection_op("DROP",name,contxt,description,count); 
endfunction



task automatic m_uvmc_drop_objection_proc();
  forever begin
    uvmc_drop_objection_info info;
    if (uvmc_drop_objection_q.size()==0)
      @(uvmc_drop_objection_q.size()!=0);
    info = uvmc_drop_objection_q.pop_front();
    assert(info != null);
    `ifdef OVMC
    info.objection.drop_objection(info.comp,info.count);
    `else
    info.objection.drop_objection(info.comp,info.description,info.count);
    `endif
  end
endtask



function void UVMC_global_stop_request();

  // global_stop_request();  This is now deprecated. Let's do this instead ...

  uvm_test_done_objection tdo;
  tdo = uvm_test_done_objection::get();
  tdo.stop_request();
endfunction


//------------------------------------------------------------------------------
// Group: Topology
//
// Provides ability to wait for UVM phase transitions.
//------------------------------------------------------------------------------


// TOPOLOGY
// --------

function automatic void UVMC_print_topology(string contxt, int depth);
  uvm_root top = uvm_root::get();
  uvm_component comps[$];
  uvm_printer printer;
  int depth_save;
  `ifdef OVMC
    printer = ovm_default_printer;
  `else
    printer = uvm_default_printer;
  `endif
  if (contxt == "")
    comps.push_back(top);
  else begin
    top.find_all(contxt,comps);
    `uvm_error("UVMC_PRINT_TOPOLOGY",
               {"No components found at context ", contxt})
    return;
  end
    depth_save = printer.knobs.depth;
    printer.knobs.depth = depth;
  foreach (comps[i]) begin
    string name = comps[i].get_full_name();
    if (name == "")
      name = "uvm_top";
    `uvm_info("TRACE/UVMC_CMD/PRINT_TOPOLOGY",
              {"Topology for component ",name,":"},UVM_NONE)
    comps[i].print(printer);
    $display();
  end
endfunction


//------------------------------------------------------------------------------
// Group: Reporting
//
// Provides ability to send reports to UVM, set report verbosity for any or all
// components in UVM, check whether a report source is enabled given the
// current verbosity setting,for UVM phase transitions.
//------------------------------------------------------------------------------


// REPORTING
// ---------

function automatic bit UVMC_report_enabled (string contxt,
                                            int verbosity,
                                            int severity,
                                            string id);
  uvm_root top = uvm_root::get();
  uvm_component comp = get_context(contxt, "UVMC_REPORT_ENABLED");
  if (comp == null)
    comp = top;
  `ifdef OVMC
    UVMC_report_enabled = comp.ovm_report_enabled(verbosity,UVM_INFO,id);
  `else
    UVMC_report_enabled = comp.uvm_report_enabled(verbosity,UVM_INFO,id);
  `endif
  if ($test$plusargs("UVMC_COMMAND_TRACE")) begin
    uvm_severity_type sev = uvm_severity_type'(severity);
    `uvm_info("TRACE/UVMC_CMD/REPORT_ENABLED",
        $sformatf("context=%s verbosity=%0d severity=%s id=%s (RESULT=%0d)",
          (contxt==""?"uvm_top":contxt),
          verbosity,sev.name(),id,UVMC_report_enabled),UVM_NONE)
  end
endfunction


function automatic void UVMC_report(int severity,
                        string id,
                        string message,
                        int verbosity,
                        string contxt,
                        string filename,
                        int line);
  uvm_root top = uvm_root::get();
  // context replaces "get_full_name()" that is used in UVM
  if ($test$plusargs("UVMC_COMMAND_TRACE")) begin
    uvm_severity_type sev = uvm_severity_type'(severity);
    `uvm_info("TRACE/UVMC_CMD/REPORT",
        $sformatf("severity=%s id=%s verbosity=%0d contxt=%s filename=%s line=%0d",
          sev.name(),id,verbosity,
          (contxt==""?"uvm_top":contxt),filename,line),UVM_NONE)
  end
  top.m_rh.report(severity, contxt, id, message, verbosity, filename, line, top);
endfunction


//TODO: add delay arg?

function automatic void UVMC_set_report_verbosity (int level,
                                                   string contxt,
                                                   bit recurse);
  uvm_component comp = get_context(contxt, "UVMC_SET_VERB");
  if (comp == null) begin
    return;
  end
  if ($test$plusargs("UVMC_COMMAND_TRACE"))
    `uvm_info("TRACE/UVMC_CMD/SET_REPORT_VERBOSITY",
        $sformatf("contxt=%s  level=%0d  recurse=%b",
          (contxt==""?"uvm_top":contxt),level,recurse),UVM_NONE)
  if (recurse)
    comp.set_report_verbosity_level_hier(level);
  else
    comp.set_report_verbosity_level(level);
  
endfunction


/*
OTHER REPORTING TODO:

1) get report id counts
2) report catching
3) integration with sc_report/sc_report_handler

function automatic int uvmc_report_catcher
    ref uvm_severity severity, 
    input string name, 
    ref string id,
    ref string message,
    ref int verbosity_level,
    ref uvm_action action,
    input string filename,
    input int line 

*/


//------------------------------------------------------------------------------
// Group: Configuration
//
// Provides ability to set and get configuration for integrals (up to 64 bits),
// strings, and any object whose type is registered with the UVM factory and
// defines a conversion algorithm (e.g. pack/unpack).
//------------------------------------------------------------------------------


// SET CONFIG
// ----------

function void UVMC_set_config_int (string contxt,
                                   string inst_name,
                                   string field_name,
                                   longint unsigned value);
  uvm_component comp;
  if ($test$plusargs("UVMC_COMMAND_TRACE"))
    `uvm_info("TRACE/UVMC_CMD/SET_CFG_INT",
      $sformatf("contxt='%s' inst_name='%s' field_name='%s' value=%0d",
          contxt,inst_name,field_name,value),UVM_NONE)
  `ifdef VCS
    fork : create_sv_process_scope
    begin
  `endif

  `ifndef OVMC
    comp = get_context(contxt, "UVMC_SET_CFG_INT", 0);
    if (comp == null) begin
      if (inst_name == "")
        inst_name = contxt;
      else if (contxt != "")
        inst_name = {contxt, ".", inst_name};
    end
    uvm_config_db #(uvm_bitstream_t)::set(comp, inst_name, field_name, value);
  `else // OVMC
    if (inst_name == "")
      inst_name = contxt;
    else if (contxt != "")
      inst_name = {contxt, ".", inst_name};
    set_config_int (inst_name, field_name, value);
  `endif

  `ifdef VCS
    end
    join_none
  `endif
   
endfunction

static uvm_packer uvmc_default_packer = new();


function void UVMC_set_config_string (string contxt,
                                      string inst_name,  
                                      string field_name,
                                      string value);
  uvm_component comp;

  if ($test$plusargs("UVMC_COMMAND_TRACE"))
    `uvm_info("TRACE/UVMC_CMD/SET_CFG_STR",
      $sformatf("contxt='%s' inst_name='%s' field_name='%s' value='%0d'",
          contxt,inst_name,field_name,value),UVM_NONE)

  `ifdef VCS
   fork : create_sv_process_scope
   begin
  `endif
  
  `ifndef OVMC
    comp = get_context(contxt, "UVMC_SET_CFG_STR", 0);
    if (comp == null) begin
      if (inst_name == "")
        inst_name = contxt;
      else if (contxt != "")
        inst_name = {contxt, ".", inst_name};
    end
    uvm_config_db #(string)::set(null, inst_name, field_name, value);

  `else // OVMC
    if (inst_name == "")
      inst_name = contxt;
    else if (contxt != "")
      inst_name = {contxt, ".", inst_name};
    set_config_string (inst_name, field_name, value);
  `endif

  `ifdef VCS
   end
   join_none
  `endif

endfunction

function void UVMC_set_config_object (string type_name,
                                      string contxt,
                                      string inst_name,
                                      string field_name,
                                      bits_t value);
  uvm_object obj;
  uvm_component comp;
  uvm_factory factory = uvm_factory::get();

  if ($test$plusargs("UVMC_COMMAND_TRACE"))
    `uvm_info("TRACE/UVMC_CMD/SET_CFG_OBJ",
      $sformatf("type_name='%s' contxt='%s' inst_name='%s' field_name=%s",
          type_name,contxt,inst_name,field_name),UVM_NONE)

  `ifndef OVMC
    comp = get_context(contxt, "UVMC_SET_CFG_OBJ", 0);
  `endif

  if (comp == null) begin
    if (inst_name == "")
      inst_name = contxt;
    else if (contxt != "")
      inst_name = {contxt, ".", inst_name};
  end

  obj = factory.create_object_by_name(type_name,contxt);
  if (obj == null) begin
    `uvm_error("UVMC_SET_CFG_OBJ",{"There is no object of type=",
               type_name," registered with the factory. Cannot proceed."})
    return;
  end
  uvmc_default_packer.use_metadata = 1;
  uvmc_default_packer.big_endian = 0;
  converter::m_pre_unpack(value,obj,uvmc_default_packer);
  converter::do_unpack(obj,uvmc_default_packer);
  converter::m_post_unpack(obj,uvmc_default_packer);

  `ifdef VCS
   fork : create_sv_process_scope
   begin
  `endif

  `ifdef OVMC
    set_config_object (inst_name, field_name, obj, 0);
  `else
    uvm_config_db #(uvm_object)::set(comp, inst_name, field_name, obj);
  `endif

  `ifdef VCS
   end
   join_none
  `endif
endfunction



// GET CONFIG
// ----------

function bit  UVMC_get_config_int  (string contxt,
                                    string inst_name,
                                    string field_name,
                                    output longint unsigned value);
  uvm_component comp;

  if ($test$plusargs("UVMC_COMMAND_TRACE"))
    `uvm_info("TRACE/UVMC_CMD/GET_CFG_INT",
      $sformatf("contxt=%s inst_name=%s field_name=%s",
          contxt,inst_name,field_name),UVM_NONE)

  `ifndef OVMC
    comp = get_context(contxt, "UVMC_GET_CFG_INT", 0);
    if (comp == null) begin
      if (inst_name == "")
        inst_name = contxt;
      else if (contxt != "")
        inst_name = {contxt, ".", inst_name};
    end
    UVMC_get_config_int=
      uvm_config_db #(uvm_bitstream_t)::get(comp, inst_name, field_name, value);

  `else // OVMC
    // in OVMC mode, context is {contxt,".",inst_name}
    if (inst_name == "")
      inst_name = contxt;
    else if (contxt != "")
      inst_name = {contxt, ".", inst_name};
    comp = get_context(inst_name, "UVMC_GET_CFG_INT", 2);
    $display("comp=%p",comp);
    if (comp != null)
      return comp.get_config_int (field_name, value);
    return 0;
  `endif

endfunction


function bit UVMC_get_config_string (string contxt,
                                     string inst_name,  
                                     string field_name,
                                     output string value);
  uvm_component comp;

  if ($test$plusargs("UVMC_COMMAND_TRACE"))
    `uvm_info("TRACE/UVMC_CMD/GET_CFG_STR",
      $sformatf("contxt=%s inst_name=%s field_name=%s",
          contxt,inst_name,field_name),UVM_NONE)

  `ifndef OVMC
    comp = get_context(contxt, "UVMC_GET_CFG_STR", 0);
    if (comp == null) begin
      if (inst_name == "")
        inst_name = contxt;
      else if (contxt != "")
        inst_name = {contxt, ".", inst_name};
    end
    UVMC_get_config_string=
      uvm_config_db #(string)::get(comp, inst_name, field_name, value);

  `else // OVMC
    // in OVMC mode, context is {contxt,".",inst_name}
    if (inst_name == "")
      inst_name = contxt;
    else if (contxt != "")
      inst_name = {contxt, ".", inst_name};
    comp = get_context(inst_name, "UVMC_GET_CFG_STR", 2);
    if (comp != null)
      return comp.get_config_string (field_name, value);
    return 0;
  `endif

endfunction


function bit UVMC_get_config_object (string type_name,
                                     string contxt,
                                     string inst_name,
                                     string field_name,
                                     output bits_t value);
  uvm_object obj;
  uvm_component comp;

  if ($test$plusargs("UVMC_COMMAND_TRACE"))
    `uvm_info("TRACE/UVMC_CMD/GET_CONFIG_OBJ",
      $sformatf("type_name=%s contxt=%s inst_name=%s field_name=%s",
          type_name,contxt,inst_name,field_name),UVM_NONE)

  `ifndef OVMC
    comp = get_context(contxt, "UVMC_GET_CFG_OBJ", 0);
    if (comp == null) begin
      if (inst_name == "")
        inst_name = contxt;
      else if (contxt != "")
        inst_name = {contxt, ".", inst_name};
    end
    if (!uvm_config_db #(uvm_object)::get(comp, inst_name, field_name, obj)) begin
      `uvm_error("UVMC_GET_CFG_OBJ",{"Could not find config object at context=",
               contxt," inst_name=",inst_name," field_name=",field_name})
      return 0;
    end

  `else // OVMC
    // in OVMC mode, context is {contxt,".",inst_name}
    if (inst_name == "")
      inst_name = contxt;
    else if (contxt != "")
      inst_name = {contxt, ".", inst_name};
    comp = get_context(inst_name, "UVMC_GET_CFG_OBJ", 2);
    if (comp == null || !comp.get_config_object (field_name, obj, 0)) begin
      `uvm_error("UVMC_GET_CFG_OBJ",{"Could not find config object at context=",
             contxt," inst_name=",inst_name," field_name=",field_name})
      return 0;
    end
  `endif

  if (type_name != obj.get_type_name()) begin
    `uvm_error("UVMC_GET_CFG_OBJ",{"Config object at context=",
               contxt," inst_name=",inst_name," field_name=",field_name,
               " is not of expected type=",type_name})
    return 0;
  end
  uvmc_default_packer.use_metadata = 1;
  uvmc_default_packer.big_endian = 0;
  converter::m_pre_pack(obj,uvmc_default_packer);
  converter::do_pack(obj,uvmc_default_packer);
  converter::m_post_pack(value,obj,uvmc_default_packer);
  return 1;
endfunction



//------------------------------------------------------------------------------
// Group: Factory
//
// Provides ability to set type and instance overrides for simple classes
// (non-parameterized).
//------------------------------------------------------------------------------

function automatic void UVMC_print_factory (int all_types=1);
  uvm_factory factory = uvm_factory::get();
  factory.print(all_types);
endfunction


function automatic void UVMC_set_factory_inst_override (string requested_type,
                                                        string override_type,
                                                        string contxt);
  uvm_factory factory = uvm_factory::get();
  factory.set_inst_override_by_name(requested_type,override_type,contxt);
endfunction


function automatic void UVMC_set_factory_type_override (string requested_type,
                                                        string override_type,
                                                        bit replace=1);
  uvm_factory factory = uvm_factory::get();
  factory.set_type_override_by_name(requested_type,override_type,replace);
endfunction


function automatic void UVMC_debug_factory_create (string requested_type,
                                                   string contxt="");
  uvm_factory factory = uvm_factory::get();
  factory.debug_create_by_name(requested_type,contxt,"");
endfunction


function automatic void UVMC_find_factory_override (string requested_type,
                                                    string contxt,
                                                    output string override_type);
  uvm_object_wrapper wrapper;
  uvm_factory factory = uvm_factory::get();
  wrapper = factory.find_override_by_name(requested_type, contxt);
  if (wrapper == null)
    override_type = requested_type;
  else
    override_type = wrapper.get_type_name();
endfunction

/*
function uvm_object uvm_factory::create_object_by_name (string requested_type_name,  
                                                        string parent_inst_path="",  
                                                        string name="",
                                                        output bits_t object);


function uvm_component uvm_factory::create_component_by_name (string requested_type_name,  
                                                              string parent_inst_path="",  
                                                              string name, 
                                                              uvm_component parent);
*/


