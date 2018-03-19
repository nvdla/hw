`ifndef _CSB_SEQ_LIB_SV_
`define _CSB_SEQ_LIB_SV_

//-------------------------------------------------------------------------------------
//
// File: csb_seq_lib
//
//-------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------
//
// CLASS: csb_basic_seq
//
//
//-------------------------------------------------------------------------------------

class csb_basic_seq extends uvm_sequence #(uvm_tlm_gp);
    string        tID = "CSB_BASIC_SEQ";
    uvm_tlm_gp    gp;
    csb_bus_ext   bus_ext;
    csb_ctrl_ext  ctrl_ext;
    byte unsigned wdata[];
    byte unsigned byte_en[];

    `uvm_object_utils_begin(csb_basic_seq)
    `uvm_object_utils_end

    // Function: new
    function new(string name = "csb_basic_seq");
        super.new(name);
        set_automatic_phase_objection(1);
    endfunction : new

    virtual task pre_body();
    endtask : pre_body

    virtual task body();
        repeat(10) begin
            `uvm_create(gp);
            bus_ext  = csb_bus_ext::type_id::create("bus_ext",,get_full_name());
            ctrl_ext = csb_ctrl_ext::type_id::create("ctrl_ext",,get_full_name());
            wdata    = new[`CSB_DATA_WIDTH/8];
            byte_en  = new[`CSB_DATA_WIDTH/8];
            foreach(byte_en[i]) begin
                byte_en[i] = 'hFF;
            end

            assert(bus_ext.randomize());
            assert(ctrl_ext.randomize());
            assert(randomize(wdata));
            assert(gp.randomize() with { m_command != UVM_TLM_IGNORE_COMMAND;});

            gp.set_data(wdata);
            gp.set_data_length(`CSB_DATA_WIDTH/8);
            gp.set_byte_enable(byte_en);
            gp.set_byte_enable_length(`CSB_DATA_WIDTH/8);
            gp.set_streaming_width(`CSB_DATA_WIDTH/8);
            gp.set_extension(bus_ext);
            gp.set_extension(ctrl_ext);

            `uvm_info(tID, $sformatf("Issue GP:\n%0s", gp.sprint()), UVM_MEDIUM)
            `uvm_send(gp);
        end

    endtask : body

    virtual task post_body();
    endtask : post_body

endclass : csb_basic_seq




`endif // _CSB_SEQ_LIB_SV_
