`ifndef _MEM_PKG_SV_
`define _MEM_PKG_SV_

package mem_pkg;

    import uvm_pkg::*;

    `include "nvdla_tb_txn.sv"

    `include "mem_define.svh"
    `include "mem_core.svh"
    `include "mem_wrap.svh"

endpackage

`endif
