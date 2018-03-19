//
//------------------------------------------------------------//
//   Copyright 2009-2012 Mentor Graphics Corporation          //
//   All Rights Reserved Worldwid                             //
//                                                            //
//   Licensed under the Apache License, Version 2.0 (the      //
//   "License"); you may not use this file except in          //
//   compliance with the License.  You may obtain a copy of   //
//   the License at                                           //
//                                                            //
//       http://www.apache.org/licenses/LICENSE-2.0           //
//                                                            //
//   Unless required by applicable law or agreed to in        //
//   writing, software distributed under the License is       //
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR   //
//   CONDITIONS OF ANY KIND, either express or implied.  See  //
//   the License for the specific language governing          //
//   permissions and limitations under the License.           //
//------------------------------------------------------------//

#ifndef UVMC_CHANNELS_H
#define UVMC_CHANNELS_H

//------------------------------------------------------------------------------
//
//                               SC ---> SV
//
// This file defines channel and target socket proxies that are driven
// from SC-side ports and initiator sockets. These proxies will delegate 
// the operations to the SV-side.
//
//------------------------------------------------------------------------------

#include <string>
#include <map>
#include <vector>
#include <iomanip>
#include <systemc.h>
#include <tlm.h>
//#include <tlm/tlm_utils/simple_target_socket.h>


using namespace sc_core;
using namespace sc_dt;
using namespace tlm;
//using namespace tlm_utils;
using std::string;
using std::map;
using std::vector;
using sc_core::sc_semaphore;

#include "svdpi.h"

#include "uvmc_common.h"
#include "uvmc_convert.h"


//------------------------------------------------------------------------------
//
// Group- DPI-C export functions
//
// Not intended for public use.
//
// The following C2SV-prefixed functions are called by UVMC to transfer
// packed bits across the language boundary using standard DPI-C.
//
//------------------------------------------------------------------------------

extern "C"
{

void  C2SV_put      (int x_id, const bits_t *bits);
bool  C2SV_try_put  (int x_id, const bits_t *bits);
bool  C2SV_can_put  (int x_id);
void  C2SV_get      (int x_id);
bool  C2SV_try_get  (int x_id, bits_t *bits);
bool  C2SV_can_get  (int x_id);
void  C2SV_peek     (int x_id);
bool  C2SV_try_peek (int x_id, bits_t *bits);
bool  C2SV_can_peek (int x_id);
void  C2SV_write    (int x_id, const bits_t *bits);

void  C2SV_transport    (int x_id, bits_t *bits);
bool  C2SV_try_transport(int x_id, bits_t *bits);

int   C2SV_nb_transport_fw (int x_id,
                            bits_t *bits,
                            unsigned int *phase,
                            uint64 *delay);

int   C2SV_nb_transport_bw (int x_id,
                            bits_t *bits,
                            unsigned int *phase,
                            uint64 *delay);

void  C2SV_b_transport     (int x_id,
                            bits_t *bits,
                            uint64 delay);

//void  SV2C_blocking_req_done(int x_id);
//void  SV2C_blocking_rsp_done(int x_id, const bits_t *bits, uint64 delay);
}

namespace uvmc
{

//------------------------------------------------------------------------------
//
// CLASS- uvmc_tlm1_channel_proxy
//
// Not intended as a user class.
// The <uvmc_connect> function is the user of this proxy. 
//
// The ~uvmc_tlm1_channel_proxy~ is used to connect with registered TLM1 ports
// so they pass connectivity checks during SystemC elaboration. It serves as a
// proxy to an export or imp residing in SystemVerilog.
//
//|                             bind
//|  sc_port<[TLM1 interface]>  ---->  uvmc_tlm1_channel_proxy
//
// The <uvmc_connect> function creates, binds, and returns an instance of this
// proxy.
//------------------------------------------------------------------------------

template <class T1, class T2=T1,
          class CVRT_T1=uvmc_converter<T1>,
          class CVRT_T2=uvmc_converter<T2> >
class uvmc_tlm1_channel_proxy
    : public virtual uvmc_proxy_base,
      public virtual sc_prim_channel,
      public virtual tlm_put_if<T1>,
      public virtual tlm_get_peek_if<T1>,
      public virtual tlm_master_if<T1,T2>,
      public virtual tlm_slave_if<T2,T1>,
      public virtual tlm_transport_if<T1,T2>
{
  protected:
  sc_event m_never_triggered;
  mutable sc_semaphore m_sem;
  T2 m_t;

  public:
  typedef uvmc_tlm1_channel_proxy <T1,T2,CVRT_T1,CVRT_T2> this_type;

  // c'tor

  uvmc_tlm1_channel_proxy(const string name, const string lookup, const int mask,
     uvmc_packer *packer=NULL) : 
       uvmc_proxy_base(name, lookup, mask, packer, UVM_CHANNEL),
       sc_prim_channel((string("UVMC_CHAN_FOR_") + uvmc_legal_path(name)).c_str()),
       m_sem(1) {
    sc_core::sc_get_curr_simcontext()->hierarchy_pop();
  }

  // called via SV when a blocking put returns. No return data, just
  // allow the blocked put on the SC side to return.
  virtual void blocking_req_done() {
    m_blocking_op_done.notify();
  }

  // called via SV when a blocking get or peek or transport returns.
  // data returns with the call, which must be converted to a transaction.
  // the delay is used for TLM2 b_transport only, so we ignore here.
  virtual void blocking_rsp_done(const bits_t *bits, uint64 delay) {
    //int sz, id;
    m_packer->init_unpack(bits);
    //(*m_packer) >> sz >> id; // throw size and ID out.
    CVRT_T2::do_unpack(m_t,*m_packer);
    m_blocking_op_done.notify();
  }

 
  // B_PUT

  virtual void put (const T1 &t) {
    wait_connected();
    m_sem.wait();
    m_packer->init_pack(m_bits);
    CVRT_T1::do_pack(t,*m_packer);
    svSetScope(uvmc_pkg_scope);
    C2SV_put(m_x_id,m_bits);
    wait(m_blocking_op_done);
    m_sem.post();
  }


  // NB_PUT

  virtual bool nb_put (const T1 &t) {
    if (!nb_can_put())
      return 0;
    m_packer->init_pack(m_bits);
    CVRT_T1::do_pack(t,*m_packer);
    svSetScope(uvmc_pkg_scope);
    return C2SV_try_put(m_x_id,m_bits);
  }

  virtual bool nb_can_put (tlm_tag<T1> *t=0) const {
    if (!m_connected)
      return 0;
    if (m_sem.trywait()==-1)
      return 0;
    m_sem.post();
    svSetScope(uvmc_pkg_scope);
    return C2SV_can_put(m_x_id);
  }
   
  virtual const sc_event &ok_to_put (tlm_tag<T1> *t=0) const  {
    // return *something* non-null, effectively disabled.
    return m_never_triggered;
  }

  // B_GET

  virtual void get (T2 &t) {
    wait_connected();
    m_sem.wait();
    svSetScope(uvmc_pkg_scope);
    C2SV_get(m_x_id);
    wait(m_blocking_op_done);
    t = m_t;
    m_sem.post();
  }

  virtual T2 get (tlm_tag<T2> *t=0)  {
    T2 tr;
    get(tr);
    return tr;
  }
   
  // NB_GET

  virtual bool nb_get (T2 &t)  {
    if (!nb_can_get())
      return 0;
    svSetScope(uvmc_pkg_scope);
    if (C2SV_try_get(m_x_id,m_bits)) {
      m_packer->init_unpack(m_bits);
      CVRT_T2::do_unpack(t,*m_packer);
      return 1;
    }
    return 0;
  }
   
  virtual bool nb_can_get (tlm_tag<T2> *t=0) const  {
    if (!m_connected)
      return 0;
    if (m_sem.trywait()==-1)
      return 0;
    m_sem.post();
    svSetScope(uvmc_pkg_scope);
    return C2SV_can_get(m_x_id);
  }
   
  virtual const sc_event &ok_to_get (tlm_tag<T2> *t=0) const  {
    // return *something* non-null, effectively disabled.
    return m_never_triggered;
  }

  
  // B_PEEK

  virtual void peek (T2& t) const  {
    // ADAME: Note: wait methods are not const. Need to play trick.
    m_sem.wait();
    svSetScope(uvmc_pkg_scope);
    C2SV_peek(m_x_id);
    const_cast< this_type * >( this )->wait(m_blocking_op_done);
    t = m_t;
    m_sem.post();
  }
   
  virtual T2 peek (tlm_tag<T2> *t=0) const {
    T2 tr;
    peek(tr);
    return tr;
  }

  // NB_PEEK

  virtual bool nb_peek (T2 &t) const  {
    if (!nb_can_peek())
      return 0;
    svSetScope(uvmc_pkg_scope);
    if (C2SV_try_peek(m_x_id,m_bits)) {
      m_packer->init_unpack(m_bits);
      CVRT_T2::do_unpack(t,*m_packer);
      return 1;
    }
    return 0;
  }
   
  virtual bool nb_can_peek (tlm_tag<T2> *t=0) const  {
    if (!m_connected)
      return 0;
    if (m_sem.trywait()==-1)
      return 0;
    m_sem.post();
    svSetScope(uvmc_pkg_scope);
    return C2SV_can_peek(m_x_id);
  }
   
  virtual const sc_event &ok_to_peek (tlm_tag<T2> *t=0) const  {
    // return *something* non-null, effectively disabled.
    return m_never_triggered;
  }
   
  // TRANSPORT (TLM1)

  virtual void transport(const T1 &req, T2 &rsp)  {
    wait_connected();
    m_sem.wait();
    m_packer->init_pack(m_bits);
    CVRT_T1::do_pack(req,*m_packer);
    svSetScope(uvmc_pkg_scope);
    C2SV_transport(m_x_id,m_bits);
    wait(m_blocking_op_done); 
    rsp = m_t;
    m_sem.post();
  }
   
  // tlm_core_ifs defines return type as return-by-value!;
  // RSP must define copy ctor!  Inefficient.
  virtual T2 transport(const T1 &req) {
    T2 rsp;
    transport(req,rsp);
    return rsp;
  }
};



//------------------------------------------------------------------------------
//
// CLASS- uvmc_tlm2_channel_proxy
//
// Not intended as a user class.
// The <uvmc_connect> function is the user of this proxy. 
//
// The ~uvmc_tlm2_channel_proxy~ is used to connect with registered TLM2 ports
// so they pass connectivity checks during SystemC elaboration. It serves as a
// proxy to an export or imp residing in SystemVerilog.
//
//|                             bind
//|  sc_port<[TLM2 interface]>  ---->  uvmc_tlm2_channel_proxy
//
// This proxy is also used as a proxy channel for connecting analysis ports, i.e.
// ~tlm_analysis_port<T>~.
//
// The <uvmc_connect> function creates, binds, and returns an instance of
// this proxy.
//------------------------------------------------------------------------------


template <class T, class PHASE=tlm_phase, class CVRT=uvmc_converter<T> >
class uvmc_tlm2_channel_proxy
    : public uvmc_proxy_base,
      public sc_prim_channel,
      public virtual tlm_blocking_transport_if<T>,
      public virtual tlm_fw_nonblocking_transport_if<T,PHASE>,
      public virtual tlm_bw_nonblocking_transport_if<T,PHASE>,
      public virtual tlm_analysis_if<T>,
      public virtual tlm_write_if<T>
{
  protected:
  mutable sc_semaphore m_sem;

  public:
  uvmc_tlm2_channel_proxy(const string name, const string lookup,
                            const int mask, uvmc_packer *packer=NULL) :
                        uvmc_proxy_base(name, lookup, mask, packer, UVM_CHANNEL),
                        sc_prim_channel((string("UVMC_CHAN_FOR_") + uvmc_legal_path(name)).c_str()),
                        m_sem(1) {
    sc_core::sc_get_curr_simcontext()->hierarchy_pop();
  }

  T * m_t;

  // called via SV when a blocking put returns. No return data, just
  // allow the blocked put on the SC side to return.
  virtual void blocking_req_done() {
    m_blocking_op_done.notify();
  }

  // called via SV when a blocking get or peek or transport returns.
  // data returns with the call, which must be converted to a transaction.
  // the delay is used for TLM2 b_transport only, so we ignore here.
  virtual void blocking_rsp_done(const bits_t *bits, uint64 delay) {
    //int sz, id;
    m_packer->init_unpack(bits);
    //(*m_packer) >> sz >> id;
    CVRT::do_unpack(*m_t,*m_packer);
    //rsp_trans_queue.push_back(t);
    m_delay_bits = delay;
    m_blocking_op_done.notify();
  }

  virtual ~uvmc_tlm2_channel_proxy() {
  }

  // B_TRANSPORT (TLM2)

  virtual void b_transport( T& trans, sc_time& t )
  {
#ifdef UVMC23_ADDITIONS // {
    // if( SC <-> SC UVM-Connect'ion being used ) ...
    if( m_use_peer_sc_proxy ) {
        sc2sc_b_transport( trans, t );
        return;
    }
#endif // } UVMC23_ADDITIONS

    double delay_in_ps = t.to_seconds() * 1e12; 
    uint64* delay_in_bits = reinterpret_cast<uint64*>(&delay_in_ps);
    wait_connected();
    m_sem.wait();
    m_packer->init_pack(m_bits);
    CVRT::do_pack(trans,*m_packer);
    svSetScope(uvmc_pkg_scope);
    C2SV_b_transport(m_x_id, m_bits, *delay_in_bits);
    m_t = &trans;
    wait(m_blocking_op_done);
    //m_packer->init_unpack(m_bits);
    //CVRT::do_unpack(trans,*m_packer);
    delay_in_ps = *(reinterpret_cast<double*>(&m_delay_bits));
    t = sc_time(delay_in_ps,SC_PS);
    m_sem.post();
  }

  // NB_TRANSPORT_FW

  virtual tlm::tlm_sync_enum nb_transport_fw( T& trans,
                                              PHASE& phase,
                                              sc_core::sc_time& t)
  {
#ifdef UVMC23_ADDITIONS // {
    // if( SC <-> SC UVM-Connect'ion being used ) ...
    if( m_use_peer_sc_proxy )
        return sc2sc_nb_transport_fw( trans, phase, t );
#endif // } UVMC23_ADDITIONS

    if (!m_connected) {
      cout << "ERROR: " << uvmc_proxy_base::name()
           << ".nb_transport_fw called before SV-side was connected" << endl;
      // Todo- if TLM GP, default resp is TLM_INCOMPLETE_RESPONSE
      return TLM_COMPLETED;
    }
    int result;
    tlm_sync_enum sync;
    unsigned int ph = phase;
    double delay_in_ps = t.to_seconds() * 1e12; 
    uint64* delay_in_bits = reinterpret_cast<uint64*>(&delay_in_ps);
    m_packer->init_pack(m_bits);
    CVRT::do_pack(trans,*m_packer);
    svSetScope(uvmc_pkg_scope);
    result = C2SV_nb_transport_fw(m_x_id, m_bits, &ph, delay_in_bits);
    sync = static_cast<tlm_sync_enum>(result);
    phase = ph;
    m_packer->init_unpack(m_bits);
    CVRT::do_unpack(trans,*m_packer);
    delay_in_ps = *(reinterpret_cast<double*>(&delay_in_bits));
    t = sc_time(delay_in_ps,SC_PS);
    return sync;
  }

  // NB_TRANSPORT_BW

  virtual tlm::tlm_sync_enum nb_transport_bw( T& trans,
                                              PHASE& phase,
                                              sc_core::sc_time& t)
  {
    if (!m_connected) {
      cout << "ERROR: " << uvmc_proxy_base::name()
           << ".nb_transport_bw called before SV-side was connected" << endl;
      return TLM_COMPLETED;
    }
    int result;
    tlm_sync_enum sync;
    unsigned int ph = phase;
    double delay_in_ps = t.to_seconds() * 1e12; 
    uint64* delay_in_bits = reinterpret_cast<uint64*>(&delay_in_ps);
    m_packer->init_pack(m_bits);
    CVRT::do_pack(trans,*m_packer);
    svSetScope(uvmc_pkg_scope);
    result = C2SV_nb_transport_bw(m_x_id, m_bits, &ph, delay_in_bits);
    sync = static_cast<tlm_sync_enum>(result);
    phase = ph;
    m_packer->init_unpack(m_bits);
    CVRT::do_unpack(trans,*m_packer);
    delay_in_ps = *(reinterpret_cast<double*>(&delay_in_bits));
    t = sc_time(delay_in_ps,SC_PS);
    return sync;
  }

  virtual int x_nb_transport_bw (bits_t *bits, uint32 *phase, uint64 delay) {
    cout << "ERROR: x_nb_transport_bw not implemented" << endl;
    return 0;
  }

  // WRITE (ANALYSIS)

  virtual void write(const T& t)  {
    if (!m_connected) {
      cout << "ERROR: " << uvmc_proxy_base::name()
           << ".write called before SV-side was connected. "
           << "Transaction dropped." << endl;
      return;
    }
    m_packer->init_pack(m_bits);
    CVRT::do_pack(t,*m_packer);
    svSetScope(uvmc_pkg_scope);
    C2SV_write(m_x_id,m_bits);
  }

#ifdef UVMC23_ADDITIONS // {
  protected:
    virtual void sc2sc_b_transport( T &trans, sc_time &delay )
    { cout << "ERROR: unexpected call to "
           << "uvmc_tlm2_channel_proxy::sc2sc_b_transport()" << endl; }

    virtual tlm::tlm_sync_enum sc2sc_nb_transport_fw(
        T &trans, PHASE &phase, sc_time &delay )
    { cout << "ERROR: unexpected call to "
           << "uvmc_tlm2_channel_proxy::sc2sc_nb_transport_fw()" << endl;
      return tlm::TLM_COMPLETED; }

#endif // } UVMC23_ADDITIONS

};

//------------------------------------------------------------------------------
// CLASS- uvmc_target_socket
//
// Not intended as a user class.
// The <uvmc_connect> function is the user of this proxy. 
//
// The ~uvmc_target_socket~ is used to connect with registered TLM2 initiator
// sockets so they pass connectivity checks during SystemC elaboration. It
// serves as a proxy to a TLM2 target socket residing in SystemVerilog.
//
//|                              bind
//|  tlm_initiator_socket<T,...> ---->  uvmc_target_socket
//
//------------------------------------------------------------------------------
// Implements fw interface; 

template <unsigned int BUSWIDTH = 32,
          typename TYPES = tlm_base_protocol_types,
          int N = 1,
          sc_port_policy POL = SC_ONE_OR_MORE_BOUND,
          class CVRT=uvmc_converter<typename TYPES::tlm_payload_type> >

class uvmc_target_socket
    : /*public sc_module,*/
      public uvmc_tlm2_channel_proxy<typename TYPES::tlm_payload_type,
                                     typename TYPES::tlm_phase_type, CVRT>,
      public tlm_fw_transport_if<TYPES>
{
  public:
  typedef uvmc_tlm2_channel_proxy<typename TYPES::tlm_payload_type,
                                  typename TYPES::tlm_phase_type,
                                    CVRT> proxy_type;
  typedef tlm_target_socket <BUSWIDTH, TYPES, N, POL> target_type;
  //typedef simple_target_socket <uvmc_target_socket, BUSWIDTH, TYPES> target_type;

  target_type *m_target_skt;

#ifdef UVMC23_ADDITIONS // {
  typedef tlm_initiator_socket <BUSWIDTH, TYPES, N, POL> initiator_type;
  initiator_type *m_peer_sc_target_proxy;

  void set_peer_sc_target_proxy_socket( initiator_type *peer ){
    proxy_type::m_use_peer_sc_proxy = true;
    m_peer_sc_target_proxy = peer; }
#endif // } UVMC23_ADDITIONS

  uvmc_target_socket(/*sc_module_name nm,*/ const string name, const string lookup, 
                       uvmc_packer *packer=NULL) :
           /* sc_module(nm), */
           proxy_type(name, lookup, TLM_FW_NB_TRANSPORT_MASK |
                                    TLM_BW_NB_TRANSPORT_MASK |
                                    TLM_B_TRANSPORT_MASK, packer)
  {
    // We need to push the uvmc_registry module onto the hierarchy stack before
    // creating the target skt proxy. When the target skt is created, it will be
    // registered as a child of uvmc_registry. After socket creation, we pop
    // uvmc_registry off the hierarchy stack.

    sc_core::sc_get_curr_simcontext()->hierarchy_push(&uvmc_registry::get());

    m_target_skt = new target_type((string("UVMC_TARGET_SOCKET_FOR_") +
                                   uvmc_legal_path(string(name))).c_str());
    sc_core::sc_get_curr_simcontext()->hierarchy_pop();

    m_target_skt->bind( *this );
    // TODO: When switch to simple sockets, defer registering transport methods
    // until we know what we're connected to on the other side (b or nb socket).
    //m_target_skt->bind( *this );
    //register_nb();
    //register_b();
  }

  // During SV UVM elaboration, we attempt to associate SC-side and SV-side
  // proxies by string name. The SV-side supports only blocking or non-blocking
  // sockets, not both. So, if this socket is matched with an SV-side socket
  // that only implements the blocking intf, we register the blocking and leave
  // it to the simple target socket's adapter to convert any incoming nb transport calls
  // to the blocking intf. If the SV-side socket implements only the nb transport
  // then we call ~register_nb~ and rely on the simple_target_socket's adapter
  // to convert any blocking calls to non-blocking.

  /*
  virtual void register_nb() {
    m_target_skt->register_nb_transport_fw(this,&proxy_type::nb_transport_fw);
  }
  virtual void register_b() {
    m_target_skt->register_b_transport(this,&proxy_type::b_transport);
  }
  */

  virtual ~uvmc_target_socket() {
    delete m_target_skt;
  }


  virtual int x_nb_transport_bw (bits_t *bits,
                                 uint32 *phase,
                                 uint64 *delay) {
    typename TYPES::tlm_payload_type x_trans;
    double* d = reinterpret_cast<double*>(delay);
    sc_time x_delay = sc_time(*d,SC_PS);
    typename TYPES::tlm_phase_type x_phase = *phase;
    proxy_type::m_packer->init_unpack(bits);
#ifdef UVMC23_ADDITIONS // {
    // Allow converters to query if transaction being unpacked/packed
    // is owned by application or UVMC (for knowing when to allocate/
    // release local config extensions or use application defined ones)
    proxy_type::m_packer->uvmc_owns_trans(1);
#endif // } UVMC23_ADDITIONS
    CVRT::do_unpack(x_trans,*proxy_type::m_packer);
    tlm_sync_enum result;
    result = (*m_target_skt)->nb_transport_bw(x_trans,x_phase,x_delay);
    *phase = x_phase;
    double delay_in_ps = x_delay.to_seconds() * 1e12; 
    delay = reinterpret_cast<uint64*>(&delay_in_ps);
    proxy_type::m_packer->init_pack(bits);
    CVRT::do_pack(x_trans,*proxy_type::m_packer);
#ifdef UVMC23_ADDITIONS // {
    proxy_type::m_packer->uvmc_owns_trans(0);
#endif // } UVMC23_ADDITIONS
    svSetScope(uvmc_pkg_scope);
    return result;
  }

  virtual bool get_direct_mem_ptr(typename TYPES::tlm_payload_type &trans,
                                  tlm::tlm_dmi& dmi_data) {
    //cout << "UVMC WARN: get_direct_mem_ptr not implemented in SV" << endl;
    return false;
  }

  virtual unsigned int transport_dbg(typename TYPES::tlm_payload_type &trans) {
    //cout << "UVMC WARN: transport_dbg not implemented in SV" << endl;
    return -1;
  }

  virtual void invalidate_direct_mem_ptr(sc_dt::uint64 start_range,
                                         sc_dt::uint64 end_range) {
    //cout << "UVMC WARN: invalidate_direct_mem_ptr not implemented in SV" << endl;
  }

#ifdef UVMC23_ADDITIONS // {
  protected:
    virtual void sc2sc_b_transport(
        typename TYPES::tlm_payload_type &trans, sc_time &delay )
    { (*m_peer_sc_target_proxy)->b_transport( trans, delay ); }

    virtual tlm::tlm_sync_enum sc2sc_nb_transport_fw(
        typename TYPES::tlm_payload_type &trans,
        typename TYPES::tlm_phase_type &phase, sc_time &delay )
    {   return (*m_peer_sc_target_proxy)->nb_transport_fw(
            trans, phase, delay ); }
#endif // } UVMC23_ADDITIONS

};


} // namespace uvmc

#endif // UVMC_CHANNELS_H
