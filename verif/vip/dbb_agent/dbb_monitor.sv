`ifndef dbb_monitor__SV
`define dbb_monitor__SV

typedef class dbb_monitor;
typedef class dbb_mon_ext;

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                  class dbb_monitor_callbacks
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

`ifdef CALLBACKS
/// Callback class for the dbb_monitor.
class dbb_monitor_callbacks extends uvm_callback;

    /// Creates a new dbb_monitor_callbacks object
    function new(string name = "dbb_monitor_callbacks");
        super.new(name);
    endfunction: new

    // -------- Read Transaction --------
    /// Called at start of observed read transaction
    virtual function void pre_rd_trans(dbb_monitor xactor,
                                       uvm_tlm_gp tr);
    endfunction: pre_rd_trans

    /// Called at end of observed read transaction
    virtual function void post_rd_trans(dbb_monitor xactor,
                                        uvm_tlm_gp tr);
    endfunction: post_rd_trans

    // -------- Write Transaction --------
    /// Called at start of observed write transaction
    virtual function void pre_wr_trans(dbb_monitor xactor,
                                       uvm_tlm_gp tr);
    endfunction: pre_wr_trans

    /// Called at end of observed write transaction
    virtual function void post_wr_trans(dbb_monitor xactor,
                                        uvm_tlm_gp tr);
    endfunction: post_wr_trans

    // -------- Read Address --------
    /// Called when address becomes valid for each read address
    virtual function void pre_rd_addr(dbb_monitor xactor,
                                      uvm_tlm_gp tr);
    endfunction: pre_rd_addr

    /// Called when address is accepted for each read address
    virtual function void post_rd_addr(dbb_monitor xactor,
                                       uvm_tlm_gp tr);
    endfunction: post_rd_addr

    // -------- Write Address --------
    /// Called when address becomes valid for each write address
    virtual function void pre_wr_addr(dbb_monitor xactor,
                                      uvm_tlm_gp tr);
    endfunction: pre_wr_addr

    /// Called when address is accepted for each write address
    virtual function void post_wr_addr(dbb_monitor xactor,
                                       uvm_tlm_gp tr);
    endfunction: post_wr_addr

    // -------- Read Beat --------
    /// Called when data becomes valid for each read beat
    virtual function void pre_rd_beat(dbb_monitor xactor,
                                      uvm_tlm_gp tr);
    endfunction: pre_rd_beat

    /// Called when data is accepted for each read beat
    virtual function void post_rd_beat(dbb_monitor xactor,
                                       uvm_tlm_gp tr);
    endfunction: post_rd_beat

    // -------- Write Beat --------
    /// Called when data becomes valid for each write beat
    virtual function void pre_wr_beat(dbb_monitor xactor,
                                      uvm_tlm_gp tr);
    endfunction: pre_wr_beat

    /// Called when data is accepted for each write beat
    virtual function void post_wr_beat(dbb_monitor xactor,
                                       uvm_tlm_gp tr);
    endfunction: post_wr_beat

    // -------- Write Response --------
    /// Called when write response becomes valid
    virtual function void pre_wr_resp(dbb_monitor xactor,
                                      uvm_tlm_gp tr);
    endfunction: pre_wr_resp

    /// Called when write response is accepted
    virtual function void post_wr_resp(dbb_monitor xactor,
                                       uvm_tlm_gp tr);
    endfunction: post_wr_resp

endclass:dbb_monitor_callbacks

typedef uvm_callbacks #(dbb_monitor, dbb_monitor_callbacks) dbb_mon_cb;
`endif

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                  class uvm_tlm_gp_q
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

/// Queue of uvm_tlm_gp transactions.
/// A bit of a work-around because VCS doesn't support arrays of queues
class uvm_tlm_gp_q;
    uvm_tlm_gp q[$];
endclass

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                  class dbb_monitor
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

/// NVDLA DBB Monitor class.
/// The DBB monitor observes a single DBB interface and produces an uvm_tlm_gp
/// transaction object for each observed transaction.
class dbb_monitor#(int MEM_DATA_WIDTH=512) extends uvm_monitor;
    parameter MEM_WSTRB_WIDTH = MEM_DATA_WIDTH/8;
    /// Event notification to track when the monitor is still observing
    /// ongoing transactions. This can be checked to see whether or
    /// not the monitor is ready for the end of the simulation, or if
    /// there are still transactions in flight.
    uvm_event OBSERVING;

    /// Enables transaction logging to a file/screen
    bit enable_logging = 0;
  
    /// The stream ID of the driver is stored in all of the transaction
    /// objects which are processed by the driver. This can be useful
    /// in things such as scoreboards which receive transactions from
    /// multiple sources through the same port.
    int stream_id      = 32'hdbb305; 

    string                      tID;
 
    /// A TLM2.0 socket for sending transactions at pre-read and post write stage.
    /// Any component may connect to this socket to get transactions to pre-read and post-write stage
    uvm_tlm_b_initiator_socket mon_socket;

    /// A configuration bit to enable mon_socket.
    bit has_mon_socket = 0;

    /// A TLM transaction object. Needed for TLM port transactions
    uvm_tlm_generic_payload tlm_tr;

    uvm_tlm_time tlm_time;

    /// Track how many txns are in flight at once.
    int outstanding_txns;

    /// Observed DBB bus
    virtual dbb_interface#(MEM_DATA_WIDTH).Monitor mon_if;

    /// TLM Analysis port for completed observed transactions
    uvm_analysis_port #(uvm_tlm_gp) mon_analysis_port;

    /// TLM Analysis port for DBB request.
    uvm_analysis_port #(uvm_tlm_gp) mon_analysis_port_request;

    // Transaction queues, by ID number
    uvm_tlm_gp_q rd_q[int];///< Read transaction queue.
    uvm_tlm_gp_q wr_q[int];///< Write transaction queue.
    uvm_tlm_gp   resp_tr;  ///< Pending write resp txn.

    int cycle_count;                  ///< Running count of cycles.
    int total_txns;                   ///< Total number of observed transactions.

    /// DBB Transaction Logger
    dbb_logger#(MEM_DATA_WIDTH) logger;

    //---------------------------- CONFIGURATION PARAMETERS --------------------------------
    /// @name Configuration Parameters
    /// nvdla DBB Monitor Configuration Parameters. These parameters can be controlled
    /// through the UVM configuration database.
    ///@{
    /// Drive z's onto the bus between transactions. DBB doesn't actually use tri-state busses,
    /// but this mode is helpful during verification to make it easy to see when transactions
    /// are active, and it also could potentially catch somebody latching data where they're
    /// not supposed to.

    /// Configured width of the data bus.
    int data_bus_width = MEM_DATA_WIDTH;
    ///@}

    `uvm_component_param_utils_begin(dbb_monitor#(MEM_DATA_WIDTH))
        `uvm_field_int(enable_logging, UVM_DEFAULT)
        `uvm_field_int(stream_id,      UVM_DEFAULT)
        `uvm_field_int(has_mon_socket, UVM_DEFAULT)
        `uvm_field_int(data_bus_width, UVM_DEFAULT)
    `uvm_component_utils_end

`ifdef CALLBACKS
    /// Register UVM callback class
    `uvm_register_cb(dbb_monitor,dbb_monitor_callbacks)
`endif

    extern function new(string        name = "dbb_monitor",
                        uvm_component parent);

    ////////////////////////////////////////////////////////////////////////////////
    /// Returns the stream ID of the driver.
    function int get_stream_id();
        return stream_id;
    endfunction: get_stream_id

    ////////////////////////////////////////////////////////////////////////////////
    /// Sets the stream ID of the driver.
    function void set_stream_id(int sid);
        stream_id = sid;
    endfunction: set_stream_id

    /// @name UVM Phases
    ///@{
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    ///@}

    /// @name Reset Transactor
    ///@{
    extern protected task detect_reset();
    extern protected function void reset_xactor();
    extern protected function void cleanup_async_reset();
    extern protected function void kill_txn(uvm_tlm_gp txn);
    ///@}

    /// @name Monitoring
    ///@{
    extern protected task wr_address_monitor();
    extern protected task wr_data_monitor();
    extern protected task wr_resp_monitor();
    extern protected task rd_address_monitor();
    extern protected task rd_data_monitor();
    ///@}

    /// @name Transaction Handling
    ///@{
    extern function uvm_tlm_gp create_new_gp();
    extern function uvm_tlm_gp create_new_transaction();
    extern function void transaction_started(uvm_tlm_gp tr);
    extern function void transaction_finished(uvm_tlm_gp tr);
    ///@}

    /// @name TLM gp ext Helper functions
    ///@{
    //----------------------------------------------------------------------
    /// Applies a given write strobe to the given data and returns the result.
    function bit [MEM_DATA_WIDTH-1:0]
      apply_write_strobe(bit [MEM_DATA_WIDTH-1:0] busdata,
                                        bit [MEM_WSTRB_WIDTH-1:0] wstrobe);
        bit [MEM_DATA_WIDTH-1:0] mask;
    
        mask = get_strobe_mask(wstrobe);
        return(busdata & mask);
    
    endfunction: apply_write_strobe
    //----------------------------------------------------------------------
    /// This function extracts data read the bus from its proper byte lane.
    function bit [MEM_DATA_WIDTH-1:0]
      unshift_lane_data(uvm_tlm_gp tr,
                                       bit [MEM_DATA_WIDTH-1:0] busdata,
                                       int beatnum,
                                       int dbus_width = MEM_DATA_WIDTH,
                                       int number_bits);
        bit [MEM_DATA_WIDTH-1:0] mask;
        // We need to make sure we mask this, just in case the data bus is driving
        // values on the other lanes.
        mask = (1 << number_bits) - 1;
        `uvm_info("DBB_HELPER_EXT/UNSHIFT_LANE_DATA", $psprintf("mask:%#0x", mask), UVM_DEBUG)
    
        // Shift out of the appropriate lane
        unshift_lane_data = busdata >> (byte_lane(tr,beatnum,dbus_width,number_bits) * number_bits);
        `uvm_info("DBB_HELPER_EXT/UNSHIFT_LANE_DATA", $psprintf("byte_lane:%#0x", byte_lane(tr,beatnum,dbus_width,number_bits)), UVM_DEBUG)
        `uvm_info("DBB_HELPER_EXT/UNSHIFT_LANE_DATA", $psprintf("unshift_lane_data:%#0x", unshift_lane_data), UVM_DEBUG)
        // Apply the mask
        unshift_lane_data &= mask;
        `uvm_info("DBB_HELPER_EXT/UNSHIFT_LANE_DATA", $psprintf("unshift_lane_data:%#0x", unshift_lane_data), UVM_DEBUG)
        // Now shift even further if unaligned access
        unshift_lane_data >>= 8*misalignment_offset(tr, beatnum);
        `uvm_info("DBB_HELPER_EXT/UNSHIFT_LANE_DATA", $psprintf("unshift_lane_data:%#0x", unshift_lane_data), UVM_DEBUG)
    
    endfunction: unshift_lane_data
    function void set_bit_data_for_beat(ref uvm_tlm_gp tr, int beatnum, bit [MEM_DATA_WIDTH-1:0] data);
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
        if(starting_byte+bytes_per_beat > tr.get_data_length()) begin
            original_data = new[starting_byte + bytes_per_beat] (original_data);
        end
    
        `uvm_info("DBB_HELPER_EXT/GET_BIT_DATA_FOR_BEAT", $psprintf("starting_byte:%0d, bytes_per_beat:%0d, beatnum:%0d",starting_byte, bytes_per_beat, beatnum), UVM_DEBUG)
        for (i=0; i<bytes_per_beat; i++) begin
            `uvm_info("DBB_HELPER_EXT/GET_BIT_DATA_FOR_BEAT/BEFORE", $psprintf("set_data:%#0x, original_data:%#0x, i:%0d",data[i*8+:8], original_data[starting_byte+i],i), UVM_DEBUG)
            original_data[starting_byte+i] = data[i*8+:8];
            `uvm_info("DBB_HELPER_EXT/GET_BIT_DATA_FOR_BEAT/AFTER", $psprintf("set_data:%#0x, original_data:%#0x, new_size:%0d",data[i*8+:8], original_data[starting_byte+i], original_data.size()), UVM_DEBUG)
        end
        tr.set_data(original_data);
        tr.set_data_length(original_data.size()); // necessary
        tr.set_streaming_width(original_data.size());
    endfunction : set_bit_data_for_beat
    //----------------------------------------------------------------------
    /// This function unshifts the observed wstrb value on the bus from it's byte lane
    function bit [MEM_WSTRB_WIDTH-1:0]
      unshift_lane_wstrb(uvm_tlm_gp tr,
                                        bit [MEM_WSTRB_WIDTH-1:0] busdata,
                                        int beatnum,
                                        int dbus_width = MEM_WSTRB_WIDTH,
                                        int number_bits);
        bit [MEM_WSTRB_WIDTH-1:0] mask;
        // We need to make sure we mask this, just in case the data bus is driving
        // values on the other lanes.
        mask = (1 << (number_bits/8)) - 1;
    
        // Shift out of the appropriate lane
        unshift_lane_wstrb = busdata >> (byte_lane(tr,beatnum,dbus_width,number_bits) * (number_bits/8));
        // Apply the mask
        unshift_lane_wstrb &= mask;
        // Now shift even further if unaligned access
        unshift_lane_wstrb >>= misalignment_offset(tr, beatnum);
    
    endfunction: unshift_lane_wstrb
    function void set_bit_wstrb_for_beat(ref uvm_tlm_gp tr, int beatnum, bit [MEM_WSTRB_WIDTH-1:0] wstrb);
        // If data has 3 beats of 8 bytes already and we're adding 8 more (denoted 8.4)
        // it'll looks like {8.4, 8.3, 8.2, 8.1};
        int i;
        byte unsigned original_wstrb [];
        dbb_bus_ext tr_bus;
    
        // tr.get_wstrb_length may not be sized right and we may not be always appending
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
    
        //UVM_TLM_GP specifies that each index is 0 or 'ff. So each 1 bit from the bus is one index of 'ff. So we iterate over each bit
        for (i=0; i<bytes_per_beat*8; i++) begin
            original_wstrb[starting_byte+i] = (wstrb[i]) ? 8'hff : 8'h00;
        end
        tr.set_byte_enable(original_wstrb);
        tr.set_byte_enable_length(original_wstrb.size()); // necessary
    endfunction : set_bit_wstrb_for_beat 
    //----------------------------------------------------------------------
    /// Returns the number of bytes out of alignment a particular address is. Misalignment only
    /// affects the first beat of INCR or WRAP bursts.
    function int misalignment_offset(uvm_tlm_gp tr, int beatnum);
        dbb_helper_ext tr_helper;
        `CAST_DBB_EXT(,tr,helper);
        if (beatnum == 0)
          return (tr.get_address() - tr_helper.aligned_address(tr));
        else
          return (0);
    endfunction: misalignment_offset
    //----------------------------------------------------------------------
    /// Calculates write strobe mask.
    function bit [MEM_DATA_WIDTH-1:0] get_strobe_mask(bit [MEM_WSTRB_WIDTH-1:0] wstrobe);
    
        get_strobe_mask = 0;
        for (int i=MEM_WSTRB_WIDTH-1; i>=0; i--) begin
            get_strobe_mask <<= 8;
            if (wstrobe[i]) get_strobe_mask += 'b11111111;
        end
    
    endfunction: get_strobe_mask
    //----------------------------------------------------------------------
    /// Calculates which byte lane a particular beat needs to be driven on.
    /// This depends on the data bus width, which will determine how many
    /// total byte lanes there are.
    function int byte_lane(uvm_tlm_gp tr, int beatnum, int dbus_width = MEM_DATA_WIDTH, int number_bits);
        int numlanes;
        dbb_helper_ext tr_helper;
        `CAST_DBB_EXT(,tr,helper);
        numlanes = dbus_width/number_bits;
        // Rightshift by number of bytes in a beat
        byte_lane = (tr_helper.beat_address(tr, beatnum) >> $clog2(number_bits/8)) & (numlanes-1);
    endfunction: byte_lane

    ///@}

endclass:dbb_monitor


//////////////////////////////////////////////////////////////////////
/// Creates new dbb_monitor object
function dbb_monitor::new(string        name = "dbb_monitor",
                                uvm_component parent);

    super.new(name, parent);
    tID           = get_type_name().toupper();

    cycle_count = 0;
    total_txns = 0;

    mon_analysis_port         = new ("mon_analysis_port", this);
    mon_analysis_port_request = new ("mon_analysis_port_request", this);

    // Create event objects
    OBSERVING = new();

endfunction: new

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM build phase.
function void dbb_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_LOW)

    uvm_config_int::get(this,"","enable_logging",enable_logging);
    uvm_config_int::get(this,"","stream_id",stream_id);
    uvm_config_int::get(this,"","data_bus_width",data_bus_width);

    logger = dbb_logger#(MEM_DATA_WIDTH)::type_id::create("logger",this);

    // Logger data bus width
    uvm_config_int::set(this,"logger","data_bus_width",data_bus_width);

    if (!uvm_config_db#(bit)::get(this,"","has_mon_socket",has_mon_socket)) begin
        `uvm_info(get_name(),$psprintf("has_mon_socket does not exist in config db"), UVM_LOW);
    end

    if (has_mon_socket) begin
        `uvm_info(get_name(),$psprintf("Enabled mon_socket"), UVM_LOW);
    end
endfunction: build_phase

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM connect phase.
function void dbb_monitor::connect_phase(uvm_phase phase);
    virtual dbb_interface#(MEM_DATA_WIDTH) temp_if;
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_LOW)

    // Hook up the virtual interface here
    if (!uvm_config_db#(virtual dbb_interface#(MEM_DATA_WIDTH))::get(this, "", "mon_if", temp_if)) begin
        if (!uvm_config_db#(virtual dbb_interface#(MEM_DATA_WIDTH).Monitor)::get(this, "", "mon_if", mon_if)) begin
            `uvm_fatal("NVDLA/DBB/MON/NO_VIF", "No virtual interface specified for this driver instance")
        end
    end
    else begin
        mon_if = temp_if;
    end

endfunction: connect_phase

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM start of simulation phase.
function void dbb_monitor::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    reset_xactor(); // Reset any state information
endfunction: start_of_simulation_phase

//////////////////////////////////////////////////////////////////////
/// Resets counters and clears any state
function void dbb_monitor::reset_xactor();
    rd_q.delete();
    wr_q.delete();
    resp_tr = null;
endfunction: reset_xactor

//////////////////////////////////////////////////////////////////////
/// Forks off Read and Write monitoring threads
task dbb_monitor::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_LOW)

    fork
        forever begin
            @(mon_if.monclk) cycle_count++;
        end
    join_none

    fork
        forever begin
            // Wait for a clock, we want reset to be stable
            @(posedge mon_if.clk);

            // Wait here if in reset
            if (mon_if.rst_n !== '1) @(posedge mon_if.rst_n);

            fork
                detect_reset();
                wr_address_monitor();
                wr_data_monitor();
                wr_resp_monitor();
                rd_address_monitor();
                rd_data_monitor();
            join_any

            // Process all active transactions for reset termination
            cleanup_async_reset();
            disable fork;
            reset_xactor();
        end
    join

endtask: run_phase

function uvm_tlm_gp dbb_monitor::create_new_gp();
    uvm_tlm_gp   gp;
    dbb_bus_ext  bus_ext;
    dbb_ctrl_ext ctrl_ext;
    dbb_mon_ext mon_ext;
    dbb_helper_ext helper_ext;

    gp       = uvm_tlm_gp::type_id::create();
    bus_ext  = new();
    ctrl_ext = new();
    mon_ext = new();
    helper_ext = new();

    gp.set_extension(bus_ext);
    gp.set_extension(ctrl_ext);
    gp.set_extension(mon_ext);
    gp.set_extension(helper_ext);

    return gp;
endfunction : create_new_gp

////////////////////////////////////////////////////////////////////////////////
/// Wait until the reset line drops, then exit routine. This will initiate
/// all of the asynchronous reset cleanup activity.
task dbb_monitor::detect_reset();
    @(negedge mon_if.rst_n);
    `uvm_info("NVDLA/DBB/MON/RESET_DETECT","Reset Detected",UVM_LOW);
endtask: detect_reset

////////////////////////////////////////////////////////////////////////////////
/// Steps through all transaction pointers and terminates any active transactions.
/// transaction_started() and transaction_finished() routines will be called as
/// necessary.
function void dbb_monitor::cleanup_async_reset();

    foreach (rd_q[i])
      foreach (rd_q[i].q[j]) kill_txn(rd_q[i].q[j]);
    foreach (wr_q[i])
      foreach (wr_q[i].q[j]) kill_txn(wr_q[i].q[j]);
    kill_txn(resp_tr);

    if (outstanding_txns != 0) begin
        `uvm_error("NVDLA/DBB/MON/RESET_SYNC",
                   $psprintf("Monitor Sync Error on Reset (%0d)",outstanding_txns));
    end
endfunction: cleanup_async_reset

////////////////////////////////////////////////////////////////////////////////
/// Kills an ongoing transaction as a result of detecting reset getting pulled.
/// Will call transaction_started or transaction_finished if needed.
function void dbb_monitor::kill_txn(uvm_tlm_gp txn);
    if (txn) begin
        dbb_ctrl_ext txn_ctrl;
        `CAST_DBB_EXT(,txn,ctrl)
        if (txn_ctrl.TXN_STARTED.is_off()) begin
            transaction_started(txn);
        end
        if (txn_ctrl.TXN_ENDED.is_off()) begin
            // Set status to show why transaction was killed
            txn_ctrl.transtat = dbb_ctrl_ext::NVDLA_TS_RESET;
            `uvm_info("NVDLA/DBB/MON/RESET_KILL",
                      $psprintf("Transaction killed due to reset: 'h%08x",txn.get_address()),UVM_LOW);
            // Now finish the transaction
            transaction_finished(txn);
        end
    end
endfunction: kill_txn
//////////////////////////////////////////////////////////////////////
/// Continually monitors the DBB write address channel for new transactions
task dbb_monitor::wr_address_monitor();
    uvm_tlm_gp tr;
    int arr_id;
    int txn_id;
    bit is_new_txn;
    dbb_bus_ext  tr_bus;
    dbb_ctrl_ext tr_ctrl;
    dbb_mon_ext  tr_mon;
    dbb_helper_ext  tr_helper;
    int trq_itr;

    forever begin : wr_addr
        uvm_tlm_gp trq[$];

        // Wait for start of transaction
        do @(mon_if.monclk);
        while ( mon_if.monclk.awvalid !== 1'b1 );

        txn_id = mon_if.monclk.awid;
        arr_id = 0; 
        if(wr_q[arr_id] == null) wr_q[arr_id] = new;   // Initialize entry for this ID

        // Check to see if we're tracking write data for this ID already
        // find 1st tracked txn without an address
        // Can't use this because item is uvm_tlm_gp, not dbb_ctrl_ext
        //trq = wr_q[arr_id].q.find_first with (item.ADDRESS_STARTED.is_off());
        for(trq_itr=0; trq_itr < wr_q[arr_id].q.size(); trq_itr++) begin
            uvm_tlm_gp dbb_gp;
            dbb_ctrl_ext dbb_gp_ctrl;
            dbb_gp = wr_q[arr_id].q[trq_itr];
            `CAST_DBB_EXT(,dbb_gp,ctrl)
            if (dbb_gp_ctrl.ADDRESS_STARTED.is_off()) begin
                trq.push_front(dbb_gp);
                break;
            end
        end
        if(trq.size > 0) begin
            // We found a transaction that we're tracking with the same ID, but no address. We must have
            // a situtation where the write data was seen before the address.
            is_new_txn = 0;
            tr = trq[0];
        end
        else begin
            // This is a brand new initiated transaction, create with factory method
            is_new_txn = 1;
            tr = create_new_transaction();
        end
        `CAST_DBB_EXT(,tr,bus)
        `CAST_DBB_EXT(,tr,ctrl)
        `CAST_DBB_EXT(,tr,mon)
        `CAST_DBB_EXT(,tr,helper)

        // Sample address and control information from bus
        tr.set_write();
        tr.set_address(mon_if.monclk.awaddr);
        tr_bus.set_size(1<<mon_if.monclk.awsize);
        // Necessary to limit transaction to 16 beats and to avoid consumption
        // of Zs if defines not correctly limiting width
        tr_bus.set_length(mon_if.monclk.awlen[3:0] + 1);
        tr_bus.set_id(txn_id);
        tr.set_transaction_id(txn_id);

        // Set wr address valid time
        tr_mon.c_avalid = cycle_count;
        tr_mon.t_avalid = $time;
        tr_ctrl.ADDRESS_STARTED.trigger();

        `uvm_info("NVDLA/DBB/MON/WR_ADDR", $sformatf("wr_q[%0d].q.size = %0d, is_new_txn = %0d, len = %0d, size = %0d, tr = \n%s",
            arr_id, wr_q[arr_id].q.size(), is_new_txn, tr_bus.get_length(), tr_bus.get_size(), tr.sprint()), UVM_DEBUG)
        // Add a new transaction to the queue
        if(is_new_txn) begin
            // Allocate dynamic arrays based on how many beats
            tr_helper.size_txn_arrays(tr, tr_bus.get_size()*tr_bus.get_length());
            tr_ctrl.size_txn_arrays(tr_bus.get_length);
            tr_mon.size_txn_arrays(tr_bus.get_length);
            wr_q[arr_id].q.push_back(tr);
            transaction_started(tr);
            tr.set_response_status(UVM_TLM_INCOMPLETE_RESPONSE);
            `uvm_info("NVDLA/DBB/MON/WR_ADDR", $psprintf("Starting pre_send_checks for above tr.", tr_helper.print(tr)),UVM_FULL)
            tr_helper.pre_send_checks(tr);
            mon_analysis_port_request.write(tr);
        end
        else begin
            // Now we need to 'fix' any data/wstrb which was read before we had any address
            // and control information. Data was properly masked, but it wasn't shifted
            // from the byte lane because we didn't know what size the transaction was.
            // Do this, and then write this data to the memory array.
            byte unsigned old_data[];
            byte unsigned q[];
            byte unsigned old_wstrb[];
            byte unsigned s[];
            q = new[tr_bus.get_length()*tr_bus.get_size()];
            s = new[tr_bus.get_length()*tr_bus.get_size()];
            tr.get_data(old_data);
            tr.get_byte_enable(old_wstrb);
        end

`ifdef CALLBACKS
        // Do pre write address callback
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          pre_wr_addr(this, tr))
`endif

        // Now we need to block until the write address is accepted from the slave
        while ((mon_if.monclk.awvalid !== 1'b1) ||
               (mon_if.monclk.awready !== 1'b1) )
          @(mon_if.monclk);

        // Set wr address accepted time
        tr_mon.c_aready = cycle_count;
        tr_mon.t_aready = $time;
        tr_ctrl.ADDRESS_ENDED.trigger();

`ifdef CALLBACKS
        // Do post write address callback
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          post_wr_addr(this, tr))
`endif

    end

endtask: wr_address_monitor

//////////////////////////////////////////////////////////////////////
/// Continually monitors the DBB write data channel. When data is observed,
/// store to the appropriate transaction object.
task dbb_monitor::wr_data_monitor();
    uvm_tlm_gp             tr;
    bit [MEM_DATA_WIDTH-1:0] busdata;
    int                       id;
    dbb_bus_ext               tr_bus;
    dbb_ctrl_ext              tr_ctrl;
    dbb_mon_ext               tr_mon;
    dbb_helper_ext            tr_helper;
    int trq_itr;

    //---------------------------
    // Write data channel
    forever begin : wr_data
        uvm_tlm_gp             trq[$];

        // Wait for start of data burst
        do @(mon_if.monclk);
        while ( mon_if.monclk.wvalid !== 1'b1 );

        id = 0;
        if(wr_q[id] == null) wr_q[id] = new;

        // Find first tracked txn which is still waiting for data
        // Can't use this because item is uvm_tlm_gp, not dbb_ctrl_ext
        //trq = wr_q[id].q.find_first with (item.DATA_ENDED.is_off());
        for(trq_itr=0; trq_itr < wr_q[id].q.size(); trq_itr++) begin
            uvm_tlm_gp dbb_gp;
            dbb_bus_ext dbb_gp_bus;
            dbb_ctrl_ext dbb_gp_ctrl;
            dbb_helper_ext dbb_gp_helper;
            dbb_gp = wr_q[id].q[trq_itr];
            `CAST_DBB_EXT(,dbb_gp,bus)
            `CAST_DBB_EXT(,dbb_gp,ctrl)
            `CAST_DBB_EXT(,dbb_gp,helper)
            `uvm_info("NVDLA/DBB/MON/WR_DATA",
                $psprintf("wr_data wr_q: i:%0d, txn_num:%0d, n_data:%0d, DATA_ENDED:%0d, ADDR_ENDED:%0d, size:%0d, len:%0d, data_length:%0d",
                trq_itr, dbb_gp_helper.my_txn_num, dbb_gp_helper.n_data, dbb_gp_ctrl.DATA_ENDED.is_on(), dbb_gp_ctrl.ADDRESS_ENDED.is_on(),
                dbb_gp_bus.get_size(), dbb_gp_bus.get_length(), dbb_gp.get_data_length()), UVM_DEBUG);
            if (dbb_gp_ctrl.DATA_ENDED.is_off()) begin
                trq.push_front(dbb_gp);
                `uvm_info("NVDLA/DBB/MON/WR_DATA", $psprintf("wr_data wr_q: picked i:%0d txn_num:%0d", trq_itr, dbb_gp_helper.my_txn_num),UVM_DEBUG)
                break;
            end
        end

        // Did we find an existing transaction that still needs data?
        if(trq.size > 0) begin
            byte unsigned p[];
            tr = trq[0];
            `CAST_DBB_EXT(,tr,bus)
            `CAST_DBB_EXT(,tr,ctrl)
            `CAST_DBB_EXT(,tr,mon)
            `CAST_DBB_EXT(,tr,helper)
            `uvm_info("NVDLA/DBB/MON/WR_DATA", $psprintf("wr_data wr_q: using i:%0d txn_num:%0d", trq_itr, tr_helper.my_txn_num),UVM_DEBUG)
            tr_helper.n_data++; // Increment beat counter to get ready for next data beat
            // Check to see if we've run out of room in our dynamic arrays. If so, allocate
            // another chunk, since we still don't know the exact size.
            tr.get_data(p);
            if (tr_helper.n_data*(1<<mon_if.monclk.arsize) >= p.size())
              tr_helper.resize_txn_arrays(tr, p.size()+(1<<mon_if.monclk.awsize));
              tr_ctrl.size_txn_arrays(tr_helper.n_data+1);
              tr_mon.size_txn_arrays(tr_helper.n_data+1);
        end
        else begin
            // Need to create a brand new transaction for the data. Must not have an address yet.
            tr = create_new_transaction();
            `CAST_DBB_EXT(,tr,bus)
            `CAST_DBB_EXT(,tr,ctrl)
            `CAST_DBB_EXT(,tr,mon)
            `CAST_DBB_EXT(,tr,helper)
            tr.set_write();
            tr_bus.set_id(0);
            tr_bus.set_size(1<<mon_if.monclk.awsize); // awsize is constant 
            tr_helper.n_data  = 0;                             // Point to first data beat
            // We don't know how many beats yet, so start by allocating according to size
            tr_helper.size_txn_arrays(tr, (1<<mon_if.monclk.awsize));
            tr_ctrl.size_txn_arrays(1);
            tr_mon.size_txn_arrays(1);

            transaction_started(tr);
            wr_q[id].q.push_back(tr);
            `uvm_info("NVDLA/DBB/MON/WR_DATA", $psprintf("wr_data wr_q: using i:%0d txn_num:%0d", trq_itr, tr_helper.my_txn_num),UVM_DEBUG)
        end

        // Record data valid time
        if (tr_helper.n_data == 0) tr_ctrl.DATA_STARTED.trigger();
        tr_mon.c_dvalid[tr_helper.n_data] = cycle_count;
        tr_mon.t_dvalid[tr_helper.n_data] = $time;

        if(tr_ctrl.ADDRESS_STARTED.is_on()) begin // We already have the address
            // Apply write strobe to bus signal, get rid of any unused bus data
            bit [MEM_DATA_WIDTH-1:0] data;
            bit [MEM_WSTRB_WIDTH-1:0] wstrb;
            busdata = apply_write_strobe(mon_if.monclk.wdata,
                                            mon_if.monclk.wstrb);
            // Store transaction data
            data = unshift_lane_data(tr,
                                                      busdata,
                                                      tr_helper.n_data,
                                                      data_bus_width,
                                                      8*tr_bus.get_size());
            set_bit_data_for_beat(tr, tr_helper.n_data, data);
            wstrb = unshift_lane_wstrb(tr,
                                                        mon_if.monclk.wstrb,
                                                        tr_helper.n_data,
                                                        data_bus_width,
                                                        8*tr_bus.get_size());
            set_bit_wstrb_for_beat(tr, tr_helper.n_data, wstrb);
        end
        else begin // Just store the data and wstrb as is, we'll align them properly once we get more info
            bit [MEM_DATA_WIDTH-1:0] data;
            bit [MEM_WSTRB_WIDTH-1:0] wstrb;
            data = apply_write_strobe(mon_if.monclk.wdata,
                                                        mon_if.monclk.wstrb);
            set_bit_data_for_beat(tr, tr_helper.n_data, data);
            wstrb = mon_if.monclk.wstrb;
            set_bit_wstrb_for_beat(tr, tr_helper.n_data, wstrb);
        end


`ifdef CALLBACKS
        // Do pre write beat callback
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          pre_wr_beat(this, tr))
`endif

        // Now we block until the data is accepted by the slave
        while ((mon_if.monclk.wvalid !== 1'b1) ||
               (mon_if.monclk.wready !== 1'b1) ) @(mon_if.monclk);

        // Store time of data transfer
        tr_mon.c_dready[tr_helper.n_data] = cycle_count;
        tr_mon.t_dready[tr_helper.n_data] = $time;

        if (mon_if.monclk.wlast === 1'b1) begin
            tr_mon.last = tr_helper.n_data;
            tr_ctrl.DATA_ENDED.trigger();
        end

`ifdef CALLBACKS
        // Do post write beat callback
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          post_wr_beat(this, tr))
`endif

    end
endtask: wr_data_monitor

//////////////////////////////////////////////////////////////////////
/// Continually monitors the DBB write response channel.
task dbb_monitor::wr_resp_monitor();
    int                    txn_id;
    int                    arr_id;
    dbb_bus_ext            resp_tr_bus;
    dbb_ctrl_ext           resp_tr_ctrl;
    dbb_mon_ext            resp_tr_mon;
    //---------------------------
    // Write response channel
    forever begin : wr_resp

        // Wait for start of write_response
        do @(mon_if.monclk);
        while ( mon_if.monclk.bvalid !== 1'b1 );

        // Grab transaction ID from bus
        txn_id = mon_if.monclk.bid;
        arr_id = 0;

        // Are there transactions waiting?
        if (wr_q[arr_id] != null && wr_q[arr_id].q.size != 0) begin
            int trq_itr;
            int qindex[$];
            //qindex = wr_q[0].q.find_first_index with (item.DATA_ENDED.is_on() && (item.id == txn_id));
            for(trq_itr=0; trq_itr < wr_q[arr_id].q.size(); trq_itr++) begin
                uvm_tlm_gp dbb_gp;
                dbb_bus_ext dbb_gp_bus;
                dbb_ctrl_ext dbb_gp_ctrl;
                dbb_gp = wr_q[arr_id].q[trq_itr];
                `CAST_DBB_EXT(,dbb_gp,bus)
                `CAST_DBB_EXT(,dbb_gp,ctrl)
                if (dbb_gp_ctrl.DATA_ENDED.is_on() && (dbb_gp_bus.get_id() == txn_id)) begin
                    qindex.push_front(trq_itr);
                    break;
                end
            end
            if (qindex.size > 0) begin
                resp_tr = wr_q[0].q[qindex[0]];
                wr_q[0].q.delete(qindex[0]);  // Done with the transaction, remove it from the queue
            end
            // Find the matching transaction for this id. For  we're using a queue for each ID,
            //resp_tr = wr_q[arr_id].q[0];      // Use txn at front of this ID's queue.
            //wr_q[arr_id].q.delete(0);         // Done with the transaction, remove it from the queue
        end

        // Did we find a matching transaction?
        if (resp_tr == null) begin
            `uvm_error("NVDLA/DBB/MON/IDMSMTCH", $psprintf("No pending write transaction for id: 'h%0x", txn_id));
            continue;
        end

        `CAST_DBB_EXT(,resp_tr,bus)
        `CAST_DBB_EXT(,resp_tr,ctrl)
        `CAST_DBB_EXT(,resp_tr,mon)

        // Store Response Valid Time
        resp_tr_mon.c_bresp_valid = cycle_count;
        resp_tr_mon.t_bresp_valid = $time;

`ifdef CALLBACKS
        // Do pre write beat callback
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          pre_wr_resp(this, resp_tr))
`endif

        // Block until a write response ready is seen
        while ((mon_if.monclk.bvalid !== 1'b1) ||
               (mon_if.monclk.bready !== 1'b1))
          @(mon_if.monclk);

        // Store Response Ready Time
        resp_tr_mon.c_bresp_ready = cycle_count;
        resp_tr_mon.t_bresp_ready = $time;

        // Observe response type
        resp_tr_ctrl.resp[0] = dbb_ctrl_ext::resp_type_e'(mon_if.monclk.bresp);

`ifdef CALLBACKS
        // Do post write resp callback
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          post_wr_resp(this, resp_tr))
`endif

        transaction_finished(resp_tr);
        resp_tr = null;
    end

endtask: wr_resp_monitor

//////////////////////////////////////////////////////////////////////
/// Continually monitors the DBB read address channel for new transactions.
task dbb_monitor::rd_address_monitor();
    uvm_tlm_gp tr;
    int                   id;
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;
    dbb_mon_ext tr_mon;
    dbb_helper_ext tr_helper;

    forever begin : rd_addr

        // Wait for start of read transaction
        do @(mon_if.monclk);
        while ( mon_if.monclk.arvalid !== 1'b1 );

        // Grab transction ID from the bus
        id = mon_if.monclk.arid;

        // Create a new transaction with factory method
        tr = create_new_transaction();

        `CAST_DBB_EXT(,tr,bus)
        `CAST_DBB_EXT(,tr,ctrl)
        `CAST_DBB_EXT(,tr,mon)
        `CAST_DBB_EXT(,tr,helper)

        // Set rd address valid time
        tr_mon.c_avalid = cycle_count;
        tr_mon.t_avalid = $time;

        tr_ctrl.ADDRESS_STARTED.trigger();

        // Sample address and control information from bus
        tr.set_read();
        tr.set_address(mon_if.monclk.araddr);
        tr_bus.set_size(1<<mon_if.monclk.arsize);
        // Necessary to limit transaction to 16 beats and to avoid consumption
        // of Zs if defines not correctly limiting width
        tr_bus.set_length(mon_if.monclk.arlen[3:0] + 1);
        tr_bus.set_id(id);
        tr.set_transaction_id(id);

        // Allocate dynamic arrays based on how many beats
        tr_helper.size_txn_arrays(tr, tr_bus.get_size*tr_bus.get_length());
        tr_ctrl.size_txn_arrays(tr_bus.get_length());
        tr_mon.size_txn_arrays(tr_bus.get_length());

        transaction_started(tr);
        tr.set_response_status(UVM_TLM_INCOMPLETE_RESPONSE);
        `uvm_info("NVDLA/DBB/MON/RD_ADDR", $psprintf("Starting pre_send_checks for above tr.", tr_helper.print(tr)),UVM_FULL)
        tr_helper.pre_send_checks(tr);
        mon_analysis_port_request.write(tr);

        if(rd_q[id] == null) rd_q[id] = new;
        rd_q[id].q.push_back(tr); // Queue transactions in order per ID

`ifdef CALLBACKS
        // Do pre read address callback
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          pre_rd_addr(this, tr))
`endif

        // Now block until the transaction is accepted by the slave
        while ((mon_if.monclk.arvalid !== 1'b1) ||
               (mon_if.monclk.arready !== 1'b1) )
          @(mon_if.monclk);

        // Set rd address accepted time
        tr_mon.c_aready = cycle_count;
        tr_mon.t_aready = $time;
        tr_ctrl.ADDRESS_ENDED.trigger();

`ifdef CALLBACKS
        // Do post read address callback
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          post_rd_addr(this, tr))
`endif
    end

endtask: rd_address_monitor

//////////////////////////////////////////////////////////////////////
/// Continually monitors the DBB read data channel. When data is observed,
/// store to the appropriate transaction object.
task dbb_monitor::rd_data_monitor();
    uvm_tlm_gp tr;
    int                   id;
    bit [MEM_DATA_WIDTH-1:0] data;
    byte unsigned wstrb [];
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;
    dbb_mon_ext tr_mon;
    dbb_helper_ext tr_helper;

    forever begin : rd_data

        // Wait for start of read data
        do @(mon_if.monclk);
        while ( mon_if.monclk.rvalid !== 1'b1 );

        id = mon_if.monclk.rid; // Grab the transaction ID from thebus

        // Make sure we've already seen an address for this transaction
        if(rd_q[id] == null || rd_q[id].q.size == 0) begin
            `uvm_error("NVDLA/DBB/MON/IDMSMTCH", $psprintf("No pending read transaction for id: 'h%0x", id));
            continue;
        end
        tr = rd_q[id].q[0]; // Use first transaction in matching ID queue

        `CAST_DBB_EXT(,tr,bus)
        `CAST_DBB_EXT(,tr,ctrl)
        `CAST_DBB_EXT(,tr,mon)
        `CAST_DBB_EXT(,tr,helper)

        tr_helper.n_data++;        // Advance pointer to the next data beat

        // Record data valid time
        if (tr_helper.n_data == 0) tr_ctrl.DATA_STARTED.trigger();
        tr_mon.c_dvalid[tr_helper.n_data] = cycle_count;
        tr_mon.t_dvalid[tr_helper.n_data] = $time;

`ifdef CALLBACKS
        // Do pre read beat callback
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          pre_rd_beat(this, tr))
`endif

        // Now block until the slave signals that it's ready
        while ((mon_if.monclk.rvalid !== 1'b1) ||
               (mon_if.monclk.rready !== 1'b1) )
          @(mon_if.monclk);

        // Sample data and response from the bus
        data = unshift_lane_data(tr,mon_if.monclk.rdata,tr_helper.n_data,data_bus_width,8*tr_bus.get_size());
        `uvm_info("NVDLA/DBB/MON/RD_DATA", $psprintf("rd_data_monitor data:%x. unshifted data:%x. tr.data_length:%0d",data, mon_if.monclk.rdata, tr.get_data_length()),UVM_DEBUG)
        set_bit_data_for_beat(tr, tr_helper.n_data, data);

        // Set read's data enable to 'ff to satisfy scoreboard
        wstrb = new [tr.get_byte_enable_length()];
        foreach (wstrb[i]) begin
            wstrb[i] = 8'hff;
        end
        tr.set_byte_enable(wstrb);

        // Store time of data transfer
        tr_mon.c_dready[tr_helper.n_data] = cycle_count;
        tr_mon.t_dready[tr_helper.n_data] = $time;

`ifdef CALLBACKS
        // Do post read beat callback
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          post_rd_beat(this, tr))
`endif

        if (mon_if.monclk.rlast) begin
            tr_mon.last = tr_helper.n_data;
            tr_ctrl.DATA_ENDED.trigger();
            transaction_finished(tr);
            rd_q[id].q.delete(0);        // Done with this txn.  Remove it from queue
        end

    end

endtask: rd_data_monitor

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                    TRANSACTION HANDLING
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
/// Create a new transaction using UVM factory methods.
function uvm_tlm_gp dbb_monitor::create_new_transaction();
    uvm_tlm_gp tr;
    dbb_helper_ext tr_helper;

    tr = create_new_gp();
    `CAST_DBB_EXT(,tr,helper)
    tr_helper.n_data  = -1;               // No data as yet
    tr_helper.stream_id = this.stream_id; // Set the stream ID
    return (tr);
endfunction: create_new_transaction

//////////////////////////////////////////////////////////////////////
/// All transactions which are starting call this routine.
function void dbb_monitor::transaction_started(uvm_tlm_gp tr);
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;
    dbb_mon_ext  tr_mon;
    dbb_helper_ext  tr_helper;
    byte unsigned wstrb [];
    `CAST_DBB_EXT(,tr,bus)
    `CAST_DBB_EXT(,tr,ctrl)
    `CAST_DBB_EXT(,tr,mon)
    `CAST_DBB_EXT(,tr,helper)

    // Update transaction counts
    outstanding_txns++;
    tr_mon.data_id = total_txns++;

    // Record transaction start time
    tr_mon.c_start = cycle_count;
    tr_mon.t_start = $time;

`ifdef CALLBACKS
    if (tr.is_read()) begin
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          pre_rd_trans(this, tr));
    end
    else begin
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          pre_wr_trans(this, tr));
    end
`endif

    // Indicate that the transaction is starting
    tr_ctrl.TXN_STARTED.trigger();
    accept_tr(tr);
    begin_tr(tr);

    // Indicate when going from idle to active
    if (outstanding_txns == 1)
      OBSERVING.trigger(tr);


    // Set read's data enable to '00 to satisfy scoreboard
    `uvm_info("NVDLA/DBB/MON/TR_START", $psprintf("byte_enable_length:%0d, len=%0d, size=%0d",
        tr.get_byte_enable_length(), tr_bus.get_length(), tr_bus.get_size()), UVM_FULL)
    wstrb = new [tr.get_byte_enable_length()];
    foreach (wstrb[i]) begin
        wstrb[i] = 8'hff;
    end
    tr.set_byte_enable(wstrb);

    `uvm_info("NVDLA/DBB/MON/TXN_TRACE",
              $psprintf("Starting transaction 'h%08x.",tr.get_address()),UVM_FULL);
    `uvm_info("NVDLA/DBB/MON/TXN_TRACE",{"\n",tr.sprint()},UVM_DEBUG);

endfunction: transaction_started

//////////////////////////////////////////////////////////////////////
/// All transactions which are finishing call this routine.
function void dbb_monitor::transaction_finished(uvm_tlm_gp tr);
    dbb_ctrl_ext tr_ctrl;
    dbb_mon_ext  tr_mon;
    dbb_helper_ext  tr_helper;
    `CAST_DBB_EXT(,tr,ctrl)
    `CAST_DBB_EXT(,tr,mon)
    `CAST_DBB_EXT(,tr,helper)

    // Update transaction count
    outstanding_txns--;

    // Record transaction start time
    tr_mon.c_end = cycle_count;
    tr_mon.t_end = $time;

    // Indicate if going from active to idle
    if (outstanding_txns == 0)
      OBSERVING.reset();

    // Indicate that the transaction is finished
    tr_ctrl.TXN_ENDED.trigger();
    end_tr(tr);

    tr.set_response_status(UVM_TLM_OK_RESPONSE);

`ifdef CALLBACKS
    if (tr.is_read()) begin
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          post_rd_trans(this, tr));
    end
    else begin
        `uvm_do_callbacks(dbb_monitor,dbb_monitor_callbacks,
                          post_wr_trans(this, tr));
    end
`endif

    // Post to transaction log, if enabled
    if(enable_logging)  logger.log_txn(tr);

    `uvm_info("NVDLA/DBB/MON/TR_FINISH", $psprintf("Starting pre_send_checks for above tr.", tr_helper.print(tr)),UVM_FULL)
    tr_helper.pre_send_checks(tr);
    // Always write to analysis port
    mon_analysis_port.write(tr);

    `uvm_info("NVDLA/DBB/MON/TXN_TRACE",
              $psprintf("Completed transaction 'h%08x.",tr.get_address()),UVM_FULL);
    `uvm_info("NVDLA/DBB/MON/TXN_TRACE",{"\n",tr.sprint()},UVM_DEBUG);

endfunction: transaction_finished

`endif
