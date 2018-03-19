`ifndef __NVDLA_TB_TXN_SV__
`define __NVDLA_TB_TXN_SV__

typedef byte unsigned       uint8_t;
typedef byte                int8_t;
typedef shortint unsigned   uint16_t;
typedef shortint            int16_t;
typedef int unsigned        uint32_t;
typedef int                 int32_t;
typedef longint unsigned    uint64_t;
typedef longint             int64_t;
// define trace parser instruction command enum type
typedef enum { WRITE
               , NOTIFY
               , WAIT
               , READ
               , READ_CHECK
               , POLL_REG_EQUAL
               , POLL_FIELD
               , SINGLE_SHOT
               , MULTI_SHOT
               , CHECK_CRC
               , CHECK_FILE
               , CHECK_NOTHING
               , MEM_LOAD
               , MEM_INIT_PATTERN
               , MEM_INIT_FILE
             } kind_e;

typedef enum { PRIMARY_MEM      = 0,
               SECONDARY_MEM    = 1
             } memory_type_e;

typedef uvm_enum_wrapper#(kind_e)           kind_wrapper;
typedef uvm_enum_wrapper#(memory_type_e)    memory_type_wrapper;

// Class: sequence command
//  usage: trace parser to sequence
//---------------------------------------------------------------------------------------------
// kind         | block_name    | reg_name    | field_name    | data             | sync_id
// WRITE        |   block_name  |   reg_name  |   N.A         |   data           |   N.A
// NOTIFY       |   block_name  |   N.A       |   N.A         |   N.A            |   sync_id
// WAIT         |   block_name  |   N.A       |   N.A         |   N.A            |   sync_id
// READ         |   block_name  |   reg_name  |   N.A         |   N.A            |   N.A
// READ_CHECK   |   block_name  |   reg_name  |   N.A         |   expected data  |   N.A
// POLL_REG_*   |   block_name  |   reg_name  |   N.A         |   expected data  |   N.A
// POLL_FIELD_* |   block_name  |   reg_name  |   field_name  |   expected data  |   N.A
//---------------------------- ----------------------------------------------------------------
class sequence_command extends uvm_sequence_item;
    kind_e      kind;
    string      block_name;
    string      reg_name;
    string      field_name;
    uint32_t    data;
    string      sync_id;
    `uvm_object_utils_begin(sequence_command)
        `uvm_field_string(block_name,   UVM_ALL_ON)
        `uvm_field_string(reg_name,     UVM_ALL_ON)
        `uvm_field_string(field_name,   UVM_ALL_ON)
        `uvm_field_int(data,            UVM_ALL_ON)
        `uvm_field_enum(kind_e,  kind,  UVM_ALL_ON)
        `uvm_field_string(sync_id,      UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="seq_cmd");
        super.new(name);
    endfunction
endclass: sequence_command

// Class: interrupt command
//  usage: trace parser to interupt handler
//--------------------------------------------------
// kind         |  interrupt_id     | sync_id
// SINGLE_SHOT  |    N.A            |   sync_id
// MULTI_SHOT   |    interrupt_id   |   sync_id
//--------------------------------------------------
class interrupt_command extends uvm_sequence_item;
    kind_e        kind;
    string        interrupt_id;
    string        sync_id;
    `uvm_object_utils_begin(interrupt_command)
        `uvm_field_enum(kind_e,  kind,  UVM_ALL_ON)
        `uvm_field_string(interrupt_id, UVM_ALL_ON)
        `uvm_field_string(sync_id,      UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name="intr_cmd");
        super.new(name);
    endfunction
endclass: interrupt_command

// Class: result checker command
//  usage: trace parser to result checker
//  usage: result checker to memory model
//--------------------------------------------------
// kind             | sync_id   | memory_type   | base_addr     | size  | crc   | file_path
// CHECK_NOTHING    |  sync_id  |  N.A          |  N.A          |  N.A  |  N.A  |  N.A
// CHECK_CRC        |  sync_id  |  memory_type  |  base_addr    |  size | crc   |  N.A
// CHECK_FILE       |  sync_id  |  memory_type  |  base_addr    |  size |  N.A   | file_path
//--------------------------------------------------
class result_checker_command extends uvm_sequence_item;
    kind_e          kind;
    string          sync_id;
    memory_type_e   memory_type;
    uint64_t        base_address;
    uint64_t        size;
    uint64_t        golden_crc;
    string          golden_file_path;
    `uvm_object_utils_begin(result_checker_command)
        `uvm_field_enum(kind_e,  kind,      UVM_ALL_ON)
        `uvm_field_string(sync_id,          UVM_ALL_ON)
        `uvm_field_enum(memory_type_e, memory_type, UVM_ALL_ON)
        `uvm_field_int(base_address,        UVM_ALL_ON)
        `uvm_field_int(size,                UVM_ALL_ON)
        `uvm_field_int(golden_crc,          UVM_ALL_ON)
        `uvm_field_string(golden_file_path, UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name="result_checker_cmd");
        super.new(name);
    endfunction
endclass: result_checker_command

// Class: memory model command
//  usage: trace parser to memory model
//--------------------------------------------------
// kind             | memory_type   | base_addr     | size  | pattern   | file_path
// MEM_LOAD         |  N.A          |  N.A          |  N.A  |  N.A      |  file_path
// MEM_INIT_PATTERN |  memory_type  |  base_addr    |  size |  pattern  |  N.A
// MEM_INIT_FILE    |  memory_type  |  base_addr    |  N.A  |  pattern  |  file_path
//--------------------------------------------------
//mem_load ( sec_mem, 0x8000, "python/over/perl.dat"); 
//mem_init ( sec_mem, 0x5000, 0x2000, ALL_ZERO); 
//mem_init ( pri_mem, 0x2000, "python/over/perl.dat", RANDOM); 
class memory_model_command extends uvm_sequence_item;
    kind_e          kind;
    memory_type_e   memory_type;
    uint64_t        base_address;
    uint64_t        size;
    string          pattern;
    string          file_path;
    `uvm_object_utils_begin(memory_model_command)
        `uvm_field_enum(kind_e,        kind,        UVM_ALL_ON)
        `uvm_field_enum(memory_type_e, memory_type, UVM_ALL_ON)
        `uvm_field_int(base_address,                UVM_ALL_ON)
        `uvm_field_int(size,                        UVM_ALL_ON)
        `uvm_field_string(pattern,                  UVM_ALL_ON)
        `uvm_field_string(file_path,                UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name="mem_model_cmd");
        super.new(name);
    endfunction
endclass: memory_model_command


`endif // __NVDLA_TB_TXN_SV__
