`ifndef _DMA_COVERAGE_SV_
`define _DMA_COVERAGE_SV_


//-------------------------------------------------------------------------------------
//
// CLASS: dma_coverage
//
//-------------------------------------------------------------------------------------

class dma_coverage; 

    dma_txn txn;

    // Define a covergroup
    covergroup dma_cg;
    endgroup

   // Create the covergroup and the transaction in the class constructor
   function new();
      dma_cg = new;
      txn    = new;
   endfunction: new

   // This function collects coverage from the transaction received
   function void sample(dma_txn t);
      txn = t;
      dma_cg.sample();
   endfunction: sample
   
endclass: dma_coverage


//-------------------------------------------------------------------------------------
//
// CLASS: dma_cov_cb
//
// This is a callback class which extends from the monitor callback class
// and overrides the post_trans function such that it can call the sample()
// of the coverage collector class
//-------------------------------------------------------------------------------------
class dma_cov_cb extends dma_monitor_callbacks;

    dma_coverage cov_obj = new();

    `uvm_object_utils(dma_cov_cb);

    function new(string name = "dma_cov_cb");
        super.new(name);
    endfunction:new

    virtual task post_trans(dma_monitor xactor, dma_txn tr);
        cov_obj.sample(tr);
    endtask: post_trans

endclass: dma_cov_cb

typedef uvm_callbacks #(dma_monitor, dma_cov_cb) dma_cov_cbs;


`endif // _DMA_COVERAGE_SV_
