`ifndef _NVDLA_SCENARIO_PKG_SV_
`define _NVDLA_SCENARIO_PKG_SV_


//-------------------------------------------------------------------------------------
//
// PACKAGE: nvdla_resources_pkg
//
//-------------------------------------------------------------------------------------
package nvdla_scenario_pkg;
    import uvm_pkg::*;
    import surface_generator_pkg::*;
    import nvdla_resource_pkg::*;
    import mem_man_pkg::*;
    import nvdla_coverage_pkg::*;

    `include "nvdla_base_scenario.sv"
    `include "nvdla_pdprdma_pdp_scenario.sv"
    `include "nvdla_cdprdma_cdp_scenario.sv"
    `include "nvdla_sdprdma_sdp_scenario.sv"
    `include "nvdla_sdprdma_sdp_pdp_scenario.sv"
    `include "nvdla_cc_sdp_scenario.sv"
    `include "nvdla_cc_sdp_pdp_scenario.sv"
    `include "nvdla_cc_sdprdma_sdp_scenario.sv"
    `include "nvdla_cc_sdprdma_sdp_pdp_scenario.sv"

endpackage : nvdla_scenario_pkg

`endif // _NVDLA_SCENARIO_PKG_SV_
