`ifndef dbb_slave_seq__SV
`define dbb_slave_seq__SV

/// UVM-compliant sequencer class for the UVM DBB Slave driver.
class dbb_slave_seq extends uvm_sequencer # (uvm_tlm_gp);
    string                tID;

    `uvm_component_utils(dbb_slave_seq)
    function new (string name,
                  uvm_component parent);
        super.new(name,parent);
        tID = get_type_name().toupper();
    endfunction: new

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
 
endclass: dbb_slave_seq

// Function: build_phase
// Used to construct testbench components, build top-level testbench topology
function void dbb_slave_seq::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_LOW)
endfunction : build_phase

// Function: connect_phase
// Used to connect components/tlm ports for environment topoloty
function void dbb_slave_seq::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_LOW)
endfunction : connect_phase


// Task: main_phase
// Used to execure mainly run-time tasks of simulation
task dbb_slave_seq::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_LOW)
endtask : main_phase
   
`endif
