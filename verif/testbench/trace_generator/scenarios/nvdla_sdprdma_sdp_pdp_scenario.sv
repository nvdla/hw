`ifndef _NVDLA_SDPRDMA_SDP_PDP_SCENARIO_SV_
`define _NVDLA_SDPRDMA_SDP_PDP_SCENARIO_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_sdprdma_sdp_pdp
//
// @description: scenario of SDPRDMA + SDP + PDP
//-------------------------------------------------------------------------------------

class nvdla_sdprdma_sdp_pdp_scenario extends nvdla_base_scenario;
    /*
        resource
    */
    rand nvdla_sdp_rdma_resource  sdp_rdma;
    rand nvdla_sdp_resource       sdp;
    rand nvdla_pdp_resource       pdp;

    /*
        constraints:
            * ias_constraint: mandatory constraints from architecture requirement
            * sim_constraint: optional constraints for simulation only
    */
    extern constraint c_ias_sdp;
    extern constraint c_ias_sdp_rdma;
    extern constraint c_ias_pdp;
    extern constraint c_sim_xx;
    /*
        method
    */
    extern function         new(string name, uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    activate();
    extern function void    set_sync_evt_name();
    extern function void    update_sync_evt_queue();
    extern function void    set_sim_constraint();
    /*
        phase
    */
    extern function void build_phase(uvm_phase phase);

    `uvm_component_utils_begin(nvdla_sdprdma_sdp_pdp_scenario)
        `uvm_field_object(sdp_rdma, UVM_DEFAULT)
        `uvm_field_object(sdp     , UVM_DEFAULT)
        `uvm_field_object(pdp     , UVM_DEFAULT)
    `uvm_component_utils_end

endclass : nvdla_sdprdma_sdp_pdp_scenario

function nvdla_sdprdma_sdp_pdp_scenario::new(string name, uvm_component parent);
    super.new(name, parent);
    sdp         = nvdla_sdp_resource::get_sdp(this);
    sdp_rdma    = nvdla_sdp_rdma_resource::get_sdp_rdma(this);
    pdp         = nvdla_pdp_resource::get_pdp(this);
endfunction : new

function void nvdla_sdprdma_sdp_pdp_scenario::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // sdp = nvdla_sdp_resource::type_id::create("NVDLA_SDP", this);
    // sdp_rdma = nvdla_sdp_rdma_resource::type_id::create("NVDLA_SDP_RDMA", this);
    // pdp = nvdla_pdp_resource::type_id::create("NVDLA_PDP", this);
endfunction: build_phase

function void nvdla_sdprdma_sdp_pdp_scenario::trace_dump(int fh);
    surface_feature_config feature_cfg;
    if (fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)
    print_comment(fh, $sformatf("Scenario SDPRDMA_SDP_PDP:%0d start",active_cnt));

    set_sync_evt_name();
    // Get surface setting fro resource register
    // feature_cfg.width =
    // surface_generator.generate_memory_surface_feature(feature_cfg)
    sdp_rdma.trace_dump(fh);
    sdp.trace_dump(fh);
    pdp.trace_dump(fh);
    check_nothing(fh,pdp.get_sync_evt_name);
    update_sync_evt_queue();
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)

    if (fcov_en) begin
        `uvm_info(inst_name, "Start to sample coverage ...", UVM_HIGH)
        cov.sdp_pool.sdp_rdma_sample();
`ifdef NVDLA_SDP_EW_ENABLE
        cov.sdp_pool.sdp_lut_sample();
`endif
        cov.sdp_pool.sdp_sample();
        cov.pdp_pool.sample();
    end
    print_comment(fh, $sformatf("Scenario SDPRDMA_SDP_PDP:%0d end",active_cnt));
endfunction: trace_dump

function void nvdla_sdprdma_sdp_pdp_scenario::activate();
    active_cnt += 1;
    sdp_rdma.activate();
    sdp.activate();
    pdp.activate();
endfunction: activate

function void nvdla_sdprdma_sdp_pdp_scenario::update_sync_evt_queue();
    sdp.update_sync_evt_queue();
    sdp_rdma.update_sync_evt_queue();
    pdp.update_sync_evt_queue();
endfunction: update_sync_evt_queue

function void nvdla_sdprdma_sdp_pdp_scenario::set_sync_evt_name();
    string sdp_sync_evt_name;
    string pdp_sync_evt_name;

    sync_evt_name = {inst_name.tolower(),"_act",$sformatf("%0d",active_cnt)};
    sdp_sync_evt_name = {sync_evt_name, "_",sdp.get_resource_name(),"_act",$sformatf("%0d",sdp.get_active_cnt()),
                         "_",sdp_rdma.get_resource_name(),"_act",$sformatf("%0d",sdp_rdma.get_active_cnt())};
    pdp_sync_evt_name = {sync_evt_name, "_", pdp.get_resource_name(), "_act", $sformatf("%0d",pdp.get_active_cnt())};

    /*
        SDP_RDMA relies on SDP interrupt to show status, so always provide same sync evt to both resources
    */
    sdp_rdma.set_sync_evt_name(sdp_sync_evt_name);
    sdp.set_sync_evt_name(sdp_sync_evt_name);
    pdp.set_sync_evt_name(pdp_sync_evt_name);
endfunction: set_sync_evt_name

function void nvdla_sdprdma_sdp_pdp_scenario::set_sim_constraint();
    `uvm_info(inst_name, $sformatf("set sim constraint knobs"), UVM_MEDIUM)
    sdp.set_sim_constraint();
    pdp.set_sim_constraint();
endfunction: set_sim_constraint

constraint nvdla_sdprdma_sdp_pdp_scenario::c_ias_sdp {
    sdp.width           == pdp.cube_in_width;
    sdp.height          == pdp.cube_in_height;
    sdp.channel         == pdp.cube_in_channel;
    sdp.batch_number    == 0;
    sdp.flying_mode     == nvdla_sdp_resource::flying_mode_OFF;
    sdp.winograd        == nvdla_sdp_resource::winograd_OFF;
    sdp.output_dst      == nvdla_sdp_resource::output_dst_PDP;
    sdp.proc_precision  == int'(pdp.input_data);
    sdp.out_precision   == int'(pdp.input_data);
    sdp.ew_alu_algo     != nvdla_sdp_resource::ew_alu_algo_EQL;
}

constraint nvdla_sdprdma_sdp_pdp_scenario::c_ias_sdp_rdma {
    sdp_rdma.width          == sdp.width;
    sdp_rdma.height         == sdp.height;
    sdp_rdma.channel        == sdp.channel;
    sdp_rdma.flying_mode    == int'(sdp.flying_mode);
    sdp_rdma.winograd       == int'(sdp.winograd);
    sdp_rdma.proc_precision == int'(sdp.proc_precision);
    sdp_rdma.out_precision  == int'(sdp.out_precision);
    sdp_rdma.batch_number   == sdp.batch_number;

    (sdp.proc_precision == nvdla_sdp_resource::proc_precision_INT8) -> {
        sdp_rdma.in_precision == nvdla_sdp_rdma_resource::in_precision_INT8;
    }

    (sdp.proc_precision == nvdla_sdp_resource::proc_precision_INT16) -> {
        sdp_rdma.in_precision == nvdla_sdp_rdma_resource::in_precision_INT16;
    }

    (sdp.proc_precision == nvdla_sdp_resource::proc_precision_FP16) -> {
        sdp_rdma.in_precision == nvdla_sdp_rdma_resource::in_precision_FP16;
    }

    if (   (sdp.bs_bypass == nvdla_sdp_resource::bs_bypass_NO)
        && (   (   sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_NO
                && sdp.bs_alu_src    == nvdla_sdp_resource::bs_alu_src_MEM  )
            || (   sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_NO
                && sdp.bs_mul_src    == nvdla_sdp_resource::bs_mul_src_MEM  ))) {
        sdp_rdma.brdma_disable == nvdla_sdp_rdma_resource::brdma_disable_NO;
    } else {
        sdp_rdma.brdma_disable == nvdla_sdp_rdma_resource::brdma_disable_YES;
    }

    (   sdp.bs_bypass     == nvdla_sdp_resource::bs_bypass_NO
     && sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_NO
     && sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_YES) -> {
        sdp_rdma.brdma_data_use == nvdla_sdp_rdma_resource::brdma_data_use_MUL;
    }

    (   sdp.bs_bypass     == nvdla_sdp_resource::bs_bypass_NO
     && sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_YES
     && sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_NO ) -> {
        sdp_rdma.brdma_data_use == nvdla_sdp_rdma_resource::brdma_data_use_ALU;
    }

    (   sdp.bs_bypass     == nvdla_sdp_resource::bs_bypass_NO
     && sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_NO
     && sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_NO) -> {
        sdp_rdma.brdma_data_use == nvdla_sdp_rdma_resource::brdma_data_use_BOTH;
    }

    if (   (sdp.bn_bypass == nvdla_sdp_resource::bn_bypass_NO)
        && (   (   sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_NO
                && sdp.bn_alu_src    == nvdla_sdp_resource::bn_alu_src_MEM  )
            || (   sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_NO
                && sdp.bn_mul_src    == nvdla_sdp_resource::bn_mul_src_MEM  ))) {
        sdp_rdma.nrdma_disable == nvdla_sdp_rdma_resource::nrdma_disable_NO;
    } else {
        sdp_rdma.nrdma_disable == nvdla_sdp_rdma_resource::nrdma_disable_YES;
    }

    (   sdp.bn_bypass     == nvdla_sdp_resource::bn_bypass_NO
     && sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_NO
     && sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_YES) -> {
        sdp_rdma.nrdma_data_use == nvdla_sdp_rdma_resource::nrdma_data_use_MUL;
    }

    (   sdp.bn_bypass     == nvdla_sdp_resource::bn_bypass_NO
     && sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_YES
     && sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_NO ) -> {
        sdp_rdma.nrdma_data_use == nvdla_sdp_rdma_resource::nrdma_data_use_ALU;
    }

    (   sdp.bn_bypass     == nvdla_sdp_resource::bn_bypass_NO
     && sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_NO
     && sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_NO) -> {
        sdp_rdma.nrdma_data_use == nvdla_sdp_rdma_resource::nrdma_data_use_BOTH;
    }

    if (   (sdp.ew_bypass == nvdla_sdp_resource::ew_bypass_NO)
        && (   (   sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_NO
                && sdp.ew_alu_src    == nvdla_sdp_resource::ew_alu_src_MEM  )
            || (   sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_NO
                && sdp.ew_mul_src    == nvdla_sdp_resource::ew_mul_src_MEM  ))) {
        sdp_rdma.erdma_disable == nvdla_sdp_rdma_resource::erdma_disable_NO;
    } else {
        sdp_rdma.erdma_disable == nvdla_sdp_rdma_resource::erdma_disable_YES;
    }

    (   sdp.ew_bypass     == nvdla_sdp_resource::ew_bypass_NO
     && sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_NO
     && sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_YES) -> {
        sdp_rdma.erdma_data_use == nvdla_sdp_rdma_resource::erdma_data_use_MUL;
    }

    (   sdp.ew_bypass     == nvdla_sdp_resource::ew_bypass_NO
     && sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_YES
     && sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_NO ) -> {
        sdp_rdma.erdma_data_use == nvdla_sdp_rdma_resource::erdma_data_use_ALU;
    }

    (   sdp.ew_bypass     == nvdla_sdp_resource::ew_bypass_NO
     && sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_NO
     && sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_NO) -> {
        sdp_rdma.erdma_data_use == nvdla_sdp_rdma_resource::erdma_data_use_BOTH;
    }
}

constraint nvdla_sdprdma_sdp_pdp_scenario::c_ias_pdp {
    pdp.split_num    == 0;
    pdp.flying_mode  == nvdla_pdp_resource::flying_mode_ON_FLYING;
}

constraint nvdla_sdprdma_sdp_pdp_scenario::c_sim_xx {
}

`endif //_NVDLA_SDPRDMA_SDP_PDP_SCENARIO_SV_
