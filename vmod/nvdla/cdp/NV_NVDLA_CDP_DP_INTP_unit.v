// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_INTP_unit.v

module NV_NVDLA_CDP_DP_INTP_unit (
   nvdla_core_clk  
  ,nvdla_core_rstn
  ,interp_in0_pd  
  ,interp_in1_pd  
  ,interp_in_pd   
  ,interp_in_scale
  ,interp_in_shift
  ,interp_in_vld  
  ,interp_out_rdy 
  ,interp_in_rdy  
  ,interp_out_pd  
  ,interp_out_vld 
  );
/////////////////////////////////////////////////////////////////
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [38:0] interp_in0_pd;
input  [37:0] interp_in1_pd;
input  [16:0] interp_in_pd;
input  [16:0] interp_in_scale;
input   [5:0] interp_in_shift;
input         interp_in_vld;
input         interp_out_rdy;
output        interp_in_rdy;
output [16:0] interp_out_pd;
output        interp_out_vld;
/////////////////////////////////////////////////////////////////
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
wire          int_in_load;
wire          int_in_load_d0;
wire          int_in_load_d1;
wire          int_in_rdy;
wire          int_in_vld;
wire   [15:0] int_interp_out_pd;
wire   [87:0] int_mul_rs;
wire   [31:0] int_mul_shift_frac;
wire   [87:0] int_mul_shift_int;
wire          int_rdy_d0;
wire          int_rdy_d1;
wire          int_rdy_d2;
wire    [5:0] interp_in_shift_abs;
wire    [4:0] intp_in_shift_inv;
wire    [5:0] intp_in_shift_inv_inc;
/////////////////////////////////////////////////////////////////
///////////////////////////////////////////
//interp_in_vld
assign interp_in_rdy = int_in_rdy;
///////////////////////////////////////////
assign int_in_vld = interp_in_vld;
assign int_in_rdy = ~int_vld_d0 | int_rdy_d0;
assign int_in_load = int_in_vld & int_in_rdy;

///////////////////
//X1-X0
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_sub[39:0] <= {40{1'b0}};
    interp_in0_pd_d0 <= {17{1'b0}};
    interp_in_offset_d0 <= {17{1'b0}};
    interp_in_shift_d0 <= {6{1'b0}};
  end else begin
    if(int_in_load) begin
        int_sub[39:0] <= $signed({interp_in1_pd[37],interp_in1_pd[37:0]}) - $signed(interp_in0_pd[38:0]);
        interp_in0_pd_d0    <= interp_in_pd[16:0];
        interp_in_offset_d0 <= interp_in_scale[16:0];
        interp_in_shift_d0  <= interp_in_shift[5:0];
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_mul[56:0] <= {57{1'b0}};
    interp_in0_pd_d1 <= {17{1'b0}};
    interp_in_shift_d1 <= {6{1'b0}};
  end else begin
    if(int_in_load_d0) begin
        int_mul[56:0] <= $signed(int_sub[39:0]) * $signed(interp_in_offset_d0);
        interp_in0_pd_d1    <= interp_in0_pd_d0[16:0];
        interp_in_shift_d1  <= interp_in_shift_d0[5:0];
    end
  end
end

//>>16 proc for ((X1-X0)*frac) >>16
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
  nv_assert_never #(0,0,"CDP_out of range shifter abs shouldn't out of data range of signed-int6")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, int_in_load_d1 & ((interp_in_shift_d1[5] & (interp_in_shift_abs > 6'd32)) | ((~interp_in_shift_d1[5]) & (interp_in_shift_abs > 6'd31)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_add[88:0] <= {89{1'b0}};
  end else begin
    if(int_in_load_d1) begin
        int_add[88:0] <= $signed(int_mul_rs[87:0]) + $signed({{71{interp_in0_pd_d1[16]}}, interp_in0_pd_d1[16:0]});
    end
  end
end
assign int_interp_out_pd[15:0] = int_add[88] ? (&int_add[88:15] ? {int_add[88],int_add[14:0]} : 16'h8000) : (|int_add[88:15] ? 16'h7fff : int_add[15:0]);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_vld_d2 <= 1'b0;
  end else begin
    if(int_vld_d1)
        int_vld_d2 <= 1'b1;
    else if(int_rdy_d2)
        int_vld_d2 <= 1'b0;
  end
end
assign int_rdy_d2 = interp_out_rdy;

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
assign interp_out_vld      =  int_vld_d2;
assign interp_out_pd[16:0] =  {int_interp_out_pd[15],int_interp_out_pd[15:0]};

///////////////////////////////////////////
endmodule // NV_NVDLA_CDP_DP_INTP_unit

