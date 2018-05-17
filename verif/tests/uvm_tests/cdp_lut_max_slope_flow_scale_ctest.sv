`ifndef _CDP_LUT_MAX_SLOPE_FLOW_SCALE_CTEST_SV_
`define _CDP_LUT_MAX_SLOPE_FLOW_SCALE_CTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: cdp_lut_max_slope_flow_scale 
//-------------------------------------------------------------------------------------

class cdp_lut_max_slope_flow_scale_cdprdma_cdp_scenario extends nvdla_cdprdma_cdp_scenario ;
    int subtest = 0;

    function new(string name="cdp_lut_max_slope_flow_scale_cdprdma_cdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void pre_randomize();
        super.pre_randomize();
        if (!(subtest inside {[0:7]}))
            `uvm_fatal(get_name(), $sformatf("# Invalid subtest (%0d), valid range is [0:7]", subtest))

        `uvm_info(get_name(), $sformatf("# subtest = %0d", subtest), UVM_NONE)
    endfunction
    
    constraint sce_cdprdma_cdp_sim_constraint_for_user_extend {
        // cross among pos_max_range/neg_max_range and oflow/uflow
        (subtest == 0) -> this.cdp.lut_le_slope_oflow_scale inside {[16'h7FF0:16'h7FFF]}; // pos_max_range  
        (subtest == 1) -> this.cdp.lut_le_slope_oflow_scale inside {[16'h8000:16'h800F]}; // neg_max_range  
        (subtest == 2) -> this.cdp.lut_le_slope_uflow_scale inside {[16'h7FF0:16'h7FFF]}; // pos_max_range  
        (subtest == 3) -> this.cdp.lut_le_slope_uflow_scale inside {[16'h8000:16'h800F]}; // neg_max_range 

        (subtest == 4) -> this.cdp.lut_lo_slope_oflow_scale inside {[16'h7FF0:16'h7FFF]}; // pos_max_range  
        (subtest == 5) -> this.cdp.lut_lo_slope_oflow_scale inside {[16'h8000:16'h800F]}; // neg_max_range  
        (subtest == 6) -> this.cdp.lut_lo_slope_uflow_scale inside {[16'h7FF0:16'h7FFF]}; // pos_max_range  
        (subtest == 7) -> this.cdp.lut_lo_slope_uflow_scale inside {[16'h8000:16'h800F]}; // neg_max_range 
    }

    `uvm_component_utils_begin(cdp_lut_max_slope_flow_scale_cdprdma_cdp_scenario)
        `uvm_field_int(subtest, UVM_DEFAULT)
    `uvm_component_utils_end
endclass: cdp_lut_max_slope_flow_scale_cdprdma_cdp_scenario

class cdp_lut_max_slope_flow_scale_ctest extends nvdla_tg_base_test;

    function new(string name="cdp_lut_max_slope_flow_scale_ctest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("cdp_lut_max_slope_flow_scale_ctest");
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        set_type_override_by_type(nvdla_cdprdma_cdp_scenario::get_type(), cdp_lut_max_slope_flow_scale_cdprdma_cdp_scenario::get_type());
    endfunction: build_phase

    function override_scenario_pool();
         generator.delete_scenario_pool();
         generator.push_scenario_pool(SCE_CDPRDMA_CDP);
    endfunction: override_scenario_pool

    `uvm_component_utils(cdp_lut_max_slope_flow_scale_ctest)
endclass : cdp_lut_max_slope_flow_scale_ctest

`endif

