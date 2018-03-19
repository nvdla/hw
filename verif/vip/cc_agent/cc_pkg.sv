`include "cc_interface.sv"

package cc_pkg;

    import uvm_pkg::*;

    `include "cc_defines.sv"
       
    // Transaction objects 
    `include "cc_txn.sv"        

    // CC Monitor
    `include "cc_monitor.sv"
       
    // CC Coverage
    `include "cc_coverage.sv"

    // Agents
    `include "cc_slave_agent.sv"

endpackage: cc_pkg
