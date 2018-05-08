`ifndef _CDP_CHANNEL_CTEST_SV_
`define _CDP_CHANNEL_CTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: cdp_channel_ctest 
//-------------------------------------------------------------------------------------

// This test is used to cover cdp cube channel ranges.
// see cp_cube_channel in nvdla_coverage_cdp.sv
//
// subtest must be set using cmdline "+uvm_set_config_int=*,subtest,<N>"

class cdp_channel_cdprdma_cdp_scenario extends nvdla_cdprdma_cdp_scenario ;
    localparam MIN = 0;
    localparam MAX = 'h1FFF;
    localparam N_SUBTESTS = 10;
    
    int subtest = 0;

    function new(string name="cdp_channel_cdprdma_cdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void pre_randomize();
        super.pre_randomize();
        if (!(subtest inside {[0:N_SUBTESTS-1]}))
            `uvm_fatal(get_name(), $sformatf("# Invalid subtest (%0d), valid range is [0:%0d]", subtest, N_SUBTESTS-1))

        `uvm_info(get_name(), $sformatf("# subtest = %0d", subtest), UVM_NONE)
    endfunction
    
    constraint sce_cdprdma_cdp_sim_constraint_for_user_extend {
        subtest == 0 -> this.cdp_rdma.channel == MIN;
        subtest == 1 -> this.cdp_rdma.channel inside {['h0001:'h03ff]};
        subtest == 2 -> this.cdp_rdma.channel inside {['h0400:'h07ff]};
        subtest == 3 -> this.cdp_rdma.channel inside {['h0800:'h0bff]};
        subtest == 4 -> this.cdp_rdma.channel inside {['h0c00:'h0fff]};
        subtest == 5 -> this.cdp_rdma.channel inside {['h1000:'h13ff]};
        subtest == 6 -> this.cdp_rdma.channel inside {['h1400:'h17ff]};
        subtest == 7 -> this.cdp_rdma.channel inside {['h1800:'h1bff]};
        subtest == 8 -> this.cdp_rdma.channel inside {['h1c00:'h1ffe]};
        subtest == 9 -> this.cdp_rdma.channel == MAX;            
    }

    `uvm_component_utils_begin(cdp_channel_cdprdma_cdp_scenario)
        `uvm_field_int(subtest, UVM_DEFAULT)
    `uvm_component_utils_end        
endclass: cdp_channel_cdprdma_cdp_scenario

class cdp_channel_ctest extends nvdla_tg_base_test;
    function new(string name="cdp_channel_ctest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("cdp_channel_ctest");
    endfunction : new
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        set_type_override_by_type(nvdla_cdprdma_cdp_scenario::get_type(), cdp_channel_cdprdma_cdp_scenario::get_type());
    endfunction: build_phase

    function override_scenario_pool();
        generator.delete_scenario_pool();
        generator.push_scenario_pool(SCE_CDPRDMA_CDP);
    endfunction: override_scenario_pool

    `uvm_component_utils_begin(cdp_channel_ctest)
    `uvm_component_utils_end
endclass : cdp_channel_ctest

`endif
