// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_core_reset.v

module NV_NVDLA_core_reset (
   dla_reset_rstn  //|< i
  ,direct_reset_   //|< i
  ,test_mode       //|< i
  ,synced_rstn     //|> o
  ,core_reset_rstn //|< i
  ,nvdla_clk       //|< i
  );

//
// NV_NVDLA_reset_ports.v
//

input  dla_reset_rstn;
input  direct_reset_;

input  test_mode;

output  synced_rstn;

input core_reset_rstn;
input nvdla_clk;

wire  synced_core_rstn;
wire  synced_dla_rstn;
reg   combined_rstn;


  sync_reset sync_reset_synced_dla_rstn (
     .clk           (nvdla_clk)        //|< i
    ,.inreset_      (dla_reset_rstn)   //|< i
    ,.direct_reset_ (direct_reset_)    //|< i
    ,.test_mode     (test_mode)        //|< i
    ,.outreset_     (synced_dla_rstn)  //|> w
    );
//&Instance sync3d_reset u_car_rstn_sync;
//    &Connect inreset_      dla_reset_rstn;
//    &Connect test_mode     test_mode;
//    &Connect direct_reset_ direct_reset_;
//    &Connect clk           nvdla_clk;
//    &Connect outreset_     synced_dla_rstn;


  sync_reset sync_reset_synced_core_rstn (
     .clk           (nvdla_clk)        //|< i
    ,.inreset_      (core_reset_rstn)  //|< i
    ,.direct_reset_ (direct_reset_)    //|< i
    ,.test_mode     (test_mode)        //|< i
    ,.outreset_     (synced_core_rstn) //|> w
    );
//&Instance sync3d_reset u_falcon_rstn_sync;
//    &Connect inreset_      core_reset_rstn;
//    &Connect test_mode     test_mode;
//    &Connect direct_reset_ direct_reset_;
//    &Connect clk           nvdla_clk;
//    &Connect outreset_     synced_core_rstn;

//assign combined_rstn = synced_dla_rstn & synced_core_rstn;
always @(posedge nvdla_clk or negedge synced_dla_rstn) begin
  if (!synced_dla_rstn) begin
    combined_rstn <= 1'b0;
  end else begin
  combined_rstn <= synced_dla_rstn & synced_core_rstn;
  end
end


  sync_reset sync_reset_synced_rstn (
     .clk           (nvdla_clk)        //|< i
    ,.inreset_      (combined_rstn)    //|< r
    ,.direct_reset_ (direct_reset_)    //|< i
    ,.test_mode     (test_mode)        //|< i
    ,.outreset_     (synced_rstn)      //|> o
    );
//    &Connect inreset_      combined_rstn;
//    &Connect test_mode     test_mode;
//    &Connect direct_reset_ direct_reset_;
//    &Connect clk           nvdla_clk;
//    &Connect outreset_     synced_rstn;

endmodule // NV_NVDLA_core_reset


