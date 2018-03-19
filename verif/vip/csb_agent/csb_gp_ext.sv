`ifndef _CSB_GP_EXT_SV_
`define _CSB_GP_EXT_SV_

//-------------------------------------------------------------------------------------
//
// File: csb_gp_ext
//
// In order to adapt to CMOD transaction type, csb transaction will be extended 
// from uvm_tlm_generic_payload base class. All csb protocol fields will be mapped
// to tlm2 generic payload, and one extension instances are needed here, that is 
// nonposted field extension.csb txn can be used directly through TLM2.0 in SC<->SV 
// convertor.
//
// Field Mapping:
// 
// [63:0] m_address              <---------------> [`CSB_ADDR_WIDTH-1:0] address
// m_command                     <---------------> READ/WRITE
// byte unsigned m_data[]        <---------------> [`CSB_DATA_WIDTH-1:0] data
// m_length                      <---------------> `CSB_DATA_WIDTH/8
// byte unsigned m_byte_enable[] <---------------> (`CSB_DATA_WIDTH/8)`{8'hFF}
// m_byte_enable_length          <---------------> `CSB_DATA_WIDTH/8
// m_streaming_width             <---------------> `CSB_DATA_WIDTH/8
//
// protocol extension            <--------------->  csb_bus_ext
// drive control extension       <--------------->  csb_ctrl_ext
//-------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------
//
// CLASS: csb_bus_ext
//
// Define one extenstion type for nposted field in CSB protocol. This extension type
// will be instanced and be added to m_extensions by calling set_extension() to tlm gp
//
//-------------------------------------------------------------------------------------

class csb_bus_ext extends uvm_tlm_extension#(csb_bus_ext);
    protected rand bit m_nposted;

    `uvm_object_utils_begin(csb_bus_ext)
        `uvm_field_int(m_nposted, UVM_ALL_ON)
    `uvm_object_utils_end

    extern function new(string name = "csb_bus_ext");

    extern function void set_nposted(bit _nposted);
    extern function bit  get_nposted();
    extern function bit  is_nposted();

    constraint c_nposted {
        m_nposted dist {0:=80, 1:=20};
    }

endclass : csb_bus_ext

// Function: new
// Creates a new CSB GP EXT object
function csb_bus_ext::new(string name = "csb_bus_ext");
    super.new(name);
endfunction : new

// Function: set_nposted
function void csb_bus_ext::set_nposted(bit _nposted);
    m_nposted = _nposted;
endfunction : set_nposted

// Function: get_nposted
function bit csb_bus_ext::get_nposted();
    return m_nposted;
endfunction : get_nposted

// Function: is_nposted
function bit csb_bus_ext::is_nposted();
    return m_nposted;
endfunction : is_nposted

//-------------------------------------------------------------------------------------
//
// CLASS: csb_ctrl_ext
//
//
//-------------------------------------------------------------------------------------

class csb_ctrl_ext extends uvm_tlm_extension#(csb_ctrl_ext);
    protected int      m_c_start;   // Cycle number for starting of txn
    protected int      m_c_end;     // Cycle number for ending of txn
    protected longint  m_t_start;   // Timestamp for starting of txn
    protected longint  m_t_end;     // Timestamp for ending of txn

    protected rand int m_pvld_delay;
    protected rand int m_txn_delay;

    `uvm_object_utils_begin(csb_ctrl_ext)
        `uvm_field_int(m_c_start,    UVM_ALL_ON)
        `uvm_field_int(m_c_end,      UVM_ALL_ON)
        `uvm_field_int(m_t_start,    UVM_ALL_ON)
        `uvm_field_int(m_t_end,      UVM_ALL_ON)
        `uvm_field_int(m_pvld_delay, UVM_ALL_ON)
        `uvm_field_int(m_txn_delay,  UVM_ALL_ON)
    `uvm_object_utils_end

    extern function new(string name = "csb_ctrl_ext");

    extern function void set_c_start   (int _c_start);
    extern function void set_c_end     (int _c_end);
    extern function void set_t_start   (longint _t_start);
    extern function void set_t_end     (longint _t_end);
    extern function void set_pvld_delay(int _pvld_delay);
    extern function void set_txn_delay (int _txn_delay);
    extern function int  get_pvld_delay();
    extern function int  get_txn_delay ();

    constraint c_pvld_delay {
        m_pvld_delay dist {0:=50, [1:10]:/50};
    }

    constraint c_txn_delay {
        m_txn_delay dist {0:=50, [1:10]:/50};
    }

endclass : csb_ctrl_ext

// Function: new
// Creates a new CSB GP EXT object
function csb_ctrl_ext::new(string name = "csb_ctrl_ext");
    super.new(name);
endfunction : new

function void csb_ctrl_ext::set_c_start(int _c_start);
    m_c_start = _c_start;
endfunction : set_c_start

function void csb_ctrl_ext::set_c_end(int _c_end);
    m_c_end = _c_end;
endfunction : set_c_end

function void csb_ctrl_ext::set_t_start(longint _t_start);
    m_t_start = _t_start;
endfunction : set_t_start

function void csb_ctrl_ext::set_t_end(longint _t_end);
    m_t_end = _t_end;
endfunction : set_t_end

function void csb_ctrl_ext::set_pvld_delay(int _pvld_delay);
    m_pvld_delay = _pvld_delay;
endfunction : set_pvld_delay

function void csb_ctrl_ext::set_txn_delay(int _txn_delay);
    m_txn_delay = _txn_delay;
endfunction : set_txn_delay

function int csb_ctrl_ext::get_pvld_delay();
    return m_pvld_delay;
endfunction : get_pvld_delay

function int csb_ctrl_ext::get_txn_delay();
    return m_txn_delay;
endfunction : get_txn_delay


`endif // _CSB_GP_EXT_SV_
