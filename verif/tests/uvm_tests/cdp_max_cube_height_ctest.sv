`ifndef _CDP_MAX_CUBE_HEIGHT_CTEST_SV_
`define _CDP_MAX_CUBE_HEIGHT_CTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: cdp_max_cube_height 
//-------------------------------------------------------------------------------------

class cdp_max_cube_height_cdprdma_cdp_scenario extends nvdla_cdprdma_cdp_scenario ;
    function new(string name="cdp_max_cube_height_cdprdma_cdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    constraint sce_cdprdma_cdp_sim_constraint_for_user_extend {
        this.cdp_rdma.height == 'h1fff;
    }

    `uvm_component_utils(cdp_max_cube_height_cdprdma_cdp_scenario)
endclass: cdp_max_cube_height_cdprdma_cdp_scenario

class cdp_max_cube_height_ctest extends nvdla_tg_base_test;

    function new(string name="cdp_max_cube_height_ctest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("cdp_max_cube_height_ctest");
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_config_db#()::get(this,"", "layers", layers);
        `uvm_info(inst_name,$sformatf("Layers = %0d ",layers),UVM_HIGH); 

        uvm_config_db#(string)::set(this, "*", "cdp_cube_size", "large");
        
        set_type_override_by_type(nvdla_cdprdma_cdp_scenario::get_type(), cdp_max_cube_height_cdprdma_cdp_scenario::get_type());
    endfunction: build_phase

    function override_scenario_pool();
         generator.delete_scenario_pool();
         generator.push_scenario_pool(SCE_CDPRDMA_CDP);
    endfunction: override_scenario_pool

    `uvm_component_utils(cdp_max_cube_height_ctest)
endclass : cdp_max_cube_height_ctest

`endif

