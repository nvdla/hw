`ifndef _CC_IN_HEIGHT_CTEST_SV_
`define _CC_IN_HEIGHT_CTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: cc_in_height 
//-------------------------------------------------------------------------------------

class cc_in_height_scenario extends nvdla_cc_sdp_scenario;
    localparam MIN = 0;
    localparam MAX = 'hEFF; // 4K due to CBUF limitation
    localparam N_SUBTESTS = 10;
    
    int subtest = 0;

    function new(string name="cc_in_height_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void pre_randomize();
        super.pre_randomize();
        if (!(subtest inside {[0:N_SUBTESTS-1]}))
            `uvm_fatal(get_name(), $sformatf("# Invalid subtest (%0d), valid range is [0:%0d]", subtest, N_SUBTESTS-1))

        `uvm_info(get_name(), $sformatf("# subtest = %0d", subtest), UVM_NONE)
    endfunction
    
    constraint sce_cc_sdp_sim_constraint_for_user_extend {
        this.cdma.data_reuse        == nvdla_cdma_resource::data_reuse_DISABLE;
        this.cdma.weight_reuse      == nvdla_cdma_resource::weight_reuse_DISABLE;
        this.cdma.skip_data_rls     == nvdla_cdma_resource::skip_data_rls_DISABLE;
        this.cdma.skip_weight_rls   == nvdla_cdma_resource::skip_weight_rls_DISABLE;
        this.cdma.datain_format     == nvdla_cdma_resource::datain_format_FEATURE;

        this.sdp.bs_bypass          == nvdla_sdp_resource::bs_bypass_YES;
        this.sdp.bn_bypass          == nvdla_sdp_resource::bn_bypass_YES;
        this.sdp.flying_mode        == nvdla_sdp_resource::flying_mode_ON;
        this.sdp.output_dst         == nvdla_sdp_resource::output_dst_MEM;

        this.sdp.cvt_offset         == 0;
        this.sdp.cvt_scale          == 1;
        this.sdp.cvt_shift          == 0;

        subtest == 0 -> this.cdma.datain_height == MIN;
        subtest == 1 -> this.cdma.datain_height inside {['h001:'h1df]};
        subtest == 2 -> this.cdma.datain_height inside {['h1e0:'h3be]};
        subtest == 3 -> this.cdma.datain_height inside {['h3bf:'h59d]};
        subtest == 4 -> this.cdma.datain_height inside {['h59e:'h77c]};
        subtest == 5 -> this.cdma.datain_height inside {['h77d:'h95b]};
        subtest == 6 -> this.cdma.datain_height inside {['h95c:'hb3a]};
        subtest == 7 -> this.cdma.datain_height inside {['hb3b:'hd19]};
        subtest == 8 -> this.cdma.datain_height inside {['hd1a:'hefe]};
        subtest == 9 -> this.cdma.datain_height == MAX;            
    }

    `uvm_component_utils_begin(cc_in_height_scenario)
        `uvm_field_int(subtest, UVM_DEFAULT)
    `uvm_component_utils_end            
endclass: cc_in_height_scenario

class cc_in_height_ctest extends nvdla_tg_base_test;

    function new(string name="cc_in_height_ctest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("cc_in_height_ctest");
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        set_type_override_by_type(nvdla_cc_sdp_scenario::get_type(), cc_in_height_scenario::get_type());
    endfunction: build_phase

    function override_scenario_pool();
         generator.delete_scenario_pool();
         generator.push_scenario_pool(SCE_CC_SDP);
    endfunction: override_scenario_pool

    `uvm_component_utils(cc_in_height_ctest)
endclass : cc_in_height_ctest

`endif

