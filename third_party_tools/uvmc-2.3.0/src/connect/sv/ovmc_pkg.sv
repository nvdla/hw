//
//------------------------------------------------------------//
//   Copyright 2009-2014 Mentor Graphics Corporation          //
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


`timescale 1ps / 1ps

`ifndef OVMC_PKG__SVH
`define OVMC_PKG__SVH

`define OVMC

`include "ovm_macros.svh"

`define uvm_port_base ovm_port_base
`define uvm_tlm_if_base ovm_tlm_if_base
`define uvm_packer ovm_packer

// Number of bytes used to transfer packed object data 
// Should be equial to UVM's setting
`ifndef UVM_PACKER_MAX_BYTES
`define UVM_PACKER_MAX_BYTES 4096
`endif

// Number of 32-bits words used to transfer packed object data 
`ifndef UVMC_MAX_WORDS
`define UVMC_MAX_WORDS (`UVM_PACKER_MAX_BYTES/4)
`endif

`define uvm_info(ID, MSG, VERBOSITY) `ovm_info(ID, MSG, VERBOSITY)
`define uvm_warning(ID,MSG)          `ovm_warning(ID,MSG)
`define uvm_error(ID,MSG)            `ovm_error(ID,MSG)
`define uvm_fatal(ID,MSG)            `ovm_fatal(ID,MSG)

`define UVM_MAJOR_REV `OVM_MAJOR_REV;
`define UVM_MINOR_REV `OVM_MINOR_REV;
`define UVM_FIX_REV   `OVM_FIX_REV;

package ovmc_pkg;

import ovm_pkg::*;


typedef ovm_object         uvm_object;
typedef ovm_packer         uvm_packer;
typedef ovm_component      uvm_component;
typedef ovm_root           uvm_root;
typedef ovm_factory        uvm_factory;
typedef ovm_object_wrapper uvm_object_wrapper;
typedef ovm_phase          uvm_phase;
typedef ovm_printer        uvm_printer;
typedef ovm_objection      uvm_objection;
typedef ovm_severity_type  uvm_severity_type;

parameter int UVM_NONE = OVM_NONE;
parameter int UVM_LOW  = OVM_LOW;
parameter int UVM_MEDIUM = OVM_MEDIUM;
parameter int UVM_HIGH = OVM_HIGH;
parameter int UVM_FULL = OVM_FULL;

parameter int UVM_INFO = OVM_INFO;
parameter int UVM_WARNING = OVM_WARNING;
parameter int UVM_ERROR = OVM_ERROR;
parameter int UVM_FATAL = OVM_FATAL;

typedef ovm_port_type_e uvm_port_type_e;

parameter ovm_port_type_e UVM_IMPLEMENTATION = OVM_IMPLEMENTATION;
parameter ovm_port_type_e UVM_PORT = OVM_PORT;
parameter ovm_port_type_e UVM_EXPORT = OVM_EXPORT;

class uvm_tlm_generic_payload;
endclass



/*
typedef enum
{
  UVM_PORT ,
  UVM_EXPORT ,
  UVM_IMPLEMENTATION
} uvm_port_type_e;
*/


typedef enum { UVM_PHASE_DORMANT      = 1,
               UVM_PHASE_SCHEDULED    = 2,
               UVM_PHASE_SYNCING      = 4,
               UVM_PHASE_STARTED      = 8,
               UVM_PHASE_EXECUTING    = 16,
               UVM_PHASE_READY_TO_END = 32,
               UVM_PHASE_ENDED        = 64,
               UVM_PHASE_CLEANUP      = 128,
               UVM_PHASE_DONE         = 256,
               UVM_PHASE_JUMPING      = 512
} uvm_phase_state;


typedef enum { UVM_LT,
               UVM_LTE,
               UVM_NE,
               UVM_EQ,
               UVM_GT,
               UVM_GTE
} uvm_wait_op;



// adapt these classes:
// uvm_domain
// uvm_phase
// uvm_objection -> uvm_test_done

parameter string uvmc_mgc_copyright  = "(C) 2009-2014 Mentor Graphics Corporation";
parameter string uvmc_revision = "OVMC-2.3";

bit x_banner_printed;

function void print_x_banner();
  if (x_banner_printed == 1)
    return;
  x_banner_printed = 1;
  $display("----------------------------------------------------------------");
  $display(uvmc_revision);
  $display(uvmc_mgc_copyright);
  $display("----------------------------------------------------------------");
endfunction

typedef int unsigned bits_t[`UVMC_MAX_WORDS];
typedef longint unsigned uint64;
typedef int unsigned uint32;


`include "uvmc_common.sv"
`include "uvmc_tlm1.sv"
`include "uvmc_commands.sv"

export "DPI-C"  function C2SV_nb_transport_fw;
export "DPI-C"  function C2SV_nb_transport_bw;
export "DPI-C"  function C2SV_b_transport;

function int C2SV_nb_transport_fw(int x_id,
                                  inout bits_t bits,
                                  inout uint32 phase,
                                  inout uint64 delay);
  `uvm_error("OVMC_NO_TLM2","No TLM2 Support in OVM. Cannot call nb_transport_fw from SC");
  return 0;
endfunction

function int C2SV_nb_transport_bw(int x_id,
                                  inout bits_t bits,
                                  inout uint32 phase,
                                  inout uint64 delay);
  `uvm_error("OVMC_NO_TLM2","No TLM2 Support in OVM. Cannot call nb_transport_bw from SC");
  return 0;
endfunction

function void C2SV_b_transport (int x_id,
                                inout bits_t bits,
                                input uint64 delay);
  `uvm_error("OVMC_NO_TLM2","No TLM2 Support in OVM. Cannot call b_transport from SC");
endfunction


endpackage : ovmc_pkg

`endif //OVMC_PKG__SVH

