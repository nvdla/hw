// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_HLS_shiftleftsu.v

module NV_NVDLA_HLS_shiftleftsu (
   data_in
  ,shift_num
  ,data_out
  );

parameter  IN_WIDTH  = 16;
parameter  OUT_WIDTH = 32;
parameter  SHIFT_WIDTH = 6;
parameter  SHIFT_MAX   = (1<<SHIFT_WIDTH)-1;
parameter  HIGH_WIDTH  = SHIFT_MAX+IN_WIDTH-OUT_WIDTH;


input   [IN_WIDTH-1:0]    data_in;
input   [SHIFT_WIDTH-1:0] shift_num;
output  [OUT_WIDTH-1:0]   data_out;

wire    [HIGH_WIDTH-1:0]  data_high;
wire    [OUT_WIDTH-1:0]   data_shift;
wire    [OUT_WIDTH-1:0]   data_max;
wire                      data_sign;
wire                      left_shift_sat;


// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
assign  data_sign = data_in[IN_WIDTH-1];

assign {data_high[((HIGH_WIDTH) - 1):0],data_shift[((OUT_WIDTH) - 1):0]} = {{SHIFT_MAX{data_sign}},data_in} << shift_num[((SHIFT_WIDTH) - 1):0];

assign left_shift_sat = {data_high[((HIGH_WIDTH) - 1):0],data_shift[OUT_WIDTH-1]} != {(HIGH_WIDTH+1){data_sign}};

assign data_max = data_sign ? {1'b1, {(OUT_WIDTH-1){1'b0}}} : ~{1'b1, {(OUT_WIDTH-1){1'b0}}};

assign data_out = left_shift_sat ? data_max : data_shift;

endmodule // NV_NVDLA_HLS_shiftleftsu


