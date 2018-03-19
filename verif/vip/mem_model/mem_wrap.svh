`ifndef _MEM_WRAP_SVH_
`define _MEM_WRAP_SVH_

// TO REMOVE BEGIN
typedef class memory_model_command;
typedef class result_checker_command;

// TO REMOVE END

class mem_wrap extends uvm_component;

    typedef uvm_tlm_generic_payload gp_t;

    string tID;

    // trace parser input command fifo
    uvm_tlm_analysis_fifo#(memory_model_command) mmc_fifo;
    
    // result checker command fifo
    uvm_tlm_analysis_fifo#(result_checker_command) rcc_fifo;
    
    // Memory read/write socket
    uvm_tlm_b_target_socket#(mem_wrap, gp_t) skt;

    // To scoreboard
    uvm_analysis_port#(gp_t) req_ap;
    uvm_analysis_port#(gp_t) rsp_ap;

    mem_core mem;
    
    bit auto_dump_surface = 0;

    `uvm_component_utils_begin(mem_wrap)
        `uvm_field_int(auto_dump_surface, UVM_DEFAULT)
    `uvm_component_utils_end

    extern function new(string name = "mem_wrap", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void start_of_simulation_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);    
    extern function void extract_phase(uvm_phase phase);
    extern task b_transport(gp_t gp, uvm_tlm_time delay);

    extern function void m_process_memory_model_command();
    extern protected task m_process_result_checker_command();    
endclass

// ----------------------------------------------------------------------------
// Implementations
// ----------------------------------------------------------------------------
    
function mem_wrap::new(string name = "mem_wrap", uvm_component parent = null);
    super.new(name, parent);
    tID = name;
endfunction

function void mem_wrap::build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_db#(bit)::get(this, "", "auto_dump_surface", auto_dump_surface);

    mmc_fifo = new("mmc_fifo", this);
    rcc_fifo = new("rcc_fifo", this);    
    skt = new("skt", this);
    req_ap = new("req_ap", this);
    rsp_ap = new("rsp_ap", this);
    mem = mem_core::type_id::create("mem", this);
endfunction

function void mem_wrap::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(tID, $sformatf("start_of_simulation_phase begin ..."), UVM_HIGH)
    m_process_memory_model_command();
    `uvm_info(tID, "Memory initialization done", UVM_NONE)
endfunction : start_of_simulation_phase

task mem_wrap::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(tID, $sformatf("run_phase begin ..."), UVM_HIGH)
    m_process_result_checker_command();        
    `uvm_info(tID, $sformatf("run_phase complete ..."), UVM_HIGH)
endtask

function void mem_wrap::extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(tID, $sformatf("extract_phase begin ..."), UVM_HIGH)

    if (auto_dump_surface) begin
        surface_store_info ssi;
        string filename;

        `uvm_info("EXTRACT_PHASE", "Start to dump surface data automatically ...", UVM_LOW)
        foreach (mem.ssi_queue[i]) begin
            ssi = mem.ssi_queue[i];
            filename = $sformatf("dump_surface_%s_%0d_base_%#x.dat", tID, ssi.surface_id, ssi.base);
            mem.dump_surface(filename, ssi.base, ssi.len);
        end
    end
    `uvm_info(tID, $sformatf("extract_phase complete ..."), UVM_HIGH)
endfunction

task mem_wrap::b_transport(gp_t gp, uvm_tlm_time delay);
    bit [63:0]    addr;
    int  unsigned num_bytes;
    byte unsigned byte_enable[];
    byte unsigned data[];
    gp_t req_gp;
    
    `uvm_info(tID, {"Memory model tlm_gp received: \n", gp.sprint()}, UVM_HIGH)
    addr = gp.get_address();
    num_bytes = gp.get_data_length();

    $cast(req_gp, gp.clone());
    req_gp.set_transaction_id(gp.get_transaction_id);
    req_ap.write(req_gp);
    if (gp.is_read()) begin
        gp.get_data(data);
        for (int i=0; i<num_bytes; i++) begin
            data[i] = mem.read8(addr+i);
        end
        gp.set_data(data);
    end else begin
        bit wstrb;
        gp.get_data(data);
        gp.get_byte_enable(byte_enable);
        for (int i=0; i<num_bytes; i++) begin
            wstrb = (byte_enable[i] == 8'hff);
            mem.write8(addr+i, data[i], wstrb);
        end
    end
    gp.set_response_status(UVM_TLM_OK_RESPONSE);
    `uvm_info(tID, {"Memory model tlm_gp processed: \n", gp.sprint()}, UVM_HIGH)
    rsp_ap.write(gp);
endtask

function void mem_wrap::m_process_memory_model_command();
    memory_model_command tr;
    
    while(mmc_fifo.try_get(tr)) begin
        // mmc_fifo.get(tr);
        `uvm_info("RCC/CMD", {"Memory model command received: \n", tr.sprint()}, UVM_HIGH)

        case (tr.kind)
            MEM_LOAD:
              mem.load_surface(tr.file_path, tr.base_address);

            MEM_INIT_PATTERN:
              mem.init_surface_with_pattern(tr.base_address, tr.size, tr.pattern);

            MEM_INIT_FILE:
              mem.init_surface_with_pattern_and_file(tr.base_address, tr.pattern, tr.file_path);

            default:
              `uvm_error("INVCMD",
                  $sformatf("Invalid memory model command: %s, valid commands are: MEM_LOAD, MEM_INIT_PATTERN, MEM_INIT_FILE", tr.kind.name()))
        endcase
    end
endfunction

task mem_wrap::m_process_result_checker_command();
    result_checker_command tr;

    forever begin
        rcc_fifo.get(tr);
        `uvm_info("RCC/CMD", {"Result checker command received: \n", tr.sprint()}, UVM_HIGH)

        case (tr.kind)
            CHECK_CRC: begin
                bit[31:0] actual_crc;
                
                actual_crc = mem.calc_surface_crc(tr.base_address, tr.size);
                if (actual_crc != tr.golden_crc)
                    `uvm_error("CRC_MISMATCH",
                        $sformatf("Golden CRC = %#0x, Actual CRC = %#0x, RCC is: \n%s", tr.golden_crc, actual_crc, tr.sprint()))
                else
                    `uvm_info("CRC_MATCH",
                        $sformatf("CRC (%#0x) Match with golden, RCC is \n%s", actual_crc, tr.sprint()), UVM_NONE)
            end

            CHECK_FILE: begin
                // TODO
            end

            default:
              `uvm_error("INVCMD",
                  $sformatf("Invalid result checker command: %s, valid commands are: CHECK_CRC, CHECK_FILE", tr.kind.name()))
        endcase
    end
endtask

`endif
