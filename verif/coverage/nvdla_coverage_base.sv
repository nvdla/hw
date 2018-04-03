// ===================================================================
// CLASS: nvdla_coverage_base
//     a) define common covergroup
//     b) define common sample function
// ===================================================================

class nvdla_coverage_base;
    
    string          tID;
    ral_sys_top     ral;

    function new(string name, ral_sys_top ral);
        tID = name.toupper();
        this.ral = ral;

`ifdef NVDLA_MEM_ADDRESS_WIDTH
        if (`NVDLA_MEM_ADDRESS_WIDTH > 32) begin
            `define MEM_ADDR_WIDTH_GT_32
            ;
        end else begin
            `undef MEM_ADDR_WIDTH_GT_32
            ;
        end
`endif
    endfunction : new

    // ----------------------------------------------------
    // FUNCTION : 
    //     1) 
    //     2) 
    // ----------------------------------------------------

    // ----------------------------------------------------
    // COVERGROUP : 
    //     1) 
    //     2) 
    // ----------------------------------------------------

endclass : nvdla_coverage_base


