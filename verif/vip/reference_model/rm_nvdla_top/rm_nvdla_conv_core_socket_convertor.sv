`ifndef rm_nvdla_conv_core_socket_convertor
`define rm_nvdla_conv_core_socket_convertor

import cc_pkg::*;
import nvdla_tb_common_pkg::*;

import "DPI-C" context function void parse_sc2mac_data_transaction(
    inout byte unsigned tlm_gp_data_ptr [],
    inout byte unsigned parsed_data_ptr []
);

import "DPI-C" context function void parse_sc2mac_weight_transaction(
    inout byte unsigned tlm_gp_data_ptr [],
    inout byte unsigned parsed_data_ptr []
);

import "DPI-C" context function void parse_mac2accu_transaction(
    inout byte unsigned tlm_gp_data_ptr [],
    inout byte unsigned parsed_data_ptr []
);

typedef struct {
    bit [CSC_DT_DS-1:0]         mask;
    byte                        data[CSC_DT_DS];
    byte                        layer_end;
    byte                        channel_end;
    byte                        stripe_end;
    byte                        stripe_st;
    byte                        batch_index;
} sc2mac_data_payload_t;

typedef struct {
    bit [CSC_WT_DS-1:0]         mask;
    byte                        data[CSC_WT_DS];
    bit [(((CMAC_DS+7)/8)*8)-1:0] wt_sel;
} sc2mac_weight_payload_t;

typedef struct {
    bit [(((CMAC_DS+7)/8)*8)-1:0] mask;
    byte                        mode;
    bit [31:0]                  data[CMAC_DS];
    byte                        layer_end;
    byte                        channel_end;
    byte                        stripe_end;
    byte                        stripe_st;
    byte                        batch_index;
} mac2accu_payload_t;

class rm_nvdla_conv_core_socket_convertor extends uvm_component;

//:| global project
//:| import project
//:| print("    //FIXME: CONVOLUTION_CORE_MONITOR_LIST Should be got from project.pm")
//:| global CONVOLUTION_CORE_MONITOR_LIST
//:| CONVOLUTION_CORE_MONITOR_LIST = ["SC2MAC_DAT_A", "SC2MAC_DAT_B", "SC2MAC_WT_A", "SC2MAC_WT_B", "MAC_A2ACCU", "MAC_B2ACCU"]
//:| print("    // Convolution interface list:")
//:| for idx in range(len(CONVOLUTION_CORE_MONITOR_LIST)):
//:|     monitor = CONVOLUTION_CORE_MONITOR_LIST[idx].upper()
//:|     print("    `define  TAG_%-20s     %0d" % (monitor, idx))
//:| for idx in range(len(CONVOLUTION_CORE_MONITOR_LIST)):
//:|     monitor = CONVOLUTION_CORE_MONITOR_LIST[idx].lower()
//:|     print("    int %0s_initial_credit = MONITOR_WORKING_MODE_PASSTHROUGH;" % monitor)
    string tID;
    `uvm_component_param_utils_begin(rm_nvdla_conv_core_socket_convertor)
//:| for item in CONVOLUTION_CORE_MONITOR_LIST: print("        `uvm_field_int(%0s_initial_credit, UVM_ALL_ON)" % item.lower())
    `uvm_component_utils_end
    

    uvm_analysis_port   #(cc_txn#(CSC_DT_DW,CSC_DT_DS))   sc2mac_data_a_ana_port;
    uvm_analysis_port   #(cc_txn#(CSC_DT_DW,CSC_DT_DS))   sc2mac_data_b_ana_port;
    uvm_analysis_port   #(cc_txn#(CSC_WT_DW,CSC_WT_DS))   sc2mac_weight_a_ana_port;
    uvm_analysis_port   #(cc_txn#(CSC_WT_DW,CSC_WT_DS))   sc2mac_weight_b_ana_port;
    uvm_analysis_port   #(cc_txn#(CMAC_DW, CMAC_DS))      mac_a2accu_ana_port;
    uvm_analysis_port   #(cc_txn#(CMAC_DW, CMAC_DS))      mac_b2accu_ana_port;

//:| for item in CONVOLUTION_CORE_MONITOR_LIST: print("    uvm_tlm_analysis_fifo#(credit_txn) %0s_credit_fifo;" % item.lower())

    /////////////////////////////////////////////////////////////
    // TLM sockets declaration, connects with CMOD
    /////////////////////////////////////////////////////////////
    uvm_tlm_b_target_socket#(rm_nvdla_conv_core_socket_convertor, uvm_tlm_generic_payload)  rm_nvdla_conv_core_socket_convertor_target; 
    uvm_tlm_b_initiator_socket                                                              rm_nvdla_conv_core_socket_convertor_credit_initiator;

    // extern protected task dma_transaction_convertor();

    /////////////////////////////////////////////////////////////
    //// constructor
    /////////////////////////////////////////////////////////////
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        tID = get_type_name();
        tID = tID.toupper();

        sc2mac_data_a_ana_port      = new ("sc2mac_data_a_ana_port",      this);
        sc2mac_data_b_ana_port      = new ("sc2mac_data_b_ana_port",      this);
        sc2mac_weight_a_ana_port    = new ("sc2mac_weight_a_ana_port",    this);
        sc2mac_weight_b_ana_port    = new ("sc2mac_weight_b_ana_port",    this);
        mac_a2accu_ana_port         = new ("mac_a2accu_ana_port",         this);
        mac_b2accu_ana_port         = new ("mac_b2accu_ana_port",         this);
//:| for item in CONVOLUTION_CORE_MONITOR_LIST: print("        %(item)0s_credit_fifo = new(\"%(item)0s_credit_fifo\", this);" % {'item':item.lower()})
    endfunction // new
    
      
    /////////////////////////////////////////////////////////////
    /// build phase()
    /////////////////////////////////////////////////////////////
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        /////////////////////////////////////////////////////////
        // Socket Construction
        ///////////////////////////////////////////////////////// 
        rm_nvdla_conv_core_socket_convertor_target              = new ("rm_nvdla_conv_core_socket_convertor_target", this); 
        rm_nvdla_conv_core_socket_convertor_credit_initiator    = new ("rm_nvdla_conv_core_socket_convertor_credit_initiator", this);

        `uvm_info(tID, "build_phase is executed", UVM_FULL)
    endfunction : build_phase
    
      
    /////////////////////////////////////////////////////////////
    /// connect phase()
    /////////////////////////////////////////////////////////////
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(tID, "connect_phase is executed", UVM_FULL)
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
        super.run_phase(phase);
        `uvm_info(tID, "Start to execute run_phase", UVM_LOW)
        
        fork
        //:| for item in CONVOLUTION_CORE_MONITOR_LIST:
        //:|     monitor = item.lower()
        //:|     message = '''
        //:|             forever begin : %(monitor)0s_credit_transponder_task
        //:|                 %(monitor)0s_credit_transponder();
        //:|             end : %(monitor)0s_credit_transponder_task'''
        //:|     print(message % {'monitor':monitor})
        join
        `uvm_info(tID, "run_phase is executed", UVM_LOW)

    endtask


    /////////////////////////////////////////////////////////////
    ///  report_phase()
    /////////////////////////////////////////////////////////////
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(tID, "report_phase is executed", UVM_FULL)
    endfunction

    /////////////////////////////////////////////////////////////
    ///  final_phase()
    /////////////////////////////////////////////////////////////
    virtual function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        `uvm_info(tID, "final_phase is executed", UVM_FULL)
    endfunction

    // 1) Parse TLM GP, return info stored in a SystemVerilog byte unsigned array txn_info
    // 2) Handling txn_info, convert it into nvdla transaction
    // 3) Send nvdla transaction to corresponding analysis port

    task b_transport(ref uvm_tlm_generic_payload tlm_tr, uvm_tlm_time delay);
        byte unsigned                tlm_gp_data_ptr [];// From tlm_tr
        byte unsigned                parsed_data_ptr [];// From tlm_tr
        byte                         tag;
        credit_txn                   sc2mac_data_a_credit_txn;
        credit_txn                   sc2mac_data_b_credit_txn;
        credit_txn                   sc2mac_weight_a_credit_txn;
        credit_txn                   sc2mac_weight_b_credit_txn;
        credit_txn                   mac_a2accu_credit_txn;
        credit_txn                   mac_b2accu_credit_txn;
        cc_txn#(CSC_DT_DW,CSC_DT_DS) sc2mac_data_a_txn_nvdla;
        cc_txn#(CSC_DT_DW,CSC_DT_DS) sc2mac_data_b_txn_nvdla;
        cc_txn#(CSC_WT_DW,CSC_WT_DS) sc2mac_weight_a_txn_nvdla;
        cc_txn#(CSC_WT_DW,CSC_WT_DS) sc2mac_weight_b_txn_nvdla;
        cc_txn#(CMAC_DW,CMAC_DS)     mac_a2accu_txn_nvdla;
        cc_txn#(CMAC_DW,CMAC_DS)     mac_b2accu_txn_nvdla;
        sc2mac_data_payload_t        sc2mac_data_a_txn_st;
        sc2mac_data_payload_t        sc2mac_data_b_txn_st;
        sc2mac_weight_payload_t      sc2mac_weight_a_txn_st;
        sc2mac_weight_payload_t      sc2mac_weight_b_txn_st;
        mac2accu_payload_t           mac_a2accu_txn_st;
        mac2accu_payload_t           mac_b2accu_txn_st;

        `uvm_info(tID, $sformatf("Got a convolution core TLM_GP transaction\n%0s", tlm_tr.sprint()), UVM_FULL)
        // 1) Parse TLM GP, store field in local response variables
        tlm_tr.get_data(tlm_gp_data_ptr);
        tag = tlm_gp_data_ptr[0];
        case (tag)
            `TAG_SC2MAC_DAT_A: begin
                `uvm_info(tID, $sformatf("SC2MAC_DAT_A: $bits(sc2mac_data_payload_t)/8=%0d", $bits(sc2mac_data_payload_t)/8), UVM_FULL)
                parsed_data_ptr         = new [$bits(sc2mac_data_payload_t)/8];
                parse_sc2mac_data_transaction(tlm_gp_data_ptr, parsed_data_ptr);
                sc2mac_data_a_txn_st    = { >> {parsed_data_ptr}};
                sc2mac_data_a_txn_nvdla = new ("sc2mac_data_a");
                sc2mac_data_a_txn_nvdla.batch_index   = sc2mac_data_a_txn_st.batch_index;
                sc2mac_data_a_txn_nvdla.mask          = sc2mac_data_a_txn_st.mask;
                foreach (sc2mac_data_a_txn_nvdla.data[i]) begin
                    sc2mac_data_a_txn_nvdla.data[i]   = sc2mac_data_a_txn_st.data[i];
                end
                sc2mac_data_a_txn_nvdla.layer_end     = sc2mac_data_a_txn_st.layer_end;
                sc2mac_data_a_txn_nvdla.channel_end   = sc2mac_data_a_txn_st.channel_end;
                sc2mac_data_a_txn_nvdla.stripe_end    = sc2mac_data_a_txn_st.stripe_end;
                sc2mac_data_a_txn_nvdla.stripe_st     = sc2mac_data_a_txn_st.stripe_st;
                `uvm_info(tID, $sformatf("Send sc2mac_data_a transaction.\n%0s", sc2mac_data_a_txn_nvdla.sprint()), UVM_FULL)
                sc2mac_data_a_ana_port.write(sc2mac_data_a_txn_nvdla);
            end
            `TAG_SC2MAC_DAT_B: begin
               `uvm_info(tID, $sformatf("SC2MAC_DAT_B: $bits(sc2mac_data_payload_t)/8=%0d", $bits(sc2mac_data_payload_t)/8), UVM_FULL)
                parsed_data_ptr         = new [$bits(sc2mac_data_payload_t)/8];
                parse_sc2mac_data_transaction(tlm_gp_data_ptr, parsed_data_ptr);
                sc2mac_data_b_txn_st      = { >> {parsed_data_ptr}};
                sc2mac_data_b_txn_nvdla   = new ("sc2mac_data_b_b");
                sc2mac_data_b_txn_nvdla.batch_index   = sc2mac_data_b_txn_st.batch_index;
                sc2mac_data_b_txn_nvdla.mask          = sc2mac_data_b_txn_st.mask;
                foreach (sc2mac_data_b_txn_nvdla.data[i]) begin
                    sc2mac_data_b_txn_nvdla.data[i]   = sc2mac_data_b_txn_st.data[i];
                end
                sc2mac_data_b_txn_nvdla.layer_end     = sc2mac_data_b_txn_st.layer_end;
                sc2mac_data_b_txn_nvdla.channel_end   = sc2mac_data_b_txn_st.channel_end;
                sc2mac_data_b_txn_nvdla.stripe_end    = sc2mac_data_b_txn_st.stripe_end;
                sc2mac_data_b_txn_nvdla.stripe_st     = sc2mac_data_b_txn_st.stripe_st;
                `uvm_info(tID, $sformatf("Send sc2mac_data_b_b transaction.\n%0s", sc2mac_data_b_txn_nvdla.sprint()), UVM_FULL)
                sc2mac_data_b_ana_port.write(sc2mac_data_b_txn_nvdla);
            end
            `TAG_SC2MAC_WT_A: begin
                parsed_data_ptr         = new [$bits(sc2mac_weight_payload_t)/8];
                `uvm_info(tID, $sformatf("SC2MAC_WT_A: $bits(sc2mac_weight_payload_t)/8=%0d", $bits(sc2mac_weight_payload_t)/8), UVM_FULL)
                parse_sc2mac_weight_transaction(tlm_gp_data_ptr, parsed_data_ptr);
                sc2mac_weight_a_txn_st    = { >> {parsed_data_ptr}};
                sc2mac_weight_a_txn_nvdla = new ("sc2mac_weight_a_a");
                sc2mac_weight_a_txn_nvdla.mask    = sc2mac_weight_a_txn_st.mask;
                sc2mac_weight_a_txn_nvdla.wt_sel  = sc2mac_weight_a_txn_st.wt_sel;
                foreach (sc2mac_weight_a_txn_nvdla.data[i]) begin
                    sc2mac_weight_a_txn_nvdla.data[i] = sc2mac_weight_a_txn_st.data[i];
                end
                `uvm_info(tID, $sformatf("Send sc2mac_weight_a_a transaction.\n%0s", sc2mac_weight_a_txn_nvdla.sprint()), UVM_FULL)
                sc2mac_weight_a_ana_port.write(sc2mac_weight_a_txn_nvdla);
            end
            `TAG_SC2MAC_WT_B: begin
                parsed_data_ptr         = new [$bits(sc2mac_weight_payload_t)/8];
                `uvm_info(tID, $sformatf("SC2MAC_WT_B: $bits(sc2mac_weight_payload_t)/8=%0d", $bits(sc2mac_weight_payload_t)/8), UVM_FULL)
                parse_sc2mac_weight_transaction(tlm_gp_data_ptr, parsed_data_ptr);
                sc2mac_weight_b_txn_st    = { >> {parsed_data_ptr}};
                sc2mac_weight_b_txn_nvdla = new ("sc2mac_weight_b_b");
                sc2mac_weight_b_txn_nvdla.mask    = sc2mac_weight_b_txn_st.mask;
                sc2mac_weight_b_txn_nvdla.wt_sel  = sc2mac_weight_b_txn_st.wt_sel;
                foreach (sc2mac_weight_b_txn_nvdla.data[i]) begin
                    sc2mac_weight_b_txn_nvdla.data[i] = sc2mac_weight_b_txn_st.data[i];
                end
                `uvm_info(tID, $sformatf("Send sc2mac_weight_b_b transaction.\n%0s", sc2mac_weight_b_txn_nvdla.sprint()), UVM_FULL)
                sc2mac_weight_b_ana_port.write(sc2mac_weight_b_txn_nvdla);
            end
            `TAG_MAC_A2ACCU: begin
                parsed_data_ptr     = new [$bits(mac2accu_payload_t)/8];
                `uvm_info(tID, $sformatf("MAC_A2ACCU: $bits(mac2accu_payload_t)/8=%0d", $bits(mac2accu_payload_t)/8), UVM_FULL)
                parse_mac2accu_transaction(tlm_gp_data_ptr, parsed_data_ptr);
                mac_a2accu_txn_st     = { >> {parsed_data_ptr}};
                mac_a2accu_txn_nvdla  = new ("mac_a2accu_txn");
                mac_a2accu_txn_nvdla.mask         = mac_a2accu_txn_st.mask;
                mac_a2accu_txn_nvdla.mode         = mac_a2accu_txn_st.mode;
                foreach (mac_a2accu_txn_nvdla.data[i]) begin
                    mac_a2accu_txn_nvdla.data[i]  = mac_a2accu_txn_st.data[i];
                end
                mac_a2accu_txn_nvdla.layer_end    = mac_a2accu_txn_st.layer_end;
                mac_a2accu_txn_nvdla.channel_end  = mac_a2accu_txn_st.channel_end;
                mac_a2accu_txn_nvdla.stripe_end   = mac_a2accu_txn_st.stripe_end;
                mac_a2accu_txn_nvdla.stripe_st    = mac_a2accu_txn_st.stripe_st;
                mac_a2accu_txn_nvdla.batch_index  = mac_a2accu_txn_st.batch_index;
                `uvm_info(tID, $sformatf("Send mac_a2accu_txn transaction.\n%0s", mac_a2accu_txn_nvdla.sprint()), UVM_FULL)
                mac_a2accu_ana_port.write(mac_a2accu_txn_nvdla);
            end
            `TAG_MAC_B2ACCU: begin
                parsed_data_ptr     = new [$bits(mac2accu_payload_t)/8];
                `uvm_info(tID, $sformatf("MAC_B2ACCU: $bits(mac2accu_payload_t)/8=%0d", $bits(mac2accu_payload_t)/8), UVM_FULL)
                parse_mac2accu_transaction(tlm_gp_data_ptr, parsed_data_ptr);
                mac_b2accu_txn_st     = { >> {parsed_data_ptr}};
                mac_b2accu_txn_nvdla  = new ("mac_b2accu_txn");
                mac_b2accu_txn_nvdla.mask         = mac_b2accu_txn_st.mask;
                mac_b2accu_txn_nvdla.mode         = mac_b2accu_txn_st.mode;
                foreach (mac_b2accu_txn_nvdla.data[i]) begin
                    mac_b2accu_txn_nvdla.data[i]  = mac_b2accu_txn_st.data[i];
                end
                mac_b2accu_txn_nvdla.layer_end    = mac_b2accu_txn_st.layer_end;
                mac_b2accu_txn_nvdla.channel_end  = mac_b2accu_txn_st.channel_end;
                mac_b2accu_txn_nvdla.stripe_end   = mac_b2accu_txn_st.stripe_end;
                mac_b2accu_txn_nvdla.stripe_st    = mac_b2accu_txn_st.stripe_st;
                mac_b2accu_txn_nvdla.batch_index  = mac_b2accu_txn_st.batch_index;
                `uvm_info(tID, $sformatf("Send mac_b2accu_txn transaction.\n%0s", mac_b2accu_txn_nvdla.sprint()), UVM_FULL)
                mac_b2accu_ana_port.write(mac_b2accu_txn_nvdla);
            end
        endcase
     endtask

//:| for item in CONVOLUTION_CORE_MONITOR_LIST:
//:|     MONITOR = item.upper()
//:|     monitor = item.lower()
//:|     message = '''
//:|     task %(monitor)0s_credit_transponder();
//:|         byte unsigned                   tlm_gp_data_ptr [];// From tlm_gp
//:|         byte unsigned                   tlm_gp_byte_enable_ptr [];// From tlm_gp
//:|         credit_txn                      conv_credit_txn;
//:|         credit_structure                conv_credit_st;
//:|         uvm_tlm_generic_payload         tlm_gp;
//:|         uvm_tlm_time                    tlm_time;
//:|         tlm_time                = new( "<unused>" );
//:|         tlm_gp                  = uvm_tlm_generic_payload::type_id::create( "%(monitor)0s_credit" );
//:|         tlm_gp_data_ptr         = new [$bits(credit_structure)/8];
//:|         tlm_gp_byte_enable_ptr  = new [$bits(credit_structure)/8];
//:|         tlm_gp.set_write();
//:|         tlm_gp.set_data_length(tlm_gp_data_ptr.size());
//:|         // Initialize tlm_gp_byte_enable_ptr
//:|         foreach (tlm_gp_byte_enable_ptr[i]) begin
//:|             tlm_gp_byte_enable_ptr[i] = 8'hFF;
//:|         end
//:|         tlm_gp.set_byte_enable_length(tlm_gp_byte_enable_ptr.size());
//:|         tlm_gp.set_byte_enable(tlm_gp_byte_enable_ptr);
//:|         conv_credit_st.txn_id   = `TAG_%(MONITOR)0s;
//:|         conv_credit_st.is_req   = 1;                // Don't care this field
//:|         conv_credit_st.not_write  = 0;                // Don't care this field
//:|         // Grant initial credits, begin
//:|         conv_credit_st.credit   = %(monitor)0s_initial_credit;
//:|         tlm_gp_data_ptr = {<< byte{conv_credit_st.txn_id, conv_credit_st.not_write, conv_credit_st.is_req, conv_credit_st.credit, conv_credit_st.sub_id}};
//:|         tlm_gp.set_data(tlm_gp_data_ptr);
//:|         rm_nvdla_conv_core_socket_convertor_credit_initiator.b_transport(tlm_gp, tlm_time);
//:|         // Grant initial credits, end
//:|         while (1'b1) begin
//:|             %(monitor)0s_credit_fifo.get(conv_credit_txn);
//:|             conv_credit_st.credit   = conv_credit_txn.credit;
//:|             `uvm_info(tID, $sformatf(\"response_%(monitor)0s_credit is \\n%%p", conv_credit_st), UVM_FULL)
//:|             tlm_gp_data_ptr = {<< byte{conv_credit_st.txn_id, conv_credit_st.not_write, conv_credit_st.is_req, conv_credit_st.credit, conv_credit_st.sub_id}};
//:|             foreach (tlm_gp_data_ptr[i]) begin
//:|                 `uvm_info(tID, $sformatf(\"tlm_gp_data_ptr[0x%%x]:0x%%x\\n", i, tlm_gp_data_ptr[i]), UVM_FULL)
//:|             end
//:|             foreach (tlm_gp_byte_enable_ptr[i]) begin
//:|                 `uvm_info(tID, $sformatf(\"tlm_gp_byte_enable_ptr[0x%%x]:0x%%x\\n", i, tlm_gp_byte_enable_ptr[i]), UVM_FULL)
//:|             end
//:|             tlm_gp.set_data(tlm_gp_data_ptr);
//:|             rm_nvdla_conv_core_socket_convertor_credit_initiator.b_transport(tlm_gp, tlm_time);
//:|         end
//:|     endtask'''
//:|     print(message % {'monitor':monitor, 'MONITOR':MONITOR})
endclass: rm_nvdla_conv_core_socket_convertor

`endif // rm_nvdla_conv_core_socket_convertor




