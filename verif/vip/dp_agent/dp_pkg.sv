`include "dp_interface.sv"

package dp_pkg;

    import uvm_pkg::*;

    `include "dp_defines.sv"
       
    // Transaction objects 
    `include "dp_txn.sv"        

    // DP Monitor
    `include "dp_monitor.sv"
       
    // DP Coverage
    `include "dp_coverage.sv"

    // Agents
    `include "dp_slave_agent.sv"

endpackage: dp_pkg
