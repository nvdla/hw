`ifndef _MEM_DEFINE_SVH
`define _MEM_DEFINE_SVH

    typedef bit[`NVDLA_MEM_ADDRESS_WIDTH-1:0] addr_t;

    let max(a, b) = ((a > b) ? a : b);
    let min(a, b) = ((a < b) ? a : b);

`endif
