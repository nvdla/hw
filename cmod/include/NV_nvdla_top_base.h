// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_nvdla_top_base.h

#ifndef _NV_NVDLA_TOP_BASE_H_
#define _NV_NVDLA_TOP_BASE_H_

#ifndef SC_INCLUDE_DYNAMIC_PROCESSES
#define SC_INCLUDE_DYNAMIC_PROCESSES
#endif


#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_initiator_socket.h>
#include <tlm_utils/multi_passthrough_target_socket.h>

SCSIM_NAMESPACE_START(cmod)

// Base SystemC class for module NV_nvdla
class NV_nvdla_base : public sc_module
{
    public:

    // Constructor
    NV_nvdla_base(const sc_module_name name);


    // Port has no flow: nvdla_intr
    sc_out<bool> nvdla_intr;


    // Initiator Socket (axi4): nvdla_core2cvsram_axi4
    tlm::tlm_generic_payload nvdla_core2cvsram_axi4_gp;
    tlm_utils::multi_passthrough_initiator_socket<NV_nvdla_base> nvdla_core2cvsram_axi4;


    // Initiator Socket (axi4): nvdla_core2dbb_axi4
    tlm::tlm_generic_payload nvdla_core2dbb_axi4_gp;
    tlm_utils::multi_passthrough_initiator_socket<NV_nvdla_base> nvdla_core2dbb_axi4;


    // Target Socket (csb): nvdla_host_master_if
    tlm_utils::multi_passthrough_target_socket<NV_nvdla_base> nvdla_host_master_if;

    // Destructor
    virtual ~NV_nvdla_base() {}

};

// Constructor for base SystemC class for module NV_nvdla
inline NV_nvdla_base::NV_nvdla_base(const sc_module_name name)
    : sc_module(name),

    nvdla_intr("nvdla_intr"),

    nvdla_core2cvsram_axi4_gp(),
    nvdla_core2cvsram_axi4("nvdla_core2cvsram_axi4"),

    nvdla_core2dbb_axi4_gp(),
    nvdla_core2dbb_axi4("nvdla_core2dbb_axi4"),

    nvdla_host_master_if("nvdla_host_master_if")
{

}

SCSIM_NAMESPACE_END()

#endif
