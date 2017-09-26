// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CACC_delivery_buffer.v

module NV_NVDLA_CACC_delivery_buffer (
   nvdla_core_clk        //|< i
  ,nvdla_core_rstn       //|< i
  ,cacc2sdp_ready        //|< i
  ,dbuf_rd_addr          //|< i
  ,dbuf_rd_en            //|< i
  ,dbuf_rd_layer_end     //|< i
  ,dbuf_wr_addr_0        //|< i
  ,dbuf_wr_addr_1        //|< i
  ,dbuf_wr_addr_2        //|< i
  ,dbuf_wr_addr_3        //|< i
  ,dbuf_wr_addr_4        //|< i
  ,dbuf_wr_addr_5        //|< i
  ,dbuf_wr_addr_6        //|< i
  ,dbuf_wr_addr_7        //|< i
  ,dbuf_wr_data_0        //|< i
  ,dbuf_wr_data_1        //|< i
  ,dbuf_wr_data_2        //|< i
  ,dbuf_wr_data_3        //|< i
  ,dbuf_wr_data_4        //|< i
  ,dbuf_wr_data_5        //|< i
  ,dbuf_wr_data_6        //|< i
  ,dbuf_wr_data_7        //|< i
  ,dbuf_wr_en            //|< i
  ,pwrbus_ram_pd         //|< i
  ,cacc2glb_done_intr_pd //|> o
  ,cacc2sdp_pd           //|> o
  ,cacc2sdp_valid        //|> o
  ,dbuf_rd_ready         //|> o
  );


input          nvdla_core_clk;
input          nvdla_core_rstn;
input          cacc2sdp_ready;
input    [4:0] dbuf_rd_addr;
input    [7:0] dbuf_rd_en;
input          dbuf_rd_layer_end;
input    [4:0] dbuf_wr_addr_0;
input    [4:0] dbuf_wr_addr_1;
input    [4:0] dbuf_wr_addr_2;
input    [4:0] dbuf_wr_addr_3;
input    [4:0] dbuf_wr_addr_4;
input    [4:0] dbuf_wr_addr_5;
input    [4:0] dbuf_wr_addr_6;
input    [4:0] dbuf_wr_addr_7;
input  [511:0] dbuf_wr_data_0;
input  [511:0] dbuf_wr_data_1;
input  [511:0] dbuf_wr_data_2;
input  [511:0] dbuf_wr_data_3;
input  [511:0] dbuf_wr_data_4;
input  [511:0] dbuf_wr_data_5;
input  [511:0] dbuf_wr_data_6;
input  [511:0] dbuf_wr_data_7;
input    [7:0] dbuf_wr_en;
input   [31:0] pwrbus_ram_pd;
output   [1:0] cacc2glb_done_intr_pd;
output [513:0] cacc2sdp_pd;
output         cacc2sdp_valid;
output         dbuf_rd_ready;
wire           cacc2sdp_batch_end;
wire           cacc2sdp_layer_end;
wire           cacc_done;
wire     [1:0] cacc_done_intr_w;
wire   [511:0] dbg_cacc2sdp_dat;
wire   [511:0] dbuf_rd_data_d3_w;
wire   [511:0] dbuf_rd_data_ecc_0;
wire   [511:0] dbuf_rd_data_ecc_1;
wire   [511:0] dbuf_rd_data_ecc_2;
wire   [511:0] dbuf_rd_data_ecc_3;
wire   [511:0] dbuf_rd_data_ecc_4;
wire   [511:0] dbuf_rd_data_ecc_5;
wire   [511:0] dbuf_rd_data_ecc_6;
wire   [511:0] dbuf_rd_data_ecc_7;
wire           dbuf_rd_ready_d2;
wire           dbuf_rd_ready_d3;
wire   [511:0] dbuf_wr_data_0_d1_w;
wire   [511:0] dbuf_wr_data_1_d1_w;
wire   [511:0] dbuf_wr_data_2_d1_w;
wire   [511:0] dbuf_wr_data_3_d1_w;
wire   [511:0] dbuf_wr_data_4_d1_w;
wire   [511:0] dbuf_wr_data_5_d1_w;
wire   [511:0] dbuf_wr_data_6_d1_w;
wire   [511:0] dbuf_wr_data_7_d1_w;
wire     [7:0] dbuf_wr_en_d1_w;
wire           intr_sel_w;
reg     [31:0] cacc2sdp_data0;
reg     [31:0] cacc2sdp_data1;
reg     [31:0] cacc2sdp_data10;
reg     [31:0] cacc2sdp_data11;
reg     [31:0] cacc2sdp_data12;
reg     [31:0] cacc2sdp_data13;
reg     [31:0] cacc2sdp_data14;
reg     [31:0] cacc2sdp_data15;
reg     [31:0] cacc2sdp_data2;
reg     [31:0] cacc2sdp_data3;
reg     [31:0] cacc2sdp_data4;
reg     [31:0] cacc2sdp_data5;
reg     [31:0] cacc2sdp_data6;
reg     [31:0] cacc2sdp_data7;
reg     [31:0] cacc2sdp_data8;
reg     [31:0] cacc2sdp_data9;
reg      [1:0] cacc_done_intr;
reg      [4:0] dbuf_rd_addr_d1;
reg      [4:0] dbuf_rd_addr_in;
reg            dbuf_rd_d0_reg_en;
reg            dbuf_rd_d1_reg_en;
reg            dbuf_rd_d2_reg_en;
reg    [511:0] dbuf_rd_data_d3;
reg    [511:0] dbuf_rd_data_ecc_d2;
reg    [511:0] dbuf_rd_data_ecc_d2_w;
reg      [7:0] dbuf_rd_en_d1;
reg      [7:0] dbuf_rd_en_in;
reg            dbuf_rd_layer_end_d1;
reg            dbuf_rd_layer_end_d2;
reg            dbuf_rd_layer_end_d3;
reg    [511:0] dbuf_rd_raw_data;
reg            dbuf_rd_ready_d0;
reg            dbuf_rd_ready_d1;
reg            dbuf_rd_ready_d3_w;
reg            dbuf_rd_valid_d1;
reg            dbuf_rd_valid_d1_w;
reg            dbuf_rd_valid_d2;
reg            dbuf_rd_valid_d2_w;
reg            dbuf_rd_valid_d3;
reg            dbuf_rd_valid_d3_w;
reg      [4:0] dbuf_wr_addr_0_d1;
reg      [4:0] dbuf_wr_addr_1_d1;
reg      [4:0] dbuf_wr_addr_2_d1;
reg      [4:0] dbuf_wr_addr_3_d1;
reg      [4:0] dbuf_wr_addr_4_d1;
reg      [4:0] dbuf_wr_addr_5_d1;
reg      [4:0] dbuf_wr_addr_6_d1;
reg      [4:0] dbuf_wr_addr_7_d1;
reg    [511:0] dbuf_wr_data_0_d1;
reg    [511:0] dbuf_wr_data_1_d1;
reg    [511:0] dbuf_wr_data_2_d1;
reg    [511:0] dbuf_wr_data_3_d1;
reg    [511:0] dbuf_wr_data_4_d1;
reg    [511:0] dbuf_wr_data_5_d1;
reg    [511:0] dbuf_wr_data_6_d1;
reg    [511:0] dbuf_wr_data_7_d1;
reg      [7:0] dbuf_wr_en_d1;
reg            intr_sel;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    




////////////////////////////////////////////////////////////////////////
//                                                                    //
// Input write latency: 2 cycle                                       //
//                                                                    //
////////////////////////////////////////////////////////////////////////








////////////////////////////////////////////////////////////////////////
//                                                                    //
// Output read latency: 3 cycle                                       //
//                                                                    //
////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////
// Input write stage1: connect to retiming register                   //
////////////////////////////////////////////////////////////////////////

assign dbuf_wr_en_d1_w[0] = dbuf_wr_en[0];
assign dbuf_wr_en_d1_w[1] = dbuf_wr_en[1];
assign dbuf_wr_en_d1_w[2] = dbuf_wr_en[2];
assign dbuf_wr_en_d1_w[3] = dbuf_wr_en[3];
assign dbuf_wr_en_d1_w[4] = dbuf_wr_en[4];
assign dbuf_wr_en_d1_w[5] = dbuf_wr_en[5];
assign dbuf_wr_en_d1_w[6] = dbuf_wr_en[6];
assign dbuf_wr_en_d1_w[7] = dbuf_wr_en[7];


assign dbuf_wr_data_0_d1_w = dbuf_wr_data_0[512-1:0];
assign dbuf_wr_data_1_d1_w = dbuf_wr_data_1[512-1:0];
assign dbuf_wr_data_2_d1_w = dbuf_wr_data_2[512-1:0];
assign dbuf_wr_data_3_d1_w = dbuf_wr_data_3[512-1:0];
assign dbuf_wr_data_4_d1_w = dbuf_wr_data_4[512-1:0];
assign dbuf_wr_data_5_d1_w = dbuf_wr_data_5[512-1:0];
assign dbuf_wr_data_6_d1_w = dbuf_wr_data_6[512-1:0];
assign dbuf_wr_data_7_d1_w = dbuf_wr_data_7[512-1:0];

////////////////////////////////////////////////////////////////////////
// Input write stage1 registers                                       //
////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dbuf_wr_en_d1 <= {8{1'b0}};
  end else begin
  dbuf_wr_en_d1 <= dbuf_wr_en_d1_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dbuf_wr_addr_0_d1 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_d1_w[0]) == 1'b1) begin
    dbuf_wr_addr_0_d1 <= dbuf_wr_addr_0;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[0]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_d1_w[0]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_1_d1 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_d1_w[1]) == 1'b1) begin
    dbuf_wr_addr_1_d1 <= dbuf_wr_addr_1;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[1]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_d1_w[1]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_2_d1 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_d1_w[2]) == 1'b1) begin
    dbuf_wr_addr_2_d1 <= dbuf_wr_addr_2;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[2]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_2_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_d1_w[2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_3_d1 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_d1_w[3]) == 1'b1) begin
    dbuf_wr_addr_3_d1 <= dbuf_wr_addr_3;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[3]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_3_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_d1_w[3]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_4_d1 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_d1_w[4]) == 1'b1) begin
    dbuf_wr_addr_4_d1 <= dbuf_wr_addr_4;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[4]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_4_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_d1_w[4]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_5_d1 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_d1_w[5]) == 1'b1) begin
    dbuf_wr_addr_5_d1 <= dbuf_wr_addr_5;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[5]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_5_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_d1_w[5]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_6_d1 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_d1_w[6]) == 1'b1) begin
    dbuf_wr_addr_6_d1 <= dbuf_wr_addr_6;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[6]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_6_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_d1_w[6]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_7_d1 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_d1_w[7]) == 1'b1) begin
    dbuf_wr_addr_7_d1 <= dbuf_wr_addr_7;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[7]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_7_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_d1_w[7]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_d1_w[0]) == 1'b1) begin
    dbuf_wr_data_0_d1 <= dbuf_wr_data_0_d1_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[0]) == 1'b0) begin
  end else begin
    dbuf_wr_data_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_d1_w[1]) == 1'b1) begin
    dbuf_wr_data_1_d1 <= dbuf_wr_data_1_d1_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[1]) == 1'b0) begin
  end else begin
    dbuf_wr_data_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_d1_w[2]) == 1'b1) begin
    dbuf_wr_data_2_d1 <= dbuf_wr_data_2_d1_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[2]) == 1'b0) begin
  end else begin
    dbuf_wr_data_2_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_d1_w[3]) == 1'b1) begin
    dbuf_wr_data_3_d1 <= dbuf_wr_data_3_d1_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[3]) == 1'b0) begin
  end else begin
    dbuf_wr_data_3_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_d1_w[4]) == 1'b1) begin
    dbuf_wr_data_4_d1 <= dbuf_wr_data_4_d1_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[4]) == 1'b0) begin
  end else begin
    dbuf_wr_data_4_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_d1_w[5]) == 1'b1) begin
    dbuf_wr_data_5_d1 <= dbuf_wr_data_5_d1_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[5]) == 1'b0) begin
  end else begin
    dbuf_wr_data_5_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_d1_w[6]) == 1'b1) begin
    dbuf_wr_data_6_d1 <= dbuf_wr_data_6_d1_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[6]) == 1'b0) begin
  end else begin
    dbuf_wr_data_6_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_d1_w[7]) == 1'b1) begin
    dbuf_wr_data_7_d1 <= dbuf_wr_data_7_d1_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_d1_w[7]) == 1'b0) begin
  end else begin
    dbuf_wr_data_7_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

////////////////////////////////////////////////////////////////////////
// Instance RAMs                                                      //
////////////////////////////////////////////////////////////////////////

nv_ram_rws_32x512 u_accu_dbuf_0 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (dbuf_rd_addr_in[4:0])      //|< r
  ,.re            (dbuf_rd_en_in[0])          //|< r
  ,.dout          (dbuf_rd_data_ecc_0[511:0]) //|> w
  ,.wa            (dbuf_wr_addr_0_d1[4:0])    //|< r
  ,.we            (dbuf_wr_en_d1[0])          //|< r
  ,.di            (dbuf_wr_data_0_d1[511:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x512 u_accu_dbuf_1 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (dbuf_rd_addr_in[4:0])      //|< r
  ,.re            (dbuf_rd_en_in[1])          //|< r
  ,.dout          (dbuf_rd_data_ecc_1[511:0]) //|> w
  ,.wa            (dbuf_wr_addr_1_d1[4:0])    //|< r
  ,.we            (dbuf_wr_en_d1[1])          //|< r
  ,.di            (dbuf_wr_data_1_d1[511:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x512 u_accu_dbuf_2 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (dbuf_rd_addr_in[4:0])      //|< r
  ,.re            (dbuf_rd_en_in[2])          //|< r
  ,.dout          (dbuf_rd_data_ecc_2[511:0]) //|> w
  ,.wa            (dbuf_wr_addr_2_d1[4:0])    //|< r
  ,.we            (dbuf_wr_en_d1[2])          //|< r
  ,.di            (dbuf_wr_data_2_d1[511:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x512 u_accu_dbuf_3 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (dbuf_rd_addr_in[4:0])      //|< r
  ,.re            (dbuf_rd_en_in[3])          //|< r
  ,.dout          (dbuf_rd_data_ecc_3[511:0]) //|> w
  ,.wa            (dbuf_wr_addr_3_d1[4:0])    //|< r
  ,.we            (dbuf_wr_en_d1[3])          //|< r
  ,.di            (dbuf_wr_data_3_d1[511:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x512 u_accu_dbuf_4 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (dbuf_rd_addr_in[4:0])      //|< r
  ,.re            (dbuf_rd_en_in[4])          //|< r
  ,.dout          (dbuf_rd_data_ecc_4[511:0]) //|> w
  ,.wa            (dbuf_wr_addr_4_d1[4:0])    //|< r
  ,.we            (dbuf_wr_en_d1[4])          //|< r
  ,.di            (dbuf_wr_data_4_d1[511:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x512 u_accu_dbuf_5 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (dbuf_rd_addr_in[4:0])      //|< r
  ,.re            (dbuf_rd_en_in[5])          //|< r
  ,.dout          (dbuf_rd_data_ecc_5[511:0]) //|> w
  ,.wa            (dbuf_wr_addr_5_d1[4:0])    //|< r
  ,.we            (dbuf_wr_en_d1[5])          //|< r
  ,.di            (dbuf_wr_data_5_d1[511:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x512 u_accu_dbuf_6 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (dbuf_rd_addr_in[4:0])      //|< r
  ,.re            (dbuf_rd_en_in[6])          //|< r
  ,.dout          (dbuf_rd_data_ecc_6[511:0]) //|> w
  ,.wa            (dbuf_wr_addr_6_d1[4:0])    //|< r
  ,.we            (dbuf_wr_en_d1[6])          //|< r
  ,.di            (dbuf_wr_data_6_d1[511:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x512 u_accu_dbuf_7 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (dbuf_rd_addr_in[4:0])      //|< r
  ,.re            (dbuf_rd_en_in[7])          //|< r
  ,.dout          (dbuf_rd_data_ecc_7[511:0]) //|> w
  ,.wa            (dbuf_wr_addr_7_d1[4:0])    //|< r
  ,.we            (dbuf_wr_en_d1[7])          //|< r
  ,.di            (dbuf_wr_data_7_d1[511:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );

////////////////////////////////////////////////////////////////////////
// Input read input signals                                           //
////////////////////////////////////////////////////////////////////////
always @(
  dbuf_rd_ready_d0
  or dbuf_rd_en
  or dbuf_rd_en_d1
  ) begin
    dbuf_rd_en_in = dbuf_rd_ready_d0 ? dbuf_rd_en : dbuf_rd_en_d1;
end

always @(
  dbuf_rd_ready_d0
  or dbuf_rd_addr
  or dbuf_rd_addr_d1
  ) begin
    dbuf_rd_addr_in = dbuf_rd_ready_d0 ? dbuf_rd_addr : dbuf_rd_addr_d1;
end

assign dbuf_rd_ready = dbuf_rd_ready_d0;

////////////////////////////////////////////////////////////////////////
// Input read stage1 registers                                        //
////////////////////////////////////////////////////////////////////////
always @(
  dbuf_rd_en
  or dbuf_rd_ready_d1
  or dbuf_rd_valid_d1
  ) begin
    dbuf_rd_valid_d1_w = (|dbuf_rd_en) ? 1'b1 :
                         dbuf_rd_ready_d1 ? 1'b0 :
                         dbuf_rd_valid_d1;
end

always @(
  dbuf_rd_valid_d1
  or dbuf_rd_ready_d1
  ) begin
    dbuf_rd_ready_d0 = ~dbuf_rd_valid_d1 | dbuf_rd_ready_d1;
end

always @(
  dbuf_rd_en
  or dbuf_rd_ready_d0
  ) begin
    dbuf_rd_d0_reg_en = (|dbuf_rd_en) & dbuf_rd_ready_d0;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dbuf_rd_valid_d1 <= 1'b0;
  end else begin
  dbuf_rd_valid_d1 <= dbuf_rd_valid_d1_w;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dbuf_rd_en_d1 <= {8{1'b0}};
  end else begin
  if ((dbuf_rd_d0_reg_en) == 1'b1) begin
    dbuf_rd_en_d1 <= dbuf_rd_en;
  // VCS coverage off
  end else if ((dbuf_rd_d0_reg_en) == 1'b0) begin
  end else begin
    dbuf_rd_en_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_rd_d0_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_rd_addr_d1 <= {5{1'b0}};
  end else begin
  if ((dbuf_rd_d0_reg_en) == 1'b1) begin
    dbuf_rd_addr_d1 <= dbuf_rd_addr;
  // VCS coverage off
  end else if ((dbuf_rd_d0_reg_en) == 1'b0) begin
  end else begin
    dbuf_rd_addr_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_rd_d0_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_rd_layer_end_d1 <= 1'b0;
  end else begin
  if ((dbuf_rd_d0_reg_en) == 1'b1) begin
    dbuf_rd_layer_end_d1 <= dbuf_rd_layer_end;
  // VCS coverage off
  end else if ((dbuf_rd_d0_reg_en) == 1'b0) begin
  end else begin
    dbuf_rd_layer_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_rd_d0_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////
// Input read stage2: select data form all banks                      //
////////////////////////////////////////////////////////////////////////
always @(
  dbuf_rd_en_d1
  or dbuf_rd_data_ecc_0
  or dbuf_rd_data_ecc_1
  or dbuf_rd_data_ecc_2
  or dbuf_rd_data_ecc_3
  or dbuf_rd_data_ecc_4
  or dbuf_rd_data_ecc_5
  or dbuf_rd_data_ecc_6
  or dbuf_rd_data_ecc_7
  ) begin
    dbuf_rd_data_ecc_d2_w = ({512{dbuf_rd_en_d1[0]}} & dbuf_rd_data_ecc_0)
                          | ({512{dbuf_rd_en_d1[1]}} & dbuf_rd_data_ecc_1)
                          | ({512{dbuf_rd_en_d1[2]}} & dbuf_rd_data_ecc_2)
                          | ({512{dbuf_rd_en_d1[3]}} & dbuf_rd_data_ecc_3)
                          | ({512{dbuf_rd_en_d1[4]}} & dbuf_rd_data_ecc_4)
                          | ({512{dbuf_rd_en_d1[5]}} & dbuf_rd_data_ecc_5)
                          | ({512{dbuf_rd_en_d1[6]}} & dbuf_rd_data_ecc_6)
                          | ({512{dbuf_rd_en_d1[7]}} & dbuf_rd_data_ecc_7);
end

always @(
  dbuf_rd_valid_d1
  or dbuf_rd_ready_d2
  or dbuf_rd_valid_d2
  ) begin
    dbuf_rd_valid_d2_w = dbuf_rd_valid_d1 ? 1'b1 :
                         dbuf_rd_ready_d2 ? 1'b0 :
                         dbuf_rd_valid_d2;
end

always @(
  dbuf_rd_valid_d2
  or dbuf_rd_ready_d2
  ) begin
    dbuf_rd_ready_d1 = ~dbuf_rd_valid_d2 | dbuf_rd_ready_d2;
end

always @(
  dbuf_rd_valid_d1
  or dbuf_rd_ready_d1
  ) begin
    dbuf_rd_d1_reg_en = dbuf_rd_valid_d1 & dbuf_rd_ready_d1;
end

////////////////////////////////////////////////////////////////////////
// Input read stage2 registers                                        //
////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dbuf_rd_valid_d2 <= 1'b0;
  end else begin
  dbuf_rd_valid_d2 <= dbuf_rd_valid_d2_w;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dbuf_rd_data_ecc_d2 <= {512{1'b0}};
  end else begin
  if ((dbuf_rd_d1_reg_en) == 1'b1) begin
    dbuf_rd_data_ecc_d2 <= dbuf_rd_data_ecc_d2_w;
  // VCS coverage off
  end else if ((dbuf_rd_d1_reg_en) == 1'b0) begin
  end else begin
    dbuf_rd_data_ecc_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_rd_d1_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_rd_layer_end_d2 <= 1'b0;
  end else begin
  if ((dbuf_rd_d1_reg_en) == 1'b1) begin
    dbuf_rd_layer_end_d2 <= dbuf_rd_layer_end_d1;
  // VCS coverage off
  end else if ((dbuf_rd_d1_reg_en) == 1'b0) begin
  end else begin
    dbuf_rd_layer_end_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_rd_d1_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////
// Input read stage3: to retiming register                            //
////////////////////////////////////////////////////////////////////////


always @(
  dbuf_rd_data_ecc_d2
  ) begin
    dbuf_rd_raw_data = dbuf_rd_data_ecc_d2;
end
always @(
  dbuf_rd_valid_d2
  or dbuf_rd_ready_d3
  or dbuf_rd_valid_d3
  ) begin
    dbuf_rd_valid_d3_w = dbuf_rd_valid_d2 ? 1'b1 :
                         dbuf_rd_ready_d3 ? 1'b0 :
                         dbuf_rd_valid_d3;
end

always @(
  dbuf_rd_valid_d3
  or dbuf_rd_ready_d3
  ) begin
    dbuf_rd_ready_d3_w = ~dbuf_rd_valid_d3 | dbuf_rd_ready_d3;

end

always @(
  dbuf_rd_valid_d2
  or dbuf_rd_ready_d3_w
  ) begin
    dbuf_rd_d2_reg_en = dbuf_rd_valid_d2 & dbuf_rd_ready_d3_w;

end

assign dbuf_rd_ready_d2 = dbuf_rd_ready_d3_w;
assign dbuf_rd_data_d3_w = dbuf_rd_raw_data;

////////////////////////////////////////////////////////////////////////
// Input read stage3 registers                                        //
////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dbuf_rd_valid_d3 <= 1'b0;
  end else begin
  dbuf_rd_valid_d3 <= dbuf_rd_valid_d3_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dbuf_rd_d2_reg_en) == 1'b1) begin
    dbuf_rd_data_d3 <= dbuf_rd_data_d3_w;
  // VCS coverage off
  end else if ((dbuf_rd_d2_reg_en) == 1'b0) begin
  end else begin
    dbuf_rd_data_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dbuf_rd_layer_end_d3 <= 1'b0;
  end else begin
  if ((dbuf_rd_d2_reg_en) == 1'b1) begin
    dbuf_rd_layer_end_d3 <= dbuf_rd_layer_end_d2;
  // VCS coverage off
  end else if ((dbuf_rd_d2_reg_en) == 1'b0) begin
  end else begin
    dbuf_rd_layer_end_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_rd_d2_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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


////////////////////////////////////////////////////////////////////////
// Output stage: rename signals                                       //
////////////////////////////////////////////////////////////////////////


assign cacc2sdp_valid = dbuf_rd_valid_d3;
assign dbuf_rd_ready_d3 = cacc2sdp_ready;

always @(
  dbuf_rd_data_d3
  ) begin
    {cacc2sdp_data15,
     cacc2sdp_data14,
     cacc2sdp_data13,
     cacc2sdp_data12,
     cacc2sdp_data11,
     cacc2sdp_data10,
     cacc2sdp_data9,
     cacc2sdp_data8,
     cacc2sdp_data7,
     cacc2sdp_data6,
     cacc2sdp_data5,
     cacc2sdp_data4,
     cacc2sdp_data3,
     cacc2sdp_data2,
     cacc2sdp_data1,
     cacc2sdp_data0} = dbuf_rd_data_d3;
end




assign cacc2sdp_batch_end = 1'b0;
assign cacc2sdp_layer_end = dbuf_rd_layer_end_d3;


// PKT_PACK_WIRE( nvdla_cc2pp_pkg ,  cacc2sdp_ ,  cacc2sdp_pd )
assign       cacc2sdp_pd[31:0] =     cacc2sdp_data0[31:0];
assign       cacc2sdp_pd[63:32] =     cacc2sdp_data1[31:0];
assign       cacc2sdp_pd[95:64] =     cacc2sdp_data2[31:0];
assign       cacc2sdp_pd[127:96] =     cacc2sdp_data3[31:0];
assign       cacc2sdp_pd[159:128] =     cacc2sdp_data4[31:0];
assign       cacc2sdp_pd[191:160] =     cacc2sdp_data5[31:0];
assign       cacc2sdp_pd[223:192] =     cacc2sdp_data6[31:0];
assign       cacc2sdp_pd[255:224] =     cacc2sdp_data7[31:0];
assign       cacc2sdp_pd[287:256] =     cacc2sdp_data8[31:0];
assign       cacc2sdp_pd[319:288] =     cacc2sdp_data9[31:0];
assign       cacc2sdp_pd[351:320] =     cacc2sdp_data10[31:0];
assign       cacc2sdp_pd[383:352] =     cacc2sdp_data11[31:0];
assign       cacc2sdp_pd[415:384] =     cacc2sdp_data12[31:0];
assign       cacc2sdp_pd[447:416] =     cacc2sdp_data13[31:0];
assign       cacc2sdp_pd[479:448] =     cacc2sdp_data14[31:0];
assign       cacc2sdp_pd[511:480] =     cacc2sdp_data15[31:0];
assign       cacc2sdp_pd[512] =     cacc2sdp_batch_end ;
assign       cacc2sdp_pd[513] =     cacc2sdp_layer_end ;

`ifndef SYNTHESIS
assign dbg_cacc2sdp_dat = {cacc2sdp_data15, cacc2sdp_data14, cacc2sdp_data13, cacc2sdp_data12, cacc2sdp_data11, cacc2sdp_data10, cacc2sdp_data9, cacc2sdp_data8, cacc2sdp_data7, cacc2sdp_data6, cacc2sdp_data5, cacc2sdp_data4, cacc2sdp_data3, cacc2sdp_data2, cacc2sdp_data1, cacc2sdp_data0};

`ifdef NVDLA_PRINT_CACC
always @ (posedge nvdla_core_clk)
begin
    if(cacc2sdp_valid & cacc2sdp_ready)
    begin
        $display("[NVDLA CACC] cacc2sdp_dat = %0512h", dbg_cacc2sdp_dat);

        if(cacc2sdp_layer_end == 1'b1)
        begin
            $display("[NVDLA CACC] layer end");
        end
    end
end
`endif
`endif

//////////////////////////////////////////////////////////////
///// generate CACC done interrupt                       /////
//////////////////////////////////////////////////////////////

assign cacc_done = dbuf_rd_valid_d3 & dbuf_rd_ready_d3 & dbuf_rd_layer_end_d3;
assign cacc_done_intr_w[0] = cacc_done & ~intr_sel;
assign cacc_done_intr_w[1] = cacc_done & intr_sel;
assign intr_sel_w = cacc_done ? ~intr_sel : intr_sel;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    intr_sel <= 1'b0;
  end else begin
  intr_sel <= intr_sel_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cacc_done_intr <= {2{1'b0}};
  end else begin
  cacc_done_intr <= cacc_done_intr_w;
  end
end

assign cacc2glb_done_intr_pd = cacc_done_intr;

//////////////////////////////////////////////////////////////
///// functional point                                   /////
//////////////////////////////////////////////////////////////

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

    property cacc_delivery_buffer__dbuf_rd_d0_en_and_ready__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((|dbuf_rd_en) & dbuf_rd_ready_d1);
    endproperty
    // Cover 0 : "((|dbuf_rd_en) & dbuf_rd_ready_d1)"
    FUNCPOINT_cacc_delivery_buffer__dbuf_rd_d0_en_and_ready__0_COV : cover property (cacc_delivery_buffer__dbuf_rd_d0_en_and_ready__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_delivery_buffer__dbuf_rd_d1_en_and_ready__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (dbuf_rd_valid_d1 & dbuf_rd_ready_d2);
    endproperty
    // Cover 1 : "(dbuf_rd_valid_d1 & dbuf_rd_ready_d2)"
    FUNCPOINT_cacc_delivery_buffer__dbuf_rd_d1_en_and_ready__1_COV : cover property (cacc_delivery_buffer__dbuf_rd_d1_en_and_ready__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_delivery_buffer__dbuf_rd_d2_en_and_ready__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (dbuf_rd_valid_d2 & dbuf_rd_ready_d3);
    endproperty
    // Cover 2 : "(dbuf_rd_valid_d2 & dbuf_rd_ready_d3)"
    FUNCPOINT_cacc_delivery_buffer__dbuf_rd_d2_en_and_ready__2_COV : cover property (cacc_delivery_buffer__dbuf_rd_d2_en_and_ready__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_delivery_buffer__cacc2sdp_stall__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (cacc2sdp_valid & ~cacc2sdp_ready);
    endproperty
    // Cover 3 : "(cacc2sdp_valid & ~cacc2sdp_ready)"
    FUNCPOINT_cacc_delivery_buffer__cacc2sdp_stall__3_COV : cover property (cacc_delivery_buffer__cacc2sdp_stall__3_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_CACC_delivery_buffer


