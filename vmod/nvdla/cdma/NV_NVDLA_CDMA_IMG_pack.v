// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_IMG_pack.v

module NV_NVDLA_CDMA_IMG_pack (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,img2sbuf_p0_rd_data
  ,img2sbuf_p1_rd_data
  ,is_running
  ,layer_st
  ,pixel_bank
  ,pixel_data_expand
  ,pixel_data_shrink
  ,pixel_early_end
  ,pixel_packed_10b
  ,pixel_planar
  ,pixel_planar0_sft
  ,pixel_planar1_sft
  ,pixel_precision
  ,pixel_uint
  ,reg2dp_datain_channel
  ,reg2dp_datain_width
  ,reg2dp_mean_ax
  ,reg2dp_mean_bv
  ,reg2dp_mean_gu
  ,reg2dp_mean_ry
  ,reg2dp_pad_left
  ,reg2dp_pad_right
  ,sg2pack_data_entries
  ,sg2pack_entry_end
  ,sg2pack_entry_mid
  ,sg2pack_entry_st
  ,sg2pack_height_total
  ,sg2pack_img_pd
  ,sg2pack_img_pvld
  ,sg2pack_mn_enable
  ,sg2pack_sub_h_end
  ,sg2pack_sub_h_mid
  ,sg2pack_sub_h_st
  ,status2dma_wr_idx
  ,img2cvt_dat_wr_addr
  ,img2cvt_dat_wr_data
  ,img2cvt_dat_wr_en
  ,img2cvt_dat_wr_hsel
  ,img2cvt_dat_wr_info_pd
  ,img2cvt_dat_wr_pad_mask
  ,img2cvt_mn_wr_data
  ,img2sbuf_p0_rd_addr
  ,img2sbuf_p0_rd_en
  ,img2sbuf_p1_rd_addr
  ,img2sbuf_p1_rd_en
  ,img2status_dat_entries
  ,img2status_dat_slices
  ,img2status_dat_updt
  ,pack_is_done
  ,sg2pack_img_prdy
  );


input           nvdla_core_clk;
input           nvdla_core_rstn;
input   [255:0] img2sbuf_p0_rd_data;
input   [255:0] img2sbuf_p1_rd_data;
input           is_running;
input           layer_st;
input     [3:0] pixel_bank;
input           pixel_data_expand;
input           pixel_data_shrink;
input           pixel_early_end;
input           pixel_packed_10b;
input           pixel_planar;
input     [2:0] pixel_planar0_sft;
input     [2:0] pixel_planar1_sft;
input     [1:0] pixel_precision;
input           pixel_uint;
input    [11:0] sg2pack_data_entries;
input    [11:0] sg2pack_entry_end;
input    [11:0] sg2pack_entry_mid;
input    [11:0] sg2pack_entry_st;
input    [12:0] sg2pack_height_total;
input    [10:0] sg2pack_img_pd;
input           sg2pack_img_pvld;
input           sg2pack_mn_enable;
input     [3:0] sg2pack_sub_h_end;
input     [3:0] sg2pack_sub_h_mid;
input     [3:0] sg2pack_sub_h_st;
input    [11:0] status2dma_wr_idx;
output   [11:0] img2cvt_dat_wr_addr;
output [1023:0] img2cvt_dat_wr_data;
output          img2cvt_dat_wr_en;
output          img2cvt_dat_wr_hsel;
output   [11:0] img2cvt_dat_wr_info_pd;
output [1023:0] img2cvt_mn_wr_data;
output    [7:0] img2sbuf_p0_rd_addr;
output          img2sbuf_p0_rd_en;
output    [7:0] img2sbuf_p1_rd_addr;
output          img2sbuf_p1_rd_en;
output   [11:0] img2status_dat_entries;
output   [11:0] img2status_dat_slices;
output          img2status_dat_updt;
output          pack_is_done;
output          sg2pack_img_prdy;

input [12:0]          reg2dp_datain_width;
input [12:0]        reg2dp_datain_channel;
input [15:0]               reg2dp_mean_ry;
input [15:0]               reg2dp_mean_gu;
input [15:0]               reg2dp_mean_bv;
input [15:0]               reg2dp_mean_ax;
input [4:0]               reg2dp_pad_left;
input [5:0]              reg2dp_pad_right;
//input [NVDLA_CDMA_D_ZERO_PADDING_VALUE_0_PAD_VALUE_SIZE-1:0]        reg2dp_pad_value;

output [127:0] img2cvt_dat_wr_pad_mask;

wire   [1535:0] dat_16b_yuv;
wire   [1535:0] dat_8b_yuv;
wire    [511:0] dat_l0;
wire   [1023:0] dat_l1;
wire    [511:0] dat_l1_hi;
wire    [511:0] dat_l1_lo;
wire   [1535:0] dat_yuv;
wire     [13:0] data_width_mark_0;
wire     [13:0] data_width_mark_1_w;
wire     [13:0] data_width_mark_2_w;
wire            img_layer_end;
wire            img_line_end;
wire      [3:0] img_p0_burst;
wire      [4:0] img_p1_burst;
wire     [10:0] img_pd;
wire            is_last_sub_h;
wire     [63:0] mask_pad;
wire     [63:0] mask_zero;
wire   [1023:0] mn_ch1;
wire   [1023:0] mn_ch1_4;
wire   [3071:0] mn_ch3;
wire   [1023:0] mn_ch4;
wire    [127:0] mn_mask_uv;
wire            mn_mask_uv_0_en;
wire            mn_mask_uv_1_en;
wire     [63:0] mn_mask_uv_hi;
wire     [63:0] mn_mask_uv_lo;
wire     [63:0] mn_mask_y;
wire            mn_mask_y_en;
wire    [191:0] mn_mask_yuv;
wire    [191:0] pad_mask_16b_yuv;
wire    [191:0] pad_mask_8b_yuv;
wire     [63:0] pad_mask_l0;
wire    [127:0] pad_mask_l1;
wire     [63:0] pad_mask_l1_hi;
wire     [63:0] pad_mask_l1_lo;
wire    [191:0] pad_mask_yuv;
wire   [1023:0] pk_mn_out_data;
wire   [1023:0] pk_out_data;
wire     [11:0] pk_out_info_pd;
wire            pk_out_interleave;
wire    [127:0] pk_out_pad_mask;
wire            pk_rsp_1st_height;
wire            pk_rsp_cur_1st_height;
wire            pk_rsp_cur_layer_end;
wire            pk_rsp_cur_loop_end;
wire            pk_rsp_cur_one_line_end;
wire      [2:0] pk_rsp_cur_sub_h;
wire            pk_rsp_cur_sub_h_end;
wire            pk_rsp_cur_vld;
wire   [1023:0] pk_rsp_dat_ergb;
wire    [511:0] pk_rsp_dat_normal;
wire     [11:0] pk_rsp_data_entries;
wire            pk_rsp_data_h0_en;
wire            pk_rsp_data_h1_en;
wire      [3:0] pk_rsp_data_slices;
wire            pk_rsp_early_end;
wire            pk_rsp_layer_end;
wire            pk_rsp_loop_end;
wire            pk_rsp_mn_data_h0_en;
wire            pk_rsp_mn_data_h1_en;
wire            pk_rsp_one_line_end;
wire    [255:0] pk_rsp_p0_data;
wire     [31:0] pk_rsp_p0_pad_mask;
wire     [31:0] pk_rsp_p0_zero_mask;
wire    [255:0] pk_rsp_p1_data;
wire     [31:0] pk_rsp_p1_pad_mask;
wire     [31:0] pk_rsp_p1_zero_mask;
wire    [127:0] pk_rsp_pad_mask_ergb;
wire     [63:0] pk_rsp_pad_mask_norm;
wire            pk_rsp_pipe_sel;
wire            pk_rsp_planar;
wire            pk_rsp_planar0_c0_en;
wire            pk_rsp_planar1_c0_en;
wire            pk_rsp_planar1_c1_en;
wire      [2:0] pk_rsp_sub_h;
wire            pk_rsp_sub_h_end;
wire            pk_rsp_vld;
wire            pk_rsp_vld_d1_w;
wire            pk_rsp_wr_ext128;
wire            pk_rsp_wr_ext64;
wire      [3:0] pk_rsp_wr_mask;
wire      [2:0] pk_rsp_wr_size_ori;
wire      [1:0] pk_rsp_wr_sub_addr;
wire      [2:0] rd_sub_h_cnt;
wire    [511:0] rdat;
wire     [13:0] z14;
wire      [5:0] z6;
reg       [5:0] data_planar0_add;
reg       [5:0] data_planar0_add_w;
reg      [13:0] data_planar0_cur_cnt;
reg      [13:0] data_planar0_cur_cnt_w;
reg             data_planar0_en;
reg      [13:0] data_planar0_ori_cnt;
reg             data_planar0_ori_en;
reg      [13:0] data_planar0_p0_cnt_w;
reg       [2:0] data_planar0_p0_cur_flag;
reg      [31:0] data_planar0_p0_lp_mask;
reg      [31:0] data_planar0_p0_pad_mask;
reg      [31:0] data_planar0_p0_rp_mask;
reg      [31:0] data_planar0_p0_zero_mask;
reg      [13:0] data_planar0_p1_cnt_w;
reg       [2:0] data_planar0_p1_cur_flag;
reg       [2:0] data_planar0_p1_flag;
reg       [2:0] data_planar0_p1_flag_w;
reg      [31:0] data_planar0_p1_lp_mask;
reg       [2:0] data_planar0_p1_ori_flag;
reg      [31:0] data_planar0_p1_pad_mask;
reg      [31:0] data_planar0_p1_rp_mask;
reg      [31:0] data_planar0_p1_zero_mask;
reg       [5:0] data_planar1_add;
reg       [5:0] data_planar1_add_w;
reg      [13:0] data_planar1_cur_cnt;
reg      [13:0] data_planar1_cur_cnt_w;
reg             data_planar1_en;
reg      [13:0] data_planar1_ori_cnt;
reg             data_planar1_ori_en;
reg      [13:0] data_planar1_p0_cnt_w;
reg       [2:0] data_planar1_p0_cur_flag;
reg      [31:0] data_planar1_p0_lp_mask;
reg      [31:0] data_planar1_p0_pad_mask;
reg      [31:0] data_planar1_p0_rp_mask;
reg      [31:0] data_planar1_p0_zero_mask;
reg      [13:0] data_planar1_p1_cnt_w;
reg       [2:0] data_planar1_p1_cur_flag;
reg       [2:0] data_planar1_p1_flag;
reg       [2:0] data_planar1_p1_flag_w;
reg      [31:0] data_planar1_p1_lp_mask;
reg       [2:0] data_planar1_p1_ori_flag;
reg      [31:0] data_planar1_p1_pad_mask;
reg      [31:0] data_planar1_p1_rp_mask;
reg      [31:0] data_planar1_p1_zero_mask;
reg      [13:0] data_width_mark_1;
reg      [13:0] data_width_mark_2;
reg             is_1st_height;
reg             is_addr_wrap;
reg             is_base_wrap;
reg             is_first_running;
reg             is_last_height;
reg             is_last_loop;
reg             is_last_pburst;
reg             is_last_planar;
reg             is_running_d1;
reg       [4:0] lp_planar0_mask_sft;
reg       [4:0] lp_planar0_mask_sft_w;
reg       [4:0] lp_planar1_mask_sft;
reg       [4:0] lp_planar1_mask_sft_w;
reg      [63:0] mask_pad_planar0_c0_d1;
reg      [63:0] mask_pad_planar1_c0_d1;
reg      [63:0] mask_pad_planar1_c1_d1;
reg     [511:0] mn_16b_mnorm;
reg    [1535:0] mn_16b_myuv;
reg    [1023:0] mn_8b_mnorm;
reg    [3071:0] mn_8b_myuv;
reg      [63:0] mn_mask_uv_hi_d1;
reg      [63:0] mn_mask_uv_lo_d1;
reg      [63:0] mn_mask_y_d1;
reg             mon_data_planar0_p0_cnt_w;
reg             mon_data_planar0_p1_cnt_w;
reg             mon_data_planar1_p0_cnt_w;
reg             mon_data_planar1_p1_cnt_w;
reg       [4:0] mon_lp_planar0_mask_sft_w;
reg       [4:0] mon_lp_planar1_mask_sft_w;
reg       [1:0] mon_pk_rsp_wr_addr_wrap;
reg       [1:0] mon_pk_rsp_wr_base_wrap;
reg             mon_pk_rsp_wr_cnt_w;
reg             mon_pk_rsp_wr_h_offset_w;
reg             mon_pk_rsp_wr_w_offset_w;
reg             mon_rd_loop_cnt_inc;
reg             mon_rd_loop_cnt_limit;
reg       [4:0] mon_rp_planar0_mask_sft_w;
reg       [4:0] mon_rp_planar1_mask_sft_w;
reg       [4:0] mon_zero_planar0_mask_sft_w;
reg       [4:0] mon_zero_planar1_mask_sft_w;
reg             pack_is_done;
reg             pack_is_done_w;
reg       [4:0] pad_left_d1;
reg     [511:0] pk_mn_out_data_h0;
reg     [511:0] pk_mn_out_data_h1;
reg      [11:0] pk_out_addr;
reg      [11:0] pk_out_data_entries;
reg     [511:0] pk_out_data_h0;
reg     [511:0] pk_out_data_h1;
reg       [3:0] pk_out_data_slices;
reg             pk_out_data_updt;
reg             pk_out_ext128;
reg             pk_out_ext64;
reg             pk_out_hsel;
reg       [3:0] pk_out_mask;
reg             pk_out_mean;
reg      [63:0] pk_out_pad_mask_h0;
reg      [63:0] pk_out_pad_mask_h1;
reg       [2:0] pk_out_sub_h;
reg             pk_out_uint;
reg             pk_out_vld;
reg             pk_rsp_1st_height_d1;
reg    [1023:0] pk_rsp_dat_mergb;
reg     [511:0] pk_rsp_dat_mnorm;
reg     [511:0] pk_rsp_data_h0;
reg     [511:0] pk_rsp_data_h1;
reg             pk_rsp_data_updt;
reg             pk_rsp_layer_end_d1;
reg             pk_rsp_loop_end_d1;
reg     [511:0] pk_rsp_mn_data_h0;
reg     [511:0] pk_rsp_mn_data_h1;
reg       [7:0] pk_rsp_mn_sel;
reg             pk_rsp_one_line_end_d1;
reg       [4:0] pk_rsp_out_sel;
reg      [63:0] pk_rsp_pad_mask_h0;
reg      [63:0] pk_rsp_pad_mask_h1;
reg     [511:0] pk_rsp_planar0_c0_d1;
reg     [511:0] pk_rsp_planar1_c0_d1;
reg     [511:0] pk_rsp_planar1_c1_d1;
reg       [2:0] pk_rsp_sub_h_d1;
reg             pk_rsp_sub_h_end_d1;
reg             pk_rsp_vld_d1;
reg      [11:0] pk_rsp_wr_addr;
reg      [13:0] pk_rsp_wr_addr_inc;
reg       [3:0] pk_rsp_wr_addr_wrap;
reg      [11:0] pk_rsp_wr_base;
reg             pk_rsp_wr_base_en;
reg      [12:0] pk_rsp_wr_base_inc;
reg      [11:0] pk_rsp_wr_base_w;
reg       [3:0] pk_rsp_wr_base_wrap;
reg       [1:0] pk_rsp_wr_cnt;
reg       [1:0] pk_rsp_wr_cnt_w;
reg      [11:0] pk_rsp_wr_entries;
reg      [11:0] pk_rsp_wr_h_offset;
reg             pk_rsp_wr_h_offset_en;
reg      [11:0] pk_rsp_wr_h_offset_w;
reg       [3:0] pk_rsp_wr_slices;
reg             pk_rsp_wr_vld;
reg       [2:0] pk_rsp_wr_w_add;
reg      [13:0] pk_rsp_wr_w_offset;
reg             pk_rsp_wr_w_offset_en;
reg      [13:0] pk_rsp_wr_w_offset_ori;
reg             pk_rsp_wr_w_offset_ori_en;
reg      [13:0] pk_rsp_wr_w_offset_w;
reg             rd_1st_height_d1;
reg             rd_1st_height_d2;
reg             rd_1st_height_d3;
reg      [12:0] rd_height_cnt;
reg      [13:0] rd_height_cnt_inc;
reg      [12:0] rd_height_cnt_w;
reg             rd_height_en;
reg             rd_height_end;
reg       [1:0] rd_idx_add;
reg             rd_layer_end_d1;
reg             rd_layer_end_d2;
reg             rd_layer_end_d3;
reg             rd_line_end;
reg             rd_local_vld;
reg             rd_local_vld_w;
reg       [2:0] rd_loop_cnt;
reg       [2:0] rd_loop_cnt_inc;
reg       [2:0] rd_loop_cnt_limit;
reg       [2:0] rd_loop_cnt_w;
reg             rd_loop_en;
reg             rd_loop_end;
reg             rd_loop_end_d1;
reg             rd_loop_end_d2;
reg             rd_loop_end_d3;
reg             rd_one_line_end_d1;
reg             rd_one_line_end_d2;
reg             rd_one_line_end_d3;
reg       [7:0] rd_p0_addr;
reg       [7:0] rd_p0_addr_d1;
reg      [31:0] rd_p0_pad_mask;
reg      [31:0] rd_p0_pad_mask_d1;
reg      [31:0] rd_p0_pad_mask_d2;
reg      [31:0] rd_p0_pad_mask_d3;
reg       [6:0] rd_p0_planar0_idx;
reg       [7:0] rd_p0_planar0_idx_inc;
reg       [6:0] rd_p0_planar0_idx_w;
reg       [6:0] rd_p0_planar0_ori_idx;
reg       [6:0] rd_p0_planar1_idx;
reg       [7:0] rd_p0_planar1_idx_inc;
reg       [6:0] rd_p0_planar1_idx_w;
reg       [6:0] rd_p0_planar1_ori_idx;
reg             rd_p0_vld;
reg             rd_p0_vld_d1;
reg      [31:0] rd_p0_zero_mask;
reg      [31:0] rd_p0_zero_mask_d1;
reg      [31:0] rd_p0_zero_mask_d2;
reg      [31:0] rd_p0_zero_mask_d3;
reg       [7:0] rd_p1_addr;
reg       [7:0] rd_p1_addr_d1;
reg      [31:0] rd_p1_pad_mask;
reg      [31:0] rd_p1_pad_mask_d1;
reg      [31:0] rd_p1_pad_mask_d2;
reg      [31:0] rd_p1_pad_mask_d3;
reg       [6:0] rd_p1_planar0_idx;
reg       [7:0] rd_p1_planar0_idx_inc;
reg       [6:0] rd_p1_planar0_idx_w;
reg       [6:0] rd_p1_planar0_ori_idx;
reg       [6:0] rd_p1_planar1_idx;
reg       [7:0] rd_p1_planar1_idx_inc;
reg       [6:0] rd_p1_planar1_idx_w;
reg       [6:0] rd_p1_planar1_ori_idx;
reg             rd_p1_vld;
reg             rd_p1_vld_d1;
reg      [31:0] rd_p1_zero_mask;
reg      [31:0] rd_p1_zero_mask_d1;
reg      [31:0] rd_p1_zero_mask_d2;
reg      [31:0] rd_p1_zero_mask_d3;
reg             rd_pburst_cnt;
reg             rd_pburst_cnt_w;
reg             rd_pburst_en;
reg             rd_pburst_end;
reg             rd_pburst_limit;
reg             rd_planar0_burst_end;
reg             rd_planar0_en;
reg             rd_planar0_line_end;
reg             rd_planar0_ori_en;
reg       [1:0] rd_planar0_rd_mask;
reg             rd_planar1_burst_end;
reg             rd_planar1_en;
reg             rd_planar1_line_end;
reg             rd_planar1_ori_en;
reg       [1:0] rd_planar1_rd_mask;
reg             rd_planar_cnt;
reg             rd_planar_cnt_w;
reg             rd_planar_d1;
reg             rd_planar_d2;
reg             rd_planar_d3;
reg             rd_planar_en;
reg             rd_planar_end;
reg       [1:0] rd_rd_mask;
reg       [2:0] rd_sub_h_d1;
reg       [2:0] rd_sub_h_d2;
reg       [2:0] rd_sub_h_d3;
reg             rd_sub_h_end;
reg             rd_sub_h_end_d1;
reg             rd_sub_h_end_d2;
reg             rd_sub_h_end_d3;
reg             rd_vld;
reg             rd_vld_d1;
reg             rd_vld_d2;
reg             rd_vld_d3;
reg       [4:0] rp_planar0_mask_sft;
reg       [4:0] rp_planar0_mask_sft_w;
reg       [4:0] rp_planar1_mask_sft;
reg       [4:0] rp_planar1_mask_sft_w;
reg       [4:0] zero_planar0_mask_sft;
reg       [4:0] zero_planar0_mask_sft_w;
reg       [4:0] zero_planar1_mask_sft;
reg       [4:0] zero_planar1_mask_sft_w;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
////////////////////////////////////////////////////////////////////////
// signals from other modules                                         //
////////////////////////////////////////////////////////////////////////


assign img_pd = sg2pack_img_pvld ? sg2pack_img_pd : 11'b0;


// PKT_UNPACK_WIRE( sg2pack_info ,  img_ ,  img_pd )
assign        img_p0_burst[3:0] =     img_pd[3:0];
assign        img_p1_burst[4:0] =     img_pd[8:4];
assign         img_line_end  =     img_pd[9];
assign         img_layer_end  =     img_pd[10];

always @(
  is_running_d1
  or is_running
  ) begin
    is_first_running = ~is_running_d1 & is_running;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_running_d1 <= 1'b0;
  end else begin
  is_running_d1 <= is_running;
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
  nv_assert_never #(0,0,"Error! p0_burst and p1_burst mismatch!")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, (sg2pack_img_pvld & pixel_planar & (img_p0_burst * 2 != img_p1_burst) & (img_p0_burst * 2 != img_p1_burst + 1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// general signals                                                    //
////////////////////////////////////////////////////////////////////////

assign data_width_mark_1_w = reg2dp_pad_left + reg2dp_datain_width + 1'b1;
assign data_width_mark_2_w = reg2dp_pad_left + reg2dp_datain_width + 1'b1 + reg2dp_pad_right;

always @(
  data_width_mark_0
  or pixel_planar0_sft
  or pixel_planar1_sft
  ) begin
    {mon_lp_planar0_mask_sft_w, lp_planar0_mask_sft_w} = ({data_width_mark_0[4:0], 5'b0} >> pixel_planar0_sft);
    {mon_lp_planar1_mask_sft_w, lp_planar1_mask_sft_w} = ({data_width_mark_0[4:0], 5'b0} >> pixel_planar1_sft);
end

always @(
  data_width_mark_1
  or pixel_planar0_sft
  or pixel_planar1_sft
  ) begin
    {mon_rp_planar0_mask_sft_w, rp_planar0_mask_sft_w} = ({data_width_mark_1[4:0], 5'b0} >> pixel_planar0_sft);
    {mon_rp_planar1_mask_sft_w, rp_planar1_mask_sft_w} = ({data_width_mark_1[4:0], 5'b0} >> pixel_planar1_sft);
end

always @(
  data_width_mark_2
  or pixel_planar0_sft
  or pixel_planar1_sft
  ) begin
    {mon_zero_planar0_mask_sft_w, zero_planar0_mask_sft_w} = ({data_width_mark_2[4:0], 5'b0} >> pixel_planar0_sft);
    {mon_zero_planar1_mask_sft_w, zero_planar1_mask_sft_w} = ({data_width_mark_2[4:0], 5'b0} >> pixel_planar1_sft);
end

always @(
  pixel_planar0_sft
  or pixel_planar1_sft
  ) begin
    data_planar0_add_w = (1'b1 << pixel_planar0_sft);
    data_planar1_add_w = (1'b1 << pixel_planar1_sft);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pad_left_d1 <= {5{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pad_left_d1 <= reg2dp_pad_left;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pad_left_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    data_width_mark_1 <= {14{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_width_mark_1 <= data_width_mark_1_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_width_mark_1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    data_width_mark_2 <= {14{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_width_mark_2 <= data_width_mark_2_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_width_mark_2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lp_planar0_mask_sft <= {5{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    lp_planar0_mask_sft <= lp_planar0_mask_sft_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    lp_planar0_mask_sft <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lp_planar1_mask_sft <= {5{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    lp_planar1_mask_sft <= lp_planar1_mask_sft_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    lp_planar1_mask_sft <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rp_planar0_mask_sft <= {5{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    rp_planar0_mask_sft <= rp_planar0_mask_sft_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    rp_planar0_mask_sft <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rp_planar1_mask_sft <= {5{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    rp_planar1_mask_sft <= rp_planar1_mask_sft_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    rp_planar1_mask_sft <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    zero_planar0_mask_sft <= {5{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    zero_planar0_mask_sft <= zero_planar0_mask_sft_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    zero_planar0_mask_sft <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    zero_planar1_mask_sft <= {5{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    zero_planar1_mask_sft <= zero_planar1_mask_sft_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    zero_planar1_mask_sft <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    data_planar0_add <= {6{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    data_planar0_add <= data_planar0_add_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    data_planar0_add <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    data_planar1_add <= {6{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    data_planar1_add <= data_planar1_add_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    data_planar1_add <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign data_width_mark_0 = {{9{1'b0}}, pad_left_d1};

////////////////////////////////////////////////////////////////////////
// Shared buffer read sequnce generator                               //
////////////////////////////////////////////////////////////////////////

always @(
  rd_height_cnt
  ) begin
    rd_height_cnt_inc = rd_height_cnt + 1'b1;
end

always @(
  rd_height_cnt
  ) begin
    is_1st_height = ~(|rd_height_cnt);
end

always @(
  rd_height_cnt
  or sg2pack_height_total
  ) begin
    is_last_height = (rd_height_cnt == sg2pack_height_total);
end

always @(
  is_first_running
  or rd_height_cnt_inc
  ) begin
    rd_height_cnt_w = (is_first_running) ? 13'b0 :
                      rd_height_cnt_inc[12:0];
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_height_cnt <= {13{1'b0}};
  end else begin
  if ((rd_height_en) == 1'b1) begin
    rd_height_cnt <= rd_height_cnt_w;
  // VCS coverage off
  end else if ((rd_height_en) == 1'b0) begin
  end else begin
    rd_height_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_height_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! layer_end signal conflict with local cnt!")      zzz_assert_never_14x (nvdla_core_clk, `ASSERT_RESET, (rd_line_end & (is_last_height ^ img_layer_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////// sub height counter ////////
assign is_last_sub_h = 1'b1;
assign rd_sub_h_cnt = 3'b0;

//////// loop cnt ////////

always @(
  img_p0_burst
  ) begin
    {mon_rd_loop_cnt_limit,
     rd_loop_cnt_limit} = img_p0_burst[3:1] + img_p0_burst[0];
end

always @(
  rd_loop_cnt
  ) begin
    {mon_rd_loop_cnt_inc,
     rd_loop_cnt_inc} = rd_loop_cnt + 1'b1;
end

always @(
  rd_loop_cnt_inc
  or rd_loop_cnt_limit
  ) begin
    is_last_loop = (rd_loop_cnt_inc >= rd_loop_cnt_limit);
end

always @(
  is_first_running
  or is_last_loop
  or rd_loop_cnt_inc
  ) begin
    rd_loop_cnt_w = (is_first_running | is_last_loop) ? 3'b0 :
                    rd_loop_cnt_inc;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_loop_cnt <= {3{1'b0}};
  end else begin
  if ((rd_loop_en) == 1'b1) begin
    rd_loop_cnt <= rd_loop_cnt_w;
  // VCS coverage off
  end else if ((rd_loop_en) == 1'b0) begin
  end else begin
    rd_loop_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_loop_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! rd_sub_h_limit is overflow!")      zzz_assert_never_16x (nvdla_core_clk, `ASSERT_RESET, (mon_rd_sub_h_limit & is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! rd_loop_cnt_limit is overflow!")      zzz_assert_never_17x (nvdla_core_clk, `ASSERT_RESET, (mon_rd_loop_cnt_limit & is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////// planar cnt ////////
always @(
  is_first_running
  or is_last_planar
  or rd_planar_cnt
  ) begin
    rd_planar_cnt_w = (is_first_running | is_last_planar) ? 1'b0 :
                      ~rd_planar_cnt;
end

always @(
  pixel_planar
  or rd_planar_cnt
  ) begin
    is_last_planar = ~pixel_planar | rd_planar_cnt;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_planar_cnt <= 1'b0;
  end else begin
  if ((rd_planar_en) == 1'b1) begin
    rd_planar_cnt <= rd_planar_cnt_w;
  // VCS coverage off
  end else if ((rd_planar_en) == 1'b0) begin
  end else begin
    rd_planar_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////// partial burst cnt ////////

always @(
  is_first_running
  or is_last_pburst
  or rd_pburst_cnt
  ) begin
    rd_pburst_cnt_w = (is_first_running | is_last_pburst) ? 1'b0 :
                      ~rd_pburst_cnt;
end

always @(
  rd_planar_cnt
  or is_last_loop
  or img_p0_burst
  ) begin
    rd_pburst_limit = (rd_planar_cnt & (~is_last_loop | ~img_p0_burst[0])) ? 1'b1 : 1'b0;
end

always @(
  rd_pburst_cnt
  or rd_pburst_limit
  ) begin
    is_last_pburst = (rd_pburst_cnt == rd_pburst_limit);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_pburst_cnt <= 1'b0;
  end else begin
  if ((rd_pburst_en) == 1'b1) begin
    rd_pburst_cnt <= rd_pburst_cnt_w;
  // VCS coverage off
  end else if ((rd_pburst_en) == 1'b0) begin
  end else begin
    rd_pburst_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_pburst_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////// control logic ////////
assign sg2pack_img_prdy = rd_vld & rd_sub_h_end;

always @(
  sg2pack_img_pvld
  or rd_local_vld
  ) begin
    rd_vld = (sg2pack_img_pvld | rd_local_vld);
end

always @(
  is_running
  or rd_sub_h_end
  or sg2pack_img_pvld
  or rd_local_vld
  ) begin
    rd_local_vld_w = (~is_running) ? 1'b0 :
                     (rd_sub_h_end) ? 1'b0 :
                     (sg2pack_img_pvld) ? 1'b1 :
                     rd_local_vld;
end

always @(
  rd_vld
  or is_last_pburst
  ) begin
    rd_pburst_end = rd_vld & is_last_pburst;
end

always @(
  rd_vld
  or is_last_pburst
  or is_last_planar
  ) begin
    rd_planar_end = rd_vld & is_last_pburst & is_last_planar;
end

always @(
  rd_vld
  or is_last_pburst
  or is_last_planar
  or is_last_loop
  ) begin
    rd_loop_end = rd_vld & is_last_pburst & is_last_planar & is_last_loop;
end

always @(
  rd_vld
  or is_last_pburst
  or is_last_planar
  or is_last_loop
  or is_last_sub_h
  ) begin
    rd_sub_h_end = rd_vld & is_last_pburst & is_last_planar & is_last_loop & is_last_sub_h;
end

always @(
  rd_vld
  or is_last_pburst
  or is_last_planar
  or is_last_loop
  or is_last_sub_h
  or img_line_end
  ) begin
    rd_line_end = rd_vld & is_last_pburst & is_last_planar & is_last_loop & is_last_sub_h & img_line_end;
end

always @(
  rd_vld
  or is_last_pburst
  or is_last_planar
  or is_last_loop
  or is_last_sub_h
  or img_line_end
  or is_last_height
  ) begin
    rd_height_end = rd_vld & is_last_pburst & is_last_planar & is_last_loop & is_last_sub_h & img_line_end & is_last_height;
end

always @(
  is_first_running
  or rd_vld
  ) begin
    rd_pburst_en = is_first_running | rd_vld;
end

always @(
  is_first_running
  or rd_pburst_end
  or pixel_planar
  ) begin
    rd_planar_en = is_first_running | (rd_pburst_end & pixel_planar);
end

always @(
  is_first_running
  or rd_planar_end
  ) begin
    rd_loop_en = is_first_running | rd_planar_end;
end


always @(
  is_first_running
  or rd_line_end
  ) begin
    rd_height_en = is_first_running | rd_line_end;
end

always @(
  rd_vld
  or is_last_pburst
  or rd_planar_cnt
  or is_last_loop
  ) begin
    rd_planar0_burst_end = rd_vld & is_last_pburst & ~rd_planar_cnt & is_last_loop;
    rd_planar1_burst_end = rd_vld & is_last_pburst & rd_planar_cnt & is_last_loop;
end

always @(
  rd_vld
  or is_last_pburst
  or rd_planar_cnt
  or is_last_loop
  or is_last_sub_h
  or img_line_end
  ) begin
    rd_planar0_line_end = rd_vld & is_last_pburst & ~rd_planar_cnt & is_last_loop & is_last_sub_h & img_line_end;
    rd_planar1_line_end = rd_vld & is_last_pburst & rd_planar_cnt & is_last_loop & is_last_sub_h & img_line_end;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_local_vld <= 1'b0;
  end else begin
  rd_local_vld <= rd_local_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_vld_d1 <= 1'b0;
  end else begin
  rd_vld_d1 <= rd_vld;
  end
end

////////////////////////////////////////////////////////////////////////
// read control logic generator                                       //
////////////////////////////////////////////////////////////////////////
//////// read enalbe mask ////////
always @(
  is_last_loop
  or is_last_pburst
  or img_p0_burst
  or img_p1_burst
  ) begin
    rd_planar0_rd_mask = (is_last_loop & is_last_pburst & img_p0_burst[0]) ? 2'h1 : 2'h3;
    rd_planar1_rd_mask = (is_last_loop & is_last_pburst & img_p1_burst[0]) ? 2'h1 : 2'h3;  
end

always @(
  rd_planar_cnt
  or rd_planar1_rd_mask
  or rd_planar0_rd_mask
  ) begin
    rd_rd_mask = rd_planar_cnt ? rd_planar1_rd_mask : rd_planar0_rd_mask;
end

always @(
  rd_vld
  or rd_rd_mask
  ) begin
    rd_p0_vld = rd_vld & rd_rd_mask[0];
    rd_p1_vld = rd_vld & rd_rd_mask[1];
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_p0_vld_d1 <= 1'b0;
  end else begin
  rd_p0_vld_d1 <= rd_p0_vld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_p1_vld_d1 <= 1'b0;
  end else begin
  rd_p1_vld_d1 <= rd_p1_vld;
  end
end

//////// read address ////////

always @(
  rd_rd_mask
  ) begin
    rd_idx_add = rd_rd_mask[1] ? 2'h2 : 2'h1;
end

always @(
  rd_p0_planar0_idx
  or rd_idx_add
  or rd_p1_planar0_idx
  or rd_p0_planar1_idx
  or rd_p1_planar1_idx
  ) begin
    rd_p0_planar0_idx_inc = rd_p0_planar0_idx + rd_idx_add;
    rd_p1_planar0_idx_inc = rd_p1_planar0_idx + rd_idx_add;
    rd_p0_planar1_idx_inc = rd_p0_planar1_idx + rd_idx_add;
    rd_p1_planar1_idx_inc = rd_p1_planar1_idx + rd_idx_add;
end

always @(
  is_first_running
  or is_last_loop
  or is_last_pburst
  or is_last_sub_h
  or rd_p0_planar0_ori_idx
  or rd_p0_planar0_idx_inc
  or rd_p1_planar0_ori_idx
  or rd_p1_planar0_idx_inc
  ) begin
    rd_p0_planar0_idx_w = is_first_running ? 7'b0 :
                          (is_last_loop & is_last_pburst & ~is_last_sub_h) ? rd_p0_planar0_ori_idx :
                          rd_p0_planar0_idx_inc[8 -2:0];
    rd_p1_planar0_idx_w = is_first_running ? 7'b1 :
                          (is_last_loop & is_last_pburst & ~is_last_sub_h) ? rd_p1_planar0_ori_idx :
                          rd_p1_planar0_idx_inc[8 -2:0];
end

always @(
  is_first_running
  or is_last_loop
  or is_last_pburst
  or is_last_sub_h
  or rd_p0_planar1_ori_idx
  or rd_p0_planar1_idx_inc
  or rd_p1_planar1_ori_idx
  or rd_p1_planar1_idx_inc
  ) begin
    rd_p0_planar1_idx_w = is_first_running ? 7'b0 :
                          (is_last_loop & is_last_pburst & ~is_last_sub_h) ? rd_p0_planar1_ori_idx :
                          rd_p0_planar1_idx_inc[8 -2:0];
    rd_p1_planar1_idx_w = is_first_running ? 7'b1 :
                          (is_last_loop & is_last_pburst & ~is_last_sub_h) ? rd_p1_planar1_ori_idx :
                          rd_p1_planar1_idx_inc[8 -2:0];
end

always @(
  is_first_running
  or rd_vld
  or rd_planar_cnt
  ) begin
    rd_planar0_en = is_first_running | (rd_vld & ~rd_planar_cnt);
    rd_planar1_en = is_first_running | (rd_vld & rd_planar_cnt);
end

always @(
  is_first_running
  ) begin
    rd_planar0_ori_en = is_first_running;
    rd_planar1_ori_en = is_first_running;
end

always @(
  rd_planar_cnt
  or rd_p0_planar0_idx
  or rd_p0_planar1_idx
  ) begin
    rd_p0_addr = (~rd_planar_cnt) ? {1'b0, rd_p0_planar0_idx[0], rd_p0_planar0_idx[8 -2:1]} :
                 {1'b1, rd_p0_planar1_idx[0], rd_p0_planar1_idx[8 -2:1]};
end

always @(
  rd_planar_cnt
  or rd_p1_planar0_idx
  or rd_p1_planar1_idx
  ) begin
    rd_p1_addr = (~rd_planar_cnt) ? {1'b0, rd_p1_planar0_idx[0], rd_p1_planar0_idx[8 -2:1]} :
                 {1'b1, rd_p1_planar1_idx[0], rd_p1_planar1_idx[8 -2:1]};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_p0_planar0_idx <= {7{1'b0}};
  end else begin
  if ((rd_planar0_en) == 1'b1) begin
    rd_p0_planar0_idx <= rd_p0_planar0_idx_w;
  // VCS coverage off
  end else if ((rd_planar0_en) == 1'b0) begin
  end else begin
    rd_p0_planar0_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_p0_planar1_idx <= {7{1'b0}};
  end else begin
  if ((rd_planar1_en) == 1'b1) begin
    rd_p0_planar1_idx <= rd_p0_planar1_idx_w;
  // VCS coverage off
  end else if ((rd_planar1_en) == 1'b0) begin
  end else begin
    rd_p0_planar1_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_p1_planar0_idx <= {7{1'b0}};
  end else begin
  if ((rd_planar0_en) == 1'b1) begin
    rd_p1_planar0_idx <= rd_p1_planar0_idx_w;
  // VCS coverage off
  end else if ((rd_planar0_en) == 1'b0) begin
  end else begin
    rd_p1_planar0_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_p1_planar1_idx <= {7{1'b0}};
  end else begin
  if ((rd_planar1_en) == 1'b1) begin
    rd_p1_planar1_idx <= rd_p1_planar1_idx_w;
  // VCS coverage off
  end else if ((rd_planar1_en) == 1'b0) begin
  end else begin
    rd_p1_planar1_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_p0_planar0_ori_idx <= {7{1'b0}};
  end else begin
  if ((rd_planar0_ori_en) == 1'b1) begin
    rd_p0_planar0_ori_idx <= rd_p0_planar0_idx_w;
  // VCS coverage off
  end else if ((rd_planar0_ori_en) == 1'b0) begin
  end else begin
    rd_p0_planar0_ori_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar0_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_p0_planar1_ori_idx <= {7{1'b0}};
  end else begin
  if ((rd_planar1_ori_en) == 1'b1) begin
    rd_p0_planar1_ori_idx <= rd_p0_planar1_idx_w;
  // VCS coverage off
  end else if ((rd_planar1_ori_en) == 1'b0) begin
  end else begin
    rd_p0_planar1_ori_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar1_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_p1_planar0_ori_idx <= {7{1'b0}};
  end else begin
  if ((rd_planar0_ori_en) == 1'b1) begin
    rd_p1_planar0_ori_idx <= rd_p1_planar0_idx_w;
  // VCS coverage off
  end else if ((rd_planar0_ori_en) == 1'b0) begin
  end else begin
    rd_p1_planar0_ori_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar0_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_p1_planar1_ori_idx <= {7{1'b0}};
  end else begin
  if ((rd_planar1_ori_en) == 1'b1) begin
    rd_p1_planar1_ori_idx <= rd_p1_planar1_idx_w;
  // VCS coverage off
  end else if ((rd_planar1_ori_en) == 1'b0) begin
  end else begin
    rd_p1_planar1_ori_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar1_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_p0_addr_d1 <= {8{1'b0}};
  end else begin
  if ((rd_p0_vld) == 1'b1) begin
    rd_p0_addr_d1 <= rd_p0_addr;
  // VCS coverage off
  end else if ((rd_p0_vld) == 1'b0) begin
  end else begin
    rd_p0_addr_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_p0_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_p1_addr_d1 <= {8{1'b0}};
  end else begin
  if ((rd_p1_vld) == 1'b1) begin
    rd_p1_addr_d1 <= rd_p1_addr;
  // VCS coverage off
  end else if ((rd_p1_vld) == 1'b0) begin
  end else begin
    rd_p1_addr_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_p1_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////// status logic /////////

always @(
  data_planar0_cur_cnt
  or data_planar0_add
  ) begin
    {mon_data_planar0_p0_cnt_w,
     data_planar0_p0_cnt_w} = data_planar0_cur_cnt + data_planar0_add;
    {mon_data_planar0_p1_cnt_w,
     data_planar0_p1_cnt_w} = data_planar0_cur_cnt + {data_planar0_add, 1'b0};
end

always @(
  data_planar1_cur_cnt
  or data_planar1_add
  ) begin
    {mon_data_planar1_p0_cnt_w,
     data_planar1_p0_cnt_w} = data_planar1_cur_cnt + data_planar1_add;
    {mon_data_planar1_p1_cnt_w,
     data_planar1_p1_cnt_w} = data_planar1_cur_cnt + {data_planar1_add, 1'b0};
end

always @(
  data_planar0_p0_cnt_w
  or data_width_mark_0
  or data_width_mark_1
  or data_width_mark_2
  ) begin
    data_planar0_p0_cur_flag[0] = (data_planar0_p0_cnt_w > data_width_mark_0);
    data_planar0_p0_cur_flag[1] = (data_planar0_p0_cnt_w > data_width_mark_1);
    data_planar0_p0_cur_flag[2] = (data_planar0_p0_cnt_w > data_width_mark_2);
end

always @(
  data_planar0_p1_cnt_w
  or data_width_mark_0
  or data_width_mark_1
  or data_width_mark_2
  ) begin
    data_planar0_p1_cur_flag[0] = (data_planar0_p1_cnt_w > data_width_mark_0);
    data_planar0_p1_cur_flag[1] = (data_planar0_p1_cnt_w > data_width_mark_1);
    data_planar0_p1_cur_flag[2] = (data_planar0_p1_cnt_w > data_width_mark_2);
end

always @(
  data_planar1_p0_cnt_w
  or data_width_mark_0
  or data_width_mark_1
  or data_width_mark_2
  ) begin
    data_planar1_p0_cur_flag[0] = (data_planar1_p0_cnt_w > data_width_mark_0);
    data_planar1_p0_cur_flag[1] = (data_planar1_p0_cnt_w > data_width_mark_1);
    data_planar1_p0_cur_flag[2] = (data_planar1_p0_cnt_w > data_width_mark_2);
end

always @(
  data_planar1_p1_cnt_w
  or data_width_mark_0
  or data_width_mark_1
  or data_width_mark_2
  ) begin
    data_planar1_p1_cur_flag[0] = (data_planar1_p1_cnt_w > data_width_mark_0);
    data_planar1_p1_cur_flag[1] = (data_planar1_p1_cnt_w > data_width_mark_1);
    data_planar1_p1_cur_flag[2] = (data_planar1_p1_cnt_w > data_width_mark_2);
end

always @(
  is_first_running
  or rd_planar0_line_end
  or rd_planar0_burst_end
  or is_last_sub_h
  or data_planar0_p1_ori_flag
  or data_planar0_p1_cur_flag
  ) begin
    data_planar0_p1_flag_w = (is_first_running | rd_planar0_line_end) ? 3'b0 :
                             (rd_planar0_burst_end & ~is_last_sub_h) ? data_planar0_p1_ori_flag :
                             data_planar0_p1_cur_flag; 
end

always @(
  is_first_running
  or rd_planar1_line_end
  or rd_planar1_burst_end
  or is_last_sub_h
  or data_planar1_p1_ori_flag
  or data_planar1_p1_cur_flag
  ) begin
    data_planar1_p1_flag_w = (is_first_running | rd_planar1_line_end) ? 3'b0 :
                             (rd_planar1_burst_end & ~is_last_sub_h) ? data_planar1_p1_ori_flag :
                             data_planar1_p1_cur_flag; 
end

always @(
  is_first_running
  or rd_planar0_line_end
  or rd_planar0_burst_end
  or is_last_sub_h
  or data_planar0_ori_cnt
  or rd_p1_vld
  or data_planar0_p1_cnt_w
  or data_planar0_p0_cnt_w
  ) begin
    data_planar0_cur_cnt_w = (is_first_running | rd_planar0_line_end) ? 14'b0 :
                             (rd_planar0_burst_end & ~is_last_sub_h) ? data_planar0_ori_cnt :
                             (rd_p1_vld) ? data_planar0_p1_cnt_w :
                             data_planar0_p0_cnt_w;
end

always @(
  is_first_running
  or rd_planar1_line_end
  or rd_planar1_burst_end
  or is_last_sub_h
  or data_planar1_ori_cnt
  or rd_p1_vld
  or data_planar1_p1_cnt_w
  or data_planar1_p0_cnt_w
  ) begin
    data_planar1_cur_cnt_w = (is_first_running | rd_planar1_line_end) ? 14'b0 :
                             (rd_planar1_burst_end & ~is_last_sub_h) ? data_planar1_ori_cnt :
                             (rd_p1_vld) ? data_planar1_p1_cnt_w :
                             data_planar1_p0_cnt_w;
end

always @(
  data_planar0_p0_cur_flag
  or data_planar0_p1_flag
  or lp_planar0_mask_sft
  or rp_planar0_mask_sft
  or zero_planar0_mask_sft
  ) begin
    data_planar0_p0_lp_mask = ~data_planar0_p0_cur_flag[0] ? 32'hffff_ffff :
                              (~data_planar0_p1_flag[0] & data_planar0_p0_cur_flag[0]) ? ~(32'hffffffff << lp_planar0_mask_sft) :
                              32'h0;
    data_planar0_p0_rp_mask = ~data_planar0_p0_cur_flag[1] ? 32'h0 :
                              (~data_planar0_p1_flag[1] & data_planar0_p0_cur_flag[1]) ? (32'hffffffff << rp_planar0_mask_sft) :
                              32'hffff_ffff;
    data_planar0_p0_zero_mask = ~data_planar0_p0_cur_flag[2] ? 32'h0 : (32'hffffffff << zero_planar0_mask_sft);
    data_planar0_p0_pad_mask = (data_planar0_p0_lp_mask | data_planar0_p0_rp_mask) & ~data_planar0_p0_zero_mask;
end

always @(
  data_planar0_p1_cur_flag
  or data_planar0_p0_cur_flag
  or lp_planar0_mask_sft
  or rp_planar0_mask_sft
  or zero_planar0_mask_sft
  ) begin
    data_planar0_p1_lp_mask = ~data_planar0_p1_cur_flag[0] ? 32'hffff_ffff :
                              (~data_planar0_p0_cur_flag[0] & data_planar0_p1_cur_flag[0]) ? ~(32'hffffffff << lp_planar0_mask_sft) :
                              32'h0;
    data_planar0_p1_rp_mask = ~data_planar0_p1_cur_flag[1] ? 32'h0 :
                              (~data_planar0_p0_cur_flag[1] & data_planar0_p1_cur_flag[1]) ? (32'hffffffff << rp_planar0_mask_sft) :
                              32'hffff_ffff;
    data_planar0_p1_zero_mask = ~data_planar0_p1_cur_flag[2] ? 32'h0 :
                                data_planar0_p0_cur_flag[2] ? 32'hffffffff :
                                (32'hffffffff << zero_planar0_mask_sft);
    data_planar0_p1_pad_mask = (data_planar0_p1_lp_mask | data_planar0_p1_rp_mask) & ~data_planar0_p1_zero_mask;
end

always @(
  data_planar1_p0_cur_flag
  or data_planar1_p1_flag
  or lp_planar1_mask_sft
  or rp_planar1_mask_sft
  or zero_planar1_mask_sft
  ) begin
    data_planar1_p0_lp_mask = ~data_planar1_p0_cur_flag[0] ? 32'hffff_ffff :
                              (~data_planar1_p1_flag[0] & data_planar1_p0_cur_flag[0]) ? ~(32'hffffffff << lp_planar1_mask_sft) :
                              32'h0;
    data_planar1_p0_rp_mask = ~data_planar1_p0_cur_flag[1] ? 32'h0 :
                              (~data_planar1_p1_flag[1] & data_planar1_p0_cur_flag[1]) ? (32'hffffffff << rp_planar1_mask_sft) :
                              32'hffff_ffff;
    data_planar1_p0_zero_mask = ~data_planar1_p0_cur_flag[2] ? 32'h0 : (32'hffffffff << zero_planar1_mask_sft);
    data_planar1_p0_pad_mask = (data_planar1_p0_lp_mask | data_planar1_p0_rp_mask) & ~data_planar1_p0_zero_mask;
end

always @(
  data_planar1_p1_cur_flag
  or data_planar1_p0_cur_flag
  or lp_planar1_mask_sft
  or rp_planar1_mask_sft
  or zero_planar1_mask_sft
  ) begin
    data_planar1_p1_lp_mask = ~data_planar1_p1_cur_flag[0] ? 32'hffff_ffff :
                              (~data_planar1_p0_cur_flag[0] & data_planar1_p1_cur_flag[0]) ? ~(32'hffffffff << lp_planar1_mask_sft) :
                              32'h0;
    data_planar1_p1_rp_mask = ~data_planar1_p1_cur_flag[1] ? 32'h0 :
                              (~data_planar1_p0_cur_flag[1] & data_planar1_p1_cur_flag[1]) ? (32'hffffffff << rp_planar1_mask_sft) :
                              32'hffff_ffff;
    data_planar1_p1_zero_mask = ~data_planar1_p1_cur_flag[2] ? 32'h0 :
                                data_planar1_p0_cur_flag[2] ? 32'hffffffff :
                                (32'hffffffff << zero_planar1_mask_sft);
    data_planar1_p1_pad_mask = (data_planar1_p1_lp_mask | data_planar1_p1_rp_mask) & ~data_planar1_p1_zero_mask;
end

always @(
  rd_planar_cnt
  or data_planar0_p0_pad_mask
  or data_planar1_p0_pad_mask
  or data_planar0_p1_pad_mask
  or data_planar1_p1_pad_mask
  or data_planar0_p0_zero_mask
  or data_planar1_p0_zero_mask
  or data_planar0_p1_zero_mask
  or data_planar1_p1_zero_mask
  ) begin
    rd_p0_pad_mask = ~rd_planar_cnt ? data_planar0_p0_pad_mask : data_planar1_p0_pad_mask;
    rd_p1_pad_mask = ~rd_planar_cnt ? data_planar0_p1_pad_mask : data_planar1_p1_pad_mask;
    rd_p0_zero_mask = ~rd_planar_cnt ? data_planar0_p0_zero_mask : data_planar1_p0_zero_mask;
    rd_p1_zero_mask = ~rd_planar_cnt ? data_planar0_p1_zero_mask : data_planar1_p1_zero_mask;
end

always @(
  is_first_running
  or rd_vld
  or rd_planar_cnt
  ) begin
    data_planar0_en = is_first_running | (rd_vld & ~rd_planar_cnt);
    data_planar1_en = is_first_running | (rd_vld & rd_planar_cnt);
    data_planar0_ori_en = is_first_running;
    data_planar1_ori_en = is_first_running;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    data_planar0_cur_cnt <= {14{1'b0}};
  end else begin
  if ((data_planar0_en) == 1'b1) begin
    data_planar0_cur_cnt <= data_planar0_cur_cnt_w;
  // VCS coverage off
  end else if ((data_planar0_en) == 1'b0) begin
  end else begin
    data_planar0_cur_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_30x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    data_planar1_cur_cnt <= {14{1'b0}};
  end else begin
  if ((data_planar1_en) == 1'b1) begin
    data_planar1_cur_cnt <= data_planar1_cur_cnt_w;
  // VCS coverage off
  end else if ((data_planar1_en) == 1'b0) begin
  end else begin
    data_planar1_cur_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    data_planar0_ori_cnt <= {14{1'b0}};
  end else begin
  if ((data_planar0_ori_en) == 1'b1) begin
    data_planar0_ori_cnt <= data_planar0_cur_cnt_w;
  // VCS coverage off
  end else if ((data_planar0_ori_en) == 1'b0) begin
  end else begin
    data_planar0_ori_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar0_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    data_planar1_ori_cnt <= {14{1'b0}};
  end else begin
  if ((data_planar1_ori_en) == 1'b1) begin
    data_planar1_ori_cnt <= data_planar1_cur_cnt_w;
  // VCS coverage off
  end else if ((data_planar1_ori_en) == 1'b0) begin
  end else begin
    data_planar1_ori_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_33x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar1_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    data_planar0_p1_flag <= {3{1'b0}};
  end else begin
  if ((data_planar0_en) == 1'b1) begin
    data_planar0_p1_flag <= data_planar0_p1_flag_w;
  // VCS coverage off
  end else if ((data_planar0_en) == 1'b0) begin
  end else begin
    data_planar0_p1_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_34x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    data_planar1_p1_flag <= {3{1'b0}};
  end else begin
  if ((data_planar1_en) == 1'b1) begin
    data_planar1_p1_flag <= data_planar1_p1_flag_w;
  // VCS coverage off
  end else if ((data_planar1_en) == 1'b0) begin
  end else begin
    data_planar1_p1_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_35x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    data_planar0_p1_ori_flag <= {3{1'b0}};
  end else begin
  if ((data_planar0_ori_en) == 1'b1) begin
    data_planar0_p1_ori_flag <= data_planar0_p1_flag_w;
  // VCS coverage off
  end else if ((data_planar0_ori_en) == 1'b0) begin
  end else begin
    data_planar0_p1_ori_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_36x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar0_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    data_planar1_p1_ori_flag <= {3{1'b0}};
  end else begin
  if ((data_planar1_ori_en) == 1'b1) begin
    data_planar1_p1_ori_flag <= data_planar1_p1_flag_w;
  // VCS coverage off
  end else if ((data_planar1_ori_en) == 1'b0) begin
  end else begin
    data_planar1_p1_ori_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_37x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar1_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_planar_d1 <= 1'b0;
  end else begin
  if ((rd_vld) == 1'b1) begin
    rd_planar_d1 <= rd_planar_cnt;
  // VCS coverage off
  end else if ((rd_vld) == 1'b0) begin
  end else begin
    rd_planar_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_38x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_sub_h_d1 <= {3{1'b0}};
  end else begin
  if ((rd_vld) == 1'b1) begin
    rd_sub_h_d1 <= rd_sub_h_cnt;
  // VCS coverage off
  end else if ((rd_vld) == 1'b0) begin
  end else begin
    rd_sub_h_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_39x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_sub_h_end_d1 <= 1'b0;
  end else begin
  if ((rd_vld) == 1'b1) begin
    rd_sub_h_end_d1 <= rd_sub_h_end;
  // VCS coverage off
  end else if ((rd_vld) == 1'b0) begin
  end else begin
    rd_sub_h_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_40x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_loop_end_d1 <= 1'b0;
  end else begin
  if ((rd_vld) == 1'b1) begin
    rd_loop_end_d1 <= rd_loop_end;
  // VCS coverage off
  end else if ((rd_vld) == 1'b0) begin
  end else begin
    rd_loop_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_41x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_one_line_end_d1 <= 1'b0;
  end else begin
  if ((rd_vld) == 1'b1) begin
    rd_one_line_end_d1 <= (is_last_pburst & is_last_planar & is_last_loop & img_line_end);
  // VCS coverage off
  end else if ((rd_vld) == 1'b0) begin
  end else begin
    rd_one_line_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_1st_height_d1 <= 1'b0;
  end else begin
  if ((rd_vld) == 1'b1) begin
    rd_1st_height_d1 <= is_1st_height;
  // VCS coverage off
  end else if ((rd_vld) == 1'b0) begin
  end else begin
    rd_1st_height_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_43x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_layer_end_d1 <= 1'b0;
  end else begin
  if ((rd_vld) == 1'b1) begin
    rd_layer_end_d1 <= img_layer_end & rd_height_end;
  // VCS coverage off
  end else if ((rd_vld) == 1'b0) begin
  end else begin
    rd_layer_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_44x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  if ((rd_vld) == 1'b1) begin
    rd_p0_pad_mask_d1 <= rd_p0_pad_mask;
  // VCS coverage off
  end else if ((rd_vld) == 1'b0) begin
  end else begin
    rd_p0_pad_mask_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rd_vld) == 1'b1) begin
    rd_p1_pad_mask_d1 <= rd_p1_pad_mask;
  // VCS coverage off
  end else if ((rd_vld) == 1'b0) begin
  end else begin
    rd_p1_pad_mask_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rd_vld) == 1'b1) begin
    rd_p0_zero_mask_d1 <= rd_p0_zero_mask;
  // VCS coverage off
  end else if ((rd_vld) == 1'b0) begin
  end else begin
    rd_p0_zero_mask_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rd_vld) == 1'b1) begin
    rd_p1_zero_mask_d1 <= rd_p1_zero_mask;
  // VCS coverage off
  end else if ((rd_vld) == 1'b0) begin
  end else begin
    rd_p1_zero_mask_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
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
  nv_assert_never #(0,0,"Error! data_planar0_p0_cnt_w is overflow!")      zzz_assert_never_45x (nvdla_core_clk, `ASSERT_RESET, (data_planar0_en & mon_data_planar0_p0_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! data_planar0_p1_cnt_w is overflow!")      zzz_assert_never_46x (nvdla_core_clk, `ASSERT_RESET, (data_planar0_en & mon_data_planar0_p1_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! data_planar1_p0_cnt_w is overflow!")      zzz_assert_never_47x (nvdla_core_clk, `ASSERT_RESET, (data_planar1_en & mon_data_planar1_p0_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! data_planar1_p1_cnt_w is overflow!")      zzz_assert_never_48x (nvdla_core_clk, `ASSERT_RESET, (data_planar1_en & mon_data_planar1_p1_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! data_planar0_p0_cur_flag invalid!")      zzz_assert_never_49x (nvdla_core_clk, `ASSERT_RESET, (rd_vld & ~rd_planar_cnt & data_planar0_p0_cur_flag[2] & ~img_line_end)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! data_planar0_p1_cur_flag invalid!")      zzz_assert_never_50x (nvdla_core_clk, `ASSERT_RESET, (rd_vld & ~rd_planar_cnt & data_planar0_p1_cur_flag[2] & ~img_line_end)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! data_planar1_p0_cur_flag invalid!")      zzz_assert_never_51x (nvdla_core_clk, `ASSERT_RESET, (rd_vld & rd_planar_cnt & data_planar1_p0_cur_flag[2] & ~img_line_end)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! data_planar1_p1_cur_flag invalid!")      zzz_assert_never_52x (nvdla_core_clk, `ASSERT_RESET, (rd_vld & rd_planar_cnt & data_planar1_p1_cur_flag[2] & ~img_line_end)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// connect to shared buffer                                           //
////////////////////////////////////////////////////////////////////////
assign img2sbuf_p0_rd_en = rd_p0_vld_d1;
assign img2sbuf_p1_rd_en = rd_p1_vld_d1;
assign img2sbuf_p0_rd_addr = rd_p0_addr_d1;
assign img2sbuf_p1_rd_addr = rd_p1_addr_d1;

////////////////////////////////////////////////////////////////////////
// pipeline register for shared buffer read latency                   //
////////////////////////////////////////////////////////////////////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_vld_d2 <= 1'b0;
  end else begin
  rd_vld_d2 <= rd_vld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_planar_d2 <= 1'b0;
  end else begin
  if ((rd_vld_d1) == 1'b1) begin
    rd_planar_d2 <= rd_planar_d1;
  // VCS coverage off
  end else if ((rd_vld_d1) == 1'b0) begin
  end else begin
    rd_planar_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_sub_h_d2 <= {3{1'b0}};
  end else begin
  if ((rd_vld_d1) == 1'b1) begin
    rd_sub_h_d2 <= rd_sub_h_d1;
  // VCS coverage off
  end else if ((rd_vld_d1) == 1'b0) begin
  end else begin
    rd_sub_h_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_54x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_sub_h_end_d2 <= 1'b0;
  end else begin
  if ((rd_vld_d1) == 1'b1) begin
    rd_sub_h_end_d2 <= rd_sub_h_end_d1;
  // VCS coverage off
  end else if ((rd_vld_d1) == 1'b0) begin
  end else begin
    rd_sub_h_end_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_55x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_loop_end_d2 <= 1'b0;
  end else begin
  if ((rd_vld_d1) == 1'b1) begin
    rd_loop_end_d2 <= rd_loop_end_d1;
  // VCS coverage off
  end else if ((rd_vld_d1) == 1'b0) begin
  end else begin
    rd_loop_end_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_56x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_one_line_end_d2 <= 1'b0;
  end else begin
  if ((rd_vld_d1) == 1'b1) begin
    rd_one_line_end_d2 <= rd_one_line_end_d1;
  // VCS coverage off
  end else if ((rd_vld_d1) == 1'b0) begin
  end else begin
    rd_one_line_end_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_57x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_1st_height_d2 <= 1'b0;
  end else begin
  if ((rd_vld_d1) == 1'b1) begin
    rd_1st_height_d2 <= rd_1st_height_d1;
  // VCS coverage off
  end else if ((rd_vld_d1) == 1'b0) begin
  end else begin
    rd_1st_height_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_58x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_layer_end_d2 <= 1'b0;
  end else begin
  if ((rd_vld_d1) == 1'b1) begin
    rd_layer_end_d2 <= rd_layer_end_d1;
  // VCS coverage off
  end else if ((rd_vld_d1) == 1'b0) begin
  end else begin
    rd_layer_end_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_59x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  if ((rd_vld_d1) == 1'b1) begin
    rd_p0_pad_mask_d2 <= rd_p0_pad_mask_d1;
  // VCS coverage off
  end else if ((rd_vld_d1) == 1'b0) begin
  end else begin
    rd_p0_pad_mask_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rd_vld_d1) == 1'b1) begin
    rd_p1_pad_mask_d2 <= rd_p1_pad_mask_d1;
  // VCS coverage off
  end else if ((rd_vld_d1) == 1'b0) begin
  end else begin
    rd_p1_pad_mask_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rd_vld_d1) == 1'b1) begin
    rd_p0_zero_mask_d2 <= rd_p0_zero_mask_d1;
  // VCS coverage off
  end else if ((rd_vld_d1) == 1'b0) begin
  end else begin
    rd_p0_zero_mask_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rd_vld_d1) == 1'b1) begin
    rd_p1_zero_mask_d2 <= rd_p1_zero_mask_d1;
  // VCS coverage off
  end else if ((rd_vld_d1) == 1'b0) begin
  end else begin
    rd_p1_zero_mask_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_vld_d3 <= 1'b0;
  end else begin
  rd_vld_d3 <= rd_vld_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_planar_d3 <= 1'b0;
  end else begin
  if ((rd_vld_d2) == 1'b1) begin
    rd_planar_d3 <= rd_planar_d2;
  // VCS coverage off
  end else if ((rd_vld_d2) == 1'b0) begin
  end else begin
    rd_planar_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_60x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_sub_h_d3 <= {3{1'b0}};
  end else begin
  if ((rd_vld_d2) == 1'b1) begin
    rd_sub_h_d3 <= rd_sub_h_d2;
  // VCS coverage off
  end else if ((rd_vld_d2) == 1'b0) begin
  end else begin
    rd_sub_h_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_61x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_sub_h_end_d3 <= 1'b0;
  end else begin
  if ((rd_vld_d2) == 1'b1) begin
    rd_sub_h_end_d3 <= rd_sub_h_end_d2;
  // VCS coverage off
  end else if ((rd_vld_d2) == 1'b0) begin
  end else begin
    rd_sub_h_end_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_62x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_loop_end_d3 <= 1'b0;
  end else begin
  if ((rd_vld_d2) == 1'b1) begin
    rd_loop_end_d3 <= rd_loop_end_d2;
  // VCS coverage off
  end else if ((rd_vld_d2) == 1'b0) begin
  end else begin
    rd_loop_end_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_63x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_one_line_end_d3 <= 1'b0;
  end else begin
  if ((rd_vld_d2) == 1'b1) begin
    rd_one_line_end_d3 <= rd_one_line_end_d2;
  // VCS coverage off
  end else if ((rd_vld_d2) == 1'b0) begin
  end else begin
    rd_one_line_end_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_64x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_1st_height_d3 <= 1'b0;
  end else begin
  if ((rd_vld_d2) == 1'b1) begin
    rd_1st_height_d3 <= rd_1st_height_d2;
  // VCS coverage off
  end else if ((rd_vld_d2) == 1'b0) begin
  end else begin
    rd_1st_height_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_65x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rd_layer_end_d3 <= 1'b0;
  end else begin
  if ((rd_vld_d2) == 1'b1) begin
    rd_layer_end_d3 <= rd_layer_end_d2;
  // VCS coverage off
  end else if ((rd_vld_d2) == 1'b0) begin
  end else begin
    rd_layer_end_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_66x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  if ((rd_vld_d2) == 1'b1) begin
    rd_p0_pad_mask_d3 <= rd_p0_pad_mask_d2;
  // VCS coverage off
  end else if ((rd_vld_d2) == 1'b0) begin
  end else begin
    rd_p0_pad_mask_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rd_vld_d2) == 1'b1) begin
    rd_p1_pad_mask_d3 <= rd_p1_pad_mask_d2;
  // VCS coverage off
  end else if ((rd_vld_d2) == 1'b0) begin
  end else begin
    rd_p1_pad_mask_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rd_vld_d2) == 1'b1) begin
    rd_p0_zero_mask_d3 <= rd_p0_zero_mask_d2;
  // VCS coverage off
  end else if ((rd_vld_d2) == 1'b0) begin
  end else begin
    rd_p0_zero_mask_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rd_vld_d2) == 1'b1) begin
    rd_p1_zero_mask_d3 <= rd_p1_zero_mask_d2;
  // VCS coverage off
  end else if ((rd_vld_d2) == 1'b0) begin
  end else begin
    rd_p1_zero_mask_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

assign pk_rsp_vld           = rd_vld_d3;
assign pk_rsp_planar        = rd_planar_d3;
assign pk_rsp_sub_h         = rd_sub_h_d3;
assign pk_rsp_sub_h_end     = rd_sub_h_end_d3;
assign pk_rsp_loop_end      = rd_loop_end_d3;
assign pk_rsp_one_line_end  = rd_one_line_end_d3;
assign pk_rsp_1st_height    = rd_1st_height_d3;
assign pk_rsp_layer_end     = rd_layer_end_d3;
assign pk_rsp_p0_pad_mask   = rd_p0_pad_mask_d3;
assign pk_rsp_p1_pad_mask   = rd_p1_pad_mask_d3;
assign pk_rsp_p0_zero_mask  = rd_p0_zero_mask_d3;
assign pk_rsp_p1_zero_mask  = rd_p1_zero_mask_d3;

assign pk_rsp_early_end = pixel_early_end & pk_rsp_one_line_end;
assign pk_rsp_vld_d1_w = pk_rsp_vld & pixel_planar & ~(pk_rsp_early_end);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pk_rsp_vld_d1 <= 1'b0;
  end else begin
  pk_rsp_vld_d1 <= pk_rsp_vld_d1_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pk_rsp_sub_h_d1 <= {3{1'b0}};
  end else begin
  if ((pk_rsp_vld_d1_w) == 1'b1) begin
    pk_rsp_sub_h_d1 <= pk_rsp_sub_h;
  // VCS coverage off
  end else if ((pk_rsp_vld_d1_w) == 1'b0) begin
  end else begin
    pk_rsp_sub_h_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_67x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_rsp_sub_h_end_d1 <= 1'b0;
  end else begin
  if ((pk_rsp_vld_d1_w) == 1'b1) begin
    pk_rsp_sub_h_end_d1 <= pk_rsp_sub_h_end;
  // VCS coverage off
  end else if ((pk_rsp_vld_d1_w) == 1'b0) begin
  end else begin
    pk_rsp_sub_h_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_68x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_rsp_loop_end_d1 <= 1'b0;
  end else begin
  if ((pk_rsp_vld_d1_w) == 1'b1) begin
    pk_rsp_loop_end_d1 <= pk_rsp_loop_end;
  // VCS coverage off
  end else if ((pk_rsp_vld_d1_w) == 1'b0) begin
  end else begin
    pk_rsp_loop_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_69x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_rsp_one_line_end_d1 <= 1'b0;
  end else begin
  if ((pk_rsp_vld_d1_w) == 1'b1) begin
    pk_rsp_one_line_end_d1 <= pk_rsp_one_line_end;
  // VCS coverage off
  end else if ((pk_rsp_vld_d1_w) == 1'b0) begin
  end else begin
    pk_rsp_one_line_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_70x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_rsp_1st_height_d1 <= 1'b0;
  end else begin
  if ((pk_rsp_vld_d1_w) == 1'b1) begin
    pk_rsp_1st_height_d1 <= pk_rsp_1st_height;
  // VCS coverage off
  end else if ((pk_rsp_vld_d1_w) == 1'b0) begin
  end else begin
    pk_rsp_1st_height_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_71x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_rsp_layer_end_d1 <= 1'b0;
  end else begin
  if ((pk_rsp_vld_d1_w) == 1'b1) begin
    pk_rsp_layer_end_d1 <= pk_rsp_layer_end;
  // VCS coverage off
  end else if ((pk_rsp_vld_d1_w) == 1'b0) begin
  end else begin
    pk_rsp_layer_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_72x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  connect to sbuf ram input                                         //
////////////////////////////////////////////////////////////////////////

assign pk_rsp_p0_data = img2sbuf_p0_rd_data;
assign pk_rsp_p1_data = img2sbuf_p1_rd_data;

////////////////////////////////////////////////////////////////////////
// data write logic                                                   //
////////////////////////////////////////////////////////////////////////
//////// control and status logic ////////

assign pk_rsp_pipe_sel = (~pixel_planar | (pk_rsp_vld & pk_rsp_early_end));

assign pk_rsp_cur_vld = pk_rsp_pipe_sel ? pk_rsp_vld : pk_rsp_vld_d1;
assign pk_rsp_cur_sub_h = pk_rsp_pipe_sel ? pk_rsp_sub_h : pk_rsp_sub_h_d1;
assign pk_rsp_cur_sub_h_end = pk_rsp_pipe_sel ? pk_rsp_sub_h_end : pk_rsp_sub_h_end_d1;
assign pk_rsp_cur_loop_end = pk_rsp_pipe_sel ? pk_rsp_loop_end : pk_rsp_loop_end_d1;
assign pk_rsp_cur_one_line_end = pk_rsp_pipe_sel ? pk_rsp_one_line_end : pk_rsp_one_line_end_d1;
assign pk_rsp_cur_1st_height = pk_rsp_pipe_sel ? pk_rsp_1st_height : pk_rsp_1st_height_d1;
assign pk_rsp_cur_layer_end = pk_rsp_pipe_sel ? pk_rsp_layer_end : pk_rsp_layer_end_d1;

always @(
  pk_rsp_cur_vld
  ) begin
    pk_rsp_wr_vld = pk_rsp_cur_vld;
end

always @(
  is_first_running
  or pk_rsp_planar
  or pk_rsp_wr_cnt
  ) begin
    {mon_pk_rsp_wr_cnt_w,
     pk_rsp_wr_cnt_w} = (is_first_running | ~pk_rsp_planar) ? 3'b0 :
                        pk_rsp_wr_cnt + 1'b1;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pk_rsp_wr_cnt <= {2{1'b0}};
  end else begin
  if ((pk_rsp_vld) == 1'b1) begin
    pk_rsp_wr_cnt <= pk_rsp_wr_cnt_w;
  // VCS coverage off
  end else if ((pk_rsp_vld) == 1'b0) begin
  end else begin
    pk_rsp_wr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_73x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign pk_rsp_wr_size_ori = pixel_packed_10b ? 3'h4 : 3'h2;
assign pk_rsp_wr_mask = pixel_packed_10b ? 4'hf : 4'h3;
assign pk_rsp_wr_ext64 = (pk_rsp_cur_one_line_end & (pk_rsp_wr_sub_addr == 2'h2) & pixel_data_shrink & ~pixel_packed_10b);
assign pk_rsp_wr_ext128 = (pk_rsp_cur_one_line_end & ~pk_rsp_wr_sub_addr[1] & (pixel_data_shrink | (~pixel_data_expand & ~pixel_packed_10b)));
assign pk_out_interleave = 1'b0;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pk_out_vld <= 1'b0;
  end else begin
  pk_out_vld <= pk_rsp_wr_vld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pk_out_sub_h <= {3{1'b0}};
  end else begin
  if ((pk_rsp_wr_vld) == 1'b1) begin
    pk_out_sub_h <= pk_rsp_cur_sub_h;
  // VCS coverage off
  end else if ((pk_rsp_wr_vld) == 1'b0) begin
  end else begin
    pk_out_sub_h <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_74x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_out_mask <= {4{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    pk_out_mask <= pk_rsp_wr_mask;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    pk_out_mask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_75x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_out_mean <= 1'b0;
  end else begin
  if ((is_first_running) == 1'b1) begin
    pk_out_mean <= sg2pack_mn_enable;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    pk_out_mean <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_76x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_out_uint <= 1'b0;
  end else begin
  if ((is_first_running) == 1'b1) begin
    pk_out_uint <= pixel_uint;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    pk_out_uint <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_77x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_out_ext64 <= 1'b0;
  end else begin
  if ((pk_rsp_wr_vld) == 1'b1) begin
    pk_out_ext64 <= pk_rsp_wr_ext64;
  // VCS coverage off
  end else if ((pk_rsp_wr_vld) == 1'b0) begin
  end else begin
    pk_out_ext64 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_78x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_out_ext128 <= 1'b0;
  end else begin
  if ((pk_rsp_wr_vld) == 1'b1) begin
    pk_out_ext128 <= pk_rsp_wr_ext128;
  // VCS coverage off
  end else if ((pk_rsp_wr_vld) == 1'b0) begin
  end else begin
    pk_out_ext128 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_79x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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


// PKT_PACK_WIRE( nvdla_ram_info ,  pk_out_ ,  pk_out_info_pd )
assign       pk_out_info_pd[3:0] =     pk_out_mask[3:0];
assign       pk_out_info_pd[4] =     pk_out_interleave ;
assign       pk_out_info_pd[5] =     pk_out_ext64 ;
assign       pk_out_info_pd[6] =     pk_out_ext128 ;
assign       pk_out_info_pd[7] =     pk_out_mean ;
assign       pk_out_info_pd[8] =     pk_out_uint ;
assign       pk_out_info_pd[11:9] =     pk_out_sub_h[2:0];

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
  nv_assert_never #(0,0,"Error! pk_rsp_wr_cnt is overflow!")      zzz_assert_never_80x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_vld & mon_pk_rsp_wr_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pk_rsp_wr_cnt is out of range!")      zzz_assert_never_81x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_vld & (pk_rsp_wr_cnt > 2'h2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// data output logic                                                  //
////////////////////////////////////////////////////////////////////////

assign rdat = {pk_rsp_p1_data, pk_rsp_p0_data};
assign mask_zero = {pk_rsp_p1_zero_mask, pk_rsp_p0_zero_mask};
assign mask_pad = {pk_rsp_p1_pad_mask, pk_rsp_p0_pad_mask};

assign z14 = 14'b0;
assign z6 = 6'b0;
assign pk_rsp_dat_normal = rdat;
assign pk_rsp_dat_ergb = {rdat[15*32+31:15*32+30], z14, rdat[15*32+29:15*32+20], z6, rdat[15*32+19:15*32+10], z6,rdat[15*32+9:15*32], z6, rdat[14*32+31:14*32+30], z14, rdat[14*32+29:14*32+20], z6, rdat[14*32+19:14*32+10], z6,rdat[14*32+9:14*32], z6, rdat[13*32+31:13*32+30], z14, rdat[13*32+29:13*32+20], z6, rdat[13*32+19:13*32+10], z6,rdat[13*32+9:13*32], z6, rdat[12*32+31:12*32+30], z14, rdat[12*32+29:12*32+20], z6, rdat[12*32+19:12*32+10], z6,rdat[12*32+9:12*32], z6, rdat[11*32+31:11*32+30], z14, rdat[11*32+29:11*32+20], z6, rdat[11*32+19:11*32+10], z6,rdat[11*32+9:11*32], z6, rdat[10*32+31:10*32+30], z14, rdat[10*32+29:10*32+20], z6, rdat[10*32+19:10*32+10], z6,rdat[10*32+9:10*32], z6, rdat[9*32+31:9*32+30], z14, rdat[9*32+29:9*32+20], z6, rdat[9*32+19:9*32+10], z6,rdat[9*32+9:9*32], z6, rdat[8*32+31:8*32+30], z14, rdat[8*32+29:8*32+20], z6, rdat[8*32+19:8*32+10], z6,rdat[8*32+9:8*32], z6, rdat[7*32+31:7*32+30], z14, rdat[7*32+29:7*32+20], z6, rdat[7*32+19:7*32+10], z6,rdat[7*32+9:7*32], z6, rdat[6*32+31:6*32+30], z14, rdat[6*32+29:6*32+20], z6, rdat[6*32+19:6*32+10], z6,rdat[6*32+9:6*32], z6, rdat[5*32+31:5*32+30], z14, rdat[5*32+29:5*32+20], z6, rdat[5*32+19:5*32+10], z6,rdat[5*32+9:5*32], z6, rdat[4*32+31:4*32+30], z14, rdat[4*32+29:4*32+20], z6, rdat[4*32+19:4*32+10], z6,rdat[4*32+9:4*32], z6, rdat[3*32+31:3*32+30], z14, rdat[3*32+29:3*32+20], z6, rdat[3*32+19:3*32+10], z6,rdat[3*32+9:3*32], z6, rdat[2*32+31:2*32+30], z14, rdat[2*32+29:2*32+20], z6, rdat[2*32+19:2*32+10], z6,rdat[2*32+9:2*32], z6, rdat[1*32+31:1*32+30], z14, rdat[1*32+29:1*32+20], z6, rdat[1*32+19:1*32+10], z6,rdat[1*32+9:1*32], z6, rdat[0*32+31:0*32+30], z14, rdat[0*32+29:0*32+20], z6, rdat[0*32+19:0*32+10], z6,rdat[0*32+9:0*32], z6};

//assign pk_rsp_dat_pad = (pixel_precision == 2'b0) ? {64{reg2dp_pad_value[7:0]}} :
//                        {32{reg2dp_pad_value}};

always @(
  pixel_packed_10b
  or mask_zero
  or mask_pad
  or pk_rsp_dat_ergb
  ) begin
    pk_rsp_dat_mergb[ 63:  0] = (~pixel_packed_10b | mask_zero[0] | mask_pad[0]) ? 64'b0 :
                                pk_rsp_dat_ergb[ 63:  0];
    pk_rsp_dat_mergb[127: 64] = (~pixel_packed_10b | mask_zero[4] | mask_pad[4]) ? 64'b0 :
                                pk_rsp_dat_ergb[127: 64];
    pk_rsp_dat_mergb[191:128] = (~pixel_packed_10b | mask_zero[8] | mask_pad[8]) ? 64'b0 :
                                pk_rsp_dat_ergb[191:128];
    pk_rsp_dat_mergb[255:192] = (~pixel_packed_10b | mask_zero[12] | mask_pad[12]) ? 64'b0 :
                                pk_rsp_dat_ergb[255:192];
    pk_rsp_dat_mergb[319:256] = (~pixel_packed_10b | mask_zero[16] | mask_pad[16]) ? 64'b0 :
                                pk_rsp_dat_ergb[319:256];
    pk_rsp_dat_mergb[383:320] = (~pixel_packed_10b | mask_zero[20] | mask_pad[20]) ? 64'b0 :
                                pk_rsp_dat_ergb[383:320];
    pk_rsp_dat_mergb[447:384] = (~pixel_packed_10b | mask_zero[24] | mask_pad[24]) ? 64'b0 :
                                pk_rsp_dat_ergb[447:384];
    pk_rsp_dat_mergb[511:448] = (~pixel_packed_10b | mask_zero[28] | mask_pad[28]) ? 64'b0 :
                                pk_rsp_dat_ergb[511:448];
    pk_rsp_dat_mergb[575:512] = (~pixel_packed_10b | mask_zero[32] | mask_pad[32]) ? 64'b0 :
                                pk_rsp_dat_ergb[575:512];
    pk_rsp_dat_mergb[639:576] = (~pixel_packed_10b | mask_zero[36] | mask_pad[36]) ? 64'b0 :
                                pk_rsp_dat_ergb[639:576];
    pk_rsp_dat_mergb[703:640] = (~pixel_packed_10b | mask_zero[40] | mask_pad[40]) ? 64'b0 :
                                pk_rsp_dat_ergb[703:640];
    pk_rsp_dat_mergb[767:704] = (~pixel_packed_10b | mask_zero[44] | mask_pad[44]) ? 64'b0 :
                                pk_rsp_dat_ergb[767:704];
    pk_rsp_dat_mergb[831:768] = (~pixel_packed_10b | mask_zero[48] | mask_pad[48]) ? 64'b0 :
                                pk_rsp_dat_ergb[831:768];
    pk_rsp_dat_mergb[895:832] = (~pixel_packed_10b | mask_zero[52] | mask_pad[52]) ? 64'b0 :
                                pk_rsp_dat_ergb[895:832];
    pk_rsp_dat_mergb[959:896] = (~pixel_packed_10b | mask_zero[56] | mask_pad[56]) ? 64'b0 :
                                pk_rsp_dat_ergb[959:896];
    pk_rsp_dat_mergb[1023:960] = (~pixel_packed_10b | mask_zero[60] | mask_pad[60]) ? 64'b0 :
                                pk_rsp_dat_ergb[1023:960];
end


always @(
  pixel_packed_10b
  or mask_zero
  or mask_pad
  or pk_rsp_dat_normal
  ) begin
    pk_rsp_dat_mnorm[  7:  0] = (pixel_packed_10b | mask_zero[0] | mask_pad[0]) ? 8'b0 :
                                pk_rsp_dat_normal[  7:  0];
    pk_rsp_dat_mnorm[ 15:  8] = (pixel_packed_10b | mask_zero[1] | mask_pad[1]) ? 8'b0 :
                                pk_rsp_dat_normal[ 15:  8];
    pk_rsp_dat_mnorm[ 23: 16] = (pixel_packed_10b | mask_zero[2] | mask_pad[2]) ? 8'b0 :
                                pk_rsp_dat_normal[ 23: 16];
    pk_rsp_dat_mnorm[ 31: 24] = (pixel_packed_10b | mask_zero[3] | mask_pad[3]) ? 8'b0 :
                                pk_rsp_dat_normal[ 31: 24];
    pk_rsp_dat_mnorm[ 39: 32] = (pixel_packed_10b | mask_zero[4] | mask_pad[4]) ? 8'b0 :
                                pk_rsp_dat_normal[ 39: 32];
    pk_rsp_dat_mnorm[ 47: 40] = (pixel_packed_10b | mask_zero[5] | mask_pad[5]) ? 8'b0 :
                                pk_rsp_dat_normal[ 47: 40];
    pk_rsp_dat_mnorm[ 55: 48] = (pixel_packed_10b | mask_zero[6] | mask_pad[6]) ? 8'b0 :
                                pk_rsp_dat_normal[ 55: 48];
    pk_rsp_dat_mnorm[ 63: 56] = (pixel_packed_10b | mask_zero[7] | mask_pad[7]) ? 8'b0 :
                                pk_rsp_dat_normal[ 63: 56];
    pk_rsp_dat_mnorm[ 71: 64] = (pixel_packed_10b | mask_zero[8] | mask_pad[8]) ? 8'b0 :
                                pk_rsp_dat_normal[ 71: 64];
    pk_rsp_dat_mnorm[ 79: 72] = (pixel_packed_10b | mask_zero[9] | mask_pad[9]) ? 8'b0 :
                                pk_rsp_dat_normal[ 79: 72];
    pk_rsp_dat_mnorm[ 87: 80] = (pixel_packed_10b | mask_zero[10] | mask_pad[10]) ? 8'b0 :
                                pk_rsp_dat_normal[ 87: 80];
    pk_rsp_dat_mnorm[ 95: 88] = (pixel_packed_10b | mask_zero[11] | mask_pad[11]) ? 8'b0 :
                                pk_rsp_dat_normal[ 95: 88];
    pk_rsp_dat_mnorm[103: 96] = (pixel_packed_10b | mask_zero[12] | mask_pad[12]) ? 8'b0 :
                                pk_rsp_dat_normal[103: 96];
    pk_rsp_dat_mnorm[111:104] = (pixel_packed_10b | mask_zero[13] | mask_pad[13]) ? 8'b0 :
                                pk_rsp_dat_normal[111:104];
    pk_rsp_dat_mnorm[119:112] = (pixel_packed_10b | mask_zero[14] | mask_pad[14]) ? 8'b0 :
                                pk_rsp_dat_normal[119:112];
    pk_rsp_dat_mnorm[127:120] = (pixel_packed_10b | mask_zero[15] | mask_pad[15]) ? 8'b0 :
                                pk_rsp_dat_normal[127:120];
    pk_rsp_dat_mnorm[135:128] = (pixel_packed_10b | mask_zero[16] | mask_pad[16]) ? 8'b0 :
                                pk_rsp_dat_normal[135:128];
    pk_rsp_dat_mnorm[143:136] = (pixel_packed_10b | mask_zero[17] | mask_pad[17]) ? 8'b0 :
                                pk_rsp_dat_normal[143:136];
    pk_rsp_dat_mnorm[151:144] = (pixel_packed_10b | mask_zero[18] | mask_pad[18]) ? 8'b0 :
                                pk_rsp_dat_normal[151:144];
    pk_rsp_dat_mnorm[159:152] = (pixel_packed_10b | mask_zero[19] | mask_pad[19]) ? 8'b0 :
                                pk_rsp_dat_normal[159:152];
    pk_rsp_dat_mnorm[167:160] = (pixel_packed_10b | mask_zero[20] | mask_pad[20]) ? 8'b0 :
                                pk_rsp_dat_normal[167:160];
    pk_rsp_dat_mnorm[175:168] = (pixel_packed_10b | mask_zero[21] | mask_pad[21]) ? 8'b0 :
                                pk_rsp_dat_normal[175:168];
    pk_rsp_dat_mnorm[183:176] = (pixel_packed_10b | mask_zero[22] | mask_pad[22]) ? 8'b0 :
                                pk_rsp_dat_normal[183:176];
    pk_rsp_dat_mnorm[191:184] = (pixel_packed_10b | mask_zero[23] | mask_pad[23]) ? 8'b0 :
                                pk_rsp_dat_normal[191:184];
    pk_rsp_dat_mnorm[199:192] = (pixel_packed_10b | mask_zero[24] | mask_pad[24]) ? 8'b0 :
                                pk_rsp_dat_normal[199:192];
    pk_rsp_dat_mnorm[207:200] = (pixel_packed_10b | mask_zero[25] | mask_pad[25]) ? 8'b0 :
                                pk_rsp_dat_normal[207:200];
    pk_rsp_dat_mnorm[215:208] = (pixel_packed_10b | mask_zero[26] | mask_pad[26]) ? 8'b0 :
                                pk_rsp_dat_normal[215:208];
    pk_rsp_dat_mnorm[223:216] = (pixel_packed_10b | mask_zero[27] | mask_pad[27]) ? 8'b0 :
                                pk_rsp_dat_normal[223:216];
    pk_rsp_dat_mnorm[231:224] = (pixel_packed_10b | mask_zero[28] | mask_pad[28]) ? 8'b0 :
                                pk_rsp_dat_normal[231:224];
    pk_rsp_dat_mnorm[239:232] = (pixel_packed_10b | mask_zero[29] | mask_pad[29]) ? 8'b0 :
                                pk_rsp_dat_normal[239:232];
    pk_rsp_dat_mnorm[247:240] = (pixel_packed_10b | mask_zero[30] | mask_pad[30]) ? 8'b0 :
                                pk_rsp_dat_normal[247:240];
    pk_rsp_dat_mnorm[255:248] = (pixel_packed_10b | mask_zero[31] | mask_pad[31]) ? 8'b0 :
                                pk_rsp_dat_normal[255:248];
    pk_rsp_dat_mnorm[263:256] = (pixel_packed_10b | mask_zero[32] | mask_pad[32]) ? 8'b0 :
                                pk_rsp_dat_normal[263:256];
    pk_rsp_dat_mnorm[271:264] = (pixel_packed_10b | mask_zero[33] | mask_pad[33]) ? 8'b0 :
                                pk_rsp_dat_normal[271:264];
    pk_rsp_dat_mnorm[279:272] = (pixel_packed_10b | mask_zero[34] | mask_pad[34]) ? 8'b0 :
                                pk_rsp_dat_normal[279:272];
    pk_rsp_dat_mnorm[287:280] = (pixel_packed_10b | mask_zero[35] | mask_pad[35]) ? 8'b0 :
                                pk_rsp_dat_normal[287:280];
    pk_rsp_dat_mnorm[295:288] = (pixel_packed_10b | mask_zero[36] | mask_pad[36]) ? 8'b0 :
                                pk_rsp_dat_normal[295:288];
    pk_rsp_dat_mnorm[303:296] = (pixel_packed_10b | mask_zero[37] | mask_pad[37]) ? 8'b0 :
                                pk_rsp_dat_normal[303:296];
    pk_rsp_dat_mnorm[311:304] = (pixel_packed_10b | mask_zero[38] | mask_pad[38]) ? 8'b0 :
                                pk_rsp_dat_normal[311:304];
    pk_rsp_dat_mnorm[319:312] = (pixel_packed_10b | mask_zero[39] | mask_pad[39]) ? 8'b0 :
                                pk_rsp_dat_normal[319:312];
    pk_rsp_dat_mnorm[327:320] = (pixel_packed_10b | mask_zero[40] | mask_pad[40]) ? 8'b0 :
                                pk_rsp_dat_normal[327:320];
    pk_rsp_dat_mnorm[335:328] = (pixel_packed_10b | mask_zero[41] | mask_pad[41]) ? 8'b0 :
                                pk_rsp_dat_normal[335:328];
    pk_rsp_dat_mnorm[343:336] = (pixel_packed_10b | mask_zero[42] | mask_pad[42]) ? 8'b0 :
                                pk_rsp_dat_normal[343:336];
    pk_rsp_dat_mnorm[351:344] = (pixel_packed_10b | mask_zero[43] | mask_pad[43]) ? 8'b0 :
                                pk_rsp_dat_normal[351:344];
    pk_rsp_dat_mnorm[359:352] = (pixel_packed_10b | mask_zero[44] | mask_pad[44]) ? 8'b0 :
                                pk_rsp_dat_normal[359:352];
    pk_rsp_dat_mnorm[367:360] = (pixel_packed_10b | mask_zero[45] | mask_pad[45]) ? 8'b0 :
                                pk_rsp_dat_normal[367:360];
    pk_rsp_dat_mnorm[375:368] = (pixel_packed_10b | mask_zero[46] | mask_pad[46]) ? 8'b0 :
                                pk_rsp_dat_normal[375:368];
    pk_rsp_dat_mnorm[383:376] = (pixel_packed_10b | mask_zero[47] | mask_pad[47]) ? 8'b0 :
                                pk_rsp_dat_normal[383:376];
    pk_rsp_dat_mnorm[391:384] = (pixel_packed_10b | mask_zero[48] | mask_pad[48]) ? 8'b0 :
                                pk_rsp_dat_normal[391:384];
    pk_rsp_dat_mnorm[399:392] = (pixel_packed_10b | mask_zero[49] | mask_pad[49]) ? 8'b0 :
                                pk_rsp_dat_normal[399:392];
    pk_rsp_dat_mnorm[407:400] = (pixel_packed_10b | mask_zero[50] | mask_pad[50]) ? 8'b0 :
                                pk_rsp_dat_normal[407:400];
    pk_rsp_dat_mnorm[415:408] = (pixel_packed_10b | mask_zero[51] | mask_pad[51]) ? 8'b0 :
                                pk_rsp_dat_normal[415:408];
    pk_rsp_dat_mnorm[423:416] = (pixel_packed_10b | mask_zero[52] | mask_pad[52]) ? 8'b0 :
                                pk_rsp_dat_normal[423:416];
    pk_rsp_dat_mnorm[431:424] = (pixel_packed_10b | mask_zero[53] | mask_pad[53]) ? 8'b0 :
                                pk_rsp_dat_normal[431:424];
    pk_rsp_dat_mnorm[439:432] = (pixel_packed_10b | mask_zero[54] | mask_pad[54]) ? 8'b0 :
                                pk_rsp_dat_normal[439:432];
    pk_rsp_dat_mnorm[447:440] = (pixel_packed_10b | mask_zero[55] | mask_pad[55]) ? 8'b0 :
                                pk_rsp_dat_normal[447:440];
    pk_rsp_dat_mnorm[455:448] = (pixel_packed_10b | mask_zero[56] | mask_pad[56]) ? 8'b0 :
                                pk_rsp_dat_normal[455:448];
    pk_rsp_dat_mnorm[463:456] = (pixel_packed_10b | mask_zero[57] | mask_pad[57]) ? 8'b0 :
                                pk_rsp_dat_normal[463:456];
    pk_rsp_dat_mnorm[471:464] = (pixel_packed_10b | mask_zero[58] | mask_pad[58]) ? 8'b0 :
                                pk_rsp_dat_normal[471:464];
    pk_rsp_dat_mnorm[479:472] = (pixel_packed_10b | mask_zero[59] | mask_pad[59]) ? 8'b0 :
                                pk_rsp_dat_normal[479:472];
    pk_rsp_dat_mnorm[487:480] = (pixel_packed_10b | mask_zero[60] | mask_pad[60]) ? 8'b0 :
                                pk_rsp_dat_normal[487:480];
    pk_rsp_dat_mnorm[495:488] = (pixel_packed_10b | mask_zero[61] | mask_pad[61]) ? 8'b0 :
                                pk_rsp_dat_normal[495:488];
    pk_rsp_dat_mnorm[503:496] = (pixel_packed_10b | mask_zero[62] | mask_pad[62]) ? 8'b0 :
                                pk_rsp_dat_normal[503:496];
    pk_rsp_dat_mnorm[511:504] = (pixel_packed_10b | mask_zero[63] | mask_pad[63]) ? 8'b0 :
                                pk_rsp_dat_normal[511:504];
end



assign dat_l0 = pk_rsp_planar0_c0_d1;
assign dat_l1_lo = pk_rsp_planar1_c0_en ? pk_rsp_dat_mnorm : pk_rsp_planar1_c0_d1;
assign dat_l1_hi = pk_rsp_planar1_c1_en ? pk_rsp_dat_mnorm : pk_rsp_planar1_c1_d1;
assign dat_l1 = {dat_l1_hi, dat_l1_lo};

assign dat_8b_yuv = {dat_l1[63*16+15:63*16], dat_l0[63*8+7:63*8], dat_l1[62*16+15:62*16], dat_l0[62*8+7:62*8], dat_l1[61*16+15:61*16], dat_l0[61*8+7:61*8], dat_l1[60*16+15:60*16], dat_l0[60*8+7:60*8], dat_l1[59*16+15:59*16], dat_l0[59*8+7:59*8], dat_l1[58*16+15:58*16], dat_l0[58*8+7:58*8], dat_l1[57*16+15:57*16], dat_l0[57*8+7:57*8], dat_l1[56*16+15:56*16], dat_l0[56*8+7:56*8], dat_l1[55*16+15:55*16], dat_l0[55*8+7:55*8], dat_l1[54*16+15:54*16], dat_l0[54*8+7:54*8], dat_l1[53*16+15:53*16], dat_l0[53*8+7:53*8], dat_l1[52*16+15:52*16], dat_l0[52*8+7:52*8], dat_l1[51*16+15:51*16], dat_l0[51*8+7:51*8], dat_l1[50*16+15:50*16], dat_l0[50*8+7:50*8], dat_l1[49*16+15:49*16], dat_l0[49*8+7:49*8], dat_l1[48*16+15:48*16], dat_l0[48*8+7:48*8], dat_l1[47*16+15:47*16], dat_l0[47*8+7:47*8], dat_l1[46*16+15:46*16], dat_l0[46*8+7:46*8], dat_l1[45*16+15:45*16], dat_l0[45*8+7:45*8], dat_l1[44*16+15:44*16], dat_l0[44*8+7:44*8], dat_l1[43*16+15:43*16], dat_l0[43*8+7:43*8], dat_l1[42*16+15:42*16], dat_l0[42*8+7:42*8], dat_l1[41*16+15:41*16], dat_l0[41*8+7:41*8], dat_l1[40*16+15:40*16], dat_l0[40*8+7:40*8], dat_l1[39*16+15:39*16], dat_l0[39*8+7:39*8], dat_l1[38*16+15:38*16], dat_l0[38*8+7:38*8], dat_l1[37*16+15:37*16], dat_l0[37*8+7:37*8], dat_l1[36*16+15:36*16], dat_l0[36*8+7:36*8], dat_l1[35*16+15:35*16], dat_l0[35*8+7:35*8], dat_l1[34*16+15:34*16], dat_l0[34*8+7:34*8], dat_l1[33*16+15:33*16], dat_l0[33*8+7:33*8], dat_l1[32*16+15:32*16], dat_l0[32*8+7:32*8], dat_l1[31*16+15:31*16], dat_l0[31*8+7:31*8], dat_l1[30*16+15:30*16], dat_l0[30*8+7:30*8], dat_l1[29*16+15:29*16], dat_l0[29*8+7:29*8], dat_l1[28*16+15:28*16], dat_l0[28*8+7:28*8], dat_l1[27*16+15:27*16], dat_l0[27*8+7:27*8], dat_l1[26*16+15:26*16], dat_l0[26*8+7:26*8], dat_l1[25*16+15:25*16], dat_l0[25*8+7:25*8], dat_l1[24*16+15:24*16], dat_l0[24*8+7:24*8], dat_l1[23*16+15:23*16], dat_l0[23*8+7:23*8], dat_l1[22*16+15:22*16], dat_l0[22*8+7:22*8], dat_l1[21*16+15:21*16], dat_l0[21*8+7:21*8], dat_l1[20*16+15:20*16], dat_l0[20*8+7:20*8], dat_l1[19*16+15:19*16], dat_l0[19*8+7:19*8], dat_l1[18*16+15:18*16], dat_l0[18*8+7:18*8], dat_l1[17*16+15:17*16], dat_l0[17*8+7:17*8], dat_l1[16*16+15:16*16], dat_l0[16*8+7:16*8], dat_l1[15*16+15:15*16], dat_l0[15*8+7:15*8], dat_l1[14*16+15:14*16], dat_l0[14*8+7:14*8], dat_l1[13*16+15:13*16], dat_l0[13*8+7:13*8], dat_l1[12*16+15:12*16], dat_l0[12*8+7:12*8], dat_l1[11*16+15:11*16], dat_l0[11*8+7:11*8], dat_l1[10*16+15:10*16], dat_l0[10*8+7:10*8], dat_l1[9*16+15:9*16], dat_l0[9*8+7:9*8], dat_l1[8*16+15:8*16], dat_l0[8*8+7:8*8], dat_l1[7*16+15:7*16], dat_l0[7*8+7:7*8], dat_l1[6*16+15:6*16], dat_l0[6*8+7:6*8], dat_l1[5*16+15:5*16], dat_l0[5*8+7:5*8], dat_l1[4*16+15:4*16], dat_l0[4*8+7:4*8], dat_l1[3*16+15:3*16], dat_l0[3*8+7:3*8], dat_l1[2*16+15:2*16], dat_l0[2*8+7:2*8], dat_l1[1*16+15:1*16], dat_l0[1*8+7:1*8], dat_l1[0*16+15:0*16], dat_l0[0*8+7:0*8]};
assign dat_16b_yuv = {dat_l1[31*32+31:31*32], dat_l0[31*16+15:31*16], dat_l1[30*32+31:30*32], dat_l0[30*16+15:30*16], dat_l1[29*32+31:29*32], dat_l0[29*16+15:29*16], dat_l1[28*32+31:28*32], dat_l0[28*16+15:28*16], dat_l1[27*32+31:27*32], dat_l0[27*16+15:27*16], dat_l1[26*32+31:26*32], dat_l0[26*16+15:26*16], dat_l1[25*32+31:25*32], dat_l0[25*16+15:25*16], dat_l1[24*32+31:24*32], dat_l0[24*16+15:24*16], dat_l1[23*32+31:23*32], dat_l0[23*16+15:23*16], dat_l1[22*32+31:22*32], dat_l0[22*16+15:22*16], dat_l1[21*32+31:21*32], dat_l0[21*16+15:21*16], dat_l1[20*32+31:20*32], dat_l0[20*16+15:20*16], dat_l1[19*32+31:19*32], dat_l0[19*16+15:19*16], dat_l1[18*32+31:18*32], dat_l0[18*16+15:18*16], dat_l1[17*32+31:17*32], dat_l0[17*16+15:17*16], dat_l1[16*32+31:16*32], dat_l0[16*16+15:16*16], dat_l1[15*32+31:15*32], dat_l0[15*16+15:15*16], dat_l1[14*32+31:14*32], dat_l0[14*16+15:14*16], dat_l1[13*32+31:13*32], dat_l0[13*16+15:13*16], dat_l1[12*32+31:12*32], dat_l0[12*16+15:12*16], dat_l1[11*32+31:11*32], dat_l0[11*16+15:11*16], dat_l1[10*32+31:10*32], dat_l0[10*16+15:10*16], dat_l1[9*32+31:9*32], dat_l0[9*16+15:9*16], dat_l1[8*32+31:8*32], dat_l0[8*16+15:8*16], dat_l1[7*32+31:7*32], dat_l0[7*16+15:7*16], dat_l1[6*32+31:6*32], dat_l0[6*16+15:6*16], dat_l1[5*32+31:5*32], dat_l0[5*16+15:5*16], dat_l1[4*32+31:4*32], dat_l0[4*16+15:4*16], dat_l1[3*32+31:3*32], dat_l0[3*16+15:3*16], dat_l1[2*32+31:2*32], dat_l0[2*16+15:2*16], dat_l1[1*32+31:1*32], dat_l0[1*16+15:1*16], dat_l1[0*32+31:0*32], dat_l0[0*16+15:0*16]};
assign dat_yuv = (pixel_precision == 2'h0) ? dat_8b_yuv : dat_16b_yuv;

always @(
  pixel_packed_10b
  or pixel_planar
  or pk_rsp_wr_cnt
  ) begin
    pk_rsp_out_sel[0] = (pixel_packed_10b);
    pk_rsp_out_sel[1] = (~pixel_planar & ~pixel_packed_10b);
    pk_rsp_out_sel[2] = (pixel_planar & (pk_rsp_wr_cnt == 2'h0));
    pk_rsp_out_sel[3] = (pixel_planar & (pk_rsp_wr_cnt == 2'h1));
    pk_rsp_out_sel[4] = (pixel_planar & (pk_rsp_wr_cnt == 2'h2));
end

always @(
  pk_rsp_dat_mergb
  ) begin
    pk_rsp_data_h1 = pk_rsp_dat_mergb[1023:512];
end

always @(
  pk_rsp_out_sel
  or pk_rsp_dat_mergb
  or pk_rsp_dat_mnorm
  or dat_yuv
  ) begin
    pk_rsp_data_h0 = ({256  *2{pk_rsp_out_sel[0]}} & pk_rsp_dat_mergb[511:0]) |
                     ({256  *2{pk_rsp_out_sel[1]}} & pk_rsp_dat_mnorm) |
                     ({256  *2{pk_rsp_out_sel[2]}} & dat_yuv[511:0]) |
                     ({256  *2{pk_rsp_out_sel[3]}} & dat_yuv[1023:512]) |
                     ({256  *2{pk_rsp_out_sel[4]}} & dat_yuv[1535:1024]);
end

assign pk_rsp_pad_mask_norm = mask_pad;
assign pk_rsp_pad_mask_ergb = {{2{mask_pad[63]}}, {2{mask_pad[62]}}, {2{mask_pad[61]}}, {2{mask_pad[60]}}, {2{mask_pad[59]}}, {2{mask_pad[58]}}, {2{mask_pad[57]}}, {2{mask_pad[56]}}, {2{mask_pad[55]}}, {2{mask_pad[54]}}, {2{mask_pad[53]}}, {2{mask_pad[52]}}, {2{mask_pad[51]}}, {2{mask_pad[50]}}, {2{mask_pad[49]}}, {2{mask_pad[48]}}, {2{mask_pad[47]}}, {2{mask_pad[46]}}, {2{mask_pad[45]}}, {2{mask_pad[44]}}, {2{mask_pad[43]}}, {2{mask_pad[42]}}, {2{mask_pad[41]}}, {2{mask_pad[40]}}, {2{mask_pad[39]}}, {2{mask_pad[38]}}, {2{mask_pad[37]}}, {2{mask_pad[36]}}, {2{mask_pad[35]}}, {2{mask_pad[34]}}, {2{mask_pad[33]}}, {2{mask_pad[32]}}, {2{mask_pad[31]}}, {2{mask_pad[30]}}, {2{mask_pad[29]}}, {2{mask_pad[28]}}, {2{mask_pad[27]}}, {2{mask_pad[26]}}, {2{mask_pad[25]}}, {2{mask_pad[24]}}, {2{mask_pad[23]}}, {2{mask_pad[22]}}, {2{mask_pad[21]}}, {2{mask_pad[20]}}, {2{mask_pad[19]}}, {2{mask_pad[18]}}, {2{mask_pad[17]}}, {2{mask_pad[16]}}, {2{mask_pad[15]}}, {2{mask_pad[14]}}, {2{mask_pad[13]}}, {2{mask_pad[12]}}, {2{mask_pad[11]}}, {2{mask_pad[10]}}, {2{mask_pad[9]}}, {2{mask_pad[8]}}, {2{mask_pad[7]}}, {2{mask_pad[6]}}, {2{mask_pad[5]}}, {2{mask_pad[4]}}, {2{mask_pad[3]}}, {2{mask_pad[2]}}, {2{mask_pad[1]}}, {2{mask_pad[0]}}};

assign pad_mask_l0 = mask_pad_planar0_c0_d1;
assign pad_mask_l1_lo = pk_rsp_planar1_c0_en ? mask_pad :  mask_pad_planar1_c0_d1;
assign pad_mask_l1_hi = pk_rsp_planar1_c1_en ? mask_pad :  mask_pad_planar1_c1_d1;
assign pad_mask_l1 = {pad_mask_l1_hi, pad_mask_l1_lo};

assign pad_mask_8b_yuv = {{pad_mask_l1[63*2+1:63*2], pad_mask_l0[63]}, {pad_mask_l1[62*2+1:62*2], pad_mask_l0[62]}, {pad_mask_l1[61*2+1:61*2], pad_mask_l0[61]}, {pad_mask_l1[60*2+1:60*2], pad_mask_l0[60]}, {pad_mask_l1[59*2+1:59*2], pad_mask_l0[59]}, {pad_mask_l1[58*2+1:58*2], pad_mask_l0[58]}, {pad_mask_l1[57*2+1:57*2], pad_mask_l0[57]}, {pad_mask_l1[56*2+1:56*2], pad_mask_l0[56]}, {pad_mask_l1[55*2+1:55*2], pad_mask_l0[55]}, {pad_mask_l1[54*2+1:54*2], pad_mask_l0[54]}, {pad_mask_l1[53*2+1:53*2], pad_mask_l0[53]}, {pad_mask_l1[52*2+1:52*2], pad_mask_l0[52]}, {pad_mask_l1[51*2+1:51*2], pad_mask_l0[51]}, {pad_mask_l1[50*2+1:50*2], pad_mask_l0[50]}, {pad_mask_l1[49*2+1:49*2], pad_mask_l0[49]}, {pad_mask_l1[48*2+1:48*2], pad_mask_l0[48]}, {pad_mask_l1[47*2+1:47*2], pad_mask_l0[47]}, {pad_mask_l1[46*2+1:46*2], pad_mask_l0[46]}, {pad_mask_l1[45*2+1:45*2], pad_mask_l0[45]}, {pad_mask_l1[44*2+1:44*2], pad_mask_l0[44]}, {pad_mask_l1[43*2+1:43*2], pad_mask_l0[43]}, {pad_mask_l1[42*2+1:42*2], pad_mask_l0[42]}, {pad_mask_l1[41*2+1:41*2], pad_mask_l0[41]}, {pad_mask_l1[40*2+1:40*2], pad_mask_l0[40]}, {pad_mask_l1[39*2+1:39*2], pad_mask_l0[39]}, {pad_mask_l1[38*2+1:38*2], pad_mask_l0[38]}, {pad_mask_l1[37*2+1:37*2], pad_mask_l0[37]}, {pad_mask_l1[36*2+1:36*2], pad_mask_l0[36]}, {pad_mask_l1[35*2+1:35*2], pad_mask_l0[35]}, {pad_mask_l1[34*2+1:34*2], pad_mask_l0[34]}, {pad_mask_l1[33*2+1:33*2], pad_mask_l0[33]}, {pad_mask_l1[32*2+1:32*2], pad_mask_l0[32]}, {pad_mask_l1[31*2+1:31*2], pad_mask_l0[31]}, {pad_mask_l1[30*2+1:30*2], pad_mask_l0[30]}, {pad_mask_l1[29*2+1:29*2], pad_mask_l0[29]}, {pad_mask_l1[28*2+1:28*2], pad_mask_l0[28]}, {pad_mask_l1[27*2+1:27*2], pad_mask_l0[27]}, {pad_mask_l1[26*2+1:26*2], pad_mask_l0[26]}, {pad_mask_l1[25*2+1:25*2], pad_mask_l0[25]}, {pad_mask_l1[24*2+1:24*2], pad_mask_l0[24]}, {pad_mask_l1[23*2+1:23*2], pad_mask_l0[23]}, {pad_mask_l1[22*2+1:22*2], pad_mask_l0[22]}, {pad_mask_l1[21*2+1:21*2], pad_mask_l0[21]}, {pad_mask_l1[20*2+1:20*2], pad_mask_l0[20]}, {pad_mask_l1[19*2+1:19*2], pad_mask_l0[19]}, {pad_mask_l1[18*2+1:18*2], pad_mask_l0[18]}, {pad_mask_l1[17*2+1:17*2], pad_mask_l0[17]}, {pad_mask_l1[16*2+1:16*2], pad_mask_l0[16]}, {pad_mask_l1[15*2+1:15*2], pad_mask_l0[15]}, {pad_mask_l1[14*2+1:14*2], pad_mask_l0[14]}, {pad_mask_l1[13*2+1:13*2], pad_mask_l0[13]}, {pad_mask_l1[12*2+1:12*2], pad_mask_l0[12]}, {pad_mask_l1[11*2+1:11*2], pad_mask_l0[11]}, {pad_mask_l1[10*2+1:10*2], pad_mask_l0[10]}, {pad_mask_l1[9*2+1:9*2], pad_mask_l0[9]}, {pad_mask_l1[8*2+1:8*2], pad_mask_l0[8]}, {pad_mask_l1[7*2+1:7*2], pad_mask_l0[7]}, {pad_mask_l1[6*2+1:6*2], pad_mask_l0[6]}, {pad_mask_l1[5*2+1:5*2], pad_mask_l0[5]}, {pad_mask_l1[4*2+1:4*2], pad_mask_l0[4]}, {pad_mask_l1[3*2+1:3*2], pad_mask_l0[3]}, {pad_mask_l1[2*2+1:2*2], pad_mask_l0[2]}, {pad_mask_l1[1*2+1:1*2], pad_mask_l0[1]}, {pad_mask_l1[0*2+1:0*2], pad_mask_l0[0]}};
assign pad_mask_16b_yuv = {{pad_mask_l1[31*4+3:31*4], pad_mask_l0[31*2+1:31*2]}, {pad_mask_l1[30*4+3:30*4], pad_mask_l0[30*2+1:30*2]}, {pad_mask_l1[29*4+3:29*4], pad_mask_l0[29*2+1:29*2]}, {pad_mask_l1[28*4+3:28*4], pad_mask_l0[28*2+1:28*2]}, {pad_mask_l1[27*4+3:27*4], pad_mask_l0[27*2+1:27*2]}, {pad_mask_l1[26*4+3:26*4], pad_mask_l0[26*2+1:26*2]}, {pad_mask_l1[25*4+3:25*4], pad_mask_l0[25*2+1:25*2]}, {pad_mask_l1[24*4+3:24*4], pad_mask_l0[24*2+1:24*2]}, {pad_mask_l1[23*4+3:23*4], pad_mask_l0[23*2+1:23*2]}, {pad_mask_l1[22*4+3:22*4], pad_mask_l0[22*2+1:22*2]}, {pad_mask_l1[21*4+3:21*4], pad_mask_l0[21*2+1:21*2]}, {pad_mask_l1[20*4+3:20*4], pad_mask_l0[20*2+1:20*2]}, {pad_mask_l1[19*4+3:19*4], pad_mask_l0[19*2+1:19*2]}, {pad_mask_l1[18*4+3:18*4], pad_mask_l0[18*2+1:18*2]}, {pad_mask_l1[17*4+3:17*4], pad_mask_l0[17*2+1:17*2]}, {pad_mask_l1[16*4+3:16*4], pad_mask_l0[16*2+1:16*2]}, {pad_mask_l1[15*4+3:15*4], pad_mask_l0[15*2+1:15*2]}, {pad_mask_l1[14*4+3:14*4], pad_mask_l0[14*2+1:14*2]}, {pad_mask_l1[13*4+3:13*4], pad_mask_l0[13*2+1:13*2]}, {pad_mask_l1[12*4+3:12*4], pad_mask_l0[12*2+1:12*2]}, {pad_mask_l1[11*4+3:11*4], pad_mask_l0[11*2+1:11*2]}, {pad_mask_l1[10*4+3:10*4], pad_mask_l0[10*2+1:10*2]}, {pad_mask_l1[9*4+3:9*4], pad_mask_l0[9*2+1:9*2]}, {pad_mask_l1[8*4+3:8*4], pad_mask_l0[8*2+1:8*2]}, {pad_mask_l1[7*4+3:7*4], pad_mask_l0[7*2+1:7*2]}, {pad_mask_l1[6*4+3:6*4], pad_mask_l0[6*2+1:6*2]}, {pad_mask_l1[5*4+3:5*4], pad_mask_l0[5*2+1:5*2]}, {pad_mask_l1[4*4+3:4*4], pad_mask_l0[4*2+1:4*2]}, {pad_mask_l1[3*4+3:3*4], pad_mask_l0[3*2+1:3*2]}, {pad_mask_l1[2*4+3:2*4], pad_mask_l0[2*2+1:2*2]}, {pad_mask_l1[1*4+3:1*4], pad_mask_l0[1*2+1:1*2]}, {pad_mask_l1[0*4+3:0*4], pad_mask_l0[0*2+1:0*2]}};
assign pad_mask_yuv = (pixel_precision == 2'h0) ? pad_mask_8b_yuv : pad_mask_16b_yuv;

always @(
  pixel_packed_10b
  or pk_rsp_pad_mask_ergb
  ) begin
    pk_rsp_pad_mask_h1 = pixel_packed_10b ? pk_rsp_pad_mask_ergb[127:64] : 64'b0;
end

always @(
  pk_rsp_out_sel
  or pk_rsp_pad_mask_ergb
  or pk_rsp_pad_mask_norm
  or pad_mask_yuv
  ) begin
    pk_rsp_pad_mask_h0 = ({64{pk_rsp_out_sel[0]}} & pk_rsp_pad_mask_ergb[63:0]) |
                         ({64{pk_rsp_out_sel[1]}} & pk_rsp_pad_mask_norm) |
                         ({64{pk_rsp_out_sel[2]}} & pad_mask_yuv[63:0]) |
                         ({64{pk_rsp_out_sel[3]}} & pad_mask_yuv[127:64]) |
                         ({64{pk_rsp_out_sel[4]}} & pad_mask_yuv[191:128]);
end

assign pk_rsp_planar0_c0_en = (pk_rsp_vld & pixel_planar & ~pk_rsp_planar);
assign pk_rsp_planar1_c0_en = (pk_rsp_vld & pixel_planar & pk_rsp_planar & (pk_rsp_wr_cnt == 2'h0));
assign pk_rsp_planar1_c1_en = (pk_rsp_vld & pixel_planar & pk_rsp_planar & (pk_rsp_wr_cnt == 2'h1));
assign pk_rsp_data_h0_en = pk_rsp_wr_vld;
assign pk_rsp_data_h1_en = pk_rsp_wr_vld & pixel_packed_10b;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pk_rsp_planar0_c0_d1 <= {512{1'b0}};
  end else begin
  if ((pk_rsp_planar0_c0_en) == 1'b1) begin
    pk_rsp_planar0_c0_d1 <= pk_rsp_dat_mnorm;
  // VCS coverage off
  end else if ((pk_rsp_planar0_c0_en) == 1'b0) begin
  end else begin
    pk_rsp_planar0_c0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_82x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_planar0_c0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_rsp_planar1_c0_d1 <= {512{1'b0}};
  end else begin
  if ((pk_rsp_planar1_c0_en) == 1'b1) begin
    pk_rsp_planar1_c0_d1 <= pk_rsp_dat_mnorm;
  // VCS coverage off
  end else if ((pk_rsp_planar1_c0_en) == 1'b0) begin
  end else begin
    pk_rsp_planar1_c0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_83x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_planar1_c0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_rsp_planar1_c1_d1 <= {512{1'b0}};
  end else begin
  if ((pk_rsp_planar1_c1_en) == 1'b1) begin
    pk_rsp_planar1_c1_d1 <= pk_rsp_dat_mnorm;
  // VCS coverage off
  end else if ((pk_rsp_planar1_c1_en) == 1'b0) begin
  end else begin
    pk_rsp_planar1_c1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_84x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_planar1_c1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mask_pad_planar0_c0_d1 <= {64{1'b0}};
  end else begin
  if ((pk_rsp_planar0_c0_en) == 1'b1) begin
    mask_pad_planar0_c0_d1 <= mask_pad;
  // VCS coverage off
  end else if ((pk_rsp_planar0_c0_en) == 1'b0) begin
  end else begin
    mask_pad_planar0_c0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_85x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_planar0_c0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mask_pad_planar1_c0_d1 <= {64{1'b0}};
  end else begin
  if ((pk_rsp_planar1_c0_en) == 1'b1) begin
    mask_pad_planar1_c0_d1 <= mask_pad;
  // VCS coverage off
  end else if ((pk_rsp_planar1_c0_en) == 1'b0) begin
  end else begin
    mask_pad_planar1_c0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_86x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_planar1_c0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mask_pad_planar1_c1_d1 <= {64{1'b0}};
  end else begin
  if ((pk_rsp_planar1_c1_en) == 1'b1) begin
    mask_pad_planar1_c1_d1 <= mask_pad;
  // VCS coverage off
  end else if ((pk_rsp_planar1_c1_en) == 1'b0) begin
  end else begin
    mask_pad_planar1_c1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_87x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_planar1_c1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  if ((pk_rsp_data_h1_en) == 1'b1) begin
    pk_out_data_h1 <= pk_rsp_data_h1;
  // VCS coverage off
  end else if ((pk_rsp_data_h1_en) == 1'b0) begin
  end else begin
    pk_out_data_h1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pk_rsp_data_h0_en) == 1'b1) begin
    pk_out_data_h0 <= pk_rsp_data_h0;
  // VCS coverage off
  end else if ((pk_rsp_data_h0_en) == 1'b0) begin
  end else begin
    pk_out_data_h0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pk_out_pad_mask_h1 <= {64{1'b0}};
  end else begin
  if ((pk_rsp_data_h1_en | is_first_running) == 1'b1) begin
    pk_out_pad_mask_h1 <= pk_rsp_pad_mask_h1;
  // VCS coverage off
  end else if ((pk_rsp_data_h1_en | is_first_running) == 1'b0) begin
  end else begin
    pk_out_pad_mask_h1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_88x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_data_h1_en | is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_out_pad_mask_h0 <= {64{1'b0}};
  end else begin
  if ((pk_rsp_data_h0_en) == 1'b1) begin
    pk_out_pad_mask_h0 <= pk_rsp_pad_mask_h0;
  // VCS coverage off
  end else if ((pk_rsp_data_h0_en) == 1'b0) begin
  end else begin
    pk_out_pad_mask_h0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_89x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_data_h0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign pk_out_data = {pk_out_data_h1, pk_out_data_h0};
assign pk_out_pad_mask = {pk_out_pad_mask_h1, pk_out_pad_mask_h0};

////////////////////////////////////////////////////////////////////////
// mean data replacement and output logic                             //
////////////////////////////////////////////////////////////////////////

assign mn_mask_y = mn_mask_y_d1;
assign mn_mask_uv_lo = mn_mask_uv_0_en ? mask_zero : mn_mask_uv_lo_d1;
assign mn_mask_uv_hi = mn_mask_uv_1_en ? mask_zero : mn_mask_uv_hi_d1;
assign mn_mask_uv = {mn_mask_uv_hi, mn_mask_uv_lo};
assign mn_mask_yuv = {mn_mask_uv[31*4+3:31*4], mn_mask_y[31*2+1:31*2], mn_mask_uv[30*4+3:30*4], mn_mask_y[30*2+1:30*2], mn_mask_uv[29*4+3:29*4], mn_mask_y[29*2+1:29*2], mn_mask_uv[28*4+3:28*4], mn_mask_y[28*2+1:28*2], mn_mask_uv[27*4+3:27*4], mn_mask_y[27*2+1:27*2], mn_mask_uv[26*4+3:26*4], mn_mask_y[26*2+1:26*2], mn_mask_uv[25*4+3:25*4], mn_mask_y[25*2+1:25*2], mn_mask_uv[24*4+3:24*4], mn_mask_y[24*2+1:24*2], mn_mask_uv[23*4+3:23*4], mn_mask_y[23*2+1:23*2], mn_mask_uv[22*4+3:22*4], mn_mask_y[22*2+1:22*2], mn_mask_uv[21*4+3:21*4], mn_mask_y[21*2+1:21*2], mn_mask_uv[20*4+3:20*4], mn_mask_y[20*2+1:20*2], mn_mask_uv[19*4+3:19*4], mn_mask_y[19*2+1:19*2], mn_mask_uv[18*4+3:18*4], mn_mask_y[18*2+1:18*2], mn_mask_uv[17*4+3:17*4], mn_mask_y[17*2+1:17*2], mn_mask_uv[16*4+3:16*4], mn_mask_y[16*2+1:16*2], mn_mask_uv[15*4+3:15*4], mn_mask_y[15*2+1:15*2], mn_mask_uv[14*4+3:14*4], mn_mask_y[14*2+1:14*2], mn_mask_uv[13*4+3:13*4], mn_mask_y[13*2+1:13*2], mn_mask_uv[12*4+3:12*4], mn_mask_y[12*2+1:12*2], mn_mask_uv[11*4+3:11*4], mn_mask_y[11*2+1:11*2], mn_mask_uv[10*4+3:10*4], mn_mask_y[10*2+1:10*2], mn_mask_uv[9*4+3:9*4], mn_mask_y[9*2+1:9*2], mn_mask_uv[8*4+3:8*4], mn_mask_y[8*2+1:8*2], mn_mask_uv[7*4+3:7*4], mn_mask_y[7*2+1:7*2], mn_mask_uv[6*4+3:6*4], mn_mask_y[6*2+1:6*2], mn_mask_uv[5*4+3:5*4], mn_mask_y[5*2+1:5*2], mn_mask_uv[4*4+3:4*4], mn_mask_y[4*2+1:4*2], mn_mask_uv[3*4+3:3*4], mn_mask_y[3*2+1:3*2], mn_mask_uv[2*4+3:2*4], mn_mask_y[2*2+1:2*2], mn_mask_uv[1*4+3:1*4], mn_mask_y[1*2+1:1*2], mn_mask_uv[0*4+3:0*4], mn_mask_y[0*2+1:0*2]};

assign mn_ch1 = {64{reg2dp_mean_ry}};
assign mn_ch4 = {16{reg2dp_mean_ax, reg2dp_mean_bv, reg2dp_mean_gu, reg2dp_mean_ry}};
assign mn_ch3 = {64{reg2dp_mean_bv, reg2dp_mean_gu, reg2dp_mean_ry}};
assign mn_ch1_4 = ~(|reg2dp_datain_channel) ? mn_ch1 : mn_ch4;

always @(
  mask_zero
  or mn_ch1_4
  ) begin
mn_8b_mnorm[0*16+15:0*16] = mask_zero[0] ? 16'b0 : mn_ch1_4[0*16+15:0*16];
mn_8b_mnorm[1*16+15:1*16] = mask_zero[1] ? 16'b0 : mn_ch1_4[1*16+15:1*16];
mn_8b_mnorm[2*16+15:2*16] = mask_zero[2] ? 16'b0 : mn_ch1_4[2*16+15:2*16];
mn_8b_mnorm[3*16+15:3*16] = mask_zero[3] ? 16'b0 : mn_ch1_4[3*16+15:3*16];
mn_8b_mnorm[4*16+15:4*16] = mask_zero[4] ? 16'b0 : mn_ch1_4[4*16+15:4*16];
mn_8b_mnorm[5*16+15:5*16] = mask_zero[5] ? 16'b0 : mn_ch1_4[5*16+15:5*16];
mn_8b_mnorm[6*16+15:6*16] = mask_zero[6] ? 16'b0 : mn_ch1_4[6*16+15:6*16];
mn_8b_mnorm[7*16+15:7*16] = mask_zero[7] ? 16'b0 : mn_ch1_4[7*16+15:7*16];
mn_8b_mnorm[8*16+15:8*16] = mask_zero[8] ? 16'b0 : mn_ch1_4[8*16+15:8*16];
mn_8b_mnorm[9*16+15:9*16] = mask_zero[9] ? 16'b0 : mn_ch1_4[9*16+15:9*16];
mn_8b_mnorm[10*16+15:10*16] = mask_zero[10] ? 16'b0 : mn_ch1_4[10*16+15:10*16];
mn_8b_mnorm[11*16+15:11*16] = mask_zero[11] ? 16'b0 : mn_ch1_4[11*16+15:11*16];
mn_8b_mnorm[12*16+15:12*16] = mask_zero[12] ? 16'b0 : mn_ch1_4[12*16+15:12*16];
mn_8b_mnorm[13*16+15:13*16] = mask_zero[13] ? 16'b0 : mn_ch1_4[13*16+15:13*16];
mn_8b_mnorm[14*16+15:14*16] = mask_zero[14] ? 16'b0 : mn_ch1_4[14*16+15:14*16];
mn_8b_mnorm[15*16+15:15*16] = mask_zero[15] ? 16'b0 : mn_ch1_4[15*16+15:15*16];
mn_8b_mnorm[16*16+15:16*16] = mask_zero[16] ? 16'b0 : mn_ch1_4[16*16+15:16*16];
mn_8b_mnorm[17*16+15:17*16] = mask_zero[17] ? 16'b0 : mn_ch1_4[17*16+15:17*16];
mn_8b_mnorm[18*16+15:18*16] = mask_zero[18] ? 16'b0 : mn_ch1_4[18*16+15:18*16];
mn_8b_mnorm[19*16+15:19*16] = mask_zero[19] ? 16'b0 : mn_ch1_4[19*16+15:19*16];
mn_8b_mnorm[20*16+15:20*16] = mask_zero[20] ? 16'b0 : mn_ch1_4[20*16+15:20*16];
mn_8b_mnorm[21*16+15:21*16] = mask_zero[21] ? 16'b0 : mn_ch1_4[21*16+15:21*16];
mn_8b_mnorm[22*16+15:22*16] = mask_zero[22] ? 16'b0 : mn_ch1_4[22*16+15:22*16];
mn_8b_mnorm[23*16+15:23*16] = mask_zero[23] ? 16'b0 : mn_ch1_4[23*16+15:23*16];
mn_8b_mnorm[24*16+15:24*16] = mask_zero[24] ? 16'b0 : mn_ch1_4[24*16+15:24*16];
mn_8b_mnorm[25*16+15:25*16] = mask_zero[25] ? 16'b0 : mn_ch1_4[25*16+15:25*16];
mn_8b_mnorm[26*16+15:26*16] = mask_zero[26] ? 16'b0 : mn_ch1_4[26*16+15:26*16];
mn_8b_mnorm[27*16+15:27*16] = mask_zero[27] ? 16'b0 : mn_ch1_4[27*16+15:27*16];
mn_8b_mnorm[28*16+15:28*16] = mask_zero[28] ? 16'b0 : mn_ch1_4[28*16+15:28*16];
mn_8b_mnorm[29*16+15:29*16] = mask_zero[29] ? 16'b0 : mn_ch1_4[29*16+15:29*16];
mn_8b_mnorm[30*16+15:30*16] = mask_zero[30] ? 16'b0 : mn_ch1_4[30*16+15:30*16];
mn_8b_mnorm[31*16+15:31*16] = mask_zero[31] ? 16'b0 : mn_ch1_4[31*16+15:31*16];
mn_8b_mnorm[32*16+15:32*16] = mask_zero[32] ? 16'b0 : mn_ch1_4[32*16+15:32*16];
mn_8b_mnorm[33*16+15:33*16] = mask_zero[33] ? 16'b0 : mn_ch1_4[33*16+15:33*16];
mn_8b_mnorm[34*16+15:34*16] = mask_zero[34] ? 16'b0 : mn_ch1_4[34*16+15:34*16];
mn_8b_mnorm[35*16+15:35*16] = mask_zero[35] ? 16'b0 : mn_ch1_4[35*16+15:35*16];
mn_8b_mnorm[36*16+15:36*16] = mask_zero[36] ? 16'b0 : mn_ch1_4[36*16+15:36*16];
mn_8b_mnorm[37*16+15:37*16] = mask_zero[37] ? 16'b0 : mn_ch1_4[37*16+15:37*16];
mn_8b_mnorm[38*16+15:38*16] = mask_zero[38] ? 16'b0 : mn_ch1_4[38*16+15:38*16];
mn_8b_mnorm[39*16+15:39*16] = mask_zero[39] ? 16'b0 : mn_ch1_4[39*16+15:39*16];
mn_8b_mnorm[40*16+15:40*16] = mask_zero[40] ? 16'b0 : mn_ch1_4[40*16+15:40*16];
mn_8b_mnorm[41*16+15:41*16] = mask_zero[41] ? 16'b0 : mn_ch1_4[41*16+15:41*16];
mn_8b_mnorm[42*16+15:42*16] = mask_zero[42] ? 16'b0 : mn_ch1_4[42*16+15:42*16];
mn_8b_mnorm[43*16+15:43*16] = mask_zero[43] ? 16'b0 : mn_ch1_4[43*16+15:43*16];
mn_8b_mnorm[44*16+15:44*16] = mask_zero[44] ? 16'b0 : mn_ch1_4[44*16+15:44*16];
mn_8b_mnorm[45*16+15:45*16] = mask_zero[45] ? 16'b0 : mn_ch1_4[45*16+15:45*16];
mn_8b_mnorm[46*16+15:46*16] = mask_zero[46] ? 16'b0 : mn_ch1_4[46*16+15:46*16];
mn_8b_mnorm[47*16+15:47*16] = mask_zero[47] ? 16'b0 : mn_ch1_4[47*16+15:47*16];
mn_8b_mnorm[48*16+15:48*16] = mask_zero[48] ? 16'b0 : mn_ch1_4[48*16+15:48*16];
mn_8b_mnorm[49*16+15:49*16] = mask_zero[49] ? 16'b0 : mn_ch1_4[49*16+15:49*16];
mn_8b_mnorm[50*16+15:50*16] = mask_zero[50] ? 16'b0 : mn_ch1_4[50*16+15:50*16];
mn_8b_mnorm[51*16+15:51*16] = mask_zero[51] ? 16'b0 : mn_ch1_4[51*16+15:51*16];
mn_8b_mnorm[52*16+15:52*16] = mask_zero[52] ? 16'b0 : mn_ch1_4[52*16+15:52*16];
mn_8b_mnorm[53*16+15:53*16] = mask_zero[53] ? 16'b0 : mn_ch1_4[53*16+15:53*16];
mn_8b_mnorm[54*16+15:54*16] = mask_zero[54] ? 16'b0 : mn_ch1_4[54*16+15:54*16];
mn_8b_mnorm[55*16+15:55*16] = mask_zero[55] ? 16'b0 : mn_ch1_4[55*16+15:55*16];
mn_8b_mnorm[56*16+15:56*16] = mask_zero[56] ? 16'b0 : mn_ch1_4[56*16+15:56*16];
mn_8b_mnorm[57*16+15:57*16] = mask_zero[57] ? 16'b0 : mn_ch1_4[57*16+15:57*16];
mn_8b_mnorm[58*16+15:58*16] = mask_zero[58] ? 16'b0 : mn_ch1_4[58*16+15:58*16];
mn_8b_mnorm[59*16+15:59*16] = mask_zero[59] ? 16'b0 : mn_ch1_4[59*16+15:59*16];
mn_8b_mnorm[60*16+15:60*16] = mask_zero[60] ? 16'b0 : mn_ch1_4[60*16+15:60*16];
mn_8b_mnorm[61*16+15:61*16] = mask_zero[61] ? 16'b0 : mn_ch1_4[61*16+15:61*16];
mn_8b_mnorm[62*16+15:62*16] = mask_zero[62] ? 16'b0 : mn_ch1_4[62*16+15:62*16];
mn_8b_mnorm[63*16+15:63*16] = mask_zero[63] ? 16'b0 : mn_ch1_4[63*16+15:63*16];
end


always @(
  mask_zero
  or mn_ch1_4
  ) begin
mn_16b_mnorm[0*16+15:0*16] = mask_zero[0] ? 16'b0 : mn_ch1_4[0*16+15:0*16];
mn_16b_mnorm[1*16+15:1*16] = mask_zero[2] ? 16'b0 : mn_ch1_4[1*16+15:1*16];
mn_16b_mnorm[2*16+15:2*16] = mask_zero[4] ? 16'b0 : mn_ch1_4[2*16+15:2*16];
mn_16b_mnorm[3*16+15:3*16] = mask_zero[6] ? 16'b0 : mn_ch1_4[3*16+15:3*16];
mn_16b_mnorm[4*16+15:4*16] = mask_zero[8] ? 16'b0 : mn_ch1_4[4*16+15:4*16];
mn_16b_mnorm[5*16+15:5*16] = mask_zero[10] ? 16'b0 : mn_ch1_4[5*16+15:5*16];
mn_16b_mnorm[6*16+15:6*16] = mask_zero[12] ? 16'b0 : mn_ch1_4[6*16+15:6*16];
mn_16b_mnorm[7*16+15:7*16] = mask_zero[14] ? 16'b0 : mn_ch1_4[7*16+15:7*16];
mn_16b_mnorm[8*16+15:8*16] = mask_zero[16] ? 16'b0 : mn_ch1_4[8*16+15:8*16];
mn_16b_mnorm[9*16+15:9*16] = mask_zero[18] ? 16'b0 : mn_ch1_4[9*16+15:9*16];
mn_16b_mnorm[10*16+15:10*16] = mask_zero[20] ? 16'b0 : mn_ch1_4[10*16+15:10*16];
mn_16b_mnorm[11*16+15:11*16] = mask_zero[22] ? 16'b0 : mn_ch1_4[11*16+15:11*16];
mn_16b_mnorm[12*16+15:12*16] = mask_zero[24] ? 16'b0 : mn_ch1_4[12*16+15:12*16];
mn_16b_mnorm[13*16+15:13*16] = mask_zero[26] ? 16'b0 : mn_ch1_4[13*16+15:13*16];
mn_16b_mnorm[14*16+15:14*16] = mask_zero[28] ? 16'b0 : mn_ch1_4[14*16+15:14*16];
mn_16b_mnorm[15*16+15:15*16] = mask_zero[30] ? 16'b0 : mn_ch1_4[15*16+15:15*16];
mn_16b_mnorm[16*16+15:16*16] = mask_zero[32] ? 16'b0 : mn_ch1_4[16*16+15:16*16];
mn_16b_mnorm[17*16+15:17*16] = mask_zero[34] ? 16'b0 : mn_ch1_4[17*16+15:17*16];
mn_16b_mnorm[18*16+15:18*16] = mask_zero[36] ? 16'b0 : mn_ch1_4[18*16+15:18*16];
mn_16b_mnorm[19*16+15:19*16] = mask_zero[38] ? 16'b0 : mn_ch1_4[19*16+15:19*16];
mn_16b_mnorm[20*16+15:20*16] = mask_zero[40] ? 16'b0 : mn_ch1_4[20*16+15:20*16];
mn_16b_mnorm[21*16+15:21*16] = mask_zero[42] ? 16'b0 : mn_ch1_4[21*16+15:21*16];
mn_16b_mnorm[22*16+15:22*16] = mask_zero[44] ? 16'b0 : mn_ch1_4[22*16+15:22*16];
mn_16b_mnorm[23*16+15:23*16] = mask_zero[46] ? 16'b0 : mn_ch1_4[23*16+15:23*16];
mn_16b_mnorm[24*16+15:24*16] = mask_zero[48] ? 16'b0 : mn_ch1_4[24*16+15:24*16];
mn_16b_mnorm[25*16+15:25*16] = mask_zero[50] ? 16'b0 : mn_ch1_4[25*16+15:25*16];
mn_16b_mnorm[26*16+15:26*16] = mask_zero[52] ? 16'b0 : mn_ch1_4[26*16+15:26*16];
mn_16b_mnorm[27*16+15:27*16] = mask_zero[54] ? 16'b0 : mn_ch1_4[27*16+15:27*16];
mn_16b_mnorm[28*16+15:28*16] = mask_zero[56] ? 16'b0 : mn_ch1_4[28*16+15:28*16];
mn_16b_mnorm[29*16+15:29*16] = mask_zero[58] ? 16'b0 : mn_ch1_4[29*16+15:29*16];
mn_16b_mnorm[30*16+15:30*16] = mask_zero[60] ? 16'b0 : mn_ch1_4[30*16+15:30*16];
mn_16b_mnorm[31*16+15:31*16] = mask_zero[62] ? 16'b0 : mn_ch1_4[31*16+15:31*16];
end


always @(
  mn_mask_yuv
  or mn_ch3
  ) begin
mn_8b_myuv[0*48+47:0*48] = mn_mask_yuv[0] ? 48'b0 : mn_ch3[0*48+47:0*48];
mn_8b_myuv[1*48+47:1*48] = mn_mask_yuv[1] ? 48'b0 : mn_ch3[1*48+47:1*48];
mn_8b_myuv[2*48+47:2*48] = mn_mask_yuv[2] ? 48'b0 : mn_ch3[2*48+47:2*48];
mn_8b_myuv[3*48+47:3*48] = mn_mask_yuv[3] ? 48'b0 : mn_ch3[3*48+47:3*48];
mn_8b_myuv[4*48+47:4*48] = mn_mask_yuv[4] ? 48'b0 : mn_ch3[4*48+47:4*48];
mn_8b_myuv[5*48+47:5*48] = mn_mask_yuv[5] ? 48'b0 : mn_ch3[5*48+47:5*48];
mn_8b_myuv[6*48+47:6*48] = mn_mask_yuv[6] ? 48'b0 : mn_ch3[6*48+47:6*48];
mn_8b_myuv[7*48+47:7*48] = mn_mask_yuv[7] ? 48'b0 : mn_ch3[7*48+47:7*48];
mn_8b_myuv[8*48+47:8*48] = mn_mask_yuv[8] ? 48'b0 : mn_ch3[8*48+47:8*48];
mn_8b_myuv[9*48+47:9*48] = mn_mask_yuv[9] ? 48'b0 : mn_ch3[9*48+47:9*48];
mn_8b_myuv[10*48+47:10*48] = mn_mask_yuv[10] ? 48'b0 : mn_ch3[10*48+47:10*48];
mn_8b_myuv[11*48+47:11*48] = mn_mask_yuv[11] ? 48'b0 : mn_ch3[11*48+47:11*48];
mn_8b_myuv[12*48+47:12*48] = mn_mask_yuv[12] ? 48'b0 : mn_ch3[12*48+47:12*48];
mn_8b_myuv[13*48+47:13*48] = mn_mask_yuv[13] ? 48'b0 : mn_ch3[13*48+47:13*48];
mn_8b_myuv[14*48+47:14*48] = mn_mask_yuv[14] ? 48'b0 : mn_ch3[14*48+47:14*48];
mn_8b_myuv[15*48+47:15*48] = mn_mask_yuv[15] ? 48'b0 : mn_ch3[15*48+47:15*48];
mn_8b_myuv[16*48+47:16*48] = mn_mask_yuv[16] ? 48'b0 : mn_ch3[16*48+47:16*48];
mn_8b_myuv[17*48+47:17*48] = mn_mask_yuv[17] ? 48'b0 : mn_ch3[17*48+47:17*48];
mn_8b_myuv[18*48+47:18*48] = mn_mask_yuv[18] ? 48'b0 : mn_ch3[18*48+47:18*48];
mn_8b_myuv[19*48+47:19*48] = mn_mask_yuv[19] ? 48'b0 : mn_ch3[19*48+47:19*48];
mn_8b_myuv[20*48+47:20*48] = mn_mask_yuv[20] ? 48'b0 : mn_ch3[20*48+47:20*48];
mn_8b_myuv[21*48+47:21*48] = mn_mask_yuv[21] ? 48'b0 : mn_ch3[21*48+47:21*48];
mn_8b_myuv[22*48+47:22*48] = mn_mask_yuv[22] ? 48'b0 : mn_ch3[22*48+47:22*48];
mn_8b_myuv[23*48+47:23*48] = mn_mask_yuv[23] ? 48'b0 : mn_ch3[23*48+47:23*48];
mn_8b_myuv[24*48+47:24*48] = mn_mask_yuv[24] ? 48'b0 : mn_ch3[24*48+47:24*48];
mn_8b_myuv[25*48+47:25*48] = mn_mask_yuv[25] ? 48'b0 : mn_ch3[25*48+47:25*48];
mn_8b_myuv[26*48+47:26*48] = mn_mask_yuv[26] ? 48'b0 : mn_ch3[26*48+47:26*48];
mn_8b_myuv[27*48+47:27*48] = mn_mask_yuv[27] ? 48'b0 : mn_ch3[27*48+47:27*48];
mn_8b_myuv[28*48+47:28*48] = mn_mask_yuv[28] ? 48'b0 : mn_ch3[28*48+47:28*48];
mn_8b_myuv[29*48+47:29*48] = mn_mask_yuv[29] ? 48'b0 : mn_ch3[29*48+47:29*48];
mn_8b_myuv[30*48+47:30*48] = mn_mask_yuv[30] ? 48'b0 : mn_ch3[30*48+47:30*48];
mn_8b_myuv[31*48+47:31*48] = mn_mask_yuv[31] ? 48'b0 : mn_ch3[31*48+47:31*48];
mn_8b_myuv[32*48+47:32*48] = mn_mask_yuv[32] ? 48'b0 : mn_ch3[32*48+47:32*48];
mn_8b_myuv[33*48+47:33*48] = mn_mask_yuv[33] ? 48'b0 : mn_ch3[33*48+47:33*48];
mn_8b_myuv[34*48+47:34*48] = mn_mask_yuv[34] ? 48'b0 : mn_ch3[34*48+47:34*48];
mn_8b_myuv[35*48+47:35*48] = mn_mask_yuv[35] ? 48'b0 : mn_ch3[35*48+47:35*48];
mn_8b_myuv[36*48+47:36*48] = mn_mask_yuv[36] ? 48'b0 : mn_ch3[36*48+47:36*48];
mn_8b_myuv[37*48+47:37*48] = mn_mask_yuv[37] ? 48'b0 : mn_ch3[37*48+47:37*48];
mn_8b_myuv[38*48+47:38*48] = mn_mask_yuv[38] ? 48'b0 : mn_ch3[38*48+47:38*48];
mn_8b_myuv[39*48+47:39*48] = mn_mask_yuv[39] ? 48'b0 : mn_ch3[39*48+47:39*48];
mn_8b_myuv[40*48+47:40*48] = mn_mask_yuv[40] ? 48'b0 : mn_ch3[40*48+47:40*48];
mn_8b_myuv[41*48+47:41*48] = mn_mask_yuv[41] ? 48'b0 : mn_ch3[41*48+47:41*48];
mn_8b_myuv[42*48+47:42*48] = mn_mask_yuv[42] ? 48'b0 : mn_ch3[42*48+47:42*48];
mn_8b_myuv[43*48+47:43*48] = mn_mask_yuv[43] ? 48'b0 : mn_ch3[43*48+47:43*48];
mn_8b_myuv[44*48+47:44*48] = mn_mask_yuv[44] ? 48'b0 : mn_ch3[44*48+47:44*48];
mn_8b_myuv[45*48+47:45*48] = mn_mask_yuv[45] ? 48'b0 : mn_ch3[45*48+47:45*48];
mn_8b_myuv[46*48+47:46*48] = mn_mask_yuv[46] ? 48'b0 : mn_ch3[46*48+47:46*48];
mn_8b_myuv[47*48+47:47*48] = mn_mask_yuv[47] ? 48'b0 : mn_ch3[47*48+47:47*48];
mn_8b_myuv[48*48+47:48*48] = mn_mask_yuv[48] ? 48'b0 : mn_ch3[48*48+47:48*48];
mn_8b_myuv[49*48+47:49*48] = mn_mask_yuv[49] ? 48'b0 : mn_ch3[49*48+47:49*48];
mn_8b_myuv[50*48+47:50*48] = mn_mask_yuv[50] ? 48'b0 : mn_ch3[50*48+47:50*48];
mn_8b_myuv[51*48+47:51*48] = mn_mask_yuv[51] ? 48'b0 : mn_ch3[51*48+47:51*48];
mn_8b_myuv[52*48+47:52*48] = mn_mask_yuv[52] ? 48'b0 : mn_ch3[52*48+47:52*48];
mn_8b_myuv[53*48+47:53*48] = mn_mask_yuv[53] ? 48'b0 : mn_ch3[53*48+47:53*48];
mn_8b_myuv[54*48+47:54*48] = mn_mask_yuv[54] ? 48'b0 : mn_ch3[54*48+47:54*48];
mn_8b_myuv[55*48+47:55*48] = mn_mask_yuv[55] ? 48'b0 : mn_ch3[55*48+47:55*48];
mn_8b_myuv[56*48+47:56*48] = mn_mask_yuv[56] ? 48'b0 : mn_ch3[56*48+47:56*48];
mn_8b_myuv[57*48+47:57*48] = mn_mask_yuv[57] ? 48'b0 : mn_ch3[57*48+47:57*48];
mn_8b_myuv[58*48+47:58*48] = mn_mask_yuv[58] ? 48'b0 : mn_ch3[58*48+47:58*48];
mn_8b_myuv[59*48+47:59*48] = mn_mask_yuv[59] ? 48'b0 : mn_ch3[59*48+47:59*48];
mn_8b_myuv[60*48+47:60*48] = mn_mask_yuv[60] ? 48'b0 : mn_ch3[60*48+47:60*48];
mn_8b_myuv[61*48+47:61*48] = mn_mask_yuv[61] ? 48'b0 : mn_ch3[61*48+47:61*48];
mn_8b_myuv[62*48+47:62*48] = mn_mask_yuv[62] ? 48'b0 : mn_ch3[62*48+47:62*48];
mn_8b_myuv[63*48+47:63*48] = mn_mask_yuv[63] ? 48'b0 : mn_ch3[63*48+47:63*48];
end


always @(
  mn_mask_yuv
  or mn_ch3
  ) begin
mn_16b_myuv[0*48+47:0*48] = mn_mask_yuv[0] ? 48'b0 : mn_ch3[0*48+47:0*48];
mn_16b_myuv[1*48+47:1*48] = mn_mask_yuv[2] ? 48'b0 : mn_ch3[1*48+47:1*48];
mn_16b_myuv[2*48+47:2*48] = mn_mask_yuv[4] ? 48'b0 : mn_ch3[2*48+47:2*48];
mn_16b_myuv[3*48+47:3*48] = mn_mask_yuv[6] ? 48'b0 : mn_ch3[3*48+47:3*48];
mn_16b_myuv[4*48+47:4*48] = mn_mask_yuv[8] ? 48'b0 : mn_ch3[4*48+47:4*48];
mn_16b_myuv[5*48+47:5*48] = mn_mask_yuv[10] ? 48'b0 : mn_ch3[5*48+47:5*48];
mn_16b_myuv[6*48+47:6*48] = mn_mask_yuv[12] ? 48'b0 : mn_ch3[6*48+47:6*48];
mn_16b_myuv[7*48+47:7*48] = mn_mask_yuv[14] ? 48'b0 : mn_ch3[7*48+47:7*48];
mn_16b_myuv[8*48+47:8*48] = mn_mask_yuv[16] ? 48'b0 : mn_ch3[8*48+47:8*48];
mn_16b_myuv[9*48+47:9*48] = mn_mask_yuv[18] ? 48'b0 : mn_ch3[9*48+47:9*48];
mn_16b_myuv[10*48+47:10*48] = mn_mask_yuv[20] ? 48'b0 : mn_ch3[10*48+47:10*48];
mn_16b_myuv[11*48+47:11*48] = mn_mask_yuv[22] ? 48'b0 : mn_ch3[11*48+47:11*48];
mn_16b_myuv[12*48+47:12*48] = mn_mask_yuv[24] ? 48'b0 : mn_ch3[12*48+47:12*48];
mn_16b_myuv[13*48+47:13*48] = mn_mask_yuv[26] ? 48'b0 : mn_ch3[13*48+47:13*48];
mn_16b_myuv[14*48+47:14*48] = mn_mask_yuv[28] ? 48'b0 : mn_ch3[14*48+47:14*48];
mn_16b_myuv[15*48+47:15*48] = mn_mask_yuv[30] ? 48'b0 : mn_ch3[15*48+47:15*48];
mn_16b_myuv[16*48+47:16*48] = mn_mask_yuv[32] ? 48'b0 : mn_ch3[16*48+47:16*48];
mn_16b_myuv[17*48+47:17*48] = mn_mask_yuv[34] ? 48'b0 : mn_ch3[17*48+47:17*48];
mn_16b_myuv[18*48+47:18*48] = mn_mask_yuv[36] ? 48'b0 : mn_ch3[18*48+47:18*48];
mn_16b_myuv[19*48+47:19*48] = mn_mask_yuv[38] ? 48'b0 : mn_ch3[19*48+47:19*48];
mn_16b_myuv[20*48+47:20*48] = mn_mask_yuv[40] ? 48'b0 : mn_ch3[20*48+47:20*48];
mn_16b_myuv[21*48+47:21*48] = mn_mask_yuv[42] ? 48'b0 : mn_ch3[21*48+47:21*48];
mn_16b_myuv[22*48+47:22*48] = mn_mask_yuv[44] ? 48'b0 : mn_ch3[22*48+47:22*48];
mn_16b_myuv[23*48+47:23*48] = mn_mask_yuv[46] ? 48'b0 : mn_ch3[23*48+47:23*48];
mn_16b_myuv[24*48+47:24*48] = mn_mask_yuv[48] ? 48'b0 : mn_ch3[24*48+47:24*48];
mn_16b_myuv[25*48+47:25*48] = mn_mask_yuv[50] ? 48'b0 : mn_ch3[25*48+47:25*48];
mn_16b_myuv[26*48+47:26*48] = mn_mask_yuv[52] ? 48'b0 : mn_ch3[26*48+47:26*48];
mn_16b_myuv[27*48+47:27*48] = mn_mask_yuv[54] ? 48'b0 : mn_ch3[27*48+47:27*48];
mn_16b_myuv[28*48+47:28*48] = mn_mask_yuv[56] ? 48'b0 : mn_ch3[28*48+47:28*48];
mn_16b_myuv[29*48+47:29*48] = mn_mask_yuv[58] ? 48'b0 : mn_ch3[29*48+47:29*48];
mn_16b_myuv[30*48+47:30*48] = mn_mask_yuv[60] ? 48'b0 : mn_ch3[30*48+47:30*48];
mn_16b_myuv[31*48+47:31*48] = mn_mask_yuv[62] ? 48'b0 : mn_ch3[31*48+47:31*48];
end



always @(
  pixel_planar
  or pixel_packed_10b
  or pixel_precision
  or pk_rsp_wr_cnt
  ) begin
    pk_rsp_mn_sel[0] = ~pixel_planar & (pixel_packed_10b | ~(|pixel_precision));
    pk_rsp_mn_sel[1] = ~pixel_planar & ~pixel_packed_10b & (|pixel_precision);
    pk_rsp_mn_sel[2] = pixel_planar & (pk_rsp_wr_cnt == 2'h0) & ~(|pixel_precision);
    pk_rsp_mn_sel[3] = pixel_planar & (pk_rsp_wr_cnt == 2'h0) & (|pixel_precision);
    pk_rsp_mn_sel[4] = pixel_planar & (pk_rsp_wr_cnt == 2'h1) & ~(|pixel_precision);
    pk_rsp_mn_sel[5] = pixel_planar & (pk_rsp_wr_cnt == 2'h1) & (|pixel_precision);
    pk_rsp_mn_sel[6] = pixel_planar & (pk_rsp_wr_cnt == 2'h2) & ~(|pixel_precision);
    pk_rsp_mn_sel[7] = pixel_planar & (pk_rsp_wr_cnt == 2'h2) & (|pixel_precision);
end

always @(
  pk_rsp_mn_sel
  or mn_8b_mnorm
  or mn_8b_myuv
  ) begin
    pk_rsp_mn_data_h1 = ({256  *2{pk_rsp_mn_sel[0]}} & mn_8b_mnorm[1023:512]) |
                        ({256  *2{pk_rsp_mn_sel[2]}} & mn_8b_myuv[1023:512]) |
                        ({256  *2{pk_rsp_mn_sel[4]}} & mn_8b_myuv[2047:1536]) |
                        ({256  *2{pk_rsp_mn_sel[6]}} & mn_8b_myuv[3071:2560]);
end

always @(
  pk_rsp_mn_sel
  or mn_8b_mnorm
  or mn_16b_mnorm
  or mn_8b_myuv
  or mn_16b_myuv
  ) begin
    pk_rsp_mn_data_h0 = ({256  *2{pk_rsp_mn_sel[0]}} & mn_8b_mnorm[511:0]) |
                        ({256  *2{pk_rsp_mn_sel[1]}} & mn_16b_mnorm[511:0]) |
                        ({256  *2{pk_rsp_mn_sel[2]}} & mn_8b_myuv[511:0]) |
                        ({256  *2{pk_rsp_mn_sel[3]}} & mn_16b_myuv[511:0]) |
                        ({256  *2{pk_rsp_mn_sel[4]}} & mn_8b_myuv[1535:1024]) |
                        ({256  *2{pk_rsp_mn_sel[5]}} & mn_16b_myuv[1023:512]) |
                        ({256  *2{pk_rsp_mn_sel[6]}} & mn_8b_myuv[2559:2048]) |
                        ({256  *2{pk_rsp_mn_sel[7]}} & mn_16b_myuv[1535:1024]);
end

assign mn_mask_y_en = pk_rsp_planar0_c0_en;
assign mn_mask_uv_0_en = pk_rsp_planar1_c0_en; 
assign mn_mask_uv_1_en = pk_rsp_planar1_c1_en;
assign pk_rsp_mn_data_h0_en = pk_rsp_wr_vld;
assign pk_rsp_mn_data_h1_en = (pk_rsp_wr_vld & (~(|pixel_precision) | pixel_packed_10b));

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mn_mask_y_d1 <= {64{1'b0}};
  end else begin
  if ((mn_mask_y_en) == 1'b1) begin
    mn_mask_y_d1 <= mask_zero;
  // VCS coverage off
  end else if ((mn_mask_y_en) == 1'b0) begin
  end else begin
    mn_mask_y_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_90x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mn_mask_y_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mn_mask_uv_lo_d1 <= {64{1'b0}};
  end else begin
  if ((mn_mask_uv_0_en) == 1'b1) begin
    mn_mask_uv_lo_d1 <= mask_zero;
  // VCS coverage off
  end else if ((mn_mask_uv_0_en) == 1'b0) begin
  end else begin
    mn_mask_uv_lo_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_91x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mn_mask_uv_0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mn_mask_uv_hi_d1 <= {64{1'b0}};
  end else begin
  if ((mn_mask_uv_1_en) == 1'b1) begin
    mn_mask_uv_hi_d1 <= mask_zero;
  // VCS coverage off
  end else if ((mn_mask_uv_1_en) == 1'b0) begin
  end else begin
    mn_mask_uv_hi_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_92x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mn_mask_uv_1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  if ((pk_rsp_mn_data_h1_en) == 1'b1) begin
    pk_mn_out_data_h1 <= pk_rsp_mn_data_h1;
  // VCS coverage off
  end else if ((pk_rsp_mn_data_h1_en) == 1'b0) begin
  end else begin
    pk_mn_out_data_h1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pk_rsp_mn_data_h0_en) == 1'b1) begin
    pk_mn_out_data_h0 <= pk_rsp_mn_data_h0;
  // VCS coverage off
  end else if ((pk_rsp_mn_data_h0_en) == 1'b0) begin
  end else begin
    pk_mn_out_data_h0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

assign pk_mn_out_data = {pk_mn_out_data_h1, pk_mn_out_data_h0};

////////////////////////////////////////////////////////////////////////
// cbuf write addresss generator                                      //
////////////////////////////////////////////////////////////////////////

//////// address base ////////

always @(
  pk_rsp_cur_1st_height
  or sg2pack_entry_st
  or pk_rsp_cur_layer_end
  or sg2pack_entry_end
  or sg2pack_entry_mid
  ) begin
    pk_rsp_wr_entries = pk_rsp_cur_1st_height ? sg2pack_entry_st :
                        pk_rsp_cur_layer_end ? sg2pack_entry_end :
                        sg2pack_entry_mid;
end

always @(
  pk_rsp_cur_1st_height
  or sg2pack_sub_h_st
  or pk_rsp_cur_layer_end
  or sg2pack_sub_h_end
  or sg2pack_sub_h_mid
  ) begin
    pk_rsp_wr_slices = pk_rsp_cur_1st_height ? sg2pack_sub_h_st :
                       pk_rsp_cur_layer_end ? sg2pack_sub_h_end :
                       sg2pack_sub_h_mid;
end

always @(
  is_first_running
  or status2dma_wr_idx
  or pk_rsp_wr_base
  or pk_rsp_wr_entries
  ) begin
    pk_rsp_wr_base_inc = is_first_running ? {1'b0, status2dma_wr_idx} :
                         (pk_rsp_wr_base + pk_rsp_wr_entries);
end

always @(
  pk_rsp_wr_base_inc
  or pixel_bank
  ) begin
    is_base_wrap = (pk_rsp_wr_base_inc[12 : 8 ] >= {1'b0, pixel_bank});
end

always @(
  pk_rsp_wr_base_inc
  or pixel_bank
  ) begin
    {mon_pk_rsp_wr_base_wrap[1:0],
     pk_rsp_wr_base_wrap} = (pk_rsp_wr_base_inc[12 : 8 ] - pixel_bank);
end

always @(
  is_base_wrap
  or pk_rsp_wr_base_wrap
  or pk_rsp_wr_base_inc
  ) begin
    pk_rsp_wr_base_w = is_base_wrap ? {pk_rsp_wr_base_wrap, pk_rsp_wr_base_inc[8 -1:0]} :
                       pk_rsp_wr_base_inc[12 -1:0];
end

always @(
  is_first_running
  or pk_rsp_wr_vld
  or pk_rsp_cur_one_line_end
  or pk_rsp_cur_sub_h_end
  ) begin
    pk_rsp_wr_base_en = is_first_running | (pk_rsp_wr_vld & pk_rsp_cur_one_line_end & pk_rsp_cur_sub_h_end);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pk_rsp_wr_base <= {12{1'b0}};
  end else begin
  if ((pk_rsp_wr_base_en) == 1'b1) begin
    pk_rsp_wr_base <= pk_rsp_wr_base_w;
  // VCS coverage off
  end else if ((pk_rsp_wr_base_en) == 1'b0) begin
  end else begin
    pk_rsp_wr_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_93x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_base_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pk_rsp_wr_base_wrap is overflow!")      zzz_assert_never_94x (nvdla_core_clk, `ASSERT_RESET, (is_base_wrap & (|mon_pk_rsp_wr_base_wrap) & pk_rsp_wr_base_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pk_rsp_wr_base_w is out of range!")      zzz_assert_never_95x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_base_en & (pk_rsp_wr_base_w >= 12'd3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////// h_offset ////////

always @(
  is_first_running
  or pk_rsp_cur_sub_h_end
  or pk_rsp_wr_h_offset
  or sg2pack_data_entries
  ) begin
    {mon_pk_rsp_wr_h_offset_w,
     pk_rsp_wr_h_offset_w} = (is_first_running | pk_rsp_cur_sub_h_end) ? 13'b0 :
                             pk_rsp_wr_h_offset + sg2pack_data_entries;
end

always @(
  is_first_running
  or pk_rsp_wr_vld
  or pk_rsp_cur_loop_end
  ) begin
    pk_rsp_wr_h_offset_en = is_first_running | (pk_rsp_wr_vld & pk_rsp_cur_loop_end);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pk_rsp_wr_h_offset <= {12{1'b0}};
  end else begin
  if ((pk_rsp_wr_h_offset_en) == 1'b1) begin
    pk_rsp_wr_h_offset <= pk_rsp_wr_h_offset_w;
  // VCS coverage off
  end else if ((pk_rsp_wr_h_offset_en) == 1'b0) begin
  end else begin
    pk_rsp_wr_h_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_96x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_h_offset_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pk_rsp_wr_h_offset_w is overflow!")      zzz_assert_never_97x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_h_offset_en & mon_pk_rsp_wr_h_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pk_rsp_wr_h_offset_w is out of range!")      zzz_assert_never_98x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_h_offset_en & (pk_rsp_wr_h_offset_w >= 12'd3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

///////// w_offset ////////

always @(
  pixel_data_shrink
  or pk_rsp_wr_size_ori
  or pixel_data_expand
  ) begin
    pk_rsp_wr_w_add = pixel_data_shrink ? {1'b0, pk_rsp_wr_size_ori[2:1]} :
                      pixel_data_expand ? {pk_rsp_wr_size_ori[1:0], 1'b0} :
                      pk_rsp_wr_size_ori;
end

always @(
  is_first_running
  or pk_rsp_cur_one_line_end
  or pk_rsp_cur_sub_h_end
  or pk_rsp_cur_loop_end
  or pk_rsp_wr_w_offset_ori
  or pk_rsp_wr_w_offset
  or pk_rsp_wr_w_add
  ) begin
    {mon_pk_rsp_wr_w_offset_w,
     pk_rsp_wr_w_offset_w} = (is_first_running | (pk_rsp_cur_one_line_end & pk_rsp_cur_sub_h_end)) ? 15'b0 :
                             (pk_rsp_cur_loop_end & ~pk_rsp_cur_sub_h_end) ? pk_rsp_wr_w_offset_ori :
                             pk_rsp_wr_w_offset + pk_rsp_wr_w_add;
end

always @(
  is_first_running
  or pk_rsp_wr_vld
  ) begin
    pk_rsp_wr_w_offset_en = is_first_running | pk_rsp_wr_vld;
    pk_rsp_wr_w_offset_ori_en = is_first_running;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pk_rsp_wr_w_offset <= {14{1'b0}};
  end else begin
  if ((pk_rsp_wr_w_offset_en) == 1'b1) begin
    pk_rsp_wr_w_offset <= pk_rsp_wr_w_offset_w;
  // VCS coverage off
  end else if ((pk_rsp_wr_w_offset_en) == 1'b0) begin
  end else begin
    pk_rsp_wr_w_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_99x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_w_offset_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_rsp_wr_w_offset_ori <= {14{1'b0}};
  end else begin
  if ((pk_rsp_wr_w_offset_ori_en) == 1'b1) begin
    pk_rsp_wr_w_offset_ori <= pk_rsp_wr_w_offset_w;
  // VCS coverage off
  end else if ((pk_rsp_wr_w_offset_ori_en) == 1'b0) begin
  end else begin
    pk_rsp_wr_w_offset_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_100x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_w_offset_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pk_rsp_wr_w_offset_w is overflow!")      zzz_assert_never_101x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_w_offset_en & mon_pk_rsp_wr_w_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pk_rsp_wr_w_offset_w is out of range!")      zzz_assert_never_102x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_w_offset_en & (pk_rsp_wr_w_offset_w[13:2] >= 12'd3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! store 16 bytes when not line end!")      zzz_assert_never_103x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_w_offset_en & ~pk_rsp_cur_one_line_end & ~(|pk_rsp_wr_w_add))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

///////// total_address ////////

always @(
  pk_rsp_wr_base
  or pk_rsp_wr_h_offset
  or pk_rsp_wr_w_offset
  ) begin
    pk_rsp_wr_addr_inc = pk_rsp_wr_base + pk_rsp_wr_h_offset + pk_rsp_wr_w_offset[12 +1:2];
end

always @(
  pk_rsp_wr_addr_inc
  or pixel_bank
  ) begin
    is_addr_wrap = (pk_rsp_wr_addr_inc[12 +1: 8 ] >= {2'b0, pixel_bank});
end

always @(
  pk_rsp_wr_addr_inc
  or pixel_bank
  ) begin
    {mon_pk_rsp_wr_addr_wrap[1:0],
     pk_rsp_wr_addr_wrap} = (pk_rsp_wr_addr_inc[12 : 8 ] - pixel_bank);
end

always @(
  is_addr_wrap
  or pk_rsp_wr_addr_wrap
  or pk_rsp_wr_addr_inc
  ) begin
    pk_rsp_wr_addr = is_addr_wrap ? {pk_rsp_wr_addr_wrap, pk_rsp_wr_addr_inc[8 -1:0]} :
                     pk_rsp_wr_addr_inc[12 -1:0];
end

assign pk_rsp_wr_sub_addr = pk_rsp_wr_w_offset[1:0];

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pk_out_addr <= {12{1'b0}};
  end else begin
  if ((pk_rsp_wr_vld) == 1'b1) begin
    pk_out_addr <= pk_rsp_wr_addr;
  // VCS coverage off
  end else if ((pk_rsp_wr_vld) == 1'b0) begin
  end else begin
    pk_out_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_104x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_out_hsel <= 1'b0;
  end else begin
  if ((pk_rsp_wr_vld) == 1'b1) begin
    pk_out_hsel <= pk_rsp_wr_sub_addr[1];
  // VCS coverage off
  end else if ((pk_rsp_wr_vld) == 1'b0) begin
  end else begin
    pk_out_hsel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_105x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pk_rsp_wr_addr_wrap is overflow!")      zzz_assert_never_106x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_vld & is_addr_wrap & (|mon_pk_rsp_wr_addr_wrap))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pk_rsp_wr_addr is out of range!")      zzz_assert_never_107x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_vld & (pk_rsp_wr_addr >= 12'd3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pk_rsp_wr_sub_addr conflict with pk_rsp_wr_w_add!")      zzz_assert_never_108x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_vld & (pk_rsp_wr_w_add + pk_rsp_wr_sub_addr > 4'h4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// update status                                                      //
////////////////////////////////////////////////////////////////////////
always @(
  pk_rsp_wr_vld
  or pk_rsp_cur_one_line_end
  or pk_rsp_cur_sub_h_end
  ) begin
    pk_rsp_data_updt = pk_rsp_wr_vld & pk_rsp_cur_one_line_end & pk_rsp_cur_sub_h_end;
end

assign pk_rsp_data_entries = pk_rsp_wr_entries;
assign pk_rsp_data_slices = pk_rsp_wr_slices;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pk_out_data_updt <= 1'b0;
  end else begin
  pk_out_data_updt <= pk_rsp_data_updt;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pk_out_data_entries <= {12{1'b0}};
  end else begin
  if ((pk_rsp_data_updt) == 1'b1) begin
    pk_out_data_entries <= pk_rsp_data_entries;
  // VCS coverage off
  end else if ((pk_rsp_data_updt) == 1'b0) begin
  end else begin
    pk_out_data_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_109x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_data_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pk_out_data_slices <= {4{1'b0}};
  end else begin
  if ((pk_rsp_data_updt) == 1'b1) begin
    pk_out_data_slices <= pk_rsp_data_slices;
  // VCS coverage off
  end else if ((pk_rsp_data_updt) == 1'b0) begin
  end else begin
    pk_out_data_slices <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_110x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_data_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  output connection                                                 //
////////////////////////////////////////////////////////////////////////
assign img2status_dat_updt = pk_out_data_updt;
assign img2status_dat_slices = {{8{1'b0}}, pk_out_data_slices};
assign img2status_dat_entries = pk_out_data_entries;

assign img2cvt_dat_wr_en = pk_out_vld;
assign img2cvt_dat_wr_addr = pk_out_addr;
assign img2cvt_dat_wr_hsel = pk_out_hsel;
assign img2cvt_dat_wr_data = pk_out_data;
assign img2cvt_dat_wr_pad_mask = pk_out_pad_mask;
assign img2cvt_dat_wr_info_pd = pk_out_info_pd;
assign img2cvt_mn_wr_data = pk_mn_out_data;

////////////////////////////////////////////////////////////////////////
// global status                                                      //
////////////////////////////////////////////////////////////////////////

always @(
  is_first_running
  or pk_rsp_wr_vld
  or pk_rsp_cur_layer_end
  or pack_is_done
  ) begin
    pack_is_done_w = is_first_running ? 1'b0 :
                     pk_rsp_wr_vld & pk_rsp_cur_layer_end ? 1'b1 :
                     pack_is_done;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pack_is_done <= 1'b1;
  end else begin
  pack_is_done <= pack_is_done_w;
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
  nv_assert_never #(0,0,"Error! pack_is_done cleared when idle!")      zzz_assert_never_111x (nvdla_core_clk, `ASSERT_RESET, (~pack_is_done & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

// ////////////////////////////////////////////////////////////////////////
// //  OBS connection                                                    //
// ////////////////////////////////////////////////////////////////////////
// &Force output img2cvt_dat_wr_en;
// &Force output img2cvt_dat_wr_addr;
// &Force output img2cvt_dat_wr_hsel;
// &Force output img2cvt_dat_wr_info_pd;
// &Force output img2status_dat_updt;
// 
// assign obs_bus_cdma_img2cvt_dat_wr_en       = img2cvt_dat_wr_en;
// assign obs_bus_cdma_img2cvt_dat_wr_addr     = img2cvt_dat_wr_addr;
// assign obs_bus_cdma_img2cvt_dat_wr_hsel     = img2cvt_dat_wr_hsel;
// assign obs_bus_cdma_img2cvt_dat_wr_info_pd  = img2cvt_dat_wr_info_pd;
// assign obs_bus_cdma_img2status_dat_updt     = img2status_dat_updt;

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           rd_sub_h_cnt[1:0]
//                           {rd_local_vld,rd_vld_d1}
//                           {rd_p0_vld_d1,rd_p1_vld_d1}
//                           rd_p0_addr_d1[1:0]
//                           rd_p1_addr_d1[1:0]
//                           rd_sub_h_d1[1:0]
//                           {pk_rsp_loop_end_d1,pk_rsp_one_line_end_d1}
//                           pk_rsp_wr_cnt;

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

    property cdma_img_pack__pk_rsp_wr_base_wrap__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (pk_rsp_wr_base_en & is_base_wrap);
    endproperty
    // Cover 0 : "(pk_rsp_wr_base_en & is_base_wrap)"
    FUNCPOINT_cdma_img_pack__pk_rsp_wr_base_wrap__0_COV : cover property (cdma_img_pack__pk_rsp_wr_base_wrap__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cdma_img_pack__pack_early_end__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (pk_rsp_vld & pk_rsp_early_end);
    endproperty
    // Cover 1 : "(pk_rsp_vld & pk_rsp_early_end)"
    FUNCPOINT_cdma_img_pack__pack_early_end__1_COV : cover property (cdma_img_pack__pack_early_end__1_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_CDMA_IMG_pack


