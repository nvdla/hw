// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CACC_CALC_fp_48b.v

module NV_NVDLA_CACC_CALC_fp_48b (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,in_data
  ,in_op
  ,in_op_valid
  ,in_sel
  ,in_valid
  ,out_final_data
  ,out_final_valid
  ,out_partial_data
  ,out_partial_valid
  );
input  [43:0] in_data;
input  [47:0] in_op;
input         in_op_valid;
input         in_sel;
input         in_valid;
output [31:0] out_final_data;
output        out_final_valid;
output [47:0] out_partial_data;
output        out_partial_valid;

input nvdla_core_clk;
input nvdla_core_rstn;

reg    [39:0] di_aligned_mant;
reg     [7:0] expo_trans;
reg           final_sel;
reg           final_vld;
reg     [7:0] in_aligned_expo;
reg     [2:0] in_mant_cut;
reg           in_nan_2d;
reg           in_nan_d;
reg    [41:0] mant_sum_trans;
reg           msum_sel;
reg           msum_vld;
reg    [39:0] oi_aligned_mant;
reg    [31:0] out_final_data;
reg           out_final_valid;
reg           out_partial_valid;
reg     [7:0] partial_result_expo;
reg    [39:0] partial_result_mant;
reg           shift_sel;
reg           shift_vld;
wire   [39:0] di_aligned_mant_nxt;
wire    [6:0] di_expm;
wire    [5:0] di_expn;
wire    [7:0] di_expo;
wire    [7:0] di_expo_shift;
wire    [5:0] di_lead_num;
wire   [35:0] di_manm;
wire   [35:0] di_mans;
wire   [35:0] di_mant;
wire    [2:0] di_mant_cut;
wire   [39:0] di_mant_cutt;
wire   [39:0] di_mant_ext;
wire   [37:0] di_mant_pre;
wire   [39:0] di_mant_shift;
wire          di_nan;
wire   [43:0] di_pd;
wire          di_sign;
wire          di_zero;
wire    [7:0] expo_nrml;
wire    [7:0] fp32_expo_nmlz;
wire    [7:0] fp32_expo_raw;
wire    [7:0] fp32_expo_round;
wire          fp32_mant_carry;
wire   [14:0] fp32_mant_cut;
wire   [23:0] fp32_mant_effect;
wire   [22:0] fp32_mant_nmlz;
wire   [24:0] fp32_mant_nmlz_tmp;
wire          fp32_mant_point5;
wire   [24:0] fp32_mant_round;
wire   [31:0] fp32_result;
wire    [2:0] in_mant_cut_nxt;
wire   [47:0] in_mask_op;
wire          in_nan;
wire   [40:0] mant_sum;
wire          mant_sum_carry_neg;
wire          mant_sum_carry_pos;
wire   [44:0] mant_sum_comp;
wire   [39:0] mant_sum_effect;
wire          mant_sum_guard;
wire   [41:0] mant_sum_ncmp;
wire          mant_sum_point5;
wire   [40:0] mant_sum_round;
wire   [44:0] mant_sum_scmp;
wire          mant_sum_sign;
wire          mant_sum_stick;
wire   [43:0] mant_sum_total;
wire    [7:0] max_expo;
wire          mon_di_expo_shift_c;
wire          mon_expo_nrml_c;
wire          mon_fp32_expo_round_c;
wire          mon_oi_expo_shift_c;
wire          mon_partial_expo_nmlz_nc;
wire          mon_partial_expo_nmlz_pc;
wire    [5:0] msum_lead_num;
wire   [39:0] oi_aligned_mant_nxt;
wire    [7:0] oi_expn;
wire    [7:0] oi_expo;
wire    [7:0] oi_expo_shift;
wire   [39:0] oi_mans;
wire   [39:0] oi_mant;
wire    [2:0] oi_mant_cut;
wire   [39:0] oi_mant_cutt;
wire   [39:0] oi_mant_ext;
wire   [39:0] oi_mant_shift;
wire          oi_nan;
wire   [47:0] oi_pd;
wire          oi_sign;
wire          oi_zero;
wire    [7:0] partial_expo;
wire    [7:0] partial_expo_nmlz;
wire    [7:0] partial_expo_nmlz_neg;
wire    [7:0] partial_expo_nmlz_pos;
wire    [7:0] partial_expo_nxt;
wire   [39:0] partial_mant;
wire   [38:0] partial_mant_abs;
wire   [39:0] partial_mant_nmlz;
wire   [40:0] partial_mant_nmlz_tmp;
wire   [39:0] partial_mant_nxt;
wire          partial_mant_zero;
wire          partial_nan;
wire          partial_neg2;
wire   [47:0] partial_result;
wire   [47:0] partial_result_out;
wire          partial_sign;
wire   [38:0] partial_umant;
wire    [9:0] partial_umant_nan;
wire          partial_zero;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

//*****INPUT FORMAT**************************************
// FLOAT: 48bit :  
//IN Data 44 Bit: 6exp, bias30, 18signed int, 20fraction (unnormalize) 
//IN Data 42 Bit: 6exp, bias30, 16signed int, 20fraction (unnormalize) 
//IN OP   48 Bit: 8exp, bias63, 2signed int, 38fraction (normalize)
//IN OP   39 Bit: 7exp, bias63, 2signed int, 30fraction (normalize)
//********************************************************
assign in_mask_op = in_op_valid ? in_op[47:0] : 48'b0;

assign di_pd = in_data[43:0];
assign oi_pd = in_mask_op[47:0];

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    shift_vld <= 1'b0;
  end else begin
  shift_vld <= in_valid;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    msum_vld <= 1'b0;
  end else begin
  msum_vld <= shift_vld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    final_vld <= 1'b0;
  end else begin
  final_vld <= msum_vld;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    shift_sel <= 1'b0;
  end else begin
  shift_sel <= in_valid  & in_sel;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    msum_sel <= 1'b0;
  end else begin
  msum_sel <= shift_vld & shift_sel;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    final_sel <= 1'b0;
  end else begin
  final_sel <= msum_vld  & msum_sel;
  end
end

// split to sign/mantissa
assign di_sign = di_pd[36 +1];
assign di_mant_pre = di_pd[37:0];
assign di_mant = di_pd[35:0];
assign di_expn = di_pd[43:38];
assign di_zero = ~(|di_mant_pre); 
assign di_nan  = &di_expn; 

assign oi_sign = oi_pd[40 -1];
assign oi_mant = oi_pd[39:0];
assign oi_expn = oi_pd[47:40];
assign oi_zero = ~(|oi_mant); 
assign oi_nan  = &oi_expn; 
assign in_nan  = di_nan | oi_nan;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    in_nan_d <= 1'b0;
  end else begin
  in_nan_d <= in_nan;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    in_nan_2d <= 1'b0;
  end else begin
  in_nan_2d <= in_nan_d;
  end
end


//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    reg funcpoint_cover_off;
    initial begin
        if ( $test$plusargs( "cover_off" ) ) begin
            funcpoint_cover_off = 1'b1;
        end else begin
            funcpoint_cover_off = 1'b0;
        end
    end

    property cacc_calc_fp48__in_data_zero__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (di_zero);
    endproperty
    // Cover 0 : "(di_zero)"
    FUNCPOINT_cacc_calc_fp48__in_data_zero__0_COV : cover property (cacc_calc_fp48__in_data_zero__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__in_data_nan__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (di_nan);
    endproperty
    // Cover 1 : "(di_nan)"
    FUNCPOINT_cacc_calc_fp48__in_data_nan__1_COV : cover property (cacc_calc_fp48__in_data_nan__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__in_op_zero__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (oi_zero);
    endproperty
    // Cover 2 : "(oi_zero)"
    FUNCPOINT_cacc_calc_fp48__in_op_zero__2_COV : cover property (cacc_calc_fp48__in_op_zero__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__in_op_nan__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (oi_nan);
    endproperty
    // Cover 3 : "(oi_nan)"
    FUNCPOINT_cacc_calc_fp48__in_op_nan__3_COV : cover property (cacc_calc_fp48__in_op_nan__3_cov);

  `endif
`endif
//VCS coverage on


//*******************************************//
//  pipeline1: shift exponent and mantissa   //
//*******************************************//
`ifdef DESIGNWARE_NOEXIST 
NV_DW_lsd #(.a_width(36 )) u0_dw_lsd(.a(di_mant), .enc(di_lead_num[5:0]), .dec());
`else 
DW_lsd #(.a_width(36 )) u0_dw_lsd(.a(di_mant), .enc(di_lead_num[5:0]), .dec());
`endif 

assign di_expm[6:0] = di_expn + 6'd47 - di_lead_num;  
assign di_manm[35:0] = ($signed(di_mant)) <<< di_lead_num;

assign di_mans[35:0] = oi_nan ? {36'b0} : di_nan ? {di_mant_pre[37:27],25'b0} : di_manm; 
assign oi_mans[39:0] = oi_nan ? {oi_mant[39:29],29'b0} : di_nan ? {40'b0} : oi_mant;

assign di_expo = in_nan ? {8{1'b1}} : di_zero ? {8'b0} : ({{1{1'b0}}, di_expm}); 
assign oi_expo = in_nan ? {8{1'b1}} : oi_zero ? {8'b0} : (oi_expn); 

//get the maxium of the exponent
assign  max_expo[7:0] = (di_expo > oi_expo) ? di_expo : oi_expo;
//get mantissa shift number
assign {mon_di_expo_shift_c, di_expo_shift[7:0]} = max_expo - di_expo;
assign {mon_oi_expo_shift_c, oi_expo_shift[7:0]} = max_expo - oi_expo;

//extend matissa,add 0 in the end
assign di_mant_ext[39:0] = {di_mans,{4{1'b0}}};
assign oi_mant_ext[39:0] = oi_mans; 
//shift mantissa to align exponent to max
assign {di_mant_shift[39:0],di_mant_cutt[39:0]} = ($signed({di_mant_ext,{40'b0}})) >>> di_expo_shift;
assign {oi_mant_shift[39:0],oi_mant_cutt[39:0]} = ($signed({oi_mant_ext,{40'b0}})) >>> oi_expo_shift;

assign di_aligned_mant_nxt = (di_expo_shift >= 40 ) ? {40{di_sign}} : di_mant_shift; 
assign oi_aligned_mant_nxt = (oi_expo_shift >= 40 ) ? {40{oi_sign}} : oi_mant_shift; 

assign di_mant_cut = {di_mant_cutt[39:38],|di_mant_cutt[37:0]};
assign oi_mant_cut = {oi_mant_cutt[39:38],|oi_mant_cutt[37:0]};
assign in_mant_cut_nxt = (di_expo > oi_expo) ? oi_mant_cut : (di_expo < oi_expo) ? di_mant_cut : 3'b0;

always @(posedge nvdla_core_clk) begin
  if ((in_valid) == 1'b1) begin
    di_aligned_mant <= di_aligned_mant_nxt;
  // VCS coverage off
  end else if ((in_valid) == 1'b0) begin
  end else begin
    di_aligned_mant <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_valid) == 1'b1) begin
    oi_aligned_mant <= oi_aligned_mant_nxt;
  // VCS coverage off
  end else if ((in_valid) == 1'b0) begin
  end else begin
    oi_aligned_mant <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_valid & ~in_nan) == 1'b1) begin
    in_mant_cut <= in_mant_cut_nxt;
  // VCS coverage off
  end else if ((in_valid & ~in_nan) == 1'b0) begin
  end else begin
    in_mant_cut <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_valid & ~in_nan) == 1'b1) begin
    in_aligned_expo <= max_expo;
  // VCS coverage off
  end else if ((in_valid & ~in_nan) == 1'b0) begin
  end else begin
    in_aligned_expo <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

//*******************************************//
//  pipeline2: add two mantissa,normalize    //
//*******************************************//
assign mant_sum[40:0] = $signed(di_aligned_mant) + $signed(oi_aligned_mant);
assign mant_sum_total[43:0] = {mant_sum,in_mant_cut};

`ifdef DESIGNWARE_NOEXIST 
NV_DW_lsd #(.a_width(40 +4)) u1_dw_lsd(.a(mant_sum_total), .enc(msum_lead_num[5:0]), .dec());
`else 
DW_lsd #(.a_width(40 +4)) u1_dw_lsd(.a(mant_sum_total), .enc(msum_lead_num[5:0]), .dec());
`endif 

assign {mon_expo_nrml_c,expo_nrml[7:0]} = in_aligned_expo + 1 - msum_lead_num;

assign mant_sum_comp[44:0] = {mant_sum_total,1'b0};
assign mant_sum_scmp[44:0] = |msum_lead_num ? ($signed(mant_sum_comp)) <<< (msum_lead_num-1) : ($signed(mant_sum_comp)) >>> 1;
assign mant_sum_ncmp[41:0] = in_nan_d ? {mant_sum[39:0],2'b0} : {mant_sum_scmp[43:3],|mant_sum_scmp[2:0]}; 

always @(posedge nvdla_core_clk) begin
  if ((shift_vld & ~in_nan_d) == 1'b1) begin
    expo_trans <= expo_nrml;
  // VCS coverage off
  end else if ((shift_vld & ~in_nan_d) == 1'b0) begin
  end else begin
    expo_trans <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((shift_vld) == 1'b1) begin
    mant_sum_trans <= mant_sum_ncmp[41:0];
  // VCS coverage off
  end else if ((shift_vld) == 1'b0) begin
  end else begin
    mant_sum_trans <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign mant_sum_sign   = mant_sum_trans[40 +1];
assign mant_sum_effect = mant_sum_trans[41:2];
assign mant_sum_guard  = mant_sum_trans[1];
assign mant_sum_stick  = mant_sum_trans[0];

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__mant_sum_zero__4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (~(|mant_sum));
    endproperty
    // Cover 4 : "(~(|mant_sum))"
    FUNCPOINT_cacc_calc_fp48__mant_sum_zero__4_COV : cover property (cacc_calc_fp48__mant_sum_zero__4_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__mant_sum_carry__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (mant_sum[40 ]);
    endproperty
    // Cover 5 : "(mant_sum[40 ])"
    FUNCPOINT_cacc_calc_fp48__mant_sum_carry__5_COV : cover property (cacc_calc_fp48__mant_sum_carry__5_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__mant_sum_little__6_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (msum_lead_num>=6'h4);
    endproperty
    // Cover 6 : "(msum_lead_num>=6'h4)"
    FUNCPOINT_cacc_calc_fp48__mant_sum_little__6_COV : cover property (cacc_calc_fp48__mant_sum_little__6_cov);

  `endif
`endif
//VCS coverage on


//***************************************************//
//  pipeline3:rand0.5,normalize,output partial result//
//***************************************************//
assign mant_sum_point5 = mant_sum_guard & (~mant_sum_sign | mant_sum_stick);
assign mant_sum_round[40:0] = $signed(mant_sum_effect) + $signed({1'b0,mant_sum_point5});
assign mant_sum_carry_pos = ~mant_sum_sign & (&mant_sum_effect[38:0]) & mant_sum_point5;   //01.1111 + 0.00001
assign mant_sum_carry_neg = mant_sum_sign & ~mant_sum_effect[40 -2] & (&mant_sum_effect[37:0]) & mant_sum_point5; //10.1111 + 0.0001

assign partial_mant_nmlz_tmp[40:0] = mant_sum_carry_neg ? {mant_sum_round[39:0], 1'b0} : ($signed(mant_sum_round)) >>> mant_sum_carry_pos;
assign partial_mant_nmlz[39:0] = partial_mant_nmlz_tmp[39:0];
assign partial_mant_zero = ~(|partial_mant_nmlz);

assign {mon_partial_expo_nmlz_nc,partial_expo_nmlz_neg[7:0]} = expo_trans - mant_sum_carry_neg;
assign {mon_partial_expo_nmlz_pc,partial_expo_nmlz_pos[7:0]} = expo_trans + mant_sum_carry_pos;
assign partial_expo_nmlz[7:0] = mant_sum_carry_neg ? partial_expo_nmlz_neg : partial_expo_nmlz_pos; 

assign partial_expo_nxt[7:0] = in_nan_2d ? {8{1'b1}} : partial_mant_zero ? {8'b0} : (partial_expo_nmlz);
assign partial_mant_nxt[39:0] = partial_mant_nmlz; //{partial_mant_nmlz,{::width(PART_MANT_WIDTH-FLOAT_MANT_WIDTH){1'b0}}};

always @(posedge nvdla_core_clk) begin
  if ((msum_vld) == 1'b1) begin
    partial_result_expo <= partial_expo_nxt;
  // VCS coverage off
  end else if ((msum_vld) == 1'b0) begin
  end else begin
    partial_result_expo <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((msum_vld) == 1'b1) begin
    partial_result_mant <= partial_mant_nxt;
  // VCS coverage off
  end else if ((msum_vld) == 1'b0) begin
  end else begin
    partial_result_mant <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign partial_result_out = {partial_result_expo,partial_result_mant};
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    out_partial_valid <= 1'b0;
  end else begin
  out_partial_valid <= msum_vld & ~msum_sel;
  end
end
assign out_partial_data   = partial_result_out; 

assign partial_result = final_sel & final_vld ? partial_result_out : 0;

assign partial_sign = partial_result[40  -1];
assign partial_mant[39:0]    = partial_result[39:0];
assign partial_umant[38:0] = partial_result[38:0];
assign partial_umant_nan[9:0] = partial_result[38:29];
assign partial_expo[7:0]    = partial_result[47:40];

assign partial_neg2 = partial_sign & ~(|partial_umant);
assign partial_nan  = &partial_expo;
assign partial_zero = ~(|partial_mant);

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__mant_sum_round_carry_pos__7_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        mant_sum_carry_pos;
    endproperty
    // Cover 7 : "mant_sum_carry_pos"
    FUNCPOINT_cacc_calc_fp48__mant_sum_round_carry_pos__7_COV : cover property (cacc_calc_fp48__mant_sum_round_carry_pos__7_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__mant_sum_round_carry_neg__8_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        mant_sum_carry_neg;
    endproperty
    // Cover 8 : "mant_sum_carry_neg"
    FUNCPOINT_cacc_calc_fp48__mant_sum_round_carry_neg__8_COV : cover property (cacc_calc_fp48__mant_sum_round_carry_neg__8_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__partial_sum_zero__9_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        partial_zero;
    endproperty
    // Cover 9 : "partial_zero"
    FUNCPOINT_cacc_calc_fp48__partial_sum_zero__9_COV : cover property (cacc_calc_fp48__partial_sum_zero__9_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__partial_sum_nan__10_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        partial_nan;
    endproperty
    // Cover 10 : "partial_nan"
    FUNCPOINT_cacc_calc_fp48__partial_sum_nan__10_COV : cover property (cacc_calc_fp48__partial_sum_nan__10_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__partial_sum_neg2__11_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        partial_neg2;
    endproperty
    // Cover 11 : "partial_neg2"
    FUNCPOINT_cacc_calc_fp48__partial_sum_neg2__11_COV : cover property (cacc_calc_fp48__partial_sum_neg2__11_cov);

  `endif
`endif
//VCS coverage on


//*****************************************************//
//  pipeline4: output fp32                             //
//*****************************************************//
// 1, convert the signed mantissa to be absolute value // 
// 2, rounding the mantissa absolute value             //
// 3, truncate the mantisssa to be 23 bit              //
// 4, final sel partial or fp32                        //
//*****************************************************//
assign partial_mant_abs[38:0] = partial_sign ? (~partial_umant+1) : partial_umant;  

assign fp32_mant_cut    = partial_mant_abs[14:0]; 
assign fp32_mant_effect = partial_mant_abs[38:15]; 
assign fp32_expo_raw    = partial_expo;

//round to 0.5//
assign fp32_mant_point5 = fp32_mant_cut[15 -1];
assign fp32_mant_carry  = (&fp32_mant_effect) & fp32_mant_point5;
assign fp32_mant_round[24:0] = fp32_mant_effect + fp32_mant_point5;

assign fp32_mant_nmlz_tmp[24:0] = ($signed(fp32_mant_round)) >>> fp32_mant_carry; 
assign {mon_fp32_expo_round_c,fp32_expo_round[7:0]} = fp32_expo_raw + 7'd64 + (fp32_mant_carry | partial_neg2);

assign fp32_mant_nmlz[22:0] = partial_nan ? {{13'b0},partial_umant_nan}  : fp32_mant_nmlz_tmp[22:0];
assign fp32_expo_nmlz = partial_zero ? {8'b0} : partial_nan ? {8{1'b1}} : fp32_expo_round;

assign fp32_result = {partial_sign,fp32_expo_nmlz,fp32_mant_nmlz};

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    out_final_valid <= 1'b0;
  end else begin
  out_final_valid <= final_vld & final_sel;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((final_vld & final_sel) == 1'b1) begin
    out_final_data <= fp32_result;
  // VCS coverage off
  end else if ((final_vld & final_sel) == 1'b0) begin
  end else begin
    out_final_data <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__fp32_mant_carry__12_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        fp32_mant_carry;
    endproperty
    // Cover 12 : "fp32_mant_carry"
    FUNCPOINT_cacc_calc_fp48__fp32_mant_carry__12_COV : cover property (cacc_calc_fp48__fp32_mant_carry__12_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__fp32_mant_zero__13_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ~(|fp32_mant_nmlz);
    endproperty
    // Cover 13 : "~(|fp32_mant_nmlz)"
    FUNCPOINT_cacc_calc_fp48__fp32_mant_zero__13_COV : cover property (cacc_calc_fp48__fp32_mant_zero__13_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_calc_fp48__fp32_mant_nan__14_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        &fp32_expo_nmlz;
    endproperty
    // Cover 14 : "&fp32_expo_nmlz"
    FUNCPOINT_cacc_calc_fp48__fp32_mant_nan__14_COV : cover property (cacc_calc_fp48__fp32_mant_nan__14_cov);

  `endif
`endif
//VCS coverage on

 
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! in_data_44b highest three bits is not same!")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, (in_valid & ~di_nan & ~(di_mant_pre[37:35]==3'b111 || di_mant_pre[37:35]==3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! in_data_44b is illegal,NAN and zero happen simultaneously!")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, (in_valid & di_nan & di_zero)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! in_op_48b is illegal,NAN and zero happen simultaneously!")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (in_valid & oi_nan & oi_zero)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! out partial sum is not normalized!")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (final_vld & ~partial_nan & ~partial_zero & ~(partial_mant[40  -1]^partial_mant[40  -2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! out fp32 is not illegal!")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, (final_vld & final_sel & (~(|fp32_expo_nmlz) & (|fp32_mant_nmlz) || (&fp32_expo_nmlz) & ~(|fp32_mant_nmlz)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

endmodule // NV_NVDLA_CACC_CALC_fp_48b

