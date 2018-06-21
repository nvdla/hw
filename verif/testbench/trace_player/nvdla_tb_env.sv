`ifndef _NVDLA_TB_ENV_SV_
`define _NVDLA_TB_ENV_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_tb_env
//
// @description
//-------------------------------------------------------------------------------------

import nvdla_coverage_pkg::*;

class nvdla_tb_env extends uvm_env;

    string                tID;

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
    //:| global mem_intf_list
    //:| mem_intf_list = ["pri_mem"]
    //:| if "NVDLA_SECONDARY_MEMIF_ENABLE" in project.PROJVAR:
    //:|     mem_intf_list.append("sec_mem")
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    //:| memory_interface_list = mem_intf_list
    //:| for inst in memory_interface_list:
    //:|     print('    string %s_request_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";' % inst)
    //:|     print('    string %s_response_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";' % inst)
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
    //:| dma_list       = dma_ports
    //:| mem_if_list    = mem_intf_list
    //:| kind_list      = ['request', 'response']
    //:| for dma in dma_list:
    //:|     for mem_if in mem_if_list:
    //:|         for kind in kind_list:
    //:|             print('    string %(dma)s_%(mem_if)s_%(kind)s_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";' % {'dma':dma, 'mem_if':mem_if, 'kind':kind})
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    string pri_mem_request_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string pri_mem_response_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string csc_dat_a_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string csc_dat_b_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string csc_wt_a_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string csc_wt_b_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string cmac_a_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string cmac_b_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string cacc_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string sdp_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string cdma_wt_pri_mem_request_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string cdma_wt_pri_mem_response_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string cdma_dat_pri_mem_request_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string cdma_dat_pri_mem_response_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string sdp_pri_mem_request_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string sdp_pri_mem_response_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string sdp_b_pri_mem_request_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string sdp_b_pri_mem_response_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string sdp_n_pri_mem_request_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string sdp_n_pri_mem_response_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string pdp_pri_mem_request_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string pdp_pri_mem_response_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string cdp_pri_mem_request_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    string cdp_pri_mem_response_compare_mode = "COMPARE_MODE_LOOSE_COMPARE";
    //:) epython: generated_end (DO NOT EDIT ABOVE)
    // internal passive agent
    //:| for dma in dma_ports: print("    dma_slave_agent    %0s_pri_mem_agt;" % dma)
    //:| if "NVDLA_SECONDARY_MEMIF_ENABLE" in project.PROJVAR:
    //:|     for dma in dma_ports: print("    dma_slave_agent    %0s_sec_mem_agt;" % dma)
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    dma_slave_agent    cdma_wt_pri_mem_agt;
    dma_slave_agent    cdma_dat_pri_mem_agt;
    dma_slave_agent    sdp_pri_mem_agt;
    dma_slave_agent    sdp_b_pri_mem_agt;
    dma_slave_agent    sdp_n_pri_mem_agt;
    dma_slave_agent    pdp_pri_mem_agt;
    dma_slave_agent    cdp_pri_mem_agt;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    // used for interfaces : SC=>MAC & MAC=>ACCU
    cc_slave_agent#(CSC_DT_DW, CSC_DT_DS)     csc_dat_a_agt;
    cc_slave_agent#(CSC_WT_DW, CSC_WT_DS)     csc_wt_a_agt;
    cc_slave_agent#(CSC_DT_DW, CSC_DT_DS)     csc_dat_b_agt;
    cc_slave_agent#(CSC_WT_DW, CSC_WT_DS)     csc_wt_b_agt;
    cc_slave_agent#(CMAC_DW, CMAC_DS)         cmac_a_agt;
    cc_slave_agent#(CMAC_DW, CMAC_DS)         cmac_b_agt;

    // used for interface: ACCU=>SDP & SDP=>PDP
    dp_slave_agent#(CACC_PW, CACC_DW, CACC_DS) cacc_agt;
    dp_slave_agent#(SDP_PW, SDP_DW, SDP_DS)    sdp_agt;

    csb_agent             csb_agt;
    dbb_slave_agent#(`NVDLA_PRIMARY_MEMIF_WIDTH)       pri_mem_agt;
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    dbb_slave_agent#(`NVDLA_SECONDARY_MEMIF_WIDTH)     sec_mem_agt;
    `endif

    // interrupt handler
    nvdla_tb_intr_handler intr_hdlr;
    nvdla_tb_intr_handler rm_intr_hdlr;

    // memory model: for both DUT and reference model
    mem_wrap              pri_mem;
    mem_wrap              rm_pri_mem;
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    mem_wrap              sec_mem;
    mem_wrap              rm_sec_mem;
    `endif

    // data checker & register checker & interrupt checker
    nvdla_tb_scoreboard_container   sb;

    ral_sys_top           ral;

    // using cmod for reference model
    rm_cmod_nvdla_top     rm_inst;

    // ral txn <=> csb txn adapter
    nvdla_reg_adapter#(uvm_tlm_gp) ral_adapter;

    // Coverage model
    nvdla_coverage_top     cov;

    //----------------------------------------------------------CONFIGURATION PARAMETERS
    // NVDLA_TB_ENV Configuration Parameters. These parameters can be controlled through
    // the UVM configuration database
    // @{

    // used to control whether enable reference model or not
    bit is_rm_en = 1;

    // }@

    `uvm_component_utils_begin(nvdla_tb_env)
        `uvm_field_int(is_rm_en, UVM_ALL_ON)
        //:| memory_interface_list = mem_intf_list
        //:| for inst in memory_interface_list:
        //:|     print("        `uvm_field_string(%s_request_compare_mode, UVM_ALL_ON)" % inst)
        //:|     print("        `uvm_field_string(%s_response_compare_mode, UVM_ALL_ON)" % inst)
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
        //:| dma_list       = dma_ports
        //:| mem_if_list    = mem_intf_list
        //:| kind_list      = ['request', 'response']
        //:| for dma in dma_list:
        //:|     for mem_if in mem_if_list:
        //:|         for kind in kind_list:
        //:|             print("        `uvm_field_string(%(dma)s_%(mem_if)s_%(kind)s_compare_mode, UVM_ALL_ON)" % {'dma':dma, 'mem_if':mem_if, 'kind':kind})
        //:) epython: generated_beg (DO NOT EDIT BELOW)
        `uvm_field_string(pri_mem_request_compare_mode, UVM_ALL_ON)
        `uvm_field_string(pri_mem_response_compare_mode, UVM_ALL_ON)
        `uvm_field_string(csc_dat_a_compare_mode, UVM_ALL_ON)
        `uvm_field_string(csc_dat_b_compare_mode, UVM_ALL_ON)
        `uvm_field_string(csc_wt_a_compare_mode, UVM_ALL_ON)
        `uvm_field_string(csc_wt_b_compare_mode, UVM_ALL_ON)
        `uvm_field_string(cmac_a_compare_mode, UVM_ALL_ON)
        `uvm_field_string(cmac_b_compare_mode, UVM_ALL_ON)
        `uvm_field_string(cacc_compare_mode, UVM_ALL_ON)
        `uvm_field_string(sdp_compare_mode, UVM_ALL_ON)
        `uvm_field_string(cdma_wt_pri_mem_request_compare_mode, UVM_ALL_ON)
        `uvm_field_string(cdma_wt_pri_mem_response_compare_mode, UVM_ALL_ON)
        `uvm_field_string(cdma_dat_pri_mem_request_compare_mode, UVM_ALL_ON)
        `uvm_field_string(cdma_dat_pri_mem_response_compare_mode, UVM_ALL_ON)
        `uvm_field_string(sdp_pri_mem_request_compare_mode, UVM_ALL_ON)
        `uvm_field_string(sdp_pri_mem_response_compare_mode, UVM_ALL_ON)
        `uvm_field_string(sdp_b_pri_mem_request_compare_mode, UVM_ALL_ON)
        `uvm_field_string(sdp_b_pri_mem_response_compare_mode, UVM_ALL_ON)
        `uvm_field_string(sdp_n_pri_mem_request_compare_mode, UVM_ALL_ON)
        `uvm_field_string(sdp_n_pri_mem_response_compare_mode, UVM_ALL_ON)
        `uvm_field_string(pdp_pri_mem_request_compare_mode, UVM_ALL_ON)
        `uvm_field_string(pdp_pri_mem_response_compare_mode, UVM_ALL_ON)
        `uvm_field_string(cdp_pri_mem_request_compare_mode, UVM_ALL_ON)
        `uvm_field_string(cdp_pri_mem_response_compare_mode, UVM_ALL_ON)
        //:) epython: generated_end (DO NOT EDIT ABOVE)
    `uvm_component_utils_end

    extern function new(string name = "nvdla_tb_env", uvm_component parent = null);

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

endclass : nvdla_tb_env

// Function: new
// Creates a new nvdla_tb_env component
function nvdla_tb_env::new(string name = "nvdla_tb_env", uvm_component parent = null);
    super.new(name, parent);
    tID = get_type_name().toupper();
endfunction : new

// Function: build_phase
// Used to construct testbench components, build top-level testbench topology
function void nvdla_tb_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)

    csb_agt       = csb_agent::type_id::create("csb_agt",this);
    pri_mem_agt   = dbb_slave_agent#(`NVDLA_PRIMARY_MEMIF_WIDTH)::type_id::create("pri_mem_agt", this);
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    sec_mem_agt   = dbb_slave_agent#(`NVDLA_SECONDARY_MEMIF_WIDTH)::type_id::create("sec_mem_agt", this);
    `endif

    // create internal passive agent
    //:| for dma in dma_ports:
    //:|     temp = dma + "_pri_mem_agt"
    //:|     print("    %-20s = dma_slave_agent::type_id::create(\"%0s_pri_mem_agt\", this);" % (temp, dma))
    //:| if "NVDLA_SECONDARY_MEMIF_ENABLE" in project.PROJVAR:
    //:|     for dma in dma_ports:
    //:|         temp = dma + "_sec_mem_agt"
    //:|         print("    %-20s = dma_slave_agent::type_id::create(\"%0s_sec_mem_agt\", this);" % (temp, dma))
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    cdma_wt_pri_mem_agt  = dma_slave_agent::type_id::create("cdma_wt_pri_mem_agt", this);
    cdma_dat_pri_mem_agt = dma_slave_agent::type_id::create("cdma_dat_pri_mem_agt", this);
    sdp_pri_mem_agt      = dma_slave_agent::type_id::create("sdp_pri_mem_agt", this);
    sdp_b_pri_mem_agt    = dma_slave_agent::type_id::create("sdp_b_pri_mem_agt", this);
    sdp_n_pri_mem_agt    = dma_slave_agent::type_id::create("sdp_n_pri_mem_agt", this);
    pdp_pri_mem_agt      = dma_slave_agent::type_id::create("pdp_pri_mem_agt", this);
    cdp_pri_mem_agt      = dma_slave_agent::type_id::create("cdp_pri_mem_agt", this);
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    csc_dat_a_agt  = cc_slave_agent#(CSC_DT_DW, CSC_DT_DS)::type_id::create("csc_dat_a_agt", this);
    csc_wt_a_agt   = cc_slave_agent#(CSC_WT_DW, CSC_WT_DS)::type_id::create("csc_wt_a_agt", this);
    csc_dat_b_agt  = cc_slave_agent#(CSC_DT_DW, CSC_DT_DS)::type_id::create("csc_dat_b_agt", this);
    csc_wt_b_agt   = cc_slave_agent#(CSC_WT_DW, CSC_WT_DS)::type_id::create("csc_wt_b_agt", this);
    cmac_a_agt     = cc_slave_agent#(CMAC_DW, CMAC_DS)::type_id::create("cmac_a_agt", this);
    cmac_b_agt     = cc_slave_agent#(CMAC_DW, CMAC_DS)::type_id::create("cmac_b_agt", this);

    cacc_agt = dp_slave_agent#(CACC_PW, CACC_DW, CACC_DS)::type_id::create("cacc_agt", this);
    sdp_agt = dp_slave_agent#(SDP_PW, SDP_DW, SDP_DS)::type_id::create("sdp_agt", this);

    intr_hdlr     = nvdla_tb_intr_handler::type_id::create("intr_hdlr", this);
    rm_intr_hdlr  = nvdla_tb_intr_handler::type_id::create("rm_intr_hdlr", this);

    pri_mem       = mem_wrap::type_id::create("pri_mem", this);
    rm_pri_mem    = mem_wrap::type_id::create("rm_pri_mem", this);
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    sec_mem       = mem_wrap::type_id::create("sec_mem", this);
    rm_sec_mem    = mem_wrap::type_id::create("rm_sec_mem", this);
    `endif

    sb            = nvdla_tb_scoreboard_container::type_id::create("sb", this);
    rm_inst       = rm_cmod_nvdla_top::type_id::create("rm_inst", this);

    ral_adapter   = nvdla_reg_adapter#(uvm_tlm_gp)::type_id::create("ral_adapter", this);
    cov           = nvdla_coverage_top::type_id::create("cov", this);

    //set is_rm in intr_hdlr
    uvm_config_db#(int)::set(this, "rm_intr_hdlr", "is_rm", 1);
    uvm_config_db#(int)::set(this, "intr_hdlr", "is_rm", 0);
endfunction : build_phase

// Function: connect_phase
// Used to connect components/tlm ports for environment topoloty
function void nvdla_tb_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)

    // Parse compare mode, determine connection between scoreboard and other components
    // #0, connect DBB agent/reference memory model to scoreboard
    //
    //:| memory_interface_instance_list = mem_intf_list
    //:| for inst in memory_interface_instance_list:
    //:|     msg = '''
    //:|     case(%(inst)s_response_compare_mode)
    //:|         "COMPARE_MODE_DISABLE": begin
    //:|          end
    //:|         "COMPARE_MODE_RTL_AHEAD": begin
    //:|              %(inst)s_agt.slv_mon.mon_analysis_port.connect(sb.%(inst)s_sb.dut_cmpl_fifo.analysis_export);
    //:|              rm_%(inst)s.rsp_ap.connect(sb.%(inst)s_sb.rm_cmpl_fifo.analysis_export);
    //:|          end
    //:|         "COMPARE_MODE_RTL_GATING_CMOD": begin
    //:|              %(inst)s_agt.slv_mon.mon_analysis_port.connect(sb.%(inst)s_sb.dut_cmpl_fifo.analysis_export);
    //:|              rm_%(inst)s.rsp_ap.connect(sb.%(inst)s_sb.rm_cmpl_fifo.analysis_export);
    //:|          end
    //:|         "COMPARE_MODE_LOOSE_COMPARE": begin
    //:|              %(inst)s_agt.slv_mon.mon_analysis_port.connect(sb.%(inst)s_sb.dut_cmpl_fifo.analysis_export);
    //:|              rm_%(inst)s.rsp_ap.connect(sb.%(inst)s_sb.rm_cmpl_fifo.analysis_export);
    //:|          end
    //:|         "COMPARE_MODE_COUNT_TXN_ONLY": begin
    //:|              %(inst)s_agt.slv_mon.mon_analysis_port.connect(sb.%(inst)s_sb.dut_cmpl_fifo.analysis_export);
    //:|              rm_%(inst)s.rsp_ap.connect(sb.%(inst)s_sb.rm_cmpl_fifo.analysis_export);
    //:|         end
    //:|         default: begin
    //:|             `uvm_error(tID, {"Unsupported scoreboard working mode: ", %(inst)s_response_compare_mode})
    //:|         end
    //:|     endcase
    //:|     case(%(inst)s_request_compare_mode)
    //:|         "COMPARE_MODE_DISABLE": begin
    //:|          end
    //:|         "COMPARE_MODE_RTL_AHEAD": begin
    //:|              %(inst)s_agt.slv_mon.mon_analysis_port_request.connect(sb.%(inst)s_sb.dut_init_fifo.analysis_export);
    //:|              rm_%(inst)s.req_ap.connect(sb.%(inst)s_sb.rm_init_fifo.analysis_export);
    //:|          end
    //:|         "COMPARE_MODE_RTL_GATING_CMOD": begin
    //:|              %(inst)s_agt.slv_mon.mon_analysis_port_request.connect(sb.%(inst)s_sb.dut_init_fifo.analysis_export);
    //:|              rm_%(inst)s.req_ap.connect(sb.%(inst)s_sb.rm_init_fifo.analysis_export);
    //:|          end
    //:|         "COMPARE_MODE_LOOSE_COMPARE": begin
    //:|              %(inst)s_agt.slv_mon.mon_analysis_port_request.connect(sb.%(inst)s_sb.dut_init_fifo.analysis_export);
    //:|              rm_%(inst)s.req_ap.connect(sb.%(inst)s_sb.rm_init_fifo.analysis_export);
    //:|          end
    //:|         "COMPARE_MODE_COUNT_TXN_ONLY": begin
    //:|              %(inst)s_agt.slv_mon.mon_analysis_port_request.connect(sb.%(inst)s_sb.dut_init_fifo.analysis_export);
    //:|              rm_%(inst)s.req_ap.connect(sb.%(inst)s_sb.rm_init_fifo.analysis_export);
    //:|         end
    //:|         default: begin
    //:|             `uvm_error(tID, {"Unsupported scoreboard working mode: ", %(inst)s_request_compare_mode})
    //:|         end
    //:|     endcase
    //:| ''' % {'inst':inst}
    //:|     print(msg)
    //:) epython: generated_beg (DO NOT EDIT BELOW)

    case(pri_mem_response_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.pri_mem_sb.dut_cmpl_fifo.analysis_export);
             rm_pri_mem.rsp_ap.connect(sb.pri_mem_sb.rm_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.pri_mem_sb.dut_cmpl_fifo.analysis_export);
             rm_pri_mem.rsp_ap.connect(sb.pri_mem_sb.rm_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.pri_mem_sb.dut_cmpl_fifo.analysis_export);
             rm_pri_mem.rsp_ap.connect(sb.pri_mem_sb.rm_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.pri_mem_sb.dut_cmpl_fifo.analysis_export);
             rm_pri_mem.rsp_ap.connect(sb.pri_mem_sb.rm_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", pri_mem_response_compare_mode})
        end
    endcase
    case(pri_mem_request_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             pri_mem_agt.slv_mon.mon_analysis_port_request.connect(sb.pri_mem_sb.dut_init_fifo.analysis_export);
             rm_pri_mem.req_ap.connect(sb.pri_mem_sb.rm_init_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             pri_mem_agt.slv_mon.mon_analysis_port_request.connect(sb.pri_mem_sb.dut_init_fifo.analysis_export);
             rm_pri_mem.req_ap.connect(sb.pri_mem_sb.rm_init_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             pri_mem_agt.slv_mon.mon_analysis_port_request.connect(sb.pri_mem_sb.dut_init_fifo.analysis_export);
             rm_pri_mem.req_ap.connect(sb.pri_mem_sb.rm_init_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             pri_mem_agt.slv_mon.mon_analysis_port_request.connect(sb.pri_mem_sb.dut_init_fifo.analysis_export);
             rm_pri_mem.req_ap.connect(sb.pri_mem_sb.rm_init_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", pri_mem_request_compare_mode})
        end
    endcase

    //:) epython: generated_end (DO NOT EDIT ABOVE)

    // #1, convolution core and sdp convertor
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
    //:|     msg = '''
    //:|     case(%(inst)s_compare_mode)
    //:|         "COMPARE_MODE_DISABLE": begin
    //:|          end
    //:|         "COMPARE_MODE_RTL_AHEAD": begin
    //:|              %(inst)s_agt.slv_mon.mon_analysis_port.connect(sb.%(inst)s_sb.dut_cmpl_fifo.analysis_export);
    //:|          end
    //:|         "COMPARE_MODE_RTL_GATING_CMOD": begin
    //:|              %(inst)s_agt.slv_mon.mon_analysis_port.connect(sb.%(inst)s_sb.dut_cmpl_fifo.analysis_export);
    //:|          end
    //:|         "COMPARE_MODE_LOOSE_COMPARE": begin
    //:|              %(inst)s_agt.slv_mon.mon_analysis_port.connect(sb.%(inst)s_sb.dut_cmpl_fifo.analysis_export);
    //:|          end
    //:|         "COMPARE_MODE_COUNT_TXN_ONLY": begin
    //:|              %(inst)s_agt.slv_mon.mon_analysis_port.connect(sb.%(inst)s_sb.dut_cmpl_fifo.analysis_export);
    //:|         end
    //:|         default: begin
    //:|             `uvm_error(tID, {"Unsupported scoreboard working mode: ", %(inst)s_compare_mode})
    //:|         end
    //:|     endcase
    //:| ''' % {'inst':inst}
    //:|     print(msg)
    //:) epython: generated_beg (DO NOT EDIT BELOW)

    case(csc_dat_a_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             csc_dat_a_agt.slv_mon.mon_analysis_port.connect(sb.csc_dat_a_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             csc_dat_a_agt.slv_mon.mon_analysis_port.connect(sb.csc_dat_a_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             csc_dat_a_agt.slv_mon.mon_analysis_port.connect(sb.csc_dat_a_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             csc_dat_a_agt.slv_mon.mon_analysis_port.connect(sb.csc_dat_a_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", csc_dat_a_compare_mode})
        end
    endcase


    case(csc_dat_b_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             csc_dat_b_agt.slv_mon.mon_analysis_port.connect(sb.csc_dat_b_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             csc_dat_b_agt.slv_mon.mon_analysis_port.connect(sb.csc_dat_b_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             csc_dat_b_agt.slv_mon.mon_analysis_port.connect(sb.csc_dat_b_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             csc_dat_b_agt.slv_mon.mon_analysis_port.connect(sb.csc_dat_b_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", csc_dat_b_compare_mode})
        end
    endcase


    case(csc_wt_a_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             csc_wt_a_agt.slv_mon.mon_analysis_port.connect(sb.csc_wt_a_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             csc_wt_a_agt.slv_mon.mon_analysis_port.connect(sb.csc_wt_a_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             csc_wt_a_agt.slv_mon.mon_analysis_port.connect(sb.csc_wt_a_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             csc_wt_a_agt.slv_mon.mon_analysis_port.connect(sb.csc_wt_a_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", csc_wt_a_compare_mode})
        end
    endcase


    case(csc_wt_b_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             csc_wt_b_agt.slv_mon.mon_analysis_port.connect(sb.csc_wt_b_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             csc_wt_b_agt.slv_mon.mon_analysis_port.connect(sb.csc_wt_b_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             csc_wt_b_agt.slv_mon.mon_analysis_port.connect(sb.csc_wt_b_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             csc_wt_b_agt.slv_mon.mon_analysis_port.connect(sb.csc_wt_b_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", csc_wt_b_compare_mode})
        end
    endcase


    case(cmac_a_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             cmac_a_agt.slv_mon.mon_analysis_port.connect(sb.cmac_a_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             cmac_a_agt.slv_mon.mon_analysis_port.connect(sb.cmac_a_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             cmac_a_agt.slv_mon.mon_analysis_port.connect(sb.cmac_a_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             cmac_a_agt.slv_mon.mon_analysis_port.connect(sb.cmac_a_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", cmac_a_compare_mode})
        end
    endcase


    case(cmac_b_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             cmac_b_agt.slv_mon.mon_analysis_port.connect(sb.cmac_b_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             cmac_b_agt.slv_mon.mon_analysis_port.connect(sb.cmac_b_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             cmac_b_agt.slv_mon.mon_analysis_port.connect(sb.cmac_b_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             cmac_b_agt.slv_mon.mon_analysis_port.connect(sb.cmac_b_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", cmac_b_compare_mode})
        end
    endcase


    case(cacc_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             cacc_agt.slv_mon.mon_analysis_port.connect(sb.cacc_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             cacc_agt.slv_mon.mon_analysis_port.connect(sb.cacc_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             cacc_agt.slv_mon.mon_analysis_port.connect(sb.cacc_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             cacc_agt.slv_mon.mon_analysis_port.connect(sb.cacc_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", cacc_compare_mode})
        end
    endcase


    case(sdp_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             sdp_agt.slv_mon.mon_analysis_port.connect(sb.sdp_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             sdp_agt.slv_mon.mon_analysis_port.connect(sb.sdp_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             sdp_agt.slv_mon.mon_analysis_port.connect(sb.sdp_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             sdp_agt.slv_mon.mon_analysis_port.connect(sb.sdp_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", sdp_compare_mode})
        end
    endcase

    //:) epython: generated_end (DO NOT EDIT ABOVE)

    // #2, DMA convertor
    //
    //:| dma_list       = dma_ports
    //:| mem_if_list    = mem_intf_list
    //:| kind_list      = ['request', 'response']
    //:| for dma in dma_list:
    //:|     for mem_if in mem_if_list:
    //:|         for kind in kind_list:
    //:|             fifo = 'dut_init_fifo' if kind == 'request' else 'dut_cmpl_fifo'
    //:|             port = 'port_req' if kind == 'request' else 'port'
    //:|             msg = '''
    //:|     case(%(dma)s_%(mem_if)s_%(kind)s_compare_mode)
    //:|         "COMPARE_MODE_DISABLE": begin
    //:|          end
    //:|         "COMPARE_MODE_RTL_AHEAD": begin
    //:|              %(dma)s_%(mem_if)s_agt.slv_mon.mon_analysis_%(port)s.connect(sb.%(dma)s_%(mem_if)s_sb.%(fifo)s.analysis_export);
    //:|          end
    //:|         "COMPARE_MODE_RTL_GATING_CMOD": begin
    //:|              %(dma)s_%(mem_if)s_agt.slv_mon.mon_analysis_%(port)s.connect(sb.%(dma)s_%(mem_if)s_sb.%(fifo)s.analysis_export);
    //:|          end
    //:|         "COMPARE_MODE_LOOSE_COMPARE": begin
    //:|              %(dma)s_%(mem_if)s_agt.slv_mon.mon_analysis_%(port)s.connect(sb.%(dma)s_%(mem_if)s_sb.%(fifo)s.analysis_export);
    //:|          end
    //:|         "COMPARE_MODE_COUNT_TXN_ONLY": begin
    //:|              %(dma)s_%(mem_if)s_agt.slv_mon.mon_analysis_%(port)s.connect(sb.%(dma)s_%(mem_if)s_sb.%(fifo)s.analysis_export);
    //:|         end
    //:|         default: begin
    //:|             `uvm_error(tID, {"Unsupported scoreboard working mode: ", %(dma)s_%(mem_if)s_%(kind)s_compare_mode})
    //:|         end
    //:|     endcase
    //:| ''' % {'dma':dma, 'mem_if':mem_if, 'kind':kind, 'fifo':fifo, 'port':port}
    //:|             print(msg)
    //:) epython: generated_beg (DO NOT EDIT BELOW)

    case(cdma_wt_pri_mem_request_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             cdma_wt_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.cdma_wt_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             cdma_wt_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.cdma_wt_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             cdma_wt_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.cdma_wt_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             cdma_wt_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.cdma_wt_pri_mem_sb.dut_init_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", cdma_wt_pri_mem_request_compare_mode})
        end
    endcase


    case(cdma_wt_pri_mem_response_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             cdma_wt_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.cdma_wt_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             cdma_wt_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.cdma_wt_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             cdma_wt_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.cdma_wt_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             cdma_wt_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.cdma_wt_pri_mem_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", cdma_wt_pri_mem_response_compare_mode})
        end
    endcase


    case(cdma_dat_pri_mem_request_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             cdma_dat_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.cdma_dat_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             cdma_dat_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.cdma_dat_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             cdma_dat_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.cdma_dat_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             cdma_dat_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.cdma_dat_pri_mem_sb.dut_init_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", cdma_dat_pri_mem_request_compare_mode})
        end
    endcase


    case(cdma_dat_pri_mem_response_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             cdma_dat_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.cdma_dat_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             cdma_dat_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.cdma_dat_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             cdma_dat_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.cdma_dat_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             cdma_dat_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.cdma_dat_pri_mem_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", cdma_dat_pri_mem_response_compare_mode})
        end
    endcase


    case(sdp_pri_mem_request_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             sdp_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.sdp_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             sdp_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.sdp_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             sdp_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.sdp_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             sdp_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.sdp_pri_mem_sb.dut_init_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", sdp_pri_mem_request_compare_mode})
        end
    endcase


    case(sdp_pri_mem_response_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             sdp_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.sdp_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             sdp_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.sdp_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             sdp_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.sdp_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             sdp_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.sdp_pri_mem_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", sdp_pri_mem_response_compare_mode})
        end
    endcase


    case(sdp_b_pri_mem_request_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             sdp_b_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.sdp_b_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             sdp_b_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.sdp_b_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             sdp_b_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.sdp_b_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             sdp_b_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.sdp_b_pri_mem_sb.dut_init_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", sdp_b_pri_mem_request_compare_mode})
        end
    endcase


    case(sdp_b_pri_mem_response_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             sdp_b_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.sdp_b_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             sdp_b_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.sdp_b_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             sdp_b_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.sdp_b_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             sdp_b_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.sdp_b_pri_mem_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", sdp_b_pri_mem_response_compare_mode})
        end
    endcase


    case(sdp_n_pri_mem_request_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             sdp_n_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.sdp_n_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             sdp_n_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.sdp_n_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             sdp_n_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.sdp_n_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             sdp_n_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.sdp_n_pri_mem_sb.dut_init_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", sdp_n_pri_mem_request_compare_mode})
        end
    endcase


    case(sdp_n_pri_mem_response_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             sdp_n_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.sdp_n_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             sdp_n_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.sdp_n_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             sdp_n_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.sdp_n_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             sdp_n_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.sdp_n_pri_mem_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", sdp_n_pri_mem_response_compare_mode})
        end
    endcase


    case(pdp_pri_mem_request_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             pdp_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.pdp_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             pdp_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.pdp_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             pdp_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.pdp_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             pdp_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.pdp_pri_mem_sb.dut_init_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", pdp_pri_mem_request_compare_mode})
        end
    endcase


    case(pdp_pri_mem_response_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             pdp_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.pdp_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             pdp_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.pdp_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             pdp_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.pdp_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             pdp_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.pdp_pri_mem_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", pdp_pri_mem_response_compare_mode})
        end
    endcase


    case(cdp_pri_mem_request_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             cdp_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.cdp_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             cdp_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.cdp_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             cdp_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.cdp_pri_mem_sb.dut_init_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             cdp_pri_mem_agt.slv_mon.mon_analysis_port_req.connect(sb.cdp_pri_mem_sb.dut_init_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", cdp_pri_mem_request_compare_mode})
        end
    endcase


    case(cdp_pri_mem_response_compare_mode)
        "COMPARE_MODE_DISABLE": begin
         end
        "COMPARE_MODE_RTL_AHEAD": begin
             cdp_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.cdp_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_RTL_GATING_CMOD": begin
             cdp_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.cdp_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_LOOSE_COMPARE": begin
             cdp_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.cdp_pri_mem_sb.dut_cmpl_fifo.analysis_export);
         end
        "COMPARE_MODE_COUNT_TXN_ONLY": begin
             cdp_pri_mem_agt.slv_mon.mon_analysis_port.connect(sb.cdp_pri_mem_sb.dut_cmpl_fifo.analysis_export);
        end
        default: begin
            `uvm_error(tID, {"Unsupported scoreboard working mode: ", cdp_pri_mem_response_compare_mode})
        end
    endcase

    //:) epython: generated_end (DO NOT EDIT ABOVE)

    // connect reference model internal agent monitors to scoreboard
    //:| for dma in dma_ports:
    //:|     print("    rm_inst.rm_nvdla_dma_convertor_pri.request_%0s.connect(sb.%0s_pri_mem_sb.rm_init_fifo.analysis_export);" % (dma, dma))
    //:|     print("    rm_inst.rm_nvdla_dma_convertor_pri.response_%0s.connect(sb.%0s_pri_mem_sb.rm_cmpl_fifo.analysis_export);" % (dma, dma))
    //:| if "NVDLA_SECONDARY_MEMIF_ENABLE" in project.PROJVAR:
    //:|     for dma in dma_ports:
    //:|         print("    rm_inst.rm_nvdla_dma_convertor_sec.request_%0s.connect(sb.%0s_sec_mem_sb.rm_init_fifo.analysis_export);" % (dma, dma))
    //:|         print("    rm_inst.rm_nvdla_dma_convertor_sec.response_%0s.connect(sb.%0s_sec_mem_sb.rm_cmpl_fifo.analysis_export);" % (dma, dma))
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    rm_inst.rm_nvdla_dma_convertor_pri.request_cdma_wt.connect(sb.cdma_wt_pri_mem_sb.rm_init_fifo.analysis_export);
    rm_inst.rm_nvdla_dma_convertor_pri.response_cdma_wt.connect(sb.cdma_wt_pri_mem_sb.rm_cmpl_fifo.analysis_export);
    rm_inst.rm_nvdla_dma_convertor_pri.request_cdma_dat.connect(sb.cdma_dat_pri_mem_sb.rm_init_fifo.analysis_export);
    rm_inst.rm_nvdla_dma_convertor_pri.response_cdma_dat.connect(sb.cdma_dat_pri_mem_sb.rm_cmpl_fifo.analysis_export);
    rm_inst.rm_nvdla_dma_convertor_pri.request_sdp.connect(sb.sdp_pri_mem_sb.rm_init_fifo.analysis_export);
    rm_inst.rm_nvdla_dma_convertor_pri.response_sdp.connect(sb.sdp_pri_mem_sb.rm_cmpl_fifo.analysis_export);
    rm_inst.rm_nvdla_dma_convertor_pri.request_sdp_b.connect(sb.sdp_b_pri_mem_sb.rm_init_fifo.analysis_export);
    rm_inst.rm_nvdla_dma_convertor_pri.response_sdp_b.connect(sb.sdp_b_pri_mem_sb.rm_cmpl_fifo.analysis_export);
    rm_inst.rm_nvdla_dma_convertor_pri.request_sdp_n.connect(sb.sdp_n_pri_mem_sb.rm_init_fifo.analysis_export);
    rm_inst.rm_nvdla_dma_convertor_pri.response_sdp_n.connect(sb.sdp_n_pri_mem_sb.rm_cmpl_fifo.analysis_export);
    rm_inst.rm_nvdla_dma_convertor_pri.request_pdp.connect(sb.pdp_pri_mem_sb.rm_init_fifo.analysis_export);
    rm_inst.rm_nvdla_dma_convertor_pri.response_pdp.connect(sb.pdp_pri_mem_sb.rm_cmpl_fifo.analysis_export);
    rm_inst.rm_nvdla_dma_convertor_pri.request_cdp.connect(sb.cdp_pri_mem_sb.rm_init_fifo.analysis_export);
    rm_inst.rm_nvdla_dma_convertor_pri.response_cdp.connect(sb.cdp_pri_mem_sb.rm_cmpl_fifo.analysis_export);
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    rm_inst.rm_nvdla_conv_core_socket_convertor_inst.sc2mac_data_a_ana_port.connect(sb.csc_dat_a_sb.rm_cmpl_fifo.analysis_export);
    rm_inst.rm_nvdla_conv_core_socket_convertor_inst.sc2mac_weight_a_ana_port.connect(sb.csc_wt_a_sb.rm_cmpl_fifo.analysis_export);
    rm_inst.rm_nvdla_conv_core_socket_convertor_inst.sc2mac_data_b_ana_port.connect(sb.csc_dat_b_sb.rm_cmpl_fifo.analysis_export);
    rm_inst.rm_nvdla_conv_core_socket_convertor_inst.sc2mac_weight_b_ana_port.connect(sb.csc_wt_b_sb.rm_cmpl_fifo.analysis_export);
    rm_inst.rm_nvdla_conv_core_socket_convertor_inst.mac_a2accu_ana_port.connect(sb.cmac_a_sb.rm_cmpl_fifo.analysis_export);
    rm_inst.rm_nvdla_conv_core_socket_convertor_inst.mac_b2accu_ana_port.connect(sb.cmac_b_sb.rm_cmpl_fifo.analysis_export);
    rm_inst.rm_nvdla_post_processing_socket_convertor_inst.cacc2sdp_analysis_port.connect(sb.cacc_sb.rm_cmpl_fifo.analysis_export);
    rm_inst.rm_nvdla_post_processing_socket_convertor_inst.sdp2pdp_analysis_port.connect(sb.sdp_sb.rm_cmpl_fifo.analysis_export);

    // connect csb monitor/rm_intr_hdlr to reference model, used to transfer csb txn with
    // reference model
    csb_agt.mon.ini_socket.connect(rm_inst.rm_csb_target);
    rm_intr_hdlr.ini_socket.connect(rm_inst.rm_csb_target);

    // conect csb monitor with coverage model
    if ($test$plusargs("fcov_en"))
        csb_agt.mon.analysis_port.connect(cov.analysis_export);

    // connect reference model to memory model
    rm_inst.rm_primary_mem_initator.connect(rm_pri_mem.skt);
    // connect sv agent to memory model
    pri_mem_agt.slv_drv.mem_initiator.connect(pri_mem.skt);
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    rm_inst.rm_secondary_mem_initator.connect(rm_sec_mem.skt);
    sec_mem_agt.slv_drv.mem_initiator.connect(sec_mem.skt);
    `endif

    // get RAL handle
    if(!uvm_config_db#(ral_sys_top)::get(this, "", "ral", ral)) begin
        `uvm_fatal(tID, "RAL handle is null")
    end
    // do RAL connection
    ral.default_map.set_sequencer(csb_agt.sqr, ral_adapter);
endfunction : connect_phase

// Function: end_of_elaboration_phase
// Used to make any final adjustments to the env topology
function void nvdla_tb_env::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(tID, $sformatf("end_of_elaboration_phase begin ..."), UVM_HIGH)

endfunction : end_of_elaboration_phase

// Function: start_of_simulation_phase
// Used to configure verification componets, printing
function void nvdla_tb_env::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(tID, $sformatf("start_of_simulation_phase begin ..."), UVM_HIGH)

endfunction : start_of_simulation_phase

// TASK: run_phase
// Used to execute run-time tasks of simulation
task nvdla_tb_env::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(tID, $sformatf("run_phase begin ..."), UVM_HIGH)

endtask : run_phase

// TASK: reset_phase
// The reset phase is reserved for DUT or interface specific reset behavior
task nvdla_tb_env::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(tID, $sformatf("reset_phase begin ..."), UVM_HIGH)

endtask : reset_phase

// TASK: configure_phase
// Used to program the DUT or memoried in the testbench
task nvdla_tb_env::configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    `uvm_info(tID, $sformatf("configure_phase begin ..."), UVM_HIGH)

endtask : configure_phase

// TASK: main_phase
// Used to execure mainly run-time tasks of simulation
task nvdla_tb_env::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_HIGH)

endtask : main_phase

// TASK: shutdown_phase
// Data "drain" and other operations for graceful termination
task nvdla_tb_env::shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    `uvm_info(tID, $sformatf("shutdown_phase begin ..."), UVM_HIGH)

endtask : shutdown_phase

// Function: extract_phase
// Used to retrieve final state of DUTG and details of scoreboard, etc.
function void nvdla_tb_env::extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(tID, $sformatf("extract_phase begin ..."), UVM_HIGH)

endfunction : extract_phase

// Function: check_phase
// Used to process and check the simulation results
function void nvdla_tb_env::check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info(tID, $sformatf("check_phase begin ..."), UVM_HIGH)

endfunction : check_phase

// Function: report_phase
// Simulation results analysis and reports
function void nvdla_tb_env::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(tID, $sformatf("report_phase begin ..."), UVM_HIGH)

endfunction : report_phase

// Function: final_phase
// Used to complete/end any outstanding actions of testbench
function void nvdla_tb_env::final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info(tID, $sformatf("final_phase begin ..."), UVM_HIGH)

endfunction : final_phase



`endif // _NVDLA_TB_ENV_SV_
