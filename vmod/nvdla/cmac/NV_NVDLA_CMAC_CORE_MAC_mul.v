// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CMAC_CORE_MAC_mul.v

module NV_NVDLA_CMAC_CORE_MAC_mul (
   nvdla_core_clk  //|< i
  ,nvdla_core_rstn //|< i
  ,cfg_is_fp16     //|< i
  ,cfg_is_int8     //|< i
  ,cfg_reg_en      //|< i
  ,exp_sft         //|< i
  ,op_a_dat        //|< i
  ,op_a_nz         //|< i
  ,op_a_pvld       //|< i
  ,op_b_dat        //|< i
  ,op_b_nz         //|< i
  ,op_b_pvld       //|< i
  ,res_a           //|> o
  ,res_b           //|> o
  ,res_tag         //|> o
  );

input          nvdla_core_clk;
input          nvdla_core_rstn;
input          cfg_is_fp16;
input          cfg_is_int8;
input          cfg_reg_en;
input    [3:0] exp_sft;
input   [15:0] op_a_dat;
input    [1:0] op_a_nz;
input          op_a_pvld;
input   [15:0] op_b_dat;
input    [1:0] op_b_nz;
input          op_b_pvld;
output  [31:0] res_a;
output  [31:0] res_b;
output   [7:0] res_tag;
wire    [23:0] pp_out_l0n0_0;
wire    [23:0] pp_out_l0n0_1;
wire    [23:0] pp_out_l0n1_0;
wire    [23:0] pp_out_l0n1_1;
wire    [31:0] pp_out_l1n0_0;
wire    [31:0] pp_out_l1n0_1;
wire    [16:0] sel_data_0;
wire    [16:0] sel_data_1;
wire    [16:0] sel_data_2;
wire    [16:0] sel_data_3;
wire    [16:0] sel_data_4;
wire    [16:0] sel_data_5;
wire    [16:0] sel_data_6;
wire    [16:0] sel_data_7;
wire           sel_inv_0;
wire           sel_inv_1;
wire           sel_inv_2;
wire           sel_inv_3;
wire           sel_inv_4;
wire           sel_inv_5;
wire           sel_inv_6;
wire           sel_inv_7;
reg      [3:0] cfg_is_fp16_d1;
reg            cfg_is_int8_d1;
reg      [2:0] code_0;
reg      [2:0] code_1;
reg      [2:0] code_2;
reg      [2:0] code_3;
reg      [2:0] code_4;
reg      [2:0] code_5;
reg      [2:0] code_6;
reg      [2:0] code_7;
reg      [8:0] code_hi;
reg      [8:0] code_lo;
reg            fp16_sign;
reg     [15:0] op_a_cur_dat;
reg     [15:0] op_b_cur_dat;
reg      [1:0] op_out_pvld;
reg     [31:0] pp_fp16_0_sft;
reg     [31:0] pp_fp16_1_sft;
reg    [119:0] pp_in_l0n0;
reg    [119:0] pp_in_l0n1;
reg    [127:0] pp_in_l1n0;
reg      [7:0] pp_sign_tag;
reg     [23:0] ppre_0;
reg     [23:0] ppre_1;
reg     [23:0] ppre_2;
reg     [23:0] ppre_3;
reg     [23:0] ppre_4;
reg     [23:0] ppre_5;
reg     [23:0] ppre_6;
reg     [23:0] ppre_7;
reg     [23:0] ppre_8;
reg     [23:0] ppre_9;
reg     [31:0] res_a;
reg     [31:0] res_a_gate;
reg     [31:0] res_a_ori;
reg     [31:0] res_b;
reg     [31:0] res_b_gate;
reg     [31:0] res_b_ori;
reg     [15:0] src_data_0;
reg     [15:0] src_data_1;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//==========================================================
// Config logic
//==========================================================

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_is_int8_d1 <= 1'b0;
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_is_int8_d1 <= cfg_is_int8;
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_is_int8_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_is_fp16_d1 <= {4{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_is_fp16_d1 <= {4{cfg_is_fp16}};
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_is_fp16_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==========================================================
// Control logic
//==========================================================

always @(
  op_a_pvld
  or op_b_pvld
  or op_a_nz
  or op_b_nz
  ) begin
    op_out_pvld[1] = op_a_pvld & op_b_pvld & op_a_nz[1] & op_b_nz[1];
    op_out_pvld[0] = op_a_pvld & op_b_pvld & op_a_nz[0] & op_b_nz[0];
end

always @(
  cfg_is_fp16_d1
  or op_a_dat
  or op_b_dat
  ) begin
    op_a_cur_dat = {(~cfg_is_fp16_d1[0] & op_a_dat[15]), op_a_dat[14:0]};
    op_b_cur_dat = {(~cfg_is_fp16_d1[0] & op_b_dat[15]), op_b_dat[14:0]};
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! op_out_pvld not match!")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (~cfg_is_int8_d1 & (op_out_pvld[0] ^ op_out_pvld[1]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==========================================================
// Booth recoding and selection, radix-4
//==========================================================

always @(
  op_a_cur_dat
  ) begin
    code_lo = {op_a_cur_dat[7:0], 1'b0};
end

always @(
  cfg_is_int8_d1
  or op_a_cur_dat
  ) begin
    code_hi = cfg_is_int8_d1 ? {op_a_cur_dat[15:8], 1'b0} :
              op_a_cur_dat[15:7];
end

always @(
  code_lo
  ) begin
    code_0 = code_lo[2:0];
    code_1 = code_lo[4:2];
    code_2 = code_lo[6:4];
    code_3 = code_lo[8:6];
end

always @(
  code_hi
  ) begin
    code_4 = code_hi[2:0];
    code_5 = code_hi[4:2];
    code_6 = code_hi[6:4];
    code_7 = code_hi[8:6];
end

always @(
  cfg_is_int8_d1
  or op_b_cur_dat
  ) begin
    src_data_0 = cfg_is_int8_d1 ? {8'b0, op_b_cur_dat[7:0]} : op_b_cur_dat;
    src_data_1 = cfg_is_int8_d1 ? {8'b0, op_b_cur_dat[15:8]} : op_b_cur_dat;
end

always @(
  cfg_is_fp16_d1
  or op_a_dat
  or op_b_dat
  ) begin
    fp16_sign = (cfg_is_fp16_d1[1] & (op_a_dat[15] ^ op_b_dat[15]));
end


NV_NVDLA_CMAC_CORE_MAC_booth u_booth_0 (
   .code     (code_0[2:0])         //|< r
  ,.is_8bit  (cfg_is_int8_d1)      //|< r
  ,.sign     (fp16_sign)           //|< r
  ,.src_data (src_data_0[15:0])    //|< r
  ,.out_data (sel_data_0[16:0])    //|> w
  ,.out_inv  (sel_inv_0)           //|> w
  );


NV_NVDLA_CMAC_CORE_MAC_booth u_booth_1 (
   .code     (code_1[2:0])         //|< r
  ,.is_8bit  (cfg_is_int8_d1)      //|< r
  ,.sign     (fp16_sign)           //|< r
  ,.src_data (src_data_0[15:0])    //|< r
  ,.out_data (sel_data_1[16:0])    //|> w
  ,.out_inv  (sel_inv_1)           //|> w
  );


NV_NVDLA_CMAC_CORE_MAC_booth u_booth_2 (
   .code     (code_2[2:0])         //|< r
  ,.is_8bit  (cfg_is_int8_d1)      //|< r
  ,.sign     (fp16_sign)           //|< r
  ,.src_data (src_data_0[15:0])    //|< r
  ,.out_data (sel_data_2[16:0])    //|> w
  ,.out_inv  (sel_inv_2)           //|> w
  );


NV_NVDLA_CMAC_CORE_MAC_booth u_booth_3 (
   .code     (code_3[2:0])         //|< r
  ,.is_8bit  (cfg_is_int8_d1)      //|< r
  ,.sign     (fp16_sign)           //|< r
  ,.src_data (src_data_0[15:0])    //|< r
  ,.out_data (sel_data_3[16:0])    //|> w
  ,.out_inv  (sel_inv_3)           //|> w
  );


NV_NVDLA_CMAC_CORE_MAC_booth u_booth_4 (
   .code     (code_4[2:0])         //|< r
  ,.is_8bit  (cfg_is_int8_d1)      //|< r
  ,.sign     (fp16_sign)           //|< r
  ,.src_data (src_data_1[15:0])    //|< r
  ,.out_data (sel_data_4[16:0])    //|> w
  ,.out_inv  (sel_inv_4)           //|> w
  );


NV_NVDLA_CMAC_CORE_MAC_booth u_booth_5 (
   .code     (code_5[2:0])         //|< r
  ,.is_8bit  (cfg_is_int8_d1)      //|< r
  ,.sign     (fp16_sign)           //|< r
  ,.src_data (src_data_1[15:0])    //|< r
  ,.out_data (sel_data_5[16:0])    //|> w
  ,.out_inv  (sel_inv_5)           //|> w
  );


NV_NVDLA_CMAC_CORE_MAC_booth u_booth_6 (
   .code     (code_6[2:0])         //|< r
  ,.is_8bit  (cfg_is_int8_d1)      //|< r
  ,.sign     (fp16_sign)           //|< r
  ,.src_data (src_data_1[15:0])    //|< r
  ,.out_data (sel_data_6[16:0])    //|> w
  ,.out_inv  (sel_inv_6)           //|> w
  );


NV_NVDLA_CMAC_CORE_MAC_booth u_booth_7 (
   .code     (code_7[2:0])         //|< r
  ,.is_8bit  (cfg_is_int8_d1)      //|< r
  ,.sign     (fp16_sign)           //|< r
  ,.src_data (src_data_1[15:0])    //|< r
  ,.out_data (sel_data_7[16:0])    //|> w
  ,.out_inv  (sel_inv_7)           //|> w
  );


//==========================================================
// CSA tree input
//==========================================================

always @(
  sel_data_0
  or sel_data_1
  or sel_inv_0
  or sel_data_2
  or sel_inv_1
  or sel_data_3
  or sel_inv_2
  or sel_inv_3
  ) begin
    ppre_0 = {7'b0, sel_data_0};
    ppre_1 = {5'b0, sel_data_1, 1'b0, sel_inv_0};
    ppre_2 = {3'b0, sel_data_2, 1'b0, sel_inv_1, 2'b0};
    ppre_3 = {1'b0, sel_data_3, 1'b0, sel_inv_2, 4'b0};
    ppre_4 = {17'b0, sel_inv_3, 6'b0};
end

always @(
  sel_data_4
  or sel_data_5
  or sel_inv_4
  or sel_data_6
  or sel_inv_5
  or sel_data_7
  or sel_inv_6
  or sel_inv_7
  ) begin
    ppre_5 = {7'b0, sel_data_4};
    ppre_6 = {5'b0, sel_data_5, 1'b0, sel_inv_4};
    ppre_7 = {3'b0, sel_data_6, 1'b0, sel_inv_5, 2'b0};
    ppre_8 = {1'b0, sel_data_7, 1'b0, sel_inv_6, 4'b0};
    ppre_9 = {17'b0, sel_inv_7, 6'b0};
end

//==========================================================
// CSA tree level 1
//==========================================================

always @(
  ppre_4
  or ppre_3
  or ppre_2
  or ppre_1
  or ppre_0
  ) begin
    pp_in_l0n0 = {ppre_4, ppre_3, ppre_2, ppre_1, ppre_0};
end

always @(
  ppre_9
  or ppre_8
  or ppre_7
  or ppre_6
  or ppre_5
  ) begin
    pp_in_l0n1 = {ppre_9, ppre_8, ppre_7, ppre_6, ppre_5};
end


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(5, 24) u_tree_l0n0 (
   .INPUT    (pp_in_l0n0[119:0])   //|< r
  ,.OUT0     (pp_out_l0n0_0[23:0]) //|> w
  ,.OUT1     (pp_out_l0n0_1[23:0]) //|> w
  );
`else 
DW02_tree #(5, 24) u_tree_l0n0 (
   .INPUT    (pp_in_l0n0[119:0])   //|< r
  ,.OUT0     (pp_out_l0n0_0[23:0]) //|> w
  ,.OUT1     (pp_out_l0n0_1[23:0]) //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(5, 24) u_tree_l0n1 (
   .INPUT    (pp_in_l0n1[119:0])   //|< r
  ,.OUT0     (pp_out_l0n1_0[23:0]) //|> w
  ,.OUT1     (pp_out_l0n1_1[23:0]) //|> w
  );
`else 
DW02_tree #(5, 24) u_tree_l0n1 (
   .INPUT    (pp_in_l0n1[119:0])   //|< r
  ,.OUT0     (pp_out_l0n1_0[23:0]) //|> w
  ,.OUT1     (pp_out_l0n1_1[23:0]) //|> w
  );
`endif 


//==========================================================
// CSA tree level 2
//==========================================================
always @(
  cfg_is_int8_d1
  or pp_out_l0n1_1
  or pp_out_l0n1_0
  or pp_out_l0n0_1
  or pp_out_l0n0_0
  ) begin
    pp_in_l1n0 = cfg_is_int8_d1 ? 128'b0 :
                 {{pp_out_l0n1_1, 8'b0},
                  {pp_out_l0n1_0, 8'b0},
                  {8'b0, pp_out_l0n0_1},
                  {8'b0, pp_out_l0n0_0}};
end

`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 32) u_tree_l1n0 (
   .INPUT    (pp_in_l1n0[127:0])   //|< r
  ,.OUT0     (pp_out_l1n0_0[31:0]) //|> w
  ,.OUT1     (pp_out_l1n0_1[31:0]) //|> w
  );
`else 
DW02_tree #(4, 32) u_tree_l1n0 (
   .INPUT    (pp_in_l1n0[127:0])   //|< r
  ,.OUT0     (pp_out_l1n0_0[31:0]) //|> w
  ,.OUT1     (pp_out_l1n0_1[31:0]) //|> w
  );
`endif 

//==========================================================
// Shift logic for float-point
//==========================================================

always @(
  cfg_is_fp16_d1
  or exp_sft
  or pp_out_l1n0_0
  ) begin
    pp_fp16_0_sft[31:0] = (~cfg_is_fp16_d1[2] | exp_sft[3]) ? 32'b0 :
                          (pp_out_l1n0_0 >> {exp_sft[2:0], 2'b0});
end

always @(
  cfg_is_fp16_d1
  or exp_sft
  or pp_out_l1n0_1
  ) begin
    pp_fp16_1_sft[31:0] = (~cfg_is_fp16_d1[2] | exp_sft[3]) ? 32'b0 :
                          (pp_out_l1n0_1 >> {exp_sft[2:0], 2'b0});
end

//sign compensation
always @(
  op_out_pvld
  or exp_sft
  ) begin
    pp_sign_tag = (~op_out_pvld[1] | exp_sft[3]) ? 8'h0 :
                  (8'hf0 >> exp_sft[2:0]);
end

//==========================================================
// Output select
//==========================================================


always @(
  cfg_is_int8_d1
  or cfg_is_fp16_d1
  ) begin
    res_a_gate = cfg_is_int8_d1 ? 32'h55005500 :
                 ~cfg_is_fp16_d1[3] ? 32'h55550000 :
                 32'h0;
    res_b_gate = 32'h0;
end

always @(
  cfg_is_fp16_d1
  or pp_fp16_0_sft
  or cfg_is_int8_d1
  or pp_out_l0n1_0
  or pp_out_l0n0_0
  or pp_out_l1n0_0
  ) begin
    res_a_ori = cfg_is_fp16_d1[2] ? pp_fp16_0_sft :
                cfg_is_int8_d1 ? {pp_out_l0n1_0[15:0], pp_out_l0n0_0[15:0]} :
                pp_out_l1n0_0;
end

always @(
  cfg_is_fp16_d1
  or pp_fp16_1_sft
  or cfg_is_int8_d1
  or pp_out_l0n1_1
  or pp_out_l0n0_1
  or pp_out_l1n0_1
  ) begin
    res_b_ori = cfg_is_fp16_d1[2] ? pp_fp16_1_sft :
                cfg_is_int8_d1 ? {pp_out_l0n1_1[15:0], pp_out_l0n0_1[15:0]} :
                pp_out_l1n0_1;
end

always @(
  op_out_pvld
  or res_a_ori
  or res_a_gate
  ) begin
    res_a[31:16] = op_out_pvld[1] ? res_a_ori[31:16] : res_a_gate[31:16];
    res_a[15:0]  = op_out_pvld[0] ? res_a_ori[15:0] :  res_a_gate[15:0];
end

always @(
  op_out_pvld
  or res_b_ori
  or res_b_gate
  ) begin
    res_b[31:16] = op_out_pvld[1] ? res_b_ori[31:16] : res_b_gate[31:16];
    res_b[15:0]  = op_out_pvld[0] ? res_b_ori[15:0] :  res_b_gate[15:0];
end

assign res_tag = pp_sign_tag;

endmodule // NV_NVDLA_CMAC_CORE_MAC_mul

//==========================================================
//
// Sub unit for NV_NVDLA_CMAC_CORE_MAC_mul
// Booth's recoder and Booth's selector with inversed sign flag
//
//==========================================================

module NV_NVDLA_CMAC_CORE_MAC_booth (
   code
  ,is_8bit
  ,sign
  ,src_data
  ,out_data
  ,out_inv
  );

input   [2:0] code;
input         is_8bit;
input         sign;
input  [15:0] src_data;
output [16:0] out_data;
output        out_inv;
reg     [2:0] in_code;
reg    [16:0] out_data;
reg           out_inv;


always @(
  sign
  or code
  ) begin
    in_code = {3{sign}} ^ code;
end

always @(
  is_8bit
  or in_code
  or src_data
  ) begin
    case({is_8bit, in_code})
        ///////// for 16bit /////////
        // +/- 0*src_data
        4'b0000,
        4'b0111:
        begin
            out_data = 17'h10000;
            out_inv = 1'b0;
        end

        // + 1*src_data
        4'b0001,
        4'b0010:
        begin
            out_data = {~src_data[15], src_data};
            out_inv = 1'b0;
        end

        // - 1*src_data
        4'b0101,
        4'b0110:
        begin
            out_data = {src_data[15], ~src_data};
            out_inv = 1'b1;
        end

        // + 2*src_data
        4'b0011:
        begin
            out_data = {~src_data[15], src_data[14:0], 1'b0};
            out_inv = 1'b0;
        end

        // - 2*src_data
        4'b0100:
        begin
            out_data = {src_data[15], ~src_data[14:0], 1'b1};
            out_inv = 1'b1;
        end

        ///////// for 8bit /////////
        // +/- 0*src_data
        4'b1000,
        4'b1111:
        begin
            out_data = 17'h100;
            out_inv = 1'b0;
        end

        // + 1*src_data
        4'b1001,
        4'b1010:
        begin
            out_data = {8'b0, ~src_data[7], src_data[7:0]};
            out_inv = 1'b0;
        end

        // - 1*src_data
        4'b1101,
        4'b1110:
        begin
            out_data = {8'b0, src_data[7], ~src_data[7:0]};
            out_inv = 1'b1;
        end

        // + 2*src_data
        4'b1011:
        begin
            out_data = {8'b0, ~src_data[7], src_data[6:0], 1'b0};
            out_inv = 1'b0;
        end

        // - 2*src_data
        4'b1100:
        begin
            out_data = {8'b0, src_data[7], ~src_data[6:0], 1'b1};
            out_inv = 1'b1;
        end
        default:
        begin
            out_data = 17'h10000;
            out_inv = 1'b0;
        end
    endcase
end

endmodule // NV_NVDLA_CMAC_CORE_MAC_booth

