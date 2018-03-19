`ifndef _SDPRDMA_SDP_PDP_RTEST_SV_
`define _SDPRDMA_SDP_PDP_RTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: sdprdma_sdp_pdp_rtest 
//-------------------------------------------------------------------------------------

class sdprdma_sdp_pdp_rtest_sdprdma_sdp_pdp_scenario extends nvdla_sdprdma_sdp_pdp_scenario;
    function new(string name="sdprdma_sdp_pdp_rtest_sdprdma_sdp_pdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    constraint sce_sdprdma_sdp_pdp_sim_constraint_for_user_extend {}
    `uvm_component_utils(sdprdma_sdp_pdp_rtest_sdprdma_sdp_pdp_scenario)
endclass: sdprdma_sdp_pdp_rtest_sdprdma_sdp_pdp_scenario

class sdprdma_sdp_pdp_rtest extends nvdla_tg_base_test;

    function new(string name="sdprdma_sdp_pdp_rtest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("sdprdma_sdp_pdp_rtest");
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_config_db#()::get(this,"", "layers", layers);
        `uvm_info(inst_name,$sformatf("Layers = %0d ",layers),UVM_HIGH); 

        set_type_override_by_type(nvdla_sdprdma_sdp_pdp_scenario::get_type(), sdprdma_sdp_pdp_rtest_sdprdma_sdp_pdp_scenario::get_type());
    endfunction: build_phase
    
    function override_scenario_pool();
         generator.delete_scenario_pool();
         generator.push_scenario_pool(SCE_SDPRDMA_SDP_PDP);
    endfunction: override_scenario_pool

    `uvm_component_utils(sdprdma_sdp_pdp_rtest)
endclass : sdprdma_sdp_pdp_rtest

`endif // _SDPRDMA_SDP_PDP_RTEST_SV_

