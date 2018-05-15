// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_dc.v

#include "NV_NVDLA_CDMA_define.h"

module NV_NVDLA_CDMA_dc (
 input  nvdla_core_clk
,input  nvdla_core_rstn
,input [31:0] pwrbus_ram_pd

,output        dc_dat2mcif_rd_req_valid
,input         dc_dat2mcif_rd_req_ready
,output [NVDLA_CDMA_MEM_RD_REQ-1:0] dc_dat2mcif_rd_req_pd
,input          mcif2dc_dat_rd_rsp_valid 
,output         mcif2dc_dat_rd_rsp_ready
,input [NVDLA_CDMA_MEM_RD_RSP-1:0] mcif2dc_dat_rd_rsp_pd

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
,output        dc_dat2cvif_rd_req_valid
,input         dc_dat2cvif_rd_req_ready
,output [NVDLA_CDMA_MEM_RD_REQ-1:0] dc_dat2cvif_rd_req_pd
,input          cvif2dc_dat_rd_rsp_valid
,output         cvif2dc_dat_rd_rsp_ready
,input [NVDLA_CDMA_MEM_RD_RSP-1:0] cvif2dc_dat_rd_rsp_pd
#endif

,output         dc2cvt_dat_wr_en
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:     ,output [${k}-1:0]     dc2cvt_dat_wr_sel
//:     ,output [16:0]         dc2cvt_dat_wr_addr
//:     ,output [${dmaif}-1:0] dc2cvt_dat_wr_data
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:     ,output   [${k}-1:0]      dc2cvt_dat_wr_mask
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:             ,output [16:0]         dc2cvt_dat_wr_addr${i}
//:             ,output [${dmaif}-1:0] dc2cvt_dat_wr_data${i}
//:         );
//:     }
//: } else {
//:     print qq(
//:     ,output [16:0]         dc2cvt_dat_wr_addr
//:     ,output [${dmaif}-1:0] dc2cvt_dat_wr_data
//:     );
//: }
,output [11:0] dc2cvt_dat_wr_info_pd

,output reg [1:0] dc2status_state
,output        dc2status_dat_updt
,output [14:0] dc2status_dat_entries
,output [13:0] dc2status_dat_slices

,input        status2dma_fsm_switch
,input [13:0] status2dma_valid_slices
,input [14:0] status2dma_free_entries
,input [14:0] status2dma_wr_idx

//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
//: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
//: foreach my $i (0..$M-1) {
//:     print qq(
//:         ,output               dc2sbuf_p${i}_wr_en
//:         ,output [7:0]         dc2sbuf_p${i}_wr_addr
//:         ,output [${atmm}-1:0] dc2sbuf_p${i}_wr_data
//:         ,output reg           dc2sbuf_p${i}_rd_en 
//:         ,output reg [7:0]     dc2sbuf_p${i}_rd_addr
//:         ,input  [${atmm}-1:0] dc2sbuf_p${i}_rd_data
//:     );
//: }

,input  sc2cdma_dat_pending_req

,input nvdla_core_ng_clk

,input        reg2dp_op_en
,input        reg2dp_conv_mode
,input        reg2dp_data_reuse
,input        reg2dp_skip_data_rls
,input        reg2dp_datain_format
,input [12:0] reg2dp_datain_width
,input [12:0] reg2dp_datain_height
,input [12:0] reg2dp_datain_channel
,input        reg2dp_datain_ram_type
,input [31:0] reg2dp_datain_addr_high_0
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log(${atmm})/log(2));
//: print qq(
//:     ,input [31-${atmbw}:0]   reg2dp_datain_addr_low_0
//:     ,input [31-${atmbw}:0]   reg2dp_line_stride
//:     ,input [31-${atmbw}:0]   reg2dp_surf_stride
//:     ,input [31-${atmbw}:0]   reg2dp_batch_stride
//: );
,input        reg2dp_line_packed
,input        reg2dp_surf_packed
,input [4:0]  reg2dp_batches
,input [16:0] reg2dp_entries //entry number per slice
,input [11:0] reg2dp_grains
,input [4:0]  reg2dp_data_bank
,input        reg2dp_dma_en
,output          slcg_dc_gate_wg
,output          slcg_dc_gate_img
,output reg [31:0]   dp2reg_dc_rd_stall
,output reg [31:0]   dp2reg_dc_rd_latency
  );
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

reg            cbuf_is_ready;
//: my $dmabw=NVDLA_CDMA_DMAIF_BW;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $m = int($dmaif/$atmc+0.99);
//: foreach my $i (0..$m-1) {
//:     print qq(
//:     reg     [16:0] cbuf_wr_addr_$i;
//:     wire    [16:0] cbuf_wr_addr_d0_$i;
//:     reg     [16:0] cbuf_wr_addr_d1_$i;
//:     reg     [16:0] cbuf_wr_addr_d2_$i;
//:     reg     [16:0] cbuf_wr_addr_d3_$i;
//:     reg     [$dmabw-1:0] cbuf_wr_data_d3_$i;
//:     );
//: }
reg            cbuf_wr_en;
reg            cbuf_wr_en_d1;
reg            cbuf_wr_en_d2;
reg            cbuf_wr_en_d3;
//reg            cbuf_wr_hsel;
reg      [3:0] cbuf_wr_info_mask;
reg     [11:0] cbuf_wr_info_pd_d1;
reg     [11:0] cbuf_wr_info_pd_d2;
reg     [11:0] cbuf_wr_info_pd_d3;
reg      [4:0] ch0_cnt;
reg            mon_ch0_cnt;
reg      [5:0] ch0_p0_rd_addr_cnt;
reg            mon_ch0_p0_rd_addr_cnt;
reg      [5:0] ch0_p0_wr_addr_cnt;
reg            mon_ch0_p0_wr_addr_cnt;
reg      [5:0] ch0_p1_rd_addr_cnt;
reg            mon_ch0_p1_rd_addr_cnt;
reg      [5:0] ch0_p1_wr_addr_cnt;
reg            mon_ch0_p1_wr_addr_cnt;
reg      [4:0] ch1_cnt;
reg            mon_ch1_cnt;
reg      [5:0] ch1_p0_wr_addr_cnt;
reg            mon_ch1_p0_wr_addr_cnt;
reg      [5:0] ch1_p0_rd_addr_cnt;
reg      [5:0] ch1_p1_rd_addr_cnt;
reg            mon_ch1_p0_rd_addr_cnt;
reg            mon_ch1_p1_rd_addr_cnt;
reg      [5:0] ch1_p1_wr_addr_cnt;
reg            mon_ch1_p1_wr_addr_cnt;
reg      [4:0] ch2_cnt;
reg            mon_ch2_cnt;
reg      [5:0] ch2_p0_rd_addr_cnt;
reg            mon_ch2_p0_rd_addr_cnt;
reg      [5:0] ch2_p0_wr_addr_cnt;
reg            mon_ch2_p0_wr_addr_cnt;
reg      [5:0] ch2_p1_wr_addr_cnt;
reg            mon_ch2_p1_wr_addr_cnt;
reg      [4:0] ch3_cnt;
reg            mon_ch3_cnt;
reg      [5:0] ch3_p0_wr_addr_cnt;
reg            mon_ch3_p0_wr_addr_cnt;
reg      [5:0] ch3_p0_rd_addr_cnt;
reg            mon_ch3_p0_rd_addr_cnt;
reg      [5:0] ch3_p1_wr_addr_cnt;
reg            mon_ch3_p1_wr_addr_cnt;
reg      [1:0] cur_state;
reg     [14:0] dat_entries_d0;
reg     [14:0] dat_entries_d1;
reg     [14:0] dat_entries_d2;
reg     [14:0] dat_entries_d3;
reg     [13:0] dat_slices_d0;
reg     [13:0] dat_slices_d1;
reg     [13:0] dat_slices_d2;
reg     [13:0] dat_slices_d3;
reg            dat_updt_d0;
reg            dat_updt_d1;
reg            dat_updt_d2;
reg            dat_updt_d3;
reg      [5:0] data_bank;
reg      [5:0] data_batch;
reg     [17:0] data_entries;
reg     [13:0] data_height;
reg     [10:0] data_surface;
reg     [15:0] data_width;
reg     [14:0] data_width_sub_one;
reg            dbg_is_last_reuse;
////: my $dmaif=NVDLA_CDMA_DMAIF_BW;
////: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
////: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
////: foreach my $k (0..$M-1) {
////:     print qq(
////:     reg      [7:0] dc2sbuf_p${k}_rd_addr;
////:     reg            dc2sbuf_p${k}_rd_en;
////:     );
////: }
//reg      [1:0] dc2status_state;
reg     [14:0] dc_entry_onfly;
reg            dc_rd_latency_cen;
reg            dc_rd_latency_clr;
reg            dc_rd_latency_dec;
reg            dc_rd_latency_inc;
reg            dc_rd_stall_cen;
reg            dc_rd_stall_clr;
reg            dc_rd_stall_inc;
reg      [4:0] delay_cnt;
wire     [3:0] dma_rsp_size;
reg      [3:0] dma_rsp_size_cnt;
//reg     [31:0] dp2reg_dc_rd_latency;
//reg     [31:0] dp2reg_dc_rd_stall;
reg     [17:0] entry_per_batch_d2;
reg     [11:0] fetch_grain;
reg     [14:0] idx_base;
reg     [17:0] idx_batch_offset;
reg     [17:0] idx_ch_offset;
reg     [17:0] idx_grain_offset;
reg            mon_idx_grain_offset;
reg     [17:0] idx_h_offset;
reg            is_blocking;
reg            is_req_grain_last_d1;
reg            is_req_grain_last_d2;
reg      [4:0] last_data_bank;
reg            last_dc;
reg            last_skip_data_rls;
reg            ltc_1_adv;
reg      [8:0] ltc_1_cnt_cur;
reg     [10:0] ltc_1_cnt_dec;
reg     [10:0] ltc_1_cnt_ext;
reg     [10:0] ltc_1_cnt_inc;
reg     [10:0] ltc_1_cnt_mod;
reg     [10:0] ltc_1_cnt_new;
reg     [10:0] ltc_1_cnt_nxt;
reg            ltc_2_adv;
reg     [31:0] ltc_2_cnt_cur;
reg     [33:0] ltc_2_cnt_dec;
reg     [33:0] ltc_2_cnt_ext;
reg     [33:0] ltc_2_cnt_inc;
reg     [33:0] ltc_2_cnt_mod;
reg     [33:0] ltc_2_cnt_new;
reg     [33:0] ltc_2_cnt_nxt;
reg      [1:0] nxt_state;
reg      [8:0] outs_dp2reg_dc_rd_latency;
reg            pending_req;
reg            pending_req_d1;
//bw of below two signals
reg    [0:0] pre_gen_sel;
reg    [0:0] req_csm_sel;
//: foreach my $i (0..1){
//:     print qq(
//:     wire           pre_reg_en_d2_g${i};
//:     reg     [13:0] req_atomic_${i}_d3;
//:     reg     [17:0] req_entry_${i}_d3;
//:     reg            req_pre_valid_${i}_d3;
//:     );
//: }
reg            pre_valid_d1;
reg            pre_valid_d2;
reg     [13:0] req_atm_cnt_0;
reg     [13:0] req_atm_cnt_1;
reg     [13:0] req_atm_cnt_2;
reg     [13:0] req_atm_cnt_3;
reg      [1:0] req_atm_sel;
reg     [13:0] req_atomic_d2;
reg      [4:0] req_batch_cnt;
reg     [10:0] req_ch_cnt;
reg            mon_req_ch_cnt;
reg      [1:0] req_ch_idx_d1;
reg      [2:0] req_cur_ch;
reg     [13:0] req_cur_grain_d1;
reg     [13:0] req_cur_grain_d2;
reg     [13:0] req_height_cnt_d1;
reg      [3:0] req_size_d1;
reg      [2:0] req_size_out_d1;
reg            req_valid_d1;
reg     [13:0] rsp_all_h_cnt;
reg      [4:0] rsp_batch_cnt;
reg     [17:0] rsp_batch_entry_init;
reg     [17:0] rsp_batch_entry_last;
reg     [10:0] rsp_ch_cnt;
reg            mon_rsp_ch_cnt;
reg      [2:0] rsp_cur_ch;
reg     [11:0] rsp_cur_grain;
//reg     [17:0] req_entry_0_d3;
//reg     [17:0] req_entry_1_d3;
reg     [17:0] rsp_entry_init;
reg     [17:0] rsp_entry_last;
reg     [11:0] rsp_h_cnt;
reg            rsp_rd_ch2ch3;
reg     [13:0] rsp_slice_init;
reg     [13:0] rsp_slice_last;
reg     [15:0] rsp_w_cnt;
reg            mon_rsp_w_cnt;
reg      [1:0] slcg_dc_gate_d1;
reg      [1:0] slcg_dc_gate_d2;
reg      [1:0] slcg_dc_gate_d3;
reg            stl_adv;
reg     [31:0] stl_cnt_cur;
reg     [33:0] stl_cnt_dec;
reg     [33:0] stl_cnt_ext;
reg     [33:0] stl_cnt_inc;
reg     [33:0] stl_cnt_mod;
reg     [33:0] stl_cnt_new;
reg     [33:0] stl_cnt_nxt;
wire    [15:0] cbuf_idx_inc;
wire    [16:0] cbuf_idx_w;
wire           cbuf_is_ready_w;
wire           cbuf_wr_en_d0;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:     wire   [${k}-1:0]     cbuf_wr_hsel_w;
//:     reg    [${k}-1:0]     cbuf_wr_hsel;
//:     wire   [${k}-1:0]     cbuf_wr_hsel_d0;
//:     reg    [${k}-1:0]     cbuf_wr_hsel_d1;
//:     reg    [${k}-1:0]     cbuf_wr_hsel_d2;
//:     reg    [${k}-1:0]     cbuf_wr_hsel_d3;
//:     );
//: }

wire    [11:0] cbuf_wr_info_pd;
wire    [11:0] cbuf_wr_info_pd_d0;
wire           ch0_aval;
wire     [1:0] ch0_cnt_add;
wire     [2:0] ch0_cnt_sub;
wire     [7:0] ch0_p0_rd_addr;
wire     [7:0] ch0_p0_wr_addr;
wire     [7:0] ch0_p1_rd_addr;
wire     [7:0] ch0_p1_wr_addr;
wire           ch0_rd_addr_cnt_reg_en;
wire           ch0_wr_addr_cnt_reg_en;
wire           ch1_aval;
wire     [1:0] ch1_cnt_add;
wire     [2:0] ch1_cnt_sub;
wire     [4:0] ch1_cnt_w;
wire     [7:0] ch1_p0_wr_addr;
wire     [7:0] ch1_p0_rd_addr;
wire     [7:0] ch1_p1_rd_addr;
wire     [7:0] ch1_p1_wr_addr;
wire           ch1_rd_addr_cnt_reg_en;
wire           ch1_wr_addr_cnt_reg_en;
wire           ch2_aval;
wire     [1:0] ch2_cnt_add;
wire     [2:0] ch2_cnt_sub;
wire     [4:0] ch2_cnt_w;
wire     [7:0] ch2_p0_rd_addr;
wire     [7:0] ch2_p0_wr_addr;
wire     [7:0] ch2_p1_wr_addr;
wire           ch2_rd_addr_cnt_reg_en;
wire           ch2_wr_addr_cnt_reg_en;
wire           ch3_aval;
wire     [1:0] ch3_cnt_add;
wire     [2:0] ch3_cnt_sub;
wire     [4:0] ch3_cnt_w;
wire     [7:0] ch3_p0_wr_addr;
wire     [7:0] ch3_p0_rd_addr;
wire     [7:0] ch3_p1_wr_addr;
wire           ch3_rd_addr_cnt_reg_en;
wire           ch3_wr_addr_cnt_reg_en;
wire           csm_reg_en;
wire           cur_atm_done;
wire    [17:0] data_entries_w;
wire    [13:0] data_height_w;
wire    [10:0] data_surface_inc;
wire    [10:0] data_surface_w;
wire    [14:0] data_width_sub_one_w;
wire           dbg_is_last_reuse_w;
wire     [1:0] dc2status_state_w;
wire           dc_en;
wire    [14:0] dc_entry_onfly_add;
wire    [14:0] dc_entry_onfly_sub;
wire    [14:0] dc_entry_onfly_w;
wire     [4:0] delay_cnt_end;
wire    [63:0] dma_rd_req_addr_f;
wire    [NVDLA_MEM_ADDRESS_WIDTH-1:0] dma_rd_req_addr;
wire    [NVDLA_CDMA_MEM_RD_REQ-1:0] dma_rd_req_pd;
wire           dma_rd_req_rdy;
wire    [15:0] dma_rd_req_size;
wire           dma_rd_req_type;
wire           dma_rd_req_vld;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
//: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
//: print qq(
//:     wire   [${dmaif}+${M}-1:0] dma_rd_rsp_pd;
//:     wire   [${dmaif}-1:0] dma_rd_rsp_data;
//: );
//: print qq(
//:     wire   [${M}-1:0] dma_rd_rsp_mask;
//: );
//: foreach my $k (0..$M-1) {
//: print qq( reg    [${atmm}-1:0] dma_rsp_data_p${k}; \n);
//: }
wire           dma_rd_rsp_rdy;
wire           dma_rd_rsp_vld;
wire     [5:0] dma_req_fifo_data;
wire           dma_req_fifo_ready;
wire           dma_req_fifo_req;
wire     [1:0] dma_rsp_ch_idx;
wire     [5:0] dma_rsp_fifo_data;
wire           dma_rsp_fifo_ready;
wire           dma_rsp_fifo_req;
wire     [3:0] dma_rsp_size_cnt_inc;
wire     [3:0] dma_rsp_size_cnt_w;
wire           dp2reg_dc_rd_stall_dec;
wire    [17:0] entry_per_batch;
wire    [17:0] entry_required;
wire           fetch_done;
wire    [11:0] fetch_grain_w;
wire    [17:0] idx_batch_offset_w;
wire    [17:0] idx_ch_offset_w;
wire    [17:0] idx_h_offset_w;
wire    [14:0] idx_w_offset_add;
wire     [3:0] is_atm_done;
wire           is_cbuf_idx_wrap;
wire           is_data_normal;
wire           is_dc;
wire           is_done;
wire           is_feature;
wire           is_first_running;
wire           is_free_entries_enough;
wire           is_idle;
wire           is_nxt_running;
wire           is_packed_1x1;
wire           is_pending;
wire           is_req_atm_end;
wire           is_req_atm_sel_end;
wire           is_req_batch_end;
wire           is_req_ch_end;
wire           is_req_grain_last;
wire           is_rsp_all_h_end;
wire           is_rsp_batch_end;
wire           is_rsp_ch0;
wire           is_rsp_ch1;
wire           is_rsp_ch2;
wire           is_rsp_ch3;
wire           is_rsp_ch_end;
wire           is_rsp_done;
wire           is_rsp_h_end;
wire           is_rsp_w_end;
wire           is_running;
wire           is_w_cnt_div2;
wire           is_w_cnt_div4;
wire           layer_st;
wire           ltc_1_dec;
wire           ltc_1_inc;
wire           ltc_2_dec;
wire           ltc_2_inc;
wire           mode_match;
wire     [2:0] mon_cbuf_idx_inc;
wire     [1:0] mon_cbuf_idx_w;
wire           mon_ch1_cnt_w;
wire           mon_ch2_cnt_w;
wire           mon_ch3_cnt_w;
wire           mon_data_entries_w;
wire           mon_dc_entry_onfly_w;
wire           mon_dma_rsp_size_cnt_inc;
wire     [5:0] mon_entry_per_batch;
wire    [13:0] mon_entry_required;
wire           mon_fetch_grain_w;
wire           mon_idx_batch_offset_w;
wire           mon_idx_ch_offset_w;
wire           mon_idx_h_offset_w;
wire           mon_req_addr;
wire           mon_req_addr_base_inc;
wire           mon_req_addr_batch_base_inc;
wire           mon_req_addr_ch_base_inc;
wire           mon_req_addr_grain_base_inc;
wire           mon_req_atm_cnt_inc;
wire           mon_req_atm_left;
wire           mon_req_atm_size_addr_limit;
wire     [1:0] mon_req_atm_size_out;
wire           mon_req_ch_left_w;
wire    [15:0] mon_req_cur_atomic;
reg            mon_req_height_cnt_d1;
wire           mon_req_slice_left;
wire           mon_rsp_all_h_cnt_inc;
wire           mon_rsp_all_h_left_w;
wire           mon_rsp_ch_cnt_inc;
wire           mon_rsp_ch_left_w;
wire           need_pending;
reg     [2:0]  rsp_rd_more_atmm;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
//: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
//: foreach my $k (0..$M-1) {
//:     print qq(
//:     wire           p${k}_wr_en;
//:     wire     [7:0] p${k}_wr_addr;
//:     wire           p${k}_rd_en_w;
//:     reg      [7:0] p${k}_rd_addr_w;
//:     );
//: }
wire           pending_req_end;
wire           pre_ready;
wire           pre_ready_d1;
wire           pre_ready_d2;
wire           pre_reg_en;
wire           pre_reg_en_d1;
wire           pre_reg_en_d2;
wire           pre_reg_en_d2_init;
wire           pre_reg_en_d2_last;
wire           rd_req_rdyi;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log(${atmm})/log(2));
//: print qq(
//:     wire    [63-${atmbw}:0] req_addr;
//:     reg     [63-${atmbw}:0] req_addr_d1;
//:     wire    [63-${atmbw}:0] req_addr_base_inc;
//:     wire    [63-${atmbw}:0] req_addr_base_w;
//:     reg     [63-${atmbw}:0] req_addr_base;
//:     wire    [63-${atmbw}:0] req_addr_batch_base_inc;
//:     wire    [63-${atmbw}:0] req_addr_batch_base_w;
//:     wire    [63-${atmbw}:0] req_addr_ori;
//:     wire    [63-${atmbw}:0] req_addr_ch_base_inc;
//:     wire    [63-${atmbw}:0] req_addr_ch_base_w;
//:     wire    [63-${atmbw}:0] req_addr_grain_base_inc;
//:     wire    [63-${atmbw}:0] req_addr_grain_base_w;
//:     reg     [63-${atmbw}:0] req_addr_batch_base;
//:     reg     [63-${atmbw}:0] req_addr_ch_base;
//:     reg     [63-${atmbw}:0] req_addr_grain_base;
//:     wire    [12+31-${atmbw}:0] grain_addr_w;
//:     reg     [12+31-${atmbw}:0] grain_addr;
//:     wire    [2+31-${atmbw}:0] req_addr_ch_base_add;
//: );
wire    [13:0] req_atm;
wire    [13:0] req_atm_cnt;
wire    [13:0] req_atm_cnt_0_w;
wire    [13:0] req_atm_cnt_1_w;
wire    [13:0] req_atm_cnt_2_w;
wire    [13:0] req_atm_cnt_3_w;
wire    [13:0] req_atm_cnt_inc;
wire    [13:0] req_atm_left;
wire           req_atm_reg_en;
wire           req_atm_reg_en_0;
wire           req_atm_reg_en_1;
wire           req_atm_reg_en_2;
wire           req_atm_reg_en_3;
wire     [3:0] req_atm_size;
wire     [3:0] req_atm_size_addr_limit;
wire     [2:0] req_atm_size_out;
wire           req_batch_reg_en;
wire    [10:0] req_ch_left_w;
wire     [2:0] req_ch_mode;
wire           req_ch_reg_en;
wire    [13:0] req_cur_atomic;
wire    [13:0] req_cur_grain_w;
wire    [14:0] req_entry;
wire           req_grain_reg_en;
wire           req_pre_valid;
wire           req_pre_valid_0_w;
wire           req_pre_valid_1_w;
wire           req_ready_d0;
wire           req_ready_d1;
wire           req_reg_en;
wire    [13:0] req_slice_left;
wire           req_valid_d0;
wire    [15:0] required_entries;
wire    [13:0] rsp_all_h_cnt_inc;
wire    [13:0] rsp_all_h_left_w;
wire           rsp_all_h_reg_en;
wire           rsp_batch_reg_en;
wire           rsp_ch0_rd_one;
wire     [2:0] rsp_ch0_rd_size;
wire    [10:0] rsp_ch_cnt_inc;
wire    [10:0] rsp_ch_left_w;
wire     [2:0] rsp_ch_mode;
wire           rsp_ch_reg_en;
wire    [2:0]  rsp_cur_ch_w;
wire    [11:0] rsp_cur_grain_w;
wire    [17:0] rsp_entry;
wire           rsp_h_reg_en;
reg            rsp_rd_en;
wire    [13:0] rsp_slice;
reg      [2:0] rsp_w_cnt_add;
wire           rsp_w_left1;
wire           rsp_w_left2;
wire           rsp_w_left3;
wire           rsp_w_left4;
wire           rsp_w_reg_en;
wire           slcg_dc_en_w;
wire     [1:0] slcg_dc_gate_w;

wire     [13:0] data_width_inc;
////////////////////////////////////////////////////////////////////////
// CDMA direct convolution data fetching logic FSM                    //
////////////////////////////////////////////////////////////////////////
//## fsm (1) defines
localparam DC_STATE_IDLE = 2'b00;
localparam DC_STATE_PEND = 2'b01;
localparam DC_STATE_BUSY = 2'b10;
localparam DC_STATE_DONE = 2'b11;
//## fsm (1) com block

always @(*) begin
    nxt_state = cur_state;
    begin
        casez (cur_state)
        DC_STATE_IDLE: begin
            if ((dc_en & need_pending)) begin
                nxt_state = DC_STATE_PEND; 
            end
            else if ((dc_en & reg2dp_data_reuse & last_skip_data_rls & mode_match)) begin
                nxt_state = DC_STATE_DONE; 
            end
            else if (dc_en) begin
                nxt_state = DC_STATE_BUSY; 
            end
        end
        DC_STATE_PEND: begin
            if ((pending_req_end)) begin
                nxt_state = DC_STATE_BUSY; 
            end
        end
        DC_STATE_BUSY: begin
            if (fetch_done) begin
                nxt_state = DC_STATE_DONE; 
            end
        end
        DC_STATE_DONE: begin
            if (status2dma_fsm_switch) begin
                nxt_state = DC_STATE_IDLE; 
            end
        end
        endcase
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        cur_state <= DC_STATE_IDLE;
    end else begin
        cur_state <= nxt_state;
    end
end

////////////////////////////////////////////////////////////////////////
//  FSM input signals                                                 //
////////////////////////////////////////////////////////////////////////
assign fetch_done = is_running & is_rsp_done & (delay_cnt == delay_cnt_end);
assign delay_cnt_end = CDMA_STATUS_LATENCY; // this value is related to status pipeline delay
assign need_pending = (last_data_bank != reg2dp_data_bank);
assign mode_match = dc_en & last_dc;
assign is_feature = (reg2dp_datain_format == 1'h0 );
assign is_dc = (reg2dp_conv_mode == 1'h0 );
assign dc_en = reg2dp_op_en & is_dc & is_feature;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        delay_cnt <= {5{1'b0}};
    end else if(~is_running)begin
        delay_cnt <= {5{1'b0}};
    end else if(is_rsp_done)begin
        delay_cnt <= delay_cnt + 1'b1;
    end
end

`ifndef SYNTHESIS
assign dbg_is_last_reuse_w = (is_idle & (nxt_state == DC_STATE_DONE)) ? 1'b1 :
                             (~is_running & is_nxt_running) ? 1'b0 :
                             dbg_is_last_reuse;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
        dbg_is_last_reuse <= 1'b0;
        // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    end else begin
        dbg_is_last_reuse <= dbg_is_last_reuse_w;
    end
end
`endif

////////////////////////////////////////////////////////////////////////
//  FSM output signals                                                //
////////////////////////////////////////////////////////////////////////

assign layer_st = dc_en & is_idle;
assign is_idle = (cur_state == DC_STATE_IDLE);
assign is_pending = (cur_state == DC_STATE_PEND);
assign is_running = (cur_state == DC_STATE_BUSY);
assign is_done = (cur_state == DC_STATE_DONE);
assign is_nxt_running = (nxt_state == DC_STATE_BUSY);
assign is_first_running = ~is_running & is_nxt_running;
assign dc2status_state_w = (nxt_state == DC_STATE_PEND) ? 1  : 
                           (nxt_state == DC_STATE_BUSY) ? 2  : 
                           (nxt_state == DC_STATE_DONE) ? 3  :
                           0 ;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dc2status_state <= 0;
    end else begin
        dc2status_state <= dc2status_state_w;
    end
end

////////////////////////////////////////////////////////////////////////
//  registers to keep last layer status                               //
////////////////////////////////////////////////////////////////////////
assign pending_req_end = pending_req_d1 & ~pending_req;

//================  Non-SLCG clock domain ================//
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        last_dc <= 1'b0;
    end else begin
        if ((reg2dp_op_en & is_idle) == 1'b1) begin
            last_dc <= dc_en;
        end
    end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        last_data_bank <= {5{1'b1}};
    end else begin
        if ((reg2dp_op_en & is_idle) == 1'b1) begin
            last_data_bank <= reg2dp_data_bank;
        end
    end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        last_skip_data_rls <= 1'b0;
    end else begin
        if ((reg2dp_op_en & is_idle) == 1'b1) begin
            last_skip_data_rls <= dc_en & reg2dp_skip_data_rls;
        end
    end
end

always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        pending_req <= 1'b0;
    end else begin
        pending_req <= sc2cdma_dat_pending_req;
    end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        pending_req_d1 <= 1'b0;
    end else begin
        pending_req_d1 <= pending_req;
    end
end

////////////////////////////////////////////////////////////////////////
//  SLCG control signal                                               //
////////////////////////////////////////////////////////////////////////
assign slcg_dc_en_w = dc_en & (is_running | is_pending | is_done);
assign slcg_dc_gate_w = {2{~slcg_dc_en_w}};

always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        slcg_dc_gate_d1 <= {2{1'b1}};
    end else begin
        slcg_dc_gate_d1 <= slcg_dc_gate_w;
    end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        slcg_dc_gate_d2 <= {2{1'b1}};
    end else begin
        slcg_dc_gate_d2 <= slcg_dc_gate_d1;
    end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        slcg_dc_gate_d3 <= {2{1'b1}};
    end else begin
        slcg_dc_gate_d3 <= slcg_dc_gate_d2;
    end
end

assign slcg_dc_gate_wg = slcg_dc_gate_d3[0];
assign slcg_dc_gate_img = slcg_dc_gate_d3[1];

//================  Non-SLCG clock domain end ================//

////////////////////////////////////////////////////////////////////////
//  registers to calculate local values                               //
////////////////////////////////////////////////////////////////////////
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log(${atmm})/log(2));
//: print qq(
//:     assign data_width_sub_one_w = (is_packed_1x1) ? {{(2+${atmbw}){1'b0}}, reg2dp_datain_channel[12:${atmbw}]} : {2'b0, reg2dp_datain_width};
//:     assign data_surface_inc = {{(${atmbw}-3){1'b0}}, reg2dp_datain_channel[12:${atmbw}]} + 1'b1;
//: );

// assign is_data_expand = 1'b0;
//assign is_data_shrink = 1'b0;
assign is_data_normal = 1'b1;
assign is_packed_1x1 = (reg2dp_datain_width == 13'b0) & (reg2dp_datain_height == 13'b0) & reg2dp_surf_packed;
assign data_width_inc = reg2dp_datain_width + 1'b1;
//assign data_width_w = is_packed_1x1 ? {6'b0, data_surface_inc} : {2'b0, data_width_inc};
assign data_height_w = reg2dp_datain_height + 1'b1;
assign {mon_data_entries_w, data_entries_w} = reg2dp_entries + 1'b1;
assign data_surface_w = is_packed_1x1 ? 11'b1 : data_surface_inc;
assign {mon_fetch_grain_w, fetch_grain_w} = (~reg2dp_line_packed) ? 13'b1 : reg2dp_grains + 1'b1;
assign grain_addr_w = fetch_grain_w * reg2dp_line_stride;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        data_width <= {16{1'b0}};
    end else begin
        if (layer_st) begin
            if(is_packed_1x1)
                data_width <= {5'b0, data_surface_inc} ;
            else 
                data_width <= {2'b0, data_width_inc};
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        data_width_sub_one <= {15{1'b0}};
    end else begin
        if ((layer_st) == 1'b1) begin
            data_width_sub_one <= data_width_sub_one_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        data_height <= {14{1'b0}};
    end else begin
        if ((layer_st) == 1'b1) begin
            data_height <= data_height_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        data_batch <= {6{1'b0}};
    end else begin
        if ((layer_st) == 1'b1) begin
            data_batch <= reg2dp_batches + 1'b1;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        data_entries <= 0;
    end else begin
        if ((layer_st) == 1'b1) begin
            data_entries <= data_entries_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        fetch_grain <= {12{1'b0}};
    end else begin
        if ((layer_st) == 1'b1) begin
            fetch_grain <= fetch_grain_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        data_surface <= {11{1'b0}};
    end else begin
        if ((layer_st) == 1'b1) begin
            data_surface <= data_surface_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        grain_addr <= 0;
    end else begin
        if ((layer_st) == 1'b1) begin
            grain_addr <= grain_addr_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        data_bank <= {6{1'b0}};
    end else begin
        if ((layer_st) == 1'b1) begin
            data_bank <= reg2dp_data_bank + 1'b1;
        end
    end
end


////////////////////////////////////////////////////////////////////////
//  prepare for address generation                                    //
////////////////////////////////////////////////////////////////////////
///////////// stage 1 /////////////
assign pre_ready = ~pre_valid_d1 | pre_ready_d1;
assign pre_reg_en = is_running & (req_height_cnt_d1 != data_height) & pre_ready;
assign {mon_req_slice_left, req_slice_left} = data_height - req_height_cnt_d1;
assign is_req_grain_last = (req_slice_left <= {2'd0,fetch_grain});
assign req_cur_grain_w = is_req_grain_last ? req_slice_left : {2'd0,fetch_grain};

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_req_height_cnt_d1,req_height_cnt_d1} <= {15{1'b0}};
    end else if(layer_st) begin
        {mon_req_height_cnt_d1,req_height_cnt_d1} <= {15{1'b0}};
    end else if (pre_reg_en) begin
        {mon_req_height_cnt_d1,req_height_cnt_d1} <= req_height_cnt_d1 + req_cur_grain_w;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_cur_grain_d1 <= {14{1'b0}};
    end else begin
        if ((pre_reg_en) == 1'b1) begin
            req_cur_grain_d1 <= req_cur_grain_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        is_req_grain_last_d1 <= 1'b0;
    end else begin
        if ((pre_reg_en) == 1'b1) begin
            is_req_grain_last_d1 <= is_req_grain_last;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        pre_valid_d1 <= 1'b0;
    end else if(~is_running)begin
        pre_valid_d1 <= 1'b0;
    end else begin
        if(req_height_cnt_d1 != data_height)
            pre_valid_d1 <= 1'b1;
        else if(pre_ready_d1)
            pre_valid_d1 <= 1'b0;
    end
end

///////////// stage 2 /////////////
assign {mon_req_cur_atomic, req_cur_atomic} = req_cur_grain_d1 * data_width;
assign {mon_entry_per_batch, entry_per_batch} = data_entries * data_batch;
assign pre_ready_d1 = ~pre_valid_d2 | pre_ready_d2;
assign pre_reg_en_d1 = pre_valid_d1 & pre_ready_d1;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_atomic_d2 <= {14{1'b0}};
    end else begin
        if ((pre_reg_en_d1) == 1'b1) begin
            req_atomic_d2 <= req_cur_atomic;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        entry_per_batch_d2 <= 0;
    end else begin
        if ((pre_reg_en_d1) == 1'b1) begin
            entry_per_batch_d2 <= entry_per_batch;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_cur_grain_d2 <= {14{1'b0}};
    end else begin
        if ((pre_reg_en_d1) == 1'b1) begin
            req_cur_grain_d2 <= req_cur_grain_d1;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        is_req_grain_last_d2 <= 1'b0;
    end else begin
        if ((pre_reg_en_d1) == 1'b1) begin
            is_req_grain_last_d2 <= is_req_grain_last_d1;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        pre_valid_d2 <= 1'b0;
    end else if(~is_running)begin
        pre_valid_d2 <= 1'b0;
    end else begin
        if(pre_valid_d1)
            pre_valid_d2 <= 1'b1;
        else if(pre_ready_d2)
            pre_valid_d2 <= 1'b0;
    end
end

///////////// stage 3 /////////////
assign {mon_entry_required, entry_required} = req_cur_grain_d2 * entry_per_batch_d2;
assign pre_reg_en_d2_g0 = pre_valid_d2 & ~pre_gen_sel & ~req_pre_valid_0_d3;
assign pre_reg_en_d2_g1 = pre_valid_d2 & pre_gen_sel & ~req_pre_valid_1_d3;
assign pre_ready_d2 = ((~pre_gen_sel & ~req_pre_valid_0_d3) | (pre_gen_sel & ~req_pre_valid_1_d3));
assign pre_reg_en_d2 = pre_valid_d2 & pre_ready_d2;
assign pre_reg_en_d2_init = pre_valid_d2 & pre_ready_d2 & ~is_req_grain_last_d2;
assign pre_reg_en_d2_last = pre_valid_d2 & pre_ready_d2 & is_req_grain_last_d2;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_atomic_0_d3 <= {14{1'b0}};
    end else begin
        if ((pre_reg_en_d2_g0) == 1'b1) begin
            req_atomic_0_d3 <= req_atomic_d2;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_atomic_1_d3 <= {14{1'b0}};
    end else begin
        if ((pre_reg_en_d2_g1) == 1'b1) begin
            req_atomic_1_d3 <= req_atomic_d2;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_entry_0_d3 <= 0;
    end else begin
        if ((pre_reg_en_d2_g0) == 1'b1) begin
            req_entry_0_d3 <= entry_required;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_entry_1_d3 <= 0;
    end else begin
        if ((pre_reg_en_d2_g1) == 1'b1) begin
            req_entry_1_d3 <= entry_required;
        end
    end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        rsp_entry_init <= 0;
    end else begin
        if ((pre_reg_en_d2_init) == 1'b1) begin
            rsp_entry_init <= entry_required;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        rsp_entry_last <= 0;
    end else begin
        if ((pre_reg_en_d2_last) == 1'b1) begin
            rsp_entry_last <= entry_required;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        rsp_batch_entry_init <= 0;
    end else begin
        if ((pre_reg_en_d2_init) == 1'b1) begin
            rsp_batch_entry_init <= entry_per_batch_d2;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        rsp_batch_entry_last <= 0;
    end else begin
        if ((pre_reg_en_d2_last) == 1'b1) begin
            rsp_batch_entry_last <= entry_per_batch_d2;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        rsp_slice_init <= {14{1'b0}};
    end else begin
        if ((pre_reg_en_d2_init) == 1'b1) begin
            rsp_slice_init <= req_cur_grain_d2;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        rsp_slice_last <= {14{1'b0}};
    end else begin
        if ((pre_reg_en_d2_last) == 1'b1) begin
            rsp_slice_last <= req_cur_grain_d2;
        end
    end
end

///////////// prepare control logic /////////////
// assign pre_gen_sel_w = is_running & (pre_valid_d2 ^ pre_gen_sel);
// assign req_csm_sel_w = is_running & ~req_csm_sel;
assign req_pre_valid_0_w = ~is_running ? 1'b0 :
                           (pre_reg_en_d2_g0) ? 1'b1 :
                           (~req_csm_sel & csm_reg_en) ? 1'b0 : req_pre_valid_0_d3;
assign req_pre_valid_1_w = ~is_running ? 1'b0 :
                           (pre_reg_en_d2_g1) ? 1'b1 :
                           (req_csm_sel & csm_reg_en) ? 1'b0 : req_pre_valid_1_d3;
assign csm_reg_en = req_grain_reg_en;
assign req_pre_valid = ~req_csm_sel ? req_pre_valid_0_d3 : req_pre_valid_1_d3;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        pre_gen_sel <= 0;
    end else if(~is_running) begin
        pre_gen_sel <= 0;
    end else if (pre_reg_en_d2) begin
        pre_gen_sel <= pre_gen_sel + 1'b1;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_csm_sel <= 0;
    end else if(~is_running) begin
        req_csm_sel <= 0;
    end else if (csm_reg_en) begin
        req_csm_sel <= req_csm_sel + 1'b1;
    end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_pre_valid_0_d3 <= 1'b0;
    end else begin
        req_pre_valid_0_d3 <= req_pre_valid_0_w;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_pre_valid_1_d3 <= 1'b0;
    end else begin
        req_pre_valid_1_d3 <= req_pre_valid_1_w;
    end
end

////////////////////////////////////////////////////////////////////////
//  generate address for input feature data                           //
////////////////////////////////////////////////////////////////////////
///////////// batch counter /////////////
// assign {mon_req_batch_cnt_inc,
//         req_batch_cnt_inc} = req_batch_cnt + 1'b1;
// assign req_batch_cnt_w = (is_req_batch_end) ? 5'b0 :
//                          req_batch_cnt_inc;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_batch_cnt <= {5{1'b0}};
    end else if(layer_st) begin
        req_batch_cnt <= {5{1'b0}};
    end else begin
        if (req_batch_reg_en) begin
            if(is_req_batch_end)
                req_batch_cnt <= {5{1'b0}};
            else
                req_batch_cnt <= req_batch_cnt + 1'b1;
        end
    end
end
assign is_req_batch_end = (req_batch_cnt == reg2dp_batches);

///////////// channel counter /////////////

assign req_ch_mode = is_packed_1x1 ? 3'h1 :
                     /*is_data_shrink ? 3'h4 : */
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $m = int($dmaif/$atmc);
//: my $k;
//: if($m > 1){$k=$atmc;}
//: else {$k=$dmaif;}
//: print qq(
//:    3'h${k}; 
//: );
assign {mon_req_ch_left_w,req_ch_left_w} = (layer_st | is_req_ch_end) ? {1'b0,data_surface_w} : (data_surface - req_ch_cnt) - {8'd0,req_cur_ch};
// assign req_cur_ch_w = (req_ch_left_w > {{8{1'b0}}, req_ch_mode}) ? req_ch_mode : req_ch_left_w[2:0];
// assign {mon_req_ch_cnt_inc,
//         req_ch_cnt_inc} = req_ch_cnt + req_cur_ch;
// assign is_req_ch_end = (req_ch_cnt_inc == data_surface); 
// assign req_ch_cnt_w = (layer_st | is_req_ch_end) ? 10'b0 :
//                       req_ch_cnt_inc;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_req_ch_cnt,req_ch_cnt} <= {12{1'b0}};
    end else if(layer_st) begin
        {mon_req_ch_cnt,req_ch_cnt} <= {12{1'b0}};
    end else begin
        if (req_ch_reg_en) begin
            if(is_req_ch_end)
                {mon_req_ch_cnt,req_ch_cnt} <= {12{1'b0}};
            else
            {mon_req_ch_cnt,req_ch_cnt} <= req_ch_cnt + {8'd0, req_cur_ch};
        end
    end
end
//assign is_req_ch_end = (req_ch_cnt == (data_surface-req_cur_ch)); 
wire    [10:0] data_surface_dec;
wire           mon_data_surface_dec;
assign {mon_data_surface_dec,data_surface_dec} = data_surface-{8'd0,req_cur_ch};
assign is_req_ch_end = (req_ch_cnt == data_surface_dec); 

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_cur_ch <= {3{1'b0}};
    end else begin
        if (layer_st | req_ch_reg_en) begin
            if(req_ch_left_w > {{8{1'b0}}, req_ch_mode})
                req_cur_ch <= req_ch_mode;
            else
                req_cur_ch <= req_ch_left_w[2:0];
        end
    end
end

///////////// atomic counter /////////////
// assign req_atm_sel_inc = req_atm_sel + 1'b1;
// assign is_req_atm_sel_end = (req_atm_sel_inc == req_cur_ch);
// assign req_atm_sel_w = ~is_running ? 1'b0 :
//                        (is_req_atm_sel_end | is_req_atm_end) ? 2'b0:
//                        req_atm_sel_inc[1:0];
assign is_req_atm_end =   ((req_cur_ch == 3'h1) & (&is_atm_done[  0]))
                        | ((req_cur_ch == 3'h2) & (&is_atm_done[1:0]))
                        | ((req_cur_ch == 3'h3) & (&is_atm_done[2:0]))
                        | ((req_cur_ch == 3'h4) & (&is_atm_done[3:0]));
assign req_atm = req_csm_sel ? req_atomic_1_d3 : req_atomic_0_d3;

assign is_atm_done[0] = (req_atm_cnt_0 == req_atm);
assign is_atm_done[1] = (req_atm_cnt_1 == req_atm);
assign is_atm_done[2] = (req_atm_cnt_2 == req_atm);
assign is_atm_done[3] = (req_atm_cnt_3 == req_atm);
assign req_atm_cnt = (req_atm_sel == 2'h0) ? req_atm_cnt_0 :
                     (req_atm_sel == 2'h1) ? req_atm_cnt_1 :
                     (req_atm_sel == 2'h2) ? req_atm_cnt_2 :
                     (req_atm_sel == 2'h3) ? req_atm_cnt_3 : 14'd0;
assign {mon_req_atm_cnt_inc, req_atm_cnt_inc} = req_atm_cnt + req_atm_size;
assign cur_atm_done = (req_atm_sel == 2'h0) ? is_atm_done[0] :
                      (req_atm_sel == 2'h1) ? is_atm_done[1] :
                      (req_atm_sel == 2'h2) ? is_atm_done[2] :
                      (req_atm_sel == 2'h3) ? is_atm_done[3] : 1'b0;
assign {mon_req_atm_left, req_atm_left} = req_atm - req_atm_cnt;
assign {mon_req_atm_size_addr_limit, req_atm_size_addr_limit} = (req_atm_cnt == 14'b0) ? (4'h8 - req_addr[2:0]) : 4'h8;
assign req_atm_size = (req_atm_left < {{10{1'b0}}, req_atm_size_addr_limit}) ? req_atm_left[3:0] : req_atm_size_addr_limit;
assign {mon_req_atm_size_out, req_atm_size_out} = req_atm_size - 1'b1;
assign req_atm_cnt_0_w = (~is_running | is_req_atm_end) ? 14'b0 : req_atm_cnt_inc;
assign req_atm_cnt_1_w = (~is_running | is_req_atm_end) ? 14'b0 : req_atm_cnt_inc;
assign req_atm_cnt_2_w = (~is_running | is_req_atm_end) ? 14'b0 : req_atm_cnt_inc;
assign req_atm_cnt_3_w = (~is_running | is_req_atm_end) ? 14'b0 : req_atm_cnt_inc;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_atm_sel <= {2{1'b0}};
    end else if(~is_running) begin
        req_atm_sel <= {2{1'b0}};
    end else begin
        if (req_atm_reg_en) begin
            if(is_req_atm_sel_end | is_req_atm_end)
                req_atm_sel <= {2{1'b0}};
            else
                req_atm_sel <= req_atm_sel + 1'b1;
        end
    end
end
assign is_req_atm_sel_end = ({2'd0,req_atm_sel} == (req_cur_ch-1));

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_atm_cnt_0 <= {14{1'b0}};
    end else begin
        if ((layer_st | req_atm_reg_en_0) == 1'b1) begin
            req_atm_cnt_0 <= req_atm_cnt_0_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_atm_cnt_1 <= {14{1'b0}};
    end else begin
        if ((layer_st | req_atm_reg_en_1) == 1'b1) begin
            req_atm_cnt_1 <= req_atm_cnt_1_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_atm_cnt_2 <= {14{1'b0}};
    end else begin
        if ((layer_st | req_atm_reg_en_2) == 1'b1) begin
            req_atm_cnt_2 <= req_atm_cnt_2_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_atm_cnt_3 <= {14{1'b0}};
    end else begin
        if ((layer_st | req_atm_reg_en_3) == 1'b1) begin
            req_atm_cnt_3 <= req_atm_cnt_3_w;
        end
    end
end

///////////// address counter /////////////
assign req_addr_ori = {reg2dp_datain_addr_high_0, reg2dp_datain_addr_low_0};
assign {mon_req_addr_grain_base_inc,req_addr_grain_base_inc} = req_addr_grain_base + grain_addr;
assign {mon_req_addr_batch_base_inc,req_addr_batch_base_inc} = req_addr_batch_base + reg2dp_batch_stride;
assign req_addr_ch_base_add = /*(is_data_shrink) ? {reg2dp_surf_stride, 2'b0} : */
                              //{1'b0, reg2dp_surf_stride, 1'b0};
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $k;
//: if(${dmaif} < ${atmc}) {
//:     $k=$dmaif;  
//: } else {
//:     $k=$atmc; 
//: }
//: if($k == 1) {
//:     print "{2'b0, reg2dp_surf_stride};          \n";
//: } elsif($k == 2) {
//:     print "{1'b0, reg2dp_surf_stride, 1'b0};    \n";
//: } elsif($k == 4) {
//:     print "{reg2dp_surf_stride, 2'b0};          \n";
//: }

assign {mon_req_addr_ch_base_inc, req_addr_ch_base_inc} = req_addr_ch_base + req_addr_ch_base_add;
assign {mon_req_addr_base_inc, req_addr_base_inc} = req_addr_base + reg2dp_surf_stride;
assign req_addr_grain_base_w = is_first_running ? req_addr_ori : req_addr_grain_base_inc;
assign req_addr_batch_base_w = is_first_running ? req_addr_ori :
                               is_req_batch_end ? req_addr_grain_base_inc : req_addr_batch_base_inc;
assign req_addr_ch_base_w = is_first_running ? req_addr_ori :
                            (is_req_ch_end & is_req_batch_end) ? req_addr_grain_base_inc :
                            is_req_ch_end ? req_addr_batch_base_inc : req_addr_ch_base_inc;
assign req_addr_base_w = is_first_running ? req_addr_ori :
                         (is_req_atm_end & is_req_ch_end & is_req_batch_end) ? req_addr_grain_base_inc :
                         (is_req_atm_end & is_req_ch_end) ? req_addr_batch_base_inc :
                         is_req_atm_end ? req_addr_ch_base_inc :
                         is_req_atm_sel_end ? req_addr_ch_base : req_addr_base_inc;
assign {mon_req_addr, req_addr} = req_addr_base + req_atm_cnt;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_addr_grain_base <= 0;
    end else if ((is_first_running | req_grain_reg_en) == 1'b1) begin
        req_addr_grain_base <= req_addr_grain_base_w;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_addr_batch_base <= 0;
    end else begin
        if ((is_first_running | req_batch_reg_en) == 1'b1) begin
            req_addr_batch_base <= req_addr_batch_base_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_addr_ch_base <= 0;
    end else begin
        if ((is_first_running | req_ch_reg_en) == 1'b1) begin
            req_addr_ch_base <= req_addr_ch_base_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_addr_base <= 0;
    end else begin
        if ((is_first_running | req_atm_reg_en) == 1'b1) begin
            req_addr_base <= req_addr_base_w;
        end
    end
end

///////////// request package /////////////
assign req_valid_d0 = is_running & req_pre_valid & cbuf_is_ready & ~cur_atm_done;
// assign req_valid_d1_w = ~is_running ? 1'b0 :
//                         req_valid_d0 ? 1'b1 :
//                         req_ready_d1 ? 1'b0 :
//                         req_valid_d1;   

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_valid_d1 <= 1'b0;
    end else if(~is_running) begin
        req_valid_d1 <= 1'b0;
    end else if(req_valid_d0) begin
        req_valid_d1 <= 1'b1;
    end else if(req_ready_d1) begin
        req_valid_d1 <= 1'b0;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_addr_d1 <= 0;
    end else begin
        if ((req_reg_en) == 1'b1) begin
            req_addr_d1 <= req_addr;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_size_d1 <= {4{1'b0}};
    end else begin
        if ((req_reg_en) == 1'b1) begin
            req_size_d1 <= req_atm_size;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_size_out_d1 <= {3{1'b0}};
    end else begin
        if ((req_reg_en) == 1'b1) begin
            req_size_out_d1 <= req_atm_size_out;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_ch_idx_d1 <= {2{1'b0}};
    end else begin
        if ((req_reg_en) == 1'b1) begin
            req_ch_idx_d1 <= req_atm_sel;
        end
    end
end

///////////// control logic /////////////
assign req_ready_d1 = dma_req_fifo_ready & dma_rd_req_rdy;
assign req_ready_d0 = req_ready_d1 | ~req_valid_d1;
assign req_reg_en = req_pre_valid & cbuf_is_ready & ~cur_atm_done & req_ready_d0;
assign req_atm_reg_en = req_pre_valid & cbuf_is_ready & (cur_atm_done | req_ready_d0);
assign req_atm_reg_en_0 = req_pre_valid & cbuf_is_ready & (is_req_atm_end | ((req_atm_sel == 2'h0) & ~is_atm_done[0] & req_ready_d0));
assign req_atm_reg_en_1 = req_pre_valid & cbuf_is_ready & (is_req_atm_end | ((req_atm_sel == 2'h1) & ~is_atm_done[1] & req_ready_d0));
assign req_atm_reg_en_2 = req_pre_valid & cbuf_is_ready & (is_req_atm_end | ((req_atm_sel == 2'h2) & ~is_atm_done[2] & req_ready_d0));
assign req_atm_reg_en_3 = req_pre_valid & cbuf_is_ready & (is_req_atm_end | ((req_atm_sel == 2'h3) & ~is_atm_done[2] & req_ready_d0));

//When is_req_atm_end is set, we don't need to wait cbuf_is_ready;
assign req_ch_reg_en = req_pre_valid & is_req_atm_end;
assign req_batch_reg_en = req_pre_valid & is_req_atm_end & is_req_ch_end;
assign req_grain_reg_en = req_pre_valid & is_req_atm_end & is_req_ch_end & is_req_batch_end;

////////////////////////////////////////////////////////////////////////
//  CDMA DC read request interface                                    //
////////////////////////////////////////////////////////////////////////

//==============
// DMA Interface
//==============
// rd Channel: Request
NV_NVDLA_DMAIF_rdreq NV_NVDLA_PDP_RDMA_rdreq(
  .nvdla_core_clk         (nvdla_core_clk     )
 ,.nvdla_core_rstn        (nvdla_core_rstn    )
 ,.reg2dp_src_ram_type    (reg2dp_datain_ram_type)
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
 ,.cvif_rd_req_pd         (dc_dat2cvif_rd_req_pd   )
 ,.cvif_rd_req_valid      (dc_dat2cvif_rd_req_valid)
 ,.cvif_rd_req_ready      (dc_dat2cvif_rd_req_ready)
#endif
 ,.mcif_rd_req_pd         (dc_dat2mcif_rd_req_pd   ) 
 ,.mcif_rd_req_valid      (dc_dat2mcif_rd_req_valid) 
 ,.mcif_rd_req_ready      (dc_dat2mcif_rd_req_ready) 

 ,.dmaif_rd_req_pd        (dma_rd_req_pd    ) 
 ,.dmaif_rd_req_vld       (dma_rd_req_vld   )
 ,.dmaif_rd_req_rdy       (dma_rd_req_rdy   )
);

// rd Channel: Response
NV_NVDLA_DMAIF_rdrsp NV_NVDLA_PDP_RDMA_rdrsp(
   .nvdla_core_clk     (nvdla_core_clk   ) 
  ,.nvdla_core_rstn    (nvdla_core_rstn  ) 
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cvif_rd_rsp_pd       (cvif2dc_dat_rd_rsp_pd     )    
  ,.cvif_rd_rsp_valid    (cvif2dc_dat_rd_rsp_valid  )
  ,.cvif_rd_rsp_ready    (cvif2dc_dat_rd_rsp_ready  )
  #endif
  ,.mcif_rd_rsp_pd       (mcif2dc_dat_rd_rsp_pd     ) 
  ,.mcif_rd_rsp_valid    (mcif2dc_dat_rd_rsp_valid  )
  ,.mcif_rd_rsp_ready    (mcif2dc_dat_rd_rsp_ready  )

  ,.dmaif_rd_rsp_pd      (dma_rd_rsp_pd    )    
  ,.dmaif_rd_rsp_pvld    (dma_rd_rsp_vld  )
  ,.dmaif_rd_rsp_prdy    (dma_rd_rsp_rdy  )
);
///////////////////////////////////////////

assign dma_rd_req_pd[NVDLA_MEM_ADDRESS_WIDTH-1:0] =    dma_rd_req_addr[NVDLA_MEM_ADDRESS_WIDTH-1:0];
assign dma_rd_req_pd[NVDLA_MEM_ADDRESS_WIDTH+14:NVDLA_MEM_ADDRESS_WIDTH] =    dma_rd_req_size[14:0];
assign dma_rd_req_vld = dma_req_fifo_ready & req_valid_d1;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log(${atmm})/log(2));
//: my $k = NVDLA_MEM_ADDRESS_WIDTH;
//: print "assign dma_rd_req_addr_f = {req_addr_d1, ${atmbw}'d0};  \n";
//: print "assign dma_rd_req_addr = dma_rd_req_addr_f[${k}-1:0];  \n";
assign dma_rd_req_size = {{13{1'b0}}, req_size_out_d1};
assign dma_rd_req_type = reg2dp_datain_ram_type;
assign dma_rd_rsp_rdy = ~is_blocking;

NV_NVDLA_CDMA_DC_fifo u_fifo (
   .clk                 (nvdla_core_clk)          //|< i
  ,.reset_              (nvdla_core_rstn)         //|< i
  ,.wr_ready            (dma_req_fifo_ready)      //|> w
  ,.wr_req              (dma_req_fifo_req)        //|< r
  ,.wr_data             (dma_req_fifo_data[5:0])  //|< r
  ,.rd_ready            (dma_rsp_fifo_ready)      //|< r
  ,.rd_req              (dma_rsp_fifo_req)        //|> w
  ,.rd_data             (dma_rsp_fifo_data[5:0])  //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

assign dma_req_fifo_req = req_valid_d1 & dma_rd_req_rdy;
assign dma_req_fifo_data = {req_ch_idx_d1, req_size_d1};


////////////////////////////////////////////////////////////////////////
//  CDMA DC read response connection                                  //
////////////////////////////////////////////////////////////////////////



////: my $dmaif=NVDLA_CDMA_DMAIF_BW;
////: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
////: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
////: print qq(
////:     assign dma_rd_rsp_data[${dmaif}-1:0] =    dma_rd_rsp_pd[${dmaif}-1:0];
////: );
////: if($M>1) {
////:   print qq(
////:       assign dma_rd_rsp_mask[${M}-1:0] =    dma_rd_rsp_pd[${dmaif}+${M}-1:${dmaif}];
////:   );
////: }
assign dma_rd_rsp_data[NVDLA_CDMA_DMAIF_BW-1:0] =    dma_rd_rsp_pd[NVDLA_CDMA_DMAIF_BW-1:0];
assign dma_rd_rsp_mask[NVDLA_CDMA_MEM_RD_RSP-NVDLA_CDMA_DMAIF_BW-1:0] =    dma_rd_rsp_pd[NVDLA_CDMA_MEM_RD_RSP-1:NVDLA_CDMA_DMAIF_BW];
assign {dma_rsp_ch_idx, dma_rsp_size} = dma_rsp_fifo_data;

wire    [1:0]   active_atom_num;
assign active_atom_num = 2'd0
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
//: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
//:     foreach my $k (0..$M-1){
//:       print qq(
//:             + dma_rd_rsp_mask[$k]
//:       );
//:     }
//: print "; ";

assign {mon_dma_rsp_size_cnt_inc,dma_rsp_size_cnt_inc} = dma_rsp_size_cnt + active_atom_num;
assign {
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
//: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
//: if($M>1) {
//:     foreach my $k (0..$M-2){
//:     my $i = $M -$k -1;
//:       print qq(  dma_rsp_data_p${i},   );
//:     }
//: }
//:       print qq(  dma_rsp_data_p0} = dma_rd_rsp_data;   );

assign dma_rsp_size_cnt_w = (dma_rsp_size_cnt_inc == dma_rsp_size) ? 4'b0 : dma_rsp_size_cnt_inc;
assign dma_rsp_fifo_ready = (dma_rd_rsp_vld & ~is_blocking & (dma_rsp_size_cnt_inc == dma_rsp_size));

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dma_rsp_size_cnt <= {4{1'b0}};
    end else begin
        if ((dma_rd_rsp_vld & ~is_blocking) == 1'b1) begin
            dma_rsp_size_cnt <= dma_rsp_size_cnt_w;
        end
    end
end


////////////////////////////////////////////////////////////////////////
//  DC read data to shared buffer                                     //
////////////////////////////////////////////////////////////////////////
assign is_rsp_ch0 = dma_rsp_fifo_req & (dma_rsp_ch_idx == 2'h0);
assign is_rsp_ch1 = dma_rsp_fifo_req & (dma_rsp_ch_idx == 2'h1);
assign is_rsp_ch2 = dma_rsp_fifo_req & (dma_rsp_ch_idx == 2'h2);
assign is_rsp_ch3 = dma_rsp_fifo_req & (dma_rsp_ch_idx == 2'h3);
assign ch0_wr_addr_cnt_reg_en = dma_rd_rsp_vld & ~is_blocking & is_running & is_rsp_ch0;
assign ch1_wr_addr_cnt_reg_en = dma_rd_rsp_vld & ~is_blocking & is_running & is_rsp_ch1;
assign ch2_wr_addr_cnt_reg_en = dma_rd_rsp_vld & ~is_blocking & is_running & is_rsp_ch2;
assign ch3_wr_addr_cnt_reg_en = dma_rd_rsp_vld & ~is_blocking & is_running & is_rsp_ch3;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_ch0_p0_wr_addr_cnt,ch0_p0_wr_addr_cnt} <= {7{1'b0}};
        {mon_ch0_p1_wr_addr_cnt,ch0_p1_wr_addr_cnt} <= 7'b1;
    end else if(layer_st) begin
        {mon_ch0_p0_wr_addr_cnt,ch0_p0_wr_addr_cnt} <= {7{1'b0}};
        {mon_ch0_p1_wr_addr_cnt,ch0_p1_wr_addr_cnt} <= 7'b1;
    end else if(ch0_wr_addr_cnt_reg_en) begin
        {mon_ch0_p0_wr_addr_cnt,ch0_p0_wr_addr_cnt} <= ch0_p0_wr_addr_cnt + {4'd0, active_atom_num};
        {mon_ch0_p1_wr_addr_cnt,ch0_p1_wr_addr_cnt} <= ch0_p1_wr_addr_cnt + {4'd0, active_atom_num};
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_ch1_p0_wr_addr_cnt,ch1_p0_wr_addr_cnt} <= {7{1'b0}};
        {mon_ch1_p1_wr_addr_cnt,ch1_p1_wr_addr_cnt} <= 7'b1;
    end else if(layer_st) begin
        {mon_ch1_p0_wr_addr_cnt,ch1_p0_wr_addr_cnt} <= {7{1'b0}};
        {mon_ch1_p1_wr_addr_cnt,ch1_p1_wr_addr_cnt} <= 7'b1;
    end else if (ch1_wr_addr_cnt_reg_en)begin
        {mon_ch1_p0_wr_addr_cnt,ch1_p0_wr_addr_cnt} <= ch1_p0_wr_addr_cnt + {4'd0,active_atom_num};
        {mon_ch1_p1_wr_addr_cnt,ch1_p1_wr_addr_cnt} <= ch1_p1_wr_addr_cnt + {4'd0,active_atom_num};
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_ch2_p0_wr_addr_cnt,ch2_p0_wr_addr_cnt} <= {7{1'b0}};
        {mon_ch2_p1_wr_addr_cnt,ch2_p1_wr_addr_cnt} <= 7'b1;
    end else if(layer_st) begin
        {mon_ch2_p0_wr_addr_cnt,ch2_p0_wr_addr_cnt} <= {7{1'b0}};
        {mon_ch2_p1_wr_addr_cnt,ch2_p1_wr_addr_cnt} <= 7'b1;
    end else if (ch2_wr_addr_cnt_reg_en) begin
        {mon_ch2_p0_wr_addr_cnt,ch2_p0_wr_addr_cnt} <= ch2_p0_wr_addr_cnt + {4'd0, active_atom_num};
        {mon_ch2_p1_wr_addr_cnt,ch2_p1_wr_addr_cnt} <= ch2_p1_wr_addr_cnt + {4'd0, active_atom_num};
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_ch3_p0_wr_addr_cnt,ch3_p0_wr_addr_cnt} <= {7{1'b0}};
        {mon_ch3_p1_wr_addr_cnt,ch3_p1_wr_addr_cnt} <= 7'b1;
    end else if(layer_st) begin
        {mon_ch3_p0_wr_addr_cnt,ch3_p0_wr_addr_cnt} <= {7{1'b0}};
        {mon_ch3_p1_wr_addr_cnt,ch3_p1_wr_addr_cnt} <= 7'b1;
    end else if (ch3_wr_addr_cnt_reg_en) begin
        {mon_ch3_p0_wr_addr_cnt,ch3_p0_wr_addr_cnt} <= ch3_p0_wr_addr_cnt + {4'd0, active_atom_num};
        {mon_ch3_p1_wr_addr_cnt,ch3_p1_wr_addr_cnt} <= ch3_p1_wr_addr_cnt + {4'd0, active_atom_num};
    end
end

assign ch0_p0_wr_addr = {2'h0, ch0_p0_wr_addr_cnt[0], ch0_p0_wr_addr_cnt[8 -3:1]};
assign ch0_p1_wr_addr = {2'h0, ch0_p1_wr_addr_cnt[0], ch0_p1_wr_addr_cnt[8 -3:1]};
assign ch1_p0_wr_addr = {2'h1, ch1_p0_wr_addr_cnt[0], ch1_p0_wr_addr_cnt[8 -3:1]};
assign ch1_p1_wr_addr = {2'h1, ch1_p1_wr_addr_cnt[0], ch1_p1_wr_addr_cnt[8 -3:1]};
assign ch2_p0_wr_addr = {2'h2, ch2_p0_wr_addr_cnt[0], ch2_p0_wr_addr_cnt[8 -3:1]};
assign ch2_p1_wr_addr = {2'h2, ch2_p1_wr_addr_cnt[0], ch2_p1_wr_addr_cnt[8 -3:1]};
assign ch3_p0_wr_addr = {2'h3, ch3_p0_wr_addr_cnt[0], ch3_p0_wr_addr_cnt[8 -3:1]};
assign ch3_p1_wr_addr = {2'h3, ch3_p1_wr_addr_cnt[0], ch3_p1_wr_addr_cnt[8 -3:1]};


////////////////////////////////////////////////////////////////////////
//  Shared buffer write signals                                       //
////////////////////////////////////////////////////////////////////////

//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
//: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
//: foreach my $k (0..$M-1) {
//:     if($M > 1) {
//:         print qq(
//:         assign p${k}_wr_en = is_running & dma_rd_rsp_vld & ~is_blocking & dma_rd_rsp_mask[$k];
//:         );
//:     } else {
//:         print qq(
//:         assign p${k}_wr_en = is_running & dma_rd_rsp_vld & ~is_blocking;
//:         );
//:     }
//:     print qq(
//:     assign p${k}_wr_addr = ({8 {p${k}_wr_en & is_rsp_ch0}} & ch0_p${k}_wr_addr) 
//:                          | ({8 {p${k}_wr_en & is_rsp_ch1}} & ch1_p${k}_wr_addr) 
//:                          | ({8 {p${k}_wr_en & is_rsp_ch2}} & ch2_p${k}_wr_addr) 
//:                          | ({8 {p${k}_wr_en & is_rsp_ch3}} & ch3_p${k}_wr_addr);
//:     assign dc2sbuf_p${k}_wr_en = p${k}_wr_en;
//:     assign dc2sbuf_p${k}_wr_addr = p${k}_wr_addr;
//:     assign dc2sbuf_p${k}_wr_data = dma_rsp_data_p${k};
//:     );
//: }

////////////////////////////////////////////////////////////////////////
//  DC local buffer count                                             //
////////////////////////////////////////////////////////////////////////
assign ch0_cnt_add = (ch0_wr_addr_cnt_reg_en) ? active_atom_num : 2'h0;
assign ch1_cnt_add = (ch1_wr_addr_cnt_reg_en) ? active_atom_num : 2'h0;
assign ch2_cnt_add = (ch2_wr_addr_cnt_reg_en) ? active_atom_num : 2'h0;
assign ch3_cnt_add = (ch3_wr_addr_cnt_reg_en) ? active_atom_num : 2'h0;
assign ch0_cnt_sub = (ch0_rd_addr_cnt_reg_en) ? rsp_ch0_rd_size : 3'h0;
assign ch1_cnt_sub = (ch1_rd_addr_cnt_reg_en) ? rsp_ch0_rd_size : 3'h0;
assign ch2_cnt_sub = (ch2_rd_addr_cnt_reg_en) ? rsp_ch0_rd_size : 3'h0;
assign ch3_cnt_sub = (ch3_rd_addr_cnt_reg_en) ? rsp_ch0_rd_size : 3'h0;
// assign ch1_cnt_sub = (ch1_rd_addr_cnt_reg_en) ? 1'b1 : 1'h0;
// assign ch2_cnt_sub = (ch2_rd_addr_cnt_reg_en) ? 1'b1 : 1'h0;
// assign ch3_cnt_sub = (ch3_rd_addr_cnt_reg_en) ? 1'b1 : 1'h0;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_ch0_cnt,ch0_cnt} <= {6{1'b0}};
    end else if(layer_st) begin
        {mon_ch0_cnt,ch0_cnt} <= {6{1'b0}};
    end else if (ch0_wr_addr_cnt_reg_en | ch0_rd_addr_cnt_reg_en) begin
        {mon_ch0_cnt,ch0_cnt} <= ch0_cnt + ch0_cnt_add - ch0_cnt_sub;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_ch1_cnt,ch1_cnt} <= {6{1'b0}};
    end else if(layer_st) begin
        {mon_ch1_cnt,ch1_cnt} <= {6{1'b0}};
    end else if (ch1_wr_addr_cnt_reg_en | ch1_rd_addr_cnt_reg_en) begin
        {mon_ch1_cnt,ch1_cnt} <= ch1_cnt + ch1_cnt_add - ch1_cnt_sub;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_ch2_cnt,ch2_cnt} <= {6{1'b0}};
    end else if(layer_st) begin
        {mon_ch2_cnt,ch2_cnt} <= {6{1'b0}};
    end else if (ch2_wr_addr_cnt_reg_en | ch2_rd_addr_cnt_reg_en) begin
        {mon_ch2_cnt,ch2_cnt} <= ch2_cnt + ch2_cnt_add - ch2_cnt_sub;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_ch3_cnt,ch3_cnt} <= {6{1'b0}};
    end else if(layer_st) begin
        {mon_ch3_cnt,ch3_cnt} <= {6{1'b0}};
    end else if (ch3_wr_addr_cnt_reg_en | ch3_rd_addr_cnt_reg_en) begin
        {mon_ch3_cnt,ch3_cnt} <= ch3_cnt + ch3_cnt_add - ch3_cnt_sub;
    end
end
////////////////////////////////////////////////////////////////////////
//  DC response data counter---DC reading from Sbuf                   //
////////////////////////////////////////////////////////////////////////
///////////// all height counter /////////////
assign {mon_rsp_all_h_cnt_inc,
        rsp_all_h_cnt_inc} = rsp_all_h_cnt + rsp_cur_grain;
assign {mon_rsp_all_h_left_w,
        rsp_all_h_left_w} = layer_st ? {1'b0, data_height_w} : data_height - rsp_all_h_cnt_inc;
assign rsp_cur_grain_w = (rsp_all_h_left_w > {{2{1'b0}}, fetch_grain_w}) ? fetch_grain_w : rsp_all_h_left_w[11:0];
assign is_rsp_all_h_end = (rsp_all_h_cnt_inc == data_height);
assign is_rsp_done = ~reg2dp_op_en | (rsp_all_h_cnt == data_height);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        rsp_all_h_cnt <= {14{1'b0}};
    end else if (layer_st) begin
        rsp_all_h_cnt <= {14{1'b0}};
    end else begin
        if (rsp_all_h_reg_en) begin
            rsp_all_h_cnt <= rsp_all_h_cnt_inc;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        rsp_cur_grain <= {12{1'b0}};
    end else begin
        if ((layer_st | rsp_all_h_reg_en) == 1'b1) begin
            rsp_cur_grain <= rsp_cur_grain_w;
        end
    end
end


///////////// batch counter /////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        rsp_batch_cnt <= {5{1'b0}};
    end else if (layer_st) begin
        rsp_batch_cnt <= {5{1'b0}};
    end else if(rsp_batch_reg_en) begin
        if (is_rsp_batch_end)
            rsp_batch_cnt <= {5{1'b0}};
        else
            rsp_batch_cnt <= rsp_batch_cnt + 1'b1;
    end
end
assign is_rsp_batch_end = (rsp_batch_cnt == reg2dp_batches);

///////////// channel counter /////////////
assign rsp_ch_mode = req_ch_mode;
assign {mon_rsp_ch_cnt_inc,
        rsp_ch_cnt_inc} = rsp_ch_cnt + rsp_cur_ch;
assign {mon_rsp_ch_left_w,rsp_ch_left_w} = (layer_st | is_rsp_ch_end) ? {1'b0,data_surface_w} : (data_surface - rsp_ch_cnt_inc);
// assign is_rsp_ch_end = (rsp_ch_cnt_inc == data_surface); 
assign rsp_cur_ch_w = (rsp_ch_left_w > {{8{1'b0}}, rsp_ch_mode}) ? rsp_ch_mode : rsp_ch_left_w[2:0];


//assign is_rsp_ch_end = (rsp_ch_cnt == (data_surface - rsp_cur_ch)); 
wire    [10:0] data_surface_dec_1;
wire           mon_data_surface_dec_1;
assign {mon_data_surface_dec_1,data_surface_dec_1} = data_surface-{8'd0,rsp_cur_ch};
assign is_rsp_ch_end = (rsp_ch_cnt == data_surface_dec_1); 

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_rsp_ch_cnt,rsp_ch_cnt} <= {12{1'b0}};
    end else if (layer_st) begin
        {mon_rsp_ch_cnt,rsp_ch_cnt} <= {12{1'b0}};
    end else if (rsp_ch_reg_en) begin
        if(is_rsp_ch_end)
            {mon_rsp_ch_cnt,rsp_ch_cnt} <= {12{1'b0}};
        else
            {mon_rsp_ch_cnt,rsp_ch_cnt} <= rsp_ch_cnt + rsp_cur_ch;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        rsp_cur_ch <= {3{1'b0}};
    end else begin
        if ((layer_st | rsp_ch_reg_en) == 1'b1) begin
            rsp_cur_ch <= rsp_cur_ch_w;
        end
    end
end


///////////// height counter /////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        rsp_h_cnt <= {12{1'b0}};
    end else if (layer_st) begin
        rsp_h_cnt <= {12{1'b0}};
    end else if(rsp_h_reg_en) begin
        if (is_rsp_h_end)
            rsp_h_cnt <= {12{1'b0}};
        else
            rsp_h_cnt <= rsp_h_cnt + 1'b1;
    end
end

assign is_rsp_h_end = (rsp_h_cnt == rsp_cur_grain-1);

///////////// width counter /////////////
assign rsp_w_left1 = (rsp_w_cnt == {1'b0, data_width_sub_one});
//assign rsp_w_left2 = (rsp_w_cnt == {1'b0, data_width-3'd2});
//assign rsp_w_left3 = (rsp_w_cnt == {1'b0, data_width-3'd3});
//assign rsp_w_left4 = (rsp_w_cnt == {1'b0, data_width-3'd4});
wire    mon_data_width_dec2;
wire  [15:0]  data_width_dec2;
wire    mon_data_width_dec3;
wire  [15:0]  data_width_dec3;
wire    mon_data_width_dec4;
wire  [15:0]  data_width_dec4;
assign {mon_data_width_dec2,data_width_dec2} = data_width-16'd2;
assign {mon_data_width_dec3,data_width_dec3} = data_width-16'd3;
assign {mon_data_width_dec4,data_width_dec4} = data_width-16'd4;
assign rsp_w_left2 = (rsp_w_cnt == data_width_dec2);
assign rsp_w_left3 = (rsp_w_cnt == data_width_dec3);
assign rsp_w_left4 = (rsp_w_cnt == data_width_dec4);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_rsp_w_cnt,rsp_w_cnt} <= {17{1'b0}};
    end else if (layer_st) begin
        {mon_rsp_w_cnt,rsp_w_cnt} <= {17{1'b0}};
    end else if (rsp_w_reg_en) begin
        if(is_rsp_w_end)
            {mon_rsp_w_cnt,rsp_w_cnt} <= {17{1'b0}};
        else
            {mon_rsp_w_cnt,rsp_w_cnt} <= rsp_w_cnt + rsp_w_cnt_add;
    end
end
//assign is_rsp_w_end = (rsp_w_cnt == (data_width-rsp_w_cnt_add));
wire    mon_width_dec;
wire    [15:0]  width_dec;
assign {mon_width_dec,width_dec} = data_width - {13'd0, rsp_w_cnt_add};
assign is_rsp_w_end = (rsp_w_cnt == width_dec);

///////////// response control signal /////////////
//
assign rsp_ch0_rd_one = ~(rsp_cur_ch == 3'h1) |
                        rsp_w_left1 |
                        (is_data_normal & rsp_ch_cnt[1])/* |
                        (is_data_shrink & rsp_ch_cnt[2])*/;
// assign rsp_rd_one = ((rsp_cur_ch == 3'h1) & rsp_w_left1) |
//                     ((rsp_cur_ch == 3'h1) & is_data_normal & rsp_ch_cnt[1]) |
//                     ((rsp_cur_ch == 3'h1) & is_data_shrink & rsp_ch_cnt[2]) |
//                     ((rsp_cur_ch == 3'h3) & is_data_shrink & rsp_ch_cnt[2] & rsp_rd_ch2ch3);
always @(*)
begin
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE/NVDLA_MEMORY_ATOMIC_SIZE;
//: ##my $m = int($dmaif/$atmc);
//: ##if(($dmaif==1) && ($atmc==1)) {
//: if($dmaif==1) {
//:     print qq(
//:         rsp_rd_more_atmm[2:0] = 3'd0;
//:     );
//: } elsif(($dmaif==2) && ($atmc==1)) {
//:     print qq(
//:         if(rsp_w_left1)
//:             rsp_rd_more_atmm[2:0] = 3'b000;
//:         else
//:             rsp_rd_more_atmm[2:0] = 3'b001;
//:     );
//: } elsif(($dmaif==4) && ($atmc==1)) {
//:     print qq(
//:         if(rsp_w_left1)
//:             rsp_rd_more_atmm[2:0] = 3'b000;
//:         else if(rsp_w_left2)
//:             rsp_rd_more_atmm[2:0] = 3'b001;
//:         else if(rsp_w_left3)
//:             rsp_rd_more_atmm[2:0] = 3'b011;
//:         else
//:             rsp_rd_more_atmm[2:0] = 3'b111;
//:     );
//: } elsif(($dmaif==2) && ($atmc==2)) {
//:     print qq(
//:         if(rsp_cur_ch == 3'd2)
//:             rsp_rd_more_atmm[2:0] = 3'b001;
//:         else begin
//:             if(rsp_w_left1)
//:                 rsp_rd_more_atmm[2:0] = 3'b000;
//:             else
//:                 rsp_rd_more_atmm[2:0] = 3'b001;
//:         end
//:     );
//: } elsif(($dmaif==4) && ($atmc==2)) {
//:     print qq(
//:         if(rsp_cur_ch == 3'd2) begin 
//:             if(rsp_w_left1) begin
//:                 rsp_rd_more_atmm[2:0] = 3'b001;
//:             end else begin//(rsp_w_left2)
//:                 rsp_rd_more_atmm[2:0] = 3'b111;
//:             end
//:         end else  begin//rsp_cur_ch==1
//:             if(rsp_w_left1)
//:                 rsp_rd_more_atmm[2:0] = 3'b000;
//:             else if(rsp_w_left2)
//:                 rsp_rd_more_atmm[2:0] = 3'b001;
//:             else if(rsp_w_left3)
//:                 rsp_rd_more_atmm[2:0] = 3'b011;
//:             else //(rsp_w_left4)
//:                 rsp_rd_more_atmm[2:0] = 3'b111;
//:         end
//:     );
//: } elsif(($dmaif==2) && ($atmc==4)) {
//:     print qq(
//:         if(rsp_cur_ch == 3'd2) begin 
//:             rsp_rd_more_atmm[2:0] = 3'b001;
//:         end else  begin//rsp_cur_ch==1
//:             if(rsp_w_left1)
//:                 rsp_rd_more_atmm[2:0] = 3'b000;
//:             else// if(rsp_w_left2)
//:                 rsp_rd_more_atmm[2:0] = 3'b001;
//:         end
//:     );
//: } elsif(($dmaif==4) && ($atmc==4)) {
//:     print qq(
//:         if(rsp_cur_ch == 3'd4) begin 
//:             rsp_rd_more_atmm[2:0] = 3'b111;
//:         end else if(rsp_cur_ch == 3'd3) begin 
//:             rsp_rd_more_atmm[2:0] = 3'b111;
//:         end else if(rsp_cur_ch == 3'd2) begin 
//:             if(rsp_w_left1) begin
//:                 rsp_rd_more_atmm[2:0] = 3'b001;
//:             end else begin // if(rsp_w_left2) begin
//:                 rsp_rd_more_atmm[2:0] = 3'b111;
//:             end
//:         end else begin//rsp_cur_ch==1
//:             if(rsp_w_left1)
//:                 rsp_rd_more_atmm[2:0] = 3'b000;
//:             else if(rsp_w_left2)
//:                 rsp_rd_more_atmm[2:0] = 3'b001;
//:             else if(rsp_w_left3)
//:                 rsp_rd_more_atmm[2:0] = 3'b011;
//:             else //(rsp_w_left4)
//:                 rsp_rd_more_atmm[2:0] = 3'b111;
//:         end
//:     );
//: }
end

// assign rsp_w_cnt_add = (rsp_ch0_rd_one) ? 2'h1 : 2'h2;
assign rsp_ch0_rd_size = rsp_w_cnt_add;
//
// assign rsp_w_reg_en = ~is_rsp_done & is_running &
//                       ((rsp_cur_ch == 3'h1 & (ch0_cnt >= {3'b0, rsp_w_cnt_add})) 
//                       | (rsp_cur_ch == 3'h2 & ch0_aval & ch1_aval)
//                       | (rsp_cur_ch > 3'h2 & rsp_rd_ch2ch3));
assign rsp_w_reg_en = rsp_rd_en;

assign rsp_h_reg_en     = rsp_w_reg_en & is_rsp_w_end;
assign rsp_ch_reg_en    = rsp_h_reg_en & is_rsp_h_end;
assign rsp_batch_reg_en = rsp_ch_reg_en & is_rsp_ch_end;
assign rsp_all_h_reg_en = rsp_batch_reg_en & is_rsp_batch_end;

////////////////////////////////////////////////////////////////////////
//  generate shared buffer rd signals                                 //
////////////////////////////////////////////////////////////////////////
///////////// read enable signal /////////////
assign ch0_aval = (|ch0_cnt);
assign ch1_aval = (|ch1_cnt);
assign ch2_aval = (|ch2_cnt);
assign ch3_aval = (|ch3_cnt);
// assign rsp_rd_en = ~is_rsp_done & is_running &
//                   ((rsp_cur_ch == 3'h1 & (ch0_cnt >= {3'b0, rsp_w_cnt_add})) |
//                    (rsp_cur_ch == 3'h2 & ch0_aval & ch1_aval) |
//                    (rsp_cur_ch == 3'h3 & ~rsp_rd_ch2ch3 & ch0_aval & ch1_aval) |
//                    (rsp_cur_ch == 3'h3 & rsp_rd_ch2ch3 & ch2_aval) |
//                    (rsp_cur_ch == 3'h4 & ~rsp_rd_ch2ch3 & ch0_aval & ch1_aval) |
//                    (rsp_cur_ch == 3'h4 & rsp_rd_ch2ch3 & ch2_aval & ch3_aval));
always @(*)
begin
    if(~is_rsp_done & is_running) begin
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE/NVDLA_MEMORY_ATOMIC_SIZE;
//: ##my $m = int($dmaif/$atmc);
//: ##if(($dmaif==1) && ($atmc==1)) {
//: if($dmaif==1) {
//:     print qq(
//:         rsp_rd_en = ch0_aval;
//:         rsp_w_cnt_add = 3'd1;
//:     );
//: } elsif(($dmaif==2) && ($atmc==1)) {
//:     print qq(
//:         rsp_rd_en = ch0_aval;
//:         if(rsp_w_left1)
//:             rsp_w_cnt_add = 3'd1;
//:         else
//:             rsp_w_cnt_add = 3'd2;
//:     );
//: } elsif(($dmaif==4) && ($atmc==1)) {
//:     print qq(
//:         rsp_rd_en = ch0_aval;
//:         if(rsp_w_left1)
//:             rsp_w_cnt_add = 3'd1;
//:         else if(rsp_w_left2)
//:             rsp_w_cnt_add = 3'd2;
//:         else if(rsp_w_left3)
//:             rsp_w_cnt_add = 3'd3;
//:         else
//:             rsp_w_cnt_add = 3'd4;
//:     );
//: } elsif(($dmaif==2) && ($atmc==2)) {
//:     print qq(
//:         rsp_w_cnt_add = 3'd1;
//:         if(rsp_cur_ch == 3'd2)
//:             rsp_rd_en = ch0_aval & ch1_aval;
//:         else //rsp_cur_ch==1
//:             rsp_rd_en = (ch0_cnt >= {2'b0, rsp_w_cnt_add});
//:     );
//: } elsif(($dmaif==4) && ($atmc==2)) {
//:     print qq(
//:         if(rsp_cur_ch == 3'd2) begin 
//:             if(rsp_w_left1) begin
//:                 rsp_rd_en = ch0_aval;
//:                 rsp_w_cnt_add = 3'd1;
//:             end else begin//(rsp_w_left2)
//:                 rsp_rd_en = ch0_aval & ch1_aval;
//:                 rsp_w_cnt_add = 3'd2;
//:             end
//:         end else  begin//rsp_cur_ch==1
//:             rsp_rd_en = (ch0_cnt >= {2'b0, rsp_w_cnt_add});
//:             if(rsp_w_left1)
//:                 rsp_w_cnt_add = 3'd1;
//:             else if(rsp_w_left2)
//:                 rsp_w_cnt_add = 3'd2;
//:             else if(rsp_w_left3)
//:                 rsp_w_cnt_add = 3'd1;
//:             else //(rsp_w_left4)
//:                 rsp_w_cnt_add = 3'd4;
//:         end
//:     );
//: } elsif(($dmaif==2) && ($atmc==4)) {
//:     print qq(
//:         if(rsp_cur_ch == 3'd2) begin 
//:             rsp_rd_en = ch0_aval & ch1_aval;
//:             rsp_w_cnt_add = 3'd1;
//:         end else  begin//rsp_cur_ch==1
//:             rsp_rd_en = (ch0_cnt >= {2'b0, rsp_w_cnt_add});
//:             if(rsp_w_left1)
//:                 rsp_w_cnt_add = 3'd1;
//:             else// if(rsp_w_left2)
//:                 rsp_w_cnt_add = 3'd2;
//:         end
//:     );
//: } elsif(($dmaif==4) && ($atmc==4)) {
//:     print qq(
//:         if(rsp_cur_ch == 3'd4) begin 
//:             rsp_w_cnt_add = 3'd1;
//:             rsp_rd_en = ch0_aval & ch1_aval & ch2_aval & ch3_aval;
//:         end else if(rsp_cur_ch == 3'd3) begin 
//:             rsp_w_cnt_add = 3'd1;
//:             rsp_rd_en = ch0_aval & ch1_aval & ch2_aval;
//:         end else if(rsp_cur_ch == 3'd2) begin 
//:             rsp_rd_en = ch0_aval & ch1_aval;
//:             if(rsp_w_left1) begin
//:                 rsp_w_cnt_add = 3'd1;
//:             end else begin // if(rsp_w_left2) begin
//:                 rsp_w_cnt_add = 3'd2;
//:             end
//:         end else begin//rsp_cur_ch==1
//:             rsp_rd_en = (ch0_cnt >= {2'b0, rsp_w_cnt_add});
//:             if(rsp_w_left1)
//:                 rsp_w_cnt_add = 3'd1;
//:             else if(rsp_w_left2)
//:                 rsp_w_cnt_add = 3'd2;
//:             else if(rsp_w_left3)
//:                 rsp_w_cnt_add = 3'd1;
//:             else //(rsp_w_left4)
//:                 rsp_w_cnt_add = 3'd4;
//:         end
//:     );
//: }
    end else begin
        rsp_rd_en = 1'b0;
        rsp_w_cnt_add = 3'd0;
    end
end

assign p0_rd_en_w = rsp_rd_en;
// assign p1_rd_en_w = rsp_rd_en & ~rsp_rd_one;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
//: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
//: if($M > 1) {
//:     foreach my $k (0..$M-2) {
//:         my $i = $k +1;
//:         print qq(
//:             assign p${i}_rd_en_w = rsp_rd_en & rsp_rd_more_atmm[$k];
//:         );
//:     }
//: }
///////////// channel address counter /////////////
assign ch0_rd_addr_cnt_reg_en = rsp_rd_en & ~rsp_rd_ch2ch3;
assign ch1_rd_addr_cnt_reg_en = rsp_rd_en & (rsp_cur_ch >= 3'h2) & ~rsp_rd_ch2ch3;
assign ch2_rd_addr_cnt_reg_en = rsp_rd_en & (rsp_cur_ch >= 3'h3) & rsp_rd_ch2ch3;
assign ch3_rd_addr_cnt_reg_en = rsp_rd_en & (rsp_cur_ch == 3'h4) & rsp_rd_ch2ch3;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_ch0_p0_rd_addr_cnt,ch0_p0_rd_addr_cnt} <= 7'b0;
        {mon_ch0_p1_rd_addr_cnt,ch0_p1_rd_addr_cnt} <= 7'b1;
    end else if(layer_st) begin
        {mon_ch0_p0_rd_addr_cnt,ch0_p0_rd_addr_cnt} <= 7'b0;
        {mon_ch0_p1_rd_addr_cnt,ch0_p1_rd_addr_cnt} <= 7'b1;
    end else if(ch0_rd_addr_cnt_reg_en) begin
        {mon_ch0_p0_rd_addr_cnt,ch0_p0_rd_addr_cnt} <= ch0_p0_rd_addr_cnt + {3'd0,rsp_ch0_rd_size};
        {mon_ch0_p1_rd_addr_cnt,ch0_p1_rd_addr_cnt} <= ch0_p1_rd_addr_cnt + {3'd0,rsp_ch0_rd_size};
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_ch1_p0_rd_addr_cnt,ch1_p0_rd_addr_cnt} <= 7'b0;
        {mon_ch1_p1_rd_addr_cnt,ch1_p1_rd_addr_cnt} <= 7'b1;
    end else if(layer_st) begin
        {mon_ch1_p0_rd_addr_cnt,ch1_p0_rd_addr_cnt} <= 7'b0;
        {mon_ch1_p1_rd_addr_cnt,ch1_p1_rd_addr_cnt} <= 7'b1;
    end else if(ch1_rd_addr_cnt_reg_en) begin
        {mon_ch1_p0_rd_addr_cnt,ch1_p0_rd_addr_cnt} <= ch1_p0_rd_addr_cnt + {3'd0,rsp_ch0_rd_size};
        {mon_ch1_p1_rd_addr_cnt,ch1_p1_rd_addr_cnt} <= ch1_p1_rd_addr_cnt + {3'd0,rsp_ch0_rd_size};
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_ch2_p0_rd_addr_cnt,ch2_p0_rd_addr_cnt} <= 7'b0;
    end else if(layer_st) begin
        {mon_ch2_p0_rd_addr_cnt,ch2_p0_rd_addr_cnt} <= 7'b0;
    end else if(ch2_rd_addr_cnt_reg_en) begin
        {mon_ch2_p0_rd_addr_cnt,ch2_p0_rd_addr_cnt} <= ch2_p0_rd_addr_cnt + {3'd0,rsp_ch0_rd_size};
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_ch3_p0_rd_addr_cnt,ch3_p0_rd_addr_cnt} <= 7'b0;
    end else if(layer_st) begin
        {mon_ch3_p0_rd_addr_cnt,ch3_p0_rd_addr_cnt} <= 7'b0;
    end else if(ch3_rd_addr_cnt_reg_en) begin
        {mon_ch3_p0_rd_addr_cnt,ch3_p0_rd_addr_cnt} <= ch3_p0_rd_addr_cnt + {3'd0,rsp_ch0_rd_size};
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        rsp_rd_ch2ch3 <= 1'b0;
    end else if(layer_st) begin
        rsp_rd_ch2ch3 <= 1'b0;
        if (rsp_rd_en) begin
            if((rsp_cur_ch <= 3'h2))
                rsp_rd_ch2ch3 <= 1'b0;
            else
                rsp_rd_ch2ch3 <= ~rsp_rd_ch2ch3;
        end
    end
end

assign ch0_p0_rd_addr = {2'h0, ch0_p0_rd_addr_cnt[0], ch0_p0_rd_addr_cnt[8 -3:1]};
assign ch0_p1_rd_addr = {2'h0, ch0_p1_rd_addr_cnt[0], ch0_p1_rd_addr_cnt[8 -3:1]};
assign ch1_p0_rd_addr = {2'h1, ch1_p0_rd_addr_cnt[0], ch1_p0_rd_addr_cnt[8 -3:1]};
assign ch1_p1_rd_addr = {2'h1, ch1_p1_rd_addr_cnt[0], ch1_p1_rd_addr_cnt[8 -3:1]};
assign ch2_p0_rd_addr = {2'h2, ch2_p0_rd_addr_cnt[0], ch2_p0_rd_addr_cnt[8 -3:1]};
assign ch3_p0_rd_addr = {2'h3, ch3_p0_rd_addr_cnt[0], ch3_p0_rd_addr_cnt[8 -3:1]};

///////////// shared buffer read address /////////////
always @(*) begin
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $m = int($dmaif/$atmc+0.99);
//: ##foreach my $k (0..$m-1){
//: ##    print " p${k}_rd_addr_w = 8'd0; \n";
//: ##}
//: ##if(($dmaif==1) && ($atmc==1)) {
//: if($dmaif==1) {
//:     print qq(
//:         p0_rd_addr_w = ch0_p0_rd_addr;
//:     );
//: } elsif(($dmaif==2) && ($atmc==1)) {
//:     print qq(
//:         p0_rd_addr_w = ch0_p0_rd_addr;
//:         p1_rd_addr_w = ch0_p1_rd_addr;
//:     );
//: } elsif(($dmaif==4) && ($atmc==1)) {
//:     print qq(
//:         p0_rd_addr_w = ch0_p0_rd_addr;
//:         p1_rd_addr_w = ch0_p1_rd_addr;
//:         p2_rd_addr_w = ch0_p0_rd_addr;
//:         p3_rd_addr_w = ch0_p1_rd_addr;
//:     );
//: } elsif(($dmaif==2) && ($atmc==2)) {
//:     print qq(
//:         if(rsp_cur_ch == 3'd2) begin
//:             p0_rd_addr_w = ch0_p0_rd_addr;
//:             p1_rd_addr_w = ch1_p0_rd_addr;
//:         end else begin //rsp_cur_ch==1
//:             p0_rd_addr_w = ch0_p0_rd_addr;
//:             p1_rd_addr_w = ch0_p1_rd_addr;
//:         end
//:     );
//: } elsif(($dmaif==4) && ($atmc==2)) {
//:     print qq(
//:         if(rsp_cur_ch == 3'd2) begin 
//:             if(rsp_w_left1) begin
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = ch1_p0_rd_addr;
//:                 p2_rd_addr_w = 8'd0;
//:                 p3_rd_addr_w = 8'd0;
//:             end else begin//(rsp_w_left2)
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = ch1_p0_rd_addr;
//:                 p2_rd_addr_w = ch0_p0_rd_addr;
//:                 p3_rd_addr_w = ch1_p0_rd_addr;
//:             end
//:         end else  begin//rsp_cur_ch==1
//:             if(rsp_w_left1) begin
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = 8'd0;
//:                 p2_rd_addr_w = 8'd0;
//:                 p3_rd_addr_w = 8'd0;
//:             end else if(rsp_w_left2) begin
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = ch0_p1_rd_addr;
//:                 p2_rd_addr_w = 8'd0;
//:                 p3_rd_addr_w = 8'd0;
//:             end else if(rsp_w_left3) begin
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = ch0_p1_rd_addr;
//:                 p2_rd_addr_w = ch0_p0_rd_addr;
//:                 p3_rd_addr_w = 8'd0;
//:             end else begin //(rsp_w_left4) 
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = ch0_p1_rd_addr;
//:                 p2_rd_addr_w = ch0_p0_rd_addr;
//:                 p3_rd_addr_w = ch0_p1_rd_addr;
//:             end
//:         end
//:     );
//: } elsif(($dmaif==2) && ($atmc==4)) {
//:     print qq(
//:         if(rsp_cur_ch == 3'd2) begin 
//:             p0_rd_addr_w = ch0_p0_rd_addr;
//:             p1_rd_addr_w = ch1_p0_rd_addr;
//:         end else  begin//rsp_cur_ch==1
//:             if(rsp_w_left1) begin
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = 8'd0;
//:             end else begin // if(rsp_w_left2)
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = ch0_p1_rd_addr;
//:             end
//:         end
//:     );
//: } elsif(($dmaif==4) && ($atmc==4)) {
//:     print qq(
//:         if(rsp_cur_ch == 3'd4) begin 
//:             p0_rd_addr_w = ch0_p0_rd_addr;
//:             p1_rd_addr_w = ch1_p0_rd_addr;
//:             p2_rd_addr_w = ch2_p0_rd_addr;
//:             p3_rd_addr_w = ch3_p0_rd_addr;
//:         end else if(rsp_cur_ch == 3'd3) begin 
//:             p0_rd_addr_w = ch0_p0_rd_addr;
//:             p1_rd_addr_w = ch1_p0_rd_addr;
//:             p2_rd_addr_w = ch2_p0_rd_addr;
//:             p3_rd_addr_w = 8'd0;
//:         end else if(rsp_cur_ch == 3'd2) begin 
//:             if(rsp_w_left1) begin
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = ch1_p0_rd_addr;
//:                 p2_rd_addr_w = 8'd0;
//:                 p3_rd_addr_w = 8'd0;
//:             end else begin // if(rsp_w_left2) begin
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = ch1_p0_rd_addr;
//:                 p2_rd_addr_w = ch0_p1_rd_addr;
//:                 p3_rd_addr_w = ch1_p1_rd_addr;
//:             end
//:         end else begin//rsp_cur_ch==1
//:             if(rsp_w_left1) begin
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = 8'd0;
//:                 p2_rd_addr_w = 8'd0;
//:                 p3_rd_addr_w = 8'd0;
//:             end else if(rsp_w_left2) begin
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = ch0_p1_rd_addr;
//:                 p2_rd_addr_w = 8'd0;
//:                 p3_rd_addr_w = 8'd0;
//:             end else if(rsp_w_left3) begin
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = ch0_p1_rd_addr;
//:                 p2_rd_addr_w = ch0_p0_rd_addr;
//:                 p3_rd_addr_w = 8'd0;
//:             end else begin //(rsp_w_left4)
//:                 p0_rd_addr_w = ch0_p0_rd_addr;
//:                 p1_rd_addr_w = ch0_p1_rd_addr;
//:                 p2_rd_addr_w = ch0_p0_rd_addr;
//:                 p3_rd_addr_w = ch0_p1_rd_addr;
//:             end
//:         end
//:     );
//: }
end

// assign p0_rd_addr_w = rsp_rd_ch2ch3 ? ch2_p0_rd_addr : ch0_p0_rd_addr;
// assign p1_rd_addr_w = (rsp_cur_ch == 3'h1) ? ch0_p1_rd_addr : ( rsp_rd_ch2ch3 ? ch3_p0_rd_addr : ch1_p0_rd_addr);

///////////// blocking signal /////////////
// assign is_blocking_w = (~is_running | layer_st) ? 1'b0 : (~is_blocking & rsp_rd_en & rsp_ch0_rd_one);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        is_blocking <= 1'b0;
    end else if(~is_running | layer_st) begin
        is_blocking <= 1'b0;
    end else begin
        is_blocking <= ~is_blocking & rsp_rd_en & rsp_ch0_rd_one;
    end
end

///////////// output to shared buffer /////////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
//: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
//: foreach my $k (0..$M-1) {
//: print qq(
//:     dc2sbuf_p${k}_rd_en <= 1'b0;
//: );
//: }
//: print qq(
//:     end else begin
//: );
//: foreach my $k (0..$M-1) {
//: print qq(
//:     dc2sbuf_p${k}_rd_en <= p${k}_rd_en_w;
//: );
//: }
    end
end

//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
//: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
//: foreach my $k (0..$M-1) {
//: print qq(
//:     always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:         if (!nvdla_core_rstn) begin
//:             dc2sbuf_p${k}_rd_addr <= {8{1'b0}};
//:         end else if (p${k}_rd_en_w) begin
//:             dc2sbuf_p${k}_rd_addr <= p${k}_rd_addr_w;
//:         end
//:     end
//: );
//: }

////////////////////////////////////////////////////////////////////////
//  generate write signal to convertor                                //
////////////////////////////////////////////////////////////////////////
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE/NVDLA_MEMORY_ATOMIC_SIZE;
//: if(($dmaif==1) && ($atmc==1)) {
//:     print qq(
//:         assign {mon_idx_ch_offset_w,
//:                 idx_ch_offset_w} = (layer_st) ? 18'b0 :
//:                                   (is_rsp_ch_end) ? {1'b0, idx_batch_offset_w} :
//:                                   idx_ch_offset + data_width;
//:         assign is_w_cnt_div4 = 1'b0;
//:         assign is_w_cnt_div2 = 1'b0;
//:     );
//: } elsif(($dmaif==1) && ($atmc==2)) {
//:     print qq(
//:         assign {mon_idx_ch_offset_w,
//:                 idx_ch_offset_w} = (layer_st) ? 18'b0 :
//:                                   (is_rsp_ch_end) ? {1'b0, idx_batch_offset_w} :
//:                                   (rsp_ch_cnt[0]) ? idx_ch_offset + data_width : idx_ch_offset;
//:         assign is_w_cnt_div4 = 1'b0;
//:         assign is_w_cnt_div2 = (is_data_normal & is_rsp_ch_end & ~rsp_ch_cnt[0] & (rsp_cur_ch == 3'h2));
//:         assign cbuf_wr_hsel_w = (is_w_cnt_div2 & rsp_w_cnt[0]) | (is_data_normal & rsp_ch_cnt[0]) ;
//:     );
//: } elsif(($dmaif==1) && ($atmc==4)) {
//:     print qq(
//:         assign {mon_idx_ch_offset_w,
//:                 idx_ch_offset_w} = (layer_st) ? 18'b0 :
//:                                   (is_rsp_ch_end) ? {1'b0, idx_batch_offset_w} :
//:                                   (&rsp_ch_cnt[1:0]) ? idx_ch_offset + data_width : idx_ch_offset;
//:         //assign is_w_cnt_div4 = (is_data_normal & is_rsp_ch_end & ~rsp_ch_cnt[2] & (rsp_cur_ch == 3'h1));
//:         //assign is_w_cnt_div2 = (is_data_normal & is_rsp_ch_end & ~rsp_ch_cnt[2] & (rsp_cur_ch == 3'h2));
//:         assign is_w_cnt_div4 = is_data_normal & (data_surface[1:0] == 2'b01) & (data_surface - rsp_ch_cnt == 1);
//:         assign is_w_cnt_div2 = is_data_normal & (data_surface[1:0] == 2'b10) & (data_surface - rsp_ch_cnt <= 2);
//:         assign cbuf_wr_hsel_w[0] = (is_w_cnt_div4 & rsp_w_cnt[0]) | (is_w_cnt_div2 & rsp_ch_cnt[0]) | (is_data_normal & rsp_ch_cnt[0]) ;
//:         assign cbuf_wr_hsel_w[1] = (is_w_cnt_div4 & rsp_w_cnt[1]) | (is_w_cnt_div2 & rsp_w_cnt[0]) | (is_data_normal & rsp_ch_cnt[1]) ;
//:     );
//: } elsif((($dmaif==2) || ($dmaif==4)) && ($atmc==1)) {
//:     print qq(
//:         assign {mon_idx_ch_offset_w,
//:                 idx_ch_offset_w} = (layer_st) ? 18'b0 :
//:                                   (is_rsp_ch_end) ? {1'b0, idx_batch_offset_w} :
//:                                   idx_ch_offset + data_width;
//:         assign is_w_cnt_div4 = 1'b0;
//:         assign is_w_cnt_div2 = 1'b0;
//:     );
//: } elsif((($dmaif==2) || ($dmaif==4)) && ($atmc==2)) {
//:     print qq(
//:         assign {mon_idx_ch_offset_w,
//:                 idx_ch_offset_w} = (layer_st) ? 18'b0 :
//:                                   (is_rsp_ch_end) ? {1'b0, idx_batch_offset_w} :
//:                                   (rsp_ch_cnt[0]) ? idx_ch_offset + data_width : idx_ch_offset;
//:         assign is_w_cnt_div4 = 1'b0;
//:         assign is_w_cnt_div2 = (is_data_normal & is_rsp_ch_end & ~rsp_ch_cnt[0] & (rsp_cur_ch == 3'h2));
//:     );
//: } elsif(($dmaif==2) && ($atmc==4)) {
//:     print qq(
//:         assign {mon_idx_ch_offset_w,
//:                 idx_ch_offset_w} = (layer_st) ? 18'b0 :
//:                                   (is_rsp_ch_end) ? {1'b0, idx_batch_offset_w} :
//:                                   (rsp_ch_cnt[1]) ? idx_ch_offset + data_width : idx_ch_offset;
//:         assign is_w_cnt_div4 = (is_data_normal & is_rsp_ch_end & ~rsp_ch_cnt[1] & (rsp_cur_ch == 3'h1));
//:         assign is_w_cnt_div2 = (is_data_normal & is_rsp_ch_end & ~rsp_ch_cnt[1] & (rsp_cur_ch == 3'h2));
//:         assign cbuf_wr_hsel_w = (is_w_cnt_div4 & rsp_w_cnt[1]) | (is_w_cnt_div2 & rsp_w_cnt[0]) | (is_data_normal & rsp_ch_cnt[1]) ;
//:     );
//: } elsif(($dmaif==4) && ($atmc==4)) {
//:     print qq(
//:         assign {mon_idx_ch_offset_w,
//:                 idx_ch_offset_w} = (layer_st) ? 18'b0 :
//:                                   (is_rsp_ch_end) ? {1'b0, idx_batch_offset_w} :
//:                                   (rsp_ch_cnt[1]) ? idx_ch_offset + data_width : idx_ch_offset;
//:         assign is_w_cnt_div4 = (is_data_normal & is_rsp_ch_end & ~rsp_ch_cnt[1] & (rsp_cur_ch == 3'h1));
//:         assign is_w_cnt_div2 = (is_data_normal & is_rsp_ch_end & ~rsp_ch_cnt[1] & (rsp_cur_ch == 3'h2));
//:     );
//: }

assign {mon_idx_batch_offset_w, idx_batch_offset_w} = (layer_st | is_rsp_batch_end) ? 19'b0 : (idx_batch_offset + data_entries);

assign {mon_idx_h_offset_w,
        idx_h_offset_w} = (layer_st) ? 18'b0 :
                         (is_rsp_h_end) ? {1'b0, idx_ch_offset_w} :
                         (is_rsp_all_h_end) ? idx_h_offset + rsp_batch_entry_last : idx_h_offset + rsp_batch_entry_init;

// assign {mon_idx_ch_offset_w,
//         idx_ch_offset_w} = (layer_st) ? 18'b0 :
//                           (is_rsp_ch_end) ? {1'b0, idx_batch_offset_w} :
//                           (rsp_ch_cnt[1]) ? idx_ch_offset + data_width[12:0] : idx_ch_offset;
// 
// assign is_w_cnt_div4 = (is_data_normal & is_rsp_ch_end & ~rsp_ch_cnt[1] & (rsp_cur_ch == 3'h1));
// assign is_w_cnt_div2 = (is_data_normal & is_rsp_ch_end & ~rsp_ch_cnt[1] & (rsp_cur_ch == 3'h2));
// 
// assign cbuf_wr_hsel_w = (is_w_cnt_div4 & rsp_w_cnt[1]) | (is_w_cnt_div2 & rsp_w_cnt[0]) | (is_data_normal & rsp_ch_cnt[1]) ;

//assign idx_w_offset_add = is_w_cnt_div4 ? {rsp_w_cnt[12 +2:2]} : ( is_w_cnt_div2 ? rsp_w_cnt[12+1 :1] : rsp_w_cnt[12:0] );
assign idx_w_offset_add = is_w_cnt_div4 ? {1'b0,rsp_w_cnt[15:2]} : ( is_w_cnt_div2 ? rsp_w_cnt[14+1 :1] : rsp_w_cnt[14:0] );
assign {mon_cbuf_idx_inc[2:0], cbuf_idx_inc} = idx_base + (idx_grain_offset + idx_h_offset) + idx_w_offset_add;
assign is_cbuf_idx_wrap = cbuf_idx_inc >= {1'b0, data_bank, 9'b0};
assign cbuf_idx_w = ~is_cbuf_idx_wrap ? {2'b0, cbuf_idx_inc[14:0]} : {2'd0,cbuf_idx_inc[14 :0]} - {2'b0, data_bank, 9'b0};

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        idx_base <= 0;
    end else begin
        if ((is_first_running) == 1'b1) begin
            idx_base <= status2dma_wr_idx;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        idx_batch_offset <= 0;
    end else begin
        if ((layer_st | rsp_batch_reg_en) == 1'b1) begin
            idx_batch_offset <= idx_batch_offset_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        idx_ch_offset <= 0;
    end else begin
        if ((layer_st | rsp_ch_reg_en) == 1'b1) begin
            idx_ch_offset <= idx_ch_offset_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        idx_h_offset <= {18{1'b0}};
    end else begin
        if ((layer_st | rsp_h_reg_en) == 1'b1) begin
            idx_h_offset <= idx_h_offset_w;
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        {mon_idx_grain_offset,idx_grain_offset} <= {19{1'b0}};
    end else if(layer_st) begin
        {mon_idx_grain_offset,idx_grain_offset} <= {19{1'b0}};
    end else if(rsp_all_h_reg_en) begin
        {mon_idx_grain_offset,idx_grain_offset} <= idx_grain_offset + rsp_entry;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        cbuf_wr_en <= 1'b0;
    end else begin
        cbuf_wr_en <= rsp_rd_en;
    end
end
//
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $m = int($dmaif/$atmc+0.99);
//: foreach my $i (0..$m-1) {
//:     print qq(
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:             if (!nvdla_core_rstn) begin
//:                 cbuf_wr_addr_$i <= 0;
//:             end else if(rsp_w_reg_en) begin
//:                 cbuf_wr_addr_$i <= cbuf_idx_w + $i;
//:             end
//:         end
//:     );
//: }


//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE/NVDLA_MEMORY_ATOMIC_SIZE;
//: if($dmaif < $atmc) {
//:     print qq(
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:             if (!nvdla_core_rstn) begin
//:                 cbuf_wr_hsel <= 0;
//:             end else begin
//:                 if ((rsp_w_reg_en) == 1'b1) begin
//:                     cbuf_wr_hsel <= cbuf_wr_hsel_w;
//:                 end
//:             end
//:         end
//:     );
//: } elsif($dmaif > $atmc) {
//:     print qq(
//:         reg  [$dmaif-1:0]   cbuf_wr_mask;
//:         wire [$dmaif-1:0]   cbuf_wr_mask_d0;
//:         reg  [$dmaif-1:0]   cbuf_wr_mask_d1;
//:         reg  [$dmaif-1:0]   cbuf_wr_mask_d2;
//:         reg  [$dmaif-1:0]   cbuf_wr_mask_d3;
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:             if (!nvdla_core_rstn) begin
//:                 cbuf_wr_mask <= 0;
//:             end else begin
//:                 cbuf_wr_mask <= {;
//:     );
//:     if($dmaif > 1) {
//:         foreach my $k (0..$dmaif-2) {
//:         my $i = $dmaif - $k -2;
//:             print " p${i}_rd_en_w, ";
//:         }
//:     }
//:     print qq(
//:               p0_rd_en_w};
//:            end
//:        end
//:     );
//: }

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        cbuf_wr_info_mask <= 0;
    end else begin
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
//: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
//:     print " cbuf_wr_info_mask <= {{(4-$M){1'b0}}   ";
//: foreach my $k (0..$M-1) {
//: my $i = $M - $k -1;
//:     print " ,p${i}_rd_en_w  ";
//: }
       };
    end
end

assign cbuf_wr_info_pd[3:0] =   cbuf_wr_info_mask[3:0];
assign cbuf_wr_info_pd[4] =     1'b0;//cbuf_wr_info_interleave ;
assign cbuf_wr_info_pd[5] =     1'b0;//cbuf_wr_info_ext64 ;
assign cbuf_wr_info_pd[6] =     1'b0;//cbuf_wr_info_ext128 ;
assign cbuf_wr_info_pd[7] =     1'b0;//cbuf_wr_info_mean ;
assign cbuf_wr_info_pd[8] =     1'b0;//cbuf_wr_info_uint ;
assign cbuf_wr_info_pd[11:9] =  3'd0;//cbuf_wr_info_sub_h[2:0];

////////////////////////////////////////////////////////////////////////
//  pipeline to sync the sbuf read to output to convertor             //
////////////////////////////////////////////////////////////////////////
assign cbuf_wr_en_d0      = cbuf_wr_en;
assign cbuf_wr_info_pd_d0 = cbuf_wr_info_pd;
//
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $latency = (CDMA_SBUF_RD_LATENCY+1);
//: 
//: if($dmaif < $atmc) {
//:     print qq( assign cbuf_wr_hsel_d0    = cbuf_wr_hsel; );
//:     foreach my $i (0..$latency-1) {
//:         my $j = $i + 1;
//:         print qq(
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:             if (!nvdla_core_rstn) begin
//:                 cbuf_wr_hsel_d${j} <= 1'b0;
//:             end else if (cbuf_wr_en_d${i}) begin
//:                 cbuf_wr_hsel_d${j} <= cbuf_wr_hsel_d${i};
//:             end
//:         end
//:         );
//:     }
//: } elsif($dmaif > $atmc) {
//:     print qq( assign cbuf_wr_mask_d0    = cbuf_wr_mask; );
//:     foreach my $i (0..$latency-1) {
//:         my $j = $i + 1;
//:         print qq(
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:             if (!nvdla_core_rstn) begin
//:                 cbuf_wr_mask_d${j} <= 1'b0;
//:             end else if (cbuf_wr_en_d${i}) begin
//:                 cbuf_wr_mask_d${j} <= cbuf_wr_mask_d${i};
//:             end
//:         end
//:         );
//:     }
//: }
//: ###################################################################
//: my $m = int($dmaif/$atmc+0.99);
//: foreach my $i (0..$m-1) {
//:     print qq(
//:         assign cbuf_wr_addr_d0_${i}    = cbuf_wr_addr_${i};
//:     );
//:     foreach my $k (0..$latency-1) {
//:     my $j = $k + 1;
//:         print qq(
//:             always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:                 if (!nvdla_core_rstn) begin
//:                     cbuf_wr_addr_d${j}_${i} <= 0;
//:                 end else if ((cbuf_wr_en_d${k}) == 1'b1) begin
//:                     cbuf_wr_addr_d${j}_${i} <= cbuf_wr_addr_d${k}_${i};
//:                 end
//:             end
//:         );
//:     }
//: }

////////////////////////////////////
//: my $latency = (CDMA_SBUF_RD_LATENCY+1);
//: foreach my $i (0..$latency-1) {
//: my $j = $i + 1;
//:     print qq (
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:             if (!nvdla_core_rstn) begin
//:                 cbuf_wr_en_d${j} <= 1'b0;
//:             end else begin
//:                 cbuf_wr_en_d${j} <= cbuf_wr_en_d${i};
//:             end
//:         end
//: 
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:             if (!nvdla_core_rstn) begin
//:                 cbuf_wr_info_pd_d${j} <= {12{1'b0}};
//:             end else if(cbuf_wr_en_d${i}) begin
//:                 cbuf_wr_info_pd_d${j} <= cbuf_wr_info_pd_d${i};
//:             end
//:         end
//:     );
//: }

// ###################################################################
//: my $latency = (CDMA_SBUF_RD_LATENCY+1);
//: my $lb = $latency - 1;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE/NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE/NVDLA_MEMORY_ATOMIC_SIZE;
//: if($dmaif <= $atmc) {
//:     print qq (
//:         always @(posedge nvdla_core_clk) begin
//:             if (cbuf_wr_en_d${lb}) begin
//:                 cbuf_wr_data_d${latency}_0 <= {
//:     );
//:         if($dmaif > 1){
//:             foreach my $p (0..$dmaif-2){
//:             my $q = $dmaif -$p -1;
//:                 print qq( dc2sbuf_p${q}_rd_data, );
//:             }
//:         }
//:     print qq (
//:                 dc2sbuf_p0_rd_data};
//:             end
//:         end
//:     );
//: } else { 
//:     my $cnum = int($dmaif/$atmc);
//:     foreach my $k (0.. $cnum-1){
//:         my $ks = $k * $atmc;
//:         print qq (
//:             always @(posedge nvdla_core_clk) begin
//:                 if (cbuf_wr_en_d${lb}) begin
//:                     cbuf_wr_data_d${latency}_${k} <= {
//:         );
//:             if($atmc > 1){
//:                 foreach my $p (0..$atmc-2){
//:                 my $q = $atmc -$p -1;
//:                 my $bs = $q + $ks;
//:                     print qq( dc2sbuf_p${bs}_rd_data, );
//:                 }
//:             }
//:         print qq (
//:                     dc2sbuf_p${ks}_rd_data};
//:                 end
//:             end
//:         );
//:     }
//: } 
//: ###################################################################
//: 
//: if($dmaif <= $atmc) {
//:     print qq(
//:     assign dc2cvt_dat_wr_addr = cbuf_wr_addr_d${latency}_0;
//:     assign dc2cvt_dat_wr_data = cbuf_wr_data_d${latency}_0;
//:     );
//: } else {
//: my $m = int($dmaif/$atmc+0.99);
//:     foreach my $i (0..$m-1) {
//:         print qq(
//:         assign dc2cvt_dat_wr_addr${i}   = cbuf_wr_addr_d${latency}_${i};
//:         assign dc2cvt_dat_wr_data${i}   = cbuf_wr_data_d${latency}_${i};
//:         );
//:     }
//: }
//: ###################################################################
//: print qq (
//:     assign dc2cvt_dat_wr_en      = cbuf_wr_en_d${latency};
//:     assign dc2cvt_dat_wr_info_pd = cbuf_wr_info_pd_d${latency};
//: );
//: ###################################################################
//: if($dmaif < $atmc) {
//:     print qq (
//:         assign dc2cvt_dat_wr_sel     = cbuf_wr_hsel_d${latency};
//:     );
//: } elsif ($dmaif > $atmc) {
//:     print qq (
//:         assign dc2cvt_dat_wr_mask     = cbuf_wr_mask_d${latency};
//:     );
//: }


//////////////////////////////////////////////////////
//////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//  convolution buffer slices & entries management                    //
////////////////////////////////////////////////////////////////////////
///////////// calculate onfly slices and entries /////////////
assign req_entry = req_csm_sel ? req_entry_1_d3[14:0] : req_entry_0_d3[14:0];
assign rsp_entry = is_rsp_all_h_end ? rsp_entry_last : rsp_entry_init;
assign dc_entry_onfly_add = ~req_grain_reg_en ? 15'b0 : req_entry;
assign dc_entry_onfly_sub = ~dc2status_dat_updt ? 15'b0 : dc2status_dat_entries;

assign {mon_dc_entry_onfly_w,
        dc_entry_onfly_w} = dc_entry_onfly + dc_entry_onfly_add - dc_entry_onfly_sub;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dc_entry_onfly <= {15{1'b0}};
    end else if ((req_grain_reg_en | dc2status_dat_updt) == 1'b1) begin
        dc_entry_onfly <= dc_entry_onfly_w;
    end
end

///////////// calculate if free entries is enough /////////////
assign required_entries = dc_entry_onfly + req_entry;
assign is_free_entries_enough = (required_entries <= {1'b0, status2dma_free_entries});
assign cbuf_is_ready_w = (~is_running | ~req_pre_valid | csm_reg_en) ? 1'b0 : is_free_entries_enough;
assign rsp_slice = is_rsp_all_h_end ? rsp_slice_last : rsp_slice_init;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        cbuf_is_ready <= 1'b0;
    end else begin
        cbuf_is_ready <= cbuf_is_ready_w;
    end
end

///////////// update CDMA data status /////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dat_updt_d0 <= 1'b0;
    end else begin
        dat_updt_d0 <= rsp_all_h_reg_en;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dat_entries_d0 <= {15{1'b0}};
    end else begin
        if ((rsp_all_h_reg_en) == 1'b1) begin
            dat_entries_d0 <= rsp_entry[14:0];//15bit is enough
        end
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dat_slices_d0 <= {14{1'b0}};
    end else begin
        if ((rsp_all_h_reg_en) == 1'b1) begin
            dat_slices_d0 <= rsp_slice;
        end
    end
end

//: my $latency = (CDMA_SBUF_RD_LATENCY + 1);
//: my @list = ("updt", "entries", "slices");
//:    foreach my $i (0..$latency-1) {
//:    my $k = $i + 1;
//:       print qq(
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:             if (!nvdla_core_rstn) begin
//:                 dat_updt_d${k} <= 1'b0;
//:             end else begin
//:                 dat_updt_d${k} <= dat_updt_d${i};
//:             end
//:         end
//:      );
//:      foreach my $j (1..2) {
//:      my $name = $list[$j];
//:       print qq(
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:             if (!nvdla_core_rstn) begin
//:                 dat_${name}_d${k} <= 0;
//:             end else begin
//:                 if ((dat_updt_d${i}) == 1'b1) begin
//:                     dat_${name}_d${k} <= dat_${name}_d${i};
//:                 end
//:             end
//:         end
//:      );
//:     }
//:    }
//:
//:    foreach my $j (0..2) {
//:        my $name = $list[$j];
//:        print qq(
//:             assign dc2status_dat_${name} = dat_${name}_d${latency};
//:        );
//:    }

////////////////////////////////////////////////////////////////////////
//  performance counting register                                     //
////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dc_rd_stall_inc <= 1'b0;
    end else begin
        dc_rd_stall_inc <= dma_rd_req_vld & ~dma_rd_req_rdy & reg2dp_dma_en;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dc_rd_stall_clr <= 1'b0;
    end else begin
        dc_rd_stall_clr <= status2dma_fsm_switch & reg2dp_dma_en;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dc_rd_stall_cen <= 1'b0;
    end else begin
        dc_rd_stall_cen <= reg2dp_op_en & reg2dp_dma_en;
    end
end




assign dp2reg_dc_rd_stall_dec = 1'b0;

// stl adv logic
always @(*) begin
    stl_adv = dc_rd_stall_inc ^ dp2reg_dc_rd_stall_dec;
end
    
// stl cnt logic
always @(*) begin
    // VCS sop_coverage_off start
    stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
    stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
    stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
    stl_cnt_mod[33:0] = (dc_rd_stall_inc && !dp2reg_dc_rd_stall_dec)? stl_cnt_inc : (!dc_rd_stall_inc && dp2reg_dc_rd_stall_dec)? stl_cnt_dec : stl_cnt_ext;
    stl_cnt_new[33:0] = (stl_adv)? stl_cnt_mod[33:0] : stl_cnt_ext[33:0];
    stl_cnt_nxt[33:0] = (dc_rd_stall_clr)? 34'd0 : stl_cnt_new[33:0];
    // VCS sop_coverage_off end
end

// stl flops
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        stl_cnt_cur[31:0] <= 0;
    end else begin
        if (dc_rd_stall_cen) begin
            stl_cnt_cur[31:0] <= stl_cnt_nxt[31:0];
        end
    end
end

// stl output logic
always @(*) begin
    dp2reg_dc_rd_stall[31:0] = stl_cnt_cur[31:0];
end
        
      

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dc_rd_latency_inc <= 1'b0;
    end else begin
        dc_rd_latency_inc <= dma_rd_req_vld & dma_rd_req_rdy & reg2dp_dma_en;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dc_rd_latency_dec <= 1'b0;
    end else begin
        dc_rd_latency_dec <= dma_rsp_fifo_ready & reg2dp_dma_en;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dc_rd_latency_clr <= 1'b0;
    end else begin
        dc_rd_latency_clr <= status2dma_fsm_switch;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dc_rd_latency_cen <= 1'b0;
    end else begin
        dc_rd_latency_cen <= reg2dp_op_en & reg2dp_dma_en;
    end
end



assign ltc_1_inc = (outs_dp2reg_dc_rd_latency!=511) & dc_rd_latency_inc;
assign ltc_1_dec = (outs_dp2reg_dc_rd_latency!=511) & dc_rd_latency_dec;

// ltc_1 adv logic

always @(*) begin
    ltc_1_adv = ltc_1_inc ^ ltc_1_dec;
end
    
// ltc_1 cnt logic
always @(*) begin
    // VCS sop_coverage_off start
    ltc_1_cnt_ext[10:0] = {1'b0, 1'b0, ltc_1_cnt_cur};
    ltc_1_cnt_inc[10:0] = ltc_1_cnt_cur + 1'b1; // spyglass disable W164b
    ltc_1_cnt_dec[10:0] = ltc_1_cnt_cur - 1'b1; // spyglass disable W164b
    ltc_1_cnt_mod[10:0] = (ltc_1_inc && !ltc_1_dec)? ltc_1_cnt_inc : (!ltc_1_inc && ltc_1_dec)? ltc_1_cnt_dec : ltc_1_cnt_ext;
    ltc_1_cnt_new[10:0] = (ltc_1_adv)? ltc_1_cnt_mod[10:0] : ltc_1_cnt_ext[10:0];
    ltc_1_cnt_nxt[10:0] = (dc_rd_latency_clr)? 11'd0 : ltc_1_cnt_new[10:0];
    // VCS sop_coverage_off end
end

// ltc_1 flops

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        ltc_1_cnt_cur[8:0] <= 0;
    end else begin
        if (dc_rd_latency_cen) begin
            ltc_1_cnt_cur[8:0] <= ltc_1_cnt_nxt[8:0];
        end
    end
end

// ltc_1 output logic

always @(*) begin
    outs_dp2reg_dc_rd_latency[8:0] = ltc_1_cnt_cur[8:0];
end
    

assign ltc_2_dec = 1'b0;
assign ltc_2_inc = (~&dp2reg_dc_rd_latency) & (|outs_dp2reg_dc_rd_latency);

// ltc_2 adv logic

always @(*) begin
    ltc_2_adv = ltc_2_inc ^ ltc_2_dec;
end
    
// ltc_2 cnt logic
always @(*) begin
    // VCS sop_coverage_off start
    ltc_2_cnt_ext[33:0] = {1'b0, 1'b0, ltc_2_cnt_cur};
    ltc_2_cnt_inc[33:0] = ltc_2_cnt_cur + 1'b1; // spyglass disable W164b
    ltc_2_cnt_dec[33:0] = ltc_2_cnt_cur - 1'b1; // spyglass disable W164b
    ltc_2_cnt_mod[33:0] = (ltc_2_inc && !ltc_2_dec)? ltc_2_cnt_inc : (!ltc_2_inc && ltc_2_dec)? ltc_2_cnt_dec : ltc_2_cnt_ext;
    ltc_2_cnt_new[33:0] = (ltc_2_adv)? ltc_2_cnt_mod[33:0] : ltc_2_cnt_ext[33:0];
    ltc_2_cnt_nxt[33:0] = (dc_rd_latency_clr)? 34'd0 : ltc_2_cnt_new[33:0];
    // VCS sop_coverage_off end
end

// ltc_2 flops

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        ltc_2_cnt_cur[31:0] <= 0;
    end else begin
        if (dc_rd_latency_cen) begin
            ltc_2_cnt_cur[31:0] <= ltc_2_cnt_nxt[31:0];
        end
    end
end

// ltc_2 output logic

always @(*) begin
    dp2reg_dc_rd_latency[31:0] = ltc_2_cnt_cur[31:0];
end
        
      

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

    property cdma_dc__cbuf_idx_wrap__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (rsp_w_reg_en & is_cbuf_idx_wrap);
    endproperty
    // Cover 0 : "(rsp_w_reg_en & is_cbuf_idx_wrap)"
    FUNCPOINT_cdma_dc__cbuf_idx_wrap__0_COV : cover property (cdma_dc__cbuf_idx_wrap__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cdma_dc__input_fully_connected__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (layer_st & is_packed_1x1);
    endproperty
    // Cover 1 : "(layer_st & is_packed_1x1)"
    FUNCPOINT_cdma_dc__input_fully_connected__1_COV : cover property (cdma_dc__input_fully_connected__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cdma_dc__dc_batch_size_EQ_0__2_0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 0);
    endproperty
    // Cover 2_0 : "reg2dp_batches == 0"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_0__2_0_COV : cover property (cdma_dc__dc_batch_size_EQ_0__2_0_cov);

    property cdma_dc__dc_batch_size_EQ_1__2_1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 1);
    endproperty
    // Cover 2_1 : "reg2dp_batches == 1"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_1__2_1_COV : cover property (cdma_dc__dc_batch_size_EQ_1__2_1_cov);

    property cdma_dc__dc_batch_size_EQ_2__2_2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 2);
    endproperty
    // Cover 2_2 : "reg2dp_batches == 2"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_2__2_2_COV : cover property (cdma_dc__dc_batch_size_EQ_2__2_2_cov);

    property cdma_dc__dc_batch_size_EQ_3__2_3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 3);
    endproperty
    // Cover 2_3 : "reg2dp_batches == 3"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_3__2_3_COV : cover property (cdma_dc__dc_batch_size_EQ_3__2_3_cov);

    property cdma_dc__dc_batch_size_EQ_4__2_4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 4);
    endproperty
    // Cover 2_4 : "reg2dp_batches == 4"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_4__2_4_COV : cover property (cdma_dc__dc_batch_size_EQ_4__2_4_cov);

    property cdma_dc__dc_batch_size_EQ_5__2_5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 5);
    endproperty
    // Cover 2_5 : "reg2dp_batches == 5"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_5__2_5_COV : cover property (cdma_dc__dc_batch_size_EQ_5__2_5_cov);

    property cdma_dc__dc_batch_size_EQ_6__2_6_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 6);
    endproperty
    // Cover 2_6 : "reg2dp_batches == 6"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_6__2_6_COV : cover property (cdma_dc__dc_batch_size_EQ_6__2_6_cov);

    property cdma_dc__dc_batch_size_EQ_7__2_7_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 7);
    endproperty
    // Cover 2_7 : "reg2dp_batches == 7"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_7__2_7_COV : cover property (cdma_dc__dc_batch_size_EQ_7__2_7_cov);

    property cdma_dc__dc_batch_size_EQ_8__2_8_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 8);
    endproperty
    // Cover 2_8 : "reg2dp_batches == 8"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_8__2_8_COV : cover property (cdma_dc__dc_batch_size_EQ_8__2_8_cov);

    property cdma_dc__dc_batch_size_EQ_9__2_9_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 9);
    endproperty
    // Cover 2_9 : "reg2dp_batches == 9"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_9__2_9_COV : cover property (cdma_dc__dc_batch_size_EQ_9__2_9_cov);

    property cdma_dc__dc_batch_size_EQ_10__2_10_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 10);
    endproperty
    // Cover 2_10 : "reg2dp_batches == 10"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_10__2_10_COV : cover property (cdma_dc__dc_batch_size_EQ_10__2_10_cov);

    property cdma_dc__dc_batch_size_EQ_11__2_11_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 11);
    endproperty
    // Cover 2_11 : "reg2dp_batches == 11"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_11__2_11_COV : cover property (cdma_dc__dc_batch_size_EQ_11__2_11_cov);

    property cdma_dc__dc_batch_size_EQ_12__2_12_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 12);
    endproperty
    // Cover 2_12 : "reg2dp_batches == 12"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_12__2_12_COV : cover property (cdma_dc__dc_batch_size_EQ_12__2_12_cov);

    property cdma_dc__dc_batch_size_EQ_13__2_13_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 13);
    endproperty
    // Cover 2_13 : "reg2dp_batches == 13"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_13__2_13_COV : cover property (cdma_dc__dc_batch_size_EQ_13__2_13_cov);

    property cdma_dc__dc_batch_size_EQ_14__2_14_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 14);
    endproperty
    // Cover 2_14 : "reg2dp_batches == 14"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_14__2_14_COV : cover property (cdma_dc__dc_batch_size_EQ_14__2_14_cov);

    property cdma_dc__dc_batch_size_EQ_15__2_15_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 15);
    endproperty
    // Cover 2_15 : "reg2dp_batches == 15"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_15__2_15_COV : cover property (cdma_dc__dc_batch_size_EQ_15__2_15_cov);

    property cdma_dc__dc_batch_size_EQ_16__2_16_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 16);
    endproperty
    // Cover 2_16 : "reg2dp_batches == 16"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_16__2_16_COV : cover property (cdma_dc__dc_batch_size_EQ_16__2_16_cov);

    property cdma_dc__dc_batch_size_EQ_17__2_17_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 17);
    endproperty
    // Cover 2_17 : "reg2dp_batches == 17"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_17__2_17_COV : cover property (cdma_dc__dc_batch_size_EQ_17__2_17_cov);

    property cdma_dc__dc_batch_size_EQ_18__2_18_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 18);
    endproperty
    // Cover 2_18 : "reg2dp_batches == 18"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_18__2_18_COV : cover property (cdma_dc__dc_batch_size_EQ_18__2_18_cov);

    property cdma_dc__dc_batch_size_EQ_19__2_19_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 19);
    endproperty
    // Cover 2_19 : "reg2dp_batches == 19"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_19__2_19_COV : cover property (cdma_dc__dc_batch_size_EQ_19__2_19_cov);

    property cdma_dc__dc_batch_size_EQ_20__2_20_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 20);
    endproperty
    // Cover 2_20 : "reg2dp_batches == 20"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_20__2_20_COV : cover property (cdma_dc__dc_batch_size_EQ_20__2_20_cov);

    property cdma_dc__dc_batch_size_EQ_21__2_21_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 21);
    endproperty
    // Cover 2_21 : "reg2dp_batches == 21"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_21__2_21_COV : cover property (cdma_dc__dc_batch_size_EQ_21__2_21_cov);

    property cdma_dc__dc_batch_size_EQ_22__2_22_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 22);
    endproperty
    // Cover 2_22 : "reg2dp_batches == 22"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_22__2_22_COV : cover property (cdma_dc__dc_batch_size_EQ_22__2_22_cov);

    property cdma_dc__dc_batch_size_EQ_23__2_23_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 23);
    endproperty
    // Cover 2_23 : "reg2dp_batches == 23"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_23__2_23_COV : cover property (cdma_dc__dc_batch_size_EQ_23__2_23_cov);

    property cdma_dc__dc_batch_size_EQ_24__2_24_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 24);
    endproperty
    // Cover 2_24 : "reg2dp_batches == 24"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_24__2_24_COV : cover property (cdma_dc__dc_batch_size_EQ_24__2_24_cov);

    property cdma_dc__dc_batch_size_EQ_25__2_25_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 25);
    endproperty
    // Cover 2_25 : "reg2dp_batches == 25"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_25__2_25_COV : cover property (cdma_dc__dc_batch_size_EQ_25__2_25_cov);

    property cdma_dc__dc_batch_size_EQ_26__2_26_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 26);
    endproperty
    // Cover 2_26 : "reg2dp_batches == 26"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_26__2_26_COV : cover property (cdma_dc__dc_batch_size_EQ_26__2_26_cov);

    property cdma_dc__dc_batch_size_EQ_27__2_27_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 27);
    endproperty
    // Cover 2_27 : "reg2dp_batches == 27"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_27__2_27_COV : cover property (cdma_dc__dc_batch_size_EQ_27__2_27_cov);

    property cdma_dc__dc_batch_size_EQ_28__2_28_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 28);
    endproperty
    // Cover 2_28 : "reg2dp_batches == 28"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_28__2_28_COV : cover property (cdma_dc__dc_batch_size_EQ_28__2_28_cov);

    property cdma_dc__dc_batch_size_EQ_29__2_29_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 29);
    endproperty
    // Cover 2_29 : "reg2dp_batches == 29"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_29__2_29_COV : cover property (cdma_dc__dc_batch_size_EQ_29__2_29_cov);

    property cdma_dc__dc_batch_size_EQ_30__2_30_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 30);
    endproperty
    // Cover 2_30 : "reg2dp_batches == 30"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_30__2_30_COV : cover property (cdma_dc__dc_batch_size_EQ_30__2_30_cov);

    property cdma_dc__dc_batch_size_EQ_31__2_31_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((is_running) && nvdla_core_rstn) |-> (reg2dp_batches == 31);
    endproperty
    // Cover 2_31 : "reg2dp_batches == 31"
    FUNCPOINT_cdma_dc__dc_batch_size_EQ_31__2_31_COV : cover property (cdma_dc__dc_batch_size_EQ_31__2_31_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cdma_dc__dc_reuse__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((cur_state == DC_STATE_IDLE) & (nxt_state == DC_STATE_DONE));
    endproperty
    // Cover 3 : "((cur_state == DC_STATE_IDLE) & (nxt_state == DC_STATE_DONE))"
    FUNCPOINT_cdma_dc__dc_reuse__3_COV : cover property (cdma_dc__dc_reuse__3_cov);

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

  nv_assert_no_x #(0,2,0,"No Xs allowed on cur_state")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1, cur_state); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_rsp_done | is_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(reg2dp_op_en & is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | pre_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_39x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_g0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_40x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_g1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_43x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_init))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_44x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_last))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_50x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | pre_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_51x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | csm_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_52x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_batch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_ch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_58x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_atm_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_59x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_atm_reg_en_0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_60x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_atm_reg_en_1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_61x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_atm_reg_en_2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_62x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_atm_reg_en_3))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_66x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running | req_grain_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_67x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running | req_batch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_68x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running | req_ch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_69x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running | req_atm_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_75x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_81x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dma_rd_rsp_vld & ~is_blocking))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_86x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch0_wr_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_87x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch1_wr_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_88x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch2_wr_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_89x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch3_wr_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_95x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch0_wr_addr_cnt_reg_en | ch0_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_96x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch1_wr_addr_cnt_reg_en | ch1_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_97x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch2_wr_addr_cnt_reg_en | ch2_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_98x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch3_wr_addr_cnt_reg_en | ch3_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_103x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_all_h_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_107x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_batch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_108x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_ch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_113x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_h_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_115x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_w_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_116x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch0_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_117x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch1_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_118x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch2_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_119x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch3_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_121x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_rd_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_123x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(p0_rd_en_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_124x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(p1_rd_en_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_125x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_126x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_batch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_127x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_ch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_128x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_h_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_129x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_all_h_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_130x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_w_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_141x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_wr_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_144x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_wr_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_147x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_wr_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_150x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_grain_reg_en | dc2status_dat_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_154x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_all_h_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_156x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_158x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_160x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 

  //nv_assert_never #(0,0,"Error config! data bank is not big enough!")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (is_running & ((data_bank * 256) < (data_entries * data_height)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error config! data bank is not big enough!")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (is_running & ((data_bank * 512) < (data_entries * data_height)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! fifo is not empty when done!")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, (is_rsp_done & dma_rsp_fifo_req)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Channel counter is not empty when done!")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, (is_rsp_done & ((|ch0_cnt) | (|ch1_cnt) | (|ch2_cnt) | (|ch3_cnt)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Req is not done when rsp is done!")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, (is_rsp_done & (req_height_cnt_d1 != data_height) & ~dbg_is_last_reuse)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Req is valid when rsp is done!")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, (is_rsp_done & req_pre_valid)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! entry_onfly is non zero when idle")      zzz_assert_never_9x (nvdla_core_clk, `ASSERT_RESET, (fetch_done & |(dc_entry_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error config! reg2dp_grains is overflow!")      zzz_assert_never_24x (nvdla_core_clk, `ASSERT_RESET, (layer_st & mon_fetch_grain_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error config! data_entries_w is overflow!")      zzz_assert_never_25x (nvdla_core_clk, `ASSERT_RESET, (layer_st & mon_data_entries_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
//  nv_assert_one_hot #(0,3,0,"Error! conflict data type mode")      zzz_assert_one_hot_26x (nvdla_core_clk, `ASSERT_RESET, ({is_data_normal, is_data_expand, is_data_shrink})); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_height_cnt_inc is overflow!")      zzz_assert_never_30x (nvdla_core_clk, `ASSERT_RESET, (mon_req_height_cnt_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_slice_left is overflow!")      zzz_assert_never_31x (nvdla_core_clk, `ASSERT_RESET, ((|mon_req_slice_left))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_cur_atomic is overflow!")      zzz_assert_never_36x (nvdla_core_clk, `ASSERT_RESET, (pre_reg_en_d1 & (|mon_req_cur_atomic))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! entry_per_batch is overflow!")      zzz_assert_never_37x (nvdla_core_clk, `ASSERT_RESET, (pre_reg_en_d1 & (|mon_entry_per_batch))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_cur_atomic is out of range when HoG!")      zzz_assert_never_38x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~is_feature & (|req_cur_atomic[12 -1: 12 -2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! entry_required is overflow!")      zzz_assert_never_49x (nvdla_core_clk, `ASSERT_RESET, ((|mon_entry_required))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_ch_left_w is overflow")      zzz_assert_never_55x (nvdla_core_clk, `ASSERT_RESET, (mon_req_ch_left_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_cur_ch is out of range")      zzz_assert_never_56x (nvdla_core_clk, `ASSERT_RESET, (req_cur_ch > 3'h4)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_ch_cnt is large than data_surface")      zzz_assert_never_57x (nvdla_core_clk, `ASSERT_RESET, (is_running & (req_ch_cnt > data_surface))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_atm_left is overflow!")      zzz_assert_never_63x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (|mon_req_atm_left))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_atm_size_addr_limit is overflow!")      zzz_assert_never_64x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (|mon_req_atm_size_addr_limit))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_atm_size_out is overflow!")      zzz_assert_never_65x (nvdla_core_clk, `ASSERT_RESET, (req_reg_en & (|mon_req_atm_size_out))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_addr_grain_base_inc is overflow!")      zzz_assert_never_70x (nvdla_core_clk, `ASSERT_RESET, (req_grain_reg_en & mon_req_addr_grain_base_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_addr_batch_base_inc is overflow!")      zzz_assert_never_71x (nvdla_core_clk, `ASSERT_RESET, (req_batch_reg_en & mon_req_addr_batch_base_inc & (|reg2dp_batches))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_addr_ch_base_inc is overflow!")      zzz_assert_never_72x (nvdla_core_clk, `ASSERT_RESET, (req_ch_reg_en & mon_req_addr_ch_base_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_addr_base_inc is overflow!")      zzz_assert_never_73x (nvdla_core_clk, `ASSERT_RESET, (req_atm_reg_en & mon_req_addr_base_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! req_addr is overflow!")      zzz_assert_never_74x (nvdla_core_clk, `ASSERT_RESET, (req_reg_en & mon_req_addr)); // spyglass disable W504 SelfDeterminedExpr-ML 
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  nv_assert_never #(0,0,"DMAIF: mcif and cvif should never return data both")      zzz_assert_never_79x (nvdla_core_clk, `ASSERT_RESET, mc_dma_rd_rsp_vld & cv_dma_rd_rsp_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
  #endif
  nv_assert_never #(0,0,"Error! Receive input data when not busy")      zzz_assert_never_80x (nvdla_core_clk, `ASSERT_RESET, (dma_rd_rsp_vld & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"response fifo pop error")      zzz_assert_never_82x (nvdla_core_clk, `ASSERT_RESET, (dma_rsp_fifo_ready & ~dma_rsp_fifo_req)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"response size mismatch")      zzz_assert_never_83x (nvdla_core_clk, `ASSERT_RESET, (dma_rsp_size_cnt_inc > dma_rsp_size)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! dma_rsp_size_cnt_inc is overflow")      zzz_assert_never_84x (nvdla_core_clk, `ASSERT_RESET, (mon_dma_rsp_size_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! dma_rsp_size_cnt_inc is out of range")      zzz_assert_never_85x (nvdla_core_clk, `ASSERT_RESET, (dma_rsp_size_cnt_inc > 8'h8)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_zero_one_hot #(0,4,0,"Error! ch_reg_en is not one hot")      zzz_assert_zero_one_hot_94x (nvdla_core_clk, `ASSERT_RESET, {ch0_wr_addr_cnt_reg_en, ch1_wr_addr_cnt_reg_en, ch2_wr_addr_cnt_reg_en, ch3_wr_addr_cnt_reg_en}); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Channel 0 is not zero when idle!")      zzz_assert_never_99x (nvdla_core_clk, `ASSERT_RESET, ((|ch0_cnt) & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Channel 1 is not zero when idle!")      zzz_assert_never_100x (nvdla_core_clk, `ASSERT_RESET, ((|ch1_cnt) & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Channel 2 is not zero when idle!")      zzz_assert_never_101x (nvdla_core_clk, `ASSERT_RESET, ((|ch2_cnt) & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Channel 3 is not zero when idle!")      zzz_assert_never_102x (nvdla_core_clk, `ASSERT_RESET, ((|ch3_cnt) & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! rsp_all_h_cnt_inc is overflow")      zzz_assert_never_105x (nvdla_core_clk, `ASSERT_RESET, (mon_rsp_all_h_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! rsp_all_h_left_w is overflow")      zzz_assert_never_106x (nvdla_core_clk, `ASSERT_RESET, (mon_rsp_all_h_left_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! rsp_ch_cnt_inc is overflow")      zzz_assert_never_110x (nvdla_core_clk, `ASSERT_RESET, (mon_rsp_ch_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! rsp_ch_left_w is overflow")      zzz_assert_never_111x (nvdla_core_clk, `ASSERT_RESET, (mon_rsp_ch_left_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! rsp_cur_ch is out of range")      zzz_assert_never_112x (nvdla_core_clk, `ASSERT_RESET, (rsp_cur_ch > 3'h4)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Blocking data response when not enabled")      zzz_assert_never_122x (nvdla_core_clk, `ASSERT_RESET, (is_blocking & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! idx_batch_offset_w is overflow!")      zzz_assert_never_135x (nvdla_core_clk, `ASSERT_RESET, (rsp_batch_reg_en & mon_idx_batch_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! idx_ch_offset_w is overflow!")      zzz_assert_never_136x (nvdla_core_clk, `ASSERT_RESET, (rsp_ch_reg_en & mon_idx_ch_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! idx_h_offset_w is overflow!")      zzz_assert_never_137x (nvdla_core_clk, `ASSERT_RESET, (rsp_h_reg_en & mon_idx_h_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! cbuf_idx_inc is overflow!")      zzz_assert_never_138x (nvdla_core_clk, `ASSERT_RESET, (rsp_w_reg_en & mon_cbuf_idx_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! cbuf_idx_w is overflow!")      zzz_assert_never_139x (nvdla_core_clk, `ASSERT_RESET, (rsp_w_reg_en & (|mon_cbuf_idx_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_zero_one_hot #(0,3,0,"Error! conflict div mode")      zzz_assert_zero_one_hot_140x (nvdla_core_clk, `ASSERT_RESET, ({/*is_w_cnt_div8,*/ is_w_cnt_div4, is_w_cnt_div2})); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! dc_entry_onfly_w is overflow")      zzz_assert_never_151x (nvdla_core_clk, `ASSERT_RESET, (mon_dc_entry_onfly_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! dc_entry_onfly_w is out of range")      zzz_assert_never_152x (nvdla_core_clk, `ASSERT_RESET, (dc_entry_onfly_w > 16384)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! dc_entry_onfly_w is non zero when idle")      zzz_assert_never_153x (nvdla_core_clk, `ASSERT_RESET, (~is_running & |(dc_entry_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Update to status when idle!")      zzz_assert_never_162x (nvdla_core_clk, `ASSERT_RESET, (dc2status_dat_updt & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"never: counter overflow beyond <ovr_cnt>")      zzz_assert_never_163x (nvdla_core_clk, `ASSERT_RESET, (ltc_1_cnt_nxt > 511 && dc_rd_latency_cen)); // spyglass disable W504 SelfDeterminedExpr-ML 

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

endmodule // NV_NVDLA_CDMA_dc



