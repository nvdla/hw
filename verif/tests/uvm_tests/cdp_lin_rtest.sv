`ifndef _CDP_LIN_RTEST_SV_
`define _CDP_LIN_RTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: cdp_lin_rtest 
//-------------------------------------------------------------------------------------

class cdp_lin_rtest_cdprdma_cdp_scenario extends nvdla_cdprdma_cdp_scenario ;
    function new(string name="cdp_lin_rtest_cdprdma_cdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    constraint sce_cdprdma_cdp_sim_constraint_for_user_extend{
        this.cdp.lut_le_function == nvdla_cdp_resource::lut_le_function_LINEAR;
    }
    `uvm_component_utils(cdp_lin_rtest_cdprdma_cdp_scenario)
endclass: cdp_lin_rtest_cdprdma_cdp_scenario

class cdp_lin_rtest extends nvdla_tg_base_test;

    function new(string name="cdp_lin_rtest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("cdp_lin_rtest");
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_config_db#()::get(this,"", "layers", layers);
        `uvm_info(inst_name,$sformatf("Layers = %0d ",layers),UVM_HIGH); 

        set_type_override_by_type(nvdla_cdprdma_cdp_scenario::get_type(), cdp_lin_rtest_cdprdma_cdp_scenario::get_type());
    endfunction: build_phase

    function override_scenario_pool();
         generator.delete_scenario_pool();
         generator.push_scenario_pool(SCE_CDPRDMA_CDP);
    endfunction: override_scenario_pool

    `uvm_component_utils(cdp_lin_rtest)
endclass : cdp_lin_rtest


`endif // _CDP_LIN_RTEST_SV_

