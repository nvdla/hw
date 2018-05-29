`ifndef _NVDLA_TB_TRACE_PARSER_SV_
`define _NVDLA_TB_TRACE_PARSER_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_tb_trace_parser
//
// @description
//-------------------------------------------------------------------------------------

class nvdla_tb_trace_parser extends uvm_component;

    string      tID = "nvdla_tb_trace_parser";
    string      trace_file_path;
    string      parser_core_path  = "nvdla_trace_parser.py";
    string      seq_cmd_file_path = "./trace_parser_cmd_sequence_command.log";
    string      ic_cmd_file_path  = "./trace_parser_cmd_interrupt_controller_command.log";
    string      rc_cmd_file_path  = "./trace_parser_cmd_result_checker_command.log";
    string      mm_cmd_file_path  = "./trace_parser_cmd_memory_model_command.log";
    uint32_t    echo_line_content =1;
    uvm_event_pool                              global_event_pool;
    uvm_analysis_port#(sequence_command)        sequence_command_port; 
    uvm_analysis_port#(result_checker_command)  result_checker_command_port; 
    uvm_analysis_port#(interrupt_command)       interrupt_handler_command_port; 
    uvm_analysis_port#(memory_model_command)    primary_memory_model_command_port; 
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    uvm_analysis_port#(memory_model_command)    secondary_memory_model_command_port; 
`endif

    //----------------------------------------------------------CONFIGURATION PARAMETERS
    // nvdla_tb_trace_parser Configuration Parameters. These parameters can be controlled through 
    // the UVM configuration database
    // @{

    // }@

    `uvm_component_utils_begin(nvdla_tb_trace_parser)
        `uvm_field_string   (trace_file_path, UVM_ALL_ON)
        `uvm_field_string   (parser_core_path, UVM_ALL_ON)
        `uvm_field_string   (seq_cmd_file_path, UVM_ALL_ON)
        `uvm_field_string   (ic_cmd_file_path, UVM_ALL_ON)
        `uvm_field_string   (rc_cmd_file_path, UVM_ALL_ON)
        `uvm_field_string   (mm_cmd_file_path, UVM_ALL_ON)
        `uvm_field_int      (echo_line_content, UVM_ALL_ON)
    `uvm_component_utils_end

    extern function new(string name = "nvdla_tb_trace_parser", uvm_component parent = null);

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

    extern function void parse_trace();
    extern function int  is_file_existed (string file_path);
    extern function void send_command_to_sequence(sequence_command cmd);            // Part of test
    extern function void send_command_to_result_checker(result_checker_command cmd);      // Part of test
    extern function void send_command_to_interrupt_handler(interrupt_command cmd);   // Part of env
    extern function void send_command_to_memory_model(memory_model_command cmd);        // Part of env

    // }@

endclass : nvdla_tb_trace_parser

// Function: new
// Creates a new nvdla_tb_trace_parser component
function nvdla_tb_trace_parser::new(string name = "nvdla_tb_trace_parser", uvm_component parent = null);
    super.new(name, parent);
    tID = get_type_name().toupper();
endfunction : new

// Function: build_phase
// Used to construct testbench components, build top-level testbench topology 
function void nvdla_tb_trace_parser::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)
    sequence_command_port               = new("sequence_command_port",               this);
    result_checker_command_port         = new("result_checker_command_port",         this);
    interrupt_handler_command_port      = new("interrupt_handler_command_port",      this);
    primary_memory_model_command_port   = new("primary_memory_model_command_port",   this);
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    secondary_memory_model_command_port = new("secondary_memory_model_command_port", this);
    `endif
endfunction : build_phase

// Function: connect_phase
// Used to connect components/tlm ports for environment topoloty
function void nvdla_tb_trace_parser::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)
    global_event_pool = uvm_event_pool::get_global_pool();
    if(global_event_pool == null) begin
        `uvm_fatal(tID, "Failed to get global event pool")
    end

endfunction : connect_phase

// Function: end_of_elaboration_phase
// Used to make any final adjustments to the env topology
function void nvdla_tb_trace_parser::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(tID, $sformatf("end_of_elaboration_phase begin ..."), UVM_HIGH)

    `uvm_info(tID, $sformatf("parse_trace running"), UVM_MEDIUM)
    parse_trace();

endfunction : end_of_elaboration_phase

// Function: start_of_simulation_phase
// Used to configure verification componets, printing 
function void nvdla_tb_trace_parser::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(tID, $sformatf("start_of_simulation_phase begin ..."), UVM_HIGH)

endfunction : start_of_simulation_phase

// TASK: run_phase
// Used to execute run-time tasks of simulation
task nvdla_tb_trace_parser::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(tID, $sformatf("run_phase begin ..."), UVM_HIGH)

endtask : run_phase

// TASK: reset_phase
// The reset phase is reserved for DUT or interface specific reset behavior
task nvdla_tb_trace_parser::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(tID, $sformatf("reset_phase begin ..."), UVM_HIGH)

endtask : reset_phase

// TASK: configure_phase
// Used to program the DUT or memoried in the testbench
task nvdla_tb_trace_parser::configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    `uvm_info(tID, $sformatf("configure_phase begin ..."), UVM_HIGH)

endtask : configure_phase

// TASK: main_phase
// Used to execure mainly run-time tasks of simulation
task nvdla_tb_trace_parser::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_HIGH)

endtask : main_phase

// TASK: shutdown_phase
// Data "drain" and other operations for graceful termination
task nvdla_tb_trace_parser::shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    `uvm_info(tID, $sformatf("shutdown_phase begin ..."), UVM_HIGH)

endtask : shutdown_phase

// Function: extract_phase
// Used to retrieve final state of DUTG and details of scoreboard, etc.
function void nvdla_tb_trace_parser::extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(tID, $sformatf("extract_phase begin ..."), UVM_HIGH)

endfunction : extract_phase

// Function: check_phase
// Used to process and check the simulation results
function void nvdla_tb_trace_parser::check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info(tID, $sformatf("check_phase begin ..."), UVM_HIGH)

endfunction : check_phase

// Function: report_phase
// Simulation results analysis and reports
function void nvdla_tb_trace_parser::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(tID, $sformatf("report_phase begin ..."), UVM_HIGH)

endfunction : report_phase

// Function: final_phase
// Used to complete/end any outstanding actions of testbench 
function void nvdla_tb_trace_parser::final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info(tID, $sformatf("final_phase begin ..."), UVM_HIGH)

endfunction : final_phase

function void nvdla_tb_trace_parser::parse_trace();
    int                 fh;
    int                 code;
    string              kind_name;
    string              memory_type;
    sequence_command        seq_cmd;
    interrupt_command       intr_cmd;
    result_checker_command  rc_cmd;
    memory_model_command    mm_cmd;
    // Check file existence
    `uvm_info(tID, $sformatf(" trace_file_path:%s", trace_file_path), UVM_MEDIUM)
    if (0 == is_file_existed(trace_file_path)) begin
        `uvm_fatal(tID, $sformatf("Cannot find trace file %s\n", trace_file_path) );
    end
    // Magic moment
    `uvm_info(tID, "Leverage external parser to process original trace file", UVM_NONE);
	if ($system($sformatf("%s --file_path %s", parser_core_path, trace_file_path))) begin
        `uvm_fatal(tID, $sformatf("Fail to parse trace config file %s\n", trace_file_path) );
	end

    //---------- sequence controller
    begin
        string      block_name;
        string      reg_name;
        string      field_name;
        uint32_t    data;
        string      sync_id;
        fh = $fopen(seq_cmd_file_path,"r");
        if(!fh) begin
            `uvm_fatal(tID, $sformatf("Cannot find sequence command file %s\n", seq_cmd_file_path) );
        end
        while (!$feof(fh)) begin
            // string kind_name,block_name,reg_name,field_name,data,sync_id;
            code = $fscanf(fh,"%s %s %s %s %h %s\n",kind_name,block_name,reg_name,field_name,data,sync_id);
            if (6 == code) begin
                `uvm_info(tID,$sformatf("kind_name=%s, block_name=%s, reg_name=%s, field_name=%s, data=%h, sync_id=%s",kind_name,block_name,reg_name,field_name,data,sync_id), UVM_HIGH);
                seq_cmd = new("seq_cmd");
                kind_wrapper::from_name(kind_name, seq_cmd.kind);
                seq_cmd.block_name  = block_name;
                seq_cmd.reg_name    = reg_name.substr(0, reg_name.len()-3); //FIXME: no "_0" suffix in ral register name
                seq_cmd.field_name  = field_name;
                seq_cmd.data        = data;
                seq_cmd.sync_id     = sync_id;
                if ("NOTIFY" == kind_name) begin
                    global_event_pool.get(sync_id);
                end
                send_command_to_sequence(seq_cmd);
            end
        end
        $fclose(fh);
    end

    //---------- interrupt controller
    begin
        string        interrupt_id;
        string        sync_id;
        fh = $fopen(ic_cmd_file_path,"r");
        if(!fh) begin
            `uvm_fatal(tID, $sformatf("Cannot find interrupt controller command file %s\n", ic_cmd_file_path) );
        end
        while (!$feof(fh)) begin
            // string kind_name,interrupt_id,sync_id;
            code = $fscanf(fh,"%s %s %s\n",kind_name,interrupt_id,sync_id);
            if(3==code) begin
                `uvm_info(tID,$sformatf("kind_name=%s,interrupt_id=%s, sync_id=%s",kind_name,interrupt_id,sync_id), UVM_NONE);
                intr_cmd = new("interrupt_controller_cmd");
                kind_wrapper::from_name(kind_name, intr_cmd.kind);
                intr_cmd.interrupt_id= interrupt_id;
                intr_cmd.sync_id     = sync_id;
                global_event_pool.get(sync_id);
                send_command_to_interrupt_handler(intr_cmd);
            end
        end
        $fclose(fh);
    end

    //----------- result checker
    begin
        string      sync_id;
        string      memory_type;
        uint64_t    base_address;
        uint64_t    size;
        uint64_t    golden_crc;
        string      golden_file_path;
        `uvm_info(tID,$sformatf("Reading result command file %s", rc_cmd_file_path), UVM_NONE);
        fh = $fopen(rc_cmd_file_path,"r");
        if(!fh) begin
            `uvm_fatal(tID, $sformatf("Cannot open trace file %s\n", rc_cmd_file_path) );
        end
        while (!$feof(fh)) begin
            //kind_name,sync_id,memory_type,base_address,size,golden_crc,golden_file_path
            code = $fscanf(fh,"%s %s %s %h %h %h %s\n",kind_name,sync_id,memory_type,base_address,size,golden_crc,golden_file_path);
            if(7 == code) begin
                `uvm_info(tID,$sformatf("kind_name=%s, sync_id=%s, memory_type=%s, base_address=%h, size=%h, golden_crc=%h, golden_file_path=%s",kind_name,sync_id,memory_type,base_address,size,golden_crc,golden_file_path), UVM_NONE);
                rc_cmd = new("result_checker_cmd");
                kind_wrapper::from_name(kind_name, rc_cmd.kind);
                memory_type_wrapper::from_name(memory_type, rc_cmd.memory_type);
                rc_cmd.sync_id      = sync_id;
                rc_cmd.base_address = base_address;
                rc_cmd.size         = size;
                rc_cmd.golden_crc   = golden_crc;
                rc_cmd.golden_file_path = golden_file_path;
                send_command_to_result_checker(rc_cmd);
            end
        end
        $fclose(fh);
    end

    //-------- memory model
    begin
        uint64_t        base_address;
        uint64_t        size;
        string          pattern;
        string          file_path;
        string          sync_id;
        string          line;

        fh = $fopen(mm_cmd_file_path,"r");
        if(!fh) begin
            `uvm_fatal(tID, $sformatf("Cannot open trace file %s\n", mm_cmd_file_path) );
        end
        while (!$feof(fh)) begin
            void'($fgets(line, fh));
            // memory model command without wait event, sync_id is optional:
            //  - kind_name memory_type base_address size pattern file_path sync_id
            code = $sscanf(line, "%s %s %h %h %s %s %s",
                kind_name, memory_type, base_address, size, pattern, file_path, sync_id);
            if (6 == code || 7 == code) begin
                `uvm_info(tID,
                    $sformatf("kind_name=%s, memory_type=%s, base_address=%0h, size=%0h, pattern=%s, file_path=%s, sync_id = %s",
                    kind_name, memory_type, base_address, size, pattern, file_path, sync_id), UVM_NONE);
                mm_cmd = new("memory_model_cmd");
                kind_wrapper::from_name(kind_name, mm_cmd.kind);
                mm_cmd.sync_id = (6 == code) ? "" : sync_id;
                memory_type_wrapper::from_name(memory_type, mm_cmd.memory_type);
                mm_cmd.base_address = base_address;
                mm_cmd.size         = size;
                mm_cmd.pattern      = pattern;
                mm_cmd.file_path    = file_path;

                if (mm_cmd.sync_id != "") global_event_pool.get(sync_id);
                send_command_to_memory_model(mm_cmd);
            end
        end
        $fclose(fh);
    end

    // // Get trace file handler
    // fh = $fopen(name,"r");
    // // Check file existence
    // if(!fh) begin
    //     `uvm_fatal(tID, $sformatf("Cannot open trace file %s\n", trace_file_path) );
    // end
    // while (!$feof(fh)) begin
    //     line_code = $fgets(line_content,fh);
    //     if (line_code > 0) begin
    //         // Echo read in line
    //         if (1 == echo_line_content) begin
    //             `uvm_info(tID, $sformatf("Read line:%s", line_content), UVM_LOW)
    //         end
    //         // Parsing line content
    //         // Skip commented line
    //         if (0 == uvm_re_match(re_commented_line, line_content)) begin
    //             continue;
    //         end
    //         // code = $sscanf (line_content, "")

    //     end
    //     code = $fgetc(fh);
    //         // comment line
    //         if( code=="#") begin
    //             // Detect a comment line, continue;
    //             int handle;
    //             string discard;
    //             handle = $fgets(discard,fh);
    //             continue;
    //         end
    //         else begin

    //         code = $ungetc(code, fh);
    //             code = $fscanf(fh,"%s %s %s %s\n",blk_name,reg_name,addr,value);
    //             `uvm_info("parse_scve_cfg",$sformatf("blk_name=%s, reg_name=%s, addr=%s, value=%s",blk_name,reg_name,addr,value), UVM_MEDIUM);
    //             if(blk_name=="LOADFILE") begin
    //                 //int mem = atoi(value);
    //                 int mem = value.atoi();
    //                 bit[39:0] offset = addr.atohex();
    //                 string file_name = reg_name;
    //                 if(mem == 1) begin
    //                     load_file_to_mem(mc_mem,offset,file_name);
    //                 end else begin
    //                     load_file_to_mem(cv_mem,offset,file_name);
    //                 end
    //             end
    // end
    // $fclose(fh);
endfunction : parse_trace

function int nvdla_tb_trace_parser::is_file_existed(string file_path);
    int fh;
    int is_existed = 1;
    fh = $fopen(file_path,"r");
    if(!fh) begin
        is_existed = 0;
    end
    $fclose(fh);
    return is_existed;
endfunction : is_file_existed

function void nvdla_tb_trace_parser::send_command_to_sequence(sequence_command cmd);
    `uvm_info(tID, $sformatf("seq cmd:%0s", cmd.sprint()), UVM_MEDIUM)
    sequence_command_port.write(cmd);
endfunction : send_command_to_sequence

function void nvdla_tb_trace_parser::send_command_to_result_checker(result_checker_command cmd);
    `uvm_info(tID, $sformatf("result ck cmd:%0s", cmd.sprint()), UVM_MEDIUM)
    result_checker_command_port.write(cmd);
endfunction : send_command_to_result_checker

function void nvdla_tb_trace_parser::send_command_to_interrupt_handler(interrupt_command cmd);
    `uvm_info(tID, $sformatf("intr cmd:%0s", cmd.sprint()), UVM_MEDIUM)
    interrupt_handler_command_port.write(cmd);
endfunction : send_command_to_interrupt_handler

function void nvdla_tb_trace_parser::send_command_to_memory_model(memory_model_command cmd);
    `uvm_info(tID, $sformatf("mem cmd:%0s", cmd.sprint()), UVM_MEDIUM)
    if (PRI_MEM == cmd.memory_type) begin
        primary_memory_model_command_port.write(cmd);
    end else begin
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
        secondary_memory_model_command_port.write(cmd);
`endif
    end
endfunction : send_command_to_memory_model

`endif // _NVDLA_TB_TRACE_PARSER_SV_

