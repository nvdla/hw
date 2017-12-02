// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_reset.v

module NV_NVDLA_reset (
   dla_reset_rstn //|< i
  ,direct_reset_  //|< i
  ,test_mode      //|< i
  ,synced_rstn    //|> o
  ,nvdla_clk      //|< i
  );

//
// NV_NVDLA_reset_ports.v
//

input  dla_reset_rstn;
input  direct_reset_;

input  test_mode;

output  synced_rstn;

input nvdla_clk;




  sync_reset sync_reset_synced_rstn (
     .clk           (nvdla_clk)      //|< i
    ,.inreset_      (dla_reset_rstn) //|< i
    ,.direct_reset_ (direct_reset_)  //|< i
    ,.test_mode     (test_mode)      //|< i
    ,.outreset_     (synced_rstn)    //|> o
    );
//&Instance sync3d_reset u_vi_sync_reset;
//    &Connect inreset_      dla_reset_rstn;
//    &Connect test_mode     test_mode;
//    &Connect direct_reset_ direct_reset_;
//    &Connect clk           nvdla_clk;
//    &Connect outreset_     synced_rstn;

endmodule // NV_NVDLA_reset


