`ifndef _DP_MONITOR_SV_
`define _DP_MONITOR_SV_

typedef class dp_monitor;
typedef class dp_txn; 

//-------------------------------------------------------------------------------------
//
// CLASS: dp_monitor_callbacks
//
//-------------------------------------------------------------------------------------

/// Callback class for the dp_monitor.
//class dp_monitor_callbacks extends uvm_callback;
//
//    /// nv_HINT :: Called before a transaction is executed
//    virtual task pre_trans(dp_monitor xactor, dp_txn#() tr);
//    endtask: pre_trans
//    
//    /// nv_HINT :: Called after a transaction has been executed
//    virtual task post_trans(dp_monitor xactor, dp_txn#() tr);
//    endtask: post_trans
//
//    function new(string name = "dp_monitor_callbacks");
//        super.new(name);
//    endfunction:new
//    
//endclass:dp_monitor_callbacks

//typedef uvm_callbacks #(dp_monitor#(), dp_monitor_callbacks) dp_mon_cb;

//-------------------------------------------------------------------------------------
//
// CLASS: dp_monitor
//
//-------------------------------------------------------------------------------------

/// Parameterized class, PW->Pad Data Width; DW->Data Width; DS->Data Size
class dp_monitor#(int PW = 1, int DW = 32, int DS = 16) extends uvm_monitor;

    int cycle_count;           ///< Total cycle count.
    int outstanding_txns;      ///<Track how many txns are in flight at once
    int total_txns;            ///< Total number of observed transactions
   
    /// Observed dp bus
    virtual dp_interface#(PW).Monitor mon_if;
   
    /// TLM Analysis port for completed observed transactions.
    uvm_analysis_port #(dp_txn#(DW, DS)) mon_analysis_port;  //TLM analysis port

    
    //---------------------------- CONFIGURATION PARAMETERS --------------------------------
    /// @name Configuration Parameters
    /// DP Monitor Configuration Parameters. These parameters can be controlled
    /// through the UVM configuration database.
    ///@{
    // int data_bus_width = `DP_DATA_WIDTH;
    /// @}
    
    `uvm_component_param_utils_begin(dp_monitor#(PW,DW,DS))
        /* nv_TODO */
    `uvm_component_utils_end

    /// Register UVM callback class
    //`uvm_register_cb(dp_monitor,dp_monitor_callbacks)

    //////////////////////////////////////////////////////////////////////
    /// Creates new dp_monitor object.

    extern function new(string name = "dp_monitor", uvm_component parent);

    ///@name UVM Phases
    ///@{

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern function void start_of_simulation_phase(uvm_phase phase);
     
    extern task reset_phase(uvm_phase phase);
    extern task configure_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    extern function void extract_phase(uvm_phase phase);
    extern function void check_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
    extern function void final_phase(uvm_phase phase);
    ///@}

    ///@name Interface access functions
    ///@{
    extern protected virtual function void read_control(dp_txn#(DW,DS) cur_trans);
    extern protected virtual function void reset_monitor();
    ///@}

    ///@name Queue to handle read/write response
    ///@{
    /// No Need
    ///@}

    ///@name Transactions handling
    ///@{
    extern function dp_txn#(DW,DS) create_new_transaction();
    extern task transaction_started(dp_txn#(DW,DS) tr);
    extern task transaction_finished(dp_txn#(DW,DS) tr);
    ///@}
   
endclass: dp_monitor

function dp_monitor::new(string name = "dp_monitor", uvm_component parent);
    super.new(name, parent);

    mon_analysis_port       = new ("mon_analysis_port", this);
   
endfunction

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM build phase.
function void dp_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
      
endfunction

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM connect phase.
function void dp_monitor::connect_phase(uvm_phase phase);
    virtual dp_interface#(PW) temp_if;
    super.connect_phase(phase);

    // Hook up the virtual interface here
    if (!uvm_config_db#(virtual dp_interface#(PW))::get(this, "", "mon_if", temp_if)) begin
        if (!uvm_config_db#(virtual dp_interface#(PW).Monitor)::get(this, "", "mon_if", mon_if)) begin
            `uvm_fatal("DP/MON/NO_VIF", "No virtual interface specified for this monitor instance")
        end
    end
    else begin
        mon_if = temp_if;
    end
   
endfunction

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM end of elaboration phase.
function void dp_monitor::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

endfunction

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM start of simulation phase.
function void dp_monitor::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);

endfunction
 
//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM extract phase.
function void dp_monitor::extract_phase(uvm_phase phase);
    super.extract_phase(phase);

endfunction
 
//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM check phase.
function void dp_monitor::check_phase(uvm_phase phase);
    super.check_phase(phase);

endfunction
 
//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM report phase.
function void dp_monitor::report_phase(uvm_phase phase);
    super.report_phase(phase);

endfunction
 
//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM final phase.
function void dp_monitor::final_phase(uvm_phase phase);
    super.final_phase(phase);

endfunction
 
//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM reset phase.
task dp_monitor::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    phase.raise_objection(this,"");
    /* nv_TODO */ // Reset any state information
    phase.drop_objection(this);
endtask

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM configure phase.
task dp_monitor::configure_phase(uvm_phase phase);
    super.configure_phase(phase);
endtask

//////////////////////////////////////////////////////////////////////
/// Automatically runs during the UVM run phase.
task dp_monitor::run_phase(uvm_phase phase);
    dp_txn#(DW,DS) cur_trans;
  
    super.run_phase(phase);

    fork
    forever begin : forever_control_loop
        @(mon_if.monclk);

        cycle_count++;

        // check reset
        if(mon_if.resetn !== 1) begin
            `uvm_info("DP/MON/RESET","Detected RESET.",UVM_MEDIUM);
            if (cur_trans != null) begin
                `uvm_info("DP/MON/RESET_KILL",
                            $psprintf("Transaction killed due to reset"), UVM_FULL);
                transaction_finished(cur_trans);
                cur_trans = null;
            end
            reset_monitor();
            @(posedge mon_if.resetn);;  // Wait here if in reset
            @(mon_if.monclk);           // Sync back up with bus clock
        end
    end : forever_control_loop

    forever begin : forever_data_capture_loop
        @(mon_if.monclk);
        if(mon_if.monclk.valid && mon_if.monclk.ready) begin
            cur_trans = create_new_transaction();
            read_control(cur_trans);
            transaction_started(cur_trans);
            cur_trans.c_start = cycle_count;
            cur_trans.t_start = $time;
            transaction_finished(cur_trans);
        end
    end : forever_data_capture_loop

    join

endtask

//////////////////////////////////////////////////////////////////////
//
//                    INTERFACE ACCESS FUNCTIONS
//
//////////////////////////////////////////////////////////////////////        
function void dp_monitor::read_control(dp_txn#(DW,DS) cur_trans);
    bit [PW-1:0] pad_data;
    bit [DW-1:0] accu_data[DS];
    bit [DW-1:0] sdp_data[DS];

    pad_data = mon_if.monclk.pd;
    if(PW % 8 == 0) begin // PW: 128(large)/8(small) SDP2PDP
        {<<DW{sdp_data}}   = pad_data;
        cur_trans.sdp_data = sdp_data;
    end
    else begin // PW: 514(large)/34(small) ACCU2SDP
        {cur_trans.layer_end,cur_trans.batch_end} = pad_data[PW-1:PW-2];
        {<<DW{accu_data}} = {DW*DS{1'b1}} & pad_data[PW-3:0];
        cur_trans.accu_data = accu_data;
    end
endfunction

function void dp_monitor::reset_monitor();
    // Nothing to do
endfunction

//////////////////////////////////////////////////////////////////////
//
//                    TRANSACTION HANDLING
//
//////////////////////////////////////////////////////////////////////        
/// Create a new transaction using UVM factory methods.
function dp_txn#(dp_monitor::DW,dp_monitor::DS) dp_monitor::create_new_transaction();
    dp_txn#(DW,DS) tr;
    
    tr = dp_txn#(DW,DS)::type_id::create("dp_mon_txn",this);
    return (tr);
endfunction

//////////////////////////////////////////////////////////////////////
/// All transactions which are starting call this routine.
task dp_monitor::transaction_started(dp_txn#(DW,DS) tr);

    // Update transaction counts
    outstanding_txns++;
    total_txns++;

    //`uvm_do_callbacks(dp_monitor,dp_monitor_callbacks,
                         //pre_trans(this, tr));

    accept_tr(tr);
    begin_tr(tr);

    `uvm_info("TXN_TRACE","Starting transaction...",UVM_FULL);
    `uvm_info("TXN_TRACE",tr.sprint(),UVM_FULL);

endtask
   
//////////////////////////////////////////////////////////////////////
/// All transactions which are finishing call this routine.
task dp_monitor::transaction_finished(dp_txn#(DW,DS) tr);

    `uvm_info("TXN_TRACE","Completed transaction...",UVM_FULL);
    `uvm_info("TXN_TRACE",tr.sprint(),UVM_FULL);

    // Update transaction count
    outstanding_txns--;

    // Indicate that the transaction is finished
    end_tr(tr);
    
    //`uvm_do_callbacks(dp_monitor,dp_monitor_callbacks,post_trans(this, tr));

    // Always write to analysis port
    mon_analysis_port.write(tr);

endtask
    
`endif // _DP_MONITOR_SV_
