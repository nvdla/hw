// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaTopDummy.h

#ifndef _NVDLATOPDUMMY_H_
#define _NVDLATOPDUMMY_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 
#include "scsim_common.h"

SCSIM_NAMESPACE_START(cmod)

class NvdlaTopDummy : public sc_module {
public:
    SC_HAS_PROCESS(NvdlaTopDummy);
    NvdlaTopDummy( sc_module_name module_name );

	// Target sockets
    tlm_utils::multi_passthrough_target_socket<NvdlaTopDummy> m_target;

private:
	void dummy_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
};

SCSIM_NAMESPACE_END()

#endif

