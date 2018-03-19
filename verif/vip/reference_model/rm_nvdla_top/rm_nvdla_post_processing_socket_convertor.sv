`ifndef rm_nvdla_post_processing_socket_convertor
`define rm_nvdla_post_processing_socket_convertor

import dp_pkg::*;
import nvdla_tb_common_pkg::*;

// `include "nvdla_object_globals.svh"
import "DPI-C" context function void parse_cacc2sdp_transaction(
    inout byte unsigned tlm_gp_data_ptr [],
    inout byte unsigned parsed_data_ptr []
);

import "DPI-C" context function void parse_sdp2pdp_transaction(
    inout byte unsigned tlm_gp_data_ptr [],
    inout byte unsigned parsed_data_ptr []
);

typedef struct {
    int                         data[CACC_DS];
    byte                        batch_end;
    byte                        layer_end;
} cacc2sdp_payload_t;

typedef struct {
    shortint                    data[SDP_DS];
} sdp2pdp_payload_t;

`define TAG_CACC2SDP    0
`define TAG_SDP2PDP     1

class rm_nvdla_post_processing_socket_convertor extends uvm_component;
//:| global project
//:| import project
//:| print("    //FIXME: POST_PROCESSING_MONITOR_LIST Should be got from project.pm")
//:| global POST_PROCESSING_MONITOR_LIST
//:| POST_PROCESSING_MONITOR_LIST = ['CACC2SDP', 'SDP2PDP']
//:| print("    // Post Processing interface list:")
//:| for idx in range(len(POST_PROCESSING_MONITOR_LIST)):
//:|     monitor = POST_PROCESSING_MONITOR_LIST[idx].upper()
//:|     print("    `define  TAG_%0s     %0d" % (monitor, idx))
//:| for item in POST_PROCESSING_MONITOR_LIST: print("    int %0s_initial_credit = MONITOR_WORKING_MODE_PASSTHROUGH;" % item.lower())
    string tID;
    `uvm_component_param_utils_begin(rm_nvdla_post_processing_socket_convertor)
//:| for item in POST_PROCESSING_MONITOR_LIST: print("        `uvm_field_int(%0s_initial_credit, UVM_ALL_ON)" % item.lower())
    `uvm_component_utils_end
    uvm_analysis_port   #(dp_txn#(CACC_DW,CACC_DS))  cacc2sdp_analysis_port;
    uvm_analysis_port   #(dp_txn#(SDP_DW,SDP_DS))    sdp2pdp_analysis_port;

//:| for item in POST_PROCESSING_MONITOR_LIST: print("    uvm_tlm_analysis_fifo#(credit_txn) %0s_credit_fifo;" % item.lower())

    /////////////////////////////////////////////////////////////
    // TLM sockets declaration, connects with CMOD
    /////////////////////////////////////////////////////////////
    uvm_tlm_b_target_socket#(rm_nvdla_post_processing_socket_convertor, uvm_tlm_generic_payload)    rm_nvdla_post_processing_socket_convertor_target; 
    uvm_tlm_b_initiator_socket                                                                      rm_nvdla_post_processing_socket_convertor_credit_initiator;

    /////////////////////////////////////////////////////////////
    //// constructor
    /////////////////////////////////////////////////////////////
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        tID = get_type_name();
        tID = tID.toupper();

        cacc2sdp_analysis_port  = new("cacc2sdp_analysis_port", this);
        sdp2pdp_analysis_port   = new("sdp2pdp_analysis_port",  this);
//:| for item in POST_PROCESSING_MONITOR_LIST: print("        %(item)0s_credit_fifo = new(\"%(item)0s_credit_fifo\", this);" % {'item':item.lower()})
    endfunction // new
    
      
    /////////////////////////////////////////////////////////////
    /// build phase()
    /////////////////////////////////////////////////////////////
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        /////////////////////////////////////////////////////////
        // Socket Construction
        ///////////////////////////////////////////////////////// 
        rm_nvdla_post_processing_socket_convertor_target            = new ("rm_nvdla_post_processing_socket_convertor_target", this); 
        rm_nvdla_post_processing_socket_convertor_credit_initiator  = new ("rm_nvdla_post_processing_socket_convertor_credit_initiator", this);

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
//:| for item in  POST_PROCESSING_MONITOR_LIST:
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
        byte unsigned               tlm_gp_data_ptr [];// From tlm_tr
        byte unsigned               parsed_data_ptr [];// From tlm_tr
        byte                        tag;
        dp_txn#(CACC_DW,CACC_DS)    cacc2sdp_txn_nvdla;
        dp_txn#(SDP_DW,SDP_DS)      sdp2pdp_txn_nvdla;
        cacc2sdp_payload_t          cacc2sdp_txn_st;
        sdp2pdp_payload_t           sdp2pdp_txn_st;

        `uvm_info(tID, $sformatf("Got a post processing TLM_GP transaction\n%0s", tlm_tr.sprint()), UVM_FULL)
        // 1) Parse TLM GP, store field in local response variables
        tlm_tr.get_data(tlm_gp_data_ptr);
        tag = tlm_gp_data_ptr[0];
        case (tag)
            `TAG_CACC2SDP: begin
                parsed_data_ptr     = new [$bits(cacc2sdp_payload_t)/8];
                parse_cacc2sdp_transaction(tlm_gp_data_ptr, parsed_data_ptr);
                cacc2sdp_txn_st     = { >> {parsed_data_ptr}};
                cacc2sdp_txn_nvdla  = new ("cacc2sdp_txn_nvdla");
                foreach (cacc2sdp_txn_nvdla.accu_data[i]) begin
                    cacc2sdp_txn_nvdla.accu_data[i]  = cacc2sdp_txn_st.data[i];
                end
                cacc2sdp_txn_nvdla.batch_end    = cacc2sdp_txn_st.batch_end;
                cacc2sdp_txn_nvdla.layer_end    = cacc2sdp_txn_st.layer_end;
                `uvm_info(tID, $sformatf("Send cacc2sdp  transaction.\n%0s", cacc2sdp_txn_nvdla.sprint()), UVM_FULL)
                cacc2sdp_analysis_port.write(cacc2sdp_txn_nvdla);
            end
            `TAG_SDP2PDP: begin
                parsed_data_ptr     = new [$bits(sdp2pdp_payload_t)/8];
                parse_sdp2pdp_transaction(tlm_gp_data_ptr, parsed_data_ptr);
                sdp2pdp_txn_st      = { >> {parsed_data_ptr}};
                sdp2pdp_txn_nvdla   = new ("sdp2pdp_txn_nvdla");
                foreach (sdp2pdp_txn_nvdla.sdp_data[i]) begin
                    sdp2pdp_txn_nvdla.sdp_data[i] = sdp2pdp_txn_st.data[i];
                end
                `uvm_info(tID, $sformatf("Send sdp2pdp transaction.\n%0s", sdp2pdp_txn_nvdla.sprint()), UVM_FULL)
                sdp2pdp_analysis_port.write(sdp2pdp_txn_nvdla);
            end
            default:
              `uvm_warning(tID, $sformatf("Invalid tag ID: %0d, valids are: [%0d, %0d]", tag, `TAG_CACC2SDP, `TAG_SDP2PDP))
        endcase
     endtask

//:| for item in POST_PROCESSING_MONITOR_LIST:
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
//:|         rm_nvdla_post_processing_socket_convertor_credit_initiator.b_transport(tlm_gp, tlm_time);
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
//:|             rm_nvdla_post_processing_socket_convertor_credit_initiator.b_transport(tlm_gp, tlm_time);
//:|         end
//:|     endtask'''
//:|     print(message % {'monitor':monitor, 'MONITOR':MONITOR})

endclass: rm_nvdla_post_processing_socket_convertor

`endif // rm_nvdla_post_processing_socket_convertor

