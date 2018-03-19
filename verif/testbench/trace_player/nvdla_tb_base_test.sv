`ifndef _NVDLA_TB_BASE_TEST_SV_
`define _NVDLA_TB_BASE_TEST_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_tb_base_test
//
// @description
//-------------------------------------------------------------------------------------

class nvdla_tb_base_test extends uvm_test;

    string                  tID;

    nvdla_tb_env            env;
    nvdla_tb_trace_parser   trace_parser;
    nvdla_tb_sequence       seq;
    nvdla_tb_result_checker result_ck;

    ral_sys_top             ral;

    string      pri_memif_random_enable = "DISABLE";
    string      sec_memif_random_enable = "DISABLE";
    string      work_mode = "CROSS_CHECK";

    //:| internal_instance_list = [
    //:|                          'csc_dat_a' ,
    //:|                          'csc_dat_b' ,
    //:|                          'csc_wt_a'  ,
    //:|                          'csc_wt_b'  ,
    //:|                          'cmac_a'    ,
    //:|                          'cmac_b'    ,
    //:|                          'cacc'      ,
    //:|                          'sdp'       ,
    //:|                          ]
    //:| for inst in internal_instance_list:
    //:|     print('    string %s_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";' % inst)
    //:|
    //:| dma_list       = ['bdma', 'sdp', 'pdp', 'cdp', 'rbk', 'sdp_b', 'sdp_n', 'sdp_e', 'cdma_dat', 'cdma_wt']
    //:| mem_if_list    = ['pri_mem', 'sec_mem']
    //:| kind_list      = ['request', 'response']
    //:| for dma in dma_list:
    //:|     for mem_if in mem_if_list:
    //:|         for kind in kind_list:
    //:|             print('    string %(dma)s_%(mem_if)s_%(kind)s_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";' % {'dma':dma, 'mem_if':mem_if, 'kind':kind})

    //----------------------------------------------------------CONFIGURATION PARAMETERS
    // NVDLA_TB_BASE_TEST Configuration Parameters. These parameters can be controlled
    // through the UVM configuration database
    // @{

    // }@

    `uvm_component_utils_begin(nvdla_tb_base_test)
        `uvm_field_string(work_mode, UVM_ALL_ON)
        //:| internal_instance_list = [
        //:|                          'csc_dat_a' ,
        //:|                          'csc_dat_b' ,
        //:|                          'csc_wt_a'  ,
        //:|                          'csc_wt_b'  ,
        //:|                          'cmac_a'    ,
        //:|                          'cmac_b'    ,
        //:|                          'cacc'      ,
        //:|                          'sdp'       ,
        //:|                          ]
        //:| for inst in internal_instance_list:
        //:|     print("        `uvm_field_string(%s_compare_mode, UVM_ALL_ON)" % inst)
        //:|
        //:| dma_list       = ['bdma', 'sdp', 'pdp', 'cdp', 'rbk', 'sdp_b', 'sdp_n', 'sdp_e', 'cdma_dat', 'cdma_wt']
        //:| mem_if_list    = ['pri_mem', 'sec_mem']
        //:| kind_list      = ['request', 'response']
        //:| for dma in dma_list:
        //:|     for mem_if in mem_if_list:
        //:|         for kind in kind_list:
        //:|             print("        `uvm_field_string(%(dma)s_%(mem_if)s_%(kind)s_compare_mode, UVM_ALL_ON)" % {'dma':dma, 'mem_if':mem_if, 'kind':kind})
    `uvm_component_utils_end

    extern function new(string name = "nvdla_tb_base_test", uvm_component parent = null);

    //------------------------------------------------------------------------UVM Phases
    // Not all phases are needed, just enable specific phases for different component
    // @{

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern function void start_of_simulation_phase(uvm_phase phase);
    extern task          run_phase(uvm_phase phase);
    extern task          reset_phase(uvm_phase phase);
    extern task          configure_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
    extern task          shutdown_phase(uvm_phase phase);
    extern function void extract_phase(uvm_phase phase);
    extern function void check_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
    extern function void final_phase(uvm_phase phase);
    extern function void pre_abort();
    extern function void do_report();

    // }@

endclass : nvdla_tb_base_test

// Function: new
// Creates a new nvdla_tb_base_test component
function nvdla_tb_base_test::new(string name = "nvdla_tb_base_test", uvm_component parent = null);
    super.new(name, parent);
    tID = get_type_name().toupper();

    // type/instance orverride
    set_type_override_by_type(uvm_tlm_gp::get_type(), my_uvm_tlm_gp::get_type());
endfunction : new

// Function: build_phase
// Used to construct testbench components, build top-level testbench topology
function void nvdla_tb_base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)

    env             = nvdla_tb_env::type_id::create("env", this);
    trace_parser    = nvdla_tb_trace_parser::type_id::create("trace_parser", this);
    seq             = nvdla_tb_sequence::type_id::create("seq", this);
    result_ck       = nvdla_tb_result_checker::type_id::create("result_ck", this);

    // construct RAL MODEL
    ral = ral_sys_top::type_id::create("ral", this);
    ral.build();
    ral.set_hdl_path_root("nvdla_tp_top.DLA_DUT");
    ral.lock_model();
    ral.reset();

    // configure ral model handle to any components needed
    uvm_config_db#(ral_sys_top)::set(this, "*", "ral", ral);

	// Configuration setup
    uvm_config_db#(string)::set(this, "*", "pri_memif_random_enable",    pri_memif_random_enable);
    uvm_config_db#(string)::set(this, "*", "sec_memif_random_enable",    sec_memif_random_enable);
    if($value$plusargs("WORK_MODE=%0s", work_mode)) begin
        `uvm_info(tID, $sformatf("Setting WORK_MODE:%0s", work_mode), UVM_MEDIUM)
    end

    // map = scb_name:monitor_name
    //
    //:| scb_map = {
    //:|     'csc_dat_a' : 'sc2mac_dat_a',
    //:|     'csc_dat_b' : 'sc2mac_dat_b',
    //:|     'csc_wt_a'  : 'sc2mac_wt_a' ,
    //:|     'csc_wt_b'  : 'sc2mac_wt_b' ,
    //:|     'cmac_a'    : 'mac_a2accu'  ,
    //:|     'cmac_b'    : 'mac_b2accu'  ,
    //:| }
    //:| for (k,v) in scb_map.items():
    //:|     msg = '''
    //:|     case(%(scb)s_compare_mode)
    //:|         "COMPARE_MODE_DISABLE": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_conv_core_socket_convertor_inst", "%(monitor)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_NOT_SAMPLING);
    //:|          end
    //:|         "COMPARE_MODE_RTL_AHEAD": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_conv_core_socket_convertor_inst", "%(monitor)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_RTL_AHEAD);
    //:|          end
    //:|         "COMPARE_MODE_RTL_GATING_CMOD": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_conv_core_socket_convertor_inst", "%(monitor)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_RTL_GATING_CMOD);
    //:|          end
    //:|         "COMPARE_MODE_LOOSE_COMPARE": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_conv_core_socket_convertor_inst", "%(monitor)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_PASSTHROUGH);
    //:|          end
    //:|         "COMPARE_MODE_COUNT_TXN_ONLY": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_conv_core_socket_convertor_inst", "%(monitor)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_PASSTHROUGH);
    //:|          end
    //:|          default: begin
    //:|              `uvm_error(tID, {"Unsupported scoreboard working mode: ", %(scb)s_compare_mode})
    //:|          end
    //:|     endcase
    //:| ''' % {'scb':k, 'monitor':v}
    //:|     print(msg)


    // map = scb_name:monitor_name
    //
    //:| scb_map = {
    //:|     'cacc' : 'cacc2sdp',
    //:|     'sdp'  : 'sdp2pdp',
    //:| }
    //:| for (k,v) in scb_map.items():
    //:|     msg = '''
    //:|     case(%(scb)s_compare_mode)
    //:|         "COMPARE_MODE_DISABLE": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_post_processing_socket_convertor_inst", "%(monitor)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_NOT_SAMPLING);
    //:|          end
    //:|         "COMPARE_MODE_RTL_AHEAD": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_post_processing_socket_convertor_inst", "%(monitor)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_RTL_AHEAD);
    //:|          end
    //:|         "COMPARE_MODE_RTL_GATING_CMOD": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_post_processing_socket_convertor_inst", "%(monitor)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_RTL_GATING_CMOD);
    //:|          end
    //:|         "COMPARE_MODE_LOOSE_COMPARE": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_post_processing_socket_convertor_inst", "%(monitor)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_PASSTHROUGH);
    //:|          end
    //:|         "COMPARE_MODE_COUNT_TXN_ONLY": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_post_processing_socket_convertor_inst", "%(monitor)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_PASSTHROUGH);
    //:|          end
    //:|          default: begin
    //:|              `uvm_error(tID, {"Unsupported scoreboard working mode: ", %(scb)s_compare_mode})
    //:|          end
    //:|     endcase
    //:| ''' % {'scb':k, 'monitor':v}
    //:|     print(msg)

    // DMA convertor, general
    //
    //:| read_dma_list  = ['bdma', 'sdp', 'pdp', 'cdp', 'rbk', 'sdp_b', 'sdp_n', 'sdp_e', 'cdma_dat', 'cdma_wt']
    //:| write_dma_list = ['bdma', 'sdp', 'pdp', 'cdp', 'rbk']
    //:| mem_if_list    = ['pri_mem', 'sec_mem']
    //:| kind_list      = ['request', 'response']
    //:| for dma in read_dma_list:
    //:|     for mem_if in mem_if_list:
    //:|        for kind in kind_list:
    //:|            msg = '''
    //:|     case(%(monitor)s_%(mem_if)s_%(kind)s_compare_mode)
    //:|         "COMPARE_MODE_DISABLE": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_dma_convertor_%(mem_if)s", "%(monitor)s_read_%(kind)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_NOT_SAMPLING);
    //:|          end
    //:|         "COMPARE_MODE_RTL_AHEAD": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_dma_convertor_%(mem_if)s", "%(monitor)s_read_%(kind)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_RTL_AHEAD);
    //:|          end
    //:|         "COMPARE_MODE_RTL_GATING_CMOD": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_dma_convertor_%(mem_if)s", "%(monitor)s_read_%(kind)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_RTL_GATING_CMOD);
    //:|          end
    //:|         "COMPARE_MODE_LOOSE_COMPARE": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_dma_convertor_%(mem_if)s", "%(monitor)s_read_%(kind)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_PASSTHROUGH);
    //:|          end
    //:|         "COMPARE_MODE_COUNT_TXN_ONLY": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_dma_convertor_%(mem_if)s", "%(monitor)s_read_%(kind)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_PASSTHROUGH);
    //:|          end
    //:|          default: begin
    //:|              `uvm_error(tID, {"Unsupported scoreboard working mode: ", %(monitor)s_%(mem_if)s_%(kind)s_compare_mode})
    //:|          end
    //:|     endcase
    //:| ''' % {'monitor':dma, 'mem_if':mem_if, 'kind':kind}
    //:|            print(msg)
    //:| for dma in write_dma_list:
    //:|     for mem_if in mem_if_list:
    //:|        for kind in kind_list:
    //:|            msg = '''
    //:|     case(%(monitor)s_%(mem_if)s_%(kind)s_compare_mode)
    //:|         "COMPARE_MODE_DISABLE": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_dma_convertor_%(mem_if)s", "%(monitor)s_write_%(kind)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_NOT_SAMPLING);
    //:|          end
    //:|         "COMPARE_MODE_RTL_AHEAD": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_dma_convertor_%(mem_if)s", "%(monitor)s_write_%(kind)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_RTL_AHEAD);
    //:|          end
    //:|         "COMPARE_MODE_RTL_GATING_CMOD": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_dma_convertor_%(mem_if)s", "%(monitor)s_write_%(kind)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_RTL_GATING_CMOD);
    //:|          end
    //:|         "COMPARE_MODE_LOOSE_COMPARE": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_dma_convertor_%(mem_if)s", "%(monitor)s_write_%(kind)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_PASSTHROUGH);
    //:|          end
    //:|         "COMPARE_MODE_COUNT_TXN_ONLY": begin
    //:|              uvm_config_int::set(this, "*.rm_nvdla_dma_convertor_%(mem_if)s", "%(monitor)s_write_%(kind)s_initial_credit", SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_PASSTHROUGH);
    //:|          end
    //:|          default: begin
    //:|              `uvm_error(tID, {"Unsupported scoreboard working mode: ", %(monitor)s_%(mem_if)s_%(kind)s_compare_mode})
    //:|          end
    //:|     endcase
    //:| ''' % {'monitor':dma, 'mem_if':mem_if, 'kind':kind}
    //:|            print(msg)

    // Parse compare mode, determine scoreboard compare mode
    // #0, convolution core and sdp convertor
    //
    //:| conv_and_sdp_internal_instance_list = [
    //:|                                       'csc_dat_a' ,
    //:|                                       'csc_dat_b' ,
    //:|                                       'csc_wt_a'  ,
    //:|                                       'csc_wt_b'  ,
    //:|                                       'cmac_a'    ,
    //:|                                       'cmac_b'    ,
    //:|                                       'cacc'      ,
    //:|                                       'sdp'       ,
    //:|                                       ]
    //:| for inst in conv_and_sdp_internal_instance_list:
    //:|     scb = inst + '_sb'
    //:|     msg = '''
    //:|     case(%(inst)s_compare_mode)
    //:|         "COMPARE_MODE_DISABLE": begin
    //:|              uvm_config_int::set(this, "*.%(scb)s",      "response_ck_enable",      0);
    //:|          end
    //:|         "COMPARE_MODE_RTL_AHEAD": begin
    //:|              uvm_config_int::set(this, "*.%(scb)s",      "response_compare_mode",      COMPARE_MODE_RTL_AHEAD);
    //:|          end
    //:|         "COMPARE_MODE_RTL_GATING_CMOD": begin
    //:|              uvm_config_int::set(this, "*.%(scb)s",      "response_compare_mode",      COMPARE_MODE_RTL_GATING_CMOD);
    //:|          end
    //:|         "COMPARE_MODE_LOOSE_COMPARE": begin
    //:|              uvm_config_int::set(this, "*.%(scb)s",      "response_compare_mode",      COMPARE_MODE_LOOSE_COMPARE);
    //:|          end
    //:|         "COMPARE_MODE_COUNT_TXN_ONLY": begin
    //:|              uvm_config_int::set(this, "*.%(scb)s",      "response_compare_mode",      COMPARE_MODE_COUNT_TXN_ONLY);
    //:|         end
    //:|         default: begin
    //:|             `uvm_error(tID, {"Unsupported scoreboard working mode: ", %(inst)s_compare_mode})
    //:|         end
    //:|     endcase
    //:| ''' % {'inst':inst, 'scb':scb}
    //:|     print(msg)

    // #1, DMA convertor
    //
    //:| dma_list       = ['bdma', 'sdp', 'pdp', 'cdp', 'rbk', 'sdp_b', 'sdp_n', 'sdp_e', 'cdma_dat', 'cdma_wt']
    //:| mem_if_list    = ['pri_mem', 'sec_mem']
    //:| kind_list      = ['request', 'response']
    //:| for dma in dma_list:
    //:|     for mem_if in mem_if_list:
    //:|         for kind in kind_list:
    //:|             msg = '''
    //:|     case(%(dma)s_%(mem_if)s_%(kind)s_compare_mode)
    //:|         "COMPARE_MODE_DISABLE": begin
    //:|              uvm_config_int::set(this, "*.%(dma)s_%(mem_if)s_sb",      "%(kind)s_ck_enable",      0);
    //:|          end
    //:|         "COMPARE_MODE_RTL_AHEAD": begin
    //:|              uvm_config_int::set(this, "*.%(dma)s_%(mem_if)s_sb",         "%(kind)s_compare_mode",   COMPARE_MODE_RTL_AHEAD);
    //:|          end
    //:|         "COMPARE_MODE_RTL_GATING_CMOD": begin
    //:|              uvm_config_int::set(this, "*.%(dma)s_%(mem_if)s_sb",      "%(kind)s_compare_mode",      COMPARE_MODE_RTL_GATING_CMOD);
    //:|          end
    //:|         "COMPARE_MODE_LOOSE_COMPARE": begin
    //:|              uvm_config_int::set(this, "*.%(dma)s_%(mem_if)s_sb",      "%(kind)s_compare_mode",      COMPARE_MODE_LOOSE_COMPARE);
    //:|          end
    //:|         "COMPARE_MODE_COUNT_TXN_ONLY": begin
    //:|              uvm_config_int::set(this, "*.%(dma)s_%(mem_if)s_sb",      "%(kind)s_compare_mode",      COMPARE_MODE_COUNT_TXN_ONLY);
    //:|         end
    //:|         default: begin
    //:|             `uvm_error(tID, {"Unsupported scoreboard working mode: ", %(dma)s_%(mem_if)s_%(kind)s_compare_mode})
    //:|         end
    //:|     endcase
    //:| ''' % {'dma':dma, 'mem_if':mem_if, 'kind':kind}
    //:|             print(msg)
endfunction : build_phase

// Function: connect_phase
// Used to connect components/tlm ports for environment topoloty
function void nvdla_tb_base_test::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)
    trace_parser.sequence_command_port.connect(seq.cmd_fifo.analysis_export);
    trace_parser.interrupt_handler_command_port.connect(env.rm_intr_hdlr.cmd_fifo.analysis_export);
    trace_parser.interrupt_handler_command_port.connect(env.intr_hdlr.cmd_fifo.analysis_export);
    trace_parser.result_checker_command_port.connect(result_ck.command_fifo.analysis_export);

    trace_parser.primary_memory_model_command_port.connect(env.pri_mem.mmc_fifo.analysis_export);
    trace_parser.primary_memory_model_command_port.connect(env.rm_pri_mem.mmc_fifo.analysis_export);
    seq.ini_socket.connect(env.rm_inst.rm_csb_target);
    if("CMOD_ONLY"==work_mode) begin
        result_ck.primary_memory_check_command_port.connect(env.rm_pri_mem.rcc_fifo.analysis_export);
    end else begin
        result_ck.primary_memory_check_command_port.connect(env.pri_mem.rcc_fifo.analysis_export);
    end
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
        trace_parser.secondary_memory_model_command_port.connect(env.sec_mem.mmc_fifo.analysis_export);
        trace_parser.secondary_memory_model_command_port.connect(env.rm_sec_mem.mmc_fifo.analysis_export);
        if("CMOD_ONLY"==work_mode) begin
            result_ck.secondary_memory_check_command_port.connect(env.rm_sec_mem.rcc_fifo.analysis_export);
        end else begin
            result_ck.secondary_memory_check_command_port.connect(env.sec_mem.rcc_fifo.analysis_export);
        end
    `endif
endfunction : connect_phase

// Function: end_of_elaboration_phase
// Used to make any final adjustments to the env topology
function void nvdla_tb_base_test::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(tID, $sformatf("end_of_elaboration_phase begin ..."), UVM_HIGH)

    if (get_report_verbosity_level() >= UVM_HIGH) begin
        uvm_factory factory = uvm_factory::get();
        factory.print();
    end
    uvm_top.print_topology();
endfunction : end_of_elaboration_phase

// Function: start_of_simulation_phase
// Used to configure verification componets, printing
function void nvdla_tb_base_test::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(tID, $sformatf("start_of_simulation_phase begin ..."), UVM_HIGH)

    // Avoid excessive don't-care warnings in log file
    uvm_top.set_report_severity_id_action_hier(UVM_WARNING, "UVM/RSRC/NOREGEX", UVM_NO_ACTION);
    uvm_top.set_report_severity_id_action_hier(UVM_WARNING, "UVM/COMP/NAME", UVM_NO_ACTION);
endfunction : start_of_simulation_phase

// TASK: run_phase
// Used to execute run-time tasks of simulation
task nvdla_tb_base_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(tID, $sformatf("run_phase begin ..."), UVM_HIGH)

    phase.phase_done.set_drain_time(this, 50ps);
endtask : run_phase

// TASK: reset_phase
// The reset phase is reserved for DUT or interface specific reset behavior
task nvdla_tb_base_test::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(tID, $sformatf("reset_phase begin ..."), UVM_HIGH)

endtask : reset_phase

// TASK: configure_phase
// Used to program the DUT or memoried in the testbench
task nvdla_tb_base_test::configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    `uvm_info(tID, $sformatf("configure_phase begin ..."), UVM_HIGH)

endtask : configure_phase

// TASK: main_phase
// Used to execure mainly run-time tasks of simulation
task nvdla_tb_base_test::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_HIGH)

    phase.phase_done.set_drain_time(this, 50ps);
endtask : main_phase

// TASK: shutdown_phase
// Data "drain" and other operations for graceful termination
task nvdla_tb_base_test::shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    `uvm_info(tID, $sformatf("shutdown_phase begin ..."), UVM_HIGH)

endtask : shutdown_phase

// Function: extract_phase
// Used to retrieve final state of DUTG and details of scoreboard, etc.
function void nvdla_tb_base_test::extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(tID, $sformatf("extract_phase begin ..."), UVM_HIGH)

endfunction : extract_phase

// Function: check_phase
// Used to process and check the simulation results
function void nvdla_tb_base_test::check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info(tID, $sformatf("check_phase begin ..."), UVM_HIGH)

endfunction : check_phase

// Function: report_phase
// Simulation results analysis and reports
function void nvdla_tb_base_test::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(tID, $sformatf("report_phase begin ..."), UVM_HIGH)

    do_report();
endfunction : report_phase

// Function: final_phase
// Used to complete/end any outstanding actions of testbench
function void nvdla_tb_base_test::final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info(tID, $sformatf("final_phase begin ..."), UVM_HIGH)

endfunction : final_phase

function void nvdla_tb_base_test::pre_abort();
    super.pre_abort();
    do_report();
endfunction

function void nvdla_tb_base_test::do_report();
    uvm_report_server rs = uvm_report_server::get_server();
    if (rs.get_severity_count(UVM_FATAL) + rs.get_severity_count(UVM_ERROR) == 0) begin
        $display("*******************************");
        $display("**        TEST PASS          **");
        $display("*******************************");
    end else begin
        $display("*******************************");
        $display("**        TEST FAILED        **");
        $display("*******************************");
    end
endfunction

`endif // _NVDLA_TB_BASE_TEST_SV_
