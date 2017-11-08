// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_nvdla.h

#ifndef _NV_NVDLA_H_
#define _NV_NVDLA_H_

#include "NV_nvdla_top_base.h"
#include "scsim_common.h"
#include <systemc.h>

SCSIM_NAMESPACE_START(cmod)

class NV_NVDLA_core;
class NvdlaAxiAdaptor;
class NvdlaTopDummy;
class NvdlaCsbAdaptor;

class NV_nvdla : public NV_nvdla_base
{
public:
    SC_HAS_PROCESS(NV_nvdla);
    NV_nvdla( sc_module_name module_name, uint8_t id=0, bool sctb_args=false );
    virtual ~NV_nvdla();

private:

    // Subunit declaration
    NV_NVDLA_core   *nvdla_core;
    NvdlaCsbAdaptor *csb_adaptor;
    NvdlaAxiAdaptor *axi_adaptor_mc;
    NvdlaAxiAdaptor *axi_adaptor_cv;
    NvdlaTopDummy   *nvdla_top_dummy;
     
    sc_buffer<bool> m_coreIrq;
};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NV_nvdla * NV_nvdlaCon(sc_module_name module_name, uint8_t inst);

#endif

