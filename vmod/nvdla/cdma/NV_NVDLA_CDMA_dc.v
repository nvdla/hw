// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_dc.v

module NV_NVDLA_CDMA_dc (
   nvdla_core_clk            //|< i
  ,nvdla_core_ng_clk         //|< i
  ,nvdla_core_rstn           //|< i
  ,cvif2dc_dat_rd_rsp_pd     //|< i
  ,cvif2dc_dat_rd_rsp_valid  //|< i
  ,dc2sbuf_p0_rd_data        //|< i
  ,dc2sbuf_p1_rd_data        //|< i
  ,dc_dat2cvif_rd_req_ready  //|< i
  ,dc_dat2mcif_rd_req_ready  //|< i
  ,mcif2dc_dat_rd_rsp_pd     //|< i
  ,mcif2dc_dat_rd_rsp_valid  //|< i
  ,pwrbus_ram_pd             //|< i
  ,reg2dp_batch_stride       //|< i
  ,reg2dp_batches            //|< i
  ,reg2dp_conv_mode          //|< i
  ,reg2dp_data_bank          //|< i
  ,reg2dp_data_reuse         //|< i
  ,reg2dp_datain_addr_high_0 //|< i
  ,reg2dp_datain_addr_low_0  //|< i
  ,reg2dp_datain_channel     //|< i
  ,reg2dp_datain_format      //|< i
  ,reg2dp_datain_height      //|< i
  ,reg2dp_datain_ram_type    //|< i
  ,reg2dp_datain_width       //|< i
  ,reg2dp_dma_en             //|< i
  ,reg2dp_entries            //|< i
  ,reg2dp_grains             //|< i
  ,reg2dp_in_precision       //|< i
  ,reg2dp_line_packed        //|< i
  ,reg2dp_line_stride        //|< i
  ,reg2dp_op_en              //|< i
  ,reg2dp_proc_precision     //|< i
  ,reg2dp_skip_data_rls      //|< i
  ,reg2dp_surf_packed        //|< i
  ,reg2dp_surf_stride        //|< i
  ,sc2cdma_dat_pending_req   //|< i
  ,status2dma_free_entries   //|< i
  ,status2dma_fsm_switch     //|< i
  ,status2dma_valid_slices   //|< i *
  ,status2dma_wr_idx         //|< i
  ,cvif2dc_dat_rd_rsp_ready  //|> o
  ,dc2cvt_dat_wr_addr        //|> o
  ,dc2cvt_dat_wr_data        //|> o
  ,dc2cvt_dat_wr_en          //|> o
  ,dc2cvt_dat_wr_hsel        //|> o
  ,dc2cvt_dat_wr_info_pd     //|> o
  ,dc2sbuf_p0_rd_addr        //|> o
  ,dc2sbuf_p0_rd_en          //|> o
  ,dc2sbuf_p0_wr_addr        //|> o
  ,dc2sbuf_p0_wr_data        //|> o
  ,dc2sbuf_p0_wr_en          //|> o
  ,dc2sbuf_p1_rd_addr        //|> o
  ,dc2sbuf_p1_rd_en          //|> o
  ,dc2sbuf_p1_wr_addr        //|> o
  ,dc2sbuf_p1_wr_data        //|> o
  ,dc2sbuf_p1_wr_en          //|> o
  ,dc2status_dat_entries     //|> o
  ,dc2status_dat_slices      //|> o
  ,dc2status_dat_updt        //|> o
  ,dc2status_state           //|> o
  ,dc_dat2cvif_rd_req_pd     //|> o
  ,dc_dat2cvif_rd_req_valid  //|> o
  ,dc_dat2mcif_rd_req_pd     //|> o
  ,dc_dat2mcif_rd_req_valid  //|> o
  ,dp2reg_dc_rd_latency      //|> o
  ,dp2reg_dc_rd_stall        //|> o
  ,mcif2dc_dat_rd_rsp_ready  //|> o
  ,slcg_dc_gate_img          //|> o
  ,slcg_dc_gate_wg           //|> o
  );


//
// NV_NVDLA_CDMA_dc_ports.v
//
input  nvdla_core_clk;   /* dc_dat2mcif_rd_req, dc_dat2cvif_rd_req, mcif2dc_dat_rd_rsp, cvif2dc_dat_rd_rsp, dc2cvt_dat_wr, dc2cvt_dat_wr_info, switch_status2dma, state_dc2status, dat_up_dc2status, bc_status2dma, dc2sbuf_p0_wr, dc2sbuf_p1_wr, dc2sbuf_p0_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, dc2sbuf_p0_rd_nvdla_ram_data_DATA_WIDTH_256, dc2sbuf_p1_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, dc2sbuf_p1_rd_nvdla_ram_data_DATA_WIDTH_256, sc2cdma_dat_pending */
input  nvdla_core_rstn;  /* dc_dat2mcif_rd_req, dc_dat2cvif_rd_req, mcif2dc_dat_rd_rsp, cvif2dc_dat_rd_rsp, dc2cvt_dat_wr, dc2cvt_dat_wr_info, switch_status2dma, state_dc2status, dat_up_dc2status, bc_status2dma, dc2sbuf_p0_wr, dc2sbuf_p1_wr, dc2sbuf_p0_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, dc2sbuf_p0_rd_nvdla_ram_data_DATA_WIDTH_256, dc2sbuf_p1_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, dc2sbuf_p1_rd_nvdla_ram_data_DATA_WIDTH_256, sc2cdma_dat_pending */

input [31:0] pwrbus_ram_pd;

output        dc_dat2mcif_rd_req_valid;  /* data valid */
input         dc_dat2mcif_rd_req_ready;  /* data return handshake */
output [78:0] dc_dat2mcif_rd_req_pd;

output        dc_dat2cvif_rd_req_valid;  /* data valid */
input         dc_dat2cvif_rd_req_ready;  /* data return handshake */
output [78:0] dc_dat2cvif_rd_req_pd;

input          mcif2dc_dat_rd_rsp_valid;  /* data valid */
output         mcif2dc_dat_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2dc_dat_rd_rsp_pd;

input          cvif2dc_dat_rd_rsp_valid;  /* data valid */
output         cvif2dc_dat_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2dc_dat_rd_rsp_pd;

output         dc2cvt_dat_wr_en;    /* data valid */
output  [11:0] dc2cvt_dat_wr_addr;
output         dc2cvt_dat_wr_hsel;
output [511:0] dc2cvt_dat_wr_data;

output [11:0] dc2cvt_dat_wr_info_pd;

input  status2dma_fsm_switch;

output [1:0] dc2status_state;

output        dc2status_dat_updt;     /* data valid */
output [11:0] dc2status_dat_entries;
output [11:0] dc2status_dat_slices;

input [11:0] status2dma_valid_slices;
input [11:0] status2dma_free_entries;
input [11:0] status2dma_wr_idx;

output         dc2sbuf_p0_wr_en;    /* data valid */
output   [7:0] dc2sbuf_p0_wr_addr;
output [255:0] dc2sbuf_p0_wr_data;

output         dc2sbuf_p1_wr_en;    /* data valid */
output   [7:0] dc2sbuf_p1_wr_addr;
output [255:0] dc2sbuf_p1_wr_data;

output       dc2sbuf_p0_rd_en;    /* data valid */
output [7:0] dc2sbuf_p0_rd_addr;

input [255:0] dc2sbuf_p0_rd_data;

output       dc2sbuf_p1_rd_en;    /* data valid */
output [7:0] dc2sbuf_p1_rd_addr;

input [255:0] dc2sbuf_p1_rd_data;

input  sc2cdma_dat_pending_req;

input nvdla_core_ng_clk;

input [0:0]                     reg2dp_op_en;
input [0:0]                  reg2dp_conv_mode;
input [1:0]               reg2dp_in_precision;
input [1:0]             reg2dp_proc_precision;
input [0:0]                 reg2dp_data_reuse;
input [0:0]              reg2dp_skip_data_rls;
input [0:0]         reg2dp_datain_format;
input [12:0]          reg2dp_datain_width;
input [12:0]         reg2dp_datain_height;
input [12:0]        reg2dp_datain_channel;
input [0:0]       reg2dp_datain_ram_type;
input [31:0] reg2dp_datain_addr_high_0;
input [26:0]   reg2dp_datain_addr_low_0;
input [26:0]             reg2dp_line_stride;
input [26:0]             reg2dp_surf_stride;
input [0:0]                reg2dp_line_packed;
input [0:0]                reg2dp_surf_packed;
input [4:0]                reg2dp_batches;
input [26:0]           reg2dp_batch_stride;
input [11:0]             reg2dp_entries;
input [11:0]                  reg2dp_grains;
input [3:0]                      reg2dp_data_bank;
input [0:0]                  reg2dp_dma_en;

output slcg_dc_gate_wg;
output slcg_dc_gate_img;

output [31:0]       dp2reg_dc_rd_stall;
output [31:0]   dp2reg_dc_rd_latency;

wire    [11:0] cbuf_wr_addr_d0;
wire           cbuf_wr_en_d0;
wire           cbuf_wr_hsel_d0;
wire           cbuf_wr_info_mean;
wire    [11:0] cbuf_wr_info_pd;
wire    [11:0] cbuf_wr_info_pd_d0;
wire     [2:0] cbuf_wr_info_sub_h;
wire           cbuf_wr_info_uint;
wire     [7:0] ch0_p0_rd_addr;
wire     [7:0] ch0_p0_wr_addr;
wire     [7:0] ch0_p1_rd_addr;
wire     [7:0] ch0_p1_wr_addr;
wire     [7:0] ch1_p0_wr_addr;
wire     [7:0] ch1_p1_rd_addr;
wire     [7:0] ch1_p1_wr_addr;
wire     [7:0] ch2_p0_rd_addr;
wire     [7:0] ch2_p0_wr_addr;
wire     [7:0] ch2_p1_wr_addr;
wire     [7:0] ch3_p0_wr_addr;
wire     [7:0] ch3_p1_rd_addr;
wire     [7:0] ch3_p1_wr_addr;
wire           csm_reg_en;
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
wire   [513:0] cvif2dc_dat_rd_rsp_pd_d0;
wire           cvif2dc_dat_rd_rsp_ready_d0;
wire           cvif2dc_dat_rd_rsp_valid_d0;
wire           dbg_is_last_reuse_w;
wire     [4:0] delay_cnt_end;
wire    [63:0] dma_rd_req_addr;
wire    [78:0] dma_rd_req_pd;
wire           dma_rd_req_rdy;
wire    [15:0] dma_rd_req_size;
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
wire           dp2reg_dc_rd_stall_dec;
wire           is_hog;
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
wire   [513:0] mcif2dc_dat_rd_rsp_pd_d0;
wire           mcif2dc_dat_rd_rsp_ready_d0;
wire           mcif2dc_dat_rd_rsp_valid_d0;
wire           p0_rd_en_w;
wire           pending_req_end;
wire           rd_req_rdyi;
wire    [58:0] req_addr_ori;
wire           req_ready_d0;
wire           req_ready_d1;
wire           req_valid_d0;
wire           req_valid_d1_w;
wire     [1:0] rsp_ch0_rd_size;
wire     [2:0] rsp_ch_mode;
wire           slcg_dc_en_w;
wire     [1:0] slcg_dc_gate_w;
reg     [12:0] cbuf_idx_inc;
reg     [11:0] cbuf_idx_w;
reg            cbuf_is_ready;
reg            cbuf_is_ready_w;
reg     [11:0] cbuf_wr_addr;
reg     [11:0] cbuf_wr_addr_d1;
reg     [11:0] cbuf_wr_addr_d2;
reg     [11:0] cbuf_wr_addr_d3;
reg    [511:0] cbuf_wr_data_d3;
reg            cbuf_wr_en;
reg            cbuf_wr_en_d1;
reg            cbuf_wr_en_d2;
reg            cbuf_wr_en_d3;
reg            cbuf_wr_ext128_w;
reg            cbuf_wr_ext64_w;
reg            cbuf_wr_hsel;
reg            cbuf_wr_hsel_d1;
reg            cbuf_wr_hsel_d2;
reg            cbuf_wr_hsel_d3;
reg            cbuf_wr_hsel_w;
reg            cbuf_wr_info_ext128;
reg            cbuf_wr_info_ext64;
reg            cbuf_wr_info_interleave;
reg      [3:0] cbuf_wr_info_mask;
reg     [11:0] cbuf_wr_info_pd_d1;
reg     [11:0] cbuf_wr_info_pd_d2;
reg     [11:0] cbuf_wr_info_pd_d3;
reg            cbuf_wr_interleave_w;
reg            ch0_aval;
reg      [4:0] ch0_cnt;
reg      [1:0] ch0_cnt_add;
reg      [1:0] ch0_cnt_sub;
reg      [4:0] ch0_cnt_w;
reg      [5:0] ch0_p0_rd_addr_cnt;
reg      [5:0] ch0_p0_rd_addr_cnt_w;
reg      [5:0] ch0_p0_wr_addr_cnt;
reg      [5:0] ch0_p0_wr_addr_cnt_w;
reg      [5:0] ch0_p1_rd_addr_cnt;
reg      [5:0] ch0_p1_rd_addr_cnt_w;
reg      [5:0] ch0_p1_wr_addr_cnt;
reg      [5:0] ch0_p1_wr_addr_cnt_w;
reg            ch0_rd_addr_cnt_reg_en;
reg            ch0_wr_addr_cnt_reg_en;
reg            ch1_aval;
reg      [4:0] ch1_cnt;
reg      [1:0] ch1_cnt_add;
reg            ch1_cnt_sub;
reg      [4:0] ch1_cnt_w;
reg      [5:0] ch1_p0_wr_addr_cnt;
reg      [5:0] ch1_p0_wr_addr_cnt_w;
reg      [5:0] ch1_p1_rd_addr_cnt;
reg      [5:0] ch1_p1_rd_addr_cnt_w;
reg      [5:0] ch1_p1_wr_addr_cnt;
reg      [5:0] ch1_p1_wr_addr_cnt_w;
reg            ch1_rd_addr_cnt_reg_en;
reg            ch1_wr_addr_cnt_reg_en;
reg            ch2_aval;
reg      [4:0] ch2_cnt;
reg      [1:0] ch2_cnt_add;
reg            ch2_cnt_sub;
reg      [4:0] ch2_cnt_w;
reg      [5:0] ch2_p0_rd_addr_cnt;
reg      [5:0] ch2_p0_rd_addr_cnt_w;
reg      [5:0] ch2_p0_wr_addr_cnt;
reg      [5:0] ch2_p0_wr_addr_cnt_w;
reg      [5:0] ch2_p1_wr_addr_cnt;
reg      [5:0] ch2_p1_wr_addr_cnt_w;
reg            ch2_rd_addr_cnt_reg_en;
reg            ch2_wr_addr_cnt_reg_en;
reg            ch3_aval;
reg      [4:0] ch3_cnt;
reg      [1:0] ch3_cnt_add;
reg            ch3_cnt_sub;
reg      [4:0] ch3_cnt_w;
reg      [5:0] ch3_p0_wr_addr_cnt;
reg      [5:0] ch3_p0_wr_addr_cnt_w;
reg      [5:0] ch3_p1_rd_addr_cnt;
reg      [5:0] ch3_p1_rd_addr_cnt_w;
reg      [5:0] ch3_p1_wr_addr_cnt;
reg      [5:0] ch3_p1_wr_addr_cnt_w;
reg            ch3_rd_addr_cnt_reg_en;
reg            ch3_wr_addr_cnt_reg_en;
reg            cur_atm_done;
reg      [1:0] cur_state;
reg     [11:0] dat_entries_d0;
reg     [11:0] dat_entries_d1;
reg     [11:0] dat_entries_d2;
reg     [11:0] dat_entries_d3;
reg     [11:0] dat_slices_d0;
reg     [11:0] dat_slices_d1;
reg     [11:0] dat_slices_d2;
reg     [11:0] dat_slices_d3;
reg            dat_updt_d0;
reg            dat_updt_d1;
reg            dat_updt_d2;
reg            dat_updt_d3;
reg      [3:0] data_bank;
reg      [5:0] data_batch;
reg     [11:0] data_entries;
reg     [11:0] data_entries_w;
reg     [13:0] data_height;
reg     [13:0] data_height_w;
reg      [9:0] data_surface;
reg      [9:0] data_surface_inc;
reg      [9:0] data_surface_w;
reg     [15:0] data_width;
reg     [13:0] data_width_inc;
reg     [14:0] data_width_sub_one;
reg     [14:0] data_width_sub_one_w;
reg     [15:0] data_width_w;
reg            dbg_is_last_reuse;
reg      [7:0] dc2sbuf_p0_rd_addr;
reg            dc2sbuf_p0_rd_en;
reg      [7:0] dc2sbuf_p1_rd_addr;
reg            dc2sbuf_p1_rd_en;
reg      [1:0] dc2status_state;
reg      [1:0] dc2status_state_w;
reg            dc_en;
reg     [11:0] dc_entry_onfly;
reg     [11:0] dc_entry_onfly_add;
reg     [11:0] dc_entry_onfly_sub;
reg     [11:0] dc_entry_onfly_w;
reg            dc_rd_latency_cen;
reg            dc_rd_latency_clr;
reg            dc_rd_latency_dec;
reg            dc_rd_latency_inc;
reg            dc_rd_stall_cen;
reg            dc_rd_stall_clr;
reg            dc_rd_stall_inc;
reg      [4:0] delay_cnt;
reg      [4:0] delay_cnt_w;
reg      [5:0] dma_req_fifo_data;
reg            dma_req_fifo_req;
reg      [1:0] dma_rsp_ch_idx;
reg    [255:0] dma_rsp_data_p0;
reg    [255:0] dma_rsp_data_p1;
reg            dma_rsp_fifo_ready;
reg      [3:0] dma_rsp_size;
reg      [3:0] dma_rsp_size_cnt;
reg      [3:0] dma_rsp_size_cnt_inc;
reg      [3:0] dma_rsp_size_cnt_w;
reg     [31:0] dp2reg_dc_rd_latency;
reg     [31:0] dp2reg_dc_rd_stall;
reg     [11:0] entry_per_batch;
reg     [11:0] entry_per_batch_d2;
reg     [11:0] entry_required;
reg            fetch_done;
reg     [11:0] fetch_grain;
reg     [11:0] fetch_grain_w;
reg     [38:0] grain_addr;
reg     [38:0] grain_addr_w;
reg     [11:0] idx_base;
reg     [11:0] idx_batch_offset;
reg     [11:0] idx_batch_offset_w;
reg     [11:0] idx_ch_offset;
reg     [11:0] idx_ch_offset_w;
reg     [11:0] idx_grain_offset;
reg     [11:0] idx_grain_offset_w;
reg     [11:0] idx_h_offset;
reg     [11:0] idx_h_offset_w;
reg     [11:0] idx_w_offset_add;
reg      [3:0] is_atm_done;
reg            is_blocking;
reg            is_blocking_w;
reg            is_cbuf_idx_wrap;
reg            is_data_expand;
reg            is_data_normal;
reg            is_data_shrink;
reg            is_dc;
reg            is_done;
reg            is_feature;
reg            is_first_running;
reg            is_free_entries_enough;
reg            is_idle;
reg            is_input_int8;
reg            is_int8;
reg            is_nxt_running;
reg            is_packed_1x1;
reg            is_pending;
reg            is_req_atm_end;
reg            is_req_atm_sel_end;
reg            is_req_batch_end;
reg            is_req_ch_end;
reg            is_req_grain_last;
reg            is_req_grain_last_d1;
reg            is_req_grain_last_d2;
reg            is_rsp_all_h_end;
reg            is_rsp_batch_end;
reg            is_rsp_ch0;
reg            is_rsp_ch1;
reg            is_rsp_ch2;
reg            is_rsp_ch3;
reg            is_rsp_ch_end;
reg            is_rsp_done;
reg            is_rsp_h_end;
reg            is_rsp_w_end;
reg            is_running;
reg            is_w_cnt_div2;
reg            is_w_cnt_div4;
reg            is_w_cnt_div8;
reg      [3:0] last_data_bank;
reg            last_dc;
reg            last_skip_data_rls;
reg            layer_st;
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
reg            mode_match;
reg            mon_cbuf_idx_inc;
reg      [1:0] mon_cbuf_idx_w;
reg            mon_ch0_cnt_w;
reg            mon_ch0_p0_rd_addr_cnt_w;
reg            mon_ch0_p0_wr_addr_cnt_w;
reg            mon_ch0_p1_rd_addr_cnt_w;
reg            mon_ch0_p1_wr_addr_cnt_w;
reg            mon_ch1_cnt_w;
reg            mon_ch1_p0_wr_addr_cnt_w;
reg            mon_ch1_p1_rd_addr_cnt_w;
reg            mon_ch1_p1_wr_addr_cnt_w;
reg            mon_ch2_cnt_w;
reg            mon_ch2_p0_rd_addr_cnt_w;
reg            mon_ch2_p0_wr_addr_cnt_w;
reg            mon_ch2_p1_wr_addr_cnt_w;
reg            mon_ch3_cnt_w;
reg            mon_ch3_p0_wr_addr_cnt_w;
reg            mon_ch3_p1_rd_addr_cnt_w;
reg            mon_ch3_p1_wr_addr_cnt_w;
reg            mon_data_entries_w;
reg            mon_dc_entry_onfly_w;
reg            mon_delay_cnt_w;
reg            mon_dma_rsp_size_cnt_inc;
reg      [5:0] mon_entry_per_batch;
reg     [11:0] mon_entry_required;
reg            mon_fetch_grain_w;
reg            mon_idx_batch_offset_w;
reg            mon_idx_ch_offset_w;
reg            mon_idx_grain_offset_w;
reg            mon_idx_h_offset_w;
reg            mon_req_addr;
reg            mon_req_addr_base_inc;
reg            mon_req_addr_batch_base_inc;
reg            mon_req_addr_ch_base_inc;
reg            mon_req_addr_grain_base_inc;
reg            mon_req_atm_cnt_inc;
reg            mon_req_atm_left;
reg            mon_req_atm_size_addr_limit;
reg      [1:0] mon_req_atm_size_out;
reg            mon_req_batch_cnt_inc;
reg            mon_req_ch_cnt_inc;
reg            mon_req_ch_left_w;
reg     [13:0] mon_req_cur_atomic;
reg            mon_req_height_cnt_inc;
reg      [2:0] mon_req_slice_left;
reg            mon_rsp_all_h_cnt_inc;
reg            mon_rsp_all_h_left_w;
reg            mon_rsp_batch_cnt_inc;
reg            mon_rsp_ch_cnt_inc;
reg            mon_rsp_ch_left_w;
reg            mon_rsp_h_cnt_inc;
reg            mon_rsp_w_cnt_inc;
reg            need_pending;
reg      [1:0] nxt_state;
reg      [8:0] outs_dp2reg_dc_rd_latency;
reg      [7:0] p0_rd_addr_w;
reg      [7:0] p0_wr_addr;
reg            p0_wr_en;
reg      [7:0] p1_rd_addr_w;
reg            p1_rd_en_w;
reg      [7:0] p1_wr_addr;
reg            p1_wr_en;
reg            pending_req;
reg            pending_req_d1;
reg            pre_gen_sel;
reg            pre_gen_sel_w;
reg            pre_ready;
reg            pre_ready_d1;
reg            pre_ready_d2;
reg            pre_reg_en;
reg            pre_reg_en_d1;
reg            pre_reg_en_d2;
reg            pre_reg_en_d2_g0;
reg            pre_reg_en_d2_g1;
reg            pre_reg_en_d2_init;
reg            pre_reg_en_d2_last;
reg            pre_valid_d1;
reg            pre_valid_d1_w;
reg            pre_valid_d2;
reg            pre_valid_d2_w;
reg     [58:0] req_addr;
reg     [58:0] req_addr_base;
reg     [58:0] req_addr_base_inc;
reg     [58:0] req_addr_base_w;
reg     [58:0] req_addr_batch_base;
reg     [58:0] req_addr_batch_base_inc;
reg     [58:0] req_addr_batch_base_w;
reg     [58:0] req_addr_ch_base;
reg     [28:0] req_addr_ch_base_add;
reg     [58:0] req_addr_ch_base_inc;
reg     [58:0] req_addr_ch_base_w;
reg     [58:0] req_addr_d1;
reg     [58:0] req_addr_grain_base;
reg     [58:0] req_addr_grain_base_inc;
reg     [58:0] req_addr_grain_base_w;
reg     [13:0] req_atm;
reg     [13:0] req_atm_cnt;
reg     [13:0] req_atm_cnt_0;
reg     [13:0] req_atm_cnt_0_w;
reg     [13:0] req_atm_cnt_1;
reg     [13:0] req_atm_cnt_1_w;
reg     [13:0] req_atm_cnt_2;
reg     [13:0] req_atm_cnt_2_w;
reg     [13:0] req_atm_cnt_3;
reg     [13:0] req_atm_cnt_3_w;
reg     [13:0] req_atm_cnt_inc;
reg     [13:0] req_atm_left;
reg            req_atm_reg_en;
reg            req_atm_reg_en_0;
reg            req_atm_reg_en_1;
reg            req_atm_reg_en_2;
reg            req_atm_reg_en_3;
reg      [1:0] req_atm_sel;
reg      [2:0] req_atm_sel_inc;
reg      [1:0] req_atm_sel_w;
reg      [3:0] req_atm_size;
reg      [3:0] req_atm_size_addr_limit;
reg      [2:0] req_atm_size_out;
reg     [13:0] req_atomic_0_d3;
reg     [13:0] req_atomic_1_d3;
reg     [13:0] req_atomic_d2;
reg      [4:0] req_batch_cnt;
reg      [4:0] req_batch_cnt_inc;
reg      [4:0] req_batch_cnt_w;
reg            req_batch_reg_en;
reg      [9:0] req_ch_cnt;
reg      [9:0] req_ch_cnt_inc;
reg      [9:0] req_ch_cnt_w;
reg      [1:0] req_ch_idx_d1;
reg      [9:0] req_ch_left_w;
reg      [2:0] req_ch_mode;
reg            req_ch_reg_en;
reg            req_csm_sel;
reg            req_csm_sel_w;
reg     [13:0] req_cur_atomic;
reg      [2:0] req_cur_ch;
reg      [2:0] req_cur_ch_w;
reg     [11:0] req_cur_grain_d1;
reg     [11:0] req_cur_grain_d2;
reg     [11:0] req_cur_grain_w;
reg     [11:0] req_entry;
reg     [11:0] req_entry_0_d3;
reg     [11:0] req_entry_1_d3;
reg            req_grain_reg_en;
reg     [13:0] req_height_cnt_d1;
reg     [13:0] req_height_cnt_inc;
reg            req_pre_valid;
reg            req_pre_valid_0_d3;
reg            req_pre_valid_0_w;
reg            req_pre_valid_1_d3;
reg            req_pre_valid_1_w;
reg            req_reg_en;
reg      [3:0] req_size_d1;
reg      [2:0] req_size_out_d1;
reg     [11:0] req_slice_left;
reg            req_valid_d1;
reg     [12:0] required_entries;
reg     [13:0] rsp_all_h_cnt;
reg     [13:0] rsp_all_h_cnt_inc;
reg     [13:0] rsp_all_h_cnt_w;
reg     [13:0] rsp_all_h_left_w;
reg            rsp_all_h_reg_en;
reg      [4:0] rsp_batch_cnt;
reg      [4:0] rsp_batch_cnt_inc;
reg      [4:0] rsp_batch_cnt_w;
reg     [11:0] rsp_batch_entry_init;
reg     [11:0] rsp_batch_entry_last;
reg            rsp_batch_reg_en;
reg            rsp_ch0_rd_one;
reg      [9:0] rsp_ch_cnt;
reg      [9:0] rsp_ch_cnt_inc;
reg      [9:0] rsp_ch_cnt_w;
reg      [9:0] rsp_ch_left_w;
reg            rsp_ch_reg_en;
reg      [2:0] rsp_cur_ch;
reg      [2:0] rsp_cur_ch_w;
reg     [11:0] rsp_cur_grain;
reg     [11:0] rsp_cur_grain_w;
reg     [11:0] rsp_entry;
reg     [11:0] rsp_entry_init;
reg     [11:0] rsp_entry_last;
reg     [11:0] rsp_h_cnt;
reg     [11:0] rsp_h_cnt_inc;
reg     [11:0] rsp_h_cnt_w;
reg            rsp_h_reg_en;
reg            rsp_rd_ch2ch3;
reg            rsp_rd_ch2ch3_w;
reg            rsp_rd_en;
reg            rsp_rd_one;
reg     [11:0] rsp_slice;
reg     [11:0] rsp_slice_init;
reg     [11:0] rsp_slice_last;
reg     [15:0] rsp_w_cnt;
reg      [1:0] rsp_w_cnt_add;
reg     [15:0] rsp_w_cnt_inc;
reg     [15:0] rsp_w_cnt_w;
reg            rsp_w_one_left;
reg            rsp_w_reg_en;
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

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
////////////////////////////////////////////////////////////////////////
// CDMA direct convolution data fetching logic FSM                    //
////////////////////////////////////////////////////////////////////////

//## fsm (1) output

//|)

//## fsm (1) defines

localparam DC_STATE_IDLE = 2'b00;
localparam DC_STATE_PEND = 2'b01;
localparam DC_STATE_BUSY = 2'b10;
localparam DC_STATE_DONE = 2'b11;

//## fsm (1) com block

always @(
  cur_state
  or dc_en
  or need_pending
  or reg2dp_data_reuse
  or last_skip_data_rls
  or mode_match
  or pending_req_end
  or fetch_done
  or status2dma_fsm_switch
  ) begin
  nxt_state = cur_state;
  begin
    casez (cur_state)
      DC_STATE_IDLE: begin
        if ((dc_en & need_pending)) begin
          nxt_state = DC_STATE_PEND; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((dc_en & need_pending)) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if ((dc_en & reg2dp_data_reuse & last_skip_data_rls & mode_match)) begin
          nxt_state = DC_STATE_DONE; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((dc_en & reg2dp_data_reuse & last_skip_data_rls & mode_match)) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if (dc_en) begin
          nxt_state = DC_STATE_BUSY; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((dc_en) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      DC_STATE_PEND: begin
        if ((pending_req_end)) begin
          nxt_state = DC_STATE_BUSY; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((pending_req_end)) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      DC_STATE_BUSY: begin
        if (fetch_done) begin
          nxt_state = DC_STATE_DONE; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((fetch_done) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      DC_STATE_DONE: begin
        if (status2dma_fsm_switch) begin
          nxt_state = DC_STATE_IDLE; 
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
        nxt_state = DC_STATE_IDLE; 
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
    cur_state <= DC_STATE_IDLE;
  end else begin
  cur_state <= nxt_state;
  end
end

//## fsm (1) reachable testpoints


`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_DC_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_DC_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_DC_STATE_IDLE
    `define COVER_OR_TP__state_reachable_DC_STATE_IDLE_OR_COVER
  `endif // TP__state_reachable_DC_STATE_IDLE

`ifdef COVER_OR_TP__state_reachable_DC_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_DC_STATE_IDLE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: state_reachable_DC_STATE_IDLE ::: cur_state==DC_STATE_IDLE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: state_reachable_DC_STATE_IDLE ::: testpoint_0_goal_0
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
            if ((cur_state==DC_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: state_reachable_DC_STATE_IDLE ::: testpoint_0_goal_0");
 `endif
            if ((cur_state==DC_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
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
    wire testpoint_0_goal_0_active = ((cur_state==DC_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_0_goal_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_DC_STATE_IDLE_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_DC_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_DC_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_DC_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_DC_STATE_PEND
    `define COVER_OR_TP__state_reachable_DC_STATE_PEND_OR_COVER
  `endif // TP__state_reachable_DC_STATE_PEND

`ifdef COVER_OR_TP__state_reachable_DC_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_DC_STATE_PEND"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: state_reachable_DC_STATE_PEND ::: cur_state==DC_STATE_PEND");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: state_reachable_DC_STATE_PEND ::: testpoint_1_goal_0
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
            if ((cur_state==DC_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: state_reachable_DC_STATE_PEND ::: testpoint_1_goal_0");
 `endif
            if ((cur_state==DC_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
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
    wire testpoint_1_goal_0_active = ((cur_state==DC_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_1_goal_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_DC_STATE_PEND_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_DC_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_DC_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_DC_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_DC_STATE_BUSY
    `define COVER_OR_TP__state_reachable_DC_STATE_BUSY_OR_COVER
  `endif // TP__state_reachable_DC_STATE_BUSY

`ifdef COVER_OR_TP__state_reachable_DC_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_DC_STATE_BUSY"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: state_reachable_DC_STATE_BUSY ::: cur_state==DC_STATE_BUSY");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: state_reachable_DC_STATE_BUSY ::: testpoint_2_goal_0
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
            if ((cur_state==DC_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: state_reachable_DC_STATE_BUSY ::: testpoint_2_goal_0");
 `endif
            if ((cur_state==DC_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
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
    wire testpoint_2_goal_0_active = ((cur_state==DC_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_DC_STATE_BUSY_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_DC_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_DC_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_DC_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_DC_STATE_DONE
    `define COVER_OR_TP__state_reachable_DC_STATE_DONE_OR_COVER
  `endif // TP__state_reachable_DC_STATE_DONE

`ifdef COVER_OR_TP__state_reachable_DC_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_DC_STATE_DONE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: state_reachable_DC_STATE_DONE ::: cur_state==DC_STATE_DONE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: state_reachable_DC_STATE_DONE ::: testpoint_3_goal_0
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
            if ((cur_state==DC_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: state_reachable_DC_STATE_DONE ::: testpoint_3_goal_0");
 `endif
            if ((cur_state==DC_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
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
    wire testpoint_3_goal_0_active = ((cur_state==DC_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_3_goal_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_DC_STATE_DONE_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_DC_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

//## fsm (1) transition testpoints

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__transition_DC_STATE_IDLE__to__DC_STATE_PEND
    `define COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_PEND_OR_COVER
  `endif // TP__transition_DC_STATE_IDLE__to__DC_STATE_PEND

`ifdef COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_DC_STATE_IDLE__to__DC_STATE_PEND"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: transition_DC_STATE_IDLE__to__DC_STATE_PEND ::: (cur_state==DC_STATE_IDLE) && (nxt_state == DC_STATE_PEND)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: transition_DC_STATE_IDLE__to__DC_STATE_PEND ::: testpoint_4_goal_0
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
            if (((cur_state==DC_STATE_IDLE) && (nxt_state == DC_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: transition_DC_STATE_IDLE__to__DC_STATE_PEND ::: testpoint_4_goal_0");
 `endif
            if (((cur_state==DC_STATE_IDLE) && (nxt_state == DC_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
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
    wire testpoint_4_goal_0_active = (((cur_state==DC_STATE_IDLE) && (nxt_state == DC_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_4_goal_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_DC_STATE_IDLE__to__DC_STATE_PEND_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_DC_STATE_IDLE__to__DC_STATE_DONE
    `define COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_DONE_OR_COVER
  `endif // TP__transition_DC_STATE_IDLE__to__DC_STATE_DONE

`ifdef COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_DC_STATE_IDLE__to__DC_STATE_DONE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: transition_DC_STATE_IDLE__to__DC_STATE_DONE ::: (cur_state==DC_STATE_IDLE) && (nxt_state == DC_STATE_DONE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: transition_DC_STATE_IDLE__to__DC_STATE_DONE ::: testpoint_5_goal_0
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
            if (((cur_state==DC_STATE_IDLE) && (nxt_state == DC_STATE_DONE)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: transition_DC_STATE_IDLE__to__DC_STATE_DONE ::: testpoint_5_goal_0");
 `endif
            if (((cur_state==DC_STATE_IDLE) && (nxt_state == DC_STATE_DONE)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
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
    wire testpoint_5_goal_0_active = (((cur_state==DC_STATE_IDLE) && (nxt_state == DC_STATE_DONE)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_5_goal_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_DC_STATE_IDLE__to__DC_STATE_DONE_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__transition_DC_STATE_IDLE__to__DC_STATE_BUSY
    `define COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_BUSY_OR_COVER
  `endif // TP__transition_DC_STATE_IDLE__to__DC_STATE_BUSY

`ifdef COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_DC_STATE_IDLE__to__DC_STATE_BUSY"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: transition_DC_STATE_IDLE__to__DC_STATE_BUSY ::: (cur_state==DC_STATE_IDLE) && (nxt_state == DC_STATE_BUSY)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: transition_DC_STATE_IDLE__to__DC_STATE_BUSY ::: testpoint_6_goal_0
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
            if (((cur_state==DC_STATE_IDLE) && (nxt_state == DC_STATE_BUSY)) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: transition_DC_STATE_IDLE__to__DC_STATE_BUSY ::: testpoint_6_goal_0");
 `endif
            if (((cur_state==DC_STATE_IDLE) && (nxt_state == DC_STATE_BUSY)) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk)
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
    wire testpoint_6_goal_0_active = (((cur_state==DC_STATE_IDLE) && (nxt_state == DC_STATE_BUSY)) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_6_goal_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_DC_STATE_IDLE__to__DC_STATE_BUSY_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_DC_STATE_IDLE__to__DC_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_DC_STATE_IDLE__to__DC_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_DC_STATE_IDLE__to__DC_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_DC_STATE_IDLE__to__DC_STATE_IDLE
    `define COVER_OR_TP__self_transition_DC_STATE_IDLE__to__DC_STATE_IDLE_OR_COVER
  `endif // TP__self_transition_DC_STATE_IDLE__to__DC_STATE_IDLE

`ifdef COVER_OR_TP__self_transition_DC_STATE_IDLE__to__DC_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_DC_STATE_IDLE__to__DC_STATE_IDLE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: self_transition_DC_STATE_IDLE__to__DC_STATE_IDLE ::: cur_state==DC_STATE_IDLE && nxt_state==DC_STATE_IDLE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: self_transition_DC_STATE_IDLE__to__DC_STATE_IDLE ::: testpoint_7_goal_0
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
            if ((cur_state==DC_STATE_IDLE && nxt_state==DC_STATE_IDLE) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: self_transition_DC_STATE_IDLE__to__DC_STATE_IDLE ::: testpoint_7_goal_0");
 `endif
            if ((cur_state==DC_STATE_IDLE && nxt_state==DC_STATE_IDLE) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk)
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
    wire testpoint_7_goal_0_active = ((cur_state==DC_STATE_IDLE && nxt_state==DC_STATE_IDLE) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_7_goal_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_DC_STATE_IDLE__to__DC_STATE_IDLE_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_DC_STATE_IDLE__to__DC_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_DC_STATE_PEND__to__DC_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_DC_STATE_PEND__to__DC_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__transition_DC_STATE_PEND__to__DC_STATE_BUSY
    `define COVER_OR_TP__transition_DC_STATE_PEND__to__DC_STATE_BUSY_OR_COVER
  `endif // TP__transition_DC_STATE_PEND__to__DC_STATE_BUSY

`ifdef COVER_OR_TP__transition_DC_STATE_PEND__to__DC_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_DC_STATE_PEND__to__DC_STATE_BUSY"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: transition_DC_STATE_PEND__to__DC_STATE_BUSY ::: (cur_state==DC_STATE_PEND) && (nxt_state == DC_STATE_BUSY)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: transition_DC_STATE_PEND__to__DC_STATE_BUSY ::: testpoint_8_goal_0
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
            if (((cur_state==DC_STATE_PEND) && (nxt_state == DC_STATE_BUSY)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: transition_DC_STATE_PEND__to__DC_STATE_BUSY ::: testpoint_8_goal_0");
 `endif
            if (((cur_state==DC_STATE_PEND) && (nxt_state == DC_STATE_BUSY)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk)
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
    wire testpoint_8_goal_0_active = (((cur_state==DC_STATE_PEND) && (nxt_state == DC_STATE_BUSY)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_8_goal_0 (.clk (testpoint_8_internal_nvdla_core_clk), .tp(testpoint_8_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_DC_STATE_PEND__to__DC_STATE_BUSY_0 (.clk (testpoint_8_internal_nvdla_core_clk), .tp(testpoint_8_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_DC_STATE_PEND__to__DC_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_DC_STATE_PEND__to__DC_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_DC_STATE_PEND__to__DC_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_DC_STATE_PEND__to__DC_STATE_PEND
    `define COVER_OR_TP__self_transition_DC_STATE_PEND__to__DC_STATE_PEND_OR_COVER
  `endif // TP__self_transition_DC_STATE_PEND__to__DC_STATE_PEND

`ifdef COVER_OR_TP__self_transition_DC_STATE_PEND__to__DC_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_DC_STATE_PEND__to__DC_STATE_PEND"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: self_transition_DC_STATE_PEND__to__DC_STATE_PEND ::: cur_state==DC_STATE_PEND && nxt_state==DC_STATE_PEND");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: self_transition_DC_STATE_PEND__to__DC_STATE_PEND ::: testpoint_9_goal_0
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
            if ((cur_state==DC_STATE_PEND && nxt_state==DC_STATE_PEND) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: self_transition_DC_STATE_PEND__to__DC_STATE_PEND ::: testpoint_9_goal_0");
 `endif
            if ((cur_state==DC_STATE_PEND && nxt_state==DC_STATE_PEND) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk)
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
    wire testpoint_9_goal_0_active = ((cur_state==DC_STATE_PEND && nxt_state==DC_STATE_PEND) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_9_goal_0 (.clk (testpoint_9_internal_nvdla_core_clk), .tp(testpoint_9_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_DC_STATE_PEND__to__DC_STATE_PEND_0 (.clk (testpoint_9_internal_nvdla_core_clk), .tp(testpoint_9_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_DC_STATE_PEND__to__DC_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_DC_STATE_BUSY__to__DC_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_DC_STATE_BUSY__to__DC_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_DC_STATE_BUSY__to__DC_STATE_DONE
    `define COVER_OR_TP__transition_DC_STATE_BUSY__to__DC_STATE_DONE_OR_COVER
  `endif // TP__transition_DC_STATE_BUSY__to__DC_STATE_DONE

`ifdef COVER_OR_TP__transition_DC_STATE_BUSY__to__DC_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_DC_STATE_BUSY__to__DC_STATE_DONE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: transition_DC_STATE_BUSY__to__DC_STATE_DONE ::: (cur_state==DC_STATE_BUSY) && (nxt_state == DC_STATE_DONE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: transition_DC_STATE_BUSY__to__DC_STATE_DONE ::: testpoint_10_goal_0
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
            if (((cur_state==DC_STATE_BUSY) && (nxt_state == DC_STATE_DONE)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: transition_DC_STATE_BUSY__to__DC_STATE_DONE ::: testpoint_10_goal_0");
 `endif
            if (((cur_state==DC_STATE_BUSY) && (nxt_state == DC_STATE_DONE)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk)
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
    wire testpoint_10_goal_0_active = (((cur_state==DC_STATE_BUSY) && (nxt_state == DC_STATE_DONE)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_10_goal_0 (.clk (testpoint_10_internal_nvdla_core_clk), .tp(testpoint_10_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_DC_STATE_BUSY__to__DC_STATE_DONE_0 (.clk (testpoint_10_internal_nvdla_core_clk), .tp(testpoint_10_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_DC_STATE_BUSY__to__DC_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_DC_STATE_BUSY__to__DC_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_DC_STATE_BUSY__to__DC_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_DC_STATE_BUSY__to__DC_STATE_BUSY
    `define COVER_OR_TP__self_transition_DC_STATE_BUSY__to__DC_STATE_BUSY_OR_COVER
  `endif // TP__self_transition_DC_STATE_BUSY__to__DC_STATE_BUSY

`ifdef COVER_OR_TP__self_transition_DC_STATE_BUSY__to__DC_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_DC_STATE_BUSY__to__DC_STATE_BUSY"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: self_transition_DC_STATE_BUSY__to__DC_STATE_BUSY ::: cur_state==DC_STATE_BUSY && nxt_state==DC_STATE_BUSY");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: self_transition_DC_STATE_BUSY__to__DC_STATE_BUSY ::: testpoint_11_goal_0
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
            if ((cur_state==DC_STATE_BUSY && nxt_state==DC_STATE_BUSY) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: self_transition_DC_STATE_BUSY__to__DC_STATE_BUSY ::: testpoint_11_goal_0");
 `endif
            if ((cur_state==DC_STATE_BUSY && nxt_state==DC_STATE_BUSY) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk)
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
    wire testpoint_11_goal_0_active = ((cur_state==DC_STATE_BUSY && nxt_state==DC_STATE_BUSY) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_11_goal_0 (.clk (testpoint_11_internal_nvdla_core_clk), .tp(testpoint_11_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_DC_STATE_BUSY__to__DC_STATE_BUSY_0 (.clk (testpoint_11_internal_nvdla_core_clk), .tp(testpoint_11_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_DC_STATE_BUSY__to__DC_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_DC_STATE_DONE__to__DC_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_DC_STATE_DONE__to__DC_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_DC_STATE_DONE__to__DC_STATE_IDLE
    `define COVER_OR_TP__transition_DC_STATE_DONE__to__DC_STATE_IDLE_OR_COVER
  `endif // TP__transition_DC_STATE_DONE__to__DC_STATE_IDLE

`ifdef COVER_OR_TP__transition_DC_STATE_DONE__to__DC_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_DC_STATE_DONE__to__DC_STATE_IDLE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: transition_DC_STATE_DONE__to__DC_STATE_IDLE ::: (cur_state==DC_STATE_DONE) && (nxt_state == DC_STATE_IDLE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: transition_DC_STATE_DONE__to__DC_STATE_IDLE ::: testpoint_12_goal_0
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
            if (((cur_state==DC_STATE_DONE) && (nxt_state == DC_STATE_IDLE)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: transition_DC_STATE_DONE__to__DC_STATE_IDLE ::: testpoint_12_goal_0");
 `endif
            if (((cur_state==DC_STATE_DONE) && (nxt_state == DC_STATE_IDLE)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk)
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
    wire testpoint_12_goal_0_active = (((cur_state==DC_STATE_DONE) && (nxt_state == DC_STATE_IDLE)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_12_goal_0 (.clk (testpoint_12_internal_nvdla_core_clk), .tp(testpoint_12_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_DC_STATE_DONE__to__DC_STATE_IDLE_0 (.clk (testpoint_12_internal_nvdla_core_clk), .tp(testpoint_12_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_DC_STATE_DONE__to__DC_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_DC_STATE_DONE__to__DC_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_DC_STATE_DONE__to__DC_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_DC_STATE_DONE__to__DC_STATE_DONE
    `define COVER_OR_TP__self_transition_DC_STATE_DONE__to__DC_STATE_DONE_OR_COVER
  `endif // TP__self_transition_DC_STATE_DONE__to__DC_STATE_DONE

`ifdef COVER_OR_TP__self_transition_DC_STATE_DONE__to__DC_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_DC_STATE_DONE__to__DC_STATE_DONE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_dc ::: self_transition_DC_STATE_DONE__to__DC_STATE_DONE ::: cur_state==DC_STATE_DONE && nxt_state==DC_STATE_DONE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_dc ::: self_transition_DC_STATE_DONE__to__DC_STATE_DONE ::: testpoint_13_goal_0
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
            if ((cur_state==DC_STATE_DONE && nxt_state==DC_STATE_DONE) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_dc ::: self_transition_DC_STATE_DONE__to__DC_STATE_DONE ::: testpoint_13_goal_0");
 `endif
            if ((cur_state==DC_STATE_DONE && nxt_state==DC_STATE_DONE) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk)
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
    wire testpoint_13_goal_0_active = ((cur_state==DC_STATE_DONE && nxt_state==DC_STATE_DONE) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_13_goal_0 (.clk (testpoint_13_internal_nvdla_core_clk), .tp(testpoint_13_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_DC_STATE_DONE__to__DC_STATE_DONE_0 (.clk (testpoint_13_internal_nvdla_core_clk), .tp(testpoint_13_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_DC_STATE_DONE__to__DC_STATE_DONE_OR_COVER
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
  is_running
  or is_rsp_done
  or delay_cnt
  or delay_cnt_end
  ) begin
    fetch_done = is_running & is_rsp_done & (delay_cnt == delay_cnt_end);
end

assign delay_cnt_end = (3   + 3   + 3 ) ;

always @(
  is_running
  or is_rsp_done
  or delay_cnt
  ) begin
    {mon_delay_cnt_w,
     delay_cnt_w} = ~is_running ? 6'b0 :
                    is_rsp_done ? delay_cnt + 1'b1 :
                    {1'b0, delay_cnt};
end

always @(
  last_data_bank
  or reg2dp_data_bank
  ) begin
    need_pending = (last_data_bank != reg2dp_data_bank);
end

always @(
  dc_en
  or last_dc
  ) begin
    mode_match = dc_en & last_dc;
end

//////// HoG format has dropped! ////////
//&Always;
//    is_hog = (reg2dp_datain_format == NVDLA_CDMA_D_DATAIN_FORMAT_0_DATAIN_FORMAT_HOG);
//&End;
assign is_hog = 1'b0;

always @(
  reg2dp_datain_format
  ) begin
    is_feature = (reg2dp_datain_format == 1'h0 );
end

always @(
  reg2dp_conv_mode
  ) begin
    is_dc = (reg2dp_conv_mode == 1'h0 );
end

always @(
  reg2dp_op_en
  or is_dc
  or is_hog
  or is_feature
  ) begin
    dc_en = reg2dp_op_en & is_dc & (is_hog | is_feature);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    delay_cnt <= {5{1'b0}};
  end else begin
  if ((is_rsp_done | is_done) == 1'b1) begin
    delay_cnt <= delay_cnt_w;
  // VCS coverage off
  end else if ((is_rsp_done | is_done) == 1'b0) begin
  end else begin
    delay_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_rsp_done | is_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

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

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error config! HoG for non-DC")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & ~is_dc & is_hog)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error config! data bank is not big enough!")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (is_running & ((data_bank * 256) < (data_entries * data_height)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! fifo is not empty when done!")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, (is_rsp_done & dma_rsp_fifo_req)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! Channel counter is not empty when done!")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, (is_rsp_done & ((|ch0_cnt) | (|ch1_cnt) | (|ch2_cnt) | (|ch3_cnt)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! Req is not done when rsp is done!")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, (is_rsp_done & (req_height_cnt_d1 != data_height) & ~dbg_is_last_reuse)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! Req is valid when rsp is done!")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, (is_rsp_done & req_pre_valid)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! entry_onfly is non zero when idle")      zzz_assert_never_9x (nvdla_core_clk, `ASSERT_RESET, (fetch_done & |(dc_entry_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  dc_en
  or is_idle
  ) begin
    layer_st = dc_en & is_idle;
end

//&Always;
//    layer_end = status2dma_fsm_switch;
//&End;

always @(
  cur_state
  ) begin
    is_idle = (cur_state == DC_STATE_IDLE);
end

always @(
  cur_state
  ) begin
    is_pending = (cur_state == DC_STATE_PEND);
end

always @(
  cur_state
  ) begin
    is_running = (cur_state == DC_STATE_BUSY);
end

always @(
  cur_state
  ) begin
    is_done = (cur_state == DC_STATE_DONE);
end

always @(
  nxt_state
  ) begin
    is_nxt_running = (nxt_state == DC_STATE_BUSY);
end

always @(
  is_running
  or is_nxt_running
  ) begin
    is_first_running = ~is_running & is_nxt_running;
end

always @(
  nxt_state
  ) begin
    dc2status_state_w = (nxt_state == DC_STATE_PEND) ? 1  : 
                        (nxt_state == DC_STATE_BUSY) ? 2  : 
                        (nxt_state == DC_STATE_DONE) ? 3  :
                        0 ;
end

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
  // VCS coverage off
  end else if ((reg2dp_op_en & is_idle) == 1'b0) begin
  end else begin
    last_dc <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(reg2dp_op_en & is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    last_data_bank <= {4{1'b1}};
  end else begin
  if ((reg2dp_op_en & is_idle) == 1'b1) begin
    last_data_bank <= reg2dp_data_bank;
  // VCS coverage off
  end else if ((reg2dp_op_en & is_idle) == 1'b0) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(reg2dp_op_en & is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    last_skip_data_rls <= 1'b0;
  end else begin
  if ((reg2dp_op_en & is_idle) == 1'b1) begin
    last_skip_data_rls <= dc_en & reg2dp_skip_data_rls;
  // VCS coverage off
  end else if ((reg2dp_op_en & is_idle) == 1'b0) begin
  end else begin
    last_skip_data_rls <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(reg2dp_op_en & is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//&Vector DAT_ADDR_BITS grain_addr_w;
//&Vector GRAIN_BITS+STRIDE_BITS-DAT_ADDR_BITS mon_grain_addr_w;

always @(
  reg2dp_proc_precision
  ) begin
    is_int8 = (reg2dp_proc_precision == 2'h0 );
end

always @(
  reg2dp_in_precision
  ) begin
    is_input_int8 = (reg2dp_in_precision == 2'h0 );
end

always @(
  is_int8
  or is_input_int8
  ) begin
    is_data_expand = ~is_int8 & is_input_int8;
end

always @(
  is_int8
  or is_input_int8
  ) begin
    is_data_shrink = is_int8 & ~is_input_int8;
end

always @(
  is_int8
  or is_input_int8
  ) begin
    is_data_normal = ~(is_int8 ^ is_input_int8);
end

always @(
  reg2dp_datain_width
  or reg2dp_datain_height
  or reg2dp_surf_packed
  ) begin
    is_packed_1x1 = (reg2dp_datain_width == 13'b0) & (reg2dp_datain_height == 13'b0) & reg2dp_surf_packed;
end

always @(
  reg2dp_datain_width
  ) begin
    data_width_inc = reg2dp_datain_width + 1'b1;
end

always @(
  is_hog
  or data_width_inc
  or is_packed_1x1
  or data_surface_inc
  ) begin
    data_width_w = is_hog ? {data_width_inc, 2'b0} :
                   is_packed_1x1 ? {6'b0, data_surface_inc} :
                   {2'b0, data_width_inc};
end

always @(
  is_hog
  or reg2dp_datain_width
  or is_packed_1x1
  or is_int8
  or reg2dp_datain_channel
  ) begin
    data_width_sub_one_w = is_hog ? {reg2dp_datain_width, 2'h1} :
                           (is_packed_1x1 & is_int8) ?  {7'b0, reg2dp_datain_channel[12:5]} :
                           (is_packed_1x1 & ~is_int8) ? {6'b0, reg2dp_datain_channel[12:4]} :
                           {2'b0, reg2dp_datain_width};
end

always @(
  reg2dp_datain_height
  ) begin
    data_height_w = reg2dp_datain_height + 1'b1;
end

always @(
  is_int8
  or reg2dp_datain_channel
  ) begin
    data_surface_inc = is_int8 ? {2'b0, reg2dp_datain_channel[12:5]} + 1'b1 :
                       {1'b0, reg2dp_datain_channel[12:4]} + 1'b1;
end

always @(
  reg2dp_entries
  ) begin
    {mon_data_entries_w,
     data_entries_w} = reg2dp_entries + 1'b1;
end

always @(
  is_hog
  or is_packed_1x1
  or data_surface_inc
  ) begin
    data_surface_w = (is_hog | is_packed_1x1) ? 10'b1 :
                     data_surface_inc;
end

always @(
  reg2dp_line_packed
  or reg2dp_grains
  ) begin
    {mon_fetch_grain_w,
     fetch_grain_w} = (~reg2dp_line_packed) ? 13'b1 : reg2dp_grains + 1'b1;
end

//&Always;
//    {mon_grain_addr_w,
//     grain_addr_w} = fetch_grain_w * reg2dp_line_stride;
//&End;
always @(
  fetch_grain_w
  or reg2dp_line_stride
  ) begin
     grain_addr_w = fetch_grain_w * reg2dp_line_stride;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    data_width <= {16{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_width <= data_width_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_width <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    data_width_sub_one <= {15{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_width_sub_one <= data_width_sub_one_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_width_sub_one <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    data_height <= {14{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_height <= data_height_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_height <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    data_batch <= {6{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_batch <= reg2dp_batches + 1'b1;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_batch <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    data_entries <= {12{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_entries <= data_entries_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    fetch_grain <= {12{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    fetch_grain <= fetch_grain_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    fetch_grain <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    data_surface <= {10{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_surface <= data_surface_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_surface <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    grain_addr <= {39{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    grain_addr <= grain_addr_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    grain_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    data_bank <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_bank <= reg2dp_data_bank + 1'b1;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_bank <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error Config! HoG is not line packed!")      zzz_assert_never_22x (nvdla_core_clk, `ASSERT_RESET, (is_hog & ~reg2dp_line_packed & reg2dp_op_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error Config! HoG should not use int8 input!")      zzz_assert_never_23x (nvdla_core_clk, `ASSERT_RESET, (is_hog & is_input_int8 & reg2dp_op_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error config! reg2dp_grains is overflow!")      zzz_assert_never_24x (nvdla_core_clk, `ASSERT_RESET, (layer_st & mon_fetch_grain_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error config! data_entries_w is overflow!")      zzz_assert_never_25x (nvdla_core_clk, `ASSERT_RESET, (layer_st & mon_data_entries_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_one_hot #(0,3,0,"Error! conflict data type mode")      zzz_assert_one_hot_26x (nvdla_core_clk, `ASSERT_RESET, ({is_data_normal, is_data_expand, is_data_shrink})); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  prepare for address generation                                    //
////////////////////////////////////////////////////////////////////////
///////////// stage 1 /////////////

always @(
  layer_st
  or req_height_cnt_d1
  or req_cur_grain_w
  ) begin
    {mon_req_height_cnt_inc,
     req_height_cnt_inc} = layer_st ? 15'b0 :
                           req_height_cnt_d1 + req_cur_grain_w;
end

always @(
  data_height
  or req_height_cnt_d1
  ) begin
    {mon_req_slice_left,
     req_slice_left} = data_height - req_height_cnt_d1;
end

always @(
  req_slice_left
  or fetch_grain
  ) begin
    is_req_grain_last = (req_slice_left <= fetch_grain);
end

always @(
  is_req_grain_last
  or req_slice_left
  or fetch_grain
  ) begin
    req_cur_grain_w = is_req_grain_last ? req_slice_left : fetch_grain;
end

always @(
  is_running
  or req_height_cnt_d1
  or data_height
  or pre_ready_d1
  or pre_valid_d1
  ) begin
    pre_valid_d1_w = ~is_running ? 1'b0 :
                     (req_height_cnt_d1 != data_height) ? 1'b1 :
                     pre_ready_d1 ? 1'b0 :
                     pre_valid_d1;
end

always @(
  pre_valid_d1
  or pre_ready_d1
  ) begin
    pre_ready = ~pre_valid_d1 | pre_ready_d1;
end

always @(
  is_running
  or req_height_cnt_d1
  or data_height
  or pre_ready
  ) begin
    pre_reg_en = is_running & (req_height_cnt_d1 != data_height) & pre_ready;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_height_cnt_d1 <= {14{1'b0}};
  end else begin
  if ((layer_st | pre_reg_en) == 1'b1) begin
    req_height_cnt_d1 <= req_height_cnt_inc;
  // VCS coverage off
  end else if ((layer_st | pre_reg_en) == 1'b0) begin
  end else begin
    req_height_cnt_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | pre_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_cur_grain_d1 <= {12{1'b0}};
  end else begin
  if ((pre_reg_en) == 1'b1) begin
    req_cur_grain_d1 <= req_cur_grain_w;
  // VCS coverage off
  end else if ((pre_reg_en) == 1'b0) begin
  end else begin
    req_cur_grain_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    is_req_grain_last_d1 <= 1'b0;
  end else begin
  if ((pre_reg_en) == 1'b1) begin
    is_req_grain_last_d1 <= is_req_grain_last;
  // VCS coverage off
  end else if ((pre_reg_en) == 1'b0) begin
  end else begin
    is_req_grain_last_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    pre_valid_d1 <= 1'b0;
  end else begin
  pre_valid_d1 <= pre_valid_d1_w;
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
  nv_assert_never #(0,0,"Error! req_height_cnt_inc is overflow!")      zzz_assert_never_30x (nvdla_core_clk, `ASSERT_RESET, (mon_req_height_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_slice_left is overflow!")      zzz_assert_never_31x (nvdla_core_clk, `ASSERT_RESET, ((|mon_req_slice_left))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// stage 2 /////////////

always @(
  req_cur_grain_d1
  or data_width
  ) begin
    {mon_req_cur_atomic,
     req_cur_atomic} = req_cur_grain_d1 * data_width;
end

always @(
  data_entries
  or data_batch
  ) begin
    {mon_entry_per_batch,
     entry_per_batch} = data_entries * data_batch;
end

always @(
  is_running
  or pre_valid_d1
  or pre_ready_d2
  or pre_valid_d2
  ) begin
    pre_valid_d2_w = ~is_running ? 1'b0 :
                     pre_valid_d1 ? 1'b1 :
                     pre_ready_d2 ? 1'b0 :
                     pre_valid_d2;
end

always @(
  pre_valid_d2
  or pre_ready_d2
  ) begin
    pre_ready_d1 = ~pre_valid_d2 | pre_ready_d2;
end

always @(
  pre_valid_d1
  or pre_ready_d1
  ) begin
    pre_reg_en_d1 = pre_valid_d1 & pre_ready_d1;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_atomic_d2 <= {14{1'b0}};
  end else begin
  if ((pre_reg_en_d1) == 1'b1) begin
    req_atomic_d2 <= req_cur_atomic;
  // VCS coverage off
  end else if ((pre_reg_en_d1) == 1'b0) begin
  end else begin
    req_atomic_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    entry_per_batch_d2 <= {12{1'b0}};
  end else begin
  if ((pre_reg_en_d1) == 1'b1) begin
    entry_per_batch_d2 <= entry_per_batch;
  // VCS coverage off
  end else if ((pre_reg_en_d1) == 1'b0) begin
  end else begin
    entry_per_batch_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_33x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_cur_grain_d2 <= {12{1'b0}};
  end else begin
  if ((pre_reg_en_d1) == 1'b1) begin
    req_cur_grain_d2 <= req_cur_grain_d1;
  // VCS coverage off
  end else if ((pre_reg_en_d1) == 1'b0) begin
  end else begin
    req_cur_grain_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_34x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    is_req_grain_last_d2 <= 1'b0;
  end else begin
  if ((pre_reg_en_d1) == 1'b1) begin
    is_req_grain_last_d2 <= is_req_grain_last_d1;
  // VCS coverage off
  end else if ((pre_reg_en_d1) == 1'b0) begin
  end else begin
    is_req_grain_last_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_35x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    pre_valid_d2 <= 1'b0;
  end else begin
  pre_valid_d2 <= pre_valid_d2_w;
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
  nv_assert_never #(0,0,"Error! req_cur_atomic is overflow!")      zzz_assert_never_36x (nvdla_core_clk, `ASSERT_RESET, (pre_reg_en_d1 & (|mon_req_cur_atomic))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! entry_per_batch is overflow!")      zzz_assert_never_37x (nvdla_core_clk, `ASSERT_RESET, (pre_reg_en_d1 & (|mon_entry_per_batch))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_cur_atomic is out of range when HoG!")      zzz_assert_never_38x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~is_feature & (|req_cur_atomic[12 -1: 12 -2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// stage 3 /////////////

always @(
  req_cur_grain_d2
  or entry_per_batch_d2
  ) begin
    {mon_entry_required,
     entry_required} = req_cur_grain_d2 * entry_per_batch_d2;
end

always @(
  pre_valid_d2
  or pre_gen_sel
  or req_pre_valid_0_d3
  ) begin
    pre_reg_en_d2_g0 = pre_valid_d2 & ~pre_gen_sel & ~req_pre_valid_0_d3;
end

always @(
  pre_valid_d2
  or pre_gen_sel
  or req_pre_valid_1_d3
  ) begin
    pre_reg_en_d2_g1 = pre_valid_d2 & pre_gen_sel & ~req_pre_valid_1_d3;
end

always @(
  pre_gen_sel
  or req_pre_valid_0_d3
  or req_pre_valid_1_d3
  ) begin
    pre_ready_d2 = ((~pre_gen_sel & ~req_pre_valid_0_d3) | (pre_gen_sel & ~req_pre_valid_1_d3));
end

always @(
  pre_valid_d2
  or pre_ready_d2
  ) begin
    pre_reg_en_d2 = pre_valid_d2 & pre_ready_d2;
end

always @(
  pre_valid_d2
  or pre_ready_d2
  or is_req_grain_last_d2
  ) begin
    pre_reg_en_d2_init = pre_valid_d2 & pre_ready_d2 & ~is_req_grain_last_d2;
end

always @(
  pre_valid_d2
  or pre_ready_d2
  or is_req_grain_last_d2
  ) begin
    pre_reg_en_d2_last = pre_valid_d2 & pre_ready_d2 & is_req_grain_last_d2;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_atomic_0_d3 <= {14{1'b0}};
  end else begin
  if ((pre_reg_en_d2_g0) == 1'b1) begin
    req_atomic_0_d3 <= req_atomic_d2;
  // VCS coverage off
  end else if ((pre_reg_en_d2_g0) == 1'b0) begin
  end else begin
    req_atomic_0_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_39x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_g0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_atomic_1_d3 <= {14{1'b0}};
  end else begin
  if ((pre_reg_en_d2_g1) == 1'b1) begin
    req_atomic_1_d3 <= req_atomic_d2;
  // VCS coverage off
  end else if ((pre_reg_en_d2_g1) == 1'b0) begin
  end else begin
    req_atomic_1_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_40x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_g1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_entry_0_d3 <= {12{1'b0}};
  end else begin
  if ((pre_reg_en_d2_g0) == 1'b1) begin
    req_entry_0_d3 <= entry_required;
  // VCS coverage off
  end else if ((pre_reg_en_d2_g0) == 1'b0) begin
  end else begin
    req_entry_0_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_41x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_g0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_entry_1_d3 <= {12{1'b0}};
  end else begin
  if ((pre_reg_en_d2_g1) == 1'b1) begin
    req_entry_1_d3 <= entry_required;
  // VCS coverage off
  end else if ((pre_reg_en_d2_g1) == 1'b0) begin
  end else begin
    req_entry_1_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_g1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_entry_init <= {12{1'b0}};
  end else begin
  if ((pre_reg_en_d2_init) == 1'b1) begin
    rsp_entry_init <= entry_required;
  // VCS coverage off
  end else if ((pre_reg_en_d2_init) == 1'b0) begin
  end else begin
    rsp_entry_init <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_43x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_init))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_entry_last <= {12{1'b0}};
  end else begin
  if ((pre_reg_en_d2_last) == 1'b1) begin
    rsp_entry_last <= entry_required;
  // VCS coverage off
  end else if ((pre_reg_en_d2_last) == 1'b0) begin
  end else begin
    rsp_entry_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_44x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_last))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_batch_entry_init <= {12{1'b0}};
  end else begin
  if ((pre_reg_en_d2_init) == 1'b1) begin
    rsp_batch_entry_init <= entry_per_batch_d2;
  // VCS coverage off
  end else if ((pre_reg_en_d2_init) == 1'b0) begin
  end else begin
    rsp_batch_entry_init <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_45x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_init))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_batch_entry_last <= {12{1'b0}};
  end else begin
  if ((pre_reg_en_d2_last) == 1'b1) begin
    rsp_batch_entry_last <= entry_per_batch_d2;
  // VCS coverage off
  end else if ((pre_reg_en_d2_last) == 1'b0) begin
  end else begin
    rsp_batch_entry_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_46x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_last))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_slice_init <= {12{1'b0}};
  end else begin
  if ((pre_reg_en_d2_init) == 1'b1) begin
    rsp_slice_init <= req_cur_grain_d2;
  // VCS coverage off
  end else if ((pre_reg_en_d2_init) == 1'b0) begin
  end else begin
    rsp_slice_init <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_47x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_init))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_slice_last <= {12{1'b0}};
  end else begin
  if ((pre_reg_en_d2_last) == 1'b1) begin
    rsp_slice_last <= req_cur_grain_d2;
  // VCS coverage off
  end else if ((pre_reg_en_d2_last) == 1'b0) begin
  end else begin
    rsp_slice_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_48x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pre_reg_en_d2_last))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! entry_required is overflow!")      zzz_assert_never_49x (nvdla_core_clk, `ASSERT_RESET, ((|mon_entry_required))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// prepare control logic /////////////
always @(
  is_running
  or pre_valid_d2
  or pre_gen_sel
  ) begin
    pre_gen_sel_w = is_running & (pre_valid_d2 ^ pre_gen_sel);
end

always @(
  is_running
  or req_csm_sel
  ) begin
    req_csm_sel_w = is_running & ~req_csm_sel;
end

always @(
  is_running
  or pre_reg_en_d2_g0
  or req_csm_sel
  or csm_reg_en
  or req_pre_valid_0_d3
  ) begin
    req_pre_valid_0_w = ~is_running ? 1'b0 :
                        (pre_reg_en_d2_g0) ? 1'b1 :
                        (~req_csm_sel & csm_reg_en) ? 1'b0 :
                        req_pre_valid_0_d3;
end

always @(
  is_running
  or pre_reg_en_d2_g1
  or req_csm_sel
  or csm_reg_en
  or req_pre_valid_1_d3
  ) begin
    req_pre_valid_1_w = ~is_running ? 1'b0 :
                        (pre_reg_en_d2_g1) ? 1'b1 :
                        (req_csm_sel & csm_reg_en) ? 1'b0 :
                        req_pre_valid_1_d3;
end

assign csm_reg_en = req_grain_reg_en;

always @(
  req_csm_sel
  or req_pre_valid_0_d3
  or req_pre_valid_1_d3
  ) begin
    req_pre_valid = ~req_csm_sel ? req_pre_valid_0_d3 : req_pre_valid_1_d3;
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pre_gen_sel <= 1'b0;
  end else begin
  if ((layer_st | pre_reg_en_d2) == 1'b1) begin
    pre_gen_sel <= pre_gen_sel_w;
  // VCS coverage off
  end else if ((layer_st | pre_reg_en_d2) == 1'b0) begin
  end else begin
    pre_gen_sel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_50x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | pre_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_csm_sel <= 1'b0;
  end else begin
  if ((layer_st | csm_reg_en) == 1'b1) begin
    req_csm_sel <= req_csm_sel_w;
  // VCS coverage off
  end else if ((layer_st | csm_reg_en) == 1'b0) begin
  end else begin
    req_csm_sel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_51x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | csm_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  generate address for input feature data                           //
////////////////////////////////////////////////////////////////////////
///////////// batch counter /////////////

always @(
  req_batch_cnt
  ) begin
    {mon_req_batch_cnt_inc,
     req_batch_cnt_inc} = req_batch_cnt + 1'b1;
end

always @(
  req_batch_cnt
  or reg2dp_batches
  ) begin
    is_req_batch_end = (req_batch_cnt == reg2dp_batches);
end

always @(
  layer_st
  or is_req_batch_end
  or req_batch_cnt_inc
  ) begin
    req_batch_cnt_w = (layer_st | is_req_batch_end) ? 5'b0 :
                      req_batch_cnt_inc;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_batch_cnt <= {5{1'b0}};
  end else begin
  if ((layer_st | req_batch_reg_en) == 1'b1) begin
    req_batch_cnt <= req_batch_cnt_w;
  // VCS coverage off
  end else if ((layer_st | req_batch_reg_en) == 1'b0) begin
  end else begin
    req_batch_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_52x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_batch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// channel counter /////////////

always @(
  is_hog
  or is_packed_1x1
  or is_data_shrink
  ) begin
    req_ch_mode = (is_hog | is_packed_1x1) ? 3'h1 :
                  is_data_shrink ? 3'h4 :
                  3'h2;
end

always @(
  layer_st
  or is_req_ch_end
  or data_surface_w
  or data_surface
  or req_ch_cnt
  or req_cur_ch
  ) begin
    {mon_req_ch_left_w,
     req_ch_left_w} = (layer_st | is_req_ch_end) ? {1'b0, data_surface_w} :
                      data_surface - req_ch_cnt - req_cur_ch;
end

always @(
  req_ch_left_w
  or req_ch_mode
  ) begin
    req_cur_ch_w = (req_ch_left_w > {{7{1'b0}}, req_ch_mode}) ? req_ch_mode :
                   req_ch_left_w[2:0];
end

always @(
  req_ch_cnt
  or req_cur_ch
  ) begin
    {mon_req_ch_cnt_inc,
     req_ch_cnt_inc} = req_ch_cnt + req_cur_ch;
end

always @(
  req_ch_cnt_inc
  or data_surface
  ) begin
    is_req_ch_end = (req_ch_cnt_inc == data_surface); 
end

always @(
  layer_st
  or is_req_ch_end
  or req_ch_cnt_inc
  ) begin
    req_ch_cnt_w = (layer_st | is_req_ch_end) ? 10'b0 :
                   req_ch_cnt_inc;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_ch_cnt <= {10{1'b0}};
  end else begin
  if ((layer_st | req_ch_reg_en) == 1'b1) begin
    req_ch_cnt <= req_ch_cnt_w;
  // VCS coverage off
  end else if ((layer_st | req_ch_reg_en) == 1'b0) begin
  end else begin
    req_ch_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_ch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_cur_ch <= {3{1'b0}};
  end else begin
  if ((layer_st | req_ch_reg_en) == 1'b1) begin
    req_cur_ch <= req_cur_ch_w;
  // VCS coverage off
  end else if ((layer_st | req_ch_reg_en) == 1'b0) begin
  end else begin
    req_cur_ch <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_54x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_ch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_ch_left_w is overflow")      zzz_assert_never_55x (nvdla_core_clk, `ASSERT_RESET, (mon_req_ch_left_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_cur_ch is out of range")      zzz_assert_never_56x (nvdla_core_clk, `ASSERT_RESET, (req_cur_ch > 3'h4)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_ch_cnt_inc is large than data_surface")      zzz_assert_never_57x (nvdla_core_clk, `ASSERT_RESET, (is_running & (req_ch_cnt_inc > data_surface))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// atomic counter /////////////

always @(
  req_atm_sel
  ) begin
    req_atm_sel_inc = req_atm_sel + 1'b1;
end

always @(
  req_atm_sel_inc
  or req_cur_ch
  ) begin
    is_req_atm_sel_end = (req_atm_sel_inc == req_cur_ch);
end

always @(
  is_running
  or is_req_atm_sel_end
  or is_req_atm_end
  or req_atm_sel_inc
  ) begin
    req_atm_sel_w = ~is_running ? 1'b0 :
                    (is_req_atm_sel_end | is_req_atm_end) ? 2'b0:
                    req_atm_sel_inc[1:0];
end

always @(
  req_cur_ch
  or is_atm_done
  ) begin
    is_req_atm_end = ((req_cur_ch == 3'h1) & (is_atm_done[0] == 1'h1))
                   | ((req_cur_ch == 3'h2) & (is_atm_done[1:0] == 2'h3))
                   | ((req_cur_ch == 3'h3) & (is_atm_done[2:0] == 3'h7))
                   | ((req_cur_ch == 3'h4) & (is_atm_done[3:0] == 4'hf));
end

always @(
  req_csm_sel
  or req_atomic_1_d3
  or req_atomic_0_d3
  ) begin
    req_atm = req_csm_sel ? req_atomic_1_d3 : req_atomic_0_d3;
end

always @(
  req_atm_cnt_0
  or req_atm
  or req_atm_cnt_1
  or req_atm_cnt_2
  or req_atm_cnt_3
  ) begin
    is_atm_done[0] = (req_atm_cnt_0 == req_atm);
    is_atm_done[1] = (req_atm_cnt_1 == req_atm);
    is_atm_done[2] = (req_atm_cnt_2 == req_atm);
    is_atm_done[3] = (req_atm_cnt_3 == req_atm);
end

always @(
  req_atm_sel
  or req_atm_cnt_0
  or req_atm_cnt_1
  or req_atm_cnt_2
  or req_atm_cnt_3
  ) begin
    req_atm_cnt = (req_atm_sel == 2'h0) ? req_atm_cnt_0 :
                  (req_atm_sel == 2'h1) ? req_atm_cnt_1 :
                  (req_atm_sel == 2'h2) ? req_atm_cnt_2 :
                  req_atm_cnt_3;
end

always @(
  req_atm_cnt
  or req_atm_size
  ) begin
    {mon_req_atm_cnt_inc,
     req_atm_cnt_inc} = req_atm_cnt + req_atm_size;
end

always @(
  req_atm_sel
  or is_atm_done
  ) begin
    cur_atm_done = (req_atm_sel == 2'h0) ? is_atm_done[0] :
                   (req_atm_sel == 2'h1) ? is_atm_done[1] :
                   (req_atm_sel == 2'h2) ? is_atm_done[2] :
                   is_atm_done[3];
end

always @(
  req_atm
  or req_atm_cnt
  ) begin
    {mon_req_atm_left,
     req_atm_left} = req_atm - req_atm_cnt;
end

always @(
  req_atm_cnt
  or req_addr
  ) begin
    {mon_req_atm_size_addr_limit,
     req_atm_size_addr_limit} = (req_atm_cnt == 14'b0) ? (4'h8 - req_addr[2:0]) : 4'h8;
end

always @(
  req_atm_left
  or req_atm_size_addr_limit
  ) begin
    req_atm_size = (req_atm_left < {{10{1'b0}}, req_atm_size_addr_limit}) ? req_atm_left[3:0] :
                   req_atm_size_addr_limit;
end

always @(
  req_atm_size
  ) begin
    {mon_req_atm_size_out,
     req_atm_size_out} = req_atm_size - 1'b1;
end

always @(
  is_running
  or is_req_atm_end
  or req_atm_cnt_inc
  ) begin
    req_atm_cnt_0_w = (~is_running | is_req_atm_end) ? 14'b0 :
                      req_atm_cnt_inc;
end

always @(
  is_running
  or is_req_atm_end
  or req_atm_cnt_inc
  ) begin
    req_atm_cnt_1_w = (~is_running | is_req_atm_end) ? 14'b0 :
                      req_atm_cnt_inc;
end

always @(
  is_running
  or is_req_atm_end
  or req_atm_cnt_inc
  ) begin
    req_atm_cnt_2_w = (~is_running | is_req_atm_end) ? 14'b0 :
                      req_atm_cnt_inc;
end

always @(
  is_running
  or is_req_atm_end
  or req_atm_cnt_inc
  ) begin
    req_atm_cnt_3_w = (~is_running | is_req_atm_end) ? 14'b0 :
                      req_atm_cnt_inc;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_atm_sel <= {2{1'b0}};
  end else begin
  if ((layer_st | req_atm_reg_en) == 1'b1) begin
    req_atm_sel <= req_atm_sel_w;
  // VCS coverage off
  end else if ((layer_st | req_atm_reg_en) == 1'b0) begin
  end else begin
    req_atm_sel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_58x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_atm_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_atm_cnt_0 <= {14{1'b0}};
  end else begin
  if ((layer_st | req_atm_reg_en_0) == 1'b1) begin
    req_atm_cnt_0 <= req_atm_cnt_0_w;
  // VCS coverage off
  end else if ((layer_st | req_atm_reg_en_0) == 1'b0) begin
  end else begin
    req_atm_cnt_0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_59x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_atm_reg_en_0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_atm_cnt_1 <= {14{1'b0}};
  end else begin
  if ((layer_st | req_atm_reg_en_1) == 1'b1) begin
    req_atm_cnt_1 <= req_atm_cnt_1_w;
  // VCS coverage off
  end else if ((layer_st | req_atm_reg_en_1) == 1'b0) begin
  end else begin
    req_atm_cnt_1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_60x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_atm_reg_en_1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_atm_cnt_2 <= {14{1'b0}};
  end else begin
  if ((layer_st | req_atm_reg_en_2) == 1'b1) begin
    req_atm_cnt_2 <= req_atm_cnt_2_w;
  // VCS coverage off
  end else if ((layer_st | req_atm_reg_en_2) == 1'b0) begin
  end else begin
    req_atm_cnt_2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_61x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_atm_reg_en_2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_atm_cnt_3 <= {14{1'b0}};
  end else begin
  if ((layer_st | req_atm_reg_en_3) == 1'b1) begin
    req_atm_cnt_3 <= req_atm_cnt_3_w;
  // VCS coverage off
  end else if ((layer_st | req_atm_reg_en_3) == 1'b0) begin
  end else begin
    req_atm_cnt_3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_62x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | req_atm_reg_en_3))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_atm_left is overflow!")      zzz_assert_never_63x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (|mon_req_atm_left))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_atm_size_addr_limit is overflow!")      zzz_assert_never_64x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (|mon_req_atm_size_addr_limit))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_atm_size_out is overflow!")      zzz_assert_never_65x (nvdla_core_clk, `ASSERT_RESET, (req_reg_en & (|mon_req_atm_size_out))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// address counter /////////////

assign req_addr_ori = {reg2dp_datain_addr_high_0, reg2dp_datain_addr_low_0};

always @(
  req_addr_grain_base
  or grain_addr
  ) begin
    {mon_req_addr_grain_base_inc,
     req_addr_grain_base_inc} = req_addr_grain_base + grain_addr;
end

always @(
  req_addr_batch_base
  or reg2dp_batch_stride
  ) begin
    {mon_req_addr_batch_base_inc,
     req_addr_batch_base_inc} = req_addr_batch_base + reg2dp_batch_stride;
end

always @(
  is_data_shrink
  or reg2dp_surf_stride
  or is_hog
  ) begin
    req_addr_ch_base_add = (is_data_shrink) ? {reg2dp_surf_stride, 2'b0} :
                           (is_hog) ? {2'b0, reg2dp_surf_stride} :
                           {1'b0, reg2dp_surf_stride, 1'b0};
end

always @(
  req_addr_ch_base
  or req_addr_ch_base_add
  ) begin
    {mon_req_addr_ch_base_inc,
     req_addr_ch_base_inc} = req_addr_ch_base + req_addr_ch_base_add;
end

always @(
  req_addr_base
  or reg2dp_surf_stride
  ) begin
    {mon_req_addr_base_inc,
     req_addr_base_inc} = req_addr_base + reg2dp_surf_stride;
end

always @(
  is_first_running
  or req_addr_ori
  or req_addr_grain_base_inc
  ) begin
    req_addr_grain_base_w = is_first_running ? req_addr_ori :
                            req_addr_grain_base_inc;
end

always @(
  is_first_running
  or req_addr_ori
  or is_req_batch_end
  or req_addr_grain_base_inc
  or req_addr_batch_base_inc
  ) begin
    req_addr_batch_base_w = is_first_running ? req_addr_ori :
                            is_req_batch_end ? req_addr_grain_base_inc :
                            req_addr_batch_base_inc;
end

always @(
  is_first_running
  or req_addr_ori
  or is_req_ch_end
  or is_req_batch_end
  or req_addr_grain_base_inc
  or req_addr_batch_base_inc
  or req_addr_ch_base_inc
  ) begin
    req_addr_ch_base_w = is_first_running ? req_addr_ori :
                         (is_req_ch_end & is_req_batch_end) ? req_addr_grain_base_inc :
                         is_req_ch_end ? req_addr_batch_base_inc :
                         req_addr_ch_base_inc;
end

always @(
  is_first_running
  or req_addr_ori
  or is_req_atm_end
  or is_req_ch_end
  or is_req_batch_end
  or req_addr_grain_base_inc
  or req_addr_batch_base_inc
  or req_addr_ch_base_inc
  or is_req_atm_sel_end
  or req_addr_ch_base
  or req_addr_base_inc
  ) begin
    req_addr_base_w = is_first_running ? req_addr_ori :
                      (is_req_atm_end & is_req_ch_end & is_req_batch_end) ? req_addr_grain_base_inc :
                      (is_req_atm_end & is_req_ch_end) ? req_addr_batch_base_inc :
                      is_req_atm_end ? req_addr_ch_base_inc :
                      is_req_atm_sel_end ? req_addr_ch_base :
                      req_addr_base_inc;
end

always @(
  req_addr_base
  or req_atm_cnt
  ) begin
    {mon_req_addr,
     req_addr} = req_addr_base + req_atm_cnt;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_addr_grain_base <= {59{1'b0}};
  end else begin
  if ((is_first_running | req_grain_reg_en) == 1'b1) begin
    req_addr_grain_base <= req_addr_grain_base_w;
  // VCS coverage off
  end else if ((is_first_running | req_grain_reg_en) == 1'b0) begin
  end else begin
    req_addr_grain_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_66x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running | req_grain_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_addr_batch_base <= {59{1'b0}};
  end else begin
  if ((is_first_running | req_batch_reg_en) == 1'b1) begin
    req_addr_batch_base <= req_addr_batch_base_w;
  // VCS coverage off
  end else if ((is_first_running | req_batch_reg_en) == 1'b0) begin
  end else begin
    req_addr_batch_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_67x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running | req_batch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_addr_ch_base <= {59{1'b0}};
  end else begin
  if ((is_first_running | req_ch_reg_en) == 1'b1) begin
    req_addr_ch_base <= req_addr_ch_base_w;
  // VCS coverage off
  end else if ((is_first_running | req_ch_reg_en) == 1'b0) begin
  end else begin
    req_addr_ch_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_68x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running | req_ch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_addr_base <= {59{1'b0}};
  end else begin
  if ((is_first_running | req_atm_reg_en) == 1'b1) begin
    req_addr_base <= req_addr_base_w;
  // VCS coverage off
  end else if ((is_first_running | req_atm_reg_en) == 1'b0) begin
  end else begin
    req_addr_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_69x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running | req_atm_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_addr_grain_base_inc is overflow!")      zzz_assert_never_70x (nvdla_core_clk, `ASSERT_RESET, (req_grain_reg_en & mon_req_addr_grain_base_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_addr_batch_base_inc is overflow!")      zzz_assert_never_71x (nvdla_core_clk, `ASSERT_RESET, (req_batch_reg_en & mon_req_addr_batch_base_inc & (|reg2dp_batches))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_addr_ch_base_inc is overflow!")      zzz_assert_never_72x (nvdla_core_clk, `ASSERT_RESET, (req_ch_reg_en & mon_req_addr_ch_base_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_addr_base_inc is overflow!")      zzz_assert_never_73x (nvdla_core_clk, `ASSERT_RESET, (req_atm_reg_en & mon_req_addr_base_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_addr is overflow!")      zzz_assert_never_74x (nvdla_core_clk, `ASSERT_RESET, (req_reg_en & mon_req_addr)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// request package /////////////
assign req_valid_d0 = is_running & req_pre_valid & cbuf_is_ready & ~cur_atm_done;

assign req_valid_d1_w = ~is_running ? 1'b0 :
                        req_valid_d0 ? 1'b1 :
                        req_ready_d1 ? 1'b0 :
                        req_valid_d1;   

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_valid_d1 <= 1'b0;
  end else begin
  req_valid_d1 <= req_valid_d1_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_addr_d1 <= {59{1'b0}};
  end else begin
  if ((req_reg_en) == 1'b1) begin
    req_addr_d1 <= req_addr;
  // VCS coverage off
  end else if ((req_reg_en) == 1'b0) begin
  end else begin
    req_addr_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_75x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_size_d1 <= {4{1'b0}};
  end else begin
  if ((req_reg_en) == 1'b1) begin
    req_size_d1 <= req_atm_size;
  // VCS coverage off
  end else if ((req_reg_en) == 1'b0) begin
  end else begin
    req_size_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_76x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_size_out_d1 <= {3{1'b0}};
  end else begin
  if ((req_reg_en) == 1'b1) begin
    req_size_out_d1 <= req_atm_size_out;
  // VCS coverage off
  end else if ((req_reg_en) == 1'b0) begin
  end else begin
    req_size_out_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_77x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_ch_idx_d1 <= {2{1'b0}};
  end else begin
  if ((req_reg_en) == 1'b1) begin
    req_ch_idx_d1 <= req_atm_sel;
  // VCS coverage off
  end else if ((req_reg_en) == 1'b0) begin
  end else begin
    req_ch_idx_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_78x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// control logic /////////////

assign req_ready_d1 = dma_req_fifo_ready & dma_rd_req_rdy;
assign req_ready_d0 = req_ready_d1 | ~req_valid_d1;

always @(
  req_pre_valid
  or cbuf_is_ready
  or cur_atm_done
  or req_ready_d0
  ) begin
    req_reg_en = req_pre_valid & cbuf_is_ready & ~cur_atm_done & req_ready_d0;
end

always @(
  req_pre_valid
  or cbuf_is_ready
  or cur_atm_done
  or req_ready_d0
  ) begin
    req_atm_reg_en = req_pre_valid & cbuf_is_ready & (cur_atm_done | req_ready_d0);
end

always @(
  req_pre_valid
  or cbuf_is_ready
  or is_req_atm_end
  or req_atm_sel
  or is_atm_done
  or req_ready_d0
  ) begin
    req_atm_reg_en_0 = req_pre_valid & cbuf_is_ready & (is_req_atm_end | ((req_atm_sel == 2'h0) & ~is_atm_done[0] & req_ready_d0));
end

always @(
  req_pre_valid
  or cbuf_is_ready
  or is_req_atm_end
  or req_atm_sel
  or is_atm_done
  or req_ready_d0
  ) begin
    req_atm_reg_en_1 = req_pre_valid & cbuf_is_ready & (is_req_atm_end | ((req_atm_sel == 2'h1) & ~is_atm_done[1] & req_ready_d0));
end

always @(
  req_pre_valid
  or cbuf_is_ready
  or is_req_atm_end
  or req_atm_sel
  or is_atm_done
  or req_ready_d0
  ) begin
    req_atm_reg_en_2 = req_pre_valid & cbuf_is_ready & (is_req_atm_end | ((req_atm_sel == 2'h2) & ~is_atm_done[2] & req_ready_d0));
end

always @(
  req_pre_valid
  or cbuf_is_ready
  or is_req_atm_end
  or req_atm_sel
  or is_atm_done
  or req_ready_d0
  ) begin
    req_atm_reg_en_3 = req_pre_valid & cbuf_is_ready & (is_req_atm_end | ((req_atm_sel == 2'h3) & ~is_atm_done[2] & req_ready_d0));
end

//When is_req_atm_end is set, we don't need to wait cbuf_is_ready;
always @(
  req_pre_valid
  or is_req_atm_end
  ) begin
    req_ch_reg_en = req_pre_valid & is_req_atm_end;
end

always @(
  req_pre_valid
  or is_req_atm_end
  or is_req_ch_end
  ) begin
    req_batch_reg_en = req_pre_valid & is_req_atm_end & is_req_ch_end;
end

always @(
  req_pre_valid
  or is_req_atm_end
  or is_req_ch_end
  or is_req_batch_end
  ) begin
    req_grain_reg_en = req_pre_valid & is_req_atm_end & is_req_ch_end & is_req_batch_end;
end

////////////////////////////////////////////////////////////////////////
//  CDMA DC read request interface                                    //
////////////////////////////////////////////////////////////////////////

// rd Channel: Request 
assign cv_dma_rd_req_vld = dma_rd_req_vld & (dma_rd_req_type == 1'b0);
assign mc_dma_rd_req_vld = dma_rd_req_vld & (dma_rd_req_type == 1'b1);
assign cv_rd_req_rdyi = cv_dma_rd_req_rdy & (dma_rd_req_type == 1'b0);
assign mc_rd_req_rdyi = mc_dma_rd_req_rdy & (dma_rd_req_type == 1'b1);
assign rd_req_rdyi = mc_rd_req_rdyi | cv_rd_req_rdyi;
assign dma_rd_req_rdy= rd_req_rdyi;
NV_NVDLA_CDMA_DC_pipe_p1 pipe_p1 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dma_rd_req_pd       (dma_rd_req_pd[78:0])     //|< w
  ,.mc_dma_rd_req_vld   (mc_dma_rd_req_vld)       //|< w
  ,.mc_int_rd_req_ready (mc_int_rd_req_ready)     //|< w
  ,.mc_dma_rd_req_rdy   (mc_dma_rd_req_rdy)       //|> w
  ,.mc_int_rd_req_pd    (mc_int_rd_req_pd[78:0])  //|> w
  ,.mc_int_rd_req_valid (mc_int_rd_req_valid)     //|> w
  );
NV_NVDLA_CDMA_DC_pipe_p2 pipe_p2 (
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
assign dc_dat2mcif_rd_req_valid = mc_int_rd_req_valid_d0;
assign mc_int_rd_req_ready_d0 = dc_dat2mcif_rd_req_ready;
assign dc_dat2mcif_rd_req_pd[78:0] = mc_int_rd_req_pd_d0[78:0];


assign cv_int_rd_req_valid_d0 = cv_int_rd_req_valid;
assign cv_int_rd_req_ready = cv_int_rd_req_ready_d0;
assign cv_int_rd_req_pd_d0[78:0] = cv_int_rd_req_pd[78:0];
assign dc_dat2cvif_rd_req_valid = cv_int_rd_req_valid_d0;
assign cv_int_rd_req_ready_d0 = dc_dat2cvif_rd_req_ready;
assign dc_dat2cvif_rd_req_pd[78:0] = cv_int_rd_req_pd_d0[78:0];

// rd Channel: Response

assign mcif2dc_dat_rd_rsp_valid_d0 = mcif2dc_dat_rd_rsp_valid;
assign mcif2dc_dat_rd_rsp_ready = mcif2dc_dat_rd_rsp_ready_d0;
assign mcif2dc_dat_rd_rsp_pd_d0[513:0] = mcif2dc_dat_rd_rsp_pd[513:0];
assign mc_int_rd_rsp_valid = mcif2dc_dat_rd_rsp_valid_d0;
assign mcif2dc_dat_rd_rsp_ready_d0 = mc_int_rd_rsp_ready;
assign mc_int_rd_rsp_pd[513:0] = mcif2dc_dat_rd_rsp_pd_d0[513:0];


assign cvif2dc_dat_rd_rsp_valid_d0 = cvif2dc_dat_rd_rsp_valid;
assign cvif2dc_dat_rd_rsp_ready = cvif2dc_dat_rd_rsp_ready_d0;
assign cvif2dc_dat_rd_rsp_pd_d0[513:0] = cvif2dc_dat_rd_rsp_pd[513:0];
assign cv_int_rd_rsp_valid = cvif2dc_dat_rd_rsp_valid_d0;
assign cvif2dc_dat_rd_rsp_ready_d0 = cv_int_rd_rsp_ready;
assign cv_int_rd_rsp_pd[513:0] = cvif2dc_dat_rd_rsp_pd_d0[513:0];

NV_NVDLA_CDMA_DC_pipe_p3 pipe_p3 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dma_rd_rsp_rdy      (dma_rd_rsp_rdy)          //|< w
  ,.mc_int_rd_rsp_pd    (mc_int_rd_rsp_pd[513:0]) //|< w
  ,.mc_int_rd_rsp_valid (mc_int_rd_rsp_valid)     //|< w
  ,.mc_dma_rd_rsp_pd    (mc_dma_rd_rsp_pd[513:0]) //|> w
  ,.mc_dma_rd_rsp_vld   (mc_dma_rd_rsp_vld)       //|> w
  ,.mc_int_rd_rsp_ready (mc_int_rd_rsp_ready)     //|> w
  );
NV_NVDLA_CDMA_DC_pipe_p4 pipe_p4 (
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
  nv_assert_never #(0,0,"DMAIF: mcif and cvif should never return data both")      zzz_assert_never_79x (nvdla_core_clk, `ASSERT_RESET, mc_dma_rd_rsp_vld & cv_dma_rd_rsp_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//assign dma_rd_req_vld = dma_req_fifo_ready & req_valid_d1 & cbuf_is_ready;
assign dma_rd_req_vld = dma_req_fifo_ready & req_valid_d1;
assign dma_rd_req_addr = {req_addr_d1[58:0], 5'b0};
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

always @(
  req_valid_d1
  or dma_rd_req_rdy
  ) begin
    dma_req_fifo_req = req_valid_d1 & dma_rd_req_rdy;
end

always @(
  req_ch_idx_d1
  or req_size_d1
  ) begin
    dma_req_fifo_data = {req_ch_idx_d1, req_size_d1};
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
  nv_assert_never #(0,0,"Error! Receive input data when not busy")      zzz_assert_never_80x (nvdla_core_clk, `ASSERT_RESET, (dma_rd_rsp_vld & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  CDMA DC read response connection                                  //
////////////////////////////////////////////////////////////////////////



// PKT_UNPACK_WIRE( dma_read_data , dma_rd_rsp_ , dma_rd_rsp_pd )
assign       dma_rd_rsp_data[511:0] =    dma_rd_rsp_pd[511:0];
assign       dma_rd_rsp_mask[1:0] =    dma_rd_rsp_pd[513:512];

always @(
  dma_rsp_fifo_data
  ) begin
    {dma_rsp_ch_idx, dma_rsp_size} = dma_rsp_fifo_data;
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
  or is_blocking
  or dma_rsp_size_cnt_inc
  or dma_rsp_size
  ) begin
    dma_rsp_fifo_ready = (dma_rd_rsp_vld & ~is_blocking & (dma_rsp_size_cnt_inc == dma_rsp_size));
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
  if ((dma_rd_rsp_vld & ~is_blocking) == 1'b1) begin
    dma_rsp_size_cnt <= dma_rsp_size_cnt_w;
  // VCS coverage off
  end else if ((dma_rd_rsp_vld & ~is_blocking) == 1'b0) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_81x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dma_rd_rsp_vld & ~is_blocking))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"response fifo pop error")      zzz_assert_never_82x (nvdla_core_clk, `ASSERT_RESET, (dma_rsp_fifo_ready & ~dma_rsp_fifo_req)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"response size mismatch")      zzz_assert_never_83x (nvdla_core_clk, `ASSERT_RESET, (dma_rsp_size_cnt_inc > dma_rsp_size)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! dma_rsp_size_cnt_inc is overflow")      zzz_assert_never_84x (nvdla_core_clk, `ASSERT_RESET, (mon_dma_rsp_size_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! dma_rsp_size_cnt_inc is out of range")      zzz_assert_never_85x (nvdla_core_clk, `ASSERT_RESET, (dma_rsp_size_cnt_inc > 8'h8)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  DC read data to shared buffer                                     //
////////////////////////////////////////////////////////////////////////

always @(
  layer_st
  or ch0_p0_wr_addr_cnt
  or dma_rd_rsp_mask
  ) begin
    {mon_ch0_p0_wr_addr_cnt_w,
     ch0_p0_wr_addr_cnt_w} = layer_st ? 7'b0 :
                             ch0_p0_wr_addr_cnt + dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1];
end

always @(
  layer_st
  or ch0_p1_wr_addr_cnt
  or dma_rd_rsp_mask
  ) begin
    {mon_ch0_p1_wr_addr_cnt_w,
     ch0_p1_wr_addr_cnt_w} = layer_st ? 7'b1 :
                             ch0_p1_wr_addr_cnt + dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1];
end

always @(
  layer_st
  or ch1_p0_wr_addr_cnt
  or dma_rd_rsp_mask
  ) begin
    {mon_ch1_p0_wr_addr_cnt_w,
     ch1_p0_wr_addr_cnt_w} = layer_st ? 7'b0 :
                             ch1_p0_wr_addr_cnt + dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1];
end

always @(
  layer_st
  or ch1_p1_wr_addr_cnt
  or dma_rd_rsp_mask
  ) begin
    {mon_ch1_p1_wr_addr_cnt_w,
     ch1_p1_wr_addr_cnt_w} = layer_st ? 7'b1 :
                             ch1_p1_wr_addr_cnt + dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1];
end

always @(
  layer_st
  or ch2_p0_wr_addr_cnt
  or dma_rd_rsp_mask
  ) begin
    {mon_ch2_p0_wr_addr_cnt_w,
     ch2_p0_wr_addr_cnt_w} = layer_st ? 7'b0 :
                             ch2_p0_wr_addr_cnt + dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1];
end

always @(
  layer_st
  or ch2_p1_wr_addr_cnt
  or dma_rd_rsp_mask
  ) begin
    {mon_ch2_p1_wr_addr_cnt_w,
     ch2_p1_wr_addr_cnt_w} = layer_st ? 7'b1 :
                             ch2_p1_wr_addr_cnt + dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1];
end

always @(
  layer_st
  or ch3_p0_wr_addr_cnt
  or dma_rd_rsp_mask
  ) begin
    {mon_ch3_p0_wr_addr_cnt_w,
     ch3_p0_wr_addr_cnt_w} = layer_st ? 7'b0 :
                             ch3_p0_wr_addr_cnt + dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1];
end

always @(
  layer_st
  or ch3_p1_wr_addr_cnt
  or dma_rd_rsp_mask
  ) begin
    {mon_ch3_p1_wr_addr_cnt_w,
     ch3_p1_wr_addr_cnt_w} = layer_st ? 7'b1 :
                             ch3_p1_wr_addr_cnt + dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1];
end

always @(
  dma_rsp_fifo_req
  or dma_rsp_ch_idx
  ) begin
    is_rsp_ch0 = dma_rsp_fifo_req & (dma_rsp_ch_idx == 2'h0);
end

always @(
  dma_rsp_fifo_req
  or dma_rsp_ch_idx
  ) begin
    is_rsp_ch1 = dma_rsp_fifo_req & (dma_rsp_ch_idx == 2'h1);
end

always @(
  dma_rsp_fifo_req
  or dma_rsp_ch_idx
  ) begin
    is_rsp_ch2 = dma_rsp_fifo_req & (dma_rsp_ch_idx == 2'h2);
end

always @(
  dma_rsp_fifo_req
  or dma_rsp_ch_idx
  ) begin
    is_rsp_ch3 = dma_rsp_fifo_req & (dma_rsp_ch_idx == 2'h3);
end

always @(
  dma_rd_rsp_vld
  or is_blocking
  or is_running
  or is_rsp_ch0
  ) begin
    ch0_wr_addr_cnt_reg_en = dma_rd_rsp_vld & ~is_blocking & is_running & is_rsp_ch0;
end

always @(
  dma_rd_rsp_vld
  or is_blocking
  or is_running
  or is_rsp_ch1
  ) begin
    ch1_wr_addr_cnt_reg_en = dma_rd_rsp_vld & ~is_blocking & is_running & is_rsp_ch1;
end

always @(
  dma_rd_rsp_vld
  or is_blocking
  or is_running
  or is_rsp_ch2
  ) begin
    ch2_wr_addr_cnt_reg_en = dma_rd_rsp_vld & ~is_blocking & is_running & is_rsp_ch2;
end

always @(
  dma_rd_rsp_vld
  or is_blocking
  or is_running
  or is_rsp_ch3
  ) begin
    ch3_wr_addr_cnt_reg_en = dma_rd_rsp_vld & ~is_blocking & is_running & is_rsp_ch3;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ch0_p0_wr_addr_cnt <= {6{1'b0}};
  end else begin
  if ((layer_st | ch0_wr_addr_cnt_reg_en) == 1'b1) begin
    ch0_p0_wr_addr_cnt <= ch0_p0_wr_addr_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch0_wr_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch0_p0_wr_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_86x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch0_wr_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch1_p0_wr_addr_cnt <= {6{1'b0}};
  end else begin
  if ((layer_st | ch1_wr_addr_cnt_reg_en) == 1'b1) begin
    ch1_p0_wr_addr_cnt <= ch1_p0_wr_addr_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch1_wr_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch1_p0_wr_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_87x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch1_wr_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch2_p0_wr_addr_cnt <= {6{1'b0}};
  end else begin
  if ((layer_st | ch2_wr_addr_cnt_reg_en) == 1'b1) begin
    ch2_p0_wr_addr_cnt <= ch2_p0_wr_addr_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch2_wr_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch2_p0_wr_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_88x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch2_wr_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch3_p0_wr_addr_cnt <= {6{1'b0}};
  end else begin
  if ((layer_st | ch3_wr_addr_cnt_reg_en) == 1'b1) begin
    ch3_p0_wr_addr_cnt <= ch3_p0_wr_addr_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch3_wr_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch3_p0_wr_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_89x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch3_wr_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch0_p1_wr_addr_cnt <= 6'b1;
  end else begin
  if ((layer_st | ch0_wr_addr_cnt_reg_en) == 1'b1) begin
    ch0_p1_wr_addr_cnt <= ch0_p1_wr_addr_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch0_wr_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch0_p1_wr_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_90x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch0_wr_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch1_p1_wr_addr_cnt <= 6'b1;
  end else begin
  if ((layer_st | ch1_wr_addr_cnt_reg_en) == 1'b1) begin
    ch1_p1_wr_addr_cnt <= ch1_p1_wr_addr_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch1_wr_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch1_p1_wr_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_91x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch1_wr_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch2_p1_wr_addr_cnt <= 6'b1;
  end else begin
  if ((layer_st | ch2_wr_addr_cnt_reg_en) == 1'b1) begin
    ch2_p1_wr_addr_cnt <= ch2_p1_wr_addr_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch2_wr_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch2_p1_wr_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_92x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch2_wr_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch3_p1_wr_addr_cnt <= 6'b1;
  end else begin
  if ((layer_st | ch3_wr_addr_cnt_reg_en) == 1'b1) begin
    ch3_p1_wr_addr_cnt <= ch3_p1_wr_addr_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch3_wr_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch3_p1_wr_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_93x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch3_wr_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign ch0_p0_wr_addr = {2'h0, ch0_p0_wr_addr_cnt[0], ch0_p0_wr_addr_cnt[8 -3:1]};
assign ch0_p1_wr_addr = {2'h0, ch0_p1_wr_addr_cnt[0], ch0_p1_wr_addr_cnt[8 -3:1]};
assign ch1_p0_wr_addr = {2'h1, ch1_p0_wr_addr_cnt[0], ch1_p0_wr_addr_cnt[8 -3:1]};
assign ch1_p1_wr_addr = {2'h1, ch1_p1_wr_addr_cnt[0], ch1_p1_wr_addr_cnt[8 -3:1]};
assign ch2_p0_wr_addr = {2'h2, ch2_p0_wr_addr_cnt[0], ch2_p0_wr_addr_cnt[8 -3:1]};
assign ch2_p1_wr_addr = {2'h2, ch2_p1_wr_addr_cnt[0], ch2_p1_wr_addr_cnt[8 -3:1]};
assign ch3_p0_wr_addr = {2'h3, ch3_p0_wr_addr_cnt[0], ch3_p0_wr_addr_cnt[8 -3:1]};
assign ch3_p1_wr_addr = {2'h3, ch3_p1_wr_addr_cnt[0], ch3_p1_wr_addr_cnt[8 -3:1]};

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_zero_one_hot #(0,4,0,"Error! ch_reg_en is not one hot")      zzz_assert_zero_one_hot_94x (nvdla_core_clk, `ASSERT_RESET, {ch0_wr_addr_cnt_reg_en, ch1_wr_addr_cnt_reg_en, ch2_wr_addr_cnt_reg_en, ch3_wr_addr_cnt_reg_en}); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  Shared buffer write signals                                       //
////////////////////////////////////////////////////////////////////////
always @(
  is_running
  or dma_rd_rsp_vld
  or is_blocking
  or dma_rd_rsp_mask
  ) begin
    p0_wr_en = is_running & dma_rd_rsp_vld & ~is_blocking & dma_rd_rsp_mask[0];
end

always @(
  is_running
  or dma_rd_rsp_vld
  or is_blocking
  or dma_rd_rsp_mask
  ) begin
    p1_wr_en = is_running & dma_rd_rsp_vld & ~is_blocking & dma_rd_rsp_mask[1];
end

always @(
  p0_wr_en
  or is_rsp_ch0
  or ch0_p0_wr_addr
  or is_rsp_ch1
  or ch1_p0_wr_addr
  or is_rsp_ch2
  or ch2_p0_wr_addr
  or is_rsp_ch3
  or ch3_p0_wr_addr
  ) begin
    p0_wr_addr = ({8 {p0_wr_en & is_rsp_ch0}} & ch0_p0_wr_addr) 
               | ({8 {p0_wr_en & is_rsp_ch1}} & ch1_p0_wr_addr) 
               | ({8 {p0_wr_en & is_rsp_ch2}} & ch2_p0_wr_addr) 
               | ({8 {p0_wr_en & is_rsp_ch3}} & ch3_p0_wr_addr);
end

always @(
  p1_wr_en
  or is_rsp_ch0
  or ch0_p1_wr_addr
  or is_rsp_ch1
  or ch1_p1_wr_addr
  or is_rsp_ch2
  or ch2_p1_wr_addr
  or is_rsp_ch3
  or ch3_p1_wr_addr
  ) begin
    p1_wr_addr = ({8 {p1_wr_en & is_rsp_ch0}} & ch0_p1_wr_addr) 
               | ({8 {p1_wr_en & is_rsp_ch1}} & ch1_p1_wr_addr) 
               | ({8 {p1_wr_en & is_rsp_ch2}} & ch2_p1_wr_addr) 
               | ({8 {p1_wr_en & is_rsp_ch3}} & ch3_p1_wr_addr);
end

//&Always;
//    p1_wr_addr = ({CDMA_SBUF_ADDR_BITS{p1_wr_en & ~dma_rd_rsp_mask[0] & is_rsp_ch0}} & ch0_p0_wr_addr) 
//               | ({CDMA_SBUF_ADDR_BITS{p1_wr_en & dma_rd_rsp_mask[0] & is_rsp_ch0}} & ch0_p1_wr_addr) 
//               | ({CDMA_SBUF_ADDR_BITS{p1_wr_en & ~dma_rd_rsp_mask[0] & is_rsp_ch1}} & ch1_p0_wr_addr) 
//               | ({CDMA_SBUF_ADDR_BITS{p1_wr_en & dma_rd_rsp_mask[0] & is_rsp_ch1}} & ch1_p1_wr_addr) 
//               | ({CDMA_SBUF_ADDR_BITS{p1_wr_en & ~dma_rd_rsp_mask[0] & is_rsp_ch2}} & ch2_p0_wr_addr) 
//               | ({CDMA_SBUF_ADDR_BITS{p1_wr_en & dma_rd_rsp_mask[0] & is_rsp_ch2}} & ch2_p1_wr_addr) 
//               | ({CDMA_SBUF_ADDR_BITS{p1_wr_en & ~dma_rd_rsp_mask[0] & is_rsp_ch3}} & ch3_p0_wr_addr)
//               | ({CDMA_SBUF_ADDR_BITS{p1_wr_en & dma_rd_rsp_mask[0] & is_rsp_ch3}} & ch3_p1_wr_addr);
//&End;

assign dc2sbuf_p0_wr_en = p0_wr_en;
assign dc2sbuf_p1_wr_en = p1_wr_en;
assign dc2sbuf_p0_wr_addr = p0_wr_addr;
assign dc2sbuf_p1_wr_addr = p1_wr_addr;
assign dc2sbuf_p0_wr_data = dma_rsp_data_p0;
assign dc2sbuf_p1_wr_data = dma_rsp_data_p1;

////////////////////////////////////////////////////////////////////////
//  DC local buffer count                                             //
////////////////////////////////////////////////////////////////////////

always @(
  ch0_wr_addr_cnt_reg_en
  or dma_rd_rsp_mask
  ) begin
    ch0_cnt_add = (ch0_wr_addr_cnt_reg_en) ? (dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1]) : 2'h0;
end

always @(
  ch1_wr_addr_cnt_reg_en
  or dma_rd_rsp_mask
  ) begin
    ch1_cnt_add = (ch1_wr_addr_cnt_reg_en) ? (dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1]) : 2'h0;
end

always @(
  ch2_wr_addr_cnt_reg_en
  or dma_rd_rsp_mask
  ) begin
    ch2_cnt_add = (ch2_wr_addr_cnt_reg_en) ? (dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1]) : 2'h0;
end

always @(
  ch3_wr_addr_cnt_reg_en
  or dma_rd_rsp_mask
  ) begin
    ch3_cnt_add = (ch3_wr_addr_cnt_reg_en) ? (dma_rd_rsp_mask[0] + dma_rd_rsp_mask[1]) : 2'h0;
end

always @(
  ch0_rd_addr_cnt_reg_en
  or rsp_ch0_rd_size
  ) begin
    ch0_cnt_sub = (ch0_rd_addr_cnt_reg_en) ? rsp_ch0_rd_size : 2'h0;
end

always @(
  ch1_rd_addr_cnt_reg_en
  ) begin
    ch1_cnt_sub = (ch1_rd_addr_cnt_reg_en) ? 1'b1 : 1'h0;
end

always @(
  ch2_rd_addr_cnt_reg_en
  ) begin
    ch2_cnt_sub = (ch2_rd_addr_cnt_reg_en) ? 1'b1 : 1'h0;
end

always @(
  ch3_rd_addr_cnt_reg_en
  ) begin
    ch3_cnt_sub = (ch3_rd_addr_cnt_reg_en) ? 1'b1 : 1'h0;
end

always @(
  layer_st
  or ch0_cnt
  or ch0_cnt_add
  or ch0_cnt_sub
  ) begin
    {mon_ch0_cnt_w,
     ch0_cnt_w} = layer_st ? 6'b0 : (ch0_cnt + ch0_cnt_add - ch0_cnt_sub);
end

always @(
  layer_st
  or ch1_cnt
  or ch1_cnt_add
  or ch1_cnt_sub
  ) begin
    {mon_ch1_cnt_w,
     ch1_cnt_w} = layer_st ? 6'b0 : (ch1_cnt + ch1_cnt_add - ch1_cnt_sub);
end

always @(
  layer_st
  or ch2_cnt
  or ch2_cnt_add
  or ch2_cnt_sub
  ) begin
    {mon_ch2_cnt_w,
     ch2_cnt_w} = layer_st ? 6'b0 : (ch2_cnt + ch2_cnt_add - ch2_cnt_sub);
end

always @(
  layer_st
  or ch3_cnt
  or ch3_cnt_add
  or ch3_cnt_sub
  ) begin
    {mon_ch3_cnt_w,
     ch3_cnt_w} = layer_st ? 6'b0 : (ch3_cnt + ch3_cnt_add - ch3_cnt_sub);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ch0_cnt <= {5{1'b0}};
  end else begin
  if ((layer_st | ch0_wr_addr_cnt_reg_en | ch0_rd_addr_cnt_reg_en) == 1'b1) begin
    ch0_cnt <= ch0_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch0_wr_addr_cnt_reg_en | ch0_rd_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch0_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_95x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch0_wr_addr_cnt_reg_en | ch0_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch1_cnt <= {5{1'b0}};
  end else begin
  if ((layer_st | ch1_wr_addr_cnt_reg_en | ch1_rd_addr_cnt_reg_en) == 1'b1) begin
    ch1_cnt <= ch1_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch1_wr_addr_cnt_reg_en | ch1_rd_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch1_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_96x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch1_wr_addr_cnt_reg_en | ch1_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch2_cnt <= {5{1'b0}};
  end else begin
  if ((layer_st | ch2_wr_addr_cnt_reg_en | ch2_rd_addr_cnt_reg_en) == 1'b1) begin
    ch2_cnt <= ch2_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch2_wr_addr_cnt_reg_en | ch2_rd_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch2_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_97x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch2_wr_addr_cnt_reg_en | ch2_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch3_cnt <= {5{1'b0}};
  end else begin
  if ((layer_st | ch3_wr_addr_cnt_reg_en | ch3_rd_addr_cnt_reg_en) == 1'b1) begin
    ch3_cnt <= ch3_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch3_wr_addr_cnt_reg_en | ch3_rd_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch3_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_98x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch3_wr_addr_cnt_reg_en | ch3_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! Channel 0 is not zero when idle!")      zzz_assert_never_99x (nvdla_core_clk, `ASSERT_RESET, ((|ch0_cnt) & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! Channel 1 is not zero when idle!")      zzz_assert_never_100x (nvdla_core_clk, `ASSERT_RESET, ((|ch1_cnt) & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! Channel 2 is not zero when idle!")      zzz_assert_never_101x (nvdla_core_clk, `ASSERT_RESET, ((|ch2_cnt) & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! Channel 3 is not zero when idle!")      zzz_assert_never_102x (nvdla_core_clk, `ASSERT_RESET, ((|ch3_cnt) & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  DC response data counter                                          //
////////////////////////////////////////////////////////////////////////
///////////// all height counter /////////////

always @(
  rsp_all_h_cnt
  or rsp_cur_grain
  ) begin
    {mon_rsp_all_h_cnt_inc,
     rsp_all_h_cnt_inc} = rsp_all_h_cnt + rsp_cur_grain;
end

always @(
  layer_st
  or data_height_w
  or data_height
  or rsp_all_h_cnt_inc
  ) begin
    {mon_rsp_all_h_left_w,
     rsp_all_h_left_w} = layer_st ? {1'b0, data_height_w} :
                         data_height - rsp_all_h_cnt_inc;
end

always @(
  rsp_all_h_left_w
  or fetch_grain_w
  ) begin
    rsp_cur_grain_w = (rsp_all_h_left_w > {{2{1'b0}}, fetch_grain_w}) ? fetch_grain_w :
                      rsp_all_h_left_w[11:0];
end

always @(
  rsp_all_h_cnt_inc
  or data_height
  ) begin
    is_rsp_all_h_end = (rsp_all_h_cnt_inc == data_height);
end

always @(
  layer_st
  or rsp_all_h_cnt_inc
  ) begin
    rsp_all_h_cnt_w = (layer_st) ? 14'b0 :
                       rsp_all_h_cnt_inc;
end

always @(
  reg2dp_op_en
  or rsp_all_h_cnt
  or data_height
  ) begin
    is_rsp_done = ~reg2dp_op_en | (rsp_all_h_cnt == data_height);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_all_h_cnt <= {14{1'b0}};
  end else begin
  if ((layer_st | rsp_all_h_reg_en) == 1'b1) begin
    rsp_all_h_cnt <= rsp_all_h_cnt_w;
  // VCS coverage off
  end else if ((layer_st | rsp_all_h_reg_en) == 1'b0) begin
  end else begin
    rsp_all_h_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_103x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_all_h_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_cur_grain <= {12{1'b0}};
  end else begin
  if ((layer_st | rsp_all_h_reg_en) == 1'b1) begin
    rsp_cur_grain <= rsp_cur_grain_w;
  // VCS coverage off
  end else if ((layer_st | rsp_all_h_reg_en) == 1'b0) begin
  end else begin
    rsp_cur_grain <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_104x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_all_h_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_all_h_cnt_inc is overflow")      zzz_assert_never_105x (nvdla_core_clk, `ASSERT_RESET, (mon_rsp_all_h_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_all_h_left_w is overflow")      zzz_assert_never_106x (nvdla_core_clk, `ASSERT_RESET, (mon_rsp_all_h_left_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// batch counter /////////////

always @(
  rsp_batch_cnt
  ) begin
    {mon_rsp_batch_cnt_inc,
     rsp_batch_cnt_inc} = rsp_batch_cnt + 1'b1;
end

always @(
  rsp_batch_cnt
  or reg2dp_batches
  ) begin
    is_rsp_batch_end = (rsp_batch_cnt == reg2dp_batches);
end

always @(
  layer_st
  or is_rsp_batch_end
  or rsp_batch_cnt_inc
  ) begin
    rsp_batch_cnt_w = (layer_st | is_rsp_batch_end) ? 5'b0 :
                      rsp_batch_cnt_inc;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_batch_cnt <= {5{1'b0}};
  end else begin
  if ((layer_st | rsp_batch_reg_en) == 1'b1) begin
    rsp_batch_cnt <= rsp_batch_cnt_w;
  // VCS coverage off
  end else if ((layer_st | rsp_batch_reg_en) == 1'b0) begin
  end else begin
    rsp_batch_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_107x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_batch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// channel counter /////////////

assign rsp_ch_mode = req_ch_mode;

always @(
  rsp_ch_cnt
  or rsp_cur_ch
  ) begin
    {mon_rsp_ch_cnt_inc,
     rsp_ch_cnt_inc} = rsp_ch_cnt + rsp_cur_ch;
end

always @(
  layer_st
  or is_rsp_ch_end
  or data_surface_w
  or data_surface
  or rsp_ch_cnt_inc
  ) begin
    {mon_rsp_ch_left_w,
     rsp_ch_left_w} = (layer_st | is_rsp_ch_end) ? {1'b0, data_surface_w} :
                      (data_surface - rsp_ch_cnt_inc);
end

always @(
  rsp_ch_cnt_inc
  or data_surface
  ) begin
    is_rsp_ch_end = (rsp_ch_cnt_inc == data_surface); 
end

always @(
  rsp_ch_left_w
  or rsp_ch_mode
  ) begin
    rsp_cur_ch_w = (rsp_ch_left_w > {{7{1'b0}}, rsp_ch_mode}) ? rsp_ch_mode :
                   rsp_ch_left_w[2:0];
end

always @(
  layer_st
  or is_rsp_ch_end
  or rsp_ch_cnt_inc
  ) begin
    rsp_ch_cnt_w = (layer_st | is_rsp_ch_end) ? 10'b0 :
                   rsp_ch_cnt_inc;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_ch_cnt <= {10{1'b0}};
  end else begin
  if ((layer_st | rsp_ch_reg_en) == 1'b1) begin
    rsp_ch_cnt <= rsp_ch_cnt_w;
  // VCS coverage off
  end else if ((layer_st | rsp_ch_reg_en) == 1'b0) begin
  end else begin
    rsp_ch_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_108x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_ch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_cur_ch <= {3{1'b0}};
  end else begin
  if ((layer_st | rsp_ch_reg_en) == 1'b1) begin
    rsp_cur_ch <= rsp_cur_ch_w;
  // VCS coverage off
  end else if ((layer_st | rsp_ch_reg_en) == 1'b0) begin
  end else begin
    rsp_cur_ch <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_109x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_ch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_ch_cnt_inc is overflow")      zzz_assert_never_110x (nvdla_core_clk, `ASSERT_RESET, (mon_rsp_ch_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_ch_left_w is overflow")      zzz_assert_never_111x (nvdla_core_clk, `ASSERT_RESET, (mon_rsp_ch_left_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_cur_ch is out of range")      zzz_assert_never_112x (nvdla_core_clk, `ASSERT_RESET, (rsp_cur_ch > 3'h4)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// height counter /////////////

always @(
  rsp_h_cnt
  ) begin
    {mon_rsp_h_cnt_inc,
     rsp_h_cnt_inc} = rsp_h_cnt + 1'b1;
end

always @(
  rsp_h_cnt_inc
  or rsp_cur_grain
  ) begin
    is_rsp_h_end = (rsp_h_cnt_inc == rsp_cur_grain);
end

always @(
  layer_st
  or is_rsp_h_end
  or rsp_h_cnt_inc
  ) begin
    rsp_h_cnt_w = (layer_st | is_rsp_h_end) ? 12'b0 :
                  rsp_h_cnt_inc;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_h_cnt <= {12{1'b0}};
  end else begin
  if ((layer_st | rsp_h_reg_en) == 1'b1) begin
    rsp_h_cnt <= rsp_h_cnt_w;
  // VCS coverage off
  end else if ((layer_st | rsp_h_reg_en) == 1'b0) begin
  end else begin
    rsp_h_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_113x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_h_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_h_cnt_inc is overflow")      zzz_assert_never_114x (nvdla_core_clk, `ASSERT_RESET, (mon_rsp_h_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// width counter /////////////

always @(
  rsp_w_cnt
  or rsp_w_cnt_add
  ) begin
    {mon_rsp_w_cnt_inc,
     rsp_w_cnt_inc} = rsp_w_cnt + rsp_w_cnt_add;
end

always @(
  rsp_w_cnt_inc
  or data_width
  ) begin
    is_rsp_w_end = (rsp_w_cnt_inc == data_width);
end

always @(
  rsp_w_cnt
  or data_width_sub_one
  ) begin
    rsp_w_one_left = (rsp_w_cnt == {1'b0, data_width_sub_one});
end

always @(
  layer_st
  or is_rsp_w_end
  or rsp_w_cnt_inc
  ) begin
    rsp_w_cnt_w = (layer_st | is_rsp_w_end) ? 16'b0 :
                  rsp_w_cnt_inc;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_w_cnt <= {16{1'b0}};
  end else begin
  if ((layer_st | rsp_w_reg_en) == 1'b1) begin
    rsp_w_cnt <= rsp_w_cnt_w;
  // VCS coverage off
  end else if ((layer_st | rsp_w_reg_en) == 1'b0) begin
  end else begin
    rsp_w_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_115x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_w_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON


///////////// response control signal /////////////
always @(
  rsp_cur_ch
  or rsp_w_one_left
  or is_data_normal
  or rsp_ch_cnt
  or is_data_shrink
  ) begin
    rsp_ch0_rd_one = ~(rsp_cur_ch == 3'h1) |
                     rsp_w_one_left |
                     (is_data_normal & rsp_ch_cnt[1]) |
                     (is_data_shrink & rsp_ch_cnt[2]);
end

always @(
  rsp_cur_ch
  or rsp_w_one_left
  or is_data_normal
  or rsp_ch_cnt
  or is_data_shrink
  or rsp_rd_ch2ch3
  ) begin
    rsp_rd_one = ((rsp_cur_ch == 3'h1) & rsp_w_one_left) |
                 ((rsp_cur_ch == 3'h1) & is_data_normal & rsp_ch_cnt[1]) |
                 ((rsp_cur_ch == 3'h1) & is_data_shrink & rsp_ch_cnt[2]) |
                 ((rsp_cur_ch == 3'h3) & is_data_shrink & rsp_ch_cnt[2] & rsp_rd_ch2ch3);
end

always @(
  rsp_ch0_rd_one
  ) begin
    rsp_w_cnt_add = (rsp_ch0_rd_one) ? 2'h1 : 2'h2;
end

assign rsp_ch0_rd_size = rsp_w_cnt_add;

always @(
  is_rsp_done
  or is_running
  or rsp_cur_ch
  or ch0_cnt
  or rsp_w_cnt_add
  or ch1_cnt
  or rsp_rd_ch2ch3
  ) begin
    rsp_w_reg_en = ~is_rsp_done & is_running &
                  ((rsp_cur_ch == 3'h1 & (ch0_cnt >= {3'b0, rsp_w_cnt_add})) 
                  | (rsp_cur_ch == 3'h2 & (|ch0_cnt) & (|ch1_cnt))
                  | (rsp_cur_ch > 3'h2 & rsp_rd_ch2ch3));
end

always @(
  rsp_w_reg_en
  or is_rsp_w_end
  ) begin
    rsp_h_reg_en = rsp_w_reg_en & is_rsp_w_end;
end

always @(
  rsp_w_reg_en
  or is_rsp_w_end
  or is_rsp_h_end
  ) begin
    rsp_ch_reg_en = rsp_w_reg_en & is_rsp_w_end & is_rsp_h_end;
end

always @(
  rsp_w_reg_en
  or is_rsp_w_end
  or is_rsp_h_end
  or is_rsp_ch_end
  ) begin
    rsp_batch_reg_en = rsp_w_reg_en & is_rsp_w_end & is_rsp_h_end & is_rsp_ch_end;
end

always @(
  rsp_w_reg_en
  or is_rsp_w_end
  or is_rsp_h_end
  or is_rsp_ch_end
  or is_rsp_batch_end
  ) begin
    rsp_all_h_reg_en = rsp_w_reg_en & is_rsp_w_end & is_rsp_h_end & is_rsp_ch_end & is_rsp_batch_end;
end

////////////////////////////////////////////////////////////////////////
//  generate shared buffer rd signals                                 //
////////////////////////////////////////////////////////////////////////
///////////// read enable signal /////////////
always @(
  ch0_cnt
  or ch1_cnt
  or ch2_cnt
  or ch3_cnt
  ) begin
    ch0_aval = (|ch0_cnt);
    ch1_aval = (|ch1_cnt);
    ch2_aval = (|ch2_cnt);
    ch3_aval = (|ch3_cnt);
end

always @(
  is_rsp_done
  or is_running
  or rsp_cur_ch
  or ch0_cnt
  or rsp_w_cnt_add
  or ch0_aval
  or ch1_aval
  or rsp_rd_ch2ch3
  or ch2_aval
  or ch3_aval
  ) begin
    rsp_rd_en = ~is_rsp_done & is_running &
                ((rsp_cur_ch == 3'h1 & (ch0_cnt >= {3'b0, rsp_w_cnt_add})) |
                 (rsp_cur_ch == 3'h2 & ch0_aval & ch1_aval) |
                 (rsp_cur_ch == 3'h3 & ~rsp_rd_ch2ch3 & ch0_aval & ch1_aval) |
                 (rsp_cur_ch == 3'h3 & rsp_rd_ch2ch3 & ch2_aval) |
                 (rsp_cur_ch == 3'h4 & ~rsp_rd_ch2ch3 & ch0_aval & ch1_aval) |
                 (rsp_cur_ch == 3'h4 & rsp_rd_ch2ch3 & ch2_aval & ch3_aval));
end

assign p0_rd_en_w = rsp_rd_en;

always @(
  rsp_rd_en
  or rsp_rd_one
  ) begin
    p1_rd_en_w = rsp_rd_en & ~rsp_rd_one;
end

///////////// channel address counter /////////////

always @(
  layer_st
  or ch0_p0_rd_addr_cnt
  or rsp_ch0_rd_size
  ) begin
    {mon_ch0_p0_rd_addr_cnt_w,
     ch0_p0_rd_addr_cnt_w} = layer_st ? 7'b0 :
                             ch0_p0_rd_addr_cnt + rsp_ch0_rd_size;
end

always @(
  layer_st
  or ch0_p1_rd_addr_cnt
  or rsp_ch0_rd_size
  ) begin
    {mon_ch0_p1_rd_addr_cnt_w,
     ch0_p1_rd_addr_cnt_w} = layer_st ? 7'b1 :
                             ch0_p1_rd_addr_cnt + rsp_ch0_rd_size;
end

always @(
  layer_st
  or ch1_p1_rd_addr_cnt
  ) begin
    {mon_ch1_p1_rd_addr_cnt_w,
     ch1_p1_rd_addr_cnt_w} = layer_st ? 7'b0 :
                             ch1_p1_rd_addr_cnt + 1'b1;
end

always @(
  layer_st
  or ch2_p0_rd_addr_cnt
  ) begin
    {mon_ch2_p0_rd_addr_cnt_w,
     ch2_p0_rd_addr_cnt_w} = layer_st ? 7'b0 :
                             ch2_p0_rd_addr_cnt + 1'b1;
end

always @(
  layer_st
  or ch3_p1_rd_addr_cnt
  ) begin
    {mon_ch3_p1_rd_addr_cnt_w,
     ch3_p1_rd_addr_cnt_w} = layer_st ? 7'b0 :
                             ch3_p1_rd_addr_cnt + 1'b1;
end

always @(
  rsp_rd_en
  or rsp_rd_ch2ch3
  ) begin
    ch0_rd_addr_cnt_reg_en = rsp_rd_en & ~rsp_rd_ch2ch3;
end

always @(
  rsp_rd_en
  or rsp_cur_ch
  or rsp_rd_ch2ch3
  ) begin
    ch1_rd_addr_cnt_reg_en = rsp_rd_en & (rsp_cur_ch >= 3'h2) & ~rsp_rd_ch2ch3;
end

always @(
  rsp_rd_en
  or rsp_cur_ch
  or rsp_rd_ch2ch3
  ) begin
    ch2_rd_addr_cnt_reg_en = rsp_rd_en & (rsp_cur_ch >= 3'h3) & rsp_rd_ch2ch3;
end

always @(
  rsp_rd_en
  or rsp_cur_ch
  or rsp_rd_ch2ch3
  ) begin
    ch3_rd_addr_cnt_reg_en = rsp_rd_en& (rsp_cur_ch == 3'h4)  & rsp_rd_ch2ch3;
end

always @(
  layer_st
  or rsp_cur_ch
  or rsp_rd_ch2ch3
  ) begin
    rsp_rd_ch2ch3_w = layer_st ? 1'b0 :
                      (rsp_cur_ch <= 3'h2) ? 1'b0 :
                      ~rsp_rd_ch2ch3;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ch0_p0_rd_addr_cnt <= {6{1'b0}};
  end else begin
  if ((layer_st | ch0_rd_addr_cnt_reg_en) == 1'b1) begin
    ch0_p0_rd_addr_cnt <= ch0_p0_rd_addr_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch0_rd_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch0_p0_rd_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_116x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch0_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch1_p1_rd_addr_cnt <= {6{1'b0}};
  end else begin
  if ((layer_st | ch1_rd_addr_cnt_reg_en) == 1'b1) begin
    ch1_p1_rd_addr_cnt <= ch1_p1_rd_addr_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch1_rd_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch1_p1_rd_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_117x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch1_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch2_p0_rd_addr_cnt <= {6{1'b0}};
  end else begin
  if ((layer_st | ch2_rd_addr_cnt_reg_en) == 1'b1) begin
    ch2_p0_rd_addr_cnt <= ch2_p0_rd_addr_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch2_rd_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch2_p0_rd_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_118x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch2_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch3_p1_rd_addr_cnt <= {6{1'b0}};
  end else begin
  if ((layer_st | ch3_rd_addr_cnt_reg_en) == 1'b1) begin
    ch3_p1_rd_addr_cnt <= ch3_p1_rd_addr_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch3_rd_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch3_p1_rd_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_119x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch3_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    ch0_p1_rd_addr_cnt <= 6'b1;
  end else begin
  if ((layer_st | ch0_rd_addr_cnt_reg_en) == 1'b1) begin
    ch0_p1_rd_addr_cnt <= ch0_p1_rd_addr_cnt_w;
  // VCS coverage off
  end else if ((layer_st | ch0_rd_addr_cnt_reg_en) == 1'b0) begin
  end else begin
    ch0_p1_rd_addr_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_120x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | ch0_rd_addr_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_rd_ch2ch3 <= 1'b0;
  end else begin
  if ((layer_st | rsp_rd_en) == 1'b1) begin
    rsp_rd_ch2ch3 <= rsp_rd_ch2ch3_w;
  // VCS coverage off
  end else if ((layer_st | rsp_rd_en) == 1'b0) begin
  end else begin
    rsp_rd_ch2ch3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_121x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_rd_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign ch0_p0_rd_addr = {2'h0, ch0_p0_rd_addr_cnt[0], ch0_p0_rd_addr_cnt[8 -3:1]};
assign ch0_p1_rd_addr = {2'h0, ch0_p1_rd_addr_cnt[0], ch0_p1_rd_addr_cnt[8 -3:1]};
assign ch1_p1_rd_addr = {2'h1, ch1_p1_rd_addr_cnt[0], ch1_p1_rd_addr_cnt[8 -3:1]};
assign ch2_p0_rd_addr = {2'h2, ch2_p0_rd_addr_cnt[0], ch2_p0_rd_addr_cnt[8 -3:1]};
assign ch3_p1_rd_addr = {2'h3, ch3_p1_rd_addr_cnt[0], ch3_p1_rd_addr_cnt[8 -3:1]};

///////////// shared buffer read address /////////////
always @(
  rsp_rd_ch2ch3
  or ch2_p0_rd_addr
  or ch0_p0_rd_addr
  ) begin
    p0_rd_addr_w = rsp_rd_ch2ch3 ? ch2_p0_rd_addr : ch0_p0_rd_addr;
end

always @(
  rsp_cur_ch
  or ch0_p1_rd_addr
  or rsp_rd_ch2ch3
  or ch3_p1_rd_addr
  or ch1_p1_rd_addr
  ) begin
    p1_rd_addr_w = (rsp_cur_ch == 3'h1) ? ch0_p1_rd_addr :
                   rsp_rd_ch2ch3 ? ch3_p1_rd_addr :
                   ch1_p1_rd_addr;
end

///////////// blocking signal /////////////
always @(
  is_running
  or layer_st
  or is_blocking
  or rsp_rd_en
  or rsp_ch0_rd_one
  ) begin
    is_blocking_w = (~is_running | layer_st) ? 1'b0 :
                    (~is_blocking & rsp_rd_en & rsp_ch0_rd_one) ? 1'b1 :
                    1'b0;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_blocking <= 1'b0;
  end else begin
  is_blocking <= is_blocking_w;
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
  nv_assert_never #(0,0,"Error! Blocking data response when not enabled")      zzz_assert_never_122x (nvdla_core_clk, `ASSERT_RESET, (is_blocking & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// output to shared buffer /////////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dc2sbuf_p0_rd_en <= 1'b0;
  end else begin
  dc2sbuf_p0_rd_en <= p0_rd_en_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dc2sbuf_p1_rd_en <= 1'b0;
  end else begin
  dc2sbuf_p1_rd_en <= p1_rd_en_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dc2sbuf_p0_rd_addr <= {8{1'b0}};
  end else begin
  if ((p0_rd_en_w) == 1'b1) begin
    dc2sbuf_p0_rd_addr <= p0_rd_addr_w;
  // VCS coverage off
  end else if ((p0_rd_en_w) == 1'b0) begin
  end else begin
    dc2sbuf_p0_rd_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_123x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(p0_rd_en_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    dc2sbuf_p1_rd_addr <= {8{1'b0}};
  end else begin
  if ((p1_rd_en_w) == 1'b1) begin
    dc2sbuf_p1_rd_addr <= p1_rd_addr_w;
  // VCS coverage off
  end else if ((p1_rd_en_w) == 1'b0) begin
  end else begin
    dc2sbuf_p1_rd_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_124x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(p1_rd_en_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  generate write signal to convertor                                //
////////////////////////////////////////////////////////////////////////

always @(
  layer_st
  or is_rsp_batch_end
  or idx_batch_offset
  or data_entries
  ) begin
    {mon_idx_batch_offset_w,
     idx_batch_offset_w} = (layer_st | is_rsp_batch_end) ? 13'b0 :
                           (idx_batch_offset + data_entries);
end

always @(
  layer_st
  or is_rsp_ch_end
  or idx_batch_offset_w
  or is_data_expand
  or rsp_ch_cnt
  or is_data_normal
  or is_data_shrink
  or idx_ch_offset
  or data_width
  ) begin
    {mon_idx_ch_offset_w,
     idx_ch_offset_w} = (layer_st) ? 13'b0 :
                        (is_rsp_ch_end) ? {1'b0, idx_batch_offset_w} :
                        ((is_data_expand & rsp_ch_cnt[0]) | (is_data_normal & rsp_ch_cnt[1]) | (is_data_shrink & rsp_ch_cnt[2])) ? idx_ch_offset + data_width[12 -1:0] :
                        idx_ch_offset;
end

always @(
  layer_st
  or is_rsp_h_end
  or idx_ch_offset_w
  or is_rsp_all_h_end
  or idx_h_offset
  or rsp_batch_entry_last
  or rsp_batch_entry_init
  ) begin
    {mon_idx_h_offset_w,
     idx_h_offset_w} = (layer_st) ? 13'b0 :
                       (is_rsp_h_end) ? {1'b0, idx_ch_offset_w} :
                       (is_rsp_all_h_end) ? idx_h_offset + rsp_batch_entry_last :
                        idx_h_offset + rsp_batch_entry_init;
end

always @(
  layer_st
  or idx_grain_offset
  or rsp_entry
  ) begin
    {mon_idx_grain_offset_w,
     idx_grain_offset_w} = (layer_st) ? 13'b0 :
                           idx_grain_offset + rsp_entry;
end

always @(
  is_hog
  or is_packed_1x1
  or is_data_shrink
  ) begin
    is_w_cnt_div8 = ((is_hog | is_packed_1x1) & is_data_shrink);
end

always @(
  is_hog
  or is_data_shrink
  or is_data_normal
  or is_rsp_ch_end
  or rsp_ch_cnt
  or rsp_cur_ch
  ) begin
    is_w_cnt_div4 = (is_hog & ~is_data_shrink)
                  | (~is_hog & is_data_normal & is_rsp_ch_end & ~rsp_ch_cnt[1] & (rsp_cur_ch == 3'h1))
                  | (~is_hog & is_data_shrink & is_rsp_ch_end & ~rsp_ch_cnt[2] & ((rsp_cur_ch == 3'h1) || (rsp_cur_ch == 3'h2)));
end

always @(
  is_hog
  or is_data_expand
  or is_rsp_ch_end
  or rsp_ch_cnt
  or rsp_cur_ch
  or is_data_normal
  or is_data_shrink
  ) begin
    is_w_cnt_div2 = (~is_hog & is_data_expand & is_rsp_ch_end & ~rsp_ch_cnt[0] & (rsp_cur_ch == 3'h1))
                  | (~is_hog & is_data_normal & is_rsp_ch_end & ~rsp_ch_cnt[1] & (rsp_cur_ch == 3'h2))
                  | (~is_hog & is_data_shrink & is_rsp_ch_end & ~rsp_ch_cnt[2] & ((rsp_cur_ch == 3'h3) || (rsp_cur_ch == 3'h4)));
end

always @(
  is_w_cnt_div8
  or rsp_w_cnt
  or is_w_cnt_div4
  or is_w_cnt_div2
  ) begin
    idx_w_offset_add = is_w_cnt_div8 ? rsp_w_cnt[12 +2:3] :
                       is_w_cnt_div4 ? rsp_w_cnt[12 +1:2] :
                       is_w_cnt_div2 ? rsp_w_cnt[12 :1] :
                       rsp_w_cnt[12 -1:0];
end

always @(
  idx_base
  or idx_grain_offset
  or idx_h_offset
  or idx_w_offset_add
  ) begin
    {mon_cbuf_idx_inc,
     cbuf_idx_inc} = idx_base + idx_grain_offset + idx_h_offset + idx_w_offset_add;
end

always @(
  cbuf_idx_inc
  or data_bank
  ) begin
    is_cbuf_idx_wrap = cbuf_idx_inc >= {1'b0, data_bank, 8'b0};
end

always @(
  is_cbuf_idx_wrap
  or cbuf_idx_inc
  or data_bank
  ) begin
    {mon_cbuf_idx_w[1:0],
     cbuf_idx_w} = ~is_cbuf_idx_wrap ? {2'b0, cbuf_idx_inc[12 -1:0]} :
                   cbuf_idx_inc[12 :0] - {data_bank, 8'b0};
end

always @(
  is_w_cnt_div8
  or rsp_w_cnt
  or is_w_cnt_div4
  or is_w_cnt_div2
  or is_data_shrink
  or rsp_ch_cnt
  or is_data_normal
  or is_data_expand
  ) begin
    cbuf_wr_hsel_w = (is_w_cnt_div8 & rsp_w_cnt[2]) | (is_w_cnt_div4 & rsp_w_cnt[1]) | (is_w_cnt_div2 & rsp_w_cnt[0])
                   | (is_data_shrink & rsp_ch_cnt[2]) | (is_data_normal & rsp_ch_cnt[1]) | (is_data_expand & rsp_ch_cnt[0]);
end

always @(
  is_hog
  or is_data_shrink
  or is_rsp_ch_end
  or rsp_ch_cnt
  or rsp_cur_ch
  ) begin
    cbuf_wr_interleave_w = (~is_hog & is_data_shrink & is_rsp_ch_end & ~rsp_ch_cnt[2] & (rsp_cur_ch == 3'h1));
end

always @(
  is_hog
  or is_data_normal
  or is_rsp_ch_end
  or rsp_ch_cnt
  or rsp_cur_ch
  or is_data_shrink
  or is_rsp_w_end
  or cbuf_wr_hsel_w
  ) begin
    cbuf_wr_ext64_w = (~is_hog & is_data_normal & is_rsp_ch_end & rsp_ch_cnt[1] & (rsp_cur_ch == 3'h1))
                    | (~is_hog & is_data_shrink & is_rsp_ch_end & rsp_ch_cnt[2] & ((rsp_cur_ch == 3'h1) | (rsp_cur_ch == 3'h2)))
                    | (is_rsp_w_end & is_rsp_ch_end & cbuf_wr_hsel_w);
end

always @(
  is_data_expand
  or is_rsp_w_end
  or is_rsp_ch_end
  or cbuf_wr_hsel_w
  ) begin
    cbuf_wr_ext128_w = is_data_expand
                     | (is_rsp_w_end & is_rsp_ch_end & ~cbuf_wr_hsel_w);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    idx_base <= {12{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    idx_base <= status2dma_wr_idx;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    idx_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_125x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    idx_batch_offset <= {12{1'b0}};
  end else begin
  if ((layer_st | rsp_batch_reg_en) == 1'b1) begin
    idx_batch_offset <= idx_batch_offset_w;
  // VCS coverage off
  end else if ((layer_st | rsp_batch_reg_en) == 1'b0) begin
  end else begin
    idx_batch_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_126x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_batch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    idx_ch_offset <= {12{1'b0}};
  end else begin
  if ((layer_st | rsp_ch_reg_en) == 1'b1) begin
    idx_ch_offset <= idx_ch_offset_w;
  // VCS coverage off
  end else if ((layer_st | rsp_ch_reg_en) == 1'b0) begin
  end else begin
    idx_ch_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_127x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_ch_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    idx_h_offset <= {12{1'b0}};
  end else begin
  if ((layer_st | rsp_h_reg_en) == 1'b1) begin
    idx_h_offset <= idx_h_offset_w;
  // VCS coverage off
  end else if ((layer_st | rsp_h_reg_en) == 1'b0) begin
  end else begin
    idx_h_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_128x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_h_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    idx_grain_offset <= {12{1'b0}};
  end else begin
  if ((layer_st | rsp_all_h_reg_en) == 1'b1) begin
    idx_grain_offset <= idx_grain_offset_w;
  // VCS coverage off
  end else if ((layer_st | rsp_all_h_reg_en) == 1'b0) begin
  end else begin
    idx_grain_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_129x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | rsp_all_h_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    cbuf_wr_en <= 1'b0;
  end else begin
  cbuf_wr_en <= rsp_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cbuf_wr_addr <= {12{1'b0}};
  end else begin
  if ((rsp_w_reg_en) == 1'b1) begin
    cbuf_wr_addr <= cbuf_idx_w;
  // VCS coverage off
  end else if ((rsp_w_reg_en) == 1'b0) begin
  end else begin
    cbuf_wr_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_130x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_w_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    cbuf_wr_hsel <= 1'b0;
  end else begin
  if ((rsp_w_reg_en) == 1'b1) begin
    cbuf_wr_hsel <= cbuf_wr_hsel_w;
  // VCS coverage off
  end else if ((rsp_w_reg_en) == 1'b0) begin
  end else begin
    cbuf_wr_hsel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_131x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_w_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    cbuf_wr_info_mask <= {4{1'b0}};
  end else begin
  cbuf_wr_info_mask <= {2'b0, p1_rd_en_w, p0_rd_en_w};
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cbuf_wr_info_interleave <= 1'b0;
  end else begin
  if ((rsp_w_reg_en) == 1'b1) begin
    cbuf_wr_info_interleave <= cbuf_wr_interleave_w;
  // VCS coverage off
  end else if ((rsp_w_reg_en) == 1'b0) begin
  end else begin
    cbuf_wr_info_interleave <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_132x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_w_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    cbuf_wr_info_ext64 <= 1'b0;
  end else begin
  if ((rsp_w_reg_en) == 1'b1) begin
    cbuf_wr_info_ext64 <= cbuf_wr_ext64_w;
  // VCS coverage off
  end else if ((rsp_w_reg_en) == 1'b0) begin
  end else begin
    cbuf_wr_info_ext64 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_133x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_w_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    cbuf_wr_info_ext128 <= 1'b0;
  end else begin
  if ((rsp_w_reg_en) == 1'b1) begin
    cbuf_wr_info_ext128 <= cbuf_wr_ext128_w;
  // VCS coverage off
  end else if ((rsp_w_reg_en) == 1'b0) begin
  end else begin
    cbuf_wr_info_ext128 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_134x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_w_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
assign cbuf_wr_info_mean = 1'b0;
assign cbuf_wr_info_uint = 1'b0;
assign cbuf_wr_info_sub_h = 3'b0;


// PKT_PACK_WIRE( nvdla_ram_info ,  cbuf_wr_info_ ,  cbuf_wr_info_pd )
assign       cbuf_wr_info_pd[3:0] =     cbuf_wr_info_mask[3:0];
assign       cbuf_wr_info_pd[4] =     cbuf_wr_info_interleave ;
assign       cbuf_wr_info_pd[5] =     cbuf_wr_info_ext64 ;
assign       cbuf_wr_info_pd[6] =     cbuf_wr_info_ext128 ;
assign       cbuf_wr_info_pd[7] =     cbuf_wr_info_mean ;
assign       cbuf_wr_info_pd[8] =     cbuf_wr_info_uint ;
assign       cbuf_wr_info_pd[11:9] =     cbuf_wr_info_sub_h[2:0];

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! idx_batch_offset_w is overflow!")      zzz_assert_never_135x (nvdla_core_clk, `ASSERT_RESET, (rsp_batch_reg_en & mon_idx_batch_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! idx_ch_offset_w is overflow!")      zzz_assert_never_136x (nvdla_core_clk, `ASSERT_RESET, (rsp_ch_reg_en & mon_idx_ch_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! idx_h_offset_w is overflow!")      zzz_assert_never_137x (nvdla_core_clk, `ASSERT_RESET, (rsp_h_reg_en & mon_idx_h_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! cbuf_idx_inc is overflow!")      zzz_assert_never_138x (nvdla_core_clk, `ASSERT_RESET, (rsp_w_reg_en & mon_cbuf_idx_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! cbuf_idx_w is overflow!")      zzz_assert_never_139x (nvdla_core_clk, `ASSERT_RESET, (rsp_w_reg_en & (|mon_cbuf_idx_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_zero_one_hot #(0,3,0,"Error! conflict div mode")      zzz_assert_zero_one_hot_140x (nvdla_core_clk, `ASSERT_RESET, ({is_w_cnt_div8, is_w_cnt_div4, is_w_cnt_div2})); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  pipeline to sync the sbuf read to output to convertor             //
////////////////////////////////////////////////////////////////////////

assign cbuf_wr_en_d0      = cbuf_wr_en;
assign cbuf_wr_addr_d0    = cbuf_wr_addr;
assign cbuf_wr_hsel_d0    = cbuf_wr_hsel;
assign cbuf_wr_info_pd_d0 = cbuf_wr_info_pd;


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cbuf_wr_en_d1 <= 1'b0;
  end else begin
  cbuf_wr_en_d1 <= cbuf_wr_en_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cbuf_wr_addr_d1 <= {12{1'b0}};
  end else begin
  if ((cbuf_wr_en_d0) == 1'b1) begin
    cbuf_wr_addr_d1 <= cbuf_wr_addr_d0;
  // VCS coverage off
  end else if ((cbuf_wr_en_d0) == 1'b0) begin
  end else begin
    cbuf_wr_addr_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_141x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_wr_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    cbuf_wr_hsel_d1 <= 1'b0;
  end else begin
  if ((cbuf_wr_en_d0) == 1'b1) begin
    cbuf_wr_hsel_d1 <= cbuf_wr_hsel_d0;
  // VCS coverage off
  end else if ((cbuf_wr_en_d0) == 1'b0) begin
  end else begin
    cbuf_wr_hsel_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_142x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_wr_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    cbuf_wr_info_pd_d1 <= {12{1'b0}};
  end else begin
  if ((cbuf_wr_en_d0) == 1'b1) begin
    cbuf_wr_info_pd_d1 <= cbuf_wr_info_pd_d0;
  // VCS coverage off
  end else if ((cbuf_wr_en_d0) == 1'b0) begin
  end else begin
    cbuf_wr_info_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_143x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_wr_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    cbuf_wr_en_d2 <= 1'b0;
  end else begin
  cbuf_wr_en_d2 <= cbuf_wr_en_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cbuf_wr_addr_d2 <= {12{1'b0}};
  end else begin
  if ((cbuf_wr_en_d1) == 1'b1) begin
    cbuf_wr_addr_d2 <= cbuf_wr_addr_d1;
  // VCS coverage off
  end else if ((cbuf_wr_en_d1) == 1'b0) begin
  end else begin
    cbuf_wr_addr_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_144x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_wr_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    cbuf_wr_hsel_d2 <= 1'b0;
  end else begin
  if ((cbuf_wr_en_d1) == 1'b1) begin
    cbuf_wr_hsel_d2 <= cbuf_wr_hsel_d1;
  // VCS coverage off
  end else if ((cbuf_wr_en_d1) == 1'b0) begin
  end else begin
    cbuf_wr_hsel_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_145x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_wr_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    cbuf_wr_info_pd_d2 <= {12{1'b0}};
  end else begin
  if ((cbuf_wr_en_d1) == 1'b1) begin
    cbuf_wr_info_pd_d2 <= cbuf_wr_info_pd_d1;
  // VCS coverage off
  end else if ((cbuf_wr_en_d1) == 1'b0) begin
  end else begin
    cbuf_wr_info_pd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_146x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_wr_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    cbuf_wr_en_d3 <= 1'b0;
  end else begin
  cbuf_wr_en_d3 <= cbuf_wr_en_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cbuf_wr_addr_d3 <= {12{1'b0}};
  end else begin
  if ((cbuf_wr_en_d2) == 1'b1) begin
    cbuf_wr_addr_d3 <= cbuf_wr_addr_d2;
  // VCS coverage off
  end else if ((cbuf_wr_en_d2) == 1'b0) begin
  end else begin
    cbuf_wr_addr_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_147x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_wr_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    cbuf_wr_hsel_d3 <= 1'b0;
  end else begin
  if ((cbuf_wr_en_d2) == 1'b1) begin
    cbuf_wr_hsel_d3 <= cbuf_wr_hsel_d2;
  // VCS coverage off
  end else if ((cbuf_wr_en_d2) == 1'b0) begin
  end else begin
    cbuf_wr_hsel_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_148x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_wr_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    cbuf_wr_info_pd_d3 <= {12{1'b0}};
  end else begin
  if ((cbuf_wr_en_d2) == 1'b1) begin
    cbuf_wr_info_pd_d3 <= cbuf_wr_info_pd_d2;
  // VCS coverage off
  end else if ((cbuf_wr_en_d2) == 1'b0) begin
  end else begin
    cbuf_wr_info_pd_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_149x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_wr_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  if ((cbuf_wr_en_d2) == 1'b1) begin
    cbuf_wr_data_d3 <= {dc2sbuf_p1_rd_data, dc2sbuf_p0_rd_data};
  // VCS coverage off
  end else if ((cbuf_wr_en_d2) == 1'b0) begin
  end else begin
    cbuf_wr_data_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


assign dc2cvt_dat_wr_en      = cbuf_wr_en_d3;
assign dc2cvt_dat_wr_addr    = cbuf_wr_addr_d3;
assign dc2cvt_dat_wr_hsel    = cbuf_wr_hsel_d3;
assign dc2cvt_dat_wr_info_pd = cbuf_wr_info_pd_d3;
assign dc2cvt_dat_wr_data    = cbuf_wr_data_d3;


////////////////////////////////////////////////////////////////////////
//  convolution buffer slices & entries management                    //
////////////////////////////////////////////////////////////////////////
///////////// calculate onfly slices and entries /////////////

always @(
  req_csm_sel
  or req_entry_1_d3
  or req_entry_0_d3
  ) begin
    req_entry = req_csm_sel ? req_entry_1_d3 : req_entry_0_d3;
end

always @(
  req_grain_reg_en
  or req_entry
  ) begin
    dc_entry_onfly_add = ~req_grain_reg_en ? 12'b0 :
                         req_entry;
end

always @(
  is_rsp_all_h_end
  or rsp_entry_last
  or rsp_entry_init
  ) begin
    rsp_entry = is_rsp_all_h_end ? rsp_entry_last : rsp_entry_init;
end

always @(
  dc2status_dat_updt
  or dc2status_dat_entries
  ) begin
    dc_entry_onfly_sub = ~dc2status_dat_updt ? 12'b0 :
                         dc2status_dat_entries;
end

always @(
  dc_entry_onfly
  or dc_entry_onfly_add
  or dc_entry_onfly_sub
  ) begin
    {mon_dc_entry_onfly_w,
     dc_entry_onfly_w} = dc_entry_onfly + dc_entry_onfly_add - dc_entry_onfly_sub;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dc_entry_onfly <= {12{1'b0}};
  end else begin
  if ((req_grain_reg_en | dc2status_dat_updt) == 1'b1) begin
    dc_entry_onfly <= dc_entry_onfly_w;
  // VCS coverage off
  end else if ((req_grain_reg_en | dc2status_dat_updt) == 1'b0) begin
  end else begin
    dc_entry_onfly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_150x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_grain_reg_en | dc2status_dat_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! dc_entry_onfly_w is overflow")      zzz_assert_never_151x (nvdla_core_clk, `ASSERT_RESET, (mon_dc_entry_onfly_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! dc_entry_onfly_w is out of range")      zzz_assert_never_152x (nvdla_core_clk, `ASSERT_RESET, (dc_entry_onfly_w > 3840)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! dc_entry_onfly_w is non zero when idle")      zzz_assert_never_153x (nvdla_core_clk, `ASSERT_RESET, (~is_running & |(dc_entry_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// calculate if free entries is enough /////////////

always @(
  dc_entry_onfly
  or req_entry
  ) begin
    required_entries = dc_entry_onfly + req_entry;
end

always @(
  required_entries
  or status2dma_free_entries
  ) begin
    is_free_entries_enough = (required_entries <= {1'b0, status2dma_free_entries});
end

always @(
  is_running
  or req_pre_valid
  or csm_reg_en
  or is_free_entries_enough
  ) begin
    cbuf_is_ready_w = (~is_running | ~req_pre_valid | csm_reg_en) ? 1'b0 :
                      is_free_entries_enough;
end

always @(
  is_rsp_all_h_end
  or rsp_slice_last
  or rsp_slice_init
  ) begin
    rsp_slice = is_rsp_all_h_end ? rsp_slice_last : rsp_slice_init;
end

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
    dat_entries_d0 <= {12{1'b0}};
  end else begin
  if ((rsp_all_h_reg_en) == 1'b1) begin
    dat_entries_d0 <= rsp_entry;
  // VCS coverage off
  end else if ((rsp_all_h_reg_en) == 1'b0) begin
  end else begin
    dat_entries_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_154x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_all_h_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    dat_slices_d0 <= {12{1'b0}};
  end else begin
  if ((rsp_all_h_reg_en) == 1'b1) begin
    dat_slices_d0 <= rsp_slice;
  // VCS coverage off
  end else if ((rsp_all_h_reg_en) == 1'b0) begin
  end else begin
    dat_slices_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_155x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_all_h_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    dat_updt_d1 <= 1'b0;
  end else begin
  dat_updt_d1 <= dat_updt_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_entries_d1 <= {12{1'b0}};
  end else begin
  if ((dat_updt_d0) == 1'b1) begin
    dat_entries_d1 <= dat_entries_d0;
  // VCS coverage off
  end else if ((dat_updt_d0) == 1'b0) begin
  end else begin
    dat_entries_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_156x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    dat_slices_d1 <= {12{1'b0}};
  end else begin
  if ((dat_updt_d0) == 1'b1) begin
    dat_slices_d1 <= dat_slices_d0;
  // VCS coverage off
  end else if ((dat_updt_d0) == 1'b0) begin
  end else begin
    dat_slices_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_157x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    dat_updt_d2 <= 1'b0;
  end else begin
  dat_updt_d2 <= dat_updt_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_entries_d2 <= {12{1'b0}};
  end else begin
  if ((dat_updt_d1) == 1'b1) begin
    dat_entries_d2 <= dat_entries_d1;
  // VCS coverage off
  end else if ((dat_updt_d1) == 1'b0) begin
  end else begin
    dat_entries_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_158x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    dat_slices_d2 <= {12{1'b0}};
  end else begin
  if ((dat_updt_d1) == 1'b1) begin
    dat_slices_d2 <= dat_slices_d1;
  // VCS coverage off
  end else if ((dat_updt_d1) == 1'b0) begin
  end else begin
    dat_slices_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_159x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    dat_updt_d3 <= 1'b0;
  end else begin
  dat_updt_d3 <= dat_updt_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_entries_d3 <= {12{1'b0}};
  end else begin
  if ((dat_updt_d2) == 1'b1) begin
    dat_entries_d3 <= dat_entries_d2;
  // VCS coverage off
  end else if ((dat_updt_d2) == 1'b0) begin
  end else begin
    dat_entries_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_160x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    dat_slices_d3 <= {12{1'b0}};
  end else begin
  if ((dat_updt_d2) == 1'b1) begin
    dat_slices_d3 <= dat_slices_d2;
  // VCS coverage off
  end else if ((dat_updt_d2) == 1'b0) begin
  end else begin
    dat_slices_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_161x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign dc2status_dat_updt = dat_updt_d3;
assign dc2status_dat_entries = dat_entries_d3;
assign dc2status_dat_slices = dat_slices_d3;




`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Update to status when idle!")      zzz_assert_never_162x (nvdla_core_clk, `ASSERT_RESET, (dc2status_dat_updt & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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

    always @(
      dc_rd_stall_inc
      or dp2reg_dc_rd_stall_dec
      ) begin
      stl_adv = dc_rd_stall_inc ^ dp2reg_dc_rd_stall_dec;
    end
        
    // stl cnt logic
    always @(
      stl_cnt_cur
      or dc_rd_stall_inc
      or dp2reg_dc_rd_stall_dec
      or stl_adv
      or dc_rd_stall_clr
      ) begin
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

    always @(
      stl_cnt_cur
      ) begin
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




    // 
    assign ltc_1_inc = (outs_dp2reg_dc_rd_latency!=511) & dc_rd_latency_inc;
    assign ltc_1_dec = (outs_dp2reg_dc_rd_latency!=511) & dc_rd_latency_dec;

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
      or dc_rd_latency_clr
      ) begin
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

    always @(
      ltc_1_cnt_cur
      ) begin
      outs_dp2reg_dc_rd_latency[8:0] = ltc_1_cnt_cur[8:0];
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
      nv_assert_never #(0,0,"never: counter overflow beyond <ovr_cnt>")      zzz_assert_never_163x (nvdla_core_clk, `ASSERT_RESET, (ltc_1_cnt_nxt > 511 && dc_rd_latency_cen)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

      
    //assign dp2reg_dc_rd_latency_sub = 1'b0;
    assign ltc_2_dec = 1'b0;
    assign ltc_2_inc = (~&dp2reg_dc_rd_latency) & (|outs_dp2reg_dc_rd_latency);

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
      or dc_rd_latency_clr
      ) begin
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

    always @(
      ltc_2_cnt_cur
      ) begin
      dp2reg_dc_rd_latency[31:0] = ltc_2_cnt_cur[31:0];
    end
        
      

// ////////////////////////////////////////////////////////////////////////
// //  OBS connection                                                    //
// ////////////////////////////////////////////////////////////////////////
// assign obs_bus_cdma_dc_dma_rd_req_vld      = dma_rd_req_vld;
// assign obs_bus_cdma_dc_dma_rd_req_rdy      = dma_rd_req_rdy;
// assign obs_bus_cdma_dc_dma_req_fifo_req    = dma_req_fifo_req;
// assign obs_bus_cdma_dc_dma_req_fifo_ready  = dma_req_fifo_ready;
// assign obs_bus_cdma_dc_req_size_out_d1     = req_size_out_d1;
// assign obs_bus_cdma_dc_req_addr_d1_lo      = req_addr_d1[15:0];
// assign obs_bus_cdma_dc_dma_rd_rsp_vld      = dma_rd_rsp_vld;
// assign obs_bus_cdma_dc_dma_rd_rsp_rdy      = dma_rd_rsp_rdy;
// assign obs_bus_cdma_dc_dma_rd_rsp_mask     = dma_rd_rsp_mask;
// assign obs_bus_cdma_dc_dma_rsp_fifo_req    = dma_rsp_fifo_req;
// assign obs_bus_cdma_dc_dma_rsp_fifo_ready  = dma_rsp_fifo_ready;
// assign obs_bus_cdma_dc_fetch_done          = fetch_done;
// assign obs_bus_cdma_dc_is_rsp_done         = is_rsp_done;
// assign obs_bus_cdma_dc_cur_state           = cur_state;
// assign obs_bus_cdma_dc_nxt_state           = nxt_state;
// assign obs_bus_cdma_dc2cvt_dat_wr_en       = dc2cvt_dat_wr_en;
// assign obs_bus_cdma_dc2cvt_dat_wr_addr     = dc2cvt_dat_wr_addr;
// assign obs_bus_cdma_dc2cvt_dat_wr_hsel     = dc2cvt_dat_wr_hsel;
// assign obs_bus_cdma_dc2cvt_dat_wr_info_pd  = dc2cvt_dat_wr_info_pd;
// assign obs_bus_cdma_dc2status_dat_updt     = dc2status_dat_updt;

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           {is_req_grain_last_d1,pre_valid_d1}
//                           {pre_gen_sel,req_csm_sel}
//                           req_cur_ch[1:0]
//                           req_atm_sel
//                           dma_rsp_size_cnt[1:0]
//                           rsp_all_h_cnt[1:0]
//                           {rsp_rd_ch2ch3,is_blocking}
//                           {cbuf_wr_en,cbuf_wr_hsel};

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


endmodule // NV_NVDLA_CDMA_dc



// **************************************************************************************************************
// Generated by ::pipe -m -bc -is mc_int_rd_req_pd (mc_int_rd_req_valid,mc_int_rd_req_ready) <= dma_rd_req_pd[78:0] (mc_dma_rd_req_vld,mc_dma_rd_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_CDMA_DC_pipe_p1 (
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
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_164x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_int_rd_req_valid^mc_int_rd_req_ready^mc_dma_rd_req_vld^mc_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_165x (nvdla_core_clk, `ASSERT_RESET, (mc_dma_rd_req_vld && !mc_dma_rd_req_rdy), (mc_dma_rd_req_vld), (mc_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDMA_DC_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is cv_int_rd_req_pd (cv_int_rd_req_valid,cv_int_rd_req_ready) <= dma_rd_req_pd[78:0] (cv_dma_rd_req_vld,cv_dma_rd_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_CDMA_DC_pipe_p2 (
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
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_166x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_int_rd_req_valid^cv_int_rd_req_ready^cv_dma_rd_req_vld^cv_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_167x (nvdla_core_clk, `ASSERT_RESET, (cv_dma_rd_req_vld && !cv_dma_rd_req_rdy), (cv_dma_rd_req_vld), (cv_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDMA_DC_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os mc_dma_rd_rsp_pd (mc_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= mc_int_rd_rsp_pd[513:0] (mc_int_rd_rsp_valid,mc_int_rd_rsp_ready)
// **************************************************************************************************************
module NV_NVDLA_CDMA_DC_pipe_p3 (
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
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_probability" ) ) p3_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_min"  ) ) p3_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_max"  ) ) p3_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_168x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_dma_rd_rsp_vld^dma_rd_rsp_rdy^mc_int_rd_rsp_valid^mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_169x (nvdla_core_clk, `ASSERT_RESET, (mc_int_rd_rsp_valid && !mc_int_rd_rsp_ready), (mc_int_rd_rsp_valid), (mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDMA_DC_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os cv_dma_rd_rsp_pd (cv_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= cv_int_rd_rsp_pd[513:0] (cv_int_rd_rsp_valid,cv_int_rd_rsp_ready)
// **************************************************************************************************************
module NV_NVDLA_CDMA_DC_pipe_p4 (
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
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_probability" ) ) p4_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_min"  ) ) p4_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_dc_pipe_stall_cycles_max"  ) ) p4_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_170x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_dma_rd_rsp_vld^dma_rd_rsp_rdy^cv_int_rd_rsp_valid^cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_171x (nvdla_core_clk, `ASSERT_RESET, (cv_int_rd_rsp_valid && !cv_int_rd_rsp_ready), (cv_int_rd_rsp_valid), (cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDMA_DC_pipe_p4



