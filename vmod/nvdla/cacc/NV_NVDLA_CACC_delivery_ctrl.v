// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CACC_delivery_ctrl.v

module NV_NVDLA_CACC_delivery_ctrl (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cacc2sdp_ready
  ,cacc2sdp_valid
  ,dbuf_rd_ready
  ,dlv_data_0
  ,dlv_data_1
  ,dlv_data_2
  ,dlv_data_3
  ,dlv_data_4
  ,dlv_data_5
  ,dlv_data_6
  ,dlv_data_7
  ,dlv_mask
  ,dlv_pd
  ,dlv_valid
  ,reg2dp_batches
  ,reg2dp_conv_mode
  ,reg2dp_dataout_addr
  ,reg2dp_dataout_channel
  ,reg2dp_dataout_height
  ,reg2dp_dataout_width
  ,reg2dp_line_packed
  ,reg2dp_line_stride
  ,reg2dp_op_en
  ,reg2dp_proc_precision
  ,reg2dp_surf_packed
  ,reg2dp_surf_stride
  ,wait_for_op_en
  ,accu2sc_credit_size
  ,accu2sc_credit_vld
  ,dbuf_rd_addr
  ,dbuf_rd_en
  ,dbuf_rd_layer_end
  ,dbuf_wr_addr_0
  ,dbuf_wr_addr_1
  ,dbuf_wr_addr_2
  ,dbuf_wr_addr_3
  ,dbuf_wr_addr_4
  ,dbuf_wr_addr_5
  ,dbuf_wr_addr_6
  ,dbuf_wr_addr_7
  ,dbuf_wr_data_0
  ,dbuf_wr_data_1
  ,dbuf_wr_data_2
  ,dbuf_wr_data_3
  ,dbuf_wr_data_4
  ,dbuf_wr_data_5
  ,dbuf_wr_data_6
  ,dbuf_wr_data_7
  ,dbuf_wr_en
  ,dp2reg_done
  );


input [0:0]                 reg2dp_op_en;
input [0:0]              reg2dp_conv_mode;
input [1:0]         reg2dp_proc_precision;
input [12:0]    reg2dp_dataout_width;
input [12:0]   reg2dp_dataout_height;
input [12:0]  reg2dp_dataout_channel;
input [26:0]       reg2dp_dataout_addr;
input [0:0]         reg2dp_line_packed;
input [0:0]         reg2dp_surf_packed;
input [4:0]            reg2dp_batches;
input [18:0]         reg2dp_line_stride;
input [18:0]         reg2dp_surf_stride;

input          nvdla_core_clk;
input          nvdla_core_rstn;
input          cacc2sdp_ready;
input          cacc2sdp_valid;
input          dbuf_rd_ready;
input  [511:0] dlv_data_0;
input  [511:0] dlv_data_1;
input  [511:0] dlv_data_2;
input  [511:0] dlv_data_3;
input  [511:0] dlv_data_4;
input  [511:0] dlv_data_5;
input  [511:0] dlv_data_6;
input  [511:0] dlv_data_7;
input    [7:0] dlv_mask;
input    [1:0] dlv_pd;
input          dlv_valid;
input          wait_for_op_en;
output   [2:0] accu2sc_credit_size;
output         accu2sc_credit_vld;
output   [4:0] dbuf_rd_addr;
output   [7:0] dbuf_rd_en;
output         dbuf_rd_layer_end;
output   [4:0] dbuf_wr_addr_0;
output   [4:0] dbuf_wr_addr_1;
output   [4:0] dbuf_wr_addr_2;
output   [4:0] dbuf_wr_addr_3;
output   [4:0] dbuf_wr_addr_4;
output   [4:0] dbuf_wr_addr_5;
output   [4:0] dbuf_wr_addr_6;
output   [4:0] dbuf_wr_addr_7;
output [511:0] dbuf_wr_data_0;
output [511:0] dbuf_wr_data_1;
output [511:0] dbuf_wr_data_2;
output [511:0] dbuf_wr_data_3;
output [511:0] dbuf_wr_data_4;
output [511:0] dbuf_wr_data_5;
output [511:0] dbuf_wr_data_6;
output [511:0] dbuf_wr_data_7;
output   [7:0] dbuf_wr_en;
output         dp2reg_done;
wire     [3:0] dlv_data_add_size;
wire           dlv_data_add_valid;
wire           dlv_layer_end;
wire     [3:0] dlv_push_size_d0;
wire           dlv_push_valid_d0;
wire           dlv_stripe_end;
wire           dp2reg_done_w;
wire           is_add_8;
reg            accu2sc_credit_vld;
reg            back_reg_en;
reg      [4:0] batch_cnt;
reg      [4:0] batch_cnt_inc;
reg            batch_cnt_reg_en;
reg      [4:0] batch_cnt_w;
reg      [8:0] channel_cnt;
reg      [8:0] channel_cnt_inc;
reg            channel_cnt_reg_en;
reg      [8:0] channel_cnt_w;
reg      [4:0] cur_batches;
reg      [8:0] cur_channel;
reg      [8:0] cur_channel_w;
reg            cur_conv_mode;
reg     [26:0] cur_dataout_addr;
reg     [12:0] cur_height;
reg            cur_line_packed;
reg      [0:0] cur_line_stride;
reg            cur_op_en;
reg      [1:0] cur_proc_precision;
reg            cur_surf_packed;
reg      [0:0] cur_surf_stride;
reg     [12:0] cur_width;
reg            dataout_addr_cnt;
reg            dataout_addr_cnt_d1;
reg            dataout_addr_cnt_w;
reg            dataout_addr_height_base;
reg            dataout_addr_line_base;
reg            dbuf_empty;
reg      [7:0] dbuf_rd_addr_cnt;
reg      [7:0] dbuf_rd_addr_cnt_inc;
reg      [7:0] dbuf_rd_en;
reg      [7:0] dbuf_rd_mask;
reg      [7:0] dbuf_rd_mask_w;
reg      [4:0] dbuf_wr_addr_0;
reg      [4:0] dbuf_wr_addr_0_w;
reg      [4:0] dbuf_wr_addr_1;
reg      [4:0] dbuf_wr_addr_1_w;
reg      [4:0] dbuf_wr_addr_2;
reg      [4:0] dbuf_wr_addr_2_w;
reg      [4:0] dbuf_wr_addr_3;
reg      [4:0] dbuf_wr_addr_3_w;
reg      [4:0] dbuf_wr_addr_4;
reg      [4:0] dbuf_wr_addr_4_w;
reg      [4:0] dbuf_wr_addr_5;
reg      [4:0] dbuf_wr_addr_5_w;
reg      [4:0] dbuf_wr_addr_6;
reg      [4:0] dbuf_wr_addr_6_w;
reg      [4:0] dbuf_wr_addr_7;
reg      [4:0] dbuf_wr_addr_7_w;
reg      [7:0] dbuf_wr_addr_back;
reg      [1:0] dbuf_wr_addr_back_add;
reg      [7:0] dbuf_wr_addr_back_w;
reg      [7:0] dbuf_wr_addr_base;
reg      [3:0] dbuf_wr_addr_base_add;
reg      [7:0] dbuf_wr_addr_base_w;
reg      [7:0] dbuf_wr_addr_plus;
reg    [511:0] dbuf_wr_data_0;
reg    [511:0] dbuf_wr_data_0_w;
reg    [511:0] dbuf_wr_data_1;
reg    [511:0] dbuf_wr_data_1_w;
reg    [511:0] dbuf_wr_data_2;
reg    [511:0] dbuf_wr_data_2_w;
reg    [511:0] dbuf_wr_data_3;
reg    [511:0] dbuf_wr_data_3_w;
reg    [511:0] dbuf_wr_data_4;
reg    [511:0] dbuf_wr_data_4_w;
reg    [511:0] dbuf_wr_data_5;
reg    [511:0] dbuf_wr_data_5_w;
reg    [511:0] dbuf_wr_data_6;
reg    [511:0] dbuf_wr_data_6_w;
reg    [511:0] dbuf_wr_data_7;
reg    [511:0] dbuf_wr_data_7_w;
reg      [7:0] dbuf_wr_en;
reg      [7:0] dbuf_wr_en_w;
reg      [8:0] dlv_data_avl;
reg      [3:0] dlv_data_avl_add;
reg            dlv_data_avl_sub;
reg      [8:0] dlv_data_avl_w;
reg            dlv_data_sub_valid;
reg      [4:0] dlv_end_addr_w;
reg            dlv_end_clr;
reg      [7:0] dlv_end_mask_w;
reg            dlv_end_set;
reg      [4:0] dlv_end_tag0_addr;
reg      [4:0] dlv_end_tag0_addr_w;
reg            dlv_end_tag0_en;
reg      [7:0] dlv_end_tag0_mask;
reg      [7:0] dlv_end_tag0_mask_w;
reg            dlv_end_tag0_vld;
reg            dlv_end_tag0_vld_w;
reg      [4:0] dlv_end_tag1_addr;
reg      [4:0] dlv_end_tag1_addr_w;
reg            dlv_end_tag1_en;
reg      [7:0] dlv_end_tag1_mask;
reg      [7:0] dlv_end_tag1_mask_w;
reg            dlv_end_tag1_vld;
reg            dlv_end_tag1_vld_w;
reg      [7:0] dlv_last_mask;
reg            dlv_pop;
reg      [3:0] dlv_push_dual;
reg      [3:0] dlv_push_single;
reg      [3:0] dlv_push_size;
reg      [3:0] dlv_push_size_d1;
reg      [3:0] dlv_push_size_d2;
reg            dlv_push_valid;
reg            dlv_push_valid_d1;
reg            dlv_push_valid_d2;
reg            dlv_valid_d1;
reg            dp2reg_done;
reg     [12:0] height_cnt;
reg     [12:0] height_cnt_inc;
reg            height_cnt_reg_en;
reg     [12:0] height_cnt_w;
reg            is_1x1_packed;
reg            is_add_2;
reg            is_add_4;
reg            is_addr_back;
reg            is_batch_end;
reg            is_channel_end;
reg            is_first_atomic;
reg            is_height_end;
reg            is_int8;
reg            is_int8_w;
reg            is_need_reorder;
reg            is_push_skip;
reg            is_width_end;
reg            is_winograd;
reg            is_x1;
reg            is_x2;
reg            is_x4;
reg            is_x8;
reg            mon_batch_cnt_inc;
reg            mon_channel_cnt_inc;
reg            mon_dataout_addr_cnt_w;
reg            mon_dbuf_rd_addr_cnt_inc;
reg            mon_dbuf_wr_addr_back_w;
reg            mon_dbuf_wr_addr_base_w;
reg            mon_dbuf_wr_addr_plus;
reg      [7:0] mon_dbuf_wr_en_w;
reg            mon_dlv_data_avl_w;
reg      [7:0] mon_dlv_end_mask_w;
reg            mon_height_cnt_inc;
reg            mon_width_cnt_inc;
reg            skip_cnt;
reg            skip_cnt_w;
reg     [12:0] width_cnt;
reg     [12:0] width_cnt_inc;
reg            width_cnt_reg_en;
reg     [12:0] width_cnt_w;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//////////////////////////////////////////////////////////////
///// parse input status signal                          /////
//////////////////////////////////////////////////////////////


// PKT_UNPACK_WIRE( nvdla_dbuf_info ,  dlv_ ,  dlv_pd )
assign         dlv_stripe_end  =     dlv_pd[0];
assign         dlv_layer_end  =     dlv_pd[1];

//////////////////////////////////////////////////////////////
///// register input signal from regfile                 /////
//////////////////////////////////////////////////////////////

always @(
  is_int8_w
  or reg2dp_dataout_channel
  ) begin
    cur_channel_w = is_int8_w ? {1'b0, reg2dp_dataout_channel[12:5]} :
                    reg2dp_dataout_channel[12:4];
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cur_op_en <= 1'b0;
  end else begin
  if ((wait_for_op_en & reg2dp_op_en) == 1'b1) begin
    cur_op_en <= reg2dp_op_en;
  // VCS coverage off
  end else if ((wait_for_op_en & reg2dp_op_en) == 1'b0) begin
  end else begin
    cur_op_en <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wait_for_op_en & reg2dp_op_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cur_conv_mode <= 1'b0;
  end else begin
  if ((wait_for_op_en & reg2dp_op_en) == 1'b1) begin
    cur_conv_mode <= reg2dp_conv_mode;
  // VCS coverage off
  end else if ((wait_for_op_en & reg2dp_op_en) == 1'b0) begin
  end else begin
    cur_conv_mode <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wait_for_op_en & reg2dp_op_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cur_proc_precision <= {2{1'b0}};
  end else begin
  if ((wait_for_op_en & reg2dp_op_en) == 1'b1) begin
    cur_proc_precision <= reg2dp_proc_precision;
  // VCS coverage off
  end else if ((wait_for_op_en & reg2dp_op_en) == 1'b0) begin
  end else begin
    cur_proc_precision <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wait_for_op_en & reg2dp_op_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cur_width <= {13{1'b0}};
  end else begin
  if ((wait_for_op_en & reg2dp_op_en) == 1'b1) begin
    cur_width <= reg2dp_dataout_width;
  // VCS coverage off
  end else if ((wait_for_op_en & reg2dp_op_en) == 1'b0) begin
  end else begin
    cur_width <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wait_for_op_en & reg2dp_op_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cur_height <= {13{1'b0}};
  end else begin
  if ((wait_for_op_en & reg2dp_op_en) == 1'b1) begin
    cur_height <= reg2dp_dataout_height;
  // VCS coverage off
  end else if ((wait_for_op_en & reg2dp_op_en) == 1'b0) begin
  end else begin
    cur_height <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wait_for_op_en & reg2dp_op_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cur_channel <= {9{1'b0}};
  end else begin
  if ((wait_for_op_en & reg2dp_op_en) == 1'b1) begin
    cur_channel <= cur_channel_w;
  // VCS coverage off
  end else if ((wait_for_op_en & reg2dp_op_en) == 1'b0) begin
  end else begin
    cur_channel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wait_for_op_en & reg2dp_op_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cur_dataout_addr <= {27{1'b0}};
  end else begin
  if ((wait_for_op_en & reg2dp_op_en) == 1'b1) begin
    cur_dataout_addr <= reg2dp_dataout_addr;
  // VCS coverage off
  end else if ((wait_for_op_en & reg2dp_op_en) == 1'b0) begin
  end else begin
    cur_dataout_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wait_for_op_en & reg2dp_op_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cur_batches <= {5{1'b0}};
  end else begin
  if ((wait_for_op_en & reg2dp_op_en) == 1'b1) begin
    cur_batches <= reg2dp_batches;
  // VCS coverage off
  end else if ((wait_for_op_en & reg2dp_op_en) == 1'b0) begin
  end else begin
    cur_batches <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wait_for_op_en & reg2dp_op_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cur_line_stride <= 1'b0;
  end else begin
  if ((wait_for_op_en & reg2dp_op_en) == 1'b1) begin
    cur_line_stride <= reg2dp_line_stride[0];
  // VCS coverage off
  end else if ((wait_for_op_en & reg2dp_op_en) == 1'b0) begin
  end else begin
    cur_line_stride <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wait_for_op_en & reg2dp_op_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cur_surf_stride <= 1'b0;
  end else begin
  if ((wait_for_op_en & reg2dp_op_en) == 1'b1) begin
    cur_surf_stride <= reg2dp_surf_stride[0];
  // VCS coverage off
  end else if ((wait_for_op_en & reg2dp_op_en) == 1'b0) begin
  end else begin
    cur_surf_stride <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wait_for_op_en & reg2dp_op_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cur_line_packed <= 1'b0;
  end else begin
  if ((wait_for_op_en & reg2dp_op_en) == 1'b1) begin
    cur_line_packed <= reg2dp_line_packed;
  // VCS coverage off
  end else if ((wait_for_op_en & reg2dp_op_en) == 1'b0) begin
  end else begin
    cur_line_packed <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wait_for_op_en & reg2dp_op_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cur_surf_packed <= 1'b0;
  end else begin
  if ((wait_for_op_en & reg2dp_op_en) == 1'b1) begin
    cur_surf_packed <= reg2dp_surf_packed;
  // VCS coverage off
  end else if ((wait_for_op_en & reg2dp_op_en) == 1'b0) begin
  end else begin
    cur_surf_packed <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wait_for_op_en & reg2dp_op_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
///// generate current status signals                    /////
//////////////////////////////////////////////////////////////

always @(
  reg2dp_proc_precision
  ) begin
    is_int8_w = (reg2dp_proc_precision == 2'h0 );
end

always @(
  cur_proc_precision
  ) begin
    is_int8 = (cur_proc_precision == 2'h0 );
end

always @(
  cur_conv_mode
  ) begin
    is_winograd = (cur_conv_mode == 1'h1 );
end

always @(
  is_int8
  or is_winograd
  ) begin
    is_x1 = ~is_int8 & ~is_winograd;
end

always @(
  is_int8
  or is_winograd
  ) begin
    is_x2 = is_int8 & ~is_winograd;
end

always @(
  is_int8
  or is_winograd
  ) begin
    is_x4 = ~is_int8 & is_winograd;
end

always @(
  is_int8
  or is_winograd
  ) begin
    is_x8 = is_int8 & is_winograd;
end

always @(
  cur_batches
  ) begin
    is_need_reorder = |(cur_batches);
end

always @(
  cur_width
  or cur_height
  or cur_line_packed
  or cur_surf_packed
  ) begin
    is_1x1_packed = ~(|cur_width) & ~(|cur_height) & cur_line_packed & cur_surf_packed;
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
  nv_assert_never #(0,0,"Config error! Winograd mode with multi-batch!")      zzz_assert_never_13x (nvdla_core_clk, `ASSERT_RESET, (is_need_reorder & is_winograd)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! line_packed is not match line stride!")      zzz_assert_never_14x (nvdla_core_clk, `ASSERT_RESET, (cur_op_en & is_need_reorder & (cur_line_packed & (cur_width[0] == cur_line_stride)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! surf_packed is not match surf stride!")      zzz_assert_never_15x (nvdla_core_clk, `ASSERT_RESET, (cur_op_en & is_need_reorder & (cur_surf_packed & ((cur_width[0] | cur_height[0]) == cur_surf_stride)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
///// generate base address                              /////
//////////////////////////////////////////////////////////////

always @(
  is_add_8
  or is_add_4
  or is_add_2
  ) begin
    dbuf_wr_addr_base_add = is_add_8 ? 4'h8 :
                            is_add_4 ? 4'h4 :
                            is_add_2 ? 4'h2 :
                            4'h1;
end

always @(
  is_add_4
  ) begin
    dbuf_wr_addr_back_add = is_add_4 ? 2'h2 : 2'h1;
end

always @(
  is_addr_back
  or dbuf_wr_addr_back
  or dbuf_wr_addr_base
  or dbuf_wr_addr_base_add
  ) begin
    {mon_dbuf_wr_addr_base_w,
     dbuf_wr_addr_base_w} = is_addr_back ? {1'b0, dbuf_wr_addr_back} :
                            dbuf_wr_addr_base + dbuf_wr_addr_base_add;
end

always @(
  dbuf_wr_addr_base
  or dbuf_wr_addr_back_add
  ) begin
    {mon_dbuf_wr_addr_back_w,
     dbuf_wr_addr_back_w} = dbuf_wr_addr_base + dbuf_wr_addr_back_add;
end

always @(
  dbuf_wr_addr_base
  ) begin
    {mon_dbuf_wr_addr_plus,
     dbuf_wr_addr_plus} = dbuf_wr_addr_base + 5'h8;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dbuf_wr_addr_base <= {8{1'b0}};
  end else begin
  if ((dlv_valid) == 1'b1) begin
    dbuf_wr_addr_base <= dbuf_wr_addr_base_w;
  // VCS coverage off
  end else if ((dlv_valid) == 1'b0) begin
  end else begin
    dbuf_wr_addr_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dlv_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_back <= {8{1'b0}};
  end else begin
  if ((dlv_valid & back_reg_en) == 1'b1) begin
    dbuf_wr_addr_back <= dbuf_wr_addr_back_w;
  // VCS coverage off
  end else if ((dlv_valid & back_reg_en) == 1'b0) begin
  end else begin
    dbuf_wr_addr_back <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dlv_valid & back_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
///// generate dbuf wright signal                        /////
//////////////////////////////////////////////////////////////


always @(
  dlv_valid
  or dlv_mask
  or dbuf_wr_addr_base
  ) begin
    {dbuf_wr_en_w, mon_dbuf_wr_en_w} = (({16{dlv_valid}} & {dlv_mask, dlv_mask}) << dbuf_wr_addr_base[2:0]);
end


always @(
  dbuf_wr_addr_base
  or dbuf_wr_addr_plus
  ) begin
    dbuf_wr_addr_0_w = (dbuf_wr_addr_base[2:0] > 3'h0) ? dbuf_wr_addr_plus[5 +2:3] :
                       dbuf_wr_addr_base[5 +2:3];
end


always @(
  dbuf_wr_addr_base
  or dbuf_wr_addr_plus
  ) begin
    dbuf_wr_addr_1_w = (dbuf_wr_addr_base[2:0] > 3'h1) ? dbuf_wr_addr_plus[5 +2:3] :
                       dbuf_wr_addr_base[5 +2:3];
end


always @(
  dbuf_wr_addr_base
  or dbuf_wr_addr_plus
  ) begin
    dbuf_wr_addr_2_w = (dbuf_wr_addr_base[2:0] > 3'h2) ? dbuf_wr_addr_plus[5 +2:3] :
                       dbuf_wr_addr_base[5 +2:3];
end


always @(
  dbuf_wr_addr_base
  or dbuf_wr_addr_plus
  ) begin
    dbuf_wr_addr_3_w = (dbuf_wr_addr_base[2:0] > 3'h3) ? dbuf_wr_addr_plus[5 +2:3] :
                       dbuf_wr_addr_base[5 +2:3];
end


always @(
  dbuf_wr_addr_base
  or dbuf_wr_addr_plus
  ) begin
    dbuf_wr_addr_4_w = (dbuf_wr_addr_base[2:0] > 3'h4) ? dbuf_wr_addr_plus[5 +2:3] :
                       dbuf_wr_addr_base[5 +2:3];
end


always @(
  dbuf_wr_addr_base
  or dbuf_wr_addr_plus
  ) begin
    dbuf_wr_addr_5_w = (dbuf_wr_addr_base[2:0] > 3'h5) ? dbuf_wr_addr_plus[5 +2:3] :
                       dbuf_wr_addr_base[5 +2:3];
end


always @(
  dbuf_wr_addr_base
  or dbuf_wr_addr_plus
  ) begin
    dbuf_wr_addr_6_w = (dbuf_wr_addr_base[2:0] > 3'h6) ? dbuf_wr_addr_plus[5 +2:3] :
                       dbuf_wr_addr_base[5 +2:3];
end


always @(
  dbuf_wr_addr_base
  or dbuf_wr_addr_plus
  ) begin
    dbuf_wr_addr_7_w = (dbuf_wr_addr_base[2:0] > 3'h7) ? dbuf_wr_addr_plus[5 +2:3] :
                       dbuf_wr_addr_base[5 +2:3];
end



always @(
  dbuf_wr_addr_base
  or dlv_data_0
  or dlv_data_1
  or dlv_data_2
  or dlv_data_3
  or dlv_data_4
  or dlv_data_5
  or dlv_data_6
  or dlv_data_7
  ) begin
    dbuf_wr_data_0_w = (dbuf_wr_addr_base[2:0] == 3'h0) ? dlv_data_0 :
                       (dbuf_wr_addr_base[2:0] == 3'h7) ? dlv_data_1 :
                       (dbuf_wr_addr_base[2:0] == 3'h6) ? dlv_data_2 :
                       (dbuf_wr_addr_base[2:0] == 3'h5) ? dlv_data_3 :
                       (dbuf_wr_addr_base[2:0] == 3'h4) ? dlv_data_4 :
                       (dbuf_wr_addr_base[2:0] == 3'h3) ? dlv_data_5 :
                       (dbuf_wr_addr_base[2:0] == 3'h2) ? dlv_data_6 :
                       dlv_data_7;
end

always @(
  dbuf_wr_addr_base
  or dlv_data_0
  or dlv_data_1
  or dlv_data_2
  or dlv_data_3
  or dlv_data_4
  or dlv_data_5
  or dlv_data_6
  or dlv_data_7
  ) begin
    dbuf_wr_data_1_w = (dbuf_wr_addr_base[2:0] == 3'h1) ? dlv_data_0 :
                       (dbuf_wr_addr_base[2:0] == 3'h0) ? dlv_data_1 :
                       (dbuf_wr_addr_base[2:0] == 3'h7) ? dlv_data_2 :
                       (dbuf_wr_addr_base[2:0] == 3'h6) ? dlv_data_3 :
                       (dbuf_wr_addr_base[2:0] == 3'h5) ? dlv_data_4 :
                       (dbuf_wr_addr_base[2:0] == 3'h4) ? dlv_data_5 :
                       (dbuf_wr_addr_base[2:0] == 3'h3) ? dlv_data_6 :
                       dlv_data_7;
end

always @(
  dbuf_wr_addr_base
  or dlv_data_0
  or dlv_data_1
  or dlv_data_2
  or dlv_data_3
  or dlv_data_4
  or dlv_data_5
  or dlv_data_6
  or dlv_data_7
  ) begin
    dbuf_wr_data_2_w = (dbuf_wr_addr_base[2:0] == 3'h2) ? dlv_data_0 :
                       (dbuf_wr_addr_base[2:0] == 3'h1) ? dlv_data_1 :
                       (dbuf_wr_addr_base[2:0] == 3'h0) ? dlv_data_2 :
                       (dbuf_wr_addr_base[2:0] == 3'h7) ? dlv_data_3 :
                       (dbuf_wr_addr_base[2:0] == 3'h6) ? dlv_data_4 :
                       (dbuf_wr_addr_base[2:0] == 3'h5) ? dlv_data_5 :
                       (dbuf_wr_addr_base[2:0] == 3'h4) ? dlv_data_6 :
                       dlv_data_7;
end

always @(
  dbuf_wr_addr_base
  or dlv_data_0
  or dlv_data_1
  or dlv_data_2
  or dlv_data_3
  or dlv_data_4
  or dlv_data_5
  or dlv_data_6
  or dlv_data_7
  ) begin
    dbuf_wr_data_3_w = (dbuf_wr_addr_base[2:0] == 3'h3) ? dlv_data_0 :
                       (dbuf_wr_addr_base[2:0] == 3'h2) ? dlv_data_1 :
                       (dbuf_wr_addr_base[2:0] == 3'h1) ? dlv_data_2 :
                       (dbuf_wr_addr_base[2:0] == 3'h0) ? dlv_data_3 :
                       (dbuf_wr_addr_base[2:0] == 3'h7) ? dlv_data_4 :
                       (dbuf_wr_addr_base[2:0] == 3'h6) ? dlv_data_5 :
                       (dbuf_wr_addr_base[2:0] == 3'h5) ? dlv_data_6 :
                       dlv_data_7;
end

always @(
  dbuf_wr_addr_base
  or dlv_data_0
  or dlv_data_1
  or dlv_data_2
  or dlv_data_3
  or dlv_data_4
  or dlv_data_5
  or dlv_data_6
  or dlv_data_7
  ) begin
    dbuf_wr_data_4_w = (dbuf_wr_addr_base[2:0] == 3'h4) ? dlv_data_0 :
                       (dbuf_wr_addr_base[2:0] == 3'h3) ? dlv_data_1 :
                       (dbuf_wr_addr_base[2:0] == 3'h2) ? dlv_data_2 :
                       (dbuf_wr_addr_base[2:0] == 3'h1) ? dlv_data_3 :
                       (dbuf_wr_addr_base[2:0] == 3'h0) ? dlv_data_4 :
                       (dbuf_wr_addr_base[2:0] == 3'h7) ? dlv_data_5 :
                       (dbuf_wr_addr_base[2:0] == 3'h6) ? dlv_data_6 :
                       dlv_data_7;
end

always @(
  dbuf_wr_addr_base
  or dlv_data_0
  or dlv_data_1
  or dlv_data_2
  or dlv_data_3
  or dlv_data_4
  or dlv_data_5
  or dlv_data_6
  or dlv_data_7
  ) begin
    dbuf_wr_data_5_w = (dbuf_wr_addr_base[2:0] == 3'h5) ? dlv_data_0 :
                       (dbuf_wr_addr_base[2:0] == 3'h4) ? dlv_data_1 :
                       (dbuf_wr_addr_base[2:0] == 3'h3) ? dlv_data_2 :
                       (dbuf_wr_addr_base[2:0] == 3'h2) ? dlv_data_3 :
                       (dbuf_wr_addr_base[2:0] == 3'h1) ? dlv_data_4 :
                       (dbuf_wr_addr_base[2:0] == 3'h0) ? dlv_data_5 :
                       (dbuf_wr_addr_base[2:0] == 3'h7) ? dlv_data_6 :
                       dlv_data_7;
end

always @(
  dbuf_wr_addr_base
  or dlv_data_0
  or dlv_data_1
  or dlv_data_2
  or dlv_data_3
  or dlv_data_4
  or dlv_data_5
  or dlv_data_6
  or dlv_data_7
  ) begin
    dbuf_wr_data_6_w = (dbuf_wr_addr_base[2:0] == 3'h6) ? dlv_data_0 :
                       (dbuf_wr_addr_base[2:0] == 3'h5) ? dlv_data_1 :
                       (dbuf_wr_addr_base[2:0] == 3'h4) ? dlv_data_2 :
                       (dbuf_wr_addr_base[2:0] == 3'h3) ? dlv_data_3 :
                       (dbuf_wr_addr_base[2:0] == 3'h2) ? dlv_data_4 :
                       (dbuf_wr_addr_base[2:0] == 3'h1) ? dlv_data_5 :
                       (dbuf_wr_addr_base[2:0] == 3'h0) ? dlv_data_6 :
                       dlv_data_7;
end

always @(
  dbuf_wr_addr_base
  or dlv_data_0
  or dlv_data_1
  or dlv_data_2
  or dlv_data_3
  or dlv_data_4
  or dlv_data_5
  or dlv_data_6
  or dlv_data_7
  ) begin
    dbuf_wr_data_7_w = (dbuf_wr_addr_base[2:0] == 3'h7) ? dlv_data_0 :
                       (dbuf_wr_addr_base[2:0] == 3'h6) ? dlv_data_1 :
                       (dbuf_wr_addr_base[2:0] == 3'h5) ? dlv_data_2 :
                       (dbuf_wr_addr_base[2:0] == 3'h4) ? dlv_data_3 :
                       (dbuf_wr_addr_base[2:0] == 3'h3) ? dlv_data_4 :
                       (dbuf_wr_addr_base[2:0] == 3'h2) ? dlv_data_5 :
                       (dbuf_wr_addr_base[2:0] == 3'h1) ? dlv_data_6 :
                       dlv_data_7;
end




always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dlv_valid_d1 <= 1'b0;
  end else begin
  dlv_valid_d1 <= dlv_valid;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dbuf_wr_en <= {8{1'b0}};
  end else begin
  if ((dlv_valid | dlv_valid_d1) == 1'b1) begin
    dbuf_wr_en <= dbuf_wr_en_w;
  // VCS coverage off
  end else if ((dlv_valid | dlv_valid_d1) == 1'b0) begin
  end else begin
    dbuf_wr_en <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dlv_valid | dlv_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_0 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_w[0]) == 1'b1) begin
    dbuf_wr_addr_0 <= dbuf_wr_addr_0_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[0]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_w[0]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_1 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_w[1]) == 1'b1) begin
    dbuf_wr_addr_1 <= dbuf_wr_addr_1_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[1]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_w[1]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_2 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_w[2]) == 1'b1) begin
    dbuf_wr_addr_2 <= dbuf_wr_addr_2_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[2]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_w[2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_3 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_w[3]) == 1'b1) begin
    dbuf_wr_addr_3 <= dbuf_wr_addr_3_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[3]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_w[3]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_4 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_w[4]) == 1'b1) begin
    dbuf_wr_addr_4 <= dbuf_wr_addr_4_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[4]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_w[4]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_5 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_w[5]) == 1'b1) begin
    dbuf_wr_addr_5 <= dbuf_wr_addr_5_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[5]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_w[5]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_6 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_w[6]) == 1'b1) begin
    dbuf_wr_addr_6 <= dbuf_wr_addr_6_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[6]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_w[6]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_wr_addr_7 <= {5{1'b0}};
  end else begin
  if ((dbuf_wr_en_w[7]) == 1'b1) begin
    dbuf_wr_addr_7 <= dbuf_wr_addr_7_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[7]) == 1'b0) begin
  end else begin
    dbuf_wr_addr_7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbuf_wr_en_w[7]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  if ((dbuf_wr_en_w[0]) == 1'b1) begin
    dbuf_wr_data_0 <= dbuf_wr_data_0_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[0]) == 1'b0) begin
  end else begin
    dbuf_wr_data_0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_w[1]) == 1'b1) begin
    dbuf_wr_data_1 <= dbuf_wr_data_1_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[1]) == 1'b0) begin
  end else begin
    dbuf_wr_data_1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_w[2]) == 1'b1) begin
    dbuf_wr_data_2 <= dbuf_wr_data_2_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[2]) == 1'b0) begin
  end else begin
    dbuf_wr_data_2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_w[3]) == 1'b1) begin
    dbuf_wr_data_3 <= dbuf_wr_data_3_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[3]) == 1'b0) begin
  end else begin
    dbuf_wr_data_3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_w[4]) == 1'b1) begin
    dbuf_wr_data_4 <= dbuf_wr_data_4_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[4]) == 1'b0) begin
  end else begin
    dbuf_wr_data_4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_w[5]) == 1'b1) begin
    dbuf_wr_data_5 <= dbuf_wr_data_5_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[5]) == 1'b0) begin
  end else begin
    dbuf_wr_data_5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_w[6]) == 1'b1) begin
    dbuf_wr_data_6 <= dbuf_wr_data_6_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[6]) == 1'b0) begin
  end else begin
    dbuf_wr_data_6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dbuf_wr_en_w[7]) == 1'b1) begin
    dbuf_wr_data_7 <= dbuf_wr_data_7_w;
  // VCS coverage off
  end else if ((dbuf_wr_en_w[7]) == 1'b0) begin
  end else begin
    dbuf_wr_data_7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end



//////////////////////////////////////////////////////////////
///// generate reordering signal                         /////
//////////////////////////////////////////////////////////////

/////////////////// batch count ///////////////////
always @(
  batch_cnt
  ) begin
    {mon_batch_cnt_inc, batch_cnt_inc} = batch_cnt + 1'b1;
end

always @(
  batch_cnt
  or cur_batches
  ) begin
    is_batch_end = (batch_cnt == cur_batches);
end

always @(
  is_batch_end
  or batch_cnt_inc
  ) begin
    batch_cnt_w = is_batch_end ? 5'b0 : batch_cnt_inc;
end

always @(
  dlv_valid
  or is_need_reorder
  ) begin
    batch_cnt_reg_en = dlv_valid & is_need_reorder;
end

/////////////////// line count ///////////////////
always @(
  width_cnt
  ) begin
    {mon_width_cnt_inc, width_cnt_inc} = width_cnt + 1'b1;
end

always @(
  width_cnt
  or cur_width
  ) begin
    is_width_end = (width_cnt == cur_width);
end

always @(
  is_width_end
  or width_cnt_inc
  ) begin
    width_cnt_w = is_width_end ? 13'b0 : width_cnt_inc;
end

always @(
  dlv_valid
  or is_need_reorder
  or is_batch_end
  ) begin
    width_cnt_reg_en = dlv_valid & is_need_reorder & is_batch_end;
end

/////////////////// height count ///////////////////
always @(
  height_cnt
  ) begin
    {mon_height_cnt_inc, height_cnt_inc} = height_cnt + 1'b1;
end

always @(
  height_cnt
  or cur_height
  ) begin
    is_height_end = (height_cnt == cur_height);
end

always @(
  is_height_end
  or height_cnt_inc
  ) begin
    height_cnt_w = is_height_end ? 13'b0 : height_cnt_inc;
end

always @(
  dlv_valid
  or is_need_reorder
  or is_batch_end
  or is_width_end
  ) begin
    height_cnt_reg_en = dlv_valid & is_need_reorder & is_batch_end & is_width_end;
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
  nv_assert_never #(0,0,"Error! height_cnt out of range!")      zzz_assert_never_27x (nvdla_core_clk, `ASSERT_RESET, (height_cnt >= 3840)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////// channel count ///////////////////
always @(
  channel_cnt
  ) begin
    {mon_channel_cnt_inc, channel_cnt_inc} = channel_cnt + 1'b1;
end

always @(
  channel_cnt
  or cur_channel
  ) begin
    is_channel_end = (channel_cnt == cur_channel);
end

always @(
  is_channel_end
  or channel_cnt_inc
  ) begin
    channel_cnt_w = is_channel_end ? 9'b0 : channel_cnt_inc;
end

always @(
  dlv_valid
  or is_need_reorder
  or is_batch_end
  or is_width_end
  or is_height_end
  ) begin
    channel_cnt_reg_en = dlv_valid & is_need_reorder & is_batch_end & is_width_end & is_height_end;
end

/////////////////// address cnt for output feature data ///////////////////
always @(
  dlv_valid
  or batch_cnt
  or width_cnt
  or height_cnt
  or channel_cnt
  ) begin
    is_first_atomic = dlv_valid
                    & (batch_cnt == 5'b0)
                    & (width_cnt == 13'b0)
                    & (height_cnt == 13'b0)
                    & (channel_cnt == 9'b0);
end

always @(
  channel_cnt_reg_en
  or dataout_addr_height_base
  or cur_surf_stride
  or height_cnt_reg_en
  or dataout_addr_line_base
  or cur_line_stride
  or width_cnt_reg_en
  or dataout_addr_cnt
  ) begin
    {mon_dataout_addr_cnt_w,
     dataout_addr_cnt_w} = channel_cnt_reg_en ? (dataout_addr_height_base + cur_surf_stride[0]) :
                           height_cnt_reg_en ? (dataout_addr_line_base + cur_line_stride[0]) :
                           width_cnt_reg_en ? (dataout_addr_cnt + 1'b1) :
                           dataout_addr_cnt;
end

always @(
  is_first_atomic
  or cur_dataout_addr
  or dataout_addr_cnt_d1
  ) begin
    dataout_addr_cnt = is_first_atomic ? cur_dataout_addr[0] : dataout_addr_cnt_d1;
end

/////////////////// generate skipping and add signal for write address ///////////////////
//As SDP owner required, output data cube write sequence is always treated as line unpack, including 1x1 case
//Nvbug 200328533
//&Always;
//    is_push_skip = skip_cnt ? ~is_batch_end :
//                   is_need_reorder & (~dataout_addr_cnt & (~is_width_end | (is_1x1_packed & ~is_channel_end)));
//&End;


always @(
  skip_cnt
  or is_batch_end
  or is_need_reorder
  or dataout_addr_cnt
  or is_width_end
  ) begin
    is_push_skip = skip_cnt ? ~is_batch_end :
                   is_need_reorder & ~dataout_addr_cnt & ~is_width_end;
end

always @(
  cur_op_en
  or is_need_reorder
  or dlv_valid
  or dlv_stripe_end
  or dlv_layer_end
  or is_batch_end
  or skip_cnt
  or is_push_skip
  ) begin
    skip_cnt_w = (~cur_op_en | ~is_need_reorder) ? 1'b0 :
                 (dlv_valid & dlv_stripe_end & dlv_layer_end) ? 1'b0 :
                 (is_batch_end & skip_cnt) ? 1'b0 :
                 (is_batch_end & ~skip_cnt) ? is_push_skip :
                 skip_cnt;
end

always @(
  is_x1
  or is_push_skip
  or is_x2
  ) begin
    is_add_2 = (is_x1 & is_push_skip) | (is_x2 & ~is_push_skip);
end

always @(
  is_x2
  or is_push_skip
  or is_x4
  ) begin
    is_add_4 = (is_x2 & is_push_skip) | (is_x4 & ~is_push_skip);
end

assign is_add_8 = is_x8;

always @(
  is_push_skip
  or skip_cnt
  or is_batch_end
  ) begin
    is_addr_back = is_push_skip & ~skip_cnt & is_batch_end;
end

always @(
  is_push_skip
  or batch_cnt
  ) begin
    back_reg_en = is_push_skip & (batch_cnt == 5'b0);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    batch_cnt <= {5{1'b0}};
  end else begin
  if ((batch_cnt_reg_en) == 1'b1) begin
    batch_cnt <= batch_cnt_w;
  // VCS coverage off
  end else if ((batch_cnt_reg_en) == 1'b0) begin
  end else begin
    batch_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(batch_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    width_cnt <= {13{1'b0}};
  end else begin
  if ((width_cnt_reg_en) == 1'b1) begin
    width_cnt <= width_cnt_w;
  // VCS coverage off
  end else if ((width_cnt_reg_en) == 1'b0) begin
  end else begin
    width_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(width_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    height_cnt <= {13{1'b0}};
  end else begin
  if ((height_cnt_reg_en) == 1'b1) begin
    height_cnt <= height_cnt_w;
  // VCS coverage off
  end else if ((height_cnt_reg_en) == 1'b0) begin
  end else begin
    height_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_30x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(height_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    channel_cnt <= {9{1'b0}};
  end else begin
  if ((channel_cnt_reg_en) == 1'b1) begin
    channel_cnt <= channel_cnt_w;
  // VCS coverage off
  end else if ((channel_cnt_reg_en) == 1'b0) begin
  end else begin
    channel_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(channel_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dataout_addr_cnt_d1 <= 1'b0;
  end else begin
  if ((width_cnt_reg_en | is_first_atomic) == 1'b1) begin
    dataout_addr_cnt_d1 <= dataout_addr_cnt_w;
  // VCS coverage off
  end else if ((width_cnt_reg_en | is_first_atomic) == 1'b0) begin
  end else begin
    dataout_addr_cnt_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(width_cnt_reg_en | is_first_atomic))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dataout_addr_line_base <= 1'b0;
  end else begin
  if ((height_cnt_reg_en | is_first_atomic) == 1'b1) begin
    dataout_addr_line_base <= dataout_addr_cnt_w;
  // VCS coverage off
  end else if ((height_cnt_reg_en | is_first_atomic) == 1'b0) begin
  end else begin
    dataout_addr_line_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_33x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(height_cnt_reg_en | is_first_atomic))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dataout_addr_height_base <= 1'b0;
  end else begin
  if ((channel_cnt_reg_en | is_first_atomic) == 1'b1) begin
    dataout_addr_height_base <= dataout_addr_cnt_w;
  // VCS coverage off
  end else if ((channel_cnt_reg_en | is_first_atomic) == 1'b0) begin
  end else begin
    dataout_addr_height_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_34x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(channel_cnt_reg_en | is_first_atomic))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    skip_cnt <= 1'b0;
  end else begin
  skip_cnt <= skip_cnt_w;
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
  nv_assert_never #(0,0,"Error! is_x8 conflict with reorder!")      zzz_assert_never_35x (nvdla_core_clk, `ASSERT_RESET, (is_x8 & is_need_reorder)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! is_x4 conflict with reorder!")      zzz_assert_never_36x (nvdla_core_clk, `ASSERT_RESET, (is_x4 & is_need_reorder)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
///// generate stored data size                          /////
//////////////////////////////////////////////////////////////

always @(
  is_x8
  or is_x4
  or is_x2
  ) begin
    dlv_push_single = is_x8 ? 4'h8 :
                      is_x4 ? 4'h4 :
                      is_x2 ? 4'h2 :
                      4'h1;
end

always @(
  is_x2
  ) begin
    dlv_push_dual = is_x2 ? 4'h4 : 4'h2;
end

always @(
  skip_cnt
  or dlv_push_dual
  or dlv_push_single
  ) begin
    dlv_push_size = (skip_cnt) ? dlv_push_dual : dlv_push_single;
end

always @(
  dlv_valid
  or is_push_skip
  or skip_cnt
  ) begin
    dlv_push_valid = (dlv_valid & (~is_push_skip | skip_cnt));
end

assign dlv_push_valid_d0 = dlv_push_valid;
assign dlv_push_size_d0 = dlv_push_size;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dlv_push_valid_d1 <= 1'b0;
  end else begin
  dlv_push_valid_d1 <= dlv_push_valid_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dlv_push_size_d1 <= {4{1'b0}};
  end else begin
  if ((dlv_push_valid_d0) == 1'b1) begin
    dlv_push_size_d1 <= dlv_push_size_d0;
  // VCS coverage off
  end else if ((dlv_push_valid_d0) == 1'b0) begin
  end else begin
    dlv_push_size_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_37x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dlv_push_valid_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dlv_push_valid_d2 <= 1'b0;
  end else begin
  dlv_push_valid_d2 <= dlv_push_valid_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dlv_push_size_d2 <= {4{1'b0}};
  end else begin
  if ((dlv_push_valid_d1) == 1'b1) begin
    dlv_push_size_d2 <= dlv_push_size_d1;
  // VCS coverage off
  end else if ((dlv_push_valid_d1) == 1'b0) begin
  end else begin
    dlv_push_size_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_38x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dlv_push_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dlv_data_add_valid = dlv_push_valid_d2;
assign dlv_data_add_size = dlv_push_size_d2;

///////////////////////////////////// output data counter /////////////////////////////////

always @(
  dlv_data_add_valid
  or dlv_data_add_size
  ) begin
    dlv_data_avl_add = dlv_data_add_valid ? dlv_data_add_size : 4'h0;
end

always @(
  dlv_pop
  ) begin
    dlv_data_avl_sub = dlv_pop ? 1'b1 : 1'b0;
end

always @(
  dlv_pop
  ) begin
    dlv_data_sub_valid = dlv_pop;
end

always @(
  dlv_data_avl
  or dlv_data_avl_add
  or dlv_data_avl_sub
  ) begin
    {mon_dlv_data_avl_w,
     dlv_data_avl_w} = dlv_data_avl + dlv_data_avl_add - dlv_data_avl_sub;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dlv_data_avl <= {9{1'b0}};
  end else begin
  if ((dlv_data_add_valid | dlv_data_sub_valid) == 1'b1) begin
    dlv_data_avl <= dlv_data_avl_w;
  // VCS coverage off
  end else if ((dlv_data_add_valid | dlv_data_sub_valid) == 1'b0) begin
  end else begin
    dlv_data_avl <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_39x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dlv_data_add_valid | dlv_data_sub_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! dlv_data_avl_w is overflow")      zzz_assert_never_40x (nvdla_core_clk, `ASSERT_RESET, (mon_dlv_data_avl_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! dlv_data_avl_w is out of range")      zzz_assert_never_41x (nvdla_core_clk, `ASSERT_RESET, (dlv_data_avl > {1'b1, {8{1'b0}}})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
///// generate dbuf read request                         /////
//////////////////////////////////////////////////////////////


always @(
  dbuf_rd_en
  or dbuf_rd_ready
  ) begin
    dlv_pop = (|dbuf_rd_en) & dbuf_rd_ready;
end

always @(
  dbuf_rd_addr_cnt
  ) begin
    {mon_dbuf_rd_addr_cnt_inc,
     dbuf_rd_addr_cnt_inc} = dbuf_rd_addr_cnt + 1'b1;
end

always @(
  dlv_data_avl
  ) begin
    dbuf_empty = ~(|dlv_data_avl);
end

always @(
  dbuf_rd_addr_cnt_inc
  ) begin
    dbuf_rd_mask_w = (8'h1 << dbuf_rd_addr_cnt_inc[2:0]);
end

always @(
  dbuf_empty
  or dbuf_rd_mask
  ) begin
    dbuf_rd_en = ~{8{dbuf_empty}} & dbuf_rd_mask;
end

assign dbuf_rd_addr = dbuf_rd_addr_cnt[5 +2:3];

//////////////////////////////////////////////////////////////
///// generate dbuf read request                         /////
//////////////////////////////////////////////////////////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dbuf_rd_addr_cnt <= {8{1'b0}};
  end else begin
  if ((dlv_pop) == 1'b1) begin
    dbuf_rd_addr_cnt <= dbuf_rd_addr_cnt_inc;
  // VCS coverage off
  end else if ((dlv_pop) == 1'b0) begin
  end else begin
    dbuf_rd_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dlv_pop))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dbuf_rd_mask <= 8'h1;
  end else begin
  if ((dlv_pop) == 1'b1) begin
    dbuf_rd_mask <= dbuf_rd_mask_w;
  // VCS coverage off
  end else if ((dlv_pop) == 1'b0) begin
  end else begin
    dbuf_rd_mask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_43x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dlv_pop))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// Inferring message: you should provide one
  // VCS coverage off 
  nv_assert_one_hot #(0,8,0,"Danger")      zzz_assert_one_hot_44x (nvdla_core_clk, `ASSERT_RESET, dbuf_rd_mask); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// Inferring message: you should provide one
  // VCS coverage off 
  nv_assert_zero_one_hot #(0,8,0,"Danger")      zzz_assert_zero_one_hot_45x (nvdla_core_clk, `ASSERT_RESET, dbuf_rd_en); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////
/////// generate dp2reg_done signal                        /////
////////////////////////////////////////////////////////////////

assign dp2reg_done_w = dlv_valid & dlv_stripe_end & dlv_layer_end;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_done <= 1'b0;
  end else begin
  dp2reg_done <= dp2reg_done_w;
  end
end

////////////////////////////////////////////////////////////////
/////// generate output package for sdp                    /////
////////////////////////////////////////////////////////////////

always @(
  dlv_valid
  or dlv_stripe_end
  or dlv_layer_end
  ) begin
    dlv_end_set = dlv_valid & dlv_stripe_end & dlv_layer_end;
end

always @(
  is_x1
  or is_x2
  or is_x4
  ) begin
    dlv_last_mask = is_x1 ? 8'h1 :
                    is_x2 ? 8'h2 :
                    is_x4 ? 8'h8 :
                    8'h80;
end

always @(
  dlv_last_mask
  or dbuf_wr_addr_base
  ) begin
    {dlv_end_mask_w, mon_dlv_end_mask_w} = ({dlv_last_mask, dlv_last_mask} << dbuf_wr_addr_base[2:0]);
end

always @(
  dlv_end_mask_w
  or dbuf_wr_addr_0_w
  or dbuf_wr_addr_1_w
  or dbuf_wr_addr_2_w
  or dbuf_wr_addr_3_w
  or dbuf_wr_addr_4_w
  or dbuf_wr_addr_5_w
  or dbuf_wr_addr_6_w
  or dbuf_wr_addr_7_w
  ) begin
    dlv_end_addr_w = ({5 {dlv_end_mask_w[0]}} & dbuf_wr_addr_0_w) |
                     ({5 {dlv_end_mask_w[1]}} & dbuf_wr_addr_1_w) |
                     ({5 {dlv_end_mask_w[2]}} & dbuf_wr_addr_2_w) |
                     ({5 {dlv_end_mask_w[3]}} & dbuf_wr_addr_3_w) |
                     ({5 {dlv_end_mask_w[4]}} & dbuf_wr_addr_4_w) |
                     ({5 {dlv_end_mask_w[5]}} & dbuf_wr_addr_5_w) |
                     ({5 {dlv_end_mask_w[6]}} & dbuf_wr_addr_6_w) |
                     ({5 {dlv_end_mask_w[7]}} & dbuf_wr_addr_7_w);
end

always @(
  dlv_pop
  or dbuf_rd_addr
  or dlv_end_tag0_addr
  or dbuf_rd_en
  or dlv_end_tag0_mask
  or dlv_end_tag0_vld
  ) begin
    dlv_end_clr = dlv_pop & ((dbuf_rd_addr == dlv_end_tag0_addr) & (dbuf_rd_en == dlv_end_tag0_mask)) & dlv_end_tag0_vld;
end

always @(
  dlv_end_tag1_vld
  or dlv_end_set
  or dlv_end_clr
  or dlv_end_tag0_vld
  ) begin
    dlv_end_tag0_vld_w = (dlv_end_tag1_vld | dlv_end_set) ? 1'b1 :
                         dlv_end_clr ? 1'b0 :
                         dlv_end_tag0_vld;
end

always @(
  dlv_end_clr
  or dlv_end_tag0_vld
  or dlv_end_set
  or dlv_end_tag1_vld
  ) begin
    dlv_end_tag1_vld_w = dlv_end_clr ? 1'b0 :
                         (dlv_end_tag0_vld & dlv_end_set) ? 1'b1 :
                         dlv_end_tag1_vld;
end

always @(
  dlv_end_set
  or dlv_end_tag0_vld
  or dlv_end_clr
  or dlv_end_tag1_vld
  ) begin
    dlv_end_tag0_en = (dlv_end_set & ~dlv_end_tag0_vld) | 
                      (dlv_end_set & dlv_end_clr) |
                      (dlv_end_clr & dlv_end_tag1_vld);
end

always @(
  dlv_end_set
  or dlv_end_tag0_vld
  or dlv_end_clr
  ) begin
    dlv_end_tag1_en = (dlv_end_set & dlv_end_tag0_vld & ~dlv_end_clr);
end

always @(
  dlv_end_tag1_vld
  or dlv_end_tag1_addr
  or dlv_end_addr_w
  ) begin
    dlv_end_tag0_addr_w = dlv_end_tag1_vld ? dlv_end_tag1_addr : dlv_end_addr_w;
end

always @(
  dlv_end_addr_w
  ) begin
    dlv_end_tag1_addr_w = dlv_end_addr_w;
end

always @(
  dlv_end_tag1_vld
  or dlv_end_tag1_mask
  or dlv_end_mask_w
  ) begin
    dlv_end_tag0_mask_w = dlv_end_tag1_vld ? dlv_end_tag1_mask : dlv_end_mask_w;
end

always @(
  dlv_end_mask_w
  ) begin
    dlv_end_tag1_mask_w = dlv_end_mask_w;
end

assign dbuf_rd_layer_end = dlv_end_clr;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dlv_end_tag0_vld <= 1'b0;
  end else begin
  dlv_end_tag0_vld <= dlv_end_tag0_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dlv_end_tag1_vld <= 1'b0;
  end else begin
  dlv_end_tag1_vld <= dlv_end_tag1_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dlv_end_tag0_addr <= {5{1'b0}};
  end else begin
  if ((dlv_end_tag0_en) == 1'b1) begin
    dlv_end_tag0_addr <= dlv_end_tag0_addr_w;
  // VCS coverage off
  end else if ((dlv_end_tag0_en) == 1'b0) begin
  end else begin
    dlv_end_tag0_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_46x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dlv_end_tag0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dlv_end_tag1_addr <= {5{1'b0}};
  end else begin
  if ((dlv_end_tag1_en) == 1'b1) begin
    dlv_end_tag1_addr <= dlv_end_tag1_addr_w;
  // VCS coverage off
  end else if ((dlv_end_tag1_en) == 1'b0) begin
  end else begin
    dlv_end_tag1_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_47x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dlv_end_tag1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dlv_end_tag0_mask <= {8{1'b0}};
  end else begin
  if ((dlv_end_tag0_en) == 1'b1) begin
    dlv_end_tag0_mask <= dlv_end_tag0_mask_w;
  // VCS coverage off
  end else if ((dlv_end_tag0_en) == 1'b0) begin
  end else begin
    dlv_end_tag0_mask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_48x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dlv_end_tag0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dlv_end_tag1_mask <= {8{1'b0}};
  end else begin
  if ((dlv_end_tag1_en) == 1'b1) begin
    dlv_end_tag1_mask <= dlv_end_tag1_mask_w;
  // VCS coverage off
  end else if ((dlv_end_tag1_en) == 1'b0) begin
  end else begin
    dlv_end_tag1_mask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_49x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dlv_end_tag1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Get layer end conflict running!")      zzz_assert_never_50x (nvdla_core_clk, `ASSERT_RESET, (dlv_end_tag1_vld & ~dlv_end_tag0_vld)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Get 3th layer end during running!")      zzz_assert_never_51x (nvdla_core_clk, `ASSERT_RESET, (dlv_end_tag1_vld & dlv_end_set)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
///// generate credit signal                             /////
//////////////////////////////////////////////////////////////

assign accu2sc_credit_size = 3'h1;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    accu2sc_credit_vld <= 1'b0;
  end else begin
  accu2sc_credit_vld <= cacc2sdp_valid & cacc2sdp_ready;
  end
end

// //////////////////////////////////////////////////////////////
// ///// OBS connection                                     /////
// //////////////////////////////////////////////////////////////
// &Force output dbuf_wr_en;
// &Force output dbuf_wr_addr_0;
// &Force output dbuf_rd_en;
// 
// assign obs_bus_cacc_dlv_valid      = dlv_valid;
// assign obs_bus_cacc_dlv_layer_end  = dlv_layer_end;
// assign obs_bus_cacc_dlv_mask       = dlv_mask;
// assign obs_bus_cacc_dbuf_wr_en     = dbuf_wr_en;
// assign obs_bus_cacc_dbuf_wr_addr_0 = dbuf_wr_addr_0;
// assign obs_bus_cacc_dbuf_empty     = dbuf_empty;
// assign obs_bus_cacc_dbuf_rd_en     = dbuf_rd_en;

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           dbuf_wr_addr_base[3:2]
//                           dbuf_wr_addr_base[5:4]
//                           dbuf_wr_addr_base[7:6]
//                           dlv_push_size_d2[1:0]
//                           dlv_push_size_d2[3:2]
//                           {skip_cnt[0],dbuf_wr_addr_back[0]};

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

    property cacc_delivery_ctrl__dlv_end_tag0_set_and_clear__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_end_tag1_vld | dlv_end_set) & dlv_end_clr);
    endproperty
    // Cover 0 : "((dlv_end_tag1_vld | dlv_end_set) & dlv_end_clr)"
    FUNCPOINT_cacc_delivery_ctrl__dlv_end_tag0_set_and_clear__0_COV : cover property (cacc_delivery_ctrl__dlv_end_tag0_set_and_clear__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_delivery_ctrl__dlv_end_tag1_set_and_clear__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (dlv_end_clr & (dlv_end_tag0_vld & dlv_end_set));
    endproperty
    // Cover 1 : "(dlv_end_clr & (dlv_end_tag0_vld & dlv_end_set))"
    FUNCPOINT_cacc_delivery_ctrl__dlv_end_tag1_set_and_clear__1_COV : cover property (cacc_delivery_ctrl__dlv_end_tag1_set_and_clear__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_delivery_ctrl__dbuf_write_select_EQ_0__2_0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 0));
    endproperty
    // Cover 2_0 : "(dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 0)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_0__2_0_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_0__2_0_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_1__2_1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 1));
    endproperty
    // Cover 2_1 : "(dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 1)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_1__2_1_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_1__2_1_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_2__2_2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 2));
    endproperty
    // Cover 2_2 : "(dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 2)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_2__2_2_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_2__2_2_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_3__2_3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 3));
    endproperty
    // Cover 2_3 : "(dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 3)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_3__2_3_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_3__2_3_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_4__2_4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 4));
    endproperty
    // Cover 2_4 : "(dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 4)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_4__2_4_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_4__2_4_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_5__2_5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 5));
    endproperty
    // Cover 2_5 : "(dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 5)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_5__2_5_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_5__2_5_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_6__2_6_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 6));
    endproperty
    // Cover 2_6 : "(dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 6)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_6__2_6_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_6__2_6_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_7__2_7_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 7));
    endproperty
    // Cover 2_7 : "(dlv_mask == 8'h1) && (dbuf_wr_addr_base[2:0] == 7)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_7__2_7_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_7__2_7_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_8__2_8_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 0));
    endproperty
    // Cover 2_8 : "(dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 0)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_8__2_8_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_8__2_8_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_9__2_9_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 1));
    endproperty
    // Cover 2_9 : "(dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 1)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_9__2_9_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_9__2_9_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_10__2_10_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 2));
    endproperty
    // Cover 2_10 : "(dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 2)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_10__2_10_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_10__2_10_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_11__2_11_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 3));
    endproperty
    // Cover 2_11 : "(dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 3)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_11__2_11_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_11__2_11_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_12__2_12_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 4));
    endproperty
    // Cover 2_12 : "(dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 4)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_12__2_12_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_12__2_12_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_13__2_13_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 5));
    endproperty
    // Cover 2_13 : "(dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 5)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_13__2_13_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_13__2_13_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_14__2_14_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 6));
    endproperty
    // Cover 2_14 : "(dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 6)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_14__2_14_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_14__2_14_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_15__2_15_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 7));
    endproperty
    // Cover 2_15 : "(dlv_mask == 8'h3) && (dbuf_wr_addr_base[2:0] == 7)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_15__2_15_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_15__2_15_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_16__2_16_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 0));
    endproperty
    // Cover 2_16 : "(dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 0)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_16__2_16_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_16__2_16_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_17__2_17_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 1));
    endproperty
    // Cover 2_17 : "(dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 1)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_17__2_17_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_17__2_17_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_18__2_18_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 2));
    endproperty
    // Cover 2_18 : "(dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 2)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_18__2_18_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_18__2_18_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_19__2_19_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 3));
    endproperty
    // Cover 2_19 : "(dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 3)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_19__2_19_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_19__2_19_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_20__2_20_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 4));
    endproperty
    // Cover 2_20 : "(dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 4)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_20__2_20_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_20__2_20_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_21__2_21_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 5));
    endproperty
    // Cover 2_21 : "(dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 5)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_21__2_21_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_21__2_21_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_22__2_22_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 6));
    endproperty
    // Cover 2_22 : "(dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 6)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_22__2_22_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_22__2_22_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_23__2_23_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 7));
    endproperty
    // Cover 2_23 : "(dlv_mask == 8'hf) && (dbuf_wr_addr_base[2:0] == 7)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_23__2_23_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_23__2_23_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_24__2_24_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 0));
    endproperty
    // Cover 2_24 : "(dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 0)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_24__2_24_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_24__2_24_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_25__2_25_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 1));
    endproperty
    // Cover 2_25 : "(dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 1)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_25__2_25_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_25__2_25_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_26__2_26_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 2));
    endproperty
    // Cover 2_26 : "(dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 2)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_26__2_26_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_26__2_26_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_27__2_27_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 3));
    endproperty
    // Cover 2_27 : "(dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 3)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_27__2_27_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_27__2_27_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_28__2_28_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 4));
    endproperty
    // Cover 2_28 : "(dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 4)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_28__2_28_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_28__2_28_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_29__2_29_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 5));
    endproperty
    // Cover 2_29 : "(dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 5)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_29__2_29_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_29__2_29_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_30__2_30_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 6));
    endproperty
    // Cover 2_30 : "(dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 6)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_30__2_30_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_30__2_30_cov);

    property cacc_delivery_ctrl__dbuf_write_select_EQ_31__2_31_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dlv_valid) && nvdla_core_rstn) |-> ((dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 7));
    endproperty
    // Cover 2_31 : "(dlv_mask == 8'hff) && (dbuf_wr_addr_base[2:0] == 7)"
    FUNCPOINT_cacc_delivery_ctrl__dbuf_write_select_EQ_31__2_31_COV : cover property (cacc_delivery_ctrl__dbuf_write_select_EQ_31__2_31_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_delivery_ctrl__int8_1x1_output__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (reg2dp_op_en & ~(|reg2dp_dataout_width) & ~(|reg2dp_dataout_height) & (reg2dp_proc_precision == 2'h0 ));
    endproperty
    // Cover 3 : "(reg2dp_op_en & ~(|reg2dp_dataout_width) & ~(|reg2dp_dataout_height) & (reg2dp_proc_precision == 2'h0 ))"
    FUNCPOINT_cacc_delivery_ctrl__int8_1x1_output__3_COV : cover property (cacc_delivery_ctrl__int8_1x1_output__3_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_delivery_ctrl__non_int8_1x1_output__4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (reg2dp_op_en & ~(|reg2dp_dataout_width) & ~(|reg2dp_dataout_height) & (reg2dp_proc_precision != 2'h0 ));
    endproperty
    // Cover 4 : "(reg2dp_op_en & ~(|reg2dp_dataout_width) & ~(|reg2dp_dataout_height) & (reg2dp_proc_precision != 2'h0 ))"
    FUNCPOINT_cacc_delivery_ctrl__non_int8_1x1_output__4_COV : cover property (cacc_delivery_ctrl__non_int8_1x1_output__4_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cacc_delivery_ctrl__dbuf0_write_addr_plus__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (dbuf_wr_en_w[0] & (dbuf_wr_addr_base[2:0] > 3'h0));
    endproperty
    // Cover 5 : "(dbuf_wr_en_w[0] & (dbuf_wr_addr_base[2:0] > 3'h0))"
    FUNCPOINT_cacc_delivery_ctrl__dbuf0_write_addr_plus__5_COV : cover property (cacc_delivery_ctrl__dbuf0_write_addr_plus__5_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_CACC_delivery_ctrl


