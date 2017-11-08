// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaCoreDummy.cpp

#include "NvdlaCoreDummy.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;


NvdlaCoreDummy::NvdlaCoreDummy( sc_module_name module_name )
	: sc_module(module_name),
	cvif2csb_resp("cvif2csb_resp"),
	mcif2csb_resp("mcif2csb_resp"),
	csb2cvif_req("csb2cvif_req"),
	csb2mcif_req("csb2mcif_req")
{
	// Register target socket b_transport
	this->csb2cvif_req.register_b_transport(this, &NvdlaCoreDummy::csb2cvif_req_b_transport);
	this->csb2mcif_req.register_b_transport(this, &NvdlaCoreDummy::csb2mcif_req_b_transport);
	// this->.register_b_transport(this, &NvdlaCoreDummy::);
}
#pragma CTC SKIP
NvdlaCoreDummy::~NvdlaCoreDummy() {
}

// b_transports for target sockets
void NvdlaCoreDummy::csb2cvif_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
}

void NvdlaCoreDummy::csb2mcif_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
}

// void NvdlaCoreDummy::() {
// }

NvdlaCoreDummy * NvdlaCoreDummyCon(sc_module_name name)
{
    return new NvdlaCoreDummy(name);
}
#pragma CTC ENDSKIP
