`ifndef _NVDLA_TB_SEQUENCE_SV_
`define _NVDLA_TB_SEQUENCE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_tb_sequence
//
// @description
//-------------------------------------------------------------------------------------

class nvdla_tb_sequence extends uvm_component;

    string                   tID;
    
    ral_sys_top              ral;
    uvm_event_pool           glb_evts;

    typedef sequence_command seq_cmd_q[$];
    seq_cmd_q                blk_cmd[string];     

    uvm_tlm_analysis_fifo#(sequence_command) cmd_fifo; 

    // used to transport csb gp to ref model
    uvm_tlm_b_initiator_socket#(uvm_tlm_gp)  ini_socket;

    string                   work_mode = "CROSS_CHECK";
    //----------------------------------------------------------CONFIGURATION PARAMETERS
    // nvdla_tb_sequence Configuration Parameters. These parameters can be controlled through 
    // the UVM configuration database
    // @{

    // }@

    `uvm_component_utils_begin(nvdla_tb_sequence)
        `uvm_field_string(work_mode, UVM_ALL_ON)
    `uvm_component_utils_end

    extern function new(string name = "nvdla_tb_sequence", uvm_component parent = null);

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

    extern function void cmd_distribute();
    extern task          cmd_issue(sequence_command cmd);
    extern function uvm_tlm_gp  create_gp();
    extern task          write_i(sequence_command cmd);
    extern task          notify_i(sequence_command cmd);
    extern task          wait_i(sequence_command cmd);
    extern task          read_i(sequence_command cmd);
    extern task          read_check_i(sequence_command cmd);
    extern task          poll_field_i(sequence_command cmd);
    extern task          poll_reg_equal_i(sequence_command cmd);

    // }@
endclass : nvdla_tb_sequence

// Function: new
// Creates a new nvdla_tb_sequence component
function nvdla_tb_sequence::new(string name = "nvdla_tb_sequence", uvm_component parent = null);
    super.new(name, parent);
    tID = get_type_name().toupper();
endfunction : new

// Function: build_phase
// Used to construct testbench components, build top-level testbench topology 
function void nvdla_tb_sequence::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)

    cmd_fifo    = new("cmd_fifo", this);
    ini_socket  = new("ini_socket", this);
    if($value$plusargs("WORK_MODE=%0s", work_mode)) begin
        `uvm_info(tID, $sformatf("Setting WORK_MODE:%0s", work_mode), UVM_MEDIUM)
    end
endfunction : build_phase

// Function: connect_phase
// Used to connect components/tlm ports for environment topoloty
function void nvdla_tb_sequence::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)

    if(!uvm_config_db#(ral_sys_top)::get(this, "", "ral", ral)) begin
        `uvm_fatal(tID, "RAL handle is null")
    end
    glb_evts = uvm_event_pool::get_global_pool();
    if(glb_evts == null) begin
        `uvm_fatal(tID, "Failed to get global event pool")
    end
endfunction : connect_phase

// Function: end_of_elaboration_phase
// Used to make any final adjustments to the env topology
function void nvdla_tb_sequence::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(tID, $sformatf("end_of_elaboration_phase begin ..."), UVM_HIGH)

endfunction : end_of_elaboration_phase

// Function: start_of_simulation_phase
// Used to configure verification componets, printing 
function void nvdla_tb_sequence::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(tID, $sformatf("start_of_simulation_phase begin ..."), UVM_HIGH)

    cmd_distribute();
endfunction : start_of_simulation_phase

// TASK: run_phase
// Used to execute run-time tasks of simulation
task nvdla_tb_sequence::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(tID, $sformatf("run_phase begin ..."), UVM_HIGH)

endtask : run_phase

// TASK: reset_phase
// The reset phase is reserved for DUT or interface specific reset behavior
task nvdla_tb_sequence::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(tID, $sformatf("reset_phase begin ..."), UVM_HIGH)

endtask : reset_phase

// TASK: configure_phase
// Used to program the DUT or memoried in the testbench
task nvdla_tb_sequence::configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    `uvm_info(tID, $sformatf("configure_phase begin ..."), UVM_HIGH)

endtask : configure_phase

// TASK: main_phase
// Used to execure mainly run-time tasks of simulation
task nvdla_tb_sequence::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_MEDIUM)
    phase.raise_objection(this);
    foreach(blk_cmd[i]) begin
        automatic string j = i;
        fork
            begin
                sequence_command cmd;
                while(blk_cmd[j].size() != 0) begin
                    cmd = blk_cmd[j].pop_front();
                    cmd_issue(cmd);
                end
                `uvm_info(tID, $sformatf("main_phase::sequence %s, all commands have been procesdded.", j), UVM_MEDIUM)
            end
        join_none
    end
    wait fork;
    `uvm_info(tID, $sformatf("main_phase complete ..."), UVM_MEDIUM)
    phase.drop_objection(this);
endtask : main_phase

// TASK: shutdown_phase
// Data "drain" and other operations for graceful termination
task nvdla_tb_sequence::shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    `uvm_info(tID, $sformatf("shutdown_phase begin ..."), UVM_HIGH)

endtask : shutdown_phase

// Function: extract_phase
// Used to retrieve final state of DUTG and details of scoreboard, etc.
function void nvdla_tb_sequence::extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(tID, $sformatf("extract_phase begin ..."), UVM_HIGH)

endfunction : extract_phase

// Function: check_phase
// Used to process and check the simulation results
function void nvdla_tb_sequence::check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info(tID, $sformatf("check_phase begin ..."), UVM_HIGH)

endfunction : check_phase

// Function: report_phase
// Simulation results analysis and reports
function void nvdla_tb_sequence::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(tID, $sformatf("report_phase begin ..."), UVM_HIGH)

endfunction : report_phase

// Function: final_phase
// Used to complete/end any outstanding actions of testbench 
function void nvdla_tb_sequence::final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info(tID, $sformatf("final_phase begin ..."), UVM_HIGH)

endfunction : final_phase

// Function: cmd_distribute
// 
function void nvdla_tb_sequence::cmd_distribute();
    sequence_command  item_t;    
    sequence_command  item;    
    string            blk;
    uvm_event         evt;

    while(cmd_fifo.try_get(item_t))begin
        $cast(item, item_t.clone());
        `uvm_info(tID, $sformatf("cmd_distribute:\n%0s", item.sprint()), UVM_HIGH)
        if(item.kind == NOTIFY || item.kind == WAIT) begin
            evt = new(item.sync_id);
            glb_evts.add(item.sync_id, evt);
        end
        blk = item.block_name;
        blk_cmd[blk].push_back(item);
    end
endfunction : cmd_distribute

// Task: cmd_issue
// 
task nvdla_tb_sequence::cmd_issue(sequence_command cmd);
    `uvm_info(tID, $sformatf("cmd_issue start:%0s", cmd.sprint()), UVM_MEDIUM)
    case(cmd.kind) 
        WRITE:      write_i(cmd);
        NOTIFY:     notify_i(cmd);
        WAIT:       wait_i(cmd);
        READ:       read_i(cmd);
        READ_CHECK: read_check_i(cmd);
        POLL_REG_EQUAL:  poll_reg_equal_i(cmd);
        POLL_FIELD: poll_field_i(cmd);
    endcase
    `uvm_info(tID, $sformatf("cmd_issue done."), UVM_MEDIUM)
endtask : cmd_issue

function uvm_tlm_gp nvdla_tb_sequence::create_gp();
    byte unsigned     byte_en[];
    byte unsigned     data[];
    uvm_tlm_gp        gp;

    gp                = new("gp");
    data              = new[`CSB_DATA_WIDTH/8];
    byte_en           = new[`CSB_DATA_WIDTH/8];
    {<<byte{byte_en}} = {`CSB_DATA_WIDTH{1'b1}};
    gp.set_streaming_width(`CSB_DATA_WIDTH/8);
    gp.set_byte_enable(byte_en);
    gp.set_byte_enable_length(`CSB_DATA_WIDTH/8);
    gp.set_data(data);
    gp.set_data_length(`CSB_DATA_WIDTH/8);

    return gp;
endfunction : create_gp

// Task: write_i
// 
task nvdla_tb_sequence::write_i(sequence_command cmd);
    string          blk_name;
    string          reg_name;
    uvm_reg         regs;
    uvm_reg_block   blks;
    uvm_status_e    status;
    
    blk_name = cmd.block_name;
    reg_name = cmd.reg_name;
    blks = ral.nvdla.get_block_by_name(blk_name.toupper);
    if(blks == null) begin
        `uvm_fatal(tID, $sformatf("No exists uvm_reg_block: %s", blk_name))
    end
    regs = blks.get_reg_by_name(reg_name.toupper);
    if(regs == null) begin
        `uvm_fatal(tID, $sformatf("No exists uvm_reg: %s", reg_name))
    end
    regs.write(status, cmd.data);

endtask : write_i

// Task: notify_i
// 
task nvdla_tb_sequence::notify_i(sequence_command cmd);
    uvm_event  evt;

    if(!glb_evts.exists(cmd.sync_id)) begin
        `uvm_fatal(tID, $sformatf("sync_id %0s doesn't exist", cmd.sync_id))
    end
    else begin
        evt = glb_evts.get(cmd.sync_id);
    end
    evt.trigger();
    `uvm_info(tID, $sformatf("sync_id: %0s is trigged", cmd.sync_id), UVM_MEDIUM)
endtask : notify_i

// Task: wait_i
// 
task nvdla_tb_sequence::wait_i(sequence_command cmd);
    uvm_event  evt;

    if(!glb_evts.exists(cmd.sync_id)) begin
        `uvm_fatal(tID, $sformatf("sync_id %0s doesn't exist", cmd.sync_id))
    end
    else begin
        evt = glb_evts.get(cmd.sync_id);
    end
    evt.wait_on();
    `uvm_info(tID, $sformatf("sync_id: %0s is on", cmd.sync_id), UVM_MEDIUM)
    //evt.reset();
    //`uvm_info(tID, $sformatf("sync_id: %0s is reseted", cmd.sync_id), UVM_MEDIUM)
endtask : wait_i

// Task: read_i
// 
task nvdla_tb_sequence::read_i(sequence_command cmd);
    string          blk_name;
    string          reg_name;
    uvm_reg         regs;
    uvm_reg_block   blks;
    uvm_status_e    status;
    uvm_reg_data_t  reg_val;
    
    blk_name = cmd.block_name;
    reg_name = cmd.reg_name;
    blks = ral.nvdla.get_block_by_name(blk_name.toupper);
    if(blks == null) begin
        `uvm_fatal(tID, $sformatf("No exists uvm_reg_block: %s", blk_name))
    end
    regs = blks.get_reg_by_name(reg_name.toupper);
    if(regs == null) begin
        `uvm_fatal(tID, $sformatf("No exists uvm_reg: %s", reg_name))
    end
    regs.read(status, reg_val);
endtask : read_i

// Task: read_check_i
// 
task nvdla_tb_sequence::read_check_i(sequence_command cmd);
    string          blk_name;
    string          reg_name;
    uvm_reg         regs;
    uvm_reg_block   blks;
    uvm_status_e    status;
    uvm_reg_data_t  reg_val;
    
    blk_name = cmd.block_name;
    reg_name = cmd.reg_name;
    blks = ral.nvdla.get_block_by_name(blk_name.toupper);
    if(blks == null) begin
        `uvm_fatal(tID, $sformatf("No exists uvm_reg_block: %s", blk_name))
    end
    regs = blks.get_reg_by_name(reg_name.toupper);
    if(regs == null) begin
        `uvm_fatal(tID, $sformatf("No exists uvm_reg: %s", reg_name))
    end
    regs.read(status, reg_val);
    if(reg_val != cmd.data) begin
        `uvm_fatal(tID, $sformatf("value mismatch of %0s_%0s: act val %0h; exp val %0h", 
                   blk_name, reg_name, reg_val, cmd.data))
    end
endtask : read_check_i

// Task: poll_field_i
// 
task nvdla_tb_sequence::poll_field_i(sequence_command cmd);
endtask : poll_field_i

// Task: poll_reg_equal
// 
task nvdla_tb_sequence::poll_reg_equal_i(sequence_command cmd);
    string          blk_name;
    string          reg_name;
    uvm_reg         regs;
    uvm_reg_block   blks;
    uvm_status_e    status;
    uvm_reg_data_t  reg_val;
    uvm_tlm_gp      gp;
    uvm_tlm_time    tlm_time = new("tlm_time");
    byte unsigned   gp_data[];
    int unsigned    reg_val_uint32;
    
    blk_name = cmd.block_name;
    reg_name = cmd.reg_name;
    blks = ral.nvdla.get_block_by_name(blk_name.toupper);
    if(blks == null) begin
        `uvm_fatal(tID, $sformatf("No exists uvm_reg_block: %s", blk_name))
    end
    regs = blks.get_reg_by_name(reg_name.toupper);
    if(regs == null) begin
        `uvm_fatal(tID, $sformatf("No exists uvm_reg: %s", reg_name))
    end
    do begin
        if("CMOD_ONLY" != work_mode) begin
            regs.read(status, reg_val);
        end else begin
            gp = create_gp();
            gp.set_read();
            gp.set_address(regs.get_address());
            ini_socket.b_transport(gp, tlm_time);
            gp.get_data(gp_data);
            foreach (gp_data[i]) begin
                `uvm_info(tID, $sformatf("POLL_REG_EQUAL: GP data[%d]=%h", i, gp_data[i]), UVM_HIGH)
            end

            reg_val_uint32 = {<<byte{gp_data}};
            reg_val = reg_val_uint32;
            `uvm_info(tID, $sformatf("POLL_REG_EQUAL: reg_val=%h", reg_val), UVM_HIGH)
        end
    end while(reg_val != cmd.data );
    `uvm_info(tID, $sformatf("POLL_REG_EQUAL: %s.%s has reached to expected value %h", blk_name, reg_name, cmd.data), UVM_MEDIUM)

endtask : poll_reg_equal_i


`endif // _NVDLA_TB_SEQUENCE_SV_
