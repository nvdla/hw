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

#include "uvmc_common.h"


void * uvmc_pkg_scope = NULL; // set by SV2C_resolve_bindings 

unsigned int uvm_major = 0;
unsigned int uvm_minor = 0;
string       uvm_fix = "";
bool         uvmc_uvm_version_is_pre11b = 0;
unsigned int uvmc_default_stack_size = 1 * 1024 * 1024; // 1M

namespace uvmc {

bool uvmc_wait_for_run_phase = 0;

class uvmc_proxy_base;

// uvmc_legal_path

string uvmc_legal_path(const string path) {
  string str(path);
  for (unsigned int i=0; i<str.length(); i++) {
    if (str[i] == '/' || str[i] == '.')
      str[i] = '_';
  }
  return str;
}


// uvmc_mask_to_string

const char* uvmc_mask_to_string(const int mask) {
  switch(mask) {
    case TLM_B_PUT_MASK        : return "tlm_blocking_put-or-tlm_fw_nonblocking_transport(tlm2)";
    case TLM_NB_PUT_MASK       : return "tlm_nonblocking_put";
    case TLM_PUT_MASK          : return "tlm_put";

    case TLM_B_GET_MASK        : return "tlm_blocking_get-or-tlm_bw_nonblocking_transport(tlm2)";
    case TLM_NB_GET_MASK       : return "tlm_nonblocking_get";
    case TLM_GET_MASK          : return "tlm_get";

    case TLM_B_PEEK_MASK       : return "tlm_blocking_peek-or-tlm_blocking_transport(tlm2)";
    case TLM_NB_PEEK_MASK      : return "tlm_nonblocking_peek";
    case TLM_PEEK_MASK         : return "tlm_peek";

    case TLM_ANALYSIS_MASK     : return "tlm_analysis";

    //case TLM_B_TRANSPORT_MASK  : return "tlm_blocking_transport";
    //case TLM_NB_TRANSPORT_MASK : return "tlm_nonblocking_transport";
    case TLM_TRANSPORT_MASK    : return "tlm_transport";

    case TLM_B_GET_PEEK_MASK   : return "tlm_blocking_get_peek";
    case TLM_NB_GET_PEEK_MASK  : return "tlm_nonblocking_get_peek";
    case TLM_GET_PEEK_MASK     : return "tlm_get_peek";

    case TLM_B_MASTER_MASK     : return "tlm_blocking_master";
    case TLM_NB_MASTER_MASK    : return "tlm_nonblocking_master";
    case TLM_MASTER_MASK       : return "tlm_master";

    case TLM_B_SLAVE_MASK      : return "tlm_blocking_slave";
    case TLM_NB_SLAVE_MASK     : return "tlm_nonblocking_slave";
    case TLM_SLAVE_MASK        : return "tlm_slave";


    default: return "<unknown>";

  }
}

//uvmc_proxy_module uvmc_proxy_mod("uvmc_proxy_module");
//uvmc_proxy_module::uvmc_proxy_module(sc_module_name nm) : sc_module(nm) { }

uvmc_registry::uvmc_registry(sc_module_name nm) {
}


uvmc_registry::~uvmc_registry() {
  delete m_inst;
}

uvmc_registry *uvmc_registry::m_inst = 0;


uvmc_registry& uvmc_registry::get() {
  if (m_inst == NULL)
    m_inst = new uvmc_registry("uvmc_registry");
  return (*m_inst);

}

void uvmc_registry::add(uvmc_proxy_base &proxy) {
  // TBD: push provided proxy to internal queue for possible debug and
  // perhaps deletion in destructor
}


//------------------------------------------------------------------------------
//
// CLASS- uvmc_proxy_base
//
//------------------------------------------------------------------------------


// c'tor
// -----

uvmc_proxy_base::uvmc_proxy_base(const string name, const string lookup,
                                 const int mask, uvmc_packer *packer,
                                 int proxy_kind) :
         m_name(/*uvmc_legal_path(*/name/*)*/), m_id(-1), m_mask(mask),
         m_x_id(0), m_packer(packer), m_connected(0)/*, m_gp_cache(0)*/
#ifdef UVMC23_ADDITIONS // {
      , m_use_peer_sc_proxy(false),
        m_proxy_names( proxy_kind==UVM_PORT ? m_port_names : m_channel_names )
#endif // } UVMC23_ADDITIONS
{

    if (m_proxies.size()==0) // avoid a '0' id
      m_proxies.push_back(NULL);

    int id(m_proxies.size());

    map<string,int>::iterator iter;

    cout << "Connecting an SC-side proxy "
         << (proxy_kind == UVM_PORT ? "port" : "chan")
         //<< " (mask=" << mask << ")"
         << " for '" << m_name << "'"
         << " with lookup string '" << lookup << "'"
         << " for later connection with SV" << endl;


    iter = m_proxy_names.find(m_name);
    if (iter != m_proxy_names.end()) {
      int local_id = (*iter).second;
      uvmc_proxy_base* exist_chan = m_proxies[local_id];
      if (exist_chan->m_x_id != 0) {
        uvmc_proxy_base *bound_chan = m_proxies[exist_chan->m_x_id];
        cerr << "UVMC-Error: port/proxy with name '"
             << exist_chan->name() << "' is already bound to"
             << bound_chan->name() << endl;
        return;
      }
      cout << "Warning-UVMC: Making local connection between existing '" 
           << exist_chan->name() << "' and '" << m_name << "'" << endl;
      m_locally_connected = 1;
      m_x_id = local_id;
      m_proxies.push_back(this);
      m_proxy_names[m_name] = id;
      exist_chan->m_x_id = id;
      exist_chan->m_locally_connected = 1;
      return;
    }

    if (lookup.length() != 0) {
      iter = m_proxy_names.find(lookup);
      if (iter != m_proxy_names.end()) {
        int local_id = (*iter).second;
        uvmc_proxy_base* exist_chan = m_proxies[local_id];
        if (exist_chan->m_x_id != 0) {
          uvmc_proxy_base *bound_chan = m_proxies[exist_chan->m_x_id];
          cerr << "UVMC-Error: port or channel with name '"
               << exist_chan->name() << "' is already bound to '"
               << bound_chan->name() << "' using lookup name '" << lookup << "'" << endl;
          return;
        }
        cout << "Warning-UVMC: Making local connection between existing '" 
             << exist_chan->name() << "' and '"
             << m_name << "' using lookup string '" << lookup << "'" << endl;
        m_locally_connected = 1;
        m_x_id = local_id;
        m_proxies.push_back(this);
        m_proxy_names[m_name] = id;
        exist_chan->m_x_id = id;
        exist_chan->m_locally_connected = 1;
        return;
      }
      m_proxy_names[lookup] = id;
    }

    m_id = id;
    m_kind = proxy_kind;
    m_proxy_names[m_name] = id;
    m_proxies.push_back(this);


    if (m_packer!=NULL) {
      m_i_own_packer = 0;
    }
    else {
      m_i_own_packer = 1;
      m_packer = new uvmc_packer();
    }

    // Because we are a port, we must be a child of a module. Normally ports are created
    // from within the c'tor of their parent module. However, we want all proxies to be
    // children of a single module that does directly instantiated its ports. We use a
    // backdoor path to the simcontext registry to do this. The OSCI reference simulator
    // appears to provide public access, so this seems reasonably safe to do.
    //
    // We push our uvmc_registry module to be the current module into which our
    // port will be a child. We can do so here because uvmc_port_base c'tor is called
    // before sc_port's c'tor, which is were port registration occurs. Later, in each
    // concrete uvmc_port proxy class c'tor, we pop the uvmc_registry off the hierarchy
    // queue.
    sc_core::sc_get_curr_simcontext()->hierarchy_push(&uvmc_registry::get());

 }


// d'tor
// -----

uvmc_proxy_base::~uvmc_proxy_base() {
  for (unsigned int i=0; i < m_proxies.size(); i++) {
    //cout << "***** DESTROYING UVMC CHANNEL " << i
    //     << " name=" << m_proxies[i]->name() << endl;
    delete m_proxies[i];
  }
  if (m_i_own_packer)
    delete m_packer;
  //if (m_gp_cache)
  //  delete m_gp_cache;
}


/*
// register_nb
// -----------

void uvmc_proxy_base::register_nb() { }


// register_b
// ----------

void uvmc_proxy_base::register_b() { }
*/




// notify_connected
// ----------------

void uvmc_proxy_base::notify_connected() {
  m_connected = 1;
  m_connected_event.notify();
}


// wait_connected
// --------------

void uvmc_proxy_base::wait_connected() {
  sc_process_handle proc_h = sc_get_current_process_handle();
  /*
  if (proc_h.proc_kind() == SC_METHOD_PROC_) {
    return;
  }
  else {
  */
    /*
    if (uvmc_wait_for_run_phase) {
      svSetScope(uvmc_pkg_scope);
      uvmc_wait_for_phase("run",UVM_PHASE_STARTED,UVM_GTE);
      if (!m_connected)
        cout << "UVMC-Error: Port '" << name()
             << "' not connected to SV side, yet reached run phase." << endl;
    }
    */
    if (m_connected==0) {
      ::wait(m_connected_event);
    }
  //}
}


// resolve
// -------

bool uvmc_proxy_base::resolve(const string   sv_name,
                                const string sv_lookup,
                                const int    sv_mask,
                                const string sv_type_name,
                                const int    sv_id,
                                int          sv_proxy_kind, 
                                int *        sc_id)
{
  map<string,int>::const_iterator iter;
  uvmc_proxy_base *proxy;
  int id;

#ifdef UVMC23_ADDITIONS // {
  map<string,int> &m_proxy_names
    = (sv_proxy_kind == UVM_PORT) ? m_channel_names : m_port_names;
#endif // } UVMC23_ADDITIONS

  //cout << "uvmc_proxy_base::resolve - " <<
  //        "sv_name=" << sv_name << " sc_lookup=" << sv_lookup <<
  //        " sv_mask=" << sv_mask << " sv_type_name=" << sv_type_name <<
  //        " sv_id=" << sv_id << " sv_proxy_kind=" << sv_proxy_kind << endl;

  iter = m_proxy_names.find(sv_name);
  if (iter != m_proxy_names.end()) {
    id = (*iter).second;
  }
  else {
    iter = m_proxy_names.find(sv_lookup);
    if (iter != m_proxy_names.end()) {
      id = (*iter).second;
    }
    else {
      cout << "UVMC-Error: No SC-side port/export/interface registered with name="
           << sv_name << " or lookup=" << sv_lookup <<  ". (sv_mask="
           << hex << sv_mask << dec << " sv_id=" << sv_id << ")" << endl;
      map<string,int>::const_iterator last = m_proxy_names.end(); 
      cout << "  Registered SC-side UVMC proxies are:" << endl;
      for (map<string,int>::const_iterator it = m_proxy_names.begin();
           it != last; ++it)
      {
        string nm = (*it).first;
        cout << "    '" << nm << "'";
        if (nm == sv_lookup)
          cout << "  MATCH!" << endl;
        else
          cout << endl;
        //cout << "    " << m_proxies[ (*it).second ].name() << endl;
      }
      cout << endl;

      return 0;
    }
  }
  proxy = m_proxies[id];
 
  // check port/export compatibility
  int this_kind = proxy->proxy_kind();
  if ((this_kind == UVM_CHANNEL && sv_proxy_kind != UVM_PORT) ||
      (this_kind == UVM_PORT && sv_proxy_kind == UVM_PORT) ) {
    cout << "UVMC-Error: SC-side '"
         << proxy->name()
         << "' and SV-side '"
         << sv_name
         << "' cannot be both initiators or both targets."
         << endl;
    return 0;
  }

  // check mask compatibility
  // A proxy port receives transactions from the SV side. It is acting as
  // a channel for the SV-side proxy port. Thus, the SV side mask is the driving
  // port, so this proxy must provide the full interface of the SV side proxy.
  // 
  if (proxy->proxy_kind() == UVM_PORT) {
    if ((proxy->mask() & sv_mask) != sv_mask) {
      cout << "UVMC-Error: SC-side proxy port for '" << proxy->name()
           << "' with mask '" << hex << proxy->mask() << dec
           << "' and id '" << proxy->id()
           << "' not compatible with connected SV-side proxy" 
           << (sv_proxy_kind == UVM_PORT ? " port " : " channel ")
           << "for '" << sv_name
           << "' with mask '" << sv_mask <<  dec << "' and id " << sv_id << endl;
      return 0;
    }
  }
  else {
    if ((sv_mask & proxy->mask()) != sv_mask) {
      cout << "UVMC-Error: SC-side proxy channel for '" << proxy->name()
           << "' with mask '" << hex << proxy->mask() << dec
           << "' and id '" << proxy->id()
           << "' not compatible with connected SV-side proxy"
           << (sv_proxy_kind == UVM_PORT ? " port " : " channel ")
           << "for '" << sv_name
           << "' with mask '" << sv_mask <<  dec << "' and id " << sv_id << endl;
      return 0;
    }
  }

  // TODO: check port-export, port-port connection compatibility
  //   port-export only allowed with uvmc_connect
  //   port-port only allowed with uvmc_connect_hier



  // TODO: check transaction type compatibility
  //   need type string for transaction on SC side.
  //   Mismatched types can cause serious problems when unpacking arrays,
  //   as size of array is encoded in packed stream.
  /*
  if (proxy->kind().compare(sv_trans_type)) {
    cout << "UVMC-Error: Channel interface '" << proxy->name()
         << "' carrying transaction type '" << proxy->kind()
         << "' not compatible with connected SV port '" << port_name
         << "' carrying transaction type '" << trans_type << endl;
    return 0;
  }
  */

  // Successful connnection. Assign proxy's id to SV-side id.
  proxy->set_x_id(sv_id);
  *sc_id = proxy->id();
  
  cout << "Connected SC-side '" << proxy->name()
       << "' to SV-side '" << sv_name << "'" << endl;

  if (!uvmc_wait_for_run_phase) {
    proxy->notify_connected();
  }

  return 1;

}


// get_proxy (static)
// ---------

uvmc_proxy_base* uvmc_proxy_base::get_proxy(const int id)
{
  if (id < 0 || id >= (int)uvmc_proxy_base::m_proxies.size()) {
    cout << "Fatal: SV2C_x_trans_done: invalid id, " << id << endl;
    return NULL;
  }
  return uvmc_proxy_base::m_proxies[id];
}


// set_x_id
// ---------

void uvmc_proxy_base::set_x_id(int id)  {
  // TODO: validate before assigning
  m_x_id = id;
}


// x_id
// -----

int uvmc_proxy_base::x_id()  {
  return m_x_id;
}

// id
// --

int uvmc_proxy_base::id()  {
  return m_id;
}

// proxy_kind
// ----------

int uvmc_proxy_base::proxy_kind()  {
  return m_kind;
}

// mask
// ----

int uvmc_proxy_base::mask() {
  return m_mask;
}


// name
// ----

const char *uvmc_proxy_base::name() const {
  return m_name.c_str();
}


// kind
// ----

const char *uvmc_proxy_base::kind() const {
  return "uvmc_proxy_base";
}



// trampoline functions for channels
// ---------------------------------

void uvmc_proxy_base::blocking_req_done() {
  //implemented in derived classes; make pure virtual?
}


void uvmc_proxy_base::blocking_rsp_done(const bits_t *bits, uint64 delay) {
  // TODO: use memcpy? Answer: NO. Don't copy at all. Convert immediately.
  /*
  for (int i=0; i<UVMC_MAX_WORDS; i++) {
    m_bits[i] = bits[i];
  }
  m_delay_bits = delay;
  m_blocking_op_done.notify();
  */
}



// trampoline functions for ports
// ------------------------------

#define UVMCERR(N) \
  cout << "ERROR: Invalid call: " #N " must be implemented in derived class. " \
       << "Cross-language ports/exports are likely incompatible" << endl;

void uvmc_proxy_base::x_put (const bits_t *bits) {
  UVMCERR(x_put)
}

bool uvmc_proxy_base::x_try_put (const bits_t *bits) {
  UVMCERR(x_try_put)
  return 0;
}

bool uvmc_proxy_base::x_can_put () {
  UVMCERR(x_can_put)
  return 0;
}

void uvmc_proxy_base::x_get () {
  UVMCERR(x_get)
}

bool uvmc_proxy_base::x_try_get (bits_t *bits) {
  UVMCERR(x_try_get)
  return 0;
}

bool uvmc_proxy_base::x_can_get() {
  UVMCERR(x_can_get)
  return 0;
}

void uvmc_proxy_base::x_peek () {
  UVMCERR(x_peek)
}

bool uvmc_proxy_base::x_try_peek (bits_t *bits) {
  UVMCERR(x_try_peek)
  return 0;
}

bool uvmc_proxy_base::x_can_peek () {
  UVMCERR(x_can_peek)
  return 0;
}

void uvmc_proxy_base::x_write (const bits_t *bits) {
  UVMCERR(x_write)
}

void uvmc_proxy_base::x_transport (bits_t *bits) {
  UVMCERR(x_transport)
}

bool uvmc_proxy_base::x_nb_transport (bits_t *bits) {
  UVMCERR(x_nb_transport)
  return 0;
}


void uvmc_proxy_base::x_b_transport (bits_t *bits, uint64 delay ) {
  UVMCERR(x_b_transport);
}

int uvmc_proxy_base::x_nb_transport_fw (bits_t *bits, uint32 *phase, uint64 *delay ) {
  UVMCERR(x_nb_transport_fw);
  return tlm::TLM_COMPLETED;
}

int uvmc_proxy_base::x_nb_transport_bw (bits_t *bits, uint32 *phase, uint64 *delay ) {
  UVMCERR(x_nb_transport_bw);
  return tlm::TLM_COMPLETED;
}


//---------

// internal static variables
#ifdef UVMC23_ADDITIONS // {
// Need distinct name maps for both ports and channels to support
// name matching between SC <-> SC UVM-Connect'ions.
map<string,int> uvmc_proxy_base::m_port_names;
map<string,int> uvmc_proxy_base::m_channel_names;
#else // } UVMC23_ADDITIONS {
map<string,int> uvmc_proxy_base::m_proxy_names;
#endif // } UVMC23_ADDITIONS
vector<uvmc_proxy_base*> uvmc_proxy_base::m_proxies;



uvmc_proxy_base::uvmc_proxy_base() :
   m_name(""), m_id(-1), m_mask(0), m_x_id(-1)
#ifdef UVMC23_ADDITIONS // {
  , m_use_peer_sc_proxy(false), m_proxy_names( m_port_names )
#endif // } UVMC23_ADDITIONS
{ }


} // namespace uvmc


//------------------------------------------------------------------------------
//
// DPI IMPORT FUNC IMPLS
//
// Called by SV-side proxies, these find the proxy handle using the given id,
// then calls the appropriate method in the proxy.
//------------------------------------------------------------------------------

using namespace uvmc;
using uvmc::uvmc_proxy_base;
using uvmc::uint32;

extern "C" {

bool SV2C_blocking_req_done(int x_id)
{
  uvmc_proxy_base* port;
  port = uvmc_proxy_base::get_proxy(x_id);
  if (port)
    port->blocking_req_done();
  return 1;
}


bool SV2C_blocking_rsp_done(int x_id,
                            const bits_t *bits,
                            uint64 delay)
{
  uvmc_proxy_base* proxy;
  proxy = uvmc_proxy_base::get_proxy(x_id);
  if (proxy) {
    proxy->blocking_rsp_done(bits,delay);
  }
  return 1;
}


#define GET_PROXY_FROM_ID(NAME,RET) \
  uvmc_proxy_base* proxy; \
  if (id < 0 || id >= (int)uvmc_proxy_base::m_proxies.size()) { \
    cout << "Fatal: " << #NAME << ": invalid id, " << id << endl; \
    cout << "Possible proxies are (list of " \
         << uvmc_proxy_base::m_proxies.size() << " proxies) :" << endl; \
    for (unsigned int i=0; i< uvmc_proxy_base::m_proxies.size(); i++) { \
      cout << "  proxy[" << i << "]=" \
           << uvmc_proxy_base::m_proxies[i]->name() << endl; \
    } \
    return RET; \
  } \
  proxy = uvmc_proxy_base::m_proxies[id];

#define GET_PROXY_FROM_ID_VOID(NAME) \
  GET_PROXY_FROM_ID(NAME,)


// PUT 

bool SV2C_put (int id, const bits_t *bits) {
  GET_PROXY_FROM_ID(SV2C_put,0)
  proxy->x_put(bits);
  return 1;
}
bool SV2C_try_put (int id, const bits_t *bits) {
  GET_PROXY_FROM_ID(SV2C_try_put,0)
  return proxy->x_try_put(bits);
}
bool SV2C_can_put (int id) {
  GET_PROXY_FROM_ID(SV2C_can_put,0)
  return proxy->x_can_put();
}


// WRITE

bool SV2C_write (int id, const bits_t *bits) {
  GET_PROXY_FROM_ID(SV2C_write,0)
  proxy->x_write(bits);
  return 1;
}

// GET

bool SV2C_get (int id) {
  GET_PROXY_FROM_ID(SV2C_get,0)
  proxy->x_get();
  return 1;
}
bool SV2C_try_get (int id, bits_t *bits) {
  GET_PROXY_FROM_ID(SV2C_try_get,0)
  return proxy->x_try_get(bits);
}
bool SV2C_can_get (int id) {
  GET_PROXY_FROM_ID(SV2C_can_get,0)
  return proxy->x_can_get();
}


// PEEK

bool SV2C_peek (int id) {
  GET_PROXY_FROM_ID(SV2C_peek,0)
  proxy->x_peek();
  return 1;
}
bool SV2C_try_peek (int id, bits_t *bits) {
  GET_PROXY_FROM_ID(SV2C_try_peek,0)
  return proxy->x_try_peek(bits);
}
bool SV2C_can_peek (int id) {
  GET_PROXY_FROM_ID(SV2C_can_peek,0)
  return proxy->x_can_peek();
}


// TRANSPORT

bool SV2C_transport (int id, bits_t *bits) {
  GET_PROXY_FROM_ID(SV2C_transport,0)
  proxy->x_transport(bits);
  return 1;
}
bool SV2C_try_transport (int id, bits_t *bits) {
  GET_PROXY_FROM_ID(SV2C_try_transport,0)
  //proxy->x_nb_transport(bits);
  return 0;
}


// TLM2
//

int SV2C_nb_transport_fw (int id, bits_t *bits, uint32 *phase, uint64 *delay) {
  GET_PROXY_FROM_ID(SV2C_nb_transport_fw,tlm::TLM_COMPLETED)
  return proxy->x_nb_transport_fw(bits,phase,delay);
}

int SV2C_nb_transport_bw (int id, bits_t *bits, uint32 *phase, uint64 *delay) {
  GET_PROXY_FROM_ID(SV2C_nb_transport_bw,tlm::TLM_COMPLETED)
  return proxy->x_nb_transport_bw(bits,phase,delay);
}

bool  SV2C_b_transport (int id, bits_t* bits, uint64 delay) {
  GET_PROXY_FROM_ID(SV2C_b_transport,0)
  proxy->x_b_transport(bits,delay);
  return 1;
}

#ifdef UVMC23_ADDITIONS // {
// See comments for these functions in uvmc_common.h
uvmc_proxy_base *
uvmc_proxy_base::find_sc_peer_port_matching_lookupid( const char *lookupid ){
    if( *lookupid ) {
        map<string,int>::iterator iter = m_port_names.find(lookupid);
        if( iter != m_port_names.end() )
            // Ah ! we found one.
            return m_proxies[(*iter).second];
    }
    return NULL;
}
uvmc_proxy_base *
uvmc_proxy_base::find_sc_peer_channel_matching_lookupid( const char *lookupid ){
    if( *lookupid ) {
        map<string,int>::iterator iter = m_channel_names.find(lookupid);
        if( iter != m_channel_names.end() )
            // Ah ! we found one.
            return m_proxies[(*iter).second];
    }
    return NULL;
}
#endif // } UVMC23_ADDITIONS

} // namespace uvmc

