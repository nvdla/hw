`ifndef rm_nvdla_dma_convertor
`define rm_nvdla_dma_convertor

import dma_pkg::*;
import nvdla_tb_common_pkg::*;

import "DPI-C" context function void parse_read_dma_transaction(
    inout byte unsigned tlm_gp_data_ptr [],
    inout byte unsigned parsed_data_ptr []
);

import "DPI-C" context function void parse_write_dma_transaction(
    inout byte unsigned tlm_gp_data_ptr [],
    inout byte unsigned parsed_data_ptr []
);

`define NVDLA_MONITOR_DMA_STATUS_REQUEST  0
`define NVDLA_MONITOR_DMA_STATUS_RESPONSE 1
`define TAG_CMD                           0
`define TAG_DATA                          1

`ifndef DMA_WRITE_CMD_PAD_BYTES
`define DMA_WRITE_CMD_PAD_BYTES           53
`endif

typedef struct packed{
    bit      [`DMA_WRITE_CMD_PAD_BYTES*8-1:0] pad;
    longint  unsigned                         addr;
    shortint unsigned                         size;
    byte     unsigned                         require_ack;
} dma_write_cmd_t;

typedef struct packed{
    bit [511:0]         data; 
} dma_write_data_t;


typedef union packed{
    dma_write_cmd_t     dma_write_cmd;
    dma_write_data_t    dma_write_data;
} nvdla_dma_wr_req_u;

typedef struct packed{
    byte unsigned       tag;
    nvdla_dma_wr_req_u  pd;
} nvdla_dma_wr_req_t;

typedef struct packed{
    byte unsigned       dma_id;
    byte unsigned       status; // Request, Response
    nvdla_dma_wr_req_t  req;
} nvdla_monitor_dma_wr_transaction_t;

typedef struct packed{
    longint unsigned    addr ; 
    shortint unsigned   size ; 
} dma_read_cmd_t;

typedef union packed{
    dma_read_cmd_t dma_read_cmd;
} nvdla_dma_rd_req_u;

typedef struct packed{
    nvdla_dma_rd_req_u  pd; 
} nvdla_dma_rd_req_t;

typedef struct packed{
    bit [511:0]         data; 
    byte unsigned       mask; 
} dma_read_data_t;

typedef union packed{
    dma_read_data_t dma_read_data;
} nvdla_dma_rd_rsp_u;

typedef struct packed{
    nvdla_dma_rd_rsp_u  pd; 
} nvdla_dma_rd_rsp_t;

typedef struct packed{
    byte unsigned       dma_id;
    byte unsigned       status; // Request, Response
    nvdla_dma_rd_req_t  req;
    nvdla_dma_rd_rsp_t  rsp;
} nvdla_monitor_dma_rd_transaction_t;


class rm_nvdla_dma_convertor extends uvm_component;
    // FIXME: DMA ID define, should be got from "project.pm", wait for 
    // "project.pm" updapte
    // Read DMA lists
    `define BDMA_READ_ID     0
    `define SDP_READ_ID      1
    `define PDP_READ_ID      2
    `define CDP_READ_ID      3
    `define RBK_READ_ID      4
    `define SDP_B_READ_ID    5
    `define SDP_N_READ_ID    6
    `define SDP_E_READ_ID    7
    `define CDMA_DAT_READ_ID 8
    `define CDMA_WT_READ_ID  9
    
    // Write DMA lists
    `define BDMA_WRITE_ID    0
    `define SDP_WRITE_ID     1
    `define PDP_WRITE_ID     2
    `define CDP_WRITE_ID     3
    `define RBK_WRITE_ID     4

    string tID;

//:| global project
//:| import project
//:| print("    // Hack for generating DMA_LISTS array")
//:| global READ_DMA_LIST
//:| global WRITE_DMA_LIST
//:| READ_DMA_LIST = []
//:| WRITE_DMA_LIST = []
//:| if "NVDLA_BDMA_ENABLE" in project.PROJVAR:
//:|     READ_DMA_LIST.append("bdma")
//:|     WRITE_DMA_LIST.append("bdma")
//:| READ_DMA_LIST.append("sdp")
//:| WRITE_DMA_LIST.append("sdp")
//:| if "NVDLA_PDP_ENABLE" in project.PROJVAR:
//:|     READ_DMA_LIST.append("pdp")
//:|     WRITE_DMA_LIST.append("pdp")
//:| if "NVDLA_CDP_ENABLE" in project.PROJVAR:
//:|     READ_DMA_LIST.append("cdp")
//:|     WRITE_DMA_LIST.append("cdp")
//:| if "NVDLA_RUBIK_ENABLE" in project.PROJVAR:
//:|     READ_DMA_LIST.append("rbk")
//:|     WRITE_DMA_LIST.append("rbk")
//:| if "NVDLA_SDP_BS_ENABLE" in project.PROJVAR:
//:|     READ_DMA_LIST.append("sdp_b")
//:| if "NVDLA_SDP_BN_ENABLE" in project.PROJVAR:
//:|     READ_DMA_LIST.append("sdp_n")
//:| if "NVDLA_SDP_EW_ENABLE" in project.PROJVAR:
//:|     READ_DMA_LIST.append("sdp_e")
//:| READ_DMA_LIST.append("cdma_dat")
//:| READ_DMA_LIST.append("cdma_wt")
//:| global uvm_analysis_port_request_list;
//:| global uvm_analysis_port_response_list;
//:| uvm_analysis_port_request_list  = {}
//:| uvm_analysis_port_response_list = {}
//:| for dma in READ_DMA_LIST:  print("    dma_txn         read_request_fifo_array_%0s[$];" % dma)
//:| for dma in WRITE_DMA_LIST: print("    dma_txn         write_request_fifo_array_%0s[$];" % dma)
//:| for dma in WRITE_DMA_LIST: print("    dma_txn         write_response_fifo_array_%0s[$];" % dma)
//:| for dma in READ_DMA_LIST:
//:|     uvm_analysis_port_request_list[dma]  = 1; 
//:|     uvm_analysis_port_response_list[dma] = 1;
//:| for dma in WRITE_DMA_LIST:
//:|     uvm_analysis_port_request_list[dma]  = 1; 
//:|     uvm_analysis_port_response_list[dma] = 1;
//:| for dma in READ_DMA_LIST:  print("    int unsigned        read_response_size_idx_%0s;" % dma)
//:| for dma in WRITE_DMA_LIST: print("    int unsigned        write_response_size_idx_%0s;" % dma)
//:| for key in uvm_analysis_port_request_list.keys():  print("    uvm_analysis_port#(dma_txn) request_%0s;" % key)
//:| for key in uvm_analysis_port_response_list.keys(): print("    uvm_analysis_port#(dma_txn) response_%0s;" % key)
//:| for key in uvm_analysis_port_request_list.keys():  print("    uvm_tlm_analysis_fifo#(credit_txn) request_%0s_credit_fifo;" % key)
//:| for key in uvm_analysis_port_response_list.keys(): print("    uvm_tlm_analysis_fifo#(credit_txn) response_%0s_credit_fifo;" % key)
//:| for key in uvm_analysis_port_request_list.keys():
//:|     print("    int %0s_read_request_initial_credit = SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_PASSTHROUGH;" % key)
//:|     print("    int %0s_write_request_initial_credit = SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_PASSTHROUGH;" % key)
//:| for key in uvm_analysis_port_response_list.keys():
//:|     print("    int %0s_read_response_initial_credit = SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_PASSTHROUGH;" % key)
//:|     print("    int %0s_write_response_initial_credit = SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_PASSTHROUGH;" % key)

    `uvm_component_param_utils_begin(rm_nvdla_dma_convertor)
//:| for key in uvm_analysis_port_request_list.keys():
//:|     print("    `uvm_field_int(%0s_read_request_initial_credit, UVM_ALL_ON)" % key)
//:|     print("    `uvm_field_int(%0s_write_request_initial_credit, UVM_ALL_ON)" % key)
//:| for key in uvm_analysis_port_response_list.keys():
//:|     print("    `uvm_field_int(%0s_read_response_initial_credit, UVM_ALL_ON)" % key)
//:|     print("    `uvm_field_int(%0s_write_response_initial_credit, UVM_ALL_ON)" % key)
    `uvm_component_utils_end


    /////////////////////////////////////////////////////////////
    // TLM sockets declaration, connects with CMOD
    /////////////////////////////////////////////////////////////
    uvm_tlm_b_target_socket#(rm_nvdla_dma_convertor, uvm_tlm_generic_payload)   rm_nvdla_dma_convertor_target; 
    uvm_tlm_b_initiator_socket                                                  rm_nvdla_dma_convertor_credit_initiator;

    // extern protected task dma_transaction_convertor();

    /////////////////////////////////////////////////////////////
    //// constructor
    /////////////////////////////////////////////////////////////
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        tID = get_type_name();
        tID = tID.toupper();

//:| for item in READ_DMA_LIST: print("    read_response_size_idx_%0s = 0;" % item)
//:| for item in WRITE_DMA_LIST: print("    write_response_size_idx_%0s = 0;" % item)
//:| for key in uvm_analysis_port_request_list.keys():  print("    request_%(key)0s = new(\"request_%(key)0s\", this);" % {'key':key})
//:| for key in uvm_analysis_port_response_list.keys(): print("    response_%(key)0s = new(\"response_%(key)0s\", this);" % {'key':key})
//:| for key in uvm_analysis_port_request_list.keys():  print("    request_%(key)0s_credit_fifo = new(\"request_%(key)0s_credit_fifo\", this);" % {'key':key})
//:| for key in uvm_analysis_port_response_list.keys(): print("    response_%(key)0s_credit_fifo = new(\"response_%(key)0s_credit_fifo\", this);" % {'key':key})
    endfunction // new
    
      
    /////////////////////////////////////////////////////////////
    /// build phase()
    /////////////////////////////////////////////////////////////
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        /////////////////////////////////////////////////////////
        // Socket Construction
        ///////////////////////////////////////////////////////// 
        rm_nvdla_dma_convertor_target = new ("rm_nvdla_dma_convertor_target", this); 
        rm_nvdla_dma_convertor_credit_initiator = new ("rm_nvdla_dma_convertor_credit_initiator", this);

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
//:| for key in uvm_analysis_port_request_list.keys():
//:|     message = '''
//:|             forever begin : request_%(key)0s_credit_transponder_task
//:|                 request_%(key)0s_credit_transponder();
//:|             end : request_%(key)0s_credit_transponder_task'''
//:|     print (message % {'key':key})
//:| for key in uvm_analysis_port_response_list.keys():
//:|     message = '''
//:|             forever begin : response_%(key)0s_credit_transponder_task
//:|                 response_%(key)0s_credit_transponder();
//:|             end : response_%(key)0s_credit_transponder_task'''
//:|     print(message % {'key':key})
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
    // 3) If transaction is a request, send it to corresponding analysis port, and push to request FIFO
    // 4) If transaction is a response, get it's request from request FIFO, compose the final transaction, and then send it to corresponding analysis port
    // txn_info structure
    //      uint8_t             dma_id;
    //      uint8_t             status; // Request, Response
    //      nvdla_dma_wr_req_t  req;
    // -------------------------------------------------------
    //      uint8_t             dma_id;
    //      uint8_t             status; // Request, Response
    //      // union   nvdla_monitor_dma_rd_u  payload;
    //      nvdla_dma_rd_req_t  req;
    //      nvdla_dma_rd_rsp_t  rsp;

    task b_transport(ref uvm_tlm_generic_payload tlm_tr, uvm_tlm_time delay);
        byte unsigned               tlm_gp_data_ptr [];// From tlm_tr
        byte unsigned               parsed_data_ptr [];// From tlm_tr
        dma_txn                 dma_txn_nvdla;
        nvdla_monitor_dma_rd_transaction_t  dma_txn_rd_st;
        nvdla_monitor_dma_wr_transaction_t  dma_txn_wr_st;

        // `uvm_info(tID, $sformatf("Got a DMA TLM_GP transaction\n%0s", tlm_tr.sprint()), UVM_FULL)
        // 1) Parse TLM GP, store field in local response variables
        tlm_tr.get_data(tlm_gp_data_ptr);
        if (UVM_TLM_READ_COMMAND == tlm_tr.get_command()) begin
            `uvm_info(tID, $sformatf("Got a DMA TLM_GP read transaction\n%0s", tlm_tr.sprint()), UVM_FULL)
            parsed_data_ptr = new [$bits(dma_txn_rd_st)/8];
            parse_read_dma_transaction(tlm_gp_data_ptr, parsed_data_ptr);
            dma_txn_rd_st = { >> {parsed_data_ptr}};
            if (`NVDLA_MONITOR_DMA_STATUS_REQUEST == dma_txn_rd_st.status) begin
                `uvm_info(tID, $sformatf("Got a DMA TLM_GP read request transaction\n%0s", tlm_tr.sprint()), UVM_FULL)
                // Read request:
                //  1. Convert struct transaction into nvdla transaction
                //  2. Send to corresponding analysis port and push to corresponding request FIFO
                dma_txn_nvdla = new("dma_txn_nvdla_rd");
                dma_txn_nvdla.kind          = dma_txn::READ;
                dma_txn_nvdla.set_addr( dma_txn_rd_st.req.pd.dma_read_cmd.addr );
                dma_txn_nvdla.length        = dma_txn_rd_st.req.pd.dma_read_cmd.size;
                // dma_txn_nvdla.stream_id_ptr = dma_txn_rd_st.req.pd.dma_read_cmd.stream_id_ptr;
                dma_txn_nvdla.data          = new [dma_txn_nvdla.length+1];
                case (dma_txn_rd_st.dma_id)
//:| for item in READ_DMA_LIST:
//:|     DMA = item.upper()
//:|     dma = item.lower()
//:|     message = ''' 
//:|                     `%(DMA)0s_READ_ID: begin
//:|                         read_request_fifo_array_%(dma)0s.push_front(dma_txn_nvdla);
//:|                         `uvm_info(tID, $sformatf("Send DMA ( from %(dma)0s ) read request transaction.\\n%%0s", dma_txn_nvdla.sprint()), UVM_FULL)
//:|                         request_%(dma)0s.write(dma_txn_nvdla);
//:|                     end'''
//:|     print(message % {'DMA':DMA, 'dma':dma})
                endcase
            end else begin
                `uvm_info(tID, $sformatf("Got a DMA TLM_GP read response transaction\n%0s", tlm_tr.sprint()), UVM_FULL)
                `uvm_info(tID, $sformatf("Convert TLM_GP to SV struct\n%p", dma_txn_rd_st), UVM_FULL)
                `uvm_info(tID, $sformatf("    dma_txn_rd_st.rsp.pd.dma_read_data.mask is %0x", dma_txn_rd_st.rsp.pd.dma_read_data.mask), UVM_FULL)

                // Read response:
                //  1. Get one transaction from corresponding request FIFO
                //  2. Adding data related field from structure transaction
                //  3. If all response data bytes are got, send to corresponding analysis port, else, push_back to request FIFO
                case (dma_txn_rd_st.dma_id)
//:| for item in READ_DMA_LIST:
//:|     DMA = item.upper()
//:|     dma = item.lower()
//:|     message = '''
//:|                     `%(DMA)0s_READ_ID: begin
//:|                         dma_txn_nvdla = read_request_fifo_array_%(dma)0s.pop_back();
//:|                         if(dma_txn_nvdla == null) begin
//:|                             `uvm_fatal(tID, \"%(DMA)0s_READ, got response with no request\")
//:|                         end
//:|                         if (2'b1 == (dma_txn_rd_st.rsp.pd.dma_read_data.mask & 2'b1)) begin
//:|                             dma_txn_nvdla.data[read_response_size_idx_%(dma)0s] = dma_txn_rd_st.rsp.pd.dma_read_data.data[`DMA_DATA_WIDTH-1:0];
//:|                             `uvm_info(tID, $sformatf(\"   dma_txn_rd_st.rsp.pd.dma_read_data.data[`DMA_DATA_WIDTH-1:0]%%0x\", dma_txn_rd_st.rsp.pd.dma_read_data.data[`DMA_DATA_WIDTH-1:0]), UVM_FULL)
//:|                             read_response_size_idx_%(dma)0s ++;
//:|                         end
//:|                         if (2'b10 == (dma_txn_rd_st.rsp.pd.dma_read_data.mask & 2'b10)) begin
//:|                             dma_txn_nvdla.data[read_response_size_idx_%(dma)0s] = dma_txn_rd_st.rsp.pd.dma_read_data.data[`DMA_DATA_WIDTH*2-1:`DMA_DATA_WIDTH];
//:|                             `uvm_info(tID, $sformatf(\"   dma_txn_rd_st.rsp.pd.dma_read_data.data[`DMA_DATA_WIDTH*2-1:`DMA_DATA_WIDTH]%%0x\", dma_txn_rd_st.rsp.pd.dma_read_data.data[`DMA_DATA_WIDTH*2-1:`DMA_DATA_WIDTH]), UVM_FULL)
//:|                             read_response_size_idx_%(dma)0s ++;
//:|                         end
//:|                         if (read_response_size_idx_%(dma)0s - 1 == dma_txn_nvdla.length) begin
//:|                             `uvm_info(tID, $sformatf(\"Send DMA ( from %(dma)0s ) read response transaction.\\n%%0s\", dma_txn_nvdla.sprint()), UVM_FULL)
//:|                             // read_response_%(dma)0s.write (dma_txn_nvdla);
//:|                             response_%(dma)0s.write (dma_txn_nvdla);
//:|                             read_response_size_idx_%(dma)0s = 0;
//:|                         end else begin
//:|                             `uvm_info(tID, $sformatf(\"Push back incomplete DMA ( from %(dma)0s ) read response transaction.\\n%%0s\", dma_txn_nvdla.sprint()), UVM_FULL)
//:|                             read_request_fifo_array_%(dma)0s.push_back(dma_txn_nvdla);
//:|                         end
//:|                     end'''
//:|     print(message % {'DMA':DMA, 'dma':dma})
                endcase
            end
        end else if (UVM_TLM_WRITE_COMMAND == tlm_tr.get_command()) begin
            `uvm_info(tID, $sformatf("Got a DMA TLM_GP write transaction\n%0s", tlm_tr.sprint()), UVM_FULL)
            parsed_data_ptr = new [$bits(dma_txn_wr_st)/8];
            parse_write_dma_transaction(tlm_gp_data_ptr, parsed_data_ptr);
            dma_txn_wr_st = { >> {parsed_data_ptr}};
            `uvm_info(tID, $sformatf("DMA write txn, dma_id: 0x%X", dma_txn_wr_st.dma_id), UVM_FULL)
            `uvm_info(tID, $sformatf("DMA write txn, status: 0x%X", dma_txn_wr_st.status), UVM_FULL)
            if (`NVDLA_MONITOR_DMA_STATUS_REQUEST == dma_txn_wr_st.status) begin
                `uvm_info(tID, $sformatf("Got a DMA TLM_GP write request transaction\n%0s", tlm_tr.sprint()), UVM_FULL)
                // Write request:
                //  1. Convert struct transaction into nvdla transaction, if it is a write command, push_front to corresponding request FIFO, if it is a write data, pop_front from queue, attach data to it, and then push_front to corresponding request FIFO, if it is a write data
                //  2. If the write transaction is complete send to corresponding analysis port 
                if (`TAG_CMD ==  dma_txn_wr_st.req.tag) begin
                    // Write command
                    dma_txn_nvdla = new("dma_txn_nvdla_wr");
                    dma_txn_nvdla.kind          = dma_txn::WRITE;
                    dma_txn_nvdla.set_addr( dma_txn_wr_st.req.pd.dma_write_cmd.addr );
                    dma_txn_nvdla.length        = dma_txn_wr_st.req.pd.dma_write_cmd.size;
                    // dma_txn_nvdla.stream_id_ptr = dma_txn_wr_st.req.pd.dma_write_cmd.stream_id_ptr;
                    dma_txn_nvdla.require_ack   = dma_txn_wr_st.req.pd.dma_write_cmd.require_ack;
                    dma_txn_nvdla.data          = new [dma_txn_nvdla.length+1];
                    `uvm_info(tID, "    DMA TLM_GP write request transaction is a command", UVM_FULL)
                    `uvm_info(tID, $sformatf("        length is      %X", dma_txn_nvdla.length), UVM_FULL)
                    `uvm_info(tID, $sformatf("        require_ack is %X", dma_txn_nvdla.require_ack), UVM_FULL)
                    case (dma_txn_wr_st.dma_id)
//:| for item in WRITE_DMA_LIST:
//:|     DMA = item.upper()
//:|     dma = item.lower()
//:|     message = '''
//:|                     `%(DMA)0s_WRITE_ID: begin
//:|                         write_response_size_idx_%(dma)0s = 0;
//:|                         `uvm_info(tID, $sformatf(\"Push DMA ( from %(dma)0s ) write request command transaction.\\n%%0s\", dma_txn_nvdla.sprint()), UVM_FULL)
//:|                         write_request_fifo_array_%(dma)0s.push_front(dma_txn_nvdla);
//:|                     end'''
//:|     print(message % {'DMA':DMA, 'dma':dma})
                    endcase
                end else begin
                    `uvm_info(tID, "    DMA TLM_GP write request transaction is a data", UVM_FULL)
                    // Write data
                    case (dma_txn_wr_st.dma_id)
//:| for item in WRITE_DMA_LIST:
//:|     DMA = item.upper()
//:|     dma = item.lower()
//:|     message = '''
//:|                         `%(DMA)0s_WRITE_ID: begin
//:|                             dma_txn_nvdla = write_request_fifo_array_%(dma)0s.pop_front();
//:|                             dma_txn_nvdla.data[write_response_size_idx_%(dma)0s] = dma_txn_wr_st.req.pd.dma_write_data.data[`DMA_DATA_WIDTH-1:0];
//:|                             write_response_size_idx_%(dma)0s ++;
//:|                             if (write_response_size_idx_%(dma)0s - 1 == dma_txn_nvdla.length) begin
//:|                                 `uvm_info(tID, $sformatf(\"Send DMA ( from %(dma)0s ) write request transaction.\\n%%0s\", dma_txn_nvdla.sprint()), UVM_FULL)
//:|                                 request_%(dma)0s.write(dma_txn_nvdla);
//:|                                 if (1'b1 == dma_txn_nvdla.require_ack) begin
//:|                                     `uvm_info(tID, \"Transaction required ack, push to %(dma)0s write response FIFO.\\n\", UVM_FULL)
//:|                                     write_response_fifo_array_%(dma)0s.push_back(dma_txn_nvdla);
//:|                                 end else begin
//:|                                     if (write_response_fifo_array_%(dma)0s.size()>0) begin
//:|                                         write_response_fifo_array_%(dma)0s.push_back(dma_txn_nvdla);
//:|                                     end else begin
//:|                                         response_%(dma)0s.write(dma_txn_nvdla);
//:|                                     end
//:|                                 end
//:|                             end else begin
//:|                                 if(`DMA_DATA_MASK_WIDTH == 2) begin
//:|                                     `uvm_info(tID, \"Each beat has two data item\", UVM_FULL)
//:|                                     // Request is not completed, get data from another atom
//:|                                     dma_txn_nvdla.data[write_response_size_idx_%(dma)0s] = dma_txn_wr_st.req.pd.dma_write_data.data[`DMA_DATA_WIDTH*2-1:`DMA_DATA_WIDTH];
//:|                                     write_response_size_idx_%(dma)0s ++;
//:|                                     if (write_response_size_idx_%(dma)0s - 1 == dma_txn_nvdla.length) begin
//:|                                         `uvm_info(tID, $sformatf(\"Send DMA ( from %(dma)0s ) write request transaction.\\n%%0s\", dma_txn_nvdla.sprint()), UVM_FULL)
//:|                                         request_%(dma)0s.write(dma_txn_nvdla);
//:|                                         if (1'b1 == dma_txn_nvdla.require_ack) begin
//:|                                             `uvm_info(tID, \"Transaction required ack, push to %(dma)0s write response FIFO.\\n\", UVM_FULL)
//:|                                             write_response_fifo_array_%(dma)0s.push_back(dma_txn_nvdla);
//:|                                         end else begin
//:|                                             if (write_response_fifo_array_%(dma)0s.size()>0) begin
//:|                                                 write_response_fifo_array_%(dma)0s.push_back(dma_txn_nvdla);
//:|                                             end else begin
//:|                                                 response_%(dma)0s.write(dma_txn_nvdla);
//:|                                             end
//:|                                         end
//:|                                     end else begin
//:|                                         // Request is not completed, push_front to queue
//:|                                         `uvm_info(tID, $sformatf(\"Push back incomplete DMA ( from %(dma)0s ) write request transaction.\\n%%0s\", dma_txn_nvdla.sprint()), UVM_FULL)
//:|                                         write_request_fifo_array_%(dma)0s.push_front(dma_txn_nvdla);
//:|                                     end
//:|                                 end else begin
//:|                                     `uvm_info(tID, \"Each beat has one data item\", UVM_FULL)
//:|                                     // Request is not completed, push_front to queue
//:|                                     `uvm_info(tID, $sformatf(\"Push back incomplete DMA ( from %(dma)0s ) write request transaction.\\n%%0s\", dma_txn_nvdla.sprint()), UVM_FULL)
//:|                                     write_request_fifo_array_%(dma)0s.push_front(dma_txn_nvdla);
//:|                                 end
//:|                             end
//:|                         end'''
//:|     print(message % {'DMA':DMA, 'dma':dma})
                    endcase
                end
            end else begin
                `uvm_info(tID, $sformatf("Got a DMA TLM_GP write response transaction\n%0s", tlm_tr.sprint()), UVM_FULL)
                // Write response:
                //  1. Pop_back transaction from corresponding request FIFO
                //  2. Send to corresponding analysis port
                case (dma_txn_wr_st.dma_id)
//:| for item in WRITE_DMA_LIST:
//:|     DMA = item.upper()
//:|     dma = item.lower()
//:|     message = '''
//:|                     `%(DMA)0s_WRITE_ID: begin
//:|                         while (write_response_fifo_array_%(dma)0s.size() > 0) begin
//:|                             dma_txn_nvdla = write_response_fifo_array_%(dma)0s.pop_front();
//:|                             if (dma_txn_nvdla == null) begin
//:|                                 `uvm_info(tID, \"Got a txn from write_response_fifo_array_%(dma)0s, pointer is null\", UVM_FULL);
//:|                             end
//:|                             response_%(dma)0s.write(dma_txn_nvdla);
//:|                         end
//:|                     end'''
//:|     print(message % {'DMA':DMA, 'dma':dma})
                endcase
            end
        end
    endtask

    // Credit transponder
    // 1. Collect credit from score boards' analysis fifos
    // 2. Forward credit to SC via rm_nvdla_dma_convertor_credit_initiator
//:| for key in uvm_analysis_port_request_list.keys():
//:|     DMA         = key.upper()
//:|     dma         = key.lower()
//:|     has_write = 1 if dma in WRITE_DMA_LIST else 0
//:|     has_read  = 1 if dma in READ_DMA_LIST else 0
//:|     message = '''
//:|     task request_%(key)0s_credit_transponder();
//:|         byte unsigned                   tlm_gp_data_ptr [];// From tlm_gp
//:|         byte unsigned                   tlm_gp_byte_enable_ptr [];// From tlm_gp
//:|         credit_txn                      dma_credit_txn;
//:|         credit_structure                dma_credit_st;
//:|         uvm_tlm_generic_payload         tlm_gp;
//:|         uvm_tlm_time                    tlm_time;
//:|         tlm_time                = new( "<unused>" );
//:|         tlm_gp                  = uvm_tlm_generic_payload::type_id::create( "request_%(key)0s_credit" );
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
//:|         dma_credit_st.txn_id    = `%(DMA)0s_READ_ID;  // ID is the same as read ID
//:|         dma_credit_st.is_req    = 1;                // Request
//:|         // Grant initial credits, begin
//:|         // Read
//:|         if ( %(has_read)0d ) begin
//:|             dma_credit_st.not_write   = 1;
//:|             dma_credit_st.credit    = %(key)0s_read_request_initial_credit;
//:|             tlm_gp_data_ptr = {<< byte{dma_credit_st.txn_id, dma_credit_st.not_write, dma_credit_st.is_req, dma_credit_st.credit, dma_credit_st.sub_id}};
//:|             tlm_gp.set_data(tlm_gp_data_ptr);
//:|             rm_nvdla_dma_convertor_credit_initiator.b_transport(tlm_gp, tlm_time);
//:|         end
//:|         // Write
//:|         if ( %(has_write)0d ) begin
//:|             dma_credit_st.not_write   = 0;
//:|             dma_credit_st.credit    = %(key)0s_write_request_initial_credit;
//:|             tlm_gp_data_ptr = {<< byte{dma_credit_st.txn_id, dma_credit_st.not_write, dma_credit_st.is_req, dma_credit_st.credit, dma_credit_st.sub_id}};
//:|             tlm_gp.set_data(tlm_gp_data_ptr);
//:|             rm_nvdla_dma_convertor_credit_initiator.b_transport(tlm_gp, tlm_time);
//:|         end
//:|         // Grant initial credits, end
//:|         while (1'b1) begin
//:|             request_%(key)0s_credit_fifo.get(dma_credit_txn);
//:|             `uvm_info(tID, $sformatf(\"request_%(key)0s_fifo: dma_credit_txn is \\n%%0s\", dma_credit_txn.sprint()), UVM_FULL)
//:|             // Drop response credit
//:|             if (1'b1 != dma_credit_txn.is_req) begin
//:|                 continue;
//:|             end
//:|             dma_credit_st.not_write     = dma_credit_txn.not_write;
//:|             dma_credit_st.credit = dma_credit_txn.credit;
//:|             dma_credit_st.sub_id = dma_credit_txn.sub_id;
//:|             `uvm_info(tID, $sformatf(\"request_%(key)0s_credit is \\n%%p\", dma_credit_st), UVM_FULL)
//:|             tlm_gp_data_ptr = {<< byte{dma_credit_st.txn_id, dma_credit_st.not_write, dma_credit_st.is_req, dma_credit_st.credit, dma_credit_st.sub_id}};
//:|             foreach (tlm_gp_data_ptr[i]) begin
//:|                 `uvm_info(tID, $sformatf(\"tlm_gp_data_ptr[0x%%x]:0x%%x\\n", i, tlm_gp_data_ptr[i]), UVM_FULL)
//:|             end
//:|             foreach (tlm_gp_byte_enable_ptr[i]) begin
//:|                 `uvm_info(tID, $sformatf(\"tlm_gp_byte_enable_ptr[0x%%x]:0x%%x\\n", i, tlm_gp_byte_enable_ptr[i]), UVM_FULL)
//:|             end
//:|             tlm_gp.set_data(tlm_gp_data_ptr);
//:|             // tlm_gp.set_byte_enable(tlm_gp_byte_enable_ptr);
//:|             rm_nvdla_dma_convertor_credit_initiator.b_transport(tlm_gp, tlm_time);
//:|         end
//:|     endtask '''
//:|     print(message % {'key':key, 'has_write':has_write, 'has_read':has_read, 'DMA':DMA})
//:| for key in uvm_analysis_port_response_list.keys():
//:|     DMA         = key.upper()
//:|     dma         = key.lower()
//:|     has_write   = 1 if dma in WRITE_DMA_LIST else 0
//:|     has_read    = 1 if dma in READ_DMA_LIST else 0
//:|     message = '''
//:|     task response_%(key)0s_credit_transponder();
//:|         byte unsigned                   tlm_gp_data_ptr [];// From tlm_gp
//:|         byte unsigned                   tlm_gp_byte_enable_ptr [];// From tlm_gp
//:|         credit_txn                      dma_credit_txn;
//:|         credit_structure                dma_credit_st;
//:|         uvm_tlm_generic_payload         tlm_gp;
//:|         uvm_tlm_time                    tlm_time;
//:|         tlm_time                = new( "<unused>" );
//:|         tlm_gp                  = uvm_tlm_generic_payload::type_id::create( "request_%(key)0s_credit" );
//:|         tlm_gp_data_ptr         = new [$bits(credit_structure)/8];
//:|         tlm_gp_byte_enable_ptr  = new [$bits(credit_structure)/8];
//:|         tlm_gp.set_write();
//:|         tlm_gp.set_data_length(tlm_gp_data_ptr.size());
//:|         // Initialize tlm_gp_byte_enable_ptr
//:|         foreach (tlm_gp_byte_enable_ptr[i]) begin
//:|             tlm_gp_byte_enable_ptr[i] = 8'hFF;
//:|         end
//:|         tlm_gp.set_byte_enable_length($bits(credit_structure)/8);
//:|         tlm_gp.set_byte_enable(tlm_gp_byte_enable_ptr);
//:|         dma_credit_st.txn_id    = `%(DMA)0s_READ_ID;  // ID is the same as read ID
//:|         dma_credit_st.is_req    = 0;                // Response
//:|         // Grant initial credits, begin
//:|         // Read
//:|         if (%(has_read)0d) begin
//:|             dma_credit_st.not_write   = 1;
//:|             dma_credit_st.credit    = %(key)0s_read_response_initial_credit;
//:|             tlm_gp_data_ptr = {<< byte{dma_credit_st.txn_id, dma_credit_st.not_write, dma_credit_st.is_req, dma_credit_st.credit, dma_credit_st.sub_id}};
//:|             tlm_gp.set_data(tlm_gp_data_ptr);
//:|             rm_nvdla_dma_convertor_credit_initiator.b_transport(tlm_gp, tlm_time);
//:|         end
//:|         // Write
//:|         if (%(has_write)0d) begin
//:|             dma_credit_st.not_write   = 0;
//:|             dma_credit_st.credit    = %(key)0s_write_response_initial_credit;
//:|             tlm_gp_data_ptr = {<< byte{dma_credit_st.txn_id, dma_credit_st.not_write, dma_credit_st.is_req, dma_credit_st.credit, dma_credit_st.sub_id}};
//:|             tlm_gp.set_data(tlm_gp_data_ptr);
//:|             rm_nvdla_dma_convertor_credit_initiator.b_transport(tlm_gp, tlm_time);
//:|         end
//:|         // Grant initial credits, end
//:|         while (1'b1) begin
//:|             response_%(key)0s_credit_fifo.get(dma_credit_txn);
//:|             `uvm_info(tID, $sformatf(\"response_%(key)0s_fifo: dma_credit_txn is \\n%%0s\", dma_credit_txn.sprint()), UVM_FULL)
//:|             // Drop request credit
//:|             if (1'b1 == dma_credit_txn.is_req) begin
//:|                 continue;
//:|             end
//:|             dma_credit_st.not_write     = dma_credit_txn.not_write;
//:|             dma_credit_st.credit = dma_credit_txn.credit;
//:|             dma_credit_st.sub_id = dma_credit_txn.sub_id;
//:|             `uvm_info(tID, $sformatf(\"response_%(key)0s_credit is \\n%%p\", dma_credit_st), UVM_FULL)
//:|             tlm_gp_data_ptr = {<< byte{dma_credit_st.txn_id, dma_credit_st.not_write, dma_credit_st.is_req, dma_credit_st.credit, dma_credit_st.sub_id}};
//:|             foreach (tlm_gp_data_ptr[i]) begin
//:|                 `uvm_info(tID, $sformatf(\"tlm_gp_data_ptr[0x%%x]:0x%%x\\n", i, tlm_gp_data_ptr[i]), UVM_FULL)
//:|             end
//:|             foreach (tlm_gp_byte_enable_ptr[i]) begin
//:|                 `uvm_info(tID, $sformatf(\"tlm_gp_byte_enable_ptr[0x%%x]:0x%%x\\n", i, tlm_gp_byte_enable_ptr[i]), UVM_FULL)
//:|             end
//:|             tlm_gp.set_data(tlm_gp_data_ptr);
//:|             rm_nvdla_dma_convertor_credit_initiator.b_transport(tlm_gp, tlm_time);
//:|         end
//:|     endtask'''
//:|     print(message % {'key':key, 'DMA':DMA, 'has_write':has_write, 'has_read':has_read})

endclass: rm_nvdla_dma_convertor

`endif // rm_nvdla_dma_convertor

