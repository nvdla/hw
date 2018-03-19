`ifndef _DMA_MONITOR_SV_
`define _DMA_MONITOR_SV_

typedef class dma_monitor;
typedef class dma_txn; 

//-------------------------------------------------------------------------------------
//
// CLASS: dma_monitor_callbacks
//
// Callback class for the dma_monitor.
//-------------------------------------------------------------------------------------

class dma_monitor_callbacks extends uvm_callback;

    // Called before a transaction is executed
    virtual task pre_trans(dma_monitor xactor, dma_txn tr);
    endtask: pre_trans
    
    // Called after a transaction has been executed
    virtual task post_trans(dma_monitor xactor, dma_txn tr);
    endtask: post_trans

    function new(string name = "dma_monitor_callbacks");
        super.new(name);
    endfunction:new
    
endclass: dma_monitor_callbacks

typedef uvm_callbacks #(dma_monitor, dma_monitor_callbacks) dma_mon_cb;

//-------------------------------------------------------------------------------------
//
// CLASS: dma_monitor
//
//-------------------------------------------------------------------------------------
class dma_monitor extends uvm_monitor;

    int cycle_count;           // Total cycle count.
    int outstanding_txns;      // Track how many txns are in flight at once
    int total_txns;            // Total number of observed transactions
   
    // Observed dma bus
    virtual dma_interface.Monitor mon_if;
   
    // TLM Analysis port for completed observed transactions.
    uvm_analysis_port #(dma_txn) mon_analysis_port;  //TLM analysis port

    // TLM Analysis port for DMA write&read request, used by C-model
    uvm_analysis_port #(dma_txn) mon_analysis_port_req;

    
    //---------------------------- CONFIGURATION PARAMETERS --------------------------------
    /// @name Configuration Parameters
    /// DMA Monitor Configuration Parameters. These parameters can be controlled
    /// through the UVM configuration database.
    ///@{

    int is_wt_dma = 0;

    /// @}
    
    `uvm_component_utils_begin(dma_monitor)
        `uvm_field_int(is_wt_dma, UVM_ALL_ON)
    `uvm_component_utils_end

    /// Register UVM callback class
    `uvm_register_cb(dma_monitor,dma_monitor_callbacks)

    extern function new(string name = "dma_monitor", uvm_component parent);

    ///@name UVM Phases
    ///@{

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern function void start_of_simulation_phase(uvm_phase phase);
     
    //extern task reset_phase(uvm_phase phase);
    //extern task configure_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);

    //extern function void extract_phase(uvm_phase phase);
    //extern function void check_phase(uvm_phase phase);
    //extern function void report_phase(uvm_phase phase);
    //extern function void final_phase(uvm_phase phase);
    ///@}

    ///@name Interface access functions
    ///@{
    extern protected virtual function void reset_monitor();
    ///@}

    ///@name Queue to handle read/write response
    ///@{
    dma_txn read_queue[$];
    dma_txn write_queue[$];
    ///@}

    ///@name Transactions handling
    ///@{
    extern function dma_txn create_new_transaction();
    extern task transaction_started(dma_txn tr);
    extern task transaction_finished(dma_txn tr);
    ///@}
   
endclass: dma_monitor

function dma_monitor::new(string name = "dma_monitor", uvm_component parent);
    super.new(name, parent);

    mon_analysis_port       = new ("mon_analysis_port", this);
    mon_analysis_port_req   = new("mon_analysis_port_req", this);
   
endfunction

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM build phase.
function void dma_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
      
    uvm_config_int::get(this, "", "is_wt_dma", is_wt_dma);
endfunction

//////////////////////////////////////////////////////////////////////
/// Called automatically during UVM connect phase.
function void dma_monitor::connect_phase(uvm_phase phase);
    virtual dma_interface temp_if;
    super.connect_phase(phase);

    // Hook up the virtual interface here
    if (!uvm_config_db#(virtual dma_interface)::get(this, "", "mon_if", temp_if)) begin
        if (!uvm_config_db#(virtual dma_interface.Monitor)::get(this, "", "mon_if", mon_if)) begin
            `uvm_fatal("DMA/MON/NO_VIF", "No virtual interface specified for this monitor instance")
        end
    end
    else begin
        mon_if = temp_if;
    end
   
endfunction

// Called automatically during UVM end of elaboration phase.
function void dma_monitor::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

endfunction

// Called automatically during UVM start of simulation phase.
function void dma_monitor::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);

endfunction
 
// Automatically runs during the UVM main_phase.
task dma_monitor::main_phase(uvm_phase phase);
    dma_txn cur_rd_trans;
    dma_txn cur_wr_trans;
    int     wr_txn_index = 0;
  
    super.main_phase(phase);

    fork
    forever begin : forever_control_loop
        @(mon_if.monclk);

        cycle_count++;

        // check reset
        if(mon_if.resetn !== 1) begin
            `uvm_info("DMA/MON/RESET","Detected RESET.",UVM_MEDIUM);
            if (cur_rd_trans != null) begin
                `uvm_info("DMA/MON/RESET_KILL",
                            $psprintf("Transaction killed due to reset: 0x%0x",cur_rd_trans.addr),UVM_FULL);
                transaction_finished(cur_rd_trans);
                cur_rd_trans = null;
            end
            if (cur_wr_trans != null) begin
                `uvm_info("DMA/MON/RESET_KILL",
                            $psprintf("Transaction killed due to reset: 0x%0x",cur_wr_trans.addr),UVM_FULL);
                transaction_finished(cur_wr_trans);
                cur_wr_trans = null;
            end
            reset_monitor();
            @(posedge mon_if.resetn);;  // Wait here if in reset
            @(mon_if.monclk);           // Sync back up with bus clock
        end
    end : forever_control_loop

    forever begin : forever_read_req_loop
        @(mon_if.monclk);
        if(mon_if.monclk.rd_req_valid && mon_if.monclk.rd_req_ready) begin
            dma_txn rd_trans_temp;
            cur_rd_trans = create_new_transaction();
            // Capture interface signal 
            cur_rd_trans.kind          = dma_txn::READ;  
            cur_rd_trans.addr          = mon_if.monclk.rd_req_pd[`DMA_ADDR_WIDTH-1:0];
            cur_rd_trans.length        = mon_if.monclk.rd_req_pd[`DMA_ADDR_WIDTH+`DMA_RD_SIZE_WIDTH-1:`DMA_ADDR_WIDTH];
            cur_rd_trans.data          = new[cur_rd_trans.length+1];
            if(is_wt_dma == 1) begin
                cur_rd_trans.wt_dma_id     = mon_if.monclk.wt_dma_id;
            end
            else begin
                cur_rd_trans.wt_dma_id     = -1;
            end

            transaction_started(cur_rd_trans);
            cur_rd_trans.c_start = cycle_count;
            cur_rd_trans.t_start = $time;
            $cast(rd_trans_temp, cur_rd_trans.clone());
            read_queue.push_back(rd_trans_temp);
            
            mon_analysis_port_req.write(rd_trans_temp); // 
            `uvm_info("DMA/MON/RDREQ", $sformatf("Broadcast DMA read request txns:\n%0s", rd_trans_temp.sprint()), UVM_HIGH)
        end
    end : forever_read_req_loop

    forever begin : forever_read_rsp_loop
        @(mon_if.monclk);
        if(read_queue.size() != 0) begin
            dma_txn                        tr;
            int                            txn_index;
            bit [`DMA_DATA_MASK_WIDTH-1:0] mask;

            txn_index = 0;
            tr        = read_queue.pop_front();
            while(txn_index < (tr.length+1)) begin  // capture read resp data
                if(mon_if.monclk.rd_rsp_valid && mon_if.monclk.rd_rsp_ready) begin
                    `uvm_info("DMA/MON/READ_RSP", "Got read response", UVM_HIGH )
                    mask = mon_if.monclk.rd_rsp_pd[`DMA_RD_RSP_PD_WIDTH-1:`DMA_RD_RSP_PD_WIDTH-`DMA_DATA_MASK_WIDTH];
                    if(mask == 'b1) begin
                        tr.data[txn_index] = mon_if.monclk.rd_rsp_pd[`DMA_DATA_WIDTH-1:0];
                        tr.mask[txn_index] = 1;
                        txn_index++;
                    end
                    else if(mask == 'b11) begin
                        tr.data[txn_index]   = mon_if.monclk.rd_rsp_pd[`DMA_DATA_WIDTH-1:0];
                        tr.data[txn_index+1] = mon_if.monclk.rd_rsp_pd[2*`DMA_DATA_WIDTH-1:`DMA_DATA_WIDTH];
                        tr.mask[txn_index]   = 1;
                        tr.mask[txn_index+1] = 1;
                        txn_index            = txn_index+2;
                    end
                    else begin
                        `uvm_fatal("DMA/MON/MASK_ERR", $sformatf("Read response error with invalid mask:%0d", mask))
                    end
                end
                if(txn_index < (tr.length+1)) @(mon_if.monclk);
            end // while
            if(txn_index != (tr.length+1)) begin 
                `uvm_error("DMA/MON/SIZE_ERR", $sformatf("TXN data size:%0d, Received data size:%0d", tr.length+1, txn_index))
            end
            tr.c_end = cycle_count;
            tr.t_end = $time;
            transaction_finished(tr);
        end
    end : forever_read_rsp_loop

    forever begin : forever_write_req_loop
        @(mon_if.monclk);
        if(mon_if.monclk.wr_req_valid && mon_if.monclk.wr_req_ready) begin
            // Capture interface signal
            if(!mon_if.monclk.wr_req_pd[`DMA_WR_REQ_PD_WIDTH-1]) begin   // A new write txn, capture write command
                cur_wr_trans               = create_new_transaction();
                cur_wr_trans.kind          = dma_txn::WRITE;
                cur_wr_trans.addr          = mon_if.monclk.wr_req_pd[`DMA_ADDR_WIDTH-1:0];
                cur_wr_trans.length        = mon_if.monclk.wr_req_pd[`DMA_ADDR_WIDTH+`DMA_WR_SIZE_WIDTH-1:`DMA_ADDR_WIDTH];
                cur_wr_trans.require_ack   = mon_if.monclk.wr_req_pd[`DMA_ADDR_WIDTH+`DMA_WR_SIZE_WIDTH];
                cur_wr_trans.data          = new[cur_wr_trans.length+1];
                cur_wr_trans.mask          = new[cur_wr_trans.length+1];

                transaction_started(cur_wr_trans);
                cur_wr_trans.c_start = cycle_count;
                cur_wr_trans.t_start = $time;
                wr_txn_index         = 0;
            end
            else begin   // Capture write data
                if(cur_wr_trans != null) begin // already send write request command
                    if(wr_txn_index < cur_wr_trans.length) begin
                        cur_wr_trans.data[wr_txn_index]   = mon_if.monclk.wr_req_pd[`DMA_DATA_WIDTH-1:0];
                        cur_wr_trans.mask[wr_txn_index]   = mon_if.monclk.wr_req_pd[`DMA_WR_REQ_PD_WIDTH-1-`DMA_DATA_MASK_WIDTH];
                        if(`DMA_DATA_MASK_WIDTH == 2) begin
                            cur_wr_trans.data[wr_txn_index+1] = mon_if.monclk.wr_req_pd[2*`DMA_DATA_WIDTH-1:`DMA_DATA_WIDTH];
                            cur_wr_trans.mask[wr_txn_index+1] = mon_if.monclk.wr_req_pd[`DMA_WR_REQ_PD_WIDTH-`DMA_DATA_MASK_WIDTH];
                        end
                        if(!$test$plusargs("dma_monitor_disable_checker")) begin
                            assert(mon_if.monclk.wr_req_pd[`DMA_WR_REQ_PD_WIDTH-1-1:`DMA_WR_REQ_PD_WIDTH-1-`DMA_DATA_MASK_WIDTH] == {`DMA_DATA_MASK_WIDTH{1'b1}}) else
                                `uvm_fatal("DMA/MON/WR_REQ", "DATA MASK bit should be all 'b1, please check")
                        end
                        wr_txn_index                      = wr_txn_index+`DMA_DATA_MASK_WIDTH;
                    end
                    else if(wr_txn_index == cur_wr_trans.length) begin
                        cur_wr_trans.data[wr_txn_index] = mon_if.monclk.wr_req_pd[`DMA_DATA_WIDTH-1:0];
                        cur_wr_trans.mask[wr_txn_index] = mon_if.monclk.wr_req_pd[`DMA_WR_REQ_PD_WIDTH-1-`DMA_DATA_MASK_WIDTH];
                        if(!$test$plusargs("dma_monitor_disable_checker")) begin
                            assert(mon_if.monclk.wr_req_pd[`DMA_WR_REQ_PD_WIDTH-1-1:`DMA_WR_REQ_PD_WIDTH-1-`DMA_DATA_MASK_WIDTH] == 'b1) else
                                `uvm_fatal("DMA/MON/WR_REQ", "DATA MASK bit should be 2'b01, please check")
                        end
                        wr_txn_index++;
                    end
                    if(wr_txn_index == (cur_wr_trans.length+1)) begin
                        // Finish write data capture
                        //if(!cur_wr_trans.require_ack) begin  // No ACK needed
                        //    dma_txn wr_trans_temp;
                        //    cur_wr_trans.c_end = cycle_count;
                        //    cur_wr_trans.t_end = $time;
                        //    $cast(wr_trans_temp, cur_wr_trans.clone());
                        //    mon_analysis_port_req.write(wr_trans_temp);
                        //    `uvm_info("DMA/MON/WR_REQ", $sformatf("Broadcast write request txns:\n%0s", wr_trans_temp.sprint()), UVM_HIGH)
                        //    transaction_finished(wr_trans_temp);
                        //end
                        //else begin  // ACK needed
                        // Always pushed into write queue for post-process
                        dma_txn wr_trans_temp;
                        $cast(wr_trans_temp, cur_wr_trans.clone());
                        write_queue.push_back(wr_trans_temp);
                        mon_analysis_port_req.write(wr_trans_temp);
                        `uvm_info("DMA/MON/WR_REQ", $sformatf("Broadcast write request txns:\n%0s", wr_trans_temp.sprint()), UVM_HIGH)
                        //end
                        cur_wr_trans = null;
                    end
                end
                else begin
                    `uvm_fatal("DMA/MON/WR_ERR", $sformatf("Write data comes without sending any command firstly"))
                end
            end
        end
    end : forever_write_req_loop

    forever begin : forever_write_rsp_loop
        //@(mon_if.monclk);
        //if(mon_if.monclk.wr_rsp_complete == 1) begin
        //    dma_txn tr;
        //    if(write_queue.size() != 0) begin
        //        tr = write_queue.pop_front();
        //        `uvm_info("DMA/MON/WR_FINISH", "Capture wr_rsp_complete", UVM_HIGH)
        //        tr.c_end = cycle_count;
        //        tr.t_end = $time;
        //        transaction_finished(tr);
        //    end
        //    else begin
        //        `uvm_error("DMA/MON/WRITE_ACK_ERROR","Found write ack without one write request");
        //    end
        //end
    
        @(mon_if.monclk);
        if(write_queue.size() != 0) begin
            dma_txn tr;
            tr = write_queue.pop_front();
            if(tr.require_ack == 0) begin // No ACK needed, issue complete txn immediately
                tr.c_end = cycle_count;
                tr.t_end = $time;
                transaction_finished(tr);
            end
            else begin  // ACK needed
                while(mon_if.monclk.wr_rsp_complete == 0) begin
                    @(mon_if.monclk);
                end
                `uvm_info("DMA/MON/WR_FINISH", "Capture wr_rsp_complete", UVM_HIGH)
                tr.c_end = cycle_count;
                tr.t_end = $time;
                transaction_finished(tr);
            end
        end

    end : forever_write_rsp_loop

    join

endtask

//////////////////////////////////////////////////////////////////////
//
//                    INTERFACE ACCESS FUNCTIONS
//
//////////////////////////////////////////////////////////////////////        
function void dma_monitor::reset_monitor();
    write_queue.delete();
    read_queue.delete();
endfunction

//////////////////////////////////////////////////////////////////////
//
//                    TRANSACTION HANDLING
//
//////////////////////////////////////////////////////////////////////        
/// Create a new transaction using UVM factory methods.
function dma_txn dma_monitor::create_new_transaction();
    dma_txn tr;
    
    tr = dma_txn::type_id::create("dma_mon_txn",this);
    return (tr);
endfunction

//////////////////////////////////////////////////////////////////////
/// All transactions which are starting call this routine.
task dma_monitor::transaction_started(dma_txn tr);

    // Update transaction counts
    outstanding_txns++;
    total_txns++;

    `uvm_do_callbacks(dma_monitor,dma_monitor_callbacks,
                         pre_trans(this, tr));

    // Indicate that the transaction is starting
    accept_tr(tr);
    begin_tr(tr);

    `uvm_info("TXN_TRACE","Starting transaction...",UVM_HIGH);
    `uvm_info("TXN_TRACE",tr.sprint(),UVM_FULL);

endtask
   
//////////////////////////////////////////////////////////////////////
/// All transactions which are finishing call this routine.
task dma_monitor::transaction_finished(dma_txn tr);

    `uvm_info("TXN_TRACE","Completed transaction...",UVM_HIGH);
    `uvm_info("TXN_TRACE",tr.sprint(),UVM_HIGH);

    // Update transaction count
    outstanding_txns--;

    // Indicate that the transaction is finished
    end_tr(tr);

    `uvm_do_callbacks(dma_monitor,dma_monitor_callbacks,post_trans(this, tr));

    // Always write to analysis port
    mon_analysis_port.write(tr);

endtask
    
`endif // _DMA_MONITOR_SV_
