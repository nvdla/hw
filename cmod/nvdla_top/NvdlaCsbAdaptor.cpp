// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaCsbAdaptor.cpp

#include "NvdlaCsbAdaptor.h"
#include "opendla.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

NvdlaCsbAdaptor::NvdlaCsbAdaptor( sc_module_name module_name )
	: sc_module(module_name)
{
    csb_read_fifo = new sc_core::sc_fifo<NV_MSDEC_xx2csb_erpt_t *> ( 4 );
    this->csb_nvdla_bus.register_b_transport(this, &NvdlaCsbAdaptor::csb_nvdla_bus_cb);
    this->csb2adaptor.register_b_transport(this, &NvdlaCsbAdaptor::csb2adaptor_b_transport);
}

NvdlaCsbAdaptor::~NvdlaCsbAdaptor() {
    if (csb_read_fifo) delete csb_read_fifo;
}

void NvdlaCsbAdaptor::csb_nvdla_bus_cb(int ID, tlm_generic_payload& gp, sc_time& delay) {
	uint32_t   address  = gp.get_address();
    uint8_t*  data_ptr = gp.get_data_ptr();
    // Only support 4bytes read/write with aligned address
    sc_assert(gp.get_data_length()==4 && address%4 == 0);

    csb2xx_16m_secure_be_lvl_t csb_payload;
    csb_payload.addr    = address >> 2;
    csb_payload.write   = gp.is_write();
    if (csb_payload.write) {
        csb_payload.wdat = *(reinterpret_cast<uint32_t *>(data_ptr));
        csb_payload.wrbe = 0xFFFFFFFF;
    }
    csb_payload.nposted = 0;
    csb_payload.srcpriv = 0;
    csb_payload.secure  = 0;
    csb_payload.level   = 0;

    adaptor2csb_bp.set_data_ptr( reinterpret_cast<unsigned char*>( &csb_payload ) );
    adaptor2csb_bp.set_data_length( sizeof(csb2xx_16m_secure_be_lvl_t) );
    adaptor2csb->b_transport(adaptor2csb_bp, delay);

	if( gp.is_read() ) {
        NV_MSDEC_xx2csb_erpt_t* csb_read_pd = csb_read_fifo->read();
        *(reinterpret_cast<uint32_t *>(data_ptr)) = csb_read_pd->pd.xx2csb.rdat;
	}
    gp.set_response_status( tlm::TLM_OK_RESPONSE );
}

// csb2adaptor read response target socket
void NvdlaCsbAdaptor::csb2adaptor_b_transport(int ID, NV_MSDEC_xx2csb_erpt_t* payload, sc_time& delay) {
    csb_read_fifo->write(payload);
}

void NvdlaCsbAdaptor::csb2adaptor_b_transport(int ID, tlm_generic_payload& gp, sc_time& delay)
{
    NV_MSDEC_xx2csb_erpt_t* payload = (NV_MSDEC_xx2csb_erpt_t*) gp.get_data_ptr();
    csb2adaptor_b_transport(ID, payload, delay);
}
