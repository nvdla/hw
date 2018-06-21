`ifndef _CC_IN_CHANNEL_CTEST_SV_
`define _CC_IN_CHANNEL_CTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: cc_in_channel 
//-------------------------------------------------------------------------------------

class cc_in_channel_scenario extends nvdla_cc_sdp_scenario;
    localparam MIN = 0;
    localparam MAX = 'h1FFF;
    localparam N_SUBTESTS = 10;
    
    int subtest = 0;

    function new(string name="cc_in_channel_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void pre_randomize();
        super.pre_randomize();
        if (!(subtest inside {[0:N_SUBTESTS-1]}))
            `uvm_fatal(get_name(), $sformatf("# Invalid subtest (%0d), valid range is [0:%0d]", subtest, N_SUBTESTS-1))

        `uvm_info(get_name(), $sformatf("# subtest = %0d", subtest), UVM_NONE)

//      if (subtest > 2) this.cdma.cc_input_cube_size = "large";
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

        subtest == 0 -> this.cdma.datain_channel == MIN;
        subtest == 1 -> this.cdma.datain_channel inside {['h0001:'h03ff]};
        subtest == 2 -> this.cdma.datain_channel inside {['h0400:'h07fe]};
        subtest == 3 -> this.cdma.datain_channel inside {['h07ff:'h0bfd]};
        subtest == 4 -> this.cdma.datain_channel inside {['h0bfe:'h0ffc]};
        subtest == 5 -> this.cdma.datain_channel inside {['h0ffd:'h13fb]};
        subtest == 6 -> this.cdma.datain_channel inside {['h13fc:'h17fa]};
        subtest == 7 -> this.cdma.datain_channel inside {['h17fb:'h1bf9]};
        subtest == 8 -> this.cdma.datain_channel inside {['h1bfa:'h1ffe]};
        subtest == 9 -> this.cdma.datain_channel == MAX;            
    }

    `uvm_component_utils_begin(cc_in_channel_scenario)
        `uvm_field_int(subtest, UVM_DEFAULT)
    `uvm_component_utils_end            
endclass: cc_in_channel_scenario

class cc_in_channel_ctest extends nvdla_tg_base_test;

    function new(string name="cc_in_channel_ctest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("cc_in_channel_ctest");
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        set_type_override_by_type(nvdla_cc_sdp_scenario::get_type(), cc_in_channel_scenario::get_type());
    endfunction: build_phase

    function override_scenario_pool();
         generator.delete_scenario_pool();
         generator.push_scenario_pool(SCE_CC_SDP);
    endfunction: override_scenario_pool

    `uvm_component_utils(cc_in_channel_ctest)
endclass : cc_in_channel_ctest

`endif

