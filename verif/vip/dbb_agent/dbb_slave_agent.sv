`ifndef NVDLA_DBB_SLAVE_AGENT__SV
`define NVDLA_DBB_SLAVE_AGENT__SV

//-------------------------------------------------------------------------------------
//
// CLASS: dbb_agent
//
// The dbb_agent is a slave agent, which used to hook up to DLA primary/secondary
// memory interface. The driver/sequencer/monitor components are created & connected
// in the class. The dbb_agent supports both active and passive mode. All driver/
// sequencer/monitor arr avaliable in active mode and only monitor is avaliable in
// passive mode.
//-------------------------------------------------------------------------------------
/// Default slave sequence which continuously generates transaction objects for the
/// slave driver.
class dbb_slave_default_seq#(int MEM_DATA_WIDTH=512) extends uvm_sequence #(uvm_tlm_gp);
    uvm_tlm_gp tr;

    `uvm_object_param_utils(dbb_slave_default_seq#(MEM_DATA_WIDTH));

    virtual task body();
        /// Just repeat forever in the background. The slave always needs immediate access
        /// to a ready transaction, so this is safest.
        forever begin
            dbb_ctrl_ext tr_ctrl;
            dbb_helper_ext tr_helper;
            tr = create_new_gp();
            start_item(tr);
            `CAST_DBB_EXT(,tr,ctrl)
            `CAST_DBB_EXT(,tr,helper)
            tr.randomize() with {
            };
            tr_ctrl.randomize() with {
              //address_rvalid_delay inside {[20:30]};
              //foreach (resp[idx]) resp[idx] == dbb_ctrl_ext#()::OKAY;
            };
            finish_item(tr);
        end
    endtask: body

    function new(string name="dbb_slave_default_seq");
        super.new(name);
    endfunction

    function uvm_tlm_gp create_new_gp();
        uvm_tlm_gp   gp;
        dbb_bus_ext  bus_ext;
        dbb_ctrl_ext ctrl_ext;
        dbb_helper_ext helper_ext;
        byte unsigned p[] = new[1];
        byte unsigned q[] = new[1];

        gp       = uvm_tlm_gp::type_id::create();
        bus_ext  = new();
        ctrl_ext = new();
        helper_ext = dbb_helper_ext::type_id::create();

        gp.set_extension(bus_ext);
        gp.set_extension(ctrl_ext);
        gp.set_extension(helper_ext);

        gp.set_data(p);
        gp.set_byte_enable(q);
        gp.set_data_length(1);
        gp.set_byte_enable_length(1);
        gp.set_streaming_width(1);


        return gp;
    endfunction : create_new_gp

endclass: dbb_slave_default_seq

typedef class dbb_bus_object;

/// nvdla UVM DBB Slave Agent. This agent contains an DBB Slave driver, monitor, and sequencer.
/// An DBB virtual interface must be specified at build time, or an error occurs.
class dbb_slave_agent#(int MEM_DATA_WIDTH=512) extends uvm_agent;
    string                              tID;

    dbb_slave_seq                 slv_sqr;        ///< nvdla DBB Slave Sequencer
    dbb_slave_driver#(MEM_DATA_WIDTH)  slv_drv;        ///< nvdla DBB Slave Driver
    dbb_monitor#(MEM_DATA_WIDTH)       slv_mon;        ///< nvdla DBB Monitor


    typedef virtual dbb_interface#(MEM_DATA_WIDTH) vif;
    vif slv_if;                     ///< DBB Virtual interface.

    //---------------------------- CONFIGURATION PARAMETERS --------------------------------
    /// @name Configuration Parameters
    /// @{
    // agent active/passive mode control
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    /// Socket for external synchronization
    uvm_tlm_b_passthrough_initiator_socket  tlm_socket; ///< TLM socket used for external sync mode

    /// Defines the width of the data bus for this agent. If set, will configure the
    /// driver and monitor to match.
    int data_bus_width = MEM_DATA_WIDTH;
    /// Flag to not create a default slave sequence.
    bit no_default_sequence = 0;

    /// Set this to turn off the DBB assertions in the interface.  By default they are
    /// turned on.
    int disable_dbb_assertions = 0;
    /// @}
    
    `uvm_component_param_utils_begin(dbb_slave_agent#(MEM_DATA_WIDTH))
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
        `uvm_field_int(data_bus_width,              UVM_DEFAULT)
        `uvm_field_int(no_default_sequence,         UVM_DEFAULT)
        `uvm_field_int(disable_dbb_assertions,  UVM_ALL_ON)
    `uvm_component_utils_end

    ////////////////////////////////////////////////////////////////////////////////
    /// Create a new DBB slave agent.
    function new(string name = "dbb_slave_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    ////////////////////////////////////////////////////////////////////////////////
    /// This function is run automatically during the UVM build phase. It will check
    /// for the existance of a virtual interface, and report an error if one has not
    /// been specified.
    ///
    /// If the agent is not set to UVM_ACTIVE, then only the monitor will be created,
    /// and it will function in a purely passive mode.
    virtual function void build_phase(uvm_phase phase);
        bit slv_mon_has_mon_socket;

        super.build_phase(phase);
        tID = get_type_name().toupper();
        uvm_config_int::get(this,"","data_bus_width",data_bus_width);
        uvm_config_int::get(this,"","no_default_sequence",no_default_sequence);
        uvm_config_int::get(this,"","disable_dbb_assertions",disable_dbb_assertions);

        // Check to make sure we have an virtual interface specified for the agent.
        if (!uvm_config_db#(vif)::get(this, "", "slv_if", slv_if)) begin
            `uvm_fatal("NVDLA/DBB/SLV/AGENT/NOVIF", "No virtual interface specified for this agent instance")
        end
        else begin
            // Configure driver and monitor to use the agent interface
            uvm_config_db#(vif)::set(this,"slv_mon","mon_if",slv_if);
        end

        // Enable assertions according to the agent configuration.
        slv_if.en_dbb_assrt = ( !disable_dbb_assertions );

        // Create monitor, sequencer and driver
        uvm_config_int::set(this,"slv_mon","data_bus_width",data_bus_width);
        slv_mon = dbb_monitor#(MEM_DATA_WIDTH)::type_id::create("slv_mon", this);

        // Build the monitor's TLM adapter if it is in has_mon_socket mode.
        uvm_config_db#(bit)::get( this, "slv_mon", "has_mon_socket", slv_mon_has_mon_socket );

        if (is_active == UVM_ACTIVE) begin
            uvm_config_int::set(this,"slv_drv","data_bus_width",data_bus_width);
            uvm_config_db#(vif)::set(this,"slv_drv","drv_if",slv_if);
            slv_sqr = dbb_slave_seq::type_id::create("slv_sqr", this);
            slv_drv = dbb_slave_driver#(MEM_DATA_WIDTH)::type_id::create("slv_drv", this);

            // Set up a default slave sequence
            if (!no_default_sequence)
                uvm_config_db#(uvm_object_wrapper)::set(this,"slv_sqr.run_phase","default_sequence",dbb_slave_default_seq#(MEM_DATA_WIDTH)::type_id::get());
        end
                                   
    endfunction: build_phase
    
    ////////////////////////////////////////////////////////////////////////////////
    /// This function is run automatically during the UVM connect phase. It will
    /// automatically connect the sequencer export to the driver port.
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_LOW)

        if (is_active == UVM_ACTIVE) begin
            slv_drv.seq_item_port.connect(slv_sqr.seq_item_export);
        end
    endfunction

    ////////////////////////////////////////////////////////////////////////////////
    /// This task is run automatically during the UVM run phase.
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask

    ////////////////////////////////////////////////////////////////////////////////
    /// This function is run automatically during the UVM report phase.
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
    endfunction

///Creates the dbb bus object
    virtual function dbb_bus_object create_generic_object(string name);
           create_generic_object= dbb_bus_object#()::type_id::create(name, this);
	   endfunction: create_generic_object



endclass: dbb_slave_agent

`endif // NVDLA_DBB_SLAVE_AGENT__SV
