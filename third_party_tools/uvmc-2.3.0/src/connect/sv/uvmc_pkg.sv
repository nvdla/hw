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

`ifndef UVMC_PKG__SVH
`define UVMC_PKG__SVH

`include "uvm_macros.svh"

// Define MASKS for tlm2 interfaces. UVM_HOME/src/tlm2/tlm2_defines.svh is not
// included by uvm_macros.svh
`define UVM_TLM_NB_FW_MASK  (1<<0)
`define UVM_TLM_NB_BW_MASK  (1<<1)
`define UVM_TLM_B_MASK      (1<<2)

// Number of bytes used to transfer packed object data 
// Should be equial to UVM's setting
`ifndef UVM_PACKER_MAX_BYTES
`define UVM_PACKER_MAX_BYTES 4096
`endif

// Number of 32-bits words used to transfer packed object data 
`ifndef UVMC_MAX_WORDS
`define UVMC_MAX_WORDS (`UVM_PACKER_MAX_BYTES/4)
`endif

package uvmc_pkg;

import uvm_pkg::*;

parameter string uvmc_mgc_copyright  = "(C) 2009-2014 Mentor Graphics Corporation";
parameter string uvmc_revision = "UVMC-2.3";

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

`include "uvmc_xl_config.svh"
`include "uvmc_xl_converter.svh"
`include "uvmc_converter.svh"

`include "uvmc_common.sv"
`include "uvmc_tlm1.sv"
`include "uvmc_tlm2.sv"
`include "uvmc_commands.sv"

endpackage : uvmc_pkg

`endif //UVMC_PKG__SVH

