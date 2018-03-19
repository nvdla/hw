// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaAxiAdaptor.cpp

#include "NvdlaAxiAdaptor.h"
#include "log.h"
#include "gp_mm.h"
SCSIM_NAMESPACE_START(cmod)
using namespace std;
using namespace tlm;
using namespace sc_core;

NvdlaAxiAdaptor::NvdlaAxiAdaptor( sc_module_name module_name )
	: sc_module(module_name),
      m_peq(module_name)
{
    m_perf = 0;

    m_mm = gp_mm::getGPMemManager();
    assert( m_mm );

	customized_wr_req.register_b_transport(this, &NvdlaAxiAdaptor::customized_wr_req_b_transport);
	customized_rd_req.register_b_transport(this, &NvdlaAxiAdaptor::customized_rd_req_b_transport);
    standard_axi.register_nb_transport_bw(this, &NvdlaAxiAdaptor::axi_nb_transport_bw_cb);

    axi_rd_req_fifo_ = new sc_fifo <tlm_generic_payload*> (1);
    axi_wr_req_fifo_ = new sc_fifo <tlm_generic_payload*> (1);

    SC_THREAD(axi_rd_wr_thread);
    sensitive  << axi_rd_req_fifo_->data_written_event()  << axi_wr_req_fifo_->data_written_event();
}

void NvdlaAxiAdaptor::nb_resp_thread()
{
    while( true ) {
        wait( m_peq.get_event() );

        tlm_generic_payload* gp = 0;
        while( (gp = m_peq.get_next_transaction()) != 0 ) {
            tlm_phase phase = tlm::END_RESP;
            sc_time delay = sc_time(1, SC_NS);
            standard_axi->nb_transport_fw( *gp, phase, delay);
            done_request( *gp, delay );
            cslDebug(( 50, "%s send END_RESP, tran = %p\n", basename(), gp ));
        }
    }
}

static void free_gp(tlm_generic_payload *gp)
{
    if (gp == NULL) {
        return ;
    }

    if (gp->get_data_ptr()) {
        delete [] gp->get_data_ptr();
    }
    if (gp->get_byte_enable_ptr()) {
        delete [] gp->get_byte_enable_ptr();
    }
    delete gp;
}

void NvdlaAxiAdaptor::axi_rd_wr_thread()
{
    tlm_generic_payload *tlm_gp;
    sc_time delay = sc_core::SC_ZERO_TIME;
    while (true) {
        if((axi_rd_req_fifo_->num_available()==0) && (axi_wr_req_fifo_->num_available()==0)) {
            cslDebug((50, "NvdlaAxiAdaptor::axi_rd_wr_thread, no pending request, waiting.\n"));
            wait();
            cslDebug((50, "NvdlaAxiAdaptor::axi_rd_wr_thread, get new request, wake up.\n"));
        }

        // Get a read/write event

        // For Read request
        if (axi_rd_req_fifo_->nb_read(tlm_gp)) {
            uint64_t address = tlm_gp->get_address();
            cslDebug((50, "NvdlaAxiAdaptor::axi_rd_wr_thread, send read request start. address=0x%lx\n", address));
            if( m_perf ) {
                axi_nb_transport_fw( *tlm_gp, delay );
            } else {
                cslDebug(( 50, "NvdlaAxiAdaptor::axi_rd_wr_thread, before standard_axi (read)\n" ));
                tlm_gp->set_mm( m_mm ); // CVNAS require
                standard_axi->b_transport(*tlm_gp, delay);
                customized_rd_rsp->b_transport(*tlm_gp, delay);
                cslDebug(( 50, "NvdlaAxiAdaptor::axi_rd_wr_thread, after standard_axi (read)\n" ));
            }
            free_gp(tlm_gp);
            cslDebug((50, "NvdlaAxiAdaptor::axi_rd_wr_thread, send read request done\n"));
        }
        // For Write request
        if (axi_wr_req_fifo_->nb_read(tlm_gp)) {
            uint64_t address = tlm_gp->get_address();
            cslDebug((50, "NvdlaAxiAdaptor::axi_rd_wr_thread, send write request start. address=0x%lx\n", address));
            if( m_perf ) {
                axi_nb_transport_fw( *tlm_gp, delay );
            } else {
                cslDebug(( 50, "NvdlaAxiAdaptor::axi_rd_wr_thread, before standard_axi (write)\n" ));
                tlm_gp->set_mm( m_mm ); // CVNAS require
                standard_axi->b_transport(*tlm_gp, delay);
                customized_wr_rsp->b_transport(*tlm_gp, delay);
                cslDebug(( 50, "NvdlaAxiAdaptor::axi_rd_wr_thread, after standard_axi (write)\n" ));
            }
            free_gp(tlm_gp);
            cslDebug((50, "NvdlaAxiAdaptor::axi_rd_wr_thread, send write request done\n"));
        }
    }
}


tlm_sync_enum NvdlaAxiAdaptor::axi_nb_transport_bw_cb(int ID, tlm_generic_payload& tlm_gp, tlm_phase& phase, sc_time& delay)
{
    switch( phase ) {
        case tlm::END_REQ:
            cslDebug(( 50, "%s receive END_REQ, tran = %p\n", basename(), &tlm_gp ));
            break;
        case tlm::BEGIN_RESP:
            cslDebug(( 50, "%s receive BEGIN_RESP, tran = %p\n", basename(), &tlm_gp ));
            m_peq.notify( tlm_gp, delay );
            break;
        default: FAIL(( "Illegal TLM phase transition!" ));
    }
    m_end_req.notify( SC_ZERO_TIME ); // MC doesn't send END_REQ
    return tlm::TLM_ACCEPTED;
}

static void deep_copy_gp( tlm_generic_payload& copied, const tlm_generic_payload& origin )
{
    // data
    uint32_t data_len = origin.get_data_length();
    uint32_t byte_enable_len = origin.get_byte_enable_length();

    if( !copied.get_data_ptr() ) {
        uint8_t* data_ptr = new uint8_t[data_len];
        copied.set_data_ptr(data_ptr);
    } else {
        if( copied.get_data_length() < data_len ) {
            uint8_t* data_ptr = copied.get_data_ptr();
            delete [] data_ptr;
            data_ptr = new uint8_t[data_len];
            copied.set_data_ptr(data_ptr);
        }
    }

    if( !copied.get_byte_enable_ptr() ) {
        uint8_t* byte_enable_ptr = new uint8_t[byte_enable_len];
        copied.set_byte_enable_ptr(byte_enable_ptr);
    } else {
        if( copied.get_byte_enable_length() < byte_enable_len ) {
            uint8_t* byte_enable_ptr = copied.get_byte_enable_ptr();
            delete [] byte_enable_ptr;
            byte_enable_ptr = new uint8_t[byte_enable_len];
            copied.set_byte_enable_ptr(byte_enable_ptr);
        }
    }

    copied.deep_copy_from(origin);
}

void NvdlaAxiAdaptor::axi_nb_transport_fw(tlm_generic_payload& tran, sc_time& delay)
{
    delay = sc_core::SC_ZERO_TIME;
    tlm_phase phase = tlm::BEGIN_REQ;
    tlm_generic_payload* tlm_gp = m_mm->allocate();
    deep_copy_gp(*tlm_gp, tran);
    tlm_gp->acquire();

	tlm_sync_enum sync = standard_axi->nb_transport_fw(*tlm_gp, phase, delay);
    cslDebug(( 50, "%s send BEGIN_REQ, tran = %p\n", basename(), tlm_gp ));

    switch( sync ) {
        case tlm::TLM_COMPLETED:
        {
            done_request( *tlm_gp, delay );
            cslDebug(( 50, "%s got TLM_COMPLETED, tran = %p\n", basename(), tlm_gp ));
            break;
        }
        case tlm::TLM_ACCEPTED:
        {
            if( phase != tlm::BEGIN_REQ ) {
                FAIL(( "Illegal TLM phase transition!" ));
            }
            wait( m_end_req );
            break;
        }
        case tlm::TLM_UPDATED:
        {
            switch( phase ) {
                case tlm::END_REQ:
                    cslDebug(( 50, "%s receive END_REQ, tran = %p\n", basename(), tlm_gp ));
                    break;
                case tlm::BEGIN_RESP:
                    m_peq.notify( *tlm_gp, delay );
                    cslDebug(( 50, "%s receive BEGIN_RESP, tran = %p\n", basename(), tlm_gp ));
                    break;
                default: FAIL(( "Illegal TLM phase transition!" ));
            }
            break;
        }
        default: assert( 0 );
    }
}

void NvdlaAxiAdaptor::done_request(tlm_generic_payload& tlm_gp, sc_time& delay)
{
    if( tlm_gp.is_response_error() ) {
        FAIL(( "payload response error: %u", tlm_gp.get_response_status() ));
    }
    if( tlm_gp.is_write() ) {
        customized_wr_rsp->b_transport(tlm_gp, delay);
    } else {
        customized_rd_rsp->b_transport(tlm_gp, delay);
    }
    tlm_gp.release();
}

void NvdlaAxiAdaptor::customized_wr_req_b_transport(tlm_generic_payload& tlm_gp, sc_time& delay)
{
    tlm_generic_payload * new_tlm_gp = new tlm_generic_payload();
    deep_copy_gp(*new_tlm_gp, tlm_gp);
    uint64_t address = tlm_gp.get_address();
    cslDebug(( 50, "before NvdlaAxiAdaptor::customized_wr_req_b_transport address=0x%lx\n", address ));
    axi_wr_req_fifo_->write(new_tlm_gp);
    cslDebug(( 50, "after NvdlaAxiAdaptor::customized_wr_req_b_transport\n" ));
}

void NvdlaAxiAdaptor::customized_rd_req_b_transport(tlm_generic_payload& tlm_gp, sc_time& delay)
{
    tlm_generic_payload * new_tlm_gp = new tlm_generic_payload();
    deep_copy_gp(*new_tlm_gp, tlm_gp);
    uint64_t address = tlm_gp.get_address();
    cslDebug(( 50, "before NvdlaAxiAdaptor::customized_rd_req_b_transport address=0x%lx\n", address ));
    axi_rd_req_fifo_->write(new_tlm_gp);
    cslDebug(( 50, "after NvdlaAxiAdaptor::customized_rd_req_b_transport\n" ));
}

SCSIM_NAMESPACE_END()

