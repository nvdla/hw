// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// This is nvdla_top sc side SC-SV Adapter 

#include "nvdla_top_sc_adapter.h"
#include "log.h"

//Constructor
nvdla_top_sc_adapter::nvdla_top_sc_adapter(sc_module_name name):sc_module(name)    
                                                               ,nvdla_top_sc2sv_nvdla_intr("nvdla_top_sc2sv_nvdla_intr")
{
  //////////////////////////////////////////////////////////////////////
  //  Insert user code
  //////////////////////////////////////////////////////////////////////
  const char *env = getenv("SC_LOG");
  if (env) {
      string sc_log(env);
      log_parse(sc_log);
  }


  //////////////////////////////////////////////////////////////////////
  //  Instantiate nvdla converters
  //////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////
  //  Instantiate user converters
  //////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////
  //SystemC Model Instance
  //////////////////////////////////////////////////////////////////////
  nvdla_top_sc_inst = new scsim::cmod::NV_nvdla("nvdla_top_sc_inst");

  //////////////////////////////////////////////////////////////////////
  //Layer Module Instance 
  //////////////////////////////////////////////////////////////////////
  nvdla_top_sc_layer_inst = new nvdla_top_sc_layer("nvdla_top_sc_layer_inst"); 

  //////////////////////////////////////////////////////////////////////
  // Connect layer's passthrough sockets to nvdla_top SystemC model 
  // The layer would connect these to the SV side via UVMConnect calls
  //////////////////////////////////////////////////////////////////////
  nvdla_top_sc_inst->nvdla_core2dbb_axi4.bind(nvdla_top_sc_layer_inst->nvdla_top_sc2sv_nvdla_core2dbb_axi4_target_pt);
            
  //////////////////////////////////////////////////////////////////////
  // Connect layer's passthrough sockets to nvdla_top SystemC model 
  // The layer would connect these to the SV side via UVMConnect calls
  //////////////////////////////////////////////////////////////////////
  nvdla_top_sc_inst->nvdla_core2cvsram_axi4.bind(nvdla_top_sc_layer_inst->nvdla_top_sc2sv_nvdla_core2cvsram_axi4_target_pt);

  //////////////////////////////////////////////////////////////////////
  // Connect layer's passthrough sockets to nvdla_top SystemC model 
  // The layer would connect these to the SV side via UVMConnect calls
  //////////////////////////////////////////////////////////////////////
  nvdla_top_sc_layer_inst->nvdla_top_sv2sc_nvdla_host_master_if_initiator_pt.bind(nvdla_top_sc_inst->nvdla_host_master_if);   
          
  //////////////////////////////////////////////////////////////////////
  // Connect layer's passthrough sockets to nvdla_top SystemC model 
  // The layer would connect these to the SV side via UVMConnect calls
  //////////////////////////////////////////////////////////////////////
  nvdla_top_sc_inst->dma_monitor_mc.bind(nvdla_top_sc_layer_inst->nvdla_top_sc2sv_dma_monitor_mc_target_pt);
            
  //////////////////////////////////////////////////////////////////////
  // Connect layer's passthrough sockets to nvdla_top SystemC model 
  // The layer would connect these to the SV side via UVMConnect calls
  //////////////////////////////////////////////////////////////////////
  nvdla_top_sc_inst->dma_monitor_cv.bind(nvdla_top_sc_layer_inst->nvdla_top_sc2sv_dma_monitor_cv_target_pt);

  //////////////////////////////////////////////////////////////////////
  // Connect layer's passthrough sockets to nvdla_top SystemC model 
  // The layer would connect these to the SV side via UVMConnect calls
  //////////////////////////////////////////////////////////////////////
  nvdla_top_sc_inst->convolution_core_monitor_initiator.bind(nvdla_top_sc_layer_inst->nvdla_top_sc2sv_convolution_core_monitor_initiator_target_pt);
            
  //////////////////////////////////////////////////////////////////////
  // Connect layer's passthrough sockets to nvdla_top SystemC model 
  // The layer would connect these to the SV side via UVMConnect calls
  //////////////////////////////////////////////////////////////////////
  nvdla_top_sc_inst->post_processing_monitor_initiator.bind(nvdla_top_sc_layer_inst->nvdla_top_sc2sv_post_processing_monitor_initiator_target_pt);

  //////////////////////////////////////////////////////////////////////
  // Connect layer's passthrough sockets to nvdla_top SystemC model 
  // The layer would connect these to the SV side via UVMConnect calls
  //////////////////////////////////////////////////////////////////////
  nvdla_top_sc_layer_inst->nvdla_top_sv2sc_dma_monitor_mc_credit_initiator_pt.bind(nvdla_top_sc_inst->dma_monitor_mc_credit);   

  //////////////////////////////////////////////////////////////////////
  // Connect layer's passthrough sockets to nvdla_top SystemC model 
  // The layer would connect these to the SV side via UVMConnect calls
  //////////////////////////////////////////////////////////////////////
  nvdla_top_sc_layer_inst->nvdla_top_sv2sc_dma_monitor_cv_credit_initiator_pt.bind(nvdla_top_sc_inst->dma_monitor_cv_credit);   

  //////////////////////////////////////////////////////////////////////
  // Connect layer's passthrough sockets to nvdla_top SystemC model 
  // The layer would connect these to the SV side via UVMConnect calls
  //////////////////////////////////////////////////////////////////////
  nvdla_top_sc_layer_inst->nvdla_top_sv2sc_convolution_core_monitor_credit_initiator_pt.bind(nvdla_top_sc_inst->convolution_core_monitor_credit);   

  //////////////////////////////////////////////////////////////////////
  // Connect layer's passthrough sockets to nvdla_top SystemC model 
  // The layer would connect these to the SV side via UVMConnect calls
  //////////////////////////////////////////////////////////////////////
  nvdla_top_sc_layer_inst->nvdla_top_sv2sc_post_processing_monitor_credit_initiator_pt.bind(nvdla_top_sc_inst->post_processing_monitor_credit);    

  //////////////////////////////////////////////////////////////////////
  // Hierarchial IO connections for syscan adapter generation 
  //////////////////////////////////////////////////////////////////////
    
  //Connect scalar nvdla_intr
  nvdla_top_sc_inst->nvdla_intr(nvdla_top_sc_layer_inst->nvdla_top_sc2sv_nvdla_intr);
  nvdla_top_sc_layer_inst->nvdla_top_sc2sv_nvdla_intr(nvdla_top_sc2sv_nvdla_intr);
};
