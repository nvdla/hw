`ifndef _NVDLA_TB_INTR_HANDLER_SV_
`define _NVDLA_TB_INTR_HANDLER_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_tb_intr_handler
//
// @description
//-------------------------------------------------------------------------------------

class nvdla_tb_intr_handler extends uvm_component;

    string                    tID;

    ral_sys_top               ral;
    uvm_event                 dut_intr_evt;
    uvm_event                 rm_intr_evt;
    uvm_event_pool            glb_evts;

    typedef interrupt_command intr_cmd_q[$];
    intr_cmd_q                blk_cmd[string];     

    uvm_tlm_analysis_fifo#(interrupt_command) cmd_fifo; 
    uvm_analysis_port#(interrupt_command) analysis_port; 

    // used to transport csb gp to ref model
    uvm_tlm_b_initiator_socket#(uvm_tlm_gp)   ini_socket;
    //----------------------------------------------------------CONFIGURATION PARAMETERS
    // NVDLA_TB_INTR_HANDLER Configuration Parameters. These parameters can be 
    // controlled through the UVM configuration database
    // @{

    bit                       is_rm;

    // Trace player has three work modes for different usages:
    // CMOD_ONLY:   only cmod is working
    // RTL_ONLY:    only DUT rtl is working
    // CROSS_CHECK: default verfication mode, cross check between RTL and CMOD
    string                    work_mode = "CROSS_CHECK";

    // }@

    `uvm_component_utils_begin(nvdla_tb_intr_handler)
        `uvm_field_int(is_rm,        UVM_ALL_ON)
        `uvm_field_string(work_mode, UVM_ALL_ON)
    `uvm_component_utils_end

    extern function new(string name = "nvdla_tb_intr_handler", uvm_component parent = null);

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

    extern function void        cmd_distribute();
    extern function int         cmd_queue_size();
    extern function uvm_tlm_gp  create_gp();
    extern task                 intr_process();
    extern task                 wait_intr(bit is_rm);
    extern task                 get_intr_val(input bit is_rm, output bit [`CSB_DATA_WIDTH-1:0] intr_val, output bit [`CSB_DATA_WIDTH-1:0] mask_val);
    extern task                 evt_trigger(bit is_rm, interrupt_command item);
    extern task                 intr_clear(bit is_rm, bit [`CSB_DATA_WIDTH-1:0] intr_val, bit [`CSB_DATA_WIDTH-1:0] mask_val);
    extern task                 evt_reset(bit is_rm);

    // }@
endclass : nvdla_tb_intr_handler

// Function: new
// Creates a new nvdla_tb_intr_handler component
function nvdla_tb_intr_handler::new(string name = "nvdla_tb_intr_handler", uvm_component parent = null);
    super.new(name, parent);
    tID = get_type_name().toupper();
endfunction : new

// Function: build_phase
// Used to construct testbench components, build top-level testbench topology 
function void nvdla_tb_intr_handler::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)

    cmd_fifo      = new("cmd_fifo", this);
    analysis_port = new("analysis_port", this);
    // used only for ref model
    if(is_rm) begin
        ini_socket = new("ini_socket", this);
    end

    if($value$plusargs("WORK_MODE=%0s", work_mode)) begin
        `uvm_info(tID, $sformatf("Setting WORK_MODE:%0s", work_mode), UVM_MEDIUM)
    end
endfunction : build_phase

// Function: connect_phase
// Used to connect components/tlm ports for environment topoloty
function void nvdla_tb_intr_handler::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)

    if(!uvm_config_db#(ral_sys_top)::get(this, "", "ral", ral)) begin
        `uvm_fatal(tID, "RAL handle is null")
    end
    glb_evts = uvm_event_pool::get_global_pool();
    if(glb_evts == null) begin
        `uvm_fatal(tID, "Failed to get global event pool")
    end
    if(!is_rm) begin
        if(!glb_evts.exists("dut_intr_evt")) begin
            `uvm_fatal(tID, $sformatf("dut_intr_evt doesn't exists"))
        end
        else begin
            dut_intr_evt = glb_evts.get("dut_intr_evt");
        end
    end
    else begin
        if(!glb_evts.exists("rm_intr_evt")) begin
            `uvm_fatal(tID, $sformatf("rm_intr_evt doesn't exists"))
        end
        else begin
            rm_intr_evt = glb_evts.get("rm_intr_evt");
        end
    end
endfunction : connect_phase

// Function: end_of_elaboration_phase
// Used to make any final adjustments to the env topology
function void nvdla_tb_intr_handler::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(tID, $sformatf("end_of_elaboration_phase begin ..."), UVM_HIGH)

endfunction : end_of_elaboration_phase

// Function: start_of_simulation_phase
// Used to configure verification componets, printing 
function void nvdla_tb_intr_handler::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(tID, $sformatf("start_of_simulation_phase begin ..."), UVM_HIGH)

    cmd_distribute();
endfunction : start_of_simulation_phase

// TASK: run_phase
// Used to execute run-time tasks of simulation
task nvdla_tb_intr_handler::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(tID, $sformatf("run_phase begin ..."), UVM_HIGH)

endtask : run_phase

// TASK: reset_phase
// The reset phase is reserved for DUT or interface specific reset behavior
task nvdla_tb_intr_handler::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(tID, $sformatf("reset_phase begin ..."), UVM_HIGH)

endtask : reset_phase

// TASK: configure_phase
// Used to program the DUT or memoried in the testbench
task nvdla_tb_intr_handler::configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    `uvm_info(tID, $sformatf("configure_phase begin ..."), UVM_HIGH)

endtask : configure_phase

// TASK: main_phase
// Used to execure mainly run-time tasks of simulation
task nvdla_tb_intr_handler::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_HIGH)

    // `uvm_info(tID, $sformatf("raise objection"), UVM_MEDIUM)
    // phase.raise_objection(this);
    if((is_rm && ("RTL_ONLY" != work_mode)) || (!is_rm && ("CMOD_ONLY" != work_mode))) begin
        while(cmd_queue_size()>0) begin
            `uvm_info(tID, $sformatf("raise objection"), UVM_MEDIUM)
            phase.raise_objection(this);
            intr_process();
            phase.drop_objection(this);
            `uvm_info(tID, $sformatf("drop objection"), UVM_MEDIUM)
        end
    end
    // `uvm_info(tID, $sformatf("main_phase complete ..."), UVM_HIGH)
    // `uvm_info(tID, $sformatf("drop objection"), UVM_MEDIUM)
    // phase.drop_objection(this);

endtask : main_phase

// TASK: shutdown_phase
// Data "drain" and other operations for graceful termination
task nvdla_tb_intr_handler::shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    `uvm_info(tID, $sformatf("shutdown_phase begin ..."), UVM_HIGH)

endtask : shutdown_phase

// Function: extract_phase
// Used to retrieve final state of DUTG and details of scoreboard, etc.
function void nvdla_tb_intr_handler::extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(tID, $sformatf("extract_phase begin ..."), UVM_HIGH)

endfunction : extract_phase

// Function: check_phase
// Used to process and check the simulation results
function void nvdla_tb_intr_handler::check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info(tID, $sformatf("check_phase begin ..."), UVM_HIGH)

endfunction : check_phase

// Function: report_phase
// Simulation results analysis and reports
function void nvdla_tb_intr_handler::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(tID, $sformatf("report_phase begin ..."), UVM_HIGH)

endfunction : report_phase

// Function: final_phase
// Used to complete/end any outstanding actions of testbench 
function void nvdla_tb_intr_handler::final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info(tID, $sformatf("final_phase begin ..."), UVM_HIGH)

endfunction : final_phase


// Function: cmd_distribute
// 
function void nvdla_tb_intr_handler::cmd_distribute();
    interrupt_command  item_t;    
    interrupt_command  item;    
    string             blk;

    while(cmd_fifo.try_get(item_t))begin
        $cast(item, item_t.clone());
        `uvm_info(tID, $sformatf("cmd_distribute:\n%0s", item.sprint()), UVM_HIGH)
        blk = item.interrupt_id.substr(0,item.interrupt_id.len()-3);
        blk = blk.toupper();
        blk_cmd[blk].push_back(item);
    end
endfunction : cmd_distribute

// Function: cmd_size
// Used to get total intr_cmd size received from trace parser
function int nvdla_tb_intr_handler::cmd_queue_size();
    int size = 0;
    foreach(blk_cmd[i]) begin
        size += blk_cmd[i].size();
        `uvm_info(tID, $sformatf("cmd_queue_size, %s remained cmd number:%d", i, blk_cmd[i].size()), UVM_HIGH)
    end
    `uvm_info(tID, $sformatf("cmd_queue_size, total remained cmd number:%d", size), UVM_HIGH)
    return size;
endfunction : cmd_queue_size

function uvm_tlm_gp nvdla_tb_intr_handler::create_gp();
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

task nvdla_tb_intr_handler::intr_process();
    bit [`CSB_DATA_WIDTH-1:0]    intr_val;
    bit [`CSB_DATA_WIDTH-1:0]    mask_val;
    uvm_reg_field     flds[$];
    interrupt_command item;
    uvm_tlm_gp        gp;
    int               lsb;

    wait_intr(is_rm);
    get_intr_val(is_rm, intr_val, mask_val);

    flds.delete();
    ral.nvdla.NVDLA_GLB.S_INTR_STATUS.get_fields(flds);
    foreach(flds[i]) begin
        lsb = flds[i].get_lsb_pos();
        if(intr_val[lsb] == 1) begin
            string    fld_name = flds[i].get_name();
            string    blk_name = fld_name.substr(0, fld_name.len()-14);
            bit       act_id   = fld_name.substr(fld_name.len-2, fld_name.len-1);
            bit       exp_id;
            `uvm_info(tID, $sformatf("field: %0s intr_val == 1", fld_name), UVM_NONE)

            item = blk_cmd[blk_name].pop_front();
            if(item == null) begin
                `uvm_fatal(tID, $sformatf("No expected INTR from %0s", fld_name))
            end
            exp_id = item.interrupt_id.substr(item.interrupt_id.len-2, item.interrupt_id.len-1);
            if(exp_id != act_id) begin
                interrupt_command item_pre;
                `uvm_warning(tID, $sformatf("Group of INTR mismatch, exp:%0d, act:%0d, checking next exp INTR ID", exp_id, act_id))
                $cast(item_pre, item.clone());
                item = blk_cmd[blk_name].pop_front();
                if(item == null) begin
                    `uvm_fatal(tID, $sformatf("No expected INTR from %0s", fld_name))
                end
                exp_id = item.interrupt_id.substr(item.interrupt_id.len-2, item.interrupt_id.len-1);
                if(exp_id != act_id) begin
                    `uvm_fatal(tID, $sformatf("Group of INTR mismatch, exp:%0d, act:%0d", exp_id, act_id))
                end
                else begin
                    // The sencond intr item matches, PUSH_FRONT the first mismatch item
                    blk_cmd[blk_name].push_front(item_pre);
                end
            end
            evt_trigger(is_rm, item);
            // write to interrupt scoreboard
            analysis_port.write(item);
        end
    end

    intr_clear(is_rm, intr_val, mask_val);
    evt_reset(is_rm);
endtask : intr_process

task nvdla_tb_intr_handler::wait_intr(bit is_rm);
    if(is_rm) begin
        rm_intr_evt.wait_on();
    end
    else begin
        dut_intr_evt.wait_on();
    end
    `uvm_info(tID, $sformatf("intr_evt is on"), UVM_MEDIUM)
endtask : wait_intr

task nvdla_tb_intr_handler::get_intr_val(input bit is_rm, output bit [`CSB_DATA_WIDTH-1:0] intr_val, output bit [`CSB_DATA_WIDTH-1:0] mask_val);
    if(is_rm) begin
        uvm_tlm_time      tlm_time = new("tlm_time");
        uvm_tlm_gp        gp;
        uvm_reg_addr_t    reg_addr;
        byte unsigned     pdata[];

        gp = create_gp();
        gp.set_read();
        reg_addr = ral.nvdla.NVDLA_GLB.S_INTR_STATUS.get_address();
        gp.set_address(reg_addr);
        ini_socket.b_transport(gp, tlm_time);
        gp.get_data(pdata);
        intr_val = {<<byte{pdata}};
        
        gp = create_gp();
        gp.set_read();
        pdata.delete();
        reg_addr = ral.nvdla.NVDLA_GLB.S_INTR_MASK.get_address();
        gp.set_address(reg_addr);
        ini_socket.b_transport(gp, tlm_time);
        gp.get_data(pdata);
        mask_val = {<<byte{pdata}};
    end
    else begin
        uvm_status_e      status;

        ral.nvdla.NVDLA_GLB.S_INTR_STATUS.read(status, intr_val);
        ral.nvdla.NVDLA_GLB.S_INTR_MASK.read(status, mask_val);
    end
    intr_val = intr_val & (~mask_val);
    if(intr_val == 0) begin
        `uvm_fatal(tID, "Interrupt is observed but no interrupt source is asserted!")
    end
    `uvm_info(tID, $sformatf("intr_val:%0h; mask_val:%0h",intr_val,mask_val), UVM_HIGH)
endtask : get_intr_val

task nvdla_tb_intr_handler::evt_trigger(bit is_rm, interrupt_command item);
    if((!is_rm) || ("CMOD_ONLY"==work_mode)) begin
        uvm_event evt;

        if(!glb_evts.exists(item.sync_id)) begin
            `uvm_fatal(tID, $sformatf("sync_id: %0s doesn't exist", item.sync_id))
        end
        else begin
            evt = glb_evts.get(item.sync_id);
            if(evt.is_on()) begin
                `uvm_fatal(tID, $sformatf("sync_id: %0s is already on", item.sync_id))
            end
            evt.trigger();
            `uvm_info(tID, $sformatf("sync_id: %0s is triggered", item.sync_id), UVM_MEDIUM)
        end
    end
endtask : evt_trigger

task nvdla_tb_intr_handler::intr_clear(bit is_rm, bit [`CSB_DATA_WIDTH-1:0] intr_val, bit [`CSB_DATA_WIDTH-1:0] mask_val);
    csb_bus_ext               bus_ext;
    bit [`CSB_DATA_WIDTH-1:0] temp_val;

    bus_ext = new();
    bus_ext.set_nposted(1);
    // write clear interrupt: npost-write
    if(is_rm) begin
        uvm_tlm_time      tlm_time = new("tlm_time");
        uvm_tlm_gp        gp;
        uvm_reg_addr_t    reg_addr;
        byte unsigned     pdata[];
       
        #5;
        gp = create_gp();
        gp.set_write();
        reg_addr = ral.nvdla.NVDLA_GLB.S_INTR_STATUS.get_address();
        gp.set_address(reg_addr);
        pdata = new[`CSB_DATA_WIDTH/8];
        pdata = {<<byte{intr_val}};
        gp.set_data(pdata);
        gp.set_extension(bus_ext);
        ini_socket.b_transport(gp, tlm_time);

        gp = create_gp();
        gp.set_read();
        pdata.delete();
        reg_addr = ral.nvdla.NVDLA_GLB.S_INTR_STATUS.get_address();
        gp.set_address(reg_addr);
        ini_socket.b_transport(gp, tlm_time);
        gp.get_data(pdata);
        temp_val = {<<byte{pdata}};
    end
    else begin
        uvm_status_e      status;

        ral.nvdla.NVDLA_GLB.S_INTR_STATUS.write(status, intr_val, .extension(bus_ext));
        ral.nvdla.NVDLA_GLB.S_INTR_STATUS.read(status, temp_val);
    end

    if(temp_val & (~mask_val) & intr_val) begin
        `uvm_fatal(tID, $sformatf("Fail to clear intr"))
    end
    `uvm_info(tID, $sformatf("intr clear done"), UVM_HIGH)
endtask : intr_clear

task nvdla_tb_intr_handler::evt_reset(bit is_rm);
    if(is_rm) begin
        rm_intr_evt.reset();
    end
    else begin
        dut_intr_evt.reset();
    end
endtask : evt_reset
`endif // _NVDLA_TB_INTR_HANDLER_SV_
