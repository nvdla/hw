`ifndef _NVDLA_PDPRDMA_PDP_SCENARIO_SV_
`define _NVDLA_PDPRDMA_PDP_SCENARIO_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_pdp_pdp_rdma_scenario
//
// @description: scenario of PDP+PDP_RDMA
//-------------------------------------------------------------------------------------

class nvdla_pdprdma_pdp_scenario extends nvdla_base_scenario;
    string                  inst_name;
    /*
        resource
    */
    rand nvdla_pdp_rdma_resource     pdp_rdma;
    rand nvdla_pdp_resource          pdp;

    /*
        constraints:
            * ias_constraint: mandatory constraints from architecture requirement
            * sim_constraint: optional constraints for simulation only
    */
    extern constraint sce_pdprdma_pdp_sim_constraint_for_demo;
    extern constraint sce_pdprdma_pdp_ias_constraint;
    extern constraint sce_pdprdma_pdp_sim_solve_height_before_width;
    extern constraint sce_pdprdma_pdp_sim_solve_channel_before_width;
    /*
        method
    */
    extern function         new(string name, uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    activate();
    extern function void    set_sync_evt_name();
    extern function void    set_sim_constraint();
    extern function void    pre_randomize();

    /*
        phase
    */
    extern function void build_phase(uvm_phase phase);

    `uvm_component_utils_begin(nvdla_pdprdma_pdp_scenario)
    `uvm_component_utils_end

endclass : nvdla_pdprdma_pdp_scenario

function nvdla_pdprdma_pdp_scenario::new(string name, uvm_component parent);
    super.new(name, parent);
    this.inst_name = name;
    pdp   = nvdla_pdp_resource::get_pdp(this);
    pdp_rdma = nvdla_pdp_rdma_resource::get_pdp_rdma(this);
endfunction : new

function void nvdla_pdprdma_pdp_scenario::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction: build_phase

function void nvdla_pdprdma_pdp_scenario::trace_dump(int fh);
    if(fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)
    print_comment(fh, $sformatf("Scenario PDPRDMA_PDP:%0d start",active_cnt));

    set_sync_evt_name();
    pdp_rdma.trace_dump(fh);
    pdp.trace_dump(fh);
    check_nothing(fh,sync_evt_name);
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)

    if (fcov_en) begin
        `uvm_info(inst_name, "Start to sample coverage ...", UVM_HIGH)
        cov.pdp_pool.pdp_sample(ral);
        cov.pdp_pool.pdp_rdma_sample(ral);
    end
    print_comment(fh, $sformatf("Scenario PDPRDMA_PDP:%0d end",active_cnt));
endfunction: trace_dump

function void nvdla_pdprdma_pdp_scenario::activate();
    active_cnt += 1;
    pdp_rdma.activate();
    pdp.activate();
endfunction: activate

function void nvdla_pdprdma_pdp_scenario::set_sync_evt_name();
    sync_evt_name = {inst_name.tolower(),"_act",$sformatf("%0d",active_cnt)};
    sync_evt_name = {sync_evt_name, "_",pdp.get_resource_name(),"_act",$sformatf("%0d",pdp.get_active_cnt())};
    sync_evt_name = {sync_evt_name, "_",pdp_rdma.get_resource_name(),"_act",$sformatf("%0d",pdp_rdma.get_active_cnt())};

    /*
        PDP_RDMA relies on PDP interrupt to show status, so always provide same sync evt to both resources
    */
    pdp_rdma.set_sync_evt_name(sync_evt_name);
    pdp.set_sync_evt_name(sync_evt_name);
endfunction: set_sync_evt_name

function void nvdla_pdprdma_pdp_scenario::set_sim_constraint();
    `uvm_info(inst_name, $sformatf("set sim constraint knobs"), UVM_MEDIUM)
    pdp.set_sim_constraint();
endfunction: set_sim_constraint

function void nvdla_pdprdma_pdp_scenario::pre_randomize();
    super.pre_randomize();
    sce_pdprdma_pdp_sim_solve_height_before_width.constraint_mode($urandom_range(0, 1));
    sce_pdprdma_pdp_sim_solve_channel_before_width.constraint_mode($urandom_range(0, 1));
endfunction

constraint nvdla_pdprdma_pdp_scenario::sce_pdprdma_pdp_sim_constraint_for_demo {
}

constraint nvdla_pdprdma_pdp_scenario::sce_pdprdma_pdp_ias_constraint {
    pdp.flying_mode            == nvdla_pdp_resource::flying_mode_OFF_FLYING;
    pdp.cube_in_width          == pdp_rdma.cube_in_width;
    pdp.cube_in_height         == pdp_rdma.cube_in_height;
    pdp.cube_in_channel        == pdp_rdma.cube_in_channel;
    pdp.flying_mode            == int'(pdp_rdma.flying_mode);
    pdp.src_base_addr_low      == pdp_rdma.src_base_addr_low;
    pdp.src_base_addr_high     == pdp_rdma.src_base_addr_high;
    pdp.src_line_stride        == pdp_rdma.src_line_stride;
    pdp.src_surface_stride     == pdp_rdma.src_surface_stride;
    pdp.input_data             == int'(pdp_rdma.input_data);
    pdp.split_num              == pdp_rdma.split_num;
    pdp.kernel_width           == int'(pdp_rdma.kernel_width);
    pdp.kernel_stride_width    == pdp_rdma.kernel_stride_width;
    pdp.partial_width_in_first == pdp_rdma.partial_width_in_first;
    pdp.partial_width_in_mid   == pdp_rdma.partial_width_in_mid;
    pdp.partial_width_in_last  == pdp_rdma.partial_width_in_last;
}

constraint nvdla_pdprdma_pdp_scenario::sce_pdprdma_pdp_sim_solve_height_before_width {
    solve pdp.cube_in_height  before pdp.cube_in_width;
    solve pdp.cube_out_height before pdp.cube_out_width;
}

constraint nvdla_pdprdma_pdp_scenario::sce_pdprdma_pdp_sim_solve_channel_before_width {
    solve pdp.cube_in_channel  before pdp.cube_in_width;
    solve pdp.cube_out_channel before pdp.cube_out_width;
}

`endif //_NVDLA_PDPRDMA_PDP_SCENARIO_SV_
