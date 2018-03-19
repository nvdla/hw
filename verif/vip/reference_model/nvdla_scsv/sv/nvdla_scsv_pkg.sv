// Component: NVDLA-SCSV SV Package for the SystemVerilog side of the NVDLA Mixed language channels
//
// Package:  NVDLA SystemC-SystemVerilog Mixed Language Connectors based on
//           UVMConnect 2.3.1 
//
// Description:
//  This file contains the SystemVerilog package of the SystemVerilog-SystemC TLM channels and callback classes

`ifndef _NVDLA_SCSV_PKG_
`define _NVDLA_SCSV_PKG_

package nvdla_scsv_pkg;

`include "uvm_macros.svh"

    import uvm_pkg::*;
    import uvmc_pkg::*;
    import dbb_pkg::*;

    // To make payload class name the same on SystemC and SystemVerilog side
    typedef uvm_tlm_generic_payload tlm_generic_payload;

`include "nvdla_scsv_register_extension_packer_defines.svh"

`include "nvdla_scsv_sv_tlm_callbacks.svh"
`include "nvdla_scsv_sv_tlm_channel.svh"

`include "nvdla_scsv_extension_packer_base.svh"
`include "nvdla_scsv_extension_packer.svh"
`include "nvdla_dbb_scsv_extension_packer.sv"
`include "nvdla_scsv_converter.sv"

endpackage: nvdla_scsv_pkg

`endif // _NVDLA_SCSV_PKG_
