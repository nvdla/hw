`ifndef _CSB_PKG_SV_
`define _CSB_PKG_SV_


//-------------------------------------------------------------------------------------
//
// PACKAGE: csb_pkg
//
// XXX
//-------------------------------------------------------------------------------------

`include "csb_interface.sv"
package csb_pkg;
    import uvm_pkg::*;
    import nvdla_ral_pkg::*;
    
    `include "csb_defines.svh"
    `include "csb_gp_ext.sv"
    `include "csb_sequencer.sv"
    `include "csb_driver.sv"
    `include "csb_monitor.sv"
    `include "csb_agent.sv"
    `include "csb_seq_lib.sv"

endpackage : csb_pkg


`endif // _CSB_PKG_SV_
