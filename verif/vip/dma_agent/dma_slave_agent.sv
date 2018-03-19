`ifndef _DMA_SLAVE_AGENT_SV_
`define _DMA_SLAVE_AGENT_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: dma_slave_agent
//
//-------------------------------------------------------------------------------------

class dma_slave_agent extends uvm_agent;

    // Only monitor, no driver/sequencer defined here
    dma_monitor       slv_mon; 

    virtual dma_interface slv_if;

    `uvm_component_utils(dma_slave_agent)

    // Create a new dma agent.
    function new(string name = "dma_slave_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    // This function is run automatically during the UVM build phase. It will check
    // for the existance of a virtual interface, and report an error if one has not
    // been specified.
    //
    // If the agent is not set to UVM_ACTIVE, then only the monitor will be created,
    // and it will function in a purely passive mode.
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Check to make sure we have an virtual interface specified for the agent.
        if (!uvm_config_db#(virtual dma_interface)::get(this, "", "slv_if", slv_if)) begin
            `uvm_fatal("DMA/NOVIF", "No virtual interface specified for this agent instance")
        end
        else begin
            // Configure driver and monitor to use the agent interface
            uvm_config_db#(virtual dma_interface)::set(this,"slv_mon","mon_if",slv_if);
        end
        
        // Create monitor, sequencer and driver
        slv_mon = dma_monitor::type_id::create("slv_mon", this);
        
        if (is_active == UVM_ACTIVE) begin
            // Instance sequencer/driver here
        end

    endfunction: build_phase
       
    // This function is run automatically during the UVM connect phase. It will
    // automatically connect the sequencer export to the driver port.
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (is_active == UVM_ACTIVE) begin
        end
    endfunction

endclass: dma_slave_agent

`endif // _DMA_SLAVE_AGENT_SV_
