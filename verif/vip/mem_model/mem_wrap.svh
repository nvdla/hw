`ifndef _MEM_WRAP_SVH_
`define _MEM_WRAP_SVH_

typedef class memory_model_command;
typedef class result_checker_command;

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

    // Store requested memory regions
    mem_core mem_list[$];

    uvm_event_pool  global_event_pool;

    bit auto_dump_surface = 1;

    `uvm_component_utils_begin(mem_wrap)
        `uvm_field_int(auto_dump_surface, UVM_DEFAULT)
    `uvm_component_utils_end

    extern function new(string name = "mem_wrap", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task b_transport(gp_t gp, uvm_tlm_time delay);

    extern protected task m_process_memory_model_command(memory_model_command tr);
    extern protected task m_process_result_checker_command(result_checker_command tr);

    extern local function void evaluate_memory_model_command(memory_model_command tr);
    extern local function string sprint_mem_list();
    extern local function mem_core locate_mem(addr_t addr);
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
    global_event_pool = uvm_event_pool::get_global_pool();
    if (global_event_pool == null)
        `uvm_fatal(tID, "Failed to get global event pool")
endfunction

task mem_wrap::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(tID, $sformatf("run_phase begin ..."), UVM_HIGH)

    fork
        begin
            memory_model_command tr;
            forever begin
                mmc_fifo.get(tr);
                m_process_memory_model_command(tr);
            end
        end

        begin
            result_checker_command tr;
            forever begin
                rcc_fifo.get(tr);
                m_process_result_checker_command(tr);
            end
        end
    join

    `uvm_info(tID, $sformatf("run_phase complete ..."), UVM_HIGH)
endtask

task mem_wrap::b_transport(gp_t gp, uvm_tlm_time delay);
    bit [63:0]    addr;
    int  unsigned num_bytes;
    byte unsigned byte_enable[];
    byte unsigned data[];
    gp_t          req_gp;
    mem_core      mem;

    `uvm_info(tID, {"Memory model tlm_gp received: \n", gp.sprint()}, UVM_HIGH)
    addr = gp.get_address();
    num_bytes = gp.get_data_length();

    $cast(req_gp, gp.clone());
    req_gp.set_transaction_id(gp.get_transaction_id);
    req_ap.write(req_gp);

    mem = locate_mem(addr);
    if (mem == null) begin
        `uvm_fatal(tID,
            $sformatf("Can't find a valid mem region to %s (addr = %#0x), valid mem_regions are: %s",
            gp.is_read()?"read":"write", addr, this.sprint_mem_list()))
    end

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

task mem_wrap::m_process_memory_model_command(memory_model_command tr);
    uvm_event evt;

    `uvm_info("MMC_CMD", {"Memory model command received: \n", tr.sprint()}, UVM_LOW)

    fork begin
        if (tr.sync_id != "") begin
            if (!(global_event_pool.exists(tr.sync_id))) begin
                `uvm_error(tID, $sformatf("Can't find event (%s) in global event pool.", tr.sync_id))
            end
            evt = global_event_pool.get(tr.sync_id);
            `uvm_info(tID, {"# Wait event ", evt.get_name()}, UVM_LOW)
            evt.wait_on();
            `uvm_info(tID, {"# Event ", evt.get_name(), " is triggered"}, UVM_LOW)
        end

        evaluate_memory_model_command(tr);

        // kind is defined in nvdla_tb_txn.sv
        // Release function is added to reduce physical memory occupation during simulation.
        case (tr.kind)
            MEM_RESERVE: begin
                mem_core mem;
                mem = mem_core::type_id::create($sformatf("mem_%#0x", tr.base_address), this);
                mem.base = tr.base_address;
                mem.limit = tr.base_address + tr.size;
                mem_list.push_back(mem);
            end

            MEM_LOAD: begin
                mem_core mem;
                mem = locate_mem(tr.base_address);
                if (mem == null) begin
                    mem = mem_core::type_id::create($sformatf("mem_%#0x", tr.base_address), this);
                    mem_list.push_back(mem);
                end
                mem.load_surface(tr.file_path, tr.base_address);
            end

            MEM_INIT_PATTERN: begin
                mem_core mem;
                mem = locate_mem(tr.base_address);
                if (mem == null) begin
                    mem = mem_core::type_id::create($sformatf("mem_%#0x", tr.base_address), this);
                    mem_list.push_back(mem);
                end
                mem.init_surface_with_pattern(tr.base_address, tr.size, tr.pattern);
            end

            MEM_INIT_FILE: begin
                mem_core mem;
                mem = locate_mem(tr.base_address);
                if (mem == null) begin
                    mem = mem_core::type_id::create($sformatf("mem_%#0x", tr.base_address), this);
                    mem_list.push_back(mem);
                end
                mem.init_surface_with_pattern_and_file(tr.base_address, tr.pattern, tr.file_path);
            end

            MEM_RELEASE: begin
                foreach (mem_list[i]) begin
                    if (mem_list[i].has_addr(tr.base_address)) begin
                        if (auto_dump_surface) begin
                            string filename = $sformatf("%s_output_%#0x.dat", tID, tr.base_address);
                            mem_list[i].dump_surface(filename, tr.base_address, tr.size);
                        end
                        mem_list.delete(i);
                        break;
                    end
                end
            end
        endcase
    end join_none
endtask

task mem_wrap::m_process_result_checker_command(result_checker_command tr);
    `uvm_info("RCC_CMD", {"Result checker command received: \n", tr.sprint()}, UVM_HIGH)

    case (tr.kind)
        CHECK_CRC: begin
            bit[31:0] actual_crc;

            foreach (mem_list[i]) begin
                if (mem_list[i].has_addr(tr.base_address)) begin
                    actual_crc = mem_list[i].calc_surface_crc(tr.base_address, tr.size);
                    break;
                end
            end
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
endtask

function void mem_wrap::evaluate_memory_model_command(memory_model_command tr);
    mem_core mem;

    mem = locate_mem(tr.base_address);
    case (tr.kind)
        MEM_RESERVE: begin
            if (mem != null) begin
                `uvm_fatal(tID,
                    $sformatf("You are trying to reserve a memory region that has already been used ! (base = %#0x), mem_regions are: \n%scmd is\n%s",
                    tr.base_address, this.sprint_mem_list(), tr.sprint()))
            end
        end

        MEM_LOAD,
        MEM_INIT_PATTERN,
        MEM_INIT_FILE: begin
            if (mem != null) begin
                `uvm_warning(tID,
                    $sformatf("You are trying to %s a memory region that has already been initialized! (base = %#0x), mem_regions are: \n%scmd is\n%s",
                    tr.kind.name(), tr.base_address, this.sprint_mem_list(), tr.sprint()))
            end
        end

        MEM_RELEASE: begin
            if (mem == null) begin
                `uvm_fatal(tID,
                    $sformatf("You are trying to release a memory region that has not been initialized! (base = %#0x), mem_regions are: \n%scmd is\n%s",
                    tr.base_address, this.sprint_mem_list(), tr.sprint()))
            end
        end

        default: begin
            `uvm_fatal("INVCMD",
                $sformatf("Invalid memory model command (%s), valid commands are: %s",
                tr.kind.name(), "MEM_LOAD, MEM_INIT_PATTERN, MEM_INIT_FILE, MEM_RELEASE"))
        end
    endcase
endfunction

function string mem_wrap::sprint_mem_list();
    string s;
    foreach (mem_list[i]) begin
        s = {s, mem_list[i].sprint(), "\n"};
    end
    return s;
endfunction

function mem_core mem_wrap::locate_mem(addr_t addr);
    mem_core mem = null;
    foreach (mem_list[i]) begin
        if (mem_list[i].has_addr(addr)) begin
            mem = mem_list[i];
            break;
        end
    end
    return mem;
endfunction

`endif
