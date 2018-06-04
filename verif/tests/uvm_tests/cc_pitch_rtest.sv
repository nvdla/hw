`ifndef _CC_PITCH_RTEST_SV_
`define _CC_PITCH_RTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: cc_pitch_rtest 
//-------------------------------------------------------------------------------------

class cc_pitch_rtest_cc_sdp_scenario extends nvdla_cc_sdp_scenario;
    function new(string name="cc_pitch_rtest_cc_sdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    constraint sce_cc_sdp_sim_constraint_for_user_extend {
        this.cdma.data_reuse        == nvdla_cdma_resource::data_reuse_DISABLE;
        this.cdma.weight_reuse      == nvdla_cdma_resource::weight_reuse_DISABLE;
        this.cdma.skip_data_rls     == nvdla_cdma_resource::skip_data_rls_DISABLE;
        this.cdma.skip_weight_rls   == nvdla_cdma_resource::skip_weight_rls_DISABLE;
        this.cdma.datain_format     == nvdla_cdma_resource::datain_format_PIXEL;

        this.sdp.bs_bypass          == nvdla_sdp_resource::bs_bypass_YES;
        this.sdp.bn_bypass          == nvdla_sdp_resource::bn_bypass_YES;
        this.sdp.flying_mode        == nvdla_sdp_resource::flying_mode_ON;
        this.sdp.output_dst         == nvdla_sdp_resource::output_dst_MEM;

        this.sdp.cvt_offset         == 0;
        this.sdp.cvt_scale          == 1;
        this.sdp.cvt_shift          == 0;
    }
    `uvm_component_utils(cc_pitch_rtest_cc_sdp_scenario)
endclass: cc_pitch_rtest_cc_sdp_scenario

class cc_pitch_rtest extends nvdla_tg_base_test;

    function new(string name="cc_pitch_rtest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("cc_pitch_rtest");
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_config_db#()::get(this,"", "layers", layers);
        `uvm_info(inst_name,$sformatf("Layers = %0d ",layers),UVM_HIGH); 

        set_type_override_by_type(nvdla_cc_sdp_scenario::get_type(), cc_pitch_rtest_cc_sdp_scenario::get_type());
    endfunction: build_phase

    function override_scenario_pool();
         generator.delete_scenario_pool();
         generator.push_scenario_pool(SCE_CC_SDP);
    endfunction: override_scenario_pool

    `uvm_component_utils(cc_pitch_rtest)
endclass : cc_pitch_rtest


`endif // _CC_PITCH_RTEST_SV_

