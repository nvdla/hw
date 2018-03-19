// ---------------------------------------------------------
// CLASS: credit_txn
// a) used to backpressure cmod txn sending to sb  
// ---------------------------------------------------------
// typedef struct packed{
//     int unsigned txn_id;
//     int unsigned is_read;
//     int unsigned is_req;
//     int unsigned is_gated;
// } gating_control;

typedef struct packed{
    int txn_id;
    int not_write;
    int is_req;
    int credit;
    int sub_id; // Only used for cdma_wt: 0:weight data; 1:wmb data; 2:wgs_data;
} credit_structure;

class credit_txn extends uvm_sequence_item;
    int txn_id  = -1;  
    int not_write = -1; // 0-write, 1-read
    int is_req  = -1; // 1-req, 0-respon
    int credit  =  0;  // indicate fifo.used - 1 in sb
    int sub_id  = -1; // Only used for cdma_wt: 0:weight data; 1:wmb data; 2:wgs_data;

    `uvm_object_utils_begin(credit_txn)
        `uvm_field_int(txn_id,  UVM_ALL_ON)
        `uvm_field_int(not_write, UVM_ALL_ON)
        `uvm_field_int(is_req,  UVM_ALL_ON)
        `uvm_field_int(credit,  UVM_ALL_ON)
        `uvm_field_int(sub_id,  UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "credit_txn");
        super.new(name);
    endfunction : new
endclass : credit_txn

