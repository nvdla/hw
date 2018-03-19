
// 
// 

// `include "nvdla_object_globals.svh"
package rm_nvdla_top_pkg;

//  import nvdla_lib_pkg::*;
    import uvm_pkg::*;
//  import nvdla_common_pkg::*;
    import nvdla_scsv_pkg::*;
//  import nv_tlm_extension_pkg::*;
//  import nvdla_tlm_extension_pkg::*;
    // Import SCSV adapter
    import nvdla_top_scsv_pkg::*;
    
    `include "rm_nvdla_txn.svh"
    `include "rm_cmod_nvdla_top.sv"
    `include "rm_nvdla_dma_convertor.sv"
    `include "rm_nvdla_conv_core_socket_convertor.sv"
    `include "rm_nvdla_post_processing_socket_convertor.sv"
    
endpackage: rm_nvdla_top_pkg

