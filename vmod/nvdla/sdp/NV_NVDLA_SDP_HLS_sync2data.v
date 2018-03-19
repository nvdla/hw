// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_HLS_sync2data.v

module NV_NVDLA_SDP_HLS_sync2data (
   chn1_en
  ,chn1_in_pvld
  ,chn2_en
  ,chn2_in_pvld
  ,chn_out_prdy
  ,data1_in
  ,data2_in
  ,chn1_in_prdy
  ,chn2_in_prdy
  ,chn_out_pvld
  ,data1_out
  ,data2_out
  );

parameter  DATA1_WIDTH = 32; 
parameter  DATA2_WIDTH = 32; 


input        chn1_en;
input        chn2_en;
input        chn1_in_pvld;
output       chn1_in_prdy;
input        chn2_in_pvld;
output       chn2_in_prdy;
output       chn_out_pvld;
input        chn_out_prdy;
input  [DATA1_WIDTH-1:0] data1_in;
input  [DATA2_WIDTH-1:0] data2_in;
output [DATA1_WIDTH-1:0] data1_out;
output [DATA2_WIDTH-1:0] data2_out;



// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
assign  chn_out_pvld = chn1_en & chn2_en ? chn1_in_pvld & chn2_in_pvld : chn2_en ? chn2_in_pvld : chn1_en ? chn1_in_pvld : 1'b0;
assign  chn1_in_prdy = chn1_en & chn2_en ? chn_out_prdy & chn2_in_pvld : chn2_en ? 1'b1 : chn_out_prdy ;
assign  chn2_in_prdy = chn1_en & chn2_en ? chn_out_prdy & chn1_in_pvld : chn2_en ? chn_out_prdy : 1'b1 ;

assign  data1_out[DATA1_WIDTH-1:0] = chn1_en ? data1_in[DATA1_WIDTH-1:0] : {DATA1_WIDTH{1'b0}};
assign  data2_out[DATA2_WIDTH-1:0] = chn2_en ? data2_in[DATA2_WIDTH-1:0] : {DATA2_WIDTH{1'b0}};


endmodule // NV_NVDLA_SDP_HLS_sync2data


