// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_wt.v

module NV_NVDLA_CDMA_wt (
   nvdla_core_clk            //|< i
  ,nvdla_core_ng_clk         //|< i
  ,nvdla_core_rstn           //|< i
  ,cdma_wt2cvif_rd_req_ready //|< i
  ,cdma_wt2mcif_rd_req_ready //|< i
  ,cvif2cdma_wt_rd_rsp_pd    //|< i
  ,cvif2cdma_wt_rd_rsp_valid //|< i
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
  ,cdma2buf_wt_wr_addr       //|> o
  ,cdma2buf_wt_wr_data       //|> o
  ,cdma2buf_wt_wr_en         //|> o
  ,cdma2buf_wt_wr_hsel       //|> o
  ,cdma2sc_wmb_entries       //|> o
  ,cdma2sc_wt_entries        //|> o
  ,cdma2sc_wt_kernels        //|> o
  ,cdma2sc_wt_pending_ack    //|> o
  ,cdma2sc_wt_updt           //|> o
  ,cdma_wt2cvif_rd_req_pd    //|> o
  ,cdma_wt2cvif_rd_req_valid //|> o
  ,cdma_wt2mcif_rd_req_pd    //|> o
  ,cdma_wt2mcif_rd_req_valid //|> o
  ,cvif2cdma_wt_rd_rsp_ready //|> o
  ,dp2reg_inf_weight_num     //|> o
  ,dp2reg_nan_weight_num     //|> o
  ,dp2reg_wt_flush_done      //|> o
  ,dp2reg_wt_rd_latency      //|> o
  ,dp2reg_wt_rd_stall        //|> o
  ,mcif2cdma_wt_rd_rsp_ready //|> o
  ,wt2status_state           //|> o
  );


//
// NV_NVDLA_CDMA_wt_ports.v
//
input  nvdla_core_clk;   /* cdma_wt2mcif_rd_req, cdma_wt2cvif_rd_req, mcif2cdma_wt_rd_rsp, cvif2cdma_wt_rd_rsp, cdma2buf_wt_wr, switch_status2dma, state_wt2status, wt_up_cdma2sc, wt_up_sc2cdma, sc2cdma_wt_pending, cdma2sc_wt_pending */
input  nvdla_core_rstn;  /* cdma_wt2mcif_rd_req, cdma_wt2cvif_rd_req, mcif2cdma_wt_rd_rsp, cvif2cdma_wt_rd_rsp, cdma2buf_wt_wr, switch_status2dma, state_wt2status, wt_up_cdma2sc, wt_up_sc2cdma, sc2cdma_wt_pending, cdma2sc_wt_pending */

input [31:0] pwrbus_ram_pd;

output        cdma_wt2mcif_rd_req_valid;  /* data valid */
input         cdma_wt2mcif_rd_req_ready;  /* data return handshake */
output [78:0] cdma_wt2mcif_rd_req_pd;

output        cdma_wt2cvif_rd_req_valid;  /* data valid */
input         cdma_wt2cvif_rd_req_ready;  /* data return handshake */
output [78:0] cdma_wt2cvif_rd_req_pd;

input          mcif2cdma_wt_rd_rsp_valid;  /* data valid */
output         mcif2cdma_wt_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2cdma_wt_rd_rsp_pd;

input          cvif2cdma_wt_rd_rsp_valid;  /* data valid */
output         cvif2cdma_wt_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2cdma_wt_rd_rsp_pd;

output         cdma2buf_wt_wr_en;    /* data valid */
output  [11:0] cdma2buf_wt_wr_addr;
output         cdma2buf_wt_wr_hsel;
output [511:0] cdma2buf_wt_wr_data;

input  status2dma_fsm_switch;

output [1:0] wt2status_state;

output        cdma2sc_wt_updt;      /* data valid */
output [13:0] cdma2sc_wt_kernels;
output [11:0] cdma2sc_wt_entries;
output  [8:0] cdma2sc_wmb_entries;

input        sc2cdma_wt_updt;      /* data valid */
input [13:0] sc2cdma_wt_kernels;
input [11:0] sc2cdma_wt_entries;
input  [8:0] sc2cdma_wmb_entries;

input  sc2cdma_wt_pending_req;

output  cdma2sc_wt_pending_ack;

input nvdla_core_ng_clk;

input [3:0]                  reg2dp_arb_weight;
input [3:0]                     reg2dp_arb_wmb;
input [0:0]                     reg2dp_op_en;
input [1:0]             reg2dp_proc_precision;
input [0:0]               reg2dp_weight_reuse;
input [0:0]            reg2dp_skip_weight_rls;
input [0:0]         reg2dp_weight_format;
input [17:0]       reg2dp_byte_per_kernel;
input [12:0]         reg2dp_weight_kernel;
input [0:0]     reg2dp_weight_ram_type;
input [31:0]   reg2dp_weight_addr_high;
input [26:0]     reg2dp_weight_addr_low;
input [24:0]           reg2dp_weight_bytes;
input [31:0]         reg2dp_wgs_addr_high;
input [26:0]           reg2dp_wgs_addr_low;
input [31:0]         reg2dp_wmb_addr_high;
input [26:0]           reg2dp_wmb_addr_low;
input [20:0]                 reg2dp_wmb_bytes;
input [3:0]                      reg2dp_data_bank;
input [3:0]                    reg2dp_weight_bank;
input [0:0]       reg2dp_nan_to_zero;
input [0:0]                  reg2dp_dma_en;

output [31:0]    dp2reg_nan_weight_num;
output [31:0]    dp2reg_inf_weight_num;
output                                                                  dp2reg_wt_flush_done;
output [31:0]         dp2reg_wt_rd_stall;
output [31:0]     dp2reg_wt_rd_latency;

wire           arb_sp_block;
wire     [1:0] arb_sp_in_rdy;
wire     [1:0] arb_sp_in_vld;
wire    [67:0] arb_sp_req_package_in_00;
wire    [67:0] arb_sp_req_package_in_01;
wire           arb_wrr_block;
wire     [1:0] arb_wrr_in_rdy;
wire     [1:0] arb_wrr_in_vld;
wire           arb_wrr_out_rdy;
wire    [67:0] arb_wrr_req_package_in_00;
wire    [67:0] arb_wrr_req_package_in_01;
wire     [4:0] arb_wrr_weight_0;
wire     [4:0] arb_wrr_weight_1;
wire           cv_dma_rd_req_rdy;
wire           cv_dma_rd_req_vld;
wire   [513:0] cv_dma_rd_rsp_pd;
wire           cv_dma_rd_rsp_vld;
wire    [78:0] cv_int_rd_req_pd;
wire    [78:0] cv_int_rd_req_pd_d0;
wire           cv_int_rd_req_ready;
wire           cv_int_rd_req_ready_d0;
wire           cv_int_rd_req_valid;
wire           cv_int_rd_req_valid_d0;
wire   [513:0] cv_int_rd_rsp_pd;
wire           cv_int_rd_rsp_ready;
wire           cv_int_rd_rsp_valid;
wire           cv_rd_req_rdyi;
wire   [513:0] cvif2cdma_wt_rd_rsp_pd_d0;
wire           cvif2cdma_wt_rd_rsp_ready_d0;
wire           cvif2cdma_wt_rd_rsp_valid_d0;
wire     [1:0] dbg_dma_req_src;
wire           dbg_full_weight;
wire           dbg_full_wmb;
wire           dbg_src_rd_ptr_en;
wire           dbg_src_rd_ptr_w;
wire           dbg_src_wr_ptr_en;
wire           dbg_src_wr_ptr_w;
wire    [31:0] dbg_wmb_kernel_bits_sub;
wire    [31:0] dbg_wmb_kernel_bits_w;
wire    [31:0] dbg_wt_kernel_bytes_w;
wire    [63:0] dma_rd_req_addr;
wire    [78:0] dma_rd_req_pd;
wire           dma_rd_req_rdy;
wire    [14:0] dma_rd_req_size;
wire           dma_rd_req_type;
wire           dma_rd_req_vld;
wire   [511:0] dma_rd_rsp_data;
wire     [1:0] dma_rd_rsp_mask;
wire   [513:0] dma_rd_rsp_pd;
wire           dma_rd_rsp_rdy;
wire           dma_rd_rsp_vld;
wire           dma_req_fifo_ready;
wire     [5:0] dma_rsp_fifo_data;
wire           dma_rsp_fifo_req;
wire           dp2reg_wt_rd_stall_dec;
wire     [8:0] incr_wmb_entries_d0;
wire    [11:0] incr_wt_entries_d0;
wire     [5:0] incr_wt_kernels_d0;
wire           incr_wt_updt_d0;
wire           ltc_1_dec;
wire           ltc_1_inc;
wire           ltc_2_dec;
wire           ltc_2_inc;
wire           mc_dma_rd_req_rdy;
wire           mc_dma_rd_req_vld;
wire   [513:0] mc_dma_rd_rsp_pd;
wire           mc_dma_rd_rsp_vld;
wire    [78:0] mc_int_rd_req_pd;
wire    [78:0] mc_int_rd_req_pd_d0;
wire           mc_int_rd_req_ready;
wire           mc_int_rd_req_ready_d0;
wire           mc_int_rd_req_valid;
wire           mc_int_rd_req_valid_d0;
wire   [513:0] mc_int_rd_rsp_pd;
wire           mc_int_rd_rsp_ready;
wire           mc_int_rd_rsp_valid;
wire           mc_rd_req_rdyi;
wire   [513:0] mcif2cdma_wt_rd_rsp_pd_d0;
wire           mcif2cdma_wt_rd_rsp_ready_d0;
wire           mcif2cdma_wt_rd_rsp_valid_d0;
wire           pending_req_end;
wire           rd_req_rdyi;
wire    [31:0] wgs_pop_data;
wire           wgs_pop_req;
wire           wgs_push_ready;
wire           wgs_req_rdy;
wire     [3:0] wgs_req_size_d1;
wire     [2:0] wgs_req_size_out_d1;
wire     [1:0] wgs_req_src_d1;
wire           wmb_req_overflow_d3;
wire           wmb_req_rdy;
wire           wmb_req_reg_en_d0;
wire           wmb_req_reg_en_d1;
wire           wmb_req_reg_en_d2;
wire     [1:0] wmb_req_src_d3;
wire           wt_req_overflow_d3;
wire           wt_req_rdy;
wire           wt_req_reg_en_d0;
wire           wt_req_reg_en_d1;
wire           wt_req_reg_en_d2;
wire     [1:0] wt_req_src_d3;
reg     [67:0] arb_sp_out_back_package;
reg            arb_sp_out_back_reg_en;
reg            arb_sp_out_back_vld;
reg            arb_sp_out_back_vld_w;
reg     [67:0] arb_sp_out_package;
reg     [67:0] arb_sp_out_package_w;
reg            arb_sp_out_rdy;
reg            arb_sp_out_reg_en;
reg            arb_sp_out_vld;
reg            arb_sp_out_vld_w;
reg      [4:0] arb_weight_wmb;
reg      [4:0] arb_weight_wt;
reg     [67:0] arb_wrr_out_back_package;
reg            arb_wrr_out_back_reg_en;
reg            arb_wrr_out_back_vld;
reg            arb_wrr_out_back_vld_w;
reg     [67:0] arb_wrr_out_package;
reg     [67:0] arb_wrr_out_package_w;
reg            arb_wrr_out_reg_en;
reg            arb_wrr_out_vld;
reg            arb_wrr_out_vld_w;
reg     [18:0] byte_per_kernel;
reg     [11:0] cdma2buf_wt_wr_addr;
reg     [11:0] cdma2buf_wt_wr_addr_w;
reg    [511:0] cdma2buf_wt_wr_data;
reg    [511:0] cdma2buf_wt_wr_data_w;
reg            cdma2buf_wt_wr_en;
reg            cdma2buf_wt_wr_en_w;
reg            cdma2buf_wt_wr_hsel;
reg            cdma2buf_wt_wr_hsel_w;
reg            clear_all;
reg      [1:0] cur_state;
reg      [3:0] data_bank_w;
reg      [1:0] dbg_dma_req_src_b0;
reg      [1:0] dbg_dma_req_src_b1;
reg            dbg_src_rd_ptr;
reg            dbg_src_wr_ptr;
reg     [31:0] dbg_wmb_kernel_bits;
reg     [31:0] dbg_wt_kernel_bytes;
reg     [58:0] dma_req_addr;
reg      [5:0] dma_req_fifo_data;
reg            dma_req_fifo_req;
reg      [3:0] dma_req_size;
reg      [2:0] dma_req_size_out;
reg      [1:0] dma_req_src;
reg    [255:0] dma_rsp_data_p0;
reg    [255:0] dma_rsp_data_p1;
reg            dma_rsp_fifo_ready;
reg      [3:0] dma_rsp_size;
reg      [3:0] dma_rsp_size_cnt;
reg      [3:0] dma_rsp_size_cnt_inc;
reg      [3:0] dma_rsp_size_cnt_w;
reg      [1:0] dma_rsp_src;
reg     [31:0] dp2reg_inf_weight_num;
reg     [31:0] dp2reg_inf_weight_num_inc;
reg     [31:0] dp2reg_inf_weight_num_w;
reg     [31:0] dp2reg_nan_weight_num;
reg     [31:0] dp2reg_nan_weight_num_inc;
reg     [31:0] dp2reg_nan_weight_num_w;
reg     [31:0] dp2reg_wt_rd_latency;
reg     [31:0] dp2reg_wt_rd_stall;
reg            fetch_done;
reg      [9:0] group;
reg      [9:0] group_op;
reg      [9:0] group_w;
reg      [9:0] incr_wmb_cnt;
reg      [8:0] incr_wmb_entries;
reg      [8:0] incr_wmb_entries_d1;
reg      [8:0] incr_wmb_entries_d2;
reg      [8:0] incr_wmb_entries_d3;
reg      [8:0] incr_wmb_entries_w;
reg     [12:0] incr_wt_cnt;
reg     [11:0] incr_wt_entries;
reg     [11:0] incr_wt_entries_d1;
reg     [11:0] incr_wt_entries_d2;
reg     [11:0] incr_wt_entries_d3;
reg     [11:0] incr_wt_entries_w;
reg      [5:0] incr_wt_kernels;
reg      [5:0] incr_wt_kernels_d1;
reg      [5:0] incr_wt_kernels_d2;
reg      [5:0] incr_wt_kernels_d3;
reg      [5:0] incr_wt_kernels_w;
reg            incr_wt_updt;
reg            incr_wt_updt_d1;
reg            incr_wt_updt_d2;
reg            incr_wt_updt_d3;
reg            inf_carry;
reg            inf_reg_en;
reg            is_compressed;
reg            is_fp16;
reg            is_int8;
reg            is_nxt_running;
reg            is_pending;
reg            is_running;
reg      [3:0] last_data_bank;
reg            last_skip_weight_rls;
reg      [3:0] last_weight_bank;
reg            layer_end;
reg            layer_st;
reg            layer_st_d1;
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
reg            mon_dma_rsp_size_cnt_inc;
reg            mon_incr_wmb_cnt;
reg            mon_incr_wt_cnt;
reg            mon_wgs_data_onfly_w;
reg            mon_wgs_push_cnt_inc;
reg    [223:0] mon_wgs_push_data;
reg            mon_wgs_req_addr_inc;
reg            mon_wgs_req_dword_cnt_dec;
reg            mon_wgs_req_sum;
reg            mon_wmb_cbuf_wr_idx_inc;
reg            mon_wmb_data_avl_w;
reg            mon_wmb_data_onfly_w;
reg            mon_wmb_data_stored_w;
reg            mon_wmb_fetched_cnt_inc;
reg            mon_wmb_req_burst_cnt_dec;
reg            mon_wmb_req_sum;
reg            mon_wmb_required_bits_w;
reg            mon_wt_cbuf_flush_idx_w;
reg            mon_wt_data_avl_w;
reg            mon_wt_data_onfly_w;
reg            mon_wt_data_stored_w;
reg            mon_wt_fetched_cnt_inc;
reg            mon_wt_req_burst_cnt_dec;
reg            mon_wt_req_sum;
reg            mon_wt_required_bytes_w;
reg            nan_carry;
reg            nan_pass;
reg            nan_pass_w;
reg            nan_reg_en;
reg            need_pending;
reg     [23:0] normal_bpg;
reg      [1:0] nxt_state;
reg      [8:0] outs_dp2reg_wt_rd_latency;
reg            pending_ack;
reg            pending_req;
reg            pending_req_d1;
reg     [21:0] pre_wmb_fetched_cnt;
reg     [21:0] pre_wmb_fetched_cnt_w;
reg     [31:0] pre_wmb_required_bits;
reg     [31:0] pre_wmb_required_bits_w;
reg     [25:0] pre_wt_fetched_cnt;
reg     [25:0] pre_wt_fetched_cnt_w;
reg     [31:0] pre_wt_required_bytes;
reg     [31:0] pre_wt_required_bytes_w;
reg            required_valid;
reg            required_valid_w;
reg      [8:0] sc_wmb_entries;
reg     [11:0] sc_wt_entries;
reg            sc_wt_updt;
reg            status_done;
reg      [3:0] status_done_cnt;
reg      [4:0] status_done_cnt_w;
reg            status_done_w;
reg      [9:0] status_group_cnt;
reg      [9:0] status_group_cnt_inc;
reg      [9:0] status_group_cnt_w;
reg            status_last_group;
reg            status_update;
reg            status_update_wmb;
reg            stl_adv;
reg     [31:0] stl_cnt_cur;
reg     [33:0] stl_cnt_dec;
reg     [33:0] stl_cnt_ext;
reg     [33:0] stl_cnt_inc;
reg     [33:0] stl_cnt_mod;
reg     [33:0] stl_cnt_new;
reg     [33:0] stl_cnt_nxt;
reg      [3:0] weight_bank;
reg      [4:0] weight_bank_end;
reg      [4:0] weight_bank_end_w;
reg      [3:0] weight_bank_w;
reg      [5:0] wgs_data_onfly;
reg      [4:0] wgs_data_onfly_add;
reg            wgs_data_onfly_reg_en;
reg            wgs_data_onfly_sub;
reg      [5:0] wgs_data_onfly_w;
reg    [255:0] wgs_local_data;
reg            wgs_pop_ready;
reg      [9:0] wgs_push_cnt;
reg      [9:0] wgs_push_cnt_inc;
reg      [9:0] wgs_push_cnt_w;
reg     [31:0] wgs_push_data;
reg            wgs_push_last;
reg            wgs_push_req;
reg            wgs_push_req_w;
reg     [58:0] wgs_req_addr_d1;
reg     [58:0] wgs_req_addr_inc;
reg     [58:0] wgs_req_addr_w;
reg            wgs_req_done;
reg      [9:0] wgs_req_dword_cnt_d1;
reg      [9:0] wgs_req_dword_cnt_dec;
reg      [9:0] wgs_req_dword_cnt_w;
reg      [3:0] wgs_req_dword_d1;
reg      [3:0] wgs_req_dword_w;
reg            wgs_req_overflow;
reg            wgs_req_reg_en;
reg      [5:0] wgs_req_sum;
reg            wgs_req_vld_d1;
reg            wgs_req_vld_w;
reg            wgs_rsp_valid;
reg    [511:0] wmb_cbuf_wr_data_w;
reg     [12:0] wmb_cbuf_wr_idx;
reg      [8:0] wmb_cbuf_wr_idx_inc;
reg     [12:0] wmb_cbuf_wr_idx_w;
reg            wmb_cbuf_wr_vld_w;
reg     [10:0] wmb_data_avl;
reg     [10:0] wmb_data_avl_sub;
reg     [10:0] wmb_data_avl_w;
reg     [10:0] wmb_data_onfly;
reg      [3:0] wmb_data_onfly_add;
reg            wmb_data_onfly_reg_en;
reg      [1:0] wmb_data_onfly_sub;
reg     [10:0] wmb_data_onfly_w;
reg     [10:0] wmb_data_stored;
reg     [10:0] wmb_data_stored_sub;
reg     [10:0] wmb_data_stored_w;
reg     [21:0] wmb_fetched_cnt;
reg     [21:0] wmb_fetched_cnt_inc;
reg     [21:0] wmb_fetched_cnt_w;
reg    [255:0] wmb_local_data;
reg      [1:0] wmb_local_data_cnt;
reg            wmb_local_data_reg_en;
reg            wmb_local_data_vld;
reg            wmb_local_data_vld_w;
reg    [255:0] wmb_local_data_w;
reg     [58:0] wmb_req_addr_d2;
reg     [58:0] wmb_req_addr_d3;
reg     [55:0] wmb_req_addr_inc;
reg     [58:0] wmb_req_addr_w;
reg     [22:0] wmb_req_burst_cnt_d1;
reg     [22:0] wmb_req_burst_cnt_dec;
reg     [22:0] wmb_req_burst_cnt_w;
reg            wmb_req_done_d2;
reg            wmb_req_done_d3;
reg            wmb_req_done_w;
reg            wmb_req_last_d2;
reg            wmb_req_last_w;
reg            wmb_req_overflow;
reg            wmb_req_reg_en;
reg      [3:0] wmb_req_size_addr_limit;
reg      [3:0] wmb_req_size_d1;
reg      [3:0] wmb_req_size_d2;
reg      [3:0] wmb_req_size_d3;
reg      [2:0] wmb_req_size_out_d2;
reg      [2:0] wmb_req_size_out_d3;
reg      [2:0] wmb_req_size_out_w;
reg      [3:0] wmb_req_size_w;
reg            wmb_req_stage_vld_d1;
reg            wmb_req_stage_vld_d2;
reg     [10:0] wmb_req_sum;
reg            wmb_req_vld_d3;
reg            wmb_req_vld_w;
reg     [31:0] wmb_required_bits;
reg     [31:0] wmb_required_bits_w;
reg            wmb_required_en;
reg            wmb_rsp_valid;
reg            wmb_satisfied;
reg      [1:0] wt2status_state;
reg      [1:0] wt2status_state_w;
reg     [12:0] wt_cbuf_flush_idx;
reg     [12:0] wt_cbuf_flush_idx_w;
reg            wt_cbuf_flush_vld_w;
reg    [511:0] wt_cbuf_wr_data_ori_w;
reg    [511:0] wt_cbuf_wr_data_w;
reg     [12:0] wt_cbuf_wr_idx;
reg     [13:0] wt_cbuf_wr_idx_inc;
reg            wt_cbuf_wr_idx_set;
reg     [12:0] wt_cbuf_wr_idx_w;
reg            wt_cbuf_wr_idx_wrap;
reg            wt_cbuf_wr_vld_w;
reg     [13:0] wt_data_avl;
reg     [13:0] wt_data_avl_sub;
reg     [13:0] wt_data_avl_w;
reg     [13:0] wt_data_onfly;
reg      [3:0] wt_data_onfly_add;
reg            wt_data_onfly_reg_en;
reg      [1:0] wt_data_onfly_sub;
reg     [13:0] wt_data_onfly_w;
reg     [13:0] wt_data_stored;
reg     [13:0] wt_data_stored_sub;
reg     [13:0] wt_data_stored_w;
reg     [25:0] wt_fetched_cnt;
reg     [25:0] wt_fetched_cnt_inc;
reg     [25:0] wt_fetched_cnt_w;
reg     [31:0] wt_fp16_exp_flag_w;
reg     [31:0] wt_fp16_inf_flag;
reg     [31:0] wt_fp16_inf_flag_w;
reg      [5:0] wt_fp16_inf_sum;
reg            wt_fp16_inf_vld;
reg            wt_fp16_inf_vld_w;
reg     [31:0] wt_fp16_manti_flag_w;
reg     [31:0] wt_fp16_nan_flag;
reg     [31:0] wt_fp16_nan_flag_w;
reg      [5:0] wt_fp16_nan_sum;
reg            wt_fp16_nan_vld;
reg            wt_fp16_nan_vld_w;
reg    [255:0] wt_local_data;
reg      [1:0] wt_local_data_cnt;
reg            wt_local_data_reg_en;
reg            wt_local_data_vld;
reg            wt_local_data_vld_w;
reg    [255:0] wt_local_data_w;
reg    [511:0] wt_nan_mask;
reg            wt_rd_latency_cen;
reg            wt_rd_latency_clr;
reg            wt_rd_latency_dec;
reg            wt_rd_latency_inc;
reg            wt_rd_stall_cen;
reg            wt_rd_stall_clr;
reg            wt_rd_stall_inc;
reg     [58:0] wt_req_addr_d2;
reg     [58:0] wt_req_addr_d3;
reg     [55:0] wt_req_addr_inc;
reg     [58:0] wt_req_addr_w;
reg     [26:0] wt_req_burst_cnt_d1;
reg     [26:0] wt_req_burst_cnt_dec;
reg     [26:0] wt_req_burst_cnt_w;
reg            wt_req_done_d2;
reg            wt_req_done_d3;
reg            wt_req_done_w;
reg            wt_req_last_d2;
reg            wt_req_last_w;
reg            wt_req_overflow;
reg            wt_req_reg_en;
reg      [3:0] wt_req_size_addr_limit;
reg      [3:0] wt_req_size_d1;
reg      [3:0] wt_req_size_d2;
reg      [3:0] wt_req_size_d3;
reg      [2:0] wt_req_size_out_d2;
reg      [2:0] wt_req_size_out_d3;
reg      [2:0] wt_req_size_out_w;
reg      [3:0] wt_req_size_w;
reg            wt_req_stage_vld_d1;
reg            wt_req_stage_vld_d2;
reg     [13:0] wt_req_sum;
reg            wt_req_vld_d3;
reg            wt_req_vld_w;
reg     [31:0] wt_required_bytes;
reg     [31:0] wt_required_bytes_w;
reg            wt_required_en;
reg            wt_rsp_valid;
reg            wt_satisfied;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
////////////////////////////////////////////////////////////////////////
// CDMA weight fetching logic FSM                                     //
////////////////////////////////////////////////////////////////////////


//## fsm (1) output

//|)

//## fsm (1) defines

localparam WT_STATE_IDLE = 2'b00;
localparam WT_STATE_PEND = 2'b01;
localparam WT_STATE_BUSY = 2'b10;
localparam WT_STATE_DONE = 2'b11;

//## fsm (1) com block

always @(
  cur_state
  or reg2dp_op_en
  or need_pending
  or reg2dp_weight_reuse
  or last_skip_weight_rls
  or pending_req_end
  or fetch_done
  or status2dma_fsm_switch
  ) begin
  nxt_state = cur_state;
  begin
    casez (cur_state)
      WT_STATE_IDLE: begin
        if ((reg2dp_op_en & need_pending)) begin
          nxt_state = WT_STATE_PEND; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((reg2dp_op_en & need_pending)) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if ((reg2dp_op_en & reg2dp_weight_reuse & last_skip_weight_rls)) begin
          nxt_state = WT_STATE_DONE; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((reg2dp_op_en & reg2dp_weight_reuse & last_skip_weight_rls)) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if (reg2dp_op_en) begin
          nxt_state = WT_STATE_BUSY; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((reg2dp_op_en) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      WT_STATE_PEND: begin
        if ((pending_req_end)) begin
          nxt_state = WT_STATE_BUSY; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((pending_req_end)) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      WT_STATE_BUSY: begin
        if (fetch_done) begin
          nxt_state = WT_STATE_DONE; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((fetch_done) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      WT_STATE_DONE: begin
        if (status2dma_fsm_switch) begin
          nxt_state = WT_STATE_IDLE; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((status2dma_fsm_switch) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      // VCS coverage off
      default: begin
        nxt_state = WT_STATE_IDLE; 
        `ifndef SYNTHESIS
        nxt_state = {2{1'bx}};
        `endif
      end
      // VCS coverage on
    endcase
  end
end

//## fsm (1) seq block

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cur_state <= WT_STATE_IDLE;
  end else begin
  cur_state <= nxt_state;
  end
end

//## fsm (1) reachable testpoints


`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WT_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WT_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_WT_STATE_IDLE
    `define COVER_OR_TP__state_reachable_WT_STATE_IDLE_OR_COVER
  `endif // TP__state_reachable_WT_STATE_IDLE

`ifdef COVER_OR_TP__state_reachable_WT_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_WT_STATE_IDLE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_0_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_0_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_0_internal_nvdla_core_rstn
    //  Clock signal: testpoint_0_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_0_internal_nvdla_core_clk or negedge testpoint_0_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_0
        if (~testpoint_0_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_0_count_0;

    reg testpoint_0_goal_0;
    initial testpoint_0_goal_0 = 0;
    initial testpoint_0_count_0 = 0;
    always@(testpoint_0_count_0) begin
        if(testpoint_0_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_0_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: state_reachable_WT_STATE_IDLE ::: cur_state==WT_STATE_IDLE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: state_reachable_WT_STATE_IDLE ::: testpoint_0_goal_0
            testpoint_0_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_0_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_0_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_0
        if (testpoint_0_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==WT_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: state_reachable_WT_STATE_IDLE ::: testpoint_0_goal_0");
 `endif
            if ((cur_state==WT_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
                testpoint_0_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk) begin
 `endif
                testpoint_0_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_0_goal_0_active = ((cur_state==WT_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_0_goal_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_WT_STATE_IDLE_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_WT_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WT_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WT_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_WT_STATE_PEND
    `define COVER_OR_TP__state_reachable_WT_STATE_PEND_OR_COVER
  `endif // TP__state_reachable_WT_STATE_PEND

`ifdef COVER_OR_TP__state_reachable_WT_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_WT_STATE_PEND"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_1_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_1_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_1_internal_nvdla_core_rstn
    //  Clock signal: testpoint_1_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_1_internal_nvdla_core_clk or negedge testpoint_1_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_1
        if (~testpoint_1_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_1_count_0;

    reg testpoint_1_goal_0;
    initial testpoint_1_goal_0 = 0;
    initial testpoint_1_count_0 = 0;
    always@(testpoint_1_count_0) begin
        if(testpoint_1_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_1_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: state_reachable_WT_STATE_PEND ::: cur_state==WT_STATE_PEND");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: state_reachable_WT_STATE_PEND ::: testpoint_1_goal_0
            testpoint_1_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_1_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_1_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_1
        if (testpoint_1_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==WT_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: state_reachable_WT_STATE_PEND ::: testpoint_1_goal_0");
 `endif
            if ((cur_state==WT_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
                testpoint_1_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk) begin
 `endif
                testpoint_1_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_1_goal_0_active = ((cur_state==WT_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_1_goal_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_WT_STATE_PEND_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_WT_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WT_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WT_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_WT_STATE_BUSY
    `define COVER_OR_TP__state_reachable_WT_STATE_BUSY_OR_COVER
  `endif // TP__state_reachable_WT_STATE_BUSY

`ifdef COVER_OR_TP__state_reachable_WT_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_WT_STATE_BUSY"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_2_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_2_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_2_internal_nvdla_core_rstn
    //  Clock signal: testpoint_2_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_2_internal_nvdla_core_clk or negedge testpoint_2_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_2
        if (~testpoint_2_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_2_count_0;

    reg testpoint_2_goal_0;
    initial testpoint_2_goal_0 = 0;
    initial testpoint_2_count_0 = 0;
    always@(testpoint_2_count_0) begin
        if(testpoint_2_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_2_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: state_reachable_WT_STATE_BUSY ::: cur_state==WT_STATE_BUSY");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: state_reachable_WT_STATE_BUSY ::: testpoint_2_goal_0
            testpoint_2_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_2_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_2_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_2
        if (testpoint_2_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==WT_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: state_reachable_WT_STATE_BUSY ::: testpoint_2_goal_0");
 `endif
            if ((cur_state==WT_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
                testpoint_2_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk) begin
 `endif
                testpoint_2_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_2_goal_0_active = ((cur_state==WT_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_WT_STATE_BUSY_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_WT_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WT_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WT_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_WT_STATE_DONE
    `define COVER_OR_TP__state_reachable_WT_STATE_DONE_OR_COVER
  `endif // TP__state_reachable_WT_STATE_DONE

`ifdef COVER_OR_TP__state_reachable_WT_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_WT_STATE_DONE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_3_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_3_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_3_internal_nvdla_core_rstn
    //  Clock signal: testpoint_3_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_3_internal_nvdla_core_clk or negedge testpoint_3_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_3
        if (~testpoint_3_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_3_count_0;

    reg testpoint_3_goal_0;
    initial testpoint_3_goal_0 = 0;
    initial testpoint_3_count_0 = 0;
    always@(testpoint_3_count_0) begin
        if(testpoint_3_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_3_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: state_reachable_WT_STATE_DONE ::: cur_state==WT_STATE_DONE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: state_reachable_WT_STATE_DONE ::: testpoint_3_goal_0
            testpoint_3_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_3_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_3_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_3
        if (testpoint_3_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==WT_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: state_reachable_WT_STATE_DONE ::: testpoint_3_goal_0");
 `endif
            if ((cur_state==WT_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
                testpoint_3_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk) begin
 `endif
                testpoint_3_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_3_goal_0_active = ((cur_state==WT_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_3_goal_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_WT_STATE_DONE_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_WT_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

//## fsm (1) transition testpoints

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__transition_WT_STATE_IDLE__to__WT_STATE_PEND
    `define COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_PEND_OR_COVER
  `endif // TP__transition_WT_STATE_IDLE__to__WT_STATE_PEND

`ifdef COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_WT_STATE_IDLE__to__WT_STATE_PEND"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_4_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_4_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_4_internal_nvdla_core_rstn
    //  Clock signal: testpoint_4_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_4_internal_nvdla_core_clk or negedge testpoint_4_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_4
        if (~testpoint_4_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_4_count_0;

    reg testpoint_4_goal_0;
    initial testpoint_4_goal_0 = 0;
    initial testpoint_4_count_0 = 0;
    always@(testpoint_4_count_0) begin
        if(testpoint_4_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_4_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: transition_WT_STATE_IDLE__to__WT_STATE_PEND ::: (cur_state==WT_STATE_IDLE) && (nxt_state == WT_STATE_PEND)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: transition_WT_STATE_IDLE__to__WT_STATE_PEND ::: testpoint_4_goal_0
            testpoint_4_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_4_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_4_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_4
        if (testpoint_4_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((cur_state==WT_STATE_IDLE) && (nxt_state == WT_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: transition_WT_STATE_IDLE__to__WT_STATE_PEND ::: testpoint_4_goal_0");
 `endif
            if (((cur_state==WT_STATE_IDLE) && (nxt_state == WT_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
                testpoint_4_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk) begin
 `endif
                testpoint_4_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_4_goal_0_active = (((cur_state==WT_STATE_IDLE) && (nxt_state == WT_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_4_goal_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_WT_STATE_IDLE__to__WT_STATE_PEND_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_WT_STATE_IDLE__to__WT_STATE_DONE
    `define COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_DONE_OR_COVER
  `endif // TP__transition_WT_STATE_IDLE__to__WT_STATE_DONE

`ifdef COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_WT_STATE_IDLE__to__WT_STATE_DONE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_5_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_5_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_5_internal_nvdla_core_rstn
    //  Clock signal: testpoint_5_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_5_internal_nvdla_core_clk or negedge testpoint_5_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_5
        if (~testpoint_5_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_5_count_0;

    reg testpoint_5_goal_0;
    initial testpoint_5_goal_0 = 0;
    initial testpoint_5_count_0 = 0;
    always@(testpoint_5_count_0) begin
        if(testpoint_5_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_5_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: transition_WT_STATE_IDLE__to__WT_STATE_DONE ::: (cur_state==WT_STATE_IDLE) && (nxt_state == WT_STATE_DONE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: transition_WT_STATE_IDLE__to__WT_STATE_DONE ::: testpoint_5_goal_0
            testpoint_5_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_5_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_5_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_5
        if (testpoint_5_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((cur_state==WT_STATE_IDLE) && (nxt_state == WT_STATE_DONE)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: transition_WT_STATE_IDLE__to__WT_STATE_DONE ::: testpoint_5_goal_0");
 `endif
            if (((cur_state==WT_STATE_IDLE) && (nxt_state == WT_STATE_DONE)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
                testpoint_5_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk) begin
 `endif
                testpoint_5_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_5_goal_0_active = (((cur_state==WT_STATE_IDLE) && (nxt_state == WT_STATE_DONE)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_5_goal_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_WT_STATE_IDLE__to__WT_STATE_DONE_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__transition_WT_STATE_IDLE__to__WT_STATE_BUSY
    `define COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_BUSY_OR_COVER
  `endif // TP__transition_WT_STATE_IDLE__to__WT_STATE_BUSY

`ifdef COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_WT_STATE_IDLE__to__WT_STATE_BUSY"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_6_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_6_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_6_internal_nvdla_core_rstn
    //  Clock signal: testpoint_6_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_6_internal_nvdla_core_clk or negedge testpoint_6_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_6
        if (~testpoint_6_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_6_count_0;

    reg testpoint_6_goal_0;
    initial testpoint_6_goal_0 = 0;
    initial testpoint_6_count_0 = 0;
    always@(testpoint_6_count_0) begin
        if(testpoint_6_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_6_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: transition_WT_STATE_IDLE__to__WT_STATE_BUSY ::: (cur_state==WT_STATE_IDLE) && (nxt_state == WT_STATE_BUSY)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: transition_WT_STATE_IDLE__to__WT_STATE_BUSY ::: testpoint_6_goal_0
            testpoint_6_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_6_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_6_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_6
        if (testpoint_6_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((cur_state==WT_STATE_IDLE) && (nxt_state == WT_STATE_BUSY)) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: transition_WT_STATE_IDLE__to__WT_STATE_BUSY ::: testpoint_6_goal_0");
 `endif
            if (((cur_state==WT_STATE_IDLE) && (nxt_state == WT_STATE_BUSY)) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk)
                testpoint_6_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk) begin
 `endif
                testpoint_6_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_6_goal_0_active = (((cur_state==WT_STATE_IDLE) && (nxt_state == WT_STATE_BUSY)) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_6_goal_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_WT_STATE_IDLE__to__WT_STATE_BUSY_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_WT_STATE_IDLE__to__WT_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_WT_STATE_IDLE__to__WT_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_WT_STATE_IDLE__to__WT_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_WT_STATE_IDLE__to__WT_STATE_IDLE
    `define COVER_OR_TP__self_transition_WT_STATE_IDLE__to__WT_STATE_IDLE_OR_COVER
  `endif // TP__self_transition_WT_STATE_IDLE__to__WT_STATE_IDLE

`ifdef COVER_OR_TP__self_transition_WT_STATE_IDLE__to__WT_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_WT_STATE_IDLE__to__WT_STATE_IDLE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_7_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_7_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_7_internal_nvdla_core_rstn
    //  Clock signal: testpoint_7_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_7_internal_nvdla_core_clk or negedge testpoint_7_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_7
        if (~testpoint_7_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_7_count_0;

    reg testpoint_7_goal_0;
    initial testpoint_7_goal_0 = 0;
    initial testpoint_7_count_0 = 0;
    always@(testpoint_7_count_0) begin
        if(testpoint_7_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_7_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: self_transition_WT_STATE_IDLE__to__WT_STATE_IDLE ::: cur_state==WT_STATE_IDLE && nxt_state==WT_STATE_IDLE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: self_transition_WT_STATE_IDLE__to__WT_STATE_IDLE ::: testpoint_7_goal_0
            testpoint_7_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_7_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_7_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_7
        if (testpoint_7_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==WT_STATE_IDLE && nxt_state==WT_STATE_IDLE) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: self_transition_WT_STATE_IDLE__to__WT_STATE_IDLE ::: testpoint_7_goal_0");
 `endif
            if ((cur_state==WT_STATE_IDLE && nxt_state==WT_STATE_IDLE) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk)
                testpoint_7_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk) begin
 `endif
                testpoint_7_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_7_goal_0_active = ((cur_state==WT_STATE_IDLE && nxt_state==WT_STATE_IDLE) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_7_goal_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_WT_STATE_IDLE__to__WT_STATE_IDLE_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_WT_STATE_IDLE__to__WT_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_WT_STATE_PEND__to__WT_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_WT_STATE_PEND__to__WT_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__transition_WT_STATE_PEND__to__WT_STATE_BUSY
    `define COVER_OR_TP__transition_WT_STATE_PEND__to__WT_STATE_BUSY_OR_COVER
  `endif // TP__transition_WT_STATE_PEND__to__WT_STATE_BUSY

`ifdef COVER_OR_TP__transition_WT_STATE_PEND__to__WT_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_WT_STATE_PEND__to__WT_STATE_BUSY"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_8_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_8_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_8_internal_nvdla_core_rstn
    //  Clock signal: testpoint_8_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_8_internal_nvdla_core_clk or negedge testpoint_8_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_8
        if (~testpoint_8_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_8_count_0;

    reg testpoint_8_goal_0;
    initial testpoint_8_goal_0 = 0;
    initial testpoint_8_count_0 = 0;
    always@(testpoint_8_count_0) begin
        if(testpoint_8_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_8_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: transition_WT_STATE_PEND__to__WT_STATE_BUSY ::: (cur_state==WT_STATE_PEND) && (nxt_state == WT_STATE_BUSY)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: transition_WT_STATE_PEND__to__WT_STATE_BUSY ::: testpoint_8_goal_0
            testpoint_8_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_8_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_8_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_8
        if (testpoint_8_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((cur_state==WT_STATE_PEND) && (nxt_state == WT_STATE_BUSY)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: transition_WT_STATE_PEND__to__WT_STATE_BUSY ::: testpoint_8_goal_0");
 `endif
            if (((cur_state==WT_STATE_PEND) && (nxt_state == WT_STATE_BUSY)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk)
                testpoint_8_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk) begin
 `endif
                testpoint_8_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_8_goal_0_active = (((cur_state==WT_STATE_PEND) && (nxt_state == WT_STATE_BUSY)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_8_goal_0 (.clk (testpoint_8_internal_nvdla_core_clk), .tp(testpoint_8_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_WT_STATE_PEND__to__WT_STATE_BUSY_0 (.clk (testpoint_8_internal_nvdla_core_clk), .tp(testpoint_8_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_WT_STATE_PEND__to__WT_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_WT_STATE_PEND__to__WT_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_WT_STATE_PEND__to__WT_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_WT_STATE_PEND__to__WT_STATE_PEND
    `define COVER_OR_TP__self_transition_WT_STATE_PEND__to__WT_STATE_PEND_OR_COVER
  `endif // TP__self_transition_WT_STATE_PEND__to__WT_STATE_PEND

`ifdef COVER_OR_TP__self_transition_WT_STATE_PEND__to__WT_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_WT_STATE_PEND__to__WT_STATE_PEND"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_9_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_9_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_9_internal_nvdla_core_rstn
    //  Clock signal: testpoint_9_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_9_internal_nvdla_core_clk or negedge testpoint_9_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_9
        if (~testpoint_9_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_9_count_0;

    reg testpoint_9_goal_0;
    initial testpoint_9_goal_0 = 0;
    initial testpoint_9_count_0 = 0;
    always@(testpoint_9_count_0) begin
        if(testpoint_9_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_9_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: self_transition_WT_STATE_PEND__to__WT_STATE_PEND ::: cur_state==WT_STATE_PEND && nxt_state==WT_STATE_PEND");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: self_transition_WT_STATE_PEND__to__WT_STATE_PEND ::: testpoint_9_goal_0
            testpoint_9_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_9_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_9_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_9
        if (testpoint_9_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==WT_STATE_PEND && nxt_state==WT_STATE_PEND) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: self_transition_WT_STATE_PEND__to__WT_STATE_PEND ::: testpoint_9_goal_0");
 `endif
            if ((cur_state==WT_STATE_PEND && nxt_state==WT_STATE_PEND) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk)
                testpoint_9_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk) begin
 `endif
                testpoint_9_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_9_goal_0_active = ((cur_state==WT_STATE_PEND && nxt_state==WT_STATE_PEND) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_9_goal_0 (.clk (testpoint_9_internal_nvdla_core_clk), .tp(testpoint_9_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_WT_STATE_PEND__to__WT_STATE_PEND_0 (.clk (testpoint_9_internal_nvdla_core_clk), .tp(testpoint_9_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_WT_STATE_PEND__to__WT_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_WT_STATE_BUSY__to__WT_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_WT_STATE_BUSY__to__WT_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_WT_STATE_BUSY__to__WT_STATE_DONE
    `define COVER_OR_TP__transition_WT_STATE_BUSY__to__WT_STATE_DONE_OR_COVER
  `endif // TP__transition_WT_STATE_BUSY__to__WT_STATE_DONE

`ifdef COVER_OR_TP__transition_WT_STATE_BUSY__to__WT_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_WT_STATE_BUSY__to__WT_STATE_DONE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_10_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_10_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_10_internal_nvdla_core_rstn
    //  Clock signal: testpoint_10_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_10_internal_nvdla_core_clk or negedge testpoint_10_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_10
        if (~testpoint_10_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_10_count_0;

    reg testpoint_10_goal_0;
    initial testpoint_10_goal_0 = 0;
    initial testpoint_10_count_0 = 0;
    always@(testpoint_10_count_0) begin
        if(testpoint_10_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_10_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: transition_WT_STATE_BUSY__to__WT_STATE_DONE ::: (cur_state==WT_STATE_BUSY) && (nxt_state == WT_STATE_DONE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: transition_WT_STATE_BUSY__to__WT_STATE_DONE ::: testpoint_10_goal_0
            testpoint_10_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_10_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_10_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_10
        if (testpoint_10_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((cur_state==WT_STATE_BUSY) && (nxt_state == WT_STATE_DONE)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: transition_WT_STATE_BUSY__to__WT_STATE_DONE ::: testpoint_10_goal_0");
 `endif
            if (((cur_state==WT_STATE_BUSY) && (nxt_state == WT_STATE_DONE)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk)
                testpoint_10_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk) begin
 `endif
                testpoint_10_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_10_goal_0_active = (((cur_state==WT_STATE_BUSY) && (nxt_state == WT_STATE_DONE)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_10_goal_0 (.clk (testpoint_10_internal_nvdla_core_clk), .tp(testpoint_10_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_WT_STATE_BUSY__to__WT_STATE_DONE_0 (.clk (testpoint_10_internal_nvdla_core_clk), .tp(testpoint_10_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_WT_STATE_BUSY__to__WT_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_WT_STATE_BUSY__to__WT_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_WT_STATE_BUSY__to__WT_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_WT_STATE_BUSY__to__WT_STATE_BUSY
    `define COVER_OR_TP__self_transition_WT_STATE_BUSY__to__WT_STATE_BUSY_OR_COVER
  `endif // TP__self_transition_WT_STATE_BUSY__to__WT_STATE_BUSY

`ifdef COVER_OR_TP__self_transition_WT_STATE_BUSY__to__WT_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_WT_STATE_BUSY__to__WT_STATE_BUSY"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_11_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_11_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_11_internal_nvdla_core_rstn
    //  Clock signal: testpoint_11_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_11_internal_nvdla_core_clk or negedge testpoint_11_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_11
        if (~testpoint_11_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_11_count_0;

    reg testpoint_11_goal_0;
    initial testpoint_11_goal_0 = 0;
    initial testpoint_11_count_0 = 0;
    always@(testpoint_11_count_0) begin
        if(testpoint_11_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_11_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: self_transition_WT_STATE_BUSY__to__WT_STATE_BUSY ::: cur_state==WT_STATE_BUSY && nxt_state==WT_STATE_BUSY");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: self_transition_WT_STATE_BUSY__to__WT_STATE_BUSY ::: testpoint_11_goal_0
            testpoint_11_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_11_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_11_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_11
        if (testpoint_11_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==WT_STATE_BUSY && nxt_state==WT_STATE_BUSY) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: self_transition_WT_STATE_BUSY__to__WT_STATE_BUSY ::: testpoint_11_goal_0");
 `endif
            if ((cur_state==WT_STATE_BUSY && nxt_state==WT_STATE_BUSY) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk)
                testpoint_11_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk) begin
 `endif
                testpoint_11_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_11_goal_0_active = ((cur_state==WT_STATE_BUSY && nxt_state==WT_STATE_BUSY) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_11_goal_0 (.clk (testpoint_11_internal_nvdla_core_clk), .tp(testpoint_11_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_WT_STATE_BUSY__to__WT_STATE_BUSY_0 (.clk (testpoint_11_internal_nvdla_core_clk), .tp(testpoint_11_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_WT_STATE_BUSY__to__WT_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_WT_STATE_DONE__to__WT_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_WT_STATE_DONE__to__WT_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_WT_STATE_DONE__to__WT_STATE_IDLE
    `define COVER_OR_TP__transition_WT_STATE_DONE__to__WT_STATE_IDLE_OR_COVER
  `endif // TP__transition_WT_STATE_DONE__to__WT_STATE_IDLE

`ifdef COVER_OR_TP__transition_WT_STATE_DONE__to__WT_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_WT_STATE_DONE__to__WT_STATE_IDLE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_12_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_12_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_12_internal_nvdla_core_rstn
    //  Clock signal: testpoint_12_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_12_internal_nvdla_core_clk or negedge testpoint_12_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_12
        if (~testpoint_12_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_12_count_0;

    reg testpoint_12_goal_0;
    initial testpoint_12_goal_0 = 0;
    initial testpoint_12_count_0 = 0;
    always@(testpoint_12_count_0) begin
        if(testpoint_12_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_12_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: transition_WT_STATE_DONE__to__WT_STATE_IDLE ::: (cur_state==WT_STATE_DONE) && (nxt_state == WT_STATE_IDLE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: transition_WT_STATE_DONE__to__WT_STATE_IDLE ::: testpoint_12_goal_0
            testpoint_12_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_12_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_12_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_12
        if (testpoint_12_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((cur_state==WT_STATE_DONE) && (nxt_state == WT_STATE_IDLE)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: transition_WT_STATE_DONE__to__WT_STATE_IDLE ::: testpoint_12_goal_0");
 `endif
            if (((cur_state==WT_STATE_DONE) && (nxt_state == WT_STATE_IDLE)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk)
                testpoint_12_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk) begin
 `endif
                testpoint_12_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_12_goal_0_active = (((cur_state==WT_STATE_DONE) && (nxt_state == WT_STATE_IDLE)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_12_goal_0 (.clk (testpoint_12_internal_nvdla_core_clk), .tp(testpoint_12_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_WT_STATE_DONE__to__WT_STATE_IDLE_0 (.clk (testpoint_12_internal_nvdla_core_clk), .tp(testpoint_12_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_WT_STATE_DONE__to__WT_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_WT_STATE_DONE__to__WT_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_WT_STATE_DONE__to__WT_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_WT_STATE_DONE__to__WT_STATE_DONE
    `define COVER_OR_TP__self_transition_WT_STATE_DONE__to__WT_STATE_DONE_OR_COVER
  `endif // TP__self_transition_WT_STATE_DONE__to__WT_STATE_DONE

`ifdef COVER_OR_TP__self_transition_WT_STATE_DONE__to__WT_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_WT_STATE_DONE__to__WT_STATE_DONE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_13_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_13_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_13_internal_nvdla_core_rstn
    //  Clock signal: testpoint_13_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_13_internal_nvdla_core_clk or negedge testpoint_13_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_13
        if (~testpoint_13_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_13_count_0;

    reg testpoint_13_goal_0;
    initial testpoint_13_goal_0 = 0;
    initial testpoint_13_count_0 = 0;
    always@(testpoint_13_count_0) begin
        if(testpoint_13_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_13_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wt ::: self_transition_WT_STATE_DONE__to__WT_STATE_DONE ::: cur_state==WT_STATE_DONE && nxt_state==WT_STATE_DONE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wt ::: self_transition_WT_STATE_DONE__to__WT_STATE_DONE ::: testpoint_13_goal_0
            testpoint_13_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_13_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_13_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_13
        if (testpoint_13_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==WT_STATE_DONE && nxt_state==WT_STATE_DONE) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wt ::: self_transition_WT_STATE_DONE__to__WT_STATE_DONE ::: testpoint_13_goal_0");
 `endif
            if ((cur_state==WT_STATE_DONE && nxt_state==WT_STATE_DONE) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk)
                testpoint_13_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk) begin
 `endif
                testpoint_13_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_13_goal_0_active = ((cur_state==WT_STATE_DONE && nxt_state==WT_STATE_DONE) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_13_goal_0 (.clk (testpoint_13_internal_nvdla_core_clk), .tp(testpoint_13_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_WT_STATE_DONE__to__WT_STATE_DONE_0 (.clk (testpoint_13_internal_nvdla_core_clk), .tp(testpoint_13_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_WT_STATE_DONE__to__WT_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

//## fsm (1) assertions

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
//  FSM input signals                                                 //
////////////////////////////////////////////////////////////////////////
always @(
  layer_st
  or status_done
  or status_done_cnt
  ) begin
    status_done_cnt_w[4:0] = layer_st ? 5'b0 :
                             (status_done & (status_done_cnt != 4'h8)) ? (status_done_cnt + 4'b1) : 
                             status_done_cnt;
end

always @(
  status_done
  or status_done_cnt
  ) begin
    fetch_done = status_done & (status_done_cnt == 4'h8);
end

always @(
  last_data_bank
  or reg2dp_data_bank
  or last_weight_bank
  or reg2dp_weight_bank
  ) begin
    need_pending = ((last_data_bank != reg2dp_data_bank) | (last_weight_bank != reg2dp_weight_bank));
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    status_done_cnt <= {4{1'b0}};
  end else begin
  if ((layer_st | is_running) == 1'b1) begin
    status_done_cnt <= status_done_cnt_w[3:0];
  // VCS coverage off
  end else if ((layer_st | is_running) == 1'b0) begin
  end else begin
    status_done_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | is_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  FSM output signals                                                //
////////////////////////////////////////////////////////////////////////

always @(
  reg2dp_op_en
  or cur_state
  ) begin
    layer_st = reg2dp_op_en && (cur_state == WT_STATE_IDLE);
end

always @(
  status2dma_fsm_switch
  ) begin
    layer_end = status2dma_fsm_switch;
end

always @(
  cur_state
  ) begin
    is_running = (cur_state == WT_STATE_BUSY);
end

always @(
  cur_state
  ) begin
    is_pending = (cur_state == WT_STATE_PEND);
end

always @(
  pending_ack
  or pending_req
  ) begin
    clear_all = pending_ack & pending_req;
end

always @(
  nxt_state
  ) begin
    is_nxt_running = (nxt_state == WT_STATE_BUSY);
end

always @(
  nxt_state
  ) begin
    wt2status_state_w = (nxt_state == WT_STATE_PEND) ? 1  : 
                        (nxt_state == WT_STATE_BUSY) ? 2  : 
                        (nxt_state == WT_STATE_DONE) ? 3  :
                        0 ;
end

assign pending_req_end = pending_req_d1 & ~pending_req;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt2status_state <= 0;
  end else begin
  wt2status_state <= wt2status_state_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pending_req <= 1'b0;
  end else begin
  pending_req <= sc2cdma_wt_pending_req;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pending_req_d1 <= 1'b0;
  end else begin
  pending_req_d1 <= pending_req;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pending_ack <= 1'b0;
  end else begin
  pending_ack <= is_pending;
  end
end

assign cdma2sc_wt_pending_ack = pending_ack;

////////////////////////////////////////////////////////////////////////
//  registers to keep last layer status                               //
////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_data_bank <= {4{1'b1}};
  end else begin
  if ((layer_end) == 1'b1) begin
    last_data_bank <= reg2dp_data_bank;
  // VCS coverage off
  end else if ((layer_end) == 1'b0) begin
  end else begin
    last_data_bank <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_weight_bank <= {4{1'b1}};
  end else begin
  if ((layer_end) == 1'b1) begin
    last_weight_bank <= reg2dp_weight_bank;
  // VCS coverage off
  end else if ((layer_end) == 1'b0) begin
  end else begin
    last_weight_bank <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_skip_weight_rls <= 1'b0;
  end else begin
  if ((layer_end) == 1'b1) begin
    last_skip_weight_rls <= reg2dp_skip_weight_rls;
  // VCS coverage off
  end else if ((layer_end) == 1'b0) begin
  end else begin
    last_skip_weight_rls <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    layer_st_d1 <= 1'b0;
  end else begin
  layer_st_d1 <= layer_st;
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
  nv_assert_never #(0,0,"Config error! Data banks is more than 15!")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && (reg2dp_data_bank == 4'hf))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! Weight banks is more than 15!")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && (reg2dp_weight_bank == 4'hf))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! Sum of data & weight banks is more than 16 when weight uncompressed")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && ~is_compressed && (weight_bank_end_w > 16))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! Sum of data & weight banks is more than 15 when weight compressed!")      zzz_assert_never_9x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && is_compressed && (weight_bank_end_w > 15))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! wmb bytes is not match the require size!")      zzz_assert_never_10x (nvdla_core_clk, `ASSERT_RESET, (layer_st_d1 & is_compressed & (reg2dp_wmb_bytes != (((byte_per_kernel * (reg2dp_weight_kernel + 1) / (reg2dp_proc_precision == 2'b0 ? 1 : 2)) + 1023)/1024)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  registers to calculate local values                               //
////////////////////////////////////////////////////////////////////////

always @(posedge nvdla_core_clk) begin
  if ((layer_st) == 1'b1) begin
    byte_per_kernel <= reg2dp_byte_per_kernel + 1'b1;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    byte_per_kernel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    arb_weight_wt <= {5{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    arb_weight_wt <= reg2dp_arb_weight + 1'b1;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    arb_weight_wt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    arb_weight_wmb <= {5{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    arb_weight_wmb <= reg2dp_arb_wmb + 1'b1;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    arb_weight_wmb <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(
  reg2dp_proc_precision
  ) begin
    is_int8 = (reg2dp_proc_precision == 2'h0 );
end

always @(
  reg2dp_proc_precision
  ) begin
    is_fp16 = (reg2dp_proc_precision == 2'h2 );
end

always @(
  reg2dp_weight_format
  ) begin
    is_compressed = (reg2dp_weight_format == 1'h1 );
end
always @(
  is_int8
  or reg2dp_weight_kernel
  ) begin
    group_op = is_int8 ? {2'b0, reg2dp_weight_kernel[12:5]} :
                         {1'b0, reg2dp_weight_kernel[12:4]};
end

always @(
  group_op
  ) begin
    group_w = group_op + 1'b1;
end

always @(
  reg2dp_data_bank
  ) begin
    data_bank_w = reg2dp_data_bank + 1'b1;
end

always @(
  reg2dp_weight_bank
  ) begin
    weight_bank_w = reg2dp_weight_bank + 1'b1;
end

always @(
  weight_bank_w
  or data_bank_w
  ) begin
    weight_bank_end_w = weight_bank_w + data_bank_w;
end

always @(
  reg2dp_nan_to_zero
  or is_fp16
  ) begin
    nan_pass_w = ~reg2dp_nan_to_zero | ~is_fp16;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    group <= {10{1'b1}};
  end else begin
  if ((layer_st) == 1'b1) begin
    group <= group_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    group <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    weight_bank <= {4{1'b1}};
  end else begin
  if ((layer_st) == 1'b1) begin
    weight_bank <= weight_bank_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    weight_bank <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    weight_bank_end <= {5{1'b1}};
  end else begin
  if ((layer_st) == 1'b1) begin
    weight_bank_end <= weight_bank_end_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    weight_bank_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    nan_pass <= 1'b1;
  end else begin
  if ((layer_st) == 1'b1) begin
    nan_pass <= nan_pass_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    nan_pass <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  generate address for weight data                                  //
////////////////////////////////////////////////////////////////////////
localparam SRC_ID_WT  = 2'b00;
localparam SRC_ID_WMB = 2'b01;
localparam SRC_ID_WGS = 2'b10;


/////////////////// stage 1 ///////////////////
assign wt_req_reg_en_d0 = wt_req_reg_en;

always @(
  wt_req_burst_cnt_d1
  or wt_req_size_d1
  ) begin
    {mon_wt_req_burst_cnt_dec,
     wt_req_burst_cnt_dec} = wt_req_burst_cnt_d1 - {{23{1'b0}}, wt_req_size_d1};
end

always @(
  layer_st
  or reg2dp_weight_bytes
  or wt_req_burst_cnt_dec
  ) begin
    wt_req_burst_cnt_w = layer_st ? {reg2dp_weight_bytes, 2'b0} :
                         wt_req_burst_cnt_dec;
end

always @(
  layer_st
  or reg2dp_weight_addr_low
  ) begin
    wt_req_size_addr_limit = layer_st ? (4'h8 - reg2dp_weight_addr_low[2:0]) : 4'h8;
end

always @(
  wt_req_size_addr_limit
  or wt_req_burst_cnt_w
  ) begin
    wt_req_size_w = ( {{23{1'b0}}, wt_req_size_addr_limit} > wt_req_burst_cnt_w) ? wt_req_burst_cnt_w[3:0] :
                    wt_req_size_addr_limit;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_req_size_d1 <= {4{1'b0}};
  end else begin
  if ((wt_req_reg_en_d0) == 1'b1) begin
    wt_req_size_d1 <= wt_req_size_w;
  // VCS coverage off
  end else if ((wt_req_reg_en_d0) == 1'b0) begin
  end else begin
    wt_req_size_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_burst_cnt_d1 <= {27{1'b0}};
  end else begin
  if ((wt_req_reg_en_d0) == 1'b1) begin
    wt_req_burst_cnt_d1 <= wt_req_burst_cnt_w;
  // VCS coverage off
  end else if ((wt_req_reg_en_d0) == 1'b0) begin
  end else begin
    wt_req_burst_cnt_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_stage_vld_d1 <= 1'b0;
  end else begin
  wt_req_stage_vld_d1 <= is_nxt_running;
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
  nv_assert_never #(0,0,"Error! wt_req_burst_cnt_dec is overflow")      zzz_assert_never_19x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wt_req_burst_cnt_dec)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////// stage 2 ///////////////////
assign wt_req_reg_en_d1 = wt_req_reg_en;

always @(
  wt_req_stage_vld_d1
  or wt_req_burst_cnt_d1
  or wt_req_size_d1
  ) begin
    wt_req_last_w = wt_req_stage_vld_d1 && (wt_req_burst_cnt_d1 == {{23{1'b0}}, wt_req_size_d1});
end

always @(
  wt_req_addr_d2
  ) begin
    wt_req_addr_inc = wt_req_addr_d2[58:3] + 1'b1;
end

always @(
  wt_req_stage_vld_d2
  or reg2dp_weight_addr_high
  or reg2dp_weight_addr_low
  or wt_req_addr_inc
  ) begin
    wt_req_addr_w = (~wt_req_stage_vld_d2) ? {reg2dp_weight_addr_high,reg2dp_weight_addr_low} :
                    {wt_req_addr_inc, 3'b0};
end

always @(
  wt_req_size_d1
  ) begin
    wt_req_size_out_w = wt_req_size_d1[2:0] - 3'b1;
end

always @(
  layer_st
  or wt_req_last_d2
  or wt_req_done_d2
  ) begin
    wt_req_done_w = layer_st ? 1'b0 :
                    wt_req_last_d2 ? 1'b1 :
                    wt_req_done_d2;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_req_addr_d2 <= {59{1'b0}};
  end else begin
  if ((wt_req_reg_en_d1) == 1'b1) begin
    wt_req_addr_d2 <= wt_req_addr_w;
  // VCS coverage off
  end else if ((wt_req_reg_en_d1) == 1'b0) begin
  end else begin
    wt_req_addr_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_size_d2 <= {4{1'b0}};
  end else begin
  if ((wt_req_reg_en_d1) == 1'b1) begin
    wt_req_size_d2 <= wt_req_size_d1;
  // VCS coverage off
  end else if ((wt_req_reg_en_d1) == 1'b0) begin
  end else begin
    wt_req_size_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_size_out_d2 <= {3{1'b0}};
  end else begin
  if ((wt_req_reg_en_d1) == 1'b1) begin
    wt_req_size_out_d2 <= wt_req_size_out_w;
  // VCS coverage off
  end else if ((wt_req_reg_en_d1) == 1'b0) begin
  end else begin
    wt_req_size_out_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_last_d2 <= 1'b0;
  end else begin
  if ((wt_req_reg_en_d1) == 1'b1) begin
    wt_req_last_d2 <= wt_req_last_w;
  // VCS coverage off
  end else if ((wt_req_reg_en_d1) == 1'b0) begin
  end else begin
    wt_req_last_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_done_d2 <= 1'b1;
  end else begin
  if ((wt_req_reg_en_d1) == 1'b1) begin
    wt_req_done_d2 <= wt_req_done_w;
  // VCS coverage off
  end else if ((wt_req_reg_en_d1) == 1'b0) begin
  end else begin
    wt_req_done_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_stage_vld_d2 <= 1'b0;
  end else begin
  wt_req_stage_vld_d2 <= wt_req_stage_vld_d1 & is_nxt_running;
  end
end

/////////////////// stage 3 ///////////////////
assign wt_req_reg_en_d2 = wt_req_reg_en;

always @(
  is_nxt_running
  or wt_req_stage_vld_d2
  ) begin
    wt_req_vld_w = is_nxt_running & wt_req_stage_vld_d2;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_req_vld_d3 <= 1'b0;
  end else begin
  wt_req_vld_d3 <= wt_req_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_req_addr_d3 <= {59{1'b0}};
  end else begin
  if ((wt_req_reg_en_d2) == 1'b1) begin
    wt_req_addr_d3 <= wt_req_addr_d2;
  // VCS coverage off
  end else if ((wt_req_reg_en_d2) == 1'b0) begin
  end else begin
    wt_req_addr_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_size_d3 <= {4{1'b0}};
  end else begin
  if ((wt_req_reg_en_d2) == 1'b1) begin
    wt_req_size_d3 <= wt_req_size_d2;
  // VCS coverage off
  end else if ((wt_req_reg_en_d2) == 1'b0) begin
  end else begin
    wt_req_size_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_size_out_d3 <= {3{1'b0}};
  end else begin
  if ((wt_req_reg_en_d2) == 1'b1) begin
    wt_req_size_out_d3 <= wt_req_size_out_d2;
  // VCS coverage off
  end else if ((wt_req_reg_en_d2) == 1'b0) begin
  end else begin
    wt_req_size_out_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_done_d3 <= 1'b1;
  end else begin
  if ((wt_req_reg_en_d2) == 1'b1) begin
    wt_req_done_d3 <= (is_running & wt_req_done_d2);
  // VCS coverage off
  end else if ((wt_req_reg_en_d2) == 1'b0) begin
  end else begin
    wt_req_done_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign wt_req_src_d3 = SRC_ID_WT;

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
  nv_assert_never #(0,0,"Error! FSM done when wt fetch is not!")      zzz_assert_never_29x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~is_nxt_running & ~wt_req_done_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////// overflow control logic ///////////////////
always @(
  wt_data_onfly
  or wt_data_stored
  or wt_data_avl
  ) begin
    {mon_wt_req_sum,
     wt_req_sum} = wt_data_onfly + wt_data_stored + wt_data_avl;
end

always @(
  is_running
  or wt_req_sum
  or weight_bank
  ) begin
    wt_req_overflow = is_running && (wt_req_sum > {weight_bank, 10'b0});
end

assign wt_req_overflow_d3 = wt_req_overflow;

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
  nv_assert_never #(0,0,"Error! wt_data_onfly is not zero when idle")      zzz_assert_never_30x (nvdla_core_clk, `ASSERT_RESET, (~is_running && (|wt_data_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_data_stored is not zero when idle")      zzz_assert_never_31x (nvdla_core_clk, `ASSERT_RESET, (~is_running && (|wt_data_stored))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////// pipeline control logic ///////////////////
always @(
  layer_st
  or is_running
  or wt_req_vld_d3
  or wt_req_rdy
  ) begin
    wt_req_reg_en = layer_st | (is_running & (~wt_req_vld_d3 | wt_req_rdy)); 
end

////////////////////////////////////////////////////////////////////////
//  generate address for WMB data                                     //
////////////////////////////////////////////////////////////////////////

/////////////////// stage 1 ///////////////////
assign wmb_req_reg_en_d0 = wmb_req_reg_en;

always @(
  wmb_req_burst_cnt_d1
  or wmb_req_size_d1
  ) begin
    {mon_wmb_req_burst_cnt_dec,
     wmb_req_burst_cnt_dec} = wmb_req_burst_cnt_d1 - {{19{1'b0}}, wmb_req_size_d1};
end

always @(
  layer_st
  or reg2dp_wmb_bytes
  or wmb_req_burst_cnt_dec
  ) begin
    wmb_req_burst_cnt_w = layer_st ? {reg2dp_wmb_bytes, 2'b0} :
                          wmb_req_burst_cnt_dec;
end

always @(
  layer_st
  or reg2dp_wmb_addr_low
  ) begin
    wmb_req_size_addr_limit = layer_st ? (4'h8 - reg2dp_wmb_addr_low[2:0]) : 4'h8;
end

always @(
  wmb_req_size_addr_limit
  or wmb_req_burst_cnt_w
  ) begin
    wmb_req_size_w = ( {{19{1'b0}}, wmb_req_size_addr_limit} > wmb_req_burst_cnt_w) ? wmb_req_burst_cnt_w[3:0] :
                     wmb_req_size_addr_limit;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_req_size_d1 <= {4{1'b0}};
  end else begin
  if ((wmb_req_reg_en_d0) == 1'b1) begin
    wmb_req_size_d1 <= wmb_req_size_w;
  // VCS coverage off
  end else if ((wmb_req_reg_en_d0) == 1'b0) begin
  end else begin
    wmb_req_size_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_burst_cnt_d1 <= {23{1'b0}};
  end else begin
  if ((wmb_req_reg_en_d0) == 1'b1) begin
    wmb_req_burst_cnt_d1 <= wmb_req_burst_cnt_w;
  // VCS coverage off
  end else if ((wmb_req_reg_en_d0) == 1'b0) begin
  end else begin
    wmb_req_burst_cnt_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_33x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_stage_vld_d1 <= 1'b0;
  end else begin
  wmb_req_stage_vld_d1 <= is_nxt_running & is_compressed;
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
  nv_assert_never #(0,0,"Error!, wmb_req_burst_cnt_dec is overflow!")      zzz_assert_never_34x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wmb_req_burst_cnt_dec)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////// stage 2 ///////////////////
assign wmb_req_reg_en_d1 = wmb_req_reg_en;

always @(
  is_running
  or wmb_req_burst_cnt_d1
  or wmb_req_size_d1
  ) begin
    wmb_req_last_w = is_running & (wmb_req_burst_cnt_d1 == {{19{1'b0}}, wmb_req_size_d1});
end

always @(
  wmb_req_addr_d2
  ) begin
    wmb_req_addr_inc = wmb_req_addr_d2[58:3] + 56'b1;
end

always @(
  wmb_req_stage_vld_d2
  or reg2dp_wmb_addr_high
  or reg2dp_wmb_addr_low
  or wmb_req_addr_inc
  ) begin
    wmb_req_addr_w = (~wmb_req_stage_vld_d2) ? {reg2dp_wmb_addr_high, reg2dp_wmb_addr_low} :
                     {wmb_req_addr_inc, 3'b0};
end

always @(
  wmb_req_size_d1
  ) begin
    wmb_req_size_out_w = wmb_req_size_d1[2:0] - 3'b1;
end

always @(
  layer_st
  or is_compressed
  or wmb_req_last_d2
  or wmb_req_done_d2
  ) begin
    wmb_req_done_w = (layer_st & is_compressed) ? 1'b0 :
                     (layer_st & ~is_compressed) ? 1'b1 :
                     wmb_req_last_d2 ? 1'b1 :
                     wmb_req_done_d2;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_req_addr_d2 <= {59{1'b0}};
  end else begin
  if ((wmb_req_reg_en_d1) == 1'b1) begin
    wmb_req_addr_d2 <= wmb_req_addr_w;
  // VCS coverage off
  end else if ((wmb_req_reg_en_d1) == 1'b0) begin
  end else begin
    wmb_req_addr_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_35x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_size_d2 <= {4{1'b0}};
  end else begin
  if ((wmb_req_reg_en_d1) == 1'b1) begin
    wmb_req_size_d2 <= wmb_req_size_d1;
  // VCS coverage off
  end else if ((wmb_req_reg_en_d1) == 1'b0) begin
  end else begin
    wmb_req_size_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_36x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_size_out_d2 <= {3{1'b0}};
  end else begin
  if ((wmb_req_reg_en_d1) == 1'b1) begin
    wmb_req_size_out_d2 <= wmb_req_size_out_w;
  // VCS coverage off
  end else if ((wmb_req_reg_en_d1) == 1'b0) begin
  end else begin
    wmb_req_size_out_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_37x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_last_d2 <= 1'b0;
  end else begin
  if ((wmb_req_reg_en_d1) == 1'b1) begin
    wmb_req_last_d2 <= wmb_req_last_w;
  // VCS coverage off
  end else if ((wmb_req_reg_en_d1) == 1'b0) begin
  end else begin
    wmb_req_last_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_38x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_done_d2 <= 1'b1;
  end else begin
  if ((wmb_req_reg_en_d1) == 1'b1) begin
    wmb_req_done_d2 <= wmb_req_done_w;
  // VCS coverage off
  end else if ((wmb_req_reg_en_d1) == 1'b0) begin
  end else begin
    wmb_req_done_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_39x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_stage_vld_d2 <= 1'b0;
  end else begin
  wmb_req_stage_vld_d2 <= wmb_req_stage_vld_d1 & is_nxt_running;
  end
end

/////////////////// stage 3 ///////////////////
assign wmb_req_reg_en_d2 = wmb_req_reg_en;

always @(
  is_nxt_running
  or wmb_req_stage_vld_d2
  ) begin
    wmb_req_vld_w = is_nxt_running & wmb_req_stage_vld_d2;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_req_vld_d3 <= 1'b0;
  end else begin
  wmb_req_vld_d3 <= wmb_req_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_req_addr_d3 <= {59{1'b0}};
  end else begin
  if ((wmb_req_reg_en_d2) == 1'b1) begin
    wmb_req_addr_d3 <= wmb_req_addr_d2;
  // VCS coverage off
  end else if ((wmb_req_reg_en_d2) == 1'b0) begin
  end else begin
    wmb_req_addr_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_40x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_size_d3 <= {4{1'b0}};
  end else begin
  if ((wmb_req_reg_en_d2) == 1'b1) begin
    wmb_req_size_d3 <= wmb_req_size_d2;
  // VCS coverage off
  end else if ((wmb_req_reg_en_d2) == 1'b0) begin
  end else begin
    wmb_req_size_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_41x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_size_out_d3 <= {3{1'b0}};
  end else begin
  if ((wmb_req_reg_en_d2) == 1'b1) begin
    wmb_req_size_out_d3 <= wmb_req_size_out_d2;
  // VCS coverage off
  end else if ((wmb_req_reg_en_d2) == 1'b0) begin
  end else begin
    wmb_req_size_out_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_done_d3 <= 1'b1;
  end else begin
  if ((wmb_req_reg_en_d2) == 1'b1) begin
    wmb_req_done_d3 <= (is_running & wmb_req_done_d2);
  // VCS coverage off
  end else if ((wmb_req_reg_en_d2) == 1'b0) begin
  end else begin
    wmb_req_done_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_43x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign wmb_req_src_d3 = SRC_ID_WMB;

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
  nv_assert_never #(0,0,"Error! FSM done when wmb fetch is not!")      zzz_assert_never_44x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~is_nxt_running & ~wmb_req_done_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////// overflow control logic ///////////////////
always @(
  wmb_data_onfly
  or wmb_data_stored
  or wmb_data_avl
  ) begin
    {mon_wmb_req_sum,
     wmb_req_sum} = wmb_data_onfly + wmb_data_stored + wmb_data_avl;
end

always @(
  is_running
  or wmb_req_sum
  ) begin
    wmb_req_overflow = is_running && (wmb_req_sum > {1'b1, 10'b0});
end

assign wmb_req_overflow_d3 = wmb_req_overflow;

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
  nv_assert_never #(0,0,"Error! wmb_req_sum is overflow!")      zzz_assert_never_45x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & mon_wmb_req_sum)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_data_onfly is not zero when idle")      zzz_assert_never_46x (nvdla_core_clk, `ASSERT_RESET, (~is_running & (|wmb_data_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_data_onfly is not zero when idle")      zzz_assert_never_47x (nvdla_core_clk, `ASSERT_RESET, (~is_running & (|wmb_data_stored))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////// pipeline control logic ///////////////////
always @(
  layer_st
  or is_running
  or wmb_req_vld_d3
  or wmb_req_rdy
  ) begin
    wmb_req_reg_en = layer_st | (is_running & (~wmb_req_vld_d3 | wmb_req_rdy)); 
end

////////////////////////////////////////////////////////////////////////
//  generate address for WGS data                                     //
////////////////////////////////////////////////////////////////////////

/////////////////// stage 1 ///////////////////
always @(
  wgs_req_dword_cnt_d1
  or wgs_req_dword_d1
  ) begin
    {mon_wgs_req_dword_cnt_dec,
     wgs_req_dword_cnt_dec} = wgs_req_dword_cnt_d1 - wgs_req_dword_d1;
end

always @(
  layer_st
  or group_w
  or wgs_req_dword_cnt_dec
  ) begin
    wgs_req_dword_cnt_w = layer_st ? group_w :
                          wgs_req_dword_cnt_dec;
end

always @(
  wgs_req_dword_cnt_w
  ) begin
    wgs_req_dword_w = (10'h8 <= wgs_req_dword_cnt_w) ? 4'h8 :
                      wgs_req_dword_cnt_w[3:0];
end

always @(
  wgs_req_dword_cnt_d1
  or wgs_req_dword_d1
  ) begin
    wgs_req_done = (wgs_req_dword_cnt_d1  == {{6{1'b0}}, wgs_req_dword_d1});
end

always @(
  is_running
  or is_nxt_running
  or is_compressed
  or wgs_req_done
  or wgs_req_rdy
  or wgs_req_vld_d1
  ) begin
    wgs_req_vld_w = (~is_running & is_nxt_running) ? is_compressed :
                    (is_running & wgs_req_done & wgs_req_rdy) ? 1'b0 :
                    wgs_req_vld_d1;
end

always @(
  wgs_req_addr_d1
  ) begin
    {mon_wgs_req_addr_inc,
     wgs_req_addr_inc} = wgs_req_addr_d1 + 1'b1;
end

always @(
  layer_st
  or reg2dp_wgs_addr_high
  or reg2dp_wgs_addr_low
  or wgs_req_addr_inc
  ) begin
    wgs_req_addr_w = layer_st ? {reg2dp_wgs_addr_high,reg2dp_wgs_addr_low} :
                     wgs_req_addr_inc;
end

always @(
  layer_st
  or is_running
  or wgs_req_vld_d1
  or wgs_req_rdy
  or wgs_req_done
  ) begin
    wgs_req_reg_en = layer_st | (is_running & wgs_req_vld_d1 & wgs_req_rdy & ~wgs_req_done);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wgs_req_vld_d1 <= 1'b0;
  end else begin
  wgs_req_vld_d1 <= wgs_req_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wgs_req_dword_cnt_d1 <= {10{1'b0}};
  end else begin
  if ((wgs_req_reg_en) == 1'b1) begin
    wgs_req_dword_cnt_d1 <= wgs_req_dword_cnt_w;
  // VCS coverage off
  end else if ((wgs_req_reg_en) == 1'b0) begin
  end else begin
    wgs_req_dword_cnt_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_48x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wgs_req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wgs_req_dword_d1 <= {4{1'b0}};
  end else begin
  if ((wgs_req_reg_en) == 1'b1) begin
    wgs_req_dword_d1 <= wgs_req_dword_w;
  // VCS coverage off
  end else if ((wgs_req_reg_en) == 1'b0) begin
  end else begin
    wgs_req_dword_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_49x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wgs_req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wgs_req_addr_d1 <= {59{1'b0}};
  end else begin
  if ((wgs_req_reg_en) == 1'b1) begin
    wgs_req_addr_d1 <= wgs_req_addr_w;
  // VCS coverage off
  end else if ((wgs_req_reg_en) == 1'b0) begin
  end else begin
    wgs_req_addr_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_50x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wgs_req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign wgs_req_size_d1 = 4'h1;
assign wgs_req_size_out_d1 = 3'h0;
assign wgs_req_src_d1 = SRC_ID_WGS;

/////////////////// overflow control logic ///////////////////
always @(
  wgs_data_onfly
  or wgs_req_dword_d1
  ) begin
    {mon_wgs_req_sum,
     wgs_req_sum} = wgs_data_onfly + wgs_req_dword_d1;
end

always @(
  is_running
  or wgs_req_sum
  ) begin
    wgs_req_overflow = is_running & (wgs_req_sum > 6'h20);
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
  nv_assert_never #(0,0,"Error! wgs_data_onfly is not zero when idle")      zzz_assert_never_51x (nvdla_core_clk, `ASSERT_RESET, (~is_running & (|wgs_data_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(
  arb_wrr_in_rdy
  or arb_wrr_req_package_in_00
  or arb_wrr_req_package_in_01
  or arb_wrr_out_back_vld
  or arb_wrr_out_back_package
  ) begin
    arb_wrr_out_package_w = ({68{arb_wrr_in_rdy[0]}} & arb_wrr_req_package_in_00) |
                            ({68{arb_wrr_in_rdy[1]}} & arb_wrr_req_package_in_01) |
                            ({68{arb_wrr_out_back_vld}} & arb_wrr_out_back_package);
end


always @(
  arb_wrr_out_vld
  or arb_wrr_out_rdy
  or arb_wrr_out_back_vld
  or arb_wrr_in_vld
  ) begin
    arb_wrr_out_reg_en = (~arb_wrr_out_vld | arb_wrr_out_rdy) & (arb_wrr_out_back_vld | (|arb_wrr_in_vld));
end

always @(
  arb_wrr_out_vld
  or arb_wrr_out_rdy
  or arb_wrr_out_back_vld
  or arb_wrr_in_vld
  ) begin
    arb_wrr_out_back_reg_en = arb_wrr_out_vld & ~arb_wrr_out_rdy & ~arb_wrr_out_back_vld & (|arb_wrr_in_vld);
end

always @(
  arb_wrr_in_vld
  or arb_wrr_out_back_vld
  or arb_wrr_out_rdy
  or arb_wrr_out_vld
  ) begin
    arb_wrr_out_vld_w = ((|arb_wrr_in_vld) | arb_wrr_out_back_vld) ? 1'b1 :
                        arb_wrr_out_rdy ? 1'b0 :
                        arb_wrr_out_vld;
end

always @(
  arb_wrr_out_rdy
  or arb_wrr_out_vld
  or arb_wrr_in_vld
  or arb_wrr_out_back_vld
  ) begin
    arb_wrr_out_back_vld_w = arb_wrr_out_rdy ? 1'b0 :
                             (arb_wrr_out_vld & (|arb_wrr_in_vld)) ? 1'b1 :
                             arb_wrr_out_back_vld;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    arb_wrr_out_vld <= 1'b0;
  end else begin
  arb_wrr_out_vld <= arb_wrr_out_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    arb_wrr_out_back_vld <= 1'b0;
  end else begin
  arb_wrr_out_back_vld <= arb_wrr_out_back_vld_w;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((arb_wrr_out_reg_en) == 1'b1) begin
    arb_wrr_out_package <= arb_wrr_out_package_w;
  // VCS coverage off
  end else if ((arb_wrr_out_reg_en) == 1'b0) begin
  end else begin
    arb_wrr_out_package <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((arb_wrr_out_back_reg_en) == 1'b1) begin
    arb_wrr_out_back_package <= arb_wrr_out_package_w;
  // VCS coverage off
  end else if ((arb_wrr_out_back_reg_en) == 1'b0) begin
  end else begin
    arb_wrr_out_back_package <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

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
always @(
  arb_sp_in_rdy
  or arb_sp_req_package_in_00
  or arb_sp_req_package_in_01
  or arb_sp_out_back_vld
  or arb_sp_out_back_package
  ) begin
    arb_sp_out_package_w = ({68{arb_sp_in_rdy[0]}} & arb_sp_req_package_in_00) |
                           ({68{arb_sp_in_rdy[1]}} & arb_sp_req_package_in_01) |
                           ({68{arb_sp_out_back_vld}} & arb_sp_out_back_package);
end


always @(
  arb_sp_out_vld
  or arb_sp_out_rdy
  or arb_sp_out_back_vld
  or arb_sp_in_vld
  ) begin
    arb_sp_out_reg_en = (~arb_sp_out_vld | arb_sp_out_rdy) & (arb_sp_out_back_vld | (|arb_sp_in_vld));
end

always @(
  arb_sp_out_vld
  or arb_sp_out_rdy
  or arb_sp_out_back_vld
  or arb_sp_in_vld
  ) begin
    arb_sp_out_back_reg_en = arb_sp_out_vld & ~arb_sp_out_rdy & ~arb_sp_out_back_vld & (|arb_sp_in_vld);
end

always @(
  arb_sp_in_rdy
  or arb_sp_out_back_vld
  or arb_sp_out_rdy
  or arb_sp_out_vld
  ) begin
    arb_sp_out_vld_w = ((|arb_sp_in_rdy) | arb_sp_out_back_vld) ? 1'b1 :
                       arb_sp_out_rdy ? 1'b0 :
                       arb_sp_out_vld;
end

always @(
  arb_sp_out_rdy
  or arb_sp_out_vld
  or arb_sp_in_vld
  or arb_sp_out_back_vld
  ) begin
    arb_sp_out_back_vld_w = arb_sp_out_rdy ? 1'b0 :
                            (arb_sp_out_vld & (|arb_sp_in_vld)) ? 1'b1 :
                            arb_sp_out_back_vld;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    arb_sp_out_vld <= 1'b0;
  end else begin
  arb_sp_out_vld <= arb_sp_out_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    arb_sp_out_back_vld <= 1'b0;
  end else begin
  arb_sp_out_back_vld <= arb_sp_out_back_vld_w;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((arb_sp_out_reg_en) == 1'b1) begin
    arb_sp_out_package <= arb_sp_out_package_w;
  // VCS coverage off
  end else if ((arb_sp_out_reg_en) == 1'b0) begin
  end else begin
    arb_sp_out_package <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((arb_sp_out_back_reg_en) == 1'b1) begin
    arb_sp_out_back_package <= arb_sp_out_package_w;
  // VCS coverage off
  end else if ((arb_sp_out_back_reg_en) == 1'b0) begin
  end else begin
    arb_sp_out_back_package <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
    
///////////////////////////// Connect to Static Arbiter ////////////////////////////////
assign arb_sp_in_vld[0] = wgs_req_vld_d1 & ~wgs_req_overflow;
assign arb_sp_in_vld[1] = arb_wrr_out_vld;

assign wgs_req_rdy = arb_sp_in_rdy[0];
assign arb_wrr_out_rdy = arb_sp_in_rdy[1];

assign arb_sp_req_package_in_00 = {wgs_req_src_d1, wgs_req_size_d1, wgs_req_size_out_d1, wgs_req_addr_d1};
assign arb_sp_req_package_in_01 = arb_wrr_out_package;

///////////////////////////// connect to dma ////////////////////////////////

always @(
  dma_rd_req_rdy
  or dma_req_fifo_ready
  ) begin
    arb_sp_out_rdy = dma_rd_req_rdy & dma_req_fifo_ready;
end

always @(
  arb_sp_out_package
  ) begin
    {dma_req_src, dma_req_size, dma_req_size_out, dma_req_addr} = arb_sp_out_package;
end

////////////////////////////////////////////////////////////////////////
//  CDMA WT read request interface                                    //
////////////////////////////////////////////////////////////////////////

// rd Channel: Request 
assign cv_dma_rd_req_vld = dma_rd_req_vld & (dma_rd_req_type == 1'b0);
assign mc_dma_rd_req_vld = dma_rd_req_vld & (dma_rd_req_type == 1'b1);
assign cv_rd_req_rdyi = cv_dma_rd_req_rdy & (dma_rd_req_type == 1'b0);
assign mc_rd_req_rdyi = mc_dma_rd_req_rdy & (dma_rd_req_type == 1'b1);
assign rd_req_rdyi = mc_rd_req_rdyi | cv_rd_req_rdyi;
assign dma_rd_req_rdy= rd_req_rdyi;
NV_NVDLA_CDMA_WT_pipe_p1 pipe_p1 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dma_rd_req_pd       (dma_rd_req_pd[78:0])     //|< w
  ,.mc_dma_rd_req_vld   (mc_dma_rd_req_vld)       //|< w
  ,.mc_int_rd_req_ready (mc_int_rd_req_ready)     //|< w
  ,.mc_dma_rd_req_rdy   (mc_dma_rd_req_rdy)       //|> w
  ,.mc_int_rd_req_pd    (mc_int_rd_req_pd[78:0])  //|> w
  ,.mc_int_rd_req_valid (mc_int_rd_req_valid)     //|> w
  );
NV_NVDLA_CDMA_WT_pipe_p2 pipe_p2 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.cv_dma_rd_req_vld   (cv_dma_rd_req_vld)       //|< w
  ,.cv_int_rd_req_ready (cv_int_rd_req_ready)     //|< w
  ,.dma_rd_req_pd       (dma_rd_req_pd[78:0])     //|< w
  ,.cv_dma_rd_req_rdy   (cv_dma_rd_req_rdy)       //|> w
  ,.cv_int_rd_req_pd    (cv_int_rd_req_pd[78:0])  //|> w
  ,.cv_int_rd_req_valid (cv_int_rd_req_valid)     //|> w
  );

assign mc_int_rd_req_valid_d0 = mc_int_rd_req_valid;
assign mc_int_rd_req_ready = mc_int_rd_req_ready_d0;
assign mc_int_rd_req_pd_d0[78:0] = mc_int_rd_req_pd[78:0];
assign cdma_wt2mcif_rd_req_valid = mc_int_rd_req_valid_d0;
assign mc_int_rd_req_ready_d0 = cdma_wt2mcif_rd_req_ready;
assign cdma_wt2mcif_rd_req_pd[78:0] = mc_int_rd_req_pd_d0[78:0];


assign cv_int_rd_req_valid_d0 = cv_int_rd_req_valid;
assign cv_int_rd_req_ready = cv_int_rd_req_ready_d0;
assign cv_int_rd_req_pd_d0[78:0] = cv_int_rd_req_pd[78:0];
assign cdma_wt2cvif_rd_req_valid = cv_int_rd_req_valid_d0;
assign cv_int_rd_req_ready_d0 = cdma_wt2cvif_rd_req_ready;
assign cdma_wt2cvif_rd_req_pd[78:0] = cv_int_rd_req_pd_d0[78:0];

// rd Channel: Response

assign mcif2cdma_wt_rd_rsp_valid_d0 = mcif2cdma_wt_rd_rsp_valid;
assign mcif2cdma_wt_rd_rsp_ready = mcif2cdma_wt_rd_rsp_ready_d0;
assign mcif2cdma_wt_rd_rsp_pd_d0[513:0] = mcif2cdma_wt_rd_rsp_pd[513:0];
assign mc_int_rd_rsp_valid = mcif2cdma_wt_rd_rsp_valid_d0;
assign mcif2cdma_wt_rd_rsp_ready_d0 = mc_int_rd_rsp_ready;
assign mc_int_rd_rsp_pd[513:0] = mcif2cdma_wt_rd_rsp_pd_d0[513:0];


assign cvif2cdma_wt_rd_rsp_valid_d0 = cvif2cdma_wt_rd_rsp_valid;
assign cvif2cdma_wt_rd_rsp_ready = cvif2cdma_wt_rd_rsp_ready_d0;
assign cvif2cdma_wt_rd_rsp_pd_d0[513:0] = cvif2cdma_wt_rd_rsp_pd[513:0];
assign cv_int_rd_rsp_valid = cvif2cdma_wt_rd_rsp_valid_d0;
assign cvif2cdma_wt_rd_rsp_ready_d0 = cv_int_rd_rsp_ready;
assign cv_int_rd_rsp_pd[513:0] = cvif2cdma_wt_rd_rsp_pd_d0[513:0];

NV_NVDLA_CDMA_WT_pipe_p3 pipe_p3 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dma_rd_rsp_rdy      (dma_rd_rsp_rdy)          //|< w
  ,.mc_int_rd_rsp_pd    (mc_int_rd_rsp_pd[513:0]) //|< w
  ,.mc_int_rd_rsp_valid (mc_int_rd_rsp_valid)     //|< w
  ,.mc_dma_rd_rsp_pd    (mc_dma_rd_rsp_pd[513:0]) //|> w
  ,.mc_dma_rd_rsp_vld   (mc_dma_rd_rsp_vld)       //|> w
  ,.mc_int_rd_rsp_ready (mc_int_rd_rsp_ready)     //|> w
  );
NV_NVDLA_CDMA_WT_pipe_p4 pipe_p4 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.cv_int_rd_rsp_pd    (cv_int_rd_rsp_pd[513:0]) //|< w
  ,.cv_int_rd_rsp_valid (cv_int_rd_rsp_valid)     //|< w
  ,.dma_rd_rsp_rdy      (dma_rd_rsp_rdy)          //|< w
  ,.cv_dma_rd_rsp_pd    (cv_dma_rd_rsp_pd[513:0]) //|> w
  ,.cv_dma_rd_rsp_vld   (cv_dma_rd_rsp_vld)       //|> w
  ,.cv_int_rd_rsp_ready (cv_int_rd_rsp_ready)     //|> w
  );
assign dma_rd_rsp_vld = mc_dma_rd_rsp_vld | cv_dma_rd_rsp_vld;
assign dma_rd_rsp_pd = ({514{mc_dma_rd_rsp_vld}} & mc_dma_rd_rsp_pd) 
                        | ({514{cv_dma_rd_rsp_vld}} & cv_dma_rd_rsp_pd);

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
  nv_assert_never #(0,0,"DMAIF: mcif and cvif should never return data both")      zzz_assert_never_52x (nvdla_core_clk, `ASSERT_RESET, mc_dma_rd_rsp_vld & cv_dma_rd_rsp_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
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



// PKT_PACK_WIRE( dma_read_cmd , dma_rd_req_ , dma_rd_req_pd )
assign      dma_rd_req_pd[63:0] =    dma_rd_req_addr[63:0];
assign      dma_rd_req_pd[78:64] =    dma_rd_req_size[14:0];
assign dma_rd_req_vld = arb_sp_out_vld & dma_req_fifo_ready;
assign dma_rd_req_addr = {dma_req_addr[58:0], 5'b0};
assign dma_rd_req_size = {{12{1'b0}}, dma_req_size_out};
assign dma_rd_req_type = reg2dp_weight_ram_type;
assign dma_rd_rsp_rdy = ~wgs_push_req;


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

always @(
  arb_sp_out_vld
  or dma_rd_req_rdy
  ) begin
    dma_req_fifo_req = arb_sp_out_vld & dma_rd_req_rdy;
end

always @(
  dma_req_src
  or dma_req_size
  ) begin
    dma_req_fifo_data = {dma_req_src, dma_req_size};
end

////////////////////////////////////////////////////////////////////////
//  For verfification/debug                                           //
////////////////////////////////////////////////////////////////////////
assign dbg_src_rd_ptr_en = (cdma_wt2mcif_rd_req_valid & cdma_wt2mcif_rd_req_ready) | (cdma_wt2cvif_rd_req_valid & cdma_wt2cvif_rd_req_ready);
assign dbg_src_rd_ptr_w = ~layer_st & (dbg_src_rd_ptr ^ dbg_src_rd_ptr_en);
assign dbg_src_wr_ptr_en = (dma_rd_req_vld & dma_req_fifo_ready & dma_rd_req_rdy);
assign dbg_src_wr_ptr_w = ~layer_st & (dbg_src_wr_ptr ^ dbg_src_wr_ptr_en);
assign dbg_dma_req_src = dbg_src_rd_ptr ? dbg_dma_req_src_b1 : dbg_dma_req_src_b0;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_src_rd_ptr <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  dbg_src_rd_ptr <= dbg_src_rd_ptr_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_src_wr_ptr <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  dbg_src_wr_ptr <= dbg_src_wr_ptr_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_dma_req_src_b0 <= {2{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((dbg_src_wr_ptr_en & ~dbg_src_wr_ptr) == 1'b1) begin
    dbg_dma_req_src_b0 <= dma_req_src;
  // VCS coverage off
  end else if ((dbg_src_wr_ptr_en & ~dbg_src_wr_ptr) == 1'b0) begin
  end else begin
    dbg_dma_req_src_b0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbg_src_wr_ptr_en & ~dbg_src_wr_ptr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_dma_req_src_b1 <= {2{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((dbg_src_wr_ptr_en & dbg_src_wr_ptr) == 1'b1) begin
    dbg_dma_req_src_b1 <= dma_req_src;
  // VCS coverage off
  end else if ((dbg_src_wr_ptr_en & dbg_src_wr_ptr) == 1'b0) begin
  end else begin
    dbg_dma_req_src_b1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_54x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbg_src_wr_ptr_en & dbg_src_wr_ptr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  CDMA read response connection                                     //
////////////////////////////////////////////////////////////////////////


// PKT_UNPACK_WIRE( dma_read_data , dma_rd_rsp_ , dma_rd_rsp_pd )
assign       dma_rd_rsp_data[511:0] =    dma_rd_rsp_pd[511:0];
assign       dma_rd_rsp_mask[1:0] =    dma_rd_rsp_pd[513:512];
always @(
  dma_rsp_fifo_data
  ) begin
    {dma_rsp_src, dma_rsp_size} = dma_rsp_fifo_data;
end

always @(
  dma_rsp_size_cnt
  or dma_rd_rsp_mask
  ) begin
    {mon_dma_rsp_size_cnt_inc,
     dma_rsp_size_cnt_inc} = dma_rsp_size_cnt + dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1];
end

always @(
  dma_rsp_size_cnt_inc
  or dma_rsp_size
  ) begin
    dma_rsp_size_cnt_w = (dma_rsp_size_cnt_inc == dma_rsp_size) ? 4'b0 :
                         dma_rsp_size_cnt_inc;
end

always @(
  dma_rd_rsp_vld
  or dma_rd_rsp_rdy
  or dma_rsp_size_cnt_inc
  or dma_rsp_size
  ) begin
    dma_rsp_fifo_ready = (dma_rd_rsp_vld & dma_rd_rsp_rdy & (dma_rsp_size_cnt_inc == dma_rsp_size));
end

always @(
  dma_rd_rsp_vld
  or dma_rd_rsp_rdy
  or dma_rsp_src
  ) begin
    wt_rsp_valid = (dma_rd_rsp_vld & dma_rd_rsp_rdy & (dma_rsp_src == SRC_ID_WT));
end
always @(
  dma_rd_rsp_vld
  or dma_rd_rsp_rdy
  or dma_rsp_src
  ) begin
    wmb_rsp_valid = (dma_rd_rsp_vld & dma_rd_rsp_rdy & (dma_rsp_src == SRC_ID_WMB));
end
always @(
  dma_rd_rsp_vld
  or dma_rd_rsp_rdy
  or dma_rsp_src
  ) begin
    wgs_rsp_valid = (dma_rd_rsp_vld & dma_rd_rsp_rdy & (dma_rsp_src == SRC_ID_WGS));
end

always @(
  dma_rd_rsp_data
  ) begin
    {dma_rsp_data_p1, dma_rsp_data_p0} = dma_rd_rsp_data;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dma_rsp_size_cnt <= {4{1'b0}};
  end else begin
  if ((dma_rd_rsp_vld & dma_rd_rsp_rdy) == 1'b1) begin
    dma_rsp_size_cnt <= dma_rsp_size_cnt_w;
  // VCS coverage off
  end else if ((dma_rd_rsp_vld & dma_rd_rsp_rdy) == 1'b0) begin
  end else begin
    dma_rsp_size_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_55x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dma_rd_rsp_vld & dma_rd_rsp_rdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"response fifo pop error")      zzz_assert_never_56x (nvdla_core_clk, `ASSERT_RESET, (dma_rsp_fifo_ready & ~dma_rsp_fifo_req)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"response size mismatch")      zzz_assert_never_57x (nvdla_core_clk, `ASSERT_RESET, (dma_rd_rsp_vld & dma_rd_rsp_rdy & (dma_rsp_size_cnt_inc > dma_rsp_size))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! dma_rsp_size_cnt_inc is overflow")      zzz_assert_never_58x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & mon_dma_rsp_size_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! dma_rsp_size_cnt_inc is out of range")      zzz_assert_never_59x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (dma_rsp_size_cnt_inc > 8'h8))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  WT read data                                                      //
////////////////////////////////////////////////////////////////////////

always @(
  dma_rd_rsp_mask
  or wt_local_data_vld
  ) begin
    wt_local_data_cnt = dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1] + wt_local_data_vld;
end

always @(
  wt_local_data_cnt
  ) begin
    wt_local_data_vld_w = wt_local_data_cnt[0];
end

always @(
  wt_rsp_valid
  or wt_local_data_cnt
  ) begin
    wt_local_data_reg_en = wt_rsp_valid & wt_local_data_cnt[0];
end

always @(
  wt_cbuf_wr_idx
  ) begin
    wt_cbuf_wr_idx_inc = wt_cbuf_wr_idx + 1'b1;
end

always @(
  wt_rsp_valid
  or wt_local_data_cnt
  ) begin
    wt_cbuf_wr_vld_w = wt_rsp_valid & wt_local_data_cnt[1];
end

always @(
  layer_st
  or wt_cbuf_wr_idx
  ) begin
    wt_cbuf_wr_idx_set = (layer_st & ~(|wt_cbuf_wr_idx));
end

always @(
  wt_cbuf_wr_idx_inc
  or weight_bank_end
  ) begin
    wt_cbuf_wr_idx_wrap = (wt_cbuf_wr_idx_inc == {weight_bank_end, 9'b0});
end

always @(
  clear_all
  or wt_cbuf_wr_idx_set
  or wt_cbuf_wr_idx_wrap
  or data_bank_w
  or wt_cbuf_wr_idx_inc
  ) begin
    wt_cbuf_wr_idx_w = (clear_all | wt_cbuf_wr_idx_set | wt_cbuf_wr_idx_wrap) ? {data_bank_w, 9'b0} :
                       wt_cbuf_wr_idx_inc[(1  + 12 ) -1:0];
end

always @(
  wt_local_data_vld
  or dma_rsp_data_p0
  or wt_local_data
  or dma_rsp_data_p1
  ) begin
    wt_cbuf_wr_data_ori_w = wt_local_data_vld ? {dma_rsp_data_p0, wt_local_data} :
                           {dma_rsp_data_p1, dma_rsp_data_p0};
end

always @(
  nan_pass
  or wt_cbuf_wr_data_ori_w
  or wt_nan_mask
  ) begin
    wt_cbuf_wr_data_w = nan_pass ? wt_cbuf_wr_data_ori_w :
                        (wt_cbuf_wr_data_ori_w & wt_nan_mask);
end

always @(
  dma_rd_rsp_mask
  or dma_rsp_data_p1
  or dma_rsp_data_p0
  ) begin
    wt_local_data_w = dma_rd_rsp_mask[1] ? dma_rsp_data_p1 : dma_rsp_data_p0;
end

always @(posedge nvdla_core_clk) begin
  if ((wt_local_data_reg_en) == 1'b1) begin
    wt_local_data <= wt_local_data_w;
  // VCS coverage off
  end else if ((wt_local_data_reg_en) == 1'b0) begin
  end else begin
    wt_local_data <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_local_data_vld <= 1'b0;
  end else begin
  if ((wt_rsp_valid) == 1'b1) begin
    wt_local_data_vld <= wt_local_data_vld_w;
  // VCS coverage off
  end else if ((wt_rsp_valid) == 1'b0) begin
  end else begin
    wt_local_data_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_60x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_cbuf_wr_idx <= {13{1'b0}};
  end else begin
  if ((wt_cbuf_wr_idx_set | clear_all | wt_cbuf_wr_vld_w) == 1'b1) begin
    wt_cbuf_wr_idx <= wt_cbuf_wr_idx_w;
  // VCS coverage off
  end else if ((wt_cbuf_wr_idx_set | clear_all | wt_cbuf_wr_vld_w) == 1'b0) begin
  end else begin
    wt_cbuf_wr_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_61x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_cbuf_wr_idx_set | clear_all | wt_cbuf_wr_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  WMB read data                                                     //
////////////////////////////////////////////////////////////////////////

always @(
  dma_rd_rsp_mask
  or wmb_local_data_vld
  ) begin
    wmb_local_data_cnt = dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1] + wmb_local_data_vld;
end

always @(
  wmb_local_data_cnt
  ) begin
    wmb_local_data_vld_w = wmb_local_data_cnt[0];
end

always @(
  wmb_rsp_valid
  or wmb_local_data_cnt
  ) begin
    wmb_local_data_reg_en = wmb_rsp_valid & wmb_local_data_cnt[0];
end

always @(
  wmb_cbuf_wr_idx
  ) begin
    {mon_wmb_cbuf_wr_idx_inc,
     wmb_cbuf_wr_idx_inc} = wmb_cbuf_wr_idx[(1  + 8 ) -1:0] + 1'b1;
end

always @(
  wmb_rsp_valid
  or wmb_local_data_cnt
  ) begin
    wmb_cbuf_wr_vld_w = wmb_rsp_valid & wmb_local_data_cnt[1];
end

always @(
  clear_all
  or wmb_cbuf_wr_idx_inc
  ) begin
    wmb_cbuf_wr_idx_w = (clear_all) ? {~{4'b0}, 9'b0} :
                        {~{4'b0}, wmb_cbuf_wr_idx_inc};
end

always @(
  wmb_local_data_vld
  or dma_rsp_data_p0
  or wmb_local_data
  or dma_rsp_data_p1
  ) begin
    wmb_cbuf_wr_data_w = wmb_local_data_vld ? {dma_rsp_data_p0, wmb_local_data} :
                        {dma_rsp_data_p1, dma_rsp_data_p0};
end

always @(
  dma_rd_rsp_mask
  or dma_rsp_data_p1
  or dma_rsp_data_p0
  ) begin
    wmb_local_data_w = dma_rd_rsp_mask[1] ? dma_rsp_data_p1 : dma_rsp_data_p0;
end

always @(posedge nvdla_core_clk) begin
  if ((wmb_local_data_reg_en) == 1'b1) begin
    wmb_local_data <= wmb_local_data_w;
  // VCS coverage off
  end else if ((wmb_local_data_reg_en) == 1'b0) begin
  end else begin
    wmb_local_data <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_local_data_vld <= 1'b0;
  end else begin
  if ((wmb_rsp_valid) == 1'b1) begin
    wmb_local_data_vld <= wmb_local_data_vld_w;
  // VCS coverage off
  end else if ((wmb_rsp_valid) == 1'b0) begin
  end else begin
    wmb_local_data_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_62x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_cbuf_wr_idx <= {~{4'b0}, 9'b0};
  end else begin
  if ((clear_all | wmb_cbuf_wr_vld_w) == 1'b1) begin
    wmb_cbuf_wr_idx <= wmb_cbuf_wr_idx_w;
  // VCS coverage off
  end else if ((clear_all | wmb_cbuf_wr_vld_w) == 1'b0) begin
  end else begin
    wmb_cbuf_wr_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_63x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(clear_all | wmb_cbuf_wr_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  WGS read data                                                     //
////////////////////////////////////////////////////////////////////////

always @(
  wgs_push_cnt
  ) begin
    {mon_wgs_push_cnt_inc,
     wgs_push_cnt_inc} = wgs_push_cnt + 1'b1;
end

always @(
  wgs_push_cnt_inc
  or group
  ) begin
    wgs_push_last = (wgs_push_cnt_inc == group);
end

always @(
  layer_st
  or wgs_push_cnt_inc
  ) begin
    wgs_push_cnt_w = layer_st ? 10'b0 :
                     wgs_push_cnt_inc;
end

always @(
  wgs_rsp_valid
  or wgs_push_cnt
  or wgs_push_last
  or wgs_push_req
  ) begin
    wgs_push_req_w = (wgs_rsp_valid) ? 1'b1 :
                     ((wgs_push_cnt[2:0] == 3'h7) | wgs_push_last) ? 1'b0 :
                     wgs_push_req;
end

always @(
  wgs_local_data
  or wgs_push_cnt
  ) begin
    {mon_wgs_push_data,
     wgs_push_data} = (wgs_local_data >> {wgs_push_cnt[2:0], 5'b0});
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wgs_push_cnt <= {10{1'b0}};
  end else begin
  if ((layer_st | wgs_push_req) == 1'b1) begin
    wgs_push_cnt <= wgs_push_cnt_w;
  // VCS coverage off
  end else if ((layer_st | wgs_push_req) == 1'b0) begin
  end else begin
    wgs_push_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_64x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wgs_push_req))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  if ((wgs_rsp_valid) == 1'b1) begin
    wgs_local_data <= dma_rsp_data_p0;
  // VCS coverage off
  end else if ((wgs_rsp_valid) == 1'b0) begin
  end else begin
    wgs_local_data <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wgs_push_req <= 1'b0;
  end else begin
  wgs_push_req <= wgs_push_req_w;
  end
end


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

always @(
  is_compressed
  or status_update
  ) begin
    wgs_pop_ready = is_compressed & status_update;
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
  nv_assert_never #(0,0,"WGS FIFO overflow")      zzz_assert_never_65x (nvdla_core_clk, `ASSERT_RESET, (wgs_push_req & ~wgs_push_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  weight buffer flushing logic                                      //
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//  Non-SLCG clock domain                                             //
////////////////////////////////////////////////////////////////////////


always @(
  wt_cbuf_flush_idx
  ) begin
    {mon_wt_cbuf_flush_idx_w,
     wt_cbuf_flush_idx_w} = wt_cbuf_flush_idx + 1'b1;
end

always @(
  wt_cbuf_flush_idx
  ) begin
    wt_cbuf_flush_vld_w = ~wt_cbuf_flush_idx[(1  + 12 ) -1];
end

assign dp2reg_wt_flush_done = wt_cbuf_flush_idx[(1  + 12 ) -1];

always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_cbuf_flush_idx <= {13{1'b0}};
  end else begin
  if ((wt_cbuf_flush_vld_w) == 1'b1) begin
    wt_cbuf_flush_idx <= wt_cbuf_flush_idx_w;
  // VCS coverage off
  end else if ((wt_cbuf_flush_vld_w) == 1'b0) begin
  end else begin
    wt_cbuf_flush_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_66x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(wt_cbuf_flush_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  WT and WMB write to convolution buffer                            //
////////////////////////////////////////////////////////////////////////
always @(
  wt_cbuf_wr_vld_w
  or wmb_cbuf_wr_vld_w
  or wt_cbuf_flush_vld_w
  ) begin
    cdma2buf_wt_wr_en_w = wt_cbuf_wr_vld_w | wmb_cbuf_wr_vld_w | wt_cbuf_flush_vld_w;
end

always @(
  wt_cbuf_wr_vld_w
  or wt_cbuf_wr_idx
  or wmb_cbuf_wr_vld_w
  or wmb_cbuf_wr_idx
  or wt_cbuf_flush_idx
  ) begin
    cdma2buf_wt_wr_addr_w = wt_cbuf_wr_vld_w ? wt_cbuf_wr_idx[(1  + 12 ) -1:1] :
                            wmb_cbuf_wr_vld_w ? wmb_cbuf_wr_idx[(1  + 12 ) -1:1] :
                            {1'b1, wt_cbuf_flush_idx[(1  + 12 ) -2:1]};
end

always @(
  wt_cbuf_wr_vld_w
  or wt_cbuf_wr_idx
  or wmb_cbuf_wr_vld_w
  or wmb_cbuf_wr_idx
  or wt_cbuf_flush_idx
  ) begin
    cdma2buf_wt_wr_hsel_w = wt_cbuf_wr_vld_w ? wt_cbuf_wr_idx[0] :
                            wmb_cbuf_wr_vld_w ? wmb_cbuf_wr_idx[0] :
                            wt_cbuf_flush_idx[0];
end

always @(
  wt_cbuf_wr_vld_w
  or wt_cbuf_wr_data_w
  or wmb_cbuf_wr_vld_w
  or wmb_cbuf_wr_data_w
  ) begin
    cdma2buf_wt_wr_data_w = wt_cbuf_wr_vld_w ? wt_cbuf_wr_data_w :
                            wmb_cbuf_wr_vld_w ? wmb_cbuf_wr_data_w :
                            512'b0;
end

always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdma2buf_wt_wr_en <= 1'b0;
  end else begin
  cdma2buf_wt_wr_en <= cdma2buf_wt_wr_en_w;
  end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdma2buf_wt_wr_addr <= {12{1'b0}};
  end else begin
  if ((cdma2buf_wt_wr_en_w) == 1'b1) begin
    cdma2buf_wt_wr_addr <= cdma2buf_wt_wr_addr_w;
  // VCS coverage off
  end else if ((cdma2buf_wt_wr_en_w) == 1'b0) begin
  end else begin
    cdma2buf_wt_wr_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_67x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cdma2buf_wt_wr_en_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdma2buf_wt_wr_hsel <= 1'b0;
  end else begin
  if ((cdma2buf_wt_wr_en_w) == 1'b1) begin
    cdma2buf_wt_wr_hsel <= cdma2buf_wt_wr_hsel_w;
  // VCS coverage off
  end else if ((cdma2buf_wt_wr_en_w) == 1'b0) begin
  end else begin
    cdma2buf_wt_wr_hsel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_68x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cdma2buf_wt_wr_en_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  Non-SLCG clock domain end                                         //
////////////////////////////////////////////////////////////////////////


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdma2buf_wt_wr_data <= {512{1'b0}};
  end else begin
  if ((cdma2buf_wt_wr_en_w) == 1'b1) begin
    cdma2buf_wt_wr_data <= cdma2buf_wt_wr_data_w;
  // VCS coverage off
  end else if ((cdma2buf_wt_wr_en_w) == 1'b0) begin
  end else begin
    cdma2buf_wt_wr_data <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_69x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cdma2buf_wt_wr_en_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"WT and WMB write hazard")      zzz_assert_never_70x (nvdla_core_clk, `ASSERT_RESET, (wt_cbuf_wr_vld_w & wmb_cbuf_wr_vld_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"WT and FLUSH write hazard")      zzz_assert_never_71x (nvdla_core_clk, `ASSERT_RESET, (wt_cbuf_wr_vld_w & wt_cbuf_flush_vld_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"WMB and FLUSH write hazard")      zzz_assert_never_72x (nvdla_core_clk, `ASSERT_RESET, (wt_cbuf_flush_vld_w & wmb_cbuf_wr_vld_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  Infinity and NaN counting logic                                   //
////////////////////////////////////////////////////////////////////////
always @(
  wt_cbuf_wr_data_ori_w
  ) begin
    wt_fp16_exp_flag_w[0] = (&wt_cbuf_wr_data_ori_w[14:10]);
    wt_fp16_exp_flag_w[1] = (&wt_cbuf_wr_data_ori_w[30:26]);
    wt_fp16_exp_flag_w[2] = (&wt_cbuf_wr_data_ori_w[46:42]);
    wt_fp16_exp_flag_w[3] = (&wt_cbuf_wr_data_ori_w[62:58]);
    wt_fp16_exp_flag_w[4] = (&wt_cbuf_wr_data_ori_w[78:74]);
    wt_fp16_exp_flag_w[5] = (&wt_cbuf_wr_data_ori_w[94:90]);
    wt_fp16_exp_flag_w[6] = (&wt_cbuf_wr_data_ori_w[110:106]);
    wt_fp16_exp_flag_w[7] = (&wt_cbuf_wr_data_ori_w[126:122]);
    wt_fp16_exp_flag_w[8] = (&wt_cbuf_wr_data_ori_w[142:138]);
    wt_fp16_exp_flag_w[9] = (&wt_cbuf_wr_data_ori_w[158:154]);
    wt_fp16_exp_flag_w[10] = (&wt_cbuf_wr_data_ori_w[174:170]);
    wt_fp16_exp_flag_w[11] = (&wt_cbuf_wr_data_ori_w[190:186]);
    wt_fp16_exp_flag_w[12] = (&wt_cbuf_wr_data_ori_w[206:202]);
    wt_fp16_exp_flag_w[13] = (&wt_cbuf_wr_data_ori_w[222:218]);
    wt_fp16_exp_flag_w[14] = (&wt_cbuf_wr_data_ori_w[238:234]);
    wt_fp16_exp_flag_w[15] = (&wt_cbuf_wr_data_ori_w[254:250]);
    wt_fp16_exp_flag_w[16] = (&wt_cbuf_wr_data_ori_w[270:266]);
    wt_fp16_exp_flag_w[17] = (&wt_cbuf_wr_data_ori_w[286:282]);
    wt_fp16_exp_flag_w[18] = (&wt_cbuf_wr_data_ori_w[302:298]);
    wt_fp16_exp_flag_w[19] = (&wt_cbuf_wr_data_ori_w[318:314]);
    wt_fp16_exp_flag_w[20] = (&wt_cbuf_wr_data_ori_w[334:330]);
    wt_fp16_exp_flag_w[21] = (&wt_cbuf_wr_data_ori_w[350:346]);
    wt_fp16_exp_flag_w[22] = (&wt_cbuf_wr_data_ori_w[366:362]);
    wt_fp16_exp_flag_w[23] = (&wt_cbuf_wr_data_ori_w[382:378]);
    wt_fp16_exp_flag_w[24] = (&wt_cbuf_wr_data_ori_w[398:394]);
    wt_fp16_exp_flag_w[25] = (&wt_cbuf_wr_data_ori_w[414:410]);
    wt_fp16_exp_flag_w[26] = (&wt_cbuf_wr_data_ori_w[430:426]);
    wt_fp16_exp_flag_w[27] = (&wt_cbuf_wr_data_ori_w[446:442]);
    wt_fp16_exp_flag_w[28] = (&wt_cbuf_wr_data_ori_w[462:458]);
    wt_fp16_exp_flag_w[29] = (&wt_cbuf_wr_data_ori_w[478:474]);
    wt_fp16_exp_flag_w[30] = (&wt_cbuf_wr_data_ori_w[494:490]);
    wt_fp16_exp_flag_w[31] = (&wt_cbuf_wr_data_ori_w[510:506]);
end

always @(
  wt_cbuf_wr_data_ori_w
  ) begin
    wt_fp16_manti_flag_w[0] = (|wt_cbuf_wr_data_ori_w[9:0]);
    wt_fp16_manti_flag_w[1] = (|wt_cbuf_wr_data_ori_w[25:16]);
    wt_fp16_manti_flag_w[2] = (|wt_cbuf_wr_data_ori_w[41:32]);
    wt_fp16_manti_flag_w[3] = (|wt_cbuf_wr_data_ori_w[57:48]);
    wt_fp16_manti_flag_w[4] = (|wt_cbuf_wr_data_ori_w[73:64]);
    wt_fp16_manti_flag_w[5] = (|wt_cbuf_wr_data_ori_w[89:80]);
    wt_fp16_manti_flag_w[6] = (|wt_cbuf_wr_data_ori_w[105:96]);
    wt_fp16_manti_flag_w[7] = (|wt_cbuf_wr_data_ori_w[121:112]);
    wt_fp16_manti_flag_w[8] = (|wt_cbuf_wr_data_ori_w[137:128]);
    wt_fp16_manti_flag_w[9] = (|wt_cbuf_wr_data_ori_w[153:144]);
    wt_fp16_manti_flag_w[10] = (|wt_cbuf_wr_data_ori_w[169:160]);
    wt_fp16_manti_flag_w[11] = (|wt_cbuf_wr_data_ori_w[185:176]);
    wt_fp16_manti_flag_w[12] = (|wt_cbuf_wr_data_ori_w[201:192]);
    wt_fp16_manti_flag_w[13] = (|wt_cbuf_wr_data_ori_w[217:208]);
    wt_fp16_manti_flag_w[14] = (|wt_cbuf_wr_data_ori_w[233:224]);
    wt_fp16_manti_flag_w[15] = (|wt_cbuf_wr_data_ori_w[249:240]);
    wt_fp16_manti_flag_w[16] = (|wt_cbuf_wr_data_ori_w[265:256]);
    wt_fp16_manti_flag_w[17] = (|wt_cbuf_wr_data_ori_w[281:272]);
    wt_fp16_manti_flag_w[18] = (|wt_cbuf_wr_data_ori_w[297:288]);
    wt_fp16_manti_flag_w[19] = (|wt_cbuf_wr_data_ori_w[313:304]);
    wt_fp16_manti_flag_w[20] = (|wt_cbuf_wr_data_ori_w[329:320]);
    wt_fp16_manti_flag_w[21] = (|wt_cbuf_wr_data_ori_w[345:336]);
    wt_fp16_manti_flag_w[22] = (|wt_cbuf_wr_data_ori_w[361:352]);
    wt_fp16_manti_flag_w[23] = (|wt_cbuf_wr_data_ori_w[377:368]);
    wt_fp16_manti_flag_w[24] = (|wt_cbuf_wr_data_ori_w[393:384]);
    wt_fp16_manti_flag_w[25] = (|wt_cbuf_wr_data_ori_w[409:400]);
    wt_fp16_manti_flag_w[26] = (|wt_cbuf_wr_data_ori_w[425:416]);
    wt_fp16_manti_flag_w[27] = (|wt_cbuf_wr_data_ori_w[441:432]);
    wt_fp16_manti_flag_w[28] = (|wt_cbuf_wr_data_ori_w[457:448]);
    wt_fp16_manti_flag_w[29] = (|wt_cbuf_wr_data_ori_w[473:464]);
    wt_fp16_manti_flag_w[30] = (|wt_cbuf_wr_data_ori_w[489:480]);
    wt_fp16_manti_flag_w[31] = (|wt_cbuf_wr_data_ori_w[505:496]);
end


always @(
  wt_fp16_exp_flag_w
  or wt_fp16_manti_flag_w
  ) begin
    wt_fp16_nan_flag_w = wt_fp16_exp_flag_w & wt_fp16_manti_flag_w;
    wt_fp16_inf_flag_w = wt_fp16_exp_flag_w & ~wt_fp16_manti_flag_w;
end

always @(
  wt_fp16_nan_flag_w
  ) begin
    wt_nan_mask[15:0] = {16{~wt_fp16_nan_flag_w[0]}};
    wt_nan_mask[31:16] = {16{~wt_fp16_nan_flag_w[1]}};
    wt_nan_mask[47:32] = {16{~wt_fp16_nan_flag_w[2]}};
    wt_nan_mask[63:48] = {16{~wt_fp16_nan_flag_w[3]}};
    wt_nan_mask[79:64] = {16{~wt_fp16_nan_flag_w[4]}};
    wt_nan_mask[95:80] = {16{~wt_fp16_nan_flag_w[5]}};
    wt_nan_mask[111:96] = {16{~wt_fp16_nan_flag_w[6]}};
    wt_nan_mask[127:112] = {16{~wt_fp16_nan_flag_w[7]}};
    wt_nan_mask[143:128] = {16{~wt_fp16_nan_flag_w[8]}};
    wt_nan_mask[159:144] = {16{~wt_fp16_nan_flag_w[9]}};
    wt_nan_mask[175:160] = {16{~wt_fp16_nan_flag_w[10]}};
    wt_nan_mask[191:176] = {16{~wt_fp16_nan_flag_w[11]}};
    wt_nan_mask[207:192] = {16{~wt_fp16_nan_flag_w[12]}};
    wt_nan_mask[223:208] = {16{~wt_fp16_nan_flag_w[13]}};
    wt_nan_mask[239:224] = {16{~wt_fp16_nan_flag_w[14]}};
    wt_nan_mask[255:240] = {16{~wt_fp16_nan_flag_w[15]}};
    wt_nan_mask[271:256] = {16{~wt_fp16_nan_flag_w[16]}};
    wt_nan_mask[287:272] = {16{~wt_fp16_nan_flag_w[17]}};
    wt_nan_mask[303:288] = {16{~wt_fp16_nan_flag_w[18]}};
    wt_nan_mask[319:304] = {16{~wt_fp16_nan_flag_w[19]}};
    wt_nan_mask[335:320] = {16{~wt_fp16_nan_flag_w[20]}};
    wt_nan_mask[351:336] = {16{~wt_fp16_nan_flag_w[21]}};
    wt_nan_mask[367:352] = {16{~wt_fp16_nan_flag_w[22]}};
    wt_nan_mask[383:368] = {16{~wt_fp16_nan_flag_w[23]}};
    wt_nan_mask[399:384] = {16{~wt_fp16_nan_flag_w[24]}};
    wt_nan_mask[415:400] = {16{~wt_fp16_nan_flag_w[25]}};
    wt_nan_mask[431:416] = {16{~wt_fp16_nan_flag_w[26]}};
    wt_nan_mask[447:432] = {16{~wt_fp16_nan_flag_w[27]}};
    wt_nan_mask[463:448] = {16{~wt_fp16_nan_flag_w[28]}};
    wt_nan_mask[479:464] = {16{~wt_fp16_nan_flag_w[29]}};
    wt_nan_mask[495:480] = {16{~wt_fp16_nan_flag_w[30]}};
    wt_nan_mask[511:496] = {16{~wt_fp16_nan_flag_w[31]}};
end


always @(
  wt_cbuf_wr_vld_w
  or wt_fp16_nan_flag_w
  or reg2dp_op_en
  or is_fp16
  or wt_fp16_inf_flag_w
  ) begin
    wt_fp16_nan_vld_w = wt_cbuf_wr_vld_w & (|wt_fp16_nan_flag_w) & reg2dp_op_en & is_fp16;
    wt_fp16_inf_vld_w = wt_cbuf_wr_vld_w & (|wt_fp16_inf_flag_w) & reg2dp_op_en & is_fp16;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_fp16_nan_vld <= 1'b0;
  end else begin
  wt_fp16_nan_vld <= wt_fp16_nan_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_fp16_inf_vld <= 1'b0;
  end else begin
  wt_fp16_inf_vld <= wt_fp16_inf_vld_w;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((wt_fp16_nan_vld_w) == 1'b1) begin
    wt_fp16_nan_flag <= wt_fp16_nan_flag_w;
  // VCS coverage off
  end else if ((wt_fp16_nan_vld_w) == 1'b0) begin
  end else begin
    wt_fp16_nan_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((wt_fp16_inf_vld_w) == 1'b1) begin
    wt_fp16_inf_flag <= wt_fp16_inf_flag_w;
  // VCS coverage off
  end else if ((wt_fp16_inf_vld_w) == 1'b0) begin
  end else begin
    wt_fp16_inf_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

/////////////////// ///////////////////

always @(
  wt_fp16_nan_flag
  ) begin
    wt_fp16_nan_sum = wt_fp16_nan_flag[31] + wt_fp16_nan_flag[30] + wt_fp16_nan_flag[29] + wt_fp16_nan_flag[28] + wt_fp16_nan_flag[27] + wt_fp16_nan_flag[26] + wt_fp16_nan_flag[25] + wt_fp16_nan_flag[24] +
                      wt_fp16_nan_flag[23] + wt_fp16_nan_flag[22] + wt_fp16_nan_flag[21] + wt_fp16_nan_flag[20] + wt_fp16_nan_flag[19] + wt_fp16_nan_flag[18] + wt_fp16_nan_flag[17] + wt_fp16_nan_flag[16] +
                      wt_fp16_nan_flag[15] + wt_fp16_nan_flag[14] + wt_fp16_nan_flag[13] + wt_fp16_nan_flag[12] + wt_fp16_nan_flag[11] + wt_fp16_nan_flag[10] + wt_fp16_nan_flag[9] + wt_fp16_nan_flag[8] +
                      wt_fp16_nan_flag[7] + wt_fp16_nan_flag[6] + wt_fp16_nan_flag[5] + wt_fp16_nan_flag[4] + wt_fp16_nan_flag[3] + wt_fp16_nan_flag[2] + wt_fp16_nan_flag[1] + wt_fp16_nan_flag[0];
end

always @(
  wt_fp16_inf_flag
  ) begin
    wt_fp16_inf_sum = wt_fp16_inf_flag[31] + wt_fp16_inf_flag[30] + wt_fp16_inf_flag[29] + wt_fp16_inf_flag[28] + wt_fp16_inf_flag[27] + wt_fp16_inf_flag[26] + wt_fp16_inf_flag[25] + wt_fp16_inf_flag[24] +
                      wt_fp16_inf_flag[23] + wt_fp16_inf_flag[22] + wt_fp16_inf_flag[21] + wt_fp16_inf_flag[20] + wt_fp16_inf_flag[19] + wt_fp16_inf_flag[18] + wt_fp16_inf_flag[17] + wt_fp16_inf_flag[16] +
                      wt_fp16_inf_flag[15] + wt_fp16_inf_flag[14] + wt_fp16_inf_flag[13] + wt_fp16_inf_flag[12] + wt_fp16_inf_flag[11] + wt_fp16_inf_flag[10] + wt_fp16_inf_flag[9] + wt_fp16_inf_flag[8] +
                      wt_fp16_inf_flag[7] + wt_fp16_inf_flag[6] + wt_fp16_inf_flag[5] + wt_fp16_inf_flag[4] + wt_fp16_inf_flag[3] + wt_fp16_inf_flag[2] + wt_fp16_inf_flag[1] + wt_fp16_inf_flag[0];
end


always @(
  dp2reg_nan_weight_num
  or wt_fp16_nan_sum
  ) begin
    {nan_carry,
     dp2reg_nan_weight_num_inc} = dp2reg_nan_weight_num + wt_fp16_nan_sum;
end

always @(
  layer_st
  or nan_carry
  or dp2reg_nan_weight_num_inc
  ) begin
    dp2reg_nan_weight_num_w = layer_st ? 32'b0 :
                              nan_carry ? ~(32'b0) :
                              dp2reg_nan_weight_num_inc;
end

always @(
  layer_st
  or wt_fp16_nan_vld
  or wt_fp16_nan_sum
  ) begin
    nan_reg_en = layer_st | (wt_fp16_nan_vld & (|wt_fp16_nan_sum));
end

always @(
  dp2reg_inf_weight_num
  or wt_fp16_inf_sum
  ) begin
    {inf_carry,
     dp2reg_inf_weight_num_inc} = dp2reg_inf_weight_num + wt_fp16_inf_sum;
end

always @(
  layer_st
  or inf_carry
  or dp2reg_inf_weight_num_inc
  ) begin
    dp2reg_inf_weight_num_w = layer_st ? 32'b0 :
                              inf_carry ? ~(32'b0) :
                              dp2reg_inf_weight_num_inc;
end

always @(
  layer_st
  or wt_fp16_inf_vld
  or wt_fp16_inf_sum
  ) begin
    inf_reg_en = layer_st | (wt_fp16_inf_vld & (|wt_fp16_inf_sum));
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_nan_weight_num <= {32{1'b0}};
  end else begin
  if ((nan_reg_en) == 1'b1) begin
    dp2reg_nan_weight_num <= dp2reg_nan_weight_num_w;
  // VCS coverage off
  end else if ((nan_reg_en) == 1'b0) begin
  end else begin
    dp2reg_nan_weight_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_73x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(nan_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dp2reg_inf_weight_num <= {32{1'b0}};
  end else begin
  if ((inf_reg_en) == 1'b1) begin
    dp2reg_inf_weight_num <= dp2reg_inf_weight_num_w;
  // VCS coverage off
  end else if ((inf_reg_en) == 1'b0) begin
  end else begin
    dp2reg_inf_weight_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_74x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(inf_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  WT data status monitor                                            //
////////////////////////////////////////////////////////////////////////
//================  Non-SLCG clock domain ================//

//sc2cdma_wt_kernels are useless

//retiming
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc_wt_updt <= 1'b0;
  end else begin
  sc_wt_updt <= sc2cdma_wt_updt;
  end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc_wt_entries <= {12{1'b0}};
  end else begin
  if ((sc2cdma_wt_updt) == 1'b1) begin
    sc_wt_entries <= sc2cdma_wt_entries;
  // VCS coverage off
  end else if ((sc2cdma_wt_updt) == 1'b0) begin
  end else begin
    sc_wt_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_75x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(sc2cdma_wt_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc_wmb_entries <= {9{1'b0}};
  end else begin
  if ((sc2cdma_wt_updt) == 1'b1) begin
    sc_wmb_entries <= sc2cdma_wmb_entries;
  // VCS coverage off
  end else if ((sc2cdma_wt_updt) == 1'b0) begin
  end else begin
    sc_wmb_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_76x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(sc2cdma_wt_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//cation: the basic unit of data_stored, data_onfly and data_avl is 32 bytes
always @(
  wt_req_reg_en_d2
  or wt_req_stage_vld_d2
  or wt_req_done_d2
  or wt_req_size_d2
  ) begin
    wt_data_onfly_add = (wt_req_reg_en_d2 & wt_req_stage_vld_d2 & ~wt_req_done_d2) ? wt_req_size_d2 : 4'b0;
end

always @(
  wt_cbuf_wr_vld_w
  ) begin
    wt_data_onfly_sub = wt_cbuf_wr_vld_w ? 2'b10 : 2'b0;
end

always @(
  wt_data_onfly
  or wt_data_onfly_add
  or wt_data_onfly_sub
  ) begin
    {mon_wt_data_onfly_w,
     wt_data_onfly_w} = wt_data_onfly + wt_data_onfly_add - wt_data_onfly_sub;
end

always @(
  status_update
  or incr_wt_entries_w
  ) begin
    wt_data_stored_sub = status_update ? {incr_wt_entries_w, 2'b0} : 14'b0;
end

always @(
  wt_data_stored
  or wt_data_onfly_sub
  or wt_data_stored_sub
  ) begin
    {mon_wt_data_stored_w,
     wt_data_stored_w} = wt_data_stored + wt_data_onfly_sub - wt_data_stored_sub;
end

always @(
  sc_wt_updt
  or sc_wt_entries
  ) begin
    wt_data_avl_sub = sc_wt_updt ? {sc_wt_entries, 2'b0} : 14'b0;
end

always @(
  clear_all
  or wt_data_avl
  or wt_data_stored_sub
  or wt_data_avl_sub
  ) begin
    {mon_wt_data_avl_w,
     wt_data_avl_w} = (clear_all) ? 15'b0 :
                      wt_data_avl + wt_data_stored_sub - wt_data_avl_sub;
end

always @(
  wt_req_reg_en_d2
  or wt_req_stage_vld_d2
  or wt_cbuf_wr_vld_w
  ) begin
    wt_data_onfly_reg_en = ((wt_req_reg_en_d2 & wt_req_stage_vld_d2) | wt_cbuf_wr_vld_w);
end

always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_data_onfly <= {14{1'b0}};
  end else begin
  if ((wt_data_onfly_reg_en) == 1'b1) begin
    wt_data_onfly <= wt_data_onfly_w;
  // VCS coverage off
  end else if ((wt_data_onfly_reg_en) == 1'b0) begin
  end else begin
    wt_data_onfly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_77x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(wt_data_onfly_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_data_stored <= {14{1'b0}};
  end else begin
  if ((wt_cbuf_wr_vld_w | status_update) == 1'b1) begin
    wt_data_stored <= wt_data_stored_w;
  // VCS coverage off
  end else if ((wt_cbuf_wr_vld_w | status_update) == 1'b0) begin
  end else begin
    wt_data_stored <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_78x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(wt_cbuf_wr_vld_w | status_update))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_data_avl <= {14{1'b0}};
  end else begin
  if ((status_update | sc_wt_updt | clear_all) == 1'b1) begin
    wt_data_avl <= wt_data_avl_w;
  // VCS coverage off
  end else if ((status_update | sc_wt_updt | clear_all) == 1'b0) begin
  end else begin
    wt_data_avl <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_79x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(status_update | sc_wt_updt | clear_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_data_onfly_w is overflow")      zzz_assert_never_80x (nvdla_core_ng_clk, `ASSERT_RESET, (reg2dp_op_en & mon_wt_data_onfly_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_data_stored_w is overflow")      zzz_assert_never_81x (nvdla_core_ng_clk, `ASSERT_RESET, (reg2dp_op_en & mon_wt_data_stored_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_data_onfly is not zero when idle")      zzz_assert_never_82x (nvdla_core_ng_clk, `ASSERT_RESET, (~is_running & (|wt_data_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_data_stored is not zero when idle")      zzz_assert_never_83x (nvdla_core_ng_clk, `ASSERT_RESET, (~is_running & (|wt_data_stored))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_data_avl_w is overflow")      zzz_assert_never_84x (nvdla_core_ng_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wt_data_avl_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  WMB data status monitor                                           //
////////////////////////////////////////////////////////////////////////

always @(
  wmb_req_reg_en_d2
  or wmb_req_stage_vld_d2
  or wmb_req_done_d2
  or wmb_req_size_d2
  ) begin
    wmb_data_onfly_add = (wmb_req_reg_en_d2 & wmb_req_stage_vld_d2 & ~wmb_req_done_d2) ? wmb_req_size_d2 : 4'b0;
end

always @(
  wmb_cbuf_wr_vld_w
  ) begin
    wmb_data_onfly_sub = wmb_cbuf_wr_vld_w ? 2'b10 : 2'b0;
end

always @(
  wmb_data_onfly
  or wmb_data_onfly_add
  or wmb_data_onfly_sub
  ) begin
    {mon_wmb_data_onfly_w,
     wmb_data_onfly_w} = wmb_data_onfly + wmb_data_onfly_add - wmb_data_onfly_sub;
end

always @(
  status_update_wmb
  or incr_wmb_entries_w
  ) begin
    wmb_data_stored_sub = status_update_wmb ? {incr_wmb_entries_w, 2'b0} : 11'b0;
end

always @(
  wmb_data_stored
  or wmb_data_onfly_sub
  or wmb_data_stored_sub
  ) begin
    {mon_wmb_data_stored_w,
     wmb_data_stored_w} = wmb_data_stored + wmb_data_onfly_sub - wmb_data_stored_sub;
end

always @(
  sc_wt_updt
  or sc_wmb_entries
  ) begin
    wmb_data_avl_sub = sc_wt_updt ? {sc_wmb_entries, 2'b0} : 11'b0;
end

always @(
  clear_all
  or wmb_data_avl
  or wmb_data_stored_sub
  or wmb_data_avl_sub
  ) begin
    {mon_wmb_data_avl_w,
     wmb_data_avl_w} = (clear_all) ? 12'b0 :
                       wmb_data_avl + wmb_data_stored_sub - wmb_data_avl_sub;
end

always @(
  wmb_req_reg_en_d2
  or wmb_req_stage_vld_d2
  or wmb_cbuf_wr_vld_w
  ) begin
    wmb_data_onfly_reg_en = ((wmb_req_reg_en_d2 & wmb_req_stage_vld_d2) | wmb_cbuf_wr_vld_w);
end

always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_data_onfly <= {11{1'b0}};
  end else begin
  if ((wmb_data_onfly_reg_en) == 1'b1) begin
    wmb_data_onfly <= wmb_data_onfly_w;
  // VCS coverage off
  end else if ((wmb_data_onfly_reg_en) == 1'b0) begin
  end else begin
    wmb_data_onfly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_85x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(wmb_data_onfly_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_data_stored <= {11{1'b0}};
  end else begin
  if ((wmb_cbuf_wr_vld_w | status_update_wmb) == 1'b1) begin
    wmb_data_stored <= wmb_data_stored_w;
  // VCS coverage off
  end else if ((wmb_cbuf_wr_vld_w | status_update_wmb) == 1'b0) begin
  end else begin
    wmb_data_stored <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_86x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(wmb_cbuf_wr_vld_w | status_update_wmb))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_data_avl <= {11{1'b0}};
  end else begin
  if ((status_update_wmb | sc_wt_updt | clear_all) == 1'b1) begin
    wmb_data_avl <= wmb_data_avl_w;
  // VCS coverage off
  end else if ((status_update_wmb | sc_wt_updt | clear_all) == 1'b0) begin
  end else begin
    wmb_data_avl <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_87x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(status_update_wmb | sc_wt_updt | clear_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_data_onfly_w is overflow")      zzz_assert_never_88x (nvdla_core_ng_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wmb_data_onfly_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_data_stored_w is overflow")      zzz_assert_never_89x (nvdla_core_ng_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wmb_data_stored_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_data_onfly is not zero when idle")      zzz_assert_never_90x (nvdla_core_ng_clk, `ASSERT_RESET, (~is_running & (|wmb_data_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_data_stored is not zero when idle")      zzz_assert_never_91x (nvdla_core_ng_clk, `ASSERT_RESET, (~is_running & (|wmb_data_stored))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_data_avl_w is overflow")      zzz_assert_never_92x (nvdla_core_ng_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wmb_data_avl_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//================  Non-SLCG clock domain end ================//

////////////////////////////////////////////////////////////////////////
//  WGS data status monitor                                           //
////////////////////////////////////////////////////////////////////////
//csm is stand for consume

always @(
  wgs_req_rdy
  or wgs_req_dword_d1
  ) begin
    wgs_data_onfly_add = (wgs_req_rdy) ? wgs_req_dword_d1 : 5'b0;
end

always @(
  wgs_pop_req
  or wgs_pop_ready
  ) begin
    wgs_data_onfly_sub = (wgs_pop_req & wgs_pop_ready) ? 1'b1 : 1'b0;
end

always @(
  wgs_data_onfly
  or wgs_data_onfly_add
  or wgs_data_onfly_sub
  ) begin
    {mon_wgs_data_onfly_w,
     wgs_data_onfly_w} = wgs_data_onfly + wgs_data_onfly_add - wgs_data_onfly_sub;
end

always @(
  wgs_req_rdy
  or wgs_pop_req
  or wgs_pop_ready
  ) begin
    wgs_data_onfly_reg_en = (wgs_req_rdy | (wgs_pop_req & wgs_pop_ready));
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wgs_data_onfly <= {6{1'b0}};
  end else begin
  if ((wgs_data_onfly_reg_en) == 1'b1) begin
    wgs_data_onfly <= wgs_data_onfly_w;
  // VCS coverage off
  end else if ((wgs_data_onfly_reg_en) == 1'b0) begin
  end else begin
    wgs_data_onfly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_93x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wgs_data_onfly_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wgs_data_onfly_w is overflow")      zzz_assert_never_94x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wgs_data_onfly_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  status update logic                                               //
////////////////////////////////////////////////////////////////////////

always @(
  status_group_cnt
  ) begin
    status_group_cnt_inc = status_group_cnt + 1'b1;
end

always @(
  status_group_cnt_inc
  or group
  ) begin
    status_last_group = (status_group_cnt_inc == group);
end

always @(
  layer_st
  or status_group_cnt_inc
  ) begin
    status_group_cnt_w = layer_st ? 10'b0 :
                         status_group_cnt_inc;
end

always @(
  layer_st
  or status_last_group
  or status_done
  ) begin
    status_done_w = layer_st ? 1'b0 :
                    status_last_group ? 1'b1 :
                    status_done;
end

always @(
  is_int8
  or byte_per_kernel
  ) begin
    normal_bpg = is_int8 ? {byte_per_kernel, 5'b0} : {1'b0, byte_per_kernel, 4'b0};
end

always @(
  layer_st
  or status_last_group
  or reg2dp_weight_bytes
  or is_compressed
  or pre_wt_required_bytes
  or wgs_pop_data
  or normal_bpg
  ) begin
    {mon_wt_required_bytes_w,
     wt_required_bytes_w} = layer_st ? 33'b0 :
                            status_last_group ? {1'b0, reg2dp_weight_bytes, 7'b0}  :
                            is_compressed ? pre_wt_required_bytes + wgs_pop_data :
                            pre_wt_required_bytes + normal_bpg;
end

always @(
  required_valid
  or required_valid_w
  ) begin
    wt_required_en = ~required_valid & required_valid_w;
end

always @(
  layer_st
  or wt_required_bytes
  ) begin
    pre_wt_required_bytes_w = (layer_st) ? 32'b0 :
                              wt_required_bytes;
end

always @(
  layer_st
  or status_last_group
  or reg2dp_wmb_bytes
  or is_int8
  or pre_wmb_required_bits
  or normal_bpg
  ) begin
    {mon_wmb_required_bits_w,
     wmb_required_bits_w} = layer_st ? 33'b0 :
                            status_last_group ? { {{2{1'b0}}, reg2dp_wmb_bytes}, 10'b0} :
                            is_int8 ? pre_wmb_required_bits + normal_bpg[23:0] :
                            pre_wmb_required_bits + normal_bpg[23:1];
end

always @(
  required_valid
  or required_valid_w
  or is_compressed
  ) begin
    wmb_required_en = ~required_valid & required_valid_w & is_compressed;
end

always @(
  layer_st
  or wmb_required_bits
  ) begin
    pre_wmb_required_bits_w = (layer_st) ? 31'b0 :
                              wmb_required_bits;
end

always @(
  is_running
  or status_update
  or is_compressed
  or wgs_pop_req
  ) begin
    required_valid_w = is_running & ~status_update & (~is_compressed | wgs_pop_req);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    required_valid <= 1'b0;
  end else begin
  required_valid <= required_valid_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_required_bytes <= {32{1'b0}};
  end else begin
  if ((layer_st | wt_required_en) == 1'b1) begin
    wt_required_bytes <= wt_required_bytes_w;
  // VCS coverage off
  end else if ((layer_st | wt_required_en) == 1'b0) begin
  end else begin
    wt_required_bytes <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_95x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wt_required_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_required_bits <= {32{1'b0}};
  end else begin
  if ((layer_st | wmb_required_en) == 1'b1) begin
    wmb_required_bits <= wmb_required_bits_w;
  // VCS coverage off
  end else if ((layer_st | wmb_required_en) == 1'b0) begin
  end else begin
    wmb_required_bits <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_96x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wmb_required_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////// caution: one in fetched_cnt refers to 64 bytes ////////
always @(
  wt_fetched_cnt
  ) begin
    {mon_wt_fetched_cnt_inc,
     wt_fetched_cnt_inc} = wt_fetched_cnt + 1'b1;
end

always @(
  layer_st
  or wt_fetched_cnt_inc
  ) begin
    wt_fetched_cnt_w = layer_st ? 26'b0 :
                       wt_fetched_cnt_inc;
end

//////// caution: one in fetched_cnt refers to 64 bytes ////////
always @(
  wmb_fetched_cnt
  ) begin
    {mon_wmb_fetched_cnt_inc,
     wmb_fetched_cnt_inc} = wmb_fetched_cnt + 1'b1;
end

always @(
  layer_st
  or wmb_fetched_cnt_inc
  ) begin
    wmb_fetched_cnt_w = layer_st ? 22'b0 :
                        wmb_fetched_cnt_inc;
end

always @(
  is_running
  or wt_fetched_cnt
  or wt_required_bytes
  ) begin
    wt_satisfied = is_running & ({wt_fetched_cnt, 6'b0} >= wt_required_bytes) & ~wt_fetched_cnt[0];
end

always @(
  is_running
  or wmb_fetched_cnt
  or wmb_required_bits
  ) begin
    wmb_satisfied = is_running && ({{{1{1'b0}}, wmb_fetched_cnt}, 9'b0} >= wmb_required_bits) && ~wmb_fetched_cnt[0];
end

always @(
  required_valid
  or is_compressed
  or wt_satisfied
  or wmb_satisfied
  ) begin
    status_update = (~required_valid) ? 1'b0 :
                    (~is_compressed) ? wt_satisfied :
                    wt_satisfied & wmb_satisfied;
end

always @(
  required_valid
  or is_compressed
  or wt_satisfied
  or wmb_satisfied
  ) begin
    status_update_wmb = (~required_valid) ? 1'b0 :
                        (~is_compressed) ? 1'b0 :
                        wt_satisfied & wmb_satisfied;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    status_group_cnt <= {10{1'b0}};
  end else begin
  if ((layer_st | status_update) == 1'b1) begin
    status_group_cnt <= status_group_cnt_w;
  // VCS coverage off
  end else if ((layer_st | status_update) == 1'b0) begin
  end else begin
    status_group_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_97x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | status_update))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    status_done <= 1'b0;
  end else begin
  if ((layer_st | status_update) == 1'b1) begin
    status_done <= status_done_w;
  // VCS coverage off
  end else if ((layer_st | status_update) == 1'b0) begin
  end else begin
    status_done <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_98x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | status_update))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pre_wt_required_bytes <= {32{1'b0}};
  end else begin
  if ((layer_st | status_update) == 1'b1) begin
    pre_wt_required_bytes <= pre_wt_required_bytes_w;
  // VCS coverage off
  end else if ((layer_st | status_update) == 1'b0) begin
  end else begin
    pre_wt_required_bytes <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_99x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | status_update))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pre_wmb_required_bits <= {32{1'b0}};
  end else begin
  if ((layer_st | status_update) == 1'b1) begin
    pre_wmb_required_bits <= pre_wmb_required_bits_w;
  // VCS coverage off
  end else if ((layer_st | status_update) == 1'b0) begin
  end else begin
    pre_wmb_required_bits <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_100x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | status_update))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_fetched_cnt <= {26{1'b0}};
  end else begin
  if ((layer_st | wt_cbuf_wr_vld_w) == 1'b1) begin
    wt_fetched_cnt <= wt_fetched_cnt_w;
  // VCS coverage off
  end else if ((layer_st | wt_cbuf_wr_vld_w) == 1'b0) begin
  end else begin
    wt_fetched_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_101x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wt_cbuf_wr_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_fetched_cnt <= {22{1'b0}};
  end else begin
  if ((layer_st | wmb_cbuf_wr_vld_w) == 1'b1) begin
    wmb_fetched_cnt <= wmb_fetched_cnt_w;
  // VCS coverage off
  end else if ((layer_st | wmb_cbuf_wr_vld_w) == 1'b0) begin
  end else begin
    wmb_fetched_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_102x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wmb_cbuf_wr_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_fetched_cnt_w is overflow")      zzz_assert_never_103x (nvdla_core_clk, `ASSERT_RESET, ((layer_st | wt_cbuf_wr_vld_w) & mon_wt_fetched_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_fetched_cnt_w is overflow")      zzz_assert_never_104x (nvdla_core_clk, `ASSERT_RESET, ((layer_st | wmb_cbuf_wr_vld_w) & mon_wmb_fetched_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  avaliable kernels monitor                                         //
////////////////////////////////////////////////////////////////////////
// Avaliable kernel size is useless here. Discard the code;

////////////////////////////////////////////////////////////////////////
//  CDMA WT communicate to CSC                                        //
////////////////////////////////////////////////////////////////////////

always @(
  status_last_group
  or wt_fetched_cnt
  ) begin
    pre_wt_fetched_cnt_w = status_last_group ? 26'b0 :
                           wt_fetched_cnt;
end

always @(
  status_last_group
  or wmb_fetched_cnt
  ) begin
    pre_wmb_fetched_cnt_w = status_last_group ? 22'b0 :
                            wmb_fetched_cnt;
end

always @(
  wt_fetched_cnt
  or pre_wt_fetched_cnt
  ) begin
    {mon_incr_wt_cnt,
     incr_wt_cnt} = wt_fetched_cnt[12 :0] - pre_wt_fetched_cnt[12 :0];
end

always @(
  wmb_fetched_cnt
  or pre_wmb_fetched_cnt
  ) begin
    {mon_incr_wmb_cnt,
     incr_wmb_cnt} = wmb_fetched_cnt[8 +1:0] - pre_wmb_fetched_cnt[8 +1:0];
end

always @(
  incr_wt_cnt
  ) begin
    incr_wt_entries_w = incr_wt_cnt[12 :1];
end

always @(
  incr_wmb_cnt
  ) begin
    incr_wmb_entries_w = incr_wmb_cnt[8 +1:1];
end

always @(
  status_last_group
  or is_int8
  or reg2dp_weight_kernel
  ) begin
    incr_wt_kernels_w = (~status_last_group) ? (is_int8 ? 6'h20 : 6'h10) :
                        is_int8 ? (reg2dp_weight_kernel[4:0] + 1'b1) :
                        reg2dp_weight_kernel[3:0] + 1'b1;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    incr_wt_updt <= 1'b0;
  end else begin
  incr_wt_updt <= status_update;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pre_wt_fetched_cnt <= {26{1'b0}};
  end else begin
  if ((status_update) == 1'b1) begin
    pre_wt_fetched_cnt <= pre_wt_fetched_cnt_w;
  // VCS coverage off
  end else if ((status_update) == 1'b0) begin
  end else begin
    pre_wt_fetched_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_105x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(status_update))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pre_wmb_fetched_cnt <= {22{1'b0}};
  end else begin
  if ((status_update) == 1'b1) begin
    pre_wmb_fetched_cnt <= pre_wmb_fetched_cnt_w;
  // VCS coverage off
  end else if ((status_update) == 1'b0) begin
  end else begin
    pre_wmb_fetched_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_106x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(status_update))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    incr_wt_entries <= {12{1'b0}};
  end else begin
  if ((status_update) == 1'b1) begin
    incr_wt_entries <= incr_wt_entries_w;
  // VCS coverage off
  end else if ((status_update) == 1'b0) begin
  end else begin
    incr_wt_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_107x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(status_update))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    incr_wmb_entries <= {9{1'b0}};
  end else begin
  if ((status_update) == 1'b1) begin
    incr_wmb_entries <= incr_wmb_entries_w;
  // VCS coverage off
  end else if ((status_update) == 1'b0) begin
  end else begin
    incr_wmb_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_108x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(status_update))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    incr_wt_kernels <= {6{1'b0}};
  end else begin
  if ((status_update) == 1'b1) begin
    incr_wt_kernels <= incr_wt_kernels_w;
  // VCS coverage off
  end else if ((status_update) == 1'b0) begin
  end else begin
    incr_wt_kernels <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_109x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(status_update))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign incr_wt_kernels_d0 = incr_wt_kernels;
assign incr_wt_entries_d0 = incr_wt_entries;
assign incr_wmb_entries_d0 = incr_wmb_entries;
assign incr_wt_updt_d0 = incr_wt_updt;


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    incr_wt_kernels_d1 <= {6{1'b0}};
  end else begin
  if ((incr_wt_updt_d0) == 1'b1) begin
    incr_wt_kernels_d1 <= incr_wt_kernels_d0;
  // VCS coverage off
  end else if ((incr_wt_updt_d0) == 1'b0) begin
  end else begin
    incr_wt_kernels_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_110x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(incr_wt_updt_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    incr_wt_entries_d1 <= {12{1'b0}};
  end else begin
  if ((incr_wt_updt_d0) == 1'b1) begin
    incr_wt_entries_d1 <= incr_wt_entries_d0;
  // VCS coverage off
  end else if ((incr_wt_updt_d0) == 1'b0) begin
  end else begin
    incr_wt_entries_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_111x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(incr_wt_updt_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    incr_wmb_entries_d1 <= {9{1'b0}};
  end else begin
  if ((incr_wt_updt_d0) == 1'b1) begin
    incr_wmb_entries_d1 <= incr_wmb_entries_d0;
  // VCS coverage off
  end else if ((incr_wt_updt_d0) == 1'b0) begin
  end else begin
    incr_wmb_entries_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_112x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(incr_wt_updt_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    incr_wt_updt_d1 <= 1'b0;
  end else begin
  incr_wt_updt_d1 <= incr_wt_updt_d0;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    incr_wt_kernels_d2 <= {6{1'b0}};
  end else begin
  if ((incr_wt_updt_d1) == 1'b1) begin
    incr_wt_kernels_d2 <= incr_wt_kernels_d1;
  // VCS coverage off
  end else if ((incr_wt_updt_d1) == 1'b0) begin
  end else begin
    incr_wt_kernels_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_113x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(incr_wt_updt_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    incr_wt_entries_d2 <= {12{1'b0}};
  end else begin
  if ((incr_wt_updt_d1) == 1'b1) begin
    incr_wt_entries_d2 <= incr_wt_entries_d1;
  // VCS coverage off
  end else if ((incr_wt_updt_d1) == 1'b0) begin
  end else begin
    incr_wt_entries_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_114x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(incr_wt_updt_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    incr_wmb_entries_d2 <= {9{1'b0}};
  end else begin
  if ((incr_wt_updt_d1) == 1'b1) begin
    incr_wmb_entries_d2 <= incr_wmb_entries_d1;
  // VCS coverage off
  end else if ((incr_wt_updt_d1) == 1'b0) begin
  end else begin
    incr_wmb_entries_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_115x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(incr_wt_updt_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    incr_wt_updt_d2 <= 1'b0;
  end else begin
  incr_wt_updt_d2 <= incr_wt_updt_d1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    incr_wt_kernels_d3 <= {6{1'b0}};
  end else begin
  if ((incr_wt_updt_d2) == 1'b1) begin
    incr_wt_kernels_d3 <= incr_wt_kernels_d2;
  // VCS coverage off
  end else if ((incr_wt_updt_d2) == 1'b0) begin
  end else begin
    incr_wt_kernels_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_116x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(incr_wt_updt_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    incr_wt_entries_d3 <= {12{1'b0}};
  end else begin
  if ((incr_wt_updt_d2) == 1'b1) begin
    incr_wt_entries_d3 <= incr_wt_entries_d2;
  // VCS coverage off
  end else if ((incr_wt_updt_d2) == 1'b0) begin
  end else begin
    incr_wt_entries_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_117x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(incr_wt_updt_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    incr_wmb_entries_d3 <= {9{1'b0}};
  end else begin
  if ((incr_wt_updt_d2) == 1'b1) begin
    incr_wmb_entries_d3 <= incr_wmb_entries_d2;
  // VCS coverage off
  end else if ((incr_wt_updt_d2) == 1'b0) begin
  end else begin
    incr_wmb_entries_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_118x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(incr_wt_updt_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    incr_wt_updt_d3 <= 1'b0;
  end else begin
  incr_wt_updt_d3 <= incr_wt_updt_d2;
  end
end



assign cdma2sc_wt_kernels[5:0] = incr_wt_kernels_d3;
assign cdma2sc_wt_entries = incr_wt_entries_d3;
assign cdma2sc_wmb_entries = incr_wmb_entries_d3;
assign cdma2sc_wt_updt = incr_wt_updt_d3;
assign cdma2sc_wt_kernels[13:6] = 8'b0;

`ifndef SYNTHESIS
assign dbg_wt_kernel_bytes_w[31:0] = layer_st ? 32'b0 : wt_required_bytes_w - wt_required_bytes;
assign dbg_wmb_kernel_bits_sub[31:0] = wmb_required_bits_w - wmb_required_bits;
assign dbg_wmb_kernel_bits_w[31:0] = layer_st ? 32'b0 : 
                                     ((dbg_wmb_kernel_bits_sub > dbg_wmb_kernel_bits) && (dbg_wmb_kernel_bits != 0)) ? dbg_wmb_kernel_bits :
                                     dbg_wmb_kernel_bits_sub;
assign dbg_full_weight = (reg2dp_weight_bytes <= {weight_bank, 8'h0});
assign dbg_full_wmb = (reg2dp_wmb_bytes <= 9'h100);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_wt_kernel_bytes <= {32{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((layer_st |  wt_required_en) == 1'b1) begin
    dbg_wt_kernel_bytes <= dbg_wt_kernel_bytes_w;
  // VCS coverage off
  end else if ((layer_st |  wt_required_en) == 1'b0) begin
  end else begin
    dbg_wt_kernel_bytes <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_119x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st |  wt_required_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_wmb_kernel_bits <= {32{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((layer_st | wmb_required_en) == 1'b1) begin
    dbg_wmb_kernel_bits <= dbg_wmb_kernel_bits_w;
  // VCS coverage off
  end else if ((layer_st | wmb_required_en) == 1'b0) begin
  end else begin
    dbg_wmb_kernel_bits <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_120x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wmb_required_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif

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
  nv_assert_never #(0,0,"Config error! Run out of weight buffer: uncompressed weight!")      zzz_assert_never_121x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~reg2dp_skip_weight_rls & ~dbg_full_weight & ~is_compressed & ~status_done & ((dbg_wt_kernel_bytes + 128) > {weight_bank, 15'b0}))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! Run out of weight buffer: compressed weight!")      zzz_assert_never_122x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~reg2dp_skip_weight_rls & ~dbg_full_weight & is_compressed & ~status_done & wgs_pop_req & ((wgs_pop_data + 128) > {weight_bank, 15'b0}))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! Run out of weight buffer: WMB!")      zzz_assert_never_123x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~reg2dp_skip_weight_rls & ~dbg_full_wmb & is_compressed & ~status_done & (dbg_wmb_kernel_bits > 32'h3fc00))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! Run out of weight buffer: full weight!")      zzz_assert_never_124x (nvdla_core_clk, `ASSERT_RESET, (is_running & reg2dp_skip_weight_rls & ~dbg_full_weight)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! Run out of weight buffer: full WMB!")      zzz_assert_never_125x (nvdla_core_clk, `ASSERT_RESET, (is_running & reg2dp_skip_weight_rls & is_compressed & ~dbg_full_wmb)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Weight output update with zero kernels")      zzz_assert_never_126x (nvdla_core_clk, `ASSERT_RESET, (cdma2sc_wt_updt & ~(|cdma2sc_wt_kernels))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

    always @(
      wt_rd_stall_inc
      or dp2reg_wt_rd_stall_dec
      ) begin
      stl_adv = wt_rd_stall_inc ^ dp2reg_wt_rd_stall_dec;
    end
        
    // stl cnt logic
    always @(
      stl_cnt_cur
      or wt_rd_stall_inc
      or dp2reg_wt_rd_stall_dec
      or stl_adv
      or wt_rd_stall_clr
      ) begin
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

    always @(
      stl_cnt_cur
      ) begin
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

    always @(
      ltc_1_inc
      or ltc_1_dec
      ) begin
      ltc_1_adv = ltc_1_inc ^ ltc_1_dec;
    end
        
    // ltc_1 cnt logic
    always @(
      ltc_1_cnt_cur
      or ltc_1_inc
      or ltc_1_dec
      or ltc_1_adv
      or wt_rd_latency_clr
      ) begin
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

    always @(
      ltc_1_cnt_cur
      ) begin
      outs_dp2reg_wt_rd_latency[8:0] = ltc_1_cnt_cur[8:0];
    end
        
    // ltc_1 asserts

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
      nv_assert_never #(0,0,"never: counter overflow beyond <ovr_cnt>")      zzz_assert_never_127x (nvdla_core_clk, `ASSERT_RESET, (ltc_1_cnt_nxt > 511 && wt_rd_latency_cen)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

      
    //assign dp2reg_wt_rd_latency_sub = 1'b0;
    assign ltc_2_dec = 1'b0;
    assign ltc_2_inc = (~&dp2reg_wt_rd_latency) & (|outs_dp2reg_wt_rd_latency);

    // ltc_2 adv logic

    always @(
      ltc_2_inc
      or ltc_2_dec
      ) begin
      ltc_2_adv = ltc_2_inc ^ ltc_2_dec;
    end
        
    // ltc_2 cnt logic
    always @(
      ltc_2_cnt_cur
      or ltc_2_inc
      or ltc_2_dec
      or ltc_2_adv
      or wt_rd_latency_clr
      ) begin
      // VCS sop_coverage_off start
      ltc_2_cnt_ext[33:0] = {1'b0, 1'b0, ltc_2_cnt_cur};
      ltc_2_cnt_inc[33:0] = ltc_2_cnt_cur + 1'b1; // spyglass disable W164b
      ltc_2_cnt_dec[33:0] = ltc_2_cnt_cur - 1'b1; // spyglass disable W164b
      ltc_2_cnt_mod[33:0] = (ltc_2_inc && !ltc_2_dec)? ltc_2_cnt_inc : (!ltc_2_inc && ltc_2_dec)? ltc_2_cnt_dec : ltc_2_cnt_ext;
      ltc_2_cnt_new[33:0] = (ltc_2_adv)? ltc_2_cnt_mod[33:0] : ltc_2_cnt_ext[33:0];
      ltc_2_cnt_nxt[33:0] = (wt_rd_latency_clr)? 34'd0 : ltc_2_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // ltc_2 flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        ltc_2_cnt_cur[31:0] <= 0;
      end else begin
      if (wt_rd_latency_cen) begin
      ltc_2_cnt_cur[31:0] <= ltc_2_cnt_nxt[31:0];
      end
      end
    end

    // ltc_2 output logic

    always @(
      ltc_2_cnt_cur
      ) begin
      dp2reg_wt_rd_latency[31:0] = ltc_2_cnt_cur[31:0];
    end
        
      

// ////////////////////////////////////////////////////////////////////////
// //  OBS connection                                                    //
// ////////////////////////////////////////////////////////////////////////
// assign obs_bus_cdma_wt_dma_rd_req_vld      = dma_rd_req_vld;
// assign obs_bus_cdma_wt_dma_rd_req_rdy      = dma_rd_req_rdy;
// assign obs_bus_cdma_wt_dma_req_fifo_req    = dma_req_fifo_req;
// assign obs_bus_cdma_wt_dma_req_fifo_ready  = dma_req_fifo_ready;
// assign obs_bus_cdma_wt_dma_req_size_out    = dma_req_size_out;
// assign obs_bus_cdma_wt_dma_req_src         = dma_req_src;
// assign obs_bus_cdma_wt_dma_req_addr_lo     = dma_req_addr[15:0];
// assign obs_bus_cdma_wt_dma_rd_rsp_vld      = dma_rd_rsp_vld;
// assign obs_bus_cdma_wt_dma_rd_rsp_rdy      = dma_rd_rsp_rdy;
// assign obs_bus_cdma_wt_dma_rd_rsp_mask     = dma_rd_rsp_mask;
// assign obs_bus_cdma_wt_dma_rsp_fifo_req    = dma_rsp_fifo_req;
// assign obs_bus_cdma_wt_dma_rsp_fifo_ready  = dma_rsp_fifo_ready;
// assign obs_bus_cdma_wt_fetch_done          = fetch_done;
// assign obs_bus_cdma_wt_cur_state           = cur_state;
// assign obs_bus_cdma_wt_nxt_state           = nxt_state;
// assign obs_bus_cdma_cdma2buf_wt_wr_en      = cdma2buf_wt_wr_en;
// assign obs_bus_cdma_cdma2buf_wt_wr_addr    = cdma2buf_wt_wr_addr;
// assign obs_bus_cdma_cdma2buf_wt_wr_hsel    = cdma2buf_wt_wr_hsel;
// assign obs_bus_cdma_cdma2sc_wt_updt        = cdma2sc_wt_updt;

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           wt_req_size_d2[1:0]
//                           {wt_req_last_d2,wt_req_done_d2}
//                           {wgs_req_vld_d1,arb_wrr_out_vld}
//                           {arb_sp_out_vld,arb_sp_out_back_vld}
//                           {wgs_push_req,wmb_local_data_vld}
//                           wmb_req_burst_cnt_d1[1:0];

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


endmodule // NV_NVDLA_CDMA_wt



// **************************************************************************************************************
// Generated by ::pipe -m -bc -is mc_int_rd_req_pd (mc_int_rd_req_valid,mc_int_rd_req_ready) <= dma_rd_req_pd[78:0] (mc_dma_rd_req_vld,mc_dma_rd_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_CDMA_WT_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma_rd_req_pd
  ,mc_dma_rd_req_vld
  ,mc_int_rd_req_ready
  ,mc_dma_rd_req_rdy
  ,mc_int_rd_req_pd
  ,mc_int_rd_req_valid
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [78:0] dma_rd_req_pd;
input         mc_dma_rd_req_vld;
input         mc_int_rd_req_ready;
output        mc_dma_rd_req_rdy;
output [78:0] mc_int_rd_req_pd;
output        mc_int_rd_req_valid;
reg           mc_dma_rd_req_rdy;
reg    [78:0] mc_int_rd_req_pd;
reg           mc_int_rd_req_valid;
reg    [78:0] p1_pipe_data;
reg    [78:0] p1_pipe_rand_data;
reg           p1_pipe_rand_ready;
reg           p1_pipe_rand_valid;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
reg           p1_skid_catch;
reg    [78:0] p1_skid_data;
reg    [78:0] p1_skid_pipe_data;
reg           p1_skid_pipe_ready;
reg           p1_skid_pipe_valid;
reg           p1_skid_ready;
reg           p1_skid_ready_flop;
reg           p1_skid_valid;
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     mc_dma_rd_req_vld
  or p1_pipe_rand_ready
  or dma_rd_req_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = mc_dma_rd_req_vld;
  mc_dma_rd_req_rdy = p1_pipe_rand_ready;
  p1_pipe_rand_data = dma_rd_req_pd[78:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : mc_dma_rd_req_vld;
  mc_dma_rd_req_rdy = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : dma_rd_req_pd[78:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p1_pipe_stall_cycles;
integer p1_pipe_stall_probability;
integer p1_pipe_stall_cycles_min;
integer p1_pipe_stall_cycles_max;
initial begin
  p1_pipe_stall_cycles = 0;
  p1_pipe_stall_probability = 0;
  p1_pipe_stall_cycles_min = 1;
  p1_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or mc_dma_rd_req_vld
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && mc_dma_rd_req_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p1_pipe_rand_poised) begin
    if (p1_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p1_pipe_stall_cycles <= prand_inst1(p1_pipe_stall_cycles_min, p1_pipe_stall_cycles_max);
    end
  end else if (p1_pipe_rand_active) begin
    p1_pipe_stall_cycles <= p1_pipe_stall_cycles - 1;
  end else begin
    p1_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (1) skid buffer
always @(
  p1_pipe_rand_valid
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_rand_valid && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_rand_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_rand_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_rand_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_rand_valid
  or p1_skid_valid
  or p1_pipe_rand_data
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? p1_pipe_rand_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? p1_pipe_rand_data : p1_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (1) valid-ready-bubble-collapse
always @(
  p1_pipe_ready
  or p1_pipe_valid
  ) begin
  p1_pipe_ready_bc = p1_pipe_ready || !p1_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_valid <= 1'b0;
  end else begin
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_skid_pipe_valid)? p1_skid_pipe_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_skid_pipe_ready = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or mc_int_rd_req_ready
  or p1_pipe_data
  ) begin
  mc_int_rd_req_valid = p1_pipe_valid;
  p1_pipe_ready = mc_int_rd_req_ready;
  mc_int_rd_req_pd = p1_pipe_data;
end
//## pipe (1) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p1_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_128x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_int_rd_req_valid^mc_int_rd_req_ready^mc_dma_rd_req_vld^mc_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_129x (nvdla_core_clk, `ASSERT_RESET, (mc_dma_rd_req_vld && !mc_dma_rd_req_rdy), (mc_dma_rd_req_vld), (mc_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDMA_WT_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is cv_int_rd_req_pd (cv_int_rd_req_valid,cv_int_rd_req_ready) <= dma_rd_req_pd[78:0] (cv_dma_rd_req_vld,cv_dma_rd_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_CDMA_WT_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cv_dma_rd_req_vld
  ,cv_int_rd_req_ready
  ,dma_rd_req_pd
  ,cv_dma_rd_req_rdy
  ,cv_int_rd_req_pd
  ,cv_int_rd_req_valid
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         cv_dma_rd_req_vld;
input         cv_int_rd_req_ready;
input  [78:0] dma_rd_req_pd;
output        cv_dma_rd_req_rdy;
output [78:0] cv_int_rd_req_pd;
output        cv_int_rd_req_valid;
reg           cv_dma_rd_req_rdy;
reg    [78:0] cv_int_rd_req_pd;
reg           cv_int_rd_req_valid;
reg    [78:0] p2_pipe_data;
reg    [78:0] p2_pipe_rand_data;
reg           p2_pipe_rand_ready;
reg           p2_pipe_rand_valid;
reg           p2_pipe_ready;
reg           p2_pipe_ready_bc;
reg           p2_pipe_valid;
reg           p2_skid_catch;
reg    [78:0] p2_skid_data;
reg    [78:0] p2_skid_pipe_data;
reg           p2_skid_pipe_ready;
reg           p2_skid_pipe_valid;
reg           p2_skid_ready;
reg           p2_skid_ready_flop;
reg           p2_skid_valid;
//## pipe (2) randomizer
`ifndef SYNTHESIS
reg p2_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p2_pipe_rand_active
  or 
     `endif
     cv_dma_rd_req_vld
  or p2_pipe_rand_ready
  or dma_rd_req_pd
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = cv_dma_rd_req_vld;
  cv_dma_rd_req_rdy = p2_pipe_rand_ready;
  p2_pipe_rand_data = dma_rd_req_pd[78:0];
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : cv_dma_rd_req_vld;
  cv_dma_rd_req_rdy = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : dma_rd_req_pd[78:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p2_pipe_stall_cycles;
integer p2_pipe_stall_probability;
integer p2_pipe_stall_cycles_min;
integer p2_pipe_stall_cycles_max;
initial begin
  p2_pipe_stall_cycles = 0;
  p2_pipe_stall_probability = 0;
  p2_pipe_stall_cycles_min = 1;
  p2_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or cv_dma_rd_req_vld
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && cv_dma_rd_req_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p2_pipe_rand_poised) begin
    if (p2_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p2_pipe_stall_cycles <= prand_inst1(p2_pipe_stall_cycles_min, p2_pipe_stall_cycles_max);
    end
  end else if (p2_pipe_rand_active) begin
    p2_pipe_stall_cycles <= p2_pipe_stall_cycles - 1;
  end else begin
    p2_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (2) skid buffer
always @(
  p2_pipe_rand_valid
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = p2_pipe_rand_valid && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    p2_pipe_rand_ready <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  p2_pipe_rand_ready <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or p2_pipe_rand_valid
  or p2_skid_valid
  or p2_pipe_rand_data
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? p2_pipe_rand_valid : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (2) valid-ready-bubble-collapse
always @(
  p2_pipe_ready
  or p2_pipe_valid
  ) begin
  p2_pipe_ready_bc = p2_pipe_ready || !p2_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? p2_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && p2_skid_pipe_valid)? p2_skid_pipe_data : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  p2_skid_pipe_ready = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or cv_int_rd_req_ready
  or p2_pipe_data
  ) begin
  cv_int_rd_req_valid = p2_pipe_valid;
  p2_pipe_ready = cv_int_rd_req_ready;
  cv_int_rd_req_pd = p2_pipe_data;
end
//## pipe (2) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p2_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_130x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_int_rd_req_valid^cv_int_rd_req_ready^cv_dma_rd_req_vld^cv_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_131x (nvdla_core_clk, `ASSERT_RESET, (cv_dma_rd_req_vld && !cv_dma_rd_req_rdy), (cv_dma_rd_req_vld), (cv_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDMA_WT_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os mc_dma_rd_rsp_pd (mc_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= mc_int_rd_rsp_pd[513:0] (mc_int_rd_rsp_valid,mc_int_rd_rsp_ready)
// **************************************************************************************************************
module NV_NVDLA_CDMA_WT_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma_rd_rsp_rdy
  ,mc_int_rd_rsp_pd
  ,mc_int_rd_rsp_valid
  ,mc_dma_rd_rsp_pd
  ,mc_dma_rd_rsp_vld
  ,mc_int_rd_rsp_ready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          dma_rd_rsp_rdy;
input  [513:0] mc_int_rd_rsp_pd;
input          mc_int_rd_rsp_valid;
output [513:0] mc_dma_rd_rsp_pd;
output         mc_dma_rd_rsp_vld;
output         mc_int_rd_rsp_ready;
reg    [513:0] mc_dma_rd_rsp_pd;
reg            mc_dma_rd_rsp_vld;
reg            mc_int_rd_rsp_ready;
reg    [513:0] p3_pipe_data;
reg    [513:0] p3_pipe_rand_data;
reg            p3_pipe_rand_ready;
reg            p3_pipe_rand_valid;
reg            p3_pipe_ready;
reg            p3_pipe_ready_bc;
reg    [513:0] p3_pipe_skid_data;
reg            p3_pipe_skid_ready;
reg            p3_pipe_skid_valid;
reg            p3_pipe_valid;
reg            p3_skid_catch;
reg    [513:0] p3_skid_data;
reg            p3_skid_ready;
reg            p3_skid_ready_flop;
reg            p3_skid_valid;
//## pipe (3) randomizer
`ifndef SYNTHESIS
reg p3_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p3_pipe_rand_active
  or 
     `endif
     mc_int_rd_rsp_valid
  or p3_pipe_rand_ready
  or mc_int_rd_rsp_pd
  ) begin
  `ifdef SYNTHESIS
  p3_pipe_rand_valid = mc_int_rd_rsp_valid;
  mc_int_rd_rsp_ready = p3_pipe_rand_ready;
  p3_pipe_rand_data = mc_int_rd_rsp_pd[513:0];
  `else
  // VCS coverage off
  p3_pipe_rand_valid = (p3_pipe_rand_active)? 1'b0 : mc_int_rd_rsp_valid;
  mc_int_rd_rsp_ready = (p3_pipe_rand_active)? 1'b0 : p3_pipe_rand_ready;
  p3_pipe_rand_data = (p3_pipe_rand_active)?  'bx : mc_int_rd_rsp_pd[513:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p3_pipe_stall_cycles;
integer p3_pipe_stall_probability;
integer p3_pipe_stall_cycles_min;
integer p3_pipe_stall_cycles_max;
initial begin
  p3_pipe_stall_cycles = 0;
  p3_pipe_stall_probability = 0;
  p3_pipe_stall_cycles_min = 1;
  p3_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_probability" ) ) p3_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_min"  ) ) p3_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_max"  ) ) p3_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p3_pipe_rand_enable;
reg p3_pipe_rand_poised;
always @(
  p3_pipe_stall_cycles
  or p3_pipe_stall_probability
  or mc_int_rd_rsp_valid
  ) begin
  p3_pipe_rand_active = p3_pipe_stall_cycles != 0;
  p3_pipe_rand_enable = p3_pipe_stall_probability != 0;
  p3_pipe_rand_poised = p3_pipe_rand_enable && !p3_pipe_rand_active && mc_int_rd_rsp_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p3_pipe_rand_poised) begin
    if (p3_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p3_pipe_stall_cycles <= prand_inst1(p3_pipe_stall_cycles_min, p3_pipe_stall_cycles_max);
    end
  end else if (p3_pipe_rand_active) begin
    p3_pipe_stall_cycles <= p3_pipe_stall_cycles - 1;
  end else begin
    p3_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (3) valid-ready-bubble-collapse
always @(
  p3_pipe_ready
  or p3_pipe_valid
  ) begin
  p3_pipe_ready_bc = p3_pipe_ready || !p3_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_valid <= 1'b0;
  end else begin
  p3_pipe_valid <= (p3_pipe_ready_bc)? p3_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && p3_pipe_rand_valid)? p3_pipe_rand_data : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  p3_pipe_rand_ready = p3_pipe_ready_bc;
end
//## pipe (3) skid buffer
always @(
  p3_pipe_valid
  or p3_skid_ready_flop
  or p3_pipe_skid_ready
  or p3_skid_valid
  ) begin
  p3_skid_catch = p3_pipe_valid && p3_skid_ready_flop && !p3_pipe_skid_ready;  
  p3_skid_ready = (p3_skid_valid)? p3_pipe_skid_ready : !p3_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_skid_valid <= 1'b0;
    p3_skid_ready_flop <= 1'b1;
    p3_pipe_ready <= 1'b1;
  end else begin
  p3_skid_valid <= (p3_skid_valid)? !p3_pipe_skid_ready : p3_skid_catch;
  p3_skid_ready_flop <= p3_skid_ready;
  p3_pipe_ready <= p3_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_skid_data <= (p3_skid_catch)? p3_pipe_data : p3_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p3_skid_ready_flop
  or p3_pipe_valid
  or p3_skid_valid
  or p3_pipe_data
  or p3_skid_data
  ) begin
  p3_pipe_skid_valid = (p3_skid_ready_flop)? p3_pipe_valid : p3_skid_valid; 
  // VCS sop_coverage_off start
  p3_pipe_skid_data = (p3_skid_ready_flop)? p3_pipe_data : p3_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (3) output
always @(
  p3_pipe_skid_valid
  or dma_rd_rsp_rdy
  or p3_pipe_skid_data
  ) begin
  mc_dma_rd_rsp_vld = p3_pipe_skid_valid;
  p3_pipe_skid_ready = dma_rd_rsp_rdy;
  mc_dma_rd_rsp_pd = p3_pipe_skid_data;
end
//## pipe (3) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p3_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_132x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_dma_rd_rsp_vld^dma_rd_rsp_rdy^mc_int_rd_rsp_valid^mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_133x (nvdla_core_clk, `ASSERT_RESET, (mc_int_rd_rsp_valid && !mc_int_rd_rsp_ready), (mc_int_rd_rsp_valid), (mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDMA_WT_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os cv_dma_rd_rsp_pd (cv_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= cv_int_rd_rsp_pd[513:0] (cv_int_rd_rsp_valid,cv_int_rd_rsp_ready)
// **************************************************************************************************************
module NV_NVDLA_CDMA_WT_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cv_int_rd_rsp_pd
  ,cv_int_rd_rsp_valid
  ,dma_rd_rsp_rdy
  ,cv_dma_rd_rsp_pd
  ,cv_dma_rd_rsp_vld
  ,cv_int_rd_rsp_ready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] cv_int_rd_rsp_pd;
input          cv_int_rd_rsp_valid;
input          dma_rd_rsp_rdy;
output [513:0] cv_dma_rd_rsp_pd;
output         cv_dma_rd_rsp_vld;
output         cv_int_rd_rsp_ready;
reg    [513:0] cv_dma_rd_rsp_pd;
reg            cv_dma_rd_rsp_vld;
reg            cv_int_rd_rsp_ready;
reg    [513:0] p4_pipe_data;
reg    [513:0] p4_pipe_rand_data;
reg            p4_pipe_rand_ready;
reg            p4_pipe_rand_valid;
reg            p4_pipe_ready;
reg            p4_pipe_ready_bc;
reg    [513:0] p4_pipe_skid_data;
reg            p4_pipe_skid_ready;
reg            p4_pipe_skid_valid;
reg            p4_pipe_valid;
reg            p4_skid_catch;
reg    [513:0] p4_skid_data;
reg            p4_skid_ready;
reg            p4_skid_ready_flop;
reg            p4_skid_valid;
//## pipe (4) randomizer
`ifndef SYNTHESIS
reg p4_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p4_pipe_rand_active
  or 
     `endif
     cv_int_rd_rsp_valid
  or p4_pipe_rand_ready
  or cv_int_rd_rsp_pd
  ) begin
  `ifdef SYNTHESIS
  p4_pipe_rand_valid = cv_int_rd_rsp_valid;
  cv_int_rd_rsp_ready = p4_pipe_rand_ready;
  p4_pipe_rand_data = cv_int_rd_rsp_pd[513:0];
  `else
  // VCS coverage off
  p4_pipe_rand_valid = (p4_pipe_rand_active)? 1'b0 : cv_int_rd_rsp_valid;
  cv_int_rd_rsp_ready = (p4_pipe_rand_active)? 1'b0 : p4_pipe_rand_ready;
  p4_pipe_rand_data = (p4_pipe_rand_active)?  'bx : cv_int_rd_rsp_pd[513:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p4_pipe_stall_cycles;
integer p4_pipe_stall_probability;
integer p4_pipe_stall_cycles_min;
integer p4_pipe_stall_cycles_max;
initial begin
  p4_pipe_stall_cycles = 0;
  p4_pipe_stall_probability = 0;
  p4_pipe_stall_cycles_min = 1;
  p4_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_probability" ) ) p4_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_min"  ) ) p4_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wt_pipe_stall_cycles_max"  ) ) p4_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p4_pipe_rand_enable;
reg p4_pipe_rand_poised;
always @(
  p4_pipe_stall_cycles
  or p4_pipe_stall_probability
  or cv_int_rd_rsp_valid
  ) begin
  p4_pipe_rand_active = p4_pipe_stall_cycles != 0;
  p4_pipe_rand_enable = p4_pipe_stall_probability != 0;
  p4_pipe_rand_poised = p4_pipe_rand_enable && !p4_pipe_rand_active && cv_int_rd_rsp_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p4_pipe_rand_poised) begin
    if (p4_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p4_pipe_stall_cycles <= prand_inst1(p4_pipe_stall_cycles_min, p4_pipe_stall_cycles_max);
    end
  end else if (p4_pipe_rand_active) begin
    p4_pipe_stall_cycles <= p4_pipe_stall_cycles - 1;
  end else begin
    p4_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (4) valid-ready-bubble-collapse
always @(
  p4_pipe_ready
  or p4_pipe_valid
  ) begin
  p4_pipe_ready_bc = p4_pipe_ready || !p4_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_valid <= 1'b0;
  end else begin
  p4_pipe_valid <= (p4_pipe_ready_bc)? p4_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && p4_pipe_rand_valid)? p4_pipe_rand_data : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  p4_pipe_rand_ready = p4_pipe_ready_bc;
end
//## pipe (4) skid buffer
always @(
  p4_pipe_valid
  or p4_skid_ready_flop
  or p4_pipe_skid_ready
  or p4_skid_valid
  ) begin
  p4_skid_catch = p4_pipe_valid && p4_skid_ready_flop && !p4_pipe_skid_ready;  
  p4_skid_ready = (p4_skid_valid)? p4_pipe_skid_ready : !p4_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_skid_valid <= 1'b0;
    p4_skid_ready_flop <= 1'b1;
    p4_pipe_ready <= 1'b1;
  end else begin
  p4_skid_valid <= (p4_skid_valid)? !p4_pipe_skid_ready : p4_skid_catch;
  p4_skid_ready_flop <= p4_skid_ready;
  p4_pipe_ready <= p4_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_skid_data <= (p4_skid_catch)? p4_pipe_data : p4_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p4_skid_ready_flop
  or p4_pipe_valid
  or p4_skid_valid
  or p4_pipe_data
  or p4_skid_data
  ) begin
  p4_pipe_skid_valid = (p4_skid_ready_flop)? p4_pipe_valid : p4_skid_valid; 
  // VCS sop_coverage_off start
  p4_pipe_skid_data = (p4_skid_ready_flop)? p4_pipe_data : p4_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (4) output
always @(
  p4_pipe_skid_valid
  or dma_rd_rsp_rdy
  or p4_pipe_skid_data
  ) begin
  cv_dma_rd_rsp_vld = p4_pipe_skid_valid;
  p4_pipe_skid_ready = dma_rd_rsp_rdy;
  cv_dma_rd_rsp_pd = p4_pipe_skid_data;
end
//## pipe (4) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p4_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_134x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_dma_rd_rsp_vld^dma_rd_rsp_rdy^cv_int_rd_rsp_valid^cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_135x (nvdla_core_clk, `ASSERT_RESET, (cv_int_rd_rsp_valid && !cv_int_rd_rsp_ready), (cv_int_rd_rsp_valid), (cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDMA_WT_pipe_p4



