`ifndef _CC_MONITOR_SV_
`define _CC_MONITOR_SV_

typedef class cc_monitor;
typedef class cc_txn; 

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                  class cc_monitor_callbacks
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

/// Callback class for the cc_monitor.
class cc_monitor_callbacks extends uvm_callback;

    /// nv_HINT :: Called before a transaction is executed
    virtual task pre_trans(cc_monitor xactor, cc_txn#() tr);
    endtask: pre_trans
    
    /// nv_HINT :: Called after a transaction has been executed
    virtual task post_trans(cc_monitor xactor, cc_txn#() tr);
    endtask: post_trans

    function new(string name = "cc_monitor_callbacks");
        super.new(name);
    endfunction:new
    
endclass:cc_monitor_callbacks

typedef uvm_callbacks #(cc_monitor, cc_monitor_callbacks) cc_mon_cb;

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                  class cc_monitor
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

// Parameterized class, DW->Data Width; MW->Mask Width; 
class cc_monitor #(int DW = 1, int MW = 1) extends uvm_monitor;

    int cycle_count;           ///< Total cycle count.
    int outstanding_txns;      ///<Track how many txns are in flight at once
    int total_txns;            ///< Total number of observed transactions
   
    /// Observed cc bus
    virtual cc_interface#(DW,MW).Monitor mon_if;
   
    /// TLM Analysis port for completed observed transactions.
    uvm_analysis_port #(cc_txn#(DW,MW)) mon_analysis_port;  //TLM analysis port
    
    //---------------------------- CONFIGURATION PARAMETERS --------------------------------
    /// @name Configuration Parameters
    /// CC Monitor Configuration Parameters. These parameters can be controlled
    /// through the UVM configuration database.
    ///@{
    int is_cmac2cacc    = 0;
    int is_csc2cmac_dat = 0;
    int is_csc2cmac_wt  = 0;
    /// @}
    
    `uvm_component_param_utils_begin(cc_monitor#(DW,MW))
        /* nv_TODO */
        `uvm_field_int(is_cmac2cacc,    UVM_ALL_ON)
        `uvm_field_int(is_csc2cmac_dat, UVM_ALL_ON)
        `uvm_field_int(is_csc2cmac_wt,  UVM_ALL_ON)
    `uvm_component_utils_end

    /// Register UVM callback class
    `uvm_register_cb(cc_monitor,cc_monitor_callbacks)

    //////////////////////////////////////////////////////////////////////
    /// Creates new cc_monitor object.

    extern function new(string name = "cc_monitor", uvm_component parent);

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
    extern protected virtual function void read_control(cc_txn#(DW,MW) cur_trans);
    extern protected virtual function void reset_monitor();
    ///@}

    ///@name Queue to handle read/write response
    ///@{
    //cc_txn#(DW,MW) write_queue[$];
    ///@}

    ///@name Transactions handling
    ///@{
    extern function cc_txn#(DW,MW) create_new_transaction();
    extern task transaction_started(cc_txn#(DW,MW) tr);
    extern task transaction_finished(cc_txn#(DW,MW) tr);
    ///@}
   
endclass:cc_monitor

function cc_monitor::new(string name = "cc_monitor", uvm_component parent);
    super.new(name, parent);

    mon_analysis_port       = new ("mon_analysis_port", this);
   
endfunction

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM build phase.
function void cc_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
      
    uvm_config_int::get(this, "", "is_cmac2cacc",    is_cmac2cacc);
    uvm_config_int::get(this, "", "is_csc2cmac_dat", is_csc2cmac_dat);
    uvm_config_int::get(this, "", "is_csc2cmac_wt",  is_csc2cmac_wt);
endfunction

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM connect phase.
function void cc_monitor::connect_phase(uvm_phase phase);
    virtual cc_interface#(DW,MW) temp_if;
    super.connect_phase(phase);

    // Hook up the virtual interface here
    if (!uvm_config_db#(virtual cc_interface#(DW,MW))::get(this, "", "mon_if", temp_if)) begin
        if (!uvm_config_db#(virtual cc_interface#(DW,MW).Monitor)::get(this, "", "mon_if", mon_if)) begin
            `uvm_fatal("CC/MON/NO_VIF", "No virtual interface specified for this monitor instance")
        end
    end
    else begin
        mon_if = temp_if;
    end
   
endfunction

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM end of elaboration phase.
function void cc_monitor::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

endfunction

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM start of simulation phase.
function void cc_monitor::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);

endfunction
 
//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM extract phase.
function void cc_monitor::extract_phase(uvm_phase phase);
    super.extract_phase(phase);

endfunction
 
//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM check phase.
function void cc_monitor::check_phase(uvm_phase phase);
    super.check_phase(phase);

endfunction
 
//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM report phase.
function void cc_monitor::report_phase(uvm_phase phase);
    super.report_phase(phase);

endfunction
 
//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM final phase.
function void cc_monitor::final_phase(uvm_phase phase);
    super.final_phase(phase);

endfunction
 
//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM reset phase.
task cc_monitor::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    phase.raise_objection(this,"");
    /* nv_TODO */ // Reset any state information
    phase.drop_objection(this);
endtask

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM configure phase.
task cc_monitor::configure_phase(uvm_phase phase);
    super.configure_phase(phase);
endtask

//////////////////////////////////////////////////////////////////////
/// Automatically runs during the UVM run phase.
task cc_monitor::run_phase(uvm_phase phase);
    cc_txn#(DW,MW) cur_trans;
  
    super.run_phase(phase);

    fork
    forever begin : forever_control_loop
        @(mon_if.monclk);

        cycle_count++;

        // check reset
        if(mon_if.resetn !== 1) begin
            `uvm_info("CC/MON/RESET","Detected RESET.",UVM_MEDIUM);
            if (cur_trans != null) begin
                `uvm_info("CC/MON/RESET_KILL",
                            $psprintf("Transaction killed due to reset"),UVM_FULL);
                transaction_finished(cur_trans);
                cur_trans = null;
            end
            reset_monitor();
            @(posedge mon_if.resetn);;  // Wait here if in reset
            @(mon_if.monclk);           // Sync back up with bus clock
        end
    end : forever_control_loop

    forever begin : forever_write_loop
        @(mon_if.monclk);
        if(mon_if.monclk.pvld) begin
            cur_trans = create_new_transaction();
            read_control(cur_trans);
            transaction_started(cur_trans);
            cur_trans.c_start = cycle_count;
            cur_trans.t_start = $time;
            transaction_finished(cur_trans);
        end
    end : forever_write_loop

    join

endtask

//////////////////////////////////////////////////////////////////////
//
//                    INTERFACE ACCESS FUNCTIONS
//
//////////////////////////////////////////////////////////////////////        
/// Capture interface signals
function void cc_monitor::read_control(cc_txn#(DW,MW) cur_trans);
    // Do "X" & "Z" value check firstly
    if(is_cmac2cacc || is_csc2cmac_dat) assert(!$isunknown(mon_if.monclk.pd));
    if(is_csc2cmac_wt)                  assert(!$isunknown(mon_if.monclk.wt_sel));
    if(is_cmac2cacc)                    assert(!$isunknown(mon_if.monclk.mode));

    cur_trans.batch_index = mon_if.monclk.pd[4:0];
    cur_trans.stripe_st   = mon_if.monclk.pd[5];
    cur_trans.stripe_end  = mon_if.monclk.pd[6];
    cur_trans.channel_end = mon_if.monclk.pd[7];
    cur_trans.layer_end   = mon_if.monclk.pd[8];
    cur_trans.mask        = mon_if.monclk.mask;
    cur_trans.wt_sel      = mon_if.monclk.wt_sel;
    if(is_cmac2cacc == 1) begin
        cur_trans.conv_mode      = mon_if.monclk.conv_mode;
        cur_trans.proc_precision = mon_if.monclk.proc_precision;
        cur_trans.mode           = mon_if.monclk.mode;
    end
    for (int i=0; i<MW; i++) begin
        cur_trans.data[i] = mon_if.monclk.data[i] & {DW{mon_if.monclk.mask[i]}};
    end
endfunction

function void cc_monitor::reset_monitor();
    //write_queue.delete();
endfunction

//////////////////////////////////////////////////////////////////////
//
//                    TRANSACTION HANDLING
//
//////////////////////////////////////////////////////////////////////        
/// Create a new transaction using UVM factory methods.
function cc_txn#(cc_monitor::DW,cc_monitor::MW) cc_monitor::create_new_transaction();
    cc_txn#(DW,MW) tr;
    
    tr = cc_txn#(DW,MW)::type_id::create("cc_mon_txn",this);
    return (tr);
endfunction

//////////////////////////////////////////////////////////////////////
/// All transactions which are starting call this routine.
task cc_monitor::transaction_started(cc_txn#(DW,MW) tr);

    // Update transaction counts
    outstanding_txns++;
    total_txns++;

    //uvm doesn't support parameterized callbacks
    //`uvm_do_callbacks(cc_monitor,cc_monitor_callbacks#(DW,MW),
                         //pre_trans(this, tr));

    accept_tr(tr);
    begin_tr(tr);

    `uvm_info("TXN_TRACE","Starting transaction...",UVM_FULL);
    `uvm_info("TXN_TRACE",tr.sprint(),UVM_FULL);

endtask
   
//////////////////////////////////////////////////////////////////////
/// All transactions which are finishing call this routine.
task cc_monitor::transaction_finished(cc_txn#(DW,MW) tr);

    `uvm_info("TXN_TRACE","Completed transaction...",UVM_FULL);
    `uvm_info("TXN_TRACE",tr.sprint(),UVM_FULL);

    // Update transaction count
    outstanding_txns--;

    end_tr(tr);

    //`uvm_do_callbacks(cc_monitor#(DW,MW),cc_monitor_callbacks#(DW,MW),post_trans(this, tr));

    // Always write to analysis port
    mon_analysis_port.write(tr);

endtask
    
`endif // _CC_MONITOR_SV_
