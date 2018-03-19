`ifndef NVDLA_DBB_SEQ_LIB__SV
`define NVDLA_DBB_SEQ_LIB__SV
/// This file contains an assortment of extended transaction objects,
/// sequence objects and transaction libraries for the nvdla DBB VIP.
///
/// These classes can be further customized through the use of UVM factory
/// overrides of the default transaction types, as well as extended overrides
/// of constraints.
///
/// This file consists of six sections as follows:
///
/// NVDLA DBB SLAVE
/// ---------------
///   - Slave Sequence Libraries
///   - Slave Transaction Types
///   - Slave Sequences
///
///
///  DBB Slave
///  =========
///
///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
///  Slave Sequence Lib          | Included Sequences          | Comments
///  -----------------------------------------------------------------------------------------------------------------
///  dbb_slv_seq_lib       | dbb_slv_basic_seq           | Mixture of all transaction types and timing
///                              | dbb_slv_no_delay_all_seq    |
///                              | dbb_slv_resp_err_seq        |
///                              | dbb_slv_sparse_seq          |
///  -----------------------------------------------------------------------------------------------------------------
///  dbb_slv_basic_seq_lib | dbb_slv_basic_seq           | Only basic transaction types
///                              | dbb_slv_no_delay_seq        | data
///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
///
///
///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
///  Slave Transaction        | Extended From            | Comments
///  -----------------------------------------------------------------------------------------------------------------
///  dbb_slv_base_txn         | uvm_tlm_gp      | Timing tightened somewhat from 'reasonable' constraints.
///                           |                          | Basic txn types only
///                           |                          | responses.
///  dbb_slv_no_delay         | uvm_tlm_gp      | All delays are set to minimum values. Good for stressing the
///                           |                          | system, or when tb simulation efficiency is required. Only
///                           |                          | basic types, no interleaving
///  dbb_slv_no_delay_all     | dbb_slv_no_delay         | Minimum delays
///  dbb_slv_resp_err         | dbb_slv_base_txn              | Reponses will include error responses.
///  dbb_slv_sparse           | dbb_slv_base_txn         | Add big delay between subsequent transactions    
//                            |                          |
///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
///
///
///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
///  Slave Sequence              | Default Txn Type        | Comments
///  -----------------------------------------------------------------------------------------------------------------
///  dbb_slv_basic_seq           | dbb_slv_base_txn        | Only basic transactions, no read data interleaving or
///  dbb_slv_no_delay_seq        | dbb_slv_no_delay        | Basic transaction, no read data interleaving with minimum timing parameters.
///  dbb_slv_no_delay_all_seq    | dbb_slv_no_delay_all    | Minimum timing parameters with read data interleaving and
///  dbb_slv_resp_err_seq        | dbb_slv_resp_err        | All types allowed. Reponses can include error responses.
///            
///  dbb_slv_sparse_seq          | dbb_slv_sparse          |
///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//     DBB Slave Sequence Libraries
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
/// nvdla DBB sequence library (slave).
/// Mixture of all transaction types and timing including read data
/// interleaving. Also includes error responses.
class dbb_slv_seq_lib extends uvm_sequence_library #(uvm_tlm_gp);
//--------------------------------------------------------------------------------
    `uvm_object_utils(dbb_slv_seq_lib)
    `uvm_sequence_library_utils(dbb_slv_seq_lib)

    function new(string name = "dbb_slv_seq_lib");
        super.new(name);
        init_sequence_library();
    endfunction

endclass: dbb_slv_seq_lib

//--------------------------------------------------------------------------------
/// nvdla DBB sequence library (slave).
/// Only basic transaction types
class dbb_slv_basic_seq_lib extends uvm_sequence_library #(uvm_tlm_gp);
//--------------------------------------------------------------------------------
    `uvm_object_utils(dbb_slv_basic_seq_lib)
    `uvm_sequence_library_utils(dbb_slv_basic_seq_lib)

    function new(string name = "dbb_slv_basic_seq_lib");
        super.new(name);
        init_sequence_library();
    endfunction

endclass: dbb_slv_basic_seq_lib

//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//     DBB Slave Transactions
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
/// nvdla DBB sequence library transaction.
/// Timing tightened somewhat from 'reasonable' constraints.
/// Basic txn types only, no interleaving
class dbb_slv_base_txn extends uvm_tlm_gp;
//--------------------------------------------------------------------------------
    `uvm_object_utils(dbb_slv_base_txn);

    function new (string name = "dbb_slv_base_txn");
        super.new(name);
        
    endfunction

    // Address Channel
    constraint c_avalid_aready_delay {avalid_aready_delay inside {[0:5]}; }
    constraint c_aready_delay        {aready_delay inside {[0:3]};}

    // Write Data Channel
    constraint c_wready_delay        {foreach(wready_delay[idx]) {
                                         wready_delay[idx] inside {[0:5]};}}
    constraint c_wvalid_wready_delay {foreach(wvalid_wready_delay[idx]) {
                                         wvalid_wready_delay[idx] inside {[0:5]};}}

    // Read Data Channel
    constraint c_address_rvalid_delay {address_rvalid_delay inside {[0:5]};}
    constraint c_next_rvalid_delay    {foreach(next_rvalid_delay[idx]) {
                                          next_rvalid_delay[idx] inside {[0:5]};}}

    // Response
    constraint reasonable_write_bvalid_delay {write_bvalid_delay inside {[0:5]};}

endclass: dbb_slv_base_txn

//--------------------------------------------------------------------------------
/// nvdla DBB sequence library transaction.
/// All delays are set to minimum values. Good for stressing the system,
/// or when tb simulation efficiency is required. Only basic types, no
/// interleaving
class dbb_slv_no_delay extends uvm_tlm_gp;
//--------------------------------------------------------------------------------
    `uvm_object_utils(dbb_slv_no_delay);

    function new (string name = "dbb_slv_no_delay");
        super.new(name);
    endfunction

    // Address Channel
    constraint c_avalid_aready_delay {avalid_aready_delay == 0; }
    constraint c_aready_delay        {aready_delay == 0;}

    // Write Data Channel
    constraint c_wready_delay        {foreach(wready_delay[idx]) {
                                         wready_delay[idx] == 0;}}
    constraint c_wvalid_wready_delay {foreach(wvalid_wready_delay[idx]) {
                                         wvalid_wready_delay[idx] == 0;}}

    // Read Data Channel
    constraint c_address_rvalid_delay {address_rvalid_delay == 0;}
    constraint c_next_rvalid_delay    {foreach(next_rvalid_delay[idx]) {
                                          next_rvalid_delay[idx] == 0;}}

    // Response
    constraint reasonable_write_bvalid_delay {write_bvalid_delay == 0;}

endclass: dbb_slv_no_delay

//--------------------------------------------------------------------------------
/// nvdla DBB sequence library transaction.
/// Minimum delays
class dbb_slv_no_delay_all extends dbb_slv_no_delay;
//--------------------------------------------------------------------------------
    `uvm_object_utils(dbb_slv_no_delay_all);

    function new (string name = "dbb_slv_no_delay_all");
        super.new(name);
    endfunction

endclass: dbb_slv_no_delay_all

//--------------------------------------------------------------------------------
/// nvdla DBB sequence library transaction.
/// Reponses will include error responses.
class dbb_slv_resp_err extends dbb_slv_base_txn;
//--------------------------------------------------------------------------------
    `uvm_object_utils(dbb_slv_resp_err);

    function new (string name = "dbb_slv_resp_err");
        super.new(name);
    endfunction

    constraint reasonable_status_err        {foreach(status_err[idx]) {
                                                  status_err[idx] dist {NO_FORCE := 8, FORCE_EXOKAY := 0,
                                                                          FORCE_SLVERR := 1, FORCE_DECERR := 1,
                                                                          FORCE_OKAY := 0};}}
endclass: dbb_slv_resp_err

//--------------------------------------------------------------------------------
/// nvdla DBB sequence library transaction.
/// 
class dbb_slv_sparse extends uvm_tlm_gp;
//--------------------------------------------------------------------------------
    `uvm_object_utils(dbb_slv_sparse);

    function new (string name = "dbb_slv_sparse");
       super.new(name);
       reasonable_address_rvalid_delay.constraint_mode(0);
    endfunction

   
    // Read Data Channel
   constraint c_address_rvalid_delay {address_rvalid_delay inside {[100:200]};}
   
endclass: dbb_slv_sparse

//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//     DBB Slave Sequences
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
/// nvdla DBB sequence library sequence.
/// Only basic transactions, no read data interleaving responses.
class dbb_slv_basic_seq extends uvm_sequence #(uvm_tlm_gp);
//--------------------------------------------------------------------------------
    rand int            seqlen;
    int                 curcnt = 0;
    bit                 background_mode = 0;   
    uvm_tlm_gp tr;

    `uvm_object_utils(dbb_slv_basic_seq);
    `uvm_add_to_seq_lib(dbb_slv_basic_seq, dbb_slv_seq_lib)
    `uvm_add_to_seq_lib(dbb_slv_basic_seq, dbb_slv_basic_seq_lib)

    virtual task body();
        forever begin
            if (!background_mode)
              if (curcnt++ == seqlen) break;
            tr = dbb_slv_base_txn::type_id::create("tr",,get_full_name());
            start_item(tr);
            tr.randomize();
            finish_item(tr);
        end
    endtask: body

    constraint c_seqlen {seqlen inside {[1:30]};}    

    function new(string name="dbb_slv_basic_seq");
        super.new(name);
    endfunction

endclass: dbb_slv_basic_seq

//--------------------------------------------------------------------------------
/// nvdla DBB sequence library sequence.
/// Basic transaction, no read data interleaving
/// responses, with minimum timing parameters.
class dbb_slv_no_delay_seq extends uvm_sequence #(uvm_tlm_gp);
//--------------------------------------------------------------------------------
    rand int            seqlen;
    int                 curcnt = 0;
    bit                 background_mode = 0;
    uvm_tlm_gp tr;

    `uvm_object_utils(dbb_slv_no_delay_seq);
    `uvm_add_to_seq_lib(dbb_slv_no_delay_seq, dbb_slv_basic_seq_lib)

    virtual task body();
        forever begin
            if (!background_mode)
              if (curcnt++ == seqlen) break;
            tr = dbb_slv_no_delay::type_id::create("tr",,get_full_name());
            start_item(tr);
            tr.randomize();
            finish_item(tr);
        end
    endtask: body

    constraint c_seqlen {seqlen inside {[1:30]};} 

    function new(string name="dbb_slv_no_delay_seq");
        super.new(name);
    endfunction

endclass: dbb_slv_no_delay_seq

//--------------------------------------------------------------------------------
/// nvdla DBB sequence library sequence.
/// Minimum timing parameters
class dbb_slv_no_delay_all_seq extends uvm_sequence #(uvm_tlm_gp);
//--------------------------------------------------------------------------------
    rand int            seqlen;
    int                 curcnt = 0;
    bit                 background_mode = 0;
    uvm_tlm_gp tr;

    `uvm_object_utils(dbb_slv_no_delay_all_seq);
    `uvm_add_to_seq_lib(dbb_slv_no_delay_all_seq, dbb_slv_seq_lib)

    virtual task body();
        forever begin
            if (!background_mode)
              if (curcnt++ == seqlen) break;
            tr = dbb_slv_no_delay_all::type_id::create("tr",,get_full_name());
            start_item(tr);
            tr.randomize();
            finish_item(tr);
        end
    endtask: body

    constraint c_seqlen {seqlen inside {[1:30]};} 

    function new(string name="dbb_slv_no_delay_all_seq");
        super.new(name);
    endfunction

endclass: dbb_slv_no_delay_all_seq

//--------------------------------------------------------------------------------
/// nvdla DBB sequence library sequence.
/// All types allowed. Reponses can include error responses.
class dbb_slv_resp_err_seq extends uvm_sequence #(uvm_tlm_gp);
//--------------------------------------------------------------------------------
    rand int            seqlen;
    int                 curcnt = 0;
    bit                 background_mode = 0;
    uvm_tlm_gp tr;

    `uvm_object_utils(dbb_slv_resp_err_seq);
    `uvm_add_to_seq_lib(dbb_slv_resp_err_seq, dbb_slv_seq_lib)

    virtual task body();
        forever begin
            if (!background_mode)
              if (curcnt++ == seqlen) break;
            tr = dbb_slv_resp_err::type_id::create("tr",,get_full_name());
            start_item(tr);
            tr.randomize();
            finish_item(tr);
        end
    endtask: body

    constraint c_seqlen {seqlen inside {[1:30]};} 

    function new(string name="dbb_slv_resp_errors_seq");
        super.new(name);
    endfunction

endclass: dbb_slv_resp_err_seq

//--------------------------------------------------------------------------------
/// nvdla DBB sequence library sequence.
/// 
/// 
class dbb_slv_sparse_seq extends uvm_sequence #(uvm_tlm_gp);
//--------------------------------------------------------------------------------
    rand int            seqlen;
    int                 curcnt = 0;
    bit                 background_mode = 0;   
    dbb_slv_sparse      tr;

    `uvm_object_utils(dbb_slv_sparse_seq);
   `uvm_add_to_seq_lib(dbb_slv_sparse_seq, dbb_slv_seq_lib)
     
    virtual task body();
        forever begin
            if (!background_mode)
              if (curcnt++ == seqlen) break;
            tr = dbb_slv_sparse::type_id::create("tr",,get_full_name());
            start_item(tr);
            tr.randomize();
            finish_item(tr);
        end
    endtask: body

    constraint c_seqlen {seqlen inside {[1:10]};}    

    function new(string name="dbb_slv_sparse_seq");
        super.new(name);
    endfunction

endclass: dbb_slv_sparse_seq

`endif
