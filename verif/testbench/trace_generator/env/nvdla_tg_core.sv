`ifndef _NVDLA_TG_CORE_SV_
`define _NVDLA_TG_CORE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_tg_core
//
// @description: class of trace generator
//-------------------------------------------------------------------------------------

import nvdla_ral_pkg::*;
import nvdla_resource_pkg::*;
import nvdla_scenario_pkg::*;
import nvdla_coverage_pkg::*;
import mem_man_pkg::*;

class nvdla_tg_core extends uvm_component;
    string                      inst_name;

    /*
        curr_scenario: enum value of scenario being processed. By default is not valid
    */
    scenario_e                  curr_scenario;

    ral_sys_top                 ral;

    scenario_e                  scenario_pool[$];

    /*
        coverage model: used to measure constraint quality before RTL is ready.
    */
    bit                         fcov_en = 0;
    nvdla_coverage_top          cov;

    /*
        scenarioes
    */
    nvdla_pdprdma_pdp_scenario          pdprdma_pdp;
    nvdla_cdprdma_cdp_scenario          cdprdma_cdp;
    nvdla_sdprdma_sdp_scenario          sdprdma_sdp;
    nvdla_sdprdma_sdp_pdp_scenario      sdprdma_sdp_pdp;
    nvdla_cc_sdp_scenario               cc_sdp;
    nvdla_cc_sdp_pdp_scenario           cc_sdp_pdp;
    nvdla_cc_sdprdma_sdp_scenario       cc_sdprdma_sdp;
    nvdla_cc_sdprdma_sdp_pdp_scenario   cc_sdprdma_sdp_pdp;

    `uvm_component_utils(nvdla_tg_core)

    /*
        methods
    */
    extern function         new(string name="nvdla_tg_core", uvm_component parent);
    /*
        restore_scenario_pool: set curr_scenario and scenario_pool to initial status
    */
    extern function void    restore_scenario_pool();
    extern function void    delete_scenario_pool();
    extern function void    push_scenario_pool(scenario_e sce);
    extern function void    generate_trace(int fh);

    /*
        phases
    */
    extern function void    build_phase(uvm_phase phase);

endclass : nvdla_tg_core

function nvdla_tg_core::new(string name="nvdla_tg_core", uvm_component parent);
    super.new(name,parent);
    this.inst_name = name;
    curr_scenario = ALL_SCENARIOS;

    begin
        mem_man mm = mem_man::get_mem_man();
        mm.register_domain("pri_mem", 'h0, {`NVDLA_MEM_ADDRESS_WIDTH{1'b1}}, mem_man_pkg::ALLOC_RANDOM);
        mm.register_domain("sec_mem", 'h0, {`NVDLA_MEM_ADDRESS_WIDTH{1'b1}}, mem_man_pkg::ALLOC_RANDOM);
    end

    if ($test$plusargs("fcov_en")) begin
        fcov_en = 1;
    end
endfunction: new

function void nvdla_tg_core::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(ral==null) begin
        ral = new("ral");
        ral.build();
        ral.lock_model();
    end
    uvm_config_db#(ral_sys_top)::set(this, "*", "ral", ral);

    pdprdma_pdp         = nvdla_pdprdma_pdp_scenario::type_id::create("PDPRDMA_PDP",this);
    cdprdma_cdp         = nvdla_cdprdma_cdp_scenario::type_id::create("CDPRDMA_CDP",this);
    sdprdma_sdp         = nvdla_sdprdma_sdp_scenario::type_id::create("SDPRDMA_SDP",this);
    sdprdma_sdp_pdp     = nvdla_sdprdma_sdp_pdp_scenario::type_id::create("SDPRDMA_SDP_PDP",this);
    cc_sdp              = nvdla_cc_sdp_scenario::type_id::create("CC_SDP",this);
    cc_sdp_pdp          = nvdla_cc_sdp_pdp_scenario::type_id::create("CC_SDP_PDP",this);
    cc_sdprdma_sdp      = nvdla_cc_sdprdma_sdp_scenario::type_id::create("CC_SDPRDMA_SDP",this);
    cc_sdprdma_sdp_pdp  = nvdla_cc_sdprdma_sdp_pdp_scenario::type_id::create("CC_SDPRDMA_SDP_PDP",this);

    if (fcov_en) begin
        cov = nvdla_coverage_top::type_id::create("cov", this);
        uvm_config_db#(nvdla_coverage_top)::set(this, "*", "cov", cov);
    end
endfunction: build_phase

function void nvdla_tg_core::restore_scenario_pool();
    delete_scenario_pool();
    curr_scenario = ALL_SCENARIOS;
    for(int i=0;i<ALL_SCENARIOS;i++) begin
        scenario_e  sce = scenario_e'(i);
        push_scenario_pool(sce);
    end
endfunction

function void nvdla_tg_core::delete_scenario_pool();
    scenario_pool.delete();
    `uvm_info(inst_name,"Delete all scenarios from scenario pool", UVM_HIGH) 
endfunction: delete_scenario_pool

function void nvdla_tg_core::push_scenario_pool(scenario_e sce);
    scenario_pool.push_back(sce);
    `uvm_info(inst_name,$sformatf("Add %s in scenario_pool",sce.name), UVM_HIGH) 
endfunction: push_scenario_pool

function void nvdla_tg_core::generate_trace(int fh);
    scenario_pool.shuffle();
    curr_scenario = scenario_pool.pop_front();
    
    `uvm_info(inst_name, $sformatf("Pick up scenario: %s",curr_scenario.name()),UVM_NONE);
    
    case (curr_scenario)
        SCE_PDPRDMA_PDP: begin
            pdprdma_pdp.activate();
            if(!pdprdma_pdp.randomize()) begin
                `uvm_fatal(inst_name, "Fail to randomize SCE_PDPRDMA_PDP ...");
            end
            pdprdma_pdp.trace_dump(fh);
            `uvm_info(inst_name, $sformatf("%0s config:%0s", curr_scenario.name(), pdprdma_pdp.sprint()), UVM_NONE)
        end
        SCE_CDPRDMA_CDP: begin
            cdprdma_cdp.activate();
            if(!cdprdma_cdp.randomize()) begin
                `uvm_fatal(inst_name, "Fail to randomize SCE_CDPRDMA_CDP ...");
            end
            cdprdma_cdp.trace_dump(fh);
            `uvm_info(inst_name, $sformatf("%0s config:%0s", curr_scenario.name(), cdprdma_cdp.sprint()), UVM_NONE)
        end
        SCE_SDPRDMA_SDP: begin
            sdprdma_sdp.activate();
            if(!sdprdma_sdp.randomize()) begin
                `uvm_fatal(inst_name, "Fail to randomize SCE_SDPRDMA_SDP ...");
            end
            sdprdma_sdp.trace_dump(fh);
            `uvm_info(inst_name, $sformatf("%0s config:%0s", curr_scenario.name(), sdprdma_sdp.sprint()), UVM_NONE)
        end
        SCE_SDPRDMA_SDP_PDP: begin
            sdprdma_sdp_pdp.activate();
            if(!sdprdma_sdp_pdp.randomize()) begin
                `uvm_fatal(inst_name, "Fail to randomize SCE_SDPRDMA_SDP_PDP ...");
            end
            sdprdma_sdp_pdp.trace_dump(fh);
            `uvm_info(inst_name, $sformatf("%0s config:%0s", curr_scenario.name(), sdprdma_sdp_pdp.sprint()), UVM_NONE)
        end
        SCE_CC_SDP: begin
            cc_sdp.activate();
            if(!cc_sdp.randomize()) begin
                `uvm_fatal(inst_name, "Fail to randomize SCE_CC_SDP ...");
            end
            cc_sdp.trace_dump(fh);
            `uvm_info(inst_name, $sformatf("%0s config:%0s", curr_scenario.name(), cc_sdp.sprint()), UVM_NONE)
        end
        SCE_CC_SDP_PDP: begin
            cc_sdp_pdp.activate();
            if(!cc_sdp_pdp.randomize()) begin
                `uvm_fatal(inst_name, "Fail to randomize SCE_CC_SDP_PDP ...");
            end
            cc_sdp_pdp.trace_dump(fh);
            `uvm_info(inst_name, $sformatf("%0s config:%0s", curr_scenario.name(), cc_sdp_pdp.sprint()), UVM_NONE)
        end
        SCE_CC_SDPRDMA_SDP: begin
            cc_sdprdma_sdp.activate();
            if(!cc_sdprdma_sdp.randomize()) begin
                `uvm_fatal(inst_name, "Fail to randomize SCE_CC_SDPRDMA_SDP ...");
            end
            cc_sdprdma_sdp.trace_dump(fh);
            `uvm_info(inst_name, $sformatf("%0s config:%0s", curr_scenario.name(), cc_sdprdma_sdp.sprint()), UVM_NONE)
        end
        SCE_CC_SDPRDMA_SDP_PDP: begin
            cc_sdprdma_sdp_pdp.activate();
            if(!cc_sdprdma_sdp_pdp.randomize()) begin
                `uvm_fatal(inst_name, "Fail to randomize SCE_CC_SDPRDMA_SDP_PDP ...");
            end
            cc_sdprdma_sdp_pdp.trace_dump(fh);
            `uvm_info(inst_name, $sformatf("%0s config:%0s", curr_scenario.name(), cc_sdprdma_sdp_pdp.sprint()), UVM_NONE)
        end
        default: begin
            `uvm_fatal(inst_name, $sformatf("Invalid scenario setting: %s ...",curr_scenario.name()))
        end
    endcase

    `uvm_info(inst_name, $sformatf("Scenario %s trace generated ... ",curr_scenario.name()),UVM_LOW);
endfunction: generate_trace

`endif //_NVDLA_TG_CORE_SV_
