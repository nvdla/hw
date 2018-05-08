`ifndef _SDP_CHANNEL_CTEST_SV_
`define _SDP_CHANNEL_CTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: sdp_channel_ctest 
//-------------------------------------------------------------------------------------

// This test is used to cover cross between flying_mode and channel value range.
// see cr_channel_flying_mode in nvdla_coverage_sdp.sv
//
// subtest must be set using cmdline "+uvm_set_config_int=*,subtest,<N>"
// flying_mode must be set using cmdline "+uvm_set_config_string=*,flying_mode,<string>"

class sdp_channel_ctest_sdp_resource extends nvdla_sdp_resource;
    localparam MIN = 0;
    localparam MAX = 'h1FFF;
    localparam N_SUBTESTS = 10;
    
    int subtest = 0;
    
    function new(string name="sdp_resource", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void pre_randomize();
        super.pre_randomize();
        if (!(subtest inside {[0:N_SUBTESTS-1]}))
            `uvm_fatal(get_name(), $sformatf("# Invalid subtest (%0d), valid range is [0:%0d]", subtest, N_SUBTESTS-1))

        `uvm_info(get_name(), $sformatf("# subtest = %0d", subtest), UVM_NONE)
    endfunction

    constraint c_user_extend {
        subtest == 0 -> this.channel == MIN;
        subtest == 1 -> this.channel inside {['h0001:'h03ff]};
        subtest == 2 -> this.channel inside {['h0400:'h07fe]};
        subtest == 3 -> this.channel inside {['h07ff:'h0bfd]};
        subtest == 4 -> this.channel inside {['h0bfe:'h0ffc]};
        subtest == 5 -> this.channel inside {['h0ffd:'h13fb]};
        subtest == 6 -> this.channel inside {['h13fc:'h17fa]};
        subtest == 7 -> this.channel inside {['h17fb:'h1bf9]};
        subtest == 8 -> this.channel inside {['h1bfa:'h1ffe]};
        subtest == 9 -> this.channel == MAX;            
    }
                                                               
    `uvm_component_utils_begin(sdp_channel_ctest_sdp_resource)
        `uvm_field_int(subtest, UVM_DEFAULT)
    `uvm_component_utils_end
endclass

class sdp_channel_ctest extends nvdla_tg_base_test;
    string flying_mode;
    
    function new(string name="sdp_channel_ctest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("sdp_channel_ctest");
    endfunction : new
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        set_type_override_by_type(nvdla_sdp_resource::get_type(), sdp_channel_ctest_sdp_resource::get_type());
    endfunction: build_phase

    function override_scenario_pool();
        generator.delete_scenario_pool();
        if (flying_mode == "flying_mode_OFF")
            generator.push_scenario_pool(SCE_SDPRDMA_SDP);
        else if (flying_mode == "flying_mode_ON")
            generator.push_scenario_pool(SCE_CC_SDPRDMA_SDP);
        else
            `uvm_fatal(get_name(), $sformatf("Invalid flying_mode (%s), valid are flying_mode_ON and flying_mode_OFF", flying_mode))
    endfunction: override_scenario_pool

    `uvm_component_utils_begin(sdp_channel_ctest)
        `uvm_field_string(flying_mode, UVM_DEFAULT)
    `uvm_component_utils_end
endclass : sdp_channel_ctest

`endif

