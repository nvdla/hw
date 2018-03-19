`ifndef _CC_COVERAGE_SV_
`define _CC_COVERAGE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: cc_coverage
//
//-------------------------------------------------------------------------------------


class cc_coverage#(int DW, int MW); 

    cc_txn#(DW,MW) txn;

    ///Define a covergroup
    covergroup cc_cg;
        //dummy_cp:         coverpoint txn.mst_dummy;
    endgroup

   ///Create the covergroup and the transaction in the class constructor
   function new();
      cc_cg =  new;
      txn    = new;
   endfunction: new

   ///This function collects coverage from the transaction received
   function void sample(cc_txn#(DW,MW) t);
      txn = t;
      cc_cg.sample();
   endfunction: sample
   
endclass: cc_coverage


/// This is a callback class which extends from the monitor callback class
/// and overrides the post_trans function such that it can call the sample()
/// of the coverage collector class
class cc_cov_cb#(int DW, int MW) extends cc_monitor_callbacks;

    cc_coverage cov_obj = new();

    `uvm_object_utils(cc_cov_cb);

    function new(string name = "cc_cov_cb");
        super.new(name);
    endfunction:new

    virtual task post_trans(cc_monitor xactor, cc_txn tr);
        cov_obj.sample(tr);
    endtask: post_trans

endclass: cc_cov_cb

//typedef uvm_callbacks #(cc_monitor, cc_cov_cb) cc_cov_cb;
// uvm doesn't support parameterized callback

`endif // _CC_COVERAGE_SV_

