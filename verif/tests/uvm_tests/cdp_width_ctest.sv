`ifndef _CDP_WIDTH_CTEST_SV_
`define _CDP_WIDTH_CTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: cdp_width_ctest 
//-------------------------------------------------------------------------------------

// This test is used to cover cdp cube width ranges.
// see cp_cube_width in nvdla_coverage_cdp.sv
//
// subtest must be set using cmdline "+uvm_set_config_int=*,subtest,<N>"

class cdp_width_cdprdma_cdp_scenario extends nvdla_cdprdma_cdp_scenario ;
    localparam MIN = 0;
    localparam MAX = 'h1FFF;
    localparam N_SUBTESTS = 10;
    
    int subtest = 0;

    function new(string name="cdp_width_cdprdma_cdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void pre_randomize();
        super.pre_randomize();
        if (!(subtest inside {[0:N_SUBTESTS-1]}))
            `uvm_fatal(get_name(), $sformatf("# Invalid subtest (%0d), valid range is [0:%0d]", subtest, N_SUBTESTS-1))

        `uvm_info(get_name(), $sformatf("# subtest = %0d", subtest), UVM_NONE)
    endfunction
    
    constraint sce_cdprdma_cdp_sim_constraint_for_user_extend {
        subtest == 0 -> this.cdp_rdma.width == MIN;
        subtest == 1 -> this.cdp_rdma.width inside {['h0001:'h03ff]};
        subtest == 2 -> this.cdp_rdma.width inside {['h0400:'h07fe]};
        subtest == 3 -> this.cdp_rdma.width inside {['h07ff:'h0bfd]};
        subtest == 4 -> this.cdp_rdma.width inside {['h0bfe:'h0ffc]};
        subtest == 5 -> this.cdp_rdma.width inside {['h0ffd:'h13fb]};
        subtest == 6 -> this.cdp_rdma.width inside {['h13fc:'h17fa]};
        subtest == 7 -> this.cdp_rdma.width inside {['h17fb:'h1bf9]};
        subtest == 8 -> this.cdp_rdma.width inside {['h1bfa:'h1ffe]};
        subtest == 9 -> this.cdp_rdma.width == MAX;            
    }

    `uvm_component_utils_begin(cdp_width_cdprdma_cdp_scenario)
        `uvm_field_int(subtest, UVM_DEFAULT)
    `uvm_component_utils_end        
endclass: cdp_width_cdprdma_cdp_scenario

class cdp_width_ctest extends nvdla_tg_base_test;
    function new(string name="cdp_width_ctest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("cdp_width_ctest");
    endfunction : new
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        set_type_override_by_type(nvdla_cdprdma_cdp_scenario::get_type(), cdp_width_cdprdma_cdp_scenario::get_type());
    endfunction: build_phase

    function override_scenario_pool();
        generator.delete_scenario_pool();
        generator.push_scenario_pool(SCE_CDPRDMA_CDP);
    endfunction: override_scenario_pool

    `uvm_component_utils_begin(cdp_width_ctest)
    `uvm_component_utils_end
endclass : cdp_width_ctest

`endif
