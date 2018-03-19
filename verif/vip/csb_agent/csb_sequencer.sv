`ifndef _CSB_SEQUENCER_SV_
`define _CSB_SEQUENCER_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: csb_sequencer
//
// XXX
//-------------------------------------------------------------------------------------

class csb_sequencer extends uvm_sequencer#(uvm_tlm_gp);

    string                tID;

    //------------------------CONFIGURATION PARAMETERS--------------------------------
    // CSB_SEQUENCER Configuration Parameters. These parameters can be controlled through 
    // the UVM configuration database
    // @{


    // }@

    `uvm_component_utils_begin(csb_sequencer)
    `uvm_component_utils_end

    extern function new(string name = "csb_sequencer", uvm_component parent = null);

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
    extern task          main_phase(uvm_phase phase);
    //extern task          shutdown_phase(uvm_phase phase);
    //extern function void extract_phase(uvm_phase phase);
    //extern function void check_phase(uvm_phase phase);
    //extern function void report_phase(uvm_phase phase);
    //extern function void final_phase(uvm_phase phase);

    // }@

    // Methods
    // @{
    

    // }@

endclass : csb_sequencer

// Function: new
// Creates a new CSB sequencer
function csb_sequencer::new(string name = "csb_sequencer", uvm_component parent = null);
    super.new(name, parent);
    tID = get_type_name().toupper();
endfunction : new

// Function: build_phase
// XXX
function void csb_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)
endfunction : build_phase

// Function: connect_phase
// XXX
function void csb_sequencer::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)
endfunction : connect_phase


// Task: main_phase
// XXX
task csb_sequencer::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_HIGH)
endtask : main_phase

`endif // _CSB_SEQUENCER_SV_
