`ifndef _NVDLA_TB_SCOREBOARD_SV_
`define _NVDLA_TB_SCOREBOARD_SV_

import nvdla_tb_common_pkg::*;
import nvdla_scsv_pkg::*;  // Temperal used
import csb_pkg::*;
import dbb_pkg::*;
import dma_pkg::*;
import cc_pkg::*;
import dp_pkg::*;
import nvdla_ral_pkg::*;
import mem_pkg::*;
import rm_nvdla_top_pkg::*;

////////////////////////////////////////////////////////////////////////////
/// class: scoreboard_checker
////////////////////////////////////////////////////////////////////////////
class scoreboard_checker extends uvm_component;

    string tID;
    uvm_comparer comparer;

    `uvm_component_utils(scoreboard_checker)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        tID = get_type_name();
        tID = tID.toupper();
        comparer = new();
        comparer.show_max = 200;
        comparer.sev = UVM_INFO;
        comparer.check_type = 0;
    endfunction : new

    virtual function request_txn_compre(uvm_sequence_item act_tr, uvm_sequence_item exp_tr);
        `uvm_info(tID, $sformatf("request txn compare"), UVM_DEBUG)
        return act_tr.compare(exp_tr, comparer);
    endfunction : request_txn_compre

    virtual function response_txn_compare(uvm_sequence_item act_tr, uvm_sequence_item exp_tr);
        `uvm_info(tID, $sformatf("response txn compare"), UVM_DEBUG)
        return act_tr.compare(exp_tr, comparer);
    endfunction : response_txn_compare

endclass : scoreboard_checker

typedef class scoreboard_template;

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_tb_scoreboard_container
//
// @description
//-------------------------------------------------------------------------------------

class nvdla_tb_scoreboard_container extends uvm_scoreboard;

    string                         tID;

    //:| global project
    //:| import project
    //:| global dma_ports
    //:| dma_ports = ["cdma_wt", "cdma_dat", "sdp"]
    //:| if "NVDLA_SDP_BS_ENABLE" in project.PROJVAR: dma_ports.append("sdp_b")
    //:| if "NVDLA_SDP_BN_ENABLE" in project.PROJVAR: dma_ports.append("sdp_n")
    //:| if "NVDLA_SDP_EW_ENABLE" in project.PROJVAR: dma_ports.append("sdp_e")
    //:| if "NVDLA_PDP_ENABLE"    in project.PROJVAR: dma_ports.append("pdp")
    //:| if "NVDLA_CDP_ENABLE"    in project.PROJVAR: dma_ports.append("cdp")
    //:| if "NVDLA_BDMA_ENABLE"   in project.PROJVAR: dma_ports.append("bdma")
    //:| if "NVDLA_RUBIK_ENABLE"  in project.PROJVAR: dma_ports.append("rbk")
    //:| for dma in dma_ports: print("    scoreboard_template#(dma_txn)   %0s_pri_mem_sb;" % dma)
    //:| if "NVDLA_SECONDARY_MEMIF_ENABLE" in project.PROJVAR:
    //:|     for dma in dma_ports: print("    scoreboard_template#(dma_txn)   %0s_sec_mem_sb;" % dma)

    scoreboard_template#(cc_txn#(CSC_DT_DW,CSC_DT_DS))    csc_dat_a_sb;
    scoreboard_template#(cc_txn#(CSC_WT_DW,CSC_WT_DS))    csc_wt_a_sb;
    scoreboard_template#(cc_txn#(CSC_DT_DW,CSC_DT_DS))    csc_dat_b_sb;
    scoreboard_template#(cc_txn#(CSC_WT_DW,CSC_WT_DS))    csc_wt_b_sb;
    scoreboard_template#(cc_txn#(CMAC_DW,CMAC_DS))        cmac_a_sb;
    scoreboard_template#(cc_txn#(CMAC_DW,CMAC_DS))        cmac_b_sb;
    scoreboard_template#(dp_txn#(CACC_DW,CACC_DS))        cacc_sb;
    scoreboard_template#(dp_txn#(SDP_DW,SDP_DS))          sdp_sb;

    //scoreboard_template#(int)      intr_sb;
    scoreboard_template#(uvm_tlm_gp)   pri_mem_sb;
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    scoreboard_template#(uvm_tlm_gp)   sec_mem_sb;
    `endif

    //----------------------------------------------------------CONFIGURATION PARAMETERS
    // NVDLA_TB_SCOREBOARD Configuration Parameters. These parameters can be controlled through
    // the UVM configuration database
    // @{

    // }@

    `uvm_component_utils_begin(nvdla_tb_scoreboard_container)
    `uvm_component_utils_end

    extern function new(string name = "nvdla_tb_scoreboard_container", uvm_component parent = null);

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

    // }@

endclass : nvdla_tb_scoreboard_container

// Function: new
// Creates a new nvdla_tb_scoreboard_container component
function nvdla_tb_scoreboard_container::new(string name = "nvdla_tb_scoreboard_container", uvm_component parent = null);
    super.new(name, parent);
    tID = get_type_name().toupper();
endfunction : new

// Function: build_phase
// Used to construct testbench components, build top-level testbench topology
function void nvdla_tb_scoreboard_container::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)

    //:| for dma in dma_ports:
    //:|     temp = dma + "_pri_mem_sb"
    //:|     print("    %-18s = scoreboard_template#(dma_txn)::type_id::create(\"%0s_pri_mem_sb\", this);" % (temp, dma))
    //:| if "NVDLA_SECONDARY_MEMIF_ENABLE" in project.PROJVAR:
    //:|     for dma in dma_ports:
    //:|         temp = dma + "_sec_mem_sb"
    //:|         print("    %-18s = scoreboard_template#(dma_txn)::type_id::create(\"%0s_sec_mem_sb\", this);" % (temp, dma))

    csc_dat_a_sb   = scoreboard_template#(cc_txn#(CSC_DT_DW,CSC_DT_DS))::type_id::create("csc_dat_a_sb", this);
    csc_wt_a_sb    = scoreboard_template#(cc_txn#(CSC_WT_DW,CSC_WT_DS))::type_id::create("csc_wt_a_sb",  this);
    csc_dat_b_sb   = scoreboard_template#(cc_txn#(CSC_DT_DW,CSC_DT_DS))::type_id::create("csc_dat_b_sb", this);
    csc_wt_b_sb    = scoreboard_template#(cc_txn#(CSC_WT_DW,CSC_WT_DS))::type_id::create("csc_wt_b_sb",  this);
    cmac_a_sb      = scoreboard_template#(cc_txn#(CMAC_DW,CMAC_DS))::type_id::create("cmac_a_sb",   this);
    cmac_b_sb      = scoreboard_template#(cc_txn#(CMAC_DW,CMAC_DS))::type_id::create("cmac_b_sb",   this);
    cacc_sb        = scoreboard_template#(dp_txn#(CACC_DW,CACC_DS))::type_id::create("cacc_sb",      this);
    sdp_sb         = scoreboard_template#(dp_txn#(SDP_DW,SDP_DS))::type_id::create("sdp_sb",     this);

    pri_mem_sb   = scoreboard_template#(uvm_tlm_gp)::type_id::create("pri_mem_sb",  this);
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    sec_mem_sb   = scoreboard_template#(uvm_tlm_gp)::type_id::create("sec_mem_sb",  this);
    `endif
endfunction : build_phase

// Function: connect_phase
// Used to connect components/tlm ports for environment topoloty
function void nvdla_tb_scoreboard_container::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)

endfunction : connect_phase

// Function: end_of_elaboration_phase
// Used to make any final adjustments to the env topology
function void nvdla_tb_scoreboard_container::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(tID, $sformatf("end_of_elaboration_phase begin ..."), UVM_HIGH)

endfunction : end_of_elaboration_phase

// Function: start_of_simulation_phase
// Used to configure verification componets, printing
function void nvdla_tb_scoreboard_container::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(tID, $sformatf("start_of_simulation_phase begin ..."), UVM_HIGH)

endfunction : start_of_simulation_phase

// TASK: run_phase
// Used to execute run-time tasks of simulation
task nvdla_tb_scoreboard_container::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(tID, $sformatf("run_phase begin ..."), UVM_HIGH)

endtask : run_phase

// TASK: reset_phase
// The reset phase is reserved for DUT or interface specific reset behavior
task nvdla_tb_scoreboard_container::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(tID, $sformatf("reset_phase begin ..."), UVM_HIGH)

endtask : reset_phase

// TASK: configure_phase
// Used to program the DUT or memoried in the testbench
task nvdla_tb_scoreboard_container::configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    `uvm_info(tID, $sformatf("configure_phase begin ..."), UVM_HIGH)

endtask : configure_phase

// TASK: main_phase
// Used to execure mainly run-time tasks of simulation
task nvdla_tb_scoreboard_container::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_HIGH)

endtask : main_phase

// TASK: shutdown_phase
// Data "drain" and other operations for graceful termination
task nvdla_tb_scoreboard_container::shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    `uvm_info(tID, $sformatf("shutdown_phase begin ..."), UVM_HIGH)

endtask : shutdown_phase

// Function: extract_phase
// Used to retrieve final state of DUTG and details of scoreboard, etc.
function void nvdla_tb_scoreboard_container::extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(tID, $sformatf("extract_phase begin ..."), UVM_HIGH)

endfunction : extract_phase

// Function: check_phase
// Used to process and check the simulation results
function void nvdla_tb_scoreboard_container::check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info(tID, $sformatf("check_phase begin ..."), UVM_HIGH)

endfunction : check_phase

// Function: report_phase
// Simulation results analysis and reports
function void nvdla_tb_scoreboard_container::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(tID, $sformatf("report_phase begin ..."), UVM_HIGH)

endfunction : report_phase

// Function: final_phase
// Used to response/end any outstanding actions of testbench
function void nvdla_tb_scoreboard_container::final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info(tID, $sformatf("final_phase begin ..."), UVM_HIGH)

endfunction : final_phase

/////////////////////////////////////////////////////////////
///
///              class scoreboard_template
///
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
class scoreboard_template #(type TRANS = int) extends uvm_scoreboard;

    typedef  TRANS txn_q[$]; // TXN QUEUE for specific ID & KIND
    string   kind_t[int] = '{0:"WRITE", 1:"READ"};// 0:write (or don't care) 1:read
    // FIXME, DMA_ID shall use project value
    string   dma_t[int]  = '{-1:"NULL", 0:"BDMA", 1:"SDP", 2:"PDP", 3:"CDP", 4:"RBK", 5:"SDP_B", 6:"SDP_N", 7:"SDP_E", 8:"CDMA_DAT", 9:"CDMA_WT"};

    string   tID;
    string   info_flag;
    bit      sb_enable                      = 1;
    bit      eot_enable                     = 1;   // End of test check
    bit      request_ck_enable              = 1;
    bit      response_ck_enable             = 1;
    // int      initial_request_credit_num     = 1;
    // int      initial_response_credit_num    = 1;

    // COMPARE MODE:
    //  - "COMPARE_MODE_RTL_AHEAD"       : RTL send txn before CMOD (to let CMOD follows RTL's arbiter order in weight compression test)
    //  - "COMPARE_MODE_RTL_GATING_CMOD" : Involve back-pressure to reduce memory resources occupasion.
    //  - "COMPARE_MODE_LOOSE_COMPARE"   : CMOD generates all txns one time.
    //  - "COMPARE_MODE_COUNT_TXN_ONLY"  : Do txn counting, don't push txn to queue.
    int      request_compare_mode  = COMPARE_MODE_LOOSE_COMPARE;
    int      response_compare_mode = COMPARE_MODE_LOOSE_COMPARE;
    //int      total_dut_txn_cnt   = 0;
    //int      total_cmod_txn_cnt  = 0;
    //int      pass_txn_cnt        = 0;
    //int      err_txn_cnt         = 0;

    // Trace player has three work modes for different usages:
    // CMOD_ONLY:   only cmod is working
    // RTL_ONLY:    only DUT rtl is working
    // CROSS_CHECK: default verfication mode, cross check between RTL and CMOD
    string   work_mode = "CROSS_CHECK";

    // associative array for each TXN ID
    // 1st dimen -> TXN ID (-1~9); 2nd dimen -> 0 for read (or don't care), 1 for write
    // Initialize associative array with empty queue
    txn_q    act_req_txn_q[int][int] = '{-1:'{0:{},1:{}},0:'{0:{},1:{}},1:'{0:{},1:{}},2:'{0:{},1:{}},3:'{0:{},1:{}},4:'{0:{},1:{}},5:'{0:{},1:{}},6:'{0:{},1:{}},7:'{0:{},1:{}},8:'{0:{},1:{}},9:'{0:{},1:{}}};
    txn_q    exp_req_txn_q[int][int] = '{-1:'{0:{},1:{}},0:'{0:{},1:{}},1:'{0:{},1:{}},2:'{0:{},1:{}},3:'{0:{},1:{}},4:'{0:{},1:{}},5:'{0:{},1:{}},6:'{0:{},1:{}},7:'{0:{},1:{}},8:'{0:{},1:{}},9:'{0:{},1:{}}};
    txn_q    act_txn_q[int][int]     = '{-1:'{0:{},1:{}},0:'{0:{},1:{}},1:'{0:{},1:{}},2:'{0:{},1:{}},3:'{0:{},1:{}},4:'{0:{},1:{}},5:'{0:{},1:{}},6:'{0:{},1:{}},7:'{0:{},1:{}},8:'{0:{},1:{}},9:'{0:{},1:{}}};
    txn_q    exp_txn_q[int][int]     = '{-1:'{0:{},1:{}},0:'{0:{},1:{}},1:'{0:{},1:{}},2:'{0:{},1:{}},3:'{0:{},1:{}},4:'{0:{},1:{}},5:'{0:{},1:{}},6:'{0:{},1:{}},7:'{0:{},1:{}},8:'{0:{},1:{}},9:'{0:{},1:{}}};

    int      act_req_cnt_q[int][int];
    int      act_cnt_q[int][int];
    int      exp_req_cnt_q[int][int];
    int      exp_cnt_q[int][int];

    int      pass_req_cnt_q[int][int];
    int      err_req_cnt_q[int][int];
    int      pass_cnt_q[int][int];
    int      err_cnt_q[int][int];

    int      sec_mem_rd_os_cnt; // sec_mem outstanding txn cnt
    int      sec_mem_wt_os_cnt; // sec_mem outstanding txn cnt
    int      pri_mem_rd_os_cnt; // emem outstanding txn cnt
    int      pri_mem_wt_os_cnt; // emem outstanding txn cnt

    int      sec_mem_rd_os_cnt_cfg;
    int      sec_mem_wt_os_cnt_cfg;
    int      pri_mem_rd_os_cnt_cfg;
    int      pri_mem_wt_os_cnt_cfg;

    string      pri_memif_random_enable = "DISABLE";
    string      sec_memif_random_enable = "DISABLE";

    // semaphore for each TXN_ID*KIND queue
    //semaphore act_req_key[int][int];
    //semaphore exp_req_key[int];
    //semaphore act_key[int][int];
    //semaphore exp_key[int];

    uvm_event_pool  events;
    //uvm_event       intf_max_req_evt;
    uvm_event       sec_mem_max_rd_os_evt;
    uvm_event       sec_mem_max_wt_os_evt;
    uvm_event       pri_mem_max_rd_os_evt;
    uvm_event       pri_mem_max_wt_os_evt;
    //uvm_event       sub_unit_max_req_evt;

    `uvm_component_param_utils_begin(scoreboard_template#(TRANS))
        `uvm_field_int(sb_enable,                   UVM_ALL_ON)
        `uvm_field_int(eot_enable,                  UVM_ALL_ON)
        `uvm_field_int(request_ck_enable,           UVM_ALL_ON)
        `uvm_field_int(response_ck_enable,          UVM_ALL_ON)
        // `uvm_field_int(initial_request_credit_num,  UVM_ALL_ON)
        // `uvm_field_int(initial_response_credit_num, UVM_ALL_ON)
        `uvm_field_int(request_compare_mode,        UVM_ALL_ON)
        `uvm_field_int(response_compare_mode,       UVM_ALL_ON)
        `uvm_field_string(work_mode,                UVM_ALL_ON)
    `uvm_component_utils_end

    // Create TLM analysis fifo for DUT monitor
    uvm_tlm_analysis_fifo#(TRANS) dut_cmpl_fifo;
    uvm_tlm_analysis_fifo#(TRANS) dut_init_fifo;

    // Create TLM analysis fifo for CMOD
    uvm_tlm_analysis_fifo#(TRANS) rm_init_fifo;
    uvm_tlm_analysis_fifo#(TRANS) rm_cmpl_fifo;

    // TLM Analysis port for backpressuring CMOD txn
    uvm_analysis_port#(credit_txn) bp_analysis_port;

    // Hooks for transaction checker
    scoreboard_checker sb_checker;

    // print Control
    uvm_table_printer printer;

    /////////////////////////////////////////////////////////////
    //// constructor
    /////////////////////////////////////////////////////////////
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        tID = name;
        tID = tID.toupper();

        dut_cmpl_fifo                = new("dut_cmpl_fifo", this);
        dut_init_fifo                = new("dut_init_fifo", this);
        rm_cmpl_fifo                 = new("rm_cmpl_fifo", this);
        rm_init_fifo                 = new("rm_init_fifo", this);
        bp_analysis_port             = new("bp_analysis_port", this);
        printer                      = new();
        printer.knobs.begin_elements = -1;
    endfunction // new


    /////////////////////////////////////////////////////////////
    /// build phase()
    /////////////////////////////////////////////////////////////
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(tID, "build_phase is executed", UVM_FULL)

        sb_checker = scoreboard_checker::type_id::create("sb_checker", this);

        if($value$plusargs("WORK_MODE=%0s", work_mode)) begin
            `uvm_info(tID, $sformatf("Setting WORK_MODE:%0s", work_mode), UVM_MEDIUM)
        end
    endfunction : build_phase


    /////////////////////////////////////////////////////////////
    /// connect phase()
    /////////////////////////////////////////////////////////////
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(tID, "connect_phase is executed", UVM_FULL)
        events = uvm_event_pool::get_global_pool();
        if(events == null) begin
            `uvm_fatal(tID, "Global event pool can NOT be found\n");
        end
        sec_mem_max_rd_os_evt = events.get("sec_mem_max_rd_os_evt");
        if(sec_mem_max_rd_os_evt == null) begin
            `uvm_fatal(tID, "Event \"sec_mem_max_rd_os_evt\" can NOT be found");
        end
        sec_mem_max_wt_os_evt = events.get("sec_mem_max_wt_os_evt");
        if(sec_mem_max_wt_os_evt == null) begin
            `uvm_fatal(tID, "Event \"sec_mem_max_wt_os_evt\" can NOT be found");
        end
        pri_mem_max_rd_os_evt = events.get("pri_mem_max_rd_os_evt");
        if(pri_mem_max_rd_os_evt == null) begin
            `uvm_fatal(tID, "Event \"pri_mem_max_rd_os_evt\" can NOT be found");
        end
        pri_mem_max_wt_os_evt = events.get("pri_mem_max_wt_os_evt");
        if(pri_mem_max_wt_os_evt == null) begin
            `uvm_fatal(tID, "Event \"pri_mem_max_wt_os_evt\" can NOT be found");
        end
        //sub_unit_max_req_evt = events.get("sub_unit_max_req_evt");
        //if(sub_unit_max_req_evt == null) begin
        //    `uvm_fatal(tID, "Event \"sub_unit_max_req_evt\" can NOT be found");
        //end
        uvm_config_db#(int)::get(this, "*", "sec_mem_rd_os_cnt_cfg", sec_mem_rd_os_cnt_cfg);
        uvm_config_db#(int)::get(this, "*", "sec_mem_wt_os_cnt_cfg", sec_mem_wt_os_cnt_cfg);
        uvm_config_db#(int)::get(this, "*", "pri_mem_rd_os_cnt_cfg", pri_mem_rd_os_cnt_cfg);
        uvm_config_db#(int)::get(this, "*", "pri_mem_wt_os_cnt_cfg", pri_mem_wt_os_cnt_cfg);
        if(!uvm_config_db#(string)::get(this, "", "pri_memif_random_enable", pri_memif_random_enable)) begin
            `uvm_fatal(tID, "Could not get pri_memif_random_enable")
        end
        if(!uvm_config_db#(string)::get(this, "", "sec_memif_random_enable", sec_memif_random_enable)) begin
            `uvm_fatal(tID, "Could not get sec_memif_random_enable")
        end
        if(pri_memif_random_enable == "DISABLE") begin
            pri_mem_rd_os_cnt_cfg = 255;
            pri_mem_wt_os_cnt_cfg = 255;
        end
        else begin
            `uvm_info(tID, $sformatf("PRI_MEMIF_RANDOM_ENABLE, pri_mem_rd_os_cnt_cfg=%0d, pri_mem_wt_os_cnt_cfg=%0d", pri_mem_rd_os_cnt_cfg, pri_mem_wt_os_cnt_cfg), UVM_LOW)
        end
        if(sec_memif_random_enable == "DISABLE") begin
            sec_mem_rd_os_cnt_cfg = 255;
            sec_mem_wt_os_cnt_cfg = 255;
        end
        else begin
            `uvm_info(tID, $sformatf("SEC_MEMIF_RANDOM_ENABLE, sec_mem_rd_os_cnt_cfg=%0d, sec_mem_wt_os_cnt_cfg=%0d", sec_mem_rd_os_cnt_cfg, sec_mem_wt_os_cnt_cfg), UVM_LOW)
        end
    endfunction : connect_phase


    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info(tID, "end_of_elaboration_phase is executed", UVM_FULL)
    endfunction

    /////////////////////////////////////////////////////////////
    ///  start_of_simulation_phase()
    /////////////////////////////////////////////////////////////
    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info(tID, "start_of_simulation_phase is executed", UVM_FULL)
    endfunction

    //////////////////////////////////////////////////////////////////////
    /// reset phase()
    /// IMPORTANT: Remember that reset_phase is a part of the run_phase.
    /// Please be informed of how to use the constituent phases of run_phase.
    /// The following code shows a usage in which the reset_phase waits until
    /// all resets are lifted. The intent is to wait for all resets to lift,
    /// and then issue transactions to the DUT. Therefore, in this case, your
    /// test must start issuing transactions in main_phase (and not in run_phase)
    virtual task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        `uvm_info(tID, "reset_phase is executed", UVM_FULL)
    endtask:reset_phase


    /////////////////////////////////////////////////////////////
    ///  main_phase()
    /////////////////////////////////////////////////////////////
    virtual task run_phase(uvm_phase phase);
        process ctrl_pro;
        process req_check_pro;
        process rsp_check_pro;
        super.run_phase(phase);

        `uvm_info(tID, "run_phase is executed", UVM_FULL)

        if (work_mode != "CROSS_CHECK"
         || response_compare_mode == COMPARE_MODE_COUNT_TXN_ONLY
         || request_compare_mode  == COMPARE_MODE_COUNT_TXN_ONLY)
            eot_enable = 0;

        evaluate_compare_mode();

        fork
            begin : check_process_control
                ctrl_pro = process::self();
                #0;
                if(sb_enable == 0 || request_ck_enable == 0) begin
                    //disable req_trans_check_process;
                    req_check_pro.kill();
                    `uvm_info(tID, "Request trans check process is disabled!", UVM_NONE)
                end
                if(sb_enable == 0 || response_ck_enable == 0) begin
                    //disable response_trans_check_process;
                    rsp_check_pro.kill();
                    `uvm_info(tID, "Response trans check process is disabled!", UVM_NONE)
                end
            end
            begin : req_trans_check_process
                req_check_pro = process::self();
                #1;
                request_trans_check();
            end
            begin : response_trans_check_process
                rsp_check_pro = process::self();
                #1;
                response_trans_check();
            end
        join

    endtask

    function void evaluate_compare_mode();
        if (!(request_compare_mode inside {
            COMPARE_MODE_RTL_AHEAD
           ,COMPARE_MODE_RTL_GATING_CMOD
           ,COMPARE_MODE_LOOSE_COMPARE
           ,COMPARE_MODE_COUNT_TXN_ONLY
        })) begin
            `uvm_fatal(tID, $sformatf("Invalid request_compare_mode value (%0d)", request_compare_mode))
        end

        if (!(response_compare_mode inside {
            COMPARE_MODE_RTL_AHEAD
           ,COMPARE_MODE_RTL_GATING_CMOD
           ,COMPARE_MODE_LOOSE_COMPARE
           ,COMPARE_MODE_COUNT_TXN_ONLY
        })) begin
            `uvm_fatal(tID, $sformatf("Invalid response_compare_mode value (%0d)", response_compare_mode))
        end
    endfunction

    /////////////////////////////////////////////////////////////
    ///  extract_phase()
    /////////////////////////////////////////////////////////////
    virtual function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        `uvm_info(tID, "extract_phase is executed", UVM_FULL)
    endfunction

    /////////////////////////////////////////////////////////////
    ///  check_phase()
    /////////////////////////////////////////////////////////////
    virtual function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        `uvm_info(tID, "check_phase is executed", UVM_FULL)
        if (eot_enable == 1) begin
            fifo_check();
            // TBD, other status check at the end of the test
        end
        else begin
            `uvm_info(tID, "End of Test check is disabled!", NVDLA_NONE)
        end
    endfunction

    /////////////////////////////////////////////////////////////
    ///  report_phase()
    /////////////////////////////////////////////////////////////
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(tID, "report_phase is executed", UVM_FULL)
        if(act_req_cnt_q.size != 0 || act_cnt_q.size != 0 || exp_req_cnt_q.size != 0 || exp_cnt_q.size != 0) begin  // ACTIVE SCOREBOARD
            result_report();
        end
    endfunction

    /////////////////////////////////////////////////////////////
    ///  final_phase()
    /////////////////////////////////////////////////////////////
    virtual function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        `uvm_info(tID, "final_phase is executed", UVM_FULL)
    endfunction

    extern task request_trans_check();
    extern task response_trans_check();
    extern task fifo_check();
    extern function result_report();
    extern function void pre_abort();
endclass: scoreboard_template

/////////////////////////////////////////////////////////////
///  task: request_trans_check
///  implement request transactions check
/////////////////////////////////////////////////////////////
task scoreboard_template::request_trans_check();
    int    result;

    `uvm_info(tID, "req trans check task running ...",  UVM_FULL)

    fork
        // Distribute act fifo txn to specific ID queue
        forever begin : dist_act_req_queue_id
            TRANS  act_tr;
            TRANS  temp_tr;
            credit_txn credit_tr;
            int    txn_id;
            int    sub_id;
            int    kind;

            //dut_init_fifo.get(act_tr);
            dut_init_fifo.get(temp_tr);
            $cast(act_tr, temp_tr.clone());
            txn_id = temp_tr.get_transaction_id();
            //total_dut_txn_cnt++;
            if(txn_id[5] == 1) begin  // cdma_wt txn
                sub_id = txn_id[4:0];
                txn_id    = -1;
            end
            else begin
                sub_id = -1;
            end
            kind   = act_tr.is_read();
            //work around for DBBIF MONITOR send wrong write request txn_id
            if (!(txn_id != -1 && kind == 0)) begin //Not DBBIF write request
                // create one key for each TXN_ID*KIND queue
                //if(!act_req_key.exists(txn_id)) begin
                //    semaphore sem = new(1);
                //    act_req_key[txn_id][kind] = sem;
                //    `uvm_info(tID, $sformatf("Allocate one KEY for ACT DUT REQUEST QUEUE: ID=%0d, KIND=%0s", txn_id, kind_t[kind]), UVM_FULL)
                //end
                //else if(!act_req_key[txn_id].exists(kind)) begin
                //    semaphore sem = new(1);
                //    act_req_key[txn_id][kind] = sem;
                //    `uvm_info(tID, $sformatf("Allocate one KEY for ACT DUT REQUEST QUEUE: ID=%0d, KIND=%0s", txn_id, kind_t[kind]), UVM_FULL)
                //end

                act_req_cnt_q[txn_id][kind]++;
                if (COMPARE_MODE_COUNT_TXN_ONLY == request_compare_mode) continue;

                act_req_txn_q[txn_id][kind].push_back(act_tr);
                // Events trigger for DBBIF INTF MAX REQ check
                //if(tID == "BDMA_SEC_MEM_SB" || tID == "BDMA_PRI_MEM_SB") begin // DBBIF interface txn, currently only work for bdma
                //    if((act_req_cnt_q[txn_id][kind] -  act_cnt_q[txn_id][kind]) > 256) begin // Achieve max out-standing request
                //        sub_unit_max_req_evt.trigger();
                //    end
                //end
                if(tID == "PRI_MEM_SB") begin
                    pri_mem_rd_os_cnt++;
                    `uvm_info(tID, $sformatf("pri_mem_rd_os_cnt=%0d", pri_mem_rd_os_cnt),UVM_FULL)
                    if(pri_mem_rd_os_cnt == (pri_mem_rd_os_cnt_cfg+1)) begin
                        pri_mem_max_rd_os_evt.trigger();
                        `uvm_info(tID, "pri_mem_max_rd_os_evt trigger", NVDLA_LOW)
                    end
                    else if(pri_mem_rd_os_cnt > (pri_mem_rd_os_cnt_cfg+1) && pri_mem_max_rd_os_evt.is_on()) begin
                        `uvm_fatal(tID, $sformatf("PRI_MEMIF READ outstanding cnt overflow"))
                    end
                end
                else if(tID == "SEC_MEM_SB") begin
                    dbb_bus_ext dbb_ext;
                    uvm_tlm_gp gp;
                    $cast(gp, act_tr);
                    $cast(dbb_ext, gp.get_extension(dbb_bus_ext::ID()));
                    sec_mem_rd_os_cnt = sec_mem_rd_os_cnt + dbb_ext.get_length();
                    `uvm_info(tID, $sformatf("sec_mem_rd_os_cnt=%0d", sec_mem_rd_os_cnt),UVM_FULL)
                    if(sec_mem_rd_os_cnt <= (sec_mem_rd_os_cnt_cfg+1) && sec_mem_rd_os_cnt > (sec_mem_rd_os_cnt_cfg-3)) begin
                        sec_mem_max_rd_os_evt.trigger();
                    end
                    else if(sec_mem_rd_os_cnt > (sec_mem_rd_os_cnt_cfg+4) && sec_mem_max_rd_os_evt.is_on()) begin
                        `uvm_fatal(tID, $sformatf("SEC_MEMIF READ outstanding cnt overflow"))
                    end
                end
                //->act_txn_ev;
                info_flag = {tID,(txn_id==-1)?"|":{"|",dma_t[txn_id],"|"},kind_t[kind],"|REQUEST|DUT" };
                `uvm_info(info_flag, $sformatf("TXN_INDEX:%0d, Received DUT REQ TXN: ID=%0d, KIND=%0s",
                                               (act_req_cnt_q[txn_id][kind]-1), txn_id, kind_t[kind]), UVM_HIGH)
                `uvm_info(info_flag, $sformatf("%0s", act_tr.sprint(printer)), UVM_HIGH)
                if ((COMPARE_MODE_RTL_GATING_CMOD == request_compare_mode) || (COMPARE_MODE_RTL_AHEAD == request_compare_mode)) begin
                    // send back credit to CMOD for backpresure usage
                    credit_tr           = new();
                    credit_tr.txn_id    = txn_id;
                    credit_tr.not_write   = kind;
                    credit_tr.is_req    = 1;
                    credit_tr.credit    = 1;
                    credit_tr.sub_id    = sub_id;
                    bp_analysis_port.write(credit_tr);
                    `uvm_info(tID, $sformatf("Issue credit to CMOD:%0s", credit_tr.sprint(printer)), UVM_FULL)
                end
            end
            else if(txn_id != -1 && kind == 0) begin // DBBIF write request
                `uvm_info(tID, $sformatf("DBBIF Write Request:%0s", act_tr.sprint(printer)), UVM_FULL)
                if(tID == "PRI_MEM_SB") begin
                    pri_mem_wt_os_cnt++;
                    `uvm_info(tID, $sformatf("pri_mem_wt_os_cnt=%0d", pri_mem_wt_os_cnt),UVM_FULL)
                    if(pri_mem_wt_os_cnt == (pri_mem_wt_os_cnt_cfg+1)) begin
                        pri_mem_max_wt_os_evt.trigger();
                    end
                    else if(pri_mem_wt_os_cnt > (pri_mem_wt_os_cnt+1) && pri_mem_max_wt_os_evt.is_on()) begin
                        `uvm_fatal(tID, $sformatf("PRI_MEMIF WRITE outstanding cnt overflow"))
                    end
                end
                else if(tID == "SEC_MEM_SB") begin
                    dbb_bus_ext dbb_ext;
                    uvm_tlm_gp gp;
                    $cast(gp, act_tr);
                    $cast(dbb_ext, gp.get_extension(dbb_bus_ext::ID()));
                    sec_mem_wt_os_cnt = sec_mem_wt_os_cnt + dbb_ext.get_length();
                    `uvm_info(tID, $sformatf("sec_mem_wt_os_cnt=%0d", sec_mem_wt_os_cnt),UVM_FULL)
                    if(sec_mem_wt_os_cnt <= (sec_mem_wt_os_cnt_cfg+1) && sec_mem_wt_os_cnt >(sec_mem_wt_os_cnt_cfg-3)) begin
                        sec_mem_max_wt_os_evt.trigger();
                    end
                    else if(sec_mem_wt_os_cnt > (sec_mem_wt_os_cnt_cfg+1) && sec_mem_max_wt_os_evt.is_on()) begin
                        `uvm_fatal(tID, $sformatf("SEC_MEMIF WRITE outstanding cnt overflow"))
                    end
                end
            end
        end : dist_act_req_queue_id

        // Dsitribute exp fifo txn to specific ID queue
        forever begin : dist_exp_req_queue_id
            TRANS  exp_tr;
            TRANS  temp_tr;
            int    txn_id;
            int    kind;

            //rm_init_fifo.get(exp_tr);
            rm_init_fifo.get(temp_tr);
            $cast(exp_tr, temp_tr.clone());
            txn_id = temp_tr.get_transaction_id();
            //total_cmod_txn_cnt++;
            //kind   = exp_tr.is_write();
            kind   = exp_tr.is_read();
            //work around for DBBIF MONITOR send wrong write request txn_id
            if(!(txn_id != -1 && kind == 0)) begin //Not DBBIF write request
                exp_req_txn_q[txn_id][kind].push_back(exp_tr);
                exp_req_cnt_q[txn_id][kind]++;
                info_flag = {tID,(txn_id==-1)?"|":{"|",dma_t[txn_id],"|"},kind_t[kind],"|REQUEST|CMOD" };
                `uvm_info(info_flag, $sformatf("TXN_INDEX:%0d, Received CMOD REQ TXN: ID=%0d, KIND=%0s",
                                               (exp_req_cnt_q[txn_id][kind]-1), txn_id, kind_t[kind]), UVM_HIGH)
                `uvm_info(info_flag, $sformatf("%0s", exp_tr.sprint(printer)), UVM_HIGH)
            end
        end : dist_exp_req_queue_id

        begin : forever_req_trans_process
            //event act_txn_ev;
            //event kind_ev;

            //fork
            //    begin  // Case 1
            //        @(act_req_txn_q.size);
            //    end

            //    begin // Case 2
            //        foreach(act_req_txn_q[i]) begin
            //            automatic int j = i;
            //            fork
            //                begin
            //                    //automatic int j = i;
            //                    @(act_req_txn_q[j].size());
            //                    ->kind_ev;
            //                end
            //            join_none
            //        end
            //        @kind_ev;
            //        disable fork;
            //    end

            //    begin   // Case 3
            //        foreach(act_req_txn_q[i]) begin
            //            foreach(act_req_txn_q[i][j]) begin
            //                automatic int n = i;
            //                automatic int m = j;
            //                fork
            //                    begin
            //                        //automatic int n = i;
            //                        //automatic int m = j;
            //                        wait(act_req_txn_q[n][m].size != 0);
            //                        act_req_key[n][m].get(1);
            //                        ->act_txn_ev;
            //                        act_req_key[n][m].put(1);
            //                    end
            //                join_none;
            //            end
            //        end
            //        @act_txn_ev;
            //        disable fork;
            //    end
            //join_any
            //disable fork;

            //wait(act_req_txn_q.size != 0); // Exist at leat one txn queue
            //foreach(act_req_txn_q[i]) begin
            //    foreach(act_req_txn_q[i][j]) begin
            //        fork
            //            begin
            //                automatic int n = i;
            //                automatic int m = j;
            //                wait(act_req_txn_q[n][m].size != 0);
            //                act_req_key[n][m].get(1);
            //                ->act_txn_ev;
            //                act_req_key[n][m].put(1);
            //            end
            //        join_none;
            //    end
            //end
            //@act_txn_ev;

            foreach(act_req_txn_q[k]) begin
                foreach(act_req_txn_q[k][l]) begin
                    automatic int index = k;
                    automatic int kind  = l;
                    fork
                        //automatic int index = k;
                        //automatic int kind  = l;
                        forever begin
                            if(act_req_txn_q[index][kind].size != 0) begin
                                TRANS      act_tr;
                                TRANS      exp_tr;

                                //act_req_key[index][kind].get(1); // Get key, lock this queue
                                // if ((initial_request_credit_num > 0) && (eot_enable == 1)) begin
                                if (COMPARE_MODE_RTL_GATING_CMOD == request_compare_mode) begin
                                    if (exp_req_txn_q[index][kind].size == 0) begin
                                        info_flag = {tID,(index==-1)?"|":{"|",dma_t[index],"|"},kind_t[kind],"|REQUEST|NO_EXPECT_TXN" };
                                        `uvm_fatal(info_flag,
                                            $sformatf("TXN_INDEX:%0d, no CMOD REQ TXN for compare, in strict compare mode, CMOD transaction shall be in advance of RTL.",
                                            (pass_req_cnt_q[index][kind]+err_req_cnt_q[index][kind])))
                                    end
                                end
                                else begin
                                    wait(exp_req_txn_q[index][kind].size != 0);
                                end
                                act_tr = act_req_txn_q[index][kind].pop_front();
                                `uvm_info(tID, $sformatf("Pop Request trans from DUT QUEUE:TXN_ID=%0d KIND=%0s for compare", index,kind_t[kind]), UVM_FULL)
                                exp_tr = exp_req_txn_q[index][kind].pop_front();
                                `uvm_info(tID, $sformatf("Pop Request trans from CMOD QUEUE:TXN_ID=%0d KIND=%0s for compare", index,kind_t[kind]), UVM_FULL)
                                //CHECKER
                                result = sb_checker.request_txn_compre(act_tr, exp_tr);
                                if(result) begin
                                    info_flag = {tID,(index==-1)?"|":{"|",dma_t[index],"|"},kind_t[kind],"|REQUEST|MATCH" };
                                    pass_req_cnt_q[index][kind]++;
                                    `uvm_info(info_flag, $sformatf("TXN_INDEX:%0d, REQ TXN compare passed!", (pass_req_cnt_q[index][kind]+err_req_cnt_q[index][kind]-1)), UVM_HIGH)
                                end
                                else begin
                                    info_flag = {tID,(index==-1)?"|":{"|",dma_t[index],"|"},kind_t[kind],"|REQUEST|MISMATCH" };
                                    err_req_cnt_q[index][kind]++;
                                    `uvm_error(info_flag, $sformatf("TXN_INDEX:%0d, REQ TXN compare failed!\nSee below for detail compared TXN:\nDUT TXN:\n%0s\nCMOD TXN:\n%0s",
                                                                    (pass_req_cnt_q[index][kind]+err_req_cnt_q[index][kind]-1), act_tr.sprint(printer), exp_tr.sprint(printer)))
                                end
                                //act_req_key[index][kind].put(1); // put back key, ready for next txn check in this queue
                            end
                            else begin
                                @(act_req_txn_q[index][kind].size());
                            end
                        end
                    join_none
                end
            end
        end : forever_req_trans_process
    join

endtask : request_trans_check

/////////////////////////////////////////////////////////////
///  task: response_trans_check
///  implement response observed transactions check
/////////////////////////////////////////////////////////////
task scoreboard_template::response_trans_check();
    int   result;

    `uvm_info(tID, "responsed trans check task running ...",  UVM_FULL)

    fork
        // Distribute act fifo txn to specific ID queue
        forever begin : dist_act_queue_id
            TRANS   act_tr;
            TRANS   temp_tr;
            credit_txn credit_tr;
            int     txn_id;
            int     sub_id;
            int     kind;

            //dut_cmpl_fifo.get(act_tr);
            dut_cmpl_fifo.get(temp_tr);
            $cast(act_tr, temp_tr.clone());
            txn_id = temp_tr.get_transaction_id();
            //total_dut_txn_cnt++;
            if(txn_id[5] == 1) begin  // cdma_wt txn
                sub_id = txn_id[4:0];
                txn_id    = -1;
            end
            else begin
                sub_id = -1;
            end
            //kind   = act_tr.is_write();
            kind   = act_tr.is_read();
            if (!(txn_id != -1 && kind == 1)) begin // Not DBBIF read response txn from DUT
                // create one key for each TXN_ID*KIND queue
                //if(!act_key.exists(txn_id)) begin
                //    semaphore sem = new(1);
                //    act_key[txn_id][kind] = sem;
                //    `uvm_info(tID, $sformatf("Allocate one KEY for ACT DUT RESPONSE QUEUE: ID=%0d, KIND=%0s", txn_id, kind_t[kind]), UVM_FULL)
                //end
                //else if(!act_key[txn_id].exists(kind)) begin
                //    semaphore sem = new(1);
                //    act_key[txn_id][kind] = sem;
                //    `uvm_info(tID, $sformatf("Allocate one KEY for ACT DUT RESPONSE QUEUE: ID=%0d, KIND=%0s", txn_id, kind_t[kind]), UVM_FULL)
                //end

                act_cnt_q[txn_id][kind]++;
                if (COMPARE_MODE_COUNT_TXN_ONLY == response_compare_mode) continue;

                act_txn_q[txn_id][kind].push_back(act_tr);
                if(tID == "PRI_MEM_SB") begin
                    pri_mem_wt_os_cnt--;
                    `uvm_info(tID, $sformatf("pri_mem_wt_os_cnt=%0d", pri_mem_wt_os_cnt),UVM_FULL)
                end
                else if(tID == "SEC_MEM_SB") begin
                    dbb_bus_ext dbb_ext;
                    uvm_tlm_gp gp;
                    $cast(gp, act_tr);
                    $cast(dbb_ext, gp.get_extension(dbb_bus_ext::ID()));
                    sec_mem_wt_os_cnt = sec_mem_wt_os_cnt - dbb_ext.get_length();
                    `uvm_info(tID, $sformatf("sec_mem_wt_os_cnt=%0d", sec_mem_wt_os_cnt),UVM_FULL)
                end
                info_flag = {tID,(txn_id==-1)?"|":{"|",dma_t[txn_id],"|"},kind_t[kind],"|RESPONSE|DUT" };
                `uvm_info(info_flag, $sformatf("TXN_INDEX:%0d, Received DUT RESPONSE TXN: ID=%0d, KIND=%0s",
                                          (act_cnt_q[txn_id][kind]-1), txn_id, kind_t[kind]), UVM_HIGH)
                `uvm_info(info_flag, $sformatf("%0s", act_tr.sprint(printer)), UVM_FULL)
                if ((COMPARE_MODE_RTL_GATING_CMOD == response_compare_mode) || (COMPARE_MODE_RTL_AHEAD == response_compare_mode)) begin
                    // send back credit to CMOD for backpresure usage
                    credit_tr           = new();
                    credit_tr.txn_id    = txn_id;
                    credit_tr.not_write   = kind;
                    credit_tr.is_req    = 0;
                    credit_tr.credit    = 1;
                    credit_tr.sub_id    = sub_id;
                    bp_analysis_port.write(credit_tr);
                    `uvm_info(tID, $sformatf("Issue credit to CMOD:%0s", credit_tr.sprint(printer)), UVM_FULL)
                end
            end
            else if(txn_id != -1 && kind == 1)begin
                `uvm_info(tID, $sformatf("Received DBBIF read response txn to DUT:ID=%0s, KIND=%0s\n%0s", dma_t[txn_id], kind_t[kind], act_tr.sprint(printer)), UVM_FULL)
                if(tID == "PRI_MEM_SB") begin
                    pri_mem_rd_os_cnt--;
                    `uvm_info(tID, $sformatf("pri_mem_rd_os_cnt=%0d", pri_mem_rd_os_cnt),UVM_FULL)
                end
                else if(tID == "SEC_MEM_SB") begin
                    dbb_bus_ext dbb_ext;
                    uvm_tlm_gp gp;
                    $cast(gp, act_tr);
                    $cast(dbb_ext, gp.get_extension(dbb_bus_ext::ID()));
                    sec_mem_rd_os_cnt = sec_mem_rd_os_cnt - dbb_ext.get_length();
                    `uvm_info(tID, $sformatf("sec_mem_rd_os_cnt=%0d", sec_mem_rd_os_cnt),UVM_FULL)
                end
            end
        end : dist_act_queue_id

        // Dsitribute exp fifo txn to specific ID queue
        forever begin : dist_exp_queue_id
            TRANS   exp_tr;
            TRANS   temp_tr;
            int     txn_id;
            int     kind;  // 0 for read (or dont't care), 1 for write

            //rm_cmpl_fifo.get(exp_tr);
            rm_cmpl_fifo.get(temp_tr);
            $cast(exp_tr, temp_tr.clone());
            txn_id = temp_tr.get_transaction_id();
            //total_cmod_txn_cnt++;
            //kind   = exp_tr.is_write();
            kind   = exp_tr.is_read();
            if(!(txn_id != -1 && kind == 1)) begin // Not DBBIF read request txn from CMOD
                exp_txn_q[txn_id][kind].push_back(exp_tr);
                exp_cnt_q[txn_id][kind]++;
                info_flag = {tID,(txn_id==-1)?"|":{"|",dma_t[txn_id],"|"},kind_t[kind],"|RESPONSE|CMOD" };
                `uvm_info(info_flag, $sformatf("TXN_INDEX:%0d, Received CMOD RESPONSE TXN: ID=%0d, KIND=%0s",
                                               (exp_cnt_q[txn_id][kind]-1), txn_id, kind_t[kind]), UVM_HIGH)
                `uvm_info(info_flag, $sformatf("%0s", exp_tr.sprint(printer)), UVM_HIGH)
            end
        end : dist_exp_queue_id

        begin : forever_compl_trans_process
            //event act_txn_ev;
            //event kind_ev;

            //fork
            //    begin  // Case 1
            //        @(act_txn_q.size);
            //    end

            //    begin  // Case 2
            //        foreach(act_txn_q[i]) begin
            //            automatic int j = i;
            //            fork
            //                begin
            //                    //automatic int j = i;
            //                    @(act_txn_q[j].size());
            //                    ->kind_ev;
            //                end
            //            join_none
            //        end
            //        @kind_ev;
            //        disable fork;
            //    end

            //    begin   // Case 3
            //        foreach(act_txn_q[i]) begin
            //            foreach(act_txn_q[i][j]) begin
            //                automatic int n = i;
            //                automatic int m = j;
            //                fork
            //                    begin
            //                        //automatic int n = i;
            //                        //automatic int m = j;
            //                        wait(act_txn_q[n][m].size != 0);
            //                        act_key[n][m].get(1);
            //                        ->act_txn_ev;
            //                        act_key[n][m].put(1);
            //                    end
            //                join_none;
            //            end
            //        end
            //        @act_txn_ev;
            //        disable fork;
            //    end
            //join_any

            //wait(act_txn_q.size != 0); // Exist at leat one txn queue
            //foreach(act_txn_q[i]) begin
            //    foreach(act_txn_q[i][j]) begin
            //        fork
            //            begin
            //                automatic int n = i;
            //                automatic int m = j;
            //                wait(act_txn_q[n][m].size != 0);
            //                act_key[n][m].get(1);
            //                ->act_txn_ev;
            //                act_key[n][m].put(1);
            //            end
            //        join_none;
            //    end
            //end
            //@act_txn_ev;

            foreach(act_txn_q[k]) begin
                foreach(act_txn_q[k][l]) begin
                    automatic int index = k;
                    automatic int kind  = l;
                    fork
                        //automatic int index = k;
                        //automatic int kind  = l;
                        forever begin
                            if(act_txn_q[index][kind].size != 0) begin
                                TRANS      act_tr;
                                TRANS      exp_tr;

                                //act_key[index][kind].get(1); // Get key, lock this queue
                                // if ((initial_response_credit_num > 0) && (eot_enable == 1)) begin
                                if (COMPARE_MODE_RTL_GATING_CMOD == response_compare_mode) begin
                                    if (exp_txn_q[index][kind].size == 0) begin
                                        info_flag = {tID,(index==-1)?"|":{"|",dma_t[index],"|"},kind_t[kind],"|RESPONSE|NO_EXPECT_TXN" };
                                        `uvm_fatal(info_flag,
                                            $sformatf("TXN_INDEX:%0d, no CMOD response TXN for compare, in strict compare mode, CMOD transaction shall be in advance of RTL.",
                                            (pass_cnt_q[index][kind] + err_cnt_q[index][kind])))
                                    end
                                end
                                else begin
                                    wait(exp_txn_q[index][kind].size != 0);
                                end
                                act_tr = act_txn_q[index][kind].pop_front();
                                `uvm_info(tID, $sformatf("Pop Response trans from DUT QUEUE:TXN_ID=%0d KIND=%0s for compare", index,kind_t[kind]), UVM_FULL)
                                exp_tr = exp_txn_q[index][kind].pop_front();
                                `uvm_info(tID, $sformatf("Pop Response trans from CMOD QUEUE:TXN_ID=%0d KIND=%0s for compare", index,kind_t[kind]), UVM_FULL)
                                //CHECKER
                                result = sb_checker.response_txn_compare(act_tr, exp_tr);
                                if(result) begin
                                    //total_txn_cnt++;
                                    info_flag = {tID,(index==-1)?"|":{"|",dma_t[index],"|"},kind_t[kind],"|RESPONSE|MATCH" };
                                    pass_cnt_q[index][kind]++;
                                    `uvm_info(info_flag, $sformatf("TXN_INDEX:%0d, RESPONSE TXN compare passed!", (pass_cnt_q[index][kind] + err_cnt_q[index][kind]-1)), UVM_HIGH)
                                end
                                else begin
                                    info_flag = {tID,(index==-1)?"|":{"|",dma_t[index],"|"},kind_t[kind],"|RESPONSE|MISMATCH" };
                                    err_cnt_q[index][kind]++;
                                    `uvm_error(info_flag, $sformatf("TXN_INDEX:%0d, RESPONSE TXN compare failed! See below for detail compared TXN:\nDUT TXN:\n%0s\nCMOD TXN:\n%0s",
                                                                    (pass_cnt_q[index][kind] + err_cnt_q[index][kind]-1), act_tr.sprint(printer), exp_tr.sprint(printer)))
                                end
                                //act_key[index][kind].put(1); // put back key, ready for next txn check in this queue
                            end
                            else begin
                                @(act_txn_q[index][kind].size());
                            end
                        end
                    join_none
                end
            end
        end : forever_compl_trans_process
    join

endtask : response_trans_check

/////////////////////////////////////////////////////////////
///  task: fifo_check
///  END of TEST check: 1) check fifo empty, whether all transactions collected
///                        in fifo have been processed
/////////////////////////////////////////////////////////////
task scoreboard_template::fifo_check();
    `uvm_info(tID, "EOT fifo check running ...", UVM_FULL)
    // FIFO empty check
    /*
        assert(dut_cmpl_fifo.is_empty()) else
            `uvm_error(tID, $sformatf("dut_cmpl_fifo is not empty, %0d trans un-processed", dut_cmpl_fifo.used()))
        assert(dut_init_fifo.is_empty()) else
            `uvm_error(tID, $sformatf("dut_init_fifo is not empty, %0d trans un-processed", dut_init_fifo.used()))
        assert(rm_cmpl_fifo.is_empty()) else
            `uvm_error(tID, $sformatf("rm_cmpl_fifo is not empty, %0d trans un-processed", rm_cmpl_fifo.used()))
        assert(rm_init_fifo.is_empty()) else
            `uvm_error(tID, $sformatf("rm_init_fifo is not empty, %0d trans un-processed", rm_init_fifo.used()))

        foreach(act_req_txn_q[i]) begin
            foreach(act_req_txn_q[i][j]) begin
                if(act_req_txn_q[i][j].size() != 0) begin
                    `uvm_error(tID, $sformatf("TXN_ID: %0d, KIND=%0s, DUT request queue not empty, size=%0d", i, kind_t[j], act_req_txn_q[i][j].size()))
                end
            end
        end
        foreach(exp_req_txn_q[i]) begin
            foreach(exp_req_txn_q[i][j]) begin
                if(exp_req_txn_q[i][j].size() != 0) begin
                    `uvm_error(tID, $sformatf("TXN_ID: %0d, KIND:%0s, CMOD request queue not empty, size=%0d", i, kind_t[j], exp_req_txn_q[i][j].size))
                end
            end
        end
        foreach(act_txn_q[i]) begin
            foreach(act_txn_q[i][j]) begin
                if(act_txn_q[i][j].size() != 0) begin
                    `uvm_error(tID, $sformatf("TXN_ID: %0d, KIND=%0s, DUT response queue not empty, size=%0d", i, kind_t[j], act_txn_q[i][j].size()))
                end
            end
        end
        foreach(exp_txn_q[i]) begin
            foreach(exp_txn_q[i][j]) begin
                if(exp_txn_q[i][j].size() != 0) begin
                    `uvm_error(tID, $sformatf("TXN_ID: %0d, KIND=%0s, CMOD response queue not empty, size=%0d", i, kind_t[j], exp_txn_q[i][j].size))
                end
            end
        end
    */
    foreach(act_req_txn_q[i]) begin
        foreach(act_req_txn_q[i][j]) begin
            if(act_req_txn_q[i][j].size() != 0) begin
                `uvm_error(tID, $sformatf("%0s: DUT request queue not empty, please check whether CMOD miss request txn.\nThe First Remaining DUT TXN:\nTXN_INDEX:%0d, TXN_ID: %0s, KIND=%0s, TXN:\n%0s", tID, (pass_req_cnt_q[i][j]+err_req_cnt_q[i][j]+1), dma_t[i], kind_t[j], act_req_txn_q[i][j][0].sprint()))
            end
        end
    end
    foreach(exp_req_txn_q[i]) begin
        foreach(exp_req_txn_q[i][j]) begin
            if(exp_req_txn_q[i][j].size() != 0) begin
               `uvm_error(tID, $sformatf("%0s: CMOD request queue not empty, please check whether DUT miss request txn.\nThe First Remaining CMOD TXN:\nTXN_INDEX:%0d, TXN_ID: %0s, KIND=%0s, TXN:\n%0s", tID, (pass_req_cnt_q[i][j]+err_req_cnt_q[i][j]+1), dma_t[i], kind_t[j], exp_req_txn_q[i][j][0].sprint()))
            end
        end
    end
    foreach(act_txn_q[i]) begin
        foreach(act_txn_q[i][j]) begin
            if(act_txn_q[i][j].size() != 0) begin
                `uvm_error(tID, $sformatf("%0s: DUT Response queue not empty, please check whether CMOD miss response txn.\nThe First Remaining DUT TXN:\nTXN_INDEX:%0d, TXN_ID: %0s, KIND=%0s, TXN:\n%0s", tID, (pass_cnt_q[i][j]+err_cnt_q[i][j]+1), dma_t[i], kind_t[j], act_txn_q[i][j][0].sprint()))
            end
        end
    end
    foreach(exp_txn_q[i]) begin
        foreach(exp_txn_q[i][j]) begin
            if(exp_txn_q[i][j].size() != 0) begin
                `uvm_error(tID, $sformatf("%0s: CMOD Response queue not empty, please check whether DUT miss response txn.\nThe First Remaining CMOD TXN:\nTXN_INDEX:%0d, TXN_ID: %0s, KIND=%0s, TXN:\n%0s", tID, (pass_cnt_q[i][j]+err_cnt_q[i][j]+1), dma_t[i], kind_t[j], exp_txn_q[i][j][0].sprint()))
            end
        end
    end
endtask : fifo_check

/////////////////////////////////////////////////////////////
///  function: result_report
///  Print scoreboard results
/////////////////////////////////////////////////////////////
function scoreboard_template::result_report();
    typedef string info_table_t[9][5];

    string    head_table[7];
    string    info_format[9][5];
    string    bi_line = "======================================================================================================================\n";
    string    si_line = "----------------------------------------------------------------------------------------------------------------------\n";
    string    content;
    int       has_txn_id;
    bit [1:0] has_rw;
    bit [1:0] has_req_rsp;
    string    rw;
    string    req_rsp;
    string    src;
    string    dst;

    info_table_t info_table_q[int];

    // build format
    // ===============
    info_format[0] = '{         "TXN_ID=%0s |", "MATCH      |","MISMATCH      |", "REMAIN      |",   "TOTAL      \n"};
    info_format[1] = '{   "DUT Read Request |",  "%10d      |",    "%10d      |",   "%10d      |",    "%10d      \n"};
    info_format[2] = '{  "DUT Read Response |",  "%10d      |",    "%10d      |",   "%10d      |",    "%10d      \n"};
    info_format[3] = '{  "DUT Write Request |",  "%10d      |",    "%10d      |",   "%10d      |",    "%10d      \n"};
    info_format[4] = '{ "DUT Write Response |",  "%10d      |",    "%10d      |",   "%10d      |",    "%10d      \n"};
    info_format[5] = '{  "CMOD Read Request |",  "%10d      |",    "%10d      |",   "%10d      |",    "%10d      \n"};
    info_format[6] = '{ "CMOD Read Response |",  "%10d      |",    "%10d      |",   "%10d      |",    "%10d      \n"};
    info_format[7] = '{ "CMOD Write Request |",  "%10d      |",    "%10d      |",   "%10d      |",    "%10d      \n"};
    info_format[8] = '{"CMOD Write Response |",  "%10d      |",    "%10d      |",   "%10d      |",    "%10d      \n"};

    // fill content
    // ===============
    case(tID)
        "SEC_MEM_SB":                                                              begin src="SEC_MIF"; dst="    OUT"; end
        "PRI_MEM_SB":                                                              begin src="PRI_MIF"; dst="    OUT"; end
        "CDMA_WT_SEC_MEM_SB","CDMA_DAT_SEC_MEM_SB":                                begin src="   CDMA"; dst="SEC_MIF"; end
        "CDMA_WT_PRI_MEM_SB","CDMA_DAT_PRI_MEM_SB":                                begin src="   CDMA"; dst="PRI_MIF"; end
        "SDP_SEC_MEM_SB","SDP_B_SEC_MEM_SB","SDP_N_SEC_MEM_SB","SDP_E_SEC_MEM_SB": begin src="    SDP"; dst="SEC_MIF"; end
        "SDP_PRI_MEM_SB","SDP_B_PRI_MEM_SB","SDP_N_PRI_MEM_SB","SDP_E_PRI_MEM_SB": begin src="    SDP"; dst="PRI_MIF"; end
        "PDP_SEC_MEM_SB":                                                          begin src="    PDP"; dst="SEC_MIF"; end
        "PDP_PRI_MEM_SB":                                                          begin src="    PDP"; dst="PRI_MIF"; end
        "CDP_SEC_MEM_SB":                                                          begin src="    CDP"; dst="SEC_MIF"; end
        "CDP_PRI_MEM_SB":                                                          begin src="    CDP"; dst="PRI_MIF"; end
        "BDMA_SEC_MEM_SB":                                                         begin src="   BDMA"; dst="SEC_MIF"; end
        "BDMA_PRI_MEM_SB":                                                         begin src="   BDMA"; dst="PRI_MIF"; end
        "RBK_SEC_MEM_SB":                                                          begin src="  RUBIK"; dst="SEC_MIF"; end
        "RBK_PRI_MEM_SB":                                                          begin src="  RUBIK"; dst="PRI_MIF"; end
        "CSC_DAT_A_SB","CSC_WT_A_SB","CSC_DAT_B_SB","CSC_WT_B_SB":                 begin src="    CSC"; dst="   CMAC"; end
        "CMAC_A_SB","CMAC_B_SB":                                                   begin src="   CMAC"; dst="   CACC"; end
        "CACC_SB":                                                                 begin src="   CACC"; dst="    SDP"; end
        "SDP_SB":                                                                  begin src="    SDP"; dst="    PDP"; end
        default: `uvm_error(tID, "Invalid scoreboard name, please check")
    endcase

    head_table[0]  = "\n";
    head_table[1] = bi_line;
    head_table[2] = $psprintf("                                      SCOREBOARD RESULTS:  %0s              \n", tID);
    head_table[3] = $psprintf("                                      -----------             -----------     \n");
    head_table[4] = $psprintf("                                     |  %0s  | --------> |  %0s  |      \n", src, dst);
    head_table[5] = $psprintf("                                      -----------             -----------     \n");
    head_table[6] = bi_line;

    foreach(act_req_txn_q[i]) begin
        if(act_req_cnt_q[i][0]==0 && act_req_cnt_q[i][1]==0) begin
            continue;
        end
        else begin
            if(!info_table_q.exists(i)) begin
                info_table_t item;
                info_table_q[i] = item;
                info_table_q[i][0] = '{i==-1?$psprintf("%16s", "TXN_ID=NULL    |") : $psprintf(info_format[0][0],dma_t[i]), $psprintf(info_format[0][1]),
                                       $psprintf(info_format[0][2]), $psprintf(info_format[0][3]), $psprintf(info_format[0][4])};
            end
            foreach(act_req_txn_q[i][j]) begin
                if(act_req_cnt_q[i][j] != 0) begin
                    if(j == 1) begin
                        info_table_q[i][1] = '{$psprintf(info_format[1][0]), $psprintf(info_format[1][1], pass_req_cnt_q[i][j]),
                                               $psprintf(info_format[1][2], err_req_cnt_q[i][j]),$psprintf(info_format[1][3], act_req_txn_q[i][j].size), $psprintf(info_format[1][4], act_req_cnt_q[i][j])};
                    end
                    else if(j == 0) begin
                        info_table_q[i][3] = '{$psprintf(info_format[3][0]), $psprintf(info_format[3][1], pass_req_cnt_q[i][j]),
                                               $psprintf(info_format[3][2], err_req_cnt_q[i][j]),$psprintf(info_format[3][3], act_req_txn_q[i][j].size), $psprintf(info_format[3][4], act_req_cnt_q[i][j])};
                    end
                end
            end
        end
    end

    foreach(exp_req_txn_q[i]) begin
        if(exp_req_cnt_q[i][0]==0 && exp_req_cnt_q[i][1]==0) begin
            continue;
        end
        else begin
            if(!info_table_q.exists(i)) begin
                info_table_t item;
                info_table_q[i] = item;
                info_table_q[i][0] = '{i==-1?$psprintf("%16s", "TXN_ID=NULL    |") : $psprintf(info_format[0][0],dma_t[i]), $psprintf(info_format[0][1]),
                                       $psprintf(info_format[0][2]), $psprintf(info_format[0][3]), $psprintf(info_format[0][4])};
            end
            foreach(exp_req_txn_q[i][j]) begin
                if(exp_req_cnt_q[i][j] != 0) begin
                    if(j == 1) begin
                        info_table_q[i][5] = '{$psprintf(info_format[5][0]), $psprintf(info_format[5][1], pass_req_cnt_q[i][j]),
                                               $psprintf(info_format[5][2], err_req_cnt_q[i][j]),$psprintf(info_format[5][3], exp_req_txn_q[i][j].size), $psprintf(info_format[5][4], exp_req_cnt_q[i][j])};
                    end
                    else if(j == 0) begin
                        info_table_q[i][7] = '{$psprintf(info_format[7][0]), $psprintf(info_format[7][1], pass_req_cnt_q[i][j]),
                                               $psprintf(info_format[7][2], err_req_cnt_q[i][j]),$psprintf(info_format[7][3], exp_req_txn_q[i][j].size), $psprintf(info_format[7][4], exp_req_cnt_q[i][j])};
                    end
                end
            end
        end
    end

    foreach(act_txn_q[i]) begin
        if(act_cnt_q[i][0]==0 && act_cnt_q[i][1]==0) begin
            continue;
        end
        else begin
            if(!info_table_q.exists(i)) begin
                info_table_t item;
                info_table_q[i] = item;
                info_table_q[i][0] = '{i==-1?$psprintf("%16s", "TXN_ID=NULL    |") : $psprintf(info_format[0][0],dma_t[i]), $psprintf(info_format[0][1]),
                                       $psprintf(info_format[0][2]), $psprintf(info_format[0][3]), $psprintf(info_format[0][4])};
            end
            foreach(act_txn_q[i][j]) begin
                if(act_cnt_q[i][j] != 0) begin
                    if(j == 1) begin
                        info_table_q[i][2] = '{$psprintf(info_format[2][0]), $psprintf(info_format[2][1], pass_cnt_q[i][j]),
                                               $psprintf(info_format[2][2], err_cnt_q[i][j]),$psprintf(info_format[2][3], act_txn_q[i][j].size), $psprintf(info_format[2][4], act_cnt_q[i][j])};
                    end
                    else if(j == 0) begin
                        info_table_q[i][4] = '{$psprintf(info_format[4][0]), $psprintf(info_format[4][1], pass_cnt_q[i][j]),
                                               $psprintf(info_format[4][2], err_cnt_q[i][j]),$psprintf(info_format[4][3], act_txn_q[i][j].size), $psprintf(info_format[4][4], act_cnt_q[i][j])};
                    end
                end
            end
        end
    end

    foreach(exp_txn_q[i]) begin
        if(exp_cnt_q[i][0]==0 && exp_cnt_q[i][1]==0) begin
            continue;
        end
        else begin
            if(!info_table_q.exists(i)) begin
                info_table_t item;
                info_table_q[i] = item;
                info_table_q[i][0] = '{i==-1?$psprintf("%16s", "TXN_ID=NULL    |") : $psprintf(info_format[0][0],dma_t[i]), $psprintf(info_format[0][1]),
                                       $psprintf(info_format[0][2]), $psprintf(info_format[0][3]), $psprintf(info_format[0][4])};
            end
            foreach(exp_txn_q[i][j]) begin
                if(exp_cnt_q[i][j] != 0) begin
                    if(j == 1) begin
                        info_table_q[i][6] = '{$psprintf(info_format[6][0]), $psprintf(info_format[6][1], pass_cnt_q[i][j]),
                                               $psprintf(info_format[6][2], err_cnt_q[i][j]),$psprintf(info_format[6][3], exp_txn_q[i][j].size), $psprintf(info_format[6][4], exp_cnt_q[i][j])};
                    end
                    else if(j == 0) begin
                        info_table_q[i][8] = '{$psprintf(info_format[8][0]), $psprintf(info_format[8][1], pass_cnt_q[i][j]),
                                               $psprintf(info_format[8][2], err_cnt_q[i][j]),$psprintf(info_format[8][3], exp_txn_q[i][j].size), $psprintf(info_format[8][4], exp_cnt_q[i][j])};
                    end
                end
            end
        end
    end


    // print table
    // ===============
    foreach(head_table[i]) begin
        $write(head_table[i]);
    end
    foreach(info_table_q[i]) begin
        foreach(info_table_q[i][j]) begin
            if(info_table_q[i][j][0] != "") begin
                foreach(info_table_q[i][j][k]) begin
                    $write($psprintf("%22s", info_table_q[i][j][k]));
                end
                $write(si_line);
            end
        end
        //if(i == -1) begin
        //    content = $psprintf("    GREP KEY: \"[%0s|WRITE(READ)|REQUEST(RESPONSE)|MATCH(MISMATCH)(DUT)(CMOD)] TXN_INDEX:\"\n              ():means optional", tID);
        //end
        //else begin
        //    content = $psprintf("    GREP KEY: \"[%0s|%0s|WRITE(READ)|REQUEST(RESPONSE)|MATCH(MISMATCH)(DUT)(CMOD)] TXN_INDEX:\"\n              ():means optional", tID, dma_t[i]);
        //end
        has_rw[0]      = ((info_table_q[i][3][0]!="") || (info_table_q[i][4][0]!="") || (info_table_q[i][7][0]!="") || (info_table_q[i][8][0]!="")); //write
        has_rw[1]      = ((info_table_q[i][1][0]!="") || (info_table_q[i][2][0]!="") || (info_table_q[i][5][0]!="") || (info_table_q[i][6][0]!="")); //read
        has_req_rsp[0] = ((info_table_q[i][1][0]!="") || (info_table_q[i][3][0]!="") || (info_table_q[i][5][0]!="") || (info_table_q[i][7][0]!="")); //request
        has_req_rsp[1] = ((info_table_q[i][2][0]!="") || (info_table_q[i][4][0]!="") || (info_table_q[i][6][0]!="") || (info_table_q[i][8][0]!="")); //response
        case(has_rw)
            2'b00: rw = "";
            2'b01: rw = "WRITE";
            2'b10: rw = "READ";
            2'b11: rw = "WRITE(READ)";
        endcase
        case(has_req_rsp)
            2'b00: req_rsp = "";
            2'b01: req_rsp = "REQUEST";
            2'b10: req_rsp = "RESPONSE";
            2'b11: req_rsp = "REQUEST(RESPONSE)";
        endcase
        content = $psprintf("    GREP KEY: \"%0s%0s|%0s|REQUEST|MISMATCH(MATCH)(DUT)(CMOD)] TXN_INDEX:\"", tID, (i==-1)?"":{"|", dma_t[i]}, rw);
        $write({content, "\n"});
        content = $psprintf("    GREP KEY: \"%0s%0s|%0s|RESPONSE|MISMATCH(MATCH)(DUT)(CMOD)] TXN_INDEX:\"", tID, (i==-1)?"":{"|", dma_t[i]}, rw);
        $write({content, "\n"});
        content = $psprintf("              ():means optional");
        $write({content, "\n"});
        $write(si_line);
    end
endfunction : result_report

function void scoreboard_template::pre_abort();
    `uvm_info(tID, "Call pre_abort function", UVM_FULL)
    extract_phase(null);
    report_phase(null);
    //check_phase(null);
endfunction : pre_abort

`endif // _NVDLA_TB_SCOREBOARD_SV_
