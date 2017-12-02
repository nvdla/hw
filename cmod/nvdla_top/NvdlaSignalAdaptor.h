// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaSignalAdaptor.h

#ifndef _NV_NVDLA_SIGNAL_ADAPTOR_H_
#define _NV_NVDLA_SIGNAL_ADAPTOR_H_

#include "scsim_common.h"
#include <systemc>
#include <tlm.h>
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/simple_target_socket.h>


SCSIM_NAMESPACE_START(cmod)

template< typename T >
class Signal2Socket : public sc_core::sc_module
{
public:
    SC_CTOR( Signal2Socket ) {
        SC_THREAD( transport );
        sensitive << m_signal;
    }
    virtual ~Signal2Socket() {}

    sc_core::sc_in< T > m_signal;
    tlm_utils::simple_initiator_socket< Signal2Socket<T> > m_socket;

protected:
    virtual void transport() = 0;
    tlm::tlm_generic_payload m_gp;
    sc_core::sc_time m_delay;
};


template< typename T >
class Socket2Signal : public sc_core::sc_module
{
public:
    SC_CTOR( Socket2Signal ) {
        m_socket.register_b_transport( this, &Socket2Signal<T>::transport );
    }
    virtual ~Socket2Signal() {}

    sc_core::sc_out< T > m_signal;
    tlm_utils::simple_target_socket< Socket2Signal<T> > m_socket;

protected:
    virtual void transport( tlm::tlm_generic_payload &gp, sc_time &delay ) = 0;
};


class ResetAdaptor : public Signal2Socket< bool >
{
public:
    ResetAdaptor( sc_core::sc_module_name name )
        : Signal2Socket( name )
    {
        m_gp.set_data_length( sizeof(rstDat) );
        m_gp.set_data_ptr( reinterpret_cast<unsigned char*>( &m_rstPkt )  );
    }

    void transport() {
        while(1) {
            wait();
            m_rstPkt.reset_ = m_signal.read();
            m_rstPkt.direct_reset_ = 1;
            m_rstPkt.test_mode = 0;
            m_socket->b_transport( m_gp, m_delay );
        }
    }

private:
    rstDat m_rstPkt;
};

class EngIrqAdaptor : public Signal2Socket< bool >
{
public:
    EngIrqAdaptor( sc_core::sc_module_name name )
        : Signal2Socket( name )
    {
        m_gp.set_data_length( sizeof(fmodIntrDat) );
        m_gp.set_data_ptr( reinterpret_cast<unsigned char*>( &m_engIntr )  );
    }

    void transport() {
        while(1) {
            wait();
            m_engIntr.intr  = m_signal.read();
            m_engIntr.index = 10;
            m_socket->b_transport( m_gp, m_delay );
        }
    }

private:
    fmodIntrDat m_engIntr;
};

class ThiIrqAdaptor : public Socket2Signal< bool >
{
public:
    ThiIrqAdaptor( sc_core::sc_module_name name  )
        : Socket2Signal( name )
    {}

    void transport( tlm::tlm_generic_payload &gp, sc_core::sc_time &delay )
    {
        m_thiIntr = reinterpret_cast< thiIntrDat* >( gp.get_data_ptr() );
        gp.set_response_status( tlm::TLM_OK_RESPONSE );
        m_signal.write( m_thiIntr->intr );
    }

private:
    thiIntrDat* m_thiIntr;
};

SCSIM_NAMESPACE_END()

#endif

