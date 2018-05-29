`ifndef _NVDLA_SDPRDMA_SDP_SCENARIO_SV_
`define _NVDLA_SDPRDMA_SDP_SCENARIO_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_sdp_sdp_rdma_scenario
//
// @description: scenario of SDP+SDP_RDMA
//-------------------------------------------------------------------------------------

class nvdla_sdprdma_sdp_scenario extends nvdla_base_scenario;
    string                  inst_name;
    /*
        resource
    */
    rand nvdla_sdp_rdma_resource     sdp_rdma;
    rand nvdla_sdp_resource          sdp;

    /*
        constraints:
            * ias_constraint: mandatory constraints from architecture requirement
            * sim_constraint: optional constraints for simulation only
    */
    extern constraint sce_sdprdma_sdp_sim_constraint_for_user_extend;
    extern constraint sce_sdprdma_sdp_ias_constraint;
    /*
        method
    */
    extern function         new(string name, uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    activate();
    extern function void    set_sync_evt_name();
    extern function void    set_sim_constraint();

    /*
        phase
    */
    extern function void build_phase(uvm_phase phase);

    `uvm_component_utils_begin(nvdla_sdprdma_sdp_scenario)
        `uvm_field_object(sdp_rdma, UVM_DEFAULT)
        `uvm_field_object(sdp     , UVM_DEFAULT)
    `uvm_component_utils_end

endclass : nvdla_sdprdma_sdp_scenario

function nvdla_sdprdma_sdp_scenario::new(string name, uvm_component parent);
    super.new(name, parent);
    this.inst_name = name;
    sdp         = nvdla_sdp_resource::get_sdp(this);
    sdp_rdma    = nvdla_sdp_rdma_resource::get_sdp_rdma(this);
endfunction : new

function void nvdla_sdprdma_sdp_scenario::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // sdp = nvdla_sdp_resource::type_id::create("NVDLA_SDP", this);
    // sdp_rdma = nvdla_sdp_rdma_resource::type_id::create("NVDLA_SDP_RDMA", this);
endfunction: build_phase

function void nvdla_sdprdma_sdp_scenario::trace_dump(int fh);
    surface_feature_config feature_cfg;
    if(fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)
    print_comment(fh, $sformatf("Scenario SDPRDMA_SDP:%0d start",active_cnt));
    
    set_sync_evt_name();
    // Get surface setting fro resource register
    // feature_cfg.width =
    // surface_generator.generate_memory_surface_feature(feature_cfg)
    sdp_rdma.trace_dump(fh);
    sdp.trace_dump(fh);
    check_nothing(fh,sync_evt_name);
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)

    if (fcov_en) begin
        `uvm_info(inst_name, "Start to sample coverage ...", UVM_HIGH)
        cov.sdp_pool.sdp_rdma_sample(ral);
`ifdef NVDLA_SDP_LUT_ENABLE
        cov.sdp_pool.sdp_lut_sample(ral);
`endif
        cov.sdp_pool.sdp_sample(ral);
    end
    print_comment(fh, $sformatf("Scenario SDPRDMA_SDP:%0d end",active_cnt));
endfunction: trace_dump

function void nvdla_sdprdma_sdp_scenario::activate();
    active_cnt += 1;
    sdp_rdma.activate();
    sdp.activate();
endfunction: activate

function void nvdla_sdprdma_sdp_scenario::set_sync_evt_name();
    sync_evt_name = {inst_name.tolower(),"_act",$sformatf("%0d",active_cnt)};
    sync_evt_name = {sync_evt_name, "_",sdp.get_resource_name(),"_act",$sformatf("%0d",sdp.get_active_cnt())};
    sync_evt_name = {sync_evt_name, "_",sdp_rdma.get_resource_name(),"_act",$sformatf("%0d",sdp_rdma.get_active_cnt())};

    /*
        SDP_RDMA relies on SDP interrupt to show status, so always provide same sync evt to both resources
    */
    sdp_rdma.set_sync_evt_name(sync_evt_name);
    sdp.set_sync_evt_name(sync_evt_name);
endfunction: set_sync_evt_name

function void nvdla_sdprdma_sdp_scenario::set_sim_constraint();
    `uvm_info(inst_name, $sformatf("set sim constraint knobs"), UVM_MEDIUM)
    sdp.set_sim_constraint();
endfunction: set_sim_constraint

constraint nvdla_sdprdma_sdp_scenario::sce_sdprdma_sdp_sim_constraint_for_user_extend {
}

constraint nvdla_sdprdma_sdp_scenario::sce_sdprdma_sdp_ias_constraint {
    sdp.flying_mode  == nvdla_sdp_resource::flying_mode_OFF;
    sdp.output_dst   == nvdla_sdp_resource::output_dst_MEM;
    if(sdp.batch_number!=0) {
        sdp.proc_precision == int'(sdp.out_precision);
    }
    sdp_rdma.width         == sdp.width;
    sdp_rdma.height        == sdp.height;
    sdp_rdma.channel       == sdp.channel;
    sdp_rdma.flying_mode   == int'(sdp.flying_mode);
    sdp_rdma.winograd      == int'(sdp.winograd);
    sdp_rdma.proc_precision == int'(sdp.proc_precision);
    sdp_rdma.out_precision == int'(sdp.out_precision);
    sdp_rdma.batch_number  == sdp.batch_number;

    if(sdp.proc_precision==nvdla_sdp_resource::proc_precision_INT8  && sdp.out_precision==nvdla_sdp_resource::out_precision_INT8)  { sdp_rdma.in_precision != nvdla_sdp_rdma_resource::in_precision_FP16; }

`ifdef FEATURE_DATA_TYPE_INT16_FP16
`ifdef PRECISION_CONVERSION_ENABLE
    if(sdp.proc_precision==nvdla_sdp_resource::proc_precision_INT8  && sdp.out_precision==nvdla_sdp_resource::out_precision_INT16) { sdp_rdma.in_precision == nvdla_sdp_rdma_resource::in_precision_INT8; }
`endif
    if(sdp.proc_precision==nvdla_sdp_resource::proc_precision_INT16) { sdp_rdma.in_precision==nvdla_sdp_rdma_resource::in_precision_INT16; }
    if(sdp.proc_precision==nvdla_sdp_resource::proc_precision_FP16)  { sdp_rdma.in_precision==nvdla_sdp_rdma_resource::in_precision_FP16;  }
`endif

    if((sdp.bs_bypass==nvdla_sdp_resource::bs_bypass_NO) && ((sdp.bs_alu_bypass==nvdla_sdp_resource::bs_alu_bypass_NO && sdp.bs_alu_src==nvdla_sdp_resource::bs_alu_src_MEM) || (sdp.bs_mul_bypass==nvdla_sdp_resource::bs_mul_bypass_NO && sdp.bs_mul_src==nvdla_sdp_resource::bs_mul_src_MEM))) { sdp_rdma.brdma_disable==nvdla_sdp_rdma_resource::brdma_disable_NO; }
    else { sdp_rdma.brdma_disable==nvdla_sdp_rdma_resource::brdma_disable_YES; }
    if(sdp.bs_bypass==nvdla_sdp_resource::bs_bypass_NO && sdp.bs_mul_bypass==nvdla_sdp_resource::bs_mul_bypass_NO  && sdp.bs_alu_bypass==nvdla_sdp_resource::bs_alu_bypass_YES) { sdp_rdma.brdma_data_use==nvdla_sdp_rdma_resource::brdma_data_use_MUL;  }
    if(sdp.bs_bypass==nvdla_sdp_resource::bs_bypass_NO && sdp.bs_mul_bypass==nvdla_sdp_resource::bs_mul_bypass_YES && sdp.bs_alu_bypass==nvdla_sdp_resource::bs_alu_bypass_NO)  { sdp_rdma.brdma_data_use==nvdla_sdp_rdma_resource::brdma_data_use_ALU;  }
    if(sdp.bs_bypass==nvdla_sdp_resource::bs_bypass_NO && sdp.bs_mul_bypass==nvdla_sdp_resource::bs_mul_bypass_NO  && sdp.bs_alu_bypass==nvdla_sdp_resource::bs_alu_bypass_NO)  { sdp_rdma.brdma_data_use==nvdla_sdp_rdma_resource::brdma_data_use_BOTH; }
    if ((sdp.bn_bypass==nvdla_sdp_resource::bn_bypass_NO) && ((sdp.bn_alu_bypass==nvdla_sdp_resource::bn_alu_bypass_NO && sdp.bn_alu_src==nvdla_sdp_resource::bn_alu_src_MEM) || (sdp.bn_mul_bypass==nvdla_sdp_resource::bn_mul_bypass_NO && sdp.bn_mul_src==nvdla_sdp_resource::bn_mul_src_MEM))) { sdp_rdma.nrdma_disable==nvdla_sdp_rdma_resource::nrdma_disable_NO; }
    else { sdp_rdma.nrdma_disable==nvdla_sdp_rdma_resource::nrdma_disable_YES; }
    if(sdp.bn_bypass==nvdla_sdp_resource::bn_bypass_NO && sdp.bn_mul_bypass==nvdla_sdp_resource::bn_mul_bypass_NO  && sdp.bn_alu_bypass==nvdla_sdp_resource::bn_alu_bypass_YES){sdp_rdma.nrdma_data_use==nvdla_sdp_rdma_resource::nrdma_data_use_MUL;}
    if(sdp.bn_bypass==nvdla_sdp_resource::bn_bypass_NO && sdp.bn_mul_bypass==nvdla_sdp_resource::bn_mul_bypass_YES && sdp.bn_alu_bypass==nvdla_sdp_resource::bn_alu_bypass_NO) {sdp_rdma.nrdma_data_use==nvdla_sdp_rdma_resource::nrdma_data_use_ALU;}
    if(sdp.bn_bypass==nvdla_sdp_resource::bn_bypass_NO && sdp.bn_mul_bypass==nvdla_sdp_resource::bn_mul_bypass_NO  && sdp.bn_alu_bypass==nvdla_sdp_resource::bn_alu_bypass_NO) {sdp_rdma.nrdma_data_use==nvdla_sdp_rdma_resource::nrdma_data_use_BOTH;}
    if((sdp.ew_bypass==nvdla_sdp_resource::ew_bypass_NO) && ((sdp.ew_alu_bypass==nvdla_sdp_resource::ew_alu_bypass_NO && sdp.ew_alu_src==nvdla_sdp_resource::ew_alu_src_MEM) || (sdp.ew_mul_bypass==nvdla_sdp_resource::ew_mul_bypass_NO && sdp.ew_mul_src==nvdla_sdp_resource::ew_mul_src_MEM))) { sdp_rdma.erdma_disable==nvdla_sdp_rdma_resource::erdma_disable_NO; }
    else { sdp_rdma.erdma_disable==nvdla_sdp_rdma_resource::erdma_disable_YES; }
    if(sdp.ew_bypass==nvdla_sdp_resource::ew_bypass_NO && sdp.ew_mul_bypass==nvdla_sdp_resource::ew_mul_bypass_NO  && sdp.ew_alu_bypass==nvdla_sdp_resource::ew_alu_bypass_YES) {sdp_rdma.erdma_data_use==nvdla_sdp_rdma_resource::erdma_data_use_MUL;}
    if(sdp.ew_bypass==nvdla_sdp_resource::ew_bypass_NO && sdp.ew_mul_bypass==nvdla_sdp_resource::ew_mul_bypass_YES && sdp.ew_alu_bypass==nvdla_sdp_resource::ew_alu_bypass_NO)  {sdp_rdma.erdma_data_use==nvdla_sdp_rdma_resource::erdma_data_use_ALU;}
    if(sdp.ew_bypass==nvdla_sdp_resource::ew_bypass_NO && sdp.ew_mul_bypass==nvdla_sdp_resource::ew_mul_bypass_NO  && sdp.ew_alu_bypass==nvdla_sdp_resource::ew_alu_bypass_NO)  {sdp_rdma.erdma_data_use==nvdla_sdp_rdma_resource::erdma_data_use_BOTH;}
    if(sdp.ew_alu_algo == nvdla_sdp_resource::ew_alu_algo_EQL && sdp.ew_bypass == nvdla_sdp_resource::ew_bypass_NO && sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_NO) {
        sdp_rdma.erdma_data_use!=nvdla_sdp_rdma_resource::erdma_data_use_BOTH;
        !((sdp_rdma.erdma_data_size == nvdla_sdp_rdma_resource::erdma_data_size_TWO_BYTE) && (sdp_rdma.proc_precision == nvdla_sdp_rdma_resource::proc_precision_INT8));
        sdp_rdma.src_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE == (sdp_rdma.width+1);
        sdp_rdma.src_surface_stride == sdp_rdma.src_line_stride*(sdp_rdma.height+64'h1);
        sdp_rdma.ew_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE == (sdp_rdma.width+1);
        sdp_rdma.ew_surface_stride == sdp_rdma.ew_line_stride*(sdp_rdma.height+64'h1);
        sdp_rdma.in_precision   == int'(sdp.proc_precision);
    }
}

`endif //_NVDLA_SDPRDMA_SDP_SCENARIO_SV_
