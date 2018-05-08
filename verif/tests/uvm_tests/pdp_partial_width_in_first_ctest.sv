`ifndef _PDP_PARTIAL_WIDTH_IN_FIRST_CTEST_SV_
`define _PDP_PARTIAL_WIDTH_IN_FIRST_CTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: pdp_partial_width_in_first_ctest 
//-------------------------------------------------------------------------------------

class pdp_partial_width_in_first_pdprdma_pdp_scenario extends nvdla_pdprdma_pdp_scenario ;
    localparam MIN = 0;
    localparam MAX = 'h3FF;
    localparam N_SUBTESTS = 10;
    
    int subtest = 0;

    function new(string name="pdp_partial_width_in_first_pdprdma_pdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void pre_randomize();
        super.pre_randomize();
        if (!(subtest inside {[0:N_SUBTESTS-1]}))
            `uvm_fatal(get_name(), $sformatf("# Invalid subtest (%0d), valid range is [0:%0d]", subtest, N_SUBTESTS-1))

        `uvm_info(get_name(), $sformatf("# subtest = %0d", subtest), UVM_NONE)
    endfunction

    constraint sce_pdprdma_pdp_sim_constraint_for_user_extend {
        this.pdp.flying_mode == nvdla_pdp_resource::flying_mode_OFF_FLYING;
        this.pdp_rdma.split_num > 0;

        subtest == 0 -> this.pdp.partial_width_in_first == MIN;
        subtest == 1 -> this.pdp.partial_width_in_first inside {['h001:'h07f]};
        subtest == 2 -> this.pdp.partial_width_in_first inside {['h080:'h0ff]};
        subtest == 3 -> this.pdp.partial_width_in_first inside {['h100:'h17f]};
        subtest == 4 -> this.pdp.partial_width_in_first inside {['h180:'h1ff]};
        subtest == 5 -> this.pdp.partial_width_in_first inside {['h200:'h27f]};
        subtest == 6 -> this.pdp.partial_width_in_first inside {['h280:'h2ff]};
        subtest == 7 -> this.pdp.partial_width_in_first inside {['h300:'h37f]};
        subtest == 8 -> this.pdp.partial_width_in_first inside {['h380:'h3fe]};
        subtest == 9 -> this.pdp.partial_width_in_first == MAX;
    }

    `uvm_component_utils_begin(pdp_partial_width_in_first_pdprdma_pdp_scenario)
        `uvm_field_int(subtest, UVM_DEFAULT)
    `uvm_component_utils_end
endclass: pdp_partial_width_in_first_pdprdma_pdp_scenario

class pdp_partial_width_in_first_ctest extends nvdla_tg_base_test;
    function new(string name="pdp_partial_width_in_first_ctest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("pdp_partial_width_in_first_ctest");
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

//      uvm_config_db#(string)::set(this, "*", "pdp_input_cube_size", "large");
        set_type_override_by_type(nvdla_pdprdma_pdp_scenario::get_type(), pdp_partial_width_in_first_pdprdma_pdp_scenario::get_type());
    endfunction: build_phase

    function override_scenario_pool();
        generator.delete_scenario_pool();
        generator.push_scenario_pool(SCE_PDPRDMA_PDP);
    endfunction: override_scenario_pool

    `uvm_component_utils(pdp_partial_width_in_first_ctest)
endclass : pdp_partial_width_in_first_ctest

`endif

