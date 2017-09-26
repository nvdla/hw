// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CMAC_CORE_cfg.v

module NV_NVDLA_CMAC_CORE_cfg (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dp2reg_done
  ,reg2dp_conv_mode
  ,reg2dp_op_en
  ,reg2dp_proc_precision
  ,cfg_is_fp16
  ,cfg_is_int16
  ,cfg_is_int8
  ,cfg_is_wg
  ,cfg_reg_en
  ,slcg_wg_en
  );

input        nvdla_core_clk;
input        nvdla_core_rstn;
input        dp2reg_done;
input        reg2dp_conv_mode;
input        reg2dp_op_en;
input  [1:0] reg2dp_proc_precision;
output       cfg_is_fp16;
output       cfg_is_int16;
output       cfg_is_int8;
output       cfg_is_wg;
output       cfg_reg_en;
output [8:0] slcg_wg_en;
reg          cfg_is_fp16;
reg          cfg_is_fp16_w;
reg          cfg_is_int16;
reg          cfg_is_int16_w;
reg          cfg_is_int8;
reg          cfg_is_int8_w;
reg          cfg_is_wg;
reg          cfg_is_wg_w;
reg          cfg_reg_en;
reg          cfg_reg_en_d1;
reg          cfg_reg_en_w;
reg          op_done_d1;
reg          op_en_d1;
reg    [8:0] slcg_wg_en_d1;
reg    [8:0] slcg_wg_en_d2;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

always @(
  op_en_d1
  or op_done_d1
  or reg2dp_op_en
  ) begin
    cfg_reg_en_w = (~op_en_d1 | op_done_d1) & reg2dp_op_en;
end

always @(
  reg2dp_proc_precision
  ) begin
    cfg_is_int8_w  = (reg2dp_proc_precision ==  2'h0 );
    cfg_is_fp16_w  = (reg2dp_proc_precision ==  2'h2 );
    cfg_is_int16_w = (reg2dp_proc_precision ==  2'h1 );
end

always @(
  reg2dp_conv_mode
  ) begin
    cfg_is_wg_w = (reg2dp_conv_mode == 1'h1 );
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    op_en_d1 <= 1'b0;
  end else begin
  op_en_d1 <= reg2dp_op_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    op_done_d1 <= 1'b0;
  end else begin
  op_done_d1 <= dp2reg_done;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_reg_en <= 1'b0;
  end else begin
  cfg_reg_en <= cfg_reg_en_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_is_int8 <= 1'b0;
  end else begin
  cfg_is_int8 <= cfg_is_int8_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_is_fp16 <= 1'b0;
  end else begin
  cfg_is_fp16 <= cfg_is_fp16_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_is_int16 <= 1'b1;
  end else begin
  cfg_is_int16 <= cfg_is_int16_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_is_wg <= 1'b0;
  end else begin
  cfg_is_wg <= cfg_is_wg_w;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_reg_en_d1 <= 1'b0;
  end else begin
  cfg_reg_en_d1 <= cfg_reg_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_wg_en_d1 <= {9{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    slcg_wg_en_d1 <= {9{cfg_is_wg}};
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    slcg_wg_en_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    slcg_wg_en_d2 <= {9{1'b0}};
  end else begin
  if ((cfg_reg_en_d1) == 1'b1) begin
    slcg_wg_en_d2 <= slcg_wg_en_d1;
  // VCS coverage off
  end else if ((cfg_reg_en_d1) == 1'b0) begin
  end else begin
    slcg_wg_en_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign slcg_wg_en = slcg_wg_en_d2;

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           {cfg_reg_en,cfg_is_int8}
//                           {cfg_is_fp16,cfg_is_wg};

endmodule // NV_NVDLA_CMAC_CORE_cfg


