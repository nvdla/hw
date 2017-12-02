// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaTopDummy.cpp

#include "NvdlaTopDummy.h"
USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace tlm;
using namespace sc_core;

NvdlaTopDummy::NvdlaTopDummy( sc_module_name module_name )
	: sc_module(module_name),
      m_target("dummy_target")
{
	m_target.register_b_transport(this, &NvdlaTopDummy::dummy_b_transport);
}

void NvdlaTopDummy::dummy_b_transport(int ID, tlm::tlm_generic_payload& gp, sc_time& delay) 
{
    gp.set_response_status(tlm::TLM_OK_RESPONSE);
}
