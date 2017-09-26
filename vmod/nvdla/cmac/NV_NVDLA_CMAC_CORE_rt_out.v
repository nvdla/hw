// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CMAC_CORE_rt_out.v

module NV_NVDLA_CMAC_CORE_rt_out (
   nvdla_core_clk
  ,nvdla_wg_clk
  ,nvdla_core_rstn
  ,cfg_is_wg
  ,cfg_reg_en
  ,out_data0
  ,out_data1
  ,out_data2
  ,out_data3
  ,out_data4
  ,out_data5
  ,out_data6
  ,out_data7
  ,out_mask
  ,out_pd
  ,out_pvld
  ,dp2reg_done
  ,mac2accu_data0
  ,mac2accu_data1
  ,mac2accu_data2
  ,mac2accu_data3
  ,mac2accu_data4
  ,mac2accu_data5
  ,mac2accu_data6
  ,mac2accu_data7
  ,mac2accu_mask
  ,mac2accu_mode
  ,mac2accu_pd
  ,mac2accu_pvld
  );

input          nvdla_core_clk;
input          nvdla_wg_clk;
input          nvdla_core_rstn;
input          cfg_is_wg;
input          cfg_reg_en;
input  [175:0] out_data0;
input  [175:0] out_data1;
input  [175:0] out_data2;
input  [175:0] out_data3;
input  [175:0] out_data4;
input  [175:0] out_data5;
input  [175:0] out_data6;
input  [175:0] out_data7;
input    [7:0] out_mask;
input    [8:0] out_pd;
input          out_pvld;
output         dp2reg_done;
output [175:0] mac2accu_data0;
output [175:0] mac2accu_data1;
output [175:0] mac2accu_data2;
output [175:0] mac2accu_data3;
output [175:0] mac2accu_data4;
output [175:0] mac2accu_data5;
output [175:0] mac2accu_data6;
output [175:0] mac2accu_data7;
output   [7:0] mac2accu_mask;
output   [7:0] mac2accu_mode;
output   [8:0] mac2accu_pd;
output         mac2accu_pvld;
wire     [7:0] out_dat_en_0;
wire           out_rt_done_d0;
reg            cfg_is_wg_d1;
reg            cfg_reg_en_d1;
reg    [175:0] mac2accu_data0;
reg    [175:0] mac2accu_data1;
reg    [175:0] mac2accu_data2;
reg    [175:0] mac2accu_data3;
reg    [175:0] mac2accu_data4;
reg    [175:0] mac2accu_data5;
reg    [175:0] mac2accu_data6;
reg    [175:0] mac2accu_data7;
reg      [7:0] mac2accu_mask;
reg      [7:0] mac2accu_mode;
reg      [8:0] mac2accu_pd;
reg            mac2accu_pvld;
reg      [7:0] out_dat_en_1;
reg      [7:0] out_dat_en_2;
reg      [7:0] out_dat_en_3;
reg            out_layer_done;
reg    [175:0] out_rt_data0_d0;
reg    [175:0] out_rt_data0_d1;
reg    [175:0] out_rt_data1_d0;
reg    [175:0] out_rt_data1_d1;
reg    [175:0] out_rt_data2_d0;
reg    [175:0] out_rt_data2_d1;
reg    [175:0] out_rt_data3_d0;
reg    [175:0] out_rt_data3_d1;
reg    [175:0] out_rt_data4_d0;
reg    [175:0] out_rt_data4_d1;
reg    [175:0] out_rt_data5_d0;
reg    [175:0] out_rt_data5_d1;
reg    [175:0] out_rt_data6_d0;
reg    [175:0] out_rt_data6_d1;
reg    [175:0] out_rt_data7_d0;
reg    [175:0] out_rt_data7_d1;
reg            out_rt_done_d1;
reg            out_rt_done_d2;
reg            out_rt_done_d3;
reg            out_rt_done_d4;
reg      [7:0] out_rt_mask_d0;
reg      [7:0] out_rt_mask_d1;
reg      [8:0] out_rt_pd_d0;
reg      [8:0] out_rt_pd_d1;
reg            out_rt_pvld_d0;
reg            out_rt_pvld_d1;

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
    cfg_reg_en_d1 <= 1'b0;
  end else begin
  cfg_reg_en_d1 <= cfg_reg_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_is_wg_d1 <= 1'b0;
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_is_wg_d1 <= cfg_is_wg;
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_is_wg_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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

assign out_dat_en_0 = {16 /2 {1'b1}};
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    out_dat_en_1 <= {8{1'b0}};
  end else begin
  if ((cfg_reg_en_d1) == 1'b1) begin
    out_dat_en_1 <= {8{cfg_is_wg_d1}};
  // VCS coverage off
  end else if ((cfg_reg_en_d1) == 1'b0) begin
  end else begin
    out_dat_en_1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    out_dat_en_2 <= {8{1'b0}};
  end else begin
  if ((cfg_reg_en_d1) == 1'b1) begin
    out_dat_en_2 <= {8{cfg_is_wg_d1}};
  // VCS coverage off
  end else if ((cfg_reg_en_d1) == 1'b0) begin
  end else begin
    out_dat_en_2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    out_dat_en_3 <= {8{1'b0}};
  end else begin
  if ((cfg_reg_en_d1) == 1'b1) begin
    out_dat_en_3 <= {8{cfg_is_wg_d1}};
  // VCS coverage off
  end else if ((cfg_reg_en_d1) == 1'b0) begin
  end else begin
    out_dat_en_3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// Output retiming
//==========================================================

always @(
  out_pd
  or out_pvld
  ) begin
    out_layer_done = out_pd[8:8] &
                     out_pd[6:6] &
                     out_pvld;
end

always @(
  out_pvld
  or out_mask
  or out_pd
  ) begin
    out_rt_pvld_d0 = out_pvld;
    out_rt_mask_d0 = out_mask;
    out_rt_pd_d0   = out_pd;
end


always @(
  out_data0
  or out_data1
  or out_data2
  or out_data3
  or out_data4
  or out_data5
  or out_data6
  or out_data7
  ) begin
    out_rt_data0_d0 =  out_data0;
    out_rt_data1_d0 =  out_data1;
    out_rt_data2_d0 =  out_data2;
    out_rt_data3_d0 =  out_data3;
    out_rt_data4_d0 =  out_data4;
    out_rt_data5_d0 =  out_data5;
    out_rt_data6_d0 =  out_data6;
    out_rt_data7_d0 =  out_data7;
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    out_rt_pvld_d1 <= 1'b0;
  end else begin
  out_rt_pvld_d1 <= out_rt_pvld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    out_rt_mask_d1 <= {8{1'b0}};
  end else begin
  out_rt_mask_d1 <= out_rt_mask_d0;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((out_rt_pvld_d0) == 1'b1) begin
    out_rt_pd_d1 <= out_rt_pd_d0;
  // VCS coverage off
  end else if ((out_rt_pvld_d0) == 1'b0) begin
  end else begin
    out_rt_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((out_rt_mask_d0[0] & out_dat_en_0[0]) == 1'b1) begin
    out_rt_data0_d1[43:0] <= out_rt_data0_d0[43:0];
  // VCS coverage off
  end else if ((out_rt_mask_d0[0] & out_dat_en_0[0]) == 1'b0) begin
  end else begin
    out_rt_data0_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[0] & out_dat_en_1[0]) == 1'b1) begin
    out_rt_data0_d1[87:44] <= out_rt_data0_d0[87:44];
  // VCS coverage off
  end else if ((out_rt_mask_d0[0] & out_dat_en_1[0]) == 1'b0) begin
  end else begin
    out_rt_data0_d1[87:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[0] & out_dat_en_2[0]) == 1'b1) begin
    out_rt_data0_d1[131:88] <= out_rt_data0_d0[131:88];
  // VCS coverage off
  end else if ((out_rt_mask_d0[0] & out_dat_en_2[0]) == 1'b0) begin
  end else begin
    out_rt_data0_d1[131:88] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[0] & out_dat_en_3[0]) == 1'b1) begin
    out_rt_data0_d1[175:132] <= out_rt_data0_d0[175:132];
  // VCS coverage off
  end else if ((out_rt_mask_d0[0] & out_dat_en_3[0]) == 1'b0) begin
  end else begin
    out_rt_data0_d1[175:132] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((out_rt_mask_d0[1] & out_dat_en_0[1]) == 1'b1) begin
    out_rt_data1_d1[43:0] <= out_rt_data1_d0[43:0];
  // VCS coverage off
  end else if ((out_rt_mask_d0[1] & out_dat_en_0[1]) == 1'b0) begin
  end else begin
    out_rt_data1_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[1] & out_dat_en_1[1]) == 1'b1) begin
    out_rt_data1_d1[87:44] <= out_rt_data1_d0[87:44];
  // VCS coverage off
  end else if ((out_rt_mask_d0[1] & out_dat_en_1[1]) == 1'b0) begin
  end else begin
    out_rt_data1_d1[87:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[1] & out_dat_en_2[1]) == 1'b1) begin
    out_rt_data1_d1[131:88] <= out_rt_data1_d0[131:88];
  // VCS coverage off
  end else if ((out_rt_mask_d0[1] & out_dat_en_2[1]) == 1'b0) begin
  end else begin
    out_rt_data1_d1[131:88] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[1] & out_dat_en_3[1]) == 1'b1) begin
    out_rt_data1_d1[175:132] <= out_rt_data1_d0[175:132];
  // VCS coverage off
  end else if ((out_rt_mask_d0[1] & out_dat_en_3[1]) == 1'b0) begin
  end else begin
    out_rt_data1_d1[175:132] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((out_rt_mask_d0[2] & out_dat_en_0[2]) == 1'b1) begin
    out_rt_data2_d1[43:0] <= out_rt_data2_d0[43:0];
  // VCS coverage off
  end else if ((out_rt_mask_d0[2] & out_dat_en_0[2]) == 1'b0) begin
  end else begin
    out_rt_data2_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[2] & out_dat_en_1[2]) == 1'b1) begin
    out_rt_data2_d1[87:44] <= out_rt_data2_d0[87:44];
  // VCS coverage off
  end else if ((out_rt_mask_d0[2] & out_dat_en_1[2]) == 1'b0) begin
  end else begin
    out_rt_data2_d1[87:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[2] & out_dat_en_2[2]) == 1'b1) begin
    out_rt_data2_d1[131:88] <= out_rt_data2_d0[131:88];
  // VCS coverage off
  end else if ((out_rt_mask_d0[2] & out_dat_en_2[2]) == 1'b0) begin
  end else begin
    out_rt_data2_d1[131:88] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[2] & out_dat_en_3[2]) == 1'b1) begin
    out_rt_data2_d1[175:132] <= out_rt_data2_d0[175:132];
  // VCS coverage off
  end else if ((out_rt_mask_d0[2] & out_dat_en_3[2]) == 1'b0) begin
  end else begin
    out_rt_data2_d1[175:132] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((out_rt_mask_d0[3] & out_dat_en_0[3]) == 1'b1) begin
    out_rt_data3_d1[43:0] <= out_rt_data3_d0[43:0];
  // VCS coverage off
  end else if ((out_rt_mask_d0[3] & out_dat_en_0[3]) == 1'b0) begin
  end else begin
    out_rt_data3_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[3] & out_dat_en_1[3]) == 1'b1) begin
    out_rt_data3_d1[87:44] <= out_rt_data3_d0[87:44];
  // VCS coverage off
  end else if ((out_rt_mask_d0[3] & out_dat_en_1[3]) == 1'b0) begin
  end else begin
    out_rt_data3_d1[87:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[3] & out_dat_en_2[3]) == 1'b1) begin
    out_rt_data3_d1[131:88] <= out_rt_data3_d0[131:88];
  // VCS coverage off
  end else if ((out_rt_mask_d0[3] & out_dat_en_2[3]) == 1'b0) begin
  end else begin
    out_rt_data3_d1[131:88] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[3] & out_dat_en_3[3]) == 1'b1) begin
    out_rt_data3_d1[175:132] <= out_rt_data3_d0[175:132];
  // VCS coverage off
  end else if ((out_rt_mask_d0[3] & out_dat_en_3[3]) == 1'b0) begin
  end else begin
    out_rt_data3_d1[175:132] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((out_rt_mask_d0[4] & out_dat_en_0[4]) == 1'b1) begin
    out_rt_data4_d1[43:0] <= out_rt_data4_d0[43:0];
  // VCS coverage off
  end else if ((out_rt_mask_d0[4] & out_dat_en_0[4]) == 1'b0) begin
  end else begin
    out_rt_data4_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[4] & out_dat_en_1[4]) == 1'b1) begin
    out_rt_data4_d1[87:44] <= out_rt_data4_d0[87:44];
  // VCS coverage off
  end else if ((out_rt_mask_d0[4] & out_dat_en_1[4]) == 1'b0) begin
  end else begin
    out_rt_data4_d1[87:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[4] & out_dat_en_2[4]) == 1'b1) begin
    out_rt_data4_d1[131:88] <= out_rt_data4_d0[131:88];
  // VCS coverage off
  end else if ((out_rt_mask_d0[4] & out_dat_en_2[4]) == 1'b0) begin
  end else begin
    out_rt_data4_d1[131:88] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[4] & out_dat_en_3[4]) == 1'b1) begin
    out_rt_data4_d1[175:132] <= out_rt_data4_d0[175:132];
  // VCS coverage off
  end else if ((out_rt_mask_d0[4] & out_dat_en_3[4]) == 1'b0) begin
  end else begin
    out_rt_data4_d1[175:132] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((out_rt_mask_d0[5] & out_dat_en_0[5]) == 1'b1) begin
    out_rt_data5_d1[43:0] <= out_rt_data5_d0[43:0];
  // VCS coverage off
  end else if ((out_rt_mask_d0[5] & out_dat_en_0[5]) == 1'b0) begin
  end else begin
    out_rt_data5_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[5] & out_dat_en_1[5]) == 1'b1) begin
    out_rt_data5_d1[87:44] <= out_rt_data5_d0[87:44];
  // VCS coverage off
  end else if ((out_rt_mask_d0[5] & out_dat_en_1[5]) == 1'b0) begin
  end else begin
    out_rt_data5_d1[87:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[5] & out_dat_en_2[5]) == 1'b1) begin
    out_rt_data5_d1[131:88] <= out_rt_data5_d0[131:88];
  // VCS coverage off
  end else if ((out_rt_mask_d0[5] & out_dat_en_2[5]) == 1'b0) begin
  end else begin
    out_rt_data5_d1[131:88] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[5] & out_dat_en_3[5]) == 1'b1) begin
    out_rt_data5_d1[175:132] <= out_rt_data5_d0[175:132];
  // VCS coverage off
  end else if ((out_rt_mask_d0[5] & out_dat_en_3[5]) == 1'b0) begin
  end else begin
    out_rt_data5_d1[175:132] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((out_rt_mask_d0[6] & out_dat_en_0[6]) == 1'b1) begin
    out_rt_data6_d1[43:0] <= out_rt_data6_d0[43:0];
  // VCS coverage off
  end else if ((out_rt_mask_d0[6] & out_dat_en_0[6]) == 1'b0) begin
  end else begin
    out_rt_data6_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[6] & out_dat_en_1[6]) == 1'b1) begin
    out_rt_data6_d1[87:44] <= out_rt_data6_d0[87:44];
  // VCS coverage off
  end else if ((out_rt_mask_d0[6] & out_dat_en_1[6]) == 1'b0) begin
  end else begin
    out_rt_data6_d1[87:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[6] & out_dat_en_2[6]) == 1'b1) begin
    out_rt_data6_d1[131:88] <= out_rt_data6_d0[131:88];
  // VCS coverage off
  end else if ((out_rt_mask_d0[6] & out_dat_en_2[6]) == 1'b0) begin
  end else begin
    out_rt_data6_d1[131:88] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[6] & out_dat_en_3[6]) == 1'b1) begin
    out_rt_data6_d1[175:132] <= out_rt_data6_d0[175:132];
  // VCS coverage off
  end else if ((out_rt_mask_d0[6] & out_dat_en_3[6]) == 1'b0) begin
  end else begin
    out_rt_data6_d1[175:132] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((out_rt_mask_d0[7] & out_dat_en_0[7]) == 1'b1) begin
    out_rt_data7_d1[43:0] <= out_rt_data7_d0[43:0];
  // VCS coverage off
  end else if ((out_rt_mask_d0[7] & out_dat_en_0[7]) == 1'b0) begin
  end else begin
    out_rt_data7_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[7] & out_dat_en_1[7]) == 1'b1) begin
    out_rt_data7_d1[87:44] <= out_rt_data7_d0[87:44];
  // VCS coverage off
  end else if ((out_rt_mask_d0[7] & out_dat_en_1[7]) == 1'b0) begin
  end else begin
    out_rt_data7_d1[87:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[7] & out_dat_en_2[7]) == 1'b1) begin
    out_rt_data7_d1[131:88] <= out_rt_data7_d0[131:88];
  // VCS coverage off
  end else if ((out_rt_mask_d0[7] & out_dat_en_2[7]) == 1'b0) begin
  end else begin
    out_rt_data7_d1[131:88] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((out_rt_mask_d0[7] & out_dat_en_3[7]) == 1'b1) begin
    out_rt_data7_d1[175:132] <= out_rt_data7_d0[175:132];
  // VCS coverage off
  end else if ((out_rt_mask_d0[7] & out_dat_en_3[7]) == 1'b0) begin
  end else begin
    out_rt_data7_d1[175:132] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end



always @(
  out_rt_pvld_d1
  or out_rt_mask_d1
  or out_rt_pd_d1
  ) begin
    mac2accu_pvld = out_rt_pvld_d1;
    mac2accu_mask = out_rt_mask_d1;
    mac2accu_pd = out_rt_pd_d1;
end


always @(
  out_rt_data0_d1
  or out_rt_data1_d1
  or out_rt_data2_d1
  or out_rt_data3_d1
  or out_rt_data4_d1
  or out_rt_data5_d1
  or out_rt_data6_d1
  or out_rt_data7_d1
  ) begin
    mac2accu_data0 = out_rt_data0_d1;
    mac2accu_data1 = out_rt_data1_d1;
    mac2accu_data2 = out_rt_data2_d1;
    mac2accu_data3 = out_rt_data3_d1;
    mac2accu_data4 = out_rt_data4_d1;
    mac2accu_data5 = out_rt_data5_d1;
    mac2accu_data6 = out_rt_data6_d1;
    mac2accu_data7 = out_rt_data7_d1;
end



assign out_rt_done_d0 = out_layer_done;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    out_rt_done_d1 <= 1'b0;
  end else begin
  out_rt_done_d1 <= out_rt_done_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    out_rt_done_d2 <= 1'b0;
  end else begin
  out_rt_done_d2 <= out_rt_done_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    out_rt_done_d3 <= 1'b0;
  end else begin
  out_rt_done_d3 <= out_rt_done_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    out_rt_done_d4 <= 1'b0;
  end else begin
  out_rt_done_d4 <= out_rt_done_d3;
  end
end


assign dp2reg_done = out_rt_done_d4;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mac2accu_mode <= {8{1'b0}};
  end else begin
  if ((cfg_reg_en_d1) == 1'b1) begin
    mac2accu_mode <= {8{cfg_is_wg_d1}};
  // VCS coverage off
  end else if ((cfg_reg_en_d1) == 1'b0) begin
  end else begin
    mac2accu_mode <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           out_rt_mask_d1[1:0]
//                           out_rt_pd_d1[1:0];

endmodule // NV_NVDLA_CMAC_CORE_rt_out


