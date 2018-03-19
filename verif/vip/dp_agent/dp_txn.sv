`ifndef _DP_TXN_SV_
`define _DP_TXN_SV_

`include "dp_defines.sv"

//-------------------------------------------------------------------------------------
//
// CLASS: dp_txn
//
//-------------------------------------------------------------------------------------

// Parameterized class, DW->Data Width; DS->Data Size
class dp_txn #(int DW = 1, int DS = 1) extends uvm_sequence_item;

    //--------------------------------------------------------------------------------
    //          ENUMERATED TYPES
    //--------------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------------
    //          DATA MEMBERS
    //--------------------------------------------------------------------------------
    
    /// @name Configuration Parameters
    ///@{
    // Fields in SDP2PDP interface
    rand bit [DW-1:0]   sdp_data[]  = new[DS];
    // Removed
    //rand bit [3:0]    wpos;
    //rand bit [3:0]    cpos;
    //rand bit          lc;
    //rand bit          surf_end;
    //rand bit          cube_end;
    // Fields in ACCU2SDP interface
    rand bit [DW-1:0]   accu_data[] = new[DS];
    rand bit          batch_end;
    rand bit          layer_end;

    // Cycle based
    int       c_start;       ///< Cycle number for: Start of txn.
    int       c_end;         ///< Cycle number for: end of txn/data transfer
    
    // Time stamped
    longint   t_start;       ///< Timestamp for: Start of txn.
    longint   t_end;         ///< Timestamp for: end of txn/data transfer
    ///@}


    //--------------------------------------------------------------------------------
    //          UVM Object Macros
    //--------------------------------------------------------------------------------
    `uvm_object_param_utils_begin(dp_txn#(DW,DS))
        if(DW == 32) begin // ACCU2SDP
            `uvm_field_array_int (accu_data,  UVM_ALL_ON)      
            `uvm_field_int (batch_end,        UVM_ALL_ON)      
            `uvm_field_int (layer_end,        UVM_ALL_ON)      
            `uvm_field_array_int (sdp_data,   UVM_ALL_ON | UVM_NOPRINT | UVM_NOCOMPARE)      
            //`uvm_field_int (wpos,             UVM_ALL_ON | UVM_NOPRINT | UVM_NOCOMPARE)      
            //`uvm_field_int (cpos,             UVM_ALL_ON | UVM_NOPRINT | UVM_NOCOMPARE)      
            //`uvm_field_int (lc,               UVM_ALL_ON | UVM_NOPRINT | UVM_NOCOMPARE)      
            //`uvm_field_int (surf_end,         UVM_ALL_ON | UVM_NOPRINT | UVM_NOCOMPARE)      
            //`uvm_field_int (cube_end,         UVM_ALL_ON | UVM_NOPRINT | UVM_NOCOMPARE)      
        end
        else begin // SDP2PDP
            `uvm_field_array_int (accu_data,  UVM_ALL_ON | UVM_NOPRINT | UVM_NOCOMPARE)      
            `uvm_field_int (batch_end,        UVM_ALL_ON | UVM_NOPRINT | UVM_NOCOMPARE)      
            `uvm_field_int (layer_end,        UVM_ALL_ON | UVM_NOPRINT | UVM_NOCOMPARE)      
            `uvm_field_array_int (sdp_data,   UVM_ALL_ON)      
            //`uvm_field_int (wpos,             UVM_ALL_ON)      
            //`uvm_field_int (cpos,             UVM_ALL_ON)      
            //`uvm_field_int (lc,               UVM_ALL_ON)      
            //`uvm_field_int (surf_end,         UVM_ALL_ON)      
            //`uvm_field_int (cube_end,         UVM_ALL_ON)      
        end
        `uvm_field_int(c_start,     UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(c_end,       UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(t_start,     UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(t_end,       UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_object_utils_end
    
    //--------------------------------------------------------------------------------
    //          CONSTRAINTS
    //--------------------------------------------------------------------------------
    
    /// Doxygen Description of the constraint
    constraint c_dp { 
    }
    
    //--------------------------------------------------------------------------------
    //          MEMBER FUNCTIONS & TASKS
    //--------------------------------------------------------------------------------
    
    ////////////////////////////////////////////////////////////////////////////////
    /// Create new dp_txn object.
    function new(string name = "dp_txn");
        super.new(name);
    endfunction:new

    //virtual function void set_data(ref bit [`DP_PD_WIDTH-1:0] p []);
    //    // TBD
    //endfunction

    //virtual function void get_data(output bit [`DP_PD_WIDTH-1:0] p []);
    //    // TBD
    //endfunction

    virtual function bit is_read();
    endfunction

endclass: dp_txn

`endif //  _DP_TXN_SV_
