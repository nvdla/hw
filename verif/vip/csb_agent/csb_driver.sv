`ifndef _CSB_DRIVER_SV_
`define _CSB_DRIVER_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: csb_driver
//
// XXX
//-------------------------------------------------------------------------------------

class csb_driver extends uvm_driver#(uvm_tlm_gp);

    string                tID;

    virtual csb_interface vif;

    uvm_tlm_gp            cur_gp;

    //------------------------CONFIGURATION PARAMETERS--------------------------------
    // CSB_DRIVER Configuration Parameters. These parameters can be controlled through 
    // the UVM configuration database
    // @{

    bit drive_z_between_txns = 1;

    // }@

    `uvm_component_utils_begin(csb_driver)
        `uvm_field_int(drive_z_between_txns, UVM_ALL_ON)
    `uvm_component_utils_end

    extern function new(string name = "csb_driver", uvm_component parent = null);

    // UVM Phases
    // Can just enable needed phase
    // @{

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    //extern function void end_of_elaboration_phase(uvm_phase phase);
    //extern function void start_of_simulation_phase(uvm_phase phase);
    //extern task          run_phase(uvm_phase phase);
    extern task          reset_phase(uvm_phase phase);
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
    
    extern function void quiesce_bus();
    extern task          reset_control();
    extern task          control_loop();
    extern task          txn_start(uvm_tlm_gp gp);
    extern task          txn_finish(uvm_tlm_gp gp);
    extern task          drive_txn(uvm_tlm_gp gp);
    extern task          drive_write(uvm_tlm_gp gp);
    extern task          drive_read(uvm_tlm_gp gp);

    // }@

endclass : csb_driver

// Function: new
// Creates a new CSB driver
function csb_driver::new(string name = "csb_driver", uvm_component parent = null);
    super.new(name, parent);
    tID = get_type_name().toupper();
endfunction : new

// Function: build_phase
// XXX
function void csb_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)
endfunction : build_phase

// Function: connect_phase
// XXX
function void csb_driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)

    // Get virtual interface from uvm_config_db
    if(!uvm_config_db#(virtual csb_interface)::get(this, "", "vif", vif)) begin
        `uvm_fatal(tID, "No virtual interface specified fo csb_driver")
    end
endfunction : connect_phase

// Task: reset_phase
// XXX
task csb_driver::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    quiesce_bus();
endtask : reset_phase

// Task: main_phase
// XXX
task csb_driver::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_MEDIUM)

    forever begin
        wait(vif.rst_n === 1);
        `uvm_info(tID, $sformatf("reset deassert"), UVM_MEDIUM)
        repeat(20) @(vif.mcb);
        fork
            reset_control();
            control_loop();
        join_any
        disable fork;
    end
endtask : main_phase

// Function: quiesce_bus
// XXX
function void csb_driver::quiesce_bus();
    vif.mcb.pvld    <= 0;
    vif.mcb.write   <= 0;
    vif.mcb.nposted <= 0;
    if(drive_z_between_txns) begin
        vif.mcb.addr  <= 'z;
        vif.mcb.wdata <= 'z;
    end
endfunction : quiesce_bus

task csb_driver::reset_control();
    wait(vif.rst_n === 0) begin
        `uvm_info(tID, $sformatf("reset assert"), UVM_MEDIUM)
        if(cur_gp != null) begin
            cur_gp.set_response_status(UVM_TLM_INCOMPLETE_RESPONSE);
            txn_finish(cur_gp);
            cur_gp = null;
        end
        quiesce_bus();
    end
endtask : reset_control

task csb_driver::control_loop();
    forever begin
        seq_item_port.get_next_item(cur_gp);
        `uvm_info(tID, $sformatf("Item got from sqr:\n%0s", cur_gp.sprint()), UVM_HIGH)
        //`uvm_do_callbacks(csb_driver, csb_driver_callbacks, pre_trans(this, gp))
        drive_txn(cur_gp);
        seq_item_port.item_done();
        `uvm_info(tID, $sformatf("Item driven done:\n%0s", cur_gp.sprint()), UVM_HIGH)
    end
endtask : control_loop

task csb_driver::txn_start(uvm_tlm_gp gp);
    csb_ctrl_ext ctrl_ext;

    //`uvm_do_callbacks(csb_driver, csb_driver_callbacks, pre_trans(this, gp));

    $cast(ctrl_ext, gp.get_extension(csb_ctrl_ext::ID));
    ctrl_ext.set_t_start($time);
    gp.set_extension(ctrl_ext);
    `uvm_info(tID, $sformatf("TXN Starting:\n%0s", gp.sprint()), UVM_HIGH)
endtask : txn_start

task csb_driver::txn_finish(uvm_tlm_gp gp);
    csb_ctrl_ext ctrl_ext;
    uvm_tlm_time tlm_time = new("tlm_time");

    //`uvm_do_callbacks(csb_driver, csb_driver_callbacks, post_trans(this, gp));

    $cast(ctrl_ext, gp.get_extension(csb_ctrl_ext::ID));
    ctrl_ext.set_t_end($time);
    gp.set_extension(ctrl_ext);
    `uvm_info(tID, $sformatf("TXN finishing:\n%0s", gp.sprint()), UVM_HIGH)
endtask : txn_finish

task csb_driver::drive_txn(uvm_tlm_gp gp);
    `uvm_info(tID, $sformatf("In drive_txn loop"), UVM_HIGH)
    txn_start(gp);
    if(gp.is_write()) begin
        drive_write(gp);
    end
    else begin
        drive_read(gp);
    end
    txn_finish(gp);
endtask : drive_txn

task csb_driver::drive_write(uvm_tlm_gp gp);
    csb_bus_ext               bus_ext;
    csb_ctrl_ext              ctrl_ext;
    byte unsigned             pdata[];
    bit [`CSB_DATA_WIDTH-1:0] wdata;

    $cast(bus_ext, gp.get_extension(csb_bus_ext::ID));
    $cast(ctrl_ext, gp.get_extension(csb_ctrl_ext::ID));
    gp.get_data(pdata);
    wdata = {<<byte{pdata}};

    // Drive write address and data
    vif.mcb.write   <= gp.is_write;
    vif.mcb.nposted <= bus_ext.is_nposted;
    vif.mcb.addr    <= (gp.get_address>>2);
    vif.mcb.wdata   <= wdata;
    `uvm_info(tID, $sformatf("Drive write address %x",  gp.get_address>>2 ), UVM_HIGH)
    `uvm_info(tID, $sformatf("Drive write data %x",     wdata ), UVM_HIGH)

    // Wait pvld delay
    repeat(ctrl_ext.get_pvld_delay()) begin
        @(vif.mcb);
    end

    // Drive pvld
    vif.mcb.pvld    <= 1;
    @(vif.mcb);

    while(!((vif.mcb.prdy === 1) && (vif.pvld === 1)))begin
        @(vif.mcb);
    end
    quiesce_bus();
    `uvm_info(tID, $sformatf("prdy asserted, quiesce bus"), UVM_HIGH)

    if(bus_ext.is_nposted()) begin
        // none_posted, wait write complete
        while(vif.mcb.wr_complete !== 1) begin
            @(vif.mcb);
        end
    end

    // Wait txn delay
    repeat(ctrl_ext.get_txn_delay()) begin
        @(vif.mcb);
    end
endtask : drive_write

task csb_driver::drive_read(uvm_tlm_gp gp);
    csb_bus_ext    bus_ext;
    csb_ctrl_ext   ctrl_ext;
    byte unsigned  rdata[];

    $cast(bus_ext,  gp.get_extension(csb_bus_ext::ID));
    $cast(ctrl_ext, gp.get_extension(csb_ctrl_ext::ID));

    // Drive read address and pollute data
    vif.mcb.write   <= gp.is_write;
    vif.mcb.nposted <= bus_ext.is_nposted;
    vif.mcb.addr    <= (gp.get_address>>2);
    vif.mcb.wdata   <= 'z;

    // Wait pvld delay
    repeat(ctrl_ext.get_pvld_delay()) begin
        @(vif.mcb);
    end

    // Drive pvld
    vif.mcb.pvld    <= 1;
    @(vif.mcb);

    while(!((vif.mcb.prdy === 1) && (vif.pvld === 1)))begin
        @(vif.mcb);
    end
    `uvm_info(tID, $sformatf("prdy asserted"), UVM_HIGH)
    // Release interface
    quiesce_bus();

    // Wait return data
    while(vif.mcb.rvld !== 1) begin
        @(vif.mcb);
    end
    rdata = {<<byte{vif.mcb.rdata}};
    gp.set_data(rdata);

    // Wait txn delay
    repeat(ctrl_ext.get_txn_delay()) begin
        @(vif.mcb);
    end
endtask : drive_read

`endif // _CSB_DRIVER_SV_
