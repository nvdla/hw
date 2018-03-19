// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_HLS_shiftrightsatsu.v

module NV_NVDLA_HLS_shiftrightsatsu (
   data_in
  ,shift_num
  ,data_out
  ,sat_out
  );

parameter  IN_WIDTH  = 49;
parameter  OUT_WIDTH = 32;
parameter  SHIFT_WIDTH   = 6;


input   [IN_WIDTH-1:0]    data_in;
input   [SHIFT_WIDTH-1:0] shift_num;
output  [OUT_WIDTH-1:0]   data_out;
output                    sat_out;

wire    [IN_WIDTH-1:0]    data_high;
wire    [IN_WIDTH-1:0]    data_shift;
wire    [IN_WIDTH-2:0]    stick;
wire    [OUT_WIDTH-1:0]   data_max;
wire    [OUT_WIDTH-1:0]   data_round;
wire                      data_sign;
wire                      guide;
wire                      point5;
wire                      mon_round_c;
wire                      tru_need_sat;


// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

assign  data_sign = data_in[IN_WIDTH-1];

assign {data_high[((IN_WIDTH) - 1):0], data_shift[((IN_WIDTH) - 1):0], guide, stick[((IN_WIDTH-1) - 1):0]} = {{IN_WIDTH{data_sign}},data_in,{IN_WIDTH{1'b0}}} >> shift_num[((SHIFT_WIDTH) - 1):0];
//assign {data_shift[::range(IN_WIDTH)], guide, stick[::range(IN_WIDTH-1)]} = ($signed({data_in,{IN_WIDTH{1'b0}}}) >>> shift_num[::range(SHIFT_WIDTH)]);

assign point5 = guide & (~data_sign | (|stick));

assign {mon_round_c,data_round[((OUT_WIDTH) - 1):0]} = data_shift[((OUT_WIDTH) - 1):0] + point5;

assign tru_need_sat = ( data_sign & ~(&data_shift[IN_WIDTH-2:OUT_WIDTH-1])) |
                      (~data_sign &  (|data_shift[IN_WIDTH-2:OUT_WIDTH-1])) |
                      (~data_sign & (&{data_shift[((OUT_WIDTH-1) - 1):0], point5}));

assign data_max = data_sign ? {1'b1, {(OUT_WIDTH-1){1'b0}}} : ~{1'b1, {(OUT_WIDTH-1){1'b0}}};

assign data_out = (shift_num >= IN_WIDTH) ? {(OUT_WIDTH){1'b0}} :  tru_need_sat ? data_max : data_round;

assign sat_out  = (shift_num >= IN_WIDTH) ? 1'b0:  tru_need_sat;

endmodule // NV_NVDLA_HLS_shiftrightsatsu


