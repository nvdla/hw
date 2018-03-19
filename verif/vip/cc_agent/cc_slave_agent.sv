`ifndef _CC_SLAVE_AGENT_SV_
`define _CC_SLAVE_AGENT_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: cc_slave_agent
//
//-------------------------------------------------------------------------------------

class cc_slave_agent#(int DW = 1, int MW = 1) extends uvm_agent;

    // Only monitor, no driver/sequencer defined here
    cc_monitor#(DW,MW)          slv_mon; ///< cc slave Monitor

    virtual cc_interface#(DW,MW)       slv_if;///< cc Virtual interface.

    `uvm_component_param_utils(cc_slave_agent#(DW,MW))

    ////////////////////////////////////////////////////////////////////////////////
    /// Create a new cc __an_ agent.
    function new(string name = "cc_slave_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    ////////////////////////////////////////////////////////////////////////////////
    /// This function is run automatically during the UVM build phase. It will check
    /// for the existance of a virtual interface, and report an error if one has not
    /// been specified.
    ///
    /// If the agent is not set to UVM_ACTIVE, then only the monitor will be created,
    /// and it will function in a purely passive mode.
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Check to make sure we have an virtual interface specified for the agent.
        if (!uvm_config_db#(virtual cc_interface#(DW,MW))::get(this, "", "slv_if", slv_if)) begin
            `uvm_fatal("cc/NOVIF", "No virtual interface specified for this agent instance")
        end
        else begin
            // Configure driver and monitor to use the agent interface
            uvm_config_db#(virtual cc_interface#(DW,MW))::set(this,"slv_mon","mon_if",slv_if);
        end
        
        // Create monitor, sequencer and driver
        slv_mon = cc_monitor#(DW,MW)::type_id::create("slv_mon", this);
        
        if (is_active == UVM_ACTIVE) begin
            // Instance sequencer/driver here
        end

    endfunction: build_phase
       
    ////////////////////////////////////////////////////////////////////////////////
    /// This function is run automatically during the UVM connect phase. It will
    /// automatically connect the sequencer export to the driver port.
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (is_active == UVM_ACTIVE) begin
            //slv_drv.seq_item_port.connect(slv_sqr.seq_item_export);
        end
    endfunction

    ////////////////////////////////////////////////////////////////////////////////
    /// This task is run automatically during the UVM run phase.
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask

    ////////////////////////////////////////////////////////////////////////////////
    /// This function is run automatically during the UVM report phase.
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
    endfunction

endclass: cc_slave_agent

`endif // _CC_SLAVE_AGENT_SV_
