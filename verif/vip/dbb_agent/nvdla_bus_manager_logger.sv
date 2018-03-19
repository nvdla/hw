`ifndef nvdla_bus_manager_logger__SV
`define nvdla_bus_manager_logger__SV

//////////////////////////////////////////////////////////////////////      
//////////////////////////////////////////////////////////////////////      
///
///                  class nvdla_bus_manager_logger
///
//////////////////////////////////////////////////////////////////////      
//////////////////////////////////////////////////////////////////////      


/// Class to print messages when bus manager is used.
class nvdla_bus_manager_logger extends nvdla_txn_logger();
    int colndx[string]; ///< Associative array to store column numbers, indexed by column name.
    
    `uvm_component_utils_begin(nvdla_bus_manager_logger)
    `uvm_component_utils_end

    ////////////////////////////////////////////////////////////////////////////////
    /// Create a new BM logging object.
      function new(string inst          = "nvdla_bus_manager_logger",
                   uvm_component parent = null);
          super.new(inst,parent);
      endfunction: new

    ////////////////////////////////////////////////////////////////////////////////
    /// Called automatically during the UVM build phase.
    /// Initializes the logger by creating all of the columns with the appropriate
    /// attributes. Column numbers are assigned to an associative array for easier
    /// indexing and code readability.
    function void build_phase(uvm_phase phase);
        int    time_width;
        super.build_phase(phase);
        time_width = 20;   // Allow a little more space for abs. time
        colndx["Bus name"]      = register_column("Bus name",13,STRING);
        colndx["Bus Type"]      = register_column("Bus Type",8,STRING);
        colndx["Start Time"]    = register_column("Start Time",10,DEC);
        colndx["Finish Time"]   = register_column("Finish Time",10,DEC);
        colndx["Address"]       = register_column("Address",16,HEX);
        colndx["Dir"]           = register_column("Dir",1,STRING);
        colndx["Xfer Size"]     = register_column("Xfer Size",4,DEC);
        colndx["Burst Len"]     = register_column("Burst Len",2,DEC);
        colndx["Xfer Type"]     = register_column("Xfer Type",10,STRING);
        // Configure 'time' columns to grow as needed, rather than truncate/wrap
        configure_col_truncate(colndx["Bus name"],  TR_FLOW);      
        configure_col_truncate(colndx["Start Time"],  TR_GROW);
        configure_col_truncate(colndx["Finish Time"],  TR_GROW);      
    endfunction: build_phase

    ////////////////////////////////////////////////////////////////////////////////
    /// Function to log a system transaction on a single line.
    function void log_bus(string bus_name, string bus_type, longint t_start, longint t_end,
                          bit [63:0] addr, string xfer_kind, int xfer_size, int burst_len, string xfer_type);
        set_column_text(colndx["Bus name"],bus_name);
        set_column_text(colndx["Bus Type"],bus_type);
        set_column_val(colndx["Start Time"],t_start);
        set_column_val(colndx["Finish Time"],t_end);
        set_column_val(colndx["Address"],addr);
        set_column_text(colndx["Dir"],xfer_kind);
        set_column_val(colndx["Xfer Size"],xfer_size);
        set_column_val(colndx["Burst Len"],burst_len);
        set_column_text(colndx["Xfer Type"],xfer_type);

        print_row();
    endfunction: log_bus

endclass
`endif



