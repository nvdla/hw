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

// Blocking call completion notification
import "DPI-C"  context function bit SV2C_blocking_req_done(int m_x_id);
import "DPI-C"  context function bit SV2C_blocking_rsp_done(int m_x_id,
                                                            bits_t bits,
                                                            uint64 delay);
export "DPI-C"  function C2SV_blocking_req_done;
export "DPI-C"  function C2SV_blocking_rsp_done;


// UVMC-port resolution
import "DPI-C"  context function int SV2C_resolve_binding
            (
            string sv_port_name,  // port name use when looking for a match
            string sv_target,     // alternate name to look for match
            string sv_trans_type, // transaction type for checking compatibility
            int    dummy,
            int    sv_proxy_type, // port type for checking compatibility
            int    sv_mask,       // mask for checking compatibility
            int    sv_id,         // SV-side ID
            output int sc_id      // SC-side matching ID
            );


//------------------------------------------------------------------------------
//
// CLASS: uvmc_convert #(T)
//
// The virtual base class from which all transaction converters derive.
//
// UVMC Converts an object of type T to/from the canonical type, bits_t. 
//
// Default implementation delegates to pack/unpack methods in class.
//
// PRIVATE! - all code in base converter is not for public use -
//            DO NOT USE - subject to change without notice
//
//------------------------------------------------------------------------------

class uvmc_converter #(type T=int);

  
  static uvm_object obj;

  // Internal methods for preloading bits into packer for unpacking and
  // getting bits from packer after packing.

  // set bits to 0 before packing?
  //   bits = '{ default:'0};
  //If encode size of packed ints in first word, don't need to copy whole array
  //   bits[0] = size;
  //   foreach(ints[i])
  //     bits[i+1] = ints[i];

  static function void m_pre_pack (T t,
                                   uvm_packer packer);
    if ($cast(obj,t)) begin
    `ifdef OVMC
      ovm_auto_options_object.packer=packer;
      packer.scope.down(obj.get_name(),t);
    `else
      obj.__m_uvm_status_container.packer = packer;
      packer.scope.down(obj.get_name());
    `endif
    end
    packer.reset();
  endfunction

  // copy packer.m_bits (a fixed bit array) into bits (a fixed word array)
  // we don't use the packer's get_ints because that returns a dynamic array
  // and we want to avoid another full copy
  static function void m_post_pack (ref bits_t bits,
                                    input T t,
                                    uvm_packer packer);
    int cnt, sz;
    packer.set_packed_size();
    sz = (packer.m_packed_size+31) / 32;
    // bits[0] = sz;
    // bits[1] = t.get_inst_id();
    // sz += 2;
    if (packer.big_endian) begin
      int unsigned raw;
      int unsigned val;
      for (int i=0; i<sz; i++) begin
        raw = packer.m_bits[cnt +: 32];
        for (int j=0; j<32; j++)
          val[j] = raw[31-j];
        bits[i] = val;
        cnt += 32;
      end
    end
    else begin
      for (int i=0; i<sz; i++) begin
        bits[i] = packer.m_bits[cnt +: 32];
        cnt += 32;
      end
    end
    if (obj != null)
    `ifdef OVMC
      packer.scope.up(t);
    `else
      packer.scope.up();
    `endif
    obj=null;
  endfunction

  // copy 'bits' (a fixed word array) into packer.m_bits (a fixed bit array)
  // we don't use the packer's put_ints because that requires us to copy our
  // word array into a dynamic array first, and we want to avoid extra copying
  static function void m_pre_unpack (ref bits_t bits,
                                     input T t,
                                     uvm_packer packer);
    static int cnt;
    // note: the use of t.__m_uvm_status_container and scope.down(t.get_name())
    // requires T to be a uvm_object derivative. 
    int index;
    if (t != null && $cast(obj,t)) begin
      // t.set_name($sformatf("trans%0d",++cnt));
      `ifdef OVMC
        ovm_auto_options_object.packer=packer;
        packer.scope.down(obj.get_name(),t);
      `else
        obj.__m_uvm_status_container.packer = packer;
        packer.scope.down(obj.get_name());
      `endif
    end
    packer.reset();
    // sz = bits[0];
    // inst_id = bits[1];
    // sz += 2;
    if (packer.big_endian) begin
      int unsigned raw, val;
      foreach (bits[i]) begin
        raw = bits[i];
        for (int j=0; j<32; j++)
          val[j] = raw[31-j];
        packer.m_bits[index +: 32] = val;
        index += 32;
      end
    end
    else begin
      foreach (bits[i]) begin
        packer.m_bits[index +: 32] = bits[i];
        index += 32;
      end
    end
    packer.m_packed_size = index;
    packer.count = 0;
  endfunction

  static function void m_post_unpack (T t,
                                      uvm_packer packer);
    `ifndef OVMC
    uvm_tlm_generic_payload gp;
    if ($cast(gp,t)) begin
      //byte unsigned be[];
      //gp.get_byte_enable(be);
      gp.set_byte_enable_length(gp.m_byte_enable.size());
    end
    if (obj != null)
      packer.scope.up();
    `else
    if (obj != null)
      packer.scope.up(t);
    `endif
    obj=null;
  endfunction

endclass



//------------------------------------------------------------------------------
//
// CLASS- uvmc_default_converter #(T)
//
// Converts an object of type T to/from the canonical type using the uvm_packer. 
//
// Default implementation delegates to T's pack/unpack methods, which use the
// uvm_packer.
//
//------------------------------------------------------------------------------

`ifdef OVMC
parameter int UVM_PACK = OVM_PACK;
parameter int UVM_UNPACK = OVM_UNPACK;
`endif

class uvmc_default_converter #(type T=int) extends uvmc_converter #(T);

  // Function: do_pack
  //
  // Convert an object of type T to the canonical type, bits_t.
  // The default implementation requires T be derived from uvm_object, whose
  // uvm_object::do_pack or `uvm_field macros provide the packing functionality.

  static function void do_pack(T t, uvm_packer packer);
    if (t == null)
      `uvm_fatal("UVMC",
         "Null transaction handle passed to uvmc_default_converter::do_pack")
    `ifdef OVMC
      t.m_field_automation(null, UVM_PACK, "");
    `else
      t.__m_uvm_field_automation(null, UVM_PACK, "");
    `endif
    t.do_pack(packer);
  endfunction


  // Function: do_unpack
  //
  // Unpacks the canonical bits_t type into an object of type T.
  // The default implementation requires T be derived from uvm_object, whose
  // uvm_object::do_unpack or `uvm_field macros provide the unpacking
  // functionality.

  static function void do_unpack(T t, uvm_packer packer);
    if (t == null)
      `uvm_fatal("UVMC",
         "Null transaction handle passed to uvmc_default_converter::do_unpack")
    `ifdef OVMC
      t.m_field_automation(null, UVM_UNPACK, "");
    `else
      t.__m_uvm_field_automation(null, UVM_UNPACK, "");
    `endif
    t.do_unpack(packer);
  endfunction

endclass


//------------------------------------------------------------------------------
//
// CLASS: uvmc_base
//
// The common base class for TLM proxy ports, exports, and sockets. Each proxy
// has a numeric ID assigned to it. Requests from C must provide the ID of the
// proxy it is targeting, along with any other argument(s) needed for the
// particular request. 
//
// SC->SV:
// Requests from SC provide an ID and canonical bit vector representing the
// transation. The bits are forwarded to the port proxy registered with the
// given ID. The SV-side proxy will unpack the bits into a SV object and
// forward it to the connected target.
//
// SV->SC:
// Transaction objects are first converted to bits. Then a cross-language
// call is made that provides the ID of the SC-side port proxy along with the
// converted bits. The SC-side proxy will unpack those bits into a SC-side
// object and forward it to the connected target.
//------------------------------------------------------------------------------

virtual class uvmc_base;

  // Extensions of this class implement either the TLM1 or TLM2 "typeless" API

  // "Typeless" TLM1 API
  virtual function void x_put      (ref bits_t bits);           endfunction
  virtual function bit  x_try_put  (ref bits_t bits); return 0; endfunction
  virtual function bit  x_can_put  ();                return 0; endfunction
  virtual function void x_get      ();                          endfunction
  virtual function bit  x_try_get  (ref bits_t bits); return 0; endfunction
  virtual function bit  x_can_get  ();                return 0; endfunction
  virtual function void x_peek     ();                          endfunction
  virtual function bit  x_try_peek (ref bits_t bits); return 0; endfunction
  virtual function bit  x_can_peek ();                return 0; endfunction
  virtual function void x_write    (ref bits_t bits); return;   endfunction
  virtual function void x_transport(ref bits_t bits);           endfunction
  virtual function bit  x_try_transport(ref bits_t bits); return 0; endfunction

  // typeless TLM2 API
  virtual function int x_nb_transport_fw (ref bits_t bits,
                                           inout uint32 phase,
                                           inout uint64 delay);
    return 0;
  endfunction

  virtual function int x_nb_transport_bw (ref bits_t bits,
                                           inout uint32 phase,
                                           inout uint64 delay);
    return 0;
  endfunction

  virtual function void x_b_transport (ref bits_t bits,
                                        inout uint64 delay);
  endfunction

  // Blocking calls (put, get, peek, transport, b_transport) to C actually
  // do not block on the SC side. The 'get' method, for example, is a function;
  // it returns immediately. The 'get' is a non-blocking request for a new
  // transaction. The uvmc_tlm1_map::get implementation executes SV2C_get
  // then waits for an event notifying the bits for the requested transaction
  // have arrived. We do this in order to implement the transfers using
  // standard DPI-C, which do not have built-in context switching.

  virtual function void blocking_rsp_done(ref bits_t bits, input uint64 delay);
  endfunction

  virtual function void blocking_req_done();
  endfunction

  uvm_packer packer;

  static uvmc_base x_ports[$];
  static int x_port_names[string];

  // PRIVATE - IMPLEMENTATION
  local     string m_lookup_name;       // the optional lookup string used during binding resolution 
  /*local*/ bit    m_locally_connected; // we are connected to SV-side port/export/imp
  local     bit    m_x_connected;      // we are connected to SC-side proxy
  /*local*/protected int    m_id;       // SV-side id, used by SC-side proxy
  /*local*/ int    m_x_id = 0;        // SC-side id, or SV-side id. used by extensions of this proxy
  /*local*/ string m_port_name;
  // PRIVATE - IMPLEMENTATION end

  // Disabled: name-based lookups not possible without mods to UVM
  // extern function automatic int uvmc_resolve_name_pair(string port1_name, string port2_name);


  pure virtual function string get_full_name();


  // Function: new
  //
  // Creates and registers a proxy to the given port for cross-language communication.
  // Its name and the optional lookup_name are registered in global arrays.
  //
  // Port resolution is deferred until resolve_bindings, just before UVM-SV'a
  // end_of_elaboration phase.
  //
  // uvmc_ports must be driven by SC-side ports. Its name, or the optional
  // lookup name supplied during registration, must be successfully mapped
  // to a compatible port on the SC side that was registered with one of the
  // same names.
  //
  // uvmc_channels must drive SC-side exports or interface implementations.
  // Like uvmc_ports, its registered name and optional lookup name must
  // be mapped to a compatible export/interface on the SC side.

  function new(string port_name, string lookup_name="", uvm_packer packer=null);

    int id;

    m_port_name = port_name;
    m_lookup_name = lookup_name;

    assert(port_name != "");

    $write("Registering SV-side '",port_name,"'");
    if (lookup_name != "")
      $write(" and lookup string '",lookup_name,"'");
    $display(" for later connection with SC");
    // id=%0d",id);

    // check that port isn't already registered
    if (x_port_names.exists(port_name)) begin
      int local_id = x_port_names[port_name];
      uvmc_base exist_port = x_ports[local_id];
      if (exist_port.m_x_id != 0) begin
        uvmc_base bound_port = x_ports[exist_port.m_x_id];
        `uvm_fatal("UVMC",{"Port '",exist_port.m_port_name,
                   "' is already bound to '", bound_port.get_full_name(),"'"})
        return;
      end
      `uvm_warning("UVMC",{"Making local SV connection between '",
                   exist_port.m_port_name,"' and '", port_name})
      m_locally_connected = 1;
      m_x_id = local_id;
      id = x_ports.size();
      x_ports.push_back(this);
      x_port_names[port_name] = id;
      exist_port.m_x_id = id;
      exist_port.m_locally_connected = 1;
      return;
    end

    // check that lookup_name isn't already registered
    if (lookup_name != "" && x_port_names.exists(lookup_name)) begin
      int local_id = x_port_names[lookup_name];
      uvmc_base exist_port = x_ports[local_id];
      if (exist_port.m_x_id != 0) begin
        uvmc_base bound_port = x_ports[exist_port.m_x_id];
        `uvm_fatal("UVMC",$sformatf("Lookup string '%s' was already used to connect '%s' to '%s'.",
                 lookup_name,exist_port.m_port_name, bound_port.get_full_name()))
        return;
      end
      `uvm_warning("UVMC",$sformatf("Lookup string '%s' is being used to make a local SV connection between '%s' and '%s'.",
                  lookup_name,exist_port.m_port_name, port_name))
      m_locally_connected = 1;
      m_x_id = local_id;
      id = x_ports.size();
      x_ports.push_back(this);
      x_port_names[port_name] = id;
      exist_port.m_x_id = id;
      exist_port.m_locally_connected = 1;
      return;
    end

    if (x_ports.size()==0)
      x_ports.push_back(null);

    id = x_ports.size();

    x_ports.push_back(this);
    x_port_names[port_name] = id;

    if (lookup_name != "")
      x_port_names[lookup_name] = id;

    if (packer == null) begin
      packer = new();
      packer.use_metadata = 1;
      packer.big_endian = 0;
    end

    this.packer = packer;

  endfunction


  // Function: resolve_bindings
  //
  // Resolves the cross-language binding, where the port name and optional lookup string
  // are matched with a corresponding proxy channel name/x_id string on the SC side.
  //
  virtual function void resolve_bindings(uvm_port_type_e proxy_kind, int if_mask);

   string unknown = "unknown";
   int kind = proxy_kind;
   int dummy = 0;

    if (m_x_connected)
      return;


    m_x_connected = 1; // don't try to resolve more than once

    //$display("*** RESOLVE_BINDINGS  proxy_kind=%0d  if_mask=%0h", kind, if_mask);

    m_id = this.x_port_names[m_port_name];

    if (m_x_id == 0 && !SV2C_resolve_binding(m_port_name,m_lookup_name,unknown, dummy, kind,
                              if_mask, m_id, m_x_id)) begin
      `uvm_error("UVMC",{"Cannot bind SV-side UVMC proxy with name '",
                           m_port_name,"'", m_lookup_name==""?"":
                           {" or its alternative lookup name, '",
                           m_lookup_name,"' (mask=",$sformatf("%0h)",if_mask)} })
      return;
    end
  endfunction
 

endclass: uvmc_base



//------------------------------------------------------------------------------
//
// Group: C2SV_*
//
// The C2SV_*_done methods indicate blocking operation completion to SV from SC.
//------------------------------------------------------------------------------

`define __UVMC_GET_PORT__ \
    uvmc_base port; \
    if (x_id < 0 || x_id >= uvmc_base::x_ports.size()) begin \
      `uvm_fatal("UVMC",$sformatf("Internal error (%m): invalid id %0d",x_id)) \
      $finish; \
    end \
    port = uvmc_base::x_ports[x_id]; \
    if (port == null) begin \
      `uvm_fatal("UVMC",$sformatf("Internal error (%m): port at id %0d is null",x_id)) \
      $finish; \
    end \
    //if (!m_end_of_uvm_elab) \
    //  connect_ph.wait_done(); \
    //m_end_of_uvm_elab = 1; 


function void C2SV_blocking_rsp_done(int x_id, bits_t bits, uint64 delay);
  `__UVMC_GET_PORT__
  port.blocking_rsp_done(bits,delay);
endfunction

function void C2SV_blocking_req_done(int x_id);
  `__UVMC_GET_PORT__
  port.blocking_req_done();
endfunction


`ifndef OVMC
bit uvm_disable_ILLCRT;

// Class- uvmc_report_catcher

class uvmc_report_catcher extends uvm_report_catcher;
   static int seen = 0;
   virtual function action_e catch();
     if (get_id() == "ILLCRT")
       return CAUGHT;
      return THROW;
   endfunction
endclass

`endif // OVMC

