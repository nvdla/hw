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

#ifndef UVMC_COMMON_H
#define UVMC_COMMON_H

#define UVMC23_ADDITIONS

// PRIMITIVE INTERFACES
#define TLM_B_PUT_MASK        (1<<0)
#define TLM_B_GET_MASK        (1<<1)
#define TLM_B_PEEK_MASK       (1<<2)
#define TLM_TRANSPORT_MASK    (1<<3)
#define TLM_NB_PUT_MASK       (1<<4)
#define TLM_NB_GET_MASK       (1<<5)
#define TLM_NB_PEEK_MASK      (1<<6)
//#define TLM_NB_TRANSPORT_MASK (1<<7)
#define TLM_ANALYSIS_MASK     (1<<8)
#define TLM_MASTER_BIT_MASK   (1<<9)
#define TLM_SLAVE_BIT_MASK    (1<<10)

#define TLM_FW_NB_TRANSPORT_MASK  (1<<0)
#define TLM_BW_NB_TRANSPORT_MASK  (1<<1)
#define TLM_B_TRANSPORT_MASK      (1<<2)

// COMBINATION INTERFACES
#define TLM_PUT_MASK         (TLM_B_PUT_MASK       | TLM_NB_PUT_MASK)
#define TLM_GET_MASK         (TLM_B_GET_MASK       | TLM_NB_GET_MASK)
#define TLM_PEEK_MASK        (TLM_B_PEEK_MASK      | TLM_NB_PEEK_MASK)
#define TLM_B_GET_PEEK_MASK  (TLM_B_GET_MASK       | TLM_B_PEEK_MASK)
#define TLM_B_MASTER_MASK    (TLM_B_PUT_MASK       | TLM_B_GET_MASK | \
                              TLM_B_PEEK_MASK      | TLM_MASTER_BIT_MASK)
#define TLM_B_SLAVE_MASK     (TLM_B_PUT_MASK       | TLM_B_GET_MASK | \
                              TLM_B_PEEK_MASK      | TLM_SLAVE_BIT_MASK)
#define TLM_NB_GET_PEEK_MASK (TLM_NB_GET_MASK      | TLM_NB_PEEK_MASK)
#define TLM_NB_MASTER_MASK   (TLM_NB_PUT_MASK      | TLM_NB_GET_MASK | \
                              TLM_NB_PEEK_MASK     | TLM_MASTER_BIT_MASK)
#define TLM_NB_SLAVE_MASK    (TLM_NB_PUT_MASK      | TLM_NB_GET_MASK | \
                              TLM_NB_PEEK_MASK     | TLM_SLAVE_BIT_MASK)
#define TLM_GET_PEEK_MASK    (TLM_GET_MASK         | TLM_PEEK_MASK)
#define TLM_MASTER_MASK      (TLM_B_MASTER_MASK    | TLM_NB_MASTER_MASK)
#define TLM_SLAVE_MASK       (TLM_B_SLAVE_MASK     | TLM_NB_SLAVE_MASK)
//#define TLM_TRANSPORT_MASK   (TLM_B_TRANSPORT_MASK | TLM_NB_TRANSPORT_MASK)


// Must be same as max words in SV!
#ifndef UVMC_MAX_WORDS
#define UVMC_MAX_WORDS (4096/4)
#endif

#define UVM_PORT 0
#define UVM_EXPORT 1
#define UVM_IMP  2
#define UVM_CHANNEL  3
#define UVM_SOCKET  4

#include <string>
#include <vector>
#include <map>
#include <systemc.h>
#include <tlm.h>

using std::string;
using std::vector;
using std::map;

typedef int unsigned bits_t;

extern "C" void* uvmc_pkg_scope;

extern "C" unsigned int uvm_major;
extern "C" unsigned int uvm_minor;
extern "C" string       uvm_fix;
extern "C" bool         uvmc_uvm_version_is_pre11b;
extern "C" unsigned int uvmc_default_stack_size;

namespace uvmc {

typedef  unsigned int uint32;

string uvmc_legal_path(const string path);

const char* uvmc_mask_to_string(const int mask);

extern bool uvmc_wait_for_run_phase;



class uvmc_packer;

//------------------------------------------------------------------------------
//
// CLASS- uvmc_proxy_base
//
// Defines a "typeless" TLM API interface for incoming and outgoing bits. The
// API is called by SV via the SV2C DPI import methods. Each uvmc_*_port and
// uvmc_*_channel proxy will inherit from this class, implementing only
// the methods pertinent to the port's/channel's interface.
//------------------------------------------------------------------------------

class uvmc_proxy_base
{
  public:
  uvmc_proxy_base(const string name,
                  const string lookup,
                  const int mask,
                  uvmc_packer* packer=NULL,
                  int proxy_kind=UVM_PORT);
  virtual ~uvmc_proxy_base();

  int id();
  int mask();
  int x_id();
  int proxy_kind();
  void set_x_id(int id);
  virtual const char *name() const;
  virtual const char *kind() const;

  static bool resolve(const string sv_name,
                      const string sv_lookup,
                      const int    sv_mask,
                      const string sv_type_name,
                      const int    sv_id,
                      int          sv_port_kind,
                      int *        sc_id);

#ifdef UVMC23_ADDITIONS // {
  // Small helper functions to assist in mutual discovery of SC ports and peer
  // exports with the same lookupid to allow support of direct-coupled SC <-> SC
  // UVM-Connect'ions. Search for "mutual discovery" in uvmc_connect.h for
  // more details.
  static uvmc_proxy_base *find_sc_peer_port_matching_lookupid(
      const char *lookupid );
  static uvmc_proxy_base *find_sc_peer_channel_matching_lookupid(
      const char *lookupid );
#endif // } UVMC23_ADDITIONS

  static vector<uvmc_proxy_base*> m_proxies;

  protected:
#ifdef UVMC23_ADDITIONS // {
  // Need distinct name maps for both ports and channels to support
  // name matching between SC <-> SC UVM-Connect'ions.
  static map<string,int> m_port_names;
  static map<string,int> m_channel_names;
#else // } UVMC23_ADDITIONS {
  static map<string,int> m_proxy_names;
#endif // } UVMC23_ADDITIONS

  mutable bits_t m_bits[UVMC_MAX_WORDS];
  //map<tlm_generic_payload, gp_info>* m_gp_cache;


  string m_name;
  int m_id;
  int m_mask;
  int m_x_id; // the id of our SV-counterpart
  uvmc_packer *m_packer;
  bool m_i_own_packer;
  bool m_locally_connected;
  uint64 m_delay_bits;
  int m_kind;


  private:
  explicit uvmc_proxy_base();


  // CHANNELS
  public:
  void notify_connected();
  void wait_connected();
  bool     m_connected;
  sc_event m_connected_event;

  static uvmc_proxy_base* get_proxy(const int id);

  sc_event m_blocking_op_done;
  virtual void blocking_req_done();
  virtual void blocking_rsp_done(const bits_t *bits, uint64 delay);



  // PORTS
  public:
  virtual void  x_put          (const bits_t *bits);
  virtual bool  x_try_put      (const bits_t *bits);
  virtual bool  x_can_put      ();
  virtual void  x_get          ();
  virtual bool  x_try_get      (bits_t *bits);
  virtual bool  x_can_get      ();
  virtual void  x_peek         ();
  virtual bool  x_try_peek     (bits_t *bits);
  virtual bool  x_can_peek     ();
  virtual void  x_write        (const bits_t *bits);

  virtual void  x_transport    (bits_t *bits);
  virtual bool  x_nb_transport (bits_t *bits);

  virtual void x_b_transport (bits_t *bits, uint64 delay );
  virtual int x_nb_transport_fw (bits_t *bits, uint32 *phase, uint64 *delay );
  virtual int x_nb_transport_bw (bits_t *bits, uint32 *phase, uint64 *delay );


  //virtual void register_nb();
  //virtual void register_b();

#ifdef UVMC23_ADDITIONS // {
  protected:
    bool m_use_peer_sc_proxy;
    map<string,int> &m_proxy_names;
#endif // } UVMC23_ADDITIONS

};



//------------------------------------------------------------------------------
//
// CLASS- uvmc_registry
//
//------------------------------------------------------------------------------

class uvmc_registry : public sc_module
{
  public:
   static uvmc_registry &get();
  
   static void add(uvmc_proxy_base &proxy);

  protected:
   virtual ~uvmc_registry();

   //static vector<uvmc_port_base> m_ports;
   //static vector<uvmc_channel_base> m_chans;
   static vector<uvmc_proxy_base> m_proxies;

  private:
   static uvmc_registry* m_inst;
   uvmc_registry(sc_module_name nm);
};


} // namespace uvmc


//------------------------------------------------------------------------------
//
// Group- DPI Imports
//
// Called by SV-side uvmc_channel
//------------------------------------------------------------------------------
//
// SV calls these methods with id and, if delivering data, the transaction in
// bit-form.
//
// id   - this is determined by SV2C_resolve_binding, another import function
//        called for each uvmc_channel instance on the SV side. 
//
// bits - a pointer to the data
//
// Blocking operations do not block. They 
//
// - An SV Initiator calls one of put, get, peek, transport, or b_transport
//
// - The corresponding method in the connected UVMC imp is called.
//   It the appropriate SV2C DPI import to make the request (delivering
//   converted bits if a b_transport call).
//
// - The DPI import here in C calls into the matched proxy port method,
//   x_put, x_get, x_transport, or x_b_transport, which accepts the
//   request (and bits, if b_tranport), triggers a background SC process,
//   then returns immediately.
//
// - On return from the SV2C calls, the UVMC imp then waits on an 'done' event. 
//
// - Meanwhile, in SC, the background thread process wakes up. It acts on
//   behalf of the blocked process in SV. This process then calls the
//   TLM interface method, which calls the bound implementation in SC.
//   We are finally calling the TLM method in SC via a call made in SV.
//
// - When the TLM function returns... if the function is get, peek, transport,
//   or b_transport, the transaction is packed into bits and sent back to SV
//   via the C2SV_blocking_rsp_done DPI export function. If the TLM method
//   is put, the process calls C2SV_blocking_req_done. After return from either
//   of these functions, the background process waits for the next request
//   from SV.
//
// - In SV, the event is triggered, causing the waiting process to wake up,
//   convert the bits to a SV transaction, then deliver it on return from
//   original blocking TLM method in SV
//------------------------------------------------------------------------------

using namespace uvmc;

extern "C"
{
// TLM1
bool SV2C_put             (int x_id, const bits_t *bits);
bool SV2C_try_put         (int x_id, const bits_t *bits);
bool SV2C_can_put         (int x_id);
bool SV2C_get             (int x_id);
bool SV2C_try_get         (int x_id, bits_t *bits);
bool SV2C_can_get         (int x_id);
bool SV2C_peek            (int x_id);
bool SV2C_try_peek        (int x_id, bits_t *bits);
bool SV2C_can_peek        (int x_id);
bool SV2C_transport       (int x_id, bits_t *bits);
bool SV2C_try_transport   (int x_id, bits_t *bits);
bool SV2C_write           (int x_id, const bits_t *bits);

// TLM2
int   SV2C_nb_transport_fw (int x_id,
                            bits_t *bits,
                            uvmc::uint32 *phase,
                            uint64 *delay);

int   SV2C_nb_transport_bw (int x_id,
                            bits_t *bits,
                            uvmc::uint32 *phase,
                            uint64 *delay);

bool SV2C_b_transport     (int x_id,
                            bits_t *bits,
                            uint64 delay);

bool SV2C_blocking_req_done(int x_id);
bool SV2C_blocking_rsp_done(int x_id, const bits_t *bits, uint64 delay);


} // extern "C"

#endif // UVMC_COMMON_H

