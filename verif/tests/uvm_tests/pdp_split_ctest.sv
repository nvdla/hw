`ifndef _PDP_SPLIT_CTEST_SV_
`define _PDP_SPLIT_CTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: pdp_split_ctest 
//-------------------------------------------------------------------------------------

class pdp_split_ctest_pdprdma_pdp_scenario extends nvdla_pdprdma_pdp_scenario ;
    function new(string name="pdp_split_ctest_pdprdma_pdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    constraint sce_pdprdma_pdp_sim_constraint_for_user_extend{
        this.pdp.flying_mode   == nvdla_pdp_resource::flying_mode_OFF_FLYING;
        this.pdp.cube_in_width >= 'h400;
        this.pdp.kernel_stride_width inside {[0:4]};
        this.pdp.partial_width_out_first >= 'h40;
        this.pdp.partial_width_out_mid   >= 'h40;
        this.pdp.partial_width_out_last  >= 'h40;
        this.pdp.split_num   dist {[1:2]:/80, [3:6]:/20};
    }
    `uvm_component_utils(pdp_split_ctest_pdprdma_pdp_scenario)
endclass: pdp_split_ctest_pdprdma_pdp_scenario

class pdp_split_ctest extends nvdla_tg_base_test;

    function new(string name="pdp_split_ctest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("pdp_split_ctest");
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_config_db#()::get(this,"", "layers", layers);
        `uvm_info(inst_name,$sformatf("Layers = %0d ",layers),UVM_HIGH); 

        set_type_override_by_type(nvdla_pdprdma_pdp_scenario::get_type(), pdp_split_ctest_pdprdma_pdp_scenario::get_type());
    endfunction: build_phase

    function override_scenario_pool();
         generator.delete_scenario_pool();
         generator.push_scenario_pool(SCE_PDPRDMA_PDP);
    endfunction: override_scenario_pool

    `uvm_component_utils(pdp_split_ctest)
endclass : pdp_split_ctest


`endif // _PDP_SPLIT_CTEST_SV_

