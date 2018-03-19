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
// File: uvmc_tlm2.sv
//
// Handles all TLM2-specific UVMC handling.
//-----------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Group: TLM2 DPI Imports
//
// For SV TLM2 proxy ports calling into SC.
//------------------------------------------------------------------------------

import "DPI-C" context function int  SV2C_nb_transport_fw (int x_id,
                                                           inout bits_t bits,
                                                           inout uint32 phase,
                                                           inout uint64 delay);

import "DPI-C" context function int  SV2C_nb_transport_bw (int x_id,
                                                           inout bits_t bits,
                                                           inout uint32 phase,
                                                           inout uint64 delay);

import "DPI-C" context function bit  SV2C_b_transport     (int x_id,
                                                           inout bits_t bits,
                                                           input uint64 delay);


//------------------------------------------------------------------------------
// Group: TLM2 DPI Exports
//
// For SC TLM2 calling into SV
//
// SC calls export-DPI C2SV_* tf with target port id and bit vector.  The id is
// used to lookup the target port, which must have been previously registered. 
// Once the port is found, the bits are sent the port's x_-prefixed method,
// which converts the bits to the SV transaction object and calls the
// appropriate, typed TLM method.
//
//
// SC to SV:
//
//|       DPI-C export                  SV                      SV UVM TLM
//|         function                 dispatcher     UNPACK      proxy port
//| C2SV_b_transport(id,...) -> port.x_b_transport(bits) -> port.b_transport(object)
//
//      The C2SV function
//      finds the dispatcher
//      and forwards args to 
//      it. The dispatch 
//      instance knows what
//      type to unpack into.
//
//
//| SV UVM TLM              DPI-C import
//| proxy imp                function     PACK
//
//  imp.b_transport(...) -> SV2C_b_transport(id,...)
//
//------------------------------------------------------------------------------

export "DPI-C"  function C2SV_nb_transport_fw;
export "DPI-C"  function C2SV_nb_transport_bw;
export "DPI-C"  function C2SV_b_transport;

function int C2SV_nb_transport_fw(int x_id,
                                  inout bits_t bits,
                                  inout uint32 phase,
                                  inout uint64 delay);
  `__UVMC_GET_PORT__
  C2SV_nb_transport_fw = port.x_nb_transport_fw(bits,phase,delay);
endfunction

function int C2SV_nb_transport_bw(int x_id,
                                  inout bits_t bits,
                                  inout uint32 phase,
                                  inout uint64 delay);
  `__UVMC_GET_PORT__
  return port.x_nb_transport_bw(bits,phase,delay);
endfunction

function void C2SV_b_transport (int x_id,
                                inout bits_t bits,
                                input uint64 delay);
  `__UVMC_GET_PORT__
  port.x_b_transport(bits, delay);
endfunction




//------------------------------------------------------------------------------
//
// CLASS: uvmc_tlm2_dispatch
//
//------------------------------------------------------------------------------

class uvmc_tlm2_dispatch #(type T=uvm_tlm_generic_payload,
                                PH=uvm_tlm_phase_e,
                                CVRT=int/*uvmc_default_converter #(T)*/)
                          extends uvmc_base;
  typedef uvm_port_base #(uvm_tlm_if #(T,PH)) imp_t;

  typedef enum {NONE,B_TRANSPORT} op_e;

  /* local */ imp_t m_imp;
  /* local */ imp_t m_local_imp;
  /* local */ bit   m_trans_is_gp;

  local bits_t          m_bits; // used only for IMP proxies
  local semaphore       m_sem = new(1);
  local T               m_t;
  local op_e            m_blocking_op;
  local event           m_blocking_op_done;
  local uvm_tlm_time    m_delay;
  local uint64          m_delay_bits;
  local uvm_tlm_phase_e m_phase;
  local process         m_blocking_sync_proc;


  // Function: new
  //
  // Create a new instance of a proxy port for TLM2 communication.

  function new(string port_name,
               string lookup_name="",
               uvm_packer packer,
               imp_t imp=null);
    uvm_tlm_generic_payload gp;
    super.new(port_name, lookup_name, packer);
    m_t = new();
    if ($cast(gp,m_t))
      m_trans_is_gp = 1;
    m_t = null;
    this.m_imp = imp;
    if (m_blocking_sync_proc == null)
      fork begin
        m_blocking_sync_proc = process::self();
        blocking_sync_proc();
      end
      join_none
  endfunction


  virtual function string get_full_name();
    return m_imp.get_full_name();
  endfunction


  // Function: blocking_rsp_done
  //
  // Triggers the background process to wake up and complete the
  // blocking get, peek, or transport operation.
 
  virtual function void blocking_rsp_done(ref bits_t bits,
                                          input uint64 delay);
    // copies from array ptr provided by SC
    // TODO: copy directly into packer
    m_bits = bits;
    m_delay_bits = delay;
    ->m_blocking_op_done;
  endfunction


  // Function: blocking_req_done
  //
  // Triggers the background process to wake up and complete
  // the blocking put operation.
  //
  virtual function void blocking_req_done();
    ->m_blocking_op_done;
  endfunction


  // Task: blocking_sync_process
  //
  //
  task blocking_sync_proc();
    forever begin
      @(m_blocking_op != NONE);
      case (m_blocking_op)
        B_TRANSPORT: begin
               uint64 del;
               m_imp.b_transport(m_t,m_delay);
               CVRT::m_pre_pack(m_t,packer);
               CVRT::do_pack(m_t,packer);
               CVRT::m_post_pack(m_bits,m_t,packer);
               del = $realtobits(m_delay.get_abstime(1.0e-12));
               void'(SV2C_blocking_rsp_done(m_x_id,m_bits,del));
               //if (m_trans_is_gp)
               //  m_t.free();
             end
        default:
            `uvm_fatal("UVMC",{"Unknown blocking operation attempted: %0d",
                       $sformatf("%0d",m_blocking_op)})
      endcase
      m_blocking_op = NONE;
    end
  endtask


  // Methods- implementations of the cross-language (type-less) methods,
  // which delegate to the typed methods

  function void x_b_transport (ref bits_t bits,
                               inout uint64 delay);
    T t;
    m_delay = new("x_b_transport_delay", 1.0e-12);
    t = new();
    //if (m_trans_is_gp) begin
    //  T t = m_gp_pool.get();
    //  t.acquire();
    //end
    //else
    //  T t = T::type_id::create(get_name(),null);
    CVRT::m_pre_unpack(bits,t,packer);
    CVRT::do_unpack(t,packer);
    CVRT::m_post_unpack(t,packer);
    m_t = t;
    m_delay.set_abstime($bitstoreal(delay),1.0e-12);
    m_blocking_op = B_TRANSPORT;
  endfunction

  function int x_nb_transport_fw (ref bits_t bits,
                                  inout uint32 phase,
                                  inout uint64 delay);
    uvm_tlm_time del = new("x_nb_transport_fw_delay", 1.0e-12);
    uvm_tlm_phase_e ph = uvm_tlm_phase_e'(phase);
    if (m_t == null)
      m_t = new();
    del.set_abstime($bitstoreal(delay),1.0e-12);
    CVRT::m_pre_unpack(bits,m_t,packer);
    CVRT::do_unpack(m_t,packer);
    CVRT::m_post_unpack(m_t,packer);
    x_nb_transport_fw = m_imp.nb_transport_fw(m_t, ph, del);
    CVRT::m_pre_pack(m_t,packer);
    CVRT::do_pack(m_t,packer);
    CVRT::m_post_pack(bits,m_t,packer);
    delay = $realtobits(del.get_abstime(1.0e-12));
    phase = ph;
    if (phase == UVM_TLM_COMPLETED)
      m_t = null;
  endfunction

  function int x_nb_transport_bw (ref bits_t bits,
                                  inout uint32 phase,
                                  inout uint64 delay);
    uvm_tlm_time del = new("x_nb_transport_bw_delay", 1.0e-12);
    uvm_tlm_phase_e ph = uvm_tlm_phase_e'(phase);
    if (m_t == null)
      m_t = new();
    del.set_abstime($bitstoreal(delay),1.0e-12);
    CVRT::m_pre_unpack(bits,m_t,packer);
    CVRT::do_unpack(m_t,packer);
    CVRT::m_post_unpack(m_t,packer);
    x_nb_transport_bw = m_imp.nb_transport_bw(m_t, ph, del);
    CVRT::m_pre_pack(m_t,packer);
    CVRT::do_pack(m_t,packer);
    CVRT::m_post_pack(bits,m_t,packer);
    delay = $realtobits(del.get_abstime(1.0e-12));
    phase = ph;
    if (phase == UVM_TLM_COMPLETED)
      m_t = null;
  endfunction


   // Methods- implementations of the TLM2 methods. When called via the
   // connected SV port, these methods will delegate to the connected proxy
   // port on the SC side, which will be connected to the target SC export
   // or interface. (see <uvmc_tlm2 #(T,P)::connect>).

  task b_transport (T t, uvm_tlm_time delay); 
    uint64 del;
    if (delay == null) begin
       `uvm_error("UVM/TLM/NULLDELAY",
              {get_full_name(), ".b_transport() called with 'null' delay"})
       return;
    end
    del = $realtobits(delay.get_abstime(1.0e-12));
    m_sem.get();
    if (m_local_imp != null) begin
      m_local_imp.b_transport(t,delay);
      m_sem.put();
      return;
    end
    CVRT::m_pre_pack(t,packer);
    CVRT::do_pack(t,packer);
    CVRT::m_post_pack(m_bits,t,packer);
    //$display("HERE");
    void'(SV2C_b_transport(m_x_id,m_bits,del));
    @m_blocking_op_done;
    CVRT::m_pre_unpack(m_bits,t,packer);
    CVRT::do_unpack(t,packer);
    CVRT::m_post_unpack(t,packer);
    delay.set_abstime($bitstoreal(m_delay_bits),1.0e-12);
    m_sem.put();
  endtask


  function uvm_tlm_sync_e nb_transport_fw (T t,
                                           ref uvm_tlm_phase_e p,
                                           input uvm_tlm_time delay); 
    uint64 del;
    uint32 ph = p;
    int result;
    if (delay == null) begin
       `uvm_error("UVM/TLM/NULLDELAY",
              {get_full_name(), ".nb_transport_fw() called with 'null' delay"})
       return UVM_TLM_COMPLETED;
    end
    del = $realtobits(delay.get_abstime(1.0e-12));
    if (!m_sem.try_get())
      return UVM_TLM_COMPLETED;
    CVRT::m_pre_pack(t,packer);
    CVRT::do_pack(t,packer);
    CVRT::m_post_pack(m_bits,t,packer);
    result = SV2C_nb_transport_fw(m_x_id,m_bits,ph,del);
    CVRT::m_pre_unpack(m_bits,t,packer);
    CVRT::do_unpack(t,packer);
    CVRT::m_post_unpack(t,packer);
    nb_transport_fw = uvm_tlm_sync_e'(result);
    delay.set_abstime($bitstoreal(del),1.0e-12);
    p = PH'(ph);
    m_sem.put();
  endfunction


  function uvm_tlm_sync_e nb_transport_bw (T t,
                                           ref uvm_tlm_phase_e p,
                                           input uvm_tlm_time delay); 
    uint64 del;
    uint32 ph = p;
    int result;
    if (delay == null) begin
       `uvm_error("UVM/TLM/NULLDELAY",
              {get_full_name(), ".nb_transport_bw() called with 'null' delay"})
       return UVM_TLM_COMPLETED;
    end
    del = $realtobits(delay.get_abstime(1.0e-12));
    if (!m_sem.try_get())
      return UVM_TLM_COMPLETED;
    CVRT::m_pre_pack(t,packer);
    CVRT::do_pack(t,packer);
    CVRT::m_post_pack(m_bits,t,packer);
    result = SV2C_nb_transport_bw(m_x_id,m_bits,ph,del);
    CVRT::m_pre_unpack(m_bits,t,packer);
    CVRT::do_unpack(t,packer);
    CVRT::m_post_unpack(t,packer);
    delay.set_abstime($bitstoreal(del),1.0e-12);
    nb_transport_bw = uvm_tlm_sync_e'(result);
    p = PH'(ph);
    m_sem.put();
  endfunction

endclass


//------------------------------------------------------------------------------
//
// CLASS: uvmc_tlm2_port_proxy #(T,P)
//
// A fully-typed proxy that can bind to any of the TLM2 primitive
// ports, exports, and imps (b_transport, nb_transport_fw, nb_transport_bw).
//------------------------------------------------------------------------------

class uvmc_tlm2_port_proxy #(type T=uvm_tlm_generic_payload,
                                  P=uvm_tlm_phase_e,
                                  CVRT=uvmc_default_converter#(uvm_object)
                                  /*CVRT=uvmc_default_converter #(T)*/)
                           extends uvm_port_base #(uvm_tlm_if #(T,P));

  typedef uvm_port_base #(uvm_tlm_if #(T,P)) port_type;
  typedef uvmc_tlm2_dispatch #(T,P,CVRT) x_dispatch_type;
  typedef uvmc_tlm2_port_proxy #(T,P,CVRT) this_type;

  static this_type m_proxys[string];

  local x_dispatch_type m_x_dispatch;
  this_type m_local_proxy;

  const string m_type_name;


  // Function: new
  //
  // Creates a new x_port proxy port. Normally called by <connect>.

  function new(port_type port, string lookup_name, uvm_port_type_e proxy_type,
               uvm_packer packer); 
    super.new({"UVMC_PROXY.",port.get_full_name()},uvm_top,proxy_type,1,1);
    m_if_mask = port.m_get_if_mask();
    m_type_name = {"UVMC_PROXY_FOR_",port.get_type_name()};
    m_x_dispatch = new(port.get_full_name(), lookup_name, packer, this);
    m_proxys[port.get_full_name()] = this;
  endfunction


  virtual function string get_type_name();
    return m_type_name;
  endfunction


  // Function: resolve_bindings
  //
  // Resolves the cross-language binding, where the xport's name and optional
  // x_id string are matched with a corresponding proxy channel name/x_id string
  // on the SC side.

  virtual function void resolve_bindings();
    m_x_dispatch.resolve_bindings(is_port()?UVM_PORT:UVM_IMPLEMENTATION, m_if_mask);
    super.resolve_bindings();
    m_x_dispatch.m_imp = m_if;

    // if this channel proxy is string matched with a port proxy to a local
    // imp/export, forward to the port proxy
    if (m_x_dispatch.m_locally_connected && m_local_proxy == null && !is_port())
      m_local_proxy = m_proxys[uvmc_base::x_ports[m_x_dispatch.m_x_id].m_port_name];

  endfunction


  // If we're an IMPLEMENTATION proxy driven by an SV port:
  //
  // - If connected to SC, we delegate to our dispatcher, which knows how to
  //   convert the transaction and send to the C side.
  // - If we are locally connected, delegate to the proxy port for
  //   our local target.

  task b_transport (T t, uvm_tlm_time delay);
    if (m_local_proxy != null)
      m_local_proxy.m_if.b_transport(t, delay);
    else
      m_x_dispatch.b_transport(t, delay);
  endtask

  function uvm_tlm_sync_e nb_transport_fw (T t,
                                           ref P p,
                                           input uvm_tlm_time delay); 
    if (m_local_proxy != null)
      return m_local_proxy.m_if.nb_transport_fw(t, p, delay);
    else
      return m_x_dispatch.nb_transport_fw(t, p, delay);
  endfunction

  function uvm_tlm_sync_e nb_transport_bw (T t,
                                           ref P p,
                                           input uvm_tlm_time delay); 
    if (m_local_proxy != null)
      return m_local_proxy.m_if.nb_transport_bw(t, p, delay);
    else
      return m_x_dispatch.nb_transport_bw(t, p, delay);
  endfunction

endclass



//------------------------------------------------------------------------------
//
// Group: uvmc_tlm_*_socket workarounds
//
// Proxies for connecting to the various UVM TLM socket flavors. 
//
// ** NOTE**
// The following components with sockets really shouldn't be necessary.
// SV TLM2 sockets can't be extended to provide their own implementation.
// The UVMC proxys must be components, not sockets proper.
//
// They must be components because TLM2 sockets REQUIRE connections to specific
// compatible socket types. For example, uvm_tlm_b_passthrough_target_socket
// MUST connect to uvm_tlm_b_passthrough_target_socket or uvm_tlm_b_target_socket.
// This means we can not connect to a generic proxy with configurable mask
// as is done with TLM1 itfs and the TLM2 basic itfs.
//
// **NOTE**
// Standard SC sockets (initiator & target) require/provide both b and nb intfs.
// SV UVM sockets do either b or nb.  This means a SC-side initiator socket
// must only use the b or nb interface, and the integrator must know which in
// order to connect the appropriate b or nb-only SV UVM socket. If the SC-side
// initiator socket happens to use both b and nb, a connection to SV UVM is
// currently not possible.
//
// **NOTE**
// A blocking only socket is really just a b_transport port/export/imp. There
// is no backward path. Calling them "sockets" is a misnomer and is confusing.
//------------------------------------------------------------------------------

class uvmc_tlm_b_target_comp #(type T=uvm_tlm_generic_payload,
                                    CVRT=uvmc_default_converter#(uvm_object)
                                    /*uvmc_default_converter #(T)*/)
                           extends uvm_component;
  typedef uvmc_tlm2_dispatch #(T,uvm_tlm_phase_e,CVRT) imp_t;
  typedef uvmc_tlm_b_target_comp #(T,CVRT) this_type;
  uvm_tlm_b_target_socket #(this_type,T) target_skt;
  imp_t m_imp;
  uvm_port_base #(uvm_tlm_if #(T,uvm_tlm_phase_e)) m_local_proxy;

  function new(string name, uvm_component parent=null, imp_t imp=null);
    super.new(name, parent);
    target_skt = new(name, this);
    m_imp = imp;
  endfunction

  virtual function void resolve_bindings();
    m_imp.resolve_bindings(UVM_IMPLEMENTATION,`UVM_TLM_B_MASK+
                                              `UVM_TLM_NB_FW_MASK+
                                              `UVM_TLM_NB_BW_MASK);
    super.resolve_bindings();
    if (m_imp.m_locally_connected && m_local_proxy == null)
      m_local_proxy = m_imp.m_imp;
  endfunction

  task b_transport(T t, uvm_tlm_time delay); 
    if (m_local_proxy != null)
      m_local_proxy.b_transport(t,delay);
    else
      m_imp.b_transport(t,delay);
  endtask
endclass


class uvmc_tlm_nb_target_comp #(type T=uvm_tlm_generic_payload,
                                     P=uvm_tlm_phase_e,
                                     CVRT=uvmc_default_converter#(uvm_object)
                                     /*uvmc_default_converter #(T)*/)
                            extends uvm_component;
  typedef uvmc_tlm2_dispatch #(T,P,CVRT) imp_t;
  typedef uvmc_tlm_nb_target_comp #(T,P,CVRT) this_type;
  uvm_tlm_nb_target_socket #(this_type,T,P) target_skt;
  imp_t m_imp;
  //uvm_port_base #(uvm_tlm_if #(T,P)) m_local_proxy;

  function new(string name, uvm_component parent=null, imp_t imp=null);
    super.new(name, parent);
    target_skt = new(name, this);
    m_imp = imp;
  endfunction

  virtual function void resolve_bindings();
    m_imp.resolve_bindings(UVM_IMPLEMENTATION,`UVM_TLM_B_MASK+
                                              `UVM_TLM_NB_FW_MASK+
                                              `UVM_TLM_NB_BW_MASK);
    super.resolve_bindings();
    //if (m_imp.m_locally_connected && m_local_proxy == null)
    //  m_local_proxy = m_imp.m_imp;
  endfunction

  task b_transport(T t, uvm_tlm_time delay); 
    m_imp.b_transport(t,delay);
  endtask
  function uvm_tlm_sync_e nb_transport_fw (T t,
                                           ref uvm_tlm_phase_e p,
                                           input uvm_tlm_time delay); 
    //if (m_local_proxy != null)
    //  return m_local_proxy.nb_transport_fw(t,p,delay);
    return m_imp.nb_transport_fw(t,p,delay);
  endfunction
endclass


class uvmc_tlm_b_initiator_comp #(type T=uvm_tlm_generic_payload,
                                       CVRT=uvmc_default_converter#(uvm_object)
                                       /*uvmc_default_converter #(T)*/)
                              extends uvm_component;
  typedef uvmc_tlm2_dispatch #(T,uvm_tlm_phase_e,CVRT) imp_t;
  typedef uvmc_tlm_b_initiator_comp #(T,CVRT) this_type;
  uvm_tlm_b_initiator_socket #(T) init_skt;
  imp_t m_imp;
  //uvm_port_base #(uvm_tlm_if #(T,uvm_tlm_phase_e)) m_local_proxy;
  function new(string name, uvm_component parent=null, imp_t imp=null);
    super.new(name, parent);
    init_skt = new(name, this);
    m_imp = imp;
  endfunction
  virtual function void resolve_bindings();
    m_imp.resolve_bindings(UVM_PORT,`UVM_TLM_B_MASK+
                                    `UVM_TLM_NB_FW_MASK+
                                    `UVM_TLM_NB_BW_MASK);
    super.resolve_bindings();
    //if (m_imp.m_locally_connected && m_local_proxy == null)
    //  m_local_proxy = m_imp.m_imp;
  endfunction
endclass


class uvmc_tlm_nb_initiator_comp #(type T=uvm_tlm_generic_payload,
                                        P=uvm_tlm_phase_e,
                                        CVRT=uvmc_default_converter#(uvm_object)
                                        /*uvmc_default_converter #(T)*/)
                               extends uvm_component;
  typedef uvmc_tlm2_dispatch #(T,P,CVRT) imp_t;
  typedef uvmc_tlm_nb_initiator_comp #(T,P,CVRT) this_type;
  uvm_tlm_nb_initiator_socket #(this_type,T,P) init_skt;
  imp_t m_imp;
  //uvm_port_base #(uvm_tlm_if #(T,P)) m_local_proxy;

  function new(string name, uvm_component parent=null, imp_t imp=null);
    super.new(name, parent); //, imp);
    init_skt = new(name, this); //, imp);
    m_imp = imp;
  endfunction

  virtual function void resolve_bindings();
    m_imp.resolve_bindings(UVM_PORT,`UVM_TLM_B_MASK+
                                    `UVM_TLM_NB_FW_MASK+
                                    `UVM_TLM_NB_BW_MASK);
    super.resolve_bindings();
    //if (m_imp.m_locally_connected && m_local_proxy == null)
    //  m_local_proxy = m_imp.m_imp;
  endfunction
  function uvm_tlm_sync_e nb_transport_bw (T t,
                                           ref uvm_tlm_phase_e p,
                                           input uvm_tlm_time delay); 
    //if (m_local_proxy != null)
    //  return m_local_proxy.nb_transport_bw(t,p,delay);
    return m_imp.nb_transport_bw(t,p,delay);
  endfunction

endclass


/*
class uvmc_tlm_b_target_socket #(type T=uvm_tlm_generic_payload)
  extends uvm_tlm_b_target_socket #(uvmc_tlm2_dispatch #(T,uvm_tlm_phase_e),T);
  typedef uvmc_tlm2_dispatch #(T,uvm_tlm_phase_e) imp_t;
  imp_t m_imp;
  function new(string name, uvm_component parent=null, imp_t imp=null);
    super.new(name, parent, imp);
    m_imp = imp;
  endfunction
  virtual function void resolve_bindings();
    m_imp.resolve_bindings(UVM_IMPLEMENTATION,m_if_mask);
    super.resolve_bindings();
  endfunction
endclass
*/

/*
can't use socket extension; must be component
class uvmc_tlm_b_initiator_socket #(type T=uvm_tlm_generic_payload)
                      extends uvm_tlm_b_initiator_socket #(T);
  typedef uvmc_tlm2_dispatch #(T,uvm_tlm_phase_e) imp_t;
  imp_t m_imp;
  function new(string name, uvm_component parent=null, imp_t imp=null);
    super.new(name, parent);
    m_imp = imp;
  endfunction
  virtual function void resolve_bindings();
    m_imp.resolve_bindings(UVM_PORT,m_if_mask);
    super.resolve_bindings();
  endfunction
endclass
*/



//------------------------------------------------------------------------------
//
// CLASS: uvmc_tlm #(T,P)
//
// Provides static connect method for connecting TLM2 ports, export, imps, and
// sockets.
//
// Connect to TLM2 socket with default payload, phase, and converter types:
// converter:
//
//|   uvmc_tlm::connect( agent.driver.b_trans_socket, "foo");
//
// Here, we will connect the given b_transport socket and associate it with
// its full name and the string "foo". During binding resolution, these strings
// will be compared to those registered on the SC side. If either string matches
// and the SC-side proxy is of a compatible type and interface, a cross-language
// link is established.
//
// Connect TLM2 nb_target_socket with payload type axi_item, phase type
// axi_phase, and default converter:
//
//|  uvmc_tlm #(axi_item,axi_phase)::connect( agent.driver.nb_target, "bar");
//
//------------------------------------------------------------------------------

class uvmc_tlm #(type T=uvm_tlm_generic_payload, P=uvm_tlm_phase_e,
                      CVRT=uvmc_default_converter#(uvm_object));
                      //uvmc_default_converter #(T));

  typedef uvm_port_base #(uvm_tlm_if #(T,P)) port_type;
  typedef uvmc_tlm2_port_proxy #(T,P,CVRT) proxy_type;
  typedef uvmc_tlm2_dispatch #(T,P,CVRT) x_dispatch_type;


  // Function: connect
  //
  // Connect a proxy to the given TLM2 port, export, or imp.
  //
  // The port's full name and optional ~lookup_name~ string are saved for later
  // lookup during cross-language binding (see <resolve_bindings>).
  //
  // The reason for all the $cast with TLM2:
  //
  // TLM2 sockets in UVM do not conform with uvm_port_base / mask architecture.
  // Thus, we must use $cast to check for legal connection instead of using
  // mask. This prevents polymorphic connections via a uvm_port_base #(IF)
  // handle. Need to fix socket impl in UVM

  static function void connect (port_type port,
                                string lookup_name="",
                                uvm_packer packer=null);

    // Sockets require binding to actual concrete component types due to their
    // architecture. We thus need to determine what type the ~port~ is via
    // $cast and then create and connect a compatible proxy type. We $cast to
    // the _base type because the non-passthru subtypes contain an IMP
    // parameter whose type we know nothing about.
    uvm_tlm_b_target_socket_base #(T) bt;
    uvm_tlm_b_initiator_socket_base #(T) bi;
    uvm_tlm_nb_target_socket_base #(T,P) nbt; 
    uvm_tlm_nb_initiator_socket_base #(T,P) nbi;
    uvm_tlm_nb_passthrough_initiator_socket_base #(T,P) nbpi;
    uvm_tlm_nb_passthrough_target_socket_base #(T,P) nbpt;
    uvm_tlm_b_passthrough_initiator_socket_base #(T) bpi;
    uvm_tlm_b_passthrough_target_socket_base #(T) bpt;


    x_dispatch_type m_x_dispatch;
    uvmc_report_catcher catcher;

    print_x_banner();

    if (!uvm_disable_ILLCRT) begin
      catcher = new();
      uvm_report_cb::add(null,catcher);
      uvm_disable_ILLCRT = 1;
    end

    if ($cast(bt,port) || $cast(bpt,port)) begin
        uvmc_tlm_b_initiator_comp #(T, CVRT) comp;
        m_x_dispatch = new(port.get_full_name(), lookup_name, packer, null);
        comp = new({"UVMC_COMP_WITH_B_INITIATOR_SOCKET_FOR_",
                   port.get_full_name()},null,m_x_dispatch);
        m_x_dispatch.m_imp = comp.init_skt;
        comp.init_skt.connect(port);
        return;
    end
    else if ($cast(nbt,port) || $cast(nbpt,port)) begin
        uvmc_tlm_nb_initiator_comp #(T, P, CVRT) comp;
        m_x_dispatch = new(port.get_full_name(), lookup_name, packer, null);
        comp = new({"UVMC_COMP_WITH_NB_INITIATOR_SOCKET_FOR_",
                   port.get_full_name()},null,m_x_dispatch);
        m_x_dispatch.m_imp = comp.init_skt;
        comp.init_skt.connect(port);
        return;
    end
    else if ($cast(bi,port) || $cast(bpi,port)) begin
        uvmc_tlm_b_target_comp #(T, CVRT) comp;
        m_x_dispatch = new(port.get_full_name(), lookup_name, packer, null);
        comp = new({"UVMC_COMP_WITH_B_TARGET_SOCKET_FOR_",
                   port.get_full_name()},null,m_x_dispatch);
        m_x_dispatch.m_imp = comp.target_skt;
        port.connect(comp.target_skt);
        return;
    end
    else if ($cast(nbi,port) || $cast(nbpi,port)) begin
        uvmc_tlm_nb_target_comp #(T, P, CVRT) comp;
        m_x_dispatch = new(port.get_full_name(), lookup_name, packer, null);
        comp = new({"UVMC_COMP_WITH_NB_TARGET_SOCKET_FOR_",
                   port.get_full_name()},null,m_x_dispatch);
        m_x_dispatch.m_imp = comp.target_skt;
        port.connect(comp.target_skt);
        return;
    end

    // If we get here, the ~port~ is not a socket type, so we assume
    // it's a port/export/imp typed to one of the TLM2 primitive interfaces
    // (b_transport, nb_transport_fw, or nb_transport_bw). We can bind
    // to a generic proxy that implements all the interfaces, i.e. its
    // mask is compatible with all possible ~port~ types.

    if (port.is_port()) begin
      proxy_type proxy = new(port, lookup_name, UVM_IMPLEMENTATION, packer);
      port.connect(proxy);
    end
    else begin
      proxy_type proxy = new(port, lookup_name, UVM_PORT, packer);
      proxy.connect(port);
    end
  endfunction


  // Function: connect_hier
  //
  // Make a hierarchical (parent-child) connection across the language
  // boundary, where SV is the parent to an SC-side implementation.
  //
  // If ~port~ is an EXPORT, bind it to an IMP proxy, which acts as
  // the implementation of the SV-side ~export~.
  //
  // If ~port~ is a PORT type, bind it to a PORT proxy, which acts as a
  // child driving the ~port~. SC will drive the ~port~.
  //
  // If ~port~ is an IMP, produce an error. Only ~connect~ can be
  // used to bind to an imp.

  static function void connect_hier (port_type port,
                                     string lookup_name="",
                                     uvm_packer packer=null);

    // See above for explanation of why we have so many $casts for socket
    // connections.
    uvm_tlm_b_target_socket_base #(T) bt;
    uvm_tlm_b_initiator_socket_base #(T) bi;
    uvm_tlm_nb_target_socket_base #(T,P) nbt; 
    uvm_tlm_nb_initiator_socket_base #(T,P) nbi;

    uvm_tlm_nb_passthrough_initiator_socket_base #(T,P) nbpi;
    uvm_tlm_nb_passthrough_target_socket_base #(T,P) nbpt;
    uvm_tlm_b_passthrough_initiator_socket_base #(T) bpi;
    uvm_tlm_b_passthrough_target_socket_base #(T) bpt;


    x_dispatch_type m_x_dispatch;
    uvmc_report_catcher catcher;

    print_x_banner();

    if (!uvm_disable_ILLCRT) begin
      catcher = new();
      uvm_report_cb::add(null,catcher);
      uvm_disable_ILLCRT = 1;
    end


    if ($cast(bpt,port)) begin
        uvmc_tlm_b_target_comp #(T, CVRT) comp;
        m_x_dispatch = new(port.get_full_name(), lookup_name, packer, null);
        comp = new({"UVMC_COMP_WITH_B_TARGET_SOCKET_FOR_",
                   port.get_full_name()},null,m_x_dispatch);
        m_x_dispatch.m_imp = comp.target_skt;
        port.connect(comp.target_skt);
        return;
    end
    else if ($cast(nbpt,port)) begin
        uvmc_tlm_nb_target_comp #(T, P, CVRT) comp;
        m_x_dispatch = new(port.get_full_name(), lookup_name, packer, null);
        comp = new({"UVMC_COMP_WITH_NB_TARGET_SOCKET_FOR_",
                   port.get_full_name()},null,m_x_dispatch);
        m_x_dispatch.m_imp = comp.target_skt;
        port.connect(comp.target_skt);
        return;
    end
    else if ($cast(bpi,port)) begin
        uvmc_tlm_b_initiator_comp #(T, CVRT) comp;
        m_x_dispatch = new(port.get_full_name(), lookup_name, packer, null);
        comp = new({"UVMC_COMP_WITH_B_INITIATOR_SOCKET_FOR_",
                   port.get_full_name()},null,m_x_dispatch);
        m_x_dispatch.m_imp = comp.init_skt;
        comp.init_skt.connect(port);
        return;
    end
    else if ($cast(nbpi,port)) begin
        uvmc_tlm_nb_initiator_comp #(T, P, CVRT) comp;
        m_x_dispatch = new(port.get_full_name(), lookup_name, packer, null);
        comp = new({"UVMC_COMP_WITH_NB_INITIATOR_SOCKET_FOR_",
               port.get_full_name()},null,m_x_dispatch);
        m_x_dispatch.m_imp = comp.init_skt;
        comp.init_skt.connect(port);
        return;
    end

    if ($cast(nbpi,port) || $cast(bpt,port) ||
        $cast(nbpt,port) || $cast(bpi,port)) begin
      `uvm_fatal("UVMC/ILL_CONNECT",{"The socket '",port.get_full_name(),
                  "' cannot be connected using connect_hier. Only passthrough",
                  " sockets can be connected using connect_hier"});
    end

    // If we made it here, we're not a socket. We're a port, export, or imp
    // 
    if (port.is_port()) begin
      proxy_type proxy = new(port, lookup_name, UVM_PORT, packer);
      proxy.connect(port);
    end
    else if (port.is_export()) begin
      proxy_type proxy = new(port, lookup_name, UVM_IMPLEMENTATION, packer);
      port.connect(proxy);
    end
    else begin
      `uvm_fatal("UVMC/ILL_CONNECT",{"The imp '",port.get_full_name(),
                  "' cannot be connected using connect_hier"});
    end

  endfunction


endclass


