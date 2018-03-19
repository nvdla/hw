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


