// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_HLS_shiftrightss.v

module NV_NVDLA_HLS_shiftrightss (
   data_in
  ,shift_num
  ,data_out
  );

parameter  IN_WIDTH  = 49;
parameter  OUT_WIDTH = 32;
parameter  SHIFT_WIDTH = 6;
parameter  SHIFT_MAX   = 1<<(SHIFT_WIDTH-1);
parameter  HIGH_WIDTH  = SHIFT_MAX+IN_WIDTH-OUT_WIDTH;


input   [IN_WIDTH-1:0]    data_in;              //signed 
input   [SHIFT_WIDTH-1:0] shift_num;            //signed
output  [OUT_WIDTH-1:0]   data_out;

wire    [OUT_WIDTH-1:0]   data_shift_l;
wire    [HIGH_WIDTH-1:0]  data_high;
wire    [IN_WIDTH-1:0]    data_highr;
wire    [IN_WIDTH-1:0]    data_shift_rt;
wire    [IN_WIDTH-1:0]    data_shift_r;
wire    [IN_WIDTH-2:0]    stick;
wire    [OUT_WIDTH-1:0]   data_max;
wire    [OUT_WIDTH-1:0]   data_round;
wire                      shift_sign;
wire                      data_sign;
wire                      guide;
wire                      point5;
wire                      mon_round_c;
wire                      left_shift_sat;
wire                      right_shift_sat;

wire [5:0] shift_num_abs;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

assign  data_sign  = data_in[IN_WIDTH-1];
assign  shift_sign = shift_num[SHIFT_WIDTH-1];

//shift left
assign  shift_num_abs[SHIFT_WIDTH-1:0] = ~shift_num[SHIFT_WIDTH-1:0] + 1;

assign {data_high[((HIGH_WIDTH) - 1):0],data_shift_l[((OUT_WIDTH) - 1):0]} = {{SHIFT_MAX{data_sign}},data_in} << shift_num_abs[((SHIFT_WIDTH) - 1):0];

assign left_shift_sat = shift_sign & {data_high,data_shift_l[OUT_WIDTH-1]} != {(HIGH_WIDTH+1){data_sign}};

//shift right
assign {data_highr[((IN_WIDTH) - 1):0],data_shift_rt[((IN_WIDTH) - 1):0], guide, stick[((IN_WIDTH-1) - 1):0]} = {{IN_WIDTH{data_sign}},data_in,{IN_WIDTH{1'b0}}} >> shift_num[((SHIFT_WIDTH) - 1):0];
//assign {data_shift_rt[::range(IN_WIDTH)], guide, stick[::range(IN_WIDTH-1)]} = ($signed({data_in,{IN_WIDTH{1'b0}}}) >>> shift_num[::range(SHIFT_WIDTH)]);

assign  data_shift_r[((IN_WIDTH) - 1):0] = shift_num >= IN_WIDTH ? {IN_WIDTH{1'b0}} : data_shift_rt[((IN_WIDTH) - 1):0];

assign point5 =  shift_num >= IN_WIDTH ? 1'b0 :  guide & (~data_sign | (|stick));

assign {mon_round_c,data_round[((OUT_WIDTH) - 1):0]} = data_shift_r[((OUT_WIDTH) - 1):0] + point5;

assign right_shift_sat = !shift_sign &
                        (( data_sign & ~(&data_shift_r[IN_WIDTH-2:OUT_WIDTH-1])) |
                         (~data_sign &  (|data_shift_r[IN_WIDTH-2:OUT_WIDTH-1])) |
                         (~data_sign & (&{data_shift_r[((OUT_WIDTH-1) - 1):0], point5})));

assign data_max = data_sign ? {1'b1, {(OUT_WIDTH-1){1'b0}}} : ~{1'b1, {(OUT_WIDTH-1){1'b0}}};

assign data_out = (left_shift_sat | right_shift_sat) ? data_max : shift_sign ? data_shift_l : data_round;

endmodule // NV_NVDLA_HLS_shiftrightss


