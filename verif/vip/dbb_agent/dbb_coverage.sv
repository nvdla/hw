`ifndef dbb_coverage__SV
`define dbb_coverage__SV

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
//                  class dbb_coverage
//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/// class which describes covergroups and collects coverage
class dbb_coverage extends uvm_subscriber#(uvm_tlm_gp);   

    uvm_tlm_gp txn;
    dbb_bus_ext txn_bus;
    dbb_ctrl_ext txn_ctrl;
    dbb_mon_ext txn_mon;
    dbb_helper_ext txn_helper;
    bit enable_coverage;

    reg [`DBB_AID_WIDTH-1:0] id_prev;
    bit flag_id_is_same;

    `uvm_component_utils_begin(dbb_coverage)
        `uvm_field_int(enable_coverage, UVM_DEFAULT)
    `uvm_component_utils_end

    ///Define a basic covergroup
    covergroup dbb_basic_cg;
        option.per_instance = 1;
        option.name = {get_full_name(),".dbb_basic_cg"};

        kind_cp:        coverpoint txn.is_write();
        len_cp:         coverpoint txn_bus.get_length() {
                                            bins len_bins_0 = {1};
                                            bins len_bins_1 = {[2:4]};
                                            bins len_bins_2 = {[5:8]};
                                            bins len_bins_3 = {[9:16]};
                                            bins len_bins_4 = {[17:32]};
                                            bins len_bins_5 = {[33:64]};
                                            bins len_bins_6 = {[65:128]};
                                            bins len_bins_7 = {[129:255]};
                                            bins len_bins_8 = {256};
                        }
        size_cp:        coverpoint txn_bus.get_size();
        addr_cp:        coverpoint txn.get_address() {
                            bins addr_bins[10] = {[0 : {`DBB_ADDR_WIDTH{1'b1}}] };
                        }
        id_cp:          coverpoint txn_bus.get_id() { option.auto_bin_max = 3; }
        resp_cp:        coverpoint txn_ctrl.resp[0];
        wstrb_cp:       coverpoint txn.m_byte_enable[0] {
                            bins wstrb_bins_all0  = {0};
                            bins wstrb_bins_all1  = {{8{1'b1}}}; //TODO: This needs to be based on physicial size of the bus
                            bins wstrb_bins_other = {[1 : {8{1'b1}}-1]};
                        }
	
        kind_len_cr:       cross kind_cp, len_cp;
        kind_size_cr:      cross kind_cp, size_cp;
        kind_id_cr:        cross kind_cp, id_cp;
        kind_resp_cr:      cross kind_cp, resp_cp;

        kind_addr_cr:      cross kind_cp, addr_cp;
        len_addr_cr:       cross len_cp, addr_cp;
    endgroup

    ///Create the covergroup and the transaction in the class constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        dbb_basic_cg = new;
        txn = new;
        id_prev = {`DBB_AID_WIDTH{1'bx}};
    endfunction: new

    function void build_phase(uvm_phase phase);
        // EXPLICITLY OMITTED.  Do not call super.build_phase.  
        // super.build_phase ( phase );
        uvm_config_int::get(this,"","enable_coverage",enable_coverage);
    endfunction: build_phase

    ///This function collects coverage from the transaction received
    // The write() function is used to sample the data 
    // used to calculate coverage
    function void write(uvm_tlm_gp t);
        if (enable_coverage) begin
            txn = t;
            `CAST_DBB_EXT(,txn,bus)
            `CAST_DBB_EXT(,txn,ctrl)
            `CAST_DBB_EXT(,txn,mon)
            `CAST_DBB_EXT(,txn,helper)
            flag_id_is_same = (id_prev == txn_bus.get_id());
            id_prev = txn_bus.get_id();
            dbb_basic_cg.sample();
        end
    endfunction

    // In the report phase we print the coverage 
    // for demonstration purposed only
    function void report_phase(uvm_phase phase);
        int defined_bins;
        int covered_bins;
        real coverage;
        super.report_phase(phase);

        if (enable_coverage) begin
            coverage = dbb_basic_cg.get_coverage(defined_bins, covered_bins);
            `uvm_info("NVDLA/DBB/COV_RPT",$psprintf("basic coverage = %6.2f%%  (%0d bins covered / %0d bins defined)", coverage, covered_bins, defined_bins), UVM_NONE);
        end

    endfunction

endclass: dbb_coverage

`endif

