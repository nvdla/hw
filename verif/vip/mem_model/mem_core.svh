`ifndef _MEM_CORE_SVH_
`define _MEM_CORE_SVH_

//-------------------------------------------------------------------------------------
//
// CLASS: mem_core
//
// Core function of memory model.
//-------------------------------------------------------------------------------------

typedef class memory_model_command;
typedef class surface_file_content;    
typedef class surface_store_info;

class mem_core extends uvm_component;

    typedef enum {RANDOM, ZEROS, ONES, X, AFIVE, FIVEA, ADDR} init_option_enum;

    string tID;

    rand init_option_enum init_option = RANDOM;
    rand bit dont_store_uninitialized_vals = 0;

    surface_store_info ssi_queue[$];
    
    protected bit [7:0] m_mem[*];

    `uvm_component_utils_begin(mem_core)
        `uvm_field_enum(init_option_enum, init_option, UVM_DEFAULT)
        `uvm_field_int(dont_store_uninitialized_vals, UVM_DEFAULT)
    `uvm_component_utils_end

    // Constructor
    extern function new(string name = "mem_core", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);

    // Read functions
    extern function bit [1023:0] read(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [10:0] size_in_bits);
    extern function bit [7:0] read8(bit [`MEM_ADDR_WIDTH-1:0] addr);
    extern function bit [15:0] read16(bit [`MEM_ADDR_WIDTH-1:0] addr);    
    extern function bit [31:0] read32(bit [`MEM_ADDR_WIDTH-1:0] addr);
    extern function bit [63:0] read64(bit [`MEM_ADDR_WIDTH-1:0] addr);
    extern function bit [127:0] read128(bit [`MEM_ADDR_WIDTH-1:0] addr);
    extern function bit [255:0] read256(bit [`MEM_ADDR_WIDTH-1:0] addr);
    extern function bit [511:0] read512(bit [`MEM_ADDR_WIDTH-1:0] addr);    
    extern function bit [1023:0] read1024(bit [`MEM_ADDR_WIDTH-1:0] addr);

    // Write functions
    extern function void write(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [1023:0] data, bit [10:0] size_in_bits, bit [127:0] wstrb);
    extern function void write8(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [7:0] data, bit wstrb = 1'b1);
    extern function void write16(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [15:0] data, bit [1:0] wstrb = {2{1'b1}});
    extern function void write32(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [31:0] data, bit [3:0] wstrb = {4{1'b1}});
    extern function void write64(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [63:0] data, bit [7:0] wstrb = {8{1'b1}});
    extern function void write128(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [127:0] data, bit [15:0] wstrb = {16{1'b1}});
    extern function void write256(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [255:0] data, bit [31:0] wstrb = {32{1'b1}});
    extern function void write512(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [511:0] data, bit [63:0] wstrb = {64{1'b1}});
    extern function void write1024(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [1023:0] data, bit [127:0] wstrb = {128{1'b1}});
    
    // Surface Load & Dump functions
    extern function void load_surface(string filename, bit [`MEM_ADDR_WIDTH-1:0] base);
    extern function void dump_surface(string filename, bit [`MEM_ADDR_WIDTH-1:0] base, int unsigned len);
    extern function void init_surface_with_pattern(bit [`MEM_ADDR_WIDTH-1:0] base, int unsigned len, string pattern);
    extern function void init_surface_with_pattern_and_file(bit [`MEM_ADDR_WIDTH-1:0] base, string pattern, string filename);

    // Other APIs
    extern function bit mem_exists(bit [`MEM_ADDR_WIDTH-1:0] addr);
    extern function int unsigned calc_surface_crc(bit [`MEM_ADDR_WIDTH-1:0] base, int len);
    
    // Private utility functions
    extern protected function string m_trimed_string(string str);
    extern protected function int m_atov(string str);
    extern protected function void m_parse_surface_file(string filename, output surface_file_content content);
    extern protected function void m_update_surface_store_info(bit [`MEM_ADDR_WIDTH-1:0] base, int unsigned len);    

endclass

// -----------------------------------------------------------------------------
// Constructor
// -----------------------------------------------------------------------------

function mem_core::new(string name = "mem_core", uvm_component parent = null);
    super.new(name, parent);
    tID = get_type_name().toupper();
endfunction

function void mem_core::build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_db#(int)::get(this, "", "dont_store_uninitialized_vals", dont_store_uninitialized_vals);
    uvm_config_db#(mem_core::init_option_enum)::get(this, "", "init_option", init_option);
endfunction

// -----------------------------------------------------------------------------
// Read functions
// -----------------------------------------------------------------------------

function bit [1023:0] mem_core::read(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [10:0] size_in_bits);
    int unsigned num_bytes;
    bit [1023:0] rdata;
    
    if (size_in_bits%8 != 0)
        `uvm_error("MEM/RD_SIZE", $sformatf("Trying to read a number of bits (%0d) which is not divisible by 8", size_in_bits))

    num_bytes = size_in_bits/8;
    for (int i=0; i<num_bytes; i++) begin
        if (m_mem.exists(addr+i)) begin
            rdata[8*i+7 -: 8] = m_mem[addr+i];
        end else begin
            bit [7:0] data;
            case (init_option)
                RANDOM : data = $urandom();
                ZEROS  : data = 8'h00;
                ONES   : data = 8'hff;
                X      : data = 8'hxx;
                AFIVE  : data = 8'ha5;
                FIVEA  : data = 8'h5a;
                ADDR   : data = (addr+i) & 'hff;
            endcase
            rdata[8*i+7 -: 8] = data;
            `uvm_info("MEM/RD", $sformatf("Read %#x from uninitialized addr %#0x", data, addr+i), UVM_FULL)
            if (!dont_store_uninitialized_vals)
                write8(addr+i, data);
        end
        `uvm_info("MEM/RD", $sformatf("Read %#2x from addr %#x", m_mem[addr+i], addr+i), UVM_FULL)        
    end

    return rdata;
endfunction

function bit [7:0] mem_core::read8(bit [`MEM_ADDR_WIDTH-1:0] addr);
    return read(addr, 8);
endfunction

function bit [15:0] mem_core::read16(bit [`MEM_ADDR_WIDTH-1:0] addr);
    return read(addr, 16);    
endfunction
    
function bit [31:0] mem_core::read32(bit [`MEM_ADDR_WIDTH-1:0] addr);
    return read(addr, 32);    
endfunction
    
function bit [63:0] mem_core::read64(bit [`MEM_ADDR_WIDTH-1:0] addr);
    return read(addr, 64);    
endfunction
    
function bit [127:0] mem_core::read128(bit [`MEM_ADDR_WIDTH-1:0] addr);
    return read(addr, 128);    
endfunction
    
function bit [255:0] mem_core::read256(bit [`MEM_ADDR_WIDTH-1:0] addr);
    return read(addr, 256);    
endfunction
    
function bit [511:0] mem_core::read512(bit [`MEM_ADDR_WIDTH-1:0] addr);
    return read(addr, 512);    
endfunction
    
function bit [1023:0] mem_core::read1024(bit [`MEM_ADDR_WIDTH-1:0] addr);
    return read(addr, 1024);    
endfunction

// -----------------------------------------------------------------------------
// Write functions
// -----------------------------------------------------------------------------

function void mem_core::write(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [1023:0] data, bit [10:0] size_in_bits, bit [127:0] wstrb);
    int unsigned num_bytes;
    
    if (size_in_bits%8 != 0)
        `uvm_error("MEM/WR_SIZE", $sformatf("Trying to write a number of bits (%0d) which is not divisible by 8", size_in_bits))

    num_bytes = size_in_bits/8;
    for (int i=0; i<num_bytes; i++) begin
        if (wstrb[i]) begin
            m_mem[addr+i] = data[8*i+7 -: 8];
            `uvm_info("MEM/WR", $sformatf("Write %#2x to addr %#x", m_mem[addr+i], addr+i), UVM_FULL)
        end
    end
endfunction
    
function void mem_core::write8(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [7:0] data, bit wstrb = 1'b1);
    write(addr, data, 8, wstrb);
endfunction
    
function void mem_core::write16(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [15:0] data, bit [1:0] wstrb = {2{1'b1}});
    write(addr, data, 16, wstrb);    
endfunction
    
function void mem_core::write32(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [31:0] data, bit [3:0] wstrb = {4{1'b1}});
    write(addr, data, 32, wstrb);
endfunction

function void mem_core::write64(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [63:0] data, bit [7:0] wstrb = {8{1'b1}});
    write(addr, data, 64, wstrb);    
endfunction
    
function void mem_core::write128(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [127:0] data, bit [15:0] wstrb = {16{1'b1}});
    write(addr, data, 128, wstrb);    
endfunction
    
function void mem_core::write256(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [255:0] data, bit [31:0] wstrb = {32{1'b1}});
    write(addr, data, 256, wstrb);    
endfunction
    
function void mem_core::write512(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [511:0] data, bit [63:0] wstrb = {64{1'b1}});
    write(addr, data, 512, wstrb);    
endfunction
    
function void mem_core::write1024(bit [`MEM_ADDR_WIDTH-1:0] addr, bit [1023:0] data, bit [127:0] wstrb = {128{1'b1}});
    write(addr, data, 1024, wstrb);    
endfunction

// -----------------------------------------------------------------------------
// Memory Load & Dump functions
// -----------------------------------------------------------------------------

// Surface file format: {addr:0x20, size:4, payload:0x00 0x10 0x20 0x30}
function void mem_core::load_surface(string filename, bit [`MEM_ADDR_WIDTH-1:0] base);
    surface_file_content content;

    m_parse_surface_file(filename, content);
    foreach (content.offset[i])
        write8(base+content.offset[i], content.data[i]);

    m_update_surface_store_info(base, content.end_offset);
endfunction

// One segment is a continuous area, which can be divided into multiple payloads
// when dumped to file.
function void mem_core::dump_surface(string filename,
                                     bit [`MEM_ADDR_WIDTH-1:0] base,
                                     int unsigned len);
    int fh;
    int segment_start_offset;
    int segment_end_offset;
    int segment_len;
    byte segment_data[$];
    int num_payload;
    int payload_size;
    string q[$];

    `uvm_info("MEM/DUMP",
        $sformatf("Dump surface stored in [%#x:%#x] to %s", base, base+len-1, filename), UVM_FULL)
    
    fh = $fopen(filename, "w");
    if (!fh) `uvm_fatal("FILE/OPEN/FAILED", {"Open ", filename, " failed!"})

    q.push_back("{\n");
    for (int offset=0; offset<len; offset++) begin
        if (mem_exists(base+offset) && ((offset == 0) || !mem_exists(base+offset-1)))
            segment_start_offset = offset;

        if (mem_exists(base+offset) && ((offset == len-1) || !mem_exists(base+offset+1))) begin
            segment_end_offset = offset + 1;
            for (int j=segment_start_offset; j<segment_end_offset; j++) begin
                segment_data.push_back(read8(base+j));
            end

            // Print in a new line (a payload) every 16 bytes
            segment_len = segment_end_offset - segment_start_offset;            
            num_payload = (segment_len%16 == 0) ? segment_len/16 : segment_len/16 + 1;
            `uvm_info("MEM/DUMP",
                $sformatf("segment_start_offset = %#4x, segment_end_offset = %#4x, segment_len = %0d, num_payload = %0d",
                segment_start_offset, segment_end_offset, segment_len, num_payload), UVM_FULL)

            for (int payload_idx=0; payload_idx<num_payload; payload_idx++) begin
                if ((payload_idx == num_payload-1) && (segment_len%16 != 0))
                    payload_size = segment_len % 16;
                else
                    payload_size = 16;                    

                q.push_back("  { ");
                q.push_back($sformatf("offset:%#4x, size:%2d, payload:",
                    segment_start_offset+16*payload_idx, payload_size));
                repeat (payload_size)
                    q.push_back($sformatf("%#2x ", segment_data.pop_front()));

                q.push_back("},\n");
            end
            segment_data.delete();
        end
    end

    // Remove "," in the end of last line.
    begin
        string s;
        s = q.pop_back();
        if (s[s.len()-2] == ",")
            s = {s.substr(0, s.len()-3), "\n"};
        q.push_back(s);
    end
    
    q.push_back("}");

    $fwrite(fh, `UVM_STRING_QUEUE_STREAMING_PACK(q));
    $fclose(fh);
endfunction

function void mem_core::init_surface_with_pattern(bit [`MEM_ADDR_WIDTH-1:0] base,
                                                  int unsigned len,
                                                  string pattern);
    bit [7:0]  data;

    for (int i=0; i<len; i++) begin
        case (pattern)
            "RANDOM" : data = $urandom();
            "ALL_ZERO"  : data = 8'h00;
            "ONES"   : data = 8'hff;
            "X"      : data = 8'hxx;
            "AFIVE"  : data = 8'ha5;
            "FIVEA"  : data = 8'h5a;
            "ADDR"   : data = (base+i) & 'hff;
        endcase
        `uvm_info(tID, $sformatf("Init %#x to addr %#0x", data, base+i), UVM_HIGH)
        write8(base+i, data);
    end

    m_update_surface_store_info(base, len);
endfunction

function void mem_core::init_surface_with_pattern_and_file(bit [`MEM_ADDR_WIDTH-1:0] base,
                                                           string pattern,
                                                           string filename);
    surface_file_content content;

    m_parse_surface_file(filename, content);
    init_surface_with_pattern(base, content.end_offset, pattern);
endfunction
    
// -----------------------------------------------------------------------------
// Other APIs
// -----------------------------------------------------------------------------

function bit mem_core::mem_exists(bit [`MEM_ADDR_WIDTH-1:0] addr);
    return m_mem.exists(addr);
endfunction

// CRC32 lookup table is generated by following code:
// 
//|  int unsigned crc;
//|  for (int i=0; i<256; i++) begin
//|      crc = i;
//|      for (int j=0; j<8; j++) begin    // 8 reduction
//|          crc = (crc >> 1) ^ (crc[0] ? 'hEDB88320L : 0);
//|      end
//|      crc32_table[i] = crc;
//|  end

function int unsigned mem_core::calc_surface_crc(bit [`MEM_ADDR_WIDTH-1:0] base, int len);
    static const int unsigned crc32_table[] = {32'h00000000,32'h77073096,32'hee0e612c,32'h990951ba,
                                               32'h076dc419,32'h706af48f,32'he963a535,32'h9e6495a3,
                                               32'h0edb8832,32'h79dcb8a4,32'he0d5e91e,32'h97d2d988,
                                               32'h09b64c2b,32'h7eb17cbd,32'he7b82d07,32'h90bf1d91,
                                               32'h1db71064,32'h6ab020f2,32'hf3b97148,32'h84be41de,
                                               32'h1adad47d,32'h6ddde4eb,32'hf4d4b551,32'h83d385c7,
                                               32'h136c9856,32'h646ba8c0,32'hfd62f97a,32'h8a65c9ec,
                                               32'h14015c4f,32'h63066cd9,32'hfa0f3d63,32'h8d080df5,
                                               32'h3b6e20c8,32'h4c69105e,32'hd56041e4,32'ha2677172,
                                               32'h3c03e4d1,32'h4b04d447,32'hd20d85fd,32'ha50ab56b,
                                               32'h35b5a8fa,32'h42b2986c,32'hdbbbc9d6,32'hacbcf940,
                                               32'h32d86ce3,32'h45df5c75,32'hdcd60dcf,32'habd13d59,
                                               32'h26d930ac,32'h51de003a,32'hc8d75180,32'hbfd06116,
                                               32'h21b4f4b5,32'h56b3c423,32'hcfba9599,32'hb8bda50f,
                                               32'h2802b89e,32'h5f058808,32'hc60cd9b2,32'hb10be924,
                                               32'h2f6f7c87,32'h58684c11,32'hc1611dab,32'hb6662d3d,
                                               32'h76dc4190,32'h01db7106,32'h98d220bc,32'hefd5102a,
                                               32'h71b18589,32'h06b6b51f,32'h9fbfe4a5,32'he8b8d433,
                                               32'h7807c9a2,32'h0f00f934,32'h9609a88e,32'he10e9818,
                                               32'h7f6a0dbb,32'h086d3d2d,32'h91646c97,32'he6635c01,
                                               32'h6b6b51f4,32'h1c6c6162,32'h856530d8,32'hf262004e,
                                               32'h6c0695ed,32'h1b01a57b,32'h8208f4c1,32'hf50fc457,
                                               32'h65b0d9c6,32'h12b7e950,32'h8bbeb8ea,32'hfcb9887c,
                                               32'h62dd1ddf,32'h15da2d49,32'h8cd37cf3,32'hfbd44c65,
                                               32'h4db26158,32'h3ab551ce,32'ha3bc0074,32'hd4bb30e2,
                                               32'h4adfa541,32'h3dd895d7,32'ha4d1c46d,32'hd3d6f4fb,
                                               32'h4369e96a,32'h346ed9fc,32'had678846,32'hda60b8d0,
                                               32'h44042d73,32'h33031de5,32'haa0a4c5f,32'hdd0d7cc9,
                                               32'h5005713c,32'h270241aa,32'hbe0b1010,32'hc90c2086,
                                               32'h5768b525,32'h206f85b3,32'hb966d409,32'hce61e49f,
                                               32'h5edef90e,32'h29d9c998,32'hb0d09822,32'hc7d7a8b4,
                                               32'h59b33d17,32'h2eb40d81,32'hb7bd5c3b,32'hc0ba6cad,
                                               32'hedb88320,32'h9abfb3b6,32'h03b6e20c,32'h74b1d29a,
                                               32'head54739,32'h9dd277af,32'h04db2615,32'h73dc1683,
                                               32'he3630b12,32'h94643b84,32'h0d6d6a3e,32'h7a6a5aa8,
                                               32'he40ecf0b,32'h9309ff9d,32'h0a00ae27,32'h7d079eb1,
                                               32'hf00f9344,32'h8708a3d2,32'h1e01f268,32'h6906c2fe,
                                               32'hf762575d,32'h806567cb,32'h196c3671,32'h6e6b06e7,
                                               32'hfed41b76,32'h89d32be0,32'h10da7a5a,32'h67dd4acc,
                                               32'hf9b9df6f,32'h8ebeeff9,32'h17b7be43,32'h60b08ed5,
                                               32'hd6d6a3e8,32'ha1d1937e,32'h38d8c2c4,32'h4fdff252,
                                               32'hd1bb67f1,32'ha6bc5767,32'h3fb506dd,32'h48b2364b,
                                               32'hd80d2bda,32'haf0a1b4c,32'h36034af6,32'h41047a60,
                                               32'hdf60efc3,32'ha867df55,32'h316e8eef,32'h4669be79,
                                               32'hcb61b38c,32'hbc66831a,32'h256fd2a0,32'h5268e236,
                                               32'hcc0c7795,32'hbb0b4703,32'h220216b9,32'h5505262f,
                                               32'hc5ba3bbe,32'hb2bd0b28,32'h2bb45a92,32'h5cb36a04,
                                               32'hc2d7ffa7,32'hb5d0cf31,32'h2cd99e8b,32'h5bdeae1d,
                                               32'h9b64c2b0,32'hec63f226,32'h756aa39c,32'h026d930a,
                                               32'h9c0906a9,32'heb0e363f,32'h72076785,32'h05005713,
                                               32'h95bf4a82,32'he2b87a14,32'h7bb12bae,32'h0cb61b38,
                                               32'h92d28e9b,32'he5d5be0d,32'h7cdcefb7,32'h0bdbdf21,
                                               32'h86d3d2d4,32'hf1d4e242,32'h68ddb3f8,32'h1fda836e,
                                               32'h81be16cd,32'hf6b9265b,32'h6fb077e1,32'h18b74777,
                                               32'h88085ae6,32'hff0f6a70,32'h66063bca,32'h11010b5c,
                                               32'h8f659eff,32'hf862ae69,32'h616bffd3,32'h166ccf45,
                                               32'ha00ae278,32'hd70dd2ee,32'h4e048354,32'h3903b3c2,
                                               32'ha7672661,32'hd06016f7,32'h4969474d,32'h3e6e77db,
                                               32'haed16a4a,32'hd9d65adc,32'h40df0b66,32'h37d83bf0,
                                               32'ha9bcae53,32'hdebb9ec5,32'h47b2cf7f,32'h30b5ffe9,
                                               32'hbdbdf21c,32'hcabac28a,32'h53b39330,32'h24b4a3a6,
                                               32'hbad03605,32'hcdd70693,32'h54de5729,32'h23d967bf,
                                               32'hb3667a2e,32'hc4614ab8,32'h5d681b02,32'h2a6f2b94,
                                               32'hb40bbe37,32'hc30c8ea1,32'h5a05df1b,32'h2d02ef8d};

    bit [`MEM_ADDR_WIDTH-1:0] addr = base;
    int unsigned              result = ~0;

    if (0 != base%4)
        `uvm_error("CRC/CALC", $sformatf("base (%0d) is not multiple of 4", base))

    if (0 != len%4)
        `uvm_error("CRC/CALC", $sformatf("length (%0d) is not multiple of 4", len))

    `uvm_info("MEM/CRC", $sformatf("Calculate CRC32 of memory range [%#x:%#x]", base, base+len), UVM_FULL)
    
    while (len >= 4) begin
        int unsigned d = mem_exists(addr) ? read32(addr) : 0;
        for (int i=0; i<32; i+=8 ) begin
            byte unsigned b = (d>>i) & 8'hff;
            result = (result>>8) ^ crc32_table[result[7:0]^b];
        end
        addr += 4;
        len -= 4;
    end
    
    return ~result;
endfunction

// -----------------------------------------------------------------------------
// Utility Functions
// -----------------------------------------------------------------------------

function string mem_core::m_trimed_string(string str);
    string s = str;
    
    // Strip front spaces and '{' in a str
    while (s[0] inside {" ", "\t", "\n", "{"})
        s = s .substr(1);

    // Strip tail spaces, '}' and ',' in a str
    while (s[s.len()-1] inside {" ", "\t", "\n", "}", ","})
        s = s.substr(0, s.len()-2);
    
    return s;
endfunction

// Only supports hex, oct and dec radix.
function int mem_core::m_atov(string str);
    string s;
    int    val;

    s = m_trimed_string(str);
    if (s.substr(0, 1) inside {"0x", "0X"})
        val = s.substr(2).atohex();
    else if (s.substr(0, 0) == "0")
        val = s.atooct();
    else
        val = s.atoi();

    return val;
endfunction

function void mem_core::m_parse_surface_file(string filename, output surface_file_content content);
    int    fh;
    string line;
    string payload_offset_str;
    string payload_size_str;
    string payload_str;
    string payload_data_str;    
    int    payload_offset;
    int    payload_size;
    string split_vals[$];    

    fh = $fopen(filename, "r");
    if (!fh) `uvm_fatal("FILE/OPEN/FAILED", {"Open ", filename, " failed!"})

    content = new();
    
    while (!$feof(fh)) begin
        void'($fgets(line, fh));
        line = m_trimed_string(line);

        // Skip comments
        if (line[0] == "#") continue;
        
        uvm_split_string(line, ",", split_vals);
        if (split_vals.size() != 3) continue;

        payload_offset_str = m_trimed_string(split_vals[0]);
        payload_size_str = m_trimed_string(split_vals[1]);
        payload_str = m_trimed_string(split_vals[2]);

        // Offset part format - offset:0x10 or offset:16
        if (payload_offset_str.substr(0, 5) != "offset")
            `uvm_warning("INVFMT",
                $sformatf("Offset part (%s) must start with 'offset'", payload_offset_str))
        uvm_split_string(payload_offset_str, ":", split_vals);
        payload_offset = m_atov(split_vals[1]);

        // Size part format - size:0x10 or size:16
        if (payload_size_str.substr(0, 3) != "size")
            `uvm_warning("INVFMT",
                $sformatf("Size part (%s) must start with 'size'", payload_size_str))
        uvm_split_string(payload_size_str, ":", split_vals);
        payload_size = m_atov(split_vals[1]);

        // Payload part format - payload: 0x1 0x2
        if (payload_str.substr(0, 6) != "payload")
            `uvm_warning("INVFMT",
                $sformatf("Payload part (%s) must start with 'payload'", payload_str))
        uvm_split_string(payload_str, ":", split_vals);
        payload_data_str = split_vals[1];

        // Debug info
        `uvm_info("PARSE/SURFACE_FILE", {payload_offset_str, ", ", payload_size_str, ", ", payload_str}, UVM_FULL)

        // Store file content
        uvm_split_string(payload_data_str, " ", split_vals);        
        for (int i=0; i<payload_size; i++) begin
            content.offset.push_back(payload_offset+i);
            if (i < split_vals.size())
                content.data.push_back(m_atov(split_vals[i]));
            else
                content.data.push_back(0);
        end
    end

    begin
        bit [`MEM_ADDR_WIDTH-1:0] maxq[$];
        bit [`MEM_ADDR_WIDTH-1:0] minq[$];

        maxq = content.offset.max();
        minq = content.offset.min();
        content.start_offset = minq[0];
        content.end_offset = maxq[0] + 1;
        `uvm_info("PARSE/SURFACE_FILE",
            $sformatf("start_offset = %#0x, end_offset = %#0x", content.start_offset, content.end_offset), UVM_FULL)
    end

    $fclose(fh);        
endfunction

function void mem_core::m_update_surface_store_info(bit [`MEM_ADDR_WIDTH-1:0] base, int unsigned len);
    surface_store_info ssi;    

    ssi = new(base, len);
    ssi_queue.push_back(ssi);
    `uvm_info("MEM/LOAD", ssi.convert2string(), UVM_FULL)
endfunction

// ----------------------------------------------------------------------------
// Utility class
// ----------------------------------------------------------------------------    

class surface_store_info;
    int surface_id;
    static local int m_surface_count = 0;

    bit [`MEM_ADDR_WIDTH-1:0] base;
    int unsigned len;

    function new(bit [`MEM_ADDR_WIDTH-1:0] base, int unsigned len);
        this.surface_id = m_surface_count;
        m_surface_count++;
        this.base = base;
        this.len = len;
    endfunction

    function string convert2string();
        string   s;
        s = $sformatf("Surface %0d: base = %#x, len = %0d", surface_id, base, len);
        return s;
    endfunction
endclass

class surface_file_content;
    bit [`MEM_ADDR_WIDTH-1:0] offset[$];
    bit [7:0]                 data[$];

    bit [`MEM_ADDR_WIDTH-1:0] start_offset;
    bit [`MEM_ADDR_WIDTH-1:0] end_offset; // offset guard, next of last valid offset.
endclass
    
`endif // _MEM_CORE_SVH_
