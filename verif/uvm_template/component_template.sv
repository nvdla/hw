`ifndef _XXX_SV_
`define _XXX_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: XXX
//
// @description
//-------------------------------------------------------------------------------------

class XXX extends uvm_component;

    string                tID;

    //----------------------------------------------------------CONFIGURATION PARAMETERS
    // XXX Configuration Parameters. These parameters can be controlled through 
    // the UVM configuration database
    // @{

    // }@

    `uvm_component_utils_begin(XXX)
    `uvm_component_utils_end

    extern function new(string name = "XXX", uvm_component parent = null);

    //------------------------------------------------------------------------UVM Phases
    // Not all phases are needed, just enable specific phases for different component
    // @{

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern function void start_of_simulation_phase(uvm_phase phase);
    extern task          run_phase(uvm_phase phase);
    extern task          reset_phase(uvm_phase phase);
    extern task          configure_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
    extern task          shutdown_phase(uvm_phase phase);
    extern function void extract_phase(uvm_phase phase);
    extern function void check_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
    extern function void final_phase(uvm_phase phase);

    // }@

endclass : XXX

// Function: new
// Creates a new XXX component
function XXX::new(string name = "XXX", uvm_component parent = null);
    super.new(name, parent);
    tID = get_type_name().toupper();
endfunction : new

// Function: build_phase
// Used to construct testbench components, build top-level testbench topology 
function void XXX::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)

endfunction : build_phase

// Function: connect_phase
// Used to connect components/tlm ports for environment topoloty
function void XXX::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)

endfunction : connect_phase

// Function: end_of_elaboration_phase
// Used to make any final adjustments to the env topology
function void XXX::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(tID, $sformatf("end_of_elaboration_phase begin ..."), UVM_HIGH)

endfunction : end_of_elaboration_phase

// Function: start_of_simulation_phase
// Used to configure verification componets, printing 
function void XXX::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(tID, $sformatf("start_of_simulation_phase begin ..."), UVM_HIGH)

endfunction : start_of_simulation_phase

// TASK: run_phase
// Used to execute run-time tasks of simulation
task XXX::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(tID, $sformatf("run_phase begin ..."), UVM_HIGH)

endtask : run_phase

// TASK: reset_phase
// The reset phase is reserved for DUT or interface specific reset behavior
task XXX::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(tID, $sformatf("reset_phase begin ..."), UVM_HIGH)

endtask : reset_phase

// TASK: configure_phase
// Used to program the DUT or memoried in the testbench
task XXX::configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    `uvm_info(tID, $sformatf("configure_phase begin ..."), UVM_HIGH)

endtask : configure_phase

// TASK: main_phase
// Used to execure mainly run-time tasks of simulation
task XXX::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_HIGH)

endtask : main_phase

// TASK: shutdown_phase
// Data "drain" and other operations for graceful termination
task XXX::shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    `uvm_info(tID, $sformatf("shutdown_phase begin ..."), UVM_HIGH)

endtask : shutdown_phase

// Function: extract_phase
// Used to retrieve final state of DUTG and details of scoreboard, etc.
function void XXX::extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(tID, $sformatf("extract_phase begin ..."), UVM_HIGH)

endfunction : extract_phase

// Function: check_phase
// Used to process and check the simulation results
function void XXX::check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info(tID, $sformatf("check_phase begin ..."), UVM_HIGH)

endfunction : check_phase

// Function: report_phase
// Simulation results analysis and reports
function void XXX::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(tID, $sformatf("report_phase begin ..."), UVM_HIGH)

endfunction : report_phase

// Function: final_phase
// Used to complete/end any outstanding actions of testbench 
function void XXX::final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info(tID, $sformatf("final_phase begin ..."), UVM_HIGH)

endfunction : final_phase



`endif // _XXX_SV_
