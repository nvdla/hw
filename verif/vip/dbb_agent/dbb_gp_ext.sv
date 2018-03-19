`ifndef _DBB_GP_EXT_SV_
`define _DBB_GP_EXT_SV_

//-------------------------------------------------------------------------------------
//
// File: dbb_gp_ext
//
// In order to adapt to CMOD transaction type, transaction dbb_gp will be extended 
// from uvm_tlm_generic_payload base class. All dbb protocol fields will be mapped
// to tlm2 generic payload, and extra extension instances are created and added. 
// Therefore, dbb_gp can be used directly through TLM2.0 in SC<->SV convertor.
//
// Field Mapping:
// 
// [63:0] m_address              <---------------> 
// m_command                     <---------------> 
// byte unsigned m_data[]        <---------------> 
// m_length                      <---------------> // We use tr.get_data_length to get the current size of m_data. This changes throughout the life of the txn and should not be considered an accurate way to measure m_data.size until sent to mem_model or analysis port. Use tr_helper.n_data*tr_bus.get_size for an expected size of m_data or use beatnum*tr_bus.get_size to find the starting point for a beat
// byte unsigned m_byte_enable[] <---------------> 
// m_byte_enable_length          <---------------> // This along with m_length need to be set manually. Using set_data or set_byte_enable has no effect on this variable
// m_streaming_width             <---------------> 
//
// extension
//-------------------------------------------------------------------------------------


//-------------------------------------------------------------------------------------
//
// CLASS: dbb_bus_ext
//
// Define one extenstion type for extra fields in DBB protocol. This extension type
// will be instanced and be added to m_extensions in uvm_tlm_gp by calling 
// set_extension()
//-------------------------------------------------------------------------------------

class dbb_bus_ext extends uvm_tlm_extension#(dbb_bus_ext);
    protected int unsigned m_id;
    protected int unsigned m_size; // Bytes per beat (taken from a[rw]size)
    protected int unsigned m_length; // Number of total beats expected (taken from a[rw]len)

    `uvm_object_utils_begin(dbb_bus_ext)
        `uvm_field_int(m_id,     UVM_ALL_ON)
        `uvm_field_int(m_size,   UVM_ALL_ON)
        `uvm_field_int(m_length, UVM_ALL_ON)
    `uvm_object_utils_end

    extern function new(string name = "dbb_bus_ext");

    extern function void set_id(int unsigned _id);
    extern function void set_size(int unsigned _size);
    extern function void set_length(int unsigned _length);
    extern function int unsigned get_id();
    extern function int unsigned get_size();
    extern function int unsigned get_length();

endclass : dbb_bus_ext

// Function: new
// Creates a new DBB EXTENSION object
function dbb_bus_ext::new(string name = "dbb_bus_ext");
    super.new(name);
endfunction : new

// Function: set_id
function void dbb_bus_ext::set_id(int unsigned _id);
    m_id = _id;
endfunction : set_id

// Function: set_size in bytes
function void dbb_bus_ext::set_size(int unsigned _size);
    m_size = _size;
endfunction : set_size

// Function: set_length
function void dbb_bus_ext::set_length(int unsigned _length);
    m_length = _length;
endfunction : set_length

// Function: get_id
function int unsigned dbb_bus_ext::get_id();
    return m_id;
endfunction : get_id

// Function: get_size in bytes
function int unsigned dbb_bus_ext::get_size();
    return m_size;
endfunction : get_size

// Function: get_length
function int unsigned dbb_bus_ext::get_length();
    return m_length;
endfunction : get_length

//-------------------------------------------------------------------------------------
//
// CLASS: dbb_ctrl_ext
//
// This extension is used to define configuration parameters which are used by dbb 
// driver to control specific drive behavior, like valid-ready delay control, etc.
//-------------------------------------------------------------------------------------

class dbb_ctrl_ext extends uvm_tlm_extension#(dbb_ctrl_ext);

    /// Response Type
    typedef enum {OKAY   = 0,
                  EXOKAY = 1,
                  SLVERR = 2,
                  DECERR = 3,
                  INCOMPLETE = 4
                  } resp_type_e;

    /// Transaction Status Enum definition
    typedef enum {NVDLA_TS_NORMAL = 0,
                  NVDLA_TS_RESET,
                  NVDLA_TS_ABORT,
                  NVDLA_TS_DROP} nvdla_transtat_e;

   /// @name Configuration Parameters
   /// nvdla DBB Slave Transaction UVM Configuration Parameters
   ///@{
    rand int out_of_order = 0;        ///< Allows specified number of like transactions to complete before this one.

    rand int address_rvalid_delay = 0;///< Delay after address accepted to first read data response beat.

    rand int aready_delay = 0;        ///< Min cycles that Aready will be driven low after AValid and Aready
                                      ///< are both true. Can delay response to the next transaction

    rand int avalid_aready_delay = 0; ///< Delay from sampling Avalid high to Aready high.
                                      ///< Zero means the cycle after. If Aready already high by default
                                      ///< setting, this delay will have no effect for the txn.

    rand int wready_delay[];          ///< Cycles that Wready will be driven low after WValid and Wready
                                      ///< are both true. Can delay the start of the next handshake.

    rand int wvalid_wready_delay[];   ///< Minimum delay between sampling Wvalid to driving Wready.
                                      ///< Zero means the cycle after. If Wready already high by default
                                      ///< setting, this delay will have no effect for the txn.

    rand int next_rvalid_delay[];     ///< Delay after read beat transferred until next read beat

    rand int write_bvalid_delay = 0;  ///< Delay from transmission of last beat of write data to write response.
                                      ///< A negative value for this parameter has special meaning, it means we're
                                      ///< going to be controlling when a response is issued externally, through the
                                      ///< EXT_WRESPONSE_SYNC event trigger.

    rand resp_type_e resp[];          ///< Returned response type from a txn. Write txns only have
                                      ///< a single response, and will always use resp[0].
                                      ///< For dbb_master_driver this array will be used to store the
                                      ///< observed value. It might also contain values to be
                                      ///< checked as they come off the bus depending on the value
                                      ///< of dbb_master_txn::check_data.
                                      ///< For dbb_slave_driver this array might be
                                      ///< automatically generated, depending on the values in
                                      ///< dbb_slave_txn::StatusError[]. In any case, the response
                                      ///< can be overridden before being driven in the pre_response
                                      ///< callback.

    /// Transaction Status.
    /// This status field is used whenever a transaction does not complete normally. It is
    /// intended to provide the reason as to why the transaction did not complete.
    /// NVDLA_TS_NORMAL - Transaction completed normally (default)
    /// NVDLA_TS_RESET  - Transaction was killed as a result of a bus reset
    /// NVDLA_TS_ABORT  - Transaction was aborted according to bus protocol
    /// NVDLA_TS_DROP   - Transaction was dropped, usually via the a pre_trans callback routine
    nvdla_transtat_e transtat  = NVDLA_TS_NORMAL;
   ///@}

    // Event Notifications
    uvm_event TXN_STARTED;
    uvm_event TXN_ENDED;
    uvm_event DATA_STARTED;      ///< Data Started notification.
    uvm_event DATA_ENDED;        ///< Data Ended notification.
    uvm_event ADDRESS_STARTED;   ///< Address Started notification.
    uvm_event ADDRESS_ENDED;     ///< Address Ended notification.

    `uvm_object_utils_begin(dbb_ctrl_ext)
        `uvm_field_int(out_of_order,                        UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(address_rvalid_delay,                UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(aready_delay,                        UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(avalid_aready_delay,                 UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_array_int(wready_delay,                  UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_array_int(wvalid_wready_delay,           UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_array_int(next_rvalid_delay,             UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(write_bvalid_delay,                  UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_enum(nvdla_transtat_e, transtat,         UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_array_enum(resp_type_e,resp,             UVM_ALL_ON | UVM_NOCOMPARE)    
    `uvm_object_utils_end

    extern function new(string name = "dbb_ctrl_ext");
    extern function void set_response_status(ref uvm_tlm_gp tr, uvm_tlm_response_status_e status );
    extern function uvm_tlm_response_status_e get_response_status(uvm_tlm_gp tr);
    extern function void size_txn_arrays(int size);
    extern function void resize_txn_arrays(int size);

    constraint reasonable_out_of_order {
        out_of_order inside {[0:0]};
    }

    constraint c_address_rvalid_delay {
        address_rvalid_delay inside {[1:100]};
    }

    constraint c_aready_delay {
        aready_delay inside {[1:100]};
    }

    constraint c_avalid_aready_delay {
        avalid_aready_delay inside {[1:100]};
    }

    constraint c_write_bvalid_delay {
        write_bvalid_delay inside {[1:100]};
    }

    constraint c_wready_delay {
        foreach(wready_delay[idx]) {
            wready_delay[idx] inside {[1:100]};
        }
    }

    constraint c_wvalid_wready_delay {
        foreach(wvalid_wready_delay[idx]) {
            wvalid_wready_delay[idx] inside {[1:100]};
        }
    }

    constraint c_next_rvalid_delay {
        foreach(next_rvalid_delay[idx]) {
            next_rvalid_delay[idx] inside {[1:100]};
        }
    }

    constraint c_resp_okay {
        foreach(resp[idx]) {
            resp[idx] == dbb_ctrl_ext#()::OKAY;
        }
    }
endclass : dbb_ctrl_ext

// Function: new
// Creates a new DBB EXTENSION object
function dbb_ctrl_ext::new(string name = "dbb_ctrl_ext");
    super.new(name);

    // Create event objects for synchronization
    TXN_STARTED       = new();
    TXN_ENDED         = new();
    DATA_STARTED      = new();
    DATA_ENDED        = new();
    ADDRESS_STARTED   = new(); 
    ADDRESS_ENDED     = new();
endfunction : new

/// Sets the TLM response status for the transaction.  The settings in this function may be
/// overridden
function void dbb_ctrl_ext::set_response_status(ref uvm_tlm_gp tr, uvm_tlm_response_status_e status );
    resp_type_e resp_to_set;
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;
    `CAST_DBB_EXT(,tr,bus)
    `CAST_DBB_EXT(,tr,ctrl)
    // Do our best to size the array correctly if it's not already created.
    if ( tr_ctrl.resp.size() == 0 ) begin
        if ( tr.is_write() )    tr_ctrl.resp = new[1];
        else                    tr_ctrl.resp = new[ nvdla_tools::max#()::call( 1, tr_bus.get_length() ) ];
    end
    case ( status )
        UVM_TLM_OK_RESPONSE:                resp_to_set = OKAY;
        UVM_TLM_INCOMPLETE_RESPONSE:        resp_to_set = SLVERR;
        UVM_TLM_GENERIC_ERROR_RESPONSE:     resp_to_set = SLVERR;
        UVM_TLM_ADDRESS_ERROR_RESPONSE:     resp_to_set = DECERR;
        UVM_TLM_COMMAND_ERROR_RESPONSE:     resp_to_set = SLVERR;
        UVM_TLM_BURST_ERROR_RESPONSE:       resp_to_set = SLVERR;
        UVM_TLM_BYTE_ENABLE_ERROR_RESPONSE: resp_to_set = SLVERR;
        default:                            resp_to_set = OKAY;
    endcase
    foreach ( tr_ctrl.resp[ i ] ) begin
        tr_ctrl.resp[ i ] = resp_to_set;
    end
endfunction

/// Gets the TLM response status for the transaction.  The default response is
/// UVM_TLM_OK_RESPONSE.
function uvm_tlm_response_status_e dbb_ctrl_ext::get_response_status(uvm_tlm_gp tr);
    resp_type_e resp_to_get;
    uvm_tlm_response_status_e tlm_resp;
    dbb_ctrl_ext tr_ctrl;
    `CAST_DBB_EXT(,tr,ctrl)

    if ( tr_ctrl.resp.size() == 0 ) return UVM_TLM_OK_RESPONSE;

    if ( tr.is_write) begin
        resp_to_get = tr_ctrl.resp[0];
    end
    else begin
        resp_type_e first_not_ok_resp[$];
        first_not_ok_resp = tr_ctrl.resp.find_first( r ) with ( (r != OKAY) && (r != EXOKAY) );
        if ( first_not_ok_resp.size() == 0 ) begin
            resp_to_get = OKAY;
        end
        else begin
            resp_to_get = first_not_ok_resp[0];
        end
    end
    case ( resp_to_get )
        OKAY:       tlm_resp = UVM_TLM_OK_RESPONSE;
        EXOKAY:     tlm_resp = UVM_TLM_OK_RESPONSE;
        SLVERR:     tlm_resp = UVM_TLM_GENERIC_ERROR_RESPONSE;
        DECERR:     tlm_resp = UVM_TLM_ADDRESS_ERROR_RESPONSE;
        default:    tlm_resp = UVM_TLM_OK_RESPONSE;
    endcase
    return tlm_resp;
endfunction

////////////////////////////////////////////////////////////////////////////////
/// Initialize the dynamic arrays to a given size. This does not preserve any
/// existing data.
function void dbb_ctrl_ext::size_txn_arrays(int size);
    resp      = new[size];
endfunction: size_txn_arrays

////////////////////////////////////////////////////////////////////////////////
/// Resizes the dynamic arrays, preserving any existing data.
function void dbb_ctrl_ext::resize_txn_arrays(int size);
    resp      = new[size] (resp);
endfunction: resize_txn_arrays

//-------------------------------------------------------------------------------------
//
// CLASS: dbb_mon_ext
//
// This extension is used to define configuration parameters which are used by dbb 
// monitor to record times and cycle counts of events
//-------------------------------------------------------------------------------------

class dbb_mon_ext extends uvm_tlm_extension#(dbb_mon_ext);
    /// @name Configuration Parameters
    /// nvdla DBB Monitor Transaction Configuration Parameters
    ///@{

    int c_start;           ///< Cycle number for: Start of txn.  AWVALID or first WVALID
    int c_end;             ///< Cycle number for: End of txn.  Wr Response or last Read Data

    int c_avalid;          ///< Cycle number for: ARVALID/AWVALID
    int c_aready;          ///< Cycle number for: ARVALID + ARREADY/AWVALID + AWREADY

    int c_dvalid[];        ///< Cycle number for: RVALID/WVALID
    int c_dready[];        ///< Cycle number for: RVALID + RREADY/WVALID + WREADY

    int c_bresp_valid;     ///< Cycle number for: BVALID
    int c_bresp_ready;     ///< Cycle number for: BVALID + BREADY
    
    longint t_start;       ///< Timestamp for: Start of txn.  AWVALID or first WVALID
    longint t_end;         ///< Timestamp for: End of txn.  Wr Response or last Read Data 

    longint t_avalid;      ///< Timestamp for: ARVALID/AWVALID
    longint t_aready;      ///< Timestamp for: ARVALID + ARREADY/AWVALID + AWREADY
    
    longint t_dvalid[];    ///< Timestamp for: RVALID/WVALID
    longint t_dready[];    ///< Timestamp for: RVALID + RREADY/WVALID + WREADY

    longint t_bresp_valid; ///< Timestamp for: BVALID
    longint t_bresp_ready; ///< Timestamp for: BVALID + BREADY
    
    int last = -1;         ///< wlast/rlast signal beat number
    
    int data_id;           ///< Data identifier.
    ///@}

    `uvm_object_utils_begin(dbb_mon_ext)
        `uvm_field_int(c_start,        UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(c_end,          UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(c_avalid,       UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(c_aready,       UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_array_int(c_dvalid, UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_array_int(c_dready, UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(c_bresp_valid,  UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(c_bresp_ready,  UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(t_start,        UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(t_end,          UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(t_avalid,       UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(t_aready,       UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_array_int(t_dvalid, UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_array_int(t_dready, UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(t_bresp_valid,  UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(t_bresp_ready,  UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(last,           UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(data_id,        UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_object_utils_end

    extern function new(string name = "dbb_mon_ext");

    ////////////////////////////////////////////////////////////////////////////////
    /// Initialize the dynamic arrays to a given size. This does not preserve any
    /// previous data.
    function void size_txn_arrays(int size);
        c_dvalid = new[size];
        c_dready = new[size];
        t_dvalid = new[size];
        t_dready = new[size];
    endfunction: size_txn_arrays

    ////////////////////////////////////////////////////////////////////////////////
    /// Resizes the dynamic arrays, preserving any existing data.
    function void resize_txn_arrays(int size);
        //super.resize_txn_arrays(size);
        c_dvalid = new[size] (c_dvalid);
        c_dready = new[size] (c_dready);
        t_dvalid = new[size] (t_dvalid);
        t_dready = new[size] (t_dready);
    endfunction: resize_txn_arrays

endclass : dbb_mon_ext

// Function: new
// Creates a new DBB EXTENSION object
function dbb_mon_ext::new(string name = "dbb_mon_ext");
    super.new(name);
endfunction : new

//-------------------------------------------------------------------------------------
//
// CLASS: dbb_helper_ext
//
// This extension is used to define helper functions which are used by dbb 
//-------------------------------------------------------------------------------------

class dbb_helper_ext extends uvm_tlm_extension#(dbb_helper_ext);

    /// Status Error Type
    typedef enum {NO_FORCE     = 0,
                  FORCE_EXOKAY = 1,
                  FORCE_SLVERR = 2,
                  FORCE_DECERR = 3,
                  FORCE_OKAY   = 4
                  } status_err_type_e;

    int n_data = 0;               ///<  Current number of data xfers (read or write.)

    /// This is intended to be a place to store the ID of the uvm_component which processes the
    /// sequence item (i.e. monitor, driver, etc.) It is up to the UVM component to set this value,
    /// which can be useful for certain implementations, such as scoreboards or other checkers.
    int stream_id = -1;

    static int txn_num; //Assigned and incremented when new helper is created;
    int my_txn_num;     //Local once-written txn number. Used for debugging
    
    int write_before_addr; //Driver signal to indicate if data was seen before addr for a txn

    rand status_err_type_e status_err[];
                                      ///< Allows slave to produce err responses for any beat. The
                                      ///< dbb_helper_ext::NO_FORCE value allows slave to set normal response according
                                      ///< to txn. Reads are configurable per beat, but write has a single response,
                                      ///< and status_err[0] will always be used.

    `uvm_object_utils_begin(dbb_helper_ext)
        `uvm_field_array_enum(status_err_type_e,status_err, UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(stream_id,                           UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(write_before_addr,                   UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(txn_num,                             UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(my_txn_num,                          UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(n_data,                              UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_object_utils_end


    static function int decode_size(int encoded_size);
        int size;
        if (encoded_size == 0)
            size = 8;
        else if (encoded_size == 1) 
            size = 16;
        else if (encoded_size == 2) 
            size = 32;
        else if (encoded_size == 3) 
            size = 64;
        else if (encoded_size == 4) 
            size = 128;
        else if (encoded_size == 5) 
            size = 256;
        else if (encoded_size == 6) 
            size = 512;
        else if (encoded_size == 7) 
            size = 1024;
        return size;
    endfunction : decode_size

    extern function new(string name = "dbb_helper_ext");
    extern function bit last_beat(uvm_tlm_gp tr);
    extern function bit [`DBB_ADDR_WIDTH-1:0] beat_address(uvm_tlm_gp tr, int beatnum);
    extern function bit [`DBB_ADDR_WIDTH-1:0] aligned_address(uvm_tlm_gp tr);
    extern function void resize_txn_arrays(uvm_tlm_gp tr, int total_bytes);
    extern function void size_txn_arrays(uvm_tlm_gp tr, int total_bytes);
    // Use byte version when wanting array of bytes
    extern function void get_data_for_beat(uvm_tlm_gp tr, int beatnum, ref byte unsigned ret_data[] );
    extern function void get_wstrb_for_beat(uvm_tlm_gp tr, int beatnum, ref byte unsigned ret_wstrb[] );
    // Use byte version when setting using array of bytes
    extern function void set_data_for_beat(ref uvm_tlm_gp tr, int beatnum, byte unsigned data []);
    extern function void set_wstrb_for_beat(ref uvm_tlm_gp tr, int beatnum, byte unsigned wstrb []);
    extern function void pre_send_checks(uvm_tlm_gp tr);
    extern function string print (uvm_tlm_gp tr);

endclass : dbb_helper_ext

// Function: new
// Creates a new DBB EXTENSION object
function dbb_helper_ext::new(string name = "dbb_helper_ext");
    super.new(name);
    my_txn_num = txn_num++;
endfunction : new

//----------------------------------------------------------------------
/// Returns true if current beat counter indicates that we're at the last
/// data beat of the transaction
function bit dbb_helper_ext::last_beat(uvm_tlm_gp tr);
    dbb_bus_ext tr_bus; 
    `CAST_DBB_EXT(,tr,bus);
    return (n_data+1 >= tr_bus.get_length());
endfunction: last_beat

//----------------------------------------------------------------------
/// Calculates the aligned address for a particular beat. For a fixed burst, this is always
/// the aligned transaction address.
function bit [`DBB_ADDR_WIDTH-1:0] dbb_helper_ext::beat_address(uvm_tlm_gp tr, int beatnum);
    dbb_bus_ext tr_bus;
    int bytes_per_beat;
    `CAST_DBB_EXT(,tr,bus)
    //BURST_INCR
    bytes_per_beat = tr_bus.get_size();
    beat_address = aligned_address(tr) + (beatnum*bytes_per_beat);
endfunction: beat_address

//----------------------------------------------------------------------
/// Returns an aligned version of the current transaction address.
function bit [`DBB_ADDR_WIDTH-1:0] dbb_helper_ext::aligned_address(uvm_tlm_gp tr);
    dbb_bus_ext tr_bus;
    int bytes_per_beat;
    `CAST_DBB_EXT(,tr,bus)
    bytes_per_beat = tr_bus.get_size();
    return ((tr.get_address()/bytes_per_beat)*bytes_per_beat);
endfunction: aligned_address

////////////////////////////////////////////////////////////////////////////////
/// Initialize the dynamic arrays to a given size. This does not preserve any
/// existing data. Use size instead of tr_bus.get_size in case caller wants
/// extra space or tr hasn't set size yet
function void dbb_helper_ext::size_txn_arrays(uvm_tlm_gp tr, int total_bytes);
    dbb_mon_ext tr_mon;
    dbb_ctrl_ext tr_ctrl;
    byte unsigned   data[];
    byte unsigned   wstrb[];

    data = new[total_bytes];
    wstrb = new[total_bytes];

    tr.set_data(data);
    tr.set_data_length(total_bytes);
    tr.set_streaming_width(total_bytes);
    tr.set_byte_enable(wstrb);
    tr.set_byte_enable_length(total_bytes);

    //If tr has ctrl extension, use its size_txn_arrays function
    $cast(tr_ctrl,tr.get_extension(dbb_ctrl_ext::ID));
    if (tr_ctrl != null)
      tr_ctrl.size_txn_arrays(total_bytes);

    //If tr has mon extension, use its size_txn_arrays function
    $cast(tr_mon,tr.get_extension(dbb_mon_ext::ID));
    if (tr_mon != null)
      tr_mon.size_txn_arrays(total_bytes);
endfunction: size_txn_arrays

////////////////////////////////////////////////////////////////////////////////
/// Resizes the dynamic arrays, preserving any existing data.
/// Use size instead of tr_bus.get_size in case caller wants
/// extra space or tr hasn't set size yet
function void dbb_helper_ext::resize_txn_arrays(uvm_tlm_gp tr, int total_bytes);
    dbb_bus_ext tr_bus;
    dbb_mon_ext tr_mon;
    dbb_ctrl_ext tr_ctrl;
    byte unsigned  data[];
    byte unsigned  wstrb[];

    tr.get_data(data);
    data = new[total_bytes] (data);
    tr.get_byte_enable(wstrb);
    wstrb = new[total_bytes] (wstrb);

    tr.set_data(data);
    tr.set_data_length(total_bytes);
    tr.set_streaming_width(total_bytes);
    tr.set_byte_enable(wstrb);
    tr.set_byte_enable_length(total_bytes);

    //If tr has ctrl extension, use its size_txn_arrays function
    $cast(tr_ctrl,tr.get_extension(dbb_ctrl_ext::ID));
    if (tr_ctrl != null)
      tr_ctrl.size_txn_arrays(total_bytes);

    //If tr has mon extension, use its size_txn_arrays function
    $cast(tr_mon,tr.get_extension(dbb_mon_ext::ID));
    if (tr_mon != null)
      tr_mon.size_txn_arrays(total_bytes);
endfunction: resize_txn_arrays

//----------------------------------------------------------------------
/// Using only tlm's get_data/set_data is not nice for building up txns
/// This will get the right data slice for a given beat
function void dbb_helper_ext::get_data_for_beat(uvm_tlm_gp tr, int beatnum, ref byte unsigned ret_data[] );
    //uvm_tlm_gp m_data is an array of unsigned bytes. which is not how we originally organized data for multiple beats of axi data. This will treat use n_data, burst length, and size to determine where to slice up the array. Data is organized as first beat data in lowest indexes. 
    int i;
    int starting_byte;
    int bytes_per_beat;
    byte unsigned original_data [];
    dbb_bus_ext tr_bus;
    `CAST_DBB_EXT(,tr,bus)
    bytes_per_beat = tr_bus.get_size();
    starting_byte = beatnum * bytes_per_beat;
    tr.get_data(original_data);
    for (i=0; i<bytes_per_beat; i++) begin
      ret_data[i] = original_data[starting_byte+i];
    end     
endfunction : get_data_for_beat

function void dbb_helper_ext::get_wstrb_for_beat(uvm_tlm_gp tr, int beatnum, ref byte unsigned ret_wstrb[]);
    int i;
    int starting_byte;
    int bytes_per_beat;
    byte unsigned original_wstrb [];
    dbb_bus_ext tr_bus;
    `CAST_DBB_EXT(,tr,bus)
    bytes_per_beat = tr_bus.get_size();
    starting_byte = beatnum * bytes_per_beat;
    tr.get_byte_enable(original_wstrb);
    for (i=0; i<bytes_per_beat; i++) begin
      ret_wstrb[i] = original_wstrb[starting_byte+i];
    end     
endfunction : get_wstrb_for_beat

function void dbb_helper_ext::set_data_for_beat(ref uvm_tlm_gp tr, int beatnum, byte unsigned data []);
    // If data has 3 beats of 8 bytes already and we're adding 8 more (denoted 8.4)
    // it'll looks like {8.4, 8.3, 8.2, 8.1};
    int i;
    byte unsigned original_data [];
    dbb_bus_ext tr_bus;
    // tr.get_data_length may not be sized right and we may not be always appending
    // Use beatnum and data size to determine start of location to write
    int starting_byte;
    int bytes_per_beat;
    `CAST_DBB_EXT(,tr,bus)

    bytes_per_beat = tr_bus.get_size();
    starting_byte = beatnum*bytes_per_beat;
    tr.get_data(original_data);
    if((starting_byte+bytes_per_beat) > tr.get_data_length()) begin
      original_data = new[starting_byte + bytes_per_beat] (original_data);
    end
    
    for (i=0; i<data.size(); i++) begin
      original_data[starting_byte+i] = data[i];
    end
    tr.set_data(original_data);
    tr.set_data_length(original_data.size()); 
    tr.set_streaming_width(original_data.size());
endfunction : set_data_for_beat

function void dbb_helper_ext::set_wstrb_for_beat(ref uvm_tlm_gp tr, int beatnum, byte unsigned wstrb []);
    // If data has 3 beats of 8 bytes already and we're adding 8 more (denoted 8.4)
    // it'll looks like {8.4, 8.3, 8.2, 8.1};
    int i;
    byte unsigned original_wstrb [];
    dbb_bus_ext tr_bus;
    // tr.get_byte_enable_length may not be sized right and we may not be always appending
    // Use beatnum and data size to determine start of location to write
    int starting_byte;
    int bytes_per_beat;
    `CAST_DBB_EXT(,tr,bus)

    bytes_per_beat = tr_bus.get_size();
    starting_byte = beatnum*bytes_per_beat;
    tr.get_byte_enable(original_wstrb);
    if(starting_byte+bytes_per_beat > tr.get_byte_enable_length()) begin
      original_wstrb = new[starting_byte + bytes_per_beat] (original_wstrb);
    end
    
    for (i=0; i<wstrb.size(); i++) begin
      original_wstrb[starting_byte+i] = wstrb[i];
    end
    tr.set_byte_enable(original_wstrb);
    tr.set_byte_enable_length(original_wstrb.size());
endfunction : set_wstrb_for_beat

function void dbb_helper_ext::pre_send_checks(uvm_tlm_gp tr);
    dbb_bus_ext tr_bus;
    int errors = 0;
    byte unsigned data [];
    byte unsigned wstrb [];
    `CAST_DBB_EXT(,tr,bus)
    tr.get_data(data);
    tr.get_byte_enable(wstrb);
    if (data.size() != wstrb.size()) begin
        `uvm_error("DBB_GP_EXT", $psprintf("data array not same length as byte_enable array, %0d != %0d", data.size(), wstrb.size()))
        errors++;
    end
    if (data.size() != tr.get_data_length()) begin
        `uvm_error("DBB_GP_EXT", $psprintf("data array not same length as get_data_length, %0d != %0d", data.size(), tr.get_data_length()))
        errors++;
    end
    if (wstrb.size() != tr.get_byte_enable_length()) begin
        `uvm_error("DBB_GP_EXT", $psprintf("wstrb array not same length as get_byte_enable_length, %0d != %0d", wstrb.size(), tr.get_byte_enable_length()))
        errors++;
    end
    if (tr.get_data_length() != tr.get_byte_enable_length()) begin
        `uvm_error("DBB_GP_EXT", $psprintf("data_length not same length as byte_enable_length, %0d != %0d", tr.get_data_length(), tr.get_byte_enable_length()))
        errors++;
    end
    if (tr.get_data_length() != tr_bus.get_length()*tr_bus.get_size()) begin
        `uvm_error("DBB_GP_EXT", $psprintf("data_length not same length as burst length * size, %0d != %0d * %0d", tr.get_data_length(), tr_bus.get_length(), tr_bus.get_size()))
        errors++;
    end
    foreach (wstrb[i]) begin
        if (wstrb[i] != 8'h00 && wstrb[i] != 8'hff) begin
            `uvm_error("DBB_GP_EXT", $psprintf("byte_enable index has value other than 0 or ff, i:%0d en:%#0x", i, wstrb[i]))
            errors++;
        end
    end
    if (tr.is_read()) begin
    end else begin //tr.is_write
    end
    if (errors)
        `uvm_fatal("DBB_GP_EXT", $psprintf("Errors in pre_send_checks for %s txn",(tr.is_read())?"read":"write"))
endfunction : pre_send_checks

function string dbb_helper_ext::print(uvm_tlm_gp tr);
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;
    dbb_mon_ext tr_mon;

    `uvm_info("DBB/TXN/GP/PRINT", $psprintf("kind:%s, addr:%#0x, data_length:%0d, byte_enable_length:%0d, is_dmi_allowed:%0d, is_response_ok:%0d, is_response_err:%0d, get_response_string:%s", tr.is_write()?"W":"R", tr.get_address(), tr.get_data_length(), tr.get_byte_enable_length(), tr.is_dmi_allowed(), tr.is_response_ok(), tr.is_response_error(), tr.get_response_string()), UVM_FULL)

    `uvm_info("DBB/TXN/HELPER/PRINT", $psprintf("n_data:%0d, stream_id:%0d, txn_num:%0d, my_txn_num:%0d, write_before_addr:%0d", n_data, stream_id, txn_num, my_txn_num, write_before_addr), UVM_FULL)

    //If tr has bus extension, use its print function
    $cast(tr_bus,tr.get_extension(dbb_bus_ext::ID));
    // DONOT PRINT ANY MESSAGE THROUGH THIS WAY
    //if (tr_bus != null)
    //  tr_bus.print();
    `uvm_info("DBB/TXN/GP/PRINT", $sformatf("tr_bus:%0s", tr_bus.sprint()), UVM_HIGH)

    //If tr has ctrl extension, use its print function
    $cast(tr_ctrl,tr.get_extension(dbb_ctrl_ext::ID));
    //if (tr_ctrl != null)
    //  tr_ctrl.print();
    `uvm_info("DBB/TXN/GP/PRINT", $sformatf("tr_ctrl:%0s", tr_ctrl.sprint()), UVM_HIGH)

    //If tr has mon extension, use its size_txn_arrays function
    $cast(tr_mon,tr.get_extension(dbb_mon_ext::ID));
    //if (tr_mon != null)
    //  tr_mon.print();
    `uvm_info("DBB/TXN/GP/PRINT", $sformatf("tr_mon:%0s", tr_mon.sprint()), UVM_HIGH)

endfunction : print

`endif // _DBB_GP_EXT_SV_
