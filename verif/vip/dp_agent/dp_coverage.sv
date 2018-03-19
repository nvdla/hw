`ifndef _DP_COVERAGE_SV_
`define _DP_COVERAGE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: dp_coverage
//
//-------------------------------------------------------------------------------------


class dp_coverage#(int DW = 1, int DS = 1); 

    dp_txn#(DW,DS) txn;

    ///Define a covergroup
    covergroup dp_cg;
        //dummy_cp:         coverpoint txn.mst_dummy;
    endgroup

   ///Create the covergroup and the transaction in the class constructor
   function new();
      dp_cg = new;
      txn    = new;
   endfunction: new

   ///This function collects coverage from the transaction received
   function void sample(dp_txn#(DW,DS) t);
      txn = t;
      dp_cg.sample();
   endfunction: sample
   
endclass: dp_coverage


/// This is a callback class which extends from the monitor callback class
/// and overrides the post_trans function such that it can call the sample()
/// of the coverage collector class
//class dp_cov_cb#(int DW,int DS) extends dp_monitor_callbacks;
//
//    dp_coverage cov_obj = new();
//
//    `uvm_object_utils(dp_cov_cb);
//
//    function new(string name = "dp_cov_cb");
//        super.new(name);
//    endfunction:new
//
//    virtual task post_trans(dp_monitor xactor, dp_txn tr);
//        cov_obj.sample(tr);
//    endtask: post_trans
//
//endclass: dp_cov_cb

//typedef uvm_callbacks #(dp_monitor, dp_cov_cb) dp_cov_cb;

`endif // _DP_COVERAGE_SV_

