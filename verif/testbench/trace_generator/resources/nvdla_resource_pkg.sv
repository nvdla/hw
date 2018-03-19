`ifndef _NVDLA_RESOURCE_PKG_SV_
`define _NVDLA_RESOURCE_PKG_SV_


//-------------------------------------------------------------------------------------
//
// PACKAGE: nvdla_resources_pkg
//
//-------------------------------------------------------------------------------------

package nvdla_resource_pkg;
    import uvm_pkg::*;
    import surface_generator_pkg::*;
    import mem_man_pkg::*;
    import nvdla_ral_pkg::*;

    `include "nvdla_resource_define.sv"
    `include "nvdla_base_resource.sv"
    `include "nvdla_pdp_resource.sv"
    `include "nvdla_pdp_rdma_resource.sv"
    `include "nvdla_sdp_resource.sv"
    `include "nvdla_sdp_rdma_resource.sv"
    `include "nvdla_cdp_resource.sv"
    `include "nvdla_cdp_rdma_resource.sv"
    `include "nvdla_cdma_resource.sv"
    `include "nvdla_cc_dp_resource.sv"
`ifdef NVDLA_BDMA_ENABLE
    `include "nvdla_bdma_resource.sv"
`endif
`ifdef NVDLA_RUBIK_ENABLE
    `include "nvdla_rbk_resource.sv"
`endif
endpackage : nvdla_resource_pkg

`endif // _NVDLA_RESOURCE_PKG_SV_
