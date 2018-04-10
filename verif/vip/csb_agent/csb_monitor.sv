`ifndef _CSB_MONITOR_SV_
`define _CSB_MONITOR_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: csb_monitor
//
// XXX
//-------------------------------------------------------------------------------------

class csb_monitor extends uvm_monitor;

    string                      tID;

    virtual csb_interface       vif;

    int                         cycle_cnt;

    uvm_tlm_gp                  cur_gp;
    uvm_tlm_gp                  read_queue[$];
    uvm_tlm_gp                  write_queue[$];

    ral_sys_top                 ral;
    // used to transport csb gp to ref model
    uvm_tlm_b_initiator_socket#(uvm_tlm_gp) ini_socket;

    // to coverage model
    uvm_analysis_port #(uvm_tlm_gp) analysis_port;

    //------------------------CONFIGURATION PARAMETERS--------------------------------
    // CSB_MONITOR Configuration Parameters. These parameters can be controlled through 
    // the UVM configuration database
    // @{

    // Trace player has three work modes for different usages:
    // CMOD_ONLY:   only cmod is working
    // RTL_ONLY:    only DUT rtl is working
    // CROSS_CHECK: default verfication mode, cross check between RTL and CMOD
    string                      work_mode = "CROSS_CHECK";

    // }@

    `uvm_component_utils_begin(csb_monitor)
        `uvm_field_string(work_mode, UVM_ALL_ON)
    `uvm_component_utils_end

    extern function new(string name = "csb_monitor", uvm_component parent = null);

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
    
    extern function uvm_tlm_gp create_new_gp();
    extern task                txn_start(uvm_tlm_gp gp);
    extern task                txn_finish(uvm_tlm_gp gp);
    extern function void       reset_monitor();
    extern task                reset_control();
    extern function void       read_control(uvm_tlm_gp gp);
    extern task                control_loop();
    extern task                write_resp_loop();
    extern task                read_resp_loop();

    // }@

endclass : csb_monitor

// Function: new
// Creates a new CSB monitor
function csb_monitor::new(string name = "csb_monitor", uvm_component parent = null);
    super.new(name, parent);

    tID        = get_type_name().toupper();
endfunction : new

// Function: build_phase
// XXX
function void csb_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)

    if($value$plusargs("WORK_MODE=%0s", work_mode)) begin
        `uvm_info(tID, $sformatf("Setting WORK_MODE:%0s", work_mode), UVM_MEDIUM)
    end

    ini_socket = new("ini_socket", this);
    analysis_port = new("analysis_port", this);
endfunction : build_phase

// Function: connect_phase
// XXX
function void csb_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)

    if(!uvm_config_db#(ral_sys_top)::get(this, "", "ral", ral)) begin
        `uvm_fatal(tID, "RAL handle is null")
    end
    // Get virtual interface from uvm_config_db
    if(!uvm_config_db#(virtual csb_interface)::get(this, "", "vif", vif)) begin
        `uvm_fatal(tID, "No virtual interface specified fo csb_monitor")
    end
endfunction : connect_phase


// Task: main_phase
// XXX
task csb_monitor::main_phase(uvm_phase phase);

    super.main_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_MEDIUM)

    forever begin
        wait(vif.rst_n === 1);
        `uvm_info(tID, $sformatf("reset deassert"), UVM_MEDIUM)
        fork
            reset_control();
            control_loop();
            write_resp_loop();
            read_resp_loop();
        join_any
        disable fork;
    end
endtask : main_phase

function uvm_tlm_gp csb_monitor::create_new_gp();
    uvm_tlm_gp     gp;
    csb_bus_ext    bus_ext;
    csb_ctrl_ext   ctrl_ext;
    byte unsigned  byte_en[];

    gp       = uvm_tlm_gp::type_id::create("gp",,get_full_name());
    bus_ext  = csb_bus_ext::type_id::create("bus_ext",,get_full_name());
    ctrl_ext = csb_ctrl_ext::type_id::create("ctrl_ext",,get_full_name());

    byte_en = new[`CSB_DATA_WIDTH/8];
    foreach(byte_en[i]) begin
        byte_en[i] = 'hFF;
    end
    gp.set_byte_enable(byte_en);
    gp.set_byte_enable_length(`CSB_DATA_WIDTH/8);
    gp.set_streaming_width(`CSB_DATA_WIDTH/8);
    gp.set_extension(bus_ext);
    gp.set_extension(ctrl_ext);
    return gp;
endfunction : create_new_gp

function void csb_monitor::read_control(uvm_tlm_gp gp);
    csb_bus_ext   bus_ext;
    byte unsigned wdata[];

    if(vif.moncb.write === 1) begin
        gp.set_write();
        wdata   = new[`CSB_DATA_WIDTH/8];
        wdata = {<<byte{vif.moncb.wdata}};
        gp.set_data(wdata);
        gp.set_data_length(`CSB_DATA_WIDTH/8);
    end
    else begin
        gp.set_read();
    end
    $cast(bus_ext, gp.get_extension(csb_bus_ext::ID));
    bus_ext.set_nposted(vif.moncb.nposted);
    gp.set_extension(bus_ext);
    gp.set_address((vif.moncb.addr<<2));
    `uvm_info(tID, $sformatf("read gp:\n%0s", gp.sprint()), UVM_HIGH)
endfunction : read_control

task csb_monitor::txn_start(uvm_tlm_gp gp);
    csb_ctrl_ext ctrl_ext;

    //`uvm_do_callbacks(csb_monitor, csb_monitor_callbacks, pre_trans(this, gp));

    $cast(ctrl_ext, gp.get_extension(csb_ctrl_ext::ID));
    ctrl_ext.set_c_start(cycle_cnt);
    ctrl_ext.set_t_start($time);
    gp.set_extension(ctrl_ext);
    `uvm_info(tID, $sformatf("TXN starting:\n%0s", gp.sprint()), UVM_HIGH)
endtask : txn_start

task csb_monitor::txn_finish(uvm_tlm_gp gp);
    csb_ctrl_ext ctrl_ext;
    uvm_tlm_time tlm_time = new("tlm_time");

    //`uvm_do_callbacks(csb_monitor, csb_monitor_callbacks, post_trans(this, gp));

    $cast(ctrl_ext, gp.get_extension(csb_ctrl_ext::ID));
    ctrl_ext.set_c_end(cycle_cnt);
    ctrl_ext.set_t_end($time);
    gp.set_extension(ctrl_ext);
    // NEEDN'T send read txn and interrupt write txn to CMOD
    if("RTL_ONLY" != work_mode) begin
        if(gp.is_write() && (gp.get_address() != ral.nvdla.NVDLA_GLB.S_INTR_STATUS.get_address())) begin
            ini_socket.b_transport(gp, tlm_time);
        end
    end
    // to coverage model
    analysis_port.write(gp);
    `uvm_info(tID, $sformatf("TXN finishing:\n%0s", gp.sprint()), UVM_MEDIUM)
endtask : txn_finish

function void csb_monitor::reset_monitor();
    write_queue.delete();
    read_queue.delete();
endfunction : reset_monitor

task csb_monitor::reset_control();
    wait(vif.rst_n === 0) begin
        `uvm_info(tID, $sformatf("reset assert"), UVM_MEDIUM)
        if(cur_gp != null) begin
            cur_gp.set_response_status(UVM_TLM_INCOMPLETE_RESPONSE);
            txn_finish(cur_gp);
            cur_gp = null;
        end
        reset_monitor();
    end
endtask : reset_control

task csb_monitor::control_loop();
    csb_bus_ext bus_ext;
    forever begin
        @(vif.moncb);
        cycle_cnt++;
        if(vif.moncb.pvld && vif.moncb.prdy) begin
            `uvm_info(tID, $sformatf("req done"), UVM_HIGH)
            cur_gp = create_new_gp();
            read_control(cur_gp);
            txn_start(cur_gp);

            if(cur_gp.is_write()) begin
                $cast(bus_ext, cur_gp.get_extension(csb_bus_ext::ID));
                if(bus_ext.is_nposted()) begin
                    write_queue.push_back(cur_gp);
                    `uvm_info(tID, $sformatf("push write queue"), UVM_HIGH)
                end
                else begin
                    txn_finish(cur_gp);
                end
            end
            else begin
                read_queue.push_back(cur_gp);
                `uvm_info(tID, $sformatf("push read queue"), UVM_HIGH)
            end
        end
    end
endtask : control_loop

task csb_monitor::write_resp_loop();
    forever begin
        @(vif.moncb);
        if(vif.moncb.wr_complete === 1) begin
            `uvm_info(tID, $sformatf("detect wr_complete"), UVM_HIGH)
            if(write_queue.size() != 0) begin
                uvm_tlm_gp gp;
                gp = write_queue.pop_front();
                txn_finish(gp);
            end
            else begin
                `uvm_fatal(tID, "Write ACK without write request")
            end
        end
    end
endtask : write_resp_loop

task csb_monitor::read_resp_loop();
    byte unsigned rdata[];
    forever begin
        @(vif.moncb);
        if(vif.moncb.rvld === 1) begin
            uvm_tlm_gp gp;
            if(read_queue.size() != 0) begin
                gp = read_queue.pop_front();
                rdata = new[`CSB_DATA_WIDTH/8];
                rdata = {<<byte{vif.moncb.rdata}};
                gp.set_data(rdata);
                gp.set_data_length(`CSB_DATA_WIDTH/8);
                txn_finish(gp);
            end
            else begin
                `uvm_fatal(tID, "Read ACK without read request")
            end
        end
    end
endtask : read_resp_loop

`endif // _CSB_MONITOR_SV_
