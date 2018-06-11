`ifndef _MULTI_SCENARIO_SV_
`define _MULTI_SCENARIO_SV_

//-------------------------------------------------------------------------------------
// CLASS: multi_scenario_rtest 
//-------------------------------------------------------------------------------------

class multi_scenario_rtest_cc_sdp_scenario extends nvdla_cc_sdp_scenario;
    function new(string name="multi_scenario_rtest_cc_sdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    constraint sce_cc_sdp_sim_constraint_for_user_extend {
        this.cdma.data_reuse        == nvdla_cdma_resource::data_reuse_DISABLE;
        this.cdma.weight_reuse      == nvdla_cdma_resource::weight_reuse_DISABLE;
        this.cdma.skip_data_rls     == nvdla_cdma_resource::skip_data_rls_DISABLE;
        this.cdma.skip_weight_rls   == nvdla_cdma_resource::skip_weight_rls_DISABLE;
    }
    `uvm_component_utils(multi_scenario_rtest_cc_sdp_scenario)
endclass: multi_scenario_rtest_cc_sdp_scenario

class multi_scenario_rtest_cc_sdp_pdp_scenario extends nvdla_cc_sdp_pdp_scenario;
    function new(string name="multi_scenario_rtest_cc_sdp_pdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    constraint sce_cc_sdp_pdp_sim_constraint_for_user_extend {
        this.cdma.data_reuse        == nvdla_cdma_resource::data_reuse_DISABLE;
        this.cdma.weight_reuse      == nvdla_cdma_resource::weight_reuse_DISABLE;
        this.cdma.skip_data_rls     == nvdla_cdma_resource::skip_data_rls_DISABLE;
        this.cdma.skip_weight_rls   == nvdla_cdma_resource::skip_weight_rls_DISABLE;
    }
    `uvm_component_utils(multi_scenario_rtest_cc_sdp_pdp_scenario)
endclass: multi_scenario_rtest_cc_sdp_pdp_scenario

class multi_scenario_rtest_cc_sdprdma_sdp_pdp_scenario extends nvdla_cc_sdprdma_sdp_pdp_scenario;
    function new(string name="multi_scenario_rtest_cc_sdprdma_sdp_pdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    constraint sce_cc_sdprdma_sdp_pdp_sim_constraint_for_user_extend {
        this.cdma.data_reuse        == nvdla_cdma_resource::data_reuse_DISABLE;
        this.cdma.weight_reuse      == nvdla_cdma_resource::weight_reuse_DISABLE;
        this.cdma.skip_data_rls     == nvdla_cdma_resource::skip_data_rls_DISABLE;
        this.cdma.skip_weight_rls   == nvdla_cdma_resource::skip_weight_rls_DISABLE;
    }
    `uvm_component_utils(multi_scenario_rtest_cc_sdprdma_sdp_pdp_scenario)
endclass: multi_scenario_rtest_cc_sdprdma_sdp_pdp_scenario

class multi_scenario_rtest_cc_sdprdma_sdp_scenario extends nvdla_cc_sdprdma_sdp_scenario;
    function new(string name="multi_scenario_rtest_cc_sdprdma_sdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    constraint sce_cc_sdprdma_sdp_sim_constraint_for_user_extend {
        this.cdma.data_reuse        == nvdla_cdma_resource::data_reuse_DISABLE;
        this.cdma.weight_reuse      == nvdla_cdma_resource::weight_reuse_DISABLE;
        this.cdma.skip_data_rls     == nvdla_cdma_resource::skip_data_rls_DISABLE;
        this.cdma.skip_weight_rls   == nvdla_cdma_resource::skip_weight_rls_DISABLE;
    }
    `uvm_component_utils(multi_scenario_rtest_cc_sdprdma_sdp_scenario)
endclass: multi_scenario_rtest_cc_sdprdma_sdp_scenario

class multi_scenario_rtest extends nvdla_tg_base_test;

    function new(string name="multi_scenario_rtest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("multi_scenario_rtest");
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_config_db#()::get(this,"", "layers", layers);
        `uvm_info(inst_name,$sformatf("Layers = %0d ",layers),UVM_HIGH); 

        set_type_override_by_type(nvdla_cc_sdp_scenario::get_type(), multi_scenario_rtest_cc_sdp_scenario::get_type());
        set_type_override_by_type(nvdla_cc_sdp_pdp_scenario::get_type(), multi_scenario_rtest_cc_sdp_pdp_scenario::get_type());
        set_type_override_by_type(nvdla_cc_sdprdma_sdp_scenario::get_type(), multi_scenario_rtest_cc_sdprdma_sdp_scenario::get_type());
        set_type_override_by_type(nvdla_cc_sdprdma_sdp_pdp_scenario::get_type(), multi_scenario_rtest_cc_sdprdma_sdp_pdp_scenario::get_type());
    endfunction: build_phase
    
    `uvm_component_utils(multi_scenario_rtest)
endclass : multi_scenario_rtest


`endif // _MULTI_SCENARIO_SV_

