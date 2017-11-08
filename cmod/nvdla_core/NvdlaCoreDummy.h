// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaCoreDummy.h

#ifndef _NVDLACOREDUMMY_H_
#define _NVDLACOREDUMMY_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 

#include "scsim_common.h"


#define NVDLA_AXI_ADAPTOR_OUT_STANDING_REQUEST_NUM 1024


SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

class NvdlaCoreDummy : public sc_module {
    public:
        SC_HAS_PROCESS(NvdlaCoreDummy);
        NvdlaCoreDummy( sc_module_name module_name );
        ~NvdlaCoreDummy();

		// Initiator sockets
		// Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): cvif2csb_resp
    	tlm_utils::multi_passthrough_initiator_socket<NvdlaCoreDummy, 32, tlm::tlm_base_protocol_types> cvif2csb_resp;
		// Initiator Socket (unrecognized protocol: nvdla_xx2csb_resp_t): mcif2csb_resp
    	tlm_utils::multi_passthrough_initiator_socket<NvdlaCoreDummy, 32, tlm::tlm_base_protocol_types> mcif2csb_resp;
		// Target sockets
		// Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2cvif_req
    	tlm_utils::multi_passthrough_target_socket<NvdlaCoreDummy, 32, tlm::tlm_base_protocol_types> csb2cvif_req;
		virtual void csb2cvif_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
		// Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): csb2mcif_req
    	tlm_utils::multi_passthrough_target_socket<NvdlaCoreDummy, 32, tlm::tlm_base_protocol_types> csb2mcif_req;
		virtual void csb2mcif_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);

		// sc_in, sc_out, sc_inout
};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NvdlaCoreDummy * NvdlaCoreDummyCon(sc_module_name module_name);

#endif

