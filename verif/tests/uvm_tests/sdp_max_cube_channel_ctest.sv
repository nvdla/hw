`ifndef _SDP_MAX_CUBE_CHANNEL_CTEST_SV_
`define _SDP_MAX_CUBE_CHANNEL_CTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: sdp_max_cube_channel_ctest 
//-------------------------------------------------------------------------------------

class sdp_max_cube_channel_sdprdma_sdp_scenario extends nvdla_sdprdma_sdp_scenario ;
    function new(string name="sdp_max_cube_channel_sdprdma_sdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    constraint sec_sdprdma_sdp_sim_constraint_for_user_extend {
        this.sdp.flying_mode     == nvdla_sdp_resource::flying_mode_OFF;
        this.sdp.output_dst      == nvdla_sdp_resource::output_dst_MEM;
        this.sdp.channel         == 'h1fff;
    }
    `uvm_component_utils(sdp_max_cube_channel_sdprdma_sdp_scenario)
endclass: sdp_max_cube_channel_sdprdma_sdp_scenario

class sdp_max_cube_channel_ctest extends nvdla_tg_base_test;

    function new(string name="sdp_max_cube_channel_ctest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("sdp_max_cube_channel_ctest");
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_config_db#()::get(this,"", "layers", layers);
        `uvm_info(inst_name,$sformatf("Layers = %0d ",layers),UVM_HIGH); 

        uvm_config_db#(string)::set(this, "*", "sdp_cube_size", "large");
        
        set_type_override_by_type(nvdla_sdprdma_sdp_scenario::get_type(), sdp_max_cube_channel_sdprdma_sdp_scenario::get_type());
    endfunction: build_phase

    function override_scenario_pool();
         generator.delete_scenario_pool();
         generator.push_scenario_pool(SCE_SDPRDMA_SDP);
    endfunction: override_scenario_pool

    `uvm_component_utils(sdp_max_cube_channel_ctest)
endclass : sdp_max_cube_channel_ctest

`endif

