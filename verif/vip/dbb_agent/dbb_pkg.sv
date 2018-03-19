/// UVM DBB Verification IP Package
// A package of small utility classes and functions.
`include "nvdla_toolbox.sv"

package dbb_pkg;
    import uvm_pkg::*;
`ifdef DBB_AGENT_TEST
    // dbb_agent_testing only
    import nitro_lib_pkg::*;
`endif

    `include "dbb_defines.svh"
    `include "dbb_params.sv"
    
    // Logger
    `include "nvdla_txn_logger.sv"
    
    // Generic bus manager logger
    `include "nvdla_bus_manager_logger.sv"
   
    // Macros 
    `include "uvm_macros.svh"
    
    // TLM Generic Payload Extensions
    `include "dbb_gp_ext.sv"
    
    // Sequence Library
    //`include "dbb_seq_lib.sv"
    
    `include "dbb_channel_sm.sv"
    
    // DBB Slave
    `include "dbb_slave_driver.sv"
    `include "dbb_slave_seq.sv"
    
    // Logger
    `include "dbb_logger.sv"
    
    // DBB Monitor
    `include "dbb_monitor.sv"
    
    // Agents
    `include "dbb_slave_agent.sv"
    
    // Coverage
    `include "dbb_coverage.sv"
    
    //BUS OBJECT
    `include "dbb_bus_object.sv"

endpackage: dbb_pkg

`include "dbb_interface.sv"
`include "dbb_port_list_if.sv"
