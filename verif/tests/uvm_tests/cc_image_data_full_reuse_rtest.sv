`ifndef _CC_IMAGE_DATA_FULL_REUSE_RTEST_SV_
`define _CC_IMAGE_DATA_FULL_REUSE_RTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: cc_image_data_full_reuse_rtest 
//-------------------------------------------------------------------------------------

class cc_image_data_full_reuse_rtest_cc_sdp_scenario extends nvdla_cc_sdp_scenario;
    function new(string name="cc_image_data_full_reuse_rtest_cc_sdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    constraint sce_cc_sdp_sim_constraint_for_user_extend {
        // CONV 1st layer config
        (active_cnt == 0) -> {
            this.cdma.data_reuse      == nvdla_cdma_resource::data_reuse_DISABLE;
            this.cdma.weight_reuse    == nvdla_cdma_resource::weight_reuse_DISABLE;
            this.cdma.skip_data_rls   == nvdla_cdma_resource::skip_data_rls_ENABLE;
            this.cdma.skip_weight_rls == nvdla_cdma_resource::skip_weight_rls_DISABLE;
            this.cdma.datain_format   == nvdla_cdma_resource::datain_format_PIXEL;
        }
        // CONV 2nd layer config
        (active_cnt == 1) -> {
            this.cdma.data_reuse      == nvdla_cdma_resource::data_reuse_ENABLE;
            this.cdma.weight_reuse    == nvdla_cdma_resource::weight_reuse_DISABLE;
        }
        
        //SDP common config
        this.sdp.bn_bypass          == nvdla_sdp_resource::bn_bypass_YES;
        this.sdp.flying_mode        == nvdla_sdp_resource::flying_mode_ON;
        this.sdp.output_dst         == nvdla_sdp_resource::output_dst_MEM;
        this.sdp.bs_alu_bypass      == nvdla_sdp_resource::bs_alu_bypass_YES;
        this.sdp.bs_mul_bypass      == nvdla_sdp_resource::bs_mul_bypass_NO;
        this.sdp.bs_relu_bypass     == nvdla_sdp_resource::bs_relu_bypass_YES;
        this.sdp.bs_mul_src         == nvdla_sdp_resource::bs_mul_src_REG;
        this.sdp.bs_mul_shift_value == 0;
        this.sdp.bs_mul_prelu       == 0;
        this.sdp.bs_mul_operand     == 1;
    }
    `uvm_component_utils(cc_image_data_full_reuse_rtest_cc_sdp_scenario)
endclass: cc_image_data_full_reuse_rtest_cc_sdp_scenario

class cc_image_data_full_reuse_rtest extends nvdla_tg_base_test;

    function new(string name="cc_image_data_full_reuse_rtest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("cc_image_data_full_reuse_rtest");
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_config_db#()::get(this,"", "layers", layers);
        `uvm_info(inst_name,$sformatf("Layers = %0d ",layers),UVM_HIGH); 
        
        if(layers<2) begin
            `uvm_fatal(inst_name, "This's a CONV reuse case, at least 2 layers are required, please check your command options ..."); 
        end
        set_type_override_by_type(nvdla_cc_sdp_scenario::get_type(), cc_image_data_full_reuse_rtest_cc_sdp_scenario::get_type());
    endfunction: build_phase
    
    function override_scenario_pool();
         generator.delete_scenario_pool();
         generator.push_scenario_pool(SCE_CC_SDP);
    endfunction: override_scenario_pool

    `uvm_component_utils(cc_image_data_full_reuse_rtest)
endclass : cc_image_data_full_reuse_rtest


`endif //_CC_IMAGE_DATA_FULL_REUSE_RTEST_SV_

