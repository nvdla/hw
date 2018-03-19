// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_wt.v

#include "NV_NVDLA_CDMA_define.h"

module NV_NVDLA_CDMA_wt (
   nvdla_core_clk            //|< i
  ,nvdla_core_ng_clk         //|< i
  ,nvdla_core_rstn           //|< i
  ,cdma_wt2mcif_rd_req_ready //|< i
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cdma_wt2cvif_rd_req_ready //|< i
  ,cvif2cdma_wt_rd_rsp_pd    //|< i
  ,cvif2cdma_wt_rd_rsp_valid //|< i
  ,cdma_wt2cvif_rd_req_pd    //|> o
  ,cdma_wt2cvif_rd_req_valid //|> o
  ,cvif2cdma_wt_rd_rsp_ready //|> o
  #endif
  ,mcif2cdma_wt_rd_rsp_pd    //|< i
  ,mcif2cdma_wt_rd_rsp_valid //|< i
  ,pwrbus_ram_pd             //|< i
  ,reg2dp_arb_weight         //|< i
  ,reg2dp_arb_wmb            //|< i
  ,reg2dp_byte_per_kernel    //|< i
  ,reg2dp_data_bank          //|< i
  ,reg2dp_dma_en             //|< i
  ,reg2dp_nan_to_zero        //|< i
  ,reg2dp_op_en              //|< i
  ,reg2dp_proc_precision     //|< i
  ,reg2dp_skip_weight_rls    //|< i
  ,reg2dp_weight_addr_high   //|< i
  ,reg2dp_weight_addr_low    //|< i
  ,reg2dp_weight_bank        //|< i
  ,reg2dp_weight_bytes       //|< i
  ,reg2dp_weight_format      //|< i
  ,reg2dp_weight_kernel      //|< i
  ,reg2dp_weight_ram_type    //|< i
  ,reg2dp_weight_reuse       //|< i
  ,reg2dp_wgs_addr_high      //|< i
  ,reg2dp_wgs_addr_low       //|< i
  ,reg2dp_wmb_addr_high      //|< i
  ,reg2dp_wmb_addr_low       //|< i
  ,reg2dp_wmb_bytes          //|< i
  ,sc2cdma_wmb_entries       //|< i
  ,sc2cdma_wt_entries        //|< i
  ,sc2cdma_wt_kernels        //|< i *
  ,sc2cdma_wt_pending_req    //|< i
  ,sc2cdma_wt_updt           //|< i
  ,status2dma_fsm_switch     //|< i
  ,cdma2buf_wt_wr_en         //|> o
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     print qq(
//:     ,cdma2buf_wt_wr_sel
//:     ,cdma2buf_wt_wr_addr
//:     ,cdma2buf_wt_wr_data
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:     ,cdma2buf_wt_wr_mask
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:             ,cdma2buf_wt_wr_addr${i}
//:             ,cdma2buf_wt_wr_data${i}
//:         );
//:     }
//: } else {
//:     print qq(
//:     ,cdma2buf_wt_wr_addr
//:     ,cdma2buf_wt_wr_data
//:     );
//: }
  //,cdma2buf_wt_wr_addr       //|> o
  //,cdma2buf_wt_wr_data       //|> o
  //,cdma2buf_wt_wr_hsel       //|> o
  ,cdma2sc_wmb_entries       //|> o
  ,cdma2sc_wt_entries        //|> o
  ,cdma2sc_wt_kernels        //|> o
  ,cdma2sc_wt_pending_ack    //|> o
  ,cdma2sc_wt_updt           //|> o
  ,cdma_wt2mcif_rd_req_pd    //|> o
  ,cdma_wt2mcif_rd_req_valid //|> o
  ,dp2reg_inf_weight_num     //|> o
  ,dp2reg_nan_weight_num     //|> o
  ,dp2reg_wt_flush_done      //|> o
  ,dp2reg_wt_rd_latency      //|> o
  ,dp2reg_wt_rd_stall        //|> o
  ,mcif2cdma_wt_rd_rsp_ready //|> o
  ,wt2status_state           //|> o
  );

/////////////////////////////////////////////////////
input  nvdla_core_clk;
input  nvdla_core_rstn;

input [31:0] pwrbus_ram_pd;

output        cdma_wt2mcif_rd_req_valid; 
input         cdma_wt2mcif_rd_req_ready; 
output [NVDLA_CDMA_MEM_RD_REQ-1:0] cdma_wt2mcif_rd_req_pd;
input          mcif2cdma_wt_rd_rsp_valid;
output         mcif2cdma_wt_rd_rsp_ready;
input  [NVDLA_CDMA_MEM_RD_RSP-1:0] mcif2cdma_wt_rd_rsp_pd;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output        cdma_wt2cvif_rd_req_valid; 
input         cdma_wt2cvif_rd_req_ready; 
output [NVDLA_CDMA_MEM_RD_REQ-1:0] cdma_wt2cvif_rd_req_pd;
input          cvif2cdma_wt_rd_rsp_valid;
output         cvif2cdma_wt_rd_rsp_ready;
input  [NVDLA_CDMA_MEM_RD_RSP-1:0] cvif2cdma_wt_rd_rsp_pd;
#endif

output         cdma2buf_wt_wr_en;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int($atmc/$dmaif);
//:     print qq(
//:     output [${k}-1:0]     cdma2buf_wt_wr_sel ; 
//:     output [16:0]         cdma2buf_wt_wr_addr;
//:     output [${dmaif}-1:0] cdma2buf_wt_wr_data;
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:     output   [${k}-1:0]      cdma2buf_wt_wr_mask;
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:             output [16:0]         cdma2buf_wt_wr_addr${i};
//:             output [${dmaif}-1:0] cdma2buf_wt_wr_data${i};
//:         );
//:     }
//: } else {
//:     print qq(
//:     output [16:0]         cdma2buf_wt_wr_addr;
//:     output [${dmaif}-1:0] cdma2buf_wt_wr_data;
//:     );
//: }

input  status2dma_fsm_switch;

output [1:0] wt2status_state;

output        cdma2sc_wt_updt; 
output [13:0] cdma2sc_wt_kernels;
output [14:0] cdma2sc_wt_entries;
output [11:0] cdma2sc_wmb_entries;
input        sc2cdma_wt_updt;
input [13:0] sc2cdma_wt_kernels;
input [14:0] sc2cdma_wt_entries;
input  [8:0] sc2cdma_wmb_entries;

input  sc2cdma_wt_pending_req;
output  cdma2sc_wt_pending_ack;

input nvdla_core_ng_clk;

input [3:0]    reg2dp_arb_weight;
input [3:0]    reg2dp_arb_wmb;
input [0:0]    reg2dp_op_en;
input [1:0]    reg2dp_proc_precision;
input [0:0]    reg2dp_weight_reuse;
input [0:0]    reg2dp_skip_weight_rls;
input [0:0]    reg2dp_weight_format;
input [17:0]   reg2dp_byte_per_kernel;
input [12:0]   reg2dp_weight_kernel;
input [0:0]    reg2dp_weight_ram_type;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log(${atmm})/log(2));
//: print qq(
//:     input [31-${atmbw}:0]   reg2dp_weight_addr_low;
//:     input [31-${atmbw}:0]   reg2dp_wgs_addr_low;
//:     input [31-${atmbw}:0]   reg2dp_wmb_addr_low;
//: );
input [31:0]   reg2dp_weight_addr_high;
input [31:0]   reg2dp_weight_bytes;
input [31:0]   reg2dp_wgs_addr_high;
input [31:0]   reg2dp_wmb_addr_high;
input [27:0]   reg2dp_wmb_bytes;
input [4:0]    reg2dp_data_bank; 
input [4:0]    reg2dp_weight_bank;
input [0:0]    reg2dp_nan_to_zero;
input [0:0]    reg2dp_dma_en;

output [31:0]  dp2reg_nan_weight_num;
output [31:0]  dp2reg_inf_weight_num;
output         dp2reg_wt_flush_done;
output [31:0]  dp2reg_wt_rd_stall;
output [31:0]  dp2reg_wt_rd_latency;
/////////////////////////////////////////////////////

#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
reg            arb_sp_out_back_vld;
reg            arb_sp_out_vld;
reg      [4:0] arb_weight_wmb;
reg      [4:0] arb_weight_wt;
reg            arb_wrr_out_back_vld;
reg            arb_wrr_out_vld;
reg     [11:0] incr_wmb_entries;
reg     [21:0] pre_wmb_fetched_cnt;
reg     [31:0] pre_wmb_required_bits;
reg      [8:0] sc_wmb_entries;
reg      [5:0] wgs_data_onfly;
reg      [11:0] wgs_push_cnt;
reg            wgs_push_req;
reg      [11:0] wgs_req_dword_cnt_d1;
reg      [3:0] wgs_req_dword_d1;
reg            wgs_req_vld_d1;
reg     [12:0] wmb_cbuf_wr_idx;
reg     [14:0] wmb_data_avl;
reg     [10:0] wmb_data_onfly;
reg     [13:0] wmb_data_stored;
reg     [21:0] wmb_fetched_cnt;
reg            wmb_local_data_vld;
reg     [22:0] wmb_req_burst_cnt_d1;
reg            wmb_req_done_d2;
reg            wmb_req_done_d3;
reg            wmb_req_last_d2;
reg      [3:0] wmb_req_size_d1;
reg      [3:0] wmb_req_size_d2;
reg      [3:0] wmb_req_size_d3;
reg      [2:0] wmb_req_size_out_d2;
reg      [2:0] wmb_req_size_out_d3;
reg            wmb_req_stage_vld_d1;
reg            wmb_req_stage_vld_d2;
reg            wmb_req_vld_d3;
reg     [31:0] wmb_required_bits;
#endif
reg     [18:0] byte_per_kernel;
reg     [16:0] cdma2buf_wt_wr_addr;
reg            cdma2buf_wt_wr_en;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     my $s = int($atmc/$dmaif);
//:     print qq(
//:     reg    [${s}-1:0]     cdma2buf_wt_wr_sel ; 
//:     wire   [${k}-1:0]     cdma2buf_wt_wr_sel_w;
//:     );
//: }
//reg            cdma2buf_wt_wr_sel;
reg      [1:0] cur_state;
reg      [1:0] dbg_dma_req_src_b0;
reg      [1:0] dbg_dma_req_src_b1;
reg            dbg_src_rd_ptr;
reg            dbg_src_wr_ptr;
reg     [31:0] dbg_wmb_kernel_bits;
reg     [31:0] dbg_wt_kernel_bytes;
reg      [3:0] dma_req_size;
reg      [2:0] dma_req_size_out;

//: my $mask = NVDLA_CDMA_MEM_MASK_BIT;
//: my $atmm = (NVDLA_MEMORY_ATOMIC_SIZE * NVDLA_BPE);
//:     print qq(
//:         wire   [${atmm}-1:0] wt_local_data_w;
//:         reg    [${atmm}-1:0] wt_local_data;
//:         wire   [${atmm}-1:0] wmb_local_data_w;
//:         reg    [${atmm}-1:0] wmb_local_data;
//:         reg    [${atmm}-1:0] wgs_local_data;
//:     );
//: foreach my $i(0..$mask-1) {
//:     print qq(
//:         reg    [${atmm}-1:0] dma_rsp_data_p${i};
//:     );
//: }
wire   [NVDLA_CDMA_DMAIF_BW-1:0] wt_cbuf_wr_data_ori_w;
wire   [NVDLA_CDMA_DMAIF_BW-1:0] wt_cbuf_wr_data_w;
reg    [NVDLA_CDMA_DMAIF_BW-1:0] cdma2buf_wt_wr_data;
wire   [NVDLA_CDMA_DMAIF_BW-1:0] wmb_cbuf_wr_data_w;
wire   [NVDLA_CDMA_DMAIF_BW-1:0] cdma2buf_wt_wr_data_w;
reg      [3:0] dma_rsp_size;
reg      [3:0] dma_rsp_size_cnt;
reg     [31:0] dp2reg_wt_rd_latency;
reg     [31:0] dp2reg_wt_rd_stall;
reg      [11:0] group;
reg     [14:0] incr_wt_entries;
reg      [5:0] incr_wt_kernels;
reg            incr_wt_updt;
reg      [4:0] last_data_bank;
reg            last_skip_weight_rls;
reg      [4:0] last_weight_bank;
reg            layer_st_d1;
reg            ltc_1_adv;
reg     [10:0] ltc_1_cnt_dec;
reg     [10:0] ltc_1_cnt_ext;
reg     [10:0] ltc_1_cnt_inc;
reg     [10:0] ltc_1_cnt_mod;
reg     [10:0] ltc_1_cnt_new;
reg     [10:0] ltc_1_cnt_nxt;
reg      [8:0] ltc_1_cnt_cur;
reg            ltc_1_dec;
reg            ltc_1_inc;
reg            ltc_2_adv;
reg     [33:0] ltc_2_cnt_dec;
reg     [33:0] ltc_2_cnt_ext;
reg     [33:0] ltc_2_cnt_inc;
reg     [33:0] ltc_2_cnt_mod;
reg     [33:0] ltc_2_cnt_new;
reg     [33:0] ltc_2_cnt_nxt;
reg            ltc_2_dec;
reg            ltc_2_inc;
reg     [31:0] ltc_2_cnt_cur;
reg            nan_pass;
reg      [1:0] nxt_state;
reg      [8:0] outs_dp2reg_wt_rd_latency;
reg            pending_ack;
reg            pending_req;
reg            pending_req_d1;
reg     [25:0] pre_wt_fetched_cnt;
reg     [31:0] pre_wt_required_bytes;
reg            required_valid;
reg     [14:0] sc_wt_entries;
reg            sc_wt_updt;
reg            status_done;
reg      [3:0] status_done_cnt;
reg      [11:0] status_group_cnt;
reg            stl_adv;
reg     [31:0] stl_cnt_cur;
reg     [33:0] stl_cnt_dec;
reg     [33:0] stl_cnt_ext;
reg     [33:0] stl_cnt_inc;
reg     [33:0] stl_cnt_mod;
reg     [33:0] stl_cnt_new;
reg     [33:0] stl_cnt_nxt;
reg      [5:0] weight_bank;
reg      [5:0] weight_bank_end;
reg      [1:0] wt2status_state;
////: my $bank_entry = NVDLA_CBUF_BANK_NUMBER * NVDLA_CBUF_BANK_DEPTH;
////: my $bank_entry_bw = int( log( $bank_entry)/log(2) );
////: my $dmaif=NVDLA_CDMA_DMAIF_BW;
////: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
////: my $k;
////: if($dmaif < $atmc) {
////:     $k = int(log(int($atmc/$dmaif))/log(2));
////: } else {
////:     $k = 0;
////: }
////: print qq(
////: reg     [${bank_entry_bw}+$k-1:0] wt_cbuf_flush_idx;//max value = half bank entry * 2^$k
////: );

reg     [17:0] wt_cbuf_flush_idx;
reg     [16:0] wt_cbuf_wr_idx;
reg     [16:0] wt_data_avl;
reg     [13:0] wt_data_onfly;
reg     [16:0] wt_data_stored;
reg     [25:0] wt_fetched_cnt;
reg     [31:0] wt_fp16_inf_flag;
reg            wt_fp16_inf_vld;
reg     [31:0] wt_fp16_nan_flag;
reg            wt_fp16_nan_vld;
reg            wt_local_data_vld;
reg            wt_rd_latency_cen;
reg            wt_rd_latency_clr;
reg            wt_rd_latency_dec;
reg            wt_rd_latency_inc;
reg            wt_rd_stall_cen;
reg            wt_rd_stall_clr;
reg            wt_rd_stall_inc;
reg     [26:0] wt_req_burst_cnt_d1;
reg            wt_req_done_d2;
reg            wt_req_done_d3;
reg            wt_req_last_d2;
reg      [3:0] wt_req_size_d1;
reg      [3:0] wt_req_size_d2;
reg      [3:0] wt_req_size_d3;
reg      [2:0] wt_req_size_out_d2;
reg      [2:0] wt_req_size_out_d3;
reg            wt_req_stage_vld_d1;
reg            wt_req_stage_vld_d2;
reg            wt_req_vld_d3;
reg     [31:0] wt_required_bytes;
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
wire           arb_sp_block;
wire     [1:0] arb_sp_in_rdy;
wire     [1:0] arb_sp_in_vld;
wire           arb_sp_out_back_reg_en;
wire           arb_sp_out_back_vld_w;
wire           arb_sp_out_reg_en;
wire           arb_sp_out_vld_w;
wire           arb_wrr_block;
wire     [1:0] arb_wrr_in_rdy;
wire     [1:0] arb_wrr_in_vld;
wire           arb_wrr_out_back_reg_en;
wire           arb_wrr_out_back_vld_w;
wire           arb_wrr_out_rdy;
wire           arb_wrr_out_reg_en;
wire           arb_wrr_out_vld_w;
wire     [4:0] arb_wrr_weight_0;
wire     [4:0] arb_wrr_weight_1;
wire           dbg_full_wmb;
wire    [31:0] dbg_wmb_kernel_bits_sub;
wire    [31:0] dbg_wmb_kernel_bits_w;
wire     [9:0] incr_wmb_cnt;
wire     [11:0] incr_wmb_entries_d0;
wire     [11:0] incr_wmb_entries_w;
wire           mon_incr_wmb_cnt;
wire           mon_wgs_data_onfly_w;
wire           mon_wgs_push_cnt_inc;
wire   [223:0] mon_wgs_push_data;
wire           mon_wgs_req_addr_inc;
wire           mon_wgs_req_dword_cnt_dec;
wire           mon_wgs_req_sum;
wire           mon_wmb_cbuf_wr_idx_inc;
wire           mon_wmb_data_avl_w;
wire           mon_wmb_data_onfly_w;
wire           mon_wmb_data_stored_w;
wire           mon_wmb_fetched_cnt_inc;
wire           mon_wmb_req_burst_cnt_dec;
wire           mon_wmb_req_sum;
wire           mon_wmb_required_bits_w;
wire    [21:0] pre_wmb_fetched_cnt_w;
wire    [31:0] pre_wmb_required_bits_w;
wire           status_update_wmb;
wire     [4:0] wgs_data_onfly_add;
wire           wgs_data_onfly_reg_en;
wire           wgs_data_onfly_sub;
wire     [5:0] wgs_data_onfly_w;
wire    [31:0] wgs_pop_data;
wire           wgs_pop_ready;
wire           wgs_pop_req;
wire     [11:0] wgs_push_cnt_inc;
wire     [11:0] wgs_push_cnt_w;
wire    [31:0] wgs_push_data;
wire           wgs_push_last;
wire           wgs_push_ready;
wire           wgs_push_req_w;
wire           wgs_req_done;
wire     [11:0] wgs_req_dword_cnt_dec;
wire     [11:0] wgs_req_dword_cnt_w;
wire     [3:0] wgs_req_dword_w;
wire           wgs_req_overflow;
wire           wgs_req_rdy;
wire           wgs_req_reg_en;
wire     [3:0] wgs_req_size_d1;
wire     [2:0] wgs_req_size_out_d1;
wire     [1:0] wgs_req_src_d1;
wire     [5:0] wgs_req_sum;
wire           wgs_req_vld_w;
wire           wgs_rsp_valid;
wire     [8:0] wmb_cbuf_wr_idx_inc;
wire    [12:0] wmb_cbuf_wr_idx_w;
wire           wmb_cbuf_wr_vld_w;
wire    [10:0] wmb_data_avl_sub;
wire    [14:0] wmb_data_avl_w;
wire     [3:0] wmb_data_onfly_add;
wire           wmb_data_onfly_reg_en;
wire     [2:0] wmb_data_onfly_sub;
wire    [10:0] wmb_data_onfly_w;
wire    [13:0] wmb_data_stored_sub;
wire    [13:0] wmb_data_stored_w;
wire    [21:0] wmb_fetched_cnt_inc;
wire    [21:0] wmb_fetched_cnt_w;
wire     [1:0] wmb_local_data_cnt;
wire           wmb_local_data_reg_en;
wire           wmb_local_data_vld_w;
wire           wmb_req_done_w;
wire           wmb_req_last_w;
wire           wmb_req_overflow;
wire           wmb_req_overflow_d3;
wire           wmb_req_rdy;
wire           wmb_req_reg_en;
wire           wmb_req_reg_en_d0;
wire           wmb_req_reg_en_d1;
wire           wmb_req_reg_en_d2;
wire     [3:0] wmb_req_size_addr_limit;
wire     [2:0] wmb_req_size_out_w;
wire     [3:0] wmb_req_size_w;
wire     [1:0] wmb_req_src_d3;
wire    [14:0] wmb_req_sum;
wire           wmb_req_vld_w;
wire    [31:0] wmb_required_bits_w;
wire           wmb_required_en;
wire           wmb_rsp_valid;
wire           wmb_satisfied;
#else
wire           arb_sp_out_vld;
#endif
wire           arb_sp_out_rdy;
wire    [16:0] cdma2buf_wt_wr_addr_w;
wire           cdma2buf_wt_wr_en_w;
//wire           cdma2buf_wt_wr_sel_w;
wire           clear_all;
wire     [5:0] data_bank_w;
wire     [1:0] dbg_dma_req_src;
wire           dbg_full_weight;
wire           dbg_src_rd_ptr_en;
wire           dbg_src_rd_ptr_w;
wire           dbg_src_wr_ptr_en;
wire           dbg_src_wr_ptr_w;
wire    [31:0] dbg_wt_kernel_bytes_w;
wire    [63:0] dma_rd_req_addr;
wire    [NVDLA_MEM_ADDRESS_WIDTH+14:0] dma_rd_req_pd;
wire           dma_rd_req_rdy;
wire    [14:0] dma_rd_req_size;
wire           dma_rd_req_type;
wire           dma_rd_req_vld;
wire   [NVDLA_MEMIF_WIDTH-1:0] dma_rd_rsp_data;
wire   [NVDLA_CDMA_MEM_RD_RSP-NVDLA_MEMIF_WIDTH-1:0] dma_rd_rsp_mask;
wire   [NVDLA_CDMA_MEM_RD_RSP-1:0] dma_rd_rsp_pd;
wire           dma_rd_rsp_rdy;
wire           dma_rd_rsp_vld;
wire     [5:0] dma_req_fifo_data;
wire           dma_req_fifo_ready;
wire           dma_req_fifo_req;
wire     [1:0] dma_req_src;
wire     [5:0] dma_rsp_fifo_data;
wire           dma_rsp_fifo_ready;
wire           dma_rsp_fifo_req;
wire     [3:0] dma_rsp_size_cnt_inc;
wire     [3:0] dma_rsp_size_cnt_w;
wire     [1:0] dma_rsp_src;
wire    [31:0] dp2reg_inf_weight_num_inc;
wire    [31:0] dp2reg_inf_weight_num_w;
wire    [31:0] dp2reg_nan_weight_num_inc;
wire    [31:0] dp2reg_nan_weight_num_w;
wire           dp2reg_wt_rd_stall_dec;
wire           fetch_done;
wire     [10:0] group_op;
wire     [11:0] group_w;
wire    [12:0] incr_wt_cnt;
wire    [14:0] incr_wt_entries_d0;
wire    [14:0] incr_wt_entries_w;
wire     [5:0] incr_wt_kernels_d0;
wire     [5:0] incr_wt_kernels_w;
wire           incr_wt_updt_d0;
wire           inf_carry;
wire           inf_reg_en;
wire           is_compressed;
wire           is_fp16;
wire           is_int8;
wire           is_nxt_running;
wire           is_pending;
wire           is_running;
wire           layer_end;
wire           layer_st;
wire           mon_dma_rsp_size_cnt_inc;
wire           mon_incr_wt_cnt;
wire           mon_wt_cbuf_flush_idx_w;
wire           mon_wt_data_avl_w;
wire           mon_wt_data_onfly_w;
wire           mon_wt_data_stored_w;
wire           mon_wt_fetched_cnt_inc;
wire           mon_wt_req_burst_cnt_dec;
wire           mon_wt_req_sum;
wire           mon_wt_required_bytes_w;
wire           nan_carry;
wire           nan_pass_w;
wire           nan_reg_en;
wire           need_pending;
wire    [23:0] normal_bpg;
wire           pending_req_end;
wire    [25:0] pre_wt_fetched_cnt_w;
wire    [31:0] pre_wt_required_bytes_w;
wire           rd_req_rdyi;
wire           required_valid_w;
wire     [4:0] status_done_cnt_w;
wire           status_done_w;
wire     [11:0] status_group_cnt_inc;
wire     [11:0] status_group_cnt_w;
wire           status_last_group;
wire           status_update;
wire     [5:0] weight_bank_end_w;
wire     [5:0] weight_bank_w;
wire     [1:0] wt2status_state_w;
wire    [17:0] wt_cbuf_flush_idx_w;
wire           wt_cbuf_flush_vld_w;
wire    [17:0] wt_cbuf_wr_idx_inc;
wire           wt_cbuf_wr_idx_set;
wire    [16:0] wt_cbuf_wr_idx_w;
wire           wt_cbuf_wr_idx_wrap;
wire           wt_cbuf_wr_vld_w;
wire    [16:0] wt_data_avl_sub;
wire    [16:0] wt_data_avl_w;
wire     [3:0] wt_data_onfly_add;
wire           wt_data_onfly_reg_en;
wire     [3:0] wt_data_onfly_sub;
wire    [13:0] wt_data_onfly_w;
wire    [16:0] wt_data_stored_sub;
wire    [16:0] wt_data_stored_w;
wire    [25:0] wt_fetched_cnt_inc;
wire    [25:0] wt_fetched_cnt_w;
wire    [31:0] wt_fp16_exp_flag_w;
wire    [31:0] wt_fp16_inf_flag_w;
wire     [5:0] wt_fp16_inf_sum;
wire           wt_fp16_inf_vld_w;
wire    [31:0] wt_fp16_manti_flag_w;
wire    [31:0] wt_fp16_nan_flag_w;
wire     [5:0] wt_fp16_nan_sum;
wire           wt_fp16_nan_vld_w;
wire     [2:0] wt_local_data_cnt;
wire           wt_local_data_reg_en;
wire           wt_local_data_vld_w;
//wire   [511:0] wt_nan_mask;


//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log(${atmm})/log(2));
//: print qq(
//:     wire    [64-${atmbw}-1:0] wt_req_addr_w;
//:     reg     [64-${atmbw}-1:0] wt_req_addr_d2;
//:     reg     [64-${atmbw}-1:0] wt_req_addr_d3;
//:     reg     [64-${atmbw}-1:0] dma_req_addr;
//:     wire    [64-${atmbw}-1-3:0] wt_req_addr_inc;
//:     wire    [64-${atmbw}-1:0] wmb_req_addr_w;
//:     reg     [64-${atmbw}-1:0] wmb_req_addr_d2;
//:     reg     [64-${atmbw}-1:0] wmb_req_addr_d3;
//:     wire    [64-${atmbw}-1-3:0] wmb_req_addr_inc;
//:     wire    [64-${atmbw}-1:0] wgs_req_addr_w;
//:     wire    [64-${atmbw}-1:0] wgs_req_addr_inc;
//:     reg     [64-${atmbw}-1:0] wgs_req_addr_d1;
//:     wire    [64-${atmbw}-1+9:0] arb_wrr_req_package_in_00;
//:     wire    [64-${atmbw}-1+9:0] arb_wrr_req_package_in_01;
//:     wire    [64-${atmbw}-1+9:0] arb_wrr_out_package_w;
//:     reg     [64-${atmbw}-1+9:0] arb_wrr_out_package;
//:     reg     [64-${atmbw}-1+9:0] arb_wrr_out_back_package;
//:     reg     [64-${atmbw}-1+9:0] arb_sp_req_package_in_00;
//:     reg     [64-${atmbw}-1+9:0] arb_sp_req_package_in_01;
//: );
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log(${atmm})/log(2));
//: print qq(
//:     wire    [64-${atmbw}-1+9:0] arb_sp_out_package_w;
//:     reg     [64-${atmbw}-1+9:0] arb_sp_out_package;
//:     reg     [64-${atmbw}-1+9:0] arb_sp_out_back_package;
//: );
#endif

//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $k = int( log(${atmm}) / log(2) );
//: print qq(
//:     wire    [32-${k}-1:0] wt_req_burst_cnt_w;
//:     wire    [32-${k}-1:0] wt_req_burst_cnt_dec;
//:     wire    [28-${k}-1:0] wmb_req_burst_cnt_w;
//:     wire    [28-${k}-1:0] wmb_req_burst_cnt_dec;
//: );
wire           wt_req_done_w;
wire           wt_req_last_w;
wire           wt_req_overflow;
wire           wt_req_overflow_d3;
wire           wt_req_rdy;
wire           wt_req_reg_en;
wire           wt_req_reg_en_d0;
wire           wt_req_reg_en_d1;
wire           wt_req_reg_en_d2;
wire     [3:0] wt_req_size_addr_limit;
wire     [2:0] wt_req_size_out_w;
wire     [3:0] wt_req_size_w;
wire     [1:0] wt_req_src_d3;
wire    [16:0] wt_req_sum;
wire           wt_req_vld_w;
wire    [31:0] wt_required_bytes_w;
wire           wt_required_en;
wire           wt_rsp_valid;
wire           wt_satisfied;
#ifdef NVDLA_WEIGHT_DATA_TYPE_INT8
wire    [31:0] dp2reg_nan_weight_num;
wire    [31:0] dp2reg_inf_weight_num;
#else
reg     [31:0] dp2reg_nan_weight_num;
reg     [31:0] dp2reg_inf_weight_num;
#endif
    
////////////////////////////////////////////////////////////////////////
// CDMA weight fetching logic FSM                                     //
////////////////////////////////////////////////////////////////////////
//## fsm (1) defines

localparam WT_STATE_IDLE = 2'b00;
localparam WT_STATE_PEND = 2'b01;
localparam WT_STATE_BUSY = 2'b10;
localparam WT_STATE_DONE = 2'b11;

always @(*) begin
    nxt_state = cur_state;
    begin
        casez (cur_state)
        WT_STATE_IDLE: begin
            if ((reg2dp_op_en & need_pending)) begin
                nxt_state = WT_STATE_PEND; 
            end
            else if ((reg2dp_op_en & reg2dp_weight_reuse & last_skip_weight_rls)) begin
                nxt_state = WT_STATE_DONE; 
            end
            else if (reg2dp_op_en) begin
                nxt_state = WT_STATE_BUSY; 
            end
        end
        WT_STATE_PEND: begin
            if ((pending_req_end)) begin
                nxt_state = WT_STATE_BUSY; 
            end
        end
        WT_STATE_BUSY: begin
            if (fetch_done) begin
                nxt_state = WT_STATE_DONE; 
            end
        end
        WT_STATE_DONE: begin
            if (status2dma_fsm_switch) begin
                nxt_state = WT_STATE_IDLE; 
            end
        end
        endcase
    end
end
//: &eperl::flop("-nodeclare   -rval \"WT_STATE_IDLE\"   -d \"nxt_state\" -q cur_state");

////////////////////////////////////////////////////////////////////////
//  FSM input signals                                                 //
////////////////////////////////////////////////////////////////////////
assign status_done_cnt_w[4:0] = layer_st ? 5'b0 :
                                (status_done & (status_done_cnt != 4'h8)) ? (status_done_cnt + 4'b1) : status_done_cnt;
assign fetch_done = status_done & (status_done_cnt == 4'h8);
assign need_pending = ((last_data_bank != reg2dp_data_bank) | (last_weight_bank != reg2dp_weight_bank));

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        status_done_cnt <= {4{1'b0}};
    end else begin
        if ((layer_st | is_running) == 1'b1) begin
            status_done_cnt <= status_done_cnt_w[3:0];
        end
    end
end

////////////////////////////////////////////////////////////////////////
//  FSM output signals                                                //
////////////////////////////////////////////////////////////////////////

assign layer_st = reg2dp_op_en && (cur_state == WT_STATE_IDLE);
assign layer_end = status2dma_fsm_switch;
assign is_running = (cur_state == WT_STATE_BUSY);
assign is_pending = (cur_state == WT_STATE_PEND);
assign clear_all = pending_ack & pending_req;
assign is_nxt_running = (nxt_state == WT_STATE_BUSY);
assign wt2status_state_w = (nxt_state == WT_STATE_PEND) ? 1  : 
                           (nxt_state == WT_STATE_BUSY) ? 2  : 
                           (nxt_state == WT_STATE_DONE) ? 3  :
                           0 ;
assign pending_req_end = pending_req_d1 & ~pending_req;

//: &eperl::flop("-nodeclare   -rval \"0\"   -d \"wt2status_state_w\" -q wt2status_state");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"sc2cdma_wt_pending_req\" -q pending_req");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"pending_req\" -q pending_req_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"is_pending\" -q pending_ack");

assign cdma2sc_wt_pending_ack = pending_ack;

////////////////////////////////////////////////////////////////////////
//  registers to keep last layer status                               //
////////////////////////////////////////////////////////////////////////
//: &eperl::flop("-nodeclare   -rval \"{5{1'b1}}\"  -en \"layer_end\" -d \"reg2dp_data_bank\" -q last_data_bank");
//: &eperl::flop("-nodeclare   -rval \"{5{1'b1}}\"  -en \"layer_end\" -d \"reg2dp_weight_bank\" -q last_weight_bank");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_end\" -d \"reg2dp_skip_weight_rls\" -q last_skip_weight_rls");

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"layer_st\" -q layer_st_d1");

////////////////////////////////////////////////////////////////////////
//  registers to calculate local values                               //
////////////////////////////////////////////////////////////////////////

//: &eperl::flop("-nodeclare  -norst -en \"layer_st\" -d \"reg2dp_byte_per_kernel + 1'b1\" -q byte_per_kernel");
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
//: &eperl::flop("-nodeclare   -rval \"{5{1'b0}}\"  -en \"layer_st\" -d \"reg2dp_arb_weight + 1'b1\" -q arb_weight_wt");
//: &eperl::flop("-nodeclare   -rval \"{5{1'b0}}\"  -en \"layer_st\" -d \"reg2dp_arb_wmb + 1'b1\" -q arb_weight_wmb");
#endif

#ifdef NVDLA_WEIGHT_DATA_TYPE_INT8
assign is_int8 = 1'b1;
assign is_fp16 = 1'b0;
#else
assign is_int8 = 1'b0;
assign is_fp16 = (reg2dp_proc_precision == 2'h2 );
#endif
//: my $atmk = NVDLA_MAC_ATOMIC_K_SIZE;
//: my $atmkbw = int(log($atmk) / log(2));
//: print qq( assign group_op = {{($atmkbw-2){1'b0}}, reg2dp_weight_kernel[12:${atmkbw}]}; );
assign group_w = group_op + 1'b1;

assign data_bank_w = reg2dp_data_bank + 1'b1;
assign weight_bank_w = reg2dp_weight_bank + 1'b1;
assign weight_bank_end_w = weight_bank_w + data_bank_w;
assign nan_pass_w = ~reg2dp_nan_to_zero | ~is_fp16;
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
assign is_compressed = (reg2dp_weight_format == 1'h1 );
#else
assign is_compressed = 1'b0;
#endif

//: &eperl::flop("-nodeclare   -rval \"{12{1'b1}}\"  -en \"layer_st\" -d \"group_w\" -q group");
//: &eperl::flop("-nodeclare   -rval \"{6{1'b1}}\"  -en \"layer_st\" -d \"weight_bank_w\" -q weight_bank");
//: &eperl::flop("-nodeclare   -rval \"{6{1'b1}}\"  -en \"layer_st\" -d \"weight_bank_end_w\" -q weight_bank_end");
//: &eperl::flop("-nodeclare   -rval \"1'b1\"  -en \"layer_st\" -d \"nan_pass_w\" -q nan_pass");
////////////////////////////////////////////////////////////////////////
//  generate address for weight data                                  //
////////////////////////////////////////////////////////////////////////
localparam SRC_ID_WT  = 2'b00;
localparam SRC_ID_WMB = 2'b01;
localparam SRC_ID_WGS = 2'b10;

/////////////////// stage 1 ///////////////////
assign wt_req_reg_en_d0 = wt_req_reg_en;
assign {mon_wt_req_burst_cnt_dec, wt_req_burst_cnt_dec} = wt_req_burst_cnt_d1 - {{23{1'b0}}, wt_req_size_d1};
//assign wt_req_burst_cnt_w = layer_st ? {reg2dp_weight_bytes, 2'b0} : wt_req_burst_cnt_dec;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $k = int( log(${atmm}) / log(2) );
//: print qq( assign wt_req_burst_cnt_w = layer_st ? reg2dp_weight_bytes[31:${k}] : wt_req_burst_cnt_dec;  );
assign wt_req_size_addr_limit = layer_st ? (4'h8 - reg2dp_weight_addr_low[2:0]) : 4'h8;
assign wt_req_size_w = ( {{23{1'b0}}, wt_req_size_addr_limit} > wt_req_burst_cnt_w) ? wt_req_burst_cnt_w[3:0] : wt_req_size_addr_limit;

//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"wt_req_reg_en_d0\" -d \"wt_req_size_w\" -q wt_req_size_d1");
//: &eperl::flop("-nodeclare   -rval \"{27{1'b0}}\"  -en \"wt_req_reg_en_d0\" -d \"wt_req_burst_cnt_w\" -q wt_req_burst_cnt_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"is_nxt_running\" -q wt_req_stage_vld_d1");


/////////////////// stage 2 ///////////////////
assign wt_req_reg_en_d1 = wt_req_reg_en;
assign wt_req_last_w = wt_req_stage_vld_d1 && (wt_req_burst_cnt_d1 == {{23{1'b0}}, wt_req_size_d1});
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log(${atmm})/log(2));
//: print qq(
//:     assign wt_req_addr_inc = wt_req_addr_d2[64-${atmbw}-1:3] + 1'b1;
//: );
assign wt_req_addr_w = (~wt_req_stage_vld_d2) ? {reg2dp_weight_addr_high,reg2dp_weight_addr_low} : {wt_req_addr_inc, 3'b0};
assign wt_req_size_out_w = wt_req_size_d1[2:0] - 3'b1;
assign wt_req_done_w = layer_st ? 1'b0 :  wt_req_last_d2 ? 1'b1 : wt_req_done_d2;

//: &eperl::flop("-nodeclare   -rval \"0\"          -en \"wt_req_reg_en_d1\" -d \"wt_req_addr_w\" -q wt_req_addr_d2");
//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"wt_req_reg_en_d1\" -d \"wt_req_size_d1\" -q wt_req_size_d2");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"wt_req_reg_en_d1\" -d \"wt_req_size_out_w\" -q wt_req_size_out_d2");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"       -en \"wt_req_reg_en_d1\" -d \"wt_req_last_w\" -q wt_req_last_d2");
//: &eperl::flop("-nodeclare   -rval \"1'b1\"       -en \"wt_req_reg_en_d1\" -d \"wt_req_done_w\" -q wt_req_done_d2");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"wt_req_stage_vld_d1 & is_nxt_running\" -q wt_req_stage_vld_d2");

/////////////////// stage 3 ///////////////////
assign wt_req_reg_en_d2 = wt_req_reg_en;
assign wt_req_vld_w = is_nxt_running & wt_req_stage_vld_d2;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"wt_req_vld_w\" -q wt_req_vld_d3");
//: &eperl::flop("-nodeclare   -rval \"0\"  -en \"wt_req_reg_en_d2\" -d \"wt_req_addr_d2\" -q wt_req_addr_d3");
//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"wt_req_reg_en_d2\" -d \"wt_req_size_d2\" -q wt_req_size_d3");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"wt_req_reg_en_d2\" -d \"wt_req_size_out_d2\" -q wt_req_size_out_d3");
//: &eperl::flop("-nodeclare   -rval \"1'b1\"  -en \"wt_req_reg_en_d2\" -d \"(is_running & wt_req_done_d2)\" -q wt_req_done_d3");
assign wt_req_src_d3 = SRC_ID_WT;

/////////////////// overflow control logic ///////////////////
assign {mon_wt_req_sum, wt_req_sum} = wt_data_onfly + wt_data_stored + wt_data_avl;

//: my $Cbuf_bank_size = NVDLA_CBUF_BANK_WIDTH * NVDLA_CBUF_BANK_DEPTH;
//: my $cdma_addr_align = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $Cbuf_bank_fetch_bits = int( log($Cbuf_bank_size/$cdma_addr_align)/log(2) );
//: print qq(
//:     assign wt_req_overflow = is_running && (wt_req_sum > {weight_bank, ${Cbuf_bank_fetch_bits}'b0});
//: );
assign wt_req_overflow_d3 = wt_req_overflow;

/////////////////// pipeline control logic ///////////////////
assign wt_req_reg_en = layer_st | (is_running & (~wt_req_vld_d3 | wt_req_rdy)); 

#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
////////////////////////////////////////////////////////////////////////
//  generate address for WMB data                                     //
////////////////////////////////////////////////////////////////////////

/////////////////// stage 1 ///////////////////
assign wmb_req_reg_en_d0 = wmb_req_reg_en;
assign {mon_wmb_req_burst_cnt_dec, wmb_req_burst_cnt_dec} = wmb_req_burst_cnt_d1 - {{19{1'b0}}, wmb_req_size_d1};
//assign wmb_req_burst_cnt_w = layer_st ? {reg2dp_wmb_bytes, 2'b0} : wmb_req_burst_cnt_dec;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $k = int(log($atmm)/log(2));
//: print qq( assign wmb_req_burst_cnt_w = layer_st ? reg2dp_wmb_bytes[27:${k}] : wmb_req_burst_cnt_dec;  );
assign wmb_req_size_addr_limit = layer_st ? (4'h8 - reg2dp_wmb_addr_low[2:0]) : 4'h8;
assign wmb_req_size_w = ( {{19{1'b0}}, wmb_req_size_addr_limit} > wmb_req_burst_cnt_w) ? wmb_req_burst_cnt_w[3:0] : wmb_req_size_addr_limit;

//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"wmb_req_reg_en_d0\" -d \"wmb_req_size_w\" -q wmb_req_size_d1");
//: &eperl::flop("-nodeclare   -rval \"{23{1'b0}}\"  -en \"wmb_req_reg_en_d0\" -d \"wmb_req_burst_cnt_w\" -q wmb_req_burst_cnt_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"is_nxt_running & is_compressed\" -q wmb_req_stage_vld_d1");

/////////////////// stage 2 ///////////////////
assign wmb_req_reg_en_d1 = wmb_req_reg_en;
assign wmb_req_last_w = is_running & (wmb_req_burst_cnt_d1 == {{19{1'b0}}, wmb_req_size_d1});
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log(${atmm})/log(2));
//: print qq(
//:     assign wmb_req_addr_inc = wmb_req_addr_d2[64-${atmbw}-1:3] + 1'b1;
//: );
//assign wmb_req_addr_inc = wmb_req_addr_d2[58:3] + 56'b1;
assign wmb_req_addr_w = (~wmb_req_stage_vld_d2) ? {reg2dp_wmb_addr_high, reg2dp_wmb_addr_low} : {wmb_req_addr_inc, 3'b0};
assign wmb_req_size_out_w = wmb_req_size_d1[2:0] - 3'b1;
assign wmb_req_done_w = (layer_st & is_compressed) ? 1'b0 :
                        (layer_st & ~is_compressed) ? 1'b1 :
                        wmb_req_last_d2 ? 1'b1 : wmb_req_done_d2;

//: &eperl::flop("-nodeclare   -rval \"0\"          -en \"wmb_req_reg_en_d1\" -d \"wmb_req_addr_w\" -q wmb_req_addr_d2");
//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"wmb_req_reg_en_d1\" -d \"wmb_req_size_d1\" -q wmb_req_size_d2");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"wmb_req_reg_en_d1\" -d \"wmb_req_size_out_w\" -q wmb_req_size_out_d2");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"wmb_req_reg_en_d1\" -d \"wmb_req_last_w\" -q wmb_req_last_d2");
//: &eperl::flop("-nodeclare   -rval \"1'b1\"  -en \"wmb_req_reg_en_d1\" -d \"wmb_req_done_w\" -q wmb_req_done_d2");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"wmb_req_stage_vld_d1 & is_nxt_running\" -q wmb_req_stage_vld_d2");

/////////////////// stage 3 ///////////////////
assign wmb_req_reg_en_d2 = wmb_req_reg_en;
assign wmb_req_vld_w = is_nxt_running & wmb_req_stage_vld_d2;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"wmb_req_vld_w\" -q wmb_req_vld_d3");
//: &eperl::flop("-nodeclare   -rval \"0\"          -en \"wmb_req_reg_en_d2\" -d \"wmb_req_addr_d2\" -q wmb_req_addr_d3");
//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"wmb_req_reg_en_d2\" -d \"wmb_req_size_d2\" -q wmb_req_size_d3");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"wmb_req_reg_en_d2\" -d \"wmb_req_size_out_d2\" -q wmb_req_size_out_d3");
//: &eperl::flop("-nodeclare   -rval \"1'b1\"  -en \"wmb_req_reg_en_d2\" -d \"(is_running & wmb_req_done_d2)\" -q wmb_req_done_d3");
assign wmb_req_src_d3 = SRC_ID_WMB;


/////////////////// overflow control logic ///////////////////
assign {mon_wmb_req_sum,
        wmb_req_sum} = wmb_data_onfly + wmb_data_stored + wmb_data_avl;
assign wmb_req_overflow = is_running && (wmb_req_sum > {1'b1, 10'b0});
assign wmb_req_overflow_d3 = wmb_req_overflow;


/////////////////// pipeline control logic ///////////////////
assign wmb_req_reg_en = layer_st | (is_running & (~wmb_req_vld_d3 | wmb_req_rdy)); 

////////////////////////////////////////////////////////////////////////
//  generate address for WGS data                                     //
////////////////////////////////////////////////////////////////////////

/////////////////// stage 1 ///////////////////
assign {mon_wgs_req_dword_cnt_dec,
        wgs_req_dword_cnt_dec} = wgs_req_dword_cnt_d1 - wgs_req_dword_d1;
assign wgs_req_dword_cnt_w = layer_st ? group_w : wgs_req_dword_cnt_dec;

//assign wgs_req_dword_w = (10'h8 <= wgs_req_dword_cnt_w) ? 4'h8 : wgs_req_dword_cnt_w[3:0];
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $k = (($atmm * NVDLA_BPE )/32); ##32bits per kernel
//: my $m = int(log($k)/log(2));
//: if($m == 3) {
//:     print qq(
//:         assign wgs_req_dword_w = (12'h${k} <= wgs_req_dword_cnt_w) ? 4'h${k} : wgs_req_dword_cnt_w[${m}:0];
//:     );
//: } else {
//:     print qq(
//:         assign wgs_req_dword_w = (12'h${k} <= wgs_req_dword_cnt_w) ? 4'h${k} : {{(3-${m}){1'b0}},wgs_req_dword_cnt_w[${m}:0]};
//:     );
//: }
assign wgs_req_done = (wgs_req_dword_cnt_d1  == {{8{1'b0}}, wgs_req_dword_d1});
assign wgs_req_vld_w = (~is_running & is_nxt_running) ? is_compressed :
                       (is_running & wgs_req_done & wgs_req_rdy) ? 1'b0 : wgs_req_vld_d1;
assign {mon_wgs_req_addr_inc,
        wgs_req_addr_inc} = wgs_req_addr_d1 + 1'b1;
assign wgs_req_addr_w = layer_st ? {reg2dp_wgs_addr_high,reg2dp_wgs_addr_low} : wgs_req_addr_inc;
assign wgs_req_reg_en = layer_st | (is_running & wgs_req_vld_d1 & wgs_req_rdy & ~wgs_req_done);

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"wgs_req_vld_w\" -q wgs_req_vld_d1");
//: &eperl::flop("-nodeclare   -rval \"{12{1'b0}}\"  -en \"wgs_req_reg_en\" -d \"wgs_req_dword_cnt_w\" -q wgs_req_dword_cnt_d1");

//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"wgs_req_reg_en\" -d \"wgs_req_dword_w\" -q wgs_req_dword_d1");
//: &eperl::flop("-nodeclare   -rval \"0\"  -en \"wgs_req_reg_en\" -d \"wgs_req_addr_w\" -q wgs_req_addr_d1");

assign wgs_req_size_d1 = 4'h1;
assign wgs_req_size_out_d1 = 3'h0;
assign wgs_req_src_d1 = SRC_ID_WGS;

/////////////////// overflow control logic ///////////////////
assign {mon_wgs_req_sum,
        wgs_req_sum} = wgs_data_onfly + wgs_req_dword_d1;
assign wgs_req_overflow = is_running & (wgs_req_sum > 6'h20);//Note 6'h20 is the depth of NV_NVDLA_CDMA_WT_wgs_fifo

////////////////////////////////////////////////////////////////////////
//  CDMA WT read request arbiter                                      //
////////////////////////////////////////////////////////////////////////

NV_NVDLA_CDMA_WT_wrr_arb u_wrr_arb (
   .req0                (arb_wrr_in_vld[0])       //|< w
  ,.req1                (arb_wrr_in_vld[1])       //|< w
  ,.wt0                 (arb_wrr_weight_0[4:0])   //|< w
  ,.wt1                 (arb_wrr_weight_1[4:0])   //|< w
  ,.gnt_busy            (arb_wrr_block)           //|< w
  ,.clk                 (nvdla_core_clk)          //|< i
  ,.reset_              (nvdla_core_rstn)         //|< i
  ,.gnt0                (arb_wrr_in_rdy[0])       //|> w
  ,.gnt1                (arb_wrr_in_rdy[1])       //|> w
  );

assign arb_wrr_block = arb_wrr_out_back_vld;

///////////////////////////// WRR request package logic ////////////////////////////////
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log(${atmm})/log(2));
//: print qq(
//:     assign arb_wrr_out_package_w = ({(64-${atmbw}+9){arb_wrr_in_rdy[0]}} & arb_wrr_req_package_in_00) |
//:                                    ({(64-${atmbw}+9){arb_wrr_in_rdy[1]}} & arb_wrr_req_package_in_01) |
//:                                    ({(64-${atmbw}+9){arb_wrr_out_back_vld}} & arb_wrr_out_back_package);
//: );

assign arb_wrr_out_reg_en = (~arb_wrr_out_vld | arb_wrr_out_rdy) & (arb_wrr_out_back_vld | (|arb_wrr_in_vld));
assign arb_wrr_out_back_reg_en = arb_wrr_out_vld & ~arb_wrr_out_rdy & ~arb_wrr_out_back_vld & (|arb_wrr_in_vld);
assign arb_wrr_out_vld_w = ((|arb_wrr_in_vld) | arb_wrr_out_back_vld) ? 1'b1 :
                           arb_wrr_out_rdy ? 1'b0 : arb_wrr_out_vld;
assign arb_wrr_out_back_vld_w = arb_wrr_out_rdy ? 1'b0 :
                                (arb_wrr_out_vld & (|arb_wrr_in_vld)) ? 1'b1 : arb_wrr_out_back_vld;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"arb_wrr_out_vld_w\" -q arb_wrr_out_vld");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"arb_wrr_out_back_vld_w\" -q arb_wrr_out_back_vld");
//: &eperl::flop("-nodeclare  -norst -en \"arb_wrr_out_reg_en\" -d \"arb_wrr_out_package_w\" -q arb_wrr_out_package");
//: &eperl::flop("-nodeclare  -norst -en \"arb_wrr_out_back_reg_en\" -d \"arb_wrr_out_package_w\" -q arb_wrr_out_back_package");

///////////////////////////// Connect to WRR Logic ////////////////////////////////
assign arb_wrr_in_vld[0] = wmb_req_vld_d3 & ~wmb_req_overflow_d3 & ~wmb_req_done_d3;
assign arb_wrr_in_vld[1] = wt_req_vld_d3 & ~wt_req_overflow_d3 & ~wt_req_done_d3;

assign arb_wrr_weight_0 = arb_weight_wmb;
assign arb_wrr_weight_1 = arb_weight_wt;

assign wmb_req_rdy = arb_wrr_in_rdy[0];
assign wt_req_rdy  = arb_wrr_in_rdy[1];

assign arb_wrr_req_package_in_00 = {wmb_req_src_d3, wmb_req_size_d3, wmb_req_size_out_d3, wmb_req_addr_d3};
assign arb_wrr_req_package_in_01 = {wt_req_src_d3, wt_req_size_d3, wt_req_size_out_d3, wt_req_addr_d3};

///////////////////////////// Static Arbiter ////////////////////////////////
///////////////////////////// SP Control logic ////////////////////////////////

NV_NVDLA_CDMA_WT_sp_arb u_sp_arb (
   .req0                (arb_sp_in_vld[0])        //|< w
  ,.req1                (arb_sp_in_vld[1])        //|< w
  ,.gnt_busy            (arb_sp_block)            //|< w
  ,.gnt0                (arb_sp_in_rdy[0])        //|> w
  ,.gnt1                (arb_sp_in_rdy[1])        //|> w
  );

assign arb_sp_block = arb_sp_out_back_vld;

///////////////////////////// SP request package logic ////////////////////////////////
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log(${atmm})/log(2));
//: print qq(
//:     assign arb_sp_out_package_w = ({(64-${atmbw}+9){arb_sp_in_rdy[0]}} & arb_sp_req_package_in_00) |
//:                                   ({(64-${atmbw}+9){arb_sp_in_rdy[1]}} & arb_sp_req_package_in_01) |
//:                                   ({(64-${atmbw}+9){arb_sp_out_back_vld}} & arb_sp_out_back_package);
//: );

assign arb_sp_out_reg_en = (~arb_sp_out_vld | arb_sp_out_rdy) & (arb_sp_out_back_vld | (|arb_sp_in_vld));
assign arb_sp_out_back_reg_en = arb_sp_out_vld & ~arb_sp_out_rdy & ~arb_sp_out_back_vld & (|arb_sp_in_vld);
assign arb_sp_out_vld_w = ((|arb_sp_in_rdy) | arb_sp_out_back_vld) ? 1'b1 :
                          arb_sp_out_rdy ? 1'b0 :
                          arb_sp_out_vld;
assign arb_sp_out_back_vld_w = arb_sp_out_rdy ? 1'b0 :
                               (arb_sp_out_vld & (|arb_sp_in_vld)) ? 1'b1 :
                               arb_sp_out_back_vld;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"arb_sp_out_vld_w\" -q arb_sp_out_vld");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"arb_sp_out_back_vld_w\" -q arb_sp_out_back_vld");
//: &eperl::flop("-nodeclare  -norst -en \"arb_sp_out_reg_en\" -d \"arb_sp_out_package_w\" -q arb_sp_out_package");
//: &eperl::flop("-nodeclare  -norst -en \"arb_sp_out_back_reg_en\" -d \"arb_sp_out_package_w\" -q arb_sp_out_back_package");
    
///////////////////////////// Connect to Static Arbiter ////////////////////////////////
assign arb_sp_in_vld[0] = wgs_req_vld_d1 & ~wgs_req_overflow;
assign arb_sp_in_vld[1] = arb_wrr_out_vld;

assign wgs_req_rdy = arb_sp_in_rdy[0];
assign arb_wrr_out_rdy = arb_sp_in_rdy[1];

assign arb_sp_req_package_in_00 = {wgs_req_src_d1, wgs_req_size_d1, wgs_req_size_out_d1, wgs_req_addr_d1};
assign arb_sp_req_package_in_01 = arb_wrr_out_package;

///////////////////////////// connect to dma ////////////////////////////////

assign arb_sp_out_rdy = dma_rd_req_rdy & dma_req_fifo_ready;
assign {dma_req_src, dma_req_size, dma_req_size_out, dma_req_addr} = arb_sp_out_package;

#else
assign arb_sp_out_rdy = dma_rd_req_rdy & dma_req_fifo_ready;
assign arb_sp_out_vld = wt_req_vld_d3 & ~wt_req_overflow_d3 & ~wt_req_done_d3;
//assign wt_req_rdy = arb_sp_out_rdy;
assign wt_req_rdy = arb_sp_out_rdy & arb_sp_out_vld;

assign dma_req_src      = wt_req_src_d3;
assign dma_req_size     = wt_req_size_d3;
assign dma_req_size_out = wt_req_size_out_d3;
assign dma_req_addr     = wt_req_addr_d3;

#endif

////////////////////////////////////////////////////////////////////////
//  CDMA WT read request interface                                    //
////////////////////////////////////////////////////////////////////////
//==============
// DMA Interface
//==============
// rd Channel: Request
NV_NVDLA_DMAIF_rdreq NV_NVDLA_PDP_RDMA_rdreq(
  .nvdla_core_clk         (nvdla_core_clk     )
 ,.nvdla_core_rstn        (nvdla_core_rstn    )
 ,.reg2dp_src_ram_type    (reg2dp_weight_ram_type)
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
 ,.cvif_rd_req_pd         (cdma_wt2cvif_rd_req_pd    )
 ,.cvif_rd_req_valid      (cdma_wt2cvif_rd_req_valid )
 ,.cvif_rd_req_ready      (cdma_wt2cvif_rd_req_ready )
#endif
 ,.mcif_rd_req_pd         (cdma_wt2mcif_rd_req_pd    ) 
 ,.mcif_rd_req_valid      (cdma_wt2mcif_rd_req_valid ) 
 ,.mcif_rd_req_ready      (cdma_wt2mcif_rd_req_ready ) 

 ,.dmaif_rd_req_pd        (dma_rd_req_pd    ) 
 ,.dmaif_rd_req_vld       (dma_rd_req_vld   )
 ,.dmaif_rd_req_rdy       (dma_rd_req_rdy   )
);

// rd Channel: Response
NV_NVDLA_DMAIF_rdrsp NV_NVDLA_PDP_RDMA_rdrsp(
   .nvdla_core_clk     (nvdla_core_clk   ) 
  ,.nvdla_core_rstn    (nvdla_core_rstn  ) 
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cvif_rd_rsp_pd       (cvif2cdma_wt_rd_rsp_pd     )    
  ,.cvif_rd_rsp_valid    (cvif2cdma_wt_rd_rsp_valid  )
  ,.cvif_rd_rsp_ready    (cvif2cdma_wt_rd_rsp_ready  )
  #endif
  ,.mcif_rd_rsp_pd       (mcif2cdma_wt_rd_rsp_pd     ) 
  ,.mcif_rd_rsp_valid    (mcif2cdma_wt_rd_rsp_valid  )
  ,.mcif_rd_rsp_ready    (mcif2cdma_wt_rd_rsp_ready  )

  ,.dmaif_rd_rsp_pd      (dma_rd_rsp_pd    )    
  ,.dmaif_rd_rsp_pvld    (dma_rd_rsp_vld  )
  ,.dmaif_rd_rsp_prdy    (dma_rd_rsp_rdy  )
);
///////////////////////////////////////////

assign dma_rd_req_pd[NVDLA_MEM_ADDRESS_WIDTH-1:0] =    dma_rd_req_addr[NVDLA_MEM_ADDRESS_WIDTH-1:0];
assign dma_rd_req_pd[NVDLA_MEM_ADDRESS_WIDTH+14:NVDLA_MEM_ADDRESS_WIDTH] = dma_rd_req_size[14:0];
assign dma_rd_req_vld = arb_sp_out_vld & dma_req_fifo_ready;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log(${atmm})/log(2));
//: print qq(
//:     assign dma_rd_req_addr = {dma_req_addr, ${atmbw}'b0};
//: );
assign dma_rd_req_size = {{12{1'b0}}, dma_req_size_out};
assign dma_rd_req_type = reg2dp_weight_ram_type;
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
assign dma_rd_rsp_rdy = ~wgs_push_req;
#else
assign dma_rd_rsp_rdy = 1'b1;
#endif


NV_NVDLA_CDMA_WT_fifo u_fifo (
   .clk                 (nvdla_core_clk)          //|< i
  ,.reset_              (nvdla_core_rstn)         //|< i
  ,.wr_ready            (dma_req_fifo_ready)      //|> w
  ,.wr_req              (dma_req_fifo_req)        //|< r
  ,.wr_data             (dma_req_fifo_data[5:0])  //|< r
  ,.rd_ready            (dma_rsp_fifo_ready)      //|< r
  ,.rd_req              (dma_rsp_fifo_req)        //|> w *
  ,.rd_data             (dma_rsp_fifo_data[5:0])  //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

assign dma_req_fifo_req = arb_sp_out_vld & dma_rd_req_rdy;
assign dma_req_fifo_data = {dma_req_src, dma_req_size};

////////////////////////////////////////////////////////////////////////
//  For verification/debug                                            //
////////////////////////////////////////////////////////////////////////
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign dbg_src_rd_ptr_en = (cdma_wt2mcif_rd_req_valid & cdma_wt2mcif_rd_req_ready) | (cdma_wt2cvif_rd_req_valid & cdma_wt2cvif_rd_req_ready);
#else
assign dbg_src_rd_ptr_en = (cdma_wt2mcif_rd_req_valid & cdma_wt2mcif_rd_req_ready); 
#endif
assign dbg_src_rd_ptr_w = ~layer_st & (dbg_src_rd_ptr ^ dbg_src_rd_ptr_en);
assign dbg_src_wr_ptr_en = (dma_rd_req_vld & dma_req_fifo_ready & dma_rd_req_rdy);
assign dbg_src_wr_ptr_w = ~layer_st & (dbg_src_wr_ptr ^ dbg_src_wr_ptr_en);
assign dbg_dma_req_src = dbg_src_rd_ptr ? dbg_dma_req_src_b1 : dbg_dma_req_src_b0;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"dbg_src_rd_ptr_w\" -q dbg_src_rd_ptr");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"dbg_src_wr_ptr_w\" -q dbg_src_wr_ptr");
//: &eperl::flop("-nodeclare   -rval \"{2{1'b0}}\"  -en \"dbg_src_wr_ptr_en & ~dbg_src_wr_ptr\" -d \"dma_req_src\" -q dbg_dma_req_src_b0");
//: &eperl::flop("-nodeclare   -rval \"{2{1'b0}}\"  -en \"dbg_src_wr_ptr_en & dbg_src_wr_ptr\" -d \"dma_req_src\" -q dbg_dma_req_src_b1");

////////////////////////////////////////////////////////////////////////
//  CDMA read response connection                                     //
////////////////////////////////////////////////////////////////////////
assign dma_rd_rsp_data[NVDLA_MEMIF_WIDTH-1:0] =    dma_rd_rsp_pd[NVDLA_MEMIF_WIDTH-1:0];
assign dma_rd_rsp_mask[NVDLA_CDMA_MEM_RD_RSP-NVDLA_MEMIF_WIDTH-1:0] =    dma_rd_rsp_pd[NVDLA_CDMA_MEM_RD_RSP-1:NVDLA_MEMIF_WIDTH];
assign {dma_rsp_src, dma_rsp_size} = dma_rsp_fifo_data;
assign {mon_dma_rsp_size_cnt_inc, dma_rsp_size_cnt_inc} = dma_rsp_size_cnt
//: my $mask = NVDLA_CDMA_MEM_MASK_BIT;
//: foreach my $i(0..$mask-1) {
//:     print qq(
//:         + dma_rd_rsp_mask[$i]
//:     );
//: }
//: print qq( ; );
assign dma_rsp_size_cnt_w = (dma_rsp_size_cnt_inc == dma_rsp_size) ? 4'b0 : dma_rsp_size_cnt_inc;
assign dma_rsp_fifo_ready = (dma_rd_rsp_vld & dma_rd_rsp_rdy & (dma_rsp_size_cnt_inc == dma_rsp_size));

assign wt_rsp_valid = (dma_rd_rsp_vld & dma_rd_rsp_rdy & (dma_rsp_src == SRC_ID_WT));
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
assign wmb_rsp_valid = (dma_rd_rsp_vld & dma_rd_rsp_rdy & (dma_rsp_src == SRC_ID_WMB));
assign wgs_rsp_valid = (dma_rd_rsp_vld & dma_rd_rsp_rdy & (dma_rsp_src == SRC_ID_WGS));
#endif

assign {
//: my $mask = NVDLA_CDMA_MEM_MASK_BIT;
//: if($mask > 1) {
//:     foreach my $i(0..$mask-2) {
//:     my $j = $mask -$i -1;
//:         print qq( dma_rsp_data_p${j} , );
//:     }
//: }
 dma_rsp_data_p0} = dma_rd_rsp_data;

//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"dma_rd_rsp_vld & dma_rd_rsp_rdy\" -d \"dma_rsp_size_cnt_w\" -q dma_rsp_size_cnt");

////////////////////////////////////////////////////////////////////////
//  WT read data                                                      //
////////////////////////////////////////////////////////////////////////
assign wt_local_data_cnt = wt_local_data_vld
//: my $mask = NVDLA_CDMA_MEM_MASK_BIT;
//: foreach my $i(0..$mask-1) {
//:     print qq(
//:         + dma_rd_rsp_mask[$i]
//:     );
//: }
//: print qq( ; );

//: my $mask = NVDLA_CDMA_MEM_MASK_BIT;
//: if($mask == 1) {
//:  print qq(
//:     assign wt_local_data_vld_w = 1'b0;
//:     assign wt_local_data_reg_en = 1'b0;
//:     assign wt_cbuf_wr_vld_w = wt_rsp_valid;
//:     assign wt_local_data_w = 0;// bw
//:     assign wt_cbuf_wr_data_ori_w = dma_rsp_data_p0;
//:  );
//: } elsif($mask == 2) {
//:  print qq(
//:     assign wt_local_data_vld_w = wt_local_data_cnt[0];
//:     assign wt_local_data_reg_en = wt_rsp_valid & wt_local_data_cnt[0];
//:     assign wt_cbuf_wr_vld_w = wt_rsp_valid & wt_local_data_cnt[1];
//:     assign wt_local_data_w = dma_rd_rsp_mask[1] ? dma_rsp_data_p1 : dma_rsp_data_p0;
//:     assign wt_cbuf_wr_data_ori_w = wt_local_data_vld ? {dma_rsp_data_p0, wt_local_data} : dma_rd_rsp_data;
//:  );
//: } elsif($mask == 4) {
//:  print qq(
//:     assign wt_local_data_vld_w = |wt_local_data_cnt[1:0];
//:     assign wt_local_data_reg_en = wt_rsp_valid & wt_local_data_vld_w;
//:     assign wt_cbuf_wr_vld_w = wt_rsp_valid & wt_local_data_cnt[2];
//:     assign wt_local_data_w = dma_rd_rsp_mask[3] ? dma_rd_rsp_data ://
//:                              dma_rd_rsp_mask[2] ? {dma_rsp_data_p2, dma_rsp_data_p1, dma_rsp_data_p0}: 
//:                              dma_rd_rsp_mask[1] ? {dma_rsp_data_p1, dma_rsp_data_p0} : dma_rsp_data_p0;
//:     assign wt_cbuf_wr_data_ori_w = wt_local_data_vld ? {dma_rsp_data_p0, wt_local_data} : dma_rd_rsp_data;//
//:  );
//: }
assign wt_cbuf_wr_idx_inc = wt_cbuf_wr_idx + 1'b1;
assign wt_cbuf_wr_idx_set = (layer_st & ~(|wt_cbuf_wr_idx));
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: my $k;
//: if($dmaif < $atmc) {
//:     $k = int(log(int($atmc/$dmaif))/log(2));
//: } else {
//:     $k = 0;
//: }
//:
//: my $bank_depth_bits = int( log(NVDLA_CBUF_BANK_DEPTH)/log(2) + ${k});
//: print qq(
//: assign wt_cbuf_wr_idx_wrap = (wt_cbuf_wr_idx_inc == {weight_bank_end, ${bank_depth_bits}'b0});
//: assign wt_cbuf_wr_idx_w = (clear_all | wt_cbuf_wr_idx_set | wt_cbuf_wr_idx_wrap) ? {data_bank_w, ${bank_depth_bits}'b0} : wt_cbuf_wr_idx_inc[(1  + 16 ) -1:0];
//: );
//assign wt_cbuf_wr_data_w = nan_pass ? wt_cbuf_wr_data_ori_w : (wt_cbuf_wr_data_ori_w & wt_nan_mask);
assign wt_cbuf_wr_data_w = wt_cbuf_wr_data_ori_w;

//: &eperl::flop("-nodeclare  -norst -en \"wt_local_data_reg_en\" -d \"wt_local_data_w\" -q wt_local_data");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"wt_rsp_valid\" -d \"wt_local_data_vld_w\" -q wt_local_data_vld");
//: &eperl::flop("-nodeclare   -rval \"{17{1'b0}}\"  -en \"wt_cbuf_wr_idx_set | clear_all | wt_cbuf_wr_vld_w\" -d \"wt_cbuf_wr_idx_w\" -q wt_cbuf_wr_idx");

#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
////////////////////////////////////////////////////////////////////////
//  WMB read data                                                     //
////////////////////////////////////////////////////////////////////////
assign wmb_local_data_cnt = wmb_local_data_vld
//: my $mask = NVDLA_CDMA_MEM_MASK_BIT;
//: foreach my $i(0..$mask-1) {
//:     print qq(
//:         + dma_rd_rsp_mask[$i]
//:     );
//: }
//: print qq( ; );


//: my $mask = NVDLA_CDMA_MEM_MASK_BIT;
//: if($mask == 1) {
//:  print qq(
//:     assign wmb_local_data_vld_w = 1'b0;
//:     assign wmb_cbuf_wr_vld_w = wmb_rsp_valid;
//:     assign wmb_cbuf_wr_data_w = dma_rsp_data_p0;
//:     assign wmb_local_data_w = 0;
//:  );
//: } elsif($mask == 2) {
//:  print qq(
//:     assign wmb_local_data_vld_w = wmb_local_data_cnt[0];
//:     assign wmb_cbuf_wr_vld_w = wmb_rsp_valid & wmb_local_data_cnt[1];
//:     assign wmb_cbuf_wr_data_w = wmb_local_data_vld ? {dma_rsp_data_p0, wmb_local_data} : {dma_rsp_data_p1, dma_rsp_data_p0};
//:     assign wmb_local_data_w = dma_rd_rsp_mask[1] ? dma_rsp_data_p1 : dma_rsp_data_p0;
//:  );
//: } elsif($mask == 4) {
//:  print qq(
//:     assign wmb_local_data_vld_w = |wmb_local_data_cnt[1:0];
//:     assign wmb_cbuf_wr_vld_w = wmb_rsp_valid & wmb_local_data_cnt[2];
//:     assign wmb_cbuf_wr_data_w = wmb_local_data_vld ? {dma_rsp_data_p0, wmb_local_data} : {dma_rsp_data_p1, dma_rsp_data_p0};//
//:     assign wmb_local_data_w = dma_rd_rsp_mask[1] ? dma_rsp_data_p1 : dma_rsp_data_p0;//##
//:  );
//: }
assign wmb_local_data_reg_en = wmb_rsp_valid & wmb_local_data_vld_w;
assign {mon_wmb_cbuf_wr_idx_inc,wmb_cbuf_wr_idx_inc} = wmb_cbuf_wr_idx[(1  + 8 ) -1:0] + 1'b1;
assign wmb_cbuf_wr_idx_w = (clear_all) ? {~{4'b0}, 9'b0} : {~{4'b0}, wmb_cbuf_wr_idx_inc};

//: &eperl::flop("-nodeclare  -norst -en \"wmb_local_data_reg_en\" -d \"wmb_local_data_w\" -q wmb_local_data");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"wmb_rsp_valid\" -d \"wmb_local_data_vld_w\" -q wmb_local_data_vld");
//: &eperl::flop("-nodeclare   -rval \"{~{4'b0}, 9'b0}\"  -en \"clear_all | wmb_cbuf_wr_vld_w\" -d \"wmb_cbuf_wr_idx_w\" -q wmb_cbuf_wr_idx");

////////////////////////////////////////////////////////////////////////
//  WGS read data                                                     //
////////////////////////////////////////////////////////////////////////

assign {mon_wgs_push_cnt_inc, wgs_push_cnt_inc} = wgs_push_cnt + 1'b1;
assign wgs_push_last = (wgs_push_cnt_inc == group);
assign wgs_push_cnt_w = layer_st ? 12'b0 : wgs_push_cnt_inc;
//assign wgs_push_req_w = wgs_rsp_valid ? 1'b1 : ((wgs_push_cnt[2:0] == 3'h7) | wgs_push_last) ? 1'b0 : wgs_push_req;
//: my $atmm = (NVDLA_MEMORY_ATOMIC_SIZE * NVDLA_BPE);
//: my $atmm_num = ($atmm / 32);
//: my $k = int (log($atmm_num)/log(2));
//: print qq(
//:     assign wgs_push_req_w = wgs_rsp_valid ? 1'b1 : ((&wgs_push_cnt[${k}-1:0]) | wgs_push_last) ? 1'b0 : wgs_push_req;
//:     assign {mon_wgs_push_data,wgs_push_data} = (wgs_local_data >> {wgs_push_cnt[${k}-1:0], 5'b0});
//: );

//: &eperl::flop("-nodeclare   -rval \"{12{1'b0}}\"  -en \"layer_st | wgs_push_req\" -d \"wgs_push_cnt_w\" -q wgs_push_cnt");
//: &eperl::flop("-nodeclare  -norst -en \"wgs_rsp_valid\" -d \"dma_rsp_data_p0\" -q wgs_local_data");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"wgs_push_req_w\" -q wgs_push_req");

NV_NVDLA_CDMA_WT_wgs_fifo u_wgs_fifo (
   .clk                 (nvdla_core_clk)          //|< i
  ,.reset_              (nvdla_core_rstn)         //|< i
  ,.wr_ready            (wgs_push_ready)          //|> w *
  ,.wr_req              (wgs_push_req)            //|< r
  ,.wr_data             (wgs_push_data[31:0])     //|< r
  ,.rd_ready            (wgs_pop_ready)           //|< r
  ,.rd_req              (wgs_pop_req)             //|> w
  ,.rd_data             (wgs_pop_data[31:0])      //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

assign wgs_pop_ready = is_compressed & status_update;
#endif

////////////////////////////////////////////////////////////////////////
//  weight buffer flushing logic                                      //
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//  Non-SLCG clock domain                                             //
////////////////////////////////////////////////////////////////////////

assign {mon_wt_cbuf_flush_idx_w, wt_cbuf_flush_idx_w} = wt_cbuf_flush_idx + 1'b1;
//: my $bank_entry = NVDLA_CBUF_BANK_NUMBER * NVDLA_CBUF_BANK_DEPTH;
//: my $bank_entry_bw = int( log( $bank_entry)/log(2) );
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: my $k;
//: if($dmaif < $atmc) {
//:     $k = int(log(int($atmc/$dmaif))/log(2));
//: } else {
//:     $k = 0;
//: }
//: print qq(
//:   assign wt_cbuf_flush_vld_w = ~wt_cbuf_flush_idx[${bank_entry_bw}+$k-1];//max value = half bank entry * 2^$k
//:   assign dp2reg_wt_flush_done = wt_cbuf_flush_idx[${bank_entry_bw}+$k-1];
//: );

//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{18{1'b0}}\"  -en \"wt_cbuf_flush_vld_w\" -d \"wt_cbuf_flush_idx_w\" -q wt_cbuf_flush_idx");

////////////////////////////////////////////////////////////////////////
//  WT and WMB write to convolution buffer                            //
////////////////////////////////////////////////////////////////////////
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
assign cdma2buf_wt_wr_en_w = wt_cbuf_wr_vld_w | wmb_cbuf_wr_vld_w | wt_cbuf_flush_vld_w;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: my $half_bank_entry_num = NVDLA_CBUF_BANK_NUMBER * NVDLA_CBUF_BANK_DEPTH / 2;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:     assign cdma2buf_wt_wr_addr_w = wt_cbuf_wr_vld_w ? wt_cbuf_wr_idx[16:${k}] :
//:                                    wmb_cbuf_wr_vld_w ? wmb_cbuf_wr_idx[(1  + 12 ) -1:${k}] :
//:                                    ${half_bank_entry_num} + wt_cbuf_flush_idx[16:${k}];
//:     assign cdma2buf_wt_wr_sel_w = wt_cbuf_wr_vld_w ? wt_cbuf_wr_idx[${k}-1:0] :
//:                                    wmb_cbuf_wr_vld_w ? wmb_cbuf_wr_idx[${k}-1:0] : wt_cbuf_flush_idx[${k}-1:0];
//:     assign cdma2buf_wt_wr_data_w = wt_cbuf_wr_vld_w ? wt_cbuf_wr_data_w :
//:                                    wmb_cbuf_wr_vld_w ? wmb_cbuf_wr_data_w : 0;
//:     );
//: 
//:     my $dmanum = int($atmc/$dmaif);
//:     foreach my $s (0..${dmanum}-1) {
//:         &eperl::flop("-nodeclare -clk nvdla_core_ng_clk -rval \"1'b0\"  -en \"cdma2buf_wt_wr_en_w\" -d \"cdma2buf_wt_wr_sel_w===${k}'d${s}\" -q cdma2buf_wt_wr_sel[${s}]");
//:     }
//: } elsif($dmaif > $atmc) {
//:     ## my $k = int(log(int($dmaif/$atmc))/log(2));
//:     ## print qq(
//:     ## output   [${k}-1:0]      cdma2buf_wt_wr_mask;
//:     ## );
//:     ## foreach my $i (0..$k-1) {
//:     ##     print qq(
//:     ##         output [16:0]         cdma2buf_wt_wr_addr${i};
//:     ##         output [${dmaif}-1:0] cdma2buf_wt_wr_data${i};
//:     ##     );
//:     ## }
//: } else {
//:     print qq(
//:     assign cdma2buf_wt_wr_addr_w = wt_cbuf_wr_vld_w ? wt_cbuf_wr_idx :
//:                                    wmb_cbuf_wr_vld_w ? wmb_cbuf_wr_idx :
//:                                    ${half_bank_entry_num} + wt_cbuf_flush_idx;
//:     assign cdma2buf_wt_wr_data_w = wt_cbuf_wr_vld_w ? wt_cbuf_wr_data_w :
//:                                    wmb_cbuf_wr_vld_w ? wmb_cbuf_wr_data_w : 0;
//:     );
//: }

#else
assign cdma2buf_wt_wr_en_w = wt_cbuf_wr_vld_w | wt_cbuf_flush_vld_w;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: my $half_bank_entry_num = NVDLA_CBUF_BANK_NUMBER * NVDLA_CBUF_BANK_DEPTH / 2;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:     assign cdma2buf_wt_wr_addr_w = wt_cbuf_wr_vld_w ? wt_cbuf_wr_idx[(1  + 16 ) -1:${k}] :
//:                                    ${half_bank_entry_num} + wt_cbuf_flush_idx[16:${k}];
//:     assign cdma2buf_wt_wr_sel_w = wt_cbuf_wr_vld_w ? wt_cbuf_wr_idx[${k}-1:0] :
//:                                    wt_cbuf_flush_idx[${k}-1:0];
//:     assign cdma2buf_wt_wr_data_w = wt_cbuf_wr_vld_w ? wt_cbuf_wr_data_w :
//:                                     0;
//:     );
//: 
//:     my $dmanum = int($atmc/$dmaif);
//:     foreach my $s (0..${dmanum}-1) {
//:         &eperl::flop("-nodeclare -clk nvdla_core_ng_clk -rval \"1'b0\"  -en \"cdma2buf_wt_wr_en_w\" -d \"cdma2buf_wt_wr_sel_w===${k}'d${s}\" -q cdma2buf_wt_wr_sel[${s}]");
//:     }
//:  ## &eperl::flop("-nodeclare -clk nvdla_core_ng_clk -rval \"1'b0\"  -en \"cdma2buf_wt_wr_en_w\" -d \"cdma2buf_wt_wr_sel_w\" -q cdma2buf_wt_wr_sel");
//: } elsif($dmaif > $atmc) {
//: } else {
//:     print qq(
//:     assign cdma2buf_wt_wr_addr_w = wt_cbuf_wr_vld_w ? wt_cbuf_wr_idx : ${half_bank_entry_num} + wt_cbuf_flush_idx;
//:     assign cdma2buf_wt_wr_data_w = wt_cbuf_wr_vld_w ? wt_cbuf_wr_data_w : 0;
//:     );
//: }

#endif

//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk -rval \"1'b0\"   -d \"cdma2buf_wt_wr_en_w\" -q cdma2buf_wt_wr_en");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk -rval \"{17{1'b0}}\"  -en \"cdma2buf_wt_wr_en_w\" -d \"cdma2buf_wt_wr_addr_w\" -q cdma2buf_wt_wr_addr");

////////////////////////////////////////////////////////////////////////
//  Non-SLCG clock domain end                                         //
////////////////////////////////////////////////////////////////////////
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: &eperl::flop("-nodeclare   -rval \"{${dmaif}{1'b0}}\"  -en \"cdma2buf_wt_wr_en_w\" -d \"cdma2buf_wt_wr_data_w\" -q cdma2buf_wt_wr_data");

#ifdef NVDLA_WEIGHT_DATA_TYPE_INT8
assign dp2reg_nan_weight_num = 32'b0;
assign dp2reg_inf_weight_num = 32'b0;
#else
////////////////////////////////////////////////////////////////////////
//  Infinity and NaN counting logic                                   //
////////////////////////////////////////////////////////////////////////
//: my $i;
//: my $b0;
//: my $b1;
//: for($i = 0; $i < 32; $i ++) {
//:     $b0 = 16 * $i + 10;
//:     $b1 = 16 * $i + 14;
//:     print "assign wt_fp16_exp_flag_w[$i] = (&wt_cbuf_wr_data_ori_w[${b1}:${b0}]);\n";
//: }
//: print "\n\n";
//: 
//: for($i = 0; $i < 32; $i ++) {
//:     $b0 = 16 * $i;
//:     $b1 = 16 * $i + 9;
//:     print "assign wt_fp16_manti_flag_w[$i] = (|wt_cbuf_wr_data_ori_w[${b1}:${b0}]);\n";
//: }
//: print "\n\n";

assign wt_fp16_nan_flag_w = wt_fp16_exp_flag_w & wt_fp16_manti_flag_w;
assign wt_fp16_inf_flag_w = wt_fp16_exp_flag_w & ~wt_fp16_manti_flag_w;

//: my $i;
//: for($i = 0; $i < 32; $i ++) {
//:     $b0 = 16 * $i;
//:     $b1 = 16 * $i + 15;
//:     print "assign wt_nan_mask[${b1}:${b0}] = {16{~wt_fp16_nan_flag_w[${i}]}};\n";
//: }
//: print "\n\n";

assign wt_fp16_nan_vld_w = wt_cbuf_wr_vld_w & (|wt_fp16_nan_flag_w) & reg2dp_op_en & is_fp16;
assign wt_fp16_inf_vld_w = wt_cbuf_wr_vld_w & (|wt_fp16_inf_flag_w) & reg2dp_op_en & is_fp16;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"wt_fp16_nan_vld_w\" -q wt_fp16_nan_vld");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"wt_fp16_inf_vld_w\" -q wt_fp16_inf_vld");
//: &eperl::flop("-nodeclare  -norst -en \"wt_fp16_nan_vld_w\" -d \"wt_fp16_nan_flag_w\" -q wt_fp16_nan_flag");
//: &eperl::flop("-nodeclare  -norst -en \"wt_fp16_inf_vld_w\" -d \"wt_fp16_inf_flag_w\" -q wt_fp16_inf_flag");

/////////////////// ///////////////////

assign wt_fp16_nan_sum = wt_fp16_nan_flag[31] + wt_fp16_nan_flag[30] + wt_fp16_nan_flag[29] + wt_fp16_nan_flag[28] + wt_fp16_nan_flag[27] + wt_fp16_nan_flag[26] + wt_fp16_nan_flag[25] + wt_fp16_nan_flag[24] +
                         wt_fp16_nan_flag[23] + wt_fp16_nan_flag[22] + wt_fp16_nan_flag[21] + wt_fp16_nan_flag[20] + wt_fp16_nan_flag[19] + wt_fp16_nan_flag[18] + wt_fp16_nan_flag[17] + wt_fp16_nan_flag[16] +
                         wt_fp16_nan_flag[15] + wt_fp16_nan_flag[14] + wt_fp16_nan_flag[13] + wt_fp16_nan_flag[12] + wt_fp16_nan_flag[11] + wt_fp16_nan_flag[10] + wt_fp16_nan_flag[9] + wt_fp16_nan_flag[8] +
                         wt_fp16_nan_flag[7] + wt_fp16_nan_flag[6] + wt_fp16_nan_flag[5] + wt_fp16_nan_flag[4] + wt_fp16_nan_flag[3] + wt_fp16_nan_flag[2] + wt_fp16_nan_flag[1] + wt_fp16_nan_flag[0];

assign wt_fp16_inf_sum = wt_fp16_inf_flag[31] + wt_fp16_inf_flag[30] + wt_fp16_inf_flag[29] + wt_fp16_inf_flag[28] + wt_fp16_inf_flag[27] + wt_fp16_inf_flag[26] + wt_fp16_inf_flag[25] + wt_fp16_inf_flag[24] +
                         wt_fp16_inf_flag[23] + wt_fp16_inf_flag[22] + wt_fp16_inf_flag[21] + wt_fp16_inf_flag[20] + wt_fp16_inf_flag[19] + wt_fp16_inf_flag[18] + wt_fp16_inf_flag[17] + wt_fp16_inf_flag[16] +
                         wt_fp16_inf_flag[15] + wt_fp16_inf_flag[14] + wt_fp16_inf_flag[13] + wt_fp16_inf_flag[12] + wt_fp16_inf_flag[11] + wt_fp16_inf_flag[10] + wt_fp16_inf_flag[9] + wt_fp16_inf_flag[8] +
                         wt_fp16_inf_flag[7] + wt_fp16_inf_flag[6] + wt_fp16_inf_flag[5] + wt_fp16_inf_flag[4] + wt_fp16_inf_flag[3] + wt_fp16_inf_flag[2] + wt_fp16_inf_flag[1] + wt_fp16_inf_flag[0];


assign {nan_carry,
        dp2reg_nan_weight_num_inc} = dp2reg_nan_weight_num + wt_fp16_nan_sum;
assign dp2reg_nan_weight_num_w = layer_st ? 32'b0 :
                                 nan_carry ? ~(32'b0) :
                                 dp2reg_nan_weight_num_inc;
assign nan_reg_en = layer_st | (wt_fp16_nan_vld & (|wt_fp16_nan_sum));
assign {inf_carry,
        dp2reg_inf_weight_num_inc} = dp2reg_inf_weight_num + wt_fp16_inf_sum;
assign dp2reg_inf_weight_num_w = layer_st ? 32'b0 :
                                 inf_carry ? ~(32'b0) :
                                 dp2reg_inf_weight_num_inc;
assign inf_reg_en = layer_st | (wt_fp16_inf_vld & (|wt_fp16_inf_sum));

//: &eperl::flop("-nodeclare   -rval \"{32{1'b0}}\"  -en \"nan_reg_en\" -d \"dp2reg_nan_weight_num_w\" -q dp2reg_nan_weight_num");
//: &eperl::flop("-nodeclare   -rval \"{32{1'b0}}\"  -en \"inf_reg_en\" -d \"dp2reg_inf_weight_num_w\" -q dp2reg_inf_weight_num");
#endif

////////////////////////////////////////////////////////////////////////
//  WT data status monitor                                            //
////////////////////////////////////////////////////////////////////////
//================  Non-SLCG clock domain ================//

//sc2cdma_wt_kernels are useless

//retiming
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"1'b0\"   -d \"sc2cdma_wt_updt\" -q sc_wt_updt");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{15{1'b0}}\"  -en \"sc2cdma_wt_updt\" -d \"sc2cdma_wt_entries\" -q sc_wt_entries");
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{9{1'b0}}\"  -en \"sc2cdma_wt_updt\" -d \"sc2cdma_wmb_entries\" -q sc_wmb_entries");
#endif

//cation: the basic unit of data_stored, data_onfly and data_avl is atomic_m bytes, 32 bytes in Xavier
assign wt_data_onfly_add = (wt_req_reg_en_d2 & wt_req_stage_vld_d2 & ~wt_req_done_d2) ? wt_req_size_d2 : 4'b0;
//atom_m num per cbuf write, =dmaif/atom_m
//: my $dmaif = (NVDLA_CDMA_DMAIF_BW / NVDLA_BPE);
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmm_dmaif =  int($dmaif / $atmm);
//: my $atmm_atmc =  int($atmc / $atmm);
//: print qq(
//: assign wt_data_onfly_sub = wt_cbuf_wr_vld_w ? 3'd${atmm_dmaif} : 3'b0;
//: );
//: if($atmm_atmc == 4) {
//:     print qq(
//:     assign wt_data_stored_sub = status_update ? {incr_wt_entries_w, 2'd0} : 17'b0;
//:     assign wt_data_avl_sub = sc_wt_updt ? {sc_wt_entries, 2'b0} : 17'b0;
//:     );
//: } elsif($atmm_atmc == 2) {
//:     print qq(
//:     assign wt_data_stored_sub = status_update ? {1'b0,incr_wt_entries_w, 1'd0} : 17'b0;
//:     assign wt_data_avl_sub = sc_wt_updt ? {1'b0,sc_wt_entries, 1'b0} : 17'b0;
//:     );
//: } elsif($atmm_atmc == 1) {
//:     print qq(
//:     assign wt_data_stored_sub = status_update ? {2'b0,incr_wt_entries_w} : 17'b0;
//:     assign wt_data_avl_sub = sc_wt_updt ? {2'b0,sc_wt_entries} : 17'b0;
//:     );
//: }
assign {mon_wt_data_onfly_w, wt_data_onfly_w} = wt_data_onfly + wt_data_onfly_add - wt_data_onfly_sub;
//assign wt_data_stored_sub = status_update ? {incr_wt_entries_w, 2'b0} : 14'b0;
assign {mon_wt_data_stored_w, wt_data_stored_w} = wt_data_stored + wt_data_onfly_sub - wt_data_stored_sub;
//assign wt_data_avl_sub = sc_wt_updt ? {sc_wt_entries, 2'b0} : 14'b0;
assign {mon_wt_data_avl_w, wt_data_avl_w} = (clear_all) ? 17'b0 : wt_data_avl + wt_data_stored_sub - wt_data_avl_sub;
assign wt_data_onfly_reg_en = ((wt_req_reg_en_d2 & wt_req_stage_vld_d2) | wt_cbuf_wr_vld_w);

//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{14{1'b0}}\"  -en \"wt_data_onfly_reg_en\" -d \"wt_data_onfly_w\" -q wt_data_onfly");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{17{1'b0}}\"  -en \"wt_cbuf_wr_vld_w | status_update\" -d \"wt_data_stored_w\" -q wt_data_stored");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{17{1'b0}}\"  -en \"status_update | sc_wt_updt | clear_all\" -d \"wt_data_avl_w\" -q wt_data_avl");

#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
////////////////////////////////////////////////////////////////////////
//  WMB data status monitor                                           //
////////////////////////////////////////////////////////////////////////

//atom_m num per cbuf write, =dmaif/atom_m
//: my $dmaif = (NVDLA_CDMA_DMAIF_BW / NVDLA_BPE);
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmm_dmaif =  int($dmaif / $atmm);
//: my $atmm_atmc =  int($atmc / $atmm);
//: print qq(
//: assign wmb_data_onfly_sub = wmb_cbuf_wr_vld_w ? 3'd${atmm_dmaif} : 3'b0;
//: );
//: if($atmm_atmc == 4) {
//:     print qq(
//:     assign wmb_data_stored_sub = status_update_wmb ? {incr_wmb_entries_w, 2'b0} : 11'b0;
//:     assign wmb_data_avl_sub = sc_wt_updt ? {sc_wmb_entries, 2'b0} : 11'b0;
//:     );
//: } elsif($atmm_atmc == 2) {
//:     print qq(
//:     assign wmb_data_stored_sub = status_update_wmb ? {1'b0,incr_wmb_entries_w, 1'b0} : 11'b0;
//:     assign wmb_data_avl_sub = sc_wt_updt ? {1'b0,sc_wmb_entries, 1'b0} : 11'b0;
//:     );
//: } elsif($atmm_atmc == 1) {
//:     print qq(
//:     assign wmb_data_stored_sub = status_update_wmb ? {2'b0,incr_wmb_entries_w} : 11'b0;
//:     assign wmb_data_avl_sub = sc_wt_updt ? {2'b0,sc_wmb_entries} : 11'b0;
//:     );
//: }

assign wmb_data_onfly_add = (wmb_req_reg_en_d2 & wmb_req_stage_vld_d2 & ~wmb_req_done_d2) ? wmb_req_size_d2 : 4'b0;
//assign wmb_data_onfly_sub = wmb_cbuf_wr_vld_w ? 2'b10 : 2'b0;
assign {mon_wmb_data_onfly_w,
        wmb_data_onfly_w} = wmb_data_onfly + wmb_data_onfly_add - wmb_data_onfly_sub;
//assign wmb_data_stored_sub = status_update_wmb ? {incr_wmb_entries_w, 2'b0} : 11'b0;
assign {mon_wmb_data_stored_w,
        wmb_data_stored_w} = wmb_data_stored + wmb_data_onfly_sub - wmb_data_stored_sub;
//assign wmb_data_avl_sub = sc_wt_updt ? {sc_wmb_entries, 2'b0} : 11'b0;
assign {mon_wmb_data_avl_w,
        wmb_data_avl_w} = (clear_all) ? 15'b0 :
                         wmb_data_avl + wmb_data_stored_sub - wmb_data_avl_sub;
assign wmb_data_onfly_reg_en = ((wmb_req_reg_en_d2 & wmb_req_stage_vld_d2) | wmb_cbuf_wr_vld_w);

//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{11{1'b0}}\"  -en \"wmb_data_onfly_reg_en\" -d \"wmb_data_onfly_w\" -q wmb_data_onfly");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{14{1'b0}}\"  -en \"wmb_cbuf_wr_vld_w | status_update_wmb\" -d \"wmb_data_stored_w\" -q wmb_data_stored");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{15{1'b0}}\"  -en \"status_update_wmb | sc_wt_updt | clear_all\" -d \"wmb_data_avl_w\" -q wmb_data_avl");

//================  Non-SLCG clock domain end ================//

////////////////////////////////////////////////////////////////////////
//  WGS data status monitor                                           //
////////////////////////////////////////////////////////////////////////
//csm is stand for consume
assign wgs_data_onfly_add = (wgs_req_rdy) ? wgs_req_dword_d1 : 5'b0;
assign wgs_data_onfly_sub = (wgs_pop_req & wgs_pop_ready) ? 1'b1 : 1'b0;
assign {mon_wgs_data_onfly_w, wgs_data_onfly_w} = wgs_data_onfly + wgs_data_onfly_add - wgs_data_onfly_sub;
assign wgs_data_onfly_reg_en = (wgs_req_rdy | (wgs_pop_req & wgs_pop_ready));

//: &eperl::flop("-nodeclare   -rval \"{6{1'b0}}\"  -en \"wgs_data_onfly_reg_en\" -d \"wgs_data_onfly_w\" -q wgs_data_onfly");
#endif

////////////////////////////////////////////////////////////////////////
//  status update logic                                               //
////////////////////////////////////////////////////////////////////////
assign status_group_cnt_inc = status_group_cnt + 1'b1;
assign status_last_group = (status_group_cnt_inc == group);
assign status_group_cnt_w = layer_st ? 12'b0 : status_group_cnt_inc;
assign status_done_w = layer_st ? 1'b0 :
                       status_last_group ? 1'b1 : status_done;

//: my $atmk = NVDLA_MAC_ATOMIC_K_SIZE;
//: my $atmkbw = int(log($atmk) / log(2));
//: print qq(
//:     assign normal_bpg = {byte_per_kernel, ${atmkbw}'b0};
//: );

#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
assign {mon_wt_required_bytes_w,
        wt_required_bytes_w} = layer_st ? 33'b0 :
                               status_last_group ? {1'b0, reg2dp_weight_bytes}  :
                               is_compressed ? pre_wt_required_bytes + wgs_pop_data :
                               pre_wt_required_bytes + normal_bpg;
#else
assign {mon_wt_required_bytes_w,
        wt_required_bytes_w} = layer_st ? 33'b0 :
                               status_last_group ? {1'b0, reg2dp_weight_bytes}  :
                               pre_wt_required_bytes + normal_bpg;
#endif
assign wt_required_en = ~required_valid & required_valid_w;
assign pre_wt_required_bytes_w = (layer_st) ? 32'b0 : wt_required_bytes;
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
assign {mon_wmb_required_bits_w,
        wmb_required_bits_w} = layer_st ? 33'b0 :
//
//: my $k = int(log(NVDLA_BPE)/log(2)); 
//: my $b = int(log(NVDLA_BPE/8)/log(2)); ##8 bits per byte
//: print qq(                  status_last_group ? {2'b0, reg2dp_wmb_bytes, ${k}'d0}  :  );
//: print qq(                  pre_wmb_required_bits + normal_bpg[23:${b}]; );

                               //status_last_group ? { {{2{1'b0}}, reg2dp_wmb_bytes}, 10'b0} :
                               //pre_wmb_required_bits + normal_bpg[23:0];
assign wmb_required_en = ~required_valid & required_valid_w & is_compressed;
assign pre_wmb_required_bits_w = layer_st ? 31'b0 :  wmb_required_bits;
assign required_valid_w = is_running & ~status_update & (~is_compressed | wgs_pop_req);
#else
assign required_valid_w = is_running & ~status_update;
#endif

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"required_valid_w\" -q required_valid");
//: &eperl::flop("-nodeclare   -rval \"{32{1'b0}}\"  -en \"layer_st | wt_required_en\" -d \"wt_required_bytes_w\" -q wt_required_bytes");
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
//: &eperl::flop("-nodeclare   -rval \"{32{1'b0}}\"  -en \"layer_st | wmb_required_en\" -d \"wmb_required_bits_w\" -q wmb_required_bits");
#endif

//////// caution: one in fetched_cnt refers to 64 bytes ////////
assign {mon_wt_fetched_cnt_inc, wt_fetched_cnt_inc} = wt_fetched_cnt + 1'b1;
assign wt_fetched_cnt_w = layer_st ? 26'b0 :  wt_fetched_cnt_inc;

#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
//////// caution: one in fetched_cnt refers to 64 bytes ////////
assign {mon_wmb_fetched_cnt_inc, wmb_fetched_cnt_inc} = wmb_fetched_cnt + 1'b1;
assign wmb_fetched_cnt_w = layer_st ? 22'b0 : wmb_fetched_cnt_inc;
//
//: my $m = int(log(NVDLA_BPE)/log(2)); 
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/8; ## byte number per dmaif tx
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE * NVDLA_CDMA_BPE;
//: my $dmaifbw=NVDLA_CDMA_DMAIF_BW;
//: my $k = int(log($dmaif)/log(2));
//: if($atmc > $dmaifbw) {
//:     my $k = int( log( ${atmc}/${dmaifbw} )/log(2) );
//:     print qq(
//:         assign wt_satisfied = is_running & ({wt_fetched_cnt, ${k}'b0} >= wt_required_bytes) & ~(|wt_fetched_cnt[${k}-1:0]); // wt_fetched_cnt[0] means a complete entry 
//:         assign wmb_satisfied = is_running & ({{{1{1'b0}}, wmb_fetched_cnt}, ${k}'d0, ${m}'b0} >= wmb_required_bits) & ~(|wmb_fetched_cnt[${k}-1:0]);// wmb_fetched_cnt[0] 
//:     );
//: } else {
//:     print qq(
//:         assign wt_satisfied = is_running & ({wt_fetched_cnt, ${k}'b0} >= wt_required_bytes);
//:         assign wmb_satisfied = is_running & ({{{1{1'b0}}, wmb_fetched_cnt}, ${k}'d0, ${m}'b0} >= wmb_required_bits);
//:     );
//: }
assign status_update = (~required_valid) ? 1'b0 :
                       (~is_compressed) ? wt_satisfied : wt_satisfied & wmb_satisfied;
assign status_update_wmb = (~required_valid) ? 1'b0 :
                           (~is_compressed) ? 1'b0 : wt_satisfied & wmb_satisfied;
#else
//: my $m = int(log(NVDLA_BPE)/log(2)); 
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/8; ##byte number per dmaif tx
//: my $k = int(log($dmaif)/log(2));
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE * NVDLA_CDMA_BPE;
//: my $dmaifbw=NVDLA_CDMA_DMAIF_BW;
//: if($atmc > $dmaifbw) {
//:     my $k = int( log( ${atmc}/${dmaifbw} )/log(2) );
//:     print qq(
//:         assign wt_satisfied = is_running & ({wt_fetched_cnt, ${k}'b0} >= wt_required_bytes) & ~(|wt_fetched_cnt[${k}-1:0]); // wt_fetched_cnt[0]
//:     );
//: } else {
//:     print qq(
//:         assign wt_satisfied = is_running & ({wt_fetched_cnt, ${k}'b0} >= wt_required_bytes); // wt_fetched_cnt[0]
//:     );
//: }

//assign wt_satisfied = is_running & ({wt_fetched_cnt, 6'b0} >= wt_required_bytes) & ~wt_fetched_cnt[0];
assign status_update = (~required_valid) ? 1'b0 : wt_satisfied;
#endif

//: &eperl::flop("-nodeclare   -rval \"{12{1'b0}}\"  -en \"layer_st | status_update\" -d \"status_group_cnt_w\" -q status_group_cnt");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st | status_update\" -d \"status_done_w\" -q status_done");
//: &eperl::flop("-nodeclare   -rval \"{32{1'b0}}\"  -en \"layer_st | status_update\" -d \"pre_wt_required_bytes_w\" -q pre_wt_required_bytes");
//: &eperl::flop("-nodeclare   -rval \"{26{1'b0}}\"  -en \"layer_st | wt_cbuf_wr_vld_w\" -d \"wt_fetched_cnt_w\" -q wt_fetched_cnt");
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
//: &eperl::flop("-nodeclare   -rval \"{32{1'b0}}\"  -en \"layer_st | status_update\" -d \"pre_wmb_required_bits_w\" -q pre_wmb_required_bits");
//: &eperl::flop("-nodeclare   -rval \"{22{1'b0}}\"  -en \"layer_st | wmb_cbuf_wr_vld_w\" -d \"wmb_fetched_cnt_w\" -q wmb_fetched_cnt");
#endif


////////////////////////////////////////////////////////////////////////
//  avaliable kernels monitor                                         //
////////////////////////////////////////////////////////////////////////
// Avaliable kernel size is useless here. Discard the code;

////////////////////////////////////////////////////////////////////////
//  CDMA WT communicate to CSC                                        //
////////////////////////////////////////////////////////////////////////
assign pre_wt_fetched_cnt_w = status_last_group ? 26'b0 : wt_fetched_cnt;
assign {mon_incr_wt_cnt, incr_wt_cnt} = wt_fetched_cnt[12 :0] - pre_wt_fetched_cnt[12 :0];

// dmaif vs atom_c
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE;
//: if($dmaif == $atmc){
//:     print qq(
//:         assign incr_wt_entries_w = {2'd0,incr_wt_cnt[12:0]};
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log($dmaif/$atmc)/log(2));
//:     print qq(
//:         assign incr_wt_entries_w = {incr_wt_cnt[12:0],{${k}{1'b0}}};
//:     );
//: } elsif($dmaif < $atmc) {
//:     my $k = int(log($atmc/$dmaif)/log(2));
//:     print qq(
//:         assign incr_wt_entries_w = {{(2+${k}){1'b0}},incr_wt_cnt[12:${k}]};
//:     );
//: }

//assign incr_wt_entries_w = incr_wt_cnt[12 :1];
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
assign pre_wmb_fetched_cnt_w = status_last_group ? 22'b0 : wmb_fetched_cnt;
assign {mon_incr_wmb_cnt, incr_wmb_cnt} = wmb_fetched_cnt[8 +1:0] - pre_wmb_fetched_cnt[8 +1:0];
// dmaif vs atom_c
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE;
//: if($dmaif == $atmc){
//:     print qq(
//:         assign incr_wmb_entries_w = {2'd0,incr_wmb_cnt[8 +1:0]};
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log($dmaif/$atmc)/log(2));
//:     print qq(
//:         assign incr_wmb_entries_w = {incr_wmb_cnt[8 +1:0],{${k}{1'b0}}};
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log($atmc/$dmaif)/log(2));
//:     print qq(
//:         assign incr_wmb_entries_w = {{(2+${k}){1'b0}},incr_wmb_cnt[8 +1:0]};
//:     );
//: }

//assign incr_wmb_entries_w = incr_wmb_cnt[8 +1:1];
#endif
//: my $atmk = NVDLA_MAC_ATOMIC_K_SIZE;
//: my $atmkbw = int(log($atmk)/log(2));
//: print qq(
//: assign incr_wt_kernels_w = (~status_last_group) ? 6'd${atmk} : (reg2dp_weight_kernel[${atmkbw}-1:0] + 1'b1);
//: );

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"status_update\" -q incr_wt_updt");
//: &eperl::flop("-nodeclare   -rval \"{26{1'b0}}\"  -en \"status_update\" -d \"pre_wt_fetched_cnt_w\" -q pre_wt_fetched_cnt");
//: &eperl::flop("-nodeclare   -rval \"{15{1'b0}}\"  -en \"status_update\" -d \"incr_wt_entries_w\" -q incr_wt_entries");
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
//: &eperl::flop("-nodeclare   -rval \"{22{1'b0}}\"  -en \"status_update\" -d \"pre_wmb_fetched_cnt_w\" -q pre_wmb_fetched_cnt");
//: &eperl::flop("-nodeclare   -rval \"{12{1'b0}}\"  -en \"status_update\" -d \"incr_wmb_entries_w\" -q incr_wmb_entries");
#endif
//: &eperl::flop("-nodeclare   -rval \"{6{1'b0}}\"  -en \"status_update\" -d \"incr_wt_kernels_w\" -q incr_wt_kernels");

//: my $i;
//: my $j;
//: my $k;
//: my $name;
//: my $wid;
//: my $cbuf_wr_delay = CDMA_CBUF_WR_LATENCY;
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
//: my @list = ("wt_kernels", "wt_entries", "wmb_entries");
//: my @width = (6, 15, 12);
#else
//: my @list = ("wt_kernels", "wt_entries");
//: my @width = (6, 15);
#endif
//: 
//: for($i = 0; $i < @list; $i ++) {
//:     $name = $list[$i];
//:     print "assign incr_${name}_d0 = incr_${name};\n";
//: }
//: print "assign incr_wt_updt_d0 = incr_wt_updt;\n";
//: print "\n\n";
//: 
//: for($j = 1; $j <= $cbuf_wr_delay; $j ++) {
//:     $k = $j - 1;
//:     for($i = 0; $i < @list; $i ++) {
//:         $name = $list[$i];
//:         $wid = $width[$i];
//:         &eperl::flop("-wid ${wid}   -rval \"'b0\"  -en \"incr_wt_updt_d${k}\" -d \"incr_${name}_d${k}\" -q incr_${name}_d${j}");
//:     }
//:     &eperl::flop("-wid 1   -rval \"1'b0\"   -d \"incr_wt_updt_d${k}\" -q incr_wt_updt_d${j}");
//: }
//: print "\n\n";
//: 
//: $j = $cbuf_wr_delay;
//: print "assign cdma2sc_wt_kernels[5:0] = incr_wt_kernels_d${j};\n";
//: print "assign cdma2sc_wt_entries = incr_wt_entries_d${j};\n";
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
//: print "assign cdma2sc_wmb_entries = incr_wmb_entries_d${j};\n";
#else
//: print "assign cdma2sc_wmb_entries = 12'b0;  \n";
#endif
//: print "assign cdma2sc_wt_updt = incr_wt_updt_d${j};\n";
assign cdma2sc_wt_kernels[13:6] = 8'b0;

`ifndef SYNTHESIS
assign dbg_wt_kernel_bytes_w[31:0] = layer_st ? 32'b0 : wt_required_bytes_w - wt_required_bytes;
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
assign dbg_wmb_kernel_bits_sub[31:0] = wmb_required_bits_w - wmb_required_bits;
assign dbg_wmb_kernel_bits_w[31:0] = layer_st ? 32'b0 : 
                                     ((dbg_wmb_kernel_bits_sub > dbg_wmb_kernel_bits) && (dbg_wmb_kernel_bits != 0)) ? dbg_wmb_kernel_bits : dbg_wmb_kernel_bits_sub;
assign dbg_full_wmb = (reg2dp_wmb_bytes <= 9'h100);//9'h100
#endif
//assign dbg_full_weight = (reg2dp_weight_bytes <= {weight_bank, 8'h0});
assign dbg_full_weight = (reg2dp_weight_bytes <= {weight_bank, 9'h0});

//: &eperl::flop("-nodeclare   -rval \"{32{1'b0}}\"  -en \"layer_st |  wt_required_en\" -d \"dbg_wt_kernel_bytes_w\" -q dbg_wt_kernel_bytes");
#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
//: &eperl::flop("-nodeclare   -rval \"{32{1'b0}}\"  -en \"layer_st | wmb_required_en\" -d \"dbg_wmb_kernel_bits_w\" -q dbg_wmb_kernel_bits");
#endif
`endif


////////////////////////////////////////////////////////////////////////
//  performance counting register                                     //
////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        wt_rd_stall_inc <= 1'b0;
    end else begin
        wt_rd_stall_inc <= dma_rd_req_vld & ~dma_rd_req_rdy & reg2dp_dma_en;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        wt_rd_stall_clr <= 1'b0;
    end else begin
        wt_rd_stall_clr <= status2dma_fsm_switch & reg2dp_dma_en;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        wt_rd_stall_cen <= 1'b0;
    end else begin
        wt_rd_stall_cen <= reg2dp_op_en & reg2dp_dma_en;
    end
end

assign dp2reg_wt_rd_stall_dec = 1'b0;

// stl adv logic

always @(*) begin
    stl_adv = wt_rd_stall_inc ^ dp2reg_wt_rd_stall_dec;
end
    
// stl cnt logic
always @(*) begin
    // VCS sop_coverage_off start
    stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
    stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
    stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
    stl_cnt_mod[33:0] = (wt_rd_stall_inc && !dp2reg_wt_rd_stall_dec)? stl_cnt_inc : (!wt_rd_stall_inc && dp2reg_wt_rd_stall_dec)? stl_cnt_dec : stl_cnt_ext;
    stl_cnt_new[33:0] = (stl_adv)? stl_cnt_mod[33:0] : stl_cnt_ext[33:0];
    stl_cnt_nxt[33:0] = (wt_rd_stall_clr)? 34'd0 : stl_cnt_new[33:0];
    // VCS sop_coverage_off end
end

// stl flops

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        stl_cnt_cur[31:0] <= 0;
    end else begin
        if (wt_rd_stall_cen) begin
            stl_cnt_cur[31:0] <= stl_cnt_nxt[31:0];
        end
    end
end

// stl output logic

always @(*) begin
    dp2reg_wt_rd_stall[31:0] = stl_cnt_cur[31:0];
end
        
      

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        wt_rd_latency_inc <= 1'b0;
    end else begin
        wt_rd_latency_inc <= dma_rd_req_vld & dma_rd_req_rdy & reg2dp_dma_en;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        wt_rd_latency_dec <= 1'b0;
    end else begin
        wt_rd_latency_dec <= dma_rsp_fifo_ready & reg2dp_dma_en;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        wt_rd_latency_clr <= 1'b0;
    end else begin
        wt_rd_latency_clr <= status2dma_fsm_switch;
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        wt_rd_latency_cen <= 1'b0;
    end else begin
        wt_rd_latency_cen <= reg2dp_op_en & reg2dp_dma_en;
    end
end




// 
assign ltc_1_inc = (outs_dp2reg_wt_rd_latency!=511) & wt_rd_latency_inc;
assign ltc_1_dec = (outs_dp2reg_wt_rd_latency!=511) & wt_rd_latency_dec;

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
    ltc_1_cnt_nxt[10:0] = (wt_rd_latency_clr)? 11'd0 : ltc_1_cnt_new[10:0];
    // VCS sop_coverage_off end
end

// ltc_1 flops

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        ltc_1_cnt_cur[8:0] <= 0;
    end else begin
        if (wt_rd_latency_cen) begin
            ltc_1_cnt_cur[8:0] <= ltc_1_cnt_nxt[8:0];
        end
    end
end

// ltc_1 output logic
always @(*) begin
    outs_dp2reg_wt_rd_latency[8:0] = ltc_1_cnt_cur[8:0];
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

    property cdma_wt__cbuf_idx_wrap__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wt_cbuf_wr_idx_set | clear_all | wt_cbuf_wr_vld_w) & wt_cbuf_wr_idx_wrap);
    endproperty
    // Cover 0 : "((wt_cbuf_wr_idx_set | clear_all | wt_cbuf_wr_vld_w) & wt_cbuf_wr_idx_wrap)"
    FUNCPOINT_cdma_wt__cbuf_idx_wrap__0_COV : cover property (cdma_wt__cbuf_idx_wrap__0_cov);

  `endif
`endif
//VCS coverage on

#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cdma_wt__wt_satisfy_when_wmb_not__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (is_compressed & wt_satisfied & ~wmb_satisfied);
    endproperty
    // Cover 1 : "(is_compressed & wt_satisfied & ~wmb_satisfied)"
    FUNCPOINT_cdma_wt__wt_satisfy_when_wmb_not__1_COV : cover property (cdma_wt__wt_satisfy_when_wmb_not__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cdma_wt__wrr_wt_ahead_wmb__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (arb_wrr_in_vld[0] & arb_wrr_in_vld[1] & ~arb_wrr_in_rdy[0] & arb_wrr_in_rdy[1]);
    endproperty
    // Cover 2 : "(arb_wrr_in_vld[0] & arb_wrr_in_vld[1] & ~arb_wrr_in_rdy[0] & arb_wrr_in_rdy[1])"
    FUNCPOINT_cdma_wt__wrr_wt_ahead_wmb__2_COV : cover property (cdma_wt__wrr_wt_ahead_wmb__2_cov);

  `endif
`endif
//VCS coverage on
#endif


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

#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_35x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_40x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_62x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_63x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(clear_all | wmb_cbuf_wr_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_85x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(wmb_data_onfly_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_86x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(wmb_cbuf_wr_vld_w | status_update_wmb))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_87x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(status_update_wmb | sc_wt_updt | clear_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_96x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wmb_required_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_102x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wmb_cbuf_wr_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_120x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wmb_required_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_48x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wgs_req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_64x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wgs_push_req))); // spyglass disable W504 SelfDeterminedExpr-ML 
#endif
  nv_assert_no_x #(0,2,0,"No Xs allowed on cur_state")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1, cur_state); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | is_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbg_src_wr_ptr_en & ~dbg_src_wr_ptr))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_54x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbg_src_wr_ptr_en & dbg_src_wr_ptr))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_55x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dma_rd_rsp_vld & dma_rd_rsp_rdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_60x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_61x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_cbuf_wr_idx_set | clear_all | wt_cbuf_wr_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_66x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(wt_cbuf_flush_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_67x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cdma2buf_wt_wr_en_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_68x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cdma2buf_wt_wr_en_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_69x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cdma2buf_wt_wr_en_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_73x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(nan_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_74x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(inf_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_75x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(sc2cdma_wt_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_76x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(sc2cdma_wt_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_77x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(wt_data_onfly_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_78x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(wt_cbuf_wr_vld_w | status_update))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_79x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(status_update | sc_wt_updt | clear_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_93x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wgs_data_onfly_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_95x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wt_required_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_97x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | status_update))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_101x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wt_cbuf_wr_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_105x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(status_update))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_110x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(incr_wt_updt_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_113x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(incr_wt_updt_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_116x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(incr_wt_updt_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 

#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
  nv_assert_never #(0,0,"Config error! wmb bytes is not match the require size!")      zzz_assert_never_10x (nvdla_core_clk, `ASSERT_RESET, (layer_st_d1 & is_compressed & (reg2dp_wmb_bytes != (((byte_per_kernel * (reg2dp_weight_kernel + 1) / (reg2dp_proc_precision == 2'b0 ? 1 : 2)) + 1023)/1024)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error!, wmb_req_burst_cnt_dec is overflow!")      zzz_assert_never_34x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wmb_req_burst_cnt_dec)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! FSM done when wmb fetch is not!")      zzz_assert_never_44x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~is_nxt_running & ~wmb_req_done_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wmb_req_sum is overflow!")      zzz_assert_never_45x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & mon_wmb_req_sum)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wmb_data_onfly is not zero when idle")      zzz_assert_never_46x (nvdla_core_clk, `ASSERT_RESET, (~is_running & (|wmb_data_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wmb_data_onfly is not zero when idle")      zzz_assert_never_47x (nvdla_core_clk, `ASSERT_RESET, (~is_running & (|wmb_data_stored))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"WT and WMB write hazard")      zzz_assert_never_70x (nvdla_core_clk, `ASSERT_RESET, (wt_cbuf_wr_vld_w & wmb_cbuf_wr_vld_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"WMB and FLUSH write hazard")      zzz_assert_never_72x (nvdla_core_clk, `ASSERT_RESET, (wt_cbuf_flush_vld_w & wmb_cbuf_wr_vld_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wmb_data_onfly_w is overflow")      zzz_assert_never_88x (nvdla_core_ng_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wmb_data_onfly_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wmb_data_stored_w is overflow")      zzz_assert_never_89x (nvdla_core_ng_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wmb_data_stored_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wmb_data_onfly is not zero when idle")      zzz_assert_never_90x (nvdla_core_ng_clk, `ASSERT_RESET, (~is_running & (|wmb_data_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wmb_data_stored is not zero when idle")      zzz_assert_never_91x (nvdla_core_ng_clk, `ASSERT_RESET, (~is_running & (|wmb_data_stored))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wmb_data_avl_w is overflow")      zzz_assert_never_92x (nvdla_core_ng_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wmb_data_avl_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wmb_fetched_cnt_w is overflow")      zzz_assert_never_104x (nvdla_core_clk, `ASSERT_RESET, ((layer_st | wmb_cbuf_wr_vld_w) & mon_wmb_fetched_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wgs_data_onfly is not zero when idle")      zzz_assert_never_51x (nvdla_core_clk, `ASSERT_RESET, (~is_running & (|wgs_data_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"WGS FIFO overflow")      zzz_assert_never_65x (nvdla_core_clk, `ASSERT_RESET, (wgs_push_req & ~wgs_push_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wgs_data_onfly_w is overflow")      zzz_assert_never_94x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wgs_data_onfly_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Config error! Run out of weight buffer: compressed weight!")      zzz_assert_never_122x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~reg2dp_skip_weight_rls & ~dbg_full_weight & is_compressed & ~status_done & wgs_pop_req & ((wgs_pop_data + 128) > {weight_bank, 15'b0}))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Config error! Run out of weight buffer: WMB!")      zzz_assert_never_123x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~reg2dp_skip_weight_rls & ~dbg_full_wmb & is_compressed & ~status_done & (dbg_wmb_kernel_bits > 32'h3fc00))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Config error! Run out of weight buffer: full WMB!")      zzz_assert_never_125x (nvdla_core_clk, `ASSERT_RESET, (is_running & reg2dp_skip_weight_rls & is_compressed & ~dbg_full_wmb)); // spyglass disable W504 SelfDeterminedExpr-ML 
#endif
//  nv_assert_never #(0,0,"Config error! Data banks is more than 15!")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && (reg2dp_data_bank == 4'hf))); // spyglass disable W504 SelfDeterminedExpr-ML 
//  nv_assert_never #(0,0,"Config error! Weight banks is more than 15!")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && (reg2dp_weight_bank == 4'hf))); // spyglass disable W504 SelfDeterminedExpr-ML 
//  nv_assert_never #(0,0,"Config error! Sum of data & weight banks is more than 16 when weight uncompressed")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && ~is_compressed && (weight_bank_end_w > 16))); // spyglass disable W504 SelfDeterminedExpr-ML 
//  nv_assert_never #(0,0,"Config error! Sum of data & weight banks is more than 15 when weight compressed!")      zzz_assert_never_9x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && is_compressed && (weight_bank_end_w > 15))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wt_req_burst_cnt_dec is overflow")      zzz_assert_never_19x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wt_req_burst_cnt_dec)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! FSM done when wt fetch is not!")      zzz_assert_never_29x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~is_nxt_running & ~wt_req_done_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wt_data_onfly is not zero when idle")      zzz_assert_never_30x (nvdla_core_clk, `ASSERT_RESET, (~is_running && (|wt_data_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wt_data_stored is not zero when idle")      zzz_assert_never_31x (nvdla_core_clk, `ASSERT_RESET, (~is_running && (|wt_data_stored))); // spyglass disable W504 SelfDeterminedExpr-ML 
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
//  nv_assert_never #(0,0,"DMAIF: mcif and cvif should never return data both")      zzz_assert_never_52x (nvdla_core_clk, `ASSERT_RESET, mc_dma_rd_rsp_vld & cv_dma_rd_rsp_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
  #endif
  nv_assert_never #(0,0,"response fifo pop error")      zzz_assert_never_56x (nvdla_core_clk, `ASSERT_RESET, (dma_rsp_fifo_ready & ~dma_rsp_fifo_req)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"response size mismatch")      zzz_assert_never_57x (nvdla_core_clk, `ASSERT_RESET, (dma_rd_rsp_vld & dma_rd_rsp_rdy & (dma_rsp_size_cnt_inc > dma_rsp_size))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! dma_rsp_size_cnt_inc is overflow")      zzz_assert_never_58x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & mon_dma_rsp_size_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! dma_rsp_size_cnt_inc is out of range")      zzz_assert_never_59x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (dma_rsp_size_cnt_inc > 8'h8))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"WT and FLUSH write hazard")      zzz_assert_never_71x (nvdla_core_clk, `ASSERT_RESET, (wt_cbuf_wr_vld_w & wt_cbuf_flush_vld_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wt_data_onfly_w is overflow")      zzz_assert_never_80x (nvdla_core_ng_clk, `ASSERT_RESET, (reg2dp_op_en & mon_wt_data_onfly_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wt_data_stored_w is overflow")      zzz_assert_never_81x (nvdla_core_ng_clk, `ASSERT_RESET, (reg2dp_op_en & mon_wt_data_stored_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wt_data_onfly is not zero when idle")      zzz_assert_never_82x (nvdla_core_ng_clk, `ASSERT_RESET, (~is_running & (|wt_data_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wt_data_stored is not zero when idle")      zzz_assert_never_83x (nvdla_core_ng_clk, `ASSERT_RESET, (~is_running & (|wt_data_stored))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wt_data_avl_w is overflow")      zzz_assert_never_84x (nvdla_core_ng_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wt_data_avl_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! wt_fetched_cnt_w is overflow")      zzz_assert_never_103x (nvdla_core_clk, `ASSERT_RESET, ((layer_st | wt_cbuf_wr_vld_w) & mon_wt_fetched_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Config error! Run out of weight buffer: uncompressed weight!")      zzz_assert_never_121x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~reg2dp_skip_weight_rls & ~dbg_full_weight & ~is_compressed & ~status_done & ((dbg_wt_kernel_bytes + 128) > {weight_bank, 15'b0}))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Config error! Run out of weight buffer: full weight!")      zzz_assert_never_124x (nvdla_core_clk, `ASSERT_RESET, (is_running & reg2dp_skip_weight_rls & ~dbg_full_weight)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Weight output update with zero kernels")      zzz_assert_never_126x (nvdla_core_clk, `ASSERT_RESET, (cdma2sc_wt_updt & ~(|cdma2sc_wt_kernels))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"never: counter overflow beyond <ovr_cnt>")      zzz_assert_never_127x (nvdla_core_clk, `ASSERT_RESET, (ltc_1_cnt_nxt > 511 && wt_rd_latency_cen)); // spyglass disable W504 SelfDeterminedExpr-ML 

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

endmodule // NV_NVDLA_CDMA_wt

