`ifndef _NVDLA_TB_RESULT_CHECKER_SV_
`define _NVDLA_TB_RESULT_CHECKER_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_tb_result_checker
//
// @description
//  Phase
//
//-------------------------------------------------------------------------------------

class nvdla_tb_result_checker extends uvm_component;

    string                                          tID;

    ral_sys_top                                     ral;

    uvm_event_pool                                  global_event_pool;
    uvm_event                                       sim_done_evt;

    uvm_tlm_analysis_fifo#(result_checker_command)  command_fifo; 
    uint32_t                                        command_number;
    uvm_analysis_port#(result_checker_command)      primary_memory_check_command_port; 
    uvm_analysis_port#(result_checker_command)      secondary_memory_check_command_port; 

    //----------------------------------------------------------CONFIGURATION PARAMETERS
    // NVDLA_TB_RESULT_CHECKER Configuration Parameters. These parameters can be 
    // controlled through the UVM configuration database
    // @{

    // Trace player has three work modes for different usages:
    // CMOD_ONLY:   only cmod is working
    // RTL_ONLY:    only DUT rtl is working
    // CROSS_CHECK: default verfication mode, cross check between RTL and CMOD
    string                      work_mode = "CROSS_CHECK";

    // }@

    `uvm_component_utils_begin(nvdla_tb_result_checker)
        `uvm_field_string(work_mode, UVM_ALL_ON)
    `uvm_component_utils_end

    extern function new(string name = "nvdla_tb_result_checker", uvm_component parent = null);

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

    //---------------------------------------------------------------------------Methods
    // @{

    extern function void check_command_fifo_size_shall_not_be_zero();
    extern function void check_command_fifo_size_shall_be_zero();
    extern task          warden_process();

    // }@
endclass : nvdla_tb_result_checker

// Function: new
// Creates a new nvdla_tb_result_checker component
function nvdla_tb_result_checker::new(string name = "nvdla_tb_result_checker", uvm_component parent = null);
    super.new(name, parent);
    tID = get_type_name().toupper();
endfunction : new

// Function: build_phase
// Used to construct testbench components, build top-level testbench topology 
function void nvdla_tb_result_checker::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)

    command_fifo                        = new("command_fifo", this);
    primary_memory_check_command_port   = new("primary_memory_check_command_port", this);
    secondary_memory_check_command_port = new("secondary_memory_check_command_port", this);

    if($value$plusargs("WORK_MODE=%0s", work_mode)) begin
        `uvm_info(tID, $sformatf("Setting WORK_MODE:%0s", work_mode), UVM_MEDIUM)
    end
endfunction : build_phase

// Function: connect_phase
// Used to connect components/tlm ports for environment topoloty
function void nvdla_tb_result_checker::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)

    if(!uvm_config_db#(ral_sys_top)::get(this, "", "ral", ral)) begin
        `uvm_fatal(tID, "RAL handle is null")
    end
    global_event_pool = uvm_event_pool::get_global_pool();
    if(global_event_pool == null) begin
        `uvm_fatal(tID, "Failed to get global event pool")
    end
    
    if(!global_event_pool.exists("sim_done_evt")) begin
        `uvm_fatal(tID, "Failed to get sim_done_evt from global_event_pool")
    end else begin
        sim_done_evt = global_event_pool.get("sim_done_evt");
    end

endfunction : connect_phase

// Function: end_of_elaboration_phase
// Used to make any final adjustments to the env topology
function void nvdla_tb_result_checker::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(tID, $sformatf("end_of_elaboration_phase begin ..."), UVM_HIGH)

endfunction : end_of_elaboration_phase

// Function: start_of_simulation_phase
// Used to configure verification componets, printing 
function void nvdla_tb_result_checker::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(tID, $sformatf("start_of_simulation_phase begin ..."), UVM_HIGH)
    command_number = command_fifo.used();
    `uvm_info(tID, $sformatf("There are %d result checking commands", command_number), UVM_HIGH)
    check_command_fifo_size_shall_not_be_zero();
endfunction : start_of_simulation_phase

// TASK: run_phase
// Used to execute run-time tasks of simulation
task nvdla_tb_result_checker::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(tID, $sformatf("run_phase begin ..."), UVM_HIGH)

endtask : run_phase

// TASK: reset_phase
// The reset phase is reserved for DUT or interface specific reset behavior
task nvdla_tb_result_checker::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(tID, $sformatf("reset_phase begin ..."), UVM_HIGH)

endtask : reset_phase

// TASK: configure_phase
// Used to program the DUT or memoried in the testbench
task nvdla_tb_result_checker::configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    `uvm_info(tID, $sformatf("configure_phase begin ..."), UVM_HIGH)

endtask : configure_phase

// TASK: main_phase
// Used to execure mainly run-time tasks of simulation
task nvdla_tb_result_checker::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_MEDIUM)
    phase.raise_objection(this);
    warden_process();
    phase.drop_objection(this);
    `uvm_info(tID, $sformatf("main_phase end ..."), UVM_MEDIUM)

endtask : main_phase

// TASK: shutdown_phase
// Data "drain" and other operations for graceful termination
task nvdla_tb_result_checker::shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    `uvm_info(tID, $sformatf("shutdown_phase begin ..."), UVM_HIGH)
    check_command_fifo_size_shall_be_zero();

endtask : shutdown_phase

// Function: extract_phase
// Used to retrieve final state of DUTG and details of scoreboard, etc.
function void nvdla_tb_result_checker::extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(tID, $sformatf("extract_phase begin ..."), UVM_HIGH)

endfunction : extract_phase

// Function: check_phase
// Used to process and check the simulation results
function void nvdla_tb_result_checker::check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info(tID, $sformatf("check_phase begin ..."), UVM_HIGH)

endfunction : check_phase

// Function: report_phase
// Simulation results analysis and reports
function void nvdla_tb_result_checker::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(tID, $sformatf("report_phase begin ..."), UVM_HIGH)

endfunction : report_phase

// Function: final_phase
// Used to complete/end any outstanding actions of testbench 
function void nvdla_tb_result_checker::final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info(tID, $sformatf("final_phase begin ..."), UVM_HIGH)

endfunction : final_phase

// Function: check_command_fifo_size
// 
function void nvdla_tb_result_checker::check_command_fifo_size_shall_not_be_zero();
    if (0 == command_fifo.used()) begin
        `uvm_fatal(tID, "Command fifo is empty, no command has been received.")
    end
endfunction : check_command_fifo_size_shall_not_be_zero

// Function: check_command_fifo_size
// 
function void nvdla_tb_result_checker::check_command_fifo_size_shall_be_zero();
    if ((0 != command_fifo.used()) && ("CMOD_ONLY" != work_mode)) begin
        `uvm_fatal(tID, "Command fifo is not empty, receive commands in simulation phases.")
    end
endfunction : check_command_fifo_size_shall_be_zero

// Task: warden_process
// 
task nvdla_tb_result_checker::warden_process();
    uint32_t cmd_idx;
    for (cmd_idx = 0; cmd_idx < command_number; cmd_idx ++) begin
        automatic uint32_t var_i = cmd_idx;
        fork
            begin
                uvm_event evt;
                result_checker_command cmd_item;
                command_fifo.get(cmd_item);
                if(!global_event_pool.exists(cmd_item.sync_id)) begin
                    `uvm_fatal(tID, $sformatf("sync_id %0s doesn't exist", cmd_item.sync_id))
                end
                evt = global_event_pool.get(cmd_item.sync_id);
                if (evt.is_off()) begin
                    evt.wait_on();
                end
                if (CHECK_NOTHING == cmd_item.kind) begin
                    `uvm_info(tID, $sformatf("No need to check on sync_id:%s.", cmd_item.sync_id), UVM_MEDIUM)
                end else begin
                    `uvm_info(tID, $sformatf("Ready to send check command to memory model ..."), UVM_MEDIUM)
                    if (PRI_MEM == cmd_item.memory_type) begin
                        primary_memory_check_command_port.write(cmd_item);
                    end else begin
                        secondary_memory_check_command_port.write(cmd_item);
                    end
                end
            end
        join_none
    end
    wait fork;
    
    // Simulation complete notification
    sim_done_evt.trigger();

endtask : warden_process

`endif // _NVDLA_TB_RESULT_CHECKER_SV_
