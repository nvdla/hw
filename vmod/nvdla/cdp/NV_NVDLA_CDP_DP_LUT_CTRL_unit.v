// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_LUT_CTRL_unit.v

module NV_NVDLA_CDP_DP_LUT_CTRL_unit (
   nvdla_core_clk             
  ,nvdla_core_rstn            
  ,dp2lut_prdy                
  ,reg2dp_lut_le_function     
  ,reg2dp_lut_le_index_offset 
  ,reg2dp_lut_le_index_select 
  ,reg2dp_lut_le_start_high   
  ,reg2dp_lut_le_start_low    
  ,reg2dp_lut_lo_index_select 
  ,reg2dp_lut_lo_start_high   
  ,reg2dp_lut_lo_start_low    
  ,reg2dp_sqsum_bypass        
  ,sum2itp_pd                 
  ,sum2itp_pvld               
  ,dp2lut_X_info              
  ,dp2lut_X_pd                
  ,dp2lut_Y_info              
  ,dp2lut_Y_pd                
  ,dp2lut_pvld                
  ,sum2itp_prdy               
  );
///////////////////////////////////////////////////
parameter pINT8_BW = NVDLA_BPE+1;//int8 bitwidth after icvt
parameter pPP_BW = (pINT8_BW + pINT8_BW) -1 + 4;//(pINT8_BW * pINT8_BW) -1 is for int8 mode x^2, +4 is after 9 lrn
///////////////////////////////////////////////////
input          nvdla_core_clk;
input          nvdla_core_rstn;
input   [pPP_BW-1:0] sum2itp_pd;
input          sum2itp_pvld;
output         sum2itp_prdy;
input          reg2dp_lut_le_function;
input    [7:0] reg2dp_lut_le_index_offset;
input    [7:0] reg2dp_lut_le_index_select;
input    [5:0] reg2dp_lut_le_start_high;
input   [31:0] reg2dp_lut_le_start_low;
input    [7:0] reg2dp_lut_lo_index_select;
input    [5:0] reg2dp_lut_lo_start_high;
input   [31:0] reg2dp_lut_lo_start_low;
input          reg2dp_sqsum_bypass;
output  [17:0] dp2lut_X_info;
output  [9:0]  dp2lut_X_pd;
output  [17:0] dp2lut_Y_info;
output  [9:0]  dp2lut_Y_pd;
output         dp2lut_pvld;
input          dp2lut_prdy;
///////////////////////////////////////////////////
reg            X_exp;
reg            X_int8_oflow_msb;
reg     [15:0] X_lin_frac_int8_msb;
reg            Y_dat_info_shift;
reg     [pPP_BW:0] Y_dec_offset_msb;
reg            Y_int8_oflow_msb;
reg            Y_less_than_win_s;
reg     [15:0] Y_lin_frac_int8_msb;
reg      [7:0] Y_shift_bits;
reg      [9:0] Y_shift_msb_int8;
reg     [16:0] dat_info_d;
reg     [16:0] dat_info_shift;
reg     [pPP_BW+1:0] dec_Xindex_msb;
reg     [pPP_BW:0] dec_offset_msb;
reg            int_X_index_uflow_msb;
reg            int_X_input_uflow_d;
reg            int_X_input_uflow_msb;
reg            int_Y_input_uflow_msb;
reg            int_Y_stage0_pvld;
reg            int_Y_stage1_pvld;
reg            int_stage0_pvld;
reg            int_stage1_pvld;
reg            int_stage2_pvld;
reg            int_stage3_pvld;
reg            less_than_win_s;
reg     [pPP_BW:0] log2_datout_msb;
reg     [pPP_BW-1:0] log2_frac_msb;
reg      [0:0] mon_Y_dec_offset_msb;
reg      [0:0] mon_dec_Xindex_msb;
reg      [0:0] mon_dec_offset_msb;
//reg      [9:0] shift_int16;
reg      [9:0] shift_msb_int8;
reg            sqsum_bypass_enable;
wire    [17:0] X_dat_info;
wire    [15:0] X_exp_frac_msb;
wire    [15:0] X_frac_msb;
wire     [9:0] X_index_msb;
wire    [15:0] X_lin_frac_msb;
wire           X_oflow_int_msb;
wire    [17:0] Y_dat_info;
wire    [17:0] Y_dat_info_f;
wire     [9:0] Y_index_msb;
wire     [9:0] Y_index_msb_f;
wire           Y_int_stage3_prdy;
wire           Y_int_stage3_pvld;
wire    [15:0] Y_lin_frac_msb;
wire           Y_oflow_int_msb;
//wire     [5:0] Y_shift_bits_int16_abs;
wire     [4:0] Y_shift_bits_int8_abs;
wire     [4:0] Y_shift_bits_inv;
//wire     [5:0] Y_shift_bits_inv1;
//wire    [37:0] Y_shift_int16_f;
//wire    [63:0] Y_shift_int16_s;
wire    [pPP_BW:0] Y_shift_msb_int8_f;
wire    [31:0] Y_shift_msb_int8_s;
wire    [16:0] dat_info;
wire    [16:0] dat_info_index_sub;
wire    [pPP_BW-1:0] datin_int8;
wire    [pPP_BW:0] dec_Xindex_datin_msb;
wire    [pPP_BW:0] dec_Yindex_msb;
wire    [pPP_BW:0] dec_offset_datin_msb;
wire    [pPP_BW:0] dec_offset_datin_msb_f0;
wire    [pPP_BW:0] dec_offset_datin_msb_f1;
wire           int_X_datin_prdy;
wire           int_X_proc_in_vld;
wire           int_Y_datin_prdy;
wire           int_Y_proc_in_vld;
wire           int_Y_stage0_prdy;
wire           int_Y_stage1_prdy;
wire           int_out_rdy;
wire           int_out_vld;
wire           int_stage0_prdy;
wire           int_stage1_prdy;
wire           int_stage2_in_vld;
wire           int_stage2_prdy;
wire           int_stage3_prdy;
wire           load_din_intY;
wire           load_in_intX;
wire           load_int_Y_stage0;
wire           load_int_stage0;
wire           load_int_stage1;
wire           load_int_stage2;
wire    [pPP_BW:0] log2_datin_msb;
wire           log2_datin_vld;
wire     [7:0] reg2dp_X_index_offset;
wire    [37:0] reg2dp_X_offset;
wire    [37:0] reg2dp_Y_offset;
wire     [7:0] shift_bits;
//wire     [6:0] shift_bits_int16_abs;
wire     [5:0] shift_bits_int8_abs;
wire     [4:0] shift_bits_inv;
//wire     [5:0] shift_bits_inv1;
//wire    [38:0] shift_int16_f;
//wire    [63:0] shift_int16_s;
wire    [pPP_BW+1:0] shift_msb_int8_f;
wire    [31:0] shift_msb_int8_s;

wire        Y_stage3_out_rdy;
///////////////////////////////////////////////////
//==============
// Work Processing
//==============

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    X_exp <= 1'b0;
  end else begin
  X_exp <= reg2dp_lut_le_function == 1'h0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_shift_bits[7:0] <= {8{1'b0}};
  end else begin
  Y_shift_bits[7:0] <= reg2dp_lut_lo_index_select[7:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sqsum_bypass_enable <= 1'b0;
  end else begin
  sqsum_bypass_enable <= reg2dp_sqsum_bypass == 1'h1;
  end
end
///////////////////////////////////////
assign sum2itp_prdy = int_Y_datin_prdy & int_X_datin_prdy;

assign datin_int8 = sum2itp_pd;
///////////////////////////////////////////////////////////////////////////////////////
//int X Y table input interlock
assign int_X_proc_in_vld = sum2itp_pvld & int_Y_datin_prdy;
assign int_Y_proc_in_vld = sum2itp_pvld & int_X_datin_prdy;

//////////////////////////////////////////////////////////////////////
// index calculation of X table
//////////////////////////////////////////////////////////////////////

//=================================================
//offset minus
//=================================================
assign reg2dp_X_offset[37:0] = {reg2dp_lut_le_start_high[5:0],reg2dp_lut_le_start_low[31:0]};

assign load_in_intX = int_X_proc_in_vld & int_X_datin_prdy;
assign dec_offset_datin_msb_f0 = {1'b0,datin_int8};
assign dec_offset_datin_msb_f1 = {datin_int8[pPP_BW-1],datin_int8};
assign dec_offset_datin_msb = sqsum_bypass_enable ? dec_offset_datin_msb_f1 : dec_offset_datin_msb_f0;

always @(*) begin
    case({dec_offset_datin_msb[pPP_BW],reg2dp_X_offset[pPP_BW]})
    2'b01: less_than_win_s = 1'b0;
    2'b10: less_than_win_s = 1'b1;
    default: less_than_win_s = (dec_offset_datin_msb[pPP_BW:0] < reg2dp_X_offset[pPP_BW:0]) | (dec_offset_datin_msb[pPP_BW:0] == reg2dp_X_offset[pPP_BW:0]);
    endcase
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_dec_offset_msb[0],dec_offset_msb[pPP_BW:0]} <= {(pPP_BW+2){1'b0}};
    int_X_input_uflow_msb <= 1'b0;
  end else begin
    if(load_in_intX) begin
        if(less_than_win_s) begin
            {mon_dec_offset_msb[0], dec_offset_msb[pPP_BW:0]} <= {(pPP_BW+2){1'b0}};
            int_X_input_uflow_msb <= 1'b1;
        end else begin
            {mon_dec_offset_msb[0], dec_offset_msb[pPP_BW:0]} <= ($signed(dec_offset_datin_msb) - $signed(reg2dp_X_offset[pPP_BW:0]));
            int_X_input_uflow_msb <= 1'b0;
        end
    end
  end
end

assign int_X_datin_prdy = ~int_stage0_pvld | int_stage0_prdy;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_stage0_pvld <= 1'b0;
  end else begin
    if(int_X_proc_in_vld)
        int_stage0_pvld <= 1'b1;
    else if(int_stage0_prdy)
        int_stage0_pvld <= 1'b0;
  end
end
assign int_stage0_prdy = ~int_stage1_pvld | int_stage1_prdy;

assign load_int_stage0 = int_stage0_pvld & int_stage0_prdy;
//===================================================================
//log2 logic , bypassed when X is a linear table
assign log2_datin_msb = dec_offset_msb ;
assign log2_datin_vld = load_int_stage0;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    log2_datout_msb <= {(pPP_BW+1){1'b0}};
    log2_frac_msb   <= {pPP_BW{1'b0}};
  end else begin
    if(log2_datin_vld) begin
        if(int_X_input_uflow_msb) begin
            log2_datout_msb <= {(pPP_BW+1){1'b0}};
            log2_frac_msb   <= {pPP_BW{1'b0}};
        end else begin
            if(X_exp) begin
//Note need modify "my $k = 21" if BW changed.
//: my $k = 21;
//: my $k1 = $k +1;
//:       print qq(
//:           if(log2_datin_msb[${k}]) begin
//:               log2_datout_msb <= ${k1}'d${k};
//:               log2_frac_msb   <= log2_datin_msb[${k}-1:0];
//:       );
//:     foreach my $m (0..$k - 2) {
//:       my $i = $k - $m -1;
//:         print qq(
//:           end else if(log2_datin_msb[$i]) begin
//:               log2_datout_msb <= ${k1}'d${i}; 
//:               log2_frac_msb   <= {log2_datin_msb[${i}-1:0],{(${k}-${i}){1'b0}}}; 
//:         );
//:     }
                    end else if(log2_datin_msb[0]) begin
                        log2_datout_msb <= {(pPP_BW+1){1'b0}};
                        log2_frac_msb   <= {pPP_BW{1'b0}};
                    end
            end else
                log2_datout_msb <= log2_datin_msb;
        end
    end
  end
end

assign X_exp_frac_msb = log2_frac_msb[pPP_BW-1:pPP_BW-16];

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_X_input_uflow_d <= 1'b0;
  end else begin
    if(log2_datin_vld)
        int_X_input_uflow_d <= int_X_input_uflow_msb;
  end
end

assign dat_info = {int_X_input_uflow_d,X_exp_frac_msb};
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_stage1_pvld <= 1'b0;
  end else begin
    if(int_stage0_pvld)
        int_stage1_pvld <= 1'b1;
    else if(int_stage1_prdy)
        int_stage1_pvld <= 1'b0;
  end
end
assign int_stage1_prdy = ~int_stage2_pvld | int_stage2_prdy;

//===================================================================
//exp index offset , only valid for exponent table
assign reg2dp_X_index_offset[7:0] = reg2dp_lut_le_index_offset[7:0];

assign load_int_stage1 = int_stage1_pvld & int_stage1_prdy;
assign int_stage2_in_vld = int_stage1_pvld;
assign dec_Xindex_datin_msb = log2_datout_msb;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_dec_Xindex_msb[0],dec_Xindex_msb} <= {(pPP_BW+3){1'b0}};
    int_X_index_uflow_msb <= 1'b0;
  end else begin
    if(load_int_stage1) begin
        if(dat_info[16]) begin //uflow
            {mon_dec_Xindex_msb[0], dec_Xindex_msb} <= {(pPP_BW+3){1'b0}};
            int_X_index_uflow_msb <= 1'b0;
        end else if(X_exp) begin
            //if((dec_Xindex_datin_msb < {{(pPP_BW+1-7){1'b0}},reg2dp_X_index_offset[6:0]}) & (~reg2dp_X_index_offset[7])) begin
            if((dec_Xindex_datin_msb < {{(pPP_BW-6){1'b0}},reg2dp_X_index_offset[6:0]}) & (~reg2dp_X_index_offset[7])) begin
                {mon_dec_Xindex_msb[0], dec_Xindex_msb} <= {(pPP_BW+3){1'b0}};
                int_X_index_uflow_msb <= 1'b1;
            end else begin
                {mon_dec_Xindex_msb[0], dec_Xindex_msb} <= $signed({1'b0,dec_Xindex_datin_msb}) - $signed({{(pPP_BW-6){reg2dp_X_index_offset[7]}},reg2dp_X_index_offset[7:0]});
                int_X_index_uflow_msb <= 1'b0;
            end
        end else begin
            {mon_dec_Xindex_msb[0], dec_Xindex_msb} <= {2'd0,dec_Xindex_datin_msb};
            int_X_index_uflow_msb <= 1'b0;
        end
    end
  end
end

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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP_LUT_ctrl: no overflow is allowed")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, load_int_stage2 & (|mon_dec_Xindex_msb); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_info_d <= {17{1'b0}};
  end else if ((load_int_stage1) == 1'b1) begin
    dat_info_d <= dat_info;
  end
end
assign dat_info_index_sub = {dat_info_d[16] | int_X_index_uflow_msb, dat_info_d[15:0]};

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_stage2_pvld <= 1'b0;
  end else begin
    if(int_stage2_in_vld)
        int_stage2_pvld <= 1'b1;
    else if(int_stage2_prdy)
        int_stage2_pvld <= 1'b0;
  end
end
assign int_stage2_prdy = ~int_stage3_pvld | int_stage3_prdy;

assign load_int_stage2 = int_stage2_pvld & int_stage2_prdy;
//===================================================================
//shift process for int8/int16, linear only, shift "0" when exponent X
assign shift_bits[7:0] = X_exp ? 8'd0 : reg2dp_lut_le_index_select[7:0];
//note for int16 should be: assign shift_bits_inv1[5:0] = ~shift_bits[5:0];
//note for int16 should be: assign shift_bits_int16_abs[6:0] = shift_bits[6]? (shift_bits_inv1[5:0]+1) : shift_bits[5:0];
//note for int16 should be: assign {shift_int16_s[63:0],   shift_int16_f[38:0]   } = shift_bits[6]? ({64'd0,dec_Xindex_lsb[38:0]}<<shift_bits_int16_abs) : ({25'd0,dec_Xindex_lsb[38:0],39'd0}>>shift_bits_int16_abs);
assign shift_bits_inv[4:0]  = ~shift_bits[4:0];
assign shift_bits_int8_abs[5:0]  = shift_bits[5]? (shift_bits_inv[4:0] +1) : shift_bits[4:0];
assign {shift_msb_int8_s[31:0],shift_msb_int8_f[pPP_BW+1:0]} = shift_bits[5]? ({32'd0,dec_Xindex_msb}<<shift_bits_int8_abs ) : ({9'd0,dec_Xindex_msb,23'd0}>>shift_bits_int8_abs );

//always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//  if (!nvdla_core_rstn) begin
//    shift_int16[9:0] <= {10{1'b0}};
//    X_int16_oflow <= 1'b0;
//  end else begin
//    if(load_int_stage2) begin
//        if(dat_info_index_sub[32]) begin //lsb uflow
//            shift_int16[9:0] <= 10'd0;
//            X_int16_oflow <= 1'b0;
//        end else if(shift_bits[6]) begin
//            if({shift_int16_s,shift_int16_f} >= (65 -1)) begin
//                shift_int16[9:0] <= 65  - 1;
//                X_int16_oflow <= 1'b1;
//            end else begin
//                shift_int16[9:0] <= shift_int16_f[9:0];
//                X_int16_oflow <= 1'b0;
//            end
//        end else begin
//            if(shift_int16_s >= (65 -1)) begin
//                shift_int16[9:0] <= 65  - 1;
//                X_int16_oflow <= 1'b1;
//            end else begin
//                shift_int16[9:0] <= shift_int16_s[9:0];
//                X_int16_oflow <= 1'b0;
//            end
//        end
//    end
//  end
//end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    shift_msb_int8[9:0] <= {10{1'b0}};
    X_int8_oflow_msb <= 1'b0;
  end else begin
    if(load_int_stage2) begin
        if(dat_info_index_sub[16]) begin //uflow
            shift_msb_int8[9:0] <= 10'd0;
            X_int8_oflow_msb <= 1'b0;
        end else if(shift_bits[5]) begin
            if({shift_msb_int8_s,shift_msb_int8_f} >= (65 -1)) begin
                shift_msb_int8[9:0] <= 65  - 1;//7'd64;
                X_int8_oflow_msb <= 1'b1;
            end else begin
                shift_msb_int8[9:0] <= shift_msb_int8_f[9:0];
                X_int8_oflow_msb <= 1'b0;
            end
        end else begin
            if(shift_msb_int8_s >= (65 -1)) begin
                shift_msb_int8[9:0] <= 65  - 1;//7'd64;
                X_int8_oflow_msb <= 1'b1;
            end else begin
                shift_msb_int8[9:0] <= shift_msb_int8_s[9:0];
                X_int8_oflow_msb <= 1'b0;
            end
        end
    end
  end
end
assign X_oflow_int_msb = X_int8_oflow_msb;
assign X_index_msb = shift_msb_int8;

//always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//  if (!nvdla_core_rstn) begin
//    X_lin_frac_int16[15:0] <= {16{1'b0}};
//  end else begin
//    if(load_int_stage2) begin
//        if(shift_bits[6])
//            X_lin_frac_int16[15:0] <= 16'd0;
//        else
//            X_lin_frac_int16[15:0] <= shift_int16_f[38:23];
//    end
//  end
//end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    X_lin_frac_int8_msb[15:0] <= {16{1'b0}};
  end else begin
    if(load_int_stage2) begin
        if(shift_bits[5])
            X_lin_frac_int8_msb[15:0] <= 16'd0;
        else
            X_lin_frac_int8_msb[15:0] <= shift_msb_int8_f[pPP_BW+1:pPP_BW-14];
    end
  end
end

assign X_lin_frac_msb = X_lin_frac_int8_msb;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_info_shift <= {17{1'b0}};
  end else if ((load_int_stage2) == 1'b1) begin
    dat_info_shift <= dat_info_index_sub;
  end
end
assign X_frac_msb = X_exp ? dat_info_shift[15:0] : X_lin_frac_msb;
assign X_dat_info   = {X_oflow_int_msb,dat_info_shift[16],X_frac_msb};//oflow, uflow, frac
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP INT X table msb info: uflow and oflow occured at same time")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, int_stage3_pvld & dat_info_shift[16] & X_oflow_int_msb); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_stage3_pvld <= 1'b0;
  end else begin
    if(int_stage2_pvld)
        int_stage3_pvld <= 1'b1;
    else if(int_stage3_prdy)
        int_stage3_pvld <= 1'b0;
  end
end
//assign int_stage3_prdy = ~int_stage4_pvld | int_stage4_prdy;

//assign load_int_stage3 = int_stage3_pvld & int_stage3_prdy;

//////////////////////////////////////////////////////////////////////
//index calculation of Y table
//////////////////////////////////////////////////////////////////////

//==================================================
//input offset
//==================================================
assign reg2dp_Y_offset[37:0] = {reg2dp_lut_lo_start_high[5:0],reg2dp_lut_lo_start_low[31:0]};

assign load_din_intY = int_Y_proc_in_vld & int_Y_datin_prdy;

always @(*) begin
    case({dec_offset_datin_msb[pPP_BW],reg2dp_Y_offset[pPP_BW]})
    2'b01: Y_less_than_win_s = 1'b0;
    2'b10: Y_less_than_win_s = 1'b1;
    default: Y_less_than_win_s = (dec_offset_datin_msb[pPP_BW:0] < reg2dp_Y_offset[pPP_BW:0]) | (dec_offset_datin_msb[pPP_BW:0] == reg2dp_Y_offset[pPP_BW:0]);
    endcase
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_Y_dec_offset_msb[0],Y_dec_offset_msb} <= {(pPP_BW+2){1'b0}};
    int_Y_input_uflow_msb <= 1'b0;
  end else begin
    if(load_din_intY) begin
        if(Y_less_than_win_s) begin
            {mon_Y_dec_offset_msb[0], Y_dec_offset_msb} <= {(pPP_BW+2){1'b0}};
            int_Y_input_uflow_msb <= 1'b1;
        end else begin
            {mon_Y_dec_offset_msb[0], Y_dec_offset_msb} <= ($signed(dec_offset_datin_msb) - $signed(reg2dp_Y_offset[pPP_BW:0]));
            int_Y_input_uflow_msb <= 1'b0;
        end
    end
  end
end

assign int_Y_datin_prdy = ~int_Y_stage0_pvld | int_Y_stage0_prdy;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_Y_stage0_pvld <= 1'b0;
  end else begin
    if(int_Y_proc_in_vld)
        int_Y_stage0_pvld <= 1'b1;
    else if(int_Y_stage0_prdy)
        int_Y_stage0_pvld <= 1'b0;
  end
end
assign int_Y_stage0_prdy =~int_Y_stage1_pvld | int_Y_stage1_prdy;

assign load_int_Y_stage0 = int_Y_stage0_pvld & int_Y_stage0_prdy;

//===================================================================
//shift process for Y int8/int16, Y is linear only
//===================================================================
assign dec_Yindex_msb = Y_dec_offset_msb;
// note int16 should be this : assign Y_shift_bits_inv1[5:0] = ~Y_shift_bits[5:0];
// note int16 should be this : assign Y_shift_bits_int16_abs = Y_shift_bits[6]? (Y_shift_bits_inv1[5:0]+1) : Y_shift_bits[5:0];
// note int16 should be this : assign {Y_shift_int16_s[63:0]   ,Y_shift_int16_f[37:0]}    = Y_shift_bits[6]? ({64'd0,dec_Yindex_lsb[37:0]} << Y_shift_bits_int16_abs) : ({26'd0,dec_Yindex_lsb[37:0],38'd0} >> Y_shift_bits_int16_abs);

assign Y_shift_bits_inv[4:0]  = ~Y_shift_bits[4:0];
assign Y_shift_bits_int8_abs  = Y_shift_bits[5]? (Y_shift_bits_inv[4:0] +1) : Y_shift_bits[4:0];
assign {Y_shift_msb_int8_s[31:0],Y_shift_msb_int8_f} = Y_shift_bits[5]? ({32'd0,dec_Yindex_msb} << Y_shift_bits_int8_abs ) : ({10'd0,dec_Yindex_msb,22'd0} >> Y_shift_bits_int8_abs);

//always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//  if (!nvdla_core_rstn) begin
//    Y_shift_int16[9:0] <= {10{1'b0}};
//    Y_int16_oflow <= 1'b0;
//  end else begin
//    if(load_int_Y_stage0) begin
//        if(int_Y_input_uflow_lsb) begin
//            Y_shift_int16[9:0] <= 10'd0;
//            Y_int16_oflow <= 1'b0;
//        end else if(Y_shift_bits[6]) begin
//            if({Y_shift_int16_s,Y_shift_int16_f} >= (257 -1)) begin
//                Y_shift_int16[9:0] <= 257  - 1;
//                Y_int16_oflow <= 1'b1;
//            end else begin
//                Y_shift_int16[9:0] <= Y_shift_int16_f[9:0];
//                Y_int16_oflow <= 1'b0;
//            end
//        end else begin
//            if(Y_shift_int16_s >= (257 -1)) begin
//                Y_shift_int16[9:0] <= 257  - 1;
//                Y_int16_oflow <= 1'b1;
//            end else begin
//                Y_shift_int16[9:0] <= Y_shift_int16_s[9:0];
//                Y_int16_oflow <= 1'b0;
//            end
//        end
//    end
//  end
//end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_shift_msb_int8[9:0] <= {10{1'b0}};
    Y_int8_oflow_msb <= 1'b0;
  end else begin
    if(load_int_Y_stage0) begin
        if(int_Y_input_uflow_msb) begin
            Y_shift_msb_int8[9:0] <= 10'd0;
            Y_int8_oflow_msb <= 1'b0;
        end else if(Y_shift_bits[5]) begin
            if({Y_shift_msb_int8_s,Y_shift_msb_int8_f} >= (257 -1)) begin
                Y_shift_msb_int8[9:0] <= 257  - 1;
                Y_int8_oflow_msb <= 1'b1;
            end else begin
                Y_shift_msb_int8[9:0] <= Y_shift_msb_int8_f[9:0];
                Y_int8_oflow_msb <= 1'b0;
            end
        end else begin
            if(Y_shift_msb_int8_s >= (257 -1)) begin
                Y_shift_msb_int8[9:0] <= 257  - 1;
                Y_int8_oflow_msb <= 1'b1;
            end else begin
                Y_shift_msb_int8[9:0] <= Y_shift_msb_int8_s[9:0];
                Y_int8_oflow_msb <= 1'b0;
            end
        end
    end
  end
end
assign Y_oflow_int_msb = Y_int8_oflow_msb;
assign Y_index_msb_f = Y_shift_msb_int8;

//always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//  if (!nvdla_core_rstn) begin
//    Y_lin_frac_int16[15:0] <= {16{1'b0}};
//  end else begin
//    if(load_int_Y_stage0) begin
//        if(Y_shift_bits[6])
//            Y_lin_frac_int16[15:0] <= 16'd0;
//        else
//            Y_lin_frac_int16[15:0] <= Y_shift_int16_f[37:22];
//    end
//  end
//end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_lin_frac_int8_msb[15:0] <= {16{1'b0}};
  end else begin
    if(load_int_Y_stage0) begin
        if(Y_shift_bits[5])
            Y_lin_frac_int8_msb[15:0] <= 16'd0;
        else
            Y_lin_frac_int8_msb[15:0] <= Y_shift_msb_int8_f[pPP_BW:pPP_BW-15];
    end
  end
end
assign Y_lin_frac_msb = Y_lin_frac_int8_msb;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_dat_info_shift <= 1'b0;
  end else if (load_int_Y_stage0)  begin
    Y_dat_info_shift <= int_Y_input_uflow_msb;
  end
end
assign Y_dat_info_f   = {Y_oflow_int_msb,Y_dat_info_shift,Y_lin_frac_msb};
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP INT Y table msb info: uflow and oflow occured at same time")      zzz_assert_never_10x (nvdla_core_clk, `ASSERT_RESET, int_Y_stage1_pvld & Y_dat_info_shift & Y_oflow_int_msb); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_Y_stage1_pvld <= 1'b0;
  end else begin
    if(int_Y_stage0_pvld)
        int_Y_stage1_pvld <= 1'b1;
    else if(int_Y_stage1_prdy)
        int_Y_stage1_pvld <= 1'b0;
  end
end
//assign int_Y_stage1_prdy = Y_stage1_in_rdy;

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//pipe delay to sync with X table
wire  [27:0]    Y_stage1_in_pd;
wire            Y_stage1_in_vld;
wire            Y_stage1_in_rdy;
reg             Y_stage2_in_vld;
reg             Y_stage3_out_vld;
wire            Y_stage2_in_rdy;
reg   [27:0]    Y_stage2_in_dp;
reg   [27:0]    Y_stage3_out_pd;
/////////////////////////////////////////////////////////////////////////
assign int_Y_stage1_prdy = Y_stage1_in_rdy;
/////////////////////////////////////////////////////////////////////////

assign Y_stage1_in_pd = {Y_dat_info_f,Y_index_msb_f};
assign Y_stage1_in_vld = int_Y_stage1_pvld;
/////////////////////////////////
assign Y_stage1_in_rdy = Y_stage2_in_rdy || (~Y_stage2_in_vld);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_stage2_in_vld <= 1'b0;
  end else if(Y_stage1_in_vld) begin
    Y_stage2_in_vld <= 1'b1;
  end else if(Y_stage2_in_rdy) begin
    Y_stage2_in_vld <= 1'b0;
  end
end
assign Y_stage2_in_rdy = Y_stage3_out_rdy || (~Y_stage3_out_vld);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_stage3_out_vld <= 1'b0;
  end else if(Y_stage2_in_vld) begin
    Y_stage3_out_vld <= 1'b1;
  end else if(Y_stage3_out_rdy) begin
    Y_stage3_out_vld <= 1'b0;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_stage2_in_dp <= 28'd0;
  end else if(Y_stage1_in_vld & Y_stage1_in_rdy) begin
    Y_stage2_in_dp <= Y_stage1_in_pd;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_stage3_out_pd <= 28'd0;
  end else if(Y_stage2_in_vld & Y_stage2_in_rdy) begin
    Y_stage3_out_pd <= Y_stage2_in_dp;
  end
end
/////////////////////////////////

assign Y_index_msb = Y_stage3_out_pd[9:0];
assign Y_dat_info = Y_stage3_out_pd[27:10];
assign Y_int_stage3_pvld = Y_stage3_out_vld;
assign Y_stage3_out_rdy  = Y_int_stage3_prdy;
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
//int X Y tables control output interlock
assign int_stage3_prdy   = int_out_rdy & Y_int_stage3_pvld;
assign Y_int_stage3_prdy = int_out_rdy & int_stage3_pvld;
assign int_out_vld = int_stage3_pvld & Y_int_stage3_pvld;

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
assign dp2lut_pvld = int_out_vld;
assign int_out_rdy = dp2lut_prdy;

assign dp2lut_X_pd   = {X_index_msb};
assign dp2lut_X_info = X_dat_info;

assign dp2lut_Y_pd   = {Y_index_msb};
assign dp2lut_Y_info =  Y_dat_info;

////////////
endmodule // NV_NVDLA_CDP_DP_LUT_CTRL_unit


