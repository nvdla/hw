// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_INTP_unit.v

module NV_NVDLA_CDP_DP_INTP_unit (
   nvdla_op_gated_clk_int  //|< i
  ,nvdla_core_rstn         //|< i
  ,fp16_en                 //|< i
  ,interp_in0_pd           //|< i
  ,interp_in1_pd           //|< i
  ,interp_in_pd            //|< i
  ,interp_in_scale         //|< i
  ,interp_in_shift         //|< i
  ,interp_in_vld           //|< i
  ,interp_out_rdy          //|< i
  ,nvdla_op_gated_clk_fp16 //|< i
  ,interp_in_rdy           //|> o
  ,interp_out_pd           //|> o
  ,interp_out_vld          //|> o
  );
input         nvdla_op_gated_clk_int;
input         nvdla_core_rstn;
input         fp16_en;
input  [38:0] interp_in0_pd;
input  [37:0] interp_in1_pd;
input  [16:0] interp_in_pd;
input  [16:0] interp_in_scale;
input   [5:0] interp_in_shift;
input         interp_in_vld;
input         interp_out_rdy;
input         nvdla_op_gated_clk_fp16;
output        interp_in_rdy;
output [16:0] interp_out_pd;
output        interp_out_vld;
reg    [88:0] int_add;
reg    [56:0] int_mul;
reg    [57:0] int_mul_for_Rshift;
reg    [39:0] int_sub;
reg           int_vld_d0;
reg           int_vld_d1;
reg           int_vld_d2;
reg    [16:0] interp_in0_pd_d0;
reg    [16:0] interp_in0_pd_d1;
reg    [16:0] interp_in_offset_d0;
reg     [5:0] interp_in_shift_d0;
reg     [5:0] interp_in_shift_d1;
wire          fp_add_a_rdy;
wire          fp_add_a_vld;
wire          fp_add_b_rdy;
wire          fp_add_b_vld;
wire   [16:0] fp_add_out_pd;
wire          fp_add_out_rdy;
wire          fp_add_out_vld;
wire          fp_in_rdy;
wire          fp_in_vld;
wire   [16:0] fp_interp_in0_pd_d0;
wire   [16:0] fp_interp_in0_pd_d1;
wire   [16:0] fp_interp_in_offset_d0;
wire          fp_interp_rdy_d0;
wire          fp_interp_rdy_d1;
wire          fp_interp_vld_d0;
wire          fp_interp_vld_d1;
wire          fp_mul_a_rdy;
wire          fp_mul_a_vld;
wire          fp_mul_b_rdy;
wire          fp_mul_b_vld;
wire   [16:0] fp_mul_out_pd;
wire          fp_mul_out_rdy;
wire          fp_mul_out_vld;
wire   [16:0] fp_mul_sync_in_pd;
wire   [16:0] fp_mul_sync_in_pd_d0;
wire   [16:0] fp_mul_sync_in_pd_d1;
wire   [16:0] fp_mul_sync_in_pd_d2;
wire   [16:0] fp_mul_sync_in_pd_d3;
wire          fp_mul_sync_in_rdy;
wire          fp_mul_sync_in_rdy_d0;
wire          fp_mul_sync_in_rdy_d1;
wire          fp_mul_sync_in_rdy_d2;
wire          fp_mul_sync_in_rdy_d3;
wire          fp_mul_sync_in_vld;
wire          fp_mul_sync_in_vld_d0;
wire          fp_mul_sync_in_vld_d1;
wire          fp_mul_sync_in_vld_d2;
wire          fp_mul_sync_in_vld_d3;
wire   [16:0] fp_mul_sync_out_pd;
wire          fp_mul_sync_out_rdy;
wire          fp_mul_sync_out_vld;
wire          fp_sub_a_rdy;
wire          fp_sub_a_vld;
wire          fp_sub_b_rdy;
wire          fp_sub_b_vld;
wire   [16:0] fp_sub_o_pd;
wire          fp_sub_o_rdy;
wire          fp_sub_o_vld;
wire   [31:0] fp_sub_out_pd;
wire          fp_sub_out_rdy;
wire          fp_sub_out_vld;
wire   [33:0] fp_sub_sync_in_pd;
wire   [33:0] fp_sub_sync_in_pd_d0;
wire   [33:0] fp_sub_sync_in_pd_d1;
wire   [33:0] fp_sub_sync_in_pd_d2;
wire   [33:0] fp_sub_sync_in_pd_d3;
wire   [33:0] fp_sub_sync_in_pd_d4;
wire   [33:0] fp_sub_sync_in_pd_d5;
wire   [33:0] fp_sub_sync_in_pd_d6;
wire   [33:0] fp_sub_sync_in_pd_d7;
wire          fp_sub_sync_in_rdy;
wire          fp_sub_sync_in_rdy_d0;
wire          fp_sub_sync_in_rdy_d1;
wire          fp_sub_sync_in_rdy_d2;
wire          fp_sub_sync_in_rdy_d3;
wire          fp_sub_sync_in_rdy_d4;
wire          fp_sub_sync_in_rdy_d5;
wire          fp_sub_sync_in_rdy_d6;
wire          fp_sub_sync_in_rdy_d7;
wire          fp_sub_sync_in_vld;
wire          fp_sub_sync_in_vld_d0;
wire          fp_sub_sync_in_vld_d1;
wire          fp_sub_sync_in_vld_d2;
wire          fp_sub_sync_in_vld_d3;
wire          fp_sub_sync_in_vld_d4;
wire          fp_sub_sync_in_vld_d5;
wire          fp_sub_sync_in_vld_d6;
wire          fp_sub_sync_in_vld_d7;
wire   [33:0] fp_sub_sync_out_pd;
wire          fp_sub_sync_out_rdy;
wire          fp_sub_sync_out_vld;
wire          int_in_load;
wire          int_in_load_d0;
wire          int_in_load_d1;
wire          int_in_rdy;
wire          int_in_vld;
wire   [15:0] int_interp_out_pd;
wire          int_interp_out_rdy;
wire   [87:0] int_mul_rs;
wire   [31:0] int_mul_shift_frac;
wire   [87:0] int_mul_shift_int;
wire          int_rdy_d0;
wire          int_rdy_d1;
wire          int_rdy_d2;
wire    [5:0] interp_in_shift_abs;
wire    [4:0] intp_in_shift_inv;
wire    [5:0] intp_in_shift_inv_inc;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    ///////////////////////////////////////////
//interp_in_vld
assign interp_in_rdy = fp16_en ? fp_in_rdy : int_in_rdy;
///////////////////////////////////////////
//interperlator for INT mode
//interpolation for normal hit: X0+(X1-X0)*frac>>16
//interpolation for underflow : X0+(sumout-start)*scale>>shift
//interpolation for overflow  : X1+(sumout-end)*scale>>shift
assign int_in_vld = fp16_en ? 1'b0 : interp_in_vld;
assign int_in_rdy = ~int_vld_d0 | int_rdy_d0;
assign int_in_load = int_in_vld & int_in_rdy;

//slcg
//////

///////////////////
//X1-X0
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_sub[39:0] <= {40{1'b0}};
    interp_in0_pd_d0 <= {17{1'b0}};
    interp_in_offset_d0 <= {17{1'b0}};
    interp_in_shift_d0 <= {6{1'b0}};
  end else begin
    if(int_in_load) begin
        //int_sub <0= $signed(interp_in1_pd[37:0]) - $signed(interp_in0_pd[38:0]);
        int_sub[39:0] <= $signed({interp_in1_pd[37],interp_in1_pd[37:0]}) - $signed(interp_in0_pd[38:0]);
        interp_in0_pd_d0    <= interp_in_pd[16:0];
        interp_in_offset_d0 <= interp_in_scale[16:0];
        interp_in_shift_d0  <= interp_in_shift[5:0];
    end
  end
end

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_vld_d0 <= 1'b0;
  end else begin
    if(int_in_vld)
        int_vld_d0 <= 1'b1;
    else if(int_rdy_d0)
        int_vld_d0 <= 1'b0;
  end
end
assign int_rdy_d0 = ~int_vld_d1 | int_rdy_d1;
assign int_in_load_d0 = int_vld_d0 & int_rdy_d0;
///////////////////
//(X1-X0)*frac
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_mul[56:0] <= {57{1'b0}};
    interp_in0_pd_d1 <= {17{1'b0}};
    interp_in_shift_d1 <= {6{1'b0}};
  end else begin
    if(int_in_load_d0) begin
        //int_mul[55:0] <0= $signed(int_sub[38:0]) * $signed(interp_in_offset_d0);
        int_mul[56:0] <= $signed(int_sub[39:0]) * $signed(interp_in_offset_d0);
        interp_in0_pd_d1    <= interp_in0_pd_d0[16:0];
        interp_in_shift_d1  <= interp_in_shift_d0[5:0];
    end
  end
end

//>>16 proc for ((X1-X0)*frac) >>16
//assign interp_in_shift_abs[5:0] = interp_in_shift_d1[5] ? ((~interp_in_shift_d1[4:0])+5'd1): interp_in_shift_d1[5:0];
assign intp_in_shift_inv[4:0] = ~interp_in_shift_d1[4:0];
assign intp_in_shift_inv_inc[5:0] = intp_in_shift_inv[4:0] + 5'd1;
assign interp_in_shift_abs[5:0] = interp_in_shift_d1[5] ? intp_in_shift_inv_inc[5:0]: interp_in_shift_d1[5:0];
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
  nv_assert_never #(0,0,"CDP_out of range shifter abs shouldn't out of data range of signed-int6")      zzz_assert_never_1x (nvdla_op_gated_clk_int, `ASSERT_RESET, int_in_load_d1 & ((interp_in_shift_d1[5] & (interp_in_shift_abs > 6'd32)) | ((~interp_in_shift_d1[5]) & (interp_in_shift_abs > 6'd31)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//assign {int_mul_shift_int[87:0],int_mul_shift_frac[31:0]} = interp_in_shift_d1[5] ? {::sign_extend(int_mul,55:0,87:0),32'd0} << interp_in_shift_abs[5:0] : {::sign_extend(int_mul,55:0,87:0),32'd0} >> interp_in_shift_abs[5:0];
assign {int_mul_shift_int[87:0],int_mul_shift_frac[31:0]} = interp_in_shift_d1[5] ? {{{31{int_mul[56]}}, int_mul[56:0]},32'd0} << interp_in_shift_abs[5:0] : {{{31{int_mul[56]}}, int_mul[56:0]},32'd0} >> interp_in_shift_abs[5:0];

//rounding process for right shift
always @(
  int_mul_shift_int
  or int_mul_shift_frac
  ) begin
    //if(int_mul_shift_int[55]) begin
    if(int_mul_shift_int[56]) begin
        if(int_mul_shift_frac[31]) begin
            if(~(|int_mul_shift_frac[30:0]))
                int_mul_for_Rshift = {int_mul_shift_int[56],int_mul_shift_int[56:0]};
            else
                int_mul_for_Rshift = $signed(int_mul_shift_int[56:0]) + $signed({56'd0,1'b1});
        end else begin
            int_mul_for_Rshift = {int_mul_shift_int[56],int_mul_shift_int[56:0]};
        end
    end else begin
        int_mul_for_Rshift = $signed(int_mul_shift_int[56:0]) + $signed({56'd0,int_mul_shift_frac[31]});
    end
end
assign int_mul_rs[87:0] = interp_in_shift_d1[5] ? int_mul_shift_int[87:0] : ({{30{int_mul_for_Rshift[57]}}, int_mul_for_Rshift[57:0]});

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_vld_d1 <= 1'b0;
  end else begin
    if(int_vld_d0)
        int_vld_d1 <= 1'b1;
    else if(int_rdy_d1)
        int_vld_d1 <= 1'b0;
  end
end
assign int_rdy_d1 = ~int_vld_d2 | int_rdy_d2;
assign int_in_load_d1 = int_vld_d1 & int_rdy_d1;

//Xo = X0+[(X1-X0)*frac>>16]
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_add[88:0] <= {89{1'b0}};
  end else begin
    if(int_in_load_d1) begin
        int_add[88:0] <= $signed(int_mul_rs[87:0]) + $signed({{71{interp_in0_pd_d1[16]}}, interp_in0_pd_d1[16:0]});//{{40{interp_in0_pd_d1[16]}},interp_in0_pd_d1[16:0]});
    end
  end
end
//assign int_interp_out_pd[15:0] = int_add[88] ? (&int_add[88:15] ? {int_add[88],int_add[14:0]} : 16'h8000) : (|int_add[88:16] ? 16'h7fff : int_add[15:0]);
assign int_interp_out_pd[15:0] = int_add[88] ? (&int_add[88:15] ? {int_add[88],int_add[14:0]} : 16'h8000) : (|int_add[88:15] ? 16'h7fff : int_add[15:0]);

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_vld_d2 <= 1'b0;
  end else begin
    if(int_vld_d1)
        int_vld_d2 <= 1'b1;
    else if(int_rdy_d2)
        int_vld_d2 <= 1'b0;
  end
end
assign int_rdy_d2 = int_interp_out_rdy;

//slcg
//////
//////////////////////////////////////////////////////////////////////////////////////////////
//interperlator for fp16 mode
//////////////////////////////////////////////////////////////////////////////////////////////

//Xo = X0+(X1-X0)*frac>>16
assign fp_in_vld = fp16_en ? interp_in_vld : 1'b0;
assign fp_in_rdy = fp_sub_a_rdy & fp_sub_b_rdy & fp_sub_sync_in_rdy;
//assign fp_in_load = fp_in_vld & fp_in_rdy;

///////////////////
//X1-X0
assign fp_sub_a_vld = fp_in_vld & fp_sub_b_rdy & fp_sub_sync_in_rdy;
assign fp_sub_b_vld = fp_in_vld & fp_sub_a_rdy & fp_sub_sync_in_rdy;

HLS_fp32_sub u_fp_sub (
   .nvdla_core_clk          (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.chn_a_rsc_z             (interp_in1_pd[31:0])          //|< i
  ,.chn_a_rsc_vz            (fp_sub_a_vld)                 //|< w
  ,.chn_a_rsc_lz            (fp_sub_a_rdy)                 //|> w
  ,.chn_b_rsc_z             (interp_in0_pd[31:0])          //|< i
  ,.chn_b_rsc_vz            (fp_sub_b_vld)                 //|< w
  ,.chn_b_rsc_lz            (fp_sub_b_rdy)                 //|> w
  ,.chn_o_rsc_z             (fp_sub_out_pd[31:0])          //|> w
  ,.chn_o_rsc_vz            (fp_sub_out_rdy)               //|< w
  ,.chn_o_rsc_lz            (fp_sub_out_vld)               //|> w
  );
//fp32 - fp17
HLS_fp32_to_fp17 u_HLS_fp32_to_fp17 (
   .nvdla_core_clk          (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.chn_a_rsc_z             (fp_sub_out_pd[31:0])          //|< w
  ,.chn_a_rsc_vz            (fp_sub_out_vld)               //|< w
  ,.chn_a_rsc_lz            (fp_sub_out_rdy)               //|> w
  ,.chn_o_rsc_z             (fp_sub_o_pd[16:0])            //|> w
  ,.chn_o_rsc_vz            (fp_sub_o_rdy)                 //|< w
  ,.chn_o_rsc_lz            (fp_sub_o_vld)                 //|> w
  );

assign fp_sub_sync_in_vld = fp_in_vld & fp_sub_a_rdy & fp_sub_b_rdy;
assign fp_sub_sync_in_pd = {interp_in_pd[16:0],interp_in_scale[16:0]};

assign fp_sub_sync_in_vld_d0 = fp_sub_sync_in_vld;
assign fp_sub_sync_in_rdy = fp_sub_sync_in_rdy_d0;
assign fp_sub_sync_in_pd_d0[33:0] = fp_sub_sync_in_pd[33:0];
NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p1 pipe_p1 (
   .nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.fp_sub_sync_in_pd_d0    (fp_sub_sync_in_pd_d0[33:0])   //|< w
  ,.fp_sub_sync_in_rdy_d1   (fp_sub_sync_in_rdy_d1)        //|< w
  ,.fp_sub_sync_in_vld_d0   (fp_sub_sync_in_vld_d0)        //|< w
  ,.fp_sub_sync_in_pd_d1    (fp_sub_sync_in_pd_d1[33:0])   //|> w
  ,.fp_sub_sync_in_rdy_d0   (fp_sub_sync_in_rdy_d0)        //|> w
  ,.fp_sub_sync_in_vld_d1   (fp_sub_sync_in_vld_d1)        //|> w
  );
NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p2 pipe_p2 (
   .nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.fp_sub_sync_in_pd_d1    (fp_sub_sync_in_pd_d1[33:0])   //|< w
  ,.fp_sub_sync_in_rdy_d2   (fp_sub_sync_in_rdy_d2)        //|< w
  ,.fp_sub_sync_in_vld_d1   (fp_sub_sync_in_vld_d1)        //|< w
  ,.fp_sub_sync_in_pd_d2    (fp_sub_sync_in_pd_d2[33:0])   //|> w
  ,.fp_sub_sync_in_rdy_d1   (fp_sub_sync_in_rdy_d1)        //|> w
  ,.fp_sub_sync_in_vld_d2   (fp_sub_sync_in_vld_d2)        //|> w
  );
NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p3 pipe_p3 (
   .nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.fp_sub_sync_in_pd_d2    (fp_sub_sync_in_pd_d2[33:0])   //|< w
  ,.fp_sub_sync_in_rdy_d3   (fp_sub_sync_in_rdy_d3)        //|< w
  ,.fp_sub_sync_in_vld_d2   (fp_sub_sync_in_vld_d2)        //|< w
  ,.fp_sub_sync_in_pd_d3    (fp_sub_sync_in_pd_d3[33:0])   //|> w
  ,.fp_sub_sync_in_rdy_d2   (fp_sub_sync_in_rdy_d2)        //|> w
  ,.fp_sub_sync_in_vld_d3   (fp_sub_sync_in_vld_d3)        //|> w
  );
NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p4 pipe_p4 (
   .nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.fp_sub_sync_in_pd_d3    (fp_sub_sync_in_pd_d3[33:0])   //|< w
  ,.fp_sub_sync_in_rdy_d4   (fp_sub_sync_in_rdy_d4)        //|< w
  ,.fp_sub_sync_in_vld_d3   (fp_sub_sync_in_vld_d3)        //|< w
  ,.fp_sub_sync_in_pd_d4    (fp_sub_sync_in_pd_d4[33:0])   //|> w
  ,.fp_sub_sync_in_rdy_d3   (fp_sub_sync_in_rdy_d3)        //|> w
  ,.fp_sub_sync_in_vld_d4   (fp_sub_sync_in_vld_d4)        //|> w
  );
NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p5 pipe_p5 (
   .nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.fp_sub_sync_in_pd_d4    (fp_sub_sync_in_pd_d4[33:0])   //|< w
  ,.fp_sub_sync_in_rdy_d5   (fp_sub_sync_in_rdy_d5)        //|< w
  ,.fp_sub_sync_in_vld_d4   (fp_sub_sync_in_vld_d4)        //|< w
  ,.fp_sub_sync_in_pd_d5    (fp_sub_sync_in_pd_d5[33:0])   //|> w
  ,.fp_sub_sync_in_rdy_d4   (fp_sub_sync_in_rdy_d4)        //|> w
  ,.fp_sub_sync_in_vld_d5   (fp_sub_sync_in_vld_d5)        //|> w
  );
NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p6 pipe_p6 (
   .nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.fp_sub_sync_in_pd_d5    (fp_sub_sync_in_pd_d5[33:0])   //|< w
  ,.fp_sub_sync_in_rdy_d6   (fp_sub_sync_in_rdy_d6)        //|< w
  ,.fp_sub_sync_in_vld_d5   (fp_sub_sync_in_vld_d5)        //|< w
  ,.fp_sub_sync_in_pd_d6    (fp_sub_sync_in_pd_d6[33:0])   //|> w
  ,.fp_sub_sync_in_rdy_d5   (fp_sub_sync_in_rdy_d5)        //|> w
  ,.fp_sub_sync_in_vld_d6   (fp_sub_sync_in_vld_d6)        //|> w
  );
NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p7 pipe_p7 (
   .nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.fp_sub_sync_in_pd_d6    (fp_sub_sync_in_pd_d6[33:0])   //|< w
  ,.fp_sub_sync_in_rdy_d7   (fp_sub_sync_in_rdy_d7)        //|< w
  ,.fp_sub_sync_in_vld_d6   (fp_sub_sync_in_vld_d6)        //|< w
  ,.fp_sub_sync_in_pd_d7    (fp_sub_sync_in_pd_d7[33:0])   //|> w
  ,.fp_sub_sync_in_rdy_d6   (fp_sub_sync_in_rdy_d6)        //|> w
  ,.fp_sub_sync_in_vld_d7   (fp_sub_sync_in_vld_d7)        //|> w
  );
assign fp_sub_sync_out_vld = fp_sub_sync_in_vld_d7;
assign fp_sub_sync_in_rdy_d7 = fp_sub_sync_out_rdy;
assign fp_sub_sync_out_pd[33:0] = fp_sub_sync_in_pd_d7[33:0];

assign fp_interp_in0_pd_d0    = fp_sub_sync_out_pd[33:17];
assign fp_interp_in_offset_d0 = fp_sub_sync_out_pd[16:0];
assign fp_sub_o_rdy = fp_interp_rdy_d0 & fp_sub_sync_out_vld;
assign fp_sub_sync_out_rdy = fp_interp_rdy_d0 & fp_sub_o_vld;
assign fp_interp_vld_d0 = fp_sub_o_vld & fp_sub_sync_out_vld;

///////////////////
//(X1-X0)*frac
assign fp_interp_rdy_d0 = fp_mul_a_rdy & fp_mul_b_rdy & fp_mul_sync_in_rdy;

assign fp_mul_a_vld = fp_interp_vld_d0 & fp_mul_b_rdy & fp_mul_sync_in_rdy;
assign fp_mul_b_vld = fp_interp_vld_d0 & fp_mul_a_rdy & fp_mul_sync_in_rdy;
assign fp_mul_sync_in_vld = fp_interp_vld_d0 & fp_mul_b_rdy & fp_mul_a_rdy;

HLS_fp17_mul u_fp_mul (
   .nvdla_core_clk          (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.chn_a_rsc_z             (fp_sub_o_pd[16:0])            //|< w
  ,.chn_a_rsc_vz            (fp_mul_a_vld)                 //|< w
  ,.chn_a_rsc_lz            (fp_mul_a_rdy)                 //|> w
  ,.chn_b_rsc_z             (fp_interp_in_offset_d0[16:0]) //|< w
  ,.chn_b_rsc_vz            (fp_mul_b_vld)                 //|< w
  ,.chn_b_rsc_lz            (fp_mul_b_rdy)                 //|> w
  ,.chn_o_rsc_z             (fp_mul_out_pd[16:0])          //|> w
  ,.chn_o_rsc_vz            (fp_mul_out_rdy)               //|< w
  ,.chn_o_rsc_lz            (fp_mul_out_vld)               //|> w
  );

assign fp_mul_sync_in_pd = fp_interp_in0_pd_d0;

assign fp_mul_sync_in_vld_d0 = fp_mul_sync_in_vld;
assign fp_mul_sync_in_rdy = fp_mul_sync_in_rdy_d0;
assign fp_mul_sync_in_pd_d0[16:0] = fp_mul_sync_in_pd[16:0];
NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p8 pipe_p8 (
   .nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.fp_mul_sync_in_pd_d0    (fp_mul_sync_in_pd_d0[16:0])   //|< w
  ,.fp_mul_sync_in_rdy_d1   (fp_mul_sync_in_rdy_d1)        //|< w
  ,.fp_mul_sync_in_vld_d0   (fp_mul_sync_in_vld_d0)        //|< w
  ,.fp_mul_sync_in_pd_d1    (fp_mul_sync_in_pd_d1[16:0])   //|> w
  ,.fp_mul_sync_in_rdy_d0   (fp_mul_sync_in_rdy_d0)        //|> w
  ,.fp_mul_sync_in_vld_d1   (fp_mul_sync_in_vld_d1)        //|> w
  );
NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p9 pipe_p9 (
   .nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.fp_mul_sync_in_pd_d1    (fp_mul_sync_in_pd_d1[16:0])   //|< w
  ,.fp_mul_sync_in_rdy_d2   (fp_mul_sync_in_rdy_d2)        //|< w
  ,.fp_mul_sync_in_vld_d1   (fp_mul_sync_in_vld_d1)        //|< w
  ,.fp_mul_sync_in_pd_d2    (fp_mul_sync_in_pd_d2[16:0])   //|> w
  ,.fp_mul_sync_in_rdy_d1   (fp_mul_sync_in_rdy_d1)        //|> w
  ,.fp_mul_sync_in_vld_d2   (fp_mul_sync_in_vld_d2)        //|> w
  );
NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p10 pipe_p10 (
   .nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.fp_mul_sync_in_pd_d2    (fp_mul_sync_in_pd_d2[16:0])   //|< w
  ,.fp_mul_sync_in_rdy_d3   (fp_mul_sync_in_rdy_d3)        //|< w
  ,.fp_mul_sync_in_vld_d2   (fp_mul_sync_in_vld_d2)        //|< w
  ,.fp_mul_sync_in_pd_d3    (fp_mul_sync_in_pd_d3[16:0])   //|> w
  ,.fp_mul_sync_in_rdy_d2   (fp_mul_sync_in_rdy_d2)        //|> w
  ,.fp_mul_sync_in_vld_d3   (fp_mul_sync_in_vld_d3)        //|> w
  );
assign fp_mul_sync_out_vld = fp_mul_sync_in_vld_d3;
assign fp_mul_sync_in_rdy_d3 = fp_mul_sync_out_rdy;
assign fp_mul_sync_out_pd[16:0] = fp_mul_sync_in_pd_d3[16:0];

assign fp_interp_in0_pd_d1    = fp_mul_sync_out_pd[16:0];
assign fp_mul_out_rdy = fp_interp_rdy_d1 & fp_mul_sync_out_vld;
assign fp_mul_sync_out_rdy = fp_interp_rdy_d1 & fp_mul_out_vld;
assign fp_interp_vld_d1 = fp_mul_out_vld & fp_mul_sync_out_vld;

///////////////////
//X0+(X1-X0)*frac

assign fp_interp_rdy_d1 = fp_add_a_rdy & fp_add_b_rdy;

assign fp_add_a_vld = fp_interp_vld_d1 & fp_add_b_rdy;
assign fp_add_b_vld = fp_interp_vld_d1 & fp_add_a_rdy;
HLS_fp17_add u_fp_add (
   .nvdla_core_clk          (nvdla_op_gated_clk_fp16)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.chn_a_rsc_z             (fp_mul_out_pd[16:0])          //|< w
  ,.chn_a_rsc_vz            (fp_add_a_vld)                 //|< w
  ,.chn_a_rsc_lz            (fp_add_a_rdy)                 //|> w
  ,.chn_b_rsc_z             (fp_interp_in0_pd_d1[16:0])    //|< w
  ,.chn_b_rsc_vz            (fp_add_b_vld)                 //|< w
  ,.chn_b_rsc_lz            (fp_add_b_rdy)                 //|> w
  ,.chn_o_rsc_z             (fp_add_out_pd[16:0])          //|> w
  ,.chn_o_rsc_vz            (fp_add_out_rdy)               //|< w
  ,.chn_o_rsc_lz            (fp_add_out_vld)               //|> w
  );
///////////////////////////////////////////
assign int_interp_out_rdy = fp16_en ? 1'b1 : interp_out_rdy;
assign fp_add_out_rdy     = fp16_en ? interp_out_rdy : 1'b1;
///////////////////////////////////////////

assign interp_out_vld      = fp16_en ? fp_add_out_vld : int_vld_d2;
assign interp_out_pd[16:0] = fp16_en ? fp_add_out_pd  : {int_interp_out_pd[15],int_interp_out_pd[15:0]};

///////////////////////////////////////////
endmodule // NV_NVDLA_CDP_DP_INTP_unit



// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp_sub_sync_in_pd_d1[33:0] (fp_sub_sync_in_vld_d1,fp_sub_sync_in_rdy_d1) <= fp_sub_sync_in_pd_d0[33:0] (fp_sub_sync_in_vld_d0,fp_sub_sync_in_rdy_d0)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p1 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp_sub_sync_in_pd_d0
  ,fp_sub_sync_in_rdy_d1
  ,fp_sub_sync_in_vld_d0
  ,fp_sub_sync_in_pd_d1
  ,fp_sub_sync_in_rdy_d0
  ,fp_sub_sync_in_vld_d1
  );
input         nvdla_op_gated_clk_fp16;
input         nvdla_core_rstn;
input  [33:0] fp_sub_sync_in_pd_d0;
input         fp_sub_sync_in_rdy_d1;
input         fp_sub_sync_in_vld_d0;
output [33:0] fp_sub_sync_in_pd_d1;
output        fp_sub_sync_in_rdy_d0;
output        fp_sub_sync_in_vld_d1;
reg    [33:0] fp_sub_sync_in_pd_d1;
reg           fp_sub_sync_in_rdy_d0;
reg           fp_sub_sync_in_vld_d1;
reg    [33:0] p1_pipe_data;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
//## pipe (1) valid-ready-bubble-collapse
always @(
  p1_pipe_ready
  or p1_pipe_valid
  ) begin
  p1_pipe_ready_bc = p1_pipe_ready || !p1_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_valid <= 1'b0;
  end else begin
  p1_pipe_valid <= (p1_pipe_ready_bc)? fp_sub_sync_in_vld_d0 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && fp_sub_sync_in_vld_d0)? fp_sub_sync_in_pd_d0[33:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  fp_sub_sync_in_rdy_d0 = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or fp_sub_sync_in_rdy_d1
  or p1_pipe_data
  ) begin
  fp_sub_sync_in_vld_d1 = p1_pipe_valid;
  p1_pipe_ready = fp_sub_sync_in_rdy_d1;
  fp_sub_sync_in_pd_d1[33:0] = p1_pipe_data;
end
//## pipe (1) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p1_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp_sub_sync_in_vld_d1^fp_sub_sync_in_rdy_d1^fp_sub_sync_in_vld_d0^fp_sub_sync_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_3x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp_sub_sync_in_vld_d0 && !fp_sub_sync_in_rdy_d0), (fp_sub_sync_in_vld_d0), (fp_sub_sync_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp_sub_sync_in_pd_d2[33:0] (fp_sub_sync_in_vld_d2,fp_sub_sync_in_rdy_d2) <= fp_sub_sync_in_pd_d1[33:0] (fp_sub_sync_in_vld_d1,fp_sub_sync_in_rdy_d1)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p2 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp_sub_sync_in_pd_d1
  ,fp_sub_sync_in_rdy_d2
  ,fp_sub_sync_in_vld_d1
  ,fp_sub_sync_in_pd_d2
  ,fp_sub_sync_in_rdy_d1
  ,fp_sub_sync_in_vld_d2
  );
input         nvdla_op_gated_clk_fp16;
input         nvdla_core_rstn;
input  [33:0] fp_sub_sync_in_pd_d1;
input         fp_sub_sync_in_rdy_d2;
input         fp_sub_sync_in_vld_d1;
output [33:0] fp_sub_sync_in_pd_d2;
output        fp_sub_sync_in_rdy_d1;
output        fp_sub_sync_in_vld_d2;
reg    [33:0] fp_sub_sync_in_pd_d2;
reg           fp_sub_sync_in_rdy_d1;
reg           fp_sub_sync_in_vld_d2;
reg    [33:0] p2_pipe_data;
reg           p2_pipe_ready;
reg           p2_pipe_ready_bc;
reg           p2_pipe_valid;
//## pipe (2) valid-ready-bubble-collapse
always @(
  p2_pipe_ready
  or p2_pipe_valid
  ) begin
  p2_pipe_ready_bc = p2_pipe_ready || !p2_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? fp_sub_sync_in_vld_d1 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && fp_sub_sync_in_vld_d1)? fp_sub_sync_in_pd_d1[33:0] : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  fp_sub_sync_in_rdy_d1 = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or fp_sub_sync_in_rdy_d2
  or p2_pipe_data
  ) begin
  fp_sub_sync_in_vld_d2 = p2_pipe_valid;
  p2_pipe_ready = fp_sub_sync_in_rdy_d2;
  fp_sub_sync_in_pd_d2[33:0] = p2_pipe_data;
end
//## pipe (2) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p2_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp_sub_sync_in_vld_d2^fp_sub_sync_in_rdy_d2^fp_sub_sync_in_vld_d1^fp_sub_sync_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_5x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp_sub_sync_in_vld_d1 && !fp_sub_sync_in_rdy_d1), (fp_sub_sync_in_vld_d1), (fp_sub_sync_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp_sub_sync_in_pd_d3[33:0] (fp_sub_sync_in_vld_d3,fp_sub_sync_in_rdy_d3) <= fp_sub_sync_in_pd_d2[33:0] (fp_sub_sync_in_vld_d2,fp_sub_sync_in_rdy_d2)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p3 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp_sub_sync_in_pd_d2
  ,fp_sub_sync_in_rdy_d3
  ,fp_sub_sync_in_vld_d2
  ,fp_sub_sync_in_pd_d3
  ,fp_sub_sync_in_rdy_d2
  ,fp_sub_sync_in_vld_d3
  );
input         nvdla_op_gated_clk_fp16;
input         nvdla_core_rstn;
input  [33:0] fp_sub_sync_in_pd_d2;
input         fp_sub_sync_in_rdy_d3;
input         fp_sub_sync_in_vld_d2;
output [33:0] fp_sub_sync_in_pd_d3;
output        fp_sub_sync_in_rdy_d2;
output        fp_sub_sync_in_vld_d3;
reg    [33:0] fp_sub_sync_in_pd_d3;
reg           fp_sub_sync_in_rdy_d2;
reg           fp_sub_sync_in_vld_d3;
reg    [33:0] p3_pipe_data;
reg           p3_pipe_ready;
reg           p3_pipe_ready_bc;
reg           p3_pipe_valid;
//## pipe (3) valid-ready-bubble-collapse
always @(
  p3_pipe_ready
  or p3_pipe_valid
  ) begin
  p3_pipe_ready_bc = p3_pipe_ready || !p3_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_valid <= 1'b0;
  end else begin
  p3_pipe_valid <= (p3_pipe_ready_bc)? fp_sub_sync_in_vld_d2 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && fp_sub_sync_in_vld_d2)? fp_sub_sync_in_pd_d2[33:0] : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  fp_sub_sync_in_rdy_d2 = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or fp_sub_sync_in_rdy_d3
  or p3_pipe_data
  ) begin
  fp_sub_sync_in_vld_d3 = p3_pipe_valid;
  p3_pipe_ready = fp_sub_sync_in_rdy_d3;
  fp_sub_sync_in_pd_d3[33:0] = p3_pipe_data;
end
//## pipe (3) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p3_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp_sub_sync_in_vld_d3^fp_sub_sync_in_rdy_d3^fp_sub_sync_in_vld_d2^fp_sub_sync_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_7x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp_sub_sync_in_vld_d2 && !fp_sub_sync_in_rdy_d2), (fp_sub_sync_in_vld_d2), (fp_sub_sync_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp_sub_sync_in_pd_d4[33:0] (fp_sub_sync_in_vld_d4,fp_sub_sync_in_rdy_d4) <= fp_sub_sync_in_pd_d3[33:0] (fp_sub_sync_in_vld_d3,fp_sub_sync_in_rdy_d3)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p4 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp_sub_sync_in_pd_d3
  ,fp_sub_sync_in_rdy_d4
  ,fp_sub_sync_in_vld_d3
  ,fp_sub_sync_in_pd_d4
  ,fp_sub_sync_in_rdy_d3
  ,fp_sub_sync_in_vld_d4
  );
input         nvdla_op_gated_clk_fp16;
input         nvdla_core_rstn;
input  [33:0] fp_sub_sync_in_pd_d3;
input         fp_sub_sync_in_rdy_d4;
input         fp_sub_sync_in_vld_d3;
output [33:0] fp_sub_sync_in_pd_d4;
output        fp_sub_sync_in_rdy_d3;
output        fp_sub_sync_in_vld_d4;
reg    [33:0] fp_sub_sync_in_pd_d4;
reg           fp_sub_sync_in_rdy_d3;
reg           fp_sub_sync_in_vld_d4;
reg    [33:0] p4_pipe_data;
reg           p4_pipe_ready;
reg           p4_pipe_ready_bc;
reg           p4_pipe_valid;
//## pipe (4) valid-ready-bubble-collapse
always @(
  p4_pipe_ready
  or p4_pipe_valid
  ) begin
  p4_pipe_ready_bc = p4_pipe_ready || !p4_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_valid <= 1'b0;
  end else begin
  p4_pipe_valid <= (p4_pipe_ready_bc)? fp_sub_sync_in_vld_d3 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && fp_sub_sync_in_vld_d3)? fp_sub_sync_in_pd_d3[33:0] : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  fp_sub_sync_in_rdy_d3 = p4_pipe_ready_bc;
end
//## pipe (4) output
always @(
  p4_pipe_valid
  or fp_sub_sync_in_rdy_d4
  or p4_pipe_data
  ) begin
  fp_sub_sync_in_vld_d4 = p4_pipe_valid;
  p4_pipe_ready = fp_sub_sync_in_rdy_d4;
  fp_sub_sync_in_pd_d4[33:0] = p4_pipe_data;
end
//## pipe (4) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p4_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp_sub_sync_in_vld_d4^fp_sub_sync_in_rdy_d4^fp_sub_sync_in_vld_d3^fp_sub_sync_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_9x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp_sub_sync_in_vld_d3 && !fp_sub_sync_in_rdy_d3), (fp_sub_sync_in_vld_d3), (fp_sub_sync_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p4




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp_sub_sync_in_pd_d5[33:0] (fp_sub_sync_in_vld_d5,fp_sub_sync_in_rdy_d5) <= fp_sub_sync_in_pd_d4[33:0] (fp_sub_sync_in_vld_d4,fp_sub_sync_in_rdy_d4)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p5 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp_sub_sync_in_pd_d4
  ,fp_sub_sync_in_rdy_d5
  ,fp_sub_sync_in_vld_d4
  ,fp_sub_sync_in_pd_d5
  ,fp_sub_sync_in_rdy_d4
  ,fp_sub_sync_in_vld_d5
  );
input         nvdla_op_gated_clk_fp16;
input         nvdla_core_rstn;
input  [33:0] fp_sub_sync_in_pd_d4;
input         fp_sub_sync_in_rdy_d5;
input         fp_sub_sync_in_vld_d4;
output [33:0] fp_sub_sync_in_pd_d5;
output        fp_sub_sync_in_rdy_d4;
output        fp_sub_sync_in_vld_d5;
reg    [33:0] fp_sub_sync_in_pd_d5;
reg           fp_sub_sync_in_rdy_d4;
reg           fp_sub_sync_in_vld_d5;
reg    [33:0] p5_pipe_data;
reg           p5_pipe_ready;
reg           p5_pipe_ready_bc;
reg           p5_pipe_valid;
//## pipe (5) valid-ready-bubble-collapse
always @(
  p5_pipe_ready
  or p5_pipe_valid
  ) begin
  p5_pipe_ready_bc = p5_pipe_ready || !p5_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_pipe_valid <= 1'b0;
  end else begin
  p5_pipe_valid <= (p5_pipe_ready_bc)? fp_sub_sync_in_vld_d4 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p5_pipe_data <= (p5_pipe_ready_bc && fp_sub_sync_in_vld_d4)? fp_sub_sync_in_pd_d4[33:0] : p5_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p5_pipe_ready_bc
  ) begin
  fp_sub_sync_in_rdy_d4 = p5_pipe_ready_bc;
end
//## pipe (5) output
always @(
  p5_pipe_valid
  or fp_sub_sync_in_rdy_d5
  or p5_pipe_data
  ) begin
  fp_sub_sync_in_vld_d5 = p5_pipe_valid;
  p5_pipe_ready = fp_sub_sync_in_rdy_d5;
  fp_sub_sync_in_pd_d5[33:0] = p5_pipe_data;
end
//## pipe (5) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p5_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp_sub_sync_in_vld_d5^fp_sub_sync_in_rdy_d5^fp_sub_sync_in_vld_d4^fp_sub_sync_in_rdy_d4)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_11x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp_sub_sync_in_vld_d4 && !fp_sub_sync_in_rdy_d4), (fp_sub_sync_in_vld_d4), (fp_sub_sync_in_rdy_d4)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p5




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp_sub_sync_in_pd_d6[33:0] (fp_sub_sync_in_vld_d6,fp_sub_sync_in_rdy_d6) <= fp_sub_sync_in_pd_d5[33:0] (fp_sub_sync_in_vld_d5,fp_sub_sync_in_rdy_d5)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p6 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp_sub_sync_in_pd_d5
  ,fp_sub_sync_in_rdy_d6
  ,fp_sub_sync_in_vld_d5
  ,fp_sub_sync_in_pd_d6
  ,fp_sub_sync_in_rdy_d5
  ,fp_sub_sync_in_vld_d6
  );
input         nvdla_op_gated_clk_fp16;
input         nvdla_core_rstn;
input  [33:0] fp_sub_sync_in_pd_d5;
input         fp_sub_sync_in_rdy_d6;
input         fp_sub_sync_in_vld_d5;
output [33:0] fp_sub_sync_in_pd_d6;
output        fp_sub_sync_in_rdy_d5;
output        fp_sub_sync_in_vld_d6;
reg    [33:0] fp_sub_sync_in_pd_d6;
reg           fp_sub_sync_in_rdy_d5;
reg           fp_sub_sync_in_vld_d6;
reg    [33:0] p6_pipe_data;
reg           p6_pipe_ready;
reg           p6_pipe_ready_bc;
reg           p6_pipe_valid;
//## pipe (6) valid-ready-bubble-collapse
always @(
  p6_pipe_ready
  or p6_pipe_valid
  ) begin
  p6_pipe_ready_bc = p6_pipe_ready || !p6_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p6_pipe_valid <= 1'b0;
  end else begin
  p6_pipe_valid <= (p6_pipe_ready_bc)? fp_sub_sync_in_vld_d5 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p6_pipe_data <= (p6_pipe_ready_bc && fp_sub_sync_in_vld_d5)? fp_sub_sync_in_pd_d5[33:0] : p6_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p6_pipe_ready_bc
  ) begin
  fp_sub_sync_in_rdy_d5 = p6_pipe_ready_bc;
end
//## pipe (6) output
always @(
  p6_pipe_valid
  or fp_sub_sync_in_rdy_d6
  or p6_pipe_data
  ) begin
  fp_sub_sync_in_vld_d6 = p6_pipe_valid;
  p6_pipe_ready = fp_sub_sync_in_rdy_d6;
  fp_sub_sync_in_pd_d6[33:0] = p6_pipe_data;
end
//## pipe (6) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p6_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp_sub_sync_in_vld_d6^fp_sub_sync_in_rdy_d6^fp_sub_sync_in_vld_d5^fp_sub_sync_in_rdy_d5)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_13x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp_sub_sync_in_vld_d5 && !fp_sub_sync_in_rdy_d5), (fp_sub_sync_in_vld_d5), (fp_sub_sync_in_rdy_d5)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p6




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp_sub_sync_in_pd_d7[33:0] (fp_sub_sync_in_vld_d7,fp_sub_sync_in_rdy_d7) <= fp_sub_sync_in_pd_d6[33:0] (fp_sub_sync_in_vld_d6,fp_sub_sync_in_rdy_d6)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p7 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp_sub_sync_in_pd_d6
  ,fp_sub_sync_in_rdy_d7
  ,fp_sub_sync_in_vld_d6
  ,fp_sub_sync_in_pd_d7
  ,fp_sub_sync_in_rdy_d6
  ,fp_sub_sync_in_vld_d7
  );
input         nvdla_op_gated_clk_fp16;
input         nvdla_core_rstn;
input  [33:0] fp_sub_sync_in_pd_d6;
input         fp_sub_sync_in_rdy_d7;
input         fp_sub_sync_in_vld_d6;
output [33:0] fp_sub_sync_in_pd_d7;
output        fp_sub_sync_in_rdy_d6;
output        fp_sub_sync_in_vld_d7;
reg    [33:0] fp_sub_sync_in_pd_d7;
reg           fp_sub_sync_in_rdy_d6;
reg           fp_sub_sync_in_vld_d7;
reg    [33:0] p7_pipe_data;
reg           p7_pipe_ready;
reg           p7_pipe_ready_bc;
reg           p7_pipe_valid;
//## pipe (7) valid-ready-bubble-collapse
always @(
  p7_pipe_ready
  or p7_pipe_valid
  ) begin
  p7_pipe_ready_bc = p7_pipe_ready || !p7_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p7_pipe_valid <= 1'b0;
  end else begin
  p7_pipe_valid <= (p7_pipe_ready_bc)? fp_sub_sync_in_vld_d6 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p7_pipe_data <= (p7_pipe_ready_bc && fp_sub_sync_in_vld_d6)? fp_sub_sync_in_pd_d6[33:0] : p7_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p7_pipe_ready_bc
  ) begin
  fp_sub_sync_in_rdy_d6 = p7_pipe_ready_bc;
end
//## pipe (7) output
always @(
  p7_pipe_valid
  or fp_sub_sync_in_rdy_d7
  or p7_pipe_data
  ) begin
  fp_sub_sync_in_vld_d7 = p7_pipe_valid;
  p7_pipe_ready = fp_sub_sync_in_rdy_d7;
  fp_sub_sync_in_pd_d7[33:0] = p7_pipe_data;
end
//## pipe (7) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p7_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp_sub_sync_in_vld_d7^fp_sub_sync_in_rdy_d7^fp_sub_sync_in_vld_d6^fp_sub_sync_in_rdy_d6)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_15x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp_sub_sync_in_vld_d6 && !fp_sub_sync_in_rdy_d6), (fp_sub_sync_in_vld_d6), (fp_sub_sync_in_rdy_d6)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p7




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp_mul_sync_in_pd_d1[16:0] (fp_mul_sync_in_vld_d1,fp_mul_sync_in_rdy_d1) <= fp_mul_sync_in_pd_d0[16:0] (fp_mul_sync_in_vld_d0,fp_mul_sync_in_rdy_d0)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p8 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp_mul_sync_in_pd_d0
  ,fp_mul_sync_in_rdy_d1
  ,fp_mul_sync_in_vld_d0
  ,fp_mul_sync_in_pd_d1
  ,fp_mul_sync_in_rdy_d0
  ,fp_mul_sync_in_vld_d1
  );
input         nvdla_op_gated_clk_fp16;
input         nvdla_core_rstn;
input  [16:0] fp_mul_sync_in_pd_d0;
input         fp_mul_sync_in_rdy_d1;
input         fp_mul_sync_in_vld_d0;
output [16:0] fp_mul_sync_in_pd_d1;
output        fp_mul_sync_in_rdy_d0;
output        fp_mul_sync_in_vld_d1;
reg    [16:0] fp_mul_sync_in_pd_d1;
reg           fp_mul_sync_in_rdy_d0;
reg           fp_mul_sync_in_vld_d1;
reg    [16:0] p8_pipe_data;
reg           p8_pipe_ready;
reg           p8_pipe_ready_bc;
reg           p8_pipe_valid;
//## pipe (8) valid-ready-bubble-collapse
always @(
  p8_pipe_ready
  or p8_pipe_valid
  ) begin
  p8_pipe_ready_bc = p8_pipe_ready || !p8_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p8_pipe_valid <= 1'b0;
  end else begin
  p8_pipe_valid <= (p8_pipe_ready_bc)? fp_mul_sync_in_vld_d0 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p8_pipe_data <= (p8_pipe_ready_bc && fp_mul_sync_in_vld_d0)? fp_mul_sync_in_pd_d0[16:0] : p8_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p8_pipe_ready_bc
  ) begin
  fp_mul_sync_in_rdy_d0 = p8_pipe_ready_bc;
end
//## pipe (8) output
always @(
  p8_pipe_valid
  or fp_mul_sync_in_rdy_d1
  or p8_pipe_data
  ) begin
  fp_mul_sync_in_vld_d1 = p8_pipe_valid;
  p8_pipe_ready = fp_mul_sync_in_rdy_d1;
  fp_mul_sync_in_pd_d1[16:0] = p8_pipe_data;
end
//## pipe (8) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p8_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp_mul_sync_in_vld_d1^fp_mul_sync_in_rdy_d1^fp_mul_sync_in_vld_d0^fp_mul_sync_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_17x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp_mul_sync_in_vld_d0 && !fp_mul_sync_in_rdy_d0), (fp_mul_sync_in_vld_d0), (fp_mul_sync_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p8




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp_mul_sync_in_pd_d2[16:0] (fp_mul_sync_in_vld_d2,fp_mul_sync_in_rdy_d2) <= fp_mul_sync_in_pd_d1[16:0] (fp_mul_sync_in_vld_d1,fp_mul_sync_in_rdy_d1)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p9 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp_mul_sync_in_pd_d1
  ,fp_mul_sync_in_rdy_d2
  ,fp_mul_sync_in_vld_d1
  ,fp_mul_sync_in_pd_d2
  ,fp_mul_sync_in_rdy_d1
  ,fp_mul_sync_in_vld_d2
  );
input         nvdla_op_gated_clk_fp16;
input         nvdla_core_rstn;
input  [16:0] fp_mul_sync_in_pd_d1;
input         fp_mul_sync_in_rdy_d2;
input         fp_mul_sync_in_vld_d1;
output [16:0] fp_mul_sync_in_pd_d2;
output        fp_mul_sync_in_rdy_d1;
output        fp_mul_sync_in_vld_d2;
reg    [16:0] fp_mul_sync_in_pd_d2;
reg           fp_mul_sync_in_rdy_d1;
reg           fp_mul_sync_in_vld_d2;
reg    [16:0] p9_pipe_data;
reg           p9_pipe_ready;
reg           p9_pipe_ready_bc;
reg           p9_pipe_valid;
//## pipe (9) valid-ready-bubble-collapse
always @(
  p9_pipe_ready
  or p9_pipe_valid
  ) begin
  p9_pipe_ready_bc = p9_pipe_ready || !p9_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p9_pipe_valid <= 1'b0;
  end else begin
  p9_pipe_valid <= (p9_pipe_ready_bc)? fp_mul_sync_in_vld_d1 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p9_pipe_data <= (p9_pipe_ready_bc && fp_mul_sync_in_vld_d1)? fp_mul_sync_in_pd_d1[16:0] : p9_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p9_pipe_ready_bc
  ) begin
  fp_mul_sync_in_rdy_d1 = p9_pipe_ready_bc;
end
//## pipe (9) output
always @(
  p9_pipe_valid
  or fp_mul_sync_in_rdy_d2
  or p9_pipe_data
  ) begin
  fp_mul_sync_in_vld_d2 = p9_pipe_valid;
  p9_pipe_ready = fp_mul_sync_in_rdy_d2;
  fp_mul_sync_in_pd_d2[16:0] = p9_pipe_data;
end
//## pipe (9) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p9_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp_mul_sync_in_vld_d2^fp_mul_sync_in_rdy_d2^fp_mul_sync_in_vld_d1^fp_mul_sync_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_19x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp_mul_sync_in_vld_d1 && !fp_mul_sync_in_rdy_d1), (fp_mul_sync_in_vld_d1), (fp_mul_sync_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p9




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp_mul_sync_in_pd_d3[16:0] (fp_mul_sync_in_vld_d3,fp_mul_sync_in_rdy_d3) <= fp_mul_sync_in_pd_d2[16:0] (fp_mul_sync_in_vld_d2,fp_mul_sync_in_rdy_d2)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p10 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp_mul_sync_in_pd_d2
  ,fp_mul_sync_in_rdy_d3
  ,fp_mul_sync_in_vld_d2
  ,fp_mul_sync_in_pd_d3
  ,fp_mul_sync_in_rdy_d2
  ,fp_mul_sync_in_vld_d3
  );
input         nvdla_op_gated_clk_fp16;
input         nvdla_core_rstn;
input  [16:0] fp_mul_sync_in_pd_d2;
input         fp_mul_sync_in_rdy_d3;
input         fp_mul_sync_in_vld_d2;
output [16:0] fp_mul_sync_in_pd_d3;
output        fp_mul_sync_in_rdy_d2;
output        fp_mul_sync_in_vld_d3;
reg    [16:0] fp_mul_sync_in_pd_d3;
reg           fp_mul_sync_in_rdy_d2;
reg           fp_mul_sync_in_vld_d3;
reg    [16:0] p10_pipe_data;
reg           p10_pipe_ready;
reg           p10_pipe_ready_bc;
reg           p10_pipe_valid;
//## pipe (10) valid-ready-bubble-collapse
always @(
  p10_pipe_ready
  or p10_pipe_valid
  ) begin
  p10_pipe_ready_bc = p10_pipe_ready || !p10_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p10_pipe_valid <= 1'b0;
  end else begin
  p10_pipe_valid <= (p10_pipe_ready_bc)? fp_mul_sync_in_vld_d2 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p10_pipe_data <= (p10_pipe_ready_bc && fp_mul_sync_in_vld_d2)? fp_mul_sync_in_pd_d2[16:0] : p10_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p10_pipe_ready_bc
  ) begin
  fp_mul_sync_in_rdy_d2 = p10_pipe_ready_bc;
end
//## pipe (10) output
always @(
  p10_pipe_valid
  or fp_mul_sync_in_rdy_d3
  or p10_pipe_data
  ) begin
  fp_mul_sync_in_vld_d3 = p10_pipe_valid;
  p10_pipe_ready = fp_mul_sync_in_rdy_d3;
  fp_mul_sync_in_pd_d3[16:0] = p10_pipe_data;
end
//## pipe (10) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p10_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp_mul_sync_in_vld_d3^fp_mul_sync_in_rdy_d3^fp_mul_sync_in_vld_d2^fp_mul_sync_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_21x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp_mul_sync_in_vld_d2 && !fp_mul_sync_in_rdy_d2), (fp_mul_sync_in_vld_d2), (fp_mul_sync_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDP_DP_INTP_UNIT_pipe_p10



