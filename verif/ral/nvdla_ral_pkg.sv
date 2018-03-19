`ifndef _NVDLA_RAL_PKG_SV_
`define _NVDLA_RAL_PKG_SV_


//-------------------------------------------------------------------------------------
//
// PACKAGE: nvdla_ral_pkg
//
// XXX
//-------------------------------------------------------------------------------------
// Workaround define for ORDT ral model
`define ADDRMAP_NVDLA_PIO_INSTANCE_PATH ""

`include "ordt_uvm_reg_pkg.sv"
package nvdla_ral_pkg;
    import uvm_pkg::*;
    
    `include "opendla_reg.sv"
    `include "nvdla_ral.sv"

endpackage : nvdla_ral_pkg

`endif // _NVDLA_RAL_PKG_SV_
