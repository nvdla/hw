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


//-----------------------------------------------------------------------------
// File: uvmc_tlm1.sv
//
// Handles all TLM1-specific UVMC handling.
//-----------------------------------------------------------------------------



//------------------------------------------------------------------------------
// Group: TLM1 DPI Imports
//
// For SV TLM1 proxy ports calling into SC.
//------------------------------------------------------------------------------

import "DPI-C" context function bit  SV2C_put      (int x_id, bits_t bits);
import "DPI-C" context function bit  SV2C_try_put  (int x_id, bits_t bits);
import "DPI-C" context function bit  SV2C_can_put  (int x_id);
import "DPI-C" context function bit  SV2C_get      (int x_id);
import "DPI-C" context function bit  SV2C_try_get  (int x_id, output bits_t bits);
import "DPI-C" context function bit  SV2C_can_get  (int x_id);
import "DPI-C" context function bit  SV2C_peek     (int x_id);
import "DPI-C" context function bit  SV2C_try_peek (int x_id, output bits_t bits);
import "DPI-C" context function bit  SV2C_can_peek (int x_id);
import "DPI-C" context function bit  SV2C_write    (int x_id, bits_t bits);
import "DPI-C" context function bit  SV2C_transport(int x_id, inout bits_t bits);
import "DPI-C" context function bit  SV2C_try_transport(int x_id, inout bits_t bits);


//------------------------------------------------------------------------------
//
// Group: TLM1 DPI Exports
//
// For SC TLM1 calling into SV
//
// SC calls export-DPI C2SV_* tf with target port id and bit vector.  The id is
// used to lookup the target port, which must have been previously registered. 
// Once the port is found, the bits are sent the port's x_-prefixed method,
// which converts the bits to the SV transaction object and calls the
// appropriate, typed TLM method.
//
//|    DPI-C entry             SV               SV UVM TLM
//|
//| C2SV_put(id,bits) -> port.x_put(bits) -> port.put(object)
//
//------------------------------------------------------------------------------

export "DPI-C"  function C2SV_put;
export "DPI-C"  function C2SV_try_put;
export "DPI-C"  function C2SV_can_put;
export "DPI-C"  function C2SV_get;
export "DPI-C"  function C2SV_try_get;
export "DPI-C"  function C2SV_can_get;
export "DPI-C"  function C2SV_peek;
export "DPI-C"  function C2SV_try_peek;
export "DPI-C"  function C2SV_can_peek;
export "DPI-C"  function C2SV_write;
export "DPI-C"  function C2SV_transport;
export "DPI-C"  function C2SV_try_transport;


// put

function void C2SV_put(int x_id, bits_t bits);
  `__UVMC_GET_PORT__
  port.x_put(bits);
endfunction

function bit C2SV_try_put(int x_id, bits_t bits);
  `__UVMC_GET_PORT__
  return port.x_try_put(bits);
endfunction

function bit C2SV_can_put(int x_id);
  `__UVMC_GET_PORT__
  return port.x_can_put();
endfunction


// get

function void C2SV_get(int x_id);
  `__UVMC_GET_PORT__
  port.x_get();
endfunction

function bit C2SV_try_get(int x_id, output bits_t bits);
  `__UVMC_GET_PORT__
  return port.x_try_get(bits);
endfunction

function bit C2SV_can_get(int x_id);
  `__UVMC_GET_PORT__
  return port.x_can_get();
endfunction


// peek

function void C2SV_peek(int x_id);
  `__UVMC_GET_PORT__
  port.x_peek();
endfunction

function bit C2SV_try_peek(int x_id, output bits_t bits);
  `__UVMC_GET_PORT__
  return port.x_try_peek(bits);
endfunction

function bit C2SV_can_peek(int x_id);
  `__UVMC_GET_PORT__
  return port.x_can_peek();
endfunction


// analysis

function void C2SV_write(int x_id, bits_t bits);
  `__UVMC_GET_PORT__
  port.x_write(bits);
endfunction


// transport

function void C2SV_transport(int x_id, inout bits_t bits);
  `__UVMC_GET_PORT__
  port.x_transport(bits);
endfunction

function bit C2SV_try_transport(int x_id, inout bits_t bits);
  `__UVMC_GET_PORT__
  return port.x_try_transport(bits);
endfunction



//------------------------------------------------------------------------------
//
// CLASS: uvmc_tlm1_dispatch #(T1,T2,CVRT_T1,CVRT_T2)
//
// The base class for all TLM1 port and export proxies.
//
// SC->SV:
// Incoming TLM1 requests from the C2SV_* DPI-C export functions will be
// forwarded to the corresponding x_* method in the this class. The 
//
//------------------------------------------------------------------------------

class uvmc_tlm1_dispatch #(type T1=int,
                           T2=T1,
                           CVRT_T1=int, //uvmc_default_converter #(T1),
                           CVRT_T2=CVRT_T1 // uvmc_default_converter #(T2)
                           ) extends uvmc_base;
  
  `ifdef OVMC
    typedef ovm_port_base #(tlm_if_base #(T1,T2)) imp_t;
  `else
    typedef uvm_port_base #(uvm_tlm_if_base #(T1,T2)) imp_t;
  `endif

  typedef enum {NONE,PUT,GET,PEEK,TRANSPORT} op_e;

  /* local */ imp_t m_imp;

  local bits_t  m_bits; // used only for IMP proxies
  local semaphore      m_sem = new(1);
  local T1             t1;
  local op_e           m_blocking_op;
  local event          m_blocking_op_done;
  local process        m_blocking_sync_proc;
  local uint64         m_delay;


  // Function: new
  //
  // Creates a new proxy port, associating it with the ~port_name~ of the
  // SV port, export, or imp that it will be connected to, and an optional
  // ~lookup_name~, which can be used to make connections using arbitrary
  // strings instead of hierarchical names.

  function new (string port_name,
                string lookup_name="",
                uvm_packer packer,
                imp_t imp);
    super.new(port_name, lookup_name, packer);
    this.m_imp = imp;
    if (m_blocking_sync_proc == null)
      fork begin
        m_blocking_sync_proc = process::self();
        blocking_sync_process();
      end
      join_none
  endfunction

  virtual function string get_full_name();
    return m_imp.get_full_name();
  endfunction


  // Group: Blocking calls from SC
  //
  // Blocking put, get, peek, and transport calls from SystemC are
  // handled using two non-blocking DPI export calls. For example,
  // a ~get~ operation from SC to SV involves a non-blocking call
  // to <x_get>, which only triggers the <blocking_sync_process> to
  // resume before returning. The SC side will then wait on a native
  // sc_event for the blocking operation in SV to complete. Meanwhile
  // the <blocking_sync_process> wakes up and calls get(T t) to get
  // the requested transaction object from the connected target.
  // This object is then converted to bits and sent back to SC via
  // the <SV2C_blocking_rsp_done>, which triggers the sc_event that
  // the original caller was waiting on. 


  // Function: notify_blocking_sync_op
  //
  // Triggers the <blocking_sync_process> to complete a blocking
  // put, get, peek, or transport operation originating from SystemC.

  function void notify_blocking_sync_op(op_e op);
    m_blocking_op = op;
  endfunction



  // Function: blocking_rsp_done
  //
  // Called by SC when a blocking operation with data is completed. The 
  // <blocking_sync_process> in this proxy instance is resumed, which
  // converts to bits back to an object and returns from the original
  // blocking get, peek, or transport operation.

  virtual function void blocking_rsp_done(ref bits_t bits, input uint64 delay);
    // copies from array ptr provided by by SC
    // (TODO: copy directly into unpacker)
    m_bits = bits;
    ->m_blocking_op_done;
  endfunction


  // Function: blocking_req_done
  //
  // Triggers the <blocking_sync_process> to wake up and complete the
  // blocking put operation.

  virtual function void blocking_req_done();
    ->m_blocking_op_done;
  endfunction


  // Task: blocking_sync_process
  //
  // Facilitates TLM1 blocking calls (put, get, peek, and transport).  by waiting
  // for the SC side to complete the original request before returning. 
  // Background process waits for a m_blocking_op event from the C side.
  // It then executes the blocking operation, then notifies the C side that
  // the operation completed. If a get, peek, or transport, the response
  // is also delivered the response in bits if a get, peek, or transport.

  task blocking_sync_process();
    forever begin
      @(m_blocking_op != NONE);
      case (m_blocking_op)
        PUT: begin
               m_imp.put(t1);
               void'(SV2C_blocking_req_done(m_x_id));
             end
        GET: begin
               T2 t2;
               m_imp.get(t2);
               CVRT_T2::m_pre_pack(t2,packer);
               CVRT_T2::do_pack(t2,packer);
               CVRT_T2::m_post_pack(m_bits,t2,packer);
               void'(SV2C_blocking_rsp_done(m_x_id,m_bits,0));
             end
        PEEK: begin
               T2 t2;
               m_imp.peek(t2);
               CVRT_T2::m_pre_pack(t2,packer);
               CVRT_T2::do_pack(t2,packer);
               CVRT_T2::m_post_pack(m_bits,t2,packer);
               void'(SV2C_blocking_rsp_done(m_x_id,m_bits,0));
             end
        TRANSPORT: begin
               T2 t2;
               m_imp.transport(t1,t2);
               CVRT_T2::m_pre_pack(t2,packer);
               CVRT_T2::do_pack(t2,packer);
               CVRT_T2::m_post_pack(m_bits,t2,packer);
               void'(SV2C_blocking_rsp_done(m_x_id,m_bits,0));
             end
        default: begin
            `uvm_fatal("UVMC",
                       {"Unknown blocking operation attempted: %0d",
                       $sformatf("%0d",m_blocking_op)})
             end
      endcase
      m_blocking_op = NONE;
    end
  endtask


  //----------------------------------------------------------------------------
  //
  // Group: SC to SV dispatch method: x_*
  //
  // The x_ prefixed methods are called by their corresponding C2SV_ DPI export
  // non-member functions and tasks. The x_ methods convert from bits to a
  // transaction object of the appropriate type, then send the transaction
  // object to the connected imp (interface implementation).
  //
  //| C2SV_* --> x_* --> connected imp on SV side
  // 
  //----------------------------------------------------------------------------

  function void x_put(ref bits_t bits);
    t1 = new();
    CVRT_T1::m_pre_unpack(bits,t1,packer);
    CVRT_T1::do_unpack(t1,packer);
    CVRT_T1::m_post_unpack(t1,packer);
    notify_blocking_sync_op(PUT);
  endfunction

  function bit x_try_put(ref bits_t bits);
    T1 t;
    //if (!m_imp.can_put())
    //  return 0;
    t = new();
    CVRT_T1::m_pre_unpack(bits,t,packer);
    CVRT_T1::do_unpack(t,packer);
    CVRT_T1::m_post_unpack(t,packer);
    return m_imp.try_put(t);
  endfunction

  function bit x_can_put();
    return m_imp.can_put();
  endfunction

  function void x_get();
    notify_blocking_sync_op(GET);
  endfunction

  function bit x_try_get(ref bits_t bits);
    T2 t;
    if (m_imp.try_get(t)) begin
      CVRT_T2::m_pre_pack(t,packer);
      CVRT_T2::do_pack(t,packer);
      CVRT_T2::m_post_pack(bits,t,packer);
      return 1;
    end
    return 0;
  endfunction

  function bit x_can_get();
    return m_imp.can_get();
  endfunction

  function void x_peek();
    notify_blocking_sync_op(PEEK);
  endfunction 

  function bit x_try_peek(ref bits_t bits);
    T2 t;
    if (m_imp.try_peek(t)) begin
      CVRT_T2::m_pre_pack(t,packer);
      CVRT_T2::do_pack(t,packer);
      CVRT_T2::m_post_pack(bits,t,packer);
      return 1;
    end
    return 0;
  endfunction

  function bit x_can_peek();
    return m_imp.can_peek();
  endfunction 

  function void x_write(ref bits_t bits);
    T1 t;
    t = new();
    CVRT_T1::m_pre_unpack(bits,t,packer);
    CVRT_T1::do_unpack(t,packer);
    CVRT_T1::m_post_unpack(t,packer);
    m_imp.write(t);
  endfunction

  function void x_transport(ref bits_t bits);
    t1 = null;
    t1 = new();
    CVRT_T1::m_pre_unpack(bits,t1,packer);
    CVRT_T1::do_unpack(t1,packer);
    CVRT_T1::m_post_unpack(t1,packer);
    notify_blocking_sync_op(TRANSPORT);
  endfunction

  function bit x_try_transport(ref bits_t bits);
    T1 req;
    T2 rsp;
    req = new();
    CVRT_T1::m_pre_unpack(bits,req,packer);
    CVRT_T1::do_unpack(req,packer);
    CVRT_T1::m_post_unpack(req,packer);
    x_try_transport = m_imp.nb_transport(req,rsp);
    if (x_try_transport) begin
      CVRT_T2::m_pre_pack(rsp,packer);
      CVRT_T2::do_pack(rsp,packer);
      CVRT_T2::m_post_pack(bits,rsp,packer);
    end
  endfunction



  //----------------------------------------------------------------------------
  //
  // OUTBOUND: SV --> C
  //
  //
  // Group: TLM IF methods
  //
  // The following method implementations are called via connected SV-side
  // ports. They first convert the transaction object into bits, then call the
  // corresponding SV2C method to send the bits to the C side. 
  //
  //| SV-side port --> <one of these methods> --> SV2C_*
  // 
  //----------------------------------------------------------------------------

 // PUT 

  function bit can_put();
    can_put = SV2C_can_put(m_x_id);
  endfunction

  function bit try_put(T1 t);
    if (!m_sem.try_get())
      return 0;
    if (!can_put()) begin
      m_sem.put();
      return 0;
    end  
    CVRT_T1::m_pre_pack(t,packer);
    CVRT_T1::do_pack(t,packer);
    CVRT_T1::m_post_pack(m_bits,t,packer);
    try_put = SV2C_try_put(m_x_id,m_bits);
    if (!try_put) begin
      `uvm_fatal("UVMC",{"try_put failed after receiving can_put=1"})
    end
    m_sem.put();
  endfunction

  virtual task put(T1 t);
    m_sem.get();
    CVRT_T1::m_pre_pack(t,packer);
    CVRT_T1::do_pack(t,packer);
    CVRT_T1::m_post_pack(m_bits,t,packer);
    void'(SV2C_put(m_x_id,m_bits));
    @m_blocking_op_done;
    m_sem.put();
  endtask


  // GET

  function bit can_get();
    return SV2C_can_get(m_x_id);
  endfunction

  function bit try_get(output T2 t);
    if (!m_sem.try_get())
      return 0;
    if (!can_get()) begin
      m_sem.put();
      return 0;
    end
    try_get = SV2C_try_get(m_x_id,m_bits);
    if (!try_get) begin
      `uvm_fatal("UVMC",{"try_get failed after receiving can_get=1"})
      return 0;
    end
    t=new();
    CVRT_T2::m_pre_unpack(m_bits,t,packer);
    CVRT_T2::do_unpack(t,packer);
    CVRT_T2::m_post_unpack(t,packer);
    m_sem.put();
  endfunction

  task get(output T2 t);
    m_sem.get();
    void'(SV2C_get(m_x_id));
    @m_blocking_op_done;
    t=new();
    CVRT_T2::m_pre_unpack(m_bits,t,packer);
    CVRT_T2::do_unpack(t,packer);
    CVRT_T2::m_post_unpack(t,packer);
    m_sem.put();
  endtask


  // PEEK

  function bit can_peek();
    return SV2C_can_peek(m_x_id);
  endfunction

  function bit try_peek(output T2 t);
    if (!m_sem.try_get())
      return 0;
    if (!can_peek()) begin
      m_sem.put();
      return 0;
    end
    try_peek = SV2C_try_peek(m_x_id,m_bits);
    if (!try_peek) begin
      `uvm_fatal("UVMC",{"try_peek failed after receiving can_peek=1"})
      return 0;
    end
    t=new();
    CVRT_T2::m_pre_unpack(m_bits,t,packer);
    CVRT_T2::do_unpack(t,packer);
    CVRT_T2::m_post_unpack(t,packer);
    m_sem.put();
  endfunction

  task peek(output T2 t);
    m_sem.get();
    void'(SV2C_peek(m_x_id));
    @m_blocking_op_done;
    t=new();
    CVRT_T2::m_pre_unpack(m_bits,t,packer);
    CVRT_T2::do_unpack(t,packer);
    CVRT_T2::m_post_unpack(t,packer);
    m_sem.put();
  endtask


  // WRITE

  function void write(T1 t);
    CVRT_T1::m_pre_pack(t,packer);
    CVRT_T1::do_pack(t,packer);
    CVRT_T1::m_post_pack(m_bits,t,packer);
    void'(SV2C_write(m_x_id,m_bits));
  endfunction


  // TRANSPORT

  task transport(T1 req, output T2 rsp);
    m_sem.get();
    CVRT_T1::m_pre_pack(req,packer);
    CVRT_T1::do_pack(req,packer);
    CVRT_T1::m_post_pack(m_bits,req,packer);
    void'(SV2C_transport(m_x_id,m_bits));
    @m_blocking_op_done;
    rsp=new();
    CVRT_T2::m_pre_unpack(m_bits,rsp,packer);
    CVRT_T2::do_unpack(rsp,packer);
    CVRT_T2::m_post_unpack(rsp,packer);
    m_sem.put();
  endtask

  function bit nb_transport(T1 req, output T2 rsp);
    CVRT_T1::m_pre_pack(req,packer);
    CVRT_T1::do_pack(req,packer);
    CVRT_T1::m_post_pack(m_bits,req,packer);
    // not implemented on C side (commented out)
    //if (!SV2C_nb_transport(m_x_id,m_bits))
    //  return 0;
    rsp=new();
    CVRT_T2::m_pre_unpack(m_bits,rsp,packer);
    CVRT_T2::do_unpack(rsp,packer);
    CVRT_T2::m_post_unpack(rsp,packer);
    return 1;
  endfunction


endclass



//------------------------------------------------------------------------------
//
// CLASS: uvmc_tlm1_port_proxy #(T1,T2)
//
//------------------------------------------------------------------------------

class uvmc_tlm1_port_proxy #(type T1=int, T2=T1,
                               CVRT_T1=uvmc_default_converter #(uvm_object),
                               CVRT_T2=CVRT_T1)
  `ifdef OVMC
                           extends ovm_port_base #(tlm_if_base #(T1,T2));
  typedef ovm_port_base #(tlm_if_base #(T1,T2)) port_type;
  `else
                           extends uvm_port_base #(uvm_tlm_if_base #(T1,T2));
  typedef uvm_port_base #(uvm_tlm_if_base #(T1,T2)) port_type;
   `endif

  typedef uvmc_tlm1_dispatch #(T1,T2,CVRT_T1,CVRT_T2) x_dispatch_type;
  typedef uvmc_tlm1_port_proxy #(T1,T2,CVRT_T1,CVRT_T2) this_type;

  static this_type m_proxys[string];

  local x_dispatch_type m_x_dispatch;
  this_type m_local_proxy;

  const string m_type_name;

  // Function: new
  //
  // Create a new instance of a proxy port or imp that is a compatible
  // connection to the given ~port~. Once created, this proxy will be
  // connected to the given ~port~ to satisfy the connectivity requirements
  // of the ~port~. 

  function new(port_type port, string lookup_name,uvm_port_type_e proxy_kind,
               uvm_packer packer);
    `ifdef OVMC
      `ifndef HAS_OVM_PORT_MASK_ACCESSOR
        super.new({"UVMC_PROXY.",port.get_full_name()},ovm_top,proxy_kind,1,1);
        // must effectively disable mask check; can't get from ~port~ argument
        // uvm 1.1a added a m_get_if_mask() method to allow access to the mask
        if (proxy_kind == UVM_PORT)
          m_if_mask = 'h0;
        else
          m_if_mask = 'h7FFFFFFF;
      `else
        super.new({"UVMC_PROXY.",port.get_full_name()},uvm_top,proxy_kind,1,1);
        m_if_mask = port.m_get_if_mask();
      `endif
    `else
      super.new({"UVMC_PROXY.",port.get_full_name()},uvm_top,proxy_kind,1,1);
      m_if_mask = port.m_get_if_mask();
    `endif
    m_type_name = {"UVMC_PROXY_FOR_",port.get_type_name()};
    m_x_dispatch = new(port.get_full_name(), lookup_name, packer, this);
    m_proxys[port.get_full_name()] = this;
  endfunction


  // Function: get_type_name
  //
  // Returns the type name of this proxy.

  virtual function string get_type_name();
    return m_type_name;
  endfunction


  // Function: resolve_bindings
  //
  // Resolves the cross-language binding, where the port's name and optional
  // lookup string are matched with a corresponding proxy channel name/x_id
  // string on the SC side.

  virtual function void resolve_bindings();
    `ifdef OVMC
      `ifndef HAS_OVM_PORT_MASK_ACCESSOR
        int mask;
        // must effectively disable mask check in OVM; can't get from supplied port in c'tor
        // uvm 1.1a added a m_get_if_mask() method to allow access to the mask.
        // May provide this method in new release of OVM.
        if (is_port())
          mask = 'h7FFFFFFF;
        else
          mask = 'h0;
        m_x_dispatch.resolve_bindings(
               uvm_port_type_e'(is_port()?UVM_PORT:UVM_IMPLEMENTATION), mask);
      `else
        m_x_dispatch.resolve_bindings(
               uvm_port_type_e'(is_port()?UVM_PORT:UVM_IMPLEMENTATION), m_if_mask);
      `endif
    `else
      m_x_dispatch.resolve_bindings(
               uvm_port_type_e'(is_port()?UVM_PORT:UVM_IMPLEMENTATION), m_if_mask);
    `endif
    super.resolve_bindings();
    m_x_dispatch.m_imp = m_if;

    // if we are a channel proxy whose lookup was matched with a port proxy to a local
    // imp/export, forward to the port proxy
    if (m_x_dispatch.m_locally_connected && m_local_proxy == null && !is_port())
      m_local_proxy=m_proxys[uvmc_base::x_ports[m_x_dispatch.m_x_id].m_port_name];
  endfunction

  // If we're an IMPLEMENTATION proxy driven by an SV port:
  // - if connected to SC, we delegate to our dispatcher, which knows how to
  //   convert the transaction and send to the C side.
  // - If we are locally connected, delegate to the proxy for our target.

   task put (T1 t); 
    if (m_local_proxy != null)
      m_local_proxy.m_if.put(t);
    else
      m_x_dispatch.put(t);
  endtask

  function bit try_put (T1 t); 
    if (m_local_proxy != null)
      return m_local_proxy.m_if.try_put(t);
    else
      return m_x_dispatch.try_put(t); 
  endfunction 
  function bit can_put(); 
    if (m_local_proxy != null)
      return m_local_proxy.m_if.can_put();
    else
      return m_x_dispatch.can_put(); 
  endfunction

  task get (output T2 t); 
    if (m_local_proxy != null)
      m_local_proxy.m_if.get(t);
    else
      m_x_dispatch.get(t); 
  endtask

  function bit try_get (output T2 t); 
    if (m_local_proxy != null)
      return m_local_proxy.m_if.try_get(t);
    else
      return m_x_dispatch.try_get(t); 
  endfunction 
  function bit can_get(); 
    if (m_local_proxy != null)
      return m_local_proxy.m_if.can_get();
    else
      return m_x_dispatch.can_get(); 
  endfunction

  task peek (output T2 t); 
    if (m_local_proxy != null)
      m_local_proxy.m_if.peek(t);
    else
      m_x_dispatch.peek(t); 
  endtask

  function bit try_peek (output T2 t); 
    if (m_local_proxy != null)
      return m_local_proxy.m_if.try_peek(t);
    else
      return m_x_dispatch.try_peek(t); 
  endfunction 
  function bit can_peek(); 
    if (m_local_proxy != null)
      return m_local_proxy.m_if.can_peek();
    else
      return m_x_dispatch.can_peek(); 
  endfunction

  task transport (T1 req, output T2 rsp); 
    if (m_local_proxy != null)
      m_local_proxy.m_if.transport(req,rsp);
    else
      m_x_dispatch.transport(req, rsp); 
  endtask

  function bit nb_transport (T1 req, output T2 rsp); 
    if (m_local_proxy != null)
      return m_local_proxy.m_if.nb_transport(req,rsp);
    else
      return m_x_dispatch.nb_transport(req, rsp); 
  endfunction


  function void write (input T1 t);
    if (m_local_proxy != null)
      m_local_proxy.m_if.write(t);
    else
      m_x_dispatch.write(t);
  endfunction

endclass



//------------------------------------------------------------------------------
//
// CLASS: uvmc_tlm1 #(T1,T2)
//
// Use the static methods of this class to register a TLM1 port, export, or imp
// for connection to a corresponding port in SystemC.
//------------------------------------------------------------------------------

class uvmc_tlm1 #(type T1=int, T2=T1,
                    CVRT_T1=uvmc_default_converter #(uvm_object),
                    CVRT_T2=CVRT_T1); //uvmc_default_converter #(T2));

  typedef uvmc_tlm1_port_proxy #(T1,T2,CVRT_T1,CVRT_T2) port_proxy_type;
  `ifdef OVMC
  typedef ovm_port_base #(tlm_if_base #(T1,T2)) port_type;
  `else
  typedef uvm_port_base #(uvm_tlm_if_base #(T1,T2)) port_type;
  `endif

  // Function: connect
  //
  // Register the given ~port~ for communication with SC. The port's hierarchical
  // name and optional ~lookup_name~ will be used to match against SC-side port
  // registrations during elaboration. Any connection that does not match will
  // produce a fatal error. An optional, custom packing policy can be provided in
  // the ~packer~ argument.
  //
  // Registration involves creation of a proxy. If the ~port~ argument is a port,
  // then an imp proxy is created and the port connected to it. If the ~port~
  // argument is an export or imp, a port proxy is created and connected to it.
  //
  // To allow port registration to occur up through the connect_phase, the
  // check that components are not created past the build phase will be disabled.

  static function void connect(port_type port,
                               string lookup_name="",
                               uvm_packer packer=null);
    port_proxy_type proxy; 

    `ifndef OVMC
    uvmc_report_catcher catcher;
    `endif

    print_x_banner();

    if (port == null)
      `uvm_fatal("UVMC/CONNECT/NULL",
        {"The tlm1 connect function was passed a null port handle. Lookup name='",lookup_name,"'"})

    `ifndef OVMC
    if (!uvm_disable_ILLCRT) begin
      catcher = new();
      uvm_report_cb::add(null,catcher);
      uvm_disable_ILLCRT = 1;
    end
    `endif

    if (port.is_port()) begin
      proxy = new(port, lookup_name, UVM_IMPLEMENTATION, packer);
      port.connect(proxy);
    end
    else begin
      proxy = new(port, lookup_name, UVM_PORT, packer);
      proxy.connect(port);
    end
  endfunction


  // Function: connect_hier
  //
  // Register the given ~port~ for communication with SC. The port's hierarchical
  // name and optional ~lookup_name~ will be used to match against SC-side port
  // registrations during elaboration. Any connection that does not match will
  // produce a fatal error. An optional, custom packing policy can be provided in
  // the ~packer~ argument.
  //
  // Registration involves creation of a proxy. If the ~port~ argument is a port,
  // then a port proxy is created and connected to the given port, which acts as
  // a parent port to a SC port on the other side. If the ~port~
  // argument is an export, an export  proxy is created and the given export
  // connected to it. In this case, the given export serves as a parent
  // to an SC interface implementation or export.
  // 
  // To allow port registration to occur up through the connect_phase, the
  // check that components are not created past the build phase will be disabled.

  static function void connect_hier(port_type port,
                                    string lookup_name="",
                                    uvm_packer packer=null);
    port_proxy_type proxy; 
    `ifndef OVMC
    uvmc_report_catcher catcher;
    `endif

    print_x_banner();

    if (port == null)
      `uvm_fatal("UVMC/CONNECT/NULL",
        {"The tlm1 connect_hier function was passed a null port handle. Lookup name='",lookup_name,"'"})

    `ifndef OVMC
    if (!uvm_disable_ILLCRT) begin
      catcher = new();
      uvm_report_cb::add(null,catcher);
      uvm_disable_ILLCRT = 1;
    end
    `endif

    if (port.is_port()) begin
      proxy = new(port, lookup_name, UVM_PORT, packer);
      proxy.connect(port);
    end
    else if (port.is_export()) begin
      proxy = new(port, lookup_name, UVM_IMPLEMENTATION, packer);
      port.connect(proxy);
    end
    else begin
      `uvm_fatal("UVMC/ILL_CONNECT",{"The imp '",port.get_full_name(),
                  "' cannot be connected using connect_hier"});
    end
  endfunction


endclass


