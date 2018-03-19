`ifndef MEM_REGION_SVH
`define MEM_REGION_SVH

class mem_region extends uvm_report_object;

    rand bit [`MEM_ADDR_SIZE_MAX-1:0] base;
    rand bit [`MEM_ADDR_SIZE_MAX-1:0] limit;

    constraint c_limit {
        base <= limit;
    }

    extern function new(string name);
    extern function bit [`MEM_ADDR_SIZE_MAX-1:0] get_start_offset();
    extern function bit [`MEM_ADDR_SIZE_MAX-1:0] get_end_offset();
    extern function bit [`MEM_ADDR_SIZE_MAX-1:0] get_len();
    extern function bit overlaps(mem_region region);
    extern function bit has_addr(bit [`MEM_ADDR_SIZE_MAX-1:0] addr);
    extern function bit is_coherent();
    extern function string convert2string();

endclass


function mem_region::new(string name);
    super.new(name);
endfunction

function bit [`MEM_ADDR_SIZE_MAX-1:0] mem_region::get_start_offset();
    return this.base;
endfunction

function bit [`MEM_ADDR_SIZE_MAX-1:0] mem_region::get_end_offset();
    return this.limit;
endfunction

function bit [`MEM_ADDR_SIZE_MAX-1:0] mem_region::get_len();
    return limit - base + 1;
endfunction

function bit mem_region::overlaps(mem_region region);
    bit no_overlap;
    if (!this.is_coherent()) begin
        `uvm_error( "mem_region is illegally configured:\n%s", convert2string() )
    end
    if (!region.is_coherent()) begin
        `uvm_error( "mem_region is illegally configured:\n%s", region.convert2string() )
    end
    no_overlap = (this.limit < region.base) || (this.base > region.limit);
    return ! no_overlap;
endfunction

function bit mem_region::has_addr(bit [`MEM_ADDR_SIZE_MAX-1:0] addr);
    return (addr >= base) && (addr <= limit);
endfunction

function bit mem_region::is_coherent();
    return (base <= limit);
endfunction

function string mem_region::convert2string();
    return $sformatf("region %15s: base=%#x, limit=%#x, size=%#x", get_name(), base, limit, limit-base+1);
endfunction

`endif
