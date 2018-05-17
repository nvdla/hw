`ifndef _PDP_OUT_HEIGHT_CTEST_SV_
`define _PDP_OUT_HEIGHT_CTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: pdp_out_height_ctest 
//-------------------------------------------------------------------------------------

// This test is used to cover pdp output cube height ranges.
// see cp_cube_out_height in nvdla_coverage_pdp.sv
//
// subtest must be set using cmdline "+uvm_set_config_int=*,subtest,<N>"

class pdp_out_height_pdprdma_pdp_scenario extends nvdla_pdprdma_pdp_scenario ;
    localparam MIN = 0;
    localparam MAX = 'h1FFF;
    localparam N_SUBTESTS = 10;
    
    int subtest = 0;

    function new(string name="pdp_out_height_pdprdma_pdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void pre_randomize();
        super.pre_randomize();
        if (!(subtest inside {[0:N_SUBTESTS-1]}))
            `uvm_fatal(get_name(), $sformatf("# Invalid subtest (%0d), valid range is [0:%0d]", subtest, N_SUBTESTS-1))

        `uvm_info(get_name(), $sformatf("# subtest = %0d", subtest), UVM_NONE)

        if (subtest > 2) this.pdp.pdp_input_cube_size = "large";
    endfunction
    
    constraint sce_pdprdma_pdp_sim_constraint_for_user_extend {
        this.pdp.flying_mode == nvdla_pdp_resource::flying_mode_OFF_FLYING;

        subtest == 0 -> this.pdp.cube_out_height == MIN;
        subtest == 1 -> this.pdp.cube_out_height inside {['h0001:'h03ff]};
        subtest == 2 -> this.pdp.cube_out_height inside {['h0400:'h07ff]};
        subtest == 3 -> this.pdp.cube_out_height inside {['h0800:'h0bff]};
        subtest == 4 -> this.pdp.cube_out_height inside {['h0c00:'h0fff]};
        subtest == 5 -> this.pdp.cube_out_height inside {['h1000:'h13ff]};
        subtest == 6 -> this.pdp.cube_out_height inside {['h1400:'h17ff]};
        subtest == 7 -> this.pdp.cube_out_height inside {['h1800:'h1bff]};
        subtest == 8 -> this.pdp.cube_out_height inside {['h1c00:'h1ffe]};
        subtest == 9 -> this.pdp.cube_out_height == MAX;            
    }

    `uvm_component_utils_begin(pdp_out_height_pdprdma_pdp_scenario)
        `uvm_field_int(subtest, UVM_DEFAULT)
    `uvm_component_utils_end        
endclass: pdp_out_height_pdprdma_pdp_scenario

class pdp_out_height_ctest extends nvdla_tg_base_test;
    function new(string name="pdp_out_height_ctest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("pdp_out_height_ctest");
    endfunction : new
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        set_type_override_by_type(nvdla_pdprdma_pdp_scenario::get_type(), pdp_out_height_pdprdma_pdp_scenario::get_type());
    endfunction: build_phase

    function override_scenario_pool();
        generator.delete_scenario_pool();
        generator.push_scenario_pool(SCE_PDPRDMA_PDP);
    endfunction: override_scenario_pool

    `uvm_component_utils_begin(pdp_out_height_ctest)
    `uvm_component_utils_end
endclass : pdp_out_height_ctest

`endif

