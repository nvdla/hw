`ifndef dbb_slave_driver__SV
`define dbb_slave_driver__SV

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                  class dbb_slave_driver_callbacks
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

typedef class dbb_slave_driver;
   
`ifdef DRIVER_CALLBACKS
/// Callback class for the dbb_slave_driver.
class dbb_slave_driver_callbacks extends uvm_callback;

    /// Creates a new dbb_slave_driver_callbacks object
    function new(string name = "dbb_slave_driver_callbacks");
        super.new(name);
    endfunction: new

    /// Called at start of observed transaction after latching relevant signal values.
    virtual function void pre_trans(dbb_slave_driver xactor,
                                    uvm_tlm_gp tr);
    endfunction: pre_trans

    /// Called at end of observed transaction.
    virtual function void post_trans(dbb_slave_driver xactor,
                                     uvm_tlm_gp tr);
    endfunction: post_trans

    /// Called immediately before driving response (read or write).
    virtual function void pre_response(dbb_slave_driver xactor,
                                       uvm_tlm_gp tr);
    endfunction: pre_response
    
    /// Called immediately after driving response (read or write).
    virtual function void post_response(dbb_slave_driver xactor,
                                        uvm_tlm_gp tr);
    endfunction: post_response

    /// Called just before mem.write() calls to allow end user to skip
    /// mem.write().  Return 1 through skip to avoid the mem.write() call,
    /// default is to allow mem.write() call to occur as soon as data and
    /// address become available.
    virtual function void skip_mem_write(dbb_slave_driver xactor,
                                         uvm_tlm_gp tr,
                                         ref bit skip);
    endfunction: skip_mem_write
    
    /// Called immediately after receipt of the last beat of write data.
    virtual function void post_write_data(dbb_slave_driver xactor,
                                          uvm_tlm_gp tr);
    endfunction: post_write_data

    /// Used to arbitrarily delay the assertion of ARREADY.  This is called when RVALID asserts.  If
    /// it returns true ARREADY will stay low and this function will be called again on the next
    /// clock cycle.  This callback is never called if default_arready_value is 1.
    virtual function bit arready_backpressure( dbb_slave_driver xactor,
                                               uvm_tlm_gp tr);
    endfunction : arready_backpressure

    /// Used to arbitrarily delay the assertion of AWREADY.  This is called when BVALID asserts.  If
    /// it returns true AWREADY will stay low and this function will be called again on the next
    /// clock cycle.  This callback is never called if default_awready_value is 1.
    virtual function bit awready_backpressure( dbb_slave_driver xactor,
                                               uvm_tlm_gp tr);
    endfunction : awready_backpressure

    /// Used to arbitrarily delay the assertion of WREADY.  This is called when BVALID asserts.  If
    /// it returns true WREADY will stay low and this function will be called again on the next
    /// clock cycle.  This callback is never called if default_wready_value is 1.
    virtual function bit wready_backpressure( dbb_slave_driver xactor,
                                              uvm_tlm_gp tr);
    endfunction : wready_backpressure

endclass: dbb_slave_driver_callbacks

//typedef uvm_callbacks #(dbb_slave_driver#(MEM_DATA_WIDTH), dbb_slave_driver_callbacks) dbb_slv_cb;
`endif
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                    class delay_queue
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

/// Keeps track of out-of-order and delay parameters when dealing with out-of-order
/// responses.
class delay_queue;

    uvm_tlm_gp txn; ///< Pointer to base transaction object.
    int          Timeout;    ///< Timeout counter.
    int          OutOfOrder; ///< Keeps track of how many transaction have passed this one in the queue.
    int          Delay;      ///< Keeps track of current delay amount.

    function new(uvm_tlm_gp tr,int resp_timeout, int time_delay);
        dbb_ctrl_ext tr_ctrl;
        `CAST_DBB_EXT(,tr,ctrl)
        txn        = tr;
        Delay      = time_delay;
        OutOfOrder = tr_ctrl.out_of_order;
        Timeout    = resp_timeout;
    endfunction: new
    
    /// Debug display procedure.
    function string psdisplay();
        dbb_bus_ext txn_bus;
        `CAST_DBB_EXT(,txn,bus)
        psdisplay = $psprintf("%08x (%02d):   Delay: %0d, Timeout: %0d OutOfOrder: %0d",
                              txn.get_address(),txn_bus.get_id(),Delay,Timeout,OutOfOrder);
    endfunction: psdisplay

    /// Called each cycle to decrement delay and timeout counters.
    function decrement_counters();
        if (Delay > 0) Delay--;
        if (Timeout > 0) Timeout--;
    endfunction: decrement_counters

endclass: delay_queue

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                 class read_data_queue_item, read_data_queue
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

/// This class keeps track of the interleaving of read data from dbb_slave_driver
/// back to the master.
///
class read_data_queue_item;
    uvm_tlm_gp tr;      ///< Pointer to the underlying transaction object
    int cur_subburst;            ///< What is the current subburst?
    int burst_cnt;               ///< Count of transactions for current subburst
    int subburst_cnt;            ///< Overall transaction count
    
    function new(uvm_tlm_gp tr);
        int cur_subburst = 0;
        int burst_cnt    = 0;
        int subburst_cnt = 0;
        this.tr = tr;
    endfunction: new
    
    //////////////////////////////////////////////////////////////////////
    /// Returns true if current subburst can provide another data beat.
    function bit ready();
        // Cases when it can't are not in current dbb spec
        ready = 1;
    endfunction: ready

    //////////////////////////////////////////////////////////////////////
    /// We've sent a data beat, increment counters
    function void bump();
        burst_cnt++;
        subburst_cnt++;
    endfunction: bump

    //////////////////////////////////////////////////////////////////////
    /// Move to the next subburst, and reset the subburst counter
    function void reload();
        cur_subburst++;
        subburst_cnt = 0;
    endfunction: reload
    
    //////////////////////////////////////////////////////////////////////
    /// Returns true if we've sent our last data beat
    function bit last();
        dbb_bus_ext tr_bus;
       `CAST_DBB_EXT(,tr,bus)
        return (burst_cnt+1 >= tr_bus.get_length());
    endfunction: last

    //////////////////////////////////////////////////////////////////////
    /// Debug display routine
    function string psdisplay();
        dbb_bus_ext tr_bus;
        `CAST_DBB_EXT(,tr,bus)
        psdisplay = $psprintf("%08x (ID:%02d,%03d):  CurBurst:%0d B_cnt:%0d SB_cnt:%0d __ ",
                              tr.get_address(),tr_bus.get_id(),tr_bus.get_length(),
                              cur_subburst,burst_cnt,subburst_cnt);
        for (int i=0; i<tr.get_data_length(); i++)
          psdisplay = $psprintf("%s %s%0d",psdisplay,(i==cur_subburst)?"*":"",tr.m_data[i]);

        if (cur_subburst >= tr.get_data_length())
          psdisplay = $psprintf("%s >>>",psdisplay);
        
    endfunction: psdisplay

endclass: read_data_queue_item

//////////////////////////////////////////////////////////////////////
/// Manages queue of read data items. See the description for
/// read_data_queue_item for more information.   
class read_data_queue;

    read_data_queue_item txn_queue[$];
    int max_interleave_depth;
    int current_index;

    function new(int max_interleave_depth);
        current_index = 0;
        this.max_interleave_depth = max_interleave_depth;
    endfunction: new
    
    //////////////////////////////////////////////////////////////////////
    /// Add a new transaction to the queue.
    function void push_queue(uvm_tlm_gp tr);
        read_data_queue_item new_item;

        new_item = new(tr);
        txn_queue.push_back(new_item);

    endfunction: push_queue

    //////////////////////////////////////////////////////////////////////
    /// Figures out from which queue entry (transaction) the next data beat needs to
    /// come from.
    function uvm_tlm_gp next_data_beat();
        bit next_good;
        
        // If we have nothing in queue, immediately return
        if (txn_queue.size() == 0) return (null);

        // If we've run past the end of the queue, roll back to 0 again
        if (current_index >= txn_queue.size()) begin
            current_index = 0;
        end
        
        // If the current entry cannot provide the next beat of data, advance to the
        // next entry that can.
        if (!txn_queue[current_index].ready()) begin
            txn_queue[current_index].reload();
            next_subburst();
        end

        // Return a pointer to the transaction which will provide the next data beat
        next_data_beat = txn_queue[current_index].tr;

        // If we just consumed the last data beat, delete the queue entry, and update
        // the index pointer to a valid entry
        if (txn_queue[current_index].last()) begin
            next_good = next_entry_ok();
            txn_queue.delete(current_index);
            if (!next_good) current_index = 0;
        end
        else txn_queue[current_index].bump(); // Increment data counters
        
    endfunction: next_data_beat

    //////////////////////////////////////////////////////////////////////
    /// Figure out which entry will supply the next data beat.
    function void next_subburst();
        bit found;
        
        found = 0;
        do begin
            if (!next_entry_ok()) begin // If we can't point to the next entry, wrap around
                current_index = 0;
            end
            else begin
                current_index++;
            end
            // Now check and see if the new entry is really ready
            if (!txn_queue[current_index].ready()) begin
                txn_queue[current_index].reload(); // skip a turn
            end
            else begin
                found = 1;
            end
        end while (!found);
        
    endfunction: next_subburst

    //////////////////////////////////////////////////////////////////////
    /// Used to peak ahead and see if we can increment the queue pointer by one.
    /// If we can't go to the next entry, we'll have to wrap back around to 0.
    /// Reasons why the next entry cannot be used are:
    ///  * Hit the end of the queue
    ///  * Would exceed max_interleave_depth
    ///  * Next entry has ID which is already being used in current interleave
    function bit next_entry_ok();

        next_entry_ok = !((txn_queue.size() - 1 <= current_index) ||                  // Hit end of queue?
                          ((current_index + 1 >= max_interleave_depth) && 
                           (max_interleave_depth > 0)) ||                             // Exceed max interleave depth?
                          id_in_use());                                               // Next entry ID already in use?
        
    endfunction: next_entry_ok
    

    //////////////////////////////////////////////////////////////////////
    /// Returns true if the next index beyond to current pointer is already in
    /// use earlier in the queue.
    function bit id_in_use();
        dbb_bus_ext tr_bus;
        dbb_bus_ext cur_tr_bus;
        `CAST_DBB_EXT_PRE(txn_queue[current_index+1].,cur,tr,bus)
        for (int i=0; i<= current_index; i++) begin
            `CAST_DBB_EXT(txn_queue[i].,tr,bus)
            if (cur_tr_bus.get_id() == tr_bus.get_id()) return (1);
        end
        return (0);
    endfunction: id_in_use


    //////////////////////////////////////////////////////////////////////
    /// Resets the state of the queue and the index counter.
    function void clear_state();
        txn_queue = '{};
        current_index = 0;
    endfunction: clear_state

    //////////////////////////////////////////////////////////////////////
    /// Debug display routine.
    function void displayqueue();
        // WAR for VCS bug
        int idx_temp; 

        $display("---- Current Queue @%0t ----",$time);

        foreach (txn_queue[i]) begin
            idx_temp = i;
            $display("%s #%0d %s", (idx_temp==current_index)? "*" : " " , idx_temp, txn_queue[idx_temp].psdisplay());
        end
    endfunction: displayqueue

endclass: read_data_queue
  
typedef class dbb_slave_agent;

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                    class dbb_slave_driver
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
///      This file implements the baseclass for all nvdla family slave drivers.
class dbb_slave_driver #(int MEM_DATA_WIDTH=512, type REQ = uvm_tlm_gp, RSP = REQ ) extends uvm_driver#(REQ, RSP);
    parameter MEM_WSTRB_WIDTH = MEM_DATA_WIDTH/8;
    string                tID;

    /// nvdla Slave Driver Configuration Parameters


    // Transaction counts
    int outstanding_txns;
    int total_txns;
    
    // DBB Interface
    virtual dbb_interface#(MEM_DATA_WIDTH).Slave drv_if;

    // Slave memory model
`ifdef DBB_AGENT_TEST
    //for dbb_agent_testing only
    nitro_mem   mem;
`else
    // used to connect to memory model for access
    uvm_tlm_b_initiator_socket#(uvm_tlm_gp) mem_initiator;
`endif

    // Delay & Reorder Queues
    protected uvm_tlm_gp write_data_queue[$];
    protected uvm_tlm_gp write_resp_queue[$];
    protected delay_queue rdata_delay_queue[$];
    protected delay_queue wresp_delay_queue[$];

    // Read Data Queue
    protected read_data_queue read_data_queue;

    // Active Transaction Queue
    int active_txn_q[uvm_tlm_gp];

    // Synchronize concurrent loops
    protected semaphore write_address_channel_complete;
    protected semaphore write_data_channel_complete;
    protected semaphore write_response_reorder_complete;
    protected semaphore read_address_channel_complete;
    protected semaphore read_response_reorder_complete;
    protected semaphore pull_new_transaction;
    // start_write_transaction_sem is for preventing race conditions between the write address and
    // write data channel when awvaid and wvalid go high on the same clock cycle.  Both channel
    // processes can start a new transaction when their respsective valids go high.  Without this
    // proection, if the simulator jumps from one process to another, it is possible for both
    // channels to start the process which causes a deadlock.
    //   The code that get protected is starts with checking if the transaction already exists in
    //   write_data_queue and ends with inserting the newly created transaction into the queue.
    local     semaphore start_write_transaction_sem;

    /// Enum for tracking state or read address, write address and write data channels.
    typedef enum {READY_HIGH, 
                  READY_LOW, 
                  READY_DELAY, 
                  VALID_TO_READY_DELAY, 
                  DRIVING_READY
                  } state_delay_e;

    //---------------------------- CONFIGURATION PARAMETERS --------------------------------
    /// @name Configuration Parameters
    /// nvdla DBB Slave Driver Configuration Parameters. These parameters can be controlled
    /// through the UVM configuration database.

    ///@{
    int stream_id      = 32'hdbbd17; ///< Stream identifier. The stream ID of the driver is stored
                             ///< all of the transaction objects which are processed by the
                             ///< driver. This can be useful in things such as
                             ///< scoreboards which receive transactions from multiple
                             ///< sources through the same port.


    /// Drive x's onto the bus between transactions. Similar to 'drive_z_between_txns', but
    /// drives x when the bus is not active. This can be useful for testing x-prop
    /// characteristics. Takes precedence over drive_z_between_txns.
    bit      drive_x_between_txns = 0;

    /// Drive z's onto the bus between transactions. DBB doesn't actually use tri-state busses,
    /// but this mode is helpful during verification to make it easy to see when transactions
    /// are active, and it also could potentially catch somebody latching data where they're
    /// not supposed to.
    bit      drive_z_between_txns = 1;
    
    /// Drive random values when bus is inactive.
    /// If the drive_x/z_between_txns parameters are not set, this parameter determines whether
    /// signals are left driving previous values, or whether the signals are randomized
    bit      randomize_inactive_signals = 1;

    /// Defines the width of the data bus for this transactor. This variable really only
    /// affects how data is formatted for the data bus, since the width determines
    /// how many lanes of data there are.
    int      data_bus_width = MEM_DATA_WIDTH;
    
    /// Specifies default value of AWREADY.
    rand bit default_awready_value = 0;
    
    /// Specifies default value of ARREADY.
    rand bit default_arready_value = 0;
    
    /// Specifies default value of WREADY.
    rand bit default_wready_value = 0;

    /// Specifies maximum number of cycles that a transaction will wait to issue
    /// a response out of order. If the required number of transactions have not
    /// been allowed to issue a response before this timer runs out, the response
    /// will be issued anyway to prevent potential deadlock.
    int      response_order_timeout = 1000;
    
    ///@}

    extern function new(string        inst = "dbb_slave_driver",
                        uvm_component parent = null);
   
    `uvm_component_param_utils_begin(dbb_slave_driver#(MEM_DATA_WIDTH))
        `uvm_field_int(stream_id,                 UVM_DEFAULT)
        `uvm_field_int(drive_x_between_txns,      UVM_DEFAULT)
        `uvm_field_int(drive_z_between_txns,      UVM_DEFAULT)
        `uvm_field_int(randomize_inactive_signals,UVM_DEFAULT)
        `uvm_field_int(data_bus_width,            UVM_DEFAULT)
        `uvm_field_int(default_awready_value,     UVM_DEFAULT)
        `uvm_field_int(default_arready_value,     UVM_DEFAULT)
        `uvm_field_int(default_wready_value,      UVM_DEFAULT)
        `uvm_field_int(response_order_timeout,    UVM_DEFAULT)
    `uvm_component_utils_end

    // Event Notifications
    uvm_event EXECUTING; ///< Indicates when the driver is still active. This can
                         ///< be checked to see whether or not the driver is ready
                         ///< to end the simulation or not.

    /// Socket for external synchronization
    uvm_tlm_b_initiator_socket  tlm_socket;     ///< DEPRECATED. TLM socket used for external sync mode
   
`ifdef DRIVER_CALLBACKS
    `uvm_register_cb(dbb_slave_driver#(MEM_DATA_WIDTH),dbb_slave_driver_callbacks)
`endif

    /// @name UVM Phases
    ///@{
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern function void start_of_simulation_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    ///@}

    ///@name Reset and Quiesce Values
    ///@{
    extern virtual function void reset_xactor();
    extern virtual function void init_semaphores();
    extern function void quiesce_bus();
    extern protected task detect_reset();
    extern protected function void cleanup_async_reset();    
    extern protected function void kill_txn(uvm_tlm_gp txn);
    ///@}

    typedef class dbb_slave_driver_read_address_channel_sm;
    typedef class dbb_slave_driver_write_address_channel_sm;
    typedef class dbb_slave_driver_write_data_channel_sm;

    ///@name Channel and Reorder Threads
    dbb_slave_driver_read_address_channel_sm      read_address_channel_sm;
    dbb_slave_driver_write_address_channel_sm     write_address_channel_sm;
    extern protected task read_data_channel();
    extern protected task read_response_reorder();
    dbb_slave_driver_write_data_channel_sm        write_data_channel_sm;
    extern protected task write_response_channel();
    extern protected task write_response_reorder();
    ///@}

    ///@name Transaction Handling
    extern function uvm_tlm_gp create_new_gp();
    extern virtual function bit [`DBB_ADDR_WIDTH-1:0] calculate_beat_address(int beatnum, ref uvm_tlm_gp tr);
    extern virtual function bit is_access_allowed(bit [`DBB_ADDR_WIDTH-1:0] addr, ref uvm_tlm_gp tr);
    //////////////////////////////////////////////////////////////////////
    /// In the case that access is not allowed (per is_access_allowed),
    /// what should be be returned on a read type of access?
    function bit [MEM_DATA_WIDTH-1:0] get_disallowed_read_data(bit [`DBB_ADDR_WIDTH-1:0] addr, ref uvm_tlm_gp tr);
        get_disallowed_read_data = {MEM_DATA_WIDTH{1'bx}};
    endfunction: get_disallowed_read_data
    
//////////////////////////////////////////////////////////////////////
    extern protected task init_read_txn(ref uvm_tlm_gp tr);
    extern protected task init_write_txn(ref uvm_tlm_gp tr);
    extern protected task get_new_transaction(ref uvm_tlm_gp tr);
    extern function void rightsize_txn_arrays(uvm_tlm_gp tr);
    extern function void upsize_txn_arrays(uvm_tlm_gp tr);
    extern function void check_txn_arrays(uvm_tlm_gp tr);

    extern protected task transaction_started(uvm_tlm_gp tr);
    extern protected task transaction_finished(uvm_tlm_gp tr);
    ///@}

    ///@name Read Transaction Processing
    extern protected function void insert_read_data(uvm_tlm_gp tr);
    extern protected function uvm_tlm_gp get_next_read_beat();
    extern protected task drive_read_data_channel(uvm_tlm_gp tr);
    extern protected function dbb_ctrl_ext#()::resp_type_e get_read_response(uvm_tlm_gp tr);
    extern protected function void quiesce_read_data_channel();
    ///@}


    /// @name Write Transaction Processing
    ///@{
    extern protected function void check_write_data_complete(uvm_tlm_gp tr);
    extern protected function void sample_write_address(uvm_tlm_gp tr, bit size_init_array);
    extern protected task sample_write_data(uvm_tlm_gp tr);
    extern protected task write_beat_finished(uvm_tlm_gp tr);
    extern protected task find_write_txn_for_beat(ref uvm_tlm_gp tr);
    extern protected function uvm_tlm_gp check_write_before_addr();
    extern protected function void delete_from_write_data_queue(uvm_tlm_gp tr);
    ///@}

    /// @name Write Response
    ///@{
    extern protected function void insert_write_response(uvm_tlm_gp tr);
    extern protected function void drive_write_resp_channel(uvm_tlm_gp tr);
    extern protected function dbb_ctrl_ext#()::resp_type_e get_write_response(uvm_tlm_gp tr);
    extern protected function void quiesce_write_resp_channel();
    ///@}

    /// @name dbb_helper_ext helper functions
    ///@{
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
    
    //----------------------------------------------------------------------
    /// This function extracts data read the bus from its proper byte lane, then does
    /// a read-modify-write based on byte enables and existing data.
    function bit [MEM_DATA_WIDTH-1:0]
      unshift_and_merge(uvm_tlm_gp tr,
                                       bit [MEM_DATA_WIDTH-1:0]  busdata,
                                       bit [MEM_DATA_WIDTH-1:0]  existingdata,
                                       bit [MEM_WSTRB_WIDTH-1:0] wstrb,
                                       int                        beatnum,
                                       int                        dbus_width = MEM_DATA_WIDTH,
                                       int                        number_bits);
        bit [MEM_DATA_WIDTH-1:0] mask;
    
        // Convert write strobes into a bit mask
        mask      = get_strobe_mask(wstrb);
        `uvm_info("DBB_HELPER_EXT/UNSHIFT_AND_MERGE", $psprintf("wstrb:%#0x .. preshiftmask:%#0x", wstrb, mask), UVM_DEBUG)
    
        // Shift both the mask and the bus data out of byte lane to right justified
        mask    >>= (byte_lane(tr,beatnum,dbus_width,number_bits) * number_bits);
        busdata >>= (byte_lane(tr,beatnum,dbus_width,number_bits) * number_bits);
        `uvm_info("DBB_HELPER_EXT/UNSHIFT_AND_MERGE", $psprintf("byte_lane:%0d .. postshift mask:%#0x .. postshift busdata:%#0x",byte_lane(tr,beatnum,dbus_width,number_bits), mask, busdata), UVM_DEBUG)
    
        // Mask the new bus data and existing memory data
        busdata      &= mask;
        existingdata &= ~mask;
        `uvm_info("DBB_HELPER_EXT/UNSHIFT_AND_MERGE", $psprintf("busdata:%#0x .. existingdata:%#0x", busdata, existingdata), UVM_DEBUG)
    
        // Merge new bus data with existing memory data based on write strobes
        unshift_and_merge = busdata + existingdata;
    
    endfunction: unshift_and_merge
    //----------------------------------------------------------------------
    /// This function returns the value that should be driven onto the data
    /// bus for a particular beat, shifted into its proper byte lane.
    function bit [MEM_DATA_WIDTH-1:0] shift_lane_data(uvm_tlm_gp tr,
                                     int beatnum,
                                     int dbus_width = MEM_DATA_WIDTH,
                                     int number_bits);
        bit [MEM_DATA_WIDTH-1:0] mask;
        dbb_bus_ext tr_bus;
        `CAST_DBB_EXT(,tr,bus);
    
        // Shift data left if this happens to be an unaligned beat.
        //shift_lane_data = get_data_for_beat(tr,beatnum) << 8*misalignment_offset(tr, beatnum);
        get_bit_data_for_beat(tr, beatnum, shift_lane_data);
        `uvm_info("DBB_HELPER_EXT/SHIFT_LANE_DATA", $psprintf("busdata:%#0x .. size:%#0x", shift_lane_data, tr_bus.get_size()), UVM_DEBUG)
        shift_lane_data <<= 8*misalignment_offset(tr, beatnum);
        `uvm_info("DBB_HELPER_EXT/SHIFT_LANE_DATA", $psprintf("busdata:%#0x .. size:%#0x .. beatnum:%0d .. misalignment_offset:%0d", shift_lane_data, tr_bus.get_size(), beatnum, misalignment_offset(tr, beatnum)), UVM_DEBUG)
        // Calculate data mask
        mask = (1 << number_bits) - 1;
        `uvm_info("DBB_HELPER_EXT/SHIFT_LANE_DATA", $psprintf("mask:%#0x", mask), UVM_DEBUG)
        // Mask only the valid bits before driving onto bus, just to make sure
        // we don't try to drive too large of a data value.
        shift_lane_data &= mask;
        // Now shift into proper byte lane
        shift_lane_data <<= (byte_lane(tr,beatnum,dbus_width,number_bits) * number_bits);
        `uvm_info("DBB_HELPER_EXT/SHIFT_LANE_DATA", $psprintf("busdata:%#0x .. bits:%0d", shift_lane_data, number_bits), UVM_DEBUG)
    
    endfunction: shift_lane_data
    //----------------------------------------------------------------------
    /// This function returns the value that should be driven onto the wstrb
    /// bus for a particular beat, shifted into its proper byte lane.
    /// The value stored in the transaction is masked first, to prevent too
    /// many bits from being driven.
    function bit [MEM_WSTRB_WIDTH-1:0] shift_lane_wstrb(uvm_tlm_gp tr,
                                                                        int beatnum,
                                                                        int dbus_width = MEM_DATA_WIDTH,
                                                                        int number_bits);
        bit [MEM_WSTRB_WIDTH-1:0] mask;
    
        // Shift left for unaligned beat.
        //shift_lane_wstrb = get_wstrb_for_beat(tr,beatnum) << misalignment_offset(tr, beatnum);
        get_bit_wstrb_for_beat(tr, beatnum, shift_lane_wstrb);
        shift_lane_wstrb <<= misalignment_offset(tr, beatnum);
        // Calculate data mask
        mask = (1 << (number_bits/8)) - 1;
        // Mask off only the valid bits
        shift_lane_wstrb &= mask;
        // Now shift them into proper byte lane
        shift_lane_wstrb <<= (byte_lane(tr,beatnum,dbus_width,number_bits) * (number_bits/8));
    
    endfunction: shift_lane_wstrb
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
    /// Applies a given write strobe to the given data and returns the result.
    function bit [MEM_DATA_WIDTH-1:0]
      apply_write_strobe(bit [MEM_DATA_WIDTH-1:0] busdata,
                                        bit [MEM_WSTRB_WIDTH-1:0] wstrobe);
        bit [MEM_DATA_WIDTH-1:0] mask;
    
        mask = get_strobe_mask(wstrobe);
        return(busdata & mask);
    
    endfunction: apply_write_strobe
    
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
    //----------------------------------------------------------------------
    /// Using only tlm's get_data/set_data is not nice for building up txns
    /// This will get the right data slice for a given beat
    function void get_bit_data_for_beat(uvm_tlm_gp tr, int beatnum, ref bit [MEM_DATA_WIDTH-1:0] ret_data );
        //uvm_tlm_gp m_data is an array of unsigned bytes. which is not how we originally organized data for multiple beats of axi data. This will treat use n_data, burst length, and size to determine where to slice up the array. Data is organized as first beat data in lowest indexes.
        int i;
        int starting_byte;
        int bytes_per_beat;
        byte unsigned original_data [];
        dbb_bus_ext tr_bus;
        `CAST_DBB_EXT(,tr,bus)
        bytes_per_beat = tr_bus.get_size();
        if (MEM_DATA_WIDTH < 8*bytes_per_beat) begin
            `uvm_fatal("DBB_HELPER_EXT", $psprintf("Data width not sized correctly. %0d needs to be larger than $d", MEM_DATA_WIDTH, 8*bytes_per_beat))
        end
        starting_byte = beatnum * bytes_per_beat;
        tr.get_data(original_data);
        `uvm_info("DBB_HELPER_EXT/GET_BIT_DATA_FOR_BEAT", $psprintf("starting_byte:%0d, bytes_per_beat:%0d, beatnum:%0d",starting_byte, bytes_per_beat, beatnum), UVM_DEBUG)
        for (i=0; i<bytes_per_beat; i++) begin
          `uvm_info("DBB_HELPER_EXT/GET_BIT_DATA_FOR_BEAT", $psprintf("ret_data:%#0x, original_data:%#0x",ret_data[i*8+:8], original_data[starting_byte+i]), UVM_DEBUG)
          ret_data[i*8+:8] = original_data[starting_byte+i];
        end     
    endfunction : get_bit_data_for_beat
    function void get_bit_wstrb_for_beat(uvm_tlm_gp tr, int beatnum, ref bit [MEM_WSTRB_WIDTH-1:0] ret_wstrb);
        int i;
        int starting_byte;
        int bytes_per_beat;
        byte unsigned original_wstrb [];
        dbb_bus_ext tr_bus;
        `CAST_DBB_EXT(,tr,bus)
        bytes_per_beat = tr_bus.get_size();
        if (MEM_WSTRB_WIDTH < bytes_per_beat) begin
            `uvm_fatal("DBB_HELPER_EXT", $psprintf("Data width not sized correctly. %0d needs to be larger than $d", MEM_DATA_WIDTH, bytes_per_beat))
        end
        starting_byte = beatnum * bytes_per_beat;
        tr.get_byte_enable(original_wstrb);
        for (i=0; i<bytes_per_beat; i++) begin
          ret_wstrb[i*8+:8] = original_wstrb[starting_byte+i];
        end     
    endfunction : get_bit_wstrb_for_beat
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
    ///@}
    
    // Nested helper classses.  The state machine object for the AW, AR, and W channels.
    class dbb_slave_driver_read_address_channel_sm extends dbb_channel_ready_driver_sm;
        dbb_slave_driver#(MEM_DATA_WIDTH) driver;              // Reference to parent driver instance.
        uvm_tlm_gp    active_rdadd_txn;    // Reference to active read address transaction

        `uvm_object_utils_begin( dbb_slave_driver_read_address_channel_sm )
        `uvm_object_utils_end

        extern virtual task wait_clock();
        extern virtual function void drive_ready( logic value );
        extern virtual function logic sample_valid();
        extern virtual function int get_valid_ready_delay();
        extern virtual function int get_ready_delay();
        extern virtual task initiate_beat();
        extern virtual task beat_finished();

`ifdef DRIVER_CALLBACKS
        extern virtual function bit do_backpressure_callback();
`endif

        extern virtual task post_sm();

        function new( string name = "dbb_slave_driver_read_address_channel_sm" );
            super.new( name );
        endfunction

    endclass : dbb_slave_driver_read_address_channel_sm

    class dbb_slave_driver_write_address_channel_sm extends dbb_channel_ready_driver_sm;
        dbb_slave_driver#(MEM_DATA_WIDTH) driver;              // Reference to parent driver instance.
        uvm_tlm_gp    active_wradd_txn;    // Reference to active write address transaction

        `uvm_object_utils_begin( dbb_slave_driver_write_address_channel_sm )
        `uvm_object_utils_end

        extern virtual task wait_clock();
        extern virtual function void drive_ready( logic value );
        extern virtual function logic sample_valid();
        extern virtual function int get_valid_ready_delay();
        extern virtual function int get_ready_delay();
        extern virtual task initiate_beat();
        extern virtual task beat_finished();

`ifdef DRIVER_CALLBACKS
        extern virtual function bit do_backpressure_callback();
`endif

        extern virtual task post_sm();

        function new( string name = "dbb_slave_driver_write_address_channel_sm" );
            super.new( name );
        endfunction

    endclass : dbb_slave_driver_write_address_channel_sm

    class dbb_slave_driver_write_data_channel_sm extends dbb_channel_ready_driver_sm;
        dbb_slave_driver#(MEM_DATA_WIDTH)  driver;              // Reference to parent driver instance.
        uvm_tlm_gp     active_wrd_txn;

        `uvm_object_utils_begin( dbb_slave_driver_write_data_channel_sm )
        `uvm_object_utils_end

        extern virtual task wait_clock();
        extern virtual function void drive_ready( logic value );
        extern virtual function logic sample_valid();
        extern virtual function int get_valid_ready_delay();
        extern virtual function int get_ready_delay();
        extern virtual task initiate_beat();
        extern virtual task beat_finished();

`ifdef DRIVER_CALLBACKS
        extern virtual function bit do_backpressure_callback();
`endif

        extern virtual task pre_sm();
        extern virtual task post_sm();

        function new( string name = "dbb_slave_driver_write_data_channel_sm" );
            super.new( name );
        endfunction

    endclass : dbb_slave_driver_write_data_channel_sm
    
    ////////////////////////////////////////////////////////////////////////////////
    /// Returns the stream ID of the driver.
    function int get_stream_id();
        return stream_id;
    endfunction: get_stream_id

    ////////////////////////////////////////////////////////////////////////////////
    /// Sets the stream ID of the driver. This can also be set through the UVM
    /// configuration database ("stream_id").
    function void set_stream_id(int sid);
        stream_id = sid;
    endfunction: set_stream_id

    // Function to unpack an array of bytes into array of bits.
    function bit [MEM_DATA_WIDTH-1:0] byte_to_bit (uvm_tlm_gp tr, int n_beat);
        int i;
        byte unsigned p[];
        int byte_per_beat;
        tr.get_data(p);
        byte_per_beat = $clog2(MEM_DATA_WIDTH);
        byte_to_bit = MEM_DATA_WIDTH-1'b0; //Just in case p is less than width/8
        // Needs to be constant compile time expression, but if it's too big and not sized right then the last index of p is overwritten with any byte after n=length bytes
        for(i=byte_per_beat*n_beat; i<byte_per_beat*(n_beat+1);i++) begin
            byte_to_bit[i*8+:8] = p[i];
        end
    endfunction
    
    // Function to pack an array of bits into array of bytes. Takes lower n=length bytes
    function bit_to_byte (bit [MEM_DATA_WIDTH-1:0] bits, int length, ref uvm_tlm_gp tr);
        int i;
        byte unsigned p[] = new[length];
        // Needs to be constant compile time expression, but if it's too big and not sized right then the last index of p is overwritten with any byte after n=length bytes
        for(i=0; i<length;i++) begin
            p[i] = bits[i*8+:8];
        end
        tr.set_data(p);
        tr.set_data_length(length);
        tr.set_streaming_width(length);
    endfunction


endclass : dbb_slave_driver

//////////////////////////////////////////////////////////////////////
/// Creates new dbb_slave_driver object
function dbb_slave_driver::new(string        inst = "dbb_slave_driver",
                                     uvm_component parent = null);

    super.new(inst, parent);

    // Create event objects
        EXECUTING = new();

    // Initialize some internal class objects
    read_data_queue = new(1); // 1 means no interleaving

    read_address_channel_sm                     = new( "read_address_channel_sm" );
    read_address_channel_sm.driver              = this;
    read_address_channel_sm.delay_beat_finish   = 1;

    write_address_channel_sm                    = new( "write_address_channel_sm" );
    write_address_channel_sm.driver             = this;
    write_address_channel_sm.delay_beat_finish  = 1;

    write_data_channel_sm                   = new( "write_data_channel_sm" );
    write_data_channel_sm.driver            = this;
    write_data_channel_sm.delay_beat_finish = 1;

    // Initialize semaphores
    init_semaphores();
   
endfunction: new

//////////////////////////////////////////////////////////////////////
/// Automatically runs during the UVM build phase.
function void dbb_slave_driver::build_phase(uvm_phase phase);
    dbb_slave_agent n_agent;
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_LOW)

    uvm_config_int::get(this,"", "stream_id", stream_id);
    uvm_config_int::get(this,"","drive_x_between_txns",drive_x_between_txns);
    uvm_config_int::get(this,"","drive_z_between_txns",drive_z_between_txns);
    uvm_config_int::get(this,"","randomize_inactive_signals",randomize_inactive_signals);
    uvm_config_int::get(this,"","data_bus_width",data_bus_width);
    uvm_config_int::get(this,"","default_awready_value",default_awready_value);
    uvm_config_int::get(this,"","default_arready_value",default_arready_value);
    uvm_config_int::get(this,"","default_wready_value",default_wready_value);
    uvm_config_int::get(this,"","response_order_timeout",response_order_timeout);

    // If a memory has been externally configured, use it. Otherwise create a new
    // memory model for the slave to use.
`ifdef DBB_AGENT_TEST
    //for dbb_agent_testing only
    if (!uvm_config_db#(nitro_mem)::get(this, "", "mem", mem)) begin
        mem = nitro_mem#()::type_id::create("mem",this);
    end
`else
    mem_initiator = new("mem_initiator", this);
`endif

    read_address_channel_sm.default_ready_value     = default_arready_value;
    write_address_channel_sm.default_ready_value    = default_awready_value;
    write_data_channel_sm.default_ready_value       = default_wready_value;
endfunction: build_phase

//////////////////////////////////////////////////////////////////////
/// Automatically runs during the UVM connect phase.
function void dbb_slave_driver::connect_phase(uvm_phase phase);
    virtual dbb_interface#(MEM_DATA_WIDTH) temp_if;
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)

`ifdef DBB_AGENT_TEST
    mem.udo = nitro_mem::DATA_SAME_AS_ADDR;
`endif
    // Hook up the virtual interface here
    if (!uvm_config_db#(virtual dbb_interface#(MEM_DATA_WIDTH))::get(this, "", "drv_if", temp_if)) begin
        if (!uvm_config_db#(virtual dbb_interface#(MEM_DATA_WIDTH).Slave)::get(this, "", "drv_if", drv_if)) begin
            `uvm_fatal("NVDLA/DBB/SLV/DRV/NOVIF", "No virtual interface specified for this driver instance")
        end
    end
    else begin
        drv_if = temp_if;
    end

endfunction: connect_phase

//////////////////////////////////////////////////////////////////////
/// Automatically runs during the UVM end of elaboration phase.
function void dbb_slave_driver::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    if (drv_if == null)
      `uvm_fatal("NVDLA/DBB/SLV/DRV/NO_CONN", "Virtual port not connected to an actual interface instance.");
    read_address_channel_sm.set_report_handler( this.get_report_handler );
    read_address_channel_sm.set_report_id(  "NVDLA/DBB/SLV/DRV/ARCHAN" );
    write_address_channel_sm.set_report_handler( this.get_report_handler );
    write_address_channel_sm.set_report_id(  "NVDLA/DBB/SLV/DRV/AWCHAN" );
    write_data_channel_sm.set_report_handler( this.get_report_handler );
    write_data_channel_sm.set_report_id(  "NVDLA/DBB/SLV/DRV/WCHAN" );
endfunction: end_of_elaboration_phase

//////////////////////////////////////////////////////////////////////
/// Automatically runs during the UVM start of simulation phase.
function void dbb_slave_driver::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    quiesce_bus();   // Reset output signals
endfunction: start_of_simulation_phase

//////////////////////////////////////////////////////////////////////
// Task: main_phase
// Used to execute mainly run-time tasks of simulation
task dbb_slave_driver::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_LOW)

    forever begin
        @(posedge drv_if.clk);
        // reset handler
        // txn pulling
        // txn driving
    end
endtask : main_phase

//////////////////////////////////////////////////////////////////////
/// Quiesces the bus and resets all state information.
function void dbb_slave_driver::reset_xactor();

    quiesce_bus();               // Reset output signals

    // Initialize Semaphores
    init_semaphores();

    // Clear out queues
    write_data_queue  = '{};
    write_resp_queue  = '{};
    rdata_delay_queue = '{};
    wresp_delay_queue = '{};
    read_data_queue.clear_state();

    // Other cleanup
    outstanding_txns = 0;

endfunction: reset_xactor

//////////////////////////////////////////////////////////////////////
/// Initialize all semaphores used in driver.
function void dbb_slave_driver::init_semaphores();
    write_address_channel_complete  = new(0);
    write_data_channel_complete     = new(0);
    write_response_reorder_complete = new(0);
    read_address_channel_complete   = new(0);
    read_response_reorder_complete  = new(0);
    pull_new_transaction            = new(1);
    start_write_transaction_sem     = new(1);
endfunction: init_semaphores
  
//////////////////////////////////////////////////////////////////////
/// Drives quiescent values onto the bus. Ready line values are set
/// by configuration values. If drive_z_between_txns configuration parameter
/// is set, then z's are driven. If not then either 0's or random values
/// are driven, based on randomize_inactive_signals value.
function void dbb_slave_driver::quiesce_bus();
    // Reset output signals
    drv_if.sclk.rvalid  <= 0;
    drv_if.sclk.bvalid  <= 0;
    drv_if.sclk.awready <= (default_awready_value)?1:0;
    drv_if.sclk.arready <= (default_arready_value)?1:0;
    drv_if.sclk.wready  <= (default_wready_value)?1:0;

    if (drive_x_between_txns) begin
        drv_if.sclk.rlast  <= 'x;
        drv_if.sclk.rdata  <= 'x;
        drv_if.sclk.rid    <= 'x;
        drv_if.sclk.bid    <= 'x;
        drv_if.sclk.bresp  <= 'x;
    end
    else if (drive_z_between_txns) begin
        drv_if.sclk.rlast  <= 'z;
        drv_if.sclk.rdata  <= 'z;
        drv_if.sclk.rid    <= 'z;
        drv_if.sclk.bid    <= 'z;
        drv_if.sclk.bresp  <= 'z;
    end
    else begin
        drv_if.sclk.rlast  <= (randomize_inactive_signals)?$urandom():0;
        drv_if.sclk.rdata  <= (randomize_inactive_signals)?$urandom():0;
        drv_if.sclk.rid    <= (randomize_inactive_signals)?$urandom():0;
        drv_if.sclk.bid    <= (randomize_inactive_signals)?$urandom():0;
        drv_if.sclk.bresp  <= (randomize_inactive_signals)?$urandom():0;
    end
endfunction: quiesce_bus

////////////////////////////////////////////////////////////////////////////////
/// Called automatically during UVM run phase. Forks off all BFM threads in parallel.
/// If the detect_reset returns, it means that a reset on the bus was detected, which
/// will cause all the threads to be killed and restarted.
task dbb_slave_driver::run_phase(uvm_phase phase);
    // Not in uvm1.1
    //seq_item_port.disable_auto_item_recording();
    
    forever begin
        // Wait for a clock, we want reset to be stable
        @(posedge drv_if.clk);

        // Wait here if in reset    
        if (drv_if.rst_n !== '1) @(posedge drv_if.rst_n);

        // Fork off all of the concurrent control loops.  The only thread that
        // could end here is the detect_reset(). All others will loop forever.
        fork
            detect_reset();
            read_address_channel_sm.start();
            write_address_channel_sm.start();
            read_data_channel();
            read_response_reorder();
            write_data_channel_sm.start();
            write_response_channel();
            write_response_reorder();
        join_any
        disable fork;
        cleanup_async_reset();
        reset_xactor();

    end
    
endtask: run_phase

function uvm_tlm_gp dbb_slave_driver::create_new_gp();
    uvm_tlm_gp   gp;
    dbb_bus_ext  bus_ext;
    dbb_ctrl_ext ctrl_ext;
    dbb_helper_ext helper_ext;
    byte unsigned p[] = new[1];
    byte unsigned q[] = new[1];

    gp       = uvm_tlm_gp::type_id::create();
    bus_ext  = new();
    ctrl_ext = new();
    helper_ext = new();

    gp.set_extension(bus_ext);
    gp.set_extension(ctrl_ext);
    gp.set_extension(helper_ext);

    gp.set_data(p);
    gp.set_byte_enable(q);
    gp.set_data_length(1);
    gp.set_streaming_width(1);
    gp.set_byte_enable_length(1);

    return gp;
endfunction : create_new_gp

////////////////////////////////////////////////////////////////////////////////
/// Wait until the reset line drops, then exit routine. This will initiate
/// all of the asynchronous reset cleanup activity.
task dbb_slave_driver::detect_reset();
    @(negedge drv_if.rst_n);
endtask: detect_reset

////////////////////////////////////////////////////////////////////////////////
/// Steps through all transaction pointers and terminates any active transactions.
/// transaction_started() and transaction_finished() routines will be called as
/// necessary.
function void dbb_slave_driver::cleanup_async_reset();    

    // Kill any transaction currently active
    foreach (active_txn_q[txn])
      kill_txn(txn);

    if (outstanding_txns != 0) begin
        `uvm_error("NVDLA/DBB/SLV/DRV/RESET_SYNC",
                   $psprintf("Transactor Sync Error on Reset (%0d)",outstanding_txns));
    end
    
endfunction: cleanup_async_reset

////////////////////////////////////////////////////////////////////////////////
/// Kills an ongoing transaction as a result of detecting reset getting pulled.
/// Will call transaction_started or transaction_finished if needed.
function void dbb_slave_driver::kill_txn(uvm_tlm_gp txn);
    if (txn) begin
        dbb_ctrl_ext txn_ctrl;
        `CAST_DBB_EXT(,txn,ctrl)
        if (txn_ctrl.TXN_STARTED.is_off())
          transaction_started(txn);
        if (txn_ctrl.TXN_ENDED.is_off()) begin
            // Set status to show why transaction was killed
            txn_ctrl.transtat = dbb_ctrl_ext::NVDLA_TS_RESET;
            `uvm_info("NVDLA/DBB/SLV/DRV/RESET_KILL",
                      $psprintf("Transaction killed due to reset: 'h%08x",txn.get_address()),UVM_FULL);
            // Now finish the transaction
            transaction_finished(txn);
        end
    end
endfunction: kill_txn

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                    READ ADDRESS CHANNEL
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
// Interface functions for the state machine object.

task dbb_slave_driver::dbb_slave_driver_read_address_channel_sm::wait_clock();
    @(driver.drv_if.sclk);
endtask

function void dbb_slave_driver::dbb_slave_driver_read_address_channel_sm::drive_ready( logic value );
    driver.drv_if.sclk.arready <= value;
endfunction

function logic dbb_slave_driver::dbb_slave_driver_read_address_channel_sm::sample_valid();
    return driver.drv_if.sclk.arvalid;
endfunction

function int dbb_slave_driver::dbb_slave_driver_read_address_channel_sm::get_valid_ready_delay();
    dbb_ctrl_ext active_rdadd_txn_ctrl;
    `CAST_DBB_EXT(,active_rdadd_txn,ctrl)
    return active_rdadd_txn_ctrl.avalid_aready_delay;
endfunction

function int dbb_slave_driver::dbb_slave_driver_read_address_channel_sm::get_ready_delay();
    dbb_ctrl_ext active_rdadd_txn_ctrl;
    `CAST_DBB_EXT(,active_rdadd_txn,ctrl)
    return active_rdadd_txn_ctrl.aready_delay;
endfunction

task dbb_slave_driver::dbb_slave_driver_read_address_channel_sm::initiate_beat();
    `uvm_info("DBB/SLV/DRV/RDADD/INITIATE_BEAT", "dbb_slave_driver::dbb_slave_driver_read_address_channel_sm::initiate_beat", UVM_DEBUG)
    driver.init_read_txn(active_rdadd_txn);
    driver.transaction_started(active_rdadd_txn);
endtask

task dbb_slave_driver::dbb_slave_driver_read_address_channel_sm::beat_finished();
    driver.insert_read_data(active_rdadd_txn);
endtask

`ifdef DRIVER_CALLBACKS
function bit dbb_slave_driver::dbb_slave_driver_read_address_channel_sm::do_backpressure_callback();
    `uvm_do_obj_callbacks_exit_on(dbb_slave_driver#(MEM_DATA_WIDTH),dbb_slave_driver_callbacks, driver,
                                  arready_backpressure(driver, active_rdadd_txn), 1)
endfunction
`endif

task dbb_slave_driver::dbb_slave_driver_read_address_channel_sm::post_sm();
    // Signal read data buffer to go
    driver.read_address_channel_complete.put(1);
endtask

//////////////////////////////////////////////////////////////////////
/// For the general case, defer to transaction's math for calculating
/// conversion from beat to address.  For specific conversion, derive
/// from this class and create a new calculate_beat_address() function
/// in the child class.
function bit [`DBB_ADDR_WIDTH-1:0] dbb_slave_driver::calculate_beat_address(int beatnum, ref uvm_tlm_gp tr);
    dbb_helper_ext tr_helper;
    `CAST_DBB_EXT(,tr,helper)
    calculate_beat_address = tr_helper.beat_address(tr, beatnum);
endfunction: calculate_beat_address

//////////////////////////////////////////////////////////////////////
/// For the general case, all transactions to all addresses are allowed
/// For specific implementations, we may desire to disallow accesses to
/// various address ranges based on transaction attributes
function bit dbb_slave_driver::is_access_allowed(bit [`DBB_ADDR_WIDTH-1:0] addr, ref uvm_tlm_gp tr);
    is_access_allowed = 1;
endfunction: is_access_allowed

/// Initialize a new read transaction.
/// When a new read address is detected, this routine will create a new
/// transaction object for the read, and sample all address and control
/// information from the bus.
task dbb_slave_driver::init_read_txn(ref uvm_tlm_gp tr);
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;
    dbb_helper_ext tr_helper;
    byte unsigned wstrb[];

    // Get a new transaction from the sequencer port
    get_new_transaction(tr);
    tr.set_response_status(UVM_TLM_INCOMPLETE_RESPONSE);
    `CAST_DBB_EXT(,tr,bus)
    `CAST_DBB_EXT(,tr,ctrl)
    `CAST_DBB_EXT(,tr,helper)

    // Now initialize object with observed read address control data
    tr.set_read();
    tr.set_address(drv_if.sclk.araddr);
    tr_bus.set_size(1<<drv_if.sclk.arsize);
    // Necessary to limit transaction to 16 beats and to avoid consumption 
    // of Zs if defines not correctly limiting width 
    tr_bus.set_length(drv_if.sclk.arlen[3:0] + 1);
    tr_bus.set_id(drv_if.sclk.arid);
    tr_helper.n_data = 0;
    tr.set_data_length(1);
    tr.set_streaming_width(1);
    tr.set_byte_enable_length(1);
    // Size the transaction appropriately, now that we have all the control information
    rightsize_txn_arrays(tr);
    // Set read's data enable to 'ff to satisfy scoreboard
    wstrb = new [tr.get_byte_enable_length()];
    foreach (wstrb[i]) begin
        wstrb[i] = 8'hff;
    end
    tr.set_byte_enable(wstrb);
    `uvm_info("DBB/SLV/DRV/INIT_READ_TXN", $psprintf("length is %d, size is %d, get_data_length is %d", tr_bus.get_length(), tr_bus.get_size(), tr.get_data_length()), UVM_FULL)
    
    // Indicate that the read address phase has started
    tr_ctrl.ADDRESS_STARTED.trigger();

endtask: init_read_txn

//////////////////////////////////////////////////////////////////////
/// Initialize a new read response object, and insert it into the queue.
function void dbb_slave_driver::insert_read_data(uvm_tlm_gp tr);
    delay_queue rddq;
    dbb_ctrl_ext tr_ctrl;
    dbb_helper_ext tr_helper;
    `CAST_DBB_EXT(,tr,ctrl);
    `CAST_DBB_EXT(,tr,helper);

    tr_ctrl.ADDRESS_ENDED.trigger();
    // Create delay queue entry
    `uvm_info("NVDLA/DBB/SLV/DRV/TXN_TRACE",{"\n",tr_helper.print(tr)},UVM_DEBUG);
    rddq = new(tr,response_order_timeout,tr_ctrl.address_rvalid_delay);
    // Push it into the read data delay queue
    rdata_delay_queue.push_back(rddq);
    
endfunction: insert_read_data

//////////////////////////////////////////////////////////////////////
///   This loop sits between the read_address_channel loop and the
/// read_data_channel_loop. It enforces the AddressRvalidDelay, and
/// also does the read response reordering. If a transaction times
/// out while here, it gets forwarded on immediately.
task dbb_slave_driver::read_response_reorder();
    dbb_bus_ext i_txn_bus;
    dbb_bus_ext j_txn_bus;
    bit blocked;

    forever begin: forever_loop

        @(drv_if.sclk);

        // Let read address channel complete first.
        read_address_channel_complete.get();

        // For a response to be advanced it's delay as well as it's OutOfOrder
        // requirement must be met, or else the Timeout must have expired.
        for (int i=0; i<rdata_delay_queue.size(); i++) begin

            // Determine if I'm blocked or not by looking at those waiting before me
            // I can only be blocked if:
            //  -  Any previously queued txn has the same ID
            //  -  Any previously queued txn has OutOfOrder set to 0
            blocked = 0;
            `CAST_DBB_EXT_PRE(rdata_delay_queue[i].,i,txn,bus);
            for (int j=0; j<i; j++) begin
              `CAST_DBB_EXT_PRE(rdata_delay_queue[j].,j,txn,bus);
              if ((j_txn_bus.get_id() == i_txn_bus.get_id()) ||
                  (rdata_delay_queue[j].OutOfOrder == 0))
                blocked = 1;
            end

            // If we're not blocked, check to see if we're good to go. This means either
            //   - We're not blocked, and we've satisified OutOfOrder requirement and Delay requirement
            //   - We're not blocked, and we've timed out
            if ((! blocked) &&
                (((rdata_delay_queue[i].Delay == 0) && (rdata_delay_queue[i].OutOfOrder == 0)) ||
                 (rdata_delay_queue[i].Timeout == 0))) begin
                // We're good to go. Now we have to:
                //  - Decrement OutOfOrder fields on any txns we've just passed up
                //  - Add txn to the official write response queue
                //  - Delete txn from this delay queue
                for (int j=0; j<i; j++) rdata_delay_queue[j].OutOfOrder--;
                read_data_queue.push_queue(rdata_delay_queue[i].txn);
                rdata_delay_queue.delete(i);
                i--;
            end

        end

        // Now scan through the queue for any transaction which is further down in the queue
        // with the same ID, and which has already satisfied their OutOfOrder requirement.
        // This transaction would block all other transactions and prevent me from satisfying
        // my own OutOfOrder requirement. Rather than wait for a timeout, let's clear the
        // OutOfOrder requirement.
        for (int i=0; i<rdata_delay_queue.size(); i++) begin
            if (rdata_delay_queue[i].Delay == 0) begin // Don't bother checking unless my delay is already zero
                `CAST_DBB_EXT_PRE(rdata_delay_queue[i].,i,txn,bus);
                for (int j=i+1; j<rdata_delay_queue.size(); j++) begin
                    `CAST_DBB_EXT_PRE(rdata_delay_queue[j].,j,txn,bus);
                    if ((j_txn_bus.get_id() == i_txn_bus.get_id()) && 
                        (rdata_delay_queue[j].OutOfOrder == 0)) begin
                        rdata_delay_queue[i].OutOfOrder = 0;    // Conditions exist to clear requirement
                        break;
                    end
                    if (rdata_delay_queue[j].Delay != 0) break; // Stuff is still counting down, leave alone
                end
            end
        end

        // Decrement delays and timeouts
        foreach (rdata_delay_queue[i]) begin
            rdata_delay_queue[i].decrement_counters();
        end
        
        // Now let read data channel proceed
        read_response_reorder_complete.put(1);
        
    end: forever_loop

endtask: read_response_reorder


//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                    WRITE ADDRESS CHANNEL
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
// Interface functions for the state machine object.

task dbb_slave_driver::dbb_slave_driver_write_address_channel_sm::wait_clock();
    @(driver.drv_if.sclk);
endtask

function void dbb_slave_driver::dbb_slave_driver_write_address_channel_sm::drive_ready( logic value );
    driver.drv_if.sclk.awready <= value;
endfunction

function logic dbb_slave_driver::dbb_slave_driver_write_address_channel_sm::sample_valid();
    return driver.drv_if.sclk.awvalid;
endfunction

function int dbb_slave_driver::dbb_slave_driver_write_address_channel_sm::get_valid_ready_delay();
    dbb_ctrl_ext active_wradd_txn_ctrl;
    `CAST_DBB_EXT(,active_wradd_txn,ctrl)
    return active_wradd_txn_ctrl.avalid_aready_delay;
endfunction

function int dbb_slave_driver::dbb_slave_driver_write_address_channel_sm::get_ready_delay();
    dbb_ctrl_ext active_wradd_txn_ctrl;
    `CAST_DBB_EXT(,active_wradd_txn,ctrl)
    return active_wradd_txn_ctrl.aready_delay;
endfunction

task dbb_slave_driver::dbb_slave_driver_write_address_channel_sm::initiate_beat();
    `uvm_info("DBB/SLV/DRV/WRADD/INITIATE_BEAT", "dbb_slave_driver::dbb_slave_driver_write_address_channel_sm::initiate_beat", UVM_DEBUG)
    driver.init_write_txn(active_wradd_txn);
endtask

task dbb_slave_driver::dbb_slave_driver_write_address_channel_sm::beat_finished();
    dbb_helper_ext active_wradd_txn_helper;
    `CAST_DBB_EXT(,active_wradd_txn,helper)
    `uvm_info("DBB/SLV/DRV/WRADD/INITIATE_BEAT", "dbb_slave_driver::dbb_slave_driver_write_address_channel_sm::beat_finished", UVM_DEBUG)
    driver.check_write_data_complete(active_wradd_txn);
    `uvm_info("NVDLA/DBB/SLV/DRV/TXN_TRACE",{"\n",active_wradd_txn_helper.print(active_wradd_txn)},UVM_DEBUG);
endtask

`ifdef DRIVER_CALLBACKS
function bit dbb_slave_driver::dbb_slave_driver_write_address_channel_sm::do_backpressure_callback();
    `uvm_do_obj_callbacks_exit_on(dbb_slave_driver#(MEM_DATA_WIDTH),dbb_slave_driver_callbacks, driver,
                                  awready_backpressure(driver, active_wradd_txn), 1)
endfunction
`endif

task dbb_slave_driver::dbb_slave_driver_write_address_channel_sm::post_sm();
    // Tell data channel that it's their turn to process
    driver.write_address_channel_complete.put(1);
endtask

////////////////////////////////////////////////////////////////////////////////
/// When the write address channel detects a new write address, it calls
/// this routine. Checks to see if it needs to create a new object for it, or if
/// write data has come out first so that the transaction already exists.
/// Write address and control information is sampled, and any data which came
/// out before the transaction type was known is now adjusted to compensate
/// for proper byte lane.
task dbb_slave_driver::init_write_txn(ref uvm_tlm_gp tr);
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;
    dbb_helper_ext tr_helper;
    int obs_len; 
    int wstrb_len;
    bit [MEM_DATA_WIDTH-1:0] memorydata;
    
    `uvm_info( "NVDLA/DBB/SLV/DRV/AWCHAN", "Getting start_write_transaction_sem.", UVM_FULL )
    start_write_transaction_sem.get();
    `uvm_info( "NVDLA/DBB/SLV/DRV/AWCHAN", "Got start_write_transaction_sem.", UVM_FULL )

    tr = check_write_before_addr();

    // If data wasn't present first, we'll need to create a new object
    if (tr == null) begin
        // Grab a new transaction from the sequencer port
        get_new_transaction(tr);
        tr.set_response_status(UVM_TLM_INCOMPLETE_RESPONSE);
        `CAST_DBB_EXT(,tr,helper)
        `CAST_DBB_EXT(,tr,ctrl)
        tr_helper.n_data = -1;                      // No valid data yet
        tr_helper.write_before_addr = 0;

        // Get control information and start transaction
        sample_write_address(tr, 1); //Sets data/wstrb length to 1
        transaction_started(tr);

        // Push transaction into the queue to wait for write data
        write_data_queue.push_back(tr);

        `uvm_info( "NVDLA/DBB/SLV/DRV/AWCHAN", "Returning start_write_transaction_sem. (New txn)", UVM_FULL )
        start_write_transaction_sem.put();
    end
    else begin
        `CAST_DBB_EXT(,tr,bus)
        `CAST_DBB_EXT(,tr,ctrl)
        `CAST_DBB_EXT(,tr,helper)
        `uvm_info("NVDLA/DBB/SLV/DRV/TXN_TRACE",{"\n",tr_helper.print(tr)},UVM_DEBUG);
        `uvm_info( "NITRO/AXI/SLV/DRV/AWCHAN", "Returning start_write_transaction_sem. (Txn exists)", UVM_FULL )
        start_write_transaction_sem.put();

        obs_len = tr.get_data_length();
        // Update existing transaction with address info
        sample_write_address(tr, 0); //Leaves data/wstrb length as is

        if (tr_ctrl.DATA_ENDED.is_on()) begin
            // If all of the data was already done, and we were just waiting for the address,
            // check to see that we really got the right amount of data.
            if (tr_bus.get_length()*tr_bus.get_size() != obs_len) begin
                `uvm_error("NVLDA/DBB/SLV/DRV/LEN_MSMTCH",
                           $psprintf("Observed length of %0d doesn't match transaction length\n%s",
                                     obs_len,tr.sprint()));
            end
        end
    end
    `CAST_DBB_EXT(,tr,helper)
    `uvm_info("NVDLA/DBB/SLV/DRV/TXN_TRACE",{"\n",tr_helper.print(tr)},UVM_DEBUG);
    
    // Indicate the start of the address
    tr_ctrl.ADDRESS_STARTED.trigger();
    
endtask: init_write_txn

//////////////////////////////////////////////////////////////////////
/// This function is called at the end of the address phase. It
/// indicates that the address is complete, then checks to see if both
/// the address and data are finished as a result of all of the
/// data having come out early. If it's all done, it cleans up and
/// puts the transaction into the write response queue.
function void dbb_slave_driver::check_write_data_complete(uvm_tlm_gp tr);
    dbb_ctrl_ext tr_ctrl;
    dbb_helper_ext tr_helper;
    `CAST_DBB_EXT(,tr,ctrl)
    `CAST_DBB_EXT(,tr,helper)

    // Indicate address phase is over
    tr_ctrl.ADDRESS_ENDED.trigger();

    // If both address and data are finished, take this out of the data
    // queue and queue this up for the write response.
    if (tr_ctrl.DATA_ENDED.is_on()) begin
        int _before = write_data_queue.size();
        int after;
        delete_from_write_data_queue(tr);
        after = write_data_queue.size();
        if (_before == after)
            `uvm_error("DELETE ERROR", "write_data_queue size same as before")
        `uvm_info("NVDLA/DBB/SLV/DRV/TXN_TRACE",{"\n",tr_helper.print(tr)},UVM_DEBUG);
        insert_write_response(tr);
    end
endfunction: check_write_data_complete

//////////////////////////////////////////////////////////////////////
/// Samples the address and control information from the bus and stores
/// it in the transaction object.
function void dbb_slave_driver::sample_write_address(uvm_tlm_gp tr, bit size_init_array);
    dbb_bus_ext tr_bus;
    `CAST_DBB_EXT(,tr,bus)
    // Now initialize object with observed write address control data
    tr.set_write();
    tr.set_address(drv_if.sclk.awaddr);
    tr_bus.set_size(1<<drv_if.sclk.awsize);
    // Necessary to limit transaction to 16 beats and to avoid consumption 
    // of Zs if defines not correctly limiting width
    tr_bus.set_length(drv_if.sclk.awlen[3:0] + 1);
    tr_bus.set_id(drv_if.sclk.awid);
    if (size_init_array) begin
        tr.set_data_length(1);
        tr.set_streaming_width(1);
        tr.set_byte_enable_length(1);
    end else begin
        // In this case data length and byte_enable have been built up already
        tr.set_streaming_width(tr.get_data_length());
    end
    // Size the transaction appropriately, now that we have all the control information
    rightsize_txn_arrays(tr);
endfunction: sample_write_address      

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                    READ DATA CHANNEL
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
/// Main control loop for the read data channel.
task dbb_slave_driver::read_data_channel();
    uvm_tlm_gp active_rdd_txn;
    dbb_ctrl_ext active_rdd_txn_ctrl;
    dbb_helper_ext active_rdd_txn_helper;
    int next_rvalid_delay  = 0;
    
    forever begin: forever_loop

        @(drv_if.sclk);

        // Wait for data buffer loop to finish
        read_response_reorder_complete.get();
        
        if (active_rdd_txn) begin
            if (drv_if.sclk.rready) begin // Data is finished?
                next_rvalid_delay = active_rdd_txn_ctrl.next_rvalid_delay[active_rdd_txn_helper.n_data];
                drv_if.sclk.rvalid <= '0;
                quiesce_read_data_channel();
                if (active_rdd_txn_helper.last_beat(active_rdd_txn)) begin
                    active_rdd_txn_ctrl.DATA_ENDED.trigger();
                    transaction_finished(active_rdd_txn);
                end
                else
                  active_rdd_txn_helper.n_data++; // Increment beat count
                active_rdd_txn = null;     // Finished with this beat
            end
        end

        if (!active_rdd_txn) begin
            if (next_rvalid_delay <= 0) begin             // Delay timer expired?
                active_rdd_txn = get_next_read_beat();        // Get next data beat
                if (active_rdd_txn) begin                     // Is there some data ready to go?
                    `CAST_DBB_EXT(,active_rdd_txn,ctrl)
                    `CAST_DBB_EXT(,active_rdd_txn,helper)
                    if (active_rdd_txn_helper.n_data == 0) begin           // Indicate data starting
                        uvm_tlm_time tlm_time = new("tlm_time");
                        active_rdd_txn_ctrl.DATA_STARTED.trigger();
                        `uvm_info("DBB/SLV/DRV/RD_DATA", $psprintf("Starting pre_send_checks for above tr. \n%s", active_rdd_txn.sprint()),UVM_FULL)
                        active_rdd_txn_helper.pre_send_checks(active_rdd_txn);
`ifdef DBB_AGENT_TEST
`else
                        active_rdd_txn.set_response_status(UVM_TLM_INCOMPLETE_RESPONSE);
                        // Delay of 0 for now
                        mem_initiator.b_transport(active_rdd_txn,tlm_time);
`endif
                        `uvm_info("DBB/SLV/DRV/RD_DATA", $psprintf("After read memory data.\n%s", active_rdd_txn.sprint()),UVM_FULL)
                    end
                    // `uvm_info("DBB/SLV/DRV/RD_DATA", $psprintf("Before drive_read_data_channel.\n%s", active_rdd_txn.sprint()),UVM_NONE)
                    drive_read_data_channel(active_rdd_txn);// Drive data beat
                    // `uvm_info("DBB/SLV/DRV/RD_DATA", $psprintf("After drive_read_data_channel.\n%s", active_rdd_txn.sprint()),UVM_NONE)
                end
            end
        end

        // Decrement valid delay counter
        if (next_rvalid_delay) next_rvalid_delay--;

    end: forever_loop
   
endtask: read_data_channel

//////////////////////////////////////////////////////////////////////
/// Returns the next beat of data to return in the read data channel.
/// Considers read data interleaving to determine which goes next.
function uvm_tlm_gp dbb_slave_driver::get_next_read_beat();

    get_next_read_beat = read_data_queue.next_data_beat();
   
endfunction: get_next_read_beat

//////////////////////////////////////////////////////////////////////
/// Drives the current beat of read data onto the read data channel.
task dbb_slave_driver::drive_read_data_channel(uvm_tlm_gp tr);
    static int rcnt;
    bit [MEM_DATA_WIDTH-1:0] beat_data;
    bit [`DBB_ADDR_WIDTH-1:0] addr;
    dbb_bus_ext tr_bus;
    dbb_helper_ext tr_helper;
    `CAST_DBB_EXT(,tr,bus)
    `CAST_DBB_EXT(,tr,helper)

    addr = calculate_beat_address(tr_helper.n_data, tr);

    drv_if.sclk.rvalid <= 1;      // Drive VALID line

    // Grab the memory values based on aligned beat address
    if ( is_access_allowed(addr, tr) ) begin
        bit [MEM_DATA_WIDTH-1:0] beat_data;
`ifdef DBB_AGENT_TEST
        beat_data = mem.read(addr, 8*tr_bus.get_size());
`else
        // Mem model read moved to read_data_channel once when n_data is 0
        beat_data = byte_to_bit(tr, tr_helper.n_data);
`endif
        `uvm_info("DBB/SLV/DRV/RD_DATA_CHAN", $psprintf("addr:%x .. busdata:%x .. size:%x",addr, beat_data, tr_bus.get_size()), UVM_DEBUG)

        // If this is an unaligned beat, shift out the unwanted data
        beat_data >>= misalignment_offset(tr, tr_helper.n_data);
        `uvm_info("DBB/SLV/DRV/RD_DATA_CHAN", $psprintf("addr:%x .. busdata:%x .. size:%x",addr, beat_data, tr_bus.get_size()), UVM_FULL)
        // set_bit_data_for_beat(tr, tr_helper.n_data,beat_data);
    end
    else begin
        bit [MEM_DATA_WIDTH-1:0] bus_data;
        bus_data = get_disallowed_read_data(addr, tr);
        set_bit_data_for_beat(tr, tr_helper.n_data, bus_data);
        `uvm_info("NVDLA/DBB/SLAVE/DRV/READ_ACCESS_VIOLATION", 
                  $psprintf("Transaction ID %d ('h%x) returned 'h%x during attempted access to address 'h%x", 
                  tr_bus.get_id(), tr_bus.get_id(), bus_data, addr), UVM_LOW);
    end

`ifdef DRIVER_CALLBACKS
    // Pre response callback
    `uvm_do_callbacks(dbb_slave_driver#(MEM_DATA_WIDTH),dbb_slave_driver_callbacks,
                      pre_response(this, tr));
`endif

    // Shift data into proper lane
    drv_if.sclk.rdata  <= shift_lane_data(tr,tr_helper.n_data,data_bus_width,8*tr_bus.get_size());
    `uvm_info("DBB/SLV/DRV/RD_DATA_CHAN", $psprintf("addr:%x .. busdata:%x .. size:%x",addr, shift_lane_data(tr,tr_helper.n_data,data_bus_width,8*tr_bus.get_size()), tr_bus.get_size()), UVM_DEBUG)
    drv_if.sclk.rid    <= tr_bus.get_id();
    drv_if.sclk.rlast  <= (tr_helper.last_beat(tr))?1:0;
    
`ifdef DRIVER_CALLBACKS
    // Post response callback
    `uvm_do_callbacks(dbb_slave_driver#(MEM_DATA_WIDTH),dbb_slave_driver_callbacks,
                      post_response(this, tr));
`endif

endtask: drive_read_data_channel

//////////////////////////////////////////////////////////////////////
/// Return proper read response, honoring any requested FORCEs.
function dbb_ctrl_ext#()::resp_type_e dbb_slave_driver::get_read_response(uvm_tlm_gp tr);
    dbb_helper_ext tr_helper;
    `CAST_DBB_EXT(,tr,helper)
      
    case (tr_helper.status_err[tr_helper.n_data])
      dbb_helper_ext#()::NO_FORCE:
        // Return EXOKAY if exclusive was requested. We should already be monitoring this address.
          get_read_response = dbb_ctrl_ext#()::OKAY;
      dbb_helper_ext#()::FORCE_EXOKAY:
        get_read_response = dbb_ctrl_ext#()::EXOKAY;
      dbb_helper_ext#()::FORCE_SLVERR:
        get_read_response = dbb_ctrl_ext#()::SLVERR;
      dbb_helper_ext#()::FORCE_DECERR:
        get_read_response = dbb_ctrl_ext#()::DECERR;
      dbb_helper_ext#()::FORCE_OKAY:
        get_read_response = dbb_ctrl_ext#()::OKAY;
    endcase

endfunction: get_read_response


//////////////////////////////////////////////////////////////////////
/// Drive quiescent values into read data channel.
function void dbb_slave_driver::quiesce_read_data_channel();

    drv_if.sclk.rvalid <= 0;

    if (drive_x_between_txns) begin
        drv_if.sclk.rdata <= 'x;
        drv_if.sclk.rid   <= 'x;
        drv_if.sclk.rlast <= 'x;
    end
    else if (drive_z_between_txns) begin
        drv_if.sclk.rdata <= 'z;
        drv_if.sclk.rid   <= 'z;
        drv_if.sclk.rlast <= 'z;
    end
    else if (randomize_inactive_signals) begin
        drv_if.sclk.rdata <= $urandom();
        drv_if.sclk.rid   <= $urandom();
        drv_if.sclk.rlast <= $urandom();
    end

endfunction: quiesce_read_data_channel

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                    WRITE DATA CHANNEL
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
// Interface functions for the state machine object.

task dbb_slave_driver::dbb_slave_driver_write_data_channel_sm::wait_clock();
    @(driver.drv_if.sclk);
endtask

function void dbb_slave_driver::dbb_slave_driver_write_data_channel_sm::drive_ready( logic value );
    driver.drv_if.sclk.wready <= value;
endfunction

function logic dbb_slave_driver::dbb_slave_driver_write_data_channel_sm::sample_valid();
    return driver.drv_if.sclk.wvalid;
endfunction

function int dbb_slave_driver::dbb_slave_driver_write_data_channel_sm::get_valid_ready_delay();
    dbb_ctrl_ext active_wrd_txn_ctrl;
    dbb_helper_ext active_wrd_txn_helper;
    `CAST_DBB_EXT(,active_wrd_txn,ctrl)
    `CAST_DBB_EXT(,active_wrd_txn,helper)
    return active_wrd_txn_ctrl.wvalid_wready_delay[active_wrd_txn_helper.n_data];
endfunction

function int dbb_slave_driver::dbb_slave_driver_write_data_channel_sm::get_ready_delay();
    dbb_ctrl_ext active_wrd_txn_ctrl;
    dbb_helper_ext active_wrd_txn_helper;
    `CAST_DBB_EXT(,active_wrd_txn,ctrl)
    `CAST_DBB_EXT(,active_wrd_txn,helper)
    return active_wrd_txn_ctrl.wready_delay[active_wrd_txn_helper.n_data];
endfunction

task dbb_slave_driver::dbb_slave_driver_write_data_channel_sm::initiate_beat();
    `uvm_info("DBB/SLV/DRV/WRDATA/INITIATE_BEAT", "dbb_slave_driver::dbb_slave_driver_write_data_channel_sm::initiate_beat", UVM_DEBUG)
    driver.find_write_txn_for_beat(active_wrd_txn);
endtask

task dbb_slave_driver::dbb_slave_driver_write_data_channel_sm::beat_finished();
    driver.write_beat_finished(active_wrd_txn);
endtask

`ifdef DRIVER_CALLBACKS
function bit dbb_slave_driver::dbb_slave_driver_write_data_channel_sm::do_backpressure_callback();
    `uvm_do_obj_callbacks_exit_on(dbb_slave_driver#(MEM_DATA_WIDTH),dbb_slave_driver_callbacks, driver,
                                  wready_backpressure(driver, active_wrd_txn), 1)
endfunction
`endif

task dbb_slave_driver::dbb_slave_driver_write_data_channel_sm::pre_sm();
    // Let write address channel complete first to make sure that address
    // is handled before simultaneous data for that same transaction
    driver.write_address_channel_complete.get();
endtask

task dbb_slave_driver::dbb_slave_driver_write_data_channel_sm::post_sm();
    // Tell data channel that it's their turn to process
    driver.write_data_channel_complete.put(1);
endtask

//////////////////////////////////////////////////////////////////////
/// Samples write data off the bus. Also applies write strobes, unshifts it,
/// and stores it in the transaction object.
task dbb_slave_driver::sample_write_data(uvm_tlm_gp tr);
    bit [MEM_DATA_WIDTH-1:0] busdata;
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;
    dbb_helper_ext tr_helper;
    `CAST_DBB_EXT(,tr,bus)
    `CAST_DBB_EXT(,tr,ctrl)
    `CAST_DBB_EXT(,tr,helper)

    tr_helper.n_data++;               // Increment the current beat counter

    // Did we run out of room in our data array? Make it bigger if we need to.
    if (tr_helper.n_data*tr_bus.get_size() >= tr.get_data_length()) begin
        upsize_txn_arrays(tr);
    end
    
    if (tr_ctrl.ADDRESS_STARTED.is_on()) begin
        bit skip = 0;
        bit [`DBB_ADDR_WIDTH-1:0] addr;
        bit [MEM_DATA_WIDTH-1:0] data;
        bit [MEM_WSTRB_WIDTH-1:0] wstrb;
        
        // Apply write strobe to bus signal, get rid of any unused bus data
        busdata = apply_write_strobe(drv_if.sclk.wdata,drv_if.sclk.wstrb);
        `uvm_info("DBB/SLV/DRV/SAMPLE_WRITE_DATA/1", $psprintf("busdata:%x .. wstrb:%x",busdata,drv_if.sclk.wstrb),UVM_DEBUG)
        // Store transaction data and wstrb
        data = unshift_lane_data(tr,
                                                  busdata,
                                                  tr_helper.n_data,
                                                  data_bus_width,
                                                  8*tr_bus.get_size());
        `uvm_info("DBB/SLV/DRV/SAMPLE_WRITE_DATA/2", $psprintf("shiftdata:%x .. beatnum:%d .. bus_width:%d .. size:%d",data,tr_helper.n_data, data_bus_width, tr_bus.get_size()),UVM_DEBUG)
        set_bit_data_for_beat(tr, tr_helper.n_data, data);
        wstrb = unshift_lane_wstrb(tr,drv_if.sclk.wstrb,
                                                    tr_helper.n_data,
                                                    data_bus_width,
                                                    8*tr_bus.get_size());
        set_bit_wstrb_for_beat(tr, tr_helper.n_data, wstrb);

`ifdef DRIVER_CALLBACKS
        `uvm_do_callbacks(dbb_slave_driver#(MEM_DATA_WIDTH), dbb_slave_driver_callbacks,
                          skip_mem_write(this, tr, skip));
`endif
        if (!skip) begin
            // Now handle updating the memory. Since we could potentially not be storing all of the
            // bytes depending on the write strobe, we actually need to do a read/modify/write from the
            // memory to make sure we don't destroy any memory locations that we're not supposed to
            // be writing to.
            bit [MEM_DATA_WIDTH-1:0] beat_data;
            addr = calculate_beat_address(tr_helper.n_data, tr);
`ifdef DBB_AGENT_TEST
            beat_data = mem.read(addr, 8*tr_bus.get_size());
`else
            // Mem model takes care of data and dealing with byte enables for us
`endif
            busdata = unshift_and_merge(tr,
                                           drv_if.sclk.wdata,
                                           beat_data,
                                           drv_if.sclk.wstrb,
                                           tr_helper.n_data,
                                           data_bus_width,
                                           8*tr_bus.get_size());
        `uvm_info("DBB/SLV/DRV/SAMPLE_WRITE_DATA/3", $psprintf("addr:%x .. busdata:%x .. wstrb:%x",addr, busdata,drv_if.sclk.wstrb),UVM_DEBUG)
        
            // Update the memory model
            // Don't write if this is a failed exclusive access, or we're using external sync mode
            // or if access is not allowed
            if (is_access_allowed(addr, tr)) begin
`ifdef DBB_AGENT_TEST
                `uvm_info("DBB/SLV/DRV/SAMPLE_WRITE_DATA/4", $psprintf("addr:%x .. actualdata:%x .. size:%x",addr, busdata,tr_bus.get_size()),UVM_FULL)
                mem.write(addr,
                          busdata,
                          8*tr_bus.get_size());
`else
                // Moved write of each beat to once in write_beat_finished
`endif
            end
        end // if (!skip)
    end
    else begin
        // Just store the raw data and strobes for now, we don't have any address & control
        // information to know exactly what we have yet.
        bit [MEM_DATA_WIDTH-1:0] data = apply_write_strobe(drv_if.sclk.wdata,drv_if.sclk.wstrb);
        bit [MEM_WSTRB_WIDTH-1:0] wstrb = drv_if.sclk.wstrb;
        `uvm_info("DBB/SLV/DRV/SAMPLE_WRITE_DATA/NO_ADDR", $psprintf("wstrb:%x", wstrb), UVM_DEBUG)
        set_bit_data_for_beat(tr, tr_helper.n_data, data);
        set_bit_wstrb_for_beat(tr, tr_helper.n_data, wstrb);
        for(int i=0; i<=tr_helper.n_data; i++) begin
          get_bit_wstrb_for_beat(tr, i, wstrb);
          `uvm_info("DBB/SLV/DRV/SAMPLE_WRITE_DATA/NO_ADDR", $psprintf("beat:%d wstrb:%x", i, wstrb), UVM_DEBUG)
        end
    end
       
endtask: sample_write_data

//////////////////////////////////////////////////////////////////////
/// Checks to see if the beat that just finished is the last write beat
/// of the transaction. If so, it cleans up, and passes it to the write
/// response queue.
task dbb_slave_driver::write_beat_finished(uvm_tlm_gp tr);
    dbb_ctrl_ext tr_ctrl;
    dbb_helper_ext tr_helper;
    `CAST_DBB_EXT(,tr,ctrl)
    `CAST_DBB_EXT(,tr,helper)

    if (tr_helper.last_beat(tr)) begin
        // If this is the last beat, indicate that the data is over
        tr_ctrl.DATA_ENDED.trigger();
`ifdef DRIVER_CALLBACKS
        // Call any callbacks that wanted notification that last write data beat
        // has arrived and tr is fully populated with write data
        `uvm_do_callbacks(dbb_slave_driver#(MEM_DATA_WIDTH), dbb_slave_driver_callbacks,
                          post_write_data(this, tr));
`endif
        // If the address is also over, time to hand over to write response phase
        if (tr_ctrl.ADDRESS_ENDED.is_on()) begin
            delete_from_write_data_queue(tr);
            `uvm_info("NVDLA/DBB/SLV/DRV/TXN_TRACE",{"\n",tr_helper.print(tr)},UVM_DEBUG);
            // Moved write of each beat to once in write_resp
            insert_write_response(tr);
        end
    end
      
endtask: write_beat_finished
      
//////////////////////////////////////////////////////////////////////
/// Takes the write beat that just came off of the write data bus, and
/// finds an existing transaction object for it. If one doesn't exist, we're
/// getting write data first, and need to initialize a new object. Once we
/// have the correct object, we sample the write data, and then return a pointer
/// to the correct transaction object.
///
/// This really should be a function, the expectation is that it consumes no time,
/// however, all of the routines which potentially grab data from a sequencer
/// port are implemented as tasks, so this has to be a task as well.
/// DBB has no wid signal from nvdla so uses oldest outstanding without data
task dbb_slave_driver::find_write_txn_for_beat(ref uvm_tlm_gp tr);
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;
    dbb_helper_ext tr_helper;
    `uvm_info( "NVDLA/DBB/SLV/DRV/WCHAN", "Getting start_write_transaction_sem.", UVM_FULL )
    start_write_transaction_sem.get();
    `uvm_info( "NVDLA/DBB/SLV/DRV/WCHAN", "Got start_write_transaction_sem.", UVM_FULL )

    tr = null;
    foreach (write_data_queue[i]) begin
        uvm_tlm_gp i_tr;
        dbb_bus_ext i_tr_bus;
        dbb_ctrl_ext i_tr_ctrl;
        dbb_helper_ext i_tr_helper;
        i_tr = write_data_queue[i];
        `CAST_DBB_EXT(,i_tr,bus)
        `CAST_DBB_EXT(,i_tr,ctrl)
        `CAST_DBB_EXT(,i_tr,helper)
        `uvm_info( "NVDLA/DBB/SLV/DRV/WCHAN", $psprintf("write_data_queue: i:%d, txn:%d id:%d: data_size:%d wrstrb_size:%d n_data:%d DATA_ENDED:%d ADDRESS_ENDED:%d", i, i_tr_helper.my_txn_num, i_tr_bus.get_id(), i_tr.get_data_length(), i_tr.get_byte_enable_length(), i_tr_helper.n_data, i_tr_ctrl.DATA_ENDED.is_on(), i_tr_ctrl.ADDRESS_ENDED.is_on()), UVM_FULL )
        // Don't need to match the wid, oldest tr without data gets picked
        // Skip over any transactions that have completed all of their data,
        // and are simply waiting around for the address to appear.
        if (!i_tr_ctrl.DATA_ENDED.is_on()) begin
            tr = write_data_queue[i];
            `CAST_DBB_EXT(,tr,bus)
            `CAST_DBB_EXT(,tr,ctrl)
            `CAST_DBB_EXT(,tr,helper)
            break;
        end
    end
    
    if (tr == null) begin
        // We have write data, but no address yet. We'll create a transaction as a
        // placeholder for the data, until the address appears in the channel.

        // Get a new transaction from the sequencer object
        get_new_transaction(tr);
        `CAST_DBB_EXT(,tr,bus)
        `CAST_DBB_EXT(,tr,ctrl)
        `CAST_DBB_EXT(,tr,helper)

        // Now initialize object with write control data
        tr.set_write();
        tr_bus.set_id(0); //Set 0 for now. Sample write addr will set it again
        tr_bus.set_length(1);
        tr_bus.set_size(1<<drv_if.sclk.awsize);
        tr_helper.n_data          = -1; // No valid data yet
        tr_helper.write_before_addr = 1;

        // Starting new transaction
        transaction_started(tr);

        // Now put it in the write_data_queue
        write_data_queue.push_back(tr);
    end

    `uvm_info( "NVDLA/DBB/SLV/DRV/WCHAN", "Returning start_write_transaction_sem.", UVM_FULL )
    start_write_transaction_sem.put();

    // OK, now grab the write data off of the bus, and increment n_data counter.
    sample_write_data(tr);

    // Indicate that data has started for this transaction.
    if (tr_helper.n_data == 0) tr_ctrl.DATA_STARTED.trigger();

    if (tr_ctrl.ADDRESS_STARTED.is_on()) begin
        // Do some checks. If the address has already been seen, then we really
        // know what the behavior of the WLAST signal should be.
        if (drv_if.sclk.wlast != tr_helper.last_beat(tr)) begin
            if (drv_if.sclk.wlast) begin
                `uvm_error("NVDLA/DBB/SLV/DRV/EARLY_WLAST",
                           $psprintf("WLAST asserted before the last beat\n%s",tr.sprint()));
            end
            else begin
                `uvm_error("NVDLA/DBB/SLV/DRV/LATE_WLAST",
                           $psprintf("WLAST not asserted on last beat\n%s",tr.sprint()));
            end
        end
    end
    else begin
        // If we still haven't seen the address for this transaction, we
        // also don't know the exact length. If the wlast signal isn't high,
        // we have to keep incrementing the transaction length as we go.
        if (!drv_if.sclk.wlast) begin
            `CAST_DBB_EXT(,tr,bus)
            `CAST_DBB_EXT(,tr,ctrl)
            `CAST_DBB_EXT(,tr,helper)
            if (tr_bus.get_length() == 16) begin
                `uvm_error("NVDLA/DBB/SLV/DRV/MAX_BURST",
                           "Write transaction exceeded maximum burst length of 16.");
            end else if (tr.get_data_length() == 512) begin
                `uvm_error("NVDLA/DBB/SLV/DRV/MAX_BURST",
                           "Write transaction exceeded maximum bytes of 512.");
            end
            else begin
              `uvm_info( "NVDLA/DBB/SLV/DRV/WCHAN", $psprintf("txn:%d data_size:%d wrstrb_size:%d n_data:%d len:%d DATA_ENDED:%d ADDRESS_ENDED:%d", tr_helper.my_txn_num, tr.get_data_length(), tr.get_byte_enable_length(), tr_helper.n_data, tr_bus.get_length(), tr_ctrl.DATA_ENDED.is_on(), tr_ctrl.ADDRESS_ENDED.is_on()), UVM_FULL )
              tr.set_data_length(tr_bus.get_length()*tr_bus.get_size());
              tr.set_byte_enable_length(tr_bus.get_length()*tr_bus.get_size());
              tr.set_streaming_width(tr.get_data_length());
              tr_bus.set_length(tr_bus.get_length() + 1);
            end
        end
    end

endtask: find_write_txn_for_beat      

//////////////////////////////////////////////////////////////////////
/// When a new address is seen on the write address channel, this routine is called.
/// Checks to see if a transaction object already exists as a result of write data appearing
/// before it's address. Returns the transaction object if found, otherwise null.
/// DBB has no wid signal from nvdla so uses oldest outstanding without data
function uvm_tlm_gp dbb_slave_driver::check_write_before_addr();
    uvm_tlm_gp atxn;

    atxn = null;
    // Don't need to match the wid, picks the oldest without ADDRESS_STARTED
    foreach (write_data_queue[i]) begin
        // Does the id match, and we haven't seen an address for it yet?
        uvm_tlm_gp tr;
        dbb_bus_ext tr_bus;
        dbb_ctrl_ext tr_ctrl;
        dbb_helper_ext tr_helper;
        tr = write_data_queue[i];
        `CAST_DBB_EXT(,tr,bus);
        `CAST_DBB_EXT(,tr,ctrl);
        `CAST_DBB_EXT(,tr,helper);
        `uvm_info( "NVDLA/DBB/SLV/DRV/WADDR", $psprintf("init_write_addr_txn write_data_queue: i:%d, txn:%d id:%d: data_size:%d wrstrb_size:%d n_data:%d DATA_ENDED:%d ADDRESS_ENDED:%d", i, tr_helper.my_txn_num, tr_bus.get_id(), tr.get_data_length(), tr.get_byte_enable_length(), tr_helper.n_data, tr_ctrl.DATA_ENDED.is_on(), tr_ctrl.ADDRESS_ENDED.is_on()), UVM_FULL )
        if ((!tr_ctrl.ADDRESS_STARTED.is_on())) begin
            atxn = write_data_queue[i];
            break;
        end
    end

    return atxn;

endfunction: check_write_before_addr
   
//////////////////////////////////////////////////////////////////////
/// Deletes the specified entry from the write_data_queue.
function void dbb_slave_driver::delete_from_write_data_queue(uvm_tlm_gp tr);
    foreach (write_data_queue[i]) begin
        if (write_data_queue[i] == tr) begin
            write_data_queue.delete(i);
            break;
        end
    end
endfunction: delete_from_write_data_queue   

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                    WRITE RESPONSE CHANNEL
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
/// Main control loop for the write response channel.
task dbb_slave_driver::write_response_channel();
    uvm_tlm_gp active_wresp_txn;

    forever begin: forever_loop

        @(drv_if.sclk);

        // Let response buffer do its thing first
        write_response_reorder_complete.get();
        
        if (active_wresp_txn) begin
            `uvm_info("ACTIVE_WRESP_TXN", $psprintf("write_response_channel, active_wresp_txn, bready:%d",drv_if.sclk.bready), UVM_FULL)
            if (drv_if.sclk.bready) begin // Transaction is finished?
                dbb_helper_ext active_wresp_txn_helper;
                uvm_tlm_time tlm_time = new("tlm_time");
                `CAST_DBB_EXT(,active_wresp_txn,helper)
                quiesce_write_resp_channel();
                // Finished with transaction here
                `uvm_info("DBB/SLV/DRV/WRITE_RESP_FINISHED", $psprintf("Starting pre_send_checks for above tr.", active_wresp_txn_helper.print(active_wresp_txn)),UVM_FULL)
                active_wresp_txn_helper.pre_send_checks(active_wresp_txn);
`ifdef DBB_AGENT_TEST
`else
                // Delay of 0 for now
                mem_initiator.b_transport(active_wresp_txn,tlm_time);
`endif
                transaction_finished(active_wresp_txn);
                active_wresp_txn = null;
            end
        end

        if (!active_wresp_txn) begin
            if (write_resp_queue.size()) begin                
                dbb_helper_ext active_wresp_txn_helper;
                `uvm_info("ACTIVE_WRESP_TXN", $psprintf("write_response_channel, driving txn"), UVM_FULL)
                active_wresp_txn = write_resp_queue.pop_front();
                `CAST_DBB_EXT(,active_wresp_txn,helper)
                `uvm_info("NVDLA/DBB/SLV/DRV/TXN_TRACE",{"\n",active_wresp_txn_helper.print(active_wresp_txn)},UVM_FULL);
                drive_write_resp_channel(active_wresp_txn);
            end
        end

    end: forever_loop

endtask: write_response_channel

//////////////////////////////////////////////////////////////////////
/// This loop sits between the write data channel and the write response
/// channel. The WriteBvalidDelay delay parameter is handled here, as well as
/// reordering for out of order write responses. A maximum timeout is also
/// monitored here to help prevent deadlocks.
task dbb_slave_driver::write_response_reorder();
    dbb_bus_ext i_txn_bus;
    dbb_bus_ext j_txn_bus;
    bit blocked;
    
    forever begin: forever_loop

        @(drv_if.sclk);

        // Let write data channel complete first.
        write_data_channel_complete.get();

        // For a response to be advanced it's delay requirement as well as it's OutOfORder
        // requirement must be met, or else the Timeout must have expired.
        for (int i=0; i<wresp_delay_queue.size(); i++) begin

            // Determine if I'm blocked or not by looking at those waiting before me
            // I can only be blocked if:
            //  -  Any previously queued txn has the same ID
            //  -  Any previously queued txn has OutOfOrder set to 0
            blocked = 0;
            `CAST_DBB_EXT_PRE(wresp_delay_queue[i].,i,txn,bus)
            for (int j=0; j<i; j++) begin
              `CAST_DBB_EXT_PRE(wresp_delay_queue[j].,j,txn,bus)
              if ((j_txn_bus.get_id() == i_txn_bus.get_id()) ||
                  (wresp_delay_queue[j].OutOfOrder == 0))
                blocked = 1;
            end

            // If we're not blocked, check to see if we're good to go. This means
            //   - We're not blocked, and we've satisfied OutOfOrder and Delay requirement
            //   - We're not blocked, and we've timed out
            if ((! blocked) &&
                (((wresp_delay_queue[i].Delay == 0) && (wresp_delay_queue[i].OutOfOrder == 0)) ||
                 (wresp_delay_queue[i].Timeout == 0))) begin
                // We're good to go. Now we have to:
                //  - Decrement OutOfOrder fields on any txns we've just passed up
                //  - Add txn to the official write response queue
                //  - Delete txn from this delay queue
                uvm_tlm_gp my_txn;
                dbb_helper_ext my_txn_helper;
                my_txn = wresp_delay_queue[i].txn;
                `CAST_DBB_EXT(,my_txn,helper)
                `uvm_info("NVDLA/DBB/SLV/DRV/TXN_TRACE",{"\n",my_txn_helper.print(my_txn)},UVM_DEBUG);
                for (int j=0; j<i; j++) wresp_delay_queue[j].OutOfOrder--;
                write_resp_queue.push_back(wresp_delay_queue[i].txn);
                wresp_delay_queue.delete(i);
                i--;
            end

        end

        // Now scan through the queue for any transaction which is further down in the queue
        // with the same ID, and which has already satisfied their OutOfOrder requirement.
        // This transaction would block all other transactions and prevent me from satisfying
        // my own OutOfOrder requirement. Rather than force a timeout, let's clear the
        // OutOfOrder requirement.
        for (int i=0; i<wresp_delay_queue.size(); i++) begin
            if (wresp_delay_queue[i].Delay == 0) begin // Don't bother checking unless my delay is already zero
                `CAST_DBB_EXT_PRE(wresp_delay_queue[i].,i,txn,bus)
                for (int j=i+1; j<wresp_delay_queue.size(); j++) begin
                    `CAST_DBB_EXT_PRE(wresp_delay_queue[j].,j,txn,bus)
                    if ((j_txn_bus.get_id() == i_txn_bus.get_id()) && 
                        (wresp_delay_queue[j].OutOfOrder == 0)) begin
                        wresp_delay_queue[i].OutOfOrder = 0;    // Conditions exist to clear requirement
                        break;
                    end
                    if (wresp_delay_queue[j].Delay != 0) break; // Stuff is still counting down, leave alone
                end
            end
        end

        // Decrement delays and timeouts
        foreach (wresp_delay_queue[i]) begin
            wresp_delay_queue[i].decrement_counters();
        end
        
        // Now let response_channel proceed
        write_response_reorder_complete.put(1);
        
    end: forever_loop
   
endtask: write_response_reorder
   
//////////////////////////////////////////////////////////////////////
/// This function is called to insert transactions ready for write response
/// into the delay/reorder queue.
function void dbb_slave_driver::insert_write_response(uvm_tlm_gp tr);
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;
    dbb_helper_ext tr_helper;
    delay_queue wrdq;

    `CAST_DBB_EXT(,tr,bus)
    `CAST_DBB_EXT(,tr,ctrl)
    `CAST_DBB_EXT(,tr,helper)
    `uvm_info("NVDLA/DBB/SLV/DRV/TXN_TRACE",{"\n",tr_helper.print(tr)},UVM_DEBUG);
    // Create new delay queue entry
    wrdq = new(tr,response_order_timeout,tr_ctrl.write_bvalid_delay);
    // Push it onto the delay queue
    wresp_delay_queue.push_back(wrdq);
   
endfunction: insert_write_response

//////////////////////////////////////////////////////////////////////
/// Drives the proper write response into the write response channel.
function void dbb_slave_driver::drive_write_resp_channel(uvm_tlm_gp tr);
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;

    `CAST_DBB_EXT(,tr,bus)
    `CAST_DBB_EXT(,tr,ctrl)
    // Determine proper write response
    tr_ctrl.resp[0]        = get_write_response(tr);

    // Pre Response Callback
`ifdef DRIVER_CALLBACKS
    `uvm_do_callbacks(dbb_slave_driver#(MEM_DATA_WIDTH),dbb_slave_driver_callbacks,
                      pre_response(this, tr));

`endif

    // Drive Write Response
    drv_if.sclk.bresp  <= tr_ctrl.resp[0];
    drv_if.sclk.bvalid <= 1;
    drv_if.sclk.bid    <= tr_bus.get_id();
    
    // Post Response Callback
`ifdef DRIVER_CALLBACKS
    `uvm_do_callbacks(dbb_slave_driver#(MEM_DATA_WIDTH),dbb_slave_driver_callbacks,
                      post_response(this, tr));
`endif

endfunction: drive_write_resp_channel
   
//////////////////////////////////////////////////////////////////////
/// Return proper write response, honoring any requested FORCEs.
function dbb_ctrl_ext#()::resp_type_e dbb_slave_driver::get_write_response(uvm_tlm_gp tr);
    dbb_helper_ext tr_helper;
    `CAST_DBB_EXT(,tr,helper)
      
    case (tr_helper.status_err[0])
      dbb_helper_ext#()::NO_FORCE:
          ;//calculate_excl_bresp(tr);
      dbb_helper_ext#()::FORCE_EXOKAY:
        get_write_response = dbb_ctrl_ext#()::EXOKAY;
      dbb_helper_ext#()::FORCE_SLVERR:
        get_write_response = dbb_ctrl_ext#()::SLVERR;
      dbb_helper_ext#()::FORCE_DECERR:
        get_write_response = dbb_ctrl_ext#()::DECERR;
      dbb_helper_ext#()::FORCE_OKAY:
        get_write_response = dbb_ctrl_ext#()::OKAY;
    endcase

endfunction: get_write_response
   
//////////////////////////////////////////////////////////////////////
/// Drives quiescent values into the write response channel.
function void dbb_slave_driver::quiesce_write_resp_channel();

    drv_if.sclk.bvalid <= 0;

    if (drive_x_between_txns) begin
        drv_if.sclk.bid   <= 'x;
        drv_if.sclk.bresp <= 'x;
    end
    else if (drive_z_between_txns) begin
        drv_if.sclk.bid   <= 'z;
        drv_if.sclk.bresp <= 'z;
    end
    else if (randomize_inactive_signals) begin
        drv_if.sclk.bid   <= $urandom();
        drv_if.sclk.bresp <= $urandom();
    end
   
endfunction: quiesce_write_resp_channel
   
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                    TRANSACTIONS
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
/// Called to pull a new transaction from the sequence item port. Will check
/// to make sure that this call did not block, as that would impact timing
/// elsewhere.
///   This routine is protected by a semaphore because the independent read
/// and write threads can call this routine on the same timestamp. When this
/// happens then get_next_item() could be called twice before item_done() gets
/// called, resulting in a runtime error. The semaphore makes sure the entire
/// task is run for one thread before the other starts.
task automatic dbb_slave_driver::get_new_transaction(ref uvm_tlm_gp tr);
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;
    //dbb_mon_ext tr_mon;
    dbb_helper_ext tr_helper;
    byte unsigned p[];

    pull_new_transaction.get(); // Get semaphore, only one thread can be here at a time
    
    // Blocking would be really bad here and mess up timing of the slave
    seq_item_port.try_next_item(tr);
    if (tr == null) begin
        `uvm_fatal("NVDLA/DBB/SLV/DRV/SEQNRDY",
                   "Sequencer not immediately ready with new slave txn, which blocked the slave driver.")
    end
    seq_item_port.item_done();             // Necessary to process items in parallel
    tr.set_response_status(UVM_TLM_INCOMPLETE_RESPONSE);

    // Store in the active transaction queue. This helps with cleanup in case a reset
    // occurs before the transaction completes on its own.
    active_txn_q[tr]++;

    `CAST_DBB_EXT(,tr,helper)
    tr_helper.stream_id = this.stream_id;         // Set stream id
    p = new[1];
    tr.set_data(p);
    tr.set_data_length(1);
    p = new[1];
    tr.set_byte_enable(p);
    tr.set_byte_enable_length(1);
    tr.set_streaming_width(1);
    check_txn_arrays(tr);
    
    accept_tr(tr);                         // Accept txn
    pull_new_transaction.put();            // Reset semaphore
endtask: get_new_transaction

////////////////////////////////////////////////////////////////////////////////
/// This routine is called to size the dynamic arrays in the transaction object
/// after all of the control information for the transaction has been set. It will
/// shrink or expand the array sizes as appropriate. Timing parameters get aliased
/// if necessary.
function void dbb_slave_driver::rightsize_txn_arrays(uvm_tlm_gp tr);
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;
    //dbb_mon_ext tr_mon;
    dbb_helper_ext tr_helper;
    `CAST_DBB_EXT(,tr,bus)
    `CAST_DBB_EXT(,tr,ctrl)
    //`CAST_DBB_EXT(,tr,mon)
    `CAST_DBB_EXT(,tr,helper)

    while (tr.get_data_length() < tr_bus.get_length()*tr_bus.get_size()) begin
        upsize_txn_arrays(tr);
    end
    if (tr.get_data_length() > tr_bus.get_length()*tr_bus.get_size()) begin
        tr_helper.resize_txn_arrays(tr, tr_bus.get_length()*tr_bus.get_size());
    end
    tr_ctrl.size_txn_arrays(tr_bus.get_length());
    tr_ctrl.size_txn_arrays(tr_bus.get_length());
    
endfunction: rightsize_txn_arrays


////////////////////////////////////////////////////////////////////////////////
/// This routine used to allocate more space for the dynamic arrays in the
/// transaction object. The array sizes are all doubled, and timing information
/// is duplicated from the existing values to the new values.
function void dbb_slave_driver::upsize_txn_arrays(uvm_tlm_gp tr);
    dbb_bus_ext tr_bus;
    dbb_ctrl_ext tr_ctrl;
    dbb_helper_ext tr_helper;
    int old_size = tr.get_data_length();
    int new_size;
    `CAST_DBB_EXT(,tr,ctrl)
    `CAST_DBB_EXT(,tr,bus)
    `CAST_DBB_EXT(,tr,helper)
    new_size = old_size + tr_bus.get_size();
    tr_helper.resize_txn_arrays(tr, new_size);
    // Replicate the data from the old half in the new half
    for (int i=0; i<old_size; i++) begin
        tr_helper.status_err[i+old_size]        = tr_helper.status_err[i];
        tr_ctrl.wready_delay[i+old_size]        = tr_ctrl.wready_delay[i];
        tr_ctrl.wvalid_wready_delay[i+old_size] = tr_ctrl.wvalid_wready_delay[i];
        tr_ctrl.next_rvalid_delay[i+old_size]   = tr_ctrl.next_rvalid_delay[i];
    end
endfunction: upsize_txn_arrays

////////////////////////////////////////////////////////////////////////////////
/// Checks the sizing of the dynamic arrays in the transaction object. Makes
/// sure that the data array has at least one entry. If anything is smaller than
/// the data array, it's padded accordingly. If anything is larger, a warning is
/// issued.
function void dbb_slave_driver::check_txn_arrays(uvm_tlm_gp tr);
    dbb_ctrl_ext tr_ctrl;
    //dbb_mon_ext tr_mon;
    dbb_helper_ext tr_helper;
    int datasize = tr.get_data_length();
    byte unsigned p [];

    `CAST_DBB_EXT(,tr,ctrl)
    //`CAST_DBB_EXT(,tr,mon)
    `CAST_DBB_EXT(,tr,helper)

    // First make sure that we have at least one data entry
    if (datasize == 0) begin
        p = new[1];
        tr.set_data(p);
        tr.set_data_length(1);
        tr.set_streaming_width(1);
        p = new[1];
        tr.set_byte_enable(p);
        tr.set_byte_enable_length(1);
        datasize = 1;
    end
    else if (datasize > MEM_DATA_WIDTH || datasize < 0) begin
        `uvm_warning("NVDLA/DBB/SLV/DRV/CHECK_TXN_ARRAY", $psprintf("datasize is %d, changing to %d", datasize, MEM_DATA_WIDTH))
        datasize = MEM_DATA_WIDTH;
    end
    
    // First pad any arrays that are not as big as the data array.
    if (tr_ctrl.resp.size()                < datasize) tr_ctrl.resp                = new[datasize] (tr_ctrl.resp);
    tr.get_byte_enable(p);
    p = new [datasize] (p);
    if (tr.get_byte_enable_length()        < datasize) tr.set_byte_enable(p);
    if (tr_helper.status_err.size()        < datasize) tr_helper.status_err          = new[datasize] (tr_helper.status_err);
    if (tr_ctrl.wready_delay.size()        < datasize) tr_ctrl.wready_delay        = new[datasize] (tr_ctrl.wready_delay);
    if (tr_ctrl.wvalid_wready_delay.size() < datasize) tr_ctrl.wvalid_wready_delay = new[datasize] (tr_ctrl.wvalid_wready_delay);
    if (tr_ctrl.next_rvalid_delay.size()   < datasize) tr_ctrl.next_rvalid_delay   = new[datasize] (tr_ctrl.next_rvalid_delay);

    // Now complain if something was sized larger than the data array.
    if ((tr_ctrl.resp.size() > datasize) ||
        (tr.get_byte_enable_length() > datasize) ||
        (tr_helper.status_err.size() > datasize) ||
        (tr_ctrl.wready_delay.size() > datasize) ||
        (tr_ctrl.wvalid_wready_delay.size() > datasize) ||
        (tr_ctrl.next_rvalid_delay.size() > datasize)) begin
        `uvm_warning("NVDLA/DBB/SLV/DRV/ARRAY_SIZE_MSMTCH",
                     $psprintf("A dynamic array size in the transaction object which was bigger than the data array size was detected. This is not recommended. datasize:%d resp:%d wstrb:%d status_err:%d wready_delay:%d wvalid_wready_delay:%d, next_rvalid_delay:%d", datasize, tr_ctrl.resp.size(), tr.get_byte_enable_length(), tr_helper.status_err.size(), tr_ctrl.wready_delay.size(), tr_ctrl.wvalid_wready_delay.size(), tr_ctrl.next_rvalid_delay.size()))
    end
        
endfunction: check_txn_arrays
    
//////////////////////////////////////////////////////////////////////
/// All transactions which are starting call this routine.
task dbb_slave_driver::transaction_started(uvm_tlm_gp tr);
    int addrcnt=0;
    dbb_ctrl_ext tr_ctrl;

    `CAST_DBB_EXT(,tr,ctrl)

    // Increment active transaction counts
    outstanding_txns++;
    total_txns++;

`ifdef DRIVER_CALLBACKS
    `uvm_do_callbacks(dbb_slave_driver#(MEM_DATA_WIDTH),dbb_slave_driver_callbacks,
                      pre_trans(this, tr));
`endif

    // Indicate that the transaction is starting
    tr_ctrl.TXN_STARTED.trigger();
    begin_tr(tr);

    // Indicate when going from idle to active
    if (outstanding_txns == 1)
      EXECUTING.trigger(tr);

    `uvm_info("NVDLA/DBB/SLV/DRV/TXN_TRACE",
              $psprintf("Starting transaction 'h%08x.",tr.get_address),UVM_FULL);
    `uvm_info("NVDLA/DBB/SLV/DRV/TXN_TRACE",{"\n",tr.sprint()},UVM_DEBUG);

endtask: transaction_started
   
//////////////////////////////////////////////////////////////////////
/// All transactions which are finishing call this routine.
task dbb_slave_driver::transaction_finished(uvm_tlm_gp tr);
    dbb_ctrl_ext tr_ctrl;

    `CAST_DBB_EXT(,tr,ctrl)

    outstanding_txns--;

    // Indicate if going from active to idle
    if (outstanding_txns == 0)
      EXECUTING.reset();
    
    // Indicate that the transaction is finished
    tr_ctrl.TXN_ENDED.trigger();
    end_tr(tr);

`ifdef DRIVER_CALLBACKS
    `uvm_do_callbacks(dbb_slave_driver#(MEM_DATA_WIDTH),dbb_slave_driver_callbacks,
                      post_trans(this, tr));
`endif

    // Remove from active transaction queue
    active_txn_q.delete(tr);

    `uvm_info("NVDLA/DBB/SLV/DRV/TXN_TRACE",
              $psprintf("Completed transaction 'h%08x.",tr.get_address),UVM_FULL);
    `uvm_info("NVDLA/DBB/SLV/DRV/TXN_TRACE",{"\n",tr.sprint()},UVM_DEBUG);

endtask: transaction_finished

   
`endif
