`ifndef _CSB_AGENT_SV_
`define _CSB_AGENT_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: csb_agent
//
// The csb_agent is a master agent, which used to hook up to DLA csb interface. The 
// driver/sequencer/monitor components are created & connected in the class. The 
// csb_agent supports both active and passive mode. All driver/sequencer/monitor are
// avaliable in active mode and only monitor is avaliable in passive mode.
//-------------------------------------------------------------------------------------

class csb_agent extends uvm_agent;

    string                tID;

    csb_sequencer         sqr;
    csb_driver            drv;
    csb_monitor           mon;

    virtual csb_interface vif;

    //------------------------CONFIGURATION PARAMETERS--------------------------------
    // CSB_AGENT Configuration Parameters. These parameters can be controlled through 
    // the UVM configuration database
    // @{

    // agent active/passive mode control
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    // }@

    `uvm_component_utils_begin(csb_agent)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_component_utils_end

    extern function new(string name = "csb_agent", uvm_component parent = null);

    // UVM Phases
    // Can just enable needed phase
    // @{

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    //extern function void end_of_elaboration_phase(uvm_phase phase);
    //extern function void start_of_simulation_phase(uvm_phase phase);
    //extern task          run_phase(uvm_phase phase);
    //extern task          reset_phase(uvm_phase phase);
    //extern task          configure_phase(uvm_phase phase);
    //extern task          main_phase(uvm_phase phase);
    //extern task          shutdown_phase(uvm_phase phase);
    //extern function void extract_phase(uvm_phase phase);
    //extern function void check_phase(uvm_phase phase);
    //extern function void report_phase(uvm_phase phase);
    //extern function void final_phase(uvm_phase phase);

    // }@

endclass : csb_agent

// Function: new
// Creates a new CSB master agent
function csb_agent::new(string name = "csb_agent", uvm_component parent = null);
    super.new(name, parent);
    tID = get_type_name().toupper();
endfunction : new

// Function: build_phase
// XXX
function void csb_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)

    // Get virtual interface from uvm_config_db
    if(!uvm_config_db#(virtual csb_interface)::get(this, "", "vif", vif)) begin
        `uvm_fatal(tID, "No virtual interface specified fo csb_agent")
    end
    else begin
        uvm_config_db#(virtual csb_interface)::set(this, "*", "vif", vif);
    end

    // Always create monitor
    mon = csb_monitor::type_id::create("mon", this);
    // Create drvier/sequecer accoding to mode configure "is_active"
    if(is_active == UVM_ACTIVE) begin
        sqr = csb_sequencer::type_id::create("sqr", this);
        drv = csb_driver::type_id::create("drv", this);
    end
endfunction : build_phase

// Function: connect_phase
// XXX
function void csb_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)

    // Connect driver and monitor if in ACTIVE mode
    if(is_active == UVM_ACTIVE) begin
        drv.seq_item_port.connect(sqr.seq_item_export);
    end
endfunction : connect_phase

`endif // CSB_AGENT_SV_
