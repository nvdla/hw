`ifndef _DMA_PKG_
`define _DMA_PKG_

`include "dma_interface.sv"

package dma_pkg;

    import uvm_pkg::*;

    `include "dma_defines.sv"
       
    // Transaction objects 
    `include "dma_txn.sv"        

    // DMA Monitor
    `include "dma_monitor.sv"
       
    // DMA Coverage
    `include "dma_coverage.sv"

    // Agents
    `include "dma_slave_agent.sv"

endpackage: dma_pkg

`endif // _DMA_PKG_
