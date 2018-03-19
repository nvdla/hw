`ifndef dbb_logger__SV
`define dbb_logger__SV

//////////////////////////////////////////////////////////////////////      
//////////////////////////////////////////////////////////////////////      
///
///                  class dbb_logger
///
//////////////////////////////////////////////////////////////////////      
//////////////////////////////////////////////////////////////////////      

typedef class uvm_tlm_gp;

/// nvdla DBB transaction logging class. This class utilizes the library nvdla
/// logging class to implement an DBB transaction logger. A configuration bit
/// can be used to indicate whether absolute time, or clock cycle counts should
/// be used for the time stamps.
class dbb_logger#(int MEM_DATA_WIDTH=512) extends nvdla_txn_logger();
    parameter MEM_WSTRB_WIDTH = MEM_DATA_WIDTH/8;
    int colndx[string]; ///< Associative array to store column numbers, indexed by column name.

    /// @name Configuration Parameters
    ///@{
    /// Use clock cycle count, or absolute time?
    bit use_clock_cycle = 0;
    /// Shows the address for each beat, in addition to the overall transaction address.
    bit show_beat_address = 0;
    /// DBB data bus width. Defaults to setting in dbb_defines.svh.
    int data_bus_width = MEM_DATA_WIDTH;
    ///@}

    `uvm_component_param_utils_begin(dbb_logger#(MEM_DATA_WIDTH) )
        `uvm_field_int(use_clock_cycle,   UVM_DEFAULT)
        `uvm_field_int(show_beat_address, UVM_DEFAULT)
        `uvm_field_int(data_bus_width,    UVM_DEFAULT)
    `uvm_component_utils_end

    ////////////////////////////////////////////////////////////////////////////////
    /// Create a new DBB logging object.
      function new(string inst          = "dbb_logger",
                   uvm_component parent = null);
          super.new(inst, parent);
      endfunction: new

    ////////////////////////////////////////////////////////////////////////////////
    /// Called automatically during the UVM build phase.
    /// Initializes the DBB logger by creating all of the columns with the appropriate
    /// attributes. Column numbers are assigned to an associative array for easier
    /// indexing and code readability.
    function void build_phase(uvm_phase phase);
        string ndx;
        int    time_width;
        int    phase_width;
        super.build_phase(phase);
        uvm_config_int::get(this,"","use_clock_cycle",use_clock_cycle);
        uvm_config_int::get(this,"","show_beat_address",show_beat_address);
        uvm_config_int::get(this,"","data_bus_width",data_bus_width);

        phase_width = 8; // Handle 2-decimal-digit data[] phase ()
        colndx["Start"]   = register_column("Start time",time_width,DEC);
        colndx["Finish"]  = register_column("Finish time",time_width,DEC);
        colndx["DIR"]     = register_column("DIR",5,STRING," ");
        colndx["Phase"]   = register_column("Phase",phase_width,STRING," ");
        colndx["Assert"]  = register_column("Valid Assert Time",time_width,DEC);
        colndx["Ready"]   = register_column("Valid Ready Time",time_width,DEC);
        colndx["ADDR"]    = register_column("ADDR",((`DBB_ADDR_WIDTH-1)/4)+1,HEX);
        colndx["AID"]     = register_column("AID",((`DBB_AID_WIDTH-1)/4)+1,HEX);
        colndx["ALEN"]    = register_column("ALEN",3,DEC);
        colndx["ASIZE"]   = register_column("ASIZE",2,DEC);
        colndx["ABURST"]  = register_column("ABURST",3,STRING," ");
        for (int i=(data_bus_width/8)-1; i>=0; i--) begin
            ndx.itoa(i);
            colndx[{"DLANE ",ndx}] = register_column({"DLANE_WSTRB ",ndx},2,HEX);
        end
        colndx["RESP"]    = register_column("RESP",6,STRING," ");
        colndx["LAST"]    = register_column("LAST",1,BIN);

        // Configure 'time' columns to grow as needed, rather than truncate/wrap
        configure_col_truncate(colndx["Start"],  TR_GROW);      
        configure_col_truncate(colndx["Finish"], TR_GROW);      
        configure_col_truncate(colndx["Assert"], TR_GROW);      
        configure_col_truncate(colndx["Ready"],  TR_GROW);      
    endfunction: build_phase
   
    ////////////////////////////////////////////////////////////////////////////////
    /// Called with DBB transaction to log. Will print to logfile or screen or both,
    /// depending on the configuration settings.
    virtual function void log_txn(uvm_tlm_gp tr);
        dbb_bus_ext tr_bus;
        dbb_ctrl_ext tr_ctrl;
        dbb_mon_ext tr_mon;
        dbb_helper_ext tr_helper;
        string field;
        bit [MEM_DATA_WIDTH-1:0] databus;
        int curcol;  // current column counter
        int curbit;  // current bit counter
        int data_bus_bytes = data_bus_width/8;
        string xfer_kind = tr.is_read()?"R":"W";
        
        // If we aren't logging anything, then bail quickly
        if (!(log_to_file || log_to_screen)) return;
        
        `CAST_DBB_EXT(,tr,bus)
        `CAST_DBB_EXT(,tr,ctrl)
        `CAST_DBB_EXT(,tr,mon)
        `CAST_DBB_EXT(,tr,helper)

        // Address Phase
        if (use_clock_cycle) begin // Use clock cycle counts?
            set_column_val(colndx["Start"],tr_mon.c_start);
            set_column_val(colndx["Finish"],tr_mon.c_end);
            set_column_val(colndx["Assert"],tr_mon.c_avalid);
            set_column_val(colndx["Ready"],tr_mon.c_aready);
        end
        else begin                 // Use Absolute Time
            set_column_val(colndx["Start"],tr_mon.t_start);
            set_column_val(colndx["Finish"],tr_mon.t_end);
            set_column_val(colndx["Assert"],tr_mon.t_avalid);
            set_column_val(colndx["Ready"],tr_mon.t_aready);
        end
        set_column_text(colndx["DIR"],xfer_kind);
        set_column_text(colndx["Phase"],"ADDR");
        set_column_val(colndx["ADDR"],tr.get_address());
        set_column_val(colndx["AID"],tr_bus.get_id());
        set_column_val(colndx["ALEN"],tr_bus.get_length());
        set_column_val(colndx["ASIZE"],tr_bus.get_size());
        set_column_text(colndx["ABURST"],field);
        print_row();

        if (tr.is_read()) begin
            // Read Data Phase
            for (int beat=0; beat<tr_bus.get_length(); beat++) begin
                field = $psprintf("DATA[%0d]",beat);
                set_column_text(colndx["Phase"],field);
                if (use_clock_cycle) begin // Use clock cycle counts?
                    set_column_val(colndx["Assert"],tr_mon.c_dvalid[beat]);
                    set_column_val(colndx["Ready"],tr_mon.c_dready[beat]);
                end
                else begin                 // Use Absolute Time
                    set_column_val(colndx["Assert"],tr_mon.t_dvalid[beat]);
                    set_column_val(colndx["Ready"],tr_mon.t_dready[beat]);
                end
                // Show beat address, if configured to
                if (show_beat_address)
                  set_column_val(colndx["ADDR"],tr_helper.beat_address(tr, beat));
                // Get the 'lane shifted' version of the data for logging
                databus = shift_lane_data(tr,beat,data_bus_width,8*tr_bus.get_size());
                // Find the index of the first data column
                curcol  = colndx["DLANE 0"]-(data_bus_bytes-1);
                for (int i=data_bus_bytes-1; i>=0; i--) begin
                    // Shift right and mask off a single byte for each byte lane
                    set_column_val(curcol++,(databus >> (i*8)) & 'hff);
                end
                set_column_text(colndx["RESP"],tr_ctrl.resp[beat].name());
                set_column_val(colndx["LAST"],(beat==tr_mon.last)?1:0);
                print_row();
            end
        end
        else begin
            bit [MEM_WSTRB_WIDTH-1:0] wstrb;
            // Write Data Phase
            for (int beat=0; beat<tr_bus.get_length(); beat++) begin
                field = $psprintf("DATA[%0d]",beat);
                set_column_text(colndx["Phase"],field);
                if (use_clock_cycle) begin // Use clock cycle counts?
                    set_column_val(colndx["Assert"],tr_mon.c_dvalid[beat]);
                    set_column_val(colndx["Ready"],tr_mon.c_dready[beat]);
                end
                else begin                 // Use Absolute Time
                    set_column_val(colndx["Assert"],tr_mon.t_dvalid[beat]);
                    set_column_val(colndx["Ready"],tr_mon.t_dready[beat]);
                end
                // Show beat address, if configured to
                if (show_beat_address)
                  set_column_val(colndx["ADDR"],tr_helper.beat_address(tr, beat));
                // Get the 'lane shifted' version of the data & wstrb for logging
                databus = shift_lane_data(tr,beat,data_bus_width,8*tr_bus.get_size());
                wstrb   = shift_lane_wstrb(tr,beat,data_bus_width,8*tr_bus.get_size());
                // Find the index of the first data column
                curcol = colndx["DLANE 0"]-(data_bus_bytes-1);
                curbit = 1;
                for (int i=data_bus_bytes-1; i>=0; i--) begin
                    // Shift right and mask off a single byte for each byte lane
                    set_column_val(curcol,(databus >> (i*8)) & 'hff);
                    // Now grab the single bit that corresponds to this byte lane
                    format_column_val(curcol++,
                                      wstrb[data_bus_bytes - curbit++],
                                      HEX,1);
                end
                set_column_val(colndx["LAST"],(beat==tr_mon.last)?1:0);
                print_row();
            end
            // Write Response Phase
            set_column_text(colndx["Phase"],"RESP");
            if (use_clock_cycle) begin // Use clock cycle counts?
                set_column_val(colndx["Assert"],tr_mon.c_bresp_valid);
                set_column_val(colndx["Ready"],tr_mon.c_bresp_ready);
            end
            else begin                 // Use Absolute Time
                set_column_val(colndx["Assert"],tr_mon.t_bresp_valid);
                set_column_val(colndx["Ready"],tr_mon.t_bresp_ready);
            end
            set_column_text(colndx["RESP"],tr_ctrl.resp[0].name());
            print_row();
        end
        
    endfunction: log_txn

    //----------------------------------------------------------------------
    /// This function returns the value that should be driven onto the data
    /// bus for a particular beat, shifted into its proper byte lane.
    function bit [MEM_DATA_WIDTH-1:0] shift_lane_data(uvm_tlm_gp tr,
                                     int beatnum,
                                     int dbus_width = MEM_DATA_WIDTH,
                                     int number_bits);
        bit [MEM_DATA_WIDTH-1:0] mask;
        dbb_bus_ext tr_bus;
        `CAST_DBB_EXT(,tr,bus);
    
        // Shift data left if this happens to be an unaligned beat.
        //shift_lane_data = get_data_for_beat(tr,beatnum) << 8*misalignment_offset(tr, beatnum);
        get_bit_data_for_beat(tr, beatnum, shift_lane_data);
        `uvm_info("DBB_HELPER_EXT/SHIFT_LANE_DATA", $psprintf("busdata:%#0x .. size:%#0x", shift_lane_data, tr_bus.get_size()), UVM_DEBUG)
        shift_lane_data <<= 8*misalignment_offset(tr, beatnum);
        `uvm_info("DBB_HELPER_EXT/SHIFT_LANE_DATA", $psprintf("busdata:%#0x .. size:%#0x .. beatnum:%0d .. misalignment_offset:%0d", shift_lane_data, tr_bus.get_size(), beatnum, misalignment_offset(tr, beatnum)), UVM_DEBUG)
        // Calculate data mask
        mask = (1 << number_bits) - 1;
        `uvm_info("DBB_HELPER_EXT/SHIFT_LANE_DATA", $psprintf("mask:%#0x", mask), UVM_DEBUG)
        // Mask only the valid bits before driving onto bus, just to make sure
        // we don't try to drive too large of a data value.
        shift_lane_data &= mask;
        // Now shift into proper byte lane
        shift_lane_data <<= (byte_lane(tr,beatnum,dbus_width,number_bits) * number_bits);
        `uvm_info("DBB_HELPER_EXT/SHIFT_LANE_DATA", $psprintf("busdata:%#0x .. bits:%0d", shift_lane_data, number_bits), UVM_DEBUG)
    
    endfunction: shift_lane_data
    
    //----------------------------------------------------------------------
    /// This function returns the value that should be driven onto the wstrb
    /// bus for a particular beat, shifted into its proper byte lane.
    /// The value stored in the transaction is masked first, to prevent too
    /// many bits from being driven.
    function bit [MEM_WSTRB_WIDTH-1:0] shift_lane_wstrb(uvm_tlm_gp tr,
                                                                        int beatnum,
                                                                        int dbus_width = MEM_DATA_WIDTH,
                                                                        int number_bits);
        bit [MEM_WSTRB_WIDTH-1:0] mask;
    
        // Shift left for unaligned beat.
        //shift_lane_wstrb = get_wstrb_for_beat(tr,beatnum) << misalignment_offset(tr, beatnum);
        get_bit_wstrb_for_beat(tr, beatnum, shift_lane_wstrb);
        shift_lane_wstrb <<= misalignment_offset(tr, beatnum);
        // Calculate data mask
        mask = (1 << (number_bits/8)) - 1;
        // Mask off only the valid bits
        shift_lane_wstrb &= mask;
        // Now shift them into proper byte lane
        shift_lane_wstrb <<= (byte_lane(tr,beatnum,dbus_width,number_bits) * (number_bits/8));
    
    endfunction: shift_lane_wstrb
    
    //----------------------------------------------------------------------
    /// Calculates which byte lane a particular beat needs to be driven on.
    /// This depends on the data bus width, which will determine how many
    /// total byte lanes there are.
    function int byte_lane(uvm_tlm_gp tr, int beatnum, int dbus_width = MEM_DATA_WIDTH, int number_bits);
        int numlanes;
        dbb_helper_ext tr_helper;
        `CAST_DBB_EXT(,tr,helper);
        numlanes = dbus_width/number_bits;
        // Rightshift by number of bytes in a beat
        byte_lane = (tr_helper.beat_address(tr, beatnum) >> $clog2(number_bits/8)) & (numlanes-1);
    endfunction: byte_lane
    
    //----------------------------------------------------------------------
    /// Returns the number of bytes out of alignment a particular address is. Misalignment only
    /// affects the first beat of INCR or WRAP bursts.
    function int misalignment_offset(uvm_tlm_gp tr, int beatnum);
        dbb_helper_ext tr_helper;
        `CAST_DBB_EXT(,tr,helper);
        if (beatnum == 0)
          return (tr.get_address() - tr_helper.aligned_address(tr));
        else
          return (0);
    endfunction: misalignment_offset
    
    function void get_bit_data_for_beat(uvm_tlm_gp tr, int beatnum, ref bit [MEM_DATA_WIDTH-1:0] ret_data );
        //uvm_tlm_gp m_data is an array of unsigned bytes. which is not how we originally organized data for multiple beats of axi data. This will treat use n_data, burst length, and size to determine where to slice up the array. Data is organized as first beat data in lowest indexes.
        int i;
        int starting_byte;
        int bytes_per_beat;
        byte unsigned original_data [];
        dbb_bus_ext tr_bus;
        `CAST_DBB_EXT(,tr,bus)
        bytes_per_beat = tr_bus.get_size();
        if (MEM_DATA_WIDTH < 8*bytes_per_beat) begin
            `uvm_fatal("DBB_HELPER_EXT", $psprintf("Data width not sized correctly. %0d needs to be larger than $d", MEM_DATA_WIDTH, 8*bytes_per_beat))
        end
        starting_byte = beatnum * bytes_per_beat;
        tr.get_data(original_data);
        `uvm_info("DBB_HELPER_EXT/GET_BIT_DATA_FOR_BEAT", $psprintf("starting_byte:%0d, bytes_per_beat:%0d, beatnum:%0d",starting_byte, bytes_per_beat, beatnum), UVM_DEBUG)
        for (i=0; i<bytes_per_beat; i++) begin
          `uvm_info("DBB_HELPER_EXT/GET_BIT_DATA_FOR_BEAT", $psprintf("ret_data:%#0x, original_data:%#0x",ret_data[i*8+:8], original_data[starting_byte+i]), UVM_DEBUG)
          ret_data[i*8+:8] = original_data[starting_byte+i];
        end
    endfunction : get_bit_data_for_beat
    function void get_bit_wstrb_for_beat(uvm_tlm_gp tr, int beatnum, ref bit [MEM_WSTRB_WIDTH-1:0] ret_wstrb);
        int i;
        int starting_byte;
        int bytes_per_beat;
        byte unsigned original_wstrb [];
        dbb_bus_ext tr_bus;
        `CAST_DBB_EXT(,tr,bus)
        bytes_per_beat = tr_bus.get_size();
        if (MEM_WSTRB_WIDTH < bytes_per_beat) begin
            `uvm_fatal("DBB_HELPER_EXT", $psprintf("Data width not sized correctly. %0d needs to be larger than $d", MEM_DATA_WIDTH, bytes_per_beat))
        end
        starting_byte = beatnum * bytes_per_beat;
        tr.get_byte_enable(original_wstrb);
        for (i=0; i<bytes_per_beat; i++) begin
          ret_wstrb[i*8+:8] = original_wstrb[starting_byte+i];
        end
    endfunction : get_bit_wstrb_for_beat

endclass: dbb_logger

`endif
  
