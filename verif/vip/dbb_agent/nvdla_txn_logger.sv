`ifndef NVDLA_TXN_LOGGER__SV
`define NVDLA_TXN_LOGGER__SV
/// @class nvdla_txn_logger
/// Overview
/// --------
///   This file implements a NVDLA transaction logger.The transaction
/// logging class will produce well organized transaction log
/// reports to a file, screen, or both. The main features of this class 
/// include:
/// - Automatic report header generation
/// - Automatic file I/O handling
/// - Configurable default column formatting (base, zero padding, truncation,
///   etc.)
/// - Will automatically format column fields that are smaller or wider
///   than the column itself to insure proper alignment. In the case of
///   columns which are too wide, there are several configurable options
///   for how this is done:
///   * Truncating the column at the width of the field, and spanning
///     it over several rows. For example, this would work well for
///     an 8 character wide column that is displaying both 32 and 64
///     bit numbers. The 32 bit numbers would fit in a single row, while
///     the 64 bit numbers would automatically be split into two
///     consecutive rows.
///   * Delimiting text at space (" ") boundaries. This is the default
///     behavior for things such as header labels.
///   * Displaying text vertically (ie One character per row, spanning
///     multiple rows.) This can be useful for displaying things such
///     as burst types or transaction types as a text string in a single
///     column.
/// - Column default formatting can be overridden at any time. This is
///   useful if you use the same column for different purposes, perhaps depending
///   on the transaction type, or transaction phase.
///
/// Usage
/// -----
///   The nvdla_txn_logger class is not intended to be used directly, but rather
/// as a base class for an extended class which implements the transaction
/// logger for a specific type of transaction. The steps to do this are:
///   1. Extend the nvdla_txn_logger class to create a new logger class for
///      your specific transaction type.
///   2. In the configure phase, make a 'register_column' call for each column
///      in the report that you'd like to use, specifying default attributes
///      for each column.
///   3. Implement the virtual function log_txn() to log your transaction data.
///      Within this routine:
///      - Cast the uvm_sequence_item to your specific transaction.
///      - Call set_column_val() or set_column_text() for each column with the data
///        from your transaction object that you'd like to display. format_column_val()
///        and format_column_text() can also be used if you'd like to temporarily
///        override the default column attributes.
///      - Call print_row() to display the transaction in the log.
///   4. Make sure log_txn() is called at the appropriate place in your monitor,
///      scoreboard, etc.//   <Description of file contents>

typedef enum {DEC,HEX,BIN,STRING} num_format_e;
typedef enum {TR_DEFAULT,TR_FLOW,TR_CHOP,TR_GROW} truncate_e;
   
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                  class nvdla_txn_log_item
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

/// Helper class for nvdla_txn_logger.
/// This class manages all of the attributes of a single column within
/// a log report. It is used by the nvdla_txn_logger class, and is not
/// intended to be used directly.
/// See the documentation for nvdla_txn_logger for more information.
class nvdla_txn_log_item;

    string       name;           ///< Name of column, used in header.
    int          width;          ///< The width of the column.
    string       def_char;       ///< Default character for empty column.
    num_format_e num_format;     ///< Column number type (bin, hex, etc.)
    int          padding;        ///< How much '0' padding on left of number.
    truncate_e   truncate;       ///< Specify how to handle strings which are too
                                 ///< long to fit inside the column. Choices are:
                                 ///< - FLOW: Will try to fit into column by delimiting
                                 ///<         spaces. If this still doesn't work, print
                                 ///<         the column vertically (i.e. one character
                                 ///<         per row.) Handy for strings.
                                 ///< - CHOP: Truncates column at the boundary as many
                                 ///<         times as needed. Useful for large numbers.
                                 ///< - GROW: When set, if a column gets data which is too
                                 ///<         wide, the width will automatically be adjusted.
                                 ///<         This is handy for columns containing things such
                                 ///<         as timestamps which get larger as the simulation
                                 ///<         progresses.
    string num_display_format;   ///< Format string for number display.
    string str_display_format;   ///< Format string for string(column) display.
    string col_text[$];          ///< Used to store column text. Can be multiple rows.


    //////////////////////////////////////////////////////////////////////
    /// Creates a new column in the report, and initializes the default print parameters for it.
    function new(string name, int width, num_format_e num_format=HEX, byte def_char="-", int padding=-1);
        this.name       = name;
        this.width      = width;
        this.num_format = num_format;
        this.def_char   = string'( def_char );
        // Default number padding is '1' for decimal format, the column width for everything else
        this.padding    = (padding == -1)?((num_format == DEC)?1:width):padding;
        // Default truncate setting is TR_FLOW for strings, TR_CHOP on for everything else
        this.truncate   = (num_format == STRING)?TR_FLOW:TR_CHOP;
        update_format_strings();
    endfunction: new
    
    //////////////////////////////////////////////////////////////////////
    /// Calculates the number and string formatting strings based on the
    /// current settings for the column. Is called in the new() routine,
    /// and should be called whenever the default format settings change.
    function void update_format_strings();
        case(num_format)
          DEC: num_display_format = $psprintf("%%0%0dd",padding);
          HEX: num_display_format = $psprintf("%%0%0dx",padding);
          BIN: num_display_format = $psprintf("%%0%0db",padding);
          default: num_display_format = $psprintf("%%0%0dd",padding);
        endcase
        str_display_format = $psprintf("%%0%0ds ",width);
    endfunction: update_format_strings
    
    //////////////////////////////////////////////////////////////////////
    /// Adds text to a column for display. This text will be displayed when
    /// a row is printed. This routine can be called multiple times if the
    /// column spans multiple rows when printed. If the text will not fit
    /// into the column, this routine will automatically spread it out over
    /// multiple rows in order for it to fit, either by truncating, dividing
    /// by spaces, or printing single-character vertically, depending on the
    /// settings.
    function void add_col_text(string newtext, truncate_e truncate_type = TR_DEFAULT);
        int endpos;
        int curpos    = 0;
        int start_index;
        int index     = 0;
        int maxlength = 0;

        truncate_type = (truncate_type == TR_DEFAULT)?truncate:truncate_type;
        start_index = col_text.size();
        index       = start_index;

        case (truncate_type)
          TR_GROW: begin
              // If text wider than column, then resize column
              if (newtext.len()>width) configure_width(newtext.len());
              col_text[index] = newtext;
          end
          TR_CHOP: begin
              // Simply truncate the string at the column width, as many times as needed
              endpos = -1;
              do begin
                  // Calculate end of substring. Can't extend past the end of the string.
                  endpos = (endpos+width>=newtext.len())?newtext.len()-1:endpos+width;
                  col_text[index++]=newtext.substr(curpos,endpos);
                  curpos = endpos+1;
              end while (curpos < newtext.len()); // Did we run out of string?
          end
          TR_FLOW: begin
              // Scan through text and separate it by spaces
              for (int i=0; i<newtext.len(); i++) begin
                  if ((newtext[i] == " ") || (i == newtext.len()-1)) begin
                      endpos = (newtext[i] == " ")?i-1:i;
                      col_text[index] = newtext.substr(curpos,endpos);
                      if (col_text[index].len() > maxlength) maxlength = col_text[index].len();
                      curpos = i+1;
                      index++;
                  end
              end
              
              // Column is not wide enough, we're going to have to make the label verticle
              if (maxlength > width) begin
                  index = start_index;
                  for (int i=0; i<newtext.len(); i++)
                    col_text[index++] = string'( newtext[i] );
              end
          end
        endcase
        
    endfunction: add_col_text

    //////////////////////////////////////////////////////////////////////
    // Configuration Access Routines
    //////////////////////////////////////////////////////////////////////
    // function void configure_name
    // function void configure_width
    // function void configure_def_char
    // function void configure_num_format
    // function void configure_padding
    // function void configure_truncate
    /// @name Column Configuration Routines
    /// This set of routines provide a way to modify the default print parameters
    /// once the column has already been created. There are similar routines in
    /// the nvdla_txn_logger class, and normally those would be used rather than
    /// the routines for the individual columns.
    ///@{

    /// Configure column name.
    function void configure_name(string name);
        this.name = name;
    endfunction: configure_name

    /// Configure column width.
    function void configure_width(int width);
        this.width = width;
        update_format_strings();
    endfunction: configure_width

    /// Configure default column display char. Common choices are ' ', '-', or '.'
    function void configure_def_char(byte def_char);
        this.def_char = string'( def_char );
    endfunction:configure_def_char

    /// Configure column number format. (ex: HEX, DEC, STRING);
    function void configure_num_format(num_format_e num_format);
        this.num_format = num_format;
        update_format_strings();
    endfunction: configure_num_format

    /// Configure amount of 'zero' padding for column. This insures things
    /// such as a 32 bit hex address 'h10 to be displayed as 00000010, rather than just 10.
    function void configure_padding(int padding);
        this.padding = padding;
        update_format_strings();
    endfunction: configure_padding

    /// Configure truncate style for column.
    function void configure_truncate(truncate_e truncate);
        this.truncate = truncate;
        if (this.truncate == TR_DEFAULT) // Shouldn't really set it to default like this
          this.truncate   = (num_format == STRING)?TR_FLOW:TR_CHOP;
    endfunction: configure_truncate
    ///@}
endclass: nvdla_txn_log_item


//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                  class nvdla_txn_logger
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

/// The transaction logging base class.
/// Logging classes for specific transaction types should extend this class.
class nvdla_txn_logger extends uvm_component;
    nvdla_txn_log_item columns[$]; ///< Array of column objects.
    string  row_text;              ///< Storage for the current row text
    int fd;                        ///< Logfile descriptor
    int firstprint;                ///< Flag for ensuring the header gets printed only once   
    string temp;                   ///Temporary string to store 1st entry of the logfile

    /// @name Configuration Parameters
    ///@{
    string  logfile;               ///< Logfile name
    bit     log_to_file   = 1;     ///< Flag for logging to file (default is on)
    bit     log_to_screen = 0;     ///< Flag for echo'ing the log information to the screen
    ///@}
    
    `uvm_component_utils_begin(nvdla_txn_logger)
        `uvm_field_int(log_to_file,   UVM_DEFAULT)
        `uvm_field_int(log_to_screen, UVM_DEFAULT)
        `uvm_field_string(logfile,    UVM_DEFAULT)
    `uvm_component_utils_end

    ///////////////////////////////////////////////////////////////////////
    /// Create a new nvdla_txn_logger object.
      function new(string inst          = "nvdla_txn_logger",
                   uvm_component parent = null);
          super.new(inst, parent);
          // Default logfile name is the heirarchical pathname
          logfile = {get_full_name(),".log"};
      endfunction: new

    virtual function void build_phase(uvm_phase phase);
        // EXPLICITLY OMITTED.  Do not call super.build_phase.  
        // super.build_phase ( phase );

        uvm_config_int::get(this,"","log_to_file",log_to_file);
        uvm_config_int::get(this,"","log_to_screen",log_to_screen);
        uvm_config_db#(string)::get(this,"","logfile",logfile);
    endfunction: build_phase


    //////////////////////////////////////////////////////////////////////
    /// Run automatically during the UVM start of simulation phase.
    /// At the start of the simulation the logfile is opened, and a the header
    /// is printed.
    function void start_of_simulation_phase(uvm_phase phase);
    endfunction: start_of_simulation_phase

    //////////////////////////////////////////////////////////////////////
    /// Run automatically during the UVM final phase.
    /// Close the log at the end of the simulation
    function void final_phase(uvm_phase phase);
        if (fd) close_log();
    endfunction: final_phase

    //////////////////////////////////////////////////////////////////////
    /// This function should be called whenever a new transaction should be
    /// logged. This base class has no implementation, it should be extended
    /// and implemented for your specific transaction type.
    virtual function void log_txn(uvm_tlm_gp tr);
    endfunction: log_txn

    //////////////////////////////////////////////////////////////////////
    /// Opens up a logfile for the specified name. append flag will determine
    /// whether any existing files are overwritten or appended to.
    /// Returns true or false depending upon success of file open.
    function bit open_log(bit append=0);
        string ftype;

        ftype = (append)?"a":"w";
        fd = $fopen(logfile, ftype);
        if (!fd) begin
            `uvm_error("NVDLA/TXN_LOGGER/LOG_OPEN",$psprintf("Can't open log file: %s",logfile));
        end

        return(fd == 0);
    endfunction: open_log

    //////////////////////////////////////////////////////////////////////
    /// Closes the logfile.
    function void close_log();
        $fclose(fd);
        fd = 0;
    endfunction: close_log
    
    //////////////////////////////////////////////////////////////////////
    /// Stops logging transactions. Also closes the logfile.
    function void stop_log();
        $fclose(fd);
        fd = 0;
    endfunction: stop_log
    
    //////////////////////////////////////////////////////////////////////
    /// Opens a logfile back up for logging transactions. Assumes that 'open_log' has
    /// been called previously since it reopens the same logfile in 'append' mode.
    function void start_log();
        if (logfile != "") begin
            fd = $fopen(logfile, "a");
            if (!fd) begin
                `uvm_error("NVDLA/TXN_LOGGER/LOG_REOPEN",$psprintf("Error reopening file: %s",logfile));
            end
        end
    endfunction: start_log

    //////////////////////////////////////////////////////////////////////
    /// This routine should be called when configuring each column. Default
    /// display attributes are set here. These can be changed by access functions,
    /// and also temporarily overriden using appropriate routines.
    ///
    /// This function returns the index of the column which you've created. Since
    /// other routines require this index, you'll need to keep track of it.
    function int register_column(string name, int width, num_format_e num_format = DEC, 
                                 byte def_char = "-", int padding = -1);
        nvdla_txn_log_item new_item;
        
        new_item = new(name,width,num_format,def_char,padding);
        columns.push_back(new_item);
        register_column = columns.size()-1; // Return array index of new entry
    endfunction: register_column

    //////////////////////////////////////////////////////////////////////
    /// Prints a report header using the column name as the column header.
    /// This will try to fit the header name inside the column by delimiting
    /// it by spaces. If that doesn't work and it still doesn't fit, it will
    /// print the column name vertically.
    function void print_header();
        string display_format;
        int    total_height = 0;
        int    total_width  = 0;

        // Calculate the total width and height of the header, and generate header text
        foreach(columns[i]) begin
            columns[i].add_col_text(columns[i].name,TR_FLOW);
            total_width += columns[i].width + 1;
            total_height = (columns[i].col_text.size() > total_height)?columns[i].col_text.size():total_height;
        end
        print_horizontal_line(total_width);
        for (int row = 0; row < total_height; row++) begin
            foreach(columns[i]) begin
                if (row < columns[i].col_text.size()) begin
                    display_format = $psprintf("%%0%0ds|",columns[i].width);
                    row_text = {row_text,$sformatf(display_format,columns[i].col_text[row])};
                end
                else begin
                    // Blank entry, print spaces
                    row_text = {row_text,{columns[i].width{" "}},"|"};
                end
            end
            row_text = {row_text,"\n"};
        end
        print_horizontal_line(total_width);
        flush_text();
    endfunction: print_header
    
    //////////////////////////////////////////////////////////////////////
    /// Prints a row of data to the transaction log, based on the data which has
    /// been input. This action will clear out all data after printing. A single
    /// transaction might call this multiple times when displaying transaction
    /// with multiple phases. See nvdla_axi_logger for an example of this.
    function void print_row();
        string display_format;
        int    row_height;
        row_height = get_row_height();
        for (int row = 0; row < row_height; row++) begin
            foreach(columns[i]) begin
                if (row < columns[i].col_text.size()) begin
                    display_format = $psprintf("%%0%0ds ",columns[i].width);
                    row_text = {row_text,$sformatf(display_format,columns[i].col_text[row])};
                end
                else begin
                    row_text = {row_text,{columns[i].width{columns[i].def_char}}," "};
                end
            end
            row_text = {row_text,"\n"};
        end
        flush_text();
    endfunction: print_row

    //////////////////////////////////////////////////////////////////////
    /// Prints a horizontal line in the report. By default this is the full
    /// width of the report and uses the "-" character, but both can be overrridden.
    function void print_horizontal_line(int linewidth = -1,string linechar = "-");
        if (linewidth == -1) begin
            linewidth = 0;
            foreach(columns[i]) linewidth += columns[i].width + 1;
        end
        row_text = {row_text,{linewidth{linechar}},"\n"};
    endfunction: print_horizontal_line
    
    //////////////////////////////////////////////////////////////////////
    /// Prints arbitrary text to the logfile. Does not insert a newline character.
    /// Will be seen at the next print_row() or print_header() command.
    function void print_text(string arbtext);
        row_text = {row_text,arbtext};
    endfunction: print_text
    

    //////////////////////////////////////////////////////////////////////
    /// Called by print_row() and print_header(). This command dumps the current row
    /// to a file and/or screen, then clears the data to be ready for the next row.
    function void flush_text();
        //This function is first called by print_row()
        //But we need to store that row_text as we have not printed header.
        if(!firstprint)begin
            firstprint=1;
            temp=row_text;
            clear_columns();
            if(log_to_file) open_log();
            print_header();
            row_text=temp;
        end
        if (log_to_file)   $fwrite(fd,row_text);
        if (log_to_screen) $write(row_text);
        clear_columns();
    endfunction: flush_text
    
    //////////////////////////////////////////////////////////////////////
    /// Deletes all column data to get ready for next row.
    function void clear_columns();
        foreach(columns[i]) columns[i].col_text.delete(); // Clear out all column values
        row_text = "";                                    // Delete row string
    endfunction: clear_columns
    
    //////////////////////////////////////////////////////////////////////
    /// Sets the value to be printed for a particular column. The format of how
    /// it is displayed will be determined by the column defaults. If you don't
    /// want to use the column defaults, use format_column_val() instead.
    /// Note that this routine is only capabable of displaying numbers up to
    /// 64 bits in length. If you wish to log a number greater than that, you'll
    /// need to convert it to a string first, and use the set_column_text() routine.
    function void set_column_val(int colnum, longint unsigned col_num);
        columns[colnum].add_col_text($psprintf(columns[colnum].num_display_format,col_num));
    endfunction: set_column_val
    
    //////////////////////////////////////////////////////////////////////
    /// Sets the text value to printed for a particular column. The format of how
    /// it is displayed will be determined by the column defaults. If you don't want
    /// to use the defaults use format_column_text() instead.
    function void set_column_text(int colnum, string col_string);
        columns[colnum].add_col_text(col_string);
    endfunction: set_column_text

    //////////////////////////////////////////////////////////////////////
    /// Similar to set_column_val(), this sets the value to be printed
    /// for a particular column and allows you to specifiy the exact
    /// format. This routine is useful if you want to print a value in a
    /// format other than the column defaults. It's not quite as
    /// efficient as set_column_val(), however, since it needs to
    /// calculate the format string.
    ///
    /// Padding defaults to the column width.
    ///
    /// Note that this routine is only capabable of displaying numbers up to
    /// 64 bits in length. If you wish to log a number greater than that, you'll
    /// need to convert it to a string first, and use the set_column_text() routine.
    function void format_column_val(int colnum, longint unsigned dec_num, num_format_e num_format, 
                                    int padding = -1, truncate_e truncate = TR_DEFAULT);
        string display_format;

        padding = (padding == -1)?columns[colnum].width:padding;
        case(num_format)
          DEC: display_format = $psprintf("%%0%0dd",padding);
          HEX: display_format = $psprintf("%%0%0dx",padding);
          BIN: display_format = $psprintf("%%0%0db",padding);
          default: display_format = $psprintf("%%0%0dd",padding);
        endcase
        columns[colnum].add_col_text($psprintf(display_format,dec_num),truncate);
    endfunction: format_column_val
    
    //////////////////////////////////////////////////////////////////////
    /// Set column text with specified format.
    /// Similar to set_column_string(), this sets the value to be printed
    /// for a particular column and allows you to specify the exact
    /// format, rather than using configured defaults.
    ///  
    /// Note that for a string you really only have control over whether or not 
    /// truncating is done.
    function void format_column_string(int colnum, string col_string, truncate_e truncate = TR_DEFAULT);
        columns[colnum].add_col_text(col_string,truncate);
    endfunction: format_column_string

    //////////////////////////////////////////////////////////////////////
    // Column attribute access routines
    //////////////////////////////////////////////////////////////////////
    // function void configure_col_name
    // function void configure_col_width
    // function void configure_col_def_char
    // function void configure_col_num_format
    // function void configure_col_padding
    // function void configure_col_truncate

    /// @name Column Configuration Routines
    /// This set of access routines provides the ability to change the default
    /// print attributes of a column after it is already created. You should
    /// use these routines rather than direct manipulation of the column objects.
    ///@{

    /// Configure specified column name.
    function void configure_col_name(int colnum, string name);
        columns[colnum].configure_name(name);
    endfunction: configure_col_name

    /// Configure specified column width.
    function void configure_col_width(int colnum, int width);
        columns[colnum].configure_width(width);
    endfunction: configure_col_width

    /// Configure default column display char. Common choices are ' ', '-', or '.'
    function void configure_col_def_char(int colnum, byte def_char);
        columns[colnum].configure_def_char(def_char);
    endfunction:configure_col_def_char

    /// Configure specified column number format. (ex: HEX, DEC, STRING);
    function void configure_col_num_format(int colnum, num_format_e num_format);
        columns[colnum].configure_num_format(num_format);
    endfunction: configure_col_num_format

    /// Configure amount of 'zero' padding for specified column. This insures things
    /// such as a 32 bit hex address 'h10 to be displayed as 00000010, rather than just 10.
    function void configure_col_padding(int colnum, int padding);
        columns[colnum].configure_padding(padding);
    endfunction: configure_col_padding

    /// Configure truncate style for specified column.
    function void configure_col_truncate(int colnum, truncate_e truncate);
        columns[colnum].configure_truncate(truncate);
    endfunction: configure_col_truncate
    ///@}
    
    //////////////////////////////////////////////////////////////////////
    /// Helper routine to calculate how many lines high the current row is.
    function int get_row_height();
        get_row_height = 0;
        foreach(columns[i])
          get_row_height = (columns[i].col_text.size() > get_row_height)?
                           columns[i].col_text.size():get_row_height;
    endfunction: get_row_height
    
endclass: nvdla_txn_logger

`endif //  `ifndef NVDLA_TXN_LOGGER__SV

