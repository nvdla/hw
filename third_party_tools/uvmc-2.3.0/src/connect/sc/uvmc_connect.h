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

#ifndef UVMC_CONNECT_H
#define UVMC_CONNECT_H

#include <string>
#include <systemc.h>
#include <tlm.h>

using std::string;
using namespace tlm;
using sc_core::sc_port;
using sc_core::sc_export;


#include "uvmc_common.h"
#include "uvmc_channels.h"
#include "uvmc_ports.h"

//------------------------------------------------------------------------------
//
// Title- uvmc_connect
//
//------------------------------------------------------------------------------
//

//------------------------------------------------------------------------------
//
// Function- SV2C_resolve_binding
//
//------------------------------------------------------------------------------
//
// SV channel -> SC port:
//
// We're mapping to an UVM export or imp, i.e. trying to bind one of our
// uvmc_*_ports. We need to send back the id of the matching SC-side port.
// During runtime, the SV channel will provide this id to identify the port
// it is driving.
//
// SV port -> SC channel:
//
// We're mapping to an SV port, i.e. trying to bind to one of our uvmc_channels.
// The selected channel's target id is set to the id of the SV port. The channel
// will use this target id as the port identifier when communicating to the SV
// side.
//
// When name-based SC port lookup is possible, so are other connection methods...
// TODO? read from side-file
// TODO? parse command line
//------------------------------------------------------------------------------


extern "C"
int SV2C_resolve_binding (
       const char *sv_port_name,  // port name to use when looking for a match
       const char *sv_target,     // alternate name to look for match
       const char *sv_trans_type, // transaction type for checking compatibility
       int         dummy,
       int         sv_proxy_kind, // port type for checking compatibility
       int         sv_mask,       // mask for checking compatibility
       int         sv_id,
       int *       sc_id);

extern "C"
int uvmc_read_connections_file(const string filename="uvmc_connections.txt");


namespace uvmc {


//------------------------------------------------------------------------------
//
// Functions- uvmc_connect
//
// Template functions for transparent instantiation of port and channel proxies.
// Overloaded for each of the possible TLM ports, exports, interfaces, and
// sockets.
//
// Usage:
//
//| uvmc_connect(consumer.in);       // registers "consumer.in" for lookup
//| uvmc_connect(consumer.in,"foo"); // registers both "consumer.in" and "foo"
//
// Without template functions, user would have to allocate and bind a
// proxy manually:
//
// uvmc_blocking_put_port<mytrans> port(consumer.in.name(),"foo",TLM_B_PUT_MASK);
// port.bind(consumer.in);
//
//
// Proxies are allocated on the heap and are not deleted. They persist throughout
// simulation so should not leak any memory.
//
// Interfaces don't have context (names) associated with them.  Therefore, you
// *must* provide a "lookup string" name to provide a context.
// Could also add support for binding to prim_channel or channel, which do have
// instance names, but this would entail another parameter on all the TLM
// interface types. 
//
// Possibly save the pointers created by uvmc_connect for later destruction?
//  vector<sc_port_b& > m_x_port_list;
//  vector<uvmc_tlm_proxy& > m_x_proxy_list;

//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//
// UVMC_CONNECT_PORT (TLM1)
//
// For registering SC-side channels/interface implementations via their
// exports
//
//------------------------------------------------------------------------------

#define UVMC_CONNECT_PORT(IF_TYPE,MASK) \
\
template<typename T, \
         int N, \
         sc_port_policy POL> \
uvmc_tlm1_channel_proxy<T>& \
uvmc_connect(sc_port<tlm_##IF_TYPE##_if<T>,N,POL>&port, \
                     std::string lookup="", \
                     uvmc_packer *packer=NULL) { \
  uvmc_tlm1_channel_proxy<T>* channel_proxy; \
  channel_proxy = new uvmc_tlm1_channel_proxy<T>(port.name(),lookup, \
                                                 MASK,packer); \
  port.bind(*channel_proxy); \
  return (*channel_proxy); \
} \
\
template<typename CVRT,\
         typename T, \
         int N, \
         sc_port_policy POL> \
uvmc_tlm1_channel_proxy<T,CVRT>& \
uvmc_connect(sc_port<tlm_##IF_TYPE##_if<T>,N,POL>&port, \
                     std::string lookup="", \
                     uvmc_packer *packer=NULL) { \
  uvmc_tlm1_channel_proxy<T,CVRT>* channel_proxy; \
  channel_proxy = new uvmc_tlm1_channel_proxy<T,CVRT>(port.name(), \
                                                      lookup,MASK,packer); \
  port.bind(*channel_proxy); \
  return (*channel_proxy); \
} \
\
template<typename T, \
         int N,\
         sc_port_policy POL> \
uvmc_##IF_TYPE##_port<T>& \
uvmc_connect_hier(sc_port<tlm_##IF_TYPE##_if<T>,N,POL>&port, \
                  std::string lookup="", \
                  uvmc_packer *packer=NULL, \
                  unsigned int stack_size=0) { \
  uvmc_##IF_TYPE##_port<T>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T>(port.name(),lookup,packer,stack_size); \
  port_proxy->bind(port); \
  return (*port_proxy); \
} \
\
template<typename CVRT,\
         typename T, \
         int N,\
         sc_port_policy POL> \
uvmc_##IF_TYPE##_port<T,CVRT>& \
uvmc_connect_hier(sc_port<tlm_##IF_TYPE##_if<T>,N,POL>&port, \
                  std::string lookup="", \
                  uvmc_packer *packer=NULL, \
                  unsigned int stack_size=0) { \
  uvmc_##IF_TYPE##_port<T,CVRT>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T,CVRT>(port.name(),lookup,packer,stack_size); \
  port_proxy->bind(port); \
  return (*port_proxy); \
}


#define UVMC_CONNECT_BIDIR_PORT(IF_TYPE,MASK) \
\
template<typename REQ, \
         typename RSP, \
         int N, \
         sc_port_policy POL> \
uvmc_tlm1_channel_proxy<REQ,RSP>& \
uvmc_connect(sc_port<tlm_##IF_TYPE##_if<REQ,RSP>,N,POL>&port, \
             string lookup="",\
             uvmc_packer *packer=NULL) { \
  uvmc_tlm1_channel_proxy<REQ,RSP>* channel_proxy; \
  channel_proxy = new uvmc_tlm1_channel_proxy<REQ,RSP>(port.name(), \
                                                      lookup,MASK,packer); \
  port.bind(*channel_proxy); \
  return (*channel_proxy); \
} \
\
template<typename CVRT_REQ,\
         typename CVRT_RSP, \
         typename REQ,\
         typename RSP, \
         int N, \
         sc_port_policy POL > \
uvmc_tlm1_channel_proxy<REQ,RSP,CVRT_REQ,CVRT_RSP>& \
uvmc_connect(sc_port<tlm_##IF_TYPE##_if<REQ,RSP>,N,POL>&port, \
             string lookup="", \
             uvmc_packer *packer=NULL) { \
  uvmc_tlm1_channel_proxy<REQ,RSP,CVRT_REQ,CVRT_RSP>* channel_proxy; \
  channel_proxy = new uvmc_tlm1_channel_proxy<REQ,RSP,CVRT_REQ,CVRT_RSP> \
                      (port.name(),lookup,MASK,packer); \
  port.bind(*channel_proxy); \
  return (*channel_proxy); \
} \
\
template<typename REQ, \
         typename RSP, \
         int N, \
         sc_port_policy POL> \
uvmc_##IF_TYPE##_port<REQ,RSP>& \
uvmc_connect_hier(sc_port<tlm_##IF_TYPE##_if<REQ,RSP>,N,POL>&port, \
                  string lookup="", \
                  uvmc_packer *packer=NULL, \
                  unsigned int stack_size=0) { \
  uvmc_##IF_TYPE##_port<REQ,RSP>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<REQ,RSP>(port.name(),\
                                                  lookup,packer,stack_size); \
  port_proxy->bind(port); \
  return (*port_proxy); \
} \
\
template<typename CVRT_REQ, \
         typename CVRT_RSP, \
         typename REQ, \
         typename RSP, \
         int N, \
         sc_port_policy POL > \
uvmc_##IF_TYPE##_port<REQ,RSP,CVRT_REQ,CVRT_RSP>& \
uvmc_connect_hier(sc_port<tlm_##IF_TYPE##_if<REQ,RSP>,N,POL>&port, \
                  string lookup="", \
                  uvmc_packer *packer=NULL, \
                  unsigned int stack_size=0) { \
  uvmc_##IF_TYPE##_port<REQ,RSP,CVRT_REQ,CVRT_RSP>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<REQ,RSP,CVRT_REQ,CVRT_RSP>\
                  (port.name(), lookup,packer,stack_size); \
  port_proxy->bind(port); \
  return (*port_proxy); \
}

UVMC_CONNECT_PORT(blocking_put,TLM_B_PUT_MASK)
UVMC_CONNECT_PORT(nonblocking_put,TLM_NB_PUT_MASK)
UVMC_CONNECT_PORT(put,TLM_PUT_MASK)
UVMC_CONNECT_PORT(blocking_get,TLM_B_GET_MASK)
UVMC_CONNECT_PORT(nonblocking_get,TLM_NB_GET_MASK)
UVMC_CONNECT_PORT(get,TLM_GET_MASK)
UVMC_CONNECT_PORT(blocking_peek,TLM_B_PEEK_MASK)
UVMC_CONNECT_PORT(nonblocking_peek,TLM_NB_PEEK_MASK)
UVMC_CONNECT_PORT(peek,TLM_PEEK_MASK)
UVMC_CONNECT_PORT(blocking_get_peek,TLM_B_GET_PEEK_MASK)
UVMC_CONNECT_PORT(nonblocking_get_peek,TLM_NB_GET_PEEK_MASK)
UVMC_CONNECT_PORT(get_peek,TLM_GET_PEEK_MASK)


UVMC_CONNECT_BIDIR_PORT(blocking_master,TLM_B_MASTER_MASK)
UVMC_CONNECT_BIDIR_PORT(nonblocking_master,TLM_NB_MASTER_MASK)
UVMC_CONNECT_BIDIR_PORT(master,TLM_MASTER_MASK)
UVMC_CONNECT_BIDIR_PORT(blocking_slave,TLM_B_SLAVE_MASK)
UVMC_CONNECT_BIDIR_PORT(nonblocking_slave,TLM_NB_SLAVE_MASK)
UVMC_CONNECT_BIDIR_PORT(slave,TLM_SLAVE_MASK)
UVMC_CONNECT_BIDIR_PORT(transport,TLM_TRANSPORT_MASK)


//------------------------------------------------------------------------------
//
// UVMC_CONNECT_EXPORT (TLM1)
//
//------------------------------------------------------------------------------
//
// For connecting to SC-side channels/interface implementations via their
// exports
//
// uvmc_connect(sc_port<IF>, string) is already defined for connecting to
// uvmc_channels.
//
// we don't use sc_export's implicit conversion to IF&; instead, we define
// explicit x_connect methods for sc_export so that its name can be used for
// lookup and debug purposes.
//
// TODO: change args to const
//
// need export to resolve before implicit conversion to IF& ?!
//------------------------------------------------------------------------------

#define UVMC_CONNECT_EXPORT(IF_TYPE,MASK) \
\
template<typename T> \
uvmc_##IF_TYPE##_port<T>& \
uvmc_connect(sc_export<tlm_##IF_TYPE##_if<T> > &xport, \
             string lookup="", \
             uvmc_packer *packer=NULL, \
             unsigned int stack_size=0) { \
    uvmc_##IF_TYPE##_port<T>* port_proxy; \
    port_proxy = new uvmc_##IF_TYPE##_port<T>(xport.name(),lookup,packer,stack_size); \
    port_proxy->bind(xport); \
    return (*port_proxy); \
} \
\
template<class CVRT, \
         typename T> \
uvmc_##IF_TYPE##_port<T,CVRT>& \
uvmc_connect(sc_export<tlm_##IF_TYPE##_if<T> > &xport,\
             string lookup="", \
             uvmc_packer *packer=NULL, \
             unsigned int stack_size=0) { \
    uvmc_##IF_TYPE##_port<T,CVRT>* port_proxy; \
    port_proxy = new uvmc_##IF_TYPE##_port<T,CVRT>(xport.name(), \
                                                   lookup,packer,stack_size); \
    port_proxy->bind(xport); \
    return (*port_proxy); \
} \
\
template<typename T> \
uvmc_tlm1_channel_proxy<T>& \
uvmc_connect_hier(sc_export<tlm_##IF_TYPE##_if<T> > &xport, \
                  string lookup="", \
                  uvmc_packer *packer=NULL) { \
    uvmc_tlm1_channel_proxy<T>* channel_proxy; \
    channel_proxy = new uvmc_tlm1_channel_proxy<T>(xport.name(), \
                                                   lookup,MASK,packer); \
    xport.bind(*channel_proxy); \
    return (*channel_proxy); \
} \
\
template<class CVRT, \
         typename T> \
uvmc_tlm1_channel_proxy<T,CVRT>& \
uvmc_connect_hier(sc_export<tlm_##IF_TYPE##_if<T> > &xport,\
                  string lookup="", \
                  uvmc_packer *packer=NULL) { \
    uvmc_tlm1_channel_proxy<T,CVRT>* channel_proxy; \
    channel_proxy = new uvmc_tlm1_channel_proxy<T,CVRT>(xport.name(), \
                                                   lookup,MASK,packer); \
    xport.bind(*channel_proxy); \
    return (*channel_proxy); \
}

#define UVMC_CONNECT_BIDIR_EXPORT(IF_TYPE,MASK) \
\
template<typename REQ,\
         typename RSP> \
uvmc_##IF_TYPE##_port<REQ,RSP>& \
uvmc_connect(sc_export<tlm_##IF_TYPE##_if<REQ,RSP> > &xport, \
             string lookup="", \
             uvmc_packer *packer=NULL, \
             unsigned int stack_size=0) { \
    uvmc_##IF_TYPE##_port<REQ,RSP>* port_proxy; \
    port_proxy = new uvmc_##IF_TYPE##_port<REQ,RSP>(xport.name(), \
                                                   lookup,packer,stack_size); \
    port_proxy->bind(xport); \
    return (*port_proxy); \
} \
\
template<class CVRT_REQ, \
         class CVRT_RSP, \
         typename REQ, \
         typename RSP> \
uvmc_##IF_TYPE##_port<REQ,RSP,CVRT_REQ,CVRT_RSP>& \
uvmc_connect(sc_export<tlm_##IF_TYPE##_if<REQ,RSP> > &xport, \
             string lookup="", \
             uvmc_packer *packer=NULL, \
             unsigned int stack_size=0) { \
    uvmc_##IF_TYPE##_port<REQ,RSP,CVRT_REQ,CVRT_RSP>* port_proxy; \
    port_proxy = new uvmc_##IF_TYPE##_port<REQ,RSP,CVRT_REQ,CVRT_RSP>\
                         (xport.name(), lookup,packer,stack_size); \
    port_proxy->bind(xport); \
    return (*port_proxy); \
} \
\
template<typename REQ,\
         typename RSP> \
uvmc_tlm1_channel_proxy<REQ,RSP>& \
uvmc_connect_hier(sc_export<tlm_##IF_TYPE##_if<REQ,RSP> > &xport, \
                  string lookup="", \
                  uvmc_packer *packer=NULL) { \
    uvmc_tlm1_channel_proxy<REQ,RSP>* channel_proxy; \
    channel_proxy = new uvmc_tlm1_channel_proxy<REQ,RSP>(xport.name(), \
                                                   lookup,MASK,packer); \
    channel_proxy->bind(xport); \
    return (*channel_proxy); \
} \
\
template<class CVRT_REQ, \
         class CVRT_RSP, \
         typename REQ, \
         typename RSP> \
uvmc_tlm1_channel_proxy<REQ,RSP,CVRT_REQ,CVRT_RSP>& \
uvmc_connect_hier(sc_export<tlm_##IF_TYPE##_if<REQ,RSP> > &xport, \
                  string lookup="", \
                  uvmc_packer *packer=NULL) { \
    uvmc_tlm1_channel_proxy<REQ,RSP,CVRT_REQ,CVRT_RSP>* channel_proxy; \
    channel_proxy = new uvmc_tlm1_channel_proxy<REQ,RSP,CVRT_REQ,CVRT_RSP> \
                      (xport.name(),lookup,MASK,packer); \
    channel_proxy->bind(xport); \
    return (*channel_proxy); \
}

UVMC_CONNECT_EXPORT(blocking_put,TLM_B_PUT_MASK)
UVMC_CONNECT_EXPORT(nonblocking_put,TLM_NB_PUT_MASK)
UVMC_CONNECT_EXPORT(put,TLM_PUT_MASK)
UVMC_CONNECT_EXPORT(blocking_get,TLM_B_GET_MASK)
UVMC_CONNECT_EXPORT(nonblocking_get,TLM_NB_GET_MASK)
UVMC_CONNECT_EXPORT(get,TLM_GET_MASK)
UVMC_CONNECT_EXPORT(blocking_peek,TLM_B_PEEK_MASK)
UVMC_CONNECT_EXPORT(nonblocking_peek,TLM_NB_PEEK_MASK)
UVMC_CONNECT_EXPORT(peek,TLM_PEEK_MASK)
UVMC_CONNECT_EXPORT(blocking_get_peek,TLM_B_GET_PEEK_MASK)
UVMC_CONNECT_EXPORT(nonblocking_get_peek,TLM_NB_GET_PEEK_MASK)
UVMC_CONNECT_EXPORT(get_peek,TLM_GET_PEEK_MASK)


UVMC_CONNECT_BIDIR_EXPORT(transport,TLM_TRANSPORT_MASK)
UVMC_CONNECT_BIDIR_EXPORT(blocking_master,TLM_B_MASTER_MASK)
UVMC_CONNECT_BIDIR_EXPORT(nonblocking_master,TLM_NB_MASTER_MASK)
UVMC_CONNECT_BIDIR_EXPORT(master,TLM_MASTER_MASK)
UVMC_CONNECT_BIDIR_EXPORT(blocking_slave,TLM_B_SLAVE_MASK)
UVMC_CONNECT_BIDIR_EXPORT(nonblocking_slave,TLM_NB_SLAVE_MASK)
UVMC_CONNECT_BIDIR_EXPORT(slave,TLM_SLAVE_MASK)



//------------------------------------------------------------------------------
// TLM1 IF
//
//------------------------------------------------------------------------------

#define UVMC_CONNECT_IF(IF_TYPE) \
\
template<typename T> \
uvmc_##IF_TYPE##_port<T>& \
uvmc_connect(tlm::tlm_##IF_TYPE##_if<T> &intf, \
             string lookup="", \
             uvmc_packer *packer=NULL, \
             unsigned int stack_size=0) { \
    uvmc_##IF_TYPE##_port<T>* port_proxy; \
    port_proxy = new uvmc_##IF_TYPE##_port<T>(sc_gen_unique_name(#IF_TYPE "_if"),\
                                              lookup,packer,stack_size); \
    port_proxy->bind(intf); \
    return (*port_proxy); \
} \
\
template<class CVRT, \
         typename T> \
uvmc_##IF_TYPE##_port<T,CVRT>& \
uvmc_connect(tlm::tlm_##IF_TYPE##_if<T> &intf, \
             string lookup="", \
             uvmc_packer *packer=NULL, \
             unsigned int stack_size=0) { \
    uvmc_##IF_TYPE##_port<T,CVRT>* port_proxy; \
    port_proxy = new uvmc_##IF_TYPE##_port<T,CVRT>(sc_gen_unique_name(#IF_TYPE "_if"),\
                                                   lookup,packer,stack_size); \
    port_proxy->bind(intf); \
    return (*port_proxy); \
}

#define UVMC_CONNECT_BIDIR_IF(IF_TYPE) \
\
template<typename REQ, \
         typename RSP> \
uvmc_##IF_TYPE##_port<REQ,RSP>& \
uvmc_connect(tlm_##IF_TYPE##_if<REQ,RSP> &intf, \
             string lookup="", \
             uvmc_packer *packer=NULL, \
             unsigned int stack_size=0) { \
    uvmc_##IF_TYPE##_port<REQ,RSP>* port_proxy; \
    port_proxy = new uvmc_##IF_TYPE##_port<REQ,RSP>(sc_gen_unique_name(#IF_TYPE "_if"),\
                                                    lookup,packer,stack_size); \
    port_proxy->bind(intf); \
    return (*port_proxy); \
} \
\
template<class CVRT_REQ, \
         class CVRT_RSP, \
         typename REQ, \
         typename RSP> \
uvmc_##IF_TYPE##_port<REQ,RSP,CVRT_REQ,CVRT_RSP>& \
uvmc_connect(tlm_##IF_TYPE##_if<REQ,RSP> &intf, \
             string lookup="", \
             uvmc_packer *packer=NULL, \
             unsigned int stack_size=0) { \
    uvmc_##IF_TYPE##_port<REQ,RSP,CVRT_REQ,CVRT_RSP>* port_proxy; \
    port_proxy = new uvmc_##IF_TYPE##_port<REQ,RSP,CVRT_REQ,CVRT_RSP> \
                       (sc_gen_unique_name(#IF_TYPE "_if"),lookup,packer,stack_size); \
    port_proxy->bind(intf); \
    return (*port_proxy); \
}

UVMC_CONNECT_IF(blocking_put)
UVMC_CONNECT_IF(nonblocking_put)
UVMC_CONNECT_IF(put)
UVMC_CONNECT_IF(blocking_get)
UVMC_CONNECT_IF(nonblocking_get)
UVMC_CONNECT_IF(get)
UVMC_CONNECT_IF(blocking_peek)
UVMC_CONNECT_IF(nonblocking_peek)
UVMC_CONNECT_IF(peek)
UVMC_CONNECT_IF(blocking_get_peek)
UVMC_CONNECT_IF(nonblocking_get_peek)
UVMC_CONNECT_IF(get_peek)


UVMC_CONNECT_BIDIR_IF(transport)
UVMC_CONNECT_BIDIR_IF(blocking_master)
UVMC_CONNECT_BIDIR_IF(nonblocking_master)
UVMC_CONNECT_BIDIR_IF(master)
UVMC_CONNECT_BIDIR_IF(blocking_slave)
UVMC_CONNECT_BIDIR_IF(nonblocking_slave)
UVMC_CONNECT_BIDIR_IF(slave)



//------------------------------------------------------------------------------
// TLM2
// ----

// For connecting to SC-side TLM2 b/fw_nb/bw_nb ifs

// Analysis is part of TLM2 proxy to enable passing tlm_generic_protocol over analysis ports.
// The TLM1 base proxy implements the blocking get if, whose proto requires T to have a copy ctor.
// TLM2 generic protocol's copy ctor and assign operator are disabled (private)
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// PORTS (creates UVMC CHANNEL PROXIES)
//------------------------------------------------------------------------------

#define UVMC_CONNECT_TLM2_PORT(IF_TYPE,MASK) \
\
template<class T, int N, sc_port_policy POL> \
uvmc_tlm2_channel_proxy<T,tlm_phase>& \
uvmc_connect(sc_port<tlm_##IF_TYPE##_if<T>,N,POL> &port, \
               string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_tlm2_channel_proxy<T,tlm_phase>* proxy; \
  proxy = new uvmc_tlm2_channel_proxy<T,tlm_phase>(port.name(),\
                                                   lookup,MASK,packer); \
  port.bind(*proxy); \
  return (*proxy); \
} \
\
template<class CVRT, class T, int N, sc_port_policy POL> \
uvmc_tlm2_channel_proxy<T,tlm_phase,CVRT>& \
uvmc_connect(sc_port<tlm_##IF_TYPE##_if<T>,N,POL> &port, \
               string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_tlm2_channel_proxy<T,tlm_phase,CVRT>* proxy; \
  proxy = new uvmc_tlm2_channel_proxy<T,tlm_phase,CVRT>(port.name(),\
                                                   lookup,MASK,packer); \
  port.bind(*proxy); \
  return (*proxy); \
} \
\
template<class T, int N, sc_port_policy POL> \
uvmc_##IF_TYPE##_port<T>& \
uvmc_connect_hier(sc_port<tlm_##IF_TYPE##_if<T>,N,POL> &port, \
                  string lookup="", uvmc_packer *packer=NULL, \
                  unsigned int stack_size=0) { \
  uvmc_##IF_TYPE##_port<T>* proxy; \
  proxy = new uvmc_##IF_TYPE##_port<T>(port.name(),lookup,packer,stack_size); \
  proxy->bind(port); \
  return (*proxy); \
} \
\
template<class CVRT, class T, int N, sc_port_policy POL> \
uvmc_##IF_TYPE##_port<T,CVRT>& \
uvmc_connect_hier(sc_port<tlm_##IF_TYPE##_if<T>,N,POL> &port, \
                  string lookup="", uvmc_packer *packer=NULL, \
                  unsigned int stack_size=0) { \
  uvmc_##IF_TYPE##_port<T,CVRT>* proxy; \
  proxy = new uvmc_##IF_TYPE##_port<T,CVRT>(port.name(),lookup,packer,stack_size); \
  proxy->bind(port); \
  return (*proxy); \
}


#define UVMC_CONNECT_TLM2_NB_PORT(IF_TYPE,MASK) \
\
template<class T, class PH, int N, sc_port_policy POL> \
uvmc_tlm2_channel_proxy<T,PH>& \
uvmc_connect(sc_port<tlm_##IF_TYPE##_if<T,PH>,N,POL> &port, \
               string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_tlm2_channel_proxy<T,PH>* proxy; \
  proxy = new uvmc_tlm2_channel_proxy<T,PH>(port.name(),lookup,MASK,packer); \
  port.bind(*proxy); \
  return (*proxy); \
} \
\
template<class CVRT, class T, class PH, int N, sc_port_policy POL> \
uvmc_tlm2_channel_proxy<T,PH,CVRT>& \
uvmc_connect(sc_port<tlm_##IF_TYPE##_if<T,PH>,N,POL> &port, \
               string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_tlm2_channel_proxy<T,PH,CVRT>* proxy; \
  proxy = new uvmc_tlm2_channel_proxy<T,PH,CVRT>(port.name(),lookup,MASK,packer); \
  port.bind(*proxy); \
  return (*proxy); \
} \
\
template<class T, class PH, int N, sc_port_policy POL> \
uvmc_##IF_TYPE##_port<T,PH>& \
uvmc_connect_hier(sc_port<tlm_##IF_TYPE##_if<T,PH>,N,POL> &port, \
                  string lookup="", uvmc_packer *packer=NULL, \
                  unsigned int stack_size=0) { \
  uvmc_##IF_TYPE##_port<T,PH>* proxy; \
  proxy = new uvmc_##IF_TYPE##_port<T,PH>(port.name(),lookup,packer,stack_size); \
  proxy->bind(port); \
  return (*proxy); \
} \
\
template<class CVRT, class T, class PH, int N, sc_port_policy POL> \
uvmc_##IF_TYPE##_port<T,PH,CVRT>& \
uvmc_connect_hier(sc_port<tlm_##IF_TYPE##_if<T,PH>,N,POL> &port, \
                  string lookup="", uvmc_packer *packer=NULL, \
                  unsigned int stack_size=0) { \
  uvmc_##IF_TYPE##_port<T,PH,CVRT>* proxy; \
  proxy = new uvmc_##IF_TYPE##_port<T,PH,CVRT>(port.name(),lookup,packer,stack_size); \
  proxy->bind(port); \
  return (*proxy); \
}

UVMC_CONNECT_TLM2_PORT(blocking_transport,TLM_B_TRANSPORT_MASK)
UVMC_CONNECT_TLM2_PORT(write,TLM_ANALYSIS_MASK)

UVMC_CONNECT_TLM2_NB_PORT(fw_nonblocking_transport,TLM_FW_NB_TRANSPORT_MASK)
UVMC_CONNECT_TLM2_NB_PORT(bw_nonblocking_transport,TLM_BW_NB_TRANSPORT_MASK)


// TODO: remove--correct usage is to use tlm_analysis_port, not sc_port<tlm_analysis_if>
UVMC_CONNECT_TLM2_PORT(analysis,TLM_ANALYSIS_MASK)

template<class T>
uvmc_tlm2_channel_proxy<T,tlm_phase>&
uvmc_connect(tlm_analysis_port<T> &port,
               string lookup="", uvmc_packer *packer=NULL) {
  uvmc_tlm2_channel_proxy<T,tlm_phase>* proxy;
  proxy = new uvmc_tlm2_channel_proxy<T,tlm_phase>(port.name(),
                                                   lookup,TLM_ANALYSIS_MASK,packer);
  port.bind(*proxy);
  return (*proxy);
}

template<class CVRT, class T>
uvmc_tlm2_channel_proxy<T,tlm_phase,CVRT>&
uvmc_connect(tlm_analysis_port<T> &port,
               string lookup="", uvmc_packer *packer=NULL) {
  uvmc_tlm2_channel_proxy<T,tlm_phase,CVRT>* proxy;
  proxy = new uvmc_tlm2_channel_proxy<T,tlm_phase,CVRT>(port.name(),
                                                   lookup,TLM_ANALYSIS_MASK,packer);
  port.bind(*proxy);
  return (*proxy);
}

template<class T>
uvmc_analysis_port<T>&
uvmc_connect_hier(tlm_analysis_port<T> &port,
                  string lookup="", uvmc_packer *packer=NULL) {
  uvmc_analysis_port<T>* proxy;
  proxy = new uvmc_analysis_port<T>(port.name(),lookup,packer);
  proxy->bind(port);
  return (*proxy);
}

template<class CVRT, class T>
uvmc_analysis_port<T,CVRT>&
uvmc_connect_hier(tlm_analysis_port<T> &port,
                  string lookup="", uvmc_packer *packer=NULL) {
  uvmc_analysis_port<T,CVRT>* proxy;
  proxy = new uvmc_analysis_port<T,CVRT>(port.name(),lookup,packer);
  proxy->bind(port);
  return (*proxy);
}



//------------------------------------------------------------------------------
// EXPORTS
//------------------------------------------------------------------------------

#define UVMC_CONNECT_TLM2_EXPORT(IF_TYPE,MASK) \
\
template<class T> \
uvmc_##IF_TYPE##_port<T>& \
uvmc_connect(sc_export<tlm_##IF_TYPE##_if<T> >&xport, \
               string lookup="", uvmc_packer *packer=NULL, \
               unsigned int stack_size=0) { \
  uvmc_##IF_TYPE##_port<T>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T>(xport.name(),lookup,packer,stack_size); \
  port_proxy->bind(xport); \
  return (*port_proxy); \
} \
\
template<class CVRT, class T> \
uvmc_##IF_TYPE##_port<T,CVRT>& \
uvmc_connect(sc_export<tlm_##IF_TYPE##_if<T> >&xport, \
               string lookup="", uvmc_packer *packer=NULL, \
               unsigned int stack_size=0) { \
  uvmc_##IF_TYPE##_port<T,CVRT>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T,CVRT>(xport.name(),lookup,packer,stack_size); \
  port_proxy->bind(xport); \
  return (*port_proxy); \
} \
\
template<class T> \
uvmc_tlm2_channel_proxy<T,tlm_phase>& \
uvmc_connect_hier(sc_export<tlm_##IF_TYPE##_if<T> > &xport, \
                  string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_tlm2_channel_proxy<T,tlm_phase>* proxy; \
  proxy = new uvmc_tlm2_channel_proxy<T,tlm_phase>(xport.name(),lookup,MASK,packer); \
  xport.bind(*proxy); \
  return (*proxy); \
} \
\
template<class CVRT, class T> \
uvmc_tlm2_channel_proxy<T,tlm_phase,CVRT>& \
uvmc_connect_hier(sc_export<tlm_##IF_TYPE##_if<T> > &xport, \
                  string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_tlm2_channel_proxy<T,tlm_phase,CVRT>* proxy; \
  proxy = new uvmc_tlm2_channel_proxy<T,tlm_phase,CVRT>(xport.name(),lookup,MASK,packer); \
  xport.bind(*proxy); \
  return (*proxy); \
} 


#define UVMC_CONNECT_ANALYSIS_EXPORT(IF_TYPE,MASK) \
\
template<class T> \
uvmc_##IF_TYPE##_port<T>& \
uvmc_connect(sc_export<tlm_##IF_TYPE##_if<T> >&xport, \
               string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_##IF_TYPE##_port<T>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T>(xport.name(),lookup,packer); \
  port_proxy->bind(xport); \
  return (*port_proxy); \
} \
\
template<class CVRT, class T> \
uvmc_##IF_TYPE##_port<T,CVRT>& \
uvmc_connect(sc_export<tlm_##IF_TYPE##_if<T> >&xport, \
               string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_##IF_TYPE##_port<T,CVRT>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T,CVRT>(xport.name(),lookup,packer); \
  port_proxy->bind(xport); \
  return (*port_proxy); \
} \
\
template<class T> \
uvmc_tlm2_channel_proxy<T,tlm_phase>& \
uvmc_connect_hier(sc_export<tlm_##IF_TYPE##_if<T> > &xport, \
                  string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_tlm2_channel_proxy<T,tlm_phase>* proxy; \
  proxy = new uvmc_tlm2_channel_proxy<T,tlm_phase>(xport.name(),lookup,MASK,packer); \
  xport.bind(*proxy); \
  return (*proxy); \
} \
\
template<class CVRT, class T> \
uvmc_tlm2_channel_proxy<T,tlm_phase,CVRT>& \
uvmc_connect_hier(sc_export<tlm_##IF_TYPE##_if<T> > &xport, \
                  string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_tlm2_channel_proxy<T,tlm_phase,CVRT>* proxy; \
  proxy = new uvmc_tlm2_channel_proxy<T,tlm_phase,CVRT>(xport.name(),lookup,MASK,packer); \
  xport.bind(*proxy); \
  return (*proxy); \
}


#define UVMC_CONNECT_TLM2_NB_EXPORT(IF_TYPE,MASK) \
\
template<class T, class PH> \
uvmc_##IF_TYPE##_port<T,PH>& \
uvmc_connect(sc_export<tlm_##IF_TYPE##_if<T,PH> >&xport, \
               string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_##IF_TYPE##_port<T,PH>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T,PH>(xport.name(),lookup,packer); \
  port_proxy->bind(xport); \
  return (*port_proxy); \
} \
\
template<class CVRT, class T, class PH> \
uvmc_##IF_TYPE##_port<T,PH,CVRT>& \
uvmc_connect(sc_export<tlm_##IF_TYPE##_if<T,PH> >&xport, \
               string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_##IF_TYPE##_port<T,PH,CVRT>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T,PH,CVRT>(xport.name(),lookup,packer); \
  port_proxy->bind(xport); \
  return (*port_proxy); \
} \
\
template<class T, class PH> \
uvmc_tlm2_channel_proxy<T,PH>& \
uvmc_connect_hier(sc_export<tlm_##IF_TYPE##_if<T,PH> > &xport, \
               string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_tlm2_channel_proxy<T,PH>* proxy; \
  proxy = new uvmc_tlm2_channel_proxy<T,PH>(xport.name(),lookup,MASK,packer); \
  xport.bind(*proxy); \
  return (*proxy); \
} \
\
template<class CVRT, class T, class PH> \
uvmc_tlm2_channel_proxy<T,PH,CVRT>& \
uvmc_connect_hier(sc_export<tlm_##IF_TYPE##_if<T,PH> > &xport, \
               string lookup="", uvmc_packer *packer=NULL) { \
  uvmc_tlm2_channel_proxy<T,PH,CVRT>* proxy; \
  proxy = new uvmc_tlm2_channel_proxy<T,PH,CVRT>(xport.name(),lookup,MASK,packer); \
  xport.bind(*proxy); \
  return (*proxy); \
} \

UVMC_CONNECT_TLM2_EXPORT(blocking_transport, TLM_B_TRANSPORT_MASK)

UVMC_CONNECT_ANALYSIS_EXPORT(analysis, TLM_ANALYSIS_MASK)
UVMC_CONNECT_ANALYSIS_EXPORT(write, TLM_ANALYSIS_MASK)

UVMC_CONNECT_TLM2_NB_EXPORT(fw_nonblocking_transport, TLM_FW_NB_TRANSPORT_MASK)
UVMC_CONNECT_TLM2_NB_EXPORT(bw_nonblocking_transport, TLM_BW_NB_TRANSPORT_MASK)



//------------------------------------------------------------------------------
// IFS
//------------------------------------------------------------------------------

#define UVMC_CONNECT_TLM2_IF(IF_TYPE) \
\
template<class T> uvmc_##IF_TYPE##_port<T>& \
uvmc_connect(tlm_##IF_TYPE##_if<T>&intf, string lookup="", \
               uvmc_packer *packer=NULL, \
               unsigned int stack_size=0) { \
  uvmc_##IF_TYPE##_port<T>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T>( \
                string(sc_gen_unique_name(#IF_TYPE "_if")),lookup,packer,stack_size); \
  port_proxy->bind(intf); \
  return (*port_proxy); \
} \
\
template<class CVRT, class T> \
uvmc_##IF_TYPE##_port<T,CVRT>& \
uvmc_connect(tlm_##IF_TYPE##_if<T>&intf, string lookup="", \
               uvmc_packer *packer=NULL, \
               unsigned int stack_size=0) { \
  uvmc_##IF_TYPE##_port<T,CVRT>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T,CVRT>( \
                string(sc_gen_unique_name(#IF_TYPE "_if")),lookup,packer,stack_size); \
  port_proxy->bind(intf); \
  return (*port_proxy); \
}

#define UVMC_CONNECT_ANALYSIS_IF(IF_TYPE) \
\
template<class T> uvmc_##IF_TYPE##_port<T>& \
uvmc_connect(tlm_##IF_TYPE##_if<T>&intf, string lookup="", \
               uvmc_packer *packer=NULL) { \
  uvmc_##IF_TYPE##_port<T>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T>( \
                string(sc_gen_unique_name(#IF_TYPE "_if")),lookup,packer); \
  port_proxy->bind(intf); \
  return (*port_proxy); \
} \
\
template<class CVRT, class T> \
uvmc_##IF_TYPE##_port<T,CVRT>& \
uvmc_connect(tlm_##IF_TYPE##_if<T>&intf, string lookup="", \
               uvmc_packer *packer=NULL) { \
  uvmc_##IF_TYPE##_port<T,CVRT>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T,CVRT>( \
                string(sc_gen_unique_name(#IF_TYPE "_if")),lookup,packer); \
  port_proxy->bind(intf); \
  return (*port_proxy); \
}


#define UVMC_CONNECT_TLM2_NB_IF(IF_TYPE) \
\
template<class T, class PH> \
uvmc_##IF_TYPE##_port<T,PH>& \
uvmc_connect(tlm_##IF_TYPE##_if<T,PH>&intf, string lookup="", \
               uvmc_packer *packer=NULL) { \
  uvmc_##IF_TYPE##_port<T,PH>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T,PH>( \
                string(sc_gen_unique_name(#IF_TYPE "_if")),lookup),packer; \
  port_proxy->bind(intf); \
  return (*port_proxy); \
} \
\
template<class CVRT, class T, class PH> \
uvmc_##IF_TYPE##_port<T,PH,CVRT>& \
uvmc_connect(tlm_##IF_TYPE##_if<T,PH>&intf, string lookup="", \
               uvmc_packer *packer=NULL) { \
  uvmc_##IF_TYPE##_port<T,PH,CVRT>* port_proxy; \
  port_proxy = new uvmc_##IF_TYPE##_port<T,PH,CVRT>( \
                string(sc_gen_unique_name(#IF_TYPE "_if")),lookup),packer; \
  port_proxy->bind(intf); \
  return (*port_proxy); \
}

UVMC_CONNECT_TLM2_IF(blocking_transport)
UVMC_CONNECT_ANALYSIS_IF(analysis)
UVMC_CONNECT_ANALYSIS_IF(write)

UVMC_CONNECT_TLM2_NB_IF(fw_nonblocking_transport)
UVMC_CONNECT_TLM2_NB_IF(bw_nonblocking_transport)



//------------------------------------------------------------------------------
// SOCKETS
//------------------------------------------------------------------------------

#ifdef UVMC23_ADDITIONS // {
// For sockets we first attempt mutual discovery of SC ports/exports with the
// same lookupid. In this case we bind them directly to each other to support
// SC <-> SC UVM-Connect'ions.
//
// The beauty of this is that there is 0 overhead associated with packers
// in this case because the transaction data types are passed straight
// through by reference. Yet we provide a really simple name string based
// binding mechanism (as per the simple uvmc_connect() API usage) as an
// alternative mechanism to bind SC TLM ports/exports to each other. This also
// makes for interchangeable code for connecting to SC ports to either local
// SC peers, SV-UVM peers, XLerated peers, or remote IPC peers, with absolutely
// no code modifications. Only the lookup string identifies the peer endpoint
// of the connection. This maximizes model reuse for a variety of TLM fabric
// connection types.
// 
// Note that the CHANNEL and PORT mutual discoveries can rendezvous in
// either order. If a CHANNEL sees a PORT has already been registered, it
// binds. Otherwise it does nothing. And vice versa. So the binding itself
// will only occur when the 2nd connection discovers the first.
#endif // } UVMC23_ADDITIONS
//------------------------------------------------------------------------------

// initiator->target proxy
template<unsigned int BUSWIDTH,
         class TYPES,
         int N,
         sc_port_policy POL>
        uvmc_target_socket<BUSWIDTH,TYPES>&
uvmc_connect(tlm_initiator_socket<BUSWIDTH,TYPES,N,POL> &initiator,
               std::string lookup="",
               uvmc_packer *packer=NULL)
{
  uvmc_target_socket<BUSWIDTH,TYPES>* proxy;
  proxy = new uvmc_target_socket<BUSWIDTH,TYPES>
                (initiator.name(),lookup,packer);
  initiator.bind( *(proxy->m_target_skt) ); // bind target proxy to initiator socket
#ifdef UVMC23_ADDITIONS // {
    // See "mutual discovery" comments above. Here we attempt to see if an SC
    // target socket has already registered itself. If so, we bind to it
    // directly for the special case of SC <-> SC UVM-Connect'ions.
    uvmc_initiator_socket<BUSWIDTH,TYPES>* match;
    if( (match=static_cast<
        uvmc_initiator_socket<BUSWIDTH,TYPES> * >
            (uvmc_proxy_base::find_sc_peer_port_matching_lookupid(
                lookup.c_str() ))) != NULL ){
        proxy->set_peer_sc_target_proxy_socket( &match->m_init_skt );
        match->set_peer_sc_initiator_proxy_socket( proxy->m_target_skt );
    }
#endif // } UVMC23_ADDITIONS
  return (*proxy);
}

// initiator proxy->initiator (hierarchical bind)
template<unsigned int BUSWIDTH,
         class TYPES,
         int N,
         sc_port_policy POL>
        uvmc_initiator_socket<BUSWIDTH,TYPES>&
uvmc_connect_hier(tlm_initiator_socket<BUSWIDTH,TYPES,N,POL> &initiator,
                    std::string lookup="",
                    uvmc_packer *packer=NULL,
                    unsigned int stack_size=0)
{
  uvmc_initiator_socket<BUSWIDTH,TYPES>* proxy;
  proxy = new uvmc_initiator_socket<BUSWIDTH,TYPES>
                (initiator.name(),lookup,packer,stack_size);
  proxy->m_init_skt.bind( initiator );
  return (*proxy);
}

// initiator proxy->target 
template<unsigned int BUSWIDTH,
         class TYPES,
         int N,
         sc_port_policy POL>
        uvmc_initiator_socket<BUSWIDTH,TYPES>&
uvmc_connect(tlm_target_socket<BUSWIDTH,TYPES,N,POL> &target,
               std::string lookup="",
               uvmc_packer *packer=NULL,
               unsigned int stack_size=0)
{
  uvmc_initiator_socket<BUSWIDTH,TYPES>* proxy;
  proxy = new uvmc_initiator_socket<BUSWIDTH,TYPES>
                   (target.name(),lookup,packer,stack_size);
  proxy->m_init_skt.bind( target );
#ifdef UVMC23_ADDITIONS // {
    // See "mutual discovery" comments above. Here we attempt to see if an SC
    // target socket has already registered itself. If so, we bind to it
    // directly for the special case of SC <-> SC UVM-Connect'ions.
    uvmc_target_socket<BUSWIDTH,TYPES>* match;
    if( (match=static_cast<
        uvmc_target_socket<BUSWIDTH,TYPES> * >
            (uvmc_proxy_base::find_sc_peer_channel_matching_lookupid(
                lookup.c_str() ))) != NULL ){
        match->set_peer_sc_target_proxy_socket( &proxy->m_init_skt );
        proxy->set_peer_sc_initiator_proxy_socket( match->m_target_skt );  
    }
#endif // } UVMC23_ADDITIONS
  return (*proxy);
}

// target proxy->target (hierarchical bind)
template<unsigned int BUSWIDTH,
         class TYPES,
         int N,
         sc_port_policy POL>
       uvmc_target_socket<BUSWIDTH,TYPES>&
uvmc_connect_hier(tlm_target_socket<BUSWIDTH,TYPES,N,POL> &target,
                    std::string lookup="",
                    uvmc_packer *packer=NULL)
{
  uvmc_target_socket<BUSWIDTH,TYPES>* proxy;
  proxy = new uvmc_target_socket<BUSWIDTH,TYPES>
                   (target.name(),lookup,packer);
  target.bind( *(proxy->m_target_skt) );
  return (*proxy);
}


// with converters

// initiator->target proxy
template<class CVRT,
         unsigned int BUSWIDTH,
         class TYPES,
         int N,
         sc_port_policy POL>
      uvmc_target_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>&
uvmc_connect(tlm_initiator_socket<BUSWIDTH,TYPES,N,POL> &initiator,
               std::string lookup="",
               uvmc_packer *packer=NULL)
{
  uvmc_target_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>* proxy;
  proxy = new uvmc_target_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>
                   (initiator.name(),lookup,packer);
  // bind target proxy to initiator socket
  initiator.bind( *(proxy->m_target_skt) );
#ifdef UVMC23_ADDITIONS // {
    // See "mutual discovery" comments above. Here we attempt to see if an SC
    // initiator socket has already registered itself. If so, we bind to it
    // directly for the special case of SC <-> SC UVM-Connect'ions.
    uvmc_initiator_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>* match;
    if( (match=static_cast<
        uvmc_initiator_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT> * >
            (uvmc_proxy_base::find_sc_peer_port_matching_lookupid(
                lookup.c_str() ))) != NULL ){
        proxy->set_peer_sc_target_proxy_socket( &match->m_init_skt );
        match->set_peer_sc_initiator_proxy_socket( proxy->m_target_skt );
    }
#endif // } UVMC23_ADDITIONS
  return (*proxy);
}

// initiator proxy->initiator (hierarchical bind)
template<class CVRT,
         unsigned int BUSWIDTH,
         class TYPES,
         int N,
         sc_port_policy POL>
        uvmc_initiator_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>&
uvmc_connect_hier(tlm_initiator_socket<BUSWIDTH,TYPES,N,POL> &initiator,
                    std::string lookup="",
                    uvmc_packer *packer=NULL,
                    unsigned int stack_size=0)
{
  uvmc_initiator_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>* proxy;
  proxy = new uvmc_initiator_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>
                   (initiator.name(),lookup,packer,stack_size);
  proxy->m_init_skt.bind( initiator );
  return (*proxy);
}

// initiator proxy->target 
template<class CVRT,
         unsigned int BUSWIDTH,
         class TYPES,
         int N,
         sc_port_policy POL>
        uvmc_initiator_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>&
uvmc_connect(tlm_target_socket<BUSWIDTH,TYPES,N,POL> &target,
               std::string lookup="",
               uvmc_packer *packer=NULL,
               unsigned int stack_size=0)
{
  uvmc_initiator_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>* proxy;
  proxy = new uvmc_initiator_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>
                   (target.name(),lookup,packer,stack_size);
  proxy->m_init_skt.bind( target );
#ifdef UVMC23_ADDITIONS // {
    // See "mutual discovery" comments above. Here we attempt to see if an SC
    // target socket has already registered itself. If so, we bind to it
    // directly for the special case of SC <-> SC UVM-Connect'ions.
    uvmc_target_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>* match;
    if( (match=static_cast<
        uvmc_target_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT> * >
            (uvmc_proxy_base::find_sc_peer_channel_matching_lookupid(
                lookup.c_str() ))) != NULL ){
        match->set_peer_sc_target_proxy_socket( &proxy->m_init_skt );
        proxy->set_peer_sc_initiator_proxy_socket( match->m_target_skt );  
    }
#endif // } UVMC23_ADDITIONS
  return (*proxy);
}

// target proxy->target (hierarchical bind)
template<class CVRT,
         unsigned int BUSWIDTH,
         class TYPES,
         int N,
         sc_port_policy POL>
        uvmc_target_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>&
uvmc_connect_hier(tlm_target_socket<BUSWIDTH,TYPES,N,POL> &target,
                    std::string lookup="",
                    uvmc_packer *packer=NULL)
{
  uvmc_target_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>* proxy;
  proxy = new uvmc_target_socket<BUSWIDTH,TYPES,1,SC_ONE_OR_MORE_BOUND,CVRT>
                   (target.name(),lookup,packer);
  target.bind( *(proxy->m_target_skt) );
  return (*proxy);
}


}; // namespace uvmc


#endif // UVMC_CONNECT_H
