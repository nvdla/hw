`ifndef _DMA_TXN_SV_
`define _DMA_TXN_SV_

//`include "dma_defines.sv"

//-------------------------------------------------------------------------------------
//
// CLASS: dma_txn
//
//-------------------------------------------------------------------------------------

class dma_txn extends uvm_sequence_item;

    //--------------------------------------------------------------------------------
    //          ENUMERATED TYPES
    //--------------------------------------------------------------------------------
    typedef enum {READ,WRITE} kind_e;     // 0 for read, 1 for write

    rand kind_e     kind;
    
    //--------------------------------------------------------------------------------
    //          DATA MEMBERS
    //--------------------------------------------------------------------------------
    `define DMA_SIZE_WIDTH (`DMA_RD_SIZE_WIDTH > `DMA_WR_SIZE_WIDTH) ? `DMA_RD_SIZE_WIDTH : `DMA_WR_SIZE_WIDTH
    
    /// @name Configuration Parameters
    ///@{
    rand bit [`DMA_ADDR_WIDTH-1:0] addr;    // read/wirte address
    rand bit [`DMA_SIZE_WIDTH-1:0] length;
    rand bit                       require_ack;  // Used for write request, require complete signal
    rand bit [`DMA_DATA_WIDTH-1:0] data[];
    rand bit                       mask[];
    int                            wt_dma_id = -1;  // Only used for cdma_wt agent

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
    `uvm_object_utils_begin(dma_txn)
        `uvm_field_enum(kind_e, kind,                  UVM_ALL_ON)  
        `uvm_field_int (require_ack,                   UVM_ALL_ON)      
        `uvm_field_int (length,                        UVM_ALL_ON)      
        `uvm_field_int (addr,                          UVM_ALL_ON)      
        `uvm_field_array_int (data,                    UVM_ALL_ON)      
        `uvm_field_array_int (mask,    UVM_ALL_ON | UVM_NOCOMPARE) 
        `uvm_field_int(wt_dma_id,      UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(c_start,        UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(c_end,          UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(t_start,        UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_int(t_end,          UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_object_utils_end
    
    //--------------------------------------------------------------------------------
    //          CONSTRAINTS
    //--------------------------------------------------------------------------------
    
    /// Doxygen Description of the constraint
    constraint c_dma { 
    }
    
    //--------------------------------------------------------------------------------
    //          MEMBER FUNCTIONS & TASKS
    //--------------------------------------------------------------------------------
    
    ////////////////////////////////////////////////////////////////////////////////
    /// Create new dma_txn object.
    function new(string name = "dma_txn");
        super.new(name);
    endfunction:new

    virtual function bit is_write();
        return bit'(kind);
    endfunction

    virtual function void set_write();
        this.kind = WRITE;
    endfunction

    virtual function bit is_read();
        return bit'(!kind);
    endfunction

    virtual function void set_read();
        this.kind = READ;
    endfunction

    virtual function void set_addr(bit [`DMA_ADDR_WIDTH-1:0] addr);
        this.addr = addr[`DMA_ADDR_WIDTH-1:0];
    endfunction

    virtual function bit[`DMA_ADDR_WIDTH:0] get_addr();
        return(this.addr);
    endfunction

    virtual function int get_id();
        int id;
        if(wt_dma_id != -1) begin  // wt_dma
            id = 'h20 + wt_dma_id; // id[5] indicate for wt_dma 
        end
        else begin
            id = wt_dma_id; // -1
        end
        return id;
    endfunction : get_id

endclass: dma_txn

`endif //  _DMA_TXN_SV_
