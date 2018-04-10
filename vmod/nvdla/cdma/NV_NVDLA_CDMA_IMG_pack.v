// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_IMG_pack.v

#include "NV_NVDLA_CDMA_define.h"

module NV_NVDLA_CDMA_IMG_pack (
   nvdla_core_clk
  ,nvdla_core_rstn
//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $atmm_num = ($dmaif / $atmm);
//: foreach my $i(0..$atmm_num -1) {
//:     print qq(
//:       ,img2sbuf_p${i}_rd_data 
//:       ,img2sbuf_p${i}_rd_addr 
//:       ,img2sbuf_p${i}_rd_en   
//:     );
//: }
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
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $Bnum = $dmaif / NVDLA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:      ,img2cvt_dat_wr_sel
//:      ,img2cvt_dat_wr_addr
//:      ,img2cvt_dat_wr_data
//:      ,img2cvt_mn_wr_data
//:      ,img2cvt_dat_wr_pad_mask
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:         ,img2cvt_dat_wr_mask
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:              ,img2cvt_dat_wr_addr${i}
//:              ,img2cvt_dat_wr_data${i}
//:              ,img2cvt_mn_wr_data${i}
//:              ,img2cvt_dat_wr_pad_mask${i}
//:         );
//:     }
//: } else {
//:     print qq(
//:      ,img2cvt_dat_wr_addr
//:      ,img2cvt_dat_wr_data
//:      ,img2cvt_mn_wr_data
//:      ,img2cvt_dat_wr_pad_mask
//:     );
//: }
  //,img2cvt_dat_wr_addr
  //,img2cvt_dat_wr_data
  ,img2cvt_dat_wr_en
  //,img2cvt_dat_wr_hsel
  ,img2cvt_dat_wr_info_pd
  //,img2cvt_dat_wr_pad_mask
  //,img2cvt_mn_wr_data
  ,img2status_dat_entries
  ,img2status_dat_slices
  ,img2status_dat_updt
  ,pack_is_done
  ,sg2pack_img_prdy
  );

/////////////////////////////////////////////////////////////
input           nvdla_core_clk;
input           nvdla_core_rstn;
//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $atmm_num = ($dmaif / $atmm);
//: foreach my $i(0..$atmm_num -1) {
//:     print qq(
//:         input   [${atmm}-1:0] img2sbuf_p${i}_rd_data;
//:         output    [7:0]       img2sbuf_p${i}_rd_addr;
//:         output                img2sbuf_p${i}_rd_en;
//:     );
//: }
input           is_running;
input           layer_st;
input     [5:0] pixel_bank;
input           pixel_data_expand;
input           pixel_data_shrink;
input           pixel_early_end;
input           pixel_packed_10b;
input           pixel_planar;
input     [2:0] pixel_planar0_sft;
input     [2:0] pixel_planar1_sft;
input     [1:0] pixel_precision;
input           pixel_uint;
input    [14:0] sg2pack_data_entries;
input    [14:0] sg2pack_entry_end;
input    [14:0] sg2pack_entry_mid;
input    [14:0] sg2pack_entry_st;
input    [12:0] sg2pack_height_total;
input    [10:0] sg2pack_img_pd;
input           sg2pack_img_pvld;
input           sg2pack_mn_enable;
input     [3:0] sg2pack_sub_h_end;
input     [3:0] sg2pack_sub_h_mid;
input     [3:0] sg2pack_sub_h_st;
input    [14:0] status2dma_wr_idx;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $Bnum = $dmaif / NVDLA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:      output [${k}-1:0]     img2cvt_dat_wr_sel;
//:      output [16:0]         img2cvt_dat_wr_addr;
//:      output [${dmaif}-1:0] img2cvt_dat_wr_data;
//:      output [${Bnum}*16-1:0] img2cvt_mn_wr_data;
//:      output [$Bnum-1:0]    img2cvt_dat_wr_pad_mask;
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:      output   [${k}-1:0]      img2cvt_dat_wr_mask;
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:              output [16:0]         img2cvt_dat_wr_addr${i};
//:              output [${dmaif}-1:0] img2cvt_dat_wr_data${i};
//:              output [${Bnum}*16-1:0] img2cvt_mn_wr_data${i};
//:              output [$Bnum-1:0]    img2cvt_dat_wr_pad_mask${i};
//:         );
//:     }
//: } else {
//:     print qq(
//:      output [16:0]         img2cvt_dat_wr_addr;
//:      output [${dmaif}-1:0] img2cvt_dat_wr_data;
//:      output [${Bnum}*16-1:0] img2cvt_mn_wr_data;
//:      output [$Bnum-1:0]    img2cvt_dat_wr_pad_mask;
//:     );
//: }
////output   [11:0] img2cvt_dat_wr_addr;
////output [511:0]  img2cvt_dat_wr_data;
output          img2cvt_dat_wr_en;
////output          img2cvt_dat_wr_hsel;
output   [11:0] img2cvt_dat_wr_info_pd;
////output [1023:0] img2cvt_mn_wr_data;
////output [63:0] img2cvt_dat_wr_pad_mask;//element per dmaif

output   [14:0] img2status_dat_entries;
output   [13:0] img2status_dat_slices;
output          img2status_dat_updt;
output          pack_is_done;
output          sg2pack_img_prdy;

input [12:0]        reg2dp_datain_width;
input [12:0]        reg2dp_datain_channel;
input [15:0]        reg2dp_mean_ry;
input [15:0]        reg2dp_mean_gu;
input [15:0]        reg2dp_mean_bv;
input [15:0]        reg2dp_mean_ax;
input [4:0]         reg2dp_pad_left;
input [5:0]         reg2dp_pad_right;

/////////////////////////////////////////////////////////////

reg       [5:0] data_planar0_add;
reg      [13:0] data_planar0_cur_cnt;
//reg      [13:0] data_planar0_ori_cnt;
reg       [2:0] data_planar0_p1_flag;
//reg       [2:0] data_planar0_p1_ori_flag;
reg       [5:0] data_planar1_add;
reg      [13:0] data_planar1_cur_cnt;
//reg      [13:0] data_planar1_ori_cnt;
reg       [2:0] data_planar1_p1_flag;
//reg       [2:0] data_planar1_p1_ori_flag;
reg      [13:0] data_width_mark_1;
reg      [13:0] data_width_mark_2;
reg             is_running_d1;
//: my $atmmbw = int(log(NVDLA_MEMORY_ATOMIC_SIZE)/log(2));
//: print qq(
//:     reg       [${atmmbw}-1:0] lp_planar0_mask_sft;
//:     wire      [${atmmbw}-1:0] lp_planar0_mask_sft_w;
//:     reg       [${atmmbw}-1:0] lp_planar1_mask_sft;
//:     wire      [${atmmbw}-1:0] lp_planar1_mask_sft_w;
//:     reg       [${atmmbw}-1:0] rp_planar0_mask_sft;
//:     wire      [${atmmbw}-1:0] rp_planar0_mask_sft_w;
//:     reg       [${atmmbw}-1:0] rp_planar1_mask_sft;
//:     wire      [${atmmbw}-1:0] rp_planar1_mask_sft_w;
//:     reg       [${atmmbw}-1:0] zero_planar0_mask_sft;
//:     wire      [${atmmbw}-1:0] zero_planar0_mask_sft_w;
//:     reg       [${atmmbw}-1:0] zero_planar1_mask_sft;
//:     wire      [${atmmbw}-1:0] zero_planar1_mask_sft_w;
//: );
reg      [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] mask_pad_planar0_c0_d1;
reg      [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] mask_pad_planar1_c0_d1;
reg      [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] mask_pad_planar1_c1_d1;
reg      [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] mn_mask_uv_hi_d1;
reg      [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] mn_mask_uv_lo_d1;
reg      [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] mn_mask_y_d1;
reg             pack_is_done;
reg       [4:0] pad_left_d1;
//reg     [NVDLA_CDMA_DMAIF_BW-1:0] pk_mn_out_data_h0;
//reg     [NVDLA_CDMA_DMAIF_BW-1:0] pk_mn_out_data_h1;
reg      [14:0] pk_out_addr;
reg      [14:0] pk_out_data_entries;
reg     [NVDLA_CDMA_DMAIF_BW-1:0] pk_out_data_h0;
//reg     [511:0] pk_out_data_h1;
reg       [3:0] pk_out_data_slices;
reg             pk_out_data_updt;
reg             pk_out_ext128;
//reg             pk_out_ext64;

//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $Bnum = $dmaif / NVDLA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:      reg    [${k}-1:0]     pk_out_hsel;
//:     );
//: }
reg       [3:0] pk_out_mask;
reg             pk_out_mean;
reg      [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] pk_out_pad_mask_h0;
//reg      [63:0] pk_out_pad_mask_h1;
reg       [2:0] pk_out_sub_h;
reg             pk_out_uint;
reg             pk_out_vld;
reg             pk_rsp_1st_height_d1;
reg             pk_rsp_layer_end_d1;
reg             pk_rsp_loop_end_d1;
reg             pk_rsp_one_line_end_d1;
reg     [NVDLA_CDMA_DMAIF_BW-1:0] pk_rsp_planar0_c0_d1;
reg     [NVDLA_CDMA_DMAIF_BW-1:0] pk_rsp_planar1_c0_d1;
reg     [NVDLA_CDMA_DMAIF_BW-1:0] pk_rsp_planar1_c1_d1;
reg       [2:0] pk_rsp_sub_h_d1;
reg             pk_rsp_sub_h_end_d1;
reg             pk_rsp_vld_d1;
reg      [14:0] pk_rsp_wr_base;
reg       [1:0] pk_rsp_wr_cnt;
reg      [14:0] pk_rsp_wr_h_offset;
reg      [14:0] pk_rsp_wr_w_offset;
reg      [14:0] pk_rsp_wr_w_offset_ori;
reg             rd_1st_height_d1;
reg      [12:0] rd_height_cnt;
reg             rd_layer_end_d1;
reg             rd_local_vld;
reg       [3:0] rd_loop_cnt;
reg             rd_loop_end_d1;
reg             rd_one_line_end_d1;
reg       [7:0] rd_p0_addr_d1;
reg      [NVDLA_MEMORY_ATOMIC_SIZE-1:0] rd_p0_pad_mask_d1;
reg       [6:0] rd_p0_planar0_idx;
reg       [6:0] rd_p0_planar0_ori_idx;
reg       [6:0] rd_p0_planar1_idx;
reg       [6:0] rd_p0_planar1_ori_idx;
reg             rd_p0_vld_d1;
reg      [NVDLA_MEMORY_ATOMIC_SIZE-1:0] rd_p0_zero_mask_d1;
reg       [7:0] rd_p1_addr_d1;
reg      [NVDLA_MEMORY_ATOMIC_SIZE-1:0] rd_p1_pad_mask_d1;
reg       [6:0] rd_p1_planar0_idx;
reg       [6:0] rd_p1_planar0_ori_idx;
reg       [6:0] rd_p1_planar1_idx;
reg       [6:0] rd_p1_planar1_ori_idx;
reg             rd_p1_vld_d1;
reg      [NVDLA_MEMORY_ATOMIC_SIZE-1:0] rd_p1_zero_mask_d1;
reg       [1:0] rd_pburst_cnt;
reg             rd_planar_cnt;
reg             rd_planar_d1;
reg       [2:0] rd_sub_h_d1;
reg             rd_sub_h_end_d1;
reg             rd_vld_d1;
//reg       [4:0] rp_planar0_mask_sft;
//wire      [4:0] rp_planar0_mask_sft_w;
//reg       [4:0] rp_planar1_mask_sft;
//wire      [4:0] rp_planar1_mask_sft_w;
//reg       [4:0] zero_planar0_mask_sft;
//wire      [4:0] zero_planar0_mask_sft_w;
//reg       [4:0] zero_planar1_mask_sft;
//wire      [4:0] zero_planar1_mask_sft_w;
wire   [NVDLA_CDMA_DMAIF_BW-1:0] dat_l0;
wire   [NVDLA_CDMA_DMAIF_BW*2-1:0] dat_l1;
wire   [NVDLA_CDMA_DMAIF_BW-1:0] dat_l1_hi;
wire   [NVDLA_CDMA_DMAIF_BW-1:0] dat_l1_lo;
wire   [NVDLA_CDMA_DMAIF_BW*3-1:0] dat_yuv;
wire   [NVDLA_CDMA_DMAIF_BW*3-1:0] dat_8b_yuv;
wire      [5:0] data_planar0_add_w;
wire     [13:0] data_planar0_cur_cnt_w;
wire            data_planar0_en;
//wire            data_planar0_ori_en;
wire     [13:0] data_planar0_p0_cnt_w;
wire      [2:0] data_planar0_p0_cur_flag;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar0_p0_lp_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar0_p0_pad_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar0_p0_rp_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar0_p0_zero_mask;
wire     [13:0] data_planar0_p1_cnt_w;
wire      [2:0] data_planar0_p1_cur_flag;
wire      [2:0] data_planar0_p1_flag_w;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar0_p1_lp_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar0_p1_pad_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar0_p1_rp_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar0_p1_zero_mask;
wire      [5:0] data_planar1_add_w;
wire     [13:0] data_planar1_cur_cnt_w;
wire            data_planar1_en;
//wire            data_planar1_ori_en;
wire     [13:0] data_planar1_p0_cnt_w;
wire      [2:0] data_planar1_p0_cur_flag;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar1_p0_lp_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar1_p0_pad_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar1_p0_rp_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar1_p0_zero_mask;
wire     [13:0] data_planar1_p1_cnt_w;
wire      [2:0] data_planar1_p1_cur_flag;
wire      [2:0] data_planar1_p1_flag_w;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar1_p1_lp_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar1_p1_pad_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar1_p1_rp_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] data_planar1_p1_zero_mask;
wire     [13:0] data_width_mark_0;
wire     [13:0] data_width_mark_1_w;
wire     [13:0] data_width_mark_2_w;
wire            img_layer_end;
wire            img_line_end;
wire      [3:0] img_p0_burst;
wire      [4:0] img_p1_burst;
wire     [10:0] img_pd;
wire            is_1st_height;
wire            is_addr_wrap;
wire            is_base_wrap;
wire            is_first_running;
wire            is_last_height;
wire            is_last_loop;
wire            is_last_pburst;
wire            is_last_planar;
wire            is_last_sub_h;
wire     [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] mask_pad;
wire     [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] mask_zero;
//wire    [511:0] mn_16b_mnorm;
//wire   [1535:0] mn_16b_myuv;
//wire   [NVDLA_CDMA_DMAIF_BW-1:0] mn_8b_mnorm;
//wire   [NVDLA_CDMA_DMAIF_BW*3-1:0] mn_8b_myuv;

//: my $mn_bw = int(NVDLA_CDMA_DMAIF_BW / NVDLA_BPE) * 16 ;
//: print qq(
//:     wire   [${mn_bw}-1:0] mn_ch1;
//:     wire   [${mn_bw}-1:0] mn_ch4;
//:     wire   [${mn_bw}*3-1:0] mn_ch3;
//:     wire   [${mn_bw}*3-1:0] mn_8b_myuv;
//:     wire   [${mn_bw}-1:0] mn_ch1_4;
//:     wire   [${mn_bw}-1:0] mn_8b_mnorm;
//:     wire   [${mn_bw}-1:0] pk_rsp_mn_data_h0;
//:     reg    [${mn_bw}-1:0] pk_mn_out_data_h0;
//:     wire   [${mn_bw}-1:0] pk_mn_out_data;
//: );

//wire   [NVDLA_CDMA_DMAIF_BW-1:0] mn_ch1;
//wire   [NVDLA_CDMA_DMAIF_BW-1:0] mn_ch1_4;
//wire   [NVDLA_CDMA_DMAIF_BW*3-1:0] mn_ch3;
//wire   [NVDLA_CDMA_DMAIF_BW-1:0] mn_ch4;

wire   [(NVDLA_CDMA_DMAIF_BW/NVDLA_BPE)*2-1:0] mn_mask_uv;
wire            mn_mask_uv_0_en;
wire            mn_mask_uv_1_en;
wire    [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] mn_mask_uv_hi;
wire    [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] mn_mask_uv_lo;
wire    [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] mn_mask_y;
wire            mn_mask_y_en;
wire    [(NVDLA_CDMA_DMAIF_BW/NVDLA_BPE)*3-1:0] mn_mask_yuv;
wire            mon_data_planar0_p0_cnt_w;
wire            mon_data_planar0_p1_cnt_w;
wire            mon_data_planar1_p0_cnt_w;
wire            mon_data_planar1_p1_cnt_w;
wire      [2:0] mon_lp_planar0_mask_sft_w;
wire      [2:0] mon_lp_planar1_mask_sft_w;
wire      [2:0] mon_pk_rsp_wr_addr_wrap;
wire      [1:0] mon_pk_rsp_wr_base_wrap;
wire            mon_pk_rsp_wr_cnt_w;
wire            mon_pk_rsp_wr_h_offset_w;
wire            mon_pk_rsp_wr_w_offset_w;
wire            mon_rd_loop_cnt_inc;
wire            mon_rd_loop_cnt_limit;
wire      [2:0] mon_rp_planar0_mask_sft_w;
wire      [2:0] mon_rp_planar1_mask_sft_w;
wire      [2:0] mon_zero_planar0_mask_sft_w;
wire      [2:0] mon_zero_planar1_mask_sft_w;
wire            pack_is_done_w;
wire    [(NVDLA_CDMA_DMAIF_BW/NVDLA_BPE)*3-1:0] pad_mask_8b_yuv;
wire    [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] pad_mask_l0;
wire    [(NVDLA_CDMA_DMAIF_BW/NVDLA_BPE)*2-1:0] pad_mask_l1;
wire     [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] pad_mask_l1_hi;
wire     [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] pad_mask_l1_lo;
wire    [(NVDLA_CDMA_DMAIF_BW/NVDLA_BPE)*3-1:0] pad_mask_yuv;
//wire   [NVDLA_CDMA_DMAIF_BW-1:0] pk_mn_out_data;
wire   [NVDLA_CDMA_DMAIF_BW-1:0] pk_out_data;
wire     [11:0] pk_out_info_pd;
//wire            pk_out_interleave;
//wire    [127:0] pk_out_pad_mask;
wire    [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] pk_out_pad_mask;
wire            pk_rsp_1st_height;
wire            pk_rsp_cur_1st_height;
wire            pk_rsp_cur_layer_end;
wire            pk_rsp_cur_loop_end;
wire            pk_rsp_cur_one_line_end;
wire      [2:0] pk_rsp_cur_sub_h;
wire            pk_rsp_cur_sub_h_end;
wire            pk_rsp_cur_vld;
//wire   [1023:0] pk_rsp_dat_ergb;
//wire   [1023:0] pk_rsp_dat_mergb;
wire    [NVDLA_CDMA_DMAIF_BW-1:0] pk_rsp_dat_mnorm;
wire    [NVDLA_CDMA_DMAIF_BW-1:0] pk_rsp_dat_normal;
wire    [NVDLA_CDMA_DMAIF_BW-1:0] pk_rsp_data_h0;
wire            pk_rsp_data_h0_en;
//wire    [511:0] pk_rsp_data_h1;
//wire            pk_rsp_data_h1_en;
wire            pk_rsp_data_updt;
wire            pk_rsp_early_end;
wire            pk_rsp_layer_end;
wire            pk_rsp_loop_end;
//wire    [NVDLA_CDMA_DMAIF_BW-1:0] pk_rsp_mn_data_h0;
wire            pk_rsp_mn_data_h0_en;
//wire    [511:0] pk_rsp_mn_data_h1;
wire            pk_rsp_mn_data_h1_en;
wire      [7:0] pk_rsp_mn_sel;
wire            pk_rsp_one_line_end;
wire      [4:0] pk_rsp_out_sel;
wire    [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] pk_rsp_p0_data;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] pk_rsp_p0_pad_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] pk_rsp_p0_zero_mask;
wire    [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] pk_rsp_p1_data;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] pk_rsp_p1_pad_mask;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] pk_rsp_p1_zero_mask;
//wire    [127:0] pk_rsp_pad_mask_ergb;
wire     [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] pk_rsp_pad_mask_h0;
//wire     [63:0] pk_rsp_pad_mask_h1;
wire     [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE-1:0] pk_rsp_pad_mask_norm;
wire            pk_rsp_pipe_sel;
wire            pk_rsp_planar;
wire            pk_rsp_planar0_c0_en;
wire            pk_rsp_planar1_c0_en;
wire            pk_rsp_planar1_c1_en;
wire      [2:0] pk_rsp_sub_h;
wire            pk_rsp_sub_h_end;
wire            pk_rsp_vld;
wire            pk_rsp_vld_d1_w;
wire     [14:0] pk_rsp_wr_addr;
wire     [16:0] pk_rsp_wr_addr_inc;
wire      [5:0] pk_rsp_wr_addr_wrap;
wire            pk_rsp_wr_base_en;
wire     [15:0] pk_rsp_wr_base_inc;
wire     [14:0] pk_rsp_wr_base_w;
wire      [5:0] pk_rsp_wr_base_wrap;
wire      [1:0] pk_rsp_wr_cnt_w;
wire     [14:0] pk_rsp_wr_entries;
//wire            pk_rsp_wr_ext128;
//wire            pk_rsp_wr_ext64;
wire            pk_rsp_wr_h_offset_en;
wire     [14:0] pk_rsp_wr_h_offset_w;
wire      [3:0] pk_rsp_wr_mask;
wire      [2:0] pk_rsp_wr_size_ori;
wire      [3:0] pk_rsp_wr_slices;
wire      [1:0] pk_rsp_wr_sub_addr;
wire            pk_rsp_wr_vld;
wire      [2:0] pk_rsp_wr_w_add;
wire            pk_rsp_wr_w_offset_en;
wire            pk_rsp_wr_w_offset_ori_en;
wire     [14:0] pk_rsp_wr_w_offset_w;
wire     [13:0] rd_height_cnt_inc;
wire     [12:0] rd_height_cnt_w;
wire            rd_height_en;
wire            rd_height_end;
wire      [2:0] rd_idx_add;
wire            rd_line_end;
wire            rd_local_vld_w;
wire      [3:0] rd_loop_cnt_inc;
wire      [3:0] rd_loop_cnt_limit;
wire      [3:0] rd_loop_cnt_w;
wire            rd_loop_en;
wire            rd_loop_end;
wire      [7:0] rd_p0_addr;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] rd_p0_pad_mask;
wire      [7:0] rd_p0_planar0_idx_inc;
wire      [6:0] rd_p0_planar0_idx_w;
wire      [7:0] rd_p0_planar1_idx_inc;
wire      [6:0] rd_p0_planar1_idx_w;
wire            rd_p0_vld;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] rd_p0_zero_mask;
wire      [7:0] rd_p1_addr;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] rd_p1_pad_mask;
wire      [7:0] rd_p1_planar0_idx_inc;
wire      [6:0] rd_p1_planar0_idx_w;
wire      [7:0] rd_p1_planar1_idx_inc;
wire      [6:0] rd_p1_planar1_idx_w;
wire            rd_p1_vld;
wire     [NVDLA_MEMORY_ATOMIC_SIZE-1:0] rd_p1_zero_mask;
wire     [1:0]  rd_pburst_cnt_w;
wire            rd_pburst_en;
wire            rd_pburst_end;
wire     [1:0]  rd_pburst_limit;
wire            rd_planar0_burst_end;
wire            rd_planar0_en;
wire            rd_planar0_line_end;
wire            rd_planar0_ori_en;
//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $atmm_num = ($dmaif / $atmm);
//: print qq(
//:     wire      [${atmm_num}-1:0] rd_planar0_rd_mask;
//:     wire      [${atmm_num}-1:0] rd_planar1_rd_mask;
//:     wire      [${atmm_num}-1:0] rd_rd_mask;
//: );
wire            rd_planar1_burst_end;
wire            rd_planar1_en;
wire            rd_planar1_line_end;
wire            rd_planar1_ori_en;
wire            rd_planar_cnt_w;
wire            rd_planar_en;
wire            rd_planar_end;
wire      [2:0] rd_sub_h_cnt;
wire            rd_sub_h_end;
wire            rd_vld;
wire    [NVDLA_CDMA_DMAIF_BW-1:0] rdat;
//wire     [13:0] z14;
//wire      [5:0] z6;
////////////////////////////////////////////////////////////////////////
// signals from other modules                                         //
////////////////////////////////////////////////////////////////////////
assign img_pd = sg2pack_img_pvld ? sg2pack_img_pd : 11'b0;

assign img_p0_burst[3:0] = img_pd[3:0];
assign img_p1_burst[4:0] = img_pd[8:4];
assign img_line_end      = img_pd[9];
assign img_layer_end     = img_pd[10];

assign is_first_running = ~is_running_d1 & is_running;
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"is_running\" -q is_running_d1");

////////////////////////////////////////////////////////////////////////
// general signals                                                    //
////////////////////////////////////////////////////////////////////////
//: &eperl::flop("-nodeclare   -rval \"{5{1'b0}}\"  -en \"layer_st\" -d \"reg2dp_pad_left\" -q pad_left_d1");
assign data_width_mark_0 = {{9{1'b0}}, pad_left_d1};
assign data_width_mark_1_w = reg2dp_pad_left + reg2dp_datain_width + 1'b1;
assign data_width_mark_2_w = reg2dp_pad_left + reg2dp_datain_width + 1'b1 + reg2dp_pad_right;
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"layer_st\" -d \"data_width_mark_1_w\" -q data_width_mark_1");
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"layer_st\" -d \"data_width_mark_2_w\" -q data_width_mark_2");

// 5'b0 means atmm bw
//: my $atmmbw = int(log(NVDLA_MEMORY_ATOMIC_SIZE)/log(2));
//: print qq(
//:     assign {mon_lp_planar0_mask_sft_w, lp_planar0_mask_sft_w} = ({data_width_mark_0[${atmmbw}-1:0], ${atmmbw}'b0} >> pixel_planar0_sft);
//:     assign {mon_lp_planar1_mask_sft_w, lp_planar1_mask_sft_w} = ({data_width_mark_0[${atmmbw}-1:0], ${atmmbw}'b0} >> pixel_planar1_sft);
//:     
//:     assign {mon_rp_planar0_mask_sft_w, rp_planar0_mask_sft_w} = ({data_width_mark_1[${atmmbw}-1:0], ${atmmbw}'b0} >> pixel_planar0_sft);
//:     assign {mon_rp_planar1_mask_sft_w, rp_planar1_mask_sft_w} = ({data_width_mark_1[${atmmbw}-1:0], ${atmmbw}'b0} >> pixel_planar1_sft);
//:     
//:     assign {mon_zero_planar0_mask_sft_w, zero_planar0_mask_sft_w} = ({data_width_mark_2[${atmmbw}-1:0], ${atmmbw}'b0} >> pixel_planar0_sft);
//:     assign {mon_zero_planar1_mask_sft_w, zero_planar1_mask_sft_w} = ({data_width_mark_2[${atmmbw}-1:0], ${atmmbw}'b0} >> pixel_planar1_sft);
//: );
assign data_planar0_add_w = (1'b1 << pixel_planar0_sft);
assign data_planar1_add_w = (1'b1 << pixel_planar1_sft);

//: my $atmmbw = int(log(NVDLA_MEMORY_ATOMIC_SIZE)/log(2));
//: &eperl::flop("-nodeclare   -rval \"{${atmmbw}{1'b0}}\"  -en \"is_first_running\" -d \"lp_planar0_mask_sft_w\" -q lp_planar0_mask_sft");
//: &eperl::flop("-nodeclare   -rval \"{${atmmbw}{1'b0}}\"  -en \"is_first_running\" -d \"lp_planar1_mask_sft_w\" -q lp_planar1_mask_sft");
//: &eperl::flop("-nodeclare   -rval \"{${atmmbw}{1'b0}}\"  -en \"is_first_running\" -d \"rp_planar0_mask_sft_w\" -q rp_planar0_mask_sft");
//: &eperl::flop("-nodeclare   -rval \"{${atmmbw}{1'b0}}\"  -en \"is_first_running\" -d \"rp_planar1_mask_sft_w\" -q rp_planar1_mask_sft");
//: &eperl::flop("-nodeclare   -rval \"{${atmmbw}{1'b0}}\"  -en \"is_first_running\" -d \"zero_planar0_mask_sft_w\" -q zero_planar0_mask_sft");
//: &eperl::flop("-nodeclare   -rval \"{${atmmbw}{1'b0}}\"  -en \"is_first_running\" -d \"zero_planar1_mask_sft_w\" -q zero_planar1_mask_sft");
//: &eperl::flop("-nodeclare   -rval \"{6{1'b0}}\"  -en \"is_first_running\" -d \"data_planar0_add_w\" -q data_planar0_add");
//: &eperl::flop("-nodeclare   -rval \"{6{1'b0}}\"  -en \"is_first_running\" -d \"data_planar1_add_w\" -q data_planar1_add");

////////////////////////////////////////////////////////////////////////
// Shared buffer read sequnce generator                               //
////////////////////////////////////////////////////////////////////////
assign is_1st_height = ~(|rd_height_cnt);
assign is_last_height = (rd_height_cnt == sg2pack_height_total);
assign rd_height_cnt_inc = rd_height_cnt + 1'b1;
assign rd_height_cnt_w = (is_first_running) ? 13'b0 : rd_height_cnt_inc[12:0];
//: &eperl::flop("-nodeclare   -rval \"{13{1'b0}}\"  -en \"rd_height_en\" -d \"rd_height_cnt_w\" -q rd_height_cnt");

//////// sub height counter ////////
assign is_last_sub_h = 1'b1;
assign rd_sub_h_cnt = 3'b0;

//////// loop cnt ////////
// img_p0_burst[3:1],means img_p0_burst/2, 2 means atmm_num/per_dmaif
//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $atmm_num = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: if($atmm_num == 1) {
//:     print qq(
//:         assign rd_loop_cnt_limit = img_p0_burst[3:0];
//:     ) 
//: } elsif($atmm_num == 2) {
//:     print qq(
//:         assign {mon_rd_loop_cnt_limit, rd_loop_cnt_limit} = img_p0_burst[3:1] + img_p0_burst[0];
//:     )
//: } elsif($atmm_num == 4) {
//:     print qq(
//:         assign {mon_rd_loop_cnt_limit, rd_loop_cnt_limit} = img_p0_burst[3:2] + (|img_p0_burst[1:0]);
//:     )
//: }
assign {mon_rd_loop_cnt_inc, rd_loop_cnt_inc} = rd_loop_cnt + 1'b1;
assign is_last_loop = (rd_loop_cnt_inc >= rd_loop_cnt_limit);
assign rd_loop_cnt_w = (is_first_running | is_last_loop) ? 4'b0 : rd_loop_cnt_inc;
//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"rd_loop_en\" -d \"rd_loop_cnt_w\" -q rd_loop_cnt");

//////// planar cnt ////////
assign rd_planar_cnt_w = (is_first_running | is_last_planar) ? 1'b0 : ~rd_planar_cnt;
assign is_last_planar = ~pixel_planar | rd_planar_cnt;
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"rd_planar_en\" -d \"rd_planar_cnt_w\" -q rd_planar_cnt");

//////// partial burst cnt ////////
//assign rd_pburst_limit = (rd_planar_cnt & (~is_last_loop | ~img_p0_burst[0])) ? 1'b1 : 1'b0;

//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $atmm_num = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: if($atmm_num == 1) {
//:     print qq(
//:         //assign rd_pburst_limit = 2'b0;
//:         assign rd_pburst_limit = (rd_planar_cnt & (~is_last_loop | ~img_p1_burst[0])) ? 2'b1 : 2'b0;
//:     ) 
//: } elsif($atmm_num == 2) {
//:     print qq(
//:         assign rd_pburst_limit = (rd_planar_cnt & (~is_last_loop | ~img_p0_burst[0])) ? 2'b1 : 2'b0;
//:     )
//: } elsif($atmm_num == 4) {
//:     print qq(
//:         assign rd_pburst_limit = (rd_planar_cnt & (~is_last_loop | (img_p0_burst[1:0]==2'd0))) ? 2'b3
//:                                  (rd_planar_cnt & (~is_last_loop | (img_p0_burst[1:0]==2'd1))) ? 2'b0
//:                                  (rd_planar_cnt & (~is_last_loop | (img_p0_burst[1:0]==2'd2))) ? 2'b1 : 2'b2;
//:     )
//: }
assign is_last_pburst = (rd_pburst_cnt == rd_pburst_limit);
assign rd_pburst_cnt_w = (is_first_running | is_last_pburst) ? 2'b0 : rd_pburst_cnt + 1'b1;
//: &eperl::flop("-nodeclare   -rval \"2'b0\"  -en \"rd_pburst_en\" -d \"rd_pburst_cnt_w\" -q rd_pburst_cnt");

//////// control logic ////////
assign sg2pack_img_prdy = rd_vld & rd_sub_h_end;
assign rd_vld = (sg2pack_img_pvld | rd_local_vld);
assign rd_local_vld_w = (~is_running) ? 1'b0 :
                        rd_sub_h_end ? 1'b0 :
                        sg2pack_img_pvld ? 1'b1 : rd_local_vld;

assign rd_pburst_end = rd_vld & is_last_pburst;
assign rd_planar_end = rd_vld & is_last_pburst & is_last_planar;
assign rd_loop_end   = rd_vld & is_last_pburst & is_last_planar & is_last_loop;
assign rd_sub_h_end  = rd_vld & is_last_pburst & is_last_planar & is_last_loop & is_last_sub_h;
assign rd_line_end   = rd_vld & is_last_pburst & is_last_planar & is_last_loop & is_last_sub_h & img_line_end;
assign rd_height_end = rd_vld & is_last_pburst & is_last_planar & is_last_loop & is_last_sub_h & img_line_end & is_last_height;
assign rd_pburst_en = is_first_running | rd_vld;
assign rd_planar_en = is_first_running | (rd_pburst_end & pixel_planar);
assign rd_loop_en   = is_first_running | rd_planar_end;
assign rd_height_en = is_first_running | rd_line_end;

assign rd_planar0_burst_end = rd_vld & is_last_pburst & ~rd_planar_cnt & is_last_loop;
assign rd_planar1_burst_end = rd_vld & is_last_pburst & rd_planar_cnt & is_last_loop;

assign rd_planar0_line_end = rd_vld & is_last_pburst & ~rd_planar_cnt & is_last_loop & is_last_sub_h & img_line_end;
assign rd_planar1_line_end = rd_vld & is_last_pburst & rd_planar_cnt & is_last_loop & is_last_sub_h & img_line_end;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"rd_local_vld_w\" -q rd_local_vld");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"rd_vld\" -q rd_vld_d1");

////////////////////////////////////////////////////////////////////////
// read control logic generator                                       //
////////////////////////////////////////////////////////////////////////
//////// read enalbe mask ////////
//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $atmm_num = ($dmaif / $atmm);
//: if($atmm_num == 1) {
//:     print qq(
//:         assign rd_planar0_rd_mask = 1'h1;
//:         assign rd_planar1_rd_mask = 1'h1;
//:
//:         assign rd_p0_vld = rd_vld & rd_rd_mask[0];
//:
//:         assign rd_idx_add = 3'h1;
//:     );
//: } elsif($atmm_num == 2) {
//:     print qq(
//:         assign rd_planar0_rd_mask = (is_last_loop & is_last_pburst & img_p0_burst[0]) ? 2'h1 : 2'h3;
//:         assign rd_planar1_rd_mask = (is_last_loop & is_last_pburst & img_p1_burst[0]) ? 2'h1 : 2'h3;  
//:
//:         assign rd_p0_vld = rd_vld & rd_rd_mask[0];
//:         assign rd_p1_vld = rd_vld & rd_rd_mask[1];
//:
//:         assign rd_idx_add = rd_rd_mask[1] ? 3'h2 : 3'h1;
//:     );
//: } elsif($atmm_num == 4) {
//:     print qq(
//:         assign rd_planar0_rd_mask = (is_last_loop & is_last_pburst & (img_p0_burst[1:0]==2'd0)) ? 4'h1 : 
//:                                     (is_last_loop & is_last_pburst & (img_p0_burst[1:0]==2'd1)) ? 4'h3 :
//:                                     (is_last_loop & is_last_pburst & (img_p0_burst[1:0]==2'd2)) ? 4'h7 : 4'hf;
//:         assign rd_planar1_rd_mask = (is_last_loop & is_last_pburst & (img_p1_burst[1:0]==2'd0)) ? 4'h1 : 
//:                                     (is_last_loop & is_last_pburst & (img_p1_burst[1:0]==2'd1)) ? 4'h3 :
//:                                     (is_last_loop & is_last_pburst & (img_p1_burst[1:0]==2'd2)) ? 4'h7 : 4'hf;  
//:
//:         assign rd_p0_vld = rd_vld & rd_rd_mask[0];
//:         assign rd_p1_vld = rd_vld & rd_rd_mask[1];
//:         assign rd_p2_vld = rd_vld & rd_rd_mask[2];
//:         assign rd_p3_vld = rd_vld & rd_rd_mask[3];
//:
//:         assign rd_idx_add = rd_rd_mask[3] ? 3'h4 : rd_rd_mask[2] ? 3'h3 : rd_rd_mask[1] ? 3'h2 : 3'h1;
//:     );
//: }
//: foreach my $i(0..$atmm_num -1) {
//:     &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"rd_p${i}_vld\" -q rd_p${i}_vld_d1");
//: }
assign rd_rd_mask = rd_planar_cnt ? rd_planar1_rd_mask : rd_planar0_rd_mask;

//////// read address ////////
//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $atmm_num = ($dmaif / $atmm);
//: foreach my $i(0..$atmm_num -1) {
//:     print qq(
//:         assign rd_p${i}_planar0_idx_inc = rd_p${i}_planar0_idx + rd_idx_add;
//:         assign rd_p${i}_planar1_idx_inc = rd_p${i}_planar1_idx + rd_idx_add;
//:         assign rd_p${i}_planar0_idx_w = is_first_running ? 7'b${i} : rd_p${i}_planar0_idx_inc[8 -2:0];
//:         assign rd_p${i}_planar1_idx_w = is_first_running ? 7'b${i} : rd_p${i}_planar1_idx_inc[8 -2:0];
//:         assign rd_p${i}_addr = (~rd_planar_cnt) ? {1'b0, rd_p${i}_planar0_idx[0], rd_p${i}_planar0_idx[8 -2:1]} : {1'b1, rd_p${i}_planar1_idx[0], rd_p${i}_planar1_idx[8 -2:1]};
//:     );
//: &eperl::flop("-nodeclare   -rval \"{7{1'b0}}\"  -en \"rd_planar0_en\" -d \"rd_p${i}_planar0_idx_w\" -q rd_p${i}_planar0_idx");
//: &eperl::flop("-nodeclare   -rval \"{7{1'b0}}\"  -en \"rd_planar1_en\" -d \"rd_p${i}_planar1_idx_w\" -q rd_p${i}_planar1_idx");
//: &eperl::flop("-nodeclare   -rval \"{7{1'b0}}\"  -en \"rd_planar0_ori_en\" -d \"rd_p${i}_planar0_idx_w\" -q rd_p${i}_planar0_ori_idx");
//: &eperl::flop("-nodeclare   -rval \"{7{1'b0}}\"  -en \"rd_planar1_ori_en\" -d \"rd_p${i}_planar1_idx_w\" -q rd_p${i}_planar1_ori_idx");
//: &eperl::flop("-nodeclare   -rval \"{8{1'b0}}\"  -en \"rd_p${i}_vld\" -d \"rd_p${i}_addr\" -q rd_p${i}_addr_d1");
//: }

// assign rd_p0_planar0_idx_w = is_first_running ? 7'b0 :
//                              //(is_last_loop & is_last_pburst & ~is_last_sub_h) ? rd_p0_planar0_ori_idx :
//                              rd_p0_planar0_idx_inc[8 -2:0];
// assign rd_p1_planar0_idx_w = is_first_running ? 7'b1 :
//                              //(is_last_loop & is_last_pburst & ~is_last_sub_h) ? rd_p1_planar0_ori_idx :
//                              rd_p1_planar0_idx_inc[8 -2:0];
// 
// assign rd_p0_planar1_idx_w = is_first_running ? 7'b0 :
//                              //(is_last_loop & is_last_pburst & ~is_last_sub_h) ? rd_p0_planar1_ori_idx :
//                              rd_p0_planar1_idx_inc[8 -2:0];
// assign rd_p1_planar1_idx_w = is_first_running ? 7'b1 :
//                              //(is_last_loop & is_last_pburst & ~is_last_sub_h) ? rd_p1_planar1_ori_idx :
//                              rd_p1_planar1_idx_inc[8 -2:0];

assign rd_planar0_en = is_first_running | (rd_vld & ~rd_planar_cnt);
assign rd_planar1_en = is_first_running | (rd_vld & rd_planar_cnt);

assign rd_planar0_ori_en = is_first_running;
assign rd_planar1_ori_en = is_first_running;

//////// status logic /////////
//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $atmm_num = ($dmaif / $atmm);
//: foreach my $i(0..$atmm_num -1) {
//:     print qq(
//:         assign {mon_data_planar0_p${i}_cnt_w, data_planar0_p${i}_cnt_w} = data_planar0_cur_cnt + data_planar0_add * (${i}+1);
//:         assign {mon_data_planar1_p${i}_cnt_w, data_planar1_p${i}_cnt_w} = data_planar1_cur_cnt + data_planar1_add * (${i}+1);
//: 
//:         assign data_planar0_p${i}_cur_flag[0] = (data_planar0_p${i}_cnt_w > data_width_mark_0);
//:         assign data_planar0_p${i}_cur_flag[1] = (data_planar0_p${i}_cnt_w > data_width_mark_1);
//:         assign data_planar0_p${i}_cur_flag[2] = (data_planar0_p${i}_cnt_w > data_width_mark_2);
//:         assign data_planar1_p${i}_cur_flag[0] = (data_planar1_p${i}_cnt_w > data_width_mark_0);
//:         assign data_planar1_p${i}_cur_flag[1] = (data_planar1_p${i}_cnt_w > data_width_mark_1);
//:         assign data_planar1_p${i}_cur_flag[2] = (data_planar1_p${i}_cnt_w > data_width_mark_2);
//: 
//:     );
//: }


//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $atmm_num = ($dmaif / $atmm);
//: if($atmm_num == 1) {
//:     print qq(
//:         assign data_planar0_cur_cnt_w = (is_first_running | rd_planar0_line_end) ? 14'b0 : data_planar0_p0_cnt_w;
//:         assign data_planar1_cur_cnt_w = (is_first_running | rd_planar1_line_end) ? 14'b0 : data_planar1_p0_cnt_w;
//:     );
//: } elsif($atmm_num == 2) {
//:     print qq(
//:         assign data_planar0_cur_cnt_w = (is_first_running | rd_planar0_line_end) ? 14'b0 : (rd_p1_vld) ? data_planar0_p1_cnt_w : data_planar0_p0_cnt_w;
//:         assign data_planar1_cur_cnt_w = (is_first_running | rd_planar1_line_end) ? 14'b0 : (rd_p1_vld) ? data_planar1_p1_cnt_w : data_planar1_p0_cnt_w;
//:     );
//: } elsif($atmm_num == 4) {
//:     print qq(
//:         assign data_planar0_cur_cnt_w = (is_first_running | rd_planar0_line_end) ? 14'b0 : (rd_p3_vld) ? data_planar0_p3_cnt_w : 
//:                                                                                            (rd_p2_vld) ? data_planar0_p2_cnt_w : 
//:                                                                                            (rd_p1_vld) ? data_planar0_p1_cnt_w : data_planar0_p0_cnt_w;
//:         assign data_planar1_cur_cnt_w = (is_first_running | rd_planar1_line_end) ? 14'b0 : (rd_p3_vld) ? data_planar1_p3_cnt_w : 
//:                                                                                            (rd_p2_vld) ? data_planar1_p2_cnt_w : 
//:                                                                                            (rd_p1_vld) ? data_planar1_p1_cnt_w : data_planar1_p0_cnt_w;
//:     );
//: }
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"data_planar0_en\"    -d \"data_planar0_cur_cnt_w\" -q data_planar0_cur_cnt");
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"data_planar1_en\"    -d \"data_planar1_cur_cnt_w\" -q data_planar1_cur_cnt");
///// assign data_planar0_cur_cnt_w = (is_first_running | rd_planar0_line_end) ? 14'b0 : (rd_p1_vld) ? data_planar0_p1_cnt_w : data_planar0_p0_cnt_w;
///// assign data_planar1_cur_cnt_w = (is_first_running | rd_planar1_line_end) ? 14'b0 : (rd_p1_vld) ? data_planar1_p1_cnt_w : data_planar1_p0_cnt_w;

//: my $dmaif = NVDLA_CDMA_DMAIF_BW/NVDLA_BPE;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmm_num = ($dmaif / $atmm);
//: if($atmm_num == 2) {
//:     print qq(
//:         assign data_planar0_p1_flag_w = (is_first_running | rd_planar0_line_end) ? 3'b0 : data_planar0_p1_cur_flag; 
//:         assign data_planar1_p1_flag_w = (is_first_running | rd_planar1_line_end) ? 3'b0 : data_planar1_p1_cur_flag; 
//:     );
//:     &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"data_planar0_en\"  -d \"data_planar0_p1_flag_w\" -q data_planar0_p1_flag");
//:     &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"data_planar1_en\"  -d \"data_planar1_p1_flag_w\" -q data_planar1_p1_flag");
//: }
///////////////////////////////

//: my $dmaif = NVDLA_CDMA_DMAIF_BW/NVDLA_BPE;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmm_num = ($dmaif / $atmm);
//: if($atmm_num == 1) {
//:     print qq(
//:         wire    [1:0]   data_planar0_p0_flag_nex;
//:         wire    [1:0]   data_planar1_p0_flag_nex;
//:         wire    [13:0]  data_planar0_cnt_sub;
//:         wire            mon_data_planar0_cnt_sub;
//:         assign {mon_data_planar0_cnt_sub,data_planar0_cnt_sub[13:0]} = (data_planar0_p0_cnt_w - {8'd0,data_planar0_add});
//:         assign data_planar0_p0_flag_nex[0] = data_planar0_cnt_sub > data_width_mark_0;
//:         assign data_planar0_p0_flag_nex[1] = data_planar0_cnt_sub > data_width_mark_1;
//:         //assign data_planar0_p0_flag_nex[0] = (data_planar0_p0_cnt_w - data_planar0_add) > data_width_mark_0;
//:         //assign data_planar0_p0_flag_nex[1] = (data_planar0_p0_cnt_w - data_planar0_add) > data_width_mark_1;
//:         assign data_planar0_p0_lp_mask = ~data_planar0_p0_cur_flag[0] ? {${atmm}{1'b1}} : 
//:                                          ~data_planar0_p0_flag_nex[0] ? ~({${atmm}{1'b1}} << lp_planar0_mask_sft) : {${atmm}{1'b0}};
//:         assign data_planar0_p0_rp_mask = ~data_planar0_p0_cur_flag[1] ? {${atmm}{1'b0}} : 
//:                                          ~data_planar0_p0_flag_nex[1] ? ({${atmm}{1'b1}} << rp_planar0_mask_sft) : {${atmm}{1'b1}};
//:         assign data_planar0_p0_zero_mask = ~data_planar0_p0_cur_flag[2] ? {${atmm}{1'b0}} : ({${atmm}{1'b1}} << zero_planar0_mask_sft);
//:         assign data_planar0_p0_pad_mask = (data_planar0_p0_lp_mask | data_planar0_p0_rp_mask) & ~data_planar0_p0_zero_mask;
//:         
//:         wire    [13:0]  data_planar1_cnt_sub;
//:         wire            mon_data_planar1_cnt_sub;
//:         assign {mon_data_planar1_cnt_sub,data_planar1_cnt_sub[13:0]} = (data_planar1_p0_cnt_w - {8'd0,data_planar1_add});
//:         assign data_planar1_p0_flag_nex[0] = data_planar1_cnt_sub > data_width_mark_0;
//:         assign data_planar1_p0_flag_nex[1] = data_planar1_cnt_sub > data_width_mark_1;
//:         //assign data_planar1_p0_flag_nex[0] = (data_planar1_p0_cnt_w - data_planar1_add) > data_width_mark_0;
//:         //assign data_planar1_p0_flag_nex[1] = (data_planar1_p0_cnt_w - data_planar1_add) > data_width_mark_1;
//:
//:         assign data_planar1_p0_lp_mask = ~data_planar1_p0_cur_flag[0] ? {${atmm}{1'b1}} : 
//:                                          ~data_planar1_p0_flag_nex[0] ? ~({${atmm}{1'b1}} << lp_planar1_mask_sft) : {${atmm}{1'b0}};
//:         assign data_planar1_p0_rp_mask = ~data_planar1_p0_cur_flag[1] ? {${atmm}{1'b0}} : 
//:                                          ~data_planar1_p0_flag_nex[1] ? ({${atmm}{1'b1}} << rp_planar1_mask_sft) : {${atmm}{1'b1}};
//:         assign data_planar1_p0_zero_mask = ~data_planar1_p0_cur_flag[2] ? {${atmm}{1'b0}} : ({${atmm}{1'b1}} << zero_planar1_mask_sft);
//:         assign data_planar1_p0_pad_mask = (data_planar1_p0_lp_mask | data_planar1_p0_rp_mask) & ~data_planar1_p0_zero_mask;
//:     );
//: } elsif ($atmm_num == 2) {
//:     print qq(
//:         assign data_planar0_p0_lp_mask = ~data_planar0_p0_cur_flag[0] ? {${atmm}{1'b1}} : 
//:                                          (~data_planar0_p1_flag[0] & data_planar0_p0_cur_flag[0]) ? ~({${atmm}{1'b1}} << lp_planar0_mask_sft) : {${atmm}{1'b0}};
//:         assign data_planar0_p0_rp_mask = ~data_planar0_p0_cur_flag[1] ? {${atmm}{1'b0}} :
//:                                          (~data_planar0_p1_flag[1] & data_planar0_p0_cur_flag[1]) ? ({${atmm}{1'b1}} << rp_planar0_mask_sft) :  {${atmm}{1'b1}};
//:         assign data_planar0_p0_zero_mask = ~data_planar0_p0_cur_flag[2] ? {${atmm}{1'b0}} : ({${atmm}{1'b1}} << zero_planar0_mask_sft);
//:         assign data_planar0_p0_pad_mask = (data_planar0_p0_lp_mask | data_planar0_p0_rp_mask) & ~data_planar0_p0_zero_mask;
//:         
//:         assign data_planar0_p1_lp_mask = ~data_planar0_p1_cur_flag[0] ? {${atmm}{1'b1}} :
//:                                          (~data_planar0_p0_cur_flag[0] & data_planar0_p1_cur_flag[0]) ? ~({${atmm}{1'b1}} << lp_planar0_mask_sft) : {${atmm}{1'b0}};
//:         assign data_planar0_p1_rp_mask = ~data_planar0_p1_cur_flag[1] ? {${atmm}{1'b0}} :
//:                                          (~data_planar0_p0_cur_flag[1] & data_planar0_p1_cur_flag[1]) ? ({${atmm}{1'b1}} << rp_planar0_mask_sft) : {${atmm}{1'b1}};
//:         assign data_planar0_p1_zero_mask = ~data_planar0_p1_cur_flag[2] ? {${atmm}{1'b0}} :
//:                                            data_planar0_p0_cur_flag[2] ? {${atmm}{1'b1}} : ({${atmm}{1'b1}} << zero_planar0_mask_sft);
//:         assign data_planar0_p1_pad_mask = (data_planar0_p1_lp_mask | data_planar0_p1_rp_mask) & ~data_planar0_p1_zero_mask;
//:         
//:         assign data_planar1_p0_lp_mask = ~data_planar1_p0_cur_flag[0] ? {${atmm}{1'b1}} :
//:                                          (~data_planar1_p1_flag[0] ) ? ~({${atmm}{1'b1}} << lp_planar1_mask_sft) : {${atmm}{1'b0}};
//:         assign data_planar1_p0_rp_mask = ~data_planar1_p0_cur_flag[1] ? {${atmm}{1'b0}} :
//:                                          (~data_planar1_p1_flag[1] ) ? ({${atmm}{1'b1}} << rp_planar1_mask_sft) : {${atmm}{1'b1}};
//:         assign data_planar1_p0_zero_mask = ~data_planar1_p0_cur_flag[2] ? {${atmm}{1'b0}} : ({${atmm}{1'b1}} << zero_planar1_mask_sft);
//:         assign data_planar1_p0_pad_mask = (data_planar1_p0_lp_mask | data_planar1_p0_rp_mask) & ~data_planar1_p0_zero_mask;
//:         
//:         assign data_planar1_p1_lp_mask = ~data_planar1_p1_cur_flag[0] ? {${atmm}{1'b1}} :
//:                                          (~data_planar1_p0_cur_flag[0] & data_planar1_p1_cur_flag[0]) ? ~({${atmm}{1'b1}} << lp_planar1_mask_sft) : {${atmm}{1'b0}};
//:         assign data_planar1_p1_rp_mask = ~data_planar1_p1_cur_flag[1] ? {${atmm}{1'b0}} :
//:                                          (~data_planar1_p0_cur_flag[1] & data_planar1_p1_cur_flag[1]) ? ({${atmm}{1'b1}} << rp_planar1_mask_sft) : {${atmm}{1'b1}};
//:         assign data_planar1_p1_zero_mask = ~data_planar1_p1_cur_flag[2] ? {${atmm}{1'b0}} :
//:                                            data_planar1_p0_cur_flag[2] ? {${atmm}{1'b1}} : ({${atmm}{1'b1}} << zero_planar1_mask_sft);
//:         assign data_planar1_p1_pad_mask = (data_planar1_p1_lp_mask | data_planar1_p1_rp_mask) & ~data_planar1_p1_zero_mask;
//:     );
//: } elsif ($atmm_num == 4) {
//:     print qq(
//:     );
//: }
//: foreach my $i (0..$atmm_num -1) {
//:     print qq(
//:     assign rd_p${i}_pad_mask  = ~rd_planar_cnt ? data_planar0_p${i}_pad_mask : data_planar1_p${i}_pad_mask;
//:     assign rd_p${i}_zero_mask = ~rd_planar_cnt ? data_planar0_p${i}_zero_mask : data_planar1_p${i}_zero_mask;
//:     );
//: &eperl::flop("-nodeclare  -norst   -en \"rd_vld\"  -d \"rd_p${i}_pad_mask\"  -q rd_p${i}_pad_mask_d1");
//: &eperl::flop("-nodeclare  -norst   -en \"rd_vld\"  -d \"rd_p${i}_zero_mask\" -q rd_p${i}_zero_mask_d1");
//: print " //assign img2sbuf_p${i}_rd_en = rd_p${i}_vld_d1;  \n";
//: print " //assign img2sbuf_p${i}_rd_addr = rd_p${i}_addr_d1;  \n";
//: }
assign data_planar0_en = is_first_running | (rd_vld & ~rd_planar_cnt);
assign data_planar1_en = is_first_running | (rd_vld & rd_planar_cnt);
//assign data_planar0_ori_en = is_first_running;
//assign data_planar1_ori_en = is_first_running;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"rd_vld\"      -d \"rd_planar_cnt\" -q rd_planar_d1");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"rd_vld\" -d \"rd_sub_h_cnt\" -q rd_sub_h_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"rd_vld\"      -d \"rd_sub_h_end\" -q rd_sub_h_end_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"rd_vld\"      -d \"rd_loop_end\" -q rd_loop_end_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"rd_vld\"      -d \"(is_last_pburst & is_last_planar & is_last_loop & img_line_end)\" -q rd_one_line_end_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"rd_vld\"      -d \"is_1st_height\" -q rd_1st_height_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"rd_vld\"      -d \"img_layer_end & rd_height_end\" -q rd_layer_end_d1");

////////////////////////////////////////////////////////////////////////
// connect to shared buffer                                           //
////////////////////////////////////////////////////////////////////////
//: my $dmaif = NVDLA_CDMA_DMAIF_BW/NVDLA_BPE;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmm_num = ($dmaif / $atmm);
//: foreach my $i (0..$atmm_num -1) {
//: print " assign img2sbuf_p${i}_rd_en = rd_p${i}_vld_d1;  \n";
//: print " assign img2sbuf_p${i}_rd_addr = rd_p${i}_addr_d1;  \n";
//: }

////////////////////////////////////////////////////////////////////////
// pipeline register for shared buffer read latency                   //
////////////////////////////////////////////////////////////////////////
//: my $dmaif = NVDLA_CDMA_DMAIF_BW/NVDLA_BPE;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmm_num = ($dmaif / $atmm);
//: my $i;
//: my $j;
//: my $limit = 1 + CDMA_SBUF_RD_LATENCY;
//: for($i = 1; $i < $limit; $i ++) {
//:     $j = $i + 1;
//: &eperl::flop("-wid 1    -rval \"1'b0\"                            -d \"rd_vld_d${i}\"          -q rd_vld_d${j}");
//: &eperl::flop("-wid 1    -rval \"1'b0\"       -en \"rd_vld_d${i}\" -d \"rd_planar_d${i}\"       -q rd_planar_d${j}");
//: &eperl::flop("-wid 3    -rval \"{3{1'b0}}\"  -en \"rd_vld_d${i}\" -d \"rd_sub_h_d${i}\"        -q rd_sub_h_d${j}");
//: &eperl::flop("-wid 1    -rval \"1'b0\"       -en \"rd_vld_d${i}\" -d \"rd_sub_h_end_d${i}\"    -q rd_sub_h_end_d${j}");
//: &eperl::flop("-wid 1    -rval \"1'b0\"       -en \"rd_vld_d${i}\" -d \"rd_loop_end_d${i}\"     -q rd_loop_end_d${j}");
//: &eperl::flop("-wid 1    -rval \"1'b0\"       -en \"rd_vld_d${i}\" -d \"rd_one_line_end_d${i}\" -q rd_one_line_end_d${j}");
//: &eperl::flop("-wid 1    -rval \"1'b0\"       -en \"rd_vld_d${i}\" -d \"rd_1st_height_d${i}\"   -q rd_1st_height_d${j}");
//: &eperl::flop("-wid 1    -rval \"1'b0\"       -en \"rd_vld_d${i}\" -d \"rd_layer_end_d${i}\"    -q rd_layer_end_d${j}");
//:     foreach my $k (0..$atmm_num -1) {
//:     &eperl::flop("-wid $atmm   -norst    -en \"rd_vld_d${i}\" -d \"rd_p${k}_pad_mask_d${i}\"  -q rd_p${k}_pad_mask_d${j}");
//:     &eperl::flop("-wid $atmm   -norst    -en \"rd_vld_d${i}\" -d \"rd_p${k}_zero_mask_d${i}\" -q rd_p${k}_zero_mask_d${j}");
//:     }
//: }
//: 
//: $i = $limit;
//: print qq (
//: assign pk_rsp_vld           = rd_vld_d${i};
//: assign pk_rsp_planar        = rd_planar_d${i};
//: assign pk_rsp_sub_h         = rd_sub_h_d${i};
//: assign pk_rsp_sub_h_end     = rd_sub_h_end_d${i};
//: assign pk_rsp_loop_end      = rd_loop_end_d${i};
//: assign pk_rsp_one_line_end  = rd_one_line_end_d${i};
//: assign pk_rsp_1st_height    = rd_1st_height_d${i};
//: assign pk_rsp_layer_end     = rd_layer_end_d${i};
//: );
//:     foreach my $k (0..$atmm_num -1) {
//:     print qq(
//:         assign pk_rsp_p${k}_pad_mask   = rd_p${k}_pad_mask_d${i};
//:         assign pk_rsp_p${k}_zero_mask  = rd_p${k}_zero_mask_d${i};
//:     );
//:     }

assign pk_rsp_early_end = pixel_early_end & pk_rsp_one_line_end;
assign pk_rsp_vld_d1_w = pk_rsp_vld & pixel_planar & ~(pk_rsp_early_end);

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"pk_rsp_vld_d1_w\" -q pk_rsp_vld_d1");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"pk_rsp_vld_d1_w\" -d \"pk_rsp_sub_h\" -q pk_rsp_sub_h_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pk_rsp_vld_d1_w\" -d \"pk_rsp_sub_h_end\" -q pk_rsp_sub_h_end_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pk_rsp_vld_d1_w\" -d \"pk_rsp_loop_end\" -q pk_rsp_loop_end_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pk_rsp_vld_d1_w\" -d \"pk_rsp_one_line_end\" -q pk_rsp_one_line_end_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pk_rsp_vld_d1_w\" -d \"pk_rsp_1st_height\" -q pk_rsp_1st_height_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pk_rsp_vld_d1_w\" -d \"pk_rsp_layer_end\" -q pk_rsp_layer_end_d1");

////////////////////////////////////////////////////////////////////////
//  connect to sbuf ram input                                         //
////////////////////////////////////////////////////////////////////////
//: my $dmaif = NVDLA_CDMA_DMAIF_BW/NVDLA_BPE;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmm_num = ($dmaif / $atmm);
//: foreach my $k (0..$atmm_num -1) {
//:     print qq(
//:         assign pk_rsp_p${k}_data = img2sbuf_p${k}_rd_data;
//:     );
//: }

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

assign pk_rsp_wr_vld = pk_rsp_cur_vld;

assign {mon_pk_rsp_wr_cnt_w,
        pk_rsp_wr_cnt_w} = (is_first_running | ~pk_rsp_planar) ? 3'b0 : pk_rsp_wr_cnt + 1'b1;
//: &eperl::flop("-nodeclare   -rval \"{2{1'b0}}\"  -en \"pk_rsp_vld\" -d \"pk_rsp_wr_cnt_w\" -q pk_rsp_wr_cnt");

//assign pk_rsp_wr_size_ori = pixel_packed_10b ? 3'h4 : 3'h2;
//assign pk_rsp_wr_mask = pixel_packed_10b ? 4'hf : 4'h3;

//: my $dmaif = NVDLA_CDMA_DMAIF_BW/NVDLA_BPE;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmm_num = ($dmaif / $atmm);
//: print qq(
//: assign pk_rsp_wr_size_ori = 3'h${atmm_num};//3'h2
//: assign pk_rsp_wr_mask = {{(4-${atmm_num}){1'b0}},{${atmm_num}{1'b1}}};//4'h3;
//: );

////assign pk_rsp_wr_ext64 = (pk_rsp_cur_one_line_end & (pk_rsp_wr_sub_addr == 2'h2) & pixel_data_shrink & ~pixel_packed_10b);
////assign pk_rsp_wr_ext128 = (pk_rsp_cur_one_line_end & ~pk_rsp_wr_sub_addr[1] & (pixel_data_shrink | (~pixel_data_expand & ~pixel_packed_10b)));
////assign pk_out_interleave = 1'b0;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"pk_rsp_wr_vld\" -q pk_out_vld");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"pk_rsp_wr_vld\" -d \"pk_rsp_cur_sub_h\" -q pk_out_sub_h");
//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"is_first_running\" -d \"pk_rsp_wr_mask\" -q pk_out_mask");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"is_first_running\" -d \"sg2pack_mn_enable\" -q pk_out_mean");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"is_first_running\" -d \"pixel_uint\" -q pk_out_uint");
////: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pk_rsp_wr_vld\" -d \"pk_rsp_wr_ext64\" -q pk_out_ext64");
////: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pk_rsp_wr_vld\" -d \"pk_rsp_wr_ext128\" -q pk_out_ext128");

// PKT_PACK_WIRE( nvdla_ram_info ,  pk_out_ ,  pk_out_info_pd )
assign pk_out_info_pd[3:0] =     pk_out_mask[3:0];
assign pk_out_info_pd[4] =     1'b0;//pk_out_interleave ;
assign pk_out_info_pd[5] =     1'b0;//pk_out_ext64 ;
assign pk_out_info_pd[6] =     1'b0;//pk_out_ext128 ;
assign pk_out_info_pd[7] =     pk_out_mean ;
assign pk_out_info_pd[8] =     pk_out_uint ;
assign pk_out_info_pd[11:9] =     pk_out_sub_h[2:0];

////////////////////////////////////////////////////////////////////////
// data output logic                                                  //
////////////////////////////////////////////////////////////////////////
//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $atmm_num = ($dmaif / $atmm);
//: if($atmm_num == 1) {
//:     print qq(
//:         assign rdat = pk_rsp_p0_data;
//:         assign mask_zero = {pk_rsp_p0_zero_mask};
//:         assign mask_pad  = {pk_rsp_p0_pad_mask};
//:     );
//: } elsif($atmm_num == 2) {
//:     print qq(
//:         assign rdat = {pk_rsp_p1_data, pk_rsp_p0_data};
//:         assign mask_zero = {pk_rsp_p1_zero_mask, pk_rsp_p0_zero_mask};
//:         assign mask_pad = {pk_rsp_p1_pad_mask, pk_rsp_p0_pad_mask};
//:     );
//: } elsif($atmm_num == 4) {
//:     print qq(
//:         assign rdat = {pk_rsp_p3_data, pk_rsp_p2_data, pk_rsp_p1_data, pk_rsp_p0_data};
//:         assign mask_zero = {pk_rsp_p3_zero_mask, pk_rsp_p2_zero_mask, pk_rsp_p1_zero_mask, pk_rsp_p0_zero_mask};
//:         assign mask_pad =  {pk_rsp_p3_pad_mask,  pk_rsp_p2_pad_mask,  pk_rsp_p1_pad_mask,  pk_rsp_p0_pad_mask};
//:     );
//: }

//assign z14 = 14'b0;
//assign z6 = 6'b0;
assign pk_rsp_dat_normal = rdat;
////assign pk_rsp_dat_ergb = {rdat[15*32+31:15*32+30], z14, rdat[15*32+29:15*32+20], z6, rdat[15*32+19:15*32+10], z6,rdat[15*32+9:15*32], z6, 
////                          rdat[14*32+31:14*32+30], z14, rdat[14*32+29:14*32+20], z6, rdat[14*32+19:14*32+10], z6,rdat[14*32+9:14*32], z6, 
////                          rdat[13*32+31:13*32+30], z14, rdat[13*32+29:13*32+20], z6, rdat[13*32+19:13*32+10], z6,rdat[13*32+9:13*32], z6, 
////                          rdat[12*32+31:12*32+30], z14, rdat[12*32+29:12*32+20], z6, rdat[12*32+19:12*32+10], z6,rdat[12*32+9:12*32], z6, 
////                          rdat[11*32+31:11*32+30], z14, rdat[11*32+29:11*32+20], z6, rdat[11*32+19:11*32+10], z6,rdat[11*32+9:11*32], z6, 
////                          rdat[10*32+31:10*32+30], z14, rdat[10*32+29:10*32+20], z6, rdat[10*32+19:10*32+10], z6,rdat[10*32+9:10*32], z6,
////                          rdat[9*32+31:9*32+30], z14, rdat[9*32+29:9*32+20], z6, rdat[9*32+19:9*32+10], z6,rdat[9*32+9:9*32], z6,
////                          rdat[8*32+31:8*32+30], z14, rdat[8*32+29:8*32+20], z6, rdat[8*32+19:8*32+10], z6,rdat[8*32+9:8*32], z6,
////                          rdat[7*32+31:7*32+30], z14, rdat[7*32+29:7*32+20], z6, rdat[7*32+19:7*32+10], z6,rdat[7*32+9:7*32], z6, 
////                          rdat[6*32+31:6*32+30], z14, rdat[6*32+29:6*32+20], z6, rdat[6*32+19:6*32+10], z6,rdat[6*32+9:6*32], z6,
////                          rdat[5*32+31:5*32+30], z14, rdat[5*32+29:5*32+20], z6, rdat[5*32+19:5*32+10], z6,rdat[5*32+9:5*32], z6,
////                          rdat[4*32+31:4*32+30], z14, rdat[4*32+29:4*32+20], z6, rdat[4*32+19:4*32+10], z6,rdat[4*32+9:4*32], z6,
////                          rdat[3*32+31:3*32+30], z14, rdat[3*32+29:3*32+20], z6, rdat[3*32+19:3*32+10], z6,rdat[3*32+9:3*32], z6,
////                          rdat[2*32+31:2*32+30], z14, rdat[2*32+29:2*32+20], z6, rdat[2*32+19:2*32+10], z6,rdat[2*32+9:2*32], z6,
////                          rdat[1*32+31:1*32+30], z14, rdat[1*32+29:1*32+20], z6, rdat[1*32+19:1*32+10], z6,rdat[1*32+9:1*32], z6,
////                          rdat[0*32+31:0*32+30], z14, rdat[0*32+29:0*32+20], z6, rdat[0*32+19:0*32+10], z6,rdat[0*32+9:0*32], z6};
/////: for(my $i = 0; $i < 16; $i ++) {
/////:     my $b0 = sprintf("%3d", ($i * 64));
/////:     my $b1 = sprintf("%3d", ($i * 64 + 63));
/////:     my $b2 = $i * 4;
/////:     print "assign pk_rsp_dat_mergb[${b1}:${b0}] = (~pixel_packed_10b | mask_zero[${b2}] | mask_pad[${b2}]) ? 64'b0 : pk_rsp_dat_ergb[${b1}:${b0}];\n";
/////: }
/////: print "\n\n\n";
/////: 

//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $bpe = NVDLA_BPE;
//: my $ele_num = int($dmaif/$bpe);
//: for(my $i = 0; $i < $ele_num; $i ++) {
//:     my $b0 = sprintf("%3d", ($i * $bpe));
//:     my $b1 = sprintf("%3d", ($i * $bpe + $bpe -1));
//:     print qq( assign pk_rsp_dat_mnorm[${b1}:${b0}] = (pixel_packed_10b | mask_zero[${i}] | mask_pad[${i}]) ? ${bpe}'b0 : pk_rsp_dat_normal[${b1}:${b0}]; \n);
//: }
//: print "\n\n\n";

assign dat_l0    = pk_rsp_planar0_c0_d1;
assign dat_l1_lo = pk_rsp_planar1_c0_en ? pk_rsp_dat_mnorm : pk_rsp_planar1_c0_d1;
assign dat_l1_hi = pk_rsp_planar1_c1_en ? pk_rsp_dat_mnorm : pk_rsp_planar1_c1_d1;
assign dat_l1    = {dat_l1_hi, dat_l1_lo};

assign dat_8b_yuv = {
//: my $bpe = NVDLA_BPE;
//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $m = ($dmaif/$bpe);
//: foreach my $i(0..$m -2) {
//: my $k = $m -$i -1;
//:     print " dat_l1[${k}*2*${bpe}+2*${bpe}-1:${k}*2*${bpe}], dat_l0[${k}*${bpe}+${bpe}-1:${k}*${bpe}],    \n"; 
//: }
//:     print " dat_l1[2*${bpe}-1:0], dat_l0[${bpe}-1:0]}; \n";
assign dat_yuv = dat_8b_yuv;

assign pk_rsp_out_sel[0] = (pixel_packed_10b);
assign pk_rsp_out_sel[1] = (~pixel_planar & ~pixel_packed_10b);
assign pk_rsp_out_sel[2] = (pixel_planar & (pk_rsp_wr_cnt == 2'h0));
assign pk_rsp_out_sel[3] = (pixel_planar & (pk_rsp_wr_cnt == 2'h1));
assign pk_rsp_out_sel[4] = (pixel_planar & (pk_rsp_wr_cnt == 2'h2));

//assign pk_rsp_data_h1 = pk_rsp_dat_mergb[1023:512];
assign pk_rsp_data_h0 = //({256*2{pk_rsp_out_sel[0]}} & pk_rsp_dat_mergb[511:0]) |
                        ({NVDLA_CDMA_DMAIF_BW{pk_rsp_out_sel[1]}} & pk_rsp_dat_mnorm) |
                        ({NVDLA_CDMA_DMAIF_BW{pk_rsp_out_sel[2]}} & dat_yuv[NVDLA_CDMA_DMAIF_BW-1:0]) |
                        ({NVDLA_CDMA_DMAIF_BW{pk_rsp_out_sel[3]}} & dat_yuv[NVDLA_CDMA_DMAIF_BW*2-1:NVDLA_CDMA_DMAIF_BW]) |
                        ({NVDLA_CDMA_DMAIF_BW{pk_rsp_out_sel[4]}} & dat_yuv[NVDLA_CDMA_DMAIF_BW*3-1:NVDLA_CDMA_DMAIF_BW*2]);

assign pk_rsp_pad_mask_norm = mask_pad;
//assign pk_rsp_pad_mask_ergb = {{2{mask_pad[63]}}, {2{mask_pad[62]}}, {2{mask_pad[61]}}, {2{mask_pad[60]}}, {2{mask_pad[59]}}, {2{mask_pad[58]}}, {2{mask_pad[57]}}, {2{mask_pad[56]}}, {2{mask_pad[55]}}, {2{mask_pad[54]}}, {2{mask_pad[53]}}, {2{mask_pad[52]}}, {2{mask_pad[51]}}, {2{mask_pad[50]}}, {2{mask_pad[49]}}, {2{mask_pad[48]}}, {2{mask_pad[47]}}, {2{mask_pad[46]}}, {2{mask_pad[45]}}, {2{mask_pad[44]}}, {2{mask_pad[43]}}, {2{mask_pad[42]}}, {2{mask_pad[41]}}, {2{mask_pad[40]}}, {2{mask_pad[39]}}, {2{mask_pad[38]}}, {2{mask_pad[37]}}, {2{mask_pad[36]}}, {2{mask_pad[35]}}, {2{mask_pad[34]}}, {2{mask_pad[33]}}, {2{mask_pad[32]}}, {2{mask_pad[31]}}, {2{mask_pad[30]}}, {2{mask_pad[29]}}, {2{mask_pad[28]}}, {2{mask_pad[27]}}, {2{mask_pad[26]}}, {2{mask_pad[25]}}, {2{mask_pad[24]}}, {2{mask_pad[23]}}, {2{mask_pad[22]}}, {2{mask_pad[21]}}, {2{mask_pad[20]}}, {2{mask_pad[19]}}, {2{mask_pad[18]}}, {2{mask_pad[17]}}, {2{mask_pad[16]}}, {2{mask_pad[15]}}, {2{mask_pad[14]}}, {2{mask_pad[13]}}, {2{mask_pad[12]}}, {2{mask_pad[11]}}, {2{mask_pad[10]}}, {2{mask_pad[9]}}, {2{mask_pad[8]}}, {2{mask_pad[7]}}, {2{mask_pad[6]}}, {2{mask_pad[5]}}, {2{mask_pad[4]}}, {2{mask_pad[3]}}, {2{mask_pad[2]}}, {2{mask_pad[1]}}, {2{mask_pad[0]}}};

assign pad_mask_l0 = mask_pad_planar0_c0_d1;
assign pad_mask_l1_lo = pk_rsp_planar1_c0_en ? mask_pad :  mask_pad_planar1_c0_d1;
assign pad_mask_l1_hi = pk_rsp_planar1_c1_en ? mask_pad :  mask_pad_planar1_c1_d1;
assign pad_mask_l1 = {pad_mask_l1_hi, pad_mask_l1_lo};

assign pad_mask_8b_yuv = {
//: my $bpe = NVDLA_BPE;
//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $m = ($dmaif/$bpe);
//: my $byte = NVDLA_BPE/8;
//: foreach my $i(0..$m -2) {
//: my $k = $m -$i -1;
//:     print " {pad_mask_l1[${k}*2*${byte}+2*${byte}-1:${k}*2*${byte}], pad_mask_l0[${k}*${byte}+${byte}-1:${k}*${byte}]},    \n"; 
//: }
//:     print " {pad_mask_l1[2*${byte}-1:0], pad_mask_l0[${byte}-1:0]}}; \n";
assign pad_mask_yuv = pad_mask_8b_yuv;

//assign pk_rsp_pad_mask_h1 = pixel_packed_10b ? pk_rsp_pad_mask_ergb[127:64] : 64'b0;
//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $bpe = NVDLA_BPE;
//: my $ele_num = int( $dmaif/$bpe );
//: print qq(
//:     assign pk_rsp_pad_mask_h0 = //({64{pk_rsp_out_sel[0]}} & pk_rsp_pad_mask_ergb[63:0]) |
//:                                 ({${ele_num}{pk_rsp_out_sel[1]}} & pk_rsp_pad_mask_norm) |
//:                                 ({${ele_num}{pk_rsp_out_sel[2]}} & pad_mask_yuv[${ele_num}-1:0]) |
//:                                 ({${ele_num}{pk_rsp_out_sel[3]}} & pad_mask_yuv[${ele_num}*2-1:${ele_num}]) |
//:                                 ({${ele_num}{pk_rsp_out_sel[4]}} & pad_mask_yuv[${ele_num}*3-1:${ele_num}*2]);
//: );
assign pk_rsp_planar0_c0_en = (pk_rsp_vld & pixel_planar & ~pk_rsp_planar);
assign pk_rsp_planar1_c0_en = (pk_rsp_vld & pixel_planar & pk_rsp_planar & (pk_rsp_wr_cnt == 2'h0));
assign pk_rsp_planar1_c1_en = (pk_rsp_vld & pixel_planar & pk_rsp_planar & (pk_rsp_wr_cnt == 2'h1));
assign pk_rsp_data_h0_en = pk_rsp_wr_vld;
//assign pk_rsp_data_h1_en = pk_rsp_wr_vld & pixel_packed_10b;

//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $bpe = NVDLA_BPE;
//: my $ele_num = int($dmaif/$bpe);
//: &eperl::flop("-nodeclare   -rval \"{${dmaif}{1'b0}}\"  -en \"pk_rsp_planar0_c0_en\" -d \"pk_rsp_dat_mnorm\" -q pk_rsp_planar0_c0_d1");
//: &eperl::flop("-nodeclare   -rval \"{${dmaif}{1'b0}}\"  -en \"pk_rsp_planar1_c0_en\" -d \"pk_rsp_dat_mnorm\" -q pk_rsp_planar1_c0_d1");
//: &eperl::flop("-nodeclare   -rval \"{${dmaif}{1'b0}}\"  -en \"pk_rsp_planar1_c1_en\" -d \"pk_rsp_dat_mnorm\" -q pk_rsp_planar1_c1_d1");
//: &eperl::flop("-nodeclare   -rval \"{${ele_num}{1'b0}}\"  -en \"pk_rsp_planar0_c0_en\" -d \"mask_pad\" -q mask_pad_planar0_c0_d1");
//: &eperl::flop("-nodeclare   -rval \"{${ele_num}{1'b0}}\"  -en \"pk_rsp_planar1_c0_en\" -d \"mask_pad\" -q mask_pad_planar1_c0_d1");
//: &eperl::flop("-nodeclare   -rval \"{${ele_num}{1'b0}}\"  -en \"pk_rsp_planar1_c1_en\" -d \"mask_pad\" -q mask_pad_planar1_c1_d1");
//: &eperl::flop("-nodeclare  -norst -en \"pk_rsp_data_h0_en\" -d \"pk_rsp_data_h0\" -q pk_out_data_h0");
//: &eperl::flop("-nodeclare   -rval \"{${ele_num}{1'b0}}\"  -en \"pk_rsp_data_h0_en\" -d \"pk_rsp_pad_mask_h0\" -q pk_out_pad_mask_h0");
// //: &eperl::flop("-nodeclare  -norst -en \"pk_rsp_data_h1_en\" -d \"pk_rsp_data_h1\" -q pk_out_data_h1");
// //: &eperl::flop("-nodeclare   -rval \"{64{1'b0}}\"  -en \"pk_rsp_data_h1_en | is_first_running\" -d \"pk_rsp_pad_mask_h1\" -q pk_out_pad_mask_h1");

//assign pk_out_data = {pk_out_data_h1, pk_out_data_h0};
assign pk_out_data = pk_out_data_h0;
//assign pk_out_pad_mask = {pk_out_pad_mask_h1, pk_out_pad_mask_h0};
assign pk_out_pad_mask = pk_out_pad_mask_h0;

////////////////////////////////////////////////////////////////////////
// mean data replacement and output logic                             //
////////////////////////////////////////////////////////////////////////

assign mn_mask_y = mn_mask_y_d1;
assign mn_mask_uv_lo = mn_mask_uv_0_en ? mask_zero : mn_mask_uv_lo_d1;
assign mn_mask_uv_hi = mn_mask_uv_1_en ? mask_zero : mn_mask_uv_hi_d1;
assign mn_mask_uv = {mn_mask_uv_hi, mn_mask_uv_lo};
assign mn_mask_yuv = {
//: my $dmaif = NVDLA_CDMA_DMAIF_BW/NVDLA_BPE;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmm_num = ($dmaif / $atmm);
//: foreach my $i(0..$atmm-2) {
//:     my $k = $atmm - $i -1;
//:     print qq(
//:                   mn_mask_uv[${k}*2*${atmm_num}+2*${atmm_num}-1:${k}*2*${atmm_num}], mn_mask_y[${k}*${atmm_num}+${atmm_num}-1:${k}*${atmm_num}],
//:     );
//: }
//:     print "       mn_mask_uv[2*${atmm_num}-1:0], mn_mask_y[${atmm_num}-1:0]};  \n";

//assign mn_ch1 = {64{reg2dp_mean_ry}};
//assign mn_ch4 = {16{reg2dp_mean_ax, reg2dp_mean_bv, reg2dp_mean_gu, reg2dp_mean_ry}};
//assign mn_ch3 = {64{reg2dp_mean_bv, reg2dp_mean_gu, reg2dp_mean_ry}};

//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $bpe = NVDLA_BPE;
//: my $bpe3 = (NVDLA_BPE*3);
//: my $Bnum = int($dmaif/$bpe);
//: print qq(
//:     assign mn_ch1 = {${Bnum}{reg2dp_mean_ry[15:0]}};
//:     assign mn_ch4 = {(${Bnum}/4){reg2dp_mean_ax[15:0], reg2dp_mean_bv[15:0], reg2dp_mean_gu[15:0], reg2dp_mean_ry[15:0]}};
//:     assign mn_ch3 = {${Bnum}{reg2dp_mean_bv[15:0], reg2dp_mean_gu[15:0], reg2dp_mean_ry[15:0]}};
//:     assign mn_ch1_4 = ~(|reg2dp_datain_channel) ? mn_ch1 : mn_ch4;
//: );
//: for(my $i = 0; $i < $Bnum; $i ++) {
//:     print "assign mn_8b_mnorm[${i}*16+15:${i}*16] = mask_zero[${i}] ? 16'b0 : mn_ch1_4[${i}*16+15:${i}*16];\n";
//:    ## print "assign mn_8b_myuv[${i}*48+47:${i}*48] = mn_mask_yuv[${i}] ? 48'b0 : mn_ch3[${i}*48+47:${i}*48];\n";
//: }
//: my $Bnum_3 = int( $Bnum * 3 );
//: for(my $i = 0; $i < $Bnum_3; $i ++) {
//:     print "assign mn_8b_myuv[${i}*16+15:${i}*16] = mn_mask_yuv[${i}] ? 16'b0 : mn_ch3[${i}*16+15:${i}*16];\n";
//: }
//: print "\n\n\n";
#ifndef NVDLA_FEATURE_DATA_TYPE_INT8
//: for(my $i = 0; $i < 32; $i ++) {
//:     my $j = $i * 2;
//:     print "assign mn_16b_mnorm[${i}*16+15:${i}*16] = mask_zero[${j}] ? 16'b0 : mn_ch1_4[${i}*16+15:${i}*16];\n";
//:     print "assign mn_16b_myuv[${i}*48+47:${i}*48] = mn_mask_yuv[${j}] ? 48'b0 : mn_ch3[${i}*48+47:${i}*48];\n";
//: }
//: print "\n\n\n";
#endif

assign pk_rsp_mn_sel[0] = ~pixel_planar & (pixel_packed_10b | ~(|pixel_precision));
assign pk_rsp_mn_sel[1] = ~pixel_planar & ~pixel_packed_10b & (|pixel_precision);
assign pk_rsp_mn_sel[2] = pixel_planar & (pk_rsp_wr_cnt == 2'h0) & ~(|pixel_precision);
assign pk_rsp_mn_sel[3] = pixel_planar & (pk_rsp_wr_cnt == 2'h0) & (|pixel_precision);
assign pk_rsp_mn_sel[4] = pixel_planar & (pk_rsp_wr_cnt == 2'h1) & ~(|pixel_precision);
assign pk_rsp_mn_sel[5] = pixel_planar & (pk_rsp_wr_cnt == 2'h1) & (|pixel_precision);
assign pk_rsp_mn_sel[6] = pixel_planar & (pk_rsp_wr_cnt == 2'h2) & ~(|pixel_precision);
assign pk_rsp_mn_sel[7] = pixel_planar & (pk_rsp_wr_cnt == 2'h2) & (|pixel_precision);

//assign pk_rsp_mn_data_h1 = ({256  *2{pk_rsp_mn_sel[0]}} & mn_8b_mnorm[1023:512]) |
//                           ({256  *2{pk_rsp_mn_sel[2]}} & mn_8b_myuv[1023:512]) |
//                           ({256  *2{pk_rsp_mn_sel[4]}} & mn_8b_myuv[2047:1536]) |
//                           ({256  *2{pk_rsp_mn_sel[6]}} & mn_8b_myuv[3071:2560]);
//

#ifdef NVDLA_FEATURE_DATA_TYPE_INT8
//: my $mn_bw = int(NVDLA_CDMA_DMAIF_BW / NVDLA_BPE) * 16 ;
//: print qq(
//:     assign pk_rsp_mn_data_h0 = ({${mn_bw}{pk_rsp_mn_sel[0]}} & mn_8b_mnorm) |
//:                                ({${mn_bw}{pk_rsp_mn_sel[2]}} & mn_8b_myuv[${mn_bw}-1:0]) |
//:                                ({${mn_bw}{pk_rsp_mn_sel[4]}} & mn_8b_myuv[${mn_bw}*2-1:${mn_bw}]) |
//:                                ({${mn_bw}{pk_rsp_mn_sel[6]}} & mn_8b_myuv[${mn_bw}*3-1:${mn_bw}*2]);
//: );
#else
assign pk_rsp_mn_data_h0 = ({256  *2{pk_rsp_mn_sel[0]}} & mn_8b_mnorm[511:0]) |
                           ({256  *2{pk_rsp_mn_sel[1]}} & mn_16b_mnorm[511:0]) |
                           ({256  *2{pk_rsp_mn_sel[2]}} & mn_8b_myuv[511:0]) |
                           ({256  *2{pk_rsp_mn_sel[3]}} & mn_16b_myuv[511:0]) |
                           ({256  *2{pk_rsp_mn_sel[4]}} & mn_8b_myuv[1535:1024]) |
                           ({256  *2{pk_rsp_mn_sel[5]}} & mn_16b_myuv[1023:512]) |
                           ({256  *2{pk_rsp_mn_sel[6]}} & mn_8b_myuv[2559:2048]) |
                           ({256  *2{pk_rsp_mn_sel[7]}} & mn_16b_myuv[1535:1024]);
#endif

assign mn_mask_y_en = pk_rsp_planar0_c0_en;
assign mn_mask_uv_0_en = pk_rsp_planar1_c0_en; 
assign mn_mask_uv_1_en = pk_rsp_planar1_c1_en;
assign pk_rsp_mn_data_h0_en = pk_rsp_wr_vld;
assign pk_rsp_mn_data_h1_en = (pk_rsp_wr_vld & (~(|pixel_precision) | pixel_packed_10b));

//: my $Bnum = NVDLA_CDMA_DMAIF_BW/NVDLA_BPE;
//: &eperl::flop("-nodeclare   -rval \"{${Bnum}{1'b0}}\"  -en \"mn_mask_y_en\" -d \"mask_zero\" -q mn_mask_y_d1");
//: &eperl::flop("-nodeclare   -rval \"{${Bnum}{1'b0}}\"  -en \"mn_mask_uv_0_en\" -d \"mask_zero\" -q mn_mask_uv_lo_d1");
//: &eperl::flop("-nodeclare   -rval \"{${Bnum}{1'b0}}\"  -en \"mn_mask_uv_1_en\" -d \"mask_zero\" -q mn_mask_uv_hi_d1");
////: &eperl::flop("-nodeclare  -norst -en \"pk_rsp_mn_data_h1_en\" -d \"pk_rsp_mn_data_h1\" -q pk_mn_out_data_h1");
//: &eperl::flop("-nodeclare  -norst -en \"pk_rsp_mn_data_h0_en\" -d \"pk_rsp_mn_data_h0\" -q pk_mn_out_data_h0");

//assign pk_mn_out_data = {pk_mn_out_data_h1, pk_mn_out_data_h0};
assign pk_mn_out_data = {pk_mn_out_data_h0};

////////////////////////////////////////////////////////////////////////
// cbuf write addresss generator                                      //
////////////////////////////////////////////////////////////////////////

//////// address base ////////
assign pk_rsp_wr_entries = pk_rsp_cur_1st_height ? sg2pack_entry_st :
                           pk_rsp_cur_layer_end ? sg2pack_entry_end : sg2pack_entry_mid;

assign pk_rsp_wr_slices = pk_rsp_cur_1st_height ? sg2pack_sub_h_st :
                          pk_rsp_cur_layer_end ? sg2pack_sub_h_end : sg2pack_sub_h_mid;

assign pk_rsp_wr_base_inc = is_first_running ? {1'b0, status2dma_wr_idx} : (pk_rsp_wr_base + pk_rsp_wr_entries);
assign is_base_wrap = (pk_rsp_wr_base_inc[15 : 9 ] >= {1'd0,pixel_bank});
assign {mon_pk_rsp_wr_base_wrap[1:0], pk_rsp_wr_base_wrap} = (pk_rsp_wr_base_inc[15 : 9 ] - {1'b0,pixel_bank});
assign pk_rsp_wr_base_w = is_base_wrap ? {pk_rsp_wr_base_wrap, pk_rsp_wr_base_inc[8 :0]} : pk_rsp_wr_base_inc[15 -1:0];

assign pk_rsp_wr_base_en = is_first_running | (pk_rsp_wr_vld & pk_rsp_cur_one_line_end & pk_rsp_cur_sub_h_end);
//: &eperl::flop("-nodeclare   -rval \"{15{1'b0}}\"  -en \"pk_rsp_wr_base_en\" -d \"pk_rsp_wr_base_w\" -q pk_rsp_wr_base");

//////// h_offset ////////
assign {mon_pk_rsp_wr_h_offset_w,
        pk_rsp_wr_h_offset_w} = (is_first_running | pk_rsp_cur_sub_h_end) ? 16'b0 :
                               pk_rsp_wr_h_offset + sg2pack_data_entries;

assign pk_rsp_wr_h_offset_en = is_first_running | (pk_rsp_wr_vld & pk_rsp_cur_loop_end);
//: &eperl::flop("-nodeclare   -rval \"{15{1'b0}}\"  -en \"pk_rsp_wr_h_offset_en\" -d \"pk_rsp_wr_h_offset_w\" -q pk_rsp_wr_h_offset");

///////// w_offset ////////
//assign pk_rsp_wr_w_add = pixel_data_shrink ? {1'b0, pk_rsp_wr_size_ori[2:1]} :
//                         pixel_data_expand ? {pk_rsp_wr_size_ori[1:0], 1'b0} : pk_rsp_wr_size_ori;
assign pk_rsp_wr_w_add = pk_rsp_wr_size_ori;

assign {mon_pk_rsp_wr_w_offset_w,
        pk_rsp_wr_w_offset_w} = (is_first_running | (pk_rsp_cur_one_line_end & pk_rsp_cur_sub_h_end)) ? 15'b0 :
                               (pk_rsp_cur_loop_end & ~pk_rsp_cur_sub_h_end) ? pk_rsp_wr_w_offset_ori :
                               pk_rsp_wr_w_offset + pk_rsp_wr_w_add;

assign pk_rsp_wr_w_offset_en = is_first_running | pk_rsp_wr_vld;
assign pk_rsp_wr_w_offset_ori_en = is_first_running;

//: &eperl::flop("-nodeclare   -rval \"{15{1'b0}}\"  -en \"pk_rsp_wr_w_offset_en\" -d \"pk_rsp_wr_w_offset_w\" -q pk_rsp_wr_w_offset");
//: &eperl::flop("-nodeclare   -rval \"{15{1'b0}}\"  -en \"pk_rsp_wr_w_offset_ori_en\" -d \"pk_rsp_wr_w_offset_w\" -q pk_rsp_wr_w_offset_ori");

///////// total_address ////////
//: my $dmaif = (NVDLA_CDMA_DMAIF_BW/NVDLA_BPE);
//: my $atmc = NVDLA_MAC_ATOMIC_C_SIZE;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $Bnum = int( $dmaif/$atmm );
//: my $Cnum = int( $atmc/$atmm );
//: my $ss = int( log($Cnum)/log(2) );
//: print qq(
//: assign pk_rsp_wr_addr_inc = pk_rsp_wr_base + pk_rsp_wr_h_offset + pk_rsp_wr_w_offset[14:${ss}];
//: );
//: if($ss > 0){
//: print qq(
//: assign pk_rsp_wr_sub_addr = pk_rsp_wr_w_offset[${ss}-1:0];
//: );
//: ##} else {
//: ##print qq(
//: ##assign pk_rsp_wr_sub_addr = 2'd0;
//: ##);
//: }
//:
//: if($atmc > $dmaif){
//:     my $k = int( $atmc/$dmaif );
//:     if($k == 2) {
//:         if($Bnum == 1) {
//:             &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pk_rsp_wr_vld\" -d \"pk_rsp_wr_sub_addr[0]\" -q pk_out_hsel");
//:         } elsif($Bnum == 2) {
//:             &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pk_rsp_wr_vld\" -d \"pk_rsp_wr_sub_addr[1]\" -q pk_out_hsel");
//:         } elsif($Bnum == 4) {
//:             &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pk_rsp_wr_vld\" -d \"pk_rsp_wr_sub_addr[2]\" -q pk_out_hsel");
//:         }
//:     } elsif($k == 4) {
//:         if($Bnum == 1) {
//:             &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pk_rsp_wr_vld\" -d \"pk_rsp_wr_sub_addr[1:0]\" -q pk_out_hsel[1:0]");
//:         } elsif($Bnum == 2) {
//:             &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pk_rsp_wr_vld\" -d \"pk_rsp_wr_sub_addr[2:1]\" -q pk_out_hsel[1:0]");
//:         } elsif($Bnum == 4) {
//:             &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pk_rsp_wr_vld\" -d \"pk_rsp_wr_sub_addr[3:2]\" -q pk_out_hsel[1:0]");
//:         }
//:     }
//: }
assign is_addr_wrap = (pk_rsp_wr_addr_inc[15 +1: 9 ] >= {2'd0, pixel_bank});
assign {mon_pk_rsp_wr_addr_wrap[2:0], pk_rsp_wr_addr_wrap} = (pk_rsp_wr_addr_inc[16 : 9 ] - {2'b0,pixel_bank});
assign pk_rsp_wr_addr = is_addr_wrap ? {pk_rsp_wr_addr_wrap, pk_rsp_wr_addr_inc[8 :0]} : pk_rsp_wr_addr_inc[14:0];
//: &eperl::flop("-nodeclare   -rval \"{15{1'b0}}\"  -en \"pk_rsp_wr_vld\" -d \"pk_rsp_wr_addr\" -q pk_out_addr");

////////////////////////////////////////////////////////////////////////
// update status                                                      //
////////////////////////////////////////////////////////////////////////
assign pk_rsp_data_updt = pk_rsp_wr_vld & pk_rsp_cur_one_line_end & pk_rsp_cur_sub_h_end;
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"pk_rsp_data_updt\" -q pk_out_data_updt");
//: &eperl::flop("-nodeclare   -rval \"{15{1'b0}}\"  -en \"pk_rsp_data_updt\" -d \"pk_rsp_wr_entries\" -q pk_out_data_entries");
//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"pk_rsp_data_updt\" -d \"pk_rsp_wr_slices\" -q pk_out_data_slices");

////////////////////////////////////////////////////////////////////////
//  output connection                                                 //
////////////////////////////////////////////////////////////////////////
assign img2status_dat_updt = pk_out_data_updt;
assign img2status_dat_slices = {{10{1'b0}}, pk_out_data_slices};
assign img2status_dat_entries = pk_out_data_entries;

assign img2cvt_dat_wr_en = pk_out_vld;
//assign img2cvt_dat_wr_addr = pk_out_addr;
//assign img2cvt_dat_wr_sel  = pk_out_hsel;
//assign img2cvt_dat_wr_data = pk_out_data;
//assign img2cvt_dat_wr_pad_mask = pk_out_pad_mask;
assign img2cvt_dat_wr_info_pd = pk_out_info_pd;
//assign img2cvt_mn_wr_data = pk_mn_out_data;

//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $Bnum = $dmaif / NVDLA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:      assign img2cvt_dat_wr_sel      = pk_out_hsel;
//:      assign img2cvt_dat_wr_addr     = pk_out_addr;
//:      assign img2cvt_dat_wr_data     = pk_out_data;
//:      assign img2cvt_mn_wr_data      = pk_mn_out_data;
//:      assign img2cvt_dat_wr_pad_mask = pk_out_pad_mask;
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:      assign img2cvt_dat_wr_mask = ?; //
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:           assign img2cvt_dat_wr_addr${i}       = img2cvt_dat_wr_addr${i}    ;//
//:           assign img2cvt_dat_wr_data${i}       = img2cvt_dat_wr_data${i}    ;//
//:           assign img2cvt_mn_wr_data${i}        = img2cvt_mn_wr_data${i}     ;//
//:           assign img2cvt_dat_wr_pad_mask${i}   = img2cvt_dat_wr_pad_mask${i};//
//:         );
//:     }
//: } else {
//:     print qq(
//:      assign img2cvt_dat_wr_addr     = {2'd0,pk_out_addr};
//:      assign img2cvt_dat_wr_data     = pk_out_data;
//:      assign img2cvt_mn_wr_data      = pk_mn_out_data;
//:      assign img2cvt_dat_wr_pad_mask = pk_out_pad_mask;
//:     );
//: }

////////////////////////////////////////////////////////////////////////
// global status                                                      //
////////////////////////////////////////////////////////////////////////
assign pack_is_done_w = is_first_running ? 1'b0 :
                        pk_rsp_wr_vld & pk_rsp_cur_layer_end ? 1'b1 : pack_is_done;
//: &eperl::flop("-nodeclare   -rval \"1'b1\"   -d \"pack_is_done_w\" -q pack_is_done");


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


////////////////////////////////////////////////////////////////////////
//  Assertion                                                         //
////////////////////////////////////////////////////////////////////////
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_height_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_loop_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_pburst_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar0_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar1_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar0_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_planar1_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_p0_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_p1_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_30x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
//  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar0_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
//  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_33x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar1_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_34x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_35x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
//  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_36x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar0_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
//  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_37x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_planar1_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_38x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_39x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_40x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_41x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_43x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_44x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_54x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_55x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_56x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_57x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_58x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_59x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_60x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_61x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_62x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_63x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_64x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_65x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_66x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_67x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_68x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_69x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_70x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_71x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_72x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_73x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_74x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_75x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_76x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_77x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_78x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_79x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_82x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_planar0_c0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_83x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_planar1_c0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_84x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_planar1_c1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_85x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_planar0_c0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_86x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_planar1_c0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_87x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_planar1_c1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
//  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_88x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_data_h1_en | is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_89x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_data_h0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_90x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mn_mask_y_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_91x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mn_mask_uv_0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_92x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mn_mask_uv_1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_93x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_base_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_96x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_h_offset_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_99x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_w_offset_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_100x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_w_offset_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_104x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_105x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_wr_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_109x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_data_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_110x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pk_rsp_data_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 

  nv_assert_never #(0,0,"Error! p0_burst and p1_burst mismatch!")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, (sg2pack_img_pvld & pixel_planar & (img_p0_burst * 2 != img_p1_burst) & (img_p0_burst * 2 != img_p1_burst + 1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! layer_end signal conflict with local cnt!")      zzz_assert_never_14x (nvdla_core_clk, `ASSERT_RESET, (rd_line_end & (is_last_height ^ img_layer_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! rd_sub_h_limit is overflow!")      zzz_assert_never_16x (nvdla_core_clk, `ASSERT_RESET, (mon_rd_sub_h_limit & is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! rd_loop_cnt_limit is overflow!")      zzz_assert_never_17x (nvdla_core_clk, `ASSERT_RESET, (mon_rd_loop_cnt_limit & is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! data_planar0_p0_cnt_w is overflow!")      zzz_assert_never_45x (nvdla_core_clk, `ASSERT_RESET, (data_planar0_en & mon_data_planar0_p0_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! data_planar0_p1_cnt_w is overflow!")      zzz_assert_never_46x (nvdla_core_clk, `ASSERT_RESET, (data_planar0_en & mon_data_planar0_p1_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! data_planar1_p0_cnt_w is overflow!")      zzz_assert_never_47x (nvdla_core_clk, `ASSERT_RESET, (data_planar1_en & mon_data_planar1_p0_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! data_planar1_p1_cnt_w is overflow!")      zzz_assert_never_48x (nvdla_core_clk, `ASSERT_RESET, (data_planar1_en & mon_data_planar1_p1_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! data_planar0_p0_cur_flag invalid!")      zzz_assert_never_49x (nvdla_core_clk, `ASSERT_RESET, (rd_vld & ~rd_planar_cnt & data_planar0_p0_cur_flag[2] & ~img_line_end)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! data_planar0_p1_cur_flag invalid!")      zzz_assert_never_50x (nvdla_core_clk, `ASSERT_RESET, (rd_vld & ~rd_planar_cnt & data_planar0_p1_cur_flag[2] & ~img_line_end)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! data_planar1_p0_cur_flag invalid!")      zzz_assert_never_51x (nvdla_core_clk, `ASSERT_RESET, (rd_vld & rd_planar_cnt & data_planar1_p0_cur_flag[2] & ~img_line_end)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! data_planar1_p1_cur_flag invalid!")      zzz_assert_never_52x (nvdla_core_clk, `ASSERT_RESET, (rd_vld & rd_planar_cnt & data_planar1_p1_cur_flag[2] & ~img_line_end)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pk_rsp_wr_cnt is overflow!")      zzz_assert_never_80x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_vld & mon_pk_rsp_wr_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pk_rsp_wr_cnt is out of range!")      zzz_assert_never_81x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_vld & (pk_rsp_wr_cnt > 2'h2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pk_rsp_wr_base_wrap is overflow!")      zzz_assert_never_94x (nvdla_core_clk, `ASSERT_RESET, (is_base_wrap & (|mon_pk_rsp_wr_base_wrap) & pk_rsp_wr_base_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pk_rsp_wr_base_w is out of range!")      zzz_assert_never_95x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_base_en & (pk_rsp_wr_base_w >= 12'd3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pk_rsp_wr_h_offset_w is overflow!")      zzz_assert_never_97x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_h_offset_en & mon_pk_rsp_wr_h_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pk_rsp_wr_h_offset_w is out of range!")      zzz_assert_never_98x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_h_offset_en & (pk_rsp_wr_h_offset_w >= 12'd3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pk_rsp_wr_w_offset_w is overflow!")      zzz_assert_never_101x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_w_offset_en & mon_pk_rsp_wr_w_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pk_rsp_wr_w_offset_w is out of range!")      zzz_assert_never_102x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_w_offset_en & (pk_rsp_wr_w_offset_w[13:2] >= 12'd3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! store 16 bytes when not line end!")      zzz_assert_never_103x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_w_offset_en & ~pk_rsp_cur_one_line_end & ~(|pk_rsp_wr_w_add))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pk_rsp_wr_addr_wrap is overflow!")      zzz_assert_never_106x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_vld & is_addr_wrap & (|mon_pk_rsp_wr_addr_wrap))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pk_rsp_wr_addr is out of range!")      zzz_assert_never_107x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_vld & (pk_rsp_wr_addr >= 12'd3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pk_rsp_wr_sub_addr conflict with pk_rsp_wr_w_add!")      zzz_assert_never_108x (nvdla_core_clk, `ASSERT_RESET, (pk_rsp_wr_vld & (pk_rsp_wr_w_add + pk_rsp_wr_sub_addr > 4'h4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

endmodule // NV_NVDLA_CDMA_IMG_pack
