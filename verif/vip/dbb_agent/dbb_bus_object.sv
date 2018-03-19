`ifndef NVDLA_DBB_BUS_OBJECT__SV
`define NVDLA_DBB_BUS_OBJECT__SV

typedef class nvdla_bus_manager_logger;

//////////////////////////////////////////////////////////////////////////////////////////
/// Class to launch and track start and end times.
class nvdla_bus_manager_timer;
    longint   t_start;         ///< Desired start time
    longint   t_end;           ///< Desired end time
    uvm_event reached_t_start; ///< Event to track start time
    uvm_event reached_t_end;   ///< Event to track end time

    //////////////////////////////////////////////////////////////////////////////////////////
    /// Create a new nvdla_bus_manager_timer object. Initializes start/end time events.
    function new ();
        reached_t_start = new();
        reached_t_end = new();
    endfunction: new

    function start_timers (longint starttime=0, longint endtime=0);
        t_start = starttime;
        t_end   = endtime;
        fork
            begin
                if(t_start>0)
              #t_start;
              reached_t_start.trigger();
            end
            begin
                // If t_end = 0 it means the end of simulation, so we'll never trigger this event.
                if(t_end>0) begin
                #t_end;
                reached_t_end.trigger();
                end
            end
        join_none
    endfunction: start_timers

endclass: nvdla_bus_manager_timer

`ifdef CALLBACKS
/// Callback to dump DBB transactions for nvdla_bus_manager class.
class dbb_dump_cb extends dbb_monitor_callbacks;
    string    iname;                     ///< DBB Bus Name for Logger
    string    bus_type;                  ///< Bus Type for Logger
    longint   start_time;                ///< Desired start log time
    longint   end_time;                  ///< Desired end log time
    nvdla_bus_manager_logger dbb_logger; ///< Pointer to Bus Manager Logger

    `uvm_object_utils(dbb_dump_cb);

    function new (string name = "dbb_dump_cb");
      super.new();
    endfunction: new
    
    //////////////////////////////////////////////////////////////////////////////////////////
    /// Called at end of observed transaction
    virtual function void post_wr_trans(dbb_monitor xactor,
                                       uvm_tlm_gp tr);
        dumpit(tr);

    endfunction: post_wr_trans

    /// Called at end of observed transaction
    virtual function void post_rd_trans(dbb_monitor xactor,
                                        uvm_tlm_gp tr);
        dumpit(tr);

    endfunction: post_rd_trans

    //////////////////////////////////////////////////////////////////////////////////////////
    /// Call to dump transaction to the bus manager logging object
    function void dumpit(uvm_tlm_gp tr);
        dbb_bus_ext tr_bus;
        dbb_mon_ext tr_mon;
        string xfer_kind;
        string xfer_type;
        longint curtime = $time;

        `CAST_DBB_EXT(,tr,bus)
        `CAST_DBB_EXT(,tr,mon)
        //Here we should get the bus_manager logger handle and simply call its print function
        if (((start_time == 0) || (curtime >= start_time)) &&
            ((end_time   == 0) || (curtime <= end_time))) begin
            xfer_kind = tr.is_read()?"R":"W";
            dbb_logger.log_bus(iname, bus_type, tr_mon.t_start, tr_mon.t_end, tr.get_address(), xfer_kind,
                               tr_bus.get_size(), tr_bus.get_length(), xfer_type);
        end
    endfunction: dumpit

 endclass: dbb_dump_cb
`endif

//////////////////////////////////////////////////////////////////////////////////////////
//                                 DBB Bus Object
//////////////////////////////////////////////////////////////////////////////////////////

/// DBB nvdla_bus_object extension for nvdla_bus_manager class.
class dbb_bus_object extends uvm_object;

   string        bus_tag;               ///< Contains the string 'name' for the specific bus.
                                         ///< This bus_tag determines what the plusargs look like to control
                                         ///< runtime behaviors. This bus_tag should not contain spaces.
    int           master;                ///< If master=1, the agent is a master. If master=0, agent is a slave;
    int           num_bg_seq;            ///< This is the number of bg sequences created
    string        bus_type;              ///< Type of bus (ex. AXI, APB, AHB, etc.)
    dbb_slave_agent   agent;                 ///< Pointer to the NVDLA agent for the bus object.
    dbb_monitor monitor;               ///< Pointer to the monitor of the bus registered with bus manager
    int           active ;               ///< Flag to determine if agent passed at the time of creation was active or passive
    nvdla_bus_manager_logger bus_logger; ///< Pointer to NVDLA bus logger used by the concise unified txn dumping. This will
                                         ///< be set for you by the NVDLA bus manager.

    `uvm_object_utils_begin(dbb_bus_object)
    `uvm_object_utils_end     

    dbb_monitor       dbb_monitor;      ///< Pointer to DBB Monitor
    
`ifdef CALLBACKS
    dbb_dump_cb       dump_cb;          ///< DBB Dump Callback
`endif

    int seq_index;                            ///< Counter for number of background traffic seqs

    //////////////////////////////////////////////////////////////////////////////////////////
    /// Creates a new DBB bus object
    function new(string name = "dbb_bus_object",
                  dbb_slave_agent agent = null);
        
        super.new(name);
                
    endfunction: new

    //////////////////////////////////////////////////////////////////////////////////////////
    /// Initializes the bus object with the given name and agent pointer.
    virtual function void set_agent(string bus_name, dbb_slave_agent agent);
        dbb_slave_agent  dbb_slave;
      
        bus_tag    = bus_name;
        this.agent = agent;

        if ($cast(dbb_slave, agent) && (dbb_slave != null)) begin
            dbb_monitor = dbb_slave.slv_mon;
            master = 0;
        end
        else begin
            `uvm_error("NVDLA/DBB/BO/NO AGENT","Illegal Agent specified for dbb bus object.");
        end
        bus_type = "DBB";
        monitor  = dbb_monitor;
    endfunction: set_agent
    
    //////////////////////////////////////////////////////////////////////////////////////////
    /// Function to enable text dumping. Creates the required callback to do the dumping, and
    /// registers it with the DBB agent monitor. Can take an optional start and end time.
    virtual function void enable_dumping(longint t_start=0, t_end=0);
        `uvm_info("NVDLA/DBB/BO/TRACE",$psprintf("Dumping enabled for %s. start: %0d, end: %0d",
                                                 bus_tag,t_start,t_end),UVM_HIGH);
`ifdef CALLBACKS
        dump_cb            = dbb_dump_cb::type_id::create("dump_cb",,get_full_name());
        // Initialize Callback variables
        dump_cb.iname      = bus_tag;
        dump_cb.bus_type   = bus_type;
        dump_cb.start_time = t_start;
        dump_cb.end_time   = t_end;
        dump_cb.dbb_logger = bus_logger;
        // Register Callback
        dbb_mon_cb::add_by_name(dbb_monitor.get_full_name(),dump_cb,uvm_top);
`endif
    endfunction: enable_dumping

    //////////////////////////////////////////////////////////////////////////////////////////
    /// Function to enable waveform recording.
    virtual function void enable_waveform_recording(longint t_start=0, t_end=0);
        nvdla_bus_manager_timer wavrec_timer;
        `uvm_info("NVDLA/DBB/BO/TRACE",$psprintf("Txn recording enabled for %s. start: %0d, end: %0d",
                                                 bus_tag,t_start,t_end),UVM_HIGH);

        if (dbb_monitor == null) return;
        if ((t_start == 0) && (t_end == 0)) begin
            // If we don't have a time range, just turn it on
            dbb_monitor.recording_detail = UVM_FULL;
        end
        else begin
            // If we have a time range, use a timer
            wavrec_timer = new();
            wavrec_timer.start_timers(t_start, t_end);
            fork
                begin // Wait for start time then turn on
                    wavrec_timer.reached_t_start.wait_on();
                    dbb_monitor.recording_detail = UVM_FULL;
                end
                begin // Wait for end time then turn off
                    if (t_end != 0) begin
                        wavrec_timer.reached_t_end.wait_on();
                        dbb_monitor.recording_detail = UVM_HIGH;
                    end
                end
            join_none
        end

    endfunction: enable_waveform_recording

    ////////////////////////////////////////////////////////////////////////////////
    /// Virtual function to enable coverage on a bus.
    virtual function void enable_coverage(longint t_start=0, t_end=0);
    endfunction: enable_coverage

    ////////////////////////////////////////////////////////////////////////////////
    /// Virtual function to allow users to add their own custom capabilities to nvdla_bus_manager
    virtual function void enable_user(longint t_start=0, t_end=0);
    endfunction: enable_user

    ////////////////////////////////////////////////////////////////////////////////
    /// Virtual function to enable Detailed logging
    virtual function void enable_txn_log(longint t_start=0, t_end=0);
        nvdla_bus_manager_timer txnlog_timer;
        `uvm_info("NVDLA/BO/TRACE",{"Txn Logging enabled for ",bus_tag},UVM_HIGH);
        `uvm_info("NVDLA/BO/TRACE",$psprintf("start: %0d, end: %0d",t_start,t_end),UVM_HIGH);

        if (monitor == null) return;
        if ((t_start == 0) && (t_end == 0)) begin
            // If we don't have a time range, just turn it on
            monitor.enable_logging = 1;
        end
        else begin
            //If the logging is already turned on, we need to stop it
            //and turn it back on when t_start happens
            if(monitor.enable_logging) monitor.enable_logging=0;
            // If we have a time range, use a timer
            txnlog_timer = new();
            txnlog_timer.start_timers(t_start, t_end);
            fork
                begin // Wait for start time then turn on
                    txnlog_timer.reached_t_start.wait_on();
                    monitor.enable_logging = 1;
                end
                begin // Wait for end time then turn off
                    if (t_end != 0) begin
                        txnlog_timer.reached_t_end.wait_on();
                        monitor.enable_logging = 0;
                    end
                end
            join_none
        end

    endfunction: enable_txn_log

endclass: dbb_bus_object
   
`endif

