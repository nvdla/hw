`ifndef _PDP_MAX_CUBE_IN_WIDTH_CTEST_SV_
`define _PDP_MAX_CUBE_IN_WIDTH_CTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: pdp_max_cube_in_width_ctest 
//-------------------------------------------------------------------------------------

class pdp_max_cube_in_width_pdprdma_pdp_scenario extends nvdla_pdprdma_pdp_scenario ;
    function new(string name="pdp_max_cube_in_width_pdprdma_pdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    constraint sce_pdprdma_pdp_sim_constraint_for_user_extend{
        this.pdp.flying_mode == nvdla_pdp_resource::flying_mode_OFF_FLYING;
        this.pdp.cube_in_width == 'h1fff;
    }
    `uvm_component_utils(pdp_max_cube_in_width_pdprdma_pdp_scenario)
endclass: pdp_max_cube_in_width_pdprdma_pdp_scenario

class pdp_max_cube_in_width_ctest extends nvdla_tg_base_test;

    function new(string name="pdp_max_cube_in_width_ctest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("pdp_max_cube_in_width_ctest");
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_config_db#()::get(this,"", "layers", layers);
        `uvm_info(inst_name,$sformatf("Layers = %0d ",layers),UVM_HIGH); 

        uvm_config_db#(string)::set(this, "*", "pdp_input_cube_size", "large");
        
        set_type_override_by_type(nvdla_pdprdma_pdp_scenario::get_type(), pdp_max_cube_in_width_pdprdma_pdp_scenario::get_type());
    endfunction: build_phase

    function override_scenario_pool();
         generator.delete_scenario_pool();
         generator.push_scenario_pool(SCE_PDPRDMA_PDP);
    endfunction: override_scenario_pool

    `uvm_component_utils(pdp_max_cube_in_width_ctest)
endclass : pdp_max_cube_in_width_ctest


`endif

