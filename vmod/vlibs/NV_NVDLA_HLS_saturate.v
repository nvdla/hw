// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_HLS_saturate.v

module NV_NVDLA_HLS_saturate (
   data_in
  ,data_out
  );

parameter  IN_WIDTH  = 49;
parameter  OUT_WIDTH = 32;


input  [IN_WIDTH-1:0]  data_in;
output [OUT_WIDTH-1:0] data_out;

wire   [OUT_WIDTH-1:0] data_max;
wire                   data_sign;
wire                   tru_need_sat;


// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
assign  data_sign = data_in[IN_WIDTH-1];

assign  tru_need_sat = ( data_sign & ~(&data_in[IN_WIDTH-2:OUT_WIDTH-1])) |
                       (~data_sign &  (|data_in[IN_WIDTH-2:OUT_WIDTH-1]));

assign  data_max = data_sign ? {1'b1, {(OUT_WIDTH-1){1'b0}}} : ~{1'b1, {(OUT_WIDTH-1){1'b0}}};

assign  data_out = tru_need_sat ? data_max : data_in[((OUT_WIDTH) - 1):0];

endmodule // NV_NVDLA_HLS_saturate


