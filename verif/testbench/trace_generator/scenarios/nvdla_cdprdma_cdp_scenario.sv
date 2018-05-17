`ifndef _NVDLA_CDPRDMA_CDP_SCENARIO_SV_
`define _NVDLA_CDPRDMA_CDP_SCENARIO_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_cdprdma_cdp_scenario
//
// @description: scenario of CDP+CDP_RDMA
//-------------------------------------------------------------------------------------

class nvdla_cdprdma_cdp_scenario extends nvdla_base_scenario;
    string                  inst_name;
    /*
        resource
    */
    rand nvdla_cdp_rdma_resource     cdp_rdma;
    rand nvdla_cdp_resource          cdp;

    /*
        constraints: 
            * ias_constraint: mandatory constraints from architecture requirement
            * sim_constraint: optional constraints for simulation only
    */
    extern constraint sce_cdprdma_cdp_sim_constraint_for_user_extend;
    extern constraint sce_cdprdma_cdp_ias_constraint;
    /*
        method
    */
    extern function         new(string name, uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    set_output_mem_addr();
    extern function void    activate();
    extern function void    set_sync_evt_name();
    extern function void    update_sync_evt_queue();
    extern function void    set_sim_constraint();
    /*
        phase
    */
    extern function void build_phase(uvm_phase phase);

    `uvm_component_utils(nvdla_cdprdma_cdp_scenario)

endclass : nvdla_cdprdma_cdp_scenario

function nvdla_cdprdma_cdp_scenario::new(string name, uvm_component parent);
    super.new(name, parent);
    this.inst_name = name;
endfunction : new

function void nvdla_cdprdma_cdp_scenario::build_phase(uvm_phase phase);
    super.build_phase(phase);
    cdp = nvdla_cdp_resource::type_id::create("NVDLA_CDP", this);
    cdp_rdma = nvdla_cdp_rdma_resource::type_id::create("NVDLA_CDP_RDMA", this);
endfunction: build_phase

function void nvdla_cdprdma_cdp_scenario::set_output_mem_addr();
    mem_man             mm;
    mem_region          region;
    longint unsigned    mem_size;

    mm = mem_man::get_mem_man();

    // WDMA
    mem_size = cdp.calc_mem_size(0, 0, cdp_rdma.channel+1, `NVDLA_MEMORY_ATOMIC_SIZE, cdp.dst_surface_stride);
    region = mm.request_region_by_size("PRI", $sformatf("%s_%d", "CDP_WDMA", cdp.get_active_cnt()), mem_size, cdp.align_mask[0]);
    {cdp.dst_base_addr_high, cdp.dst_base_addr_low} = region.get_start_offset();
    cdp.ral.nvdla.NVDLA_CDP.D_DST_BASE_ADDR_HIGH.set(cdp.dst_base_addr_high);
    cdp.ral.nvdla.NVDLA_CDP.D_DST_BASE_ADDR_LOW.set(cdp.dst_base_addr_low);
endfunction : set_output_mem_addr

function void nvdla_cdprdma_cdp_scenario::trace_dump(int fh);
    if(fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)
    print_comment(fh, $sformatf("Scenario CDPRDMA_CDP:%0d start",active_cnt));
    
    set_sync_evt_name();
    set_output_mem_addr();
    cdp.trace_dump(fh);
    cdp_rdma.trace_dump(fh);
    check_nothing(fh,sync_evt_name);
    update_sync_evt_queue();
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)

    if (fcov_en) begin
        `uvm_info(inst_name, "Start to sample coverage ...", UVM_NONE)
        `uvm_info(inst_name, $sformatf("CDP_RDMA.OP_ENABLE = %0d, CDP_OP_ENABLE = %0d",
            cdp.ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value,
            cdp.ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value), UVM_NONE)
        cov.cdp_pool.cdp_lut_sample();
        cov.cdp_pool.sample();
    end
    print_comment(fh, $sformatf("Scenario CDPRDMA_CDP:%0d end",active_cnt));
endfunction: trace_dump

function void nvdla_cdprdma_cdp_scenario::activate();
    active_cnt += 1;
    cdp_rdma.activate();
    cdp.activate();
endfunction: activate

function void nvdla_cdprdma_cdp_scenario::update_sync_evt_queue();
    cdp.update_sync_evt_queue();
    cdp_rdma.update_sync_evt_queue();
endfunction: update_sync_evt_queue

function void nvdla_cdprdma_cdp_scenario::set_sync_evt_name();
    sync_evt_name = {inst_name.tolower(),"_act",$sformatf("%0d",active_cnt)};
    sync_evt_name = {sync_evt_name, "_",cdp.get_resource_name(),"_act",$sformatf("%0d",cdp.get_active_cnt())};
    sync_evt_name = {sync_evt_name, "_",cdp_rdma.get_resource_name(),"_act",$sformatf("%0d",cdp_rdma.get_active_cnt())};
    
    /*
        CDP_RDMA relies on CDP interrupt to show status, so always provide same sync evt to both resources
    */
    cdp_rdma.set_sync_evt_name(sync_evt_name);
    cdp.set_sync_evt_name(sync_evt_name);
endfunction: set_sync_evt_name

function void nvdla_cdprdma_cdp_scenario::set_sim_constraint();
    `uvm_info(inst_name, $sformatf("set sim constraint knobs"), UVM_MEDIUM)
    cdp_rdma.set_sim_constraint();
endfunction: set_sim_constraint


constraint nvdla_cdprdma_cdp_scenario::sce_cdprdma_cdp_sim_constraint_for_user_extend {
}

// FIXME need to add lut resue case
constraint nvdla_cdprdma_cdp_scenario::sce_cdprdma_cdp_ias_constraint {
    cdp.input_data_type    == nvdla_cdp_resource::input_data_type_t'(cdp_rdma.input_data);
    cdp.dst_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE  >= (cdp_rdma.width+1);
    (cdp.dst_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (cdp_rdma.width+1)) dist { 0:=30, ['h1:'hF]:=60, ['h10:'h7F]:=5, ['h80:'hFF]:=4, ['h100:'1]:=1};
    50'h1 * cdp.dst_surface_stride >= cdp.dst_line_stride*(cdp_rdma.height+1);
    (cdp.dst_surface_stride - cdp.dst_line_stride*(cdp_rdma.height+1)) / `NVDLA_MEMORY_ATOMIC_SIZE dist { 0:=30, ['h1:'hF]:=60, ['h10:'h7F]:=5, ['h80:'hFF]:=4, ['h100:'1]:=1};
    // Total size shall be less then 16 MiB
    if (cdp.input_data_type == nvdla_cdp_resource::input_data_type_INT8) {
        cdp.dst_surface_stride * ((cdp_rdma.channel+1+`NVDLA_MEMORY_ATOMIC_SIZE-1) / `NVDLA_MEMORY_ATOMIC_SIZE) <= 64'h100_0000;
    } else {
        cdp.dst_surface_stride * ((cdp_rdma.channel+1+`NVDLA_MEMORY_ATOMIC_SIZE/2-1) / (`NVDLA_MEMORY_ATOMIC_SIZE/2)) <= 64'h100_0000;
    }
}

`endif //_NVDLA_CDPRDMA_CDP_SCENARIO_SV_
