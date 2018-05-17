`ifndef _NVDLA_BASE_SCENARIO_SV_
`define _NVDLA_BASE_SCENARIO_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_base_scenario
//
// @description: base class of various hardware scenarios
//-------------------------------------------------------------------------------------

class nvdla_base_scenario extends uvm_component;
    string                  inst_name;
    /*
        active_cnt: counter of how many times scenario is active, e.g. gets called by any sequences
        counter default value is set to `NEVER_BE_ACTIVE( e.g. -1 ), and start counting from 0
    */
    int                     active_cnt = `NEVER_BE_ACTIVE;
    /*
        sync_evt_name: uniq string to pass down to each resource for sync
    */
    string                  sync_evt_name;

    mem_man                 mm;
    surface_generator       surface_gen;
    /*
        cov: used to measure constraint quality before RTL is ready.
    */
    bit                     fcov_en = 0;
    static nvdla_coverage_top cov;
    
    /*
        methods
    */
    extern function         new(string name, uvm_component parent);
    extern function void    build_phase(uvm_phase phase);
    /*
        set_sync_evt_name: scenario is responsible of setting sync event name to resources being used
        * for scenario containts mulitple resources: 
            ** If a resource has its own interrupt, a uniq event name must be passed down to resource,
               and resource must pair up sync event and its interrupt accordingly
            ** If a resource doesn't have its own interrupt, scenario must make sure a valid sync event gets passed down to resouce,
               A sync event is considered valid when it has paired up with a resource interrupt.
               Resource with no interrupt will wait for event to be triggered by other resources.

        For example, in PDP+PDP_RDMA scenario, PDP_RDMA relies on PDP interrupt, so scenario must make sure both resources gets the same sync event
        Please check scenario class for detail
    */
    extern function      set_sync_evt_name();

    extern virtual function void set_sim_constraint();

    extern function void pre_randomize();
    extern function void post_randomize();
    
    extern function void print_comment(int fh, string comment);
    extern function void mem_load(int fh, string mem_domain, longint unsigned base_addr, string file_name);

    extern function void check_nothing(int fh, string event_name);

    `uvm_component_utils(nvdla_base_scenario)
endclass : nvdla_base_scenario

function nvdla_base_scenario::new(string name, uvm_component parent);
    super.new(name, parent);
    sync_evt_name = "NOT_SET";
    inst_name = name;

    if ($test$plusargs("fcov_en"))
        fcov_en = 1;
endfunction : new

function void nvdla_base_scenario::build_phase(uvm_phase phase);
    super.build_phase(phase);

    mm = mem_man::get_mem_man();
    surface_gen = surface_generator::type_id::create("surface_generator",this);
    if (fcov_en)
        cov = nvdla_coverage_top::type_id::create("cov", this);
endfunction: build_phase

function nvdla_base_scenario::set_sync_evt_name();
    ;
endfunction: set_sync_evt_name

function void nvdla_base_scenario::set_sim_constraint();
        `uvm_info(inst_name, $sformatf("set sim constraint knobs"), UVM_MEDIUM)
endfunction: set_sim_constraint

function void nvdla_base_scenario::pre_randomize();
    set_sim_constraint();
endfunction: pre_randomize

function void nvdla_base_scenario::post_randomize();
endfunction: post_randomize

function void nvdla_base_scenario::print_comment(int fh, string comment);
    $fwrite(fh,"// %s\n", comment);
endfunction: print_comment

function void nvdla_base_scenario::mem_load(int fh, string mem_domain, longint unsigned base_addr, string file_name);
    $fwrite(fh,"mem_load(%s,0x%0h,\"%s\");\n",mem_domain,base_addr,file_name);
endfunction: mem_load

function void nvdla_base_scenario::check_nothing(int fh, string event_name);
    $fwrite(fh,"check_nothing(%s);\n",event_name);
endfunction: check_nothing

`endif //_NVDLA_BASE_SCENARIO_SV_
