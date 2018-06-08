`ifndef _CC_TXN_SV_
`define _CC_TXN_SV_

`include "cc_defines.sv"

//-------------------------------------------------------------------------------------
//
// CLASS: cc_txn
//
//-------------------------------------------------------------------------------------

// parameterized class, DW->Data Width; MW->Mask Width; 
class cc_txn #(int DW = 1, int MW = 1) extends uvm_sequence_item;

    //--------------------------------------------------------------------------------
    //          ENUMERATED TYPES
    //--------------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------------
    //          DATA MEMBERS
    //--------------------------------------------------------------------------------
    
    /// @name Configuration Parameters
    ///@{
    rand bit [4:0]                   batch_index;
    rand bit                         stripe_st;
    rand bit                         stripe_end;
    rand bit                         channel_end;
//  rand bit                         batch_end;
    rand bit                         layer_end;
    rand bit [MW-1:0]                mask;
    rand bit [DW-1:0]                data[] = new[MW];
    rand bit [`NVDLA_MAC_ATOMIC_K_SIZE_DIV2-1:0]     wt_sel;            // used only for sc2mac_wt
    bit                              conv_mode;         // only used for cmac2cacc
    bit [1:0]                        proc_precision;    // only used for cmac2cacc
    bit [7:0]                        mode;              // only used for cmac2cacc

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
    `uvm_object_param_utils_begin(cc_txn#(DW,MW))
        `uvm_field_int (batch_index,                    UVM_ALL_ON)      
        `uvm_field_int (stripe_st,                      UVM_ALL_ON)      
        `uvm_field_int (stripe_end,                     UVM_ALL_ON)      
        `uvm_field_int (channel_end,                    UVM_ALL_ON)      
//      `uvm_field_int (batch_end,                      UVM_ALL_ON)
        `uvm_field_int (layer_end,                      UVM_ALL_ON)      
        `uvm_field_int (mask,                           UVM_ALL_ON)      
        `uvm_field_int (mode,                           UVM_ALL_ON)      
        `uvm_field_int (wt_sel,                         UVM_ALL_ON)      
        `uvm_field_int (conv_mode,      UVM_ALL_ON | UVM_NOCOMPARE)      
        `uvm_field_int (proc_precision, UVM_ALL_ON | UVM_NOCOMPARE)      
        `uvm_field_array_int (data,                     UVM_ALL_ON)      
        `uvm_field_int(c_start,         UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(c_end,           UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(t_start,         UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(t_end,           UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_object_utils_end
    
    //--------------------------------------------------------------------------------
    //          CONSTRAINTS
    //--------------------------------------------------------------------------------
    
    /// Doxygen Description of the constraint
    constraint c_cc { 
    }
    
    //--------------------------------------------------------------------------------
    //          MEMBER FUNCTIONS & TASKS
    //--------------------------------------------------------------------------------
    
    function new(string name = "cc_txn");
        super.new(name);
    endfunction:new

    virtual function bit is_read();
    endfunction

endclass:cc_txn

`endif //  _CC_TXN_SV_
